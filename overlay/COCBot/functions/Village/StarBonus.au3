; #FUNCTION# ====================================================================================================================
; Name ..........: StarBonus
; Description ...: Checks for Star bonus window, and clicks ok to close window.
; Syntax ........: StarBonus()
; Parameters ....:
; Return values .: MonkeyHunter(2016-1)
; Modified ......: MonkeyHunter (05-2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func StarBonus()

	SetDebugLog("Begin Star Bonus window check", $COLOR_DEBUG1)

	; Verify is Star bonus window open?
	If Not _CheckPixel($aIsMainGrayed, $g_bCapturePixel, Default, "IsMainGrayed") Then Return ; Star bonus window opens on main base view, and grays page.

	If _Sleep($DELAYSTARBONUS100) Then Return

	; Verify actual star bonus window open
	If _CheckPixel($g_aSbonusWindowChk1, $g_bCapturePixel, Default, "Starbonus1") And _CheckPixel($g_aSbonusWindowChk2, $g_bCapturePixel, Default, "Starbonus2") Then
		; Find and Click Okay button
		Local $offColors[3][3] = [[0x131313, 144, 0], [0xFFFFFF, 54, 17], [0xD7F478, 54, 10]] ; 2nd Black opposite button, 3rd pixel white "O" center top, 4th pixel White "0" bottom center
		Local $ButtonPixel = _MultiPixelSearch(353, 442 + $g_iMidOffsetY, 502, 474 + $g_iMidOffsetY, 1, 1, Hex(0x131313, 6), $offColors, 20) ; first vertical black pixel of Okay
		SetDebugLog("Okay btn chk-#1: " & _GetPixelColor(354, 442 + $g_iMidOffsetY, $g_bCapturePixel) & ", #2: " & _GetPixelColor(354 + 145, 442 + $g_iMidOffsetY, $g_bCapturePixel) & ", #3: " & _GetPixelColor(354 + 55, 442 + 16 + $g_iMidOffsetY, $g_bCapturePixel) & ", #4: " & _GetPixelColor(355 + 51, 442 + 23 + $g_iMidOffsetY, $g_bCapturePixel), $COLOR_DEBUG)
		If IsArray($ButtonPixel) Then
			If $g_bDebugSetlog Then
				SetDebugLog("ButtonPixelLocation = " & $ButtonPixel[0] & ", " & $ButtonPixel[1], $COLOR_DEBUG) ;Debug
				SetDebugLog("Pixel color found #1: " & _GetPixelColor($ButtonPixel[0], $ButtonPixel[1], $g_bCapturePixel) & ", #2: " & _GetPixelColor($ButtonPixel[0] + 144, $ButtonPixel[1], $g_bCapturePixel) & ", #3: " & _GetPixelColor($ButtonPixel[0] + 52, $ButtonPixel[1] + 17, $g_bCapturePixel) & ", #4: " & _GetPixelColor($ButtonPixel[0] + 51, $ButtonPixel[1] + 24, $g_bCapturePixel), $COLOR_DEBUG)
			EndIf
			Click($ButtonPixel[0] + 75, $ButtonPixel[1] + 25, 2, 50, "#0117") ; Click Okay Button
			If _Sleep($DELAYSTARBONUS500) Then Return
			Return True
		EndIf
	EndIf

	SetDebugLog("Star Bonus window not found?", $COLOR_DEBUG)
	Return False

EndFunc   ;==>StarBonus