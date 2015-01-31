//Respawn handler stage 2
#define PROCESSING_WAIT_TIME 5 //Minimum time delay between respawns.

waitUntil {uiSleep 3; diag_tickTime > A3EAI_nextRespawnTime};

A3EAI_respawnActive = true;							//First respawn is now being processed, so deny subsequent attempts to modify the initial wait time.
A3EAI_queueActive = nil;
A3EAI_nextRespawnTime = nil;

while {(count A3EAI_respawnQueue) > 0} do {
	private ["_minDelay","_delay"];

	_minDelay = -1;
	//diag_log format ["DEBUG: Contents of respawn queue before cleanup stage 1: %1.",A3EAI_respawnQueue];
	//Remove expired entries before proceeding.
	{
		if (((typeName (_x select 3)) isEqualTo "GROUP") && {(isNull (_x select 3))}) then {
			A3EAI_respawnQueue set [_forEachIndex,objNull];
		};
	} forEach A3EAI_respawnQueue;
	//diag_log format ["DEBUG: Contents of respawn queue before cleanup stage 2: %1.",A3EAI_respawnQueue];
	if (objNull in A3EAI_respawnQueue) then {
		A3EAI_respawnQueue = A3EAI_respawnQueue - [objNull];
		//diag_log "DEBUG :: Cleaned despawned groups from respawn queue.";
	};
	//diag_log format ["DEBUG: Contents of respawn queue after cleanup: %1.",A3EAI_respawnQueue];
	
	//Begin examining queue entries.
	for "_i" from 0 to ((count A3EAI_respawnQueue) - 1) do {
		_timeToRespawn = (A3EAI_respawnQueue select _i) select 0;
		//If enough time has passed to respawn the group.
		if (diag_tickTime > _timeToRespawn) then {
			_mode = (A3EAI_respawnQueue select _i) select 1;
			call {
				if (_mode isEqualTo 0) exitWith {
					//Infantry AI respawn
					_trigger = (A3EAI_respawnQueue select _i) select 2;
					_unitGroup = (A3EAI_respawnQueue select _i) select 3;
					_grpArray = _trigger getVariable ["GroupArray",[]];
					if ((_unitGroup in _grpArray) && {((_unitGroup getVariable ["GroupSize",0]) isEqualTo 0)}) then {
						if ((triggerStatements _trigger select 1) isEqualTo "") then {
							//Trigger is active, so respawn the group
							_maxUnits = _trigger getVariable ["maxUnits",[1,0]];
							_respawned = [_unitGroup,_trigger,_maxUnits] call A3EAI_respawnGroup;
							if ((A3EAI_debugLevel > 0) && {!_respawned}) then {diag_log format ["A3EAI Debug: No units were respawned for group %1 at %2. Group %1 reinserted into respawn queue.",_unitGroup,(triggerText _trigger)];};
						} else {
							//Trigger is inactive (despawned or deleted) so clean up group instead
							if (A3EAI_debugLevel > 0) then {diag_log format ["A3EAI Debug: Spawn area %1 has already been despawned. Cleaning up group %2.",triggerText _trigger,_unitGroup]};
							_unitGroup call A3EAI_deleteGroup;
							if (!isNull _trigger) then {
								_trigger setVariable ["GroupArray",_grpArray - [grpNull]];
							};
						};
					};
				};
				if (_mode isEqualTo 1) exitWith {
					//Custom vehicle AI respawn
					_respawnParams = (A3EAI_respawnQueue select _i) select 2;
					_nul = _respawnParams spawn A3EAI_spawnVehicle_custom;
					if (A3EAI_debugLevel > 0) then {diag_log format ["A3EAI Debug: Respawning custom AI vehicle patrol with params %1",((A3EAI_respawnQueue select _i) select 2)]};
				};
				if (_mode isEqualTo 2) exitWith {
					//Vehicle AI patrol respawn
					_vehicleTypeOld = (A3EAI_respawnQueue select _i) select 2;
					if (_vehicleTypeOld isKindOf "Air") then {
						//Air-type vehicle AI patrol respawn
						if ((count A3EAI_heliTypesUsable) isEqualTo 0) then {
							_nul = _vehicleTypeOld spawn A3EAI_spawnVehiclePatrol; 
							if (A3EAI_debugLevel > 0) then {diag_log format ["A3EAI Debug: Respawning AI air vehicle patrol type %1.",_vehicleTypeOld]};
						} else {
							A3EAI_heliTypesUsable set [(count A3EAI_heliTypesUsable),_vehicleTypeOld];
							_index = floor (random (count A3EAI_heliTypesUsable));
							_vehicleTypeNew = A3EAI_heliTypesUsable select _index;						
							_nul = _vehicleTypeNew spawn A3EAI_spawnVehiclePatrol;
							A3EAI_heliTypesUsable set [_index,objNull];
							A3EAI_heliTypesUsable = A3EAI_heliTypesUsable - [objNull];
							if (A3EAI_debugLevel > 0) then {diag_log format ["A3EAI Debug: Respawning AI air vehicle type patrol %1.",_vehicleTypeNew]};
						};
					} else {
						if (_vehicleTypeOld isKindOf "LandVehicle") then {
							//Land-type vehicle AI patrol respawn
							if ((count A3EAI_heliTypesUsable) isEqualTo 0) then {
								_nul = _vehicleTypeOld spawn A3EAI_spawnVehiclePatrol;
								if (A3EAI_debugLevel > 0) then {diag_log format ["A3EAI Debug: Respawning AI land vehicle patrol type %1.",_vehicleTypeOld]};
							} else {
								A3EAI_vehTypesUsable set [(count A3EAI_vehTypesUsable),_vehicleTypeOld];
								_index = floor (random (count A3EAI_vehTypesUsable));
								_vehicleTypeNew = A3EAI_vehTypesUsable select _index;	
								_nul = _vehicleTypeNew spawn A3EAI_spawnVehiclePatrol;
								A3EAI_vehTypesUsable set [_index,objNull];
								A3EAI_vehTypesUsable = A3EAI_vehTypesUsable - [objNull];
								if (A3EAI_debugLevel > 0) then {diag_log format ["A3EAI Debug: Respawning AI land vehicle patrol type %1.",_vehicleTypeNew]};
							};
						};
					};
				};
			};
			A3EAI_respawnQueue set [_i,objNull];
			uiSleep PROCESSING_WAIT_TIME;
		} else {
			//Find shortest delay to next group respawn.
			_delay = ((_timeToRespawn - diag_tickTime) max PROCESSING_WAIT_TIME);
			//diag_log format ["DEBUG :: Comparing new respawn time %1 with previous %2.",_delay,_minDelay];
			if (_minDelay > 0) then {
				//If next delay time is smaller than the current minimum delay, use it instead.
				if (_delay < _minDelay) then {
					_minDelay = _delay;
					//diag_log format ["DEBUG :: Found shorter respawn interval: %1 seconds.",_minDelay];
				};
			} else {
				//Initialize minimum delay to first found delay.
				_minDelay = _delay;
				//diag_log format ["DEBUG :: Set respawn interval to %1 seconds.",_minDelay];
			};
		};
	};
	//Remove processed entries
	if (objNull in A3EAI_respawnQueue) then {
		A3EAI_respawnQueue = A3EAI_respawnQueue - [objNull];
		//diag_log "DEBUG :: Cleaned respawned groups from respawn queue.";
	};
	if (_minDelay > -1) then {
		if (A3EAI_debugLevel > 0) then {diag_log format ["A3EAI Debug: %1 groups left in respawn queue. Next group is scheduled to respawn in %2 seconds.",(count A3EAI_respawnQueue),_minDelay];};
		uiSleep _minDelay;
	};
};

A3EAI_respawnActive = nil;
if (A3EAI_debugLevel > 0) then {diag_log "A3EAI Debug: Respawn queue is empty. Exiting respawn handler. (respawnHandler)";};
