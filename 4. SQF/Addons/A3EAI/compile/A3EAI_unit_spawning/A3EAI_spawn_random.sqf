
private ["_patrolDist","_trigger","_totalAI","_minAI","_addAI","_unitLevel","_unitGroup","_playerPos","_spawnPos","_startTime","_baseDist","_extraDist","_triggerStatements","_spawnDist","_thisList" ,"_spawnPosSelected","_spawnChance"];


_startTime = diag_tickTime;

_patrolDist = _this select 0;
_trigger = _this select 1;
_thisList = _this select 2;
_minAI = _this select 3;
_addAI = _this select 4;
_unitLevel = _this select 5;
_spawnChance = _this select 6;

if (_spawnChance call A3EAI_chance) then {
	_baseDist = 0;
	_extraDist = 300;
	_playerPos = [0,0,0];

	{
		if (isPlayer _x) exitWith {
			_playerPos = getPosASL _x;
			_triggerLocation = _trigger getVariable ["triggerLocation",locationNull];
			if (
					(({if (_playerPos in _x) exitWith {1}} count ((nearestLocations [_playerPos,["Strategic"],1500]) - [_triggerLocation])) isEqualTo 0) && 
					{!(surfaceIsWater _playerPos)} &&
					{((_playerPos nearObjects ["PlotPole_EPOCH",300]) isEqualTo [])}
				) then {
				_trigger setPosASL _playerPos;
				_triggerLocation setPosition _playerPos;
				_baseDist = 200;
				_extraDist = 100;
				if (A3EAI_debugMarkersEnabled) then {
					str (_trigger) setMarkerPos _playerPos;
				};
			};
		};
	} forEach _thisList;

	_triggerPos = getPosATL _trigger;

	_nearAttempts = 0;
	_spawnPos = [];
	while {(_spawnPos isEqualTo []) && {_nearAttempts < 4}} do {
		_spawnPosSelected = [_triggerPos,(_baseDist + (random _extraDist)),(random 360),0] call SHK_pos;
		_spawnPosSelASL = ATLToASL _spawnPosSelected;
		if ((count _spawnPosSelected) isEqualTo 2) then {_spawnPosSelected set [2,0];};
		if (
			({if ((isPlayer _x) && {([eyePos _x,[(_spawnPosSelected select 0),(_spawnPosSelected select 1),(_spawnPosSelASL select 2) + 1.7],_x] call A3EAI_hasLOS) or ((_x distance _spawnPosSelected) < 150)}) exitWith {1}} count (_spawnPosSelected nearEntities [["Epoch_Male_F","Epoch_Female_F","Car"], 200]) isEqualTo 0) && 
			{!(surfaceIsWater _spawnPosSelected)} &&
			{!((_spawnPosSelASL) call A3EAI_posInBuilding)} &&
			{((_spawnPosSelected nearObjects ["PlotPole_EPOCH",300]) isEqualTo [])}
		) then {
			_spawnPos = _spawnPosSelected;
		};
		_nearAttempts = _nearAttempts + 1;
	};

	//diag_log format ["DEBUG: Nearby units: %1",_spawnPos nearEntities [["CAManBase"],200]];

	if !(_spawnPos isEqualTo []) then {
		_totalAI = ((_minAI + floor (random (_addAI + 1))) max 1);
		_unitGroup = [_totalAI,grpNull,"random",_spawnPos,_trigger,_unitLevel,true] call A3EAI_spawnGroup;

		_unitGroup setBehaviour "AWARE";
		_unitGroup setSpeedMode "FULL";
		
		[_unitGroup,_playerPos] call A3EAI_setFirstWPPos;
		0 = [_unitGroup,_triggerPos,_patrolDist] spawn A3EAI_BIN_taskPatrol;

		if (A3EAI_debugLevel > 0) then {
			diag_log format["A3EAI Debug: Spawned 1 new AI groups of %1 units each in %2 seconds at %3 using %4 attempts (Random Spawn).",_totalAI,(diag_tickTime - _startTime),(mapGridPosition _trigger),_nearAttempts];
		};

		_triggerStatements = (triggerStatements _trigger);
		if (!(_trigger getVariable ["initialized",false])) then {
			0 = [2,_trigger,[_unitGroup]] call A3EAI_initializeTrigger;
			_trigger setVariable ["triggerStatements",+_triggerStatements];
		};
		_triggerStatements set [1,""];
		_trigger setTriggerStatements _triggerStatements;

		if (A3EAI_debugMarkersEnabled) then {
			_nul = _trigger spawn {
				_marker = str(_this);
				_marker setMarkerColor "ColorOrange";
				_marker setMarkerAlpha 0.9;				//Dark orange: Activated trigger
			};
		};

		true
	} else {
		if (A3EAI_debugLevel > 0) then {
			diag_log format ["A3EAI Debug: Conditional checks failed for random spawn at %1. Canceling spawn.",(mapGridPosition _trigger)];
		};
		_nul = _trigger call A3EAI_cancelRandomSpawn;
		false
	};
} else {
	if (A3EAI_debugLevel > 0) then {
		diag_log format ["A3EAI Debug: Probability check failed for random spawn at %1. Canceling spawn.",(mapGridPosition _trigger)];
	};
	_nul = _trigger call A3EAI_cancelRandomSpawn;
	false
};
