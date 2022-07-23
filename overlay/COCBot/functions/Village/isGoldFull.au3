; #FUNCTION# ====================================================================================================================
; Name ..........: isGoldFull
; Description ...: Checks if your Gold Storages are maxed out
; Syntax ........: isGoldFull()
; Parameters ....:
; Return values .: True or False
; Author ........: Code Monkey #57 (send more bananas please!)
; Modified ......: Hervidero (2015)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func isGoldFull()
	If _CheckPixel($aIsGoldFull, $g_bCapturePixel) Then ;Hex if color of gold (orange)
		SetLog("Gold Storages are full!", $COLOR_SUCCESS)
		$g_abFullStorage[$eLootGold] = True
	ElseIf $g_abFullStorage[$eLootGold] Then
		If Number($g_aiCurrentLoot[$eLootGold]) >= Number($g_aiResumeAttackLoot[$eLootGold]) Then
			SetLog("Gold Storages is relatively full: " & $g_aiCurrentLoot[$eLootGold], $COLOR_SUCCESS)
			$g_abFullStorage[$eLootGold] = True
		Else
			SetLog("Switching back to normal when Gold drops below " & $g_aiResumeAttackLoot[$eLootGold], $COLOR_SUCCESS)
			$g_abFullStorage[$eLootGold] = False
		EndIf
	EndIf
	Return $g_abFullStorage[$eLootGold]
EndFunc   ;==>isGoldFull
