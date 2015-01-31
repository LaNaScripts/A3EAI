/*
	spawnBandits_initialize

*/

private ["_minAI","_addAI","_patrolDist","_trigger","_unitLevel","_numGroups","_triggerPos","_locationArray","_positionArray","_startTime","_triggerStatements","_newTrigger"];



_startTime = diag_tickTime;

_minAI = _this select 0;									//Mandatory minimum number of AI units to spawn
_addAI = _this select 1;									//Maximum number of additional AI units to spawn
_patrolDist = _this select 2;								//Patrol radius from trigger center.
_trigger = _this select 3;									//The trigger calling this script.
_positionArray = _this select 4;							//Array of manually-defined spawn points (markers). If empty, nearby buildings are used as spawn points.
_unitLevel = if ((count _this) > 5) then {_this select 5} else {1};		//(Optional) Select the item probability table to use
_numGroups = if ((count _this) > 6) then {_this select 6} else {1};		//(Optional) Number of groups of x number of units each to spawn

_triggerPos = ASLtoATL getPosASL _trigger;
_locationArray = [];
//If no markers specified in position array, then generate spawn points using building positions (search for buildings within 250m. generate a maximum of 150 positions).
if ((count _positionArray) isEqualTo 0) then {
	private["_nearbldgs","_ignoredObj"];
	_nearbldgs = _triggerPos nearObjects ["HouseBase",250];
	_ignoredObj = missionNamespace getVariable ["A3EAI_ignoredObjects",[]];
	{
		scopeName "bldgloop";
		_pos = ASLtoATL getPosASL _x;
		if (!((typeOf _x) in _ignoredObj) && {!(surfaceIsWater _pos)}) then {
			_locationArray pushBack _pos;
			if (_locationCount >= 150) then {
				breakOut "bldgloop";
			};
		};
	} count _nearbldgs;
	if (A3EAI_debugLevel > 1) then {diag_log format ["A3EAI Extended Debug: Spawn trigger %1 is generating spawn positions from nearby buildings.",triggerText _trigger];};
} else {
	{
		if ((getMarkerColor _x) != "") then {
			_pos = getMarkerPos _x;
				if !(surfaceIsWater _pos) then {
				_locationArray pushBack _pos;
				deleteMarker _x;
			};
		};
	} count _positionArray;
	if (A3EAI_debugLevel > 1) then {diag_log format ["A3EAI Extended Debug: Spawn trigger %1 is generating spawn positions from provided markers.",triggerText _trigger];};
};

_newTrigger = createTrigger ["EmptyDetector", _triggerPos];
_newTrigger setTriggerArea [600, 600, 0, false];
_newTrigger setTriggerActivation ["ANY", "PRESENT", true];
_newTrigger setTriggerTimeout [10, 15, 20, true];
_newTrigger setTriggerText (triggerText _trigger);
_triggerStatements = [
	"{if (isPlayer _x) exitWith {1}} count thisList != 0;",	//Activation condition
	format ["_nul = [%1,%2,%3,thisTrigger,%4,%5,%6] call A3EAI_spawnUnits_static;",_minAI,_addAI,_patrolDist,_positionArray,_unitLevel,_numGroups], //Activation statement
	"_nul = [thisTrigger] spawn A3EAI_despawn_static;" //Deactivation statement
]; 
_newTrigger setVariable ["respawnLimit",(missionNamespace getVariable ["A3EAI_respawnLimit"+str(_unitLevel),5])];
_newTrigger setTriggerStatements _triggerStatements;
0 = [0,_newTrigger,[],_patrolDist,_unitLevel,_locationArray,[_minAI,_addAI]] call A3EAI_initializeTrigger;
//diag_log format ["DEBUG :: Created trigger %1 has statements %2.",triggerText _newTrigger,triggerStatements _newTrigger];
//diag_log format ["DEBUG :: Created trigger %1 has saved statements %2.",triggerText _newTrigger,(_newTrigger getVariable "triggerStatements")];

deleteVehicle _trigger;

if (A3EAI_debugLevel > 0) then {diag_log format["A3EAI Debug: Processed static trigger spawn data in %1 seconds (spawnBandits).",(diag_tickTime - _startTime)];};

true
