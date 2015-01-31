_startTime = diag_tickTime;

_backpackList = [configFile >> "CfgLootTable" >> "Backpack","items",[]] call BIS_fnc_returnConfigEntry;
{
	_backpackList set [_forEachIndex,(_x select 0)];
} forEach _backpackList;

if !(_backpackList isEqualTo []) then {
	A3EAI_backpackTypes0 = _backpackList;
	A3EAI_backpackTypes1 = +_backpackList;
	A3EAI_backpackTypes2 = +_backpackList;
	A3EAI_backpackTypes3 = +_backpackList;
	if (A3EAI_debugLevel > 0) then {diag_log format ["A3EAI Debug: Generated %1 backpack classnames in %2 seconds.",(count _backpackList),diag_tickTime - _startTime]};
} else {
	diag_log "A3EAI Error: Could not dynamically generate backpack classname list. Classnames from A3EAI_config.sqf used instead.";
};
