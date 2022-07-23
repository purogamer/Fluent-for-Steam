; #FUNCTION# ====================================================================================================================
; Name ..........: Globals Team AiO MOD++
; Description ...: This file Includes several files in the current script and all Declared variables, constant, or create an array.
; Syntax ........: #include , Global
; Parameters ....: None
; Return values .: None
; Author ........: Team AiO MOD++ (2021)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#Tidy_Off
;[0]=ImageName 	 					[1]=Challenge Name		[3]=THlevel 	[4]=Priority/TroopsNeeded 	[5]=Extra/to use in future
Global $g_eChallengesTotal = 6
Global $g_hCGLootChallenges[$g_eChallengesTotal]
Global $g_aCGLootChallenges[$g_eChallengesTotal][6] = [ _
			["GoldChallenge", 			"Gold Challenge", 				 7,  5, 8, "Loot certain amount of Gold from a single Multiplayer Battle"								], _ ;|8h 	|50
			["ElixirChallenge", 		"Elixir Challenge", 			 7,  5, 8, "Loot certain amount of Elixir from a single Multiplayer Battle"								], _ ;|8h 	|50
			["DarkEChallenge", 			"Dark Elixir Challenge", 		 8,  5, 8, "Loot certain amount of Dark elixir from a single Multiplayer Battle"						], _ ;|8h 	|50
			["GoldGrab", 				"Gold Grab", 					 6,  1, 1, "Loot a total amount of Gold (accumulated from many attacks) from Multiplayer Battle"		], _ ;|1h-2d 	|100-600
			["ElixirEmbezz", 			"Elixir Embezzlement", 			 6,  1, 1, "Loot a total amount of Elixir (accumulated from many attacks) from Multiplayer Battle"		], _ ;|1h-2d 	|100-600
			["DarkEHeist", 				"Dark Elixir Heist", 			 9,  3, 1, "Loot a total amount of Dark Elixir (accumulated from many attacks) from Multiplayer Battle"	]]   ;|1h-2d 	|100-600


$g_eChallengesTotal = 14
Global $g_hCGAirTroopChallenges[$g_eChallengesTotal]
Global $g_aCGAirTroopChallenges[$g_eChallengesTotal][6] = [ _
			["Ball", 					"Balloon", 						 4, 1, 1, "Earn 1-5 Stars (accumulated from many attacks) from Multiplayer Battles using certain count of Balloons"		], _ ;|3h-8h	|40-100
			["Heal", 					"Healer", 						 4, 1, 1, "Earn 1-5 Stars (accumulated from many attacks) from Multiplayer Battles using a Healer"							], _ ;|3h-8h	|40-100
			["Drag", 					"Dragon", 						 7, 1, 1, "Earn 1-5 Stars (accumulated from many attacks) from Multiplayer Battles using certain count of Dragons"			], _ ;	|3h-8h	|40-100
			["BabyD", 					"Baby Dragon", 					 9, 1, 1, "Earn 1-5 Stars (accumulated from many attacks) from Multiplayer Battles using certain count of Baby Dragons"	], _ ;|3h-8h	|40-100
			["Edrag", 					"Electro Dragon", 				10, 1, 1, "Earn 1-5 Stars (accumulated from many attacks) from Multiplayer Battles using certain count of Electro Dragon"	], _ ;	|3h-8h	|40-300
			["RDrag", 					"Dragon Rider", 				10, 1, 1, "Earn 1-5 Stars (accumulated from many attacks) from Multiplayer Battles using certain count of Dragon Rider"	], _ ;	|3h-8h	|40-300
			["Mini", 					"Minion", 						 7, 1, 1, "Earn 1-5 Stars (accumulated from many attacks) from Multiplayer Battles using certain count of Minions"			], _ ;|3h-8h	|40-100
			["Lava", 					"Lavahound", 					 9, 1, 1, "Earn 1-5 Stars (accumulated from many attacks) from Multiplayer Battles using certain count of Lava Hounds"		], _ ;	|3h-8h	|40-100
			["RBall", 					"Rocket Balloon", 				12, 1, 1, "Earn 1-5 Stars (accumulated from many attacks) from Multiplayer Battles using certain count of Rocket Balloon"], _ ;
			["Smini", 					"Super Minion", 				12, 1, 1, "Earn 1-5 Stars (accumulated from many attacks) from Multiplayer Battles using certain count of Super Minion"], _ ;
			["InfernoD",				"Inferno Dragon", 				12, 1, 1, "Earn 1-5 Stars (accumulated from many attacks) from Multiplayer Battles using certain count of Inferno Dragon"], _ ;
			["IceH", 					"Ice Hound", 					13, 1, 1, "Earn 1-5 Stars (accumulated from many attacks) from Multiplayer Battles using certain count of Ice Hound"], _ ;
			["BattleB", 				"Battle Blimp", 				10, 1, 1, "Earn 1-5 Stars (accumulated from many attacks) from Multiplayer Battles using a of Battle Blimp"], _ ;
			["StoneS",	 				"Stone Slammer", 				10, 1, 1, "Earn 1-5 Stars (accumulated from many attacks) from Multiplayer Battles using a of Stone Slammer"]]   ;

$g_eChallengesTotal = 27
Global $g_hCGGroundTroopChallenges[$g_eChallengesTotal]
Global $g_aCGGroundTroopChallenges[$g_eChallengesTotal][6] = [ _
			["Arch", 					"Archer", 						  6, 1, 1, "Earn 1-5 Stars from Multiplayer Battles using certain count of Barbarians"		], _ ;	|3h-8h	|40-100
			["Barb", 					"Barbarian", 					  6, 1, 1, "Earn 1-5 Stars from Multiplayer Battles using certain count of Archers"			], _ ;|3h-8h	|40-100
			["Giant", 					"Giant", 						  6, 1, 1, "Earn 1-5 Stars from Multiplayer Battles using certain count of Giants"			], _ ;	|3h-8h	|40-100
			["Gobl", 					"Goblin", 						  2, 1, 1, "Earn 1-5 Stars from Multiplayer Battles using certain count of Goblins"			], _ ;|3h-8h	|40-100
			["Wall", 					"WallBreaker", 					  6, 1, 1, "Earn 1-5 Stars from Multiplayer Battles using certain count of Wall Breakers"	], _ ;|3h-8h	|40-100
			["Wiza", 					"Wizard", 						  5, 1, 1, "Earn 1-5 Stars from Multiplayer Battles using certain count of Wizards"			], _ ;|3h-8h	|40-100
			["Hogs", 					"HogRider", 					  7, 1, 1, "Earn 1-5 Stars from Multiplayer Battles using certain count of Hog Riders"		], _ ;	|3h-8h	|40-100
			["Mine", 					"Miner", 						 10, 1, 1, "Earn 1-5 Stars from Multiplayer Battles using certain count of Miners"			], _ ;	|3h-8h	|40-100
			["Pekk", 					"Pekka", 						  8, 1, 1, "Earn 1-5 Stars from Multiplayer Battles using certain count of Pekka"       	], _ ;
			["Witc", 					"Witch", 						  9, 1, 1, "Earn 1-5 Stars from Multiplayer Battles using certain count of Witches"			], _ ;	|3h-8h	|40-100
			["Bowl", 					"Bowler", 						 10, 1, 1, "Earn 1-5 Stars from Multiplayer Battles using certain count of Bowlers"			], _ ;	|3h-8h	|40-100
			["Valk", 					"Valkyrie", 					  8, 1, 1, "Earn 1-5 Stars from Multiplayer Battles using certain count of Valkyries"		], _ ;|3h-8h	|40-100
			["Gole", 					"Golem", 						  8, 1, 1, "Earn 1-5 Stars from Multiplayer Battles using certain count of Golems"			], _ ;	|3h-8h	|40-100
			["Yeti", 					"Yeti", 						 12, 1, 1, "Earn 1-5 Stars from Multiplayer Battles using certain count of Yeti" 			], _ ;
			["IceG", 					"IceGolem", 					 11, 1, 1, "Earn 1-5 Stars from Multiplayer Battles using certain count of Ice Golem" 		], _ ;
			["Hunt", 					"HeadHunters", 					 12, 1, 1, "Earn 1-5 Stars from Multiplayer Battles using certain count of Head Hunters" 	], _ ;
			["Sbarb", 					"SuperBarbarian", 				 11, 1, 1, "Earn 1-5 Stars from Multiplayer Battles using certain count of Super Barbarian" ], _ ;
			["Sarch", 					"SuperArcher", 					 11, 1, 1, "Earn 1-5 Stars from Multiplayer Battles using certain count of Super Archer" 	], _ ;
			["Sgiant", 					"SuperGiant", 					 12, 1, 1, "Earn 1-5 Stars from Multiplayer Battles using certain count of Super Giant" 	], _ ;
			["Sgobl", 					"SneakyGoblin", 				 11, 1, 1, "Earn 1-5 Stars from Multiplayer Battles using certain count of Super Goblin" 	], _ ;
			["Swall", 					"SuperWallBreaker", 			 11, 1, 1, "Earn 1-5 Stars from Multiplayer Battles using certain count of Super Wall Breaker" ], _ ;
			["Swiza", 					"SuperWizard",					 12, 1, 1, "Earn 1-5 Stars from Multiplayer Battles using certain count of Super Wizard" 	], _ ;
			["Svalk", 					"SuperValkyrie",				 12, 1, 1, "Earn 1-5 Stars from Multiplayer Battles using certain count of Super Valkyrie"	], _ ;
			["Switc", 					"SuperWitch", 					 12, 1, 1, "Earn 1-5 Stars from Multiplayer Battles using certain count of Super Witch" 	], _ ;
			["WallW", 					"Wall Wrecker", 				 10, 1, 1, "Earn 1-5 Stars from Multiplayer Battles using a Wall Wrecker" 					], _ ;
			["SiegeB", 					"Siege Barrack", 				 10, 1, 1, "Earn 1-5 Stars from Multiplayer Battles using a Siege Barracks" 				], _ ;
			["LogL", 					"Log Launcher", 				 10, 1, 1, "Earn 1-5 Stars from Multiplayer Battles using a Log Launcher"					]]   ;

$g_eChallengesTotal = 21
Global $g_hCGBattleChallenges[$g_eChallengesTotal]
Global $g_aCGBattleChallenges[$g_eChallengesTotal][6] = [ _
			["Start", 					"Star Collector", 				 6,  1, 1, "Collect a total amount of Stars (accumulated from many attacks) from Multiplayer Battle"					], _ ;	|8h-2d	|100-600
			["Destruction", 			"Lord of Destruction", 			 6,  1, 1, "Collect a total amount of percentage Destruction % (accumulated from many attacks) from Multiplayer Battle"	], _ ;	|8h-2d	|100-600
			["PileOfVictores", 			"Pile Of Victories", 			 6,  1, 2, "Win 1-5 Multiplayer Battles"																				], _ ;	|8h-2d	|100-600
			["StarThree", 				"Hunt for Three Stars", 		10,  5, 8, "Score a Perfect 3 Stars in Multiplayer Battles"																], _ ;	|8h 	|200
			["WinningStreak", 			"Winning Streak", 				 9,  5, 8, "Win 1-5 Multiplayer Battles in a row"																		], _ ;|8h-2d	|100-600
			["SlayingTitans", 			"Slaying The Titans", 			11,  2, 1, "Win a Multiplayer Battles In Titan League"																	], _ ;|5h		|300
			["NoHero", 					"No Heroics Allowed", 			 3,  5, 5, "Win a stars without using Heroes"																			], _ ;	|8h		|100
			["NoMagic", 				"No-Magic Zone", 				 6,  5, 5, "Win a stars without using Spells"																			], _ ;	|8h		|100
			["Scrappy6s", 				"Scrappy 6s", 					 6,  1, 4, "Gain 3 Stars Against Town Hall level 6"																		], _ ;	|8h		|200
			["Super7s", 				"Super 7s", 					 7,  1, 4, "Gain 3 Stars Against Town Hall level 7"																		], _ ;	|8h		|200
			["Exciting8s", 				"Exciting 8s", 					 8,  1, 4, "Gain 3 Stars Against Town Hall level 8"																		], _ ;	|8h		|200
			["Noble9s", 				"Noble 9s", 					 9,  1, 4, "Gain 3 Stars Against Town Hall level 9"																		], _ ;	|8h		|200
			["Terrific10s", 			"Terrific 10s", 				10,  1, 4, "Gain 3 Stars Against Town Hall level 10"																	], _ ;	|8h		|200
			["Exotic11s", 			    "Exotic 11s", 					11,  1, 4, "Gain 3 Stars Against Town Hall level 11"																	], _ ;	|8h		|200
			["Triumphant12s", 			"Triumphant 12s", 				12,  1, 4, "Gain 3 Stars Against Town Hall level 12"																	], _ ;	|8h		|200
			["AttackUp", 				"Attack Up", 					 6,  1, 8, "Gain 3 Stars Against Town Hall a level higher"																], _ ;|8h		|200
			["ClashOfLegends", 			"Clash of Legends", 			11,  2, 1, "Win a Multiplayer Battles In Legend League"                                                             	], _ ;
			["GainStarsFromClanWars",	"3 Stars From Clan War",		 6,  0, 99, "Gain 3 Stars on Clan War"                                                             						], _ ;
			["SpeedyStars", 			"3 Stars in 60 seconds",		 6,  2, 2, "Gain 3 Stars (accumulated from many attacks) from Multiplayer Battle but only stars gained below a minute counted"], _ ;
			["SuperCharge", 			"Deploy SuperTroops",			 6,  2, 0, "Deploy certain housing space of Any Super Troops"                                                           ], _ ;
			["Tremendous13s", 			"Tremendous 13s", 				13,  1, 4, "Gain 3 Stars Against Town Hall level 13"                                                             		]]   ;

$g_eChallengesTotal = 34
Global $g_hCGDestructionChallenges[$g_eChallengesTotal]
Global $g_aCGDestructionChallenges[$g_eChallengesTotal][6] = [ _
			["Cannon", 					"Cannon", 				 6,  1, 1,"Destroy 5-25 Cannons in Multiplayer Battles"					], _ ;	|1h-8h	|75-350
			["ArcherT", 				"Archer Tower", 		 6,  1, 1,"Destroy 5-20 Archer Towers in Multiplayer Battles"			], _ ;	|1h-8h	|75-350
			["BuilderHut", 				"Builder Hut", 		     6,  1, 1,"Destroy 4-12 BuilderHut in Multiplayer Battles"				], _ ;	|1h-8h	|40-350
			["Mortar", 					"Mortar", 				 6,  1, 2,"Destroy 4-12 Mortars in Multiplayer Battles"					], _ ;	|1h-8h	|40-350
			["AirD", 					"Air Defenses", 		 7,  2, 3,"Destroy 3-12 Air Defenses in Multiplayer Battles"			], _ ;|1h-8h	|40-350
			["WizardT", 				"Wizard Tower", 		 6,  1, 3,"Destroy 4-12 Wizard Towers in Multiplayer Battles"			], _ ;	|1h-8h	|40-350
			["AirSweepers", 			"Air Sweepers", 		 8,  4, 3,"Destroy 2-6 Air Sweepers in Multiplayer Battles"				], _ ;	|1h-8h	|40-350
			["Tesla", 					"Tesla Towers", 		 7,  5, 3,"Destroy 4-12 Hidden Teslas in Multiplayer Battles"			], _ ;	|1h-8h	|50-350
			["BombT", 					"Bomb Towers", 			 8,  2, 3,"Destroy 2 Bomb Towers in Multiplayer Battles"				], _ ;|1h-8h	|50-350
			["Xbow", 					"X-Bows", 				 9,  5, 4,"Destroy 3-12 X-Bows in Multiplayer Battles"					], _ ;	|1h-8h	|50-350
			["Inferno", 				"Inferno Towers", 		11,  5, 4,"Destroy 2 Inferno Towers in Multiplayer Battles"				], _ ;	|1h-2d	|50-600
			["EagleA", 					"Eagle Artillery", 	    11,  5, 5,"Destroy 1-7 Eagle Artillery in Multiplayer Battles"			], _ ;	|1h-2d	|50-600
			["ClanC", 					"Clan Castle", 			 5,  2, 3,"Destroy 1-4 Clan Castle in Multiplayer Battles"				], _ ;	|1h-8h	|40-350
			["GoldSRaid", 				"Gold Storage", 		 6,  2, 3,"Destroy 3-15 Gold Storages in Multiplayer Battles"			], _ ;	|1h-8h	|40-350
			["ElixirSRaid", 			"Elixir Storage", 		 6,  1, 3,"Destroy 3-15 Elixir Storages in Multiplayer Battles"			], _ ;	|1h-8h	|40-350
			["DarkEStorageRaid", 		"Dark Elixir Storage", 	 8,  3, 3,"Destroy 1-4 Dark Elixir Storage in Multiplayer Battles"		], _ ;	|1h-8h	|40-350
			["GoldM", 					"Gold Mine", 			 6,  1, 1,"Destroy 6-20 Gold Mines in Multiplayer Battles"				], _ ;	|1h-8h	|40-350
			["ElixirPump", 				"Elixir Pump", 		 	 6,  1, 1,"Destroy 6-20 Elixir Collectors in Multiplayer Battles"		], _ ;	|1h-8h	|40-350
			["DarkEPlumbers", 			"Dark Elixir Drill", 	 6,  1, 1,"Destroy 2-8 Dark Elixir Drills in Multiplayer Battles"		], _ ;	|1h-8h	|40-350
			["Laboratory", 				"Laboratory", 			 6,  1, 1,"Destroy 2-6 Laboratories in Multiplayer Battles"				], _ ;	|1h-8h	|40-200
			["SFacto", 					"Spell Factory", 		 6,  1, 1,"Destroy 2-6 Spell Factories in Multiplayer Battles"			], _ ;	|1h-8h	|40-200
			["DESpell", 				"Dark Spell Factory", 	 8,  1, 1,"Destroy 2-6 Dark Spell Factories in Multiplayer Battles"		], _ ;	|1h-8h	|40-200
			["WallWhacker", 			"Wall Whacker", 		 10, 1, 8,"Destroy 50-250 Walls in Multiplayer Battles"					], _ ;	|
			["BBreakdown",	 			"Building Breakdown", 	 6,  1, 1,"Destroy 50-250 Buildings in Multiplayer Battles"				], _ ;		|
			["BKaltar", 				"Barbarian King Altars", 9,  4, 4,"Destroy 2-5 Barbarian King Altars in Multiplayer Battles"	], _ ;|1h-8h	|50-150
			["AQaltar", 				"Archer Queen Altars", 	10,  5, 4,"Destroy 2-5 Archer Queen Altars in Multiplayer Battles"		], _ ;	|1h-8h	|50-150
			["GWaltar", 				"Grand Warden Altars", 	11,  5, 4,"Destroy 2-5 Grand Warden Altars in Multiplayer Battles"		], _ ;	|1h-8h	|50-150
			["HeroLevelHunter", 		"Hero Level Hunter", 	 9,  5, 5,"Knockout 125 Level Heroes on Multiplayer Battles"			], _ ;|8h		|100
			["KingLevelHunter", 		"King Level Hunter", 	 9,  5, 5,"Knockout 50 Level King on Multiplayer Battles"				], _ ;	|8h		|100
			["QueenLevelHunt", 			"Queen Level Hunter", 	10,  5, 5,"Knockout 50 Level Queen on Multiplayer Battles"				], _ ;	|8h		|100
			["WardenLevelHunter", 		"Warden Level Hunter", 	11,  5, 5,"Knockout 20 Level Warden on Multiplayer Battles"				], _ ;	|8h		|100
			["ArmyCamp", 				"Destroy ArmyCamp", 	6,   5, 1,"Destroy 3-16 Army Camp in Multiplayer Battles"				], _ ;	|8h		|100
			["ScatterShotSabotage",		"ScatterShot",			13,  5, 5,"Destroy 1-4 ScatterShot in Multiplayer Battles"				], _ ;
			["ChampionLevelHunt",		"Champion Level Hunter",13,  5, 5,"Knockout 20 Level Champion on Multiplayer Battles"			]]   ;


$g_eChallengesTotal = 3
Global $g_hCGMiscChallenges[$g_eChallengesTotal]
Global $g_aCGMiscChallenges[$g_eChallengesTotal][6] = [ _
			["Gard", 					"Gardening Exercise", 			 6,  6, 8, "Clear 5 obstacles from your Home Village or Builder Base"		], _ ; |8h	|50
			["DonateSpell", 			"Donate Spells", 				 9,  6, 8, "Donate a total of 3 spells"				], _ ; |8h	|50
			["DonateTroop", 			"Helping Hand", 				 6,  6, 8, "Donate a total of 45 housing space worth of troops"			]]   ; 	|8h	|50


$g_eChallengesTotal = 11
Global $g_hCGSpellChallenges[$g_eChallengesTotal]
Global $g_aCGSpellChallenges[$g_eChallengesTotal][6] = [ _
			["LSpell", 					"Lightning", 					 6,  1, 1, "Use certain amount of Lightning Spell to Win a Stars in Multiplayer Battles"	], _ ;
			["HSpell", 					"Heal",							 6,  2, 1, "Use certain amount of Heal Spell to Win a Stars in Multiplayer Battles"			], _ ; updated 25/01/2021
			["RSpell", 					"Rage", 					 	 6,  2, 1, "Use certain amount of Rage Spell to Win a Stars in Multiplayer Battles"			], _ ;
			["JSpell", 					"Jump", 					 	 6,  2, 1, "Use certain amount of Jump Spell to Win a Stars in Multiplayer Battles"			], _ ;
			["FSpell", 					"Freeze", 					 	 9,  1, 1, "Use certain amount of Freeze Spell to Win a Stars in Multiplayer Battles"		], _ ;
			["CSpell", 					"Clone", 					 	11,  3, 1, "Use certain amount of Clone Spell to Win a Stars in Multiplayer Battles"		], _ ;
			["PSpell", 					"Poison", 					 	 6,  1, 1, "Use certain amount of Poison Spell to Win a Stars in Multiplayer Battles"		], _ ;
			["ESpell", 					"Earthquake", 					 6,  1, 1, "Use certain amount of Earthquake Spell to Win a Stars in Multiplayer Battles"	], _ ;
			["HaSpell", 				"Haste",	 					 6,  1, 1, "Use certain amount of Haste Spell to Win a Stars in Multiplayer Battles"		], _ ; updated 25/01/2021
			["SkSpell",					"Skeleton", 					11,  1, 1, "Use certain amount of Skeleton Spell to Win a Stars in Multiplayer Battles"		], _ ;
			["BtSpell",					"Bat", 					 		10,  1, 1, "Use certain amount of Bat Spell to Win a Stars in Multiplayer Battles"			]]   ;

$g_eChallengesTotal = 4
Global $g_hCGBBBattleChallenges[$g_eChallengesTotal]
Global $g_aCGBBBattleChallenges[$g_eChallengesTotal][6] = [ _
            ["StarM",					"BB Star Master",				6,  1, 1, "Collect certain amount of stars in Versus Battles"						], _ ; Earn 6 - 24 stars on the BB
            ["Victories",				"BB Victories",					6,  5, 3, "Get certain count of Victories in Versus Battles"						], _ ; Earn 3 - 6 victories on the BB
			["StarTimed",				"BB Star Timed",				6,  2, 2, "Earn stars in Versus Battles, but only stars gained below a minute counted"	], _
            ["Destruction",				"BB Destruction",				6,  1, 1, "Earn certain amount of destruction percentage (%) in Versus Battles"			]] ; Earn 225% - 900% on BB attacks

$g_eChallengesTotal = 18
Global $g_hCGBBDestructionChallenges[$g_eChallengesTotal]
Global $g_aCGBBDestructionChallenges[$g_eChallengesTotal][6] = [ _
            ["Airbomb",					"Air Bomb",                 	6,  1, 4, "Destroy certain number of Air Bomb in Versus Battles"		], _
			["BuildingDes",             "BB Building",					6,  1, 1, "Destroy certain number of Building in Versus Battles"		], _
			["BuilderHall",             "BuilderHall",					6,  1, 2, "Destroy certain number of Builder Hall in Versus Battles"	], _
            ["Cannon",                 	"BB Cannon",                  	6,  1, 1, "Destroy certain number of Cannon in Versus Battles"			], _
			["ClockTower",             	"Clock Tower",                 	6,  1, 2, "Destroy certain number of Clock Tower in Versus Battles"		], _
            ["DoubleCannon",         	"Double Cannon",             	6,  1, 1, "Destroy certain number of Double Cannon in Versus Battles"	], _
			["FireCrackers",         	"Fire Crackers",              	6,  1, 3, "Destroy certain number of Fire Crackers in Versus Battles"	], _
			["GemMine",                 "Gem Mine",                  	6,  1, 2, "Destroy certain number of Gem Mine in Versus Battles"		], _
			["GiantCannon",             "Giant Cannon",               	6,  1, 4, "Destroy certain number of Giant Cannon in Versus Battles"	], _
			["GuardPost",               "Guard Post",                 	6,  1, 4, "Destroy certain number of Guard Post in Versus Battles"		], _
			["MegaTesla",               "Mega Tesla",               	6,  1, 5, "Destroy certain number of Mega Tesla in Versus Battles"		], _
			["MultiMortar",             "Multi Mortar",               	6,  1, 4, "Destroy certain number of Multi Mortar in Versus Battles"	], _
			["Roaster",                 "Roaster",			            6,  1, 4, "Destroy certain number of Roaster in Versus Battles"			], _
			["StarLab",                 "Star Laboratory",              6,  1, 1, "Destroy certain number of Star Laboratory in Versus Battles"	], _
			["WallDes",             	"Wall Whacker",              	6,  1, 2, "Destroy certain number of Wall in Versus Battles"			], _
			["Crusher",             	"Crusher",                 		6,  1, 3, "Destroy certain number of Crusher in Versus Battles"			], _
			["ArcherTower",             "Archer Tower",            		6,  1, 1, "Destroy certain number of Archer Tower in Versus Battles"	], _
			["LavaLauncher",            "Lava Launcher",           		6,  1, 5, "Destroy certain number of Lava Launcher in Versus Battles"	]]

$g_eChallengesTotal = 11
Global $g_hCGBBTroopChallenges[$g_eChallengesTotal]
Global $g_aCGBBTroopChallenges[$g_eChallengesTotal][6] = [ _
            ["RBarb",					"Raged Barbarian",              6,  1, 1, "Win 1-5 Attacks using Raged Barbarians in Versus Battle"	], _ ;BB Troops
            ["SArch",                 	"Sneaky Archer",                6,  1, 1, "Win 1-5 Attacks using Sneaky Archer in Versus Battle"	], _
            ["BGiant",         			"Boxer Giant",             		6,  1, 1, "Win 1-5 Attacks using Boxer Giant in Versus Battle"		], _
			["BMini",         			"Beta Minion",              	6,  1, 1, "Win 1-5 Attacks using Beta Minion in Versus Battle"		], _
			["Bomber",                 	"Bomber",                  		6,  1, 1, "Win 1-5 Attacks using Bomber in Versus Battle"			], _
			["BabyD",               	"Baby Dragon",                 	6,  1, 1, "Win 1-5 Attacks using Baby Dragon in Versus Battle"		], _
			["CannCart",             	"Cannon Cart",               	6,  1, 1, "Win 1-5 Attacks using Cannon Cart in Versus Battle"		], _
			["NWitch",                 	"Night Witch",                 	6,  1, 1, "Win 1-5 Attacks using Night Witch in Versus Battle"		], _
			["DShip",                 	"Drop Ship",                  	6,  1, 1, "Win 1-5 Attacks using Drop Ship in Versus Battle"		], _
			["SPekka",                 	"Super Pekka",                  6,  1, 1, "Win 1-5 Attacks using Super Pekka in Versus Battle"		], _
			["HGlider",                 "Hog Glider",                  	6,  1, 1, "Win 1-5 Attacks using Hog Glider in Versus Battle"		]]
			
Global $g_aChallengesClanGamesStrings = ["Loot Challenges", _ 
										"Air Troop Challenges", _ 
										"Ground Troop Challenges", _ 
										"Battle Challenges", _ 
										"Destruction Challenges", _ 
										"Misc Challenges", _ 
										"Spell Challenges", _
										"BB Battle Challenges", _ 
										"BB Destruction Challenges", _ 
										"BB Troop Challenges"]
#Tidy_Off

; Custom 
Global $DiamondMiddleX, $DiamondMiddleY
 
#Region - Boost - Team AiO MOD++

; One Gem Boost - Team AiO MOD++
Global $g_bChkOneGemBoostBarracks = False, $g_bChkOneGemBoostSpells = False, $g_bChkOneGemBoostHeroes = False, $g_bChkOneGemBoostWorkshop = False, $g_bOneGemEventEnded = False
Global $g_hChkOneGemBoostBarracks = 0, $g_hChkOneGemBoostSpells = 0, $g_hChkOneGemBoostHeroes = 0, $g_hChkOneGemBoostWorkshop = 0

; Custom boost - Team AIO Mod++ 
Global Const $g_sConstBoostEverything = 18000 ; 18000 const = 5 hours quality check (in seconds).
Global $g_sBoostEverythingTime = "2022/01/31 00:00:00" ; "0001/01/01 00:00:00"

; Schedule boost - Team AIO Mod++ 
Global $g_hTxtminBoostGold = 0, $g_hTxtminBoostElixir = 0, $g_hTxtminBoostDark = 0
Global $g_iMinBoostGold = 100000, $g_iMinBoostElixir = 100000, $g_iMinBoostDark = 10000

Global $g_iSwitchBoostSchedule[3]
Global $g_hCmbSwitchBoostSchedule[3]
#EndRegion - Boost - Team AiO MOD++

#Region - AIO Updater - Team AiO MOD++
Global $g_bCheckVersionAIO = True, $g_hChkForAIOUpdates = 0
#EndRegion - AIO Updater - Team AiO MOD++

#Region - Icn - Team AiO MOD++
Global Const $g_sLibModIconPath = $g_sLibPath & "\ModLibs\AIOMod.dll" ; Mod icon library - Team AiO MOD++
; enumerated Icons 1-based index to IconLibMod
Global Enum $eIcnModKingGray = 1, $eIcnModKingBlue, $eIcnModKingGreen, $eIcnModKingRed, $eIcnModQueenGray, $eIcnModQueenBlue, $eIcnModQueenGreen, $eIcnModQueenRed, _
		$eIcnModWardenGray, $eIcnModWardenBlue, $eIcnModWardenGreen, $eIcnModWardenRed, $eIcnModLabGray, $eIcnModLabGreen, $eIcnModLabRed, _
		$eIcnModArrowLeft, $eIcnModArrowRight, $eIcnModTrainingP, $eIcnModResourceP, $eIcnModHeroP, $eIcnModClockTowerP, $eIcnModBuilderP, $eIcnModPowerP, _
		$eIcnModChat, $eIcnModRepeat, $eIcnModClan, $eIcnModTarget, $eIcnModSettings, $eIcnModBKingSX, $eIcnModAQueenSX, $eIcnModGWardenSX, $eIcnModDebug, $eIcnModClanHop, $eIcnModPrecise, _
		$eIcnModAccountsS, $eIcnModProfilesS, $eIcnModFarmingS, $eIcnMiscMod, $eIcnSuperXP, $eIcnChatActions, $eIcnHumanization, $eIcnAIOMod, $eIcnDebugMod, _
		$eIcnLabP, $eIcnShop, $eIcnGoldP, $eIcnElixirP, $eIcnDarkP, $eIcnGFTO, $eIcnMisc, $eIcnPrewar

Global Const $g_sLibBBIconPath = $g_sLibPath & "\ModLibs\BuilderBase.dll" ; icon library
Global Enum $eIcnBB = 1 , $eIcnLabBB, $eIcnBBElixir, $eIcnBBGold, $eIcnBBTrophies, $eIcnMachine, $eIcnBBWallInfo, $eIcnBBWallL1, $eIcnBBWallL2, $eIcnBBWallL3, $eIcnBBWallL4, $eIcnBBWallL5, _
		$eIcnBBWallL6, $eIcnBBWallL7, $eIcnBBWallL8, $eIcnBBWallL9, $eIcnVersus
#EndRegion - Icn - Team AIO Mod++

#Region - Multi Finger - Team AIO Mod++
Global Enum $directionLeft, $directionRight
Global Enum $sideBottomRight, $sideTopLeft, $sideBottomLeft, $sideTopRight
Global Enum $mfRandom, $mfFFStandard, $mfFFSpiralLeft, $mfFFSpiralRight, $mf8FBlossom, $mf8FImplosion, $mf8FPinWheelLeft, $mf8FPinWheelRight

Global $g_iMultiFingerStyle = 1
#EndRegion - Multi Finger - Team AIO Mod++

#Region - BuyGuard - Team AIO Mod++
Global $g_bChkColorfulAttackLog = 0, $g_bChkBuyGuard = False
Global $g_hChkColorfulAttackLog = 0, $g_hChkBuyGuard = 0
#EndRegion - BuyGuard - Team AIO Mod++

#Region - Custom PrepareSearch - Team AIO Mod++
Global $g_bBadPrepareSearch = False
#EndRegion - Custom PrepareSearch - Team AIO Mod++

#Region - Dates - Team AIO Mod++
; Magic items check.
Global Const $g_sConstMaxMagicItemsSeconds = 172800 ; 172800 const = 2 days quality check.
Global $g_sDateAndTimeMagicItems = ""

; Hero war upgrade exception.
Global Const $g_sConstHeroWUESeconds = 172800 ; 172800 const = 2 days quality check.
Global $g_sDateAndTimeHeroWUE = "2021/09/02 00:00:00"

#cs
; King upgrade time.
Global Const $g_sConstMaxHeroTime = 864000 ; 864000 const = 10 days quality check.
Global $g_sDateAndTimeKing = "2021/09/02 00:00:00"

; Queen upgrade time.
Global $g_sDateAndTimeQueen = "2021/09/02 00:00:00"

; Warden upgrade time.
Global $g_sDateAndTimeWarden = "2021/09/02 00:00:00"

; Champion upgrade time.
Global $g_sDateAndTimeChampion = "2021/09/02 00:00:00"
#Ce

; Builder base play.
Global $g_sTimerStatusBB = "2022/03/29 20:09:00"
Global Const $g_sConstMaxBuilderBase = 86400 ; 86400 const = 1 day quality check (in seconds).
Global $g_sDateBuilderBase = "2021/09/02 00:00:00"
#EndRegion - Dates - Team AIO Mod++

#Region - No Upgrade In War - Team AIO Mod++
Global $g_hChkNoUpgradeInWar = True, $g_bNoUpgradeInWar
#EndRegion - No Upgrade In War - Team AIO Mod++

#Region - Legend trophy protection - Team AIO Mod++
Global $g_hChkProtectInLL, $g_hChkForceProtectLL, $g_bProtectInLL = True, $g_bForceProtectLL = False
#EndRegion - Legend trophy protection - Team AIO Mod++

#Region - Return Home by Time - Team AIO Mod++
Global $g_hChkResetByCloudTimeEnable = 0, $g_hTxtReturnTimer = 0, $g_bResetByCloudTimeEnable = False, $g_iTxtReturnTimer = 5
#EndRegion - Return Home by Time - Team AIO Mod++

#Region - Lab Priority System
Global $g_hChkLabUpgradeOrder = 0, $g_hBtnRemoveLabUpgradeOrder = 0, $g_hBtnSetLabUpgradeOrder = 0
Global $g_hChkSLabUpgradeOrder = 0, $g_hBtnRemoveSLabUpgradeOrder = 0, $g_hBtnSetSLabUpgradeOrder = 0
Global $g_bLabUpgradeOrderEnable = False
Global $g_bSLabUpgradeOrderEnable = False
Global $g_aCmbLabUpgradeOrder[10] = [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1]
Global $g_ahCmbLabUpgradeOrder[10] = [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1]
Global $g_aCmbSLabUpgradeOrder[6] = [-1, -1, -1, -1, -1, -1]
Global $g_ahCmbSLabUpgradeOrder[6] = [-1, -1, -1, -1, -1, -1]
#EndRegion - Lab Priority System

#Region - Discord - Team AIO Mod++
Global $g_bNotifyDSEnable, $g_sNotifyDSToken = "https://discord.com/api/webhooks/XXX/XXX"
Global $g_sNotifyOriginDS = ""

;Alerts
Global $g_bNotifyRemoteEnableDS = False, $g_bNotifyAlertMatchFoundDS = False, $g_bNotifyAlerLastRaidIMGDS = False, $g_bNotifyAlerLastRaidTXTDS = False, $g_bNotifyAlertCampFullDS = False, _
		$g_bNotifyAlertUpgradeWallsDS = False, $g_bNotifyAlertOutOfSyncDS = False, $g_bNotifyAlertTakeBreakDS = False, $g_bNotifyAlertBulderIdleDS = False, _
		$g_bNotifyAlertVillageReportDS = False, $g_bNotifyAlertLastAttackDS = False, $g_bNotifyAlertAnotherDeviceDS = False, $g_bNotifyAlertMaintenanceDS = False, _
		$g_bNotifyAlertBANDS = False, $g_bNotifyAlertBOTUpdateDS = False, $g_bNotifyAlertSmartWaitTimeDS = False, $g_bNotifyAlertLaboratoryIdleDS = False, $g_bNotifyAlertPetHouseIdleDS = False
;Schedule
Global $g_bNotifyScheduleHoursEnableDS = False, $g_bNotifyScheduleWeekDaysEnableDS = False
Global $g_abNotifyScheduleHoursDS[24] = [False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False]
Global $g_abNotifyScheduleWeekDaysDS[7] = [False, False, False, False, False, False, False]
#EndRegion - Discord - Team AIO Mod++

#Region - Setlog limit - Team AIO Mod++
Global $g_hChkBotLogLineLimit, $g_bChkBotLogLineLimit, _
$g_hTxtLogLineLimit, $g_iTxtLogLineLimit
#EndRegion - Setlog limit - Team AIO Mod++

#Region - Type once - Team AIO Mod++
Global $g_hChkRequestOneTimeEnable
Global $g_bRequestOneTimeEnable = False
Global $g_aRequestTroopsTextOT[0][2]
Global $g_aRequestTroopsTextOTR[0][2]
#EndRegion - Type once - Team AIO Mod++

#Region - Custom train - Team AIO Mod++
Global $g_hChkPreciseSpells = 0, $g_hChkForcePreBrewSpells = 0
Global $g_bForcePreBrewSpells = True, $g_bPreciseBrew = False

Global $g_bChkPreTrainTroopsPercent = True, $g_iInpPreTrainTroopsPercent = 95, $g_bForceDoubleTrain = False, $g_bTrainBeforeAttack = False
Global $g_hChkPreTrainTroopsPercent = 0, $g_hInpPreTrainTroopsPercent = 0, $g_hChkTrainBeforeAttack = 0, $g_hLblPreTrainTroopsPercent = 0

Global $g_iCustomArmysMainVillage[$eTroopCount][3]
Global $g_iCustomBrewMainVillage[$eSpellCount][3]
Global $g_iCustomSiegesMainVillage[$eSiegeMachineCount][3]
Global $g_hCmbTroopSetting = 0, $g_iCmbTroopSetting = 0
Global $g_bIgnoreIncorrectTroopCombo = False, $g_bIgnoreIncorrectSpellCombo = False, $g_iCmbFillIncorrectTroopCombo = 0, $g_iCmbFillIncorrectSpellCombo = 0

Global $g_hChkMMIgnoreIncorrectTroopCombo = 0, $g_hLblFillIncorrectTroopCombo = 0, $g_hCmbFillIncorrectTroopCombo = 0, $g_hChkMMIgnoreIncorrectSpellCombo = 0, $g_hLblFillIncorrectSpellCombo = 0, $g_hCmbFillIncorrectSpellCombo = 0

Global $g_sCmbFICTroops[2][3] = [ _ 
								["Barb",	"Barbarians",		1], _
								["Arch",	"Archers",			1]] 
Global $g_sCmbFICSpells[5][3] = [ _ 
								["LSpell",	"Lightning Spell",	1], _
								["BtSpell",	"Bat Spell",		1], _
								["HaSpell",	"Haste Spell",		1], _
								["FSpell",	"Freeze Spell",		1], _
								["ESpell",	"Earthquake Spell",	1]]

; Custom pets - Team AIO Mod++
Global $g_hChkPetHouseSelector = 0
Global $g_bPetHouseSelector = False

Global $g_hLblLassiHero = 0, $g_hLblElectroOwlHero = 0, $g_hLblMightyYakHero = 0, $g_hLblUnicornHero = 0
Global $g_hCmbLassiPet = 0, $g_hCmbElectroOwlPet = 0, $g_hCmbMightyYakPet = 0, $g_hCmbUnicornPet = 0
Global $g_iCmbLassiPet = 0, $g_iCmbElectroOwlPet = 0, $g_iCmbMightyYakPet = 0, $g_iCmbUnicornPet = 0

; Stick to Army page when time left
Global $g_iStickToTrainWindow = 1
Global $g_hLblStickToTrainWindow = 0, $g_hTxtStickToTrainWindow = 0

; Sieges
Global $g_iTotalSiegeValue = 0, $g_bPreciseSieges = 0, $g_bForcePreBuildSieges = 0
Global $g_hChkCustomBuildOrderEnable = 0
Global $g_hChkPreciseSieges = 0, $g_hChkForcePreBuildSieges = 0
Global $g_ahCmbSiegesOrder[$eSiegeMachineCount] = [0, 0, 0, 0, 0, 0]
Global $g_hTxtTotalCountSiege = 0, $g_hChkPreciseSieges = 0, $g_hChkForcePreBuildSieges = 0

Global $g_bCustomBuildOrderEnable = False, $g_aiCmbCustomBuildOrder[$eSiegeMachineCount] = [-1, -1, -1, -1, -1, -1]

Global $g_aiBuildOrder[$eSiegeMachineCount] = [ _
        $eWallW, $eBattleB, $eStoneS, $eSiegeB, $eLogL, $eFlameF]
		
Global Const $g_ahPicTrainArmySiege[$eSiegeMachineCount] = [ _ 
		$eIcnWallW, $eIcnBattleB, $eIcnStoneS, $eIcnSiegeB, $eIcnLogL, $eIcnFlameF]

; Pre train spells
Global $g_ahChkSpellsPre[$eSpellCount]
Global $g_aiChkSpellsPre[$eSpellCount]
#EndRegion - Custom train - Team AIO Mod++

; Advanced debugging.
Global $g_bExecuteCapture = False
Global $g_bNewModAvailable = False

; Custom remain - Team AIO Mod++
Global $g_bRemainTweak = True

; Skip ubi buildings - Team AIO Mod++
Global $g_bChkAvoidBuildingsLocate  = False, $g_hChkBuildingsLocate = 0

; Firewall - Team AIO Mod++
Global $g_hChkEnableFirewall = 0, $g_bChkEnableFirewall = False

; Stop for war - War Preparation Demen - Team AIO Mod++
Global $g_bStopForWar
Global $g_iStopTime, $g_iReturnTime
Global $g_bTrainWarTroop, $g_bUseQuickTrainWar, $g_aChkArmyWar[3], $g_aiWarCompTroops[$eTroopCount], $g_aiWarCompSpells[$eSpellCount]
Global $g_bRequestCCForWar,	$g_sTxtRequestCCForWar
Global $g_bClanWarLeague = True, $g_bClanWar = True

; Custom BB Army - Team AIO Mod++
Global $g_bDebugBBattack = False

; Drop trophy - Team AiO MOD++
Global $g_bChkNoDropIfShield = True, $g_bChkTrophyTroops = False, $g_bChkTrophyHeroesAndTroops = True
; GUI
Global $g_hChkNoDropIfShield, $g_hChkTrophyTroops, $g_hChkTrophyHeroesAndTroops

; Misc tab - Team AiO MOD++
Global $g_bUseSleep = False, $g_iIntSleep = 20, $g_bUseRandomSleep = False, $g_bNoAttackSleep = False, $g_bDisableColorLog = False, $g_bDelayLabel = False, $g_bChkSkipFirstAttack = False, $g_bEdgeObstacle = False
; GUI
Global $g_hDelayLabel, $g_hChkSkipFirstAttack, $g_hEdgeObstacle
;-------------------

; Max sides SF
Global $g_bMaxSidesSF = True, $g_iCmbMaxSidesSF = 1
; GUI
Global $g_hMaxSidesSF, $g_hCmbMaxSidesSF
;-------------------

; Attack extras - Team AiO MOD++
Global $g_bDeployCastleFirst[2] = [False, False]

Global $g_iDeployWave[3] = [5, 5, 5],  $g_iDeployDelay[3] = [5, 5, 5] ; $DB, $LB, $iCmbValue
Global $g_bChkEnableRandom[3] = [True, True, True]
; GUI
Global $g_hDeployCastleFirst[2] = [$LB, $DB]
Global $g_hDeployWave[3],  $g_hDeployDelay[3]
Global $g_hChkEnableRandom[3]

; SuperXP / GoblinXP - Team AiO MOD++
Global $g_bEnableSuperXP = False, $g_bFastSuperXP = False, $g_bSkipDragToEndSX = False, _
	$g_iActivateOptionSX = 1, $g_iGoblinMapOptSX = 2, $g_sGoblinMapOptSX = "The Arena", $g_iMaxXPtoGain = 500, _
	$g_bBKingSX = False, $g_bAQueenSX = False, $g_bGWardenSX = False, $g_bSkipZoomOutSX = False
Global $g_iStartXP = 0, $g_iCurrentXP = 0, $g_iGainedXP = 0, $g_iGainedHourXP = 0, $g_sRunTimeXP = 0
Global $g_bDebugSX = True
; [0] = Queen, [1] = Warden, [2] = Barbarian King
; [0][0] = X, [0][1] = Y, [0][2] = XRandomOffset, [0][3] = YRandomOffset
Global $g_aiDpGoblinPicnic[3][4] = [[310, 200, 5, 5], [340, 140, 5, 5], [290, 220, 5, 5]]
Global $g_aiDpTheArena[2][4] = [[429, 82, 0, 0], [430, 20, 5, 5]] ; Can't Farm With Barbarian King
Global $g_aiBdGoblinPicnic[3] = [0, "5000-7000", "6000-8000"] ; [0] = Archer Queen, [1] = Grand Warden, [2] = Barbarian King
Global $g_aiBdTheArena[2] = [0, "5000-7000"] ; [0] = Queen, [1] = Warden, Can't Farm With Barbarian King
Global $g_bActivatedHeroes[3] = [False, False, False] ; [0] = Archer Queen, [1] = Grand Warden, [2] = Barbarian King , Prevent to click on them to Activate Again And Again
Global Const $g_iMinStarsToEnd = 1
Global $bCanGainXP = False

; Humanization - Team AiO MOD++
Global $g_iacmbPriority[10] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_iacmbMaxSpeed[2] = [1, 1]
Global $g_iacmbPause[2] = [0, 0]
; Global $g_iahumanMessage[2] = ["Hello !", "Hello !"]
; Global $g_iTxtChallengeMessage = "Ready to Challenge?"

Global $g_iMinimumPriority, $g_iMaxActionsNumber, $g_iActionToDo
Global $g_aSetActionPriority[10] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

Global $g_sFrequenceChain = "Never|Sometimes|Frequently|Often|Very Often"
Global $g_sReplayChain = "1|2|4"
Global $g_bUseBotHumanization = False, $g_bUseAltRClick = False, $g_iCmbMaxActionsNumber = 1, $g_bLookAtRedNotifications = False

Global $g_aReplayDuration[2] = [0, 0] ; An array, [0] = Minute | [1] = Seconds
Global $g_bOnReplayWindow, $g_iReplayToPause

Global $g_iLastLayout = 0

; ChatActions - Team AiO MOD++
Global $g_bChatClan = True, $g_sDelayTimeClan = 2, $g_bClanUseResponses = False, $g_bClanUseGeneric = False;, $g_bCleverbot = False
Global $g_bUseNotify = False, $g_bPbSendNew = False
Global $g_bEnableFriendlyChallenge = True, $g_sDelayTimeFC = 5, $g_bOnlyOnRequest = False
Global $g_bFriendlyChallengeBase[6] = [False, False, False, False, False, False]
Global $g_abFriendlyChallengeHours[24] = [True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True]
Global $ChatbotStartTime, $ChatbotQueuedChats[0], $ChatbotReadQueued = False, $ChatbotReadInterval = 0, $ChatbotIsOnInterval = False, _
	$g_sGlobalChatLastMsgSentTime = "", $g_sClanChatLastMsgSentTime = "", $g_sFCLastMsgSentTime = ""

Global $g_iCmbPriorityCHAT = 0, $g_iCmbPriorityFC = 0, $g_bChkHarangueCG = 0

Global $g_sGetOcrMod = "", $g_aImageSearchXML = -1
Global $g_aClanResponses, $g_sClanResponses
Global $g_aClanGeneric, $g_sClanGeneric
Global $g_aChallengeText, $g_aKeywordFcRequest, $g_sChallengeText, $g_sKeywordFcRequest

#Region - Daily Discounts - Team AiO MOD++
Global $g_iDDCount = 20
Global $g_abChkDD_Deals[$g_iDDCount] = [False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False, False]
Global $g_aiDD_DealsCosts[$g_iDDCount] = [25, 75, 70, 115, 285, 300, 300, 500, 1000, 500, 500, 925, 925, 925, 1500, 1500, 3000, 1500, 1500, 300]
Global $g_eDDPotionTrain = 0, $g_eDDPotionClock = 1, $g_eDDPotionResearch = 2, $g_eDDPotionResource = 3, $g_eDDPotionBuilder = 4, _
		$g_eDDPotionPower = 5, $g_eDDPotionHero = 6, $g_eDDWallRing5 = 7, $g_eDDWallRing10 = 8, $g_eDDShovel = 9, $g_eDDBookHeros = 10, _
		$g_eDDBookFighting = 11, $g_eDDBookSpells = 12, $g_eDDBookBuilding = 13, $g_eDDRuneGold = 14, $g_eDDRuneElixir = 15, $g_eDDRuneDarkElixir = 16, _
		$g_eDDRuneBBGold = 17, $g_eDDRuneBBElixir = 18, $g_eDDSuperPotion = 19
#EndRegion - Daily Discounts - Team AiO MOD++

; CSV Deploy Speed - Team AiO MOD++
Global $cmbCSVSpeed[2] = [$LB, $DB]
Global $icmbCSVSpeed[2] = [2, 2]
Global $g_CSVSpeedDivider[2] = [1, 1] ; default CSVSpeed for DB & LB

#Region Check Collectors Outside
; Check Collector Outside - Team AiO MOD++
Global $g_bScanMineAndElixir = False

; Collectors Outside Filter
Global $g_bDBCollectorNone = True
Global $g_bDBMeetCollectorOutside = False, $g_iDBMinCollectorOutsidePercent = 80
Global $g_bDBCollectorNearRedline = False, $g_iCmbRedlineTiles = 1
Global $g_bSkipCollectorCheck = False, $g_iTxtSkipCollectorGold = 400000, $g_iTxtSkipCollectorElixir = 400000, $g_iTxtSkipCollectorDark = 0
Global $g_bSkipCollectorCheckTH = False, $g_iCmbSkipCollectorCheckTH = 1
; constants
Global Const $THEllipseWidth = 200, $THEllipseHeigth = 150, $CollectorsEllipseWidth = 130, $CollectorsEllipseHeigth = 97.5
#EndRegion Check Collectors Outside

; Auto Dock, Hide Emulator & Bot - Team AiO MOD++
Global $g_bEnableAuto = False, $g_bChkAutoDock = False, $g_bChkAutoHideEmulator = True, $g_bChkAutoMinimizeBot = False

; Switch Profiles - Team AiO MOD++
Global $g_abChkSwitchMax[4] = [False, False, False, False], $g_abChkSwitchMin[4] = [False, False, False, False], _
		$g_aiCmbSwitchMax[4] = [-1, -1, -1, -1], $g_aiCmbSwitchMin[4] = [-1, -1, -1, -1], _
		$g_abChkBotTypeMax[4] = [False, False, False, False], $g_abChkBotTypeMin[4] = [False, False, False, False], _
		$g_aiCmbBotTypeMax[4] = [1, 1, 1, 1], $g_aiCmbBotTypeMin[4] = [2, 2, 2, 2], _
		$g_aiConditionMax[4] = ["12000000", "12000000", "240000", "5000"], $g_aiConditionMin[4] = ["1000000", "1000000", "20000", "3000"]

; Farm Schedule - Team AiO MOD++
Global $g_abChkSetFarm[$g_eTotalAcc], _
		$g_aiCmbAction1[$g_eTotalAcc], $g_aiCmbCriteria1[$g_eTotalAcc], $g_aiTxtResource1[$g_eTotalAcc], $g_aiCmbTime1[$g_eTotalAcc], _
		$g_aiCmbAction2[$g_eTotalAcc], $g_aiCmbCriteria2[$g_eTotalAcc], $g_aiTxtResource2[$g_eTotalAcc], $g_aiCmbTime2[$g_eTotalAcc]

; Max logout time - Team AiO MOD++
Global $g_bTrainLogoutMaxTime = False, $g_iTrainLogoutMaxTime = 4

; Multipixel solution
Global $g_iMultiPixelOffSet[2]

; Only farm - Team AiO MOD++
Global $g_bChkOnlyFarm = False
Global $g_iComboStatusMode = 0, $g_hCmbStatusMode = 0

; Check No League for Dead Base - Team AiO MOD++
Global $g_bChkNoLeague[$g_iModeCount] = [False, False, False]

; GTFO
Global $g_bChkUseGTFO = False, $g_bChkUseKickOut = False, $g_bChkKickOutSpammers = False
Global $g_iTxtMinSaveGTFO_Elixir = 200000, $g_iTxtMinSaveGTFO_DE = 2000, _
		$g_iTxtDonatedCap = 8, $g_iTxtReceivedCap = 35, _
		$g_iTxtKickLimit = 6
Global $g_hTxtClanID, $g_sTxtClanID, $g_iTxtCyclesGTFO
Global $g_bChkGTFOClanHop = False, $g_bChkGTFOReturnClan = False
Global $g_bExitAfterCyclesGTFO = False
Global $g_iCycle = 0

#Region - Magic Items
Global $g_bChkCollectMagicItems, $g_bChkBuilderPotion, $g_bChkClockTowerPotion, $g_bChkHeroPotion, $g_bChkLabPotion, $g_bChkPowerPotion, $g_bChkResourcePotion, $g_iComboHeroPotion, $g_iComboPowerPotion, _
$g_iInputBuilderPotion, $g_iInputLabPotion, $g_iInputGoldItems = 250000, $g_iInputElixirItems = 300000, $g_iInputDarkElixirItems = 1000

Global $g_hChkBuilderPotion, $g_hChkHeroPotion, $g_hChkLabPotion, $g_hChkPowerPotion, _
$g_hComboHeroPotion, $g_hComboPowerPotion, $g_hCmbInputBuilderPotion, $g_hInputLabPotion, $g_hInputGoldItems, $g_hInputElixirItems, $g_hInputDarkElixirItems
#EndRegion - Magic Items

#Region - Builder Base !!!
Global $g_oTxtBBAtkLogInitText = ObjCreate("Scripting.Dictionary")

;GUI
;CustomArmy
Global $g_iCmbCampsBB[6] = [0, 0, 0, 0, 0, 0]
Global $g_hIcnTroopBB[6]
Global $g_hComboTroopBB[6]
Global $g_bChkBBCustomArmyEnable = True, $g_hChkBBCustomArmyEnable

; Custom Improve - Team AIO Mod++
Global $g_aBBUpgradeNameLevel[3] = ["", "", ""]
Global $g_aBBUpgradeResourceCostDuration[3] = ["", "", ""]
Global $g_iChkBBUpgradesToIgnore[28] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_hChkBBUpgradesToIgnore[28] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_bRadioBBUpgradesToIgnore = True, $g_bRadioBBCustomOTTO = False
Global Const $g_sBBUpgradesToIgnore[28] = ["Builder Hall", "Gold Mine", "Elixir Collector", "Gold Storage", _
									 "Elixir Storage", "Gem Mine", "Clock Tower", "Star Laboratory", "Builder Barracks", _
									 "Battle Machine", "Cannon", "Double Cannon", "Archer Tower", "Hidden Tesla", "Firecrackers", _
									 "Crusher", "Guard Post", "Air Bombs", "Multi Mortar", "Roaster", "Giant Cannon", "Mega Tesla", _
									 "Lava Launcher", "Push Trap", "Spring Trap", "Mega Mine", "Mine", "Wall"]
	
; @snorlax x @xbebenk credits.
Global Const $g_sBBOptimizeOTTO[14] = ["Builder Hall", "Gold Mine", "Elixir Collector", "Gold Storage", _
                                     "Elixir Storage", "Gem Mine", "Clock Tower", "Star Laboratory", "Builder Barracks", _
                                     "Battle Machine", "Double Cannon", "Archer Tower", "Multi Mortar", "Mega Tesla"]

; Extra options
Global $g_iBBMinAttack = 2, $g_iBBMaxAttack = 3

; Attack
; Globals for BB Machine
; X, Y, g_bIsBBMachineD, g_bBBIsFirst
Global Const $g_aMachineBBReset[4] = [-1, -1, False, True]
Global $g_aMachineBB[4] = [-1, -1, False, True]
Global $g_iFurtherFromBBDefault = 3
Global $g_aBuilderHallPos = -1, $g_aAirdefensesPos = -1, $g_aCrusherPos = -1, $g_aCannonPos = -1, $g_aGuardPostPos = -1, _
$g_aAirBombs = -1, $g_aLavaLauncherPos = -1, $g_aRoasterPos = -1, $g_aDeployPoints, $g_aBestDeployPoints, $g_aOuterDeployPoints
Global $g_aBBMainSide = "TopLeft"
Global $g_aExternalEdges, $g_aBuilderBaseDiamond, $g_aOuterEdges, $g_aBuilderBaseOuterDiamond, $g_aBuilderBaseOuterPolygon, $g_aBuilderBaseAttackPolygon, $g_aFinalOuter[4]

Global $g_bIsMachinePresent = False
Global $g_iBBMachAbilityLastActivatedTime = -1 ; time between abilities

; Report
Global $g_iAvailableAttacksBB = 0, $g_iLastDamage = 0

; GUI
Global Enum $g_eBBAttackCSV = 0, $g_eBBAttackSmart = 1
Global $g_iCmbBBAttack = $g_eBBAttackCSV
Global $g_hTabBuilderBase = 0, $g_hTabAttack = 0
Global $g_hCmbBBAttack = 0

; Attack CSV
Global $g_bChkBBCustomAttack = False
Global Const $g_sCSVBBAttacksPath = @ScriptDir & "\CSV\BuilderBase"
Global $g_sAttackScrScriptNameBB[3] = ["", "", ""]
Global $g_iBuilderBaseScript = 0

; Upgrade Troops
Global $g_bChkUpgradeTroops = False, $g_bChkUpgradeMachine = False

; BB Upgrade Walls - Team AiO MOD++
Global Const $g_aWallBBInfoPerLevel[10][4] = [[0, 0, 0, 0], [1, 4000, 20, 2], [2, 10000, 50, 3], [3, 100000, 50, 3], [4, 300000, 75, 4], [5, 800000, 100, 5], [6, 1200000, 120, 6], [7, 2000000, 140, 7], [8, 3000000, 160, 8], [9, 4000000, 180, 9]]
Global $g_bChkBBUpgradeWalls = False, $g_iCmbBBWallLevel, $g_iBBWallNumber = 0, _ 
	   $g_bChkBBUpgWallsGold = True, $g_bChkBBUpgWallsElixir = False, $g_bChkBBWallRing = False

; Troops
Global Enum $eBBTroopBarbarian, $eBBTroopArcher, $eBBTroopGiant, $eBBTroopMinion, $eBBTroopBomber, $eBBTroopBabyDragon, $eBBTroopCannon, $eBBTroopNight, $eBBTroopDrop, $eBBTroopPekka, $eBBTroopHogG, $eBBTroopMachine, $g_iBBTroopCount
Global $g_sIcnBBOrder[$g_iBBTroopCount]
Global Const $g_asAttackBarBB[$g_iBBTroopCount] = ["Barbarian", "Archer", "BoxerGiant", "Minion", "WallBreaker", "BabyDrag", "CannonCart", "Witch", "DropShip", "SuperPekka", "HogGlider", "Machine"]
Global $g_sBBDropOrder = "|" & _ArrayToString($g_asAttackBarBB)

; BB Drop Order
Global $g_hBtnBBDropOrder = 0
Global $g_hGUI_BBDropOrder = 0
Global $g_hChkBBCustomDropOrderEnable = 0
Global $g_hBtnBBDropOrderSet = 0, $g_hBtnBBRemoveDropOrder = 0, $g_hBtnBBClose = 0
Global $g_bBBDropOrderSet = False
Global $g_aiCmbBBDropOrder[$g_iBBTroopCount] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]
Global $g_ahCmbBBDropOrder[$g_iBBTroopCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_iBBNextTroopDelay = 2000,  $g_iBBSameTroopDelay = 300; delay time between different and same troops

; Camps
Global $g_aCamps[6] = ["", "", "", "", "", ""]

; General
Global $g_bChkBuilderAttack = False, $g_bChkBBStopAt3 = False, $g_bChkBBTrophiesRange = False, $g_iTxtBBDropTrophiesMin = 0, $g_iTxtBBDropTrophiesMax = 0
Global $g_iCmbBBArmy1 = 0, $g_iCmbBBArmy2 = 0, $g_iCmbBBArmy3 = 0, $g_iCmbBBArmy4 = 0, $g_iCmbBBArmy5 = 0, $g_iCmbBBArmy6 = 0

; Attack cycles
Global $g_bDSICGBB = True

; Internal & External Polygon
;~ Global $CocDiamondECD = $CocDiamondECD
;~ Global $CocDiamondDCD = $CocDiamondDCD
Global $InternalArea[8][3]
Global $ExternalArea[8][3]

; Log
Global $g_hBBAttackLogFile = 0

Global $g_bOnlyBuilderBase = False

Global $g_bChkBBGetFromCSV = False, $g_bChkBBGetFromArmy

; CleanYardBBAll
Global $g_bChkCleanYardBBAll = False, $g_hChkCleanYardBBall = 0

; Clock tower mecanics.
Global $g_iCmbStartClockTowerBoost = 0, _
$g_bChkClockTowerPotion = 0, $g_iCmbClockTowerPotion = 0 ; AIO ++

#EndRegion - Builder Base !!!

Global $g_iAttackTotalBLButtons = -1
Global $g_aBLButtonsRegion[4] = [10, 570, 450, 55]

#Region - Custom SmartFarm - Team AIO Mod++
Global $g_hChkSmartFarmAndRandomDeploy, $g_bUseSmartFarmAndRandomDeploy = True
Global $g_hChkSmartFarmAndRandomQuant, $g_bUseSmartFarmAndRandomQuant = False
Global $g_hCmbSmartFarmSpellsHowManySides, $g_hSmartFarmSpellsEnable, $g_iSmartFarmSpellsHowManySides = 2, $g_bSmartFarmSpellsEnable = True
Global $g_hChkUseSmartFarmRedLine, $g_bUseSmartFarmRedLine = False

Global $g_FirstBitMap, $g_SecondBitMap
#EndRegion - Custom SmartFarm - Team AIO Mod++

#Region - Misc - Team AIO Mod++
Global $g_bChkColorfulAttackLog = True, _
       $g_bChkBuyGuard = False
	   
Global $g_hChkColorfulAttackLog = 0, _
	   $g_hChkBuyGuard = 0
#EndRegion - Misc - Team AIO Mod++

#Region - Request defense CC (Demen)
Global $g_bRequestCCDefense, $g_sRequestCCDefenseText, $g_iCmbRequestCCDefenseWhen, $g_iRequestDefenseTime, $g_bSaveCCTroopForDefense
Global $g_aiCCTroopsExpectedForDef[$eTroopCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_aiClanCastleTroopDefType[3], $g_aiCCDefenseTroopWaitQty[3]
Global $g_bChkRemoveCCForDefense = False
#EndRegion - Request defense CC (Demen)

#Region - Type Once - ChacalGyn
Global $g_aiRequestTroopTypeOnce[$g_eTotalAcc] = [0, 0, 0, 0, 0, 0, 0, 0]
Global $g_bChkRequestTypeOnceEnable = True
#EndRegion - Type Once - ChacalGyn

#Region - Request Early - Team AIO Mod++
Global $g_bChkReqCCFirst = False, $g_bChkRequestFromChat = False
#EndRegion - Request Early - Team AIO Mod++

#Region - Custom SmartZap - Team AIO Mod++
Global $g_bDoneSmartZap = False
#EndRegion - Custom SmartZap - Team AIO Mod++

#Region - Custom smart attack - Team AIO Mod++
Global $g_abAttackStdSmartDropSpells[$g_iModeCount + 1] = [0, 0, 0, 0]
#EndRegion - Custom smart attack - Team AIO Mod++

#Region - Custom schedule - Team AIO Mod++
Global $g_hChkRNDSchedAttack = 0, $g_hCmbRNDSchedAttack = 0
Global $g_bChkRNDSchedAttack = False, $g_iRNDSchedAttack = 8, $g_iChkRNDSchedAttack = 24, $g_iTimeRNDSchedAttack = 0

Global $g_aiAttackedCountAcc[$g_eTotalAcc]
Global $g_bAttackAccountReachLimts[$g_eTotalAcc]
Global $g_abPlannedAttackWeekDays[$g_eTotalAcc][7]
Global $g_abPlannedattackHours[$g_eTotalAcc][24]
For $i = 0 To $g_eTotalAcc - 1
	For $h = 0 To UBound($g_abPlannedAttackWeekDays, $UBOUND_COLUMNS) - 1
		$g_abPlannedAttackWeekDays[$i][$h] = True
	Next
	For $h = 0 To UBound($g_abPlannedattackHours, $UBOUND_COLUMNS) - 1
		$g_abPlannedattackHours[$i][$h] = True
	Next
    $g_bAttackAccountReachLimts[$i] = False
	$g_aiAttackedCountAcc[$i] = 0
Next
#EndRegion - Custom schedule - Team AIO Mod++

#Region - Custom Wall - Team AIO Mod++
Global $g_hchkwallspriorities = 0, $g_bchkwallspriorities = False
#EndRegion - Custom Wall - Team AIO Mod++

#Region - SmartMilk
Global $g_bDebugSmartMilk = False, $g_bChkMilkForceDeployHeroes = False, $g_bChkMilkForceAllTroops = False, $g_iMilkStrategyArmy = 0, _
	   $g_iMilkDelay = 3, $g_bMilksJumpSpells = False, $g_bChkmilkForceTH = False

; Global $g_bChkByPassToSmartFarm = False, $g_bByPassSmartFarm = False
#EndRegion - SmartMilk

; Custom Fix - Team AIO Mod++
Global $g_bAttackClickFC = False
Global $g_bIsCaravanOn = "Undefined" ; Custom BB - Team AIO Mod++

;Village Reference size, add info here for every scenery:
;[stoneName, SceneryName, stone2tree distance, DiamondInnerXleft, DiamondInnerXRight, DiamondInnerYTop, DiamondInnerYBottom]
Global $g_aVillageRefSize[16][7] = [["DS", "Default", 612.8, 45, 815, 60, 636], _ ;ok
									["JS", "Jungle", 566.60, 69, 796, 64, 609], _ ;ok
									["BB", "BuilderBase", 523, 117, 748, 128, 595], _
									["CC", "Clashy Construction", 642.40, 50, 811, 60, 636], _ ;ok
									["PC", "Pirate", 598.68, 50, 812, 63, 634], _ ;ok
									["EW", "Winter", 576.41, 68, 794, 61, 607], _ ;ok
									["HM", "Hog Mountain", 637.4, 52, 810, 62, 636], _ ;ok
									["EP", "Epic Jungle", 636.8, 45, 815, 60, 636], _ ;ok
									["9C", "9th Clashivery", 617.21, 76, 803, 64, 611], _ ;ok
									["PG", "Pumpkin Graveyard", 567.01, 94, 784, 58, 581], _
									["SD", "Snow Day", 569.2, 84, 789, 58, 584], _ ;ok
									["TM", "Tiger Mountain", 616, 74, 805, 45, 594], _ ;ok
									["PR", "Primal", 580.41, 74, 803, 64, 613], _ ;ok
									["SH", "Shadow", 598.40, 81, 790, 61, 592], _ ;ok
									["RY", "Royal", 610.20, 57, 799, 48, 603], _ ;ok
									["SM", "Summer", 568, 85, 813, 56, 604]] ;ok
									
Global $g_sCurrentScenery = "", $g_sSceneryCode = "DS"
Global $g_aFallbackDragFix = -1

; New building MV - Team AIO Mod++
Global $g_bNewUpdateMainVillage = False, $g_hChkAutoBuildNew = 0

; Android version
Global $g_hLblAndroidInfo = 0