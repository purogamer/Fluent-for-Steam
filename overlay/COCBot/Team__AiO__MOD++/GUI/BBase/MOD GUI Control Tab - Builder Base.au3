; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Control
; Description ...: This file Includes all functions to current GUI
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: ProMac (03-2018)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once
Func btnBBAtkLogClear()
	_GUICtrlRichEdit_SetText($g_hTxtBBAtkLog, "")
	BBAtkLogHead()
EndFunc   ;==>btnBBAtkLogClear

Func checkIfBBLogIsEmptyInitialize()
	;TODO:As this logic is not working when Switching from mini to normal
	;If StringLen(_GUICtrlRichEdit_GetText($g_hTxtBBAtkLog)) = 0 Then BBAtkLogHead()
EndFunc   ;==>checkIfBBLogIsEmptyInitialize

Func btnBBAtkLogCopyClipboard()
	Local $text = _GUICtrlRichEdit_GetText($g_hTxtBBAtkLog)
	$text = StringReplace($text, @CR, @CRLF)
	ClipPut($text)
EndFunc   ;==>btnBBAtkLogCopyClipboard

Func chkDebugBBattack()
	If GUICtrlRead($g_hDebugBBattack) = $GUI_CHECKED Then
		$g_bDebugBBattack = True
	Else
		$g_bDebugBBattack = False
	EndIf
EndFunc   ;==>chkDebugBBattack

Func chkBuilderAttack()
	If BitAND(GUICtrlGetState($g_hGUI_BUILDER_BASE), $GUI_SHOW) And GUICtrlRead($g_hGUI_BUILDER_BASE_TAB) = 2 Then ; fix flickring
		If GUICtrlRead($g_hChkBuilderAttack) = $GUI_CHECKED Then
			$g_bChkBuilderAttack = True
			GUISetState(@SW_SHOWNOACTIVATE, $g_hGUI_ATTACK_PLAN_BUILDER_BASE)
			GUISetState(@SW_SHOWNOACTIVATE, $g_hGUI_ATTACK_PLAN_BUILDER_BASE_CSV)
			GUICtrlSetState($g_hLblBuilderAttackDisabled, $GUI_HIDE)
		Else
			$g_bChkBuilderAttack = False
			GUISetState(@SW_HIDE, $g_hGUI_ATTACK_PLAN_BUILDER_BASE)
			GUISetState(@SW_HIDE, $g_hGUI_ATTACK_PLAN_BUILDER_BASE_CSV)
			GUICtrlSetState($g_hLblBuilderAttackDisabled, $GUI_SHOW)
		EndIf
	EndIf
EndFunc   ;==>chkBuilderAttack

Func cmbBBAttack()
	If _GUICtrlComboBox_GetCurSel($g_hCmbBBAttack) = $g_eBBAttackCSV Then
		GUICtrlSetState($g_hChkBBGetFromCSV, $GUI_HIDE)
		GUICtrlSetState($g_hChkBBGetFromArmy, $GUI_SHOW)
		GUICtrlSetState($g_hLblBBNextTroopDelay, $GUI_HIDE)
		GUICtrlSetState($g_hLblBBSameTroopDelay, $GUI_HIDE)
		GUICtrlSetState($g_hCmbBBNextTroopDelay, $GUI_HIDE)
		GUICtrlSetState($g_hCmbBBSameTroopDelay, $GUI_HIDE)
		GUICtrlSetState($g_hBtnBBDropOrder, $GUI_HIDE)
		GUICtrlSetState($g_hChkBBCustomAttack, $GUI_ENABLE)
		For $i = $g_hCmbBBAttackStyle[0] To $g_hIcnBBCSV_3[3] ; enable all csv stuff
			GUICtrlSetState($i, $GUI_ENABLE)
		Next
	Else
		GUICtrlSetState($g_hChkBBCustomAttack, $GUI_UNCHECKED) ; AIO ++
		ChkBBCustomAttack()
		GUICtrlSetState($g_hChkBBGetFromArmy, $GUI_HIDE)
		GUICtrlSetState($g_hChkBBGetFromCSV, $GUI_SHOW)
		ChkBBGetFromCSV()
		GUICtrlSetState($g_hLblBBNextTroopDelay, $GUI_SHOW)
		GUICtrlSetState($g_hLblBBSameTroopDelay, $GUI_SHOW)
		GUICtrlSetState($g_hCmbBBNextTroopDelay, $GUI_SHOW)
		GUICtrlSetState($g_hCmbBBSameTroopDelay, $GUI_SHOW)
		GUICtrlSetState($g_hBtnBBDropOrder, $GUI_SHOW)
		GUICtrlSetState($g_hChkBBCustomAttack, $GUI_UNCHECKED)
		GUICtrlSetState($g_hChkBBCustomAttack, $GUI_DISABLE)
	EndIf
EndFunc

Func ChkBBGetFromCSV()
	If GUICtrlRead($g_hChkBBGetFromCSV) = $GUI_CHECKED Then
		$g_bChkBBGetFromCSV = True
	Else
		$g_bChkBBGetFromCSV = False
	EndIf

	$g_iCmbBBAttack = _GUICtrlComboBox_GetCurSel($g_hCmbBBAttack)
	If $g_bChkBBGetFromCSV = True Or ($g_iCmbBBAttack = $g_eBBAttackCSV) Then
		For $i = $g_hCmbBBAttackStyle[0] To $g_hIcnBBCSV_3[3] ; enable all csv stuff
			GUICtrlSetState($i, $GUI_ENABLE)
		Next
	Else
		For $i = $g_hCmbBBAttackStyle[0] To $g_hIcnBBCSV_3[3] ; enable all csv stuff
			GUICtrlSetState($i, $GUI_DISABLE)
		Next
	EndIf
EndFunc   ;==>ChkBBGetFromCSV

Func ChkBBGetFromArmy()
	If GUICtrlRead($g_hChkBBGetFromArmy) = $GUI_CHECKED Then
		$g_bChkBBGetFromArmy = True
	Else
		$g_bChkBBGetFromArmy = False
	EndIf
EndFunc   ;==>ChkBBGetFromArmy

Func chkBBtrophiesRange()
	If GUICtrlRead($g_hChkBBTrophiesRange) = $GUI_CHECKED Then
		GUICtrlSetState($g_hTxtBBDropTrophiesMin, $GUI_ENABLE)
		GUICtrlSetState($g_hTxtBBDropTrophiesMax, $GUI_ENABLE)
	Else
		GUICtrlSetState($g_hTxtBBDropTrophiesMin, $GUI_DISABLE)
		GUICtrlSetState($g_hTxtBBDropTrophiesMax, $GUI_DISABLE)
	EndIf
EndFunc   ;==>chkBBtrophiesRange

Func chkBBStyle()
	For $i = 0 To 2
		Local $indexofscript = _GUICtrlComboBox_GetCurSel($g_hCmbBBAttackStyle[$i])
		Local $scriptname
		_GUICtrlComboBox_GetLBText($g_hCmbBBAttackStyle[$i], $indexofscript, $scriptname)
		$g_sAttackScrScriptNameBB[$i] = $scriptname
		SetDebugLog($g_sAttackScrScriptNameBB[$i] & " Loaded to use on BB attack!")
	Next
	cmbScriptNameBB()
EndFunc   ;==>chkBBStyle

Func PopulateComboScriptsFilesBB($spacficIndex = "-999") ;Define Impoisble Default Index
	Local $FileSearch, $NewFile
	$FileSearch = FileFindFirstFile($g_sCSVBBAttacksPath & "\*.csv")
	Local $output = ""
	While True
		$NewFile = FileFindNextFile($FileSearch)
		If @error Then ExitLoop
		$output = $output & StringLeft($NewFile, StringLen($NewFile) - 4) & "|"
	WEnd
	FileClose($FileSearch)
	;remove last |
	$output = StringLeft($output, StringLen($output) - 1)
	If $spacficIndex = "-999" Then
		;set 3 combo boxes
		For $i = 0 To 2
			;reset combo box
			_GUICtrlComboBox_ResetContent($g_hCmbBBAttackStyle[$i])
			GUICtrlSetData($g_hCmbBBAttackStyle[$i], $output)
			_GUICtrlComboBox_SetCurSel($g_hCmbBBAttackStyle[$i], _GUICtrlComboBox_FindStringExact($g_hCmbBBAttackStyle[$i], ""))
			GUICtrlSetData($g_hLblNotesScriptBB[$i], "")
		Next
	Else
		;reset combo box For Spacfic Index We Need This Logic For Reload Button
		_GUICtrlComboBox_ResetContent($g_hCmbBBAttackStyle[$spacficIndex])
		GUICtrlSetData($g_hCmbBBAttackStyle[$spacficIndex], $output)
		_GUICtrlComboBox_SetCurSel($g_hCmbBBAttackStyle[$spacficIndex], _GUICtrlComboBox_FindStringExact($g_hCmbBBAttackStyle[$spacficIndex], ""))
		GUICtrlSetData($g_hLblNotesScriptBB[$spacficIndex], "")
	EndIf
EndFunc   ;==>PopulateComboScriptsFilesBB

Func cmbScriptNameBB()
	For $i = 0 To 2
		Local $tempvect1 = _GUICtrlComboBox_GetListArray($g_hCmbBBAttackStyle[$i])
		Local $filename = $tempvect1[_GUICtrlComboBox_GetCurSel($g_hCmbBBAttackStyle[$i]) + 1]
		Local $f, $result = ""
		Local $tempvect, $line, $t

		If FileExists($g_sCSVBBAttacksPath & "\" & $filename & ".csv") Then
			$f = FileOpen($g_sCSVBBAttacksPath & "\" & $filename & ".csv", 0)
			; Read in lines of text until the EOF is reached
			While 1
				$line = FileReadLine($f)
				If @error = -1 Then ExitLoop
				$tempvect = StringSplit($line, "|", 2)
				If UBound($tempvect) >= 2 Then
					If StringStripWS(StringUpper($tempvect[0]), 2) = "NOTE" Then $result &= $tempvect[1] & @CRLF
				EndIf
			WEnd
			FileClose($f)
		EndIf
		GUICtrlSetData($g_hLblNotesScriptBB[$i], $result)
	Next
EndFunc   ;==>cmbScriptNameBB

Func UpdateComboScriptNameBB()
	For $i = 0 To 2
		Local $indexofscript = _GUICtrlComboBox_GetCurSel($g_hCmbBBAttackStyle[$i])
		Local $scriptname
		_GUICtrlComboBox_GetLBText($g_hCmbBBAttackStyle[$i], $indexofscript, $scriptname)
		PopulateComboScriptsFilesBB($i)
		_GUICtrlComboBox_SetCurSel($g_hCmbBBAttackStyle[$i], _GUICtrlComboBox_FindStringExact($g_hCmbBBAttackStyle[$i], $scriptname))
	Next
	cmbScriptNameBB()
EndFunc   ;==>UpdateComboScriptNameBB

Func EditScriptBB()
	Local $iCSVID = 0
	If @GUI_CtrlId == $g_hIcnBBCSV_2[1] Then
		$iCSVID = 1
	ElseIf @GUI_CtrlId == $g_hIcnBBCSV_3[1] Then
		$iCSVID = 2
	EndIf
	
	Local $tempvect1 = _GUICtrlComboBox_GetListArray($g_hCmbBBAttackStyle[$iCSVID])
	Local $filename = $tempvect1[_GUICtrlComboBox_GetCurSel($g_hCmbBBAttackStyle[$iCSVID]) + 1]
	Local $f, $result = ""
	Local $tempvect, $line, $t
	If FileExists($g_sCSVBBAttacksPath & "\" & $filename & ".csv") Then
		ShellExecute("notepad.exe", $g_sCSVBBAttacksPath & "\" & $filename & ".csv")
	EndIf
EndFunc   ;==>EditScriptBB

Func NewScriptBB()
	Local $filenameScript = InputBox(GetTranslatedFileIni("MBR Popups", "Func_AttackCSVAssignDefaultScriptName_Create", -1), GetTranslatedFileIni("MBR Popups", "Func_AttackCSVAssignDefaultScriptName_New_0", -1) & ":")
	If StringLen($filenameScript) > 0 Then
		If FileExists($g_sCSVBBAttacksPath & "\" & $filenameScript & ".csv") Then
			MsgBox("", "", GetTranslatedFileIni("MBR Popups", "Func_AttackCSVAssignDefaultScriptName_File-exists", -1))
		Else
			Local $hFileOpen = FileOpen($g_sCSVBBAttacksPath & "\" & $filenameScript & ".csv", $FO_APPEND)
			If $hFileOpen = -1 Then
				MsgBox($MB_SYSTEMMODAL, "", GetTranslatedFileIni("MBR Popups", "Func_AttackCSVAssignDefaultScriptName_Error", -1))
				Return False
			Else
				FileClose($hFileOpen)
				$g_sAttackScrScriptNameBB[0] = $filenameScript
				UpdateComboScriptNameBB()
			EndIf
		EndIf
	EndIf
EndFunc   ;==>NewScriptBB

Func DuplicateScriptBB()
	Local $iCSVID = 0
	If @GUI_CtrlId == $g_hIcnBBCSV_2[3] Then
		$iCSVID = 1
	ElseIf @GUI_CtrlId == $g_hIcnBBCSV_3[3] Then
		$iCSVID = 2
	EndIf
	
	Local $indexofscript = _GUICtrlComboBox_GetCurSel($g_hCmbBBAttackStyle[$iCSVID])
	Local $scriptname
	_GUICtrlComboBox_GetLBText($g_hCmbBBAttackStyle[$iCSVID], $indexofscript, $scriptname)
	$g_sAttackScrScriptNameBB[$iCSVID] = $scriptname
	Local $filenameScript = InputBox(GetTranslatedFileIni("MBR Popups", "Func_AttackCSVAssignDefaultScriptName_Copy_0", -1), GetTranslatedFileIni("MBR Popups", "Func_AttackCSVAssignDefaultScriptName_Copy_1", -1) & ": <" & $g_sAttackScrScriptNameBB[$iCSVID] & ">" & @CRLF & GetTranslatedFileIni("MBR Popups", "Func_AttackCSVAssignDefaultScriptName_New_1", -1) & ":")
	If StringLen($filenameScript) > 0 Then
		If FileExists($g_sCSVBBAttacksPath & "\" & $filenameScript & ".csv") Then
			MsgBox("", "", GetTranslatedFileIni("MBR Popups", "Func_AttackCSVAssignDefaultScriptName_File-exists", -1))
		Else
			Local $hFileOpen = FileCopy($g_sCSVBBAttacksPath & "\" & $g_sAttackScrScriptNameBB[$iCSVID] & ".csv", $g_sCSVBBAttacksPath & "\" & $filenameScript & ".csv")

			If $hFileOpen = -1 Then
				MsgBox($MB_SYSTEMMODAL, "", GetTranslatedFileIni("MBR Popups", "Func_AttackCSVAssignDefaultScriptName_Error", -1))
				Return False
			Else
				FileClose($hFileOpen)
				$g_sAttackScrScriptNameBB[$iCSVID] = $filenameScript
				UpdateComboScriptNameBB()
			EndIf
		EndIf
	EndIf
EndFunc   ;==>DuplicateScriptBB

Func ChkBBCustomAttack()
	If GUICtrlRead($g_hChkBBCustomAttack) = $GUI_CHECKED Then
		$g_bChkBBCustomAttack = True
		For $h = $g_hCmbBBAttackStyle[1] To $g_hIcnBBCSV_3[3]
			GUICtrlSetState($h, $GUI_ENABLE) ; AIO ++
		Next
	Else
		$g_bChkBBCustomAttack = False
		For $h = $g_hCmbBBAttackStyle[1] To $g_hIcnBBCSV_3[3]
			GUICtrlSetState($h, $GUI_DISABLE) ; AIO ++
		Next
	EndIf
	
	$g_iCmbBBAttack = _GUICtrlComboBox_GetCurSel($g_hCmbBBAttack)
	If $g_iCmbBBAttack = $g_eBBAttackCSV Then
		GUICtrlSetState($g_hChkBBGetFromCSV, $GUI_HIDE) ; AIO ++
		GUICtrlSetState($g_hChkBBGetFromArmy, $GUI_SHOW) ; AIO ++
	Else
		GUICtrlSetState($g_hChkBBGetFromCSV, $GUI_SHOW) ; AIO ++
		GUICtrlSetState($g_hChkBBGetFromArmy, $GUI_HIDE) ; AIO ++
	EndIf
EndFunc   ;==>ChkBBCustomAttack

; AIO
Func ChkBBWalls()
	If GUICtrlRead($g_hChkBBUpgradeWalls) = $GUI_CHECKED Then
		$g_bChkBBUpgradeWalls = True
		GUICtrlSetState($g_hLblBBWallLevelInfo, $GUI_ENABLE)
		GUICtrlSetState($g_hCmbBBWallLevel, $GUI_ENABLE)
		GUICtrlSetState($g_hLblBBWallCostInfo, $GUI_ENABLE)
		GUICtrlSetState($g_hLblBBWallCost, $GUI_ENABLE)
		GUICtrlSetState($g_hPicBBWallUpgrade, $GUI_SHOW)
		GUICtrlSetState($g_hBBWallNumber, $GUI_SHOW)
		GUICtrlSetState($g_hLblBBWallNumberInfo, $GUI_SHOW)
		GUICtrlSetState($g_hChkBBWallRing, $GUI_SHOW)
		GUICtrlSetState($g_hChkBBUpgWallsGold, $GUI_SHOW)
		GUICtrlSetState($g_hChkBBUpgWallsElixir, $GUI_SHOW)
	Else
		$g_bChkBBUpgradeWalls = False
		GUICtrlSetState($g_hLblBBWallLevelInfo, $GUI_DISABLE)
		GUICtrlSetState($g_hCmbBBWallLevel, $GUI_DISABLE)
		GUICtrlSetState($g_hLblBBWallCostInfo, $GUI_DISABLE)
		GUICtrlSetState($g_hLblBBWallCost, $GUI_DISABLE)
		GUICtrlSetState($g_hPicBBWallUpgrade, $GUI_HIDE)
		GUICtrlSetState($g_hBBWallNumber, $GUI_HIDE)
		GUICtrlSetState($g_hLblBBWallNumberInfo, $GUI_HIDE)
		GUICtrlSetState($g_hChkBBWallRing, $GUI_HIDE)
		GUICtrlSetState($g_hChkBBUpgWallsGold, $GUI_HIDE)
		GUICtrlSetState($g_hChkBBUpgWallsElixir, $GUI_HIDE)
	EndIf
EndFunc   ;==>ChkBBWalls

Func cmbBBWall()
	$g_iCmbBBWallLevel = _GUICtrlComboBox_GetCurSel($g_hCmbBBWallLevel)
	GUICtrlSetData($g_hLblBBWallCost, _NumberFormat($g_aWallBBInfoPerLevel[$g_iCmbBBWallLevel + 2][1]))
	_GUICtrlSetImage($g_hPicBBWallUpgrade, $g_sLibBBIconPath, $g_iCmbBBWallLevel + 20)
EndFunc   ;==>cmbBBWall

Func ChkBBAttackLoops()
	$g_iBBMinAttack = Int(GUICtrlRead($g_hTxtBBMinAttack))
    If $g_iBBMinAttack <= 0 Then GUICtrlSetData($g_hTxtBBMinAttack, 1)
	$g_iBBMaxAttack = Int(GUICtrlRead($g_hTxtBBMaxAttack))
    If $g_iBBMaxAttack <= 0 Then GUICtrlSetData($g_hTxtBBMaxAttack, 1)

    If $g_iBBMinAttack > $g_iBBMaxAttack Then
		If $g_iBBMaxAttack > 0 Then
			GUICtrlSetData($g_hTxtBBMinAttack, $g_iBBMaxAttack)
		Else
			GUICtrlSetData($g_hTxtBBMinAttack, 1)
			GUICtrlSetData($g_hTxtBBMaxAttack, 1)
		EndIf
	EndIf

EndFunc   ;==>ChkBBAttackLoops

#Region - Custom Yard - Team AIO Mod++
Func chkCleanBBYard()
	If GUICtrlRead($g_hChkCleanBBYard) = $GUI_CHECKED Then
		$g_bChkCleanBBYard = True
		GUICtrlSetState($g_hChkCleanYardBBAll, $GUI_ENABLE)
	Else
		$g_bChkCleanBBYard = False
		GUICtrlSetState($g_hChkCleanYardBBAll, $GUI_UNCHECKED)
		GUICtrlSetState($g_hChkCleanYardBBAll, $GUI_DISABLE)
	EndIf
	chkCleanBBYardAll()
EndFunc   ;==>chkCleanYardBB

Func chkCleanBBYardAll()
	$g_bChkCleanYardBBAll = (GUICtrlRead($g_hChkCleanYardBBAll) = $GUI_CHECKED) ? (True) : (False)
EndFunc   ;==>chkCleanYardBBall
#EndRegion - Custom Yard - Team AIO Mod++

Func chkStartClockTowerBoost()
	$g_bChkStartClockTowerBoost = (GUICtrlRead($g_hChkStartClockTowerBoost) = $GUI_CHECKED)
	If $g_bChkStartClockTowerBoost = True Then
		GUICtrlSetState($g_hCmbStartClockTowerBoost, $GUI_ENABLE)
	Else
		GUICtrlSetState($g_hCmbStartClockTowerBoost, $GUI_DISABLE)
	EndIf

EndFunc   ;==>chkStartClockTowerBoost

Func chkStartClockTowerBoostPotion()
	$g_bChkClockTowerPotion = (GUICtrlRead($g_hChkClockTowerPotion) = $GUI_CHECKED)
	If $g_bChkClockTowerPotion = True Then
		GUICtrlSetState($g_hCmbClockTowerPotion, $GUI_ENABLE)
	Else
		GUICtrlSetState($g_hCmbClockTowerPotion, $GUI_DISABLE)
	EndIf

EndFunc   ;==>chkStartClockTowerBoostPotion

#Region - Custom Improve - Team AIO Mod++
; W. W. You got me.
Func chkIgnoreUpgradesBB()
	For $i = 0 To UBound($g_hChkBBUpgradesToIgnore) -1
		If @GUI_CtrlId = $g_hChkBBUpgradesToIgnore[$i] Then
			$g_iChkBBUpgradesToIgnore[$i] = (GUICtrlRead($g_hChkBBUpgradesToIgnore[$i]) = $GUI_CHECKED) ? (1) : (0)
		EndIf
	Next
EndFunc   ;==>chkIgnoreUpgradesBB

Func chkBBUpgradesToIgnore()
	For $i = 0 To UBound($g_iChkBBUpgradesToIgnore) - 1
		$g_iChkBBUpgradesToIgnore[$i] = GUICtrlRead($g_hChkBBUpgradesToIgnore[$i]) = $GUI_CHECKED ? 1 : 0
	Next
EndFunc   ;==>chkBBUpgradesToIgnore

Func RadioIgnoreUpgradesBBOrOtto()
	If GUICtrlRead($g_hRadioBBCustomOTTO) = $GUI_UNCHECKED And GUICtrlRead($g_hRadioBBUpgradesToIgnore) = $GUI_UNCHECKED Then
		GUICtrlSetState($g_hRadioBBCustomOTTO, $GUI_CHECKED)
	EndIf
	
	If GUICtrlRead($g_hRadioBBCustomOTTO) = $GUI_CHECKED Then
		GUICtrlSetState($g_hChkPlacingNewBuildings, $GUI_CHECKED)
	EndIf
	
	Local $hMode = (GUICtrlRead($g_hRadioBBUpgradesToIgnore) = $GUI_CHECKED And GUICtrlRead($g_hChkBBSuggestedUpgrades) = $GUI_CHECKED) ? ($GUI_ENABLE) : ($GUI_DISABLE)
	
	For $hCtrl = $g_hChkBBUpgradesToIgnore[0] To $g_hChkBBUpgradesToIgnore[UBound($g_hChkBBUpgradesToIgnore) -1]
		GUICtrlSetState($hCtrl, $hMode)
	Next
	
EndFunc   ;==>RadioIgnoreUpgradesBBOrOtto
#EndRegion - Custom Improve - Team AIO Mod++
