; #FUNCTION# ====================================================================================================================
; Name ..........: _CheckPixel
; Description ...: _CheckPixel : takes an Screencode array[4] as a parameter, [x, y, color, tolerance], $bNeedCapture is used cature if needed in the _GetPixelColor function
; Syntax ........: _CheckPixel($aScreenCode[, $bNeedCapture = Default[, $Ignore = Default[, $sLogText = Default[, $Color = Default[, $bSilentSetLog = Default]]]]])
; Parameters ....: $aScreenCode         - an array of screen data: x location, y location, colot code, tolerance as specified in ScreenCoordinates file.
;                  $bNeedCapture        - [optional] a boolean value to flag if capture is needed. Default is Default.
;                  $Ignore              - [optional] a string of color to be ignored in _colorcheck(). Default is Default.
;                  $sLogText            - [optional] a string value of text to log for color. Default is Default. No log generated if null or default
;                  $LogTextColor        - [optional] an integer value for text color of log message. Default is Default = purple
;                  $bSilentSetLog       - [optional] a boolean value to flag if log message is suppressed from GUI. Default is Default.
; Return values .: True when the referenced pixel is found, False if not found
; Author ........: FastFrench (2015)
; Modified ......: Hervidero (2015), MonkeyHunter (08-2015)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func _CheckPixel($aScreenCode, $bNeedCapture = Default, $Ignore = Default, $sLogText = Default, $LogTextColor = Default, $bSilentSetLog = Default)
	If $bNeedCapture = Default Then $bNeedCapture = False
	If $g_bDebugSetlog And $sLogText <> Default And IsString($sLogText) Then
		$sLogText &= ", Expected: " & Hex($aScreenCode[2], 6) & ", Tolerance: " & $aScreenCode[3]
	Else
		$sLogText = Default
	EndIf
	If _ColorCheck( _
			_GetPixelColor($aScreenCode[0], $aScreenCode[1], $bNeedCapture, $sLogText, $LogTextColor, $bSilentSetLog), _ ; capture color #1
			Hex($aScreenCode[2], 6), _ ; compare to Color #2 from screencode
			$aScreenCode[3], $Ignore) Then ; using tolerance from screencode and color mask name referenced by $Ignore
		Return True
	EndIf
	Return False ;
EndFunc   ;==>_CheckPixel

Func _CheckPixel2($aScreenCode, $sHexColor, $Ignore = Default)
	If _ColorCheck( _
			$sHexColor, _ ; capture color #1
			Hex($aScreenCode[2], 6), _ ; compare to Color #2 from screencode
			$aScreenCode[3], $Ignore) Then ; using tolerance from screencode and color mask name referenced by $Ignore
		Return True
	EndIf
	Return False ;
EndFunc   ;==>_CheckPixel2

Func _WaitForCheckPixel($aScreenCode, $bNeedCapture = Default, $Ignore = Default, $sLogText = Default, $LogTextColor = Default, $bSilentSetLog = Default, $iWaitLoop = Default)
	If $iWaitLoop = Default Then $iWaitLoop = 250  ; if default wait time per loop, then wait 250ms
	Local $wCount = 0
	While _CheckPixel($aScreenCode, $bNeedCapture, $Ignore, $sLogText, $LogTextColor, $bSilentSetLog) = False
		If _Sleep($iWaitLoop ) Then Return
		$wCount += 1
		If $wCount > 20 Then ; wait for 20*250ms=5 seconds for pixel to appear
			SetLog($sLogText & " not found!", $COLOR_ERROR)
			Return False
		EndIf
	WEnd
	Return True
EndFunc