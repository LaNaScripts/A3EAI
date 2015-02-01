/*
	spawnBandits_dynamic

	Usage: Called by an activated dynamic trigger when a player unit enters the trigger area.
	
	Description: Spawns a group of AI units some distance from a dynamically-spawned trigger. These units do not respawn after death.
	
	Last updated: 10:58 PM 6/6/2014
*/

private ["_patrolDist","_trigger","_totalAI","_unitGroup","_targetPlayer","_playerPos","_playerDir","_spawnPos","_startTime","_baseDist","_distVariance","_dirVariance","_behavior","_triggerStatements","_spawnDist","_triggerLocation"];


_startTime = diag_tickTime;

_patrolDist = _this select 0;
_trigger = _this select 1;
_minAI = _this select 2;
_addAI = _this select 3;
_unitLevel = _this select 4;

_targetPlayer = _trigger getVariable ["targetplayer",objNull];
if (isNull _targetPlayer) exitWith {
	if (A3EAI_debugLevel > 1) then {diag_log format ["A3EAI Extended Debug: Cancelling dynamic spawn for target player. Reason: Player does not exist (logged out?).",name _targetPlayer]};
	_nul = _trigger call A3EAI_cancelDynamicSpawn;
	
	false
};

_baseDist = 200;		//On foot distance: 200-250
_distVariance = 50;
_dirVariance = 90;
if (!((vehicle _targetPlayer) isKindOf "Man")) then {
	_baseDist = _baseDist - 50;	//In vehicle distance: 150-225m
	_dirVariance = 67.5;
};

_playerPos = ASLtoATL getPosASL _targetPlayer;
_playerDir = getDir _targetPlayer;
_spawnDist = (_baseDist + random (_distVariance));
_spawnPos = [_playerPos,_spawnDist,[(_playerDir-_dirVariance),(_playerDir+_dirVariance)],0] call SHK_pos;
_triggerLocation = _trigger getVariable ["triggerLocation",locationNull];

if (
	(surfaceIsWater _spawnPos) or 
	{({if ((isPlayer _x) && {[eyePos _x,_spawnPos,_x] call A3EAI_hasLOS}) exitWith {1}} count ((_spawnPos nearEntities [["CAManBase","LandVehicle"],200]) - [_targetPlayer])) > 0} or 
	{({if (_spawnPos in _x) exitWith {1}} count ((nearestLocations [_spawnPos,["Strategic"],1000]) - [_triggerLocation])) > 0}
) exitWith {
	if (A3EAI_debugLevel > 1) then {
		diag_log format ["A3EAI Extended Debug: Canceling dynamic spawn for target player %1. Possible reasons: Spawn position has water, player nearby, or is blacklisted.",name _targetPlayer];
		diag_log format ["DEBUG: Position is water: %1",(surfaceIsWater _spawnPos)];
		diag_log format ["DEBUG: Player nearby: %1",({isPlayer _x} count ((_spawnPos nearEntities [["CAManBase","LandVehicle"],200]) - [_targetPlayer])) > 0];
		diag_log format ["DEBUG: Location is blacklisted: %1",({_spawnPos in _x} count ((nearestLocations [_spawnPos,["Strategic"],1000]) - [_triggerLocation])) > 0];
	};
	_nul = _trigger call A3EAI_cancelDynamicSpawn;
	
	false

};
_totalAI = (_minAI + round(random _addAI));
_unitGroup = [_totalAI,grpNull,_spawnPos,_trigger,_unitLevel,true] call A3EAI_spawnGroup;

//Set group variables
_unitGroup setVariable ["unitType","dynamic"];
_unitGroup setBehaviour "AWARE";
_unitGroup setSpeedMode "FULL";

//Begin hunting player or patrolling area
_behavior = if (A3EAI_huntingChance call A3EAI_chance) then {
	_unitGroup reveal [_targetPlayer,4];
	0 = [_unitGroup,_spawnPos,_patrolDist,_targetPlayer,ASLtoATL getPosASL _trigger] spawn A3EAI_dynamicHunting; //seek mode
	"HUNT PLAYER"
} else {
	[_unitGroup,_playerPos] call A3EAI_setFirstWPPos;
	0 = [_unitGroup,_playerPos,_patrolDist] spawn A3EAI_BIN_taskPatrol;
	"PATROL AREA"
};
if (A3EAI_debugLevel > 0) then {
	diag_log format["A3EAI Debug: Spawned 1 new AI groups of %1 units each in %2 seconds at %3 using behavior mode %4. Distance from target: %5 meters.",_totalAI,(diag_tickTime - _startTime),(mapGridPosition _trigger),_behavior,_spawnDist];
};

_triggerStatements = (triggerStatements _trigger);
if (!(_trigger getVariable ["initialized",false])) then {
	0 = [1,_trigger,[_unitGroup]] call A3EAI_initializeTrigger; //set dynamic trigger variables and create dynamic area blacklist
	_trigger setVariable ["triggerStatements",+_triggerStatements];
};
//_triggerStatements set [1,""];
_trigger setTriggerStatements _triggerStatements;
[_trigger,"A3EAI_dynTriggerArray"] call A3EAI_updateSpawnCount;

if ((!isNil "A3EAI_debugMarkersEnabled") && {A3EAI_debugMarkersEnabled}) then {
	_nul = _trigger spawn {
		_marker = str(_this);
		_marker setMarkerColor "ColorOrange";
		_marker setMarkerAlpha 0.9;				//Dark orange: Activated trigger
	};
};

true
