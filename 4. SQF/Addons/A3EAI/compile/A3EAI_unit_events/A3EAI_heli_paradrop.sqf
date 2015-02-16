_unitGroup = _this select 0;
_vehicle = _this select 1;
_targetPlayer = _this select 2;

if (surfaceIsWater (getPosASL _vehicle)) exitWith {};
_cargoAvailable = (_vehicle emptyPositions "cargo") min A3EAI_paraDropAmount;
if (_cargoAvailable > 0) then {

	if (A3EAI_debugLevel > 1) then {diag_log format ["A3EAI Extended Debug: %1 group %2 has enough cargo positions for successful paradrop. Spawning new group ...",typeOf _vehicle,_unitGroup];};
	
	_target = if ((owner _targetPlayer) isEqualTo 0) then {_vehicle} else {_targetPlayer};
	_startPos = getPosASL _target;
	_startPos set [2,0];
	
	_trigger = createTrigger ["EmptyDetector",_startPos];
	_trigger setTriggerArea [600, 600, 0, false];
	_trigger setTriggerActivation ["ANY", "PRESENT", true];
	_trigger setTriggerTimeout [5, 5, 5, true];
	_trigger setTriggerText (format ["Heli AI Reinforcement %1",mapGridPosition _vehicle]);
	_trigger setTriggerStatements ["{if (isPlayer _x) exitWith {1}} count thisList != 0;","","0 = [thisTrigger] spawn A3EAI_despawn_static;"];
	
	_unitLevel = _unitGroup getVariable ["unitLevel",1];
	_paraGroup = ["static"] call A3EAI_createGroup;
	
	//Note: unitGroup: Helicopter group. paraGroup: Parachute group.
	_vehicle allowDamage false;
	
	for "_i" from 1 to _cargoAvailable do {
		_unit = [_paraGroup,_unitLevel,[0,0,0]] call A3EAI_createUnit;
		_vehiclePos = (getPosASL _vehicle);
		_parachute = createVehicle ["Steerable_Parachute_F", [_vehiclePos select 0, _vehiclePos select 1, ((_vehiclePos select 2) min 90)], [], (-10 + (random 10)), "FLY"];
		_unit moveInDriver _parachute;
		_unit call A3EAI_addTempNVG;
		uiSleep 0.5;
	};

	_unitsAlive = {alive _x} count (units _paraGroup);
	_paraGroup setVariable ["groupSize",_unitsAlive,A3EAI_enableHC];
	_paraGroup setVariable ["trigger",_trigger,A3EAI_enableHC];
	
	_trigger setVariable ["isCleaning",false];
	_trigger setVariable ["GroupArray",[_paraGroup]];
	_trigger setVariable ["unitLevel",_unitLevel,A3EAI_enableHC];
	_trigger setVariable ["maxUnits",[_unitsAlive,0]];
	_trigger setVariable ["respawn",false]; //landed AI units should never respawn
	_trigger setVariable ["permadelete",true]; //units should be permanently despawned
	_trigger setVariable ["spawnType","static"];

	[_trigger,"A3EAI_staticTriggerArray"] call A3EAI_updateSpawnCount;
	0 = [_trigger] spawn A3EAI_despawn_static;
	
	_rearm = [_paraGroup,_unitLevel] spawn A3EAI_addGroupManager;
	[_paraGroup,_startPos] call A3EAI_setFirstWPPos;
	0 = [_paraGroup,_startPos,125] spawn A3EAI_BIN_taskPatrol;
	
	_vehicle allowDamage true;
	if (A3EAI_debugLevel > 0) then {diag_log format ["A3EAI Debug: Paradrop group %1 with %2 units deployed at %3 by %4 group %5.",_paraGroup,_cargoAvailable,_startPos,typeOf _vehicle,_unitGroup];};
};
