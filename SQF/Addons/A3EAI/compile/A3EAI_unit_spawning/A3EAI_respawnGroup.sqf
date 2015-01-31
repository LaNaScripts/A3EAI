/*
	respawnBandits
	
	Usage: [_unitGroup,_trigger,_maxUnits] call respawnBandits;
	
	Description: Called internally by fnc_banditAIRespawn. Calls fnc_createAI to respawn a unit near a randomly selected building from a stored reference location.
	
	Last updated: 8:38 AM 10/23/2013
*/

private ["_unitGroup","_trigger","_grpArray","_patrolDist","_spawnPositions","_spawnPos","_unit","_pos","_startTime","_maxUnits","_totalAI","_aiGroup","_unitLevel","_unitLevelEffective"];


_startTime = diag_tickTime;

_unitGroup = _this select 0;
_trigger = _this select 1;
_maxUnits = _this select 2;

_patrolDist = _trigger getVariable ["patrolDist",150];
_unitLevel = _trigger getVariable ["unitLevel",1];
_unitLevelEffective = _trigger getVariable ["unitLevelEffective",1];
_spawnPositions = _trigger getVariable ["locationArray",[]];

_totalAI = 0;
_spawnPos = [];
if ((_trigger getVariable ["spawnChance",1]) call A3EAI_chance) then {
	_totalAI = ((_maxUnits select 0) + round(random (_maxUnits select 1)));
	_spawnPos = if ((count _spawnPositions) > 0) then {_spawnPositions call A3EAI_findSpawnPos} else {[(ASLtoATL getPosASL _trigger),random (_patrolDist),random(360),0] call SHK_pos};
	//diag_log format ["DEBUG :: _spawnPos: %1. _spawnPositions: %2. _trigger: %3. _patrolDist: %4.",_spawnPos,(count _spawnPositions),_trigger,_patrolDist];
};

if ((_totalAI isEqualTo 0) or {((count _spawnPos) isEqualTo 0)}) exitWith {
	[0,_trigger,_unitGroup] call A3EAI_addRespawnQueue;
	false
};

//Respawn the group
_aiGroup = [_totalAI,_unitGroup,_spawnPos,_trigger,_unitLevelEffective] call A3EAI_spawnGroup;
if (isNull _unitGroup) then {diag_log format ["A3EAI Error :: Respawned group at %1 was null group. New group reassigned: %2.",triggerText _trigger,_aiGroup]; _unitGroup = _aiGroup};
if (isNil {_unitGroup getVariable "unitType"}) then {_unitGroup setVariable ["unitType",_trigger getVariable ["spawnType","unknown"]]};
if (_unitLevel != _unitLevelEffective) then {_trigger setVariable ["unitLevelEffective",_unitLevel]}; //Reset unitLevel after respawning promoted group
if (_patrolDist > 1) then {
	if ((count (waypoints _unitGroup)) > 1) then {
		_unitGroup setCurrentWaypoint ((waypoints _unitGroup) call BIS_fnc_selectRandom2);
	} else {
		_nul = [_unitGroup,(ASLtoATL getPosASL _trigger),_patrolDist] spawn A3EAI_BIN_taskPatrol;
	};
} else {
	[_unitGroup, 0] setWaypointType "HOLD";
};

if ((!isNil "A3EAI_debugMarkersEnabled") && {A3EAI_debugMarkersEnabled}) then {
	_nul = _trigger call A3EAI_addMapMarker;
};

if (A3EAI_debugLevel > 0) then {diag_log format["A3EAI Debug: %1 AI units respawned for group %2 (unitLevel %3) at %4 in %5 seconds (respawnBandits).",_totalAI,_unitGroup,_unitLevelEffective,(triggerText _trigger),diag_tickTime - _startTime];};

true
