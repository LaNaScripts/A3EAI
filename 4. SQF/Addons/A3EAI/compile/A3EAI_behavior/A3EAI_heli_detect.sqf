private ["_unitGroup","_detectBase","_detectFactor","_detectRange","_helicopter"];
_unitGroup = _this select 0;

if (_unitGroup getVariable ["EnemiesIgnored",false]) then {[_unitGroup,"IgnoreEnemies_Undo"] call A3EAI_forceBehavior};

_helicopter = vehicle (leader _unitGroup);
_detectRange = if (_unitGroup getVariable ["SAD_Ready",true]) then {275} else {375};

//uiSleep (round (random _detectDelay));
uiSleep 2;

if (_unitGroup getVariable ["HeliDetectReady",true]) then {
	_unitGroup setVariable ["HeliDetectReady",false];
	_detectStartPos = getPosASL _helicopter;
	while {!(_helicopter getVariable ["heli_disabled",false])} do {
		private ["_detected","_detectOrigin","_detectedCount","_startPos"];
		_startPos = getPosASL _helicopter;
		_detectOrigin = [_startPos,100,getDir _helicopter,1] call SHK_pos;
		_detectOrigin set [2,0];
		_detected = _detectOrigin nearEntities [["Epoch_Male_F","Epoch_Female_F"],_detectRange];
		_detectedCount = (count _detected);
		if (_detectedCount > 0) then {
			if (_detectedCount > 10) then {_detected resize 10};
			{
				if (isPlayer _x) then {
					_heliAimPos = aimPos _helicopter;
					_playerEyePos = eyePos _x;
					if (!(terrainIntersectASL [_heliAimPos,_playerEyePos]) && {!(lineIntersects [_heliAimPos,_playerEyePos,_helicopter,_x])}) then { //if no intersection of terrain and objects between helicopter and player, then reveal player
						if (0.7 call A3EAI_chance) then {
							_unitGroup reveal [_x,1.9];
						};
					};
				};
				uiSleep 0.1;
			} forEach _detected;
			
			if (((_helicopter distance _detectStartPos) > 750) or {_helicopter getVariable ["heli_disabled",false]}) exitWith {_unitGroup setVariable ["HeliDetectReady",true]};
			//if (_forEachIndex > 10) exitWith {};
			uiSleep 15;
		} else {
			uiSleep 7.5;
		};
	};
};
