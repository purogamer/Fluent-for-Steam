; #FUNCTION# ====================================================================================================================
; Name ..........: _TicksToDay
; Description ...: Converts the specified tick amount to days, hours, minutes and seconds
; Syntax ........: _TicksToDay($iTicks, ByRef $iDays, ByRef $iHours, ByRef $iMins, ByRef $iSecs)
; Parameters ....: $iTicks				- Tick amount.
;				   $iDays				- Variable to store the days
;				   $iHours				- Variable to store the hours.
;				   $iMins				- Variable to store the minutes.
;				   $iSecs				- Variable to store the seconds.
; Return values .: Success: 			1
;				   Failure: 			0 and sets the @error flag to non-zero.
;				   @error: 				1 - $iTicks < 0
; Author ........: MMHK (May-2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......: _TicksToTime
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func _TicksToDay($iTicks, ByRef $iDays, ByRef $iHours, ByRef $iMins, ByRef $iSecs)

	_TicksToTime($iTicks, $iHours, $iMins, $iSecs)
	If @error Then Return SetError(1, 0, 0) ; $iTicks < 0

	$iDays = Int($iHours / 24)
	$iHours = Mod($iHours, 24)

	Return 1
EndFunc   ;==>_TicksToDay
