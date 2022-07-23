; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Control Upgrade
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

Func InitTranslatedTextUpgradeTab()
	GetTranslatedFileIni("MBR GUI Design - AutoUpgrade", "MsgBox_Warning_Title", "Warning about your settings...")
	GetTranslatedFileIni("MBR GUI Design - AutoUpgrade", "MsgBox_Warning_Text", "Warning ! You selected 2 resources to ignore... That can be a problem,\r\n" & _
		"and Auto Upgrade can be ineffective, by not launching any upgrade...\r\n" & _
		"I recommend you to select only one resource, not more...")
	GetTranslatedFileIni("MBR GUI Design - AutoUpgrade", "MsgBox_Invalid_Title", "Invalid settings...")
	GetTranslatedFileIni("MBR GUI Design - AutoUpgrade", "MsgBox_Invalid_Text", "Warning ! You selected 3 resources to ignore... And you can't...\r\n" & _
		"With your settings, Auto Upgrade will be completely ineffective\r\n" & _
		"and will not launch any upgrade... You must deselect one or more\r\n" & _
		"ignored resource.")
EndFunc   ;==>InitTranslatedTextUpgradeTab

Func btnLocateUpgrades()
	Local $wasRunState = $g_bRunState
	$g_bRunState = True
	LocateUpgrades()
	$g_bRunState = $wasRunState
EndFunc   ;==>btnLocateUpgrades

Func btnchkbxUpgrade()
	For $i = 0 To UBound($g_avBuildingUpgrades, 1) - 1
		If GUICtrlRead($g_hChkUpgrade[$i]) = $GUI_CHECKED Then
			$g_abBuildingUpgradeEnable[$i] = True
		Else
			$g_abBuildingUpgradeEnable[$i] = False
		EndIf
	Next
EndFunc   ;==>btnchkbxUpgrade

Func btnchkbxRepeat()
	For $i = 0 To UBound($g_avBuildingUpgrades, 1) - 1
		If GUICtrlRead($g_hChkUpgradeRepeat[$i]) = $GUI_CHECKED Then
			$g_abUpgradeRepeatEnable[$i] = True
		Else
			$g_abUpgradeRepeatEnable[$i] = False
		EndIf
	Next
EndFunc   ;==>btnchkbxRepeat

Func picUpgradeTypeLocation()
	Local $wasRunState = $g_bRunState
	$g_bRunState = True
	PureClick(1, 40, 1, 0, "#9999") ; Clear screen
	Sleep(100)
	Zoomout() ; Zoom out if needed
	Local $inum
	For $inum = 0 To UBound($g_avBuildingUpgrades, 1) - 1
		If @GUI_CtrlId = $g_hPicUpgradeType[$inum] Then
			Local $x = $g_avBuildingUpgrades[$inum][0]
			Local $y = $g_avBuildingUpgrades[$inum][1]
			Local $n = $g_avBuildingUpgrades[$inum][4]
			SetDebugLog("Selecting #" & $inum + 1 & ": " & $n & ", " & $x & "/" & $y)
			If isInsideDiamondXY($x, $y) Then ; check for valid location
				BuildingClick($g_avBuildingUpgrades[$inum][0], $g_avBuildingUpgrades[$inum][1], "#9999")
				Sleep(100)
				If StringInStr($n, "collect", $STR_NOCASESENSEBASIC) Or _
						StringInStr($n, "mine", $STR_NOCASESENSEBASIC) Or _
						StringInStr($n, "drill", $STR_NOCASESENSEBASIC) Then
					Click(1, 40, 1, 0, "#0999") ;Click away to deselect collector if was not full, and collected with previous click
					Sleep(100)
					BuildingClick($g_avBuildingUpgrades[$inum][0], $g_avBuildingUpgrades[$inum][1], "#9999") ;Select collector
				EndIf
			EndIf
			ExitLoop
		EndIf
	Next
	$g_bRunState = $wasRunState
EndFunc   ;==>picUpgradeTypeLocation

Func btnResetUpgrade()
	Local $iEmptyRow=-1 ;-1 means no empty row found yet.
	Local $j=0 ;temp upgrade type or status
	;Sleep(5000)
	;SetDebugLog("Reset Upgarde *******************************************")
	For $i = 0 To UBound($g_avBuildingUpgrades, 1) - 1
		If GUICtrlRead($g_hChkUpgradeRepeat[$i]) = $GUI_CHECKED Then
		;SetDebugLog("Row to keep " & $i)
		  If $iEmptyRow<>-1 Then  ;Is there an empty row to fill?
		    ;SetDebugLog("Moving from " & $i)
			;SetDebugLog("Moving to " & $iEmptyRow)
		    ;Move this row up...
			$g_aiPicUpgradeStatus[$iEmptyRow] = $g_aiPicUpgradeStatus[$i] ; Upgrade status
		    $g_avBuildingUpgrades[$iEmptyRow][0] = $g_avBuildingUpgrades[$i][0] ;Upgrade Location X
		    $g_avBuildingUpgrades[$iEmptyRow][1] = $g_avBuildingUpgrades[$i][1] ;Upgrade Location Y
		    $g_avBuildingUpgrades[$iEmptyRow][2] = $g_avBuildingUpgrades[$i][2] ;Upgrade Value
			;SetDebugLog("Type setting to " & $g_avBuildingUpgrades[$i][3])
		    $g_avBuildingUpgrades[$iEmptyRow][3] = $g_avBuildingUpgrades[$i][3] ;Upgrade Type
			;SetDebugLog("Name in global setting to " & $g_avBuildingUpgrades[$i][4])
		    $g_avBuildingUpgrades[$iEmptyRow][4] = $g_avBuildingUpgrades[$i][4] ;Upgrade Unit Name
			;SetDebugLog("Level in global setting to " & $g_avBuildingUpgrades[$i][5])
		    $g_avBuildingUpgrades[$iEmptyRow][5] = $g_avBuildingUpgrades[$i][5] ;Upgrade Level
		    $g_avBuildingUpgrades[$iEmptyRow][6] = $g_avBuildingUpgrades[$i][6] ;Upgrade Duration
		    $g_avBuildingUpgrades[$iEmptyRow][7] = $g_avBuildingUpgrades[$i][7] ;Upgrade Finish Time

			;Set the GUI data for new row and clear the GUI data for the cleared row.
			;GUI Unit Name
			;SetDebugLog("Setting name " & $g_avBuildingUpgrades[$iEmptyRow][4])
			GUICtrlSetData($g_hTxtUpgradeName[$iEmptyRow], $g_avBuildingUpgrades[$iEmptyRow][4])
			GUICtrlSetData($g_hTxtUpgradeName[$i], "")
			;GUI Unit Level
			;SetDebugLog("Setting level " & $g_avBuildingUpgrades[$iEmptyRow][5])
			GUICtrlSetData($g_hTxtUpgradeLevel[$iEmptyRow], $g_avBuildingUpgrades[$iEmptyRow][5])
		    GUICtrlSetData($g_hTxtUpgradeLevel[$i], "")
			;Upgrade value in GUI
			GUICtrlSetData($g_hTxtUpgradeValue[$iEmptyRow], $g_avBuildingUpgrades[$iEmptyRow][2])
		    GUICtrlSetData($g_hTxtUpgradeValue[$i], "")
		    ;Upgrade duration in GUI
			GUICtrlSetData($g_hTxtUpgradeTime[$iEmptyRow], $g_avBuildingUpgrades[$iEmptyRow][6])
			GUICtrlSetData($g_hTxtUpgradeTime[$i], "")

			;GUI upgrade type image
			$j = $eIcnElixir
			If $g_avBuildingUpgrades[$iEmptyRow][3] = "GOLD" Then $j = $eIcnGold
			;SetDebugLog("Setting GUI type to " & $j)
			_GUICtrlSetImage($g_hPicUpgradeType[$iEmptyRow], $g_sLibIconPath, $j)
		    _GUICtrlSetImage($g_hPicUpgradeType[$i], $g_sLibIconPath, $eIcnBlank)

			;GUI Status icon : Still not working right!
			;$eIcnTroops=43, $eIcnGreenLight=69, $eIcnRedLight=71 or $eIcnYellowLight=73
			;SetDebugLog("Setting status to " & $g_aiPicUpgradeStatus[$i])
			;$j=$g_aiPicUpgradeStatus[$i]
			;No idea why this crap is needed, but I can't pass a variable to _GUICtrlSetImage
			$j=$eIcnGreenLight
			If $g_aiPicUpgradeStatus[$i] = $eIcnYellowLight Then $j=$eIcnYellowLight
			$g_aiPicUpgradeStatus[$iEmptyRow] = $j
			_GUICtrlSetImage($g_hPicUpgradeStatus[$iEmptyRow], $g_sLibIconPath, $j)
		    ;SetDebugLog("Clearing old status to red light " & $eIcnRedLight)
			$g_aiPicUpgradeStatus[$i] = $eIcnRedLight ;blank row goes red
			_GUICtrlSetImage($g_hPicUpgradeStatus[$i], $g_sLibIconPath, $eIcnRedLight)

			;Upgrade selection box
			GUICtrlSetState($g_hChkUpgrade[$iEmptyRow], $GUI_CHECKED)
			GUICtrlSetState($g_hChkUpgrade[$i], $GUI_UNCHECKED)
			;Upgrade finish time in GUI
			GUICtrlSetData($g_hTxtUpgradeEndTime[$iEmptyRow], $g_avBuildingUpgrades[$iEmptyRow][7])
		    GUICtrlSetData($g_hTxtUpgradeEndTime[$i], "")
			;Repeat box
			GUICtrlSetState($g_hChkUpgradeRepeat[$iEmptyRow], $GUI_CHECKED)
		    GUICtrlSetState($g_hChkUpgradeRepeat[$i], $GUI_UNCHECKED)

			;Now clear the row we just moved from.
			$g_avBuildingUpgrades[$i][0] = -1 ;Upgrade Location X
		    $g_avBuildingUpgrades[$i][1] = -1 ;Upgrade Location Y
		    $g_avBuildingUpgrades[$i][2] = -1 ;Upgrade Value
		    $g_avBuildingUpgrades[$i][3] = "" ;Upgrade Type
		    $g_avBuildingUpgrades[$i][4] = "" ;Upgrade Unit Name
		    $g_avBuildingUpgrades[$i][5] = "" ;Upgrade Level
		    $g_avBuildingUpgrades[$i][6] = "" ;Upgrade Duration
		    $g_avBuildingUpgrades[$i][7] = "" ;Upgrade Finish Time


			$i = $iEmptyRow ;Reset counter to this row so we continue forward from here.
			$iEmptyRow = -1 ;This should be the first empty row now.

		  Else
			;set these to clear up old status icon issues on rows not moved
		    ;SetDebugLog("Not moving row " & $i)
			$j=$g_aiPicUpgradeStatus[$i]
			;SetDebugLog("Setting GUI status to " & $j) ;
			;Following works if a constant is used, but not an variable?
			if $j=69 then _GUICtrlSetImage($g_hPicUpgradeStatus[$i], $g_sLibIconPath, 69)
			if $j=73 then _GUICtrlSetImage($g_hPicUpgradeStatus[$i], $g_sLibIconPath, 73)
			ContinueLoop
		  Endif
		Else ;Row not checked.  Clear it.
		  ;SetDebugLog("Row not checked, clearing row " & $i)
		  $g_avBuildingUpgrades[$i][0] = -1 ;Upgrade position x
		  $g_avBuildingUpgrades[$i][1] = -1 ;Upgrade position y
		  $g_avBuildingUpgrades[$i][2] = -1 ;Upgrade value
		  $g_avBuildingUpgrades[$i][3] = "" ;Upgrade Type
		  $g_avBuildingUpgrades[$i][4] = "" ;Upgrade Unit Name
		  $g_avBuildingUpgrades[$i][5] = "" ;Upgrade Level
		  $g_avBuildingUpgrades[$i][6] = "" ;Upgrade Duration
		  $g_avBuildingUpgrades[$i][7] = "" ;Upgrade Finish Time
		  GUICtrlSetData($g_hTxtUpgradeName[$i], "")  ;GUI Unit Name
		  GUICtrlSetData($g_hTxtUpgradeLevel[$i], "") ;GUI Unit Level
		  GUICtrlSetData($g_hTxtUpgradeValue[$i], "") ;Upgrade value in GUI
		  GUICtrlSetData($g_hTxtUpgradeTime[$i], "")  ;Upgrade duration in GUI
		  _GUICtrlSetImage($g_hPicUpgradeType[$i], $g_sLibIconPath, $eIcnBlank) ;Upgrade type blank
		  $g_aiPicUpgradeStatus[$i] = $eIcnRedLight
		  _GUICtrlSetImage($g_hPicUpgradeStatus[$i], $g_sLibIconPath, $eIcnRedLight) ;Upgrade status to not ready
		  GUICtrlSetState($g_hChkUpgrade[$i], $GUI_UNCHECKED) ;Change upgrade selection box to unchecked
		  GUICtrlSetData($g_hTxtUpgradeEndTime[$i], "") ;Clear Upgrade time in GUI
		  GUICtrlSetState($g_hChkUpgradeRepeat[$i], $GUI_UNCHECKED) ;Change repeat box to unchecked
		  If $iEmptyRow = -1 Then $iEmptyRow=$i ;This row is now empty.
		Endif
	Next
EndFunc   ;==>btnResetUpgrade

#Region - Custom lab - Team AIO Mod++
Func chkLab()
	If GUICtrlRead($g_hChkAutoLabUpgrades) = $GUI_CHECKED Then
		$g_bAutoLabUpgradeEnable = True
		GUICtrlSetState($g_hPicLabUpgrade, $GUI_SHOW)
		GUICtrlSetState($g_hLblNextUpgrade, $GUI_ENABLE)
		GUICtrlSetState($g_hCmbLaboratory, $GUI_ENABLE)
		_GUICtrlSetImage($g_hPicLabUpgrade, $g_sLibIconPath, $g_avLabTroops[$g_iCmbLaboratory][1])
	Else
		$g_bAutoLabUpgradeEnable = False
		GUICtrlSetState($g_hPicLabUpgrade, $GUI_HIDE)
		GUICtrlSetState($g_hLblNextUpgrade, $GUI_DISABLE)
		GUICtrlSetState($g_hCmbLaboratory, $GUI_DISABLE)
		_GUICtrlSetImage($g_hPicLabUpgrade, $g_sLibIconPath, $g_avLabTroops[0][1])
	EndIf
	If $g_iCmbLaboratory = 0 Then 
		GUICtrlSetState($g_hChkLabUpgradeOrder, $GUI_ENABLE)
	Else
		GUICtrlSetState($g_hChkLabUpgradeOrder, $GUI_DISABLE)
	EndIf
	LabStatusGUIUpdate()
EndFunc   ;==>chkLab
	
Func chkLabUpgradeOrder()
	If GUICtrlRead($g_hChkLabUpgradeOrder) = $GUI_CHECKED Then
		$g_bLabUpgradeOrderEnable = True
		GUICtrlSetState($g_hCmbLaboratory, $GUI_DISABLE)
		GUICtrlSetState($g_hBtnRemoveLabUpgradeOrder, $GUI_ENABLE)
		GUICtrlSetState($g_hBtnSetLabUpgradeOrder, $GUI_ENABLE)
		For $i = 0 To UBound($g_ahCmbLabUpgradeOrder) - 1
			GUICtrlSetState($g_ahCmbLabUpgradeOrder[$i], $GUI_ENABLE)
		Next
	Else
		$g_bLabUpgradeOrderEnable = False
		GUICtrlSetState($g_hCmbLaboratory, $GUI_ENABLE)
		GUICtrlSetState($g_hBtnRemoveLabUpgradeOrder, $GUI_DISABLE)
		GUICtrlSetState($g_hBtnSetLabUpgradeOrder, $GUI_DISABLE)
		For $i = 0 To UBound($g_ahCmbLabUpgradeOrder) - 1
			GUICtrlSetState($g_ahCmbLabUpgradeOrder[$i], $GUI_DISABLE)
		Next
	EndIf
EndFunc ;==>chkLabUpgradeOrder

Func chkSLabUpgradeOrder()
	If GUICtrlRead($g_hChkSLabUpgradeOrder) = $GUI_CHECKED Then
		$g_bSLabUpgradeOrderEnable = True
		$g_iCmbStarLaboratory = 0 ; Custom - Team AIO Mod++
        _GUICtrlComboBox_SetCurSel($g_hCmbStarLaboratory, 0) ; Custom - Team AIO Mod++
		_GUICtrlSetImage($g_hPicStarLabUpgrade, $g_sLibIconPath, $g_avStarLabTroops[$g_iCmbStarLaboratory][4]) ; Custom - Team AIO Mod++	
		GUICtrlSetState($g_hCmbStarLaboratory, $GUI_DISABLE)
		GUICtrlSetState($g_hBtnRemoveSLabUpgradeOrder, $GUI_ENABLE)
		GUICtrlSetState($g_hBtnSetSLabUpgradeOrder, $GUI_ENABLE)
		For $i = 0 To UBound($g_ahCmbSLabUpgradeOrder) - 1
			GUICtrlSetState($g_ahCmbSLabUpgradeOrder[$i], $GUI_ENABLE)
		Next
	Else
		$g_bSLabUpgradeOrderEnable = False
		GUICtrlSetState($g_hCmbStarLaboratory, $GUI_ENABLE)
		GUICtrlSetState($g_hBtnRemoveSLabUpgradeOrder, $GUI_DISABLE)
		GUICtrlSetState($g_hBtnSetSLabUpgradeOrder, $GUI_DISABLE)
		For $i = 0 To UBound($g_ahCmbSLabUpgradeOrder) - 1
			GUICtrlSetState($g_ahCmbSLabUpgradeOrder[$i], $GUI_DISABLE)
		Next
	EndIf
EndFunc ;==>chkSLabUpgradeOrder

Func cmbLabUpgradeOrder()
	Local $iGUI_CtrlId = @GUI_CtrlId
	For $i = 0 To UBound($g_ahCmbLabUpgradeOrder) - 1 ; check for duplicate combobox index and flag problem
		If $iGUI_CtrlId = $g_ahCmbLabUpgradeOrder[$i] Then ContinueLoop
		If _GUICtrlComboBox_GetCurSel($iGUI_CtrlId) = _GUICtrlComboBox_GetCurSel($g_ahCmbLabUpgradeOrder[$i]) Then
			_GUICtrlComboBox_SetCurSel($g_ahCmbLabUpgradeOrder[$i], -1)
			GUISetState()
		EndIf
	Next
EndFunc   ;==>cmbLabUpgradeOrder

Func cmbSLabUpgradeOrder()
	Local $iGUI_CtrlId = @GUI_CtrlId
	For $i = 0 To UBound($g_ahCmbSLabUpgradeOrder) - 1 ; check for duplicate combobox index and flag problem
		If $iGUI_CtrlId = $g_ahCmbSLabUpgradeOrder[$i] Then ContinueLoop
		If _GUICtrlComboBox_GetCurSel($iGUI_CtrlId) = _GUICtrlComboBox_GetCurSel($g_ahCmbSLabUpgradeOrder[$i]) Then
			_GUICtrlComboBox_SetCurSel($g_ahCmbSLabUpgradeOrder[$i], -1)
			GUISetState()
		EndIf
	Next
EndFunc   ;==>cmbSLabUpgradeOrder

Func btnRemoveLabUpgradeOrder()
	For $i = 0 To UBound($g_ahCmbLabUpgradeOrder) - 1
		_GUICtrlComboBox_SetCurSel($g_ahCmbLabUpgradeOrder[$i], -1)
	Next
EndFunc

Func btnRemoveSLabUpgradeOrder()
	For $i = 0 To UBound($g_ahCmbSLabUpgradeOrder) - 1
		_GUICtrlComboBox_SetCurSel($g_ahCmbSLabUpgradeOrder[$i], -1)
	Next
EndFunc

Func btnSetLabUpgradeOrder()
	Local $d
	SetLog("Set Laboratory upgrade Order",$COLOR_SUCCESS)
	For $i = 0 To UBound($g_ahCmbLabUpgradeOrder) - 1
		$g_aCmbLabUpgradeOrder[$i] = _GUICtrlComboBox_GetCurSel($g_ahCmbLabUpgradeOrder[$i])
		$d = $g_aCmbLabUpgradeOrder[$i]
		SetLog($i + 1 & " : " & $g_avLabTroops[$d+1][0], $COLOR_SUCCESS)
	Next
EndFunc

Func btnSetSLabUpgradeOrder()
	Local $d
	SetLog("Set Star Laboratory ugrade Order",$COLOR_SUCCESS)
	For $i = 0 To UBound($g_ahCmbSLabUpgradeOrder) - 1
		$g_aCmbSLabUpgradeOrder[$i] = _GUICtrlComboBox_GetCurSel($g_ahCmbSLabUpgradeOrder[$i])
		$d = $g_aCmbSLabUpgradeOrder[$i]
		SetLog($i + 1 & " : " & $g_avStarLabTroops[$d+1][3], $COLOR_SUCCESS)
	Next
EndFunc

Func BBUpgradeOrder()
	GUISetState(@SW_SHOW, $g_hGUI_BBUpgradeOrder)
EndFunc   ;==>btnBBDropOrder

Func BBUpgradeOrderClose()
	GUISetState(@SW_HIDE, $g_hGUI_BBUpgradeOrder)
EndFunc   ;==>BBUpgradeOrderClose
#EndRegion - Custom lab - Team AIO Mod++

Func chkStarLab()
	If GUICtrlRead($g_hChkAutoStarLabUpgrades) = $GUI_CHECKED Then
		$g_bAutoStarLabUpgradeEnable = True
		GUICtrlSetState($g_hBtnBBUpgradeOrderGUI, $GUI_ENABLE) ; Custom - Team AIO Mod++
		GUICtrlSetState($g_hPicStarLabUpgrade, $GUI_SHOW)
		GUICtrlSetState($g_hLblNextSLUpgrade, $GUI_ENABLE)
		GUICtrlSetState($g_hCmbStarLaboratory, $GUI_ENABLE)
		_GUICtrlSetImage($g_hPicStarLabUpgrade, $g_sLibIconPath, $g_avStarLabTroops[$g_iCmbStarLaboratory][4])
	Else
		$g_bAutoStarLabUpgradeEnable = False
		GUICtrlSetState($g_hBtnBBUpgradeOrderGUI, $GUI_DISABLE) ; Custom - Team AIO Mod++
		GUICtrlSetState($g_hPicStarLabUpgrade, $GUI_HIDE)
		GUICtrlSetState($g_hLblNextSLUpgrade, $GUI_DISABLE)
		GUICtrlSetState($g_hCmbStarLaboratory, $GUI_DISABLE)
		_GUICtrlSetImage($g_hPicStarLabUpgrade, $g_sLibIconPath, $g_avStarLabTroops[0][4])
		BBUpgradeOrderClose() ; Custom - Team AIO Mod++
	EndIf
	 ; Custom - Team AIO Mod++
	; If $g_iCmbStarLaboratory = 0 Then 
		; GUICtrlSetState($g_hChkSLabUpgradeOrder, $GUI_ENABLE)
	; Else
		; GUICtrlSetState($g_hChkSLabUpgradeOrder, $GUI_DISABLE)
	; EndIf
	StarLabStatusGUIUpdate()
EndFunc   ;==>chkStarLab

Func LabStatusGUIUpdate()
	If _DateIsValid($g_sLabUpgradeTime) Then
		_GUICtrlSetTip($g_hBtnResetLabUpgradeTime, GetTranslatedFileIni("MBR Func_Village_Upgrade", "BtnResetLabUpgradeTime_Info_01", "Visible Red button means that laboratory upgrade in process") & @CRLF & _
				GetTranslatedFileIni("MBR Func_Village_Upgrade", "BtnResetLabUpgradeTime_Info_02", "This will automatically disappear when near time for upgrade to be completed.") & @CRLF & _
				GetTranslatedFileIni("MBR Func_Village_Upgrade", "BtnResetLabUpgradeTime_Info_03", "If upgrade has been manually finished with gems before normal end time,") & @CRLF & _
				GetTranslatedFileIni("MBR Func_Village_Upgrade", "BtnResetLabUpgradeTime_Info_04", "Click red button to reset internal upgrade timer BEFORE STARTING NEW UPGRADE") & @CRLF & _
				GetTranslatedFileIni("MBR Func_Village_Upgrade", "BtnResetLabUpgradeTime_Info_05", "Caution - Unnecessary timer reset will force constant checks for lab status") & @CRLF & @CRLF & _
				GetTranslatedFileIni("MBR Func_Village_Upgrade", "BtnResetLabUpgradeTime_Info_06", "Troop Upgrade started") & ", " & _
				GetTranslatedFileIni("MBR Func_Village_Upgrade", "BtnResetLabUpgradeTime_Info_07", "Will begin to check completion at:") & " " & $g_sLabUpgradeTime & @CRLF & " ")
		GUICtrlSetState($g_hBtnResetLabUpgradeTime, $GUI_SHOW)
		GUICtrlSetState($g_hBtnResetLabUpgradeTime, $GUI_ENABLE)
	Else
		GUICtrlSetState($g_hBtnResetLabUpgradeTime, $GUI_HIDE) ; comment this line out to edit GUI
		GUICtrlSetState($g_hBtnResetLabUpgradeTime, $GUI_DISABLE)
	EndIf
EndFunc   ;==>LabStatusGUIUpdate

Func StarLabStatusGUIUpdate()
	If _DateIsValid($g_sStarLabUpgradeTime) Then
		_GUICtrlSetTip($g_hBtnResetStarLabUpgradeTime, GetTranslatedFileIni("MBR Func_Village_Upgrade", "BtnResetLabUpgradeTime_Info_01", "Visible Red button means that laboratory upgrade in process") & @CRLF & _
				GetTranslatedFileIni("MBR Func_Village_Upgrade", "BtnResetLabUpgradeTime_Info_02", "This will automatically disappear when near time for upgrade to be completed.") & @CRLF & _
				GetTranslatedFileIni("MBR Func_Village_Upgrade", "BtnResetLabUpgradeTime_Info_03", "If upgrade has been manually finished with gems before normal end time,") & @CRLF & _
				GetTranslatedFileIni("MBR Func_Village_Upgrade", "BtnResetLabUpgradeTime_Info_04", "Click red button to reset internal upgrade timer BEFORE STARTING NEW UPGRADE") & @CRLF & _
				GetTranslatedFileIni("MBR Func_Village_Upgrade", "BtnResetLabUpgradeTime_Info_05", "Caution - Unnecessary timer reset will force constant checks for lab status") & @CRLF & @CRLF & _
				GetTranslatedFileIni("MBR Func_Village_Upgrade", "BtnResetLabUpgradeTime_Info_06", "Troop Upgrade started") & ", " & _
				GetTranslatedFileIni("MBR Func_Village_Upgrade", "BtnResetLabUpgradeTime_Info_07", "Will begin to check completion at:") & " " & $g_sStarLabUpgradeTime & @CRLF & " ")
		GUICtrlSetState($g_hBtnResetStarLabUpgradeTime, $GUI_SHOW)
		GUICtrlSetState($g_hBtnResetStarLabUpgradeTime, $GUI_ENABLE)
	Else
		GUICtrlSetState($g_hBtnResetStarLabUpgradeTime, $GUI_HIDE)
		GUICtrlSetState($g_hBtnResetStarLabUpgradeTime, $GUI_DISABLE)
	EndIf
EndFunc   ;==>StarLabStatusGUIUpdate

Func cmbLab()
	$g_iCmbLaboratory = _GUICtrlComboBox_GetCurSel($g_hCmbLaboratory)
	_GUICtrlSetImage($g_hPicLabUpgrade, $g_sLibIconPath, $g_avLabTroops[$g_iCmbLaboratory][1])
	If $g_iCmbLaboratory = 0 Then
		GUICtrlSetState($g_hChkLabUpgradeOrder, $GUI_ENABLE)
		; SetLog($g_iCmbLaboratory)
	Else
		GUICtrlSetState($g_hChkLabUpgradeOrder, $GUI_DISABLE)
		; SetLog($g_iCmbLaboratory)
	EndIf
	chkLabUpgradeOrder()
EndFunc   ;==>cmbLab

Func cmbStarLab()
	$g_iCmbStarLaboratory = _GUICtrlComboBox_GetCurSel($g_hCmbStarLaboratory)
	_GUICtrlSetImage($g_hPicStarLabUpgrade, $g_sLibIconPath, $g_avStarLabTroops[$g_iCmbStarLaboratory][4])
	; Custom - Team AIO Mod++
	; If $g_iCmbStarLaboratory = 0 Then
		; GUICtrlSetState($g_hChkSLabUpgradeOrder, $GUI_ENABLE)
	; Else
		; GUICtrlSetState($g_hChkSLabUpgradeOrder, $GUI_DISABLE)
	; Endif
	chkSLabUpgradeOrder()
EndFunc   ;==>cmbStarLab

Func ResetLabUpgradeTime()
	; Display are you sure message
	_ExtMsgBoxSet(1 + 64, $SS_CENTER, 0x004080, 0xFFFF00, 12, "Comic Sans MS", 600)
	Local $stext = @CRLF & GetTranslatedFileIni("MBR Func_Village_Upgrade", "Lab_GUIUpdate_Info_07", "Are you 100% sure you want to reset lab upgrade timer?") & @CRLF & _
			GetTranslatedFileIni("MBR Func_Village_Upgrade", "Lab_GUIUpdate_Info_08", "Click OK to reset") & @CRLF & GetTranslatedFileIni("MBR Func_Village_Upgrade", "Lab_GUIUpdate_Info_09", "Or Click Cancel to exit") & @CRLF
	Local $MsgBox = _ExtMsgBox(0, GetTranslatedFileIni("MBR Func_Village_Upgrade", "Lab_GUIUpdate_Info_10", "Reset timer") & "|" & GetTranslatedFileIni("MBR Func_Village_Upgrade", "Lab_GUIUpdate_Info_11", "Cancel and Return"), _
							   GetTranslatedFileIni("MBR Func_Village_Upgrade", "Lab_GUIUpdate_Info_12", "Reset laboratory upgrade timer?"), $stext, 120, $g_hFrmBot)
	SetDebugLog("$MsgBox= " & $MsgBox, $COLOR_DEBUG)
	If $MsgBox = 1 Then
		$g_sLabUpgradeTime = ""
		_GUICtrlSetTip($g_hBtnResetLabUpgradeTime, GetTranslatedFileIni("MBR Func_Village_Upgrade", "BtnResetLabUpgradeTime_Info_01", "Visible Red button means that laboratory upgrade in process") & @CRLF & _
				GetTranslatedFileIni("MBR Func_Village_Upgrade", "BtnResetLabUpgradeTime_Info_02", "This will automatically disappear when near time for upgrade to be completed.") & @CRLF & _
				GetTranslatedFileIni("MBR Func_Village_Upgrade", "BtnResetLabUpgradeTime_Info_03", "If upgrade has been manually finished with gems before normal end time,") & @CRLF & _
				GetTranslatedFileIni("MBR Func_Village_Upgrade", "BtnResetLabUpgradeTime_Info_04", "Click red button to reset internal upgrade timer BEFORE STARTING NEW UPGRADE") & @CRLF & _
				GetTranslatedFileIni("MBR Func_Village_Upgrade", "BtnResetLabUpgradeTime_Info_05", "Caution - Unnecessary timer reset will force constant checks for lab status"))
	EndIf
	If _DateIsValid($g_sLabUpgradeTime) Then
		GUICtrlSetState($g_hBtnResetLabUpgradeTime, $GUI_SHOW)
		GUICtrlSetState($g_hBtnResetLabUpgradeTime, $GUI_ENABLE)
	Else
		GUICtrlSetState($g_hBtnResetLabUpgradeTime, $GUI_HIDE)
		GUICtrlSetState($g_hBtnResetLabUpgradeTime, $GUI_DISABLE)
	EndIf
EndFunc   ;==>ResetLabUpgradeTime

Func ResetStarLabUpgradeTime()
	; Display are you sure message
	_ExtMsgBoxSet(1 + 64, $SS_CENTER, 0x004080, 0xFFFF00, 12, "Comic Sans MS", 600)
	Local $stext = @CRLF & GetTranslatedFileIni("MBR Func_Village_Upgrade", "Lab_GUIUpdate_Info_07", "Are you 100% sure you want to reset lab upgrade timer?") & @CRLF & _
			GetTranslatedFileIni("MBR Func_Village_Upgrade", "Lab_GUIUpdate_Info_08", "Click OK to reset") & @CRLF & GetTranslatedFileIni("MBR Func_Village_Upgrade", "Lab_GUIUpdate_Info_09", "Or Click Cancel to exit") & @CRLF
	Local $MsgBox = _ExtMsgBox(0, GetTranslatedFileIni("MBR Func_Village_Upgrade", "Lab_GUIUpdate_Info_10", "Reset timer") & "|" & GetTranslatedFileIni("MBR Func_Village_Upgrade", "Lab_GUIUpdate_Info_11", "Cancel and Return"), _
							   GetTranslatedFileIni("MBR Func_Village_Upgrade", "Lab_GUIUpdate_Info_12", "Reset laboratory upgrade timer?"), $stext, 120, $g_hFrmBot)
	SetDebugLog("$MsgBox= " & $MsgBox, $COLOR_DEBUG)
	If $MsgBox = 1 Then
		$g_sStarLabUpgradeTime = ""
		_GUICtrlSetTip($g_hBtnResetStarLabUpgradeTime, GetTranslatedFileIni("MBR Func_Village_Upgrade", "BtnResetLabUpgradeTime_Info_01", "Visible Red button means that laboratory upgrade in process") & @CRLF & _
				GetTranslatedFileIni("MBR Func_Village_Upgrade", "BtnResetLabUpgradeTime_Info_02", "This will automatically disappear when near time for upgrade to be completed.") & @CRLF & _
				GetTranslatedFileIni("MBR Func_Village_Upgrade", "BtnResetLabUpgradeTime_Info_03", "If upgrade has been manually finished with gems before normal end time,") & @CRLF & _
				GetTranslatedFileIni("MBR Func_Village_Upgrade", "BtnResetLabUpgradeTime_Info_04", "Click red button to reset internal upgrade timer BEFORE STARTING NEW UPGRADE") & @CRLF & _
				GetTranslatedFileIni("MBR Func_Village_Upgrade", "BtnResetLabUpgradeTime_Info_05", "Caution - Unnecessary timer reset will force constant checks for lab status"))
	EndIf
	If _DateIsValid($g_sStarLabUpgradeTime) Then
		GUICtrlSetState($g_hBtnResetStarLabUpgradeTime, $GUI_SHOW)
		GUICtrlSetState($g_hBtnResetStarLabUpgradeTime, $GUI_ENABLE)
	Else
		GUICtrlSetState($g_hBtnResetStarLabUpgradeTime, $GUI_HIDE)
		GUICtrlSetState($g_hBtnResetStarLabUpgradeTime, $GUI_DISABLE)
	EndIf
EndFunc   ;==>ResetLabUpgradeTime

Func chkUpgradeKing()
	If $g_iTownHallLevel > 6 Or $g_iTownHallLevel < 1 Then ; Must be TH7 or above to have King
		If GUICtrlRead($g_hCmbBoostBarbarianKing) > 0 Then
			GUICtrlSetState($g_hChkUpgradeKing, $GUI_DISABLE)
			GUICtrlSetState($g_hChkUpgradeKing, $GUI_UNCHECKED)
			$g_bUpgradeKingEnable = False
		Else
			GUICtrlSetState($g_hChkUpgradeKing, $GUI_ENABLE)
		EndIf

		Local $ahGroupKingWait[4] = [$g_hChkDBKingWait, $g_hChkABKingWait, $g_hPicDBKingWait, $g_hPicABKingWait]
		Local $TxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "TxtKingWait_Info_01", -1) & @CRLF & _
						GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "TxtKingWait_Info_02", -1)
		Local $TxtWarningTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "TxtKingWait_Info_03", "ATTENTION: King auto upgrade is currently enable.")
		If GUICtrlRead($g_hChkUpgradeKing) = $GUI_CHECKED Then
			$g_bUpgradeKingEnable = True
			_GUI_Value_STATE("SHOW", $groupKingSleeping)
			For $i In $ahGroupKingWait
				_GUICtrlSetTip($i, $TxtTip & @CRLF & $TxtWarningTip)
			Next
		Else
			$g_bUpgradeKingEnable = False
			_GUI_Value_STATE("HIDE", $groupKingSleeping)
			For $i In $ahGroupKingWait
				_GUICtrlSetTip($i, $TxtTip)
			Next
		EndIf

	Else
		GUICtrlSetState($g_hChkUpgradeKing, BitOR($GUI_DISABLE, $GUI_UNCHECKED))
	EndIf
EndFunc   ;==>chkUpgradeKing

Func chkUpgradeQueen()
	If $g_iTownHallLevel > 8 Or $g_iTownHallLevel < 1 Then ; Must be TH9 or above to have Queen
		If GUICtrlRead($g_hCmbBoostArcherQueen) > 0 Then
			GUICtrlSetState($g_hChkUpgradeQueen, $GUI_DISABLE)
			GUICtrlSetState($g_hChkUpgradeQueen, $GUI_UNCHECKED)
			$g_bUpgradeQueenEnable = False
		Else
			GUICtrlSetState($g_hChkUpgradeQueen, $GUI_ENABLE)
		EndIf

		Local $ahGroupQueenWait[4] = [$g_hChkDBQueenWait, $g_hChkABQueenWait, $g_hPicDBQueenWait, $g_hPicABQueenWait]
		Local $TxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "TxtQueenWait_Info_01", -1) & @CRLF & _
						GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "TxtQueenWait_Info_02", -1)
		Local $TxtWarningTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "TxtQueenWait_Info_03", "ATTENTION: Queen auto upgrade is currently enable.")
		If GUICtrlRead($g_hChkUpgradeQueen) = $GUI_CHECKED Then
			$g_bUpgradeQueenEnable = True
			_GUI_Value_STATE("SHOW", $groupQueenSleeping)
			For $i In $ahGroupQueenWait
				_GUICtrlSetTip($i, $TxtTip & @CRLF & $TxtWarningTip)
			Next
		Else
			$g_bUpgradeQueenEnable = False
			_GUI_Value_STATE("HIDE", $groupQueenSleeping)
			For $i In $ahGroupQueenWait
				_GUICtrlSetTip($i, $TxtTip)
			Next
		EndIf
	Else
		GUICtrlSetState($g_hChkUpgradeQueen, BitOR($GUI_DISABLE, $GUI_UNCHECKED))
	EndIf
EndFunc   ;==>chkUpgradeQueen

Func chkUpgradeWarden()
	If $g_iTownHallLevel > 10 Or $g_iTownHallLevel < 1 Then ; Must be TH11 to have warden
		If GUICtrlRead($g_hCmbBoostWarden) > 0 Then
			GUICtrlSetState($g_hChkUpgradeWarden, $GUI_DISABLE)
			GUICtrlSetState($g_hChkUpgradeWarden, $GUI_UNCHECKED)
			$g_bUpgradeWardenEnable = False
		Else
			GUICtrlSetState($g_hChkUpgradeWarden, $GUI_ENABLE)
		EndIf

		Local $ahGroupWardenWait[4] = [$g_hChkDBWardenWait, $g_hChkABWardenWait, $g_hPicDBWardenWait, $g_hPicABWardenWait]
		Local $TxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "TxtWardenWait_Info_01", -1) & @CRLF & _
						GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "TxtWardenWait_Info_02", -1)
		Local $TxtWarningTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "TxtWardenWait_Info_03", "ATTENTION: Warden auto upgrade is currently enable.")
		If GUICtrlRead($g_hChkUpgradeWarden) = $GUI_CHECKED Then
			$g_bUpgradeWardenEnable = True
			_GUI_Value_STATE("SHOW", $groupWardenSleeping)
			For $i In $ahGroupWardenWait
				_GUICtrlSetTip($i, $TxtTip & @CRLF & $TxtWarningTip)
			Next
		Else
			$g_bUpgradeWardenEnable = False
			_GUI_Value_STATE("HIDE", $groupWardenSleeping)
			For $i In $ahGroupWardenWait
				_GUICtrlSetTip($i, $TxtTip)
			Next
		EndIf
	Else
		GUICtrlSetState($g_hChkUpgradeWarden, BitOR($GUI_DISABLE, $GUI_UNCHECKED))
	EndIf
EndFunc   ;==>chkUpgradeWarden

Func chkUpgradeChampion()
	If $g_iTownHallLevel > 12 Or $g_iTownHallLevel < 1 Then ; Must be TH13 to have Champion
		If GUICtrlRead($g_hCmbBoostChampion) > 0 Then
			GUICtrlSetState($g_hChkUpgradeChampion, $GUI_DISABLE)
			GUICtrlSetState($g_hChkUpgradeChampion, $GUI_UNCHECKED)
			$g_bUpgradeChampionEnable = False
		Else
			GUICtrlSetState($g_hChkUpgradeChampion, $GUI_ENABLE)
		EndIf

		Local $ahGroupChampionWait[4] = [$g_hChkDBChampionWait, $g_hChkABChampionWait, $g_hPicDBChampionWait, $g_hPicABChampionWait]
		Local $TxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "TxtChampionWait_Info_01", -1) & @CRLF & _
						GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "TxtChampionWait_Info_02", -1)
		Local $TxtWarningTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "TxtChampionWait_Info_03", "ATTENTION: Champion auto upgrade is currently enable.")
		If GUICtrlRead($g_hChkUpgradeChampion) = $GUI_CHECKED Then
			$g_bUpgradeChampionEnable = True
			_GUI_Value_STATE("SHOW", $groupChampionSleeping)
			For $i In $ahGroupChampionWait
				_GUICtrlSetTip($i, $TxtTip & @CRLF & $TxtWarningTip)
			Next
		Else
			$g_bUpgradeChampionEnable = False
			_GUI_Value_STATE("HIDE", $groupChampionSleeping)
			For $i In $ahGroupChampionWait
				_GUICtrlSetTip($i, $TxtTip)
			Next
		EndIf
	Else
		GUICtrlSetState($g_hChkUpgradeChampion, BitOR($GUI_DISABLE, $GUI_UNCHECKED))
	EndIf
EndFunc   ;==>chkUpgradeChampion

Func cmbHeroReservedBuilder()
	$g_iHeroReservedBuilder = _GUICtrlComboBox_GetCurSel($g_hCmbHeroReservedBuilder)
	If $g_iTownHallLevel > 6 Then ; Must be TH7 or above to have Heroes
		If $g_iTownHallLevel > 12 Then ; For TH13 enable up to 4 reserved builders
			GUICtrlSetData($g_hCmbHeroReservedBuilder, "|0|1|2|3|4", "0")
		ElseIf $g_iTownHallLevel > 10 Then ; For TH11 enable up to 3 reserved builders
			GUICtrlSetData($g_hCmbHeroReservedBuilder, "|0|1|2|3", "0")
		ElseIf $g_iTownHallLevel > 8 Then ; For TH9 enable up to 2 reserved builders
			GUICtrlSetData($g_hCmbHeroReservedBuilder, "|0|1|2", "0")
		Else ; For TH7 enable up to 1 reserved builder
			GUICtrlSetData($g_hCmbHeroReservedBuilder, "|0|1", "0")
		EndIf
		GUICtrlSetState($g_hCmbHeroReservedBuilder, $GUI_ENABLE)
		GUICtrlSetState($g_hLblHeroReservedBuilderTop, $GUI_ENABLE)
		GUICtrlSetState($g_hLblHeroReservedBuilderBottom, $GUI_ENABLE)
	Else
		GUICtrlSetState($g_hCmbHeroReservedBuilder, $GUI_DISABLE)
		GUICtrlSetState($g_hLblHeroReservedBuilderTop, $GUI_DISABLE)
		GUICtrlSetState($g_hLblHeroReservedBuilderBottom, $GUI_DISABLE)
	EndIf
	_GUICtrlComboBox_SetCurSel($g_hCmbHeroReservedBuilder, $g_iHeroReservedBuilder)
EndFunc   ;==>cmbHeroReservedBuilder

Func chkWalls()
	If GUICtrlRead($g_hChkWalls) = $GUI_CHECKED Then
		$g_bAutoUpgradeWallsEnable = True
		GUICtrlSetState($g_hRdoUseGold, $GUI_ENABLE)
		; GUICtrlSetState($sldMaxNbWall, $GUI_ENABLE)
		;GUICtrlSetState($sldToleranceWall, $GUI_ENABLE)
		;GUICtrlSetState($g_hBtnFindWalls, $GUI_ENABLE)
		;		GUICtrlSetState($g_hRdoUseElixir, $GUI_ENABLE)
		;		GUICtrlSetState($g_hRdoUseElixirGold, $GUI_ENABLE)
		GUICtrlSetState($g_hCmbWalls, $GUI_ENABLE)
		GUICtrlSetState($g_hTxtWallMinGold, $GUI_ENABLE)
		;		GUICtrlSetState($g_hTxtWallMinElixir, $GUI_ENABLE)
		cmbWalls()
	Else
		$g_bAutoUpgradeWallsEnable = False
		GUICtrlSetState($g_hRdoUseGold, $GUI_DISABLE)
		GUICtrlSetState($g_hRdoUseElixir, $GUI_DISABLE)
		GUICtrlSetState($g_hRdoUseElixirGold, $GUI_DISABLE)
		GUICtrlSetState($g_hCmbWalls, $GUI_DISABLE)
		GUICtrlSetState($g_hTxtWallMinGold, $GUI_DISABLE)
		GUICtrlSetState($g_hTxtWallMinElixir, $GUI_DISABLE)
		; GUICtrlSetState($sldMaxNbWall, $GUI_DISABLE)
		;GUICtrlSetState($sldToleranceWall, $GUI_DISABLE)
		;GUICtrlSetState($g_hBtnFindWalls, $GUI_DISABLE)

	EndIf
EndFunc   ;==>chkWalls

Func chkSaveWallBldr()
	$g_bUpgradeWallSaveBuilder = (GUICtrlRead($g_hChkSaveWallBldr) = $GUI_CHECKED)
	chkwallspriorities()
EndFunc   ;==>chkSaveWallBldr

Func cmbWalls()
	$g_iCmbUpgradeWallsLevel = _GUICtrlComboBox_GetCurSel($g_hCmbWalls)
	$g_iWallCost = $g_aiWallCost[$g_iCmbUpgradeWallsLevel]
	GUICtrlSetData($g_hLblWallCost, _NumberFormat($g_iWallCost))

   For $i = 4 To $g_iCmbUpgradeWallsLevel+5
	  GUICtrlSetState($g_ahWallsCurrentCount[$i], $GUI_SHOW)
	  GUICtrlSetState($g_ahPicWallsLevel[$i], $GUI_SHOW)
   Next
   For $i = $g_iCmbUpgradeWallsLevel+6 To 15
	  GUICtrlSetState($g_ahWallsCurrentCount[$i], $GUI_HIDE)
	  GUICtrlSetState($g_ahPicWallsLevel[$i], $GUI_HIDE)
   Next

   If $g_iCmbUpgradeWallsLevel <= 3 Then GUICtrlSetState($g_hRdoUseGold, $GUI_CHECKED)

   GUICtrlSetState($g_hRdoUseElixir, $g_iCmbUpgradeWallsLevel <= 3 ? $GUI_DISABLE : $GUI_ENABLE)
   GUICtrlSetState($g_hRdoUseElixirGold, $g_iCmbUpgradeWallsLevel <= 3 ? $GUI_DISABLE : $GUI_ENABLE)
   GUICtrlSetState($g_hTxtWallMinElixir, $g_iCmbUpgradeWallsLevel <= 3 ? $GUI_DISABLE : $GUI_ENABLE)
EndFunc   ;==>cmbWalls

Func btnWalls()
	Local $wasRunState = $g_bRunState
	$g_bRunState = True
	Zoomout()
	$g_iCmbUpgradeWallsLevel = _GUICtrlComboBox_GetCurSel($g_hCmbWalls)
	If imglocCheckWall() Then SetLog("Hey Chef! We found the Wall!")
	$g_bRunState = $wasRunState
	AndroidShield("btnWalls") ; Update shield status due to manual $g_bRunState
EndFunc   ;==>btnWalls

; New building MV - Team AIO Mod++
; Magic Items - Team AIO Mod++
Func chkAutoUpgrade()
	If GUICtrlRead($g_hChkAutoUpgrade) = $GUI_CHECKED Then
		$g_bAutoUpgradeEnabled = True
		For $h = $g_hChkAutoBuildNew To $g_hTxtAutoUpgradeLog
			If $g_hChkBuilderPotion = $h Or $g_hCmbInputBuilderPotion = $h Then ContinueLoop
			GUICtrlSetState($h, $GUI_ENABLE)
		Next
	Else
		$g_bAutoUpgradeEnabled = False
		For $h = $g_hChkAutoBuildNew To $g_hTxtAutoUpgradeLog
			If $g_hChkBuilderPotion = $h Or $g_hCmbInputBuilderPotion = $h Then ContinueLoop
			GUICtrlSetState($h, $GUI_DISABLE)
		Next
	EndIf
EndFunc   ;==>chkAutoUpgrade

Func chkResourcesToIgnore()
	For $i = 0 To 2
		$g_iChkResourcesToIgnore[$i] = GUICtrlRead($g_hChkResourcesToIgnore[$i]) = $GUI_CHECKED ? 1 : 0
	Next

	Local $iIgnoredResources = 0
	For $i = 0 To 2
		If $g_iChkResourcesToIgnore[$i] = 1 Then $iIgnoredResources += 1
	Next
	Switch $iIgnoredResources
		Case 2
			MsgBox(0 + 16, GetTranslatedFileIni("MBR GUI Design - AutoUpgrade", "MsgBox_Warning_Title", "-1"), _
					GetTranslatedFileIni("MBR GUI Design - AutoUpgrade", "MsgBox_Warning_Text", "-1"))
		Case 3
			MsgBox(0 + 16, GetTranslatedFileIni("MBR GUI Design - AutoUpgrade", "MsgBox_Invalid_Title", "-1"), _
					GetTranslatedFileIni("MBR GUI Design - AutoUpgrade", "MsgBox_Invalid_Text", "-1"))
	EndSwitch
EndFunc   ;==>chkResourcesToIgnore

Func chkUpgradesToIgnore()
	For $i = 0 To UBound($g_iChkUpgradesToIgnore) - 1 ; Custom Improve - Team AIO Mod++
		$g_iChkUpgradesToIgnore[$i] = GUICtrlRead($g_hChkUpgradesToIgnore[$i]) = $GUI_CHECKED ? 1 : 0
	Next
EndFunc   ;==>chkUpgradesToIgnore

Func chkUpgradePets()
	For $i = 0 to $ePetCount - 1
		If GUICtrlRead($g_hChkUpgradePets[$i]) = $GUI_CHECKED Then
			$g_bUpgradePetsEnable[$i] = True
			SetDebugLog("Upgrade: " & $g_asPetNames[$i] & " enabled")
		Else
			$g_bUpgradePetsEnable[$i] = False
			SetDebugLog("Upgrade: " & $g_asPetNames[$i] & " disabled")
		EndIf
	Next
EndFunc