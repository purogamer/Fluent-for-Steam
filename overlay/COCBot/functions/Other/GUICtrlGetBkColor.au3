; #FUNCTION# ====================================================================================================================
; Name ..........: GUICtrlGetBkColor
; Description ...: Retrieves the RGB value of the control background.
; Syntax ........: GUICtrlGetBkColor($hWnd)
; Parameters ....: $hWnd                - Control ID/Handle to the control
; Return values .: Success - RGB value
;                  Failure - 0
; Author ........: guinness
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func GUICtrlGetBkColor($hWnd)
	If Not IsHWnd($hWnd) Then
		$hWnd = GUICtrlGetHandle($hWnd)
	EndIf
	Local $hDC = _WinAPI_GetDC($hWnd)
	Local $iColor = _WinAPI_GetPixel($hDC, 0, 0)
	_WinAPI_ReleaseDC($hWnd, $hDC)
	Return $iColor
EndFunc   ;==>GUICtrlGetBkColor
