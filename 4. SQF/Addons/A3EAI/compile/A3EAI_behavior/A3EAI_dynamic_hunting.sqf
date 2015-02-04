/*
	A3EAI_dynamicHunting
	
	Description: Used for dynamically spawned AI. Creates a MOVE waypoint directing AI to a random player's position, then uses BIN_taskPatrol to create a circular patrol path around initial spawn position.
	
	Last updated: 2:12 AM 1/11/2014
*/

#define TRANSMIT_RANGE 50 //distance to broadcast radio text around target player (target player will also recieve messages)
#define SEEK_RANGE 450 //distance to chase player from initial group spawn location

private ["_unitGroup","_spawnPos","_waypoint","_patrolDist","_statement","_targetPlayer","_triggerPos","_leader","_nearbyUnits","_radioSpeech","_radioText","_ableToChase","_radioType"];

_unitGroup = _this select 0;
_spawnPos = _this select 1;
_patrolDist = _this select 2;
_targetPlayer = _this select 3;
_triggerPos = _this select 4;

_unitGroup setVariable ["seekActive",true];
{_x enableFatigue false} count (units _unitGroup);
_waypoint = [_unitGroup,0];	//Group will move to waypoint index 0 (first waypoint).
_waypoint setWaypointType "MOVE";
_waypoint setWaypointCompletionRadius 35;
_waypoint setWaypointTimeout [10,12,15];
_waypoint setWPPos (ASLtoATL getPosASL _targetPlayer);
_unitGroup setCurrentWaypoint _waypoint;
//_radioType = _unitGroup getVariable ["AssignedRadio","EpochRadio0"];
_radioType = "EpochRadio0";

if (A3EAI_radioMsgs) then {
	_leader = (leader _unitGroup);
	if ((_unitGroup getVariable ["GroupSize",0]) > 1) then {
		_nearbyUnits = (getPosASL _targetPlayer) nearEntities [["Car","Epoch_Male_F","Epoch_Female_F"],TRANSMIT_RANGE];
		{
			if (isPlayer _x) then {
				if (({if (_radioType in (assignedItems _x)) exitWith {1}} count (crew (vehicle _x))) > 0) then {
					_radioSpeech = ""; //Send only radio sound.
					[_x,_radioSpeech] call A3EAI_radioSend;
				} else {
					if (0.10 call A3EAI_chance) then {
						_radioSpeech = [
							"You feel as if you are being watched...",
							"You feel as if you are being followed...",
							"You feel something isn't quite right..."
						] call BIS_fnc_selectRandom2;
						[_x,_radioSpeech] call A3EAI_radioSend;
					};
				};
			}
		} count _nearbyUnits;
	};
};
uiSleep 10;

//Begin hunting phase
_ableToChase = true;
while {
	_ableToChase &&
	{alive _targetPlayer} && 
	{((_targetPlayer distance _triggerPos) < SEEK_RANGE)}
} do {
	if !(_unitGroup getVariable ["inPursuit",false]) then {
		_leader = (leader _unitGroup);
		if (((getWPPos [_unitGroup,0]) distance _targetPlayer) > 25) then {
			_waypoint setWPPos (ASLtoATL getPosASL _targetPlayer);
			_unitGroup setCurrentWaypoint _waypoint;
			if ((_unitGroup knowsAbout _targetPlayer) < 4) then {_unitGroup reveal [_targetPlayer,4]};
			(units _unitGroup) doTarget _targetPlayer;
			//(units _unitGroup) doFire _targetPlayer;
		};
		if ((A3EAI_radioMsgs) && {0.6 call A3EAI_chance}) then {
			//Warn player of AI bandit presence if they have a radio.
			if (((_unitGroup getVariable ["GroupSize",0]) > 1) && {(_leader distance _targetPlayer) < 250}) then {
				_nearbyUnits = (ASLtoATL getPosASL _targetPlayer) nearEntities [["Car","Epoch_Male_F","Epoch_Female_F"],TRANSMIT_RANGE];
				
				{
					if ((isPlayer _x) && {({if (_radioType in (assignedItems _x)) exitWith {1}} count (crew (vehicle _x))) > 0}) then {
						_index = (floor (random 4));
						_radioSpeech = call {
							if (_index isEqualTo 0) exitWith {format ["[RADIO] %1 (Bandit Leader): %2 is somewhere in this location. Search the area!",(name _leader),(name _targetPlayer)]};
							if (_index isEqualTo 1) exitWith {format ["[RADIO] %1 (Bandit Leader): Target is a %2. Stay on alert!",(name _leader),(getText (configFile >> "CfgVehicles" >> (typeOf _targetPlayer) >> "displayName"))]};
							if (_index isEqualTo 2) exitWith {format ["[RADIO] %1 (Bandit Leader): Target's distance is %2 meters. Move in to intercept!",(name _leader),round (_leader distance _targetPlayer)]};
							if (_index > 2) exitWith {""};
							"[RADIO] ??? : ..."
						};
						//diag_log format ["DEBUG :: %1",_radioSpeech];
						[_x,_radioSpeech] call A3EAI_radioSend;
						//[_radioSpeech,"systemChat",_x,false,false] call BIS_fnc_MP;
					};
				} count _nearbyUnits;
			};
		};
	};
	uiSleep 19.5;
	_ableToChase = ((!isNull _unitGroup) && {(_unitGroup getVariable ["GroupSize",0]) > 0});
	if (_ableToChase && {isNull _targetPlayer}) then {
		if (A3EAI_debugLevel > 1) then {diag_log format ["A3EAI Extended Debug: Group %1 is attempting to search for a new target.",_unitGroup];};
		_nearUnits = (leader _unitGroup) nearEntities [["Epoch_Male_F","Epoch_Female_F"],200];
		{
			if (isPlayer _x) exitWith {
				_targetPlayer = _x;
				_unitGroup reveal [_targetPlayer,4];
			};
		} forEach _nearUnits;
	};
	uiSleep 0.5;
};

if ((isNull _unitGroup) or {(_unitGroup getVariable ["GroupSize",0]) < 1}) exitWith {};
if (A3EAI_debugLevel > 0) then {diag_log format ["A3EAI Debug: Group %1 has exited hunting phase. Moving to patrol phase. (fn_seekPlayer)",_unitGroup];};

//Begin patrol phase
_waypoint setWaypointStatements ["true","if ((random 1) < 0.50) then { group this setCurrentWaypoint [(group this), (floor (random (count (waypoints (group this)))))];};"];
0 = [_unitGroup,_triggerPos,_patrolDist] spawn A3EAI_BIN_taskPatrol;
_unitGroup setVariable ["seekActive",nil];
{_x enableFatigue true} count (units _unitGroup);

uiSleep 5;

if (A3EAI_radioMsgs) then {
	_leader = (leader _unitGroup);
	if (((_unitGroup getVariable ["GroupSize",0]) > 1) && {!(isNull _targetPlayer)}) then {
		_nearbyUnits = (getPosASL _targetPlayer) nearEntities [["Car","Epoch_Male_F","Epoch_Female_F"],TRANSMIT_RANGE];
		{
			if ((isPlayer _x) && {({if (_radioType in (assignedItems _x)) exitWith {1}} count (crew (vehicle _x))) > 0}) then {
				_radioText = if (alive _targetPlayer) then {"%1 (Bandit Leader): We've lost contact with the target. Let's move out."} else {"%1 (Bandit Leader): The target has been killed."};
				_radioSpeech = format [_radioText,(name _leader)];
				[_x,_radioSpeech] call A3EAI_radioSend;
			};
		} count _nearbyUnits;
	};
};

true
