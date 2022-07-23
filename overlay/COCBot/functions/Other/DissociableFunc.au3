; #FUNCTION# ====================================================================================================================
; Name ..........: DissociableFunc
; Description ...: DissociableFunc will open or close Dissociable.OCR.dll and Dissociable.Matching.dll .
; Syntax ........:
; Parameters ....:
; Return values .:
; Author ........: Dissociable (2020)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2020
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func DissociableFunc($bStart = True)
	Switch $bStart
		Case True
			; Dissociable.OCR.dll
			$g_hLibDissociableOcr = DllOpen($g_sLibDissociableOcrPath)
			If $g_hLibDissociableOcr = -1 Then
				SetLog($g_sDissociableOcrLib & " not found.", $COLOR_ERROR)
			EndIf
			SetDebugLog($g_sDissociableOcrLib & " opened.")
			; Dissociable.Matching.dll
			$g_hLibDissociableMatch = DllOpen($g_sLibDissociableMatchPath)
			If $g_hLibDissociableMatch = -1 Then
				SetLog($g_sDissociableMatchLib & " not found.", $COLOR_ERROR)
				Return False
			EndIf
			SetDebugLog($g_sDissociableMatchLib & " opened.")
			Return True
		Case False
			; Dissociable.OCR.dll
			DllClose($g_hLibDissociableOcr)
			SetDebugLog($g_sDissociableOcrLib & " closed.")
			; Dissociable.Matching.dll
			DllClose($g_hLibDissociableMatch)
			SetDebugLog($g_sDissociableMatchLib & " closed.")
			Return True
	EndSwitch
EndFunc   ;==>DissociableFunc

Func DllCallDMatching($sFunc, $ReturnType, $sType1 = Default, $vParam1 = Default, $sType2 = Default, $vParam2 = Default, $sType3 = Default, $vParam3 = Default, $sType4 = Default, $vParam4 = Default, $sType5 = Default, $vParam5 = Default _
	, $sType6 = Default, $vParam6 = Default, $sType7 = Default, $vParam7 = Default, $sType8 = Default, $vParam8 = Default, $sType9 = Default, $vParam9 = Default, $sType10 = Default, $vParam10 = Default, $sType11 = Default, $vParam11 = Default)
	
	; Find function Parameters and Defaults: IntPtr sourceHandle, string bundlePath, ushort levelStart = 0, ushort levelEnd = 0, ushort regionX = 0, ushort regionY = 0, ushort regionWidth = 0, ushort regionHeight = 0, ushort threads = 32, ushort limit = 0, bool saveDebugImage = false
	; suspend Android now
	Local $bWasSuspended = SuspendAndroid()
	Local $aResult = _DllCallDMatching($sFunc, $ReturnType, $sType1, $vParam1, $sType2, $vParam2, $sType3, $vParam3, $sType4, $vParam4, $sType5, $vParam5, $sType6, $vParam6, $sType7, $vParam7, $sType8, $vParam8, $sType9, $vParam9, $sType10, $vParam10, $sType11, $vParam11)
	If @error Then
		SetLog("DMatching Issue | Fail 0x0: " & @error)

		If _Sleep(20) Then
			ResumeAndroid()
			$aResult[0] = ""
			Return SetError(0, 0, $aResult)
		EndIf

		$aResult = _DllCallDMatching($sFunc, $ReturnType, $sType1, $vParam1, $sType2, $vParam2, $sType3, $vParam3, $sType4, $vParam4, $sType5, $vParam5, $sType6, $vParam6, $sType7, $vParam7, $sType8, $vParam8, $sType9, $vParam9, $sType10, $vParam10, $sType11, $vParam11)
		If @error Then
			SetLog("DMatching Issue | Fail 0x1: " & @error)
			; resume Android again (if it was not already suspended)
			SuspendAndroid($bWasSuspended)
			Return ""
		EndIf
	EndIf


	If IsArray($aResult) Then
		If StringLeft($aResult[0], 7) = "(ERROR)" Then
			SetLog("DMatching Issue | Fail 0x2. | " & $aResult[0], $COLOR_ERROR)
			; resume Android again (if it was not already suspended)
			SuspendAndroid($bWasSuspended)
			Return ""  
		EndIf
		; resume Android again (if it was not already suspended)
		SuspendAndroid($bWasSuspended)

		Return $aResult[0]
	EndIf

	SetLog("DMatching Issue: Unknown DllCallDMatching Return: " & $aResult)
	; resume Android again (if it was not already suspended)
	SuspendAndroid($bWasSuspended)
	Return ""
EndFunc   ;==>DllCallDMatching

Func _DllCallDMatching($sFunc, $ReturnType, $sType1 = Default, $vParam1 = Default, $sType2 = Default, $vParam2 = Default, $sType3 = Default, $vParam3 = Default, $sType4 = Default, $vParam4 = Default, $sType5 = Default, $vParam5 = Default  _
	, $sType6 = Default, $vParam6 = Default, $sType7 = Default, $vParam7 = Default, $sType8 = Default, $vParam8 = Default, $sType9 = Default, $vParam9 = Default, $sType10 = Default, $vParam10 = Default, $sType11 = Default, $vParam11 = Default)
	If $sFunc = "Find" Then
		If $vParam11 = Default Then $vParam11 = $g_bDMatchingDebugImages
		Return DllCall($g_hLibDissociableMatch, $ReturnType, $sFunc, $sType1, $vParam1, $sType2, $vParam2, $sType3, $vParam3, $sType4, $vParam4, $sType5, $vParam5, $sType6, $vParam6, $sType7, $vParam7, $sType8, $vParam8, $sType9, $vParam9, $sType10, $vParam10, $sType11, $vParam11)
	EndIf
	If $sType1 = Default Then DllCall($g_hLibDissociableMatch, $ReturnType, $sFunc)
	If $sType11 <> Default Then Return DllCall($g_hLibDissociableMatch, $ReturnType, $sFunc, $sType1, $vParam1, $sType2, $vParam2, $sType3, $vParam3, $sType4, $vParam4, $sType5, $vParam5, $sType6, $vParam6, $sType7, $vParam7, $sType8, $vParam8, $sType9, $vParam9, $sType10, $vParam10, $sType11, $vParam11)
	If $sType10 <> Default Then Return DllCall($g_hLibDissociableMatch, $ReturnType, $sFunc, $sType1, $vParam1, $sType2, $vParam2, $sType3, $vParam3, $sType4, $vParam4, $sType5, $vParam5, $sType6, $vParam6, $sType7, $vParam7, $sType8, $vParam8, $sType9, $vParam9, $sType10, $vParam10)
	If $sType9 <> Default Then Return DllCall($g_hLibDissociableMatch, $ReturnType, $sFunc, $sType1, $vParam1, $sType2, $vParam2, $sType3, $vParam3, $sType4, $vParam4, $sType5, $vParam5, $sType6, $vParam6, $sType7, $vParam7, $sType8, $vParam8, $sType9, $vParam9)
	If $sType8 <> Default Then Return DllCall($g_hLibDissociableMatch, $ReturnType, $sFunc, $sType1, $vParam1, $sType2, $vParam2, $sType3, $vParam3, $sType4, $vParam4, $sType5, $vParam5, $sType6, $vParam6, $sType7, $vParam7, $sType8, $vParam8)
	If $sType7 <> Default Then Return DllCall($g_hLibDissociableMatch, $ReturnType, $sFunc, $sType1, $vParam1, $sType2, $vParam2, $sType3, $vParam3, $sType4, $vParam4, $sType5, $vParam5, $sType6, $vParam6, $sType7, $vParam7)
	If $sType6 <> Default Then Return DllCall($g_hLibDissociableMatch, $ReturnType, $sFunc, $sType1, $vParam1, $sType2, $vParam2, $sType3, $vParam3, $sType4, $vParam4, $sType5, $vParam5, $sType6, $vParam6)
	If $sType5 <> Default Then Return DllCall($g_hLibDissociableMatch, $ReturnType, $sFunc, $sType1, $vParam1, $sType2, $vParam2, $sType3, $vParam3, $sType4, $vParam4, $sType5, $vParam5)
	If $sType4 <> Default Then Return DllCall($g_hLibDissociableMatch, $ReturnType, $sFunc, $sType1, $vParam1, $sType2, $vParam2, $sType3, $vParam3, $sType4, $vParam4)
	If $sType3 <> Default Then Return DllCall($g_hLibDissociableMatch, $ReturnType, $sFunc, $sType1, $vParam1, $sType2, $vParam2, $sType3, $vParam3)
	If $sType2 <> Default Then Return DllCall($g_hLibDissociableMatch, $ReturnType, $sFunc, $sType1, $vParam1, $sType2, $vParam2)
	If $sType1 <> Default Then Return DllCall($g_hLibDissociableMatch, $ReturnType, $sFunc, $sType1, $vParam1)
	SetLog("DMatch Dll Call: Unknown Match/Parameters ?!", $COLOR_ERROR)
    Return -1
EndFunc

Func DllCallDOCR($sFunc, $ReturnType, $sType1 = Default, $vParam1 = Default, $sType2 = Default, $vParam2 = Default)
	; SetLog("DOCR: sFunc: " & $sFunc & " - Return Type: " & $ReturnType & " - sType1: " & $sType1 & " - vParam1: " & $vParam1 & " - sType2: " & $sType2 & " - vParam2: " & $vParam2)
	; suspend Android now

	Local $bWasSuspended = SuspendAndroid()
	Local $aResult
	$aResult = DllCall($g_hLibDissociableOcr, $ReturnType, $sFunc, $sType1, $vParam1, $sType2, $vParam2)
	If @error Then
		SetLog("DOCR Issue | Fail 0x0: " & @error)

		Sleep(20)

		$aResult = DllCall($g_hLibDissociableOcr, $ReturnType, $sFunc, $sType1, $vParam1, $sType2, $vParam2)
		If @error Then
			SetLog("DOCR Issue | Fail 0x1: " & @error)
			; resume Android again (if it was not already suspended)
			SuspendAndroid($bWasSuspended)
			Return ""
		EndIf
	EndIf


	If IsArray($aResult) Then
		If StringInStr($aResult[0], "ERROR") > 0 Then
			SetLog("DOCR Issue | Fail 0x2. | " & $aResult[0], $COLOR_ERROR)
			; resume Android again (if it was not already suspended)
			SuspendAndroid($bWasSuspended)
			Return ""
		EndIf
		; resume Android again (if it was not already suspended)
		SuspendAndroid($bWasSuspended)

		Return $aResult[0]
	EndIf

	SetLog("DOCR Issue: Unknown DllCallDOCR Return: " & $aResult)
	; resume Android again (if it was not already suspended)
	SuspendAndroid($bWasSuspended)
	Return ""
EndFunc   ;==>DllCallDOCR

#cs
Func _DllCallDOCR($sFunc, $ReturnType, $sType1 = Default, $vParam1 = Default, $sType2 = Default, $vParam2 = Default)
    If $sType1 = Default Then Return DllCall($g_hLibDissociableOcr, $ReturnType, $sFunc)
    If $sType2 <> Default Then Return DllCall($g_hLibDissociableOcr, $ReturnType, $sFunc, $sType1, $vParam1, $sType2, $vParam2)
    If $sType1 <> Default Then Return DllCall($g_hLibDissociableOcr, $ReturnType, $sFunc, $sType1, $vParam1)
    Return -1
EndFunc
#ce
