; #FUNCTION# ====================================================================================================================
; Name ..........: Functions to interact with Android Window
; Description ...: This file contains the detection fucntions for the Emulator and Android version used.
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Cosote (12-2015)
; Modified ......: CodeSlinger69 (01-2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Global Const $g_sAdbScriptsPath = $g_sLibPath & "\adb.scripts" ; ADD script and event files folder
Global $g_sAndroidAdbPrompt = "mybot.run:" ; Unique ADB PS1 prompt
Global $g_bAndroidAdbPort = 0 ; When $g_bAndroidAdbPortPerInstance = True save here the port
Global $g_iAndroidAdbMinitouchModeDefault = 1 ; 0 = use tcp port, 1 = use stdin in separate shell
Global $g_iAndroidAdbMinitouchMode = $g_iAndroidAdbMinitouchModeDefault ; 0 = use tcp port, 1 = use stdin in separate shell
Global $g_bAndroidAdbMinitouchPort = 0 ; The minitouch port
Global $g_bAndroidAdbMinitouchSocket = 0 ; Socket for minitouch communication
Global $g_sAndroidAdbInstanceShellOptionsDefault = " -t -t" ; Additional shell options, only used by BlueStacks2 " -t -t"
Global $g_sAndroidAdbInstanceShellOptions = $g_sAndroidAdbInstanceShellOptionsDefault ; Additional shell options, only used by BlueStacks2 " -t -t"
Global $g_sAndroidAdbShellOptions = "" ; Additional shell options when launch shell with command, only used by BlueStacks2 " /data/anr/../../system/xbin/bstk/su root"
Global $g_bAndroidAdbPromptUseGiven = False ; If True, don't set custom prompt with PS1, use default
Global $g_iAndroidCoCPid = 0 ; Android CoC process PID for suspend and resume
Global $g_iAndroidAdbProcess = [0, 0, 0, 0, 0] ; Single instance of ADB used for screencap, 0: PID, 1: StdIn handle, 2: StdOut handle, 3: Process handle, 4: Thread handle
Global $g_iAndroidAdbMinitouchProcess = [0, 0, 0, 0, 0] ; Single instance of ADB used for minitouch, 0: PID, 1: StdIn handle, 2: StdOut handle, 3: Process handle, 4: Thread handle
Global $g_aiAndroidAdbClicks[1] = [-1] ; Stores clicks after KeepClicks() called, fired and emptied with ReleaseClicks()
Global $g_aiAndroidAdbStatsTotal[2][2] = [ _
		[0, 0], _ ; Total of screencap duration, 0 is count, 1 is sum of durations
		[0, 0] _ ; Total of click duration, 0 is count, 1 is sum of durations
		]
Global $g_aiAndroidAdbStatsLast[2][12] ; Last 10 durations, 0 is sum of durations, 1 is index to oldest, 2-11 last 10 durations
$g_aiAndroidAdbStatsLast[0][0] = 0 ; screencap sum of durations
$g_aiAndroidAdbStatsLast[0][1] = -1 ; screencap index to oldest
$g_aiAndroidAdbStatsLast[1][0] = 0 ; click sum of durations
$g_aiAndroidAdbStatsLast[1][1] = -1 ; click index to oldest
Global $g_bWinGetAndroidHandleActive = False ; Prevent recursion in WinGetAndroidHandle()
Global $g_bAndroidSuspended = False ; Android window is suspended flag
Global $g_bAndroidQueueReboot = False ; Reboot Android as soon as possible
Global $g_iAndroidSuspendedTimer = 0 ; Android Suspended Timer
Global $g_iSuspendAndroidTime = 0
Global $g_iSuspendAndroidTimeCount = 0
Global $g_hSuspendAndroidTimer = 0
Global $g_aiMouseOffset = [0, 0]
Global $g_aiMouseOffsetWindowOnly = [0, 0]
Global $g_bPullPushSharedPrefsAbdCommand = False ; If true, push and pull with adb pull/push is tried first before falling back to use shared folder (some adb pull can create shared_prefs subfolder causing problems)
Global $g_PushedSharedPrefsProfile = "" ; Last Profile name shared_prefs were pushed
Global $g_PushedSharedPrefsProfile_Timer = 0 ; Last __TimerInit() shared_prefs were pushed
; Update shared_prefs when pushing
Global $g_bUpdateSharedPrefsLanguage = True ; Reset Language to English when pushing shared_prefs
Global $g_bUpdateSharedPrefsSnow = True ; Reset Snow when pushing shared_prefs
Global $g_bUpdateSharedPrefsZoomLevel = True ; Reset ZoomLevel when pushing shared_prefs
Global $g_bUpdateSharedPrefsGoogleDisconnected  = True ; Reset GoogleDisconnected when pushing shared_prefs (not used, doesn't work!)
Global $g_bUpdateSharedPrefsRated  = True ; Reset Rated when pushing shared_prefs
Global $g_bAndroidZoomoutModeFallback = False ; If shared_prefs zoomout mode is used, shared_prefs pushed, then fallback to normal zoomout if still not zoomed out


Func InitAndroidConfig($bRestart = False)
	FuncEnter(InitAndroidConfig)
	If $bRestart = False Then
		$g_sAndroidEmulator = $g_avAndroidAppConfig[$g_iAndroidConfig][0]
		$g_sAndroidInstance = $g_avAndroidAppConfig[$g_iAndroidConfig][1]
		$g_sAndroidTitle = $g_avAndroidAppConfig[$g_iAndroidConfig][2]
	EndIf

	$g_sAppClassInstance = $g_avAndroidAppConfig[$g_iAndroidConfig][3] ; Control Class and instance of android rendering
	$g_sAppPaneName = $g_avAndroidAppConfig[$g_iAndroidConfig][4] ; Control name of android rendering TODO check is still required
	$g_iAndroidClientWidth = $g_avAndroidAppConfig[$g_iAndroidConfig][5] ; Expected width of android rendering control
	$g_iAndroidClientHeight = $g_avAndroidAppConfig[$g_iAndroidConfig][6] ; Expected height of android rendering control
	$g_iAndroidWindowWidth = $g_avAndroidAppConfig[$g_iAndroidConfig][7] ; Expected Width of android window
	$g_iAndroidWindowHeight = $g_avAndroidAppConfig[$g_iAndroidConfig][8] ; Expected height of android window
	$g_iAndroidAdbSuCommand = "" ; Android path to su
	;$g_sAndroidAdbPath = "" ; Path to executable HD-Adb.exe or adb.exe
	$g_sAndroidAdbDevice = $g_avAndroidAppConfig[$g_iAndroidConfig][10] ; full device name ADB connects to
	$g_iAndroidSupportFeature = $g_avAndroidAppConfig[$g_iAndroidConfig][11] ; 0 = Not available, 1 = Available, 2 = Available using ADB (experimental!)
	$g_sAndroidShellPrompt = $g_avAndroidAppConfig[$g_iAndroidConfig][12] ; empty string not available, '# ' for rooted and '$ ' for not rooted android
	$g_sAndroidMouseDevice = $g_avAndroidAppConfig[$g_iAndroidConfig][13] ; empty string not available, can be direct device '/dev/input/event2' or name by getevent -p
	$g_iAndroidEmbedMode = $g_avAndroidAppConfig[$g_iAndroidConfig][14] ; Android Dock Mode: -1 = Not available, 0 = Normal docking, 1 = Simulated docking
	$g_iAndroidBackgroundModeDefault = $g_avAndroidAppConfig[$g_iAndroidConfig][15] ; Default Android Background Mode: 1 = WinAPI mode (faster, but requires Android DirectX), 2 = ADB screencap mode (slower, but alwasy works even if Monitor is off -> "True Brackground Mode")
	$g_bAndroidAdbScreencap = $g_bAndroidAdbScreencapEnabled = True And BitAND($g_iAndroidSupportFeature, 2) = 2 ; Use Android ADB to capture screenshots in RGBA raw format
	$g_bAndroidAdbClick = $g_bAndroidAdbClickEnabled = True And AndroidAdbClickSupported() ; Enable Android ADB mouse click
	$g_bAndroidAdbInput = $g_bAndroidAdbInputEnabled = True And BitAND($g_iAndroidSupportFeature, 8) = 8 ; Enable Android ADB send text (CC requests)
	$g_bAndroidAdbInstance = $g_bAndroidAdbInstanceEnabled = True And BitAND($g_iAndroidSupportFeature, 16) = 16 ; Enable Android steady ADB shell instance when available
	$g_bAndroidAdbClickDrag = $g_bAndroidAdbClickDragEnabled = True And BitAND($g_iAndroidSupportFeature, 32) = 32 ; Enable Android ADB Click Drag script or input swipe
	$g_bAndroidPicturesPathAutoConfig = BitAND($g_iAndroidSupportFeature, 512) > 0
	$g_bAndroidEmbed = $g_bAndroidEmbedEnabled = True And $g_iAndroidEmbedMode > -1 ; Enable Android Docking
	$g_bAndroidBackgroundLaunch = $g_bAndroidBackgroundLaunchEnabled = True ; Enabled Android Background launch using Windows Scheduled Task
	$g_bAndroidBackgroundLaunched = False ; True when Android was launched in headless mode without a window
	$g_bUpdateAndroidWindowTitle = False ; If Android has always same title instance name will be added
	$g_bAndroidControlUseParentPos = False ; If true, control pos is used from parent control (only used to fix docking for Nox in DirectX mode)
	$g_sAndroidAdbInstanceShellOptions = $g_sAndroidAdbInstanceShellOptionsDefault ; Additional shell options, only used by BlueStacks2 " -t -t"
	$g_sAndroidAdbShellOptions = "" ; Additional shell options when launch shell with command, only used by BlueStacks2 " /data/anr/../../system/xbin/bstk/su root"
	$g_iAndroidRecoverStrategy = $g_iAndroidRecoverStrategyDefault
	$g_iAndroidAdbMinitouchMode = $g_iAndroidAdbMinitouchModeDefault
	; reset shared prefs variables
	$g_PushedSharedPrefsProfile = ""
	$g_PushedSharedPrefsProfile_Timer = 0
	; screencap might have disabled backgroundmode
	If $g_bAndroidAdbScreencap Then
		; update background checkbox
		UpdateChkBackground()
	EndIf

	UpdateHWnD($g_hAndroidWindow, False) ; Ensure $g_sAppClassInstance is properly set
	FuncReturn()
EndFunc   ;==>InitAndroidConfig

Func AndroidSupportFeaturesSet($iValue, $iIdx = $g_iAndroidConfig)
	$g_avAndroidAppConfig[$iIdx][11] = BitOR($g_avAndroidAppConfig[$iIdx][11], $iValue)
	$g_iAndroidSupportFeature = BitOR($g_iAndroidSupportFeature, $iValue)
EndFunc   ;==>AndroidSupportFeaturesSet

Func AndroidSupportFeaturesRemove($iValue, $iIdx = $g_iAndroidConfig)
	$g_avAndroidAppConfig[$iIdx][11] = BitAND($g_avAndroidAppConfig[$iIdx][11], BitXOR(-1, $iValue))
	$g_iAndroidSupportFeature = BitAND($g_iAndroidSupportFeature, BitXOR(-1, $iValue))
EndFunc   ;==>AndroidSupportFeaturesRemove

Func AndroidMakeDpiAware()
	Return BitAND($g_iAndroidSupportFeature, 64) > 0 And $g_bAndroidAdbScreencap = False
EndFunc   ;==>AndroidMakeDpiAware

Func CleanSecureFiles($iAgeInUTCSeconds = 600)
	If $g_sAndroidPicturesHostPath = "" Then Return
	;0x84F11AA80008358DCF4C2144FE66B332A62C9CFC
	Local $aFiles = _FileListToArray($g_sAndroidPicturesHostPath, "*", $FLTA_FILES)
	If @error Then Return
	For $i = 1 To $aFiles[0]
		If StringRegExp($aFiles[$i], "[0-9A-F]{40}") = 1 Then
			Local $aTime = FileGetTime($g_sAndroidPicturesHostPath & $aFiles[$i], $FT_CREATED)
			If UBound($aTime) < 6 Then ContinueLoop
			Local $tTime = _Date_Time_EncodeFileTime($aTime[1], $aTime[2], $aTime[0], $aTime[3], $aTime[4], $aTime[5])
			Local $tLocal = _Date_Time_LocalFileTimeToFileTime($tTime)
			Local $lo = DllStructGetData($tLocal, "Lo")
			Local $hi = DllStructGetData($tLocal, "Hi")
			Local $iCreated = $hi * 0x100000000 + $lo
			$tTime = _Date_Time_EncodeFileTime(@MON, @MDAY, @YEAR, @HOUR, @MIN, @SEC)
			$tLocal = _Date_Time_LocalFileTimeToFileTime($tTime)
			$lo = DllStructGetData($tLocal, "Lo")
			$hi = DllStructGetData($tLocal, "Hi")
			Local $iNow = $hi * 0x100000000 + $lo
			If $iCreated + $iAgeInUTCSeconds * 1000 < $iNow Then
				FileDelete($g_sAndroidPicturesHostPath & $aFiles[$i])
			EndIf
		EndIf
	Next
EndFunc   ;==>CleanSecureFiles

#cs
	Global $CALG_SHA1 = 1
	Func _Crypt_Startup()
	EndFunc
	Func _Crypt_Shutdown()
	EndFunc
	Func _Crypt_HashData($sData, $iAlgorythm)
	Local $s = "0x"
	Static $chars = "0123456789ABCDEF"
	Local $l = StringLen($sData)
	For $i = 1 To 40
	If $i <= $l Then
	$s &= StringMid($chars, Mod(ASC(StringMid($sData, $i, 1)), 16) + 1, 1)
	Else
	$s &= StringMid($chars, Random(1, 16, 1), 1)
	EndIf
	Next
	Return $s
	EndFunc
#ce

Func GetSecureFilename($Filename)
	If BitAND($g_iAndroidSecureFlags, 1) = 0 Then
		Return $Filename
	EndIf
	Return StringMid(_Crypt_HashData($Filename, $CALG_SHA1), 3)
EndFunc   ;==>GetSecureFilename

; Update Global Android variables based on $g_iAndroidConfig index
; Calls "Update" & $g_sAndroidEmulator & "Config()"
Func UpdateAndroidConfig($instance = Default, $emulator = Default)
	FuncEnter(UpdateAndroidConfig)
	If $emulator <> Default Then
		; Update $g_iAndroidConfig
		For $i = 0 To UBound($g_avAndroidAppConfig) - 1
			If $g_avAndroidAppConfig[$i][0] = $emulator Then
				If $g_iAndroidConfig <> $i Then
					$g_iAndroidConfig = $i
					$g_sAndroidEmulator = $g_avAndroidAppConfig[$g_iAndroidConfig][0]
					SetLog("Android Emulator " & $g_sAndroidEmulator)
				EndIf
				$emulator = Default
				ExitLoop
			EndIf
		Next
	EndIf
	If $emulator <> Default Then SetLog("Unknown Android Emulator " & $emulator, $COLOR_RED)
	If $instance = "" Then $instance = Default
	If $instance = Default Then $instance = $g_avAndroidAppConfig[$g_iAndroidConfig][1]
	SetDebugLog("UpdateAndroidConfig(""" & $instance & """)")

	InitAndroidConfig(False)
	$g_sAndroidInstance = $instance ; Clone or instance of emulator or "" if not supported/default instance

	; update secure setting
	If BitAND($g_iAndroidSecureFlags, 1) = 1 Then
		$g_sAndroidPicturesHostFolder = ""
	Else
		$g_sAndroidPicturesHostFolder = "mybot.run\"
	EndIf

	; validate install and initialize Android variables
	Local $Result = InitAndroid(False, False)

	SetDebugLog("UpdateAndroidConfig(""" & $instance & """) END")
	Return FuncReturn($Result)
EndFunc   ;==>UpdateAndroidConfig

Func UpdateAndroidWindowState()
	; Android specific configurations
	Local $bChanged = Execute("Update" & $g_sAndroidEmulator & "WindowState()")
	If $bChanged = "" And @error <> 0 Then Return False ; Not implemented
	Return $bChanged
EndFunc   ;==>UpdateAndroidWindowState

Func GetAndroidControlClass($bCheck = False, $bInit = False)
	If $bInit = False And ($bCheck = False Or IsString($g_sAppClassInstance) Or IsHWnd($g_sAppClassInstance)) Then Return SetError(0, 0, $g_sAppClassInstance)
	; Handle not found, try to update
	$g_hAndroidControl = 0
	$g_sAppClassInstance = $g_avAndroidAppConfig[$g_iAndroidConfig][3]
	Local $hAndroidWin = GetCurrentAndroidHWnD()
	If IsHWnd($hAndroidWin) Then
		; ok, Android Window exists
		Local $hCtrl = ControlGetHandle2($hAndroidWin, $g_sAppPaneName, $g_sAppClassInstance, 100, 100)
		If $hCtrl = 0 Then
			Return SetError(1, 0, $g_sAppClassInstance)
		EndIf
		Local $AppClass = $g_sControlGetHandle2_Classname
		If BitAND($g_iAndroidSupportFeature, 256) > 0 Then $AppClass = $hCtrl
		If $g_sAppClassInstance <> $AppClass Then
			SetDebugLog("Update $g_sAppClassInstance to: " & $AppClass)
		EndIf
		$g_sAppClassInstance = $AppClass
		Local $hWinParent = __WinAPI_GetParent($hCtrl)
		If $hWinParent = 0 Then
			$g_sAppClassInstance = $g_avAndroidAppConfig[$g_iAndroidConfig][3]
			Return SetError(1, 0, $g_sAppClassInstance)
		EndIf
		; all good
		$g_hAndroidControl = $hWinParent
		Return SetError(0, 0, $g_sAppClassInstance)
	EndIf
	; Android not found
	Return SetError(0, 0, $g_sAppClassInstance)
EndFunc   ;==>GetAndroidControlClass

Func UpdateHWnD($hWin, $bRestart = True)
	FuncEnter(UpdateHWnD)
	If $hWin = 0 Then
		If $g_hAndroidWindow <> 0 And $bRestart Then
			$g_bRestart = True ; Android likely crashed
			;$g_bIsClientSyncError = True ; quick restart search
		EndIf
		$g_hAndroidWindow = 0
		GetAndroidControlClass(True, True)
		ResetAndroidProcess()
		InitAndroidRebootCondition(False)
		Return FuncReturn(False)
	EndIf
	If $g_hAndroidWindow <> 0 And $bRestart Then
		$g_bRestart = True ; Android likely crashed
		;$g_bIsClientSyncError = True ; quick restart search
	EndIf

	If $g_iAndroidProcessAffinityMask Then
		Local $pid = WinGetProcess($hWin)
		Local $ai_Handle = _WinAPI_OpenProcess($PROCESS_ALL_ACCESS, False, $pid)
		If $ai_Handle Then
			_WinAPI_SetProcessAffinityMask($ai_Handle, $g_iAndroidProcessAffinityMask)
			;_WinAPI_CloseHandle($hProcess)
		EndIf
	EndIf

	_WindowAppId($hWin, "MyBot.run.Android")
	$g_hAndroidWindow = $hWin
	CheckDpiAwareness()
	; reset time lag
	InitAndroidTimeLag()
	ResetAndroidProcess()
	GetAndroidControlClass(True, True)
	If @error Then Return FuncReturn(SetError(1, 0, False))
	Return FuncReturn(SetError(0, 0, True))
EndFunc   ;==>UpdateHWnD

Func WinGetAndroidHandle($bInitAndroid = Default, $bTestPid = False)
	FuncEnter(WinGetAndroidHandle)
	If $bInitAndroid = Default Then $bInitAndroid = $g_bInitAndroidActive = False
	If $g_bWinGetAndroidHandleActive = True Then
		Return FuncReturn($g_hAndroidWindow)
	EndIf
	$g_bWinGetAndroidHandleActive = True
	Local $currHWnD = $g_hAndroidWindow

	If $g_hAndroidWindow = 0 Or $g_bAndroidBackgroundLaunched = False Then _WinGetAndroidHandle()
	If IsHWnd($g_hAndroidWindow) = 1 Then
		; Android Window found
		Local $aPos = WinGetPos($g_hAndroidWindow)
		If IsArray($aPos) Then
			If $g_bAndroidEmbedded = False And _CheckWindowVisibility($g_hAndroidWindow, $aPos) Then
				SetDebugLog("Android Window '" & $g_sAndroidTitle & "' not visible, moving to position: " & $aPos[0] & ", " & $aPos[1])
				WinMove($g_hAndroidWindow, "", $aPos[0], $aPos[1])
				$aPos = WinGetPos($g_hAndroidWindow)
			EndIf
		EndIf

		AndroidQueueReboot(False)
		If ($g_iAndroidPosX = $g_WIN_POS_DEFAULT Or $g_iAndroidPosY = $g_WIN_POS_DEFAULT) And UBound($aPos) > 1 Then
			$g_iAndroidPosX = $aPos[0]
			$g_iAndroidPosY = $aPos[1]
		EndIf
		If $currHWnD = 0 Or $currHWnD <> $g_hAndroidWindow Then
			; Restore original Android Window position
			If $g_bAndroidEmbedded = False And IsArray($aPos) = 1 And ($g_bIsHidden = False Or ($aPos[0] > -30000 Or $aPos[1] > -30000)) Then
				SetDebugLog("Move Android Window '" & $g_sAndroidTitle & "' to position: " & $g_iAndroidPosX & ", " & $g_iAndroidPosY)
				HideAndroidWindow(False, Default, Default, "WinGetAndroidHandle:1", 0)
				$aPos[0] = $g_iAndroidPosX
				$aPos[1] = $g_iAndroidPosY
			EndIf
			Local $instance = ($g_sAndroidInstance = "" ? "" : " (" & $g_sAndroidInstance & ")")
			SetLog($g_sAndroidEmulator & $instance & " running in window mode", $COLOR_ACTION)
			If $currHWnD <> 0 And $currHWnD <> $g_hAndroidWindow Then
				$g_bInitAndroid = True
				If $bInitAndroid = True Then InitAndroid(True)
			EndIf
		EndIf
		; update Android Window position
		If $g_bAndroidEmbedded = False And IsArray($aPos) = 1 Then
			Local $posX = $g_iAndroidPosX
			Local $posY = $g_iAndroidPosY
			$g_iAndroidPosX = ($aPos[0] > -30000 ? $aPos[0] : $g_iAndroidPosX)
			$g_iAndroidPosY = ($aPos[1] > -30000 ? $aPos[1] : $g_iAndroidPosY)
			If $posX <> $g_iAndroidPosX Or $posY <> $g_iAndroidPosY Then
				SetDebugLog("Updating Android Window '" & $g_sAndroidTitle & "' position: " & $g_iAndroidPosX & ", " & $g_iAndroidPosY)
			EndIf
			If $g_bIsHidden = True And ($aPos[0] > -30000 Or $aPos[1] > -30000) Then
				; rehide Android
				HideAndroidWindow(True, Default, Default, "WinGetAndroidHandle:2")
			EndIf
		EndIf
		$g_bWinGetAndroidHandleActive = False
		Return FuncReturn($g_hAndroidWindow)
	EndIf

	If $g_bAndroidBackgroundLaunch = False And $bTestPid = False Then
		; Headless mode support not enabled
		$g_bWinGetAndroidHandleActive = False
		Return FuncReturn($g_hAndroidWindow)
	EndIf

	; Now check headless mode
	If $g_hAndroidWindow <> 0 Then
		If $g_hAndroidWindow = ProcessExists2($g_hAndroidWindow) Then
			; Android Headless process found
			;$g_bAndroidBackgroundLaunched = True
		Else
			Local $instance = ($g_sAndroidInstance = "" ? "" : " (" & $g_sAndroidInstance & ")")
			SetDebugLog($g_sAndroidEmulator & $instance & " process with PID = " & $g_hAndroidWindow & " not found")
			UpdateHWnD(0)
		EndIf
	EndIf

	If $g_hAndroidWindow = 0 Then
		If $g_sAndroidProgramPath <> "" Then
			Local $parameter = GetAndroidProgramParameter(False)
			Local $parameter2 = GetAndroidProgramParameter(True)
			Local $pid = ProcessExists2($g_sAndroidProgramPath, $parameter, 0, 0, "Is" & $g_sAndroidEmulator & "CommandLine")
			If $pid = 0 And $parameter <> $parameter2 Then
				; try alternative parameter
				$parameter = $parameter2
				$pid = ProcessExists2($g_sAndroidProgramPath, $parameter, 0, 0, "Is" & $g_sAndroidEmulator & "CommandLine")
			EndIf
			Local $commandLine = $g_sAndroidProgramPath & ($parameter = "" ? "" : " " & $parameter)
			Local $instance = ($g_sAndroidInstance = "" ? "" : " (" & $g_sAndroidInstance & ")")
			If $pid <> 0 Then
				SetDebugLog("Found " & $g_sAndroidEmulator & $instance & " process " & $pid & " ('" & $commandLine & "')")
				If $bTestPid = True Then
					$g_bWinGetAndroidHandleActive = False
					Return FuncReturn($pid)
				EndIf
				If $g_bAndroidAdbScreencap = True And $g_bAndroidAdbClick = False And AndroidAdbClickSupported() = True Then
					SetLog("Enabled ADB Click to support background mode", $COLOR_ACTION)
					$g_bAndroidAdbClick = True
				EndIf
				If $g_bAndroidAdbClick = False Or $g_bAndroidAdbScreencap = False Then
					If $g_bAndroidQueueReboot = False Then
						SetLog("Headless Android not supported because", $COLOR_ERROR)
						Local $reason = ""
						If $g_bAndroidAdbClick = False Then $reason &= "ADB Click " & ($g_bAndroidAdbScreencap = False ? "and " : "")
						If $g_bAndroidAdbScreencap = False Then $reason &= "ADB Screencap "
						$reason &= "not available!"
						SetLog($reason, $COLOR_ERROR)
						;$g_hAndroidWindow = 0
						AndroidQueueReboot(True)
					EndIf
					UpdateHWnD($pid)
					If $currHWnD <> 0 And $currHWnD <> $g_hAndroidWindow Then
						$g_bInitAndroid = True
						If $bInitAndroid = True Then InitAndroid(True)
					EndIf
				Else
					SetLog($g_sAndroidEmulator & $instance & " running in headless mode", $COLOR_ACTION)
					UpdateHWnD($pid)
					If $currHWnD <> 0 And $currHWnD <> $g_hAndroidWindow Then
						$g_bInitAndroid = True
						If $bInitAndroid = True Then InitAndroid(True)
					EndIf
					$g_bAndroidBackgroundLaunched = True
				EndIf
				setAndroidPID($pid)
			Else
				SetDebugLog($g_sAndroidEmulator & $instance & " process not found")
			EndIf
		EndIf
	EndIf

	If $g_hAndroidWindow = 0 Then
		$g_bInitAndroid = True
		$g_bAndroidBackgroundLaunched = False
	EndIf

	$g_bWinGetAndroidHandleActive = False
	Return FuncReturn($g_hAndroidWindow)

EndFunc   ;==>WinGetAndroidHandle

Func GetAndroidPid()
	Local $h = WinGetAndroidHandle(Default, True)
	If IsHWnd($h) Then Return WinGetProcess($h)
	Return $h
EndFunc   ;==>GetAndroidPid

; Find Android Window defined by $g_sAndroidTitle in WinTitleMatchMode -1 and updates $g_hAndroidWindow and $g_sAndroidTitle when found.
; Uses different strategies to find best matching Window.
; Returns Android Window Handle or 0 if Window not found
Func _WinGetAndroidHandle($bFindByTitle = False)
	; Default WinTitleMatchMode should be 3 (exact match)
	Local $hWin = WinGetHandle($g_hAndroidWindow)
	If $hWin > 0 And $hWin = $g_hAndroidWindow Then Return $g_hAndroidWindow

	; Window not found, reset $g_sAppClassInstance as it might have replaced with handle
	If $g_sAppClassInstance <> $g_avAndroidAppConfig[$g_iAndroidConfig][3] Then
		SetDebugLog("Restore $g_sAppClassInstance to: " & $g_avAndroidAppConfig[$g_iAndroidConfig][3])
	EndIf
	$g_sAppClassInstance = $g_avAndroidAppConfig[$g_iAndroidConfig][3]

	; Find all controls by title and check which contains the android control (required for Nox)
	Local $i
	Local $t
	Local $ReInitAndroid = $g_hAndroidWindow <> 0
	SetDebugLog("Searching " & $g_sAndroidEmulator & " Window: Title = '" & $g_sAndroidTitle & "', Class = '" & $g_sAppClassInstance & "', Text = '" & $g_sAppPaneName & "'")
	Local $aWinList
	If $bFindByTitle = True Then
		$aWinList = WinList($g_sAndroidTitle)
		If $aWinList[0][0] > 0 Then
			For $i = 1 To $aWinList[0][0]
				; early exit if control exists
				$hWin = $aWinList[$i][1]
				$t = $aWinList[$i][0]
				If $g_sAndroidTitle = $t Then
					Local $hCtrl = ControlGetHandle2($hWin, $g_sAppPaneName, $g_sAppClassInstance)
					If $hCtrl <> 0 Then
						SetDebugLog("Found " & $g_sAndroidEmulator & " Window '" & $t & "' (" & $hWin & ") by matching title '" & $g_sAndroidTitle & "' (#1)")
						UpdateHWnD($hWin)
						$g_sAndroidTitle = UpdateAndroidWindowTitle($g_hAndroidWindow, $t)
						If $ReInitAndroid = True And $g_bInitAndroid = False Then ; Only initialize Android when not currently running
							$g_bInitAndroid = True ; change window, re-initialize Android config
							InitAndroid()
						EndIf
						AndroidEmbed(False, False)
						setAndroidPID(GetAndroidPid())
						Return $hWin
					EndIf
				EndIf
			Next
		EndIf

		; search for window
		Local $iMode = Opt("WinTitleMatchMode", -1)
		$hWin = WinGetHandle($g_sAndroidTitle)
		Local $error = @error
		Opt("WinTitleMatchMode", $iMode)
		If $error = 0 Then
			; window found, check title for case insensitive match
			$t = WinGetTitle($hWin)
			If $g_sAndroidTitle = $t And ControlGetHandle2($hWin, $g_sAppPaneName, $g_sAppClassInstance) <> 0 Then
				; all good, update $g_hAndroidWindow and exit
				If $g_hAndroidWindow <> $hWin Then SetDebugLog("Found " & $g_sAndroidEmulator & " Window '" & $t & "' (" & $hWin & ") by matching title '" & $g_sAndroidTitle & "' (#2)")
				UpdateHWnD($hWin)
				$g_sAndroidTitle = UpdateAndroidWindowTitle($g_hAndroidWindow, $t)
				If $ReInitAndroid = True And $g_bInitAndroid = False Then ; Only initialize Android when not currently running
					$g_bInitAndroid = True ; change window, re-initialize Android config
					InitAndroid()
				EndIf
				AndroidEmbed(False, False)
				setAndroidPID(GetAndroidPid())
				Return $hWin
			Else
				SetDebugLog($g_sAndroidEmulator & " Window title '" & $t & "' not matching '" & $g_sAndroidTitle & "' or control")
			EndIf
		EndIf

		; Check for multiple windows
		$iMode = Opt("WinTitleMatchMode", -1)
		$aWinList = WinList($g_sAndroidTitle)
		Opt("WinTitleMatchMode", $iMode)
		If $aWinList[0][0] = 0 Then
			SetDebugLog($g_sAndroidEmulator & " Window not found")
			If $ReInitAndroid = True Then $g_bInitAndroid = True ; no window anymore, re-initialize Android config
			UpdateHWnD(0)
			AndroidEmbed(False, False)
			Return 0
		EndIf
		SetDebugLog("Found " & $aWinList[0][0] & " possible " & $g_sAndroidEmulator & " windows by title '" & $g_sAndroidTitle & "':")
		For $i = 1 To $aWinList[0][0]
			SetDebugLog($aWinList[$i][1] & ": " & $aWinList[$i][0])
		Next
		If $g_sAndroidInstance <> "" Then
			; Check for given instance
			For $i = 1 To $aWinList[0][0]
				$t = $aWinList[$i][0]
				$hWin = $aWinList[$i][1]
				If StringRight($t, StringLen($g_sAndroidInstance)) = $g_sAndroidInstance And ControlGetHandle2($hWin, $g_sAppPaneName, $g_sAppClassInstance) <> 0 Then
					; looks good, update $g_hAndroidWindow, $g_sAndroidTitle and exit
					SetDebugLog("Found " & $g_sAndroidEmulator & " Window '" & $t & "' (" & $hWin & ") for instance " & $g_sAndroidInstance)
					UpdateHWnD($hWin)
					$g_sAndroidTitle = UpdateAndroidWindowTitle($g_hAndroidWindow, $t)
					If $ReInitAndroid = True And $g_bInitAndroid = False Then ; Only initialize Android when not currently running
						$g_bInitAndroid = True ; change window, re-initialize Android config
						InitAndroid()
					EndIf
					AndroidEmbed(False, False)
					setAndroidPID(GetAndroidPid())
					Return $hWin
				EndIf
			Next
		EndIf
	EndIf
	; Check by command line
	If $g_sAndroidProgramPath <> "" Then
		Local $parameter = GetAndroidProgramParameter(False)
		Local $parameter2 = GetAndroidProgramParameter(True)
		Local $pid = ProcessExists2($g_sAndroidProgramPath, $parameter, 0, 0, "Is" & $g_sAndroidEmulator & "CommandLine")
		If $pid = 0 And $parameter <> $parameter2 Then
			; try alternative parameter
			$parameter = $parameter2
			$pid = ProcessExists2($g_sAndroidProgramPath, $parameter, 0, 0, "Is" & $g_sAndroidEmulator & "CommandLine")
		EndIf
		Local $commandLine = $g_sAndroidProgramPath & ($parameter = "" ? "" : " " & $parameter)
		If $pid <> 0 Then
			If IsArray($aWinList) = 0 Then
				Local $aWinList2 = _WinAPI_EnumProcessWindows($pid, True)
				If IsArray($aWinList2) = 1 And $aWinList2[0][0] > 0 Then
					Local $aWinList[$aWinList2[0][0] + 1][5]
					$aWinList[0][0] = $aWinList2[0][0]
					For $i = 1 To $aWinList2[0][0]
						Local $aPos = WinGetPos($aWinList2[$i][0])
						$aWinList[$i][0] = WinGetTitle($aWinList2[$i][0])
						$aWinList[$i][1] = $aWinList2[$i][0]
						$aWinList[$i][2] = $aWinList2[$i][1]
						If UBound($aPos) > 3 Then
							$aWinList[$i][3] = $aPos[2]
							$aWinList[$i][4] = $aPos[3]
						EndIf
						SetDebugLog("Found Android window: " & $aWinList[$i][0] & ", " & $aWinList[$i][1] & ", " & $aWinList[$i][2] & ", " & $aWinList[$i][3] & ", " & $aWinList[$i][4])
					Next
				EndIf
			EndIf
			If IsArray($aWinList) = 1 Then
				SetDebugLog("Found " & $aWinList[0][0] & " windows, searching for '" & $g_sAppPaneName & "' with class '" & $g_sAppClassInstance & "'")
				For $i = 1 To $aWinList[0][0]
					$t = $aWinList[$i][0]
					$hWin = $aWinList[$i][1]
					If $pid = WinGetProcess($hWin) And ControlGetHandle2($hWin, $g_sAppPaneName, $g_sAppClassInstance) <> 0 And $aWinList[$i][3] > 400 And $aWinList[$i][4] > 400 Then
						SetDebugLog("Found " & $g_sAndroidEmulator & " Window '" & $t & "' (" & $hWin & ") by PID " & $pid & " ('" & $commandLine & "')")
						UpdateHWnD($hWin)
						$g_sAndroidTitle = UpdateAndroidWindowTitle($g_hAndroidWindow, $t)
						If $ReInitAndroid = True And $g_bInitAndroid = False Then ; Only initialize Android when not currently running
							$g_bInitAndroid = True ; change window, re-initialize Android config
							InitAndroid()
						EndIf
						AndroidEmbed(False, False)
						setAndroidPID(GetAndroidPid())
						Return $hWin
					EndIf
				Next
			EndIf
			SetDebugLog($g_sAndroidEmulator & ($g_sAndroidInstance = "" ? "" : " (" & $g_sAndroidInstance & ")") & " Window not found for PID " & $pid)
		EndIf
	EndIf

	SetDebugLog($g_sAndroidEmulator & ($g_sAndroidInstance = "" ? "" : " (" & $g_sAndroidInstance & ")") & " Window not found in list")
	If $ReInitAndroid = True Then $g_bInitAndroid = True ; no window anymore, re-initialize Android config
	UpdateHWnD(0)
	AndroidEmbed(False, False)
	Return 0
EndFunc   ;==>_WinGetAndroidHandle

Func UpdateAndroidWindowTitle($hWin, $t)
	If $g_bUpdateAndroidWindowTitle = True And $g_sAndroidInstance <> "" And StringInStr($t, $g_sAndroidInstance) = 0 Then
		;$t &= " (" & $g_sAndroidInstance & ")"
		$t = $g_sAndroidEmulator & " (" & $g_sAndroidInstance & ")"
		_WinAPI_SetWindowText($hWin, $t)
	EndIf
	Return $t
EndFunc   ;==>UpdateAndroidWindowTitle

Func AndroidControlAvailable()
	If $g_bAndroidBackgroundLaunched = True Then
		Return 0
	EndIf
	Return IsArray(GetAndroidPos(True))
EndFunc   ;==>AndroidControlAvailable

Func GetAndroidSvcPid()
	Static $iAndroidSvcPid = 0 ; Android Backend Process

	If $iAndroidSvcPid <> 0 And $iAndroidSvcPid = ProcessExists2($iAndroidSvcPid) Then
		Return $iAndroidSvcPid
	EndIf

	SetError(0, 0, 0)
	Local $pid = Execute("Get" & $g_sAndroidEmulator & "SvcPid()")
	If $pid = "" And @error <> 0 Then $pid = GetVBoxAndroidSvcPid() ; Not implemented, use VBox default

	If $pid <> 0 Then
		SetDebugLog("Found " & $g_sAndroidEmulator & " Service PID = " & $pid)
	Else
		SetDebugLog("Cannot find " & $g_sAndroidEmulator & " Service PID", $COLOR_ERROR)
	EndIf
	$iAndroidSvcPid = $pid
	Return $pid
EndFunc   ;==>GetAndroidSvcPid

Func GetVBoxAndroidSvcPid()

	; find vm uuid (it's used as command line parameter)
	Local $aRegExResult = StringRegExp($__VBoxVMinfo, "UUID:\s+(.+)", $STR_REGEXPARRAYMATCH)
	Local $uuid = ""
	If Not @error Then $uuid = $aRegExResult[0]
	If StringLen($uuid) < 32 Then
		SetDebugLog("Cannot find VBox UUID", $COLOR_ERROR)
		Return 0
	EndIf

	; find process PID
	Local $pid = ProcessExists2("", $uuid, 1, 1)
	Return $pid

EndFunc   ;==>GetVBoxAndroidSvcPid

; Checks if Android is running and returns array of window handle and instance name
; $bStrictCheck = False includes "unsupported" ways of launching Android (like BlueStacks2 default launch shortcut)
Func GetAndroidRunningInstance($bStrictCheck = True)
	FuncEnter(GetAndroidRunningInstance)
	Local $runningInstance = Execute("Get" & $g_sAndroidEmulator & "RunningInstance(" & $bStrictCheck & ")")
	Local $i
	If $runningInstance = "" And @error <> 0 Then ; Not implemented
		Local $a[2] = [0, ""]
		SetDebugLog("GetAndroidRunningInstance: Try to find """ & $g_sAndroidProgramPath & """")
		Local $pids = ProcessesExist($g_sAndroidProgramPath, "", 1) ; find any process
		If UBound($pids) > 0 Then
			Local $currentInstance = $g_sAndroidInstance
			For $i = 0 To UBound($pids) - 1
				Local $pid = $pids[$i]
				; assume last parameter is instance
				Local $commandLine = ProcessGetCommandLine($pid)
				SetDebugLog("GetAndroidRunningInstance: Found """ & $commandLine & """ by PID=" & $pid)
				Local $lastSpace = StringInStr($commandLine, " ", 0, -1)
				If $lastSpace > 0 Then
					$g_sAndroidInstance = StringStripWS(StringMid($commandLine, $lastSpace + 1), 3)
					; Check that $g_sAndroidInstance default instance is used for ""
					If $g_sAndroidInstance = "" Then $g_sAndroidInstance = $g_avAndroidAppConfig[$g_iAndroidConfig][1]
				EndIf
				; validate
				If WinGetAndroidHandle() <> 0 Then
					SetDebugLog("Running " & $g_sAndroidEmulator & " instance found: """ & $g_sAndroidInstance & """")
					If $a[0] = 0 Or $g_sAndroidInstance = $currentInstance Then
						$a[0] = $g_hAndroidWindow
						$a[1] = $g_sAndroidInstance
						If $g_sAndroidInstance = $currentInstance Then ExitLoop
					EndIf
				Else
					$g_sAndroidInstance = $currentInstance
				EndIf
			Next
		EndIf
		If $a[0] <> 0 Then SetDebugLog("Running " & $g_sAndroidEmulator & " instance is """ & $g_sAndroidInstance & """")
		Return FuncReturn($a)
	EndIf
	Return FuncReturn($runningInstance)
EndFunc   ;==>GetAndroidRunningInstance

; Detects first running Android Window is present based on $g_avAndroidAppConfig array sequence
Func DetectRunningAndroid()
	FuncEnter(DetectRunningAndroid)
	; Find running Android Emulator
	$g_bFoundRunningAndroid = False

	Local $i, $iCurrentConfig = $g_iAndroidConfig
	$g_bSilentSetLog = True
	For $i = 0 To UBound($g_avAndroidAppConfig) - 1
		$g_iAndroidConfig = $i
		$g_bInitAndroid = True
		If UpdateAndroidConfig() = True Then
			; this Android is installed
			Local $aRunning = GetAndroidRunningInstance(False)
			If $aRunning[0] = 0 Then
				; not running
			Else
				; Window is available
				$g_bFoundRunningAndroid = True
				$g_bSilentSetLog = False
				$g_bInitAndroid = True ; init Android again now
				If InitAndroid() = True Then
					SetDebugLog("Found running " & $g_sAndroidEmulator & " " & $g_sAndroidVersion)
				EndIf
				Return FuncReturn()
			EndIf
		EndIf
	Next

	; Reset to current config
	$g_bInitAndroid = True
	$g_iAndroidConfig = $iCurrentConfig
	UpdateAndroidConfig()
	$g_bSilentSetLog = False
	SetDebugLog("Found no running Android Emulator")
	FuncReturn()
EndFunc   ;==>DetectRunningAndroid

; Detects first installed Adnroid Emulator installation based on $g_avAndroidAppConfig array sequence
Func DetectInstalledAndroid()
	FuncEnter(DetectInstalledAndroid)
	; Find installed Android Emulator

	Local $i, $CurrentConfig = $g_iAndroidConfig
	$g_bSilentSetLog = True
	For $i = 0 To UBound($g_avAndroidAppConfig) - 1
		$g_iAndroidConfig = $i
		$g_bInitAndroid = True
		If UpdateAndroidConfig() Then
			; installed Android found
			$g_bFoundInstalledAndroid = True
			$g_bSilentSetLog = False
			SetDebugLog("Found installed " & $g_sAndroidEmulator & " " & $g_sAndroidVersion)
			Return FuncReturn()
		EndIf
	Next

	; Reset to current config
	$g_iAndroidConfig = $CurrentConfig
	$g_bInitAndroid = True
	UpdateAndroidConfig()
	$g_bSilentSetLog = False
	SetDebugLog("Found no installed Android Emulator")
	FuncReturn()
EndFunc   ;==>DetectInstalledAndroid

; Custom - Team AIO Mod++
; Find preferred Adb Path. Current Android ADB is used and saved in profile.ini and shared across instances.
Func FindPreferredAdbPath()
	Local $sADB = ($g_sAndroidEmulator = "Nox") ? ("nox_adb.exe") : ("adb.exe")
	$sADB = (StringInStr($g_sAndroidEmulator, "BlueStacks") <> 0) ? ("HD-adb.exe") : ($sADB)
	Local $sADBPathExeOri = @ScriptDir & "\lib\adb\adb.exe"
	Local $sADBPath = $sADBPathExeOri
	Local $sADBPathvdll = @ScriptDir & "\lib\adb\AdbWinApi.dll"
	Local $sADBPathvdll1 = @ScriptDir & "\lib\adb\AdbWinUsbApi.dll"
	Local $sFolderBy = @ScriptDir & "\lib\AdbTemp\" & $g_sAndroidInstance & "\"
	Local $iMyBotPath = 0, $iNewADBSize = 0, $iError = 0, $aAdbProcess = 0

	Local $sPathAdbLegacy = Execute("Get" & $g_sAndroidEmulator & "AdbPath()")
	If not @error And FileExists($sPathAdbLegacy) Then
		$aAdbProcess = ProcessesExist($sPathAdbLegacy)
		For $i = 0 To UBound($aAdbProcess) -1
			; ensure target process is not running
			KillProcess($aAdbProcess[$i], "FindPreferredAdbPath (1)")
		Next
	
		Switch $g_iAndroidAdbReplace
			Case 2
				Local $sDummyAdb = @ScriptDir & "\lib\DummyExe.exe"
				Local $bDummy = FileExists($sDummyAdb)
				If Not $bDummy Then ContinueCase
				If FileGetSize($sDummyAdb) <> FileGetSize($sPathAdbLegacy) And not @error Then
					If FileCopy($sDummyAdb, $sPathAdbLegacy, $FC_OVERWRITE) = 1 Then SetLog("Replaced ADB.EXE by Dummy", $COLOR_INFO)
				EndIf
			Case 1
				If FileGetSize($sADBPathExeOri) <> FileGetSize($sPathAdbLegacy) And not @error Then
					If FileCopy($sADBPathExeOri, $sPathAdbLegacy, $FC_OVERWRITE) = 1 Then SetLog("Replaced ADB.EXE by MyBot ADB", $COLOR_INFO)
					Local $sDirectory = StringRegExpReplace($sPathAdbLegacy, "(^.*\\)(.*)", "\1")
					FileCopy($sADBPathvdll, $sDirectory & StringRegExpReplace($sADBPathvdll, "^.*\\", ""), $FC_OVERWRITE)
					FileCopy($sADBPathvdll1, $sDirectory & StringRegExpReplace($sADBPathvdll1, "^.*\\", ""), $FC_OVERWRITE)
				EndIf
				
				$sPathAdbLegacy = Execute("Get" & $g_sAndroidEmulator & "AdbPath()")
				
				If FileExists($sPathAdbLegacy) Then
					$g_sAndroidAdbPath = $sPathAdbLegacy
					Return $g_sAndroidAdbPath
				EndIf

		EndSwitch
	EndIf

	If DirCreate($sFolderBy) = 0 Then
		SetLog("Adb Directory error!", $COLOR_ERROR)
		$sADBPath = $sADBPathExeOri
		$g_sandroidadbpath = $sADBPath
	Else
		SetDebugLog("ADB Checking", $COLOR_ACTION)
		$sADBPath = $sFolderBy & $sADB
		$g_sandroidadbpath = $sADBPath

		$iMyBotPath = FileGetSize($sADBPathExeOri)
		$iError = @error
		$iNewADBSize = FileGetSize($sADBPath)
		If $iMyBotPath <> $iNewADBSize And not $iError Then

			$aAdbProcess = ProcessesExist($sFolderBy & $sADB)
			For $i = 0 To UBound($aAdbProcess) -1
				; ensure target process is not running
				KillProcess($aAdbProcess[$i], "FindPreferredAdbPath (2)")
			Next

			$aAdbProcess = ProcessesExist($sADBPathExeOri)
			For $i = 0 To UBound($aAdbProcess) -1
				; ensure target process is not running
				KillProcess($aAdbProcess[$i], "FindPreferredAdbPath (3)")
			Next

			SetDebugLog("$g_sAndroidADBPath: " & $g_sAndroidADBPath)
			If FileCopy($sADBPathExeOri, $sFolderBy & $sADB, $FC_OVERWRITE) = 0 Then
				SetLog("$sADBPathExeOri FAIL", $COLOR_ERROR)
			EndIf
		EndIf

		$iMyBotPath = FileGetSize($sADBPathvdll)
		If Not $iError Then $iError = @error
		$iNewADBSize = FileGetSize($sFolderBy & "AdbWinApi.dll")
		If $iMyBotPath <> $iNewADBSize And not $iError Then
			If FileCopy($sADBPathvdll, $sFolderBy & "AdbWinApi.dll", $FC_OVERWRITE) = 0 Then
				SetLog("$sADBPathvdll FAIL", $COLOR_ERROR)
			EndIf
		EndIf

		$iMyBotPath = FileGetSize($sADBPathvdll1)
		If Not $iError Then $iError = @error
		$iNewADBSize = FileGetSize($sFolderBy & "AdbWinUsbApi.dll")
		If $iMyBotPath <> $iNewADBSize And not $iError Then
			If FileCopy($sADBPathvdll1, $sFolderBy & "AdbWinUsbApi.dll", $FC_OVERWRITE) = 0 Then
				SetLog("$sADBPathvdll1 FAIL", $COLOR_ERROR)
			EndIf
		EndIf
	EndIf

	If $iError Then
		$sADBPath = $sADBPathExeOri
		$g_sandroidadbpath = $sADBPath
		SetLog("ADB Checking failed", $COLOR_ERROR)
	Else
		SetDebugLog("ADB Checking OK", $COLOR_INFO)
	EndIf

	Return $sADBPath
EndFunc   ;==>FindPreferredsADBPath

Func CompareAndUpdate(ByRef $UpdateWhenDifferent, Const $New)
	Local $bDifferent = $UpdateWhenDifferent <> $New
	If $bDifferent Then $UpdateWhenDifferent = $New
	Return $bDifferent
EndFunc   ;==>CompareAndUpdate

Func IncrUpdate(ByRef $i, $ReturnInitial = True)
	Local $i2 = $i
	$i += 1
	If $ReturnInitial Then Return $i2
	Return $i
EndFunc   ;==>IncrUpdate

Func InitAndroidAdbPorts($bForce = False)

	Local $bUsePort = $g_bAndroidAdbPortPerInstance

	If $bForce Then $g_bAndroidAdbPort = 0
	If Not $g_bAndroidAdbPort Then
		; dynamically select port to use by mutex
		Local $iPortStart = 5038, $iPortRange = 255
		Local $iPort = $iPortStart, $iTcpIdx = 1, $iTcpMtIdx = 0, $iMtPort
		Local $hMutex = 0
		$g_sAndroidAdbGlobalOptions = ""
		Local $aTcpTable = _TcpTable(5, "LISTENING")
		If $g_hMutex_AdbDaemon Then
			; release prior mutex
			ReleaseMutex($g_hMutex_AdbDaemon)
			$g_hMutex_AdbDaemon = 0
		EndIf
		While Not $hMutex And $iPort < $iPortStart + $iPortRange
			; find next free port
			For $i = $iTcpIdx To UBound($aTcpTable) - 1
				If $aTcpTable[$i][2] < $iPort Then
					$iTcpIdx = $i + 1
					ContinueLoop
				ElseIf $aTcpTable[$i][0] = "adb.exe" Or $aTcpTable[$i][2] > $iPort Then
					; re-use adb.exe or port is free
					ExitLoop
				Else
					; cannot use that port
					$iPort += 1
				EndIf
			Next
			; now check for free minitouch port
			$iMtPort = 0
			If $g_iAndroidAdbMinitouchMode = 0 Then
				$iTcpMtIdx = _ArrayBinarySearch($aTcpTable, $iPort + 1000, 0, 0, 2)
				If $iTcpMtIdx = -1 Or ($iTcpMtIdx > 0 And $aTcpTable[$iTcpMtIdx][0] = "adb.exe") Then
					; use minitouch port
					$iMtPort = $iPort + 1000
				EndIf
			EndIf
			If $iMtPort Or $g_iAndroidAdbMinitouchMode = 1 Then
				; try to use it
				$hMutex = CreateMutex("MyBot.run/Adb-Port-" & $iPort)
				If $hMutex Then
					;_ArrayDisplay($aTcpTable)
					$g_hMutex_AdbDaemon = $hMutex
					$g_bAndroidAdbPort = $iPort
					$g_bAndroidAdbMinitouchPort = $iMtPort
					ExitLoop
				EndIf
			EndIf
			$iPort += 1 ; try next port
		WEnd
	EndIf
	If $bUsePort And $g_bAndroidAdbPort Then
		SetDebugLog("Using ADB Daemon port " & $g_bAndroidAdbPort)
		$g_sAndroidAdbGlobalOptions = "-P " & $g_bAndroidAdbPort
	Else
		If $g_bAndroidAdbPort Then
			SetDebugLog("Using default ADB Daemon port, minitouch port is " & ($g_bAndroidAdbPort + 1000), $COLOR_ERROR)
		Else
			SetDebugLog("Cannot aquire ADB Daemon port, using default", $COLOR_ERROR)
			$g_bAndroidAdbMinitouchPort = 1111
		EndIf
	EndIf
EndFunc   ;==>InitAndroidAdbPorts

Func InitAndroid($bCheckOnly = False, $bLogChangesOnly = True)
	FuncEnter(InitAndroid)
	If $bCheckOnly = False And $g_bInitAndroid = False Then
		;SetDebugLog("InitAndroid(" & $bCheckOnly & "): " & $g_sAndroidEmulator & " is already initialized");
		Return FuncReturn(True)
	EndIf
	$g_bAndroidInitialized = False
	$g_bInitAndroidActive = True
	Local $aPriorValues = [ _
			$g_sAndroidEmulator _
			, $g_iAndroidConfig _
			, $g_sAndroidVersion _
			, $g_sAndroidInstance _
			, $g_sAndroidTitle _
			, $g_sAndroidProgramPath _
			, GetAndroidProgramParameter() _
			, ((IsArray($g_avAndroidProgramFileVersionInfo) ? _ArrayToString($g_avAndroidProgramFileVersionInfo, ",", 1) : "not available")) _
			, $g_iAndroidSecureFlags _
			, $g_sAndroidAdbPath _
			, $g_sAndroidAdbGlobalOptions _
			, $__VBoxManage_Path _
			, $g_sAndroidAdbDevice _
			, $g_sAndroidPicturesPath _
			, $g_sAndroidPicturesHostPath _
			, $g_sAndroidPicturesHostFolder _
			, $g_sAndroidMouseDevice _
			, $g_bAndroidAdbScreencap _
			, $g_bAndroidAdbInput _
			, $g_bAndroidAdbClick _
			, $g_bAndroidAdbClickDrag _
			, ($g_bChkBackgroundMode = True ? "enabled" : "disabled") _
			, $g_bNoFocusTampering _
			]
	SetDebugLog("InitAndroid(" & $bCheckOnly & "): " & $g_sAndroidEmulator)

	If Not $bCheckOnly Then
		; Check that $g_sAndroidInstance default instance is used for ""
		If $g_sAndroidInstance = "" Then $g_sAndroidInstance = $g_avAndroidAppConfig[$g_iAndroidConfig][1]

		; clear some values for optional vbox calls
		$__VBoxGuestProperties = ""
		$__VBoxExtraData = ""
	EndIf

	; call Android initialization routine
	Local $Result = Execute("Init" & $g_sAndroidEmulator & "(" & $bCheckOnly & ")")
	If $Result = "" And @error <> 0 Then
		; Not implemented
		SetLog("Android support for " & $g_sAndroidEmulator & " is not available", $COLOR_ERROR)
	EndIf

	; Check the Supported Emulator versions
	CheckEmuNewVersions(True) ; Custom - Team AIO Mod++

	Local $successful = @error = 0, $process_killed
	If Not $bCheckOnly And $Result Then

		InitAndroidAdbPorts()
	
		; exclude Android for WerFault reporting
		If $b_sAndroidProgramWerFaultExcluded = True Then
			Local $sFileOnly = StringMid($g_sAndroidProgramPath, StringInStr($g_sAndroidProgramPath, "\", 0, -1) + 1)
			Local $aResult = DllCall("Wer.dll", "int", "WerAddExcludedApplication", "wstr", $sFileOnly, "bool", True)
			If (UBound($aResult) > 0 And $aResult[0] = $S_OK) Or RegWrite($g_sHKLM & "\Software\Microsoft\Windows\Windows Error Reporting\ExcludedApplications", $sFileOnly, "REG_DWORD", "1") = 1 Then
				SetDebugLog("Disabled WerFault for " & $sFileOnly)
			Else
				SetDebugLog("Cannot disable WerFault for " & $sFileOnly)
			EndIf
			Local $sPath = FindPreferredAdbPath() ; Execute("Get" & $g_sAndroidEmulator & "AdbPath()") - Custom Fix - Team__AiO__MOD
			If $sPath Then
				Local $sFileOnly = StringMid($sPath, StringInStr($sPath, "\", 0, -1) + 1)
				Local $aResult = DllCall("Wer.dll", "int", "WerAddExcludedApplication", "wstr", $sFileOnly, "bool", True)
				If (UBound($aResult) > 0 And $aResult[0] = $S_OK) Or RegWrite($g_sHKLM & "\Software\Microsoft\Windows\Windows Error Reporting\ExcludedApplications", $sFileOnly, "REG_DWORD", "1") = 1 Then
					SetDebugLog("Disabled WerFault for " & $sFileOnly)
				Else
					SetDebugLog("Cannot disable WerFault for " & $sFileOnly)
				EndIf
			EndIf
		EndIf
		
		; update Virtualbox properties
		If FileExists($__VBoxManage_Path) Then
			If $__VBoxGuestProperties = "" Then $__VBoxGuestProperties = LaunchConsole($__VBoxManage_Path, "guestproperty enumerate " & $g_sAndroidInstance, $process_killed)
			If $__VBoxExtraData = "" Then $__VBoxExtraData = LaunchConsole($__VBoxManage_Path, "getextradata " & $g_sAndroidInstance & " enumerate", $process_killed)
		EndIf

		UpdateAndroidBackgroundMode()

		; read Android Program Details
		Local $pAndroidFileVersionInfo
		If _WinAPI_GetFileVersionInfo($g_sAndroidProgramPath, $pAndroidFileVersionInfo) Then
			$g_avAndroidProgramFileVersionInfo = _WinAPI_VerQueryValue($pAndroidFileVersionInfo)
		Else
			$g_avAndroidProgramFileVersionInfo = 0
		EndIf

		Local $i = 0
		Local $sText = ""
		If CompareAndUpdate($aPriorValues[IncrUpdate($i)], $g_sAndroidEmulator) Or $bLogChangesOnly = False Then SetDebugLog("Android: " & $g_sAndroidEmulator)
		If CompareAndUpdate($aPriorValues[IncrUpdate($i)], $g_iAndroidConfig) Or $bLogChangesOnly = False Then SetDebugLog("Android Config: " & $g_iAndroidConfig)
		If CompareAndUpdate($aPriorValues[IncrUpdate($i)], $g_sAndroidVersion) Or $bLogChangesOnly = False Then SetDebugLog("Android Version: " & $g_sAndroidVersion)
		If CompareAndUpdate($aPriorValues[IncrUpdate($i)], $g_sAndroidInstance) Or $bLogChangesOnly = False Then SetDebugLog("Android Instance: " & $g_sAndroidInstance)
		If CompareAndUpdate($aPriorValues[IncrUpdate($i)], $g_sAndroidTitle) Or $bLogChangesOnly = False Then SetDebugLog("Android Window Title: " & $g_sAndroidTitle)
		If CompareAndUpdate($aPriorValues[IncrUpdate($i)], $g_sAndroidProgramPath) Or $bLogChangesOnly = False Then SetDebugLog("Android Program Path: " & $g_sAndroidProgramPath)
		If CompareAndUpdate($aPriorValues[IncrUpdate($i)], GetAndroidProgramParameter()) Or $bLogChangesOnly = False Then SetDebugLog("Android Program Parameter: " & GetAndroidProgramParameter())
		$sText = ((IsArray($g_avAndroidProgramFileVersionInfo) ? _ArrayToString($g_avAndroidProgramFileVersionInfo, ",", 1) : "not available"))
		If CompareAndUpdate($aPriorValues[IncrUpdate($i)], $sText) Or $bLogChangesOnly = False Then SetDebugLog("Android Program FileVersionInfo: " & $sText)
		If CompareAndUpdate($aPriorValues[IncrUpdate($i)], $g_iAndroidSecureFlags) Or $bLogChangesOnly = False Then SetDebugLog("Android SecureME setting: " & $g_iAndroidSecureFlags)
		If CompareAndUpdate($aPriorValues[IncrUpdate($i)], $g_sAndroidAdbPath) Or $bLogChangesOnly = False Then SetDebugLog("Android ADB Path: " & $g_sAndroidAdbPath)
		If CompareAndUpdate($aPriorValues[IncrUpdate($i)], $g_sAndroidAdbGlobalOptions) Or $bLogChangesOnly = False Then SetDebugLog("Android ADB Global Options: " & $g_sAndroidAdbGlobalOptions)
		If CompareAndUpdate($aPriorValues[IncrUpdate($i)], $__VBoxManage_Path) Or $bLogChangesOnly = False Then SetDebugLog("Android VBoxManage Path: " & $__VBoxManage_Path)
		If CompareAndUpdate($aPriorValues[IncrUpdate($i)], $g_sAndroidAdbDevice) Or $bLogChangesOnly = False Then SetDebugLog("Android ADB Device: " & $g_sAndroidAdbDevice)
		If CompareAndUpdate($aPriorValues[IncrUpdate($i)], $g_sAndroidPicturesPath) Or $bLogChangesOnly = False Then SetDebugLog("Android ADB Shared Folder: " & $g_sAndroidPicturesPath)
		; check if share folder exists
		If FileExists($g_sAndroidPicturesHostPath) Then
			If ($g_sAndroidPicturesHostFolder <> "" Or BitAND($g_iAndroidSecureFlags, 1) = 1) Then
				DirCreate($g_sAndroidPicturesHostPath & $g_sAndroidPicturesHostFolder)
			EndIf
		ElseIf $g_sAndroidPicturesHostPath <> "" Then
			#cs
			If DirCreate($g_sAndroidPicturesHostPath) Then
				SetLog("Shared Folder doesn't exist and was now created:", $COLOR_ERROR)
				SetLog($g_sAndroidPicturesHostPath, $COLOR_ERROR)
				SetLog("Please restart " & $g_sAndroidEmulator & " instance " & $g_sAndroidInstance, $COLOR_ERROR)
			Else
				SetLog("Shared Folder doesn't exist, please fix:", $COLOR_ERROR)
				SetLog($g_sAndroidPicturesHostPath, $COLOR_ERROR)
			EndIf
			#ce
		EndIf
		If CompareAndUpdate($aPriorValues[IncrUpdate($i)], $g_sAndroidPicturesHostPath) Or $bLogChangesOnly = False Then SetDebugLog("Android ADB Shared Folder on Host: " & $g_sAndroidPicturesHostPath)
		If CompareAndUpdate($aPriorValues[IncrUpdate($i)], $g_sAndroidPicturesHostFolder) Or $bLogChangesOnly = False Then SetDebugLog("Android ADB Shared SubFolder: " & $g_sAndroidPicturesHostFolder)
		If CompareAndUpdate($aPriorValues[IncrUpdate($i)], $g_sAndroidMouseDevice) Or $bLogChangesOnly = False Then SetDebugLog("Android Mouse Device: " & $g_sAndroidMouseDevice)
		If CompareAndUpdate($aPriorValues[IncrUpdate($i)], $g_bAndroidAdbScreencap) Or $bLogChangesOnly = False Then SetDebugLog("Android ADB screencap command enabled: " & $g_bAndroidAdbScreencap)
		If CompareAndUpdate($aPriorValues[IncrUpdate($i)], $g_bAndroidAdbInput) Or $bLogChangesOnly = False Then SetDebugLog("Android ADB input command enabled: " & $g_bAndroidAdbInput)
		If CompareAndUpdate($aPriorValues[IncrUpdate($i)], $g_bAndroidAdbClick) Or $bLogChangesOnly = False Then SetDebugLog("Android ADB Mouse Click enabled: " & $g_bAndroidAdbClick)
		If CompareAndUpdate($aPriorValues[IncrUpdate($i)], $g_bAndroidAdbClickDrag) Or $bLogChangesOnly = False Then SetDebugLog("Android ADB Click Drag enabled: " & $g_bAndroidAdbClickDrag)
		If CompareAndUpdate($aPriorValues[IncrUpdate($i)], ($g_bChkBackgroundMode = True ? "enabled" : "disabled")) Or $bLogChangesOnly = False Then SetDebugLog("Bot Background Mode for screen capture: " & ($g_bChkBackgroundMode = True ? "enabled" : "disabled"))
		If CompareAndUpdate($aPriorValues[IncrUpdate($i)], $g_bNoFocusTampering) Or $bLogChangesOnly = False Then SetDebugLog("No Focus Tampering: " & $g_bNoFocusTampering)
		;$g_hAndroidWindow = WinGetHandle($g_sAndroidTitle) ;Handle for Android window
		WinGetAndroidHandle() ; Set $g_hAndroidWindow and $g_sAndroidTitle for Android window
		InitAndroidTimeLag()
		InitAndroidPageError()
		$g_bInitAndroid = Not $successful
		$g_bAndroidInitialized = True
	Else
		If $bCheckOnly = False Then $g_bInitAndroid = True
	EndIf
	SetDebugLog("InitAndroid(" & $bCheckOnly & "): " & $g_sAndroidEmulator & " END, initialization successful = " & $successful & ", result = " & $Result)
	$g_bInitAndroidActive = False
	Return FuncReturn($Result)
EndFunc   ;==>InitAndroid

Func GetAndroidProgramParameter($bAlternative = False)
	Local $parameter = Execute("Get" & $g_sAndroidEmulator & "ProgramParameter(" & $bAlternative & ")")
	If $parameter = "" And @error <> 0 Then $parameter = "" ; Not implemented
	Return $parameter
EndFunc   ;==>GetAndroidProgramParameter

Func AndroidBotStartEvent()
	; restore Android Window hidden state
	reHide()

	CheckAndroidRebootCondition(True, True) ; Log when Android gets automatically rebooted

	Local $Result = Execute($g_sAndroidEmulator & "BotStartEvent()")
	If $Result = "" And @error <> 0 Then $Result = "" ; Not implemented
	Return $Result
EndFunc   ;==>AndroidBotStartEvent

Func AndroidBotStopEvent()
	Local $Result = Execute($g_sAndroidEmulator & "BotStopEvent()")
	If $Result = "" And @error <> 0 Then $Result = "" ; Not implemented
	Return $Result
EndFunc   ;==>AndroidBotStopEvent

Func OpenAndroid($bRestart = False, $bStartOnlyAndroid = False, $wasRunState = $g_bRunState)
	FuncEnter(OpenAndroid)
	Static $OpenAndroidActive = 0

	If $OpenAndroidActive >= $g_iOpenAndroidActiveMaxTry Then
		SetLog("Cannot open " & $g_sAndroidEmulator & ", tried " & $OpenAndroidActive & " times...", $COLOR_ERROR)
		btnStop()
		Return FuncReturn(False)
	EndIf
	$OpenAndroidActive += 1
	If $OpenAndroidActive > 1 Then
		SetDebugLog("Opening " & $g_sAndroidEmulator & " recursively " & $OpenAndroidActive & ". time...")
	EndIf
	If $bStartOnlyAndroid = True And $wasRunState = False Then $g_bRunState = True
	Local $Result = _OpenAndroid($bRestart, $bStartOnlyAndroid)
	If $bStartOnlyAndroid = True And $wasRunState = False Then $g_bRunState = False
	WinGetAndroidHandle()
	$OpenAndroidActive -= 1
	Return FuncReturn($Result)
EndFunc   ;==>OpenAndroid

; Custom - Team AIO Mod++
Func _OpenAndroid($bRestart = False, $bStartOnlyAndroid = False)
	If StringIsSpace($g_sAndroidAdbPath) = 0 Then
		ResumeAndroid()
		
		; list Android devices to ensure ADB Daemon is launched
		Local $hMutex = AquireAdbDaemonMutex(), $process_killed
		LaunchConsole($g_sAndroidAdbPath, AddSpace($g_sAndroidAdbGlobalOptions) & "devices", $process_killed)
		ReleaseAdbDaemonMutex($hMutex)
	EndIf
	
	If Not InitAndroid() Then
		SetLog("Unable to open " & $g_sAndroidEmulator & ($g_sAndroidInstance = "" ? "" : " instance '" & $g_sAndroidInstance & "'"), $COLOR_ERROR)
		SetLog("Please check emulator/installation", $COLOR_ERROR)
		SetLog("To switch to another emualtor, please use bot with command line parameter", $COLOR_BLUE)
		SetLog("Unable to continue........", $COLOR_ERROR)
		btnStop()
		SetError(1, 1, -1)
		Return False
	EndIf

	If StringIsSpace($g_sAndroidAdbPath) = 0 Then
		ResumeAndroid()
		
		; list Android devices to ensure ADB Daemon is launched
		Local $hMutex = AquireAdbDaemonMutex(), $process_killed
		LaunchConsole($g_sAndroidAdbPath, AddSpace($g_sAndroidAdbGlobalOptions) & "devices", $process_killed)
		ReleaseAdbDaemonMutex($hMutex)
	EndIf

	AndroidAdbTerminateShellInstance()
	If Not $g_bRunState Then Return False

	; Close any existing WerFault windows for this emulator
	WerFaultClose($g_sAndroidProgramPath)

	; Close crashed android when $g_bAndroidBackgroundLaunch = False
	If $g_bAndroidBackgroundLaunch = False And WinGetAndroidHandle(Default, True) <> 0 Or GetAndroidSvcPid() <> 0 Then
		CloseAndroid("_OpenAndroid")
		If _Sleep(1000) Then Return False
	EndIf

	InitAndroidRebootCondition(False)
	If Not Execute("Open" & $g_sAndroidEmulator & "(" & $bRestart & ")") Then Return False

	InitAndroidRebootCondition(True) ; Android should be running now

	; ensure adb shell is initialized
	AndroidAdbLaunchShellInstance(Default, False)

	; flag always restart to exit any current methods
	$g_bRestart = True
	$g_bIsClientSyncError = False

	If $bStartOnlyAndroid Then
		Return True
	EndIf

	; Check Android screen size, position windows
	If Not InitiateLayout() Then Return False ; recursive call to OpenAndroid() possible

	WinGetAndroidHandle(False) ; get window Handle

	If Not $g_bRunState Then Return False
	; Better create a func AndroidCoCStartEvent
	AndroidBotStartEvent()

	If Not $g_bRunState Then Return False

	If $bRestart = False Then
		; Press home button to start default launcher (e.g. for BS 4 with Nova Launcher)
		AndroidHomeButton()
	
		If _Sleep(3000) Then Return False ; wait 3 seconds or delayed home button execution "kill" games (maybe more seconds required?)
	
		If Not $g_bRunState Then Return False
	EndIf

	; Launch CcC
	If Not StartAndroidCoC() Then Return False

	If $bRestart = False Then
		waitMainScreenMini()
		If Not $g_bRunState Then Return False
		Zoomout()
	Else
		WaitMainScreenMini()
		If Not $g_bRunState Then Return False
		If @error = 1 Then
			Return False
		EndIf
		Zoomout()
	EndIf

	If Not $g_bRunState Then Return False
	Return True
EndFunc   ;==>_OpenAndroid

Func StartAndroidCoC()
	FuncEnter(StartAndroidCoC)
	Return FuncReturn(RestartAndroidCoC(False, False, False))
EndFunc   ;==>StartAndroidCoC

Func RestartAndroidCoC($bInitAndroid = True, $bRestart = True, $bStopCoC = True, $iRetry = 0)
	Static $iRecursive = -1
	FuncEnter(RestartAndroidCoC)
	$iRecursive += 1
	Local $Result = _RestartAndroidCoC($bInitAndroid, $bRestart, $bStopCoC, $iRetry, $iRecursive)
	$iRecursive -= 1
	Return FuncReturn()
EndFunc   ;==>RestartAndroidCoC

Func _RestartAndroidCoC($bInitAndroid = True, $bRestart = True, $bStopCoC = True, $iRetry = 0, $iRecursive = 0)
	ClearClicks() ; it can happen the clicks are hold back, ensure it's cleared
	$g_bSkipFirstZoomout = False
	ResumeAndroid()
	If Not $g_bRunState Then Return False

	If $bInitAndroid Then
		If Not InitAndroid() Then Return False
	EndIf

	Local $cmdOutput, $process_killed, $connected_to

	; Test ADB is connected
	;$cmdOutput = LaunchConsole($g_sAndroidAdbPath, "connect " & $g_sAndroidAdbDevice, $process_killed)
	;$connected_to = StringInStr($cmdOutput, "connected to")

	ResetAndroidProcess()
	Local $sRestart = ""
	If $bRestart = True Then
		If $bStopCoC Then
			SetLog("Please wait for CoC restart.....", $COLOR_INFO) ; Let user know we need time...
			$sRestart = "-S "
		Else
			SetLog("Please wait for CoC restart....", $COLOR_INFO) ; Let user know we need time...
		EndIf
	Else
		SetLog("Launch Clash of Clans now...", $COLOR_SUCCESS)
	EndIf
	ConnectAndroidAdb()
	If Not $g_bRunState Then Return False
	;AndroidAdbTerminateShellInstance()
	If Not $g_bRunState Then Return False
	;$cmdOutput = LaunchConsole($g_sAndroidAdbPath, "-s " & $g_sAndroidAdbDevice & " shell am start " & $sRestart & "-n " & $g_sAndroidGamePackage & "/" & $g_sAndroidGameClass, $process_killed, 30 * 1000) ; removed "-W" option and added timeout (didn't exit sometimes)
	If ((ProfileSwitchAccountEnabled() And $g_bChkSharedPrefs) Or $g_bUpdateSharedPrefs) And HaveSharedPrefs() And _
			($g_bUpdateSharedPrefs Or $g_PushedSharedPrefsProfile <> $g_sProfileCurrentName Or ($g_PushedSharedPrefsProfile_Timer = 0 Or __TimerDiff($g_PushedSharedPrefsProfile_Timer) > 120000)) Then PushSharedPrefs()

	$cmdOutput = AndroidAdbSendShellCommand("set export=$(am start " & $sRestart & "-n " & $g_sAndroidGamePackage & "/" & $g_sAndroidGameClass & " >&2)", 15000) ; timeout of 15 Seconds
	If StringInStr($cmdOutput, "Error:") > 0 And StringInStr($cmdOutput, $g_sAndroidGamePackage) > 0 Then
		SetLog("Unable to load Clash of Clans, install/reinstall the game.", $COLOR_ERROR)
		SetLog("Unable to continue........", $COLOR_ERROR)
		btnStop()
		SetError(1, 1, -1)
		Return False
	EndIf
	If StringInStr($cmdOutput, "Exception") > 0 Then
		; some other strange, unexpected error, restart Android
		If Not RebootAndroid() Then Return False
	EndIf

	If Not IsAdbConnected($cmdOutput) Then
		If Not ConnectAndroidAdb() Then Return False
	EndIf

	If Not $g_bRunState Then Return False
	AndroidAdbLaunchShellInstance()

	; reset time lag
	InitAndroidTimeLag()

	; wait 3 sec. CoC might have just crashed
	If _SleepStatus(3000) Then Return False

	If GetAndroidProcessPID(Default, False) = 0 And @error = 0 Then
		If $iRetry > 2 And $iRecursive > 2 Then
			SetLog("Unable to load Clash of Clans ! ! !", $COLOR_ERROR)
			SetLog("Please check Clash of Clans and Android installation.", $COLOR_ERROR)
			SetLog("Reinstalling Clash of Clans or Android might fix the problem.", $COLOR_ERROR)
			SetLog("Unable to continue........", $COLOR_ERROR)
			btnStop()
			SetError(1, 1, -1)
			Return False
		Else
			If $iRetry > 2 Then
				; restart Android, enter recursion...
				SetLog("Unable to load Clash of Clans, close Android and retry...", $COLOR_ERROR)
				CloseAndroid("_RestartAndroidCoC")
				Return OpenAndroid(True)
			EndIf
			$iRetry += 1
			SetLog("Unable to load Clash of Clans, " & $iRetry & ". retry...", $COLOR_ERROR)
			If $iRetry = 2 And $iRecursive = 0 And HaveSharedPrefs() Then
				; crash might get fixed by clearing cache
				$cmdOutput = AndroidAdbSendShellCommand("set export=$(pm clear " & $g_sAndroidGamePackage & " >&2)", 15000) ; timeout of 15 Seconds
				If StringInStr($cmdOutput, "Success") Then
					SetLog("Clash of Clans cache now cleared", $COLOR_SUCCESS)
				Else
					SetLog("Clash of Clans cache not cleared: " & $cmdOutput, $COLOR_ERROR)
				EndIf
			EndIf
			If _SleepStatus(5000) Then Return False
			Return _RestartAndroidCoC($bInitAndroid, $bRestart, $bStopCoC, $iRetry, $iRecursive)
		EndIf
	EndIf

	Return True
EndFunc   ;==>_RestartAndroidCoC

; Reset variables that track running CoC App
Func ResetAndroidProcess()
	$g_iAndroidCoCPid = 0
	$g_bMainWindowOk = False
EndFunc   ;==>ResetAndroidProcess

Func CloseAndroid($sSource)
	FuncEnter(CloseAndroid)
	ResumeAndroid()

	ResetAndroidProcess()

	SetLog("Stopping " & $g_sAndroidEmulator & "....", $COLOR_INFO)
	SetDebugLog("CloseAndroid, caller: " & $sSource)

	; Un-dock Android
	AndroidEmbed(False)

	AndroidAdbTerminateShellInstance()

	If Not $g_bRunState Then Return FuncReturn(False)

	SetLog("Please wait for full " & $g_sAndroidEmulator & " shutdown...", $COLOR_SUCCESS)
	Local $pid = GetAndroidPid()
	If ProcessExists2($pid) Then
		KillProcess($pid, "CloseAndroid")
		If _SleepStatus(1000) Then Return FuncReturn(False)
	EndIf

	; Call special Android close
	Local $Result = Execute("Close" & $g_sAndroidEmulator & "()")

	If Not $g_bRunState Then Return FuncReturn(False)
	If ProcessExists($pid) Then
		SetLog("Failed to stop " & $g_sAndroidEmulator, $COLOR_ERROR)
	Else
		SetLog($g_sAndroidEmulator & " stopped successfully", $COLOR_SUCCESS)
	EndIf

	If Not $g_bRunState Then Return FuncReturn(False)
	RemoveGhostTrayIcons() ; Remove ghost icon if left behind
	Return FuncReturn(True)
EndFunc   ;==>CloseAndroid

Func CloseVboxAndroidSvc()
	Local $process_killed
	If Not $g_bRunState Then Return
	; stop virtualbox instance
	LaunchConsole($__VBoxManage_Path, "controlvm " & $g_sAndroidInstance & " poweroff", $process_killed, 30000)
	If _SleepStatus(3000) Then Return
EndFunc   ;==>CloseVboxAndroidSvc

Func CheckAndroidRunning($bQuickCheck = True, $bStartIfRequired = True, $bStartOnlyAndroid = False)
	FuncEnter(CheckAndroidRunning)
	Local $hWin = $g_hAndroidWindow
	If WinGetAndroidHandle() = 0 Or ($bQuickCheck = False And $g_bAndroidBackgroundLaunched = False And AndroidControlAvailable() = 0) Then
		SetDebugLog($g_sAndroidEmulator & " not running")
		If $bStartIfRequired = True Then
			If $hWin = 0 Then
				OpenAndroid(True, $bStartOnlyAndroid)
			Else
				RebootAndroid()
			EndIf
		EndIf
		Return FuncReturn(False)
	EndIf
	Return FuncReturn(True)
EndFunc   ;==>CheckAndroidRunning

Func SetScreenAndroid()
	ResumeAndroid()
	If Not $g_bRunState Then Return False
	; Set Android screen size and dpi
	SetLog("Set " & $g_sAndroidEmulator & " screen resolution to " & $g_iAndroidClientWidth & " x " & $g_iAndroidClientHeight, $COLOR_INFO)
	Local $Result = Execute("SetScreen" & $g_sAndroidEmulator & "()")
	If $Result Then
		SetLog("A restart of your computer might be required", $COLOR_ACTION)
		SetLog("for the applied changes to take effect.", $COLOR_ACTION)
	EndIf
	Return $Result
EndFunc   ;==>SetScreenAndroid

Func CloseUnsupportedAndroid()
	ResumeAndroid()
	If Not $g_bRunState Then Return False
	SetError(0, 0, 0)
	Local $Closed = Execute("CloseUnsupported" & $g_sAndroidEmulator & "()")
	If $Closed = "" And @error <> 0 Then Return False ; Not implemented
	Return $Closed
EndFunc   ;==>CloseUnsupportedAndroid

Func RebootAndroidSetScreen()
	ResumeAndroid()
	If Not $g_bRunState Then Return False
	Return Execute("Reboot" & $g_sAndroidEmulator & "SetScreen()")
EndFunc   ;==>RebootAndroidSetScreen

Func IsAdbTCP()
	Return StringInStr($g_sAndroidAdbDevice, ":") > 0
EndFunc   ;==>IsAdbTCP

Func WaitForRunningVMS($WaitInSec = 120, $hTimer = 0)
	ResumeAndroid()
	If Not $g_bRunState Then Return True
	Local $cmdOutput, $connected_to, $running, $process_killed, $hMyTimer
	$hMyTimer = ($hTimer = 0 ? __TimerInit() : $hTimer)
	While True
		If Not $g_bRunState Then Return True
		$cmdOutput = LaunchConsole($__VBoxManage_Path, "list runningvms", $process_killed)
		If Not $g_bRunState Then Return True
		$running = StringInStr($cmdOutput, """" & $g_sAndroidInstance & """") > 0
		If $running = True Then ExitLoop
		If $hTimer <> 0 Then _StatusUpdateTime($hTimer)
		_Sleep(3000) ; Sleep 3 Seconds
		If __TimerDiff($hMyTimer) > $WaitInSec * 1000 Then ; if no device available in 4 minutes, Android/PC has major issue so exit
			SetLog("Serious error has occurred, please restart PC and try again", $COLOR_ERROR)
			SetLog($g_sAndroidEmulator & " refuses to load, waited " & Round(__TimerDiff($hTimer) / 1000, 2) & " seconds for boot completed", $COLOR_ERROR)
			SetError(1, @extended, False)
			Return True
		EndIf
	WEnd
	Return False
EndFunc   ;==>WaitForRunningVMS

Func FindAvaiableInstances($sVboxManage = $__VBoxManage_Path)
	Local $a = []
	If FileExists($sVboxManage) = 0 Then
		If $g_bDebugAndroid Then SetDebugLog("Cannot check for available " & $g_sAndroidEmulator & " instances: VBoxManager.exe not available", $COLOR_ERROR)
		Return $a
	EndIf
	ResumeAndroid()
	Local $cmdOutput, $connected_to, $running, $process_killed, $hMyTimer
	$cmdOutput = LaunchConsole($sVboxManage, "list vms", $process_killed)
	If $g_bDebugAndroid Then SetDebugLog("Available " & $g_sAndroidEmulator & " instances: " & $cmdOutput, $COLOR_ERROR)
	$a = StringRegExp($cmdOutput, """(.*?)""", $STR_REGEXPARRAYGLOBALMATCH)
	If @error Then Local $a = []
	Return $a
EndFunc   ;==>FindAvaiableInstances

Func GetAndroidVMinfo(ByRef $sVMinfo, $sVboxManage = $__VBoxManage_Path)
	Local $process_killed
	Local $as_Instances
	$sVMinfo = LaunchConsole($sVboxManage, "showvminfo " & $g_sAndroidInstance, $process_killed)
	; check if instance is known
	If StringInStr($sVMinfo, "Could not find a registered machine named") > 0 Then
		$as_Instances = FindAvaiableInstances($sVboxManage)
		For $s In $as_Instances
			If StringCompare($g_sAndroidInstance, $s, $STR_NOCASESENSE) = 0 Then
				SetDebugLog("Using " & $g_sAndroidEmulator & " instance " & $s & " (" & $g_sAndroidInstance & " not found!)", $COLOR_ERROR)
				$g_sAndroidInstance = $s
				$sVMinfo = LaunchConsole($sVboxManage, "showvminfo " & $g_sAndroidInstance, $process_killed)
				ExitLoop
			EndIf
		Next
	EndIf

	If StringInStr($sVMinfo, "Could not find a registered machine named") > 0 Then
		; Unknown vm
		SetLog("Cannot find " & $g_sAndroidEmulator & " instance " & $g_sAndroidInstance, $COLOR_ERROR)
		If UBound($as_Instances) = 0 Then
			SetLog("No " & $g_sAndroidEmulator & " instance found, please check installation", $COLOR_ERROR)
		Else
			SetLog("Available " & $g_sAndroidEmulator & " instances are:", $COLOR_ERROR)
			For $s In $as_Instances
				SetLog($s, $COLOR_ERROR)
			Next
		EndIf
		Return False
	EndIf
	Return True
EndFunc   ;==>GetAndroidVMinfo

Func WaitForAndroidBootCompleted($WaitInSec = 120, $hTimer = 0)
	ResumeAndroid()
	If Not $g_bRunState Then Return True
	Local $cmdOutput, $connected_to, $booted, $process_killed, $hMyTimer
	; Wait for boot completed
	$hMyTimer = ($hTimer = 0 ? __TimerInit() : $hTimer)
	While True
		If Not $g_bRunState Then Return True
		$cmdOutput = LaunchConsole($g_sAndroidAdbPath, AddSpace($g_sAndroidAdbGlobalOptions) & "-s " & $g_sAndroidAdbDevice & " shell" & $g_sAndroidAdbShellOptions & " getprop sys.boot_completed", $process_killed)
		If InvalidAdbShellOptions($cmdOutput, "WaitForAndroidBootCompleted") Then
			$cmdOutput = LaunchConsole($g_sAndroidAdbPath, AddSpace($g_sAndroidAdbGlobalOptions) & "-s " & $g_sAndroidAdbDevice & " shell" & $g_sAndroidAdbShellOptions & " getprop sys.boot_completed", $process_killed)
		EndIf
		If Not $g_bRunState Then Return True
		; Test ADB is connected
		$connected_to = IsAdbConnected($cmdOutput)
		If Not $g_bRunState Then Return True
		If Not $connected_to Then ConnectAndroidAdb(False)
		If Not $g_bRunState Then Return True
		$booted = StringLeft($cmdOutput, 1) = "1"
		If $booted = True Then ExitLoop
		If $hTimer <> 0 Then _StatusUpdateTime($hTimer)
		If _Sleep(5000) Then Return True ; Sleep 5 Seconds
		If __TimerDiff($hMyTimer) > $WaitInSec * 1000 Then ; if no device available in 4 minutes, Android/PC has major issue so exit
			SetLog("Serious error has occurred, please restart PC and try again", $COLOR_ERROR)
			SetLog($g_sAndroidEmulator & " refuses to load, waited " & Round(__TimerDiff($hTimer) / 1000, 2) & " seconds for boot completed", $COLOR_ERROR)
			SetError(1, @extended, False)
			Return True
		EndIf
	WEnd
	Return False
EndFunc   ;==>WaitForAndroidBootCompleted

; 2018-03-17 cosote Added "error: closed" when MEmu is unusable
Func IsAdbConnected($cmdOutput = Default)
	ResumeAndroid()
	If $__TEST_ERROR_ADB_DEVICE_NOT_FOUND Then Return False
	Local $process_killed, $connected_to
	If $cmdOutput = Default Then
		If IsAdbTCP() Then
			$cmdOutput = LaunchConsole($g_sAndroidAdbPath, AddSpace($g_sAndroidAdbGlobalOptions) & "connect " & $g_sAndroidAdbDevice, $process_killed)
			$connected_to = StringInStr($cmdOutput, "connected to") > 0
			If $connected_to Then
				; also check whoami
				$cmdOutput = LaunchConsole($g_sAndroidAdbPath, AddSpace($g_sAndroidAdbGlobalOptions) & "-s " & $g_sAndroidAdbDevice & " shell" & $g_sAndroidAdbShellOptions & " echo $USER:$USER_ID", $process_killed)
				$connected_to = StringInStr($cmdOutput, " not ") = 0 And StringInStr($cmdOutput, "unable") = 0 And StringInStr($cmdOutput, "error: ") = 0 And StringInStr($cmdOutput, "device ") = 0 And $process_killed = False
			EndIf
		Else
			$cmdOutput = LaunchConsole($g_sAndroidAdbPath, AddSpace($g_sAndroidAdbGlobalOptions) & "-s " & $g_sAndroidAdbDevice & " shell" & $g_sAndroidAdbShellOptions & " echo $USER:$USER_ID", $process_killed)
			$connected_to = StringInStr($cmdOutput, " not ") = 0 And StringInStr($cmdOutput, "unable") = 0 And StringInStr($cmdOutput, "error: ") = 0 And $process_killed = False
		EndIf
		; check for /data/anr/../../system/xbin/bstk/su: not found
		If Not $connected_to And InvalidAdbShellOptions($cmdOutput, "IsAdbConnected") Then
			Return IsAdbConnected()
		EndIf
	Else
		; $cmdOutput was specified
		$connected_to = StringInStr($cmdOutput, " not ") = 0 And StringInStr($cmdOutput, "unable") = 0 And StringInStr($cmdOutput, "error: ") = 0
	EndIf
	Return $connected_to
EndFunc   ;==>IsAdbConnected

Func AquireAdbDaemonMutex($timout = 30000)
	Local $timer = __TimerInit()
	Local $g_hMutex_MyBot = 0
	While $g_hMutex_MyBot = 0 And __TimerDiff($timer) < $timout
		$g_hMutex_MyBot = CreateMutex("MyBot.run/AdbDaemonLaunch" & $g_sAndroidAdbGlobalOptions)
		If $g_hMutex_MyBot <> 0 Then ExitLoop
		If _Sleep(250) Then ExitLoop
	WEnd
	Return $g_hMutex_MyBot
EndFunc   ;==>AquireAdbDaemonMutex

Func ReleaseAdbDaemonMutex($hMutex, $ReturnValue = Default)
	Return ReleaseMutex($hMutex, $ReturnValue)
EndFunc   ;==>ReleaseAdbDaemonMutex

Func KillAdbDaemon($bMutexLock = True)
	Local $hMutex = -1
	If $bMutexLock Then $hMutex = AquireAdbDaemonMutex()
	If $hMutex = 0 Then
		SetDebugLog("Cannot acquire ADB mutex to kill daemon", $COLOR_ERROR)
		Return False
	EndIf
	SetDebugLog("Stop ADB daemon!", $COLOR_ERROR)
	Local $process_killed
	LaunchConsole($g_sAndroidAdbPath, AddSpace($g_sAndroidAdbGlobalOptions) & "kill-server", $process_killed)
	Local $sPort = ""
	If $g_bAndroidAdbPort Then $sPort = String($g_bAndroidAdbPort)
	Local $pids = ProcessesExist($g_sAndroidAdbPath, $sPort, 1, 1)
	For $i = 0 To UBound($pids) - 1
		KillProcess($pids[$i], $g_sAndroidAdbPath)
	Next
	Return ReleaseAdbDaemonMutex($hMutex, True)
EndFunc   ;==>KillAdbDaemon

Func ConnectAndroidAdb($rebootAndroidIfNeccessary = $g_bRunState, $bStartOnlyAndroid = False, $timeout = 15000)
	FuncEnter(ConnectAndroidAdb)
	Return FuncReturn(_ConnectAndroidAdb($rebootAndroidIfNeccessary, $bStartOnlyAndroid, $timeout))
EndFunc   ;==>ConnectAndroidAdb

Func _ConnectAndroidAdb($rebootAndroidIfNeccessary = $g_bRunState, $bStartOnlyAndroid = False, $timeout = 15000)
	If $g_sAndroidAdbPath = "" Or FileExists($g_sAndroidAdbPath) = 0 Then
		SetLog($g_sAndroidEmulator & " ADB Path not valid: " & $g_sAndroidAdbPath, $COLOR_ERROR)
		Return 0
	EndIf
	ResumeAndroid()
	Local $bRebooted = False

	; check if Android is running
	If $rebootAndroidIfNeccessary = True Then
		WinGetAndroidHandle()
		If AndroidInvalidState() Then
			; Android is not running
			SetDebugLog("ConnectAndroidAdb: Reboot Android as it's not running")
			$bRebooted = RebootAndroid(True, $bStartOnlyAndroid)
		EndIf
	EndIf

	Local $hMutex = AquireAdbDaemonMutex()

	Local $process_killed, $cmdOutput
	Local $connected_to = False
	Local $timer = __TimerInit()
	Local $timerReInit = $timer
	While __TimerDiff($timer) < $timeout ; wait max 15 Seconds before killing ADB daemon
		$connected_to = IsAdbConnected()
		If $connected_to Then Return ReleaseAdbDaemonMutex($hMutex, 1) ; all good, adb is connected
		Local $ms = $timeout - __TimerDiff($timer)
		If $ms > 3000 Then $ms = 3000
		If _Sleep($ms) Then Return ReleaseAdbDaemonMutex($hMutex, 0) ; True ; interrupted and return True not to start any failback logic
		If __TimerDiff($timerReInit) >= 10000 Then
			$timerReInit = __TimerInit()
			$g_bInitAndroid = True ; Re-Initialize Android as during start running config might have changed
			InitAndroid()
		EndIf
	WEnd

	Switch $g_iAndroidRecoverStrategy
		Case 0
			; not connected... strange, kill any Adb now
			KillAdbDaemon(False)

			; ok, now try to connect again
			$connected_to = IsAdbConnected()
			ReleaseAdbDaemonMutex($hMutex)

			If Not $connected_to And $g_bRunState = True And $rebootAndroidIfNeccessary = True Then
				; not good, what to do now? Reboot Android...
				SetLog("ADB cannot connect to " & $g_sAndroidEmulator & ", restart emulator now...", $COLOR_ERROR)
				$bRebooted = RebootAndroid()
				If Not $bRebooted Then Return 0
				; ok, last try
				$connected_to = ConnectAndroidAdb(False, $bStartOnlyAndroid)
				If Not $connected_to Then
					; Let's give up...
					If Not $g_bRunState Then Return 0 ; True ; interrupted and return True not to start any failback logic
					SetLog("ADB really cannot connect to " & $g_sAndroidEmulator & "!", $COLOR_ERROR)
					SetLog("Please restart bot, emulator and/or PC...", $COLOR_ERROR)
				EndIf
			EndIf
		Case 1
			ReleaseAdbDaemonMutex($hMutex)
			If $rebootAndroidIfNeccessary Then
				SetDebugLog("ConnectAndroidAdb: Reboot Android due to ADB connection problems...", $COLOR_ERROR)
				$bRebooted = RebootAndroid()
				If Not $bRebooted Then Return 0
			Else
				SetDebugLog("ConnectAndroidAdb: Reboot Android nor ADB Daemon not allowed", $COLOR_ERROR)
				Return 0
			EndIf

			; ok, now try to connect again
			$connected_to = IsAdbConnected()

			If Not $connected_to Then
				; not connected... strange, kill any Adb now
				SetDebugLog("Stop ADB daemon!", $COLOR_ERROR)
				LaunchConsole($g_sAndroidAdbPath, AddSpace($g_sAndroidAdbGlobalOptions) & "kill-server", $process_killed)
				Local $sPort = ""
				If $g_bAndroidAdbPort Then $sPort = String($g_bAndroidAdbPort)
				Local $pids = ProcessesExist($g_sAndroidAdbPath, $sPort, 1, 1)
				For $i = 0 To UBound($pids) - 1
					KillProcess($pids[$i], $g_sAndroidAdbPath)
				Next

				; ok, last try
				$connected_to = ConnectAndroidAdb(False, $bStartOnlyAndroid)
				If Not $connected_to Then
					; Let's give up...
					If Not $g_bRunState Then Return 0 ; True ; interrupted and return True not to start any failback logic
					SetLog("ADB really cannot connect to " & $g_sAndroidEmulator & "!", $COLOR_ERROR)
					SetLog("Please restart bot, emulator and/or PC...", $COLOR_ERROR)
				EndIf
			EndIf
	EndSwitch

	Return (($connected_to) ? (($bRebooted) ? (2) : (1)) : (0)) ; ADB is connected or not
EndFunc   ;==>_ConnectAndroidAdb

Func RebootAndroid($bRestart = True, $bStartOnlyAndroid = False)
	FuncEnter(RebootAndroid)
	ResumeAndroid()
	If Not $g_bRunState Then Return FuncReturn(False)

	; Close Android
	If CloseUnsupportedAndroid() Then
		; Unsupport Emulator now closed, screen config is now adjusted
	Else
		; Close Emulator
		CloseAndroid("RebootAndroid")
	EndIf
	If _Sleep(1000) Then Return FuncReturn(False)

	; Start Android
	Return FuncReturn(OpenAndroid($bRestart, $bStartOnlyAndroid))
EndFunc   ;==>RebootAndroid

Func RebootAndroidSetScreenDefault()
	ResumeAndroid()
	If Not $g_bRunState Then Return False

	; Set font size to normal
	AndroidSetFontSizeNormal()
	If Not $g_bRunState Then Return False

	; Close Android
	CloseAndroid("RebootAndroidSetScreenDefault")
	If _Sleep(1000) Then Return False

	SetScreenAndroid()
	If Not $g_bRunState Then Return False

	; Start Android
	Return OpenAndroid(True)

EndFunc   ;==>RebootAndroidSetScreenDefault

Func CheckScreenAndroid($ClientWidth, $ClientHeight, $bSetLog = True)
	ResumeAndroid()
	If Not $g_bRunState Then Return True

	Local $AndroidWinPos = WinGetPos($g_hAndroidWindow)
	If IsArray($AndroidWinPos) = 1 Then
		Local $WinWidth = $AndroidWinPos[2]
		Local $WinHeight = $AndroidWinPos[3]
		If $WinWidth <> $g_iAndroidWindowWidth Or $WinHeight <> $g_iAndroidWindowHeight Then
			SetDebugLog("CheckScreenAndroid: Window size " & $WinWidth & " x " & $WinHeight & " <> " & $g_iAndroidWindowWidth & " x " & $g_iAndroidWindowHeight, $COLOR_ERROR)
		Else
			SetDebugLog("CheckScreenAndroid: Window size " & $WinWidth & " x " & $WinHeight)
		EndIf
	EndIf

	Local $ok = ($ClientWidth = $g_iAndroidClientWidth) And ($ClientHeight = $g_iAndroidClientHeight)
	If Not $ok Then
		If $bSetLog Then SetLog("MyBot doesn't work with " & $g_sAndroidEmulator & " screen resolution of " & $ClientWidth & " x " & $ClientHeight & "!", $COLOR_ERROR)
		SetDebugLog("CheckScreenAndroid: " & $ClientWidth & " x " & $ClientHeight & " <> " & $g_iAndroidClientWidth & " x " & $g_iAndroidClientHeight)
		Return False
	EndIf

	; check emulator specific setting
	SetError(0, 0, 0)
	$ok = Execute("CheckScreen" & $g_sAndroidEmulator & "(" & $bSetLog & ")")
	If $ok = "" And @error <> 0 Then
		; Not implemented
		$ok = True
	EndIf

	If Not $ok Then
		If $bSetLog Then SetLog($g_sAndroidEmulator & " misses required configuration!", $COLOR_ERROR)
		Return False
	EndIf

	AndroidAdbLaunchShellInstance()
	If Not $g_bRunState Then Return True

	; check display font size
	Local $s_font_scale = AndroidAdbSendShellCommand("settings get system font_scale")
	Local $font_scale = Number($s_font_scale)
	If $font_scale > 0 Then
		SetDebugLog($g_sAndroidEmulator & " font_scale = " & $font_scale)
		If $font_scale <> 1 Then
			SetLog("MyBot doesn't work with Display Font Scale of " & $font_scale, $COLOR_ERROR)
			Return False
		EndIf
	Else
		Switch $g_sAndroidEmulator
			Case "BlueStacks", "BlueStacks2" ; BlueStacks doesn't support it
			Case Else
				SetDebugLog($g_sAndroidEmulator & " Display Font Scale cannot be verified", $COLOR_ERROR)
		EndSwitch
	EndIf

	Return $ok

EndFunc   ;==>CheckScreenAndroid

Func AndroidSetFontSizeNormal()
	ResumeAndroid()
	AndroidAdbLaunchShellInstance($g_bRunState, False)
	SetLog("Set " & $g_sAndroidEmulator & " Display Font Scale to normal", $COLOR_INFO)
	AndroidAdbSendShellCommand("settings put system font_scale 1.0", Default, Default, False)
EndFunc   ;==>AndroidSetFontSizeNormal

Func AndroidInitPrompt()
	If Not $g_bAndroidAdbInstance Then Return
	Local $bIdentified = False
	Local $s
	Sleep(250)
	AndroidAdbSendShellCommand("", -250, Default, False, False) ; just send enter to clear any incomplete entered command (required for BlueStacks N)
	AndroidAdbSendShellCommand("", -250, Default, False, False) ; just send enter again to clear any incomplete entered command (required for BlueStacks N)
	If $g_bAndroidAdbPromptUseGiven Then
		$s = AndroidAdbSendShellCommand("", -500, Default, False, False)
		If $s Then
			; assume this is the prompt
			$g_sAndroidAdbPrompt = StringStripWS($s, $STR_STRIPLEADING)
			SetDebugLog("Initialize shell prompt with '" & $g_sAndroidAdbPrompt & "'")
			$bIdentified = True
		Else
			SetDebugLog("ADB Prompt not identified!", $COLOR_ERROR)
			SetDebugLog("ADB Result: " & $s, $COLOR_ERROR)
		EndIf
	EndIf
	If Not $bIdentified Then
		SetDebugLog("Initialize shell prompt with '" & $g_sAndroidAdbPrompt & "'")
		$s = AndroidAdbSendShellCommand("export PS1=" & $g_sAndroidAdbPrompt, -500, Default, False) ; set prompt to unique string $g_sAndroidAdbPrompt
	EndIf
	Return $s
EndFunc   ;==>AndroidInitPrompt

Func AndroidAdbLaunchShellInstance($wasRunState = Default, $rebootAndroidIfNeccessary = $g_bRunState)
	Static $bAndroidAdbLaunchShellInstanceActive = False
	Local $bWasActive = $bAndroidAdbLaunchShellInstanceActive
	;If $bWasActive Then Return
	FuncEnter(AndroidAdbLaunchShellInstance)
	$bAndroidAdbLaunchShellInstanceActive = True
	Local $Result = _AndroidAdbLaunchShellInstance($wasRunState, (($bWasActive) ? (False) : ($rebootAndroidIfNeccessary)))
	Local $err = @error
	If $err Then
		; ensure adb is terminated on error
		AndroidAdbTerminateShellInstance()
	EndIf
	$bAndroidAdbLaunchShellInstanceActive = $bWasActive
	Return FuncReturn(SetError($err, 0, $Result))
EndFunc   ;==>AndroidAdbLaunchShellInstance

; Custom - Team AIO Mod++
Func _AndroidAdbLaunchShellInstance($wasRunState = Default, $rebootAndroidIfNeccessary = $g_bRunState)
	;If Not $g_bAndroidInitialized Then Return
	If $wasRunState = Default Then $wasRunState = $g_bRunState
	Local $iConnected, $process_killed
	If Not $g_bAndroidInitialized Or $g_iAndroidAdbProcess[0] = 0 Or ProcessExists2($g_iAndroidAdbProcess[0]) <> $g_iAndroidAdbProcess[0] Then
		Local $SuspendMode = ResumeAndroid()
		InitAndroid()
		Local $s

		; check ADB device connection
		$iConnected = ConnectAndroidAdb($rebootAndroidIfNeccessary)
		If $iConnected = 0 Or ($iConnected = 2 And $g_iAndroidAdbProcess[0] = 0) Then
			; return with error
			Return SetError(3, 0)
		ElseIf $iConnected = 2 And $g_iAndroidAdbProcess[0] Then
			; return OK
			Return SetError(0, 0)
		EndIf

		; sync android tools to shared folder
		Local $hostFolder = $g_sAndroidPicturesHostPath & $g_sAndroidPicturesHostFolder
		If FileExists($hostFolder) = 1 Then
			SetDebugLog($hostFolder & " exists")
			Local $aTools = ["toybox", "minitouch"]
			Local $tool
			For $tool In $aTools
				Local $srcFile = $g_sAdbScriptsPath & "\" & $tool
				Local $dstFile = $hostFolder & $tool
				If FileGetTime($srcFile, $FT_MODIFIED, $FT_STRING) <> FileGetTime($dstFile, $FT_MODIFIED, $FT_STRING) Then
					FileCopy($srcFile, $dstFile, $FC_OVERWRITE)
				EndIf
			Next
		EndIf
		If $g_bAndroidAdbInstance = True Then
			$iConnected = ConnectAndroidAdb($rebootAndroidIfNeccessary)
			If $iConnected = 0 Or ($iConnected = 2 And $g_iAndroidAdbProcess[0] = 0) Then
				; return with error
				Return SetError(3, 0)
			ElseIf $iConnected = 2 And $g_iAndroidAdbProcess[0] Then
				; return OK
				Return SetError(0, 0)
			EndIf
			AndroidAdbTerminateShellInstance()
			;$g_iAndroidAdbProcess[0] = Run($g_sAndroidAdbPath & " -s " & $g_sAndroidAdbDevice & " shell", "", @SW_HIDE, BitOR($STDIN_CHILD, $STDERR_MERGED))
			; avoid "Use multiple -t options to force remote PTY allocation." by using -t -t
			Local $cmd = '"' & $g_sAndroidAdbPath & '"' & AddSpace($g_sAndroidAdbGlobalOptions, 1) & " -s " & $g_sAndroidAdbDevice & " shell" & $g_sAndroidAdbInstanceShellOptions & $g_sAndroidAdbShellOptions
			SetDebugLog("Run pipe ADB shell: " & $cmd)
			$g_iAndroidAdbProcess[0] = RunPipe($cmd, "", @SW_HIDE, BitOR($STDIN_CHILD, $STDERR_MERGED), $g_iAndroidAdbProcess[1], $g_iAndroidAdbProcess[2], $g_iAndroidAdbProcess[3], $g_iAndroidAdbProcess[4])
			Sleep(500)
			If $g_sAndroidAdbInstanceShellOptions And $g_iAndroidAdbProcess[0] <> 0 And ProcessExists2($g_iAndroidAdbProcess[0]) <> $g_iAndroidAdbProcess[0] Then
				Local $aReadPipe = $g_iAndroidAdbProcess[2]
				Local $output = ReadPipe($aReadPipe[0])
				If InvalidAdbInstanceShellOptions($output, "_AndroidAdbLaunchShellInstance") Then
					; try again
					ClosePipe($g_iAndroidAdbProcess[0], $g_iAndroidAdbProcess[1], $g_iAndroidAdbProcess[2], $g_iAndroidAdbProcess[3], $g_iAndroidAdbProcess[4])
					$cmd = '"' & $g_sAndroidAdbPath & '"' & AddSpace($g_sAndroidAdbGlobalOptions, 1) & " -s " & $g_sAndroidAdbDevice & " shell" & $g_sAndroidAdbInstanceShellOptions & $g_sAndroidAdbShellOptions
					SetDebugLog("Run pipe ADB shell: " & $cmd)
					$g_iAndroidAdbProcess[0] = RunPipe('"' & $g_sAndroidAdbPath & '"' & AddSpace($g_sAndroidAdbGlobalOptions, 1) & " -s " & $g_sAndroidAdbDevice & " shell" & $g_sAndroidAdbInstanceShellOptions & $g_sAndroidAdbShellOptions, "", @SW_HIDE, BitOR($STDIN_CHILD, $STDERR_MERGED), $g_iAndroidAdbProcess[1], $g_iAndroidAdbProcess[2], $g_iAndroidAdbProcess[3], $g_iAndroidAdbProcess[4])
					Sleep(500)
				EndIf
			EndIf
			If $g_sAndroidAdbShellOptions And $g_iAndroidAdbProcess[0] <> 0 And ProcessExists2($g_iAndroidAdbProcess[0]) <> $g_iAndroidAdbProcess[0] Then
				Local $aReadPipe = $g_iAndroidAdbProcess[2]
				Local $output = ReadPipe($aReadPipe[0])
				If InvalidAdbShellOptions($output, "_AndroidAdbLaunchShellInstance") Then
					; try again
					ClosePipe($g_iAndroidAdbProcess[0], $g_iAndroidAdbProcess[1], $g_iAndroidAdbProcess[2], $g_iAndroidAdbProcess[3], $g_iAndroidAdbProcess[4])
					$cmd = '"' & $g_sAndroidAdbPath & '"' & AddSpace($g_sAndroidAdbGlobalOptions, 1) & " -s " & $g_sAndroidAdbDevice & " shell" & $g_sAndroidAdbInstanceShellOptions & $g_sAndroidAdbShellOptions
					SetDebugLog("Run pipe ADB shell: " & $cmd)
					$g_iAndroidAdbProcess[0] = RunPipe('"' & $g_sAndroidAdbPath & '"' & AddSpace($g_sAndroidAdbGlobalOptions, 1) & " -s " & $g_sAndroidAdbDevice & " shell" & $g_sAndroidAdbInstanceShellOptions & $g_sAndroidAdbShellOptions, "", @SW_HIDE, BitOR($STDIN_CHILD, $STDERR_MERGED), $g_iAndroidAdbProcess[1], $g_iAndroidAdbProcess[2], $g_iAndroidAdbProcess[3], $g_iAndroidAdbProcess[4])
					Sleep(500)
				EndIf
			EndIf
			If $g_iAndroidAdbProcess[0] = 0 Or ProcessExists2($g_iAndroidAdbProcess[0]) <> $g_iAndroidAdbProcess[0] Then
				SetLog($g_sAndroidEmulator & " error launching ADB for background mode, zoom-out, mouse click and input", $COLOR_ERROR)
				$g_iAndroidAdbProcess[0] = 0
				$g_bAndroidAdbScreencap = False
				$g_bAndroidAdbClick = False
				$g_bAndroidAdbInput = False
				If BitAND($g_iAndroidSupportFeature, 1) = 0 Then $g_bChkBackgroundMode = False ; disable also background mode the hard way
				Return SetError(1, 0)
			Else
				AndroidInitPrompt()
			EndIf
		EndIf

		; if shared folder is not available, configure it
		If (Not $g_sAndroidPicturesHostPath Or Not $g_bAndroidSharedFolderAvailable) And $g_bAndroidPicturesPathAutoConfig And $rebootAndroidIfNeccessary Then
			RebootAndroidSetScreenDefault()
			Return SetError(0, 0)
		EndIf

		; check shared folder
		Local $pathFound = False
		Local $iMount
		$iconnected = connectAndroidadb($rebootAndroidifneccessary)
		If $iconnected = 0 OR ($iconnected = 2 And $g_iAndroidadbprocess[0] = 0) Then
			Return SetError(3, 0)
		ElseIf $iconnected = 2 And $g_iAndroidadbprocess[0] Then
			Return SetError(0, 0)
		EndIf
		
		For $iMount = 0 To 15

			$s = LaunchConsole($g_sAndroidAdbPath, AddSpace($g_sAndroidAdbGlobalOptions) & "-s " & $g_sAndroidAdbDevice & " shell" & $g_sAndroidAdbShellOptions & " mount", $process_killed)
			SetDebugLog("Display existing mounts: " & $s)
			Local $path = $g_sAndroidpicturespath
			If StringRight($path, 1) = "/" Then $path = StringLeft($path, StringLen($path) - 1)
			Local $aregexresult = StringRegExp($s, "[^ ]+(?: on)* ([^ ]+).+", $str_regexparrayglobalmatch)
			SetError(0)
			Local $amounts[0]
			If $path Then _arrayconcatenate($amounts, StringSplit(((StringLeft($path, 1) = "(" And StringRight($path, 1) = ")") ? StringMid($path, 2, StringLen($path) - 2) : $path), "|", $str_nocount))
			If UBound($aregexresult) > 0 Then _arrayconcatenate($amounts, $aregexresult)
			Local $dummyfile = StringMid(_crypt_hashdata($g_sbottitle & _now(), $calg_sha1), 3)
			If FileWriteLine($g_sAndroidpictureshostpath & $dummyfile, _now()) Then
				If _Sleep(100) Then Return SetError(4, 0)
				SetDebugLog("Created dummy file: " & $g_sAndroidpictureshostpath & $dummyfile)
				If FileExists($g_sAndroidpictureshostpath & $dummyfile) Then
					SetDebugLog("Dummy file size: " & FileGetSize($g_sAndroidpictureshostpath & $dummyfile))
				Else
					SetLog("Cannot create dummy file: " & $g_sAndroidpictureshostpath & $dummyfile, $COLOR_ERROR)
					Return SetError(4, 0)
				EndIf
			Else
				SetLog("Cannot create dummy file: " & $g_sAndroidpictureshostpath & $dummyfile, $COLOR_ERROR)
				Return SetError(4, 0)
			EndIf
            
			; Snorlax
            $s = LaunchConsole($g_sAndroidAdbPath, AddSpace($g_sAndroidAdbGlobalOptions) & "-s " & $g_sAndroidAdbDevice & " shell" & $g_sAndroidAdbShellOptions & " ls '" & $g_sAndroidPicturesPath & $dummyFile & "'", $process_killed)
            If StringInStr($s, $dummyFile) > 0 And StringInStr($s, $dummyFile & ":") = 0 And StringInStr($s, "No such file or directory") = 0 And StringInStr($s, "syntax error") = 0 And StringInStr($s, "Permission denied") = 0 Then
                $pathFound = True
                SetDebugLog("Using " & $g_sAndroidPicturesPath & " for Android shared folder")
                ExitLoop
            EndIf
            
			For $i = 0 To UBound($amounts) - 1
				$path = $amounts[$i]
				If $path = "" Then ContinueLoop
				If StringRight($path, 1) <> "/" Then $path &= "/"
				$s = AndroidadbsendshellcommAnd("set result=$(ls '" & $path & $dummyfile & "' >&2)", 10000, $wasrunstate, False)
				If StringInStr($s, $dummyfile) > 0 And StringInStr($s, $dummyfile & ":") = 0 And StringInStr($s, "No such file or directory") = 0 And StringInStr($s, "syntax error") = 0 And StringInStr($s, "Permission denied") = 0 Then
					$pathfound = True
					$g_sAndroidpicturespath = $path
					SetDebugLog("Using " & $g_sAndroidpicturespath & " for Android shared folder")
					ExitLoop
				EndIf
			Next
	
			FileDelete($g_sAndroidpictureshostpath & $dummyfile)
			If $pathfound = True Then ExitLoop
			If $imount = 0 Then
				SetLog("Waiting for shared folder to get mounted...", $color_green)
			Else
				SetDebugLog("Still waiting for shared folder to get mounted...")
			EndIf
			If $imount = 10 Then
				SetDebugLog("Restart adb with root permissions!", $color_warning)
				Local $process_killed
				Local $cmdoutput = launchconsole($g_sAndroidadbpath, "root", $process_killed)
				SetDebugLog("Remount adb.", $color_action)
				$cmdoutput = launchconsole($g_sAndroidadbpath, "remount", $process_killed)
				SetDebugLog("OutPut: " & $cmdoutput)
			EndIf
			If _Sleep(6000) Then Return 
			$g_iAndroidVersionAPI = Int(AndroidAdbSendShellCommand("getprop ro.build.version.sdk", Default, $wasRunState, False))
		Next
		
		$g_sAndroidPicturesPathAvailable = $pathFound
		If $pathFound = False Then
			SetLog($g_sAndroidEmulator & " cannot use ADB on shared folder, """ & $g_sAndroidPicturesPath & """ not found", $COLOR_ERROR)
		EndIf

		; call init script
		If $g_bAndroidAdbInstance = True Then
			$s = ""
			; increase shell priority
			#cs 2016-04-08 cosote Replaced by shell.init.script
				Local $renice = "/system/xbin/renice -20 "
				$s = AndroidAdbSendShellCommand($renice & "$$", Default, $wasRunState, False) ; increase shell priority to maximum
				If StringInStr($s, "not found") > 0 Then
				$renice = "renice -- -20 "
				$s = AndroidAdbSendShellCommand($renice & "$$", Default, $wasRunState, False) ; increase shell priority to maximum
				EndIf
				$s &= AndroidAdbSendShellCommand("stop media", Default, Default, False) ; stop media service as it can consume up to 30% Android CPU
			#ce
			Local $scriptFile = ""
			If $scriptFile = "" And FileExists($g_sAdbScriptsPath & "\shell.init." & $g_sAndroidEmulator & ".script") = 1 Then $scriptFile = "shell.init." & $g_sAndroidEmulator & ".script"
			If $scriptFile = "" Then $scriptFile = "shell.init.script"
			$s &= AndroidAdbSendShellCommandScript($scriptFile, Default, True, 3000, $wasRunState, False)
			; $s &= AndroidAdbSendShellCommand("stop media", Default, $wasRunState, False) ; stop media service as it can consume up to 30% Android CPU
			$s &= AndroidInitPrompt()
			Local $error = @error
			SetDebugLog("ADB shell launched, PID = " & $g_iAndroidAdbProcess[0] & ": " & $s)
			If $error <> 0 Then
				Return SetError(1, 0)
			EndIf
		EndIf

		; clear output
		;AndroidAdbSendShellCommand("", Default, $wasRunState, False)
		; update $g_iAndroidSystemAPI ; getprop ro.build.version.sdk
		$g_iAndroidVersionAPI = Int(AndroidAdbSendShellCommand("getprop ro.build.version.sdk", Default, $wasRunState, False))
		SetDebugLog("Android Version API = " & $g_iAndroidVersionAPI)
		Switch $g_iAndroidversionapi
			Case $g_iAndroidpie
				SetDebugLog("Android Version 9.0")
			Case $g_iAndroidoreo81
				SetDebugLog("Android Version 8.1")
			Case $g_iAndroidoreo
				SetDebugLog("Android Version 8.0")
			Case $g_iAndroidnougat72
				SetDebugLog("Android Version 7.1")
			Case $g_iAndroidnougat
				SetDebugLog("Android Version 7.0")
			Case $g_iAndroidlollipop51
				SetDebugLog("Android Version 5.1")
			Case $g_iAndroidlollipop
				SetDebugLog("Android Version 5.0")
			Case $g_iAndroidkitkat
				SetDebugLog("Android Version 4.4")
			Case $g_iAndroidjellybean
				SetDebugLog("Android Version 4.1 - 4.3.1")
			Case Else
				SetDebugLog("Android Version not detected!")
		EndSwitch

		; check mouse device
		If StringLen($g_sAndroidMouseDevice) > 0 And $g_sAndroidMouseDevice = $g_avAndroidAppConfig[$g_iAndroidConfig][13] Then
			$iConnected = ConnectAndroidAdb($rebootAndroidIfNeccessary)
			If $iConnected = 0 Or ($iConnected = 2 And $g_iAndroidAdbProcess[0] = 0) Then
				; return with error
				Return SetError(3, 0)
			ElseIf $iConnected = 2 And $g_iAndroidAdbProcess[0] Then
				; return OK
				Return SetError(0, 0)
			EndIf
			If StringInStr($g_sAndroidMouseDevice, "/dev/input/event") = 0 Then
				; use getevent to find mouse input device
				$s = AndroidAdbSendShellCommand("getevent -p", Default, $wasRunState, False)
				SetDebugLog($g_sAndroidEmulator & " getevent -p: " & $s)
				Local $aRegExResult = StringRegExp($s, "(\/dev\/input\/event\d+)[\r\n]+.+""" & $g_sAndroidMouseDevice & """((?!\/dev\/input\/event)[\s\S])+ABS", $STR_REGEXPARRAYMATCH)
				If @error = 0 Then
					$g_sAndroidMouseDevice = $aRegExResult[0]
					SetDebugLog("Using " & $g_sAndroidMouseDevice & " for mouse events")
				Else
					; ok, now use first device with 35/36 expected dimensions
					$aRegExResult = StringRegExp($s, "(\/dev\/input\/event\d+)[\r\n]+.+"".+""((?!\/dev\/input\/event)[\s\S])+ABS \(\d+\): 0035.+max " & $g_iGAME_WIDTH & ".+\n.+0036.+max " & $g_iGAME_HEIGHT, $STR_REGEXPARRAYMATCH)
					If @error = 0 Then
						SetDebugLog("Using " & $aRegExResult[0] & " for mouse events (" & $g_sAndroidMouseDevice & " not found)")
						$g_sAndroidMouseDevice = $aRegExResult[0]
					Else
						$g_bAndroidAdbClick = False
						SetLog($g_sAndroidEmulator & " cannot use ADB for mouse events, """ & $g_sAndroidMouseDevice & """ not found", $COLOR_ERROR)
						Return SetError(2, 1)
					EndIf
				EndIf
			EndIf
		Else
			SetDebugLog($g_sAndroidEmulator & " ADB use " & $g_sAndroidMouseDevice & " for mouse events")
		EndIf

		If $g_bAndroidAdbMinitouchSocket Then
			TCPCloseSocket($g_bAndroidAdbMinitouchSocket)
			$g_bAndroidAdbMinitouchSocket = 0
		EndIf
		If $g_iAndroidAdbMinitouchMode = 0 Then
			If $g_bAndroidAdbMinitouchPort Then
				SetDebugLog($g_sAndroidEmulator & " initialize minitouch on port " & $g_bAndroidAdbMinitouchPort)
				; launch minitouch
				Local $androidPath = $g_sAndroidPicturesPath & StringReplace($g_sAndroidPicturesHostFolder, "\", "/")
				Local $output = AndroidAdbSendShellCommand($androidPath & "minitouch -d " & $g_sAndroidMouseDevice & " >/dev/null 2>&1 &", -1000, $wasRunState, False)
				; clear output
				AndroidAdbSendShellCommand("", Default, $wasRunState, False)
				; forward minitouch port
				Local $process_killed
				Local $output = LaunchConsole($g_sAndroidAdbPath, AddSpace($g_sAndroidAdbGlobalOptions) & "-s " & $g_sAndroidAdbDevice & " forward tcp:" & $g_bAndroidAdbMinitouchPort & " localabstract:minitouch", $process_killed)
				If StringInStr($output, "cannot bind") > 0 Then
					; cannot bind TCP port, not available "anymore"
					SetLog("Initialize Android ADB ports...")
					; try again
					AndroidAdbTerminateShellInstance()
					InitAndroidAdbPorts(True)
					_AndroidAdbLaunchShellInstance($wasRunState, $rebootAndroidIfNeccessary)
					Return
				EndIf
				; connect socket
				$g_bAndroidAdbMinitouchSocket = TCPConnect("127.0.0.1", $g_bAndroidAdbMinitouchPort)
			EndIf
			If $g_bAndroidAdbMinitouchSocket < 1 Then
				SetDebugLog($g_sAndroidEmulator & " minitouch not available, switch to STDIN", $COLOR_ERROR)
				$g_bAndroidAdbMinitouchSocket = 0
				$g_iAndroidAdbMinitouchMode = 1
			EndIf
		EndIf
		If $g_iAndroidAdbMinitouchMode = 1 Then
			; use STDIN
			AndroidAdbLaunchMinitouchShellInstance($wasRunState, $rebootAndroidIfNeccessary)
		EndIf
		SuspendAndroid($SuspendMode)
	EndIf
	SetError(0, 0)
EndFunc   ;==>_AndroidAdbLaunchShellInstance

Func AndroidAdbTerminateShellInstance()
	ClearClicks() ; it can happen the clicks are hold back, ensure it's cleared
	Local $SuspendMode = ResumeAndroid()
	If $g_iAndroidAdbProcess[0] <> 0 Then
		; send exit to shell
		If _AndroidAdbSendShellCommand("exit", 500, Default, False, False, True) Then _AndroidAdbSendShellCommand("exit", 0, Default, False, False, True) ; probably su (2nd shell) is running e.g. for BlueStacks
		If ClosePipe($g_iAndroidAdbProcess[0], $g_iAndroidAdbProcess[1], $g_iAndroidAdbProcess[2], $g_iAndroidAdbProcess[3], $g_iAndroidAdbProcess[4]) = 1 Then
			SetDebugLog("ADB shell terminated, PID = " & $g_iAndroidAdbProcess[0])
		Else
			SetDebugLog("ADB shell already terminated, PID = " & $g_iAndroidAdbProcess[0])
		EndIf
		$g_iAndroidAdbProcess[0] = 0
	EndIf
	If $g_bAndroidAdbMinitouchSocket Then
		TCPCloseSocket($g_bAndroidAdbMinitouchSocket)
		$g_bAndroidAdbMinitouchSocket = 0
	EndIf
	AndroidAdbTerminateMinitouchShellInstance()
EndFunc   ;==>AndroidAdbTerminateShellInstance

Func AndroidAdbSendShellCommand($cmd = Default, $timeout = Default, $wasRunState = Default, $EnsureShellInstance = True, $bStripPrompt = True, $bNoShellTerminate = False)
	FuncEnter(AndroidAdbSendShellCommand)
	If Not $g_bAndroidInitialized Then Return FuncReturn()
	Local $wasAllowed = $g_bTogglePauseAllowed
	$g_bTogglePauseAllowed = False
	Local $Result = _AndroidAdbSendShellCommand($cmd, $timeout, $wasRunState, $EnsureShellInstance, $bStripPrompt, $bNoShellTerminate)
	$g_bTogglePauseAllowed = $wasAllowed
	Return FuncReturn(SetError(@error, @extended, $Result))
EndFunc   ;==>AndroidAdbSendShellCommand

Func _AndroidAdbSendShellCommand($cmd = Default, $timeout = Default, $wasRunState = Default, $EnsureShellInstance = True, $bStripPrompt = True, $bNoShellTerminate = False)
	Static $iCommandErrors = 0 ; restart ADB on too many errors
	Local $_SilentSetLog = $g_bSilentSetLog
	If $timeout = Default Then $timeout = 3000 ; default is 3 sec.
	If $wasRunState = Default Then $wasRunState = $g_bRunState
	Local $sentBytes = 0
	Local $SuspendMode = ResumeAndroid()
	SetError(0, 0, 0)
	If $EnsureShellInstance = True Then
		AndroidAdbLaunchShellInstance($wasRunState) ; recursive call in AndroidAdbLaunchShellInstance!
	EndIf
	If @error <> 0 Then Return SetError(@error, 0, "")
	Local $hTimer = __TimerInit()
	Local $s = ""
	Local $loopCount = 0
	Local $cleanOutput = True
	If $g_bAndroidAdbInstance = True Then
		; use steady ADB shell
		Local $aReadPipe = $g_iAndroidAdbProcess[2]
		Local $aWritePipe = $g_iAndroidAdbProcess[1]
		If UBound($aReadPipe) < 2 Or UBound($aWritePipe) < 2 Then
			SetDebugLog("ADB Shell instance not initialized, cannot execute: " & $cmd, $COLOR_ERROR)
			Return SetError(1, 0, "")
		EndIf
		ReadPipe($aReadPipe[0]) ; clear anything in read pipe first
		If $cmd = Default Then
			; nothing to launch
		Else
			If $g_bDebugAndroid Then
				;$g_bSilentSetLog = True
				SetDebugLog("Send ADB shell command: " & $cmd)
				;$g_bSilentSetLog = $_SilentSetLog
			EndIf
			$sentBytes = WritePipe($aWritePipe[1], $cmd & @LF)
		EndIf
		If $timeout <> 0 Then
			While @error = 0 And ($timeout < 0 Or StringCompare(StringRight($s, StringLen($g_sAndroidAdbPrompt) + 1), @LF & $g_sAndroidAdbPrompt, $STR_CASESENSE) <> 0) And __TimerDiff($hTimer) < Abs($timeout)
				Sleep(10)
				$s &= ReadPipe($aReadPipe[0])
				$loopCount += 1
				; Custom fix - Team__AiO__MOD
				If $wasRunState <> $g_bRunState Then ExitLoop ; stop pressed here, exit without error ; Custom fix - Team__AiO__MOD
				;SetDebugLog("Prompt-Check: tail is '"  & StringRight($s, StringLen($g_sAndroidAdbPrompt) + 1) & "', result " & StringCompare(StringRight($s, StringLen($g_sAndroidAdbPrompt) + 1), @LF & $g_sAndroidAdbPrompt, $STR_CASESENSE))
			WEnd
		Else
			; no timeout, just read pipe once
			$s &= ReadPipe($aReadPipe[0])
		EndIf
		;SetDebugLog("Send ADB shell raw output: " & $s)
	Else
		; invoke new single ADB shell command
		$cleanOutput = False
		If $cmd = Default Then
			; nothing to launch
		Else
			Local $process_killed
			If $g_bDebugAndroid Then
				;$g_bSilentSetLog = True
				SetDebugLog("Execute ADB shell command: " & $cmd)
				;$g_bSilentSetLog = $_SilentSetLog
			EndIf
			$s = LaunchConsole($g_sAndroidAdbPath, AddSpace($g_sAndroidAdbGlobalOptions) & "-s " & $g_sAndroidAdbDevice & " shell " & $cmd, $process_killed, Abs($timeout))
		EndIf
	EndIf

	If $cleanOutput Then
		Local $i = StringInStr($s, @LF)
		If $i > 0 Then $s = StringMid($s, $i) ; remove echo'd command
		If $bStripPrompt And StringCompare(StringRight($s, StringLen($g_sAndroidAdbPrompt) + 1), @LF & $g_sAndroidAdbPrompt, $STR_CASESENSE) = 0 Then $s = StringLeft($s, StringLen($s) - StringLen($g_sAndroidAdbPrompt) - 1) ; remove tailing prompt
		CleanLaunchOutput($s)
		If StringLeft($s, 1) = @LF Then $s = StringMid($s, 2) ; remove starting @LF
	Else
		If StringLeft($s, 1) = @LF Then $s = StringMid($s, 2) ; remove starting @LF
		; always strip tailing CR/LF
		If StringRight($s, 1) = @LF Then $s = StringLeft($s, StringLen($s) - 1)
		If StringRight($s, 1) = @CR Then $s = StringLeft($s, StringLen($s) - 1)
	EndIf

	If $g_bAndroidAdbInstance = True And $g_bDebugAndroid And StringLen($s) > 0 Then SetDebugLog("ADB shell command output: " & $s)
	SuspendAndroid($SuspendMode)
	Local $error = (($g_bRunState = False Or __TimerDiff($hTimer) < $timeout Or $timeout < 1) ? 0 : 1)
	If $error <> 0 Then
		SetDebugLog("(" & $iCommandErrors & "): ADB shell command error " & $error & " (" & $g_sAndroidAdbPrompt & "): " & $s, $COLOR_ERROR)
		$iCommandErrors += 1
	EndIf
	If $__TEST_ERROR_SLOW_ADB_SHELL_COMMAND_DELAY > 0 Then Sleep($__TEST_ERROR_SLOW_ADB_SHELL_COMMAND_DELAY)
	$g_iAndroidAdbAutoTerminateCount += 1
	If $iCommandErrors > $g_iAndroidRebootAdbCommandErrorCount Or (Mod($g_iAndroidAdbAutoTerminateCount, $g_iAndroidAdbAutoTerminate) = 0 And $EnsureShellInstance = True) Then
		If $iCommandErrors > $g_iAndroidRebootAdbCommandErrorCount Then
			$iCommandErrors = 0
			RebootAndroid() ; reboot
		Else
			$iCommandErrors = 0
			If $bNoShellTerminate = False Then AndroidAdbTerminateShellInstance()
		EndIf
	EndIf
	;Return SetError($error, Int(__TimerDiff($hTimer)) & "ms,#" & $loopCount, $s)
	Return SetError($error, Int(__TimerDiff($hTimer)), $s)
EndFunc   ;==>_AndroidAdbSendShellCommand

Func AndroidAdbLaunchMinitouchShellInstance($wasRunState = Default, $rebootAndroidIfNeccessary = $g_bRunState, $bUseMouseDevice = True)
	If Not $g_bAndroidInitialized Then Return SetError(2, 0)
	If $wasRunState = Default Then $wasRunState = $g_bRunState
	Local $iConnected
	If Not $g_bAndroidInitialized Or $g_iAndroidAdbMinitouchProcess[0] = 0 Or ProcessExists2($g_iAndroidAdbMinitouchProcess[0]) <> $g_iAndroidAdbMinitouchProcess[0] Then
		Local $SuspendMode = ResumeAndroid()
		Local $s

		$iConnected = ConnectAndroidAdb($rebootAndroidIfNeccessary)
		If $iConnected = 0 Or ($iConnected = 2 And $g_iAndroidAdbMinitouchProcess[0] = 0) Then
			; return with error
			Return SetError(3, 0)
		ElseIf $iConnected = 2 And $g_iAndroidAdbMinitouchProcess[0] Then
			; return OK
			Return SetError(0, 0)
		EndIf
		AndroidAdbTerminateMinitouchShellInstance()
		; minitouch: Uses STDIN and doesn't start socket
		If $bUseMouseDevice Then
			Local $cmdMinitouch = $g_sAndroidPicturesPath & StringReplace($g_sAndroidPicturesHostFolder, "\", "/") & "minitouch -d " & $g_sAndroidMouseDevice & " -i"
		Else
			Local $cmdMinitouch = $g_sAndroidPicturesPath & StringReplace($g_sAndroidPicturesHostFolder, "\", "/") & "minitouch -i"
		EndIf
		Local $cmd = '"' & $g_sAndroidAdbPath & '"' & AddSpace($g_sAndroidAdbGlobalOptions, 1) & " -s " & $g_sAndroidAdbDevice & " shell" & $g_sAndroidAdbInstanceShellOptions & $g_sAndroidAdbShellOptions & " " & $cmdMinitouch
		SetDebugLog("Run pipe ADB shell for minituch: " & $cmd)
		$g_iAndroidAdbMinitouchProcess[0] = RunPipe($cmd, "", @SW_HIDE, BitOR($STDIN_CHILD, $STDERR_MERGED), $g_iAndroidAdbMinitouchProcess[1], $g_iAndroidAdbMinitouchProcess[2], $g_iAndroidAdbMinitouchProcess[3], $g_iAndroidAdbMinitouchProcess[4])
		Sleep(500)
		If $g_sAndroidAdbInstanceShellOptions And $g_iAndroidAdbMinitouchProcess[0] <> 0 And ProcessExists2($g_iAndroidAdbMinitouchProcess[0]) <> $g_iAndroidAdbMinitouchProcess[0] Then
			Local $aReadPipe = $g_iAndroidAdbMinitouchProcess[2]
			Local $output = ReadPipe($aReadPipe[0])
			If InvalidAdbInstanceShellOptions($output, "AndroidAdbLaunchMinitouchShellInstance") Then
				; try again
				ClosePipe($g_iAndroidAdbMinitouchProcess[0], $g_iAndroidAdbMinitouchProcess[1], $g_iAndroidAdbMinitouchProcess[2], $g_iAndroidAdbMinitouchProcess[3], $g_iAndroidAdbMinitouchProcess[4])
				$cmd = '"' & $g_sAndroidAdbPath & '"' & AddSpace($g_sAndroidAdbGlobalOptions, 1) & " -s " & $g_sAndroidAdbDevice & " shell" & $g_sAndroidAdbInstanceShellOptions & $g_sAndroidAdbShellOptions & " " & $cmdMinitouch
				SetDebugLog("Run pipe ADB shell for minituch: " & $cmd)
				$g_iAndroidAdbMinitouchProcess[0] = RunPipe($cmd, "", @SW_HIDE, BitOR($STDIN_CHILD, $STDERR_MERGED), $g_iAndroidAdbProcess[1], $g_iAndroidAdbProcess[2], $g_iAndroidAdbProcess[3], $g_iAndroidAdbProcess[4])
				Sleep(500)
			EndIf
		EndIf
		If $g_sAndroidAdbShellOptions And $g_iAndroidAdbMinitouchProcess[0] <> 0 And ProcessExists2($g_iAndroidAdbMinitouchProcess[0]) <> $g_iAndroidAdbMinitouchProcess[0] Then
			Local $aReadPipe = $g_iAndroidAdbMinitouchProcess[2]
			Local $output = ReadPipe($aReadPipe[0])
			If InvalidAdbShellOptions($output, "AndroidAdbLaunchMinitouchShellInstance") Then
				; try again
				ClosePipe($g_iAndroidAdbMinitouchProcess[0], $g_iAndroidAdbMinitouchProcess[1], $g_iAndroidAdbMinitouchProcess[2], $g_iAndroidAdbMinitouchProcess[3], $g_iAndroidAdbMinitouchProcess[4])
				$cmd = '"' & $g_sAndroidAdbPath & '"' & AddSpace($g_sAndroidAdbGlobalOptions, 1) & " -s " & $g_sAndroidAdbDevice & " shell" & $g_sAndroidAdbInstanceShellOptions & $g_sAndroidAdbShellOptions & " " & $cmdMinitouch
				SetDebugLog("Run pipe ADB shell for minituch: " & $cmd)
				$g_iAndroidAdbMinitouchProcess[0] = RunPipe($cmd, "", @SW_HIDE, BitOR($STDIN_CHILD, $STDERR_MERGED), $g_iAndroidAdbProcess[1], $g_iAndroidAdbProcess[2], $g_iAndroidAdbProcess[3], $g_iAndroidAdbProcess[4])
				Sleep(500)
			EndIf
		EndIf
		If $g_iAndroidAdbMinitouchProcess[0] And ProcessExists2($g_iAndroidAdbMinitouchProcess[0]) = $g_iAndroidAdbMinitouchProcess[0] Then
			; all seems fine, run minitouch service now
		Else
			If $bUseMouseDevice Then
				; failed with mouse device, now try without
				Return AndroidAdbLaunchMinitouchShellInstance($wasRunState, $rebootAndroidIfNeccessary, False)
			EndIf
			SetLog($g_sAndroidEmulator & " error launching ADB shell for minitouch", $COLOR_ERROR)
			$g_iAndroidAdbMinitouchProcess[0] = 0
			Return SetError(1, 0)
		EndIf
	EndIf
	SetError(0, 0)
EndFunc   ;==>AndroidAdbLaunchMinitouchShellInstance

Func AndroidAdbTerminateMinitouchShellInstance()
	Local $SuspendMode = ResumeAndroid()
	If $g_iAndroidAdbMinitouchProcess[0] <> 0 Then
		; send exit to shell
		;If AndroidAdbSendMinitouchShellCommand("exit", Default, False, False, True) Then _AndroidAdbSendShellCommand("exit", 0, Default, False, False, True) ; probably su (2nd shell) is running e.g. for BlueStacks
		If ClosePipe($g_iAndroidAdbMinitouchProcess[0], $g_iAndroidAdbMinitouchProcess[1], $g_iAndroidAdbMinitouchProcess[2], $g_iAndroidAdbMinitouchProcess[3], $g_iAndroidAdbMinitouchProcess[4]) = 1 Then
			SetDebugLog("ADB minitouch shell terminated, PID = " & $g_iAndroidAdbMinitouchProcess[0])
		Else
			SetDebugLog("ADB minitouch shell already terminated, PID = " & $g_iAndroidAdbMinitouchProcess[0])
		EndIf
		$g_iAndroidAdbMinitouchProcess[0] = 0
	EndIf
EndFunc   ;==>AndroidAdbTerminateMinitouchShellInstance

Func AndroidAdbSendMinitouchShellCommand($cmd = Default, $iDelay = 0, $wasRunState = Default, $EnsureShellInstance = True, $bStripPrompt = True, $bNoShellTerminate = False)
	Static $iCommandErrors = 0 ; restart ADB on too many errors
	Local $_SilentSetLog = $g_bSilentSetLog
	If $wasRunState = Default Then $wasRunState = $g_bRunState
	Local $sentBytes = 0
	Local $SuspendMode = ResumeAndroid()
	SetError(0, 0, 0)
	If $EnsureShellInstance = True Then
		AndroidAdbLaunchMinitouchShellInstance($wasRunState) ; recursive call in AndroidAdbLaunchShellInstance!
	EndIf
	If @error <> 0 Then Return SetError(@error, 0, "")
	Local $loopCount = 0
	; use steady ADB shell
	Local $aReadPipe = $g_iAndroidAdbMinitouchProcess[2]
	Local $aWritePipe = $g_iAndroidAdbMinitouchProcess[1]
	If UBound($aReadPipe) < 2 Or UBound($aWritePipe) < 2 Then
		SetDebugLog("ADB Minitiuch Shell instance not initialized, cannot execute: " & $cmd, $COLOR_ERROR)
		Return SetError(1, 0, "")
	EndIf
	ReadPipe($aReadPipe[0]) ; clear anything in read pipe first
	If $cmd = Default Then
		; nothing to launch
	Else
		If $g_bDebugAndroid Then
			;$g_bSilentSetLog = True
			SetDebugLog("Send ADB minitouch shell command: " & StringReplace($cmd, @LF, ";"))
			;$g_bSilentSetLog = $_SilentSetLog
		EndIf
		$sentBytes = WritePipe($aWritePipe[1], $cmd)
	EndIf
	If $iDelay Then Sleep($iDelay)
	; read pipe once
	Local $s = ReadPipe($aReadPipe[0])
	SuspendAndroid($SuspendMode)
	Return $s
EndFunc   ;==>AndroidAdbSendMinitouchShellCommand

Func GetBinaryEvent($type, $code, $value)
	Local $h, $hType, $hCode, $hValue
	If IsInt($type) Then
		$hType = StringLeft(Hex(Binary($type)), 4)
	ElseIf IsString($type) Then
		$hType = $type
	EndIf
	If IsInt($code) Then
		$hCode = StringLeft(Hex(Binary($code)), 4)
	ElseIf IsString($code) Then
		$hCode = $code
	EndIf
	If IsInt($value) Then
		$hValue = StringLeft(Hex(Binary($value)), 8)
	ElseIf IsString($value) Then
		$hValue = $value
	EndIf
	#cs
		$hType = "0100"
		$hCode = "4a01"
		$hValue = "01000000"
	#ce
	$h = "0x0000000000000000" & $hType & $hCode & $hValue
	Return Binary($h)
EndFunc   ;==>GetBinaryEvent

Func AndroidAdbSendShellCommandScript($scriptFile, $variablesArray = Default, $combine = Default, $timeout = Default, $wasRunState = $g_bRunState, $EnsureShellInstance = True)
	If $combine = Default Then $combine = False
	If $timeout = Default Then $timeout = 20000 ; default is 20 sec. for scripts
	Local $hostPath = $g_sAndroidPicturesHostPath & $g_sAndroidPicturesHostFolder
	Local $androidPath = $g_sAndroidPicturesPath & StringReplace($g_sAndroidPicturesHostFolder, "\", "/")

	;If $HwND <> WinGetHandle($HwND) Then Return SetError(2, 0) ; Window gone
	AndroidAdbLaunchShellInstance()
	If @error <> 0 Then Return SetError(3, 0)

	Local $hTimer = __TimerInit()
	Local $hFileOpen = FileOpen($g_sAdbScriptsPath & "\" & $scriptFile)
	If $hFileOpen = -1 Then
		SetLog("ADB script file not found: " & $scriptFile, $COLOR_ERROR)
		Return SetError(5, 0)
	EndIf

	Local $script = FileRead($hFileOpen)
	FileClose($hFileOpen)
	Local $scriptModifiedTime = FileGetTime($g_sAdbScriptsPath & "\" & $scriptFile, $FT_MODIFIED, $FT_STRING)

	Local $scriptFileSh = $scriptFile
	Local $bIsMinitouch = StringRight($scriptFile, 10) = ".minitouch"
	Local $i, $j, $k, $iAdditional
	If $bIsMinitouch Then
		If StringInStr($g_sAndroidMouseDevice, "/dev/input/event") = 0 Then
			$g_bAndroidAdbClick = False
			SetLog($g_sAndroidEmulator & " mouse device not configured", $COLOR_ERROR)
			Return SetError(4, 0, 0)
		EndIf
	Else
		$script = StringReplace($script, "{$AndroidMouseDevice}", $g_sAndroidMouseDevice)
		If @extended > 0 Then
			$scriptFileSh &= $g_sAndroidMouseDevice
			If StringInStr($g_sAndroidMouseDevice, "/dev/input/event") = 0 Then
				$g_bAndroidAdbClick = False
				SetLog($g_sAndroidEmulator & " mouse device not configured", $COLOR_ERROR)
				Return SetError(4, 0, 0)
			EndIf
		EndIf

		; copy additional files required for script
		Local $additionalFilenames[0]
		$i = 1
		While FileExists($g_sAdbScriptsPath & "\" & $scriptFile & "." & $i) = 1
			Local $srcFile = $g_sAdbScriptsPath & "\" & $scriptFile & "." & $i
			Local $secFile = GetSecureFilename($scriptFile & "." & $i)
			Local $dstFile = $hostPath & $secFile
			If FileGetTime($srcFile, $FT_MODIFIED, $FT_STRING) <> FileGetTime($dstFile, $FT_MODIFIED, $FT_STRING) Then
				FileCopy($srcFile, $dstFile, $FC_OVERWRITE)
			EndIf
			$iAdditional = $i
			ReDim $additionalFilenames[$iAdditional]
			$additionalFilenames[$iAdditional - 1] = $secFile
			$script = StringReplace($script, $scriptFile & "." & $i, $secFile)
			$i += 1
		WEnd

		If UBound($variablesArray, 2) = 2 Then
			For $i = 0 To UBound($variablesArray, 1) - 1
				$script = StringReplace($script, $variablesArray[$i][0], $variablesArray[$i][1])
				If @extended > 0 Then
					$scriptFileSh &= "." & $variablesArray[$i][1]
				EndIf
			Next
		EndIf
	EndIf
	$scriptFileSh = StringRegExpReplace($scriptFileSh, '[/\:*?"<>|]', '.')

	$scriptFileSh &= ".sh"
	$scriptFileSh = GetSecureFilename($scriptFileSh)
	$script = StringReplace($script, @CRLF, @LF)

	Local $aCmds = StringSplit($script, @LF)
	Local $hTimer = __TimerInit()
	Local $s = ""

	; create sh file in shared folder
	If FileExists($hostPath) = 0 Then
		SetLog($g_sAndroidEmulator & " ADB script file folder doesn't exist:", $COLOR_ERROR)
		SetLog($hostPath, $COLOR_ERROR)
		Return SetError(6, 0)
	EndIf

	SetError(0, 0)
	If Not $bIsMinitouch Then
		Local $sDev
		Local $cmds = ""
		Local $dd[1]
		Local $ddCount = -1
		Local $ddFile, $ddHandle
		For $i = 1 To $aCmds[0]
			Local $cmd = $aCmds[$i]
			If StringInStr($cmd, "/dev/input/") = 1 Then
				Local $aElem = StringSplit($cmd, " ")
				$sDev = StringReplace($aElem[1], ":", "")
				If $aElem[0] < 4 Then
					SetDebugLog("ADB script " & $scriptFile & ": ignore line " & $i & ": " & $cmd, $COLOR_ACTION)
				Else
					If IsString($combine) = 1 And $combine = "dd" Then
						; convert getevent into dd send binary data
						$j = UBound($dd)
						ReDim $dd[$j + 1]
						$dd[0] = $sDev
						$dd[$j] = GetBinaryEvent(Dec($aElem[2]), Dec($aElem[3]), Dec($aElem[4]))
						$cmd = ""
					Else
						; convert getevent into sendevent
						$cmd = "sendevent " & $sDev & " " & Dec($aElem[2]) & " " & Dec($aElem[3]) & " " & Dec($aElem[4])
					EndIf
				EndIf
			EndIf

			$cmd = StringStripWS($cmd, 3)

			If $cmd = "#dd send" Then
				$j = UBound($dd) - 1
				If $j > 0 Then
					$iAdditional += 1
					$ddFile = GetSecureFilename($scriptFile & "." & $iAdditional)
					ReDim $additionalFilenames[$iAdditional]
					$additionalFilenames[$iAdditional - 1] = $ddFile
					; create dd file
					$ddHandle = FileOpen($hostPath & $ddFile, BitOR($FO_OVERWRITE, $FO_BINARY))
					$cmd = "dd obs=" & 16 * ($j - 1) & " if=" & $androidPath & $ddFile & " of=" & $dd[0]
					For $k = 1 To $j
						FileWrite($ddHandle, $dd[$k])
					Next
					FileClose($ddHandle)
				EndIf
			EndIf

			$aCmds[$i] = $cmd

			If $combine = True And IsString($combine) = 0 And StringLen($cmd) > 0 Then
				$cmds &= $cmd
				If $i < $aCmds[0] Then $cmds &= ";"
			EndIf
		Next
	EndIf

	$script = ""
	Local $loopCount = 0
	If Not $bIsMinitouch And $combine = True And IsString($combine) = 0 And StringLen($cmds) <= 1024 Then
		; invoke commands now
		$s = AndroidAdbSendShellCommand($cmds, $timeout, $wasRunState, $EnsureShellInstance)
		If @error <> 0 Then Return SetError(1, 0, $s)
		Local $a = StringSplit(@extended, "#")
		If $a[0] > 1 Then $loopCount += Number($a[2])
	Else
		; create sh file in shared folder
		If $scriptModifiedTime <> FileGetTime($hostPath & $scriptFileSh, $FT_MODIFIED, $FT_STRING) Then
			FileDelete($hostPath & $scriptFileSh) ; delete existing file as new version is available
		EndIf
		If FileExists($hostPath & $scriptFileSh) = 0 Then
			; create script file
			If Not $bIsMinitouch Then $script = "#!/bin/sh"
			For $i = 1 To $aCmds[0]
				If ($i = 1 And StringLeft($aCmds[$i], 2) = "#!") Or $aCmds[$i] = "" Then
					ContinueLoop
				EndIf
				If $script <> "" Then $script &= @LF
				$script &= $aCmds[$i]
			Next
			; create sh file
			If FileWrite($hostPath & $scriptFileSh, $script) = 1 Then
				If BitAND($g_iAndroidSecureFlags, 3) = 0 Then SetLog("ADB script file created: " & $hostPath & $scriptFileSh)
			Else
				SetLog("ADB cannot create script file: " & $hostPath & $scriptFileSh, $COLOR_ERROR)
				Return SetError(7, 0)
			EndIf
			FileSetTime($hostPath & $scriptFileSh, $scriptModifiedTime, $FT_MODIFIED) ; set modification date of source
		EndIf
		If $bIsMinitouch Then
			$s = AndroidAdbSendShellCommand("""" & $androidPath & "minitouch"" -v -d " & $g_sAndroidMouseDevice & " -f """ & $androidPath & $scriptFileSh & """", $timeout, $wasRunState, $EnsureShellInstance)
		Else
			$s = AndroidAdbSendShellCommand("sh """ & $androidPath & $scriptFileSh & """", $timeout, $wasRunState, $EnsureShellInstance)
		EndIf
		If BitAND($g_iAndroidSecureFlags, 2) = 2 Then
			; delete files
			FileDelete($hostPath & $scriptFileSh)
			For $i = 0 To $iAdditional - 1
				FileDelete($hostPath & $additionalFilenames[$i])
			Next
		EndIf
		If @error <> 0 Then
			SetDebugLog("Error executing " & $scriptFileSh & ": " & $s)
			Return SetError(1, 0, $s)
		EndIf
		Local $a = StringSplit(@extended, "#")
		If $a[0] > 1 Then $loopCount += Number($a[2])
	EndIf

	Return SetError(0, Int(__TimerDiff($hTimer)) & "ms,#" & $loopCount, $s)
EndFunc   ;==>AndroidAdbSendShellCommandScript

;==================================================================================================================================
; Author ........: UEZ
; Modified.......: progandy, cosote
;===================================================================================================================================
Func __GDIPlus_BitmapCreateFromMemory($dImage, $bHBITMAP = False)
	If Not IsBinary($dImage) Then Return SetError(1, 0, 0)
	Local $aResult = 0
	Local Const $dMemBitmap = Binary($dImage) ;load image saved in variable (memory) and convert it to binary
	Local Const $iLen = BinaryLen($dMemBitmap) ;get binary length of the image
	Local Const $GMEM_MOVEABLE = 0x0002
	$aResult = DllCall("kernel32.dll", "handle", "GlobalAlloc", "uint", $GMEM_MOVEABLE, "ulong_ptr", $iLen) ;allocates movable memory ($GMEM_MOVEABLE = 0x0002)
	If @error Then Return SetError(4, 0, 0)
	Local Const $hData = $aResult[0]
	$aResult = DllCall("kernel32.dll", "ptr", "GlobalLock", "handle", $hData)
	If @error Then Return SetError(5, 0, 0)
	Local $tMem = DllStructCreate("byte[" & $iLen & "]", $aResult[0]) ;create struct
	DllStructSetData($tMem, 1, $dMemBitmap) ;fill struct with image data
	DllCall("kernel32.dll", "bool", "GlobalUnlock", "handle", $hData) ;decrements the lock count associated with a memory object that was allocated with GMEM_MOVEABLE
	If @error Then Return SetError(6, 0, 0)
	Local Const $hStream = _WinAPI_CreateStreamOnHGlobal($hData) ;creates a stream object that uses an HGLOBAL memory handle to store the stream contents
	If @error Then Return SetError(2, 0, 0)
	Local Const $hBitmap = _GDIPlus_BitmapCreateFromStream($hStream) ;creates a Bitmap object based on an IStream COM interface
	If @error Then Return SetError(3, 0, 0)
	DllCall("oleaut32.dll", "long", "DispCallFunc", "ptr", $hStream, "ulong_ptr", 8 * (1 + @AutoItX64), "uint", 4, "ushort", 23, "uint", 0, "ptr", 0, "ptr", 0, "str", "") ;release memory from $hStream to avoid memory leak
	If $bHBITMAP Then
		Local Const $hHBmp = _GDIPlus_BitmapCreateDIBFromBitmap($hBitmap) ;supports GDI transparent color format
		_GDIPlus_BitmapDispose($hBitmap)
		Return $hHBmp
	EndIf
	Return $hBitmap
EndFunc   ;==>__GDIPlus_BitmapCreateFromMemory

Func AndroidScreencap($iLeft, $iTop, $iWidth, $iHeight, $iRetryCount = 0)
	Local $wasAllowed = $g_bTogglePauseAllowed
	$g_bTogglePauseAllowed = False
	Local $Result = _AndroidScreencap($iLeft, $iTop, $iWidth, $iHeight, $iRetryCount)
	Local $iError = @error, $iExtended = @extended
	$g_bTogglePauseAllowed = $wasAllowed
	Return SetError($iError, $iExtended, $Result)
EndFunc   ;==>AndroidScreencap

Func _AndroidScreencap($iLeft, $iTop, $iWidth, $iHeight, $iRetryCount = 0)
	; ensure dimensions are not exceeding buffer, DLL might crash with exception code c0000005
	If $iWidth > $g_iGAME_WIDTH Then $iWidth = $g_iGAME_WIDTH
	If $iHeight > $g_iGAME_HEIGHT Then $iHeight = $g_iGAME_HEIGHT
	If $iWidth < 1 Then $iWidth = 1
	If $iHeight < 1 Then $iHeight = 1
	If $iLeft > $g_iGAME_WIDTH - 1 Then $iLeft = $g_iGAME_WIDTH - 1
	If $iTop > $g_iGAME_HEIGHT - 1 Then $iTop = $g_iGAME_HEIGHT - 1
	If $iLeft < 0 Then $iLeft = 0
	If $iTop < 0 Then $iTop = 0
	If $iLeft + $iWidth > $g_iGAME_WIDTH Then $iWidth = $g_iGAME_WIDTH - $iLeft
	If $iTop + $iHeight > $g_iGAME_HEIGHT Then $iHeight = $g_iGAME_HEIGHT - $iTop
	Local $startTimer = __TimerInit()
	Local $hostPath = $g_sAndroidPicturesHostPath & $g_sAndroidPicturesHostFolder
	Local $androidPath = $g_sAndroidPicturesPath & StringReplace($g_sAndroidPicturesHostFolder, "\", "/")

	If $hostPath = "" Or $androidPath = "" Then
		If $hostPath = "" Then
			SetLog($g_sAndroidEmulator & " shared folder not configured for host", $COLOR_ERROR)
		Else
			SetLog($g_sAndroidEmulator & " shared folder not configured for Android", $COLOR_ERROR)
		EndIf
		SetLog($g_sAndroidEmulator & " ADB screen capture disabled", $COLOR_ERROR)
		If BitAND($g_iAndroidSupportFeature, 1) = 0 Then $g_bChkBackgroundMode = False ; disable also background mode the hard way
		$g_bAndroidAdbScreencap = False
	EndIf

	;If $HwND <> WinGetHandle($HwND) Then Return SetError(4, 0) ; Window gone
	Local $wasRunState = $g_bRunState
	AndroidAdbLaunchShellInstance($wasRunState)
	If @error <> 0 Then Return SetError(2, 0)

	Local $sBotTitleEx = StringRegExpReplace($g_sBotTitle, '[/:*?"<>|]', '_')
	Local $Filename = $sBotTitleEx & ".rgba"
	If $g_bAndroidAdbScreencapPngEnabled = True Then $Filename = $sBotTitleEx & ".png"
	$Filename = GetSecureFilename($Filename)
	Local $s

	; Create 32 bits-per-pixel device-independent bitmap (DIB)
	Local $tBIV5HDR = 0
	If $g_bAndroidAdbScreencapPngEnabled = False Then
		$tBIV5HDR = DllStructCreate($tagBITMAPV5HEADER)
		DllStructSetData($tBIV5HDR, 'bV5Size', DllStructGetSize($tBIV5HDR))
		DllStructSetData($tBIV5HDR, 'bV5Width', $iWidth)
		DllStructSetData($tBIV5HDR, 'bV5Height', -$iHeight)
		DllStructSetData($tBIV5HDR, 'bV5Planes', 1)
		DllStructSetData($tBIV5HDR, 'bV5BitCount', 32)
		DllStructSetData($tBIV5HDR, 'biCompression', $BI_RGB)
	EndIf
	Local $pBits = 0
	Local $hHBitmap = 0

	If $g_iAndroidAdbScreencapTimer <> 0 And $g_bForceCapture = False And __TimerDiff($g_iAndroidAdbScreencapTimer) < $g_iAndroidAdbScreencapTimeout And $g_bRunState = True And $iRetryCount = 0 Then
		If $g_bAndroidAdbScreencapPngEnabled = False Then
			$hHBitmap = _WinAPI_CreateDIBSection(0, $tBIV5HDR, $DIB_RGB_COLORS, $pBits)
			$tBIV5HDR = 0 ; Release the resources used by the structure
			DllCall($g_sLibPath & "\helper_functions.dll", "none:cdecl", "RGBA2BGRA", "ptr", DllStructGetPtr($g_aiAndroidAdbScreencapBuffer), "ptr", $pBits, "int", $iLeft, "int", $iTop, "int", $iWidth, "int", $iHeight, "int", $g_iAndroidAdbScreencapWidth, "int", $g_iAndroidAdbScreencapHeight)
			Return $hHBitmap
		ElseIf $g_hAndroidAdbScreencapBufferPngHandle <> 0 Then
			If $iWidth > $g_iAndroidAdbScreencapWidth - $iLeft Then $iWidth = $g_iAndroidAdbScreencapWidth - $iLeft
			If $iHeight > $g_iAndroidAdbScreencapHeight - $iTop Then $iHeight = $g_iAndroidAdbScreencapHeight - $iTop
			Local $hClone = _GDIPlus_BitmapCloneArea($g_hAndroidAdbScreencapBufferPngHandle, $iLeft, $iTop, $iWidth, $iHeight, $GDIP_PXF32ARGB)
			Return _GDIPlus_BitmapCreateDIBFromBitmap($hClone)
		EndIf
	EndIf

	FileDelete($hostPath & $Filename)
	$s = AndroidAdbSendShellCommand("screencap """ & $androidPath & $Filename & """", $g_iAndroidAdbScreencapWaitAdbTimeout, $wasRunState)
	;$s = AndroidAdbSendShellCommand("screencap """ & $androidPath & $filename & """", -1, $wasRunState)
	If $__TEST_ERROR_SLOW_ADB_SCREENCAP_DELAY > 0 Then Sleep($__TEST_ERROR_SLOW_ADB_SCREENCAP_DELAY)
	Local $shellLogInfo = @extended

	Local $hTimer = __TimerInit()
	Local $hFile = 0
	Local $iSize = 0
	Local $iLoopCountFile = 0
	Local $AdbStatsType = 0 ; screencap stats
	Local $iF = 0
	Local $ExpectedFileSize = 1500 ; all blank png is approx 1.5 KByte
	Local $iReadData = 0

	If $g_bAndroidAdbScreencapPngEnabled = False Then
		; default raw RGBA mode

		; Android screencap see:
		; https://android.googlesource.com/platform/frameworks/base/+/jb-release/cmds/screencap/screencap.cpp
		; http://androidsource.top/code/source/system/core/include/system/graphics.h
		; http://androidsource.top/code/source/frameworks/base/include/ui/PixelFormat.h
		Local $tHeader = DllStructCreate("int w;int h;int f")
		Local $iHeaderSize = DllStructGetSize($tHeader)
		Local $iDataSize = DllStructGetSize($g_aiAndroidAdbScreencapBuffer)

		$ExpectedFileSize = $g_iAndroidClientWidth * $g_iAndroidClientHeight * 4 + $iHeaderSize
		If $hFile = 0 Then $hFile = _WinAPI_CreateFile($hostPath & $Filename, 2, 2, 7)
		If $hFile <> 0 Then $iSize = _WinAPI_GetFileSizeEx($hFile)
		Sleep(10)
		; Custom fix - Team__AiO__MOD
		If $wasRunState <> $g_bRunState Then
			If $hFile <> 0 Then _WinAPI_CloseHandle($hFile)
			Return SetError(1, 0)
		EndIf

		Local $iReadHeader = 0
		$g_iAndroidAdbScreencapWidth = 0
		$g_iAndroidAdbScreencapHeight = 0

		If $hFile <> 0 Then
			If $iSize >= $ExpectedFileSize Then
				$hTimer = __TimerInit()
				While $iReadHeader < $iHeaderSize And __TimerDiff($hTimer) < $g_iAndroidAdbScreencapWaitFileTimeout
					If _WinAPI_ReadFile($hFile, $tHeader, $iHeaderSize, $iReadHeader) = True And $iReadHeader = $iHeaderSize Then
						ExitLoop
					Else
						SetDebugLog("Error " & _WinAPI_GetLastError() & ", read " & $iReadHeader & " header bytes, file: " & $hostPath & $Filename, $COLOR_ERROR)
						If $iReadHeader > 0 Then _WinAPI_SetFilePointer($hFile, 0)
						Sleep(10)
					EndIf
				WEnd
				$g_iAndroidAdbScreencapWidth = DllStructGetData($tHeader, "w")
				If $g_iAndroidAdbScreencapWidth > $g_iGAME_WIDTH Then $g_iAndroidAdbScreencapWidth = $g_iGAME_WIDTH
				$g_iAndroidAdbScreencapHeight = DllStructGetData($tHeader, "h")
				If $g_iAndroidAdbScreencapHeight > $g_iGAME_HEIGHT Then $g_iAndroidAdbScreencapHeight = $g_iGAME_HEIGHT
				$iF = DllStructGetData($tHeader, "f")
				$hTimer = __TimerInit()
				If $iSize - $iHeaderSize < $iDataSize Then $iDataSize = $iSize - $iHeaderSize
				While $iReadData < $iDataSize And __TimerDiff($hTimer) < $g_iAndroidAdbScreencapWaitFileTimeout
					If _WinAPI_ReadFile($hFile, $g_aiAndroidAdbScreencapBuffer, $iDataSize, $iReadData) = True And $iReadData = $iDataSize Then
						ExitLoop
					Else
						SetDebugLog("Error " & _WinAPI_GetLastError() & ", read " & $iReadData & " data bytes, file: " & $hostPath & $Filename, $COLOR_ERROR)
						If $iReadData > 0 Then _WinAPI_SetFilePointer($hFile, $iHeaderSize)
						Sleep(10)
					EndIf
				WEnd

				_WinAPI_CloseHandle($hFile)
				$hHBitmap = _WinAPI_CreateDIBSection(0, $tBIV5HDR, $DIB_RGB_COLORS, $pBits)
				DllCall($g_sLibPath & "\helper_functions.dll", "none:cdecl", "RGBA2BGRA", "ptr", DllStructGetPtr($g_aiAndroidAdbScreencapBuffer), "ptr", $pBits, "int", $iLeft, "int", $iTop, "int", $iWidth, "int", $iHeight, "int", $g_iAndroidAdbScreencapWidth, "int", $g_iAndroidAdbScreencapHeight)
			Else
				_WinAPI_CloseHandle($hFile)
				SetDebugLog("File too small (" & $iSize & " < " & $ExpectedFileSize & "): " & $hostPath & $Filename, $COLOR_ERROR)
			EndIf
		EndIf
		If $hFile = 0 Or $iSize < $ExpectedFileSize Or $iReadHeader < $iHeaderSize Or $iReadData < $iDataSize Then
			If $hFile = 0 Then
				
                If $g_bRunState = False Then
                    SetLog("File not found: Try start android first!", $COLOR_ERROR)
                    If $hFile <> 0 Then _WinAPI_CloseHandle($hFile)
                    Return SetError(7, 0)
                Else
                    SetLog("File not found: " & $hostPath & $Filename, $COLOR_ERROR)
                EndIf
				
			Else
				If $iSize <> $ExpectedFileSize Then SetDebugLog("File size " & $iSize & " is not " & $ExpectedFileSize & " for " & $hostPath & $Filename, $COLOR_ERROR)
				SetDebugLog("Captured screen size " & $g_iAndroidAdbScreencapWidth & " x " & $g_iAndroidAdbScreencapHeight, $COLOR_ERROR)
				SetDebugLog("Captured screen bytes read (header/datata): " & $iReadHeader & " / " & $iReadData, $COLOR_ERROR)
			EndIf
			If $iRetryCount < 10 Then
				SetDebugLog("ADB retry screencap in 1000 ms. (restarting ADB session)", $COLOR_ACTION)
				_Sleep(1000)
				AndroidAdbTerminateShellInstance()
				AndroidAdbLaunchShellInstance($wasRunState)
				Return AndroidScreencap($iLeft, $iTop, $iWidth, $iHeight, $iRetryCount + 1)
			EndIf
			SetLog($g_sAndroidEmulator & " screen not captured using ADB", $COLOR_ERROR)
			If $g_aiAndroidAdbStatsTotal[$AdbStatsType][0] < 50 And AndroidControlAvailable() Then
				SetLog($g_sAndroidEmulator & " ADB screen capture disabled", $COLOR_ERROR)
				If BitAND($g_iAndroidSupportFeature, 1) = 0 Then $g_bChkBackgroundMode = False ; disable also background mode the hard way
				$g_bAndroidAdbScreencap = False
			Else
				; reboot Android
				SetLog("Rebooting " & $g_sAndroidEmulator & " due to problems capturing screen", $COLOR_ERROR)
				Local $_NoFocusTampering = $g_bNoFocusTampering
				$g_bNoFocusTampering = True
				RebootAndroid()
				$g_bNoFocusTampering = $_NoFocusTampering
			EndIf
			Return SetError(3, 0)
		EndIf

	Else

		; slower compatible PNG mode for BlueStacks
		If $g_hAndroidAdbScreencapBufferPngHandle <> 0 Then
			_GDIPlus_ImageDispose($g_hAndroidAdbScreencapBufferPngHandle)
			_GDIPlus_BitmapDispose($g_hAndroidAdbScreencapBufferPngHandle) ; dispose old cache
			_WinAPI_DeleteObject($g_hAndroidAdbScreencapBufferPngHandle)
			$g_hAndroidAdbScreencapBufferPngHandle = 0
		EndIf
		Local $hBitmap = 0

		If $hFile = 0 Then $hFile = _WinAPI_CreateFile($hostPath & $Filename, 2, 2, 7)
		If $hFile <> 0 Then $iSize = _WinAPI_GetFileSizeEx($hFile)
		Sleep(10)
		; Custom fix - Team__AiO__MOD
		If $wasRunState <> $g_bRunState Then
			If $hFile <> 0 Then _WinAPI_CloseHandle($hFile)
			Return SetError(1, 0)
		EndIf

		Local $hData = _MemGlobalAlloc($iSize, $GMEM_MOVEABLE)
		Local $pData = _MemGlobalLock($hData)
		Local $tData = DllStructCreate('byte[' & $iSize & ']', $pData)

		While $iSize > 0 And $iReadData < $iSize And __TimerDiff($hTimer) < $g_iAndroidAdbScreencapWaitFileTimeout
			If _WinAPI_ReadFile($hFile, $tData, $iSize, $iReadData) = True And $iReadData = $iSize Then
				ExitLoop
			Else
				SetDebugLog("Error " & _WinAPI_GetLastError() & ", read " & $iReadData & " data bytes, file: " & $hostPath & $Filename, $COLOR_ERROR)
				If $iReadData > 0 Then _WinAPI_SetFilePointer($hFile, 0)
				Sleep(10)
			EndIf
		WEnd
		_WinAPI_CloseHandle($hFile)
		SetDebugLog($iSize, $COLOR_ERROR)

		Local $testTimer = __TimerInit()
		Local $msg = ""
		_MemGlobalUnlock($hData)
		Local $pStream = _WinAPI_CreateStreamOnHGlobal($hData)

		$hBitmap = _GDIPlus_BitmapCreateFromStream($pStream)
		;Local $hBitmap = _GDIPlus_BitmapCreateHBITMAPFromBitmap($hImage)
		;Local $iWidth = _GDIPlus_ImageGetWidth($hImage)
		;Local $iHeight = _GDIPlus_ImageGetHeight($hImage)
		_WinAPI_ReleaseStream($pStream)
		$msg &= ", " & Round(__TimerDiff($testTimer), 2)
		;_GDIPlus_ImageDispose($hImage)


		;_GDIPlus_BitmapCreateFromMemory
		If $hBitmap = 0 Then
			; problem creating Bitmap
			If $iRetryCount < 10 Then
				SetDebugLog("ADB retry screencap in 1000 ms. (restarting ADB session)", $COLOR_ACTION)
				_Sleep(1000)
				AndroidAdbTerminateShellInstance()
				AndroidAdbLaunchShellInstance($wasRunState)
				Return AndroidScreencap($iLeft, $iTop, $iWidth, $iHeight, $iRetryCount + 1)
			EndIf
			SetLog($g_sAndroidEmulator & " screen not captured using ADB", $COLOR_ERROR)
			If FileExists($hostPath & $Filename) = 0 Then SetLog("File not found: " & $hostPath & $Filename, $COLOR_ERROR)
			SetLog($g_sAndroidEmulator & " ADB screen capture disabled", $COLOR_ERROR)
			$g_bAndroidAdbScreencap = False
			Return SetError(5, 0)
		Else
			$g_iAndroidAdbScreencapWidth = _GDIPlus_ImageGetWidth($hBitmap)
			$g_iAndroidAdbScreencapHeight = _GDIPlus_ImageGetHeight($hBitmap)
			$msg &= ", " & Round(__TimerDiff($testTimer), 2)
			;$hImage = _GDIPlus_BitmapCreateFromHBITMAP($hBitmap)
			If $iWidth > $g_iAndroidAdbScreencapWidth - $iLeft Then $iWidth = $g_iAndroidAdbScreencapWidth - $iLeft
			If $iHeight > $g_iAndroidAdbScreencapHeight - $iTop Then $iHeight = $g_iAndroidAdbScreencapHeight - $iTop
			Local $hClone = _GDIPlus_BitmapCloneArea($hBitmap, $iLeft, $iTop, $iWidth, $iHeight, $GDIP_PXF32ARGB)
			$msg &= ", " & Round(__TimerDiff($testTimer), 2)
			If $hClone = 0 Then
				SetDebugLog($g_sAndroidEmulator & " error using " & $g_iAndroidAdbScreencapWidth & "x" & $g_iAndroidAdbScreencapHeight & " on _GDIPlus_BitmapCloneArea(" & $hBitmap & "," & $iLeft & "," & $iTop & "," & $iWidth & "," & $iHeight, $COLOR_ERROR)
				SetLog($g_sAndroidEmulator & " screenshot not available", $COLOR_ERROR)
				SetLog($g_sAndroidEmulator & " ADB screen capture disabled", $COLOR_ERROR)
				$g_bAndroidAdbScreencap = False
				Return SetError(6, 0)
			EndIf
			$g_hAndroidAdbScreencapBufferPngHandle = $hBitmap
			;_GDIPlus_ImageDispose($hBitmap)
			$msg &= ", " & Round(__TimerDiff($testTimer), 2)
			$hHBitmap = _GDIPlus_BitmapCreateDIBFromBitmap($hClone)
			;$hHBitmap = _GDIPlus_BitmapCreateDIBFromBitmap($hBitmap)
		EndIf
	EndIf

	If BitAND($g_iAndroidSecureFlags, 2) = 2 Then
		; delete file
		FileDelete($hostPath & $Filename)
	EndIf

	Local $duration = Int(__TimerDiff($startTimer))
	; dynamically adjust $g_iAndroidAdbScreencapTimeout to 3 x of current duration ($g_iAndroidAdbScreencapTimeoutDynamic)
	$g_iAndroidAdbScreencapTimeout = ($g_iAndroidAdbScreencapTimeoutDynamic = 0 ? $g_iAndroidAdbScreencapTimeoutMax : $duration * $g_iAndroidAdbScreencapTimeoutDynamic)
	If $g_iAndroidAdbScreencapTimeout < $g_iAndroidAdbScreencapTimeoutMin Then $g_iAndroidAdbScreencapTimeout = $g_iAndroidAdbScreencapTimeoutMin
	If $g_iAndroidAdbScreencapTimeout > $g_iAndroidAdbScreencapTimeoutMax Then $g_iAndroidAdbScreencapTimeout = $g_iAndroidAdbScreencapTimeoutMax
	;SetDebugLog("AndroidScreencap (" & $duration & "ms," & $shellLogInfo & "," & $iLoopCountFile & "): l=" & $iLeft & ",t=" & $iTop & ",w=" & $iWidth & ",h=" & $iHeight & ", " & $filename & ": w=" & $g_iAndroidAdbScreencapWidth & ",h=" & $g_iAndroidAdbScreencapHeight & ",f=" & $iF)

	$g_iAndroidAdbScreencapTimer = __TimerInit() ; timeout starts now
	#cs
	; update total stats
	$g_aiAndroidAdbStatsTotal[$AdbStatsType][0] += 1
	$g_aiAndroidAdbStatsTotal[$AdbStatsType][1] += $duration
	Local $iLastCount = UBound($g_aiAndroidAdbStatsLast, 2) - 2
	; Last 10 screencap durations, 0 is sum of durations, 1 is 0-based index to oldest, 2-11 last 10 durations
	If $g_aiAndroidAdbStatsTotal[$AdbStatsType][0] <= $iLastCount Then
		$g_aiAndroidAdbStatsLast[$AdbStatsType][0] += $duration
		$g_aiAndroidAdbStatsLast[$AdbStatsType][$g_aiAndroidAdbStatsTotal[$AdbStatsType][0] + 1] = $duration
		If $g_aiAndroidAdbStatsTotal[$AdbStatsType][0] = $iLastCount Then $g_aiAndroidAdbStatsLast[$AdbStatsType][1] = 0 ; init last index
	Else
		Local $iLastIdx = $g_aiAndroidAdbStatsLast[$AdbStatsType][1] + 2
		$g_aiAndroidAdbStatsLast[$AdbStatsType][0] -= $g_aiAndroidAdbStatsLast[$AdbStatsType][$iLastIdx] ; remove last duration
		$g_aiAndroidAdbStatsLast[$AdbStatsType][0] += $duration ; add current duration
		$g_aiAndroidAdbStatsLast[$AdbStatsType][$iLastIdx] = $duration ; update current duration
		$g_aiAndroidAdbStatsLast[$AdbStatsType][1] = Mod($g_aiAndroidAdbStatsLast[$AdbStatsType][1] + 1, $iLastCount) ; update oldest index
	EndIf
	If $g_aiAndroidAdbStatsLast[$AdbStatsType][1] = 0 Then
		Local $totalAvg = Round($g_aiAndroidAdbStatsTotal[$AdbStatsType][1] / $g_aiAndroidAdbStatsTotal[$AdbStatsType][0])
		Local $lastAvg = Round($g_aiAndroidAdbStatsLast[$AdbStatsType][0] / $iLastCount)
		If $g_bDebugAndroid Or Mod($g_aiAndroidAdbStatsTotal[$AdbStatsType][0], 100) = 0 Then
			SetDebugLog("AdbScreencap: " & $totalAvg & "/" & $lastAvg & "/" & $duration & " ms (all/" & $iLastCount & "/1)," & $shellLogInfo & "," & $iLoopCountFile & ",l=" & $iLeft & ",t=" & $iTop & ",w=" & $iWidth & ",h=" & $iHeight & ", " & $Filename & ": w=" & $g_iAndroidAdbScreencapWidth & ",h=" & $g_iAndroidAdbScreencapHeight & ",f=" & $iF)
		EndIf
	EndIf
	#ce
	$tBIV5HDR = 0 ; Release the resources used by the structure
	Return $hHBitmap
EndFunc   ;==>_AndroidScreencap

Func AndroidZoomOut($loopCount = 0, $timeout = Default, $bMinitouch = Default, $wasRunState = Default)
	Return AndroidAdbScript("ZoomOut", Default, $timeout, $bMinitouch, $wasRunState)
EndFunc   ;==>AndroidZoomOut

Func AndroidAdbScript($scriptTag, $variablesArray = Default, $timeout = Default, $bMinitouch = Default, $wasRunState = Default)
	If $bMinitouch = Default Then $bMinitouch = True
	If $wasRunState = Default Then $wasRunState = $g_bRunState
	ResumeAndroid()
	If $g_bAndroidAdbZoomoutEnabled = False Then Return SetError(4, 0)
	;If $HwND <> WinGetHandle($HwND) Then Return SetError(3, 0) ; Window gone
	AndroidAdbLaunchShellInstance($wasRunState)
	If @error <> 0 Then Return SetError(2, 0, 0)
	If StringInStr($g_sAndroidMouseDevice, "/dev/input/event") = 0 Then Return SetError(2, 0, 0)
	Local $scriptFile = ""
	If $bMinitouch And $scriptFile = "" And FileExists($g_sAdbScriptsPath & "\" & $scriptTag & "." & $g_sAndroidEmulator & ".minitouch") = 1 Then $scriptFile = $scriptTag & "." & $g_sAndroidEmulator & ".minitouch"
	If $scriptFile = "" And FileExists($g_sAdbScriptsPath & "\" & $scriptTag & "." & $g_sAndroidEmulator & ".script") = 1 Then $scriptFile = $scriptTag & "." & $g_sAndroidEmulator & ".script"
	If $scriptFile = "" And FileExists($g_sAdbScriptsPath & "\" & $scriptTag & "." & $g_sAndroidEmulator & ".getevent") = 1 Then $scriptFile = $scriptTag & "." & $g_sAndroidEmulator & ".getevent"
	If Not $bMinitouch And $scriptFile = "" And FileExists($g_sAdbScriptsPath & "\" & $scriptTag & "." & $g_sAndroidEmulator & ".minitouch") = 1 Then $scriptFile = $scriptTag & "." & $g_sAndroidEmulator & ".minitouch"
	If $bMinitouch And $scriptFile = "" And FileExists($g_sAdbScriptsPath & "\" & $scriptTag & ".minitouch") = 1 Then $scriptFile = $scriptTag & ".minitouch"
	If $scriptFile = "" And FileExists($g_sAdbScriptsPath & "\" & $scriptTag & ".script") = 1 Then $scriptFile = $scriptTag & ".script"
	If $scriptFile = "" And FileExists($g_sAdbScriptsPath & "\" & $scriptTag & ".getevent") = 1 Then $scriptFile = $scriptTag & ".getevent"
	If Not $bMinitouch And $scriptFile = "" And FileExists($g_sAdbScriptsPath & "\" & $scriptTag & ".minitouch") = 1 Then $scriptFile = $scriptTag & ".minitouch"
	AndroidAdbSendShellCommandScript($scriptFile, $variablesArray, Default, $timeout, $wasRunState)
	Return SetError(@error, @extended, (@error = 0 ? 1 : 0))
EndFunc   ;==>AndroidAdbScript

Func AndroidClickDrag($x1, $y1, $x2, $y2, $wasRunState = Default, $bSCIDSwitch = False)
	$x1 = Int($x1) + $g_aiMouseOffset[0]
	$y1 = Int($y1) + $g_aiMouseOffset[1]
	$x2 = Int($x2) + $g_aiMouseOffset[0]
	$y2 = Int($y2) + $g_aiMouseOffset[1]
	Execute($g_sAndroidEmulator & "AdjustClickCoordinates($x1,$y1)")
	Execute($g_sAndroidEmulator & "AdjustClickCoordinates($x2,$y2)")
	Local $swipe_coord[4][2] = [["{$x1}", $x1], ["{$y1}", $y1], ["{$x2}", $x2], ["{$y2}", $y2]]
	;Return AndroidAdbScript("clickdrag", $swipe_coord, Default, Default, $wasRunState)
	Return AndroidMinitouchClickDrag($x1, $y1, $x2, $y2, $wasRunState, $bSCIDSwitch)
EndFunc   ;==>AndroidClickDrag

Func AndroidMinitouchClickDrag($x1, $y1, $x2, $y2, $wasRunState = Default, $bSCIDSwitch = False)
	AndroidAdbLaunchShellInstance($wasRunState)
	If $g_iAndroidAdbMinitouchMode = 0 Then
		If $g_bAndroidAdbMinitouchSocket < 1 Then
			SetLog("Minitouch not available", $COLOR_ERROR)
			Return SetError(1, 0, 0)
		EndIf

		TCPRecv($g_bAndroidAdbMinitouchSocket, 256, 1)
		Local $recv_state = [@error, @extended]
		Local $bytes = TCPSend($g_bAndroidAdbMinitouchSocket, @LF)
		Local $send_state = [@error, $bytes]
		If ($recv_state[0] Or $send_state[0] Or $send_state[1] <> 1) Then
			If $wasRunState Then
				SetLog("Cannot send minitouch data to " & $g_sAndroidEmulator & ", received " & $recv_state[1] & ", send " & $send_state[1], $COLOR_ERROR)
				; restart adb session that hopefully fixes the tcp issues
				AndroidAdbTerminateShellInstance()
				Return AndroidMinitouchClickDrag($x1, $y1, $x2, $y2, False)
			EndIf
			Return SetError(1, 0, 0)
		EndIf
	EndIf

	Local $sleepStart = 250
	Local $sleepMove = 10
	Local $sleepEnd = 1000
	Local $sleep = $sleepStart
	Local $botSleep = 0
	Local $send = ""
	Local $screen_w = $g_iGAME_WIDTH
	Local $screen_h = $g_iGAME_HEIGHT
	If $screen_h Then Execute($g_sAndroidEmulator & "AdjustClickCoordinates($screen_w,$screen_h)") ; use $screen_h so it doesn't get sripped away
	Local $steps = Int(($screen_w * 10) / $g_iGAME_WIDTH)
	Local $loops = Int(_Max(Abs($x2 - $x1), Abs($y2 - $y1)) / $steps) + 1
	Local $x_steps = ($x2 - $x1) / $loops
	Local $y_steps = ($y2 - $y1) / $loops
	Local $x = $x1, $y = $y1
	$send = "d 0 " & $x & " " & $y & " 50" & @LF & "c" & @LF & "w " & $sleep & @LF
	$botSleep += $sleep
	If $g_bDebugAndroid Then SetDebugLog("minitouch: " & StringReplace($send, @LF, ";"))
	If $g_iAndroidAdbMinitouchMode = 0 Then
		TCPSend($g_bAndroidAdbMinitouchSocket, $send)
	Else
		AndroidAdbSendMinitouchShellCommand($send)
	EndIf
	If $bSCIDSwitch Then
		$sleep = 50
	Else
		$sleep = $sleepMove
	EndIf
	For $i = 1 To $loops
		$x += $x_steps
		$y += $y_steps
		If ($x2 >= $x1 And $x >= $x2) Or ($x2 < $x1 And $x <= $x2) Then
			$x = $x2
		EndIf
		If ($y2 >= $y1 And $y >= $y2) Or ($y2 < $y1 And $y <= $y2) Then
			$y = $y2
		EndIf
		If Int($x) = $x2 And Int($y) = $y2 Then
			; end reached
			$i = $loops
			; keep touch down longer to avoid further moves
			$sleep = $sleepEnd
		EndIf
		$send = "m 0 " & Int($x) & " " & Int($y) & " 50" & @LF & "c" & @LF & "w " & $sleep & @LF
		$botSleep += $sleep
		If $g_bDebugAndroid Then SetDebugLog("minitouch: " & StringReplace($send, @LF, ";"))
		If $g_iAndroidAdbMinitouchMode = 0 Then
			TCPSend($g_bAndroidAdbMinitouchSocket, $send)
		Else
			AndroidAdbSendMinitouchShellCommand($send)
		EndIf
	Next
	$sleep = $sleepMove
	$send = "u 0" & @LF & "c" & @LF & "w " & $sleep & @LF
	$botSleep += $sleep
	If $g_bDebugAndroid Then SetDebugLog("minitouch: " & StringReplace($send, @LF, ";"))
	If $g_iAndroidAdbMinitouchMode = 0 Then
		TCPSend($g_bAndroidAdbMinitouchSocket, $send)
	Else
		AndroidAdbSendMinitouchShellCommand($send)
	EndIf
	_Sleep($botSleep)

	Return SetError(0, 0, 1)
EndFunc   ;==>AndroidMinitouchClickDrag

; Returns True if KeepClicks is active or for $Really = False KeepClicks() was called even though not enabled (poor mans deploy troops detection)
Func IsKeepClicksActive($Really = True)
	If $Really = True Then
		Return $g_bAndroidAdbClick = True And $g_bAndroidAdbClicksEnabled = True And $g_aiAndroidAdbClicks[0] > -1
	EndIf
	Return $g_bAndroidAdbKeepClicksActive
EndFunc   ;==>IsKeepClicksActive

Func KeepClicks()
	$g_bAndroidAdbKeepClicksActive = True
	If $g_bAndroidAdbClick = False Or $g_bAndroidAdbClicksEnabled = False Then Return False
	If $g_aiAndroidAdbClicks[0] = -1 Then $g_aiAndroidAdbClicks[0] = 0
EndFunc   ;==>KeepClicks

Func ReleaseClicks($minClicksToRelease = 0, $ReleaseClicksEnabled = $g_bAndroidAdbClicksEnabled)
	If $g_bAndroidAdbClick = False Or $ReleaseClicksEnabled = False Then
		$g_bAndroidAdbKeepClicksActive = False
		Return False
	EndIf
	If $g_aiAndroidAdbClicks[0] > 0 And $g_bRunState = True Then
		If $g_aiAndroidAdbClicks[0] >= $minClicksToRelease Then
			AndroidClick(Default, Default, $g_aiAndroidAdbClicks[0], 0)
		Else
			Return False
		EndIf
	EndIf
	ClearClicks()
EndFunc   ;==>ReleaseClicks

Func ClearClicks()
	$g_bAndroidAdbKeepClicksActive = False
	ReDim $g_aiAndroidAdbClicks[1]
	$g_aiAndroidAdbClicks[0] = -1
EndFunc   ;==>ClearClicks

Func AndroidAdbClickSupported()
	Return BitAND($g_iAndroidSupportFeature, 4) = 4
EndFunc   ;==>AndroidAdbClickSupported

Func AndroidClick($x, $y, $times = 1, $speed = 0, $checkProblemAffect = True)
	If Not ($x = Default) Then $x = Int($x) + $g_aiMouseOffset[0]
	If Not ($x = Default) Then $y = Int($y) + $g_aiMouseOffset[1]
	ForceCaptureRegion()
	;AndroidSlowClick($x, $y, $times, $speed)
	;AndroidFastClick($x, $y, $times, $speed, $checkProblemAffect)
	AndroidMinitouchClick($x, $y, $times, $speed, $checkProblemAffect)
EndFunc   ;==>AndroidClick

Func AndroidSlowClick($x, $y, $times = 1, $speed = 0)
	Local $wasRunState = $g_bRunState
	Local $cmd = ""
	Local $i = 0
	$g_iAndroidAdbScreencapTimer = 0 ; invalidate ADB screencap timer/timeout
	AndroidAdbLaunchShellInstance($wasRunState)
	If @error = 0 Then
		For $i = 1 To $times
			$cmd &= "input tap " & $x & " " & $y & ";"
		Next
		Local $timer = __TimerInit()
		AndroidAdbSendShellCommand($cmd, Default, $wasRunState)
		Local $wait = $speed - __TimerDiff($timer)
		If $wait > 0 Then _Sleep($wait, False)
	Else
		Local $error = @error
		SetDebugLog("Disabled " & $g_sAndroidEmulator & " ADB mouse click, error " & $error, $COLOR_ERROR)
		$g_bAndroidAdbClick = False
		Return SetError($error, 0)
	EndIf
EndFunc   ;==>AndroidSlowClick

Func AndroidMoveMouseAnywhere()
	Local $_SilentSetLog = $g_bSilentSetLog
	Local $hostPath = $g_sAndroidPicturesHostPath & $g_sAndroidPicturesHostFolder
	Local $androidPath = $g_sAndroidPicturesPath & StringReplace($g_sAndroidPicturesHostFolder, "\", "/")
	Local $sBotTitleEx = StringRegExpReplace($g_sBotTitle, '[/:*?"<>|]', '_')
	Local $Filename = GetSecureFilename($sBotTitleEx & ".moveaway")
	Local $recordsNum = 4
	Local $iToWrite = $recordsNum * 16
	Local $records = ""

	If FileExists($hostPath & $Filename) = 0 Then
		Local $times = 1
		Local $x = 1 ; $aAway[0]
		Local $y = 40 ; $aAway[1]
		Execute($g_sAndroidEmulator & "AdjustClickCoordinates($x,$y)")
		Local $i = 0
		Local $record = "byte[16];"
		For $i = 1 To $recordsNum * $times
			$records &= $record
		Next

		Local $data = DllStructCreate($records)
		$i = 0
		DllStructSetData($data, 1 + $i * $recordsNum, Binary("0x000000000000000003003500" & StringRight(Hex($x, 4), 2) & StringLeft(Hex($x, 4), 2) & "0000")) ; ABS_MT_POSITION_X
		DllStructSetData($data, 2 + $i * $recordsNum, Binary("0x000000000000000003003600" & StringRight(Hex($y, 4), 2) & StringLeft(Hex($y, 4), 2) & "0000")) ; ABS_MT_POSITION_Y
		DllStructSetData($data, 3 + $i * $recordsNum, Binary("0x00000000000000000000020000000000")) ; SYN_MT_REPORT
		DllStructSetData($data, 4 + $i * $recordsNum, Binary("0x00000000000000000000000000000000")) ; SYN_REPORT
		Local $data2 = DllStructCreate("byte[" & DllStructGetSize($data) & "]", DllStructGetPtr($data))

		Local $iWritten = 0
		Local $hFileOpen = _WinAPI_CreateFile($hostPath & $Filename, 1, 4)
		If $hFileOpen = 0 Then
			Local $error = _WinAPI_GetLastError()
			Return SetError($error, 0)
		EndIf
		_WinAPI_WriteFile($hFileOpen, DllStructGetPtr($data2), $iToWrite, $iWritten)
		_WinAPI_CloseHandle($hFileOpen)
	EndIf

	$g_bSilentSetLog = True
	AndroidAdbSendShellCommand("dd if=""" & $androidPath & $Filename & """ of=" & $g_sAndroidMouseDevice & " obs=" & $iToWrite & ">/dev/null 2>&1", Default)
	If BitAND($g_iAndroidSecureFlags, 2) = 2 Then
		; delete file
		FileDelete($hostPath & $Filename)
	EndIf
	$g_bSilentSetLog = $_SilentSetLog

EndFunc   ;==>AndroidMoveMouseAnywhere

Func AndroidFastClick($x, $y, $times = 1, $speed = 0, $checkProblemAffect = True, $iRetryCount = 0)
	Local $wasAllowed = $g_bTogglePauseAllowed
	$g_bTogglePauseAllowed = False
	Local $Result = _AndroidFastClick($x, $y, $times, $speed, $checkProblemAffect, $iRetryCount)
	$g_bTogglePauseAllowed = $wasAllowed
	Return SetError(@error, @extended, $Result)
EndFunc   ;==>AndroidFastClick

Func _AndroidFastClick($x, $y, $times = 1, $speed = 0, $checkProblemAffect = True, $iRetryCount = 0)
	Local $_SilentSetLog = $g_bSilentSetLog
	Local $hDuration = __TimerInit()
	If $times < 1 Then Return SetError(0, 0)
	Local $i = 0, $j = 0
	Local $Click = [$x, $y, "down-up"]
	Local $aiAndroidAdbClicks
	Local $ReleaseClicks = ($x = Default And $y = Default And $g_aiAndroidAdbClicks[0] > 0)
	If $ReleaseClicks = False And $g_aiAndroidAdbClicks[0] > -1 Then
		Local $pos = $g_aiAndroidAdbClicks[0]
		$g_aiAndroidAdbClicks[0] = $pos + $times
		ReDim $g_aiAndroidAdbClicks[$g_aiAndroidAdbClicks[0] + 1]
		For $i = 1 To $times
			$g_aiAndroidAdbClicks[$pos + $i] = $Click
		Next
		If $g_bDebugAndroid Or $g_bDebugClick Then
			$g_bSilentSetLog = True
			SetDebugLog("Hold back click (" & $x & "/" & $y & " * " & $times & "): queue size = " & $g_aiAndroidAdbClicks[0], $COLOR_ERROR)
			$g_bSilentSetLog = $_SilentSetLog
		EndIf
		Return
	EndIf

	$x = Int($x)
	$y = Int($y)
	Local $wasRunState = $g_bRunState
	Local $hostPath = $g_sAndroidPicturesHostPath & $g_sAndroidPicturesHostFolder
	Local $androidPath = $g_sAndroidPicturesPath & StringReplace($g_sAndroidPicturesHostFolder, "\", "/")

	If $hostPath = "" Or $androidPath = "" Then
		If $hostPath = "" Then
			SetLog($g_sAndroidEmulator & " shared folder not configured for host", $COLOR_ERROR)
		Else
			SetLog($g_sAndroidEmulator & " shared folder not configured for Android", $COLOR_ERROR)
		EndIf
		SetLog($g_sAndroidEmulator & " shared folder not configured for Android", $COLOR_ERROR)
		$g_bAndroidAdbClick = False
		SetLog("Disabled " & $g_sAndroidEmulator & " ADB fast mouse click", $COLOR_ERROR)
		Return SetError(1, 0)
	EndIf

	AndroidAdbLaunchShellInstance($wasRunState)
	#cs
		If @error <> 0 Then
		Local $error = @error
		;SetDebugLog("Disabled " & $g_sAndroidEmulator & " ADB fast mouse click, error " & $error & " (AndroidAdbLaunchShellInstance)" , $COLOR_ERROR)
		;$g_bAndroidAdbClick = False
		$g_bSilentSetLog = True
		SetDebugLog("Cannot use ADB fast mouse click, error " & $error & " (#Err0001)" , $COLOR_ERROR)
		$g_bSilentSetLog = $_SilentSetLog
		Return SetError($error, 0)
		EndIf
	#ce
	Local $sBotTitleEx = StringRegExpReplace($g_sBotTitle, '[/:*?"<>|]', '_')
	Local $Filename = GetSecureFilename($sBotTitleEx & ".click")
	Local $record = "byte[16];"
	Local $records = ""
	Local $loops = 1
	Local $remaining = 0
	Local $adjustSpeed = 0
	Local $timer = __TimerInit()
	If $times > $g_iAndroidAdbClickGroup Then
		$speed = $g_iAndroidAdbClickGroupDelay
		$remaining = Mod($times, $g_iAndroidAdbClickGroup)
		$loops = Int($times / $g_iAndroidAdbClickGroup) + ($remaining > 0 ? 1 : 0)
		$times = $g_iAndroidAdbClickGroup
	Else
		If $ReleaseClicks = False Then $adjustSpeed = $speed
		$speed = 0 ; no need for speed now!
	EndIf
	Local $recordsNum = 10
	Local $recordsClicks = ($times < $g_iAndroidAdbClickGroup ? $times : $g_iAndroidAdbClickGroup)
	For $i = 1 To $recordsNum * $recordsClicks
		$records &= $record
	Next

	If $ReleaseClicks = True Then
		If $g_bDebugAndroid Or $g_bDebugClick Then SetDebugLog("Release clicks: queue size = " & $g_aiAndroidAdbClicks[0])
		Local $aiAndroidAdbClicks = $g_aiAndroidAdbClicks ; create copy of $g_aiAndroidAdbClicks as it could be modified during execution
	Else
		Execute($g_sAndroidEmulator & "AdjustClickCoordinates($x,$y)")
	EndIf

	;SetDebugLog("AndroidFastClick(" & $x & "," & $y & "):" & $s)
	Local $data = DllStructCreate($records)
	For $i = 0 To $recordsClicks - 1
		DllStructSetData($data, 1 + $i * $recordsNum, Binary("0x000000000000000001004a0101000000")) ; BTN_TOUCH DOWN
		DllStructSetData($data, 2 + $i * $recordsNum, Binary("0x000000000000000003003a0001000000")) ; ABS_MT_PRESSURE 1
		;DllStructSetData($data, 3 + $i * $recordsNum, Binary("0x000000000000000003003500" & StringRight(Hex($x, 4),2) & StringLeft(Hex($x, 4),2) & "0000")) ; ABS_MT_POSITION_X
		;DllStructSetData($data, 4 + $i * $recordsNum, Binary("0x000000000000000003003600" & StringRight(Hex($y, 4),2) & StringLeft(Hex($y, 4),2) & "0000")) ; ABS_MT_POSITION_Y
		DllStructSetData($data, 5 + $i * $recordsNum, Binary("0x00000000000000000000020000000000")) ; SYN_MT_REPORT
		DllStructSetData($data, 6 + $i * $recordsNum, Binary("0x00000000000000000000000000000000")) ; SYN_REPORT
		DllStructSetData($data, 7 + $i * $recordsNum, Binary("0x000000000000000001004a0100000000")) ; BTN_TOUCH UP
		DllStructSetData($data, 8 + $i * $recordsNum, Binary("0x000000000000000003003a0000000000")) ; ABS_MT_PRESSURE 0
		DllStructSetData($data, 9 + $i * $recordsNum, Binary("0x00000000000000000000020000000000")) ; SYN_MT_REPORT
		DllStructSetData($data, 10 + $i * $recordsNum, Binary("0x00000000000000000000000000000000")) ; SYN_REPORT
	Next
	;SetDebugLog("AndroidFastClick: $times=" & $times & ", $loops=" & $loops & ", $remaining=" & $remaining)
	Local $AdbStatsType = 1 ; click stats
	Local $data2 = DllStructCreate("byte[" & DllStructGetSize($data) & "]", DllStructGetPtr($data))
	Local $hFileOpen = 0
	Local $iToWrite = DllStructGetSize($data2)
	Local $iWritten = 0
	Local $sleep = ""
	Local $timeSlept = 0
	If $speed > 0 Then
		$sleep = "/system/xbin/sleep " & ($speed / 1000) ; use busy box sleep as it supports milliseconds (if available!)
	EndIf
	For $i = 1 To $loops
		If IsKeepClicksActive(False) = False Then
			If $checkProblemAffect = True Then
				If isProblemAffect(True) Then
					SetDebugLog("VOIDED Click " & $x & "," & $y & "," & $times & "," & $speed, $COLOR_ERROR, "Verdana", "7.5", 0)
					checkMainScreen(False)
					Return ; if need to clear screen do not click
				EndIf
			EndIf
		EndIf
		If $i = $loops And $remaining > 0 Then ; last block with less clicks, create new file
			$iToWrite = (16 * $recordsNum) * $remaining
			$recordsClicks = $remaining
			$hFileOpen = 0
		ElseIf $ReleaseClicks = True Then
			$hFileOpen = 0
		EndIf
		If $hFileOpen = 0 Then
			;$hFileOpen = FileOpen($hostPath & $filename, $FO_BINARY  + $FO_OVERWRITE)
			;FileWrite($hFileOpen, DllStructGetData($data2,1))
			;FileClose($hFileOpen)
			Local $timer = __TimerInit()
			While $hFileOpen = 0 And __TimerDiff($timer) < 3000
				$hFileOpen = _WinAPI_CreateFile($hostPath & $Filename, 1, 4)
				If $hFileOpen <> 0 Then ExitLoop
				SetDebugLog("Error " & _WinAPI_GetLastError() & " (" & Round(__TimerDiff($timer)) & "ms) creating " & $hostPath & $Filename, $COLOR_ERROR)
				Sleep(10)
			WEnd
			If $hFileOpen = 0 Then
				Local $error = _WinAPI_GetLastError()
				SetLog("Error creating " & $hostPath & $Filename, $COLOR_ERROR)
				SetError($error)
				ExitLoop
				#cs
					SetLog("Disabled " & $g_sAndroidEmulator & " ADB fast mouse click due to error " & $error & " (#Err0002)", $COLOR_ERROR)
					$g_bAndroidAdbClick = False
					_WinAPI_CloseHandle($hFileOpen)
					Return SetError($error, 0)
				#ce
			EndIf
			;SetDebugLog("AndroidFastClick: $times=" & $times & ", $loops=" & $loops & ", $remaining=" & $remaining)
			For $j = 0 To $recordsClicks - 1
				Local $BTN_TOUCH_DOWN = True
				Local $BTN_TOUCH_UP = True
				If $ReleaseClicks = True Then
					$Click = $aiAndroidAdbClicks[($i - 1) * $recordsNum + $j + 1] ; fixed Array variable has incorrect number of subscripts
					$x = $Click[0]
					$y = $Click[1]
					Execute($g_sAndroidEmulator & "AdjustClickCoordinates($x,$y)")
					Local $up_down = $Click[2]
					$BTN_TOUCH_DOWN = StringInStr($up_down, "down") > 0
					$BTN_TOUCH_UP = StringInStr($up_down, "up") > 0
				EndIf
				#cs
					DllStructSetData($data, 1 + $i * $recordsNum, Binary("0x000000000000000001004a0101000000")) ; BTN_TOUCH DOWN
					DllStructSetData($data, 2 + $i * $recordsNum, Binary("0x000000000000000003003a0001000000")) ; ABS_MT_PRESSURE 1
					;DllStructSetData($data, 3 + $i * $recordsNum, Binary("0x000000000000000003003500" & StringRight(Hex($x, 4),2) & StringLeft(Hex($x, 4),2) & "0000")) ; ABS_MT_POSITION_X
					;DllStructSetData($data, 4 + $i * $recordsNum, Binary("0x000000000000000003003600" & StringRight(Hex($y, 4),2) & StringLeft(Hex($y, 4),2) & "0000")) ; ABS_MT_POSITION_Y
					DllStructSetData($data, 5 + $i * $recordsNum, Binary("0x00000000000000000000020000000000")) ; SYN_MT_REPORT
					DllStructSetData($data, 6 + $i * $recordsNum, Binary("0x00000000000000000000000000000000")) ; SYN_REPORT
					DllStructSetData($data, 7 + $i * $recordsNum, Binary("0x000000000000000001004a0100000000")) ; BTN_TOUCH UP
					DllStructSetData($data, 8 + $i * $recordsNum, Binary("0x000000000000000003003a0000000000")) ; ABS_MT_PRESSURE 0
					DllStructSetData($data, 9 + $i * $recordsNum, Binary("0x00000000000000000000020000000000")) ; SYN_MT_REPORT
					DllStructSetData($data,10 + $i * $recordsNum, Binary("0x00000000000000000000000000000000")) ; SYN_REPORT
				#ce
				If $BTN_TOUCH_DOWN Then
					;DllStructSetData($data, 1 + $j * $recordsNum, Binary("0x000000000000000001004a0101000000")) ; BTN_TOUCH DOWN
				Else
					DllStructSetData($data, 1 + $j * $recordsNum, Binary("0x00000000000000000000020000000000")) ; SYN_MT_REPORT
					DllStructSetData($data, 2 + $j * $recordsNum, Binary("0x00000000000000000000000000000000")) ; SYN_REPORT
				EndIf
				DllStructSetData($data, 3 + $j * $recordsNum, Binary("0x000000000000000003003500" & StringRight(Hex($x, 4), 2) & StringLeft(Hex($x, 4), 2) & "0000")) ; ABS_MT_POSITION_X
				DllStructSetData($data, 4 + $j * $recordsNum, Binary("0x000000000000000003003600" & StringRight(Hex($y, 4), 2) & StringLeft(Hex($y, 4), 2) & "0000")) ; ABS_MT_POSITION_Y
				If $BTN_TOUCH_UP Then
					;DllStructSetData($data, 6 + $j * $recordsNum, Binary("0x000000000000000001004a0100000000")) ; BTN_TOUCH UP
				Else
					DllStructSetData($data, 7 + $j * $recordsNum, Binary("0x00000000000000000000020000000000")) ; SYN_MT_REPORT
					DllStructSetData($data, 8 + $j * $recordsNum, Binary("0x00000000000000000000000000000000")) ; SYN_REPORT
				EndIf
			Next
			_WinAPI_WriteFile($hFileOpen, DllStructGetPtr($data2), $iToWrite, $iWritten)
			If $hFileOpen = 0 Then
				Local $error = _WinAPI_GetLastError()
				SetLog("Error writing " & $hostPath & $Filename, $COLOR_ERROR)
				SetError($error)
				ExitLoop
				#cs
					SetLog("Disabled " & $g_sAndroidEmulator & " ADB fast mouse click due to error " & $error & " (#Err0003)", $COLOR_ERROR)
					$g_bAndroidAdbClick = False
					Return SetError($error, 0)
				#ce
			EndIf
			_WinAPI_CloseHandle($hFileOpen)
		EndIf
		If $loops > 1 Then
			AndroidMoveMouseAnywhere()
		EndIf
		$g_bSilentSetLog = True
		AndroidAdbSendShellCommand("dd if=""" & $androidPath & $Filename & """ of=" & $g_sAndroidMouseDevice & " obs=" & $iToWrite & ">/dev/null 2>&1", Default)
		If BitAND($g_iAndroidSecureFlags, 2) = 2 Then
			; delete file
			FileDelete($hostPath & $Filename)
		EndIf
		$g_bSilentSetLog = $_SilentSetLog
		Local $sleepTimer = __TimerInit()
		If $speed > 0 Then
			; speed was overwritten with $g_iAndroidAdbClickGroupDelay
			;AndroidAdbSendShellCommand($sleep)
			Local $sleepTime = $speed - __TimerDiff($sleepTimer)
			If $sleepTime > 0 Then _Sleep($sleepTime, False)
		EndIf
		If $adjustSpeed > 0 Then
			; wait remaining time
			Local $wait = Round($adjustSpeed - __TimerDiff($timer))
			If $wait > 0 Then
				If $g_bDebugAndroid Or $g_bDebugClick Then
					$g_bSilentSetLog = True
					SetDebugLog("AndroidFastClick: Sleep " & $wait & " ms.")
					$g_bSilentSetLog = $_SilentSetLog
				EndIf
				_Sleep($wait, False)
			EndIf
		EndIf
		$timeSlept += __TimerDiff($sleepTimer)
		If $g_bRunState = False Then ExitLoop
		If $__TEST_ERROR_SLOW_ADB_CLICK_DELAY > 0 Then Sleep($__TEST_ERROR_SLOW_ADB_CLICK_DELAY)
		;If $speed > 0 Then Sleep($speed)
	Next
	If @error <> 0 Then
		Local $error = @error
		If $iRetryCount < 10 Then
			SetError(0, 0, 0)
			SetDebugLog("ADB retry sending mouse click in 1000 ms. (restarting ADB session)", $COLOR_ACTION)
			_Sleep(1000)
			AndroidAdbTerminateShellInstance()
			AndroidAdbLaunchShellInstance($wasRunState)
			Return AndroidFastClick($x, $y, $times, $speed, $checkProblemAffect, $iRetryCount + 1)
		EndIf
		If $g_aiAndroidAdbStatsTotal[$AdbStatsType][0] < 10 Then
			SetLog("Disabled " & $g_sAndroidEmulator & " ADB fast mouse click due to error " & $error & " (#Err0004)", $COLOR_ERROR)
			$g_bAndroidAdbClick = False
		Else
			; reboot Android
			SetLog("Rebooting " & $g_sAndroidEmulator & " due to problems sending mouse click", $COLOR_ERROR)
			Local $_NoFocusTampering = $g_bNoFocusTampering
			$g_bNoFocusTampering = True
			RebootAndroid()
			$g_bNoFocusTampering = $_NoFocusTampering
		EndIf
		Return SetError($error, 0)
	EndIf
	If IsKeepClicksActive(False) = False Then ; Invalidate ADB screencap (not when troops are deployed to speed up clicks)
		$g_iAndroidAdbScreencapTimer = 0 ; invalidate ADB screencap timer/timeout
	EndIf
	#cs
	; update total stats
	Local $duration = Round((__TimerDiff($hDuration) - $timeSlept) / $loops)
	$g_aiAndroidAdbStatsTotal[$AdbStatsType][0] += 1
	$g_aiAndroidAdbStatsTotal[$AdbStatsType][1] += $duration
	Local $iLastCount = UBound($g_aiAndroidAdbStatsLast, 2) - 2
	; Last 10 screencap durations, 0 is sum of durations, 1 is 0-based index to oldest, 2-11 last 10 durations
	If $g_aiAndroidAdbStatsTotal[$AdbStatsType][0] <= $iLastCount Then
		$g_aiAndroidAdbStatsLast[$AdbStatsType][0] += $duration
		$g_aiAndroidAdbStatsLast[$AdbStatsType][$g_aiAndroidAdbStatsTotal[$AdbStatsType][0] + 1] = $duration
		If $g_aiAndroidAdbStatsTotal[$AdbStatsType][0] = $iLastCount Then $g_aiAndroidAdbStatsLast[$AdbStatsType][1] = 0 ; init last index
	Else
		Local $iLastIdx = $g_aiAndroidAdbStatsLast[$AdbStatsType][1] + 2
		$g_aiAndroidAdbStatsLast[$AdbStatsType][0] -= $g_aiAndroidAdbStatsLast[$AdbStatsType][$iLastIdx] ; remove last duration
		$g_aiAndroidAdbStatsLast[$AdbStatsType][0] += $duration ; add current duration
		$g_aiAndroidAdbStatsLast[$AdbStatsType][$iLastIdx] = $duration ; update current duration
		$g_aiAndroidAdbStatsLast[$AdbStatsType][1] = Mod($g_aiAndroidAdbStatsLast[$AdbStatsType][1] + 1, $iLastCount) ; update oldest index
	EndIf
	If $g_aiAndroidAdbStatsLast[$AdbStatsType][1] = 0 Then
		Local $totalAvg = Round($g_aiAndroidAdbStatsTotal[$AdbStatsType][1] / $g_aiAndroidAdbStatsTotal[$AdbStatsType][0])
		Local $lastAvg = Round($g_aiAndroidAdbStatsLast[$AdbStatsType][0] / $iLastCount)
		If $g_bDebugAndroid Or $g_bDebugClick Or Mod($g_aiAndroidAdbStatsTotal[$AdbStatsType][0], 100) = 0 Then
			SetDebugLog("AndroidFastClick: " & $totalAvg & "/" & $lastAvg & "/" & $duration & " ms (all/" & $iLastCount & "/1), $x=" & $x & ", $y=" & $y & ", $times=" & $times & ", $speed = " & $speed & ", $checkProblemAffect=" & $checkProblemAffect)
		EndIf
	EndIf
	#ce
EndFunc   ;==>_AndroidFastClick

; User for docked mouse touches, $iaAction: 0 = move, 1 = down, 2 = up
; return bytes sent
Func Minitouch($x, $y, $iAction = 0, $iDelay = 1)
	If $g_iAndroidAdbMinitouchMode = 0 Then
		If $g_bAndroidAdbMinitouchSocket < 1 Then Return -1
	EndIf

	Static $x_dn, $y_dn
	$x = Int($x)
	$y = Int($y)
	Execute($g_sAndroidEmulator & "AdjustClickCoordinates($x,$y)")

	Local $iBytes = 0
	Local $s
	Local $t = ""
	Local $sWait = "" ; "w 1" & @LF
	Switch $iAction
		Case 0, 2 ; move or up
			If $iAction = 0 Or $x_dn <> $x Or $y_dn <> $y Then
				$s = "m 0 " & $x & " " & $y & " 50" & @LF & "c" & @LF & $sWait
				$t &= $s
				If $g_iAndroidAdbMinitouchMode = 0 Then
					$iBytes += TCPSend($g_bAndroidAdbMinitouchSocket, $s)
				Else
					AndroidAdbSendMinitouchShellCommand($s)
					If @error Then
						Return SetError(@error, 0, 0)
					Else
						$iBytes += StringLen($s)
					EndIf
				EndIf
			EndIf
			If $iAction = 2 Then ; up
				;$s = "w " & $iDelay & @LF & "u 0 " & @LF & "c" & @LF
				$s = "u 0 " & @LF & "c" & @LF & $sWait
				;For $i = 1 To 9
				;	$s &= "u " & $i & @LF & "c" & @LF
				;Next
				$t &= $s
				If $g_iAndroidAdbMinitouchMode = 0 Then
					$iBytes += TCPSend($g_bAndroidAdbMinitouchSocket, $s)
				Else
					AndroidAdbSendMinitouchShellCommand($s)
					If @error Then
						Return SetError(@error, 0, 0)
					Else
						$iBytes += StringLen($s)
					EndIf
				EndIf
			EndIf
		Case 1 ; down
			;$s = "d 0 " & $x & " " & $y & " 50" & @LF & "w " & $iDelay & @LF & "c" & @LF
			$s = "d 0 " & $x & " " & $y & " 50" & @LF & "c" & @LF & $sWait
			$t &= $s
			If $g_iAndroidAdbMinitouchMode = 0 Then
				$iBytes += TCPSend($g_bAndroidAdbMinitouchSocket, $s)
			Else
				AndroidAdbSendMinitouchShellCommand($s)
				If @error Then
					Return SetError(@error, 0, 0)
				Else
					$iBytes += StringLen($s)
				EndIf
			EndIf
			$x_dn = $x
			$y_dn = $y
	EndSwitch

	If $g_bDebugAndroid Then
		SetDebugLog("Minitouch: " & StringReplace($t, @LF, ";"), $COLOR_INFO, True)
	EndIf

	Return $iBytes
EndFunc   ;==>Minitouch

Func AndroidMinitouchClick($x, $y, $times = 1, $speed = 0, $checkProblemAffect = True, $iRetryCount = 0)
	Local $minSleep = GetClickDownDelay()
	Local $iDelay = GetClickUpDelay()
	Local $_SilentSetLog = $g_bSilentSetLog
	Local $hDuration = __TimerInit()
	If $times < 1 Then Return SetError(0, 0)
	Local $iTimesCopy = $times
	Local $i = 0, $j = 0
	Local $Click = [$x, $y, "down-up"]
	Local $aiAndroidAdbClicks
	Local $ReleaseClicks = ($x = Default And $y = Default And $g_aiAndroidAdbClicks[0] > 0)
	If $ReleaseClicks = False And $g_aiAndroidAdbClicks[0] > -1 Then
		Local $pos = $g_aiAndroidAdbClicks[0]
		$g_aiAndroidAdbClicks[0] = $pos + $times
		ReDim $g_aiAndroidAdbClicks[$g_aiAndroidAdbClicks[0] + 1]
		For $i = 1 To $times
			$g_aiAndroidAdbClicks[$pos + $i] = $Click
		Next
		If $g_bDebugAndroid Or $g_bDebugClick Then
			$g_bSilentSetLog = True
			SetDebugLog("Hold back click (" & $x & "/" & $y & " * " & $times & "): queue size = " & $g_aiAndroidAdbClicks[0], $COLOR_ERROR)
			$g_bSilentSetLog = $_SilentSetLog
		EndIf
		Return
	EndIf

	Local $bytes = 0
	Local $bytesSent = 0
	Local $wasRunState = $g_bRunState
	Local $hostPath = $g_sAndroidPicturesHostPath & $g_sAndroidPicturesHostFolder
	Local $androidPath = $g_sAndroidPicturesPath & StringReplace($g_sAndroidPicturesHostFolder, "\", "/")

	If $hostPath = "" Or $androidPath = "" Then
		If $hostPath = "" Then
			SetLog($g_sAndroidEmulator & " shared folder not configured for host", $COLOR_ERROR)
		Else
			SetLog($g_sAndroidEmulator & " shared folder not configured for Android", $COLOR_ERROR)
		EndIf
		SetLog($g_sAndroidEmulator & " shared folder not configured for Android", $COLOR_ERROR)
		$g_bAndroidAdbClick = False
		SetLog("Disabled " & $g_sAndroidEmulator & " ADB fast mouse click", $COLOR_ERROR)
		Return SetError(1, 0)
	EndIf

	AndroidAdbLaunchShellInstance($wasRunState)
	If $g_iAndroidAdbMinitouchMode = 0 Then
		;$g_bAndroidAdbMinitouchSocket = TCPConnect("127.0.0.1", $g_bAndroidAdbMinitouchPort)
		If $g_bAndroidAdbMinitouchSocket < 1 Then
			$g_bAndroidAdbClick = False
			SetLog("Disabled " & $g_sAndroidEmulator & " ADB fast mouse click", $COLOR_ERROR)
			Return SetError(1, 0)
		EndIf

		TCPRecv($g_bAndroidAdbMinitouchSocket, 256, 1)
		Local $recv_state = [@error, @extended]
		$bytes = TCPSend($g_bAndroidAdbMinitouchSocket, @LF)
		Local $send_state = [@error, $bytes]
		If ($recv_state[0] Or $send_state[0] Or $send_state[1] <> 1) Then
			SetLog("Cannot send minitouch data to " & $g_sAndroidEmulator & ", received " & $recv_state[1] & ", send " & $send_state[1], $COLOR_ERROR)
			If $iRetryCount < 1 Then
				; restart adb session that hopefully fixes the tcp issues
				AndroidAdbTerminateShellInstance()
				Return AndroidMinitouchClick($x, $y, $times, $speed, $checkProblemAffect, $iRetryCount + 1)
			EndIf
			Return SetError(1, 0)
		EndIf
	EndIf

	; consistency check
	Local $ReleaseClicksCheck = ($x = Default And $y = Default And $g_aiAndroidAdbClicks[0] > 0)
	If $ReleaseClicks <> $ReleaseClicksCheck Then
		SetDebugLog("AndroidMinitouchClick: Release clicks condition changed from " & $ReleaseClicks & " to " & $ReleaseClicksCheck)
		Return AndroidMinitouchClick($x, $y, $times, $speed, $checkProblemAffect, $iRetryCount)
	EndIf

	$x = Int($x)
	$y = Int($y)
	Local $loops = 1
	Local $remaining = 0
	Local $adjustSpeed = 0
	Local $timer = __TimerInit()
	If $times > $g_iAndroidAdbClickGroup Then
		$speed = $speed + $g_iAndroidAdbClickGroupDelay
		$remaining = Mod($times, $g_iAndroidAdbClickGroup)
		$loops = Int($times / $g_iAndroidAdbClickGroup) + ($remaining > 0 ? 1 : 0)
		$times = $g_iAndroidAdbClickGroup
	Else
		If $ReleaseClicks = False Then $adjustSpeed = $speed
		;$speed = 0 ; no need for speed now!
	EndIf
	Local $recordsClicks = ($times < $g_iAndroidAdbClickGroup ? $times : $g_iAndroidAdbClickGroup)
	If $ReleaseClicks = True Then
		If $g_bDebugAndroid Or $g_bDebugClick Then SetDebugLog("Release clicks: queue size = " & $g_aiAndroidAdbClicks[0])
		Local $aiAndroidAdbClicks = $g_aiAndroidAdbClicks ; create copy of $g_aiAndroidAdbClicks as it could be modified during execution
	Else
		Execute($g_sAndroidEmulator & "AdjustClickCoordinates($x,$y)")
	EndIf

	;SetDebugLog("AndroidFastClick: $times=" & $times & ", $loops=" & $loops & ", $remaining=" & $remaining)
	Local $AdbStatsType = 1 ; click stats
	Local $timeSlept = 0
	For $i = 1 To $loops
		If IsKeepClicksActive(False) = False Then
			If $checkProblemAffect = True Then
				If isProblemAffect(True) Then
					SetDebugLog("VOIDED Click " & $x & "," & $y & "," & $times & "," & $speed, $COLOR_ERROR, "Verdana", "7.5", 0)
					checkMainScreen(False)
					Return ; if need to clear screen do not click
				EndIf
			EndIf
		EndIf
		If $i = $loops And $remaining > 0 Then ; last block with less clicks, create new file
			$recordsClicks = $remaining
		ElseIf $ReleaseClicks = True Then
		EndIf
		Local $sleepTimer = __TimerInit()
		If True Then
			;SetDebugLog("AndroidFastClick: $times=" & $times & ", $loops=" & $loops & ", $remaining=" & $remaining)
			For $j = 0 To $recordsClicks - 1
				Local $BTN_TOUCH_DOWN = True
				Local $BTN_TOUCH_UP = True
				If $ReleaseClicks = True Then
					$Click = $aiAndroidAdbClicks[($i - 1) * $recordsClicks + $j + 1] ; seen here incorrect number of subscripts error
					$x = $Click[0]
					$y = $Click[1]
					Execute($g_sAndroidEmulator & "AdjustClickCoordinates($x,$y)")
					Local $up_down = $Click[2]
					$BTN_TOUCH_DOWN = StringInStr($up_down, "down") > 0
					$BTN_TOUCH_UP = StringInStr($up_down, "up") > 0
				EndIf
				Local $send = ""
				$bytes = 0
				$bytesSent = 0
				If $BTN_TOUCH_DOWN Then
					; down
					$send &= "d 0 " & $x & " " & $y & " 50" & @LF
					$send &= "c" & @LF
					If $g_iAndroidAdbMinitouchMode = 0 Then
						$bytes += TCPSend($g_bAndroidAdbMinitouchSocket, $send)
						$bytesSent += StringLen($send)
					Else
						AndroidAdbSendMinitouchShellCommand($send)
					EndIf
				EndIf

				If $BTN_TOUCH_UP Then
					$send = ""
					; wait
					Local $sleep = $minSleep
					If $speed > $minSleep Then
						$sleep = $speed
					EndIf
					;TCPSend($g_bAndroidAdbMinitouchSocket, "w " & $sleep & @CRLF)
					;_SleepMicro($sleep * 1000)
					; up
					$send &= "w " & $sleep & @LF
					If $g_iAndroidAdbMinitouchMode = 0 Then
						$bytes += TCPSend($g_bAndroidAdbMinitouchSocket, $send)
						$bytesSent += StringLen($send)
					Else
						AndroidAdbSendMinitouchShellCommand($send)
					EndIf
					$send = ""
					$send &= "u 0" & @LF
					$send &= "c" & @LF
					$send &= "w " & $iDelay & @LF
					;$send &= "w " & $iDelay & @LF
					If $g_iAndroidAdbMinitouchMode = 0 Then
						$bytes += TCPSend($g_bAndroidAdbMinitouchSocket, $send)
						$bytesSent += StringLen($send)
					Else
						AndroidAdbSendMinitouchShellCommand($send)
					EndIf
					_SleepMicro(($iDelay + $sleep) * 1000)
					If $g_bDebugClick Then SetDebugLog("minitouch: d 0 " & $x & " " & $y & " "  & $iTimesCopy & ", speed=" & $sleep & ", delay=" & $iDelay)
					;_SleepMicro(10000)
				EndIf

				If $g_iAndroidAdbMinitouchMode = 0 Then
					If $bytes < $bytesSent Then SetDebugLog("minitouch: Failed to send " & ($bytesSent - $bytes) & " bytes!", $COLOR_ERROR)
				EndIf
				;TCPRecv($g_bAndroidAdbMinitouchSocket, 256, 1)
			Next
		EndIf
		$g_bSilentSetLog = True
		$g_bSilentSetLog = $_SilentSetLog
		If False Then
			; disabled for now
			If $speed > 0 Then
				; speed was overwritten with $g_iAndroidAdbClickGroupDelay
				;AndroidAdbSendShellCommand($sleep)
				If $g_bDebugClick Then SetDebugLog("minitouch: wait between group clicks: " & $speed & " ms.")
				$send = "w " & $speed & @LF
				If $g_iAndroidAdbMinitouchMode = 0 Then
					$bytes += TCPSend($g_bAndroidAdbMinitouchSocket, $send)
				Else
					AndroidAdbSendMinitouchShellCommand($send)
				EndIf
				_SleepMicro($speed * 1000)
				;Local $sleepTime = $speed - __TimerDiff($sleepTimer)
				;If $sleepTime > 0 Then _Sleep($sleepTime, False)
			EndIf
			If $adjustSpeed > 0 Then
				; wait remaining time
				Local $wait = Round($adjustSpeed - __TimerDiff($timer))
				If $wait > 0 Then
					If $g_bDebugAndroid Or $g_bDebugClick Then
						$g_bSilentSetLog = True
						SetDebugLog("AndroidMinitouchClick: Sleep " & $wait & " ms.")
						$g_bSilentSetLog = $_SilentSetLog
					EndIf
					_Sleep($wait, False)
				EndIf
			EndIf
		EndIf
		$timeSlept += __TimerDiff($sleepTimer)
		If $g_bRunState = False Then ExitLoop
		If $__TEST_ERROR_SLOW_ADB_CLICK_DELAY > 0 Then Sleep($__TEST_ERROR_SLOW_ADB_CLICK_DELAY)
		;If $speed > 0 Then Sleep($speed)
	Next
	;TCPSend($g_bAndroidAdbMinitouchSocket, "r" & @CRLF)
	;TCPSend($g_bAndroidAdbMinitouchSocket, "c" & @CRLF)
	;_SleepMicro($minSleep * 1000)
	;TCPCloseSocket($g_bAndroidAdbMinitouchSocket)
	;$g_bAndroidAdbMinitouchSocket = 0

	If IsKeepClicksActive(False) = False Then ; Invalidate ADB screencap (not when troops are deployed to speed up clicks)
		$g_iAndroidAdbScreencapTimer = 0 ; invalidate ADB screencap timer/timeout
	EndIf
	
	#cs
	; update total stats
	Local $duration = Round((__TimerDiff($hDuration) - $timeSlept) / $loops)
	$g_aiAndroidAdbStatsTotal[$AdbStatsType][0] += 1
	$g_aiAndroidAdbStatsTotal[$AdbStatsType][1] += $duration
	Local $iLastCount = UBound($g_aiAndroidAdbStatsLast, 2) - 2
	; Last 10 screencap durations, 0 is sum of durations, 1 is 0-based index to oldest, 2-11 last 10 durations
	If $g_aiAndroidAdbStatsTotal[$AdbStatsType][0] <= $iLastCount Then
		$g_aiAndroidAdbStatsLast[$AdbStatsType][0] += $duration
		$g_aiAndroidAdbStatsLast[$AdbStatsType][$g_aiAndroidAdbStatsTotal[$AdbStatsType][0] + 1] = $duration
		If $g_aiAndroidAdbStatsTotal[$AdbStatsType][0] = $iLastCount Then $g_aiAndroidAdbStatsLast[$AdbStatsType][1] = 0 ; init last index
	Else
		Local $iLastIdx = $g_aiAndroidAdbStatsLast[$AdbStatsType][1] + 2
		$g_aiAndroidAdbStatsLast[$AdbStatsType][0] -= $g_aiAndroidAdbStatsLast[$AdbStatsType][$iLastIdx] ; remove last duration
		$g_aiAndroidAdbStatsLast[$AdbStatsType][0] += $duration ; add current duration
		$g_aiAndroidAdbStatsLast[$AdbStatsType][$iLastIdx] = $duration ; update current duration
		$g_aiAndroidAdbStatsLast[$AdbStatsType][1] = Mod($g_aiAndroidAdbStatsLast[$AdbStatsType][1] + 1, $iLastCount) ; update oldest index
	EndIf
	If $g_aiAndroidAdbStatsLast[$AdbStatsType][1] = 0 Then
		Local $totalAvg = Round($g_aiAndroidAdbStatsTotal[$AdbStatsType][1] / $g_aiAndroidAdbStatsTotal[$AdbStatsType][0])
		Local $lastAvg = Round($g_aiAndroidAdbStatsLast[$AdbStatsType][0] / $iLastCount)
		If $g_bDebugAndroid Or $g_bDebugClick Or Mod($g_aiAndroidAdbStatsTotal[$AdbStatsType][0], 100) = 0 Then
			SetDebugLog("AndroidMinitouchClick: " & $totalAvg & "/" & $lastAvg & "/" & $duration & " ms (all/" & $iLastCount & "/1), $x=" & $x & ", $y=" & $y & ", $times=" & $times & ", $speed = " & $speed & ", $checkProblemAffect=" & $checkProblemAffect)
		EndIf
	EndIf
	#ce
EndFunc   ;==>AndroidMinitouchClick

Func AndroidSendText($sText, $SymbolFix = False, $wasRunState = $g_bRunState)
	AndroidAdbLaunchShellInstance($wasRunState)
	Local $error = @error
	If $error = 0 Then
		; replace space with %s and remove/replace umlaut and non-english characters
		; still ? and * will be treated as file wildcards... might need to be replaced as well
		Local $newText = $sText
		StringRegExpReplace($newText, "[^A-Za-z0-9\.,\?""!@#\$%\^&\*\(\)-_=\+;:<>\/\\\|\}\{\[\]'~ ]", ".")
		If @extended <> 0 Then
			If $SymbolFix = False Then SetDebugLog("Cannot use ADB to send input text, use Windows method", $COLOR_ERROR)
			Return SetError(10, 0)
		EndIf
		If $SymbolFix = False Then
			If $g_iAndroidAdbInputWordsCharLimit = 0 Then
				; send entire text at once
				; escape special characters
				$newText = StringRegExpReplace($newText, "([\\\?""\$\^&\*\(\)\+<>\|'~;])", "\\$1")
				; replace " " with "%s"
				$newText = StringReplace($newText, " ", "%s")
				AndroidAdbSendShellCommand("input text " & $newText, 6000, $wasRunState) ; use 6 secs for additional timeout
			Else
				; send one word per command
				Local $words = StringSplit($newText, " ")
				Local $i, $word, $newWord
				For $i = 1 To $words[0]
					$word = $words[$i]
					While StringLen($word) > 0
						; escape special characters
						$newWord = StringRegExpReplace(StringLeft($word, $g_iAndroidAdbInputWordsCharLimit), "([\\\?""\$\^&\*\(\)\+<>\|'~;])", "\\$1")
						AndroidAdbSendShellCommand("input text " & $newWord, 6000, $wasRunState) ; use 6 secs for additional timeout
						$word = StringMid($word, $g_iAndroidAdbInputWordsCharLimit + 1)
					WEnd
					; send space
					If $i < $words[0] Then AndroidAdbSendShellCommand("input text %s", Default, $wasRunState)
				Next
			EndIf
		Else
			AndroidAdbSendShellCommand("input text %s", Default, $wasRunState)
		EndIf
		SetError(0, 0)
	Else
		If $SymbolFix = False Then
			SetDebugLog("Disabled " & $g_sAndroidEmulator & " ADB input due to error", $COLOR_ERROR)
			$g_bAndroidAdbInput = False
		EndIf
		Return SetError($error, 0)
	EndIf
EndFunc   ;==>AndroidSendText

Func AndroidSwipeNotWorking($x1, $y1, $x2, $y2, $wasRunState = $g_bRunState) ; This swipe is not working... but might in future with same fixing...
	$x1 = Int($x1)
	$y1 = Int($y1)
	$x2 = Int($x2)
	$y2 = Int($y2)
	If $g_bAndroidAdbClick = False Then
		Return SetError(-1, 0)
	EndIf
	AndroidAdbLaunchShellInstance($wasRunState)
	If @error = 0 Then
		ReleaseClicks()
		ReDim $g_aiAndroidAdbClicks[11]
		$g_aiAndroidAdbClicks[0] = 10
		Local $Click = [$x1, $y1, "down"]
		$g_aiAndroidAdbClicks[1] = $Click
		For $i = 1 To 8
			Local $Click = [$x1 + Int($i * ($x2 - $x1) / 9), $y1 + Int($i * ($y2 - $y1) / 9), ""]
			$g_aiAndroidAdbClicks[$i + 1] = $Click
		Next
		Local $Click = [$x2, $y2, "up"]
		$g_aiAndroidAdbClicks[10] = $Click
		SetDebugLog("AndroidSwipe: " & $x1 & "," & $y1 & "," & $x2 & "," & $y2)
		ReleaseClicks(0, True)
		Return SetError(@error, 0)
	Else
		Local $error = @error
		;SetDebugLog("Disabled " & $g_sAndroidEmulator & " ADB input due to error", $COLOR_ERROR)
		;$g_bAndroidAdbInput = False
		Return SetError($error, 0)
	EndIf
EndFunc   ;==>AndroidSwipeNotWorking

#Region - Custom fix - Team AIO Mod++
Func AndroidInputSwipe($x1, $y1, $x2, $y2, $wasRunState = $g_bRunState, $bPrecise = False)
	AndroidAdbLaunchShellInstance($wasRunState)
	Local $iMultiplicator = ($bPrecise = False) ? (9) : (12.5)
	Local $iSleep = _Max(Ceiling(Pixel_Distance($x1, $y1, $x2, $y2) * $iMultiplicator), 1000)
	If @error = 0 Then
		androidadbsendshellcommand("input swipe " & $x1 & " " & $y1 & " " & $x2 & " " & $y2 & " " & $iSleep & ";", $iSleep + 5000, $wasRunState) ; use 6 secs for additional timeout
		SetError(0, 0)
	Else
		Local $error = @error
		SetDebugLog("Disabled " & $g_sAndroidEmulator & " ADB input due to error", $COLOR_ERROR)
		$g_bAndroidAdbInput = False
		Return SetError($error, 0)
	EndIf
EndFunc   ;==>AndroidInputSwipe
#EndRegion - Custom fix - Team AIO Mod++

Func SuspendAndroidTime($Action = False)
	If IsBool($Action) And $Action = True Then
		Local $iTime = $g_iSuspendAndroidTime
		$g_iSuspendAndroidTime = 0
		$g_iSuspendAndroidTimeCount = 0
		$g_hSuspendAndroidTimer = 0
		Return $iTime
	ElseIf $Action = False Then
		Return $g_iSuspendAndroidTime
	EndIf
	If $g_hSuspendAndroidTimer = 0 Then
		; nothing to add
	ElseIf $Action = "Stats" Then
		; debug stats
		SetDebugLog("SuspendAndroidTime: Time = " & $g_iSuspendAndroidTime & ", Count = " & $g_iSuspendAndroidTimeCount)
	Else
		; Did tests on EBO battle count-down, and for some reason 50ms need to be removed here... hope works for other systems, too
		Local $iSuspendTime = (_HPTimerDiff($g_hSuspendAndroidTimer) - 50)
		If $iSuspendTime > 0 Then
			$g_iSuspendAndroidTime += $iSuspendTime
			$g_iSuspendAndroidTimeCount += 1
		EndIf
		$g_hSuspendAndroidTimer = 0
	EndIf
	If $Action = "Start" Then $g_hSuspendAndroidTimer = _HPTimerInit()
	Return $g_iSuspendAndroidTime
EndFunc   ;==>SuspendAndroidTime

Func SuspendAndroid($SuspendMode = True, $bDebugLog = Default, $bForceSuspendAndroid = False)
	If $bDebugLog = Default Then $bDebugLog = $g_bDebugAndroid
	If ($g_bAndroidSuspendedEnabled = False Or $g_iAndroidSuspendModeFlags = 0) And $bForceSuspendAndroid = False Then Return False
	; it would significantly increase re-connection error during cloud search, also never clearing clouds can happen, so disable android suspend when in clouds
	Local $bSuspendAllowed = Not $g_bCloudsActive And $g_bMainWindowOk And (($g_iAndroidSuspendModeFlags = 1 And ($g_bAttackActive Or $g_bVillageSearchActive)) Or $g_iAndroidSuspendModeFlags >= 2)
	If Not $bSuspendAllowed And $bForceSuspendAndroid = False Then
		; ensure android is not suspended
		If $g_bAndroidSuspended Then
			; used to disable android suspend during cloud search, as that can freeze the search
			Return ResumeAndroid($bDebugLog, $bForceSuspendAndroid)
		EndIf
		Return False
	EndIf
	If $SuspendMode = False Then Return ResumeAndroid($bDebugLog, $bForceSuspendAndroid)
	If $g_bAndroidSuspended = True Then Return True
	Local $bSuspendProcess = BitAND($g_iAndroidSuspendModeFlags, 4) = 0
	If $bSuspendProcess = True Then
		; Suspend CoC Process
		If $g_iAndroidCoCPid = 0 Then $g_iAndroidCoCPid = GetAndroidProcessPID(Default, False)
		If $g_iAndroidCoCPid = 0 Then
			SuspendAndroidTime(True) ; reset timer
			Return False
		EndIf
		Local $s = AndroidAdbSendShellCommand("kill -STOP " & $g_iAndroidCoCPid, 0) ; suspend CoC
		If StringInStr($s, "No such process") > 0 Then
			$g_iAndroidCoCPid = GetAndroidProcessPID(Default, False)
			If $g_iAndroidCoCPid = 0 Then
				SuspendAndroidTime(True) ; reset timer
				Return False
			EndIf
			$s = AndroidAdbSendShellCommand("kill -STOP " & $g_iAndroidCoCPid, 0) ; suspend CoC
		EndIf
		$g_bAndroidSuspended = True
	Else
		; Suspend entire Android
		Local $pid = GetAndroidSvcPid()
		If $pid = -1 Or $pid = 0 Then $pid = GetAndroidPid()
		If $pid = -1 Or $pid = 0 Then
			SuspendAndroidTime(True) ; reset timer
			Return False
		EndIf
		;AndroidAdbSendShellCommand("input keyevent 26") ; sleep android
		$g_bAndroidSuspended = True
		_ProcessSuspendResume($pid, True) ; suspend Android
		$g_iAndroidSuspendedTimer = __TimerInit()
	EndIf
	SuspendAndroidTime("Start")
	If $bDebugLog = True Then SetDebugLog("Android Suspended")
	Return False
EndFunc   ;==>SuspendAndroid

Func ResumeAndroid($bDebugLog = Default, $bForceSuspendAndroid = False)
	If $bDebugLog = Default Then $bDebugLog = $g_bDebugAndroid
	If ($g_bAndroidSuspendedEnabled = False Or $g_iAndroidSuspendModeFlags = 0) And $bForceSuspendAndroid = False Then Return False
	If $g_bAndroidSuspended = False Then Return False
	Local $bSuspendProcess = BitAND($g_iAndroidSuspendModeFlags, 4) = 0
	SuspendAndroidTime("Stop")
	If $bSuspendProcess = True Then
		; Resume CoC Process
		$g_bAndroidSuspended = False
		If $g_iAndroidCoCPid = 0 Then $g_iAndroidCoCPid = GetAndroidProcessPID(Default, False)
		If $g_iAndroidCoCPid = 0 Then
			SuspendAndroidTime(True) ; reset timer
			Return False
		EndIf
		Local $s = AndroidAdbSendShellCommand("kill -CONT " & $g_iAndroidCoCPid) ; suspend CoC
		If StringInStr($s, "No such process") > 0 Then
			$g_iAndroidCoCPid = GetAndroidProcessPID(Default, False)
			If $g_iAndroidCoCPid = 0 Then
				SuspendAndroidTime(True) ; reset timer
				Return False
			EndIf
			$s = AndroidAdbSendShellCommand("kill -CONT " & $g_iAndroidCoCPid) ; suspend CoC
		EndIf
		If $bDebugLog = True Then SetDebugLog("Android Resumed")
	Else
		; Resume entire Android
		Local $pid = GetAndroidSvcPid()
		If $pid = -1 Or $pid = 0 Then $pid = GetAndroidPid()
		If $pid = -1 Or $pid = 0 Then
			SuspendAndroidTime(True) ; reset timer
			Return False
		EndIf
		$g_bAndroidSuspended = False
		_ProcessSuspendResume($pid, False) ; resume Android
		;AndroidAdbSendShellCommand("input keyevent 26") ; wake android
		$g_aiAndroidTimeLag[3] += __TimerDiff($g_iAndroidSuspendedTimer) ; calculate total suspended time
		If $bDebugLog = True Then SetDebugLog("Android Resumed (total time " & Round($g_aiAndroidTimeLag[3]) & " ms)")
	EndIf
	Return True
EndFunc   ;==>ResumeAndroid

Func AndroidCloseSystemBar()
	If AndroidInvalidState() Then Return False
	Local $wasRunState = $g_bRunState
	AndroidAdbLaunchShellInstance($wasRunState)
	If @error <> 0 Then
		SetLog("Cannot close " & $g_sAndroidEmulator & " System Bar", $COLOR_ERROR)
		Return False
	EndIf
	Local $cmdOutput = AndroidAdbSendShellCommand("service call activity 42 s16 com.android.systemui", Default, $wasRunState, False)
	Local $Result = StringLeft($cmdOutput, 6) = "Result"
	SetDebugLog("Closed " & $g_sAndroidEmulator & " System Bar: " & $Result)
	Return $Result
EndFunc   ;==>AndroidCloseSystemBar

Func AndroidOpenSystemBar($bZygote = False)
	If AndroidInvalidState() Then Return False
	Local $wasRunState = $g_bRunState
	AndroidAdbLaunchShellInstance($wasRunState)
	If @error <> 0 Then
		SetLog("Cannot open " & $g_sAndroidEmulator & " System Bar", $COLOR_ERROR)
		Return False
	EndIf
	Local $cmdOutput
	Local $Result
	If $bZygote = True Then
		$cmdOutput = AndroidAdbSendShellCommand("setprop ctl.restart zygote", Default, $wasRunState, False)
		$Result = $cmdOutput = ""
	Else
		$cmdOutput = AndroidAdbSendShellCommand("am startservice -n com.android.systemui/.SystemUIService", Default, $wasRunState, False)
		$Result = StringLeft($cmdOutput, 16) = "Starting service"
		SetDebugLog("Opened " & $g_sAndroidEmulator & " System Bar: " & $Result)
	EndIf
	Return $Result
EndFunc   ;==>AndroidOpenSystemBar

Func RedrawAndroidWindow()
	Local $Result = Execute("Redraw" & $g_sAndroidEmulator & "Window()")
	If $Result = "" And @error <> 0 Then
		; Not implemented, use default implementation
		_WinAPI_RedrawWindow($g_hAndroidWindow, 0, 0, $RDW_INVALIDATE + $RDW_ALLCHILDREN)
		_WinAPI_SetWindowPos($g_hAndroidWindow, 0, 0, 0, 0, 0, BitOR($SWP_NOMOVE, $SWP_NOSIZE, $SWP_FRAMECHANGED)) ; redraw
		_WinAPI_UpdateWindow($g_hAndroidWindow)
	EndIf
	Return $Result
EndFunc   ;==>RedrawAndroidWindow

Func AndroidQueueReboot($bQueueReboot = True)
	$g_bAndroidQueueReboot = $bQueueReboot
EndFunc   ;==>AndroidQueueReboot

Func AndroidInvalidState()
	If $g_hAndroidWindow = 0 Then
		SetDebugLog("AndroidInvalidState: No Window Handle", $COLOR_ERROR)
		Return True
	EndIf
	If IsHWnd($g_hAndroidWindow) And WinGetHandle($g_hAndroidWindow, "") = 0 Then
		SetDebugLog("AndroidInvalidState: Window Handle " & $g_hAndroidWindow & " doesn't exist", $COLOR_ERROR)
		Return True
	EndIf
	If IsHWnd($g_hAndroidWindow) = False And IsNumber($g_hAndroidWindow) And $g_bAndroidBackgroundLaunched = False Then
		SetDebugLog("AndroidInvalidState: PID " & $g_hAndroidWindow & " not supported for Headless Mode", $COLOR_ERROR)
		Return True
	EndIf
	If $g_bAndroidBackgroundLaunched = True And ProcessExists2($g_hAndroidWindow) = 0 Then
		SetDebugLog("AndroidInvalidState: PID " & $g_hAndroidWindow & " doesn't exist", $COLOR_ERROR)
		Return True
	EndIf
	; all seems ok
	Return False
EndFunc   ;==>AndroidInvalidState

Func CheckAndroidReboot($bRebootAndroid = True)

	If CheckAndroidTimeLag($bRebootAndroid) = True _
			Or CheckAndroidPageError($bRebootAndroid) = True _
			Or CheckAndroidRebootCondition($bRebootAndroid) = True Then

		; Reboot Android
		Local $_NoFocusTampering = $g_bNoFocusTampering
		$g_bNoFocusTampering = True
		RebootAndroid()
		$g_bNoFocusTampering = $_NoFocusTampering
		Return True

	EndIf

	Return False

EndFunc   ;==>CheckAndroidReboot

Func GetAndroidProcessPID($sPackage = Default, $bForeground = True, $iRetryCount = 0)
	If $sPackage = Default Then $sPackage = $g_sAndroidGamePackage
	; - USER  - PID - PPID  - VSS  - RSS  -   PRIO - NICE - RTPRIO - SCHED - WCHAN  - EIP    - STATE - NAME
	; u0_a58    4395  580   1135308 187040     14    -6        0      0     ffffffff 00000000    S      com.supercell.clashofclans
	; u0_a27    2912  142   663800  98656      30    10        0      3     ffffffff b7591617    S      com.tencent.tmgp.supercell.clashofclans
	; u0_a26    2740  73    1601704 76380      20    0         0      0     ffffffff b7489435    S      com.supercell.clashofclans.guopan
	;USER      PID   PPID  VSIZE  RSS  PRIO  NICE  RTPRI SCHED  WCHAN            PC  NAME
	;u0_a54    12560 84    1336996 189660 10    -10   0     0     futex_wait b7725424 S com.supercell.clashofclans
	;u0_a54    13303 84    1338548 188464 16    -4    0     0     sys_epoll_ b7725424 S com.supercell.clashofclans
	If AndroidInvalidState() Then Return 0
	Local $cmd = "set result=$(ps -p|grep """ & $g_sAndroidGamePackage & """ >&2)"
	Local $output = AndroidAdbSendShellCommand($cmd)
	Local $error = @error
	SetError(0)
	If $error = 0 Then
		SetDebugLog("$g_sAndroidGamePackage: " & $g_sAndroidGamePackage)
		SetDebugLog("GetAndroidProcessPID StdOut :" & $output)
		$output = StringStripWS($output, 7)
		Local $aPkgList[0][26] ; adjust to any suffisent size to accommodate
		Local $iCols
		_ArrayAdd($aPkgList, $output, 0, " ", @LF, $ARRAYFILL_FORCE_STRING)

		Local $CorrectSCHED = "0"
		Switch $g_sAndroidGamePackage
			Case $g_sAndroidGamePackage = "com.tencent.tmgp.supercell.clashofclans"
				; scheduling policy : SCHED_BATCH = 3
				$CorrectSCHED = "3"
			Case Else
				; scheduling policy : SCHED_NORMAL = 0
				$CorrectSCHED = "0"
		EndSwitch

		For $i = 1 To UBound($aPkgList)
			$iCols = _ArraySearch($aPkgList, "", 0, 0, 0, 0, 1, $i, True)
			If $iCols > 9 And $aPkgList[$i - 1][$iCols - 1] = $g_sAndroidGamePackage Then
				; process running
				If $bForeground = True And $aPkgList[$i - 1][8] <> $CorrectSCHED Then
					; not foreground
					If $iRetryCount < 2 Then
						; retry 2 times
						Sleep(100)
						Return GetAndroidProcessPID($sPackage, $bForeground, $iRetryCount + 1)
					EndIf
					SetDebugLog("Android process " & $sPackage & " not running in foreground")
					Return 0
				EndIf
				Return Int($aPkgList[$i - 1][1])
			EndIf
		Next
	EndIf
	If $iRetryCount < 2 Then
		; retry 2 times
		Sleep(100)
		Return GetAndroidProcessPID($sPackage, $bForeground, $iRetryCount + 1)
	EndIf
	SetDebugLog("Android process " & $sPackage & " not running")
	Return SetError($error, 0, 0)
EndFunc   ;==>GetAndroidProcessPID

Func AndroidToFront($hHWndAfter = Default, $sSource = "Unknown")
	If $hHWndAfter = Default Then $hHWndAfter = $HWND_TOPMOST
	SetDebugLog("AndroidToFront: Source " & $sSource)
	WinMove2(GetAndroidDisplayHWnD(), "", -1, -1, -1, -1, $hHWndAfter, 0, False)
	If $g_bChkBackgroundMode And ($hHWndAfter = $HWND_TOPMOST Or $hHWndAfter = $HWND_TOP) Then WinMove2(GetAndroidDisplayHWnD(), "", -1, -1, -1, -1, $HWND_NOTOPMOST, 0, False)
EndFunc   ;==>AndroidToFront

Func ShowAndroidWindow($hHWndAfter = Default, $bRestorePosAndActivateWindow = Default, $bFastCheck = Default, $sSource = "Unknown")
	Return HideAndroidWindow(False, $bRestorePosAndActivateWindow, $bFastCheck, $sSource & "->ShowAndroidWindow", $hHWndAfter)
EndFunc   ;==>ShowAndroidWindow

Func HideAndroidWindow($bHide = True, $bRestorePosAndActivateWhenShow = Default, $bFastCheck = Default, $sSource = "Unknown", $hHWndAfter = Default)
	If $bFastCheck = Default Then $bFastCheck = True
	If $hHWndAfter = Default Then $hHWndAfter = $HWND_TOPMOST
	;SetDebugLog("HideAndroidWindow: " & $bHide & ", " & $bRestorePosAndActivateWhenShow & ", " & $bFastCheck & ", " & $sSource)

	ResumeAndroid()
	SetError(0)
	If $bFastCheck Then
		If Not IsHWnd($g_hAndroidWindow) Then SetError(1)
	Else
		WinGetAndroidHandle() ; updates android position
		WinGetPos($g_hAndroidWindow)
	EndIf
	If @error <> 0 Or AndroidEmbedded() Then Return SetError(0, 0, 0)

	If $bHide = True Then
		WinMove($g_hAndroidWindow, "", -32000, -32000)
	ElseIf $bHide = False Then
		Switch $bRestorePosAndActivateWhenShow
			Case True
				; move and activate
				WinMove($g_hAndroidWindow, "", $g_iAndroidPosX, $g_iAndroidPosY)
				WinActivate($g_hAndroidWindow)
			Case False
				; don't move, only when hidden
				Local $a = WinGetPos($g_hAndroidWindow)
				If UBound($a) > 1 And ($a[0] < -30000 Or $a[1] < -30000) Then WinMove($g_hAndroidWindow, "", $g_iAndroidPosX, $g_iAndroidPosY)
				_WinAPI_ShowWindow($g_hAndroidWindow, @SW_SHOWNOACTIVATE)
			Case Default
				; just move
				Local $a = WinGetPos($g_hAndroidWindow)
				If UBound($a) > 1 And ($a[0] <> $g_iAndroidPosX Or $a[1] <> $g_iAndroidPosY) Then WinMove($g_hAndroidWindow, "", $g_iAndroidPosX, $g_iAndroidPosY)
		EndSwitch
		If $hHWndAfter <> $g_hAndroidWindow Then AndroidToFront($hHWndAfter, $sSource & "->HideAndroidWindow")
	EndIf
	Execute("Hide" & $g_sAndroidEmulator & "Window($bHide, $hHWndAfter)")
	SetError(0)
EndFunc   ;==>HideAndroidWindow

Func AndroidPicturePathAutoConfig($myPictures = Default, $subDir = Default, $bSetLog = Default)
	If $subDir = Default Then $subDir = $g_sAndroidEmulator & " Photo"
	If $bSetLog = Default Then $bSetLog = True
	Local $Result = False
	Local $path
	If $g_bAndroidPicturesPathAutoConfig = True Then
		If $g_sAndroidPicturesHostPath = "" Then
			If $myPictures = Default Then $myPictures = RegRead("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders\", "My Pictures")
			If @error = 0 And FileExists($myPictures) = 1 Then
				If $subDir <> "" Then $subDir = "\" & $subDir
				$path = $myPictures & $subDir
				; add tailing backslash
				If StringRight($path, 1) <> "\" Then $path &= "\"
				If FileExists($path) = 1 Then
					$g_sAndroidPicturesHostPath = $path
					SetGuiLog("Shared folder: '" & $g_sAndroidPicturesHostPath & "' will be added to " & $g_sAndroidEmulator, $COLOR_SUCCESS, $bSetLog)
					$Result = True
				ElseIf DirCreate($path) = 1 Then
					$g_sAndroidPicturesHostPath = $path
					SetGuiLog("Configure " & $g_sAndroidEmulator & " to support shared folder", $COLOR_SUCCESS, $bSetLog)
					SetGuiLog("Folder created: " & $path, $COLOR_SUCCESS, $bSetLog)
					SetGuiLog("This shared folder will be added to " & $g_sAndroidEmulator, $COLOR_SUCCESS, $bSetLog)
					$Result = True
				Else
					SetGuiLog("Cannot configure " & $g_sAndroidEmulator & " shared folder", $COLOR_SUCCESS, $bSetLog)
					SetGuiLog("Cannot create folder: " & $path, $COLOR_ERROR, $bSetLog)
					$g_bAndroidPicturesPathAutoConfig = False
				EndIf
			Else
				SetGuiLog("Cannot configure " & $g_sAndroidEmulator & " shared folder", $COLOR_SUCCESS, $bSetLog)
				SetGuiLog("Cannot find current user 'My Pictures' folder", $COLOR_ERROR, $bSetLog)
				$g_bAndroidPicturesPathAutoConfig = False
			EndIf
		Else
			$path = $g_sAndroidPicturesHostPath
			If FileExists($path) = 1 Then
				; path exists, nothing to do
			ElseIf DirCreate($path) = 1 Then
				SetGuiLog("Shared folder created: " & $path, $COLOR_SUCCESS, $bSetLog)
				$Result = True
			Else
				SetGuiLog("Cannot configure " & $g_sAndroidEmulator & " shared folder", $COLOR_SUCCESS, $bSetLog)
				SetGuiLog("Cannot create folder: " & $path, $COLOR_ERROR, $bSetLog)
				$g_bAndroidPicturesPathAutoConfig = False
			EndIf
		EndIf
	EndIf
	Return $Result
EndFunc   ;==>AndroidPicturePathAutoConfig

Func ConfigureSharedFolder($iMode = 0, $bSetLog = Default)
	If $bSetLog = Default Then $bSetLog = True
	Local $Result = Execute("ConfigureSharedFolder" & $g_sAndroidEmulator & "(" & $iMode & "," & $bSetLog & ")")
	If Not ($Result = "" And @error <> 0) Then
		Return $Result
	EndIf

	; Not implemented, use default
	Local $bResult = False

	Switch $iMode
		Case 0 ; check that shared folder is configured in VM
			Local $aRegexResult = StringRegExp($__VBoxVMinfo, "Name: '" & $g_sAndroidSharedFolderName & "', Host path: '(.*)'.*", $STR_REGEXPARRAYGLOBALMATCH)
			If Not @error Then
				$bResult = True
				$g_bAndroidSharedFolderAvailable = True
				$g_sAndroidPicturesHostPath = $aRegexResult[UBound($aRegexResult) - 1] & "\"
			Else
				SetLog($g_sAndroidEmulator & " shared folder is not available", $COLOR_ERROR)
				$g_sAndroidPicturesHostPath = ""
				$g_bAndroidAdbScreencap = False
				$g_bAndroidSharedFolderAvailable = False
			EndIf
		Case 1 ; create missing shared folder
			$bResult = AndroidPicturePathAutoConfig(Default, Default, $bSetLog)
		Case 2 ; Configure VM and add missing shared folder
			If $g_bAndroidSharedFolderAvailable = False And $g_bAndroidPicturesPathAutoConfig = True And FileExists($g_sAndroidPicturesHostPath) = 1 Then
				Local $cmdOutput, $process_killed
				Local $path = $g_sAndroidPicturesHostPath
				; remove tailing backslash
				If StringRight($path, 1) = "\" Then $path = StringLeft($path, StringLen($path) - 1)
				$cmdOutput = LaunchConsole($__VBoxManage_Path, "sharedfolder remove " & $g_sAndroidInstance & " --name " & $g_sAndroidSharedFolderName, $process_killed)
				$cmdOutput = LaunchConsole($__VBoxManage_Path, "sharedfolder add " & $g_sAndroidInstance & " --name " & $g_sAndroidSharedFolderName & " --hostpath """ & $path & """  --automount", $process_killed)
				$bResult = True
			EndIf
	EndSwitch

	Return SetError(0,0, $bResult)
EndFunc

Func OpenAdbShell()
	Local $bWasRunState = $g_bRunState
	$g_bRunState = True
	Local $Result = _OpenAdbShell()
	$g_bRunState = $bWasRunState
	Return $Result
EndFunc   ;==>OpenAdbShell

Func _OpenAdbShell($bRunInitScript = True, $bAdbInstanceShellOptions = True, $bAdbShellOptions = True)
	; Ensure Android is running
	CheckAndroidRunning(True, True, True)
	; Ensure ADB daemon is running
	If ConnectAndroidAdb(True, True) = False Then
		SetLog("Cannot open ADB Shell, ADB connection not available", $COLOR_ERROR)
		Return 0
	EndIf
	Local $param = AddSpace($g_sAndroidAdbGlobalOptions) & "-s " & $g_sAndroidAdbDevice & " shell"
	If $bAdbInstanceShellOptions Then $param &= $g_sAndroidAdbInstanceShellOptions
	If $bAdbShellOptions Then $param &= $g_sAndroidAdbShellOptions
	Local $iPid = ShellExecute($g_sAndroidAdbPath, $param)
	SetLog("Launched ADB Shell, PID=" & $iPid & ": """ & $g_sAndroidAdbPath & """ " & $param)
	Local $hWnd = 0
	Local $hTimer = __TimerInit()
	Do
		If $hWnd = 0 Then _Sleep(100, True, False)
		Local $winlist = WinList()
		For $i = 1 To $winlist[0][0]
			If $winlist[$i][0] <> "" Then
				If WinGetProcess($winlist[$i][1]) = $iPid Then
					$hWnd = $winlist[$i][1]
					SetDebugLog("Launched ADB Shell, found Window Handle " & $hWnd)
					ExitLoop
				EndIf
			EndIf
		Next
	Until $hWnd <> 0 Or __TimerDiff($hTimer) > 3000

	If $hWnd <> 0 Then
		; update title with instance name
		_WinAPI_SetWindowText($hWnd, "ADB Shell: " & $g_sAndroidEmulator & " (" & $g_sAndroidInstance & "), Device = " & $g_sAndroidAdbDevice)
		_WinAPI_SetConsoleIcon($g_sLibIconPath, $eIcnGUI, $hWnd)
	Else
		SetLog("Cannot find ADB Shell Window, try again...")
		If $bAdbInstanceShellOptions And $g_sAndroidAdbInstanceShellOptions Then Return _OpenAdbShell($bRunInitScript, False, $bAdbShellOptions)
		If $bAdbShellOptions And $g_sAndroidAdbShellOptions Then Return _OpenAdbShell($bRunInitScript, $bAdbInstanceShellOptions, False)
	EndIf
	If $hWnd <> 0 And $g_iAndroidAdbSuCommand <> "" Then
		ControlSend($hWnd, "", "", "{ENTER}") ; first send just enter (required for BlueStacks N)
		SetLog("Send Shell command: " & $g_iAndroidAdbSuCommand)
		ControlSend($hWnd, "", "", $g_iAndroidAdbSuCommand & "{ENTER}")
		ControlSend($hWnd, "", "", "{ENTER}")
		ControlSend($hWnd, "", "", "{ENTER}")
	EndIf
	Return $iPid
EndFunc   ;==>_OpenAdbShell

Func OpenPlayStore($sPackage)
	; Ensure Android is running
	CheckAndroidRunning(True, True, True)
	; Ensure ADB daemon is running
	If ConnectAndroidAdb(True, True) = False Then
		SetLog("Cannot open Play Store, ADB connection not available", $COLOR_ERROR)
		Return 0
	EndIf
	SetLog("Open Play Store App '" & $sPackage & "'", $COLOR_INFO)
	AndroidAdbSendShellCommand("am start -a android.intent.action.VIEW -d 'market://details?id=" & $sPackage & "'")
EndFunc   ;==>OpenPlayStore

Func OpenPlayStoreGame()
	Return OpenPlayStore($g_sUserGamePackage)
EndFunc   ;==>OpenPlayStoreGame

Func OpenPlayStoreGooglePlayServices()
	Return OpenPlayStore("com.google.android.gms")
EndFunc   ;==>OpenPlayStoreGooglePlayServices

Func OpenPlayStoreNovaLauncher()
	Return OpenPlayStore("com.teslacoilsw.launcher")
EndFunc   ;==>OpenPlayStoreNovaLauncher

Func LaunchAndroid($sProgramPath, $sCmdParam, $sPath, $iWaitInSecAfterLaunch = Default, $bStopIfLaunchFails = True)
	If $iWaitInSecAfterLaunch = Default Then $iWaitInSecAfterLaunch = 10
	If $sCmdParam And StringLeft($sCmdParam, 1) <> " " Then
		$sCmdParam = " " & $sCmdParam
	EndIf
		; if shared folder is not available, configure it
		If Not $g_sAndroidPicturesHostPath Then
			SetScreenAndroid()
		EndIf
	SetLog("Please wait while " & $g_sAndroidEmulator & " and CoC start...", $COLOR_SUCCESS)
	Local $pid = 0
	;$PID = ShellExecute($g_sAndroidProgramPath, $cmdPar, $__MEmu_Path)
	For $i = 1 To 3
		SetDebugLog("LaunchAndroid: " & $sProgramPath & $sCmdParam)
		$pid = Run($sProgramPath & $sCmdParam, $sPath)
		If _Sleep(3000) Then Return False
		If $pid <> 0 Then $pid = ProcessExists($pid)
		If $pid <> 0 Then ExitLoop
	Next

	SetDebugLog("$PID= " & $pid)
	If $pid = 0 And $bStopIfLaunchFails = True Then ; IF ShellExecute failed
		SetLog("Unable to load " & $g_sAndroidEmulator & ($g_sAndroidInstance = "" ? "" : "(" & $g_sAndroidInstance & ")") & ", please check emulator/installation.", $COLOR_ERROR)
		SetLog("Unable to continue........", $COLOR_WARNING)
		btnStop()
		SetError(1, 1, -1)
		Return 0
	EndIf

	If $iWaitInSecAfterLaunch > 0 Then
		_SleepStatus($iWaitInSecAfterLaunch * 1000)
	EndIf

	Return $pid

EndFunc   ;==>LaunchAndroid

Func UpdateAndroidBackgroundMode()
	; update Android Brackground Mode support
	Local $iMode = (($g_iAndroidBackgroundMode = 0) ? ($g_iAndroidBackgroundModeDefault) : ($g_iAndroidBackgroundMode))
	Local $iBackgroundMode = Execute("Get" & $g_sAndroidEmulator & "BackgroundMode()")
	If $iBackgroundMode = "" And @error <> 0 Then
		; Not implemented
		Local $sMode = "Unknown"
		Switch $iMode
			Case $g_iAndroidBackgroundModeDirectX
				$sMode = "DirectX/WinAPI"
			Case $g_iAndroidBackgroundModeOpenGL
				$sMode = "OpenGL/ADB screencap"
		EndSwitch
		SetLog($g_sAndroidEmulator & " DirectX/OpenGL cannot be detected")
		SetLog("Using " & $sMode & " for Background Mode")
	Else
		; update Android Background supported modes
		Local $sGraphicsEngine = "Unknown"
		Switch $iBackgroundMode
			Case $g_iAndroidBackgroundModeDirectX
				$sGraphicsEngine = "DirectX"
				SetDebugLog($g_sAndroidEmulator & " (" & $g_sAndroidInstance & ") is using DirectX, enable WinAPI for Background Mode")
				AndroidSupportFeaturesSet(1) ; enabled DirectX Background Mode
			Case $g_iAndroidBackgroundModeOpenGL
				$sGraphicsEngine = "OpenGL"
				SetDebugLog($g_sAndroidEmulator & " (" & $g_sAndroidInstance & ") is using OpenGL, disable WinAPI for Background Mode")
				AndroidSupportFeaturesRemove(1) ; disabled DirectX Background Mode
			Case Else
				; using default mode
				$iMode = $g_iAndroidBackgroundModeDefault
				Local $sMode = "Unknown"
				Switch $iMode
					Case $g_iAndroidBackgroundModeDirectX
						$sMode = "DirectX/WinAPI"
					Case $g_iAndroidBackgroundModeOpenGL
						$sMode = "OpenGL/ADB screencap"
				EndSwitch
				SetLog($g_sAndroidEmulator & " (" & $g_sAndroidInstance & ") unsupported Graphics Engine / Render Mode, using " & $sMode, $COLOR_WARNING)
		EndSwitch
	EndIf

	Switch $iMode
		Case 1 ; WinAPI mode (faster, but requires Android DirectX)
			If BitAND($g_iAndroidSupportFeature, 1) = 0 Then
				If BitAND($g_iAndroidSupportFeature, 2) > 0 Then
					SetLog("Android DirectX not available, using ADB screencap for background capture", $COLOR_WARNING)
				Else
					SetLog("Android DirectX and ADB screencap not available, Background Mode not supported", $COLOR_ERROR)
				EndIf
			Else
				; Ok, disable screencap
				SetDebugLog("Disable ADB screencap, using WinAPI DirectX for Background Mode")
				$g_bAndroidAdbScreencap = False
			EndIf
		Case 2 ; ADB screencap mode (slower, but alwasy works even if Monitor is off -> "True Brackground Mode")
			If $g_bAndroidAdbScreencapEnabled <> True Or $g_bAndroidSharedFolderAvailable <> True Then
				SetLog("Android ADB screencap disabled, please check Android Options", $COLOR_ERROR)
			Else
				If BitAND($g_iAndroidSupportFeature, 2) = 0 Then
					If BitAND($g_iAndroidSupportFeature, 1) > 0 Then
						SetLog("Android ADB screencap not available, using WinAPI for background capture", $COLOR_WARNING)
					Else
						SetLog("Android ADB screencap and DirectX not available, Background Mode not supported", $COLOR_ERROR)
					EndIf
				Else
					; Ok, enable screencap
					SetDebugLog("Enable ADB screencap for Background Mode")
					$g_bAndroidAdbScreencap = $g_bAndroidAdbScreencapEnabled = True And BitAND($g_iAndroidSupportFeature, 2) = 2 ; Use Android ADB to capture screenshots in RGBA raw format
				EndIf
			EndIf
		Case Else
			SetLog("Unsupported Android Background Mode " & $iMode, $COLOR_ERROR)
	EndSwitch

	; update background checkbox
	UpdateChkBackground()
EndFunc   ;==>UpdateAndroidBackgroundMode

#Region - Team__AiO__MOD
Func getAndroidcodename($iapi = $g_iAndroidversionapi)
	If $iapi >= $g_iAndroidpie Then Return "Pie"
	If $iapi >= $g_iAndroidoreo Then Return "Oreo"
	If $iapi >= $g_iAndroidnougat Then Return "Nougat"
	If $iapi >= $g_iAndroidlollipop Then Return "Lollipop"
	If $iapi >= $g_iAndroidkitkat Then Return "KitKat"
	If $iapi >= $g_iAndroidjellybean Then Return "JellyBean"
	SetDebugLog("Unsupported Android API Version: " & $iapi, $COLOR_ERROR)
	Return ""
EndFunc
#EndRegion - Team__AiO__MOD

Func HaveSharedPrefs($sProfile = $g_sProfileCurrentName, $BothNewOrOld = Default, $bReturnArray = False)
	If $sProfile = Default Then $sProfile = $g_sProfileCurrentName
	If Not $bReturnArray Then
		Return (($BothNewOrOld = Default Or $BothNewOrOld = True) And UBound(_FileListToArray($g_sPrivateProfilePath & "\" & $sProfile & "\shared_prefs", "*", $FLTA_FILES)) > 1) _
				Or (($BothNewOrOld = Default Or $BothNewOrOld = False) And UBound(_FileListToArray($g_sProfilePath & "\" & $sProfile & "\shared_prefs", "*", $FLTA_FILES)) > 1)
	EndIf
	; return array
	Local $aFiles
	If $BothNewOrOld = Default Or $BothNewOrOld = True Then
		$aFiles = _FileListToArray($g_sPrivateProfilePath & "\" & $sProfile & "\shared_prefs", "*", $FLTA_FILES, True)
	EndIf
	If ($BothNewOrOld = Default And UBound($aFiles) < 2) Or $BothNewOrOld = False Then
		$aFiles = _FileListToArray($g_sProfilePath & "\" & $sProfile & "\shared_prefs", "*", $FLTA_FILES, True)
	EndIf
	If UBound($aFiles) < 1 Then Local $aFiles = [0]
	Return SetError(0, 0, $aFiles)
EndFunc   ;==>HaveSharedPrefs

Func PullSharedPrefs($sProfile = $g_sProfileCurrentName)
	Local $bWasRunState = $g_bRunState
	Local $process_killed
	DirCreate($g_sPrivateProfilePath & "\" & $sProfile) ; ensure again that private profile folder exists, because adb pull and DirMove requires it
	Local $cmdOutput
	Local $Result = False
	Local $iFiles = 5
	Local $iFilesPulled = 0

	If Not $g_sAndroidPicturesPathAvailable Then
		SetLog("Shard folder in Android not availble, cannot pull shared_prefs", $COLOR_RED)
		Return SetError(0, 0, $Result)
	EndIf

	SetDebugLog("Pulling shared_pref of profile " & $sProfile)
	Local $sProfileMD5 = _Crypt_HashData($sProfile, $CALG_MD5)

	; create temporary backup of shared_prefs
	DirRemove($g_sPrivateProfilePath & "\" & $sProfile & "\shared_prefs_tmp", 1)
	DirMove($g_sPrivateProfilePath & "\" & $sProfile & "\shared_prefs", $g_sPrivateProfilePath & "\" & $sProfile & "\shared_prefs_tmp")
	If FileExists($g_sPrivateProfilePath & "\" & $sProfile & "\shared_prefs") Then
		SetLog("Cannot rename " & $g_sPrivateProfilePath & "\" & $sProfile & "\shared_prefs", $COLOR_ERROR)
		SetLog("Error pulling shared_prefs of profile " & $sProfile, $COLOR_ERROR)
		Return SetError(0, 0, $Result)
	EndIf
	If $g_bPullPushSharedPrefsAbdCommand Then
		$cmdOutput = LaunchConsole($g_sAndroidAdbPath, AddSpace($g_sAndroidAdbGlobalOptions) & "-s " & $g_sAndroidAdbDevice & " pull /data/data/" & $g_sAndroidGamePackage & "/shared_prefs """ & $g_sPrivateProfilePath & "\" & $sProfile & "\shared_prefs""", $process_killed)
	Else
		$cmdOutput = ""
	EndIf
	If StringInStr($cmdOutput, "files pulled") > 0 And StringInStr($cmdOutput, @LF & "0 files pulled") = 0 And StringInStr($cmdOutput, "failed to ") = 0 And StringInStr($cmdOutput, "Permission denied") = 0 Then
		; OK, files pulled, validate
		Local $aRegExResult = StringRegExp($cmdOutput, "(\d+) files pulled", $STR_REGEXPARRAYMATCH)
		If Not @error Then
			$iFilesPulled = Number($aRegExResult[0])
		EndIf
		$Result = $iFilesPulled >= $iFiles
		If Not $Result Then SetLog("Pulled " & $iFilesPulled & " files of " & $iFiles & " total", $COLOR_ERROR)
	Else
		If $g_bPullPushSharedPrefsAbdCommand Then SetDebugLog("ADB pull failed, try to use host shared folder")
		$cmdOutput = AndroidAdbSendShellCommand("set result=$(ls -l /data/data/" & $g_sAndroidGamePackage & "/shared_prefs/ >&2)")
		$iFiles = UBound(Ls_l_FilesOnly(StringSplit($cmdOutput, @LF, $STR_NOCOUNT)))
		If $iFiles >= 5 And StringInStr($cmdOutput, "Permission denied") = 0 And StringInStr($cmdOutput, "No such file or directory") = 0 Then
			Local $androidFolder = $g_sAndroidPicturesPath & $g_sAndroidPicturesHostFolder & $sProfileMD5
			AndroidAdbSendShellCommand("set result=$(rm -r """ & $androidFolder & """ >&2)")
			AndroidAdbSendShellCommand("set result=$(mkdir -p """ & $androidFolder & "/shared_prefs"" >&2)")
			AndroidAdbSendShellCommand("set result=$(cp /data/data/" & $g_sAndroidGamePackage & "/shared_prefs/* """ & $androidFolder & "/shared_prefs"" >&2)")
			$cmdOutput = AndroidAdbSendShellCommand("set result=$(ls -l """ & $androidFolder & "/shared_prefs/"" >&2)")
			$iFilesPulled = UBound(Ls_l_FilesOnly(StringSplit($cmdOutput, @LF, $STR_NOCOUNT)))
			If $iFilesPulled >= $iFiles And StringInStr($cmdOutput, "Permission denied") = 0 And StringInStr($cmdOutput, "No such file or directory") = 0 Then ; And StringInStr($cmdOutput, "usage: cp") = 0
				Local $hostFolder = $g_sAndroidPicturesHostPath & $g_sAndroidPicturesHostFolder & $sProfileMD5
				$iFilesPulled = UBound(_FileListToArray($hostFolder & "\shared_prefs", "*", $FLTA_FILES)) - 1
				If $iFilesPulled >= $iFiles Then
					;If DirCopy($hostFolder & "\shared_prefs", $g_sPrivateProfilePath & "\" & $sProfile, $FC_OVERWRITE) = 1 Then
					FileDelete($g_sPrivateProfilePath & "\" & $sProfile & "\shared_prefs") ; ensure folder doen't exist as file
					DirRemove($g_sPrivateProfilePath & "\" & $sProfile & "\shared_prefs", 1) ; delete shared_prefs folder
					DirCreate($g_sPrivateProfilePath & "\" & $sProfile & "\shared_prefs")
					If FileCopy($hostFolder & "\shared_prefs\*", $g_sPrivateProfilePath & "\" & $sProfile & "\shared_prefs", $FC_OVERWRITE) And UBound(_FileListToArray($g_sPrivateProfilePath & "\" & $sProfile & "\shared_prefs", "*", $FLTA_FILES)) - 1 >= $iFiles Then
						; OK, files pulled
						AndroidAdbSendShellCommand("set result=$(rm -r """ & $androidFolder & """ >&2)")
						$Result = True
					Else
						SetLog("Cannot copy shared_prefs to " & $g_sPrivateProfilePath & "\" & $sProfile, $COLOR_ERROR)
					EndIf
				Else
					SetLog("Cannot copy shared_prefs to " & $hostFolder, $COLOR_ERROR)
				EndIf
			Else
				SetLog("Cannot copy shared_prefs to " & $androidFolder, $COLOR_ERROR)
			EndIf
		Else
			SetLog($g_sAndroidGamePackage & " has no valid shared_prefs folder or it cannot be accessed", $COLOR_ERROR)
		EndIf
	EndIf

	Local $aFiles = _FileListToArray($g_sPrivateProfilePath & "\" & $sProfile & "\shared_prefs", "*", $FLTA_FILES, True)
	$iFilesPulled = UBound($aFiles) - 1
	If $Result Then $Result = $iFilesPulled >= $iFiles
	If $Result Then
		DirRemove($g_sPrivateProfilePath & "\" & $sProfile & "\shared_prefs_tmp", 1)
		Local $a[$iFilesPulled][2]
		For $i = 1 To $aFiles[0]
			Local $aFileTime = FileGetTime($aFiles[$i], 0)
			$a[$i - 1][0] = $aFiles[$i]
			$a[$i - 1][1] = _ArrayToString($aFileTime, "-", -1, 2) & " " & _ArrayToString($aFileTime, ":", 3, -1)
		Next
		SetDebugLog(_ArrayToString($a, ","))
		SetLog("Pulled shared_prefs of profile " & $sProfile & " (" & $iFilesPulled & " files)")
	Else
		; something went wrong
		DirRemove($g_sPrivateProfilePath & "\" & $sProfile & "\shared_prefs", 1)
		DirMove($g_sPrivateProfilePath & "\" & $sProfile & "\shared_prefs_tmp", $g_sPrivateProfilePath & "\" & $sProfile & "\shared_prefs")
		SetLog("Error pulling shared_prefs of profile " & $sProfile, $COLOR_ERROR)
	EndIf
	Return SetError(0, 0, $Result)
EndFunc   ;==>PullSharedPrefs
global $g_bpushedsharedprefs = False
Func PushSharedPrefs($sProfile = $g_sProfileCurrentName, $bCloseGameIfRunning = True)
	Local $Result = False
	Local $bWasRunState = $g_bRunState
	Local $process_killed
	Local $cmdOutput

	If Not $g_sAndroidPicturesPathAvailable Then
		SetLog("Shard folder in Android not availble, cannot push shared_prefs", $COLOR_RED)
		Return SetError(0, 0, $Result)
	EndIf

	Local $aNewFiles = HaveSharedPrefs($sProfile, True, True)
	Local $bHaveNew = UBound($aNewFiles) > 1
	Local $bHaveOld = HaveSharedPrefs($sProfile, False, True)

	If Not $bHaveNew And Not $bHaveOld Then
		SetLog("Profile " & $sProfile & " doesn't have shared_prefs folder to push", $COLOR_RED)
		Return SetError(0, 0, $Result)
	EndIf

	SetDebugLog("Pushing shared_pref of profile " & $sProfile)
	Local $sProfileMD5 = _Crypt_HashData($sProfile, $CALG_MD5)

	; ensure shared_prefs exist
	$cmdOutput = AndroidAdbSendShellCommand("set result=$(ls /data/data/" & $g_sAndroidGamePackage & "/shared_prefs/ >&2)")
	If StringInStr($cmdOutput, "No such file or directory") Then
		SetLog("Please launch game one time before pushing shared_prefs", $COLOR_ERROR)
		Return SetError(0, 0, $Result)
	EndIf

	If $bCloseGameIfRunning And GetAndroidProcessPID(Default, $bWasRunState) Then
		CloseCoC(False, False)
	EndIf

	If Not $bHaveNew And $bHaveOld Then
		; If shared_prefs doesn't exists in private profile path, check if it must be migrated
		SetLog("Migrate shared_prefs to " & $g_sPrivateProfilePath & "\" & $sProfile)
		If DirMove($g_sProfilePath & "\" & $sProfile & "\shared_prefs", $g_sPrivateProfilePath & "\" & $sProfile & "\shared_prefs") Then
			DirRemove($g_sProfilePath & "\" & $sProfile & "\shared_prefs", 1)
			$aNewFiles = HaveSharedPrefs($sProfile, True, True)
			; Ok
		Else
			SetLog("Migration of shared_prefs failed", $COLOR_ERROR)
		EndIf
	EndIf

	Local $iFiles = UBound($aNewFiles) - 1
	Local $iFilesPushed = 0

	_Sleep(1000)
	; use ADB push to transfer files
	If $g_bPullPushSharedPrefsAbdCommand Then
		$cmdOutput = LaunchConsole($g_sAndroidAdbPath, AddSpace($g_sAndroidAdbGlobalOptions) & "-s " & $g_sAndroidAdbDevice & " push """ & $g_sPrivateProfilePath & "\" & $sProfile & "\shared_prefs"" /data/data/" & $g_sAndroidGamePackage & "/shared_prefs", $process_killed)
	Else
		$cmdOutput = ""
	EndIf
	If StringInStr($cmdOutput, "files pushed") > 0 And StringInStr($cmdOutput, @LF & "0 files pushed") = 0 And StringInStr($cmdOutput, "failed to ") = 0 And StringInStr($cmdOutput, "Permission denied") = 0 Then
		; OK, files pushed, validate
		Local $aRegExResult = StringRegExp($cmdOutput, "(\d+) files pushed", $STR_REGEXPARRAYMATCH)
		If Not @error Then
			$iFilesPushed = Number($aRegExResult[0])
		EndIf
		$Result = $iFilesPushed >= $iFiles
		If Not $Result Then SetLog("Pushed " & $iFilesPushed & " files of " & $iFiles & " total", $COLOR_ERROR)
	Else
		If $g_bPullPushSharedPrefsAbdCommand Then SetDebugLog("ADB push failed, try to use host shared folder")
		;AndroidAdbSendShellCommand("set result=$(mkdir -p /data/data/" & $g_sAndroidGamePackage & "/shared_prefs >&2)") ; don't ensure game shared_prefs exist: too dangerous regarding permissions!
		$cmdOutput = AndroidAdbSendShellCommand("set result=$(ls -l /data/data/" & $g_sAndroidGamePackage & "/ >&2)")
		Local $aLs = Ls_l_ToArray($cmdOutput)
		SetDebugLog("Game folder: " & _ArrayToString($aLs))
		Local $iSharedPrefs = _ArraySearch($aLs, "shared_prefs")
		If StringInStr($cmdOutput, "Permission denied") = 0 And StringInStr($cmdOutput, "No such file or directory") = 0 And $iSharedPrefs > -1 Then
			; shared_prefs exists
			Local $androidFolder = $g_sAndroidPicturesPath & $g_sAndroidPicturesHostFolder & $sProfileMD5
			AndroidAdbSendShellCommand("set result=$(rm -r """ & $androidFolder & """ >&2)")
			AndroidAdbSendShellCommand("set result=$(mkdir -p """ & $androidFolder & "/shared_prefs"" >&2)")
			Local $hostFolder = $g_sAndroidPicturesHostPath & $g_sAndroidPicturesHostFolder & $sProfileMD5
			Local $iFilesInShared = UBound(_FileListToArray($hostFolder & "\shared_prefs", "*", $FLTA_FILES)) - 1
			If FileExists($hostFolder & "\shared_prefs") And $iFilesInShared < 1 Then
				; copy files
				If FileCopy($g_sPrivateProfilePath & "\" & $sProfile & "\shared_prefs\*", $hostFolder & "\shared_prefs", $FC_OVERWRITE) And UBound(_FileListToArray($hostFolder & "\shared_prefs", "*", $FLTA_FILES)) - 1 >= $iFiles Then

					; files copied, now check to update storage_new.xml
					If $g_bUpdateSharedPrefs And ($g_bUpdateSharedPrefsLanguage OR $g_bUpdateSharedPrefsSnow Or $g_bUpdateSharedPrefsZoomLevel Or $g_bUpdateSharedPrefsGoogleDisconnected Or $g_bUpdateSharedPrefsRated) Then
						; read file
						Local $hFile = FileOpen($hostFolder & "\shared_prefs\storage_new.xml", $FO_READ + $FO_UTF8_NOBOM)
						Local $sStorage = FileRead($hFile)
						FileClose($hFile)
						If $sStorage Then
							Local $sStorageUpdated = $sStorage
							;Quick fix for "can't stop snow" proposed by Famine098 in Forum
							Local $aTags[4][3] = _
							[[$g_bUpdateSharedPrefsLanguage, "d0h6phQUOxO/uSfvat949w==", "FWCNTu39RUlYoSt0Y6mCwg=="], _
							[$g_bUpdateSharedPrefsZoomLevel, "MjhxqoFNUV+begGvsz3gkg==", "oiMa1oDch9dThLoIKokZqQ=="], _
							[$g_bUpdateSharedPrefsRated, "7lJCTt3TmNyzikZuHh9wZQ==", "pmvEzdQuRQuKZob4KB0IeA=="], _
							[$g_bUpdateSharedPrefsGoogleDisconnected, "AQ+/D2n+JXPIPpMLdPZcqHpYSGJ5PpF3sOnowks5I5s=", "pmvEzdQuRQuKZob4KB0IeA=="]]
	;						Local $aTags[5][3] = [[$g_bUpdateSharedPrefsLanguage, "d0h6phQUOxO/uSfvat949w==", "FWCNTu39RUlYoSt0Y6mCwg=="], _
	;						[$g_bUpdateSharedPrefsSnow, "WnITdUFs6FnH4NScnkEtyg==", "jS26iozgAh+i/424eyY5cA=="], _
	;						[$g_bUpdateSharedPrefsZoomLevel, "MjhxqoFNUV+begGvsz3gkg==", "oiMa1oDch9dThLoIKokZqQ=="], _
	;						[$g_bUpdateSharedPrefsRated, "7lJCTt3TmNyzikZuHh9wZQ==", "pmvEzdQuRQuKZob4KB0IeA=="], _
	;						[$g_bUpdateSharedPrefsGoogleDisconnected, "AQ+/D2n+JXPIPpMLdPZcqHpYSGJ5PpF3sOnowks5I5s=", "pmvEzdQuRQuKZob4KB0IeA=="]]

							For $i = 0 To UBound($aTags) -1
								If $aTags[$i][0] Then
									Local $sNewTag = '<string name="' & $aTags[$i][1] & '">' & $aTags[$i][2] & '</string>'
									Local $sSearchName = StringRegExpReplace($aTags[$i][1], "([\/\+])", "\\$1")
									$sStorageUpdated = StringRegExpReplace($sStorageUpdated, '<string name="' & $sSearchName & '">.+</string>', $sNewTag, 1)
									If @extended = 0 Then $sStorageUpdated = StringReplace($sStorageUpdated, '</map>', "    " & $sNewTag & @LF & '</map>', 1, 1)
								EndIf
							Next
							If $sStorageUpdated <> $sStorage Then
								; write file
								Local $hFile = FileOpen($hostFolder & "\shared_prefs\storage_new.xml", $FO_OVERWRITE + $FO_UTF8_NOBOM)
								If FileWrite($hFile, $sStorageUpdated) Then
									SetLog("Updated shared_prefs", $COLOR_SUCCESS)
								Else
									SetLog("Failed to update shared_prefs", $COLOR_ERROR)
								EndIf
								FileClose($hFile)
							Else
								SetDebugLog("No need to update shared_prefs", $COLOR_ERROR)
							EndIf
						Else
							SetLog("Failed to read shared_prefs", $COLOR_ERROR)
						EndIf
					EndIf

					AndroidAdbSendShellCommand("set result=$(rm /data/data/" & $g_sAndroidGamePackage & "/shared_prefs/* >&2)")
					AndroidAdbSendShellCommand("set result=$(cp """ & $androidFolder & "/shared_prefs/""* /data/data/" & $g_sAndroidGamePackage & "/shared_prefs >&2)")
					$cmdOutput = AndroidAdbSendShellCommand("set result=$(ls -l /data/data/" & $g_sAndroidGamePackage & "/shared_prefs/ >&2)")
					$iFilesPushed = UBound(Ls_l_FilesOnly(StringSplit($cmdOutput, @LF, $STR_NOCOUNT)))
					$cmdOutput += AndroidAdbSendShellCommand("set result=$(ls -l """ & $androidFolder & "/shared_prefs/"" >&2)")
					If $iFilesPushed >= $iFiles And StringInStr($cmdOutput, "Permission denied") = 0 And StringInStr($cmdOutput, "No such file or directory") = 0 Then ; And StringInStr($cmdOutput, "usage: cp") = 0
						; OK, files pushed
						AndroidAdbSendShellCommand("set result=$(rm -r """ & $androidFolder & """ >&2)")
						; restore permissions and owner
						Local $sPerm = Ls_l_PermissionsToNumber($aLs[$iSharedPrefs][0])
						Local $sOwn = $aLs[$iSharedPrefs][1] & ":" & $aLs[$iSharedPrefs][2]
						If $g_iAndroidVersionAPI >= $g_iAndroidNougat Then $sOwn = $aLs[$iSharedPrefs][2] & ":" & $aLs[$iSharedPrefs][3]
						AndroidAdbSendShellCommand("set result=$(chmod " & $sPerm & " /data/data/" & $g_sAndroidGamePackage & "/shared_prefs/* >&2)")
						AndroidAdbSendShellCommand("set result=$(chown " & $sOwn & " /data/data/" & $g_sAndroidGamePackage & "/shared_prefs/* >&2)")
						$Result = True
					Else
						SetLog("Cannot copy sharef_prefs to /data/data/" & $g_sAndroidGamePackage, $COLOR_ERROR)
					EndIf
				Else
					SetLog("Cannot copy shared_prefs to " & $hostFolder, $COLOR_ERROR)
				EndIf
			Else
				SetLog("Cannot create empty folder " & $androidFolder & "/shared_prefs", $COLOR_ERROR)
			EndIf
		Else
			SetDebugLog("ADB command: ls -l /data/data/" & $g_sAndroidGamePackage & "/" & @LF & $cmdOutput)
			SetLog($g_sAndroidGamePackage & " has no shared_prefs or cannot be accessed, please launch game first", $COLOR_ERROR)
		EndIf
	EndIf

	If $Result Then
		AndroidAdbSendShellCommand("set result=$(ls -l /data/data/" & $g_sAndroidGamePackage & "/shared_prefs/ >&2)")
		SetLog("Pushed shared_prefs of profile " & $sProfile & " (" & $iFilesPushed & " files)")
		$g_PushedSharedPrefsProfile = $sProfile
		$g_PushedSharedPrefsProfile_Timer = __TimerInit()
		If $g_bUpdateSharedPrefs And $g_iAndroidZoomoutMode = 4 Then $g_bAndroidZoomoutModeFallback = True
		$g_bpushedsharedprefs = True
		_Sleep(3000)
	Else
		; something went wrong
		SetLog("Error pushing shared_prefs of profile " & $sProfile, $COLOR_ERROR)
	EndIf
	Return SetError(0, 0, $Result)
EndFunc   ;==>PushSharedPrefs

Func Ls_l_FilesOnly($aFiles)
	If UBound($aFiles) < 1 Then Return $aFiles
	Local $i = 0
	While $i < UBound($aFiles)
		If IsString($aFiles[$i]) And StringLeft($aFiles[$i], 1) <> "-" Then
			; remove entry: not a file
			_ArrayDelete($aFiles, $i)
		Else
			$i += 1
		EndIf
	WEnd
	Return $aFiles
EndFunc   ;==>Ls_l_FilesOnly

Func Ls_l_PermissionsToNumber($sPerm)
	If StringLen($sPerm) <> 10 Then Return 770
	Local $n = ""
	For $u = 0 To 2
		Local $p = 0
		If StringMid($sPerm, $u * 3 + 2, 1) = "r" Then $p += 4
		If StringMid($sPerm, $u * 3 + 3, 1) = "w" Then $p += 2
		If StringMid($sPerm, $u * 3 + 4, 1) = "x" Then $p += 1
		$n &= $p
	Next
	Return $n
EndFunc   ;==>Ls_l_PermissionsToNumber

Func Ls_l_ToArray($sOutput)
	$sOutput = StringStripWS($sOutput, $STR_STRIPSPACES)
	Local $aFiles = StringSplit($sOutput, @LF, $STR_NOCOUNT)
	Local $iCols = 0
	Local $aResult[UBound($aFiles)][0]
	For $i = 0 To UBound($aFiles) - 1
		Local $aFile = StringSplit($aFiles[$i], " ", $STR_NOCOUNT)
		If UBound($aFile) > UBound($aResult, 2) Then ReDim $aResult[UBound($aFiles)][UBound($aFile)]
		For $j = 0 To UBound($aFile) - 1
			$aResult[$i][$j] = $aFile[$j]
		Next
	Next
	Return $aResult
EndFunc   ;==>Ls_l_ToArray

Func InvalidAdbShellOptions($cmdOutput, $source)
	; check for /data/anr/../../system/xbin/bstk/su: not found
	If $g_sAndroidAdbShellOptions And StringInStr($cmdOutput, ": not found") > 0 Then
		SetDebugLog($source & ": Shell option '" & $g_sAndroidAdbShellOptions & "' not supported and now disabled")
		$g_sAndroidAdbShellOptions = ""
		Return True
	EndIf
	Return False
EndFunc   ;==>InvalidAdbShellOptions

Func InvalidAdbInstanceShellOptions($cmdOutput, $source)
	; check for " -t -t" support
	If $g_sAndroidAdbInstanceShellOptions And StringInStr($cmdOutput, "error: target doesn't support PTY") > 0 Or StringInStr($cmdOutput, ": unknown option") Then
		SetDebugLog($source & ": Shell instance option '" & $g_sAndroidAdbInstanceShellOptions & "' not supported and now disabled")
		$g_sAndroidAdbInstanceShellOptions = ""
		Return True
	EndIf
	Return False
EndFunc   ;==>InvalidAdbInstanceShellOptions

Func AddSpace($s, $Option = Default)
	If Not $s Then Return ""
	If $Option == Default Then $Option = 0
	Switch $Option
		Case 0
			; add space to end
			Return $s & " "
		Case 1
			; add apce to front
			Return " " & $s
	EndSwitch
	Return $s
EndFunc   ;==>AddSpace

Func CheckEmuNewVersions($bSilentLog = False)
	
	; Custom fix - Team AIO Mod++
	; call Android initialization routine
	Local $sResult = Execute("Init" & $g_sAndroidEmulator & "(False)")
	If $sResult = "" And @error <> 0 And $bSilentLog = False Then
		; Not implemented
		SetLog("Android support for " & $g_sAndroidEmulator & " is not available", $COLOR_ERROR)
	EndIf

	Local $Version = GetVersionNormalized($g_sAndroidVersion)
	
	GuiCtrlSetData($g_hLblAndroidInfo, $g_sAndroidEmulator & " v" & $g_sAndroidVersion)
	
	Local $NewVersion = ""
	Local $HelpLink = "Please visit MyBot Forum!"

	Switch $g_sAndroidEmulator
		Case "BlueStacks5"
			$NewVersion = GetVersionNormalized("5.8.101.1001")
		Case "BlueStacks2"
			$NewVersion = GetVersionNormalized("4.280.0.4206") ; BlueStacks HyperV by Teknolojikpanda - Team__AiO__MOD
		Case "MEmu"
			$NewVersion = GetVersionNormalized("8.0.2.0")
         Case "Nox"
			$NewVersion = GetVersionNormalized("7.0.3.0")
		Case Else
			; diabled of the others
			$NewVersion = GetVersionNormalized("99.0.0.0")
	EndSwitch

	If $Version > $NewVersion And $g_sAndroidEmulator = "Memu" And $bSilentLog = False Then
		SetLog("Compatibility has not been certified for " & $g_sAndroidEmulator & " version (" & $g_sAndroidVersion & ")!", $COLOR_INFO)
		SetLog($HelpLink, $COLOR_INFO)
	EndIf
	
	If $g_sAndroidEmulator = "Memu" And $Version = GetVersionNormalized("8.0.1.0") And $bSilentLog = False Then
		SetLog("Memu 8.0.1.0 has problems working, please install a later version.", $COLOR_ERROR)
	EndIf
EndFunc   ;==>CheckEmuNewVersions
