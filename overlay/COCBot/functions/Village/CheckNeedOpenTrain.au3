; #FUNCTION# ====================================================================================================================
; Name ..........: CheckNeedOpenTrain
; Description ...:
; Syntax ........: CheckNeedOpenTrain($TimeBeforeTrain)
; Parameters ....: $TimeBeforeTrain   - Time in second Used to know is train is needed.
; Return values .: True/False
; Author ........: Boju (01-2017)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func CheckNeedOpenTrain($TimeBeforeTrain)
	Local $bToReturn = False
	Local $QuickArmyCamps = 100
	If $g_abSearchCampsEnable[$DB] Then
		If $g_aiSearchCampsPct[$DB] < $QuickArmyCamps Then $QuickArmyCamps = $g_aiSearchCampsPct[$DB]
		If $g_aiSearchCampsPct[$DB] - Int($g_CurrentCampUtilization / $g_iTotalCampSpace * 100) < $QuickArmyCamps Then $QuickArmyCamps = $g_aiSearchCampsPct[$DB] - Int($g_CurrentCampUtilization / $g_iTotalCampSpace * 100)
	EndIf
	If $g_abSearchCampsEnable[$LB] Then
		If $g_aiSearchCampsPct[$LB] < $QuickArmyCamps Then $QuickArmyCamps = $g_aiSearchCampsPct[$LB]
		If $g_aiSearchCampsPct[$LB] - Int($g_CurrentCampUtilization / $g_iTotalCampSpace * 100) < $QuickArmyCamps Then $QuickArmyCamps = $g_aiSearchCampsPct[$LB] - Int($g_CurrentCampUtilization / $g_iTotalCampSpace * 100)
	EndIf

	If $g_aiTimeTrain[0] = 0 Then $bToReturn = True

	Local $sNowTime = ""
	Local $iTimeBeforeTrain1, $iTimeBeforeTrain2
	$sNowTime = _NowCalc()
	If $TimeBeforeTrain = "" Then $TimeBeforeTrain = $sNowTime
	$iTimeBeforeTrain1 = _DateAdd("s", Int(($g_aiTimeTrain[0] * 60) * ($QuickArmyCamps / 100)), $TimeBeforeTrain)
	$iTimeBeforeTrain2 = _DateDiff("s", $sNowTime, $iTimeBeforeTrain1)
	If $g_bDebugSetlogTrain Then
		SetLog("Start Train: " & $TimeBeforeTrain)
		SetLog("Now: " & $sNowTime)
		SetLog("Train end time: " & $iTimeBeforeTrain1)
		SetLog("Next Train in S: " & $iTimeBeforeTrain2)
	EndIf
	
	; Custom train - Team AIO Mod++
	If $iTimeBeforeTrain2 < Int($g_iStickToTrainWindow * 60) Then $bToReturn = True
	
	If $iTimeBeforeTrain2 <= 0 Then $bToReturn = True
	If ($g_iActiveDonate Or $g_bDonationEnabled) And $g_bChkDonate Then $bToReturn = True
	If Not $bToReturn Then SetLog("Train end time: " & $iTimeBeforeTrain1, $COLOR_DEBUG)
	If Not $bToReturn Then ClickAway()

	Return $bToReturn
EndFunc   ;==>CheckNeedOpenTrain
