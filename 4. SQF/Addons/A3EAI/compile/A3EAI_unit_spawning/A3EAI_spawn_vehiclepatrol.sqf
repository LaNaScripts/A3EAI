private ["_marker","_vehicleType","_unitLevel","_unitGroup","_driver","_vehicle","_gunnerSpots","_markerPos","_markerSize","_isAirVehicle","_unitType","_vehSpawnPos","_isArmed","_maxUnits","_maxCargoUnits","_maxGunnerUnits","_keepLooking"];



_vehicleType = _this;

_maxCargoUnits = 0;
_maxGunnerUnits = 0;
_unitLevel = 0;
_isAirVehicle = (_vehicleType isKindOf "Air");
_vehSpawnPos = [];
_spawnMode = "NONE";
_keepLooking = true;
_error = false;
_HCActive = ((owner A3EAI_HCObject) != 0);

call {
	if (_vehicleType isKindOf "Air") exitWith {
		//Note: no cargo units for air vehicles
		_maxGunnerUnits = A3EAI_heliGunnerUnits;
		_unitLevel = "airvehicle" call A3EAI_getUnitLevel;
		_vehSpawnPos = [(getMarkerPos "A3EAI_centerMarker"),300 + (random((getMarkerSize "A3EAI_centerMarker") select 0)),random(360),1] call SHK_pos;
		_vehSpawnPos set [2,150];
		_spawnMode = "FLY";
	};
	if (_vehicleType isKindOf "Car") exitWith {
		_maxGunnerUnits = A3EAI_vehGunnerUnits;
		_maxCargoUnits = A3EAI_vehCargoUnits;
		_unitLevel = "landvehicle" call A3EAI_getUnitLevel;
		while {_keepLooking} do {
			_vehSpawnPos = [(getMarkerPos "A3EAI_centerMarker"),300 + random((getMarkerSize "A3EAI_centerMarker") select 0),random(360),0,[2,750]] call SHK_pos;
			if ((count _vehSpawnPos) > 1) then {
				_playerNear = ({isPlayer _x} count (_vehSpawnPos nearEntities [["Epoch_Male_F","Epoch_Female_F","AllVehicles"], 300]) > 0);
				if(!_playerNear) then {
					_keepLooking = false;	//Found road position, stop searching
				};
			} else {
				if (A3EAI_debugLevel > 0) then {diag_log format ["A3EAI Debug: Unable to find road position to spawn AI %1. Retrying in 30 seconds.",_vehicleType]};
				uiSleep 30; //Couldnt find road, search again in 30 seconds.
			};
		};
	};
	_error = true;
};

if (_error) exitWith {diag_log format ["A3EAI Error: %1 attempted to spawn unsupported vehicle type %2.",__FILE__,_vehicleType]};

_unitType = if (_isAirVehicle) then {"air"} else {"land"};
_unitGroup = [_unitType] call A3EAI_createGroup;
_driver = [_unitGroup,_unitLevel,[0,0,0]] call A3EAI_createUnit;

_vehicle = createVehicle [_vehicleType, _vehSpawnPos, [], 0, _spawnMode];
_vehicle setPos _vehSpawnPos;
_driver moveInDriver _vehicle;

//Run high-priority commands to set up group vehicle
_nul = _vehicle call A3EAI_protectObject;
if !(_vehicle isKindOf "Plane") then {
	_vehicle setDir (random 360);
};

//Determine vehicle armed state
_turretCount = count (configFile >> "CfgVehicles" >> _vehicleType >> "turrets");
_isArmed = ((({!(_x in ["CarHorn","BikeHorn","TruckHorn","TruckHorn2","SportCarHorn","MiniCarHorn"])} count (weapons _vehicle)) > 0) or {(_turretCount > 0)});
//diag_log format ["DEBUG: %1 is armed: %2",(typeOf _vehicle),_isArmed];

//Set variables
_vehicle setVariable ["unitGroup",_unitGroup,_HCActive];
_vehicle setVariable ["RespawnInfo",[_vehicleType,false],_HCActive]; //vehicle type, is custom spawn
_vehicle setVariable ["isArmed",_isArmed,_HCActive];

//Determine vehicle type and add needed eventhandlers
if (_isAirVehicle) then {
	_vehicle setVariable ["durability",[0,0,0],_HCActive];	//[structural, engine, tail rotor]
	_vehicle addEventHandler ["Killed",{_this call A3EAI_heliDestroyed;}];					//Begin despawn process when heli is destroyed.
	_vehicle addEventHandler ["GetOut",{_this call A3EAI_heliLanded;}];	//Converts AI crew to ground AI units.
	_vehicle addEventHandler ["HandleDamage",{_this call A3EAI_handleDamageHeli}];
} else {
	_vehicle addEventHandler ["Killed",{_this call A3EAI_vehDestroyed;}];
	_vehicle addEventHandler ["HandleDamage",{_this call A3EAI_handleDamageVeh}];
};
_vehicle allowCrewInImmobile (!_isAirVehicle);
_vehicle setVehicleLock "LOCKED";
clearWeaponCargoGlobal _vehicle;
clearMagazineCargoGlobal _vehicle;

//Setup group and crew
if (!(_driver hasWeapon "NVG_EPOCH")) then {
	_nvg = _driver call A3EAI_addTempNVG;
};
_driver assignAsDriver _vehicle;
_driver setVariable ["isDriver",true,_HCActive];
_unitGroup selectLeader _driver;

for "_i" from 0 to ((_turretCount min _maxGunnerUnits) - 1) do {
	_gunner = [_unitGroup,_unitLevel,[0,0,0]] call A3EAI_createUnit;
	if (!(_gunner hasWeapon "NVG_EPOCH")) then {
		_nvg = _gunner call A3EAI_addTempNVG;
	};
	_gunner assignAsTurret [_vehicle,[_i]];
	_gunner moveInTurret [_vehicle,[_i]];
};
if (A3EAI_debugLevel > 1) then {diag_log format ["A3EAI Extended Debug: Spawned %1 gunner units for %2 vehicle %3.",(_turretCount min _maxGunnerUnits),_unitGroup,_vehicleType]};

_cargoSpots = _vehicle emptyPositions "cargo";
for "_i" from 0 to ((_cargoSpots min _maxCargoUnits) - 1) do {
	_cargo = [_unitGroup,_unitLevel,[0,0,0]] call A3EAI_createUnit;
	if (!(_cargo hasWeapon "NVG_EPOCH")) then {
		_nvg = _cargo call A3EAI_addTempNVG;
	};
	_cargo assignAsCargo _vehicle;
	_cargo moveInCargo [_vehicle,_i];
};
if (A3EAI_debugLevel > 1) then {diag_log format ["A3EAI Extended Debug: Spawned %1 cargo units for %2 vehicle %3.",(_cargoSpots min _maxCargoUnits),_unitGroup,_vehicleType]};

_unitGroup setBehaviour "AWARE";
_unitGroup setSpeedMode "NORMAL";
_unitGroup setCombatMode "YELLOW";
_unitGroup allowFleeing 0;

_unitGroup setVariable ["unitLevel",_unitLevel,_HCActive];
_unitGroup setVariable ["assignedVehicle",_vehicle,_HCActive];
(units _unitGroup) allowGetIn true;

if (_isAirVehicle) then {
	if (_isArmed) then {
		if (A3EAI_removeMissileWeapons) then {
			_result = _vehicle call A3EAI_clearMissileWeapons; //Remove missile weaponry for air vehicles
		};
	};
};

if (_isAirVehicle) then {
	//Set initial waypoint and begin patrol
	[_unitGroup,0] setWaypointType "MOVE";
	[_unitGroup,0] setWaypointTimeout [0.5,0.5,0.5];
	[_unitGroup,0] setWaypointCompletionRadius 200;
	[_unitGroup,0] setWaypointStatements ["true","[(group this)] spawn A3EAI_heliDetection;"];

	_waypoint = _unitGroup addWaypoint [_vehSpawnPos,0];
	_waypoint setWaypointType "MOVE";
	_waypoint setWaypointTimeout [3,6,9];
	_waypoint setWaypointCompletionRadius 150;
	_waypoint setWaypointStatements ["true","[(group this)] spawn A3EAI_heliStartPatrol;"];
	
	_unitGroup setVariable ["HeliLastParaDrop",diag_tickTime - A3EAI_paraDropCooldown,_HCActive];
	_vehicle flyInHeight 125;
	
	if ((!isNull _vehicle) && {!isNull _unitGroup}) then {
		A3EAI_curHeliPatrols = A3EAI_curHeliPatrols + 1;
		if (A3EAI_debugLevel > 1) then {diag_log format ["A3EAI Extended Debug: Created AI helicopter crew group %1 is now active and patrolling.",_unitGroup];};
	};
} else {
	//Set initial waypoint and begin patrol
	[_unitGroup,0] setWaypointType "MOVE";
	[_unitGroup,0] setWaypointTimeout [5,10,15];
	[_unitGroup,0] setWaypointCompletionRadius 150;
	[_unitGroup,0] setWaypointStatements ["true","[(group this)] spawn A3EAI_vehStartPatrol;"];
	
	if ((!isNull _vehicle) && {!isNull _unitGroup}) then {
		A3EAI_curLandPatrols = A3EAI_curLandPatrols + 1;
		if (A3EAI_debugLevel > 1) then {diag_log format ["A3EAI Extended Debug: Created AI land vehicle crew group %1 is now active and patrolling.",_unitGroup];};
	};
};

if (_isAirVehicle) then {
	[_unitGroup] spawn A3EAI_heliStartPatrol;
} else {
	[_unitGroup] spawn A3EAI_vehStartPatrol;
};
_rearm = [_unitGroup,_unitLevel] spawn A3EAI_addGroupManager;	//start group-level manager

if (A3EAI_debugLevel > 0) then {diag_log format ["A3EAI Debug: Created AI vehicle patrol at %1 with vehicle type %2 with %3 crew units.",_vehSpawnPos,_vehicleType,(count (units _unitGroup))]};

true
