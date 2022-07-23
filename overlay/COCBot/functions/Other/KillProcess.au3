; #FUNCTION# ====================================================================================================================
; Name ..........: KillProcess
; Description ...:
; Syntax ........: KillProcess($iPid, $sProcess_info = "", $iAttempts = 3)
; Parameters ....: $iPid, Process Id
;                : $sProcess_info, additional process info like process filename or full command line for Debug Log
;                : $iAttempts, number of attempts
; Return values .: True if process was killed, false if not or _Sleep interrupted
; Author ........: Cosote (12-2015), Boldina (6-2022)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......: checkMainscreen, isProblemAffect
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func KillProcess($iPid, $sProcess_info = "", $iAttempts = 3)
	$iPid = ProcessExists($iPid)
	If $iPid > 0 Then
		Local $iCount = 0
		If $sProcess_info <> "" Then $sProcess_info = ", " & $sProcess_info
		While ProcessExists($iPid) And $iCount < $iAttempts
			If ProcessClose($iPid) = 1 Then
				SetDebugLog("KillProcess(" & $iCount & "): PID = " & $iPid & " closed" & $sProcess_info)
			Else
				Switch @error
					Case 1 ; OpenProcess failed
						SetDebugLog("Process close error: OpenProcess failed")
					Case 2 ; AdjustTokenPrivileges Failed
						SetDebugLog("Process close error: AdjustTokenPrivileges Failed")
					Case 3 ; TerminateProcess Failed
						SetDebugLog("Process close error: TerminateProcess Failed")
					Case 4 ; Cannot verify if process exists
						SetDebugLog("Process close error: Cannot verify if process exists")
				EndSwitch
			EndIf
			If ProcessExists($iPid) Then ; If it is still running, then try again
				ShellExecute(@WindowsDir & "\System32\taskkill.exe", " -pid " & $iPid, "", Default, @SW_HIDE)
				If _Sleep(1000) Then Return False; Give OS time to work
				If ProcessExists($iPid) = 0 Then
					SetDebugLog("KillProcess(" & $iCount & "): PID = " & $iPid & " killed (using taskkill)" & $sProcess_info)
				EndIf
			EndIf
			If ProcessExists($iPid) Then ; If it is still running, then force kill it (and entire tree!)
				ShellExecute(@WindowsDir & "\System32\taskkill.exe", "-f -t -pid " & $iPid, "", Default, @SW_HIDE)
				If _Sleep(1000) Then Return False; Give OS time to work
				If ProcessExists($iPid) = 0 Then
					SetDebugLog("KillProcess(" & $iCount & "): PID = " & $iPid & " killed (using taskkill -f -t)" & $sProcess_info)
				EndIf
			EndIf
			$iCount += 1
		WEnd
		If ProcessExists($iPid) Then
			SetDebugLog("KillProcess(" & $iCount & "): PID = " & $iPid & " failed to kill" & $sProcess_info, $COLOR_ERROR)
			Return False
		EndIf
	Else
		SetDebugLog("KillProcess(" & "None" & "): PID = " & $iPid & " closed" & $sProcess_info)
	EndIf
	Return True ; process ssuccessfuly killed
EndFunc   ;==>KillProcess
