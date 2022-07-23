; #FUNCTION# ====================================================================================================================
; Name ..........: CheckAndroidTimeLag
; Description ...: Function to check time inside Android matching host time
; Syntax ........: CheckAndroidTimeLag()
; Parameters ....: $bRebootAndroid = True reboots Android if time lag > $g_iAndroidTimeLagThreshold
; Return values .: True if Android reboot should be initiated, False otherwise
;                  @extended = time lag in Seconds per Minutes
;                  @error = 1 : Time lag check not available
;                           2 : Time lag variables initialized
;                           3 : Time lag cannot be calculated, subsequent call within 60 Seconds
;                           4 : ADB shell error
;                           5 : ADB date +%s returned not a number >= 1
;                           6 : Android elapsed time is <= 0
; Author ........: Cosote (03-2016)
; Modified ......: CodeSlinger69 (01-2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2016-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: If CheckAndroidTimeLag() = True Then Return
; ===============================================================================================================================
#include-once

Func InitAndroidTimeLag($bResetProblemCounter = True)
	$g_aiAndroidTimeLag[0] = 0 ; Time lag in Secodns determined
	$g_aiAndroidTimeLag[1] = 0 ; UTC time of Android in Seconds
	$g_aiAndroidTimeLag[2] = 0 ; AutoIt TimerHandle
	$g_aiAndroidTimeLag[3] = 0 ; Suspended time of Android in Milliseconds
	If $bResetProblemCounter = True Then
		$g_aiAndroidTimeLag[4] = 0 ; # of time lag problems detected
		$g_aiAndroidTimeLag[5] = 0 ; TimerInit handle of last time lag problem
	EndIf
EndFunc   ;==>InitAndroidTimeLag

Func CheckAndroidTimeLag($bRebootAndroid = True)

	SetError(0, 0)
	If $g_bAndroidCheckTimeLagEnabled = False Then Return SetError(1, 0, False)

	Local $androidUTC = $g_aiAndroidTimeLag[1]
	Local $hostTimer = $g_aiAndroidTimeLag[2]

	If $hostTimer <> 0 And __TimerDiff($hostTimer) / 1000 < 60 Then
		; exit as not ready to compare time
		Return SetError(3, 0, False)
	EndIf

	; check if problem count should be reseted
	If $g_aiAndroidTimeLag[4] > 0 And $g_aiAndroidTimeLag[5] <> 0 And __TimerDiff($g_aiAndroidTimeLag[5]) > $g_iAndroidTimeLagResetProblemCountMinutes * 60000 Then
		SetDebugLog("Time lag problems count of " & $g_aiAndroidTimeLag[4] & " reset to 0 due to " & Round(__TimerDiff($g_aiAndroidTimeLag[5]) / 1000, 0) & " Seconds with an incident")
		$g_aiAndroidTimeLag[4] = 0
		$g_aiAndroidTimeLag[5] = 0
	EndIf

	; get Android UTC
	Local $s = AndroidAdbSendShellCommand("date +%s")
	If @error <> 0 Then Return SetError(4, 0, False)

	Local $curr_androidUTC = Number($s)
	Local $curr_hostTimer = __TimerInit()

	If $curr_androidUTC < 1 Then
		InitAndroidTimeLag(False)
		Return SetError(5, 0, False)
	EndIf

	If $androidUTC = 0 Or $hostTimer = 0 Then
		; init time
		$g_aiAndroidTimeLag[1] = $curr_androidUTC
		$g_aiAndroidTimeLag[2] = $curr_hostTimer
		$g_aiAndroidTimeLag[3] = 0
		Return SetError(2, 0, False)
	EndIf

	; calculate lag
	Local $hostSeconds = Int(__TimerDiff($hostTimer) / 1000)
	Local $hostMinutes = $hostSeconds / 60
	Local $androidSeconds = $curr_androidUTC - $androidUTC

	Local $lagTotal = $hostSeconds - $androidSeconds
	Local $lagComp = Int($g_aiAndroidTimeLag[3] / 1000) ; compensate Android Resume time lag during Village Search (as only required there)
	$lagTotal -= $lagComp
	Local $lagPerMin = Int($lagTotal / $hostMinutes)

	SetDebugLog($g_sAndroidEmulator & " time lag is " & ($lagPerMin > 0 ? "> " : "") & $lagPerMin & " sec/min (avg for " & $hostSeconds & " sec, Android suspend time was " & $lagComp & " sec)")

	If $androidSeconds <= 0 Then
		InitAndroidTimeLag(False)
		Return SetError(6, 0, False)
	EndIf

	If $lagPerMin < 0 Then $lagPerMin = 0

	; update array
	$g_aiAndroidTimeLag[0] = $lagPerMin
	$g_aiAndroidTimeLag[1] = $curr_androidUTC
	$g_aiAndroidTimeLag[2] = $curr_hostTimer
	$g_aiAndroidTimeLag[3] = 0

	If $lagPerMin > $g_iAndroidTimeLagThreshold Then
		$g_aiAndroidTimeLag[4] += 1 ; increase problem counter
		$g_aiAndroidTimeLag[5] = __TimerInit()
		SetLog($g_aiAndroidTimeLag[4] & ". Time lag detected of " & $lagPerMin & " sec/min for " & $g_sAndroidEmulator, $COLOR_ERROR)
		InitAndroidTimeLag(False)
	EndIf

	Local $bReboot = False
	If $bRebootAndroid And $g_aiAndroidTimeLag[4] >= $g_iAndroidTimeLagRebootThreshold Then
		SetLog("Rebooting " & $g_sAndroidEmulator & " due to " & $g_aiAndroidTimeLag[4] & " time lag problems", $COLOR_ERROR)
		$bReboot = True
		;Else
		;SetLog($g_sAndroidEmulator & " suffered time lag of " & $lagPerMin & " sec/min (reboot skipped)", $COLOR_ERROR)
	EndIf

	Return SetError(0, $lagPerMin, $bReboot)
EndFunc   ;==>CheckAndroidTimeLag
