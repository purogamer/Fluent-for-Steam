; #FUNCTION# ====================================================================================================================
; Name ..........: AndroidNox
; Description ...: Nox Android functions
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Cosote (02-2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func OpenNox($bRestart = False)

	Local $PID, $hTimer, $iCount = 0, $process_killed, $cmdOutput, $connected_to, $cmdPar

	SetLog("Starting " & $g_sAndroidEmulator & " and Clash Of Clans", $COLOR_SUCCESS)

	Local $launchAndroid = (WinGetAndroidHandle() = 0 ? True : False)
	If $launchAndroid Then
		; Launch Nox
		$cmdPar = GetAndroidProgramParameter()
		$PID = LaunchAndroid($g_sAndroidProgramPath, $cmdPar, $g_sAndroidPath)
		If $PID = 0 Then
			SetError(1, 1, -1)
			Return False
		EndIf
	EndIf

	$hTimer = __TimerInit()

	; Nox can have issues detecting if VM is running, so now disabled
	;If WaitForRunningVMS($g_iAndroidLaunchWaitSec - __TimerDiff($hTimer) / 1000, $hTimer) Then Return False

	; update ADB port, as that can changes when Nox just started... disable since v7.7.5 because newer Nox 6.2.x has LockMachine errors
	$g_bInitAndroid = True
	InitAndroid()

	; Test ADB is connected
	$connected_to = ConnectAndroidAdb(False, 60 * 1000)
	If Not $g_bRunState Then Return False

	; Wait for boot completed
	If WaitForAndroidBootCompleted($g_iAndroidLaunchWaitSec - __TimerDiff($hTimer) / 1000, $hTimer) Then Return False

	If __TimerDiff($hTimer) >= $g_iAndroidLaunchWaitSec * 1000 Then ; if it took 4 minutes, Android/PC has major issue so exit
		SetLog("Serious error has occurred, please restart PC and try again", $COLOR_ERROR)
		SetLog($g_sAndroidEmulator & " refuses to load, waited " & Round(__TimerDiff($hTimer) / 1000, 2) & " seconds for window", $COLOR_ERROR)
		SetError(1, @extended, False)
		Return False
	EndIf

	SetLog($g_sAndroidEmulator & " Loaded, took " & Round(__TimerDiff($hTimer) / 1000, 2) & " seconds to begin.", $COLOR_SUCCESS)

	If WinGetAndroidHandle() Then
		; avoid another InitAndroid call, because it just got initialized and on newer Nox 6.2.x calls to vboxmanage have LockMachine problems when instance is running
		$g_bInitAndroid = False
	EndIf

	Return True

EndFunc   ;==>OpenNox

Func IsNoxCommandLine($CommandLine)
	; find instance in command line
	Local $aRegexResult = StringRegExp($CommandLine, "-clone:(\b.+\b)", $STR_REGEXPARRAYMATCH)
	If Not @error Then
		Local $sInstance = $aRegexResult[0]
		If $sInstance = $g_sAndroidInstance Or ($g_sAndroidInstance = $g_avAndroidAppConfig[$g_iAndroidConfig][1] And $sInstance = 'Nox_0') Then ; 'Nox_0' is MultiPlayerManager.exe launch support
			SetDebugLog("IsNoxCommandLine, instance " & $g_sAndroidInstance & ", returns True for: " & $CommandLine)
			Return True
		EndIf
	Else
		If $g_sAndroidInstance = $g_avAndroidAppConfig[$g_iAndroidConfig][1] Then
			SetDebugLog("IsNoxCommandLine, instance " & $g_sAndroidInstance & ", returns True for: " & $CommandLine)
			Return True
		EndIf
	EndIf
	SetDebugLog("IsNoxCommandLine, instance " & $g_sAndroidInstance & ", returns False for: " & $CommandLine)
	Return False
EndFunc   ;==>IsNoxCommandLine

Func GetNoxProgramParameter($bAlternative = False)
	; see http://en.bignox.com/blog/?p=354
	Local $customScreen = "-root:true -resolution:" & $g_iAndroidClientWidth & "x" & $g_iAndroidClientHeight & " -dpi:160" ; Custom fix - Team AIO Mod++
	Local $clone = """-clone:" & ($g_sAndroidInstance = "" ? $g_avAndroidAppConfig[$g_iAndroidConfig][1] : $g_sAndroidInstance) & """"
	If $bAlternative = False Then
		; should be launched with these parameter
		Return $customScreen & " " & $clone
	EndIf
	If $g_sAndroidInstance = "" Or $g_sAndroidInstance = $g_avAndroidAppConfig[$g_iAndroidConfig][1] Then Return ""
	; default instance gets launched when no parameter was specified (this is the alternative way)
	Return $clone
EndFunc   ;==>GetNoxProgramParameter

Func GetNoxRtPath()
	Local $path = EnvGet("ProgramFiles(x86)") & "\Bignox\BigNoxVM\RT\"
	If FileExists($path) = 0 Then
		$path = @ProgramFilesDir & "\Bignox\BigNoxVM\RT\"
	EndIf
	If FileExists($path) = 0 Then
		$path = EnvGet("ProgramFiles") & "\Bignox\BigNoxVM\RT\"
	EndIf
	If FileExists($path) = 0 Then
		$path = RegRead($g_sHKLM & "\SOFTWARE\BigNox\VirtualBox\", "InstallDir")
		If @error = 0 Then
			If StringRight($path, 1) <> "\" Then $path &= "\"
		EndIf
	EndIf
	SetError(0, 0, 0)
	Return StringReplace($path, "\\", "\")
EndFunc   ;==>GetNoxRtPath

Func GetNoxPath()
	Local $path = RegRead($g_sHKLM & "\SOFTWARE" & $g_sWow6432Node & "\DuoDianOnline\SetupInfo\", "InstallPath")
	If @error = 0 Then
		If StringRight($path, 1) <> "\" Then $path &= "\"
		$path &= "bin\"
	Else
		$path = ""
		SetError(0, 0, 0)
	EndIf
	Return StringReplace($path, "\\", "\")
EndFunc   ;==>GetNoxPath

Func GetNoxAdbPath()
	Local $adbPath = GetNoxPath() & "nox_adb.exe"
	If FileExists($adbPath) Then
		Return $adbPath
	Else
		; Custom fix - Team AIO Mod++
		Local $aFileList = _FileListToArray(GetNoxPath(), "*adb.exe", $FLTA_FILESFOLDERS)
		Local $sMove = (UBound($aFileList) > 0 And not @error) ? ($aFileList[1]) : (@ScriptDir & "\lib\adb\adb.exe")
		If FileCopy($sMove, $adbPath, $FC_OVERWRITE + $FC_CREATEPATH) Then
			SetLog("Fixed ADB !!!", $COLOR_DEBUG)
			Return $adbPath
		EndIf
	EndIf
	Return ""
EndFunc   ;==>GetNoxAdbPath

Func GetNoxBackgroundMode()

	Local $iDirectX = $g_iAndroidBackgroundModeDirectX
	Local $iOpenGL = $g_iAndroidBackgroundModeOpenGL
	; hack for super strange Windows Fall Creator Update with OpenGL and DirectX problems
	; doesn't have this issue with OSBuild : 17134
	If _OSBuild() >= 16299 And _OSBuild() < 17134 Then
		SetDebugLog("DirectX/OpenGL Fix applied for Windows Build 16299")
		$iDirectX = $g_iAndroidBackgroundModeOpenGL
		$iOpenGL = $g_iAndroidBackgroundModeDirectX
	EndIf
	; get OpenGL/DirectX config
	Local $sConfig = GetNoxConfigFile()
	If $sConfig Then
		Local $graphic_engine_type = IniRead($sConfig, "setting", "graphic_engine_type", "") ; 0 = OpenGL, 1 = DirectX
		Switch $graphic_engine_type
			Case "0", ""
				Return $iOpenGL
			Case "1"
				Return $iDirectX
			Case Else
				SetLog($g_sAndroidEmulator & " unsupported Graphics Engine Type " & $graphic_engine_type, $COLOR_WARNING)
		EndSwitch
	EndIf
	Return 0
EndFunc   ;==>GetNoxBackgroundMode

Func InitNox($bCheckOnly = False)
	Local $process_killed, $aRegexResult, $g_sAndroidAdbDeviceHost, $g_sAndroidAdbDevicePort, $oops = 0
	Local $Version = RegRead($g_sHKLM & "\SOFTWARE" & $g_sWow6432Node & "\Microsoft\Windows\CurrentVersion\Uninstall\Nox\", "DisplayVersion")
	SetError(0, 0, 0)

	Local $path = GetNoxPath()
	Local $RtPath = GetNoxRtPath()

	Local $NoxFile = $path & "Nox.exe"
	Local $AdbFile = $path & "nox_adb.exe"
	Local $VBoxFile = $RtPath & "BigNoxVMMgr.exe"

	Local $Files = [$NoxFile, $AdbFile, $VBoxFile]

	#cs
	If Not $bCheckOnly And $g_bAndroidAdbReplaceEmulatorVersion And GetVersionNormalized($Version) >= GetVersionNormalized("6.2.0") Then
		; replace adb with dummy
		$g_bAndroidAdbReplaceEmulatorVersionWithDummy = True
	EndIf
	#ce
	
	Local $sPreferredADB = FindPreferredAdbPath()
	If $sPreferredADB Then _ArrayDelete($Files, 1)

	For $File In $Files
		If FileExists($File) = False Then
			If Not $bCheckOnly Then
				SetLog("Serious error has occurred: Cannot find " & $g_sAndroidEmulator & " file:", $COLOR_ERROR)
				SetLog($File, $COLOR_ERROR)
				SetError(1, @extended, False)
			EndIf
			Return False
		EndIf
	Next

	; Read ADB host and Port
	If Not $bCheckOnly Then
		InitAndroidConfig(True) ; Restore default config

		If Not GetAndroidVMinfo($__VBoxVMinfo, $VBoxFile) Then Return False
		; update global variables
		$g_sAndroidProgramPath = $NoxFile
		$g_sAndroidAdbPath = $sPreferredADB
		If $g_sAndroidAdbPath = "" Then $g_sAndroidAdbPath = GetNoxAdbPath()
		$g_sAndroidVersion = $Version
		$__Nox_Path = $path
		$g_sAndroidPath = $__Nox_Path
		$__VBoxManage_Path = $VBoxFile
		$aRegexResult = StringRegExp($__VBoxVMinfo, ".*host ip = ([^,]+), .* guest port = 5555", $STR_REGEXPARRAYMATCH)
		If Not @error Then
			$g_sAndroidAdbDeviceHost = $aRegexResult[0]
			If $g_bDebugAndroid Then SetDebugLog("Func LaunchConsole: Read $g_sAndroidAdbDeviceHost = " & $g_sAndroidAdbDeviceHost, $COLOR_DEBUG)
		Else
			$oops = 1
			SetLog("Cannot read " & $g_sAndroidEmulator & "(" & $g_sAndroidInstance & ") ADB Device Host", $COLOR_ERROR)
		EndIf

		$aRegexResult = StringRegExp($__VBoxVMinfo, "name = .*host port = (\d{3,5}), .* guest port = 5555", $STR_REGEXPARRAYMATCH)
		If Not @error Then
			$g_sAndroidAdbDevicePort = $aRegexResult[0]
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


		Local $v = GetVersionNormalized($g_sAndroidVersion)
		For $i = 0 To UBound($__Nox_Config) - 1
			Local $v2 = GetVersionNormalized($__Nox_Config[$i][0])
			If $v >= $v2 Then
				SetDebugLog("Using Android Config of " & $g_sAndroidEmulator & " " & $__Nox_Config[$i][0])
				$g_sAppClassInstance = $__Nox_Config[$i][1]
				$g_bAndroidControlUseParentPos = $__Nox_Config[$i][2]
				$g_avAndroidAppConfig[$g_iAndroidConfig][3] = $g_sAppClassInstance
				ExitLoop
			EndIf
		Next
		#cs
			If $v >= GetVersionNormalized("5.0.0.0") Then
			$g_aiMouseOffset[0] = 6
			$g_aiMouseOffset[1] = 7
			SetDebugLog("Update Android Mouse Offset to " & $g_aiMouseOffset[0] & ", " & $g_aiMouseOffset[1])
			EndIf
		#ce

		; Update shared folder state
		$g_sAndroidSharedFolderName = "Other"
		ConfigureSharedFolderNox(0) ; something like C:\Users\Administrator\Documents\Nox_share\Other\

		UpdateHWnD($g_hAndroidWindow, False) ; Ensure $g_sAppClassInstance is properly set

		; Update Android Screen and Window
		;UpdateNoxConfig()
	EndIf

	Return True

EndFunc   ;==>InitNox

Func GetNoxConfigFile()
	Local $sLocalAppData = EnvGet("LOCALAPPDATA")
	Local $sPre = ""
	If $g_sAndroidInstance <> "nox" Then $sPre = "clone_" & $g_sAndroidInstance & "_"
	Local $sConfig = $sLocalAppData & "\Nox\" & $sPre & "conf.ini"
	If FileExists($sConfig) Then Return $sConfig
	Return ""
EndFunc   ;==>GetNoxConfigFile

Func ConfigureSharedFolderNox($iMode = 0, $bSetLog = Default)
	If $bSetLog = Default Then $bSetLog = True
	Local $bResult = False

	Switch $iMode
		Case 0 ; check that shared folder is configured in VM
			;$g_sAndroidPicturesPath = "/mnt/shell/emulated/0/Download/other/"
			;$g_sAndroidPicturesPath = "/mnt/shared/Other/"
			$g_sAndroidPicturesPath = "(/mnt/shared/Other|/mnt/shell/emulated/0/Download/other|/mnt/shell/emulated/0/Others)"
			Local $aRegexResult = StringRegExp($__VBoxVMinfo, "Name: '" & $g_sAndroidSharedFolderName & "', Host path: '(.*)'.*", $STR_REGEXPARRAYGLOBALMATCH)
			If Not @error Then
				$bResult = True
				$g_bAndroidSharedFolderAvailable = True
				$g_sAndroidPicturesHostPath = $aRegexResult[UBound($aRegexResult) - 1] & "\"
			Else
				; Check the shared folder 'Nox_share' , this is the default path on last version
				If FileExists(@HomeDrive & @HomePath & "\Nox_share\OtherShare\") Then
					; > Nox v6
					$g_bAndroidSharedFolderAvailable = True
					$g_sAndroidPicturesHostPath = @HomeDrive & @HomePath & "\Nox_share\OtherShare\"
				ElseIf FileExists(@MyDocumentsDir & "\Nox_share\Other\") Then
					; > Nox v5.2.1.0
					$g_bAndroidSharedFolderAvailable = True
					$g_sAndroidPicturesHostPath = @MyDocumentsDir & "\Nox_share\Other\"
				ElseIf FileExists(@HomeDrive & @HomePath & "\Nox_share\") Then
					; > Nox v5.2.0.0
					$g_bAndroidSharedFolderAvailable = True
					$g_sAndroidPicturesHostPath = @HomeDrive & @HomePath & "\Nox_share\"
				Else
					$g_bAndroidSharedFolderAvailable = False
					$g_bAndroidAdbScreencap = False
					$g_sAndroidPicturesHostPath = ""
					SetLog($g_sAndroidEmulator & " Background Mode is not available", $COLOR_ERROR)
				EndIf
			EndIf

		Case 1 ; create missing shared folder
			$bResult = AndroidPicturePathAutoConfig(@MyDocumentsDir, "\Nox_share\Other", $bSetLog)

		Case Else
			; use default impl.
			Return SetError(1, 0, "")
	EndSwitch

	Return SetError(0, 0, $bResult)
EndFunc

Func SetScreenNox()

	If Not InitAndroid() Then Return False

	Local $cmdOutput, $process_killed

	; These setting don't stick, so not used and instead using paramter: http://en.bignox.com/blog/?p=354
	; Set width and height
	;$cmdOutput = LaunchConsole($__VBoxManage_Path, "guestproperty set " & $g_sAndroidInstance & " vbox_graph_mode " & $g_iAndroidClientWidth & "x" & $g_iAndroidClientHeight & "-16", $process_killed)
	; Set dpi
	;$cmdOutput = LaunchConsole($__VBoxManage_Path, "guestproperty set " & $g_sAndroidInstance & " vbox_dpi 160", $process_killed)

	ConfigureSharedFolder(1, True)
	ConfigureSharedFolder(2, True)

	; find Nox conf.ini in C:\Users\User\AppData\Local\Nox and set "Fix window size" to Enable, "Remember size and position" to Disable and screen res also
	Local $sConfig = GetNoxConfigFile()
	If $sConfig Then
		SetDebugLog("Configure Nox screen config: " & $sConfig)
		IniWrite($sConfig, "setting", "h_resolution", $g_iAndroidClientWidth & "x" & $g_iAndroidClientHeight)
		IniWrite($sConfig, "setting", "h_dpi", "160")
		IniWrite($sConfig, "setting", "fixsize", "true")
		IniWrite($sConfig, "setting", "is_save_pos_and_size", "false")
		IniWrite($sConfig, "setting", "last_player_width", "864")
		IniWrite($sConfig, "setting", "last_player_height", "770")
	Else
		SetDebugLog("Cannot find Nox config to cnfigure screen: " & $sConfig, $COLOR_ERROR)
	EndIf

	Return True

EndFunc   ;==>SetScreenNox

Func RebootNoxSetScreen()

	Return RebootAndroidSetScreenDefault()

EndFunc   ;==>RebootNoxSetScreen

Func CloseNox()

	Return CloseVboxAndroidSvc()

EndFunc   ;==>CloseNox

Func CheckScreenNox($bSetLog = True)

	If Not InitAndroid() Then Return False

	Local $aValues[2][2] = [ _
			["vbox_dpi", "160"], _
			["vbox_graph_mode", $g_iAndroidClientWidth & "x" & $g_iAndroidClientHeight & "-16"] _
			]
	Local $i, $Value, $iErrCnt = 0, $process_killed, $aRegexResult

	For $i = 0 To UBound($aValues) - 1
		$aRegexResult = StringRegExp($__VBoxGuestProperties, "Name: " & $aValues[$i][0] & ", value: (.+), timestamp:", $STR_REGEXPARRAYMATCH)
		If @error = 0 Then
			$Value = $aRegexResult[0]
		Else
			If StringInStr($__VBoxGuestProperties, "error:") = 0 Then
				If $bSetLog Then
					SetLog("Cannot validate " & $g_sAndroidEmulator & " property " & $aValues[$i][0], $COLOR_ERROR)
				Else
					SetDebugLog("Cannot validate " & $g_sAndroidEmulator & " property " & $aValues[$i][0], $COLOR_ERROR)
				EndIF
			Else
				$Value = $aValues[$i][1]
				If $bSetLog Then
					SetLog("Cannot validate " & $g_sAndroidEmulator & " property " & $aValues[$i][0] & ", assuming " & $Value, $COLOR_ERROR)
				Else
					SetDebugLog("Cannot validate " & $g_sAndroidEmulator & " property " & $aValues[$i][0] & ", assuming " & $Value, $COLOR_ERROR)
				EndIF
			EndIf
		EndIf

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

EndFunc   ;==>CheckScreenNox

Func GetNoxRunningInstance($bStrictCheck = True)
	Local $a[2] = [0, ""]
	SetDebugLog("GetAndroidRunningInstance: Try to find """ & $g_sAndroidProgramPath & """")
	For $PID In ProcessesExist($g_sAndroidProgramPath, "", 1) ; find all process
		Local $currentInstance = $g_sAndroidInstance
		; assume last parameter is instance
		Local $CommandLine = ProcessGetCommandLine($PID)
		SetDebugLog("GetNoxRunningInstance: Found """ & $CommandLine & """ by PID=" & $PID)
		Local $aRegexResult = StringRegExp($CommandLine, ".*""-clone:([^""]+)"".*|.*-clone:([\S]+).*", $STR_REGEXPARRAYMATCH)
		If @error = 0 Then
			$g_sAndroidInstance = $aRegexResult[0]
			If $g_sAndroidInstance = "" Then $g_sAndroidInstance = $aRegexResult[1]
			SetDebugLog("Running " & $g_sAndroidEmulator & " instance is """ & $g_sAndroidInstance & """")
		EndIf
		; validate
		If WinGetAndroidHandle() <> 0 Then
			$a[0] = $g_hAndroidWindow
			$a[1] = $g_sAndroidInstance
			Return $a
		Else
			$g_sAndroidInstance = $currentInstance
		EndIf
	Next
	Return $a
EndFunc   ;==>GetNoxRunningInstance

Func RedrawNoxWindow()
	Return SetError(1)
	Local $aPos = WinGetPos($g_hAndroidWindow)
	;_PostMessage_ClickDrag($aPos[0] + Int($aPos[2] / 2), $aPos[1] + 3, $aPos[0] + Int($aPos[2] / 2), $aPos[1] + 53)
	;_PostMessage_ClickDrag($aPos[0] + Int($aPos[2] / 2), $aPos[1] + 53, $aPos[0] + Int($aPos[2] / 2), $aPos[1] + 3)
	Local $aMousePos = MouseGetPos()
	MouseClickDrag("left", $aPos[0] + Int($aPos[2] / 2), $aPos[1] + 3, $aPos[0] + Int($aPos[2] / 2), $aPos[1] + 53, 0)
	MouseClickDrag("left", $aPos[0] + Int($aPos[2] / 2), $aPos[1] + 53, $aPos[0] + Int($aPos[2] / 2), $aPos[1] + 3, 0)
	MouseMove($aMousePos[0], $aMousePos[1], 0)
	;WinMove2($g_hAndroidWindow, "", $AndroidWinPos[0], $AndroidWinPos[1], $aAndroidWindow[0], $aAndroidWindow[1])
	;ControlMove($g_hAndroidWindow, $g_sAppPaneName, $g_sAppClassInstance, 0, 0, $g_iAndroidClientWidth, $g_iAndroidClientHeight)
	;If _Sleep(500) Then Return False ; Just wait, not really required...
	;$new_BSsize = ControlGetPos($g_hAndroidWindow, $g_sAppPaneName, $g_sAppClassInstance)
	$aPos = WinGetPos($g_hAndroidWindow)
	ControlClick($g_hAndroidWindow, "", "", "left", 1, $aPos[2] - 46, 18)
	If _Sleep(500) Then Return False
	$aPos = WinGetPos($g_hAndroidWindow)
	ControlClick($g_hAndroidWindow, "", "", "left", 1, $aPos[2] - 46, 18)
	;If _Sleep(500) Then Return False
EndFunc   ;==>RedrawNoxWindow

Func HideNoxWindow($bHide = True, $hHWndAfter = Default)
	Return EmbedNox($bHide, $hHWndAfter)
EndFunc   ;==>HideNoxWindow

Func EmbedNox($bEmbed = Default, $hHWndAfter = Default)

	If $bEmbed = Default Then $bEmbed = $g_bAndroidEmbedded
	If $hHWndAfter = Default Then $hHWndAfter = $HWND_TOPMOST

	; Find QTool Parent Window
	Local $aWin = _WinAPI_EnumProcessWindows(GetAndroidPid(), False)
	Local $i, $c
	Local $hToolbar = 0

	For $i = 1 To UBound($aWin) - 1
		Local $h = $aWin[$i][0]
		Local $c = $aWin[$i][1]
		If $c = "Qt5QWindowToolSaveBits" Then
			Local $aPos = WinGetPos($h)
			If UBound($aPos) > 3 Then
				If $hToolbar = 0 And (($aPos[2] >= $g_iAndroidClientWidth And $aPos[3] > 7) Or ($aPos[2] > 7 And $aPos[3] >= $g_iAndroidClientHeight)) Then
					; found toolbar
					$hToolbar = $h
				ElseIf $aPos[2] = 7 Or $aPos[3] = 7 Then
					; found border, always hide stupid border
					WinMove2($h, "", -1, -1, -1, -1, $HWND_NOTOPMOST, $SWP_HIDEWINDOW, False)
				EndIf
			EndIf
		EndIf
	Next

	If $hToolbar = 0 Then
		SetDebugLog("EmbedNox(" & $bEmbed & "): toolbar Window not found, list of windows:" & $c) ;, Default, True
		For $i = 1 To UBound($aWin) - 1
			Local $h = $aWin[$i][0]
			Local $c = $aWin[$i][1]
			Local $aPos = WinGetPos($h)
			If UBound($aPos) > 3 Then
				SetDebugLog("EmbedNox(" & $bEmbed & "): Handle = " & $h & ", Class = " & $c & ", width=" & $aPos[2] & ", height=" & $aPos[3]) ;, Default, True
			Else
				SetDebugLog("EmbedNox(" & $bEmbed & "): Handle = " & $h & ", Class = " & $c) ;, Default, True
			EndIf
		Next
	Else
		SetDebugLog("EmbedNox(" & $bEmbed & "): $hToolbar=" & $hToolbar) ;, Default, True
		If $bEmbed Then
			WinMove2($hToolbar, "", -1, -1, -1, -1, $HWND_NOTOPMOST, $SWP_HIDEWINDOW, False, False)
		Else
			WinMove2($hToolbar, "", -1, -1, -1, -1, $hHWndAfter, $SWP_SHOWWINDOW, False, False)
			If $hHWndAfter = $HWND_TOPMOST Then WinMove2($hToolbar, "", -1, -1, -1, -1, $HWND_NOTOPMOST, $SWP_SHOWWINDOW, False, False)
		EndIf
	EndIf

EndFunc   ;==>EmbedNox
