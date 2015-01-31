/*
	Reads from CfgWorlds config and extracts information about city/town names, positions, and types.

	Used to generate waypoint positions for AI vehicle patrols.
*/

private ["_cfgWorldName","_startTime","_allPlaces"];

_startTime = diag_tickTime;
_allPlaces = [];
_telePositions = [];
_cfgWorldName = configFile >> "CfgWorlds" >> worldName >> "Names";

for "_i" from 0 to ((count _cfgWorldName) -1) do {
	_allPlaces set [(count _allPlaces),configName (_cfgWorldName select _i)];
	//diag_log format ["DEBUG :: Added location %1 to allPlaces array.",configName (_cfgWorldName select _i)];
};

//Add user-specified blacklist areas
{
	A3EAI_waypointBlacklist set [_forEachIndex,(toLower _x)]; //Ensure case-insensitivity
	if (A3EAI_debugLevel > 0) then {diag_log format ["A3EAI Debug: Created AI vehicle waypoint blacklist at %1.",_x];};
	if ((_forEachIndex % 3) isEqualTo 0) then {uiSleep 0.05};
} forEach A3EAI_waypointBlacklist;

//Set up trader city blacklist areas
{
	_location = [_x select 1,600] call A3EAI_createBlackListArea;
	if (A3EAI_debugLevel > 0) then {diag_log format ["A3EAI Debug: Created 600m radius blacklist area at %1 teleport source (%2).",_x select 0,_x select 1];};
	_location = [_x select 3,600] call A3EAI_createBlackListArea;
	if (A3EAI_debugLevel > 0) then {diag_log format ["A3EAI Debug: Created 600m radius blacklist area at %1 teleport destination (%2).",_x select 0,_x select 3];};
	if ((_forEachIndex % 3) isEqualTo 0) then {uiSleep 0.05};
} forEach ([configFile >> "CfgEpoch" >> worldName,"telePos",[]] call BIS_fnc_returnConfigEntry);

{
	_placeType = getText (_cfgWorldName >> _x >> "type");
	if (_placeType in ["NameCityCapital","NameCity","NameVillage","NameLocal"]) then {
		_placeName = getText (_cfgWorldName >> _x >> "name");
		_placePos = [] + getArray (_cfgWorldName >> _x >> "position");
		_isAllowedPos = !((toLower _placeName) in A3EAI_waypointBlacklist);
		if (_placeType != "NameLocal") then {
			if (_isAllowedPos) then {
				A3EAI_locationsLand pushBack [_placeName,_placePos,_placeType];
			};
		};
		if (_isAllowedPos) then {
			A3EAI_locations pushBack [_placeName,_placePos,_placeType];
		};
	};
	if ((_forEachIndex % 10) isEqualTo 0) then {uiSleep 0.05};
} forEach _allPlaces;

A3EAI_locations_ready = true;

if (A3EAI_debugLevel > 0) then {diag_log format ["A3EAI Debug: Location configuration completed with %1 locations found in %2 seconds.",(count A3EAI_locations),(diag_tickTime - _startTime)]};
