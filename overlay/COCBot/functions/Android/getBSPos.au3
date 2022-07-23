; #FUNCTION# ====================================================================================================================
; Name ..........: getBSPos
; Description ...: Gets the postiion of of the Bluestacks window, attempts to open BS if not available, or closes MBR if it can not to avoid AutoIt internal error
; Syntax ........: getBSPos()
; Parameters ....:
; Return values .: None
; Author ........:
; Modified ......: KnowJack(07-2015)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func getBSPos()
	Local $SuspendMode = ResumeAndroid()
	Local $Changed = False, $aOldValues[4]
	Local $hWin = $g_hAndroidWindow
	WinGetAndroidHandle()
	If $g_bAndroidBackgroundLaunched = False Then
		getAndroidPos(True)
	Else
		SetError($g_hAndroidWindow = 0 ? 1 : 0)
	EndIf

	If @error = 1 Then
		If Not $g_bRunState Then Return
		SetError(0, 0, 0)
		If $hWin = 0 Then
			OpenAndroid(True)
		Else
			RebootAndroid()
		EndIf
		If $g_bAndroidBackgroundLaunched = False Then
			getAndroidPos(True)
		Else
			SetError($g_hAndroidWindow = 0 ? 1 : 0)
		EndIf
		If Not $g_bRunState Then Return
		If @error = 1 Then
			_ExtMsgBoxSet(1 + 64, $SS_CENTER, 0x004080, 0xFFFF00, 12, "Comic Sans MS", 600)
			Local $stext = @CRLF & GetTranslatedFileIni("MBR Popups", "sText_01", "MyBot has experienced a serious error") & @CRLF & @CRLF & _
					GetTranslatedFileIni("MBR Popups", "sText_02", "Unable to find or start up ") & $g_sAndroidEmulator & @CRLF & @CRLF & GetTranslatedFileIni("MBR Popups", "sText_03", "Reboot PC and try again,") & _
					GetTranslatedFileIni("MBR Popups", "sText_04", "and search www.mybot.run forums for more help") & @CRLF
			Local $MsgBox = _ExtMsgBox(0, GetTranslatedFileIni("MBR Popups", "sText_05", "Close MyBot!"), GetTranslatedFileIni("MBR Popups", "sText_06", "Okay - Must Exit Program"), $stext, 15, $g_hFrmBot)
			If $MsgBox = 1 Then
				BotClose()
			EndIf
		EndIf
	EndIf
	If @error = 1 Then
		If Not $g_bRunState Then Return
		SetError(0, 0, 0)
		If $hWin = 0 Then
			OpenAndroid(True) ; Try to start Android if it is not running
		Else
			RebootAndroid()
		EndIf
		Return
	EndIf
	If $g_bAndroidBackgroundLaunched = True Then
		SuspendAndroid($SuspendMode, False)
		Return
	EndIf
	$aOldValues[0] = $g_aiBSpos[0]
	$aOldValues[1] = $g_aiBSpos[1]
	$aOldValues[2] = $g_aiBSrpos[0]
	$aOldValues[3] = $g_aiBSrpos[1]

	Local $aPos = getAndroidPos()
	If Not IsArray($aPos) Then
		If Not $g_bRunState Then Return
		If $hWin = 0 Then
			OpenAndroid(True) ; Try to start Android if it is not running
		Else
			RebootAndroid()
		EndIf
		$aPos = getAndroidPos(True)
		If Not $g_bRunState Then Return
		If @error = 1 Then
			_ExtMsgBoxSet(1 + 64, $SS_CENTER, 0x004080, 0xFFFF00, 12, "Comic Sans MS", 600)
			$stext = @CRLF & GetTranslatedFileIni("MBR Popups", "sText_01", "MyBot has experienced a serious error") & @CRLF & @CRLF & _
					GetTranslatedFileIni("MBR Popups", "sText_02", "Unable to find or start up") & " " & $g_sAndroidEmulator & @CRLF & @CRLF & GetTranslatedFileIni("MBR Popups", "sText_03", "Reboot PC and try again,") & _
					GetTranslatedFileIni("MBR Popups", "sText_04", "and search www.mybot.run forums for more help") & @CRLF
			$MsgBox = _ExtMsgBox(0, GetTranslatedFileIni("MBR Popups", "sText_05", "Close MyBot!"), GetTranslatedFileIni("MBR Popups", "sText_06", "Okay - Must Exit Program"), $stext, 15, $g_hFrmBot)
			If $MsgBox = 1 Then
				BotClose()
				Return
			EndIf
		EndIf
	EndIf

	If IsArray($aPos) Then
		Local $tPoint = DllStructCreate("int X;int Y")
		DllStructSetData($tPoint, "X", $aPos[0])
		If @error <> 0 Then
			$tPoint = 0
			Return SetError(0, 0, 0)
		EndIf

		DllStructSetData($tPoint, "Y", $aPos[1])
		If @error <> 0 Then
			$tPoint = 0
			Return SetError(0, 0, 0)
		EndIf

		_WinAPI_ClientToScreen(GetCurrentAndroidHWnD(), $tPoint)
		If @error <> 0 Then
			$tPoint = 0
			Return SetError(0, 0, 0)
		EndIf

		$g_aiBSpos[0] = DllStructGetData($tPoint, "X")
		If @error <> 0 Then
			$tPoint = 0
			Return SetError(0, 0, 0)
		EndIf

		$g_aiBSpos[1] = DllStructGetData($tPoint, "Y")
		If @error <> 0 Then
			$tPoint = 0
			Return SetError(0, 0, 0)
		EndIf

		$g_aiBSrpos[0] = $aPos[0]
		$g_aiBSrpos[1] = $aPos[1]

		$tPoint = 0

		$Changed = Not ($aOldValues[0] = $g_aiBSpos[0] And $aOldValues[1] = $g_aiBSpos[1] And $aOldValues[2] = $g_aiBSrpos[0] And $aOldValues[3] = $g_aiBSrpos[1])
		If $g_bDebugClick Or $g_bDebugSetlog And $Changed Then SetLog("$g_aiBSpos X,Y = " & $g_aiBSpos[0] & "," & $g_aiBSpos[1] & "; $g_aiBSrpos X,Y = " & $g_aiBSrpos[0] & "," & $g_aiBSrpos[1], $COLOR_ERROR, "Verdana", "7.5", 0)
	EndIf

	SuspendAndroid($SuspendMode, False)
EndFunc   ;==>getBSPos

Func getAndroidPos($FastCheck = False, $RetryCount1 = 0, $RetryCount2 = 0, $bWidthFirst = Default)
	Static $asControlSize[6][4]
	If $g_bAndroidControlUseParentPos Then
		; If true, control pos is used from parent control (only used to fix docking for Nox in DirectX mode)
		Local $hCtrl = ControlGetHandle(GetCurrentAndroidHWnD(), $g_sAppPaneName, GetAndroidControlClass(True))
		Local $hCtrlParent = _WinAPI_GetParent($hCtrl)
		Local $aControlSize = ControlGetPos(GetCurrentAndroidHWnD(), "", $hCtrlParent)
	Else
		Local $aControlSize = ControlGetPos(GetCurrentAndroidHWnD(), $g_sAppPaneName, GetAndroidControlClass(True))
	EndIf
	Local $aControlSizeInitial = $aControlSize

	;If Not $g_bRunState Or $FastCheck Then Return $aControlSize
	If $FastCheck Then Return $aControlSize

	If AndroidMakeDpiAware() Then AndroidDpiAwareness() ; enforce DPI Awareness if required

	Local $sPre = "(" & $RetryCount1 & "/" & $RetryCount2 & ") "
	Local $bResizedOk = False
	If IsArray($aControlSize) Then ; Is Android Client Control available?

		If ($aControlSize[2] <> $g_iAndroidClientWidth Or $aControlSize[3] <> $g_iAndroidClientHeight) And $RetryCount1 = 0 And $RetryCount2 = 0 Then ; Is Client size correct?
			; ensure Android Window and Screen sizes are up-to-date
			UpdateAndroidWindowState()
			; prepare local static variable for retry count
			If $RetryCount1 = 0 Then
				For $i = 0 To 5
					For $j = 0 To 3
						$asControlSize[$i][$j] = 0
					Next
				Next
			EndIf
		EndIf

		If $aControlSize[2] <> $g_iAndroidClientWidth Or $aControlSize[3] <> $g_iAndroidClientHeight Then ; Is Client size correct?
			If $RetryCount1 < 6 Then
				For $i = 0 To 3
					$asControlSize[$RetryCount1][$i] = $aControlSize[$i]
				Next
			EndIf
			;DisposeWindows()
			;WinActivate($g_hAndroidWindow)
			SetDebugLog($sPre & "Unsupported " & $g_sAndroidEmulator & " screen size of " & $aControlSize[2] & " x " & $aControlSize[3] & " at " & $aControlSize[0] & ", " & $aControlSize[1]  & " (expect " & $g_iAndroidClientWidth & " x " & $g_iAndroidClientHeight & ")", $COLOR_ACTION)
			Local $aAdj0 = [0, 0]
			If $RetryCount1 = 0 And $RetryCount2 = 0 Then
				; resize window first to an invalid size
				Local $aWin = WinGetPos($g_hAndroidWindow)
				If UBound($aWin) > 2 Then
					Local $hCtrl = ControlGetHandle($g_hAndroidWindow, $g_sAppPaneName, $g_sAppClassInstance)
					;Local $hCtrlTarget = __WinAPI_GetParent($hCtrl)
					Local $fZoom = ($g_iAndroidClientWidth / $aControlSize[2] + $g_iAndroidClientHeight / $aControlSize[3]) / 2
					$aAdj0[0] = Int($aWin[2] * $fZoom) - $aWin[2]
					$aAdj0[1] = Int($aWin[3] * $fZoom) - $aWin[3]
					WinMove2($g_hAndroidWindow, "", $aWin[0], $aWin[1], $aWin[2] + $aAdj0[0], $aWin[3] + $aAdj0[1])
					;WinMove2($hCtrlTarget, "", -1, -1, Round($aControlSize[2] * $fZoom, 0), Round($aControlSize[3] * $fZoom, 0))
					;WinMove($g_hAndroidWindow, "", $aWin[0], $aWin[1], $g_iAndroidWindowWidth - 1, $g_iAndroidWindowHeight - 1) ; first resize to expected/configured Window Size - 1
					;WinMove2($hCtrlTarget, "", -1, -1, $g_iAndroidClientWidth - 1, $g_iAndroidClientWidth - 1) ; first resize to expected/configured Window Size - 1
					RedrawAndroidWindow()
					;_WinAPI_RedrawWindow($hCtrlTarget, 0, 0, $RDW_INVALIDATE + $RDW_ALLCHILDREN)
					;_WinAPI_UpdateWindow($hCtrlTarget)
					$aControlSize = getAndroidPosWait($aControlSize)
				EndIf
			EndIf
			Local $bExpectControlResize = True

			; check if emultor window only needs resizing (problem with BS in lower Screen Resolutions!)
			Local $AndroidWinPos = WinGetPos($g_hAndroidWindow)
			If UBound($AndroidWinPos) < 4 Then
				; window not accessible
				Return
			EndIf
			Local $WinWidth = $AndroidWinPos[2] ; ($AndroidWinPos[2] > $AndroidWinPos[3]) ? $AndroidWinPos[2] : $AndroidWinPos[3]
			Local $WinHeight = $AndroidWinPos[3] ; ($AndroidWinPos[2] > $AndroidWinPos[3]) ? $AndroidWinPos[3] : $AndroidWinPos[2]

			Local $aAndroidWindow[2] = [$WinWidth, $WinHeight]
			Local $aAdj = [$g_iAndroidClientWidth - $aControlSize[2], $g_iAndroidClientHeight - $aControlSize[3]]
			Switch $RetryCount1
				Case 0
					; initial resize implementation
					; Compensate any controls surrounding the Android Client Control
					Local $tRECT = _WinAPI_GetClientRect($g_hAndroidWindow)
					If @error = 0 Then
						$aAndroidWindow[0] = $g_iAndroidWindowWidth
						$aAndroidWindow[1] = $g_iAndroidWindowHeight
						$aAdj[0] = $WinWidth - (DllStructGetData($tRECT, "Right") - DllStructGetData($tRECT, "Left"))
						$aAdj[1] = $WinHeight - (DllStructGetData($tRECT, "Bottom") - DllStructGetData($tRECT, "Top"))
					Else
						SetDebugLog($sPre & "WARNING: Cannot determine " & $g_sAndroidEmulator & " Window Client Area!", $COLOR_ERROR)
					EndIf
				Case 1
					; do both
				Case 2
					$bExpectControlResize = False
					If Abs($aControlSize[3] - $g_iAndroidClientHeight) = 0 Or Abs($aControlSize[2] - $g_iAndroidClientWidth) > 0 Then
						; adjust only width
						$aAdj[1] = 0
						$bWidthFirst = False
					Else
						; adjust only height
						$aAdj[0] = 0
						$bWidthFirst = True
					EndIf
				Case 3
					If $bWidthFirst = True Then
						$aAdj[1] = 0
					ElseIf $bWidthFirst = False Then
						$aAdj[0] = 0
					EndIf
				Case 4
					; it can happen that in hires DPI the Android Control cannot be resized to 860x732, so make Android DPI aware
					If CheckDpiAwareness(True) = False Then
						CheckDpiAwareness(False, True)
						AndroidDpiAwareness()
					EndIf
				Case 5
					; do both
			EndSwitch

			$aAndroidWindow[0] += $aAdj[0]
			$aAndroidWindow[1] += $aAdj[1]
			SetDebugLog($sPre & $g_sAndroidTitle & " Adjusted Window Size: " & $aAndroidWindow[0] & " x " & $aAndroidWindow[1] & " (by " & $aAdj[0] + $aAdj0[0] & ", " & $aAdj[1] + $aAdj0[1] & ")", $COLOR_INFO)

			If $bExpectControlResize And $RetryCount1 < 6 Then
				WinMove($g_hAndroidWindow, "", $AndroidWinPos[0], $AndroidWinPos[1], $aAndroidWindow[0] - 2, $aAndroidWindow[1] - 2) ; force invalid resize (triggers Android rendering control resize)
				;Sleep($DELAYSLEEP)
				$AndroidWinPos = WinGetPos($g_hAndroidWindow)
				If UBound($AndroidWinPos) > 3 Then
					$WinWidth = $AndroidWinPos[2]
					$WinHeight = $AndroidWinPos[3]
				EndIf
			EndIf

			If UBound($AndroidWinPos) > 3 Then ; Check expected Window size

				WinMove2($g_hAndroidWindow, "", $AndroidWinPos[0], $AndroidWinPos[1], $aAndroidWindow[0], $aAndroidWindow[1]) ; resized to expected window size
				;WinMove($g_hAndroidWindow, "", $AndroidWinPos[0], $AndroidWinPos[1], $aAndroidWindow[0], $aAndroidWindow[1])
				;_WinAPI_SetWindowPos($g_hAndroidWindow, 0, 0, 0, $g_iAndroidWindowWidth, $g_iAndroidWindowHeight, BitOr($SWP_NOACTIVATE, $SWP_NOMOVE, $SWP_NOREPOSITION, $SWP_NOSENDCHANGING, $SWP_NOZORDER)) ; resize window without BS changing it back
				Local $aNewControlSize = getAndroidPos(True)
				If UBound($aNewControlSize) > 2 Then
					;ControlMove($g_hAndroidWindow, $g_sAppPaneName, $g_sAppClassInstance, 0, 0, $g_iAndroidClientWidth, $g_iAndroidClientHeight)
					SetDebugLog($sPre & $g_sAndroidEmulator & " window resized to " & $aAndroidWindow[0] & " x " & $aAndroidWindow[1], $COLOR_SUCCESS)

					RedrawAndroidWindow()
					If $bExpectControlResize Then
						$aNewControlSize = getAndroidPosWait($aControlSize, $aNewControlSize)
					EndIf

					If UBound($aNewControlSize) > 2 Then
						; reload size
						$aControlSize = $aNewControlSize

						If $aControlSize[2] <> $g_iAndroidClientWidth Or $aControlSize[3] <> $g_iAndroidClientHeight Then
							If $bExpectControlResize = True Then
								If $g_bDebugSetlog Then
									SetDebugLog($sPre & $g_sAndroidEmulator & " window resize didn't work, screen is " & $aControlSize[2] & " x " & $aControlSize[3], $COLOR_ERROR)
								Else
									SetLog($g_sAndroidEmulator & " window resize didn't work, screen is " & $aControlSize[2] & " x " & $aControlSize[3], $COLOR_ERROR)
								EndIf
								If $RetryCount1 > 0 And $RetryCount1 < 6 And $RetryCount2 = 0 Then
									; early abort when cannot be resized
									Local $bXinc = $aControlSize[0] > $asControlSize[$RetryCount1][0] And $asControlSize[$RetryCount1][0] > $asControlSize[$RetryCount1 - 1][0]
									Local $bYinc = $aControlSize[1] > $asControlSize[$RetryCount1][1] And $asControlSize[$RetryCount1][1] > $asControlSize[$RetryCount1 - 1][1]
									If ($bXinc And Not $bYinc) Or (Not $bXinc And $bYinc) Or ($aControlSize[2] < $g_iAndroidClientWidth / 2 Or $aControlSize[2] > $g_iAndroidClientWidth * 1.5 Or $aControlSize[3] < $g_iAndroidClientHeight / 2 Or $aControlSize[3] > $g_iAndroidClientHeight * 1.5) Then
										SetLog($g_sAndroidEmulator & " window cannot be resized, abort", $COLOR_ERROR)
										Return $aControlSize
									EndIf
								EndIf
							EndIf
							; added for MEmu in hires with DPI > 100%
							If $RetryCount1 < 6 Then
								Sleep(250)
								Return getAndroidPos($FastCheck, $RetryCount1 + 1, $RetryCount2, $bWidthFirst)
							EndIf
						Else
							$bResizedOk = True
						EndIf
					Else
						; added for Nox that reports during launch a client size of 1x1
						If $RetryCount2 < 5 Then
							Sleep(250)
							Return getAndroidPos($FastCheck, $RetryCount1, $RetryCount2 + 1, $bWidthFirst)
						EndIf
					EndIf
				Else
					SetDebugLog($sPre & "WARNING: Cannot resize " & $g_sAndroidEmulator & " window to " & $aAndroidWindow[0] & " x " & $aAndroidWindow[1], $COLOR_ERROR)
				EndIf

			Else
				; added for Nox that reports during launch a client size of 1x1
				If $RetryCount2 < 5 Then
					Sleep(250)
					Return getAndroidPos($FastCheck, $RetryCount1, $RetryCount2 + 1, $bWidthFirst)
				EndIf
			EndIf

		ElseIf $RetryCount1 > 0 Or $RetryCount2 > 0 Then
			$bResizedOk = True
		EndIf

	Else
		SetDebugLog($sPre & "WARNING: Cannot resize " & $g_sAndroidEmulator & " window, control '" & $g_sAppClassInstance & "' not available", $COLOR_ERROR)
	EndIf

	If $bResizedOK Then
		;RedrawAndroidWindow()
		If $g_bDebugSetlog Then
			SetDebugLog($sPre & $g_sAndroidEmulator & " window resized to work with MyBot", $COLOR_SUCCESS)
		Else
			SetLog($g_sAndroidEmulator & " window resized to work with MyBot", $COLOR_SUCCESS)
		EndIf
		#cs
		Local $hCtrl = ControlGetHandle($g_hAndroidWindow, $g_sAppPaneName, $g_sAppClassInstance)
		Local $hCtrlTarget = __WinAPI_GetParent($hCtrl)
		Local $aCtrlTargetPos = ControlGetPos($g_hAndroidWindow, "", $hCtrlTarget)
		If $hCtrl And $hCtrlTarget And UBound($aCtrlTargetPos) > 2 Then
			;_WinAPI_RedrawWindow($hCtrl, 0, 0, $RDW_INVALIDATE + $RDW_ALLCHILDREN)
			;_WinAPI_UpdateWindow($hCtrl)
			RedrawAndroidWindow()
			;WinMove($hCtrlTarget, "", -1, -1, $aCtrlTargetPos[2] - 1, $aCtrlTargetPos[3] - 1)
			;WinMove2($hCtrlTarget, "", -1, -1, $aCtrlTargetPos[2] - 1, $aCtrlTargetPos[3] - 1)
			;WinMove2($hCtrl, "", -1, -1, $aControlSize[2] - 1, $aControlSize[3] - 1, $HWND_BOTTOM)
			;WinMove2($hCtrl, "", -1, -1, $aControlSize[2], $aControlSize[3], 0, 0, False)
			;WinMove2($hCtrlTarget, "", -1, -1, $aCtrlTargetPos[2], $aCtrlTargetPos[3], 0, 0, False)
			SetLog($sPre & $g_sAndroidEmulator & " window resized to work with MyBot", $COLOR_SUCCESS)
		Else
			SetDebugLog($sPre & "WARNING: Cannot resize " & $g_sAndroidEmulator & " window, control is not available", $COLOR_ERROR)
		EndIf
		#ce
	EndIf

	Return $aControlSize

EndFunc   ;==>getAndroidPos

Func getAndroidPosWait(ByRef $aControlSize, $aNewControlSize = 0)
	If UBound($aNewControlSize) < 4 Then $aNewControlSize = getAndroidPos(True)
	; wait 3 Sec. till window client content is resized also

	Local $hTimer = __TimerInit()
	While __TimerDiff($hTimer) < 3000 And UBound($aNewControlSize) > 2 And ($aControlSize[2] = $aNewControlSize[2] Or $aControlSize[3] = $aNewControlSize[3]) And $aNewControlSize[2] <> $g_iAndroidClientWidth And $aNewControlSize[3] <> $g_iAndroidClientHeight
		Sleep($DELAYSLEEP)
		$aNewControlSize = getAndroidPos(True)
	WEnd
	Return $aNewControlSize
EndFunc   ;==>getAndroidPosWait