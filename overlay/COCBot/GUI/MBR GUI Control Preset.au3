; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Control Preset
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

Func PopulatePresetComboBox()
	Local $FileSearch, $NewFile
	$FileSearch = FileFindFirstFile($g_sProfilePresetPath & "\*.ini")
	Local $output = ""
	While True
		$NewFile = FileFindNextFile($FileSearch)
		If @error Then ExitLoop
		$output = $output & StringLeft($NewFile, StringLen($NewFile) - 4) & "|"
	WEnd
	FileClose($FileSearch)
	;remove last |
	$output = StringLeft($output, StringLen($output) - 1)
	;reset combo box
	_GUICtrlComboBox_ResetContent($g_hCmbPresetList)
	;set combo box
	GUICtrlSetData($g_hCmbPresetList, $output)

EndFunc   ;==>PopulatePresetComboBox

Func PresetLoadConfigInfo()
	Local $inputfilename = $g_sProfilePresetPath & "\" & GUICtrlRead($g_hCmbPresetList) & ".ini"
	SetDebugLog("PresetLoadConfigInfo: " & $inputfilename)
	Local $message = IniRead($inputfilename, "Preset", "info", "")
	If StringInStr($message, "\n") > 0 Then
		GUICtrlSetData($g_hTxtPresetMessage, StringReplace($message, "\n", @CRLF))
	Else
		GUICtrlSetData($g_hTxtPresetMessage, $message)
	EndIf

	GUICtrlSetState($g_hLblLoadPresetMessage, $GUI_HIDE)
	GUICtrlSetState($g_hTxtPresetMessage, $GUI_SHOW)
	GUICtrlSetState($g_hBtnGUIPresetLoadConf, $GUI_SHOW)
	GUICtrlSetState($g_hBtnGUIPresetDeleteConf, $GUI_SHOW + $GUI_DISABLE)
	GUICtrlSetState($g_hChkDeleteConf, $GUI_UNCHECKED)
	GUICtrlSetState($g_hChkDeleteConf, $GUI_SHOW)

EndFunc   ;==>PresetLoadConfigInfo

Func PresetLoadConf()
	Local $filename = GUICtrlRead($g_hCmbPresetList)
	$g_sProfileSecondaryInputFileName = $g_sProfilePresetPath & "\" & $filename & ".ini"
	SetDebugLog("PresetLoadConf: " & $g_sProfileSecondaryInputFileName)
;~ 	CloseGUIPreset()
	SaveConfig()
	readConfig()
	applyConfig(False) ; bot window redraw stays disabled!
	_GUICtrlTab_ClickTab($g_hTabMain, 0)
	SetRedrawBotWindow(True, Default, Default, Default, "PresetLoadConf") ; enable redraw again, applyConfig(False) keeps it disabled
	SetLog("Config " & $filename & " LOADED!", $COLOR_SUCCESS)
	$g_sProfileSecondaryInputFileName = ""
EndFunc   ;==>PresetLoadConf


Func PresetSaveConf()

	;1 remove .ini from filename
	Local $filename = GUICtrlRead($g_hTxtPresetSaveFilename)
	If StringRight($filename, 4) = ".ini" Then
		$filename = StringLeft($filename, StringLen($filename) - 4)
		GUICtrlSetData($g_hTxtPresetSaveFilename, $filename)
	EndIf

	;2 check illegal caracter and replace
	If StringRegExp($filename, '\\|/|:|\*|\?|\"|\<|\>|\|') Then GUICtrlSetData($g_hTxtPresetSaveFilename, StringRegExpReplace($filename, '\\|/|:|\*|\?|\"|\<|\>|\|', "_"))

	;3 check if file already exists
	If FileExists($g_sProfilePresetPath & "\" & $filename & ".ini") Then
		Local $i = 2
		While $i > 0
			If FileExists($g_sProfilePresetPath & "\" & $filename & " (" & $i & ").ini") Then
				$i += 1
			Else
				$filename = $filename & " (" & $i & ")"
				GUICtrlSetData($g_hTxtPresetSaveFilename, $filename)
				$i = 0
			EndIf
		WEnd
	EndIf

	;4 save config
	Local $msg = StringReplace(GUICtrlRead($g_hTxtSavePresetMessage), @CRLF, "\n")
	$g_sProfileSecondaryOutputFileName = $g_sProfilePresetPath & "\" & $filename & ".ini"
	SetDebugLog("PresetSaveConf: " & $g_sProfileSecondaryInputFileName)
	IniWrite($g_sProfileSecondaryOutputFileName, "preset", "info", $msg)
;~ 	CloseGUIPreset()
	saveConfig()
	readconfig()
	applyConfig()
	_GUICtrlTab_ClickTab($g_hTabMain, 0)
	SetLog("Config " & $filename & " SAVED!", $COLOR_SUCCESS)
	$g_sProfileSecondaryOutputFileName = ""

EndFunc   ;==>PresetSaveConf

Func PresetDeleteConf()
	Local $button = MsgBox($MB_ICONWARNING + $MB_OKCANCEL, GetTranslatedFileIni("MBR Popups", "Func_PresetDeleteConf_Info_01", "Delete Configuration"), GetTranslatedFileIni("MBR Popups", "Func_PresetDeleteConf_Info_02", 'Are you sure you want to delete the configuration ?') & GUICtrlRead($g_hCmbPresetList) & '"?' & @CRLF & _
			"This cannot be undone.")
	If $button = $IDOK Then
		SetDebugLog("PresetDeleteConf: " & $g_sProfilePresetPath & "\" & GUICtrlRead($g_hCmbPresetList) & ".ini")
		FileDelete($g_sProfilePresetPath & "\" & GUICtrlRead($g_hCmbPresetList) & ".ini")
;~ 		applyPreset()
		saveconfig()
		readconfig()
		applyConfig()
	EndIf
EndFunc   ;==>PresetDeleteConf

Func chkCheckDeleteConf()
	If GUICtrlRead($g_hChkDeleteConf) = $GUI_CHECKED Then
		GUICtrlSetState($g_hBtnGUIPresetDeleteConf, $GUI_ENABLE)
	Else
		GUICtrlSetState($g_hBtnGUIPresetDeleteConf, $GUI_DISABLE)
	EndIf

EndFunc   ;==>chkCheckDeleteConf
;==================================================================


Func MakeSavePresetMessage()
	Local $message = ""

	$message &= "NOTES:" & @CRLF & @CRLF


	If $g_bDropTrophyEnable Then $message &= "TROPHIES RANGE: " & $g_iDropTrophyMin & " - " & $g_iDropTrophyMax & @CRLF & @CRLF
	$message &= "TRAIN ARMY SETTINGS:" & @CRLF
	$message &= "- Custom Train Troops:" & @CRLF
	For $i = 0 To $eTroopCount - 1
		If $g_aiArmyCompTroops[$i] > 0 Then
			$message &= "  " & $g_asTroopShortNames[$i] & " " & $g_aiArmyCompTroops[$i] & "x"
			If Mod($i + 1, 4) = 0 Then $message &= @CRLF
		EndIf
	Next
	$message &= @CRLF

	$message &= "SEARCH SETTINGS:" & @CRLF
	For $i = $DB To $LB
		If IsSearchModeActive($i, True) Then
			Switch $i
				Case $DB
					$message &= "- DB search: "
				Case $LB
					$message &= "- AB search: "
			EndSwitch
			If $g_abSearchSearchesEnable[$i] Then $message &= " " & "s. " & $g_aiSearchSearchesMin[$i] & "-" & $g_aiSearchSearchesMax[$i]
			If $g_abSearchTropiesEnable[$i] Then $message &= "  " & "t. " & $g_aiSearchTrophiesMin[$i] & "-" & $g_aiSearchTrophiesMax[$i]
			If $g_abSearchCampsEnable[$i] Then $message &= " " & "c. >" & $g_aiSearchCampsPct[$i] & "%"
			$message &= @CRLF
			Switch $i
				Case $DB
					$message &= "- DB filter: "
				Case $LB
					$message &= "- AB filter: "
			EndSwitch
			Switch $g_aiFilterMeetGE[$i]
				Case 0
					$message &= " G >= " & $g_aiFilterMinGold[$i]
					$message &= " & "
					$message &= " E >= " & $g_aiFilterMinElixir[$i] & "  "
				Case 1
					$message &= " G >= " & $g_aiFilterMinGold[$i]
					$message &= " or "
					$message &= " E >= " & $g_aiFilterMinElixir[$i] & "  "
				Case 2
					$message &= " G+E >= " & $g_aiFilterMinGoldPlusElixir[$i] & "  "
			EndSwitch
			If $g_abFilterMeetDEEnable[$i] Then $message &= " D >= " & $g_aiFilterMeetDEMin[$i] & "  "
			If $g_abFilterMeetTrophyEnable[$i] Then $message &= " TR >= " & $g_aiFilterMeetTrophyMin[$i] & "  "
			If $g_abFilterMeetTrophyEnable[$i] Then $message &= " TR <= " & $g_aiFilterMeetTrophyMax[$i] & "  "
			If $g_abFilterMeetTH[$i] Then $message &= " TH >= " & $g_aiFilterMeetTHMin[$i] + 6 & "  "
			If $g_abFilterMeetTHOutsideEnable[$i] Then $message &= " THO" & "  "
			If IsWeakBaseActive($i) Then $message &= " WB" & "  "
			If $g_abFilterMeetOneConditionEnable[$i] Then $message &= " MeetOne" & "  "
			$message &= @CRLF
		EndIf
	Next



	$message &= @CRLF & "ATTACK SETTINGS:" & @CRLF
	For $i = $DB To $LB
		If IsSearchModeActive($i, True) Then
			Switch $i
				Case $DB
					$message &= "- DB: "
				Case $LB
					$message &= "- AS: "
			EndSwitch
			If $i = $DB Or $i = $LB Then
				Switch $g_aiAttackAlgorithm[$i]
					Case "0"
						$message &= "Standard Attack > "
					Case "1"
						$message &= "Scripted Attack > "
					Case "2"
						$message &= "SmartFarm Attack > "
				EndSwitch
			EndIf

			If ($i = $DB Or $i = $LB) And $g_aiAttackAlgorithm[$i] = 0 Then
				Local $tmp = StringSplit("one side|two sides|three sides|four sides|DE side|TH side", "|", 2)
				$message &= $tmp[$g_aiAttackStdDropSides[$i]] & @CRLF
			EndIf
			If ($i = $DB Or $i = $LB) And $g_aiAttackAlgorithm[$i] = 2 Then
				$message &= "Inside resource: " & $g_iTxtInsidePercentage & " | "
				$message &= "Outside resource: " & $g_iTxtOutsidePercentage
				if ($i = $DB) And $g_bChkEnableRandom[1] = True Then
					$message &= " | Delay Unit: " & $g_iDeployDelay[1]
					$message &= " | Delay Wave: " & $g_iDeployWave[1]
				EndIf
				If ($i = $DB) And $g_bMaxSidesSF = True Then
					$message &= " | Max Sides to Attack: " & $g_iCmbMaxSidesSF
				EndIf
			EndIf
		EndIf
	Next


	$message &= @CRLF & "END BATTLE SETTINGS:" & @CRLF
	For $i = $DB To $LB
		If IsSearchModeActive($i, True) Then
			Switch $i
				Case $DB
					$message &= "- DB: "
				Case $LB
					$message &= "- AB: "
			EndSwitch
			If $g_abStopAtkNoLoot1Enable[$i] Then $message &= "wait " & $g_aiStopAtkNoLoot1Time[$i] & "  "
			If $g_abStopAtkNoLoot2Enable[$i] Then $message &= "wait " & $g_aiStopAtkNoLoot2Time[$i] & " ->(" & $g_aiStopAtkNoLoot2MinGold[$i] & "," & $g_aiStopAtkNoLoot2MinElixir[$i] & "," & $g_aiStopAtkNoLoot2MinDark[$i] & ")  "
			If $g_abStopAtkNoResources[$i] Then $message &= "nores "
			If $g_abStopAtkOneStar[$i] Then $message &= "1star  "
			If $g_abStopAtkTwoStars[$i] Then $message &= "2stars  "

		EndIf
		$message &= @CRLF
	Next


	GUICtrlSetData($g_hTxtSavePresetMessage, $message)
EndFunc   ;==>MakeSavePresetMessage

Func btnStrategyFolder()
	ShellExecute("explorer", $g_sProfilePresetPath)
EndFunc   ;==>btnStrategyFolder
