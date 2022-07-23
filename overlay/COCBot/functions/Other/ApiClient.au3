; #FUNCTION# ====================================================================================================================
; Name ..........: MyBot.run Bot API functions
; Description ...: Register Windows Message and provides functions to communicate between bots and manage bot application
; Author ........: cosote (12-2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
;                  Read/write memory: https://www.autoitscript.com/forum/topic/104117-shared-memory-variables-demo/
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Global $g_ahManagedMyBotHosts[0] ; Contains array of registered MyBot.run host Window Handle and TimerHandle of last communication
GUIRegisterMsg($WM_MYBOTRUN_API, "WM_MYBOTRUN_API_CLIENT")

Func WM_MYBOTRUN_API_CLIENT($hWind, $iMsg, $wParam, $lParam)

	If $hWind <> $g_hFrmBot Then Return 0

	If $g_iDebugWindowMessages Then SetDebugLog("API-CLIENT: $hWind=" & $hWind & ",$iMsg=" & $iMsg & ",$wParam=" & $wParam & ",$lParam=" & $lParam)

	$hWind = HWnd($lParam) ; this is the managed bot handle
	Local $wParamHi = 0
	If $g_bRunState = True Then $wParamHi += 1
	If $g_bBotPaused = True Then $wParamHi += 2
	If IsBotLaunched() Then $wParamHi += 4 ; bot launched

	Local $wParamLo = BitAND($wParam, 0xFFFF)
	Local $bRegisterHost = True

	; Handle incoming message and post Message back to Manage Farm App
	Switch $wParamLo

		Case 0x0000 To 0x00FF ; query bot run and pause state (usually received from broadcast)
			$lParam = $g_hFrmBot
			Local $iActiveBots = BitAND($wParam, 0xFF)
			If $iActiveBots < 255 Then
				If $g_BotInstanceCount <> $iActiveBots Then SetDebugLog($iActiveBots & " running bot instances detected")
				$g_BotInstanceCount = $iActiveBots
			Else
				$bRegisterHost = False
			EndIf
			$wParam = 1
			$wParamHi = 0
			If $g_bRunState = True Then $wParamHi += 1
			If $g_bBotPaused = True Then $wParamHi += 2
			If IsBotLaunched() Then $wParamHi += 4 ; bot launched
			$wParam += BitShift($wParamHi, -16)

		Case 0x0100 To 0x01FF ; query bot detailed state
			Local $iActiveBots = BitAND($wParam, 0xFF)
			If $iActiveBots < 255 Then
				If $g_BotInstanceCount <> $iActiveBots Then SetDebugLog($iActiveBots & " running bot instances detected")
				$g_BotInstanceCount = $iActiveBots
			EndIf
			$iMsg = $WM_MYBOTRUN_STATE
			$lParam = $g_hFrmBot
			$wParam = DllStructGetPtr($tBotState)
			$bRegisterHost = $wParamLo < 0x01FF
			PrepareStructBotState($tBotState, Default, Default, $bRegisterHost)

		Case 0x0200 ; query bot detailed state with extended stats
			If $g_iFirstRun = 0 Then
				PrepareUpdateStatsManagedMyBotHost($hWind, $iMsg, $wParam, $lParam)
			Else
				; same as 0x0100 To 0x01FE (query bot detailed state)
				$iMsg = $WM_MYBOTRUN_STATE
				$lParam = $g_hFrmBot
				$wParam = DllStructGetPtr($tBotState)
				PrepareStructBotState($tBotState)
			EndIf

		Case 0x1000 ; start bot
			$lParam = $g_hFrmBot
			$wParam = $wParamLo + 1
			If $g_bRunState = False Then
				$wParamHi = 1
				;If $g_bBotPaused = True Then $wParamHi += 2
				If IsBotLaunched() Then $wParamHi += 4 ; bot launched
				btnStart()
			EndIf
			$wParam += BitShift($wParamHi, -16)

		Case 0x1010 ; stop bot
			$lParam = $g_hFrmBot
			$wParam = $wParamLo + 1
			If $g_bRunState = True Then
				$wParamHi = 0
				;If $g_bBotPaused = True Then $wParamHi += 2
				If IsBotLaunched() Then $wParamHi += 4 ; bot launched
				btnStop()
			EndIf
			$wParam += BitShift($wParamHi, -16)

		Case 0x1020 ; resume bot
			$lParam = $g_hFrmBot
			$wParam = $wParamLo + 1
			If $g_bBotPaused = True And $g_bRunState = True Then
				$wParamHi = 0
				If $g_bRunState = True Then $wParamHi += 1
				;If $g_bBotPaused = True Then $wParamHi += 2
				If IsBotLaunched() Then $wParamHi += 4 ; bot launched
				TogglePauseImpl("ManageFarm")
			EndIf
			$wParam += BitShift($wParamHi, -16)

		Case 0x1030 ; pause bot
			$lParam = $g_hFrmBot
			$wParam = $wParamLo + 1
			If $g_bBotPaused = False And $g_bRunState = True Then
				$wParamHi = 2
				If $g_bRunState = True Then $wParamHi += 1
				;If $g_bBotPaused = True Then $wParamHi += 2
				If IsBotLaunched() Then $wParamHi += 4 ; bot launched
				TogglePauseImpl("ManageFarm", True)
				#cs
					$wParam += BitShift($wParamHi, -16)
					_WinAPI_PostMessage($hWind, $iMsg, $wParam, $lParam)
					TogglePauseImpl("ManageFarm", True)
					;_Timer_SetTimer($g_hFrmBot, 25, "WM_MYBOTRUN_API_CLIENT_TogglePause")
					Return
				#ce
			EndIf
			$wParam += BitShift($wParamHi, -16)

		Case 0x1040 ; close bot
			$lParam = $g_hFrmBot
			$wParam = $wParamLo + 1
			$wParamHi = 0
			BotCloseRequest()
			$wParam += BitShift($wParamHi, -16)

		Case 0x1050 ; take photo
			$lParam = $g_hFrmBot
			$wParam = $wParamLo + 1
			$wParamHi = 0
			If $g_bRunState = True Then $wParamHi += 1
			If $g_bBotPaused = True Then $wParamHi += 2
			If IsBotLaunched() Then $wParamHi += 4 ; bot launched
			btnMakeScreenshot()
			$wParam += BitShift($wParamHi, -16)

		Case 0x1060 ; update GUI PID
			$lParam = $g_hFrmBot
			$wParam = $wParamLo + 1
			$wParamHi = 0
			If $g_bRunState = True Then $wParamHi += 1
			If $g_bBotPaused = True Then $wParamHi += 2
			If IsBotLaunched() Then $wParamHi += 4 ; bot launched
			Local $pid = WinGetProcess($hWind)
			If $pid <> 0 And $pid <> -1 Then
				$g_iGuiPID = $pid
				SetBotGuiPID($pid)
			EndIf
			$wParam += BitShift($wParamHi, -16)
		
		; Custom Mini-GUI - Team AIO Mod++
        Case 0x1070 ; Hide Android
            $lParam = $g_hFrmBot
            $wParam = $wParamLo + 1        
            $wParamHi = 0
            If $g_bRunState = True Then $wParamHi += 1
            If IsBotLaunched() Then $wParamHi += 4 ; bot launched
            HideAndroidWindow(True, Default, Default, "btnHide")
            $wParam += BitShift($wParamHi, -16)
        
		; Custom Mini-GUI - Team AIO Mod++
		Case 0x1080 ; Show Android
            $lParam = $g_hFrmBot
            $wParam = $wParamLo + 1        
            $wParamHi = 0
            If $g_bRunState = True Then $wParamHi += 1
            If IsBotLaunched() Then $wParamHi += 4 ; bot launched
            HideAndroidWindow(False, Default, Default, "btnShow")
            $wParam += BitShift($wParamHi, -16)
            
		Case Else ; do nothing
			$hWind = 0
	EndSwitch

	If Not IsBotLaunched() Then
		; bot is still launching, so don't report anything
		$hWind = 0
	EndIf

	If $hWind <> 0 Then
		Local $a = GetManagedMyBotHost($hWind, True, $bRegisterHost)
		_WinAPI_PostMessage($hWind, $iMsg, $wParam, $lParam)
	EndIf

	Return 1

EndFunc   ;==>WM_MYBOTRUN_API_CLIENT

Func WM_MYBOTRUN_API_CLIENT_TogglePause($hWnd, $iMsg, $iIDTimer, $iTime)
	#forceref $hWnd, $iMsg, $iIDTimer, $iTime
	_Timer_KillTimer($hWnd, $iIDTimer)
	TogglePauseImpl("ManageFarm")
EndFunc   ;==>WM_MYBOTRUN_API_CLIENT_TogglePause

Func GetManagedMyBotHost($hFrmHost = Default, $bUpdateTime = False, $bRegisterHost = True)

	If $hFrmHost = Default Then
		Return $g_ahManagedMyBotHosts
	EndIf

	If IsHWnd($hFrmHost) = 0 Then Return -1

	For $i = 0 To UBound($g_ahManagedMyBotHosts) - 1
		Local $a = $g_ahManagedMyBotHosts[$i]
		If $a[0] = $hFrmHost Then
			If $bUpdateTime Then
				$a[1] = __TimerInit()
				$g_ahManagedMyBotHosts[$i] = $a
			EndIf
			Return $a
		EndIf
	Next

	Local $a[2]
	$a[0] = $hFrmHost
	If $bUpdateTime Then $a[1] = __TimerInit()
	If $bRegisterHost Then
		Local $i = UBound($g_ahManagedMyBotHosts)
		ReDim $g_ahManagedMyBotHosts[$i + 1]
		$g_ahManagedMyBotHosts[$i] = $a
		SetDebugLog("New Bot Host Window Handle registered: " & $hFrmHost)
	EndIf
	Return $a
EndFunc   ;==>GetManagedMyBotHost

Func LaunchWatchdog()
	Local $hMutex = CreateMutex($sWatchdogMutex)
	If $hMutex = 0 Then
		; already running
		SetDebugLog("Watchdog already running")
		Return 0
	EndIf
	ReleaseMutex($hMutex)
	Local $cmd = """" & @ScriptDir & "\MyBot.run.Watchdog.exe"""
	If @Compiled = 0 Then $cmd = """" & @AutoItExe & """ /AutoIt3ExecuteScript """ & @ScriptDir & "\MyBot.run.Watchdog.au3" & """"
	If $g_iBotLaunchOption_Console Then $cmd &= " /console"
	Local $pid = Run($cmd, @ScriptDir)
	If $pid = 0 Then
		SetLog("Cannot launch watchdog", $COLOR_RED)
		Return 0
	EndIf
	If $g_bDebugSetlog Then
		SetDebugLog("Watchdog launched, PID = " & $pid)
	Else
		SetLog("Watchdog launched")
	EndIf
	Return $pid
EndFunc   ;==>LaunchWatchdog

Func PrepareStructBotState(ByRef $tBotState, $eStructType = Default, $pStructPtr = Default, $bRegisterInHost = True)
	If $eStructType = Default Then $eStructType = $g_eSTRUCT_NONE
	If $pStructPtr = Default Then $pStructPtr = 0
	DllStructSetData($tBotState, "BotHWnd", $g_hFrmBot) ; Bot Main Window Handle
	DllStructSetData($tBotState, "AndroidHWnd", $g_hAndroidWindow) ; Android Window Handle
	DllStructSetData($tBotState, "RunState", $g_bRunState) ; Boolean
	DllStructSetData($tBotState, "Paused", $g_bBotPaused) ; Boolean
	DllStructSetData($tBotState, "Launched", IsBotLaunched()) ; Boolean
	DllStructSetData($tBotState, "g_hTimerSinceStarted", $g_hTimerSinceStarted) ; uint64
	DllStructSetData($tBotState, "g_iTimePassed", $g_iTimePassed) ;uint
	DllStructSetData($tBotState, "Profile", $g_sProfileCurrentName) ; String
	DllStructSetData($tBotState, "AndroidEmulator", $g_sAndroidEmulator) ; String
	DllStructSetData($tBotState, "AndroidInstance", $g_sAndroidInstance) ; String
	DllStructSetData($tBotState, "StructType", $eStructType)
	DllStructSetData($tBotState, "StructPtr", $pStructPtr)
	DllStructSetData($tBotState, "RegisterInHost", $bRegisterInHost) ; Boolean
EndFunc   ;==>PrepareStructBotState

Func PrepareStatusBarManagedMyBotHost($hFrmHost, ByRef $iMsg, ByRef $wParam, ByRef $lParam, $sStatusBar)
	$iMsg = $WM_MYBOTRUN_STATE
	$lParam = $g_hFrmBot
	$wParam = DllStructGetPtr($tBotState)
	DllStructSetData($tStatusBar, "Text", $sStatusBar)
	PrepareStructBotState($tBotState, $g_eSTRUCT_STATUS_BAR, DllStructGetPtr($tStatusBar))
	If $g_iDebugWindowMessages Then SetDebugLog("PrepareStatusBarManagedMyBotHost: $hFrmHost=" & $hFrmHost & ",$iMsg=" & $iMsg & ",$wParam=" & $wParam & ",$lParam=" & $lParam & ",$sStatusBar=" & $sStatusBar)
	Return True
EndFunc   ;==>PrepareStatusBarManagedMyBotHost

Func StatusBarManagedMyBotHost($sStatusBar)
	Return ManagedMyBotHostsPostMessage("PrepareStatusBarManagedMyBotHost", $sStatusBar)
EndFunc   ;==>StatusBarManagedMyBotHost

Func PrepareUpdateStatsManagedMyBotHost($hFrmHost, ByRef $iMsg, ByRef $wParam, ByRef $lParam)
	$iMsg = $WM_MYBOTRUN_STATE
	$lParam = $g_hFrmBot
	$wParam = DllStructGetPtr($tBotState)
	_DllStructSetData($tUpdateStats, "g_aiCurrentLoot", $g_aiCurrentLoot)
	_DllStructSetData($tUpdateStats, "g_iFreeBuilderCount", $g_iFreeBuilderCount)
	_DllStructSetData($tUpdateStats, "g_iTotalBuilderCount", $g_iTotalBuilderCount)
	_DllStructSetData($tUpdateStats, "g_iGemAmount", $g_iGemAmount)
	_DllStructSetData($tUpdateStats, "g_iStatsTotalGain", $g_iStatsTotalGain)
	_DllStructSetData($tUpdateStats, "g_iStatsLastAttack", $g_iStatsLastAttack)
	_DllStructSetData($tUpdateStats, "g_iStatsBonusLast", $g_iStatsBonusLast)
	_DllStructSetData($tUpdateStats, "g_iFirstAttack", $g_iFirstAttack)
	_DllStructSetData($tUpdateStats, "g_aiAttackedCount", $g_aiAttackedCount)
	_DllStructSetData($tUpdateStats, "g_iSkippedVillageCount", $g_iSkippedVillageCount)
	; Custom BB - Team AIO Mod++
	_dllstructsetdata($tupdatestats, "g_aiCurrentLootBB", $g_aicurrentlootbb)
	_dllstructsetdata($tupdatestats, "g_iFreeBuilderCountBB", $g_ifreebuildercountbb)
	_dllstructsetdata($tupdatestats, "g_iTotalBuilderCountBB", $g_itotalbuildercountbb)
	PrepareStructBotState($tBotState, $g_eSTRUCT_UPDATE_STATS, DllStructGetPtr($tUpdateStats))
	If $g_iDebugWindowMessages Then SetDebugLog("PrepareUpdateStatsManagedMyBotHost: $hFrmHost=" & $hFrmHost & ",$iMsg=" & $iMsg & ",$wParam=" & $wParam & ",$lParam=" & $lParam)
	Return True
EndFunc   ;==>PrepareUpdateStatsManagedMyBotHost

Func UpdateStatsManagedMyBotHost()
	Return ManagedMyBotHostsPostMessage("PrepareUpdateStatsManagedMyBotHost")
EndFunc   ;==>UpdateStatsManagedMyBotHost

Func PrepareUnregisterManagedMyBotHost($hFrmHost, ByRef $iMsg, ByRef $wParam, ByRef $lParam)
	$wParam = 0x1040 + 2
	SetDebugLog("Bot Host Window Handle un-registered: " & $hFrmHost)
	Return True
EndFunc   ;==>PrepareUnregisterManagedMyBotHost

Func UnregisterManagedMyBotHost()
	Local $Result = ManagedMyBotHostsPostMessage("PrepareUnregisterManagedMyBotHost")
	ReDim $g_ahManagedMyBotHosts[0]
	Return $Result
EndFunc   ;==>UnregisterManagedMyBotHost

Func ManagedMyBotHostsPostMessage($sExecutePrepare, $Value1 = Default, $Value2 = Default, $Value3 = Default)
	Local $sAdditional = ""
	If $Value1 <> Default Or $Value2 <> Default Or $Value3 <> Default Then
		If $Value3 <> Default Then
			$sAdditional = ", $Value3"
		EndIf
		If $Value2 <> Default Then
			$sAdditional = ", $Value2" & $sAdditional
		ElseIf $sAdditional <> "" Then
			$sAdditional = ", Default" & $sAdditional
		EndIf
		If $Value1 <> Default Then
			$sAdditional = ", $Value1" & $sAdditional
		ElseIf $sAdditional <> "" Then
			$sAdditional = ", Default" & $sAdditional
		EndIf
	EndIf
	For $i = 0 To UBound($g_ahManagedMyBotHosts) - 1
		Local $a = $g_ahManagedMyBotHosts[$i]
		Local $hFrmHost = $a[0]
		$g_ahManagedMyBotHosts[$i] = $a
		If IsHWnd($hFrmHost) Then
			Local $iMsg = $WM_MYBOTRUN_API
			Local $wParam = 0x0000
			Local $lParam = $g_hFrmBot
			Local $sExecute = $sExecutePrepare & "($hFrmHost, $iMsg, $wParam, $lParam" & $sAdditional & ")"
			Local $bPostMessage
			Switch $sExecutePrepare
				Case "PrepareStatusBarManagedMyBotHost"
					$bPostMessage = PrepareStatusBarManagedMyBotHost($hFrmHost, $iMsg, $wParam, $lParam, $Value1)
				Case "PrepareUpdateStatsManagedMyBotHost"
					$bPostMessage = PrepareUpdateStatsManagedMyBotHost($hFrmHost, $iMsg, $wParam, $lParam)
				Case "PrepareUnregisterManagedMyBotHost"
					$bPostMessage = PrepareUnregisterManagedMyBotHost($hFrmHost, $iMsg, $wParam, $lParam)
				Case Else
					$bPostMessage = Execute($sExecute)
			EndSwitch
			If @error <> 0 And $bPostMessage = "" Then
				SetDebugLog("ManagedMyBotHostsPostMessage: Error executing " & $sExecute)
			ElseIf $bPostMessage = False Then
				If $g_iDebugWindowMessages Then SetDebugLog("ManagedMyBotHostsPostMessage: Not posting message to " & $hFrmHost)
			Else
				If $g_iDebugWindowMessages Then SetDebugLog("ManagedMyBotHostsPostMessage: Posting message to " & $hFrmHost)
				_WinAPI_PostMessage($hFrmHost, $iMsg, $wParam, $lParam)
			EndIf
		EndIf
	Next
EndFunc   ;==>ManagedMyBotHostsPostMessage

Func _GUICtrlStatusBar_SetTextEx($hWnd, $sText = "", $iPart = 0, $iUFlag = 0)
	If $hWnd Then _GUICtrlStatusBar_SetText($hWnd, $sText, $iPart, $iUFlag)
	StatusBarManagedMyBotHost($sText)
EndFunc   ;==>_GUICtrlStatusBar_SetTextEx
