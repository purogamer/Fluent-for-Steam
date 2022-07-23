; #FUNCTION# ====================================================================================================================
; Name ..........: getArmyCCSpellCapacity
; Description ...: Obtains current and total quanitites for Clancastle spells from Training - Army Overview window
; Syntax ........: getArmyCCSpellCapacity()
; Parameters ....:
; Return values .: None
; Author ........:
; Modified ......: CodeSlinger69 (01-2017), Fliegerfaust (03-2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Func getArmyCCSpellCapacity($bOpenArmyWindow = False, $bCloseArmyWindow = False, $bCheckWindow = True, $bSetLog = True, $bNeedCapture = True)
	If $g_iTownHallLevel < 8 And $g_iTownHallLevel <> -1 Then
		SetDebugLog("getArmyCCSpellCapacity(): Early exit because clan castle cannot fit spells", $COLOR_DEBUG)
		Return
	EndIf

	If $g_bDebugSetlogTrain Or $g_bDebugSetlog Then SetLog("Begin getArmyCCSpellCapacity:", $COLOR_DEBUG1)

	If $bCheckWindow Then
		If Not $bOpenArmyWindow And Not IsTrainPage() Then ; check for train page
			SetError(1)
			Return ; not open, not requested to be open - error.
		ElseIf $bOpenArmyWindow Then
			If Not OpenArmyOverview(True, "getArmyCCSpellCapacity()") Then
				SetError(2)
				Return ; not open, requested to be open - error.
			EndIf
			If _Sleep($DELAYCHECKARMYCAMP5) Then Return
		EndIf
	EndIf
	
	#Region - Low TH Custom - Team AIO Mod++
	Local $aUnlockedSpellsCC[4] = [460, 475, 0xD0D0C0, 25] ; Low TH Custom - Team AIO Mod++
	If _ColorCheck(_GetPixelColor($aUnlockedSpellsCC[0], $aUnlockedSpellsCC[1], True), Hex($aUnlockedSpellsCC[2], 6), $aUnlockedSpellsCC[3]) = True Then ; Without being invasive.
		$g_iTotalCCSpells = 0
		$g_iCurrentCCSpells = 0
		If $bCloseArmyWindow Then
			ClickAway()
		EndIf
		Return
	EndIf
	#EndRegion - Low TH Custom - Team AIO Mod++

	; Verify spell current and total capacity
	Local $sCCSpellsInfo = getArmyCampCap($g_aArmyCCSpellSize[0], $g_aArmyCCSpellSize[1], $bNeedCapture) ; OCR read Spells and total capacity

	Local $iCount = 0 ; reset OCR loop counter
	While $sCCSpellsInfo = "" ; In case the CC donations recieved msg are blocking, need to keep checking numbers till valid
		$sCCSpellsInfo = getArmyCampCap($g_aArmyCCSpellSize[0], $g_aArmyCCSpellSize[1], $bNeedCapture) ; OCR read Spells and total capacity
		$iCount += 1
		If $iCount > 10 Then ExitLoop ; try reading 30 times for 250+150ms OCR for 4 sec
		If _Sleep($DELAYCHECKARMYCAMP5) Then Return ; Wait 250ms
	WEnd

	If $g_bDebugSetlogTrain Then SetLog("$sCCSpellsInfo = " & $sCCSpellsInfo, $COLOR_DEBUG)
	Local $aGetCCSpellsSize = StringSplit($sCCSpellsInfo, "#") ; split the existen Spells from the total Spell factory capacity

	If IsArray($aGetCCSpellsSize) Then
		If $aGetCCSpellsSize[0] > 1 Then
			$g_iTotalCCSpells = Number($aGetCCSpellsSize[2])
			$g_iCurrentCCSpells = Number($aGetCCSpellsSize[1])
		Else
			SetLog("CC Spells size read error (invalid row count)", $COLOR_ERROR) ; log if there is read error
			$g_iTotalCCSpells = 0
			$g_iCurrentCCSpells = 0
		EndIf
	Else
		SetLog("CC Spells size read error (no array)", $COLOR_ERROR) ; log if there is read error
		$g_iTotalCCSpells = 0
		$g_iCurrentCCSpells = 0
	EndIf

	If $bSetLog Then SetLog("Total Clan Castle Spells: " & $g_iCurrentCCSpells & "/" & $g_iTotalCCSpells)

	If $bCloseArmyWindow Then
		ClickAway()
		If _Sleep($DELAYCHECKARMYCAMP4) Then Return
	EndIf

EndFunc   ;==>getArmyCCSpellCapacity
