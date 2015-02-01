private ["_marker","_vehicleType","_unitLevel","_unitGroup","_driver","_vehicle","_gunnerSpots","_spawnPos","_patrolDist","_isAirVehicle","_unitType","_vehiclePosition","_isArmed","_maxUnits","_maxCargoUnits","_maxGunnerUnits","_keepLooking"];

_spawnName = _this select 0;
_spawnPos = _this select 1;
_vehicleType = _this select 2;
_patrolDist = _this select 3;
_maxUnits = _this select 4;
_unitLevel = _this select 5;

_maxCargoUnits = _maxUnits select 0;
_maxGunnerUnits = _maxUnits select 1;
_isAirVehicle = (_vehicleType isKindOf "Air");
_vehiclePosition = [];
_roadSearching = 1; 	//SHK_pos will search for roads, and return random position if none found.
_waterPosAllowed = 0; 	//do not allow water position for land vehicles.
_spawnMode = "NONE";

if (_isAirVehicle) then {
	_roadSearching = 0;				//No need to search for road positions for air vehicles
	_waterPosAllowed = 1; 			//Allow water position for air vehicles
	_spawnMode = "FLY"; 			//set flying mode for air vehicles
	_vehiclePosition set [2,180]; 	//spawn air vehicles in air
	_spawnPos set [2,150]; 			//set marker height in air
	if !(_maxCargoUnits isEqualTo 0) then {_maxCargoUnits = 0}; //disable cargo units for air vehicles
};

_keepLooking = true;
_waitTime = 10;
while {_keepLooking} do {
	_vehiclePosition = [_spawnPos,random _patrolDist,random(360),_waterPosAllowed,[_roadSearching,200]] call SHK_pos;
	if (({if (isPlayer _x) exitWith {1}} count (_vehiclePosition nearEntities [["CAManBase","AllVehicles"],300])) isEqualTo 0) then {
		_keepLooking = false; //safe area found, continue to spawn the vehicle and crew
	} else {
		if (A3EAI_debugLevel > 0) then {diag_log format ["A3EAI Debug: Waiting %1 seconds for area at %2 to have no players nearby to spawn custom AI vehicle %3.",_waitTime,_marker,_vehicleType]};
		uiSleep _waitTime; //wait a while before checking spawn area again. Scaling wait time from 10-30 seconds.
		_waitTime = ((_waitTime + 5) min 60);
	};
};

_unitGroup = [] call A3EAI_createGroup;
_driver = [_unitGroup,_unitLevel,[0,0,0]] call A3EAI_createUnit;

_vehicle = createVehicle [_vehicleType, _vehiclePosition, [], 0, _spawnMode];
_vehicle setPos _vehiclePosition;
_driver moveInDriver _vehicle;

_nul = _vehicle call A3EAI_protectObject;
if !(_vehicle isKindOf "Plane") then {
	_vehicle setDir (random 360);
};

//Set variables
_vehicle setVariable ["unitGroup",_unitGroup];

//Determine vehicle armed state
_turretCount = count (configFile >> "CfgVehicles" >> _vehicleType >> "turrets");
_isArmed = ((({!(_x in ["CarHorn","BikeHorn","TruckHorn","TruckHorn2","SportCarHorn","MiniCarHorn"])} count (weapons _vehicle)) > 0) or {(_turretCount > 0)});

//Determine vehicle type and add needed eventhandlers
if (_isAirVehicle) then {
	_vehicle setVariable ["durability",[0,0,0]];											//[structural, engine, tail rotor]
	_vehicle addEventHandler ["Killed",{_this call A3EAI_heliDestroyed;}];					//Begin despawn process when heli is destroyed.
	_vehicle addEventHandler ["GetOut",{_this call A3EAI_heliLanded;}];						//Converts AI crew to ground AI units.
	_vehicle addEventHandler ["HandleDamage",{_this call A3EAI_handleDamageHeli}];
} else {
	_vehicle addEventHandler ["Killed",{_this call A3EAI_vehDestroyed;}];
	_vehicle addEventHandler ["HandleDamage",{_this call A3EAI_handleDamageVeh}];
};
_vehicle allowCrewInImmobile (!_isAirVehicle);
_vehicle setVehicleLock "LOCKED";
clearWeaponCargoGlobal _vehicle;
clearMagazineCargoGlobal _vehicle;

if (!(_driver hasWeapon "NVGoggles")) then {
	_nvg = _driver call A3EAI_addTempNVG;
};

_driver assignAsDriver _vehicle;
_driver setVariable ["isDriver",true];
_unitGroup selectLeader _driver;

if (_isAirVehicle) then {_vehicle flyInHeight 115};

_cargoSpots = _vehicle emptyPositions "cargo";
for "_i" from 0 to ((_cargoSpots min _maxCargoUnits) - 1) do {
	_cargo = [_unitGroup,_unitLevel,[0,0,0]] call A3EAI_createUnit;
	if (!(_cargo hasWeapon "NVGoggles")) then {
		_nvg = _cargo call A3EAI_addTempNVG;
	};
	_cargo assignAsCargo _vehicle;
	_cargo moveInCargo [_vehicle,_i];
};
if (A3EAI_debugLevel > 1) then {diag_log format ["A3EAI Extended Debug: Spawned %1 cargo units for %2 vehicle %3.",(_cargoSpots min _maxCargoUnits),_unitGroup,_vehicleType]};
	
for "_i" from 0 to ((_turretCount min _maxGunnerUnits) - 1) do {
	_gunner = [_unitGroup,_unitLevel,[0,0,0]] call A3EAI_createUnit;
	[_gunner] joinSilent _unitGroup;
	if (!(_gunner hasWeapon "NVGoggles")) then {
		_nvg = _gunner call A3EAI_addTempNVG;
	}; 
	_gunner assignAsTurret [_vehicle,[_i]];
	_gunner moveInTurret [_vehicle,[_i]];
};
if (A3EAI_debugLevel > 1) then {diag_log format ["A3EAI Extended Debug: Spawned %1 gunner units for %2 vehicle %3.",(_turretCount min _maxGunnerUnits),_unitGroup,_vehicleType]};

_unitGroup setBehaviour "AWARE";
_unitGroup setSpeedMode "NORMAL";
_unitGroup setCombatMode "YELLOW";
_unitGroup allowFleeing 0;

_unitType = if (_isAirVehicle) then {"aircustom"} else {"landcustom"};
_unitGroup setVariable ["unitType",_unitType];
_unitGroup setVariable ["unitLevel",_unitLevel];
_unitGroup setVariable ["assignedVehicle",_vehicle];
_unitGroup setVariable ["isArmed",_isArmed];
_unitGroup setVariable ["spawnParams",_this];
[_unitGroup,0] setWaypointPosition [_spawnPos,0];		//Move group's initial waypoint position away from [0,0,0] (initial spawn position).
(units _unitGroup) allowGetIn true;

0 = [_unitGroup,_unitLevel] spawn A3EAI_addGroupManager;
0 = [_unitGroup,_spawnPos,_patrolDist,false] spawn A3EAI_BIN_taskPatrol;

if (_isAirVehicle) then {
	_awareness = [_vehicle,_unitGroup] spawn A3EAI_customHeliDetect;
	if (_isArmed) then {
		if (A3EAI_removeMissileWeapons) then {
			_result = _vehicle call A3EAI_clearMissileWeapons; //Remove missile weaponry for air vehicles
		};
	};
	if ((!isNull _vehicle) && {!isNull _unitGroup}) then {
		A3EAI_curHeliPatrols = A3EAI_curHeliPatrols + 1;
		if (A3EAI_debugLevel > 1) then {diag_log format ["A3EAI Extended Debug: Custom AI helicopter crew group %1 is now active and patrolling.",_unitGroup];};
	};
} else {
	if ((!isNull _vehicle) && {!isNull _unitGroup}) then {
		A3EAI_curLandPatrols = A3EAI_curLandPatrols + 1;
		if (A3EAI_debugLevel > 1) then {diag_log format ["A3EAI Extended Debug: Custom AI land vehicle crew group %1 is now active and patrolling.",_unitGroup];};
	};
};

if (A3EAI_debugLevel > 0) then {diag_log format ["A3EAI Debug: Created custom vehicle spawn at %1 with vehicle type %2 with %3 crew units.",_spawnName,_vehicleType,(count (units _unitGroup))]};

true
