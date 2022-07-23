; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file creates the "Log" tab
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: GKevinOD (2014)
; Modified ......: DkEd, Hervidero (2015), CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Global $g_hGUI_LOG = 0
Global $g_hTxtLog = 0, $g_hDivider = 0, $g_hTxtAtkLog = 0
Global $g_hCmbLogDividerOption, $g_hBtnAtkLogClear, $g_hBtnAtkLogCopyClipboard

Func CreateLogTab($hWHndLogsOnly = False)
	Local $i
	Local $x = 0, $y = 0

	Local $activeHWnD = WinGetHandle("") ; RichEdit Controls tamper with active window

	If $hWHndLogsOnly Then
		; only create so logs are available when switching to normal mode
		$g_hTxtLog = _GUICtrlRichEdit_Create($hWHndLogsOnly, "", 0, 0, 20, 20, BitOR($ES_MULTILINE, $ES_READONLY, $WS_VSCROLL, $WS_HSCROLL, $ES_UPPERCASE, $ES_AUTOHSCROLL, $ES_AUTOVSCROLL, $ES_NUMBER, 0x200), $WS_EX_STATICEDGE)
		WinSetState($g_hTxtLog, "", @SW_MINIMIZE)
		$g_hTxtAtkLog = _GUICtrlRichEdit_Create($hWHndLogsOnly, "", 0, 0, 20, 20, BitOR($ES_MULTILINE, $ES_READONLY, $WS_VSCROLL, 8908), $WS_EX_STATICEDGE) ; 8909 = $ES_NUMBER, $ES_AUTOHSCROLL, $ES_AUTOVSCROLL, $ES_MULTILINE, $ES_UPPERCASE, 0x200
		WinSetState($g_hTxtAtkLog, "", @SW_MINIMIZE)
		WinActivate($activeHWnD) ; restore current active window
		Return
	EndIf

	$g_hGUI_LOG = _GUICreate("", $g_iSizeWGrpTab1, $g_iSizeHGrpTab1, $_GUI_CHILD_LEFT, $_GUI_CHILD_TOP, BitOR($WS_CHILD, 0), -1, $g_hFrmBotEx)
	;GUISetBkColor($COLOR_WHITE, $g_hGUI_LOG)

	If IsHWnd($g_hTxtLog) Then
		SetDebugLog("Re-use existing bot log control")
		_WinAPI_SetParent($g_hTxtLog, $g_hGUI_LOG)
		_WinAPI_SetWindowLong($g_hTxtLog, $GWL_HWNDPARENT, $g_hGUI_LOG)
		WinSetState($g_hTxtLog, "", @SW_RESTORE)
	Else
		$g_hTxtLog = _GUICtrlRichEdit_Create($g_hGUI_LOG, "", 0, 0, 20, 20, BitOR($ES_MULTILINE, $ES_READONLY, $WS_VSCROLL, $WS_HSCROLL, $ES_UPPERCASE, $ES_AUTOHSCROLL, $ES_AUTOVSCROLL, $ES_NUMBER, 0x200), $WS_EX_STATICEDGE)
		; Enable word wrap in log file, nice, but better keep warp disabled
		; DllCall($g_hLibUser32DLL, "lresult", "SendMessageW", "hwnd", $g_hTxtLog, "uint", $EM_SETTARGETDEVICE, "wparam", 0, "lparam", False) ; lparam = True for enable again
	EndIf

	$g_hDivider = GUICtrlCreateLabel("", 0, 0, 20, 20, $SS_SUNKEN + $SS_BLACKRECT)
	GUICtrlSetCursor(-1, 11)
	;GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKBOTTOM + $GUI_DOCKWIDTH + $GUI_DOCKLEFT)

	If IsHWnd($g_hTxtAtkLog) Then
		SetDebugLog("Re-use existing attack log control")
		_WinAPI_SetParent($g_hTxtAtkLog, $g_hGUI_LOG)
		_WinAPI_SetWindowLong($g_hTxtAtkLog, $GWL_HWNDPARENT, $g_hGUI_LOG)
		WinSetState($g_hTxtAtkLog, "", @SW_RESTORE)
	Else
		$g_hTxtAtkLog = _GUICtrlRichEdit_Create($g_hGUI_LOG, "", 0, 0, 20, 20, BitOR($ES_MULTILINE, $ES_READONLY, $WS_VSCROLL, 8908), $WS_EX_STATICEDGE) ; 8909 = $ES_NUMBER, $ES_AUTOHSCROLL, $ES_AUTOVSCROLL, $ES_MULTILINE, $ES_UPPERCASE, 0x200
	EndIf

	WinActivate($activeHWnD) ; restore current active window

	$y = 410
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Log", "LblLog_Style", "Log Style") & ":", $x, $y + 5, -1, -1)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)

	$g_hCmbLogDividerOption = GUICtrlCreateCombo("", $x + 50, $y, 180, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Log", "LblLog_Style_Info_01", "Use these options to set the Log type."))
	GUICtrlSetData(-1, GetTranslatedFileIni("MBR GUI Design Log", "CmbLogDividerOption_Item_01", "Use Divider to Resize Both Logs") & "|" & _
			GetTranslatedFileIni("MBR GUI Design Log", "CmbLogDividerOption_Item_02", "Bot and Attack Log Same Size") & "|" & _
			GetTranslatedFileIni("MBR GUI Design Log", "CmbLogDividerOption_Item_03", "Large Bot Log, Small Attack Log") & "|" & _
			GetTranslatedFileIni("MBR GUI Design Log", "CmbLogDividerOption_Item_04", "Small Bot Log, Large Attack Log") & "|" & _
			GetTranslatedFileIni("MBR GUI Design Log", "CmbLogDividerOption_Item_05", "Full Bot Log, Hide Attack Log") & "|" & _
			GetTranslatedFileIni("MBR GUI Design Log", "CmbLogDividerOption_Item_06", "Hide Bot Log, Full Attack Log"))
	_GUICtrlComboBox_SetCurSel(-1, 0) ; Custom fix - Team AIO Mod++
	GUICtrlSetOnEvent(-1, "cmbLog")

	$g_hBtnAtkLogClear = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Log", "BtnAtkLogClear", "Clear Atk. Log"), $x + 270, $y - 1, 80, 23)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Log", "BtnAtkLogClear_Info_01", "Use this to clear the Attack Log."))
	GUICtrlSetOnEvent(-1, "btnAtkLogClear")
	If $g_bBtnColor Then GUICtrlSetBkColor(-1, 0x22C4F5)

	$g_hBtnAtkLogCopyClipboard = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Log", "BtnAtkLogCopyClipboard", "Copy to Clipboard"), $x + 350, $y - 1, 100, 23)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Log", "BtnAtkLogCopyClipboard_Info_01", "Use this to copy the Attack Log to the Clipboard (CTRL+C)"))
	GUICtrlSetOnEvent(-1, "btnAtkLogCopyClipboard")
	If $g_bBtnColor Then GUICtrlSetBkColor(-1, 0x22C4F5)

EndFunc   ;==>CreateLogTab
