
private ["_patrolDist","_waypoint","_trigger","_totalAI","_minAI","_addAI","_unitLevel","_unitGroup","_targetPlayer","_playerPos","_playerDir","_spawnPos","_startTime","_baseDist","_extraDist","_distVariance","_dirVariance","_behavior","_triggerStatements","_spawnDist","_thisList","_debugMarkers"];


_startTime = diag_tickTime;

_patrolDist = _this select 0;
_trigger = _this select 1;
_thisList = _this select 2;
_minAI = _this select 3;
_addAI = _this select 4;
_unitLevel = _this select 5;

_checkArea = true;
_nearAttempts = 1;
_spawnPos = [0,0,0];
_debugMarkers = ((!isNil "A3EAI_debugMarkersEnabled") && {A3EAI_debugMarkersEnabled});
_baseDist = 0;
_extraDist = 300;
_playerPos = [0,0,0];

{
	if (isPlayer _x) exitWith {
		_playerPos = getPosASL _x;
		_triggerLocation = _trigger getVariable ["triggerLocation",locationNull];
		if ((({if (_playerPos in _x) exitWith {1}} count ((nearestLocations [_playerPos,["Strategic"],1500]) - [_triggerLocation])) isEqualTo 0) && {!(surfaceIsWater _playerPos)}) then {
			_trigger setPosASL _playerPos;
			_triggerLocation setPosition _playerPos;
			_baseDist = 200;
			_extraDist = 100;
			if (_debugMarkers) then {
				(str (_trigger)) setMarkerPos _playerPos;
			};
		};
	};
} forEach _thisList;

_triggerPos = getPosASL _trigger;

while {_checkArea && {_nearAttempts < 4}} do {
	_spawnPos = [_triggerPos,(_baseDist + (random _extraDist)),(random 360),0] call SHK_pos;
	_checkArea = (({if ((isPlayer _x) && {[eyePos _x,_spawnPos,_x] call A3EAI_hasLOS}) exitWith {1}} count (_spawnPos nearEntities [["CAManBase","LandVehicle"], 200]) > 0) or {surfaceIsWater _spawnPos});
	_nearAttempts = _nearAttempts + 1;
};

if (_nearAttempts > 3) exitWith {_nul = _trigger call A3EAI_cancelRandomSpawn};
_totalAI = (_minAI + round(random _addAI));
_unitGroup = [_totalAI,grpNull,_spawnPos,_trigger,_unitLevel,true] call A3EAI_spawnGroup;

//Set group variables
_unitGroup setVariable ["unitType","random"];
_unitGroup setBehaviour "AWARE";
_unitGroup setSpeedMode "FULL";

[_unitGroup,_playerPos] call A3EAI_setFirstWPPos;
0 = [_unitGroup,_triggerPos,_patrolDist] spawn A3EAI_BIN_taskPatrol;

if (A3EAI_debugLevel > 0) then {
	diag_log format["A3EAI Debug: Spawned 1 new AI groups of %1 units each in %2 seconds at %3 (Random Spawn).",_totalAI,(diag_tickTime - _startTime),(mapGridPosition _trigger)];
};

_triggerStatements = (triggerStatements _trigger);
if (!(_trigger getVariable ["initialized",false])) then {
	0 = [2,_trigger,[_unitGroup]] call A3EAI_initializeTrigger;
	_trigger setVariable ["triggerStatements",+_triggerStatements];
};
_triggerStatements set [1,""];
_trigger setTriggerStatements _triggerStatements;

if (_debugMarkers) then {
	_nul = _trigger spawn {
		_marker = str(_this);
		_marker setMarkerColor "ColorOrange";
		_marker setMarkerAlpha 0.9;				//Dark orange: Activated trigger
	};
};

true
