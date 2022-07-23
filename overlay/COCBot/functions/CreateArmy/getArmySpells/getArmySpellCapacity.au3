; #FUNCTION# ====================================================================================================================
; Name ..........: getArmySpellCapacity
; Description ...: Obtains current and total quanitites for spells from Training - Army Overview window
; Syntax ........: getArmySpellCapacity()
; Parameters ....:
; Return values .: None
; Author ........:
; Modified ......: CodeSlinger69 (01-2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Func getArmySpellCapacity($bOpenArmyWindow = False, $bCloseArmyWindow = False, $bCheckWindow = True, $bSetLog = True, $bNeedCapture = True)

	If $g_bDebugSetlogTrain Or $g_bDebugSetlog Then SetLog("getArmySpellCapacity():", $COLOR_DEBUG1)

	If $bCheckWindow Then
		If Not $bOpenArmyWindow And Not IsTrainPage() Then ; check for train page
			SetError(1)
			Return ; not open, not requested to be open - error.
		ElseIf $bOpenArmyWindow Then
			If Not OpenArmyOverview(True, "getArmySpellCapacity()") Then
				SetError(2)
				Return ; not open, requested to be open - error.
			EndIf
			If _Sleep($DELAYCHECKARMYCAMP5) Then Return
		EndIf
	EndIf

	Local $g_iTotalSpells = 0
	Local $aGetSpellCap[3] = ["", "", ""]
	Local $iCount
	Local $sSpellsInfo = ""

	; Verify spell current and total capacity
	If $g_iTotalSpellValue > 0 Then ; only use this code if the user had input spells to brew ... and assign the spells quantity
		$sSpellsInfo = getArmyCampCap($aArmySpellSize[0], $aArmySpellSize[1], $bNeedCapture) ; OCR read Spells and total capacity

		$iCount = 0 ; reset OCR loop counter
		While $sSpellsInfo = "" ; In case the CC donations recieved msg are blocking, need to keep checking numbers till valid
			$sSpellsInfo = getArmyCampCap($aArmySpellSize[0], $aArmySpellSize[1], $bNeedCapture) ; OCR read Spells and total capacity
			$iCount += 1
			If $iCount > 10 Then ExitLoop ; try reading 30 times for 250+150ms OCR for 4 sec
			If _Sleep($DELAYCHECKARMYCAMP5) Then Return ; Wait 250ms
		WEnd

		If $g_bDebugSetlogTrain Then SetLog("$sSpellsInfo= " & $sSpellsInfo, $COLOR_DEBUG)
		$aGetSpellCap = StringSplit($sSpellsInfo, "#") ; split the existen Spells from the total Spell factory capacity

		If IsArray($aGetSpellCap) Then
			If $aGetSpellCap[0] > 1 Then
				$g_iTotalSpells = Number($aGetSpellCap[2])
				$g_iCurrentSpells = Number($aGetSpellCap[1])
			Else
				SetLog("Error in getArmySpellCapacity: Couldn't reall all Capacity Values", $COLOR_ERROR) ; log if there is read error
				$g_iCurrentSpells = 0
				$g_iTotalSpells = $g_iTotalSpellValue
			EndIf
		Else
			SetLog("Error in getArmySpellCapacity: $aGetCCSpell is not an Array", $COLOR_ERROR) ; log if there is read error
			$g_iCurrentSpells = 0
			$g_iTotalSpells = $g_iTotalSpellValue
		EndIf

		If $bSetLog Then SetLog("Total Spell Factory Capacity: " & $g_iCurrentSpells & "/" & $g_iTotalSpells)
	EndIf

	If $g_iTotalSpells <> $g_iTotalSpellValue And $bSetLog Then
		SetLog("Warning: Total Spell Capacity is not the same as in GUI", $COLOR_WARNING)
		If $g_bIgnoreIncorrectSpellCombo = True And Not $g_bQuickTrainEnable Then
			If $g_iTotalSpells <> 0 Then $g_iTotalSpellValue = $g_iTotalSpells
			FixInDoubleTrain($g_aiArmyCompSpells, $g_iTotalSpellValue, $g_aiSpellSpace, TroopIndexLookup($g_sCmbFICSpells[$g_iCmbFillIncorrectSpellCombo][0], "DoubleTrain") - $eLSpell)
		EndIf
	EndIf
	
	If $bCloseArmyWindow Then
		ClickAway()
		If _Sleep($DELAYCHECKARMYCAMP4) Then Return
	EndIf

EndFunc   ;==>getArmySpellCapacity
