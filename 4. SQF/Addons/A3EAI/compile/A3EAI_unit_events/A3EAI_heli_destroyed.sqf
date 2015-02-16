/*
		A3EAI_heliDestroyed
		
		Description: Called when AI air vehicle is destroyed by collision damage.
		
		Last updated: 12:11 AM 6/17/2014
*/

private ["_vehicle","_unitGroup","_unitLevel"];
_vehicle = _this select 0;

if (_vehicle getVariable ["heli_disabled",false]) exitWith {false};
_vehicle setVariable ["heli_disabled",true];
{_vehicle removeAllEventHandlers _x} count ["HandleDamage","GetOut","Killed"];
_unitGroup = _vehicle getVariable "unitGroup";
[_vehicle,(_vehicle getVariable "RespawnInfo")] call A3EAI_respawnAIVehicle;

if !(surfaceIsWater (getPosASL _vehicle)) then {
	_unitLevel = _unitGroup getVariable ["unitLevel",1];
	_unitGroup setVariable ["unitType","aircrashed"];	//Recategorize group as "aircrashed" to prevent AI inventory from being cleared since death is considered suicide.
	{
		if (alive _x) then {
			_x action ["eject",_vehicle];
			_nul = [_x,_x] call A3EAI_handleDeathEvent;
			0 = [_x,_unitLevel] spawn A3EAI_generateLoot;
		} else {
			[_x] joinSilent grpNull;
		};
	} count (units _unitGroup);
};

_unitGroup setVariable ["GroupSize",-1,A3EAI_enableHC];
if (A3EAI_debugLevel > 0) then {diag_log format ["A3EAI Debug: AI helicopter patrol destroyed at %1",mapGridPosition _vehicle];};

true
