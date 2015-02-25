#define WEAPON_BANNED_STRING "bin\config.bin/CfgWeapons/FakeWeapon"
#define VEHICLE_BANNED_STRING "bin\config.bin/CfgVehicles/Banned"
#define MAGAZINE_BANNED_STRING "bin\config.bin/CfgMagazines/FakeMagazine"

private["_verified","_errorFound","_startTime"];

_startTime = diag_tickTime;

_verified = [];

/*
_index = 4;
while {(typeName (missionNamespace getVariable ("A3EAI_Rifles"+str(_index)))) isEqualTo "ARRAY"} do {
	A3EAI_tableChecklist set [count A3EAI_tableChecklist,("A3EAI_Rifles"+str(_index))];
	_index = _index + 1;
	if (A3EAI_debugLevel > 0) then {diag_log format ["A3EAI Debug: Found custom weapon array %1.",("A3EAI_Rifles"+str(_index))]};
};
*/

{
	_array = missionNamespace getVariable [_x,[]];
	_errorFound = false;
	{
		if !(_x in _verified) then {
			call {
				if (isClass (configFile >> "CfgWeapons" >> _x)) exitWith {
					if (((str(inheritsFrom (configFile >> "CfgWeapons" >> _x))) isEqualTo WEAPON_BANNED_STRING) or {(getNumber (configFile >> "CfgWeapons" >> _x >> "scope")) isEqualTo 0}) then {
						diag_log format ["[A3EAI] Removing invalid classname: %1.",_x];
						_array set [_forEachIndex,""];
						if (!_errorFound) then {_errorFound = true};
					} else {
						_verified pushBack _x;
					};
				};
				if (isClass (configFile >> "CfgMagazines" >> _x)) exitWith {
					if (((str(inheritsFrom (configFile >> "CfgMagazines" >> _x))) isEqualTo MAGAZINE_BANNED_STRING) or {(getNumber (configFile >> "CfgMagazines" >> _x >> "scope")) isEqualTo 0}) then {
						diag_log format ["[A3EAI] Removing invalid classname: %1.",_x];
						_array set [_forEachIndex,""];
						if (!_errorFound) then {_errorFound = true};
					} else {
						_verified pushBack _x;
					};
				};
				if (isClass (configFile >> "CfgVehicles" >> _x)) exitWith {
					if (((str(inheritsFrom (configFile >> "CfgVehicles" >> _x))) isEqualTo VEHICLE_BANNED_STRING) or {(getNumber (configFile >> "CfgVehicles" >> _x >> "scope")) isEqualTo 0}) then {
						diag_log format ["[A3EAI] Removing banned classname: %1.",_x];
						_array set [_forEachIndex,""];
						if (!_errorFound) then {_errorFound = true};
					} else {
						_verified pushBack _x;
					};
				};
				diag_log format ["[A3EAI] Removing invalid classname: %1.",_x];	//Default case - if classname doesn't exist at all
				_array set [_forEachIndex,""];
				if (!_errorFound) then {_errorFound = true};
			};
		};
	} forEach _array;
	if (_errorFound) then {
		_array = _array - [""];
		missionNamespace setVariable [_x,_array];
		diag_log format ["[A3EAI] Contents of %1 failed verification. Invalid entries removed.",_x];
		//diag_log format ["DEBUG :: Corrected contents of %1: %2.",_x,_array];
		//diag_log format ["DEBUG :: Comparison check of %1: %2.",_x,missionNamespace getVariable [_x,[]]];
	};
} forEach A3EAI_tableChecklist;

{
	if (!((_x select 0) isKindOf "Air") or {([configFile >> "CfgVehicles" >> (_x select 0) >> "Eventhandlers","init",""] call BIS_fnc_returnConfigEntry) != ""}) then {
		diag_log format ["[A3EAI] Removing invalid classname from A3EAI_heliList array: %1.",(_x select 0)];
		A3EAI_heliList set [_forEachIndex,""];
	};
} forEach A3EAI_heliList;
if ("" in A3EAI_heliList) then {A3EAI_heliList = A3EAI_heliList - [""];};

{
	if (!((_x select 0) isKindOf "Car") or {([configFile >> "CfgVehicles" >> (_x select 0) >> "Eventhandlers","init",""] call BIS_fnc_returnConfigEntry) != ""}) then {
		diag_log format ["[A3EAI] Removing invalid classname from A3EAI_vehList array: %1.",(_x select 0)];
		A3EAI_vehList set [_forEachIndex,""];
	};
} forEach A3EAI_vehList;
if ("" in A3EAI_vehList) then {A3EAI_vehList = A3EAI_vehList - [""];};

{
	if !(([configFile >> "CfgWeapons" >> _x,"type",-1] call BIS_fnc_returnConfigEntry) isEqualTo 2) then {
		diag_log format ["[A3EAI] Removing invalid classname from A3EAI_pistolList array: %1.",_x];
		A3EAI_pistolList set [_forEachIndex,""];
	};
} forEach A3EAI_pistolList;
if ("" in A3EAI_pistolList) then {A3EAI_pistolList = A3EAI_pistolList - [""];};

{
	if !(([configFile >> "CfgWeapons" >> _x,"type",-1] call BIS_fnc_returnConfigEntry) isEqualTo 1) then {
		diag_log format ["[A3EAI] Removing invalid classname from A3EAI_rifleList array: %1.",_x];
		A3EAI_rifleList set [_forEachIndex,""];
	};
} forEach A3EAI_rifleList;
if ("" in A3EAI_rifleList) then {A3EAI_rifleList = A3EAI_rifleList - [""];};

{
	if !(([configFile >> "CfgWeapons" >> _x,"type",-1] call BIS_fnc_returnConfigEntry) isEqualTo 1) then {
		diag_log format ["[A3EAI] Removing invalid classname from A3EAI_machinegunList array: %1.",_x];
		A3EAI_machinegunList set [_forEachIndex,""];
	};
} forEach A3EAI_machinegunList;
if ("" in A3EAI_machinegunList) then {A3EAI_machinegunList = A3EAI_machinegunList - [""];};

{
	if !(([configFile >> "CfgWeapons" >> _x,"type",-1] call BIS_fnc_returnConfigEntry) isEqualTo 1) then {
		diag_log format ["[A3EAI] Removing invalid classname from A3EAI_sniperList array: %1.",_x];
		A3EAI_sniperList set [_forEachIndex,""];
	};
} forEach A3EAI_sniperList;
if ("" in A3EAI_sniperList) then {A3EAI_sniperList = A3EAI_sniperList - [""];};

{
	if !(([configFile >> "CfgWeapons" >> _x,"type",-1] call BIS_fnc_returnConfigEntry) isEqualTo 4) then {
		diag_log format ["[A3EAI] Removing invalid classname from A3EAI_launcherTypes array: %1.",_x];
		A3EAI_launcherTypes set [_forEachIndex,""];
	};
} forEach A3EAI_launcherTypes;
if ("" in A3EAI_launcherTypes) then {A3EAI_launcherTypes = A3EAI_launcherTypes - [""];};

//Anticipate cases where all elements of an array are invalid
if (A3EAI_pistolList isEqualTo []) then {A3EAI_pistolList = ["hgun_ACPC2_F", "hgun_ACPC2_F", "hgun_Rook40_F", "hgun_Rook40_F", "hgun_Rook40_F", "hgun_P07_F", "hgun_P07_F", "hgun_Pistol_heavy_01_F", "hgun_Pistol_heavy_02_F", "ruger_pistol_epoch", "ruger_pistol_epoch", "1911_pistol_epoch", "1911_pistol_epoch"]};
if (A3EAI_rifleList isEqualTo []) then {A3EAI_rifleList = ["arifle_Katiba_F", "arifle_Katiba_F", "arifle_Katiba_C_F", "arifle_Katiba_GL_F", "arifle_MXC_F", "arifle_MX_F", "arifle_MX_F", "arifle_MX_GL_F", "arifle_MXM_F", "arifle_SDAR_F", "arifle_TRG21_F", "arifle_TRG20_F", "arifle_TRG21_GL_F", "arifle_Mk20_F", "arifle_Mk20C_F", "arifle_Mk20_GL_F", "arifle_Mk20_plain_F", "arifle_Mk20_plain_F", "arifle_Mk20C_plain_F", "arifle_Mk20_GL_plain_F", "SMG_01_F", "SMG_02_F", "SMG_01_F", "SMG_02_F", "hgun_PDW2000_F", "hgun_PDW2000_F", "arifle_MXM_Black_F", "arifle_MX_GL_Black_F", "arifle_MX_Black_F", "arifle_MXC_Black_F", "Rollins_F", "Rollins_F", "Rollins_F", "Rollins_F", "AKM_EPOCH", "m4a3_EPOCH", "m16_EPOCH", "m16Red_EPOCH"]};
if (A3EAI_machinegunList isEqualTo []) then {A3EAI_machinegunList = ["LMG_Mk200_F", "arifle_MX_SW_F", "LMG_Zafir_F", "arifle_MX_SW_Black_F", "m249_EPOCH", "m249Tan_EPOCH"]};
if (A3EAI_sniperList isEqualTo []) then {A3EAI_sniperList = ["srifle_EBR_F", "srifle_EBR_F", "srifle_GM6_F", "srifle_GM6_F", "srifle_LRR_F", "srifle_DMR_01_F", "M14_EPOCH", "M14Grn_EPOCH", "m107_EPOCH", "m107Tan_EPOCH"]};
if (A3EAI_foodLoot isEqualTo []) then {A3EAI_foodLootCount = 0};
if (A3EAI_MiscLoot1 isEqualTo []) then {A3EAI_miscLootCount1 = 0};
if (A3EAI_MiscLoot2 isEqualTo []) then {A3EAI_miscLootCount2 = 0};
if (A3EAI_vestTypes0 isEqualTo []) then {A3EAI_vestTypes0 = ["V_1_EPOCH", "V_2_EPOCH", "V_3_EPOCH", "V_4_EPOCH", "V_5_EPOCH", "V_6_EPOCH", "V_7_EPOCH", "V_8_EPOCH", "V_9_EPOCH", "V_10_EPOCH", "V_11_EPOCH", "V_12_EPOCH", "V_13_EPOCH", "V_14_EPOCH", "V_15_EPOCH", "V_16_EPOCH", "V_17_EPOCH", "V_18_EPOCH", "V_19_EPOCH", "V_20_EPOCH", "V_21_EPOCH", "V_22_EPOCH", "V_23_EPOCH", "V_24_EPOCH", "V_25_EPOCH", "V_26_EPOCH", "V_27_EPOCH", "V_28_EPOCH", "V_29_EPOCH", "V_30_EPOCH", "V_31_EPOCH", "V_32_EPOCH", "V_33_EPOCH", "V_34_EPOCH", "V_35_EPOCH", "V_36_EPOCH", "V_37_EPOCH", "V_38_EPOCH", "V_39_EPOCH", "V_40_EPOCH"]};
if (A3EAI_vestTypes1 isEqualTo []) then {A3EAI_vestTypes1 = ["V_1_EPOCH", "V_2_EPOCH", "V_3_EPOCH", "V_4_EPOCH", "V_5_EPOCH", "V_6_EPOCH", "V_7_EPOCH", "V_8_EPOCH", "V_9_EPOCH", "V_10_EPOCH", "V_11_EPOCH", "V_12_EPOCH", "V_13_EPOCH", "V_14_EPOCH", "V_15_EPOCH", "V_16_EPOCH", "V_17_EPOCH", "V_18_EPOCH", "V_19_EPOCH", "V_20_EPOCH", "V_21_EPOCH", "V_22_EPOCH", "V_23_EPOCH", "V_24_EPOCH", "V_25_EPOCH", "V_26_EPOCH", "V_27_EPOCH", "V_28_EPOCH", "V_29_EPOCH", "V_30_EPOCH", "V_31_EPOCH", "V_32_EPOCH", "V_33_EPOCH", "V_34_EPOCH", "V_35_EPOCH", "V_36_EPOCH", "V_37_EPOCH", "V_38_EPOCH", "V_39_EPOCH", "V_40_EPOCH"]};
if (A3EAI_vestTypes2 isEqualTo []) then {A3EAI_vestTypes2 = ["V_1_EPOCH", "V_2_EPOCH", "V_3_EPOCH", "V_4_EPOCH", "V_5_EPOCH", "V_6_EPOCH", "V_7_EPOCH", "V_8_EPOCH", "V_9_EPOCH", "V_10_EPOCH", "V_11_EPOCH", "V_12_EPOCH", "V_13_EPOCH", "V_14_EPOCH", "V_15_EPOCH", "V_16_EPOCH", "V_17_EPOCH", "V_18_EPOCH", "V_19_EPOCH", "V_20_EPOCH", "V_21_EPOCH", "V_22_EPOCH", "V_23_EPOCH", "V_24_EPOCH", "V_25_EPOCH", "V_26_EPOCH", "V_27_EPOCH", "V_28_EPOCH", "V_29_EPOCH", "V_30_EPOCH", "V_31_EPOCH", "V_32_EPOCH", "V_33_EPOCH", "V_34_EPOCH", "V_35_EPOCH", "V_36_EPOCH", "V_37_EPOCH", "V_38_EPOCH", "V_39_EPOCH", "V_40_EPOCH"]};
if (A3EAI_vestTypes3 isEqualTo []) then {A3EAI_vestTypes3 = ["V_1_EPOCH", "V_2_EPOCH", "V_3_EPOCH", "V_4_EPOCH", "V_5_EPOCH", "V_6_EPOCH", "V_7_EPOCH", "V_8_EPOCH", "V_9_EPOCH", "V_10_EPOCH", "V_11_EPOCH", "V_12_EPOCH", "V_13_EPOCH", "V_14_EPOCH", "V_15_EPOCH", "V_16_EPOCH", "V_17_EPOCH", "V_18_EPOCH", "V_19_EPOCH", "V_20_EPOCH", "V_21_EPOCH", "V_22_EPOCH", "V_23_EPOCH", "V_24_EPOCH", "V_25_EPOCH", "V_26_EPOCH", "V_27_EPOCH", "V_28_EPOCH", "V_29_EPOCH", "V_30_EPOCH", "V_31_EPOCH", "V_32_EPOCH", "V_33_EPOCH", "V_34_EPOCH", "V_35_EPOCH", "V_36_EPOCH", "V_37_EPOCH", "V_38_EPOCH", "V_39_EPOCH", "V_40_EPOCH"]};

diag_log format ["[A3EAI] Verified %1 unique classnames in %2 seconds.",(count _verified),(diag_tickTime - _startTime)];
