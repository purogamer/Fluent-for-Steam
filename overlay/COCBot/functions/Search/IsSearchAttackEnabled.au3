; #FUNCTION# ====================================================================================================================
; Name ..........: IsSearchAttackEnabled
; Description ...: Determines if user has selected to not attack.  Uses GUI schedule, random time, or daily attack limit options to stop attacking
; Syntax ........: IsSearchAttackEnabled()
; Parameters ....:
; Return values .: True = attacking is enabled, False = if attacking is disabled
;					 .; Will return error code if problem determining random no attack time.
; Author ........: MonkeyHunter (06-2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func IsSearchAttackEnabled()

	SetDebugLog("Begin IsSearchAttackScheduled:", $COLOR_DEBUG1)
	
	; Defense troops - Team AIO Mod++
	If IsRequestDefense(False) Then
		SetLog("Skip Attack, Because your CC Planned to have Defense Troops.", $COLOR_INFO)
		Return False
	EndIf

	If $g_bAttackPlannerEnable = False Then Return True ; return true if attack planner is not enabled

	Local $sStartTime = "", $sEndTime = ""
	Local $aNoAttackTimes[2] = [$sStartTime, $sEndTime] ; array to hold start/end time for when attacking is disabled.
	Local $iWaitTime = 0
	
	; Custom schedule - Team AIO Mod++
	Local $bCloseGame = $g_bAttackPlannerCloseCoC = True Or $g_bAttackPlannerCloseAll = True Or $g_bAttackPlannerSuspendComputer = True
	If $g_bDebugSetlog Then SetDebugLog("$bCloseGame:" & $bCloseGame, $COLOR_DEBUG)
	$g_bAttackAccountReachLimts[$g_iCurAccount] = _OverAttackLimit()
	SetDebugLog("$g_bAccountReachLimts:" & $g_bAttackAccountReachLimts[$g_iCurAccount], $COLOR_DEBUG)
	
	If $g_bAttackPlannerDayLimit = True And $g_bAttackAccountReachLimts[$g_iCurAccount] Then
		SetLog("Daily attack limit reached, skip attacks till new day starts!", $COLOR_INFO)
		If _Sleep($DELAYRESPOND) Then Return True
		If ProfileSwitchAccountEnabled() Then Return False
		If $bCloseGame Then
			$iWaitTime = _getTimeRemainTimeToday()
			UniversalCloseWaitOpenCoC($iWaitTime * 1000, "IsSearchAttackScheduled_", $g_bAttackPlannerCloseAll, True, $g_bAttackPlannerSuspendComputer)
			$g_bRestart = True
			Return
		Else
			Return False
		EndIf
	EndIf

	If $g_bAttackPlannerRandomEnable Then ; random attack start/stop selected
		$aNoAttackTimes = _getDailyRandomStartEnd($g_iAttackPlannerRandomTime) ; determine hours to start/end attack today
		If @error Then ; log extended error message and return false to keep attacking if something strange happens
			SetLog(@extended, $COLOR_ERROR)
			Return True
		EndIf
		If _IsTimeInRange($aNoAttackTimes[0], $aNoAttackTimes[1]) Then ; returns true if time now is between start/end time
			SetLog("Attack schedule random skip time found", $COLOR_INFO)
			If _Sleep($DELAYRESPOND) Then Return True
			If ProfileSwitchAccountEnabled(True) Then Return False
			If $bCloseGame Then
				$iWaitTime = _DateDiff("s", _NowCalc(), $aNoAttackTimes[1]) ; find time to stop attacking in seconds
				If @error Then
					_logErrorDateDiff(@error)
					SetError(1, "Can not find NoAttack wait time", True)
					Return True
				EndIf
				UniversalCloseWaitOpenCoC($iWaitTime * 1000, "IsSearchAttackScheduled_", $g_bAttackPlannerCloseAll, True, $g_bAttackPlannerSuspendComputer) ; Close and Wait for attacking to start
				$g_bRestart = True
				Return
			Else
				Return False ; random time to stop attack found let bot idle
			EndIf
		Else
			Return True
		EndIf
	Else ; if not random stop attack time, use attack planner times set in GUI
		If IsPlannedTimeNow() = False Then
			SetLog("Attack schedule planned skip time found", $COLOR_INFO)
			If _Sleep($DELAYRESPOND) Then Return True
			If ProfileSwitchAccountEnabled(True) Then Return False
			If $bCloseGame Then
				; Custom schedule - Team AIO Mod++
				; determine how long to close CoC or emulator if selected
				If $g_abPlannedAttackWeekDays[$g_iCurAccount][@WDAY - 1] = False Then
					$iWaitTime = _getTimeRemainTimeToday() ; get number of seconds remaining till Midnight today
					For $i = @WDAY To 6
						If Not $g_abPlannedAttackWeekDays[$g_iCurAccount][$i] Then $iWaitTime += 86400 ; add 1 day of seconds to wait time
						If $g_abPlannedAttackWeekDays[$g_iCurAccount][$i] Then ExitLoop ; stop adding days when find attack planner enabled
						SetDebugLog("Subtotal wait time= " & $iWaitTime & " Seconds", $COLOR_DEBUG)
					Next
				EndIf
				If $iWaitTime = 0 Then ; if days are not set then compute wait time from hours
					If $g_abPlannedAttackWeekDays[$g_iCurAccount][@WDAY - 1] And $g_abPlannedattackHours[$g_iCurAccount][@HOUR] = False Then
						$iWaitTime += (59 - @MIN) * 60 ; compute seconds left this hour
						For $i = @HOUR + 1 To 23
							If Not $g_abPlannedattackHours[$g_iCurAccount][$i] Then $iWaitTime += 3600 ; add 1 hour of seconds to wait time
							If $g_abPlannedattackHours[$g_iCurAccount][$i] Then ExitLoop ; stop adding hours when find attack planner enabled
							SetDebugLog("Subtotal wait time= " & $iWaitTime & " Seconds", $COLOR_DEBUG)
						Next
					EndIf
				EndIf
				SetDebugLog("Stop attack wait time= " & $iWaitTime & " Seconds", $COLOR_DEBUG)
				; close emulator as directed
				UniversalCloseWaitOpenCoC($iWaitTime * 1000, "IsSearchAttackScheduled_", $g_bAttackPlannerCloseAll, True, $g_bAttackPlannerSuspendComputer) ; Close and Wait for attacking to start
				$g_bRestart = True
				Return
			Else
				Return False ; if not planned to close anything, then stop attack
			EndIf
		EndIf
	EndIf
	Return True
EndFunc   ;==>IsSearchAttackEnabled

Func _getTimeRemainTimeToday()
	; calculates number of seconds left till midnight today
	Local $iTimeRemain = _DateDiff("s", _NowCalc(), _NowCalcDate() & " 23:59:59")
	If @error Then
		_logErrorDateDiff(@error)
		SetError(1, "Can not determine time remaining today", 0)
		Return
	EndIf
	SetDebugLog("getTimeRemainToday= " & $iTimeRemain & " Seconds", $COLOR_DEBUG)
	Return $iTimeRemain
EndFunc   ;==>_getTimeRemainTimeToday

Func _IsTimeAfter($sCompareTime, $sCurrentTime = _NowCalc())
	; Check to see if the amount of seconds remaining is less than 0
	Local $bResult = _DateDiff("s", $sCurrentTime, $sCompareTime) < 0
	If @error Then
		_logErrorDateDiff(@error)
		SetError(1, "Can not check if time is after", False)
		Return
	EndIf
	SetDebugLog("IsTimeAfter: " & $bResult, $COLOR_DEBUG)
	Return $bResult
EndFunc   ;==>_IsTimeAfter

Func _IsTimeBefore($sCompareTime, $sCurrentTime = _NowCalc())
	; Check to see if the amount of seconds remaining is greater than 0
	Local $bResult = _DateDiff("s", $sCurrentTime, $sCompareTime) > 0
	If @error Then
		_logErrorDateDiff(@error)
		SetError(1, "Can not check if time is before", False)
		Return
	EndIf
	SetDebugLog("IsTimeBefore: " & $bResult, $COLOR_DEBUG)
	Return $bResult
EndFunc   ;==>_IsTimeBefore

Func _IsTimeInRange($sStartTime, $sEndTime)
	Local $sCurrentTime = _NowCalc()
	; Calculate if time until start time is less than 0 And time until end time is greater than 0
	Local $bResult = _IsTimeAfter($sStartTime, $sCurrentTime) And _IsTimeBefore($sEndTime, $sCurrentTime)
	SetDebugLog("IsTimeInRange: " & $bResult, $COLOR_DEBUG)
	Return $bResult ; Returns true if current time is within the range
EndFunc   ;==>_IsTimeInRange

Func _getDailyRandomStartEnd($iDuration = 4)
	Local $iStartHour, $iEndHour
	Local Static $iNowDay = @YDAY ; record numeric value for today
	If Not ($iDuration >= 0 And $iDuration <= 24) Then ; check input duration value
		SetError(1, "Invalid duration for _getDailyRandomStartEnd")
		Return
	EndIf
	; find 1st day random starting time
	Local $sStartTime = _DateAdd("h", Int(_getDailyRandom() * (23 - @HOUR)), _NowCalc()) ; find initial random time during rest of day
	If @error Then
		_logErrorDateDiff(@error)
		SetError(2, "Can not create initial random start time")
		Return
	EndIf
	; find 1st day random end time
	Local $sEndTime = _DateAdd("h", Int($iDuration), $sStartTime) ; add duration to start time
	If @error Then
		_logErrorDateDiff(@error)
		SetError(3, "Can not create initial random end time")
		Return
	EndIf
	Local Static $aNoAttackTimes[2] = [$sStartTime, $sEndTime] ; create return array with default values

	If $iNowDay <> @YDAY Then ; if 1 day or more has passed since last time, compute new random start/stop times
		$iStartHour = _getDailyRandom() * 24
		If $iStartHour <= @HOUR Then $iStartHour = @HOUR + 1.166 ; check if random start is before now, if yes add 70 minutes
		$iEndHour = $iStartHour + $iDuration
		SetDebugLog("StartHour: " & $iStartHour & "EndHour: " & $iEndHour, $COLOR_DEBUG)
		$aNoAttackTimes[0] = _DateAdd("h", Int($iStartHour), _NowCalc()) ; create proper date/time string with start time
		If @error Then
			_logErrorDateDiff(@error)
			SetError(4, "Can not create random start time")
			Return
		EndIf
		$aNoAttackTimes[1] = _DateAdd("h", Int($iEndHour), _NowCalc()) ; create proper date/time string with end time
		If @error Then
			_logErrorDateDiff(@error)
			SetError(5, "Can not create random end time")
			Return
		EndIf
	EndIf
	SetDebugLog("NoAttackStart: " & $aNoAttackTimes[0] & "NoAttackEnd: " & $aNoAttackTimes[1], $COLOR_DEBUG)
	Return $aNoAttackTimes ; return array with start/end time
EndFunc   ;==>_getDailyRandomStartEnd

Func _getDailyRandom()
	Local Static $iDailyRandomValue = Random(0.001, 1, 4) ; establish initial random value
	Local Static $iNowDay = @YDAY ; record numeric value for today
	If $iNowDay <> @YDAY Then ; if 1 day or more has passed since last time, update daily random value
		$iDailyRandomValue = Round(Random(0.001, 1), 4) ; set random value
		$iNowDay = @YDAY ; set new year day value
		SetDebugLog("New day = new random value!", $COLOR_DEBUG)
	EndIf
	SetDebugLog("DailyRandomValue=" & StringFormat("%0.5f", $iDailyRandomValue), $COLOR_DEBUG)
	Return $iDailyRandomValue
EndFunc   ;==>_getDailyRandom

; Custom schedule - Team AIO Mod++
Func IsPlannedTimeNow($bLog = True, $account = $g_iCurAccount)
	Local $hour, $hourloot
	If $g_abPlannedAttackWeekDays[$account][@WDAY - 1] = True Then
		$hour = StringSplit(_NowTime(4), ":", $STR_NOCOUNT)
		$hourloot = $hour[0]
		SetDebugLog("IsplannedTimeNow|$g_iCurAccount: " & $account)
		SetDebugLog("IsplannedTimeNow|$g_asProfileName: " & $g_asProfileName[$account])
		SetDebugLog("IsplannedTimeNow|$g_sProfileCurrentName: " & $g_sProfileCurrentName)
		For $z = 0 To UBound($g_abPlannedattackHours, $UBOUND_COLUMNS) - 1
			SetDebugLog("Hour [" & $z & "]: " & $g_abPlannedattackHours[$account][$z])
		Next
		If $g_abPlannedattackHours[$account][$hourloot] = True Then
			SetDebugLog("IsPlannedTimeNow|Attack plan enabled for now..", $COLOR_DEBUG)
			Return True
		Else
			If $bLog Then SetLog("Attack plan enabled today, but not this hour!", $COLOR_INFO)
			If _Sleep($DELAYRESPOND) Then Return False
			Return False
		EndIf
	Else
		If $bLog Then SetLog("Attack plan not enabled today!", $COLOR_INFO)
		If _Sleep($DELAYRESPOND) Then Return False
		Return False
	EndIf
EndFunc   ;==>IsPlannedTimeNow

; Custom schedule - Team AIO Mod++
Func _OverAttackLimit()
	Local Static $iAttackCountToday[$g_eTotalAcc] = ["-"]
	If $iAttackCountToday[0] = "-" Then
		For $ib = 0 To UBound($iAttackCountToday) -1
			$iAttackCountToday[$ib] = 0
		Next
	EndIf
	Local Static $iTotalAttackCount[$g_eTotalAcc] = ["-"]
	If $iTotalAttackCount[0] = "-" Then
		For $ib = 0 To UBound($iTotalAttackCount) -1
			$iTotalAttackCount[$ib] = 0
		Next
	EndIf
	Local Static $iNowDay[$g_eTotalAcc] = ["-"]
	If $iNowDay[0] = "-" Then
		For $ib = 0 To UBound($iNowDay) -1
			$iNowDay[$ib] = 0
		Next
	EndIf

	SetDebugLog("OverAttackLimit|$iNowDay: " & $iNowDay[$g_iCurAccount])
	If ProfileSwitchAccountEnabled(True) Then
		SetDebugLog("_OverAttackLimit| Switch accounts enabled")
		; For $i = 0 To UBound($g_aiAttackedCountAcc) - 1
			; SetDebugLog("_OverAttackLimit| $g_aiAttackedCountAcc[" & $i & "]" & $g_aiAttackedCountAcc[$i])
			; SetDebugLog("_OverAttackLimit| $iAttackCountToday[" & $i & "]" & $iAttackCountToday[$i])
			; SetDebugLog("_OverAttackLimit| $iTotalAttackCount[" & $i & "]" & $iTotalAttackCount[$i])
		; Next
		$g_aiAttackedCount = $g_aiAttackedCountAcc[$g_iCurAccount]
	EndIf
	If $iNowDay[$g_iCurAccount] <> @YDAY Or $iNowDay[$g_iCurAccount] = 0 Then
		SetDebugLog("New Day New Count! Reset Daily Counts!")
		$iAttackCountToday[$g_iCurAccount] = 0
		$iNowDay[$g_iCurAccount] = @YDAY
		$iTotalAttackCount[$g_iCurAccount] = $g_aiAttackedCount
	Else
		$iAttackCountToday[$g_iCurAccount] = $g_aiAttackedCount - $iTotalAttackCount[$g_iCurAccount]
	EndIf
	SetDebugLog("_OverAttackLimit|AttackCountToday: " & $iAttackCountToday[$g_iCurAccount] & ", $g_aiAttackedCount: " & $g_aiAttackedCount & ", TotalAttackCount: " & $iTotalAttackCount[$g_iCurAccount], $COLOR_DEBUG)
	Local $iRandomAttackCountToday = Ceiling(Int($g_iAttackPlannerDayMin) + (_getDailyRandom() * (Int($g_iAttackPlannerDayMax) - Int($g_iAttackPlannerDayMin))))
	If $iRandomAttackCountToday > Int($g_iAttackPlannerDayMax) Then $iRandomAttackCountToday = Int($g_iAttackPlannerDayMax)
	SetDebugLog("_OverAttackLimit|RandomAttackCountToday: " & $iRandomAttackCountToday, $COLOR_DEBUG)
	If $iAttackCountToday[$g_iCurAccount] >= $iRandomAttackCountToday Then
		SetDebugLog("_OverAttackLimit: " & True)
		Return True
	EndIf
	SetDebugLog("_OverAttackLimit: " & False)
	Return False
EndFunc   ;==>_OverAttackLimit
