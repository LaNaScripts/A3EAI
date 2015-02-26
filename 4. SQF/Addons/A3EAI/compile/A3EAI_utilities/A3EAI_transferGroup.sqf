private ["_unitGroup"];
_unitGroup = _this select 0;
//_vehicle = _this select 1;

{
	_x addEventHandler ["Local",{
		if (_this select 1) then {
			private["_unit","_unitGroup","_unitLevel"];
			_unit = _this select 0;
			_unit removeAllEventHandlers "Local";
			_unitGroup = (group _unit);
			if !(_unitGroup getVariable ["isManaged",false]) then {
				_unitLevel = _unitGroup getVariable ["unitLevel",1];
				_unitGroup setVariable ["FirstTimeManaged",false];
				0 = [_unitGroup,_unitLevel] spawn A3EAI_addGroupManager2;
			};
		};
	}];
} forEach (units _unitGroup);

A3EAI_transferGroup = _unitGroup;
A3EAI_HCObjectOwnerID publicVariableClient "A3EAI_transferGroup";

true