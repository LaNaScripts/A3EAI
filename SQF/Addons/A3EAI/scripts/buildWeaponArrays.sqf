/*
	buildWeaponArrays
	
	Description: Do not edit anything in this file unless instructed by the developer.
	
	Last updated: 11:53 AM 6/25/2014
*/

private ["_bldgClasses","_lootItem","_aiWeaponBanList","_lootList","_cfgBuildingLoot","_startTime","_lootConfigFile"];

if (!isNil "A3EAI_weaponsInitialized") exitWith {};

_startTime = diag_tickTime;

_lootConfigFile = if !((A3EAI_customLootTables) && {(isClass (missionConfigFile >> "CfgBuildingLoot"))}) then {
	if (A3EAI_debugLevel > 0) then {diag_log "A3EAI Debug: Building A3EAI weapon arrays using CfgBuildingLoot data."};
	configFile
} else {
	if (A3EAI_debugLevel > 0) then {diag_log "A3EAI Debug: Building A3EAI weapon arrays using custom CfgBuildingLoot data."};
	missionConfigFile
};

_bldgClasses = [
	["Residential","Farm"], //unitLevel 0
	["Military"],			//unitLevel 1
	["MilitarySpecial"],	//unitLevel 2
	["HeliCrash"]];			//unitLevel 3

//Built-in weapon ban list for melee weapons and nonweapon items
_aiWeaponBanList = 
	[
		"Crossbow_DZ","Crossbow","MeleeHatchet","MeleeCrowbar","MeleeMachete","MeleeBaseball","MeleeBaseBallBat","MeleeBaseBallBatBarbed","MeleeBaseBallBatNails","Chainsaw", //Melee weapons
		"ItemMap","Binocular","ItemWatch","ItemCompass","ItemFlashlight","ItemKnife","NVGoggles","ItemGPS","ItemEtool","Binocular_Vector","ItemMatchbox","ItemToolbox", //Non-weapon items
		"ItemKeyKit","ItemMatchbox_DZE" //Epoch items
	];

//Add user-specified banned weapons to A3EAI weapon banlist.
{
	if !(_x in _aiWeaponBanList) then {
		_aiWeaponBanList set [count _aiWeaponBanList,_x];
	};
} count A3EAI_banAIWeapons;
A3EAI_banAIWeapons = nil;
//diag_log format ["DEBUG :: List of weapons to be removed from A3EAI classname tables: %1",_aiWeaponBanList];

//Compatibility with Namalsk's selectable loot table feature.
if (isNil "dayzNam_buildingLoot") then {
	_cfgBuildingLoot = "cfgBuildingLoot";
	if (isClass (_lootConfigFile >> _cfgBuildingLoot >> "Barracks")) then {
		(_bldgClasses select 2) set [((_bldgClasses select 2) find "MilitarySpecial"),"Barracks"];
	};
} else {
	_cfgBuildingLoot = dayzNam_buildingLoot;
	(_bldgClasses select 3) set [((_bldgClasses select 3) find "HeliCrash"),"HeliCrashNamalsk"];
};
//diag_log format ["DEBUG :: _cfgBuildingLoot: %1",_cfgBuildingLoot];

//Compatibility with DayZ 1.7.7's new HeliCrash tables
if ((isClass (_lootConfigFile >> _cfgBuildingLoot >> "HeliCrashWEST")) && {(isClass (_lootConfigFile >> _cfgBuildingLoot >> "HeliCrashEAST"))}) then {
	_bldgClasses set [3,["HeliCrashWEST","HeliCrashEAST"]];
	//diag_log format ["DEBUG :: HeliCrash tables modified: %1",(_bldgClasses select 3)];
};

_lootList = call {
	if (isArray (_lootConfigFile >> _cfgBuildingLoot >> "Default" >> "lootTypeSmall")) exitWith {["lootType","lootTypeSmall"]}; //Epoch 1.0.5 new loot table structure
	if (isArray (_lootConfigFile >> _cfgBuildingLoot >> "Default" >> "lootType")) exitWith {["lootType"]}; //DayZ 1.8.1 and pre-Epoch 1.0.5 loot table structure 
	["itemType"] //Old DayZ loot table structure.
};
//diag_log format ["DEBUG :: _lootList: %1",_lootList];

//Declare all temporary A3EAI weapon arrays. DO NOT EDIT.
_A3EAI_Pistols0_temp = [];
_A3EAI_Pistols1_temp = [];
_A3EAI_Pistols2_temp = [];
_A3EAI_Pistols3_temp = [];

_A3EAI_Rifles0_temp = [];
_A3EAI_Rifles1_temp = [];
_A3EAI_Rifles2_temp = [];
_A3EAI_Rifles3_temp = [];

//Build the weapon arrays.
for "_i" from 0 to (count _bldgClasses - 1) do {					//_i = unitLevel
	for "_j" from 0 to (count (_bldgClasses select _i) - 1) do {	//If each unitLevel has more than 1 building class, investigate them all
		_bldgLoot = [];
		{
			_bldgLoot = _bldgLoot + (getArray (_lootConfigFile >> _cfgBuildingLoot >> ((_bldgClasses select _i) select _j) >> _x));
		} count _lootList;
		{				
			call {
				if ((_x select 1) isEqualTo "weapon") exitWith {
					_weaponItem = _x select 0;
					if (!(_weaponItem in _aiWeaponBanList)) then {
						_itemType = (getNumber (configFile >> "CfgWeapons" >> _weaponItem >> "type"));
						call {
							if (_itemType isEqualTo 1) exitWith {
								call compile format ["_A3EAI_Rifles%1_temp set [(count _A3EAI_Rifles%1_temp),'%2'];",_i,_weaponItem]
							};
							if (_itemType isEqualTo 2) exitWith {
								call compile format ["_A3EAI_Pistols%1_temp set [(count _A3EAI_Pistols%1_temp),'%2'];",_i,_weaponItem];
							};
						};
					};
				};
				if ((_x select 1) isEqualTo "cfglootweapon") exitWith {
					{
						_weaponItem = _x select 0;
						if (!(_weaponItem in _aiWeaponBanList)) then {
							_itemType = (getNumber (configFile >> "CfgWeapons" >> _weaponItem >> "type"));
							call {
								if (_itemType isEqualTo 1) exitWith {
									call compile format ["_A3EAI_Rifles%1_temp set [(count _A3EAI_Rifles%1_temp),'%2'];",_i,_weaponItem]
								};
								if (_itemType isEqualTo 2) exitWith {
									call compile format ["_A3EAI_Pistols%1_temp set [(count _A3EAI_Pistols%1_temp),'%2'];",_i,_weaponItem];
								};
							};
						};
					} count (getArray (_lootConfigFile >> "cfgLoot" >> (_x select 0)));
				};
			};
		} forEach _bldgLoot;
	};
};

//Redefine each prebuilt weapon array if new table is not empty
if ((count _A3EAI_Pistols0_temp) > 0) then {A3EAI_Pistols0 = _A3EAI_Pistols0_temp};
if ((count _A3EAI_Pistols1_temp) > 0) then {A3EAI_Pistols1 = _A3EAI_Pistols1_temp}; //else {A3EAI_Pistols1 = [] + A3EAI_Pistols0};
if ((count _A3EAI_Pistols2_temp) > 0) then {A3EAI_Pistols2 = _A3EAI_Pistols2_temp}; //else {A3EAI_Pistols2 = [] + A3EAI_Pistols1};
if ((count _A3EAI_Pistols3_temp) > 0) then {A3EAI_Pistols3 = _A3EAI_Pistols3_temp} else {A3EAI_Pistols3 = [] + A3EAI_Pistols2};
if ((count _A3EAI_Rifles0_temp) > 0) then {A3EAI_Rifles0 = _A3EAI_Rifles0_temp};
if ((count _A3EAI_Rifles1_temp) > 0) then {A3EAI_Rifles1 = _A3EAI_Rifles1_temp}; //else {A3EAI_Rifles1 = [] + A3EAI_Rifles0};
if ((count _A3EAI_Rifles2_temp) > 0) then {A3EAI_Rifles2 = _A3EAI_Rifles2_temp}; //else {A3EAI_Rifles2 = [] + A3EAI_Rifles1};
if ((count _A3EAI_Rifles3_temp) > 0) then {A3EAI_Rifles3 = _A3EAI_Rifles3_temp} else {A3EAI_Rifles3 = [] + A3EAI_Rifles2};

if (A3EAI_debugLevel > 0) then {
	if (A3EAI_debugLevel > 1) then {
		//Display finished weapon arrays
		diag_log format ["Contents of A3EAI_Pistols0: %1",A3EAI_Pistols0];
		diag_log format ["Contents of A3EAI_Pistols1: %1",A3EAI_Pistols1];
		diag_log format ["Contents of A3EAI_Pistols2: %1",A3EAI_Pistols2];
		diag_log format ["Contents of A3EAI_Pistols3: %1",A3EAI_Pistols3];
		diag_log format ["Contents of A3EAI_Rifles0: %1",A3EAI_Rifles0];
		diag_log format ["Contents of A3EAI_Rifles1: %1",A3EAI_Rifles1];
		diag_log format ["Contents of A3EAI_Rifles2: %1",A3EAI_Rifles2];
		diag_log format ["Contents of A3EAI_Rifles3: %1",A3EAI_Rifles3];
	};
	diag_log format ["A3EAI Debug: Weapon classname tables created in %1 seconds.",(diag_tickTime - _startTime)];
};

A3EAI_weaponsInitialized = true;
