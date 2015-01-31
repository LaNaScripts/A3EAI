
waitUntil {uiSleep 0.1; (!isNil "A3EAI_locations_ready" && {!isNil "A3EAI_classnamesVerified"})};

if (A3EAI_maxHeliPatrols > 0) then {
	_nul = [] spawn {
		for "_i" from 0 to ((count A3EAI_heliList) - 1) do {
			_heliType = (A3EAI_heliList select _i) select 0;
			_amount = (A3EAI_heliList select _i) select 1;
			
			if ([_heliType,"vehicle"] call A3EAI_checkClassname) then {
				for "_j" from 1 to _amount do {
					//A3EAI_heliTypesUsable set [count A3EAI_heliTypesUsable,_heliType];
					A3EAI_heliTypesUsable pushBack _heliType;
				};
			} else {
				if (A3EAI_debugLevel > 0) then {diag_log format ["A3EAI Debug: %1 attempted to spawn invalid vehicle type %2.",__FILE__,_heliType];};
			};
		};
		
		if (A3EAI_debugLevel > 0) then {diag_log format ["A3EAI Debug: Assembled helicopter list: %1",A3EAI_heliTypesUsable];};
		
		_maxHelis = (A3EAI_maxHeliPatrols min (count A3EAI_heliTypesUsable));
		for "_i" from 1 to _maxHelis do {
			_index = floor (random (count A3EAI_heliTypesUsable));
			_heliType = A3EAI_heliTypesUsable select _index;
			_nul = _heliType spawn A3EAI_spawnVehiclePatrol;
			A3EAI_heliTypesUsable set [_index,objNull];
			A3EAI_heliTypesUsable = A3EAI_heliTypesUsable - [objNull];
			if (_i < _maxHelis) then {uiSleep 20};
		};
	};
	uiSleep 5;
};

if (A3EAI_maxLandPatrols > 0) then {
	_nul = [] spawn {
		for "_i" from 0 to ((count A3EAI_vehList) - 1) do {
			_vehType = (A3EAI_vehList select _i) select 0;
			_amount = (A3EAI_vehList select _i) select 1;
			
			if ([_vehType,"vehicle"] call A3EAI_checkClassname) then {
				for "_j" from 1 to _amount do {
					//A3EAI_vehTypesUsable set [count A3EAI_vehTypesUsable,_vehType];
					A3EAI_vehTypesUsable pushBack _vehType;
				};
			} else {
				if (A3EAI_debugLevel > 0) then {diag_log format ["A3EAI Debug: %1 attempted to spawn invalid vehicle type %2.",__FILE__,_vehType];};
			};
		};
		
		if (A3EAI_debugLevel > 0) then {diag_log format ["A3EAI Debug: Assembled vehicle list: %1",A3EAI_vehTypesUsable];};
		
		_maxVehicles = (A3EAI_maxLandPatrols min (count A3EAI_vehTypesUsable));
		for "_i" from 1 to _maxVehicles do {
			_index = floor (random (count A3EAI_vehTypesUsable));
			_vehType = A3EAI_vehTypesUsable select _index;
			_nul = _vehType spawn A3EAI_spawnVehiclePatrol;
			A3EAI_vehTypesUsable set [_index,objNull];
			A3EAI_vehTypesUsable = A3EAI_vehTypesUsable - [objNull];
			if (_i < _maxVehicles) then {uiSleep 20};
		};
	};
};
