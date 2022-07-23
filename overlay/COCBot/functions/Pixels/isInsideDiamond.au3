; #FUNCTION# ====================================================================================================================
; Name ..........: isInsideDiamondXY, isInsideDiamond
; Description ...: This function can test if a given coordinate is inside (True) or outside (False) the village grass borders (a diamond shape).
;                  It will also exclude some special area's like the CHAT tab, BUILDER button and GEM shop button.
; Syntax ........: isInsideDiamondXY($aCoordX, $aCoordY), isInsideDiamond($aCoords)
; Parameters ....: ($aCoordX, $aCoordY) as coordinates or ($aCoords), an array of (x,y) to test
; Return values .: True or False
; Author ........: Hervidero (May 21, 2015), Boldina (July 3, 2022)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func isInsideDiamondXY($aCoordX, $aCoordY, $bPercentBased = True, $bDebug = False)

	Local $aCoords = [$aCoordX, $aCoordY]
	Return isInsideDiamond($aCoords, $bPercentBased, $bDebug)

EndFunc   ;==>isInsideDiamondXY

Func isInsideDiamond($aCoords, $bPercentBased = True, $bDebug = False)
	
	If UBound($aCoords) > 1 And not @error Then 
		
		; Barrani AIO Temp fix
		If $aCoords[0] <= 100 And $aCoords[1] <= 100 And (Not $bPercentBased = False) Then
			PercentToVillage($aCoords[0], $aCoords[1])
		EndIf
		
		
		Local $iX = $aCoords[0], $iY = $aCoords[1]
		Local $iLeft = $InternalArea[0][0], $iRight = $InternalArea[1][0], $iTop = $InternalArea[2][1], $iBottom = $InternalArea[3][1]
		
		Local $iFixX = (($iRight - $iLeft) * 1.086637298091043) - ($iRight - $iLeft)
		Local $iFixY = (($iBottom - $iTop) * 1.086637298091043) - ($iBottom - $iTop)
		
		$iLeft = ($iLeft - $iFixX)
		$iRight = ($iRight + $iFixX)
		$iTop = ($iTop - $iFixY)
		$iBottom = ($iBottom + $iFixY)
		
		
		Local $aDiamond[2][2] = [[$iLeft, $iTop], [$iRight, $iBottom]]
		Local $aMiddle = [($aDiamond[0][0] + $aDiamond[1][0]) / 2, ($aDiamond[0][1] + $aDiamond[1][1]) / 2]
		Local $aSize = [$aMiddle[0] - $aDiamond[0][0], $aMiddle[1] - $aDiamond[0][1]]

		Local $iDX = Abs($iX - $aMiddle[0])
		Local $iDY = Abs($iY - $aMiddle[1])

		If ($iDX / $aSize[0] + $iDY / $aSize[1] <= 1) Then
		
			If $bDebug Then DebugsInsideDiamond($iX, $iY, $iLeft, $iRight, $iTop, $iBottom, True)
			
			If $iX < 70 And $iY > 270 Then ; coordinates where the game will click on the CHAT tab (safe margin)
				SetDebugLog("[isInsideDiamond] Coordinate Inside Village, but Exclude CHAT", $COLOR_ERROR)
				Return False
			ElseIf $iY < 63 Then ; coordinates where the game will click on the BUILDER button or SHIELD button (safe margin)
				SetDebugLog("[isInsideDiamond] Coordinate Inside Village, but Exclude BUILDER", $COLOR_ERROR)
				Return False
			ElseIf $iX > 692 And $iY > 156 And $iY < 210 Then ; coordinates where the game will click on the GEMS button (safe margin)
				SetDebugLog("[isInsideDiamond] Coordinate Inside Village, but Exclude GEMS", $COLOR_ERROR)
				Return False
			ElseIf $iX > 669 And $iY > 526 Then ; coordinates where the game will click on the SHOP button (safe margin)
				SetDebugLog("[isInsideDiamond] Coordinate Inside Village, but Exclude SHOP", $COLOR_ERROR)
				Return False
			EndIf
		Else
		
			If $bDebug Then DebugsInsideDiamond($iX, $iY, $iLeft, $iRight, $iTop, $iBottom, False)
			
			SetDebugLog("[isInsideDiamond] Coordinate Outside Village")
			Return False ; Outside Village
		EndIf
		
		;SetDebugLog("[isInsideDiamond] Coordinate Inside Village", $COLOR_DEBUG)
		Return True ; Inside Village
	Else
		SetLog("[isInsideDiamond] Invalid input", $COLOR_ERROR)
		Return False ; Outside Village
	EndIf
EndFunc   ;==>isInsideDiamond

Func DebugsInsideDiamond($iX, $iY, $iLeft, $iRight, $iTop, $iBottom, $bFound = False)
	Local $subdirectory = $g_sprofiletempdebugpath & "isInsideDiamond"
	DirCreate($subdirectory)
	Local $date = @YEAR & "-" & @MON & "-" & @MDAY, $time = @HOUR & "." & @MIN & "." & @SEC
	Local $hLocalHBitmap = _CaptureRegion(0, 0, $g_iGAME_WIDTH, $g_iGAME_HEIGHT, True)
	Local $editedimage = _gdiplus_bitmapcreatefromhbitmap($hLocalHBitmap)
	Local $hgraphic = _gdiplus_imagegetgraphicscontext($editedimage)
	Local $hpenblue = _gdiplus_pencreate(0xC00FBAE9, 2)
	Local $filename = String($date & "_" & $time & "_isInsideDiamond_.png")

	;-- DRAW VERTICAL AND HORIZONTAL LINES
	_GDIPlus_GraphicsDrawLine($hGraphic, $iLeft, $iTop + ($iBottom - $iTop) / 2, $iRight, $iTop + ($iBottom - $iTop) / 2, $hpenblue)
	_GDIPlus_GraphicsDrawLine($hGraphic, $iLeft + ($iRight - $iLeft) / 2, $iTop, $iLeft + ($iRight - $iLeft) / 2, $iBottom, $hpenblue)
	
	Local $hPenHandle = _gdiplus_pencreate(($bFound = False) ? (0xC0FF0000) : (0xC0FFFF00), 2)
	_GDIPlus_GraphicsDrawArc($hGraphic, $iX, $iY, 10, 10, 0, 360, $hPenHandle)
	_GDIPlus_GraphicsDrawLine($hGraphic, $iX - 15, $iY, $iX, $iY + 15, $hpenblue)
	_GDIPlus_GraphicsDrawLine($hGraphic, $iX, $iY - 15, $iX, $iY + 15, $hpenblue)

	_gdiplus_imagesavetofile($editedimage, $subdirectory & "\" & $filename)

	If $hLocalHBitmap <> 0 Then GdiDeleteHBitmap($hLocalHBitmap)
	_gdiplus_pendispose($hpenblue)
	_gdiplus_pendispose($hPenHandle)
	_gdiplus_graphicsdispose($hgraphic)
	_gdiplus_bitmapdispose($editedimage)
EndFunc   ;==>DebugInternalExternArea
