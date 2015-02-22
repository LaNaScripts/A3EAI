
private ["_vehicle","_unitGroup","_unitsAlive"];
_vehicle = _this select 0;

if (_vehicle getVariable ["veh_disabled",false]) exitWith {};
_vehicle setVariable ["veh_disabled",true];
_unitGroup = _vehicle getVariable "unitGroup";
{_vehicle removeAllEventHandlers _x} count ["HandleDamage","Killed"];
[_vehicle,(_vehicle getVariable "RespawnInfo")] call A3EAI_respawnAIVehicle;
_unitsAlive = {alive _x} count (units _unitGroup);

if (_unitsAlive > 0) then {
	//Restrict patrol area to vehicle wreck
	for "_i" from ((count (waypoints _unitGroup)) - 1) to 0 step -1 do {
		deleteWaypoint [_unitGroup,_i];
	};
	
	_vehPos = getPosATL _vehicle;
	0 = [_unitGroup,_vehPos,100] spawn A3EAI_BIN_taskPatrol;
	
	//Create area trigger
	_trigger = createTrigger ["EmptyDetector",_vehPos];
	_trigger setTriggerArea [600, 600, 0, false];
	_trigger setTriggerActivation ["ANY", "PRESENT", true];
	_trigger setTriggerTimeout [5, 5, 5, true];
	_trigger setTriggerText (format ["Abandoned AI %1 at %2",typeOf _vehicle,mapGridPosition _vehicle]);
	_trigger setTriggerStatements ["{if (isPlayer _x) exitWith {1}} count thisList != 0;","","0 = [thisTrigger] spawn A3EAI_despawn_static;"];

	//Set required trigger variables and begin despawn
	_trigger setVariable ["isCleaning",false];
	_trigger setVariable ["GroupArray",[_unitGroup]];
	_trigger setVariable ["unitLevel",(_unitGroup getVariable ["unitLevel",3])];
	_trigger setVariable ["maxUnits",[_unitsAlive,0]];
	_trigger setVariable ["respawn",false]; //landed AI units should never respawn
	_trigger setVariable ["permadelete",true]; //units should be permanently despawned
	//A3EAI_actTrigs = A3EAI_actTrigs + 1;
	[_trigger,"A3EAI_staticTriggerArray"] call A3EAI_updateSpawnCount;
	//(A3EAI_numAIUnits + _unitsAlive) call A3EAI_updateUnitCount;
	0 = [_trigger] spawn A3EAI_despawn_static;

	_unitGroup setVariable ["unitType","static",A3EAI_enableHC];
	_unitGroup setVariable ["trigger",_trigger,A3EAI_enableHC];
	_unitGroup setVariable ["groupSize",_unitsAlive,A3EAI_enableHC];

	_unitGroup setBehaviour "AWARE";
	
	{
		unassignVehicle _x;
	} forEach (units _unitGroup);
	(units _unitGroup) allowGetIn false;
} else {
	_unitGroup setVariable ["GroupSize",-1,A3EAI_enableHC];
};

if (A3EAI_debugLevel > 0) then {diag_log format ["A3EAI Debug: AI land vehicle patrol destroyed at %1",mapGridPosition _vehicle];};
