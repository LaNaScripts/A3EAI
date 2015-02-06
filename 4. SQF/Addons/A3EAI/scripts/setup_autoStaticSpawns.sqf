//Generates static spawns for maps that A3EAI is not configured to support

waitUntil {uiSleep 3; !isNil "A3EAI_locations_ready"};

if (A3EAI_debugLevel > 0) then {diag_log format ["A3EAI Debug: A3EAI is generating static spawns."];};

_spawnsCreated = 0;
_startTime = diag_tickTime;
//_ignoredObj = missionNamespace getVariable ["A3EAI_ignoredObjects",[]];

{
	private ["_placeName","_placePos","_placeType"];
	_placeName = _x select 0;
	_placePos = _x select 1;
	_placeType = _x select 2;
	
	if (!(surfaceIsWater _placePos)) then {
		private ["_nearbldgs"];
		_nearbldgs = _placePos nearObjects ["HouseBase",250];
		if ((count _nearbldgs) > 20) then {
			_spawnPositions = [];
			_spawnPoints = 0;
			{
				scopeName "bldgloop";
				_pos = ASLtoATL getPosASL _x;
				if (!(surfaceIsWater _pos) && {(sizeOf (typeOf _x)) > 15}) then {
					_spawnPositions pushBack _pos;
					_spawnPoints = _spawnPoints + 1;
				};
				if (_spawnPoints > 149) then {
					breakOut "bldgloop";
				};
			} count _nearbldgs;
			if ((count _spawnPositions) > 9) then {
				_aiCount = [1,0];
				_unitLevel = 0;
				_patrolRad = 100;
				call {
					if (_placeType isEqualTo "NameCityCapital") exitWith {
						_aiCount = [A3EAI_minAI_capitalCity,A3EAI_addAI_capitalCity];
						_unitLevel = A3EAI_unitLevel_capitalCity;
						_patrolRad = 200;
					};
					if (_placeType isEqualTo "NameCity") exitWith {
						_aiCount = [A3EAI_minAI_city,A3EAI_addAI_city];
						_unitLevel = A3EAI_unitLevel_city;
						_patrolRad = 175;
					};
					if (_placeType isEqualTo "NameVillage") exitWith {
						_aiCount = [A3EAI_minAI_village,A3EAI_addAI_village];
						_unitLevel = A3EAI_unitLevel_village;
						_patrolRad = 125;
					};
					if (_placeType isEqualTo "NameLocal") exitWith {
						_aiCount = [A3EAI_minAI_remoteArea,A3EAI_addAI_remoteArea];
						_unitLevel = A3EAI_unitLevel_remoteArea;
						_patrolRad = 150;
					};
				};
				if (((missionNamespace getVariable ["A3EAI_spawnChance"+str(_unitLevel),0]) > 0) && {!(_aiCount isEqualTo [0,0])}) then {
					_trigger = createTrigger ["EmptyDetector", _placePos];
					_trigger setTriggerArea [600, 600, 0, false];
					_trigger setTriggerActivation ["ANY", "PRESENT", true];
					_trigger setTriggerTimeout [5, 5, 5, true];
					_trigger setTriggerText _placeName;
					_statements = format ["0 = [%1,%2,%3,thisTrigger,[],%4] call A3EAI_createInfantryQueue;",_aiCount select 0,_aiCount select 1,_patrolRad,_unitLevel];
					_trigger setTriggerStatements ["{if (isPlayer _x) exitWith {1}} count thisList != 0;", _statements, "0 = [thisTrigger] spawn A3EAI_despawn_static;"];
					_trigger setVariable ["respawnLimit",(missionNamespace getVariable ["A3EAI_respawnLimit"+str(_unitLevel),5])];
					0 = [0,_trigger,[],_patrolRad,_unitLevel,_spawnPositions,_aiCount] call A3EAI_initializeTrigger;
					_spawnsCreated = _spawnsCreated + 1;
				};
			};
		};
	};
	uiSleep 0.25;
} forEach A3EAI_locations;

if (A3EAI_debugLevel > 0) then {diag_log format ["A3EAI Debug: %1 has finished generating %2 static spawns in %3 seconds.",__FILE__,_spawnsCreated,(diag_tickTime - _startTime)];};
