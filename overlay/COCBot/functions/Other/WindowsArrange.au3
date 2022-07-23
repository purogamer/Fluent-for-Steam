; #FUNCTION# ====================================================================================================================
; Name ..........: Windows Arrange
; Description ...: This function dispose the bot and bs adjacent
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Sardo (2015-06) (2015-09)
; Modified ......:
;
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func WindowsArrange($position, $offsetX = 0, $offsetY = 0)
	WinGetAndroidHandle()
	Local $AndroidPos = WinGetPos($g_hAndroidWindow)
	Local $BotPos = WinGetPos($g_hFrmBot)
	If IsArray($AndroidPos) And IsArray($BotPos) Then
		Local $hTimer = __TimerInit()
		WinSetState($g_hAndroidWindow, "", @SW_RESTORE)
		While IsArray($AndroidPos) And __TimerDiff($hTimer) < 3000 And $AndroidPos[0] < -30000 And $AndroidPos[1] < -30000
			$AndroidPos = WinGetPos($g_hAndroidWindow)
			If _Sleep($DELAYSLEEP) Then Return False
		WEnd
		Local $x = $offsetX
		Local $y = $offsetY
		Local $AndroidX = $AndroidPos[0]
		Local $AndroidY = $AndroidPos[1]
		Local $AndroidW = $AndroidPos[2]
		Local $AndroidH = $AndroidPos[3]
		Local $BotX = $BotPos[0]
		Local $BotY = $BotPos[1]
		Local $BotW = $BotPos[2]
		Local $BotH = $BotPos[3]
		If Number($AndroidX) > -30000 And Number($AndroidY) > -30000 Then
			Local $bAdjusted = False

			If $position = "EMBED" Then

				AndroidEmbed(True)
				If Not ($offsetX == "" Or $offsetY == "") Then
					$bAdjusted = $BotX <> $offsetX Or $BotY <> $offsetY
					If $bAdjusted = True Then WinMove($g_hFrmBot, "", $offsetX, $offsetY)
				EndIf

			Else
				If $g_bAndroidEmbedded = True Then
					; not supported!
					Return
				EndIf
				Switch $position
					Case "BS-BOT" ; position left Android, right adjacent BOT
						If $offsetX == "" Then
							$x = $AndroidX
							$offsetX = 0
						EndIf
						If $offsetY == "" Then
							$y = $AndroidY
							$offsetY = 0
						EndIf
						$bAdjusted = $AndroidX <> $x Or $AndroidY <> $y
						If $bAdjusted Then
							WinMove($g_hAndroidWindow, "", $x, $y)
							_Sleep($DELAYWINDOWSARRANGE1, True, False)
						EndIf
						$bAdjusted = $bAdjusted = True Or $BotX <> $AndroidW + $offsetX * 2 Or $BotY <> $y
						If $bAdjusted Then WinMove($g_hFrmBot, "", $x + $AndroidW + $offsetX, $y)
					Case "BOT-BS" ; position left BOT, right adjacent Android
						If $offsetX == "" Then
							$x = $BotX
							$offsetX = 0
						EndIf
						If $offsetY == "" Then
							$y = $BotY
							$offsetY = 0
						EndIf
						$bAdjusted = $BotX <> $x Or $BotY <> $y
						If $bAdjusted Then
							WinMove($g_hFrmBot, "", $x, $y)
							_Sleep($DELAYWINDOWSARRANGE1, True, False)
						EndIf
						$bAdjusted = $bAdjusted Or $AndroidX <> $x + $BotW + $offsetX Or $AndroidY <> $y
						If $bAdjusted Then WinMove($g_hAndroidWindow, "", $x + $BotW + $offsetX, $y)
					Case "SNAP-TR" ; position BOT top right of Android, do not move Android
						If $offsetX == "" Then $offsetX = 0
						If $offsetY == "" Then $offsetY = 0
						$bAdjusted = $BotX <> $AndroidX + $AndroidW + $offsetX Or $BotY <> $AndroidY + $offsetY
						If $bAdjusted Then WinMove($g_hFrmBot, "", $AndroidX + $AndroidW + $offsetX, $AndroidY + $offsetY)
					Case "SNAP-BR" ; position BOT botom right of BS, do not move Android
						If $offsetX == "" Then $offsetX = 0
						If $offsetY == "" Then $offsetY = 0
						$bAdjusted = $AndroidX <> $AndroidX + $AndroidW + $offsetX Or $AndroidY <> $AndroidY + ($AndroidH - $BotH) + $offsetY
						If $bAdjusted Then WinMove($g_hFrmBot, "", $AndroidX + $AndroidW + $offsetX, $AndroidY + ($AndroidH - $BotH) + $offsetY)
					Case "SNAP-TL" ; position BOT top left of Android, do not move Android
						If $offsetX == "" Then $offsetX = 0
						If $offsetY == "" Then $offsetY = 0
						$bAdjusted = $BotX <> $AndroidX - $BotW - $offsetX Or $BotY <> $AndroidY + $offsetY
						If $bAdjusted Then WinMove($g_hFrmBot, "", $AndroidX - $BotW - $offsetX, $AndroidY + $offsetY)
					Case "SNAP-BL" ; position BOT bottom left of Android, do not move Android
						If $offsetX == "" Then $offsetX = 0
						If $offsetY == "" Then $offsetY = 0
						$bAdjusted = $BotX <> $AndroidX - $BotW - $offsetX Or $BotY <> $AndroidY + ($AndroidH - $BotH) + $offsetY
						If $bAdjusted Then WinMove($g_hFrmBot, "", $AndroidX - $BotW - $offsetX, $AndroidY + ($AndroidH - $BotH) + $offsetY)
				EndSwitch
			EndIf
			If $bAdjusted = True Then
				SetDebugLog("WindowsArrange: " & $position & ", offsetX=" & $offsetX & ", offsetY=" & $offsetY & ", X=" & $x & ", Y=" & $y)
				_Sleep($DELAYWINDOWSARRANGE1, True, False)
			EndIf
		EndIf
	EndIf

EndFunc   ;==>WindowsArrange

Func DisposeWindows()
	updateBtnEmbed()
	; ensure bot window is visible
	Local $aPos = WinGetPos($g_hFrmBot)
	If IsArray($aPos) Then
		If _CheckWindowVisibility($g_hFrmBot, $aPos) Then
			SetDebugLog("Bot Window '" & $g_sAndroidTitle & "' not visible, moving to position: " & $aPos[0] & ", " & $aPos[1])
			WinMove($g_hFrmBot, "", $aPos[0], $aPos[1])
		EndIf
	EndIf

	CheckDpiAwareness() ; check if DPI is ok
	If $g_bAutoAlignEnable Then
		Switch $g_iAutoAlignPosition
			Case 0
				WindowsArrange("BS-BOT", $g_iAutoAlignOffsetX, $g_iAutoAlignOffsetY)
			Case 1
				WindowsArrange("BOT-BS", $g_iAutoAlignOffsetX, $g_iAutoAlignOffsetY)
			Case 2
				WindowsArrange("SNAP-TR", $g_iAutoAlignOffsetX, $g_iAutoAlignOffsetY)
			Case 3
				WindowsArrange("SNAP-TL", $g_iAutoAlignOffsetX, $g_iAutoAlignOffsetY)
			Case 4
				WindowsArrange("SNAP-BR", $g_iAutoAlignOffsetX, $g_iAutoAlignOffsetY)
			Case 5
				WindowsArrange("SNAP-BL", $g_iAutoAlignOffsetX, $g_iAutoAlignOffsetY)
			Case 6
				WindowsArrange("EMBED", $g_iAutoAlignOffsetX, $g_iAutoAlignOffsetY)
		EndSwitch
	EndIf
EndFunc   ;==>DisposeWindows

; WinMove2 resizes Window without triggering a change event in target process.
; Replacement for WinMove ( "title", "text", x, y [, width [, height [, speed]]] )
; Parameter [, speed] is not supported and is actually $hAfter!
Func WinMove2($WinTitle, $WinText, $x = -1, $y = -1, $w = -1, $h = -1, $hAfter = 0, $iFlags = 0, $bCheckAfterPos = True, $bIconCheck = True)
	;If $s <> 0 And $g_bDebugSetlog Then SetLog("WinMove2(" & $WinTitle & "," & $WinText & "," & $x & "," & $y & "," & $w & "," & $h & "," & $s & "): speed parameter '" & $s & "' is not supported!", $COLOR_ERROR);
	If $WinTitle = $g_hFrmBot And $g_iGuiMode = 0 Then Return $WinTitle
	Local $hWin = WinGetHandle($WinTitle, $WinText)
	If @error Then Return 0

	If $bIconCheck And _WinAPI_IsIconic($hWin) Then
		; Window minimized, restore first
		SetDebugLog("Window " & $WinTitle & (($WinTitle <> $hWin) ? "(" & $hWin & ")" : "") & " restored", $COLOR_ACTION)
		WinSetState($hWin, "", @SW_RESTORE)
	EndIf

	Local $NoMove = $x = -1 And $y = -1
	Local $NoResize = $w = -1 And $h = -1
	Local $NOZORDER = ($hAfter = 0 ? BitOR($SWP_NOZORDER, $SWP_NOOWNERZORDER) : 0)
	$bCheckAfterPos = $bCheckAfterPos And (Not $NoMove Or Not $NoResize)

	If Not $NoMove Or Not $NoResize Then
		Local $aPos = WinGetPos($hWin)

		If @error <> 0 Or Not IsArray($aPos) Then
			SetError(1, @extended, -1)
			Return 0
		EndIf
		Local $aPPos = WinGetClientPos(__WinAPI_GetParent($hWin))
		If IsArray($aPPos) Then
			; convert to relative
			$aPos[0] -= $aPPos[0]
			$aPos[1] -= $aPPos[1]
		EndIf

		If $x = -1 Or $y = -1 Or $w = -1 Or $h = -1 Then
			If $x = -1 Then $x = $aPos[0]
			If $y = -1 Then $y = $aPos[1]
			If $w = -1 Then $w = $aPos[2]
			If $h = -1 Then $h = $aPos[3]
		EndIf
		$NoMove = $NoMove Or ($x = $aPos[0] And $y = $aPos[1])
		$NoResize = $NoResize Or ($w = $aPos[2] And $h = $aPos[3])
	EndIf

	;SetDebugLog("Window " & $WinTitle & "(" & $hWin & "): " & ($NoResize ? "no resize" : "resize to " & $w & " x " & $h) & ($NoMove ? ", no move" : ", move to " & $x & "," & $y), $COLOR_INFO);
	If $g_bWinMove2_Compatible And $NoResize = False Then
		WinMove($WinTitle, $WinText, $x, $y, $w, $h)
		_WinAPI_SetWindowPos($hWin, $hAfter, 0, 0, 0, 0, BitOR($SWP_NOSIZE, $SWP_NOMOVE, $SWP_NOREPOSITION, $SWP_NOACTIVATE, $SWP_NOSENDCHANGING, $NOZORDER, $iFlags)) ; resize window without sending changing message to window
	Else
		_WinAPI_SetWindowPos($hWin, $hAfter, $x, $y, $w, $h, BitOR(($NoMove ? BitOR($SWP_NOMOVE, $SWP_NOREPOSITION) : 0), ($NoResize ? $SWP_NOSIZE : 0), $SWP_NOACTIVATE, $SWP_NOSENDCHANGING, $NOZORDER, $iFlags)) ; resize window without sending changing message to window
	EndIf

	; check width and height if it got changed...
	If $bCheckAfterPos Then
		$aPos = WinGetPos($hWin)
		If @error <> 0 Or Not IsArray($aPos) Then
			SetError(1, @extended, -1)
			Return 0
		EndIf
		Local $aPPos = WinGetClientPos(__WinAPI_GetParent($hWin))
		If IsArray($aPPos) Then
			; convert to relative
			$aPos[0] -= $aPPos[0]
			$aPos[1] -= $aPPos[1]
		EndIf
		If $x <> $aPos[0] Or $y <> $aPos[1] Or $w <> $aPos[2] Or $h <> $aPos[3] Then
			SetDebugLog("Window " & $WinTitle & (($WinTitle <> $hWin) ? "(" & $hWin & ")" : "") & " got resized/moved again to " & $aPos[0] & "/" & $aPos[1] & " " & $aPos[2] & "x" & $aPos[3] & ", restore now " & $x & "/" & $y & " " & $w & "x" & $h, $COLOR_ACTION)
			WinMove($hWin, "", $x, $y, $w, $h - 1) ; resize window WITH sending changing message to window
			If $g_bWinMove2_Compatible Then
				WinMove($hWin, "", $x, $y, $w, $h)
				_WinAPI_SetWindowPos($hWin, $hAfter, 0, 0, 0, 0, BitOR($SWP_NOSIZE, $SWP_NOMOVE, $SWP_NOREPOSITION, $SWP_NOACTIVATE, $SWP_NOSENDCHANGING, $NOZORDER, $iFlags)) ; resize window without sending changing message to window
			Else
				_WinAPI_SetWindowPos($hWin, $hAfter, $x, $y, $w, $h, BitOR($SWP_NOMOVE, $SWP_NOREPOSITION, $SWP_NOACTIVATE, $SWP_NOSENDCHANGING, $NOZORDER, $iFlags)) ; resize window without sending changing message to window
			EndIf
		EndIf
	EndIf

	Return $hWin
EndFunc   ;==>WinMove2

Func ControlGetHandle2($title, $text, $controlID, $iMinWidth = Default, $iMinHeight = Default)
	For $sClass In StringSplit($controlID, "|", $STR_NOCOUNT)
		Local $hCtrl = ControlGetHandle($title, $text, $sClass)
		If $hCtrl Then
			If $iMinWidth <> Default Or $iMinHeight <> Default Then
				; check for min width or height
				Local $aPos = WinGetPos($hCtrl)
				If UBound($aPos) > 3 Then
					If ($iMinWidth = Default Or $aPos[2] >= $iMinWidth) And ($iMinHeight = Default Or $aPos[2] >= $iMinHeight) Then
						$g_sControlGetHandle2_Classname = $sClass
						Return $hCtrl
					EndIf
				Else
					SetDebugLog("ControlGetHandle2 cannot validate window dimension")
					$g_sControlGetHandle2_Classname = $sClass
					Return $hCtrl
				EndIf
			Else
				$g_sControlGetHandle2_Classname = $sClass
				Return $hCtrl
			EndIf
		EndIf
	Next
	$g_sControlGetHandle2_Classname = ""
	Return SetError(1, 0, 0)
EndFunc

Func WinGetClientPos($hWin, $x = 0, $y = 0)
	Local $tPoint = DllStructCreate("int x;int y")
	DllStructSetData($tPoint, "x", $x)
	DllStructSetData($tPoint, "y", $y)
	_WinAPI_ClientToScreen($hWin, $tPoint)
	If @error Then Return SetError(1, 0, 0)
	Local $a[2] = [DllStructGetData($tPoint, "x"), DllStructGetData($tPoint, "y")]
	$tPoint = 0
	Return $a
EndFunc   ;==>WinGetClientPos

Func WinGetPos2($title, $text = "")
	Local $aPos = 0
	If $title = $g_hFrmBot And $g_iGuiMode = 0 Then Return $aPos
	If IsHWnd($title) = 0 Then $title = WinGetHandle($title, $text)
	While IsHWnd($title) And (IsArray($aPos) = 0 Or $aPos[2] < 200)
		If _WinAPI_IsIconic($title) Then WinSetState($title, "", @SW_RESTORE)
		If _WinAPI_IsIconic($title) = False Then $aPos = WinGetPos($title)
	WEnd
	Return $aPos
EndFunc   ;==>WinGetPos2

Func ControlGetPos2($title, $text, $controlID)
	Local $aPos = 0
	If $title = $g_hFrmBot And $g_iGuiMode = 0 Then Return $aPos
	If IsHWnd($title) = 0 Then $title = WinGetHandle($title, $text)
	While IsHWnd($title) And (IsArray($aPos) = 0 Or $aPos[2] < 200)
		If _WinAPI_IsIconic($title) Then WinSetState($title, "", @SW_RESTORE)
		If _WinAPI_IsIconic($title) = False Then $aPos = ControlGetPos($title, $text, $controlID)
	WEnd
	Return $aPos
EndFunc   ;==>ControlGetPos2

Func ControlGetRelativePos($title, $text,  $controlID)
	Local $a = ControlGetPos($title, $text,  $controlID)
	If UBound($a) < 4 Then Return SetError(1)
	Local $hCtrl = ((IsHWnd($controlID)) ? ($controlID) : (GUICtrlGetHandle($controlID)))
	;SetDebugLog("ControlGetRelativePos ControlID " & $controlID & " handle " & $hCtrl & ": " & $a[0] & ", " & $a[1] & ", " & $a[2] & ", " & $a[3])
	Local $hWinParent = __WinAPI_GetParent($hCtrl)
	Local $aParent = ControlGetPos($title, "", $hWinParent)
	;SetDebugLog("ControlGetRelativePos Parent handle " & $hWinParent & ": " & $aParent[0] & ", " & $aParent[1] & ", " & $aParent[2] & ", " & $aParent[3])
	If IsArray($aParent) = 1 Then
		$a[0] -= $aParent[0]
		$a[1] -= $aParent[1]
	EndIf
	Return $a
EndFunc   ;==>ControlGetRelativePos

Func __WinAPI_GetParent($hWin, $iMillis = 3000)
	If $hWin = 0 Then Return 0
	Local $hTimer = __TimerInit()
	Local $bPostSomething = True
	Local $hWinParent = 0
	Do
		$hWinParent = _WinAPI_GetParent($hWin)
		If IsPtr($hWinParent) = 0 Then
			If $bPostSomething And __TimerDiff($hTimer) > $iMillis / 2 Then
				$bPostSomething = False
				;_WinAPI_UpdateWindow($hWin)
			EndIf
			Sleep(10)
		EndIf
	Until IsPtr($hWinParent) = 1 Or __TimerDiff($hTimer) > $iMillis
	;SetDebugLog("__WinAPI_GetParent: " & $hWinParent & " found from " & $hWin & " in " & __TimerDiff($hTimer) & " ms")
	Return $hWinParent
EndFunc  ;==>__WinAPI_GetParent

Func WinIsChildOf($hWinChild, $hWinParent)
	While $hWinChild <> 0
		If $hWinChild = $hWinParent Then Return True
		$hWinChild = _WinAPI_GetParent($hWinChild)
	WEnd
	Return False
EndFunc   ;==>WinIsChildOf

; #FUNCTION# ====================================================================================================================
; Name ..........: _CheckWindowVisibility
; Description ...: Checks the current position of the window to make sure it is on the visible screen area
; Syntax ........: _CheckWindowVisibility($hWnd, $p)
; Parameters ....: In $hWnd  - window handle
;                  In/Out $p - if window is not visible, this function will move it to be visible, and return the new
;                              coordinates in this parameter
; Return values .: True if window was moved, False otherwise
; Author ........: CodeSlinger69
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func _CheckWindowVisibility(Const $hWnd, ByRef $p)
   ; If window is minimized then do nothing
   If $p[0] < -30000 And $p[1] < -30000 Then Return False

   ; See if the window intersects with a monitor
   Local $monitorHandle = _MonitorFromWindow($hWnd, 0)

   If $monitorHandle <> 0 Then
	  ;ConsoleWrite("Windows is visible" & @CRLF)
	  Return False
   EndIf

   ; Get handle to closest monitor
   $monitorHandle = _MonitorFromWindow($hWnd, 2)

   ; Get info for closest monitor, and move window to top left
   Local $monitorInfo = _MonitorGetInfo($monitorHandle)
   If UBound($monitorInfo) > 1 Then
	   $p[0] = $monitorInfo[0]
	   $p[1] = $monitorInfo[1]
   EndIf

   Return True
EndFunc

; ===================================================================================================================
; Func _GraphicsCreateDC($sDriver="DISPLAY",$sDevice=0,$pInitData=0)
;
; Function to create a Device Context. With default parameters, it will create a DC covering ALL monitors, rather
;    than getting only the default monitor with GetDC(0)
;    *NOTE: When done with the DC, must use DeleteDC on the returned DC (whereas GetDC uses ReleaseDC)
;
; Author: Ascend4nt
; ===================================================================================================================
Func _GraphicsCreateDC($sDriver="DISPLAY",$sDevice=0,$pInitData=0)
    If Not IsString($sDriver) Then Return SetError(1,0,False)
    Local $aRet,$sDeviceType
    If $sDevice="" Or Not IsString($sDevice) Then
        $sDeviceType="ptr"
        $sDevice=0
    Else
        $sDeviceType="wstr"
    EndIf
    $aRet=DllCall('gdi32.dll',"handle","CreateDCW","wstr",$sDriver,$sDeviceType,$sDevice,"ptr",0,"ptr",$pInitData)
    If @error Then Return SetError(2,@error,0)
    If $aRet[0]=0 Then Return SetError(3,0,0)
    Return $aRet[0]
 EndFunc

; ==========================================================================================================================
; Func _MonitorGetInfo($hMonitor,$hMonitorDC=0)
;
; Gets information about a monitor (given a monitor handle).
;
; $hMonitor = Handle to Monitor
; $hMonitorDC = Optional Monitor DC
;
; Returns:
;    Success: 10-element array, with @error=0:
;        $array[0]  = Monitor  upper-left corner X coordinate (this rect is same as full-screen size)
;        $array[1]  = Monitor  upper-left corner Y coordinate
;        $array[2]  = Monitor lower-right corner X coordinate
;        $array[3]  = Monitor lower-right corner Y coordinate
;        $array[4]  = Monitor Work Area  upper-left corner X coordinate (this rect is same as maximized size)
;        $array[5]  = Monitor Work Area  upper-left corner Y coordinate
;        $array[6]  = Monitor Work Area lower-right corner X coordinate
;        $array[7]  = Monitor Work Area lower-right corner Y coordinate
;        $array[8]  = Primary monitor boolean (0 = not, 1 = is)
;        $array[9]  = Monitor Or Display Device Name (usually '.DISPLAY#' where # starts at 1)
;        $array[10] = Bits Per Pixel
;        $array[11] = Vertical Refresh Rate
;    Failure: '' with @error set:
;        @error = 1 = invalid parameter
;        @error = 2 = DLLCall() error, with @extended set to DLLCall() error code (see AutoIt Help)
;        @error = 3 = API call failed
;
; Author: Ascend4nt
; ==========================================================================================================================
Func _MonitorGetInfo($hMonitor,$hMonitorDC=0)
    If Not IsPtr($hMonitor) Or $hMonitor=0 Then Return SetError(1,0,'')

    ; cbSize, rcMonitor (virtual rect of monitor), rcWork (maximized state of window [minus taskbar, sidebar etc]), dwFlags
    Local $aRet, $stMonInfoEx=DllStructCreate('dword;long[8];dword;wchar[32]'), $bMonDCCreated=0
    DllStructSetData($stMonInfoEx,1,DllStructGetSize($stMonInfoEx))        ; set cbSize
    $aRet=DllCall('user32.dll','bool','GetMonitorInfoW','handle',$hMonitor,'ptr',DllStructGetPtr($stMonInfoEx))
    If @error Then
	   $stMonInfoEx = 0
	   Return SetError(2,0,'')
    EndIf

    If Not $aRet[0] Then
	   $stMonInfoEx = 0
	   Return SetError(3,0,'')
    EndIf

    Dim $aRet[12]
    ; Both RECT's
    For $i=0 To 7
        $aRet[$i]=DllStructGetData($stMonInfoEx,2,$i+1)
    Next
    ; 0 or 1 for Primary Monitor [MONITORINFOF_PRIMARY = 1]
    $aRet[8]=DllStructGetData($stMonInfoEx,3)
    ; Device String of type '.DISPLAY1' etc
    $aRet[9]=DllStructGetData($stMonInfoEx,4)
    If $hMonitorDC=0 Then
        $hMonitorDC=_GraphicsCreateDC($aRet[9],$aRet[9])
        $bMonDCCreated=1
    EndIf
    $aRet[10]=_WinAPI_GetDeviceCaps($hMonitorDC,12)    ; Bits-Per-Pixel
    $aRet[11]=_WinAPI_GetDeviceCaps($hMonitorDC,116)    ; Vertical Refresh Rate (Hz)
    If $bMonDCCreated Then _WinAPI_DeleteDC($hMonitorDC)
;~     ConsoleWrite("BitsPerPixel="&$aRet[10]&", Refresh Rate="&$aRet[11]&" Hz"&@CRLF)

	$stMonInfoEx = 0

    Return $aRet
EndFunc

; ==========================================================================================================================
; Func _MonitorFromWindow($hWnd,$iFlags=2)
;
; Retrieves a handle to the display monitor that has the largest area of intersection with the bounding rectangle of a
; specified window.
;
; $iFlags: 0-2:  Determines the function's return value if the window does not intersect any display monitor.
;    MONITOR_DEFAULTTONULL (0)
;    MONITOR_DEFAULTTOPRIMARY (1)
;    MONITOR_DEFAULTTONEAREST (2)
;
; Author: Ascend4nt
; ==========================================================================================================================
Func _MonitorFromWindow($hWnd, $iFlags=2)
    If Not IsHWnd($hWnd) Or $iFlags<0 Or $iFlags>2 Then Return SetError(1,0,0)

    Local $aRet=DllCall('user32.dll', 'handle', 'MonitorFromWindow', 'hwnd', $hWnd, 'dword', $iFlags)
    If @error Then Return SetError(2,@error,0)

    If $aRet[0]=0 Then Return SetError(3,0,0)

    Return $aRet[0]
EndFunc
