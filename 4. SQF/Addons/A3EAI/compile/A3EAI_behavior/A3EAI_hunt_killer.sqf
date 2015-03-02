
private ["_unitGroup","_targetPlayer","_startPos","_chaseDistance","_radioType"];

_targetPlayer = _this select 0;
_unitGroup = _this select 1;

//Disable killer-finding for dynamic AI in hunting mode
if (_unitGroup getVariable ["seekActive",false]) exitWith {};

//If group is already pursuing player and target player has killed another group member, then extend pursuit time.
if (((_unitGroup getVariable ["pursuitTime",0]) > 0) && {((_unitGroup getVariable ["targetKiller",""]) isEqualTo (name _targetPlayer))}) exitWith {
	_unitGroup setVariable ["pursuitTime",((_unitGroup getVariable ["pursuitTime",0]) + 20)];
	if (A3EAI_debugLevel > 0) then {diag_log format ["A3EAI Debug: Pursuit time +20 sec for Group %1 (Target: %2) to %3 seconds (fn_findKiller).",_unitGroup,name _targetPlayer,(_unitGroup getVariable ["pursuitTime",0]) - diag_tickTime]};
};

if (A3EAI_enableHC) then {_unitGroup setVariable ["HC_Ready",false];};

_startPos = _unitGroup getVariable ["trigger",(getPosASL (leader _unitGroup))];
_chaseDistance = _unitGroup getVariable ["patrolDist",250];
_radioType = "EpochRadio0";

#define TRANSMIT_RANGE 50 //distance to broadcast radio text around target player
#define RECEIVE_DIST 200 //distance requirement to receive message from AI group leader

if ((_startPos distance _targetPlayer) < _chaseDistance) then {
	private ["_targetPlayerPos","_leader","_ableToChase","_marker"];
	if (A3EAI_debugLevel > 0) then {diag_log format ["A3EAI Debug: Group %1 has entered pursuit state for 180 seconds. Target: %2. (fn_findKiller)",_unitGroup,_targetPlayer];};
	
	//Temporarily cancel patrol state.
	_unitGroup lockWP true;
	{_x enableFatigue false} count (units _unitGroup);
	
	//Set pursuit timer
	_unitGroup setVariable ["pursuitTime",diag_tickTime+180];
	_unitGroup setVariable ["targetKiller",name _targetPlayer];
	
	
	if (A3EAI_debugMarkersEnabled) then {
		_markername = format ["%1 Target",_unitGroup];
		if ((getMarkerColor _markername) != "") then {deleteMarker _markername; uiSleep 0.5;};
		_marker = createMarker [_markername,getPosASL _targetPlayer];
		_marker setMarkerText _markername;
		_marker setMarkerType "mil_warning";
		_marker setMarkerColor "ColorRed";
		_marker setMarkerBrush "Solid";
	};
	
	//Begin pursuit state.
	_ableToChase = true;
	while { 
		_ableToChase &&
		{!((owner _targetPlayer) isEqualTo 0)} && 
		{alive _targetPlayer} &&
		{((_startPos distance _targetPlayer) < _chaseDistance)} &&
		{(!((vehicle _targetPlayer) isKindOf "Air"))}
	} do {
		_targetPlayerPos = getPosATL _targetPlayer;
		if ((_unitGroup knowsAbout _targetPlayer) < 4) then {_unitGroup reveal [_targetPlayer,4]};
		(units _unitGroup) doMove _targetPlayerPos;
		/*{
			if (alive _x) then {
				_x moveTo _targetPlayerPos;
			};
		} count (units _unitGroup);*/
		if (A3EAI_debugLevel > 1) then {diag_log format ["A3EAI Extended Debug: AI group %1 in pursuit state. Pursuit time remaining: %2 seconds.",_unitGroup,(_unitGroup getVariable ["pursuitTime",0]) - diag_tickTime];};
		
		if ((A3EAI_radioMsgs) && {0.6 call A3EAI_chance}) then {
			_leader = (leader _unitGroup);
			if ((_targetPlayer distance _leader) <= RECEIVE_DIST) then {
				private ["_nearbyUnits","_radioSpeech"];
				_nearbyUnits = _targetPlayerPos nearEntities [["Epoch_Male_F","Epoch_Female_F"],TRANSMIT_RANGE];
				if ((_unitGroup getVariable ["GroupSize",0]) > 1) then {
					{
						if ((isPlayer _x) && {({if (_radioType in (assignedItems _x)) exitWith {1}} count (crew (vehicle _x))) > 0}) then {
							_speechIndex = (floor (random 3));
							_radioSpeech = call {
								if (_speechIndex isEqualTo 0) exitWith {
									format ["[RADIO] %1 (Bandit Leader): %2 is in this area. Stay on alert!",(name _leader),(name _targetPlayer)]
								};
								if (_speechIndex isEqualTo 1) exitWith {
									format ["[RADIO] %1 (Bandit Leader): Target looks like a %2. Find them!",(name _leader),(getText (configFile >> "CfgVehicles" >> (typeOf _targetPlayer) >> "displayName"))]
								};
								if (_speechIndex isEqualTo 2) exitWith {
									format ["[RADIO] %1 (Bandit Leader): Target's range is about %2 meters. Move in on that position!",(name _leader),round (_leader distance _targetPlayer)]
								};
								""	//Default radio message: empty string (this case should never happen)
							};
							[_x,_radioSpeech] call A3EAI_radioSend;
						};
					} count _nearbyUnits;
				} else {
					_radioSpeech = "[RADIO] Your radio is picking up a signal nearby.";
					{
						if ((isPlayer _x) && {({if (_radioType in (assignedItems _x)) exitWith {1}} count (crew (vehicle _x))) > 0}) then {
							[_x,_radioSpeech] call A3EAI_radioSend;
						};
					} count _nearbyUnits;
				};
			};
		};
		if (A3EAI_debugMarkersEnabled) then {
			_marker setMarkerPos (getPosASL _targetPlayer);
		};
		uiSleep 19.5;
		_ableToChase = ((!isNull _unitGroup) && {diag_tickTime < (_unitGroup getVariable ["pursuitTime",0])} && {(_unitGroup getVariable ["GroupSize",0]) > 0});
		if (_ableToChase && {((owner _targetPlayer) isEqualTo 0)}) then {
			if (A3EAI_debugLevel > 1) then {diag_log format ["A3EAI Extended Debug: Group %1 is attempting to find another target.",_unitGroup];};
			_nearUnits = _targetPlayerPos nearEntities [["Epoch_Male_F","Epoch_Female_F"],100];
			{
				if (isPlayer _x) exitWith {
					_targetPlayer = _x;
				};
			} forEach _nearUnits;
		};
		uiSleep 0.5;
	};

	if !(isNull _unitGroup) then {
		//End of pursuit state. Re-enable patrol state.
		_unitGroup setVariable ["pursuitTime",0];
		_unitGroup setVariable ["targetKiller",""];
		_unitGroup lockWP false;
		
		if ((_unitGroup getVariable ["GroupSize",0]) > 0) then {
			_waypoints = (waypoints _unitGroup);
			_unitGroup setCurrentWaypoint (_waypoints call BIS_fnc_selectRandom2);
			{_x enableFatigue true} count (units _unitGroup);
			if (A3EAI_debugLevel > 0) then {diag_log format ["A3EAI Debug: Pursuit state ended for group %1. Returning to patrol state. (fn_findKiller)",_unitGroup];};
			
			if (A3EAI_radioMsgs) then {
				_leader = (leader _unitGroup);
				if (((_targetPlayer distance _leader) <= RECEIVE_DIST) && {((_unitGroup getVariable ["GroupSize",0]) > 1)} && {!((owner _targetPlayer) isEqualTo 0)}) then {
					private ["_nearbyUnits","_radioSpeech","_radioText"];
					_radioText = if (alive _targetPlayer) then {"%1 (Bandit Leader): Lost contact with target. Breaking off pursuit."} else {"%1 (Bandit Leader): Target has been eliminated."};
					_radioSpeech = format [_radioText,(name (leader _unitGroup))];
					_nearbyUnits = (getPosASL _targetPlayer) nearEntities [["Car","Epoch_Male_F","Epoch_Female_F"],TRANSMIT_RANGE];
					{
						if ((isPlayer _x) && {({if (_radioType in (assignedItems _x)) exitWith {1}} count (crew (vehicle _x))) > 0}) then {
							[_x,_radioSpeech] call A3EAI_radioSend;
						};
					} count _nearbyUnits;
				};
			};
		};
	};
	if (A3EAI_debugMarkersEnabled) then {
		deleteMarker _marker;
	};
};

if (A3EAI_enableHC) then {_unitGroup setVariable ["HC_Ready",true];};
