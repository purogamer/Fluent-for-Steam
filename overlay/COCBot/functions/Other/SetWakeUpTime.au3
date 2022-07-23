;===============================================================================
;
; Description:    Sets a wakeup time to wake it up if the system / computer is hibernating or standby
; Parameter(s):    $Hour    - Hour Values   : 0-23
;                  $Minute  - Minutes Values: 0-59
;                  $Second  - Second Values: 0-59  (optional)
;                  $Day     - Days Values   : 1-31 (optional)
;                  $Month   - Month Values  : 1-12 (optional)
;                  $Year    - Year Values   : > 0  (optional)
;
; Requirement(s):   DllCall
; Return Value(s):  On Success - 1
;                   On Failure - 0 sets @ERROR = 1 and @EXTENDED (Windows API error code)
;
; Error code(s):    [url=http://msdn.microsoft.com/library/default.asp?url=/library/en-us/debug/base/system_error_codes.asp]http://msdn.microsoft.com/library/default....error_codes.asp[/url]
;
; Author(s):        Bastel123 aka Sebastian
; Note(s):          -
;
;===============================================================================
#include-once
#include <date.au3>

Global $g_hWaitableTimerWakeUp = 0

Func SetWakeUpTime($Hour, $Minute, $Second = 0, $Day = @MDAY, $Month = @MON, $Year = @YEAR)

	SetDebugLog("SetWakeUpTime: " & $Hour & ":" & $Minute & "." & $Second & " " & $Day & "/" & $Month & "/" & $Year)

	Local $SYSTEMTIME = DllStructCreate("word;word;word;word;word;word;word;word")
	Local $lpSYSTEMTIME = DllStructGetPtr($SYSTEMTIME)
	Local $LOCALFILETIME = DllStructCreate("dword;dword")
	Local $lpLOCALFILETIME = DllStructGetPtr($LOCALFILETIME)
	Local $DueTime = DllStructCreate("dword;dword")
	Local $lpDueTime = DllStructGetPtr($DueTime)

	DllStructSetData($SYSTEMTIME, 1, $Year)
	DllStructSetData($SYSTEMTIME, 2, $Month)
	DllStructSetData($SYSTEMTIME, 3, _DateToDayOfWeek($Year, $Month, $Day) - 1)
	DllStructSetData($SYSTEMTIME, 4, $Day)
	DllStructSetData($SYSTEMTIME, 5, $Hour)
	DllStructSetData($SYSTEMTIME, 6, $Minute)
	DllStructSetData($SYSTEMTIME, 7, $Second)
	DllStructSetData($SYSTEMTIME, 8, 0)

	Local $result = DllCall("kernel32.dll", "long", "SystemTimeToFileTime", "ptr", $lpSYSTEMTIME, "ptr", $lpLOCALFILETIME)
	If $result[0] = 0 Then
		Local $lastError = DllCall("kernel32.dll", "int", "GetLastError")
		SetExtended($lastError[0])
		SetError(1)
		Return 0
	EndIf
	$result = DllCall("kernel32.dll", "long", "LocalFileTimeToFileTime", "ptr", $lpLOCALFILETIME, "ptr", $lpLOCALFILETIME)
	If $result[0] = 0 Then
		Local $lastError = DllCall("kernel32.dll", "int", "GetLastError")
		SetExtended($lastError[0])
		SetError(1)
		Return 0
	EndIf

	If $g_hWaitableTimerWakeUp Then _WinAPI_CloseHandle($g_hWaitableTimerWakeUp)

	$result = DllCall("kernel32.dll", "long", "CreateWaitableTimer", "long", 0, "boolean", True, "str", "MyBot.run")
	If $result[0] = 0 Then
		Local $lastError = DllCall("kernel32.dll", "int", "GetLastError")
		SetExtended($lastError[0])
		SetError(1)
		Return 0
	EndIf
	$g_hWaitableTimerWakeUp = $result[0]
	DllCall("kernel32.dll", "none", "CancelWaitableTimer", "long", $g_hWaitableTimerWakeUp)

	DllStructSetData($DueTime, 1, DllStructGetData($LocalFILETIME, 1))
	DllStructSetData($DueTime, 2, DllStructGetData($LocalFILETIME, 2))

	$result = DllCall("kernel32.dll", "boolean", "SetWaitableTimer", "handle", $g_hWaitableTimerWakeUp, "ptr", $lpDueTime, "long", 0, "ptr", 0, "ptr", 0, "boolean", True)
	If $result[0] = 0 Then
		Local $lastError = DllCall("kernel32.dll", "int", "GetLastError")
		SetExtended($lastError[0])
		SetError(1)
		Return 0
	EndIf
	Return 1
EndFunc   ;==>SetWakeUpTime

Func SetWakeUpSeconds($iInSecs)

	SetDebugLog("SetWakeUpTime: " & $iInSecs & " Seconds")

	If $g_hWaitableTimerWakeUp Then _WinAPI_CloseHandle($g_hWaitableTimerWakeUp)

	Local $result = DllCall("kernel32.dll", "long", "CreateWaitableTimer", "long", 0, "boolean", True, "str", "")
	If $result[0] = 0 Then
		Local $lastError = DllCall("kernel32.dll", "int", "GetLastError")
		SetExtended($lastError[0])
		SetError(1)
		Return 0
	EndIf
	$g_hWaitableTimerWakeUp = $result[0]
	DllCall("kernel32.dll", "none", "CancelWaitableTimer", "long", $g_hWaitableTimerWakeUp)

	Local $iNanoSecs = -$iInSecs * 1000 * 1000 * 10;

	$result = DllCall("kernel32.dll", "boolean", "SetWaitableTimer", "handle", $g_hWaitableTimerWakeUp, "INT64*", $iNanoSecs, "long", 0, "ptr", 0, "ptr", 0, "boolean", True)
	If $result[0] = 0 Then
		Local $lastError = DllCall("kernel32.dll", "int", "GetLastError")
		SetExtended($lastError[0])
		SetError(2)
		Return 0
	EndIf
	Return 1
EndFunc   ;==>SetWakeUpSeconds

;===============================================================================
;
; Description:    Set the computer in Hibernate or Standby Status
; Parameter(s):  $bSuspend  - Suspend mode  : True=Suspend, False=Hibernate
;                  $bForce  - Force-Mode    : True=the system suspends operation immediately
;                                             False=FALSE, the system broadcasts a PBT_APMQUERYSUSPEND event to each application to request permission to suspend operation
;
; Requirement(s):   DllCall
;
; Author(s):        Bastel123 aka Sebastian
; Note(s):        If the system does not support hibernate use the standby mode       -
;
;===============================================================================
Func SetSuspend($bSuspend = True, $bForce = True)
	Local $bDisableWakeEvent = False
	Local $result = DllCall("PowrProf.dll", "boolean", "SetSuspendState", "boolean", Not $bSuspend, "boolean", $bForce, "boolean", $bDisableWakeEvent)
	;Local $result = DllCall("kernel32.dll", "boolean", "SetSystemPowerState", "boolean", $bSuspend, "boolean", $bForce)
	If @error Or UBound($result) = 0 Then
		Local $lastError = DllCall("kernel32.dll", "int", "GetLastError")
		SetExtended($lastError[0])
		SetError(1)
		Return 0
	EndIf
	Return $result[0]
EndFunc   ;==>SetSuspend

#cs
; manual testing
Func SetDebugLog($Message)
	ConsoleWrite(_NowCalc() & "." & @MSEC & ": " & $Message & @CRLF)
EndFunc
SetDebugLog("> SetWakeUpSeconds")
SetWakeUpSeconds(60)
SetDebugLog("< SetWakeUpSeconds " & @error & "," & @extended)
SetDebugLog("> SetSuspend")
SetSuspend()
SetDebugLog("< SetSuspend " & @error & "," & @extended)
SetDebugLog("Sleep 10000")
Sleep(10000)
SetDebugLog("> SetWakeUpSeconds")
SetWakeUpSeconds(120)
SetDebugLog("< SetWakeUpSeconds " & @error & "," & @extended)
SetDebugLog("> SetSuspend")
SetSuspend()
SetDebugLog("< SetSuspend " & @error & "," & @extended)
#ce