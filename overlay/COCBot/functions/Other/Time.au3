; #FUNCTION# ====================================================================================================================
; Name ..........: Time
; Description ...: Gives the time in '[00:00:00 AM/PM]' format
; Syntax ........: Time()
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
Func Time() ;Gives the time in '[00:00:00 AM/PM]' format
	Return "[" & _NowTime(3) & "] "
EndFunc   ;==>Time

Func TimeDebug() ;Gives the time in '[14:00:00.000]' format
	Return "[" & @YEAR & "-" & @MON & "-" & @MDAY & " " & _NowTime(5) & "." & @MSEC & "] "
EndFunc   ;==>TimeDebug


; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name ..........: __TimerInit
; Description ...: Replacement function for standard function TimerInit() due errors with some CPU
;                : minimum resolution of _Date_Time_GetTickCount() is 12-18 milliseconds per tick and varies based on system hardware
; Syntax ........: __TimerInit()
; Parameters ....:
; Return values .: Returns number of milliseconds since PC was started
; Author ........: MonkeyHunter (2017-3)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func __TimerInit()
	Local $iCurrentTimeMSec = _Date_Time_GetTickCount()
	;If $iCurrentTimeMSec > 4060800000 Then ; Get tick limit is 49.7 days, or value wraps around to zero
		;SetLog("PC running too long, reboot PC soon!", $COLOR_WARNING) ; gives users ~48 hours to reboot PC
	;EndIf
	Return $iCurrentTimeMSec
EndFunc   ;==>__TimerInit

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name ..........: __TimerDiff
; Description ...: Returns time difference between $iTimeMsec parameter passed and current time in milliseconds, using system Tick Count
;					  : replacement function for standard TimerDiff() due errors with some CPU microcode
;                : minimum resolution of _Date_Time_GetTickCount() is 14-18 milliseconds per tick and varies based on system hardware
; Syntax ........: __TimerDiff([$iTimeMsec = 0])
; Parameters ....: $iTimeMsec           - an integer value of milliseconds since PC started
; Return values .: None
; Author ........: MonkeyHunter (2017-3)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func __TimerDiff($iTimeMsec)
	If $iTimeMsec <= 0 Then
		SetError(1, 0, 0) ; if time parameter is zero, then return zero as must be postiive integer or timerinit was not used first
		Return
	EndIf
	Local $iCurrentTimeMSec = _Date_Time_GetTickCount()
	If $iCurrentTimeMSec < $iTimeMsec Then ; If $iTimeMsec > 4294080000 (48.7 days) then time value wraps around to zero
		;SetLog("PC on more than 49.7 days, must reboot PC!", $COLOR_ERROR)
		;SetError(2, 0, 0)
		;Return
		$iTimeMsec = $iTimeMsec - 4294967296
	EndIf
	Return $iCurrentTimeMSec - $iTimeMsec
EndFunc   ;==>__TimerDiff


; #FUNCTION# ====================================================================================================================
; Name ..........: _HPTimerInit
; Description ...: Used to create initial timer count for timing functions that require greater accuracy than offered by TimerInit() & TimerDiff()
; Syntax ........: _HPTimerInit()
; Parameters ....:
; Return values .: Returns performance counter value based on system clock
; Author ........: MonkeyHunter (2017-3)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
;
Global $g_iHPTimerFreq = 0  ; use global storage for freq value, as it should not change unless PC Clock frequency changes.
;
Func _HPTimerInit()
	Local $iTimerCount = _WinAPI_QueryPerformanceCounter()
	If $iTimerCount = 0 Then
		Local $err = _WinAPI_GetLastError()
		SetLog("QueryPerformanceCounter error code: " & $err, $COLOR_ERROR)
		SetError(1, $err, 0)
		Return
	EndIf
	If $g_iHPTimerFreq = 0 Then
		$g_iHPTimerFreq = _WinAPI_QueryPerformanceFrequency() ; update counts per second if not known
		If $g_iHPTimerFreq = 0 Then
			Local $err = _WinAPI_GetLastError()
			SetLog("QueryPerformanceFrequency error code: " & $err, $COLOR_ERROR)
		Else
			SetDebugLog("QueryPerformanceFrequency is: " & $g_iHPTimerFreq)
		EndIf
	EndIf
	Return $iTimerCount
EndFunc   ;==>_HPTimerInit

; #FUNCTION# ====================================================================================================================
; Name ..........: _HPTimerDiff
; Description ...: returns total elapse milliseconds since _HpTimerInit was called
;                : Accuracy is approximately +/- 8ms when above 100ms total time, and about same accuracy as TimerInit() & TimerDiff() below 100msec
; Syntax ........: _HPTimerDiff($iOldTimerCount)
; Parameters ....: $iOldTimerCount      - an integer count value as received from _HPTimerInit().
; Return values .: integer time in milliseconds
; Author ........: MonkeyHunter (2017-3)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func _HPTimerDiff($iOldTimerCount)
	If $iOldTimerCount = 0 Then
		SetLog("Bad parameter data passed to _HPTimerDiff", $COLOR_ERROR)
		SetError(1, 0, 0)
		Return
	EndIf
	Local $iNewTimerCount = _WinAPI_QueryPerformanceCounter()
	If $iNewTimerCount = 0 Then
		Local $err = _WinAPI_GetLastError()
		SetLog("QueryPerformanceCounter error code: " & $err, $COLOR_ERROR)
		SetError(1, $err, 0)
		Return
	EndIf
	If $g_iHPTimerFreq = 0 Then
		SetLog("QueryPerformanceFrequency error code: " & $err & " ,Abort timer check", $COLOR_ERROR)
		Return 0
	EndIf
	#cs ; disabled, as effect was not as hoped
	Static $iCompensation = [10, 0, 0, 0]
	If $iCompensation[1] < $iCompensation[0] Then
		$iCompensation[1] += 1
		$iCompensation[2] += _WinAPI_QueryPerformanceCounter() - $iNewTimerCount
		$iCompensation[3] = $iCompensation[2] / $iCompensation[1]
		If $iCompensation[1] = $iCompensation[0] Then SetDebugLog("QueryPerformanceCounter compensation is: " & $iCompensation[3])
	EndIf
	Return (($iNewTimerCount - $iOldTimerCount - $iCompensation[3] * 2) / $g_iHPTimerFreq) * 1000 ; return milliseconds between init and now
	#ce
	Return (($iNewTimerCount - $iOldTimerCount) / $g_iHPTimerFreq) * 1000 ; return milliseconds between init and now
EndFunc   ;==>_HPTimerDiff

