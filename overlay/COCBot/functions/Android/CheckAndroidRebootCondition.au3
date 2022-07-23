; #FUNCTION# ====================================================================================================================
; Name ..........: CheckAndroidRebootCondition
; Description ...: Function to check if Android needs to reboot after x hours
; Syntax ........: CheckAndroidRebootCondition()
; Parameters ....: $bRebootAndroid = True reboots Android
; Return values .: True if Android reboot should be initiated, False otherwise
; Author ........: Cosote (10-2017)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2016-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: If CheckAndroidTimeLag() = True Then Return
; ===============================================================================================================================
#include-once

Func InitAndroidRebootCondition($bLaunched = True)
	If $bLaunched = False Then
		$g_hAndroidLaunchTime = 0
		Return False
	EndIf
	$g_hAndroidLaunchTime = __TimerInit()
	Return True
EndFunc   ;==>InitAndroidRebootCondition

Func CheckAndroidRebootCondition($bRebootAndroid = True, $bLogOnly = False)
	
	If $g_hAndroidLaunchTime = 0 Then InitAndroidRebootCondition(True) ; Android was already launched, start time now
	
	; check for additional reboot conditions
	If $g_bGfxError Then
		$g_bGfxError = False
		SetLog("Reboot " & $g_sAndroidEmulator & " (" & $g_sAndroidInstance & ") due to detected Gfx Errors")
		Return True
	EndIF
	
	GetCOCDistributors() ; load of distributors to prevent rare bot freeze during boot
	
	; check only for timeout reboot condition
	If $g_iAndroidRebootHours <= 0 Then Return False

	Local $iLaunched = __TimerDiff($g_hAndroidLaunchTime)

	If $bLogOnly = True Then

		Local $day = 0, $hour = 0, $min = 0, $sec = 0, $sTime
		_TicksToDay($g_iAndroidRebootHours * 60 * 60 * 1000 - $iLaunched, $day, $hour, $min, $sec)
		;$sTime = $day > 0 ? StringFormat("%2u Day(s) %02i:%02i:%02i", $day, $hour, $min, $sec) : StringFormat("%02i:%02i:%02i", $hour, $min, $sec)
		$sTime = StringFormat("%id %ih %im", $day, $hour, $min)
		SetLog($g_sAndroidEmulator & " (" & $g_sAndroidInstance & ") will be automatically rebooted in " & $sTime)
		Return True

	EndIf

	If $g_bIdleState = False Then Return False

	Local $iRunTimeHrs = $iLaunched / (60 * 60 * 1000)

	If $iRunTimeHrs >= $g_iAndroidRebootHours Then
		SetLog("Reboot " & $g_sAndroidEmulator & " (" & $g_sAndroidInstance & ") due to configured run-time of " & $g_iAndroidRebootHours & "h")
		Return True
	EndIf

	Return False

EndFunc   ;==>CheckAndroidRebootCondition
