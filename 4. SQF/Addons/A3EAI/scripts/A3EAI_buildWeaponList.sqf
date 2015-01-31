private ["_startTime", "_pistolList", "_rifleList", "_machinegunList", "_sniperList", "_checkWeapon", "_magazineTypes", "_cursorAim", "_ammo", "_ammoHit", "_checkWeaponArray"];

_startTime = diag_tickTime;

_checkWeapon = 
{
	private ["_magazineTypes","_ammo","_ammoMaxRange","_ammoHit"];
	if ((typeName _this) != "STRING") exitWith {false};
	if (_this in A3EAI_dynamicWeaponBlacklist) exitWith {false};
	_magazineTypes = [configFile >> "CfgWeapons" >> _this,"magazines",[]] call BIS_fnc_returnConfigEntry;
	if ((count _magazineTypes) isEqualTo 0) exitWith {false};
	_cursorAim = [configFile >> "CfgWeapons" >> _this,"cursorAim","throw"] call BIS_fnc_returnConfigEntry;
	if (_cursorAim isEqualTo "throw") exitWith {false};
	_ammo = [configFile >> "CfgMagazines" >> (_magazineTypes select 0),"ammo",""] call BIS_fnc_returnConfigEntry;
	if (_ammo isEqualTo "") exitWith {false};
	_ammoHit = [configFile >> "CfgAmmo" >> _ammo,"hit",0] call BIS_fnc_returnConfigEntry;
	if (_ammoHit isEqualTo 0) exitWith {false};
	true
};

_checkWeaponArray = {
	_checkedWeapons = [];
	{
		_weapon = (_x select 0);
		if (_weapon call _checkWeapon) then {
			_checkedWeapons pushBack (_x select 0);
		};
	} forEach _this;
	_checkedWeapons
};

_pistolList = [configFile >> "CfgLootTable" >> "Pistols","items",[]] call BIS_fnc_returnConfigEntry;
_rifleList = [configFile >> "CfgLootTable" >> "Rifle","items",[]] call BIS_fnc_returnConfigEntry;
_machinegunList = [configFile >> "CfgLootTable" >> "Machinegun","items",[]] call BIS_fnc_returnConfigEntry;
_sniperList = [configFile >> "CfgLootTable" >> "SniperRifle","items",[]] call BIS_fnc_returnConfigEntry;

_pistolList = _pistolList call _checkWeaponArray;
_rifleList = _rifleList call _checkWeaponArray;
_machinegunList = _machinegunList call _checkWeaponArray;
_sniperList = _sniperList call _checkWeaponArray;

if !(_pistolList isEqualTo []) then {A3EAI_pistolList = _pistolList} else {diag_log "A3EAI Error: Could not dynamically generate Pistol weapon classname list. Classnames from A3EAI_config.sqf used instead."};
if !(_rifleList isEqualTo []) then {A3EAI_rifleList = _rifleList} else {diag_log "A3EAI Error: Could not dynamically generate Rifle weapon classname list. Classnames from A3EAI_config.sqf used instead."};
if !(_machinegunList isEqualTo []) then {A3EAI_machinegunList = _machinegunList} else {diag_log "A3EAI Error: Could not dynamically Machinegun weapon classname list. Classnames from A3EAI_config.sqf used instead."};
if !(_sniperList isEqualTo []) then {A3EAI_sniperList = _sniperList} else {diag_log "A3EAI Error: Could not dynamically generate Sniper weapon classname list. Classnames from A3EAI_config.sqf used instead."};

if (A3EAI_debugLevel > 0) then {
	if (A3EAI_debugLevel > 1) then {
		//Display finished weapon arrays
		diag_log format ["Contents of A3EAI_pistolList: %1",A3EAI_pistolList];
		diag_log format ["Contents of A3EAI_rifleList: %1",A3EAI_rifleList];
		diag_log format ["Contents of A3EAI_machinegunList: %1",A3EAI_machinegunList];
		diag_log format ["Contents of A3EAI_sniperList: %1",A3EAI_sniperList];
	};
	diag_log format ["A3EAI Debug: Weapon classname tables created in %1 seconds.",(diag_tickTime - _startTime)];
};
