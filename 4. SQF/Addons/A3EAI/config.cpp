class CfgPatches {
	class A3EAI {
		units[] = {};
		weapons[] = {};
		requiredVersion = 0.1;
		A3EAIVersion = "0.1.4 Alpha";
		requiredAddons[] = {"a3_epoch_code","a3_epoch_server"};
	};
};

class CfgFunctions {
	class A3EAI {
		class A3EAI_Server {
		file = "A3EAI";
			class A3EAI_init {
				preInit = 1;
			};
		};
	};
};
