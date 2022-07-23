; #FUNCTION# ====================================================================================================================
; Name ..........: BuilderBaseImageDetection
; Description ...: Use on Builder Base attack , Get Points to Deploy , Get buildings etc
; Syntax ........: Several
; Parameters ....:
; Return values .: None
; Author ........: ProMac (03-2018), Fahid.Mahmood
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as Multibot and ClashGameBot. Copyright 2015-2020
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Func TestBuilderBaseBuildingsDetection()
	Setlog("** TestBuilderBaseBuildingsDetection START**", $COLOR_DEBUG)
	Local $Status = $g_bRunState
	$g_bRunState = True
	; Reset the Boat Position , only in tests
	Local $SelectedItem = _GUICtrlComboBox_GetCurSel($g_cmbBuildings)
	Local $temp = BuilderBaseBuildingsDetection($SelectedItem)
	For $i = 0 To UBound($temp) - 1
		Setlog(" - " & $temp[$i][0] & " - " & $temp[$i][3] & " - " & $temp[$i][1] & "x" & $temp[$i][2])
	Next
	DebugBuilderBaseBuildingsDetection2($temp)
	$g_bRunState = $Status
	Setlog("** TestBuilderBaseBuildingsDetection END**", $COLOR_DEBUG)
EndFunc   ;==>TestBuilderBaseBuildingsDetection

Func TestBuilderBaseGetDeployPoints()
	Setlog("** TestBuilderBaseGetDeployPoints START**", $COLOR_DEBUG)
	Local $Status = $g_bRunState
	$g_bRunState = True
	; Reset the Boat Position , only in tests
	Local $FurtherFrom = 5 ; 5 pixels before the deploy point
	BuilderBaseGetDeployPoints($FurtherFrom, True)
	$g_bRunState = $Status
	Setlog("** TestBuilderBaseGetDeployPoints END**", $COLOR_DEBUG)
EndFunc   ;==>TestBuilderBaseGetDeployPoints

Func builderbasegetdeploypoints($furtherfrom = 5, $bDebug = False)
	If Not $g_brunstate Then Return 
	Local $debuglog
	If $g_bDebugBBattack OR $bDebug Then $debuglog = True


	Local $DeployPoints[4]
	Local $Name[4] = ["TopLeft", "TopRight", "BottomRight", "BottomLeft"]
	Local $hstarttime = __timerinit()
	
	; Custom
	$g_aBuilderHallPos = UpdateBHPos()
	
	Local $deploypointsresult = DMClassicArray(DFind($g_sBundleDeployPointsBBD, 0, 0, 0, 0, 0, 0, 1000, True), 10, ($g_bDebugImageSave Or $debuglog))
	If $deploypointsresult <> -1 And UBound($deploypointsresult) > 0 Then
		Local $topleft[0][2], $topright[0][2], $bottomright[0][2], $bottomleft[0][2]
		Local $point[2], $local = ""
		For $i = 0 To UBound($deploypointsresult) - 1
			$point[0] = Int($deploypointsresult[$i][1])
			$point[1] = Int($deploypointsresult[$i][2])
			SetDebugLog("[" & $i & "]Deploy Point: (" & $point[0] & "," & $point[1] & ")")
			$local = deploypointsposition($point)
			SetDebugLog("[" & $i & "]Deploy Local: (" & $local & ")")
			Select 
				Case $local = "TopLeft"
					ReDim $topleft[UBound($topleft) + 1][2]
					$topleft[UBound($topleft) - 1][0] = $point[0] - $furtherfrom
					$topleft[UBound($topleft) - 1][1] = $point[1] - $furtherfrom
				Case $local = "TopRight"
					ReDim $topright[UBound($topright) + 1][2]
					$topright[UBound($topright) - 1][0] = $point[0] + $furtherfrom
					$topright[UBound($topright) - 1][1] = $point[1] - $furtherfrom
				Case $local = "BottomRight"
					ReDim $bottomright[UBound($bottomright) + 1][2]
					$bottomright[UBound($bottomright) - 1][0] = $point[0] + $furtherfrom
					$bottomright[UBound($bottomright) - 1][1] = $point[1] + $furtherfrom
				Case $local = "BottomLeft"
					ReDim $bottomleft[UBound($bottomleft) + 1][2]
					$bottomleft[UBound($bottomleft) - 1][0] = $point[0] - $furtherfrom
					$bottomleft[UBound($bottomleft) - 1][1] = $point[1] + $furtherfrom
			EndSelect
		Next
		Local $sides[4] = [$topleft, $topright, $bottomright, $bottomleft]
		For $i = 0 To 3
			If Not $g_brunstate Then Return 
			SetLog($Name[$i] & " points: " & UBound($sides[$i]))
			$DeployPoints[$i] = $sides[$i]
		Next
	Else
		If $g_bDebugImageSave Then SaveDebugImage("DeployPoints")
		SetLog("Deploy Points detection Error!", $COLOR_ERROR)
		Return -1
	EndIf
	SetLog("Builder Base Internal Deploy Points: " & Round(__timerdiff($hstarttime) / 1000, 2) & " seconds", $color_debug)
	$hstarttime = __timerinit()

	$g_aBuilderBaseDiamond = BuilderBaseAttackDiamond()
	$g_aBuilderBaseOuterDiamond = BuilderBaseAttackOuterDiamond()
	
	If $g_aBuilderBaseDiamond = -1 Then
		If $g_bDebugImageSave Then SaveDebugImage("DeployPoints")
		SetLog("Deploy $g_aBuilderBaseDiamond - Points detection Error!", $COLOR_ERROR)
		$g_aExternalEdges = builderbasegetfakeedges()
	Else
		$g_aExternalEdges = builderbasegetedges($g_aBuilderBaseDiamond, "External Edges")
	EndIf
	If $g_aBuilderBaseOuterDiamond = -1 Then
		If $g_bDebugImageSave Then SaveDebugImage("DeployPoints")
		SetLog("Deploy $g_aBuilderBaseOuterDiamond - Points detection Error!", $COLOR_ERROR)
		$g_aOuterEdges = builderbasegetfakeedges()
	Else
		$g_aOuterEdges = builderbasegetedges($g_aBuilderBaseOuterDiamond, "Outer Edges")
	EndIf
	SetLog("Builder Base Edges Deploy Points: " & Round(__timerdiff($hstarttime) / 1000, 2) & " seconds", $color_debug)
	Local $topleft[0][2], $topright[0][2], $bottomright[0][2], $bottomleft[0][2]
	For $i = 0 To 3
		If Not $g_brunstate Then Return 
		Local $correctside = $g_aOuterEdges[$i]
		For $j = 0 To UBound($correctside) - 1
			Local $point[2] = [$correctside[$j][0], $correctside[$j][1]]
			Local $local = deploypointsposition($point)
			Select 
				Case $local = "TopLeft"
					ReDim $topleft[UBound($topleft) + 1][2]
					$topleft[UBound($topleft) - 1][0] = $point[0]
					$topleft[UBound($topleft) - 1][1] = $point[1]
				Case $local = "TopRight"
					ReDim $topright[UBound($topright) + 1][2]
					$topright[UBound($topright) - 1][0] = $point[0]
					$topright[UBound($topright) - 1][1] = $point[1]
				Case $local = "BottomRight"
					ReDim $bottomright[UBound($bottomright) + 1][2]
					$bottomright[UBound($bottomright) - 1][0] = $point[0]
					$bottomright[UBound($bottomright) - 1][1] = $point[1]
				Case $local = "BottomLeft"
					ReDim $bottomleft[UBound($bottomleft) + 1][2]
					$bottomleft[UBound($bottomleft) - 1][0] = $point[0]
					$bottomleft[UBound($bottomleft) - 1][1] = $point[1]
			EndSelect
		Next
	Next
	$g_aFinalOuter[0] = $topleft
	$g_aFinalOuter[1] = $topright
	$g_aFinalOuter[2] = $bottomright
	$g_aFinalOuter[3] = $bottomleft
	For $i = 0 To 3
		If Not $g_brunstate Then Return 
		If UBound($DeployPoints[$i]) < 10 Then
			SetLog($Name[$i] & " doesn't have enough deploy points(" & UBound($DeployPoints[$i]) & ") let's use Outer points", $color_debug)
			If UBound($DeployPoints[$i], $ubound_columns) <> UBound($g_aFinalOuter[$i], $ubound_columns) Then
				SetDebugLog("$DeployPoints Array dimension array diff from $g_aFinalOuter array", $color_debug)
				$DeployPoints[$i] = $g_aFinalOuter[$i]
			Else
				Local $tempdeploypoints = $DeployPoints[$i]
				SetDebugLog($Name[$i] & " Outer points are " & UBound($g_aFinalOuter[$i]))
				Local $tempfinalouter = $g_aFinalOuter[$i]
				For $j = 0 To UBound($tempfinalouter, $ubound_rows) - 1
					ReDim $tempdeploypoints[UBound($tempdeploypoints, $ubound_rows) + 1][2]
					$tempdeploypoints[UBound($tempdeploypoints, $ubound_rows) - 1][0] = $tempfinalouter[$j][0]
					$tempdeploypoints[UBound($tempdeploypoints, $ubound_rows) - 1][1] = $tempfinalouter[$j][1]
				Next
				$DeployPoints[$i] = $tempdeploypoints
			EndIf
			SetLog($Name[$i] & " points(" & UBound($DeployPoints[$i]) & ") after using outer one", $color_debug)
		EndIf
	Next
	Local $BestDeployPoints[4]
	For $i = 0 To 3
		_arraysort($DeployPoints[$i], 0, 0, 0, 0)
		SetDebugLog("Get the best Points for " & $Name[$i])
		$BestDeployPoints[$i] = findbestdroppoints($DeployPoints[$i])
	Next
	Local $OuterDeployPoints[4]
	For $i = 0 To 3
		_arraysort($g_aFinalOuter[$i], 0, 0, 0, 0)
		SetDebugLog("Get the best Outer Points for " & $Name[$i])
		$OuterDeployPoints[$i] = findbestdroppoints($g_aFinalOuter[$i])
	Next
	Switch $g_aBBMainSide
		Case "TopLeft"
		Case "TopRight"
			_arraysort($BestDeployPoints[0], 1, 0, 0, 0)
			_arraysort($BestDeployPoints[2], 1, 0, 0, 0)
			_arraysort($OuterDeployPoints[0], 1, 0, 0, 0)
			_arraysort($OuterDeployPoints[2], 1, 0, 0, 0)
		Case "BottomRight"
			_arraysort($BestDeployPoints[1], 1, 0, 0, 0)
			_arraysort($BestDeployPoints[3], 1, 0, 0, 0)
			_arraysort($OuterDeployPoints[1], 1, 0, 0, 0)
			_arraysort($OuterDeployPoints[3], 1, 0, 0, 0)
		Case "BottomLeft"
	EndSwitch
	SetLog("Builder Base Outer Edges Deploy Points: " & Round(__timerdiff($hstarttime) / 1000, 2) & " seconds", $color_debug)
	If $bDebug OR $g_bDebugBBattack Then debugbuilderbasebuildingsdetection($DeployPoints, $BestDeployPoints, $OuterDeployPoints, "Deploy_Points")
	If $g_bDebugBBattack Then debugbuilderbasecleanimage()
	$g_aDeployPoints = $DeployPoints
	$g_aBestDeployPoints = $BestDeployPoints
	$g_aOuterDeployPoints = $OuterDeployPoints
EndFunc

Func debugbuilderbasecleanimage()
	If $g_bDebugBBattack Then
		_captureregion2()
		Local $ssubdir = $g_sprofiletempdebugpath & "BuilderBase\Clean"
		DirCreate($ssubdir)
		Local $sdate = @YEAR & "-" & @MON & "-" & @MDAY
		Local $stime = @HOUR & "." & @MIN & "." & @SEC
		Local $sdebugimagename = String("BuilderBase_" & $sdate & "_" & $stime & ".png")
		Local $heditedimage = _gdiplus_bitmapcreatefromhbitmap($g_hhbitmap2)
		_gdiplus_imagesavetofile($heditedimage, $ssubdir & "\" & $sdebugimagename)
		_gdiplus_bitmapdispose($heditedimage)
	EndIf
EndFunc

Func FindBestDropPoints($DropPoints, $MaxDropPoint = 10)
	;Find Best 10 points 1-10 , the 5 is the Middle , 1 = closest to BuilderHall
	Local $aDeployP[0][2]
	If Not $g_bRunState Then Return
	;Just in case $DropPoints is empty
	If Not UBound($DropPoints) > 0 Then Return

	; If the points are less than MaxDrop Points then is necessary to assign max drop points
	; New code correction
	If UBound($DropPoints) < $MaxDropPoint Then $MaxDropPoint = UBound($DropPoints)

	Local $ArrayDimStep = Ceiling(UBound($DropPoints) / $MaxDropPoint)
	SetDebugLog("The array dimension step is " & $ArrayDimStep)

	ReDim $aDeployP[UBound($aDeployP) + 1][2]
	$aDeployP[UBound($aDeployP) - 1][0] = $DropPoints[0][0] ; X axis First Point
	$aDeployP[UBound($aDeployP) - 1][1] = $DropPoints[0][1] ; Y axis First Point
	SetDebugLog("First point assigned at " & $DropPoints[0][0] & "," & $DropPoints[0][1])
	; New code correction
	If $MaxDropPoint > 2 Then
		For $i = 1 To $MaxDropPoint - 2 ; e.g if $MaxDeployPoint is 10 get 2 to 9 points
			Local $DimensionTemp = $ArrayDimStep * ($i) >= UBound($DropPoints) ? UBound($DropPoints) - 1 : $ArrayDimStep * ($i)
			SetDebugLog("Assigned Array Dimension: " & $DimensionTemp)
			If $DimensionTemp = (UBound($DropPoints) - 1) Then $DimensionTemp -= 1 ; Incase of $DropPoints is Odd Number Last Point Can Be Duplicate to avoid that did the -1
			SetDebugLog("Dimension Correction: " & $DimensionTemp)
			ReDim $aDeployP[UBound($aDeployP) + 1][2]
			$aDeployP[UBound($aDeployP) - 1][0] = $DropPoints[$DimensionTemp][0] ; X axis
			$aDeployP[UBound($aDeployP) - 1][1] = $DropPoints[$DimensionTemp][1] ; Y axis
		Next
	EndIf

	ReDim $aDeployP[UBound($aDeployP) + 1][2]
	$aDeployP[UBound($aDeployP) - 1][0] = $DropPoints[UBound($DropPoints) - 1][0] ; X axis of Last Point
	$aDeployP[UBound($aDeployP) - 1][1] = $DropPoints[UBound($DropPoints) - 1][1] ; Y axis of Last Point
	SetDebugLog("last point assigned at " & $DropPoints[UBound($DropPoints) - 1][0] & "," & $DropPoints[UBound($DropPoints) - 1][1])

	Return $aDeployP
EndFunc   ;==>FindBestDropPoints

Func DeployPointsPosition($aPixel, $bIsBH = True)
	If Not $g_bRunState Then Return
	Local $sReturn = "", $aXY[2]

	If $bIsBH = True And UBound($g_aBuilderHallPos) > 0 And not @error Then
		$aXY[0] = $g_aBuilderHallPos[0][1]
		$aXY[1] = $g_aBuilderHallPos[0][2]
	Else
		$aXY[0] = $DiamondMiddleX
		$aXY[1] = $DiamondMiddleY
	EndIf

	; Using to determinate the Side position on Screen |Bottom Right|Bottom Left|Top Left|Top Right|
	If IsArray($aPixel) Then
		If $aPixel[0] < $aXY[0] And $aPixel[1] <= $aXY[1] Then $sReturn = "TopLeft"
		If $aPixel[0] >= $aXY[0] And $aPixel[1] < $aXY[1] Then $sReturn = "TopRight"
		If $aPixel[0] < $aXY[0] And $aPixel[1] > $aXY[1] Then $sReturn = "BottomLeft"
		If $aPixel[0] >= $aXY[0] And $aPixel[1] >= $aXY[1] Then $sReturn = "BottomRight"
		If $sReturn = "" Then
			Setlog("Error on SIDE: " & _ArrayToString($aPixel), $COLOR_ERROR)
			$sReturn = "TopLeft"
		EndIf
		Return $sReturn
	Else
		Setlog("ERROR SIDE|DeployPointsPosition!", $COLOR_ERROR)
	EndIf
EndFunc   ;==>DeployPointsPosition

Func TestUpdateBHPos()
	Setlog("** TestUpdateBHPos START**", $COLOR_DEBUG)
	Local $Status = $g_bRunState
	$g_bRunState = True
	UpdateBHPos()
	If UBound($g_aBuilderHallPos) > 0 And Not @Error Then 
		Setlog("TestUpdateBHPos : " & _ArrayToString($g_aBuilderHallPos), $COLOR_DEBUG)
	Else
		Setlog("TestUpdateBHPos : Error", $COLOR_ERROR)
	EndIf
	$g_bRunState = $Status
	Setlog("** TestUpdateBHPos END**", $COLOR_DEBUG)
EndFunc   ;==>TestUpdateBHPos

Func UpdateBHPos()
	Local $hStartTime = __TimerInit()
	Local $aBuilderHallPos = -1
	Local $aBuilderHall[1][4] = [["BuilderHall", $DiamondMiddleX, $DiamondMiddleY, 92]]
	
	For $i = 0 To 3
		$aBuilderHallPos = QuickMIS("CNX", $g_sBundleBuilderHall)
		If UBound($aBuilderHallPos) > 0 And Not @Error Then ExitLoop
		If _Sleep(750) Then Return
	Next
	
	If UBound($aBuilderHallPos) > 0 And Not @Error Then
		$g_aBuilderHallPos = $aBuilderHallPos
		SetLog("Builder Base Hall detection: " & Round(__TimerDiff($hStartTime) / 1000, 2) & " seconds.", $COLOR_DEBUG)
	Else
		$g_aBuilderHallPos = $aBuilderHall
		SaveDebugImage("UpdateBHPos")
		Setlog("Builder Hall detection error", $COLOR_ERROR)
	EndIf
	
	Return $g_aBuilderHallPos
EndFunc   ;==>UpdateBHPos

Func BuilderBaseBuildingsDetection($iBuilding = 4, $bScreenCap = True)

	Local $aBuildings = ["AirDefenses", "Crusher", "GuardPost", "Cannon", "Air Bombs", "Lava Launcher", "Roaster", "BuilderHall"]
	If UBound($aBuildings) -1 < $iBuilding Then Return -1

	Local $sDirectory = $g_sImgOpponentBuildingsBB & "\" & $aBuildings[$iBuilding]

	Setlog("Initial detection for " & $aBuildings[$iBuilding], $COLOR_ACTION)

	If $bScreenCap = True Then _CaptureRegion2()

	Local $aScreen[4] = [83, 136, 844, 694]
	If Not $g_bRunState Then Return
	
	Switch $iBuilding
		Case 0
			If $g_aAirdefensesPos <> -1 Then Return $g_aAirdefensesPos
		Case 1
			If $g_aCrusherPos <> -1 Then Return $g_aCrusherPos
		Case 2
			If $g_aGuardPostPos <> -1 Then Return $g_aGuardPostPos
		Case 3
			If $g_aCannonPos <> -1 Then Return $g_aCannonPos
		Case 4
			If $g_aAirBombs <> -1 Then Return $g_aAirBombs
		Case 5
			If $g_aLavaLauncherPos <> -1 Then Return $g_aLavaLauncherPos
		Case 6
			If $g_aRoasterPos <> -1 Then Return $g_aRoasterPos
		Case 7
			If $g_aBuilderHallPos <> -1 Then Return $g_aBuilderHallPos
	EndSwitch

	Local $aReturn = findMultipleQuick($sDirectory, 10, $aScreen, False, Default, Default, 10)
	
	Switch $iBuilding
		Case 0
			$g_aAirdefensesPos = $aReturn
		Case 1
			$g_aCrusherPos = $aReturn
		Case 2
			$g_aGuardPostPos = $aReturn
		Case 3
			$g_aCannonPos = $aReturn
		Case 4
			$g_aAirBombs = $aReturn
		Case 5
			$g_aLavaLauncherPos = $aReturn
		Case 6
			$g_aRoasterPos = $aReturn
		Case 7
			$g_aBuilderHallPos = $aReturn
	EndSwitch
	
	Return $aReturn

EndFunc   ;==>BuilderBaseBuildingsDetection

Func DebugBuilderBaseBuildingsDetection2($DetectedBuilding)
	_CaptureRegion2()
	Local $subDirectory = $g_sProfileTempDebugPath & "BuilderBase"
	DirCreate($subDirectory)
	Local $Date = @YEAR & "-" & @MON & "-" & @MDAY
	Local $Time = @HOUR & "." & @MIN & "." & @SEC
	Local $editedImage = _GDIPlus_BitmapCreateFromHBITMAP($g_hHBitmap2)
	Local $hGraphic = _GDIPlus_ImageGetGraphicsContext($editedImage)
	Local $hPenRED = _GDIPlus_PenCreate(0xFFFF0000, 3) ; Create a pencil Color FF0000/RED
	Local $filename = ""

	For $i = 0 To UBound($DetectedBuilding) - 1
		Local $SingleCoordinate = [$DetectedBuilding[$i][0], $DetectedBuilding[$i][1], $DetectedBuilding[$i][2]]
		_GDIPlus_GraphicsDrawString($hGraphic, $DetectedBuilding[$i][0], $DetectedBuilding[$i][1] + 10, $DetectedBuilding[$i][2] - 10)
		_GDIPlus_GraphicsDrawRect($hGraphic, $DetectedBuilding[$i][1] - 5, $DetectedBuilding[$i][2] - 5, 10, 10, $hPenRED)
		$filename = String($Date & "_" & $Time & "_" & $DetectedBuilding[$i][0] & "_.png")
	Next

	_GDIPlus_ImageSaveToFile($editedImage, $subDirectory & "\" & $filename)
	_GDIPlus_PenDispose($hPenRED)
	_GDIPlus_GraphicsDispose($hGraphic)
	_GDIPlus_BitmapDispose($editedImage)
EndFunc   ;==>DebugBuilderBaseBuildingsDetection2

Func debugbuilderbasebuildingsdetection($DeployPoints, $BestDeployPoints, $OuterDeployPoints, $debugtext, $csvdeploypoints = 0, $iscsvdeploypoints = False)
	_captureregion2()
	Local $subdirectory = $g_sprofiletempdebugpath & "BuilderBase"
	DirCreate($subdirectory)
	Local $date = @YEAR & "-" & @MON & "-" & @MDAY
	Local $time = @HOUR & "." & @MIN & "." & @SEC
	Local $editedimage = _gdiplus_bitmapcreatefromhbitmap($g_hhbitmap2)
	Local $hgraphic = _gdiplus_imagegetgraphicscontext($editedimage)
	Local $hPenRED = _GDIPlus_PenCreate(0xFFFF0000, 3) ; Create a pencil Color FF0000/RED
	Local $hPenWhite = _GDIPlus_PenCreate(0xFFFFFFFF, 3) ; Create a pencil Color FFFFFF/WHITE
	Local $hpenwhitebold = _gdiplus_pencreate(-1, 5)
	Local $hPenYellow = _GDIPlus_PenCreate(0xFFEEF017, 3) ; Create a pencil Color EEF017/YELLOW
	Local $hPenBlue = _GDIPlus_PenCreate(0xFF6052F9, 3) ; Create a pencil Color 6052F9/BLUE
	Local $harrowendcap = _gdiplus_arrowcapcreate(10, 10)
    If UBound($g_aBuilderHallPos, $UBOUND_COLUMNS) > 3 And not @error Then
		_gdiplus_graphicsdrawrect($hgraphic, $g_aBuilderHallPos[0][1] - 5, $g_aBuilderHallPos[0][2] - 5, 10, 10, $hpenred)
		_gdiplus_graphicsdrawline($hgraphic, 0, $g_aBuilderHallPos[0][2], 860, $g_aBuilderHallPos[0][2], $hpenwhite)
		_gdiplus_graphicsdrawline($hgraphic, $g_aBuilderHallPos[0][1], 0, $g_aBuilderHallPos[0][2], 628, $hpenwhite)
	EndIf
	Local $hbrush = _gdiplus_brushcreatesolid(-1)
	Local $hformat = _gdiplus_stringformatcreate()
	Local $hfamily = _gdiplus_fontfamilycreate("Arial")
	Local $hfont = _gdiplus_fontcreate($hfamily, 18)
	Local $size = 0
	If IsArray($g_aBuilderBaseDiamond) And UBound($g_aBuilderBaseDiamond) > 0 Then
		$size = $g_aBuilderBaseDiamond[0]
	EndIf
	For $i = 1 To UBound($g_aBuilderBaseDiamond) - 1
		Local $coord = $g_aBuilderBaseDiamond[$i]
		Local $nextcoord = ($i = UBound($g_aBuilderBaseDiamond) - 1) ? $g_aBuilderBaseDiamond[1] : $g_aBuilderBaseDiamond[$i + 1]
		_gdiplus_graphicsdrawline($hgraphic, $coord[0], $coord[1], $nextcoord[0], $nextcoord[1], $hpenblue)
	Next
	For $i = 1 To UBound($g_aBuilderBaseOuterDiamond) - 1
		Local $coord = $g_aBuilderBaseOuterDiamond[$i]
		Local $nextcoord = ($i = UBound($g_aBuilderBaseOuterDiamond) - 1) ? $g_aBuilderBaseOuterDiamond[1] : $g_aBuilderBaseOuterDiamond[$i + 1]
		_gdiplus_graphicsdrawline($hgraphic, $coord[0], $coord[1], $nextcoord[0], $nextcoord[1], $hpenblue)
	Next
	For $i = 0 To UBound($g_aExternalEdges) - 1
		Local $local = $g_aExternalEdges[$i]
		For $j = 0 To UBound($local) - 1
			_gdiplus_graphicsdrawrect($hgraphic, $local[$j][0] - 2, $local[$j][1] - 2, 4, 4, $hpenyellow)
		Next
	Next
	For $i = 0 To UBound($g_aOuterEdges) - 1
		Local $local = $g_aOuterEdges[$i]
		For $j = 0 To UBound($local) - 1
			_gdiplus_graphicsdrawrect($hgraphic, $local[$j][0] - 2, $local[$j][1] - 2, 4, 4, $hpenwhite)
		Next
	Next
	For $i = 0 To 3
		Local $local = $DeployPoints[$i]
		For $j = 0 To UBound($local) - 1
			_gdiplus_graphicsdrawrect($hgraphic, $local[$j][0] - 2, $local[$j][1] - 2, 4, 4, $hpenyellow)
		Next
	Next
	For $i = 0 To 3
		Local $local = $BestDeployPoints[$i]
		For $j = 0 To UBound($local) - 1
			_gdiplus_graphicsdrawrect($hgraphic, $local[$j][0] - 2, $local[$j][1] - 2, 4, 4, $hpenred)
			_gdiplus_graphicsdrawstring($hgraphic, $j + 1, $local[$j][0] - 5, $local[$j][1] + 5, "Arial", 12)
		Next
	Next
	For $i = 0 To 3
		Local $local = $OuterDeployPoints[$i]
		For $j = 0 To UBound($local) - 1
			_gdiplus_graphicsdrawrect($hgraphic, $local[$j][0] - 2, $local[$j][1] - 2, 4, 4, $hpenred)
			_gdiplus_graphicsdrawstring($hgraphic, $j + 1, $local[$j][0] - 5, $local[$j][1] + 5, "Arial", 12)
		Next
	Next
	If $iscsvdeploypoints And IsArray($csvdeploypoints) = 1 Then
		For $j = 0 To UBound($csvdeploypoints) - 1
			_gdiplus_graphicsdrawrect($hgraphic, $csvdeploypoints[$j][0], $csvdeploypoints[$j][1] - 2, 4, 4, $hpenwhite)
		Next
	EndIf
	Local $ssidecsvnames[4] = ["FRONT", "BACK", "LEFT", "RIGHT"]
	Local $ssidenames[4] = ["TopLeft", "TopRight", "BottomRight", "BottomLeft"]
	Local $abasesidesposition[4][2] = [[155, 150], [720, 150], [720, 460], [155, 460]]
	Local $bbdiamondmiddlex = $DiamondMiddleX
	Local $bbdiamondmiddley = $DiamondMiddleY
	Local $amainsidesposition[4][4] = [[$bbdiamondmiddlex - 280, $bbdiamondmiddley - 215, $bbdiamondmiddlex - 280 + 80, $bbdiamondmiddley - 215 + 60], [$bbdiamondmiddlex + 280, $bbdiamondmiddley - 215, $bbdiamondmiddlex + 280 - 80, $bbdiamondmiddley - 215 + 60], [$bbdiamondmiddlex + 280, $bbdiamondmiddley + 215, $bbdiamondmiddlex + 280 - 80, $bbdiamondmiddley + 215 - 60], [$bbdiamondmiddlex - 280, $bbdiamondmiddley + 215, $bbdiamondmiddlex - 280 + 80, $bbdiamondmiddley + 215 - 60]]
	Local $imainsidepostionindex = _arraysearch($ssidenames, $g_aBBMainSide)
	If $imainsidepostionindex <> -1 Then
		_gdiplus_arrowcapsetmiddleinset($harrowendcap, 0.5)
		_gdiplus_pensetcustomendcap($hpenwhitebold, $harrowendcap)
		_gdiplus_graphicsdrawline($hgraphic, $amainsidesposition[$imainsidepostionindex][0], $amainsidesposition[$imainsidepostionindex][1], $amainsidesposition[$imainsidepostionindex][2], $amainsidesposition[$imainsidepostionindex][3], $hpenwhitebold)
		For $i = 0 To UBound($ssidecsvnames) - 1
			Local $isideactualindex = 0
			Switch $ssidecsvnames[$i]
				Case "FRONT"
					$isideactualindex = $imainsidepostionindex
				Case "BACK"
					$isideactualindex = ($imainsidepostionindex + 2 > 3) ? Abs(($imainsidepostionindex + 2) - 4) : $imainsidepostionindex + 2
				Case "LEFT"
					$isideactualindex = ($imainsidepostionindex + 1 > 3) ? Abs(($imainsidepostionindex + 1) - 4) : $imainsidepostionindex + 1
				Case "RIGHT"
					$isideactualindex = ($imainsidepostionindex - 1 < 0) ? 4 - Abs($imainsidepostionindex - 1) : $imainsidepostionindex - 1
			EndSwitch
			Local $tlayout = _gdiplus_rectfcreate($abasesidesposition[$isideactualindex][0], $abasesidesposition[$isideactualindex][1], 0, 0)
			Local $ainfo = _gdiplus_graphicsmeasurestring($hgraphic, $ssidecsvnames[$i], $hfont, $tlayout, $hformat)
			_gdiplus_graphicsdrawstringex($hgraphic, $ssidecsvnames[$i], $hfont, $ainfo[0], $hformat, $hbrush)
		Next
	EndIf
	Local $filename = String($date & "_" & $time & "_" & $debugtext & "_" & $size & "_.png")
	_gdiplus_imagesavetofile($editedimage, $subdirectory & "\" & $filename)
	_gdiplus_fontdispose($hfont)
	_gdiplus_fontfamilydispose($hfamily)
	_gdiplus_stringformatdispose($hformat)
	_gdiplus_brushdispose($hbrush)
	_gdiplus_pendispose($hpenred)
	_gdiplus_pendispose($hpenwhite)
	_gdiplus_pendispose($hpenwhitebold)
	_gdiplus_pendispose($hpenyellow)
	_gdiplus_pendispose($hpenblue)
	_gdiplus_arrowcapdispose($harrowendcap)
	_gdiplus_graphicsdispose($hgraphic)
	_gdiplus_bitmapdispose($editedimage)
EndFunc

Func BuilderBaseResetAttackVariables()
	$g_aBBMainSide = "TopLeft"
	$g_aAirdefensesPos = -1
	$g_aGuardPostPos = -1
	$g_aCrusherPos = -1
	$g_aCannonPos = -1
	$g_aAirBombs = -1
	$g_aLavaLauncherPos = -1
	$g_aRoasterPos = -1
	$g_aBuilderHallPos = -1

	$g_aDeployPoints = -1
	$g_aBestDeployPoints = -1

	Global $g_aExternalEdges, $g_aBuilderBaseDiamond, $g_aOuterEdges, $g_aBuilderBaseOuterDiamond, $g_aBuilderBaseOuterPolygon, $g_aFinalOuter[4]
EndFunc   ;==>BuilderBaseResetAttackVariables

Func BuilderBaseAttackMainSide()
	Local $sMainSide = "TopLeft"
	Local $sSideNames[4] = ["TopLeft", "TopRight", "BottomRight", "BottomLeft"]
	Local $sBuilderNames[5] = ["Airdefenses", "Crusher", "GuardPost", "Cannon", "BuilderHall"]
	Local $QuantitiesDetected[4] = [0, 0, 0, 0]
	Local $QuantitiesAttackSide[4] = [0, 0, 0, 0]
	Local $Buildings[5] = [$g_aAirdefensesPos, $g_aCrusherPos, $g_aGuardPostPos, $g_aCannonPos, $g_aBuilderHallPos]

	; $g_aAirdefensesPos, $g_aCrusherPos, $g_aGuardPostPos, $g_aCannonPos, $g_aBuilderHallPos
	For $Index = 0 To UBound($Buildings) -1
		If Not $g_bRunState Then Return
		Local $tempBuilders = $Buildings[$Index]
		SetDebugLog("BuilderBaseAttackMainSide - Builder Name : " & $sBuilderNames[$Index])
		SetDebugLog("BuilderBaseAttackMainSide - All points: " & _ArrayToString($tempBuilders))
		; Can exist more than One Building detected
		For $Howmany = 0 To UBound($tempBuilders) - 1
			If Not IsArray($tempBuilders) Then ExitLoop ; goes to next Builder Type
			Local $TempBuilder = [$tempBuilders[$Howmany][1], $tempBuilders[$Howmany][2]]
			Local $side = DeployPointsPosition($TempBuilder, ($Howmany = 4))
			SetDebugLog("BuilderBaseAttackMainSide - Point: " & _ArrayToString($TempBuilder))
			SetDebugLog("BuilderBaseAttackMainSide - " & $sBuilderNames[$Index] & " Side : " & $side)
			For $Sides = 0 To UBound($sSideNames) - 1
				If $side = $sSideNames[$Sides] Then
					; Add one more building to correct side
					$QuantitiesDetected[$Sides] += 1
					; ; ;
					; Let's get the Opposite side If doesn't have any detectable Buiding
					; ; ;
					Local $mainSide = $Sides + 2 > 3 ? Abs(($Sides + 2) - 4) : $Sides + 2
					SetDebugLog(" -- " & $sBuilderNames[$Index] & " Side : " & $sSideNames[$Sides])
					SetDebugLog(" -- MainSide to Attack : " & $sSideNames[$mainSide])
					; Let's check the for sides
					For $j = 0 To 3
						Local $LastBuilderSide = $mainSide
						If $QuantitiesDetected[$mainSide] = 0 Then
							$QuantitiesAttackSide[$mainSide] += 1
							SetDebugLog(" -- Confirming the MainSide [$mainSide]: " & $sSideNames[$mainSide])
							ExitLoop (2) ; exit to next Builder position [$Howmany]
						EndIf
						; Lets check other side
						$mainSide = Abs(($mainSide + 1) - 4)
						SetDebugLog(" --- New MainSide [$mainSide]: " & $sSideNames[$mainSide] & " last Side have a building!")
					Next
				EndIf
			Next
		Next
	Next
	For $i = 0 To 3
		If $QuantitiesDetected[$i] > 0 Then SetDebugLog("BuilderBaseAttackMainSide - $QuantitiesDetected : " & $sSideNames[$i] & " - " & $QuantitiesDetected[$i])
	Next
	For $i = 0 To 3
		If $QuantitiesAttackSide[$i] > 0 Then SetDebugLog("BuilderBaseAttackMainSide - $QuantitiesAttackSide : " & $sSideNames[$i] & " - " & $QuantitiesAttackSide[$i])
	Next

	Local $LessNumber = 0

	For $i = 0 To 3
		If $QuantitiesAttackSide[$i] > $LessNumber Then
			$LessNumber = $QuantitiesAttackSide[$i]
			$sMainSide = $sSideNames[$i]
		EndIf
	Next

	Return $sMainSide
EndFunc   ;==>BuilderBaseAttackMainSide

Func BuilderBaseBuildingsOnEdge($g_aDeployPoints)
	Local $sSideNames[4] = ["TopLeft", "TopRight", "BottomRight", "BottomLeft"]
	; $TempTopLeft[XX][2]
	If UBound($g_aDeployPoints) < 4 Then Return
	If Not $g_bRunState Then Return

	Local $TempTopLeft = $g_aDeployPoints[0]
	Local $TempTopRight = $g_aDeployPoints[1]
	Local $TempBottomRight = $g_aDeployPoints[2]
	Local $TempBottomLeft = $g_aDeployPoints[3]

	; Getting the Out Edges deploy points
	Local $TempOuterTL = $g_aOuterEdges[0]
	Local $TempOuterTR = $g_aOuterEdges[1]
	Local $TempOuterBR = $g_aOuterEdges[2]
	Local $TempOuterBL = $g_aOuterEdges[3]

	;Index 3 Contains Side Name Needed For Adding Tiles Pixel
	Local $ToReturn[0][3], $Left = False, $Top = False, $Right = False, $Bottom = False

	For $Index = 0 To UBound($TempTopLeft) - 1
		If Int($TempTopLeft[$Index][0]) < 200 Then
			If Not $Left Then
				ReDim $ToReturn[UBound($ToReturn) + 1][3]
				$ToReturn[UBound($ToReturn) - 1][0] = $TempOuterTL[0][0]
				$ToReturn[UBound($ToReturn) - 1][1] = $TempOuterTL[0][1]
				$ToReturn[UBound($ToReturn) - 1][2] = $sSideNames[0]
				$Left = True
				Setlog("Possible Building at edge at LEFT corner " & $TempTopLeft[$Index][0] & "x" & $TempTopLeft[$Index][1], $COLOR_DEBUG)
			EndIf
		ElseIf Int($TempTopLeft[$Index][1]) < 160 Then
			If Not $Top Then
				ReDim $ToReturn[UBound($ToReturn) + 1][3]
				$ToReturn[UBound($ToReturn) - 1][0] = $TempOuterTL[UBound($TempOuterTL) - 1][0]
				$ToReturn[UBound($ToReturn) - 1][1] = $TempOuterTL[UBound($TempOuterTL) - 1][1]
				$ToReturn[UBound($ToReturn) - 1][2] = $sSideNames[0]
				$Top = True
				Setlog("Possible Building at edge at TOP corner " & $TempTopLeft[$Index][0] & "x" & $TempTopLeft[$Index][1], $COLOR_DEBUG)
			EndIf
		EndIf
	Next

	If Not $g_bRunState Then Return

	For $Index = 0 To UBound($TempTopRight) - 1
		If Int($TempTopRight[$Index][0]) > 690 Then
			If Not $Right Then
				ReDim $ToReturn[UBound($ToReturn) + 1][3]
				$ToReturn[UBound($ToReturn) - 1][0] = $TempOuterTR[UBound($TempOuterTR) - 1][0]
				$ToReturn[UBound($ToReturn) - 1][1] = $TempOuterTR[UBound($TempOuterTR) - 1][1]
				$ToReturn[UBound($ToReturn) - 1][2] = $sSideNames[1]
				$Right = True
				Setlog("Possible Building at edge at RIGHT corner " & $TempTopRight[$Index][0] & "x" & $TempTopRight[$Index][1], $COLOR_DEBUG)
			EndIf
		ElseIf Int($TempTopRight[$Index][1]) < 160 Then
			If Not $Top Then
				ReDim $ToReturn[UBound($ToReturn) + 1][3]
				$ToReturn[UBound($ToReturn) - 1][0] = $TempOuterTR[0][0]
				$ToReturn[UBound($ToReturn) - 1][1] = $TempOuterTR[0][1]
				$ToReturn[UBound($ToReturn) - 1][2] = $sSideNames[1]
				$Top = True
				Setlog("Possible Building at edge at TOP corner " & $TempTopRight[$Index][0] & "x" & $TempTopRight[$Index][1], $COLOR_DEBUG)
			EndIf
		EndIf
	Next

	If Not $g_bRunState Then Return

	For $Index = 0 To UBound($TempBottomRight) - 1
		If Int($TempBottomRight[$Index][0]) > 690 Then
			If Not $Right Then
				ReDim $ToReturn[UBound($ToReturn) + 1][3]
				$ToReturn[UBound($ToReturn) - 1][0] = $TempOuterBR[0][0]
				$ToReturn[UBound($ToReturn) - 1][1] = $TempOuterBR[0][1]
				$ToReturn[UBound($ToReturn) - 1][2] = $sSideNames[2]
				$Right = True
				Setlog("Possible Building at edge at RIGHT corner " & $TempBottomRight[$Index][0] & "x" & $TempBottomRight[$Index][1], $COLOR_DEBUG)
			EndIf
		ElseIf Int($TempBottomRight[$Index][1]) > 490 Then ; RC
			If Not $Bottom Then
				ReDim $ToReturn[UBound($ToReturn) + 1][3]
				$ToReturn[UBound($ToReturn) - 1][0] = $TempOuterBR[UBound($TempOuterBR) - 1][0]
				$ToReturn[UBound($ToReturn) - 1][1] = $TempOuterBR[UBound($TempOuterBR) - 1][1]
				$ToReturn[UBound($ToReturn) - 1][2] = $sSideNames[2]
				$Bottom = True
				Setlog("Possible Building at edge at BOTTOM corner " & $TempBottomRight[$Index][0] & "x" & $TempBottomRight[$Index][1], $COLOR_DEBUG)
			EndIf
		EndIf
	Next

	If Not $g_bRunState Then Return

	For $Index = 0 To UBound($TempBottomLeft) - 1
		If Int($TempBottomLeft[$Index][0]) < 200 Then
			If Not $Left Then
				ReDim $ToReturn[UBound($ToReturn) + 1][3]
				$ToReturn[UBound($ToReturn) - 1][0] = $TempOuterBL[UBound($TempOuterBL) - 1][0]
				$ToReturn[UBound($ToReturn) - 1][1] = $TempOuterBL[UBound($TempOuterBL) - 1][1]
				$ToReturn[UBound($ToReturn) - 1][2] = $sSideNames[3]
				$Left = True
				Setlog("Possible Building at edge at LEFT corner " & $TempBottomLeft[$Index][0] & "x" & $TempBottomLeft[$Index][1], $COLOR_DEBUG)
			EndIf
		ElseIf Int($TempBottomLeft[$Index][1]) > 490 Then ; RC
			If Not $Bottom Then
				ReDim $ToReturn[UBound($ToReturn) + 1][3]
				$ToReturn[UBound($ToReturn) - 1][0] = $TempOuterBL[0][0]
				$ToReturn[UBound($ToReturn) - 1][1] = $TempOuterBL[0][1]
				$ToReturn[UBound($ToReturn) - 1][2] = $sSideNames[3]
				$Bottom = True
				Setlog("Possible Building at edge at BOTTOM corner " & $TempBottomLeft[$Index][0] & "x" & $TempBottomLeft[$Index][1], $COLOR_DEBUG)
			EndIf
		EndIf
	Next

	If Not $g_bRunState Then Return

	Return UBound($ToReturn) > 0 ? $ToReturn : "-1"

EndFunc   ;==>BuilderBaseBuildingsOnEdge
