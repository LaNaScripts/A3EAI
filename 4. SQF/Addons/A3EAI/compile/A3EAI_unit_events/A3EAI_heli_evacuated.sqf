/*
		A3EAI_heliEvacuated
		
		Description: Called when AI air vehicle suffers critical damage. Onboard units are ejected if the vehicle is not above water.
		
		Last updated: 12:11 AM 6/17/2014
*/

private ["_helicopter","_vehPos","_unitGroup"];
_helicopter = _this select 0;

if (_helicopter getVariable ["heli_disabled",false]) exitWith {false};
_helicopter setVariable ["heli_disabled",true];
{_helicopter removeAllEventHandlers _x} count ["HandleDamage","GetOut","Killed"];
_unitGroup = _helicopter getVariable "unitGroup";
[_unitGroup,_helicopter] call A3EAI_respawnAIVehicle;
_vehPos = ASLtoATL getPosASL _helicopter;

if (!surfaceIsWater _vehPos) then {
	private ["_unitsAlive","_trigger","_unitLevel","_units","_waypointCount"];
	_unitLevel = _unitGroup getVariable ["unitLevel",1];
	_units = units _unitGroup;
	if (((_vehPos select 2) > 60) or {(0.40 call A3EAI_chance)}) then {
		{
			if (alive _x) then {
				if !(canMove _x) then {_x setHit["legs",0]};
				_x action ["eject",_helicopter];
				unassignVehicle _x;
			} else {
				0 = [_x,_unitLevel] spawn A3EAI_generateLoot;
			};
		} forEach _units;
		
		_unitsAlive = {alive _x} count _units;
		//(A3EAI_numAIUnits + _unitsAlive) call A3EAI_updateUnitCount;
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
			_trigger setTriggerText (format ["Heli AI Parachute %1",mapGridPosition _helicopter]);
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

			_unitGroup setVariable ["unitType","static"];
			_unitGroup setVariable ["trigger",_trigger];
			_unitGroup setVariable ["groupSize",_unitsAlive];
			
			if (_unitGroup getVariable ["EnemiesIgnored",false]) then {[_unitGroup,"IgnoreEnemies_Undo"] call A3EAI_forceBehavior};
		};
	} else {
		_unitGroup setVariable ["unitType","aircrashed"];
		{
			_x action ["eject",_helicopter];
			_nul = [_x,_x] call A3EAI_handleDeathEvent;
			0 = [_x,_unitLevel] spawn A3EAI_generateLoot;
		} forEach _units;
		_unitGroup setVariable ["GroupSize",-1];
	};
} else {
	//_unitGroup call A3EAI_deleteGroup;
	_unitGroup setVariable ["GroupSize",-1];
};

if (A3EAI_debugLevel > 0) then {diag_log format ["A3EAI Debug: AI helicopter %1 evacuated at %2.",typeOf _helicopter,mapGridPosition _helicopter];};

true
