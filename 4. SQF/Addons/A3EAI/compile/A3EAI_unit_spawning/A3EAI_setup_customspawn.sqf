private ["_spawnName","_patrolDist","_trigStatements","_trigger","_respawn","_unitLevel","_totalAI","_respawnTime"];
	
_spawnName = _this select 0;
_spawnPos = _this select 1;
_patrolDist = _this select 2;
_totalAI = _this select 3;
_unitLevel = _this select 4;
_respawn = _this select 5;
_respawnTime = _this select 6;

if !(_unitLevel in A3EAI_unitLevels) then {_unitLevel = 3;};

if !(surfaceIsWater _spawnPos) then {
	_trigStatements = format ["0 = [%1,0,%2,thisTrigger,%3,%4] call A3EAI_createCustomInfantrySpawnQueue;",_totalAI,_patrolDist,_unitLevel,_respawnTime];
	_trigger = createTrigger ["EmptyDetector", _spawnPos];
	_trigger setTriggerArea [600, 600, 0, false];
	_trigger setTriggerActivation ["ANY", "PRESENT", true];
	_trigger setTriggerTimeout [5, 5, 5, true];
	_trigger setTriggerText _spawnName;
	_trigger setTriggerStatements ["{if (isPlayer _x) exitWith {1}} count thisList != 0;",_trigStatements,"0 = [thisTrigger] spawn A3EAI_despawn_static;"];
	_trigger setVariable ["respawn",_respawn,A3EAI_enableHC];
	_trigger setVariable ["spawnmarker",_spawnName,A3EAI_enableHC];
	if (_respawnTime > 0) then {_trigger setVariable ["respawnTime",_respawnTime];};

	0 = [3,_trigger,[],_patrolDist,_unitLevel,[],[_totalAI,0]] call A3EAI_initializeTrigger;
	//diag_log format ["DEBUG: triggerstatements variable is %1",_trigger getVariable "triggerStatements"];
	if (A3EAI_debugLevel > 0) then {diag_log format ["A3EAI Debug: Created custom spawn area %1 at %2 with %3 AI units, unitLevel %4, respawn %5, respawn time %6.",_spawnName,mapGridPosition _trigger,_totalAI,_unitLevel,_respawn,_respawnTime];};

	_trigger
} else {
	diag_log format ["A3EAI Error: Unable to create custom spawn %1, position at %2 is water.",_spawnName,_spawnPos];
};