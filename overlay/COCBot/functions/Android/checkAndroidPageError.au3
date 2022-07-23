; #FUNCTION# ====================================================================================================================
; Name ..........: CheckAndroidPageError
; Description ...: Function to check for Android IsPage error to reboot Android if threshold exceeded
; Syntax ........: CheckAndroidPageError()
; Parameters ....: $bRebootAndroid = True reboots Android if too many page errors per Minutes detected
; Return values .: True if Android reboot should be initiated, False otherwise
; Author ........: Cosote (10-2016)
; Modified ......: CodeSlinger69 (01-2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2016-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: If CheckAndroidPageError() = True Then Return
; ===============================================================================================================================
#include-once

Global $g_aiAndroidPageError[2] = [0, 0] ; Variables for page error count and TimerHandle

Func InitAndroidPageError()
	$g_aiAndroidPageError[0] = 0 ; Page Error Counter
	$g_aiAndroidPageError[1] = 0 ; TimerHandle
EndFunc   ;==>InitAndroidPageError

Func CheckAndroidPageError($bRebootAndroid = True)

	If $g_aiAndroidPageError[1] = 0 Then Return False

	Local $bResetTimer = __TimerDiff($g_aiAndroidPageError[1]) > $g_iAndroidRebootPageErrorPerMinutes * 60 * 1000

	If $g_aiAndroidPageError[0] >= $g_iAndroidRebootPageErrorCount And $bResetTimer = False Then

		Local $sMin = Round(__TimerDiff($g_aiAndroidPageError[1]) / (60 * 1000), 1) & " Minutes"

		If $bRebootAndroid = True Then
			SetLog("Reboot " & $g_sAndroidEmulator & " due to " & $g_aiAndroidPageError[0] & " page errors in " & $sMin, $COLOR_ERROR)
			SaveDebugImage("page_error", False, Default, "current-hbitmap-")
			SaveDebugImage("page_error", True, Default, "new-hbitmap-")
		Else
			SetLog($g_sAndroidEmulator & " had " & $g_aiAndroidPageError[0] & " page errors in " & $sMin, $COLOR_ERROR)
		EndIf

		InitAndroidPageError()

		If $bRebootAndroid = True Then
			Return True
		EndIf

		Return False

	EndIf

	If $bResetTimer = True Then

		If $g_aiAndroidPageError[0] > 0 Then
			SetDebugLog("Cleared " & $g_aiAndroidPageError[0] & " " & $g_sAndroidEmulator & " page errors")
		EndIf

		InitAndroidPageError()

	EndIf

	Return False

EndFunc   ;==>CheckAndroidPageError


Func AndroidPageError($sSource)

	$g_aiAndroidPageError[0] += 1
	SetDebugLog("Page error count increased to " & $g_aiAndroidPageError[0] & ", source: " & $sSource)
	If $g_aiAndroidPageError[1] = 0 Then $g_aiAndroidPageError[1] = __TimerInit()
	Return $g_aiAndroidPageError[0]

EndFunc   ;==>AndroidPageError

