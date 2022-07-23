; #FUNCTION# ====================================================================================================================
; Name ..........: _logErrorDLLCall
; Description ...: SetLogs @error information for DLLCalls
; Syntax ........: _logErrorDLLCall($sDllName, $ErrorCode)
; Parameters ....: $sDllName            - a string name or location of DLL that caused error
;                  $ErrorCode           - @error
; Return values .: None
; Author ........: MonkeyHunter (2016-2)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......: Click
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func _logErrorDLLCall($sDllName, $ErrorCode)
	Local $sEmsg
	If $ErrorCode > 0 Then
		Switch $ErrorCode
			Case 1
				$sEmsg = "unable to use DLL file"
			Case 2
				$sEmsg = "unknown return type"
			Case 3
				$sEmsg = "function not found in the DLL file"
			Case 4
				$sEmsg = "bad number of parameters"
			Case 5
				$sEmsg = "bad parameter"
			Case Else
				$sEmsg = "Unknown Error Code?"
		EndSwitch
		SetLog($sDllName & " DLLCall Error, @error code: " & $sEmsg, $COLOR_ERROR)
	EndIf
EndFunc   ;==>_logErrorDLLCall

; #FUNCTION# ====================================================================================================================
; Name ..........: _logErrorDateDiff
; Description ...: Setlogs @error information for _DateDiff function
; Syntax ........: _logErrorDateDiff($ErrorCode)
; Parameters ....: $ErrorCode           - an unknown value.
; Return values .: None
; Author ........: MonkeyHunter (2016-2)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......: Click
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func _logErrorDateDiff($ErrorCode)
	Local $sEmsg
	Switch $ErrorCode
		Case 1
			$sEmsg = "1| Invalid $sType"
		Case 2
			$sEmsg = "2| Invalid $iNumber"
		Case 3
			$sEmsg = "3| Invalid $sEndDate"
	EndSwitch
	SetLog("_DateDiff error code = " & $sEmsg, $COLOR_ERROR)
EndFunc   ;==>_logErrorDateDiff

; #FUNCTION# ====================================================================================================================
; Name ..........: _logErrorDateAdd
; Description ...: Setlogs @error information for _DateAdd function
; Syntax ........: _logErrorDateAdd($ErrorCode)
; Parameters ....: $ErrorCode           - an unknown value.
; Return values .: None
; Author ........: MonkeyHunter (2016-2)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......: Click
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func _logErrorDateAdd($ErrorCode)
	Local $sEmsg
	Switch $ErrorCode
		Case 1
			$sEmsg = "1| Invalid $sType"
		Case 2
			$sEmsg = "2| Invalid $sStartDate"
		Case 3
			$sEmsg = "3| Invalid $sEndDate"
	EndSwitch
	SetLog("_DateAdd error code = " & $sEmsg, $COLOR_ERROR)
EndFunc   ;==>_logErrorDateAdd

Func _logErrorGetBuilding($ErrorCode)
	Local $sEmsg
	Switch $ErrorCode
		Case 1
			$sEmsg = "1| Path missing in $g_oBldgImages dictionary"
		Case 2
			$sEmsg = "2| DLL found no buildings"
		Case Else
			$sEmsg = "Slap Code Monkey!"
	EndSwitch
	SetLog("# GetLocationBuilding error code: " & $sEmsg, $COLOR_ERROR)
EndFunc   ;==>_logErrorGetBuilding
