_startTime = diag_tickTime;

A3EAI_uniformTypes = [configFile >> "CfgLootTable" >> "Uniforms","items",[""]] call BIS_fnc_returnConfigEntry;
{
	A3EAI_uniformTypes set [_forEachIndex,(_x select 0)];
} forEach A3EAI_uniformTypes;

if (A3EAI_debugLevel > 0) then {diag_log format ["A3EAI Debug: Generated %1 uniform classnames in %2 seconds.",(count A3EAI_uniformTypes),diag_tickTime - _startTime]};
