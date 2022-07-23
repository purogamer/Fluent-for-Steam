; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Control
; Description ...: This file Includes all functions to current GUI
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Sardo (2016)
; Modified ......: CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Func chkRequestCCHours()
	Local $bWasRedraw = SetRedrawBotWindow(False, Default, Default, Default, "chkRequestCCHours")

	If GUICtrlRead($g_hChkRequestTroopsEnable) = $GUI_CHECKED Then
		GUICtrlSetState($g_hTxtRequestCC, $GUI_SHOW + $GUI_ENABLE)
		For $i = $g_hLblRequestCChour To $g_hLblRequestCCHoursPM
			GUICtrlSetState($i, $GUI_ENABLE)
		Next
		; GuiToggle_RequestOnlyDuringHours(True)
	Else
		GUICtrlSetState($g_hTxtRequestCC, $GUI_SHOW + $GUI_DISABLE)
		For $i = $g_hLblRequestCChour To $g_hLblRequestCCHoursPM
			GUICtrlSetState($i, $GUI_DISABLE)
		Next
	EndIf

	SetRedrawBotWindowControls($bWasRedraw, $g_hGrpRequestCC, "chkRequestCCHours")
	
	If GUICtrlRead($g_hChkRequestTroopsEnable) = $GUI_CHECKED Then
		For $i = $g_hChkRequestTypeOnceEnable To $g_hChkRequestType_Siege
			GUICtrlSetState($i, $GUI_ENABLE)
		Next
	Else
		For $i = $g_hChkRequestTypeOnceEnable To $g_hChkRequestType_Siege
			GUICtrlSetState($i, $GUI_DISABLE)
		Next
	EndIf

	chkRequestCountCC()
	chkRequestDefense()
EndFunc   ;==>chkRequestCCHours

Func chkRequestCountCC()
	If GUICtrlRead($g_hChkRequestType_Troops) = $GUI_CHECKED And GUICtrlRead($g_hChkRequestTroopsEnable) = $GUI_CHECKED Then
		GUICtrlSetState($g_hTxtRequestCountCCTroop, $GUI_ENABLE)
		For $i = $g_ahCmbClanCastleTroop[0] To $g_ahCmbClanCastleTroop[2]
			GUICtrlSetState($i, $GUI_ENABLE)
		Next
		CmbClanCastleTroop()
	Else
		GUICtrlSetState($g_hTxtRequestCountCCTroop, $GUI_DISABLE)
		For $i = $g_ahCmbClanCastleTroop[0] To $g_ahTxtClanCastleTroop[2]
			GUICtrlSetState($i, $GUI_DISABLE)
		Next
	EndIf
	If GUICtrlRead($g_hChkRequestType_Spells) = $GUI_CHECKED And GUICtrlRead($g_hChkRequestTroopsEnable) = $GUI_CHECKED Then
		GUICtrlSetState($g_hTxtRequestCountCCSpell, $GUI_ENABLE)
		GUICtrlSetState($g_ahCmbClanCastleSpell[0], $GUI_ENABLE)
		GUICtrlSetState($g_ahCmbClanCastleSpell[1], $GUI_ENABLE)
		GUICtrlSetState($g_ahCmbClanCastleSpell[2], $GUI_ENABLE)
		CmbClanCastleSpell()
	Else
		GUICtrlSetState($g_hTxtRequestCountCCSpell, $GUI_DISABLE)
		GUICtrlSetState($g_ahCmbClanCastleSpell[0], $GUI_DISABLE)
		GUICtrlSetState($g_ahCmbClanCastleSpell[1], $GUI_DISABLE)
		GUICtrlSetState($g_ahCmbClanCastleSpell[2], $GUI_DISABLE)
	EndIf
	If GUICtrlRead($g_hChkRequestType_Siege) = $GUI_CHECKED And GUICtrlRead($g_hChkRequestTroopsEnable) = $GUI_CHECKED Then
		GUICtrlSetState($g_ahCmbClanCastleSiege[0], $GUI_ENABLE)
		GUICtrlSetState($g_ahCmbClanCastleSiege[1], $GUI_ENABLE)
	Else
		GUICtrlSetState($g_ahCmbClanCastleSiege[0], $GUI_DISABLE)
		GUICtrlSetState($g_ahCmbClanCastleSiege[1], $GUI_DISABLE)
	EndIf
EndFunc   ;==>chkRequestCountCC

Func CmbClanCastleTroop()
	For $i = 0 To UBound($g_ahCmbClanCastleTroop) - 1
		If _GUICtrlComboBox_GetCurSel($g_ahCmbClanCastleTroop[$i]) > 0 Then
			GUICtrlSetState($g_ahTxtClanCastleTroop[$i], $GUI_ENABLE)
		Else
			GUICtrlSetState($g_ahTxtClanCastleTroop[$i], $GUI_DISABLE)
		EndIf
	Next
EndFunc   ;==>CmbClanCastleTroop

Func CmbClanCastleSpell()
	For $i = 0 To UBound($g_ahCmbClanCastleSpell) - 1
		If _GUICtrlComboBox_GetCurSel($g_ahCmbClanCastleSpell[$i]) = $eISpell - $eLSpell Then _GUICtrlComboBox_SetCurSel($g_ahCmbClanCastleSpell[$i], $eSpellCount)
	Next
EndFunc   ;==>CmbClanCastleSpell

Func chkRequestCCHoursE1()
	If GUICtrlRead($g_hChkRequestCCHoursE1) = $GUI_CHECKED And GUICtrlRead($g_ahChkRequestCCHours[0]) = $GUI_CHECKED Then
		For $i = 0 To 11
			GUICtrlSetState($g_ahChkRequestCCHours[$i], $GUI_UNCHECKED)
		Next
	Else
		For $i = 0 To 11
			GUICtrlSetState($g_ahChkRequestCCHours[$i], $GUI_CHECKED)
		Next
	EndIf
	Sleep(300)
	GUICtrlSetState($g_hChkRequestCCHoursE1, $GUI_UNCHECKED)
EndFunc   ;==>chkRequestCCHoursE1

Func chkRequestCCHoursE2()
	If GUICtrlRead($g_hChkRequestCCHoursE2) = $GUI_CHECKED And GUICtrlRead($g_ahChkRequestCCHours[12]) = $GUI_CHECKED Then
		For $i = 12 To 23
			GUICtrlSetState($g_ahChkRequestCCHours[$i], $GUI_UNCHECKED)
		Next
	Else
		For $i = 12 To 23
			GUICtrlSetState($g_ahChkRequestCCHours[$i], $GUI_CHECKED)
		Next
	EndIf
	Sleep(300)
	GUICtrlSetState($g_hChkRequestCCHoursE2, $GUI_UNCHECKED)
EndFunc   ;==>chkRequestCCHoursE2

Func chkDonateHours()
	Local $bWasRedraw = SetRedrawBotWindow(False, Default, Default, Default, "chkDonateHours")

    If GUICtrlRead($g_hChkDonateHoursEnable) = $GUI_CHECKED Then
		For $i = $g_hLblDonateCChour To $g_hLblDonateHoursPM
			GUICtrlSetState($i, $GUI_ENABLE)
		Next
	Else
		For $i = $g_hLblDonateCChour To $g_hLblDonateHoursPM
			GUICtrlSetState($i, $GUI_DISABLE)
		Next
	EndIf

	SetRedrawBotWindowControls($bWasRedraw, $g_hGrpDonateCC, "chkDonateHours")
EndFunc   ;==>chkDonateHours

Func chkDonateHoursE1()
	If GUICtrlRead($g_ahChkDonateHoursE1) = $GUI_CHECKED And GUICtrlRead($g_ahChkDonateHours[0]) = $GUI_CHECKED Then
		For $i = 0 To 11
			GUICtrlSetState($g_ahChkDonateHours[$i], $GUI_UNCHECKED)
		Next
	Else
		For $i = 0 To 11
			GUICtrlSetState($g_ahChkDonateHours[$i], $GUI_CHECKED)
		Next
	EndIf
	Sleep(300)
	GUICtrlSetState($g_ahChkDonateHoursE1, $GUI_UNCHECKED)
EndFunc   ;==>chkDonateHoursE1

Func chkDonateHoursE2()
	If GUICtrlRead($g_ahChkDonateHoursE2) = $GUI_CHECKED And GUICtrlRead($g_ahChkDonateHours[12]) = $GUI_CHECKED Then
		For $i = 12 To 23
			GUICtrlSetState($g_ahChkDonateHours[$i], $GUI_UNCHECKED)
		Next
	Else
		For $i = 12 To 23
			GUICtrlSetState($g_ahChkDonateHours[$i], $GUI_CHECKED)
		Next
	EndIf
	Sleep(300)
	GUICtrlSetState($g_ahChkDonateHoursE2, $GUI_UNCHECKED)
EndFunc   ;==>chkDonateHoursE2

; Request troops for defense (Demen)
Func chkRequestDefense()
    If GUICtrlRead($g_hChkRequestCCDefense) = $GUI_CHECKED Then
        For $i = $g_hChkSaveCCTroopForDefense To $g_ahTxtClanCastleTroopDef[2]
            GUICtrlSetState($i, $GUI_ENABLE)
        Next
		CmbClanCastleTroopDef()
		GuiToggle_RequestOnlyDuringHours(True)
    Else
        For $i = $g_hChkSaveCCTroopForDefense To $g_ahTxtClanCastleTroopDef[2]
            GUICtrlSetState($i, $GUI_DISABLE)
        Next
		If GUICtrlRead($g_hChkRequestTroopsEnable) = $GUI_UNCHECKED Then GuiToggle_RequestOnlyDuringHours(False)
    EndIf
EndFunc   ;==>chkRequestDefense

Func CmbClanCastleTroopDef()
	For $i = 0 To UBound($g_ahCmbClanCastleTroopDef) - 1
		If _GUICtrlComboBox_GetCurSel($g_ahCmbClanCastleTroopDef[$i]) < $eTroopCount Then
			GUICtrlSetState($g_ahTxtClanCastleTroopDef[$i], $GUI_ENABLE)
		Else
			GUICtrlSetState($g_ahTxtClanCastleTroopDef[$i], $GUI_DISABLE)
		EndIf
	Next
EndFunc   ;==>CmbClanCastleTroopDef

Func GuiToggle_RequestOnlyDuringHours($Enable = True)
	If $Enable Then
		GUICtrlSetState($g_hChkRequestFromChat, $GUI_ENABLE)
		For $i = $g_hLblRequestCChour To $g_hLblRequestCCHoursPM
			GUICtrlSetState($i, $GUI_ENABLE)
		Next
	Else
		GUICtrlSetState($g_hChkRequestFromChat, $GUI_DISABLE)
		For $i = $g_hLblRequestCChour To $g_hLblRequestCCHoursPM
			GUICtrlSetState($i, $GUI_DISABLE)
		Next
	EndIf
EndFunc   ;==>GuiToggle_RequestOnlyDuringHours

Func chkRemoveCCForDefense()
    If GUICtrlRead($g_hChkRemoveCCForDefense) = $GUI_CHECKED Then
        For $i = $g_ahCmbClanCastleTroopDef[0] To $g_ahTxtClanCastleTroopDef[2]
            GUICtrlSetState($i, $GUI_ENABLE)
        Next
    Else
        For $i = $g_ahCmbClanCastleTroopDef[0] To $g_ahTxtClanCastleTroopDef[2]
            GUICtrlSetState($i, $GUI_DISABLE)
        Next
    EndIf
EndFunc   ;==>chkRemoveCCForDefense
