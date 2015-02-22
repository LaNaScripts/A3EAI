private ["_unitGroup","_detectBase","_detectFactor","_vehicle","_canParaDrop","_detectStartPos"];
_unitGroup = _this select 0;

if (_unitGroup getVariable ["EnemiesIgnored",false]) then {[_unitGroup,"IgnoreEnemies_Undo"] call A3EAI_forceBehavior};

_vehicle = vehicle (leader _unitGroup);

//uiSleep (round (random _detectDelay));
uiSleep 2;

if (_unitGroup getVariable ["HeliDetectReady",true]) then {
	_unitGroup setVariable ["HeliDetectReady",false];
	_detectStartPos = getPosASL _vehicle;
	_canParaDrop = ((_unitGroup getVariable ["HeliReinforceOrdered",false]) or {(A3EAI_paraDropChance call A3EAI_chance) && {(diag_tickTime - (_unitGroup getVariable ["HeliLastParaDrop",diag_tickTime])) > 1800}});
	while {!(_vehicle getVariable ["heli_disabled",false])} do {
		private ["_detected","_detectOrigin","_detectedCount","_startPos"];
		//diag_log format ["DEBUG: Group %1 AI %2 is beginning detection sweep...",_unitGroup,(typeOf _vehicle)];
		_startPos = getPosATL _vehicle;
		_detectOrigin = [_startPos,100,getDir _vehicle,1] call SHK_pos;
		_detectOrigin set [2,0];
		_detected = _detectOrigin nearEntities [["Epoch_Male_F","Epoch_Female_F"],275];
		_detectedCount = (count _detected);
		if (_detectedCount > 0) then {
			if (_detectedCount > 10) then {_detected resize 10};
			//diag_log format ["DEBUG: Group %1 AI %2 has paradrop available: %3",_unitGroup,(typeOf _vehicle),((diag_tickTime - (_unitGroup getVariable ["HeliLastParaDrop",diag_tickTime])) > 1800)];
			{
				if (isPlayer _x) then {
					if (_canParaDrop) then {
						if (_unitGroup getVariable ["HeliReinforceOrdered",false]) then {
							_unitGroup setVariable ["HeliReinforceOrdered",false];
						} else {
							_unitGroup setVariable ["HeliLastParaDrop",diag_tickTime];
						};
						_nul = [_unitGroup,_vehicle,_x] spawn A3EAI_heliParaDrop;
						if (A3EAI_debugLevel > 1) then {diag_log format ["A3EAI Extended Debug: %1 group %2 is deploying paradrop reinforcements at %3.",(typeOf _vehicle),_unitGroup,_detectOrigin];};
					};
					//diag_log format ["DEBUG: Group %1 AI %2 is checking LOS with player %3...",_unitGroup,(typeOf _vehicle),_x];
					_heliAimPos = aimPos _vehicle;
					_playerEyePos = eyePos _x;
					if (!(terrainIntersectASL [_heliAimPos,_playerEyePos]) && {!(lineIntersects [_heliAimPos,_playerEyePos,_vehicle,_x])}) then { //if no intersection of terrain and objects between helicopter and player, then reveal player
						if (A3EAI_detectChance call A3EAI_chance) then {
							_unitGroup reveal [_x,2]; 
						};
					};
					_canParaDrop = false;
				};
				uiSleep 0.1;
			} forEach _detected;
		};
		if (((_vehicle distance _detectStartPos) > 700) or {_vehicle getVariable ["heli_disabled",false]}) exitWith {_unitGroup setVariable ["HeliDetectReady",true]};
		uiSleep 15;
	};
};
