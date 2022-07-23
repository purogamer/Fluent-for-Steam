; #FUNCTION# ====================================================================================================================
; Name ..........: GetCurTotalSpell
; Description ...: Obtains count of spells available from Training - Army Overview window
; Syntax ........: GetCurTotalSpell()
; Parameters ....:
; Return values .: Total current spell count or -1 when not yet read
; Author ........:
; Modified ......: MonkeyHunter (06-2016), CodeSlinger69 (01-2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Func GetCurTotalSpell()

	Local $iCount = 0
	For $i = 0 To $eSpellCount - 1
		$iCount += $g_aiCurrentSpells[$i]
	Next

	Return $iCount
EndFunc   ;==>GetCurTotalSpell