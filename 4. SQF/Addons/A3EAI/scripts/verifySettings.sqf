_startTime = diag_tickTime;

//Check value types
{
	_value = missionNamespace getVariable (_x select 0);
	if ((isNil "_value") or {(typeName _value) != (typeName (_x select 1))}) then {
		missionNamespace setVariable [(_x select 0),(_x select 1)];
		diag_log format ["[A3EAI] Error found in variable %1, resetting to default value.",(_x select 0)];
	};
} forEach [
	["A3EAI_debugLevel",0],
	["A3EAI_monitorRate",300],
	["A3EAI_verifyClassnames",true],
	["A3EAI_cleanupDelay",900],
	["A3EAI_dynamicUniformList",true],
	["A3EAI_dynamicWeaponList",true],
	["A3EAI_dynamicBackpackList",true],
	["A3EAI_dynamicVestList",true],
	["A3EAI_dynamicHeadgearList",true],
	["A3EAI_dynamicFoodList",true],
	["A3EAI_dynamicLootList",true],
	["A3EAI_dynamicLootLargeList",true],
	["A3EAI_dynamicWeaponBlacklist",[]],
	["A3EAI_findKiller",true],
	["A3EAI_tempNVGs",false],
	["A3EAI_launcherTypes",[]],
	["A3EAI_launcherLevels",[]],
	["A3EAI_launchersPerGroup",1],
	["A3EAI_enableHealing",true],
	["A3EAI_radioMsgs",false],
	["A3EAI_deathMessages",false],
	["A3EAI_loadCustomFile",true],
	["A3EAI_autoGenerateStatic",true],
	["A3EAI_minAI_capitalCity",2],
	["A3EAI_addAI_capitalCity",1],
	["A3EAI_unitLevel_capitalCity",1],
	["A3EAI_minAI_city",1],
	["A3EAI_addAI_city",2],
	["A3EAI_unitLevel_city",1],
	["A3EAI_minAI_village",1],
	["A3EAI_addAI_village",1],
	["A3EAI_unitLevel_village",0],
	["A3EAI_minAI_remoteArea",1],
	["A3EAI_addAI_remoteArea",1],
	["A3EAI_unitLevel_remoteArea",2],
	["A3EAI_tempBlacklistTime",600],
	["A3EAI_promoteChances",[0.20,0.10,0.10]],
	["A3EAI_respawnTimeMin",300],
	["A3EAI_respawnTimeMax",600],
	["A3EAI_despawnWait",120],
	["A3EAI_spawnChance0",0.40],
	["A3EAI_spawnChance1",0.60],
	["A3EAI_spawnChance2",0.80],
	["A3EAI_spawnChance3",0.90],
	["A3EAI_respawnLimit0",-1],
	["A3EAI_respawnLimit1",-1],
	["A3EAI_respawnLimit2",-1],
	["A3EAI_respawnLimit3",-1],
	["A3EAI_dynAISpawns",true],
	["A3EAI_dynSpawnChance",0.40],
	["A3EAI_dynMaxSpawns",15],
	["A3EAI_dynCooldownTime",900],
	["A3EAI_dynResetLastSpawn",3600],
	["A3EAI_huntingChance",0.60],
	["A3EAI_heliReinforceChance",0.30],
	["A3EAI_dynDespawnWait",120],
	["A3EAI_maxRandomSpawns",0],
	["A3EAI_randDespawnWait",120],
	["A3EAI_minRandSpawnDist",600],
	["A3EAI_maxHeliPatrols",0],
	["A3EAI_levelChancesAir",[0.00,0.50,0.35,0.15]],
	["A3EAI_respawnTMinA",600],
	["A3EAI_respawnTMaxA",900],
	["A3EAI_heliList",[
		["B_Heli_Light_01_armed_F",5],
		["B_Heli_Attack_01_F",2]
	]],
	["A3EAI_heliGunnerUnits",3],
	["A3EAI_removeMissileWeapons",true],
	["A3EAI_detectChance",0.70],
	["A3EAI_paraDropChance",0.50],
	["A3EAI_paraDropCooldown",1800],
	["A3EAI_paraDropAmount",3],
	["A3EAI_maxLandPatrols",0],
	["A3EAI_levelChancesLand",[0.00,0.50,0.35,0.15]],
	["A3EAI_respawnTMinL",600],
	["A3EAI_respawnTMaxL",900],
	["A3EAI_vehList",[
		["C_Van_01_transport_EPOCH",5],
		["C_Offroad_01_EPOCH",5],
		["C_Hatchback_02_EPOCH",5],
		["C_Hatchback_01_EPOCH",5],
		["B_Truck_01_transport_EPOCH",5],
		["B_Truck_01_mover_EPOCH",5],
		["B_Truck_01_covered_EPOCH",5],
		["B_Truck_01_box_EPOCH",5]
	]],
	["A3EAI_vehGunnerUnits",2],
	["A3EAI_vehCargoUnits",3],
	["A3EAI_waypointBlacklist",[]],
	["A3EAI_skill0",[	
		["aimingAccuracy",0.10,0.15],
		["aimingShake",0.50,0.59],
		["aimingSpeed",0.50,0.59],
		["spotDistance",0.50,0.59],
		["spotTime",0.50,0.59],
		["courage",0.50,0.59],
		["reloadSpeed",0.50,0.59],
		["commanding",0.50,0.59],
		["general",0.50,0.59]
	]],
	["A3EAI_skill1",[	
		["aimingAccuracy",0.15,0.20],
		["aimingShake",0.60,0.69],
		["aimingSpeed",0.60,0.69],
		["spotDistance",0.60,0.69],
		["spotTime",0.60,0.69],
		["courage",0.60,0.69],
		["reloadSpeed",0.60,0.69],
		["commanding",0.60,0.69],
		["general",0.60,0.69]
	]],
	["A3EAI_skill2",[	
		["aimingAccuracy",0.20,0.25],
		["aimingShake",0.70,0.85],
		["aimingSpeed",0.70,0.85],
		["spotDistance",0.70,0.85],
		["spotTime",0.70,0.85],
		["courage",0.70,0.85],
		["reloadSpeed",0.70,0.85],
		["commanding",0.70,0.85],
		["general",0.70,0.85]
	]],
	["A3EAI_skill3",[	
		["aimingAccuracy",0.25,0.30],
		["aimingShake",0.85,0.95],
		["aimingSpeed",0.85,0.95],
		["spotDistance",0.85,0.95],
		["spotTime",0.85,0.95],
		["courage",0.85,0.95],
		["reloadSpeed",0.85,0.95],
		["commanding",0.85,0.95],
		["general",0.85,0.95]
	]],
	["A3EAI_useWeaponChance0",[0.20,0.80,0.00,0.00]],
	["A3EAI_useWeaponChance1",[0.00,0.90,0.05,0.05]],
	["A3EAI_useWeaponChance2",[0.00,0.80,0.10,0.10]],
	["A3EAI_useWeaponChance3",[0.00,0.70,0.15,0.15]],
	["A3EAI_opticsChance0",0.00],
	["A3EAI_opticsChance1",0.25],
	["A3EAI_opticsChance2",0.50],
	["A3EAI_opticsChance3",0.75],
	["A3EAI_pointerChance0",0.00],
	["A3EAI_pointerChance1",0.25],
	["A3EAI_pointerChance2",0.50],
	["A3EAI_pointerChance3",0.75],
	["A3EAI_muzzleChance0",0.00],
	["A3EAI_muzzleChance1",0.25],
	["A3EAI_muzzleChance2",0.50],
	["A3EAI_muzzleChance3",0.75],
	["A3EAI_kryptoAmount0",25],
	["A3EAI_kryptoAmount1",50],
	["A3EAI_kryptoAmount2",75],
	["A3EAI_kryptoAmount3",100],
	["A3EAI_foodLootCount",1],
	["A3EAI_miscLootCount1",1],
	["A3EAI_miscLootCount2",1],
	["A3EAI_chanceFirstAidKit",0.20],
	["A3EAI_chanceFoodLoot",0.40],
	["A3EAI_chanceMiscLoot1",0.40],
	["A3EAI_chanceMiscLoot2",0.30],
	["A3EAI_lootPullChance0",0.30],
	["A3EAI_lootPullChance1",0.40],
	["A3EAI_lootPullChance2",0.50],
	["A3EAI_lootPullChance3",0.60],
	["A3EAI_uniformTypes",["U_O_CombatUniform_ocamo", "U_O_GhillieSuit", "U_O_PilotCoveralls", "U_O_Wetsuit", "U_OG_Guerilla1_1", "U_OG_Guerilla2_1", "U_OG_Guerilla2_3", "U_OG_Guerilla3_1", "U_OG_Guerilla3_2", "U_OG_leader", "U_C_Poloshirt_stripped", "U_C_Poloshirt_blue", "U_C_Poloshirt_burgundy", "U_C_Poloshirt_tricolour", "U_C_Poloshirt_salmon", "U_C_Poloshirt_redwhite", "U_C_Poor_1", "U_C_WorkerCoveralls", "U_C_Journalist", "U_C_Scientist", "U_OrestesBody", "U_Wetsuit_uniform", "U_Wetsuit_White", "U_Wetsuit_Blue", "U_Wetsuit_Purp", "U_Wetsuit_Camo", "U_CamoRed_uniform", "U_CamoBrn_uniform", "U_CamoBlue_uniform", "U_Camo_uniform", "U_ghillie1_uniform", "U_ghillie2_uniform", "U_ghillie3_uniform", "U_C_Driver_1", "U_C_Driver_2", "U_C_Driver_3", "U_C_Driver_4", "U_C_Driver_1_black", "U_C_Driver_1_blue", "U_C_Driver_1_green", "U_C_Driver_1_red", "U_C_Driver_1_white", "U_C_Driver_1_yellow", "U_C_Driver_1_orange", "U_C_Driver_1_red"]],
	["A3EAI_pistolList",["hgun_ACPC2_F", "hgun_ACPC2_F", "hgun_Rook40_F", "hgun_Rook40_F", "hgun_Rook40_F", "hgun_P07_F", "hgun_P07_F", "hgun_Pistol_heavy_01_F", "hgun_Pistol_heavy_02_F", "ruger_pistol_epoch", "ruger_pistol_epoch", "1911_pistol_epoch", "1911_pistol_epoch"]],
	["A3EAI_rifleList",["arifle_Katiba_F", "arifle_Katiba_F", "arifle_Katiba_C_F", "arifle_Katiba_GL_F", "arifle_MXC_F", "arifle_MX_F", "arifle_MX_F", "arifle_MX_GL_F", "arifle_MXM_F", "arifle_SDAR_F", "arifle_TRG21_F", "arifle_TRG20_F", "arifle_TRG21_GL_F", "arifle_Mk20_F", "arifle_Mk20C_F", "arifle_Mk20_GL_F", "arifle_Mk20_plain_F", "arifle_Mk20_plain_F", "arifle_Mk20C_plain_F", "arifle_Mk20_GL_plain_F", "SMG_01_F", "SMG_02_F", "SMG_01_F", "SMG_02_F", "hgun_PDW2000_F", "hgun_PDW2000_F", "arifle_MXM_Black_F", "arifle_MX_GL_Black_F", "arifle_MX_Black_F", "arifle_MXC_Black_F", "Rollins_F", "Rollins_F", "Rollins_F", "Rollins_F", "AKM_EPOCH", "m4a3_EPOCH", "m16_EPOCH", "m16Red_EPOCH"]],
	["A3EAI_machinegunList",["LMG_Mk200_F", "arifle_MX_SW_F", "LMG_Zafir_F", "arifle_MX_SW_Black_F", "m249_EPOCH", "m249Tan_EPOCH"]],
	["A3EAI_sniperList",["srifle_EBR_F", "srifle_EBR_F", "srifle_GM6_F", "srifle_GM6_F", "srifle_LRR_F", "srifle_DMR_01_F", "M14_EPOCH", "M14Grn_EPOCH", "m107_EPOCH", "m107Tan_EPOCH"]],
	["A3EAI_backpackTypes0",["B_AssaultPack_cbr", "B_AssaultPack_dgtl", "B_AssaultPack_khk", "B_AssaultPack_mcamo", "B_AssaultPack_ocamo", "B_AssaultPack_rgr", "B_AssaultPack_sgg", "B_Carryall_cbr", "B_Carryall_khk", "B_Carryall_mcamo", "B_Carryall_ocamo", "B_Carryall_oli", "B_Carryall_oucamo", "B_FieldPack_blk", "B_FieldPack_cbr", "B_FieldPack_khk", "B_FieldPack_ocamo", "B_FieldPack_oli", "B_FieldPack_oucamo", "B_Kitbag_cbr", "B_Kitbag_mcamo", "B_Kitbag_rgr", "B_Kitbag_sgg", "B_Parachute", "B_TacticalPack_blk", "B_TacticalPack_mcamo", "B_TacticalPack_ocamo", "B_TacticalPack_oli", "B_TacticalPack_rgr", "smallbackpack_red_epoch", "smallbackpack_green_epoch", "smallbackpack_teal_epoch", "smallbackpack_pink_epoch"]],
	["A3EAI_backpackTypes1",["B_AssaultPack_cbr", "B_AssaultPack_dgtl", "B_AssaultPack_khk", "B_AssaultPack_mcamo", "B_AssaultPack_ocamo", "B_AssaultPack_rgr", "B_AssaultPack_sgg", "B_Carryall_cbr", "B_Carryall_khk", "B_Carryall_mcamo", "B_Carryall_ocamo", "B_Carryall_oli", "B_Carryall_oucamo", "B_FieldPack_blk", "B_FieldPack_cbr", "B_FieldPack_khk", "B_FieldPack_ocamo", "B_FieldPack_oli", "B_FieldPack_oucamo", "B_Kitbag_cbr", "B_Kitbag_mcamo", "B_Kitbag_rgr", "B_Kitbag_sgg", "B_Parachute", "B_TacticalPack_blk", "B_TacticalPack_mcamo", "B_TacticalPack_ocamo", "B_TacticalPack_oli", "B_TacticalPack_rgr", "smallbackpack_red_epoch", "smallbackpack_green_epoch", "smallbackpack_teal_epoch", "smallbackpack_pink_epoch"]],
	["A3EAI_backpackTypes2",["B_AssaultPack_cbr", "B_AssaultPack_dgtl", "B_AssaultPack_khk", "B_AssaultPack_mcamo", "B_AssaultPack_ocamo", "B_AssaultPack_rgr", "B_AssaultPack_sgg", "B_Carryall_cbr", "B_Carryall_khk", "B_Carryall_mcamo", "B_Carryall_ocamo", "B_Carryall_oli", "B_Carryall_oucamo", "B_FieldPack_blk", "B_FieldPack_cbr", "B_FieldPack_khk", "B_FieldPack_ocamo", "B_FieldPack_oli", "B_FieldPack_oucamo", "B_Kitbag_cbr", "B_Kitbag_mcamo", "B_Kitbag_rgr", "B_Kitbag_sgg", "B_Parachute", "B_TacticalPack_blk", "B_TacticalPack_mcamo", "B_TacticalPack_ocamo", "B_TacticalPack_oli", "B_TacticalPack_rgr", "smallbackpack_red_epoch", "smallbackpack_green_epoch", "smallbackpack_teal_epoch", "smallbackpack_pink_epoch"]],
	["A3EAI_backpackTypes3",["B_AssaultPack_cbr", "B_AssaultPack_dgtl", "B_AssaultPack_khk", "B_AssaultPack_mcamo", "B_AssaultPack_ocamo", "B_AssaultPack_rgr", "B_AssaultPack_sgg", "B_Carryall_cbr", "B_Carryall_khk", "B_Carryall_mcamo", "B_Carryall_ocamo", "B_Carryall_oli", "B_Carryall_oucamo", "B_FieldPack_blk", "B_FieldPack_cbr", "B_FieldPack_khk", "B_FieldPack_ocamo", "B_FieldPack_oli", "B_FieldPack_oucamo", "B_Kitbag_cbr", "B_Kitbag_mcamo", "B_Kitbag_rgr", "B_Kitbag_sgg", "B_Parachute", "B_TacticalPack_blk", "B_TacticalPack_mcamo", "B_TacticalPack_ocamo", "B_TacticalPack_oli", "B_TacticalPack_rgr", "smallbackpack_red_epoch", "smallbackpack_green_epoch", "smallbackpack_teal_epoch", "smallbackpack_pink_epoch"]],
	["A3EAI_vestTypes0",["V_1_EPOCH", "V_2_EPOCH", "V_3_EPOCH", "V_4_EPOCH", "V_5_EPOCH", "V_6_EPOCH", "V_7_EPOCH", "V_8_EPOCH", "V_9_EPOCH", "V_10_EPOCH", "V_11_EPOCH", "V_12_EPOCH", "V_13_EPOCH", "V_14_EPOCH", "V_15_EPOCH", "V_16_EPOCH", "V_17_EPOCH", "V_18_EPOCH", "V_19_EPOCH", "V_20_EPOCH", "V_21_EPOCH", "V_22_EPOCH", "V_23_EPOCH", "V_24_EPOCH", "V_25_EPOCH", "V_26_EPOCH", "V_27_EPOCH", "V_28_EPOCH", "V_29_EPOCH", "V_30_EPOCH", "V_31_EPOCH", "V_32_EPOCH", "V_33_EPOCH", "V_34_EPOCH", "V_35_EPOCH", "V_36_EPOCH", "V_37_EPOCH", "V_38_EPOCH", "V_39_EPOCH", "V_40_EPOCH"]],
	["A3EAI_vestTypes1",["V_1_EPOCH", "V_2_EPOCH", "V_3_EPOCH", "V_4_EPOCH", "V_5_EPOCH", "V_6_EPOCH", "V_7_EPOCH", "V_8_EPOCH", "V_9_EPOCH", "V_10_EPOCH", "V_11_EPOCH", "V_12_EPOCH", "V_13_EPOCH", "V_14_EPOCH", "V_15_EPOCH", "V_16_EPOCH", "V_17_EPOCH", "V_18_EPOCH", "V_19_EPOCH", "V_20_EPOCH", "V_21_EPOCH", "V_22_EPOCH", "V_23_EPOCH", "V_24_EPOCH", "V_25_EPOCH", "V_26_EPOCH", "V_27_EPOCH", "V_28_EPOCH", "V_29_EPOCH", "V_30_EPOCH", "V_31_EPOCH", "V_32_EPOCH", "V_33_EPOCH", "V_34_EPOCH", "V_35_EPOCH", "V_36_EPOCH", "V_37_EPOCH", "V_38_EPOCH", "V_39_EPOCH", "V_40_EPOCH"]],
	["A3EAI_vestTypes2",["V_1_EPOCH", "V_2_EPOCH", "V_3_EPOCH", "V_4_EPOCH", "V_5_EPOCH", "V_6_EPOCH", "V_7_EPOCH", "V_8_EPOCH", "V_9_EPOCH", "V_10_EPOCH", "V_11_EPOCH", "V_12_EPOCH", "V_13_EPOCH", "V_14_EPOCH", "V_15_EPOCH", "V_16_EPOCH", "V_17_EPOCH", "V_18_EPOCH", "V_19_EPOCH", "V_20_EPOCH", "V_21_EPOCH", "V_22_EPOCH", "V_23_EPOCH", "V_24_EPOCH", "V_25_EPOCH", "V_26_EPOCH", "V_27_EPOCH", "V_28_EPOCH", "V_29_EPOCH", "V_30_EPOCH", "V_31_EPOCH", "V_32_EPOCH", "V_33_EPOCH", "V_34_EPOCH", "V_35_EPOCH", "V_36_EPOCH", "V_37_EPOCH", "V_38_EPOCH", "V_39_EPOCH", "V_40_EPOCH"]],
	["A3EAI_vestTypes3",["V_1_EPOCH", "V_2_EPOCH", "V_3_EPOCH", "V_4_EPOCH", "V_5_EPOCH", "V_6_EPOCH", "V_7_EPOCH", "V_8_EPOCH", "V_9_EPOCH", "V_10_EPOCH", "V_11_EPOCH", "V_12_EPOCH", "V_13_EPOCH", "V_14_EPOCH", "V_15_EPOCH", "V_16_EPOCH", "V_17_EPOCH", "V_18_EPOCH", "V_19_EPOCH", "V_20_EPOCH", "V_21_EPOCH", "V_22_EPOCH", "V_23_EPOCH", "V_24_EPOCH", "V_25_EPOCH", "V_26_EPOCH", "V_27_EPOCH", "V_28_EPOCH", "V_29_EPOCH", "V_30_EPOCH", "V_31_EPOCH", "V_32_EPOCH", "V_33_EPOCH", "V_34_EPOCH", "V_35_EPOCH", "V_36_EPOCH", "V_37_EPOCH", "V_38_EPOCH", "V_39_EPOCH", "V_40_EPOCH"]],
	["A3EAI_headgearTypes",["H_1_EPOCH","H_2_EPOCH","H_3_EPOCH","H_4_EPOCH","H_5_EPOCH","H_6_EPOCH","H_7_EPOCH","H_8_EPOCH","H_9_EPOCH","H_10_EPOCH","H_11_EPOCH","H_12_EPOCH","H_13_EPOCH","H_14_EPOCH","H_15_EPOCH","H_16_EPOCH","H_17_EPOCH","H_18_EPOCH","H_19_EPOCH","H_20_EPOCH","H_21_EPOCH","H_22_EPOCH","H_23_EPOCH","H_24_EPOCH","H_25_EPOCH","H_26_EPOCH","H_27_EPOCH","H_28_EPOCH","H_29_EPOCH","H_30_EPOCH","H_31_EPOCH","H_32_EPOCH","H_33_EPOCH","H_34_EPOCH","H_35_EPOCH","H_36_EPOCH","H_37_EPOCH","H_38_EPOCH","H_39_EPOCH","H_40_EPOCH","H_41_EPOCH","H_42_EPOCH","H_43_EPOCH","H_44_EPOCH","H_45_EPOCH","H_46_EPOCH","H_47_EPOCH","H_48_EPOCH","H_49_EPOCH","H_50_EPOCH","H_51_EPOCH","H_52_EPOCH","H_53_EPOCH","H_54_EPOCH","H_55_EPOCH","H_56_EPOCH","H_57_EPOCH","H_58_EPOCH","H_59_EPOCH","H_60_EPOCH","H_61_EPOCH","H_62_EPOCH","H_63_EPOCH","H_64_EPOCH","H_65_EPOCH","H_66_EPOCH","H_67_EPOCH","H_68_EPOCH","H_69_EPOCH","H_70_EPOCH","H_71_EPOCH","H_72_EPOCH","H_73_EPOCH","H_74_EPOCH","H_75_EPOCH","H_76_EPOCH","H_77_EPOCH","H_78_EPOCH","H_79_EPOCH","H_80_EPOCH","H_81_EPOCH","H_82_EPOCH","H_83_EPOCH","H_84_EPOCH","H_85_EPOCH","H_86_EPOCH","H_87_EPOCH","H_88_EPOCH","H_89_EPOCH","H_90_EPOCH","H_91_EPOCH","H_92_EPOCH","H_93_EPOCH","H_94_EPOCH","H_95_EPOCH","H_96_EPOCH","H_97_EPOCH","H_98_EPOCH","H_99_EPOCH","H_100_EPOCH","H_101_EPOCH","H_102_EPOCH","H_103_EPOCH","H_104_EPOCH"]],
	["A3EAI_foodLoot",["FoodSnooter","FoodWalkNSons","FoodBioMeat","ItemSodaOrangeSherbet","ItemSodaPurple","ItemSodaMocha","ItemSodaBurst","ItemSodaRbull","honey_epoch","emptyjar_epoch","sardines_epoch","meatballs_epoch","scam_epoch","sweetcorn_epoch","WhiskeyNoodle","ItemCoolerE"]],
	["A3EAI_MiscLoot1",["PaintCanClear","PaintCanBlk","PaintCanBlu","PaintCanBrn","PaintCanGrn","PaintCanOra","PaintCanPur","PaintCanRed","PaintCanTeal","PaintCanYel","ItemDocument","ItemMixOil","emptyjar_epoch","emptyjar_epoch","FoodBioMeat","ItemSodaOrangeSherbet","ItemSodaPurple","ItemSodaMocha","ItemSodaBurst","ItemSodaRbull","sardines_epoch","meatballs_epoch","scam_epoch","sweetcorn_epoch","Towelette","Towelette","Towelette","Towelette","Towelette","HeatPack","HeatPack","HeatPack","ColdPack","ColdPack","VehicleRepair","CircuitParts","ItemCoolerE","ItemScraps","ItemScraps"]],
	["A3EAI_MiscLoot2",["MortarBucket","MortarBucket","ItemCorrugated","CinderBlocks","jerrycan_epoch","jerrycan_epoch","VehicleRepair","VehicleRepair","CircuitParts"]],
	["A3EAI_tools0",[["ItemWatch",0.70],["ItemCompass",0.50],["ItemMap",0.40],["ItemGPS",0.05],["EpochRadio0",0.10]]],
	["A3EAI_tools1",[["ItemWatch",0.80],["ItemCompass",0.75],["ItemMap",0.70],["ItemGPS",0.15],["EpochRadio0",0.20]]],
	["A3EAI_gadgets0",[["binocular",0.40],["NVG_EPOCH",0.10]]],
	["A3EAI_gadgets1",[["binocular",0.70],["NVG_EPOCH",0.25]]]
];

//Check value ranges
if !(A3EAI_minAI_capitalCity in [0,1,2,3,4,5]) then {diag_log format ["[A3EAI] Error found in variable A3EAI_minAI_capitalCity, resetting to default value."]; A3EAI_minAI_capitalCity = 2};
if !(A3EAI_addAI_capitalCity in [0,1,2,3,4,5]) then {diag_log format ["[A3EAI] Error found in variable A3EAI_addAI_capitalCity, resetting to default value."]; A3EAI_addAI_capitalCity = 1};
if !(A3EAI_unitLevel_capitalCity in [0,1,2,3]) then {diag_log format ["[A3EAI] Error found in variable A3EAI_unitLevel_capitalCity, resetting to default value."]; A3EAI_unitLevel_capitalCity = 1};
if !(A3EAI_minAI_city in [0,1,2,3,4,5]) then {diag_log format ["[A3EAI] Error found in variable A3EAI_minAI_city, resetting to default value."]; A3EAI_minAI_city = 1};
if !(A3EAI_addAI_city in [0,1,2,3,4,5]) then {diag_log format ["[A3EAI] Error found in variable A3EAI_addAI_city, resetting to default value."]; A3EAI_addAI_city = 2};
if !(A3EAI_unitLevel_city in [0,1,2,3]) then {diag_log format ["[A3EAI] Error found in variable A3EAI_unitLevel_city, resetting to default value."]; A3EAI_unitLevel_city = 1};
if !(A3EAI_minAI_village in [0,1,2,3,4,5]) then {diag_log format ["[A3EAI] Error found in variable A3EAI_minAI_village, resetting to default value."]; A3EAI_minAI_village = 1};
if !(A3EAI_addAI_village in [0,1,2,3,4,5]) then {diag_log format ["[A3EAI] Error found in variable A3EAI_addAI_village, resetting to default value."]; A3EAI_addAI_village = 1};
if !(A3EAI_unitLevel_village in [0,1,2,3]) then {diag_log format ["[A3EAI] Error found in variable A3EAI_unitLevel_village, resetting to default value."]; A3EAI_unitLevel_village = 0};
if !(A3EAI_minAI_remoteArea in [0,1,2,3,4,5]) then {diag_log format ["[A3EAI] Error found in variable A3EAI_minAI_remoteArea, resetting to default value."]; A3EAI_minAI_remoteArea = 1};
if !(A3EAI_addAI_remoteArea in [0,1,2,3,4,5]) then {diag_log format ["[A3EAI] Error found in variable A3EAI_unitLevel_remoteArea, resetting to default value."]; A3EAI_addAI_remoteArea = 1};
if !(A3EAI_unitLevel_remoteArea in [0,1,2,3]) then {diag_log format ["[A3EAI] Error found in variable A3EAI_unitLevel_remoteArea, resetting to default value."]; A3EAI_unitLevel_remoteArea = 2};
if !((count A3EAI_promoteChances) isEqualTo 3) then {diag_log format ["[A3EAI] Error found in variable A3EAI_promoteChances, resetting to default value."]; A3EAI_promoteChances = [0.20,0.10,0.10]};
if !((count A3EAI_levelChancesAir) isEqualTo 4) then {diag_log format ["[A3EAI] Error found in variable A3EAI_levelChancesAir, resetting to default value."]; A3EAI_levelChancesAir = [0.00,0.50,0.35,0.15]};
if !((count A3EAI_levelChancesLand) isEqualTo 4) then {diag_log format ["[A3EAI] Error found in variable A3EAI_levelChancesLand, resetting to default value."]; A3EAI_levelChancesAir = [0.00,0.50,0.35,0.15]};
if !((count A3EAI_useWeaponChance0) isEqualTo 4) then {diag_log format ["[A3EAI] Error found in variable A3EAI_useWeaponChance0, resetting to default value."]; A3EAI_useWeaponChance0 = [0.20,0.80,0.00,0.00]};
if !((count A3EAI_useWeaponChance1) isEqualTo 4) then {diag_log format ["[A3EAI] Error found in variable A3EAI_useWeaponChance1, resetting to default value."]; A3EAI_useWeaponChance1 = [0.00,0.90,0.05,0.05]};
if !((count A3EAI_useWeaponChance2) isEqualTo 4) then {diag_log format ["[A3EAI] Error found in variable A3EAI_useWeaponChance2, resetting to default value."]; A3EAI_useWeaponChance2 = [0.00,0.80,0.10,0.10]};
if !((count A3EAI_useWeaponChance3) isEqualTo 4) then {diag_log format ["[A3EAI] Error found in variable A3EAI_useWeaponChance3, resetting to default value."]; A3EAI_useWeaponChance3 = [0.00,0.70,0.15,0.15]};

diag_log format ["[A3EAI] Verified all A3EAI settings in %1 seconds.",(diag_tickTime - _startTime)];
