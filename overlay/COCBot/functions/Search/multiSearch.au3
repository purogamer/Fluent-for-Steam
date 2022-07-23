; #FUNCTION# ====================================================================================================================
; Name ..........: multiSearch
; Description ...: Various functions to return information from a multiple tile search
; Syntax ........:
; Parameters ....: None
; Return values .: An array of values of detected defense levels and information
; Author ........: LunaEclipse(April 2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func updateMultiSearchStats($aResult, $statFile = "")
	Switch $statFile
		Case $g_sProfileBuildingStatsPath
			updateWeakBaseStats($aResult)
		Case Else
			; Don't log stats at present
	EndSwitch
EndFunc   ;==>updateMultiSearchStats

Func addInfoToDebugImage(ByRef $hGraphic, ByRef $hPen, $fileName, $x, $y)
	; Draw the location on the image
	_GDIPlus_GraphicsDrawRect($hGraphic, $x - 5, $y - 5, 10, 10, $hPen)

	; Store the variables needed for writing the text
	Local $hBrush = _GDIPlus_BrushCreateSolid(0xFFFFFFFF)
	Local $hFormat = _GDIPlus_StringFormatCreate()
	Local $hFamily = _GDIPlus_FontFamilyCreate("Tahoma")
	Local $hFont = _GDIPlus_FontCreate($hFamily, 12, 2)
	Local $tLayout = _GDIPlus_RectFCreate($x + 10, $y, 0, 0)
	Local $sString = String($fileName)
	Local $aInfo = _GDIPlus_GraphicsMeasureString($hGraphic, $sString, $hFont, $tLayout, $hFormat)

	; Write the level found on the image
	_GDIPlus_GraphicsDrawStringEx($hGraphic, $sString, $hFont, $aInfo[0], $hFormat, $hBrush)

	; Dispose all resources
	$tLayout = 0
	_GDIPlus_FontDispose($hFont)
	_GDIPlus_FontFamilyDispose($hFamily)
	_GDIPlus_StringFormatDispose($hFormat)
	_GDIPlus_BrushDispose($hBrush)
EndFunc   ;==>addInfoToDebugImage

Func captureDebugImage($aResult, $subDirectory)
	If TestCapture() Then Return ; no debug images required when testing with button special things...
	Local $coords

	If IsArray($aResult) Then
		; Create the directory in case it doesn't exist
		DirCreate($g_sProfileTempDebugPath & $subDirectory)

		; Store a copy of the image handle
		Local $editedImage = _GDIPlus_BitmapCreateFromHBITMAP($g_hHBitmap2)

		; Create the timestamp and filename
		Local $Date = @YEAR & "-" & @MON & "-" & @MDAY
		Local $Time = @HOUR & "." & @MIN & "." & @SEC
		Local $fileName = String($Date & "_" & $Time & ".png")

		; Needed for editing the picture
		Local $hGraphic = _GDIPlus_ImageGetGraphicsContext($editedImage)
		Local $hPen = _GDIPlus_PenCreate(0xFFFF0000, 2) ; Create a pencil Color FF0000/RED

		; Edit the image with information about items found
		For $i = 1 To UBound($aResult) - 1
			; Check to make sure there is results to display
			If Number($aResult[$i][4]) > 0 Then
				; Retrieve the coords sub-array
				$coords = $aResult[$i][5]

				If IsArray($coords) Then
					; Loop through all found points for the item and add them to the image
					For $j = 0 To UBound($coords) - 1
						Local $coord = $coords[$j]
						If UBound($coord) > 1 Then
							addInfoToDebugImage($hGraphic, $hPen, $aResult[$i][0], $coord[0], $coord[1])
						EndIf
					Next
				EndIf
			EndIf
		Next

		; Display the time take for the search
		_GDIPlus_GraphicsDrawString($hGraphic, "Time Taken:" & $aResult[0][2] & " " & $aResult[0][3], 350, 50, "Verdana", 20)

		; Save the image and release any memory
		_GDIPlus_ImageSaveToFile($editedImage, $g_sProfileTempDebugPath & $subDirectory & "\" & $fileName)
		_GDIPlus_PenDispose($hPen)
		_GDIPlus_GraphicsDispose($hGraphic)
		_GDIPlus_BitmapDispose($editedImage)
	EndIf
EndFunc   ;==>captureDebugImage

Func updateResultsRow(ByRef $aResult, $redLines = "")
	; Create the local variable to do the counting
	Local $numberFound = 0

	If IsArray($aResult) Then
		; Loop through the results to get the total number of objects found
		If UBound($aResult) > 1 Then
			For $j = 1 To UBound($aResult) - 1
				$numberFound += Number($aResult[$j][4])
			Next
		EndIf

		; Store the redline data in case we need to do more searches
		$aResult[0][0] = $redLines
		$aResult[0][1] = $numberFound ; Store the total number found
	Else
		; Not an array, so we are not going to do anything, this should only happen if there is a problem
	EndIf
EndFunc   ;==>updateResultsRow

Func multiMatches($directory, $maxReturnPoints = 0, $fullCocAreas = $CocDiamondDCD, $redLines = $CocDiamondDCD, $statFile = "", $minLevel = 0, $maxLevel = 1000, $forceCaptureRegion = True)
	; Setup arrays, including default return values for $return
	Local $aResult[1][6] = [["", 0, 0, "Seconds", "", ""]], $aCoordArray[0][0], $aCoords, $aCoordsSplit, $aValue

	; Capture the screen for comparison
	If $forceCaptureRegion = True Then _CaptureRegion2()

	; Perform the search
	Local $res = DllCallMyBot("SearchMultipleTilesBetweenLevels", "handle", $g_hHBitmap2, "str", $directory, "str", $fullCocAreas, "Int", $maxReturnPoints, "str", $redLines, "Int", $minLevel, "Int", $maxLevel)
	If @error Then _logErrorDLLCall($g_sLibMyBotPath, @error)

	; Get the redline data
	$aValue = DllCall($g_hLibMyBot, "str", "GetProperty", "str", "redline", "str", "")
	If @error Then _logErrorDLLCall($g_sLibMyBotPath, @error)
	$redLines = $aValue[0]

	If $res[0] <> "" Then
		; Get the keys for the dictionary item.
		Local $aKeys = StringSplit($res[0], "|", $STR_NOCOUNT)

		; Redimension the result array to allow for the new entries
		ReDim $aResult[UBound($aKeys) + 1][6]

		; Loop through the array
		For $i = 0 To UBound($aKeys) - 1
			; Get the property values
			$aResult[$i + 1][0] = RetrieveImglocProperty($aKeys[$i], "filename")
			$aResult[$i + 1][1] = RetrieveImglocProperty($aKeys[$i], "objectname")
			$aResult[$i + 1][2] = RetrieveImglocProperty($aKeys[$i], "objectlevel")
			$aResult[$i + 1][3] = RetrieveImglocProperty($aKeys[$i], "fillLevel")
			$aResult[$i + 1][4] = RetrieveImglocProperty($aKeys[$i], "totalobjects")

			; Get the coords property
			$aValue = RetrieveImglocProperty($aKeys[$i], "objectpoints")
			$aCoords = StringSplit($aValue, "|", $STR_NOCOUNT)
			ReDim $aCoordArray[UBound($aCoords)][2]

			; Loop through the found coords
			For $j = 0 To UBound($aCoords) - 1
				; Split the coords into an array
				$aCoordsSplit = StringSplit($aCoords[$j], ",", $STR_NOCOUNT)
				If UBound($aCoordsSplit) = 2 Then
					; Store the coords into a two dimensional array
					$aCoordArray[$j][0] = $aCoordsSplit[0] ; X coord.
					$aCoordArray[$j][1] = $aCoordsSplit[1] ; Y coord.
				EndIf
			Next

			; Store the coords array as a sub-array
			$aResult[$i + 1][5] = $aCoordArray
		Next
	EndIf

	; Updated the results row of the array, no need to assign to a variable, because the array is passed ByRef,
	; so the function updates the array that is passed as a parameter.
	updateResultsRow($aResult, $redLines)
	updateMultiSearchStats($aResult, $statFile)

	Return $aResult
EndFunc   ;==>multiMatches

Func returnMultipleMatchesOwnVillage($directory, $maxReturnPoints = 0, $statFile = "", $minLevel = 0, $maxLevel = 1000, $forceCaptureRegion = True)
	; This is simple, just do a multiMatch search, but pass $CocDiamondECD for the redlines and full coc area
	; so whole village is checked because obstacles can appear on the outer grass area
	Local $aResult = multiMatches($directory, $maxReturnPoints, $CocDiamondECD, $CocDiamondECD, $statFile, $minLevel, $maxLevel, $forceCaptureRegion)

	Return $aResult
EndFunc   ;==>returnMultipleMatchesOwnVillage

Func returnSingleMatchOwnVillage($directory, $statFile = "", $minLevel = 0, $maxLevel = 1000, $forceCaptureRegion = True)
	; This is simple, just do a multiMatch search, with 1 return point but pass $CocDiamondECD for the redlines
	; and full coc area so whole village is checked because obstacles can appear on the outer grass area
	Local $aResult = multiMatches($directory, 1, $CocDiamondECD, $CocDiamondECD, $statFile, $minLevel, $maxLevel, $forceCaptureRegion)

	Return $aResult
EndFunc   ;==>returnSingleMatchOwnVillage

Func returnAllMatches($directory, $redLines = $CocDiamondDCD, $statFile = "", $minLevel = 0, $maxLevel = 1000, $forceCaptureRegion = True)
	; This is simple, just do a multiMatches search with 0 for the Max return points parameter
	Local $aResult = multiMatches($directory, 0, $CocDiamondDCD, $redLines, $statFile, $minLevel, $maxLevel, $forceCaptureRegion)

	Return $aResult
EndFunc   ;==>returnAllMatches

Func returnHighestLevelSingleMatch($directory, $redLines = $CocDiamondDCD, $statFile = "", $minLevel = 0, $maxLevel = 1000, $forceCaptureRegion = True)
	; Setup default return coords of 0,0
	Local $defaultCoords[1][2] = [[0, 0]]
	; Setup arrays, including default return values for $return
	Local $return[7] = ["None", "None", 0, 0, 0, $defaultCoords, ""]

	; This is simple, just do a multiMatches search with 1 for the Max return points parameter
	Local $aResult = multiMatches($directory, 1, $CocDiamondDCD, $redLines, $statFile, $minLevel, $maxLevel, $forceCaptureRegion)

	If UBound($aResult) > 1 Then
		; Now loop through the array to modify values, select the highest entry to return
		For $i = 1 To UBound($aResult) - 1
			; Check to see if its a higher level then currently stored
			If Number($aResult[$i][2]) > Number($return[2]) Then
				; Store the data because its higher
				$return[0] = $aResult[$i][0] ; Filename
				$return[1] = $aResult[$i][1] ; Type
				$return[2] = $aResult[$i][2] ; Level
				$return[3] = $aResult[$i][3] ; Fill Percent
				$return[4] = $aResult[$i][4] ; Total Objects
				$return[5] = $aResult[$i][5] ; Coords
			EndIf
		Next
	EndIf
	; Add the redline data if we want to make future searches faster
	$return[6] = $aResult[0][0] ; Redline Data

	Return $return
EndFunc   ;==>returnHighestLevelSingleMatch

Func returnLowestLevelSingleMatch($directory, $returnMax = 100, $redLines = $CocDiamondDCD, $statFile = "", $minLevel = 0, $maxLevel = 1000, $forceCaptureRegion = True)
	; Setup default return coords of 0,0
	Local $defaultCoords[1][2] = [[0, 0]]
	; Setup arrays, including default return values for $return
	Local $return[7] = ["None", "None", $returnMax + 1, 0, 0, $defaultCoords, ""]

	; This is simple, just do a multiMatches search with 1 for the Max return points parameter
	Local $aResult = multiMatches($directory, 1, $CocDiamondDCD, $redLines, $statFile, $minLevel, $maxLevel, $forceCaptureRegion)

	If UBound($aResult) > 1 Then
		; Now loop through the array to modify values, select the lowest entry to return
		For $i = 1 To UBound($aResult) - 1
			; Check to see if its a lower level then currently stored
			If Number($aResult[$i][2]) < Number($return[2]) Then
				; Store the data because its lower
				$return[0] = $aResult[$i][0] ; Filename
				$return[1] = $aResult[$i][1] ; Type
				$return[2] = $aResult[$i][2] ; Level
				$return[3] = $aResult[$i][3] ; Fill Percent
				$return[4] = $aResult[$i][4] ; Total Objects
				$return[5] = $aResult[$i][5] ; Coords
			EndIf
		Next
	EndIf
	; Add the redline data if we want to make future searches faster
	$return[6] = $aResult[0][0] ; Redline Data

	Return $return
EndFunc   ;==>returnLowestLevelSingleMatch

Func returnMultipleMatches($directory, $maxReturnPoints = 0, $redLines = $CocDiamondDCD, $statFile = "", $minLevel = 0, $maxLevel = 1000, $forceCaptureRegion = True)
	; This is simple, just do a multiMatches search specifying the Max return points parameter
	Local $aResult = multiMatches($directory, $maxReturnPoints, $CocDiamondDCD, $redLines, $statFile, $minLevel, $maxLevel)

	Return $aResult
EndFunc   ;==>returnMultipleMatches

Func returnSingleMatch($directory, $redLines = $CocDiamondDCD, $statFile = "", $minLevel = 0, $maxLevel = 1000, $forceCaptureRegion = True)
	; This is simple, just do a multiMatches search with 1 for the Max return points parameter
	Local $aResult = multiMatches($directory, 1, $CocDiamondDCD, $redLines, $statFile, $minLevel, $maxLevel, $forceCaptureRegion)

	Return $aResult
EndFunc   ;==>returnSingleMatch
