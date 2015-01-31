_startTime = diag_tickTime;

_foodList = [configFile >> "CfgLootTable" >> "Food","items",[]] call BIS_fnc_returnConfigEntry;
{
	_foodList set [_forEachIndex,(_x select 0)];
} forEach _foodList;

if !(_foodList isEqualTo []) then {
	A3EAI_foodLoot = _foodList;
	if (A3EAI_debugLevel > 0) then {diag_log format ["A3EAI Debug: Generated %1 food classnames in %2 seconds.",(count _foodList),diag_tickTime - _startTime]};
} else {
	diag_log "A3EAI Error: Could not dynamically generate food classname list. Classnames from A3EAI_config.sqf used instead.";
};
