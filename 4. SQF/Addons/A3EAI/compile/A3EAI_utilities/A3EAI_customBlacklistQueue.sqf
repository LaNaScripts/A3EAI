if !((typeName _this) isEqualTo "ARRAY") exitWith {diag_log format ["Error: Wrong arguments sent to %1.",__FILE__]};
if (A3EAI_customBlacklistQueue isEqualTo []) then {
	A3EAI_customBlacklistQueue pushBack _this;
	_blacklistQueue = [] spawn {
		while {!(A3EAI_customBlacklistQueue isEqualTo [])} do {
			_statement = (A3EAI_customBlacklistQueue select 0);
			_statement deleteAt 0;
			if ((_statement select 1) > 1499) then {_statement set [1,1499];};
			_statement call A3EAI_createBlackListArea;
			A3EAI_customBlacklistQueue deleteAt 0;
			if (A3EAI_debugLevel > 0) then {diag_log format ["A3EAI Debug: Creating blacklist area at with radius %1",_statement select 0,_statement select 1];};
			uiSleep 1;
		};
	};
} else {
	A3EAI_customBlacklistQueue pushBack _this;
};
