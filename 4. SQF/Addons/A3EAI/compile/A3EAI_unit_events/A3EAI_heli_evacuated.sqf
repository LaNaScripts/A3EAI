
private ["_vehicle","_vehPos","_unitGroup" ,"_queued"];
_vehicle = _this select 0;

if (_vehicle getVariable ["heli_disabled",false]) exitWith {false};
_vehicle setVariable ["heli_disabled",true];
{_vehicle removeAllEventHandlers _x} count ["HandleDamage","GetOut","Killed"];
_unitGroup = _vehicle getVariable "unitGroup";
_queued = [_vehicle,(_vehicle getVariable "RespawnInfo")] call A3EAI_respawnAIVehicle;
_vehPos = getPosATL _vehicle;

if (!surfaceIsWater _vehPos) then {
	private ["_unitsAlive","_trigger","_unitLevel","_units","_waypointCount"];
	_unitLevel = _unitGroup getVariable ["unitLevel",1];
	_units = (units _unitGroup);
	if (((_vehPos select 2) > 60) or {(0.40 call A3EAI_chance)}) then {
		{
			if (alive _x) then {
				unassignVehicle _x;
				_x action ["eject",_vehicle];
			} else {
				0 = [_x,_unitLevel] spawn A3EAI_generateLoot;
			};
		} forEach _units;
		
		_unitsAlive = {alive _x} count _units;
		if (_unitsAlive > 0) then {
			for "_i" from ((count (waypoints _unitGroup)) - 1) to 0 step -1 do {
				deleteWaypoint [_unitGroup,_i];
			};
	
			0 = [_unitGroup,_vehPos,75] spawn A3EAI_BIN_taskPatrol;
			
			//Create area trigger
			_trigger = createTrigger ["EmptyDetector",_vehPos];
			_trigger setTriggerArea [600, 600, 0, false];
			_trigger setTriggerActivation ["ANY", "PRESENT", true];
			_trigger setTriggerTimeout [5, 5, 5, true];
			_trigger setTriggerText (format ["Heli AI Parachute %1",mapGridPosition _vehicle]);
			_trigger setTriggerStatements ["{if (isPlayer _x) exitWith {1}} count thisList != 0;","","0 = [thisTrigger] spawn A3EAI_despawn_static;"];

			//Set required trigger variables and begin despawn
			_trigger setVariable ["isCleaning",false];
			_trigger setVariable ["GroupArray",[_unitGroup]];
			_trigger setVariable ["unitLevel",(_unitGroup getVariable ["unitLevel",3])];
			_trigger setVariable ["maxUnits",[_unitsAlive,0]];
			_trigger setVariable ["respawn",false]; //landed AI units should never respawn
			_trigger setVariable ["permadelete",true]; //units should be permanently despawned
			_trigger setVariable ["spawnType","static"];
			[_trigger,"A3EAI_staticTriggerArray"] call A3EAI_updateSpawnCount;
			0 = [_trigger] spawn A3EAI_despawn_static;

			_unitGroup setVariable ["unitType","static",A3EAI_enableHC];
			_unitGroup setVariable ["trigger",_trigger,A3EAI_enableHC];
			_unitGroup setVariable ["groupSize",_unitsAlive,A3EAI_enableHC];
			
			if (_unitGroup getVariable ["EnemiesIgnored",false]) then {[_unitGroup,"IgnoreEnemies_Undo"] call A3EAI_forceBehavior};
		};
		if (A3EAI_debugLevel > 0) then {diag_log format ["A3EAI Debug: AI %1 group %2 parachuted with %3 surviving units.",(typeOf _vehicle),_unitGroup,_unitsAlive];};
	} else {
		_unitGroup setVariable ["unitType","aircrashed"];
		{
			_x action ["eject",_vehicle];
			_nul = [_x,_x] call A3EAI_handleDeathEvent;
			0 = [_x,_unitLevel] spawn A3EAI_generateLoot;
		} forEach _units;
		_unitGroup setVariable ["GroupSize",-1,A3EAI_enableHC];
		if (A3EAI_debugLevel > 0) then {diag_log format ["A3EAI Debug: AI %1 group %2 parachuted with no surviving units.",(typeOf _vehicle),_unitGroup];};
	};
} else {
	_unitGroup setVariable ["GroupSize",-1,A3EAI_enableHC];
	if (A3EAI_debugLevel > 0) then {diag_log format ["A3EAI Debug: AI %1 group %2 was destroyed over water position.",(typeOf _vehicle),_unitGroup];};
};

true
