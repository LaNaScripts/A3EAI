if (isNil "A3EAI_customVehicleSpawnQueue") then {
	A3EAI_customVehicleSpawnQueue = [_this];
	_vehicleQueue = [] spawn {
		//uiSleep 0.5;
		_continue = true;
		while {_continue} do {
			(A3EAI_customVehicleSpawnQueue select 0) call A3EAI_spawnVehicle_custom;
			A3EAI_customVehicleSpawnQueue deleteAt 0;
			uiSleep 3;
			_continue = !(A3EAI_customVehicleSpawnQueue isEqualTo []);
		};
		A3EAI_customVehicleSpawnQueue = nil;
	};
} else {
	A3EAI_customVehicleSpawnQueue pushBack _this;
};
