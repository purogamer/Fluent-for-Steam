; #FUNCTION# ====================================================================================================================
; Name ..........: Auto Hide/Dock & Minimize for Emulator & Bot
; Description ...: Auto Dock or Hide Emulator and Minimize Bot after Start Bot & Restart Emulator
; Author ........: NguyenAnhHD
; Modified ......: Team AiO MOD++ (2019)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func autoHideAndDockAndMinimize($g_bIsAutoMinimizeAllowed = True)
	SetDebugLog("Inside autoHideAndDockAndMinimize: " & $g_bIsAutoMinimizeAllowed, $COLOR_INFO)
	If $g_bEnableAuto Then
		If $g_bChkAutoDock Then
			If Not $g_bAndroidEmbedded Then
				SetLog("Auto use Dock Android Window", $COLOR_INFO)
				btnEmbed()
			EndIf
		EndIf
		If $g_bChkAutoHideEmulator Then
			If Not $g_bIsHidden Then
				SetLog("Auto hidden the Emulator", $COLOR_INFO)
				btnHide()
				$g_bIsHidden = True
			EndIf
		EndIf
		If _Sleep($DELAYRUNBOT5) Then Return
	EndIf
	If $g_bChkAutoMinimizeBot And $g_bIsAutoMinimizeAllowed Then
		SetLog("Auto Minimize the Bot", $COLOR_INFO)
		If $g_bUpdatingWhenMinimized Then
			If $g_bHideWhenMinimized Then
				WinMove2($g_hFrmBot, "", -32000, -32000, -1, -1, 0, $SWP_HIDEWINDOW, False)
				_WinAPI_SetWindowLong($g_hFrmBot, $GWL_EXSTYLE, BitOR(_WinAPI_GetWindowLong($g_hFrmBot, $GWL_EXSTYLE), $WS_EX_TOOLWINDOW))
			EndIf
			If _WinAPI_IsIconic($g_hFrmBot) Then WinSetState($g_hFrmBot, "", @SW_RESTORE)
			If _WinAPI_IsIconic($g_hAndroidWindow) Then WinSetState($g_hAndroidWindow, "", @SW_RESTORE)
			WinMove2($g_hFrmBot, "", -32000, -32000, -1, -1, 0, BitOR($SWP_SHOWWINDOW, $SWP_NOACTIVATE), False)
		Else
			If $g_bHideWhenMinimized Then
				WinMove2($g_hFrmBot, "", -1, -1, -1, -1, 0, $SWP_HIDEWINDOW, False)
				_WinAPI_SetWindowLong($g_hFrmBot, $GWL_EXSTYLE, BitOR(_WinAPI_GetWindowLong($g_hFrmBot, $GWL_EXSTYLE), $WS_EX_TOOLWINDOW))
			EndIf
			WinSetState($g_hFrmBot, "", @SW_MINIMIZE)
		EndIf
		If _Sleep($DELAYRUNBOT5) Then Return
	EndIf
EndFunc   ;==>autoHideAndDockAndMinimize