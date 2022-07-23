; #FUNCTION# ====================================================================================================================
; Name ..........: _SleepStatus
; Description ...: Update status bar with remaining timer
;				   Display as Day(s) 00:00:00, 00:00:00, 00:00
; Syntax ........: _SleepStatus($iDelay[, $iSleep = True[, $bDirection = True[, $CheckRunState = True]]])
; Parameters ....: $iDelay              - an integer value.
;                  $iSleep              - [optional] an integer value. Default is True.
;                  $bDirection          - [optional] a boolean value. Default is True.
;                  $CheckRunState       - [optional] a boolean value. Default is True to check for $g_bRunState.
;                  $iBeginTimer         - [Optional] initial __TimerInit()
; Return values .: False:				default for running bot
;				   True:				check for run state and bot's stopped
; Author ........: KnowJack (June-2015)
; Modified ......: MMHK (Dec-2016)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func _SleepStatus($iDelay, $iSleep = True, $bDirection = True, $CheckRunState = True, $iBeginTimer = __TimerInit())
	; $bDirection: True equals count down display, False equals count up display

	Local $iDay = 0, $iHour = 0, $iMin = 0, $iSec = 0
	Local $iCurTime, $iTime
	Local $bUpdate = True, $hLastUpdate
	Local $iDayCalc = 0, $iHourCalc = 0, $iMinCalc = 0, $iSecCalc = 0
	Local $sTimeWait, $sTimeLeftLapse = ",  Time Lapse = "


	_TicksToDay($iDelay, $iDay, $iHour, $iMin, $iSec)

	While __TimerDiff($iBeginTimer) < $iDelay
		If $g_bRunState = False And $CheckRunState = True Then Return True
		If $bUpdate Then
			$iCurTime = __TimerDiff($iBeginTimer)
			$iTime = $iCurTime ; display count up timer ; avoid flicker
			If $bDirection = True Then
				$iTime = $iDelay - $iCurTime ; display countdown timer
				$sTimeLeftLapse = ",  Time Left = "
			EndIf

			_TicksToDay($iTime, $iDayCalc, $iHourCalc, $iMinCalc, $iSecCalc)

			$sTimeWait = "Waiting Time = "
			Select
				Case $iDay > 0
					$sTimeWait &= StringFormat("%2u Day(s) ", $iDay)
					$sTimeLeftLapse &= StringFormat("%2u Day(s) ", $iDayCalc)
					ContinueCase
				Case $iHour > 0
					$sTimeWait &= StringFormat("%02u:", $iHour)
					$sTimeLeftLapse &= StringFormat("%02u:", $iHourCalc)
					ContinueCase
				Case Else
					$sTimeWait &= StringFormat("%02u:%02u", $iMin, $iSec)
					$sTimeLeftLapse &= StringFormat("%02u:%02u", $iMinCalc, $iSecCalc)
			EndSelect

			$hLastUpdate = __TimerInit()
			_GUICtrlStatusBar_SetTextEx($g_hStatusBar, " Status: " & $sTimeWait & $sTimeLeftLapse)
		EndIf
		_Sleep($DELAYSLEEP)
		$bUpdate = __TimerDiff($hLastUpdate) > 750
	WEnd
	If $g_bRunState = False And $CheckRunState = True Then Return True
	Return False
EndFunc   ;==>_SleepStatus
