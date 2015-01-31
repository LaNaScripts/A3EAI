/*
		A3EAI_heliDestroyed
		
		Description: Called when AI air vehicle is destroyed by collision damage.
		
		Last updated: 12:11 AM 6/17/2014
*/

private ["_helicopter","_unitGroup","_unitLevel"];
_helicopter = _this select 0;

if (_helicopter getVariable ["heli_disabled",false]) exitWith {false};
_helicopter setVariable ["heli_disabled",true];
{_helicopter removeAllEventHandlers _x} count ["HandleDamage","GetOut","Killed"];
_unitGroup = _helicopter getVariable "unitGroup";
[_unitGroup,_helicopter] call A3EAI_respawnAIVehicle;

if !(surfaceIsWater (getPosASL _helicopter)) then {
	_unitLevel = _unitGroup getVariable ["unitLevel",1];
	_unitGroup setVariable ["unitType","aircrashed"];	//Recategorize group as "aircrashed" to prevent AI inventory from being cleared since death is considered suicide.
	{
		if (alive _x) then {
			_x action ["eject",_helicopter];
			_nul = [_x,_x] call A3EAI_handleDeathEvent;
			0 = [_x,_unitLevel] spawn A3EAI_generateLoot;
		} else {
			[_x] joinSilent grpNull;
		};
	} count (units _unitGroup);
};

_unitGroup setVariable ["GroupSize",-1];
if (A3EAI_debugLevel > 0) then {diag_log format ["A3EAI Debug: AI helicopter patrol destroyed at %1",mapGridPosition _helicopter];};

true
