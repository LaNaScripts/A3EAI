#define MAX_RSPAWN_ATTEMPTS 2

private ["_maxRandomSpawns","_debugMarkers","_triggerArea","_attempts","_trigPos","_trigger","_markername","_marker"];

_maxRandomSpawns = _this;

_debugMarkers = ((!isNil "A3EAI_debugMarkersEnabled") && {A3EAI_debugMarkersEnabled});
_triggerArea = 600;

if (A3EAI_debugLevel > 0) then {diag_log format ["A3EAI Debug: Attempting to place %1 random spawns on the map...",_maxRandomSpawns];};

for "_i" from 1 to _maxRandomSpawns do {
	_attempts = 0;
	_posCheckFail = true;
	_trigPos = [];
	while {
		(_posCheckFail && {_attempts < 2})
	} do {
		_attempts = _attempts + 1;
		//_trigPos = ["A3EAI_centerMarker",false] call SHK_pos;
		_trigPos = if (_attempts < 2) then {
			_randomLocation = (A3EAI_locations call BIS_fnc_selectRandom2) select 1;
			[_randomLocation,300+(random 300),(random 360),0] call SHK_pos
		} else {
			["A3EAI_centerMarker",0] call SHK_pos
		};
			
		_posCheckFail = (
			(({if ((_trigPos distance _x) < ((size _x) select 0)) exitWith {1}} count (nearestLocations [_trigPos,["Strategic"],1500])) > 0) ||						//Position not in blacklisted area
			{({if ((_trigPos distance _x) < (1200 + A3EAI_minRandSpawnDist)) exitWith {1}} count A3EAI_randTriggerArray) > 0}				//Not too close to another random spawn. x2 to use diameter instead of radius
		);
		if (_posCheckFail && {_attempts < 2}) then {uiSleep 0.25};
	};
	
	if !(_posCheckFail) then {
		_trigger = createTrigger ["EmptyDetector",_trigPos];
		_location = [_trigPos,600] call A3EAI_createBlackListArea;
		_trigger setVariable ["triggerLocation",_location];
		[_trigger,"A3EAI_randTriggerArray"] call A3EAI_updateSpawnCount;
		_spawnParams = _trigPos call A3EAI_getSpawnParams;
		_onActStatements = format ["0 = [150,thisTrigger,thisList,%1,%2,%3] call A3EAI_createRandomInfantrySpawnQueue;",_spawnParams select 0,_spawnParams select 1,_spawnParams select 2];
		_trigger setTriggerArea [_triggerArea, _triggerArea, 0, false];
		_trigger setTriggerActivation ["ANY", "PRESENT", true];
		_trigger setTriggerTimeout [3, 3, 3, true];
		_trigger setTriggerStatements ["{if (isPlayer _x) exitWith {1}} count thisList != 0;",_onActStatements,"[thisTrigger] spawn A3EAI_despawn_random;"];
		if (_debugMarkers) then {
			_markername = str(_trigger);
			_marker = createMarker[_markername,_trigPos];
			_marker setMarkerShape "ELLIPSE";
			_marker setMarkerType "Flag";
			_marker setMarkerBrush "SOLID";
			_marker setMarkerSize [_triggerArea, _triggerArea];
			_marker setMarkerColor "ColorYellow";
			_marker setMarkerAlpha 0.6;
			A3EAI_mapMarkerArray set [(count A3EAI_mapMarkerArray),_marker];
		};
		_trigger setTriggerText format ["Random Spawn at %1",(mapGridPosition _trigger)];
		_trigger setVariable ["timestamp",diag_tickTime];
		if (A3EAI_debugLevel > 0) then {diag_log format["A3EAI Debug: Random spawn %1 of %2 placed at %3 with params %4 (Attempts: %5).",_i,_maxRandomSpawns,_trigPos,_spawnParams,_attempts];};
	} else {
		if (A3EAI_debugLevel > 0) then {diag_log format["A3EAI Debug: Could not find suitable location to place random spawn %1 of %2.",_i,_maxRandomSpawns];};
	};
	uiSleep 3;
};
