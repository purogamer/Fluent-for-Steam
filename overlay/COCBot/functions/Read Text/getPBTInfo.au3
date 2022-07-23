; #FUNCTION# ====================================================================================================================
; Name ..........: getPBTInfo
; Description ...: Determines if Shield/Guard exists, reads PBT time, computes time till PBT starts, and returns results in array
; Syntax ........: getPBTInfo()
; Parameters ....:
; Return values .: Returns Array =  $aPBTReturnResult
; ...............: [0]=String shield type, [1]=String PBT time format = "00:00:00", [2]=String date/time till PBT start
; ...............: Sets @error if buttons not found properly or problem with OCR of PBT time, and sets @extended with string error message
; Author ........: MonkeyHunter (2016-02)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: below function:
; ===============================================================================================================================
Func getPBTInfo()

	Local $sTimeResult = ""
	Local $aString[3]
	Local $bPBTStart = False
	Local $iPBTSeconds, $Result
	Local $iHour = 0, $iMin = 0, $iSec = 0
	Local $aPBTReturnResult[3] = ["", "", ""] ; reset return values
	; $aPBTReturnResult[3] = [0] = string type of shield, [1] = string PBT time remaining,  [2] = string PBT start date/time used by _DateDiff()

	$aPBTReturnResult[1] = StringFormat("%02s", $iHour) & ":" & StringFormat("%02s", $iMin) & ":" & StringFormat("%02s", $iSec)

	If IsMainPage() = False Then ; check for main page or do not try
		SetLog("Not on Main page to read PBT information", $COLOR_ERROR)
		Return
	EndIf

	Select ; Check for Shield type
		Case _CheckPixel($aNoShield, $g_bCapturePixel)
			$aPBTReturnResult[0] = "none"
			SetDebugLog("No shield active", $COLOR_DEBUG)
		Case _CheckPixel($aHaveShield, $g_bCapturePixel)
			$aPBTReturnResult[0] = "shield" ; check for shield
			SetDebugLog("Shield Active", $COLOR_DEBUG)
		Case _CheckPixel($aHavePerGuard, $g_bCapturePixel)
			$aPBTReturnResult[0] = "guard" ; check for personal guard timer
			SetDebugLog("Guard Active", $COLOR_DEBUG)
		Case Else
			SetLog("Sorry, Monkey needs more bananas to read shield type", $COLOR_ERROR) ; Check for pixel colors errors!
			If $g_bDebugImageSave Then SaveDebugImage("ShieldInfo_", $g_bCapturePixel, "png", False)
			SetError(1, "Bad shield type pixel read")
			Return
	EndSelect

	PureClickP($aShieldInfoButton) ; click on PBT info icon
	If _Sleep($DELAYPERSONALSHIELD3) Then Return

	Local $iCount = 0
	While _CheckPixel($aIsShieldInfo, $g_bCapturePixel) = False ; check for open shield info window
		If _Sleep($DELAYPERSONALSHIELD2) Then Return
		$Result = getAttackDisable(180, 156 + $g_iMidOffsetY) ; Try to grab Ocr for PBT warning message as it can randomly block pixel check
		SetDebugLog("OCR PBT warning= " & $Result, $COLOR_DEBUG)
		If (StringLen($Result) > 3) And StringRegExp($Result, "[a-w]", $STR_REGEXPMATCH) Then ; Check string for valid characters
			SetLog("Personal Break Warning found!", $COLOR_INFO)
			$bPBTStart = True
			ExitLoop
		EndIf
		$iCount += 1
		If $iCount > 20 Then ; Wait ~10-12 seconds for window to open before error return
			SetLog("PBT information window failed to open", $COLOR_DEBUG)
			If $g_bDebugImageSave Then SaveDebugImage("PBTInfo_", $g_bCapturePixel, "png", False)
			ClickAway()
			If _Sleep($DELAYPERSONALSHIELD2) Then Return ; wait for close
			Return
		EndIf
	WEnd

	If _CheckPixel($aIsShieldInfo, $g_bCapturePixel) Or $bPBTStart Then

		$sTimeResult = getOcrPBTtime(555, 499 + $g_iMidOffsetY) ; read PBT time
		SetDebugLog("OCR PBT Time= " & $sTimeResult, $COLOR_DEBUG)
		If $sTimeResult = "" Then ; try a 2nd time after a short delay if slow PC and null read
			If _Sleep($DELAYPERSONALSHIELD2) Then Return ; pause for slow PC
			$sTimeResult = getOcrPBTtime(555, 499 + $g_iMidOffsetY) ; read PBT time
			SetDebugLog("OCR2 PBT Time= " & $sTimeResult, $COLOR_DEBUG)
			If $sTimeResult = "" Then ; error if no read value
				SetLog("strange error, no PBT value found?", $COLOR_ERROR)
				SetError(2, "Bad time value OCR read")
				ClickAway()
				If _Sleep($DELAYPERSONALSHIELD2) Then Return ; wait for close
				Return $aPBTReturnResult ; return zero value
			EndIf
		EndIf

		If _Sleep($DELAYPERSONALSHIELD3) Then Return ; improve pause/stop button response

		$aString = StringSplit($sTimeResult, " ") ; split hours/minutes or minutes/seconds
		Switch $aString[0]
			Case 1
				If StringInStr($aString[1], "s", $STR_NOCASESENSEBASIC) Then $iSec = Number($aString[1])
			Case 2
				Select
					Case StringInStr($aString[1], "h", $STR_NOCASESENSEBASIC)
						$iHour = Number($aString[1])
						If StringInStr($aString[2], "m", $STR_NOCASESENSEBASIC) Then
							$iMin = Number($aString[2])
						EndIf
					Case StringInStr($aString[1], "m", $STR_NOCASESENSEBASIC)
						$iMin = Number($aString[1])
						If StringInStr($aString[2], "s", $STR_NOCASESENSEBASIC) Then
							$iSec = Number($aString[2])
						EndIf
					Case Else
						SetLog("strange error, unexpected PBT value?", $COLOR_ERROR)
						SetError(3, "Error processing time string")
						ClickAway()
						If _Sleep($DELAYPERSONALSHIELD2) Then Return ; wait for close
						Return $aPBTReturnResult ; return zero value
				EndSelect
			Case Else
				SetLog("Error processing PBT time string: " & $sTimeResult, $COLOR_ERROR)
				SetError(4, "Error processing time string")
				ClickAway()
				If _Sleep($DELAYPERSONALSHIELD2) Then Return ; wait for close
				Return $aPBTReturnResult ; return zero value
		EndSwitch

		$aPBTReturnResult[1] = StringFormat("%02s", $iHour) & ":" & StringFormat("%02s", $iMin) & ":" & StringFormat("%02s", $iSec)
		SetDebugLog("PBT Time String = " & $aPBTReturnResult[1], $COLOR_DEBUG)

		$iPBTSeconds = ($iHour * 3600) + ($iMin * 60) + $iSec ; add time into total seconds
		SetDebugLog("Computed PBT Seconds = " & $iPBTSeconds, $COLOR_DEBUG)

		If $bPBTStart Then
			$aPBTReturnResult[2] = _DateAdd('s', -10, _NowCalc()) ; Calc time -10 seconds before now.
		Else
			$aPBTReturnResult[2] = _DateAdd('s', $iPBTSeconds, _NowCalc()) ; Calc actual expire time from now.
		EndIf
		If @error Then SetLog("_DateAdd error= " & @error, $COLOR_ERROR)
		SetDebugLog("PBT starts: " & $aPBTReturnResult[2], $COLOR_INFO)
		If _Sleep($DELAYPERSONALSHIELD1) Then Return

		ClickAway()
		If _Sleep($DELAYPERSONALSHIELD2) Then Return ; wait for close

		Return $aPBTReturnResult
	Else
		SetDebugLog("PBT Info window failed to open for PBT OCR", $COLOR_ERROR)
	EndIf

EndFunc   ;==>getPBTInfo
