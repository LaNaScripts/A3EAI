/*
		A3EAI_handleDeathEvent
		
		Description: Called when AI unit blood level drops below zero to process unit death.
		
        Usage: [_unit,_killer] call A3EAI_handleDeathEvent;
*/

private["_victim","_killer","_unitGroup","_unitType","_launchWeapon","_launchAmmo","_groupIsEmpty","_unitsAlive","_vehicle","_groupSize"];

_victim = _this select 0;
_killer = _this select 1;

if (_victim getVariable ["deathhandled",false]) exitWith {};
_victim setVariable ["deathhandled",true];

_vehicle = (vehicle _victim);
_unitGroup = (group _victim);

_victim setDamage 1;
{
	_victim removeAllEventHandlers _x;
} count ["Killed","HandleDamage"];

//Check number of units alive, preserve group immediately if empty.
_unitsAlive = ({alive _x} count (units _unitGroup));
_groupIsEmpty = if (_unitsAlive isEqualTo 0) then {_unitGroup call A3EAI_protectGroup; true} else {false};

//Update group size counter
_groupSize = (_unitGroup getVariable ["GroupSize",0]);
if (_groupSize > 0) then {_unitGroup setVariable ["GroupSize",(_groupSize - 1),A3EAI_enableHC]};

//Retrieve group type
_unitType = _unitGroup getVariable ["unitType",""];

call {
	if (_unitType isEqualTo "static") exitWith {
		[_victim,_killer,_unitGroup,_groupIsEmpty] call A3EAI_handleStaticDeath;
		0 = [_victim,_killer,_unitGroup,_unitType,_unitsAlive] call A3EAI_handleDeath_generic;
	};
	if (_unitType isEqualTo "dynamic") exitWith {
		[_victim,_killer,_unitGroup,_groupIsEmpty] call A3EAI_handleDeath_dynamic;
		0 = [_victim,_killer,_unitGroup,_unitType,_unitsAlive] call A3EAI_handleDeath_generic;
	};
	if (_unitType isEqualTo "random") exitWith {
		[_victim,_killer,_unitGroup,_groupIsEmpty] call A3EAI_handleDeath_random;
		0 = [_victim,_killer,_unitGroup,_unitType,_unitsAlive] call A3EAI_handleDeath_generic;
	};
	if (_unitType in ["air","aircustom"]) exitWith {
		[_victim,_unitGroup] call A3EAI_handleAirDeath;
	};
	if (_unitType in ["land","landcustom"]) exitWith {
		0 = [_victim,_killer,_unitGroup,_unitType] call A3EAI_handleDeath_generic;
		[_victim,_unitGroup,_groupIsEmpty] call A3EAI_handleLandDeath;
	};
	if (_unitType isEqualTo "aircrashed") exitWith {};
	if (_groupIsEmpty) then {
		_unitGroup setVariable ["GroupSize",-1,A3EAI_enableHC];
	};
};

if !(isNull _victim) then {
	_launchWeapon = (secondaryWeapon _victim);
	if (_launchWeapon in A3EAI_launcherTypes) then {
		_launchAmmo = getArray (configFile >> "CfgWeapons" >> _launchWeapon >> "magazines") select 0;
		_victim removeWeapon _launchWeapon;
		_victim removeMagazines _launchAmmo;
	};
	_victim removeItems "FirstAidKit";
	if (_victim getVariable ["Remove_NVG",true]) then {_victim removeWeapon "NVG_EPOCH"};

	_victim setVariable ["A3EAI_deathTime",diag_tickTime,A3EAI_enableHC];
	_victim setVariable ["canCheckUnit",false];
	_bodyName = _victim getVariable ["bodyName","An unknown bandit"];

	if (_vehicle isEqualTo (_unitGroup getVariable ["assignedVehicle",objNull])) then {
		_victim setPosASL (getPosASL _victim);
	};
	if ((combatMode _unitGroup) isEqualTo "BLUE") then {_unitGroup setCombatMode "RED"};
	//[_victim] joinSilent grpNull;
	if (A3EAI_deathMessages && {isPlayer _killer}) then {
		_nul = [_killer,_bodyName] spawn A3EAI_sendKillMessage;
	};
};

_victim
