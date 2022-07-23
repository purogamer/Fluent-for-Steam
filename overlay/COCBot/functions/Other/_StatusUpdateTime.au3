; #FUNCTION# ====================================================================================================================
; Name ..........: StatusUpdateTime
; Description ...: simple timer display function, displays time passed since handle declared in status bar, Give the user feedback the bot is waiting for something
; Syntax ........: StatusUpdateTime($hTimer)
; Parameters ....: $hTimer              - timer handle provided by __TimerInit()
; Return values .: None
; Author ........: KnowJack (Aug2015)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
;
Func _StatusUpdateTime($hTimer, $sWhyWait = "")
	Local $iCurTime = __TimerDiff($hTimer)
	Local $iMinCalc = Int($iCurTime / (60 * 1000))
	Local $iSecCalc = Int(($iCurTime - ($iMinCalc * 60 * 1000)) / 1000)
	Local $sString = $sWhyWait & " Wait Time = " & StringFormat("%02u" & ":" & "%02u", $iMinCalc, $iSecCalc)
	_GUICtrlStatusBar_SetTextEx($g_hStatusBar, " Status: " & $sString)
EndFunc   ;==>_StatusUpdateTime
