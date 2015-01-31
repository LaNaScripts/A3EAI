
waitUntil {uiSleep 1; !isNil "A3EAI_locations_ready"};

for "_i" from 0 to ((count A3EAI_spawnAreaBlacklist) -1) do {
	private ["_area"];
	
	_area = A3EAI_spawnAreaBlacklist select _i;
	if (((typeName _area) isEqualTo "STRING") && {((getMarkerColor _area) != "")}) then {
		private ["_areaSize","_sizeX","_sizeY","_blacklist"];
		_areaSize = getMarkerSize _area;
		_sizeX = if ((_areaSize select 0) > 0) then {_areaSize select 0} else {100};
		_sizeY = if ((_areaSize select 1) > 0) then {_areaSize select 1} else {100};
		//_blacklist = createLocation ["Strategic",getMarkerPos _area,_sizeX,_sizeY];
		_location = [getMarkerPos _area,_sizeX,_sizeY] call A3EAI_createBlackListArea;
	};
	uiSleep 0.001;
};
