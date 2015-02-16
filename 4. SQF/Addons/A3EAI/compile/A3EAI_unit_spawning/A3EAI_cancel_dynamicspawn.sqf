private["_trigger"];
_trigger = _this;

A3EAI_dynTriggerArray = A3EAI_dynTriggerArray - [_trigger];
_playerUID = _trigger getVariable "targetplayerUID";
if (!isNil "_playerUID") then {A3EAI_failedDynamicSpawns pushBack _playerUID};
if (A3EAI_debugMarkersEnabled) then {deleteMarker str(_trigger)};

deleteVehicle _trigger;

false
