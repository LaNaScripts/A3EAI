/*
	A3EAI Dynamic Spawn Manager
	
	
*/

if (A3EAI_debugLevel > 0) then {diag_log "Starting A3EAI Dynamic Spawn Manager in 2 minutes.";};
uiSleep 120;
//uiSleep 30; //FOR DEBUGGING
if (A3EAI_debugLevel > 0) then {diag_log "A3EAI V3 Dynamic Spawn Manager started.";};

//Frequency of each cycle
#define SLEEP_DELAY 300
//#define SLEEP_DELAY 60 //FOR DEBUGGING

//Spawn manager database variables
_playerUID_DB = [];			//Database of all collected playerUIDs
_lastSpawned_DB = [];		//Database of timestamps for each corresponding playerUID
_lastOnline_DB = [];		//Database of last online checks

_debugMarkers = ((!isNil "A3EAI_debugMarkersEnabled") && {A3EAI_debugMarkersEnabled});

while {true} do {
	if (({isPlayer _x} count playableUnits) > 0) then {
		_allPlayers = [];		//Do not edit
		_currentTime = diag_tickTime;
		{
			if (isPlayer _x) then {
				_playerUID = getPlayerUID _x;
				_playerIndex = _playerUID_DB find _playerUID;
				if (_playerIndex > -1) then {
					_lastSpawned = _lastSpawned_DB select _playerIndex;
					_timePassed = (_currentTime - _lastSpawned);
					if (_timePassed > A3EAI_dynCooldownTime) then {
						if ((_currentTime - (_lastOnline_DB select _playerIndex)) < A3EAI_dynResetLastSpawn) then {
							_allPlayers pushBack _x;
							//diag_log format ["DEBUG: Player %1 added to current cycle dynamic spawn list.",_x];
						};
						_lastOnline_DB set [_playerIndex,_currentTime];
					} else {
						if (_playerUID in A3EAI_failedDynamicSpawns) then {
							_allPlayers pushBack _x;
							//diag_log format ["DEBUG: Player %1 added to current cycle dynamic spawn list.",_x];
							A3EAI_failedDynamicSpawns = A3EAI_failedDynamicSpawns - [_playerUID];
						};
					};
				} else {
					_playerUID_DB pushBack _playerUID;
					_lastSpawned_DB pushBack _currentTime - SLEEP_DELAY;
					_lastOnline_DB pushBack _currentTime;
					//diag_log format ["DEBUG: Player %1 added to dynamic spawn playerUID database.",_x];
				};
				//diag_log format ["DEBUG: Found a player at %1 (%2).",mapGridPosition _x,name _x];
			};
			uiSleep 0.05;
		} forEach playableUnits;
		
		_activeDynamicSpawns = (count A3EAI_dynTriggerArray);
		_playerCount = (count _allPlayers);
		_maxSpawnsPossible = (_playerCount min A3EAI_dynMaxSpawns);	//Can't have more spawns than players (doesn't count current number of dynamic spawns)
		
		if (A3EAI_debugLevel > 1) then {diag_log format ["A3EAI Extended Debug: Preparing to create dynamic spawns with spawn chance %1. %2 dynamic spawns are possible.",A3EAI_dynSpawnChance,_maxSpawnsPossible - _activeDynamicSpawns];};

		while {_allPlayers = _allPlayers - [objNull]; (((_maxSpawnsPossible - _activeDynamicSpawns) > 0) && {(count _allPlayers) > 0})} do {	//_spawns: Have we created enough spawns? _allPlayers: Are there enough players to create spawns for?
			_time = diag_tickTime;
			_player = _allPlayers call BIS_fnc_selectRandom2;
			_playerUID = (getPlayerUID _player);
			if ((alive _player) && {!(_player isKindOf "VirtualMan_EPOCH")}) then {
				_playername = name _player;
				_index = _playerUID_DB find _playerUID;
				if (A3EAI_dynSpawnChance call A3EAI_chance) then {
					_playerPos = ASLtoATL getPosASL _player;
					if (
						!((vehicle _player) isKindOf "Air") &&												//Player must not be in air vehicle
						{({if (_playerPos in _x) exitWith {1}} count (nearestLocations [_playerPos,["Strategic"],1500])) isEqualTo 0} && //Player must not be in blacklisted areas
						//{({(_playerPos distance _x) < 1200} count A3EAI_dynTriggerArray) > 0} &&		
						{(!(surfaceIsWater _playerPos))} && 											//Player must not be on water position
						{((_playerPos distance getMarkerpos "respawn_west") > 2000)} &&					//Player must not be in debug area
						{((_playerPos nearObjects ["PlotPole_EPOCH",125]) isEqualTo [])}					//Player must not be near Epoch buildables
					) then {
						_lastSpawned_DB set [_index,diag_tickTime];
						_trigger = createTrigger ["EmptyDetector",_playerPos];
						_location = [_playerPos,600] call A3EAI_createBlackListArea;
						_spawnParams = _playerPos call A3EAI_getSpawnParams;
						_trigger setVariable ["triggerLocation",_location];
						_trigger setTriggerArea [600, 600, 0, false];
						_trigger setTriggerActivation ["ANY", "PRESENT", true];
						_trigger setTriggerTimeout [3, 3, 3, true];
						_trigger setTriggerText (format ["Dynamic Spawn (Triggered by: %1)",_playername]);
						_trigger setVariable ["targetplayer",_player];
						_trigger setVariable ["targetplayerUID",_playerUID];
						//_trigActStatements = format ["0 = [150,thisTrigger,%1,%2,%3] call A3EAI_spawnUnits_dynamic;",_spawnParams select 0,_spawnParams select 1,_spawnParams select 2];
						_trigger setTriggerStatements ["{if (isPlayer _x) exitWith {1}} count thisList != 0;","", "[thisTrigger] spawn A3EAI_despawn_dynamic;"];
						0 = [150,_trigger,_spawnParams select 0,_spawnParams select 1,_spawnParams select 2] call A3EAI_spawnUnits_dynamic;
						if (_debugMarkers) then {
							_nul = _trigger spawn {
								_marker = str(_this);
								if ((getMarkerColor _marker) != "") then {deleteMarker _marker};
								_marker = createMarker[_marker,(getPosASL _this)];
								_marker setMarkerShape "ELLIPSE";
								_marker setMarkerType "Flag";
								_marker setMarkerBrush "SOLID";
								_marker setMarkerSize [600, 600];
								_marker setMarkerAlpha 0;
							};
						};
						if (((count A3EAI_reinforcePlaces) < A3EAI_curHeliPatrols) && {A3EAI_heliReinforceChance call A3EAI_chance}) then {
							A3EAI_reinforcePlaces pushBack _trigger;
							if (A3EAI_debugLevel > 1) then {diag_log format ["A3EAI Extended Debug: Sending AI helicopter patrol to search for %1.",_playername];};
						};
						if (A3EAI_debugLevel > 0) then {diag_log format ["A3EAI Debug: Created dynamic trigger at %1 with params %2. Triggered by player: %3.",(mapGridPosition _trigger),_spawnParams,_playername];};
					} else {
						if (A3EAI_debugLevel > 1) then {
							diag_log format ["A3EAI Extended Debug: Dynamic spawn conditions failed for player %1:",_playername];
							diag_log format ["DEBUG: Player is not air: %1",!((vehicle _player) isKindOf "Air")];
							diag_log format ["DEBUG: Player not in blacklisted area: %1",(({_playerPos in _x} count (nearestLocations [_playerPos,["Strategic"],1000])) isEqualTo 0)];
							diag_log format ["DEBUG: Player not in water: %1",!(surfaceIsWater _playerPos)];
							diag_log format ["DEBUG: Player not in debug area: %1",((_playerPos distance getMarkerpos "respawn_west") > 2000)];
							diag_log format ["DEBUG: Player not near plot pole/jammer: %1",((_playerPos nearObjects ["PlotPole_EPOCH",125]) isEqualTo [])];
						};
					};
				} else {
					if (A3EAI_debugLevel > 1) then {diag_log format ["A3EAI Extended Debug: Dynamic spawn probability check failed for player %1.",_playername];};
				};
			} else {
				if (A3EAI_debugLevel > 1) then {diag_log format ["A3EAI Extended Debug: Cancel dynamic spawn check for player %1 (Reason: Player not in suitable state).",_player]};
			};
			_allPlayers = _allPlayers - [_player];
			_activeDynamicSpawns = _activeDynamicSpawns + 1;
			if (A3EAI_debugLevel > 1) then {diag_log format ["A3EAI Extended Debug: Processed a spawning probability check in %1 seconds.",diag_tickTime - _time]};
			uiSleep 5;
		};
	} else {
		if (A3EAI_debugLevel > 1) then {diag_log "A3EAI Extended Debug: No players online. Dynamic spawn manager is entering waiting state.";};
	};

	if (A3EAI_debugLevel > 0) then {diag_log format ["A3EAI Debug: Dynamic spawn manager is sleeping for %1 seconds.",SLEEP_DELAY];};
	uiSleep SLEEP_DELAY;
};
