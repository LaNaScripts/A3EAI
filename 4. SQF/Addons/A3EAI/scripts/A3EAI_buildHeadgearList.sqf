_startTime = diag_tickTime;

_headgearList = [configFile >> "CfgLootTable" >> "Headgear","items",[]] call BIS_fnc_returnConfigEntry;
{
	_headgearList set [_forEachIndex,(_x select 0)];
} forEach _headgearList;

if !(_headgearList isEqualTo []) then {
	A3EAI_headgearTypes = _headgearList;
	if (A3EAI_debugLevel > 0) then {diag_log format ["A3EAI Debug: Generated %1 headgear classnames in %2 seconds.",(count _headgearList),diag_tickTime - _startTime]};
} else {
	diag_log "A3EAI Error: Could not dynamically generate headgear classname list. Classnames from A3EAI_config.sqf used instead.";
};
