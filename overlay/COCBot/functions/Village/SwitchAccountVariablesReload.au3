; #FUNCTION# ====================================================================================================================
; Name ..........: SwitchAccountVariablesReload
; Description ...: This file contains the Sequence that runs all MBR Bot
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Demen
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func SwitchAccountVariablesReload($sType = "Load", $iAccount = $g_iCurAccount)

	; Empty arrays
	Local $aiZero[$g_eTotalAcc] = [0, 0, 0, 0, 0, 0, 0, 0], $aiTrue[$g_eTotalAcc] = [1, 1, 1, 1, 1, 1, 1, 1], $aiMinus[$g_eTotalAcc] = [-1, -1, -1, -1, -1, -1, -1, -1]
	Local $aiZero83[$g_eTotalAcc][3] = [[0, 0, 0], [0, 0, 0], [0, 0, 0], [0, 0, 0], [0, 0, 0], [0, 0, 0], [0, 0, 0], [0, 0, 0]]
	Local $aiZero84[$g_eTotalAcc][4] = [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]]
	Local $asEmpty[$g_eTotalAcc] = ["", "", "", "", "", "", "", ""]
	Local $aiZeroTroop[$eTroopCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
	Local $aiZeroSpell[$eSpellCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

	Local $aiZeroCG[$eSpellCount]

	; Reset - Custom Acc - Team AIO Mod++
	Static $abIsCaravanOnR[$g_eTotalAcc]	; Custom GC - Team AIO Mod++
	
	For $i = 0 To $g_eTotalAcc - 1
		$aiZero[$i] = 0
		$aiTrue[$i] = 1
		$aiMinus[$i] = -1
		
		$aiZero83[$i][0] = 0
		$aiZero83[$i][1] = 0
		$aiZero83[$i][2] = 0
		
		$aiZero84[$i][0] = 0
		$aiZero84[$i][1] = 0
		$aiZero84[$i][2] = 0
		$aiZero84[$i][3] = 0
		
		$abIsCaravanOnR[$i] = "Undefined"	; Custom GC - Team AIO Mod++
	Next
	
	; Custom GC - Team AIO Mod++
	Static $abIsCaravanOn = $abIsCaravanOnR

	; FirstRun
	Static $abFirstStart = $aiTrue
	Static $aiFirstRun = $aiTrue
	
	; Bottom & Multi-Stats
	Static $aiSkippedVillageCount = $aiZero
	Static $aiAttackedCount = $aiZero

	; Gain Stats
	Static $aiStatsTotalGain = $aiZero84, $aiStatsStartedWith = $aiZero84, $aiStatsLastAttack = $aiZero84, $aiStatsBonusLast = $aiZero84

	; Misc Stats
	Static $aiNbrOfOoS = $aiZero
	Static $aiDroppedTrophyCount = $aiZero
	Static $aiSearchCost = $aiZero, $aiTrainCostElixir = $aiZero, $aiTrainCostDElixir = $aiZero, $aiTrainCostGold = $aiZero ; search and train troops cost
	Static $aiGoldFromMines = $aiZero, $aiElixirFromCollectors = $aiZero, $aiDElixirFromDrills = $aiZero ; number of resources gain by collecting mines, collectors, drills
	Static $aiCostGoldWall = $aiZero, $aiCostElixirWall = $aiZero, $aiCostGoldBuilding = $aiZero, $aiCostElixirBuilding = $aiZero, $aiCostDElixirHero = $aiZero ; wall, building and hero upgrade costs
	Static $aiNbrOfWallsUppedGold = $aiZero, $aiNbrOfWallsUppedElixir = $aiZero, $aiNbrOfBuildingsUppedGold = $aiZero, $aiNbrOfBuildingsUppedElixir = $aiZero, $aiNbrOfHeroesUpped = $aiZero ; number of wall, building, hero upgrades with gold, elixir, delixir
	Static $aiNbrOfWallsUpped = $aiZero

	; Attack Stats
	Static $aiAttackedVillageCount = $aiZero83 ; number of attack villages for DB, LB, TB
	Static $aiTotalGoldGain = $aiZero83, $aiTotalElixirGain = $aiZero83, $aiTotalDarkGain = $aiZero83, $aiTotalTrophyGain = $aiZero83 ; total resource gains for DB, LB, TB
	Static $aiNbrOfDetectedMines = $aiZero83, $aiNbrOfDetectedCollectors = $aiZero83, $aiNbrOfDetectedDrills = $aiZero83 ; number of mines, collectors, drills detected for DB, LB, TB
	Static $aiSmartZapGain = $aiZero, $aiNumEQSpellsUsed = $aiZero, $aiNumLSpellsUsed = $aiZero ; smart zap

	; Builder time and count
	Static $asNextBuilderReadyTime = $asEmpty
	Static $aiFreeBuilderCount = $aiZero, $aiTotalBuilderCount = $aiZero

	; Lab time
	Static $asLabUpgradeTime = $asEmpty, $aiLabStatus = $aiZero, $aiLabElixirCost = $aiZero, $aiLabDElixirCost = $aiZero
	Static $asStarLabUpgradeTime = $asEmpty

	; Hero State
	Static $aiHeroAvailable = $aiZero
	Static $aiHeroUpgradingBit = $aiZero
	Static $aiHeroUpgrading = $aiZero83

	; QuickTrain comp
	Static $aaArmyQuickTroops[$g_eTotalAcc] = [$aiZeroTroop, $aiZeroTroop, $aiZeroTroop, $aiZeroTroop, $aiZeroTroop, $aiZeroTroop, $aiZeroTroop, $aiZeroTroop]
	Static $aaArmyQuickSpells[$g_eTotalAcc] = [$aiZeroSpell, $aiZeroSpell, $aiZeroSpell, $aiZeroSpell, $aiZeroSpell, $aiZeroSpell, $aiZeroSpell, $aiZeroSpell]
	; Reset - Custom Acc - Team AIO Mod++
	For $i = 0 To $g_eTotalAcc - 1
		$aaArmyQuickTroops[$i] = $aiZeroTroop
		$aaArmyQuickSpells[$i] = $aiZeroSpell
	Next
	Static $aiTotalQuickTroops = $aiZero
	Static $aiTotalQuickSpells = $aiZero
	Static $abQuickArmyMixed = $aiZero

	; Other global status
	
	#dude
	Static $abNotNeedAllTime0 = $aiTrue
	Static $abNotNeedAllTime1 = $aiTrue

	Static $aiCommandStop = $aiMinus
	Static $aiAllBarracksUpgd = $aiZero

	Static $abFullStorage = $aiZero84
	Static $aiBuilderBoostDiscount = $aiZero
	
	
	; First time switch account
	Switch $sType
		Case "Reset"
			$abFirstStart = $aiTrue
			$aiFirstRun = $aiTrue
			$abIsCaravanOn = $abIsCaravanOnR ; Custom GC - Team AIO Mod++
			
			$g_asTrainTimeFinish = $asEmpty
			For $i = 0 To $g_iTotalAcc
				GUICtrlSetData($g_ahLblTroopTime[$i], "")
			Next
			$g_ahTimerSinceSwitched = $aiZero
			$g_ahTimerSinceSwitched[$iAccount] = $g_hTimerSinceStarted

			; Multi-Stats
			$aiSkippedVillageCount = $aiZero
			$aiAttackedCount = $aiZero

			; Gain Stats
			$aiStatsTotalGain = $aiZero84
			$aiStatsStartedWith = $aiZero84
			$aiStatsLastAttack = $aiZero84
			$aiStatsBonusLast = $aiZero84

			; Misc Stats
			$aiNbrOfOoS = $aiZero
			$aiDroppedTrophyCount = $aiZero
			$aiSearchCost = $aiZero
			$aiTrainCostElixir = $aiZero
			$aiTrainCostDElixir = $aiZero
			$aiTrainCostGold = $aiZero
			$aiGoldFromMines = $aiZero
			$aiElixirFromCollectors = $aiZero
			$aiDElixirFromDrills = $aiZero

			$aiCostGoldWall = $aiZero
			$aiCostElixirWall = $aiZero
			$aiCostGoldBuilding = $aiZero
			$aiCostElixirBuilding = $aiZero
			$aiCostDElixirHero = $aiZero
			$aiNbrOfWallsUppedGold = $aiZero
			$aiNbrOfWallsUppedElixir = $aiZero
			$aiNbrOfBuildingsUppedGold = $aiZero
			$aiNbrOfBuildingsUppedElixir = $aiZero
			$aiNbrOfHeroesUpped = $aiZero
			$aiNbrOfWallsUpped = $aiZero

			; Attack Stats
			$aiAttackedVillageCount = $aiZero83
			$aiTotalGoldGain = $aiZero83
			$aiTotalElixirGain = $aiZero83
			$aiTotalDarkGain = $aiZero83
			$aiTotalTrophyGain = $aiZero83
			$aiNbrOfDetectedMines = $aiZero83
			$aiNbrOfDetectedCollectors = $aiZero83
			$aiNbrOfDetectedDrills = $aiZero83
			$aiSmartZapGain = $aiZero
			$aiNumEQSpellsUsed = $aiZero
			$aiNumLSpellsUsed = $aiZero

			; Builder time and count
			$asNextBuilderReadyTime = $asEmpty
			$aiFreeBuilderCount = $aiZero
			$aiTotalBuilderCount = $aiZero
			; Lab time
			$asLabUpgradeTime = $asEmpty
			$aiLabElixirCost = $aiZero
			$aiLabDElixirCost = $aiZero
			$aiLabStatus = $aiZero
			$asStarLabUpgradeTime = $asEmpty

			; Hero State
			$aiHeroAvailable = $aiZero
			$aiHeroUpgradingBit = $aiZero
			$aiHeroUpgrading = $aiZero83

			; QuickTrain comp
			For $i = 0 To $g_eTotalAcc - 1
				$aaArmyQuickTroops[$i] = $aiZeroTroop
				$aaArmyQuickSpells[$i] = $aiZeroSpell
			Next
			$aiTotalQuickTroops = $aiZero
			$aiTotalQuickSpells = $aiZero
			$abQuickArmyMixed = $aiZero

			; Other global status
			$aiCommandStop = $aiMinus
			$aiAllBarracksUpgd = $aiZero
			$abFullStorage = $aiZero84
			$aiBuilderBoostDiscount = $aiZero
			$abNotNeedAllTime0 = $aiTrue
			$abNotNeedAllTime1 = $aiTrue

		Case "Save"
			$abFirstStart[$iAccount] = $g_bFirstStart
			$aiFirstRun[$iAccount] = $g_iFirstRun
			$abIsCaravanOn[$iAccount] = $g_bIsCaravanOn ; Custom GC - Team AIO Mod++
			
			; Multi-Stats
			$aiSkippedVillageCount[$iAccount] = $g_iSkippedVillageCount
			$aiAttackedCount[$iAccount] = $g_aiAttackedCount

			; Gain Stats
			For $i = 0 To 3
				$aiStatsTotalGain[$iAccount][$i] = $g_iStatsTotalGain[$i]
				$aiStatsStartedWith[$iAccount][$i] = $g_iStatsStartedWith[$i]
				$aiStatsLastAttack[$iAccount][$i] = $g_iStatsLastAttack[$i]
				$aiStatsBonusLast[$iAccount][$i] = $g_iStatsBonusLast[$i]
			Next

			; Misc Stats
			$aiNbrOfOoS[$iAccount] = $g_iNbrOfOoS
			$aiDroppedTrophyCount[$iAccount] = $g_iDroppedTrophyCount
			$aiSearchCost[$iAccount] = $g_iSearchCost
			$aiTrainCostElixir[$iAccount] = $g_iTrainCostElixir
			$aiTrainCostDElixir[$iAccount] = $g_iTrainCostDElixir
			$aiTrainCostGold[$iAccount] = $g_iTrainCostGold
			$aiGoldFromMines[$iAccount] = $g_iGoldFromMines
			$aiElixirFromCollectors[$iAccount] = $g_iElixirFromCollectors
			$aiDElixirFromDrills[$iAccount] = $g_iDElixirFromDrills

			$aiCostGoldWall[$iAccount] = $g_iCostGoldWall
			$aiCostElixirWall[$iAccount] = $g_iCostElixirWall
			$aiCostGoldBuilding[$iAccount] = $g_iCostGoldBuilding
			$aiCostElixirBuilding[$iAccount] = $g_iCostElixirBuilding
			$aiCostDElixirHero[$iAccount] = $g_iCostDElixirHero
			$aiNbrOfWallsUppedGold[$iAccount] = $g_iNbrOfWallsUppedGold
			$aiNbrOfWallsUppedElixir[$iAccount] = $g_iNbrOfWallsUppedElixir
			$aiNbrOfBuildingsUppedGold[$iAccount] = $g_iNbrOfBuildingsUppedGold
			$aiNbrOfBuildingsUppedElixir[$iAccount] = $g_iNbrOfBuildingsUppedElixir
			$aiNbrOfHeroesUpped[$iAccount] = $g_iNbrOfHeroesUpped
			$aiNbrOfWallsUpped[$iAccount] = $g_iNbrOfWallsUpped

			; Attack Stats
			For $i = 0 To $g_iModeCount - 1
				$aiAttackedVillageCount[$iAccount][$i] = $g_aiAttackedVillageCount[$i]
				$aiTotalGoldGain[$iAccount][$i] = $g_aiTotalGoldGain[$i]
				$aiTotalElixirGain[$iAccount][$i] = $g_aiTotalElixirGain[$i]
				$aiTotalDarkGain[$iAccount][$i] = $g_aiTotalDarkGain[$i]
				$aiTotalTrophyGain[$iAccount][$i] = $g_aiTotalTrophyGain[$i]
				$aiNbrOfDetectedMines[$iAccount][$i] = $g_aiNbrOfDetectedMines[$i]
				$aiNbrOfDetectedCollectors[$iAccount][$i] = $g_aiNbrOfDetectedCollectors[$i]
				$aiNbrOfDetectedDrills[$iAccount][$i] = $g_aiNbrOfDetectedDrills[$i]
			Next
			$aiSmartZapGain[$iAccount] = $g_iSmartZapGain
			$aiNumEQSpellsUsed[$iAccount] = $g_iNumEQSpellsUsed
			$aiNumLSpellsUsed[$iAccount] = $g_iNumLSpellsUsed

			; Builder time and count
			$aiFreeBuilderCount[$iAccount] = $g_iFreeBuilderCount
			$aiTotalBuilderCount[$iAccount] = $g_iTotalBuilderCount
			; Lab time
			$asLabUpgradeTime[$iAccount] = $g_sLabUpgradeTime
			$aiLabElixirCost[$iAccount] = $g_iLaboratoryElixirCost
			$aiLabDElixirCost[$iAccount] = $g_iLaboratoryDElixirCost
			If GUICtrlGetState($g_hPicLabGreen) = $GUI_ENABLE + $GUI_SHOW Then
				$aiLabStatus[$iAccount] = 1
			ElseIf GUICtrlGetState($g_hPicLabRed) = $GUI_ENABLE + $GUI_SHOW Then
				$aiLabStatus[$iAccount] = 2
			Else
				$aiLabStatus[$iAccount] = 0
			EndIf
			$asStarLabUpgradeTime[$iAccount] = $g_sStarLabUpgradeTime

			; Hero State
			$aiHeroAvailable[$iAccount] = $g_iHeroAvailable
			$aiHeroUpgradingBit[$iAccount] = $g_iHeroUpgradingBit
			For $i = 0 To 2
				$aiHeroUpgrading[$iAccount][$i] = $g_iHeroUpgrading[$i]
			Next

			; QuickTrain comp
			$aaArmyQuickTroops[$iAccount] = $g_aiArmyQuickTroops
			$aaArmyQuickSpells[$iAccount] = $g_aiArmyQuickSpells
			$aiTotalQuickTroops[$iAccount] = $g_iTotalQuickTroops
			$aiTotalQuickSpells[$iAccount] = $g_iTotalQuickSpells
			$abQuickArmyMixed[$iAccount] = $g_bQuickArmyMixed

			; Other global status
			$aiCommandStop[$iAccount] = $g_iCommandStop
			$aiAllBarracksUpgd[$iAccount] = $g_bAllBarracksUpgd

			For $i = 0 To 3
				$abFullStorage[$iAccount][$i] = $g_abFullStorage[$i]
			Next
			$aiBuilderBoostDiscount[$iAccount] = $g_iBuilderBoostDiscount
			$abNotNeedAllTime0[$iAccount] = $g_abNotNeedAllTime[0]
			$abNotNeedAllTime1[$iAccount] = $g_abNotNeedAllTime[1]

		Case "Load"
			$g_bFirstStart = $abFirstStart[$iAccount]
			$g_iFirstRun = $aiFirstRun[$iAccount]
			$g_bIsCaravanOn = $abIsCaravanOn[$iAccount] ; Custom GC - Team AIO Mod++

			; Multi-Stats
			$g_iSkippedVillageCount = $aiSkippedVillageCount[$iAccount]
			$g_aiAttackedCount = $aiAttackedCount[$iAccount]

			; Gain Stats
			For $i = 0 To 3
				$g_iStatsTotalGain[$i] = $aiStatsTotalGain[$iAccount][$i]
				$g_iStatsStartedWith[$i] = $aiStatsStartedWith[$iAccount][$i]
				$g_iStatsLastAttack[$i] = $aiStatsLastAttack[$iAccount][$i]
				$g_iStatsBonusLast[$i] = $aiStatsBonusLast[$iAccount][$i]
			Next

			; Misc Stats
			$g_iNbrOfOoS = $aiNbrOfOoS[$iAccount]
			$g_iDroppedTrophyCount = $aiDroppedTrophyCount[$iAccount]
			$g_iSearchCost = $aiSearchCost[$iAccount]
			$g_iTrainCostElixir = $aiTrainCostElixir[$iAccount]
			$g_iTrainCostDElixir = $aiTrainCostDElixir[$iAccount]
			$g_iTrainCostGold = $aiTrainCostGold[$iAccount]
			$g_iGoldFromMines = $aiGoldFromMines[$iAccount]
			$g_iElixirFromCollectors = $aiElixirFromCollectors[$iAccount]
			$g_iDElixirFromDrills = $aiDElixirFromDrills[$iAccount]

			$g_iCostGoldWall = $aiCostGoldWall[$iAccount]
			$g_iCostElixirWall = $aiCostElixirWall[$iAccount]
			$g_iCostGoldBuilding = $aiCostGoldBuilding[$iAccount]
			$g_iCostElixirBuilding = $aiCostElixirBuilding[$iAccount]
			$g_iCostDElixirHero = $aiCostDElixirHero[$iAccount]
			$g_iNbrOfWallsUppedGold = $aiNbrOfWallsUppedGold[$iAccount]
			$g_iNbrOfWallsUppedElixir = $aiNbrOfWallsUppedElixir[$iAccount]
			$g_iNbrOfBuildingsUppedGold = $aiNbrOfBuildingsUppedGold[$iAccount]
			$g_iNbrOfBuildingsUppedElixir = $aiNbrOfBuildingsUppedElixir[$iAccount]
			$g_iNbrOfHeroesUpped = $aiNbrOfHeroesUpped[$iAccount]
			$g_iNbrOfWallsUpped = $aiNbrOfWallsUpped[$iAccount]

			; Attack Stats
			For $i = 0 To $g_iModeCount - 1
				$g_aiAttackedVillageCount[$i] = $aiAttackedVillageCount[$iAccount][$i]
				$g_aiTotalGoldGain[$i] = $aiTotalGoldGain[$iAccount][$i]
				$g_aiTotalElixirGain[$i] = $aiTotalElixirGain[$iAccount][$i]
				$g_aiTotalDarkGain[$i] = $aiTotalDarkGain[$iAccount][$i]
				$g_aiTotalTrophyGain[$i] = $aiTotalTrophyGain[$iAccount][$i]
				$g_aiNbrOfDetectedMines[$i] = $aiNbrOfDetectedMines[$iAccount][$i]
				$g_aiNbrOfDetectedCollectors[$i] = $aiNbrOfDetectedCollectors[$iAccount][$i]
				$g_aiNbrOfDetectedDrills[$i] = $aiNbrOfDetectedDrills[$iAccount][$i]
			Next
			$g_iSmartZapGain = $aiSmartZapGain[$iAccount]
			$g_iNumEQSpellsUsed = $aiNumEQSpellsUsed[$iAccount]
			$g_iNumLSpellsUsed = $aiNumLSpellsUsed[$iAccount]

			; Builder time and count
			$g_iFreeBuilderCount = $aiFreeBuilderCount[$iAccount]
			$g_iTotalBuilderCount = $aiTotalBuilderCount[$iAccount]
			; Lab time
			$g_sLabUpgradeTime = $asLabUpgradeTime[$iAccount]
			GUICtrlSetData($g_hLbLLabTime, "00:00:00")
			GUICtrlSetColor($g_hLbLLabTime, $COLOR_BLACK)
			$g_iLaboratoryElixirCost = $aiLabElixirCost[$iAccount]
			$g_iLaboratoryDElixirCost = $aiLabDElixirCost[$iAccount]
			Local $Counter = 0
			For $i = $g_hPicLabGray To $g_hPicLabRed
				GUICtrlSetState($i, $GUI_HIDE)
				If $aiLabStatus[$iAccount] = $Counter Then GUICtrlSetState($i, $GUI_SHOW)
				$Counter += 1
			Next
			$g_sStarLabUpgradeTime = $asStarLabUpgradeTime[$iAccount]

			; Hero State
			$g_iHeroAvailable = $aiHeroAvailable[$iAccount]
			$g_iHeroUpgradingBit = $aiHeroUpgradingBit[$iAccount]
			For $i = 0 To 2
				$g_iHeroUpgrading[$i] = $aiHeroUpgrading[$iAccount][$i]
			Next

			; QuickTrain comp
			$g_aiArmyQuickTroops = $aaArmyQuickTroops[$iAccount]
			$g_aiArmyQuickSpells = $aaArmyQuickSpells[$iAccount]
			$g_iTotalQuickTroops = $aiTotalQuickTroops[$iAccount]
			$g_iTotalQuickSpells = $aiTotalQuickSpells[$iAccount]
			$g_bQuickArmyMixed = $abQuickArmyMixed[$iAccount]

			; Other global status
			$g_iCommandStop = $aiCommandStop[$iAccount]
			$g_bAllBarracksUpgd = $aiAllBarracksUpgd[$iAccount]
			For $i = 0 To 3
				$g_abFullStorage[$i] = $abFullStorage[$iAccount][$i]
			Next
			$g_iBuilderBoostDiscount = $aiBuilderBoostDiscount[$iAccount]
			$g_abNotNeedAllTime[0] = $abNotNeedAllTime0[$iAccount]
			$g_abNotNeedAllTime[1] = $abNotNeedAllTime1[$iAccount]

			ResetVariables("donated") ; reset for new account
			$g_aiAttackedCountSwitch[$iAccount] = $aiAttackedCount[$iAccount]

			; Reset the log
			$g_hLogFile = 0

		Case "UpdateStats"
			For $i = 0 To 3
				GUICtrlSetData($g_ahLblStatsStartedWith[$i], _NumberFormat($g_iStatsStartedWith[$i], True))
				$aiStatsTotalGain[$iAccount][$i] = $g_iStatsTotalGain[$i]
			Next
			For $i = 0 To $g_iTotalAcc
				GUICtrlSetData($g_ahLblHourlyStatsGoldAcc[$i], _NumberFormat(Round($aiStatsTotalGain[$i][$eLootGold] / (Int(__TimerDiff($g_hTimerSinceStarted) + $g_iTimePassed)) * 3600)) & "k / h")
				GUICtrlSetData($g_ahLblHourlyStatsElixirAcc[$i], _NumberFormat(Round($aiStatsTotalGain[$i][$eLootElixir] / (Int(__TimerDiff($g_hTimerSinceStarted) + $g_iTimePassed)) * 3600)) & "k / h")
				GUICtrlSetData($g_ahLblHourlyStatsDarkAcc[$i], _NumberFormat(Round($aiStatsTotalGain[$i][$eLootDarkElixir] / (Int(__TimerDiff($g_hTimerSinceStarted) + $g_iTimePassed)) * 3600 * 1000)) & " / h")
			Next

		Case "SetTime"
			Static $DisplayLoop = 1
			Local $day = 0, $hour = 0, $min = 0, $sec = 0

			; Clock of current account
			_TicksToTime(Int(__TimerDiff($g_ahTimerSinceSwitched[$iAccount]) + $g_aiRunTime[$iAccount]), $hour, $min, $sec)
			GUICtrlSetData($g_ahLblResultRuntimeNowAcc[$iAccount], StringFormat("%02i:%02i:%02i", $hour, $min, $sec))

			; Army time, Builder time, Lab time
			For $i = 0 To $g_iTotalAcc
				; Army time of all accounts
				If _DateIsValid($g_asTrainTimeFinish[$i]) Then
					Local $iTime = _DateDiff("s", _NowCalc(), $g_asTrainTimeFinish[$i]) * 1000
					_TicksToTime(Abs($iTime), $hour, $min, $sec)
					GUICtrlSetData($g_ahLblTroopTime[$i], ($iTime < 0 ? "-" : "") & StringFormat("%02i:%02i", $min, $sec))
					Local $SetColor = $COLOR_BLACK
					If $i = $iAccount Then
						$SetColor = $COLOR_GREEN
					ElseIf $iTime < 0 Then
						$SetColor = $COLOR_RED
					EndIf
					GUICtrlSetColor($g_ahLblTroopTime[$i], $SetColor)
				EndIf

				; Builder time of all account
				If IsInt($DisplayLoop / 5) Then
					If _DateIsValid($asNextBuilderReadyTime[$i]) Then
						_TicksToDay(Int(_DateDiff("s", _NowCalc(), $asNextBuilderReadyTime[$i]) * 1000), $day, $hour, $min, $sec)
						Local $sBuilderTime = $day > 0 ? StringFormat("%2ud %02i:%02i", $day, $hour, $min, $sec) : ($hour > 0 ? StringFormat("%02i:%02i:%02i", $hour, $min, $sec) : StringFormat("%02i:%02i", $min, $sec))

						If Not IsInt($DisplayLoop / 10) Then
							GUICtrlSetData($g_ahLblResultBuilderNowAcc[$i], $aiFreeBuilderCount[$i] & "/" & $aiTotalBuilderCount[$i])
							GUICtrlSetColor($g_ahLblResultBuilderNowAcc[$i], $COLOR_BLACK)
						Else
							GUICtrlSetData($g_ahLblResultBuilderNowAcc[$i], $sBuilderTime)
							GUICtrlSetColor($g_ahLblResultBuilderNowAcc[$i], $aiFreeBuilderCount[$i] > 0 ? $COLOR_GREEN : $COLOR_BLACK)
						EndIf
					EndIf
				EndIf

				; Lab time of all account
				If _DateIsValid($asLabUpgradeTime[$i]) Then
					Local $iLabTime = _DateDiff("s", _NowCalc(), $asLabUpgradeTime[$i]) * 1000
					If $iLabTime > 0 Then
						_TicksToDay($iLabTime, $day, $hour, $min, $sec)
						GUICtrlSetData($g_ahLblLabTime[$i], $day > 0 ? StringFormat("%2ud %02i:%02i:%02i", $day, $hour, $min, $sec) : ($hour > 0 ? StringFormat("%02i:%02i:%02i", $hour, $min, $sec) : StringFormat("%02i:%02i", $min, $sec)))
						Local $SetColor = $COLOR_BLACK
						If $i = $g_iCurAccount Then $SetColor = $COLOR_GREEN
						GUICtrlSetColor($g_ahLblLabTime[$i], $day > 0 ? $SetColor : $COLOR_ACTION)
					Else
						GUICtrlSetData($g_ahLblLabTime[$i], "00:00:00")
						GUICtrlSetColor($g_ahLblLabTime[$i], $COLOR_BLACK)
						$asLabUpgradeTime[$i] = ""
					EndIf
				EndIf
			Next
			$DisplayLoop += 1
			If $DisplayLoop > 10 Then $DisplayLoop = 1

		Case "$g_iCommandStop"
			Return $aiCommandStop[$iAccount]

	EndSwitch

EndFunc   ;==>ResetSwitchAccVariable
