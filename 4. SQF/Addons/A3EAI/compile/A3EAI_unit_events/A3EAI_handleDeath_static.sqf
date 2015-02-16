/*
	fnc_staticAIDeath

	Usage: [_victim,_killer,_unitGroup] call A3EAI_handleStaticDeath;
	
	Description: Script is called when an AI unit is killed, and waits for the specified amount of time before respawning the unit into the same group it was part of previously.
	If the killed unit was the last surviving unit of its group, a dummy AI unit is created to occupy the group until a dead unit in the group is respawned.
*/

private ["_victim","_killer","_unitGroup","_trigger","_dummy","_groupIsEmpty"];

_victim = _this select 0;
_killer = _this select 1;
_unitGroup = _this select 2;
_groupIsEmpty = _this select 3;

_trigger = _unitGroup getVariable ["trigger",A3EAI_defaultTrigger];

if (_groupIsEmpty) then {
	if (_trigger getVariable ["respawn",true]) then {
		_respawnCount = _trigger getVariable ["respawnLimit",A3EAI_respawnLimit2];
		if (_respawnCount != 0) then {
			[0,_trigger,_unitGroup] call A3EAI_addRespawnQueue; //If there are still respawns possible... respawn the group
			if (_respawnCount > -1) then {
				_trigger setVariable ["respawnLimit",(_respawnCount - 1),A3EAI_enableHC]; //If respawns are limited, decrease respawn counter
				if (A3EAI_debugLevel > 0) then {diag_log format["A3EAI Debug: Respawns remaining for group %1: %2.",_unitGroup,(_unitGroup getVariable ["respawnLimit",-1])];};
			};
		} else {
			_trigger setVariable ["permadelete",true,A3EAI_enableHC];	//deny respawn and delete trigger on next despawn.
		};
	} else {
		if (A3EAI_debugMarkersEnabled) then {deleteMarker str(_trigger)};
		_nul = _trigger spawn {
			_trigger = _this;
			_trigger setTriggerStatements ["this","true","false"]; //Disable trigger from activating or deactivating while cleanup is performed
			if (A3EAI_debugLevel > 0) then {diag_log format["A3EAI Debug: Deleting custom-defined AI spawn %1 at %2 in 30 seconds.",triggerText _trigger, mapGridPosition _trigger];};
			uiSleep 30;
			{
				_x setVariable ["GroupSize",-1,A3EAI_enableHC];
			} forEach (_trigger getVariable ["GroupArray",[]]);
			deleteMarker (_trigger getVariable ["spawnmarker",""]);
			[_trigger,"A3EAI_staticTriggerArray"] call A3EAI_updateSpawnCount;
			deleteVehicle _trigger;
		};
	};
} else {
	if (!(_trigger getVariable ["respawn",true])) then {
		_maxUnits = _trigger getVariable ["maxUnits",[0,0]]; //Reduce maximum AI for spawn trigger for each AI killed for non-respawning spawns.
		_maxUnits set [0,(_maxUnits select 0) - 1];
		if (A3EAI_debugLevel > 1) then {diag_log format["A3EAI Extended Debug: MaxUnits variable for group %1 set to %2.",_unitGroup,_maxUnits];};
	};
};

_unitLevelEffective = (_trigger getVariable ["unitLevelEffective",3]);
if (_unitLevelEffective < 3) then {
	_promoteChance = (missionNamespace getVariable ["A3EAI_promoteChances",[0.40,0.20,0.10]]) select (_unitLevelEffective);
	if (_promoteChance call A3EAI_chance) then {
		_trigger setVariable ["unitLevelEffective",(_unitLevelEffective+1),A3EAI_enableHC];
		if (A3EAI_debugLevel > 1) then {diag_log format ["A3EAI Extended Debug: Promoted unitLevel for %1 spawn to %2.",(triggerText _trigger),(_unitLevelEffective+1)];};
	};
};

true
