_startTime = diag_tickTime;

_lootList1 = [configFile >> "CfgLootTable" >> "Generic","items",[]] call BIS_fnc_returnConfigEntry;
_lootList2 = [configFile >> "CfgLootTable" >> "GenericBed","items",[]] call BIS_fnc_returnConfigEntry;
_lootList = _lootList1 + _lootList2;
{
	_lootList set [_forEachIndex,(_x select 0)];
} forEach _lootList;

if !(_lootList isEqualTo []) then {
	A3EAI_MiscLoot1 = _lootList;
	if (A3EAI_debugLevel > 0) then {diag_log format ["A3EAI Debug: Generated %1 generic loot classnames in %2 seconds.",(count _lootList),diag_tickTime - _startTime]};
} else {
	diag_log "A3EAI Error: Could not dynamically generate loot classname list. Classnames from A3EAI_config.sqf used instead.";
};
