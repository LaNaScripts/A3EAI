
private ["_unitGroup","_trigger","_grpArray","_patrolDist","_spawnPositions","_spawnPos","_unit","_pos","_startTime","_maxUnits","_totalAI","_aiGroup","_unitLevel","_unitLevelEffective", "_checkPos"];

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
_checkPos = false;
if ((_trigger getVariable ["spawnChance",1]) call A3EAI_chance) then {
	_totalAI = ((_maxUnits select 0) + round(random (_maxUnits select 1)));
	if ((count _spawnPositions) > 0) then {
		_spawnPos = _spawnPositions call A3EAI_findSpawnPos;
	} else {
	
		_checkPos = true;
		_attempts = 0;
		_continue = true;
		_addDist = 0;

		while {_continue && {(_attempts < 3)}} do {
			_spawnPosSelected = [(ASLtoATL getPosASL _trigger),random ((_patrolDist + _addDist) min 200),random(360),0] call SHK_pos;
			if ((count _spawnPosSelected) isEqualTo 2) then {_spawnPosSelected set [2,0];};
			if (
				(_spawnPosSelected call A3EAI_posNotInBuilding) && 
				{({if ((isPlayer _x) && {([eyePos _x,[(_spawnPosSelected select 0),(_spawnPosSelected select 1),(_spawnPosSelected select 2) + 1.7],_x] call A3EAI_hasLOS) or ((_x distance _spawnPosSelected) < 30)}) exitWith {1}} count (_spawnPosSelected nearEntities [["Epoch_Male_F","Epoch_Female_F","Car"],200])) isEqualTo 0}
			) then {
				_spawnPos = _spawnPosSelected;
				_continue = false;
			} else {
				_attempts = _attempts + 1;
				_addDist = _addDist + 50;
				if (A3EAI_debugLevel > 0) then {diag_log format ["A3EAI Debug: Unable to find suitable spawn position. (attempt %1/3).",_attempts];};
			};
		};
	};
};

if ((_totalAI isEqualTo 0) or {_spawnPos isEqualTo []}) exitWith {
	[0,_trigger,_unitGroup,true] call A3EAI_addRespawnQueue;
	false
};

//Respawn the group
_aiGroup = [_totalAI,_unitGroup,_spawnPos,_trigger,_unitLevelEffective,_checkPos] call A3EAI_spawnGroup;
if (isNull _unitGroup) then {diag_log format ["A3EAI Error: Respawned group at %1 was null group. New group reassigned: %2.",triggerText _trigger,_aiGroup]; _unitGroup = _aiGroup};
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
