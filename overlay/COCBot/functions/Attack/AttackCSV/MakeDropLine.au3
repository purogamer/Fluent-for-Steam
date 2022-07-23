; #FUNCTION# ====================================================================================================================
; Name ..........: MakeDropLine
; Description ...:
; Syntax ........: MakeDropLine($searchvect, $startpoint, $endpoint)
; Parameters ....: $searchvect          - array
;                  $startpoint
;                  $endpoint
; Return values .: None
; Author ........: Sardo (2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func MakeDropLine($searchvect, $startpoint, $endpoint, $iLineDistanceThreshold = 75, $bLineToCorner = False)

	SetDebugLog("MakeDropLine for " & UBound($searchvect) & " points")
	If $bLineToCorner = False And UBound($searchvect) > 0 Then $startpoint = $searchvect[0]
	If $bLineToCorner = False And UBound($searchvect) > 0 Then $endpoint = $searchvect[UBound($searchvect) - 1]
	SetDebugLog("MakeDropLine: Start = " & PixelToString($startpoint) & ", End = " & PixelToString($endpoint) & ": " & PixelArrayToString($searchvect, ","))

	Local $startX = $startpoint[0]
	Local $startY = $startpoint[1]
	Local $endX = $endpoint[0]
	Local $endY = $endpoint[1]

	;CheckAttackLocation($startX, $startY)
	;CheckAttackLocation($endX, $endY)
	Local $size = UBound($searchvect)
	ReDim $searchvect[$size + 1]
	$searchvect[$size] = $endpoint
	Local $Pixel0 = [$startX, $startY]
	Local $ReturnVect = $startX & "," & $startY
	Local $iLineIdx = -1

	For $idx = 0 To $size
		Local $Pixel1 = $searchvect[$idx]

		If $Pixel1[0] < 0 Then ContinueLoop

		Local $aLen = [$Pixel1[0] - $Pixel0[0], $Pixel1[1] - $Pixel0[1]]
		Local $iStart
		Local $iEnd
		Local $iStep
		Local $iLoopAxis = ((Abs($aLen[0]) >= Abs($aLen[1])) ? (0) : (1))
		Local $iOtherAxis = 1 - $iLoopAxis
		Local $iDistance

		; loop axis direction
		$iStep = (($aLen[$iLoopAxis] > 0) ? (1) : (-1))
		$iStart = $Pixel0[$iLoopAxis]
		$iEnd = $Pixel1[$iLoopAxis]
		$iDistance = GetPixelDistance($Pixel0, $Pixel1)

		If $iLineDistanceThreshold = -1 Or $iDistance <= $iLineDistanceThreshold Or ($bLineToCorner = True And ($idx = 0 Or $idx = $size)) Then
			For $i = $iStart + $iStep To $iEnd Step $iStep
				Local $j = Line2Points($Pixel0, $Pixel1, $i, $iLoopAxis)
				Local $p[2]
				$p[$iLoopAxis] = $i
				$p[$iOtherAxis] = $j
				$ReturnVect &= "|" & $p[0] & "," & $p[1]
			Next
		Else
			$ReturnVect &= "|" & $Pixel1[0] & "," & $Pixel1[1]
		EndIf

		$Pixel0 = $Pixel1
	Next

	;$ReturnVect &= "|" & $endX & "," & $endY
	SetDebugLog("MakeDropLine: Done: " & $ReturnVect)

	Return GetListPixel($ReturnVect, ",")
EndFunc   ;==>MakeDropLine

Func MakeDropLineOriginal($searchvect, $startpoint, $endpoint)

	SetDebugLog("MakeDropLine for " & UBound($searchvect) & " points")

	Local $startX = $startpoint[0]
	Local $startY = $startpoint[1]
	Local $endX = $endpoint[0]
	Local $endY = $endpoint[1]

	CheckAttackLocation($startX, $startY)
	CheckAttackLocation($endX, $endY)

	Local $point1 = [$startX, $startY]
	Local $t, $f
	$t = 0
	$f = 0
	Local $ReturnVect = $startX & "," & $startY

	For $i = $startX + 1 To $endX
		For $j = $t To UBound($searchvect) - 1
			Local $pixel = $searchvect[$j]
			If $i < $pixel[0] Then
				Local $h = Line2Points($point1, $pixel, $i)
				CheckAttackLocation($i, $h)
				$ReturnVect &= "|" & $i & "," & $h
				$f = $i
				ExitLoop
			Else
				If $i = $pixel[0] Then
					Local $x = $pixel[0]
					Local $h = $pixel[1]
					CheckAttackLocation($x, $h)
					$ReturnVect &= "|" & $x & "," & $h
					$point1 = $pixel
					$t = $j + 1
					$f = $i
					ExitLoop
				EndIf
			EndIf
		Next
	Next
	For $i = $f + 1 To $endX
		Local $h = Line2Points($point1, $endpoint, $i)
		CheckAttackLocation($i, $h)
		$ReturnVect &= "|" & $i & "," & $h
	Next

	Return GetListPixel($ReturnVect, ",")
EndFunc   ;==>MakeDropLineOriginal
