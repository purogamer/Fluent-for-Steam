; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Control Donate
; Description ...: This file Includes all functions to current GUI
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: MyBot.run team
; Modified ......: MonkeyHunter (07-2016), CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Global $g_aiDonIcons[$eTroopCount + 1] = [$eIcnDonBarbarian, $eIcnSuperBarbarian, $eIcnDonArcher, $eIcnSuperArcher, $eIcnDonGiant, $eIcnSuperGiant, $eIcnDonGoblin, $eIcnSneakyGoblin, _
							$eIcnDonWallBreaker, $eIcnSuperWallBreaker, $eIcnDonBalloon, $eIcnRocketBalloon, $eIcnDonWizard, $eIcnSuperWizard, $eIcnDonHealer, $eIcnDonDragon, $eIcnSuperDragon, $eIcnDonPekka, $eIcnDonBabyDragon, _
							$eIcnInfernoDragon, $eIcnDonMiner, $eIcnElectroDragon, $eIcnYeti, $eIcnDragonRider, $eIcnDonMinion, $eIcnSuperMinion, $eIcnDonHogRider, $eIcnDonValkyrie, $eIcnSuperValkyrie, $eIcnDonGolem, _
							$eIcnDonWitch, $eIcnSuperWitch, $eIcnDonLavaHound, $eIcnIceHound, $eIcnDonBowler, $eIcnSuperBowler, $eIcnIceGolem, $eIcnHeadhunter, $eIcnDonBlank]

Func btnDonateTroop()
	For $i = 0 To $eTroopCount - 1 + $g_iCustomDonateConfigs + $eSiegeMachineCount
		If @GUI_CtrlId = $g_ahBtnDonateTroop[$i] Then
			If GUICtrlGetState($g_ahGrpDonateTroop[$i]) = BitOR($GUI_HIDE, $GUI_ENABLE) Then
				_DonateBtn($g_ahGrpDonateTroop[$i], $g_ahTxtBlacklistTroop[$i]) ;Hide/Show controls on Donate tab
			EndIf
			GUICtrlSetState($g_hChkDonateQueueSpellOnly, $GUI_HIDE)
			If $i <= $eTroopCount - 1 + $g_iCustomDonateConfigs Then
				GUICtrlSetState($g_hChkDonateQueueTroopOnly, $GUI_SHOW)
				If GUICtrlRead($g_ahChkDonateTroop[$i]) = $GUI_CHECKED Or GUICtrlRead($g_ahChkDonateAllTroop[$i]) = $GUI_CHECKED Then
					GUICtrlSetState($g_hChkDonateQueueTroopOnly, $GUI_ENABLE)
				Else
					GUICtrlSetState($g_hChkDonateQueueTroopOnly, $GUI_DISABLE)
				EndIf
			Else
				GUICtrlSetState($g_hChkDonateQueueTroopOnly, $GUI_HIDE)
			EndIf
			ExitLoop
		EndIf
	Next
EndFunc   ;==>btnDonateTroop

Func btnDonateSpell()
	For $i = 0 To $eSpellCount - 1
		If @GUI_CtrlId = $g_ahBtnDonateSpell[$i] Then
			If GUICtrlGetState($g_ahGrpDonateSpell[$i]) = BitOR($GUI_HIDE, $GUI_ENABLE) Then
				_DonateBtn($g_ahGrpDonateSpell[$i], $g_ahTxtBlacklistSpell[$i])
			EndIf
			GUICtrlSetState($g_hChkDonateQueueTroopOnly, $GUI_HIDE)
			GUICtrlSetState($g_hChkDonateQueueSpellOnly, $GUI_SHOW)
			If GUICtrlRead($g_ahChkDonateSpell[$i]) = $GUI_CHECKED Or GUICtrlRead($g_ahChkDonateAllSpell[$i]) = $GUI_CHECKED Then
				GUICtrlSetState($g_hChkDonateQueueSpellOnly, $GUI_ENABLE)
			Else
				GUICtrlSetState($g_hChkDonateQueueSpellOnly, $GUI_DISABLE)
			EndIf
			ExitLoop
		EndIf
	Next
EndFunc   ;==>btnDonateSpell

Func btnDonateBlacklist()
	If GUICtrlGetState($g_hGrpDonateGeneralBlacklist) = BitOR($GUI_HIDE, $GUI_ENABLE) Then
		_DonateBtn($g_hGrpDonateGeneralBlacklist, $g_hTxtGeneralBlacklist)
	EndIf
	GUICtrlSetState($g_hChkDonateQueueTroopOnly, $GUI_HIDE)
	GUICtrlSetState($g_hChkDonateQueueSpellOnly, $GUI_HIDE)
EndFunc   ;==>btnDonateBlacklist

Func chkDonateTroop()
	For $i = 0 To $eTroopCount-1 + $g_iCustomDonateConfigs + $eSiegeMachineCount
		If @GUI_CtrlId = $g_ahChkDonateTroop[$i] Then
			If GUICtrlRead($g_ahChkDonateTroop[$i]) = $GUI_CHECKED Then
				_DonateControls($i)
				If $i <= $eTroopCount - 1 + $g_iCustomDonateConfigs Then GUICtrlSetState($g_hChkDonateQueueTroopOnly, $GUI_ENABLE)
			Else
				GUICtrlSetBkColor($g_ahLblDonateTroop[$i], $GUI_BKCOLOR_TRANSPARENT)
				If $i <= $eTroopCount - 1 + $g_iCustomDonateConfigs And GUICtrlRead($g_ahChkDonateAllTroop[$i]) = $GUI_UNCHECKED Then GUICtrlSetState($g_hChkDonateQueueTroopOnly, $GUI_DISABLE)
			EndIf
			SetStateTxtGeneralBlacklist()
		EndIf
	Next
EndFunc   ;==>chkDonateTroop

Func chkDonateAllTroop()
	For $i = 0 To $eTroopCount - 1 + $g_iCustomDonateConfigs + $eSiegeMachineCount
		If @GUI_CtrlId = $g_ahChkDonateAllTroop[$i] Then
			If $i <= $eTroopCount - 1 + $g_iCustomDonateConfigs Then
				If GUICtrlRead($g_ahChkDonateAllTroop[$i]) = $GUI_CHECKED Then
					GUICtrlSetState($g_hChkDonateQueueTroopOnly, $GUI_ENABLE)
				ElseIf GUICtrlRead($g_ahChkDonateTroop[$i]) = $GUI_UNCHECKED Then
					GUICtrlSetState($g_hChkDonateQueueTroopOnly, $GUI_DISABLE)
				EndIf
			EndIf
			_DonateAllControls($i, GUICtrlRead($g_ahChkDonateAllTroop[$i]) = $GUI_CHECKED ? True : False)
			SetStateTxtGeneralBlacklist()
			ExitLoop
		EndIf
	Next
EndFunc   ;==>chkDonateAllTroop

Func chkDonateSpell()
	For $i = 0 To $eSpellCount - 1
		If @GUI_CtrlId = $g_ahChkDonateSpell[$i] Then
			If GUICtrlRead($g_ahChkDonateSpell[$i]) = $GUI_CHECKED Then
				_DonateControlsSpell($i)
				GUICtrlSetState($g_hChkDonateQueueSpellOnly, $GUI_ENABLE)
			Else
				GUICtrlSetBkColor($g_ahLblDonateSpell[$i], $GUI_BKCOLOR_TRANSPARENT)
				If GUICtrlRead($g_ahChkDonateAllSpell[$i]) = $GUI_UNCHECKED Then GUICtrlSetState($g_hChkDonateQueueSpellOnly, $GUI_DISABLE)
			EndIf
			SetStateTxtGeneralBlacklist()
		EndIf
	Next
EndFunc   ;==>chkDonateSpell

Func chkDonateAllSpell()
	For $i = 0 To $eSpellCount - 1
		If @GUI_CtrlId = $g_ahChkDonateAllSpell[$i] Then
			If GUICtrlRead($g_ahChkDonateAllSpell[$i]) = $GUI_CHECKED Then
				GUICtrlSetState($g_hChkDonateQueueSpellOnly, $GUI_ENABLE)
			Else
				If GUICtrlRead($g_ahChkDonateSpell[$i]) = $GUI_UNCHECKED Then GUICtrlSetState($g_hChkDonateQueueSpellOnly, $GUI_DISABLE)
			EndIf
			_DonateAllControlsSpell($i, GUICtrlRead($g_ahChkDonateAllSpell[$i]) = $GUI_CHECKED ? True : False)
			SetStateTxtGeneralBlacklist()
			ExitLoop
		EndIf
	Next
EndFunc   ;==>chkDonateAllSpell

Func cmbDonateCustomA()
	Local $combo1 = _GUICtrlComboBox_GetCurSel($g_ahCmbDonateCustomA[0])
	Local $combo2 = _GUICtrlComboBox_GetCurSel($g_ahCmbDonateCustomA[1])
	Local $combo3 = _GUICtrlComboBox_GetCurSel($g_ahCmbDonateCustomA[2])
	_GUICtrlSetImage($g_ahPicDonateCustomA[0], $g_sLibIconPath, $g_aiDonIcons[$combo1])
	_GUICtrlSetImage($g_ahPicDonateCustomA[1], $g_sLibIconPath, $g_aiDonIcons[$combo2])
	_GUICtrlSetImage($g_ahPicDonateCustomA[2], $g_sLibIconPath, $g_aiDonIcons[$combo3])
EndFunc   ;==>cmbDonateCustomA

Func cmbDonateCustomB()
	Local $combo1 = _GUICtrlComboBox_GetCurSel($g_ahCmbDonateCustomB[0])
	Local $combo2 = _GUICtrlComboBox_GetCurSel($g_ahCmbDonateCustomB[1])
	Local $combo3 = _GUICtrlComboBox_GetCurSel($g_ahCmbDonateCustomB[2])
	_GUICtrlSetImage($g_ahPicDonateCustomB[0], $g_sLibIconPath, $g_aiDonIcons[$combo1])
	_GUICtrlSetImage($g_ahPicDonateCustomB[1], $g_sLibIconPath, $g_aiDonIcons[$combo2])
	_GUICtrlSetImage($g_ahPicDonateCustomB[2], $g_sLibIconPath, $g_aiDonIcons[$combo3])
EndFunc   ;==>cmbDonateCustomB

Func cmbDonateCustomC()
	Local $combo1 = _GUICtrlComboBox_GetCurSel($g_ahCmbDonateCustomC[0])
	Local $combo2 = _GUICtrlComboBox_GetCurSel($g_ahCmbDonateCustomC[1])
	Local $combo3 = _GUICtrlComboBox_GetCurSel($g_ahCmbDonateCustomC[2])
	_GUICtrlSetImage($g_ahPicDonateCustomC[0], $g_sLibIconPath, $g_aiDonIcons[$combo1])
	_GUICtrlSetImage($g_ahPicDonateCustomC[1], $g_sLibIconPath, $g_aiDonIcons[$combo2])
	_GUICtrlSetImage($g_ahPicDonateCustomC[2], $g_sLibIconPath, $g_aiDonIcons[$combo3])
EndFunc   ;==>cmbDonateCustomC

Func cmbDonateCustomD()
	Local $combo1 = _GUICtrlComboBox_GetCurSel($g_ahCmbDonateCustomD[0])
	Local $combo2 = _GUICtrlComboBox_GetCurSel($g_ahCmbDonateCustomD[1])
	Local $combo3 = _GUICtrlComboBox_GetCurSel($g_ahCmbDonateCustomD[2])
	_GUICtrlSetImage($g_ahPicDonateCustomD[0], $g_sLibIconPath, $g_aiDonIcons[$combo1])
	_GUICtrlSetImage($g_ahPicDonateCustomD[1], $g_sLibIconPath, $g_aiDonIcons[$combo2])
	_GUICtrlSetImage($g_ahPicDonateCustomD[2], $g_sLibIconPath, $g_aiDonIcons[$combo3])
EndFunc   ;==>cmbDonateCustomD

Func _DonateBtn($hFirstControl, $hLastControl)
    Static $hLastDonateBtn1 = -1, $hLastDonateBtn2 = -1

	; Hide Controls
	If $hLastDonateBtn1 = -1 Then
		For $i = $g_ahGrpDonateTroop[$eTroopBarbarian] To $g_ahTxtBlacklistTroop[$eTroopBarbarian] ; 1st time use: Hide Barbarian controls
			GUICtrlSetState($i, $GUI_HIDE)
		Next
	Else
		For $i = $hLastDonateBtn1 To $hLastDonateBtn2 ; Hide last used controls on Donate Tab
			GUICtrlSetState($i, $GUI_HIDE)
		Next
	EndIf

	$hLastDonateBtn1 = $hFirstControl
	$hLastDonateBtn2 = $hLastControl

	;Show Controls
	For $i = $hFirstControl To $hLastControl ; Show these controls on Donate Tab
		GUICtrlSetState($i, $GUI_SHOW)
	Next
EndFunc   ;==>_DonateBtn

Func _DonateControls($iTroopIndex)
;	Local $bWasRedraw = SetRedrawBotWindow(False, Default, Default, Default, "_DonateControls")

	Local $iFirstTroop = 0, $iLastTroop = $eTroopCount - 1 + $g_iCustomDonateConfigs + $eSiegeMachineCount
	If $iTroopIndex <= $eTroopCount - 1 + $g_iCustomDonateConfigs Then
		$iLastTroop = $eTroopCount - 1 + $g_iCustomDonateConfigs
	Else
		$iFirstTroop = $eTroopCount + $g_iCustomDonateConfigs
	EndIf

	For $i = $iFirstTroop To $iLastTroop
		If $i = $iTroopIndex Then
			GUICtrlSetBkColor($g_ahLblDonateTroop[$i], $COLOR_ACTION)
		Else
			If GUICtrlGetBkColor($g_ahLblDonateTroop[$i]) = $COLOR_NAVY Then GUICtrlSetBkColor($g_ahLblDonateTroop[$i], $GUI_BKCOLOR_TRANSPARENT)
		EndIf

		If GUICtrlRead($g_ahChkDonateAllTroop[$i]) = $GUI_CHECKED Then GUICtrlSetState($g_ahChkDonateAllTroop[$i], $GUI_UNCHECKED)

		If BitAND(GUICtrlGetState($g_ahTxtDonateTroop[$i]), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($g_ahTxtDonateTroop[$i], $GUI_ENABLE)
		If BitAND(GUICtrlGetState($g_ahTxtBlacklistTroop[$i]), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($g_ahTxtBlacklistTroop[$i], $GUI_ENABLE)
	Next
;	SetRedrawBotWindowControls($bWasRedraw, $g_hGUI_DONATE_TAB, "_DonateControls") ; cannot use tab item here
EndFunc   ;==>_DonateControls

Func _DonateAllControls($iTroopIndex, $Set)
	Local $bWasRedraw = SetRedrawBotWindow(False, Default, Default, Default, "_DonateAllControls")

	Local $iFirstTroop = 0, $iLastTroop = $eTroopCount - 1 + $g_iCustomDonateConfigs + $eSiegeMachineCount
	If $iTroopIndex <= $eTroopCount - 1 + $g_iCustomDonateConfigs Then
		$iLastTroop = $eTroopCount - 1 + $g_iCustomDonateConfigs
	Else
		$iFirstTroop = $eTroopCount + $g_iCustomDonateConfigs
	EndIf

	If $Set = True Then
		For $i = $iFirstTroop To $iLastTroop
			GUICtrlSetBkColor($g_ahLblDonateTroop[$i], $i = $iTroopIndex ? $COLOR_NAVY : $GUI_BKCOLOR_TRANSPARENT)

			If $i <> $iTroopIndex Then
				GUICtrlSetState($g_ahChkDonateAllTroop[$i], $GUI_UNCHECKED)
			EndIf

			GUICtrlSetState($g_ahChkDonateTroop[$i], $GUI_UNCHECKED)
			If BitAND(GUICtrlGetState($g_ahTxtDonateTroop[$i]), $GUI_ENABLE) = $GUI_ENABLE Then GUICtrlSetState($g_ahTxtDonateTroop[$i], $GUI_DISABLE)
			If BitAND(GUICtrlGetState($g_ahTxtBlacklistTroop[$i]), $GUI_ENABLE) = $GUI_ENABLE Then GUICtrlSetState($g_ahTxtBlacklistTroop[$i], $GUI_DISABLE)
		Next

	Else
		GUICtrlSetBkColor($g_ahLblDonateTroop[$iTroopIndex], $GUI_BKCOLOR_TRANSPARENT)

		For $i = $iFirstTroop To $iLastTroop
			If BitAND(GUICtrlGetState($g_ahTxtDonateTroop[$i]), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($g_ahTxtDonateTroop[$i], $GUI_ENABLE)
			If BitAND(GUICtrlGetState($g_ahTxtBlacklistTroop[$i]), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($g_ahTxtBlacklistTroop[$i], $GUI_ENABLE)
		Next

	EndIf

	SetRedrawBotWindowControls($bWasRedraw, $g_hGUI_DONATE_TAB, "_DonateAllControls") ; cannot use tab item here
EndFunc   ;==>_DonateAllControls

Func _DonateControlsSpell($iSpellIndex)
	For $i = 0 To $eSpellCount - 1
		If $i = $iSpellIndex Then
			GUICtrlSetBkColor($g_ahLblDonateSpell[$i], $COLOR_ACTION)
		Else
			If GUICtrlGetBkColor($g_ahLblDonateSpell[$i]) = $COLOR_NAVY Then GUICtrlSetBkColor($g_ahLblDonateSpell[$i], $GUI_BKCOLOR_TRANSPARENT)
	    EndIf

		If GUICtrlRead($g_ahChkDonateAllSpell[$i]) = $GUI_CHECKED Then GUICtrlSetState($g_ahChkDonateAllSpell[$i], $GUI_UNCHECKED)

		If BitAND(GUICtrlGetState($g_ahTxtDonateSpell[$i]), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($g_ahTxtDonateSpell[$i], $GUI_ENABLE)
		If BitAND(GUICtrlGetState($g_ahTxtBlacklistSpell[$i]), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($g_ahTxtBlacklistSpell[$i], $GUI_ENABLE)
	Next
EndFunc   ;==>_DonateControlsSpell

Func _DonateAllControlsSpell($iSpellIndex, $Set)
	Local $bWasRedraw = SetRedrawBotWindow(False, Default, Default, Default, "_DonateAllControlsSpell")

	If $Set = True Then
		For $i = 0 To $eSpellCount - 1
			If $i = $iSpellIndex Then
				GUICtrlSetBkColor($g_ahLblDonateSpell[$i], $COLOR_NAVY)
			Else
				GUICtrlSetBkColor($g_ahLblDonateSpell[$i], $GUI_BKCOLOR_TRANSPARENT)
			EndIf

			If $i <> $iSpellIndex Then GUICtrlSetState($g_ahChkDonateAllSpell[$i], $GUI_UNCHECKED)

			GUICtrlSetState($g_ahChkDonateSpell[$i], $GUI_UNCHECKED)
			If BitAND(GUICtrlGetState($g_ahTxtDonateSpell[$i]), $GUI_ENABLE) = $GUI_ENABLE Then GUICtrlSetState($g_ahTxtDonateSpell[$i], $GUI_DISABLE)
			If BitAND(GUICtrlGetState($g_ahTxtBlacklistSpell[$i]), $GUI_ENABLE) = $GUI_ENABLE Then GUICtrlSetState($g_ahTxtBlacklistSpell[$i], $GUI_DISABLE)
		Next

	Else
		GUICtrlSetBkColor($g_ahLblDonateSpell[$iSpellIndex], $GUI_BKCOLOR_TRANSPARENT)

		For $i = 0 To $eSpellCount - 1
			If BitAND(GUICtrlGetState($g_ahTxtDonateSpell[$i]), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($g_ahTxtDonateSpell[$i], $GUI_ENABLE)
			If BitAND(GUICtrlGetState($g_ahTxtBlacklistSpell[$i]), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($g_ahTxtBlacklistSpell[$i], $GUI_ENABLE)
		Next

	EndIf

	SetRedrawBotWindowControls($bWasRedraw, $g_hGUI_DONATE_TAB, "_DonateAllControlsSpell") ; cannot use tab item here
EndFunc   ;==>_DonateAllControlsSpell

Func SetStateTxtGeneralBlacklist()
	Local $bDonateToSpecificKeyWord = False, $bDonateToAll = False
	For $i = 0 To $eTroopCount - 1 + $g_iCustomDonateConfigs + $eSiegeMachineCount
		If $bDonateToSpecificKeyWord Then ExitLoop
		If GUICtrlRead($g_ahChkDonateTroop[$i]) = $GUI_CHECKED Then $bDonateToSpecificKeyWord = True
		If GUICtrlRead($g_ahChkDonateAllTroop[$i]) = $GUI_CHECKED Then $bDonateToAll = True
		If $i >= $eSpellCount - 1 Then ContinueLoop
		If GUICtrlRead($g_ahChkDonateSpell[$i]) = $GUI_CHECKED Then $bDonateToSpecificKeyWord = True
		If GUICtrlRead($g_ahChkDonateAllSpell[$i]) = $GUI_CHECKED Then $bDonateToAll = True
	Next
	If $bDonateToSpecificKeyWord Or Not $bDonateToAll Then
		If BitAND(GUICtrlGetState($g_hTxtGeneralBlacklist), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($g_hTxtGeneralBlacklist, $GUI_ENABLE)
	ElseIf $bDonateToAll Then
		If BitAND(GUICtrlGetState($g_hTxtGeneralBlacklist), $GUI_ENABLE) = $GUI_ENABLE Then GUICtrlSetState($g_hTxtGeneralBlacklist, $GUI_DISABLE)
	EndIf
EndFunc

Func btnFilterDonationsCC()
	SetLog("open folder " & $g_sProfileDonateCapturePath, $COLOR_AQUA)
	ShellExecute("explorer", $g_sProfileDonateCapturePath)
EndFunc   ;==>btnFilterDonationsCC

Func chkskipDonateNearFulLTroopsEnable()
	If GUICtrlRead($g_hChkSkipDonateNearFullTroopsEnable) = $GUI_CHECKED Then
		GUICtrlSetState($g_hTxtSkipDonateNearFullTroopsPercentage, $GUI_ENABLE)
		GUICtrlSetState($g_hLblSkipDonateNearFullTroopsText, $GUI_ENABLE)
		GUICtrlSetState($g_hLblSkipDonateNearFullTroopsText1, $GUI_ENABLE)
	Else
		GUICtrlSetState($g_hTxtSkipDonateNearFullTroopsPercentage, $GUI_DISABLE)
		GUICtrlSetState($g_hLblSkipDonateNearFullTroopsText, $GUI_DISABLE)
		GUICtrlSetState($g_hLblSkipDonateNearFullTroopsText1, $GUI_DISABLE)
	EndIf
EndFunc   ;==>chkskipDonateNearFulLTroopsEnable

Func chkBalanceDR()
	If GUICtrlRead($g_hChkUseCCBalanced) = $GUI_CHECKED Then
		GUICtrlSetState($g_hCmbCCDonated, $GUI_ENABLE)
		GUICtrlSetState($g_hCmbCCReceived, $GUI_ENABLE)
	Else
		GUICtrlSetState($g_hCmbCCDonated, $GUI_DISABLE)
		GUICtrlSetState($g_hCmbCCReceived, $GUI_DISABLE)
	EndIf
EndFunc   ;==>chkBalanceDR

Func cmbBalanceDR()
	If _GUICtrlComboBox_GetCurSel($g_hCmbCCDonated) = _GUICtrlComboBox_GetCurSel($g_hCmbCCReceived) Then
		_GUICtrlComboBox_SetCurSel($g_hCmbCCDonated, 0)
		_GUICtrlComboBox_SetCurSel($g_hCmbCCReceived, 0)
	EndIf
EndFunc   ;==>cmbBalanceDR

Func Doncheck()
	tabDONATE() ; just call tabDONATE()
EndFunc   ;==>Doncheck

