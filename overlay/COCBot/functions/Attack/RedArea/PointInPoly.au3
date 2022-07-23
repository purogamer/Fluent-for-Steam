
; #FUNCTION# ====================================================================================================================
; Name ..........: _IsPointInPoly
; Description ...:
; Syntax ........: _IsPointInPoly($x, $y, $aPoints)
; Parameters ....: $x                   - an unknown value.
;                  $y                   - an unknown value.
;                  $aPoints             - an array of points defining the polygon, must be closed polygon, closing point is not counted in total number of vertex
;                : $aPoints [0][0] = number of vertex, each row holds x, y
; Return values .: None
; Author ........: Malkey from https://www.autoitscript.com/forum/topic/89034-check-if-a-point-is-within-various-defined-closed-shapes/
; Modified ......: MonkeyHunter (05-2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func _IsPointInPoly($x, $y, $aPoints)
	; ($x, $y)        - x, y position of the point to check
	; $aPoints - An array of x,y values representing the nodes of a polygon.
	; Finds the individual x values of the interestion of the individual sides of the polygon with the
	; line y = $y (parallel with x-axis). If the number of x values found greater than $x is even, then
	; the ($x, $y) point is outside the closed polygon. Plus, if $y is beyond the y values of the end
	; points of individual sides of the polygon, the y = $y line will not interest with that side and will
	; not be counted. Returns equivalent of, even number of intersections false, and, odd true(inside polygon).
	Local $bEvenNum = False, $xOnLine, $yMin, $yMax
	For $i = 1 To $aPoints[0][0]
		$yMin = ($aPoints[$i + 1][1] < $aPoints[$i][1] ? $aPoints[$i + 1][1] : $aPoints[$i][1])
		$yMax = ($aPoints[$i + 1][1] > $aPoints[$i][1] ? $aPoints[$i + 1][1] : $aPoints[$i][1])
		$xOnLine = -($y * $aPoints[$i + 1][0] - $y * $aPoints[$i][0] - $aPoints[$i][1] * $aPoints[$i + 1][0] + _
				$aPoints[$i][0] * $aPoints[$i + 1][1]) / (-$aPoints[$i + 1][1] + $aPoints[$i][1])
		If ($x < $xOnLine) And ($y > $yMin) And ($y <= $yMax) Then $bEvenNum = Not $bEvenNum
	Next
	Return $bEvenNum
EndFunc   ;==>_IsPointInPoly


; #FUNCTION# ====================================================================================================================
; Name ..........: IsPointOnSide
; Description ...: uses _IsPointInPoly with triangle polygons to determine if drop point is one side of base as specified in string $sSide
; Syntax ........: IsPointOnSide($aCoords, $sSide)
; Parameters ....: $aCoords             - an array with single row array inside holding x,y, as returned by GetListPixel
;                  $sSide               - a string with name of side to check
; Return values .: True if inside polygon
; Author ........: MonkeyHunter (05-2017)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func IsPointOnSide($aCoords, $sSide)
	If IsArray($aCoords) = False Then
		SetLog("IsPointOnSide() coordinates array not recognized", $COLOR_ERROR)
		Return SetError(1, 0, "")
	EndIf
	Switch $sSide
		Case "TL", "TOP-LEFT-UP", "TOP-LEFT-DOWN"
			; $aPoints [0][0] = number of vertex, each row holds x, y
			Local $apoints[5][2] = [[3, 0], [$DiamondMiddleX, $DiamondMiddleY], [5, $DiamondMiddleY], [$DiamondMiddleX, 30], [$DiamondMiddleX, $DiamondMiddleY]]
		Case "TR", "TOP-RIGHT-UP", "TOP-RIGHT-DOWN"
			Local $apoints[5][2] = [[3, 0], [$DiamondMiddleX, $DiamondMiddleY], [$DiamondMiddleX, 30], [845, $DiamondMiddleY], [$DiamondMiddleX, $DiamondMiddleY]]
		Case "BL", "BOTTOM-LEFT-UP", "BOTTOM-LEFT-DOWN"
			Local $apoints[5][2] = [[3, 0], [$DiamondMiddleX, $DiamondMiddleY], [5, $DiamondMiddleY], [$DiamondMiddleX, 620], [$DiamondMiddleX, $DiamondMiddleY]]
		Case "BR", "BOTTOM-RIGHT-UP", "BOTTOM-RIGHT-DOWN"
			Local $apoints[5][2] = [[3, 0], [$DiamondMiddleX, $DiamondMiddleY], [845, $DiamondMiddleY], [$DiamondMiddleX, 620], [$DiamondMiddleX, $DiamondMiddleY]]
		Case Else
			SetLog("IsPointOnSide() 'side' string not recognized", $COLOR_ERROR)
			Return SetError(1, 0, "")
	EndSwitch
	Return _IsPointInPoly($aCoords[0], $aCoords[1], $aPoints)
EndFunc   ;==>IsPointOnSide

; #FUNCTION# ====================================================================================================================
; Name ..........: RemoveDupNearby
; Description ...: accepts DLL string with locations and checks each location against others looking for duplicate within a defined by $iDistance
;                : Uses WINAPI call to PtInRect to find if inside square plygon
; Syntax ........: RemoveDupNearby(BYREF $sLocCoord[, $iDistance = 5])
; Parameters ....: $sLocCoord           - a BYREF string of locations x,y| x1,y1|...|xR,yR as returned by DLL
;                  $iDistance           - [optional] an integer value for size of square used to check for duplicate locations. Default is 5.
; Return values .: New count of locations in string
; Author ........: MonkeyHunter (05-2017)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func RemoveDupNearby(ByRef $sLocCoord, $iDistance = 8)

	SetDebugLog("Begin RemoveDupNearby", $COLOR_DEBUG1)

	Local $aCoord = StringSplit($sLocCoord, "|")
	Local $aLoc1, $aLoc2, $bRemovedDuplicate = False
	Local $sTmpVector = ""
#comments-start
	If $g_bDebugSetlog Then ; debug log values till know code is working...
		Local $sText = "INPUT $aCoord"
		SetLog("INPUT $aCoord count= " & $aCoord[0], $COLOR_DEBUG)
		SetLog("INPUT $sLocCoord= " & $sLocCoord, $COLOR_DEBUG)
		For $p = 1 To $aCoord[0]
			$sText &= "[" & $p & "}:" & $aCoord[$p] & "; "
		Next
		SetLog($sText, $COLOR_DEBUG)
	EndIf
#comments-end
	If IsArray($aCoord) Then
		For $ep = 1 To $aCoord[0] ;loop through existing points
			If $aCoord[$ep] = "" Then ContinueLoop ; prevent errors after removing duplicate locations
			$aLoc1 = StringSplit($aCoord[$ep], ",") ; separate x & y
			If $aLoc1[0] = 2 Then
				For $np = 1 To $aCoord[0] ; loop thru points
					If $np = $ep Then ContinueLoop ; do not check loctiona against itself!
					$aLoc2 = StringSplit($aCoord[$np], ",") ; separate x & y
					If $aCoord[$np] = "" Then ContinueLoop ; prevent errors after removing duplicate locations
					If $aLoc2[0] = 2 Then
						; is new location inside rectangle of existing location +/- $iDistance using WINAPI
						If _WinAPI_PtInRectEx($aLoc2[1], $aLoc2[2], $aLoc1[1] - $iDistance, $aLoc1[2] - $iDistance, $aLoc1[1] + $iDistance, $aLoc1[2] + $iDistance) = True Then
							SetDebugLog("Duplicate location found, skipping: " & $aLoc2[1] & "," & $aLoc2[2], $COLOR_INFO)
							$aCoord[$np] = "" ; zero out location points
							$bRemovedDuplicate = True
						EndIf
					Else
						SetLog("RemoveDupNearby stringsplit value error!", $COLOR_ERROR)
					EndIf
				Next
			Else
				SetLog("RemoveDupNearby string value error!", $COLOR_ERROR)
			EndIf
		Next
	Else
		SetLog("RemoveDupNearby location string paramenter error!", $COLOR_ERROR)
	EndIf

	If $bRemovedDuplicate = True Then

		For $np = 1 To $aCoord[0] ; assemble new string with empty values removed
			If StringStripWS($aCoord[$np], $STR_STRIPALL) = "" Then ContinueLoop
			$aLoc1 = StringSplit($aCoord[$np], ",") ; separate x & y
			If @error Then ContinueLoop
			$sTmpVector &= $aLoc1[1] & "," & $aLoc1[2] & "|"
		Next

		If StringLen($sTmpVector) > 0 Then $sTmpVector = StringLeft($sTmpVector, StringLen($sTmpVector) - 1) ; clean excess "|" from string
		SetDebugLog("Return $sTmpVector= " & $sTmpVector, $COLOR_DEBUG)


		If StringInStr($sTmpVector, "|", $STR_NOCASESENSEBASIC) > 0 Then ; have more than 1 location
			Local $aCoord2 = StringSplit($sTmpVector, "|") ; split to obtain new coord count
			If @error Then
				SetDebugLog("$sTmpVector string split failed: " & $aCoord2[1] & " , skip duplicate removal", $COLOR_WARNING)
				Return $aCoord[0] ; failsafe exit = always return same count as given
			EndIf
		Else ; have one location
			If $sTmpVector <> "" then  ; if not empty
				Local $aCoord2 = [ 1, $sTmpVector]
			Else
				SetDebugLog("Impossible error: RemoveDupNearby removed all points!", $COLOR_ERROR)
				Return $aCoord[0]
			EndIf
		EndIf

		If $g_bDebugSetlog And $aCoord[0] <> $aCoord2[0] Then
			SetDebugLog("Duplicate objectpoints found, removed: " & $aCoord[0] - $aCoord2[0], $COLOR_INFO)
			SetDebugLog("Final Coords count= " & $aCoord2[0], $COLOR_DEBUG)
		EndIf

		$sLocCoord = $sTmpVector ; If no errors in count, change BYREF string to new one.

		Return $aCoord2[0] ; return new count

	Else

		Return $aCoord[0] ; no duplicates, return original count

	EndIf

EndFunc   ;==>RemoveDupNearby


; #FUNCTION# ====================================================================================================================
; Name ..........: AddPoints_RemoveDuplicate
; Description ...: check if $sLoc2Coord locations are within square area that is +- $iDistance pixels from $sLoc1Coord locations
;                : adds any locations to existing location string that are not duplicate position based on $iDistance
;                : Uses WINAPI call to PtInRect to find if inside square polygon
; Syntax ........: AddPoints_RemoveDuplicate(Byref $sLoc1Coord, $sLoc2Coord, $iReturnpoints[, $iDistance = 8])
; Parameters ....: $sLoc1Coord          - [in/out] a string of location values same as provided by MBR DLL x,y|x1,y1|x2,y2|...|xR,yR
;                  $sLoc2Coord          - a second string of location values same as provided by MBR DLL x,y|x1,y1|x2,y2|...|xR,yR that is added to BYREF $sLoc1Coord if not duplicated
;                  $iReturnpoints       - an integer of maximum number of locations wanted to returned
;                  $iDistance           - [optional] an integer of allowable pixel distance variation to consider location values as duplicate image find. Default is 8.
; Return values .: Returns new count of locations in $sLoc1Coord - adds new points to Existing location string by reference
; Author ........: MonkeyHunter (05-2017)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func AddPoints_RemoveDuplicate(ByRef $sLoc1Coord, $sLoc2Coord, $iReturnpoints, $iDistance = 8)

	SetDebugLog("Begin AddPoints_RemoveDuplicate", $COLOR_DEBUG1)

	Local $aCoord1 = StringSplit($sLoc1Coord, "|")
	Local $aCoord2 = StringSplit($sLoc2Coord, "|")
	Local $aLoc1, $aLoc2
	Local $iPointsAdded = 0
#comments-start
	If $g_bDebugSetlog Then ; debug log values till know code is working...
		Local $sText = "INPUT $aCoord1"
		SetLog("INPUT $aCoord1 count " & $aCoord1[0], $COLOR_DEBUG)
		For $p = 1 To $aCoord1[0]
			$sText &= "[" & $p & "}:" & $aCoord1[$p] & "; "
		Next
		SetLog($sText, $COLOR_DEBUG)
		$sText = "INPUT $aCoord2"
		SetLog("INPUT $aCoord2 count " & $aCoord2[0], $COLOR_DEBUG)
		For $p = 1 To $aCoord2[0]
			$sText &= "[" & $p & "}:" & $aCoord2[$p] & "; "
		Next
		SetLog($sText, $COLOR_DEBUG)
	EndIf
#comments-end
	If IsArray($aCoord1) And IsArray($aCoord2) Then
		For $ep = 1 To $aCoord1[0] ;loop through existing points
			$aLoc1 = StringSplit($aCoord1[$ep], ",") ; separate x & y
			If $aLoc1[0] = 2 Then
				For $np = 1 To $aCoord2[0] ; loop thru new points
					If $aCoord2[$np] = "" Then ContinueLoop ; prevent errors after removing duplicate locations
					$aLoc2 = StringSplit($aCoord2[$np], ",") ; separate x & y
					If $aLoc2[0] = 2 Then
						; is new location inside rectangle of existing location +/- $iDistance using WINAPI
						If _WinAPI_PtInRectEx($aLoc2[1], $aLoc2[2], $aLoc1[1] - $iDistance, $aLoc1[2] - $iDistance, $aLoc1[1] + $iDistance, $aLoc1[2] + $iDistance) = True Then
							SetDebugLog("Duplicate location found, skipping: " & $aLoc2[1] & "," & $aLoc2[2], $COLOR_INFO)
							$aCoord2[$np] = "" ; zero out location points
						EndIf
					Else
						SetLog("RemoveDuplicatePoints New string value error!", $COLOR_ERROR)
					EndIf
				Next
			Else
				SetLog("RemoveDuplicatePoints Existing string value error!", $COLOR_ERROR)
			EndIf
		Next
#comments-start
		If $g_bDebugSetlog Then ; debug log values till know code is working...
			Local $sText = "OUTPUT $aCoord1"
			SetLog("OUTPUT $aCoord1 count " & $aCoord1[0], $COLOR_DEBUG)
			For $p = 1 To $aCoord1[0]
				$sText &= "[" & $p & "}:" & $aCoord1[$p] & "; "
			Next
			SetLog($sText, $COLOR_DEBUG)
			$sText = "OUTPUT $aCoord2"
			SetLog("OUTPUT $aCoord2 count " & $aCoord2[0], $COLOR_DEBUG)
			For $p = 1 To $aCoord2[0]
				$sText &= "[" & $p & "}:" & $aCoord2[$p] & "; "
			Next
			SetLog($sText, $COLOR_DEBUG)
		EndIf
#comments-end
		For $np = 1 To $aCoord2[0]
			If $aCoord2[$np] <> "" Then
				$aLoc2 = StringSplit($aCoord2[$np], ",") ; separate x & y
				If $aLoc2[0] = 2 Then
					$sLoc1Coord &= "|" & $aLoc2[1] & "," & $aLoc2[2]
					$iPointsAdded += 1
				EndIf
				If ($aCoord1[0] + $iPointsAdded) >= $iReturnpoints Then ; Stop adding points if reached maximum allowed.
					If $aCoord2[0] > $np And $aCoord2[$np + 1] <> "" Then
						SetLog("AddPoints_RemoveDuplicate found more locatons then requested!", $COLOR_ERROR)
						SetLog("Location string truncated to max requested: " & $iReturnpoints, $COLOR_ERROR)
						ExitLoop
					EndIf
				EndIf
			EndIf
		Next
		SetDebugLog("Final $sLoc1Coord= "& $sLoc1Coord, $COLOR_DEBUG)
	Else
		SetLog("RemoveDuplicatePoints location string paramenter error!", $COLOR_ERROR)
	EndIf

	Return ($aCoord1[0] + $iPointsAdded)

EndFunc   ;==>AddPoints_RemoveDuplicate

; #FUNCTION# ====================================================================================================================
; Name ..........: IsNearCircle
; Description ...: Checks if any $aBuildingNearPoints[R][[x,y]] locations are within a circle around target location,
;                : circle is defined by radius $iDistance representing integer number of pixels, using converse formula of Pythagorean theorem (a^2+b^2=c^2)
;                : Can be used for checking locations inside circle [IsInsideCircle{} when $sSide - "IN"], or locations outside circle with $eSide parameter [IsOutsideCircle() when $sSide = "OUT"]
;                :
; Syntax ........: IsNearCircle($aTargetLoc, $aBuildingNearPoints[, $iDistance = 25[, $sSide = "IN"]])
; Parameters ....: $aTargetLoc          - an array x,y pixel location
;                  $aBuildingNearPoints - an array with arrays x,y in each row as returned by GetListPixel
;                  $iDistance           - [optional] an integer of size of circle allowed in pixels. Default is 25.
;                  $sSide               - [optional] a string value. Default is "IN".
; Return values .: FALSE if any location is on outside when $sSide - "IN"  or FALSE when any location is on inside when $sSide = "OUT", TRUE when all locations met conditions
; Author ........: MonkeyHunter (05-2017)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func IsNearCircle($aTargetLoc, $aBuildingNearPoints, $iDistance = 25, $sSide = "IN")

	If IsArray($aTargetLoc) Then ; check target input parameter
		Local $CheckX = $aTargetLoc[0]
		Local $CheckY = $aTargetLoc[1]
	Else
		SetLog("Target building is not location array", $COLOR_ERROR)
		Return SetError(1, 0, False)
	EndIf

	If IsArray($aBuildingNearPoints) = False Then ; verify location array
		SetLog("Building near points are not location array(s)", $COLOR_ERROR)
		Return SetError(2, 0, False)
	EndIf

	If $sSide <> "IN" Or $sSide <> "OUT" Then SetLog("Input parameter SIDE error IsNearCircle!", $COLOR_ERROR) ; Check $sSide parameter

	Local $aNearBldg
	For $loc = 0 To UBound($aBuildingNearPoints) - 1
		$aNearBldg = $aBuildingNearPoints[$loc]
		If IsArray($aNearBldg) Then
			If (($aNearBldg[0] - $CheckX) ^ 2 + ($aNearBldg[0] - $CheckY) ^ 2 <= $iDistance ^ 2) Then ; it is inside circle!
				If $sSide == "OUT" Then Return False
			Else ; it is outside circle!!
				If $sSide = "IN" Then Return False
			EndIf
		EndIf
	Next

	Return True ; inside/outside condition met for all locations

EndFunc   ;==>IsNearCircle

