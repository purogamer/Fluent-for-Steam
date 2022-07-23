; #FUNCTION# ====================================================================================================================
; Name ..........: OpenMEmu
; Description ...: Opens new MEmu instance
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Cosote (12-2015)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func OpenMEmu($bRestart = False)

	Local $PID, $hTimer, $iCount = 0, $process_killed, $cmdOutput, $connected_to, $cmdPar

	SetLog("Starting " & $g_sAndroidEmulator & " and Clash Of Clans", $COLOR_SUCCESS)

	Local $launchAndroid = (WinGetAndroidHandle() = 0 ? True : False)
	If $launchAndroid Then
		; Launch MEmu
		$cmdPar = GetAndroidProgramParameter()
		$PID = LaunchAndroid($g_sAndroidProgramPath, $cmdPar, $g_sAndroidPath)
		If $PID = 0 Then
			SetError(1, 1, -1)
			Return False
		EndIf
	EndIf

	$hTimer = __TimerInit()

	; Test ADB is connected
	$connected_to = ConnectAndroidAdb(False, 60 * 1000)
	If Not $g_bRunState Then Return False

	; Wait for device
	;$cmdOutput = LaunchConsole($g_sAndroidAdbPath, "-s " & $g_sAndroidAdbDevice & " wait-for-device", $process_killed, 60 * 1000)
	;If Not $g_bRunState Then Return

	; Wait for boot completed
	If WaitForAndroidBootCompleted($g_iAndroidLaunchWaitSec - __TimerDiff($hTimer) / 1000, $hTimer) Then Return False

	; Wait for UI Control, then CoC can be launched
	;While Not IsArray(ControlGetPos($g_sAndroidTitle, $g_sAppPaneName, $g_sAppClassInstance)) And __TimerDiff($hTimer) <= $g_iAndroidLaunchWaitSec * 1000
	;  If _Sleep(500) Then Return
	;WEnd

	If __TimerDiff($hTimer) >= $g_iAndroidLaunchWaitSec * 1000 Then ; if it took 4 minutes, Android/PC has major issue so exit
		SetLog("Serious error has occurred, please restart PC and try again", $COLOR_ERROR)
		SetLog($g_sAndroidEmulator & " refuses to load, waited " & Round(__TimerDiff($hTimer) / 1000, 2) & " seconds for window", $COLOR_ERROR)
		SetError(1, @extended, False)
		Return False
	EndIf

	SetLog($g_sAndroidEmulator & " Loaded, took " & Round(__TimerDiff($hTimer) / 1000, 2) & " seconds to begin.", $COLOR_SUCCESS)

	Return True

EndFunc   ;==>OpenMEmu

Func GetMEmuProgramParameter($bAlternative = False)
	If Not $bAlternative Or $g_sAndroidInstance <> $g_avAndroidAppConfig[$g_iAndroidConfig][1] Then
		; should be launched with these parameter
		Return ($g_sAndroidInstance = "" ? $g_avAndroidAppConfig[$g_iAndroidConfig][1] : $g_sAndroidInstance)
	EndIf
	; default instance gets launched when no parameter was specified (this is the alternative way)
	Return ""
EndFunc   ;==>GetMEmuProgramParameter

Func GetMEmuPath()
	Local $MEmu_Path = EnvGet("MEmu_Path") & "\MEmu\" ;RegRead($g_sHKLM & "\SOFTWARE\MEmu\", "InstallDir") ; Doesn't exist (yet)
	If FileExists($MEmu_Path & "MEmu.exe") = 0 Then ; work-a-round
		Local $InstallLocation = RegRead($g_sHKLM & "\SOFTWARE" & $g_sWow6432Node & "\Microsoft\Windows\CurrentVersion\Uninstall\MEmu\", "InstallLocation")
		If @error = 0 And FileExists($InstallLocation & "\MEmu\MEmu.exe") = 1 Then
			$MEmu_Path = $InstallLocation & "\MEmu\"
		Else
			Local $DisplayIcon = RegRead($g_sHKLM & "\SOFTWARE" & $g_sWow6432Node & "\Microsoft\Windows\CurrentVersion\Uninstall\MEmu\", "DisplayIcon")
			If @error = 0 Then
				Local $iLastBS = StringInStr($DisplayIcon, "\", 0, -1)
				$MEmu_Path = StringLeft($DisplayIcon, $iLastBS)
				If StringLeft($MEmu_Path, 1) = """" Then $MEmu_Path = StringMid($MEmu_Path, 2)
			Else
				$MEmu_Path = @ProgramFilesDir & "\Microvirt\MEmu\"
				SetError(0, 0, 0)
			EndIf
		EndIf
	EndIf
	$MEmu_Path = StringReplace($MEmu_Path, "\\", "\")
	Return $MEmu_Path
EndFunc   ;==>GetMEmuPath

Func GetMEmuAdbPath()
	Local $adbPath = GetMEmuPath() & "adb.exe"
	If FileExists($adbPath) Then
		Return $adbPath
	Else
		; Custom fix - Team AIO Mod++
		Local $aFileList = _FileListToArray(GetMEmuPath(), "*adb.exe", $FLTA_FILESFOLDERS)
		Local $sMove = (UBound($aFileList) > 0 And not @error) ? ($aFileList[1]) : (@ScriptDir & "\lib\adb\adb.exe")
		If FileCopy($sMove, $adbPath, $FC_OVERWRITE + $FC_CREATEPATH) Then
			SetLog("Fixed ADB !!!", $COLOR_DEBUG)
			Return $adbPath
		EndIf
	EndIf
	Return ""
EndFunc   ;==>GetMEmuAdbPath

Func GetMEmuBackgroundMode()

	Local $iDirectX = $g_iAndroidBackgroundModeDirectX
	Local $iOpenGL = $g_iAndroidBackgroundModeOpenGL
	; hack for super strange Windows Fall Creator Update with OpenGL and DirectX problems
	; doesn't have this issue with OSBuild : 17134
	If _OSBuild() >= 16299 And _OSBuild() < 17134 Then
		SetDebugLog("DirectX/OpenGL Fix applied for Windows Build 16299")
		$iDirectX = $g_iAndroidBackgroundModeOpenGL
		$iOpenGL = $g_iAndroidBackgroundModeDirectX
	EndIf
	; Only OpenGL is supported up to version 3.1.2.5

	; get OpenGL/DirectX config
	Local $aRegExResult = StringRegExp($__VBoxGuestProperties, "Name: graphics_render_mode, value: (.+), timestamp:", $STR_REGEXPARRAYMATCH)
	If @error = 0 Then
		Local $graphics_render_mode = $aRegExResult[0]
		SetDebugLog($g_sAndroidEmulator & " instance " & $g_sAndroidInstance & " rendering mode is " & $graphics_render_mode)
		Switch $graphics_render_mode
			Case "1" ; DirectX
				Return $iDirectX
			Case "2" ; DirectX+ available in version 3.6.7.0
				Return $iDirectX
			Case Else ; fallback to OpenGL
				Return $iOpenGL
		EndSwitch
	EndIf

	; fallback to OpenGL
	Return $iOpenGL
EndFunc   ;==>GetMEmuBackgroundMode

Func InitMEmu($bCheckOnly = False)
	Local $process_killed, $aRegExResult, $g_sAndroidAdbDeviceHost, $g_sAndroidAdbDevicePort, $oops = 0
	Local $MEmuVersion = RegRead($g_sHKLM & "\SOFTWARE" & $g_sWow6432Node & "\Microsoft\Windows\CurrentVersion\Uninstall\MEmu\", "DisplayVersion")
	SetError(0, 0, 0)
	; Could also read MEmu paths from environment variables MEmu_Path and MEmuHyperv_Path
	Local $MEmu_Path = GetMEmuPath()
	Local $MEmu_Manage_Path = EnvGet("MEmuHyperv_Path") & "\MEmuManage.exe"
	If FileExists($MEmu_Manage_Path) = 0 Then
		$MEmu_Manage_Path = $MEmu_Path & "..\MEmuHyperv\MEmuManage.exe"
	EndIf

	If FileExists($MEmu_Path & "MEmu.exe") = 0 Then
		If Not $bCheckOnly Then
			SetLog("Serious error has occurred: Cannot find " & $g_sAndroidEmulator & ":", $COLOR_ERROR)
			SetLog($MEmu_Path & "MEmu.exe", $COLOR_ERROR)
			SetError(1, @extended, False)
		EndIf
		Return False
	EndIf

	Local $sPreferredADB = FindPreferredAdbPath()
	If $sPreferredADB = "" And FileExists($MEmu_Path & "adb.exe") = 0 Then
		If Not $bCheckOnly Then
			SetLog("Serious error has occurred: Cannot find " & $g_sAndroidEmulator & ":", $COLOR_ERROR)
			SetLog($MEmu_Path & "adb.exe", $COLOR_ERROR)
			SetError(1, @extended, False)
		EndIf
		Return False
	EndIf

	If FileExists($MEmu_Manage_Path) = 0 Then
		If Not $bCheckOnly Then
			SetLog("Serious error has occurred: Cannot find MEmu-Hyperv:", $COLOR_ERROR)
			SetLog($MEmu_Manage_Path, $COLOR_ERROR)
			SetError(1, @extended, False)
		EndIf
		Return False
	EndIf

	; Read ADB host and Port
	If Not $bCheckOnly Then
		; Custom fix - Team AIO Mod++
		local $iMemuCurr = GetVersionNormalized($MEmuVersion)
		Local $iMemu6 = GetVersionNormalized("6.0")
		Local $iMemu7 = GetVersionNormalized("7.0")
		If $iMemuCurr >= $iMemu6 And $iMemuCurr < $iMemu7 Then
			$g_bAndroidAdbClickEnabled = True
			GUICtrlSetState($g_hChkAndroidAdbClick, $GUI_ENABLE)
		EndIf

		InitAndroidConfig(True) ; Restore default config
		If Not GetAndroidVMinfo($__VBoxVMinfo, $MEmu_Manage_Path) Then Return False

		; update global variables
		$g_sAndroidProgramPath = $MEmu_Path & "MEmu.exe"
		$g_sAndroidAdbPath = $sPreferredADB
		If $g_sAndroidAdbPath = "" Then $g_sAndroidAdbPath = $MEmu_Path & "adb.exe"
		$g_sAndroidVersion = $MEmuVersion
		$__MEmu_Path = $MEmu_Path
		$g_sAndroidPath = $__MEmu_Path
		$__VBoxManage_Path = $MEmu_Manage_Path
		$aRegExResult = StringRegExp($__VBoxVMinfo, "name = ADB.*host ip = ([^,]+),", $STR_REGEXPARRAYMATCH)
		If Not @error Then
			$g_sAndroidAdbDeviceHost = $aRegExResult[0]
			If $g_bDebugAndroid Then SetDebugLog("Func LaunchConsole: Read $g_sAndroidAdbDeviceHost = " & $g_sAndroidAdbDeviceHost, $COLOR_DEBUG)
		Else
			$oops = 1
			SetLog("Cannot read " & $g_sAndroidEmulator & "(" & $g_sAndroidInstance & ") ADB Device Host", $COLOR_ERROR)
		EndIf

		$aRegExResult = StringRegExp($__VBoxVMinfo, "name = ADB.*host port = (\d{3,5}),", $STR_REGEXPARRAYMATCH)
		If Not @error Then
			$g_sAndroidAdbDevicePort = $aRegExResult[0]
			If $g_bDebugAndroid Then SetDebugLog("Func LaunchConsole: Read $g_sAndroidAdbDevicePort = " & $g_sAndroidAdbDevicePort, $COLOR_DEBUG)
		Else
			$oops = 1
			SetLog("Cannot read " & $g_sAndroidEmulator & "(" & $g_sAndroidInstance & ") ADB Device Port", $COLOR_ERROR)
		EndIf

		If $oops = 0 Then
			$g_sAndroidAdbDevice = $g_sAndroidAdbDeviceHost & ":" & $g_sAndroidAdbDevicePort
		Else ; use defaults
			SetLog("Using ADB default device " & $g_sAndroidAdbDevice & " for " & $g_sAndroidEmulator, $COLOR_ERROR)
		EndIf

		; get screencap paths: Name: 'picture', Host path: 'C:\Users\Administrator\Pictures\MEmu Photo' (machine mapping), writable
		$g_sAndroidPicturesPath = "/mnt/shell/emulated/0/Pictures/"
		$g_sAndroidSharedFolderName = "picture"
		ConfigureSharedFolder(0) ; something like C:\Users\Administrator\Pictures\MEmu Photo\

		$__VBoxGuestProperties = LaunchConsole($__VBoxManage_Path, "guestproperty enumerate " & $g_sAndroidInstance, $process_killed)

		; Update Android Screen and Window
		UpdateMEmuConfig()

	EndIf

	Return SetError($oops, 0, True)

EndFunc   ;==>InitMEmu

Func SetScreenMEmu()

	If Not InitAndroid() Then Return False

	Local $cmdOutput, $process_killed

	; Set width and height
	$cmdOutput = LaunchConsole($__VBoxManage_Path, "guestproperty set " & $g_sAndroidInstance & " resolution_width " & $g_iAndroidClientWidth, $process_killed)
	$cmdOutput = LaunchConsole($__VBoxManage_Path, "guestproperty set " & $g_sAndroidInstance & " resolution_height " & $g_iAndroidClientHeight, $process_killed)
	$cmdOutput = LaunchConsole($__VBoxManage_Path, "guestproperty set " & $g_sAndroidInstance & " is_full_screen 0", $process_killed)
	$cmdOutput = LaunchConsole($__VBoxManage_Path, "guestproperty set " & $g_sAndroidInstance & " is_customed_resolution 1", $process_killed)
	; Set dpi
	$cmdOutput = LaunchConsole($__VBoxManage_Path, "guestproperty set " & $g_sAndroidInstance & " vbox_dpi 160", $process_killed)

	ConfigureSharedFolder(1, True)
	ConfigureSharedFolder(2, True)

	Return True

EndFunc   ;==>SetScreenMEmu

Func RebootMEmuSetScreen()

	Return RebootAndroidSetScreenDefault()

EndFunc   ;==>RebootMEmuSetScreen

Func CloseMEmu()

	Return CloseVboxAndroidSvc()

EndFunc   ;==>CloseMEmu

Func CheckScreenMEmu($bSetLog = True)

	If Not InitAndroid() Then Return False

	Local $aValues[4][2] = [ _
			["is_full_screen", "0"], _
			["vbox_dpi", "160"], _
			["resolution_height", $g_iAndroidClientHeight], _
			["resolution_width", $g_iAndroidClientWidth] _
			]
	Local $i, $Value, $iErrCnt = 0, $process_killed, $aRegExResult

	For $i = 0 To UBound($aValues) - 1
		$aRegExResult = StringRegExp($__VBoxGuestProperties, "Name: " & $aValues[$i][0] & ", value: (.+), timestamp:", $STR_REGEXPARRAYMATCH)
		If @error = 0 Then $Value = $aRegExResult[0]
		If $Value <> $aValues[$i][1] Then
			If $iErrCnt = 0 Then
				If $bSetLog Then
					SetLog("MyBot doesn't work with " & $g_sAndroidEmulator & " screen configuration!", $COLOR_ERROR)
				Else
					SetDebugLog("MyBot doesn't work with " & $g_sAndroidEmulator & " screen configuration!", $COLOR_ERROR)
				EndIf
			EndIf
			If $bSetLog Then
				SetLog("Setting of " & $aValues[$i][0] & " is " & $Value & " and will be changed to " & $aValues[$i][1], $COLOR_ERROR)
			Else
				SetDebugLog("Setting of " & $aValues[$i][0] & " is " & $Value & " and will be changed to " & $aValues[$i][1], $COLOR_ERROR)
			EndIf
			$iErrCnt += 1
		EndIf
	Next

	; check if shared folder exists
	If ConfigureSharedFolder(1, $bSetLog) Then $iErrCnt += 1

	If $iErrCnt > 0 Then Return False
	Return True

EndFunc   ;==>CheckScreenMEmu

Func UpdateMEmuConfig()

	Local $aRegExResult
	Local $iSizeConfig = FindMEmuWindowConfig()

	;MEmu "phone_layout" value="2" -> no system bar
	;MEmu "phone_layout" value="1" -> right system bar
	;MEmu "phone_layout" value="0" -> bottom system bar
	$aRegExResult = StringRegExp($__VBoxGuestProperties, "Name: phone_layout, value: (.+), timestamp:", $STR_REGEXPARRAYMATCH)

	If @error = 0 Then
		$__MEmu_PhoneLayout = $aRegExResult[0]
		If $iSizeConfig > -1 And $__MEmu_Window[$iSizeConfig][4] = "-1" Then
			SetDebugLog($g_sAndroidEmulator & " phone_layout is " & $__MEmu_PhoneLayout & ", but set to -1 to disable screen compensation")
			$__MEmu_PhoneLayout = $__MEmu_Window[$iSizeConfig][4]
		Else
			SetDebugLog($g_sAndroidEmulator & " phone_layout is " & $__MEmu_PhoneLayout)
		EndIf
	Else
		SetDebugLog("Cannot read " & $g_sAndroidEmulator & " guestproperty phone_layout!", $COLOR_ERROR)
		If $iSizeConfig > -1 Then
			$__MEmu_PhoneLayout = $__MEmu_Window[$iSizeConfig][4]
			SetDebugLog("Using phone_layout " & $__MEmu_PhoneLayout)
		EndIf
	EndIf
	SetError(0, 0, 0)

	Return UpdateMEmuWindowState()
EndFunc   ;==>UpdateMEmuConfig

Func FindMEmuWindowConfig()
	Local $v = GetVersionNormalized($g_sAndroidVersion)
	For $i = 0 To UBound($__MEmu_Window) - 1
		Local $v2 = GetVersionNormalized($__MEmu_Window[$i][0])
		If $v >= $v2 Then
			SetDebugLog("Using Window sizes of " & $g_sAndroidEmulator & " " & $__MEmu_Window[$i][0])
			Return $i
		EndIf
	Next
	SetDebugLog("Cannot find Window sizes of " & $g_sAndroidEmulator & " " & $g_sAndroidVersion)
	Return -1
EndFunc   ;==>FindMEmuWindowConfig

Func UpdateMEmuWindowState()
	; check if MEmu is open and Tool Bar is closed
	;$g_hAndroidWindow = WinGetHandle($g_sAndroidTitle)
	WinGetAndroidHandle()
	ControlGetPos($g_hAndroidWindow, $g_sAppPaneName, $g_sAppClassInstance)
	If @error = 1 Then
		; Window not found, nothing to do
		SetError(0, 0, 0)
		;Return False
	EndIf

	Local $acw = $g_avAndroidAppConfig[$g_iAndroidConfig][5]
	Local $ach = $g_avAndroidAppConfig[$g_iAndroidConfig][6]
	Local $aww = $g_avAndroidAppConfig[$g_iAndroidConfig][7]
	Local $awh = $g_avAndroidAppConfig[$g_iAndroidConfig][8]
	Local $tbw = $__MEmu_ToolBar_Width

	Local $iSizeConfig = FindMEmuWindowConfig()
	If $iSizeConfig > -1 Then
		$aww = $__MEmu_Window[$iSizeConfig][1]
		$awh = $__MEmu_Window[$iSizeConfig][2]
		$tbw = $__MEmu_Window[$iSizeConfig][3]
	EndIf

	Local $bToolBarVisible = True
	Local $i
	Local $Values[4][3] = [ _
			["Screen Width", $g_iAndroidClientWidth, $g_iAndroidClientWidth], _
			["Screen Height", $g_iAndroidClientHeight, $g_iAndroidClientHeight], _
			["Window Width", $g_iAndroidWindowWidth, $g_iAndroidWindowWidth], _
			["Window Height", $g_iAndroidWindowHeight, $g_iAndroidWindowHeight] _
			]
	Local $bChanged = False, $ok = False
	Local $toolBarPos = ControlGetPos($g_hAndroidWindow, "", "Qt5QWindowIcon3")
	If UBound($toolBarPos) = 4 Then
		Local $tbw_using = $tbw
		If $toolBarPos[2] > 20 And $toolBarPos[2] < 60 Then $tbw_using = $toolBarPos[2]
		SetDebugLog($g_sAndroidEmulator & " Tool Bar found, width = " & $toolBarPos[2] & ", height = " & $toolBarPos[3] & ", expected width = " & $tbw & ", using width = " & $tbw_using)
		$tbw = $tbw_using
		;ConsoleWrite("Qt5QWindowIcon3=" & $toolBarPos[0] & "," & $toolBarPos[1] & "," & $toolBarPos[2] & "," & $toolBarPos[3] & ($isVisible = 1 ? " visible" : " hidden")) ; 863,33,45,732
		;If $toolBarPos[2] = $tbw Then
		$bToolBarVisible = ControlCommand($g_hAndroidWindow, "", "Qt5QWindowIcon3", "IsVisible", "") = 1
		SetDebugLog($g_sAndroidEmulator & " Tool Bar is " & ($bToolBarVisible ? "visible" : "hidden"))
		$ok = True
		;EndIf
	EndIf
	If Not $ok Then
		SetDebugLog($g_sAndroidEmulator & " Tool Bar state is undetermined as treated as " & ($bToolBarVisible ? "visible" : "hidden"), $COLOR_ERROR)
	EndIf

	Local $w = ($bToolBarVisible ? 0 : $tbw)

	Switch $__MEmu_PhoneLayout
		Case "0" ; Bottom position (default)
			$Values[0][2] = $acw
			$Values[1][2] = $ach + $__MEmu_SystemBar
			$Values[2][2] = $aww - $w
			$Values[3][2] = $awh + $__MEmu_SystemBar
		Case "1" ; Right position
			$Values[0][2] = $acw + $__MEmu_SystemBar
			$Values[1][2] = $ach
			$Values[2][2] = $aww + $__MEmu_SystemBar - $w
			$Values[3][2] = $awh
		Case "2", "-1" ; Hidden or no PhoneLayout compensation
			$Values[0][2] = $acw
			$Values[1][2] = $ach
			$Values[2][2] = $aww - $w
			$Values[3][2] = $awh
		Case Else ; Unexpected Value
			SetDebugLog("Unsupported " & $g_sAndroidEmulator & " guestproperty phone_layout = " & $__MEmu_PhoneLayout, $COLOR_ERROR)
	EndSwitch

	$g_iAndroidClientWidth = $Values[0][2]
	$g_iAndroidClientHeight = $Values[1][2]
	$g_iAndroidWindowWidth = $Values[2][2]
	$g_iAndroidWindowHeight = $Values[3][2]

	For $i = 0 To UBound($Values) - 1
		If $Values[$i][1] <> $Values[$i][2] Then
			$bChanged = True
			SetDebugLog($g_sAndroidEmulator & " " & $Values[$i][0] & " updated from " & $Values[$i][1] & " to " & $Values[$i][2])
		EndIf
	Next

	Return $bChanged
EndFunc   ;==>UpdateMEmuWindowState
