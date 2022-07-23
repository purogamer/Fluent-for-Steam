; #FUNCTION# ====================================================================================================================
; Name ..........: debugAttackCSV
; Description ...:
; Syntax ........: debugAttackCSV($string)
; Parameters ....: $string              - a string value.
; Return values .: None
; Author ........: Sardo (2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func debugAttackCSV($string)
	If $g_bDebugAttackCSV Then
		_ConsoleWrite("A " & TimeDebug() & $string & @CRLF)
		Local $hfile = FileOpen($g_sProfileLogsPath & "debugAttackCSV.log", $FO_APPEND)
		_FileWriteLog($hfile, $string)
		FileClose($hfile)
	EndIf
EndFunc   ;==>debugAttackCSV
