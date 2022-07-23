; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Control
; Description ...: This file Includes all functions to current GUI
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: GkevinOD (2014)
; Modified ......: Hervidero (2015), kaganus (08-2015), CodeSlinger69 (01-2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

#include "functions\Other\GUICtrlGetBkColor.au3" ; Included here To use on GUI Control

Global $g_bRedrawBotWindow[3] = [True, False, False] ; [0] = window redraw enabled, [1] = window redraw required, [2] = window redraw requird by some controls, see CheckRedrawControls()
Global $g_hFrmBot_WNDPROC = 0
Global $g_hFrmBot_WNDPROC_ptr = 0

;~ ------------------------------------------------------
;~ Control Tab Files
;~ ------------------------------------------------------
;~ #include "GUI\InitializeVariables.au3"
#include "MBR GUI Control Variables.au3"
#include "GUI\MBR GUI Control Bottom.au3"
#include "GUI\MBR GUI Control Tab General.au3"
#include "GUI\MBR GUI Control Child Army.au3"
#include "GUI\MBR GUI Control Tab Village.au3"
#include "GUI\MBR GUI Control Tab Search.au3"
#include "GUI\MBR GUI Control Child Attack.au3"
#include "GUI\MBR GUI Control Tab DropOrder.au3"
#include "GUI\MBR GUI Control Tab EndBattle.au3"
#include "GUI\MBR GUI Control Tab SmartZap.au3"
#include "GUI\MBR GUI Control Tab Stats.au3"
#include "GUI\MBR GUI Control Collectors.au3"
#include "GUI\MBR GUI Control Attack Standard.au3"
#include "GUI\MBR GUI Control Attack Scripted.au3"
#include "GUI\MBR GUI Control Achievements.au3"
#include "GUI\MBR GUI Control Notify.au3"
#include "GUI\MBR GUI Control Child Upgrade.au3"
#include "GUI\MBR GUI Control Donate.au3"
#include "GUI\MBR GUI Control Bot Options.au3"
#include "GUI\MBR GUI Control Preset.au3"
#include "GUI\MBR GUI Control Child Misc.au3"
#include "GUI\MBR GUI Control Android.au3"
#include "MBR GUI Action.au3"
; Team AiO MOD++ (2019)
#include "Team__AiO__MOD++\GUI\MOD GUI Control.au3"

Func InitializeMainGUI($bGuiModeUpdate = False)
	InitializeControlVariables()

	; Initialize attack log
	If Not $bGuiModeUpdate Then
		AtkLogHead()
		BBAtkLogHead() ; Team AIO Mod++
	EndIf

	; Show Default Tab
	tabMain()

	; Load profile
	If FileExists($g_sProfileConfigPath) = 0 And $g_asCmdLine[0] > 0 Then
		; create new profile when doesn't exist but specified via command line
		createProfile()
		saveConfig()
		;applyConfig()
		setupProfileComboBox()
	ElseIf $g_iGuiMode <> 1 Then
		; not in normal GUI mode, initialize profiles (even though profile combobox doesn't exist)
		setupProfileComboBox()
	EndIf

	selectProfile() ; Choose the profile

	; Read saved settings
	If FileExists($g_sProfileConfigPath) Or FileExists($g_sProfileBuildingPath) Then
		readConfig()
		applyConfig()
	EndIf

	; Developer mode controls
	; If $g_bDevMode Then ;Why? - Custom - Team__AiO__MOD
		GUICtrlSetState($g_hChkDebugFunc, $GUI_SHOW + $GUI_ENABLE)
		GUICtrlSetState($g_hChkDebugDisableZoomout, $GUI_SHOW + $GUI_ENABLE)
		GUICtrlSetState($g_hChkDebugDisableVillageCentering, $GUI_SHOW + $GUI_ENABLE)
		GUICtrlSetState($g_hChkDebugDeadbaseImage, $GUI_SHOW + $GUI_ENABLE)
		GUICtrlSetState($g_hChkDebugOCR, $GUI_SHOW + $GUI_ENABLE)
		GUICtrlSetState($g_hChkDebugImageSave, $GUI_SHOW + $GUI_ENABLE)
		GUICtrlSetState($g_hChkdebugBuildingPos, $GUI_SHOW + $GUI_ENABLE)
		GUICtrlSetState($g_hChkdebugTrain, $GUI_SHOW + $GUI_ENABLE)
		GUICtrlSetState($g_hChkDebugOCRDonate, $GUI_SHOW + $GUI_ENABLE)
		GUICtrlSetState($g_hChkMakeIMGCSV, $GUI_SHOW + $GUI_ENABLE)
		GUICtrlSetState($g_hChkdebugAttackCSV, $GUI_SHOW + $GUI_ENABLE)
		GUICtrlSetState($g_hChkDebugSmartZap, $GUI_SHOW + $GUI_ENABLE)
;~ 		GUICtrlSetState($g_hbtnAttNow, $GUI_SHOW + $GUI_ENABLE)
	; EndIf

	; GUI events and messages
	GUISetOnEvent($GUI_EVENT_CLOSE, "GUIEvents", $g_hFrmBot)
	GUISetOnEvent($GUI_EVENT_MINIMIZE, "GUIEvents", $g_hFrmBot)
	GUISetOnEvent($GUI_EVENT_RESTORE, "GUIEvents", $g_hFrmBot)

	GUIRegisterMsg($WM_COMMAND, "GUIControl_WM_COMMAND")
	GUIRegisterMsg($WM_NOTIFY, "GUIControl_WM_NOTIFY")
	For $i = $WM_MOUSEMOVE To $WM_MOUSEWHEEL
		GUIRegisterMsg($i, "GUIControl_WM_MOUSE")
	Next
	GUIRegisterMsg($WM_CLOSE, "GUIControl_WM_CLOSE")
	GUIRegisterMsg($WM_NCACTIVATE, "GUIControl_WM_NCACTIVATE")
	GUIRegisterMsg($WM_SETFOCUS, "GUIControl_WM_FOCUS")
	GUIRegisterMsg($WM_KILLFOCUS, "GUIControl_WM_FOCUS")
	GUIRegisterMsg($WM_ACTIVATEAPP, "GUIControl_WM_ACTIVATEAPP")
	GUIRegisterMsg($WM_MOVE, "GUIControl_WM_MOVE")

	GUIRegisterMsg(_WinAPI_RegisterWindowMessage('SHELLHOOK'), 'GUIControl_WM_SHELLHOOK')
	_WinAPI_RegisterShellHookWindow($g_hFrmBot)
	;GUIRegisterMsg($WM_PAINT, "GUIControl_WM_MPAINT")

	#cs
		Local $events = [$WM_KEYDOWN, $WM_KEYUP, $WM_SYSKEYDOWN, $WM_SYSKEYUP, $WM_MOUSEWHEEL, $WM_MOUSEHWHEEL]
		For $event in $events
		GUIRegisterMsg($event, "GUIControl_AndroidEmbedded")
		Next
	#ce

	; Register Windows Procedure to support Mouse and Keyboard in docked mode
	$g_hFrmBot_WNDPROC_ptr = DllCallbackGetPtr(DllCallbackRegister("frmBot_WNDPROC", "ptr", "hwnd;uint;long;ptr"))


	cmbDBAlgorithm()
	cmbABAlgorithm()
	SetAccelerators()

EndFunc   ;==>InitializeMainGUI

Func SetCriticalMessageProcessing($bEnterCritical = Default)
	If $bEnterCritical = Default Then Return $g_bCriticalMessageProcessing
	Local $wasCritical = $g_bCriticalMessageProcessing
	$g_bCriticalMessageProcessing = $bEnterCritical
	Return $wasCritical
EndFunc   ;==>SetCriticalMessageProcessing

Func UpdateFrmBotStyle()
	If $g_iGuiMode = 0 Then Return False

	Local $bChanged = False
	Local $ShowMinimize = $g_bAndroidBackgroundLaunched = True Or $g_bAndroidEmbedded = False Or ($g_bAndroidEmbedded = True And $g_bChkBackgroundMode = True) ; now bot is not really minimized anymore
	Local $lStyle = $WS_MINIMIZEBOX
	Local $lNewStyle = ($ShowMinimize ? $lStyle : 0)
	Local $lCurStyle = _WinAPI_GetWindowLong($g_hFrmBot, $GWL_STYLE)
	If BitAND($lCurStyle, $lStyle) <> $lNewStyle Then
		$bChanged = True
		If $ShowMinimize Then
			$lNewStyle = BitOR($lCurStyle, $lStyle)
			SetDebugLog("Show Bot Minimize Button")
		Else
			$lNewStyle = BitAND($lCurStyle, BitNOT($lStyle))
			SetDebugLog("Hide Bot Minimize Button")
		EndIf
		_WinAPI_SetWindowLong($g_hFrmBot, $GWL_STYLE, $lNewStyle)
	EndIf
	If CheckBotShrinkExpandButton() Then $bChanged = True
	Return $bChanged
EndFunc   ;==>UpdateFrmBotStyle

Func IsAlwaysEnabledControl($controlID)
	; Scripting.Dictionary is faster than array search!
	Local $bAlwaysEnabled = (($oAlwaysEnabledControls.Item($controlID)) ? (True) : (False))
	Return $bAlwaysEnabled
EndFunc   ;==>IsAlwaysEnabledControl

; Accelerator Key, more responsive than buttons in run-mode
Func SetAccelerators($bDockedUnshieledFocus = False)
	If $g_iGuiMode = 0 Then Return
	Local $aAccelKeys[2][2] = [["{ESC}", $g_hBtnStop], ["{PAUSE}", $g_hBtnPause]]
	Local $aAccelKeys_DockedUnshieldedFocus[3][2] = [["{ESC}", $g_hFrmBotEmbeddedShieldInput], ["{ENTER}", $g_hFrmBotEmbeddedShieldInput], ["{PAUSE}", $g_hBtnPause]] ; used in docked mode when android has focus to support ESC for android

	GUISetAccelerators(0, $g_hFrmBot) ; Remove all accelerators

	If $bDockedUnshieledFocus = False Then
		GUISetAccelerators($aAccelKeys, $g_hFrmBot)
	Else
		GUISetAccelerators($aAccelKeys_DockedUnshieldedFocus, $g_hFrmBot)
	EndIf
EndFunc   ;==>SetAccelerators

Func DisableProcessWindowsGhosting()
	DllCall($g_hLibUser32DLL, "none", "DisableProcessWindowsGhosting")
EndFunc   ;==>DisableProcessWindowsGhosting

; Check for any activated window to show bot when Android activated
Func GUIControl_WM_SHELLHOOK($hWin, $iMsg, $wParam, $lParam)
	If $g_iDebugWindowMessages Then SetDebugLog("GUIControl_WM_SHELLHOOK: $hWin=" & $hWin & ", $wParam=" & $wParam & ", $lParam=" & $lParam & ", Active=" & _WinAPI_GetActiveWindow(), Default, True)
	If $hWin = $g_hFrmBot And $lParam And BitAND($wParam, $HSHELL_WINDOWACTIVATED) And Not $g_bIsHidden And Not AndroidEmbedded() Then
		Select
			Case $lParam = $g_hAndroidWindow
				; show bot without activating
				;BotToFront($lParam)
				BotMinimizeRestore(False, "GUIControl_WM_SHELLHOOK", False, 0, $g_hAndroidWindow)
				;If Not $g_bIsHidden Then HideAndroidWindow(False, False, Default, "GUIControl_WM_SHELLHOOK") ; Android can be hidden
				#cs moved to GUIControl_WM_ACTIVATEAPP as it enters here without activating the bot
					Case Not $g_bIsHidden And $lParam = $g_hFrmBot ;And WinActive($g_hFrmBot)
					; show Android without activating
					HideAndroidWindow(False, False)
					;AndroidToFront()
				#ce moved to GUIControl_WM_ACTIVATEAPP as it enters here without activating the bot
		EndSelect
	EndIf
EndFunc   ;==>GUIControl_WM_SHELLHOOK

Func GUIControl_WM_ACTIVATEAPP($hWin, $iMsg, $wParam, $lParam)
	; bot activated/deactivated
	If $g_iDebugWindowMessages Then SetDebugLog("GUIControl_WM_ACTIVATEAPP: $hWin=" & $hWin & ", $wParam=" & $wParam & ", $lParam=" & $lParam & ", Active=" & _WinAPI_GetActiveWindow(), Default, True)
	If $wParam Then
		; bot activated
		;If BitAND($g_iBotDesignFlags, 2) And $g_bAndroidEmbedded And $g_bBotDockedShrinked Then BotShrinkExpandToggle() ; auto expand bot again
		; show Android behind bot without activating it
		If Not $g_bFlushGuiLogActive And Not $g_bIsHidden And Not AndroidEmbedded() And $g_bChkBackgroundMode Then ShowAndroidWindow($g_hFrmBot, False, Default, "GUIControl_WM_ACTIVATEAPP")
	Else
		; bot deactivated
		If BitAND($g_iBotDesignFlags, 2) And $g_bAndroidEmbedded And Not $g_bBotDockedShrinked Then BotShrinkExpandToggle() ; auto shrink bot again ;
	EndIf
	Return $GUI_RUNDEFMSG
EndFunc   ;==>GUIControl_WM_ACTIVATEAPP

Func GUIControl_WM_NCACTIVATE($hWin, $iMsg, $wParam, $lParam)
	Local $wasCritical = SetCriticalMessageProcessing(True)
	Local $wasAllowed = $g_bTogglePauseAllowed
	$g_bTogglePauseAllowed = False
	If $g_iDebugWindowMessages Then SetDebugLog("GUIControl_WM_NCACTIVATE: $hWin=" & $hWin & ", $iMsg=" & Hex($iMsg, 8) & ", $wParam=" & $wParam & ", $lParam=" & $lParam, Default, True)
	Local $iActive = BitAND($wParam, 0x0000FFFF)
	If $hWin = $g_hFrmBot Then
		If $g_bAndroidEmbedded And AndroidShieldActiveDelay() = False Then
			If $iActive = 0 Then
				AndroidShield("GUIControl_WM_NCACTIVATE not active", Default, False, 0, False, False)
			Else
				AndroidShield("GUIControl_WM_NCACTIVATE active", Default, False)
			EndIf
		EndIf
		If $iActive = 0 Then
			; bot deactivated
			If $g_iDebugWindowMessages Then SetDebugLog("GUIControl_WM_NCACTIVATE: Deactivate Bot", Default, True)
			_WinAPI_SetFocus(0)
		Else
			; bot activated
			If $g_bHideWhenMinimized = False Then BotRestore("GUIControl_WM_NCACTIVATE")
			If $g_iDebugWindowMessages Then SetDebugLog("GUIControl_WM_NCACTIVATE: Activate Bot", Default, True)
			If BitAND($g_iBotDesignFlags, 2) And $g_bAndroidEmbedded And $g_bBotDockedShrinked Then BotShrinkExpandToggle() ; auto expand bot again
		EndIf
		If $g_bAndroidEmbedded And $g_iAndroidEmbedMode = 1 And AndroidShieldActiveDelay() = False Then
			AndroidEmbedCheck(False, $iActive <> 0, 1) ; Always update z-order
			AndroidShield("GUIControl_WM_NCACTIVATE", Default, False)
		EndIf
	EndIf
	$g_bTogglePauseAllowed = $wasAllowed
	SetCriticalMessageProcessing($wasCritical)
	Return $GUI_RUNDEFMSG
EndFunc   ;==>GUIControl_WM_NCACTIVATE

Func GUIControl_WM_FOCUS($hWin, $iMsg, $wParam, $lParam)
	Local $wasCritical = SetCriticalMessageProcessing(True)
	Local $wasAllowed = $g_bTogglePauseAllowed
	$g_bTogglePauseAllowed = False
	If $g_iDebugWindowMessages Then SetDebugLog("GUIControl_WM_FOCUS: $hWin=" & $hWin & ", $iMsg=" & Hex($iMsg, 8) & ", $wParam=" & $wParam & ", $lParam=" & $lParam, Default, True)
	Local $iActive = BitAND($wParam, 0x0000FFFF)
	Switch $hWin
		Case $g_hFrmBot
			If $g_bAndroidEmbedded And AndroidShieldActiveDelay() = False Then
				AndroidShield("GUIControl_WM_FOCUS", Default, False)
				If $g_iAndroidEmbedMode = 1 Then
					AndroidEmbedCheck(False, Default, 1) ; Always update z-order
				EndIf
			EndIf
	EndSwitch
	$g_bTogglePauseAllowed = $wasAllowed
	SetCriticalMessageProcessing($wasCritical)
	Return $GUI_RUNDEFMSG
EndFunc   ;==>GUIControl_WM_FOCUS

; Please don't use anywhere else... it's only used for GUIControl_WM_MOUSE to show color where Mouse is in docked Android screen
Func GetPixelFromWindow($x, $y, $hWin)
	Local $hDC = _WinAPI_GetWindowDC($hWin)
	Local $Result = DllCall("gdi32.dll", "int", "GetPixel", "int", $hDC, "int", $x, "int", $y)
	_WinAPI_ReleaseDC($hWin, $hDC)
	If UBound($Result) > 0 Then Return Hex($Result[0], 6)
	Return ""
EndFunc   ;==>GetPixelFromWindow

Func GUIControl_WM_MOUSE($hWin, $iMsg, $wParam, $lParam)
	Local $wasCritical = SetCriticalMessageProcessing(True)
	Local $wasAllowed = $g_bTogglePauseAllowed
	$g_bTogglePauseAllowed = False
	Local $hWinMouse = $g_hFrmBotEmbeddedMouse
	If $g_hFrmBotEmbeddedMouse = 0 Then $hWinMouse = (($g_iAndroidEmbedMode = 0) ? $g_hFrmBotEmbeddedShield : $g_hFrmBot)
	If $g_iDebugWindowMessages > 1 Then SetDebugLog("GUIControl_WM_MOUSE Received message: $hWin=" & $hWin & ",$iMsg=" & $iMsg & ",$wParam=" & $wParam & ",$lParam=" & $lParam & ",$hWinMouse=" & $hWinMouse, Default, True)
	CheckBotZOrder()
	; always ensure
	If $hWin <> $hWinMouse Or $g_bAndroidEmbedded = False Or $g_avAndroidShieldStatus[0] = True Then
		; wrong window of shield is up: block mouse
		If $g_iDebugWindowMessages > 1 Then SetDebugLog("GUIControl_WM_MOUSE block message: $hWin=" & $hWin & ",$iMsg=" & $iMsg & ",$wParam=" & $wParam & ",$lParam=" & $lParam & ",$hWinMouse=" & $hWinMouse, Default, True)
		If $g_avAndroidShieldStatus[0] = True And $iMsg = $WM_LBUTTONDOWN And $hWin <> $g_hFrmBotButtons Then BotMoveRequest() ; move window
		$g_bTogglePauseAllowed = $wasAllowed
		SetCriticalMessageProcessing($wasCritical)
		Return $GUI_RUNDEFMSG
	EndIf

	Switch $iMsg
		Case $WM_LBUTTONDOWN, $WM_LBUTTONUP, $WM_RBUTTONDOWN, $WM_RBUTTONUP, $WM_LBUTTONDBLCLK
			; ensure text box still has focus
			Local $hInput = GUICtrlGetHandle($g_hFrmBotEmbeddedShieldInput)
			_WinAPI_SetFocus($hInput)
	EndSwitch

	Local $x = BitAND($lParam, 0xFFFF)
	Local $y = BitAND($lParam, 0xFFFF0000) / 0x10000
	Switch $iMsg
		Case $WM_MOUSEMOVE
			If $g_bDebugClick And AndroidShieldHasFocus() Then
				Local $c = GetPixelFromWindow($x, $y, $g_hAndroidControl)
				_GUICtrlStatusBar_SetText($g_hStatusBar, StringFormat("Mouse %03i,%03i Color %s", $x, $y, $c))
			EndIf
		Case $WM_LBUTTONDOWN
			If $g_bDebugClick And AndroidShieldHasFocus() Then
				Local $c = GetPixelFromWindow($x, $y, $g_hAndroidControl)
				SetLog(StringFormat("Mouse LBUTTONDOWN %03i,%03i Color %s", $x, $y, $c), $COLOR_DEBUG)
			EndIf
		Case $WM_LBUTTONDBLCLK
			If $g_bDebugClick And AndroidShieldHasFocus() Then
				Local $c = GetPixelFromWindow($x, $y, $g_hAndroidControl)
				SetLog(StringFormat("Mouse LBUTTONDBLCLK %03i,%03i Color %s", $x, $y, $c), $COLOR_DEBUG)
			EndIf
		Case $WM_LBUTTONUP, $WM_RBUTTONUP
			If $g_iDebugWindowMessages Then
				SetDebugLog("GUIControl_WM_MOUSE: " & ($iMsg = $WM_LBUTTONUP ? "$WM_LBUTTONUP" : "$WM_RBUTTONUP") & " $hWin=" & $hWin & ",$iMsg=" & $iMsg & ",$wParam=" & $wParam & ",$lParam=" & $lParam & ", X=" & $x & ", Y=" & $y, Default, True)
			EndIf
			If AndroidShieldHasFocus() = False Then
				; set focus to text box
				Local $hInput = GUICtrlGetHandle($g_hFrmBotEmbeddedShieldInput)
				_WinAPI_SetFocus($hInput)
				AndroidShield("GUIControl_WM_MOUSE", Default, False, 0, True)
				$g_bTogglePauseAllowed = $wasAllowed
				SetCriticalMessageProcessing($wasCritical)
				Return $GUI_RUNDEFMSG
			EndIf
			#cs
				Case $WM_LBUTTONDOWN, $WM_RBUTTONDOWN
				If AndroidShieldHasFocus() = True Then
				Local $hCtrlTarget = $g_aiAndroidEmbeddedCtrlTarget[0]
				_SendMessage($hCtrlTarget, $iMsg, $wParam, $lParam)
				EndIf
			#ce
	EndSwitch
	;#cs
	If AndroidShieldHasFocus() = False Then
		$g_bTogglePauseAllowed = $wasAllowed
		SetCriticalMessageProcessing($wasCritical)
		Return $GUI_RUNDEFMSG
	EndIf

	Local $bMinitouch = True
	If $bMinitouch Then
		Static $s_x, $s_y
		Local $iBytesSent = 0
		Switch $iMsg
			Case $WM_MOUSEMOVE
				If $s_x <> $x Or $s_y <> $y Then
					$iBytesSent = Minitouch($x, $y, 0)
				EndIf
			Case $WM_LBUTTONDOWN, $WM_LBUTTONDBLCLK
				$iBytesSent = Minitouch($x, $y, 1)
			Case $WM_LBUTTONUP
				$iBytesSent = Minitouch($x, $y, 2)
		EndSwitch
		$bMinitouch = ($iBytesSent > 0)
		$s_x = $x
		$s_y = $y
	EndIf

	If Not $bMinitouch And ($iMsg <> $WM_MOUSEMOVE Or $g_iAndroidEmbedMode <> 0) Then
		; not all message got thru here, so disabled
		;$x += $g_aiMouseOffset[0]
		;$y += $g_aiMouseOffset[1]
		$lParam = $y * 0x10000 + $x
		;Nox 6.2.0.0 docked clicks didn't work anymore, so copied window handle code from _ControlClick function
		Local $useHWnD = $g_iAndroidControlClickWindow = 1 And $g_bAndroidEmbedded = False
		Local $hCtrlTarget = (($useHWnD) ? ($g_hAndroidWindow) : ($g_hAndroidControl))
		;Local $hCtrlTarget = $g_aiAndroidEmbeddedCtrlTarget[0]
		;Local $Result = _WinAPI_PostMessage($hCtrlTarget, $iMsg, $wParam, $lParam)
		Local $Result = _SendMessage($hCtrlTarget, $iMsg, $wParam, $lParam)
	EndIf
	;Local $Result = _SendMessage($hCtrlTarget, $iMsg, $wParam, $lParam)
	;#ce
	$g_bTogglePauseAllowed = $wasAllowed
	SetCriticalMessageProcessing($wasCritical)
	Return $GUI_RUNDEFMSG
EndFunc   ;==>GUIControl_WM_MOUSE

Func GUIControl_AndroidEmbedded($hWin, $iMsg, $wParam, $lParam)
	Static $GUIControl_AndroidEmbedded_Call = [0, 0, 0, 0]

	If $g_bAndroidEmbedded = False Or $g_avAndroidShieldStatus[0] = True Then
		Return $GUI_RUNDEFMSG
	EndIf
	Local $wasCritical = SetCriticalMessageProcessing(True)
	Local $wasAllowed = $g_bTogglePauseAllowed
	$g_bTogglePauseAllowed = False
	Switch $iMsg
		Case $WM_KEYDOWN, $WM_KEYUP, $WM_SYSKEYDOWN, $WM_SYSKEYUP, $WM_MOUSEWHEEL ; $WM_KEYFIRST To $WM_KEYLAST
			If $iMsg = $WM_KEYUP And $wParam = 27 Then
				; send ESC as ADB back
				Local $wasSilentSetLog = $g_bSilentSetLog
				$g_bSilentSetLog = True
				AndroidBackButton(False)
				$g_bSilentSetLog = $wasSilentSetLog
				;_WinAPI_SetFocus(GUICtrlGetHandle($g_hFrmBotEmbeddedShieldInput))
				;If $g_bDebugAndroidEmbedded Then AndroidShield("GUIControl_AndroidEmbedded WM_SETFOCUS", Default, False, 0, True)
				;AndroidShield(Default, False, 10, AndroidShieldHasFocus())
			Else
				Local $hCtrlTarget = $g_aiAndroidEmbeddedCtrlTarget[0]
				If $GUIControl_AndroidEmbedded_Call[0] <> $hCtrlTarget Or $GUIControl_AndroidEmbedded_Call[1] <> $iMsg Or $GUIControl_AndroidEmbedded_Call[2] <> $wParam Or $GUIControl_AndroidEmbedded_Call[3] <> $lParam Then
					; protect against strange infinite loops with BS1/2 when using Ctrl-MouseWheel
					If $g_bDebugAndroidEmbedded Then SetDebugLog("GUIControl_AndroidEmbedded: FORWARD $hWin=" & $hWin & ", $iMsg=" & Hex($iMsg) & ", $wParam=" & $wParam & ", $lParam=" & $lParam & ", $hCtrlTarget=" & $hCtrlTarget, Default, True)
					_WinAPI_PostMessage($hCtrlTarget, $iMsg, $wParam, $lParam)
					$GUIControl_AndroidEmbedded_Call[0] = $hCtrlTarget
					$GUIControl_AndroidEmbedded_Call[1] = $iMsg
					$GUIControl_AndroidEmbedded_Call[2] = $wParam
					$GUIControl_AndroidEmbedded_Call[3] = $lParam
				EndIf
			EndIf
	EndSwitch
	$g_bTogglePauseAllowed = $wasAllowed
	SetCriticalMessageProcessing($wasCritical)
	Return $GUI_RUNDEFMSG
EndFunc   ;==>GUIControl_AndroidEmbedded

Func GUIControl_WM_COMMAND($hWind, $iMsg, $wParam, $lParam)
	If $g_bGUIControlDisabled = True Then Return $GUI_RUNDEFMSG
	;Local $wasCritical = SetCriticalMessageProcessing(True)
	Local $wasAllowed = $g_bTogglePauseAllowed
	$g_bTogglePauseAllowed = False
	If $g_iDebugWindowMessages > 1 Then SetDebugLog("GUIControl_WM_COMMAND: $hWind=" & $hWind & ",$iMsg=" & $iMsg & ",$wParam=" & $wParam & ",$lParam=" & $lParam, Default, True)
	;#forceref $hWind, $iMsg, $wParam, $lParam
	Local $nNotifyCode = BitShift($wParam, 16)
	Local $nID = BitAND($wParam, 0x0000FFFF)
	Local $hCtrl = $lParam
	;If $__TEST_ERROR = True Then ConsoleWrite("GUIControl: $hWind=" & $hWind & ", $iMsg=" & $iMsg & ", $wParam=" & $wParam & ", $lParam=" & $lParam & ", $nNotifyCode=" & $nNotifyCode & ", $nID=" & $nID & ", $hCtrl=" & $hCtrl & ", $g_hFrmBot=" & $g_hFrmBot & @CRLF)

	; check shield status
	If $hWind <> $g_hFrmBotEmbeddedShield And $hWind <> $g_hFrmBotEmbeddedGraphics And $hWind <> $g_hFrmBotEmbeddedMouse And $nID <> $g_hFrmBotEmbeddedShieldInput And $hWind <> $g_hFrmBotButtons Then
		If AndroidShieldHasFocus() = True Then
			; update shield with inactive state
			If $g_iDebugWindowMessages Then SetDebugLog("GUIControl_WM_COMMAND: $hWind=" & $hWind & ",$iMsg=" & $iMsg & ",$wParam=" & $wParam & ",$lParam=" & $lParam, Default, True)
			AndroidShield("GUIControl_WM_COMMAND", Default, False, 150, False)
		EndIf
	EndIf

	; WM_SYSCOMAND msdn: https://msdn.microsoft.com/en-us/library/windows/desktop/ms646360(v=vs.85).aspx
	CheckRedrawBotWindow(Default, Default, "GUIControl_WM_COMMAND")
	Switch $nID
		Case $g_hDivider
			;MoveDivider()
			$g_bMoveDivider = True
			SetDebugLog("MoveDivider active", Default, True)
		Case $g_hLblBotShrink, $g_hLblBotExpand
			BotShrinkExpandToggle()
		Case $g_hLblBotMinimize
			BotMinimizeRequest()
		Case $GUI_EVENT_CLOSE, $g_hLblBotClose
			; Clean up resources
			BotCloseRequest()
		Case $g_hLblBotMiniGUI, $g_hLblBotNormalGUI
			BotGuiModeToggleRequest()
		Case $g_hLblCreditsBckGrnd
			; Handle open URL clicks when label of link is over another background label
			Local $CursorInfo = GUIGetCursorInfo($g_hFrmBot)
			If IsArray($CursorInfo) = 1 Then
				Switch $CursorInfo[4]
					Case $g_hLblMyBotURL, $g_hLblForumURL
						OpenURL_Label($CursorInfo[4])
				EndSwitch
			EndIf
		Case $g_hLblMyBotURL, $g_hLblForumURL, $g_hLblUnbreakableLink
			; Handle open URL when label fires the event normally
			OpenURL_Label($nID)
		Case $g_hFrmBot_URL_PIC, $g_hFrmBot_URL_PIC2
			OpenURL_Label($g_hLblMyBotURL)
		Case $g_hLblDonate
			; Donate URL is not in text nor tooltip
			ShellExecute("https://mybot.run/forums/index.php?/donate/make-donation/")
		Case $g_hBtnStart, $g_hTblStart
			btnStart()
		Case $g_hBtnStop, $g_hTblStop
			btnStop()
		Case $g_hBtnPause, $g_hTblPause
			btnPause()
			HideShields(True) ; Custom - Team__AiO__MOD
		Case $g_hBtnResume, $g_hTblResume
			btnResume()
			HideShields(False) ; Custom - Team__AiO__MOD
		Case $g_hBtnHide
			btnHide()
		Case $btnResetStats
			btnResetStats()
		Case $g_hBtnAttackNowDB
			btnAttackNowDB()
		Case $g_hBtnAttackNowLB
			btnAttackNowLB()
		Case $g_hBtnMakeScreenshot, $g_hTblMakeScreenshot
			If $g_bRunState Then
				; call with flag when bot is running to execute on _sleep() idle
				btnMakeScreenshot()
			Else
				; call directly when bot is stopped
				If Not $g_bScreenshotPNGFormat Then
					MakeScreenshot($g_sProfileTempPath, "jpg")
				Else
					MakeScreenshot($g_sProfileTempPath, "png")
				EndIf
			EndIf
		Case $g_hPicArrowLeft
			$g_iCurrentReport -= 1
			If $g_iCurrentReport < $g_iVillageReport Then $g_iCurrentReport = $g_iBBReport
			btnVillageStat()
		Case $g_hPicArrowRight
			$g_iCurrentReport += 1
			If $g_iCurrentReport > $g_iBBReport Then $g_iCurrentReport = $g_iVillageReport
			btnVillageStat()
			; debug checkboxes and buttons
		Case $g_hChkDebugSetlog
			chkDebugSetlog()
		Case $g_hChkDebugAndroid
			chkDebugAndroid()
		Case $g_hChkDebugClick
			chkDebugClick()
		Case $g_hChkDebugFunc
			chkDebugFunc()
		Case $g_hChkDebugDisableZoomout
			chkDebugDisableZoomout()
		Case $g_hChkDebugDisableVillageCentering
			chkDebugDisableVillageCentering()
		Case $g_hChkDebugDeadbaseImage
			chkDebugDeadbaseImage()
		Case $g_hChkDebugOCR
			chkDebugOcr()
		Case $g_hChkDebugImageSave
			chkDebugImageSave()
		Case $g_hChkdebugBuildingPos
			chkDebugBuildingPos()
		Case $g_hChkdebugTrain
			chkDebugTrain()
		Case $g_hChkDebugOCRDonate
			chkdebugOCRDonate()
		Case $g_hChkdebugAttackCSV
			chkdebugAttackCSV()
		Case $g_hChkMakeIMGCSV
			chkmakeIMGCSV()
		Case $g_hBtnTestTrain
			btnTestTrain()
			;TestSmartFarm()
		Case $g_hBtnTestDonateCC
			btnTestDonateCC()
		Case $g_hBtnTestRequestCC
			btnTestRequestCC()
		Case $g_hBtnTestSendText
			btnTestSendText()
		Case $g_hBtnTestAttackBar
			btnTestAttackBar()
		Case $g_hBtnTestClickDrag
			btnTestClickDrag()
		Case $g_hBtnTestImage
			btnTestImage()
		Case $g_hBtnTestVillageSize
			btnTestVillageSize()
		Case $g_hBtnTestDeadBase
			btnTestDeadBase()
		Case $g_hbtnExecuteCapture
			btnRunFunction(True) ; Custom - Team AIO Mod++
		Case $g_hBtnTestTHimgloc
			imglocTHSearch()
		Case $g_hBtnTestAttackCSV
			btnTestAttackCSV()
		Case $g_hBtnTestArmyWindow
			Local $RuntimeA = $g_bRunState
			$g_bRunState = True
			Setlog("Army Window Test")
			_checkArmyCamp(False, False, False, True)
			$g_bRunState = $RuntimeA
		Case $g_hBtnTestBuildingLocation
			btnTestGetLocationBuilding()
		Case $g_hBtnRunFunction
			btnRunFunction(False) ; Custom - Team AIO Mod++
		Case $g_hBtnTestCleanYard
			btnTestCleanYard()
		Case $g_hBtnTestOcrMemory
			btnTestOcrMemory()
		Case $g_hBtnTestConfigSave
			saveConfig()
		Case $g_hBtnTestConfigRead
			readConfig()
		Case $g_hBtnTestConfigApply
			applyConfig()
		Case $g_hBtnTestWeakBase
			btnTestWeakBase()
		Case $g_hBtnTestClickAway
			btnTestClickAway()
		Case $g_hBtnTestAutoUpgrade
			AutoUpgrade(True)
		Case $g_hBtnTestUpgradeWindow
			btnTestUpgradeWindow()
		Case $g_hBtnTestSmartWait
			btnTestSmartWait()
		Case $g_hBtnConsoleWindow
			btnConsoleWindow()
		Case $g_hBtnTestTrainsimgloc

			Local $RuntimeA = $g_bRunState
			$g_bRunState = True
			Setlog("Prepare Attack test")
			PrepareAttack($DB, False)
			$g_bRunState = $RuntimeA
		Case $g_hBtnTestQuickTrainsimgloc

			Local $RuntimeA = $g_bRunState
			$g_bRunState = True
			Setlog("Prepare Attack test - Remaining troops")
			PrepareAttack($DB, True)
			$g_bRunState = $RuntimeA
	EndSwitch

	If $lParam = $g_hCmbGUILanguage Then
		If $nNotifyCode = $CBN_SELCHANGE Then cmbLanguage()
	EndIf

	$g_bTogglePauseAllowed = $wasAllowed
	Return $GUI_RUNDEFMSG
EndFunc   ;==>GUIControl_WM_COMMAND

Func GUIControl_WM_MOVE($hWind, $iMsg, $wParam, $lParam)
	;If $g_bGUIControlDisabled = True Then Return $GUI_RUNDEFMSG
	If $g_bBotShrinkExpandToggleRequested Then Return $GUI_RUNDEFMSG ; bot shrinking is requested or active
	Local $wasCritical = SetCriticalMessageProcessing(True)
	Local $wasAllowed = $g_bTogglePauseAllowed
	$g_bTogglePauseAllowed = False
	If $g_iDebugWindowMessages Then SetDebugLog("GUIControl_WM_MOVE: $hWind=" & $hWind & ",$iMsg=" & $iMsg & ",$wParam=" & $wParam & ",$lParam=" & $lParam, Default, True)
	If $hWind = $g_hFrmBot Then
		If $g_bUpdatingWhenMinimized And BotWindowCheck() = False And _WinAPI_IsIconic($g_hFrmBot) Then
			; ensure bot is not really minimized (e.g. when you minimize all windows)
			BotMinimize("GUIControl_WM_MOVE")
			$g_bTogglePauseAllowed = $wasAllowed
			SetCriticalMessageProcessing($wasCritical)
			Return $GUI_RUNDEFMSG
		EndIf

		If $g_bAndroidEmbedded And $g_bAndroidEmbeddedWindowZeroPosition Then
			; tell Android Window new bot position, this is currently only required for Nox 6.2.0.0 to fix user clicks when docked
			_SendMessage($g_hAndroidWindow, $iMsg, $wParam, $lParam)
		EndIf

		; update bot pos variables
		Local $g_iFrmBotPos = WinGetPos($g_hFrmBot)
		If $g_bAndroidEmbedded = False Then
			$g_iFrmBotPosX = ($g_iFrmBotPos[0] > -30000 ? $g_iFrmBotPos[0] : $g_iFrmBotPosX)
			$g_iFrmBotPosY = ($g_iFrmBotPos[1] > -30000 ? $g_iFrmBotPos[1] : $g_iFrmBotPosY)
		Else
			$g_iFrmBotDockedPosX = ($g_iFrmBotPos[0] > -30000 ? $g_iFrmBotPos[0] : $g_iFrmBotDockedPosX)
			$g_iFrmBotDockedPosY = ($g_iFrmBotPos[1] > -30000 ? $g_iFrmBotPos[1] : $g_iFrmBotDockedPosY)
		EndIf

		; required for screen change
		If $g_bAndroidEmbedded And AndroidEmbedArrangeActive() = False Then
			CheckBotShrinkExpandButton()
			Local $iAction = AndroidEmbedCheck(True)
			If $iAction > 0 Then
				; reposition docked android
				AndroidEmbedCheck(False, Default, $iAction)
				; redraw bot also
				;temp;_WinAPI_RedrawWindow($g_hFrmBotEx, 0, 0, $RDW_INVALIDATE)
				;temp;_WinAPI_RedrawWindow($frmBotBottom, 0, 0, $RDW_INVALIDATE)
			EndIf
			If $g_iDebugWindowMessages Then
				Local $a = $g_iFrmBotPos
				SetDebugLog("Bot Position: " & $a[0] & "," & $a[1] & " " & $a[2] & "x" & $a[3])
				$a = WinGetPos($g_hAndroidWindow)
				SetDebugLog("Android Position: " & $a[0] & "," & $a[1] & " " & $a[2] & "x" & $a[3])
				If $g_hFrmBotEmbeddedMouse <> 0 Then
					$a = WinGetPos($g_hFrmBotEmbeddedMouse)
					SetDebugLog("Mouse Window Position: " & $a[0] & "," & $a[1] & " " & $a[2] & "x" & $a[3])
				EndIf
			EndIf
		EndIf
	EndIf

	$g_bTogglePauseAllowed = $wasAllowed
	SetCriticalMessageProcessing($wasCritical)
	Return $GUI_RUNDEFMSG
EndFunc   ;==>GUIControl_WM_MOVE

Func GUIControl_WM_SYSCOMMAND($hWind, $iMsg, $wParam, $lParam)
	Local $wasCritical = SetCriticalMessageProcessing(True)
	Local $wasAllowed = $g_bTogglePauseAllowed
	$g_bTogglePauseAllowed = False
	If $g_iDebugWindowMessages Then SetDebugLog("GUIControl_WM_SYSCOMMAND: $hWind=" & $hWind & ",$iMsg=" & $iMsg & ",$wParam=" & $wParam & ",$lParam=" & $lParam, Default, True)
	;If $__TEST_ERROR = True Then SetDebugLog("Bot WM_SYSCOMMAND: " & Hex($wParam, 4))
	If $hWind = $g_hFrmBot Then ; Only close Bot when Bot Window sends Close Message
		Switch $wParam
			Case $SC_MINIMIZE
				BotMinimize("GUIControl_WM_SYSCOMMAND")
			Case $SC_RESTORE ; 0xf120
				; set redraw controls flag to check if after restore visibile controls require redraw
				BotRestore("GUIControl_WM_SYSCOMMAND")
			Case $SC_CLOSE ; 0xf060
				BotCloseRequest()
		EndSwitch
	EndIf
	$g_bTogglePauseAllowed = $wasAllowed
	SetCriticalMessageProcessing($wasCritical)
	Return $GUI_RUNDEFMSG
EndFunc   ;==>GUIControl_WM_SYSCOMMAND

Func GUIControl_WM_NOTIFY($hWind, $iMsg, $wParam, $lParam)
	Local $wasCritical = SetCriticalMessageProcessing(True)
	Local $wasAllowed = $g_bTogglePauseAllowed
	$g_bTogglePauseAllowed = False
	If $g_iDebugWindowMessages > 1 Then SetDebugLog("GUIControl_WM_NOTIFY: $hWind=" & $hWind & ",$iMsg=" & $iMsg & ",$wParam=" & $wParam & ",$lParam=" & $lParam, Default, True)
	Local $nNotifyCode = BitShift($wParam, 16)
	Local $nID = BitAND($wParam, 0x0000FFFF)
	Local $hCtrl = $lParam

	Local $bCheckEmbeddedShield = True

	Switch $nID
		Case $g_hSldAdditionalClickDelay
			sldAdditionalClickDelay()
		Case $g_hTabMain
			; Handle RichText controls
			tabMain()
		Case $g_hGUI_VILLAGE_TAB
			tabVillage()
		Case $g_hGUI_DONATE_TAB
			tabDONATE()
		Case $g_hGUI_ATTACK_TAB
			tabAttack()
		Case $g_hGUI_BUILDER_BASE_TAB ; BBase - Team AIO Mod++
			tabBuilderBase()
		Case $g_hGUI_TRAINARMY_TAB
			tabARMY()
		Case $g_hGUI_SEARCH_TAB
			tabSEARCH()
		Case $g_hGUI_DEADBASE_TAB
			tabDeadbase()
		Case $g_hGUI_ACTIVEBASE_TAB
			tabActivebase()
		Case $g_hGUI_MOD_TAB
			tabMod()
		Case $g_hGUI_BOT_TAB
			tabBot()
		Case $g_hGUI_SWITCH_OPTIONS_TAB
			tabSwitchOptions()
		Case Else
			$bCheckEmbeddedShield = False
	EndSwitch

	If $bCheckEmbeddedShield Then
		; check shield status
		If $hWind <> $g_hFrmBotEmbeddedShield And $hWind <> $g_hFrmBotEmbeddedGraphics And $hWind <> $g_hFrmBotEmbeddedMouse Then
			If AndroidShieldHasFocus() = True Then
				; update shield with inactive state
				If $g_iDebugWindowMessages Then SetDebugLog("GUIControl_WM_NOTIFY: $hWind=" & $hWind & ",$iMsg=" & $iMsg & ",$wParam=" & $wParam & ",$lParam=" & $lParam, Default, True)
				AndroidShield("GUIControl_WM_NOTIFY", Default, False, 150, False)
			EndIf
		EndIf
	EndIf

	$g_bTogglePauseAllowed = $wasAllowed
	SetCriticalMessageProcessing($wasCritical)
	Return $GUI_RUNDEFMSG
EndFunc   ;==>GUIControl_WM_NOTIFY

Func GUIControl_WM_CLOSE($hWind, $iMsg, $wParam, $lParam)
	;Local $wasCritical = SetCriticalMessageProcessing(True)
	If $g_iDebugWindowMessages > 0 Then SetDebugLog("GUIControl_WM_CLOSE: $hWind=" & $hWind & ",$iMsg=" & $iMsg & ",$wParam=" & $wParam & ",$lParam=" & $lParam, Default, True)
	If $hWind = $g_hFrmBot Then
		BotCloseRequest()
	EndIf
EndFunc   ;==>GUIControl_WM_CLOSE

Func GUIEvents()
	;@GUI_WinHandle
	;Local $wasCritical = SetCriticalMessageProcessing(True)
	Local $wasAllowed = $g_bTogglePauseAllowed
	$g_bTogglePauseAllowed = False
	Local $GUI_CtrlId = @GUI_CtrlId
	If $g_bFrmBotMinimized And $GUI_CtrlId = $GUI_EVENT_MINIMIZE Then
		; restore
		If $g_iDebugWindowMessages Then SetDebugLog("$GUI_EVENT_MINIMIZE changed to $GUI_EVENT_RESTORE", Default, True)
		$GUI_CtrlId = $GUI_EVENT_RESTORE
	EndIf
	Switch $GUI_CtrlId
		Case $GUI_EVENT_CLOSE
			If $g_iDebugWindowMessages Then SetDebugLog("$GUI_EVENT_CLOSE", Default, True)
			BotCloseRequest()

		Case $GUI_EVENT_MINIMIZE
			If $g_iDebugWindowMessages Then SetDebugLog("$GUI_EVENT_MINIMIZE", Default, True)
			BotMinimize("GUIEvents")
			;Return 0

		Case $GUI_EVENT_RESTORE
			If $g_iDebugWindowMessages Then SetDebugLog("$GUI_EVENT_RESTORE", Default, True)
			BotRestore("GUIEvents")

		Case Else
			If $g_iDebugWindowMessages Then SetDebugLog("$GUI_EVENT: " & @GUI_CtrlId, Default, True)
	EndSwitch
	$g_bTogglePauseAllowed = $wasAllowed
EndFunc   ;==>GUIEvents

; Open URL in default browser using ShellExecute
; URL is retrieved from label text or an existing ToolTip Control
Func OpenURL_Label($LabelCtrlID)
	Local $url = GUICtrlRead($LabelCtrlID)
	If StringInStr($url, "http") <> 1 Then
		$url = _GUIToolTip_GetText($g_hToolTip, 0, GUICtrlGetHandle($LabelCtrlID))
	EndIf
	If StringInStr($url, "http") = 1 Then
		SetDebugLog("Open URL: " & $url)
		ShellExecute($url) ;open web site when clicking label
	Else
		SetDebugLog("Cannot open URL for Control ID " & $LabelCtrlID, $COLOR_ERROR)
	EndIf
EndFunc   ;==>OpenURL_Label

Func BotMinimizeRequest()
	BotMinimize("MinimizeButton", False, 500)
EndFunc   ;==>BotMinimizeRequest

Func BotToFront($hHWndAfter = $HWND_TOPMOST)
	WinMove2($g_hFrmBot, "", -1, -1, -1, -1, $hHWndAfter, 0, False)
	If $hHWndAfter = $HWND_TOPMOST Or $hHWndAfter = $HWND_TOP Then WinMove2($g_hFrmBot, "", -1, -1, -1, -1, $HWND_NOTOPMOST, 0, False)
EndFunc   ;==>BotToFront

Func CheckBotZOrder($bCheckOnly = False, $bForceZOrder = False)
	If $g_bAndroidEmbedded And $g_iAndroidEmbedMode = 0 Then
		Local $hCtrlTarget = $g_aiAndroidEmbeddedCtrlTarget[0]
		Local $targetIsHWnD = $hCtrlTarget = $g_hAndroidWindow
		If Not $targetIsHWnD Then
			Local $bCheck = ($bForceZOrder Or _WinAPI_GetWindow($hCtrlTarget, $GW_HWNDNEXT) <> $g_hAndroidWindow)
			If $bCheckOnly Then Return $bCheck
			If $bCheck Then
				SetDebugLog("CheckBotZOrder: Ajust docked Android Window")
				WinMove2($g_hAndroidWindow, "", -1, -1, -1, -1, $hCtrlTarget, 0, False) ; place URL Small Window after (behind) bot
			EndIf
			Return $bCheck
		EndIf
	EndIf
	If $g_iAndroidEmbedMode = 1 And $g_bBotDockedShrinked Then
		; check if order is (front to bottom): URL -> buttons -> graphics -> shield -> bot, to URL is top...
		Local $hWinBehindButtons = ($g_hFrmBotEmbeddedGraphics ? $g_hFrmBotEmbeddedGraphics : ($g_hFrmBotEmbeddedShield ? $g_hFrmBotEmbeddedShield : $g_hFrmBot))
		Local $bCheck = $hWinBehindButtons And ($bForceZOrder Or _WinAPI_GetWindow($g_hFrmBotLogoUrlSmall, $GW_HWNDNEXT) <> $g_hFrmBotButtons Or _WinAPI_GetWindow($g_hFrmBotButtons, $GW_HWNDNEXT) <> $hWinBehindButtons)
		If $bCheckOnly Then Return $bCheck
		If $bCheck Then
			SetDebugLog("CheckBotZOrder: Ajust windows Z Order for custom window")
			; ensure buttons are visible in in right Z Order
			If $bForceZOrder Then
				WinMove2($g_hFrmBot, "", -1, -1, -1, -1, $HWND_TOPMOST, 0, False)
				WinMove2($g_hFrmBot, "", -1, -1, -1, -1, $HWND_NOTOPMOST, 0, False)
				If $g_hFrmBotEmbeddedShield Then WinMove2($g_hFrmBotEmbeddedShield, "", -1, -1, -1, -1, $g_hFrmBot, 0, False) ; force place shield after (behind) bot
			EndIf
			WinMove2($g_hFrmBotLogoUrlSmall, "", -1, -1, -1, -1, $g_hFrmBot, 0, False) ; place URL Small Window after (behind) bot
			WinMove2($g_hFrmBot, "", -1, -1, -1, -1, $g_hFrmBotLogoUrlSmall, 0, False) ; place bot after (behind) URL Small Window
			; now order, sequence is important!
			WinMove2($g_hFrmBotButtons, "", -1, -1, -1, -1, $g_hFrmBotLogoUrlSmall, 0, False) ; place buttons after (behind) URL
			If $hWinBehindButtons <> $g_hFrmBot Then WinMove2($hWinBehindButtons, "", -1, -1, -1, -1, $g_hFrmBotButtons, 0, False) ; place graphics/shield/bot after (behind) buttons
			If $g_hFrmBotEmbeddedShield And $g_hFrmBotEmbeddedShield <> $hWinBehindButtons Then WinMove2($g_hFrmBotEmbeddedShield, "", -1, -1, -1, -1, $hWinBehindButtons, 0, False) ; place shield after graphics
		EndIf
		Return $bCheck
	EndIf
	If ($g_iAndroidEmbedMode = 1 And $g_bCustomTitleBarActive = False) Or $g_avAndroidShieldStatus[4] Then
		; window classic style check or detached shield check
		; check if order is (front to bottom): graphics -> shield -> bot, to URL is top...
		Local $hTopWin = ($g_hFrmBotEmbeddedGraphics ? $g_hFrmBotEmbeddedGraphics : ($g_hFrmBotEmbeddedShield ? $g_hFrmBotEmbeddedShield : 0))
		Local $bCheck = $hTopWin And ($bForceZOrder Or _WinAPI_GetWindow($hTopWin, $GW_HWNDNEXT) <> $g_hFrmBot)
		If $bCheckOnly Then Return $bCheck
		If $bCheck Then
			SetDebugLog("CheckBotZOrder: Ajust windows Z Order for standard window")
			; ensure buttons are visible in in right Z Order
			If $bForceZOrder Then
				WinMove2($g_hFrmBot, "", -1, -1, -1, -1, $HWND_TOPMOST, 0, False)
				WinMove2($g_hFrmBot, "", -1, -1, -1, -1, $HWND_NOTOPMOST, 0, False)
				WinMove2($g_hFrmBotEmbeddedShield, "", -1, -1, -1, -1, $g_hFrmBot, 0, False) ; force place shield after (behind) bot
			EndIf
			WinMove2($hTopWin, "", -1, -1, -1, -1, $g_hFrmBot, 0, False) ; place Top Window after (behind) bot
			WinMove2($g_hFrmBot, "", -1, -1, -1, -1, $hTopWin, 0, False) ; place bot after (behind) Top Window
			; now order, sequence is important!
			If $g_hFrmBotEmbeddedShield And $g_hFrmBotEmbeddedShield <> $hTopWin Then WinMove2($g_hFrmBotEmbeddedShield, "", -1, -1, -1, -1, $hTopWin, 0, False) ; place shield after graphics
		EndIf
		Return $bCheck
	EndIf
	Return False
EndFunc   ;==>CheckBotZOrder

Func CheckBotShrinkExpandButton($bCheckOnlyParent = False)
	If $g_hFrmBotButtons = 0 Then Return False
	Local $bInconsistent = False
	If $g_bAndroidEmbedded = False And $g_bBotDockedShrinked Then
		; inconsistent state
		SetDebugLog("Bot Buttons inconsistent state", $COLOR_ERROR)
		$bInconsistent = True
		$bCheckOnlyParent = False
		$g_bBotDockedShrinked = False
	EndIf

	Local $bChanged = False
	Local $aBtnSize = $_GUI_MAIN_BUTTON_SIZE
	Local $aPos = ControlGetPos($g_hFrmBot, "", $g_hFrmBotButtons)
	Local $bDetached = False
	Local $bBottonsHidden = False
	If UBound($aPos) > 3 Then
		Local $x = $_GUI_MAIN_WIDTH - $aBtnSize[0] * $_GUI_MAIN_BUTTON_COUNT
		Local $y = 0
		Local $iStyle = _WinAPI_GetWindowLong($g_hFrmBotButtons, $GWL_STYLE)
		If $g_bAndroidEmbedded = True Then
			Local $a = $g_aiAndroidEmbeddedCtrlTarget[6]
			Local $iAndroidWidth = $a[2]
			$x = $iAndroidWidth + 2 + (($g_bBotDockedShrinked) ? (-$aBtnSize[0] * $_GUI_MAIN_BUTTON_COUNT) : ($_GUI_MAIN_WIDTH - $aBtnSize[0] * $_GUI_MAIN_BUTTON_COUNT))
			If $g_iAndroidEmbedMode = 1 Then
				If $g_bBotDockedShrinked Then
					$bDetached = True
					Local $tPoint = DllStructCreate($tagPOINT)
					DllStructSetData($tPoint, "X", $x)
					DllStructSetData($tPoint, "Y", $y)
					_WinAPI_ClientToScreen($g_hFrmBot, $tPoint)
					Local $abs_x = DllStructGetData($tPoint, "X")
					Local $abs_y = DllStructGetData($tPoint, "Y")
					$x = $abs_x
					$y = $abs_y
					If BitAND($iStyle, $WS_POPUP) <> $WS_POPUP Then
						SetDebugLog("Detach Bot Buttons")
						;_WinAPI_SetParent($g_hFrmBotButtons, 0)
						$bBottonsHidden = True
						GUISetState(@SW_HIDE, $g_hFrmBotButtons)
						_WinAPI_SetWindowLong($g_hFrmBotButtons, $GWL_EXSTYLE, BitOR($WS_EX_TOOLWINDOW, $WS_EX_NOACTIVATE))
						_WinAPI_SetWindowLong($g_hFrmBotButtons, $GWL_STYLE, BitOR(BitAND($iStyle, BitNOT($WS_CHILD)), $WS_POPUP))
						_WinAPI_SetWindowLong($g_hFrmBotButtons, $GWL_HWNDPARENT, 0)
						WinMove2($g_hFrmBotButtons, "", $x, $y, -1, -1, $HWND_TOPMOST, 0, False)
						WinMove2($g_hFrmBotButtons, "", $x, $y, -1, -1, $HWND_NOTOPMOST, 0, False)
						$aPos[0] = $x
						$aPos[1] = $y
						; move also LogoURL small
						_WinAPI_SetWindowLong($g_hFrmBotLogoUrlSmall, $GWL_EXSTYLE, BitOR($WS_EX_TOOLWINDOW, $WS_EX_NOACTIVATE))
						_WinAPI_SetWindowLong($g_hFrmBotLogoUrlSmall, $GWL_STYLE, BitOR(BitAND($iStyle, BitNOT($WS_CHILD)), $WS_POPUP))
						_WinAPI_SetWindowLong($g_hFrmBotLogoUrlSmall, $GWL_HWNDPARENT, 0)
						WinMove2($g_hFrmBotLogoUrlSmall, "", $x - 290, $y, -1, -1, $HWND_TOPMOST, 0, False)
						WinMove2($g_hFrmBotLogoUrlSmall, "", $x - 290, $y, -1, -1, $HWND_NOTOPMOST, 0, False)

						If $bCheckOnlyParent Then Return True
					EndIf
					If $bCheckOnlyParent Then Return False
					$aPos = WinGetPos($g_hFrmBotButtons)
					$bChanged = True
				EndIf
			EndIf
		EndIf
		If (Not $g_bAndroidEmbedded Or Not $g_bBotDockedShrinked) And BitAND($iStyle, $WS_POPUP) = $WS_POPUP Then
			SetDebugLog("Integrate Bot Buttons")
			$bBottonsHidden = True
			If Not $bInconsistent Then GUISetState(@SW_HIDE, $g_hFrmBotButtons)
			_WinAPI_SetParent($g_hFrmBotButtons, $g_hFrmBot)
			_WinAPI_SetWindowLong($g_hFrmBotButtons, $GWL_HWNDPARENT, $g_hFrmBot)
			_WinAPI_SetWindowLong($g_hFrmBotButtons, $GWL_EXSTYLE, BitOR($WS_EX_TOOLWINDOW, $WS_EX_NOACTIVATE, ($g_bAndroidShieldPreWin8 ? 0 : $WS_EX_LAYERED))) ; , $WS_EX_TOPMOST
			_WinAPI_SetWindowLong($g_hFrmBotButtons, $GWL_STYLE, BitOR(BitAND($iStyle, BitNOT($WS_POPUP)), $WS_CHILD))
			If $bInconsistent Then
				_WinAPI_SetParent($g_hFrmBotButtons, $g_hFrmBot)
			EndIf
			; move also LogoURL small
			_WinAPI_SetParent($g_hFrmBotLogoUrlSmall, $g_hFrmBot)
			_WinAPI_SetWindowLong($g_hFrmBotLogoUrlSmall, $GWL_HWNDPARENT, $g_hFrmBot)
			_WinAPI_SetWindowLong($g_hFrmBotLogoUrlSmall, $GWL_EXSTYLE, BitOR($WS_EX_TOOLWINDOW, $WS_EX_NOACTIVATE, ($g_bAndroidShieldPreWin8 ? 0 : $WS_EX_LAYERED))) ; , $WS_EX_TOPMOST
			_WinAPI_SetWindowLong($g_hFrmBotLogoUrlSmall, $GWL_STYLE, BitOR(BitAND($iStyle, BitNOT($WS_POPUP)), $WS_CHILD))
			If $bInconsistent Then
				_WinAPI_SetParent($g_hFrmBotLogoUrlSmall, $g_hFrmBot)
			EndIf
			If $bCheckOnlyParent Then Return True
			$aPos = ControlGetPos($g_hFrmBot, "", $g_hFrmBotButtons)
			$bChanged = True
		EndIf
		If $bCheckOnlyParent Then Return False
		If $x <> $aPos[0] Or $y <> $aPos[1] Or $bInconsistent Then
			SetDebugLog("Move Bot Buttons: " & $x & ", " & $y)
			If $bDetached Then
				WinMove2($g_hFrmBotButtons, "", $x, $y, -1, -1, $HWND_TOPMOST, 0, False)
				WinMove2($g_hFrmBotButtons, "", $x, $y, -1, -1, $HWND_NOTOPMOST, 0, False)
				; move also LogoURL small
				WinMove2($g_hFrmBotLogoUrlSmall, "", $x - 290, $y, -1, -1, $HWND_TOPMOST, 0, False)
				WinMove2($g_hFrmBotLogoUrlSmall, "", $x - 290, $y, -1, -1, $HWND_NOTOPMOST, 0, False)
			Else
				WinMove2($g_hFrmBotButtons, "", $x, $y, -1, -1, 0, 0, False)
				; move also LogoURL small
				WinMove2($g_hFrmBotLogoUrlSmall, "", $x - 290, $y, -1, -1, 0, 0, False)
				WinMove2($g_hFrmBotLogoUrlSmall, "", $x - 290, $y, -1, -1, 0, 0, False)
			EndIf
			$bChanged = True
		EndIf
	EndIf
	If $bBottonsHidden = True Then
		GUISetState(@SW_SHOWNOACTIVATE, $g_hFrmBotButtons)
		If $g_bBotDockedShrinked Then GUISetState(@SW_SHOWNOACTIVATE, $g_hFrmBotLogoUrlSmall)
	EndIf
	If $bInconsistent Then
		GUICtrlSetState($g_hLblBotShrink, (($g_bBotDockedShrinked) ? ($GUI_HIDE) : ($GUI_SHOW)))
		GUICtrlSetState($g_hLblBotExpand, (($g_bBotDockedShrinked) ? ($GUI_SHOW) : ($GUI_HIDE)))
		WinSetTrans($g_hFrmBotButtons, "", (($g_bBotDockedShrinked) ? (210) : (254))) ; trick to hide buttons from Android Screen that is not always refreshing
	EndIf
	Return $bChanged
EndFunc   ;==>CheckBotShrinkExpandButton

Func BotShrinkExpandToggle()
	$g_bBotShrinkExpandToggleRequested = True
EndFunc   ;==>BotShrinkExpandToggle

Func BotShrinkExpandToggleExecute()
	If $g_hFrmBotButtons = 0 Then Return False
	If $g_iBotAction = $eBotClose Then Return False
	If $g_bAndroidEmbedded = False Then
		SetDebugLog("BotShrinkExpandToggle: Android not docked")
		$g_bBotShrinkExpandToggleRequested = False
		Return False
	EndIf
	Local $aPos = WinGetPos($g_hFrmBot)
	If UBound($aPos) < 4 Then
		SetDebugLog("BotShrinkExpandToggle: Bot Window not accessible")
		$g_bBotShrinkExpandToggleRequested = False
		Return False
	EndIf
	; use expended width and height (taken from AndroidEmbedded.au3)
	Local $aPosCtl = $g_aiAndroidEmbeddedCtrlTarget[6]
	$aPos[2] = (($g_bBotDockedShrinked) ? ($aPosCtl[2] + 2) : ($g_aFrmBotPosInit[2] + $aPosCtl[2] + 2))
	$aPos[3] = $g_aFrmBotPosInit[3] + $g_iFrmBotAddH + $g_aFrmBotPosInit[7]
	Local $bAndroidShieldEnabled = $g_bAndroidShieldEnabled
	$g_bAndroidShieldEnabled = False ; disable should to prevent flickering
	$g_bBotDockedShrinked = Not $g_bBotDockedShrinked ; set new shrink mode
	If Not $g_bBotDockedShrinked Then GUISetState(@SW_HIDE, $g_hFrmBotLogoUrlSmall)

	Local $aBtnSize = $_GUI_MAIN_BUTTON_SIZE
	Local $a = $g_aiAndroidEmbeddedCtrlTarget[6]
	Local $iAndroidWidth = $a[2]
	If Not $g_bBotDockedShrinked And CheckBotShrinkExpandButton(True) Then
		Local $bStillShrinked = True
		WinMove2($g_hFrmBotButtons, "", $iAndroidWidth + 2 + (($bStillShrinked) ? (-$aBtnSize[0] * $_GUI_MAIN_BUTTON_COUNT) : ($_GUI_MAIN_WIDTH - $aBtnSize[0] * $_GUI_MAIN_BUTTON_COUNT)), 0, -1, -1, 0, 0, False)
		GUISetState(@SW_SHOWNOACTIVATE, $g_hFrmBotButtons)
	EndIf
	Local $iMode = (($g_bBotDockedShrinked) ? (1) : (-1))
	Local $aPosBtn = ControlGetPos($g_hFrmBot, "", $g_hFrmBotButtons)
	Local $bAnimate = $bAndroidShieldEnabled And Not $g_bAndroidShieldPreWin8 And $g_bChkBackgroundMode
	;_SendMessage($g_hFrmBotEx, $WM_SETREDRAW, False, 0)
	;_SendMessage($g_hFrmBotBottom, $WM_SETREDRAW, False, 0)
	GUISetState(@SW_HIDE, $g_hFrmBotEx)
	GUISetState(@SW_HIDE, $g_hFrmBotBottom)

	Local $iSteps = 10
	Local $fStep = $_GUI_MAIN_WIDTH / $iSteps
	Local $bGetAnimationSpeed = True
	Local $iAnimationDelay = 0
	If $bAnimate Then
		For $i = 1 To $iSteps
			Local $iWidth = Round($aPos[2] - $i * $fStep * $iMode, 0)
			Local $iChange = $iWidth - $aPos[2]
			If $bGetAnimationSpeed Then Local $hTimer = __TimerInit()
			WinMove2($g_hFrmBot, "", -1, -1, $iWidth, $aPos[3], 0, 0, False)
			WinMove2($g_hFrmBotButtons, "", $iAndroidWidth + 2 - $aBtnSize[0] * $_GUI_MAIN_BUTTON_COUNT + $iChange + (($g_bBotDockedShrinked) ? ($_GUI_MAIN_WIDTH) : (0)), $aPosBtn[1], -1, -1, 0, 0, False)
			If $bGetAnimationSpeed Then
				$iAnimationDelay = 100 / $iSteps - __TimerDiff($hTimer)
			EndIf
			If $iAnimationDelay > 0 Then _SleepMilli($iAnimationDelay)
		Next
	EndIf
	; update buttons
	GUICtrlSetState($g_hLblBotShrink, (($g_bBotDockedShrinked) ? ($GUI_HIDE) : ($GUI_SHOW)))
	GUICtrlSetState($g_hLblBotExpand, (($g_bBotDockedShrinked) ? ($GUI_SHOW) : ($GUI_HIDE)))
	WinSetTrans($g_hFrmBotButtons, "", (($g_bBotDockedShrinked) ? (210) : (254))) ; trick to hide buttons from Android Screen that is not always refreshing
	WinMove2($g_hFrmBot, "", -1, -1, $aPos[2] - $_GUI_MAIN_WIDTH * $iMode, $aPos[3], 0, 0, False)
	WinMove2($g_hFrmBotButtons, "", $iAndroidWidth + 2 + (($g_bBotDockedShrinked) ? (-$aBtnSize[0] * $_GUI_MAIN_BUTTON_COUNT) : ($_GUI_MAIN_WIDTH - $aBtnSize[0] * $_GUI_MAIN_BUTTON_COUNT)), $aPosBtn[1], -1, -1, 0, 0, False)
	If $g_bBotDockedShrinked Then
		WinMove2($g_hFrmBotLogoUrlSmall, "", $iAndroidWidth + 2 + (($g_bBotDockedShrinked) ? (-$aBtnSize[0] * $_GUI_MAIN_BUTTON_COUNT) : ($_GUI_MAIN_WIDTH - $aBtnSize[0] * $_GUI_MAIN_BUTTON_COUNT)) - 290, $aPosBtn[1], -1, -1, 0, 0, False)
		GUISetState(@SW_SHOWNOACTIVATE, $g_hFrmBotLogoUrlSmall)
	EndIf
	;_SendMessage($g_hFrmBotEx, $WM_SETREDRAW, True, 0)
	;_SendMessage($g_hFrmBotBottom, $WM_SETREDRAW, True, 0)
	;_WinAPI_RedrawWindow($g_hFrmBotEx, 0, 0, BitOR($RDW_INVALIDATE, $RDW_ALLCHILDREN, $RDW_ERASE))
	;_WinAPI_UpdateWindow($g_hFrmBotEx)
	;_WinAPI_RedrawWindow($g_hFrmBotBottom, 0, 0, BitOR($RDW_INVALIDATE, $RDW_ALLCHILDREN, $RDW_ERASE))
	;_WinAPI_UpdateWindow($g_hFrmBotBottom)
	GUISetState(@SW_SHOWNOACTIVATE, $g_hFrmBotEx)
	GUISetState(@SW_SHOWNOACTIVATE, $g_hFrmBotBottom)
	If $g_bBotDockedShrinked Then CheckBotShrinkExpandButton()
	SetDebugLog("BotShrinkExpandToggle: Bot " & (($g_bBotDockedShrinked) ? ("collapsed") : ("expanded")))
	$g_bAndroidShieldEnabled = $bAndroidShieldEnabled
	$g_bBotShrinkExpandToggleRequested = False
	Return True
EndFunc   ;==>BotShrinkExpandToggleExecute

Func BotGuiModeToggleRequest()
	If Not $g_bRunState And Not IsConfigActive() And Not DllCallMyBotIsActive() Then
		BotGuiModeToggle()
		Return False
	EndIf
	$g_bBotGuiModeToggleRequested = True
	Return True
EndFunc   ;==>BotGuiModeToggleRequest

Func BotGuiModeToggle()
	Static $bIsActive = False
	If $g_iBotAction = $eBotClose Or $g_iGuiMode = 0 Or $bIsActive Or IsConfigActive() Or DllCallMyBotIsActive() Then Return False
	$bIsActive = True
	$g_bBotGuiModeToggleRequested = False

	If $g_bAndroidEmbedded Then AndroidEmbed(False)

	Local $_GUI_MAIN_WIDTH_OLD = $_GUI_MAIN_WIDTH
	Local $_GUI_MAIN_HEIGHT_OLD = $_GUI_MAIN_HEIGHT

	Switch $g_iGuiMode

		Case 1
			; Bot is in Normal GUI Mode, switch to Mini Mode
			SetLog("Switch to Mini GUI Mode")

			; save config
			applyConfig(False, "Save")
			saveConfig()

			$g_iGuiMode = 2

			SetRedrawBotWindow(False, Default, Default, Default, "BotGuiModeToggle")

			; mini GUI mode
			$_GUI_MAIN_WIDTH = $_MINIGUI_MAIN_WIDTH
			$_GUI_MAIN_HEIGHT = $_MINIGUI_MAIN_HEIGHT

			; destroy GUI Controls
			; but keep Bot and Attack Log though (park them in main form, restore again in CreateLogTab())
			_WinAPI_SetParent($g_hTxtLog, $g_hFrmBotEx)
			_WinAPI_SetParent($g_hTxtAtkLog, $g_hFrmBotEx)
			_WinAPI_SetWindowLong($g_hTxtLog, $GWL_HWNDPARENT, $g_hFrmBotEx)
			_WinAPI_SetWindowLong($g_hTxtAtkLog, $GWL_HWNDPARENT, $g_hFrmBotEx)
			WinSetState($g_hTxtLog, "", @SW_MINIMIZE)
			WinSetState($g_hTxtAtkLog, "", @SW_MINIMIZE)

			GUICtrlDelete($g_hTabMain)
			GUICtrlDelete($g_hTabLog)
			GUICtrlDelete($g_hTabVillage)
			GUICtrlDelete($g_hTabAttack)
			GUICtrlDelete($g_hTabBot)
			GUICtrlDelete($g_hTabAbout)

			GUICtrlDelete($g_hGUI_VILLAGE_TAB)
			GUICtrlDelete($g_hGUI_MISC_TAB)
			GUICtrlDelete($g_hGUI_DONATE_TAB)
			GUICtrlDelete($g_hGUI_UPGRADE_TAB)
			GUICtrlDelete($g_hGUI_NOTIFY_TAB)

			GUICtrlDelete($g_hGUI_ATTACK_TAB)
			GUICtrlDelete($g_hGUI_TRAINARMY_TAB)
			GUICtrlDelete($g_hGUI_TRAINARMY_ARMY_TAB)
			GUICtrlDelete($g_hGUI_TRAINARMY_ORDER_TAB)
			GUICtrlDelete($g_hGUI_SEARCH_TAB)
			GUICtrlDelete($g_hGUI_DEADBASE_TAB)
			GUICtrlDelete($g_hGUI_ACTIVEBASE_TAB)
			GUICtrlDelete($g_hGUI_ATTACKOPTION_TAB)
			GUICtrlDelete($g_hGUI_STRATEGIES_TAB)
			GUICtrlDelete($g_hGUI_BOT_TAB)
			GUICtrlDelete($g_hGUI_LOG_SA)
			GUICtrlDelete($g_hGUI_SWITCH_OPTIONS_TAB)
			GUICtrlDelete($g_hGUI_STATS_TAB)

			#Region - Team__AiO__MOD
			GUICtrlDelete($g_hTabBuilderBase)
			GUICtrlDelete($g_hTabMOD)
			GUICtrlDelete($g_hGUI_BUILDER_BASE_TAB) ; BBase - Team AIO Mod++
			GUICtrlDelete($g_hGUI_MOD_TAB) ; Mod - Team AIO Mod++
			GUICtrlDelete($g_hGUI_LOG_BB) ; BBase - Team AIO Mod++
			#EndRegion - Team__AiO__MOD

			For $i = $g_hFirstControlToHide To $g_hLastControlToHide
				GUICtrlDelete($i)
			Next
			$g_hFirstControlToHide = 0
			$g_hLastControlToHide = 0

			; destroy windows
			For $hGUI In $g_oGuiNotInMini
				SetDebugLog("GUIDelete: " & $hGUI)
				GUIDelete($hGUI)
			Next
			$g_oGuiNotInMini.RemoveAll
			$oAlwaysEnabledControls.RemoveAll

			__GDIPlus_Shutdown()
			__GDIPlus_Startup()

		Case 2
			; Bot is in Mini GUI Mode, switch to Normal Mode
			SetLog("Switch to Normal GUI Mode")
			$g_iGuiMode = 1

			; normal GUI mode
			$_GUI_MAIN_WIDTH = $_NORMALGUI_MAIN_WIDTH
			$_GUI_MAIN_HEIGHT = $_NORMALGUI_MAIN_HEIGHT

			; Create controls
			CreateSplashScreen(6) ; Create splash window

			CreateMainGUIControls(True)

			; refresh tab states
			tabMod()
			tabBot()
			tabDONATE()
			tabARMY()
			tabSEARCH()
			tabAttack()
			tabVillage()
			tabSwitchOptions()

			InitializeMainGUI(True)

			; update stats
			UpdateStats(True)
			UpdateMultiStats()

			DistributorsUpdateGUI() ; Now loading Distributors (during GUI switch it must be called outside CreateMainGUIControls()!)
			
			getAllEmulators()
			
			DestroySplashScreen()

			; apply config
			applyConfig(False)

			If Not $g_bGuiControlsEnabled Then DisableGuiControls()

			SetRedrawBotWindow(False, Default, Default, Default, "BotGuiModeToggle")

			; now refresh the logs
			_GUICtrlRichEdit_SetSel($g_hTxtLog, 0, 0) ; select top
			_GUICtrlRichEdit_SetSel($g_hTxtLog, -1, -1) ; select end
			_GUICtrlRichEdit_SetSel($g_hTxtAtkLog, 0, 0) ; select top
			_GUICtrlRichEdit_SetSel($g_hTxtAtkLog, -1, -1) ; select end
			; avoid the cursor in attack log by selecting tab
			GUICtrlSetState($g_hTabMain, $GUI_FOCUS)

	EndSwitch

	; move bottom controls
	WinMove2($g_hFrmBotBottom, "", 0, $_GUI_MAIN_HEIGHT - $_GUI_BOTTOM_HEIGHT + $_GUI_MAIN_TOP, -1, -1, 0, 0, False)
	;ControlMove($g_hFrmBot, "", $g_hFrmBotBottom, 0, $_GUI_MAIN_HEIGHT - $_GUI_BOTTOM_HEIGHT + $_GUI_MAIN_TOP)
	;WinSetTrans($g_hFrmBotBottom, "", 255)

	; resize windows
	Local $xComp = $g_aFrmBotPosInit[2] - $_GUI_MAIN_WIDTH_OLD
	Local $yComp = $g_aFrmBotPosInit[3] + $g_aFrmBotPosInit[7] - $_GUI_MAIN_HEIGHT_OLD
	WinMove2($g_hFrmBotEx, "", -1, -1, $_GUI_MAIN_WIDTH, $_GUI_MAIN_HEIGHT - $_GUI_BOTTOM_HEIGHT + $_GUI_MAIN_TOP, 0, 0, False)
	WinMove2($g_hFrmBot, "", -1, -1, $_GUI_MAIN_WIDTH + $xComp, $_GUI_MAIN_HEIGHT + $yComp, 0, 0, False)

	; update buttons
	GUICtrlSetState($g_hLblBotNormalGUI, (($g_iGuiMode = 1) ? ($GUI_HIDE) : ($GUI_SHOW)))
	GUICtrlSetState($g_hLblBotMiniGUI, (($g_iGuiMode = 2) ? ($GUI_HIDE) : ($GUI_SHOW)))

	updateBtnEmbed()

	SetRedrawBotWindow(True, Default, Default, Default, "BotGuiModeToggle")

	ShowMainGUI()
	$bIsActive = False

	Return True
EndFunc   ;==>BotGuiModeToggle

Func GUIControl_WM_MPAINT($hWin, $iMsg, $wParam, $lParam)
	Local $wasCritical = SetCriticalMessageProcessing(True)
	Local $wasAllowed = $g_bTogglePauseAllowed
	$g_bTogglePauseAllowed = False
	SetDebugLog("GUIControl_WM_MPAINT: $hWin=" & $hWin & ",$iMsg=" & $iMsg & ",$wParam=" & $wParam & ",$lParam=" & $lParam, Default, True)

	$g_bTogglePauseAllowed = $wasAllowed
	SetCriticalMessageProcessing($wasCritical)
	Return $GUI_RUNDEFMSG
EndFunc   ;==>GUIControl_WM_MPAINT

Func BotMoveRequest()
	$g_bBotMoveRequested = True
EndFunc   ;==>BotMoveRequest

; Called from _Sleep() to avoid locked window move state, double minimize calls etc
Func CheckBotRequests()
	CheckBotZOrder() ; check Z Order of Windows is ok
	If $g_bBotMoveRequested = True Then
		$g_bBotMoveRequested = False
		_WinAPI_PostMessage($g_hFrmBot, $WM_SYSCOMMAND, 0xF012, 0) ; SC_DRAGMOVE = 0xF012
	Else
		If $g_bBotShrinkExpandToggleRequested Then BotShrinkExpandToggleExecute()
		If $g_bBotGuiModeToggleRequested Then BotGuiModeToggle()
	EndIf
EndFunc   ;==>CheckBotRequests

Func BotCloseRequest()
	If $g_iBotAction = $eBotClose Then
		; already requested to close, but user is impatient, so close now
		BotClose()
	Else
		SetLog("Closing " & $g_sBotTitle & ", please wait ...")
	EndIf
	$g_bRunState = False
	$g_bBotPaused = False
	$g_iBotAction = $eBotClose
EndFunc   ;==>BotCloseRequest

Func BotCloseRequestProcessed()
	; Return False ; no stable yet, so disabled for now
	Return $g_iBotAction = $eBotClose And $g_bAndroidEmbedded = False
EndFunc   ;==>BotCloseRequestProcessed

Func BotClose($SaveConfig = Default, $bExit = True)
    ; Perhaps this provides the stability that was lacking.
    Static $bActiveClose = False
    If $bActiveClose = True Then Return
    $bActiveClose = True 

	If $SaveConfig = Default Then $SaveConfig = IsBotLaunched()
	$g_bRunState = False
	$g_bBotPaused = False
	ResumeAndroid()
	SetLog("Closing " & $g_sBotTitle & " now ...")
	LockBotSlot(False)

	If $SaveConfig = True Then
		; setupProfile()
		SaveConfig()
	EndIf

	; ensure windows are not top anymore
	$g_bChkBackgroundMode = True

	AndroidEmbed(False) ; detach Android Window
	AndroidShieldDestroy() ; destroy Shield Hooks

	If $g_bAndroidCloseWithBot And $g_hAndroidWindow Then
		$g_bRunState = True
		CloseAndroid("BotClose")
		$g_bRunState = False
	Else
		AndroidBotStopEvent() ; signal android that bot is now stoppting
		AndroidToFront(Default, "BotClose")
		AndroidAdbTerminateShellInstance()
	EndIf

	; Close Mutexes
	If $g_hMutex_BotTitle <> 0 Then ReleaseMutex($g_hMutex_BotTitle)
	ReleaseProfilesMutex(True)
	If $g_hMutex_MyBot <> 0 Then ReleaseMutex($g_hMutex_MyBot)
	; Clean up resources
	__GDIPlus_Shutdown()
	_Crypt_Shutdown()
	_GUICtrlRichEdit_Destroy($g_hTxtLog)
	_GUICtrlRichEdit_Destroy($g_hTxtAtkLog)
	_GUICtrlRichEdit_Destroy($g_hTxtBBAtkLog)

	_WinAPI_DeregisterShellHookWindow($g_hFrmBot)
	If $g_hAndroidWindow <> 0 Then ControlFocus($g_hAndroidWindow, "", $g_hAndroidWindow) ; show Android in taskbar again
	GUIDelete($g_hFrmBot)

	; Global DllStuctCreate
	$g_aiAndroidAdbScreencapBuffer = 0 ; Allocated in MBR Global Variables.au3
	$g_hStruct_SleepMicro = 0 ; Allocated in MBR Global Variables.au3, used in _Sleep.au3

	; Unregister managing hosts
	UnregisterManagedMyBotHost()
	
	CloseEmulatorForce(True)
	
	If $bExit = True Then Exit
EndFunc   ;==>BotClose

Func BotMinimizeRestore($bMinimize, $sCaller, $iForceUpdatingWhenMinimized = False, $iStayMinimizedMillis = 0, $hHWndAfter = $HWND_TOP)

	Static $siStayMinimizedMillis = 0
	Static $shStayMinimizedTimer = 0

	If $bMinimize Then
		; Minimize Bot

		If $iStayMinimizedMillis > 0 Then
			$siStayMinimizedMillis = $iStayMinimizedMillis
			$shStayMinimizedTimer = __TimerInit()
		EndIf
		;Local $hMutex = AcquireMutex("MinimizeRestore")
		If $g_bAndroidEmbedded = True And $g_bChkBackgroundMode = False Then
			; don't minimize bot when embedded and background mode is off
			;ReleaseMutex($hMutex)
			Return False
		EndIf
		SetDebugLog("Minimize bot window, caller: " & $sCaller, Default, True)
		$g_bFrmBotMinimized = True
		If $g_bUpdatingWhenMinimized Or $iForceUpdatingWhenMinimized = True Then
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
			;WinSetState($g_hAndroidWindow, "", @SW_MINIMIZE)
		EndIf
		; Hide also Android
		If $g_bChkBackgroundMode And Not $g_bIsHidden Then HideAndroidWindow(True, False, Default, "BotMinimizeRestore")
		;ReleaseMutex($hMutex)
		Return True
	EndIf

	; Restore Bot

	If $siStayMinimizedMillis > 0 And __TimerDiff($shStayMinimizedTimer) < $siStayMinimizedMillis Then
		SetDebugLog("Prevent Bot Window Restore")
		Return False
	Else
		$siStayMinimizedMillis = 0
		$shStayMinimizedTimer = 0
	EndIf

	;Local $hMutex = AcquireMutex("MinimizeRestore")
	$g_bFrmBotMinimized = False
	Local $botPosX = ($g_bAndroidEmbedded = False ? $g_iFrmBotPosX : $g_iFrmBotDockedPosX)
	Local $botPosY = ($g_bAndroidEmbedded = False ? $g_iFrmBotPosY : $g_iFrmBotDockedPosY)
	Local $aPos = [$botPosX, $botPosY]
	;SetDebugLog("Restore bot window to " & $botPosX & ", " & $botPosY & ", caller: " & $sCaller, Default, True)
	Local $iExStyle = _WinAPI_GetWindowLong($g_hFrmBot, $GWL_EXSTYLE)
	If BitAND($iExStyle, $WS_EX_TOOLWINDOW) Then
		WinMove2($g_hFrmBot, "", -1, -1, -1, -1, 0, $SWP_HIDEWINDOW, False)
		_WinAPI_SetWindowLong($g_hFrmBot, $GWL_EXSTYLE, BitAND($iExStyle, BitNOT($WS_EX_TOOLWINDOW)))
	EndIf
	If _WinAPI_IsIconic($g_hFrmBot) Then WinSetState($g_hFrmBot, "", @SW_RESTORE)
	If $g_bAndroidAdbScreencap = False And $g_bRunState = True And $g_bBotPaused = False And _WinAPI_IsIconic($g_hAndroidWindow) Then WinSetState($g_hAndroidWindow, "", @SW_RESTORE)
	WinMove2($g_hFrmBot, "", $botPosX, $botPosY, -1, -1, $hHWndAfter, BitOR($SWP_SHOWWINDOW, $SWP_NOACTIVATE))
	;_WinAPI_SetActiveWindow($g_hFrmBot)
	;_WinAPI_SetFocus($g_hFrmBot)
	If _CheckWindowVisibility($g_hFrmBot, $aPos) Then
		SetDebugLog("Bot Window '" & $g_sAndroidTitle & "' not visible, moving to position: " & $aPos[0] & ", " & $aPos[1])
		WinMove2($g_hFrmBot, "", $aPos[0], $aPos[1])
	EndIf
	WinSetTrans($g_hFrmBot, "", 255) ; is set to 1 when "Hide when minimized" is enabled after some time, so restore it
	BotToFront($hHWndAfter)
	; Show also Android
	If $g_bChkBackgroundMode And Not $g_bIsHidden And $hHWndAfter <> $g_hAndroidWindow Then HideAndroidWindow(False, False, Default, "BotMinimizeRestore", $g_hFrmBot)
	;ReleaseMutex($hMutex)
	Return True

EndFunc   ;==>BotMinimizeRestore

Func BotMinimize($sCaller, $iForceUpdatingWhenMinimized = False, $iStayMinimizedMillis = 0)
	Return BotMinimizeRestore(True, $sCaller, $iForceUpdatingWhenMinimized, $iStayMinimizedMillis)
EndFunc   ;==>BotMinimize

Func BotRestore($sCaller)
	Return BotMinimizeRestore(False, $sCaller)
EndFunc   ;==>BotRestore

; Ensure bot window state (fix minimize not working sometimes)
Func BotWindowCheck()
	If $g_bFrmBotMinimized Then
		Local $aPos = WinGetPos($g_hFrmBot)
		If IsArray($aPos) And $aPos[0] > -30000 Or $aPos[0] > -30000 Then
			BotMinimize("BotWindowCheck")
			Return True
		EndIf
	EndIf
	Return False
EndFunc   ;==>BotWindowCheck

;---------------------------------------------------
; Tray Item Functions
;---------------------------------------------------
Func tiStartStop()
	If $g_bRunState Then
		btnStop()
	Else
		btnStart()
	EndIf
EndFunc   ;==>tiStartStop

Func tiShow()
	BotRestore("tiShow")
EndFunc   ;==>tiShow

Func tiHide()
	$g_bHideWhenMinimized = Not $g_bHideWhenMinimized
	TrayItemSetState($g_hTiHide, ($g_bHideWhenMinimized ? $TRAY_CHECKED : $TRAY_UNCHECKED))
	GUICtrlSetState($g_hChkHideWhenMinimized, ($g_bHideWhenMinimized ? $GUI_CHECKED : $GUI_UNCHECKED))
	If $g_bFrmBotMinimized = True Then
		If $g_bHideWhenMinimized = False Then
			BotRestore("tiHide")
		Else
			BotMinimize("tiHide")
		EndIf
	EndIf
EndFunc   ;==>tiHide

Func tiAbout()
	Local $sMsg = "Clash of Clans Bot" & @CRLF & @CRLF & _
			"Version: " & $g_sBotVersion & @CRLF & _
			"Released under the GNU GPLv3 license." & @CRLF & _
			"Visit www.MyBot.run"
	MsgBox(64 + $MB_APPLMODAL + $MB_TOPMOST, $g_sBotTitle, $sMsg, 0, $g_hFrmBot)
EndFunc   ;==>tiAbout

Func tiDonate()
	ShellExecute("https://mybot.run/forums/index.php?/donate/make-donation/")
EndFunc   ;==>tiDonate

Func tiExit()
	BotCloseRequest()
EndFunc   ;==>tiExit

; #FUNCTION# ====================================================================================================================
; Name ..........: SetRedrawBotWindow
; Description ...: Enables and disables bot window automatic redraw on GUI changes
; Syntax ........:
; Parameters ....: $bEnableRedraw : Boolean enables/disables
;                  $bCheckRedrawBotWindow : Boolean to check when redraw gets enabled if bot window needs to be redrawn
;                  $bForceRedraw : Boolean to always redraw bot window when redraw is enabled again
; Return values .: Boolean of former redraw state
; Author ........: Cosote (2015)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: Local $bWasRedraw = SetRedrawBotWindow(False)
;                  [...]
;                  SetRedrawBotWindow($bWasRedraw)
; ===============================================================================================================================
Func SetRedrawBotWindow($bEnableRedraw, $bCheckRedrawBotWindow = Default, $bForceRedraw = Default, $RedrawControlIDs = Default, $sSource = "")
	If $g_iRedrawBotWindowMode = 0 Then Return False ; disabled
	If $g_iRedrawBotWindowMode = 1 Then $RedrawControlIDs = Default ; always redraw entire bot window
	If $bCheckRedrawBotWindow = Default Then $bCheckRedrawBotWindow = True
	If $bForceRedraw = Default Then $bForceRedraw = False
	; speed up GUI changes by disabling window redraw
	Local $bWasRedraw = $g_bRedrawBotWindow[0]
	If $g_bRedrawBotWindow[0] = $bEnableRedraw Then
		; nothing to do
		Return $bWasRedraw
	EndIf
	; enable logging to debug GUI redraw
	;SetDebugLog(($bEnableRedraw ? "Enable" : "Disable") & " MyBot Window Redraw")
	_SendMessage($g_hFrmBotEx, $WM_SETREDRAW, $bEnableRedraw, 0)
	$g_bRedrawBotWindow[0] = $bEnableRedraw
	If $bEnableRedraw Then
		If $bCheckRedrawBotWindow Then
			CheckRedrawBotWindow($bForceRedraw, $RedrawControlIDs, $sSource)
		EndIf
	Else
		SetDebugLog("Disable MyBot Window Redraw" & (($sSource <> "") ? (": " & $sSource) : ("")))
		; set dirty redraw flag
		$g_bRedrawBotWindow[1] = True
	EndIf
	Return $bWasRedraw
EndFunc   ;==>SetRedrawBotWindow


Func SetRedrawBotWindowControls($bEnableRedraw, $RedrawControlIDs, $sSource = "")
	Return SetRedrawBotWindow($bEnableRedraw, True, False, $RedrawControlIDs, $sSource)
EndFunc   ;==>SetRedrawBotWindowControls

Func CheckRedrawBotWindow($bForceRedraw = Default, $RedrawControlIDs = Default, $sSource = "")
	If $g_iRedrawBotWindowMode = 0 Then Return False ; disabled
	If $bForceRedraw = Default Then $bForceRedraw = False
	If $g_iRedrawBotWindowMode = 1 Then $RedrawControlIDs = Default ; always redraw entire bot window
	; check if bot window redraw is enabled and required
	If Not $g_bRedrawBotWindow[0] Then Return False
	If $g_bRedrawBotWindow[1] Or $bForceRedraw Then
		; enable logging to debug GUI redraw
		$g_bRedrawBotWindow[1] = False
		$g_bRedrawBotWindow[2] = False
		; Redraw bot window
		If $RedrawControlIDs = Default Then
			; redraw entire window
			SetDebugLog("Redraw MyBot Window" & ($bForceRedraw ? " (forced)" : "") & (($sSource <> "") ? (": " & $sSource) : (""))) ; enable logging to debug GUI redraw
			_WinAPI_RedrawWindow($g_hFrmBotEx, 0, 0, BitOR($RDW_INVALIDATE, $RDW_ALLCHILDREN, $RDW_ERASE))
		Else
			; redraw only specified control(s)
			If IsArray($RedrawControlIDs) Then
				SetDebugLog("Redraw MyBot ControlIds" & ($bForceRedraw ? " (forced)" : "") & ": " & _ArrayToString($RedrawControlIDs, ", "))
				Local $c
				For $c In $RedrawControlIDs
					If ControlRedraw($g_hFrmBot, $c) = 0 Then
						_WinAPI_RedrawWindow($g_hFrmBotEx, 0, 0, BitOR($RDW_INVALIDATE, $RDW_ALLCHILDREN, $RDW_ERASE))
						ExitLoop
					EndIf
				Next
			Else
				SetDebugLog("Redraw MyBot ControlId" & ($bForceRedraw ? " (forced)" : "") & ": " & $RedrawControlIDs)
				If ControlRedraw($g_hFrmBot, $RedrawControlIDs) = 0 Then
					_WinAPI_RedrawWindow($g_hFrmBotEx, 0, 0, BitOR($RDW_INVALIDATE, $RDW_ALLCHILDREN, $RDW_ERASE))
				EndIf
			EndIf
		EndIf
		_WinAPI_UpdateWindow($g_hFrmBotEx)
		; check if android need redraw as well
		Return True
	Else
		Return CheckRedrawControls(Default, $sSource)
	EndIf
	Return False
EndFunc   ;==>CheckRedrawBotWindow

Func CheckRedrawControls($ForceCheck = Default, $sSource = "") ; ... that require additional redraw is executed like restore from minimized state
	If $g_iRedrawBotWindowMode = 0 Or $g_iGuiMode <> 1 Then Return False ; disabled
	If $ForceCheck = Default Then $ForceCheck = False
	If Not $g_bRedrawBotWindow[2] And Not $ForceCheck Then Return False
	If GUICtrlRead($g_hTabMain, 1) = $g_hTabLog Then
		Local $a = [$g_hTxtLog, $g_hTxtAtkLog]
		Return CheckRedrawBotWindow(True, $a, $sSource)
	EndIf
	$g_bRedrawBotWindow[2] = False
	Return False
EndFunc   ;==>CheckRedrawControls

; Just redraw the bot window with using any dedicated global variables... Use it only in special cases!
Func RedrawBotWindowNow()
	SetDebugLog("Redraw MyBot Window Now")
	_WinAPI_RedrawWindow($g_hFrmBot, 0, 0, BitOR($RDW_INVALIDATE, $RDW_ALLCHILDREN, $RDW_ERASE))
	_WinAPI_UpdateWindow($g_hFrmBot)
EndFunc   ;==>RedrawBotWindowNow

; Redraw only specified control
Func ControlRedraw($hWin, $ConrolId)
	Local $a = ControlGetPos($hWin, "", $ConrolId)
	If IsArray($a) = 0 Then
		SetDebugLog("ControlRedraw: Invalid ControlId: " & $ConrolId)
		Return 0
	EndIf
	Local $hCtrl = (IsHWnd($ConrolId) ? $ConrolId : GUICtrlGetHandle($ConrolId))
	Local $hWinParent = _WinAPI_GetParent($hCtrl)
	SetDebugLog("Control ID " & $ConrolId & " handle: " & $hCtrl & " parent: " & $hWinParent & " $g_hFrmBot: " & $g_hFrmBot & " $g_hFrmBotEx: " & $g_hFrmBotEx & " Pos: " & $a[0] & ", " & $a[1] & ", " & $a[2] & ", " & $a[3], Default, True)
	Local $left = $a[0]
	Local $top = $a[1]
	Local $width = $a[2]
	Local $height = $a[3]
	Local $tRECT = DllStructCreate($tagRECT)
	DllStructSetData($tRECT, "Left", $left)
	DllStructSetData($tRECT, "Top", $top)
	DllStructSetData($tRECT, "Right", $left + $width)
	DllStructSetData($tRECT, "Bottom", $top + $height)
	SetDebugLog("Control ID " & $ConrolId & " RedrawWindow Pos: " & $left & ", " & $top & ", " & $left + $width & ", " & $top + $height, Default, True)
	_WinAPI_RedrawWindow($hWin, $tRECT, 0, BitOR($RDW_INVALIDATE, $RDW_ALLCHILDREN))
	$tRECT = 0
	Return 1
EndFunc   ;==>ControlRedraw

Func SetTime($bForceUpdate = False)
	If $g_hTimerSinceStarted = 0 Then Return ; GIGO, no setTime when timer hasn't started yet
	Local $day = 0, $hour = 0, $min = 0, $sec = 0
	If (GUICtrlRead($g_hGUI_STATS_TAB, 1) = $g_hGUI_STATS_TAB_ITEM2 And GUICtrlRead($g_hGUI_BOT_TAB, 1) = $g_hGUI_BOT_TAB_ITEM5 And GUICtrlRead($g_hTabMain, 1) = $g_hTabBot) Or $bForceUpdate = True Then
		_TicksToDay(Int(__TimerDiff($g_hTimerSinceStarted) + $g_iTimePassed), $day, $hour, $min, $sec)
		GUICtrlSetData($g_hLblResultRuntime, $day > 0 ? StringFormat("%2u Day(s) %02i:%02i:%02i", $day, $hour, $min, $sec) : StringFormat("%02i:%02i:%02i", $hour, $min, $sec))
	EndIf
	If GUICtrlGetState($g_hLblResultGoldNow) <> $GUI_ENABLE + $GUI_SHOW Or $bForceUpdate = True Then
		_TicksToTime(Int(__TimerDiff($g_hTimerSinceStarted) + $g_iTimePassed), $hour, $min, $sec)
		GUICtrlSetData($g_hLblResultRuntimeNow, StringFormat("%02i:%02i:%02i", $hour, $min, $sec))
	EndIf

	If _DateIsValid($g_sLabUpgradeTime) Then
		Local $iLabTime = _DateDiff("s", _NowCalc(), $g_sLabUpgradeTime) * 1000
		If $iLabTime > 0 Then
			_TicksToDay($iLabTime, $day, $hour, $min, $sec)
			GUICtrlSetData($g_hLbLLabTime, $day > 0 ? StringFormat("%2ud %02i:%02i'", $day, $hour, $min) : StringFormat("%02i:%02i:%02i", $hour, $min, $sec))
			GUICtrlSetColor($g_hLbLLabTime, $day > 0 ? $COLOR_GREEN : $COLOR_ACTION)
		Else
			GUICtrlSetData($g_hLbLLabTime, "")
			$g_sLabUpgradeTime = ""
		EndIf
	EndIf

	If ProfileSwitchAccountEnabled() Then
		If GUICtrlRead($g_hGUI_STATS_TAB, 1) = $g_hGUI_STATS_TAB_ITEM5 And GUICtrlRead($g_hGUI_BOT_TAB, 1) = $g_hGUI_BOT_TAB_ITEM5 And GUICtrlRead($g_hTabMain, 1) = $g_hTabBot Then
			_TicksToTime(Int(__TimerDiff($g_ahTimerSinceSwitched[$g_iCurAccount]) + $g_aiRunTime[$g_iCurAccount]), $hour, $min, $sec)
			GUICtrlSetData($g_ahLblResultRuntimeNowAcc[$g_iCurAccount], StringFormat("%02i:%02i:%02i", $hour, $min, $sec))
			For $i = 0 To $g_iTotalAcc
				If _DateIsValid($g_asTrainTimeFinish[$i]) Then
					Local $iTime = _DateDiff("s", _NowCalc(), $g_asTrainTimeFinish[$i]) * 1000
					_TicksToTime(Abs($iTime), $hour, $min, $sec)
					GUICtrlSetData($g_ahLblTroopTime[$i], ($iTime < 0 ? "-" : "") & StringFormat("%02i:%02i", $min, $sec))
					If $i = $g_iCurAccount Then
						GUICtrlSetColor($g_ahLblTroopTime[$i], $COLOR_GREEN)
					ElseIf $iTime < 0 Then
						GUICtrlSetColor($g_ahLblTroopTime[$i], $COLOR_RED)
					Else
						GUICtrlSetColor($g_ahLblTroopTime[$i], $COLOR_BLACK)
					EndIf
				EndIf
			Next
			SwitchAccountVariablesReload("SetTime")
		EndIf
	EndIf
EndFunc   ;==>SetTime

Func tabMain()
	If $g_iGuiMode <> 1 Then Return
	Local $tabidx = GUICtrlRead($g_hTabMain)
	Select
		Case $tabidx = 0 ; Log
			GUISetState(@SW_HIDE, $g_hGUI_VILLAGE)
			GUISetState(@SW_HIDE, $g_hGUI_BUILDER_BASE) ; BBase - Team AIO Mod++
			GUISetState(@SW_HIDE, $g_hGUI_ATTACK)
			GUISetState(@SW_HIDE, $g_hGUI_BOT)
			GUISetState(@SW_HIDE, $g_hGUI_MOD) ; BBase - Team AIO Mod++
			GUISetState(@SW_HIDE, $g_hGUI_ABOUT)
			GUISetState(@SW_SHOWNOACTIVATE, $g_hGUI_LOG)

		Case $tabidx = 1 ; Village
			GUISetState(@SW_HIDE, $g_hGUI_LOG)
			GUISetState(@SW_HIDE, $g_hGUI_ATTACK)
			GUISetState(@SW_HIDE, $g_hGUI_BOT)
			GUISetState(@SW_HIDE, $g_hGUI_BUILDER_BASE) ; BBase - Team AIO Mod++
			GUISetState(@SW_HIDE, $g_hGUI_MOD) ; BBase - Team AIO Mod++
			GUISetState(@SW_HIDE, $g_hGUI_ABOUT)
			GUISetState(@SW_SHOWNOACTIVATE, $g_hGUI_VILLAGE)
			tabVillage()

		Case $tabidx = 2 ; Attack
			GUISetState(@SW_HIDE, $g_hGUI_LOG)
			GUISetState(@SW_HIDE, $g_hGUI_VILLAGE)
			GUISetState(@SW_HIDE, $g_hGUI_BOT)
			GUISetState(@SW_HIDE, $g_hGUI_BUILDER_BASE) ; BBase - Team AIO Mod++
			GUISetState(@SW_HIDE, $g_hGUI_MOD) ; BBase - Team AIO Mod++
			GUISetState(@SW_HIDE, $g_hGUI_ABOUT)
			GUISetState(@SW_SHOWNOACTIVATE, $g_hGUI_ATTACK)
			tabAttack()

			#Region - BBase - Team AIO Mod++
		Case $tabidx = 3 ; Builder Base
			GUISetState(@SW_HIDE, $g_hGUI_LOG)
			GUISetState(@SW_HIDE, $g_hGUI_VILLAGE)
			GUISetState(@SW_HIDE, $g_hGUI_ATTACK)
			GUISetState(@SW_HIDE, $g_hGUI_BOT)
			GUISetState(@SW_HIDE, $g_hGUI_ABOUT)
			GUISetState(@SW_HIDE, $g_hGUI_MOD)
			GUISetState(@SW_SHOWNOACTIVATE, $g_hGUI_BUILDER_BASE)
			tabBuilderBase()

		Case $tabidx = 4  ; Mod
			GUISetState(@SW_HIDE, $g_hGUI_LOG)
			GUISetState(@SW_HIDE, $g_hGUI_VILLAGE)
			GUISetState(@SW_HIDE, $g_hGUI_ATTACK)
			GUISetState(@SW_HIDE, $g_hGUI_BOT)
			GUISetState(@SW_SHOWNOACTIVATE, $g_hGUI_ABOUT)
			GUISetState(@SW_HIDE, $g_hGUI_BUILDER_BASE)
			GUISetState(@SW_SHOWNOACTIVATE, $g_hGUI_MOD)
			#EndRegion - BBase - Team AIO Mod++

		Case $tabidx = 5 ; Options
			GUISetState(@SW_HIDE, $g_hGUI_LOG)
			GUISetState(@SW_HIDE, $g_hGUI_VILLAGE)
			GUISetState(@SW_HIDE, $g_hGUI_BUILDER_BASE) ; BBase - Team AIO Mod++
			GUISetState(@SW_HIDE, $g_hGUI_ATTACK)
			GUISetState(@SW_HIDE, $g_hGUI_ABOUT)
			GUISetState(@SW_HIDE, $g_hGUI_MOD) ; BBase - Team AIO Mod++
			GUISetState(@SW_SHOWNOACTIVATE, $g_hGUI_BOT)
			tabBot()

		Case $tabidx = 6 ; About
			GUISetState(@SW_HIDE, $g_hGUI_LOG)
			GUISetState(@SW_HIDE, $g_hGUI_VILLAGE)
			GUISetState(@SW_HIDE, $g_hGUI_ATTACK)
			GUISetState(@SW_HIDE, $g_hGUI_BOT)
			GUISetState(@SW_HIDE, $g_hGUI_BUILDER_BASE)
			GUISetState(@SW_HIDE, $g_hGUI_MOD)

			GUISetState(@SW_SHOWNOACTIVATE, $g_hGUI_ABOUT)

		Case Else
			GUISetState(@SW_HIDE, $g_hGUI_LOG)
			GUISetState(@SW_HIDE, $g_hGUI_VILLAGE)
			GUISetState(@SW_HIDE, $g_hGUI_ATTACK)
			GUISetState(@SW_HIDE, $g_hGUI_BOT)
			GUISetState(@SW_HIDE, $g_hGUI_BUILDER_BASE) ; BBase - Team AIO Mod++
			GUISetState(@SW_HIDE, $g_hGUI_MOD) ; BBase - Team AIO Mod++
	EndSelect

EndFunc   ;==>tabMain

Func tabVillage()
	If $g_iGuiMode <> 1 Then Return
	Local $tabidx = GUICtrlRead($g_hGUI_VILLAGE_TAB)
	Select
		Case $tabidx = 0 ; Misc Tab
			GUISetState(@SW_HIDE, $g_hGUI_UPGRADE)
			GUISetState(@SW_SHOWNOACTIVATE, $g_hGUI_MISC)
			GUISetState(@SW_HIDE, $g_hGUI_DONATE)
			GUISetState(@SW_HIDE, $g_hGUI_NOTIFY)
		Case $tabidx = 1 ; Donate tab
			GUISetState(@SW_HIDE, $g_hGUI_UPGRADE)
			GUISetState(@SW_HIDE, $g_hGUI_MISC)
			GUISetState(@SW_SHOWNOACTIVATE, $g_hGUI_DONATE)
			GUISetState(@SW_HIDE, $g_hGUI_NOTIFY)
		Case $tabidx = 2 ; Upgrade tab
			GUISetState(@SW_SHOWNOACTIVATE, $g_hGUI_UPGRADE)
			GUISetState(@SW_HIDE, $g_hGUI_MISC)
			GUISetState(@SW_HIDE, $g_hGUI_DONATE)
			GUISetState(@SW_HIDE, $g_hGUI_NOTIFY)
		Case $tabidx = 4 ; NOTIFY tab
			GUISetState(@SW_HIDE, $g_hGUI_UPGRADE)
			GUISetState(@SW_HIDE, $g_hGUI_MISC)
			GUISetState(@SW_HIDE, $g_hGUI_DONATE)
			GUISetState(@SW_SHOWNOACTIVATE, $g_hGUI_NOTIFY)
		Case Else
			GUISetState(@SW_HIDE, $g_hGUI_UPGRADE)
			GUISetState(@SW_HIDE, $g_hGUI_MISC)
			GUISetState(@SW_HIDE, $g_hGUI_DONATE)
			GUISetState(@SW_HIDE, $g_hGUI_NOTIFY)
	EndSelect

EndFunc   ;==>tabVillage

Func tabAttack()
	If $g_iGuiMode <> 1 Then Return
	Local $tabidx = GUICtrlRead($g_hGUI_ATTACK_TAB)
	Select
		Case $tabidx = 0 ; ARMY tab
			GUISetState(@SW_HIDE, $g_hGUI_STRATEGIES)
			GUISetState(@SW_SHOWNOACTIVATE, $g_hGUI_TRAINARMY)
			GUISetState(@SW_HIDE, $g_hGUI_SEARCH)
			tabARMY()
		Case $tabidx = 1 ; SEARCH tab
			GUISetState(@SW_HIDE, $g_hGUI_STRATEGIES)
			GUISetState(@SW_HIDE, $g_hGUI_TRAINARMY)
			GUISetState(@SW_SHOWNOACTIVATE, $g_hGUI_SEARCH)
			tabSEARCH()
		Case $tabidx = 2 ; NewSmartZap tab
			GUISetState(@SW_SHOWNOACTIVATE, $g_hGUI_STRATEGIES)
			GUISetState(@SW_HIDE, $g_hGUI_TRAINARMY)
			GUISetState(@SW_HIDE, $g_hGUI_SEARCH)
	EndSelect
EndFunc   ;==>tabAttack

Func tabARMY()
	; Custom - Team AIO Mod++
	If $g_iGuiMode <> 1 Then Return
	Local $tabidx = GUICtrlRead($g_hGUI_TRAINARMY_TAB)

	Select
		Case $tabidx = 0 ; Army tab
			GUISetState(@SW_SHOWNOACTIVATE, $g_hGUI_TRAINARMY_ARMY)
			GUISetState(@SW_HIDE, $g_hGUI_SPELLARMY_ARMY)
			GUISetState(@SW_HIDE, $g_hGUI_SIEGEARMY_ARMY)
			GUISetState(@SW_HIDE, $g_hGUI_TRAINARMY_BOOST)
			GUISetState(@SW_HIDE, $g_hGUI_TRAINARMY_OPTIONS)

		Case $tabidx = 1 ; Spells tab
			GUISetState(@SW_HIDE, $g_hGUI_TRAINARMY_ARMY)
			GUISetState(@SW_SHOWNOACTIVATE, $g_hGUI_SPELLARMY_ARMY)
			GUISetState(@SW_HIDE, $g_hGUI_SIEGEARMY_ARMY)
			GUISetState(@SW_HIDE, $g_hGUI_TRAINARMY_BOOST)
			GUISetState(@SW_HIDE, $g_hGUI_TRAINARMY_OPTIONS)

		Case $tabidx = 2 ; Sieges tab
			GUISetState(@SW_HIDE, $g_hGUI_TRAINARMY_ARMY)
			GUISetState(@SW_HIDE, $g_hGUI_SPELLARMY_ARMY)
			GUISetState(@SW_SHOWNOACTIVATE, $g_hGUI_SIEGEARMY_ARMY)
			GUISetState(@SW_HIDE, $g_hGUI_TRAINARMY_BOOST)
			GUISetState(@SW_HIDE, $g_hGUI_TRAINARMY_OPTIONS)

		Case $tabidx = 3 ; Boost tab
			GUISetState(@SW_HIDE, $g_hGUI_TRAINARMY_ARMY)
			GUISetState(@SW_HIDE, $g_hGUI_SPELLARMY_ARMY)
			GUISetState(@SW_HIDE, $g_hGUI_SIEGEARMY_ARMY)
			GUISetState(@SW_SHOWNOACTIVATE, $g_hGUI_TRAINARMY_BOOST)
			GUISetState(@SW_HIDE, $g_hGUI_TRAINARMY_OPTIONS)

		Case $tabidx = 4 ; Options tab
			GUISetState(@SW_HIDE, $g_hGUI_TRAINARMY_ARMY)
			GUISetState(@SW_HIDE, $g_hGUI_SPELLARMY_ARMY)
			GUISetState(@SW_HIDE, $g_hGUI_SIEGEARMY_ARMY)
			GUISetState(@SW_HIDE, $g_hGUI_TRAINARMY_BOOST)
			GUISetState(@SW_SHOWNOACTIVATE, $g_hGUI_TRAINARMY_OPTIONS)

	EndSelect
#cs
	If $g_iGuiMode <> 1 Then Return
	Local $tabidx = GUICtrlRead($g_hGUI_TRAINARMY_TAB)

	Select
		Case $tabidx = 0 ; Army tab
			GUISetState(@SW_SHOWNOACTIVATE, $g_hGUI_TRAINARMY_ARMY)
			GUISetState(@SW_HIDE, $g_hGUI_TRAINARMY_BOOST)
			GUISetState(@SW_HIDE, $g_hGUI_TRAINARMY_TRAINORDER)
			GUISetState(@SW_HIDE, $g_hGUI_TRAINARMY_OPTIONS)

		Case $tabidx = 1 ; Boost tab
			GUISetState(@SW_HIDE, $g_hGUI_TRAINARMY_ARMY)
			GUISetState(@SW_SHOWNOACTIVATE, $g_hGUI_TRAINARMY_BOOST)
			GUISetState(@SW_HIDE, $g_hGUI_TRAINARMY_TRAINORDER)
			GUISetState(@SW_HIDE, $g_hGUI_TRAINARMY_OPTIONS)

		Case $tabidx = 2 ; Train Order tab
			GUISetState(@SW_HIDE, $g_hGUI_TRAINARMY_ARMY)
			GUISetState(@SW_HIDE, $g_hGUI_TRAINARMY_BOOST)
			GUISetState(@SW_SHOWNOACTIVATE, $g_hGUI_TRAINARMY_TRAINORDER)
			GUISetState(@SW_HIDE, $g_hGUI_TRAINARMY_OPTIONS)

		Case $tabidx = 3 ; Options tab
			GUISetState(@SW_HIDE, $g_hGUI_TRAINARMY_ARMY)
			GUISetState(@SW_HIDE, $g_hGUI_TRAINARMY_BOOST)
			GUISetState(@SW_HIDE, $g_hGUI_TRAINARMY_TRAINORDER)
			GUISetState(@SW_SHOWNOACTIVATE, $g_hGUI_TRAINARMY_OPTIONS)

	EndSelect
#ce
EndFunc   ;==>tabARMY

Func tabSEARCH()
	If $g_iGuiMode <> 1 Then Return
	Local $tabidx = GUICtrlRead($g_hGUI_SEARCH_TAB)
	Local $tabdbx = _GUICtrlTab_GetItemRect($g_hGUI_SEARCH_TAB, 0) ;get array of deadbase Tabitem rectangle coordinates, index 2,3 will be lower right X,Y coordinates (not needed: 0,1 = top left x,y)
	Local $tababx = _GUICtrlTab_GetItemRect($g_hGUI_SEARCH_TAB, 1) ;idem for activebase
	Local $tabblx = _GUICtrlTab_GetItemRect($g_hGUI_SEARCH_TAB, 2) ;idem for bully
	Select
		Case $tabidx = 0 ; Deadbase tab
			GUISetState(@SW_HIDE, $g_hGUI_ACTIVEBASE)
			GUISetState(@SW_HIDE, $g_hGUI_BULLY)
			GUISetState(@SW_HIDE, $g_hGUI_ATTACKOPTION)

			If GUICtrlRead($g_hChkDeadbase) = $GUI_CHECKED Then
				GUISetState(@SW_SHOWNOACTIVATE, $g_hGUI_DEADBASE)
				GUICtrlSetState($g_hLblDeadbaseDisabled, $GUI_HIDE)
			Else
				GUISetState(@SW_HIDE, $g_hGUI_DEADBASE)
				GUICtrlSetState($g_hLblDeadbaseDisabled, $GUI_SHOW)
			EndIf

			GUICtrlSetPos($g_hChkActivebase, $tababx[2] - 15, $tababx[3] - 15) ; use x,y coordinate of tabitem rectangle bottom right corner to dynamically reposition the checkbox control (for translated tabnames)
			GUICtrlSetPos($g_hChkBully, $tabblx[2] - 15, $tabblx[3] - 15)

			GUICtrlSetPos($g_hChkDeadbase, $tabdbx[2] - 15, $tabdbx[3] - 17)
			tabDeadbase()
		Case $tabidx = 1 ; Activebase tab
			GUISetState(@SW_HIDE, $g_hGUI_DEADBASE)
			GUISetState(@SW_HIDE, $g_hGUI_BULLY)
			GUISetState(@SW_HIDE, $g_hGUI_ATTACKOPTION)

			If GUICtrlRead($g_hChkActivebase) = $GUI_CHECKED Then
				GUISetState(@SW_SHOWNOACTIVATE, $g_hGUI_ACTIVEBASE)
				GUICtrlSetState($g_hLblActivebaseDisabled, $GUI_HIDE)
			Else
				GUISetState(@SW_HIDE, $g_hGUI_ACTIVEBASE)
				GUICtrlSetState($g_hLblActivebaseDisabled, $GUI_SHOW)
			EndIf

			GUICtrlSetPos($g_hChkDeadbase, $tabdbx[2] - 15, $tabdbx[3] - 15)
			GUICtrlSetPos($g_hChkBully, $tabblx[2] - 15, $tabblx[3] - 15)

			GUICtrlSetPos($g_hChkActivebase, $tababx[2] - 15, $tababx[3] - 17)
			tabActivebase()
		Case $tabidx = 2 ; Bully tab
			GUISetState(@SW_HIDE, $g_hGUI_DEADBASE)
			GUISetState(@SW_HIDE, $g_hGUI_ACTIVEBASE)
			GUISetState(@SW_HIDE, $g_hGUI_ATTACKOPTION)

			If GUICtrlRead($g_hChkBully) = $GUI_CHECKED Then
				GUISetState(@SW_SHOWNOACTIVATE, $g_hGUI_BULLY)
				GUICtrlSetState($g_hLblBullyDisabled, $GUI_HIDE)
			Else
				GUISetState(@SW_HIDE, $g_hGUI_BULLY)
				GUICtrlSetState($g_hLblBullyDisabled, $GUI_SHOW)
			EndIf

			GUICtrlSetPos($g_hChkDeadbase, $tabdbx[2] - 15, $tabdbx[3] - 15)
			GUICtrlSetPos($g_hChkActivebase, $tababx[2] - 15, $tababx[3] - 15)

			GUICtrlSetPos($g_hChkBully, $tabblx[2] - 15, $tabblx[3] - 17)
			; Bully has no tabs
		Case $tabidx = 3 ; Options
			GUISetState(@SW_HIDE, $g_hGUI_DEADBASE)
			GUISetState(@SW_HIDE, $g_hGUI_ACTIVEBASE)
			GUISetState(@SW_HIDE, $g_hGUI_BULLY)

			GUISetState(@SW_SHOWNOACTIVATE, $g_hGUI_ATTACKOPTION)

			GUICtrlSetPos($g_hChkDeadbase, $tabdbx[2] - 15, $tabdbx[3] - 15)
			GUICtrlSetPos($g_hChkActivebase, $tababx[2] - 15, $tababx[3] - 15)
			GUICtrlSetPos($g_hChkBully, $tabblx[2] - 15, $tabblx[3] - 15)
	EndSelect

EndFunc   ;==>tabSEARCH

#Region - BBase - Team AIO Mod++
Func tabBuilderBase()
	Local $tabidx = GUICtrlRead($g_hGUI_BUILDER_BASE_TAB)
	Local $tabtsx = _GUICtrlTab_GetItemRect($g_hGUI_BUILDER_BASE_TAB, 2) ; use x,y coordinate of tabitem rectangle bottom right corner to dynamically reposition the checkbox control (for translated tabnames)

	Select
		Case $tabidx = 0 ; MISC & STATS tab
			GUISetState(@SW_SHOWNOACTIVATE, $g_hGUI_LOG_BB)
			GUISetState(@SW_HIDE, $g_hGUI_ATTACK_PLAN_BUILDER_BASE)
			GUISetState(@SW_HIDE, $g_hGUI_ATTACK_PLAN_BUILDER_BASE_CSV)
			GUICtrlSetPos($g_hChkBuilderAttack, $tabtsx[2] - 18, $tabtsx[3] - 15)
		Case $tabidx = 1 ; UPGRADE tab
			GUISetState(@SW_HIDE, $g_hGUI_LOG_BB)
			GUISetState(@SW_HIDE, $g_hGUI_ATTACK_PLAN_BUILDER_BASE)
			GUISetState(@SW_HIDE, $g_hGUI_ATTACK_PLAN_BUILDER_BASE_CSV)
			GUICtrlSetPos($g_hChkBuilderAttack, $tabtsx[2] - 18, $tabtsx[3] - 15)
		Case $tabidx = 2 ; ATTACK PLAN tab
			GUISetState(@SW_HIDE, $g_hGUI_LOG_BB)
			If GUICtrlRead($g_hChkBuilderAttack) = $GUI_CHECKED Then
				GUISetState(@SW_SHOWNOACTIVATE, $g_hGUI_ATTACK_PLAN_BUILDER_BASE)
				GUISetState(@SW_SHOWNOACTIVATE, $g_hGUI_ATTACK_PLAN_BUILDER_BASE_CSV)
				GUICtrlSetState($g_hLblBuilderAttackDisabled, $GUI_HIDE)
			Else
				GUISetState(@SW_HIDE, $g_hGUI_ATTACK_PLAN_BUILDER_BASE)
				GUISetState(@SW_HIDE, $g_hGUI_ATTACK_PLAN_BUILDER_BASE_CSV)
				GUICtrlSetState($g_hLblBuilderAttackDisabled, $GUI_SHOW)
			EndIf
			GUICtrlSetPos($g_hChkBuilderAttack, $tabtsx[2] - 15, $tabtsx[3] - 17)
	EndSelect
EndFunc   ;==>tabBuilderBase
#EndRegion - BBase - Team AIO Mod++

; Team AiO MOD++ (2019)
Func tabDONATE()
	If $g_iGuiMode <> 1 Then Return
	Local $tabidx = GUICtrlRead($g_hGUI_DONATE_TAB)
	Local $tabdonx = _GUICtrlTab_GetItemRect($g_hGUI_DONATE_TAB, 1)

	Select
		Case $tabidx = 0 ; RequestCC
			GUISetState(@SW_SHOWNOACTIVATE, $g_hGUI_RequestCC)
			GUISetState(@SW_HIDE, $g_hGUI_DONATECC)
			GUISetState(@SW_HIDE, $g_hGUI_ScheduleCC)
			GUICtrlSetPos($g_hChkDonate, $tabdonx[2] - 15, $tabdonx[3] - 15)

		Case $tabidx = 1 ; Donate CC
			GUISetState(@SW_HIDE, $g_hGUI_RequestCC)
			GUISetState(@SW_HIDE, $g_hGUI_ScheduleCC)
			If GUICtrlRead($g_hChkDonate) = $GUI_CHECKED Then
				GUISetState(@SW_SHOWNOACTIVATE, $g_hGUI_DONATECC)
				GUICtrlSetState($g_hLblDonateDisabled, $GUI_HIDE)
			Else
				GUISetState(@SW_HIDE, $g_hGUI_DONATECC)
				GUICtrlSetState($g_hLblDonateDisabled, $GUI_SHOW)
			EndIf
			GUICtrlSetPos($g_hChkDonate, $tabdonx[2] - 15, $tabdonx[3] - 15)

		Case $tabidx = 2 ; Schedule
			GUISetState(@SW_HIDE, $g_hGUI_RequestCC)
			GUISetState(@SW_HIDE, $g_hGUI_DONATECC)
			If GUICtrlRead($g_hChkDonate) = $GUI_CHECKED Then
				GUISetState(@SW_SHOWNOACTIVATE, $g_hGUI_ScheduleCC)
				GUICtrlSetState($g_hLblScheduleDisabled, $GUI_HIDE)
			Else
				GUISetState(@SW_HIDE, $g_hGUI_ScheduleCC)
				GUICtrlSetState($g_hLblScheduleDisabled, $GUI_SHOW)
			EndIf
			GUICtrlSetPos($g_hChkDonate, $tabdonx[2] - 15, $tabdonx[3] - 15)
		Case $tabidx = 3 ; Team AIO Mod++
			GUISetState(@SW_HIDE, $g_hGUI_RequestCC)
			GUISetState(@SW_HIDE, $g_hGUI_DONATECC)
			GUISetState(@SW_HIDE, $g_hGUI_ScheduleCC)

			If GUICtrlRead($g_hChkDonate) = $GUI_CHECKED Then
				GUICtrlSetState($g_hLblScheduleDisabled, $GUI_HIDE)
			Else
				GUICtrlSetState($g_hLblScheduleDisabled, $GUI_SHOW)
			EndIf

			GUICtrlSetPos($g_hChkDonate, $tabdonx[2] - 15, $tabdonx[3] - 15)

	EndSelect

EndFunc   ;==>tabDONATE

; Team AiO MOD++ (2019)
Func tabMod()
	If $g_iGuiMode <> 1 Then Return
	Local $tabidx = GUICtrlRead($g_hGUI_MOD_TAB)
	Select
		Case $tabidx = 0

		Case $tabidx = 1

		Case $tabidx = 2

		Case $tabidx = 3

		Case $tabidx = 4

	EndSelect
EndFunc   ;==>tabMod

Func tabBot()
	If $g_iGuiMode <> 1 Then Return
	Local $tabidx = GUICtrlRead($g_hGUI_BOT_TAB)
	Select
		Case $tabidx = 0 ; Options tab
			GUISetState(@SW_HIDE, $g_hGUI_STATS)
			GUISetState(@SW_HIDE, $g_hGUI_SWITCH_OPTIONS)
			ControlShow("", "", $g_hCmbGUILanguage)
		Case $tabidx = 1 ; Android tab
			GUISetState(@SW_HIDE, $g_hGUI_STATS)
			GUISetState(@SW_HIDE, $g_hGUI_SWITCH_OPTIONS)
			ControlHide("", "", $g_hCmbGUILanguage)
		Case $tabidx = 2 ; Debug tab
			GUISetState(@SW_HIDE, $g_hGUI_STATS)
			GUISetState(@SW_HIDE, $g_hGUI_SWITCH_OPTIONS)
			ControlHide("", "", $g_hCmbGUILanguage)
		Case $tabidx = 3 ; Profiles tab
			GUISetState(@SW_HIDE, $g_hGUI_STATS)
			GUISetState(@SW_SHOWNOACTIVATE, $g_hGUI_SWITCH_OPTIONS)
			ControlHide("", "", $g_hCmbGUILanguage)
			tabSwitchOptions()
		Case $tabidx = 4 ; Stats tab
			GUISetState(@SW_SHOWNOACTIVATE, $g_hGUI_STATS)
			GUISetState(@SW_HIDE, $g_hGUI_SWITCH_OPTIONS)
			If Not $g_bRunState Then UpdateMultiStats()
			ControlHide("", "", $g_hCmbGUILanguage)
	EndSelect
EndFunc   ;==>tabBot

Func tabSwitchOptions()
	If $g_iGuiMode <> 1 Then Return
	Local $tabidx = GUICtrlRead($g_hGUI_SWITCH_OPTIONS_TAB)
	Select
		Case $tabidx = 0
			GUISetState(@SW_SHOWNOACTIVATE, $g_hGUI_LOG_SA)
		Case Else
			GUISetState(@SW_HIDE, $g_hGUI_LOG_SA)
	EndSelect
EndFunc   ;==>tabSwitchOptions

Func tabDeadbase()
	If $g_iGuiMode <> 1 Then Return
	Local $tabidx = GUICtrlRead($g_hGUI_DEADBASE_TAB)
	Select
		;			Case $tabidx = 0 ; Search tab

		Case $tabidx = 1 ; Attack tab
			cmbDBAlgorithm()

			;			Case $tabidx = 2 ; End Battle tab

		Case Else
			GUISetState(@SW_HIDE, $g_hGUI_DEADBASE_ATTACK_STANDARD)
			GUISetState(@SW_HIDE, $g_hGUI_DEADBASE_ATTACK_SCRIPTED)
			GUISetState(@SW_HIDE, $g_hGUI_DEADBASE_ATTACK_SMARTFARM)
			;Region - SmartMilk
			GUISetState(@SW_HIDE, $g_hGUI_DEADBASE_ATTACK_SMARTMILK)
	EndSelect

EndFunc   ;==>tabDeadbase

Func tabActivebase()
	If $g_iGuiMode <> 1 Then Return
	Local $tabidx = GUICtrlRead($g_hGUI_ACTIVEBASE_TAB)
	Select
		;			Case $tabidx = 0 ; Search tab

		Case $tabidx = 1 ; Attack tab
			cmbABAlgorithm()

			;			Case $tabidx = 2 ; End Battle tab

		Case Else
			GUISetState(@SW_HIDE, $g_hGUI_ACTIVEBASE_ATTACK_STANDARD)
			GUISetState(@SW_HIDE, $g_hGUI_ACTIVEBASE_ATTACK_SCRIPTED)

	EndSelect

EndFunc   ;==>tabActivebase

;---------------------------------------------------
; Extra Functions used on GUI Control
;---------------------------------------------------

Func Bind_ImageList($nCtrl, ByRef $hImageList)
	Local $aIconIndex = 0

	If $hImageList = 0 Then
		$hImageList = _GUIImageList_Create(16, 16, 5, 1)
	EndIf
	GUICtrlSendMsg($nCtrl, $TCM_SETIMAGELIST, 0, $hImageList)

	Local $tTcItem = DllStructCreate("uint;dword;dword;ptr;int;int;int")
	DllStructSetData($tTcItem, 1, 0x0002)
	Switch $nCtrl
		#Region BBase - Team AIO Mod++
		Case $g_hTabMain
			; the icons for main tab
			Local $aIconIndex = [$eIcnHourGlass, $eIcnTH14, $eIcnAttack, $eIcnBuilderHall, $eIcnAIOMod, $eIcnGUI, $eIcnInfo]
			#EndRegion BBase - Team AIO Mod++

		Case $g_hGUI_VILLAGE_TAB
			; the icons for village tab
			Local $aIconIndex = [$eIcnTH1, $eIcnCC, $eIcnLaboratory, $eIcnAchievements, $eIcnTelegram]

		Case $g_hGUI_TRAINARMY_TAB
			; the icons for army tab
			Local $aIconIndex = [$eIcnBarrack, $eIcnSpellFactory, $eIcnSiegePets, $eIcnGem, $eIcnOptions] ; Custom train - Team AIO Mod++

		Case $g_hGUI_MISC_TAB
			Local $aIconIndex = [$eIcnTH1, $eIcnStrongMan, $eIcnClanCapital, $eIcnOptions];, $eIcnPowerPotion] ; BBase - Team AIO Mod++

		Case $g_hGUI_DONATE_TAB
			; the icons for donate tab
			Local $aIconIndex = [$eIcnCCRequest, $eIcnCCDonate, $eIcnHourGlass, $eIcnCCTroops] ; Donations - Team AIO Mod++

		Case $g_hGUI_UPGRADE_TAB
			; the icons for upgrade tab
			Local $aIconIndex = [$eIcnLaboratory, $eIcnHeroes, $eIcnMortar, $eIcnBuilder, $eIcnWall]

		Case $g_hGUI_NOTIFY_TAB
			; the icons for NOTIFY tab
			Local $aIconIndex = [$eIcnTelegram, $eIcnDiscord] ; Discord - Team AIO Mod++

		Case $g_hGUI_ATTACK_TAB
			; the icons for attack tab
			Local $aIconIndex = [$eIcnTrain, $eIcnMagnifier, $eIcnStrategies]

		Case $g_hGUI_SEARCH_TAB
			; the icons for SEARCH tab
			Local $aIconIndex = [$eIcnCollector, $eIcnCC, $eIcnTH1, $eIcnOptions] ; Custom fix - Team AIO Mod+

		Case $g_hGUI_DEADBASE_TAB
			; the icons for deadbase tab
			Local $aIconIndex = [$eIcnMagnifier, $eIcnCamp, $eIcnSilverStar, $eIcnCollector]

		Case $g_hGUI_ACTIVEBASE_TAB
			; the icons for activebase tab
			Local $aIconIndex = [$eIcnMagnifier, $eIcnCamp, $eIcnSilverStar]

		Case $g_hGUI_ATTACKOPTION_TAB
			; the icons for Attack Options tab
			Local $aIconIndex = [$eIcnMagnifier, $eIcnCamp, $eIcnLightSpell, $eIcnSilverStar, $eIcnTrophy]

		#Region - Custom  - Team AiO MOD++
		Case $g_hGUI_MOD_TAB
			; the icons for Mods tab
			; $eIcnMiscMod, $eIcnWarPreparation
			; Local $aIconIndex = [$eIcnSuperXP, $eIcnHumanization, $eIcnChatActions, $eIcnGFTO, $eIcnPrewar, $eIcnMisc, $eIcnDebugMod]
			Local $aIconIndex = [$eIcnSuperXP, $eIcnHumanization, $eIcnChatActions, $eIcnGFTO, $eIcnPrewar, $eIcnDebugMod]
			#EndRegion - Custom  - Team AiO MOD++
		Case $g_hGUI_BOT_TAB
			; the icons for Bot tab
			Local $aIconIndex = [$eIcnOptions, $eIcnAndroid, $eIcnModDebug, $eIcnProfile, $eIcnGold]
			; The Android Robot is a Google Trademark and follows Creative Common Attribution 3.0

		Case $g_hGUI_SWITCH_OPTIONS_TAB
			; the icons for Switch Options tab
			Local $aIconIndex = [$eIcnModAccountsS, $eIcnModProfilesS, $eIcnModFarmingS]

		Case $g_hGUI_STRATEGIES_TAB
			; the icons for strategies tab
			Local $aIconIndex = [$eIcnReload, $eIcnCopy]

		Case $g_hGUI_STATS_TAB
			; the icons for stats tab
			Local $aIconIndex = [$eIcnGoldElixir, $eIcnOptions, $eIcnCamp, $eIcnCCRequest, $eIcnGoldElixir]

		#Region BBase - Team AIO Mod++
		Case $g_hGUI_BUILDER_BASE_TAB
			; the icons for builder base tab
			Local $aIconIndex = [$eIcnGold, $eIcnLaboratory, $eIcnVersus]
			#EndRegion BBase - Team AIO Mod++
		Case Else
			;do nothing
	EndSwitch

	If IsArray($aIconIndex) Then ; if array is filled then $nCtrl was a valid control
		For $i = 0 To UBound($aIconIndex) - 1
			DllStructSetData($tTcItem, 6, $i)
			Switch $nCtrl
				Case $g_hGUI_MOD_TAB, $g_hGUI_SWITCH_OPTIONS_TAB
					AddImageToTab($nCtrl, $hImageList, $i, $tTcItem, $g_sLibModIconPath, $aIconIndex[$i] - 1)
				Case $g_hTabMain
					If $i <> 4 Then
						AddImageToTab($nCtrl, $hImageList, $i, $tTcItem, $g_sLibIconPath, $aIconIndex[$i] - 1)
					Else
						AddImageToTab($nCtrl, $hImageList, $i, $tTcItem, $g_sLibModIconPath, $aIconIndex[$i] - 1)
					EndIf
				Case $g_hGUI_BOT_TAB
					If $i <> 2 Then
						AddImageToTab($nCtrl, $hImageList, $i, $tTcItem, $g_sLibIconPath, $aIconIndex[$i] - 1)
					Else
						AddImageToTab($nCtrl, $hImageList, $i, $tTcItem, $g_sLibModIconPath, $aIconIndex[$i] - 1)
					EndIf
				Case $g_hGUI_BUILDER_BASE_TAB
					If $i <> 2 Then
						AddImageToTab($nCtrl, $hImageList, $i, $tTcItem, $g_sLibIconPath, $aIconIndex[$i] - 1)
					Else
						AddImageToTab($nCtrl, $hImageList, $i, $tTcItem, $g_sLibBBIconPath, $aIconIndex[$i] - 1)
					EndIf
				Case Else
					AddImageToTab($nCtrl, $hImageList, $i, $tTcItem, $g_sLibIconPath, $aIconIndex[$i] - 1)
			EndSwitch
		Next
		$aIconIndex = 0 ; empty array
	EndIf

EndFunc   ;==>Bind_ImageList

Func AddImageToTab($nCtrl, ByRef $hImageList, $nTabIndex, $nItem, $g_sLibIconPath, $nIconID)
	Local $hIcon = DllStructCreate("int")
	Local $Result = DllCall("shell32.dll", "int", "ExtractIconEx", "str", $g_sLibIconPath, "int", $nIconID, "hwnd", 0, "ptr", DllStructGetPtr($hIcon), "int", 1)
	If UBound($Result) > 0 Then
		$Result = $Result[0]
		If $Result > 0 Then
			DllCall("comctl32.dll", "int", "ImageList_AddIcon", "hwnd", $hImageList, "hwnd", DllStructGetData($hIcon, 1))
			DllCall("user32.dll", "int", "SendMessage", "hwnd", ControlGetHandle($g_hFrmBot, "", $nCtrl), "int", $TCM_SETITEM, "int", $nTabIndex, "ptr", DllStructGetPtr($nItem))
			DllCall("user32.dll", "int", "DestroyIcon", "hwnd", DllStructGetData($hIcon, 1))
		EndIf
	EndIf
EndFunc   ;==>AddImageToTab

Func _GUICtrlListView_SetItemHeightByFont($hListView, $iHeight)
	; Get font of ListView control
	; Copied from _GUICtrlGetFont example by KaFu
	; See https://www.autoitscript.com/forum/index.php?showtopic=124526
	Local $hDC = _WinAPI_GetDC($hListView), $hFont = _SendMessage($hListView, $WM_GETFONT)
	Local $hObject = _WinAPI_SelectObject($hDC, $hFont), $lvLOGFONT = DllStructCreate($tagLOGFONT)
	_WinAPI_GetObject($hFont, DllStructGetSize($lvLOGFONT), DllStructGetPtr($lvLOGFONT))
	Local $hLVfont = _WinAPI_CreateFontIndirect($lvLOGFONT) ; Original ListView font
	_WinAPI_SelectObject($hDC, $hObject)
	_WinAPI_ReleaseDC($hListView, $hDC)
	_WinAPI_DeleteObject($hFont)

	; Set height of ListView items by applying text font with suitable height
	$hFont = _WinAPI_CreateFont($iHeight, 0)
	_WinAPI_SetFont($hListView, $hFont)
	_WinAPI_DeleteObject($hFont)

	; Restore font of Header control
	Local $hHeader = _GUICtrlListView_GetHeader($hListView)
	If $hHeader Then _WinAPI_SetFont($hHeader, $hLVfont)

	; release memory
	$lvLOGFONT = 0

	; Return original ListView font
	Return $hLVfont
EndFunc   ;==>_GUICtrlListView_SetItemHeightByFont

Func _GUICtrlListView_GetHeightToFitRows($hListView, $iRows)
	; Get height of Header control
	Local $tRECT = _WinAPI_GetClientRect($hListView)
	Local $hHeader = _GUICtrlListView_GetHeader($hListView)
	Local $tWindowPos = _GUICtrlHeader_Layout($hHeader, $tRECT)
	Local $iHdrHeight = DllStructGetData($tWindowPos, "CY")
	; Get height of ListView item 0 (item 0 must exist)
	Local $aItemRect = _GUICtrlListView_GetItemRect($hListView, 0, 0)
	; Return height of ListView to fit $iRows items
	; Including Header height and 8 pixels of additional room
	Return ($aItemRect[3] - $aItemRect[1]) * $iRows + $iHdrHeight + 8
EndFunc   ;==>_GUICtrlListView_GetHeightToFitRows

Func EnableControls($hWin, $Enable, ByRef $avArr, $bGUIControl_Disabled = True, $i = 0)
	If $hWin = 0 Or $hWin = -1 Then Return 0
	Local $initalCall = $i = 0
	If UBound($avArr, 0) <> 2 Then
		Local $avTmp[1][2] = [[0]]
		$avArr = $avTmp
	EndIf
	If $initalCall And $bGUIControl_Disabled Then
		_SendMessage($hWin, $WM_SETREDRAW, False, 0)
		Local $g_bGUIControlDisabled_ = $g_bGUIControlDisabled
		$g_bGUIControlDisabled = True
	EndIf
	Local $hChild = _WinAPI_GetWindow($hWin, $GW_CHILD)
	While $hChild
		$i += 1
		If $avArr[0][0] + 1 > UBound($avArr, 1) - 1 Then
			ReDim $avArr[$avArr[0][0] + 2][2]
			$avArr[$avArr[0][0] + 1][0] = $hChild
			$avArr[$avArr[0][0] + 1][1] = BitAND(WinGetState($hChild), 4) > 0
		EndIf
		If $Enable = Default Then
			WinSetState($hChild, "", ($avArr[$i][1] = True ? @SW_ENABLE : @SW_DISABLE))
		Else
			WinSetState($hChild, "", ($Enable ? @SW_ENABLE : @SW_DISABLE))
		EndIf
		$avArr[0][0] += 1
		$i = EnableControls($hChild, $Enable, $avArr, $bGUIControl_Disabled, $i)
		$hChild = _WinAPI_GetWindow($hChild, $GW_HWNDNEXT)
	WEnd

	If $initalCall And $Enable = Default Then $avArr = 0

	If $initalCall And $bGUIControl_Disabled Then
		_SendMessage($hWin, $WM_SETREDRAW, True, 0)
		_WinAPI_RedrawWindow($hWin, 0, 0, BitOR($RDW_INVALIDATE, $RDW_ALLCHILDREN))
		$g_bGUIControlDisabled = $g_bGUIControlDisabled_
	EndIf

	Return $i
EndFunc   ;==>EnableControls

Func frmBot_WNDPROC($hWin, $iMsg, $wParam, $lParam)
	Local $wasCritical = SetCriticalMessageProcessing(True)
	If $g_iDebugWindowMessages > 0 Then SetDebugLog("frmBot_WNDPROC: FORWARD $hWin=" & $hWin & ", $iMsg=" & Hex($iMsg) & ", $wParam=" & Hex($wParam) & ", $lParam=" & $lParam, Default, True)

	Switch $iMsg
		#cs
			Case $WM_NCACTIVATE
			GUIControl_WM_NCACTIVATE($hWin, $iMsg, $wParam, $lParam)
			Case $WM_SETFOCUS, $WM_KILLFOCUS
			GUIControl_WM_FOCUS($hWin, $iMsg, $wParam, $lParam)
			Case $WM_MOVE
			GUIControl_WM_MOVE($hWin, $iMsg, $wParam, $lParam)
		#ce
		Case $WM_KEYDOWN, $WM_KEYUP, $WM_SYSKEYDOWN, $WM_SYSKEYUP, $WM_MOUSEHWHEEL
			GUIControl_AndroidEmbedded($hWin, $iMsg, $wParam, $lParam)
	EndSwitch

	Local $wndproc = $g_hFrmBot_WNDPROC
	Local $Return = 1
	If $wndproc <> 0 Then
		_WinAPI_CallWindowProc($wndproc, $hWin, $iMsg, $wParam, $lParam)
		$Return = 0
	EndIf
	SetCriticalMessageProcessing($wasCritical)
	Return $Return
EndFunc   ;==>frmBot_WNDPROC

Func HandleWndProc($Enable = True)
	If $g_hFrmBot_WNDPROC = 0 And $Enable = True Then
		$g_hFrmBot_WNDPROC = _WinAPI_SetWindowLong(ControlGetHandle($g_hFrmBot, "", $g_hFrmBotEmbeddedShieldInput), $GWL_WNDPROC, $g_hFrmBot_WNDPROC_ptr)
	ElseIf $g_hFrmBot_WNDPROC <> 0 And $Enable = False Then
		_WinAPI_SetWindowLong(ControlGetHandle($g_hFrmBot, "", $g_hFrmBotEmbeddedShieldInput), $GWL_WNDPROC, $g_hFrmBot_WNDPROC)
		$g_hFrmBot_WNDPROC = 0
	EndIf
EndFunc   ;==>HandleWndProc

Func IsGUICtrlHidden($hGUICtrl)
	If BitAND(WinGetState(GUICtrlGetHandle($hGUICtrl), ""), 2) = 0 Then Return True
	Return False
EndFunc   ;==>IsGUICtrlHidden

Func IsConfigActive()
	Return $g_bReadConfigIsActive Or $g_bSaveConfigIsActive Or $g_bApplyConfigIsActive
EndFunc   ;==>IsConfigActive

Func IsBotLaunched()
	Return $g_iBotLaunchTime > 0
EndFunc   ;==>IsBotLaunched

Func ConsoleWindow($bShow = Default)
	Static $bConsoleAllocated = False
	If $bShow = Default Then $bShow = Not $bConsoleAllocated
	If $bShow Then
		_WinAPI_AllocConsole()
		_WinAPI_SetConsoleIcon($g_sLibIconPath, $eIcnGUI)
		$bConsoleAllocated = True
		SetDebugLog("Allocate Console Window")
	Else
		SetDebugLog("Free Console Window")
		_WinAPI_FreeConsole()
		$bConsoleAllocated = False
	EndIf
EndFunc   ;==>ConsoleWindow
