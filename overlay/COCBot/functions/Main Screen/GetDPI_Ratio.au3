; #FUNCTION# ====================================================================================================================
; Name ..........: GetDPI_Ratio
; Description ...: Returns the current user DPI setting for display.
; Syntax ........: GetDPI_Ratio()
; Parameters ....: None
; Return values .: Ratio of DPI to standard 96 DPI display
; Author ........: Spiff59 (AutoIt Forums posted 9/23/2013)
; Modified ......: KnowJack
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......: None
; Link ..........: https://www.autoitscript.com/forum/topic/154885-autoit-and-dpi-awareness/
; Example .......: No
; ===============================================================================================================================

Global Const $g_iDPI_Ratio = 1

Func GetDPI_Ratio()
	Local $g_hAndroidWindow = 0
	Local $hDC = DllCall("user32.dll", "long", "GetDC", "long", $g_hAndroidWindow)
	If @error Then Return SetError(1, @extended, 0)
	Local $aRet = DllCall("gdi32.dll", "long", "GetDeviceCaps", "long", $hDC[0], "long", 90)
	If @error Then Return SetError(2, @extended, 0)
	$hDC = DllCall("user32.dll", "long", "ReleaseDC", "long", $g_hAndroidWindow, "long", $hDC)
	If @error Then Return SetError(3, @extended, 0)
	If $aRet[0] = 0 Then $aRet[0] = 96
	Return $aRet[0] / 96
EndFunc   ;==>GetDPI_Ratio


; #FUNCTION# ====================================================================================================================
; Name ..........: GUISetFont_DPI
; Description ...: Automaticaly adjust GUI font size for User DPI setting
; Syntax ........: GUISetFont_DPI($isize[, $iweight = ""[, $iattribute = ""[, $sfontname = ""]]])
; Parameters ....: $isize               - an integer value.
;                  $iweight             - [optional] an integer value. Default is "".
;                  $iattribute          - [optional] an integer value. Default is "".
;                  $sfontname           - [optional] a string value. Default is "".
; Return values .: None
; Author ........: Spiff59 (AutoIt Forums posted 9/23/2013)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......: None
; Link ..........: https://github.com/MyBotRun/MyBot/wiki https://www.autoitscript.com/forum/topic/154885-autoit-and-dpi-awareness/
; Example .......: N
; ===============================================================================================================================

Func GUISetFont_DPI($isize, $iweight = "", $iattribute = "", $sfontname = "")
	GUISetFont($isize / $g_iDPI_Ratio, $iweight, $iattribute, $sfontname)
EndFunc   ;==>GUISetFont_DPI


Func SetDPI()
	; This uses undocumented dll function from MS and does work reliably in all OS so it was removed from main bot code
	_ExtMsgBoxSet(1 + 64, $SS_CENTER, 0x004080, 0xFFFF00, 12, "Comic Sans MS", 600)
	Local $stext = "My Bot needs to change your DPI settinng to continue!" & @CRLF & @CRLF & _
			"You will be required to reboot your PC when done" & @CRLF & @CRLF & "Please close other programs and save you work NOW!" & @CRLF & @CRLF & _
			"Hit OK to change settings and reboot, or cancel to exit bot"
	Local $MsgBox = _ExtMsgBox(0, GetTranslatedFileIni("MBR Popups", "Ok_Cancel", "Ok|Cancel"), GetTranslatedFileIni("MBR Popups", "Settings_Error", "Display Settings Error"), $stext, 120)
	If $MsgBox = 1 Then
		; DLLCALL to change the DPI setting, requires the DPI to be in string format
		; Requires the system to be restarted to take effect.
		Local $aRet = DllCall("syssetup.dll", "int", "SetupChangeFontSize", "int_ptr", 0, "wstr", "96")
		If @error Then Return SetError(2, @extended, 0)
		If $aRet = 0 Then
			SetLog("Your Display DPI has been changed!!  Must logoff or restart to complete the chamge!", $COLOR_WARNING)
			_Sleep(5000) ; dont use if .. then here!
			Shutdown($SD_REBOOT)
		Else
			SetLog("Your DPI has not been changed due some unknown error, Return= " & $aRet, $COLOR_WARNING)
		EndIf
	EndIf
EndFunc   ;==>SetDPI

