/*
	
	
*/

private ["_index","_trigger","_targetPlayer","_unitGroup","_reinforcePos","_lastRedirectTime","_helicopter"];

_unitGroup = _this select 0;
_helicopter = _this select 1;

_index = floor (random (count A3EAI_reinforcePlaces));
_trigger = A3EAI_reinforcePlaces select _index;

if ((!isNull _trigger) && {_trigger in A3EAI_dynTriggerArray}) then {
	_targetPlayer = _trigger getVariable "targetplayer";
	if ((!isNil "_targetPlayer") && {!((owner _targetPlayer) isEqualTo 0)}) then {
		_targetPlayerVehicle = (vehicle _targetPlayer);
		if ((_targetPlayerVehicle distance _trigger) < 300) then {
			_targetPlayerVehicleCrew = (crew _targetPlayerVehicle);
			if (({if ("EpochRadio0" in (assignedItems _x)) exitWith {1}} count _targetPlayerVehicleCrew) > 0) then {
				_radioText = format ["Warning: Hostile %1 inbound.",[configFile >> "CfgVehicles" >> (typeOf _helicopter),"textSingular","helicopter"] call BIS_fnc_returnConfigEntry];
				{
					[_x,_radioText] call A3EAI_radioSend;
				} forEach _targetPlayerVehicleCrew;
			};
		};
	};
	_reinforcePos = (getPosASL _trigger);
	A3EAI_reinforcePlaces set [_index,objNull];
	A3EAI_reinforcePlaces = A3EAI_reinforcePlaces - [objNull];
	[_unitGroup,0] setWPPos _reinforcePos; 
	[_unitGroup,1] setWPPos _reinforcePos;
	_unitGroup setVariable ["HeliReinforceOrdered",true];
	[_unitGroup,1] setWaypointTimeout [10,15,20];

	_unitGroup setCurrentWaypoint [_unitGroup,0];
	if (A3EAI_debugLevel > 1) then {diag_log format ["A3EAI Extended Debug: Helicopter %1 (%2) redirected to dynamic spawn area at %3.",_helicopter,(typeOf _helicopter),mapGridPosition _reinforcePos]};
};
A3EAI_reinforcePlaces set [_index,objNull];
A3EAI_reinforcePlaces = A3EAI_reinforcePlaces - [objNull];

true
