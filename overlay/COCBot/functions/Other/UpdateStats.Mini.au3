; #FUNCTION# ====================================================================================================================
; Name ..........: UpdateStats
; Description ...: This function will update the statistics in the GUI.
; Syntax ........: UpdateStats()
; Parameters ....: None
; Return values .: None
; Author ........: kaganus (06-2015)
; Modified ......: CodeSlinger69 (01-2017), Fliegerfaust (02-2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......:
; ===============================================================================================================================
#include-once

Global $ResetStats = 0

Func UpdateStats()
    Static $s_iOldSmartZapGain = 0, $s_iOldNumLSpellsUsed = 0, $s_iOldNumEQSpellsUsed = 0
    Static $topgoldloot = 0, $topelixirloot = 0, $topdarkloot = 0, $topTrophyloot = 0
    Static $bDonateTroopsStatsChanged = False, $bDonateSpellsStatsChanged = False
    Static $iOldFreeBuilderCount, $iOldTotalBuilderCount, $iOldGemAmount ; builder and gem amounts
    Static $iOldCurrentLoot[$eLootCount] ; current stats
    Static $iOldTotalLoot[$eLootCount] ; total stats
    Static $iOldLastLoot[$eLootCount] ; loot and trophy gain from last raid
    Static $iOldLastBonus[$eLootCount] ; bonus loot from last raid
    Static $iOldSkippedVillageCount, $iOldDroppedTrophyCount ; skipped village and dropped trophy counts
    Static $iOldCostGoldWall, $iOldCostElixirWall, $iOldCostGoldBuilding, $iOldCostElixirBuilding, $iOldCostDElixirHero ; wall, building and hero upgrade costs
    Static $iOldNbrOfWallsUppedGold, $iOldNbrOfWallsUppedElixir, $iOldNbrOfBuildingsUppedGold, $iOldNbrOfBuildingsUppedElixir, $iOldNbrOfHeroesUpped ; number of wall, building, hero upgrades with gold, elixir, delixir
    Static $iOldSearchCost, $iOldTrainCostElixir, $iOldTrainCostDElixir ; search and train troops cost
    Static $iOldNbrOfOoS ; number of Out of Sync occurred
    Static $iOldGoldFromMines, $iOldElixirFromCollectors, $iOldDElixirFromDrills ; number of resources gain by collecting mines, collectors, drills
    Static $iOldAttackedCount, $iOldAttackedVillageCount[$g_iModeCount + 1] ; number of attack villages for DB, LB, TB, TS
    Static $iOldTotalGoldGain[$g_iModeCount + 1], $iOldTotalElixirGain[$g_iModeCount + 1], $iOldTotalDarkGain[$g_iModeCount + 1], $iOldTotalTrophyGain[$g_iModeCount + 1] ; total resource gains for DB, LB, TB, TS
    Static $iOldNbrOfDetectedMines[$g_iModeCount + 1], $iOldNbrOfDetectedCollectors[$g_iModeCount + 1], $iOldNbrOfDetectedDrills[$g_iModeCount + 1] ; number of mines, collectors, drills detected for DB, LB, TB

	If $g_iFirstRun = 1 Then
		;GUICtrlSetState($g_hLblResultStatsTemp, $GUI_HIDE)
		GUICtrlSetState($g_hLblVillageReportTemp, $GUI_HIDE)
		GUICtrlSetState($g_hPicResultGoldTemp, $GUI_HIDE)
		GUICtrlSetState($g_hPicResultElixirTemp, $GUI_HIDE)
		GUICtrlSetState($g_hPicResultDETemp, $GUI_HIDE)

		GUICtrlSetState($g_hLblResultGoldNow, $GUI_SHOW) ; $GUI_DISABLE to trigger default view in btnVillageStat
		GUICtrlSetState($g_hPicResultGoldNow, $GUI_SHOW)
		GUICtrlSetState($g_hLblResultElixirNow, $GUI_SHOW)
		GUICtrlSetState($g_hPicResultElixirNow, $GUI_SHOW)
		If $g_aiCurrentLoot[$eLootDarkElixir] <> "" Then
			GUICtrlSetState($g_hLblResultDeNow, $GUI_SHOW)
			GUICtrlSetState($g_hPicResultDeNow, $GUI_SHOW)
		Else
			#cs mini
			GUICtrlSetState($g_hPicResultDEStart, $GUI_HIDE)
			GUICtrlSetState($g_hPicDarkLoot, $GUI_HIDE)
			GUICtrlSetState($g_hPicDarkLastAttack, $GUI_HIDE)
			GUICtrlSetState($g_hPicHourlyStatsDark, $GUI_HIDE)
			#ce
		EndIf
		GUICtrlSetState($g_hLblResultTrophyNow, $GUI_SHOW)
		GUICtrlSetState($g_hLblResultBuilderNow, $GUI_SHOW)
		GUICtrlSetState($g_hLblResultGemNow, $GUI_SHOW)
		;mini btnVillageStat("UpdateStats")
		$g_iStatsStartedWith[$eLootGold] = $g_aiCurrentLoot[$eLootGold]
		$g_iStatsStartedWith[$eLootElixir] = $g_aiCurrentLoot[$eLootElixir]
		$g_iStatsStartedWith[$eLootDarkElixir] = $g_aiCurrentLoot[$eLootDarkElixir]
		$g_iStatsStartedWith[$eLootTrophy] = $g_aiCurrentLoot[$eLootTrophy]
		;mini GUICtrlSetData($g_ahLblStatsStartedWith[$eLootGold], _NumberFormat($g_aiCurrentLoot[$eLootGold], True))
		GUICtrlSetData($g_hLblResultGoldNow, _NumberFormat($g_aiCurrentLoot[$eLootGold], True))
		$iOldCurrentLoot[$eLootGold] = $g_aiCurrentLoot[$eLootGold]
		;mini GUICtrlSetData($g_ahLblStatsStartedWith[$eLootElixir], _NumberFormat($g_aiCurrentLoot[$eLootElixir], True))
		GUICtrlSetData($g_hLblResultElixirNow, _NumberFormat($g_aiCurrentLoot[$eLootElixir], True))
		$iOldCurrentLoot[$eLootElixir] = $g_aiCurrentLoot[$eLootElixir]
		If $g_iStatsStartedWith[$eLootDarkElixir] <> "" Then
			;mini GUICtrlSetData($g_ahLblStatsStartedWith[$eLootDarkElixir], _NumberFormat($g_aiCurrentLoot[$eLootDarkElixir], True))
			GUICtrlSetData($g_hLblResultDeNow, _NumberFormat($g_aiCurrentLoot[$eLootDarkElixir], True))
			$iOldCurrentLoot[$eLootDarkElixir] = $g_aiCurrentLoot[$eLootDarkElixir]
		EndIf
		; mini GUICtrlSetData($g_ahLblStatsStartedWith[$eLootTrophy], _NumberFormat($g_aiCurrentLoot[$eLootTrophy], True))
		GUICtrlSetData($g_hLblResultTrophyNow, _NumberFormat($g_aiCurrentLoot[$eLootTrophy], True))
		$iOldCurrentLoot[$eLootTrophy] = $g_aiCurrentLoot[$eLootTrophy]
		GUICtrlSetData($g_hLblResultGemNow, _NumberFormat($g_iGemAmount, True))
		$iOldGemAmount = $g_iGemAmount
		GUICtrlSetData($g_hLblResultBuilderNow, $g_iFreeBuilderCount & "/" & $g_iTotalBuilderCount)
		$iOldFreeBuilderCount = $g_iFreeBuilderCount
		$iOldTotalBuilderCount = $g_iTotalBuilderCount
		$g_iFirstRun = 0
		;mini GUICtrlSetState($btnResetStats, $GUI_ENABLE)
		Return
	EndIf

	Local $bStatsUpdated = False

	If $g_iFirstAttack = 1 Then
		;GUICtrlSetState($lblLastAttackTemp, $GUI_HIDE)
		;GUICtrlSetState($lblLastAttackBonusTemp, $GUI_HIDE)
		;GUICtrlSetState($lblTotalLootTemp, $GUI_HIDE)
		;GUICtrlSetState($lblHourlyStatsTemp, $GUI_HIDE)
		$g_iFirstAttack = 2
	EndIf

	If Number($g_iStatsLastAttack[$eLootGold]) > Number($topgoldloot) Then
		$bStatsUpdated = True
		$topgoldloot = $g_iStatsLastAttack[$eLootGold]
		;mini GUICtrlSetData($g_ahLblStatsTop[$eLootGold],_NumberFormat($topgoldloot))
	EndIf

	If Number($g_iStatsLastAttack[$eLootElixir]) > Number($topelixirloot) Then
		$bStatsUpdated = True
		$topelixirloot = $g_iStatsLastAttack[$eLootElixir]
		; mini GUICtrlSetData($g_ahLblStatsTop[$eLootElixir],_NumberFormat($topelixirloot))
	EndIf

	If Number($g_iStatsLastAttack[$eLootDarkElixir]) > Number($topdarkloot) Then
		$bStatsUpdated = True
		$topdarkloot = $g_iStatsLastAttack[$eLootDarkElixir]
		; mini GUICtrlSetData($g_ahLblStatsTop[$eLootDarkElixir],_NumberFormat($topdarkloot))
	EndIf

	If Number($g_iStatsLastAttack[$eLootTrophy]) > Number($topTrophyloot) Then
		$bStatsUpdated = True
		$topTrophyloot = $g_iStatsLastAttack[$eLootTrophy]
		; mini GUICtrlSetData($g_ahLblStatsTop[$eLootTrophy],_NumberFormat($topTrophyloot))
	EndIf

	If $ResetStats = 1 Then
		$bStatsUpdated = True
		; mini GUICtrlSetData($g_ahLblStatsStartedWith[$eLootGold], _NumberFormat($g_aiCurrentLoot[$eLootGold], True))
		; mini GUICtrlSetData($g_ahLblStatsStartedWith[$eLootElixir], _NumberFormat($g_aiCurrentLoot[$eLootElixir], True))
		If $g_iStatsStartedWith[$eLootDarkElixir] <> "" Then
			; mini GUICtrlSetData($g_ahLblStatsStartedWith[$eLootDarkElixir], _NumberFormat($g_aiCurrentLoot[$eLootDarkElixir], True))
		EndIf
		; mini GUICtrlSetData($g_ahLblStatsStartedWith[$eLootTrophy], _NumberFormat($g_aiCurrentLoot[$eLootTrophy], True))
		;mini GUICtrlSetData($g_ahLblStatsGainPerHour[$eLootGold], "")
		; mini GUICtrlSetData($g_ahLblStatsGainPerHour[$eLootElixir], "")
		; mini GUICtrlSetData($g_ahLblStatsGainPerHour[$eLootDarkElixir], "")
		; mini GUICtrlSetData($g_ahLblStatsGainPerHour[$eLootTrophy], "")
		GUICtrlSetData($g_hLblResultGoldHourNow, "") ;GUI BOTTOM
		GUICtrlSetData($g_hLblResultElixirHourNow, "");GUI BOTTOM
		GUICtrlSetData($g_hLblResultDEHourNow, "") ;GUI BOTTOM

	EndIf

	If $iOldFreeBuilderCount <> $g_iFreeBuilderCount Or $iOldTotalBuilderCount <> $g_iTotalBuilderCount Then
		$bStatsUpdated = True
		GUICtrlSetData($g_hLblResultBuilderNow, $g_iFreeBuilderCount & "/" & $g_iTotalBuilderCount)
		$iOldFreeBuilderCount = $g_iFreeBuilderCount
		$iOldTotalBuilderCount = $g_iTotalBuilderCount
	EndIf

	If $iOldGemAmount <> $g_iGemAmount Then
		$bStatsUpdated = True
		GUICtrlSetData($g_hLblResultGemNow, _NumberFormat($g_iGemAmount, True))
		$iOldGemAmount = $g_iGemAmount
	EndIf

	If $iOldCurrentLoot[$eLootGold] <> $g_aiCurrentLoot[$eLootGold] Then
		$bStatsUpdated = True
		GUICtrlSetData($g_hLblResultGoldNow, _NumberFormat($g_aiCurrentLoot[$eLootGold], True))
		$iOldCurrentLoot[$eLootGold] = $g_aiCurrentLoot[$eLootGold]
	EndIf

	If $iOldCurrentLoot[$eLootElixir] <> $g_aiCurrentLoot[$eLootElixir] Then
		$bStatsUpdated = True
		GUICtrlSetData($g_hLblResultElixirNow, _NumberFormat($g_aiCurrentLoot[$eLootElixir], True))
		$iOldCurrentLoot[$eLootElixir] = $g_aiCurrentLoot[$eLootElixir]
	EndIf

	If $iOldCurrentLoot[$eLootDarkElixir] <> $g_aiCurrentLoot[$eLootDarkElixir] And $g_iStatsStartedWith[$eLootDarkElixir] <> "" Then
		$bStatsUpdated = True
		GUICtrlSetData($g_hLblResultDeNow, _NumberFormat($g_aiCurrentLoot[$eLootDarkElixir], True))
		$iOldCurrentLoot[$eLootDarkElixir] = $g_aiCurrentLoot[$eLootDarkElixir]
	EndIf

	If $iOldCurrentLoot[$eLootTrophy] <> $g_aiCurrentLoot[$eLootTrophy] Then
		$bStatsUpdated = True
		GUICtrlSetData($g_hLblResultTrophyNow, _NumberFormat($g_aiCurrentLoot[$eLootTrophy], True))
		$iOldCurrentLoot[$eLootTrophy] = $g_aiCurrentLoot[$eLootTrophy]
	EndIf

	If $iOldTotalLoot[$eLootGold] <> $g_iStatsTotalGain[$eLootGold] And ($g_iFirstAttack = 2 Or $ResetStats = 1) Then
		$bStatsUpdated = True
		;mini GUICtrlSetData($g_ahLblStatsTotalGain[$eLootGold], _NumberFormat($g_iStatsTotalGain[$eLootGold]))
		$iOldTotalLoot[$eLootGold] = $g_iStatsTotalGain[$eLootGold]
	EndIf

	If $iOldTotalLoot[$eLootElixir] <> $g_iStatsTotalGain[$eLootElixir] And ($g_iFirstAttack = 2 Or $ResetStats = 1) Then
		$bStatsUpdated = True
		; mini GUICtrlSetData($g_ahLblStatsTotalGain[$eLootElixir], _NumberFormat($g_iStatsTotalGain[$eLootElixir]))
		$iOldTotalLoot[$eLootElixir] = $g_iStatsTotalGain[$eLootElixir]
	EndIf

	If $iOldTotalLoot[$eLootDarkElixir] <> $g_iStatsTotalGain[$eLootDarkElixir] And (($g_iFirstAttack = 2 And $g_iStatsStartedWith[$eLootDarkElixir] <> "") Or $ResetStats = 1) Then
		$bStatsUpdated = True
		; mini GUICtrlSetData($g_ahLblStatsTotalGain[$eLootDarkElixir], _NumberFormat($g_iStatsTotalGain[$eLootDarkElixir]))
		$iOldTotalLoot[$eLootDarkElixir] = $g_iStatsTotalGain[$eLootDarkElixir]
	EndIf

	If $iOldTotalLoot[$eLootTrophy] <> $g_iStatsTotalGain[$eLootTrophy] And ($g_iFirstAttack = 2 Or $ResetStats = 1) Then
		$bStatsUpdated = True
		; mini GUICtrlSetData($g_ahLblStatsTotalGain[$eLootTrophy], _NumberFormat($g_iStatsTotalGain[$eLootTrophy]))
		$iOldTotalLoot[$eLootTrophy] = $g_iStatsTotalGain[$eLootTrophy]
	EndIf

	If $iOldLastLoot[$eLootGold] <> $g_iStatsLastAttack[$eLootGold] Then
		$bStatsUpdated = True
		;mini GUICtrlSetData($g_ahLblStatsLastAttack[$eLootGold], _NumberFormat($g_iStatsLastAttack[$eLootGold]))
		$iOldLastLoot[$eLootGold] = $g_iStatsLastAttack[$eLootGold]
	EndIf

	If $iOldLastLoot[$eLootElixir] <> $g_iStatsLastAttack[$eLootElixir] Then
		$bStatsUpdated = True
		; mini GUICtrlSetData($g_ahLblStatsLastAttack[$eLootElixir], _NumberFormat($g_iStatsLastAttack[$eLootElixir]))
		$iOldLastLoot[$eLootElixir] = $g_iStatsLastAttack[$eLootElixir]
	EndIf

	If $iOldLastLoot[$eLootDarkElixir] <> $g_iStatsLastAttack[$eLootDarkElixir] Then
		$bStatsUpdated = True
		; mini GUICtrlSetData($g_ahLblStatsLastAttack[$eLootDarkElixir], _NumberFormat($g_iStatsLastAttack[$eLootDarkElixir]))
		$iOldLastLoot[$eLootDarkElixir] = $g_iStatsLastAttack[$eLootDarkElixir]
	EndIf

	If $iOldLastLoot[$eLootTrophy] <> $g_iStatsLastAttack[$eLootTrophy] Then
		$bStatsUpdated = True
		; mini GUICtrlSetData($g_ahLblStatsLastAttack[$eLootTrophy], _NumberFormat($g_iStatsLastAttack[$eLootTrophy]))
		$iOldLastLoot[$eLootTrophy] = $g_iStatsLastAttack[$eLootTrophy]
	EndIf

	If $iOldLastBonus[$eLootGold] <> $g_iStatsBonusLast[$eLootGold] Then
		$bStatsUpdated = True
		;mini GUICtrlSetData($g_ahLblStatsBonusLast[$eLootGold], _NumberFormat($g_iStatsBonusLast[$eLootGold]))
		$iOldLastBonus[$eLootGold] = $g_iStatsBonusLast[$eLootGold]
	EndIf

	If $iOldLastBonus[$eLootElixir] <> $g_iStatsBonusLast[$eLootElixir] Then
		$bStatsUpdated = True
		; mini GUICtrlSetData($g_ahLblStatsBonusLast[$eLootElixir], _NumberFormat($g_iStatsBonusLast[$eLootElixir]))
		$iOldLastBonus[$eLootElixir] = $g_iStatsBonusLast[$eLootElixir]
	EndIf

	If $iOldSkippedVillageCount <> $g_iSkippedVillageCount Then
		$bStatsUpdated = True
		;mini GUICtrlSetData($g_hLblResultVillagesSkipped, _NumberFormat($g_iSkippedVillageCount, True))
		GUICtrlSetData($g_hLblResultSkippedHourNow, _NumberFormat($g_iSkippedVillageCount, True))
		$iOldSkippedVillageCount = $g_iSkippedVillageCount
	EndIf

	If $iOldAttackedCount <> $g_aiAttackedCount Then
		$bStatsUpdated = True
		;mini GUICtrlSetData($g_hLblResultVillagesAttacked, _NumberFormat($g_aiAttackedCount, True))
		GUICtrlSetData($g_hLblResultAttackedHourNow, _NumberFormat($g_aiAttackedCount, True))
		$iOldAttackedCount = $g_aiAttackedCount
	EndIf

	If $g_iFirstAttack = 2 Then
		$bStatsUpdated = True
		GUICtrlSetData($g_hLblResultGoldHourNow, _NumberFormat(Round($g_iStatsTotalGain[$eLootGold] / (Int(__TimerDiff($g_hTimerSinceStarted) + $g_iTimePassed)) * 3600)) & "k / h") ;GUI BOTTOM
		GUICtrlSetData($g_hLblResultElixirHourNow, _NumberFormat(Round($g_iStatsTotalGain[$eLootElixir] / (Int(__TimerDiff($g_hTimerSinceStarted) + $g_iTimePassed)) * 3600)) & "k / h") ;GUI BOTTOM
		If $g_iStatsStartedWith[$eLootDarkElixir] <> "" Then
			GUICtrlSetData($g_hLblResultDEHourNow, _NumberFormat(Round($g_iStatsTotalGain[$eLootDarkElixir] / (Int(__TimerDiff($g_hTimerSinceStarted) + $g_iTimePassed)) * 3600 * 1000)) & " / h") ;GUI BOTTOM
		EndIf

	EndIf

	If Number($g_iStatsLastAttack[$eLootGold]) > Number($topgoldloot) Then
		$bStatsUpdated = True
		$topgoldloot = $g_iStatsLastAttack[$eLootGold]
	EndIf

	If Number($g_iStatsLastAttack[$eLootElixir]) > Number($topelixirloot) Then
		$bStatsUpdated = True
		$topelixirloot = $g_iStatsLastAttack[$eLootElixir]
	EndIf

	If Number($g_iStatsLastAttack[$eLootDarkElixir]) > Number($topdarkloot) Then
		$bStatsUpdated = True
		$topdarkloot = $g_iStatsLastAttack[$eLootDarkElixir]
	EndIf

	If Number($g_iStatsLastAttack[$eLootTrophy]) > Number($topTrophyloot) Then
		$bStatsUpdated = True
		$topTrophyloot = $g_iStatsLastAttack[$eLootTrophy]
	EndIf

	; Custom BB - Team AIO Mod++
	BuilderBaseSetStats()

	If $ResetStats = 1 Then
		$ResetStats = 0
	EndIf

EndFunc   ;==>UpdateStats

Func ResetStats()
	$ResetStats = 1
	$g_iFirstAttack = 0
	$g_iTimePassed = 0
	$g_hTimerSinceStarted = __TimerInit()
	;mini GUICtrlSetData($g_hLblResultRuntime, "00:00:00")
	GUICtrlSetData($g_hLblResultRuntimeNow, "00:00:00")
	$g_iStatsStartedWith[$eLootGold] = $g_aiCurrentLoot[$eLootGold]
	$g_iStatsStartedWith[$eLootElixir] = $g_aiCurrentLoot[$eLootElixir]
	$g_iStatsStartedWith[$eLootDarkElixir] = $g_aiCurrentLoot[$eLootDarkElixir]
	$g_iStatsStartedWith[$eLootTrophy] = $g_aiCurrentLoot[$eLootTrophy]
	$g_iStatsTotalGain[$eLootGold] = 0
	$g_iStatsTotalGain[$eLootElixir] = 0
	$g_iStatsTotalGain[$eLootDarkElixir] = 0
	$g_iStatsTotalGain[$eLootTrophy] = 0
	$g_iStatsLastAttack[$eLootGold] = 0
	$g_iStatsLastAttack[$eLootElixir] = 0
	$g_iStatsLastAttack[$eLootDarkElixir] = 0
	$g_iStatsLastAttack[$eLootTrophy] = 0
	$g_iStatsBonusLast[$eLootGold] = 0
	$g_iStatsBonusLast[$eLootElixir] = 0
	$g_iStatsBonusLast[$eLootDarkElixir] = 0
	$g_iSkippedVillageCount = 0
	$g_iDroppedTrophyCount = 0
	$g_iCostGoldWall = 0
	$g_iCostElixirWall = 0
	$g_iCostGoldBuilding = 0
	$g_iCostElixirBuilding = 0
	$g_iCostDElixirHero = 0
	$g_iNbrOfWallsUppedGold = 0
	$g_iNbrOfWallsUppedElixir = 0
	$g_iNbrOfBuildingsUppedGold = 0
	$g_iNbrOfBuildingsUppedElixir = 0
	$g_iNbrOfHeroesUpped = 0
	$g_iSearchCost = 0
	$g_iTrainCostElixir = 0
	$g_iTrainCostGold = 0
	$g_iTrainCostDElixir = 0
	$g_iNbrOfOoS = 0
	$g_iGoldFromMines = 0
	$g_iElixirFromCollectors = 0
	$g_iDElixirFromDrills = 0
	$g_iSmartZapGain = 0
	$g_iNumLSpellsUsed = 0
	$g_iNumEQSpellsUsed = 0
	For $i = 0 To $g_iModeCount - 1
		$g_aiAttackedVillageCount[$i] = 0
		$g_aiTotalGoldGain[$i] = 0
		$g_aiTotalElixirGain[$i] = 0
		$g_aiTotalDarkGain[$i] = 0
		$g_aiTotalTrophyGain[$i] = 0
		$g_aiNbrOfDetectedMines[$i] = 0
		$g_aiNbrOfDetectedCollectors[$i] = 0
		$g_aiNbrOfDetectedDrills[$i] = 0
	Next

	For $i = 0 To $eTroopCount - 1
		$g_aiDonateStatsTroops[$i][0] = 0
    Next

	For $i = 0 To $eSpellCount - 1
	   If $i <> $eSpellClone Then
		   $g_aiDonateStatsSpells[$i][0] = 0
	   EndIf
	Next

	For $i = 0 To $eSiegeMachineCount - 1
		$g_aiDonateStatsSieges[$i][0] = 0
	Next

	$g_iTotalDonateStatsTroops = 0
	$g_iTotalDonateStatsTroopsXP = 0
	$g_iTotalDonateStatsSpells = 0
	$g_iTotalDonateStatsSpellsXP = 0
	$g_iTotalDonateStatsSiegeMachines = 0
	$g_iTotalDonateStatsSiegeMachinesXP = 0

	UpdateStats()

	; Custom BB - Team AIO Mod++
	BuilderBaseResetStats()
EndFunc   ;==>ResetStats

; Custom BB - Team AIO Mod++
Func BuilderBaseResetStats()
	GUICtrlSetData($g_hLblBBResultGoldNow, "")
	GUICtrlSetData($g_hLblBBResultElixirNow, "")
	GUICtrlSetData($g_hLblBBResultTrophyNow, "")
	GUICtrlSetData($g_hLblBBResultBuilderNow, "")
EndFunc   ;==>BuilderBaseResetStats

; Custom BB - Team AIO Mod++
Func BuilderBaseSetStats()
	GUICtrlSetData($g_hLblBBResultGoldNow, _NumberFormat($g_aiCurrentLootBB[$eLootGoldBB], True))
	GUICtrlSetData($g_hLblBBResultElixirNow, _NumberFormat($g_aiCurrentLootBB[$eLootElixirBB], True))
	GUICtrlSetData($g_hLblBBResultTrophyNow, _NumberFormat($g_aiCurrentLootBB[$eLootTrophyBB], True))
	GUICtrlSetData($g_hLblBBResultBuilderNow, $g_iFreeBuilderCountBB & "/" & $g_iTotalBuilderCountBB)
EndFunc   ;==>_BuilderBaseResetStats
