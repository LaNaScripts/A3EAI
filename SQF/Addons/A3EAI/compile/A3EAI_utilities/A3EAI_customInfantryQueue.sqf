if (isNil "A3EAI_customInfantrySpawnQueue") then {
	A3EAI_customInfantrySpawnQueue = [_this];
	_infantryQueue = [] spawn {
		//uiSleep 0.5;
		_continue = true;
		while {_continue} do {
			(A3EAI_customInfantrySpawnQueue select 0) call A3EAI_createCustomSpawn;
			A3EAI_customInfantrySpawnQueue deleteAt 0;
			uiSleep 3;
			_continue = !(A3EAI_customInfantrySpawnQueue isEqualTo []);
		};
		A3EAI_customInfantrySpawnQueue = nil;
	};
} else {
	A3EAI_customInfantrySpawnQueue pushBack _this;
};
