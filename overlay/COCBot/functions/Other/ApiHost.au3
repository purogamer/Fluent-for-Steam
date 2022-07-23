; #FUNCTION# ====================================================================================================================
; Name ..........: MyBot.run Bot API functions
; Description ...: Register Windows Message and provides functions to communicate between bots and manage bot application
; Author ........: cosote (12-2016)
; Modified ......: CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
;                  Read/write memory: https://www.autoitscript.com/forum/topic/104117-shared-memory-variables-demo/
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

#include-once
#include "_Memory.au3"

Global $g_ahManagedMyBotDetails[0] ; Contains array of MemoryHandleArray - frmBot - Timer Handle of last response - Command line of bot - Bot Window Title - RunState - TPaused - Verify count
GUIRegisterMsg($WM_MYBOTRUN_API, "WM_MYBOTRUN_API_HOST")
GUIRegisterMsg($WM_MYBOTRUN_STATE, "WM_MYBOTRUN_STATE")

Func WM_MYBOTRUN_API_HOST($hWind, $iMsg, $wParam, $lParam)

	If $g_iDebugWindowMessages Then SetDebugLog("API-HOST: $hWind=" & $hWind & ",$iMsg=" & $iMsg & ",$wParam=" & $wParam & ",$lParam=" & $lParam)

	$hWind = HWnd($lParam)
	Local $wParamHi = BitShift($wParam, 16)
	Local $wParamLo = BitAND($wParam, 0xFFFF)

	Switch $wParamLo

		; Post Message to Manage Farm App and consume message
		Case 0x00FF, 0x01FF
			; do not respond to any host query from other managers
			$hWind = 0

		Case 0x1040 + 2
			; unregister bot
			$hWind = 0
			UnregisterManagedMyBotClient($lParam)

		Case Else ;Case 0x0000 + 1
			Local $_RunState = BitAND($wParamHi, 1) > 0
			Local $_TPaused = BitAND($wParamHi, 2) > 0
			Local $_bLaunched = BitAND($wParamHi, 4) > 0
			GetManagedMyBotDetails($hWind, $g_WatchOnlyClientPID, $_RunState, $_TPaused, $_bLaunched)
			; respond to host message received, disabled for now
			$hWind = 0
			#cs
			$lParam = $g_hFrmBot
			$wParam = $wParamLo + 1
			$wParamHi = 0
			$wParam += BitShift($wParamHi, -16)
			#ce
	EndSwitch

	If $hWind <> 0 Then
		_WinAPI_PostMessage($hWind, $iMsg, $wParam, $lParam)
	EndIf

EndFunc   ;==>WM_MYBOTRUN_API_HOST

Func WM_MYBOTRUN_STATE($hWind, $iMsg, $wParam, $lParam)

	If $g_iDebugWindowMessages Then SetDebugLog("API-HOST-STATE: $hWind=" & $hWind & ",$iMsg=" & $iMsg & ",$wParam=" & $wParam & ",$lParam=" & $lParam)

	; Read state from process
	Local $_frmBot = HWnd($lParam)
	Local $pid = WinGetProcess($_frmBot)
	If $pid Then
		; Process exists
		Local $hMem = _MemoryOpen($pid)
		If _MemoryReadStruct($wParam, $hMem, $tBotState) = 1 Then
			; update state struct
			Local $_RunState = DllStructGetData($tBotState, "RunState")
			Local $_TPaused = DllStructGetData($tBotState, "Paused")
			Local $_bLaunched = DllStructGetData($tBotState, "Launched")
			GetManagedMyBotDetails($_frmBot, $g_WatchOnlyClientPID, $_RunState, $_TPaused, $_bLaunched, Default, $tBotState, $hMem)
		Else
			SetDebugLog("API-HOST-STATE: Cannot read memory from process: " & $pid)
		EndIf
		_MemoryClose($hMem)
	Else
		SetDebugLog("API-HOST-STATE: Cannot access PID for Window Handle: " & $lParam)
	EndIf

EndFunc   ;==>WM_MYBOTRUN_STATE

Func UpdateManagedMyBotArray(ByRef $a, ByRef $pid, ByRef $sTitle, ByRef $_RunState, ByRef $_TPaused, ByRef $_bLaunched, ByRef $iVerifyCount, ByRef $_tBotState, ByRef $hMem, $aLoaded = Default)
	; Global Enum $g_eBotDetailsBotForm = 0, $g_eBotDetailsTimer, $g_eBotDetailsProfile, $g_eBotDetailsCommandLine, $g_eBotDetailsTitle, $g_eBotDetailsRunState, $g_eBotDetailsPaused, $g_eBotDetailsLaunched, $g_eBotDetailsVerifyCount, $g_eBotDetailsBotStateStruct, $g_eBotDetailsOptionalStruct, $g_eBotDetailsArraySize
	$a[$g_eBotDetailsTimer] = __TimerInit()
	$a[$g_eBotDetailsTitle] = $sTitle
	If $_RunState <> Default Then $a[$g_eBotDetailsRunState] = $_RunState
	If $_TPaused <> Default Then $a[$g_eBotDetailsPaused] = $_TPaused
	If $_bLaunched <> Default Then $a[$g_eBotDetailsLaunched] = $_bLaunched
	$a[$g_eBotDetailsVerifyCount] = $iVerifyCount ; verify count bot is really crashed (used to compensate computer sleep etc.)
	Local $bRegisterInHost = True

	If $_tBotState <> Default Then
		$a[$g_eBotDetailsBotStateStruct] = $_tBotState
		Local $tStruct = 0
		If UBound($aLoaded) >= UBound($a) Then
			; load data from given array
			$tStruct = $aLoaded[$g_eBotDetailsOptionalStruct]
		Else
			$a[$g_eBotDetailsProfile] = DllStructGetData($tBotState, "Profile")
			$bRegisterInHost = DllStructGetData($tBotState, "RegisterInHost")
			If $hMem <> Default Then
				; check for additional struct
				Local $eStructType = DllStructGetData($tBotState, "StructType")
				Local $pStructPtr = DllStructGetData($tBotState, "StructPtr")
				Switch $eStructType
					Case $g_eSTRUCT_STATUS_BAR
						If $g_iDebugWindowMessages Then SetDebugLog("UpdateManagedMyBotArray: Reading StatusBar Text")
						If _MemoryReadStruct($pStructPtr, $hMem, $tStatusBar) = 1 Then
							$tStruct = $tStatusBar
							If $g_WatchDogLogStatusBar Then SetDebugLog("PID: " & $pid & ", StatusBar Text: " & DllStructGetData($tStatusBar, "Text"))
						EndIf
					Case $g_eSTRUCT_UPDATE_STATS
						If $g_iDebugWindowMessages Then SetDebugLog("UpdateManagedMyBotArray: Reading Update Stats")
						If _MemoryReadStruct($pStructPtr, $hMem, $tUpdateStats) = 1 Then
							$tStruct = $tUpdateStats
							If $g_iDebugWindowMessages Then SetDebugLog("UpdateManagedMyBotArray: Update Stats read")
						EndIf
				EndSwitch
			EndIf
		EndIf
		$a[$g_eBotDetailsOptionalStruct] = $tStruct
	EndIf

	Return $bRegisterInHost
EndFunc   ;==>UpdateManagedMyBotArray

Func GetManagedMyBotDetails($hFrmBot = Default, $iFilterPID = Default, $_RunState = Default, $_TPaused = Default, $_bLaunched = Default, $iVerifyCount = Default, $_tBotState = Default, $hMem = Default)

	If $hFrmBot = Default Then Return $g_ahManagedMyBotDetails
	If $iVerifyCount = Default Then $iVerifyCount = 2

	If IsHWnd($hFrmBot) = 0 Then Return -1
	If $iFilterPID <> Default And WinGetProcess($hFrmBot) <> $iFilterPID Then Return -2 ; not expected bot process
	Local $pid = WinGetProcess($hFrmBot)
	Local $sTitle = WinGetTitle($hFrmBot)
	If $pid = -1 Then SetLog("Process not found for Window Handle: " & $hFrmBot)

	Local $aNew[$g_eBotDetailsArraySize]
	Local $bRegisterInHost = UpdateManagedMyBotArray($aNew, $pid, $sTitle, $_RunState, $_TPaused, $_bLaunched, $iVerifyCount, $_tBotState, $hMem)
	Local $sProfile = $aNew[$g_eBotDetailsProfile]
	For $i = 0 To UBound($g_ahManagedMyBotDetails) - 1
		If $i > UBound($g_ahManagedMyBotDetails) - 1 Then ExitLoop ; array could have been reduced in size
		Local $a = $g_ahManagedMyBotDetails[$i]
		If $a[$g_eBotDetailsBotForm] = $hFrmBot Then
			UpdateManagedMyBotArray($a, $pid, $sTitle, $_RunState, $_TPaused, $_bLaunched, $iVerifyCount, $_tBotState, $hMem, $aNew)
			$g_ahManagedMyBotDetails[$i] = $a
			If $g_iDebugWindowMessages Then SetDebugLog("Bot Window state received: " & GetManagedMyBotInfoString($a))
			Execute("UpdateManagedMyBot($a)")
			Return $a
		EndIf

		If ($sProfile And $a[$g_eBotDetailsProfile] = $sProfile) Or (Not $sProfile And $a[$g_eBotDetailsTitle] = $sTitle) Then
			SetDebugLog("Remove registered Bot Window Handle " & $a[$g_eBotDetailsBotForm] & ", as new instance detected")
			_ArrayDelete($g_ahManagedMyBotDetails, $i)
			$i -= 1
		EndIf
	Next

	$aNew[$g_eBotDetailsBotForm] = $hFrmBot

	If Execute("UpdateManagedMyBot($aNew)") Then
		; Register new bot
		$aNew[$g_eBotDetailsCommandLine] = ProcessGetCommandLine($pid)
		Local $i = UBound($g_ahManagedMyBotDetails)
		ReDim $g_ahManagedMyBotDetails[$i + 1]
		If $aNew[$g_eBotDetailsCommandLine] = -1 Then SetLog("Command line not found for Window Handle/PID: " & $hFrmBot & "/" & $pid)
		$g_ahManagedMyBotDetails[$i] = $aNew
		SetDebugLog("New Bot Window Handle registered: " & GetManagedMyBotInfoString($aNew))
	EndIf
	Return $aNew
EndFunc   ;==>GetManagedMyBotDetails

Func GetManagedMyBotInfoString(ByRef $a)
	; Global Enum $g_eBotDetailsBotForm = 0, $g_eBotDetailsTimer, $g_eBotDetailsProfile, $g_eBotDetailsCommandLine, $g_eBotDetailsTitle, $g_eBotDetailsRunState, $g_eBotDetailsPaused, $g_eBotDetailsLaunched, $g_eBotDetailsVerifyCount, $g_eBotDetailsBotStateStruct, $g_eBotDetailsOptionalStruct, $g_eBotDetailsArraySize

	If UBound($a) < $g_eBotDetailsArraySize Then Return "unknown"
	Return "HWnd=" & $a[$g_eBotDetailsBotForm] & ", PID=" & WinGetProcess($a[$g_eBotDetailsBotForm]) & ", " & $a[$g_eBotDetailsProfile] & ", " & $a[$g_eBotDetailsTitle] & ", " & ($a[$g_eBotDetailsRunState] ? "running" : "not running") & ", " & ($a[$g_eBotDetailsPaused] ? "paused" : "not paused") & ", " & ($a[$g_eBotDetailsLaunched] ? "launched" : "launching") & ", " & $a[$g_eBotDetailsCommandLine]

EndFunc   ;==>GetManagedMyBotInfoString

Func ClearManagedMyBotDetails()
	ReDim $g_ahManagedMyBotDetails[0]
EndFunc   ;==>ClearManagedMyBotDetails

Func UnregisterManagedMyBotClient($hFrmBot)

	SetDebugLog("Try to un-register Bot Window Handle: " & $hFrmBot)

	For $i = 0 To UBound($g_ahManagedMyBotDetails) - 1
		Local $a = $g_ahManagedMyBotDetails[$i]
		If $a[$g_eBotDetailsBotForm] = $hFrmBot Then
			_ArrayDelete($g_ahManagedMyBotDetails, $i)
			Local $Result = 1
			If IsHWnd($hFrmBot) Then
				SetDebugLog("Bot Window Handle un-registered: " & $hFrmBot)
			Else
				SetDebugLog("Inaccessible Bot Window Handle un-registered: " & $hFrmBot)
				$Result = -1
			EndIf
			If $bCloseWhenAllBotsUnregistered = True And UBound($g_ahManagedMyBotDetails) = 0 Then
				SetLog("Closing " & $g_sBotTitle & " as all bots closed")
				Exit (1)
			EndIf
			Return $Result
		EndIf
	Next

	SetDebugLog("Bot Window Handle not un-registered: " & $hFrmBot, $COLOR_RED)

	Return 0

EndFunc   ;==>UnregisterManagedMyBotClient

Func CheckManagedMyBot($iTimeout)

	; Launch crashed bot again
	For $i = 0 To UBound($g_ahManagedMyBotDetails) - 1
		Local $a = $g_ahManagedMyBotDetails[$i]
		If __TimerDiff($a[$g_eBotDetailsTimer]) > $iTimeout Then
			If $a[$g_eBotDetailsVerifyCount] > 0 Then
				; not verified inresponsive, decrease counter
				$a[$g_eBotDetailsVerifyCount] -= 1
				; update array
				$g_ahManagedMyBotDetails[$i] = $a
				ContinueLoop
			EndIf
			_ArrayDelete($g_ahManagedMyBotDetails, $i)
			; check if bot has been already restarted manually
			Local $cmd = $a[$g_eBotDetailsCommandLine]
			Local $g_sBotTitle = $a[$g_eBotDetailsTitle]
			For $j = 0 To UBound($g_ahManagedMyBotDetails) - 1
				$a = $g_ahManagedMyBotDetails[$j]
				If $a[$g_eBotDetailsTitle] = $g_sBotTitle Then
					SetDebugLog("Bot already restarted, window title: " & $g_sBotTitle)
					Return WinGetProcess($a[$g_eBotDetailsBotForm])
				EndIf
			Next
			If StringInStr($cmd, " /restart") = 0 Then $cmd &= " /restart"
			If $a[$g_eBotDetailsRunState] Then
				; bot was started, autostart again
				If StringInStr($cmd, " /autostart") = 0 Then $cmd &= " /autostart"
			EndIf
			SetDebugLog("Restarting bot: " & $cmd)
			Return Run($cmd)
		EndIf
	Next

	Return 0
EndFunc   ;==>CheckManagedMyBot

Func GetActiveMyBotCount($iTimeout)

	Local $iCount = 0
	For $i = 0 To UBound($g_ahManagedMyBotDetails) - 1
		Local $a = $g_ahManagedMyBotDetails[$i]
		If __TimerDiff($a[$g_eBotDetailsTimer]) <= $iTimeout Then
			$iCount += 1
		Else
			SetDebugLog("Bot not responding with Window Handle: " & $a[$g_eBotDetailsBotForm])
		EndIf
	Next

	Return $iCount
EndFunc   ;==>GetActiveMyBotCount
