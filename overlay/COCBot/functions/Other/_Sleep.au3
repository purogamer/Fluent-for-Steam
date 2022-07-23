; #FUNCTION# ====================================================================================================================
; Name ..........: _Sleep
; Description ...:
; Syntax ........: _Sleep($iDelay[, $iSleep = True])
; Parameters ....: $iDelay              - an integer value.
;                  $iSleep              - [optional] an integer value. Default is True. unused and deprecated
;                  $CheckRunState      - Exit and returns True if $g_bRunState is False
; Return values .: True when $g_bRunState is False otherwise True (also True if $CheckRunState=False)
; Author ........:
; Modified ......: CodeSlinger69 (2017), Team AIO Mod++ (2021)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Global $g_hTimer_SetTime = 0, $g_hTimer_PBRemoteControlInterval = 0, $g_hTimer_EmptyWorkingSetAndroid = 0, $g_hTimer_EmptyWorkingSetBot = 0

Func _Sleep($iDelayOri, $iSleep = True, $CheckRunState = True, $SleepWhenPaused = True)

	Local $iBegin = __TimerInit()

	debugGdiHandle("_Sleep")
	CheckBotRequests() ; check if bot window should be moved, minized etc.

	Local $iDelay = $iDelayOri + Round($iDelayOri * ($g_iInputAndroidSleep / 100))

	If SetCriticalMessageProcessing() = False Then

		If $g_bMoveDivider Then
			MoveDivider()
			$g_bMoveDivider = False
		EndIf

		If __TimerDiff($g_hTxtLogTimer) >= $g_iTxtLogTimerTimeout Then

			; Notify stuff
			If __TimerDiff($g_hTimer_PBRemoteControlInterval) >= $g_iPBRemoteControlInterval Or ($g_hTimer_PBRemoteControlInterval = 0 And $g_bNotifyRemoteEnable) Then
				NotifyRemoteControl()
				$g_hTimer_PBRemoteControlInterval = __TimerInit()
			EndIf

			; Android & Bot Stuff
			If (($g_iEmptyWorkingSetAndroid > 0 And __TimerDiff($g_hTimer_EmptyWorkingSetAndroid) >= $g_iEmptyWorkingSetAndroid * 1000) Or $g_hTimer_EmptyWorkingSetAndroid = 0) And $g_bRunState And TestCapture() = False Then
				If IsArray(getAndroidPos(True)) = 1 Then _WinAPI_EmptyWorkingSet(GetAndroidPid()) ; Reduce Working Set of Android Process
				$g_hTimer_EmptyWorkingSetAndroid = __TimerInit()
			EndIf
			If ($g_iEmptyWorkingSetBot > 0 And __TimerDiff($g_hTimer_EmptyWorkingSetBot) >= $g_iEmptyWorkingSetBot * 1000) Or $g_hTimer_EmptyWorkingSetBot = 0 Then
				ReduceBotMemory(False)
				$g_hTimer_EmptyWorkingSetBot = __TimerInit()
			EndIf

			CheckPostponedLog()

			If BotCloseRequestProcessed() Then
				BotClose() ; improve responsive bot close
				Return True
			EndIf
		EndIf
	EndIf

	If $CheckRunState And Not $g_bRunState Then
		ResumeAndroid()
		Return True
	EndIf
	Local $iRemaining = $iDelay - __TimerDiff($iBegin)
	While $iRemaining > 0
		DllCall($g_hLibNTDLL, "dword", "ZwYieldExecution")
		If $CheckRunState = True And $g_bRunState = False Then
			ResumeAndroid()
			Return True
		EndIf
		If SetCriticalMessageProcessing() = False Then
			If $g_bBotPaused And $SleepWhenPaused And $g_bTogglePauseAllowed Then TogglePauseSleep() ; Bot is paused
			If $g_bTogglePauseUpdateState Then TogglePauseUpdateState("_Sleep") ; Update Pause GUI states
			If $g_bMakeScreenshotNow = True Then
				If $g_bScreenshotPNGFormat = False Then
					MakeScreenshot($g_sProfileTempPath, "jpg")
				Else
					MakeScreenshot($g_sProfileTempPath, "png")
				EndIf
			EndIf
			If __TimerDiff($g_hTxtLogTimer) >= $g_iTxtLogTimerTimeout Then
				If $g_bRunState And Not $g_bSearchMode And Not $g_bBotPaused And ($g_hTimer_SetTime = 0 Or __TimerDiff($g_hTimer_SetTime) >= 750) Then
					SetTime()
					$g_hTimer_SetTime = __TimerInit()
				EndIf
				AndroidEmbedCheck()
				AndroidShieldCheck()
				CheckPostponedLog()
			EndIf
		EndIf
		$iRemaining = $iDelay - __TimerDiff($iBegin)
		If $iRemaining >= $DELAYSLEEP Then
			_SleepMilli($DELAYSLEEP)
		Else
			_SleepMilli($iRemaining)
		EndIf
		CheckBotRequests() ; check if bot window should be moved
	WEnd
	Return False
EndFunc   ;==>_Sleep

Func _SleepMicro($iMicroSec)
	DllStructSetData($g_hStruct_SleepMicro, "time", $iMicroSec * -10)
	DllCall($g_hLibNTDLL, "dword", "ZwDelayExecution", "int", 0, "ptr", $g_pStruct_SleepMicro)
EndFunc   ;==>_SleepMicro

Func _SleepMilli($iMilliSec)
	_SleepMicro(Int($iMilliSec * 1000))
EndFunc   ;==>_SleepMilli
