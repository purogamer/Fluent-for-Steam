; #FUNCTION# ====================================================================================================================
; Name ..........: CloseRunningBot
; Description ...: Code to close existing My Bot instance by Window Title
; Syntax ........:
; Parameters ....: $sBotWindowTitle
; Return values .: True if window found and closed
; Author ........: Cosote (2016-01)
; Modified ......: CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func CloseRunningBot($sBotWindowTitle = $g_sBotTitle, $bCheckOnly = False, $bGuiInitialized = IsHWnd($g_hFrmBot))
	; terminate same bot instance, this current instance doesn't have main window yet, so no need to exclude this PID
	Local $param = ""
	For $i = 1 To $g_asCmdLine[0]
		If $param <> "" Then $param &= " "
		$param &= $g_asCmdLine[$i]
	Next
	Local $pid = 0
	Local $otherPID = 0
	Local $otherHWnD = 0
	Local $otherPIDs = 0
	If $param <> "" Then
		$otherPIDs = ProcessesExist(@AutoItExe, $param, 1, 1, Default, True)
	EndIf
	;Local $otherHWnD = WinGetHandle($sBotWindowTitle)
	Local $otherHWnDs = WinList($sBotWindowTitle)
	Local $iExpectedWindows = (($bGuiInitialized) ? (1) : (0))
	If $otherHWnDs[0][0] > $iExpectedWindows Or UBound($otherPIDs) > $iExpectedWindows Then
		For $i = 1 To $otherHWnDs[0][0]
			$pid = WinGetProcess($otherHWnDs[$i][1])
			If $pid <> @AutoItPID Then
				; other bot window found
				$otherPID = $pid
				$otherHWnD = $otherHWnDs[$i][1]
				ExitLoop
			EndIf
		Next
		If $otherPID = 0 And UBound($otherPIDs) > $iExpectedWindows Then
			; find PID in array
			For $aProcess In $otherPIDs
				$pid = $aProcess[0]
				Local $sCommandLine = $aProcess[2]
				; skip AutoIt3Wrapper processes
				If $pid <> @AutoItPID And StringInStr($sCommandLine, "AutoIt3Wrapper.au3") = 0 Then
					$otherPID = $pid
					ExitLoop
				EndIf
			Next
		EndIf
		If $otherPID > 0 And $otherPID <> @AutoItPID Then
			If $bCheckOnly = True Then
				Return True
			EndIf
			SetDebugLog("Found existing " & $sBotWindowTitle & " instance to close, PID " & $otherPID & ", HWnD " & $otherHWnD)
			; close any related WerFault Window as well
			WerFaultClose("AutoIt v3 Script")
			WerFaultClose(@AutoItExe)
			; using PostMessage as SendMessageTimeout (used by WinClose) can freeze
			SetDebugLog("Send close message...")
			_WinAPI_PostMessage($otherHWnD, $WM_CLOSE, 0, 0)
			#cs
			If WinClose($otherHWnD) = 1 Then
				SetDebugLog("Existing bot window closed")
			EndIf
			#ce
			If ProcessWaitClose($otherPID, 30) = 0 Then
				; bot didn't close in 30 secodns, force close now
				SetDebugLog("Existing bot window still there...")
				WinKill($otherHWnD)
				SetDebugLog("Existing bot window killed")
			EndIf
			
			; paranoia section...
			If ProcessExists($otherPID) = $otherPID Then
				SetDebugLog("Existing bot process still there...")
				If KillProcess($otherPID, "CloseRunningBot") = True Then
					SetDebugLog("Existing bot process now closed")
					Return True
				EndIf
				Return False
			EndIf
			Return True
		EndIf
	EndIf
	Return False
EndFunc   ;==>CloseRunningBot
