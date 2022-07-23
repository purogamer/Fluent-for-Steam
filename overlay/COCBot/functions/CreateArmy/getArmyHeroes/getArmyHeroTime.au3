; #FUNCTION# ====================================================================================================================
; Name ..........: getArmyHeroTime
; Description ...: Obtains time reamining for Heros Training - Army Overview window
; Syntax ........: getArmyHeroTime($iHeroEnum, $bReturnTimeArray = False, $bOpenArmyWindow = False, $bCloseArmyWindow = False)
; Parameters ....: $iHeroEnum = enum value for hero to check, or text "all" to check all heroes
;					  : $bOpenArmyWindow  = Bool value, true if train overview window needs to be opened
;					  : $bCloseArmyWindow = Bool value, true if train overview window needs to be closed
; Return values .:
; Author ........: MonkeyHunter (05-2016)
; Modified ......: MR.ViPER (12-2016), Fliegerfaust (03-2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func getArmyHeroTime($iHeroType, $bOpenArmyWindow = False, $bCloseArmyWindow = False)

	If $g_bDebugSetlogTrain Or $g_bDebugSetlog Then SetLog("Begin getArmyHeroTime:", $COLOR_DEBUG)

	$g_asHeroHealTime[0] = ""
	$g_asHeroHealTime[1] = ""
	$g_asHeroHealTime[2] = ""
	$g_asHeroHealTime[3] = ""

	; validate hero troop type input, must be hero enum value or "all"
	If $iHeroType <> $eHeroKing And $iHeroType <> $eHeroQueen And $iHeroType <> $eHeroWarden And $iHeroType <> $eHeroChampion And StringInStr($iHeroType, "all", $STR_NOCASESENSEBASIC) = 0 Then
		SetLog("getHeroTime slipped on banana, get doctor, tell him: " & $iHeroType, $COLOR_ERROR)
		SetError(1)
		Return
	EndIf

	If Not $bOpenArmyWindow And Not IsTrainPage() Then ; check for train page and open window if needed
		SetError(2)
		Return ; not open, not requested to be open - error.
	ElseIf $bOpenArmyWindow Then
		If Not OpenArmyOverview(True, "getArmyHeroTime()") Then
			SetError(3)
			Return ; not open, requested to be open - error.
		EndIf
		If _Sleep($DELAYCHECKARMYCAMP5) Then Return
	EndIf

	Local $iRemainTrainHeroTimer = 0, $sResultHeroTime
	Local $sResult
	Local $aResultHeroes[$eHeroCount] = ["", "", "", ""] ; array to hold all remaining regen time read via OCR
	;Local Const $aHeroStatusSlots[3][2] = [[658, 347], [732, 347], [805, 347]] ; Location of hero status check tile

	; Constant Array with OCR find location: [X pos, Y Pos, Text Name, Global enum value]
	Local Const $aHeroRemainData[$eHeroCount][4] = [[555, 414 + $g_iMidOffsetYFixed, "King", $eHeroKing], [627, 414 + $g_iMidOffsetYFixed, "Queen", $eHeroQueen], [700, 414 + $g_iMidOffsetYFixed, "Warden", $eHeroWarden], [772, 414 + $g_iMidOffsetYFixed, "Champion", $eHeroChampion]] ; Resolution changed

	For $index = 0 To UBound($aHeroRemainData) - 1 ;cycle through all 3 slots and hero types

		; check if OCR required
		If StringInStr($iHeroType, "all", $STR_NOCASESENSEBASIC) = 0 And $iHeroType <> $aHeroRemainData[$index][3] Then ContinueLoop

		; Check if slot has healing hero
		$sResult = ArmyHeroStatus($index) ; OCR slot for status information
		If $sResult <> "" Then ; we found something
			If StringInStr($sResult, "heal", $STR_NOCASESENSEBASIC) = 0 Then
				If $g_bDebugSetlogTrain Or $g_bDebugSetlog Then
					SetLog("Hero slot#" & $index + 1 & " status: " & $sResult & " :skip time read", $COLOR_PURPLE)
				EndIf
				ContinueLoop ; if do not find hero healing, then do not read time
			Else
				If $g_bDebugSetlogTrain Or $g_bDebugSetlog Then SetLog("Hero slot#" & $index + 1 & " status: " & $sResult, $COLOR_DEBUG)
			EndIf
		Else
			SetLog("Hero slot#" & $index + 1 & " Status read problem!", $COLOR_ERROR)
		EndIf

		$sResult = getRemainTHero($aHeroRemainData[$index][0], $aHeroRemainData[$index][1]) ;Get Hero training time via OCR.

		If $sResult <> "" Then

			$aResultHeroes[$index] = ConvertOCRTime($aHeroRemainData[$index][2] & " recover" , $sResult, False) ; update global array
			;If _DateDiff("h", $g_aiHeroBoost[$index], _NowCalc()) < 1 Then $aResultHeroes[$index] /= 4 ; Check if Bot boosted Heroes and boost is still active and if it is then reduce heal time ;)

			SetLog("Remaining " & $aHeroRemainData[$index][2] & " recover time: " & StringFormat("%.2f", $aResultHeroes[$index]), $COLOR_INFO)

			If $iHeroType = $aHeroRemainData[$index][3] Then ; if only one hero requested, then set return value and exit loop
				$iRemainTrainHeroTimer = Number($aResultHeroes[$index])
				ExitLoop
			EndIf
		Else ; empty OCR value
			If $iHeroType = $aHeroRemainData[$index][3] Then ; only one hero value?
				SetLog("Can not read remaining " & $aHeroRemainData[$index][2] & " recover time", $COLOR_RED)
			Else
				; reading all heros, need to find if hero is active/wait to determine how to log message?
				For $pMatchMode = $DB To $g_iMatchMode - 1 ; check all attack modes
					If IsUnitUsed($pMatchMode, $aHeroRemainData[$index][3]) And BitAND($g_aiAttackUseHeroes[$pMatchMode], $g_aiSearchHeroWaitEnable[$pMatchMode]) = $g_aiSearchHeroWaitEnable[$pMatchMode] Then ; check if Hero enabled to wait
						SetLog("Can not read remaining " & $aHeroRemainData[$index][2] & " train time", $COLOR_ERROR)
						ExitLoop
					Else
						If $g_bDebugSetlogTrain Or $g_bDebugSetlog Then SetLog("Bad read remain " & $aHeroRemainData[$index][2] & " recover time, but not enabled", $COLOR_DEBUG)
					EndIf
				Next
			EndIf
		EndIf
	Next

	If $bCloseArmyWindow Then
		ClickAway()
		If _Sleep($DELAYCHECKARMYCAMP4) Then Return
	EndIf

	; Determine proper return value
	If $iHeroType = $eHeroKing Or $iHeroType = $eHeroQueen Or $iHeroType = $eHeroWarden Or $iHeroType = $eHeroChampion Then
		Return $iRemainTrainHeroTimer ; return one requested hero value
	ElseIf StringInStr($iHeroType, "all", $STR_NOCASESENSEBASIC) > 0 Then
		; Set Time Array for PickupHealedHeroes
		For $i = 0 To $eHeroCount - 1
			If $aResultHeroes[$i] <> "" and $aResultHeroes[$i] > 0 Then $g_asHeroHealTime[$i] = _DateAdd("s", Int($aResultHeroes[$i]) * 60, _NowCalc())
			SetDebugLog($aHeroRemainData[$i][2] & " heal time: " & $g_asHeroHealTime[$i])
		Next
		; calling function needs to check if heroattack enabled & herowait enabled for attack mode used!
		Return $aResultHeroes ; return array of with each hero regen time value
	EndIf

EndFunc   ;==>getArmyHeroTime