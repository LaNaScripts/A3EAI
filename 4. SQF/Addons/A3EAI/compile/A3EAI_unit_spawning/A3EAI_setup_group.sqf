
private ["_totalAI","_spawnPos","_unitGroup","_trigger","_attempts","_baseDist","_dummy","_unitLevel","_checkPos"];

	
_totalAI = _this select 0;
_spawnPos = _this select 2;
_trigger = _this select 3;
_unitLevel = _this select 4;
_checkPos = if ((count _this) > 5) then {_this select 5} else {false};

if (_checkPos) then {	//If provided position requires checking...
	_pos = [];
	_attempts = 0;
	_baseDist = 15;

	while {(_pos isEqualTo []) && {(_attempts < 3)}} do {
		_pos = _spawnPos findEmptyPosition [0.5,_baseDist,"Land_Coil_F"];
		if !(_pos isEqualTo []) then {
			_pos = _pos isFlatEmpty [0,0,0.75,5,0,false,objNull];
		}; 
		
		_attempts = (_attempts + 1);
		if (_pos isEqualTo []) then {
			if (_attempts < 3) then {
				_baseDist = (_baseDist + 15);
			};
		} else {
			if (A3EAI_debugLevel > 1) then {diag_log format ["A3EAI Extended Debug: Found spawn position at %1 meters away at position %2 after %3 attempts.",(_pos distance _spawnPos),_pos,_attempts]};
			_spawnPos = _pos;
		};
	};
};

_spawnPos set [2,0];
_unitGroup = if (isNull (_this select 1)) then {[] call A3EAI_createGroup} else {_this select 1};

for "_i" from 1 to _totalAI do {
	private ["_unit"];
	_unit = [_unitGroup,_unitLevel,_spawnPos] call A3EAI_createUnit;
	_unit setPos _spawnPos;
};

if (({if (isPlayer _x) exitWith {1}} count (_spawnPos nearEntities [["Epoch_Male_F", "Epoch_Female_F"],100])) isEqualTo 0) then {
	_unitGroup setCombatMode "RED";	
} else {
	_unitGroup setCombatMode "BLUE";
	_nul = _unitGroup spawn {
		uiSleep 10;
		_this setCombatMode "RED";	//Activate AI group hostility after 'x' seconds
	};
};

//Delete dummy if it exists, and clear group's "dummy" variable.
_dummy = _unitGroup getVariable "dummyUnit";
if (!isNil "_dummy") then {
	deleteVehicle _dummy;
	_unitGroup setVariable ["dummyUnit",nil];
	if (A3EAI_debugLevel > 1) then {diag_log format["A3EAI Extended Debug: Deleted 1 dummy unit for group %1.",_unitGroup];};
};

_unitGroup selectLeader ((units _unitGroup) select 0);
_unitGroup setVariable ["trigger",_trigger];
_unitGroup setVariable ["GroupSize",_totalAI];
_unitGroup setVariable ["unitLevel",_unitLevel];
if (isNull _trigger) then {_unitGroup setVariable ["spawnPos",_spawnPos]}; 	//If group was spawned directly by scripting instead of a trigger object, record spawn position instead of trigger position as anchoring point
0 = [_unitGroup,_unitLevel] spawn A3EAI_addGroupManager;	//start group-level manager
_unitGroup setFormDir (random 360);
_unitGroup allowFleeing 0;

_unitGroup
