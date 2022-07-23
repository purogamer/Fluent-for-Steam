; #FUNCTION# ====================================================================================================================
; Name ..........: UniversalCloseWaitOpenCoC
; Description ...: Closes game app with back button to notify servers of exit, waits to reopen game
;					  :
; Syntax ........: PoliteCloseOpenCoc($iWaitTime, $sSource, $StopEmulator)
; Parameters ....: $iWaitTime           - an integer value of milliseconds wait time betwen close and open game
; 					  : $sSource             - Not optional string value with name of calling function to display for error logs
; 					  : $StopEmulator		 - Boolean flag or string "random", true will stop/close emulator after closing CoC app, "random" will let code pick close status, "idle" will let app time out
; 					  : $bFullRestart		 - Optional boolean flag when not closing emulator to force full restart in WaitnOpenCoc
;                     : $bSuspendComputer    - Optional boolean to put computer into sleep and resume again
; Return values .: None
; Author ........: MonkeyHunter (04-2016)
; Modified ......: Cosote (06-2016), MonkeyHunter (07-2016)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func UniversalCloseWaitOpenCoC($iWaitTime = 0, $sSource = "Unknown", $StopEmulator = False, $bFullRestart = False, $bSuspendComputer = False)

	SetDebugLog("Begin UniversalCloseWaitOpenCoC:", $COLOR_DEBUG1)

	Local $sWaitTime = ""
	Local $iMin, $iSec, $iHour, $iWaitSec, $StopAndroidFlag

	If $iWaitTime > 0 Then
		; create readable wait time message for user/log
		$iWaitSec = Round($iWaitTime / 1000)
		$iHour = Floor(Floor($iWaitSec / 60) / 60)
		$iMin = Floor(Mod(Floor($iWaitSec / 60), 60))
		$iSec = Floor(Mod($iWaitSec, 60))
		If $iHour > 0 Then $sWaitTime &= $iHour & " hours "
		If $iMin > 0 Then $sWaitTime &= $iMin & " minutes "
		If $iSec > 0 Then $sWaitTime &= $iSec & " seconds "
	EndIf
	Local $msg = ""
	Select ; error check input parameter and set $StopAndroidFlag
		Case StringInStr($StopEmulator, "rand", $STR_NOCASESENSEBASIC)
			$StopAndroidFlag = Random(0, 2, 1) ; Determine random close emulator flag value
			Switch $StopAndroidFlag
				Case 0
					$msg = " =Time out"
				Case 1
					$msg = " =Close CoC"
				Case 2
					$msg = " =Close Android"
				Case Else
					$msg = "One Bad Monkey Error!"
			EndSwitch
			SetLog("Random close option= " & $StopAndroidFlag & $msg, $COLOR_SUCCESS)
		Case StringInStr($StopEmulator, "idle", $STR_NOCASESENSEBASIC)
			$StopAndroidFlag = 0
		Case $StopEmulator = False
			$StopAndroidFlag = 1
		Case $StopEmulator = True
			$StopAndroidFlag = 2
		Case Else
			$StopAndroidFlag = 1
			SetLog("Code Monkey provided bad stop emulator flag value", $COLOR_ERROR)
	EndSelect
	SetDebugLog("Stop Android flag : Input flag " & $StopAndroidFlag & " : " & $StopEmulator, $COLOR_DEBUG)
	If _Sleep($DELAYRESPOND) Then Return False

	If $g_bUpdateSharedPrefs Then PullSharedPrefs()

	Switch $StopAndroidFlag
		Case 0 ; Do nothing while waiting, Let app time out
			If $iWaitTime > 0 Then
				SetLog("Going idle for " & $sWaitTime & "before starting CoC", $COLOR_SUCCESS)
				Local $hTimer = __TimerInit()
				LockBotSlot(False)
				If $bSuspendComputer Then SuspendComputer($iWaitTime)
				If _SleepStatus($iWaitTime, True, True, True, $hTimer) Then Return False ; Wait for set requested
				LockBotSlot(True)
			Else
				If _SleepStatus($DELAYWAITNOPENCOC10000) Then Return False ; if waittime = 0 then only wait 10 seconds before restart
			EndIf
			If _Sleep($DELAYRESPOND) Then Return False
			OpenCoC()
		Case 1 ; close CoC app only (after 2017/Dec. only jump to home-screen to avoid CoC launch delay)
			; Local $bSendHome = ($g_sAndroidEmulator <> "MEmu")
			Local $bSendHome = False ; MEmu and BlueStacks 4 have issues with CoC running in background: it crashes... to avoid that use polite close
			If $bSendHome Then
				AndroidHomeButton()
			Else
				PoliteCloseCoC($sSource)
			EndIf
			If _Sleep(3000) Then Return False ; Wait 3 sec.
			If $iWaitTime > 0 Then
				If $iWaitTime > 30000 Then
					AndroidShieldForceDown(True)
					EnableGuiControls() ; enable bot controls is more than 30 seconds wait time
					SetLog("Enabled bot controls due to long wait time", $COLOR_SUCCESS)
				EndIf
				LockBotSlot(False)
				WaitnOpenCoC($iWaitTime, $bFullRestart, $bSuspendComputer, True)
				AndroidShieldForceDown(False)
				If $g_bRunState = False Then Return False
			Else
				WaitnOpenCoC($DELAYWAITNOPENCOC10000, $bFullRestart) ; if waittime = 0 then only wait 10 seconds before restart
			EndIf
			If _Sleep($DELAYRESPOND) Then Return False
			If $iWaitTime > 30000 Then
				; ensure possible changes are populated
				SaveConfig()
				readConfig()
				applyConfig()
				DisableGuiControls()
			EndIf
		Case 2 ; Close emulator
			PoliteCloseCoC($sSource)
			If _Sleep(3000) Then Return False ; Wait 3 sec.
			CloseAndroid("UniversalCloseWaitOpenCoC")
			ReduceBotMemory()
			If $iWaitTime > 0 Then
				SetLog("Waiting " & $sWaitTime & "before starting CoC", $COLOR_SUCCESS)
				If $iWaitTime > 30000 Then
					EnableGuiControls() ; enable bot controls is more than 30 seconds wait time
					SetLog("Enabled bot controls due to long wait time", $COLOR_SUCCESS)
				EndIf
				Local $hTimer = __TimerInit()
				LockBotSlot(False)
				If $bSuspendComputer Then SuspendComputer($iWaitTime)
				If _SleepStatus($iWaitTime, True, True, True, $hTimer) Then Return False ; Wait for set requested
				LockBotSlot(True)
				If $iWaitTime > 30000 Then
					; ensure possible changes are populated
					SaveConfig()
					readConfig()
					applyConfig()
					DisableGuiControls()
				EndIf
			Else
				If _SleepStatus($DELAYWAITNOPENCOC10000) Then Return False
			EndIf
			StartAndroidCoC()
		Case Else
			SetLog("Code Monkey is drinking banana liqueur again!", $COLOR_ERROR)
	EndSwitch

EndFunc   ;==>UniversalCloseWaitOpenCoC

Func SuspendComputer($iMilliseconds)

	SetDebugLog("Trying to suspend computer")
	If $g_BotInstanceCount > 1 Then
		SetLog($g_BotInstanceCount & " bot instances detected, will not suspend computer", $COLOR_ERROR)
		Return False
	EndIf

	; wake up here
	If SetWakeUpSeconds(Round($iMilliseconds / 1000, 0)) Then
		; close ADB session
		AndroidAdbTerminateShellInstance()
		; close ADB daemon as it will loose connection to Android anyway
		KillAdbDaemon()
		; reset time lag
		InitAndroidTimeLag()
		; put computer now to sleep
		SetLog("Suspend computer now", $COLOR_INFO)
		CheckPostponedLog(True)
		If SetSuspend() Then
			Return True
		EndIf
		SetLog("Cannot suspend computer, error: " & @error & ", extended: " & @extended, $COLOR_ERROR)
		Return False
	EndIf

	SetLog("Cannot set computer wakeup time, error: " & @error & ", extended: " & @extended, $COLOR_ERROR)
	Return False

EndFunc