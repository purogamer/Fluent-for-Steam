; #FUNCTION# ====================================================================================================================
; Name ..........: SaveDebugImage
; Description ...: Saves a copy of the current BS image to the Temp Folder for later review
; Syntax ........: SaveDebugImage()
; Parameters ....: $sImageName             - [optional] text string to use as part of saved filename. Default is "Unknown".
; Return values .: None
; Author ........: KnowJack (08/2015)
; Modified ......: Sardo (01/2016)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func SaveDebugImage($sImageName = "Unknown", $vCaptureNew = Default, $bCreateSubFolder = Default, $sTag = "")
	
	If $g_bDebugImageSave = False And $g_bDebugSetlog = False Then Return ; Custom - Team AIO Mod++

	If $vCaptureNew = Default Then $vCaptureNew = True
	If $bCreateSubFolder = Default Then $bCreateSubFolder = True

	Local $sDate = @MDAY & "." & @MON & "." & @YEAR
	Local $sTime = @HOUR & "." & @MIN & "." & @SEC

	Local $sFolderPath = $g_sProfileTempDebugPath

	If $bCreateSubFolder Then
		$sFolderPath = $g_sProfileTempDebugPath & $sImageName & "\"
		DirCreate($sFolderPath)
	EndIf

	Local $bAlreadyExists = True, $bFirst = True
	local $iCount = 1
	Local $sFullFileName = ""

	While $bAlreadyExists
		If $bFirst Then
			$bFirst = False
			$sFullFileName = $sFolderPath & $sImageName & $sTag & $sDate & " at " & $sTime & ".png"
			If FileExists($sFullFileName) Then
				$bAlreadyExists = True
			Else
				$bAlreadyExists = False
			EndIf
		Else
			$sFullFileName = $sFolderPath & $sImageName & $sTag & $sDate & " at " & $sTime & " (" & $iCount & ").png"
			If FileExists($sFullFileName) Then
				$iCount +=1
			Else
				$bAlreadyExists = False
			EndIf
		EndIf
	WEnd

	If IsBool($vCaptureNew) And $vCaptureNew Then _CaptureRegion2()

	If IsPtr($vCaptureNew) Then
		_GDIPlus_ImageSaveToFile($vCaptureNew, $sFullFileName)
		SetDebugLog("DebugImageSave(" & $vCaptureNew & ") " & $sFullFileName, $COLOR_DEBUG)
	Else
		Local $EditedImage = _GDIPlus_BitmapCreateFromHBITMAP($g_hHBitmap2)
		_GDIPlus_ImageSaveToFile($EditedImage, $sFullFileName)
		_GDIPlus_BitmapDispose($EditedImage)
		SetDebugLog("DebugImageSave " & $sFullFileName, $COLOR_DEBUG)
	EndIf

	If _Sleep($DELAYDEBUGIMAGESAVE1) Then Return
EndFunc   ;==>SaveDebugImage

Func SaveDebugRectImage($sImageName = "Unknown", $sArea = "" , $vCaptureNew = Default, $bCreateSubFolder = Default, $sTag = "")

	If $vCaptureNew = Default Then $vCaptureNew = True
	If $bCreateSubFolder = Default Then $bCreateSubFolder = True

	Local $aiArea = GetRectArray($sArea)
	If UBound($aiArea) = 0 Or @Error Then
		SetLog("[SaveDebugRectImage] Wrong area")
		Return
	EndIf

	Local $x1 = Number($aiArea[0])
	Local $y1 = Number($aiArea[1])
	Local $x2 = Number($aiArea[2])
	Local $y2 = Number($aiArea[3])

	Local $sDate = @MDAY & "." & @MON & "." & @YEAR
	Local $sTime = @HOUR & "." & @MIN & "." & @SEC

	Local $sFolderPath = $g_sProfileTempDebugPath

	If $bCreateSubFolder Then
		$sFolderPath = $g_sProfileTempDebugPath & $sImageName & "\"
		DirCreate($sFolderPath)
	EndIf

	Local $bAlreadyExists = True, $bFirst = True
	local $iCount = 1
	Local $sFullFileName = ""

	While $bAlreadyExists
		If $bFirst Then
			$bFirst = False
			$sFullFileName = $sFolderPath & $sImageName & $sTag & $sDate & " at " & $sTime & ".png"
			If FileExists($sFullFileName) Then
				$bAlreadyExists = True
			Else
				$bAlreadyExists = False
			EndIf
		Else
			$sFullFileName = $sFolderPath & $sImageName & $sTag & $sDate & " at " & $sTime & " (" & $iCount & ").png"
			If FileExists($sFullFileName) Then
				$iCount +=1
			Else
				$bAlreadyExists = False
			EndIf
		EndIf
	WEnd
	
	If IsBool($vCaptureNew) And $vCaptureNew Then _CaptureRegion2()

	If IsPtr($vCaptureNew) Then
		_GDIPlus_ImageSaveToFile($vCaptureNew, $sFullFileName)
		SetDebugLog("DebugImageSave(" & $vCaptureNew & ") " & $sFullFileName, $COLOR_DEBUG)
	Else
		; Store a copy of the image handle
		Local $editedImage = _GDIPlus_BitmapCreateFromHBITMAP($g_hHBitmap2)
		
		; Needed for editing the picture
		Local $hGraphic = _GDIPlus_ImageGetGraphicsContext($editedImage)
		Local $hPen = _GDIPlus_PenCreate(0xFFFF0000, 2) ; Create a pencil Color FF0000/RED
		Local $hPen2 = _GDIPlus_PenCreate(0xFF000000, 2) ; Create a pencil Color FFFFFF/BLACK

		_GDIPlus_GraphicsDrawRect($hGraphic, $x1, $y1, $x2 - $x1, $y2 - $y1, $hPen)
	
		_GDIPlus_ImageSaveToFile($editedImage, $sFullFileName)

		_GDIPlus_PenDispose($hPen)
		_GDIPlus_PenDispose($hPen2)
		_GDIPlus_GraphicsDispose($hGraphic)		
		_GDIPlus_BitmapDispose($editedImage)
		
		If $g_bDebugSetlog Then SetDebugLog("DebugImageSave " & $sFullFileName, $COLOR_DEBUG)
	EndIf

	If _Sleep($DELAYDEBUGIMAGESAVE1) Then Return
EndFunc   ;==>SaveDebugImage

Func SaveDebugPointImage($sImageName = "Unknown", $aiPoint = 0, $vCaptureNew = Default, $bCreateSubFolder = Default, $sTag = "")

	If $vCaptureNew = Default Then $vCaptureNew = True
	If $bCreateSubFolder = Default Then $bCreateSubFolder = True
	
	If UBound($aiPoint) = 0 Or @Error Then
		SetLog("[SaveDebugPointImage] Wrong point")
		Return
	EndIf
	
	Local $x = $aiPoint[0]
	Local $y = $aiPoint[1]

	Local $sDate = @MDAY & "." & @MON & "." & @YEAR
	Local $sTime = @HOUR & "." & @MIN & "." & @SEC

	Local $sFolderPath = $g_sProfileTempDebugPath

	If $bCreateSubFolder Then
		$sFolderPath = $g_sProfileTempDebugPath & $sImageName & "\"
		DirCreate($sFolderPath)
	EndIf

	Local $bAlreadyExists = True, $bFirst = True
	local $iCount = 1
	Local $sFullFileName = ""

	While $bAlreadyExists
		If $bFirst Then
			$bFirst = False
			$sFullFileName = $sFolderPath & $sImageName & $sTag & $sDate & " at " & $sTime & ".png"
			If FileExists($sFullFileName) Then
				$bAlreadyExists = True
			Else
				$bAlreadyExists = False
			EndIf
		Else
			$sFullFileName = $sFolderPath & $sImageName & $sTag & $sDate & " at " & $sTime & " (" & $iCount & ").png"
			If FileExists($sFullFileName) Then
				$iCount +=1
			Else
				$bAlreadyExists = False
			EndIf
		EndIf
	WEnd
	
	If IsBool($vCaptureNew) And $vCaptureNew Then _CaptureRegion2()

	If IsPtr($vCaptureNew) Then
		_GDIPlus_ImageSaveToFile($vCaptureNew, $sFullFileName)
		SetDebugLog("DebugImageSave(" & $vCaptureNew & ") " & $sFullFileName, $COLOR_DEBUG)
	Else
		; Store a copy of the image handle
		Local $editedImage = _GDIPlus_BitmapCreateFromHBITMAP($g_hHBitmap2)
		
		; Needed for editing the picture
		Local $hGraphic = _GDIPlus_ImageGetGraphicsContext($editedImage)
		Local $hPen = _GDIPlus_PenCreate(0xFFFF0000, 2) ; Create a pencil Color FF0000/RED
		Local $hPen2 = _GDIPlus_PenCreate(0xFF000000, 2) ; Create a pencil Color FFFFFF/BLACK

		_GDIPlus_GraphicsDrawArc($hGraphic, $x, $y, 10, 10, 0, 360, $hPen)
	
		_GDIPlus_ImageSaveToFile($editedImage, $sFullFileName)

		_GDIPlus_PenDispose($hPen)
		_GDIPlus_PenDispose($hPen2)
		_GDIPlus_GraphicsDispose($hGraphic)		
		_GDIPlus_BitmapDispose($editedImage)
		
		If $g_bDebugSetlog Then SetDebugLog("DebugImageSave " & $sFullFileName, $COLOR_DEBUG)
	EndIf

	If _Sleep($DELAYDEBUGIMAGESAVE1) Then Return
EndFunc   ;==>SaveDebugPointImage