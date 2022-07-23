; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file creates the "War Preparation" tab under the "Village" tab
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Demen
; Modified ......: Chilly-Chill (08-2019)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
; War preparation (Demen)

Global $g_hChkStopForWar = 0, $g_hCmbStopTime = 0, $g_hCmbStopBeforeBattle = 0, $g_hCmbReturnTime = 0
Global $g_hChkTrainWarTroop = 0, $g_hChkUseQuickTrainWar, $g_ahChkArmyWar[3], $g_hLblRemoveArmy, $g_ahTxtTrainWarTroopCount[$eTroopCount], $g_ahTxtTrainWarSpellCount[$eSpellCount]
Global $g_hCalTotalWarTroops, $g_hLblTotalWarTroopsProgress, $g_hLblCountWarTroopsTotal
Global $g_hCalTotalWarSpells, $g_hLblTotalWarSpellsProgress, $g_hLblCountWarSpellsTotal
Global $g_hChkRequestCCForWar = 0, $g_hTxtRequestCCForWar = 0

Func TabWarPreparationGUI()

	Local $x = 15, $y = 60
	GUICtrlCreateGroup("War preparation", $x - 10, $y - 15, $g_iSizeWGrpTab2, $g_iSizeHGrpTab3 + 5)

		$x += 5
		$g_hChkStopForWar = GUICtrlCreateCheckbox("Pause farming for war", $x, $y, -1, -1)
			_GUICtrlSetTip(-1, "Pause or set current account 'idle' to prepare for war")
			GUICtrlSetOnEvent(-1, "ChkStopForWar")

		$g_hCmbStopTime = GUICtrlCreateCombo("", $x + 140, $y, 41, 25, BitOR($GUI_SS_DEFAULT_COMBO,$CBS_SIMPLE))
			GUICtrlSetData(-1, 	"0|1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20|21|22|23", "0")
			GUICtrlSetOnEvent(-1,"CmbStopTime")
			GUICtrlCreateLabel("Hrs", $x + 190, -1)
			
		$g_hCmbStopBeforeBattle = GUICtrlCreateCombo("", $x + 245, $y, 120, 25, BitOR($GUI_SS_DEFAULT_COMBO,$CBS_SIMPLE))
			GUICtrlSetData(-1, 	"before battle start|after battle start", "before battle start")
			GUICtrlSetOnEvent(-1,"CmbStopTime")
			
	$y += 25
		GUICtrlCreateLabel("Return to farm", $x + 15, $y + 1, -1, -1)
		$g_hCmbReturnTime = GUICtrlCreateCombo("", $x + 140, $y, 41, 25, BitOR($GUI_SS_DEFAULT_COMBO,$CBS_SIMPLE))
		GUICtrlSetData(-1, 	"0|1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20|21|22|23", "0")
		GUICtrlCreateLabel("Hrs", $x + 190, -1)
		GUICtrlSetOnEvent(-1,"CmbReturnTime")
		GUICtrlCreateLabel("before battle finish", $x + 245, $y + 1, -1, -1)
			
	$y += 25
		$g_hChkTrainWarTroop = GUICtrlCreateCheckbox("Delete all farming troops and train war troops before pausing", $x, $y, -1, -1)
			GUICtrlSetOnEvent(-1, "ChkTrainWarTroop")

	$y += 25
		$g_hChkUseQuickTrainWar = GUICtrlCreateCheckbox("Use Quick Train", $x + 15, $y, -1, 15)
			GUICtrlSetState(-1, $GUI_UNCHECKED)
			GUICtrlSetOnEvent(-1, "chkUseQTrainWar")
		For $i = 0 To 2
			$g_ahChkArmyWar[$i] = GUICtrlCreateCheckbox("Army " & $i + 1, $x + 120 + $i * 60, $y, 50, 15)
				GUICtrlSetState(-1, $GUI_DISABLE)
				If $i = 0 Then GUICtrlSetState(-1, $GUI_CHECKED)
				GUICtrlSetOnEvent(-1, "chkQuickTrainComboWar")
		Next
		$g_hLblRemoveArmy = GUICtrlCreateLabel("Remove Army", $x + 305, $y + 1, -1, 15, $SS_LEFT)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnResetButton, $x + 375, $y - 4, 24, 24)
			GUICtrlSetOnEvent(-1, "RemovecampWar")

	$x = 15
	$y += 25
	For $i = 0 To UBound($g_aQuickTroopIcon) - 1
		_GUICtrlCreateIcon($g_sLibIconPath, $g_aQuickTroopIcon[$i], ($x + Int($i / 3) * 25) + 50, $y + Mod($i, 3) * 50, 22, 22)
		$g_ahTxtTrainWarTroopCount[$i] = _GUICtrlCreateInput("0", ($x + Int($i / 3) * 25) + 50, $y + Mod($i, 3) * 50 + 25, 22, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
		GUICtrlSetOnEvent(-1, "TrainWarTroopCountEdit")
		_GUICtrlSetTip(-1, $g_asTroopNames[$i])
		GUICtrlSetLimit(-1, 3)
	Next
	$x = 15
	$y += 150
		$g_hCalTotalWarTroops = GUICtrlCreateProgress($x, $y + 3, 285, 10)
		$g_hLblTotalWarTroopsProgress = GUICtrlCreateLabel("", $x, $y + 3, 285, 10)
			GUICtrlSetBkColor(-1, $COLOR_RED)
			GUICtrlSetState(-1, BitOR($GUI_DISABLE, $GUI_HIDE))

		GUICtrlCreateLabel("Total troops", $x + 290, $y, -1, -1)
		$g_hLblCountWarTroopsTotal = GUICtrlCreateLabel("" & 0, $x + 350, $y, 30, 15, $SS_CENTER)
			GUICtrlSetBkColor(-1, 0xD1DFE7) ;lime, moneygreen

	$y += 20
		For $i = 0 To $eSpellCount - 1 ; Spells
			If $i >= 7 Then $x = 25
			_GUICtrlCreateIcon($g_sLibIconPath, $g_aQuickSpellIcon[$i], $x + $i * 34, $y, 23, 23)
			$g_ahTxtTrainWarSpellCount[$i] = _GUICtrlCreateInput("0", $x +  $i * 34, $y + 25, 25, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
				GUICtrlSetLimit(-1, 3)
				GUICtrlSetOnEvent(-1, "TrainWarSpellCountEdit")
		Next

	$x = 13
	$y += 50
		$g_hCalTotalWarSpells = GUICtrlCreateProgress($x, $y + 3, 285, 10)
		$g_hLblTotalWarSpellsProgress = GUICtrlCreateLabel("", $x, $y + 3, 285, 10)
			GUICtrlSetBkColor(-1, $COLOR_RED)
			GUICtrlSetState(-1, BitOR($GUI_DISABLE, $GUI_HIDE))

		GUICtrlCreateLabel("Total spells", $x + 290, $y, -1, -1)
		$g_hLblCountWarSpellsTotal = GUICtrlCreateLabel("" & 0, $x + 350, $y, 30, 15, $SS_CENTER)
			GUICtrlSetBkColor(-1, 0xD1DFE7) ;lime, moneygreen

	$x = 13
	$y += 20
		$g_hChkRequestCCForWar = GUICtrlCreateCheckbox("Request CC before pausing", $x, $y, -1, -1)
			GUICtrlSetOnEvent(-1, "ChkRequestCCForWar")
		$g_hTxtRequestCCForWar = _GUICtrlCreateInput("War troop please", $x + 180, $y, 120, -1, $SS_CENTER)

	GUICtrlCreateGroup("", -99, -99, 1, 1)

EndFunc   ;==>CreateMiscWarPreparationSubTab

;========= GUI Control ==========
Func ChkStopForWar()
	If GUICtrlRead($g_hChkStopForWar) = $GUI_CHECKED Then
		For $i = $g_hCmbStopTime To $g_hChkTrainWarTroop
			GUICtrlSetState($i, $GUI_ENABLE)
		Next
		ChkTrainWarTroop()
		GUICtrlSetState($g_hChkRequestCCForWar, $GUI_ENABLE)
		ChkRequestCCForWar()
	Else
		For $i = $g_hCmbStopTime To $g_hTxtRequestCCForWar
			GUICtrlSetState($i, $GUI_DISABLE)
		Next
		GUICtrlSetBkColor($g_hLblCountWarTroopsTotal, 0xD1DFE7)
		GUICtrlSetBkColor($g_hLblCountWarSpellsTotal, 0xD1DFE7)
	EndIf
EndFunc

Func CmbStopTime()
	If _GUICtrlComboBox_GetCurSel($g_hCmbStopBeforeBattle) < 1 Then Return
	If _GUICtrlComboBox_GetCurSel($g_hCmbStopTime) >= 24 - _GUICtrlComboBox_GetCurSel($g_hCmbReturnTime) Then
		_GUICtrlComboBox_SetCurSel($g_hCmbReturnTime, 0)
		ToolTip("Set Return Time: " & @CRLF & "Pause time should be before Return time.")
		Sleep(3500)
		ToolTip('')
	EndIf

	$g_iStopTime = _GUICtrlComboBox_GetCurSel($g_hCmbStopTime)
	If _GUICtrlComboBox_GetCurSel($g_hCmbStopBeforeBattle) = 0 Then $g_iStopTime = $g_iStopTime * -1
	$g_iReturnTime = _GUICtrlComboBox_GetCurSel($g_hCmbReturnTime)

EndFunc

Func CmbReturnTime()
	If _GUICtrlComboBox_GetCurSel($g_hCmbStopBeforeBattle) < 1 Then Return
	If _GUICtrlComboBox_GetCurSel($g_hCmbReturnTime) >= 24 - _GUICtrlComboBox_GetCurSel($g_hCmbStopTime) Then
		_GUICtrlComboBox_SetCurSel($g_hCmbReturnTime, 0)
		ToolTip("Set Return Time: " & @CRLF & "Return time should be after Pause time.")
		Sleep(3500)
		ToolTip('')
	EndIf

	$g_iStopTime = _GUICtrlComboBox_GetCurSel($g_hCmbStopTime)
	If _GUICtrlComboBox_GetCurSel($g_hCmbStopBeforeBattle) = 0 Then $g_iStopTime = $g_iStopTime * -1		
	$g_iReturnTime = _GUICtrlComboBox_GetCurSel($g_hCmbReturnTime)

EndFunc

Func ChkTrainWarTroop()
	If GUICtrlRead($g_hChkTrainWarTroop) = $GUI_CHECKED Then
		GUICtrlSetState($g_hChkUseQuickTrainWar, $GUI_ENABLE)
		chkUseQTrainWar()
	Else
		For $i = $g_hChkUseQuickTrainWar To $g_hLblCountWarSpellsTotal
			GUICtrlSetState($i, $GUI_DISABLE)
		Next
		GUICtrlSetBkColor($g_hLblCountWarTroopsTotal, 0xD1DFE7)
		GUICtrlSetBkColor($g_hLblCountWarSpellsTotal, 0xD1DFE7)
	EndIf
EndFunc

Func chkUseQTrainWar()
	If GUICtrlRead($g_hChkUseQuickTrainWar) = $GUI_CHECKED Then
		_GUI_Value_STATE("ENABLE", $g_ahChkArmyWar[0] & "#" & $g_ahChkArmyWar[1] & "#" & $g_ahChkArmyWar[2])
		chkQuickTrainComboWar()
		For $i = $g_hLblRemoveArmy To $g_hLblCountWarSpellsTotal
			GUICtrlSetState($i, $GUI_DISABLE)
		Next
		GUICtrlSetBkColor($g_hLblCountWarTroopsTotal, 0xD1DFE7)
		GUICtrlSetBkColor($g_hLblCountWarSpellsTotal, 0xD1DFE7)
	Else
		_GUI_Value_STATE("DISABLE", $g_ahChkArmyWar[0] & "#" & $g_ahChkArmyWar[1] & "#" & $g_ahChkArmyWar[2])
		For $i = $g_hLblRemoveArmy To $g_hLblCountWarSpellsTotal
			GUICtrlSetState($i, $GUI_ENABLE)
		Next
		lblTotalWarTroopCount()
		lblTotalWarSpellCount()
	EndIf
EndFunc

Func chkQuickTrainComboWar()
	If GUICtrlRead($g_ahChkArmyWar[0]) = $GUI_UNCHECKED And GUICtrlRead($g_ahChkArmyWar[1]) = $GUI_UNCHECKED And GUICtrlRead($g_ahChkArmyWar[2]) = $GUI_UNCHECKED Then
		GUICtrlSetState($g_ahChkArmyWar[0], $GUI_CHECKED)
		ToolTip("QuickTrainCombo: " & @CRLF & "At least 1 Army Check is required! Default Army 1.")
		Sleep(2000)
		ToolTip('')
	EndIf
EndFunc

Func RemovecampWar()
	For $T = 0 To $eTroopCount - 1
		$g_aiWarCompTroops[$T] = 0
		GUICtrlSetData($g_ahTxtTrainWarTroopCount[$T], 0)
	Next
	For $S = 0 To $eSpellCount - 1
		$g_aiWarCompSpells[$S] = 0
		GUICtrlSetData($g_ahTxtTrainWarSpellCount[$S], 0)
	Next
	lblTotalWarTroopCount()
	lblTotalWarSpellCount()
EndFunc

Func lblTotalWarTroopCount($TotalArmyCamp = 0)
	Local $TotalTroopsToTrain
    If $TotalArmyCamp = 0 Then $TotalArmyCamp = $g_bTotalCampForced ? $g_iTotalCampForcedValue : 300

	For $i = 0 To $eTroopCount - 1
		Local $iCount = GUICtrlRead($g_ahTxtTrainWarTroopCount[$i])
		If $iCount > 0 Then
			$TotalTroopsToTrain += $iCount * $g_aiTroopSpace[$i]
		Else
			GUICtrlSetData($g_ahTxtTrainWarTroopCount[$i], 0)
		EndIf
	Next

	GUICtrlSetData($g_hLblCountWarTroopsTotal, String($TotalTroopsToTrain))

	If $TotalTroopsToTrain = $TotalArmyCamp Then
		GUICtrlSetBkColor($g_hLblCountWarTroopsTotal, 0xD1DFE7)
	ElseIf $TotalTroopsToTrain > $TotalArmyCamp / 2 And $TotalTroopsToTrain < $TotalArmyCamp Then
		GUICtrlSetBkColor($g_hLblCountWarTroopsTotal, $COLOR_ACTION)
	Else
		GUICtrlSetBkColor($g_hLblCountWarTroopsTotal, $COLOR_RED)
	EndIf

	Local $fPctOfCalculated = Floor(($TotalTroopsToTrain / $TotalArmyCamp) * 100)

	GUICtrlSetData($g_hCalTotalWarTroops, $fPctOfCalculated < 1 ? ($TotalTroopsToTrain > 0 ? 1 : 0) : $fPctOfCalculated)

	If $TotalTroopsToTrain > $TotalArmyCamp Then
		GUICtrlSetState($g_hLblTotalWarTroopsProgress, $GUI_SHOW)
	Else
		GUICtrlSetState($g_hLblTotalWarTroopsProgress, $GUI_HIDE)
	EndIf

EndFunc

Func lblTotalWarSpellCount($TotalArmyCamp = 0 )

	Local $TotalSpellsToBrew
	If $TotalArmyCamp = 0 Then $TotalArmyCamp = $g_iTotalSpellValue > 0 ? $g_iTotalSpellValue : 11

	For $i = 0 To $eSpellCount - 1
		Local $iCount = GUICtrlRead($g_ahTxtTrainWarSpellCount[$i])
		If $iCount > 0 Then
			$TotalSpellsToBrew += $iCount * $g_aiSpellSpace[$i]
		Else
			GUICtrlSetData($g_ahTxtTrainWarSpellCount[$i], 0)
		EndIf
	Next

	GUICtrlSetData($g_hLblCountWarSpellsTotal, String($TotalSpellsToBrew))

	If $TotalSpellsToBrew = $TotalArmyCamp Then
		GUICtrlSetBkColor($g_hLblCountWarSpellsTotal, 0xD1DFE7)
	ElseIf $TotalSpellsToBrew > $TotalArmyCamp / 2 And $TotalSpellsToBrew < $TotalArmyCamp Then
		GUICtrlSetBkColor($g_hLblCountWarSpellsTotal, $COLOR_ACTION)
	Else
		GUICtrlSetBkColor($g_hLblCountWarSpellsTotal, $COLOR_RED)
	EndIf

	Local $fPctOfCalculated = Floor(($TotalSpellsToBrew / $TotalArmyCamp) * 100)

	GUICtrlSetData($g_hCalTotalWarSpells, $fPctOfCalculated < 1 ? ($TotalSpellsToBrew > 0 ? 1 : 0) : $fPctOfCalculated)

	If $TotalSpellsToBrew > $TotalArmyCamp Then
		GUICtrlSetState($g_hLblTotalWarSpellsProgress, $GUI_SHOW)
	Else
		GUICtrlSetState($g_hLblTotalWarSpellsProgress, $GUI_HIDE)
	EndIf

EndFunc

Func TrainWarTroopCountEdit()
	For $i = 0 To $eTroopCount - 1
		If @GUI_CtrlId = $g_ahTxtTrainWarTroopCount[$i] Then
			$g_aiWarCompTroops[$i] = GUICtrlRead($g_ahTxtTrainWarTroopCount[$i])
			lblTotalWarTroopCount()
			Return
		EndIf
	Next
EndFunc

Func TrainWarSpellCountEdit()
	For $i = 0 To $eSpellCount - 1
		If @GUI_CtrlId = $g_ahTxtTrainWarSpellCount[$i] Then
			$g_aiWarCompSpells[$i] = GUICtrlRead($g_ahTxtTrainWarSpellCount[$i])
			lblTotalWarSpellCount()
			Return
		EndIf
	Next
EndFunc

Func ChkRequestCCForWar()
	If GUICtrlRead($g_hChkRequestCCForWar) = $GUI_CHECKED Then
		GUICtrlSetState($g_hTxtRequestCCForWar, $GUI_ENABLE)
	Else
		GUICtrlSetState($g_hTxtRequestCCForWar, $GUI_DISABLE)
	EndIf
EndFunc