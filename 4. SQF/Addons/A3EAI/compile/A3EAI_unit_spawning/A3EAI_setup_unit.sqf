private ["_unit", "_unitGroup", "_spawnPos", "_unitLevel", "_type"];
_unitGroup = _this select 0;
_unitLevel = _this select 1;
_spawnPos = _this select 2;

_unit = _unitGroup createUnit ["i_survivor_F",_spawnPos,[],0,"FORM"];
_unit setVariable ["bodyName",(name _unit)];
[_unit] joinSilent _unitGroup;
0 = _unit call A3EAI_addEH;
0 = [_unit, _unitLevel] call A3EAI_generateLoadout;									// Assign unit loadout
0 = [_unit, _unitLevel] call A3EAI_setSkills;										// Set AI skill
if (A3EAI_debugLevel > 1) then {diag_log format["A3EAI Extended Debug: Spawned AI Type %1 with unitLevel %2 for group %3.",_unit,_unitLevel,_unitGroup];};

_unit