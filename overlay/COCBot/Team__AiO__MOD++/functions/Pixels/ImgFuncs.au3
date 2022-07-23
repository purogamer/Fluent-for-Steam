; #FUNCTION# ====================================================================================================================
; Name ..........: ImgFuncs.au3
; Description ...: Versatile and easy to understand function for capturing images.
; Author ........: Boldina ! (2020)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2020
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Global $g_aImageSearchXML = - 1

Func _ImageSearchXML($sDirectory, $iQuantityMatch = 0, $vArea2SearchOri = Default, $vForceCaptureOrPtr = True, $bDebugLog = False, $bCheckDuplicatedpoints = False, $iDistance2check = 25, $minLevel = 0, $maxLevel = 1000)

	$g_aImageSearchXML = -1
	Local $iCount = 0, $returnProps = "objectname,objectlevel,objectpoints"
	Local $error, $extError
	
	Local $bIsPtr = 0
	If $vForceCaptureOrPtr = Default Then $vForceCaptureOrPtr = True
	If $vForceCaptureOrPtr = True Then
		_CaptureRegion2() ;to have FULL screen image to work with
	Else
		$bIsPtr = StringLeft($vForceCaptureOrPtr, 2) = "0x"
	EndIf

	If $vArea2SearchOri = Default Then
		$vArea2SearchOri = "FV"
	Else
		If IsArray($vArea2SearchOri) Then
			$vArea2SearchOri = GetDiamondFromArray($vArea2SearchOri)
		ElseIf StringInStr($vArea2SearchOri, "|") = 0 And StringInStr($vArea2SearchOri, ",") > 0 Then
			$vArea2SearchOri = GetDiamondFromRect($vArea2SearchOri)
		EndIf
	EndIf
	
	Local $aCoords = "" ; use AutoIt mixed variable type and initialize array of coordinates to null
	Local $returnData = StringSplit($returnProps, ",", $STR_NOCOUNT + $STR_ENTIRESPLIT)
	Local $returnLine[UBound($returnData)]
	Local $result = DllCallMyBot("SearchMultipleTilesBetweenLevels", "handle", ($bIsPtr = 0) ? ($g_hHBitmap2) : ($vForceCaptureOrPtr), "str", $sDirectory, "str", $vArea2SearchOri, "Int", $iQuantityMatch, "str", $vArea2SearchOri, "Int", $minLevel, "Int", $maxLevel)
	$error = @error ; Store error values as they reset at next function call
	$extError = @extended
	If $error Then
		_logErrorDLLCall($g_sLibMyBotPath, $error)
		SetDebugLog(" imgloc DLL Error : " & $error & " --- " & $extError)
		SetError(2, $extError, $aCoords) ; Set external error code = 2 for DLL error
		Return -1
	EndIf

	If checkImglocError($result, "_ImageSearchXML", $sDirectory) = True Then
		SetDebugLog("_ImageSearchXML Returned Error or No values : ", $COLOR_DEBUG)
		Return -1
	EndIf

	Local $resultArr = StringSplit($result[0], "|", $STR_NOCOUNT + $STR_ENTIRESPLIT)
	SetDebugLog(" ***  _ImageSearchXML multiples **** ", $COLOR_ACTION)

	; Distance in pixels to check if is a duplicated detection , for deploy point will be 5
	Local $iD2C = ($bCheckDuplicatedpoints = True) ? ($iDistance2check) : (0)
	Local $aAR[0][4], $aXY
	For $rs = 0 To UBound($resultArr) - 1
		For $rD = 0 To UBound($returnData) - 1 ; cycle props
			$returnLine[$rD] = RetrieveImglocProperty($resultArr[$rs], $returnData[$rD])
			If $returnData[$rD] = "objectpoints" Then
				; Inspired in Chilly-chill
				Local $aC = StringSplit($returnLine[2], "|", $STR_NOCOUNT + $STR_ENTIRESPLIT)
				For $i = 0 To UBound($aC) - 1
					$aXY = StringSplit($aC[$i], ",", $STR_NOCOUNT + $STR_ENTIRESPLIT)
					If UBound($aXY) <> 2 Then ContinueLoop 3
					If $iD2C > 0 Then
						If DMduplicated($aAR, Int($aXY[0]), Int($aXY[1]), UBound($aAR)-1, $iD2C) Then
							ContinueLoop
						EndIf
					EndIf
					ReDim $aAR[$iCount + 1][4]
					$aAR[$iCount][0] = $returnLine[0]
					$aAR[$iCount][1] = Int($aXY[0])
					$aAR[$iCount][2] = Int($aXY[1])
					$aAR[$iCount][3] = Int($returnLine[1])
					$iCount += 1
					If $iCount >= $iQuantityMatch And $iQuantityMatch > 0 Then ExitLoop 3
				Next
			EndIf
		Next
	Next
	
	$g_aImageSearchXML = $aAR
	If UBound($aAR) < 1 Then 
		$g_aImageSearchXML = -1
		Return -1
	EndIf

	If $bDebugLog Then DebugImgArrayClassic($aAR, "_ImageSearchXML")
	Return $aAR
EndFunc   ;==>_ImageSearchXML

Func findMultipleQuick($sDirectory, $iQuantityMatch = Default, $vArea2SearchOri = Default, $vForceCaptureOrPtr = True, $sOnlyFind = "", $bExactFind = False, $iDistance2check = 25, $bDebugLog = $g_bDebugImageSave, $minLevel = 0, $maxLevel = 1000, $vArea2SearchOri2 = Default)

	$g_aImageSearchXML = -1
	Local $iCount = 0, $returnProps = "objectname,objectlevel,objectpoints"
	
	Local $bIsPtr = 0
	If $vForceCaptureOrPtr = Default Then $vForceCaptureOrPtr = True
	If $vForceCaptureOrPtr = True Then
		_CaptureRegion2() ;to have FULL screen image to work with
	Else
		$bIsPtr = StringLeft($vForceCaptureOrPtr, 2) = "0x"
	EndIf
	
	If $iQuantityMatch = Default Then $iQuantityMatch = 0
	If $sOnlyFind = Default Then $sOnlyFind = ""
	Local $bOnlyFindIsSpace = StringIsSpace($sOnlyFind)

	If $vArea2SearchOri = Default Then
		$vArea2SearchOri = "FV"
	Else
		If IsArray($vArea2SearchOri) Then
			$vArea2SearchOri = GetDiamondFromArray($vArea2SearchOri)
		ElseIf StringInStr($vArea2SearchOri, "|") = 0 And StringInStr($vArea2SearchOri, ",") > 0 Then
			$vArea2SearchOri = GetDiamondFromRect($vArea2SearchOri)
		EndIf
	EndIf
		
	If $vArea2SearchOri2 = Default Then 
		$vArea2SearchOri2 = $vArea2SearchOri
	Else
		If IsArray($vArea2SearchOri2) Then
			$vArea2SearchOri2 = GetDiamondFromArray($vArea2SearchOri2)
		ElseIf StringInStr($vArea2SearchOri2, "|") = 0 And StringInStr($vArea2SearchOri2, ",") > 0 Then
			$vArea2SearchOri2 = GetDiamondFromRect($vArea2SearchOri2)
		EndIf
	EndIf
	
	Local $iQuantToMach = ($bOnlyFindIsSpace = True) ? ($iQuantityMatch) : (0)
	If IsDir($sDirectory) = False Then
		$sOnlyFind = StringRegExpReplace($sDirectory, "^.*\\|\..*$", "")
		If StringRight($sOnlyFind, 1) = "*" Then 
			$sOnlyFind = StringTrimRight($sOnlyFind, 1)
		EndIf
		Local $aTring = StringSplit($sOnlyFind, "_", $STR_NOCOUNT + $STR_ENTIRESPLIT)
		If Not @error Then 
			$sOnlyFind = $aTring[0]
		EndIf
		$bExactFind = False
		$sDirectory = StringRegExpReplace($sDirectory, "(^.*\\)(.*)", "\1")
		$iQuantToMach = 0
	EndIf

	
	Local $aCoords = "" ; use AutoIt mixed variable type and initialize array of coordinates to null
	Local $returnData = StringSplit($returnProps, ",", $STR_NOCOUNT + $STR_ENTIRESPLIT)
	Local $returnLine[UBound($returnData)]

	Local $error, $extError
	Local $result = DllCallMyBot("SearchMultipleTilesBetweenLevels", "handle", ($bIsPtr = 0) ? ($g_hHBitmap2) : ($vForceCaptureOrPtr), "str", $sDirectory, "str", $vArea2SearchOri, "Int", $iQuantToMach, "str", $vArea2SearchOri2, "Int", $minLevel, "Int", $maxLevel)
	$error = @error ; Store error values as they reset at next function call
	$extError = @extended
	If $error Then
		_logErrorDLLCall($g_sLibMyBotPath, $error)
		SetDebugLog(" imgloc DLL Error : " & $error & " --- " & $extError)
		SetError(2, $extError, $aCoords) ; Set external error code = 2 for DLL error
		Return -1
	EndIf

	If checkImglocError($result, "findMultipleQuick", $sDirectory) = True Then
		SetDebugLog("findMultipleQuick Returned Error or No values : ", $COLOR_DEBUG)
		Return -1
	EndIf

	Local $resultArr = StringSplit($result[0], "|", $STR_NOCOUNT + $STR_ENTIRESPLIT), $sSlipt = StringSplit($sOnlyFind, "|", $STR_NOCOUNT + $STR_ENTIRESPLIT)
	;_arraydisplay($resultArr)
	SetDebugLog(" ***  findMultipleQuick multiples **** ", $COLOR_ACTION)
	If CompKick($resultArr, $sSlipt, $bExactFind) Then
		SetDebugLog(" ***  findMultipleQuick has no result **** ", $COLOR_ACTION)
		Return -1
	EndIf

	Local $iD2C = $iDistance2check
	Local $aAR[0][4], $aXY
	For $rs = 0 To UBound($resultArr) - 1
		For $rD = 0 To UBound($returnData) - 1 ; cycle props
			$returnLine[$rD] = RetrieveImglocProperty($resultArr[$rs], $returnData[$rD])
			If $returnData[$rD] = "objectpoints" Then
				Local $aC = StringSplit($returnLine[2], "|", $STR_NOCOUNT + $STR_ENTIRESPLIT)
				For $i = 0 To UBound($aC) - 1
					$aXY = StringSplit($aC[$i], ",", $STR_NOCOUNT + $STR_ENTIRESPLIT)
					If UBound($aXY) <> 2 Then ContinueLoop 3
					If $iD2C > 0 Then
						If DMduplicated($aAR, Int($aXY[0]), Int($aXY[1]), UBound($aAR)-1, $iD2C) Then
							ContinueLoop
						EndIf
					EndIf
					ReDim $aAR[$iCount + 1][4]
					$aAR[$iCount][0] = $returnLine[0]
					$aAR[$iCount][1] = Int($aXY[0])
					$aAR[$iCount][2] = Int($aXY[1])
					$aAR[$iCount][3] = Int($returnLine[1])
					$iCount += 1
					If $iCount >= $iQuantityMatch And $iQuantityMatch > 0 Then ExitLoop 3
				Next
			EndIf
		Next
	Next
	
	$g_aImageSearchXML = $aAR
	If UBound($aAR) < 1 Then 
		$g_aImageSearchXML = -1
		Return -1
	EndIf
	
	If $bDebugLog Then DebugImgArrayClassic($aAR, "findMultipleQuick")
	
	Return $aAR
EndFunc   ;==>findMultipleQuick

Func CompKick(ByRef $vFiles, $aof, $bType = False)
	If (UBound($aof) = 1) And StringIsSpace($aof[0]) Then Return False
	If $g_bDebugSetlog Then
		SetDebugLog("CompKick : " & _ArrayToString($vFiles))
		SetDebugLog("CompKick : " & _ArrayToString($aof))
		SetDebugLog("CompKick : " & "Exact mode : " & $bType)
	EndIf
	If ($bType = Default) Then $bType = False

	Local $aRS[0]

	If IsArray($vFiles) And IsArray($aof) Then
		SetDebugLog("CompKick compare : " & _ArrayToString($vFiles))
		If $bType Then
			For $s In $aof
				For $s2 In $vFiles
					Local $i2s = StringInStr($s2, "_") - 1
					If StringInStr(StringMid($s2, 1, $i2s), $s, 0) = 1 And $i2s = StringLen($s) Then _ArrayAdd($aRS, $s2)
				Next
			Next
		Else
			For $s In $aof
				For $s2 In $vFiles
					Local $i2s = StringInStr($s2, "_") - 1
					If StringInStr(StringMid($s2, 1, $i2s), $s) > 0 Then _ArrayAdd($aRS, $s2)
				Next
			Next
		EndIf
	EndIf
	$vFiles = $aRS
	Return (UBound($vFiles) = 0)
EndFunc   ;==>CompKick