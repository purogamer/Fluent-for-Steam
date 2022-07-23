;#FUNCTION# ====================================================================================================================
; Name ..........: RestartBot
; Description ...: Restart the bot
; Syntax ........: RestartBot([$bCloseAndroid, [$bAutostart]])
; Parameters ....: $bCloseAndroid    - [Optional] Default True closed Android
;                  $bAutostart       - [optional] Default True autostart bot (run state)
; Return values .: None
; Author ........: MyBot.run team
; Modified ......: Cosote (Feb-2017) xbebenk and snorlax
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#Region - Custom fix - Team AIO Mod++ 
; Credits: xbebenk mod possibly snorlax
; (Custom fix - Team AIO Mod++ is Only for code identification )

Func RestartBot($bCloseAndroid = True, $bAutostart = True)
	SetDebugLog("Restart " & $g_sBotTitle)
	Local $sCmdLine = ProcessGetCommandLine(@AutoItPID)
	If @error <> 0 Then
		SetLog("Cannot prepare to restart " & $g_sBotTitle & ", error code " & @error, $COLOR_RED)
		Return SetError(1, 0, False)
	EndIf

	; add restart option (if not already there)
	If StringInStr($sCmdLine, " /restart") = 0 Then
		$sCmdLine &= " /restart"
	EndIf
	
	; add autostart option (if not already there)
	If $bAutostart Then
		If StringInStr($sCmdLine, " /autostart") = 0 Then $sCmdLine &= " /autostart"
	EndIf

	If $bCloseAndroid Then
		CloseAndroid("RestartBot")
		_Sleep(1000)
	EndIf
	Local $sCurrentAccountName = $g_sProfileCurrentName
	Local $sStartAccountName
	If ProfileSwitchAccountEnabled() Then
		For $i = 0 To Ubound($g_abAccountNo) - 1
			SetDebugLog("Search: " & $g_asProfileName[$i] & " on " & $sCmdLine)
			If StringInStr($sCmdLine, $g_asProfileName[$i]) Then
				$sStartAccountName = $g_asProfileName[$i]
				ExitLoop
			EndIf
		Next
		StringReplace($sCmdLine, $sStartAccountName, $sCurrentAccountName)
		SetDebugLog("Result: " & $sCmdLine)
	EndIf

	; Restart My Bot
	SetDebugLog("sCmdLine= " & $sCmdLine)
	Local $pid = Run("cmd.exe /c start """" " & $sCmdLine, $g_sWorkingDir, @SW_HIDE) ; cmd.exe only used to support launch like "..\AutoIt3\autoit3.exe" from console
	If @error = 0 Then
		SetLog("Restarting " & $g_sBotTitle)
		; Wait 1 Minute to get closed
		_SleepStatus(60 * 1000)
		Return True
	Else
		SetLog("Cannot restart " & $g_sBotTitle, $COLOR_RED)
	EndIf

	Return SetError(2, 0, False)
EndFunc   ;==>_Restart
#EndRegion - Custom fix - Team AIO Mod++ 
