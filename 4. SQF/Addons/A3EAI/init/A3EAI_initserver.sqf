/*
	A3EAI Server Initialization File
	
	Description: Handles startup process for A3EAI. Does not contain any values intended for modification.
*/
if (hasInterface ||!isNil "A3EAI_isActive") exitWith {};
A3EAI_isActive = true;
_startTime = diag_tickTime;

private ["_startTime","_directoryAsArray","_worldname","_allUnits"];

_directoryAsArray = toArray __FILE__;
_directoryAsArray resize ((count _directoryAsArray) - 26);
A3EAI_directory = toString _directoryAsArray;

if !(isNil "A3EAI_devOptions") then {
	if ("readoverridefile" in A3EAI_devOptions) then {A3EAI_overrideEnabled = true} else {A3EAI_overrideEnabled = nil};
	if ("enabledebugmarkers" in A3EAI_devOptions) then {A3EAI_debugMarkersEnabled = true} else {A3EAI_debugMarkersEnabled = nil};
	if ("enableHC" in A3EAI_devOptions) then {A3EAI_enableHC = true} else {A3EAI_enableHC = nil};
	A3EAI_devOptions = nil;
} else {
	A3EAI_overrideEnabled = nil;
	A3EAI_debugMarkersEnabled = nil;
	A3EAI_enableHC = nil;
};

//Report A3EAI version to RPT log
diag_log format ["[A3EAI] Initializing A3EAI version %1 using base path %2.",[configFile >> "CfgPatches" >> "A3EAI","A3EAIVersion","error - unknown version"] call BIS_fnc_returnConfigEntry,A3EAI_directory];

//Load A3EAI main configuration file
call compile preprocessFileLineNumbers "@EpochHive\A3EAI_config.sqf";

if ((isNil "A3EAI_verifySettings") or {(typeName A3EAI_verifySettings) != "BOOL"}) then {A3EAI_verifySettings = true}; //Yo dawg, heard you like verifying, so...
if (A3EAI_verifySettings) then {call compile preprocessFileLineNumbers format ["%1\scripts\verifySettings.sqf",A3EAI_directory];};

//Load custom A3EAI settings file.
if ((!isNil "A3EAI_overrideEnabled") && {A3EAI_overrideEnabled}) then {call compile preprocessFileLineNumbers "@EpochHive\A3EAI_settings_override.sqf"};

//Load A3EAI functions
call compile preprocessFileLineNumbers format ["%1\init\A3EAI_functions.sqf",A3EAI_directory];

//Set side relations only if needed
_allUnits = +allUnits;
if (({if ((side _x) isEqualTo east) exitWith {1}} count _allUnits) isEqualTo 0) then {createCenter east};
if (({if ((side _x) isEqualTo west) exitWith {1}} count _allUnits) isEqualTo 0) then {createCenter west};
if (({if ((side _x) isEqualTo resistance) exitWith {1}} count _allUnits) isEqualTo 0) then {createCenter resistance};
if ((resistance getFriend west) > 0) then {resistance setFriend [west, 0]};
if ((resistance getFriend east) > 0) then {resistance setFriend [east, 0]};
if ((east getFriend resistance) > 0) then {east setFriend [resistance, 0]};
if ((west getFriend resistance) > 0) then {west setFriend [resistance, 0]};

//Create reference marker to act as boundary for spawning AI air/land vehicles. These values will be later modified on a per-map basis.
_centerPos = getArray(configFile >> "CfgWorlds" >> worldName >> "centerPosition");
_markerSize = [7000, 7000];
_centerMarker = createMarkerLocal ["A3EAI_centerMarker", _centerPos];
_centerMarker setMarkerShapeLocal "ELLIPSE";
_centerMarker setMarkerTypeLocal "Empty";
_centerMarker setMarkerBrushLocal "Solid";
_centerMarker setMarkerAlphaLocal 0;

_worldname = (toLower worldName);
{
	if (_worldname isEqualTo (_x select 0)) exitWith {
		_centerPos = (_x select 1);
		_markerSize = (_x select 2);
	};
} forEach [
	//worldName, center position, landmass radius
	["altis",[15834.2,15787.8,0],12000],
	["stratis",[3937.6,4774.51,0],3000],
	["caribou",[3938.9722, 4195.7417],3500],
	["chernarus",[7652.9634, 7870.8076],5500],
	["fallujah",[5139.8008, 4092.6797],4000],
	["fdf_isle1_a",[10771.362, 8389.2568],2750],
	["isladuala",[4945.3438, 4919.6616],4000],
	["lingor",[5166.5581, 5108.8301],4500],
	["mbg_celle2",[6163.52, 6220.3984],6000],
	["namalsk",[5880.1313, 8889.1045],3000],
	["napf",[10725.096, 9339.918],8500],
	["oring",[5191.1069, 5409.1938],4750],
	["panthera2",[5343.6953, 4366.2534],3500],
	["sara",[12693.104, 11544.386],6250],
	["smd_sahrani_a2",[12693.104, 11544.386],6250],
	["sauerland",[12270.443, 13632.132],17500],
	["takistan",[6368.2764, 6624.2744],6000],
	["tavi",[10887.825, 11084.657],8500],
	["trinity",[7183.8403, 7067.4727],5300],
	["utes",[3519.8037, 3703.0649],1000],
	["zargabad",[3917.6201, 3800.0376],2000]
];
_centerMarker setMarkerPos _centerPos;
_centerMarker setMarkerSize [_markerSize,_markerSize];

if (A3EAI_autoGenerateStatic) then {[] execVM format ["%1\scripts\setup_autoStaticSpawns.sqf",A3EAI_directory];};

//Continue loading required A3EAI script files
[] execVM format ['%1\scripts\A3EAI_post_init.sqf',A3EAI_directory];

//Report A3EAI startup settings to RPT log
diag_log format ["[A3EAI] A3EAI settings: Debug Level: %1. DebugMarkers: %2. WorldName: %3. VerifyClassnames: %4. VerifySettings: %5.",A3EAI_debugLevel,((!isNil "A3EAI_debugMarkersEnabled") && {A3EAI_debugMarkersEnabled}),_worldname,A3EAI_verifyClassnames,A3EAI_verifySettings];
diag_log format ["[A3EAI] AI spawn settings: Static: %1. Dynamic: %2. Random: %3. Air: %4. Land: %5.",A3EAI_autoGenerateStatic,A3EAI_dynAISpawns,(A3EAI_maxRandomSpawns > 0),(A3EAI_maxHeliPatrols>0),(A3EAI_maxLandPatrols>0)];
diag_log format ["[A3EAI] A3EAI loading completed in %1 seconds.",(diag_tickTime - _startTime)];
