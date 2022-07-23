; #FUNCTION# ====================================================================================================================
; Name ..........:
; Description ...: This function will update the statistics in the GUI.
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Boju (11-2016)
; Modified ......: CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......:
; ===============================================================================================================================
#include-once

Global $g_aiTempGainCost[3] = [0, 0, 0]

Func StartGainCost()
	$g_aiTempGainCost[0] = 0
	$g_aiTempGainCost[1] = 0
	$g_aiTempGainCost[2] = 0
	VillageReport(True, True)
	Local $tempCounter = 0
	While ($g_aiCurrentLoot[$eLootGold] = "" Or $g_aiCurrentLoot[$eLootElixir] = "" Or ($g_aiCurrentLoot[$eLootDarkElixir] = "" And $g_iStatsStartedWith[$eLootDarkElixir] <> "")) And $tempCounter < 5
		$tempCounter += 1
		If _Sleep(100) Then Return
		VillageReport(True, True)
	WEnd
	$g_aiTempGainCost[0] = $g_aiCurrentLoot[$eLootGold] ;$tempGold
	$g_aiTempGainCost[1] = $g_aiCurrentLoot[$eLootElixir] ;$tempElixir
	$g_aiTempGainCost[2] = $g_aiCurrentLoot[$eLootDarkElixir] ;$tempDElixir
EndFunc   ;==>StartGainCost

Func EndGainCost($Type)
	VillageReport(True, True)
	Local $tempCounter = 0
	While ($g_aiCurrentLoot[$eLootGold] = "" Or $g_aiCurrentLoot[$eLootElixir] = "" Or ($g_aiCurrentLoot[$eLootDarkElixir] = "" And $g_iStatsStartedWith[$eLootDarkElixir] <> "")) And $tempCounter < 5
		$tempCounter += 1
		VillageReport(True, True)
	WEnd

	Switch $Type
		Case "Collect"
			Local $tempGoldCollected = 0
			Local $tempElixirCollected = 0
			Local $tempDElixirCollected = 0

			If $g_aiTempGainCost[0] <> "" And $g_aiCurrentLoot[$eLootGold] <> "" And $g_aiTempGainCost[0] <> $g_aiCurrentLoot[$eLootGold] Then
				$tempGoldCollected = $g_aiCurrentLoot[$eLootGold] - $g_aiTempGainCost[0]
				$g_iGoldFromMines += $tempGoldCollected
				$g_iStatsTotalGain[$eLootGold] += $tempGoldCollected
			EndIf

			If $g_aiTempGainCost[1] <> "" And $g_aiCurrentLoot[$eLootElixir] <> "" And $g_aiTempGainCost[1] <> $g_aiCurrentLoot[$eLootElixir] Then
				$tempElixirCollected = $g_aiCurrentLoot[$eLootElixir] - $g_aiTempGainCost[1]
				$g_iElixirFromCollectors += $tempElixirCollected
				$g_iStatsTotalGain[$eLootElixir] += $tempElixirCollected
			EndIf

			If $g_aiTempGainCost[2] <> "" And $g_aiCurrentLoot[$eLootDarkElixir] <> "" And $g_aiTempGainCost[2] <> $g_aiCurrentLoot[$eLootDarkElixir] Then
				$tempDElixirCollected = $g_aiCurrentLoot[$eLootDarkElixir] - $g_aiTempGainCost[2]
				$g_iDElixirFromDrills += $tempDElixirCollected
				$g_iStatsTotalGain[$eLootDarkElixir] += $tempDElixirCollected
			EndIf

		Case "Train"
			Local $tempGoldSpent = 0
			Local $tempElixirSpent = 0
			Local $tempDElixirSpent = 0

			If $g_aiTempGainCost[0] <> "" And $g_aiCurrentLoot[$eLootGold] <> "" And $g_aiTempGainCost[0] <> $g_aiCurrentLoot[$eLootGold] Then
				$tempGoldSpent = ($g_aiTempGainCost[0] - $g_aiCurrentLoot[$eLootGold])
				$g_iTrainCostGold += $tempGoldSpent
				$g_iStatsTotalGain[$eLootGold] -= $tempGoldSpent
			EndIf

			If $g_aiTempGainCost[1] <> "" And $g_aiCurrentLoot[$eLootElixir] <> "" And $g_aiTempGainCost[1] <> $g_aiCurrentLoot[$eLootElixir] Then
				$tempElixirSpent = ($g_aiTempGainCost[1] - $g_aiCurrentLoot[$eLootElixir])
				$g_iTrainCostElixir += $tempElixirSpent
				$g_iStatsTotalGain[$eLootElixir] -= $tempElixirSpent
			EndIf

			If $g_aiTempGainCost[2] <> "" And $g_aiCurrentLoot[$eLootDarkElixir] <> "" And $g_aiTempGainCost[2] <> $g_aiCurrentLoot[$eLootDarkElixir] Then
				$tempDElixirSpent = ($g_aiTempGainCost[2] - $g_aiCurrentLoot[$eLootDarkElixir])
				$g_iTrainCostDElixir += $tempDElixirSpent
				$g_iStatsTotalGain[$eLootDarkElixir] -= $tempDElixirSpent
			EndIf

	EndSwitch

	UpdateStats()
EndFunc   ;==>EndGainCost
