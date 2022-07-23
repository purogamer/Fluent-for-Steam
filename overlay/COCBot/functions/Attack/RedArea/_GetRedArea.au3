; #FUNCTION# ====================================================================================================================
; Name ..........: _GetRedArea
; Description ...:  See strategy below
; Syntax ........: _GetRedArea()
; Parameters ....:
; Return values .: None
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
; Strategy :
; 			Search red area
;			Split the result in 4 sides (global var) : Top Left / Bottom Left / Top Right / Bottom Right
;			Remove bad pixel (Suppose that pixel to deploy are in the green area)
;			Get pixel next the "out zone" , indeed the red color is very different and more uncertain
;			Sort each sides
;			Add each sides in one array (not use, but it can help to get closer pixel of all the red area)

Func _GetRedArea($iMode = $REDLINE_IMGLOC, $iMaxAllowedPixelDistance = 25, $fMinSideLengthFactor = 0.65)
	Local $nameFunc = "[_GetRedArea] "
	debugRedArea($nameFunc & " IN")

	Local $colorVariation = 40
	Local $xSkip = 1
	Local $ySkip = 5
	Local $result = 0
	Local $listPixelBySide

	; If $g_iMatchMode = $LB And $g_aiAttackAlgorithm[$LB] = 0 And $g_aiAttackStdDropSides[$LB] = 4 Then ; Used for DES Side Attack (need to know the side the DES is on)
		; $result = DllCallMyBot("getRedAreaSideBuilding", "ptr", $g_hHBitmap2, "int", $xSkip, "int", $ySkip, "int", $colorVariation, "int", $eSideBuildingDES)
		; SetDebugLog("Debug: Redline with DES Side chosen")
	; ElseIf $g_iMatchMode = $LB And $g_aiAttackAlgorithm[$LB] = 0 And $g_aiAttackStdDropSides[$LB] = 5 Then ; Used for TH Side Attack (need to know the side the TH is on)
		; $result = DllCallMyBot("getRedAreaSideBuilding", "ptr", $g_hHBitmap2, "int", $xSkip, "int", $ySkip, "int", $colorVariation, "int", $eSideBuildingTH)
		; SetDebugLog("Debug: Redline with TH Side chosen")
	; Else ; Normal getRedArea

		Switch $iMode
			Case $REDLINE_NONE ; No red line
				Local $a = ["NoRedLine", "", "", "", ""]
				$listPixelBySide = $a
			Case $REDLINE_IMGLOC_RAW ; ImgLoc raw red line routine
				; ensure redline exists
				SearchRedLinesMultipleTimes()
				$listPixelBySide = getRedAreaSideBuilding()
			Case $REDLINE_IMGLOC ; New ImgLoc based deployable red line routine
				; ensure redline exists
				SearchRedLinesMultipleTimes()
				Local $dropPoints = GetOffSetRedline("TL") & "|" & GetOffSetRedline("BL") & "|" & GetOffSetRedline("BR") & "|" & GetOffSetRedline("TR")
				$listPixelBySide = getRedAreaSideBuilding($dropPoints)
				#cs
					$g_aiPixelTopLeft = _SortRedline(GetOffSetRedline("TL"))
					$g_aiPixelBottomLeft =  _SortRedline(GetOffSetRedline("BL"))
					$g_aiPixelBottomRight = _SortRedline(GetOffSetRedline("BR"))
					$g_aiPixelTopRight =  _SortRedline(GetOffSetRedline("TR"))
					Local $listPixelBySide = ["ImgLoc", $g_aiPixelTopLeft, $g_aiPixelBottomLeft, $g_aiPixelBottomRight, $g_aiPixelTopRight]
				#ce
			Case $REDLINE_ORIGINAL ; Original red line routine
				Local $result = DllCallMyBot("getRedArea", "ptr", $g_hHBitmap2, "int", $xSkip, "int", $ySkip, "int", $colorVariation)
		EndSwitch
		SetDebugLog("Debug: Redline chosen")
	; EndIf

	If IsArray($result) Then
		$listPixelBySide = StringSplit($result[0], "#")
	EndIf
	$g_aiPixelTopLeft = GetPixelSide($listPixelBySide, 1)
	$g_aiPixelBottomLeft = GetPixelSide($listPixelBySide, 2)
	$g_aiPixelBottomRight = GetPixelSide($listPixelBySide, 3)
	$g_aiPixelTopRight = GetPixelSide($listPixelBySide, 4)

	;02.02  - CLEAN REDAREA BAD POINTS -----------------------------------------------------------------------------------------------------------------------
	CleanRedArea($g_aiPixelTopLeft)
	CleanRedArea($g_aiPixelTopRight)
	CleanRedArea($g_aiPixelBottomLeft)
	CleanRedArea($g_aiPixelBottomRight)
	debugAttackCSV("RedArea cleaned")
	debugAttackCSV("	[" & UBound($g_aiPixelTopLeft) & "] pixels TopLeft")
	debugAttackCSV("	[" & UBound($g_aiPixelTopRight) & "] pixels TopRight")
	debugAttackCSV("	[" & UBound($g_aiPixelBottomLeft) & "] pixels BottomLeft")
	debugAttackCSV("	[" & UBound($g_aiPixelBottomRight) & "] pixels BottomRight")
	If _Sleep($DELAYRESPOND) Then Return

	;02.03 - MAKE FULL DROP LINE EDGE--------------------------------------------------------------------------------------------------------------------------
	; default inner area edges
	Local $coordLeft = [$ExternalArea[0][0], $ExternalArea[0][1]]
	Local $coordTop = [$ExternalArea[2][0], $ExternalArea[2][1]]
	Local $coordRight = [$ExternalArea[1][0], $ExternalArea[1][1]]
	Local $coordBottom = [$ExternalArea[3][0], $ExternalArea[3][1]]
	Switch $g_aiAttackScrDroplineEdge[$g_iMatchMode]
		Case $DROPLINE_EDGE_FIXED, $DROPLINE_FULL_EDGE_FIXED ; default inner area edges
			; nothing to do here
		Case $DROPLINE_EDGE_FIRST, $DROPLINE_FULL_EDGE_FIRST ; use first red point
			Local $newAxis
			; left
			Local $aPoint1 = GetMaxPoint($g_aiPixelTopLeft, 1)
			Local $aPoint2 = GetMinPoint($g_aiPixelBottomLeft, 1)
			$newAxis = (($aPoint1[0] < $aPoint2[0]) ? ($aPoint1[0]) : ($aPoint2[0]))
			If Abs($newAxis) < 9999 Then $coordLeft[0] = $newAxis
			; top
			Local $aPoint1 = GetMaxPoint($g_aiPixelTopLeft, 0)
			Local $aPoint2 = GetMinPoint($g_aiPixelTopRight, 0)
			$newAxis = (($aPoint1[1] < $aPoint2[1]) ? ($aPoint1[1]) : ($aPoint2[1]))
			If Abs($newAxis) < 9999 Then $coordTop[1] = $newAxis
			; right

			Local $aPoint1 = GetMaxPoint($g_aiPixelTopRight, 1)
			Local $aPoint2 = GetMinPoint($g_aiPixelBottomRight, 1)
			$newAxis = (($aPoint1[0] > $aPoint2[0]) ? ($aPoint1[0]) : ($aPoint2[0]))
			If Abs($newAxis) < 9999 Then $coordRight[0] = $newAxis
			; bottom
			Local $aPoint1 = GetMaxPoint($g_aiPixelBottomLeft, 0)
			Local $aPoint2 = GetMinPoint($g_aiPixelBottomRight, 0)
			$newAxis = (($aPoint1[1] > $aPoint2[1]) ? ($aPoint1[1]) : ($aPoint2[1]))
			If Abs($newAxis) < 9999 Then $coordBottom[1] = $newAxis
	EndSwitch

	Local $StartEndTopLeft = [$coordLeft, $coordTop]
	Local $StartEndTopRight = [$coordTop, $coordRight]
	Local $StartEndBottomLeft = [$coordLeft, $coordBottom]
	Local $StartEndBottomRight = [$coordBottom, $coordRight]

	SetDebugLog("_GetRedArea, StartEndTopLeft     = " & PixelArrayToString($StartEndTopLeft, ","))
	SetDebugLog("_GetRedArea, StartEndTopRight    = " & PixelArrayToString($StartEndTopRight, ","))
	SetDebugLog("_GetRedArea, StartEndBottomLeft  = " & PixelArrayToString($StartEndBottomLeft, ","))
	SetDebugLog("_GetRedArea, StartEndBottomRight = " & PixelArrayToString($StartEndBottomRight, ","))

	Local $startPoint, $endPoint, $invalid1, $invalid2
	Local $totalInvalid = 0
	$startPoint = $StartEndTopLeft[0]
	$endPoint = $StartEndTopLeft[1]
	Local $g_aiPixelTopLeft1 = SortByDistance($g_aiPixelTopLeft, $startPoint, $endPoint, $invalid1)
	$startPoint = $StartEndTopLeft[1]
	$endPoint = $StartEndTopLeft[0]
	Local $g_aiPixelTopLeft2 = SortByDistance($g_aiPixelTopLeft, $startPoint, $endPoint, $invalid2)
	$totalInvalid += (($invalid1 <= $invalid2) ? ($invalid1) : ($invalid2))
	$g_aiPixelTopLeft = SortByDistance((($invalid1 <= $invalid2) ? ($g_aiPixelTopLeft1) : ($g_aiPixelTopLeft2)), $StartEndTopLeft[0], $StartEndTopLeft[1], $invalid1)
	$startPoint = $StartEndTopRight[0]
	$endPoint = $StartEndTopRight[1]
	Local $g_aiPixelTopRight1 = SortByDistance($g_aiPixelTopRight, $startPoint, $endPoint, $invalid1)
	$startPoint = $StartEndTopRight[1]
	$endPoint = $StartEndTopRight[0]
	Local $g_aiPixelTopRight2 = SortByDistance($g_aiPixelTopRight, $startPoint, $endPoint, $invalid2)
	$totalInvalid += (($invalid1 <= $invalid2) ? ($invalid1) : ($invalid2))
	$g_aiPixelTopRight = SortByDistance((($invalid1 <= $invalid2) ? ($g_aiPixelTopRight1) : ($g_aiPixelTopRight2)), $StartEndTopRight[0], $StartEndTopRight[1], $invalid1)
	$startPoint = $StartEndBottomLeft[0]
	$endPoint = $StartEndBottomLeft[1]
	Local $g_aiPixelBottomLeft1 = SortByDistance($g_aiPixelBottomLeft, $startPoint, $endPoint, $invalid1)
	$startPoint = $StartEndBottomLeft[1]
	$endPoint = $StartEndBottomLeft[0]
	Local $g_aiPixelBottomLeft2 = SortByDistance($g_aiPixelBottomLeft, $startPoint, $endPoint, $invalid2)
	$totalInvalid += (($invalid1 <= $invalid2) ? ($invalid1) : ($invalid2))
	$g_aiPixelBottomLeft = SortByDistance((($invalid1 <= $invalid2) ? ($g_aiPixelBottomLeft1) : ($g_aiPixelBottomLeft2)), $StartEndBottomLeft[0], $StartEndBottomLeft[1], $invalid1)
	$startPoint = $StartEndBottomRight[0]
	$endPoint = $StartEndBottomRight[1]
	Local $g_aiPixelBottomRight1 = SortByDistance($g_aiPixelBottomRight, $startPoint, $endPoint, $invalid1)
	$startPoint = $StartEndBottomRight[1]
	$endPoint = $StartEndBottomRight[0]
	Local $g_aiPixelBottomRight2 = SortByDistance($g_aiPixelBottomRight, $startPoint, $endPoint, $invalid2)
	$totalInvalid += (($invalid1 <= $invalid2) ? ($invalid1) : ($invalid2))
	$g_aiPixelBottomRight = SortByDistance((($invalid1 <= $invalid2) ? ($g_aiPixelBottomRight1) : ($g_aiPixelBottomRight2)), $StartEndBottomRight[0], $StartEndBottomRight[1], $invalid1)

	; Pixel further calc

	Local $offsetArcher = 15

	ReDim $g_aiPixelRedArea[UBound($g_aiPixelTopLeft) + UBound($g_aiPixelBottomLeft) + UBound($g_aiPixelTopRight) + UBound($g_aiPixelBottomRight)]
	ReDim $g_aiPixelRedAreaFurther[UBound($g_aiPixelRedArea)]

	Local $a
	SetDebugLog("redarea calc pixel further", $COLOR_DEBUG)
	Local $count = 0
	ReDim $g_aiPixelTopLeftFurther[UBound($g_aiPixelTopLeft)]
	For $i = 0 To UBound($g_aiPixelTopLeft) - 1
		$g_aiPixelTopLeftFurther[$i] = _GetOffsetTroopFurther($g_aiPixelTopLeft[$i], $eVectorLeftTop, $offsetArcher)
		$g_aiPixelRedArea[$count] = $g_aiPixelTopLeft[$i]
		$g_aiPixelRedAreaFurther[$count] = $g_aiPixelTopLeftFurther[$i]
		$count += 1
	Next
	ReDim $g_aiPixelBottomLeftFurther[UBound($g_aiPixelBottomLeft)]
	For $i = 0 To UBound($g_aiPixelBottomLeft) - 1
		$g_aiPixelBottomLeftFurther[$i] = _GetOffsetTroopFurther($g_aiPixelBottomLeft[$i], $eVectorLeftBottom, $offsetArcher)
		$g_aiPixelRedArea[$count] = $g_aiPixelBottomLeft[$i]
		$g_aiPixelRedAreaFurther[$count] = $g_aiPixelBottomLeftFurther[$i]
		$count += 1
	Next
	ReDim $g_aiPixelTopRightFurther[UBound($g_aiPixelTopRight)]
	For $i = 0 To UBound($g_aiPixelTopRight) - 1
		$g_aiPixelTopRightFurther[$i] = _GetOffsetTroopFurther($g_aiPixelTopRight[$i], $eVectorRightTop, $offsetArcher)
		$g_aiPixelRedArea[$count] = $g_aiPixelTopRight[$i]
		$g_aiPixelRedAreaFurther[$count] = $g_aiPixelTopRightFurther[$i]
		$count += 1
	Next
	ReDim $g_aiPixelBottomRightFurther[UBound($g_aiPixelBottomRight)]
	For $i = 0 To UBound($g_aiPixelBottomRight) - 1
		$g_aiPixelBottomRightFurther[$i] = _GetOffsetTroopFurther($g_aiPixelBottomRight[$i], $eVectorRightBottom, $offsetArcher)
		$g_aiPixelRedArea[$count] = $g_aiPixelBottomRight[$i]
		$g_aiPixelRedAreaFurther[$count] = $g_aiPixelBottomRightFurther[$i]
		$count += 1
	Next

	; calculate average side length
	Local $aSideLength[4]
	$aSideLength[0] = ((UBound($g_aiPixelTopLeft) >= 10) ? (GetPixelDistance($g_aiPixelTopLeft[0], $g_aiPixelTopLeft[UBound($g_aiPixelTopLeft) - 1])) : (0))
	$aSideLength[1] = ((UBound($g_aiPixelBottomLeft) >= 10) ? (GetPixelDistance($g_aiPixelBottomLeft[0], $g_aiPixelBottomLeft[UBound($g_aiPixelBottomLeft) - 1])) : (0))
	$aSideLength[2] = ((UBound($g_aiPixelTopRight) >= 10) ? (GetPixelDistance($g_aiPixelTopRight[0], $g_aiPixelTopRight[UBound($g_aiPixelTopRight) - 1])) : (0))
	$aSideLength[3] = ((UBound($g_aiPixelBottomRight) >= 10) ? (GetPixelDistance($g_aiPixelBottomRight[0], $g_aiPixelBottomRight[UBound($g_aiPixelBottomRight) - 1])) : (0))
	Local $iAvgSideLength = 0
	Local $iAvgSideCount = 0
	For $i = 0 To 3
		$iAvgSideLength += $aSideLength[$i]
		If $aSideLength[$i] > 0 Then $iAvgSideCount += 1
	Next
	$iAvgSideLength = Round($iAvgSideLength / $iAvgSideCount, 0)
	SetDebugLog("Average side length: " & $iAvgSideLength)

	; validate if read line side have enough points and red line is long enough (covers enough space for attack)... otherwise fall back to outer green side
	Local $bNotEnoughPoints, $iSideLength
	$bNotEnoughPoints = UBound($g_aiPixelTopLeft) < 10
	$iSideLength = Round(GetPixelListDistance($g_aiPixelTopLeft, $iMaxAllowedPixelDistance), 0)
	If $bNotEnoughPoints Or $iSideLength / $fMinSideLengthFactor < $iAvgSideLength Then ; * 2 < GetPixelDistance($coordTop, $coordLeft) Then
		SetDebugLog("Attack side top-left: fall back to outer green (" & (($bNotEnoughPoints) ? ("not enougth points") : ("side length " & $iSideLength & " / " & $fMinSideLengthFactor & " < " & $iAvgSideLength)) & ")")
		$g_aiPixelTopLeft = _GetVectorOutZone($eVectorLeftTop)
		$g_aiPixelTopLeftFurther = $g_aiPixelTopLeft
	EndIf
	$bNotEnoughPoints = UBound($g_aiPixelBottomLeft) < 10
	$iSideLength = Round(GetPixelListDistance($g_aiPixelBottomLeft, $iMaxAllowedPixelDistance), 0)
	If $bNotEnoughPoints Or $iSideLength / $fMinSideLengthFactor < $iAvgSideLength Then ; * 2 < GetPixelDistance($coordBottom, $coordLeft) Then
		SetDebugLog("Attack side bottom-left: fall back to outer green (" & (($bNotEnoughPoints) ? ("not enougth points") : ("side length " & $iSideLength & " / " & $fMinSideLengthFactor & " < " & $iAvgSideLength)) & ")")
		$g_aiPixelBottomLeft = _GetVectorOutZone($eVectorLeftBottom)
		$g_aiPixelBottomLeftFurther = $g_aiPixelBottomLeft
	EndIf
	$bNotEnoughPoints = UBound($g_aiPixelTopRight) < 10
	$iSideLength = Round(GetPixelListDistance($g_aiPixelTopRight, $iMaxAllowedPixelDistance), 0)
	If $bNotEnoughPoints Or $iSideLength / $fMinSideLengthFactor < $iAvgSideLength Then ; * 2 < GetPixelDistance($coordTop, $coordRight) Then
		SetDebugLog("Attack side top-right: fall back to outer green (" & (($bNotEnoughPoints) ? ("not enougth points") : ("side length " & $iSideLength & " / " & $fMinSideLengthFactor & " < " & $iAvgSideLength)) & ")")
		$g_aiPixelTopRight = _GetVectorOutZone($eVectorRightTop)
		$g_aiPixelTopRightFurther = $g_aiPixelTopRight
	EndIf
	$bNotEnoughPoints = UBound($g_aiPixelBottomRight) < 10
	$iSideLength = Round(GetPixelListDistance($g_aiPixelBottomRight, $iMaxAllowedPixelDistance), 0)
	If $bNotEnoughPoints Or $iSideLength / $fMinSideLengthFactor < $iAvgSideLength Then ; * 2 < GetPixelDistance($coordBottom, $coordRight) Then
		SetDebugLog("Attack side bottom-right: fall back to outer green (" & (($bNotEnoughPoints) ? ("not enougth points") : ("side length " & $iSideLength & " / " & $fMinSideLengthFactor & " < " & $iAvgSideLength)) & ")")
		$g_aiPixelBottomRight = _GetVectorOutZone($eVectorRightBottom)
		$g_aiPixelBottomRightFurther = $g_aiPixelBottomRight
	EndIf

	debugRedArea($nameFunc & "  Size of arr pixel for TopLeft [" & UBound($g_aiPixelTopLeft) & "] /  BottomLeft [" & UBound($g_aiPixelBottomLeft) & "] /  TopRight [" & UBound($g_aiPixelTopRight) & "] /  BottomRight [" & UBound($g_aiPixelBottomRight) & "] ")
	; Custom - Team AIO Mod++
	If $g_bDebugRedArea Or $g_sBundleRedLineNV Or $g_bDebugImageSave Then 
		DebugDropPoints()
	EndIf
	
	debugRedArea($nameFunc & " OUT ")
EndFunc   ;==>_GetRedArea

; Custom - Team AIO Mod++
Func DebugDropPoints($sFrom = "")
	If IsPtr($g_hHBitmap2) Then
		Local $sDir = ($sFrom <> "") ? ($sFrom) : ("DropPoints")
		Local $sSubDir = $g_sProfileTempDebugPath & $sDir
	
		DirCreate($sSubDir)
	
		Local $sDate = @YEAR & "-" & @MON & "-" & @MDAY, $sTime = @HOUR & "." & @MIN & "." & @SEC
		Local $sDebugImageName = String($sDate & "_" & $sTime & "_.png")
		Local $hEditedImage = _GDIPlus_BitmapCreateFromHBITMAP($g_hHBitmap2)
		Local $hGraphic = _GDIPlus_ImageGetGraphicsContext($hEditedImage)
		Local $hPenYellow = _GDIPlus_PenCreate(0xFFFFFF00, 1)
		
		Local $aXY[2]
		For $i = 0 To UBound($g_aiPixelTopLeft) - 1
			$aXY = $g_aiPixelTopLeft[$i]
			_GDIPlus_GraphicsDrawRect($hGraphic, $aXY[0], $aXY[1], 1, 1, $hPenYellow)

		Next
		For $i = 0 To UBound($g_aiPixelBottomLeft) - 1
			$aXY = $g_aiPixelBottomLeft[$i]
			_GDIPlus_GraphicsDrawRect($hGraphic, $aXY[0], $aXY[1], 1, 1, $hPenYellow)
		Next
		For $i = 0 To UBound($g_aiPixelTopRight) - 1
			$aXY = $g_aiPixelTopRight[$i]
			_GDIPlus_GraphicsDrawRect($hGraphic, $aXY[0], $aXY[1], 1, 1, $hPenYellow)
		Next
		For $i = 0 To UBound($g_aiPixelBottomRight) - 1
			$aXY = $g_aiPixelBottomRight[$i]
			_GDIPlus_GraphicsDrawRect($hGraphic, $aXY[0], $aXY[1], 1, 1, $hPenYellow)
		Next
	
		_GDIPlus_ImageSaveToFile($hEditedImage, $sSubDir & "\" & $sDebugImageName )
		_GDIPlus_PenDispose($hPenYellow)
		_GDIPlus_GraphicsDispose($hGraphic)
		_GDIPlus_BitmapDispose($hEditedImage)
	EndIf
EndFunc

Func SortRedline($redline, $StartPixel, $EndPixel, $sDelim = ",")
	Local $aPoints = StringSplit($redline, "|", $STR_NOCOUNT)
	Local $size = UBound($aPoints)
	If $size < 2 Then Return StringReplace($redline, $sDelim, "-")
	For $i = 0 To $size - 1
		Local $sPoint = $aPoints[$i]
		Local $aPoint = GetPixel($sPoint, $sDelim)
		If UBound($aPoint) > 1 Then $aPoints[$i] = $aPoint
	Next
	Local $iInvalid = 0
	Local $s = PixelArrayToString(SortByDistance($aPoints, $StartPixel, $EndPixel, $iInvalid))
	Return $s
EndFunc   ;==>SortRedline

Func SortByDistance($PixelList, ByRef $StartPixel, ByRef $EndPixel, ByRef $iInvalid)

	SetDebugLog("SortByDistance Start = " & PixelToString($StartPixel, ',') & " : " & PixelArrayToString($PixelList, ","))
	Local $iMax = UBound($PixelList) - 1
	Local $iMin2 = 0
	Local $iMax2 = $iMax
	Local $Sorted[0]
	Local $PrevPixel = $StartPixel
	Local $PrevDistance = -1
	Local $totalDistances = 0
	Local $totalPoints = 0
	Local $firstPixel = [-1, -1], $lastPixel = [-1, -1]
	Local $avgDistance = 0
	$iInvalid = 0

	For $i = 0 To $iMax
		Local $ClosestIndex = 0
		Local $ClosestDistance = 9999
		Local $ClosestPixel = [0, 0]
		Local $adjustMin = True
		Local $adjustMax = 0
		For $j = $iMin2 To $iMax2
			Local $Pixel = $PixelList[$j]
			If IsArray($Pixel) = 0 Then
				If $adjustMin Then $iMin2 = $j + 1
				If $adjustMax = $iMax Then $adjustMax = $j
				ContinueLoop
			EndIf
			$adjustMin = False
			$adjustMax = $iMax
			Local $d = GetPixelDistance($PrevPixel, $Pixel)
			If $d < $ClosestDistance Then
				$ClosestIndex = $j
				$ClosestDistance = $d
				$ClosestPixel = $Pixel
			EndIf
		Next
		$iMax2 = $adjustMax
		; skip drop points that are too far away
		$avgDistance = $totalDistances / $totalPoints
		Local $invalidPoint = $ClosestPixel[0] < 0 Or $ClosestPixel[1] < 0
		If $invalidPoint Or ($PrevDistance > -1 And ($iMax - $i) / $iMax < 0.20 And ($ClosestDistance > $avgDistance * 10 Or ($ClosestDistance > $avgDistance * 3 And (GetPixelDistance($PrevPixel, $EndPixel) < 25 Or $ClosestDistance > $totalDistances / 2)))) Then
			; skip this pixel
			$iInvalid += 1
		Else
			If $firstPixel[0] = -1 Then $firstPixel = $ClosestPixel
			$lastPixel = $ClosestPixel
			$PrevPixel = $ClosestPixel
			$PrevDistance = $ClosestDistance
			$totalPoints += 1
			$totalDistances += $ClosestDistance
			ReDim $Sorted[UBound($Sorted) + 1]
			$Sorted[UBound($Sorted) - 1] = $ClosestPixel
		EndIf
		$PixelList[$ClosestIndex] = 0
	Next

	; validate start and end pixel
	If $firstPixel[0] > 0 And GetPixelDistance($StartPixel, $firstPixel) > $avgDistance * 3 Then
		$StartPixel[0] = $firstPixel[0]
		$StartPixel[1] = $firstPixel[1]
	EndIf
	If $lastPixel[0] > 0 And GetPixelDistance($EndPixel, $lastPixel) > $avgDistance * 3 Then
		$EndPixel[0] = $lastPixel[0]
		$EndPixel[1] = $lastPixel[1]
	EndIf

	Return $Sorted

EndFunc   ;==>SortByDistance

Func PixelArrayToString(Const ByRef $PixelList, $sDelim = "-")
	If UBound($PixelList) < 1 Then Return ""
	Local $s = ""
	For $i = 0 To UBound($PixelList) - 1
		Local $Pixel = $PixelList[$i]
		$s &= "|" & PixelToString($Pixel, $sDelim)
	Next
	$s = StringMid($s, 2)
	Return $s
EndFunc   ;==>PixelArrayToString

Func PixelToString(Const ByRef $Pixel, $sDelim = "-")
	If UBound($Pixel) < 2 Then Return ""
	Return $Pixel[0] & $sDelim & $Pixel[1]
EndFunc   ;==>PixelToString

Func _SortRedline($redline, $sDelim = ",")
	Local $aPoints = StringSplit($redline, "|", $STR_NOCOUNT)
	Local $size = UBound($aPoints)
	If $size < 2 Then Return StringReplace($redline, $sDelim, "-")
	Local $a1[$size + 1][2] = [[0, 0]]
	For $sPoint In $aPoints
		Local $aPoint = GetPixel($sPoint, $sDelim)
		If UBound($aPoint) > 1 Then getRedAreaSideBuildingSetPoint($a1, $aPoint)
	Next
	Local $s = getRedAreaSideBuildingString($a1)
	Return $s
EndFunc   ;==>_SortRedline

Func getRedAreaSideBuildingSetPoint(ByRef $aSide, ByRef $aPoint)
	$aSide[0][0] += 1
	$aSide[$aSide[0][0]][0] = Int($aPoint[0])
	$aSide[$aSide[0][0]][1] = Int($aPoint[1])
EndFunc   ;==>getRedAreaSideBuildingSetPoint

Func getRedAreaSideBuildingString(ByRef $aSide)
	If UBound($aSide) < 2 Or $aSide[0][0] < 1 Then Return ""
	_ArraySort($aSide, 0, 1, $aSide[0][0], 0)
	Local $s = ""
	For $j = 1 To $aSide[0][0]
		$s &= ("|" & $aSide[$j][0] & "-" & $aSide[$j][1])
	Next
	$s = StringMid($s, 2)
	Return $s
EndFunc   ;==>getRedAreaSideBuildingString

Func getRedAreaSideBuilding($redline = $g_sImglocRedline)
	;SetDebugLog("getRedAreaSideBuilding: " & $redline)
	Local $c = 0
	Local $a[5]
	Local $aPoints = StringSplit($redline, "|", $STR_NOCOUNT)
	Local $size = UBound($aPoints)
	Local $a1[$size + 1][2] = [[0, 0]] ; Top Left
	Local $a2[$size + 1][2] = [[0, 0]] ; Bottom Left
	Local $a3[$size + 1][2] = [[0, 0]] ; Bottom Right
	Local $a4[$size + 1][2] = [[0, 0]] ; Top Right

	For $sPoint In $aPoints
		Local $aPoint = GetPixel($sPoint, ",")
		If UBound($aPoint) > 1 Then
			$c += 1
			Local $i = GetPixelSection($aPoint[0], $aPoint[1])
			Switch $i
				Case 1 ; Top Left
					getRedAreaSideBuildingSetPoint($a1, $aPoint)
				Case 2 ; Bottom Left
					getRedAreaSideBuildingSetPoint($a2, $aPoint)
				Case 3 ; Bottom Right
					getRedAreaSideBuildingSetPoint($a3, $aPoint)
				Case 4 ; Top Right
					getRedAreaSideBuildingSetPoint($a4, $aPoint)
			EndSwitch
		EndIf
	Next
	$a[0] = $c
	$a[1] = getRedAreaSideBuildingString($a1)
	$a[2] = getRedAreaSideBuildingString($a2)
	$a[3] = getRedAreaSideBuildingString($a3)
	$a[4] = getRedAreaSideBuildingString($a4)
	;SetDebugLog("getRedAreaSideBuilding, Side " & $i & ": " & StringReplace($a[$i], "-", ","))
	Return $a
EndFunc   ;==>getRedAreaSideBuilding

Func GetPixelSection($x, $y)
	Local $isLeft = ($x <= $ExternalArea[2][0])
	Local $isTop = ($y <= $ExternalArea[0][1])
	If $isLeft Then
		If $isTop Then Return 1 ; Top Left
		Return 2 ; Bottom Left
	EndIf
	If $isTop Then Return 4 ; Top Right
	Return 3 ; Bottom Right
EndFunc   ;==>GetPixelSection

Func FindClosestToAxis(Const ByRef $PixelList)
	Local $Axis = [$ExternalArea[2][0], $ExternalArea[0][1]]
	Local $Search[2] = [9999, 9999]
	Local $Points[2]
	For $Pixel In $PixelList
		For $i = 0 To 1
			If Abs($Pixel[$i] - $Axis[$i]) < Abs($Search[$i] - $Axis[$i]) Then
				$Search[$i] = $Pixel[$i]
				$Points[$i] = $Pixel
			EndIf
		Next
	Next
	#cs
		Local $Order
		Local $OrderXY = [0, 1]
		Local $OrderYX = [1, 0]
		Local $FixStartEnd
		Switch $Side
		Case 1 ; Top Left
		$Order = $OrderYX
		Local $FixStartEnd = []
		Case 2 ; Bottom Left
		$Order = $OrderYX
		Case 3 ; Bottom Right
		$Order = $OrderXY
		Case 4 ; Top Right
		$Order = $OrderXY
		EndSwitch
	#ce
	For $i = 0 To 1
		If $Search[$i] = 9999 Then $Search[$i] = $Axis[$i]
	Next
	Return $Search
EndFunc   ;==>FindClosestToAxis
