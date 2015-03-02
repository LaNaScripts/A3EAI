_startTime = diag_tickTime;

_uniformTypes = [configFile >> "CfgLootTable" >> "Uniforms","items",[""]] call BIS_fnc_returnConfigEntry;
{
	_uniformTypes set [_forEachIndex,(_x select 0)];
} forEach _uniformTypes;

if !(_uniformTypes isEqualTo []) then {
	A3EAI_uniformTypes0 = _uniformTypes;
	A3EAI_uniformTypes1 = _uniformTypes;
	A3EAI_uniformTypes2 = _uniformTypes;
	A3EAI_uniformTypes3 = _uniformTypes;
	if (A3EAI_debugLevel > 0) then {diag_log format ["A3EAI Debug: Generated %1 uniform classnames in %2 seconds.",(count _uniformTypes),diag_tickTime - _startTime]};
} else {
	diag_log "A3EAI Error: Could not dynamically generate uniform classname list. Classnames from A3EAI_config.sqf used instead.";
};
