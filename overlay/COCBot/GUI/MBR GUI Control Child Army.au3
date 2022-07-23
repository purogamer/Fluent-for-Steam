; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Control
; Description ...: This file Includes all functions to current GUI
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: GkevinOD (2014)
; Modified ......: Hervidero (2015), Boju (11-2016), MR.ViPER (11-2016), CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Func radSelectTrainType()
	If GUICtrlRead($g_hRadCustomTrain) = $GUI_CHECKED Then
		$g_bQuickTrainEnable = False
		_GUICtrlTab_ClickTab($g_hGUI_TRAINARMY_ARMY_TAB, 0)
		For $i = 0 To 2
			_GUI_Value_STATE("DISABLE", $g_ahChkArmy[$i] & "#" & $g_ahChkUseInGameArmy[$i] & "#" & $g_ahLblEditArmy[$i] & "#" & $g_ahBtnEditArmy[$i])
		Next
		_GUI_Value_STATE("ENABLE", $grpTrainTroops & "#" & $grpCookSpell)
		lblTotalCountTroop1()
		TotalSpellCountClick()
	Else
		$g_bQuickTrainEnable = True
		_GUICtrlTab_ClickTab($g_hGUI_TRAINARMY_ARMY_TAB, 1)
		_GUI_Value_STATE("ENABLE", $g_ahChkArmy[0] & "#" & $g_ahChkArmy[1] & "#" & $g_ahChkArmy[2])
		For $i = 0 To 2
			_chkQuickTrainArmy($i)
		Next
		_GUI_Value_STATE("DISABLE", $grpTrainTroops & "#" & $grpCookSpell)
		GUICtrlSetData($g_hLblTotalTimeCamp, " 0s")
		GUICtrlSetData($g_hLblTotalTimeSpell, " 0s")
		GUICtrlSetData($g_hLblElixirCostCamp, "0")
		GUICtrlSetData($g_hLblDarkCostCamp, "0")
		GUICtrlSetData($g_hLblElixirCostSpell, "0")
		GUICtrlSetData($g_hLblDarkCostSpell, "0")
	EndIf
	lblTotalCountSiege()
	chkSuperTroops() ; Custom Super Troops - Team AIO Mod++
EndFunc   ;==>radSelectTrainType

Func chkQuickTrainArmy()
	For $i = 0 To 2
		If @GUI_CtrlId = $g_ahChkArmy[$i] Then
			_chkQuickTrainArmy($i)
			ExitLoop
		EndIf
	Next
EndFunc   ;==>chkQuickTrainArmy

Func chkQuickTrainCombo()
	If GUICtrlRead($g_ahChkArmy[0]) = $GUI_UNCHECKED And GUICtrlRead($g_ahChkArmy[1]) = $GUI_UNCHECKED And GUICtrlRead($g_ahChkArmy[2]) = $GUI_UNCHECKED Then
		GUICtrlSetState($g_ahChkArmy[0], $GUI_CHECKED)
		ToolTip("QuickTrainCombo: " & @CRLF & "At least 1 Army Check is required! Default Army 1.")
		Sleep(2000)
		ToolTip('')
		_chkQuickTrainArmy(0)
	EndIf
EndFunc   ;==>chkQuickTrainCombo

Func _chkQuickTrainArmy($i)
	If GUICtrlRead($g_ahChkArmy[$i]) = $GUI_UNCHECKED Then
		_GUI_Value_STATE("DISABLE", $g_ahChkUseInGameArmy[$i] & "#" & $g_ahLblEditArmy[$i] & "#" & $g_ahBtnEditArmy[$i])
		GUICtrlSetState($g_ahLblUseInGameArmyNote[$i], $GUI_HIDE)
		If GUICtrlRead($g_ahChkArmy[0]) = $GUI_UNCHECKED And GUICtrlRead($g_ahChkArmy[1]) = $GUI_UNCHECKED And GUICtrlRead($g_ahChkArmy[2]) = $GUI_UNCHECKED Then chkQuickTrainCombo()
	Else
		_GUI_Value_STATE("ENABLE", $g_ahChkUseInGameArmy[$i] & "#" & $g_ahLblEditArmy[$i] & "#" & $g_ahBtnEditArmy[$i])
		_chkUseInGameArmy($i)
	EndIf
EndFunc   ;==>_chkQuickTrainArmy

Func chkUseInGameArmy()
	For $i = 0 To 2
		If @GUI_CtrlId = $g_ahChkUseInGameArmy[$i] Then
			_chkUseInGameArmy($i)
			ExitLoop
		EndIf
	Next
EndFunc   ;==>chkUseInGameArmy

Func _chkUseInGameArmy($i)
	If GUICtrlRead($g_ahChkUseInGameArmy[$i]) = $GUI_CHECKED Then
		For $j = $g_ahBtnEditArmy[$i] To $g_ahLblQuickSpell[$i][6]
			GUICtrlSetState($j, $GUI_HIDE)
		Next
		GUICtrlSetState($g_ahLblUseInGameArmyNote[$i], $GUI_SHOW)
	Else
		_GUI_Value_STATE("SHOW", $g_ahBtnEditArmy[$i] & "#" & $g_ahLblEditArmy[$i] & "#" & $g_ahLblTotalQTroop[$i] & "#" & $g_ahPicTotalQTroop[$i] & "#" & $g_ahLblTotalQSpell[$i] & "#" & $g_ahPicTotalQSpell[$i])
		GUICtrlSetState($g_ahLblUseInGameArmyNote[$i], $GUI_HIDE)
		For $j = 0 To 6
			If $g_aiQuickTroopType[$i][$j] > -1 Then _GUI_Value_STATE("SHOW", $g_ahPicQuickTroop[$i][$j] & "#" & $g_ahLblQuickTroop[$i][$j])
			If $g_aiQuickSpellType[$i][$j] > -1 Then _GUI_Value_STATE("SHOW", $g_ahPicQuickSpell[$i][$j] & "#" & $g_ahLblQuickSpell[$i][$j])
		Next
		ApplyQuickTrainArmy($i)
	EndIf
EndFunc   ;==>_chkUseInGameArmy

Func SetComboTroopComp()
	Local $bWasRedraw = SetRedrawBotWindow(False, Default, Default, Default, "SetComboTroopComp")
	Local $ArmyCampTemp = 0

	If GUICtrlRead($g_hChkTotalCampForced) = $GUI_CHECKED Then
		$ArmyCampTemp = Floor(GUICtrlRead($g_hTxtTotalCampForced) * GUICtrlRead($g_hTxtFullTroop) / 100)
	Else
		$ArmyCampTemp = Floor($g_iTotalCampSpace * GUICtrlRead($g_hTxtFullTroop) / 100)
	EndIf

	Local $TotalTroopsToTrain = 0

	lblTotalCountTroop1()
	SetRedrawBotWindow($bWasRedraw, Default, Default, Default, "SetComboTroopComp")
EndFunc   ;==>SetComboTroopComp

Func chkTotalCampForced()
	GUICtrlSetState($g_hTxtTotalCampForced, GUICtrlRead($g_hChkTotalCampForced) = $GUI_CHECKED ? $GUI_ENABLE : $GUI_DISABLE)
EndFunc   ;==>chkTotalCampForced

#Region - Custom train - Team AIO Mod++
Func chkDoubleTrain()
	$g_bDoubleTrain = (GUICtrlRead($g_hChkDoubleTrain) = $GUI_CHECKED)
	$g_bChkPreTrainTroopsPercent = (GUICtrlRead($g_hChkPreTrainTroopsPercent) = $GUI_CHECKED)

	GUICtrlSetState($g_hInpPreTrainTroopsPercent, ($g_bDoubleTrain = True And $g_bChkPreTrainTroopsPercent = True) ? ($GUI_ENABLE) : ($GUI_DISABLE))
	GUICtrlSetState($g_hChkPreTrainTroopsPercent, ($g_bDoubleTrain = True) ? ($GUI_SHOW) : ($GUI_HIDE))
	GUICtrlSetState($g_hLblPreTrainTroopsPercent, ($g_bDoubleTrain = True) ? ($GUI_SHOW) : ($GUI_HIDE))
	GUICtrlSetState($g_hInpPreTrainTroopsPercent, ($g_bDoubleTrain = True) ? ($GUI_SHOW) : ($GUI_HIDE))

	GUICtrlSetState($g_hChkTrainBeforeAttack, ($g_bDoubleTrain = False) ? ($GUI_SHOW) : ($GUI_HIDE))
EndFunc   ;==>chkTotalCampForced
#EndRegion - Custom train - Team AIO Mod++

Func lblTotalCountTroop1()
	; Calculate count of troops, set progress bars, colors
	Local $TotalTroopsToTrain = 0
	Local $ArmyCampTemp = 0

	If GUICtrlRead($g_hChkTotalCampForced) = $GUI_CHECKED Then
		$ArmyCampTemp = Floor(GUICtrlRead($g_hTxtTotalCampForced) * GUICtrlRead($g_hTxtFullTroop) / 100)
	Else
		$ArmyCampTemp = Floor($g_iTotalCampSpace * GUICtrlRead($g_hTxtFullTroop) / 100)
	EndIf

	For $i = 0 To $eTroopCount - 1
		Local $iCount = GUICtrlRead($g_ahTxtTrainArmyTroopCount[$i])
		If $iCount > 0 Then
			$TotalTroopsToTrain += $iCount * $g_aiTroopSpace[$i]
		Else
			GUICtrlSetData($g_ahTxtTrainArmyTroopCount[$i], 0)
		EndIf
	Next

	GUICtrlSetData($g_hLblCountTotal, String($TotalTroopsToTrain))

	If GUICtrlRead($g_hChkTotalCampForced) = $GUI_CHECKED And GUICtrlRead($g_hLblCountTotal) = GUICtrlRead($g_hTxtTotalCampForced) Then
		GUICtrlSetBkColor($g_hLblCountTotal, $_COLOR_MONEYGREEN)
	ElseIf GUICtrlRead($g_hLblCountTotal) = $ArmyCampTemp Then
		GUICtrlSetBkColor($g_hLblCountTotal, $_COLOR_MONEYGREEN)
	ElseIf GUICtrlRead($g_hLblCountTotal) > $ArmyCampTemp / 2 And GUICtrlRead($g_hLblCountTotal) < $ArmyCampTemp Then
		GUICtrlSetBkColor($g_hLblCountTotal, $COLOR_ACTION)
	Else
		GUICtrlSetBkColor($g_hLblCountTotal, $COLOR_RED)
	EndIf

	Local $fPctOfForced = Floor((GUICtrlRead($g_hLblCountTotal) / GUICtrlRead($g_hTxtTotalCampForced)) * 100)
	Local $fPctOfCalculated = Floor((GUICtrlRead($g_hLblCountTotal) / $ArmyCampTemp) * 100)

	If GUICtrlRead($g_hChkTotalCampForced) = $GUI_CHECKED Then
		GUICtrlSetData($g_hCalTotalTroops, $fPctOfForced < 1 ? (GUICtrlRead($g_hLblCountTotal) > 0 ? 1 : 0) : $fPctOfForced)
	Else
		GUICtrlSetData($g_hCalTotalTroops, $fPctOfCalculated < 1 ? (GUICtrlRead($g_hLblCountTotal) > 0 ? 1 : 0) : $fPctOfCalculated)
	EndIf

	If GUICtrlRead($g_hChkTotalCampForced) = $GUI_CHECKED And GUICtrlRead($g_hLblCountTotal) > GUICtrlRead($g_hTxtTotalCampForced) Then
		GUICtrlSetState($g_hLblTotalProgress, $GUI_SHOW)
	ElseIf GUICtrlRead($g_hLblCountTotal) > $ArmyCampTemp Then
		GUICtrlSetState($g_hLblTotalProgress, $GUI_SHOW)
	Else
		; GUICtrlSetState($g_hLblTotalProgress, $GUI_HIDE)
	EndIf

	lblTotalCountTroop2()
EndFunc   ;==>lblTotalCountTroop1

Func lblTotalCountTroop2()
	; Calculate time for troops
	Local $TotalTotalTimeTroop = 0
    Local $NbrOfBarrack = 4 ; Elixir Barrack

	For $i = $eTroopBarbarian To $eTroopHeadhunter
		If $i > $eTroopDragonRider Then $NbrOfBarrack = 2 ; Dark Elixir Barrack
		Local $NbrOfTroop = GUICtrlRead($g_ahTxtTrainArmyTroopCount[$i])
		If $NbrOfTroop > 0 Then
			$TotalTotalTimeTroop += $NbrOfTroop * ($g_aiTroopTrainTime[$i] / $NbrOfBarrack)
		EndIf
	Next

	$TotalTotalTimeTroop = CalculTimeTo($TotalTotalTimeTroop)
	GUICtrlSetData($g_hLblTotalTimeCamp, $TotalTotalTimeTroop)
EndFunc   ;==>lblTotalCountTroop2

Func lblTotalCountSpell2()
	; calculate total space and time for spell composition
	Local $iTotalTotalTimeSpell = 0
	$g_iTotalTrainSpaceSpell = 0

	For $i = 0 To $eSpellCount - 1
		$g_iTotalTrainSpaceSpell += $g_aiArmyCustomSpells[$i] * $g_aiSpellSpace[$i]
		$iTotalTotalTimeSpell += $g_aiArmyCustomSpells[$i] * $g_aiSpellTrainTime[$i]
	Next

	For $i = 0 To $eSpellCount - 1
		GUICtrlSetBkColor($g_ahTxtTrainArmySpellCount[$i], $g_iTotalTrainSpaceSpell <= GUICtrlRead($g_hTxtTotalCountSpell) ? 0xD1DFE7 : $COLOR_RED) ; Custom - Team AIO Mod++
	Next

	GUICtrlSetData($g_hLblTotalTimeSpell, CalculTimeTo($iTotalTotalTimeSpell))
EndFunc   ;==>lblTotalCountSpell2

Func lblTotalCountSiege()
	; calculate total space and time for Siege composition
	Local $iTotalTotalTimeSiege = 0, $indexLevel = 0
	$g_iTotalTrainSpaceSiege = 0

	For $i = 0 To $eSiegeMachineCount - 1
		$g_iTotalTrainSpaceSiege += $g_aiArmyCompSiegeMachines[$i] * $g_aiSiegeMachineSpace[$i]
		$iTotalTotalTimeSiege += $g_aiArmyCompSiegeMachines[$i] * $g_aiSiegeMachineTrainTimePerLevel[$i][1]
	Next

	GUICtrlSetData($g_hLblTotalTimeSiege, CalculTimeTo($iTotalTotalTimeSiege))
	GUICtrlSetData($g_hLblCountTotalSiege, $g_iTotalTrainSpaceSiege)
	GUICtrlSetBkColor($g_hLblCountTotalSiege, $g_iTotalTrainSpaceSiege <= 3 ? $_COLOR_MONEYGREEN : $COLOR_RED)

	; prepared for some new TH level !!
	If $g_iTownHallLevel > 0 And $g_iTownHallLevel < 12 Then
		$g_iTotalTrainSpaceSiege = 0
		_GUI_Value_STATE("DISABLE", $groupListSieges)
	Else
		_GUI_Value_STATE("ENABLE", $groupListSieges)
	EndIf
EndFunc   ;==>lblTotalCountSiege

Func TotalSpellCountClick()
	Local $bWasRedraw = SetRedrawBotWindow(False, Default, Default, Default, "TotalSpellCountClick")
	_GUI_Value_STATE("DISABLE", $groupListSpells)
	$g_iTownHallLevel = Int($g_iTownHallLevel)

	If $g_iTownHallLevel > 4 Or $g_iTownHallLevel = 0 Then
		_GUI_Value_STATE("ENABLE", $groupLightning)
	Else
		For $i = 0 To $eSpellCount - 1
			GUICtrlSetData($g_ahTxtTrainArmySpellCount[$i], 0)
			GUICtrlSetData($g_ahLblTrainArmySpellLevel[$i], 0)
		Next
		GUICtrlSetData($g_hTxtTotalCountSpell, 0)
	EndIf

	If $g_iTownHallLevel > 5 Or $g_iTownHallLevel = 0 Then
		_GUI_Value_STATE("ENABLE", $groupHeal)
	Else
		For $i = $eSpellRage To $eSpellBat
			GUICtrlSetData($g_ahTxtTrainArmySpellCount[$i], 0)
			GUICtrlSetData($g_ahLblTrainArmySpellLevel[$i], 0)
		Next
	EndIf

	If $g_iTownHallLevel > 6 Or $g_iTownHallLevel = 0 Then
		_GUI_Value_STATE("ENABLE", $groupRage)
	Else
		For $i = $eSpellJump To $eSpellBat
			GUICtrlSetData($g_ahTxtTrainArmySpellCount[$i], 0)
			GUICtrlSetData($g_ahLblTrainArmySpellLevel[$i], 0)
		Next
	EndIf

	If $g_iTownHallLevel > 7 Or $g_iTownHallLevel = 0 Then
		_GUI_Value_STATE("ENABLE", $groupPoison)
		_GUI_Value_STATE("ENABLE", $groupEarthquake)
	Else
		GUICtrlSetData($g_ahTxtTrainArmySpellCount[$eSpellJump], 0)
		GUICtrlSetData($g_ahTxtTrainArmySpellCount[$eSpellFreeze], 0)
		GUICtrlSetData($g_ahTxtTrainArmySpellCount[$eSpellClone], 0)
		GUICtrlSetData($g_ahTxtTrainArmySpellCount[$eSpellInvisibility], 0)
		GUICtrlSetData($g_ahTxtTrainArmySpellCount[$eSpellHaste], 0)
		GUICtrlSetData($g_ahTxtTrainArmySpellCount[$eSpellSkeleton], 0)
		GUICtrlSetData($g_ahTxtTrainArmySpellCount[$eSpellBat], 0)
		GUICtrlSetData($g_ahLblTrainArmySpellLevel[$eSpellJump], 0)
		GUICtrlSetData($g_ahLblTrainArmySpellLevel[$eSpellFreeze], 0)
		GUICtrlSetData($g_ahLblTrainArmySpellLevel[$eSpellClone], 0)
		GUICtrlSetData($g_ahLblTrainArmySpellLevel[$eSpellInvisibility], 0)
		GUICtrlSetData($g_ahLblTrainArmySpellLevel[$eSpellHaste], 0)
		GUICtrlSetData($g_ahLblTrainArmySpellLevel[$eSpellSkeleton], 0)
		GUICtrlSetData($g_ahLblTrainArmySpellLevel[$eSpellBat], 0)
	EndIf

	If $g_iTownHallLevel > 8 Or $g_iTownHallLevel = 0 Then
		_GUI_Value_STATE("ENABLE", $groupJump)
		_GUI_Value_STATE("ENABLE", $groupFreeze)
		_GUI_Value_STATE("ENABLE", $groupHaste)
		_GUI_Value_STATE("ENABLE", $groupSkeleton)
	Else
		GUICtrlSetData($g_ahTxtTrainArmySpellCount[$eSpellClone], 0)
		GUICtrlSetData($g_ahTxtTrainArmySpellCount[$eSpellBat], 0)
		GUICtrlSetData($g_ahTxtTrainArmySpellCount[$eSpellInvisibility], 0)
		GUICtrlSetData($g_ahLblTrainArmySpellLevel[$eSpellClone], 0)
		GUICtrlSetData($g_ahLblTrainArmySpellLevel[$eSpellBat], 0)
		GUICtrlSetData($g_ahLblTrainArmySpellLevel[$eSpellInvisibility], 0)
	EndIf

	If $g_iTownHallLevel > 9 Or $g_iTownHallLevel = 0 Then
		_GUI_Value_STATE("ENABLE", $groupClone)
		_GUI_Value_STATE("ENABLE", $groupBat)
	Else
		GUICtrlSetData($g_ahTxtTrainArmySpellCount[$eSpellInvisibility], 0)
		GUICtrlSetData($g_ahLblTrainArmySpellLevel[$eSpellInvisibility], 0)
	EndIf

	If $g_iTownHallLevel > 10 Or $g_iTownHallLevel = 0 Then
		_GUI_Value_STATE("ENABLE", $groupInvisibility)
	EndIf

	lblTotalCountSpell2()
	SetRedrawBotWindow($bWasRedraw, Default, Default, Default, "TotalSpellCountClick")
EndFunc   ;==>TotalSpellCountClick

Func chkBoostBarracksHoursE1()
	If GUICtrlRead($g_hChkBoostBarracksHoursE1) = $GUI_CHECKED And GUICtrlRead($g_hChkBoostBarracksHours[0]) = $GUI_CHECKED Then
		For $i = 0 To 11
			GUICtrlSetState($g_hChkBoostBarracksHours[$i], $GUI_UNCHECKED)
		Next
	Else
		For $i = 0 To 11
			GUICtrlSetState($g_hChkBoostBarracksHours[$i], $GUI_CHECKED)
		Next
	EndIf
	Sleep(300)
	GUICtrlSetState($g_hChkBoostBarracksHoursE1, $GUI_UNCHECKED)
EndFunc   ;==>chkBoostBarracksHoursE1

Func chkBoostBarracksHoursE2()
	If GUICtrlRead($g_hChkBoostBarracksHoursE2) = $GUI_CHECKED And GUICtrlRead($g_hChkBoostBarracksHours[12]) = $GUI_CHECKED Then
		For $i = 12 To 23
			GUICtrlSetState($g_hChkBoostBarracksHours[$i], $GUI_UNCHECKED)
		Next
	Else
		For $i = 12 To 23
			GUICtrlSetState($g_hChkBoostBarracksHours[$i], $GUI_CHECKED)
		Next
	EndIf
	Sleep(300)
	GUICtrlSetState($g_hChkBoostBarracksHoursE2, $GUI_UNCHECKED)
EndFunc   ;==>chkBoostBarracksHoursE2

Func chkCloseWaitEnable()
	If GUICtrlRead($g_hChkCloseWhileTraining) = $GUI_CHECKED Then
		$g_bCloseWhileTrainingEnable = True
		_GUI_Value_STATE("ENABLE", $groupCloseWhileTraining)

		; Max logout time - Team AiO MOD++
		_GUI_Value_STATE("ENABLE", $g_hLblCloseWaitingTroops & "#" & $g_hCmbMinimumTimeClose & "#" & $g_hLblSymbolWaiting & "#" & $g_hLblWaitingInMinutes & "#" & $g_hChkTrainLogoutMaxTime)
		chkTrainLogoutMaxTime()
	Else
		$g_bCloseWhileTrainingEnable = False
		_GUI_Value_STATE("DISABLE", $groupCloseWhileTraining)

		; Max logout time - Team AiO MOD++
		_GUI_Value_STATE("DISABLE", $g_hLblCloseWaitingTroops & "#" & $g_hCmbMinimumTimeClose & "#" & $g_hLblSymbolWaiting & "#" & $g_hLblWaitingInMinutes & "#" & $g_hChkTrainLogoutMaxTime & "#" & $g_hTxtTrainLogoutMaxTime & "#" & $g_hLblTrainLogoutMaxTime)
		_GUI_Value_STATE("UNCHECKED", $g_hChkTrainLogoutMaxTime)
	EndIf
	If GUICtrlRead($g_hChkRandomClose) = $GUI_CHECKED Then
		GUICtrlSetState($g_hChkCloseEmulator, BitOR($GUI_DISABLE, $GUI_UNCHECKED))
		GUICtrlSetState($g_hChkSuspendComputer, BitOR($GUI_DISABLE, $GUI_UNCHECKED))
	Else
		If GUICtrlRead($g_hChkCloseWhileTraining) = $GUI_CHECKED Then
			GUICtrlSetState($g_hChkCloseEmulator, $GUI_ENABLE)
			GUICtrlSetState($g_hChkSuspendComputer, $GUI_ENABLE)
		EndIf
	EndIf
EndFunc   ;==>chkCloseWaitEnable

Func chkCloseWaitTrain()
	$g_bCloseWithoutShield = (GUICtrlRead($g_hChkCloseWithoutShield) = $GUI_CHECKED)
EndFunc   ;==>chkCloseWaitTrain

Func btnCloseWaitStop()
	$g_bCloseEmulator = (GUICtrlRead($g_hChkCloseEmulator) = $GUI_CHECKED)
EndFunc   ;==>btnCloseWaitStop

Func btnCloseWaitSuspendComputer()
	$g_bSuspendComputer = (GUICtrlRead($g_hChkSuspendComputer) = $GUI_CHECKED)
EndFunc   ;==>btnCloseWaitSuspendComputer

Func btnCloseWaitStopRandom()
	If GUICtrlRead($g_hChkRandomClose) = $GUI_CHECKED Then
		$g_bCloseRandom = True
		$g_bCloseEmulator = False
		$g_bSuspendComputer = False
		GUICtrlSetState($g_hChkCloseEmulator, BitOR($GUI_DISABLE, $GUI_UNCHECKED))
		GUICtrlSetState($g_hChkSuspendComputer, BitOR($GUI_DISABLE, $GUI_UNCHECKED))
	Else
		$g_bCloseRandom = False
		If GUICtrlRead($g_hChkCloseWhileTraining) = $GUI_CHECKED Then
			GUICtrlSetState($g_hChkCloseEmulator, $GUI_ENABLE)
			GUICtrlSetState($g_hChkSuspendComputer, $GUI_ENABLE)
		EndIf
	EndIf
EndFunc   ;==>btnCloseWaitStopRandom

Func btnCloseWaitRandom()
	If GUICtrlRead($g_hRdoCloseWaitExact) = $GUI_CHECKED Then
		$g_bCloseExactTime = True
		$g_bCloseRandomTime = False
		GUICtrlSetState($g_hCmbCloseWaitRdmPercent, $GUI_DISABLE)
	ElseIf GUICtrlRead($g_hRdoCloseWaitRandom) = $GUI_CHECKED Then
		$g_bCloseExactTime = False
		$g_bCloseRandomTime = True
		If GUICtrlRead($g_hChkCloseWhileTraining) = $GUI_CHECKED Then GUICtrlSetState($g_hCmbCloseWaitRdmPercent, $GUI_ENABLE)
	Else
		$g_bCloseExactTime = False
		$g_bCloseRandomTime = False
		GUICtrlSetState($g_hCmbCloseWaitRdmPercent, $GUI_DISABLE)
	EndIf
EndFunc   ;==>btnCloseWaitRandom

Func sldTrainITDelay()
	$g_iTrainClickDelay = GUICtrlRead($g_hSldTrainITDelay)
	GUICtrlSetData($g_hLblTrainITDelayTime, $g_iTrainClickDelay & " ms")
EndFunc   ;==>sldTrainITDelay

Func GUISpellsOrder()
	For $i = 0 To UBound($g_ahCmbSpellsOrder[$i]) - 1 ; check for duplicate combobox index and flag problem
		$g_aiCmbCustomBrewOrder[$i] = _GUICtrlComboBox_GetCurSel($g_ahCmbSpellsOrder[$i])
	Next
EndFunc   ;==>_GUITrainOrder

Func _GUISpellsOrder()
	Local $iGUI_CtrlId = @GUI_CtrlId
	Local $i = _ArraySearch($g_ahCmbSpellsOrder, @GUI_CtrlId)
	Local $iOld = $g_aiCmbCustomBrewOrder[$i]

	For $i = 0 To UBound($g_ahCmbSpellsOrder) - 1 ; check for duplicate combobox index and flag problem
		If $iGUI_CtrlId = $g_ahCmbSpellsOrder[$i] Then ContinueLoop
		If _GUICtrlComboBox_GetCurSel($iGUI_CtrlId) = _GUICtrlComboBox_GetCurSel($g_ahCmbSpellsOrder[$i]) Then
			_GUICtrlComboBox_SetCurSel($g_ahCmbSpellsOrder[$i], $iOld)
			GUISetState()
		EndIf
	Next

	For $i = 0 To UBound($g_ahCmbSpellsOrder) - 1 ; check for duplicate combobox index and flag problem
		$g_aiCmbCustomBrewOrder[$i] = _GUICtrlComboBox_GetCurSel($g_ahCmbSpellsOrder[$i])
	Next
EndFunc   ;==>_GUISpellsOrder

Func BtnRemoveSpells()
	For $i = 0 To UBound($g_ahCmbSpellsOrder) - 1 ; check for duplicate combobox index and flag problem
		_GUICtrlComboBox_SetCurSel($g_ahCmbSpellsOrder[$i], $i)
		GUISetState()
	Next
	GUISpellsOrder()
EndFunc   ;==>BtnRemoveSpells

Func GUITrainOrder()
	For $i = 0 To UBound($g_ahCmbTroopOrder) - 1 ; check for duplicate combobox index and flag problem
		$g_aiCmbCustomTrainOrder[$i] = _GUICtrlComboBox_GetCurSel($g_ahCmbTroopOrder[$i])
	Next
EndFunc   ;==>_GUITrainOrder

Func _GUITrainOrder()
	Local $iGUI_CtrlId = @GUI_CtrlId
	Local $i = _ArraySearch($g_ahCmbTroopOrder, @GUI_CtrlId)
	Local $iOld = $g_aiCmbCustomTrainOrder[$i]

	For $i = 0 To UBound($g_ahCmbTroopOrder) - 1 ; check for duplicate combobox index and flag problem
		If $iGUI_CtrlId = $g_ahCmbTroopOrder[$i] Then ContinueLoop
		If _GUICtrlComboBox_GetCurSel($iGUI_CtrlId) = _GUICtrlComboBox_GetCurSel($g_ahCmbTroopOrder[$i]) Then
			_GUICtrlComboBox_SetCurSel($g_ahCmbTroopOrder[$i], $iOld)
			GUISetState()
		EndIf
	Next

	For $i = 0 To UBound($g_ahCmbTroopOrder) - 1 ; check for duplicate combobox index and flag problem
		$g_aiCmbCustomTrainOrder[$i] = _GUICtrlComboBox_GetCurSel($g_ahCmbTroopOrder[$i])
	Next
EndFunc   ;==>_GUITrainOrder

Func Orden(ByRef $aArray)
	Local Const $iMax = UBound($aArray) - 1
	Local $iNum = -1
	For $i = 0 To $iMax
		If $aArray[$i] > $iMax Or $aArray[$i] < 0 Or Not StringIsDigit($aArray[$i]) Or _
			($i > 1 And _ArraySearch($aArray, $aArray[$i], 0, $i-1) >= 0) Or ($i = 1 And $aArray[0] = $aArray[1]) Then
			Do
				$iNum += 1
			Until _ArraySearch($aArray, $iNum) < 0
			$aArray[$i] = $iNum
		EndIf
	Next
EndFunc

Func CustomTrainOrderEnable()
	$g_bCustomTrainOrderEnable = (GUICtrlRead($g_hChkCustomTrainOrderEnable) = $GUI_CHECKED)

	For $i = 0 To UBound($g_ahCmbTroopOrder) - 1
		GUICtrlSetState($g_ahCmbTroopOrder[$i], $g_bCustomTrainOrderEnable ? $GUI_ENABLE : $GUI_DISABLE)
	Next

	Local $iTmp = 0, $iTmp2 = 0
	$iTmp2 = UBound($g_ahCmbTroopOrder) - 1
	If $g_bCustomTrainOrderEnable = False Then
		For $z = 0 To $iTmp2
			$g_aiTrainOrder[$z] = $z
		Next
	Else
		Orden($g_aiCmbCustomTrainOrder)
		For $z = 0 To $iTmp2
			$iTmp = Abs(Number($g_aiCmbCustomTrainOrder[$z]))
			$g_aiTrainOrder[$iTmp] = $z
		Next
	EndIf

EndFunc   ;==>CustomTrainOrderEnable

Func CustomBrewOrderEnable()
	$g_bCustomBrewOrderEnable = (GUICtrlRead($g_hChkCustomBrewOrderEnable) = $GUI_CHECKED)

	For $i = 0 To UBound($g_ahCmbSpellsOrder) - 1
		GUICtrlSetState($g_ahCmbSpellsOrder[$i], $g_bCustomBrewOrderEnable ? $GUI_ENABLE : $GUI_DISABLE)
	Next

	Local $iTmp = 0, $iTmp2 = 0
	$iTmp2 = UBound($g_ahCmbSpellsOrder) - 1
	If $g_bCustomBrewOrderEnable = False Then
		For $z = 0 To $iTmp2
			$g_aiBrewOrder[$z] = $z
		Next
	Else
		Orden($g_aiCmbCustomBrewOrder)
		For $z = 0 To $iTmp2
			$iTmp =	Abs(Number($g_aiCmbCustomBrewOrder[$z]))
			$g_aiBrewOrder[$iTmp] = $z
		Next
	EndIf
EndFunc   ;==>CustomBrewOrderEnable

Func CustomBuildOrderEnable()
    $g_bCustomBuildOrderEnable = (GUICtrlRead($g_hChkCustomBuildOrderEnable) = $GUI_CHECKED)

    For $i = 0 To UBound($g_ahCmbSiegesOrder) - 1
        GUICtrlSetState($g_ahCmbSiegesOrder[$i], $g_bCustomBuildOrderEnable ? $GUI_ENABLE : $GUI_DISABLE)
    Next

	Local $iTmp = 0, $iTmp2 = 0
	$iTmp2 = UBound($g_ahCmbSiegesOrder) - 1
	If $g_bCustomBuildOrderEnable = False Then
		For $z = 0 To $iTmp2
			$g_aiBuildOrder[$z] = $z
		Next
	Else
		Orden($g_aiCmbCustomBuildOrder)
		For $z = 0 To $iTmp2
			$iTmp =	Abs(Number($g_aiCmbCustomBuildOrder[$z]))
			$g_aiBuildOrder[$iTmp] = $z
		Next
	EndIf
EndFunc   ;==>CustomBuildOrderEnable

Func BtnRemoveTroops()
	For $i = 0 To UBound($g_ahCmbTroopOrder) - 1 ; check for duplicate combobox index and flag problem
		_GUICtrlComboBox_SetCurSel($g_ahCmbTroopOrder[$i], $i)
		GUISetState()
	Next
	GUITrainOrder()
EndFunc   ;==>BtnRemoveTroops

Func _GUIBuildOrder()
    Local $iGUI_CtrlId = @GUI_CtrlId
    Local $i = _ArraySearch($g_ahCmbSiegesOrder, @GUI_CtrlId)
    Local $iOld = $g_aiCmbCustomBuildOrder[$i]

    For $i = 0 To UBound($g_ahCmbSiegesOrder) - 1 ; check for duplicate combobox index and flag problem
        If $iGUI_CtrlId = $g_ahCmbSiegesOrder[$i] Then ContinueLoop
        If _GUICtrlComboBox_GetCurSel($iGUI_CtrlId) = _GUICtrlComboBox_GetCurSel($g_ahCmbSiegesOrder[$i]) Then
            _GUICtrlComboBox_SetCurSel($g_ahCmbSiegesOrder[$i], $iOld)
            GUISetState()
        EndIf
    Next

    For $i = 0 To UBound($g_ahCmbSiegesOrder) - 1 ; check for duplicate combobox index and flag problem
        $g_aiCmbCustomBuildOrder[$i] = _GUICtrlComboBox_GetCurSel($g_ahCmbSiegesOrder[$i])
    Next
EndFunc   ;==>_GUIBuildOrder

Func BtnRemoveSieges()
    For $i = 0 To UBound($g_ahCmbSiegesOrder) - 1 ; check for duplicate combobox index and flag problem
        _GUICtrlComboBox_SetCurSel($g_ahCmbSiegesOrder[$i], $i)
        GUISetState()
    Next
    GUIBuildOrder()
EndFunc   ;==>BtnRemoveSieges

Func GUIBuildOrder()
    For $i = 0 To UBound($g_ahCmbSiegesOrder) - 1 ; check for duplicate combobox index and flag problem
        $g_aiCmbCustomBuildOrder[$i] = _GUICtrlComboBox_GetCurSel($g_ahCmbSiegesOrder[$i])
    Next
EndFunc   ;==>_GUITrainOrder

Func CalculTimeTo($TotalTotalTime)
	Local $HourToTrain = 0
	Local $MinToTrain = 0
	Local $SecToTrain = 0
	Local $TotalTotalTimeTo
	If $TotalTotalTime >= 3600 Then
		$HourToTrain = Int($TotalTotalTime / 3600)
		$MinToTrain = Int(($TotalTotalTime - $HourToTrain * 3600) / 60)
		$SecToTrain = $TotalTotalTime - $HourToTrain * 3600 - $MinToTrain * 60
		$TotalTotalTimeTo = " " & $HourToTrain & "h " & $MinToTrain & "m " & $SecToTrain & "s"
	ElseIf $TotalTotalTime < 3600 And $TotalTotalTime >= 60 Then
		$MinToTrain = Int(($TotalTotalTime - $HourToTrain * 3600) / 60)
		$SecToTrain = $TotalTotalTime - $HourToTrain * 3600 - $MinToTrain * 60
		$TotalTotalTimeTo = " " & $MinToTrain & "m " & $SecToTrain & "s"
	Else
		$SecToTrain = $TotalTotalTime
		$TotalTotalTimeTo = " " & $SecToTrain & "s"
	EndIf
	Return $TotalTotalTimeTo
EndFunc   ;==>CalculTimeTo

Func Removecamptroops()
	For $T = 0 To $eTroopCount - 1
		$g_aiArmyCustomTroops[$T] = 0
		$g_aiTrainArmyTroopLevel[$T] = 0
		GUICtrlSetData($g_ahTxtTrainArmyTroopCount[$T], $g_aiArmyCustomTroops[$T])
		GUICtrlSetData($g_ahLblTrainArmyTroopLevel[$T], $g_aiTrainArmyTroopLevel[$T])
	Next

	GUICtrlSetData($g_hCalTotalTroops, 0)
	GUICtrlSetData($g_hLblTotalTimeCamp, " 0s")
	GUICtrlSetData($g_hLblElixirCostCamp, "0")
	GUICtrlSetData($g_hLblDarkCostCamp, "0")
	GUICtrlSetData($g_hLblCountTotal, 0)
	GUICtrlSetBkColor($g_hLblCountTotal, $_COLOR_MONEYGREEN)

	; BtnRemoveTroops()
EndFunc   ;==>Removecamptroops

Func Removecampspells()
	For $S = 0 To $eSpellCount - 1
		$g_aiArmyCustomSpells[$S] = 0
		$g_aiTrainArmySpellLevel[$S] = 0
		GUICtrlSetData($g_ahTxtTrainArmySpellCount[$S], $g_aiArmyCustomSpells[$S])
		GUICtrlSetData($g_ahLblTrainArmySpellLevel[$S], $g_aiTrainArmySpellLevel[$S])
	Next

	GUICtrlSetData($g_hLblTotalTimeSpell, " 0s")
	GUICtrlSetData($g_hLblElixirCostSpell, "0")
	GUICtrlSetData($g_hLblDarkCostSpell, "0")
	For $i = 0 To $eSpellCount - 1
		GUICtrlSetBkColor($g_ahTxtTrainArmySpellCount[$i], 0xD1DFE7) ; Custom - Team AIO Mod++
	Next

	; BtnRemoveSpells()
EndFunc   ;==>Removecampspells

Func Removecampsieges()
	For $S = 0 To $eSiegeMachineCount - 1
		$g_aiArmyCompSiegeMachines[$S] = 0
		$g_aiTrainArmySiegeMachineLevel[$S] = 0
		GUICtrlSetData($g_ahTxtTrainArmySiegeCount[$S], $g_aiArmyCompSiegeMachines[$S])
		GUICtrlSetData($g_ahLblTrainArmySiegeLevel[$S], $g_aiTrainArmySiegeMachineLevel[$S])
	Next

	GUICtrlSetData($g_hLblGoldCostSiege, "0")
	GUICtrlSetData($g_hLblCountTotalSiege, 0)
	GUICtrlSetData($g_hLblTotalTimeSiege, " 0s")
	GUICtrlSetBkColor($g_hLblCountTotalSiege, $_COLOR_MONEYGREEN)

EndFunc   ;==>Removecampsieges

Func TrainTroopCountEdit()
	For $i = 0 To $eTroopCount - 1
		If @GUI_CtrlId = $g_ahTxtTrainArmyTroopCount[$i] Then
			$g_aiArmyCustomTroops[$i] = GUICtrlRead($g_ahTxtTrainArmyTroopCount[$i])
			lblTotalCountTroop1()
			Return
		EndIf
	Next
EndFunc   ;==>TrainTroopCountEdit

Func TrainSiegeCountEdit()
	For $i = 0 To $eSiegeMachineCount - 1
		If @GUI_CtrlId = $g_ahTxtTrainArmySiegeCount[$i] Then
			$g_aiArmyCompSiegeMachines[$i] = GUICtrlRead($g_ahTxtTrainArmySiegeCount[$i])
			lblTotalCountSiege()
			Return
		EndIf
	Next
EndFunc   ;==>TrainSiegeCountEdit

Func TrainSpellCountEdit()
	For $i = 0 To $eSpellCount - 1
		If @GUI_CtrlId = $g_ahTxtTrainArmySpellCount[$i] Then
			$g_aiArmyCustomSpells[$i] = GUICtrlRead($g_ahTxtTrainArmySpellCount[$i])
			lblTotalCountSpell2()
			Return
		EndIf
	Next
EndFunc   ;==>TrainSpellCountEdit

Func chkAddDelayIdlePhaseEnable()
	$g_bTrainAddRandomDelayEnable = (GUICtrlRead($g_hChkTrainAddRandomDelayEnable) = $GUI_CHECKED)

	For $i = $g_hLblAddDelayIdlePhaseBetween To $g_hLblAddDelayIdlePhaseSec
		GUICtrlSetState($i, $g_bTrainAddRandomDelayEnable ? $GUI_ENABLE : $GUI_DISABLE)
	Next
EndFunc   ;==>chkAddDelayIdlePhaseEnable

#Region QuickTrain
Func EditQuickTrainArmy()
	If $g_bRunState Then Return
	If $g_bRunState Or $g_iQuickTrainEdit > -1 Then
		Local $sMessage = $g_bRunState ? ("Bot is running" & @CRLF & "Please stop the bot completely and try again") : ("Edit window for Army " & $g_iQuickTrainEdit + 1 & " is currently open" & @CRLF & "Please exit and try again")
		ToolTip("EditQuickTrainArmy: " & @CRLF & $sMessage)
		Sleep(2000)
		ToolTip('')
		Return
	EndIf
	For $i = 0 To 2
		If @GUI_CtrlId = $g_ahBtnEditArmy[$i] Then
			$g_iQuickTrainEdit = $i
			_EditQuickTrainArmy($i)
			ExitLoop
		EndIf
	Next
EndFunc   ;==>EditQuickTrainArmy

Func _EditQuickTrainArmy($i)
	GUISetState(@SW_SHOW, $g_hGUI_QuickTrainEdit)
	GUICtrlSetData($g_hGrp_QTEdit, GetTranslatedFileIni("MBR GUI Design Child Attack - Troops", "GUI_QuickTrainEdit", "Edit troops and spells for quick train") & " Army " & $i + 1)
	For $j = 0 To 6
		$g_aiQTEdit_TroopType[$j] = $g_aiQuickTroopType[$i][$j]
		$g_aiQTEdit_SpellType[$j] = $g_aiQuickSpellType[$i][$j]

		If $g_aiQTEdit_TroopType[$j] > -1 Then
			_GUICtrlSetImage($g_ahPicQTEdit_Troop[$j], $g_sLibIconPath, $g_aQuickTroopIcon[$g_aiQTEdit_TroopType[$j]])
			GUICtrlSetData($g_ahTxtQTEdit_Troop[$j], $g_aiQuickTroopQty[$i][$j])
			_GUI_Value_STATE("SHOW", $g_ahPicQTEdit_Troop[$j] & "#" & $g_ahTxtQTEdit_Troop[$j])
			GUICtrlSetTip($g_ahPicQTEdit_Troop[$j], $g_asTroopNames[$g_aiQTEdit_TroopType[$j]])
		EndIf
		If $g_aiQTEdit_SpellType[$j] > -1 Then
			_GUICtrlSetImage($g_ahPicQTEdit_Spell[$j], $g_sLibIconPath, $g_aQuickSpellIcon[$g_aiQTEdit_SpellType[$j]])
			GUICtrlSetData($g_ahTxtQTEdit_Spell[$j], $g_aiQuickSpellQty[$i][$j])
			_GUI_Value_STATE("SHOW", $g_ahPicQTEdit_Spell[$j] & "#" & $g_ahTxtQTEdit_Spell[$j])
			GUICtrlSetTip($g_ahPicQTEdit_Spell[$j], $g_asSpellNames[$g_aiQTEdit_SpellType[$j]])
		EndIf
	Next
	TotalTroopCount_QTEdit()
	TotalSpellCount_QTEdit()
EndFunc   ;==>_EditQuickTrainArmy

Func ExitQuickTrainEdit()
	RemoveArmy_QTEdit()
	GUISetState(@SW_HIDE, $g_hGUI_QuickTrainEdit)
	$g_iQuickTrainEdit = -1
EndFunc   ;==>ExitQuickTrainEdit

Func SelectTroop_QTEdit()
	Local $iTroop = -1
	For $i = 0 To $eTroopCount - 1
		If @GUI_CtrlId = $g_ahPicTroop_QTEdit[$i] Then
			$iTroop = $i
			ExitLoop
		EndIf
	Next
	If $iTroop = -1 Then Return
	While _IsPressed(01)
		If Not AddTroop_QTEdit($iTroop) Then ExitLoop
		TotalTroopCount_QTEdit()
		Sleep(100)
	WEnd
EndFunc   ;==>SelectTroop_QTEdit

Func AddTroop_QTEdit($iTroop)
	Local $bOverSpace = False, $bOverSlot = False, $iTotalCampSpace=0

   $iTotalCampSpace=Number(GUICtrlRead($g_hTxtTotalCampForced))

	If $g_iQTEdit_TotalTroop + $g_aiTroopSpace[$iTroop] > $iTotalCampSpace Then $bOverSpace = True

	For $j = 0 To 6
		If $bOverSpace Then ExitLoop
		Select
			Case $g_aiQTEdit_TroopType[$j] = -1
				$g_aiQTEdit_TroopType[$j] = $iTroop
				_GUICtrlSetImage($g_ahPicQTEdit_Troop[$j], $g_sLibIconPath, $g_aQuickTroopIcon[$iTroop])
				Local $iQty = GUICtrlRead($g_ahTxtQTEdit_Troop[$j]) + 1
				GUICtrlSetData($g_ahTxtQTEdit_Troop[$j], $iQty)
				_GUI_Value_STATE("SHOW", $g_ahPicQTEdit_Troop[$j] & "#" & $g_ahTxtQTEdit_Troop[$j])
				GUICtrlSetTip($g_ahPicQTEdit_Troop[$j], $g_asTroopNames[$g_aiQTEdit_TroopType[$j]])
				ExitLoop

			Case $g_aiQTEdit_TroopType[$j] = $iTroop
				Local $iQty = GUICtrlRead($g_ahTxtQTEdit_Troop[$j]) + 1
				GUICtrlSetData($g_ahTxtQTEdit_Troop[$j], $iQty)
				ExitLoop

			Case $g_aiQTEdit_TroopType[$j] > $iTroop And $g_aiQTEdit_TroopType[6] = -1
				For $k = 6 To $j + 1 Step -1 ; shifting the higher troops to the right
					If $g_aiQTEdit_TroopType[$k - 1] >= 0 Then
						$g_aiQTEdit_TroopType[$k] = $g_aiQTEdit_TroopType[$k - 1]
						Local $iQty = GUICtrlRead($g_ahTxtQTEdit_Troop[$k - 1])
						_GUICtrlSetImage($g_ahPicQTEdit_Troop[$k], $g_sLibIconPath, $g_aQuickTroopIcon[$g_aiQTEdit_TroopType[$k]])
						GUICtrlSetData($g_ahTxtQTEdit_Troop[$k], $iQty)
						_GUI_Value_STATE("SHOW", $g_ahPicQTEdit_Troop[$k] & "#" & $g_ahTxtQTEdit_Troop[$k])
						GUICtrlSetTip($g_ahPicQTEdit_Troop[$k], $g_asTroopNames[$g_aiQTEdit_TroopType[$k]])
					EndIf
				Next
				$g_aiQTEdit_TroopType[$j] = $iTroop
				_GUICtrlSetImage($g_ahPicQTEdit_Troop[$j], $g_sLibIconPath, $g_aQuickTroopIcon[$iTroop])
				GUICtrlSetData($g_ahTxtQTEdit_Troop[$j], 1)
				GUICtrlSetTip($g_ahPicQTEdit_Troop[$j], $g_asTroopNames[$g_aiQTEdit_TroopType[$j]])
				ExitLoop

		EndSelect
		If $j = 6 Then $bOverSlot = True
	Next

	If $bOverSpace Or $bOverSlot Then
		ToolTip($bOverSlot ? "Quick train does not support more than 7 troop slots" : "Total selected troops exceeds possible camp capacity (" & $iTotalCampSpace & ")")
		Sleep(2000)
		ToolTip('')
	Else
		Return True
	EndIf
EndFunc   ;==>AddTroop_QTEdit

Func RemoveTroop_QTEdit()
	Local $iSlot = -1
	For $i = 0 To 6
		If @GUI_CtrlId = $g_ahPicQTEdit_Troop[$i] Then
			If $g_aiQTEdit_TroopType[$i] = -1 Then Return
			$iSlot = $i
			ExitLoop
		EndIf
	Next
	If $iSlot = -1 Then Return
	While _IsPressed(01)
		_RemoveTroop_QTEdit($iSlot)
		TotalTroopCount_QTEdit()
	WEnd
EndFunc   ;==>RemoveTroop_QTEdit

Func _RemoveTroop_QTEdit($iSlot)
	Local $iQty = GUICtrlRead($g_ahTxtQTEdit_Troop[$iSlot])
	If $iQty > 0 Then
		$iQty -= 1
		GUICtrlSetData($g_ahTxtQTEdit_Troop[$iSlot], $iQty)
	EndIf
	Sleep(100)
	If $iQty = 0 Then
		For $k = $iSlot To 6
			If $k < 6 Then
				If $g_aiQTEdit_TroopType[$k] = -1 Then ExitLoop
				$g_aiQTEdit_TroopType[$k] = $g_aiQTEdit_TroopType[$k + 1]
				$iQty = GUICtrlRead($g_ahTxtQTEdit_Troop[$k + 1])
			Else
				$g_aiQTEdit_TroopType[$k] = -1
				$iQty = 0
			EndIf
			If $g_aiQTEdit_TroopType[$k] > -1 Then
				_GUICtrlSetImage($g_ahPicQTEdit_Troop[$k], $g_sLibIconPath, $g_aQuickTroopIcon[$g_aiQTEdit_TroopType[$k]])
				GUICtrlSetData($g_ahTxtQTEdit_Troop[$k], $iQty)
				_GUI_Value_STATE("SHOW", $g_ahPicQTEdit_Troop[$k] & "#" & $g_ahTxtQTEdit_Troop[$k])
				GUICtrlSetTip($g_ahPicQTEdit_Troop[$k], $g_asTroopNames[$g_aiQTEdit_TroopType[$k]])
			Else
				_GUICtrlSetImage($g_ahPicQTEdit_Troop[$k], $g_sLibIconPath, $eEmpty3)
				GUICtrlSetData($g_ahTxtQTEdit_Troop[$k], 0)
				_GUI_Value_STATE("HIDE", $g_ahPicQTEdit_Troop[$k] & "#" & $g_ahTxtQTEdit_Troop[$k])
				GUICtrlSetTip($g_ahPicQTEdit_Troop[$k], "Empty")
			EndIf
		Next
	EndIf
EndFunc   ;==>_RemoveTroop_QTEdit

Func SelectSpell_QTEdit()
	Local $iSpell = -1
	For $i = 0 To $eSpellCount - 1
		If @GUI_CtrlId = $g_ahPicSpell_QTEdit[$i] Then
			$iSpell = $i
			ExitLoop
		EndIf
	Next
	If $iSpell = -1 Then Return
	While _IsPressed(01)
		If Not AddSpell_QTEdit($iSpell) Then ExitLoop
		TotalSpellCount_QTEdit()
		Sleep(100)
	WEnd
EndFunc   ;==>SelectSpell_QTEdit

Func AddSpell_QTEdit($iSpell)
	Local $bOverSpace = False, $bOverSlot = False, $iTotalSpellSpace=0

	$iTotalSpellSpace=Number(GUICtrlRead($g_hTxtTotalCountSpell))

	If $g_iQTEdit_TotalSpell + $g_aiSpellSpace[$iSpell] > $iTotalSpellSpace Then $bOverSpace = True

	For $j = 0 To 6
		If $bOverSpace Then ExitLoop
		Select
			Case $g_aiQTEdit_SpellType[$j] = -1
				$g_aiQTEdit_SpellType[$j] = $iSpell
				_GUICtrlSetImage($g_ahPicQTEdit_Spell[$j], $g_sLibIconPath, $g_aQuickSpellIcon[$iSpell])
				Local $iQty = GUICtrlRead($g_ahTxtQTEdit_Spell[$j]) + 1
				GUICtrlSetData($g_ahTxtQTEdit_Spell[$j], $iQty)
				_GUI_Value_STATE("SHOW", $g_ahPicQTEdit_Spell[$j] & "#" & $g_ahTxtQTEdit_Spell[$j])
				GUICtrlSetTip($g_ahPicQTEdit_Spell[$j], $g_asSpellNames[$g_aiQTEdit_SpellType[$j]])
				ExitLoop

			Case $g_aiQTEdit_SpellType[$j] = $iSpell
				Local $iQty = GUICtrlRead($g_ahTxtQTEdit_Spell[$j]) + 1
				GUICtrlSetData($g_ahTxtQTEdit_Spell[$j], $iQty)
				ExitLoop

			Case $g_aiQTEdit_SpellType[$j] > $iSpell And $g_aiQTEdit_SpellType[6] = -1
				For $k = 6 To $j + 1 Step -1 ; shifting the higher spells to the right
					If $g_aiQTEdit_SpellType[$k - 1] >= 0 Then
						$g_aiQTEdit_SpellType[$k] = $g_aiQTEdit_SpellType[$k - 1]
						Local $iQty = GUICtrlRead($g_ahTxtQTEdit_Spell[$k - 1])
						_GUICtrlSetImage($g_ahPicQTEdit_Spell[$k], $g_sLibIconPath, $g_aQuickSpellIcon[$g_aiQTEdit_SpellType[$k]])
						GUICtrlSetData($g_ahTxtQTEdit_Spell[$k], $iQty)
						_GUI_Value_STATE("SHOW", $g_ahPicQTEdit_Spell[$k] & "#" & $g_ahTxtQTEdit_Spell[$k])
						GUICtrlSetTip($g_ahPicQTEdit_Spell[$k], $g_asSpellNames[$g_aiQTEdit_SpellType[$k]])
					EndIf
				Next
				$g_aiQTEdit_SpellType[$j] = $iSpell
				_GUICtrlSetImage($g_ahPicQTEdit_Spell[$j], $g_sLibIconPath, $g_aQuickSpellIcon[$iSpell])
				GUICtrlSetData($g_ahTxtQTEdit_Spell[$j], 1)
				GUICtrlSetTip($g_ahPicQTEdit_Spell[$j], $g_asSpellNames[$g_aiQTEdit_SpellType[$j]])
				ExitLoop

		EndSelect
		If $j = 6 Then $bOverSlot = True
	Next

	If $bOverSpace Or $bOverSlot Then
		ToolTip($bOverSlot ? "Quick train does not support more than 7 Spell slots" : "Total selected Spells exceeds possible spell camp capacity (" & $iTotalSpellSpace & ")")
		Sleep(2000)
		ToolTip('')
	Else
		Return True
	EndIf
EndFunc   ;==>AddSpell_QTEdit

Func RemoveSpell_QTEdit()
	Local $iSlot = -1
	For $i = 0 To 6
		If @GUI_CtrlId = $g_ahPicQTEdit_Spell[$i] Then
			If $g_aiQTEdit_SpellType[$i] = -1 Then Return
			$iSlot = $i
			ExitLoop
		EndIf
	Next
	If $iSlot = -1 Then Return
	While _IsPressed(01)
		_RemoveSpell_QTEdit($iSlot)
		TotalSpellCount_QTEdit()
	WEnd
EndFunc   ;==>RemoveSpell_QTEdit

Func _RemoveSpell_QTEdit($iSlot)
	Local $iQty = GUICtrlRead($g_ahTxtQTEdit_Spell[$iSlot])
	If $iQty > 0 Then
		$iQty -= 1
		GUICtrlSetData($g_ahTxtQTEdit_Spell[$iSlot], $iQty)
	EndIf
	Sleep(100)
	If $iQty = 0 Then
		For $k = $iSlot To 6
			If $k < 6 Then
				If $g_aiQTEdit_SpellType[$k] = -1 Then ExitLoop
				$g_aiQTEdit_SpellType[$k] = $g_aiQTEdit_SpellType[$k + 1]
				$iQty = GUICtrlRead($g_ahTxtQTEdit_Spell[$k + 1])
			Else
				$g_aiQTEdit_SpellType[$k] = -1
				$iQty = 0
			EndIf
			If $g_aiQTEdit_SpellType[$k] > -1 Then
				_GUICtrlSetImage($g_ahPicQTEdit_Spell[$k], $g_sLibIconPath, $g_aQuickSpellIcon[$g_aiQTEdit_SpellType[$k]])
				GUICtrlSetData($g_ahTxtQTEdit_Spell[$k], $iQty)
				_GUI_Value_STATE("SHOW", $g_ahPicQTEdit_Spell[$k] & "#" & $g_ahTxtQTEdit_Spell[$k])
				GUICtrlSetTip($g_ahPicQTEdit_Spell[$k], $g_asSpellNames[$g_aiQTEdit_SpellType[$k]])
			Else
				_GUICtrlSetImage($g_ahPicQTEdit_Spell[$k], $g_sLibIconPath, $eEmpty3)
				GUICtrlSetData($g_ahTxtQTEdit_Spell[$k], 0)
				_GUI_Value_STATE("HIDE", $g_ahPicQTEdit_Spell[$k] & "#" & $g_ahTxtQTEdit_Spell[$k])
				GUICtrlSetTip($g_ahPicQTEdit_Spell[$k], "Empty")
			EndIf
		Next
	EndIf
EndFunc   ;==>_RemoveSpell_QTEdit

Func RemoveArmy_QTEdit()
	For $j = 0 To 6
		$g_aiQTEdit_TroopType[$j] = -1
		$g_aiQTEdit_SpellType[$j] = -1
		_GUICtrlSetImage($g_ahPicQTEdit_Troop[$j], $g_sLibIconPath, $eEmpty3)
		_GUICtrlSetImage($g_ahPicQTEdit_Spell[$j], $g_sLibIconPath, $eEmpty3)
		GUICtrlSetData($g_ahTxtQTEdit_Troop[$j], 0)
		GUICtrlSetData($g_ahTxtQTEdit_Spell[$j], 0)
		_GUI_Value_STATE("HIDE", $g_ahPicQTEdit_Troop[$j] & "#" & $g_ahTxtQTEdit_Troop[$j] & "#" & $g_ahPicQTEdit_Spell[$j] & "#" & $g_ahTxtQTEdit_Spell[$j])
		GUICtrlSetTip($g_ahPicQTEdit_Troop[$j], "Empty")
		GUICtrlSetTip($g_ahPicQTEdit_Spell[$j], "Empty")
	Next
	TotalTroopCount_QTEdit()
	TotalSpellCount_QTEdit()
EndFunc   ;==>RemoveArmy_QTEdit

Func SaveArmy_QTEdit()
	$i = $g_iQuickTrainEdit
	For $j = 0 To 6
		$g_aiQuickTroopType[$i][$j] = $g_aiQTEdit_TroopType[$j]
		$g_aiQuickSpellType[$i][$j] = $g_aiQTEdit_SpellType[$j]
		$g_aiQuickTroopQty[$i][$j] = GUICtrlRead($g_ahTxtQTEdit_Troop[$j])
		$g_aiQuickSpellQty[$i][$j] = GUICtrlRead($g_ahTxtQTEdit_Spell[$j])
	Next
	$g_aiTotalQuickTroop[$i] = $g_iQTEdit_TotalTroop
	$g_aiTotalQuickSpell[$i] = $g_iQTEdit_TotalSpell
	RemoveArmy_QTEdit()
	GUISetState(@SW_HIDE, $g_hGUI_QuickTrainEdit)
	ApplyQuickTrainArmy($i)
	$g_iQuickTrainEdit = -1
EndFunc   ;==>SaveArmy_QTEdit

Func ApplyQuickTrainArmy($Army)
	For $i = 0 To 2
		If $i <> $Army Then ContinueLoop
		Local $bNoArmy = True
		GUICtrlSetState($g_ahLblQuickTrainNote[$i], $GUI_HIDE)
		For $j = 0 To 6
			If $g_aiQuickTroopType[$i][$j] > -1 Then
				_GUICtrlSetImage($g_ahPicQuickTroop[$i][$j], $g_sLibIconPath, $g_aQuickTroopIcon[$g_aiQuickTroopType[$i][$j]])
				GUICtrlSetData($g_ahLblQuickTroop[$i][$j], $g_aiQuickTroopQty[$i][$j] & "x")
				_GUI_Value_STATE("SHOW", $g_ahPicQuickTroop[$i][$j] & "#" & $g_ahLblQuickTroop[$i][$j])
				GUICtrlSetTip($g_ahPicQuickTroop[$i][$j], $g_asTroopNames[$g_aiQuickTroopType[$i][$j]])
				$bNoArmy = False
			Else
				_GUICtrlSetImage($g_ahPicQuickTroop[$i][$j], $g_sLibIconPath, $eEmpty3)
				_GUI_Value_STATE("HIDE", $g_ahPicQuickTroop[$i][$j] & "#" & $g_ahLblQuickTroop[$i][$j])
				GUICtrlSetTip($g_ahPicQuickTroop[$i][$j], "Empty")
			EndIf
			If $g_aiQuickSpellType[$i][$j] > -1 Then
				_GUICtrlSetImage($g_ahPicQuickSpell[$i][$j], $g_sLibIconPath, $g_aQuickSpellIcon[$g_aiQuickSpellType[$i][$j]])
				GUICtrlSetData($g_ahLblQuickSpell[$i][$j], $g_aiQuickSpellQty[$i][$j] & "x")
				_GUI_Value_STATE("SHOW", $g_ahPicQuickSpell[$i][$j] & "#" & $g_ahLblQuickSpell[$i][$j])
				GUICtrlSetTip($g_ahPicQuickSpell[$i][$j], $g_asSpellNames[$g_aiQuickSpellType[$i][$j]])
				$bNoArmy = False
			Else
				_GUICtrlSetImage($g_ahPicQuickSpell[$i][$j], $g_sLibIconPath, $eEmpty3)
				_GUI_Value_STATE("HIDE", $g_ahPicQuickSpell[$i][$j] & "#" & $g_ahLblQuickSpell[$i][$j])
				GUICtrlSetTip($g_ahPicQuickSpell[$i][$j], "Empty")
			EndIf
		Next
		If $bNoArmy Then GUICtrlSetState($g_ahLblQuickTrainNote[$i], $GUI_SHOW)
		GUICtrlSetData($g_ahLblTotalQTroop[$i], $g_aiTotalQuickTroop[$i])
		GUICtrlSetData($g_ahLblTotalQSpell[$i], $g_aiTotalQuickSpell[$i])
	Next
EndFunc   ;==>ApplyQuickTrainArmy

Func TxtQTEdit_Troop()
	Local $iTroop, $iQty, $iSpace, $iSlot, $iTotalCampSpace=0

   $iTotalCampSpace = Number(GUICtrlRead($g_hTxtTotalCampForced))

   For $j = 0 To 6
		If @GUI_CtrlId = $g_ahTxtQTEdit_Troop[$j] Then
			$iTroop = $g_aiQTEdit_TroopType[$j]
			$iQty = GUICtrlRead($g_ahTxtQTEdit_Troop[$j])
			If _ArrayIndexValid($g_aiTroopSpace, $iTroop) Then $iSpace = $iQty * $g_aiTroopSpace[$iTroop]
			$iSlot = $j
			If $iQty = 0 Then _RemoveTroop_QTEdit($iSlot)
			ExitLoop
		EndIf
		If $j = 6 Then Return
	Next
	TotalTroopCount_QTEdit()

	If $g_iQTEdit_TotalTroop > $iTotalCampSpace Then
		Local $iSpaceLeft = $iTotalCampSpace - ($g_iQTEdit_TotalTroop - $iSpace)
		Local $iMaxQtyLeft = Int($iSpaceLeft / $g_aiTroopSpace[$iTroop])
	    ToolTip("Your input of " & $iQty & "x " & $g_asTroopNames[$iTroop] & " makes total troops to exceed possible camp capacity (" & $iTotalCampSpace & ")." & @CRLF & "Automatically changing to: " & $iMaxQtyLeft & "x " & $g_asTroopNames[$iTroop])
		Sleep(2000)
		ToolTip('')
		GUICtrlSetData($g_ahTxtQTEdit_Troop[$iSlot], $iMaxQtyLeft)
		TotalTroopCount_QTEdit()
	EndIf
EndFunc   ;==>TxtQTEdit_Troop

Func TxtQTEdit_Spell()
	Local $iSpell, $iQty, $iSpace, $iSlot, $iTotalSpellSpace=0

	$iTotalSpellSpace = Number(GUICtrlRead($g_hTxtTotalCountSpell))

	For $j = 0 To 6
		If @GUI_CtrlId = $g_ahTxtQTEdit_Spell[$j] Then
			$iSpell = $g_aiQTEdit_SpellType[$j]
			$iQty = GUICtrlRead($g_ahTxtQTEdit_Spell[$j])
			If _ArrayIndexValid($g_aiSpellSpace, $iSpell) Then $iSpace = $iQty * $g_aiSpellSpace[$iSpell]
			$iSlot = $j
			If $iQty = 0 Then _RemoveSpell_QTEdit($iSlot)
			ExitLoop
		EndIf
		If $j = 6 Then Return
	Next
	TotalSpellCount_QTEdit()

	If $g_iQTEdit_TotalSpell > $iTotalSpellSpace Then
		Local $iSpaceLeft = $iTotalSpellSpace - ($g_iQTEdit_TotalSpell - $iSpace)
		Local $iMaxQtyLeft = Int($iSpaceLeft / $g_aiSpellSpace[$iSpell])
		ToolTip("Your input of " & $iQty & "x " & $g_asSpellNames[$iSpell] & " makes total Spells to exceed possible camp capacity (" & $iTotalSpellSpace & ")." & @CRLF & "Automatically changing to: " & $iMaxQtyLeft & "x " & $g_asSpellNames[$iSpell])
		Sleep(2000)
		ToolTip('')
		GUICtrlSetData($g_ahTxtQTEdit_Spell[$iSlot], $iMaxQtyLeft)
		TotalSpellCount_QTEdit()
	EndIf
EndFunc   ;==>TxtQTEdit_Spell

Func TotalTroopCount_QTEdit()
	$g_iQTEdit_TotalTroop = 0
	For $j = 0 To 6
		Local $iCount = GUICtrlRead($g_ahTxtQTEdit_Troop[$j])
		Local $iTroop = $g_aiQTEdit_TroopType[$j]
		If $iCount > 0 Then $g_iQTEdit_TotalTroop += $iCount * $g_aiTroopSpace[$iTroop]
	Next
	GUICtrlSetData($g_ahLblQTEdit_TotalTroop, $g_iQTEdit_TotalTroop)
EndFunc   ;==>TotalTroopCount_QTEdit

Func TotalSpellCount_QTEdit()
	$g_iQTEdit_TotalSpell = 0
	For $j = 0 To 6
		Local $iCount = GUICtrlRead($g_ahTxtQTEdit_Spell[$j])
		Local $iSpell = $g_aiQTEdit_SpellType[$j]
		If $iCount > 0 Then $g_iQTEdit_TotalSpell += $iCount * $g_aiSpellSpace[$iSpell]
	Next
	GUICtrlSetData($g_ahLblQTEdit_TotalSpell, $g_iQTEdit_TotalSpell)
EndFunc   ;==>TotalSpellCount_QTEdit
#EndRegion QuickTrain

; Custom Super Troops - Team AIO Mod++
Func chkSuperTroops()
	$g_bSuperAutoTroops = GUICtrlRead($g_hChkSuperAutoTroops) = $GUI_CHECKED

	GUICtrlSetState($g_hChkSuperAutoTroops, ($g_bQuickTrainEnable = True) ? ($GUI_DISABLE) : ($GUI_ENABLE))

	$g_bSuperTroopsEnable = GUICtrlRead($g_hChkSuperTroops) = $GUI_CHECKED
	GUICtrlSetState($g_hCmbSuperTroopsResources, ($g_bSuperTroopsEnable = True) ? ($GUI_ENABLE) : ($GUI_DISABLE))
	GUICtrlSetState($g_hChkSuperAutoTroops, ($g_bSuperTroopsEnable = True And $g_bQuickTrainEnable = False) ? ($GUI_ENABLE) : ($GUI_DISABLE))

	Local $bCondition = $g_bSuperTroopsEnable And not $g_bSuperAutoTroops
	If $g_bQuickTrainEnable And $g_bSuperTroopsEnable Then $bCondition = True

	For $i = 0 To $iMaxSupersTroop - 1
		GUICtrlSetState($g_ahLblSuperTroops[$i], ($bCondition = True) ? ($GUI_ENABLE) : ($GUI_DISABLE))
		GUICtrlSetState($g_ahCmbSuperTroops[$i], ($bCondition = True) ? ($GUI_ENABLE) : ($GUI_DISABLE))
		GUICtrlSetState($g_ahPicSuperTroops[$i], ($bCondition = True) ? ($GUI_SHOW) : ($GUI_HIDE))
		_GUICtrlSetImage($g_ahPicSuperTroops[$i], $g_sLibIconPath, $g_aSuperTroopsIcons[$g_iCmbSuperTroops[$i]])
	Next
EndFunc   ;==>chkSuperTroops

Func cmbSuperTroops()
	For $i = 0 To $iMaxSupersTroop - 1
		$g_iCmbSuperTroops[$i] = _GUICtrlComboBox_GetCurSel($g_ahCmbSuperTroops[$i])
		_GUICtrlSetImage($g_ahPicSuperTroops[$i], $g_sLibIconPath, $g_aSuperTroopsIcons[$g_iCmbSuperTroops[$i]])
		For $j = 0 To $iMaxSupersTroop - 1
			If $i = $j Then ContinueLoop
			If $g_iCmbSuperTroops[$i] <> 0 And $g_iCmbSuperTroops[$i] = $g_iCmbSuperTroops[$j] Then
				_GUICtrlComboBox_SetCurSel($g_ahCmbSuperTroops[$j], 0)
				_GUICtrlSetImage($g_ahImgTroopOrder[$j], $g_sLibIconPath, $eIcnOptions)
			EndIf
		Next
	Next
EndFunc   ;==>cmbSuperTroops

#Region - Custom Super Troops - Team AIO Mod++
Func cmbSuperTroopsResources()
	$g_iCmbSuperTroopsResources = _GUICtrlComboBox_GetCurSel($g_hCmbSuperTroopsResources)
EndFunc   ;==>cmbSuperTroopsResources
#EndRegion - Custom Super Troops - Team AIO Mod++

Func CmbTroopSetting()
	Local $iOld = $g_iCmbTroopSetting
	Local $iActual = _GUICtrlComboBox_GetCurSel($g_hCmbTroopSetting)

	For $T = 0 To $eTroopCount - 1
		$g_iCustomArmysMainVillage[$T][$iOld] = GUICtrlRead($g_ahTxtTrainArmyTroopCount[$T])
	Next
	For $S = 0 To $eSpellCount - 1
		$g_iCustomBrewMainVillage[$S][$iOld] = GUICtrlRead($g_ahTxtTrainArmySpellCount[$S])
	Next
	For $S = 0 To $eSiegeMachineCount - 1
		$g_iCustomSiegesMainVillage[$S][$iOld] = GUICtrlRead($g_ahTxtTrainArmySiegeCount[$S])
	Next

	For $T = 0 To $eTroopCount - 1
		GUICtrlSetData($g_ahTxtTrainArmyTroopCount[$T], Number($g_iCustomArmysMainVillage[$T][$iActual]))
	Next

	For $S = 0 To $eSpellCount - 1
		GUICtrlSetData($g_ahTxtTrainArmySpellCount[$S], Number($g_iCustomBrewMainVillage[$S][$iActual]))
	Next

	For $S = 0 To $eSiegeMachineCount - 1
		GUICtrlSetData($g_ahTxtTrainArmySiegeCount[$S], Number($g_iCustomSiegesMainVillage[$S][$iActual]))
	Next

	$g_iCmbTroopSetting = _GUICtrlComboBox_GetCurSel($g_hCmbTroopSetting)

	For $T = 0 To $eTroopCount - 1
		$g_iCustomArmysMainVillage[$T][$g_iCmbTroopSetting] = GUICtrlRead($g_ahTxtTrainArmyTroopCount[$T])
	Next
	For $S = 0 To $eSpellCount - 1
		$g_iCustomBrewMainVillage[$S][$g_iCmbTroopSetting] = GUICtrlRead($g_ahTxtTrainArmySpellCount[$S])
	Next
	For $S = 0 To $eSiegeMachineCount - 1
		$g_iCustomSiegesMainVillage[$S][$g_iCmbTroopSetting] = GUICtrlRead($g_ahTxtTrainArmySiegeCount[$S])
	Next

	; ApplyConfig_600_52_2("Save")
	; ApplyConfig_600_52_2("Read")
	; ApplyConfig_600_54("Save")
	ApplyConfig_600_54("Read")
EndFunc   ;==>CmbTroopSetting

; Custom pets - Team AIO Mod++
Func ChkPetHouseSelector()
	$g_bPetHouseSelector = (GUICtrlRead($g_hChkPetHouseSelector) = $GUI_CHECKED)
	For $h = $g_hLblLassiHero To $g_hCmbUnicornPet
		GUICtrlSetState($h, ($g_bPetHouseSelector = True) ? ($GUI_ENABLE) : ($GUI_DISABLE))
	Next
EndFunc

Func cmbPetSelector()
	Local $hSelected = @GUI_CtrlId

	Static $oPetsMatrix = ObjCreate("Scripting.Dictionary")
	If @error Then
		MsgBox(0, '', 'Error creating the dictionary object')
		Return
	EndIf

	Local $iValue = _GUICtrlComboBox_GetCurSel($hSelected)

	If $iValue > 0 Then
		$oPetsMatrix("Lassi") = $g_hCmbLassiPet
		$oPetsMatrix("Electro Owl") = $g_hCmbElectroOwlPet
		$oPetsMatrix("Mighty Yak") = $g_hCmbMightyYakPet
		$oPetsMatrix("Unicorn") = $g_hCmbUnicornPet
		Local $aPetsNames = ["Lassi", "Electro Owl", "Mighty Yak", "Unicorn"]
		For $s In $aPetsNames
			Local $sA = _GUICtrlComboBox_GetCurSel($oPetsMatrix($s))
			If $oPetsMatrix($s) <> $hSelected And $iValue = _GUICtrlComboBox_GetCurSel($oPetsMatrix($s)) Then
				_GUICtrlComboBox_SetCurSel($oPetsMatrix($s), 0)
			EndIf
		Next
		$g_iCmbLassiPet = _GUICtrlComboBox_GetCurSel($oPetsMatrix("Lassi"))
		$g_iCmbElectroOwlPet =	_GUICtrlComboBox_GetCurSel($oPetsMatrix("Electro Owl"))
		$g_iCmbMightyYakPet = _GUICtrlComboBox_GetCurSel($oPetsMatrix("Mighty Yak"))
		$g_iCmbUnicornPet = _GUICtrlComboBox_GetCurSel($oPetsMatrix("Unicorn"))
	EndIf
EndFunc   ;==>cmbPetSelector
