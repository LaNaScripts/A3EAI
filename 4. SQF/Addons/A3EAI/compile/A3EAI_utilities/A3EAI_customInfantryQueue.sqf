if !((typeName _this) isEqualTo "ARRAY") exitWith {diag_log format ["Error: Wrong arguments sent to %1.",__FILE__]};
if (isNil "A3EAI_customInfantrySpawnQueue") then {
	A3EAI_customInfantrySpawnQueue = [_this];
	_infantryQueue = [] spawn {
		while {!(A3EAI_customInfantrySpawnQueue isEqualTo [])} do {
			(A3EAI_customInfantrySpawnQueue select 0) call A3EAI_createCustomSpawn;
			A3EAI_customInfantrySpawnQueue deleteAt 0;
			uiSleep 1;
		};
		A3EAI_customInfantrySpawnQueue = nil;
	};
} else {
	A3EAI_customInfantrySpawnQueue pushBack _this;
};
