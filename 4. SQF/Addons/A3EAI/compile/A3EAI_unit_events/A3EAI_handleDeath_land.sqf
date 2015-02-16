private ["_victim","_vehicle","_unitGroup","_groupIsEmpty"];

_victim = _this select 0;
_unitGroup = _this select 1;
_groupIsEmpty = _this select 2;

_vehicle = _unitGroup getVariable ["assignedVehicle",objNull];
if (_groupIsEmpty) then {
	if (_vehicle isKindOf "Car") then {
		{_vehicle removeAllEventHandlers _x} count ["HandleDamage","Killed"];
		[_vehicle,(_vehicle getVariable "RespawnInfo")] call A3EAI_respawnAIVehicle;
		if (A3EAI_debugLevel > 0) then {diag_log format ["A3EAI Debug: AI vehicle patrol destroyed, adding vehicle %1 to cleanup queue.",(typeOf _vehicle)];};
	};
	_unitGroup setVariable ["GroupSize",-1,A3EAI_enableHC];
} else {
	if (_victim getVariable ["isDriver",false]) then {
		_groupUnits = (units _unitGroup) - [_victim];
		_newDriver = _groupUnits call BIS_fnc_selectRandom2;	//Find another unit to serve as driver
		if (!isNil "_newDriver") then {
			_nul = [_newDriver,_vehicle] spawn {
				private ["_newDriver","_vehicle"];
				_newDriver = _this select 0;
				_vehicle = _this select 1;
				unassignVehicle _newDriver;
				_newDriver assignAsDriver _vehicle;
				if (_newDriver in _vehicle) then {
					_newDriver moveInDriver _vehicle;
				};
				[_newDriver] orderGetIn true;
				_newDriver setVariable ["isDriver",true];
				if (A3EAI_debugLevel > 0) then {diag_log format ["A3EAI Debug: Replaced driver unit for group %1 vehicle %2.",(group _newDriver),(typeOf _vehicle)];};
			};
		};
	};
};

true
