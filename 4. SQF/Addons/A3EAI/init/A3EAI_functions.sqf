/*
	A3EAI Functions

*/

diag_log "[A3EAI] Compiling A3EAI functions.";

if (isNil "SHK_pos_getPos") then {call compile preprocessFile format ["%1\compile\SHK_pos\shk_pos_init.sqf",A3EAI_directory];};

A3EAI_getWeaponList = compileFinal preprocessFileLineNumbers format ["%1\compile\A3EAI_utilities\A3EAI_getWeaponList.sqf",A3EAI_directory];
BIS_fnc_selectRandom2 = compileFinal preprocessFileLineNumbers format ["%1\compile\A3EAI_utilities\fn_selectRandom.sqf",A3EAI_directory];
A3EAI_checkClassname = compileFinal preprocessFileLineNumbers format ["%1\compile\A3EAI_utilities\A3EAI_check_classname.sqf",A3EAI_directory];
A3EAI_posInBuilding = compileFinal preprocessFileLineNumbers format ["%1\compile\A3EAI_utilities\A3EAI_insideBuildingCheck.sqf",A3EAI_directory];
A3EAI_clearMissileWeapons = compileFinal preprocessFileLineNumbers format ["%1\compile\A3EAI_utilities\A3EAI_removeMissiles.sqf",A3EAI_directory];
A3EAI_createCustomInfantryQueue = compileFinal preprocessFileLineNumbers format ["%1\compile\A3EAI_utilities\A3EAI_customInfantryQueue.sqf",A3EAI_directory];
A3EAI_createCustomInfantrySpawnQueue = compileFinal preprocessFileLineNumbers format ["%1\compile\A3EAI_utilities\A3EAI_customInfantrySpawnQueue.sqf",A3EAI_directory];
A3EAI_createCustomVehicleQueue = compileFinal preprocessFileLineNumbers format ["%1\compile\A3EAI_utilities\A3EAI_customVehicleQueue.sqf",A3EAI_directory];
A3EAI_createBlacklistAreaQueue = compileFinal preprocessFileLineNumbers format ["%1\compile\A3EAI_utilities\A3EAI_customBlacklistQueue.sqf",A3EAI_directory];
A3EAI_findSpawnPos = compileFinal preprocessFileLineNumbers format ["%1\compile\A3EAI_utilities\A3EAI_find_spawnposition.sqf",A3EAI_directory];
A3EAI_hasLOS = compileFinal preprocessFileLineNumbers format ["%1\compile\A3EAI_utilities\A3EAI_hasLOS.sqf",A3EAI_directory];
A3EAI_getSpawnParams = compileFinal preprocessFileLineNumbers format ["%1\compile\A3EAI_utilities\A3EAI_getSpawnParams.sqf",A3EAI_directory];
A3EAI_createInfantryQueue = compileFinal preprocessFileLineNumbers format ["%1\compile\A3EAI_utilities\A3EAI_staticInfantrySpawnQueue.sqf",A3EAI_directory];
A3EAI_createRandomInfantrySpawnQueue = compileFinal preprocessFileLineNumbers format ["%1\compile\A3EAI_utilities\A3EAI_randomInfantrySpawnQueue.sqf",A3EAI_directory];
A3EAI_createUnit = compileFinal preprocessFileLineNumbers format ["%1\compile\A3EAI_unit_spawning\A3EAI_setup_unit.sqf",A3EAI_directory];
A3EAI_spawnGroup = compileFinal preprocessFileLineNumbers format ["%1\compile\A3EAI_unit_spawning\A3EAI_setup_group.sqf",A3EAI_directory];
A3EAI_initializeTrigger = compileFinal preprocessFileLineNumbers format ["%1\compile\A3EAI_unit_spawning\A3EAI_initialize_trigger.sqf",A3EAI_directory];
A3EAI_spawnBandits_custom = compileFinal preprocessFileLineNumbers format ["%1\compile\A3EAI_unit_spawning\A3EAI_spawn_custom.sqf",A3EAI_directory];
A3EAI_spawnVehicle_custom = compileFinal preprocessFileLineNumbers format ["%1\compile\A3EAI_unit_spawning\A3EAI_spawn_vehiclecustom.sqf",A3EAI_directory];
A3EAI_createCustomSpawn = compileFinal preprocessFileLineNumbers format ["%1\compile\A3EAI_unit_spawning\A3EAI_setup_customspawn.sqf",A3EAI_directory];
A3EAI_respawnGroup = compileFinal preprocessFileLineNumbers format ["%1\compile\A3EAI_unit_spawning\A3EAI_respawnGroup.sqf",A3EAI_directory];
A3EAI_addRespawnQueue = compileFinal preprocessFileLineNumbers format ["%1\compile\A3EAI_unit_spawning\A3EAI_add_respawn.sqf",A3EAI_directory];
A3EAI_processRespawn = compileFinal preprocessFileLineNumbers format ["%1\compile\A3EAI_unit_spawning\A3EAI_process_respawn.sqf",A3EAI_directory];
A3EAI_despawn_static = compileFinal preprocessFileLineNumbers format ["%1\compile\A3EAI_unit_spawning\A3EAI_despawn_static.sqf",A3EAI_directory];
A3EAI_spawnUnits_static = compileFinal preprocessFileLineNumbers format ["%1\compile\A3EAI_unit_spawning\A3EAI_spawn_static.sqf",A3EAI_directory];
A3EAI_staticSpawn_init = compileFinal preprocessFileLineNumbers format ["%1\compile\A3EAI_unit_spawning\A3EAI_init_static.sqf",A3EAI_directory];
A3EAI_setupStaticSpawn = compileFinal preprocessFileLineNumbers format ["%1\compile\A3EAI_unit_spawning\A3EAI_setup_staticspawn.sqf",A3EAI_directory];
A3EAI_cancelDynamicSpawn = compileFinal preprocessFileLineNumbers format ["%1\compile\A3EAI_unit_spawning\A3EAI_cancel_dynamicspawn.sqf",A3EAI_directory];
A3EAI_spawnUnits_dynamic = compileFinal preprocessFileLineNumbers format ["%1\compile\A3EAI_unit_spawning\A3EAI_spawn_dynamic.sqf",A3EAI_directory];
A3EAI_despawn_dynamic = compileFinal preprocessFileLineNumbers format ["%1\compile\A3EAI_unit_spawning\A3EAI_despawn_dynamic.sqf",A3EAI_directory];
A3EAI_setup_randomspawns =  compileFinal preprocessFileLineNumbers format ["%1\compile\A3EAI_unit_spawning\A3EAI_setup_randomspawns.sqf",A3EAI_directory];
A3EAI_cancelRandomSpawn = compileFinal preprocessFileLineNumbers format ["%1\compile\A3EAI_unit_spawning\A3EAI_cancel_randomspawn.sqf",A3EAI_directory];
A3EAI_spawnUnits_random = compileFinal preprocessFileLineNumbers format ["%1\compile\A3EAI_unit_spawning\A3EAI_spawn_random.sqf",A3EAI_directory];
A3EAI_despawn_random = compileFinal preprocessFileLineNumbers format ["%1\compile\A3EAI_unit_spawning\A3EAI_despawn_random.sqf",A3EAI_directory];
A3EAI_spawnVehiclePatrol = compileFinal preprocessFileLineNumbers format ["%1\compile\A3EAI_unit_spawning\A3EAI_spawn_vehiclepatrol.sqf",A3EAI_directory];
A3EAI_generateLoadout = compileFinal preprocessFileLineNumbers format ["%1\compile\A3EAI_unit_scripts\A3EAI_generate_loadout.sqf",A3EAI_directory];
A3EAI_generateLoot = compileFinal preprocessFileLineNumbers format ["%1\compile\A3EAI_unit_scripts\A3EAI_generate_loot.sqf",A3EAI_directory];
A3EAI_addGroupManager = compileFinal preprocessFileLineNumbers format ["%1\compile\A3EAI_unit_scripts\A3EAI_group_manager.sqf",A3EAI_directory];
A3EAI_handleDamageUnit = compileFinal preprocessFileLineNumbers format ["%1\compile\A3EAI_unit_events\A3EAI_handleDamage_unit.sqf",A3EAI_directory];
A3EAI_handleDamageHeli = compileFinal preprocessFileLineNumbers format ["%1\compile\A3EAI_unit_events\A3EAI_handleDamage_heli.sqf",A3EAI_directory];
A3EAI_handleDamageVeh = compileFinal preprocessFileLineNumbers format ["%1\compile\A3EAI_unit_events\A3EAI_handleDamage_veh.sqf",A3EAI_directory];
A3EAI_handleDeath_generic = compileFinal preprocessFileLineNumbers format ["%1\compile\A3EAI_unit_events\A3EAI_handleDeath_generic.sqf",A3EAI_directory];
A3EAI_handleStaticDeath = compileFinal preprocessFileLineNumbers format ["%1\compile\A3EAI_unit_events\A3EAI_handleDeath_static.sqf",A3EAI_directory];
A3EAI_handleDeathEvent = compileFinal preprocessFileLineNumbers format ["%1\compile\A3EAI_unit_events\A3EAI_handle_death.sqf",A3EAI_directory];
A3EAI_heliLanded = compileFinal preprocessFileLineNumbers format ["%1\compile\A3EAI_unit_events\A3EAI_heli_landed.sqf",A3EAI_directory];
A3EAI_heliEvacuated = compileFinal preprocessFileLineNumbers format ["%1\compile\A3EAI_unit_events\A3EAI_heli_evacuated.sqf",A3EAI_directory];
A3EAI_heliDestroyed = compileFinal preprocessFileLineNumbers format ["%1\compile\A3EAI_unit_events\A3EAI_heli_destroyed.sqf",A3EAI_directory];
A3EAI_heliParaDrop = compileFinal preprocessFileLineNumbers format ["%1\compile\A3EAI_unit_events\A3EAI_heli_paradrop.sqf",A3EAI_directory];
A3EAI_vehDestroyed = compileFinal preprocessFileLineNumbers format ["%1\compile\A3EAI_unit_events\A3EAI_veh_destroyed.sqf",A3EAI_directory];
A3EAI_handleAirDeath = compileFinal preprocessFileLineNumbers format ["%1\compile\A3EAI_unit_events\A3EAI_handleDeath_air.sqf",A3EAI_directory];
A3EAI_handleLandDeath = compileFinal preprocessFileLineNumbers format ["%1\compile\A3EAI_unit_events\A3EAI_handleDeath_land.sqf",A3EAI_directory];
A3EAI_handleDeath_dynamic = compileFinal preprocessFileLineNumbers format ["%1\compile\A3EAI_unit_events\A3EAI_handleDeath_dynamic.sqf",A3EAI_directory];
A3EAI_handleDeath_random = compileFinal preprocessFileLineNumbers format ["%1\compile\A3EAI_unit_events\A3EAI_handleDeath_random.sqf",A3EAI_directory];
A3EAI_huntKiller = compileFinal preprocessFileLineNumbers format ["%1\compile\A3EAI_behavior\A3EAI_hunt_killer.sqf",A3EAI_directory];
A3EAI_BIN_taskPatrol = compileFinal preprocessFileLineNumbers format ["%1\compile\A3EAI_behavior\BIN_taskPatrol.sqf",A3EAI_directory];
A3EAI_customHeliDetect = compileFinal preprocessFileLineNumbers format ["%1\compile\A3EAI_behavior\A3EAI_customheli_detect.sqf",A3EAI_directory];
A3EAI_vehCrewRegroup = compileFinal preprocessFileLineNumbers format ["%1\compile\A3EAI_behavior\A3EAI_vehicle_crew_regroup.sqf",A3EAI_directory];
A3EAI_dynamicHunting = compileFinal preprocessFileLineNumbers format ["%1\compile\A3EAI_behavior\A3EAI_dynamic_hunting.sqf",A3EAI_directory];
A3EAI_heliDetection = compileFinal preprocessFileLineNumbers format ["%1\compile\A3EAI_behavior\A3EAI_heli_detect.sqf",A3EAI_directory];
A3EAI_heliStartPatrol = compileFinal preprocessFileLineNumbers format ["%1\compile\A3EAI_behavior\A3EAI_heli_patrolling.sqf",A3EAI_directory];
A3EAI_heliReinforce = compileFinal preprocessFileLineNumbers format ["%1\compile\A3EAI_behavior\A3EAI_reinforce_location.sqf",A3EAI_directory];
A3EAI_vehStartPatrol = compileFinal preprocessFileLineNumbers format ["%1\compile\A3EAI_behavior\A3EAI_vehicle_patrolling.sqf",A3EAI_directory];

//Miscellaneous functions 
//------------------------------------------------------------------------------------------------------------------------


A3EAI_radioSend = compileFinal '
	A3EAI_SMS = (_this select 1);
	(owner (_this select 0)) publicVariableClient "A3EAI_SMS";
	true
';

A3EAI_sendKillMessage = compileFinal '
	private ["_killer","_victimName"];
	_killer = _this select 0;
	_victimName = _this select 1;
	
	{
		if (isPlayer _x) then {
			A3EAI_killMSG = _victimName;
			(owner _x) publicVariableClient "A3EAI_killMSG";
			
		};
	} count (crew _killer);
';


A3EAI_updGroupCount = compileFinal '
	private ["_unitGroup","_isNewGroup"];
	_unitGroup = _this select 0;
	_isNewGroup = _this select 1;
	
	if (isNull _unitGroup) exitWith {false};
	
	if (_isNewGroup) then {
		A3EAI_activeGroups pushBack _unitGroup;
	} else {
		A3EAI_activeGroups = A3EAI_activeGroups - [_unitGroup];
	};
	true
';

//A3EAI group side assignment function.
A3EAI_createGroup = compileFinal '
	private["_unitGroup","_protect","_unitType"];
	_unitType = _this select 0;

	//if (({(side _x) isEqualTo resistance} count allGroups) > 139) then {
	//	diag_log "A3EAI Warning: Exceeded 139 groups for Resistance side! Recommend reducing amount of AI spawns to avoid potential issues.";
	//};
	
	_unitGroup = createGroup resistance;
	if ((count _this) > 1) then {_unitGroup call A3EAI_protectGroup};
	_unitGroup setVariable ["unitType",_unitType,A3EAI_enableHC];
	[_unitGroup,true] call A3EAI_updGroupCount;
	
	_unitGroup
';

//Sets skills for unit based on their unitLevel value.
A3EAI_setSkills = compileFinal '
	private["_unit","_unitLevel","_skillArray"];
	_unit = _this select 0;
	_unitLevel = _this select 1;

	_skillArray = missionNamespace getVariable ["A3EAI_skill"+str(_unitLevel),A3EAI_skill3];
	{
		_unit setskill [_x select 0,(((_x select 1) + random ((_x select 2)-(_x select 1))) min 1)];
	} forEach _skillArray;
';

//Combines two arrays and returns the combined array. Does not add duplicate values. Second array is appended to first array.
A3EAI_append = compileFinal '
	if (((typeName (_this select 0)) != "ARRAY")&&((typeName (_this select 1)) != "ARRAY")) exitWith {diag_log "A3EAI Error: A3EAI_append function was not provided with two arrays!";};
	{
		if !(_x in (_this select 0)) then {
			(_this select 0) pushBack _x;
		};
	} forEach (_this select 1);
	
	(_this select 0)
';

A3EAI_lootSearching = compileFinal '
	private ["_lootPiles","_lootPos","_unitGroup","_searchRange"];
	_unitGroup = _this select 0;
	_searchRange = _this select 1;
	
	_lootPiles = (getPosASL (leader _unitGroup)) nearObjects ["Animated_Loot",_searchRange];
	if ((count _lootPiles) > 0) then {
		_lootPos = ASLtoATL getPosASL (_lootPiles call BIS_fnc_selectRandom2);
		if ((behaviour (leader _unitGroup)) != "AWARE") then {_unitGroup setBehaviour "AWARE"};
		(units _unitGroup) doMove _lootPos;
		{_x moveTo _lootPos} forEach (units _unitGroup);
		//diag_log format ["DEBUG :: AI group %1 is investigating a loot pile at %2.",_unitGroup,_lootPos];
	};
';

//Prevents object from being destroyed/deleted from DayZ's anti-hacker check
A3EAI_protectObject = compileFinal '
	private ["_objectMonitor","_object","_index"];
	_object = _this;
	
	_object call EPOCH_server_setVToken;
	_object setVariable["LOCK_OWNER", "-1"];
	_object setVariable["LOCKED_TILL", 3.4028235e38];
	
	_index = A3EAI_monitoredObjects pushBack _object;
	
	_index
';

A3EAI_getUnitLevel = compileFinal '
	private ["_indexWeighted","_unitLevelIndexTable"];
	_unitLevelIndexTable = _this;
	
	_indexWeighted = call {
		if (_unitLevelIndexTable isEqualTo "airvehicle") exitWith {A3EAI_levelIndicesAir};			//2: Air vehicle AI spawns
		if (_unitLevelIndexTable isEqualTo "landvehicle") exitWith {A3EAI_levelIndicesLand};		//3: Land vehicle AI spawns
		[0]
	};
		
	A3EAI_unitLevels select (_indexWeighted call BIS_fnc_selectRandom2)
';

A3EAI_protectGroup = compileFinal '
	private ["_dummy"]; //_this = group
	
	_dummy = _this createUnit ["Logic",[0,0,0],[],0,"FORM"];
	[_dummy] joinSilent _this;
	if ((behaviour _dummy) != "AWARE") then {_this setBehaviour "AWARE"};
	_this setVariable ["dummyUnit",_dummy,A3EAI_enableHC];
	
	if (A3EAI_debugLevel > 1) then {diag_log format["A3EAI Extended Debug: Spawned 1 dummy AI unit to preserve group %1.",_this];};
	
	_dummy
';

A3EAI_addTempNVG = compileFinal '
	_this addWeapon "NVG_EPOCH";
	_this setVariable ["RemoveNVG",true,A3EAI_enableHC];
	
	true
';

A3EAI_respawnAIVehicle = compileFinal '
	private ["_vehicle","_unitType"];
	if (A3EAI_debugLevel > 1) then {diag_log format ["A3EAI Extended Debug: Respawning AI vehicle with params %1",_this]};
	_vehicle = _this select 0;
	_vehicleType = (_this select 1) select 0;
	_isCustom = (_this select 1) select 1;
	call {
		if (_isCustom) then {
			private ["_spawnParams"];
			_spawnParams = _vehicle getVariable ["spawnParams",false];
			if (_spawnParams select 4) then {
				[1,_spawnParams] call A3EAI_addRespawnQueue;
			};
			if (_vehicleType isKindOf "Air") then {A3EAI_curHeliPatrols = A3EAI_curHeliPatrols - 1} else {A3EAI_curLandPatrols = A3EAI_curLandPatrols - 1};
		} else {
			[2,_vehicleType] call A3EAI_addRespawnQueue;
			if (_vehicleType isKindOf "Air") then {A3EAI_curHeliPatrols = A3EAI_curHeliPatrols - 1} else {A3EAI_curLandPatrols = A3EAI_curLandPatrols - 1};
		};
	};
	_vehicle setVariable ["A3EAI_deathTime",diag_tickTime,A3EAI_enableHC]; //mark vehicle for cleanup
	
	true
';

A3EAI_updateSpawnCount = compileFinal '
	private ["_trigger","_arrayString","_triggerArray"];
	_trigger = _this select 0;
	_arrayString = _this select 1;
	
	_triggerArray = missionNamespace getVariable [_arrayString,[]];
	if (!isNull _trigger) then {
		if (_trigger in _triggerArray) then {
			_triggerArray = _triggerArray - [_trigger];
		} else {
			if ((triggerStatements _trigger select 1) in ["","_nul = thisList call A3EAI_allowDamageFix;"]) then {
				_triggerArray pushBack _trigger;
			};
		};
	};
	
	_triggerArray = _triggerArray - [objNull];
	missionNamespace setVariable [_arrayString,_triggerArray];
';

A3EAI_deleteGroup = compileFinal '
	[_this,false] call A3EAI_updGroupCount;
	
	{
		if (alive _x) then {
			deleteVehicle _x;
		} else {
			[_x] joinSilent grpNull;
		};
	} count (units _this);
	deleteGroup _this;
	
	true
';

A3EAI_chance = compileFinal '
	private ["_result"];
	_result = ((random 1) < _this);
	
	_result
';


A3EAI_addMapMarker = compileFinal '
	private ["_mapMarkerArray","_objectString"];
	_mapMarkerArray = missionNamespace getVariable ["A3EAI_mapMarkerArray",[]];
	_objectString = str (_this);
	if !(_objectString in _mapMarkerArray) then {	//Determine if marker is new
		if ((getMarkerColor _objectString) isEqualTo "") then {
			private ["_marker"];
			_marker = createMarker [_objectString, (getPosASL _this)];
			_marker setMarkerType "mil_circle";
			_marker setMarkerBrush "Solid";
		};
		_mapMarkerArray pushBack _objectString;
		missionNamespace setVariable ["A3EAI_mapMarkerArray",_mapMarkerArray];
	};
	if (_this isKindOf "EmptyDetector") then {	//Set marker as active
		_objectString setMarkerText "STATIC TRIGGER (ACTIVE)";
		_objectString setMarkerColor "ColorRed";
	};
';

A3EAI_purgeUnitGear = compileFinal '
	//Commented lines: Need proper handling for adding these item types first.
	removeAllWeapons _this;
	removeAllItems _this;
	removeAllAssignedItems _this;
	removeGoggles _this;
	removeHeadgear _this;
	removeBackpack _this;
	removeUniform _this;
	removeVest _this;
';

A3EAI_addItem = compileFinal '
	_unit = (_this select 0);
	_item = (_this select 1);
	if (_unit canAddItemToVest _item) exitWith {_unit addItemToVest _item; true};
	if (_unit canAddItemToBackpack _item) exitWith {_unit addItemToBackpack _item; true};
	false
';


A3EAI_addEH = compileFinal '
	if (isNull _this) exitWith {};

	_this addEventHandler [
		"HandleDamage",
		"_this call A3EAI_handleDamageUnit;"
	];

	_this addEventHandler [
		"Killed",
		"_this call A3EAI_handleDeathEvent;"
	];

	true
';

A3EAI_forceBehavior = compileFinal '
	_action = (_this select 1);
	if (_action isEqualTo "IgnoreEnemies") exitWith {
		_unitGroup = _this select 0;
		_unitGroup setVariable ["Behavior_Save",(behaviour (leader _unitGroup))];
		_unitGroup setBehaviour "CARELESS";
		{_x doWatch objNull} forEach (units _unitGroup);
		_unitGroup setVariable ["EnemiesIgnored",true];
		true
	};
	if (_action isEqualTo "IgnoreEnemies_Undo") exitWith {
		_unitGroup setBehaviour (_unitGroup getVariable ["Behavior_Save","AWARE"]);
		_unitGroup setVariable ["EnemiesIgnored",false];
		true
	};
';

A3EAI_createBlackListArea = compileFinal '
	private ["_pos","_size"];

	_pos = _this select 0;
	_size = _this select 1;

	createLocation ["Strategic",_pos,_size,_size]	
';

A3EAI_setFirstWPPos = compileFinal '
	private ["_unitGroup","_position","_waypoint","_result"];
	_unitGroup = _this select 0;
	_position = _this select 1;
	_result = false;
	if !(surfaceIsWater _position) then {
		_waypoint = [_unitGroup,0];
		_waypoint setWaypointType "MOVE";
		_waypoint setWaypointCompletionRadius 40;
		_waypoint setWaypointTimeout [4,6,8];
		_waypoint setWPPos _position;
		_unitGroup setCurrentWaypoint _waypoint;
		_result = true;
	};
	
	_result
';

diag_log "[A3EAI] A3EAI functions compiled.";
