; #FUNCTION# ====================================================================================================================
; Name ..........: AttackCSVDEBUGIMAGE
; Description ...:
; Syntax ........: AttackCSVDEBUGIMAGE()
; Parameters ....:
; Return values .: None
; Author ........: Sardo (2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func AttackCSVDEBUGIMAGE()

	Local $iTimer = __TimerInit()

	_CaptureRegion2()

	Local $EditedImage = _GDIPlus_BitmapCreateFromHBITMAP($g_hHBitmap2)
	Local $testx
	Local $hGraphic = _GDIPlus_ImageGetGraphicsContext($EditedImage)
	Local $hBrush = _GDIPlus_BrushCreateSolid(0xFFFFFFFF)
	Local $pixel

	; Open box of crayons :-)
	Local $hPenLtGreen = _GDIPlus_PenCreate(0xFF00DC00, 2)
	Local $hPenDkGreen = _GDIPlus_PenCreate(0xFF006E00, 2)
	Local $hPenMdGreen = _GDIPlus_PenCreate(0xFF4CFF00, 2)
	Local $hPenRed = _GDIPlus_PenCreate(0xFFFF0000, 2)
	Local $hPenDkRed = _GDIPlus_PenCreate(0xFF6A0000, 2)
	Local $hPenNavyBlue = _GDIPlus_PenCreate(0xFF000066, 2)
	Local $hPenBlue = _GDIPlus_PenCreate(0xFF0000CC, 2)
	Local $hPenSteelBlue = _GDIPlus_PenCreate(0xFF0066CC, 2)
	Local $hPenLtBlue = _GDIPlus_PenCreate(0xFF0080FF, 2)
	Local $hPenPaleBlue = _GDIPlus_PenCreate(0xFF66B2FF, 2)
	Local $hPenCyan = _GDIPlus_PenCreate(0xFF00FFFF, 2)
	Local $hPenYellow = _GDIPlus_PenCreate(0xFFFFD800, 2)
	Local $hPenLtGrey = _GDIPlus_PenCreate(0xFFCCCCCC, 2)
	Local $hPenWhite = _GDIPlus_PenCreate(0xFFFFFFFF, 2)
	Local $hPenMagenta = _GDIPlus_PenCreate(0xFFFF00F6, 2)


	;-- DRAW EXTERNAL PERIMETER LINES
	_GDIPlus_GraphicsDrawLine($hGraphic, $ExternalArea[0][0], $ExternalArea[0][1], $ExternalArea[2][0], $ExternalArea[2][1], $hPenLtGreen)
	_GDIPlus_GraphicsDrawLine($hGraphic, $ExternalArea[0][0], $ExternalArea[0][1], $ExternalArea[3][0], $ExternalArea[3][1], $hPenLtGreen)
	_GDIPlus_GraphicsDrawLine($hGraphic, $ExternalArea[1][0], $ExternalArea[1][1], $ExternalArea[2][0], $ExternalArea[2][1], $hPenLtGreen)
	_GDIPlus_GraphicsDrawLine($hGraphic, $ExternalArea[1][0], $ExternalArea[1][1], $ExternalArea[3][0], $ExternalArea[3][1], $hPenLtGreen)

	;-- DRAW EXTERNAL PERIMETER LINES
	_GDIPlus_GraphicsDrawLine($hGraphic, $InternalArea[0][0], $InternalArea[0][1], $InternalArea[2][0], $InternalArea[2][1], $hPenDkGreen)
	_GDIPlus_GraphicsDrawLine($hGraphic, $InternalArea[0][0], $InternalArea[0][1], $InternalArea[3][0], $InternalArea[3][1], $hPenDkGreen)
	_GDIPlus_GraphicsDrawLine($hGraphic, $InternalArea[1][0], $InternalArea[1][1], $InternalArea[2][0], $InternalArea[2][1], $hPenDkGreen)
	_GDIPlus_GraphicsDrawLine($hGraphic, $InternalArea[1][0], $InternalArea[1][1], $InternalArea[3][0], $InternalArea[3][1], $hPenDkGreen)

	;-- DRAW VERTICAL AND ORIZONTAL LINES
	_GDIPlus_GraphicsDrawLine($hGraphic, $InternalArea[2][0], 0, $InternalArea[2][0], $g_iDEFAULT_HEIGHT, $hPenDkGreen)
	_GDIPlus_GraphicsDrawLine($hGraphic, 0, $InternalArea[0][1], $g_iDEFAULT_WIDTH, $InternalArea[0][1], $hPenDkGreen)

	;-- DRAW DIAGONALS LINES
	_GDIPlus_GraphicsDrawLine($hGraphic, $ExternalArea[4][0], $ExternalArea[4][1], $ExternalArea[7][0], $ExternalArea[7][1], $hPenLtGreen)
	_GDIPlus_GraphicsDrawLine($hGraphic, $ExternalArea[5][0], $ExternalArea[5][1], $ExternalArea[6][0], $ExternalArea[6][1], $hPenLtGreen)

	;-- DRAW REDAREA PATH
	For $i = 0 To UBound($g_aiPixelTopLeft) - 1
		$pixel = $g_aiPixelTopLeft[$i]
		_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 2, 2, $hPenRed)
	Next
	For $i = 0 To UBound($g_aiPixelTopRight) - 1
		$pixel = $g_aiPixelTopRight[$i]
		_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 2, 2, $hPenRed)
	Next
	For $i = 0 To UBound($g_aiPixelBottomLeft) - 1
		$pixel = $g_aiPixelBottomLeft[$i]
		_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 2, 2, $hPenRed)
	Next
	For $i = 0 To UBound($g_aiPixelBottomRight) - 1
		$pixel = $g_aiPixelBottomRight[$i]
		_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 2, 2, $hPenRed)
	Next

	;DRAW FULL DROP LINES PATH

	For $i = 0 To UBound($g_aiPixelTopLeftDropLine) - 1
		$pixel = $g_aiPixelTopLeftDropLine[$i]
		_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 2, 2, $hPenBlue)
	Next
	For $i = 0 To UBound($g_aiPixelTopRightDropLine) - 1
		$pixel = $g_aiPixelTopRightDropLine[$i]
		_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 2, 2, $hPenCyan)
	Next
	For $i = 0 To UBound($g_aiPixelBottomLeftDropLine) - 1
		$pixel = $g_aiPixelBottomLeftDropLine[$i]
		_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 2, 2, $hPenYellow)
	Next
	For $i = 0 To UBound($g_aiPixelBottomRightDropLine) - 1
		$pixel = $g_aiPixelBottomRightDropLine[$i]
		_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 2, 2, $hPenLtGrey)
	Next

	;DRAW SLICES DROP PATH LINES
	For $i = 0 To UBound($g_aiPixelTopLeftDOWNDropLine) - 1
		$pixel = $g_aiPixelTopLeftDOWNDropLine[$i]
		_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 2, 2, $hPenBlue)
	Next
	For $i = 0 To UBound($g_aiPixelTopLeftUPDropLine) - 1
		$pixel = $g_aiPixelTopLeftUPDropLine[$i]
		_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 2, 2, $hPenCyan)
	Next
	For $i = 0 To UBound($g_aiPixelBottomLeftDOWNDropLine) - 1
		$pixel = $g_aiPixelBottomLeftDOWNDropLine[$i]
		_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 2, 2, $hPenYellow)
	Next
	For $i = 0 To UBound($g_aiPixelBottomLeftUPDropLine) - 1
		$pixel = $g_aiPixelBottomLeftUPDropLine[$i]
		_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 2, 2, $hPenLtGrey)
	Next
	For $i = 0 To UBound($g_aiPixelTopRightDOWNDropLine) - 1
		$pixel = $g_aiPixelTopRightDOWNDropLine[$i]
		_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 2, 2, $hPenBlue)
	Next
	For $i = 0 To UBound($g_aiPixelTopRightUPDropLine) - 1
		$pixel = $g_aiPixelTopRightUPDropLine[$i]
		_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 2, 2, $hPenCyan)
	Next
	For $i = 0 To UBound($g_aiPixelBottomRightDOWNDropLine) - 1
		$pixel = $g_aiPixelBottomRightDOWNDropLine[$i]
		_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 2, 2, $hPenYellow)
	Next
	For $i = 0 To UBound($g_aiPixelBottomRightUPDropLine) - 1
		$pixel = $g_aiPixelBottomRightUPDropLine[$i]
		_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 2, 2, $hPenLtGrey)
	Next

	;DRAW DROP POINTS EXAMPLES
	$testx = MakeDropPoints("TOP-LEFT-DOWN", 10, 2, "EXT-INT")
	For $i = 0 To UBound($testx) - 1
		$pixel = $testx[$i]
		_GDIPlus_GraphicsDrawString($hGraphic, $i + 1, $pixel[0], $pixel[1], "Arial", 12)
		_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 6, 6, $hPenRed)
	Next

	$testx = MakeDropPoints("TOP-LEFT-DOWN", 10, 4, "EXT-INT") ;
	For $i = 0 To UBound($testx) - 1
		$pixel = $testx[$i]
		_GDIPlus_GraphicsDrawString($hGraphic, $i + 1, $pixel[0] - 10, $pixel[1] - 10, "Arial", 12)
		_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 6, 6, $hPenMdGreen)
	Next

	$testx = MakeDropPoints("BOTTOM-LEFT-UP", 10, 2, "EXT-INT")
	For $i = 0 To UBound($testx) - 1
		$pixel = $testx[$i]
		_GDIPlus_GraphicsDrawString($hGraphic, $i + 1, $pixel[0], $pixel[1], "Arial", 12)
		_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 6, 6, $hPenRed)
	Next

	$testx = MakeDropPoints("BOTTOM-LEFT-UP", 10, 4, "EXT-INT") ;
	For $i = 0 To UBound($testx) - 1
		$pixel = $testx[$i]
		_GDIPlus_GraphicsDrawString($hGraphic, $i + 1, $pixel[0] - 10, $pixel[1] - 10, "Arial", 12)
		_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 6, 6, $hPenMdGreen)
	Next

	$testx = MakeDropPoints("TOP-RIGHT-DOWN", 10, 2, "EXT-INT")
	For $i = 0 To UBound($testx) - 1
		$pixel = $testx[$i]
		_GDIPlus_GraphicsDrawString($hGraphic, $i + 1, $pixel[0], $pixel[1], "Arial", 12)
		_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 6, 6, $hPenRed)
	Next

	$testx = MakeDropPoints("TOP-RIGHT-DOWN", 10, 4, "EXT-INT") ;
	For $i = 0 To UBound($testx) - 1
		$pixel = $testx[$i]
		_GDIPlus_GraphicsDrawString($hGraphic, $i + 1, $pixel[0] - 10, $pixel[1] - 10, "Arial", 12)
		_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 6, 6, $hPenMdGreen)
	Next

	$testx = MakeDropPoints("BOTTOM-RIGHT-UP", 10, 2, "EXT-INT")
	For $i = 0 To UBound($testx) - 1
		$pixel = $testx[$i]
		_GDIPlus_GraphicsDrawString($hGraphic, $i + 1, $pixel[0], $pixel[1], "Arial", 12)
		_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 6, 6, $hPenRed)
	Next

	$testx = MakeDropPoints("BOTTOM-RIGHT-UP", 10, 4, "EXT-INT") ;
	For $i = 0 To UBound($testx) - 1
		$pixel = $testx[$i]
		_GDIPlus_GraphicsDrawString($hGraphic, $i + 1, $pixel[0] - 10, $pixel[1] - 10, "Arial", 12)
		_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 6, 6, $hPenMdGreen)
	Next

	$testx = MakeDropPoints("TOP-LEFT-UP", 10, 2, "INT-EXT")
	For $i = 0 To UBound($testx) - 1
		$pixel = $testx[$i]
		_GDIPlus_GraphicsDrawString($hGraphic, $i + 1, $pixel[0], $pixel[1], "Arial", 12)
		_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 6, 6, $hPenRed)
	Next

	$testx = MakeDropPoints("TOP-LEFT-UP", 10, 4, "INT-EXT") ;
	For $i = 0 To UBound($testx) - 1
		$pixel = $testx[$i]
		_GDIPlus_GraphicsDrawString($hGraphic, $i + 1, $pixel[0] - 10, $pixel[1] - 10, "Arial", 12)
		_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 6, 6, $hPenMdGreen)
	Next

	$testx = MakeDropPoints("BOTTOM-LEFT-DOWN", 10, 2, "INT-EXT")
	For $i = 0 To UBound($testx) - 1
		$pixel = $testx[$i]
		_GDIPlus_GraphicsDrawString($hGraphic, $i + 1, $pixel[0], $pixel[1], "Arial", 12)
		_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 6, 6, $hPenRed)
	Next

	$testx = MakeDropPoints("BOTTOM-LEFT-DOWN", 10, 4, "INT-EXT") ;
	For $i = 0 To UBound($testx) - 1
		$pixel = $testx[$i]
		_GDIPlus_GraphicsDrawString($hGraphic, $i + 1, $pixel[0] - 10, $pixel[1] - 10, "Arial", 12)
		_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 6, 6, $hPenMdGreen)
	Next

	$testx = MakeDropPoints("TOP-RIGHT-UP", 10, 2, "INT-EXT")
	For $i = 0 To UBound($testx) - 1
		$pixel = $testx[$i]
		_GDIPlus_GraphicsDrawString($hGraphic, $i + 1, $pixel[0], $pixel[1], "Arial", 12)
		_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 6, 6, $hPenRed)
	Next

	$testx = MakeDropPoints("TOP-RIGHT-UP", 10, 4, "INT-EXT") ;
	For $i = 0 To UBound($testx) - 1
		$pixel = $testx[$i]
		_GDIPlus_GraphicsDrawString($hGraphic, $i + 1, $pixel[0] - 10, $pixel[1] - 10, "Arial", 12)
		_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 6, 6, $hPenMdGreen)
	Next

	$testx = MakeDropPoints("BOTTOM-RIGHT-DOWN", 10, 2, "INT-EXT")
	For $i = 0 To UBound($testx) - 1
		$pixel = $testx[$i]
		_GDIPlus_GraphicsDrawString($hGraphic, $i + 1, $pixel[0], $pixel[1], "Arial", 12)
		_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 6, 6, $hPenRed)
	Next

	$testx = MakeDropPoints("BOTTOM-RIGHT-DOWN", 10, 4, "INT-EXT") ;
	For $i = 0 To UBound($testx) - 1
		$pixel = $testx[$i]
		_GDIPlus_GraphicsDrawString($hGraphic, $i + 1, $pixel[0] - 10, $pixel[1] - 10, "Arial", 12)
		_GDIPlus_GraphicsDrawEllipse($hGraphic, $pixel[0], $pixel[1], 6, 6, $hPenMdGreen)
	Next

	; 06 - DRAW MINES, ELIXIR, DRILLS ------------------------------------------------------------------------
	For $i = 0 To UBound($g_aiPixelMine) - 1
		$pixel = $g_aiPixelMine[$i]
		_GDIPlus_GraphicsDrawRect($hGraphic, $pixel[0] - 10, $pixel[1] - 10, 20, 20, $hPenLtGreen)
	Next
	For $i = 0 To UBound($g_aiPixelElixir) - 1
		$pixel = $g_aiPixelElixir[$i]
		_GDIPlus_GraphicsDrawRect($hGraphic, $pixel[0] - 10, $pixel[1] - 5, 20, 20, $hPenDkGreen)
	Next
	For $i = 0 To UBound($g_aiPixelDarkElixir) - 1
		$pixel = $g_aiPixelDarkElixir[$i]
		_GDIPlus_GraphicsDrawRect($hGraphic, $pixel[0] - 10, $pixel[1] - 5, 20, 20, $hPenDkRed)
	Next

	; - DRAW GOLD STORAGE -------------------------------------------------------
	If $g_bCSVLocateStorageGold = True And IsArray($g_aiCSVGoldStoragePos) Then
			For $i = 0 To UBound($g_aiCSVGoldStoragePos) - 1
				$pixel = $g_aiCSVGoldStoragePos[$i]
				_GDIPlus_GraphicsDrawRect($hGraphic, $pixel[0] - 10, $pixel[1] - 15, 20, 20, $hPenWhite)
			Next
	EndIf

	; - DRAW ELIXIR STORAGE ---------------------------------------------------------
	If $g_bCSVLocateStorageElixir = True And IsArray($g_aiCSVElixirStoragePos) Then
			For $i = 0 To UBound($g_aiCSVElixirStoragePos) - 1
				$pixel = $g_aiCSVElixirStoragePos[$i]
				_GDIPlus_GraphicsDrawRect($hGraphic, $pixel[0] - 10, $pixel[1] - 15, 20, 20, $hPenMagenta)
			Next
	EndIf


	; - DRAW TOWNHALL -------------------------------------------------------------------
	_GDIPlus_GraphicsDrawRect($hGraphic, $g_iTHx - 5, $g_iTHy - 10, 30, 30, $hPenRed)

	; - DRAW Eagle -------------------------------------------------------------------
	If $g_bCSVLocateEagle = True And IsArray($g_aiCSVEagleArtilleryPos) Then
		_GDIPlus_GraphicsDrawRect($hGraphic, $g_aiCSVEagleArtilleryPos[0] - 15, $g_aiCSVEagleArtilleryPos[1] - 15, 30, 30, $hPenBlue)
	EndIf

	; - DRAW Eagle -------------------------------------------------------------------
	If $g_bCSVLocateScatter = True And IsArray($g_aiCSVScatterPos) Then
		_GDIPlus_GraphicsDrawRect($hGraphic, $g_aiCSVScatterPos[0] - 15, $g_aiCSVScatterPos[1] - 15, 30, 30, $hPenBlue)
	EndIf

	; - DRAW Inferno -------------------------------------------------------------------
	If $g_bCSVLocateInferno = True And IsArray($g_aiCSVInfernoPos) Then
		For $i = 0 To UBound($g_aiCSVInfernoPos) - 1
			$pixel = $g_aiCSVInfernoPos[$i]
			_GDIPlus_GraphicsDrawRect($hGraphic, $pixel[0] - 10, $pixel[1] - 10, 20, 20, $hPenNavyBlue)
		Next
	EndIf

	; - DRAW X-Bow -------------------------------------------------------------------
	If $g_bCSVLocateXBow = True And IsArray($g_aiCSVXBowPos) Then
		For $i = 0 To UBound($g_aiCSVXBowPos) - 1
			$pixel = $g_aiCSVXBowPos[$i]
			_GDIPlus_GraphicsDrawRect($hGraphic, $pixel[0] - 10, $pixel[1] - 25, 25, 25, $hPenBlue)
		Next
	EndIf

	; - DRAW Wizard Towers -------------------------------------------------------------------
	If $g_bCSVLocateWizTower = True And IsArray($g_aiCSVWizTowerPos) Then
		For $i = 0 To UBound($g_aiCSVWizTowerPos) - 1
			$pixel = $g_aiCSVWizTowerPos[$i]
			_GDIPlus_GraphicsDrawRect($hGraphic, $pixel[0] - 5, $pixel[1] - 15, 25, 25, $hPenSteelBlue)
		Next
	EndIf

	; - DRAW Mortars -------------------------------------------------------------------
	If $g_bCSVLocateMortar = True And IsArray($g_aiCSVMortarPos) Then
		For $i = 0 To UBound($g_aiCSVMortarPos) - 1
			$pixel = $g_aiCSVMortarPos[$i]
			_GDIPlus_GraphicsDrawRect($hGraphic, $pixel[0] - 10, $pixel[1] - 15, 25, 25, $hPenLtBlue)
		Next
	EndIf

	; - DRAW Air Defense -------------------------------------------------------------------
	If $g_bCSVLocateAirDefense = True And IsArray($g_aiCSVAirDefensePos) Then
		For $i = 0 To UBound($g_aiCSVAirDefensePos) - 1
			$pixel = $g_aiCSVAirDefensePos[$i]
			_GDIPlus_GraphicsDrawRect($hGraphic, $pixel[0] - 12, $pixel[1] - 10, 25, 25, $hPenPaleBlue)
		Next
	EndIf

	; 99 -  DRAW SLICE NUMBERS
	_GDIPlus_GraphicsDrawString($hGraphic, "1", 580, 580, "Arial", 20)
	_GDIPlus_GraphicsDrawString($hGraphic, "2", 750, 450, "Arial", 20)
	_GDIPlus_GraphicsDrawString($hGraphic, "3", 750, 200, "Arial", 20)
	_GDIPlus_GraphicsDrawString($hGraphic, "4", 580, 110, "Arial", 20)
	_GDIPlus_GraphicsDrawString($hGraphic, "5", 260, 110, "Arial", 20)
	_GDIPlus_GraphicsDrawString($hGraphic, "6", 110, 200, "Arial", 20)
	_GDIPlus_GraphicsDrawString($hGraphic, "7", 110, 450, "Arial", 20)
	_GDIPlus_GraphicsDrawString($hGraphic, "8", 310, 580, "Arial", 20)

	; - DRAW GetVillageSize
	_GDIPlus_GraphicsDrawString($hGraphic, "S: " & DetectScenery($g_aVillageSize[6]), 5, 490, "Arial", 12)
	_GDIPlus_GraphicsDrawString($hGraphic, "Size: " & $g_aVillageSize[0], 5, 510, "Arial", 12)
	_GDIPlus_GraphicsDrawString($hGraphic, "ZF: " & $g_aVillageSize[1], 5, 530, "Arial", 12)
	_GDIPlus_GraphicsDrawString($hGraphic, "Offset: " & $g_aVillageSize[2] & ", " & $g_aVillageSize[3], 5, 550, "Arial", 12)
	
	_GDIPlus_GraphicsDrawLine($hGraphic, int($g_aVillageSize[4]), int($g_aVillageSize[5]), int($g_aVillageSize[7]), int($g_aVillageSize[8]), $hPenMagenta)

	Local $Date = @YEAR & "-" & @MON & "-" & @MDAY
	Local $Time = @HOUR & "." & @MIN & "." & @SEC
	Local $filename = $g_sProfileTempDebugPath & String("AttackDebug_" & $Date & "_" & $Time) & ".jpg"
	_GDIPlus_ImageSaveToFile($EditedImage, $filename)
	If @error Then SetLog("Debug Image save error: " & @extended, $COLOR_ERROR)
	SetDebugLog("Attack CSV image saved: " & $filename)

	; Clean up resources
	_GDIPlus_PenDispose($hPenLtGreen)
	_GDIPlus_PenDispose($hPenDkGreen)
	_GDIPlus_PenDispose($hPenMdGreen)
	_GDIPlus_PenDispose($hPenRed)
	_GDIPlus_PenDispose($hPenDkRed)
	_GDIPlus_PenDispose($hPenBlue)
	_GDIPlus_PenDispose($hPenNavyBlue)
	_GDIPlus_PenDispose($hPenSteelBlue)
	_GDIPlus_PenDispose($hPenLtBlue)
	_GDIPlus_PenDispose($hPenPaleBlue)
	_GDIPlus_PenDispose($hPenCyan)
	_GDIPlus_PenDispose($hPenYellow)
	_GDIPlus_PenDispose($hPenLtGrey)
	_GDIPlus_PenDispose($hPenWhite)
	_GDIPlus_PenDispose($hPenMagenta)
	_GDIPlus_BrushDispose($hBrush)
	_GDIPlus_GraphicsDispose($hGraphic)
	_GDIPlus_BitmapDispose($EditedImage)

	; open image
	If TestCapture() = True Then
		ShellExecute($filename)
	EndIf

	SetDebugLog("AttackCSV DEBUG IMAGE Create Required: " & Round((__TimerDiff($iTimer) * 0.001), 1) & "Seconds", $COLOR_DEBUG)

EndFunc   ;==>AttackCSVDEBUGIMAGE
