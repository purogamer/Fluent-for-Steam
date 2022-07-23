;
; #FUNCTION# ====================================================================================================================
; Name ..........: SendAdbCommand
; Description ...:
; Syntax ........: SendAdbCommand()
; Parameters ....: $EnsureConnected = True, if $cmd encouters "error: device not found", connects, checks and even restarts emulator on errors
; Return values .: True if no device not found error was detected or device is now connected and $cmd executed
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......: checkMainscreen, isProblemAffect
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func SendAdbCommand($cmd, $EnsureConnected = True)
	Local $process_killed, $connected_to, $pid, $i

	Local $data = LaunchConsole($g_sAndroidAdbPath, AddSpace($g_sAndroidAdbGlobalOptions) & "-s " & $g_sAndroidAdbDevice & " " & $cmd, $process_killed)
	Local $error_device_not_found = (StringInStr($data, "device not found") > 0) Or $process_killed

	If $error_device_not_found Then
		SetDebugLog("ADB connection error, device " & $g_sAndroidAdbDevice & " not available")
		If Not $EnsureConnected Then
			SetDebugLog("Connect will not be initiated")
			SetLog("ADB command not executed or interrupted: " & $cmd, $COLOR_ERROR)
			Return False
		EndIf
		; connect and try again
		If ConnectAndroidAdb() Then
			; execute command again
			$data = LaunchConsole($g_sAndroidAdbPath, AddSpace($g_sAndroidAdbGlobalOptions) & "-s " & $g_sAndroidAdbDevice & " " & $cmd, $process_killed)
			$error_device_not_found = (StringInStr($data, "device not found") > 0) Or $process_killed
		EndIf
		If $error_device_not_found Then
			SetLog("ADB command not executed: " & $cmd, $COLOR_ERROR)
			Return False
		EndIf
	EndIf

	Return True ; ADB command executed
EndFunc   ;==>SendAdbCommand
