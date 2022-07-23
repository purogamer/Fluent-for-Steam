; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Control
; Description ...: This file Includes all functions to current GUI
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: GkevinOD (2014)
; Modified ......: Hervidero (2015), CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Func btnAtkLogClear()
	_GUICtrlRichEdit_SetText($g_hTxtAtkLog, "")
	AtkLogHead()
EndFunc   ;==>btnAtkLogClear

Func btnAtkLogCopyClipboard()
	Local $text = _GUICtrlRichEdit_GetText($g_hTxtAtkLog)
	$text = StringReplace($text, @CR, @CRLF)
	ClipPut($text)
EndFunc   ;==>btnAtkLogCopyClipboard

Func cmbLog()
	If $g_iGuiMode <> 1 Then Return
	; Local $x = 0, $y = 0, $w = $_GUI_MAIN_WIDTH - 20, $h = $_GUI_MAIN_HEIGHT - 490 + Int($g_iFrmBotAddH / 2) ; default GUI values, used as reference
	Local $x = 0, $y = 0, $w = $_GUI_MAIN_WIDTH - 20, $h = $_GUI_MAIN_HEIGHT - (490 - $iFixResolution) + Int($g_iFrmBotAddH / 2) ; default GUI values, used as reference ; Fixed resolution
	If ($g_iLogDividerY > $h + Int($h / 2) + $y And $g_iLogDividerY < $h * 2 + $g_iLogDividerHeight + $y) Or $g_iLogDividerY > $h * 2 + $g_iLogDividerHeight + $y Then $g_iLogDividerY = $h + Int($h / 2) + $y
	If ($g_iLogDividerY < Int($h / 2) + $y And $g_iLogDividerY > 0) Or $g_iLogDividerY < 0 Then $g_iLogDividerY = Int($h / 2)
	_SendMessage($g_hTxtLog, $WM_SETREDRAW, False, 0) ; disable redraw so disabling has no visiual effect
	_WINAPI_EnableWindow($g_hTxtLog, False) ; disable RichEdit
	_SendMessage($g_hTxtAtkLog, $WM_SETREDRAW, False, 0) ; disable redraw so disabling has no visiual effect
	_WINAPI_EnableWindow($g_hTxtAtkLog, False) ; disable RichEdit
	Switch _GUICtrlComboBox_GetCurSel($g_hCmbLogDividerOption)
		Case 0
			ControlShow($g_hGUI_LOG, "", $g_hDivider)
			ControlMove($g_hGUI_LOG, "", $g_hDivider, $x, $g_iLogDividerY - $y, $w, $g_iLogDividerHeight)
			ControlShow($g_hGUI_LOG, "", $g_hTxtLog)
			ControlMove($g_hGUI_LOG, "", $g_hTxtLog, $x, $y, $w, $g_iLogDividerY - $y)
			ControlShow($g_hGUI_LOG, "", $g_hTxtAtkLog)
			ControlMove($g_hGUI_LOG, "", $g_hTxtAtkLog, $x, $g_iLogDividerY + $g_iLogDividerHeight, $w, ($h * 2) - ($g_iLogDividerY - $y))
		Case 1
			ControlShow($g_hGUI_LOG, "", $g_hTxtLog)
			ControlMove($g_hGUI_LOG, "", $g_hTxtLog, $x, $y, $w, $h)
			$y += $h
			ControlHide($g_hGUI_LOG, "", $g_hDivider)
			$y += $g_iLogDividerHeight
			ControlShow($g_hGUI_LOG, "", $g_hTxtAtkLog)
			ControlMove($g_hGUI_LOG, "", $g_hTxtAtkLog, $x, $y, $w, $h)
		Case 2
			ControlShow($g_hGUI_LOG, "", $g_hTxtLog)
			ControlMove($g_hGUI_LOG, "", $g_hTxtLog, $x, $y, $w, $h + ($h / 2))
			$y += $h + ($h / 2) + $g_iLogDividerHeight
			ControlHide($g_hGUI_LOG, "", $g_hDivider)
			ControlShow($g_hGUI_LOG, "", $g_hTxtAtkLog)
			ControlMove($g_hGUI_LOG, "", $g_hTxtAtkLog, $x, $y, $w, $h - ($h / 2))
		Case 3
			ControlShow($g_hGUI_LOG, "", $g_hTxtLog)
			ControlMove($g_hGUI_LOG, "", $g_hTxtLog, $x, $y, $w, $h - ($h / 2))
			$y += ($h / 2) + $g_iLogDividerHeight
			ControlHide($g_hGUI_LOG, "", $g_hDivider)
			ControlShow($g_hGUI_LOG, "", $g_hTxtAtkLog)
			ControlMove($g_hGUI_LOG, "", $g_hTxtAtkLog, $x, $y, $w, $h + ($h / 2))
		Case 4
			ControlShow($g_hGUI_LOG, "", $g_hTxtLog)
			ControlMove($g_hGUI_LOG, "", $g_hTxtLog, $x, $y, $w, $h * 2 + $g_iLogDividerHeight)
			ControlHide($g_hGUI_LOG, "", $g_hTxtAtkLog)
			ControlMove($g_hGUI_LOG, "", $g_hTxtAtkLog, $x, $y + $h * 2 + $g_iLogDividerHeight, $w, 0)
			ControlHide($g_hGUI_LOG, "", $g_hDivider)
		Case 5
			ControlHide($g_hGUI_LOG, "", $g_hTxtLog)
			ControlMove($g_hGUI_LOG, "", $g_hTxtLog, $x, $y, $w, 0)
			ControlShow($g_hGUI_LOG, "", $g_hTxtAtkLog)
			ControlMove($g_hGUI_LOG, "", $g_hTxtAtkLog, $x, $y, $w, $h * 2 + $g_iLogDividerHeight)
			ControlHide($g_hGUI_LOG, "", $g_hDivider)
	EndSwitch
	_SendMessage($g_hTxtLog, $WM_SETREDRAW, True, 0) ; enabled RechEdit redraw again
	_WINAPI_EnableWindow($g_hTxtLog, True) ; enable RichEdit
	;_WinAPI_RedrawWindow($g_hTxtLog, 0, 0, $RDW_INVALIDATE + $RDW_ALLCHILDREN) ; redraw RichEdit
	;_WinAPI_UpdateWindow($g_hTxtLog)
	_SendMessage($g_hTxtAtkLog, $WM_SETREDRAW, True, 0) ; enabled RechEdit redraw again
	_WINAPI_EnableWindow($g_hTxtAtkLog, True) ; enable RichEdit
	;_WinAPI_RedrawWindow($g_hTxtAtkLog, 0, 0, $RDW_INVALIDATE + $RDW_ALLCHILDREN) ; redraw RichEdit
	;_WinAPI_UpdateWindow($g_hTxtAtkLog)

	CheckRedrawControls(True, "cmbLog")
EndFunc   ;==>cmbLog

Func MoveDivider()
	Local $PPos = ControlGetPos($g_hFrmBot, "", $g_hGUI_LOG)
	Local $TPos = ControlGetPos($g_hGUI_LOG, "", $g_hTxtLog)
	Local $BPos = ControlGetPos($g_hGUI_LOG, "", $g_hTxtAtkLog)

	Local $logAndDividerX = $TPos[0] - $PPos[0]
	Local $logAndDividerWidth = $TPos[2]
	Local $totalLogsHeight = $TPos[3] + $BPos[3]
	Local $minVisibleHeight = Ceiling($totalLogsHeight / 4)
	Local $snapToMinMax = Ceiling($minVisibleHeight / 3)
	Local $halfDividerTopHeight = Ceiling($g_iLogDividerHeight / 2)
	Local $halfDividerBottomHeight = Floor($g_iLogDividerHeight / 2)
	Local $startLogsY = $TPos[1] - $_GUI_CHILD_TOP
	Local $endLogsY = $BPos[1] - $_GUI_CHILD_TOP + $BPos[3]

	;SetDebugLog("Devider: " & $g_iLogDividerY & ", " & $logAndDividerX & ", " & $logAndDividerWidth & ", " & $totalLogsHeight & ", " & $minVisibleHeight & ", " & $snapToMinMax & ", " & $halfDividerTopHeight & ", " & $halfDividerBottomHeight & ", " & $halfDividerBottomHeight & ", " & $startLogsY & ", " & $endLogsY)

	Do
		Local $pos = GUIGetCursorInfo($g_hGUI_LOG)
		Local $clickY = $pos[1]

		; adjust $clickY to final value
		If $clickY - $halfDividerTopHeight <= $startLogsY + $snapToMinMax Then
			$clickY = $startLogsY + $halfDividerTopHeight
		ElseIf $clickY + $halfDividerBottomHeight >= $endLogsY - $snapToMinMax Then
			$clickY = $endLogsY - $halfDividerBottomHeight
		ElseIf $clickY - $halfDividerTopHeight > $startLogsY + $snapToMinMax And $clickY - $halfDividerTopHeight <= $startLogsY + $minVisibleHeight Then
			$clickY = $startLogsY + $minVisibleHeight + $halfDividerTopHeight
		ElseIf $clickY + $halfDividerBottomHeight < $endLogsY - $snapToMinMax And $clickY + $halfDividerBottomHeight >= $endLogsY - $minVisibleHeight Then
			$clickY = $endLogsY - $minVisibleHeight - $halfDividerBottomHeight
		EndIf
		$g_iLogDividerY = $clickY - $halfDividerTopHeight
		ControlMove($g_hGUI_LOG, "", $g_hDivider, $logAndDividerX, $g_iLogDividerY, $logAndDividerWidth, $g_iLogDividerHeight)
		ControlMove($g_hGUI_LOG, "", $g_hTxtLog, $logAndDividerX, $startLogsY, $logAndDividerWidth, $clickY - $startLogsY - $halfDividerTopHeight)
		If $endLogsY - ($clickY + $halfDividerBottomHeight) < 0 Then
			ControlMove($g_hGUI_LOG, "", $g_hTxtAtkLog, $logAndDividerX, $endLogsY, $logAndDividerWidth, 0)
		Else
			ControlMove($g_hGUI_LOG, "", $g_hTxtAtkLog, $logAndDividerX, $clickY + $halfDividerBottomHeight, $logAndDividerWidth, $endLogsY - $clickY - $halfDividerBottomHeight)
		EndIf

		_WinAPI_UpdateWindow(WinGetHandle($g_hGUI_LOG))

	Until $pos[2] = 0

	_GUICtrlRichEdit_SetSel($g_hTxtLog, - 1, -1) ; select end
	_GUICtrlRichEdit_SetSel($g_hTxtAtkLog, - 1, -1) ; select end

	SetDebugLog("MoveDivider exit", Default, True)
	$g_bMoveDivider = False ; Team AIO Mod++
EndFunc   ;==>MoveDivider
