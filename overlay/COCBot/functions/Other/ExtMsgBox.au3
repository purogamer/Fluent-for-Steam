#include-once

; #INDEX# ============================================================================================================
; Title .........: ExtMsgBox
; AutoIt Version : v3.2.12.1 or higher
; Language ......: English
; Description ...: Generates user defined message boxes centred on a GUI, on screen or at defined coordinates
;
; Author(s) .....: Melba23, based on some original code by photonbuddy & YellowLab, and KaFu (default font data)
; Link ..........: https://www.autoitscript.com/forum/topic/109096-extended-message-box-bugfix-version-9-aug-16/
;
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ====================================================================================================================

;#AutoIt3Wrapper_au3check_parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6 -w- 7

; #INCLUDES# =========================================================================================================
#include "StringSize.au3"

; #GLOBAL CONSTANTS# =================================================================================================
Global Const $EMB_ICONSTOP = 16 ; Stop-sign icon
Global Const $EMB_ICONQUERY = 32 ; Question-mark icon
Global Const $EMB_ICONEXCLAM = 48 ; Exclamation-point icon
Global Const $EMB_ICONINFO = 64 ; Icon consisting of an 'i' in a circle

; #GLOBAL VARIABLES# =================================================================================================

Global $g_aEMB_Settings[13]
; [0] = Style			[6]  = Max Width
; [1] = Justification	[7]  = Absolute Width
; [2] = Back Colour		[8]  = Default Back Colour
; [3] = Text Colour		[9]  = Default Text Colour
; [4] = Font Size		[10] = Default Font Size
; [5] = Font Name		[11] = Default Font Name
;                       [12] = Title bar reduction

; Default settings
; Font
Global $g_aEMB_TempArray = __EMB_GetDefaultFont()
$g_aEMB_Settings[10] = $g_aEMB_TempArray[0]
$g_aEMB_Settings[11] = $g_aEMB_TempArray[1]
; Colours
$g_aEMB_TempArray = DllCall("User32.dll", "int", "GetSysColor", "int", 15) ; $COLOR_3DFACE
$g_aEMB_Settings[8] = BitAND(BitShift(String(Binary($g_aEMB_TempArray[0])), 8), 0xFFFFFF)
$g_aEMB_TempArray = DllCall("User32.dll", "int", "GetSysColor", "int", 8) ; $COLOR_WINDOWTEXT
$g_aEMB_Settings[9] = BitAND(BitShift(String(Binary($g_aEMB_TempArray[0])), 8), 0xFFFFFF)
; Title bar width reduction by icon and [X] button in various themes
$g_aEMB_TempArray = DllCall("user32.dll", "int", "GetSystemMetrics", "int", 11) ; Title bar icon width
$g_aEMB_Settings[12] = $g_aEMB_TempArray[0]
$g_aEMB_TempArray = DllCall("user32.dll", "int", "GetSystemMetrics", "int", 30) ; Title bar button width
$g_aEMB_Settings[12] += ( ($g_aEMB_TempArray[0] < 30) ? ($g_aEMB_TempArray[0] * 3) : ($g_aEMB_TempArray[0]) ) ; Compensate for small buttons in some themes
$g_aEMB_TempArray = 0
$g_aEMB_TempArray = DllCall("dwmapi.dll", "uint", "DwmIsCompositionEnabled", "int*", $g_aEMB_TempArray) ; Check for Aero enabled
If Not @error And $g_aEMB_TempArray[1] = True Then
	$g_aEMB_TempArray = DllCall("user32.dll", "int", "GetSystemMetrics", "int", 7) ; GUI button frame width
	$g_aEMB_Settings[12] += ($g_aEMB_TempArray[0] * 4) ; Add frames to compensate for incorrect Aero return
EndIf
$g_aEMB_TempArray = 0

; Set current settings
$g_aEMB_Settings[0] = 0
$g_aEMB_Settings[1] = 0
$g_aEMB_Settings[2] = $g_aEMB_Settings[8]
$g_aEMB_Settings[3] = $g_aEMB_Settings[9]
$g_aEMB_Settings[4] = $g_aEMB_Settings[10]
$g_aEMB_Settings[5] = $g_aEMB_Settings[11]
$g_aEMB_Settings[6] = 370
$g_aEMB_Settings[7] = 500

; #CURRENT# ==========================================================================================================
; _ExtMsgBoxSet: Sets the GUI style, justification, colours, font and max width for subsequent _ExtMsgBox function calls
; _ExtMsgBox:    Generates user defined message boxes centred on a GUI, on screen or at defined coordinates
; ====================================================================================================================

; #INTERNAL_USE_ONLY#=================================================================================================
; __EMB_GetDefaultFont: Determines Windows default MsgBox font size and name
; ====================================================================================================================

; #FUNCTION# =========================================================================================================
; Name...........: _ExtMsgBoxSet
; Description ...: Sets the GUI style, justification, colours, font and max width for subsequent _ExtMsgBox function calls
; Syntax.........: _ExtMsgBoxSet($iStyle, $iJust, [$iBkCol, [$iCol, [$sFont_Size, [$iFont_Name, [$iWidth, [ $iWidth_Abs]]]]]])
; Parameters ....: $iStyle      -> 0 (Default) - Taskbar Button, TOPMOST, button in user font, no tab expansion,
;                                      no checkbox, titlebar icon, active closure [X] and SysMenu close
;                                  Combine following to change:
;                                      1   = No Taskbar Button
;                                      2   = TOPMOST Style not set
;                                      4   = Buttons use default font
;                                      8   = Expand Tabs to ensure adequate sizing of GUI
;                                      16  = "Do not display again" checkbox
;                                      32  = Show no icon on title bar
;                                      64  = Disable EMB closure [X] and SysMenu Close
;                   $iJust      -> 0 = Left justified (Default), 1 = Centred , 2 = Right justified
;                                      + 4 = Centred single button.  Note: multiple buttons are always centred
;                                      ($SS_LEFT, $SS_CENTER, $SS_RIGHT can also be used)
;                   $iBkCol		-> The colour for the message box background.  Default = system colour
;                   $iCol		-> The colour for the message box text.  Default = system colour
;                   $iFont_Size -> The font size in points to use for the message box. Default = system font size
;                   $sFont_Name -> The font to use for the message box. Default = system font
;                   $iWidth     -> Normal max width for EMB.   Default/min = 370 pixels - max = @DesktopWidth - 20
;                   $iWidth_Abs -> Absolute max width for EMB. Default/min = 370 pixels - max = @DesktopWidth - 20
;                                      EMB will expand to this value to accommodate long unbroken character strings
;                                      Forced to $iWidth value if less
; Requirement(s).: v3.2.12.1 or higher
; Return values .: Success - Returns 1
;                  Failure - Returns 0 and sets @error to 1 with @extended set to incorrect parameter index number
; Remarks .......; Setting any parameter to -1 leaves the current value unchanged
;                  Setting the $iStyle parameter to 'Default' resets ALL parameters to default values <<<<<<<<<<<<<<<<<<<<<<<
;                  Setting any other parameter to "Default" only resets that parameter
; Author ........: Melba23
; Example........; Yes
;=====================================================================================================================
Func _ExtMsgBoxSet($iStyle = -1, $iJust = -1, $iBkCol = -1, $iCol = -1, $iFont_Size = -1, $sFont_Name = -1, $iWidth = -1, $iWidth_Abs = -1)

	; Set global EMB variables to required values
	Switch $iStyle
		Case Default
			$g_aEMB_Settings[0] = 0
			$g_aEMB_Settings[1] = 0
			$g_aEMB_Settings[2] = $g_aEMB_Settings[8]
			$g_aEMB_Settings[3] = $g_aEMB_Settings[9]
			$g_aEMB_Settings[5] = $g_aEMB_Settings[11]
			$g_aEMB_Settings[4] = $g_aEMB_Settings[10]
			$g_aEMB_Settings[6] = 370
			$g_aEMB_Settings[7] = 370
			Return
		Case -1
			; Do nothing
		Case 0 To 127
			$g_aEMB_Settings[0] = Int($iStyle)
		Case Else
			Return SetError(1, 1, 0)
	EndSwitch

	Switch $iJust
		Case Default
			$g_aEMB_Settings[1] = 0
		Case -1
			; Do nothing
		Case 0, 1, 2, 4, 5, 6
			$g_aEMB_Settings[1] = $iJust
		Case Else
			Return SetError(1, 2, 0)
	EndSwitch

	Switch $iBkCol
		Case Default
			$g_aEMB_Settings[2] = $g_aEMB_Settings[8]
		Case -1
			; Do nothing
		Case 0 To 0xFFFFFF
			$g_aEMB_Settings[2] = Int($iBkCol)
		Case Else
			Return SetError(1, 3, 0)
	EndSwitch

	Switch $iCol
		Case Default
			$g_aEMB_Settings[3] = $g_aEMB_Settings[9]
		Case -1
			; Do nothing
		Case 0 To 0xFFFFFF
			$g_aEMB_Settings[3] = Int($iCol)
		Case Else
			Return SetError(1, 4, 0)
	EndSwitch

	Switch $iFont_Size
		Case Default
			$g_aEMB_Settings[4] = $g_aEMB_Settings[10]
		Case -1
			; Do nothing
		Case 8 To 72
			$g_aEMB_Settings[4] = Int($iFont_Size)
		Case Else
			Return SetError(1, 5, 0)
	EndSwitch

	Switch $sFont_Name
		Case Default
			$g_aEMB_Settings[5] = $g_aEMB_Settings[11]
		Case -1
			; Do nothing
		Case Else
			If IsString($sFont_Name) Then
				$g_aEMB_Settings[5] = $sFont_Name
			Else
				Return SetError(1, 6, 0)
			EndIf
	EndSwitch

	Switch $iWidth
		Case Default
			$g_aEMB_Settings[6] = 370
		Case -1
			; Do nothing
		Case 370 To @DesktopWidth - 20
			$g_aEMB_Settings[6] = Int($iWidth)
		Case Else
			Return SetError(1, 7, 0)
	EndSwitch

	Switch $iWidth_Abs
		Case Default
			$g_aEMB_Settings[7] = 370
		Case -1
			; Do nothing
		Case 370 To @DesktopWidth - 20
			$g_aEMB_Settings[7] = Int($iWidth_Abs)
		Case Else
			Return SetError(1, 8, 0)
	EndSwitch

	; Check absolute width is at least max width
	If $g_aEMB_Settings[7] < $g_aEMB_Settings[6] Then
		$g_aEMB_Settings[7] = $g_aEMB_Settings[6]
	EndIf

	Return 1

EndFunc   ;==>_ExtMsgBoxSet

; #FUNCTION# =========================================================================================================
; Name...........: _ExtMsgBox
; Description ...: Generates user defined message boxes centred on a GUI, the desktop, or at defined coordinates
; Syntax.........: _ExtMsgBox ($vIcon, $vButton, $sTitle, $sText, [$iTimeout, [$hWin, [$iVPos, [$bMain = True[]]])
; Parameters ....: $vIcon   -> Icon to use:
;                                      0   - No icon
;                                      8   - UAC
;                                      16  - Stop         )
;                                      32  - Query        ) or equivalent $MB/$EMB_ICON constant
;                                      48  - Exclamation  )
;                                      64  - Information  )
;                                      128 - Countdown digits if $iTimeout set
;                                      Any other numeric value returns Error 1
;                                   Full path and name of exe - main exe icon displayed
;                                   Full path and name of icon - icon displayed
;                   $vButton  -> Button text separated with "|" character. " " = no buttons.
;                                      An ampersand (&) before the text indicates the default button.
;                                      Two focus ampersands returns Error 2. A single button is always default
;                                      Pressing Enter or Space fires default button
;                                      Can also use $MB_ button numeric constants: 0 = "OK", 1 = "&OK|Cancel",
;                                      2 = "&Abort|Retry|Ignore", 3 = "&Yes|No|Cancel", 4 = "&Yes|No", 5 = "&Retry|Cancel",
;                                      6 = "&Cancel|Try Again|Continue".  Other values returns Error 3
;                                      Default max width of 370 gives 1-4 buttons @ width 80, 5 @ width 60, 6 @ width 50
;                                      Min button width set at 50, so unless defaults changed 7 buttons returns Error 4
;                   $sTitle   -> The title of the message box.
;                                      Procrustean truncation if too long to fit
;                   $sText    -> The text to be displayed. Long lines will wrap. The box depth is adjusted to fit.
;                                      If unbroken character strings in $sText too long for set max width,
;                                      EMB expands to set absolute width. Error 6 if still not able to fit
;                   $iTimeout -> Timeout delay before EMB closes. 0 = no timeout (Default).
;                                      If no buttons and no timeout set, delay automatically set to 5
;                   $hWin     -> Handle of the GUI in which EMB is centred
;                                      If GUI  hidden or no handle passed - EMB centred in desktop (Default)
;                                      If not valid window handle, interpreted as horizontal coordinate for EMB location
;                   $iVPos    -> Vertical coordinate for EMB location
;                                      Only valid if $hWin parameter interpreted as horizontal coordinate (Default = 0)
;                   $bMain    -> True (default) = Adjust dialog position to ensure dialog positioned on main screen
;                                      False = Dialog positioned at defined coords
; Requirement(s).: v3.2.12.1 or higher
; Return values .: Success:	Returns 1-based index of the button pressed, counting from the LEFT.
;                           Returns 0 if closed by a "CloseGUI" event (i.e. click [X] or press Escape)
;                           Returns 9 if timed out
;                           If "Not again" checkbox is present and checked, return value is negated
;                  Failure:	Returns -1 and sets @error as follows:
;                               1 - Icon error
;                               2 - Multiple default button error
;                               3 - Button constant error
;                               4 - Too many buttons to fit in max available EMB width
;                               5 - Button text too long for max available button width
;                               6 - StringSize error
;                               7 - GUI creation error
; Remarks .......; If $bMain set EMB adjusted to appear on main screen closest to required position
; Author ........: Melba23, based on some original code by photonbuddy & YellowLab
; Example........; Yes
;=====================================================================================================================
; CS69 Jan 2018 - default $hWin parameter to $g_hFrmBot so it doesn't have to be set everytime this function is called
Func _ExtMsgBox($vIcon, $vButton, $sTitle, $sText, $iTimeOut = 0, $hWin = $g_hFrmBot, $iVPos = 0, $bMain = True)

	; Set default sizes for message box
	Local $iMsg_Width_Max = $g_aEMB_Settings[6], $iMsg_Width_Min = 150, $iMsg_Width_Abs = $g_aEMB_Settings[7]
	Local $iMsg_Height_Min = 100
	Local $iButton_Width_Def = 80, $iButton_Width_Min = 50

	; Declare local variables
	Local $iParent_Win = 0, $fCountdown = False, $cCheckbox = 0, $aLabel_Size, $aRet, $iRet_Value, $iHpos
	Local $sButton_Text, $iButton_Width, $iButton_Xpos

	; Validate timeout value
	$iTimeOut = Int(Number($iTimeOut))
	; Set automatic timeout if no buttons and no timeout set
	If $vButton == " " And $iTimeOut = 0 Then
		$iTimeOut = 5
	EndIf

	; Check for icon
	Local $iIcon_Style = 0
	Local $iIcon_Reduction = 50
	Local $sDLL = "user32.dll"
	If StringIsDigit($vIcon) Then
		Switch $vIcon
			Case 0
				$iIcon_Reduction = 0
			Case 8
				$sDLL = "imageres.dll"
				$iIcon_Style = 78
			Case 16 ; Stop
				$iIcon_Style = -4
			Case 32 ; Query
				$iIcon_Style = -3
			Case 48 ; Exclam
				$iIcon_Style = -2
			Case 64 ; Info
				$iIcon_Style = -5
			Case 128 ; Countdown
				If $iTimeOut > 0 Then
					$fCountdown = True
				Else
					ContinueCase
				EndIf
			Case Else
				Return SetError(1, 0, -1)
		EndSwitch
	Else
		$sDLL = $vIcon
		$iIcon_Style = 0
	EndIf

	; Check if two buttons are seeking focus
	StringRegExpReplace($vButton, "((?<!&)&)(?!&)", "*")
	If @extended > 1 Then
		Return SetError(2, 0, -1)
	EndIf

	; Check if using constants or text
	If IsNumber($vButton) Then
		Switch $vButton
			Case 0
				$vButton = "OK"
			Case 1
				$vButton = "&OK|Cancel"
			Case 2
				$vButton = "&Abort|Retry|Ignore"
			Case 3
				$vButton = "&Yes|No|Cancel"
			Case 4
				$vButton = "&Yes|No"
			Case 5
				$vButton = "&Retry|Cancel"
			Case 6
				$vButton = "&Cancel|Try Again|Continue"
			Case Else
				Return SetError(3, 0, -1)
		EndSwitch
	EndIf

	; Set default values
	Local $aButton_Text[1] = [0]
	Local $iButton_Width_Req = 0
	; Get required button size
	If $vButton <> " " Then
		; Split button text into individual strings
		$aButton_Text = StringSplit($vButton, "|")

		; Get absolute available width for each button
		Local $iButton_Width_Abs = Floor((($iMsg_Width_Max - 10) / $aButton_Text[0]) - 10)
		; Error if below min button size
		If $iButton_Width_Abs < $iButton_Width_Min Then
			Return SetError(4, 0, -1)
		EndIf
		; Determine required size of buttons to fit text
		Local $iButton_Width_Text = 0
		; Loop through button text
		For $i = 1 To $aButton_Text[0]
			; Remove a possible leading &
			$sButton_Text = StringRegExpReplace($aButton_Text[$i], "^&?(.*)$", "$1")
			; Check on font to use
			If BitAND($g_aEMB_Settings[0], 4) Then
				$aRet = _StringSize($sButton_Text, $g_aEMB_Settings[10], Default, Default, $g_aEMB_Settings[11])
			Else
				$aRet = _StringSize($sButton_Text, $g_aEMB_Settings[4], Default, Default, $g_aEMB_Settings[5])
			EndIf
			If IsArray($aRet) And $aRet[2] + 10 > $iButton_Width_Text Then
				; Find max button width required for text
				$iButton_Width_Text = $aRet[2] + 10
			EndIf
		Next
		; Error if text would make required button width > absolute available
		If $iButton_Width_Text > $iButton_Width_Abs Then
			Return SetError(5, 0, -1)
		EndIf
		; Determine button size to use - assume default
		$iButton_Width = $iButton_Width_Def
		; If text requires wider then default
		If $iButton_Width_Text > $iButton_Width_Def Then
			; Increase - cannot be > absolute
			$iButton_Width = $iButton_Width_Text
		EndIf
		; If absolute < default
		If $iButton_Width_Abs < $iButton_Width_Def Then
			; If text > min (text must be < abs)
			If $iButton_Width_Text > $iButton_Width_Min Then
				; Set text width
				$iButton_Width = $iButton_Width_Text
			Else
				; Set min width
				$iButton_Width = $iButton_Width_Min
			EndIf
		EndIf
		; Determine GUI width required for all buttons at this width
		$iButton_Width_Req = (($iButton_Width + 10) * $aButton_Text[0]) + 10
	EndIf

	; Set tab expansion flag if required
	Local $iExpTab = Default
	If BitAND($g_aEMB_Settings[0], 8) Then
		$iExpTab = 1
	EndIf

	; Get message label size
	While 1
		Local $aLabel_Pos = _StringSize($sText, $g_aEMB_Settings[4], Default, $iExpTab, $g_aEMB_Settings[5], $iMsg_Width_Max - 20 - $iIcon_Reduction)
		If @error Then
			If $iMsg_Width_Max >= $iMsg_Width_Abs Then
				Return SetError(6, 0, -1)
			Else
				$iMsg_Width_Max += 10
			EndIf
		Else
			ExitLoop
		EndIf
	WEnd
	; Reset text to wrapped version
	$sText = $aLabel_Pos[0]
	; Set label size
	Local $iLabel_Width = $aLabel_Pos[2]
	Local $iLabel_Height = $aLabel_Pos[3]

	; Set GUI size
	Local $iMsg_Width = $iLabel_Width + 20 + $iIcon_Reduction
	; Increase width to fit buttons if needed
	If $iButton_Width_Req > $iMsg_Width Then $iMsg_Width = $iButton_Width_Req
	If $iMsg_Width < $iMsg_Width_Min Then
		$iMsg_Width = $iMsg_Width_Min
		$iLabel_Width = $iMsg_Width_Min - 20
	EndIf

	; Check if title sets width
	Local $iDialog_Width = $iMsg_Width
	; Size title
	Local $aTitleSize = _StringSize($sTitle, $g_aEMB_Settings[10], Default, Default, $g_aEMB_Settings[11])

	; Check if title wider than text
	If $aTitleSize[2] > ($iMsg_Width - 70) Then ; Assume icon reduction of 50 regardless of icon setting
		; Adjust dialog width up to absolute dialog width value
		$iDialog_Width = ( ($aTitleSize[2] < ($g_aEMB_Settings[7] - $g_aEMB_Settings[12])) ? ($aTitleSize[2] + $g_aEMB_Settings[12]) : ($g_aEMB_Settings[7]) )
	EndIf

	Local $iMsg_Height = $iLabel_Height + 35
	; Increase height if buttons present
	If $vButton <> " " Then
		$iMsg_Height += 30
	EndIf
	; Increase height if checkbox required
	If BitAND($g_aEMB_Settings[0], 16) Then
		$iMsg_Height += 40
	EndIf
	If $iMsg_Height < $iMsg_Height_Min Then $iMsg_Height = $iMsg_Height_Min

	; If only single line, lower label to to centre text on icon
	Local $iLabel_Vert = 20
	If StringInStr($sText, @CRLF) = 0 Then $iLabel_Vert = 27

	; Check for taskbar button style required
	If Mod($g_aEMB_Settings[0], 2) = 1 Then ; Hide taskbar button so create as child
		If IsHWnd($hWin) Then
			$iParent_Win = $hWin ; Make child of that window
		Else
			$iParent_Win = WinGetHandle(AutoItWinGetTitle()) ; Make child of AutoIt window
		EndIf
	EndIf

	; Determine EMB location
	If $hWin = "" Then
		; No handle or position passed so centre on screen
		$iHpos = (@DesktopWidth - $iDialog_Width) / 2
		$iVPos = (@DesktopHeight - $iMsg_Height) / 2
	Else
		If IsHWnd($hWin) Then
			; Get parent GUI pos if visible
			If BitAND(WinGetState($hWin), 2) Then
				; Set EMB to centre on parent
				Local $aPos = WinGetPos($hWin)
				$iHpos = ($aPos[2] - $iDialog_Width) / 2 + $aPos[0] - 3
				$iVPos = ($aPos[3] - $iMsg_Height) / 2 + $aPos[1] - 20
			Else
				; Set EMB to centre om screen
				$iHpos = (@DesktopWidth - $iDialog_Width) / 2
				$iVPos = (@DesktopHeight - $iMsg_Height) / 2
			EndIf
		Else
			; Assume parameter is horizontal coord
			$iHpos = $hWin ; $iVpos already set
		EndIf
	EndIf

	; If dialog is to appear on main display
	If $bMain Then
		; Dialog is visible horizontally
		If $iHpos < 10 Then $iHpos = 10
		If $iHpos + $iDialog_Width > @DesktopWidth - 20 Then $iHpos = @DesktopWidth - 20 - $iDialog_Width
		; Then vertically
		If $iVPos < 10 Then $iVPos = 10
		If $iVPos + $iMsg_Height > @DesktopHeight - 60 Then $iVPos = @DesktopHeight - 60 - $iMsg_Height
	EndIf

	; Remove TOPMOST extended style if required
	Local $iExtStyle = 0x00000008 ; $WS_TOPMOST
	If BitAND($g_aEMB_Settings[0], 2) Then $iExtStyle = -1

	; Create GUI with $WS_POPUPWINDOW, $WS_CAPTION style and required extended style
	Local $hMsgGUI = _GUICreate($sTitle, $iDialog_Width, $iMsg_Height, $iHpos, $iVPos, BitOR(0x80880000, 0x00C00000), $iExtStyle, $iParent_Win)
	If @error Then
		Return SetError(7, 0, -1)
	EndIf

	; Check if titlebar icon hidden - actually uses transparent icon from AutoIt executable
	If BitAND($g_aEMB_Settings[0], 32) Then
		If @Compiled Then
			GUISetIcon(@ScriptName, -2, $hMsgGUI)
		Else
			GUISetIcon(@AutoItExe, -2, $hMsgGUI)
		EndIf
	EndIf
	If $g_aEMB_Settings[2] <> Default Then GUISetBkColor($g_aEMB_Settings[2])

	; Check if user closure permitted
	If BitAND($g_aEMB_Settings[0], 64) Then
		$aRet = DllCall("User32.dll", "hwnd", "GetSystemMenu", "hwnd", $hMsgGUI, "int", 0)
		Local $hSysMenu = $aRet[0]
		DllCall("User32.dll", "int", "RemoveMenu", "hwnd", $hSysMenu, "int", 0xF060, "int", 0) ; $SC_CLOSE
		DllCall("User32.dll", "int", "DrawMenuBar", "hwnd", $hMsgGUI)
	EndIf

	; Set centring parameter
	Local $iLabel_Style = 0 ; $SS_LEFT
	If BitAND($g_aEMB_Settings[1], 1) = 1 Then
		$iLabel_Style = 1 ; $SS_CENTER
	ElseIf BitAND($g_aEMB_Settings[1], 2) = 2 Then
		$iLabel_Style = 2 ; $SS_RIGHT
	EndIf

	; Create label
	GUICtrlCreateLabel($sText, 10 + $iIcon_Reduction, $iLabel_Vert, $iLabel_Width, $iLabel_Height, $iLabel_Style)
	GUICtrlSetFont(-1, $g_aEMB_Settings[4], Default, Default, $g_aEMB_Settings[5])
	If $g_aEMB_Settings[3] <> Default Then GUICtrlSetColor(-1, $g_aEMB_Settings[3])

	; Create checkbox if required
	If BitAND($g_aEMB_Settings[0], 16) Then
		Local $sAgain = " Do not show again"
		Local $iY = $iLabel_Vert + $iLabel_Height + 10
		; Create checkbox
		$cCheckbox = GUICtrlCreateCheckbox("", 10 + $iIcon_Reduction, $iY, 20, 20)
		; Write text in separate checkbox label
		Local $cCheckLabel = GUICtrlCreateLabel($sAgain, 20, 20, 20, 20)
		GUICtrlSetColor($cCheckLabel, $g_aEMB_Settings[3])
		GUICtrlSetBkColor($cCheckLabel, $g_aEMB_Settings[2])
		; Set font if required and size checkbox label text
		If BitAND($g_aEMB_Settings[0], 4) Then
			$aLabel_Size = _StringSize($sAgain)
		Else
			$aLabel_Size = _StringSize($sAgain, $g_aEMB_Settings[4], 400, 0, $g_aEMB_Settings[5])
			GUICtrlSetFont($cCheckLabel, $g_aEMB_Settings[4], 400, 0, $g_aEMB_Settings[5])
		EndIf
		; Move and resize checkbox label to fit
		$iY = ($iY + 10) - ($aLabel_Size[3] - 4) / 2
		ControlMove($hMsgGUI, "", $cCheckLabel, 30 + $iIcon_Reduction, $iY, $iMsg_Width - (30 + $iIcon_Reduction), $aLabel_Size[3])
	EndIf

	; Create icon or countdown timer
	If $fCountdown = True Then
		Local $cCountdown_Label = GUICtrlCreateLabel(StringFormat("%2s", $iTimeOut), 10, 20, 32, 32)
		GUICtrlSetFont(-1, 18, Default, Default, $g_aEMB_Settings[5])
		GUICtrlSetColor(-1, $g_aEMB_Settings[3])
	Else
		If $iIcon_Reduction Then _GUICtrlCreateIcon($sDLL, $iIcon_Style, 10, 20)
	EndIf

	; Create buttons
	Local $aButtonCID[$aButton_Text[0] + 1] = [9999] ; Placeholder to prevent accel key firing if no buttons
    If $vButton <> " " Then

        ; Create dummy control for Accel key
        $aButtonCID[0] = GUICtrlCreateDummy()
        ; Set Space key as Accel key
        Local $aAccel_Key[1][2] = [["{SPACE}", $aButtonCID[0]]]
        GUISetAccelerators($aAccel_Key)

        ; Calculate button horizontal start
        If $aButton_Text[0] = 1 Then
            If BitAND($g_aEMB_Settings[1], 4) = 4 Then
                ; Single centred button
                $iButton_Xpos = ($iMsg_Width - $iButton_Width) / 2
            Else
                ; Single offset button
                $iButton_Xpos = $iMsg_Width - $iButton_Width - 10
            EndIf
        Else
            ; Multiple centred buttons
            $iButton_Xpos = ($iMsg_Width - ($iButton_Width_Req - 20)) / 2
        EndIf
        ; Set default button code
        Local $iDefButton_Code = 0
        ; Set default button style
        Local $iDef_Button_Style = 0
        ; Work through button list
        For $i = 0 To $aButton_Text[0] - 1
            Local $iButton_Text = $aButton_Text[$i + 1]
            ; Set default button
            If $aButton_Text[0] = 1 Then ; Only 1 button
                $iDef_Button_Style = 0x0001
            ElseIf StringLeft($iButton_Text, 1) = "&" Then ; Look for &
                $iDef_Button_Style = 0x0001
                $aButton_Text[$i + 1] = StringTrimLeft($iButton_Text, 1)
                ; Set default button code for Accel key return
                $iDefButton_Code = $i + 1
            EndIf
            ; Draw button
            $aButtonCID[$i + 1] = GUICtrlCreateButton($aButton_Text[$i + 1], $iButton_Xpos + ($i * ($iButton_Width + 10)), $iMsg_Height - 35, $iButton_Width, 25, $iDef_Button_Style)
            ; Set font if required
            If Not BitAND($g_aEMB_Settings[0], 4) Then GUICtrlSetFont(-1, $g_aEMB_Settings[4], 400, 0, $g_aEMB_Settings[5])
            ; Reset default style parameter
            $iDef_Button_Style = 0
        Next
    EndIf

	; Show GUI
	GUISetState(@SW_SHOW, $hMsgGUI)

	; Begin timeout counter
	Local $iTimeout_Begin = __TimerInit()
	Local $iCounter = 0

	; Declare GUIGetMsg return array here and not in loop
	Local $aMsg

	; Set MessageLoop mode
	Local $iOrgMode = Opt('GUIOnEventMode', 0)

	While 1
		$aMsg = GUIGetMsg(1)

		If $aMsg[1] = $hMsgGUI Then
			Select
				Case $aMsg[0] = -3 ; $GUI_EVENT_CLOSE
					$iRet_Value = 0
					ExitLoop
				Case $aMsg[0] = $aButtonCID[0]
                    ; Accel key pressed so return default button code
                    If $iDefButton_Code Then
                        $iRet_Value = $iDefButton_Code
                        ExitLoop
                    EndIf
                Case Else
					; Check for other buttons
					For $i = 1 To UBound($aButtonCID) - 1
						If $aMsg[0] = $aButtonCID[$i] Then
							$iRet_Value = $i
							; No point in looking further
							ExitLoop 2
						EndIf
					Next
			EndSelect
		EndIf

		; Timeout if required
		If __TimerDiff($iTimeout_Begin) / 1000 >= $iTimeOut And $iTimeOut > 0 Then
			$iRet_Value = 9
			ExitLoop
		EndIf

		; Show countdown if required
		If $fCountdown = True Then
			Local $iTimeRun = Int(__TimerDiff($iTimeout_Begin) / 1000)
			If $iTimeRun <> $iCounter Then
				$iCounter = $iTimeRun
				GUICtrlSetData($cCountdown_Label, StringFormat("%2s", $iTimeOut - $iCounter))
			EndIf
		EndIf

	WEnd

	; Reset original mode
	Opt('GUIOnEventMode', $iOrgMode)

	If $cCheckbox And GUICtrlRead($cCheckbox) = 1 Then
		; Negate the return value
		$iRet_Value *= -1
	EndIf

	GUIDelete($hMsgGUI)

	Return $iRet_Value

EndFunc   ;==>_ExtMsgBox

; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: _EMB_GetDefaultFont
; Description ...: Determines Windows default MsgBox font size and name
; Syntax.........: _EMB_GetDefaultFont()
; Return values .: Success - Array holding determined font data
;                : Failure - Array holding default values
;                  Array elements - [0] = Size, [1] = Weight, [2] = Style, [3] = Name, [4] = Quality
; Author ........: KaFu
; Remarks .......: Used internally by ExtMsgBox UDF
; ===============================================================================================================================
Func __EMB_GetDefaultFont()

	; Fill array with standard default data
	Local $aDefFontData[2] = [9, "Tahoma"]

	; Get AutoIt GUI handle
	Local $hWnd = WinGetHandle(AutoItWinGetTitle())
	; Open Theme DLL
	Local $hThemeDLL = DllOpen("uxtheme.dll")
	; Get default theme handle
	Local $hTheme = DllCall($hThemeDLL, 'ptr', 'OpenThemeData', 'hwnd', $hWnd, 'wstr', "Static")
	If @error Then Return $aDefFontData
	$hTheme = $hTheme[0]

	; Create LOGFONT structure
	Local $tFont = DllStructCreate("long;long;long;long;long;byte;byte;byte;byte;byte;byte;byte;byte;wchar[32]")
	Local $pFont = DllStructGetPtr($tFont)

	; Get MsgBox font from theme
	DllCall($hThemeDLL, 'long', 'GetThemeSysFont', 'HANDLE', $hTheme, 'int', 805, 'ptr', $pFont) ; TMT_MSGBOXFONT
	If @error Then
	   $tFont = 0
	   Return $aDefFontData
    EndIf

	; Get default DC
	Local $hDC = DllCall("user32.dll", "handle", "GetDC", "hwnd", $hWnd)
	If @error Then
	   $tFont = 0
	   Return $aDefFontData
    EndIf
	$hDC = $hDC[0]

	; Get font vertical size
	Local $iPixel_Y = DllCall("gdi32.dll", "int", "GetDeviceCaps", "handle", $hDC, "int", 90) ; LOGPIXELSY
	If Not @error Then
		$iPixel_Y = $iPixel_Y[0]
		$aDefFontData[0] = Int(2 * (.25 - DllStructGetData($tFont, 1) * 72 / $iPixel_Y)) / 2
	EndIf

	; Close DC
	DllCall("user32.dll", "int", "ReleaseDC", "hwnd", $hWnd, "handle", $hDC)

	; Extract font data from LOGFONT structure
	$aDefFontData[1] = DllStructGetData($tFont, 14)

	$tFont = 0

	Return $aDefFontData

EndFunc   ;==>__EMB_GetDefaultFont


