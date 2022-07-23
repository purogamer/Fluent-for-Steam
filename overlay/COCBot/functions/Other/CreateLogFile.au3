; #FUNCTION# ====================================================================================================================
; Name ..........: CreateLogFile
; Description ...:
; Syntax ........: CreateLogFile()
; Parameters ....:
; Return values .: None
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func CreateLogFile()
	If $g_hLogFile <> 0 Then
	   FileClose($g_hLogFile)
	   $g_hLogFile = 0
    EndIf

	; reduce number of log files by creating new only if not created in last 2 hours
	Local $aOldLogs = _FileListToArray($g_sProfileLogsPath, @YEAR & "-" & @MON & "-" & @MDAY & "_" & @HOUR & ".*.log", $FLTA_FILES)
	If UBound($aOldLogs) < 2 Then
		Local $aDate, $aTime, $YEAR, $MON, $MDAY, $HOUR
		_DateTimeSplit(_DateAdd("h", -1, _NowCalc()), $aDate, $aTime)
		$YEAR = StringFormat("%04d", $aDate[1])
		$MON = StringFormat("%02d", $aDate[2])
		$MDAY = StringFormat("%02d", $aDate[3])
		$HOUR = StringFormat("%02d", $aTime[1])
		$aOldLogs = _FileListToArray($g_sProfileLogsPath, $YEAR & "-" & $MON & "-" & $MDAY & "_" & $HOUR & ".*.log", $FLTA_FILES)
	EndIf

	Local $sLogPath
	If UBound($aOldLogs) > 1 Then
		; sort descending
		_ArraySort($aOldLogs, 1, 1, 0)
		$g_sLogFileName = $aOldLogs[1]
		$sLogPath = $g_sProfileLogsPath & $g_sLogFileName
		$g_hLogFile = FileOpen($sLogPath, $FO_APPEND)
		SetDebugLog("Append to log file: " & $sLogPath)
	Else
		$g_sLogFileName = @YEAR & "-" & @MON & "-" & @MDAY & "_" & @HOUR & "." & @MIN & "." & @SEC & ".log"
		$sLogPath = $g_sProfileLogsPath & $g_sLogFileName
		$g_hLogFile = FileOpen($sLogPath, $FO_APPEND)
		SetDebugLog("Created log file: " & $sLogPath)
	EndIf

	If IsBotLaunched() Then
		; Android info
		SetDebugLog("Android: " & $g_sAndroidEmulator)
		SetDebugLog("Android Instance: " & $g_sAndroidInstance)
		SetDebugLog("Android Version: " & $g_sAndroidVersion)
		SetDebugLog("Android Version API: " & $g_iAndroidVersionAPI)
		SetDebugLog("Android ADB Device: " & $g_sAndroidAdbDevice)
		SetDebugLog("Android Program Path: " & $g_sAndroidProgramPath)
		SetDebugLog("Android Program FileVersionInfo: " & ((IsArray($g_avAndroidProgramFileVersionInfo) ? _ArrayToString($g_avAndroidProgramFileVersionInfo, ",", 1) : "not available")))
		SetDebugLog("Android ADB Path: " & $g_sAndroidAdbPath)
		SetDebugLog("Android ADB Global Options: " & $g_sAndroidAdbGlobalOptions)
		SetDebugLog("Android VBoxManage Path: " & $__VBoxManage_Path)
		SetDebugLog("Android ADB Shared Folder: " & $g_sAndroidPicturesPath)
	EndIf

	; Debug Output of launch parameter
	SetDebugLog("Full Command Line: " & $CmdLineRaw)
	SetDebugLog("@AutoItExe: " & @AutoItExe)
	SetDebugLog("@ScriptFullPath: " & @ScriptFullPath)
	SetDebugLog("@WorkingDir: " & @WorkingDir)
	SetDebugLog("@AutoItPID: " & @AutoItPID)
	SetDebugLog("@OSArch: " & @OSArch)
	SetDebugLog("@OSVersion: " & _OSVersion())
	SetDebugLog("@OSBuild: " & _OSBuild())
	SetDebugLog("@OSServicePack: " & @OSServicePack)
	SetDebugLog("Primary Display: " & @DesktopWidth & " x " & @DesktopHeight & " - " & @DesktopDepth & "bit")

	FlushGuiLog($g_hTxtLog, $g_oTxtLogInitText)
EndFunc   ;==>CreateLogFile

; #FUNCTION# ====================================================================================================================
; Name ..........: CreateAttackLogFile
; Description ...:
; Syntax ........: CreateAttackLogFile()
; Parameters ....:
; Return values .: None
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func CreateAttackLogFile()
	If $g_hAttackLogFile <> 0 Then
	   FileClose($g_hAttackLogFile)
	   $g_hAttackLogFile = 0
    EndIf

	Local $sAttackLogFName = "AttackLog" & "-" & @YEAR & "-" & @MON & ".log"
	Local $sAttackLogPath = $g_sProfileLogsPath & $sAttackLogFName
	$g_hAttackLogFile = FileOpen($sAttackLogPath, $FO_APPEND)
	SetDebugLog("Created attack log file: " & $sAttackLogPath)
EndFunc   ;==>CreateAttackLogFile

; #FUNCTION# ====================================================================================================================
; Name ..........: CreateAttackSwitchFile
; Description ...:
; Syntax ........: CreateAttackSwitchFile()
; Parameters ....:
; Return values .: None
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func CreateSwitchLogFile()
	If $g_hSwitchLogFile <> 0 Then
		FileClose($g_hSwitchLogFile)
		$g_hSwitchLogFile = 0
	EndIf

	Local $sSwitchLogFName = "SwitchAccLog" & "-" & @YEAR & "-" & @MON & ".log"
	Local $sSwitchLogPath = $g_sProfilePath & "\" & $sSwitchLogFName
	$g_hSwitchLogFile = FileOpen($sSwitchLogPath, $FO_APPEND)
	SetDebugLog("Created switch log file: " & $sSwitchLogPath)
EndFunc   ;==>CreateSwitchLogFile