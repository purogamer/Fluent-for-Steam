; #FUNCTION# ====================================================================================================================
; Name ..........: MakeDropPoints
; Description ...:
; Syntax ........: MakeDropPoints($side, $pointsQty, $addtiles, $versus[, $randomx = 2[, $randomy = 2]])
; Parameters ....: $side                -
;                  $pointsQty           -
;                  $addtiles            -
;                  $versus              -
;                  $randomx             - [optional] an unknown value. Default is 2.
;                  $randomy             - [optional] an unknown value. Default is 2.
; Return values .: None
; Author ........: Sardo (2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func MakeDropPoints($side, $pointsQty, $addtiles, $versus, $randomx = 2, $randomy = 2)
	Local $asidenames = ["TOP-LEFT-DOWN", "TOP-LEFT-UP", "TOP-RIGHT-DOWN", "TOP-RIGHT-UP", "BOTTOM-LEFT-DOWN", "BOTTOM-LEFT-UP", "BOTTOM-RIGHT-DOWN", "BOTTOM-RIGHT-UP"]
	debugattackcsv("make for side " & $side)
	Local $droppoints, $Output = ""
	If StringInStr($randomx, "_S") Then
		Local $rndx = StringRegExpReplace($randomx, "[^-0-9]", "")
	Else
		Local $rndx = Random(0, Abs(Int($randomx)), 1)
		If Int($randomx) < 0 Then $rndx = -$rndx
	EndIf
	
	If StringInStr($randomy, "_S") Then
		Local $rndy = StringRegExpReplace($randomy, "[^-0-9]", "")
	Else
		Local $rndy = Random(0, Abs(Int($randomy)), 1)
		If Int($randomy) < 0 Then $rndy = -$rndy
	EndIf
	
	If $side = "RANDOM" Then
		$side = $asidenames[Random(0, UBound($asidenames) - 1, 1)]
	EndIf
	
	Switch $side
		Case "TOP-LEFT-DOWN"
			$droppoints = $g_aipixeltopleftdowndropline
		Case "TOP-LEFT-UP"
			$droppoints = $g_aipixeltopleftupdropline
		Case "TOP-RIGHT-DOWN"
			$droppoints = $g_aipixeltoprightdowndropline
		Case "TOP-RIGHT-UP"
			$droppoints = $g_aipixeltoprightupdropline
		Case "BOTTOM-LEFT-UP"
			$droppoints = $g_aipixelbottomleftupdropline
		Case "BOTTOM-LEFT-DOWN"
			$droppoints = $g_aipixelbottomleftdowndropline
		Case "BOTTOM-RIGHT-UP"
			$droppoints = $g_aipixelbottomrightupdropline
		Case "BOTTOM-RIGHT-DOWN"
			$droppoints = $g_aipixelbottomrightdowndropline
		Case Else
	EndSwitch
	
	If UBound($droppoints) <= 0 Then Return ""
	
	If $versus = "IGNORE" Then $versus = "EXT-INT" ; error proof use input if misuse targeted MAKE command
	If Int($pointsQty) > 1 Then
		$pointsQty = Abs(Int($pointsQty)) - 1
	Else
		$pointsQty = 2
	EndIf
	
	Local $x = 0
	Local $y = 0
	Switch $side
		Case "TOP-LEFT-DOWN", "TOP-LEFT-UP", "TOP-RIGHT-DOWN", "TOP-RIGHT-UP", "BOTTOM-LEFT-DOWN", "BOTTOM-LEFT-UP", "BOTTOM-RIGHT-DOWN", "BOTTOM-RIGHT-UP"
			;From right to left
			For $i = 0 To $pointsQty
				Local $percent = $i / $pointsQty
				Local $idx = Round($percent * (UBound($droppoints) - 1))
				Local $pixel = $droppoints[$idx]
				$x += $pixel[0]
				$y += $pixel[1]
				For $u = 8 * Abs(Int($addtiles)) To 0 Step -1
					If Int($addtiles) > 0 Then
						Local $l = $u
					Else
						Local $l = -$u
					EndIf
					Switch $side
						Case "TOP-LEFT-UP", "TOP-LEFT-DOWN"
							Local $x2 = $x - $l - $rndx - $addtiles
							Local $y2 = $y - $l - $rndy + $addtiles
						Case "TOP-RIGHT-UP", "TOP-RIGHT-DOWN"
							Local $x2 = $x + $l + $rndx + $addtiles
							Local $y2 = $y - $l - $rndy + $addtiles
						Case "BOTTOM-LEFT-UP", "BOTTOM-LEFT-DOWN"
							Local $x2 = $x - $l - $rndx - $addtiles
							Local $y2 = $y + $l + $rndy - $addtiles
						Case "BOTTOM-RIGHT-UP", "BOTTOM-RIGHT-DOWN"
							Local $x2 = $x + $l + $rndx + $addtiles
							Local $y2 = $y + $l + $rndy - $addtiles
						Case Else
					EndSwitch
					$pixel = StringSplit($x2 & "-" & $y2, "-", 2)
					If isinsidediamondredarea($pixel) Then ExitLoop
					If $addtiles < 0 And $y2 > $g_aiDeployableLRTB[3] Then ExitLoop
				Next
				$pixel = StringSplit($x2 & "-" & $y2, "-", 2)
				$Output &= $pixel[0] & "-" & $pixel[1] & "|"
				$x = 0
				$y = 0
			Next
		Case Else
	EndSwitch
	If StringLen($Output) > 0 Then $Output = StringLeft($Output, StringLen($Output) - 1)
	Local $outputdroppoints = getlistpixel($Output)
	Switch $side & "|" & $versus
		Case "TOP-LEFT-DOWN|INT-EXT", "TOP-LEFT-UP|EXT-INT", "TOP-RIGHT-DOWN|EXT-INT", "TOP-RIGHT-UP|INT-EXT", "BOTTOM-LEFT-DOWN|EXT-INT", "BOTTOM-LEFT-UP|INT-EXT", "BOTTOM-RIGHT-DOWN|INT-EXT", "BOTTOM-RIGHT-UP|EXT-INT"
			_ArrayReverse($outputdroppoints)
	EndSwitch
	Return $outputdroppoints
EndFunc   ;==>MakeDropPoints

; #FUNCTION# ====================================================================================================================
; Name ..........: MakeTargetDropPoints
; Description ...:
; Syntax ........: MakeTargetDropPoints($side, $pointsQty, $addtiles, $building)
; Parameters ....: $side                - a string, target side string ($sidex)
;                  $pointsQty           - a integer Drop point count can be 1 or 5 value only ($value3)
;                  $addtiles            - a integer, Ignore if $pointsqty = 5, only used when dropping in sigle point ($value4)
;                  $building            - a enum value, building target for drop points ($value8)
; Return values .: PointQty =1: single x,y array
;					  : 			 =5: Array with 5 x,y points
; @error values  : 1 = Bad defense name
;					  : 2 = dictionary value for defense missing
;					  : 3 = dictionary value of defense was not array
; 					  : 4 = strange programming error?
; Author ........: MonkeyHunter (05-2017)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func MakeTargetDropPoints($side, $pointsQty, $addtiles, $building, $hownamybuildings = 1)
	debugattackcsv("MakeTargetDropPoints(" & $side & "," & $pointsQty & "," & $addtiles & "," & $building & "," & $hownamybuildings & ")")
	
	Local $Output = ""
	Local $x, $y
	Local $sLoc, $aLocation, $pixel[2], $BuildingEnum, $result, $array
	$BuildingEnum = getemunbuildings($building)
	If @error Then Return @error
	
	Local $aBuildingLoc = _objgetvalue($g_obldgattackinfo, $BuildingEnum & "_LOCATION")
	If @error Then
		_objerrmsg("_ObjGetValue " & $g_sbldgnames[$BuildingEnum] & " _LOCATION", @error)
		debugattackcsv("_ObjGetValue " & $g_sbldgnames[$BuildingEnum] & " _LOCATION, Dictonary error " & @error)
		Return SetError(2, 0, "")
	EndIf
	
	Local $aDistances[0][2]
	debugattackcsv("$aBuildingLoc _LOCATION array: " & _ArrayToString($aBuildingLoc, ",", -1, -1, "|"))
	If IsArray($aBuildingLoc) And UBound($aBuildingLoc, $ubound_rows) > 0 Then
		If UBound($aBuildingLoc, 1) > 1 And IsArray($aBuildingLoc[1]) Then ; cycle thru all building locations
			;For Inferno Get Closet To Townhall First Regarding of what there side was assigned.
			If $building = "INFERNO" Then
				;e.g
				;MAKE  |W          |LEFT-FRONT |1          |0          |IGNORE     |0          |0          |INFERNO    |           |
				;MAKE  |X          |RIGHT-FRONT|1          |0          |IGNORE     |0          |0          |INFERNO    |           |
				;MAKE  |Z          |RIGHT-FRONT|1          |0          |IGNORE     |0          |0          |INFERNO    |           |
				;W will have most closet inferno Locaion then X Will have 2nd closest Location then Z will have Most Far Away Inferno Location
				Local $iMinDistance = 0
				Local $aTownhallLoc = [$g_ithx, $g_ithy]
				For $p = 0 To UBound($aBuildingLoc) - 1
					Local $aTempLocation = $aBuildingLoc[$p]     ; pull sub-array from inside location array
					;Chcek If Building Location Not Assigned Already
					If Not CheckIfBuildingAssigenedToVector($aTempLocation, $aBuildingLoc) Then
						Local $d = getpixeldistance($aTownhallLoc, $aTempLocation)
						ReDim $aDistances[UBound($aDistances) + 1][2]
						$aDistances[UBound($aDistances) - 1][0] = Int($d)
						$aDistances[UBound($aDistances) - 1][1] = $aTempLocation
						debugattackcsv("GetPixelDistance: " & $d & " | From Townhall | " & _ArrayToString($aTownhallLoc, ",") & " | Points: " & _ArrayToString($aTempLocation, ","))
						If ($d < $iMinDistance Or $iMinDistance = 0) Then
							$iMinDistance = $d
							$aLocation = $aTempLocation
						EndIf
					Else
						debugattackcsv("Building " & $building & " points are in ATTACKVECTOR_" & PointsAssigenedToVector($aTempLocation, $aBuildingLoc))
					EndIf
				Next
				debugattackcsv("INFERNOS | $aDistances: " & UBound($aDistances) & " $hownamybuildings: " & $hownamybuildings)
				debugattackcsv("BEFORE: " & _ArrayToString($aDistances, ",", -1, -1, "|"))
				_ArraySort($aDistances, 0, 0, 0, 0)
				If UBound($aDistances) >= $hownamybuildings Then
					debugattackcsv("AFTER: " & _ArrayToString($aDistances, ",", -1, -1, "|"))
					$aLocation = $aDistances[$hownamybuildings - 1][1]
				Else
					If IsArray($aDistances) And UBound($aDistances) > 0 Then $aLocation = $aDistances[0][1]
				EndIf
			Else
				For $p = 0 To UBound($aBuildingLoc) - 1
					$array = $aBuildingLoc[$p] ; pull sub-array from inside location array
					$result = IsPointOnSide($array, $side) ; Determine if target building on side specified
					If @error Then
						Return SetError(4, 0, "")
					EndIf
					debugattackcsv("Building location IsPointOnSide: " & $side & " | " & $result & " | Points: " & _ArrayToString($array, ","))
					If $result = True Then
						Local $aTempLocation = $aBuildingLoc[$p] ; pull sub-array from inside location array
						;Chcek If Building Location Not Assigned Already
						If Not CheckIfBuildingAssigenedToVector($aTempLocation, $aBuildingLoc) Then
							$aLocation = $aTempLocation
							ExitLoop
						Else
							debugattackcsv("Building " & $building & " points are in ATTACKVECTOR_" & PointsAssigenedToVector($aTempLocation, $aBuildingLoc))
						EndIf
					EndIf
				Next
				If Not $result And $aLocation = "" Then
					; error check?
					SetLog("Building location not found on request side, pick unique one", $COLOR_ERROR)
					For $p = 0 To UBound($aBuildingLoc) - 1
						Local $aTempLocation = $aBuildingLoc[$p] ; pull sub-array from inside location array
						;Chcek If Building Location Not Assigned Already
						If Not CheckIfBuildingAssigenedToVector($aTempLocation, $aBuildingLoc) Then
							$aLocation = $aTempLocation
							ExitLoop
						Else
							debugattackcsv("Building " & $building & " points are in ATTACKVECTOR_" & PointsAssigenedToVector($aTempLocation, $aBuildingLoc))
						EndIf
					Next
				EndIf
			EndIf
		Else     ; use only building found even if not on user chosen side?
			If IsArray($aBuildingLoc) And UBound($aBuildingLoc) > 0 And IsArray($aBuildingLoc[0]) And $aBuildingLoc[0] <> "" Then
				Local $aTempLocation = $aBuildingLoc[0] ; pull sub-array from inside location array
				;Chcek If Building Location Not Assigned Already
				If Not CheckIfBuildingAssigenedToVector($aTempLocation, $aBuildingLoc) Then
					$aLocation = $aTempLocation
				Else
					debugattackcsv("Building " & $building & " points are in ATTACKVECTOR_" & PointsAssigenedToVector($aTempLocation, $aBuildingLoc))
				EndIf
			Else
				SetLog($g_sbldgnames[$BuildingEnum] & " _LOCATION not an array", $COLOR_ERROR)
				Return SetError(3, 0, "")
			EndIf
		EndIf
	Else
		SetLog($g_sbldgnames[$BuildingEnum] & " _LOCATION not an array", $COLOR_ERROR)
		Return SetError(3, 0, "")
	EndIf
	If ($aLocation = "") Then
		SetLog($g_sbldgnames[$BuildingEnum] & " No Unique Location Found", $COLOR_ERROR)
		Return SetError(3, 0, "")
	EndIf
	
	;Just make sure Drop points is not nagative
	Local $pointsQtyCleaned = 1
	If Int($pointsQty) > 0 Then
		$pointsQtyCleaned = Abs(Int($pointsQty))
	EndIf
	;Building Vector Can Only Be An Odd Number
	If Mod(Int($pointsQtyCleaned), 2) <> 0 Then ; _MathCheckDiv deprecated - Team AIO Mod++
		;First Check Add Tiles To Buildings Location
		$x += $aLocation[0]
		$y += $aLocation[1]
		; use ADDTILES * 8 pixels per tile to add offset to vector location
		For $u = 8 * Abs(Int($addtiles)) To 0 Step -1         ; count down to zero pixels till find valid drop point
			If Int($addtiles) > 0 Then         ; adjust for positive or negative ADDTILES value
				Local $l = $u
			Else
				Local $l = -$u
			EndIf
			Switch $side
				Case "TOP-LEFT-UP", "TOP-LEFT-DOWN"
					$pixel[0] = $x - $l - $addtiles
					$pixel[1] = $y - $l + $addtiles
				Case "TOP-RIGHT-UP", "TOP-RIGHT-DOWN"
					$pixel[0] = $x + $l + $addtiles
					$pixel[1] = $y - $l + $addtiles
				Case "BOTTOM-LEFT-UP", "BOTTOM-LEFT-DOWN"
					$pixel[0] = $x - $l - $addtiles
					$pixel[1] = $y + $l - $addtiles
				Case "BOTTOM-RIGHT-UP", "BOTTOM-RIGHT-DOWN"
					$pixel[0] = $x + $l + $addtiles
					$pixel[1] = $y + $l - $addtiles
				Case Else
					SetLog("Silly code monkey 'MAKE' TargetDropPoints mistake", $COLOR_ERROR)
					Return SetError(5, 0, "")
			EndSwitch
			If isinsidediamondredarea($pixel) Then ExitLoop
		Next
		If isinsidediamondredarea($pixel) = False Then SetDebugLog("MakeTargetDropPoints() ADDTILES error!")
		;if Just One Drop Point Defined
		If $pointsQtyCleaned = 1 Then
			$sLoc = $pixel[0] & "-" & $pixel[1]     ; make string for modified building location
			SetLog("Target drop points for " & $g_sbldgnames[$BuildingEnum] & " (adding " & $addtiles & " tiles): " & $sLoc)
			debugattackcsv("Target drop points for " & $g_sbldgnames[$BuildingEnum] & " (adding " & $addtiles & " tiles): " & $sLoc)
			Return getlistpixel($sLoc, "-", "MakeTargetDropPoints TARGET")     ; return ADDTILES modified location array
		Else
			;Second Check On Drop Points Add Left And Right Tiles To The Drop Points
			;Modify Building Location After Adding Tile, Now X,Y Has After Add Tiles Pixel
			$aLocation[0] = $pixel[0]
			$aLocation[1] = $pixel[1]
			$x = 0
			$y = 0
			;Logic Start For making tiles e.g $pointsQtyCleaned=5 -> $iBuildingTiles=[2, 1, 0, -1, -2]
			Local $iDivisible = Int($pointsQtyCleaned / 2)
			Local $iBuildingTiles[0]
			For $i = $iDivisible To -$iDivisible Step -1
				ReDim $iBuildingTiles[UBound($iBuildingTiles) + 1]
				$iBuildingTiles[UBound($iBuildingTiles) - 1] = $i
			Next
			;Logic Ends
			;Reverse The Order Of Tiles So [2, 1, 0, -1, -2] To [-2, -1, 0, 1, 2] To Make Equalent Left,Right Points.
			Switch $side
				Case "TOP-RIGHT-UP", "TOP-RIGHT-DOWN", "BOTTOM-LEFT-UP", "BOTTOM-LEFT-DOWN"
					_ArrayReverse($iBuildingTiles)
			EndSwitch
			SetDebugLog($side & " | iBuildingTiles: " & _ArrayToString($iBuildingTiles))
			debugattackcsv($side & " | iBuildingTiles: " & _ArrayToString($iBuildingTiles))
			For $i = 0 To UBound($iBuildingTiles) - 1
				$x += $aLocation[0]
				$y += $aLocation[1]
				; use ADDTILES * 8 pixels per tile to add offset to vector location
				For $u = 8 * Abs(Int($iBuildingTiles[$i])) To 0 Step -1 ; count down to zero pixels till find valid drop point
					If Int($iBuildingTiles[$i]) > 0 Then ; adjust for positive or negative ADDTILES value
						Local $l = $u
					Else
						Local $l = -$u
					EndIf
					Switch $side
						Case "TOP-LEFT-UP", "TOP-LEFT-DOWN"
							$pixel[0] = $x + $l + $iBuildingTiles[$i]
							$pixel[1] = $y - $l + $iBuildingTiles[$i]
						Case "TOP-RIGHT-UP", "TOP-RIGHT-DOWN"
							$pixel[0] = $x + $l + $iBuildingTiles[$i]
							$pixel[1] = $y + $l - $iBuildingTiles[$i]
						Case "BOTTOM-LEFT-UP", "BOTTOM-LEFT-DOWN"
							$pixel[0] = $x + $l + $iBuildingTiles[$i]
							$pixel[1] = $y + $l - $iBuildingTiles[$i]
						Case "BOTTOM-RIGHT-UP", "BOTTOM-RIGHT-DOWN"
							$pixel[0] = $x + $l + $iBuildingTiles[$i]
							$pixel[1] = $y - $l + $iBuildingTiles[$i]
						Case Else
							SetLog("Silly code monkey 'MAKE' TargetDropPoints mistake", $COLOR_ERROR)
							Return SetError(5, 0, "")
					EndSwitch
					If isinsidediamondredarea($pixel) Then ExitLoop
					ExitLoop
				Next
				$Output &= $pixel[0] & "-" & $pixel[1] & "|"
				$x = 0
				$y = 0
			Next
			If StringLen($Output) > 0 Then $Output = StringLeft($Output, StringLen($Output) - 1)
			SetLog("Target drop points for " & $g_sbldgnames[$BuildingEnum] & " (adding " & $addtiles & " tiles): " & $Output)
			debugattackcsv("Target drop points for " & $g_sbldgnames[$BuildingEnum] & " (adding " & $addtiles & " tiles): " & $Output)
			Return getlistpixel($Output)
		EndIf
	Else
		SetLog("MakeTargetDropPoint Error Building Drop Point Can't be Even Number", $COLOR_ERROR)
		Return SetError(6, 0, "")
	EndIf
EndFunc   ;==>MakeTargetDropPoints

; Interate Over All Vectors And See If Building Location Is Already Assiged To Any Other Vector
Func CheckIfBuildingAssigenedToVector($aTempLocation, $aBuildingLoc)
	Local $isFound = False
	For $v = 0 To 25
		Local $sAlphabat = Chr(65 + $v)                 ; start with character "A" = ASCII 65
		For $i = 0 To UBound(Execute("$ATTACKVECTOR_" & $sAlphabat)) - 1
			Local $pixel = Execute("$ATTACKVECTOR_" & $sAlphabat & "[" & $i & "]")
			If ($aTempLocation[0] = $pixel[0] And $aTempLocation[1] = $pixel[1]) Then
				$isFound = True
				ExitLoop 2
			EndIf
		Next
	Next
	Return $isFound
EndFunc   ;==>CheckIfBuildingAssigenedToVector

Func PointsAssigenedToVector($aTempLocation, $aBuildingLoc)
	Local $isFound = "ERROR"
	For $v = 0 To 25
		Local $sAlphabat = Chr(65 + $v)                 ; start with character "A" = ASCII 65
		For $i = 0 To UBound(Execute("$ATTACKVECTOR_" & $sAlphabat)) - 1
			Local $pixel = Execute("$ATTACKVECTOR_" & $sAlphabat & "[" & $i & "]")
			If ($aTempLocation[0] = $pixel[0] And $aTempLocation[1] = $pixel[1]) Then
				Return $sAlphabat
			EndIf
		Next
	Next
	Return $isFound
EndFunc   ;==>PointsAssigenedToVector
