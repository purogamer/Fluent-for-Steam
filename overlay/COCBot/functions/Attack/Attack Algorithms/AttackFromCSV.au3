; #FUNCTION# ====================================================================================================================
; Name ..........:
; Description ...: This file contains the attack algorithm SCRIPTED
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Sardo (2016)
; Modified ......: CodeSlinger69 (01-2017) GrumpyHog (05-2022)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2022
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Global $MAINSIDE = "BOTTOM-RIGHT"
Global $FRONT_LEFT = "BOTTOM-RIGHT-DOWN"
Global $FRONT_RIGHT = "BOTTOM-RIGHT-UP"
Global $RIGHT_FRONT = "TOP-RIGHT-DOWN"
Global $RIGHT_BACK = "TOP-RIGHT-UP"
Global $LEFT_FRONT = "BOTTOM-LEFT-DOWN"
Global $LEFT_BACK = "BOTTOM-LEFT-UP"
Global $BACK_LEFT = "TOP-LEFT-DOWN"
Global $BACK_RIGHT = "TOP-LEFT-UP"


Global $g_aiPixelTopLeftDropLine
Global $g_aiPixelTopRightDropLine
Global $g_aiPixelBottomLeftDropLine
Global $g_aiPixelBottomRightDropLine
Global $g_aiPixelTopLeftUPDropLine
Global $g_aiPixelTopLeftDOWNDropLine
Global $g_aiPixelTopRightUPDropLine
Global $g_aiPixelTopRightDOWNDropLine
Global $g_aiPixelBottomLeftUPDropLine
Global $g_aiPixelBottomLeftDOWNDropLine
Global $g_aiPixelBottomRightUPDropLine
Global $g_aiPixelBottomRightDOWNDropLine

Global $g_aiDeployableLRTB = [0, $g_iGAME_WIDTH - 1, 0, 529]
Global $InnerDiamondLeft = 45
Global $InnerDiamondRight = 815
Global $InnerDiamondTop = 60
Global $InnerDiamondBottom = 636
Global $InnerDiamandDiffX = 28
Global $InnerDiamandDiffY = 20
Global $DiamondMiddleX = ($InnerDiamondLeft + $InnerDiamondRight) / 2
Global $DiamondMiddleY = ($InnerDiamondTop + $InnerDiamondBottom) / 2

convertinternalexternarea("Start")

Func ConvertInternalExternArea($FunctionName = "", $bDebugImage = Default)
	$DiamondMiddleX = ($InnerDiamondLeft + $InnerDiamondRight) / 2
	$DiamondMiddleY = ($InnerDiamondTop + $InnerDiamondBottom) / 2

	Local $OuterDiamondLeft = $InnerDiamondLeft - $InnerDiamandDiffX
	Local $OuterDiamondRight = $InnerDiamondRight + $InnerDiamandDiffX
	Local $OuterDiamondTop = $InnerDiamondTop - $InnerDiamandDiffY
	Local $OuterDiamondBottom = $InnerDiamondBottom + $InnerDiamandDiffY

	Local $ExternalAreaRef[8][3] = [ _
			[$OuterDiamondLeft, $DiamondMiddleY, "LEFT"], _
			[$OuterDiamondRight, $DiamondMiddleY, "RIGHT"], _
			[$DiamondMiddleX, $OuterDiamondTop, "TOP"], _
			[$DiamondMiddleX, $OuterDiamondBottom, "BOTTOM"], _
			[$OuterDiamondLeft + ($DiamondMiddleX - $OuterDiamondLeft) / 2, $OuterDiamondTop + ($DiamondMiddleY - $OuterDiamondTop) / 2, "TOP-LEFT"], _
			[$DiamondMiddleX + ($OuterDiamondRight - $DiamondMiddleX) / 2, $OuterDiamondTop + ($DiamondMiddleY - $OuterDiamondTop) / 2, "TOP-RIGHT"], _
			[$OuterDiamondLeft + ($DiamondMiddleX - $OuterDiamondLeft) / 2, $DiamondMiddleY + ($OuterDiamondBottom - $DiamondMiddleY) / 2, "BOTTOM-LEFT"], _
			[$DiamondMiddleX + ($OuterDiamondRight - $DiamondMiddleX) / 2, $DiamondMiddleY + ($OuterDiamondBottom - $DiamondMiddleY) / 2, "BOTTOM-RIGHT"] _
			]

	Local $InternalAreaRef[8][3] = [ _
			[$InnerDiamondLeft, $DiamondMiddleY, "LEFT"], _
			[$InnerDiamondRight, $DiamondMiddleY, "RIGHT"], _
			[$DiamondMiddleX, $InnerDiamondTop, "TOP"], _
			[$DiamondMiddleX, $InnerDiamondBottom, "BOTTOM"], _
			[$InnerDiamondLeft + ($DiamondMiddleX - $InnerDiamondLeft) / 2, $InnerDiamondTop + ($DiamondMiddleY - $InnerDiamondTop) / 2, "TOP-LEFT"], _
			[$DiamondMiddleX + ($InnerDiamondRight - $DiamondMiddleX) / 2, $InnerDiamondTop + ($DiamondMiddleY - $InnerDiamondTop) / 2, "TOP-RIGHT"], _
			[$InnerDiamondLeft + ($DiamondMiddleX - $InnerDiamondLeft) / 2, $DiamondMiddleY + ($InnerDiamondBottom - $DiamondMiddleY) / 2, "BOTTOM-LEFT"], _
			[$DiamondMiddleX + ($InnerDiamondRight - $DiamondMiddleX) / 2, $DiamondMiddleY + ($InnerDiamondBottom - $DiamondMiddleY) / 2, "BOTTOM-RIGHT"] _
			]

	Local $x, $y
	; Update External coord.
	For $i = 0 To 7
		$x = $ExternalAreaRef[$i][0]
		$y = $ExternalAreaRef[$i][1]
		ConvertToVillagePos($x, $y)
		$ExternalArea[$i][0] = $x
		$ExternalArea[$i][1] = $y
		$ExternalArea[$i][2] = $ExternalAreaRef[$i][2]
		;debugAttackCSV("External Area Point " & $ExternalArea[$i][2] & ": " & $x & ", " & $y)
	Next
	; Full ECD Diamond $CocDiamondECD
	; Top
	$x = $ExternalAreaRef[2][0]
	$y = $ExternalAreaRef[2][1] + $InnerDiamandDiffY
	ConvertToVillagePos($x, $y)
	$CocDiamondECD = $x & "," & $y
	; Right
	$x = $ExternalAreaRef[1][0] - $InnerDiamandDiffX
	$y = $ExternalAreaRef[1][1]
	ConvertToVillagePos($x, $y)
	$CocDiamondECD &= "|" & $x & "," & $y
	; Bottom
	$x = $ExternalAreaRef[3][0]
	$y = $ExternalAreaRef[3][1] - $InnerDiamandDiffX
	ConvertToVillagePos($x, $y)
	$CocDiamondECD &= "|" & $x & "," & $y
	; Left
	$x = $ExternalAreaRef[0][0] + $InnerDiamandDiffX
	$y = $ExternalAreaRef[0][1]
	ConvertToVillagePos($x, $y)
	$CocDiamondECD &= "|" & $x & "," & $y

	; Update Internal coord.
	For $i = 0 To 7
		$x = $InternalAreaRef[$i][0]
		$y = $InternalAreaRef[$i][1]
		ConvertToVillagePos($x, $y)
		$InternalArea[$i][0] = $x
		$InternalArea[$i][1] = $y
		$InternalArea[$i][2] = $InternalAreaRef[$i][2]
		;debugAttackCSV("Internal Area Point " & $InternalArea[$i][2] & ": " & $x & ", " & $y)
	Next
	$CocDiamondDCD = $InternalArea[2][0] & "," & $InternalArea[2][1] & "|" & _
			$InternalArea[1][0] & "," & $InternalArea[1][1] & "|" & _
			$InternalArea[3][0] & "," & $InternalArea[3][1] & "|" & _
			$InternalArea[0][0] & "," & $InternalArea[0][1]

	; Custom fix - Team AIO Mod++
	$DiamondMiddleX = $InternalArea[0][0] + (($InternalArea[1][0] - $InternalArea[0][0]) / 2)
	$DiamondMiddleY = $InternalArea[2][1] + (($InternalArea[3][1] - $InternalArea[2][1]) / 2)

	If $bDebugImage = Default Then $bDebugImage = $g_bDebugAttackCSV Or $g_bDebugImageSave
	If $FunctionName <> "Start" And $bDebugImage = True Then
		DebugInternalExternArea()
	EndIf
EndFunc   ;==>ConvertInternalExternArea

Func DebugInternalExternArea()
	Local $subdirectory = $g_sprofiletempdebugpath & "ConvertInternalExternArea"
	DirCreate($subdirectory)
	Local $date = @YEAR & "-" & @MON & "-" & @MDAY, $time = @HOUR & "." & @MIN & "." & @SEC
	Local $editedimage = _gdiplus_bitmapcreatefromhbitmap($g_hhbitmap2)
	Local $hgraphic = _gdiplus_imagegetgraphicscontext($editedimage)
	Local $hpenwhite = _gdiplus_pencreate(0xc0ffffff, 3)
	Local $hpenblue = _gdiplus_pencreate(0xc00fbae9, 3)
	Local $filename = String($date & "_" & $time & "_ConvertInternalExternArea_.png")

	;-- DRAW EXTERNAL PERIMETER LINES
	_GDIPlus_GraphicsDrawLine($hGraphic, $ExternalArea[0][0], $ExternalArea[0][1], $ExternalArea[2][0], $ExternalArea[2][1], $hpenblue)
	_GDIPlus_GraphicsDrawLine($hGraphic, $ExternalArea[0][0], $ExternalArea[0][1], $ExternalArea[3][0], $ExternalArea[3][1], $hpenblue)
	_GDIPlus_GraphicsDrawLine($hGraphic, $ExternalArea[1][0], $ExternalArea[1][1], $ExternalArea[2][0], $ExternalArea[2][1], $hpenblue)
	_GDIPlus_GraphicsDrawLine($hGraphic, $ExternalArea[1][0], $ExternalArea[1][1], $ExternalArea[3][0], $ExternalArea[3][1], $hpenblue)

	;-- DRAW INTERNAL PERIMETER LINES
	_GDIPlus_GraphicsDrawLine($hGraphic, $InternalArea[0][0], $InternalArea[0][1], $InternalArea[2][0], $InternalArea[2][1], $hpenwhite)
	_GDIPlus_GraphicsDrawLine($hGraphic, $InternalArea[0][0], $InternalArea[0][1], $InternalArea[3][0], $InternalArea[3][1], $hpenwhite)
	_GDIPlus_GraphicsDrawLine($hGraphic, $InternalArea[1][0], $InternalArea[1][1], $InternalArea[2][0], $InternalArea[2][1], $hpenwhite)
	_GDIPlus_GraphicsDrawLine($hGraphic, $InternalArea[1][0], $InternalArea[1][1], $InternalArea[3][0], $InternalArea[3][1], $hpenwhite)
	_gdiplus_imagesavetofile($editedimage, $subdirectory & "\" & $filename)

	_gdiplus_pendispose($hpenwhite)
	_gdiplus_pendispose($hpenblue)
	_gdiplus_graphicsdispose($hgraphic)
	_gdiplus_bitmapdispose($editedimage)
EndFunc   ;==>DebugInternalExternArea

Func CheckAttackLocation(ByRef $iX, ByRef $iY)
	If $iY > $g_aiDeployableLRTB[3] Then
		$iY = $g_aiDeployableLRTB[3]
		Return False
	EndIf
	Return True
EndFunc   ;==>CheckAttackLocation

Func GetMinPoint($PointList, $Dim)
	Local $Result = [9999, 9999]
	For $i = 0 To UBound($PointList) - 1
		Local $Point = $PointList[$i]
		If $Point[$Dim] < $Result[$Dim] Then $Result = $Point
	Next
	Return $Result
EndFunc   ;==>GetMinPoint

Func GetMaxPoint($PointList, $Dim)
	Local $Result = [-9999, -9999]
	For $i = 0 To UBound($PointList) - 1
		Local $Point = $PointList[$i]
		If $Point[$Dim] > $Result[$Dim] Then $Result = $Point
	Next
	Return $Result
EndFunc   ;==>GetMaxPoint

; #FUNCTION# ====================================================================================================================
; Name ..........: Algorithm_AttackCSV
; Description ...:
; Syntax ........: Algorithm_AttackCSV([$testattack = False])
; Parameters ....: $testattack          - [optional]
; Return values .: None
; Author ........: Sardo (2016)
; Modified ......: CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func Algorithm_AttackCSV($testattack = False, $captureredarea = True)

	; Custom CSV - Team AIO Mod++
	CSVRandomization()

	Local $g_aiPixelNearCollectorTopLeft[0]
	Local $g_aiPixelNearCollectorBottomLeft[0]
	Local $g_aiPixelNearCollectorTopRight[0]
	Local $g_aiPixelNearCollectorBottomRight[0]
	Local $aResult

	;00 read attack file SIDE row and valorize variables
	ParseAttackCSV_Read_SIDE_variables()
	$g_iCSVLastTroopPositionDropTroopFromINI = -1
	If _Sleep($DELAYRESPOND) Then Return

	;01 - TROOPS ------------------------------------------------------------------------------------------------------------------------------------------
	debugAttackCSV("Troops to be used (purged from troops) ")
	For $i = 0 To UBound($g_avAttackTroops) - 1 ; identify the position of this kind of troop
		debugAttackCSV("SLOT n.: " & $i & " - Troop: " & GetTroopName($g_avAttackTroops[$i][0]) & " (" & $g_avAttackTroops[$i][0] & ") - Quantity: " & $g_avAttackTroops[$i][1])
	Next

	Local $hTimerTOTAL = __timerinit()
	;02.01 - REDAREA -----------------------------------------------------------------------------------------------------------------------------------------
	Local $hTimer = __timerinit()

	SetDebugLog("Redline mode: " & $g_aiAttackScrRedlineRoutine[$g_iMatchMode])
	SetDebugLog("Dropline mode: " & $g_aiAttackScrDroplineEdge[$g_iMatchMode])

	_CaptureRegion2() ; ensure full screen is captured (not ideal for debugging as clean image was already saved, but...)
	If $captureredarea Then _GetRedArea($g_aiAttackScrRedlineRoutine[$g_iMatchMode])
	If _Sleep($DELAYRESPOND) Then Return

	Local $htimerREDAREA = Round(__timerdiff($hTimer) / 1000, 2)
	debugAttackCSV("Calculated  (in " & $htimerREDAREA & " seconds) :")
	debugAttackCSV("	[" & UBound($g_aiPixelTopLeft) & "] pixels TopLeft")
	debugAttackCSV("	[" & UBound($g_aiPixelTopRight) & "] pixels TopRight")
	debugAttackCSV("	[" & UBound($g_aiPixelBottomLeft) & "] pixels BottomLeft")
	debugAttackCSV("	[" & UBound($g_aiPixelBottomRight) & "] pixels BottomRight")

	If $g_aiAttackScrDroplineEdge[$g_iMatchMode] = $DROPLINE_DROPPOINTS_ONLY Then

		$g_aiPixelTopLeftDropLine = $g_aiPixelTopLeft
		$g_aiPixelTopRightDropLine = $g_aiPixelTopRight
		$g_aiPixelBottomLeftDropLine = $g_aiPixelBottomLeft
		$g_aiPixelBottomRightDropLine = $g_aiPixelBottomRight

	Else

		Local $coordLeft = [$ExternalArea[0][0], $ExternalArea[0][1]]
		Local $coordTop = [$ExternalArea[2][0], $ExternalArea[2][1]]
		Local $coordRight = [$ExternalArea[1][0], $ExternalArea[1][1]]
		Local $coordBottom = [$ExternalArea[3][0], $ExternalArea[3][1]]

		Local $StartEndTopLeft = [$coordLeft, $coordTop]
		If UBound($g_aiPixelTopLeft) > 2 Then Local $StartEndTopLeft = [$g_aiPixelTopLeft[0], $g_aiPixelTopLeft[UBound($g_aiPixelTopLeft) - 1]]
		Local $StartEndTopRight = [$coordTop, $coordRight]
		If UBound($g_aiPixelTopRight) > 2 Then Local $StartEndTopRight = [$g_aiPixelTopRight[0], $g_aiPixelTopRight[UBound($g_aiPixelTopRight) - 1]]
		Local $StartEndBottomLeft = [$coordLeft, $coordBottom]
		If UBound($g_aiPixelBottomLeft) > 2 Then Local $StartEndBottomLeft = [$g_aiPixelBottomLeft[0], $g_aiPixelBottomLeft[UBound($g_aiPixelBottomLeft) - 1]]
		Local $StartEndBottomRight = [$coordBottom, $coordRight]
		If UBound($g_aiPixelBottomRight) > 2 Then Local $StartEndBottomRight = [$g_aiPixelBottomRight[0], $g_aiPixelBottomRight[UBound($g_aiPixelBottomRight) - 1]]

		Switch $g_aiAttackScrDroplineEdge[$g_iMatchMode]
			Case $DROPLINE_EDGE_FIXED, $DROPLINE_FULL_EDGE_FIXED ; default inner area edges
				; reset fix corners
				Local $StartEndTopLeft = [$coordLeft, $coordTop]
				Local $StartEndTopRight = [$coordTop, $coordRight]
				Local $StartEndBottomLeft = [$coordLeft, $coordBottom]
				Local $StartEndBottomRight = [$coordBottom, $coordRight]
		EndSwitch

		SetDebugLog("MakeDropLines, StartEndTopLeft     = " & PixelArrayToString($StartEndTopLeft, ","))
		SetDebugLog("MakeDropLines, StartEndTopRight    = " & PixelArrayToString($StartEndTopRight, ","))
		SetDebugLog("MakeDropLines, StartEndBottomLeft  = " & PixelArrayToString($StartEndBottomLeft, ","))
		SetDebugLog("MakeDropLines, StartEndBottomRight = " & PixelArrayToString($StartEndBottomRight, ","))

		Switch $g_aiAttackScrDroplineEdge[$g_iMatchMode]
			Case $DROPLINE_EDGE_FIXED, $DROPLINE_EDGE_FIRST ; default drop line
				$g_aiPixelTopLeftDropLine = MakeDropLineOriginal($g_aiPixelTopLeft, $StartEndTopLeft[0], $StartEndTopLeft[1])
				$g_aiPixelTopRightDropLine = MakeDropLineOriginal($g_aiPixelTopRight, $StartEndTopRight[0], $StartEndTopRight[1])
				$g_aiPixelBottomLeftDropLine = MakeDropLineOriginal($g_aiPixelBottomLeft, $StartEndBottomLeft[0], $StartEndBottomLeft[1])
				$g_aiPixelBottomRightDropLine = MakeDropLineOriginal($g_aiPixelBottomRight, $StartEndBottomRight[0], $StartEndBottomRight[1])
			Case $DROPLINE_FULL_EDGE_FIXED, $DROPLINE_FULL_EDGE_FIRST ; full drop line
				Local $iLineDistanceThreshold = 75
				If $g_aiAttackScrRedlineRoutine[$g_iMatchMode] = $REDLINE_IMGLOC Then $iLineDistanceThreshold = 25
				$g_aiPixelTopLeftDropLine = MakeDropLine($g_aiPixelTopLeft, $StartEndTopLeft[0], $StartEndTopLeft[1], $iLineDistanceThreshold, $g_aiAttackScrDroplineEdge[$g_iMatchMode] = $DROPLINE_FULL_EDGE_FIXED)
				$g_aiPixelTopRightDropLine = MakeDropLine($g_aiPixelTopRight, $StartEndTopRight[0], $StartEndTopRight[1], $iLineDistanceThreshold, $g_aiAttackScrDroplineEdge[$g_iMatchMode] = $DROPLINE_FULL_EDGE_FIXED)
				$g_aiPixelBottomLeftDropLine = MakeDropLine($g_aiPixelBottomLeft, $StartEndBottomLeft[0], $StartEndBottomLeft[1], $iLineDistanceThreshold, $g_aiAttackScrDroplineEdge[$g_iMatchMode] = $DROPLINE_FULL_EDGE_FIXED)
				$g_aiPixelBottomRightDropLine = MakeDropLine($g_aiPixelBottomRight, $StartEndBottomRight[0], $StartEndBottomRight[1], $iLineDistanceThreshold, $g_aiAttackScrDroplineEdge[$g_iMatchMode] = $DROPLINE_FULL_EDGE_FIXED)
		EndSwitch
	EndIf

	;02.04 - MAKE DROP LINE SLICE ----------------------------------------------------------------------------------------------------------------------------
	;-- TOP LEFT
	Local $tempvectstr1 = ""
	Local $tempvectstr2 = ""
	For $i = 0 To UBound($g_aiPixelTopLeftDropLine) - 1
		Local $pixel = $g_aiPixelTopLeftDropLine[$i]
		Local $slice = Slice8($pixel)
		Switch StringLeft($slice, 1)
			Case "6"
				$tempvectstr1 &= $pixel[0] & "," & $pixel[1] & "|"
			Case "5"
				$tempvectstr2 &= $pixel[0] & "," & $pixel[1] & "|"
			Case Else
				SetDebugLog("TOP LEFT: Skip slice " & $slice & " at " & $pixel[0] & ", " & $pixel[1])
		EndSwitch
	Next
	If StringLen($tempvectstr1) > 0 Then $tempvectstr1 = StringLeft($tempvectstr1, StringLen($tempvectstr1) - 1)
	If StringLen($tempvectstr2) > 0 Then $tempvectstr2 = StringLeft($tempvectstr2, StringLen($tempvectstr2) - 1)
	$g_aiPixelTopLeftDOWNDropLine = GetListPixel($tempvectstr1, ",", "TL-DOWN")
	$g_aiPixelTopLeftUPDropLine = GetListPixel($tempvectstr2, ",", "TL-UP")

	;-- TOP RIGHT
	Local $tempvectstr1 = ""
	Local $tempvectstr2 = ""
	For $i = 0 To UBound($g_aiPixelTopRightDropLine) - 1
		Local $pixel = $g_aiPixelTopRightDropLine[$i]
		Local $slice = Slice8($pixel)
		Switch StringLeft($slice, 1)
			Case "3"
				$tempvectstr1 &= $pixel[0] & "," & $pixel[1] & "|"
			Case "4"
				$tempvectstr2 &= $pixel[0] & "," & $pixel[1] & "|"
			Case Else
				SetDebugLog("TOP RIGHT: Skip slice " & $slice & " at " & $pixel[0] & ", " & $pixel[1])
		EndSwitch
	Next
	If StringLen($tempvectstr1) > 0 Then $tempvectstr1 = StringLeft($tempvectstr1, StringLen($tempvectstr1) - 1)
	If StringLen($tempvectstr2) > 0 Then $tempvectstr2 = StringLeft($tempvectstr2, StringLen($tempvectstr2) - 1)
	$g_aiPixelTopRightDOWNDropLine = GetListPixel($tempvectstr1, ",", "TR-DOWN")
	$g_aiPixelTopRightUPDropLine = GetListPixel($tempvectstr2, ",", "TR-UP")

	;-- BOTTOM LEFT
	Local $tempvectstr1 = ""
	Local $tempvectstr2 = ""
	For $i = 0 To UBound($g_aiPixelBottomLeftDropLine) - 1
		Local $pixel = $g_aiPixelBottomLeftDropLine[$i]
		Local $slice = Slice8($pixel)
		Switch StringLeft($slice, 1)
			Case "8"
				$tempvectstr1 &= $pixel[0] & "," & $pixel[1] & "|"
			Case "7"
				$tempvectstr2 &= $pixel[0] & "," & $pixel[1] & "|"
			Case Else
				SetDebugLog("BOTTOM LEFT: Skip slice " & $slice & " at " & $pixel[0] & ", " & $pixel[1])
		EndSwitch
	Next
	If StringLen($tempvectstr1) > 0 Then $tempvectstr1 = StringLeft($tempvectstr1, StringLen($tempvectstr1) - 1)
	If StringLen($tempvectstr2) > 0 Then $tempvectstr2 = StringLeft($tempvectstr2, StringLen($tempvectstr2) - 1)
	$g_aiPixelBottomLeftDOWNDropLine = GetListPixel($tempvectstr1, ",", "BL-DOWN")
	$g_aiPixelBottomLeftUPDropLine = GetListPixel($tempvectstr2, ",", "BL-UP")

	;-- BOTTOM RIGHT
	Local $tempvectstr1 = ""
	Local $tempvectstr2 = ""
	For $i = 0 To UBound($g_aiPixelBottomRightDropLine) - 1
		Local $pixel = $g_aiPixelBottomRightDropLine[$i]
		Local $slice = Slice8($pixel)
		Switch StringLeft($slice, 1)
			Case "1"
				$tempvectstr1 &= $pixel[0] & "," & $pixel[1] & "|"
			Case "2"
				$tempvectstr2 &= $pixel[0] & "," & $pixel[1] & "|"
			Case Else
				SetDebugLog("BOTTOM RIGHT: Skip slice " & $slice & " at " & $pixel[0] & ", " & $pixel[1])
		EndSwitch
	Next
	If StringLen($tempvectstr1) > 0 Then $tempvectstr1 = StringLeft($tempvectstr1, StringLen($tempvectstr1) - 1)
	If StringLen($tempvectstr2) > 0 Then $tempvectstr2 = StringLeft($tempvectstr2, StringLen($tempvectstr2) - 1)
	$g_aiPixelBottomRightDOWNDropLine = GetListPixel($tempvectstr1, ",", "BR-DOWN")
	$g_aiPixelBottomRightUPDropLine = GetListPixel($tempvectstr2, ",", "BR-UP")
	SetLog("> Drop Lines located in  " & Round(__timerdiff($hTimer) / 1000, 2) & " seconds", $COLOR_INFO)
	If _Sleep($DELAYRESPOND) Then Return

	; 03 - TOWNHALL ------------------------------------------------------------------------

	If $g_bCSVLocateStorageTownHall = True Then
		If $g_iSearchTH = "-" Or $g_oBldgAttackInfo.Exists($eBldgTownHall & "_LOCATION") = False Then ; If TH is unknown, try again to find as it is needed by script
			imglocTHSearch(True, False, False)
		Else
			SetLog("> Townhall has already been located in while searching for an image", $COLOR_INFO)
		EndIf
	Else
		SetLog("> Townhall search not needed, skip")
	EndIf
	If _Sleep($DELAYRESPOND) Then Return

	;04 - MINES, COLLECTORS, DRILLS -----------------------------------------------------------------------------------------------------------------------

	;reset variables
	Global $g_aiPixelMine[0]
	Global $g_aiPixelElixir[0]
	Global $g_aiPixelDarkElixir[0]
	Local $g_aiPixelNearCollectorTopLeftSTR = ""
	Local $g_aiPixelNearCollectorBottomLeftSTR = ""
	Local $g_aiPixelNearCollectorTopRightSTR = ""
	Local $g_aiPixelNearCollectorBottomRightSTR = ""

	; Team AIO Mod++
	Local $bCapturedMine = False

	;04.01 If drop troop near gold mine
	If $g_bCSVLocateMine Then
		$hTimer = __timerinit()

		; Team AIO Mod++
		If $bCapturedMine = False Then
			_CaptureRegion2()
			$bCapturedMine = True
		EndIf

		$g_aiPixelMine = GetLocationMine(False) ; Team AIO Mod++
		If _Sleep($DELAYRESPOND) Then Return
		CleanRedArea($g_aiPixelMine)
		Local $htimerMine = Round(__timerdiff($hTimer) / 1000, 2)
		If (IsArray($g_aiPixelMine)) Then
			For $i = 0 To UBound($g_aiPixelMine) - 1
				Local $pixel = $g_aiPixelMine[$i]
				Local $str = $pixel[0] & "-" & $pixel[1] & "-" & "MINE"
				If isInsideDiamond($pixel) Then
					If $pixel[0] <= $InternalArea[2][0] Then
						If $pixel[1] <= $InternalArea[0][1] Then
							;SetLog($str & " :  TOP LEFT SIDE")
							$g_aiPixelNearCollectorTopLeftSTR &= $str & "|"
						Else
							;SetLog($str & " :  BOTTOM LEFT SIDE")
							$g_aiPixelNearCollectorBottomLeftSTR &= $str & "|"
						EndIf
					Else
						If $pixel[1] <= $InternalArea[0][1] Then
							;SetLog($str & " :  TOP RIGHT SIDE")
							$g_aiPixelNearCollectorTopRightSTR &= $str & "|"
						Else
							;SetLog($str & " :  BOTTOM RIGHT SIDE")
							$g_aiPixelNearCollectorBottomRightSTR &= $str & "|"
						EndIf
					EndIf
				EndIf
			Next
		EndIf
		SetLog("> Mines located in " & Round(__timerdiff($hTimer) / 1000, 2) & " seconds", $COLOR_INFO)
	Else
		SetLog("> Mines detection not needed, skip", $COLOR_INFO)
	EndIf
	If _Sleep($DELAYRESPOND) Then Return

	;04.02  If drop troop near elisir
	If $g_bCSVLocateElixir Then
		$hTimer = __timerinit()

		; Team AIO Mod++
		If $bCapturedMine = False Then
			_CaptureRegion2()
			$bCapturedMine = True
		EndIf

		$g_aiPixelElixir = GetLocationElixir(False) ; Team AIO Mod++
		If _Sleep($DELAYRESPOND) Then Return
		CleanRedArea($g_aiPixelElixir)
		Local $htimerMine = Round(__timerdiff($hTimer) / 1000, 2)
		If (IsArray($g_aiPixelElixir)) Then
			For $i = 0 To UBound($g_aiPixelElixir) - 1
				Local $pixel = $g_aiPixelElixir[$i]
				Local $str = $pixel[0] & "-" & $pixel[1] & "-" & "ELIXIR"
				If isInsideDiamond($pixel) Then
					If $pixel[0] <= $InternalArea[2][0] Then
						If $pixel[1] <= $InternalArea[0][1] Then
							;SetLog($str & " :  TOP LEFT SIDE")
							$g_aiPixelNearCollectorTopLeftSTR &= $str & "|"
						Else
							;SetLog($str & " :  BOTTOM LEFT SIDE")
							$g_aiPixelNearCollectorBottomLeftSTR &= $str & "|"
						EndIf
					Else
						If $pixel[1] <= $InternalArea[0][1] Then
							;SetLog($str & " :  TOP RIGHT SIDE")
							$g_aiPixelNearCollectorTopRightSTR &= $str & "|"
						Else
							;SetLog($str & " :  BOTTOM RIGHT SIDE")
							$g_aiPixelNearCollectorBottomRightSTR &= $str & "|"
						EndIf
					EndIf
				EndIf
			Next
		EndIf
		SetLog("> Elixir collectors located in " & Round(__timerdiff($hTimer) / 1000, 2) & " seconds", $COLOR_INFO)
	Else
		SetLog("> Elixir collectors detection not needed, skip", $COLOR_INFO)
	EndIf
	If _Sleep($DELAYRESPOND) Then Return

	;04.03 If drop troop near drill
	If $g_bCSVLocateDrill Then
		;SetLog("Locating drills")
		$hTimer = __timerinit()

		; Team AIO Mod++
		If $bCapturedMine = False Then
			_CaptureRegion2()
			$bCapturedMine = True
		EndIf

		$g_aiPixelDarkElixir = GetLocationDarkElixir(False) ; Team AIO Mod++
		If _Sleep($DELAYRESPOND) Then Return
		CleanRedArea($g_aiPixelDarkElixir)
		Local $htimerMine = Round(__timerdiff($hTimer) / 1000, 2)
		If (IsArray($g_aiPixelDarkElixir)) Then
			For $i = 0 To UBound($g_aiPixelDarkElixir) - 1
				Local $pixel = $g_aiPixelDarkElixir[$i]
				Local $str = $pixel[0] & "-" & $pixel[1] & "-" & "DRILL"
				If isInsideDiamond($pixel) Then
					If $pixel[0] <= $InternalArea[2][0] Then
						If $pixel[1] <= $InternalArea[0][1] Then
							;SetLog($str & " :  TOP LEFT SIDE")
							$g_aiPixelNearCollectorTopLeftSTR &= $str & "|"
						Else
							;SetLog($str & " :  BOTTOM LEFT SIDE")
							$g_aiPixelNearCollectorBottomLeftSTR &= $str & "|"
						EndIf
					Else
						If $pixel[1] <= $InternalArea[0][1] Then
							;SetLog($str & " :  TOP RIGHT SIDE")
							$g_aiPixelNearCollectorTopRightSTR &= $str & "|"
						Else
							;SetLog($str & " :  BOTTOM RIGHT SIDE")
							$g_aiPixelNearCollectorBottomRightSTR &= $str & "|"
						EndIf
					EndIf
				EndIf
			Next
		EndIf
		SetLog("> Drills located in " & Round(__timerdiff($hTimer) / 1000, 2) & " seconds", $COLOR_INFO)
	Else
		SetLog("> Drills detection not needed, skip", $COLOR_INFO)
	EndIf
	If _Sleep($DELAYRESPOND) Then Return

	If StringLen($g_aiPixelNearCollectorTopLeftSTR) > 0 Then $g_aiPixelNearCollectorTopLeftSTR = StringLeft($g_aiPixelNearCollectorTopLeftSTR, StringLen($g_aiPixelNearCollectorTopLeftSTR) - 1)
	If StringLen($g_aiPixelNearCollectorTopRightSTR) > 0 Then $g_aiPixelNearCollectorTopRightSTR = StringLeft($g_aiPixelNearCollectorTopRightSTR, StringLen($g_aiPixelNearCollectorTopRightSTR) - 1)
	If StringLen($g_aiPixelNearCollectorBottomLeftSTR) > 0 Then $g_aiPixelNearCollectorBottomLeftSTR = StringLeft($g_aiPixelNearCollectorBottomLeftSTR, StringLen($g_aiPixelNearCollectorBottomLeftSTR) - 1)
	If StringLen($g_aiPixelNearCollectorBottomRightSTR) > 0 Then $g_aiPixelNearCollectorBottomRightSTR = StringLeft($g_aiPixelNearCollectorBottomRightSTR, StringLen($g_aiPixelNearCollectorBottomRightSTR) - 1)
	$g_aiPixelNearCollectorTopLeft = GetListPixel3($g_aiPixelNearCollectorTopLeftSTR)
	$g_aiPixelNearCollectorTopRight = GetListPixel3($g_aiPixelNearCollectorTopRightSTR)
	$g_aiPixelNearCollectorBottomLeft = GetListPixel3($g_aiPixelNearCollectorBottomLeftSTR)
	$g_aiPixelNearCollectorBottomRight = GetListPixel3($g_aiPixelNearCollectorBottomRightSTR)


	; 05 - Gold, Elixir and Dark Elixir STORAGES ------------------------------------------------------------------------

	If $g_bCSVLocateStorageGold Then
		$aResult = GetLocationBuilding($eBldgGoldS, $g_iSearchTH, False)
		If $aResult <> -1 Then ; check if Monkey ate bad banana
			If $aResult = 1 Then
				SetLog("> " & $g_sBldgNames[$eBldgGoldS] & " Not found", $COLOR_WARNING)
			Else
				$aResult = _ObjGetValue($g_oBldgAttackInfo, $eBldgGoldS & "_LOCATION")
				If @error Then
					_ObjErrMsg("_ObjGetValue " & $g_sBldgNames[$eBldgGoldS] & " _LOCATION", @error) ; Log errors
					SetLog("> " & $g_sBldgNames[$eBldgGoldS] & " location not in dictionary", $COLOR_WARNING)
				Else
					If IsArray($aResult) Then $g_aiCSVGoldStoragePos = $aResult
				EndIf
			EndIf
		Else
			SetLog("Monkey ate bad banana: " & "GetLocationBuilding " & $g_sBldgNames[$eBldgGoldS], $COLOR_ERROR)
		EndIf
	EndIf

	If $g_bCSVLocateStorageElixir Then
		$aResult = GetLocationBuilding($eBldgElixirS, $g_iSearchTH, False)
		If @error And $g_bDebugSetlog Then _logErrorGetBuilding(@error)
		If $aResult <> -1 Then ; check if Monkey ate bad banana
			If $aResult = 1 Then
				SetLog("> " & $g_sBldgNames[$eBldgElixirS] & " Not found", $COLOR_WARNING)
			Else
				$aResult = _ObjGetValue($g_oBldgAttackInfo, $eBldgElixirS & "_LOCATION")
				If @error Then
					_ObjErrMsg("_ObjGetValue " & $g_sBldgNames[$eBldgElixirS] & " _LOCATION", @error) ; Log errors
					SetLog("> " & $g_sBldgNames[$eBldgElixirS] & " location not in dictionary", $COLOR_WARNING)
				Else
					If IsArray($aResult) Then $g_aiCSVElixirStoragePos = $aResult
				EndIf
			EndIf
		Else
			SetLog("Monkey ate bad banana: " & "GetLocationBuilding " & $g_sBldgNames[$eBldgElixirS], $COLOR_ERROR)
		EndIf
	EndIf

	If $g_bCSVLocateStorageDarkElixir = True Then
		$hTimer = __timerinit()
		; SuspendAndroid()
		; USES OLD OPENCV DETECTION
		Local $g_aiPixelDarkElixirStorage = GetLocationDarkElixirStorageWithLevel()
		; ResumeAndroid()
		If _Sleep($DELAYRESPOND) Then Return
		CleanRedArea($g_aiPixelDarkElixirStorage)
		Local $pixel = StringSplit($g_aiPixelDarkElixirStorage, "#", 2)
		If UBound($pixel) >= 2 Then
			Local $pixellevel = $pixel[0]
			Local $pixelpos = StringSplit($pixel[1], "-", 2)
			If UBound($pixelpos) >= 2 Then
				Local $temp = [Int($pixelpos[0]), Int($pixelpos[1])]
				$g_aiCSVDarkElixirStoragePos = $temp
			EndIf
		EndIf
		SetLog("> Dark Elixir Storage located in " & Round(__timerdiff($hTimer) / 1000, 2) & " seconds", $COLOR_INFO)
	Else
		SetLog("> Dark Elixir Storage detection not needed, skip", $COLOR_INFO)
	EndIf

	; 06 - EAGLE ARTILLERY ------------------------------------------------------------------------

	$g_aiCSVEagleArtilleryPos = "" ; reset pixel position to null

	If $g_bCSVLocateEagle = True Then ; eagle find required?
		If $g_iSearchTH = "-" Or $g_iSearchTH > 10 Then ; TH level where eagle exists?
			If _ObjSearch($g_oBldgAttackInfo, $eBldgEagle & "_LOCATION") = False Then ; get data if not already exist?
				$aResult = GetLocationBuilding($eBldgEagle, $g_iSearchTH, False)
				If $aResult = -1 Then SetLog("Monkey ate bad banana: " & "GetLocationBuilding " & $g_sBldgNames[$eBldgEagle], $COLOR_ERROR)
			EndIf
			$aResult = _ObjGetValue($g_oBldgAttackInfo, $eBldgEagle & "_LOCATION")
			If @error Then
				_ObjErrMsg("_ObjGetValue " & $g_sBldgNames[$eBldgEagle] & " _LOCATION", @error) ; Log errors
				SetLog("> " & $g_sBldgNames[$eBldgEagle] & " location not in dictionary", $COLOR_WARNING)
			Else
				If IsArray($aResult[0]) Then $g_aiCSVEagleArtilleryPos = $aResult[0]
			EndIf
		Else
			SetLog("> TH Level to low for Eagle, skip detection", $COLOR_INFO)
		EndIf
	Else
		SetDebugLog("> Eagle Artillery detection not needed, skipping", $COLOR_DEBUG)
	EndIf

	; 07 - Scatter Shot ------------------------------------------------------------------------

	$g_aiCSVScatterPos = "" ; reset pixel position to null

	If $g_bCSVLocateScatter Then
		If $g_iSearchTH = "-" Or $g_iSearchTH > 10 Then
			If Not _ObjSearch($g_oBldgAttackInfo, $eBldgScatter & "_LOCATION") Then ; get data if not already exist?
				$aResult = GetLocationBuilding($eBldgScatter, $g_iSearchTH, False)
				If $aResult = -1 Then SetLog("Monkey ate bad banana: " & "GetLocationBuilding " & $g_sBldgNames[$eBldgScatter], $COLOR_ERROR)
			EndIf
			$aResult = _ObjGetValue($g_oBldgAttackInfo, $eBldgScatter & "_LOCATION")
			If @error Then
				_ObjErrMsg("_ObjGetValue " & $g_sBldgNames[$eBldgScatter] & " _LOCATION", @error) ; Log errors
				SetLog("> " & $g_sBldgNames[$eBldgScatter] & " location not in dictionary", $COLOR_WARNING)
			Else
				If IsArray($aResult[0]) Then $g_aiCSVEagleArtilleryPos = $aResult[0]
			EndIf
		Else
			SetLog("> TH Level to low for Scatter Shot, skip detection", $COLOR_INFO)
		EndIf
	Else
		SetDebugLog("> Scatter Shot detection not needed, skipping", $COLOR_DEBUG)
	EndIf

	; 08 - Inferno ------------------------------------------------------------------------

	$g_aiCSVInfernoPos = "" ; reset location array?

	If $g_bCSVLocateInferno Then
		If $g_iSearchTH = "-" Or $g_iSearchTH > 9 Then
			If Not _ObjSearch($g_oBldgAttackInfo, $eBldgInferno & "_LOCATION") Then
				$aResult = GetLocationBuilding($eBldgInferno, $g_iSearchTH, False)
				If $aResult = -1 Then SetLog("Monkey ate bad banana: " & "GetLocationBuilding " & $g_sBldgNames[$eBldgInferno], $COLOR_ERROR)
			EndIf
			$aResult = _ObjGetValue($g_oBldgAttackInfo, $eBldgInferno & "_LOCATION")
			If @error Then
				_ObjErrMsg("_ObjGetValue " & $g_sBldgNames[$eBldgInferno] & " _LOCATION", @error) ; Log errors
				SetLog("> " & $g_sBldgNames[$eBldgInferno] & " location not in dictionary", $COLOR_WARNING)
			Else
				If IsArray($aResult) Then $g_aiCSVInfernoPos = $aResult
			EndIf
		Else
			SetLog("> TH Level to low for Inferno, ignore location", $COLOR_INFO)
		EndIf
	Else
		SetDebugLog("> Inferno detection not needed, skipping", $COLOR_DEBUG)
	EndIf

	; 09 - X-Bow ------------------------------------------------------------------------

	$g_aiCSVXBowPos = "" ; reset location array?

	If $g_bCSVLocateXBow Then
		If $g_iSearchTH = "-" Or $g_iSearchTH > 8 Then
			If Not _ObjSearch($g_oBldgAttackInfo, $eBldgXBow & "_LOCATION") Then
				$aResult = GetLocationBuilding($eBldgXBow, $g_iSearchTH, False)
				If $aResult = -1 Then SetLog("Monkey ate bad banana: " & "GetLocationBuilding " & $g_sBldgNames[$eBldgXBow], $COLOR_ERROR)
			EndIf
			$aResult = _ObjGetValue($g_oBldgAttackInfo, $eBldgXBow & "_LOCATION")
			If @error Then
				_ObjErrMsg("_ObjGetValue " & $g_sBldgNames[$eBldgXBow] & " _LOCATION", @error) ; Log errors
				SetLog("> " & $g_sBldgNames[$eBldgXBow] & " location not in dictionary", $COLOR_WARNING)
			Else
				If IsArray($aResult) Then $g_aiCSVXBowPos = $aResult
			EndIf
		Else
			SetLog("> TH Level to low for " & $g_sBldgNames[$eBldgXBow] & " , ignore location", $COLOR_INFO)
		EndIf
	Else
		SetDebugLog("> " & $g_sBldgNames[$eBldgXBow] & " detection not needed, skipping", $COLOR_DEBUG)
	EndIf


	; 10 - Wizard Tower -----------------------------------------------------------------

	$g_aiCSVWizTowerPos = "" ; reset location array?

	If $g_bCSVLocateWizTower Then
		If Not _ObjSearch($g_oBldgAttackInfo, $eBldgWizTower & "_LOCATION") Then
			$aResult = GetLocationBuilding($eBldgWizTower, $g_iSearchTH, False)
			If $aResult = -1 Then SetLog("Monkey ate bad banana: " & "GetLocationBuilding " & $g_sBldgNames[$eBldgWizTower], $COLOR_ERROR)
		EndIf
		$aResult = _ObjGetValue($g_oBldgAttackInfo, $eBldgWizTower & "_LOCATION")
		If @error Then
			_ObjErrMsg("_ObjGetValue " & $g_sBldgNames[$eBldgWizTower] & " _LOCATION", @error) ; Log errors
			SetLog("> " & $g_sBldgNames[$eBldgWizTower] & " location not in dictionary", $COLOR_WARNING)
		Else
			If IsArray($aResult) Then $g_aiCSVWizTowerPos = $aResult
		EndIf
	Else
		SetDebugLog("> " & $g_sBldgNames[$eBldgWizTower] & " detection not needed, skipping", $COLOR_DEBUG)
	EndIf

	; 11 - Mortar ------------------------------------------------------------------------

	$g_aiCSVMortarPos = "" ; reset location array?

	If $g_bCSVLocateMortar Then
		If Not _ObjSearch($g_oBldgAttackInfo, $eBldgMortar & "_LOCATION") Then
			$aResult = GetLocationBuilding($eBldgMortar, $g_iSearchTH, False)
			If $aResult = -1 Then SetLog("Monkey ate bad banana: " & "GetLocationBuilding " & $g_sBldgNames[$eBldgMortar], $COLOR_ERROR)
		EndIf
		$aResult = _ObjGetValue($g_oBldgAttackInfo, $eBldgMortar & "_LOCATION")
		If @error Then
			_ObjErrMsg("_ObjGetValue " & $g_sBldgNames[$eBldgMortar] & " _LOCATION", @error) ; Log errors
			SetLog("> " & $g_sBldgNames[$eBldgMortar] & " location not in dictionary", $COLOR_WARNING)
		Else
			If IsArray($aResult) Then $g_aiCSVMortarPos = $aResult
		EndIf
	Else
		SetDebugLog("> " & $g_sBldgNames[$eBldgMortar] & " detection not needed, skipping", $COLOR_DEBUG)
	EndIf

	; 12 - Air Defense ------------------------------------------------------------------------

	$g_aiCSVAirDefensePos = "" ; reset location array?

	If $g_bCSVLocateAirDefense Then
		If Not _ObjSearch($g_oBldgAttackInfo, $eBldgAirDefense & "_LOCATION") Then
			$aResult = GetLocationBuilding($eBldgAirDefense, $g_iSearchTH, False)
			If $aResult = -1 Then SetLog("Monkey ate bad banana: " & "GetLocationBuilding " & $g_sBldgNames[$eBldgAirDefense], $COLOR_ERROR)
		EndIf
		$aResult = _ObjGetValue($g_oBldgAttackInfo, $eBldgAirDefense & "_LOCATION")
		If @error Then
			_ObjErrMsg("_ObjGetValue " & $g_sBldgNames[$eBldgAirDefense] & " _LOCATION", @error) ; Log errors
			SetLog("> " & $g_sBldgNames[$eBldgAirDefense] & " location not in dictionary", $COLOR_WARNING)
		Else
			If IsArray($aResult) Then $g_aiCSVAirDefensePos = $aResult
		EndIf
	Else
		SetDebugLog("> " & $g_sBldgNames[$eBldgAirDefense] & " detection not needed, skipping", $COLOR_DEBUG)
	EndIf

	; Calculate main attack side
	ParseAttackCSV_MainSide()

	; 13 - Wall
	If $g_bCSVLocateWall Then
		Local $aCSVExternalWall[1], $aCSVInternalWall[1]
		If FindWallCSV($aCSVExternalWall, $aCSVInternalWall) Then
			_ObjAdd($g_oBldgAttackInfo, $eExternalWall & "_LOCATION", $aCSVExternalWall) ; save array of locations
			If @error Then _ObjErrMsg("_ObjAdd " & $g_sBldgNames[$eExternalWall] & " _LOCATION", @error) ; Log errors
			_ObjAdd($g_oBldgAttackInfo, $eInternalWall & "_LOCATION", $aCSVInternalWall) ; save array of locations
			If @error Then _ObjErrMsg("_ObjAdd " & $g_sBldgNames[$eInternalWall] & " _LOCATION", @error) ; Log errors
		EndIf
	EndIf

	; Log total CSV prep time
	SetLog(">> Total time: " & Round(__timerdiff($hTimerTOTAL) / 1000, 2) & " seconds", $COLOR_INFO)

	; 14 - DEBUGIMAGE ------------------------------------------------------------------------
	If $g_bDebugMakeIMGCSV Then AttackCSVDEBUGIMAGE() ;make IMG debug
	If $g_bDebugAttackCSV Then _LogObjList($g_oBldgAttackInfo) ; display dictionary for raw find image debug

	; 15 - LAUNCH PARSE FUNCTION -------------------------------------------------------------
	SetSlotSpecialTroops()
	If _Sleep($DELAYRESPOND) Then Return

	ParseAttackCSV($testattack)

	CheckHeroesHealth()
EndFunc   ;==>Algorithm_AttackCSV

Func FindWallCSV(ByRef $aCSVExternalWall, ByRef $aCSVInternalWall)
	SetLog("Searching for wall location")

	Local $aOuterWall[2], $aInnerWall[2], $bResult = False
	Local $aiWallPos[1][3] ; x, y, distance to edge
	Local $aEdgeCoord[2], $aCenterCoord[2] = [$ExternalArea[2][0], $ExternalArea[0][1]]

	For $i = 0 To UBound($ExternalArea) - 1
		If $MAINSIDE = $ExternalArea[$i][2] Then
			$aEdgeCoord[0] = Number($ExternalArea[$i][0])
			$aEdgeCoord[1] = Number($ExternalArea[$i][1])
			ExitLoop
		EndIf
	Next

	If $g_bDebugImageSave Then
		_CaptureRegion2()
		; Create the necessery GDI stuff
		Local $subDirectory = $g_sProfileTempDebugPath & "CSVWall"
		DirCreate($subDirectory)
		Local $Date = @YEAR & "-" & @MON & "-" & @MDAY
		Local $Time = @HOUR & "." & @MIN & "." & @SEC
		Local $filename = String($Date & "_" & $Time & "_.png")
		Local $editedImage = _GDIPlus_BitmapCreateFromHBITMAP($g_hHBitmap2)
		Local $hGraphic = _GDIPlus_ImageGetGraphicsContext($editedImage)
		Local $hPenRED = _GDIPlus_PenCreate(0xFFFF0000, 3) ; Create a pencil Color FF0000/RED
		Local $hPenBLUE = _GDIPlus_PenCreate(0xFF0000FF, 2)
	EndIf

	For $i = 0 To 2 ; 3 rectangulars from edge to center
		Local $X1 = Int($aEdgeCoord[0] + $i * ($aEdgeCoord[0] < $aCenterCoord[0] ? 63 : -63))
		Local $Y1 = Int($aEdgeCoord[1] + $i * ($aEdgeCoord[1] < $aCenterCoord[1] ? 47 : -47))
		Local $X2 = Int($X1 + ($aEdgeCoord[0] < $aCenterCoord[0] ? 80 : -80))
		Local $Y2 = Int($Y1 + ($aEdgeCoord[1] < $aCenterCoord[1] ? 60 : -60))

		_CaptureRegion2(_Min($X1, $X2), _Min($Y1, $Y2), _Max($X1, $X2), _Max($Y1, $Y2))
		Local $FoundWalls = imglocFindWalls("AnyWallLevel", "FV", "FV", 10)

		If $g_bDebugImageSave Then _GDIPlus_GraphicsDrawRect($hGraphic, _Min($X1, $X2), _Min($Y1, $Y2), Abs($X1 - $X2), Abs ($Y1 - $Y2), $hPenBLUE)

		If $FoundWalls[0] = "" Then ; nothing found
			SetDebugLog("No wall(s) found in section " & $i + 1)
		Else
			Local $sWallString = _ArrayToString($FoundWalls)
			Local $aWallCoordsArray = decodeMultipleCoords($sWallString, 7, 7)
			SetDebugLog("Found " & UBound($aWallCoordsArray) & " walls in section " & $i + 1 & ": " & $sWallString)

			For $j = 0 To UBound($aWallCoordsArray) - 1
				Local $aTempPos = $aWallCoordsArray[$j]
				Local $index = UBound($aiWallPos) - 1
				$aiWallPos[$index][0] = $aTempPos[0] + _Min($X1, $X2)
				$aiWallPos[$index][1] = $aTempPos[1] + _Min($Y1, $Y2)
				$aiWallPos[$index][2] = Int(Sqrt(($aiWallPos[$index][0] - $aEdgeCoord[0]) ^ 2 + ($aiWallPos[$index][1] - $aEdgeCoord[1]) ^ 2))
				ReDim $aiWallPos[UBound($aiWallPos) + 1][3]
				If $g_bDebugImageSave Then _GDIPlus_GraphicsDrawEllipse($hGraphic, $aiWallPos[$index][0], $aiWallPos[$index][1], 3, 3, $hPenBLUE)
			Next
		EndIf
	Next

	If UBound($aiWallPos) > 1 And $aiWallPos[0][0] <> "" Then
		_ArraySort($aiWallPos, 0, 0, 0, 2)
		_ArrayDelete($aiWallPos, 0) ; remove 1st "" element
		SetDebugLog(@CRLF & _ArrayToString($aiWallPos))

		$aOuterWall[0] = $aiWallPos[0][0]
		$aOuterWall[1] = $aiWallPos[0][1]

		For $i = 0 To UBound($aiWallPos) - 1
			If $i = 0 Then ContinueLoop
			If $aiWallPos[$i][2] - $aiWallPos[0][2] >= 40 Then
				$aInnerWall[0] = $aiWallPos[$i][0]
				$aInnerWall[1] = $aiWallPos[$i][1]
				ExitLoop
			EndIf
		Next

		Setlog("External Wall: " & _ArrayToString($aOuterWall) & " , Internal Wall: " & _ArrayToString($aInnerWall))
		If $aOuterWall[0] <> "" Then
			$aCSVExternalWall[0] = $aOuterWall
			$aCSVInternalWall[0] = $aInnerWall
			If $g_bDebugImageSave Then
				_GDIPlus_GraphicsDrawEllipse($hGraphic, $aOuterWall[0], $aOuterWall[1], 3, 3, $hPenRED)
				_GDIPlus_GraphicsDrawEllipse($hGraphic, $aInnerWall[0], $aInnerWall[1], 3, 3, $hPenRED)
			EndIf
			$bResult = True
		EndIf
	Else
		SetLog("No wall found")
	EndIf
	If $g_bDebugImageSave Then
		; Destroy the used GDI stuff
		_GDIPlus_ImageSaveToFile($editedImage, $subDirectory & "\" & $filename)
		_GDIPlus_PenDispose($hPenRED)
		_GDIPlus_GraphicsDispose($hGraphic)
		_GDIPlus_BitmapDispose($editedImage)
	EndIf

	Return $bResult
EndFunc


Func CSVRandomization($bDebug = False)
	If $g_bDebugSetlog = True Or $bDebug = True Then SetLog("[CSVRandomization] Start")
	lOCAL $g_sAttackScrScriptName1[2], $g_sAttackScrScriptName2[2]

	Local $sFilePath = ""
	Local $aRandom[3]
	Local $aModes[2] = [$DB, $LB]
	Local $aiExtraCSVRandomDB[3] = [$g_sAttackScrScriptName[$DB], $g_sAttackScrScriptName1[$DB], $g_sAttackScrScriptName2[$DB]]
	Local $aiExtraCSVRandomAB[3] = [$g_sAttackScrScriptName[$LB], $g_sAttackScrScriptName1[$LB], $g_sAttackScrScriptName2[$LB]]

	For $i = 0 To UBound($aModes) - 1
		$sFilePath = ""

		Switch $aModes[$i]
			Case $DB
				$aRandom = $aiExtraCSVRandomDB
			Case $LB
				$aRandom = $aiExtraCSVRandomAB
			Case Else
				SetLog("[CSVRandomization] Wrong mode")
				ExitLoop
		EndSwitch

		_ArrayShuffle($aRandom)

		If $bDebug = True Then _ArrayDisplay($aRandom)

		For $ia = 0 To UBound($aRandom) -1
			$sFilePath = $g_sAttackScrScriptName & "\" & $aRandom[$ia]
			If FileExists($sFilePath) Then ExitLoop
			$sFilePath = ""
		Next

		If $sFilePath = "" Then
			SetLog("[CSVRandomization] No random script found", $COLOR_ERROR)
			ContinueLoop
		EndIf

		If $g_bDebugSetlog = True Or $bDebug = True Then SetLog("[CSVRandomization] Randomized CSV file: " & String($sFilePath), $COLOR_SUCCESS)
		If $bDebug = False Then $g_sAttackScrScriptName[$aModes[$i]] = $aRandom[$ia]
	Next

EndFunc
