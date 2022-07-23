;
; #FUNCTION# ====================================================================================================================
; Name ..........: WerFaultClose
; Description ...: Closes a WerFault message for given programm
; Syntax ........: WerFaultClose($programFile)
; Parameters ....: Full path or just program.exe of WerFault message to close
; Return values .: Number of windows closed
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......: checkMainscreen, isProblemAffect
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func WerFaultClose($programFile, $tryCountMax = 10, $tryCount = 0)

	Local $WinTitleMatchMode = Opt("WinTitleMatchMode", -3) ; Window Title exact match mode (case insensitive)
	Local $sTitle = $programFile

	Local $iLastBS = StringInStr($sTitle, "\", 0, -1)
	If $iLastBS > 0 Then $sTitle = StringMid($sTitle, $iLastBS + 1)

	Local $aList = WinList($sTitle)
	Opt("WinTitleMatchMode", $WinTitleMatchMode)

	Local $closed = 0
	Local $i

	SetDebugLog("Found " & $aList[0][0] & " WerFault Windows with title '" & $sTitle & "'")

	If $aList[0][0] > 0 Then
		For $i = 1 To $aList[0][0]

			Local $HWnD = $aList[$i][1]
			Local $pid = WinGetProcess($HWnD)

			Local $process = ProcessGetWmiProcess($pid)
			If IsArray($process) Then
				Local $werfault = $process[1]
				$iLastBS = StringInStr($werfault, "\", 0, -1)
				$werfault = StringMid($werfault, $iLastBS + 1)

				If $werfault = "WerFault.exe" Then
					SetDebugLog("Found WerFault Process " & $pid)
					If WinClose($HWnD) Then
						SetDebugLog("Closed " & $werfault & " Window " & $HWnD)
						$closed += 1
					Else
						If WinKill($HWnD) Then
							SetDebugLog("Killed " & $werfault & " Window " & $HWnD)
							$closed += 1
						Else
							SetDebugLog("Cannot close " & $werfault & " Window " & $HWnD, $COLOR_ERROR)
						EndIf
					EndIf
				Else
					SetDebugLog("Process " & $pid & " is not WerFault, " & $process[2], $COLOR_ERROR)
				EndIf
			ELse
				SetDebugLog("Wmi Object for process " & $pid & " not found")
			EndIF

		Next
	ElseIf FileExists($programFile) = 1 Then
		; try program FileDescription
		Local $pFileVersionInfo
		If _WinAPI_GetFileVersionInfo($programFile, $pFileVersionInfo) Then
			Local $aFileDescription = _WinAPI_VerQueryValue($pFileVersionInfo, $FV_FILEDESCRIPTION)
			If UBound($aFileDescription) > 1 And UBound($aFileDescription, 2) > 1 Then
				Local $sFileDescription = $aFileDescription[1][1]
				If $sFileDescription Then Return WerFaultClose($sFileDescription, $tryCountMax, $tryCount)
			EndIf
		EndIf
	EndIf

	If $closed > 0 And $tryCount < $tryCountMax Then

		If _Sleep(1000) = False Then

			; recursive call, as more windows might popup
			$closed += WerFaultClose($programFile, $tryCountMax, $tryCount + 1)

		EndIF

	EndIf

	Return $closed

EndFunc   ;==>WerFaultClose
