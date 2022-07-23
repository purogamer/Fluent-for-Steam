; #FUNCTION# ====================================================================================================================
; Name ..........: RemoveGhostTrayIcons
; Description ...: Removes Ghost Icons with no attached process from systray, adjusts action based on OS
; Syntax ........: RemoveGhostTrayIcons()
; Parameters ....: $IconTextPart
; Return values .: None
; Author ........: wraithdu (AutoIt Forums)
; Modified ......: Cosote (12-2015), Knowjack (08-2015)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://www.autoitscript.com/forum/topic/103871-_systray-udf, https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func RemoveGhostTrayIcons($IconTextPart_notUsedAnymore = "")
	Local $iGhostCount = 0
	Local $i, $handle, $pid
	Local $count = _SysTrayIconCount()
	For $i = $count - 1 To 0 Step -1
		$handle = _SysTrayIconHandle($i)
		$pid = WinGetProcess($handle)
		If $pid = -1 Then
			$iGhostCount += 1
			_SysTrayIconRemove($i)
		EndIf
	Next
	If _FindTrayToolbarWindow(2) <> -1 Then
		Local $countwin7 = _SysTrayIconCount(2)
		For $i = $countwin7 - 1 To 0 Step -1
			$handle = _SysTrayIconHandle($i, 2)
			$pid = WinGetProcess($handle)
			If $pid = -1 Then
				$iGhostCount += 1
				_SysTrayIconRemove($i, 2)
			EndIf
		Next
	EndIf
	If $iGhostCount > 0 And $g_bDebugSetlog Then SetLog("Removed " & $iGhostCount & " Ghost icon successfully", $COLOR_SUCCESS)
EndFunc   ;==>RemoveGhostTrayIcons

; https://www.autoitscript.com/forum/topic/103871-_systray-udf/?page=1
; ----------------------------------------------------------------------------
;
; Author:         Tuape
; Modified:       Erik Pilsits
;
; Script Function:
;   Systray UDF - Functions for reading icon info from system tray / removing
;   any icon.
;
; Last Update: 5/13/2013
;
; ----------------------------------------------------------------------------

;===============================================================================
;
; Function Name:    _SysTrayIconCount($iWin = 1)
; Description:      Returns number of icons on systray
;                   Note: Hidden icons are also reported
; Parameter(s):     $iWin
;                   | 1         - ToolbarWindow32, Win2000+
;                   | 2         - NotifyIconOverflowWindow, Win7+
;
; Requirement(s):
; Return Value(s):  On Success - Returns number of icons found
;                   On Failure - Returns -1
;
; Author(s):        Tuape, Erik Pilsits
;
;===============================================================================
Func _SysTrayIconCount($iWin = 1)
	Local Const $TB_BUTTONCOUNT = 1048
	Local $hWnd = _FindTrayToolbarWindow($iWin)
	If $hWnd = -1 Then Return -1
	Local $count = DllCall("user32.dll", "lresult", "SendMessageW", "hwnd", $hWnd, "uint", $TB_BUTTONCOUNT, "wparam", 0, "lparam", 0)
	If @error Then Return -1
	Return $count[0]
EndFunc   ;==>_SysTrayIconCount

;===============================================================================
;
; Function Name:    _SysTrayIconTitles($iWin = 1)
; Description:      Get list of all window titles that have systray icon
; Parameter(s):     $iWin
;                   | 1         - ToolbarWindow32, Win2000+
;                   | 2         - NotifyIconOverflowWindow, Win7+
; Requirement(s):
; Return Value(s):  On Success - Returns an array with all window titles
;                   On Failure - Returns -1
;
; Author(s):        Tuape, Erik Pilsits
;
;===============================================================================
Func _SysTrayIconTitles($iWin = 1)
	Local $count = _SysTrayIconCount($iWin)
	If $count <= 0 Then Return -1
	Local $titles[$count]
	; Get icon owner window"s title
	For $i = 0 To $count - 1
		$titles[$i] = WinGetTitle(_SysTrayIconHandle($i, $iWin))
	Next
	Return $titles
EndFunc   ;==>_SysTrayIconTitles

;===============================================================================
;
; Function Name:    _SysTrayIconPids($iWin = 1)
; Description:      Get list of all processes id's that have systray icon
; Parameter(s):     $iWin
;                   | 1         - ToolbarWindow32, Win2000+
;                   | 2         - NotifyIconOverflowWindow, Win7+
; Requirement(s):
; Return Value(s):  On Success - Returns an array with all process id's
;                   On Failure - Returns -1
;
; Author(s):        Tuape, Erik Pilsits
;
;===============================================================================
Func _SysTrayIconPids($iWin = 1)
	Local $count = _SysTrayIconCount($iWin)
	If $count <= 0 Then Return -1
	Local $processes[$count]
	For $i = 0 To $count - 1
		$processes[$i] = WinGetProcess(_SysTrayIconHandle($i, $iWin))
	Next
	Return $processes
EndFunc   ;==>_SysTrayIconPids

;===============================================================================
;
; Function Name:    _SysTrayIconProcesses($iWin = 1)
; Description:      Get list of all processes that have systray icon
; Parameter(s):     $iWin
;                   | 1         - ToolbarWindow32, Win2000+
;                   | 2         - NotifyIconOverflowWindow, Win7+
; Requirement(s):
; Return Value(s):  On Success - Returns an array with all process names
;                   On Failure - Returns -1
;
; Author(s):        Tuape, Erik Pilsits
;
;===============================================================================
Func _SysTrayIconProcesses($iWin = 1)
	Local $pids = _SysTrayIconPids($iWin)
	If Not IsArray($pids) Then Return -1
	Local $processes[UBound($pids)]
	; List all processes
	Local $list = ProcessList()
	For $i = 0 To UBound($pids) - 1
		For $j = 1 To $list[0][0]
			If $pids[$i] = $list[$j][1] Then
				$processes[$i] = $list[$j][0]
				ExitLoop
			EndIf
		Next
	Next
	Return $processes
EndFunc   ;==>_SysTrayIconProcesses

;===============================================================================
;
; Function Name:    _SysTrayIconIndex($test, $mode = 0, $iWin = 1)
; Description:      Get list of all processes id"s that have systray icon
; Parameter(s):     $test       - process name / window title text / process PID
;                   $mode
;                   | 0         - get index by process name (default)
;                   | 1         - get index by window title
;                   | 2         - get index by process PID
;                   $iWin
;                   | 1         - ToolbarWindow32, Win2000+
;                   | 2         - NotifyIconOverflowWindow, Win7+
; Requirement(s):
; Return Value(s):  On Success - Returns index of found icon
;                   On Failure - Returns -1
;
; Author(s):        Tuape, Erik Pilsits
;
;===============================================================================
Func _SysTrayIconIndex($test, $mode = 0, $iWin = 1)
	Local $ret = -1, $compare = -1
	If $mode < 0 Or $mode > 2 Or Not IsInt($mode) Then Return -1
	Switch $mode
		Case 0
			$compare = _SysTrayIconProcesses($iWin)
		Case 1
			$compare = _SysTrayIconTitles($iWin)
		Case 2
			$compare = _SysTrayIconPids($iWin)
	EndSwitch
	If Not IsArray($compare) Then Return -1
	For $i = 0 To UBound($compare) - 1
		If $compare[$i] = $test Then
			$ret = $i
			ExitLoop
		EndIf
	Next
	Return $ret
EndFunc   ;==>_SysTrayIconIndex

; INTERNAL =====================================================================
;
; Function Name:    _SysTrayGetButtonInfo($iIndex, $iWin = 1, $iInfo = 0)
; Description:      Gets Tray Button Info
; Parameter(s):     $iIndex     - icon index (Note: starting from 0)
;                   $iWin
;                   | 1         - ToolbarWindow32, Win2000+
;                   | 2         - NotifyIconOverflowWindow, Win7+
;                   $iInfo      - Info to return
;                   | 1         - TBBUTTON structure
;                   | 2         - TRAYDATA structure
;                   | 3         - tooltip
;                   | 4         - icon position
; Requirement(s):
; Return Value(s):  On Success - Returns requested info
;                   On Failure - Sets @error and returns -1
;                   | 1        - Failed to find tray window
;                   | 2        - Failed to get tray window PID
;                   | 3        - Failed to open process
;                   | 4        - Failed to allocate memory
;                   | 5        - Failed to get TBBUTTON info
;
; Author(s):        Erik Pilsits, Tuape
;
;===============================================================================
Func _SysTrayGetButtonInfo($iIndex, $iWin = 1, $iInfo = 1)
	Local Const $TB_GETBUTTON = 1047
;~  Local Const $TB_GETBUTTONTEXT = 1099
;~  Local Const $TB_GETBUTTONINFO = 1089
	Local Const $TB_GETITEMRECT = 1053
	Local Const $ACCESS = BitOR(0x0008, 0x0010, 0x0400) ; VM_OPERATION, VM_READ, QUERY_INFORMATION
	Local $TBBUTTON
	If @OSArch = "X86" Then
		$TBBUTTON = DllStructCreate("int iBitmap;int idCommand;byte fsState;byte fsStyle;byte bReserved[2];dword dwData;int iString")
	Else ; X64
		$TBBUTTON = DllStructCreate("int iBitmap;int idCommand;byte fsState;byte fsStyle;byte bReserved[6];uint64 dwData;int64 iString")
	EndIf
	Local $TRAYDATA
	If @OSArch = "X86" Then
		$TRAYDATA = DllStructCreate("hwnd hwnd;uint uID;uint uCallbackMessage;dword Reserved[2];handle hIcon")
	Else
		$TRAYDATA = DllStructCreate("uint64 hwnd;uint uID;uint uCallbackMessage;dword Reserved[2];uint64 hIcon")
	EndIf
	Local $trayHwnd = _FindTrayToolbarWindow($iWin)
	If $trayHwnd = -1 Then Return SetError(1, 0, -1)
	Local $return, $err = 0
	Local $ret = DllCall("user32.dll", "dword", "GetWindowThreadProcessId", "hwnd", $trayHwnd, "dword*", 0)
	If @error Or Not $ret[2] Then SetError(2, 0, -1)
	Local $pid = $ret[2]
	Local $procHandle = DllCall("kernel32.dll", "handle", "OpenProcess", "dword", $ACCESS, "bool", False, "dword", $pid)
	If @error Or Not $procHandle[0] Then Return SetError(3, 0, -1)
	Local $lpData = DllCall("kernel32.dll", "ptr", "VirtualAllocEx", "handle", $procHandle[0], "ptr", 0, "ulong", DllStructGetSize($TBBUTTON), "dword", 0x1000, "dword", 0x04)
	If Not @error And $lpData[0] Then
		$ret = DllCall("user32.dll", "lresult", "SendMessageW", "hwnd", $trayHwnd, "uint", $TB_GETBUTTON, "wparam", $iIndex, "lparam", $lpData[0])
		If Not @error And $ret[0] Then
			DllCall("kernel32.dll", "bool", "ReadProcessMemory", "handle", $procHandle[0], "ptr", $lpData[0], "struct*", $TBBUTTON, "ulong", DllStructGetSize($TBBUTTON), "ulong*", 0)
			Switch $iInfo
				Case 2
					; TRAYDATA structure
					DllCall("kernel32.dll", "bool", "ReadProcessMemory", "handle", $procHandle[0], "ptr", DllStructGetData($TBBUTTON, 6), "struct*", $TRAYDATA, "ulong", DllStructGetSize($TRAYDATA), "ulong*", 0)
					$return = $TRAYDATA
				Case 3
					; tooltip
					$return = ""
					If BitShift(DllStructGetData($TBBUTTON, 7), 16) <> 0 Then
						Local $intTip = DllStructCreate("wchar[1024]")
						; we have a pointer to a string, otherwise it is an internal resource identifier
						DllCall("kernel32.dll", "bool", "ReadProcessMemory", "handle", $procHandle[0], "ptr", DllStructGetData($TBBUTTON, 7), "struct*", $intTip, "ulong", DllStructGetSize($intTip), "ulong*", 0)
						$return = DllStructGetData($intTip, 1)
						$intTip = 0
						;else internal resource
					EndIf
				Case 4
					; icon position
					If Not BitAND(DllStructGetData($TBBUTTON, 3), 8) Then ; 8 = TBSTATE_HIDDEN
						Local $pos[2], $RECT = DllStructCreate("int;int;int;int")
						DllCall("user32.dll", "lresult", "SendMessageW", "hwnd", $trayHwnd, "uint", $TB_GETITEMRECT, "wparam", $iIndex, "lparam", $lpData[0])
						DllCall("kernel32.dll", "bool", "ReadProcessMemory", "handle", $procHandle[0], "ptr", $lpData[0], "struct*", $RECT, "ulong", DllStructGetSize($RECT), "ulong*", 0)
						$ret = DllCall("user32.dll", "int", "MapWindowPoints", "hwnd", $trayHwnd, "ptr", 0, "struct*", $RECT, "uint", 2)
						$pos[0] = DllStructGetData($RECT, 1)
						$pos[1] = DllStructGetData($RECT, 2)
						$return = $pos
						$RECT = 0
					Else
						$return = -1
					EndIf
				Case Else
					; TBBUTTON
					$return = $TBBUTTON
			EndSwitch
		Else
			$err = 5
		EndIf
		DllCall("kernel32.dll", "bool", "VirtualFreeEx", "handle", $procHandle[0], "ptr", $lpData[0], "ulong", 0, "dword", 0x8000)
	Else
		$err = 4
	EndIf
	DllCall("kernel32.dll", "bool", "CloseHandle", "handle", $procHandle[0])
	If $err Then
		Return SetError($err, 0, -1)
	Else
		Return $return
	EndIf
EndFunc   ;==>_SysTrayGetButtonInfo

;===============================================================================
;
; Function Name:    _SysTrayIconHandle($iIndex, $iWin = 1)
; Description:      Gets hwnd of window associated with systray icon of given index
; Parameter(s):     $iIndex     - icon index (Note: starting from 0)
;                   $iWin
;                   | 1         - ToolbarWindow32, Win2000+
;                   | 2         - NotifyIconOverflowWindow, Win7+
;
; Requirement(s):
; Return Value(s):  On Success - Returns hwnd of found icon
;                   On Failure - Sets @error and returns -1
;                   | See _SysTrayGetButtonInfo for @error returns
;
; Author(s):        Tuape, Erik Pilsits
;
;===============================================================================
Func _SysTrayIconHandle($iIndex, $iWin = 1)
	Local $TRAYDATA = _SysTrayGetButtonInfo($iIndex, $iWin, 2)
	If @error Then
		Return SetError(@error, 0, -1)
	Else
		Return Ptr(DllStructGetData($TRAYDATA, 1))
	EndIf
EndFunc   ;==>_SysTrayIconHandle

;===============================================================================
;
; Function Name:    _SysTrayIconTooltip($iIndex, $iWin = 1)
; Description:      Gets the tooltip text of systray icon of given index
; Parameter(s):     $iIndex     - icon index (Note: starting from 0)
;                   $iWin
;                   | 1         - ToolbarWindow32, Win2000+
;                   | 2         - NotifyIconOverflowWindow, Win7+
;
; Requirement(s):
; Return Value(s):  On Success - Returns tooltip text of icon
;                   On Failure - Sets @error and returns -1
;                   | See _SysTrayGetButtonInfo for @error returns
;
; Author(s):        Tuape, Erik Pilsits
;
;===============================================================================
Func _SysTrayIconTooltip($iIndex, $iWin = 1)
	Local $ret = _SysTrayGetButtonInfo($iIndex, $iWin, 3)
	If @error Then
		Return SetError(@error, 0, -1)
	Else
		Return $ret
	EndIf
EndFunc   ;==>_SysTrayIconTooltip

;===============================================================================
;
; Function Name:    _SysTrayIconPos($iIndex, $iWin = 1)
; Description:      Gets x & y position of systray icon
; Parameter(s):     $iIndex     - icon index (Note: starting from 0)
;                   $iWin
;                   | 1         - ToolbarWindow32, Win2000+
;                   | 2         - NotifyIconOverflowWindow, Win7+
;
; Requirement(s):
; Return Value(s):  On Success - Returns array, x [0] and y [1] position of icon
;                   On Failure - Sets @error and returns -1
;                   | -1       - Icon is hidden (Autohide on XP, etc)
;                   | See _SysTrayGetButtonInfo for additional @error returns
;
; Author(s):        Tuape, Erik Pilsits
;
;===============================================================================
Func _SysTrayIconPos($iIndex, $iWin = 1)
	Local $ret = _SysTrayGetButtonInfo($iIndex, $iWin, 4)
	If @error Then
		Return SetError(@error, 0, -1)
	Else
		If $ret = -1 Then
			Return SetError(-1, 0, -1)
		Else
			Return $ret
		EndIf
	EndIf
EndFunc   ;==>_SysTrayIconPos

;===============================================================================
;
; Function Name:    _SysTrayIconVisible($iIndex, $iWin = 1)
; Description:      Gets the visibility of a systray icon
; Parameter(s):     $iIndex     - icon index (Note: starting from 0)
;                   $iWin
;                   | 1         - ToolbarWindow32, Win2000+
;                   | 2         - NotifyIconOverflowWindow, Win7+
;
; Requirement(s):
; Return Value(s):  On Success - Returns True (visible) or False (hidden)
;                   On Failure - Sets @error and returns -1
;                   | See _SysTrayGetButtonInfo for @error returns
;
; Author(s):        Tuape, Erik Pilsits
;
;===============================================================================
Func _SysTrayIconVisible($iIndex, $iWin = 1)
	Local $TBBUTTON = _SysTrayGetButtonInfo($iIndex, $iWin, 1)
	If @error Then
		Return SetError(@error, 0, -1)
	Else
		Return Not BitAND(DllStructGetData($TBBUTTON, 3), 8) ;TBSTATE_HIDDEN
	EndIf
EndFunc   ;==>_SysTrayIconVisible

;===============================================================================
;
; Function Name:    _SysTrayIconHide($index, $iFlag, $iWin = 1)
; Description:      Hides / unhides any icon on systray
;
; Parameter(s):     $index      - icon index. Can be queried with _SysTrayIconIndex()
;                   $iFlag      - hide (1) or show (0) icon
;                   $iWin
;                   | 1         - ToolbarWindow32, Win2000+
;                   | 2         - NotifyIconOverflowWindow, Win7+
;
; Requirement(s):
; Return Value(s):  On Success - Returns 1 if operation was successfull or 0 if
;                   icon was already hidden/unhidden
;                   On Failure - Sets @error and returns -1
;                   | See _SysTrayGetButtonInfo for @error returns
;
; Author(s):        Tuape, Erik Pilsits
;
;===============================================================================
Func _SysTrayIconHide($index, $iFlag, $iWin = 1)
;~     Local Const $TB_HIDEBUTTON = 0x0404 ; WM_USER + 4
	Local $TBBUTTON = _SysTrayGetButtonInfo($index, $iWin, 1)
	If @error Then Return SetError(@error, 0, -1)
	Local $visible = Not BitAND(DllStructGetData($TBBUTTON, 3), 8) ;TBSTATE_HIDDEN
	If ($iFlag And Not $visible) Or (Not $iFlag And $visible) Then
		Return 0
	Else
		Local $TRAYDATA = _SysTrayGetButtonInfo($index, $iWin, 2)
		If @error Then Return SetError(@error, 0, -1)
		Local $NOTIFYICONDATA = DllStructCreate("dword cbSize;hwnd hWnd;uint uID;uint uFlags;uint uCallbackMessage;handle hIcon;wchar szTip[128];" _
				 & "dword dwState;dword dwStateMask;wchar szInfo[256];uint uVersion;wchar szInfoTitle[64];dword dwInfoFlags;" _
				 & "STRUCT;ulong;ushort;ushort;byte[8];ENDSTRUCT;handle hBalloonIcon")
		DllStructSetData($NOTIFYICONDATA, 1, DllStructGetSize($NOTIFYICONDATA))
		DllStructSetData($NOTIFYICONDATA, 2, Ptr(DllStructGetData($TRAYDATA, 1)))
		DllStructSetData($NOTIFYICONDATA, 3, DllStructGetData($TRAYDATA, 2))
		DllStructSetData($NOTIFYICONDATA, 4, 8) ; NIF_STATE
		DllStructSetData($NOTIFYICONDATA, 8, $iFlag) ; dw_State, 0 or 1 = NIS_HIDDEN
		DllStructSetData($NOTIFYICONDATA, 9, 1) ; dwStateMask
		Local $ret = DllCall("shell32.dll", "bool", "Shell_NotifyIconW", "dword", 0x1, "struct*", $NOTIFYICONDATA) ; NIM_MODIFY
		DllCall("user32.dll", "lresult", "SendMessageW", "hwnd", WinGetHandle("[CLASS:Shell_TrayWnd]"), "uint", 0x001A, "wparam", 0, "lparam", 0) ; WM_SETTINGCHANGE
		$NOTIFYICONDATA = 0
		If IsArray($ret) And $ret[0] Then
			Return 1
		Else
			Return 0
		EndIf
;~      $ret = DllCall("user32.dll", "lresult", "SendMessageW", "hwnd", $trayHwnd, "uint", $TB_HIDEBUTTON, "wparam", DllStructGetData($TBBUTTON, 2), "lparam", $iHide)
;~      If @error Or Not $ret[0] Then
;~          $return = -1
;~      Else
;~          $return = $ret[0]
;~      EndIf
	EndIf
EndFunc   ;==>_SysTrayIconHide

;===============================================================================
;
; Function Name:    _SysTrayIconMove($curPos, $newPos, $iWin = 1)
; Description:      Moves systray icon
;
; Parameter(s):     $curPos     - icon's current index (0 based)
;                   $newPos     - icon's new position
;                                 ($curPos+1 = one step to right, $curPos-1 = one step to left)
;                   $iWin
;                   | 1         - ToolbarWindow32, Win2000+
;                   | 2         - NotifyIconOverflowWindow, Win7+
;
; Requirement(s):   AutoIt3 Beta
; Return Value(s):  On Success - Returns 1 if operation was successfull, 0 if not
;                   On Failure - Sets @error and returns -1
;                   | 1        - Bad parameters
;                   | 2        - Failed to find tray window
;
; Author(s):        Tuape, Erik Pilsits
;
;===============================================================================
Func _SysTrayIconMove($curPos, $newPos, $iWin = 1)
	Local Const $TB_MOVEBUTTON = 0x0452 ; WM_USER + 82
	Local $iconCount = _SysTrayIconCount($iWin)
	If $curPos < 0 Or $newPos < 0 Or $curPos > $iconCount - 1 Or $newPos > $iconCount - 1 Or Not IsInt($curPos) Or Not IsInt($newPos) Then Return SetError(1, 0, -1)
	Local $hWnd = _FindTrayToolbarWindow($iWin)
	If $hWnd = -1 Then Return SetError(2, 0, -1)
	Local $ret = DllCall("user32.dll", "lresult", "SendMessageW", "hwnd", $hWnd, "uint", $TB_MOVEBUTTON, "wparam", $curPos, "lparam", $newPos)
	If @error Or Not $ret[0] Then
		Return 0
	Else
		Return 1
	EndIf
EndFunc   ;==>_SysTrayIconMove

;===============================================================================
;
; Function Name:    _SysTrayIconRemove($index, $iWin = 1)
; Description:      Removes systray icon completely.
;
; Parameter(s):     $index      - Icon index (first icon is 0)
;                   $iWin
;                   | 1         - ToolbarWindow32, Win2000+
;                   | 2         - NotifyIconOverflowWindow, Win7+
;
; Return Value(s):  On Success - Returns 1 if icon successfully removed, 0 if not
;                   On Failure - Sets @error and returns -1
;                   | See _SysTrayGetButtonInfo for @error returns
;
; Author(s):        Tuape, Erik Pilsits
;
;===============================================================================
Func _SysTrayIconRemove($index, $iWin = 1)
	Local Const $TB_DELETEBUTTON = 1046
	Local $TRAYDATA = _SysTrayGetButtonInfo($index, $iWin, 2)
	If @error Then Return SetError(@error, 0, -1)
	Local $NOTIFYICONDATA = DllStructCreate("dword cbSize;hwnd hWnd;uint uID;uint uFlags;uint uCallbackMessage;handle hIcon;wchar szTip[128];" _
			 & "dword dwState;dword dwStateMask;wchar szInfo[256];uint uVersion;wchar szInfoTitle[64];dword dwInfoFlags;" _
			 & "STRUCT;ulong;ushort;ushort;byte[8];ENDSTRUCT;handle hBalloonIcon")
	DllStructSetData($NOTIFYICONDATA, 1, DllStructGetSize($NOTIFYICONDATA))
	DllStructSetData($NOTIFYICONDATA, 2, Ptr(DllStructGetData($TRAYDATA, 1)))
	DllStructSetData($NOTIFYICONDATA, 3, DllStructGetData($TRAYDATA, 2))
	Local $ret = DllCall("shell32.dll", "bool", "Shell_NotifyIconW", "dword", 0x2, "struct*", $NOTIFYICONDATA) ; NIM_DELETE
	DllCall("user32.dll", "lresult", "SendMessageW", "hwnd", WinGetHandle("[CLASS:Shell_TrayWnd]"), "uint", 0x001A, "wparam", 0, "lparam", 0) ; WM_SETTINGCHANGE
	$NOTIFYICONDATA = 0
	If IsArray($ret) And $ret[0] Then
		Return 1
	Else
		Return 0
	EndIf
;~  Local $hWnd = _FindTrayToolbarWindow($iWin)
;~  If $hwnd = -1 Then Return -1
;~  Local $ret = DllCall("user32.dll", "lresult", "SendMessageW", "hwnd", $hWnd, "uint", $TB_DELETEBUTTON, "wparam", $index, "lparam", 0)
;~  If @error Or Not $ret[0] Then Return -1
;~  Return $ret[0]
EndFunc   ;==>_SysTrayIconRemove

;===============================================================================
;
; Function Name:    _FindTrayToolbarWindow($iWin = 1)
; Description:      Utility function for finding Toolbar window hwnd
; Parameter(s):     $iWin
;                   | 1         - ToolbarWindow32, Win2000+
;                   | 2         - NotifyIconOverflowWindow, Win7+
;
; Requirement(s):
; Return Value(s):  On Success - Returns Toolbar window hwnd
;                   On Failure - returns -1
;
; Author(s):        Tuape, Erik Pilsits
;
;===============================================================================
Func _FindTrayToolbarWindow($iWin = 1)
	Local $hWnd, $ret = -1
	If $iWin = 1 Then
		$hWnd = DllCall("user32.dll", "hwnd", "FindWindow", "str", "Shell_TrayWnd", "ptr", 0)
		If @error Then Return -1
		$hWnd = DllCall("user32.dll", "hwnd", "FindWindowEx", "hwnd", $hWnd[0], "hwnd", 0, "str", "TrayNotifyWnd", "ptr", 0)
		If @error Then Return -1
		If _OSVersion() <> "WIN_2000" Then
			$hWnd = DllCall("user32.dll", "hwnd", "FindWindowEx", "hwnd", $hWnd[0], "hwnd", 0, "str", "SysPager", "ptr", 0)
			If @error Then Return -1
		EndIf
		$hWnd = DllCall("user32.dll", "hwnd", "FindWindowEx", "hwnd", $hWnd[0], "hwnd", 0, "str", "ToolbarWindow32", "ptr", 0)
		If @error Then Return -1
		$ret = $hWnd[0]
	ElseIf $iWin = 2 Then
		; NotifyIconOverflowWindow for Windows 7
		$hWnd = DllCall("user32.dll", "hwnd", "FindWindow", "str", "NotifyIconOverflowWindow", "ptr", 0)
		If @error Then Return -1
		$hWnd = DllCall("user32.dll", "hwnd", "FindWindowEx", "hwnd", $hWnd[0], "hwnd", 0, "str", "ToolbarWindow32", "ptr", 0)
		If @error Then Return -1
		$ret = $hWnd[0]
	EndIf
	Return $ret
EndFunc   ;==>_FindTrayToolbarWindow

#cs
	Func RemoveGhostTrayIcons($IconTextPart)

	Local $iGhostCount = 0

	Local $hTrayVisible = ControlGetHandle('[Class:Shell_TrayWnd]', '', '[Class:ToolbarWindow32;Instance:1]')
	If @error Then
	SetLog("System Tray Not Found!", $COLOR_ERROR)
	Return SetError(1, @extended, -1)
	Else
	SetDebugLog("Checking system tray for ghost icons", $COLOR_SUCCESS)
	EndIf

	Local $hTrayHidden = ControlGetHandle('[Class:NotifyIconOverflowWindow]', '', '[Class:ToolbarWindow32;Instance:1]')
	If @error Then
	SetLog("Minor Nuisance, Hidden System Tray not found", $COLOR_WARNING)
	EndIf

	Local $iTrayVisibleCount = _GUICtrlToolbar_ButtonCount($hTrayVisible)
	SetDebugLog("Visible tray Count: " & $iTrayVisibleCount, $COLOR_DEBUG) ; Debug

	If $iTrayVisibleCount > 1 Then
	For $i = $iTrayVisibleCount - 1 To 0 Step -1 ; Loop through the icons and look for ghost with PID = -1
	$IconText = _GUICtrlToolbar_GetButtonText($hTrayVisible, $i)
	If ($IconTextPart <> "" And StringInStr($IconText, $IconTextPart)) Or $IconTextPart = $IconText Then
	$bResult = _GUICtrlToolbar_DeleteButton($hTrayVisible, $i)
	If @error Then
	SetDebugLog("$bResult = " & $bResult, $COLOR_DEBUG)
	ContinueLoop
	Else
	$iGhostCount += 1 ; Add to ghost count if removed
	EndIf
	EndIf
	Next
	EndIf

	Local $iTrayHiddenCount = _GUICtrlToolbar_ButtonCount($hTrayHidden)
	SetDebugLog("Hidden tray Count: " & $iTrayHiddenCount, $COLOR_DEBUG) ; Debug

	If $iTrayHiddenCount > 1 Then
	For $i = $iTrayHiddenCount - 1 To 0 Step -1 ; Loop through the icons and look for ghost with PID = -1
	$IconText = _GUICtrlToolbar_GetButtonText($hTrayHidden, $i)
	SetDebugLog("$IconText = " & $IconText, $COLOR_DEBUG)
	If ($IconTextPart <> "" And StringInStr($IconText, $IconTextPart)) Or $IconTextPart = $IconText Then
	$bResult = _GUICtrlToolbar_DeleteButton($hTrayHidden, $i)
	If @error Then
	SetDebugLog("$bResult = " & $bResult, $COLOR_DEBUG)
	ContinueLoop
	Else
	$iGhostCount += 1 ; Add to ghost count if removed
	EndIf
	EndIf
	Next
	EndIf

	If $iGhostCount > 0 And $g_bDebugSetlog Then SetLog("Removed " & $iGhostCount & " Ghost icon successfully", $COLOR_SUCCESS)

	EndFunc   ;==>RemoveGhostTrayIcons
#ce
