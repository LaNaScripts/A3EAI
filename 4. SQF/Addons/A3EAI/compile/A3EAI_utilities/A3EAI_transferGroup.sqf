private ["_unitGroup"];
_unitGroup = _this select 0;
_vehicle = _this select 1;

{
	_x addEventHandler ["Local",{
		if (_this select 1) then {
			private["_unit","_unitGroup"];
			_unit = _this select 0;
			_unit removeAllEventHandlers "Local";
			_unitGroup = (group _unit);
			if ((leader _unitGroup) isEqualTo _unit) then {
				_unitLevel = _unitGroup getVariable ["unitLevel",1];
				0 = [_unitGroup,_unitLevel] spawn A3EAI_addGroupManager;	//start group-level manager
			};
		};
	}];
} forEach (units _unitGroup);

A3EAI_transferGroup = _unitGroup;
A3EAI_HCObjectOwnerID publicVariableClient "A3EAI_transferGroup";
