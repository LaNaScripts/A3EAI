if !((typeName _this) isEqualTo "ARRAY") exitWith {diag_log format ["Error: Wrong arguments sent to %1 (%2).",__FILE__,_this]};
if (A3EAI_createCustomSpawnQueue isEqualTo []) then {
	A3EAI_createCustomSpawnQueue pushBack _this;
	_infantryQueue = [] spawn {
		while {!(A3EAI_createCustomSpawnQueue isEqualTo [])} do {
			(A3EAI_createCustomSpawnQueue select 0) call A3EAI_createCustomSpawn;
			A3EAI_createCustomSpawnQueue deleteAt 0;
			uiSleep 1;
		};
	};
} else {
	A3EAI_createCustomSpawnQueue pushBack _this;
};
