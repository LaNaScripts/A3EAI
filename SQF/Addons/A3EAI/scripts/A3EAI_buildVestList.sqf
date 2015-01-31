_startTime = diag_tickTime;

_vestList = [configFile >> "CfgLootTable" >> "Vests","items",[]] call BIS_fnc_returnConfigEntry;
{
	_vestList set [_forEachIndex,(_x select 0)];
} forEach _vestList;

if !(_vestList isEqualTo []) then {
	A3EAI_vestTypes0 = _vestList;
	A3EAI_vestTypes1 = +_vestList;
	A3EAI_vestTypes2 = +_vestList;
	A3EAI_vestTypes3 = +_vestList;
	if (A3EAI_debugLevel > 0) then {diag_log format ["A3EAI Debug: Generated %1 vest classnames in %2 seconds.",(count _vestList),diag_tickTime - _startTime]};
} else {
	diag_log "A3EAI Error: Could not dynamically generate vest classname list. Classnames from A3EAI_config.sqf used instead.";
};
