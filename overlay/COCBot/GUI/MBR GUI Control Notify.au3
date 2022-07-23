;#FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Control Notify
; Description ...: This file Includes all functions to current GUI
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: MyBot.run team
; Modified ......: CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once
#Region - Discord - Team AIO Mod++
Func chkDSenabled()
	If GUICtrlRead($g_hChkNotifyDSEnable) = $GUI_CHECKED Then
		$g_bNotifyDSEnable = True
	Else
		$g_bNotifyDSEnable = False
	EndIf

	; Discord - Team AIO Mod++
	For $h = $g_hTxtNotifyDSToken To $g_hChkNotifyOnlyHoursDS
		GUICtrlSetState($h, $g_bNotifyDSEnable = True ? $GUI_ENABLE : $GUI_DISABLE)
	Next
	
	; Discord - Team AIO Mod++
	chkNotifyHoursDS()
EndFunc   ;==>chkDSenabled

Func chkNotifyHoursDS()
	Local $b = GUICtrlRead($g_hChkNotifyOnlyHoursDS) = $GUI_CHECKED And GUICtrlRead($g_hChkNotifyDSEnable) = $GUI_CHECKED
	For $i = 0 To 23
		GUICtrlSetState($g_hChkNotifyhoursDS[$i], $b ? $GUI_ENABLE : $GUI_DISABLE)
	Next
	_GUI_Value_STATE($b ? "ENABLE" : "DISABLE", $g_hChkNotifyOnlyWeekDaysDS&"#"&$g_hChkNotifyhoursE1DS&"#"&$g_hChkNotifyhoursE2DS)

	If $b = False Then
		GUICtrlSetState($g_hChkNotifyOnlyWeekDaysDS, $GUI_UNCHECKED)
		chkNotifyWeekDaysDS()
	EndIf
EndFunc   ;==>chkNotifyHoursDS

Func chkNotifyhoursE1DS()
    Local $b = GUICtrlRead($g_hChkNotifyhoursE1DS) = $GUI_CHECKED And GUICtrlRead($g_hChkNotifyhoursDS[0]) = $GUI_CHECKED
    For $i = 0 To 11
	   GUICtrlSetState($g_hChkNotifyhoursDS[$i], $b ? $GUI_UNCHECKED : $GUI_CHECKED)
    Next
	Sleep(300)
	GUICtrlSetState($g_hChkNotifyhoursE1DS, $GUI_UNCHECKED)
EndFunc   ;==>chkNotifyhoursE1DS

Func chkNotifyhoursE2DS()
    Local $b = GUICtrlRead($g_hChkNotifyhoursE2DS) = $GUI_CHECKED And GUICtrlRead($g_hChkNotifyhoursDS[12]) = $GUI_CHECKED
	For $i = 12 To 23
	   GUICtrlSetState($g_hChkNotifyhoursDS[$i], $b ? $GUI_UNCHECKED : $GUI_CHECKED)
    Next
	Sleep(300)
	GUICtrlSetState($g_hChkNotifyhoursE2DS, $GUI_UNCHECKED)
EndFunc		;==>chkNotifyhoursE2DS

Func chkNotifyWeekDaysDS()
	Local $b = GUICtrlRead($g_hChkNotifyOnlyWeekDaysDS) = $GUI_CHECKED
	For $i = 0 To 6
		GUICtrlSetState($g_hChkNotifyWeekdaysDS[$i], $b ? $GUI_ENABLE : $GUI_DISABLE)
	Next
	GUICtrlSetState($g_ahChkNotifyWeekdaysEDS, $b ? $GUI_ENABLE : $GUI_DISABLE)
EndFunc	;==>chkNotifyWeekDaysDS

Func ChkNotifyWeekdaysEDS()
	Local $b = BitOR(GUICtrlRead($g_hChkNotifyWeekdaysDS[0]), GUICtrlRead($g_hChkNotifyWeekdaysDS[1]), GUICtrlRead($g_hChkNotifyWeekdaysDS[2]), GUICtrlRead($g_hChkNotifyWeekdaysDS[3]), GUICtrlRead($g_hChkNotifyWeekdaysDS[4]), GUICtrlRead($g_hChkNotifyWeekdaysDS[5]), GUICtrlRead($g_hChkNotifyWeekdaysDS[6])) = $GUI_CHECKED
	For $i = 0 To 6
		GUICtrlSetState($g_hChkNotifyWeekdaysDS[$i], $b ? $GUI_UNCHECKED : $GUI_CHECKED)
	Next
	Sleep(300)
	GUICtrlSetState($g_ahChkNotifyWeekdaysEDS, $GUI_UNCHECKED)
EndFunc   ;==>ChkNotifyWeekdaysEDS
#EndRegion - Discord - Team AIO Mod++

Func chkPBTGenabled()

	If GUICtrlRead($g_hChkNotifyTGEnable) = $GUI_CHECKED Then
		$g_bNotifyTGEnable = True
		GUICtrlSetState($g_hTxtNotifyTGToken, $GUI_ENABLE)
	Else
		$g_bNotifyTGEnable = False
		GUICtrlSetState($g_hTxtNotifyTGToken, $GUI_DISABLE)
	EndIf

	; Discord - Team AIO Mod++
	For $h = $g_hChkNotifyRemote To $g_hChkNotifyOnlyHours
		GUICtrlSetState($h, $g_bNotifyTGEnable = True ? $GUI_ENABLE : $GUI_DISABLE)
	Next
	
	; Discord - Team AIO Mod++
	chkNotifyHours()
EndFunc   ;==>chkPBTGenabled

Func chkNotifyHours()
	Local $b = GUICtrlRead($g_hChkNotifyOnlyHours) = $GUI_CHECKED And GUICtrlRead($g_hChkNotifyTGEnable) = $GUI_CHECKED
	For $i = 0 To 23
		GUICtrlSetState($g_hChkNotifyhours[$i], $b ? $GUI_ENABLE : $GUI_DISABLE)
	Next
	_GUI_Value_STATE($b ? "ENABLE" : "DISABLE", $g_hChkNotifyOnlyWeekDays&"#"&$g_hChkNotifyhoursE1&"#"&$g_hChkNotifyhoursE2)

	If $b = False Then
		GUICtrlSetState($g_hChkNotifyOnlyWeekDays, $GUI_UNCHECKED)
		chkNotifyWeekDays()
	EndIf
EndFunc   ;==>chkNotifyHours

Func chkNotifyhoursE1()
    Local $b = GUICtrlRead($g_hChkNotifyhoursE1) = $GUI_CHECKED And GUICtrlRead($g_hChkNotifyhours[0]) = $GUI_CHECKED
    For $i = 0 To 11
	   GUICtrlSetState($g_hChkNotifyhours[$i], $b ? $GUI_UNCHECKED : $GUI_CHECKED)
    Next
	Sleep(300)
	GUICtrlSetState($g_hChkNotifyhoursE1, $GUI_UNCHECKED)
EndFunc   ;==>chkNotifyhoursE1

Func chkNotifyhoursE2()
    Local $b = GUICtrlRead($g_hChkNotifyhoursE2) = $GUI_CHECKED And GUICtrlRead($g_hChkNotifyhours[12]) = $GUI_CHECKED
	For $i = 12 To 23
	   GUICtrlSetState($g_hChkNotifyhours[$i], $b ? $GUI_UNCHECKED : $GUI_CHECKED)
    Next
	Sleep(300)
	GUICtrlSetState($g_hChkNotifyhoursE2, $GUI_UNCHECKED)
EndFunc		;==>chkNotifyhoursE2

Func chkNotifyWeekDays()
	Local $b = GUICtrlRead($g_hChkNotifyOnlyWeekDays) = $GUI_CHECKED
	For $i = 0 To 6
		GUICtrlSetState($g_hChkNotifyWeekdays[$i], $b ? $GUI_ENABLE : $GUI_DISABLE)
	Next
	GUICtrlSetState($g_ahChkNotifyWeekdaysE, $b ? $GUI_ENABLE : $GUI_DISABLE)
EndFunc	;==>chkNotifyWeekDays

Func ChkNotifyWeekdaysE()
	Local $b = BitOR(GUICtrlRead($g_hChkNotifyWeekdays[0]), GUICtrlRead($g_hChkNotifyWeekdays[1]), GUICtrlRead($g_hChkNotifyWeekdays[2]), GUICtrlRead($g_hChkNotifyWeekdays[3]), GUICtrlRead($g_hChkNotifyWeekdays[4]), GUICtrlRead($g_hChkNotifyWeekdays[5]), GUICtrlRead($g_hChkNotifyWeekdays[6])) = $GUI_CHECKED
	For $i = 0 To 6
		GUICtrlSetState($g_hChkNotifyWeekdays[$i], $b ? $GUI_UNCHECKED : $GUI_CHECKED)
	Next
	Sleep(300)
	GUICtrlSetState($g_ahChkNotifyWeekdaysE, $GUI_UNCHECKED)
EndFunc   ;==>ChkNotifyWeekdaysE
