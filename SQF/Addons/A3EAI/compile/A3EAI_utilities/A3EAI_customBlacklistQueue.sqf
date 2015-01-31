if (isNil "A3EAI_customBlacklistQueue") then {
	A3EAI_customBlacklistQueue = [_this];
	_blacklistQueue = [] spawn {
		//uiSleep 0.5;
		_continue = true;
		while {_continue} do {
			_statement = (A3EAI_customBlacklistQueue select 0);
			_statement deleteAt 0;
			_statement call A3EAI_createBlackListArea;
			A3EAI_customBlacklistQueue deleteAt 0;
			if (A3EAI_debugLevel > 0) then {diag_log format ["A3EAI Debug: Creating blacklist area at with radius %1",_statement select 0,_statement select 1];};
			uiSleep 3;
			_continue = !(A3EAI_customBlacklistQueue isEqualTo []);
		};
		A3EAI_customBlacklistQueue = nil;
	};
} else {
	A3EAI_customBlacklistQueue pushBack _this;
};
