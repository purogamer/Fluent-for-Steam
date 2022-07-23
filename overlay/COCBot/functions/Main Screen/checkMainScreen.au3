; #FUNCTION# ====================================================================================================================
; Name ..........: checkMainScreen
; Description ...: Checks whether the pixel, located in the eyes of the builder in mainscreen, is available
;						If it is not available, it calls checkObstacles and also waitMainScreen.
; Syntax ........: checkMainScreen([$bSetLog = True], [$bBuilderBase = False])
; Parameters ....: $bCheck: [optional] Sets a Message in Bot Log. Default is True  - $bBuilderBase: [optional] Use CheckMainScreen for Builder Base instead of normal Village. Default is False
; Return values .: None
; Author ........:
; Modified ......: KnowJack (07-2015) , TheMaster1st(2015), Fliegerfaust (06-2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......: checkObstacles(), waitMainScreen()
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func checkMainScreen($bSetLog = Default, $bBuilderBase = Default) ;Checks if in main screen
	FuncEnter(checkMainScreen)
	Return FuncReturn(_checkMainScreen($bSetLog, $bBuilderBase))
EndFunc   ;==>checkMainScreen

Func _checkMainScreen($bSetLog = Default, $bBuilderBase = Default) ;Checks if in main screen

	If $bSetLog = Default Then $bSetLog = True
	If $bBuilderBase = Default Then $bBuilderBase = $g_bStayOnBuilderBase

	Local $i, $iErrorCount, $iCheckBeforeRestartAndroidCount, $bObstacleResult, $bContinue
	Local $aPixelToCheck = $aIsMain

	If $bSetLog Then
		SetLog("Trying to locate Main Screen")
	EndIf

	If Not TestCapture() Then
		If CheckAndroidRunning(False) = False Then Return False
		getBSPos() ; Update $g_hAndroidWindow and Android Window Positions
		WinGetAndroidHandle()
		If Not $g_bChkBackgroundMode And $g_hAndroidWindow <> 0 Then
			; ensure android is top
			AndroidToFront(Default, "checkMainScreen")
		EndIf
		If $g_bAndroidAdbScreencap = False And _WinAPI_IsIconic($g_hAndroidWindow) Then WinSetState($g_hAndroidWindow, "", @SW_RESTORE)
	EndIf

	$i = 0
	$iErrorCount = 0
	$iCheckBeforeRestartAndroidCount = 5

	If $bBuilderBase Then $aPixelToCheck = $aIsOnBuilderBase
	Local $bLocated
	While _CaptureRegions() And Not _checkMainScreenImage($bLocated, $aPixelToCheck)
		$i += 1
		If TestCapture() Then
			SetLog("Main Screen not Located", $COLOR_ERROR)
			ExitLoop
		EndIf
		WinGetAndroidHandle()

		$bObstacleResult = checkObstacles($bBuilderBase)
		SetDebugLog("CheckObstacles[" & $i & "] Result = " & $bObstacleResult, $COLOR_DEBUG)

		$bContinue = False
		If Not $bObstacleResult Then
			If $g_bMinorObstacle Then
				$g_bMinorObstacle = False
				$bContinue = True
			Else
				If $i > $iCheckBeforeRestartAndroidCount Then
					SaveDebugImage("checkMainScreen_RestartCoC", False) ; why do we need to restart ?
					RestartAndroidCoC() ; Need to try to restart CoC
					$bContinue = True
				EndIf
			EndIf
		Else
			$g_bRestart = True
			$bContinue = True
		EndIf
		If $bContinue Then
			waitMainScreen() ; Due to differeneces in PC speed, let waitMainScreen test for CoC restart
			If Not $g_bRunState Then Return False
			If @extended Then Return SetError(1, 1, False)
			If @error Then $iErrorCount += 1
			If $iErrorCount > 2 Then
				SetLog("Unable to fix the window error", $COLOR_ERROR)
				CloseCoC(True)
				ExitLoop
			EndIf
		Else
			If _Sleep($DELAYCHECKMAINSCREEN1) Then Return
		EndIf
	WEnd
	
	If $bLocated Then
		; check that shared_prefs are pulled
		If $g_bUpdateSharedPrefs And Not HaveSharedPrefs() Then PullSharedPrefs()
		ZoomOut()
	EndIf
	If Not $g_bRunState Then Return False

	If $bSetLog Then
		If $bLocated Then
			SetLog("Main Screen located", $COLOR_SUCCESS)
		Else
			SetLog("Main Screen not located", $COLOR_ERROR)
		EndIf
	EndIf

	;After checkscreen dispose windows
	DisposeWindows()

	;Execute Notify Pending Actions
	NotifyPendingActions()

	Return $bLocated
EndFunc   ;==>_checkMainScreen

Func _checkMainScreenImage(ByRef $bLocated, $aPixelToCheck, $bNeedCaptureRegion = $g_bNoCapturePixel)
	$bLocated = _CheckPixel($aPixelToCheck, $bNeedCaptureRegion) And Not checkObstacles_Network(False, False) ; And checkChatTabPixel() ; Resolution changed
	Return $bLocated
EndFunc
#cs
Func checkChatTabPixel()
	SetDebugLog("Checking chat tab pixel exists to ensure images have loaded correctly")
	ZoomOut()
	If _Sleep(500) Then Return
	; re
	Local $aChatTabPixel = decodeSingleCoord(findImage("ChatTabPixel", $g_sImgChatTabPixel, GetDiamondFromRect("0,406(50,300)"), 1, True)) ; Resolution changed boldina: this thing never worked on this manner
	If UBound($aChatTabPixel) > 0 Then 
		SetDebugLog("ChatTabPixel found", $COLOR_SUCCESS)
		Return True
	Else
		SetLog("ChatTabPixel not found", $COLOR_ERROR)
	EndIf
	Return False
EndFunc   ;==>checkChatTabPixel
#ce
Func isOnMainVillage($bNeedCaptureRegion = $g_bNoCapturePixel)
	Local $aPixelToCheck = $aIsMain
	Local $bLocated = False
	Return _checkMainScreenImage($bLocated, $aPixelToCheck)
EndFunc