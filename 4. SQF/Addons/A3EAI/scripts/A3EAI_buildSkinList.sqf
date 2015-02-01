_startTime = diag_tickTime;
if (A3EAI_dynamicUniformList) then {
	A3EAI_uniformTypes = [configFile >> "CfgLootTable" >> "Uniforms","items",[""]] call BIS_fnc_returnConfigEntry;
	//diag_log format ["Uniforms found: %1",A3EAI_uniformTypes];
};

A3EAI_useableUniforms = [];
{
	A3EAI_useableUniforms pushBack (_x select 0);
} forEach A3EAI_uniformTypes;

if (A3EAI_debugLevel > 0) then {diag_log format ["A3EAI Debug: Generated %1 uniform classnames in %3 seconds.",(count A3EAI_useableUniforms),diag_tickTime - _startTime]};
