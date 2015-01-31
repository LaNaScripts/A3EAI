private ["_nearestLocations", "_nearestLocationType", "_spawnParams"];

_nearestLocations = nearestLocations [_this,["NameCityCapital","NameCity","NameVillage","NameLocal"],1500];
_nearestLocationType = if !(_nearestLocations isEqualTo []) then {
	type (_nearestLocations select 0);
} else {
	""; //Position not in range of any categorized location
};
_spawnParams = call {
	if (_nearestLocationType isEqualTo "NameCityCapital") exitWith {[A3EAI_minAI_capitalCity,A3EAI_addAI_capitalCity,A3EAI_unitLevel_capitalCity]};
	if (_nearestLocationType isEqualTo "NameCity") exitWith {[A3EAI_minAI_city,A3EAI_addAI_city,A3EAI_unitLevel_city]};
	if (_nearestLocationType isEqualTo "NameVillage") exitWith {[A3EAI_minAI_village,A3EAI_addAI_village,A3EAI_unitLevel_village]};
	[A3EAI_minAI_remoteArea,A3EAI_addAI_remoteArea,A3EAI_unitLevel_remoteArea]; //Default
};

_spawnParams