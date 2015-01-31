/*
		A3EAI_heliLanded
		
		Description: Called when AI air vehicle performs a landing. Converts onboard AI crew into static-type units.
		
		Last updated: 12:11 AM 6/17/2014
*/

private ["_helicopter","_trigger","_heliPos","_unitsAlive","_unitGroup","_waypointCount"];
_helicopter = _this select 0;

if (_helicopter getVariable ["heli_disabled",false]) exitWith {};
_helicopter setVariable ["heli_disabled",true];
{_helicopter removeAllEventHandlers _x} count ["HandleDamage","GetOut","Killed"];
_unitGroup = _helicopter getVariable ["unitGroup",(group (_this select 2))];
[_unitGroup,_helicopter] call A3EAI_respawnAIVehicle;

_unitsAlive = {alive _x} count (units _unitGroup);
if (_unitsAlive > 0) then {
	//Convert helicrew units to ground units
	{
		if (alive _x) then {
			if !(canMove _x) then {_x setHit["legs",0]};
			unassignVehicle _x;
		};
	} count (units _unitGroup);
	for "_i" from ((count (waypoints _unitGroup)) - 1) to 0 step -1 do {
		deleteWaypoint [_unitGroup,_i];
	};

	_heliPos = ASLtoATL getPosASL _helicopter;
	0 = [_unitGroup,_heliPos,75] spawn A3EAI_BIN_taskPatrol;
	//(A3EAI_numAIUnits + _unitsAlive) call A3EAI_updateUnitCount;

	//Create area trigger
	_trigger = createTrigger ["EmptyDetector",_heliPos];
	_trigger setTriggerArea [600, 600, 0, false];
	_trigger setTriggerActivation ["ANY", "PRESENT", true];
	_trigger setTriggerTimeout [5, 5, 5, true];
	_trigger setTriggerText (format ["HeliLandingArea_%1",mapGridPosition _helicopter]);
	_trigger setTriggerStatements ["{if (isPlayer _x) exitWith {1}} count thisList != 0;","","0 = [thisTrigger] spawn A3EAI_despawn_static;"];

	//Set required trigger variables and begin despawn
	_trigger setVariable ["isCleaning",false];
	_trigger setVariable ["GroupArray",[_unitGroup]];
	_trigger setVariable ["unitLevel",(_unitGroup getVariable ["unitLevel",3])];
	_trigger setVariable ["maxUnits",[_unitsAlive,0]];
	_trigger setVariable ["respawn",false]; //landed AI units should never respawn
	_trigger setVariable ["permadelete",true]; //units should be permanently despawned
	[_trigger,"A3EAI_staticTriggerArray"] call A3EAI_updateSpawnCount;
	0 = [_trigger] spawn A3EAI_despawn_static;

	_unitGroup setVariable ["unitType","static"]; //convert units to static type
	_unitGroup setVariable ["trigger",_trigger]; //attach trigger object reference to group
	_unitGroup setVariable ["GroupSize",_unitsAlive]; //set group size
	_unitGroup setBehaviour "AWARE";
	if (_unitGroup getVariable ["EnemiesIgnored",false]) then {[_unitGroup,"IgnoreEnemies_Undo"] call A3EAI_forceBehavior};

	if (A3EAI_debugLevel > 0) then {diag_log format ["A3EAI Debug: AI helicopter %1 landed at %2.",typeOf _helicopter,mapGridPosition _helicopter];};
};
