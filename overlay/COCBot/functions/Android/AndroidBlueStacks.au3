; #FUNCTION# ====================================================================================================================
; Name ..........: OpenBS
; Description ...:
; Syntax ........: OpenBS([$bRestart = False])
; Parameters ....: $bRestart            - [optional] a boolean value. Default is False.
; Return values .: None
; Author ........: GkevinOD (2014), Hervidero (2015)
; Modified ......: Cosote (12-2015), KnowJack (08-2015)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func OpenBS($bRestart = False) ; @deprecated, use OpenAndroid()
	Return OpenAndroid($bRestart)
EndFunc   ;==>OpenBS

Func OpenBlueStacksX($bRestart = False)
	SetLog("Starting BlueStacks and Clash Of Clans", $COLOR_SUCCESS)
	If Not InitAndroid() Then Return False
	If $g_sAndroidEmulator = "BlueStacks" Then
		; open BlueStacks version 1
		Return _OpenBlueStacks($bRestart)
	EndIf
	; open newer BlueStacks versions
	Return _OpenBlueStacks2($bRestart)
EndFunc   ;==>OpenBlueStacksX

Func OpenBlueStacks($bRestart = False)
	Return OpenBlueStacksX($bRestart)
EndFunc   ;==>OpenBlueStacks

Func OpenBlueStacks2($bRestart = False)
	Return OpenBlueStacksX($bRestart)
EndFunc   ;==>OpenBlueStacks2

Func _OpenBlueStacks($bRestart = False)

	Local $hTimer, $iCount = 0, $cmdPar
	Local $PID, $ErrorResult, $connected_to, $process_killed

	; always start ADB first to avoid ADB connection problems
	LaunchConsole($g_sAndroidAdbPath, AddSpace($g_sAndroidAdbGlobalOptions) & "start-server", $process_killed)

	;$PID = ShellExecute($__BlueStacks_Path & "HD-RunApp.exe", "-p " & $g_sAndroidGamePackage & " -a " & $g_sAndroidGamePackage & $g_sAndroidGameClass)  ;Start BS and CoC with command line
	;$PID = ShellExecute($__BlueStacks_Path & "HD-Frontend.exe", $g_sAndroidInstance) ;Start BS and CoC with command line
	$cmdPar = GetAndroidProgramParameter()
	$PID = LaunchAndroid($g_sAndroidProgramPath, $cmdPar, $g_sAndroidPath)
	$ErrorResult = ControlGetHandle("BlueStacks Error", "", "") ; Check for BS error window handle if it opens
	If $g_bDebugAndroid Then SetDebugLog("$PID= " & $PID & ", $ErrorResult = " & $ErrorResult, $COLOR_DEBUG)
	If $PID = 0 Or $ErrorResult <> 0 Then ; IF ShellExecute failed or BS opens error window = STOP
		SetScreenBlueStacks()
		SetError(1, 1, -1)
		Return False
	EndIf

	WinGetAndroidHandle()
	$hTimer = __TimerInit() ; start a timer for tracking BS start up time
	While $g_hAndroidControl = 0
		If _Sleep(3000) Then ExitLoop
		_StatusUpdateTime($hTimer, $g_sAndroidEmulator & " Starting")
		If __TimerDiff($hTimer) > $g_iAndroidLaunchWaitSec * 1000 Then ; if no BS position returned in 4 minutes, BS/PC has major issue so exit
			SetScreenBlueStacks()
			SetLog("Serious error has occurred, please restart PC and try again", $COLOR_ERROR)
			SetLog("BlueStacks refuses to load, waited " & Round(__TimerDiff($hTimer) / 1000, 2) & " seconds", $COLOR_ERROR)
			SetLog("Unable to continue........", $COLOR_WARNING)
			btnstop()
			SetError(1, 1, -1)
			Return False
		EndIf
		WinGetAndroidHandle()
	WEnd

	If $g_hAndroidControl Then
		$connected_to = ConnectAndroidAdb(False, 3000) ; small time-out as ADB connection must be available now

		If WaitForAndroidBootCompleted($g_iAndroidLaunchWaitSec - __TimerDiff($hTimer) / 1000, $hTimer) Then Return
		If Not $g_bRunState Then Return False

		SetLog("BlueStacks Loaded, took " & Round(__TimerDiff($hTimer) / 1000, 2) & " seconds to begin.", $COLOR_SUCCESS)

		Return True

	EndIf

	Return False

EndFunc   ;==>_OpenBlueStacks

Func _OpenBlueStacks2($bRestart = False)

	Local $hTimer, $iCount = 0, $cmdOutput, $process_killed, $i, $connected_to, $PID, $cmdPar

	CloseUnsupportedBlueStacks2()

	; always start ADB first to avoid ADB connection problems
	LaunchConsole($g_sAndroidAdbPath, AddSpace($g_sAndroidAdbGlobalOptions) & "start-server", $process_killed)

	$hTimer = __TimerInit()
	WinGetAndroidHandle()
	Local $bStopIfLaunchFails = False
	While $g_hAndroidControl = 0
		If Not $g_bRunState Then Return False
		; check that HD-Frontend.exe process is really there
		;$cmdPar = " -t " & $g_sAndroidInstance
		$cmdPar = GetAndroidProgramParameter()
		$PID = LaunchAndroid($g_sAndroidProgramPath, $cmdPar, $g_sAndroidPath, Default, $bStopIfLaunchFails)
		If $PID > 0 Then $PID = ProcessExists2($g_sAndroidProgramPath, $g_sAndroidInstance)
		If $PID <= 0 Then
			CloseAndroid("OpenBlueStacks2")
			SetScreenBlueStacks2()
			$bStopIfLaunchFails = True
			If _Sleep(1000) Then Return False
		EndIf

		_StatusUpdateTime($hTimer)
		If __TimerDiff($hTimer) > $g_iAndroidLaunchWaitSec * 1000 Or ($PID = 0 And $bStopIfLaunchFails = True) Then ; if no BS position returned in 4 minutes, BS/PC has major issue so exit
			SetScreenBlueStacks2()
			SetLog("Serious error has occurred, please restart PC and try again", $COLOR_ERROR)
			SetLog($g_sAndroidEmulator & " refuses to load, waited " & Round(__TimerDiff($hTimer) / 1000, 2) & " seconds", $COLOR_ERROR)
			SetError(1, @extended, False)
			Return False
		EndIf
		If _Sleep(3000) Then Return False
		_StatusUpdateTime($hTimer, $g_sAndroidEmulator & " Starting")
		WinGetAndroidHandle()
	WEnd

	; enable window title so BS2 can be moved again
	WinGetAndroidHandle()
	Local $aWin = WinGetPos($g_hAndroidWindow)
	Local $lCurStyle = _WinAPI_GetWindowLong($g_hAndroidWindow, $GWL_STYLE)
	; Enable Title Bar and Border
	_WinAPI_SetWindowLong($g_hAndroidWindow, $GWL_STYLE, BitOR($lCurStyle, $WS_CAPTION, $WS_SYSMENU))
	Local $iCaptionHeight = _WinAPI_GetSystemMetrics($SM_CYCAPTION)
	If BitAND($lCurStyle, BitOR($WS_CAPTION, $WS_SYSMENU)) <> BitOR($WS_CAPTION, $WS_SYSMENU) And UBound($aWin) > 3 Then
		; adjust window height due to caption
		WinMove2($g_hAndroidWindow, "", $aWin[0], $aWin[1], $aWin[2], $aWin[3] + $iCaptionHeight)
	EndIf
	;_WinAPI_SetWindowPos($g_hAndroidWindow, 0, 0, 0, 0, 0, BitOr($SWP_NOMOVE, $SWP_NOSIZE, $SWP_FRAMECHANGED)) ; redraw

	If $g_hAndroidControl Then
		$connected_to = ConnectAndroidAdb(False, 3000) ; small time-out as ADB connection must be available now

		;If WaitForDeviceBlueStacks2($g_iAndroidLaunchWaitSec - __TimerDiff($hTimer) / 1000, $hTimer) Then Return
		If WaitForAndroidBootCompleted($g_iAndroidLaunchWaitSec - __TimerDiff($hTimer) / 1000, $hTimer) Then Return
		If Not $g_bRunState Then Return False

		SetLog($g_sAndroidEmulator & " Loaded, took " & Round(__TimerDiff($hTimer) / 1000, 2) & " seconds to begin.", $COLOR_SUCCESS)
		AndroidAdbLaunchShellInstance()

		If Not $g_bRunState Then Return False
		ConfigBlueStacks2WindowManager()

		Return True

	EndIf

	Return False

EndFunc   ;==>_OpenBlueStacks2

Func GetBlueStacksXAdbPath()
	Local $adbPath = $__BlueStacks_Path & "HD-Adb.exe"
	If FileExists($adbPath) Then
		Return $adbPath
	Else
		; Custom fix - Team AIO Mod++
		Local $aFileList = _FileListToArray($__BlueStacks_Path, "*adb.exe", $FLTA_FILESFOLDERS)
		Local $sMove = (UBound($aFileList) > 0 And not @error) ? ($aFileList[1]) : (@ScriptDir & "\lib\adb\adb.exe")
		If FileCopy($sMove, $adbPath, $FC_OVERWRITE + $FC_CREATEPATH) Then
			SetLog("Fixed ADB !!!", $COLOR_DEBUG)
			Return $adbPath
		EndIf
	EndIf
	Return ""
EndFunc   ;==>GetBlueStacksXAdbPath

Func GetBlueStacksAdbPath()
	Return GetBlueStacksXAdbPath()
EndFunc   ;==>GetBlueStacksAdbPath

Func GetBlueStacks2AdbPath()
	Return GetBlueStacksXAdbPath()
EndFunc   ;==>GetBlueStacks2AdbPath

Func GetBlueStacksPath()
	InitBlueStacksX(True, False, False)
	Return $__BlueStacks_Path
EndFunc

Func InitBlueStacksX($bCheckOnly = False, $bAdjustResolution = False, $bLegacyMode = False)
	
	#Region - BlueStacks HyperV by Teknolojikpanda - Team__AiO__MOD
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
	
	; more recent BlueStacks 2 version install VirtualBox based "plus" mode by default
	If $__BlueStacks_isHyperV = False Then
		Local $plusMode = RegRead($g_sHKLM & "\SOFTWARE\BlueStacks\", "Engine") = "plus" And $bLegacyMode = False
	EndIf
	If $__BlueStacks_isHyperV = True Then
		Local $plusMode = RegRead($g_sHKLM & "\SOFTWARE\BlueStacks_bgp64_hyperv\", "Engine") = "plus" And $bLegacyMode = False
	EndIf
	Local $frontend_exe = ["HD-Frontend.exe", "HD-Player.exe"]
	If $plusMode = True Then
		Local $frontend_exe = "HD-Plus-Frontend.exe"
	EndIf
	#EndRegion - BlueStacks HyperV by Teknolojikpanda - Team__AiO__MOD

	Local $i, $aFiles = [$frontend_exe, "HD-Adb.exe", "HD-Quit.exe"] ; first element can be $frontend_exe array!
	Local $Values[4][3] = [ _
			["Screen Width", $g_iAndroidClientWidth, $g_iAndroidClientWidth], _
			["Screen Height", $g_iAndroidClientHeight, $g_iAndroidClientHeight], _
			["Window Width", $g_iAndroidWindowWidth, $g_iAndroidWindowWidth], _
			["Window Height", $g_iAndroidWindowHeight, $g_iAndroidWindowHeight] _
			]
	Local $bChanged = False

	$__BlueStacks_Path = StringReplace($__BlueStacks_Path, "\\", "\")

	Local $sPreferredADB = FindPreferredAdbPath()
	If $sPreferredADB Then _ArrayDelete($aFiles, 1)

	For $i = 0 To UBound($aFiles) - 1
		Local $File
		Local $bFileFound = False
		Local $aFiles2 = $aFiles[$i]
		If Not IsArray($aFiles2) Then Local $aFiles2 = [$aFiles[$i]]
		For $j = 0 To UBound($aFiles2) - 1
			$File = $__BlueStacks_Path & $aFiles2[$j]
			$bFileFound = FileExists($File)
			If $bFileFound Then
				; check if $frontend_exe is array, then convert
				If $i = 0 And IsArray($frontend_exe) Then $frontend_exe = $aFiles2[$j]
				ExitLoop
			EndIf
		Next
		If Not $bFileFound Then
			If $plusMode And Not $bLegacyMode And $i = 0 Then
				; try legacy mode
				SetDebugLog("Cannot find " & $g_sAndroidEmulator & " file:" & $File, $COLOR_ACTION)
				SetDebugLog("Try legacy mode", $COLOR_ACTION)
				Return InitBlueStacksX($bCheckOnly, $bAdjustResolution, True)
			EndIf
			If Not $bCheckOnly Then
				SetLog("Serious error has occurred: Cannot find " & $g_sAndroidEmulator & ":", $COLOR_ERROR)
				SetLog($File, $COLOR_ERROR)
				SetError(1, @extended, False)
			EndIf
			Return False
		EndIf
	Next

	If Not $bCheckOnly Then

		; re-check BlueStacks / BlueStacks2 key and adjust based on found version as only one BlueStacks version can be installed!
		Local $sAndroidEmulator = $g_sAndroidEmulator
		Local $bIsVersion1 = GetVersionNormalized($__BlueStacks_Version) > GetVersionNormalized("0.8") And GetVersionNormalized($__BlueStacks_Version) < GetVersionNormalized("2.0")
		If $bIsVersion1 And $g_sAndroidEmulator = "BlueStacks2" Then
			; switch to BlueStacks key
			$sAndroidEmulator = "BlueStacks"
		EndIf
		Local $bIsVersion2 = GetVersionNormalized($__BlueStacks_Version) > GetVersionNormalized("2.0") And GetVersionNormalized($__BlueStacks_Version) < GetVersionNormalized("5.0")
		If $bIsVersion2 And $g_sAndroidEmulator = "BlueStacks" Then
			; switch to BlueStacks2 key
			$sAndroidEmulator = "BlueStacks2"
		EndIf
		If $sAndroidEmulator <> $g_sAndroidEmulator Then
			SetLog("Changing Android Emulator config from " & $g_sAndroidEmulator & " to " & $sAndroidEmulator, $COLOR_WARNING)
			UpdateAndroidConfig($g_sAndroidInstance, $sAndroidEmulator)
			Return InitBlueStacksX($bCheckOnly, $bAdjustResolution, $bLegacyMode)
		EndIf

		$g_iAndroidAdbSuCommand = "/system/xbin/bstk/su"
		#Region - BlueStacks HyperV by Teknolojikpanda - Team__AiO__MOD
		Local $BootParameter
		If $__BlueStacks_isHyperV = False Then
			$BootParameter = RegRead($g_sHKLM & "\SOFTWARE\BlueStacks\Guests\" & $g_sAndroidInstance & "\", "BootParameters")
		EndIf
		If $__BlueStacks_isHyperV = True Then
			$BootParameter = RegRead($g_sHKLM & "\SOFTWARE\BlueStacks_bgp64_hyperv\Guests\" & $g_sAndroidInstance & "\", "BootParameters")
		EndIf
		#EndRegion - BlueStacks HyperV by Teknolojikpanda - Team__AiO__MOD
		Local $OEMFeatures
		Local $aRegExResult = StringRegExp($BootParameter, "OEMFEATURES=(\d+)", $STR_REGEXPARRAYGLOBALMATCH)
		If Not @error Then
			; get last match!
			$OEMFeatures = $aRegExResult[UBound($aRegExResult) - 1]
			$g_bAndroidHasSystemBar = BitAND($OEMFeatures, 0x000001) = 0
		EndIf

		; update global variables
		$g_sAndroidPath = $__BlueStacks_Path
		$g_sAndroidProgramPath = $__BlueStacks_Path & $frontend_exe
		$g_sAndroidAdbPath = $sPreferredADB
		If $g_sAndroidAdbPath = "" Then $g_sAndroidAdbPath = $__BlueStacks_Path & "HD-Adb.exe"
		$g_sAndroidVersion = $__BlueStacks_Version

		ConfigureSharedFolderBlueStacksX(0) ; something like D:\ProgramData\BlueStacks\Engine\UserData\SharedFolder\

		SetDebugLog($g_sAndroidEmulator & " Engine 'Plus'-Mode: " & $plusMode)
		SetDebugLog($g_sAndroidEmulator & " OEM Features: " & $OEMFeatures)
		SetDebugLog($g_sAndroidEmulator & " System Bar is " & ($g_bAndroidHasSystemBar ? "" : "not ") & "available")
		#cs as of 2016-01-26 CoC release, system bar is transparent and should be closed when bot is running
			If $bAdjustResolution Then
			If $g_bAndroidHasSystemBar Then
			;$Values[0][2] = $g_avAndroidAppConfig[$g_iAndroidConfig][5]
			$Values[1][2] = $g_avAndroidAppConfig[$g_iAndroidConfig][6] + $__BlueStacks_SystemBar
			;$Values[2][2] = $g_avAndroidAppConfig[$g_iAndroidConfig][7]
			$Values[3][2] = $g_avAndroidAppConfig[$g_iAndroidConfig][8] + $__BlueStacks_SystemBar
			Else
			;$Values[0][2] = $g_avAndroidAppConfig[$g_iAndroidConfig][5]
			$Values[1][2] = $g_avAndroidAppConfig[$g_iAndroidConfig][6]
			;$Values[2][2] = $g_avAndroidAppConfig[$g_iAndroidConfig][7]
			$Values[3][2] = $g_avAndroidAppConfig[$g_iAndroidConfig][8]
			EndIf
			EndIf
			$g_iAndroidClientWidth = $Values[0][2]
			$g_iAndroidClientHeight = $Values[1][2]
			$g_iAndroidWindowWidth =  $Values[2][2]
			$g_iAndroidWindowHeight = $Values[3][2]
		#ce

		For $i = 0 To UBound($Values) - 1
			If $Values[$i][1] <> $Values[$i][2] Then
				$bChanged = True
				SetDebugLog($g_sAndroidEmulator & " " & $Values[$i][0] & " updated from " & $Values[$i][1] & " to " & $Values[$i][2])
			EndIf
		Next

		WinGetAndroidHandle()
	EndIf

	Return True

EndFunc   ;==>InitBlueStacksX

Func ConfigureSharedFolderBlueStacks($iMode = 0, $bSetLog = Default)
	ConfigureSharedFolderBlueStacksX($iMode, $bSetLog)
EndFunc   ;==>ConfigureSharedFolderBlueStacks

Func ConfigureSharedFolderBlueStacks2($iMode = 0, $bSetLog = Default)
	ConfigureSharedFolderBlueStacksX($iMode, $bSetLog)
EndFunc   ;==>ConfigureSharedFolderBlueStacks2

Func ConfigureSharedFolderBlueStacksX($iMode = 0, $bSetLog = Default)
	If $bSetLog = Default Then $bSetLog = True
	Local $bResult = False

	Switch $iMode
		Case 0 ; check that shared folder is configured in VM
			For $i = 0 To 5
				#Region - BlueStacks HyperV by Teknolojikpanda - Team__AiO__MOD
				Local $gSharedFolder
				If $__BlueStacks_isHyperV = False Then
					$gSharedFolder = RegRead($g_sHKLM & "\SOFTWARE\BlueStacks\Guests\" & $g_sAndroidInstance & "\SharedFolder\" & $i & "\", "Name")
				EndIf
				If $__BlueStacks_isHyperV = True Then
					$gSharedFolder = RegRead($g_sHKLM & "\SOFTWARE\BlueStacks_bgp64_hyperv\Guests\" & $g_sAndroidInstance & "\SharedFolder\" & $i & "\", "Name")
				EndIf
				#EndRegion - BlueStacks HyperV by Teknolojikpanda - Team__AiO__MOD
				If $gSharedFolder = "BstSharedFolder" Then
					$bResult = True
					$g_bAndroidSharedFolderAvailable = True
					$g_sAndroidPicturesPath = "/storage/sdcard/windows/BstSharedFolder/"
					#Region - BlueStacks HyperV by Teknolojikpanda - Team__AiO__MOD
					If $__BlueStacks_isHyperV = False Then
						$g_sAndroidPicturesHostPath = RegRead($g_sHKLM & "\SOFTWARE\BlueStacks\Guests\" & $g_sAndroidInstance & "\SharedFolder\" & $i & "\", "Path")
					EndIf
					If $__BlueStacks_isHyperV = True Then
						$g_sAndroidPicturesHostPath = RegRead($g_sHKLM & "\SOFTWARE\BlueStacks_bgp64_hyperv\Guests\" & $g_sAndroidInstance & "\SharedFolder\" & $i & "\", "Path")
					EndIf
					#EndRegion - BlueStacks HyperV by Teknolojikpanda - Team__AiO__MOD
					ExitLoop
				EndIf
			Next
		Case 1 ; create missing shared folder
		Case 2 ; Configure VM and add missing shared folder
	EndSwitch

	Return SetError(0, 0, $bResult)

EndFunc   ;==>ConfigureSharedFolderBlueStacksX

Func InitBlueStacks($bCheckOnly = False)
	Local $bInstalled = InitBlueStacksX($bCheckOnly)
	If $bInstalled And (GetVersionNormalized($__BlueStacks_Version) < GetVersionNormalized("0.8") Or GetVersionNormalized($__BlueStacks_Version) > GetVersionNormalized("2.0")) Then
		If Not $bCheckOnly Then
			SetLog("BlueStacks version is " & $__BlueStacks_Version & " but support version 0.8.x - 1.x not found", $COLOR_ERROR)
			SetError(1, @extended, False)
		EndIf
		Return False
	EndIf

	If Not $bCheckOnly Then
		; BS 1 always has system bar
		$g_bAndroidHasSystemBar = True
	EndIf

	Return $bInstalled
EndFunc   ;==>InitBlueStacks

Func InitBlueStacks2($bCheckOnly = False)
	Local $bInstalled = InitBlueStacksX($bCheckOnly, True)
	If $bInstalled And StringInStr($__BlueStacks_Version, "2.") <> 1 And StringInStr($__BlueStacks_Version, "3.") <> 1 And StringInStr($__BlueStacks_Version, "4.") <> 1 Then
		If Not $bCheckOnly Then
			SetLog("BlueStacks supported version 2.x, 3.x or 4.x not found", $COLOR_ERROR)
			SetError(1, @extended, False)
		EndIf
		Return False
	EndIf

	If $bInstalled And Not $bCheckOnly Then
		$__VBoxManage_Path = $__BlueStacks_Path & "BstkVMMgr.exe"
		Local $bsNow = GetVersionNormalized($__BlueStacks_Version)
		If $bsNow > GetVersionNormalized("4.0") Then
			; only Version 4 requires new options
			;$g_sAndroidAdbInstanceShellOptions = " -t -t" ; Additional shell options, only used by BlueStacks2 " -t -t"
			$g_sAndroidAdbShellOptions = " /data/anr/../../system/xbin/bstk/su root" ; Additional shell options when launch shell with command, only used by BlueStacks2 " /data/anr/../../system/xbin/bstk/su root"

			; tcp forward not working in BS4
			$g_iAndroidAdbMinitouchMode = 1
		EndIf

		CheckBlueStacksVersionMod()
		
		#Region - BlueStacks HyperV by Teknolojikpanda - Team__AiO__MOD
		; read ADB port
		Local $BstAdbPort
		If $__BlueStacks_isHyperV = False Then
			$BstAdbPort = RegRead($g_sHKLM & "\SOFTWARE\BlueStacks\Guests\" & $g_sAndroidInstance & "\Config\", "BstAdbPort")
		EndIf
		If $__BlueStacks_isHyperV = True Then
			$BstAdbPort = RegRead($g_sHKLM & "\SOFTWARE\BlueStacks_bgp64_hyperv\Guests\" & $g_sAndroidInstance & "\Config\", "BstAdbPort")
		EndIf
		#EndRegion - BlueStacks HyperV by Teknolojikpanda - Team__AiO__MOD
		If $BstAdbPort Then
			$g_sAndroidAdbDevice = "127.0.0.1:" & $BstAdbPort
		Else
			; use default
			$g_sAndroidAdbDevice = $g_avAndroidAppConfig[$__BS2_Idx][10]
		EndIf
	EndIf

	Return $bInstalled
EndFunc   ;==>InitBlueStacks2

; Will Check all the differences between versions
Func CheckBlueStacksVersionMod()
	Local $bsNow = GetVersionNormalized($__BlueStacks_Version)
	Local $aOff = [0, 13]
	; < 2.6.105.x - BS2
	; Undocked -> Zoomout [OK] , Mouse[OK]
	; Docked -> Zoomout [OK] , Mouse[OK]
	; $__BlueStacks2Version_2_5_or_later = False

	Local $bs3 = GetVersionNormalized("2.50.0.0")
	; 2.50.53.x - BS3
	; Undocked -> Zoomout [OK] , Mouse[Need compensation]
	; Docked -> Zoomout [OK] , Mouse[OK]
	; $__BlueStacks2Version_2_5_or_later = False

	Local $bs3WithFrame = GetVersionNormalized("2.56.75")
	; 2.56.75 excelent version - 2.56.77 - BS3
	; Undocked -> Zoomout [NO*] , Mouse[OK] ; *$__BlueStacks2Version_2_5_or_later = True
	; Docked -> Zoomout [OK] , Mouse[OK]

	Local $bs3NNoFrame = GetVersionNormalized("4.0.0.0")
	; 4.2.1.9724 - New N version
	; Undocked -> Zoomout [OK] , Mouse[Need compensation]
	; Docked -> Zoomout [OK] , Mouse[OK]

	Local $bs3NWithFrame = GetVersionNormalized("4.3.28.0")
	; 4.3.28.4020 Last version
	; Undocked -> Zoomout [NO*] , Mouse[OK] ; *$__BlueStacks2Version_2_5_or_later = True
	; Docked -> Zoomout [OK] , Mouse[OK]

	If ($bsNow >= $bs3 And $bsNow < $bs3WithFrame) Or ($bsNow > $bs3NNoFrame And $bsNow < $bs3NWithFrame) Then
		; Mouse clicks in Window are off by -13 on Y-axis, so set special value now
		If $g_aiMouseOffsetWindowOnly[0] <> $aOff[0] Or $g_aiMouseOffsetWindowOnly[1] <> $aOff[1] Then
			$g_aiMouseOffsetWindowOnly = $aOff
			SetDebugLog("BlueStacks " & $__BlueStacks_Version & ": Adjust mouse clicks when running undocked by: " & $aOff[0] & ", " & $aOff[1])
		EndIf
	EndIf

	;Zoomout Function when is not Docked
	If $bsNow >= $bs3NWithFrame Or ($bsNow >= $bs3WithFrame And $bsNow < $bs3NNoFrame) Then
		SetDebugLog("BlueStacks " & $__BlueStacks_Version & " adjustment on ZoomOut")
		$__BlueStacks2Version_2_5_or_later = True
	EndIf

EndFunc   ;==>CheckBlueStacksVersionMod

Func GetBlueStacksBackgroundMode()
	; Only DirectX-Mode is supported for Background Mode
	Return $g_iAndroidBackgroundModeDirectX
EndFunc   ;==>GetBlueStacksBackgroundMode

Func GetBlueStacks2BackgroundMode()
	#Region - BlueStacks HyperV by Teknolojikpanda - Team__AiO__MOD
	; check if BlueStacks 2 is running in OpenGL mode
	Local $GlRenderMode
	If $__BlueStacks_isHyperV = False Then
		$GlRenderMode = RegRead($g_sHKLM & "\SOFTWARE\BlueStacks\Guests\" & $g_sAndroidInstance & "\Config\", "GlRenderMode")
	EndIf
	If $__BlueStacks_isHyperV = True Then
		$GlRenderMode = RegRead($g_sHKLM & "\SOFTWARE\BlueStacks_bgp64_hyperv\Guests\" & $g_sAndroidInstance & "\Config\", "GlRenderMode")
	EndIf
	#EndRegion - BlueStacks HyperV by Teknolojikpanda - Team__AiO__MOD
	Switch $GlRenderMode
		Case 4
			; DirectX
			Return $g_iAndroidBackgroundModeDirectX
		Case 1
			; OpenGL
			Return $g_iAndroidBackgroundModeOpenGL
		Case Else
			SetLog($g_sAndroidEmulator & " unsupported render mode " & $GlRenderMode, $COLOR_WARNING)
			Return 0
	EndSwitch
EndFunc   ;==>GetBlueStacks2BackgroundMode

; Called from checkMainScreen
Func RestartBlueStacksXCoC()
	If Not $g_bRunState Then Return False
	Local $cmdOutput
	If Not InitAndroid() Then Return False
	If WinGetAndroidHandle() = 0 Then Return False
	$cmdOutput = AndroidAdbSendShellCommand("am start -W -n " & $g_sAndroidGamePackage & "/" & $g_sAndroidGameClass, 60000) ; timeout of 1 Minute ; disabled -S due to long wait after 2017 Dec. Update
	If $g_bRunState = False Then Return
	SetLog("Please wait for CoC restart......", $COLOR_INFO) ; Let user know we need time...
	Return True
EndFunc   ;==>RestartBlueStacksXCoC

Func RestartBlueStacksCoC()
	Return RestartBlueStacksXCoC()
EndFunc   ;==>RestartBlueStacksCoC

Func RestartBlueStacks2CoC()
	Return RestartBlueStacksXCoC()
EndFunc   ;==>RestartBlueStacks2CoC

Func CheckScreenBlueStacksX($bSetLog = True)
	#Region - BlueStacks HyperV by Teknolojikpanda - Team__AiO__MOD
	Local $REGISTRY_KEY_DIRECTORY
	If $__BlueStacks_isHyperV = False Then
		$REGISTRY_KEY_DIRECTORY = $g_sHKLM & "\SOFTWARE\BlueStacks\Guests\" & $g_sAndroidInstance & "\FrameBuffer\0"
	EndIf
	If $__BlueStacks_isHyperV = True Then
		$REGISTRY_KEY_DIRECTORY = $g_sHKLM & "\SOFTWARE\BlueStacks_bgp64_hyperv\Guests\" & $g_sAndroidInstance & "\FrameBuffer\0"
	EndIf
	#EndRegion - BlueStacks HyperV by Teknolojikpanda - Team__AiO__MOD
	Local $aValues[5][2] = [ _
			["FullScreen", 0], _
			["GuestHeight", $g_iAndroidClientHeight], _
			["GuestWidth", $g_iAndroidClientWidth], _
			["WindowHeight", $g_iAndroidClientHeight], _
			["WindowWidth", $g_iAndroidClientWidth] _
			]
	Local $i, $Value, $iErrCnt = 0
	For $i = 0 To UBound($aValues) - 1
		$Value = RegRead($REGISTRY_KEY_DIRECTORY, $aValues[$i][0])
		If $Value <> $aValues[$i][1] Then
			If $iErrCnt = 0 Then
				SetDebugLog("MyBot doesn't work with " & $g_sAndroidEmulator & " screen configuration!", $COLOR_ERROR)
			EndIf
			SetDebugLog("Setting of " & $aValues[$i][0] & " is " & $Value & " and will be changed to " & $aValues[$i][1], $COLOR_ERROR)
			$iErrCnt += 1
		EndIf
	Next
	; check DPI
	Local $DPI = 0
	#Region - BlueStacks HyperV by Teknolojikpanda - Team__AiO__MOD
	Local $BootParameter
	If $__BlueStacks_isHyperV = False Then
		$BootParameter = RegRead($g_sHKLM & "\SOFTWARE\BlueStacks\Guests\" & $g_sAndroidInstance & "\", "BootParameters")
	EndIf
	If $__BlueStacks_isHyperV = True Then
		$BootParameter = RegRead($g_sHKLM & "\SOFTWARE\BlueStacks_bgp64_hyperv\Guests\" & $g_sAndroidInstance & "\", "BootParameters")
	EndIf
	#EndRegion - BlueStacks HyperV by Teknolojikpanda - Team__AiO__MOD
	Local $aRegExResult = StringRegExp($BootParameter, "DPI=(\d+)", $STR_REGEXPARRAYGLOBALMATCH)
	If Not @error Then
		; get last match!
		$DPI = $aRegExResult[UBound($aRegExResult) - 1]
		If $DPI <> 160 Then
			SetDebugLog("DPI is " & $DPI & " and will be changed to 160", $COLOR_ERROR)
			$iErrCnt += 1
		EndIf
	Else
		SetDebugLog("DPI is missing and will be set to 160", $COLOR_ERROR)
		$iErrCnt += 1
	EndIf
	If $iErrCnt > 0 Then Return False
	Return True
EndFunc   ;==>CheckScreenBlueStacksX

Func CheckScreenBlueStacks($bSetLog = True)
	Return CheckScreenBlueStacksX($bSetLog)
EndFunc   ;==>CheckScreenBlueStacks

Func CheckScreenBlueStacks2($bSetLog = True)
	Return CheckScreenBlueStacksX($bSetLog)
EndFunc   ;==>CheckScreenBlueStacks2

Func SetScreenBlueStacks()
	#Region - BlueStacks HyperV by Teknolojikpanda - Team__AiO__MOD
	Local $REGISTRY_KEY_DIRECTORY
	If $__BlueStacks_isHyperV = False Then
		$REGISTRY_KEY_DIRECTORY = $g_sHKLM & "\SOFTWARE\BlueStacks\Guests\" & $g_sAndroidInstance & "\FrameBuffer\0"
	EndIf
	If $__BlueStacks_isHyperV = True Then
		$REGISTRY_KEY_DIRECTORY = $g_sHKLM & "\SOFTWARE\BlueStacks_bgp64_hyperv\Guests\" & $g_sAndroidInstance & "\FrameBuffer\0"
	EndIf
	RegWrite($REGISTRY_KEY_DIRECTORY, "FullScreen", "REG_DWORD", "0")
	RegWrite($REGISTRY_KEY_DIRECTORY, "GuestHeight", "REG_DWORD", $g_iAndroidClientHeight)
	RegWrite($REGISTRY_KEY_DIRECTORY, "GuestWidth", "REG_DWORD", $g_iAndroidClientWidth)
	RegWrite($REGISTRY_KEY_DIRECTORY, "WindowHeight", "REG_DWORD", $g_iAndroidClientHeight)
	RegWrite($REGISTRY_KEY_DIRECTORY, "WindowWidth", "REG_DWORD", $g_iAndroidClientWidth)
	If $__BlueStacks_isHyperV = False Then
		$REGISTRY_KEY_DIRECTORY = $g_sHKLM & "\SOFTWARE\BlueStacks\Guests\" & $g_sAndroidInstance
	EndIf
	If $__BlueStacks_isHyperV = True Then
		$REGISTRY_KEY_DIRECTORY = $g_sHKLM & "\SOFTWARE\BlueStacks_bgp64_hyperv\Guests\" & $g_sAndroidInstance
	EndIf
	#EndRegion - BlueStacks HyperV by Teknolojikpanda - Team__AiO__MOD
	Local $BootParameter = RegRead($REGISTRY_KEY_DIRECTORY, "BootParameters")
	$BootParameter = StringRegExpReplace($BootParameter, "DPI=\d+", "DPI=160")
	If @error = 0 And @extended > 0 Then
		RegWrite($REGISTRY_KEY_DIRECTORY, "BootParameters", "REG_SZ", $BootParameter)
	Else
		; DPI=160 was missing
		RegWrite($REGISTRY_KEY_DIRECTORY, "BootParameters", "REG_SZ", $BootParameter & " DPI=160")
	EndIf
EndFunc   ;==>SetScreenBlueStacks

Func SetScreenBlueStacks2()
	#Region - BlueStacks HyperV by Teknolojikpanda - Team__AiO__MOD
	Local $REGISTRY_KEY_DIRECTORY
	If $__BlueStacks_isHyperV = False Then
		$REGISTRY_KEY_DIRECTORY = $g_sHKLM & "\SOFTWARE\BlueStacks\Guests\" & $g_sAndroidInstance & "\FrameBuffer\0"
	EndIf
	If $__BlueStacks_isHyperV = True Then
		$REGISTRY_KEY_DIRECTORY = $g_sHKLM & "\SOFTWARE\BlueStacks_bgp64_hyperv\Guests\" & $g_sAndroidInstance & "\FrameBuffer\0"
	EndIf
	RegWrite($REGISTRY_KEY_DIRECTORY, "FullScreen", "REG_DWORD", "0")
	RegWrite($REGISTRY_KEY_DIRECTORY, "GuestHeight", "REG_DWORD", $g_iAndroidClientHeight)
	RegWrite($REGISTRY_KEY_DIRECTORY, "GuestWidth", "REG_DWORD", $g_iAndroidClientWidth)
	RegWrite($REGISTRY_KEY_DIRECTORY, "WindowHeight", "REG_DWORD", $g_iAndroidClientHeight)
	RegWrite($REGISTRY_KEY_DIRECTORY, "WindowWidth", "REG_DWORD", $g_iAndroidClientWidth)
	; Enable bottom action bar with Back- and Home-Button (Menu-Button has no function and don't click Full-Screen-Button at the right as you cannot go back - F11 is not working!)
	; 2015-12-24 cosote Disabled with "0" again because latest version 2.0.2.5623 doesn't support it anymore
	If $__BlueStacks_isHyperV = False Then
		$REGISTRY_KEY_DIRECTORY = $g_sHKLM & "\SOFTWARE\BlueStacks\Guests\" & $g_sAndroidInstance & "\Config"
	EndIf
	If $__BlueStacks_isHyperV = True Then
		$REGISTRY_KEY_DIRECTORY = $g_sHKLM & "\SOFTWARE\BlueStacks_bgp64_hyperv\Guests\" & $g_sAndroidInstance & "\Config"
	EndIf
	RegWrite($REGISTRY_KEY_DIRECTORY, "FEControlBar", "REG_DWORD", "0")
	If $__BlueStacks_isHyperV = False Then
		$REGISTRY_KEY_DIRECTORY = $g_sHKLM & "\SOFTWARE\BlueStacks\Guests\" & $g_sAndroidInstance
	EndIf
	If $__BlueStacks_isHyperV = True Then
		$REGISTRY_KEY_DIRECTORY = $g_sHKLM & "\SOFTWARE\BlueStacks_bgp64_hyperv\Guests\" & $g_sAndroidInstance
	EndIf
	#EndRegion - BlueStacks HyperV by Teknolojikpanda - Team__AiO__MOD
	Local $BootParameter = RegRead($REGISTRY_KEY_DIRECTORY, "BootParameters")
	$BootParameter = StringRegExpReplace($BootParameter, "DPI=\d+", "DPI=160")
	If @error = 0 And @extended > 0 Then
		RegWrite($REGISTRY_KEY_DIRECTORY, "BootParameters", "REG_SZ", $BootParameter)
	Else
		; DPI=160 was missing
		RegWrite($REGISTRY_KEY_DIRECTORY, "BootParameters", "REG_SZ", $BootParameter & " DPI=160")
	EndIf
EndFunc   ;==>SetScreenBlueStacks2

Func RebootBlueStacksSetScreen()

	Return RebootAndroidSetScreenDefault()

EndFunc   ;==>RebootBlueStacksSetScreen

Func ConfigBlueStacks2WindowManager()
	If Not $g_bRunState Then Return
	Local $cmdOutput
	; shell wm density 160
	; shell wm size 860x672
	; shell reboot

	; Reset Window Manager size
	$cmdOutput = AndroidAdbSendShellCommand("wm size reset", Default, Default, False)

	; Set expected dpi
	$cmdOutput = AndroidAdbSendShellCommand("wm density 160", Default, Default, False)

	; Set font size to normal
	AndroidSetFontSizeNormal()
EndFunc   ;==>ConfigBlueStacks2WindowManager

Func RebootBlueStacks2SetScreen($bOpenAndroid = True)

	;RebootAndroidSetScreenDefault()

	If Not InitAndroid() Then Return False

	ConfigBlueStacks2WindowManager()

	; Close Android
	CloseAndroid("RebootBlueStacks2SetScreen")
	If _Sleep(1000) Then Return False

	SetScreenAndroid()
	If Not $g_bRunState Then Return False

	If $bOpenAndroid Then
		; Start Android
		OpenAndroid(True)
	EndIf

	Return True

EndFunc   ;==>RebootBlueStacks2SetScreen

Func GetBlueStacksRunningInstance($bStrictCheck = True)
	WinGetAndroidHandle()
	Local $a[2] = [$g_hAndroidWindow, ""]
	Return $a
EndFunc   ;==>GetBlueStacksRunningInstance

Func GetBlueStacks2RunningInstance($bStrictCheck = True)
	WinGetAndroidHandle()
	Local $a[2] = [$g_hAndroidWindow, ""]
	If $g_hAndroidWindow <> 0 Then Return $a
	If $bStrictCheck Then Return False
	Local $WinTitleMatchMode = Opt("WinTitleMatchMode", -3) ; in recent 2.3.x can be also "BlueStacks App Player"
	Local $h = WinGetHandle("Bluestacks App Player", "") ; Need fixing as BS2 Emulator can have that title when configured in registry
	If @error = 0 Then
		$a[0] = $h
	EndIf
	Opt("WinTitleMatchMode", $WinTitleMatchMode)
	Return $a
EndFunc   ;==>GetBlueStacks2RunningInstance

Func GetBlueStacksProgramParameter($bAlternative = False)
	Return $g_sAndroidInstance
EndFunc   ;==>GetBlueStacksProgramParameter

Func GetBlueStacks2ProgramParameter($bAlternative = False)
	Return $g_sAndroidInstance
EndFunc   ;==>GetBlueStacks2ProgramParameter

Func BlueStacksBotStartEvent()
	If $g_bAndroidEmbedded = False Then
		SetDebugLog("Disable " & $g_sAndroidEmulator & " minimize/maximize Window Buttons")
		DisableBS($g_hAndroidWindow, $SC_MINIMIZE)
		DisableBS($g_hAndroidWindow, $SC_MAXIMIZE)
	EndIf
	Return AndroidCloseSystemBar()
EndFunc   ;==>BlueStacksBotStartEvent

Func BlueStacksBotStopEvent()
	If $g_bAndroidEmbedded = False Then
		SetDebugLog("Enable " & $g_sAndroidEmulator & " minimize/maximize Window Buttons")
		EnableBS($g_hAndroidWindow, $SC_MINIMIZE)
		EnableBS($g_hAndroidWindow, $SC_MAXIMIZE)
	EndIf
	Return AndroidOpenSystemBar()
EndFunc   ;==>BlueStacksBotStopEvent

Func BlueStacks2BotStartEvent()
	If $g_bAndroidEmbedded = False Then
		SetDebugLog("Disable " & $g_sAndroidEmulator & " minimize/maximize Window Buttons")
		DisableBS($g_hAndroidWindow, $SC_MINIMIZE)
		DisableBS($g_hAndroidWindow, $SC_MAXIMIZE)
	EndIf
	If $g_bAndroidHasSystemBar Then Return AndroidCloseSystemBar()
	Return False
EndFunc   ;==>BlueStacks2BotStartEvent

Func BlueStacks2BotStopEvent()
	If $g_bAndroidEmbedded = False Then
		SetDebugLog("Enable " & $g_sAndroidEmulator & " minimize/maximize Window Buttons")
		EnableBS($g_hAndroidWindow, $SC_MINIMIZE)
		EnableBS($g_hAndroidWindow, $SC_MAXIMIZE)
	EndIf
	If $g_bAndroidHasSystemBar Then Return AndroidOpenSystemBar()
	Return False
EndFunc   ;==>BlueStacks2BotStopEvent

Func BlueStacksAdjustClickCoordinates(ByRef $x, ByRef $y)
	$x = Round(32767.0 / $g_iAndroidClientWidth * $x)
	$y = Round(32767.0 / $g_iAndroidClientHeight * $y)
EndFunc   ;==>BlueStacksAdjustClickCoordinates

Func BlueStacks2AdjustClickCoordinates(ByRef $x, ByRef $y)
	Return BlueStacksAdjustClickCoordinates($x, $y)
	;Local $Num = 32728
	;$x = Int(($Num * $x) / $g_iAndroidClientWidth)
	;$y = Int(($Num * $y) / $g_iAndroidClientHeight)
EndFunc   ;==>BlueStacks2AdjustClickCoordinates

Func DisableBS($HWnD, $iButton)
	Local $hSysMenu = _GUICtrlMenu_GetSystemMenu($HWnD, 0)
	_GUICtrlMenu_RemoveMenu($hSysMenu, $iButton, False)
	_GUICtrlMenu_DrawMenuBar($HWnD)
EndFunc   ;==>DisableBS

Func EnableBS($HWnD, $iButton)
	Local $hSysMenu = _GUICtrlMenu_GetSystemMenu($HWnD, 1)
	_GUICtrlMenu_RemoveMenu($hSysMenu, $iButton, False)
	_GUICtrlMenu_DrawMenuBar($HWnD)
EndFunc   ;==>EnableBS

Func GetBlueStacksSvcPid()

	; find process PID
	Local $PID = ProcessExists2("HD-Service.exe")
	Return $PID

EndFunc   ;==>GetBlueStacksSvcPid

Func GetBlueStacksSvcPid2()

	; find process PID
	Local $aFiles = ["HD-Plus-Service.exe", "HD-Service.exe"]
	For $sFile In $aFiles
		Local $PID
		$PID = ProcessExists2($sFile, $g_sAndroidInstance)
		If $PID Then Return $PID
	Next
	Return 0

EndFunc   ;==>GetBlueStacksSvcPid2

Func CloseBlueStacks()
	Local $iIndex, $bOops = False
	Local $aServiceList[4] = ["BstHdAndroidSv", "BstHdLogRotatorSvc", "BstHdUpdaterSvc", "bthserv"]

	If Not InitAndroid() Then Return

	SetDebugLog("Closing BlueStacks: " & $__BlueStacks_Path & "HD-Quit.exe")
	RunWait($__BlueStacks_Path & "HD-Quit.exe")
	If @error <> 0 Then
		SetLog($g_sAndroidEmulator & " failed to quit", $COLOR_ERROR)
		;SetError(1, @extended, -1)
		;Return False
	EndIf

	If _Sleep(2000) Then Return ; wait a bit

	; Check if HD-FrontEnd.exe terminated
	$bOops = ProcessExists("HD-Frontend.exe") <> 0

	If $bOops Then
		$bOops = False
		SetDebugLog("Failed to terminate HD-Frontend.exe with HD-Quit.exe, fallback to taskkill", $COLOR_ERROR)
		KillBSProcess()
		If _Sleep(1000) Then Return ; wait a bit

		SetLog("Please wait for full BS shutdown....", $COLOR_SUCCESS)

		For $iIndex = 0 To UBound($aServiceList) - 1
			ServiceStop($aServiceList[$iIndex])
			If @error Then
				$bOops = True
				If $g_bDebugAndroid Then SetDebugLog($aServiceList[$iIndex] & "errored trying to stop", $COLOR_WARNING)
			EndIf
		Next
		If $bOops Then
			If $g_bDebugAndroid Then SetDebugLog("Service Stop issues, Stopping BS 2nd time", $COLOR_WARNING)
			KillBSProcess()
			If _SleepStatus(5000) Then Return
		EndIf
	EndIf


	If $g_bDebugAndroid And $bOops Then
		SetLog("BS Kill Failed to stop service", $COLOR_ERROR)
	EndIf

	If $bOops Then
		SetError(1, @extended, -1)
	EndIf

EndFunc   ;==>CloseBlueStacks

Func CloseBlueStacks2()

	Local $bOops = False

	If Not InitAndroid() Then Return

	If Not CloseUnsupportedBlueStacksX(False) And GetVersionNormalized($g_sAndroidVersion) > GetVersionNormalized("2.10") Then
		; BlueStacks 3 supports multiple instance
		Local $aFiles = ["HD-Frontend.exe", "HD-Plus-Service.exe", "HD-Service.exe"]

		Local $bError = False
		For $sFile In $aFiles
			Local $PID
			$PID = ProcessExists2($sFile, $g_sAndroidInstance)
			If $PID Then
				ShellExecute(@WindowsDir & "\System32\taskkill.exe", " -f -t -pid " & $PID, "", Default, @SW_HIDE)
				If _Sleep(1000) Then Return ; Give OS time to work
			EndIf
		Next
		If _Sleep(1000) Then Return ; Give OS time to work
		For $sFile In $aFiles
			Local $PID
			$PID = ProcessExists2($sFile, $g_sAndroidInstance)
			If $PID Then
				SetLog($g_sAndroidEmulator & " failed to kill " & $sFile, $COLOR_ERROR)
			EndIf
		Next

		; also close vm
		CloseVboxAndroidSvc()
	Else
		SetDebugLog("Closing BlueStacks: " & $__BlueStacks_Path & "HD-Quit.exe")
		RunWait($__BlueStacks_Path & "HD-Quit.exe")
		If @error <> 0 Then
			SetLog($g_sAndroidEmulator & " failed to quit", $COLOR_ERROR)
			;SetError(1, @extended, -1)
			;Return False
		EndIf
	EndIf

	If _Sleep(2000) Then Return ; wait a bit

	If $bOops Then
		SetError(1, @extended, -1)
	EndIf

EndFunc   ;==>CloseBlueStacks2

Func KillBSProcess()

	Local $aBS_FileNames[8][2] = [['HD-Agent.exe', 0], ['HD-BlockDevice.exe', 0], ['HD-Frontend.exe', 0], _
			['HD-Network.exe', 0], ['HD-Service.exe', 0], ['HD-SharedFolder.exe', 0], ['HD-UpdaterService.exe', 0], ['HD-Adb.exe', 0]]

	For $iIndex = 0 To UBound($aBS_FileNames) - 1
		$aBS_FileNames[$iIndex][1] = ProcessExists($aBS_FileNames[$iIndex][0]) ; Find the PID for each BS file name that is running
		If $g_bDebugAndroid Then SetDebugLog($aBS_FileNames[$iIndex][0] & " PID = " & $aBS_FileNames[$iIndex][1], $COLOR_DEBUG)
		If $aBS_FileNames[$iIndex][1] > 0 Then ; If it is running, then kill it
			ShellExecute(@WindowsDir & "\System32\taskkill.exe", " -t -pid " & $aBS_FileNames[$iIndex][1], "", Default, @SW_HIDE)
			If _Sleep(1000) Then Return ; Give OS time to work
		EndIf
		If ProcessExists($aBS_FileNames[$iIndex][1]) Then ; If it is still running, then force kill it
			If $g_bDebugAndroid Then SetDebugLog($aBS_FileNames[$iIndex][0] & " 1st Kill failed, trying again", $COLOR_DEBUG)
			ShellExecute(@WindowsDir & "\System32\taskkill.exe", "-f -t -pid " & $aBS_FileNames[$iIndex][1], "", Default, @SW_HIDE)
			If _Sleep(500) Then Return ; Give OS time to work
		EndIf
	Next

EndFunc   ;==>KillBSProcess


Func ServiceStop($sServiceName)

	Local $ServiceRunning, $svcWaitIterations, $data, $PID, $hTimer, $bFailed, $Result

	$hTimer = __TimerInit()

	$Result = RunWait(@ComSpec & " /c " & 'net stop ' & $sServiceName, "", @SW_HIDE)
	If @error Then
		SetLog("net stop service failed on " & $sServiceName & ", Result= " & $Result, $COLOR_ERROR)
		SetError(1, @extended, -1)
		Return
	EndIf

	$ServiceRunning = True
	$svcWaitIterations = 0

	While $ServiceRunning ; check if service is stopped yet
		_StatusUpdateTime($hTimer, "BS Service Stop")
		$data = ""
		$PID = Run(@WindowsDir & '\System32\sc.exe query ' & $sServiceName, '', @SW_HIDE, 2)
		Do
			$data &= StdoutRead($PID)
		Until @error
		StdioClose($PID)
		$Result = StringInStr($data, "stopped")
		$bFailed = StringInStr($data, "failed")
		;		If $g_bDebugAndroid Then
		;			SetLog($sServiceName & " stop status= " & $Result, $COLOR_DEBUG)
		;			SetLog("StdOutRead= " & $data, $COLOR_DEBUG)
		;		EndIf
		If $Result Then
			$ServiceRunning = False
		EndIf
		$svcWaitIterations = $svcWaitIterations + 1
		If $svcWaitIterations > 15 Or $bFailed Then ; If trouble reading service stopped, abort
			SetError(1, @extended, -1)
			$ServiceRunning = False
		EndIf
		If _Sleep(1000) Then Return ; Loop delay check for close every 1 second
	WEnd
	If $g_bDebugAndroid And $svcWaitIterations > 15 Then
		SetLog("Failed to stop service " & $sServiceName, $COLOR_ERROR)
	Else
		If $g_bDebugAndroid Then SetDebugLog($sServiceName & "Service stopped successfully", $COLOR_SUCCESS)
	EndIf
EndFunc   ;==>ServiceStop

Func CloseUnsupportedBlueStacks2()
	Return CloseUnsupportedBlueStacksX()
EndFunc   ;==>CloseUnsupportedBlueStacks2

Func CloseUnsupportedBlueStacksX($bClose = True)
	Local $WinTitleMatchMode = Opt("WinTitleMatchMode", -3) ; in recent 2.3.x can be also "BlueStacks App Player"
	#Region - BlueStacks HyperV by Teknolojikpanda - Team__AiO__MOD
	Local $sPartnerExePath
	If $__BlueStacks_isHyperV = False Then
		$sPartnerExePath = RegRead($g_sHKLM & "\SOFTWARE\BlueStacks\Config\", "PartnerExePath")
	EndIf
	If $__BlueStacks_isHyperV = True Then
		$sPartnerExePath = RegRead($g_sHKLM & "\SOFTWARE\BlueStacks_bgp64_hyperv\Config\", "PartnerExePath")
	EndIf
	#EndRegion - BlueStacks HyperV by Teknolojikpanda - Team__AiO__MOD
	If IsArray(ControlGetPos("Bluestacks App Player", "", "")) Or ($sPartnerExePath And ProcessExists2($sPartnerExePath)) Then ; $g_avAndroidAppConfig[1][4]
		Opt("WinTitleMatchMode", $WinTitleMatchMode)
		; Offical "Bluestacks App Player" v2.0 not supported because it changes the Android Screen!!!
		If $bClose = True Then
			SetLog("MyBot doesn't work with " & $g_sAndroidEmulator & " App Player", $COLOR_ERROR)
			SetLog("Please let MyBot start " & $g_sAndroidEmulator & " automatically", $COLOR_INFO)
			RebootBlueStacks2SetScreen(False)
		EndIf
		Return True
	EndIf
	Opt("WinTitleMatchMode", $WinTitleMatchMode)
	Return False
EndFunc   ;==>CloseUnsupportedBlueStacksX

