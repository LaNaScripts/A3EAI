if !((typeName _this) isEqualTo "ARRAY") exitWith {diag_log format ["Error: Wrong arguments sent to %1.",__FILE__]};
private ["_trigger", "_grpArray", "_infantryQueue", "_continue","_triggerStatements"];

_trigger = _this select 3;
_grpArray = _trigger getVariable ["GroupArray",[]];	

if (_grpArray isEqualTo []) then {
	if (isNil "A3EAI_customInfantrySpawnQueue") then {
		A3EAI_customInfantrySpawnQueue = [_this];
		_infantryQueue = [] spawn {
			//uiSleep 0.5;
			_continue = true;
			while {_continue} do {
				private ["_args","_trigger"];
				_args = (A3EAI_customInfantrySpawnQueue select 0);
				_trigger = _args select 3;
				if (triggerActivated _trigger) then {
					_trigger setVariable ["isCleaning",false];
					_triggerStatements = (triggerStatements _trigger);
					_triggerStatements set [1,""];
					_trigger setTriggerStatements _triggerStatements;
					[_trigger,"A3EAI_staticTriggerArray"] call A3EAI_updateSpawnCount;
					0 = _args call A3EAI_spawnBandits_custom;
					if ((!isNil "A3EAI_debugMarkersEnabled") && {A3EAI_debugMarkersEnabled}) then {_nul = _trigger call A3EAI_addMapMarker;};
					uiSleep 1;
				};
				A3EAI_customInfantrySpawnQueue deleteAt 0;
				_continue = !(A3EAI_customInfantrySpawnQueue isEqualTo []);
			};
			A3EAI_customInfantrySpawnQueue = nil;
		};
	} else {
		A3EAI_customInfantrySpawnQueue pushBack _this;
	};
};

true