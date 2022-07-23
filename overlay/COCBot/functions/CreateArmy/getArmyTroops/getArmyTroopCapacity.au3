; #FUNCTION# ====================================================================================================================
; Name ..........: getArmyTroopCapacity
; Description ...: Obtains current and total capacity of troops from Training - Army Overview window
; Syntax ........: getArmyTroopCapacity([$bOpenArmyWindow = False[, $bCloseArmyWindow = False]])
; Parameters ....: $bOpenArmyWindow     - [optional] a boolean value. Default is False.
;                  $bCloseArmyWindow    - [optional] a boolean value. Default is False.
; Return values .: None
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func getArmyTroopCapacity($bOpenArmyWindow = False, $bCloseArmyWindow = False, $bCheckWindow = True, $bSetLog = True, $bNeedCapture = True)

	If $g_bDebugSetlogTrain Then SetLog("getArmyTroopsCapacity():", $COLOR_DEBUG1)

	If $bCheckWindow Then
		If Not $bOpenArmyWindow And Not IsTrainPage() Then ; check for train page
			SetError(1)
			Return ; not open, not requested to be open - error.
		ElseIf $bOpenArmyWindow Then
			If Not OpenArmyOverview(True, "getArmyTroopCapacity()") Then
				SetError(2)
				Return ; not open, requested to be open - error.
			EndIf
			If _Sleep($DELAYCHECKARMYCAMP5) Then Return
		EndIf
	EndIf

	Local $aGetArmyCap[3] = ["", "", ""]
	Local $sArmyInfo = ""
	Local $iCount = 0
	Local $sInputbox, $iHoldCamp
	Local $tmpTotalCamp = 0
	Local $tmpCurCamp = 0

	; Verify troop current and full capacity
	$sArmyInfo = getArmyCampCap($aArmyCampSize[0], $aArmyCampSize[1], $bNeedCapture) ; OCR read army trained and total
	
	While $iCount < 100 ; 15 - 20 sec

		$iCount += 1
		If _Sleep($DELAYCHECKARMYCAMP5) Then Return ; Wait 250ms before reading again
		ForceCaptureRegion()
		$sArmyInfo = getArmyCampCap($aArmyCampSize[0], $aArmyCampSize[1], $bNeedCapture) ; OCR read army trained and total
		If $g_bDebugSetlogTrain Then SetLog("OCR $sArmyInfo = " & $sArmyInfo, $COLOR_DEBUG)
		If StringInStr($sArmyInfo, "#", 0, 1) < 2 Then ContinueLoop ; In case the CC donations recieved msg are blocking, need to keep checking numbers till valid

		$aGetArmyCap = StringSplit($sArmyInfo, "#") ; split the trained troop number from the total troop number
		If IsArray($aGetArmyCap) Then
			If $aGetArmyCap[0] > 1 Then ; check if the OCR was valid and returned both values
				If Number($aGetArmyCap[2]) < 10 Or Mod(Number($aGetArmyCap[2]), 5) <> 0 Then ; check to see if camp size is multiple of 5, or try to read again
					If $g_bDebugSetlogTrain Then SetLog(" OCR value is not valid camp size", $COLOR_DEBUG)
					ContinueLoop
				EndIf
				$tmpCurCamp = Number($aGetArmyCap[1])
				If $g_bDebugSetlogTrain Then SetLog("$tmpCurCamp = " & $tmpCurCamp, $COLOR_DEBUG)
				$tmpTotalCamp = Number($aGetArmyCap[2])
				If $iHoldCamp = $tmpTotalCamp And $g_bIgnoreIncorrectTroopCombo = True And Not $g_bQuickTrainEnable Then
					$g_iTotalCampSpace = Number($tmpTotalCamp)
					$g_iTotalCampForcedValue = $g_iTotalCampSpace
					ExitLoop ; check to make sure the OCR read value is same in 2 reads before exit
				ElseIf $iHoldCamp = $tmpTotalCamp Then
					ExitLoop ; check to make sure the OCR read value is same in 2 reads before exit
				EndIf
				$iHoldCamp = $tmpTotalCamp ; Store last OCR read value
			EndIf
		EndIf

	WEnd 
	
	If $iCount <= 99 Then
		$g_CurrentCampUtilization = $tmpCurCamp
		If $g_iTotalCampSpace = 0 Then $g_iTotalCampSpace = $tmpTotalCamp
		If $g_bDebugSetlogTrain Then SetLog("$g_CurrentCampUtilization = " & $g_CurrentCampUtilization & ", $g_iTotalCampSpace = " & $g_iTotalCampSpace, $COLOR_DEBUG)
	Else
		SetLog("Army size read error, Troop numbers may not train correctly", $COLOR_ERROR) ; log if there is read error
		$g_CurrentCampUtilization = 0
		CheckOverviewFullArmy()
	EndIf

    If $g_iTotalCampSpace = 0 Then ; if Total camp size is still not set or value not same as read use forced value
		Local $proposedTotalCamp = $tmpTotalCamp
		If $g_iTotalCampSpace > $tmpTotalCamp Then $proposedTotalCamp = $g_iTotalCampSpace
		$sInputbox = InputBox("Question", _
				"Enter your total Army Camp capacity." & @CRLF & @CRLF & _
				"Please check it matches with total Army Camp capacity" & @CRLF & _
				"you see in Army Overview right now in Android Window:" & @CRLF & _
				$g_sAndroidTitle & @CRLF & @CRLF & _
				"(This window closes in 2 Minutes with value of " & $proposedTotalCamp & ")", $proposedTotalCamp, "", 330, 220, Default, Default, 120, $g_hFrmBot)
		Local $error = @error
		If $error = 1 Then
			SetLog("Army Camp User input cancelled, still using " & $g_iTotalCampSpace, $COLOR_ACTION)
		Else
			If $error = 2 Then
				; Cancelled, using proposed value
				$g_iTotalCampSpace = (Number($proposedTotalCamp) = 0) ? (300) : (Number($proposedTotalCamp))
			Else
				$g_iTotalCampSpace = Number($sInputbox)
			EndIf
			If $error = 0 Then
				$g_iTotalCampForcedValue = $g_iTotalCampSpace
				$g_bTotalCampForced = True
				SetLog("Army Camp User input = " & $g_iTotalCampSpace, $COLOR_INFO)
			Else
				; timeout
				SetLog("Army Camp proposed value = " & $g_iTotalCampSpace, $COLOR_ERROR)
			EndIf
		EndIf
    EndIf

	If $g_bIgnoreIncorrectTroopCombo = True And Not $g_bQuickTrainEnable And $g_iTotalCampSpace > 0 Then FixInDoubleTrain($g_aiArmyCompTroops, $g_iTotalCampSpace, $g_aiTroopSpace, TroopIndexLookup($g_sCmbFICTroops[$g_iCmbFillIncorrectTroopCombo][0], "getArmyTroopCapacity"))
					
	If $g_bDebugSetlogTrain Then SetLog("$g_iTotalCampSpace = " & $g_iTotalCampSpace & ", Camp OCR = " & $tmpTotalCamp, $COLOR_DEBUG)

	If $g_iTotalCampSpace > 0 Then
		If $bSetLog Then SetLog("Total Army Camp Capacity: " & $g_CurrentCampUtilization & "/" & $g_iTotalCampSpace & " (" & Int($g_CurrentCampUtilization / $g_iTotalCampSpace * 100) & "%)")
		$g_iArmyCapacity = Int($g_CurrentCampUtilization / $g_iTotalCampSpace * 100)
	Else
		If $bSetLog Then SetLog("Total Army Camp Capacity: " & $g_CurrentCampUtilization & "/" & $g_iTotalCampSpace)
		$g_iArmyCapacity = 0
	EndIf

	If ($g_CurrentCampUtilization >= ($g_iTotalCampSpace * $g_iTrainArmyFullTroopPct / 100)) Then
		$g_bFullArmy = True
	Else
		$g_bFullArmy = False
		$g_bIsFullArmywithHeroesAndSpells = False
	EndIf

	If $g_CurrentCampUtilization >= $g_iTotalCampSpace * $g_aiSearchCampsPct[$DB] / 100 And $g_abSearchCampsEnable[$DB] And IsSearchModeActive($DB) Then $g_bFullArmy = True
	If $g_CurrentCampUtilization >= $g_iTotalCampSpace * $g_aiSearchCampsPct[$LB] / 100 And $g_abSearchCampsEnable[$LB] And IsSearchModeActive($LB) Then $g_bFullArmy = True

	If $bCloseArmyWindow Then
		ClickAway()
		If _Sleep($DELAYCHECKARMYCAMP4) Then Return
	EndIf

EndFunc   ;==>getArmyTroopCapacity
