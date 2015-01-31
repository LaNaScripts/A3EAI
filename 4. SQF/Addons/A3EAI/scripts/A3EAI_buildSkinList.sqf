_startTime = diag_tickTime;
if (A3EAI_dynamicUniformList) then {
	A3EAI_uniformTypes = [configFile >> "CfgLootTable" >> "Uniforms","items",[""]] call BIS_fnc_returnConfigEntry;
	//diag_log format ["Uniforms found: %1",A3EAI_uniformTypes];
} else {
	if ((typeName A3EAI_uniformTypes) != "ARRAY") then {A3EAI_uniformTypes = []};
};

A3EAI_useableUniforms = [];
{
	_uniformClass = (_x select 0);
	_uniformUnit = [configFile >> "CfgWeapons" >> _uniformClass >> "ItemInfo","uniformClass",""] call BIS_fnc_returnConfigEntry;
	_uniformSide = [configFile >> "CfgVehicles" >> _uniformUnit,"side",-1] call BIS_fnc_returnConfigEntry;
	A3EAI_useableUniforms pushBack _uniformClass;
} forEach A3EAI_uniformTypes;


if (A3EAI_debugLevel > 0) then {diag_log format ["A3EAI Debug: Generated %1 uniform classnames in %3 seconds.",(count A3EAI_useableUniforms),diag_tickTime - _startTime]};
