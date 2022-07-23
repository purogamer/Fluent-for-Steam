; #FUNCTION# ====================================================================================================================
; Name ..........: QuickMIS
; Description ...: A function to easily use ImgLoc, without headache :P !!!
; Syntax ........: ---
; Parameters ....: ---
; Return values .: ---
; Author ........: RoroTiti
; Modified ......: Demen (2018), Team AIO Mod++ (2021)
; Remarks .......: This file is part of MyBotRun. Copyright 2017
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......: ---
; Link ..........: https://www.mybot.run
; Example .......: ---
;================================================================================================================================
Func QuickMIS($ValueReturned, $directory, $left = 0, $top = 0, $right = $g_iGAME_WIDTH, $bottom = $g_iGAME_HEIGHT, $bNeedCapture = True, $debug = False, $OcrDecode = 3, $OcrSpace = 12, $bOcrStripSpaces = False)
	If ($ValueReturned <> "CXR") And ($ValueReturned <> "CNX") And ($ValueReturned <> "BC1") And ($ValueReturned <> "CX") And ($ValueReturned <> "N1") And ($ValueReturned <> "NX") And ($ValueReturned <> "Q1") And ($ValueReturned <> "QX") And ($ValueReturned <> "NxCx") And ($ValueReturned <> "N1Cx1") And ($ValueReturned <> "OCR") Then
		SetLog("Bad parameters during QuickMIS call for MultiSearch...", $COLOR_RED)
		Return
	EndIf
	Local $aSize = DirGetSize($directory, $DIR_EXTENDED)
	If @error Then
		If StringInStr($directory, "bundle") = 0 Then SetLog("Directory Path error: " & @error & " | " & $directory, $COLOR_ERROR)
	ElseIf $aSize[1] = 0 Then
		SetLog("Directory Path is empty: " & $directory, $COLOR_ERROR)
	ElseIf $aSize[1] > 0 Then
		SetDebugLog("Path Dir with " & $aSize[1] & " Images")
	EndIf
	If $bNeedCapture Then _CaptureRegion2($left, $top, $right, $bottom)
	Local $res = DllCallMyBot("SearchMultipleTilesBetweenLevels", "handle", $g_hHBitmap2, "str", $directory, "str", "FV", "Int", 0, "str", "FV", "Int", 0, "Int", 1000)
	If @error Then _logErrorDLLCall($g_sLibMyBotPath, @error)
	If $g_bDebugImageSave Then SaveDebugImage("QuickMIS_" & $ValueReturned, False)
	If IsArray($res) Then
		SetDebugLog("DLL Call succeeded " & $res[0], $COLOR_PURPLE)
		If $res[0] = "" Or $res[0] = "0" Then
			SetDebugLog("No QuickMIS [" & $ValueReturned & "] detection found!")
			SetDebugLog("Dir: " & $directory)
			Switch $ValueReturned
				Case "BC1"
					Return False
				Case "CX"
					Return -1
				Case "CXR"
					Return -1
				Case "CNX"
					Return -1
				Case "N1"
					Return "none"
				Case "NX"
					Return "none"
				Case "Q1"
					Return 0
				Case "QX"
					Return 0
				Case "N1Cx1"
					Return 0
				Case "NxCx"
					Return 0
				Case "OCR"
					Return "none"
			EndSwitch
		ElseIf StringInStr($res[0], "-1") <> 0 Then
			SetLog("DLL Error", $COLOR_RED)
		Else
			Local $DLLRes = 0
			Switch $ValueReturned
				Case "BC1" ; coordinates of first/one image found + boolean value
					Local $result = "", $Name = ""
					Local $KeyValue = StringSplit($res[0], "|", $STR_NOCOUNT + $STR_ENTIRESPLIT)
					For $i = 0 To UBound($KeyValue) - 1
						$DLLRes = DllCallMyBot("GetProperty", "str", $KeyValue[$i], "str", "objectpoints")
						If UBound(decodeSingleCoord($DLLRes[0])) > 1 Then $result &= $DLLRes[0] & "|"
					Next
					If StringRight($result, 1) = "|" Then $result = StringLeft($result, (StringLen($result) - 1))
					Local $aCords = decodeMultipleCoords($result, 60, 10, 1)
					If UBound($aCords) = 0 Then Return False
					Local $aCord = $aCords[0]
					If UBound($aCord) < 2 Then Return False
					$g_iQuickMISX = $aCord[0] + $left
					$g_iQuickMISY = $aCord[1] + $top
					$Name = RetrieveImglocProperty($KeyValue[0], "objectname")
					$g_iQuickMISName = $Name
					If $g_bDebugSetlog Or $debug Then
						SetDebugLog($ValueReturned & " Found: " & $result & ", using " & $g_iQuickMISX & "," & $g_iQuickMISY, $COLOR_PURPLE)
						If $g_bDebugImageSave Then DebugQuickMIS($left, $top, "BC1_detected[" & $Name & "_" & $g_iQuickMISX & "x" & $g_iQuickMISY & "]")
					EndIf
					Return True
					
				Case "CX" ; coordinates of each image found - eg: $Array[0] = [X1, Y1] ; $Array[1] = [X2, Y2]
					Local $result = ""
					Local $KeyValue = StringSplit($res[0], "|", $STR_NOCOUNT + $STR_ENTIRESPLIT)
					For $i = 0 To UBound($KeyValue) - 1
						$DLLRes = DllCallMyBot("GetProperty", "str", $KeyValue[$i], "str", "objectpoints")
						If UBound(decodeSingleCoord($DLLRes[0])) > 1 Then $result &= $DLLRes[0] & "|"
					Next
					If StringRight($result, 1) = "|" Then $result = StringLeft($result, (StringLen($result) - 1))
					SetDebugLog($ValueReturned & " Found: " & $result, $COLOR_PURPLE)
					Local $CoordsInArray = StringSplit($result, "|", $STR_NOCOUNT + $STR_ENTIRESPLIT)
					Return $CoordsInArray
					
				Case "N1" ; name of first file found
					Local $MultiImageSearchResult = StringSplit($res[0], "|")
					Local $FilenameFound = StringSplit($MultiImageSearchResult[1], "_")
					Return $FilenameFound[1]
					
				Case "NX" ; names of all files found
					Local $AllFilenamesFound = ""
					Local $MultiImageSearchResult = StringSplit($res[0], "|")
					For $i = 1 To $MultiImageSearchResult[0]
						Local $FilenameFound = StringSplit($MultiImageSearchResult[$i], "_")
						$AllFilenamesFound &= $FilenameFound[1] & "|"
					Next
					If StringRight($AllFilenamesFound, 1) = "|" Then $AllFilenamesFound = StringLeft($AllFilenamesFound, (StringLen($AllFilenamesFound) - 1))
					Return $AllFilenamesFound
					
				Case "Q1" ; quantity of first/one tiles found
					Local $result = ""
					Local $KeyValue = StringSplit($res[0], "|", $STR_NOCOUNT + $STR_ENTIRESPLIT)
					For $i = 0 To UBound($KeyValue) - 1
						$DLLRes = DllCallMyBot("GetProperty", "str", $KeyValue[$i], "str", "totalobjects")
						$result &= $DLLRes[0] & "|"
					Next
					If StringRight($result, 1) = "|" Then $result = StringLeft($result, (StringLen($result) - 1))
					SetDebugLog($ValueReturned & " Found: " & $result, $COLOR_PURPLE)
					Local $QuantityInArray = StringSplit($result, "|", $STR_NOCOUNT + $STR_ENTIRESPLIT)
					Return $QuantityInArray[0]
					
				Case "QX" ; quantity of files found
					Local $MultiImageSearchResult = StringSplit($res[0], "|", $STR_NOCOUNT + $STR_ENTIRESPLIT)
					Return UBound($MultiImageSearchResult)
					
				Case "CXR" ; coordinates of each image found - eg: $Array[0] = [X1, Y1] ; $Array[1] = [X2, Y2]

					Local $Result[0][2]
					Local $KeyValue = StringSplit($Res[0], "|", $STR_NOCOUNT)
					For $i = 0 To UBound($KeyValue) - 1
						Local $DLLRes = DllCallMyBot("GetProperty", "str", $KeyValue[$i], "str", "objectpoints")
						Local $xy = StringSplit($DLLRes[0], "|", $STR_NOCOUNT)
						For $j = 0 To Ubound($xy) - 1
							If UBound(decodeSingleCoord($xy[$j])) > 1 Then 
								Local $Tmpxy = StringSplit($xy[$j], ",", $STR_NOCOUNT)
								_ArrayAdd($Result, $Tmpxy[0] + $Left & "|" & $Tmpxy[1] + $Top)
							EndIf
						Next
					Next
					If $g_bDebugSetlog Then SetDebugLog($ValueReturned & " Found: " & _ArrayToString($Result), $COLOR_PURPLE)
					Return $Result
					
				Case "CNX" 
					Local $Result[0][4]
					Local $KeyValue = StringSplit($Res[0], "|", $STR_NOCOUNT)
					For $i = 0 To UBound($KeyValue) - 1
						Local $DLLRes = DllCallMyBot("GetProperty", "str", $KeyValue[$i], "str", "objectpoints")
						Local $objName = StringSplit($KeyValue[$i], "_", $STR_NOCOUNT)
						Local $xy = StringSplit($DLLRes[0], "|", $STR_NOCOUNT)
						;SetDebugLog(_ArrayToString($xy))
						For $j = 0 To Ubound($xy) - 1
							If UBound(decodeSingleCoord($xy[$j])) > 1 Then 
								Local $Tmpxy = StringSplit($xy[$j], ",", $STR_NOCOUNT)
								_ArrayAdd($Result, $objName[0] & "|" & $Tmpxy[0] + $Left & "|" & $Tmpxy[1] + $Top & "|" & $objName[1])
							EndIf
						Next
					Next
					If $g_bDebugSetlog Then SetDebugLog($ValueReturned & " Found: " & _ArrayToString($Result), $COLOR_PURPLE)
					Return $Result

				Case "N1Cx1"
					Local $NameAndCords[2]
					Local $result = "", $Name = ""
					Local $KeyValue = StringSplit($res[0], "|", $STR_NOCOUNT + $STR_ENTIRESPLIT)
					For $i = 0 To UBound($KeyValue) - 1
						$DLLRes = DllCallMyBot("GetProperty", "str", $KeyValue[$i], "str", "objectpoints")
						If UBound(decodeSingleCoord($DLLRes[0])) > 1 Then $result &= $DLLRes[0] & "|"
					Next
					If StringRight($result, 1) = "|" Then $result = StringLeft($result, (StringLen($result) - 1))
					Local $aCords = decodeMultipleCoords($result, 60, 10, 1)
					If UBound($aCords) = 0 Then Return 0
					Local $aCord = $aCords[0]
					If UBound($aCord) < 2 Then Return 0
					$aCord[0] = $aCord[0] + $left
					$aCord[1] = $aCord[1] + $top
					$Name = RetrieveImglocProperty($KeyValue[0], "objectname")
					$NameAndCords[0] = $Name
					$NameAndCords[1] = $aCord
					If $g_bDebugSetlog Or $debug Then
						SetDebugLog($ValueReturned & " Found: " & $Name & ", using " & $aCord[0] & "," & $aCord[1], $COLOR_PURPLE)
					EndIf
					Return $NameAndCords
					
				Case "NxCx"
					Local $KeyValue = StringSplit($res[0], "|", $STR_NOCOUNT + $STR_ENTIRESPLIT)
					Local $Name = ""
					Local $aPositions, $aCoords, $aCord, $level
					SetDebugLog("Detected : " & UBound($KeyValue) & " tiles")
					Local $AllFilenamesFound[UBound($KeyValue)][3]
					For $i = 0 To UBound($KeyValue) - 1
						$Name = RetrieveImglocProperty($KeyValue[$i], "objectname")
						$aPositions = RetrieveImglocProperty($KeyValue[$i], "objectpoints")
						$level = RetrieveImglocProperty($KeyValue[$i], "objectlevel")
						SetDebugLog("Name: " & $Name)
						$aCoords = decodeMultipleCoords($aPositions, 20, 10, 0)
						SetDebugLog("How many $aCoords: " & UBound($aCoords))
						$AllFilenamesFound[$i][0] = $Name
						$AllFilenamesFound[$i][1] = $aCoords
						$AllFilenamesFound[$i][2] = $level
					Next
					Return $AllFilenamesFound
					
				Case "OCR"
					Local $sOCRString = ""
					Local $aResults[1][2] = [[-1, ""]]
					Local $KeyValue = StringSplit($res[0], "|", $STR_NOCOUNT + $STR_ENTIRESPLIT)
					For $i = 0 To UBound($KeyValue) - 1
						$DLLRes = DllCallMyBot("GetProperty", "str", $KeyValue[$i], "str", "objectpoints")
						Local $Name = RetrieveImglocProperty($KeyValue[$i], "objectname")
						Local $aCoords = StringSplit($DLLRes[0], "|", $STR_NOCOUNT + $STR_ENTIRESPLIT)
						For $j = 0 To UBound($aCoords) - 1
							Local $aXY = StringSplit($aCoords[$j], ",", $STR_NOCOUNT + $STR_ENTIRESPLIT)
							ReDim $aResults[UBound($aResults) + 1][2]
							$aResults[UBound($aResults) - 2][0] = Number($aXY[0])
							$aResults[UBound($aResults) - 2][1] = $Name
						Next
					Next
					_ArrayDelete($aResults, UBound($aResults) - 1)
					_ArraySort($aResults)
					For $i = 0 To UBound($aResults) - 1
						SetDebugLog($i & ". $Name = " & $aResults[$i][1] & ", Coord = " & $aResults[$i][0])
						If $i >= 1 Then
							If $aResults[$i][1] = $aResults[$i - 1][1] And Abs($aResults[$i][0] - $aResults[$i - 1][0]) <= $OcrDecode Then ContinueLoop
							If Abs($aResults[$i][0] - $aResults[$i - 1][0]) > $OcrSpace Then $sOCRString &= " "
						EndIf
						$sOCRString &= $aResults[$i][1]
					Next
					SetDebugLog("QuickMIS " & $ValueReturned & ", $sOCRString: " & $sOCRString)

					If $bOcrStripSpaces = True Then
						$sOCRString = StringStripWS($sOCRString, $STR_STRIPALL)
					EndIf

					Return $sOCRString
			EndSwitch
		EndIf
	EndIf
EndFunc   ;==>QuickMIS

Func DebugQuickMIS($x, $y, $DebugText)
	_CaptureRegion2()
	Local $subDirectory = $g_sProfileTempDebugPath & "QuickMIS"
	DirCreate($subDirectory)
	Local $date = @YEAR & "-" & @MON & "-" & @MDAY
	Local $Time = @HOUR & "." & @MIN & "." & @SEC
	Local $Filename = String($date & "_" & $Time & "_" & $DebugText & "_.png")
	Local $EditedImage = _GDIPlus_BitmapCreateFromHBITMAP($g_hHBitmap2)
	Local $hGraphic = _GDIPlus_ImageGetGraphicsContext($EditedImage)
	Local $hPenRed = _GDIPlus_PenCreate(0xFFFF0000, 3)
	_GDIPlus_GraphicsDrawRect($hGraphic, $g_iQuickMISX - 5 + $x, $g_iQuickMISY - 5 + $y, 10, 10, $hPenRed)
	_GDIPlus_ImageSaveToFile($EditedImage, $subDirectory & "\" & $Filename)
	_GDIPlus_PenDispose($hPenRed)
	_GDIPlus_GraphicsDispose($hGraphic)
	_GDIPlus_BitmapDispose($EditedImage)
EndFunc   ;==>DebugQuickMIS