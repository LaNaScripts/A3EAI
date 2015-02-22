//Function frequency definitions
#define CLEANDEAD_FREQ 600
#define VEHICLE_CLEANUP_FREQ 900
#define LOCATION_CLEANUP_FREQ 360
#define RANDSPAWN_CHECK_FREQ 360
#define RANDSPAWN_EXPIRY_TIME 1080
#define SIDECHECK_TIME 1200

if (A3EAI_debugLevel > 0) then {diag_log "A3EAI Server Monitor will start in 60 seconds."};

//Initialize timer variables
_currentTime = diag_tickTime;
_cleanDead = _currentTime;
_monitorReport = _currentTime;
_deleteObjects = _currentTime;
_dynLocations = _currentTime;
_checkRandomSpawns = _currentTime - (RANDSPAWN_CHECK_FREQ/2);
_sideCheck = _currentTime;

//Define settings
_reportDynOrVehicles = ((A3EAI_dynMaxSpawns > 0) || {A3EAI_maxHeliPatrols > 0} or {A3EAI_maxLandPatrols > 0} || {A3EAI_maxRandomSpawns > 0});

//Local functions
_getUptime = {
	private ["_currentSec","_outSec","_outMin","_outHour"];
	_currentSec = diag_tickTime;
	_outHour = floor (_currentSec/3600);
	_outMin = floor ((_currentSec - (_outHour*3600))/60);
	_outSec = floor (_currentSec - (_outHour*3600) - (_outMin*60));
	
	[_outHour,_outMin,_outSec]
};

_purgeEH = {
	{_this removeAllEventHandlers _x} count ["Killed","HandleDamage","GetIn","GetOut","Fired"];
};

uiSleep 60;

while {true} do {
	//Main cleanup loop
	_currentTime = diag_tickTime;
	if ((_currentTime - _cleanDead) > CLEANDEAD_FREQ) then {
		_bodiesCleaned = 0;
		_vehiclesCleaned = 0;
		_nullObjects = 0;
		
		//Body/vehicle cleanup loop
		{
			_deathTime = _x getVariable "A3EAI_deathTime";
			/*
			if (!isNil "_deathTime") then {
				diag_log format ["A3EAI Cleanup Debug: Checking unit %1 (%2). diag_tickTime: %3. deathTime: %4.",_x,typeOf _x,diag_tickTime,_deathTime];
				diag_log format ["A3EAI Cleanup Debug: is CAManBase: %1. Timer complete: %2. No players: %3.",(_x isKindOf "CAManBase"),((diag_tickTime - _deathTime) > A3EAI_cleanupDelay),(({isPlayer _x} count (_x nearEntities [["Epoch_Male_F","Epoch_Female_F","Air","Car"],30])) isEqualTo 0)];
			};*/
			if (!isNil "_deathTime") then {
				if (_x isKindOf "CAManBase") then {
					//diag_log "A3EAI Cleanup Debug: Unit type is CAManBase";
					if ((_currentTime - _deathTime) > A3EAI_cleanupDelay) then {
						//diag_log "A3EAI Cleanup Debug: Timer complete, checking for nearby players";
						if (({isPlayer _x} count (_x nearEntities [["Epoch_Male_F","Epoch_Female_F","Air","Car"],30])) isEqualTo 0) then {
							//diag_log "A3EAI Cleanup Debug: No nearby players. Deleting unit";
							_kryptoDevice = _x getVariable ["KryptoDevice",objNull];
							if (!isNull _kryptoDevice) then {deleteVehicle _kryptoDevice};	//Delete Krypto item if not already removed
							_x call _purgeEH;
							//diag_log format ["DEBUG :: Deleting object %1 (type: %2).",_x,typeOf _x];
							deleteVehicle _x;
							_bodiesCleaned = _bodiesCleaned + 1;
						};
					};
				} else {
					if (_x isKindOf "AllVehicles") then {
						if ((_currentTime - _deathTime) > VEHICLE_CLEANUP_FREQ) then {
							if (({isPlayer _x} count (_x nearEntities [["Epoch_Male_F","Epoch_Female_F","Air","Car"],60])) isEqualTo 0) then {
								if (_x in A3EAI_monitoredObjects) then {
									{
										if (!(alive _x)) then {
											deleteVehicle _x;
										};
									} forEach (crew _x);
									//diag_log format ["DEBUG :: Object %1 (type: %2) found in server object monitor.",_x,typeOf _x];
								};
								_x call _purgeEH;
								//diag_log format ["DEBUG :: Deleting object %1 (type: %2).",_x,typeOf _x];
								deleteVehicle _x;
								_vehiclesCleaned = _vehiclesCleaned + 1;
							};
						};
					};
				};
			};
			uiSleep 0.025;
		} count allDead;
		
		//Clean abandoned AI vehicles
		{	
			if (!isNull _x) then {
				private ["_deathTime"];
				_deathTime = _x getVariable "A3EAI_deathTime";
				if (!isNil "_deathTime") then {
					if ((_currentTime - _deathTime) > VEHICLE_CLEANUP_FREQ) then {
						_x call _purgeEH;
						//diag_log format ["DEBUG :: Deleting object %1 (type: %2).",_x,typeOf _x];
						{
							if (!alive _x) then {
								deleteVehicle _x;
							};
						} forEach (crew _x);
						deleteVehicle _x;
						_vehiclesCleaned = _vehiclesCleaned + 1;
						_nullObjects = _nullObjects + 1;
					};
				};
			} else {
				_nullObjects = _nullObjects + 1;
			};
			uiSleep 0.025;
		} count A3EAI_monitoredObjects;

		//Clean server object monitor
		if (_nullObjects > 4) then {
			A3EAI_monitoredObjects = A3EAI_monitoredObjects - [objNull];
			diag_log format ["A3EAI Cleanup: Cleaned up %1 null objects from server object monitor.",_nullObjects];
		};
		if ((_bodiesCleaned + _vehiclesCleaned) > 0) then {diag_log format ["A3EAI Cleanup: Cleaned up %1 dead units and %2 destroyed vehicles.",_bodiesCleaned,_vehiclesCleaned]};
		_cleanDead = _currentTime;
	};

	//Main location cleanup loop
	if ((_currentTime - _dynLocations) > LOCATION_CLEANUP_FREQ) then {
		_locationsDeleted = 0;
		A3EAI_areaBlacklists = A3EAI_areaBlacklists - [locationNull];
		//diag_log format ["DEBUG: A3EAI_areaBlacklists: %1",A3EAI_areaBlacklists];
		//diag_log format ["DEBUG: CurrentTime: %1",_currentTime];
		{
			_deletetime = _x getVariable "deletetime"; 
			if (isNil "_deleteTime") then {_deleteTime = _currentTime}; //since _x getVariable ["deletetime",_currentTime] gives an error...
			//diag_log format ["DEBUG: CurrentTime: %1. Delete Time: %2",_currentTime,_deletetime];
			if (_currentTime > _deletetime) then {
				deleteLocation _x;
				_locationsDeleted = _locationsDeleted + 1;
			};
			uiSleep 0.025;
		} count A3EAI_areaBlacklists;
		A3EAI_areaBlacklists = A3EAI_areaBlacklists - [locationNull];
		if (_locationsDeleted > 0) then {diag_log format ["A3EAI Cleanup: Cleaned up %1 expired temporary blacklist areas.",_locationsDeleted]};
		_dynLocations = _currentTime;
	};

	if ((_currentTime - _checkRandomSpawns) > RANDSPAWN_CHECK_FREQ) then {
		A3EAI_randTriggerArray = A3EAI_randTriggerArray - [objNull];
		{
			if ((((triggerStatements _x) select 1) != "") && {(_currentTime - (_x getVariable ["timestamp",_currentTime])) > RANDSPAWN_EXPIRY_TIME}) then {
				_triggerLocation = _x getVariable ["triggerLocation",locationNull];
				//if (_triggerLocation in A3EAI_areaBlacklists) then {A3EAI_areaBlacklists = A3EAI_areaBlacklists - [_triggerLocation]};
				deleteLocation _triggerLocation;
				if (A3EAI_debugMarkersEnabled) then {deleteMarker (str _x)};	
				deleteVehicle _x;
			};
			if ((_forEachIndex % 3) isEqualTo 0) then {uiSleep 0.05};
		} forEach A3EAI_randTriggerArray;
		A3EAI_randTriggerArray = A3EAI_randTriggerArray - [objNull];
		_spawnsAvailable = A3EAI_maxRandomSpawns - (count A3EAI_randTriggerArray);
		if (_spawnsAvailable > 0) then {
			_nul = _spawnsAvailable spawn A3EAI_setup_randomspawns;
		};
		_checkRandomSpawns = _currentTime;
	};
	
	//Check for unwanted side modifications
	if ((_currentTime - _sideCheck) > SIDECHECK_TIME) then {
		if ((resistance getFriend west) > 0) then {resistance setFriend [west, 0]};
		if ((resistance getFriend east) > 0) then {resistance setFriend [east, 0]};
		if ((east getFriend resistance) > 0) then {east setFriend [resistance, 0]};
		if ((west getFriend resistance) > 0) then {west setFriend [resistance, 0]};
		if ((resistance getFriend resistance) < 1) then {resistance setFriend [resistance, 1]};
		_sideCheck = _currentTime;
	};
	
	if (A3EAI_debugMarkersEnabled) then {
		{
			if ((getMarkerColor _x) != "") then {
				_x setMarkerPos (getMarkerPos _x);
			} else {
				A3EAI_mapMarkerArray set [_forEachIndex,""];
			};
			if ((_forEachIndex % 3) isEqualTo 0) then {uiSleep 0.05};
		} forEach A3EAI_mapMarkerArray;
		A3EAI_mapMarkerArray = A3EAI_mapMarkerArray - [""];
	};
	
	A3EAI_activeGroupAmount = ({!isNull _x} count A3EAI_activeGroups);
	
	//Report statistics to RPT log
	if ((A3EAI_monitorRate > 0) && {((_currentTime - _monitorReport) > A3EAI_monitorRate)}) then {
		_uptime = [] call _getUptime;
		diag_log format ["A3EAI Monitor :: Server Uptime: %1:%2:%3. Server FPS: %4 Active AI Groups: %5.",_uptime select 0, _uptime select 1, _uptime select 2,diag_fps,A3EAI_activeGroupAmount];
		diag_log format ["A3EAI Monitor :: Static Spawns: %1. Respawn Queue: %2 groups queued.",(count A3EAI_staticTriggerArray),(count A3EAI_respawnQueue)];
		if (_reportDynOrVehicles) then {diag_log format ["A3EAI Monitor :: Dynamic Spawns: %1. Random Spawns: %2. Air Patrols: %3. Land Patrols: %4.",(count A3EAI_dynTriggerArray),(count A3EAI_randTriggerArray),A3EAI_curHeliPatrols,A3EAI_curLandPatrols];};
		_monitorReport = _currentTime;
	};

	uiSleep 30;
};
