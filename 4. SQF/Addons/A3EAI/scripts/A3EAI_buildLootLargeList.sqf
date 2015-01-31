_startTime = diag_tickTime;

_lootListLarge1 = [configFile >> "CfgLootTable" >> "GenericLarge","items",[]] call BIS_fnc_returnConfigEntry;
_lootListLarge2 = [configFile >> "CfgLootTable" >> "GenericAuto","items",[]] call BIS_fnc_returnConfigEntry;
_lootListLarge = _lootListLarge1 + _lootListLarge2;
{
	_lootListLarge set [_forEachIndex,(_x select 0)];
} forEach _lootListLarge;

if !(_lootListLarge isEqualTo []) then {
	A3EAI_MiscLoot2 = _lootListLarge;
	if (A3EAI_debugLevel > 0) then {diag_log format ["A3EAI Debug: Generated %1 generic loot (large) classnames in %2 seconds.",(count _lootListLarge),diag_tickTime - _startTime]};
} else {
	diag_log "A3EAI Error: Could not dynamically generate loot (large) classname list. Classnames from A3EAI_config.sqf used instead.";
};
