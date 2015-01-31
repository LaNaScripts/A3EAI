if ((typeName _this) != "OBJECT") exitWith {};
private ["_vehicleWeapons","_cursorAim"];
_vehicleWeapons = +(weapons _this);
_vehicleMags = +(magazines _this);
{
	_cursorAim = [configFile >> "CfgWeapons" >> _x,"cursorAim",""] call BIS_fnc_returnConfigEntry;
	if ((toLower _cursorAim) in ["missile","rocket"]) then {
		_this removeWeapon _x;
		if (A3EAI_debugLevel > 1) then {diag_log format ["A3EAI Extended Debug: Removed missile/rocket weapon %1 from vehicle %2.",_x,(typeOf _this)];};
	};
} forEach _vehicleWeapons;

//if ((weapons _this) isEqualTo []) then {diag_log format ["WARNING :: All weapons were removed from vehicle %1.",(typeOf _this)]};

true