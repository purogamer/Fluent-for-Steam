; #FUNCTION# ====================================================================================================================
; Name ..........: isProblemAffect
; Description ...: Test the screen for possible error messages from CoC or Bluestacks
; Syntax ........: isProblemAffect(False), False is default.
; Parameters ....: False = True will make a new 2x2 screencapture to identify the pixels to test, False will assume there is a full screen capture to use.
; Return values .: True if screen is blocked by an error message from CoC or BlueStacks
; Author ........: HungLe (05-2015)
; Modified ......: Hervidero (05-2015), Boldina (22/6/2022)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......: Click
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func isProblemAffect($bNeedCaptureRegion = False)
	Local $iGray = 0x282828
	If $g_iAndroidVersionAPI >= $g_iAndroidLollipop Then $iGray = 0x424242
	
	; Custom fix - Team AIO Mod++
	If $bNeedCaptureRegion = False Then _CaptureRegion()
	
	If Not _ColorCheck(_GetPixelColor(253, 395 + $g_iMidOffsetY, False), Hex($iGray, 6), 10) Then
		Return False
	ElseIf Not _ColorCheck(_GetPixelColor(373, 395 + $g_iMidOffsetY, False), Hex($iGray, 6), 10) Then
		Return False
	ElseIf Not _ColorCheck(_GetPixelColor(473, 395 + $g_iMidOffsetY, False), Hex($iGray, 6), 10) Then
		Return False
	ElseIf Not _ColorCheck(_GetPixelColor(283, 395 + $g_iMidOffsetY, False), Hex($iGray, 6), 10) Then
		Return False
	ElseIf Not _ColorCheck(_GetPixelColor(320, 395 + $g_iMidOffsetY, False), Hex($iGray, 6), 10) Then
		Return False
	ElseIf Not _ColorCheck(_GetPixelColor(594, 395 + $g_iMidOffsetY, False), Hex($iGray, 6), 10) Then
		Return False
	ElseIf _ColorCheck(_GetPixelColor(823, 32, False), Hex(0xF8FCFF, 6), 10) Then
		Return False
	Else
		Return True
	EndIf
EndFunc   ;==>isProblemAffect
