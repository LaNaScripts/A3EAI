private ["_unitLevel", "_weaponIndices", "_weaponList"];

_unitLevel = _this;
_weaponIndices = missionNamespace getVariable ["A3EAI_weaponTypeIndices"+str(_unitLevel),[0,1,2,3]];
_weaponList = ["A3EAI_pistolList","A3EAI_rifleList","A3EAI_machinegunList","A3EAI_sniperList"] select (_weaponIndices call BIS_fnc_selectRandom2);
_weaponListSelected = missionNamespace getVariable [_weaponList,"A3EAI_rifleList"];
//diag_log format ["Selected weapon table: %1",_weaponList];

_weaponListSelected