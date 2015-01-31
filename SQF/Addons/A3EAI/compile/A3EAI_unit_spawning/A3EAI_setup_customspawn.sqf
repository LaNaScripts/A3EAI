private ["_spawnName","_patrolRadius","_trigStatements","_trigger","_respawn","_unitLevel","_totalAI","_respawnTime"];
	
_spawnName = _this select 0;
_spawnPos = _this select 1;
_patrolRadius = _this select 2;
_totalAI = _this select 3;
_unitLevel = _this select 4;
_respawn = _this select 5;
_respawnTime = _this select 6;

_trigStatements = format ["0 = [%1,0,%2,thisTrigger,%3,%4] call A3EAI_spawnBandits_custom;",_totalAI,_patrolRadius,_unitLevel,_spawnName];
_trigger = createTrigger ["EmptyDetector", _spawnPos];
_trigger setTriggerArea [600, 600, 0, false];
_trigger setTriggerActivation ["ANY", "PRESENT", true];
_trigger setTriggerTimeout [5, 5, 5, true];
_trigger setTriggerText _spawnName;
_trigger setTriggerStatements ["{if (isPlayer _x) exitWith {1}} count thisList != 0;",_trigStatements,"0 = [thisTrigger] spawn A3EAI_despawn_static;"];
_trigger setVariable ["respawn",_respawn];
_trigger setVariable ["spawnmarker",_spawnName];
if (_respawnTime > 0) then {_trigger setVariable ["respawnTime",_respawnTime];};
//diag_log format ["DEBUG :: %1",_trigStatements];

if (A3EAI_debugLevel > 0) then {diag_log format ["A3EAI Debug: Created custom spawn area %1 at %2 with %3 AI units, unitLevel %4, respawn %5, respawn time %6.",_spawnName,mapGridPosition _trigger,_totalAI,_unitLevel,_respawn,_respawnTime];};

_trigger
