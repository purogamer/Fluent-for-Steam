; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Control Variables
; Description ...: This file Includes several files in the current script and all Declared variables, constant, or create an array.
; Syntax ........: #include , Global
; Parameters ....: $action_groupe, $group_de_controle
; Return values .: None
; Author ........: Boju(2016)
; Modified ......: MR.ViPER (11-2016), CodeSlinger69 (2017), MMHK (01-2018)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Global $g_aGroupSearchDB = "", $groupHerosDB = "", $groupSearchAB = "", $groupHerosAB = "", $groupSpellsDB = "", $groupSpellsAB = "", $groupSearchTS = ""

;Attack
Global $g_aGroupAttackDB = "", $g_aGroupAttackDBSpell = "", $groupIMGAttackDB = "", $groupIMGAttackDBSpell = "", $groupAttackAB = "", $groupAttackABSpell = "", _
	   $groupIMGAttackAB = "", $groupIMGAttackABSpell = "", $groupAttackTS = "", $groupAttackTSSpell = "", $groupIMGAttackTS = "", $groupIMGAttackTSSpell = ""

Global $g_aGroupListPicMinTrophy = "", $g_aGroupListPicMaxTrophy = ""

;End Battle
Global $g_aGroupEndBattleDB = "", $groupEndBattkeAB = "", $groupKingSleeping = "", $groupQueenSleeping = "", $groupWardenSleeping = "", $groupCloseWhileTraining = "", _
	   $grpTrainTroops = "", $grpCookSpell = "", $groupChampionSleeping = ""

;Spell
Global $groupLightning = "", $groupHeal = "", $groupRage = "", $groupJump = "", $groupFreeze = "", $groupClone = "", $groupInvisibility = ""

;Dark Spell
Global $groupPoison = "", $groupEarthquake = "", $groupHaste = "", $groupSkeleton = "", $groupBat = ""

;All Spells
Global $groupListSpells = ""

;Sieges
Global $groupWallWrecker = "", $groupBattleBlimp = "", $groupStoneSlammer = "", $groupSiegeBarracks = "", $groupLogLauncher = "", $groupFlameFlinger, $groupListSieges = ""

;TH Level
Global $g_aGroupListTHLevels = ""

;PicDBMaxTH
Global $g_aGroupListPicDBMaxTH = ""

;PicABMaxTH
Global $g_aGroupListPicABMaxTH = ""

;PicBullyMaxTH
Global $g_aGroupListPicBullyMaxTH = ""

;League
Global $g_aGroupLeague = ""

; Groups of controls
Global $aTabControlsVillage, $aTabControlsMisc, $aTabControlsDonate, $aTabControlsUpgrade, $aTabControlsNotify
Global $aTabControlsAttack, $aTabControlsArmy, $aTabControlsSearch, $aTabControlsDeadbase, $aTabControlsActivebase, $aTabControlsAttackOptions
Global $aTabControlsStrategies, $aTabControlsBot, $aTabControlsStats
Global $aTabControlsMOD, $aTabControlsBuilderBase, $aTabControlsSwitchOpt ; AIO MOD++

Global $oAlwaysEnabledControls = ObjCreate("Scripting.Dictionary")

Func InitializeControlVariables()
   $g_aGroupSearchDB = $g_hGrpDBFilter&"#"&$g_hCmbDBMeetGE&"#"&$g_hTxtDBMinGold&"#"&$g_hPicDBMinGold&"#"&$g_hTxtDBMinElixir&"#"&$g_hPicDBMinElixir&"#"& _
				    $g_hTxtDBMinGoldPlusElixir&"#"&$g_hPicDBMinGPEGold&"#"&$g_hChkDBMeetDE&"#"&$g_hTxtDBMinDarkElixir&"#"&$g_hPicDBMinDarkElixir&"#"&$g_hChkDBMeetTrophy&"#"& _
				    $g_hTxtDBMinTrophy&"#"&$g_hTxtDBMaxTrophy&"#"&$g_hPicDBMinTrophies&"#"&$g_hChkDBMeetTH&"#"&$g_hCmbDBTH&"#"&$g_hChkDBMeetTHO&"#"& _
				    $g_ahChkMeetOne[$DB]&"#"& _
				    $g_ahChkMaxMortar[$DB]&"#"&$g_ahCmbWeakMortar[$DB]&"#"&$g_ahPicWeakMortar[$DB]&"#"&$g_ahChkMaxWizTower[$DB]&"#"&$g_ahCmbWeakWizTower[$DB]&"#"& _
				    $g_ahPicWeakWizTower[$DB]&"#"& _
				    $g_ahChkMaxXBow[$DB]&"#"&$g_ahCmbWeakXBow[$DB]&"#"&$g_ahPicWeakXBow[$DB]&"#"&$g_ahChkMaxInferno[$DB]&"#"&$g_ahCmbWeakInferno[$DB]&"#"& _
				    $g_ahPicWeakInferno[$DB]&"#"&$g_ahChkMaxEagle[$DB]&"#"&$g_ahCmbWeakEagle[$DB]&"#"&$g_ahPicWeakEagle[$DB]&"#"&$g_ahChkMaxScatter[$DB]&"#"&$g_ahCmbWeakScatter[$DB]&"#"&$g_ahPicWeakScatter[$DB]
   $groupHerosDB = $g_hPicDBHeroesWait&"#"&$g_hTxtDBHeroesWait&"#"&$g_hChkDBKingWait&"#"&$g_hChkDBQueenWait&"#"&$g_hChkDBWardenWait&"#"&$g_hChkDBChampionWait&"#"&$g_hPicDBKingWait&"#"& _
				   $g_hPicDBQueenWait&"#"&$g_hPicDBWardenWait&"#"&$g_hPicDBChampionWait&"#"&$g_hChkDBNotWaitHeroes

   $groupSearchAB = $g_hGrpABFilter&"#"&$g_hCmbABMeetGE&"#"&$g_hTxtABMinGold&"#"&$g_hPicABMinGold&"#"&$g_hTxtABMinElixir&"#"&$g_hPicABMinElixir&"#"& _
				    $g_hTxtABMinGoldPlusElixir&"#"&$g_hPicABMinGPEGold&"#"&$g_hChkABMeetDE&"#"&$g_hTxtABMinDarkElixir&"#"&	$g_hPicABMinDarkElixir&"#"&$g_hChkABMeetTrophy&"#"& _
				    $g_hTxtABMinTrophy&"#"&$g_hTxtABMaxTrophy&"#"&$g_hPicABMinTrophies&"#"&$g_hChkABMeetTH&"#"&$g_hCmbABTH&"#"&$g_hChkABMeetTHO&"#"& _
				    $g_ahChkMeetOne[$LB]&"#"& _
				    $g_ahChkMaxMortar[$LB]&"#"&$g_ahCmbWeakMortar[$LB]&"#"&$g_ahPicWeakMortar[$LB]&"#"&$g_ahChkMaxWizTower[$LB]&"#"&$g_ahCmbWeakWizTower[$LB]&"#"& _
					$g_ahPicWeakWizTower[$LB]&"#"&$g_ahChkMaxXBow[$LB]&"#"&$g_ahCmbWeakXBow[$LB]&"#"&$g_ahPicWeakXBow[$LB]&"#"&$g_ahChkMaxInferno[$LB]&"#"& _
					$g_ahCmbWeakInferno[$LB]&"#"&$g_ahPicWeakInferno[$LB]&"#"&$g_ahChkMaxEagle[$LB]&"#"&$g_ahCmbWeakEagle[$LB]&"#"&$g_ahPicWeakEagle[$LB]&"#"&$g_ahChkMaxScatter[$LB]&"#"&$g_ahCmbWeakScatter[$LB]&"#"&$g_ahPicWeakScatter[$LB]
   $groupHerosAB = $g_hPicABHeroesWait&"#"&$g_hTxtABHeroesWait&"#"&$g_hChkABKingWait&"#"&$g_hChkABQueenWait&"#"&$g_hChkABWardenWait&"#"&$g_hChkABChampionWait&"#"& _
					$g_hPicABKingWait&"#"&$g_hPicABQueenWait&"#"&$g_hPicABWardenWait&"#"&$g_hPicABChampionWait&"#"&$g_hChkABNotWaitHeroes

   $groupSpellsDB = $g_hChkDBSpellsWait&"#"&$g_hPicDBLightSpellWait&"#"&$g_hPicDBHealSpellWait&"#"&$g_hPicDBRageSpellWait&"#"&$g_hPicDBJumpSpellWait&"#"& _
				    $g_hPicDBFreezeSpellWait&"#"&$g_hPicDBPoisonSpellWait&"#"&$g_hPicDBEarthquakeSpellWait&"#"&$g_hPicDBHasteSpellWait
   $groupSpellsAB = $g_hChkABSpellsWait&"#"&$g_hPicABLightSpellWait&"#"&$g_hPicABHealSpellWait&"#"&$g_hPicABRageSpellWait&"#"&$g_hPicABJumpSpellWait&"#"& _
				    $g_hPicABFreezeSpellWait&"#"&$g_hPicABPoisonSpellWait&"#"&$g_hPicABEarthquakeSpellWait&"#"&$g_hPicABHasteSpellWait

   ;Attack
   $g_aGroupAttackDB = 	$g_hCmbDBAlgorithm&"#"&$g_hCmbDBSelectTroop&"#"&$g_hChkDBKingAttack&"#"&$g_hChkDBQueenAttack&"#"&$g_hChkDBWardenAttack&"#"&$g_hChkDBChampionAttack&"#"&$g_hChkDBDropCC&"#"& _
						$g_hChkDBLightSpell&"#"&$g_hChkDBHealSpell&"#"&$g_hChkDBRageSpell&"#"&$g_hChkDBJumpSpell&"#"&$g_hChkDBFreezeSpell&"#"&$g_hChkDBCloneSpell&"#"& _
						$g_hChkDBInvisibilitySpell&"#"&$g_hChkDBPoisonSpell&"#"&$g_hChkDBEarthquakeSpell&"#"&$g_hChkDBHasteSpell&"#"&$g_hChkDBSkeletonSpell&"#"&$g_hChkDBBatSpell
   $g_aGroupAttackDBSpell = $g_hChkDBLightSpell&"#"&$g_hChkDBHealSpell&"#"&$g_hChkDBRageSpell&"#"&$g_hChkDBJumpSpell&"#"&$g_hChkDBFreezeSpell&"#"&$g_hChkDBCloneSpell&"#"& _
							$g_hChkDBInvisibilitySpell&"#"&$g_hChkDBPoisonSpell&"#"&$g_hChkDBEarthquakeSpell&"#"&$g_hChkDBHasteSpell&"#"&$g_hChkDBSkeletonSpell&"#"&$g_hChkDBBatSpell
   $groupIMGAttackDB = 	$g_hPicDBKingAttack&"#"&$g_hPicDBQueenAttack&"#"&$g_hPicDBWardenAttack&"#"&$g_hPicDBChampionAttack&"#"&$g_hPicDBDropCC&"#"& _
						$g_hPicDBLightSpell&"#"&$g_hPicDBHealSpell&"#"&$g_hPicDBRageSpell&"#"&$g_hPicDBJumpSpell&"#"&$g_hPicDBFreezeSpell&"#"&$g_hPicDBCloneSpell&"#"& _
						$g_hPicDBInvisibilitySpell&"#"&$g_hPicDBPoisonSpell&"#"&$g_hPicDBEarthquakeSpell&"#"&$g_hPicDBHasteSpell&"#"&$g_hPicDBSkeletonSpell&"#"&$g_hPicDBBatSpell
   $groupIMGAttackDBSpell = $g_hPicDBLightSpell&"#"&$g_hPicDBHealSpell&"#"&$g_hPicDBRageSpell&"#"&$g_hPicDBJumpSpell&"#"&$g_hPicDBFreezeSpell&"#"&$g_hPicDBCloneSpell&"#"& _
							$g_hPicDBInvisibilitySpell&"#"&$g_hPicDBPoisonSpell&"#"&$g_hPicDBEarthquakeSpell&"#"&$g_hPicDBHasteSpell&"#"&$g_hPicDBSkeletonSpell&"#"&$g_hPicDBBatSpell

   $groupAttackAB = $g_hCmbDBAlgorithm&"#"&$g_hCmbABSelectTroop&"#"&$g_hChkABKingAttack&"#"&$g_hChkABQueenAttack&"#"&$g_hChkABWardenAttack&"#"&$g_hChkABChampionAttack&"#"&$g_hChkABDropCC&"#"& _
				    $g_hChkABLightSpell&"#"&$g_hChkABHealSpell&"#"&$g_hChkABRageSpell&"#"&$g_hChkABJumpSpell&"#"&$g_hChkABFreezeSpell&"#"&$g_hChkABCloneSpell&"#"& _
					$g_hChkABInvisibilitySpell&"#"&$g_hChkABPoisonSpell&"#"&$g_hChkABEarthquakeSpell&"#"&$g_hChkABHasteSpell&"#"&$g_hChkABSkeletonSpell&"#"&$g_hChkABBatSpell
   $groupAttackABSpell = 	$g_hChkABLightSpell&"#"&$g_hChkABHealSpell&"#"&$g_hChkABRageSpell&"#"&$g_hChkABJumpSpell&"#"&$g_hChkABFreezeSpell&"#"&$g_hChkABCloneSpell&"#"& _
							$g_hChkABInvisibilitySpell&"#"&$g_hChkABPoisonSpell&"#"&$g_hChkABEarthquakeSpell&"#"&$g_hChkABHasteSpell&"#"&$g_hChkABSkeletonSpell&"#"&$g_hChkABBatSpell
   $groupIMGAttackAB = 	$g_hPicABKingAttack&"#"&$g_hPicABQueenAttack&"#"&$g_hPicABWardenAttack&"#"&$g_hPicABChampionAttack&"#"&$g_hPicABDropCC&"#"& _
						$g_hPicABLightSpell&"#"&$g_hPicABHealSpell&"#"&$g_hPicABRageSpell&"#"&$g_hPicABJumpSpell&"#"&$g_hPicABFreezeSpell&"#"&$g_hPicABCloneSpell&"#"& _
							$g_hPicABInvisibilitySpell&"#"&$g_hPicABPoisonSpell&"#"&$g_hPicABEarthquakeSpell&"#"&$g_hPicABHasteSpell&"#"&$g_hPicABSkeletonSpell&"#"&$g_hPicABBatSpell
   $groupIMGAttackABSpell = $g_hPicABLightSpell&"#"&$g_hPicABHealSpell&"#"&$g_hPicABRageSpell&"#"&$g_hPicABJumpSpell&"#"&$g_hPicABFreezeSpell&"#"&$g_hPicABCloneSpell&"#"& _
							$g_hPicABInvisibilitySpell&"#"&$g_hPicABPoisonSpell&"#"&$g_hPicABEarthquakeSpell&"#"&$g_hPicABHasteSpell&"#"&$g_hPicABSkeletonSpell&"#"&$g_hPicABBatSpell


   $g_aGroupListPicMinTrophy = $g_hPicMinTrophies[$eLeagueUnranked]&"#"&$g_hPicMinTrophies[$eLeagueBronze]&"#"&$g_hPicMinTrophies[$eLeagueSilver]&"#"&$g_hPicMinTrophies[$eLeagueGold] &"#"& _
				  $g_hPicMinTrophies[$eLeagueCrystal]&"#"&$g_hPicMinTrophies[$eLeagueMaster]&"#"&$g_hPicMinTrophies[$eLeagueChampion]&"#"&$g_hPicMinTrophies[$eLeagueTitan]&"#"& _
				  $g_hPicMinTrophies[$eLeagueLegend]
   $g_aGroupListPicMaxTrophy = $g_hPicMaxTrophies[$eLeagueUnranked]&"#"&$g_hPicMaxTrophies[$eLeagueBronze]&"#"&$g_hPicMaxTrophies[$eLeagueSilver]&"#"&$g_hPicMaxTrophies[$eLeagueGold] &"#"& _
				  $g_hPicMaxTrophies[$eLeagueCrystal]&"#"&$g_hPicMaxTrophies[$eLeagueMaster]&"#"&$g_hPicMaxTrophies[$eLeagueChampion]&"#"&$g_hPicMaxTrophies[$eLeagueTitan]&"#"& _
				  $g_hPicMaxTrophies[$eLeagueLegend]

   ;End Battle
   $g_aGroupEndBattleDB = $g_hGrpDBEndBattle&"#"&$g_hChkStopAtkDBNoLoot1&"#"&$g_hLblStopAtkDBNoLoot1a&"#"&$g_hTxtStopAtkDBNoLoot1&"#"&$g_hLblStopAtkDBNoLoot1b&"#"& _
					   $g_hChkStopAtkDBNoLoot2&"#"&$g_hChkStopAtkDBNoLoot2&"#"&$g_hLblStopAtkDBNoLoot2a&"#"&$g_hTxtStopAtkDBNoLoot2&"#"&$g_hLblStopAtkDBNoLoot2b&"#"& _
					   $g_hLblDBMinRerourcesAtk2&"#"&$g_hTxtDBMinGoldStopAtk2&"#"&$g_hPicDBMinGoldStopAtk2&"#"&$g_hTxtDBMinElixirStopAtk2&"#"&$g_hPicDBMinElixirStopAtk2&"#"& _
					   $g_hTxtDBMinDarkElixirStopAtk2&"#"&$g_hPicDBMinDarkElixirStopAtk2&"#"&$g_hChkDBEndNoResources&"#"&$g_hChkDBEndOneStar&"#"&$g_hChkDBEndTwoStars
   $groupEndBattkeAB = $g_hGrpABEndBattle&"#"&$g_hChkStopAtkABNoLoot1&"#"&$g_hLblABTimeStopAtka&"#"&$g_hTxtStopAtkABNoLoot1&"#"&$g_hLblABTimeStopAtk&"#"& _
					   $g_hChkStopAtkABNoLoot2&"#"&$g_hChkStopAtkABNoLoot2&"#"&$g_hLblABTimeStopAtk2a&"#"&$g_hTxtStopAtkABNoLoot2&"#"&$g_hLblABTimeStopAtk2&"#"& _
					   $g_hLblABMinRerourcesAtk2&"#"&$g_hTxtABMinGoldStopAtk2&"#"&$g_hPicABMinGoldStopAtk2&"#"&$g_hTxtABMinElixirStopAtk2&"#"&$g_hPicABMinElixirStopAtk2&"#"& _
					   $g_hTxtABMinDarkElixirStopAtk2&"#"&$g_hPicABMinDarkElixirStopAtk2&"#"&$g_hChkABEndNoResources&"#"&$g_hChkABEndOneStar&"#"&$g_hChkABEndTwoStars

   $groupKingSleeping = $g_hPicDBKingSleepWait&"#"&$g_hPicABKingSleepWait&"#"&$g_hPicChkKingSleepWait
   $groupQueenSleeping = $g_hPicDBQueenSleepWait&"#"&$g_hPicABQueenSleepWait&"#"&$g_hPicChkQueenSleepWait
   $groupWardenSleeping = $g_hPicDBWardenSleepWait&"#"&$g_hPicABWardenSleepWait&"#"&$g_hPicChkWardenSleepWait
   $groupChampionSleeping = $g_hPicDBChampionSleepWait&"#"&$g_hPicABChampionSleepWait&"#"&$g_hPicChkChampionSleepWait

   $groupCloseWhileTraining = $g_hChkCloseWithoutShield&"#"&$g_hChkCloseEmulator&"#"&$g_hChkSuspendComputer&"#"&$g_hPicCloseWaitTrain&"#"&$g_hChkRandomClose&"#"&$g_hPicCloseWaitStop&"#"& _
							  $g_hRdoCloseWaitExact&"#"&$g_hPicCloseWaitExact&"#"&$g_hRdoCloseWaitRandom&"#"&$g_hCmbCloseWaitRdmPercent&"#"&$g_hLblCloseWaitRdmPercent
   $grpTrainTroops = $g_ahTxtTrainArmyTroopCount[$eTroopBarbarian]&"#"&$g_ahTxtTrainArmyTroopCount[$eTroopSuperBarbarian]&"#"&$g_ahTxtTrainArmyTroopCount[$eTroopArcher]&"#"& _
					 $g_ahTxtTrainArmyTroopCount[$eTroopSuperArcher]&"#"&$g_ahTxtTrainArmyTroopCount[$eTroopGiant]&"#"&$g_ahTxtTrainArmyTroopCount[$eTroopSuperGiant]&"#"& _
					 $g_ahTxtTrainArmyTroopCount[$eTroopGoblin]&"#"&$g_ahTxtTrainArmyTroopCount[$eTroopSneakyGoblin]&"#"&$g_ahTxtTrainArmyTroopCount[$eTroopWallBreaker]&"#"& _
					 $g_ahTxtTrainArmyTroopCount[$eTroopSuperWallBreaker]&"#"&$g_ahTxtTrainArmyTroopCount[$eTroopBalloon]&"#"&$g_ahTxtTrainArmyTroopCount[$eTroopRocketBalloon]&"#"&$g_ahTxtTrainArmyTroopCount[$eTroopWizard]&"#"& _
					 $g_ahTxtTrainArmyTroopCount[$eTroopSuperWizard]&"#"&$g_ahTxtTrainArmyTroopCount[$eTroopHealer]&"#"&$g_ahTxtTrainArmyTroopCount[$eTroopDragon]&"#"& _
					 $g_ahTxtTrainArmyTroopCount[$eTroopPekka]&"#"&$g_ahTxtTrainArmyTroopCount[$eTroopBabyDragon]&"#"&$g_ahTxtTrainArmyTroopCount[$eTroopInfernoDragon]&"#"& _
					 $g_ahTxtTrainArmyTroopCount[$eTroopMiner]&"#"&$g_ahTxtTrainArmyTroopCount[$eTroopMinion]&"#"&$g_ahTxtTrainArmyTroopCount[$eTroopSuperMinion]&"#"& _
					 $g_ahTxtTrainArmyTroopCount[$eTroopHogRider]&"#"&$g_ahTxtTrainArmyTroopCount[$eTroopValkyrie]&"#"&$g_ahTxtTrainArmyTroopCount[$eTroopSuperValkyrie]&"#"& _
					 $g_ahTxtTrainArmyTroopCount[$eTroopGolem]&"#"&$g_ahTxtTrainArmyTroopCount[$eTroopWitch]&"#"&$g_ahTxtTrainArmyTroopCount[$eTroopSuperWitch]&"#"& _
					 $g_ahTxtTrainArmyTroopCount[$eTroopLavaHound]&"#"&$g_ahTxtTrainArmyTroopCount[$eTroopIceHound]&"#"&$g_ahTxtTrainArmyTroopCount[$eTroopBowler]&"#"& _
					 $g_ahTxtTrainArmyTroopCount[$eTroopElectroDragon]&"#"&$g_ahTxtTrainArmyTroopCount[$eTroopIceGolem]&"#"&$g_ahTxtTrainArmyTroopCount[$eTroopYeti]&"#"& _
					 $g_ahTxtTrainArmyTroopCount[$eTroopDragonRider]&"#"&$g_ahTxtTrainArmyTroopCount[$eTroopHeadhunter]&"#"&$g_ahTxtTrainArmyTroopCount[$eTroopSuperBowler]
   $grpCookSpell = $g_ahTxtTrainArmySpellCount[$eSpellLightning]&"#"&$g_ahTxtTrainArmySpellCount[$eSpellHeal]&"#"&$g_ahTxtTrainArmySpellCount[$eSpellRage]&"#"& _
				   $g_ahTxtTrainArmySpellCount[$eSpellJump]&"#"&$g_ahTxtTrainArmySpellCount[$eSpellFreeze]&"#"&$g_ahTxtTrainArmySpellCount[$eSpellClone]&"#"& _
				   $g_ahTxtTrainArmySpellCount[$eSpellInvisibility]&"#"&$g_ahTxtTrainArmySpellCount[$eSpellPoison]&"#"&$g_ahTxtTrainArmySpellCount[$eSpellEarthquake]&"#"& _
				   $g_ahTxtTrainArmySpellCount[$eSpellHaste]&"#"&$g_ahTxtTrainArmySpellCount[$eSpellSkeleton]&"#"&$g_ahTxtTrainArmySpellCount[$eSpellBat]

   ;Spell
   $groupLightning = $g_ahPicTrainArmySpell[$eSpellLightning]&"#"&$g_ahTxtTrainArmySpellCount[$eSpellLightning]&"#"&$g_ahLblTrainArmySpellLevel[$eSpellLightning]
   $groupHeal = $g_ahPicTrainArmySpell[$eSpellHeal]&"#"&$g_ahTxtTrainArmySpellCount[$eSpellHeal]&"#"&$g_ahLblTrainArmySpellLevel[$eSpellHeal]
   $groupRage = $g_ahPicTrainArmySpell[$eSpellRage]&"#"&$g_ahTxtTrainArmySpellCount[$eSpellRage]&"#"&$g_ahLblTrainArmySpellLevel[$eSpellRage]
   $groupJump = $g_ahPicTrainArmySpell[$eSpellJump]&"#"&$g_ahTxtTrainArmySpellCount[$eSpellJump]&"#"&$g_ahLblTrainArmySpellLevel[$eSpellJump]
   $groupFreeze = $g_ahPicTrainArmySpell[$eSpellFreeze]&"#"&$g_ahTxtTrainArmySpellCount[$eSpellFreeze]&"#"&$g_ahLblTrainArmySpellLevel[$eSpellFreeze]
   $groupClone = $g_ahPicTrainArmySpell[$eSpellClone]&"#"&$g_ahTxtTrainArmySpellCount[$eSpellClone]&"#"&$g_ahLblTrainArmySpellLevel[$eSpellClone]
   $groupInvisibility = $g_ahPicTrainArmySpell[$eSpellInvisibility]&"#"&$g_ahTxtTrainArmySpellCount[$eSpellInvisibility]&"#"&$g_ahLblTrainArmySpellLevel[$eSpellInvisibility]


   ;Dark Spell
   $groupPoison = $g_ahPicTrainArmySpell[$eSpellPoison]&"#"&$g_ahTxtTrainArmySpellCount[$eSpellPoison]&"#"&$g_ahLblTrainArmySpellLevel[$eSpellPoison]
   $groupEarthquake = $g_ahPicTrainArmySpell[$eSpellEarthquake]&"#"&$g_ahTxtTrainArmySpellCount[$eSpellEarthquake]&"#"&$g_ahLblTrainArmySpellLevel[$eSpellEarthquake]
   $groupHaste = $g_ahPicTrainArmySpell[$eSpellHaste]&"#"&$g_ahTxtTrainArmySpellCount[$eSpellHaste]&"#"&$g_ahLblTrainArmySpellLevel[$eSpellHaste]
   $groupSkeleton = $g_ahPicTrainArmySpell[$eSpellSkeleton]&"#"&$g_ahTxtTrainArmySpellCount[$eSpellSkeleton]&"#"&$g_ahLblTrainArmySpellLevel[$eSpellSkeleton]
   $groupBat = $g_ahPicTrainArmySpell[$eSpellBat]&"#"&$g_ahTxtTrainArmySpellCount[$eSpellBat]&"#"&$g_ahLblTrainArmySpellLevel[$eSpellBat]

   $groupListSpells = $groupLightning&"#"&$groupHeal&"#"&$groupRage&"#"&$groupJump&"#"&$groupFreeze&"#"&$groupClone&"#"&$groupInvisibility&"#"&$groupPoison&"#"& _
					  $groupEarthquake&"#"&$groupHaste&"#"&$groupSkeleton&"#"&$groupBat

	; Sieges
	$groupWallWrecker = $g_ahPicTrainArmySiege[$eSiegeWallWrecker]&"#"&$g_ahTxtTrainArmySiegeCount[$eSiegeWallWrecker]&"#"&$g_ahLblTrainArmySiegeLevel[$eSiegeWallWrecker]
	$groupBattleBlimp = $g_ahPicTrainArmySiege[$eSiegeBattleBlimp]&"#"&$g_ahTxtTrainArmySiegeCount[$eSiegeBattleBlimp]&"#"&$g_ahLblTrainArmySiegeLevel[$eSiegeBattleBlimp]
	$groupStoneSlammer = $g_ahPicTrainArmySiege[$eSiegeStoneSlammer]&"#"&$g_ahTxtTrainArmySiegeCount[$eSiegeStoneSlammer]&"#"&$g_ahLblTrainArmySiegeLevel[$eSiegeStoneSlammer]
	$groupSiegeBarracks = $g_ahPicTrainArmySiege[$eSiegeBarracks]&"#"&$g_ahTxtTrainArmySiegeCount[$eSiegeBarracks]&"#"&$g_ahLblTrainArmySiegeLevel[$eSiegeBarracks]
	$groupLogLauncher = $g_ahPicTrainArmySiege[$eSiegeLogLauncher]&"#"&$g_ahTxtTrainArmySiegeCount[$eSiegeLogLauncher]&"#"&$g_ahLblTrainArmySiegeLevel[$eSiegeLogLauncher]
	$groupFlameFlinger = $g_ahPicTrainArmySiege[$eSiegeFlameFlinger]&"#"&$g_ahTxtTrainArmySiegeCount[$eSiegeFlameFlinger]&"#"&$g_ahLblTrainArmySiegeLevel[$eSiegeFlameFlinger]
	$groupListSieges = $groupWallWrecker&"#"&$groupBattleBlimp&"#"&$groupStoneSlammer&"#"&$groupSiegeBarracks&"#"&$groupFlameFlinger&"#"&$groupLogLauncher

   ;TH Level
   $g_aGroupListTHLevels = $g_ahPicTHLevels[4]&"#"&$g_ahPicTHLevels[5]&"#"&$g_ahPicTHLevels[6]&"#"&$g_ahPicTHLevels[7]&"#"&$g_ahPicTHLevels[8]&"#"& _
						$g_ahPicTHLevels[9]&"#"&$g_ahPicTHLevels[10]&"#"&$g_ahPicTHLevels[11]&"#"&$g_ahPicTHLevels[12]&"#"&$g_ahPicTHLevels[13]&"#"&$g_ahPicTHLevels[14]

   ;PicDBMaxTH
   $g_aGroupListPicDBMaxTH = $g_ahPicDBMaxTH[6]&"#"&$g_ahPicDBMaxTH[7]&"#"&$g_ahPicDBMaxTH[8]&"#"& _
						$g_ahPicDBMaxTH[9]&"#"&$g_ahPicDBMaxTH[10]&"#"&$g_ahPicDBMaxTH[11]&"#"&$g_ahPicDBMaxTH[12]&"#"&$g_ahPicDBMaxTH[13]&"#"&$g_ahPicDBMaxTH[14]

   ;PicABMaxTH
   $g_aGroupListPicABMaxTH = $g_ahPicABMaxTH[6]&"#"&$g_ahPicABMaxTH[7]&"#"&$g_ahPicABMaxTH[8]&"#"& _
						$g_ahPicABMaxTH[9]&"#"&$g_ahPicABMaxTH[10]&"#"&$g_ahPicABMaxTH[11]&"#"&$g_ahPicABMaxTH[12]&"#"&$g_ahPicABMaxTH[13]&"#"&$g_ahPicABMaxTH[14]

   ;PicBullyMaxTH
   $g_aGroupListPicBullyMaxTH = $g_ahPicBullyMaxTH[6]&"#"&$g_ahPicBullyMaxTH[7]&"#"&$g_ahPicBullyMaxTH[8]&"#"& _
						$g_ahPicBullyMaxTH[9]&"#"&$g_ahPicBullyMaxTH[10]&"#"&$g_ahPicBullyMaxTH[11]&"#"&$g_ahPicBullyMaxTH[12]&"#"&$g_ahPicBullyMaxTH[13]&"#"&$g_ahPicBullyMaxTH[14]

   ;League
   $g_aGroupLeague = $g_ahPicLeague[$eLeagueUnranked]&"#"&$g_ahPicLeague[$eLeagueBronze]&"#"&$g_ahPicLeague[$eLeagueSilver]&"#"&$g_ahPicLeague[$eLeagueGold] &"#"& _
				  $g_ahPicLeague[$eLeagueCrystal]&"#"&$g_ahPicLeague[$eLeagueMaster]&"#"&$g_ahPicLeague[$eLeagueChampion]&"#"&$g_ahPicLeague[$eLeagueTitan]&"#"& _
				  $g_ahPicLeague[$eLeagueLegend]

   ; Groups of controls
   Dim $aTabControlsVillage = [$g_hGUI_VILLAGE_TAB, $g_hGUI_VILLAGE_TAB_ITEM1, $g_hGUI_VILLAGE_TAB_ITEM2, $g_hGUI_VILLAGE_TAB_ITEM3, $g_hGUI_VILLAGE_TAB_ITEM4, $g_hGUI_VILLAGE_TAB_ITEM5]
   Dim $aTabControlsMisc = [$g_hGUI_MISC_TAB, $g_hGUI_MISC_TAB_ITEM1, $g_hGUI_MISC_TAB_ITEM2, $g_hGUI_MISC_TAB_ITEM3, $g_hGUI_MISC_TAB_ITEM4] 
   Dim $aTabControlsDonate = [$g_hGUI_DONATE_TAB, $g_hGUI_DONATE_TAB_ITEM1, $g_hGUI_DONATE_TAB_ITEM2, $g_hGUI_DONATE_TAB_ITEM3]
   Dim $aTabControlsUpgrade = [$g_hGUI_UPGRADE_TAB, $g_hGUI_UPGRADE_TAB_ITEM1, $g_hGUI_UPGRADE_TAB_ITEM2, $g_hGUI_UPGRADE_TAB_ITEM3, $g_hGUI_UPGRADE_TAB_ITEM4, $g_hGUI_UPGRADE_TAB_ITEM5]
   Dim $aTabControlsNotify = [$g_hGUI_NOTIFY_TAB, $g_hGUI_NOTIFY_TAB_ITEM2, $g_hGUI_NOTIFY_TAB_ITEM3] ; Discord - Team AIO Mod++
   Dim $aTabControlsAttack = [$g_hGUI_ATTACK_TAB, $g_hGUI_ATTACK_TAB_ITEM1, $g_hGUI_ATTACK_TAB_ITEM2, $g_hGUI_ATTACK_TAB_ITEM3]

   Dim $aTabControlsArmy = [$g_hGUI_TRAINARMY_TAB, $g_hGUI_TRAINARMY_TAB_ITEM1, $g_hGUI_TRAINARMY_TAB_ITEM2, $g_hGUI_TRAINARMY_TAB_ITEM3, $g_hGUI_TRAINARMY_TAB_ITEM4, $g_hGUI_TRAINARMY_ARMY_TAB, $g_hGUI_TRAINARMY_ARMY_TAB_ITEM1, $g_hGUI_TRAINARMY_ARMY_TAB_ITEM2, $g_hGUI_TRAINARMY_ORDER_TAB, $g_hGUI_TRAINARMY_ORDER_TAB_ITEM1, $g_hGUI_TRAINARMY_ORDER_TAB_ITEM2]
   Dim $aTabControlsSearch = [$g_hGUI_SEARCH_TAB, $g_hGUI_SEARCH_TAB_ITEM1, $g_hGUI_SEARCH_TAB_ITEM2, $g_hGUI_SEARCH_TAB_ITEM3, $g_hGUI_SEARCH_TAB_ITEM4]
   Dim $aTabControlsDeadbase = [$g_hGUI_DEADBASE_TAB, $g_hGUI_DEADBASE_TAB_ITEM1, $g_hGUI_DEADBASE_TAB_ITEM2, $g_hGUI_DEADBASE_TAB_ITEM3, $g_hGUI_DEADBASE_TAB_ITEM4]
   Dim $aTabControlsActivebase = [$g_hGUI_ACTIVEBASE_TAB, $g_hGUI_ACTIVEBASE_TAB_ITEM1, $g_hGUI_ACTIVEBASE_TAB_ITEM2, $g_hGUI_ACTIVEBASE_TAB_ITEM3]
   Dim $aTabControlsAttackOptions = [$g_hGUI_ATTACKOPTION_TAB, $g_hGUI_ATTACKOPTION_TAB_ITEM1, $g_hGUI_ATTACKOPTION_TAB_ITEM2, $g_hGUI_ATTACKOPTION_TAB_ITEM3,  $g_hGUI_ATTACKOPTION_TAB_ITEM4,  $g_hGUI_ATTACKOPTION_TAB_ITEM5]
   Dim $aTabControlsStrategies = [$g_hGUI_STRATEGIES_TAB, $g_hGUI_STRATEGIES_TAB_ITEM1, $g_hGUI_STRATEGIES_TAB_ITEM2]

   Dim $aTabControlsBot = [$g_hGUI_BOT_TAB, $g_hGUI_BOT_TAB_ITEM1, $g_hGUI_BOT_TAB_ITEM2, $g_hGUI_BOT_TAB_ITEM3, $g_hGUI_BOT_TAB_ITEM4, $g_hGUI_BOT_TAB_ITEM5]
   Dim $aTabControlsStats = [$g_hGUI_STATS_TAB, $g_hGUI_STATS_TAB_ITEM1, $g_hGUI_STATS_TAB_ITEM2, $g_hGUI_STATS_TAB_ITEM3, $g_hGUI_STATS_TAB_ITEM4, $g_hGUI_STATS_TAB_ITEM5]

   #Region AiO MOD++
   Dim $aTabControlsMOD = [$g_hGUI_MOD_TAB, $g_hGUI_MOD_TAB_ITEM1, $g_hGUI_MOD_TAB_ITEM2, $g_hGUI_MOD_TAB_ITEM3, $g_hGUI_MOD_TAB_ITEM4, $g_hGUI_MOD_TAB_ITEM5, $g_hGUI_MOD_TAB_ITEM6];, $g_hGUI_MOD_TAB_ITEM7]
   ; Dim $aTabControlsBot = [$g_hGUI_BOT_TAB, $g_hGUI_BOT_TAB_ITEM1, $g_hGUI_BOT_TAB_ITEM2, $g_hGUI_BOT_TAB_ITEM3, $g_hGUI_BOT_TAB_ITEM4, $g_hGUI_BOT_TAB_ITEM5]
   Dim $aTabControlsSwitchOpt = [$g_hGUI_SWITCH_OPTIONS_TAB, $g_hGUI_SWITCH_OPTIONS_TAB_ITEM1, $g_hGUI_SWITCH_OPTIONS_TAB_ITEM2, $g_hGUI_SWITCH_OPTIONS_TAB_ITEM3]
   Dim $aTabControlsStats = [$g_hGUI_STATS_TAB, $g_hGUI_STATS_TAB_ITEM1, $g_hGUI_STATS_TAB_ITEM2, $g_hGUI_STATS_TAB_ITEM3, $g_hGUI_STATS_TAB_ITEM4, $g_hGUI_STATS_TAB_ITEM5]
   Dim $aTabControlsBuilderBase = [$g_hGUI_BUILDER_BASE_TAB, $g_hGUI_BUILDER_BASE_TAB_ITEM1, $g_hGUI_BUILDER_BASE_TAB_ITEM2, $g_hGUI_BUILDER_BASE_TAB_ITEM3]
   #EndRegion

	; always enabled / unchanged controls during enabling/disabling all GUI controls function
	$oAlwaysEnabledControls($g_hCmbStatusMode) = 1 ; Only Farm - Team AIO Mod++
	;$oAlwaysEnabledControls($g_hChkUpdatingWhenMinimized) = 1
	$oAlwaysEnabledControls($g_hChkHideWhenMinimized) = 1
	$oAlwaysEnabledControls($g_hChkDebugSetlog) = 1
	$oAlwaysEnabledControls($g_hChkDebugAndroid) = 1
	$oAlwaysEnabledControls($g_hChkDebugClick) = 1
	$oAlwaysEnabledControls($g_hChkDebugFunc) = 1
	$oAlwaysEnabledControls($g_hChkDebugDisableZoomout) = 1
	$oAlwaysEnabledControls($g_hChkDebugDisableVillageCentering) = 1
	$oAlwaysEnabledControls($g_hChkDebugDeadbaseImage) = 1
	$oAlwaysEnabledControls($g_hChkDebugOCR) = 1
	$oAlwaysEnabledControls($g_hChkDebugImageSave) = 1
	$oAlwaysEnabledControls($g_hChkdebugBuildingPos) = 1
	$oAlwaysEnabledControls($g_hChkdebugTrain) = 1
	$oAlwaysEnabledControls($g_hChkDebugOCRDonate) = 1
	$oAlwaysEnabledControls($g_hChkDebugSmartZap) = 1
	$oAlwaysEnabledControls($g_hBtnTestTrain) = 1
	$oAlwaysEnabledControls($g_hBtnTestDonateCC) = 1
	$oAlwaysEnabledControls($g_hBtnTestRequestCC) = 1
	$oAlwaysEnabledControls($g_hBtnTestSendText) = 1
	$oAlwaysEnabledControls($g_hBtnTestAttackBar) = 1
	$oAlwaysEnabledControls($g_hBtnTestClickDrag) = 1
	$oAlwaysEnabledControls($g_hBtnTestImage) = 1
	$oAlwaysEnabledControls($g_hBtnTestVillageSize) = 1
	$oAlwaysEnabledControls($g_hBtnTestDeadBase) = 1
	$oAlwaysEnabledControls($g_hbtnExecuteCapture) = 1
	$oAlwaysEnabledControls($g_hBtnTestTHimgloc) = 1
	$oAlwaysEnabledControls($g_hBtnTestQuickTrainsimgloc) = 1
	$oAlwaysEnabledControls($g_hChkdebugAttackCSV) = 1
	$oAlwaysEnabledControls($g_hChkMakeIMGCSV) = 1
	$oAlwaysEnabledControls($g_hBtnTestAttackCSV) = 1
	$oAlwaysEnabledControls($g_hBtnTestBuildingLocation) = 1
	$oAlwaysEnabledControls($g_hBtnRunFunction) = 1
	$oAlwaysEnabledControls($g_hTxtRunFunction) = 1
	$oAlwaysEnabledControls($g_hBtnTestCleanYard) = 1
	$oAlwaysEnabledControls($g_hLblSmartLightningUsed) = 1
	$oAlwaysEnabledControls($g_hLblSmartZap) = 1
	$oAlwaysEnabledControls($g_hLblSmartEarthQuakeUsed) = 1
	$oAlwaysEnabledControls($g_hBtnTestConfigSave) = 1
	$oAlwaysEnabledControls($g_hBtnTestConfigRead) = 1
	$oAlwaysEnabledControls($g_hBtnTestConfigApply) = 1
	$oAlwaysEnabledControls($g_hBtnTestWeakBase) = 1
	$oAlwaysEnabledControls($g_hBtnConsoleWindow) = 1

	$oAlwaysEnabledControls($g_hBtnAndroidAdbShell) = 1
	$oAlwaysEnabledControls($g_hBtnAndroidHome) = 1
	$oAlwaysEnabledControls($g_hBtnAndroidBack) = 1
	$oAlwaysEnabledControls($g_hBtnPullSharedPrefs) = 1

	$oAlwaysEnabledControls($g_hBtnMakeScreenshot) = 1
	$oAlwaysEnabledControls($g_hDivider) = 1
	
	$oAlwaysEnabledControls($g_hTabMain) = 1
	$oAlwaysEnabledControls($g_hTabLog) = 1
	$oAlwaysEnabledControls($g_hTabVillage) = 1
	$oAlwaysEnabledControls($g_hTabAttack) = 1
	$oAlwaysEnabledControls($g_hTabBot) = 1
	$oAlwaysEnabledControls($g_hTabAbout) = 1
	For $i in $aTabControlsVillage
		$oAlwaysEnabledControls($i) = 1
	Next
	For $i in $aTabControlsMisc
		$oAlwaysEnabledControls($i) = 1
	Next
	For $i in $aTabControlsDonate
		$oAlwaysEnabledControls($i) = 1
	Next
	For $i in $aTabControlsUpgrade
		$oAlwaysEnabledControls($i) = 1
	Next
	For $i in $aTabControlsNotify
		$oAlwaysEnabledControls($i) = 1
	Next
	For $i in $aTabControlsAttack
		$oAlwaysEnabledControls($i) = 1
	Next
	For $i in $aTabControlsArmy
		$oAlwaysEnabledControls($i) = 1
	Next
	For $i in $aTabControlsSearch
		$oAlwaysEnabledControls($i) = 1
	Next
	For $i in $aTabControlsDeadbase
		$oAlwaysEnabledControls($i) = 1
	Next
	For $i in $aTabControlsActivebase
		$oAlwaysEnabledControls($i) = 1
	Next
	For $i in $aTabControlsAttackOptions
		$oAlwaysEnabledControls($i) = 1
	Next
	For $i in $aTabControlsStrategies
		$oAlwaysEnabledControls($i) = 1
	Next
	For $i in $aTabControlsStats
		$oAlwaysEnabledControls($i) = 1
	Next
	
	#Region AiO MOD++
	For $i in $aTabControlsMOD
		$oAlwaysEnabledControls($i) = 1
	Next
	
	For $i in $aTabControlsBot
		$oAlwaysEnabledControls($i) = 1
	Next
	
	For $i in $aTabControlsSwitchOpt
		$oAlwaysEnabledControls($i) = 1
	Next
	
	For $i in $aTabControlsBuilderBase 
		$oAlwaysEnabledControls($i) = 1
	Next
	
	; AiO MOD++
	$oAlwaysEnabledControls($g_hTxtClanGamesLog) = 1
	#EndRegion
	
EndFunc