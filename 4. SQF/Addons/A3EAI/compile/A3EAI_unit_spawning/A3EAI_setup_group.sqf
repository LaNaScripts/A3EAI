	/*
	fnc_createGroup
	
	Description: Spawns a group of AI units. Used for spawning of A3EAI's static, dynamic, and custom AI units.
	
	_totalAI = Number of AI units to spawn in the group
	_spawnPos: Position to create AI unit.
	_trigger: The trigger object responsible for spawning the AI unit.
	_unitLevel: unitLevel to be used for generating equipment. Influences weapon quality and skill level.
	
	Last updated: 10:33 PM 5/14/2014
	
*/
private ["_totalAI","_spawnPos","_unitGroup","_trigger","_attempts","_baseDist","_dummy","_unitLevel","_checkPos"];

	
_totalAI = _this select 0;
_spawnPos = _this select 2;
_trigger = _this select 3;
_unitLevel = _this select 4;
_checkPos = if ((count _this) > 5) then {_this select 5} else {false};

if (_checkPos) then {	//If provided position requires checking...
	_pos = [];
	_attempts = 0;
	_baseDist = 25;

	while {((count _pos) < 1) && {(_attempts < 3)}} do {
		_pos = _spawnPos findEmptyPosition [0.5,_baseDist,"Land_Coil_F"];
		if ((count _pos) > 1) then {
			_pos = _pos isFlatEmpty [0,0,0.75,5,0,false,objNull];
		}; 
		if ((count _pos) < 1) then {
			if (_attempts < 2) then {
				_baseDist = (_baseDist + 15);
			} else {
				_pos = [_trigger,random (_trigger getVariable ["patrolDist",125]),random(360),0] call SHK_pos;
			};
			_attempts = (_attempts + 1);
		};
	};

	if (A3EAI_debugLevel > 1) then {diag_log format ["A3EAI Extended Debug: Found spawn position at %3 meters away at position %1 after %2 retries.",_pos,_attempts,(_pos distance _spawnPos)]};
	
	_spawnPos = _pos;
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
	{_x allowDamage false} count (units _unitGroup);
	_nul = _unitGroup spawn {
		uiSleep 10;
		{_x allowDamage true} count (units _this);
		uiSleep 1;
		_this setCombatMode "RED";	//Activate AI group hostility after 'x' seconds
	};
};

//Delete dummy if it exists, and clear group's "dummy" variable.
_dummy = _unitGroup getVariable "dummyUnit";
if (!isNil "_dummy") then {
	deleteVehicle _dummy;
	_unitGroup setVariable ["dummyUnit",nil];
	if (A3EAI_debugLevel > 1) then {diag_log format["A3EAI Extended Debug: Deleted 1 dummy AI unit for group %1. (fnc_createGroup)",_unitGroup];};
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
