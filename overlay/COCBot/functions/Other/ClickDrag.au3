;=================================================================================================
; Function:			_PostMessage_ClickDrag($g_hAndroidWindow, $X1, $Y1, $X2, $Y2, $Button = "left")
; Description:		Sends a mouse click and drag command to a specified window.
; Parameter(s):		$g_hAndroidWindow - The handle or the title of the window.
;					$X1, $Y1 - The x/y position to start the drag operation from.
;					$X2, $Y2 - The x/y position to end the drag operation at.
;					$Button - (optional) The button to click, "left", "right", "middle". Default is the left button.
;					$Delay - (optional) Delay in milliseconds. Default is 50.
; Requirement(s):	A window handle/title.
; Return Value(s):	On Success - Returns true
;					On Failure - Returns false
;					@Error - 0 = No error.
;							 1 = Invalid window handle or title.
;							 2 = Invalid start position.
;							 3 = Invalid end position.
;							 4 = Failed to open the dll.
;							 5 = Failed to send a MouseDown command.
;							 5 = Failed to send a MouseMove command.
;							 7 = Failed to send a MouseUp command.
; Author(s):		KillerDeluxe
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
;=================================================================================================
Func _PostMessage_ClickDrag($X1, $Y1, $X2, $Y2, $Button = "left", $Delay = 50)

	Local $hWin = $g_hAndroidControl

	$X1 = Int($X1) + $g_aiMouseOffset[0]
	$Y1 = Int($Y1) + $g_aiMouseOffset[1]
	$X2 = Int($X2) + $g_aiMouseOffset[0]
	$Y2 = Int($Y2) + $g_aiMouseOffset[1]

	; adjust coordinates based on Android control offset
	If $hWin = $g_hAndroidWindow Then
		$X1 += $g_aiBSrpos[0]
		$Y1 += $g_aiBSrpos[1]
		$X2 += $g_aiBSrpos[0]
		$Y2 += $g_aiBSrpos[1]
	EndIf

	If $g_bAndroidEmbedded = False Then
		; special fix for incorrect mouse offset in Android Window (undocked)
		$X1 += $g_aiMouseOffsetWindowOnly[0]
		$Y1 += $g_aiMouseOffsetWindowOnly[1]
		$X2 += $g_aiMouseOffsetWindowOnly[0]
		$Y2 += $g_aiMouseOffsetWindowOnly[1]
	EndIf

	WinGetAndroidHandle()

	If Not IsHWnd($g_hAndroidWindow) Then
		Return SetError(1, "", False)
	EndIf

	Local $Pressed = 0
	If StringLower($Button) == "left" Then
		$Button = $WM_LBUTTONDOWN
		$Pressed = 1
	ElseIf StringLower($Button) == "right" Then
		$Button = $WM_RBUTTONDOWN
		$Pressed = 2
	ElseIf StringLower($Button) == "middle" Then
		$Button = $WM_MBUTTONDOWN
		$Pressed = 10
		If $Delay == 10 Then $Delay = 100
	EndIf

	Local $User32 = DllOpen("User32.dll")
	If @error Then Return SetError(4, "", False)

	MoveMouseOutBS()

	DllCall($User32, "bool", "PostMessage", "hwnd", $g_hAndroidWindow, "int", $Button, "int", "0", "long", _MakeLong($X1, $Y1))
	If @error Then
		DllClose($User32)
		Return SetError(5, "", False)
	EndIf

	If _Sleep($Delay / 2) Then Return SetError(-1, "", False)

	DllCall($User32, "bool", "PostMessage", "hwnd", $g_hAndroidWindow, "int", $WM_MOUSEMOVE, "int", $Pressed, "long", _MakeLong($X2, $Y2))
	If @error Then
		DllClose($User32)
		Return SetError(6, "", False)
	EndIf

	If _Sleep($Delay / 2) Then Return SetError(-1, "", False)

	DllCall($User32, "bool", "PostMessage", "hwnd", $g_hAndroidWindow, "int", $Button + 1, "int", "0", "long", _MakeLong($X2, $Y2))
	If @error Then
		DllClose($User32)
		Return SetError(7, "", False)
	EndIf

	DllClose($User32)
	Return SetError(0, 0, True)
EndFunc   ;==>_PostMessage_ClickDrag

Func _MakeLong($LowWORD, $HiWORD)
	Return BitOR($HiWORD * 0x10000, BitAND($LowWORD, 0xFFFF))
EndFunc   ;==>_MakeLong

Func ClickDrag($X1, $Y1, $X2, $Y2, $Delay = 50, $bSCIDSwitch = False)
	If TestCapture() Then Return
	$bSCIDSwitch = False
	;Return _PostMessage_ClickDrag($X1, $Y1, $X2, $Y2, "left", $Delay)
	Local $error = 0
	If $g_bDebugClick Then
		SetLog("ClickDrag " & $X1 & "," & $Y1 & " to " & $X2 & "," & $Y2 & " delay=" & $Delay, $COLOR_ACTION, "Verdana", "7.5", 0)
	EndIf
	If $g_bAndroidAdbClickDrag Then
		If $g_bAndroidAdbClickDragScript Then
			AndroidClickDrag($X1, $Y1, $X2, $Y2, $g_bRunState, $bSCIDSwitch)
			$error = @error
		Else
			AndroidInputSwipe($X1, $Y1, $X2, $Y2, $g_bRunState, $bSCIDSwitch)
			$error = @error
		EndIf
		If _Sleep($Delay / 5) Then Return SetError(-1, "", False)
	EndIf
	If Not $g_bAndroidAdbClickDrag Or $error <> 0 Then
		Return _PostMessage_ClickDrag($X1, $Y1, $X2, $Y2, "left", $Delay)
	EndIf
	Return SetError(0, 0, ($error = 0 ? True : False))
EndFunc   ;==>ClickDrag