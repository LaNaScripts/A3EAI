private ["_unitGroup","_unitLevel","_vehicle","_lastRearmTime","_useLaunchers","_useGL","_isArmed","_marker","_marker2","_antistuckTime","_antistuckPos","_lastReinforceTime","_vehicleMoved","_lootPool","_pullChance","_pullRate","_antistuckObj"];



_unitGroup = _this select 0;
_unitLevel = _this select 1;

if (_unitGroup getVariable ["rearmEnabled",false]) exitWith {};
_unitGroup setVariable ["rearmEnabled",true];

_unitType = (_unitGroup getVariable ["unitType",""]);
_vehicle = if (_unitType in ["static","dynamic","random"]) then {objNull} else {(vehicle (leader _unitGroup))};
_useGL = if !(A3EAI_GLRequirement isEqualTo -1) then {_unitLevel >= A3EAI_GLRequirement} else {false};
_useLaunchers = if !(A3EAI_launcherLevelReq isEqualTo -1) then {((count A3EAI_launcherTypes) > 0) && {(_unitLevel >= A3EAI_launcherLevelReq)}} else {false};
_isArmed = _vehicle getVariable ["isArmed",false];
_antistuckPos = (getWPPos [_unitGroup,(currentWaypoint _unitGroup)]);
if (isNil {_unitGroup getVariable "GroupSize"}) then {_unitGroup setVariable ["GroupSize",(count (units _unitGroup)),A3EAI_enableHC]};
_vehicleMoved = true;
_stuckCheckTime = call {
	if (_unitType isEqualTo "static") then {300};
	if (_unitType isEqualTo "aircustom") then {300};
	if (_unitType isEqualTo "landcustom") then {300};
	if (_unitType isEqualTo "air") then {300};
	if (_unitType isEqualTo "land") then {450};
	300
};

//set up debug variables

_marker = "";
_marker2 = "";

//Set up timer variables
_lastRearmTime = diag_tickTime;
_antistuckTime = diag_tickTime + 900;
_lastReinforceTime = diag_tickTime + 600;
_lootGenTime = diag_tickTime;

//Setup loot variables
_unitGroup setVariable ["LootPool",[]];
_lootPool = (_unitGroup getVariable ["LootPool",[]]);
_pullChance = missionNamespace getVariable [format ["A3EAI_lootPullChance%1",_unitLevel],0.40];
_pullRate = 60;
if (_unitType in ["dynamic","randomspawn"]) then {_pullRate = ((_pullRate/2) max 30)};

_lootGenerate = _unitGroup spawn {
	private ["_lootPool","_groupSize","_startTime"];
	_startTime = diag_tickTime;
	_lootPool = _this getVariable ["LootPool",[]];
	_groupSize = _this getVariable ["GroupSize",0];
	
	for "_j" from 1 to _groupSize do {
		//Add first aid kit to loot list
		if (A3EAI_chanceFirstAidKit call A3EAI_chance) then {
			_lootPool pushBack "FAK";
		};

		//Add food to loot list
		for "_i" from 1 to A3EAI_foodLootCount do {
			if (A3EAI_chanceFoodLoot call A3EAI_chance) then {
				_lootPool pushBack (A3EAI_foodLoot call BIS_fnc_selectRandom2);
			};
		};

		//Add items to loot list
		for "_i" from 1 to A3EAI_miscLootCount1 do {
			if (A3EAI_chanceMiscLoot1 call A3EAI_chance) then {
				_lootPool pushBack (A3EAI_MiscLoot1 call BIS_fnc_selectRandom2);
			};
		};

		//Add items to loot list
		for "_i" from 1 to A3EAI_miscLootCount2 do {
			if (A3EAI_chanceMiscLoot2 call A3EAI_chance) then {
				_lootPool pushBack (A3EAI_MiscLoot2 call BIS_fnc_selectRandom2);
			};
		};

		sleep 0.5;
	};
	//diag_log format ["DEBUG :: Added %1 items to group %2 loot pool in %3 seconds.",(count _lootPool),_this,diag_tickTime - _startTime];
};
//Air units only: Replace backpack with parachute
if (_unitType in ["air","aircustom"]) then {
	{
		_x addBackpack "B_Parachute";
	} forEach (units _unitGroup);
	if (A3EAI_debugLevel > 1) then {diag_log format ["A3EAI Extended Debug: Unit backpacks replaced with B_Parachute for %1 group %2.",_unitType,_unitGroup]};
};

//Set up individual group units
{
	_loadout = _x getVariable "loadout";
	if (isNil "_loadout") then {
		_weapon = primaryWeapon _x;
		_magazine = getArray (configFile >> "CfgWeapons" >> _weapon >> "magazines") select 0;
		_loadout = [[_weapon],[_magazine]];
		_x setVariable ["loadout",_loadout];
	};
	
	if ((getNumber (configFile >> "CfgMagazines" >> ((_loadout select 1) select 0) >> "count")) < 6) then {_x setVariable ["extraMag",true]};
	
	if (_useGL) then {
		_weaponMuzzles = getArray(configFile >> "cfgWeapons" >> ((_loadout select 0) select 0) >> "muzzles");
		if ((count _weaponMuzzles) > 1) then {
			_GLWeapon = _weaponMuzzles select 1;
			_GLMagazine = getArray (configFile >> "CfgWeapons" >> ((_loadout select 0) select 0) >> _GLWeapon >> "magazines") select 0;
			_x addMagazine _GLMagazine;
			(_loadout select 0) pushBack _GLWeapon;
			(_loadout select 1) pushBack _GLMagazine;
			if (A3EAI_debugLevel > 1) then {diag_log format ["A3EAI Extended Debug: Modified unit %1 loadout to %2.",_x,_loadout];};
		};
	};
	
	if (_useLaunchers) then {
		_maxLaunchers = (A3EAI_launchersPerGroup min _unitLevel);
		if (_forEachIndex < _maxLaunchers) then {
			_launchWeapon = A3EAI_launcherTypes call BIS_fnc_selectRandom2;
			if ((getNumber (configFile >> "CfgWeapons" >> _launchWeapon >> "type")) isEqualTo 4) then {
				_launchAmmo = [] + getArray (configFile >> "CfgWeapons" >> _launchWeapon >> "magazines") select 0;
				_x addMagazine _launchAmmo; (_loadout select 1) pushBack _launchAmmo;
				_x addWeapon _launchWeapon; (_loadout select 0) pushBack _launchWeapon;
				if (A3EAI_debugLevel > 1) then {diag_log format ["A3EAI Extended Debug: Modified unit %1 loadout to %2.",_x,_loadout];};
			};
		};
	};
	
	_rifleGL = true;
	if (_rifleGL) then {
		_weaponMuzzles = getArray(configFile >> "cfgWeapons" >> ((_x getVariable "loadout") select 0) select 0 >> "muzzles");
	};
	
	_gadgetsArray = if (_unitLevel > 1) then {A3EAI_gadgets1} else {A3EAI_gadgets0};
	for "_i" from 0 to ((count _gadgetsArray) - 1) do {
		if (((_gadgetsArray select _i) select 1) call A3EAI_chance) then {
			_gadget = ((_gadgetsArray select _i) select 0);
			_x addWeapon _gadget;
		};
	};

	//If unit was not given NVGs, give the unit temporary NVGs which will be removed at death.
	if (A3EAI_tempNVGs) then {
		if (!(_x hasWeapon "NVG_EPOCH") && {sunOrMoon < 1}) then {
			_x call A3EAI_addTempNVG;
			if (A3EAI_debugLevel > 1) then {diag_log format ["A3EAI Extended Debug: Generated temporary NVGs for AI %1.",_x];};
		};
	};

	//Give unit temporary first aid kits to allow self-healing (unit level 1+)
	if (A3EAI_enableHealing) then {
		for "_i" from 1 to (_unitLevel min 3) do {
			_x addItem "FirstAidKit";
		};
	};
	
	if (A3EAI_debugLevel > 0) then {diag_log format ["A3EAI Debug: Unit %1 loadout: %2. unitLevel %3.",_x,_x getVariable ["loadout",[]],_unitLevel];};
} forEach (units _unitGroup);

if (A3EAI_debugMarkersEnabled) then {
	_markername = format ["%1-1",_unitGroup];
	if ((getMarkerColor _markername) != "") then {deleteMarker _markername; uiSleep 0.5};	//Delete the previous marker if it wasn't deleted for some reason.
	_marker = createMarker [_markername,getPosASL (leader _unitGroup)];
	_marker setMarkerType "mil_warning";
	_marker setMarkerBrush "Solid";
	_marker setMarkerColor "ColorBlack";
	
	if (isNull _vehicle) then {
		_marker setMarkerText format ["%1 (AI L%2)",_unitGroup,_unitLevel];
	} else {
		_marker setMarkerText format ["%1 (AI L%2 %3)",_unitGroup,_unitLevel,(typeOf (vehicle (leader _unitGroup)))];
	};
	
	_markername2 = format ["%1-2",_unitGroup];
	if ((getMarkerColor _markername2) != "") then {deleteMarker _markername2; uiSleep 0.5;};	//Delete the previous marker if it wasn't deleted for some reason.
	_marker2 = createMarker [_markername2,(getWPPos [_unitGroup,(currentWaypoint _unitGroup)])];
	_marker2 setMarkerText format ["%1 WP",_unitGroup];
	_marker2 setMarkerType "Waypoint";
	_marker2 setMarkerColor "ColorBlue";
	_marker2 setMarkerBrush "Solid";
	
	{
		_x spawn {
			private ["_mark","_markname"];
			_markname = str(_this);
			if ((getMarkerColor _markname) != "") then {deleteMarker _markname; uiSleep 0.5};
			_mark = createMarker [_markname,getPosASL _this];
			_mark setMarkerShape "ELLIPSE";
			_mark setMarkerType "Dot";
			_mark setMarkerColor "ColorRed";
			_mark setMarkerBrush "SolidBorder";
			_mark setMarkerSize [3,3];
			waitUntil {uiSleep 15; (!(alive _this))};
			//diag_log format ["DEBUG :: Deleting unit marker %1.",_mark];
			deleteMarker _mark;
		};
		uiSleep 0.1;
	} count (units _unitGroup);
} else {
	_marker = nil;
	_marker2 = nil;
};

//Main loop
while {(!isNull _unitGroup) && {(_unitGroup getVariable ["GroupSize",-1]) > 0}} do {
	_unitType = (_unitGroup getVariable ["unitType",""]);

	call {
		//If any units have left vehicle then allow re-entry
		if (_unitType in ["land","landcustom"]) exitWith {
			if (alive _vehicle) then {
				if (_unitGroup getVariable ["regrouped",true]) then {
					if (({if ((_x distance _vehicle) > 175) exitWith {1}} count (assignedCargo _vehicle)) > 0) then {
						_unitGroup setVariable ["regrouped",false];
						[_unitGroup,_vehicle] call A3EAI_vehCrewRegroup;
					};
				};
			};
		};
		if (_unitType isEqualTo "air") exitWith {
			if ((alive _vehicle) && {!(_vehicle getVariable ["heli_disabled",false])}) then {
				if (((diag_tickTime - _lastReinforceTime) > 900) && {((count A3EAI_reinforcePlaces) > 0)}) then {
					[_unitGroup,_vehicle] call A3EAI_heliReinforce;
					_lastReinforceTime = diag_tickTime;
				};
			};
		};
	};
	
	{
		//Check infantry-type units
		if (((vehicle _x) isEqualTo _x) && {_x getVariable ["canCheckUnit",true]}) then {
			_x setVariable ["canCheckUnit",false];
			_nul = _x spawn {
				if (!alive _this) exitWith {};
				_unit = _this;
				_loadout = _unit getVariable ["loadout",[[],[]]];
				if (A3EAI_debugLevel > 1) then {diag_log format ["A3EAI Extended Debug: Unpacked unit manager for unit %1. Loadout found: %2.",_unit,_loadout];};
				if (!isNil "_loadout") then {
					while {(alive _unit) && {(vehicle _unit) isEqualTo _unit}} do {
						_currentMagazines = (magazines _unit);
						for "_i" from 0 to ((count (_loadout select 0)) - 1) do {
							_magazine = ((_loadout select 1) select _i);
							if (((_unit ammo ((_loadout select 0) select _i)) isEqualTo 0) || {!((_magazine in _currentMagazines))}) then {
								_unit removeMagazines _magazine;
								[_unit,_magazine] call A3EAI_addItem;
								if ((_i isEqualTo 0) && {_unit getVariable ["extraMag",false]}) then {
									[_unit,_magazine] call A3EAI_addItem;
								};
							};
						};
						if (alive _unit) then {uiSleep 15};
					};
				};
				if (alive _unit) then {
					_unit setVariable ["canCheckUnit",true];
					if (A3EAI_debugLevel > 1) then {diag_log format ["A3EAI Extended Debug: Repacking unit manager for unit %1.",_unit];};
				};
			};
		};
		uiSleep 0.1;
	} forEach (units _unitGroup);

	//Generate loot
	if ((diag_tickTime - _lootGenTime) > _pullRate) then {
		if ((count _lootPool) > 0) then {
			if (_pullChance call A3EAI_chance) then {
				_lootUnit = (units _unitGroup) call BIS_fnc_selectRandom2;
				_lootIndex = floor (random (count _lootPool));
				_loot = _lootPool select _lootIndex;
				if (alive _lootUnit) then {
					if ([_lootUnit,_loot] call A3EAI_addItem) then {
						_lootPool deleteAt _lootIndex;
						if (A3EAI_debugLevel > 0) then {diag_log format ["A3EAI Debug: Pulled %1 from %2 loot pool (%3 items remain).",_loot,_unitGroup,(count _lootPool)];};
					};
				};
			};
		} else {
			_pullRate =  3.4028235e38;	//Loot pool emptied, stop checking it.
		};
		_lootGenTime = diag_tickTime;
	};
	
	//Vehicle ammo/fuel check
	if (alive _vehicle) then {	//If _vehicle is objNull (if no vehicle was assigned to the group) then nothing in this bracket should be executed
		if ((_isArmed) && {someAmmo _vehicle}) then {	//Note: someAmmo check is not reliable for vehicles with multiple turrets
			_lastRearmTime = diag_tickTime;	//Reset rearm timestamp if vehicle still has some ammo
		} else {
			if ((diag_tickTime - _lastRearmTime) > 180) then {	//If ammo is depleted, wait 3 minutes until rearm is possible.
				_vehicle setVehicleAmmo 1;				//Rearm vehicle. Rearm timestamp will be reset durng the next loop cycle.
			};
		};
		if ((fuel _vehicle) < 0.50) then {_vehicle setFuel 1};
	};
	
	//Antistuck detection
	if ((diag_tickTime - _antistuckTime) > _stuckCheckTime) then {
		//_wpPos = (getWPPos [_unitGroup,(currentWaypoint _unitGroup)]);
		_unitType = (_unitGroup getVariable ["unitType",""]);
		call {
			if (_unitType in ["static","landcustom"]) exitWith {
				//Static and custom land vehicle patrol anti stuck routine
				_wpPos = (getWPPos [_unitGroup,(currentWaypoint _unitGroup)]);
				if (_antistuckPos isEqualTo _wpPos) then {
					_currentWP = (currentWaypoint _unitGroup);
					_allWP = (waypoints _unitGroup);
					_nextWP = _currentWP + 1;
					if ((count _allWP) isEqualTo _nextWP) then {_nextWP = 1}; //Cycle back to first added waypoint if group is currently on last waypoint.
					_unitGroup setCurrentWaypoint [_unitGroup,_nextWP];
					if (A3EAI_debugLevel > 1) then {diag_log format ["A3EAI Extended Debug: Antistuck detection triggered for AI group %1. Forcing next waypoint.",_unitGroup];};
					_antistuckTime = diag_tickTime + (_stuckCheckTime/2);
				} else {
					_antistuckPos = _wpPos;
					_antistuckTime = diag_tickTime;
				};
			};
			if (_unitType isEqualTo "air") exitWith {
				_wpPos = (getWPPos [_unitGroup,(currentWaypoint _unitGroup)]);
				if ((_wpPos isEqualTo _antistuckPos) && {canMove _vehicle}) then {
					_tooClose = true;
					_wpSelect = [];
					while {_tooClose} do {
						_wpSelect = (A3EAI_locations call BIS_fnc_selectRandom2) select 1;
						if (((waypointPosition [_unitGroup,0]) distance _wpSelect) < 300) then {
							_tooClose = false;
						} else {
							uiSleep 0.1;
						};
					};
					_wpSelect = [_wpSelect,50+(random 900),(random 360),1] call SHK_pos;
					[_unitGroup,0] setWPPos _wpSelect;
					[_unitGroup,1] setWPPos _wpSelect;
					[_unitGroup,"IgnoreEnemies"] call A3EAI_forceBehavior;
					if (_unitGroup getVariable ["HeliReinforceOrdered",false]) then {_unitGroup setVariable ["HeliReinforceOrdered",false];}; //Cancel reinforcement order
					//_vehicle doMove _wpSelect;
					_antistuckPos = _wpSelect;
					if (A3EAI_debugLevel > 1) then {diag_log format ["A3EAI Extended Debug: Antistuck detection triggered for AI air vehicle %1 (Group: %2). Forcing next waypoint.",(typeOf _vehicle),_unitGroup];};
					_antistuckTime = diag_tickTime + (_stuckCheckTime/2);
				} else {
					_antistuckPos = _wpPos;
					_antistuckTime = diag_tickTime;
				};
			};
			if (_unitType isEqualTo "land") exitWith {
				//Mapwide land vehicle patrol anti stuck routine
				_currentPos = (getPosASL _vehicle);
				if ((_antistuckPos distance _currentPos) < 30) then {
					if (_vehicleMoved && {canMove _vehicle}) then {
						_tooClose = true;
						_wpSelect = [];
						while {_tooClose} do {
							_wpSelect = (A3EAI_locationsLand call BIS_fnc_selectRandom2) select 1;
							if (((waypointPosition [_unitGroup,0]) distance _wpSelect) < 300) then {
								_tooClose = false;
							} else {
								uiSleep 0.1;
							};
						};
						_wpSelect = [_wpSelect,random(300),random(360),0,[1,300]] call SHK_pos;
						[_unitGroup,0] setWPPos _wpSelect;
						_antistuckPos = _currentPos;
						_vehicleMoved = false;
						if (A3EAI_debugLevel > 1) then {diag_log format ["A3EAI Extended Debug: Antistuck prevention triggered for AI land vehicle %1 (Group: %2). Forcing next waypoint.",(typeOf _vehicle),_unitGroup];};
						_antistuckTime = diag_tickTime + (_stuckCheckTime/2);
					} else {
						if (!(_vehicle getVariable ["veh_disabled",false])) then {
							[_vehicle] call A3EAI_vehDestroyed;
							if (A3EAI_debugLevel > 1) then {diag_log format ["A3EAI Extended Debug: AI vehicle %1 (Group: %2) is immobilized. Respawning vehicle patrol group.",(typeOf _vehicle),_unitGroup];};
						};
					};
				} else {
					_antistuckPos = _currentPos;
					if (!_vehicleMoved) then {
						_vehicleMoved = true;
						if (A3EAI_debugLevel > 1) then {diag_log format ["A3EAI Extended Debug: Antistuck check passed for AI vehicle %1 (Group: %2). Reset vehicleMoved flag.",(typeOf _vehicle),_unitGroup];};
					};
					_antistuckTime = diag_tickTime;
				};
			};
			if (_unitType isEqualTo "aircustom") exitWith {
				_wpPos = (getWPPos [_unitGroup,(currentWaypoint _unitGroup)]);
				if ((_wpPos isEqualTo _antistuckPos) && {canMove _vehicle}) then {
					_currentWP = (currentWaypoint _unitGroup);
					_allWP = (waypoints _unitGroup);
					_nextWP = _currentWP + 1;
					if ((count _allWP) isEqualTo _nextWP) then {_nextWP = 1}; //Cycle back to first added waypoint if group is currently on last waypoint.
					_unitGroup setCurrentWaypoint [_unitGroup,_nextWP];
					if (A3EAI_debugLevel > 1) then {diag_log format ["A3EAI Extended Debug: Antistuck detection triggered for AI air (custom) group %1. Forcing next waypoint.",_unitGroup];};
					_antistuckTime = diag_tickTime + (_stuckCheckTime/2);
				} else {
					_antistuckPos = _wpPos;
					_antistuckTime = diag_tickTime;
				};
			};
		};
	};
	
	if (A3EAI_debugMarkersEnabled) then {
		_marker setMarkerPos (getPosASL ((units _unitGroup) select 0));
		_marker2 setMarkerPos (getWPPos [_unitGroup,(currentWaypoint _unitGroup)]);
		{
			if (alive _x) then {
				(str (_x)) setMarkerPos (getPosASL _x);
			};
			if ((_forEachIndex % 3) isEqualTo 0) then {uiSleep 0.05};
		} forEach (units _unitGroup);
	};
	
	//diag_log format ["DEBUG: Group Manager cycle time for group %1: %2 seconds.",_unitGroup,(diag_tickTime - _debugStartTime)];
	if ((_unitGroup getVariable ["GroupSize",0]) > 0) then {uiSleep 15};
};

_unitGroup setVariable ["rearmEnabled",false]; //allow group manager to run again on group respawn.

if (isEngineOn _vehicle) then {_vehicle engineOn false};

if (A3EAI_debugMarkersEnabled) then {
	deleteMarker _marker;
	deleteMarker _marker2;
};

//Wait until group is either respawned or marked for deletion. A dummy unit should be created to preserve group.
while {(_unitGroup getVariable ["GroupSize",-1]) isEqualTo 0} do {
	uiSleep 5;
};

//GroupSize value of -1 marks group for deletion
if ((_unitGroup getVariable ["GroupSize",-1]) isEqualTo -1) then {
	if (!isNull _unitGroup) then {
		if (A3EAI_debugLevel > 0) then {diag_log format ["A3EAI Debug: Deleting %2 group %1.",_unitGroup,(_unitGroup getVariable ["unitType","unknown"])]};
		_unitGroup call A3EAI_deleteGroup;
	};
};
