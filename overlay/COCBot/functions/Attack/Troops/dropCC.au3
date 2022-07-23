; #FUNCTION# ====================================================================================================================
; Name ..........: dropCC
; Description ...: Drops Clan Castle troops, given the slot and x, y coordinates.
; Syntax ........: dropCC($x, $y, $slot)
; Parameters ....: $x                   - X location.
;                  $y                   - Y location.
;                  $slot                - CC location in troop menu
; Return values .: None
; Author ........:
; Modified ......: Sardo (12-2015) KnowJack (06-2015)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func dropCC($iX, $iY, $iCCSlot) ;Drop clan castle

	Local $test = ($g_iMatchMode <> $DB And $g_iMatchMode <> $LB) Or $g_abAttackDropCC[$g_iMatchMode]

	If $iCCSlot <> -1 And $test Then
		If $g_bPlannedDropCCHoursEnable = True Then
			Local $hour = StringSplit(_NowTime(4), ":", $STR_NOCOUNT)
			If $g_abPlannedDropCCHours[$hour[0]] = False Then
				SetLog("Drop CC not Planned, Skipped..", $COLOR_SUCCESS)
				Return ; exit func if no planned donate checkmarks
			EndIf
		EndIf


		;standard attack
		If $g_bUseCCBalanced = True Then
			If Number($g_iTroopsReceived) <> 0 Then
				If Number(Number($g_iTroopsDonated) / Number($g_iTroopsReceived)) >= (Number($g_iCCDonated) / Number($g_iCCReceived)) Then
					SetLog("Dropping Siege/Clan Castle, donated (" & $g_iTroopsDonated & ") / received (" & $g_iTroopsReceived & ") >= " & $g_iCCDonated & "/" & $g_iCCReceived, $COLOR_INFO)
					SelectDropTroop($iCCSlot)
					If _Sleep($DELAYDROPCC1) Then Return
					AttackClick($iX, $iY, 1, 0, 0, "#0087")
				Else
					SetLog("No Dropping Siege/Clan Castle, donated  (" & $g_iTroopsDonated & ") / received (" & $g_iTroopsReceived & ") < " & $g_iCCDonated & "/" & $g_iCCReceived, $COLOR_INFO)
				EndIf
			Else
				If Number(Number($g_iTroopsDonated) / 1) >= (Number($g_iCCDonated) / Number($g_iCCReceived)) Then
					SetLog("Dropping Siege/Clan Castle, donated (" & $g_iTroopsDonated & ") / received (" & $g_iTroopsReceived & ") >= " & $g_iCCDonated & "/" & $g_iCCReceived, $COLOR_INFO)
					SelectDropTroop($iCCSlot)
					If _Sleep($DELAYDROPCC1) Then Return
					AttackClick($iX, $iY, 1, 0, 0, "#0089")
				Else
					SetLog("No Dropping Siege/Clan Castle, donated  (" & $g_iTroopsDonated & ") / received (" & $g_iTroopsReceived & ") < " & $g_iCCDonated & "/" & $g_iCCReceived, $COLOR_INFO)
				EndIf
			EndIf
		Else
			SetLog("Dropping Siege/Clan Castle", $COLOR_INFO)
			SelectDropTroop($iCCSlot)
			If _Sleep($DELAYDROPCC1) Then Return
			AttackClick($iX, $iY, 1, 0, 0, "#0091")
		EndIf
	EndIf

EndFunc   ;==>dropCC
