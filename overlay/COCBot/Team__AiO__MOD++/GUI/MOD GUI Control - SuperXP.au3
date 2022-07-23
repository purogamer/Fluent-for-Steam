; #FUNCTION# ====================================================================================================================
; Name ..........: MOD GUI Control - SuperXP
; Description ...: This file controls the "SuperXP" tab
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: NguyenAnhHD
; Modified ......: Team AiO MOD++ (2019)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Func chkEnableSuperXP()
	If GUICtrlRead($g_hChkEnableSuperXP) = $GUI_CHECKED Then
		$g_bEnableSuperXP = True
		For $i = $g_hChkSkipZoomOutSX To $g_hLblRunTimeXP
			GUICtrlSetState($i, $GUI_ENABLE)
		Next
		GUICtrlSetState($g_hLblLockedSX, $GUI_HIDE)
	Else
		$g_bEnableSuperXP = False
		For $i = $g_hChkSkipZoomOutSX To $g_hLblRunTimeXP
			GUICtrlSetState($i, $GUI_DISABLE)
		Next
	EndIf
	radLblGoblinMapOpt()
EndFunc   ;==>chkEnableSuperXP

Func radLblGoblinMapOpt()
	If GUICtrlRead($g_hRdoGoblinPicnic) = $GUI_CHECKED Then
		$g_sGoblinMapOptSX = "Goblin Picnic"
		_GUI_Value_STATE("SHOW", $g_hLblGoblinPicnic1 & "#" & $g_hLblGoblinPicnic2)
		_GUI_Value_STATE("HIDE", $g_hLblTheArena1 & "#" & $g_hLblTheArena2)
		If GUICtrlRead($g_hChkEnableSuperXP) = $GUI_CHECKED Then GUICtrlSetState($g_hChkBKingSX, $GUI_ENABLE)
	ElseIf GUICtrlRead($g_hRdoTheArena) = $GUI_CHECKED Then
		$g_sGoblinMapOptSX = "The Arena"
		_GUI_Value_STATE("HIDE", $g_hLblGoblinPicnic1 & "#" & $g_hLblGoblinPicnic2)
		_GUI_Value_STATE("SHOW", $g_hLblTheArena1 & "#" & $g_hLblTheArena2)
		If GUICtrlRead($g_hChkEnableSuperXP) = $GUI_CHECKED Then GUICtrlSetState($g_hChkBKingSX, BitOR($GUI_UNCHECKED, $GUI_DISABLE))
	EndIf
EndFunc   ;==>radLblGoblinMapOpt

Func radActivateOptionSX()
	GUICtrlSetState($g_hRdoTrainingSX, $g_iActivateOptionSX = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
	GUICtrlSetState($g_hRdoAttackingSX, $g_iActivateOptionSX = 2 ? $GUI_CHECKED : $GUI_UNCHECKED)
EndFunc   ;==>radActivateOptionSX

Func radGoblinMapOptSX()
	GUICtrlSetState($g_hRdoGoblinPicnic, $g_iGoblinMapOptSX = 1 ? $GUI_CHECKED : $GUI_UNCHECKED)
	GUICtrlSetState($g_hRdoTheArena, $g_iGoblinMapOptSX = 2 ? $GUI_CHECKED : $GUI_UNCHECKED)
EndFunc   ;==>radGoblinMapOptSX