; #FUNCTION# ====================================================================================================================
; Name ..........: CheckHeroesHealth
; Description ...:
; Syntax ........: CheckHeroesHealth()
; Parameters ....:
; Return values .: None
; Author ........:
; Modified ......: MonkeyHunter(03-2017), Fliegerfaust (11-2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func CheckHeroesHealth()

	If $g_bCheckKingPower Or $g_bCheckQueenPower Or $g_bCheckWardenPower Or $g_bCheckChampionPower Then
		ForceCaptureRegion() ; ensure no screenshot caching kicks in

		Local $aDisplayTime[$eHeroCount] = [0, 0, 0, 0] ; array to hold converted timerdiff into seconds

		; Slot11+
		Local $TempKingSlot = $g_iKingSlot
		Local $TempQueenSlot = $g_iQueenSlot
		Local $TempWardenSlot = $g_iWardenSlot
		Local $TempChampionSlot = $g_iChampionSlot
		If $g_iKingSlot >= 11 Or $g_iQueenSlot >= 11 Or $g_iWardenSlot >= 11 Or $g_iChampionSlot >= 11 Then
			If Not $g_bDraggedAttackBar Then DragAttackBar($g_iTotalAttackSlot, False) ; drag forward
		ElseIf $g_iKingSlot >= 0 And $g_iQueenSlot >= 0 And $g_iWardenSlot >= 0 And $g_iChampionSlot >= 0 And ($g_iKingSlot < $g_iTotalAttackSlot - 10 Or $g_iQueenSlot < $g_iTotalAttackSlot - 10 Or $g_iWardenSlot < $g_iTotalAttackSlot - 10 Or $g_iChampionSlot < $g_iTotalAttackSlot - 10) Then
			If $g_bDraggedAttackBar Then DragAttackBar($g_iTotalAttackSlot, True) ; return drag
		EndIf
		If $g_bDraggedAttackBar Then
			$TempKingSlot -= $g_iTotalAttackSlot - 10
			$TempQueenSlot -= $g_iTotalAttackSlot - 10
			$TempWardenSlot -= $g_iTotalAttackSlot - 10
			$TempChampionSlot -= $g_iTotalAttackSlot - 10
		EndIf

		If $g_bDebugSetlog Then
			SetDebugLog("CheckHeroesHealth() for Queen started ")
			If _Sleep($DELAYRESPOND) Then Return ; improve pause button response
		EndIf

		If $g_iActivateQueen = 0 Or $g_iActivateQueen = 2 Then
			If $g_bCheckQueenPower And ($g_aHeroesTimerActivation[$eHeroArcherQueen] = 0 Or __TimerDiff($g_aHeroesTimerActivation[$eHeroArcherQueen]) > $DELAYCHECKHEROESHEALTH) Then
				Local $aQueenHealthCopy = $aQueenHealth ; copy ScreenCoordinates array to modify locally with dynamic X coordinate from slotposition
				Local $aSlotPosition = GetSlotPosition($TempQueenSlot)
				$aQueenHealthCopy[0] = $aSlotPosition[0] + $aQueenHealthCopy[4] ; Slot11+
				Local $QueenPixelColor = _GetPixelColor($aQueenHealthCopy[0], $aQueenHealthCopy[1], $g_bCapturePixel)
				SetDebugLog(" Queen _GetPixelColor(" & $aQueenHealthCopy[0] & "," & $aQueenHealthCopy[1] & "): " & $QueenPixelColor, $COLOR_DEBUG)
				If Not _CheckPixel2($aQueenHealthCopy, $QueenPixelColor, "Red+Blue") Then
					SetLog("Queen is getting weak, Activating Queen's ability", $COLOR_INFO)
					SelectDropTroop($TempQueenSlot, 2, Default, False) ; Slot11+
					$g_iCSVLastTroopPositionDropTroopFromINI = $g_iQueenSlot
					$g_bCheckQueenPower = False
				EndIf
			EndIf
		EndIf
		If $g_iActivateQueen = 1 Or $g_iActivateQueen = 2 Then
			If $g_bCheckQueenPower Then
				If $g_aHeroesTimerActivation[$eHeroArcherQueen] <> 0 Then
					$aDisplayTime[$eHeroArcherQueen] = Ceiling(__TimerDiff($g_aHeroesTimerActivation[$eHeroArcherQueen]) / 1000) ; seconds
				EndIf
				If (Int($g_iDelayActivateQueen) / 1000) <= $aDisplayTime[$eHeroArcherQueen] Then
					SetLog("Activating Queen's ability after " & $aDisplayTime[$eHeroArcherQueen] & "'s", $COLOR_INFO)
					SelectDropTroop($TempQueenSlot, 2, Default, False) ; Slot11+
					$g_iCSVLastTroopPositionDropTroopFromINI = $g_iQueenSlot
					$g_bCheckQueenPower = False ; Reset check power flag
					$g_aHeroesTimerActivation[$eHeroArcherQueen] = 0 ; Reset Timer
				EndIf
			EndIf
		EndIf

		If $g_bDebugSetlog Then
			SetDebugLog("CheckHeroesHealth() for King started ")
			If _Sleep($DELAYRESPOND) Then Return ; improve pause button response
		EndIf

		If $g_iActivateKing = 0 Or $g_iActivateKing = 2 Then
			If $g_bCheckKingPower And ($g_aHeroesTimerActivation[$eHeroBarbarianKing] = 0 Or __TimerDiff($g_aHeroesTimerActivation[$eHeroBarbarianKing]) > $DELAYCHECKHEROESHEALTH) Then
				Local $aKingHealthCopy = $aKingHealth ; copy ScreenCoordinates array to modify locally with dynamic X coordinate from slotposition
				Local $aSlotPosition = GetSlotPosition($TempKingSlot)
				$aKingHealthCopy[0] = $aSlotPosition[0] + $aKingHealthCopy[4] ; Slot11+
				Local $KingPixelColor = _GetPixelColor($aKingHealthCopy[0], $aKingHealthCopy[1], $g_bCapturePixel)
				SetDebugLog("King _GetPixelColor(" & $aKingHealthCopy[0] & "," & $aKingHealthCopy[1] & "): " & $KingPixelColor, $COLOR_DEBUG)
				If Not _CheckPixel2($aKingHealthCopy, $KingPixelColor, "Red+Blue") Then
					SetLog("King is getting weak, Activating King's ability", $COLOR_INFO)
					SelectDropTroop($TempKingSlot, 2, Default, False) ; Slot11+
					$g_iCSVLastTroopPositionDropTroopFromINI = $g_iKingSlot
					$g_bCheckKingPower = False
				EndIf
			EndIf
		EndIf
		If $g_iActivateKing = 1 Or $g_iActivateKing = 2 Then
			If $g_bCheckKingPower Then
				If $g_aHeroesTimerActivation[$eHeroBarbarianKing] <> 0 Then
					$aDisplayTime[$eHeroBarbarianKing] = Ceiling(__TimerDiff($g_aHeroesTimerActivation[$eHeroBarbarianKing]) / 1000) ; seconds
				EndIf
				If (Int($g_iDelayActivateKing) / 1000) <= $aDisplayTime[$eHeroBarbarianKing] Then
					SetLog("Activating King's ability after " & $aDisplayTime[$eHeroBarbarianKing] & "'s", $COLOR_INFO)
					SelectDropTroop($TempKingSlot, 2, Default, False) ; Slot11+
					$g_iCSVLastTroopPositionDropTroopFromINI = $g_iKingSlot
					$g_bCheckKingPower = False ; Reset check power flag
					$g_aHeroesTimerActivation[$eHeroBarbarianKing] = 0 ; Reset Timer
				EndIf
			EndIf
		EndIf

		If $g_bDebugSetlog Then
			SetDebugLog("CheckHeroesHealth() for Warden started ")
			If _Sleep($DELAYRESPOND) Then Return ; improve pause button response
		EndIf

		If $g_iActivateWarden = 0 Or $g_iActivateWarden = 2 And ($g_aHeroesTimerActivation[$eHeroGrandWarden] = 0 Or __TimerDiff($g_aHeroesTimerActivation[$eHeroGrandWarden]) > $DELAYCHECKHEROESHEALTH) Then
			If $g_bCheckWardenPower Then
				Local $aWardenHealthCopy = $aWardenHealth
				Local $aSlotPosition = GetSlotPosition($TempWardenSlot)
				$aWardenHealthCopy[0] = $aSlotPosition[0] + $aWardenHealthCopy[4] ; Slot11+
				Local $WardenPixelColor = _GetPixelColor($aWardenHealthCopy[0], $aWardenHealthCopy[1], $g_bCapturePixel)
				SetDebugLog(" Grand Warden _GetPixelColor(" & $aWardenHealthCopy[0] & "," & $aWardenHealthCopy[1] & "): " & $WardenPixelColor, $COLOR_DEBUG)
				If Not _CheckPixel2($aWardenHealthCopy, $WardenPixelColor, "Red+Blue") Then
					SetLog("Grand Warden is getting weak, Activating Warden's ability", $COLOR_INFO)
					SelectDropTroop($TempWardenSlot, 2, Default, False) ; Slot11+
					$g_iCSVLastTroopPositionDropTroopFromINI = $g_iWardenSlot
					$g_bCheckWardenPower = False
				EndIf
			EndIf
		EndIf
		If $g_iActivateWarden = 1 Or $g_iActivateWarden = 2 Then
			If $g_bCheckWardenPower Then
				If $g_aHeroesTimerActivation[$eHeroGrandWarden] <> 0 Then
					$aDisplayTime[$eHeroGrandWarden] = Ceiling(__TimerDiff($g_aHeroesTimerActivation[$eHeroGrandWarden]) / 1000) ; seconds
				EndIf
				If (Int($g_iDelayActivateWarden) / 1000) <= $aDisplayTime[$eHeroGrandWarden] Then
					SetLog("Activating Warden's ability after " & $aDisplayTime[$eHeroGrandWarden] & "'s", $COLOR_INFO)
					SelectDropTroop($TempWardenSlot, 2, Default, False) ; Slot11+
					$g_iCSVLastTroopPositionDropTroopFromINI = $g_iWardenSlot
					$g_bCheckWardenPower = False ; Reset check power flag
					$g_aHeroesTimerActivation[$eHeroGrandWarden] = 0 ; Reset Timer
				EndIf
			EndIf
		EndIf

		If $g_bDebugSetlog Then
			SetDebugLog("CheckHeroesHealth() for Royal Champion started ")
			If _Sleep($DELAYRESPOND) Then Return ; improve pause button response
		EndIf

		If $g_iActivateChampion = 0 Or $g_iActivateChampion = 2 And ($g_aHeroesTimerActivation[$eHeroRoyalChampion] = 0 Or __TimerDiff($g_aHeroesTimerActivation[$eHeroRoyalChampion]) > $DELAYCHECKHEROESHEALTH) Then
			If $g_bCheckChampionPower Then
				Local $aChampionHealthCopy = $aChampionHealth
				Local $aSlotPosition = GetSlotPosition($TempChampionSlot)
				$aChampionHealthCopy[0] = $aSlotPosition[0] + $aChampionHealthCopy[4] ; Slot11+
				Local $ChampionPixelColor = _GetPixelColor($aChampionHealthCopy[0], $aChampionHealthCopy[1], $g_bCapturePixel)
				SetDebugLog("Royal Champion _GetPixelColor(" & $aChampionHealthCopy[0] & "," & $aChampionHealthCopy[1] & "): " & $ChampionPixelColor, $COLOR_DEBUG)
				If Not _CheckPixel2($aChampionHealthCopy, $ChampionPixelColor, "Red+Blue") Then
					SetLog("Royal Champion is getting weak, Activating Royal Champion's ability", $COLOR_INFO)
					SelectDropTroop($TempChampionSlot, 2, Default, False) ; Slot11+
					$g_iCSVLastTroopPositionDropTroopFromINI = $g_iChampionSlot
					$g_bCheckChampionPower = False
				EndIf
			EndIf
		EndIf
		If $g_iActivateChampion = 1 Or $g_iActivateChampion = 2 Then
			If $g_bCheckChampionPower Then
				If $g_aHeroesTimerActivation[$eHeroRoyalChampion] <> 0 Then
					$aDisplayTime[$eHeroRoyalChampion] = Ceiling(__TimerDiff($g_aHeroesTimerActivation[$eHeroRoyalChampion]) / 1000) ; seconds
				EndIf
				If (Int($g_iDelayActivateChampion) / 1000) <= $aDisplayTime[$eHeroRoyalChampion] Then
					SetLog("Activating Royal Champion's ability after " & $aDisplayTime[$eHeroRoyalChampion] & "'s", $COLOR_INFO)
					SelectDropTroop($TempChampionSlot, 2, Default, False) ; Slot11+
					$g_iCSVLastTroopPositionDropTroopFromINI = $g_iChampionSlot
					$g_bCheckChampionPower = False ; Reset check power flag
					$g_aHeroesTimerActivation[$eHeroRoyalChampion] = 0 ; Reset Timer
				EndIf
			EndIf
		EndIf

		If _Sleep($DELAYRESPOND) Then Return ; improve pause button response
	EndIf
EndFunc   ;==>CheckHeroesHealth

