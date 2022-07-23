; #FUNCTION# ====================================================================================================================
; Name ..........: ConvertOCRTime
; Description ...: This function will update the statistics in the GUI.
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Boju (11-2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......:
; ===============================================================================================================================

Func ConvertOCRTime($sCaller, $sConvertTo, $bSetLog = True, $sReturnFormat = "min")
	Local $iRemainTimer = 0, $avResult, $iDay = 0, $iHour = 0, $iMinute = 0, $iSecond = 0

	If $sConvertTo <> "" Then
		If StringInStr($sConvertTo, "d") > 1 Then
			$avResult = StringSplit($sConvertTo, "d", $STR_NOCOUNT)
			; $avResult[0] will be the Day and the $avResult[1] will be the rest
			$iDay = Number($avResult[0])
			$sConvertTo = $avResult[1]
		EndIf
		If StringInStr($sConvertTo, "h") > 1 Then
			$avResult = StringSplit($sConvertTo, "h", $STR_NOCOUNT)
			$iHour = Number($avResult[0])
			$sConvertTo = $avResult[1]
		EndIf
		If StringInStr($sConvertTo, "m") > 1 Then
			$avResult = StringSplit($sConvertTo, "m", $STR_NOCOUNT)
			$iMinute = Number($avResult[0])
			$sConvertTo = $avResult[1]
		EndIf
		If StringInStr($sConvertTo, "s") > 1 Then
			$avResult = StringSplit($sConvertTo, "s", $STR_NOCOUNT)
			$iSecond = Number($avResult[0])
		EndIf

		Local $iTimeInSeconds = ($iDay * 24 * 3600) + ($iHour * 3600) + ($iMinute * 60) + $iSecond

		Switch StringLower($sReturnFormat)
			Case "day"
				$iRemainTimer = Int($iTimeInSeconds / 86400)
			Case "hour"
				$iRemainTimer = Int($iTimeInSeconds / 3600)
			Case "min"
				$iRemainTimer = Int($iTimeInSeconds / 60)
			Case "sec"
				$iRemainTimer = Int($iTimeInSeconds)
			Case Else
				SetLog("Error processing ReturnFormat " & $sReturnFormat, $COLOR_ERROR)
				SetError(3, "Error processing time string")
				Return $iRemainTimer
		EndSwitch
		
		If $iRemainTimer = 0 And $g_bDebugSetlog Then SetDebugLog($sCaller & ": Bad OCR string", $COLOR_ERROR)
		
		If $bSetLog Then SetLog($sCaller & " Time: " & $iRemainTimer & " " & $sReturnFormat, $COLOR_INFO)
	Else
		SetDebugLog("Can not read remaining time for " & $sCaller, $COLOR_ERROR)
	EndIf

	Return $iRemainTimer
EndFunc   ;==>ConvertOCRTime
