; #FUNCTION# ====================================================================================================================
; Name ..........: MOD GUI Control - GTFO
; Description ...: This file is used for Fenix MOD GUI functions of GTFO Tab will be here.
; Author ........: Boldina/Boludoz (2018 FOR SIMBIOS)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2020
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func ApplyGTFO()
	$g_bChkUseGTFO = (GUICtrlRead($g_hChkUseGTFO) = $GUI_CHECKED)
	For $h = $g_hTxtMinSaveGTFO_Elixir To $g_hChkGTFOClanHop
		GUICtrlSetState($h, ($g_bChkUseGTFO = True) ? ($GUI_ENABLE) : ($GUI_DISABLE + $GUI_UNCHECKED))
	Next
	chkGTFOClanHop()
	ApplyCyclesGTFO()
	chkGTFOReturnClan()
	ApplyClanReturnGTFO()
EndFunc   ;==>ApplyGTFO

Func ApplyElixirGTFO()
	$g_iTxtMinSaveGTFO_Elixir = Number(GUICtrlRead($g_hTxtMinSaveGTFO_Elixir))
EndFunc   ;==>ApplyElixirGTFO

Func ApplyDarkElixirGTFO()
	$g_iTxtMinSaveGTFO_DE = Number(GUICtrlRead($g_hTxtMinSaveGTFO_DE))
EndFunc   ;==>ApplyDarkElixirGTFO

Func ApplyCyclesGTFO()
	$g_iTxtCyclesGTFO = Number(GUICtrlRead($g_hTxtCyclesGTFO))
	$g_iTxtCyclesGTFO -= 1
	$g_bExitAfterCyclesGTFO = (GUICtrlRead($g_hExitAfterCyclesGTFO) = $GUI_CHECKED)
	If $g_bExitAfterCyclesGTFO Then
	GUICtrlSetState($g_hTxtCyclesGTFO, $GUI_ENABLE)
	Else 
	GUICtrlSetState($g_hTxtCyclesGTFO, $GUI_DISABLE)
	EndIf
EndFunc   ;==>ApplyCyclesGTFO

Func ApplyClanReturnGTFO()
	$g_sTxtClanID = GUICtrlRead($g_hTxtClanID)
EndFunc   ;==>ApplyClanReturnGTFO

Func ApplyKickOut()
	$g_bChkUseKickOut = (GUICtrlRead($g_hChkUseKickOut) = $GUI_CHECKED)
	If $g_bChkUseKickOut Then
		GUICtrlSetState($g_hTxtDonatedCap, $GUI_ENABLE)
		GUICtrlSetState($g_hTxtReceivedCap, $GUI_ENABLE)
		GUICtrlSetState($g_hChkKickOutSpammers, $GUI_ENABLE)
		GUICtrlSetState($g_hTxtKickLimit, $GUI_ENABLE)
	Else
		GUICtrlSetState($g_hTxtDonatedCap, $GUI_DISABLE)
		GUICtrlSetState($g_hTxtReceivedCap, $GUI_DISABLE)
		GUICtrlSetState($g_hChkKickOutSpammers, $GUI_DISABLE)
		GUICtrlSetState($g_hTxtKickLimit, $GUI_DISABLE)
	EndIf
	ApplyKickOutSpammers()
	ApplyKickLimits()
EndFunc   ;==>ApplyKickOut

Func ApplyDonatedCap()
	$g_iTxtDonatedCap = Number(GUICtrlRead($g_hTxtDonatedCap))
	If $g_iTxtDonatedCap < 0 Then
		$g_iTxtDonatedCap = 0
		GUICtrlSetData($g_hTxtDonatedCap, $g_iTxtDonatedCap)
	EndIf
	If $g_iTxtDonatedCap > 8 Then
		$g_iTxtDonatedCap = 8
		GUICtrlSetData($g_hTxtDonatedCap, $g_iTxtDonatedCap)
	EndIf
EndFunc   ;==>ApplyDonatedCap

Func ApplyReceivedCap()
	$g_iTxtReceivedCap = Number(GUICtrlRead($g_hTxtReceivedCap))
	If $g_iTxtReceivedCap < 0 Then
		$g_iTxtReceivedCap = 0
		GUICtrlSetData($g_hTxtReceivedCap, $g_iTxtReceivedCap)
	EndIf
	If $g_iTxtReceivedCap > 35 Then
		$g_iTxtReceivedCap = 35
		GUICtrlSetData($g_hTxtReceivedCap, $g_iTxtReceivedCap)
	EndIf
EndFunc   ;==>ApplyReceivedCap

; Kick Spammer to kick only donating members
Func ApplyKickOutSpammers()
	$g_bChkKickOutSpammers = (GUICtrlRead($g_hChkKickOutSpammers) = $GUI_CHECKED)
	If $g_bChkKickOutSpammers = True Then
		GUICtrlSetState($g_hTxtDonatedCap, $GUI_DISABLE)
		GUICtrlSetState($g_hTxtReceivedCap, $GUI_DISABLE)
	Else
		If $g_bChkUseKickOut = True Then
			GUICtrlSetState($g_hTxtDonatedCap, $GUI_ENABLE)
			GUICtrlSetState($g_hTxtReceivedCap, $GUI_ENABLE)
		EndIf
	EndIf
EndFunc   ;==>ApplyKickOutSpammers

; Set Kick Limite according to your need
Func ApplyKickLimits()
	$g_iTxtKickLimit = Number(GUICtrlRead($g_hTxtKickLimit))
	If $g_iTxtKickLimit < 1 Then
		$g_iTxtKickLimit = 1
		GUICtrlSetData($g_hTxtKickLimit, $g_iTxtKickLimit)
	EndIf
	If $g_iTxtKickLimit > 9 Then
		$g_iTxtKickLimit = 9
		GUICtrlSetData($g_hTxtKickLimit, $g_iTxtKickLimit)
	EndIf
EndFunc   ;==>ApplyKickLimits

Func chkGTFOClanHop()
	$g_bChkGTFOClanHop = (GUICtrlRead($g_hChkGTFOClanHop) = $GUI_CHECKED)
	For $h = $g_hChkGTFOReturnClan To $g_hExitAfterCyclesGTFO
		GUICtrlSetState($h, ($g_bChkGTFOClanHop = True) ? ($GUI_ENABLE) : ($GUI_DISABLE))
	Next
EndFunc   ;==>chkGTFOClanHop

Func chkGTFOReturnClan()
	$g_bChkGTFOReturnClan = (GUICtrlRead($g_hChkGTFOReturnClan) = $GUI_CHECKED)
EndFunc   ;==>chkGTFOReturnClan
