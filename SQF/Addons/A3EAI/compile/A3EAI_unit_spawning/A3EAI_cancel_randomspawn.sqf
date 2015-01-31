private["_trigger","_triggerLocation"];
_trigger = _this;

[_trigger,"A3EAI_randTriggerArray"] call A3EAI_updateSpawnCount;
if ((!isNil "A3EAI_debugMarkersEnabled") && {A3EAI_debugMarkersEnabled}) then {deleteMarker (str _trigger)};

_triggerLocation = _trigger getVariable "triggerLocation";
deleteLocation _triggerLocation;
deleteVehicle _trigger;

false
