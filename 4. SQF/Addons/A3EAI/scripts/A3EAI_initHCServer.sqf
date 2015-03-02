"A3EAI_HCLogin" addPublicVariableEventHandler {
	private ["_HCObject","_versionHC","_requiredVersion"];
	_HCObject = (_this select 1) select 0;
	_versionHC = (_this select 1) select 1;
	if (((owner A3EAI_HCObject) isEqualTo 0) && {!isNull _HCObject}) then {
		_requiredVersion = [configFile >> "CfgPatches" >> "A3EAI","A3EAIVersion",""] call BIS_fnc_returnConfigEntry;
		if (_versionHC isEqualTo _requiredVersion) then {
			A3EAI_HCObject = _HCObject;
			A3EAI_HCObject addEventHandler ["Local",{
				if (_this select 1) then {
					private["_unit"];
					A3EAI_HCIsConnected = false;
					A3EAI_HCObjectOwnerID = 0;
					A3EAI_HCObject = objNull;
					_unit = _this select 0;
					_unit removeAllEventHandlers "Local";
					diag_log format ["Debug: Deleting disconnected headless client unit %1.",typeOf _unit];
					deleteVehicle _unit;
					deleteGroup (group _unit);
				};
			}];
			A3EAI_HCObjectOwnerID = (owner A3EAI_HCObject);
			A3EAI_HCIsConnected = true;
			A3EAI_HC_serverResponse = true;
			A3EAI_HCObjectOwnerID publicVariableClient "A3EAI_HC_serverResponse";
			diag_log format ["Debug: Headless client %1 (owner: %2) logged in successfully.",A3EAI_HCObject,A3EAI_HCObjectOwnerID];
		} else {
			diag_log format ["Debug: Headless client %1 (owner: %2) has wrong A3EAI version %2.",_HCObject,owner _HCObject,_versionHC];
		};
	} else {
		A3EAI_HC_serverResponse = false;
		(owner _HCObject) publicVariableClient "A3EAI_HC_serverResponse";
		diag_log format ["Debug: Rejected connection from HC %1. A headless client is already connected: %2. Requesting client is null object: %3.",(_this select 1),((owner A3EAI_HCObject) isEqualTo 0),isNull _HCObject];
	};
};

"A3EAI_respawnHCGroup" addPublicVariableEventHandler {
	(_this select 1) call A3EAI_addRespawnQueue;
};

diag_log "Debug: Listening for headless client connection...";
