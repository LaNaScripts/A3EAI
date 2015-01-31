if (isServer) exitWith {};

#include "A3EAI_client_version.txt"

call compile preprocessFileLineNumbers "A3EAI_Client\A3EAI_client_config.sqf";

if (A3EAIC_radio) then {
	"A3EAI_SMS" addPublicVariableEventHandler {
		_sound = format ["UAV_0%1",(floor (random 5) + 1)];
		playSound [_sound,true];
		if ((_this select 1) != "") then {systemChat (_this select 1);};
	};
};

if (A3EAIC_deathMessages) then {
	"A3EAI_killMSG" addPublicVariableEventHandler {
		systemChat (format ["%1 was killed",(_this select 1)]);
		//diag_log format ["A3EAI Debug: %1 was killed.",(_this select 1)];
	};
};

diag_log format ["[A3EAI] Initialized %1 version %2. Radio enabled: %3. Kill messages: %4.",A3EAI_CLIENT_TYPE,A3EAI_CLIENT_VERSION,A3EAIC_radio,A3EAIC_deathMessages];
