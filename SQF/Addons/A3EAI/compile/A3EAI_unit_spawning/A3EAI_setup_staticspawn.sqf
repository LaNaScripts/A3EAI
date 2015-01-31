/*Syntax: 	[
				_spawnMarker, 		//Circular marker defining patrol radius.
				[_minAI,_addAI],	//(Optional, default [1,1]) Minimum and maximum bonus amount of AI units per group.
				_positionArray,		//(Optional, default []): Array of markers defining possible spawn points. If omitted or left empty, nearby buildings within 250m radius will be used as spawn points.
				_unitLevel,			//(Optional, default 1): Number between 0-3. Defines AI weapon selection and skill parameters.
				_numGroups			//(Optional, default 1): Number of AI groups to spawn using the above parameters.			
			] call A3EAI_setupStaticSpawn;
*/

private ["_spawnMarker","_minAI","_addAI","_positionArray","_unitLevel","_numGroups","_patrolDist","_onActStatements","_trigger","_abort"];

_spawnMarker = _this select 0;
if ((getMarkerColor _spawnMarker) isEqualTo "") exitWith {diag_log format ["A3EAI Error: Static spawn marker %1 does not exist!",_spawnMarker];};
if ((markerAlpha _spawnMarker) > 0) then {_spawnMarker setMarkerAlpha 0};

_abort = true;
if ((count _this) > 1) then {
	_minAI = (_this select 1) select 0;
	_addAI = (_this select 1) select 1;
	if ((_minAI + _addAI) > 0) then {
		_abort = false;
	};
} else {
	_minAI = 1;
	_addAI = 1;
};

if (_abort) exitWith {
	diag_log format ["A3EAI Error: Zero AI amount for spawn area %1. Spawn area not created. (%2)",_spawnMarker,__FILE__];
	
	objNull
};

_positionArray = if ((count _this) > 2) then {_this select 2} else {[]};
_unitLevel = if ((count _this) > 3) then {_this select 3} else {1};
_numGroups = if ((count _this) > 4) then {_this select 4} else {1};

_patrolDist = (getMarkerSize _spawnMarker) select 0;

if !(_unitLevel in [0,1,2,3]) then {_unitLevel = 1};

_onActStatements = format ["_nul = [%1,%2,%3,thisTrigger,%4,%5,%6] call A3EAI_staticSpawn_init;",_minAI,_addAI,_patrolDist,_positionArray,_unitLevel,_numGroups];
_trigger = createTrigger ["EmptyDetector", getMarkerPos(_spawnMarker)];
_trigger setTriggerArea [600, 600, 0, false];
_trigger setTriggerActivation ["ANY", "PRESENT", true];
_trigger setTriggerTimeout [10, 10, 10, true];
_trigger setTriggerText _spawnMarker;
_trigger setTriggerStatements ["{if (isPlayer _x) exitWith {1}} count thisList != 0;",_onActStatements,""];

deleteMarker _spawnMarker;

_trigger
