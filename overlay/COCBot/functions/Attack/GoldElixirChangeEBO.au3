; #FUNCTION# ====================================================================================================================
; Name ..........: GoldElixirChangeEBO  (End Battle Options)
; Description ...: Checks if the gold/elixir changes , Returns True if changed.
; Syntax ........: GoldElixirChangeEBO()
; Parameters ....:
; Return values .: None
; Author ........:
; Modified ......: Sardo (06-2015), Fliegerfaust (01-2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:v
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func GoldElixirChangeEBO()
	Local $Gold1, $Gold2
	Local $GoldChange, $ElixirChange
	Local $Elixir1, $Elixir2
	Local $DarkElixir1, $DarkElixir2
	Local $DarkElixirChange
	Local $Trophies
	Local $txtDiff
	Local $exitOneStar = 0, $exitTwoStars = 0
	Local $Damage, $CurDamage
	$g_iDarkLow = 0
	;READ RESOURCES n.1
	$Gold1 = getGoldVillageSearch(48, 69)
	$Elixir1 = getElixirVillageSearch(48, 69 + 29)
	$Trophies = getTrophyVillageSearch(48, 69 + 99)
	$Damage = getOcrOverAllDamage(780, 527 + $g_iBottomOffsetY)
	If Number($Damage) > Number($g_iPercentageDamage) Then $g_iPercentageDamage = Number($Damage)
	If $Trophies <> "" Then ; If trophy value found, then base has Dark Elixir
		If _Sleep($DELAYGOLDELIXIRCHANGEEBO1) Then Return
		$DarkElixir1 = getDarkElixirVillageSearch(48, 69 + 57)
	Else
		$DarkElixir1 = ""
		$Trophies = getTrophyVillageSearch(48, 69 + 69)
	EndIf

	;CALCULATE WHICH TIMER TO USE
	Local $x = $g_aiStopAtkNoLoot1Time[$g_iMatchMode] * 1000, $y = $g_aiStopAtkNoLoot2Time[$g_iMatchMode] * 1000, $z, $w = $g_aiStopAtkPctNoChangeTime[$g_iMatchMode] * 1000
	If Number($Gold1) < $g_aiStopAtkNoLoot2MinGold[$g_iMatchMode] And _
			Number($Elixir1) < $g_aiStopAtkNoLoot2MinElixir[$g_iMatchMode] And _
			Number($DarkElixir1) < $g_aiStopAtkNoLoot2MinDark[$g_iMatchMode] And _
			$g_abStopAtkNoLoot2Enable[$g_iMatchMode] Then

		$z = $y
	ElseIf $Damage <> "" And $g_abStopAtkPctNoChangeEnable[$g_iMatchMode] Then
		$z = $w
	Else
		If $g_abStopAtkNoLoot1Enable[$g_iMatchMode] Then
			$z = $x
		Else
			$z = AttackRemainingTime()
		EndIf
	EndIf

	;CALCULATE TWO STARS REACH
	If $g_abStopAtkTwoStars[$g_iMatchMode] And _CheckPixel($aWonTwoStar, True) Then
		SetLog("Two Star Reach, exit", $COLOR_SUCCESS)
		$exitTwoStars = 1
		$z = 0
	EndIf

	;CALCULATE ONE STARS REACH
	If $g_abStopAtkOneStar[$g_iMatchMode] And _CheckPixel($aWonOneStar, True) Then
		SetLog("One Star Reach, exit", $COLOR_SUCCESS)
		$exitOneStar = 1
		$z = 0
	EndIf

	; Early Check if Percentage is alreay higher than set
	If $g_abStopAtkPctHigherEnable[$g_iMatchMode] And Number(getOcrOverAllDamage(780, 527 + $g_iBottomOffsetY)) > Number($g_aiStopAtkPctHigherAmt[$g_iMatchMode]) Then
		SetLog("Overall Damage above " & Number($g_aiStopAtkPctHigherAmt[$g_iMatchMode]), $COLOR_SUCCESS)
		$g_iPercentageDamage = Number(getOcrOverAllDamage(780, 527 + $g_iBottomOffsetY))
		$z = 0
	EndIf

	Local $NoResourceOCR = False
	Local $ExitNoLootChange = ($g_abStopAtkNoLoot1Enable[$g_iMatchMode] Or $g_abStopAtkNoLoot2Enable[$g_iMatchMode] Or $g_abStopAtkNoResources[$g_iMatchMode])

	;MAIN LOOP
	Local $iBegin = __TimerInit()

	Local $iSuspendAndroidTimeOffset = SuspendAndroidTime()
	SetDebugLog("GoldElixirChangeEBO: Start waiting for battle end, Wait: " & $z & ", Offset: " & $iSuspendAndroidTimeOffset)

	Local $iTime = 0
	Local $bOneLoop = True
	While $bOneLoop Or ($iTime < $z And $z > 0 And $iTime >= 0)
		$bOneLoop = False
		;HEALTH HEROES
		CheckHeroesHealth()

		;DE SPECIAL END EARLY
		If $g_iMatchMode = $LB And $g_aiAttackStdDropSides[$LB] = 4 And $g_bDESideEndEnable Then
			If $g_bDropQueen Or $g_bDropKing Then DELow()
			If $g_iDarkLow = 1 Then ExitLoop
		EndIf
		If $g_bCheckKingPower Or $g_bCheckQueenPower Or $g_iDarkLow = 2 Then
			If _Sleep($DELAYGOLDELIXIRCHANGEEBO1) Then Return
		Else
			If _Sleep($DELAYGOLDELIXIRCHANGEEBO2) Then Return
		EndIf

		;--> Read Ressources #2
		$Gold2 = getGoldVillageSearch(48, 69)
		If $Gold2 = "" Then
			If _Sleep($DELAYGOLDELIXIRCHANGEEBO1) Then Return
			$Gold2 = getGoldVillageSearch(48, 69)
		EndIf
		$Elixir2 = getElixirVillageSearch(48, 69 + 29)
		$Trophies = getTrophyVillageSearch(48, 69 + 99)
		CheckHeroesHealth()
		If $Trophies <> "" Then ; If trophy value found, then base has Dark Elixir
			If _Sleep($DELAYGOLDELIXIRCHANGEEBO1) Then Return
			$DarkElixir2 = getDarkElixirVillageSearch(48, 69 + 57)
		Else
			$DarkElixir2 = ""
			$Trophies = getTrophyVillageSearch(48, 69 + 69)
		EndIf
		$CurDamage = getOcrOverAllDamage(780, 527 + $g_iBottomOffsetY)
		;--> Read Ressources #2

		CheckHeroesHealth()

		;WRITE LOG
		$txtDiff = Round(($z - (__TimerDiff($iBegin) - SuspendAndroidTime() + $iSuspendAndroidTimeOffset)) / 1000, 0)
		If Number($txtDiff) < 0 Then
			$txtDiff = "0s"
		Else
			Local $m = Int($txtDiff / 60)
			Local $s = $txtDiff - $m * 60
			$txtDiff = ""
			If $m > 0 Then $txtDiff = $m & "m "
			$txtDiff &= $s & "s"
		EndIf
		$NoResourceOCR = StringLen($Gold2) = 0 And StringLen($Elixir2) = 0 And StringLen($DarkElixir2) = 0
		If $NoResourceOCR Then
			SetLog("Exit now, [G]: " & $Gold2 & " [E]: " & $Elixir2 & " [DE]: " & $DarkElixir2 & " [%]: " & $CurDamage, $COLOR_INFO)
		Else
			If $g_bDebugSetlog Then
				SetDebugLog("Exit in " & $txtDiff & ", [G]: " & $Gold2 & " [E]: " & $Elixir2 & " [DE]: " & $DarkElixir2 & " [%]: " & $CurDamage & ", Suspend-Time: " & $g_iSuspendAndroidTime & ", Suspend-Count: " & $g_iSuspendAndroidTimeCount &  ", Offset: " & $iSuspendAndroidTimeOffset, $COLOR_INFO)
			Else
				SetLog("Exit in " & $txtDiff & ", [G]: " & $Gold2 & " [E]: " & $Elixir2 & " [DE]: " & $DarkElixir2 & " [%]: " & $CurDamage, $COLOR_INFO)
			EndIf
		EndIf

		If Number($CurDamage) > Number($g_iPercentageDamage) Then $g_iPercentageDamage = Number($CurDamage)

		If Number($CurDamage) >= 92 Then
			If ($g_bCheckKingPower Or $g_bCheckQueenPower Or $g_bCheckWardenPower Or $g_bCheckChampionPower) Then
				If $g_bCheckKingPower And $g_iActivateKing = 0 Then
					SetLog("Activating King's ability to restore some health before leaving with a 3 Star", $COLOR_INFO)
					If IsAttackPage() Then SelectDropTroop($g_iKingSlot) ;If King was not activated: Boost King before Battle ends with a 3 Star
					$g_bCheckKingPower = False
				EndIf
				If $g_bCheckQueenPower And $g_iActivateQueen = 0 Then
					SetLog("Activating Queen's ability to restore some health before leaving with a 3 Star", $COLOR_INFO)
					If IsAttackPage() Then SelectDropTroop($g_iQueenSlot) ;If Queen was not activated: Boost Queen before Battle ends with a 3 Star
					$g_bCheckQueenPower = False
				EndIf
				If $g_bCheckWardenPower And $g_iActivateWarden = 0 Then
					SetLog("Activating Warden's ability to restore some health before leaving with a 3 Star", $COLOR_INFO)
					If IsAttackPage() Then SelectDropTroop($g_iWardenSlot) ;If Queen was not activated: Boost Queen before Battle ends with a 3 Star
					$g_bCheckWardenPower = False
				EndIf
				If $g_bCheckChampionPower And $g_iActivateChampion = 0 Then
					SetLog("Activating Royal Champion's ability to restore some health before leaving with a 3 Star", $COLOR_INFO)
					If IsAttackPage() Then SelectDropTroop($g_iChampionSlot) ;If Champion was not activated: Boost Champion before Battle ends with a 3 Star
					$g_bCheckChampionPower = False
				EndIf
			EndIf
		EndIf


		;CALCULATE RESOURCE CHANGES
		If $Gold2 <> "" Or $Elixir2 <> "" Or $DarkElixir2 <> "" Then
			$GoldChange = $Gold2
			$ElixirChange = $Elixir2
			$DarkElixirChange = $DarkElixir2
		EndIf

		;EXIT IF RESOURCES = 0
		If $g_abStopAtkNoResources[$g_iMatchMode] And Number($Gold2) = 0 And Number($Elixir2) = 0 And Number($DarkElixir2) = 0 Then
			SetLog("Gold & Elixir & DE = 0, end battle ", $COLOR_SUCCESS)
			If _Sleep($DELAYGOLDELIXIRCHANGEEBO2) Then Return
			ExitLoop
		EndIf

		;EXIT IF TWO STARS REACH
		If $g_abStopAtkTwoStars[$g_iMatchMode] And _CheckPixel($aWonTwoStar, True) Then
			SetLog("Two Star Reach, exit", $COLOR_SUCCESS)
			$exitTwoStars = 1
			ExitLoop
		EndIf

		;EXIT IF ONE STARS REACH
		If $g_abStopAtkOneStar[$g_iMatchMode] And _CheckPixel($aWonOneStar, True) Then
			SetLog("One Star Reach, exit", $COLOR_SUCCESS)
			$exitOneStar = 1
			ExitLoop
		EndIf

		;EXIT LOOP IF RESOURCES = "" ... battle end
		If getGoldVillageSearch(48, 69) = "" And getElixirVillageSearch(48, 69 + 29) = "" And $DarkElixir2 = "" Then
			ExitLoop
		EndIf

		If $g_abStopAtkPctHigherEnable[$g_iMatchMode] And Number(getOcrOverAllDamage(780, 527 + $g_iBottomOffsetY)) > Number($g_aiStopAtkPctHigherAmt[$g_iMatchMode]) Then
			SetLog("Overall Damage above " & Number($g_aiStopAtkPctHigherAmt[$g_iMatchMode]) & ", exit", $COLOR_SUCCESS)
			$g_iPercentageDamage = Number(getOcrOverAllDamage(780, 527 + $g_iBottomOffsetY))
			ExitLoop
		EndIf

		;RETURN IF RESOURCES CHANGE DETECTED
		If ($g_abStopAtkNoLoot1Enable[$g_iMatchMode] Or $g_abStopAtkNoLoot2Enable[$g_iMatchMode]) And ($Gold1 <> $Gold2 Or $Elixir1 <> $Elixir2 Or $DarkElixir1 <> $DarkElixir2) Then
			SetLog("Gold & Elixir & DE change detected, waiting...", $COLOR_SUCCESS)
			Return True
		EndIf

		;RETURN IF DAMAGE CHANGE DETECTED
		If $g_abStopAtkPctNoChangeEnable[$g_iMatchMode] And (Number($Damage) <> Number($CurDamage)) Then
			SetLog("Overall Damage Percentage change detected, waiting...", $COLOR_SUCCESS)
			$g_iPercentageDamage = Number(getOcrOverAllDamage(780, 527 + $g_iBottomOffsetY))
			Return True
		EndIf

		$iTime = __TimerDiff($iBegin) - SuspendAndroidTime() + $iSuspendAndroidTimeOffset
	WEnd ; END MAIN LOOP

	;Priority Check... Exit To protect Hero Health
	If $g_iMatchMode = $LB And $g_aiAttackStdDropSides[$LB] = 4 And $g_bDESideEndEnable And $g_iDarkLow = 1 Then
		SetLog("Returning Now -DE-", $COLOR_SUCCESS)
		Return False
	EndIf

	;FIRST CHECK... EXIT FOR ONE STAR REACH
	If $g_abStopAtkOneStar[$g_iMatchMode] And $exitOneStar = 1 Then
		If _Sleep($DELAYGOLDELIXIRCHANGEEBO2) Then Return
		Return False
	EndIf

	;SECOND CHECK... EXIT FOR TWO STARS REACH
	If $g_abStopAtkTwoStars[$g_iMatchMode] And $exitTwoStars = 1 Then
		If _Sleep($DELAYGOLDELIXIRCHANGEEBO2) Then Return
		Return False
	EndIf

	;THIRD CHECK... IF VALUES= "" REREAD AND RETURN FALSE IF = ""
	If ($NoResourceOCR = True) Then
		SetLog("Battle has finished", $COLOR_SUCCESS)
		Return False ;end battle
	EndIf

	If $g_abStopAtkPctHigherEnable[$g_iMatchMode] And Number(getOcrOverAllDamage(780, 527 + $g_iBottomOffsetY)) > Number($g_aiStopAtkPctHigherAmt[$g_iMatchMode]) Then
		$g_iPercentageDamage = Number(getOcrOverAllDamage(780, 527 + $g_iBottomOffsetY))
		Return False
	EndIf

	;FOURTH CHECK... IF RESOURCES = 0 THEN EXIT
	If $g_abStopAtkNoResources[$g_iMatchMode] And $NoResourceOCR = False And Number($Gold2) = 0 And Number($Elixir2) = 0 And Number($DarkElixir2) = 0 Then
		SetLog("Gold & Elixir & DE = 0, end battle ", $COLOR_SUCCESS)
		If _Sleep($DELAYGOLDELIXIRCHANGEEBO2) Then Return
		Return False
	EndIf

	If $g_abStopAtkPctNoChangeEnable[$g_iMatchMode] And Number($Damage) = Number($CurDamage) Then
		SetLog("No Overall Damage Percentage change detected, exit", $COLOR_SUCCESS)
		Return False
	EndIf


	;FIFTH CHECK... IF VALUES NOT CHANGED  RETURN FALSE ELSE RETURN TRUE
	If (Number($Gold1) = Number($Gold2) And Number($Elixir1) = Number($Elixir2) And Number($DarkElixir1) = Number($DarkElixir2)) Then
		If $g_abStopAtkNoLoot1Enable[$g_iMatchMode] Or $g_abStopAtkNoLoot2Enable[$g_iMatchMode] Then
			SetLog("Gold & Elixir & DE no change detected, exit", $COLOR_SUCCESS)
			Return False
		Else
			SetLog("Gold & Elixir & DE no change detected, waiting...", $COLOR_SUCCESS)
		EndIf
	Else
		If $g_bDebugSetlog Then
			SetDebugLog("Gold1: " & Number($Gold1) & "  Gold2: " & Number($Gold2), $COLOR_DEBUG)
			SetDebugLog("Elixir1: " & Number($Elixir1) & "  Elixir2: " & Number($Elixir2), $COLOR_DEBUG)
			SetDebugLog("Dark Elixir1: " & Number($DarkElixir1) & "  Dark Elixir2: " & Number($DarkElixir2), $COLOR_DEBUG)
		EndIf
	EndIf

	Return True

EndFunc   ;==>GoldElixirChangeEBO
