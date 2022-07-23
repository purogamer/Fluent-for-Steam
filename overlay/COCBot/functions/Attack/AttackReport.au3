; #FUNCTION# ====================================================================================================================
; Name ..........: AttackReport
; Description ...: This function will report the loot from the last Attack: gold, elixir, dark elixir and trophies.
;                  It will also update the statistics to the GUI (Last Attack).
; Syntax ........: AttackReport()
; Parameters ....: None
; Return values .: None
; Author ........: Hervidero (02-2015), Sardo (05-2015), Hervidero (12-2015)
; Modified ......: Sardo (05-2015), Hervidero (05-2015), Knowjack (07-2015), MikeD (04-2021)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func AttackReport()
	Static $iBonusLast = 0 ; last attack Bonus percentage
	Local $g_asLeagueDetailsShort = ""
	Local $iCount

	$iCount = 0 ; Reset loop counter
	While _CheckPixel($aEndFightSceneAvl, True) = False ; check for light gold pixle in the Gold ribbon in End of Attack Scene before reading values
		$iCount += 1
		If _Sleep($DELAYATTACKREPORT1) Then Return
		SetDebugLog("Waiting Attack Report Ready, " & ($iCount / 2) & " Seconds.", $COLOR_DEBUG)
		If $iCount > 30 Then ExitLoop ; wait 30*500ms = 15 seconds max for the window to render
	WEnd
	If $iCount > 30 Then SetLog("End of Attack scene slow to appear, attack values my not be correct", $COLOR_INFO)

	$iCount = 0 ; reset loop counter
	While getResourcesLoot(290, 289 + $g_iMidOffsetY) = "" ; check for gold value to be non-zero before reading other values as a secondary timer to make sure all values are available
		$iCount += 1
		If _Sleep($DELAYATTACKREPORT1) Then Return
		SetDebugLog("Waiting Attack Report Ready, " & ($iCount / 2) & " Seconds.", $COLOR_DEBUG)
		If $iCount > 20 Then ExitLoop ; wait 20*500ms = 10 seconds max before we have call the OCR read an error
	WEnd
	If $iCount > 20 Then SetLog("End of Attack scene read gold error, attack values my not be correct", $COLOR_INFO)

	;HArchH: Subtracted 5 pixels from each getResourcesLoot call "x" value, 12 for DE.
	;G was 290, is 285
	;E was 290, is 285
	;DE was 365, is 353
	If _ColorCheck(_GetPixelColor($aAtkRprtDECheck[0], $aAtkRprtDECheck[1], True), Hex($aAtkRprtDECheck[2], 6), $aAtkRprtDECheck[3]) Then ; if the color of the DE drop detected
		$g_iStatsLastAttack[$eLootGold] = getResourcesLoot(285, 289 + $g_iMidOffsetY)
		If _Sleep($DELAYATTACKREPORT2) Then Return
		$g_iStatsLastAttack[$eLootElixir] = getResourcesLoot(285, 328 + $g_iMidOffsetY)
		If _Sleep($DELAYATTACKREPORT2) Then Return
		$g_iStatsLastAttack[$eLootDarkElixir] = getResourcesLootDE(353, 365 + $g_iMidOffsetY)
		If _Sleep($DELAYATTACKREPORT2) Then Return
		$g_iStatsLastAttack[$eLootTrophy] = getResourcesLootT(403, 402 + $g_iMidOffsetY)
		If _ColorCheck(_GetPixelColor($aAtkRprtTrophyCheck[0], $aAtkRprtTrophyCheck[1], True), Hex($aAtkRprtTrophyCheck[2], 6), $aAtkRprtTrophyCheck[3]) Then
			$g_iStatsLastAttack[$eLootTrophy] = -$g_iStatsLastAttack[$eLootTrophy]
		EndIf
		SetLog("Loot: [G]: " & _NumberFormat($g_iStatsLastAttack[$eLootGold]) & " [E]: " & _NumberFormat($g_iStatsLastAttack[$eLootElixir]) & " [DE]: " & _NumberFormat($g_iStatsLastAttack[$eLootDarkElixir]) & " [T]: " & $g_iStatsLastAttack[$eLootTrophy], $COLOR_SUCCESS)
	Else
		$g_iStatsLastAttack[$eLootGold] = getResourcesLoot(285, 289 + $g_iMidOffsetY)
		If _Sleep($DELAYATTACKREPORT2) Then Return
		$g_iStatsLastAttack[$eLootElixir] = getResourcesLoot(285, 328 + $g_iMidOffsetY)
		If _Sleep($DELAYATTACKREPORT2) Then Return
		$g_iStatsLastAttack[$eLootTrophy] = getResourcesLootT(403, 365 + $g_iMidOffsetY)
		If _ColorCheck(_GetPixelColor($aAtkRprtTrophyCheck[0], $aAtkRprtTrophyCheck[1], True), Hex($aAtkRprtTrophyCheck[2], 6), $aAtkRprtTrophyCheck[3]) Then
			$g_iStatsLastAttack[$eLootTrophy] = -$g_iStatsLastAttack[$eLootTrophy]
		EndIf
		$g_iStatsLastAttack[$eLootDarkElixir] = ""
		SetLog("Loot: [G]: " & _NumberFormat($g_iStatsLastAttack[$eLootGold]) & " [E]: " & _NumberFormat($g_iStatsLastAttack[$eLootElixir]) & " [T]: " & $g_iStatsLastAttack[$eLootTrophy], $COLOR_SUCCESS)
	EndIf

	If $g_iStatsLastAttack[$eLootTrophy] >= 0 Then
		$iBonusLast = Number(getResourcesBonusPerc(570, 309 + $g_iMidOffsetY))
		If $iBonusLast > 0 Then
			SetLog("Bonus Percentage: " & $iBonusLast & "%")
			Local $iCalcMaxBonus = 0, $iCalcMaxBonusDark = 0

			If _ColorCheck(_GetPixelColor($aAtkRprtDECheck2[0], $aAtkRprtDECheck2[1], True), Hex($aAtkRprtDECheck2[2], 6), $aAtkRprtDECheck2[3]) Then
				If _Sleep($DELAYATTACKREPORT2) Then Return
				$g_iStatsBonusLast[$eLootGold] = getResourcesBonus(590, 340 + $g_iMidOffsetY)
				$g_iStatsBonusLast[$eLootGold] = StringReplace($g_iStatsBonusLast[$eLootGold], "+", "")
				If _Sleep($DELAYATTACKREPORT2) Then Return
				$g_iStatsBonusLast[$eLootElixir] = getResourcesBonus(590, 371 + $g_iMidOffsetY)
				$g_iStatsBonusLast[$eLootElixir] = StringReplace($g_iStatsBonusLast[$eLootElixir], "+", "")
				If _Sleep($DELAYATTACKREPORT2) Then Return
				$g_iStatsBonusLast[$eLootDarkElixir] = getResourcesBonus(621, 402 + $g_iMidOffsetY)
				$g_iStatsBonusLast[$eLootDarkElixir] = StringReplace($g_iStatsBonusLast[$eLootDarkElixir], "+", "")

				If $iBonusLast = 100 Then
					$iCalcMaxBonus = $g_iStatsBonusLast[$eLootGold]
					SetLog("Bonus [G]: " & _NumberFormat($g_iStatsBonusLast[$eLootGold]) & " [E]: " & _NumberFormat($g_iStatsBonusLast[$eLootElixir]) & " [DE]: " & _NumberFormat($g_iStatsBonusLast[$eLootDarkElixir]), $COLOR_SUCCESS)
				Else
					$iCalcMaxBonus = Ceiling($g_iStatsBonusLast[$eLootGold] / ($iBonusLast / 100))
					$iCalcMaxBonusDark = Ceiling($g_iStatsBonusLast[$eLootDarkElixir] / ($iBonusLast / 100))

					SetLog("Bonus [G]: " & _NumberFormat($g_iStatsBonusLast[$eLootGold]) & " out of " & _NumberFormat($iCalcMaxBonus) & " [E]: " & _NumberFormat($g_iStatsBonusLast[$eLootElixir]) & " out of " & _NumberFormat($iCalcMaxBonus) & " [DE]: " & _NumberFormat($g_iStatsBonusLast[$eLootDarkElixir]) & " out of " & _NumberFormat($iCalcMaxBonusDark), $COLOR_SUCCESS)
				EndIf
			Else
				If _Sleep($DELAYATTACKREPORT2) Then Return
				$g_iStatsBonusLast[$eLootGold] = getResourcesBonus(590, 340 + $g_iMidOffsetY)
				$g_iStatsBonusLast[$eLootGold] = StringReplace($g_iStatsBonusLast[$eLootGold], "+", "")
				If _Sleep($DELAYATTACKREPORT2) Then Return
				$g_iStatsBonusLast[$eLootElixir] = getResourcesBonus(590, 371 + $g_iMidOffsetY)
				$g_iStatsBonusLast[$eLootElixir] = StringReplace($g_iStatsBonusLast[$eLootElixir], "+", "")
				$g_iStatsBonusLast[$eLootDarkElixir] = 0

				If $iBonusLast = 100 Then
					$iCalcMaxBonus = $g_iStatsBonusLast[$eLootGold]
					SetLog("Bonus [G]: " & _NumberFormat($g_iStatsBonusLast[$eLootGold]) & " [E]: " & _NumberFormat($g_iStatsBonusLast[$eLootElixir]), $COLOR_SUCCESS)
				Else
					$iCalcMaxBonus = Number($g_iStatsBonusLast[$eLootGold] / ($iBonusLast / 100))
					SetLog("Bonus [G]: " & _NumberFormat($g_iStatsBonusLast[$eLootGold]) & " out of " & _NumberFormat($iCalcMaxBonus) & " [E]: " & _NumberFormat($g_iStatsBonusLast[$eLootElixir]) & " out of " & _NumberFormat($iCalcMaxBonus), $COLOR_SUCCESS)
				EndIf
			EndIf

			$g_asLeagueDetailsShort = "--"
			For $i = 1 To 21 ; skip 0 = Bronze III, see "No Bonus" else section below
				If _Sleep($DELAYATTACKREPORT2) Then Return
				If $g_asLeagueDetails[$i][0] = $iCalcMaxBonus Then
					SetLog("Your league level is: " & $g_asLeagueDetails[$i][1])
					$g_asLeagueDetailsShort = $g_asLeagueDetails[$i][3]
					ExitLoop
				EndIf
			Next
		Else
			SetLog("No Bonus")

			$g_asLeagueDetailsShort = "--"
			If $g_aiCurrentLoot[$eLootTrophy] + $g_iStatsLastAttack[$eLootTrophy] >= 400 And $g_aiCurrentLoot[$eLootTrophy] + $g_iStatsLastAttack[$eLootTrophy] < 500 Then ; Bronze III has no League bonus
				SetLog("Your league level is: " & $g_asLeagueDetails[0][1])
				$g_asLeagueDetailsShort = $g_asLeagueDetails[0][3]
			EndIf
		EndIf
		;Display League in Stats ==>
		GUICtrlSetData($g_hLblLeague, "")

		If StringInStr($g_asLeagueDetailsShort, "1") > 1 Then
			GUICtrlSetData($g_hLblLeague, "1")
		ElseIf StringInStr($g_asLeagueDetailsShort, "2") > 1 Then
			GUICtrlSetData($g_hLblLeague, "2")
		ElseIf StringInStr($g_asLeagueDetailsShort, "3") > 1 Then
			GUICtrlSetData($g_hLblLeague, "3")
		EndIf
		_GUI_Value_STATE("HIDE", $g_aGroupLeague)
		If StringInStr($g_asLeagueDetailsShort, "B") > 0 Then
			GUICtrlSetState($g_ahPicLeague[$eLeagueBronze], $GUI_SHOW)
		ElseIf StringInStr($g_asLeagueDetailsShort, "S") > 0 Then
			GUICtrlSetState($g_ahPicLeague[$eLeagueSilver], $GUI_SHOW)
		ElseIf StringInStr($g_asLeagueDetailsShort, "G") > 0 Then
			GUICtrlSetState($g_ahPicLeague[$eLeagueGold], $GUI_SHOW)
		ElseIf StringInStr($g_asLeagueDetailsShort, "c", $STR_CASESENSE) > 0 Then
			GUICtrlSetState($g_ahPicLeague[$eLeagueCrystal], $GUI_SHOW)
		ElseIf StringInStr($g_asLeagueDetailsShort, "M") > 0 Then
			GUICtrlSetState($g_ahPicLeague[$eLeagueMaster], $GUI_SHOW)
		ElseIf StringInStr($g_asLeagueDetailsShort, "C", $STR_CASESENSE) > 0 Then
			GUICtrlSetState($g_ahPicLeague[$eLeagueChampion], $GUI_SHOW)
		ElseIf StringInStr($g_asLeagueDetailsShort, "T") > 0 Then
			GUICtrlSetState($g_ahPicLeague[$eLeagueTitan], $GUI_SHOW)
		ElseIf StringInStr($g_asLeagueDetailsShort, "LE") > 0 Then
			GUICtrlSetState($g_ahPicLeague[$eLeagueLegend], $GUI_SHOW)
		Else
			GUICtrlSetState($g_ahPicLeague[$eLeagueUnranked], $GUI_SHOW)
		EndIf
		;==> Display League in Stats
	Else
		$g_iStatsBonusLast[$eLootGold] = 0
		$g_iStatsBonusLast[$eLootElixir] = 0
		$g_iStatsBonusLast[$eLootDarkElixir] = 0
		$g_asLeagueDetailsShort = "--"
	EndIf

	#Region - Colorful attack log - Team AIO Mod++
	; check stars earned
	Local $iStarsEarned = 0
	_CaptureRegion()
	If _ColorCheck(_GetPixelColor($aWonOneStarAtkRprt[0], $aWonOneStarAtkRprt[1], False), Hex($aWonOneStarAtkRprt[2], 6), $aWonOneStarAtkRprt[3]) Then $iStarsEarned += 1
	If _ColorCheck(_GetPixelColor($aWonTwoStarAtkRprt[0], $aWonTwoStarAtkRprt[1], False), Hex($aWonTwoStarAtkRprt[2], 6), $aWonTwoStarAtkRprt[3]) Then $iStarsEarned += 1
	If _ColorCheck(_GetPixelColor($aWonThreeStarAtkRprt[0], $aWonThreeStarAtkRprt[1], False), Hex($aWonThreeStarAtkRprt[2], 6), $aWonThreeStarAtkRprt[3]) Then $iStarsEarned += 1
	SetLog("Stars earned: " & $iStarsEarned)

    Local $AtkLogTxt
    $g_iStatsBonusLast[$eLootGold]=$g_iStatsBonusLast[$eLootGold]/1000
	
	; Custom Acc - Team AIO Mod++
	Local $iAccNumber = $g_iCurAccount + 1
	If $iAccNumber > 9 Then
		$AtkLogTxt = "|" & String($iAccNumber) & "|" & _NowTime(4) & "|"
	Else
		$AtkLogTxt = "| " & String($iAccNumber) & "|" & _NowTime(4) & "|"
	EndIf
    $AtkLogTxt &= StringFormat("%6d", $g_aiCurrentLoot[$eLootTrophy]) & "|"
    $AtkLogTxt &= StringFormat("%3d", $g_iSearchCount) & "|"
    $AtkLogTxt &= StringFormat("%2d", $g_iSidesAttack) & "|"
    $AtkLogTxt &= StringFormat("%7d", $g_iStatsLastAttack[$eLootGold]) & "|"
    $AtkLogTxt &= StringFormat("%7d", $g_iStatsLastAttack[$eLootElixir]) & "|"
    $AtkLogTxt &= StringFormat("%5d", $g_iStatsLastAttack[$eLootDarkElixir]) & "|"
    $AtkLogTxt &= StringFormat("%3d", $g_iStatsLastAttack[$eLootTrophy]) & "|"
    $AtkLogTxt &= StringFormat("%2d", $iStarsEarned) & "|"
    $AtkLogTxt &= StringFormat("%3d", $g_iPercentageDamage) & "|"
    $AtkLogTxt &= StringFormat("%5d", $g_iStatsBonusLast[$eLootGold]) & "k|"
    ;$AtkLogTxt &= StringFormat("%4d", $g_iStatsBonusLast[$eLootElixir]) & "k|"
    $AtkLogTxt &= StringFormat("%4d", $g_iStatsBonusLast[$eLootDarkElixir]) & "|"
    $AtkLogTxt &= $g_asLeagueDetailsShort & "|"

    $g_iStatsBonusLast[$eLootGold]=$g_iStatsBonusLast[$eLootGold]*1000

    ; Stats Attack
	$g_sTotalDamage = $g_iPercentageDamage
	$g_sAttacksides = $g_iSidesAttack
	$g_sLootGold = $g_iStatsLastAttack[$eLootGold]
	$g_sLootElixir = $g_iStatsLastAttack[$eLootElixir]
	$g_sLootDE = $g_iStatsLastAttack[$eLootDarkElixir]
	$g_sLeague = $g_asLeagueDetailsShort
	$g_sBonusGold = $g_iStatsBonusLast[$eLootGold]
	$g_sBonusElixir = $g_iStatsBonusLast[$eLootElixir]
	$g_sBonusDE = $g_iStatsBonusLast[$eLootDarkElixir]
	$g_sStarsEarned = $iStarsEarned

	Local $AtkLogTxtExtend
	$AtkLogTxtExtend = "|"
	$AtkLogTxtExtend &= $g_CurrentCampUtilization & "/" & $g_iTotalCampSpace & "|"

	If Int($g_iStatsLastAttack[$eLootTrophy]) >= 0 Then
		If $g_bChkColorfulAttackLog Then
			Local $aColorful[4] = [0xFF0000, 0x8F8F8F, 0x0047D6, 0x3FA800]
			Switch $iStarsEarned
				Case 1
					SetAtkLog($AtkLogTxt, $AtkLogTxtExtend, $aColorful[$iStarsEarned])
				Case 2
					SetAtkLog($AtkLogTxt, $AtkLogTxtExtend, $aColorful[$iStarsEarned])
				Case 3
					SetAtkLog($AtkLogTxt, $AtkLogTxtExtend, $aColorful[$iStarsEarned])
				Case Else
					SetAtkLog($AtkLogTxt, $AtkLogTxtExtend, $aColorful[0])
			EndSwitch
		Else
			SetAtkLog($AtkLogTxt, $AtkLogTxtExtend, $COLOR_BLACK)
		EndIf
	Else
		SetAtkLog($AtkLogTxt, $AtkLogTxtExtend, $COLOR_ERROR)
	EndIf
	#EndRegion - Colorful attack log - Team AIO Mod++

	; rename or delete zombie
	If $g_bDebugDeadBaseImage Then
		setZombie($g_iStatsLastAttack[$eLootElixir])
	EndIf

 	; Share Replay
 	If $g_bShareAttackEnable Then
 		If (Number($g_iStatsLastAttack[$eLootGold]) >= Number($g_iShareMinGold)) And (Number($g_iStatsLastAttack[$eLootElixir]) >= Number($g_iShareMinElixir)) And (Number($g_iStatsLastAttack[$eLootDarkElixir]) >= Number($g_iShareMinDark)) Then
			SetLog("Reached minimum Loot values. Share Replay")
 			$g_bShareAttackEnableNow = True
 		Else
			SetLog("Below minimum Loot values. No Share Replay")
 			$g_bShareAttackEnableNow = False
 		EndIf
 	EndIf

	If $g_iFirstAttack = 0 Then $g_iFirstAttack = 1
	$g_iStatsTotalGain[$eLootGold] += $g_iStatsLastAttack[$eLootGold] + $g_iStatsBonusLast[$eLootGold]
	$g_aiTotalGoldGain[$g_iMatchMode] += $g_iStatsLastAttack[$eLootGold] + $g_iStatsBonusLast[$eLootGold]
	$g_iStatsTotalGain[$eLootElixir] += $g_iStatsLastAttack[$eLootElixir] + $g_iStatsBonusLast[$eLootElixir]
	$g_aiTotalElixirGain[$g_iMatchMode] += $g_iStatsLastAttack[$eLootElixir] + $g_iStatsBonusLast[$eLootElixir]
	If $g_iStatsStartedWith[$eLootDarkElixir] <> "" Then
		$g_iStatsTotalGain[$eLootDarkElixir] += $g_iStatsLastAttack[$eLootDarkElixir] + $g_iStatsBonusLast[$eLootDarkElixir]
		$g_aiTotalDarkGain[$g_iMatchMode] += $g_iStatsLastAttack[$eLootDarkElixir] + $g_iStatsBonusLast[$eLootDarkElixir]
	EndIf
	$g_iStatsTotalGain[$eLootTrophy] += $g_iStatsLastAttack[$eLootTrophy]
	$g_aiTotalTrophyGain[$g_iMatchMode] += $g_iStatsLastAttack[$eLootTrophy]
	$g_aiAttackedVillageCount[$g_iMatchMode] += 1
	UpdateStats()
	UpdateSDataBase()
	If ProfileSwitchAccountEnabled() Then
		$g_aiAttackedCountAcc[$g_iCurAccount] += 1
		SetSwitchAccLog(" - Acc. " & $g_iCurAccount + 1 & ", Attack: " & $g_aiAttackedCountAcc[$g_iCurAccount])
	EndIf
	$g_iActualTrainSkip = 0
	$g_iPercentageDamage = 0
	$g_iSidesAttack = 0

EndFunc   ;==>AttackReport
