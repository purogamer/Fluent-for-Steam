; #FUNCTION# ====================================================================================================================
; Name ..........: SetSleep
; Description ...: Randomizes deployment wait time
; Syntax ........: SetSleep($iType)
; Parameters ....: $iType                - Flag for type return desired.
; Return values .: None
; Author ........: KnowJack (06-2015)
; Modified ......: Boldina ! (2020)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2020
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#Region - Custom sleep Drop - Team AIO Mod++
Func SetSleep($iType)
	If IsKeepClicksActive() = True Then Return 0
	Local $iOffset0 = 10, $iOffset1 = 100, $iMode = ($g_iMatchMode = $DB) ? (($g_aiAttackAlgorithm[$DB] = 0) ? (0) : (1)) : (2)
	Switch $iType
		Case 0
			If $g_bChkEnableRandom[$iMode] Then
				Return Round(Random(0.95, 1.15) * (($g_iDeployDelay[$iMode] + 1) * $iOffset0))
			Else
				Return Round(Random(4, 15) * $iOffset0)
			EndIf
		Case 1
			If $g_bChkEnableRandom[$iMode] Then
				Return Round(Random(0.95, 1.15) * (($g_iDeployWave[$iMode] + 1) * $iOffset1))
			Else
				Return Round(Random(4, 15) * $iOffset1)
			EndIf
	EndSwitch
EndFunc   ;==>SetSleep

; #FUNCTION# ====================================================================================================================
; Name ..........: _SleepAttack
; Description ...: Version of _Sleep() used in attack code so active keep clicks mode doesn't slow down bulk deploy
; Syntax ........: see _Sleep
; Parameters ....: see _Sleep
; Return values .: see _Sleep
; Author ........: cosote (2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
                 ; MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func _SleepAttack($iDelay, $iSleep = True)
	If Not $g_bRunState Then
		ResumeAndroid()
		Return True
	EndIf
	If IsKeepClicksActive() Then Return False
	Return RandomSleep($iDelay, $iDelay * 0.10) ; Team AIO Mod++
EndFunc   ;==>_SleepAttack
#EndRegion - Custom sleep Drop - Team AIO Mod++
