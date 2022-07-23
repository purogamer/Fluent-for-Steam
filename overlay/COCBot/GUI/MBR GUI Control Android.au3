; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Control Android
; Description ...: This file Includes all functions to current GUI
; Syntax ........: None
; Parameters ....:
; Return values .: None
; Author ........: MMHK (11-2016)
; Modified ......: CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Func LoadCOCDistributorsComboBox()
	Local $sDistributors = $g_sNO_COC
	Local $aDistributorsData = GetCOCDistributors()

	If @error = 2 Then
		$sDistributors = $g_sUNKNOWN_COC
	ElseIf IsArray($aDistributorsData) Then
		$sDistributors = _ArrayToString($aDistributorsData, "|")
	EndIf

	GUICtrlSetData($g_hCmbCOCDistributors, "", "")
	GUICtrlSetData($g_hCmbCOCDistributors, $sDistributors)
EndFunc   ;==>LoadCOCDistributorsComboBox

Func SetCurSelCmbCOCDistributors()
	Local $sIniDistributor
	Local $iIndex
	If _GUICtrlComboBox_GetCount($g_hCmbCOCDistributors) = 1 Then ; when no/unknown/one coc installed
		_GUICtrlComboBox_SetCurSel($g_hCmbCOCDistributors, 0)
		GUICtrlSetState($g_hCmbCOCDistributors, $GUI_DISABLE)
	Else
		$sIniDistributor = GetCOCTranslated($g_sAndroidGameDistributor)
		$iIndex = _GUICtrlComboBox_FindStringExact($g_hCmbCOCDistributors, $sIniDistributor)
		If $iIndex = -1 Then ; not found on combo
			_GUICtrlComboBox_SetCurSel($g_hCmbCOCDistributors, 0)
		Else
			_GUICtrlComboBox_SetCurSel($g_hCmbCOCDistributors, $iIndex)
		EndIf
		GUICtrlSetState($g_hCmbCOCDistributors, $GUI_ENABLE)
	EndIf
EndFunc   ;==>SetCurSelCmbCOCDistributors

Func cmbCOCDistributors()
	Local $sDistributor
	_GUICtrlComboBox_GetLBText($g_hCmbCOCDistributors, _GUICtrlComboBox_GetCurSel($g_hCmbCOCDistributors), $sDistributor)

	If $sDistributor = $g_sUserGameDistributor Then ; ini user option
		$g_sAndroidGameDistributor = $g_sUserGameDistributor
		$g_sAndroidGamePackage = $g_sUserGamePackage
		$g_sAndroidGameClass = $g_sUserGameClass
	Else
		GetCOCUnTranslated($sDistributor)
		If Not @error Then ; not no/unknown
			$g_sAndroidGameDistributor = GetCOCUnTranslated($sDistributor)
			$g_sAndroidGamePackage = GetCOCPackage($sDistributor)
			$g_sAndroidGameClass = GetCOCClass($sDistributor)
		EndIf ; else existing one (no emulator bot startup compatible), if wrong ini info either kept or replaced by cursel when saveconfig, not fall back to google
	EndIf
EndFunc   ;==>cmbCOCDistributors

Func AndroidSuspendFlagsToIndex($iFlags)
	Local $idx = 0
	If BitAND($iFlags, 2) > 0 Then
		$idx = 2
	ElseIf BitAND($iFlags, 1) > 0 Then
		$idx = 1
	EndIf
	If $idx > 0 And BitAND($iFlags, 4) > 0 Then $idx += 2
	Return $idx
EndFunc   ;==>AndroidSuspendFlagsToIndex

Func AndroidSuspendIndexToFlags($idx)
	Local $iFlags = 0
	Switch $idx
		Case 1
			$iFlags = 1
		Case 2
			$iFlags = 2
		Case 3
			$iFlags = 1 + 4
		Case 4
			$iFlags = 2 + 4
	EndSwitch
	Return $iFlags
EndFunc   ;==>AndroidSuspendIndexToFlags

Func cmbSuspendAndroid()
	$g_iAndroidSuspendModeFlags = AndroidSuspendIndexToFlags(_GUICtrlComboBox_GetCurSel($g_hCmbSuspendAndroid))
EndFunc   ;==>cmbSuspendAndroid

Func cmbAndroidBackgroundMode()
	$g_iAndroidBackgroundMode = _GUICtrlComboBox_GetCurSel($g_hCmbAndroidBackgroundMode)
	UpdateAndroidBackgroundMode()
EndFunc   ;==>cmbAndroidBackgroundMode

; Custom sleep - Team AIO Mod++ (inspired in Samkie)
Func InputAndroidSleep()
	$g_iInputAndroidSleep = GUICtrlRead($g_hInputAndroidSleep)
EndFunc   ;==>InputAndroidSleep

Func EnableShowTouchs()
	AndroidAdbSendShellCommand("content insert --uri content://settings/system --bind name:s:show_touches --bind value:i:1")
	SetDebugLog("EnableShowTouchs ON")
EndFunc   ;==>EnableShowTouchs

Func DisableShowTouchs()
	AndroidAdbSendShellCommand("content insert --uri content://settings/system --bind name:s:show_touches --bind value:i:0")
	SetDebugLog("EnableShowTouchs OFF")
EndFunc   ;==>DisableShowTouchs

Func sldAdditionalClickDelay($bSetControls = False)
	If $bSetControls Then
		GUICtrlSetData($g_hSldAdditionalClickDelay, Int($g_iAndroidControlClickAdditionalDelay / 2))
		GUICtrlSetData($g_hLblAdditionalClickDelay, $g_iAndroidControlClickAdditionalDelay & " ms")
	Else
		Local $iValue = GUICtrlRead($g_hSldAdditionalClickDelay) * 2
		If $iValue <> $g_iAndroidControlClickAdditionalDelay Then
			$g_iAndroidControlClickAdditionalDelay = $iValue
			GUICtrlSetData($g_hLblAdditionalClickDelay, $g_iAndroidControlClickAdditionalDelay & " ms")
		EndIf
	EndIf
	Opt("MouseClickDelay", GetClickUpDelay()) ;Default: 10 milliseconds
	Opt("MouseClickDownDelay", GetClickDownDelay()) ;Default: 5 milliseconds
EndFunc   ;==>sldAdditionalClickDelay

Func DistributorsUpdateGUI()
	LoadCOCDistributorsComboBox()
	SetCurSelCmbCOCDistributors()
EndFunc   ;==>DistributorsUpdateGUI

#Region - Custom Instances - Team AIO Mod++
Func CmbAndroidEmulator()
	getAllEmulatorsInstances()
	Local $emulator = GUICtrlRead($g_hCmbAndroidEmulator)
	If MsgBox($MB_YESNO, "Emulator Selection", $emulator & ", Is correct?" & @CRLF & "Any mistake and your profile will be not useful!", 10) = $IDYES Then
		SetLog("Emulator " & $emulator & " Selected at first instance. Please reboot or select instance and reboot.", $COLOR_INFO)
		$g_sAndroidEmulator = $emulator
		$g_sAndroidInstance = GUICtrlRead($g_hCmbAndroidInstance)
		UpdateAndroidConfig($g_sAndroidInstance, $g_sAndroidEmulator)
		InitAndroidConfig(True)
		BtnSaveprofile()
	Else
		_GUICtrlComboBox_SelectString($g_hCmbAndroidEmulator, $g_sAndroidEmulator)
		getAllEmulatorsInstances()
	EndIf
EndFunc   ;==>CmbAndroidEmulator

Func cmbAndroidInstance()
    Local $Instance = GUICtrlRead($g_hCmbAndroidInstance)
    If MsgBox($MB_YESNO, "Instance Selection", $Instance & ", Is correct?" & @CRLF & "If 'yes' is necessary REBOOT the 'bot'.", 10) = $IDYES Then
        SetLog("Instance " & $Instance & " Selected.")
        $g_sAndroidInstance = $Instance
		UpdateAndroidConfig($g_sAndroidInstance, $g_sAndroidEmulator)
		InitAndroidConfig(True)
        BtnSaveprofile()
    Else
        getAllEmulatorsInstances()
    EndIf
EndFunc   ;==>cmbAndroidInstance

Func getAllEmulators()

	; Initial Var with all emulators , will populate the ComboBox UI
	Local $sEmulatorString = ""

	; Reset content , Emulator ComboBox var
	GUICtrlSetData($g_hCmbAndroidEmulator, '')

	; Bluestacks :
	$__BlueStacks_isHyperV = False
	$__BlueStacks_Version = RegRead($g_sHKLM & "\SOFTWARE\BlueStacks\", "Version")
	$__BlueStacks_Path = RegRead($g_sHKLM & "\SOFTWARE\BlueStacks\", "InstallDir")
	If @error <> 0 Then
		$__BlueStacks_isHyperV = True
		$__BlueStacks_Version = RegRead($g_sHKLM & "\SOFTWARE\BlueStacks_bgp64_hyperv\", "Version")
		$__BlueStacks_Path = RegRead($g_sHKLM & "\SOFTWARE\BlueStacks_bgp64_hyperv\", "InstallDir")
		If @error <> 0 Then
			$__BlueStacks_isHyperV = False
			$__BlueStacks_Path = @ProgramFilesDir & "\BlueStacks\"
			SetError(0, 0, 0)
		EndIf
	EndIf
	
	Local $sBluestacks = ""
	If StringIsSpace($__BlueStacks_Version) = 0 And $__BlueStacks_isHyperV = False Then
		$sBluestacks = "BlueStacks|"
		If GetVersionNormalized($__BlueStacks_Version) < GetVersionNormalized("0.10") Then $sBluestacks = "BlueStacks|"
		If GetVersionNormalized($__BlueStacks_Version) > GetVersionNormalized("1.0") Then $sBluestacks = "BlueStacks2|"
	ElseIf $__BlueStacks_isHyperV = True Then
		$sBluestacks = "BlueStacks2|"
	EndIf
	
	; Snorlax
    $__BlueStacks_Version = RegRead($g_sHKLM & "\SOFTWARE\BlueStacks_nxt\", "Version")
    If Not @error Then
        If GetVersionNormalized($__BlueStacks_Version) > GetVersionNormalized("5.0") Then $sEmulatorString &= "BlueStacks5|"
    EndIf
	
    $sEmulatorString &= $sBluestacks

	; Nox :
	Local $Version = RegRead($g_sHKLM & "\SOFTWARE" & $g_sWow6432Node & "\Microsoft\Windows\CurrentVersion\Uninstall\Nox\", "DisplayVersion")
	If Not @error Then
		$sEmulatorString &= "Nox|"
	EndIf

	; Memu :
	Local $MEmuVersion = RegRead($g_sHKLM & "\SOFTWARE" & $g_sWow6432Node & "\Microsoft\Windows\CurrentVersion\Uninstall\MEmu\", "DisplayVersion")
	If Not @error Then
		$sEmulatorString &= "MEmu|"
	EndIf
	
	Local $aEmulator[0]
	Local $sResult = StringRight($sEmulatorString, 1)
	; AIO
	If $sResult == "|" Then
		$sEmulatorString = StringTrimRight($sEmulatorString, 1)
		$aEmulator = StringSplit($sEmulatorString, "|", $STR_NOCOUNT)
	EndIf
	If $sEmulatorString <> "" Then
        Setlog("All Emulator found in your machine:", $COLOR_INFO)
        For $i = 0 To UBound($aEmulator) - 1
            SetLog("  - " & $aEmulator[$i], $COLOR_INFO)
        Next
	Else
		Setlog("No Emulator found in your machine")
		Return
	EndIf


	GUICtrlSetData($g_hCmbAndroidEmulator, $sEmulatorString)

	; $g_sAndroidEmulator Cosote Var to store the Emulator
	_GUICtrlComboBox_SelectString($g_hCmbAndroidEmulator, $g_sAndroidEmulator)

	; Lets get all Instances
	getAllEmulatorsInstances()
EndFunc   ;==>getAllEmulators

Func getAllEmulatorsInstances()

	; Reset content, Instance ComboBox var
	GUICtrlSetData($g_hCmbAndroidInstance, '')
	
	; Get all Instances from SELECTED EMULATOR - $g_hCmbAndroidEmulator is the Emulator ComboBox
	Local $emulator = GUICtrlRead($g_hCmbAndroidEmulator)
	Local $sEmulatorPath = ""
	
	Switch $emulator
		Case "BlueStacks"
			GUICtrlSetData($g_hCmbAndroidInstance, "Android", "Android")
			Return
		Case "BlueStacks2"
			GUICtrlSetData($g_hCmbAndroidInstance, "Android", "Android")
			Local $VMsBlueStacks = ""
			If $__BlueStacks_isHyperV = True Then
				$VMsBlueStacks = RegRead($g_sHKLM & "\SOFTWARE\BlueStacks_bgp64_hyperv\", "DataDir")
			Else
				$VMsBlueStacks = RegRead($g_sHKLM & "\SOFTWARE\BlueStacks\", "DataDir")
			EndIf
			$sEmulatorPath = $VMsBlueStacks ; C:\ProgramData\BlueStacks\Engine
       ; Snorlax
	   Case "BlueStacks5"
            Local $VMsBlueStacks = RegRead($g_sHKLM & "\SOFTWARE\BlueStacks_nxt\", "DataDir")
            $sEmulatorPath = $VMsBlueStacks ; C:\ProgramData\BlueStacks\Engine
		Case "Nox"
			$sEmulatorPath = GetNoxPath() & "\BignoxVMS"
		Case "MEmu"
			$sEmulatorPath = GetMEmuPath() & "\MemuHyperv VMs"
		Case Else
			GUICtrlSetData($g_hCmbAndroidInstance, "Android", "Android")
			Return
	EndSwitch

	; Just in case
	$sEmulatorPath = StringReplace($sEmulatorPath, "\\", "\")

	; BS Multi Instance
	Local $sBlueStacksFolder = ""
	If $Emulator = "BlueStacks2" Then
		$sBlueStacksFolder = "Android"
	EndIf
	
	 ; Snorlax
	If $Emulator = "BlueStacks5" Then
		$sBlueStacksFolder = "Nougat"
	EndIf
	
	; Getting all VM Folders
	Local $eError = 0
	Local $aEmulatorFolders = _FileListToArray($sEmulatorPath, $sBlueStacksFolder & "*", $FLTA_FOLDERS)
	
	$eError = @error
	If $eError = 1 Then
		SetLog($emulator & " -- Path was invalid. " & $sEmulatorPath)
		Return
	EndIf
	If $eError = 4 Then
		SetLog($emulator & " -- No file(s) were found. " & $sEmulatorPath)
		Return
	EndIf

	; Removing the [0] -> $aArray[0] = Number of Files\Folders returned
	_ArrayDelete($aEmulatorFolders, 0)

	; Populating the Instance ComboBox var
	GUICtrlSetData($g_hCmbAndroidInstance, _ArrayToString($aEmulatorFolders))
	
	If $emulator == $g_sAndroidEmulator Then
		_GUICtrlComboBox_SelectString($g_hCmbAndroidInstance, $g_sAndroidInstance)
	Else
		_GUICtrlComboBox_SetCurSel($g_hCmbAndroidInstance, 0)
	EndIf
EndFunc   ;==>getAllEmulatorsInstances
#EndRegion - Custom Instances - Team AIO Mod++
