; #FUNCTION# ====================================================================================================================
; Name ..........: AndroidEmbed
; Description ...: This file contains the fucntions to dock Android into Bot window and handle shield.
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Cosote (07-2016)
; Modified ......: CodeSlinger69 (01-2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Global $g_aiAndroidEmbeddedGraphics[0][2] ; Array for GDI objects when drawing on Android Shield

; Return Android window handle containing the Android rendering control
Func GetCurrentAndroidHWnD()
	Local $h = (($g_bAndroidEmbedded = False Or $g_iAndroidEmbedMode = 1) ? $g_hAndroidWindow : $g_hFrmBot)
	Return $h
EndFunc   ;==>GetCurrentAndroidHWnD

; Return the window handle displaying the Android content
Func GetAndroidDisplayHWnD()
	Local $h = (($g_bAndroidEmbedded = False) ? $g_hAndroidWindow : $g_hFrmBot)
	Return $h
EndFunc   ;==>GetAndroidDisplayHWnD

; Syncronized _AndroidEmbed
Func AndroidEmbed($Embed = True, $CallWinGetAndroidHandle = True, $bForceEmbed = False, $bNoAndroidScreenSizeCheck = False)
	If $g_iGuiMode <> 1 Then Return False
	If $g_bAndroidEmbed = False Then Return False
	Return _AndroidEmbed($Embed, $CallWinGetAndroidHandle, $bForceEmbed, $bNoAndroidScreenSizeCheck)
	#cs
	Local $hMutex = AcquireMutex("AndroidEmbed", Default, 1000)
	If $hMutex <> 0 Then
		Return ReleaseMutex($hMutex, _AndroidEmbed($Embed, $CallWinGetAndroidHandle, $bForceEmbed, $bNoAndroidScreenSizeCheck))
	EndIf
	Return False
	#ce
EndFunc   ;==>AndroidEmbed

Func _AndroidEmbed($Embed = True, $CallWinGetAndroidHandle = True, $bForceEmbed = False, $bNoAndroidScreenSizeCheck = False)

	If ($CallWinGetAndroidHandle = False And $g_hAndroidWindow = 0) Or ($CallWinGetAndroidHandle = True And WinGetAndroidHandle() = 0) Then
		SetDebugLog("Android Emulator not launched", $COLOR_ERROR)
		If $g_bAndroidEmbedded = False Then
			; nothing to do
			updateBtnEmbed()
			Return False
		Else
			; detach android
			If $Embed = True Then
				SetDebugLog("Docked Android Window not available, force undock", $COLOR_ERROR)
				$Embed = False
			EndIf
		EndIf
	EndIf
	If $g_bAndroidBackgroundLaunched = True Then
		If $g_bAndroidEmbedded = False Then
			SetDebugLog("Android Emulator launched in background mode", $COLOR_ERROR)
			; nothing to do
			updateBtnEmbed()
			Return False
		Else
			; detach android
			If $Embed = True Then
				SetDebugLog("Android Emulator launched in background mode, force undock", $COLOR_ERROR)
				$Embed = False
			EndIf
		EndIf
	EndIf

	Local $aPos = WinGetPos($g_hAndroidWindow)
	If IsArray($aPos) = 0 Or @error <> 0 Then
		If $g_bAndroidEmbedded = False Then
			SetDebugLog("Android Window not available", $COLOR_ERROR)
			updateBtnEmbed()
			Return False
		Else
			; detach android
			If $Embed = True Then
				SetDebugLog("Android Window not accessible, force undock", $COLOR_ERROR)
				$Embed = False
			EndIf
		EndIf
	EndIf

	Local $hTimer = __TimerInit()
	Do
		Local $hCtrl = ControlGetHandle(GetCurrentAndroidHWnD(), $g_sAppPaneName, GetAndroidControlClass())
		Local $hCtrlTarget = _WinAPI_GetParent($hCtrl)
		If $hCtrlTarget = 0 Then Sleep(10)
	Until $hCtrlTarget <> 0 Or __TimerDiff($hTimer) > 3000 ; wait 3 Seconds for window to get accessible
	If $hCtrlTarget = 0 Then
		If $g_bAndroidEmbedded = False Then
			SetDebugLog("Android Control not available", $COLOR_ERROR)
			updateBtnEmbed()
			Return False
		Else
			; detach android
			If $Embed = True Then
				SetDebugLog("Android Control not available, force undock", $COLOR_ERROR)
				$Embed = False
			EndIf
		EndIf
	EndIf
	Local $aPosFrmBotEx, $aPosLog
	Local $hCtrlTarget = $g_aiAndroidEmbeddedCtrlTarget[0]
	Local $hCtrlTargetParent = $g_aiAndroidEmbeddedCtrlTarget[1]
	Local $HWnDParent = $g_aiAndroidEmbeddedCtrlTarget[2]
	Local $HWnD2 = $g_aiAndroidEmbeddedCtrlTarget[3]
	Local $lCurStyle = $g_aiAndroidEmbeddedCtrlTarget[4]
	Local $lCurExStyle = $g_aiAndroidEmbeddedCtrlTarget[5]
	Local $aPosCtl = $g_aiAndroidEmbeddedCtrlTarget[6]
	Local $lCurStyleTarget = $g_aiAndroidEmbeddedCtrlTarget[8]
	Local $hThumbnail = $g_aiAndroidEmbeddedCtrlTarget[9]
	Local $targetIsHWnD = $hCtrlTarget = $g_hAndroidWindow

	Local $botStyle = _WinAPI_GetWindowLong($g_hFrmBot, $GWL_STYLE)

	#cs
		Local $HWND_MESSAGE = HWnd(-3)
		Local $WM_CHANGEUISTATE = 0x127
		Local $WM_UPDATEUISTATE = 0x128
		Local $UIS_SET = 0x1
		Local $UIS_INITIALIZE = 0x3
		Local $UISF_ACTIVE = 0x4
		Local $WM_STATE_WPARAM = BitOR($UISF_ACTIVE * 0x10000,$UIS_SET)
	#ce

	Local $activeHWnD = WinGetHandle("")
	Local $HWnD_available = WinGetHandle($g_hAndroidWindow) = $g_hAndroidWindow

	If $Embed = False Then
		; remove embedded Android
		If $g_bAndroidEmbedded = True Then

			SetDebugLog("Undocking Android Control...")

			If _WinAPI_IsIconic($g_hFrmBot) Then BotMinimize("_AndroidEmbed (1)", True)

			If $g_bAndroidShieldEnabled = True Then
				AndroidShield("AndroidEmbed undock", False, $CallWinGetAndroidHandle, 100)
				;_WinAPI_ShowWindow($g_hFrmBotEmbeddedShield, @SW_HIDE)
				;GUISetState(@SW_HIDE, $g_hFrmBotEmbeddedShield)
				If $g_hFrmBotEmbeddedShield Then
					GUIDelete($g_hFrmBotEmbeddedShield)
					$g_hFrmBotEmbeddedShield = 0
				EndIf
				If $g_hFrmBotEmbeddedMouse Then
					GUIDelete($g_hFrmBotEmbeddedMouse)
					$g_hFrmBotEmbeddedMouse = 0
				EndIf
				$g_avAndroidShieldStatus[0] = Default
			EndIf

			SetRedrawBotWindow(False, Default, Default, Default, "_AndroidEmbed")

			If $hThumbnail <> 0 Then
				_WinAPI_DwmUnregisterThumbnail($hThumbnail)
				$g_aiAndroidEmbeddedCtrlTarget[9] = 0
			EndIf

			$aPos = $g_aiAndroidEmbeddedCtrlTarget[7]

			$g_hProcShieldInput[3] = True

			If $HWnD_available Then
				Switch $g_iAndroidEmbedMode
					Case 0
						If $targetIsHWnD = False Then
							;ControlMove($hCtrlTarget, "", "", $aPosCtl[0], $aPosCtl[1], $aPosCtl[2], $aPosCtl[3])
							_WinAPI_SetParent($hCtrlTarget, $hCtrlTargetParent)
							_WinAPI_SetWindowLong($hCtrlTarget, $GWL_HWNDPARENT, $hCtrlTargetParent)
						EndIf
						;_WinAPI_SetWindowLong($HWnd, $GWL_STYLE, BitOR(_WinAPI_GetWindowLong($HWnD, $GWL_STYLE), $WS_MINIMIZE)) ; ensures that Android Window shows up in taskbar
						_WinAPI_SetWindowLong($g_hAndroidWindow, $GWL_EXSTYLE, $lCurExStyle)
						_WinAPI_SetParent($g_hAndroidWindow, $HWnDParent)
						_WinAPI_SetWindowLong($g_hAndroidWindow, $GWL_HWNDPARENT, $HWnDParent) ; required for BS to solve strange focus switch between bot and BS
						_WinAPI_SetWindowLong($g_hAndroidWindow, $GWL_STYLE, $lCurStyle)
						WinMove($g_hAndroidWindow, "", $aPos[0], $aPos[1], $aPos[2], $aPos[3] - 1) ; this fixes strange manual mouse clicks off in BS after undock
						WinMove2($g_hAndroidWindow, "", $aPos[0], $aPos[1], $aPos[2], $aPos[3])
					Case 1
						_WinAPI_SetWindowLong($g_hAndroidWindow, $GWL_EXSTYLE, $lCurExStyle)
						_WinAPI_SetWindowLong($g_hAndroidWindow, $GWL_STYLE, $lCurStyle)
						;WinMove($g_hAndroidWindow, "", $aPos[0], $aPos[1], $aPos[2], $aPos[3] - 1) ; force redraw this way (required for LeapDroid)
						;WinMove($g_hAndroidWindow, "", $aPos[0], $aPos[1], $aPos[2], $aPos[3]) ; force redraw this way (required for LeapDroid)
				EndSwitch
			EndIf

			; move Android rendering control back to its place
			WinMove(($targetIsHWnD ? $hCtrl : $hCtrlTarget), "", $aPosCtl[0], $aPosCtl[1], $aPosCtl[2], $aPosCtl[3])
			WinMove2(($targetIsHWnD ? $hCtrl : $hCtrlTarget), "", $aPosCtl[0], $aPosCtl[1], $aPosCtl[2], $aPosCtl[3], 0, 0, False)
			If $g_bDebugAndroidEmbedded Then SetDebugLog("Placed Android Control at " & $aPosCtl[0] & "," & $aPosCtl[1])

			ControlHide($g_hGUI_LOG, "", $g_hDivider)
			$aPosFrmBotEx = ControlGetPos($g_hFrmBot, "", $g_hFrmBotEx)
			If UBound($aPosFrmBotEx) < 4 Then
				SetLog("Bot Window not available", $COLOR_ERROR)
				$g_hProcShieldInput[3] = False
				Return False
			EndIf
			ControlMove($g_hFrmBot, "", $g_hFrmBotEx, 0, 0, $aPosFrmBotEx[2], $aPosFrmBotEx[3] - $g_iFrmBotAddH)
			ControlMove($g_hFrmBot, "", $g_hFrmBotBottom, 0, $_GUI_MAIN_HEIGHT - $_GUI_BOTTOM_HEIGHT + $_GUI_MAIN_TOP)
			WinSetTrans($g_hFrmBotBottom, "", 255)
			; restore main tab size (not required ;)
			; restore log size
			$aPosLog = ControlGetPos($g_hFrmBotEx, "", $g_hGUI_LOG)
			ControlMove($g_hFrmBotEx, "", $g_hGUI_LOG, Default, Default, $aPosLog[2], $aPosLog[3] - $g_iFrmBotAddH)
			$g_bAndroidEmbedded = False
			WinMove2($g_hFrmBot, "", $g_iFrmBotPosX, $g_iFrmBotPosY, $g_aFrmBotPosInit[2], $g_aFrmBotPosInit[3] + $g_aFrmBotPosInit[7], $HWND_NOTOPMOST, 0, False)
			updateBtnEmbed()

			$g_iLogDividerY -= $g_iFrmBotAddH
			$g_iFrmBotAddH = 0
			cmbLog()

			SetRedrawBotWindow(True, Default, Default, Default, "_AndroidEmbed")
			If $HWnD_available Then
				; Ensure android window shows up in taskbar again
				_SendMessage($g_hAndroidWindow, $WM_SETREDRAW, False, 0)
				;WinSetState($g_hAndroidWindow, "", @SW_HIDE)
				_WinAPI_ShowWindow($g_hAndroidWindow, @SW_HIDE)
				_WinAPI_SetWindowLong($g_hAndroidWindow, $GWL_EXSTYLE, BitOR($lCurExStyle, $WS_EX_APPWINDOW))
				;WinSetState($g_hAndroidWindow, "", @SW_SHOW)
				_WinAPI_ShowWindow($g_hAndroidWindow, @SW_SHOWNOACTIVATE)
				_SendMessage($g_hAndroidWindow, $WM_SETREDRAW, True, 0)
				_WinAPI_UpdateWindow($g_hAndroidWindow)
				_WinAPI_SetWindowLong($g_hAndroidWindow, $GWL_EXSTYLE, $lCurExStyle)

				_WinAPI_EnableWindow($g_hAndroidWindow, True)
				_WinAPI_EnableWindow($hCtrlTarget, True)

				; move Android rendering control back to its place
				WinMove2(($targetIsHWnD ? $hCtrl : $hCtrlTarget), "", $aPosCtl[0], $aPosCtl[1], $aPosCtl[2], $aPosCtl[3], 0, 0, False)
				WinMove($g_hAndroidWindow, "", $aPos[0], $aPos[1], $aPos[2], $aPos[3]) ; use WinMove to trigger move message
				If $g_iAndroidEmbedMode = 1 Then
					; bring android back to front
					WinMove2($g_hAndroidWindow, "", $aPos[0], $aPos[1], $aPos[2], $aPos[3], $HWND_TOPMOST)
					WinMove2($g_hAndroidWindow, "", $aPos[0], $aPos[1], $aPos[2], $aPos[3], $HWND_NOTOPMOST, 0, False)
				EndIf
				If $bNoAndroidScreenSizeCheck = False Then
					getBSPos() ; update android screen coord. for clicks etc
				EndIf
				Execute("Embed" & $g_sAndroidEmulator & "(False)")
			EndIf

			SetDebugLog("Undocked Android Window")

			$g_hProcShieldInput[3] = False

			; ensure bot style wasn't changed
			_WinAPI_SetWindowLong($g_hFrmBot, $GWL_STYLE, $botStyle)

			Return True
		EndIf
		updateBtnEmbed()
		Return False
	EndIf

	If $g_bAndroidEmbedded = True And $bForceEmbed = False Then
		If $g_hAndroidWindow = $HWnD2 Then
			Local $a = AndroidEmbed_HWnD_Position()
			;SetDebugLog("Android Window already embedded", Default, True)
			If $targetIsHWnD = False Then
				; Ensure android is still hidden
				WinMove2($g_hAndroidWindow, "", $a[0], $a[1], -1, -1, $HWND_BOTTOM)
			EndIf

			Return False
		EndIf
		SetDebugLog("Docked Android Window gone", $COLOR_ERROR)
		Return _AndroidEmbed(False)
	EndIf

	Local $bAlreadyEmbedded = $g_bAndroidEmbedded = True

	; Embed Android Window
	SetDebugLog("Docking Android Control...")

	If _WinAPI_DwmEnableComposition(True) = 1 Then
		SetDebugLog("Desktop Window Manager available", $COLOR_SUCCESS)
	Else
		SetDebugLog("Desktop Window Manager not available!", $COLOR_ERROR)
		SetDebugLog("Android Shield will be invisible!", $COLOR_ERROR)
	EndIf

	If _WinAPI_IsIconic($g_hFrmBot) Then BotMinimize("_AndroidEmbed (2)", True)
	If _WinAPI_IsIconic($g_hAndroidWindow) Then WinSetState($g_hAndroidWindow, "", @SW_RESTORE)

	Switch $g_iAndroidEmbedMode
		Case 0
			; check DPI awareness
			Local $iBotDpiAware = GetProcessDpiAwareness(@AutoItPID)
			If GetProcessDpiAwareness(GetAndroidPid()) And $iBotDpiAware = 0 And CheckDpiAwareness(True) = False Then
				; ups Android is DPI Aware but not bot... fix now
				CheckDpiAwareness(False, True)
				;RedrawBotWindowNow()
			EndIf

			If $iBotDpiAware Then
				;bot is running in DPI aware mode, now does Android too
				$g_hAndroidWindowDpiAware = $g_hAndroidWindow
			EndIf
	EndSwitch
	If $bNoAndroidScreenSizeCheck = False Then getAndroidPos() ; ensure window size is ok

	Local $hTimer = __TimerInit()
	Do
		$aPos = WinGetPos($g_hAndroidWindow) ; Android Window size might has changed
		If UBound($aPos) < 3 Then Sleep(10)
	Until UBound($aPos) > 2 Or __TimerDiff($hTimer) > 3000 ; wait 3 Seconds for window to get accessible
	If UBound($aPos) < 3 Then
		SetDebugLog("Android Window not accessible", $COLOR_ERROR)
		updateBtnEmbed()
		Return False
	EndIf
	If $g_bDebugAndroidEmbedded Then SetDebugLog("AndroidEmbed: $aPos[] = " & $aPos[0] & ", " & $aPos[1] & ", " & $aPos[2] & ", " & $aPos[3], Default, True)
	$lCurStyle = _WinAPI_GetWindowLong($g_hAndroidWindow, $GWL_STYLE)
	$lCurExStyle = _WinAPI_GetWindowLong($g_hAndroidWindow, $GWL_EXSTYLE)

	$HWnDParent = __WinAPI_GetParent($g_hAndroidWindow)
	$hCtrl = ControlGetHandle(GetCurrentAndroidHWnD(), $g_sAppPaneName, $g_sAppClassInstance) ; sometimes $hCtrl is wrong/changed ?!? read again
	$hCtrlTarget = __WinAPI_GetParent($hCtrl)
	$targetIsHWnD = $hCtrlTarget = $g_hAndroidWindow
	#cs not tested nor required, yet
	; check if parent control is of same size, then use it
	Local $aCtrlPos = WinGetPos($hCtrl)
	Local $aCtrlTargetPos = WinGetPos($hCtrlTarget)
	If UBound($aCtrlPos) > 3 And UBound($aCtrlTargetPos) > 3 Then
		If $aCtrlPos[2] = $aCtrlTargetPos[2] And $aCtrlPos[3] = $aCtrlTargetPos[3] Then
			; ok, use $hCtrlTarget
		Else
			SetDebugLog("Using Android Control as target for docking")
			$hCtrlTarget = $hCtrl
		EndIf
	EndIf
	#ce
	;_WinAPI_SetWindowLong($hCtrl, $GWL_STYLE, BitAND(_WinAPI_GetWindowLong($hCtrl, $GWL_STYLE), BitNOT($WS_EX_NOPARENTNOTIFY)))
	$lCurStyleTarget = _WinAPI_GetWindowLong($hCtrlTarget, $GWL_STYLE)
	$hCtrlTargetParent = __WinAPI_GetParent($hCtrlTarget)
	SetDebugLog("AndroidEmbed: $hCtrl=" & $hCtrl & ", $hCtrlTarget=" & $hCtrlTarget & ", $hCtrlTargetParent=" & $hCtrlTargetParent & ", $g_hAndroidWindow=" & $g_hAndroidWindow, Default, True)

	Local $adjustPosCtrl = False
	If $bAlreadyEmbedded = True Then
		$g_hProcShieldInput[3] = True
	Else

		$aPosCtl = ControlGetPos($g_hAndroidWindow, "", ($targetIsHWnD ? $hCtrl : $hCtrlTarget))
		If UBound($aPosCtl) < 3 Then
			SetDebugLog("Android Control Position not available", $COLOR_ERROR)
			updateBtnEmbed()
			Return False
		EndIf
		;Switch $g_sAndroidEmulator
		;	Case "BlueStacks", "BlueStacks2"
				If $aPosCtl[2] <> $g_iAndroidClientWidth Then
					If $g_bDebugAndroidEmbedded Then SetDebugLog("AndroidEmbed: $aPosCtl[2] = " & $aPosCtl[2] & " changed to " & $g_iAndroidClientWidth, Default, True)
					$aPosCtl[2] = $g_iAndroidClientWidth
				EndIf
				If $aPosCtl[3] <> $g_iAndroidClientHeight Then
					If $g_bDebugAndroidEmbedded Then SetDebugLog("AndroidEmbed: $aPosCtl[3] = " & $aPosCtl[3] & " changed to " & $g_iAndroidClientHeight, Default, True)
					$aPosCtl[3] = $g_iAndroidClientHeight
				EndIf
		;EndSwitch
		If $g_bDebugAndroidEmbedded Then SetDebugLog("AndroidEmbed: $aPosCtl[] = " & $aPosCtl[0] & ", " & $aPosCtl[1] & ", " & $aPosCtl[2] & ", " & $aPosCtl[3], Default, True)

		If $targetIsHWnD Then
			Local $aPosParentCtl = $aPosCtl
			$hCtrlTargetParent = $hCtrlTarget
		ElseIf $hCtrlTargetParent = $g_hAndroidWindow Then
			Local $aPosParentCtl = $aPosCtl
		Else
			$adjustPosCtrl = True
			Local $aPosParentCtl = ControlGetPos($g_hAndroidWindow, "", $hCtrlTargetParent)
			If $hCtrlTargetParent = 0 Or IsArray($aPosParentCtl) = 0 Or @error <> 0 Then
				SetDebugLog("Android Parent Control not available", $COLOR_ERROR)
				updateBtnEmbed()
				Return False
			EndIf
		EndIf
		If $g_bDebugAndroidEmbedded Then SetDebugLog("AndroidEmbed: $aPosParentCtl[] = " & $aPosParentCtl[0] & ", " & $aPosParentCtl[1] & ", " & $aPosParentCtl[2] & ", " & $aPosParentCtl[3], Default, True)

		Local $botClientWidth = $g_aFrmBotPosInit[4]
		Local $botClientHeight = $g_aFrmBotPosInit[5] - $g_aFrmBotPosInit[7]
		$g_iFrmBotAddH = $aPosCtl[3] - $botClientHeight - $g_aFrmBotPosInit[7]
		If $g_bDebugAndroidEmbedded Then SetDebugLog("AndroidEmbed: $g_iFrmBotAddH = " & $g_iFrmBotAddH, Default, True)
		If $g_iFrmBotAddH < 0 Then $g_iFrmBotAddH = 0

		Local $g_hFrmBotWidth = $g_aFrmBotPosInit[2] + $aPosCtl[2] + 2
		Local $g_hFrmBotHeight = $g_aFrmBotPosInit[3] + $g_iFrmBotAddH + $g_aFrmBotPosInit[7]

		$g_hProcShieldInput[3] = True
		$g_bAndroidEmbedded = True

		If $g_iFrmBotDockedPosX = $g_WIN_POS_DEFAULT Or $g_iFrmBotDockedPosY = $g_WIN_POS_DEFAULT Then
			; determine x position based on bot / android arrangement
			If $g_iFrmBotPosX < $g_iAndroidPosX Then
				$g_iFrmBotDockedPosX = $g_iFrmBotPosX
				$g_iFrmBotDockedPosY = $g_iFrmBotPosY
			Else
				$g_iFrmBotDockedPosX = $g_iAndroidPosX
				$g_iFrmBotDockedPosY = $g_iAndroidPosY
			EndIf
		EndIf

		WinMove2($g_hFrmBot, "", $g_iFrmBotDockedPosX, $g_iFrmBotDockedPosY, -1, -1, 0, 0, False)

		$aPosFrmBotEx = ControlGetPos($g_hFrmBot, "", $g_hFrmBotEx)
		$aPosFrmBotEx[3] = $g_aFrmBotPosInit[6]
		If $g_bDebugAndroidEmbedded Then SetDebugLog("AndroidEmbed: $aPosFrmBotEx[] = " & $aPosFrmBotEx[0] & ", " & $aPosFrmBotEx[1] & ", " & $aPosFrmBotEx[2] & ", " & $aPosFrmBotEx[3], Default, True)
		WinMove($g_hFrmBotEx, "", $aPosCtl[2] + 2, 0, $aPosFrmBotEx[2], $aPosFrmBotEx[3] + $g_iFrmBotAddH)
		WinMove($g_hFrmBotBottom, "", $aPosCtl[2] + 2, $_GUI_MAIN_HEIGHT - $_GUI_BOTTOM_HEIGHT + $_GUI_MAIN_TOP + $g_iFrmBotAddH)
		;WinSetTrans($g_hFrmBotBottom, "", 254)
		;Local $BS1_style = BitOR($WS_OVERLAPPED, $WS_MINIMIZEBOX, $WS_GROUP, $WS_SYSMENU, $WS_DLGFRAME, $WS_BORDER, $WS_CAPTION, $WS_CLIPCHILDREN, $WS_CLIPSIBLINGS, $WS_VISIBLE)
		If $g_iAndroidEmbedMode = 0 Then
			WinMove2($hCtrlTarget, "", 0, 0, $aPosCtl[2], $aPosCtl[3], $HWND_BOTTOM)
		EndIf
		_SendMessage($g_hFrmBot, $WM_SETREDRAW, False, 0) ; disable bot window redraw
		; increase main tab size
		Local $a = ControlGetRelativePos($g_hFrmBotEx, "", $g_hTabMain)
		If UBound($a) > 3 Then
			Local $ctrlResult = WinMove(GUICtrlGetHandle($g_hTabMain), "", $a[0], $a[1], $a[2], $a[3] + $g_iFrmBotAddH)
			If $g_bDebugAndroidEmbedded Then SetDebugLog("Move $g_hTabMain Pos: " & $a[0] & ", " & $a[1] & ", " & $a[2] & ", " & $a[3] + $g_iFrmBotAddH & ": " & $ctrlResult)
		EndIf
		; increase log size
		$aPosLog = ControlGetPos($g_hFrmBotEx, "", $g_hGUI_LOG)
		If $g_bDebugAndroidEmbedded Then SetDebugLog("AndroidEmbed: $aPosLog[] = " & $aPosLog[0] & ", " & $aPosLog[1] & ", " & $aPosLog[2] & ", " & $aPosLog[3], Default, True)
		WinMove($g_hGUI_LOG, "", $_GUI_CHILD_LEFT, $_GUI_CHILD_TOP, $aPosLog[2], $aPosLog[3] + $g_iFrmBotAddH)

		WinMove2($g_hFrmBot, "", $g_iFrmBotDockedPosX, $g_iFrmBotDockedPosY, $g_hFrmBotWidth, $g_hFrmBotHeight, ($g_bChkBackgroundMode ? $HWND_NOTOPMOST : $HWND_TOPMOST), 0, False)

		$g_aiAndroidEmbeddedCtrlTarget[0] = $hCtrlTarget
		$g_aiAndroidEmbeddedCtrlTarget[1] = $hCtrlTargetParent
		$g_aiAndroidEmbeddedCtrlTarget[2] = $HWnDParent
		$g_aiAndroidEmbeddedCtrlTarget[3] = $g_hAndroidWindow
		$g_aiAndroidEmbeddedCtrlTarget[4] = $lCurStyle
		$g_aiAndroidEmbeddedCtrlTarget[5] = $lCurExStyle
		; convert to relative position
		If $adjustPosCtrl = True Then
			$aPosCtl[0] = $aPosParentCtl[0] - $aPosCtl[0]
			$aPosCtl[1] = $aPosParentCtl[1] - $aPosCtl[1]
		EndIf
		$g_aiAndroidEmbeddedCtrlTarget[6] = $aPosCtl
		$g_aiAndroidEmbeddedCtrlTarget[7] = $aPos
		$g_aiAndroidEmbeddedCtrlTarget[8] = $lCurStyleTarget
	EndIf

	Local $newStyle = AndroidEmbed_GWL_STYLE()
	SetDebugLog("AndroidEmbed_GWL_STYLE=" & Get_GWL_STYLE_Text($newStyle))
	Local $a = AndroidEmbed_HWnD_Position()
	Switch $g_iAndroidEmbedMode
		Case 0
			; default mode, embed Android direct in bot window
			_WinAPI_SetWindowLong($g_hAndroidWindow, $GWL_EXSTYLE, $WS_EX_MDICHILD)
			_WinAPI_SetWindowLong($g_hAndroidWindow, $GWL_HWNDPARENT, $g_hFrmBot) ; required for BS to solve strange focus switch between bot and BS
			_WinAPI_SetWindowLong($g_hAndroidWindow, $GWL_STYLE, $newStyle)
			_WinAPI_SetParent($g_hAndroidWindow, $g_hFrmBot)
			If $targetIsHWnD = False Then
				_WinAPI_SetWindowLong($hCtrlTarget, $GWL_HWNDPARENT, $g_hFrmBot)
				_WinAPI_SetParent($hCtrlTarget, $g_hFrmBot)
			EndIf
			_WinAPI_SetWindowLong($g_hAndroidWindow, $GWL_STYLE, $newStyle)
			;ControlFocus($g_hFrmBot, "", $g_hFrmBot) ; required for BlueStacks
			If $targetIsHWnD = False Then
				WinMove2($g_hAndroidWindow, "", $a[0], $a[1], -1, -1, $HWND_BOTTOM, 0, False)
			EndIf
		Case 1
			; fake embed using DWM to mirror Android into bot window
			_WinAPI_SetWindowLong($g_hAndroidWindow, $GWL_STYLE, $newStyle)
			; Hide android window in taskbar
			WinMove2($g_hAndroidWindow, "", -1, -1, -1, -1, 0, $SWP_HIDEWINDOW, False)
			_WinAPI_ShowWindow($g_hAndroidWindow, @SW_HIDE)
			_WinAPI_SetWindowLong($g_hAndroidWindow, $GWL_EXSTYLE, BitOR(_WinAPI_GetWindowLong($g_hAndroidWindow, $GWL_EXSTYLE), $WS_EX_TOOLWINDOW, $WS_EX_NOACTIVATE))
			_WinAPI_ShowWindow($g_hAndroidWindow, @SW_SHOWNOACTIVATE)
			_SendMessage($g_hAndroidWindow, $WM_SETREDRAW, True, 0)
			_WinAPI_UpdateWindow($g_hAndroidWindow)
			_WinAPI_SetWindowLong($g_hAndroidWindow, $GWL_EXSTYLE, BitOR(_WinAPI_GetWindowLong($g_hAndroidWindow, $GWL_EXSTYLE), $WS_EX_TOOLWINDOW, $WS_EX_NOACTIVATE))

			;WinMove($g_hAndroidWindow, "", $a[0], $a[1], $aPosCtl[2], $aPosCtl[3] - 1) ; force redraw this way (required for LeapDroid)
			;WinMove($g_hAndroidWindow, "", $a[0], $a[1], $aPosCtl[2], $aPosCtl[3]) ; force redraw this way (required for LeapDroid)
			If $targetIsHWnD = False Then
				WinMove2($hCtrlTarget, "", 0, 0, $aPosCtl[2], $aPosCtl[3], 0, 0, False)
			EndIf
			; register thumbnail
			If _WinAPI_DwmIsCompositionEnabled() And $hThumbnail = 0 Then
				Local $iFix = 0
				; in custom title bar mode, the window border is not considered, so use 1 (not really a good way to fix this... only tested on Windows Server 2016)
				If $g_bCustomTitleBarActive = True Then $iFix = 1
				$hThumbnail = _WinAPI_DwmRegisterThumbnail($g_hFrmBot, $g_hAndroidWindow)
				Local $tSIZE = _WinAPI_DwmQueryThumbnailSourceSize($hThumbnail)
				Local $iWidth = DllStructGetData($tSIZE, 1)
				Local $iHeight = DllStructGetData($tSIZE, 2)
				Local $tDestRect = _WinAPI_CreateRectEx(0 + $iFix, 0 + $iFix, $aPosCtl[2] + $iFix, $aPosCtl[3] + $iFix)
				Local $tSrcRect = _WinAPI_CreateRectEx(0, 0, $iWidth, $iHeight)
				_WinAPI_DwmUpdateThumbnailProperties($hThumbnail, 1, 0, 255, $tDestRect, $tSrcRect)
				$g_aiAndroidEmbeddedCtrlTarget[9] = $hThumbnail
			EndIf
			WinMove2($g_hAndroidWindow, "", $a[0], $a[1], $aPosCtl[2], $aPosCtl[3], $HWND_BOTTOM, $SWP_SHOWWINDOW, False)
	EndSwitch

	Execute("Embed" & $g_sAndroidEmulator & "(True)")
	updateBtnEmbed()

	$g_iLogDividerY += $g_iFrmBotAddH
	cmbLog()

	_WinAPI_EnableWindow($hCtrlTarget, False)
	_WinAPI_EnableWindow($g_hAndroidWindow, False)

	Local $aCheck = WinGetPos($g_hAndroidWindow)
	If IsArray($aCheck) Then
		If $g_bDebugAndroidEmbedded Then SetDebugLog("AndroidEmbed: Android Window Pos: " & $aCheck[0] & ", " & $aCheck[1] & ", " & $aCheck[2] & ", " & $aCheck[3], Default, True)
	Else
		SetDebugLog("AndroidEmbed: Android Window not found", $COLOR_ERROR)
	EndIf
	Local $aCheck = ControlGetPos(GetCurrentAndroidHWnD(), $g_sAppPaneName, $g_sAppClassInstance)
	If IsArray($aCheck) Then
		If $g_bDebugAndroidEmbedded Then SetDebugLog("AndroidEmbed: Android Control Pos: " & $aCheck[0] & ", " & $aCheck[1] & ", " & $aCheck[2] & ", " & $aCheck[3], Default, True)
	Else
		SetDebugLog("AndroidEmbed: Android Control not found", $COLOR_ERROR)
	EndIf

	If $bNoAndroidScreenSizeCheck = False Then
		getBSPos() ; update android screen coord. for clicks etc
	EndIf

	_SendMessage($g_hFrmBot, $WM_SETREDRAW, True, 0)
	;RedrawBotWindowNow()
	_WinAPI_RedrawWindow($g_hFrmBot, 0, 0, $RDW_INVALIDATE + $RDW_ALLCHILDREN + $RDW_ERASE)
	_WinAPI_RedrawWindow($g_hFrmBotBottom, 0, 0, $RDW_INVALIDATE + $RDW_ALLCHILDREN + $RDW_ERASE)
	_WinAPI_UpdateWindow($g_hFrmBot)
	_WinAPI_UpdateWindow($g_hFrmBotBottom)
	;update Android Window
	If $g_iAndroidEmbedMode = 0 Then
		WinMove2($hCtrlTarget, "", 0, 0, $aPosCtl[2] - 1, $aPosCtl[3] - 1, $HWND_BOTTOM, 0, False) ; trigger window change
		WinMove2($hCtrlTarget, "", 0, 0, $aPosCtl[2], $aPosCtl[3], $HWND_BOTTOM, 0, False)
		If $targetIsHWnD Then
			; BlueStack can have a problem, so move control
			WinMove2($hCtrl, "", 0, 0, $aPosCtl[2] - 1, $aPosCtl[3] - 1, $HWND_BOTTOM)
			WinMove2($hCtrl, "", 0, 0, $aPosCtl[2], $aPosCtl[3], $HWND_BOTTOM) ; ensure control is position at 0,0
		EndIf
	EndIf

	;CheckRedrawControls(True)

	;If $g_hFrmBotMinimized = False And $activeHWnD = $g_hFrmBot Then WinActivate($activeHWnD) ; re-activate bot

	SetDebugLog("Android Window docked")

	$g_hProcShieldInput[3] = False
	$g_hProcShieldInput[4] = 0


	; for some reason the border is sometimes not refresh, so redraw bot window border now
	_WinAPI_RedrawWindow($g_hFrmBot, 0, 0, BitOR($RDW_FRAME, $RDW_UPDATENOW, $RDW_INVALIDATE))

	AndroidShield("AndroidEmbed dock", Default, $CallWinGetAndroidHandle, 100)

	If $g_bBotLaunchOption_HideAndroid Then
		; hide bot
		BotMinimizeRequest()
	EndIf

	Return True
EndFunc   ;==>_AndroidEmbed

Func Get_GWL_STYLE_Text($iGWL_STYLE)
	Local $s = ""
	Local $a[20][2] = [[$WS_MAXIMIZEBOX, "$WS_MAXIMIZEBOX"] _
			, [$WS_MINIMIZEBOX, "$WS_MINIMIZEBOX"] _
			, [$WS_TABSTOP, "$WS_TABSTOP"] _
			, [$WS_GROUP, "$WS_GROUP"] _
			, [$WS_SIZEBOX, "$WS_SIZEBOX"] _
			, [$WS_SYSMENU, "$WS_SYSMENU"] _
			, [$WS_HSCROLL, "$WS_HSCROLL"] _
			, [$WS_VSCROLL, "$WS_VSCROLL"] _
			, [$WS_DLGFRAME, "$WS_DLGFRAME"] _
			, [$WS_BORDER, "$WS_BORDER"] _
			, [$WS_CAPTION, "$WS_CAPTION"] _
			, [$WS_MAXIMIZE, "$WS_MAXIMIZE"] _
			, [$WS_CLIPCHILDREN, "$WS_CLIPCHILDREN"] _
			, [$WS_CLIPSIBLINGS, "$WS_CLIPSIBLINGS"] _
			, [$WS_DISABLED, "$WS_DISABLED"] _
			, [$WS_VISIBLE, "$WS_VISIBLE"] _
			, [$WS_MINIMIZE, "$WS_MINIMIZE"] _
			, [$WS_CHILD, "$WS_CHILD"] _
			, [$WS_POPUP, "$WS_POPUP"] _
			, [$WS_POPUPWINDOW, "$WS_POPUPWINDOW"] _
			]
	Local $i
	For $i = 0 To UBound($a) - 1
		If BitAND($iGWL_STYLE, $a[$i][0]) > 0 Then
			If $s <> "" Then $s &= ", "
			$s &= $a[$i][1]
			$iGWL_STYLE -= $a[$i][0]
		EndIf
	Next
	If $iGWL_STYLE > 0 Then
		If $s <> "" Then $s &= ","
		$s &= Hex($iGWL_STYLE, 8)
	EndIf

	Return $s
EndFunc   ;==>Get_GWL_STYLE_Text

Func AndroidEmbed_GWL_STYLE()
	If $g_bAndroidEmbedded = True Then
		Local $lCurStyle = $g_aiAndroidEmbeddedCtrlTarget[4]
		Local $newStyle = BitOR($WS_CHILD, BitAND($lCurStyle, BitNOT(BitOR($WS_POPUP, $WS_CAPTION, $WS_SYSMENU, $WS_MINIMIZEBOX, $WS_MAXIMIZEBOX, $WS_SIZEBOX, $WS_BORDER, $WS_THICKFRAME))))
		;Local $newStyle = BitOR($WS_VISIBLE, $WS_CHILD, $WS_CLIPCHILDREN, $WS_CLIPSIBLINGS)
		If $g_iAndroidEmbedMode = 1 Then
			$newStyle = BitOR($WS_POPUP, BitAND($newStyle, BitNOT($WS_CHILD)))
		EndIf
		Return $newStyle
	EndIf
	Return ""
EndFunc   ;==>AndroidEmbed_GWL_STYLE

Func AndroidEmbed_HWnD_Position($bForShield = False, $bDetachedShield = Default, $hCtrlTarget = Default, $aPosCtl = Default)
	Local $aPos[2]

	If $bDetachedShield = Default Then
		$bDetachedShield = $g_avAndroidShieldStatus[4]
	EndIf
	If $g_iAndroidEmbedMode = 1 Or ($bForShield = True And $bDetachedShield = True) Then
		Local $tPoint = DllStructCreate("int X;int Y")
		DllStructSetData($tPoint, "X", 0)
		DllStructSetData($tPoint, "Y", 0)
		_WinAPI_ClientToScreen($g_hFrmBot, $tPoint)
		$aPos[0] = DllStructGetData($tPoint, "X")
		$aPos[1] = DllStructGetData($tPoint, "Y")
		$tPoint = 0
	ElseIf $g_iAndroidEmbedMode = 0 And $bForShield = False Then
		If $hCtrlTarget = Default Then
			$hCtrlTarget = $g_aiAndroidEmbeddedCtrlTarget[0]
		EndIf
		If $aPosCtl = Default Then
			$aPosCtl = $g_aiAndroidEmbeddedCtrlTarget[6]
		EndIf
		Local $targetIsHWnD = $hCtrlTarget = $g_hAndroidWindow
		If $targetIsHWnD = False Then
			;$aPos[0] = $aPosCtl[2] + 2
			;$aPos[1] = $g_aFrmBotPosInit[5]
			$aPos[0] = 0
			If $g_bAndroidEmbeddedWindowZeroPosition Then
				$aPos[1] = 0
			Else
				$aPos[1] = $aPosCtl[3]
			EndIf
		Else
			$aPos[0] = 0
			$aPos[1] = 0
		EndIf
	ElseIf $bForShield = True And ($bDetachedShield = False Or $bDetachedShield = Default) Then
		$aPos[0] = 0
		$aPos[1] = 0
	Else
		SetDebugLog("AndroidEmbed_HWnD_Position: Wrong window state:" & @CRLF & _
				"$bForShield=" & $bForShield & @CRLF & _
				"$g_iAndroidEmbedMode=" & $g_iAndroidEmbedMode & @CRLF & _
				"$bDetachedShield=" & $bDetachedShield)
	EndIf

	Return $aPos
EndFunc   ;==>AndroidEmbed_HWnD_Position

; Ensure embedded window stays hidden
Func AndroidEmbedCheck($bTestIfRequired = Default, $bHasFocus = Default, $iAction = 6)

	If $g_bFrmBotMinimized Then $bHasFocus = False
	If $bHasFocus = Default Then $bHasFocus = WinActive($g_hFrmBot) <> 0

	If $bTestIfRequired = Default Then
		$iAction = AndroidEmbedCheck(True, $bHasFocus)
		If $iAction = 0 Then
			Return 0
		EndIf
		$bTestIfRequired = False
	EndIf
	If $g_bAndroidEmbedded = True And AndroidEmbedArrangeActive() = False Then
		Local $hCtrlTarget = $g_aiAndroidEmbeddedCtrlTarget[0]
		Local $aPosCtl = $g_aiAndroidEmbeddedCtrlTarget[6]
		Local $targetIsHWnD = $hCtrlTarget = $g_hAndroidWindow
		Local $aPos = AndroidEmbed_HWnD_Position()
		Local $aPosShield = AndroidEmbed_HWnD_Position(True)
		Local $newStyle = AndroidEmbed_GWL_STYLE()
		Local $bDetachedShield = $g_avAndroidShieldStatus[4]
		If $bTestIfRequired = False Then
			SetDebugLog("AndroidEmbedCheck: $iAction=" & $iAction, Default, True)
			;If BitAND($iAction, 2) > 0 Then _WinAPI_SetWindowLong($g_hAndroidWindow, $GWL_STYLE, $newStyle)
			If BitAND($iAction, 2) > 0 Then
				; bad... need to dock again
				AndroidEmbedArrangeActive(True)
				_WinAPI_SetWindowLong($g_hAndroidWindow, $GWL_STYLE, $newStyle)
				AndroidEmbed(True, False, True)
			EndIf
			If BitAND($iAction, 1) Or BitAND($iAction, 4) > 0 Then
				; Ensure android is still hidden
				WinMove2($g_hAndroidWindow, "", $aPos[0], $aPos[1], -1, -1, $HWND_BOTTOM, 0, True)
			EndIf
			; Ensure shield is still at its right place
			If $g_bAndroidShieldEnabled = True And $bDetachedShield = True Then
				If BitAND($iAction, 1) > 0 Or BitAND($iAction, 4) > 0 Then
					If BitAND($iAction, 4) > 0 Then
						#cs
						WinMove2($g_hFrmBotEmbeddedShield, "", $aPosShield[0], $aPosShield[1], $aPosCtl[2], $aPosCtl[3], ($bHasFocus ? $HWND_TOPMOST : $HWND_NOTOPMOST), 0, False)
						;If $bHasFocus Then WinMove2($g_hFrmBotEmbeddedShield, "", $aPosShield[0], $aPosShield[1], $aPosCtl[2], $aPosCtl[3], $HWND_NOTOPMOST, 0, False)
						If $g_hFrmBotEmbeddedGraphics Then
							WinMove2($g_hFrmBotEmbeddedGraphics, "", $aPosShield[0], $aPosShield[1], $aPosCtl[2], $aPosCtl[3], ($bHasFocus ? $HWND_TOPMOST : $HWND_NOTOPMOST), 0, False)
							;If $bHasFocus Then WinMove2($g_hFrmBotEmbeddedGraphics, "", $aPosShield[0], $aPosShield[1], $aPosCtl[2], $aPosCtl[3], $HWND_NOTOPMOST, False)
						EndIf
						If $g_bBotDockedShrinked Then
							;CheckBotShrinkExpandButton()
							WinMove2($g_hFrmBotButtons, "", -1, -1, -1, -1, ($bHasFocus ? $HWND_TOPMOST : $HWND_NOTOPMOST), 0, False)
						EndIf
						#ce
						WinMove2($g_hFrmBotEmbeddedShield, "", $aPosShield[0], $aPosShield[1], $aPosCtl[2], $aPosCtl[3], 0, 0, False)
						If $g_hFrmBotEmbeddedGraphics Then
							WinMove2($g_hFrmBotEmbeddedGraphics, "", $aPosShield[0], $aPosShield[1], $aPosCtl[2], $aPosCtl[3], 0, 0, False)
						EndIf
					EndIf
					CheckBotZOrder()
				EndIf
			EndIf
			Return True
		EndIf

		; test if update is required
		Local $iZorder = 0
		If $g_bAndroidShieldEnabled = True And $bDetachedShield = True And $bHasFocus = False Then
			; check z-order
			If CheckBotZOrder(True) Then
				$iZorder = 1
			EndIf
		EndIf

		Local $style = _WinAPI_GetWindowLong($g_hAndroidWindow, $GWL_STYLE)
		If BitAND($style, $WS_DISABLED) > 0 Then $newStyle = BitOR($newStyle, $WS_DISABLED)
		;If BitAND($style, $WS_MAXIMIZEBOX) > 0 Then $newStyle = BitOR($newStyle, $WS_MAXIMIZEBOX) ; dirty fix for LeapDroid 1.7.0: It always adds $WS_MAXIMIZEBOX again

		Local $iStyle = (($style <> $newStyle) ? 2 : 0)
		If $iStyle > 0 Then
			SetDebugLog("AndroidEmbedCheck: Android Window GWL_STYLE changed: " & Get_GWL_STYLE_Text($newStyle) & " to " & Get_GWL_STYLE_Text($style), Default, True)
		EndIf
		Local $a1[2] = [$aPos[0], $aPos[1]]
		Local $a2 = $aPos
		Switch $g_iAndroidEmbedMode
			Case 0
				Local $a1 = ControlGetPos($g_hFrmBot, "", $g_hAndroidWindow)
			Case 1
				Local $a1 = WinGetPos($g_hAndroidWindow)
		EndSwitch
		Local $iPos = ((IsArray($a1) And ($a1[0] <> $a2[0] Or $a1[1] <> $a2[1])) ? 4 : 0)
		If $iPos > 0 Then
			SetDebugLog("AndroidEmbedCheck: Android Window Position changed: X: " & $a1[0] & " <> " & $a2[0] & ", Y: " & $a1[1] & " <> " & $a2[1], Default, True)
		EndIf
		If $iPos = 0 And $bDetachedShield = True Then
			$a1 = WinGetPos($g_hFrmBotEmbeddedShield)
			$a2 = $aPosShield
			$iPos = ((IsArray($a1) And ($a1[0] <> $a2[0] Or $a1[1] <> $a2[1])) ? 4 : 0)
			If $iPos > 0 Then
				SetDebugLog("AndroidEmbedCheck: Android Shield Position changed: X: " & $a1[0] & " <> " & $a2[0] & ", Y: " & $a1[1] & " <> " & $a2[1], Default, True)
			EndIf
		EndIf

		Return BitOR($iZorder, $iStyle, $iPos)
	EndIf
	Return 0
EndFunc   ;==>AndroidEmbedCheck

Func AndroidEmbedded()
	Return $g_bAndroidEmbedded
EndFunc   ;==>AndroidEmbedded

Func AndroidEmbedArrangeActive($bActive = Default)
	If $bActive = Default Then Return $g_hProcShieldInput[3]
	Local $bWasActive = $g_hProcShieldInput[3]
	$g_hProcShieldInput[3] = $bActive
	Return $bWasActive
EndFunc   ;==>AndroidEmbedArrangeActive

; Called when bot GUI initialize done
Func AndroidShieldStartup()
	_OnAutoItErrorRegister() ; Register custom crash handler
EndFunc   ;==>AndroidShieldStartup

; Called when bot closes
Func AndroidShieldDestroy()
	_OnAutoItErrorUnRegister() ; UnRegister custom crash handler
EndFunc   ;==>AndroidShieldDestroy

Func AndroidShieldForceDown($bForceDown = True, $AndroidHasFocus = False)
	Local $wasDown = $g_bAndroidShieldForceDown
	$g_bAndroidShieldForceDown = $bForceDown
	AndroidShield("AndroidShieldForceDown", Default, True, 0, $AndroidHasFocus)
	Return $wasDown
EndFunc   ;==>AndroidShieldForceDown

Func AndroidShieldForcedDown()
	Return $g_bAndroidShieldForceDown
EndFunc   ;==>AndroidShieldForcedDown

Func AndroidShieldHasFocus()
	Return $g_hProcShieldInput[2] = True
EndFunc   ;==>AndroidShieldHasFocus

Func AndroidShielded()
	Return $g_avAndroidShieldStatus[0] = True
EndFunc   ;==>AndroidShielded

; AndroidShieldActiveDelay return true if shield delay has been set and for $bIsStillWaiting = True also if still awaiting timeout
Func AndroidShieldActiveDelay($bIsStillWaiting = False)
	Return $g_avAndroidShieldDelay[0] <> 0 And $g_avAndroidShieldDelay[1] > 0 And ($bIsStillWaiting = False Or __TimerDiff($g_avAndroidShieldDelay[0]) < $g_avAndroidShieldDelay[1])
EndFunc   ;==>AndroidShieldActiveDelay

Func AndroidShieldCheck()
	If AndroidShieldActiveDelay(True) = True Then Return False
	Return AndroidShield("AndroidShieldCheck")
EndFunc   ;==>AndroidShieldCheck

Func AndroidShieldLock($Lock = Default)
	If $Lock = Default Then Return $g_hProcShieldInput[3]
	Local $wasLock = $g_hProcShieldInput[3]
	$g_hProcShieldInput[3] = $Lock
	Return $wasLock
EndFunc   ;==>AndroidShieldLock

; Syncronized _AndroidShield
Func AndroidShield($sCaller, $Enable = Default, $CallWinGetAndroidHandle = True, $iDelay = 0, $AndroidHasFocus = Default, $AndroidUpdateFocus = True)
	If $g_bAndroidShieldEnabled = False Or $g_hProcShieldInput[3] = True Then Return False
	If $iDelay > 0 Then
		Return _AndroidShield($sCaller, $Enable, $CallWinGetAndroidHandle, $iDelay, $AndroidHasFocus, $AndroidUpdateFocus)
	EndIf
	Return _AndroidShield($sCaller, $Enable, $CallWinGetAndroidHandle, $iDelay, $AndroidHasFocus, $AndroidUpdateFocus)
	#cs
	Local $hMutex = AcquireMutex("AndroidShield", Default, 1000)
	;If $g_bDebugAndroidEmbedded Then SetDebugLog("AndroidShield, acquired mutex: " & $hMutex, Default, True)
	If $hMutex <> 0 Then
		Local $Result = _AndroidShield($sCaller, $Enable, $CallWinGetAndroidHandle, $iDelay, $AndroidHasFocus, $AndroidUpdateFocus)
		ReleaseMutex($hMutex)
		;If $g_bDebugAndroidEmbedded Then SetDebugLog("AndroidShield, released mutex: " & $hMutex, Default, True)
		Return $Result
	Else
		SetDebugLog("AndroidShield, failed acquire mutex, caller: " & $sCaller, Default, True)
	EndIf
	Return False
	#ce
EndFunc   ;==>AndroidShield

Func _AndroidShield($sCaller, $Enable = Default, $CallWinGetAndroidHandle = True, $iDelay = 0, $AndroidHasFocus = Default, $AndroidUpdateFocus = True)

	Local $bForceUpdate = False

	If AndroidShieldActiveDelay() Then
		If AndroidShieldActiveDelay(True) = False Then
			If $Enable = Default Then $Enable = $g_avAndroidShieldDelay[2]
			If $AndroidHasFocus = Default Then $AndroidHasFocus = $g_avAndroidShieldDelay[3]
		Else
			If $iDelay = 0 Then
				If $Enable <> Default Then $g_avAndroidShieldDelay[2] = $Enable
				If $AndroidHasFocus <> Default Then $g_avAndroidShieldDelay[3] = $AndroidHasFocus
				Return False
			EndIf
		EndIf
	EndIf

	If $iDelay > 0 Then
		$g_avAndroidShieldDelay[0] = __TimerInit()
		$g_avAndroidShieldDelay[1] = $iDelay
		$g_avAndroidShieldDelay[2] = $Enable
		$g_avAndroidShieldDelay[3] = $AndroidHasFocus
		;SetDebugLog("ShieldAndroid: Delayed update $iDelay=" & $iDelay & ", $Enable=" & $Enable & ", $AndroidHasFocus=" & $AndroidHasFocus & ", caller: " & $sCaller, Default, True)
		Return False
	EndIf

	$g_avAndroidShieldDelay[0] = 0
	$g_avAndroidShieldDelay[1] = 0
	$g_avAndroidShieldDelay[2] = Default
	$g_avAndroidShieldDelay[3] = Default

	If $Enable = Default Then
		; determin shield status
		$Enable = $g_bRunState And $g_bBotPaused = False
		If $g_bAndroidShieldForceDown Then $Enable = False
	EndIf

	If $AndroidHasFocus = Default Then
		$AndroidHasFocus = AndroidShieldHasFocus() ;_WinAPI_GetFocus() = GUICtrlGetHandle($g_hFrmBotEmbeddedShieldInput)
	Else
		If $AndroidUpdateFocus Then $g_hProcShieldInput[2] = $AndroidHasFocus
	EndIf

	Local $shieldState = "active"
	Local $color = $g_iAndroidShieldColor
	Local $trans = $g_iAndroidShieldTransparency

	If $Enable = False Or $g_bBotPaused = True Then
		If _WinAPI_GetActiveWindow() = $g_hFrmBot And $AndroidHasFocus Then
			; android has focus
			$shieldState = "disabled-focus"
			$color = $g_iAndroidActiveColor
			$trans = $g_iAndroidActiveTransparency
			SetAccelerators(True) ; allow ESC for Android
		Else
			; android without focus
			$shieldState = "disabled-nofocus"
			$color = $g_iAndroidInactiveColor
			$trans = $g_iAndroidInactiveTransparency
			SetAccelerators(False) ; ESC now stopping bot again
		EndIf
	Else
		SetAccelerators(False) ; ESC now stopping bot again
	EndIf

	Local $bNoVisibleShield = $g_bChkBackgroundMode = False
	Local $bDetachedShield = $bNoVisibleShield = False And ($g_bAndroidShieldPreWin8 = True Or $g_iAndroidEmbedMode = 1)
	Local $bCreateShield = Not ($bNoVisibleShield And ($g_bAndroidShieldPreWin8 = True Or $g_iAndroidEmbedMode = 1))

	If $g_bAndroidEmbedded = False Then
		; nothing to do
		Return False
	EndIf
	If $g_bAndroidBackgroundLaunched = True Then
		; nothing to do
		Return False
	EndIf
	If $bForceUpdate = False And $g_avAndroidShieldStatus[0] = $Enable And $g_avAndroidShieldStatus[1] = $color And $g_avAndroidShieldStatus[2] = $trans And $g_avAndroidShieldStatus[3] = $bNoVisibleShield And $g_avAndroidShieldStatus[4] = $bDetachedShield Then
		; nothing to do
		Return False
	EndIf
	If ($CallWinGetAndroidHandle = False And $g_hAndroidWindow = 0) Or ($CallWinGetAndroidHandle = True And WinGetAndroidHandle() = 0) Then
		; nothing to do
		Return False
	EndIf

	Local $aPos = WinGetPos($g_hAndroidWindow)
	If IsArray($aPos) = 0 Or @error <> 0 Then
		; nothing to do
		Return False
	EndIf

	Local $hCtrlTarget = $g_aiAndroidEmbeddedCtrlTarget[0]
	Local $aPosCtl = $g_aiAndroidEmbeddedCtrlTarget[6]
	Local $targetIsHWnD = $hCtrlTarget = $g_hAndroidWindow

	; check if shield must be recreated
	If $g_hFrmBotEmbeddedShield <> 0 And ($g_avAndroidShieldStatus[3] <> $bNoVisibleShield Or $g_avAndroidShieldStatus[4] <> $bDetachedShield) Then
		GUIDelete($g_hFrmBotEmbeddedShield)
		$g_hFrmBotEmbeddedShield = 0
	EndIf

	$g_hProcShieldInput[3] = True
	Local $show_shield = @SW_SHOWNOACTIVATE
	If $bCreateShield And ($Enable <> $g_avAndroidShieldStatus[0] Or $g_hFrmBotEmbeddedShield = 0) Then ;Or $bForceUpdate = True Then
		#cs
		If $Enable = True Then
			SetDebugLog("Shield Android Control (" & $aPosCtl[2] & "x" & $aPosCtl[3] & ")", Default, True)
			; Remove hooks as not not needed when shielded
			;AndroidShieldHook(False)
		Else
			SetDebugLog("Unshield Android Control", Default, True)
			; Add hooks to forward messages to android
			;AndroidShieldHook(True)
		EndIf
		#ce
		If $bDetachedShield = False Then
			If $g_hFrmBotEmbeddedShield = 0 Then
				$g_hFrmBotEmbeddedShield = GUICreate("", $aPosCtl[2], $aPosCtl[3], 0, 0, BitOR($WS_CHILD, $WS_TABSTOP), ($bNoVisibleShield ? $WS_EX_TRANSPARENT : 0), $g_hFrmBot) ; Android Shield for mouse
			Else
				WinMove($g_hFrmBotEmbeddedShield, "", 0, 0, $aPosCtl[2], $aPosCtl[3]) ; $HWND_TOPMOST
			EndIf
			WinMove2($hCtrlTarget, "", -1, -1, -1, -1, $HWND_BOTTOM)
		Else
			Local $bHasFocus = WinActive($g_hFrmBot) <> 0
			Local $a = AndroidEmbed_HWnD_Position(True, $bDetachedShield)
			If $g_hFrmBotEmbeddedShield = 0 Then
				$g_hFrmBotEmbeddedShield = GUICreate("", $aPosCtl[2], $aPosCtl[3], $a[0], $a[1], BitOR($WS_POPUP, $WS_TABSTOP), BitOR($WS_EX_TOOLWINDOW, $WS_EX_NOACTIVATE, $WS_EX_TRANSPARENT), $g_hFrmBot) ; Android Shield for mouse
				_WinAPI_EnableWindow($g_hFrmBotEmbeddedShield, False)
				GUISetOnEvent($GUI_EVENT_PRIMARYDOWN, "BotMoveRequest")
				$g_hFrmBotEmbeddedMouse = GUICreate("", $aPosCtl[2], $aPosCtl[3], 0, 0, BitOR($WS_CHILD, $WS_TABSTOP), $WS_EX_TRANSPARENT, $g_hFrmBot) ; Android Mouse layer
			EndIf
			If $g_bBotDockedShrinked And Not $bHasFocus Then WinMove2($g_hFrmBotButtons, "", -1, -1, -1, -1, $HWND_BOTTOM, 0, False)
			WinMove2($g_hFrmBotEmbeddedShield, "", $a[0], $a[1], $aPosCtl[2], $aPosCtl[3], ($bHasFocus ? -1 : $HWND_BOTTOM), 0, False) ; $SWP_SHOWWINDOW
			WinMove2($g_hFrmBotEmbeddedMouse, "", 0, 0, $aPosCtl[2], $aPosCtl[3], ($bHasFocus ? -1 : $HWND_BOTTOM), 0, False) ; $SWP_SHOWWINDOW
			WinMove2($hCtrlTarget, "", -1, -1, -1, -1, $HWND_BOTTOM)
			SetDebugLog("$g_hFrmBotEmbeddedShield Position: " & $a[0] & ", " & $a[1] & ", " & $aPosCtl[2] & ", " & $aPosCtl[3], Default, True)
		EndIf
	EndIf

	If $bNoVisibleShield = False Then
		WinSetTrans($g_hFrmBotEmbeddedShield, "", $trans)
		GUISetBkColor($color, $g_hFrmBotEmbeddedShield)
	EndIf
	GUISetState($show_shield, $g_hFrmBotEmbeddedShield)
	GUISetState($show_shield, $g_hFrmBotEmbeddedMouse)
	If $g_bBotDockedShrinked Then GUISetState($show_shield, $g_hFrmBotButtons)

	$g_hProcShieldInput[3] = False

	; update shield current status
	$g_avAndroidShieldStatus[0] = $Enable
	$g_avAndroidShieldStatus[1] = $color
	$g_avAndroidShieldStatus[2] = $trans
	$g_avAndroidShieldStatus[3] = $bNoVisibleShield
	$g_avAndroidShieldStatus[4] = $bDetachedShield

	; Add hooks
	AndroidShieldStartup()

	HandleWndProc($shieldState = "disabled-focus")

	CheckBotZOrder()

	SetDebugLog("AndroidShield updated to " & $shieldState & "(handle=" & $g_hFrmBotEmbeddedShield & ", color=" & Hex($color, 6) & "), caller: " & $sCaller, Default, True)

	Return True
EndFunc   ;==>_AndroidShield

Func AndroidGraphicsGdiBegin()
	If $g_bAndroidEmbedded = False Then Return 0

	AndroidGraphicsGdiEnd()

	; shield must be on before creating the gaphics
	Local $wasDown = AndroidShieldForcedDown()
	AndroidShieldForceDown(False)
	AndroidShield("AndroidGraphicsGdiBegin", True, True, 0, False)

	Local $iL = 0
	Local $iT = 0
	Local $iW = $g_iAndroidClientWidth
	Local $iH = $g_iAndroidClientHeight
	Local $iOpacity = 255

	Local $aPosCtl = $g_aiAndroidEmbeddedCtrlTarget[6]
	If IsArray($aPosCtl) = 1 Then
		$iW = $aPosCtl[2]
		$iH = $aPosCtl[3]
	EndIf

	Local $a = [0, 0]
	If $g_hFrmBotEmbeddedGraphics = 0 Then
		Local $bDetachedShield = $g_avAndroidShieldStatus[4]
		If $bDetachedShield = True Then
			Local $a = AndroidEmbed_HWnD_Position(True, $bDetachedShield)
			$iL = $a[0]
			$iT = $a[1]
		EndIf
		$g_hFrmBotEmbeddedGraphics = GUICreate("", $iW, $iH, $iL, $iT, $WS_CHILD, BitOR($WS_EX_TOOLWINDOW, $WS_EX_NOACTIVATE, $WS_EX_LAYERED, $WS_EX_TOPMOST), $g_hFrmBot)
	EndIf
	WinMove2($g_hFrmBotEmbeddedGraphics, "", $iW, $iH, $iL, $iT, $HWND_NOTOPMOST, 0, False)
	GUISetState(@SW_SHOWNOACTIVATE, $g_hFrmBotEmbeddedGraphics)

	;WinMove2($g_hFrmBotEmbeddedShield, "", $iW, $iH, $iL, $iT, $HWND_TOPMOST, 0, False)
	;WinMove2($g_hFrmBotEmbeddedGraphics, "", $iW, $iH, $iL, $iT, $HWND_TOPMOST, 0, False)

	Local $hDC = _WinAPI_GetDC($g_hFrmBotEmbeddedGraphics)
	Local $hMDC = AndroidGraphicsGdiAddObject("hMDC", _WinAPI_CreateCompatibleDC($hDC)) ; idx = 0
	Local $hBitmap = AndroidGraphicsGdiAddObject("hBitmap", _WinAPI_CreateCompatibleBitmap($hDC, $iW, $iH)) ; idx = 1
	_WinAPI_SelectObject($hMDC, $hBitmap)
	AndroidGraphicsGdiAddObject("hDC", $hDC) ; idx = 2
	Local $hGraphics = AndroidGraphicsGdiAddObject("Graphics", _GDIPlus_GraphicsCreateFromHDC($hMDC)) ; idx = 3

	_GDIPlus_GraphicsSetSmoothingMode($hGraphics, $GDIP_SMOOTHINGMODE_HIGHQUALITY)
	_GDIPlus_GraphicsClear($hGraphics)

	Local $tSIZE = DllStructCreate($tagSIZE)
	AndroidGraphicsGdiAddObject("DllStruct", $tSIZE) ; idx = 4
	Local $pSize = DllStructGetPtr($tSIZE)
	DllStructSetData($tSIZE, "X", $iW)
	DllStructSetData($tSIZE, "Y", $iH)
	Local $tSource = DllStructCreate($tagPOINT)
	AndroidGraphicsGdiAddObject("DllStruct", $tSource) ; idx = 5
	Local $pSource = DllStructGetPtr($tSource)
	Local $tBlend = DllStructCreate($tagBLENDFUNCTION)
	AndroidGraphicsGdiAddObject("DllStruct", $tBlend) ; idx = 6
	Local $pBlend = DllStructGetPtr($tBlend)
	DllStructSetData($tBlend, "Alpha", $iOpacity)
	DllStructSetData($tBlend, "Format", 1)
	Local $tPoint = DllStructCreate($tagPOINT)
	AndroidGraphicsGdiAddObject("DllStruct", $tPoint) ; idx = 7
	Local $pPoint = DllStructGetPtr($tPoint)
	DllStructSetData($tPoint, "X", $a[0])
	DllStructSetData($tPoint, "Y", $a[1])
	AndroidGraphicsGdiUpdate()
	SetDebugLog("AndroidGraphicsGdiBegin: Graphics " & $hGraphics)

	AndroidShieldForceDown($wasDown)

	Return $hGraphics
EndFunc   ;==>AndroidGraphicsGdiBegin

Func AndroidGraphicsGdiUpdate()
	If $g_bAndroidEmbedded = False Then Return 0
	Local $hMDC = $g_aiAndroidEmbeddedGraphics[0][1]
	Local $hDC = $g_aiAndroidEmbeddedGraphics[2][1]
	Local $pSize = DllStructGetPtr($g_aiAndroidEmbeddedGraphics[4][1])
	Local $pSource = DllStructGetPtr($g_aiAndroidEmbeddedGraphics[5][1])
	Local $pBlend = DllStructGetPtr($g_aiAndroidEmbeddedGraphics[6][1])
	Local $pPoint = DllStructGetPtr($g_aiAndroidEmbeddedGraphics[7][1])
	Local $tPoint = DllStructCreate($tagPOINT, $pPoint)

	Local $bDetachedShield = $g_avAndroidShieldStatus[4]
	Local $a = AndroidEmbed_HWnD_Position(True, $bDetachedShield)
	DllStructSetData($tPoint, "X", $a[0])
	DllStructSetData($tPoint, "Y", $a[1])
	_WinAPI_UpdateLayeredWindow($g_hFrmBotEmbeddedGraphics, $hDC, $pPoint, $pSize, $hMDC, $pSource, 0, $pBlend, $ULW_ALPHA)
EndFunc   ;==>AndroidGraphicsGdiUpdate

Func AndroidGraphicsGdiAddObject($sType, $hHandle)
	If $g_bAndroidEmbedded = False Then Return 0
	Local $i = UBound($g_aiAndroidEmbeddedGraphics)
	ReDim $g_aiAndroidEmbeddedGraphics[$i + 1][2]
	$g_aiAndroidEmbeddedGraphics[$i][0] = $sType
	$g_aiAndroidEmbeddedGraphics[$i][1] = $hHandle
	SetDebugLog("AndroidGraphicsGdiAddObject: " & $sType & " " & $hHandle)
	Return $hHandle
EndFunc   ;==>AndroidGraphicsGdiAddObject

Func AndroidGraphicsGdiEnd($Result = Default, $bClear = True)
	If UBound($g_aiAndroidEmbeddedGraphics) > 0 Then
		Local $i
		For $i = UBound($g_aiAndroidEmbeddedGraphics) - 1 To 0 Step -1
			Local $sType = $g_aiAndroidEmbeddedGraphics[$i][0]
			Local $hHandle = $g_aiAndroidEmbeddedGraphics[$i][1]
			If $hHandle <> 0 Then
				SetDebugLog("AndroidGraphicsGdiEnd: Dispose/release/delete " & $sType & " " & $hHandle)
				Switch $sType
					Case "Pen"
						_GDIPlus_PenDispose($hHandle)
					Case "DllStruct"
						;$g_aiAndroidEmbeddedGraphics[$i][1] = 0 ; still needed for AndroidGraphicsGdiUpdate()
					Case "Graphics"
						_GDIPlus_GraphicsClear($hHandle)
						AndroidGraphicsGdiUpdate()
						_GDIPlus_GraphicsDispose($hHandle)
					Case "hDC"
						_WinAPI_ReleaseDC($g_hFrmBotEmbeddedGraphics, $hHandle)
					Case "hBitmap"
						_WinAPI_DeleteObject($hHandle)
					Case "hMDC"
						_WinAPI_DeleteDC($hHandle)
					Case Else
						SetDebugLog("Unknown GDI Type: " & $sType)
				EndSwitch
			EndIf
		Next
		ReDim $g_aiAndroidEmbeddedGraphics[0][2]
		If $g_hFrmBotEmbeddedGraphics <> 0 Then
			GUIDelete($g_hFrmBotEmbeddedGraphics)
			$g_hFrmBotEmbeddedGraphics = 0
		EndIf
	EndIf

	Return $Result
EndFunc   ;==>AndroidGraphicsGdiEnd

Func AndroidDpiAwareness($bCheckAwareness = Default)
	If $bCheckAwareness = Default Then $bCheckAwareness = False
	If $g_hAndroidWindowDpiAware = $g_hAndroidWindow Or GetProcessDpiAwareness(GetAndroidPid()) Then
		; already aware
		$g_hAndroidWindowDpiAware = $g_hAndroidWindow
		If $bCheckAwareness = True Then	Return True
		Return False
	EndIf
	If CheckDpiAwareness(True) = True Then	; super work-a-round to turn Android into DPI aware app
		If $g_hAndroidWindowDpiAware <> $g_hAndroidWindow Then
			; bot is DPI Aware, now make Android also DPI aware
			Local $bWasEmbedded = AndroidEmbedded()
			AndroidEmbed(True, False, False, True)
			AndroidEmbed(False, False, False, True)
			Return True
		EndIf
	EndIf
	Return False
EndFunc   ;==>AndroidDpiAwareness