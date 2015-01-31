/*
	spawnBandits_custom
	
	Usage: 
	
	Description: A3EAI custom spawn function (A3EAI_spawn).
	
	Last updated: 6:00 PM 10/24/2013
*/

private ["_patrolDist","_trigger","_grpArray","_triggerPos","_unitLevel","_unitLevel","_totalAI","_startTime","_tMarker","_unitGroup","_spawnPos","_totalAI"];


_startTime = diag_tickTime;

_totalAI = _this select 0;									
//_this select 1;
_patrolDist = _this select 2;								
_trigger = _this select 3;									
_unitLevel = _this select 4;
//_spawnMarker = _this select 5;

//_nul = +(list _trigger) call A3EAI_allowDamageFix;
_grpArray = _trigger getVariable ["GroupArray",[]];	
if (count _grpArray > 0) exitWith {if (A3EAI_debugLevel > 0) then {diag_log format ["A3EAI Debug: Active groups found at %1. Exiting spawn script (spawnBandits)",(triggerText _trigger)];};};						

_trigger setTriggerArea [750,750,0,false];
_triggerPos = ASLtoATL getPosASL _trigger;

if (A3EAI_debugLevel > 0) then {diag_log format["A3EAI Debug: Processed static trigger spawn data in %1 seconds (Custom Spawn).",(diag_tickTime - _startTime)];};

_startTime = diag_tickTime;

if !(_trigger getVariable ["respawn",true]) then {
	_maxUnits = _trigger getVariable ["maxUnits",[0,0]];
	_totalAINew = (_maxUnits select 0);
	if (_totalAINew > 0) then {_totalAI = _totalAINew};	//Retrieve AI amount if it was updated from initial value (for non-respawning custom spawns only)
};
_spawnPos = [(ASLtoATL getPosASL _trigger),random (_patrolDist),random(360),0] call SHK_pos;
_unitGroup = [_totalAI,grpNull,_spawnPos,_trigger,_unitLevel,true] call A3EAI_spawnGroup;

//Set group variables
_unitGroup setVariable ["unitType","static"];

if (A3EAI_debugLevel > 1) then {diag_log format ["A3EAI Extended Debug: Group %1 has group size %2.",_unitGroup,_totalAI];};

if (_patrolDist > 1) then {
	0 = [_unitGroup,_triggerPos,_patrolDist] spawn A3EAI_BIN_taskPatrol;
} else {
	[_unitGroup, 0] setWaypointType "HOLD";
};

if (A3EAI_debugLevel > 0) then {diag_log format["A3EAI Debug: Spawned a group of %1 units in %2 seconds at %3 (Custom Spawn).",_totalAI,(diag_tickTime - _startTime),(triggerText _trigger)];};

_unitLevel = if !(_unitLevel in A3EAI_unitLevels) then {_unitLevel min 3};
//_grpArray set [count _grpArray,_unitGroup];
_grpArray pushBack _unitGroup;

_triggerStatements = (triggerStatements _trigger);
if (!(_trigger getVariable ["initialized",false])) then {
	0 = [0,_trigger,_grpArray,_patrolDist,_unitLevel,[],[_totalAI,0]] call A3EAI_initializeTrigger;
	_trigger setVariable ["triggerStatements",+_triggerStatements];
} else {
	_trigger setVariable ["isCleaning",false];
	_trigger setVariable ["maxUnits",[_totalAI,0]];
	if (A3EAI_debugLevel > 1) then {diag_log format ["A3EAI Extended Debug: Trigger group array updated to: %1.",_grpArray]};
};
_triggerStatements set [1,""];
//_triggerStatements set [1,"_nul = thisList call A3EAI_allowDamageFix;"];
_trigger setTriggerStatements _triggerStatements;
[_trigger,"A3EAI_staticTriggerArray"] call A3EAI_updateSpawnCount;

if ((!isNil "A3EAI_debugMarkersEnabled") && {A3EAI_debugMarkersEnabled}) then {
	_nul = _trigger call A3EAI_addMapMarker;
};

_unitGroup
