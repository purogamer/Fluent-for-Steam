; #FUNCTION# ====================================================================================================================
; Name ..........: isGemOpen.au3
; Description ...: Test the screen for Gem Window open
; Syntax ........: isGemOpen($bNeedCaptureRegion), FALSE is default.
; Parameters ....: $bNeedCaptureRegion = True will make a new 2x2 screencapture to identify the pixels to test, False will assume there is a full screen capture to use.
; Return values .: True if Gem window is open and it was closed with click to $aAway
; Author ........: KnowJack (05-2015)
; Modified ......: Sardo (12-2015), MonkeyHutner (12-2015)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......: Click
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func isGemOpen($bNeedCaptureRegion = False, $bClick = False) ; Team AIO Mod++
	If _Sleep($DELAYISGEMOPEN1) Then Return
	If _CheckPixel($aIsGemWindow1, $bNeedCaptureRegion) Then ; Safety Check if the normal use Gem window opens
		SetDebugLog("Gemclick Red X detect", $COLOR_DEBUG)
		If ($bClick = False) Then ClickAway() ; ClickP($aAway, 1, 0, "#0140") ; click away to close gem window
		Return True
	ElseIf _CheckPixel($aIsGemWindow2, $bNeedCaptureRegion) And _ ; check for the red line under the redX square of gem window
			_CheckPixel($aIsGemWindow3, $bNeedCaptureRegion) And _
			_CheckPixel($aIsGemWindow4, $bNeedCaptureRegion) Then
		SetDebugLog("Gemclick Red Line detect", $COLOR_DEBUG)
		If ($bClick = False) Then ClickAway() ; ClickP($aAway, 1, 0, "#0141")
		Return True
	EndIf
	Return False
EndFunc   ;==>isGemOpen

