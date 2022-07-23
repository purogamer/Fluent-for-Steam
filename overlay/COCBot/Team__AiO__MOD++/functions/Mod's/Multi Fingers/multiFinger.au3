; #FUNCTION# ====================================================================================================================
; Name ..........: multiFinger
; Description ...: Contains functions for all the multi-finger deployment
; Syntax ........:
; Parameters ....:
; Return values .: None
; Author ........: LunaEclipse(January, 2016)
; Modified ......: Samkie (23 Feb 2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Global $g_aAttackTypeString[$mf8FPinWheelRight + 1] = ["Random", _
													"Four Finger Standard", _
													"Four Finger Spiral Left", _
													"Four Finger Spiral Right", _
													"Eight Finger Blossom", _
													"Eight Finger Implosion", _
													"Eight Finger Pin Wheel Spiral Left", _
													"Eight Finger Pin Wheel Spiral Right"]

Func multiFingerSetupVecors($multiStyle, ByRef $dropVectors, $listInfoDeploy)
	Switch $multiStyle
		Case $mfFFStandard
			fourFingerStandardVectors($dropVectors, $listInfoDeploy)
		Case $mfFFSpiralLeft
			fourFingerSpiralLeftVectors($dropVectors, $listInfoDeploy)
		Case $mfFFSpiralRight
			fourFingerSpiralRightVectors($dropVectors, $listInfoDeploy)
		Case $mf8FBlossom
			eightFingerBlossomVectors($dropVectors, $listInfoDeploy)
		Case $mf8FImplosion
			eightFingerImplosionVectors($dropVectors, $listInfoDeploy)
		Case $mf8FPinWheelLeft
			eightFingerPinWheelLeftVectors($dropVectors, $listInfoDeploy)
		Case $mf8FPinWheelRight
			eightFingerPinWheelRightVectors($dropVectors, $listInfoDeploy)
	EndSwitch
EndFunc

Func multiFingerDropOnEdge($multiStyle, $dropVectors, $waveNumber, $kind, $dropAmount, $position = 0)
	If $dropAmount = 0 Or isProblemAffect(True) Then Return
	If $position = 0 Or $dropAmount < $position Then $position = $dropAmount

	KeepClicks()
	 If _SleepAttack($DELAYDROPONEDGE1) Then Return
	SelectDropTroop($kind) ; Select Troop
	 If _SleepAttack($DELAYDROPONEDGE2) Then Return

	Switch $multiStyle
		Case $mfFFStandard, $mfFFSpiralLeft, $mfFFSpiralRight
			fourFingerDropOnEdge($dropVectors, $waveNumber, $kind, $dropAmount, $position)
		Case $mf8FBlossom, $mf8FImplosion, $mf8FPinWheelLeft, $mf8FPinWheelRight
			eightFingerDropOnEdge($dropVectors, $waveNumber, $kind, $dropAmount, $position)
	EndSwitch
	ReleaseClicks()
EndFunc   ;==>multiFingerDropOnEdge

Func launchMultiFinger($listInfoDeploy, $g_iClanCastleSlot, $g_iKingSlot, $g_iQueenSlot, $g_iWardenSlot, $g_iChampionSlot, $overrideSmartDeploy = -1)
	Local $kind, $nbSides, $waveNumber, $waveCount, $position, $remainingWaves, $dropAmount
	Local $RandomEdge, $RandomXY
	Local $dropVectors[0][0]
	Local $barPosition

	Local $multiStyle = ($g_iMultiFingerStyle = $mfRandom) ? Random($mfFFStandard, $mf8FPinWheelRight, 1) : $g_iMultiFingerStyle

	SetLog("Attacking " & $g_aAttackTypeString[$multiStyle] & " fight style.", $COLOR_BLUE)
	If $g_bDebugSetlog = 1 Then SetLog("Launch " & $g_aAttackTypeString[$multiStyle] & " with CC " & $g_iClanCastleSlot & ", K " & $g_iKingSlot & ", Q " & $g_iQueenSlot & ", W " & $g_iWardenSlot, $COLOR_PURPLE)

	Local $aDeployButtonPositions = getUnitLocationArray()
	Local $unitCount = unitCountArray()

	; Setup the attack vectors for the troops
	SetLog("Calculating attack vectors for all troop deployments, please be patient...", $COLOR_PURPLE)
	multiFingerSetupVecors($multiStyle, $dropVectors, $listInfoDeploy)

	For $i = 0 To UBound($listInfoDeploy) - 1
		$kind = $listInfoDeploy[$i][0]
		$nbSides = $listInfoDeploy[$i][1]
		$waveNumber = $listInfoDeploy[$i][2]
		$waveCount = $listInfoDeploy[$i][3]
		$position = $listInfoDeploy[$i][4]
		$remainingWaves = ($waveCount - $waveNumber) + 1
		$barPosition = $aDeployButtonPositions[$kind]

		If IsString($kind) And ($kind = "CC" Or $kind = "HEROES") Then
			$RandomEdge = $g_aaiEdgeDropPoints[Round(Random(0, 3, 1))]
			$RandomXY = Round(Random(0, 4, 1))

			If $kind = "CC" Then
				dropCC($RandomEdge[$RandomXY][0], $RandomEdge[$RandomXY][1], $g_iClanCastleSlot)
			ElseIf $kind = "HEROES" Then
				dropHeroes($RandomEdge[$RandomXY][0], $RandomEdge[$RandomXY][1], $g_iKingSlot, $g_iQueenSlot, $g_iWardenSlot, $g_iChampionSlot)
			EndIf
		ElseIf IsNumber($kind) And $barPosition <> -1 Then
			$dropAmount = calculateDropAmount($unitCount[$kind], $remainingWaves, $position)
			$unitCount[$kind] -= $dropAmount

			If $dropAmount > 0 Then

				multiFingerDropOnEdge($multiStyle, $dropVectors, $i, $barPosition, $dropAmount, $position)
				If _SleepAttack(SetSleep(1)) Then Return
			EndIf
		EndIf
	Next
	If _Sleep($DELAYALGORITHM_ALLTROOPS4) Then Return
	SetLog("Dropping left over troops", $COLOR_INFO)
	For $x = 0 To 1
		If PrepareAttack($g_iMatchMode, True) = 0 Then
			If $g_bDebugSetlog = 1 Then Setlog("No Wast time... exit, no troops usable left", $COLOR_DEBUG)
			ExitLoop ;Check remaining quantities
		EndIf
		For $i = $eBarb To $eTroopCount -1 ; Loop through all troop types
			LaunchTroop($i, $nbSides, 0, 1, 0)
			CheckHeroesHealth()
			If _Sleep($DELAYALGORITHM_ALLTROOPS5) Then Return
		Next
	Next
	CheckHeroesHealth()
	SetLog("Finished Attacking, waiting for the battle to end")
	Local $usingMultiFinger = False
	Return True
EndFunc   ;==>launchMultiFinger

Func dropRemainingTroops($nbSides, $overrideSmartDeploy = -1) ; Uses any left over troops
	SetLog("Dropping left over troops", $COLOR_BLUE)

	For $x = 0 To 1
		PrepareAttack($g_iMatchMode, True) ; Check remaining quantities
		For $i = $eBarb To $eTroopCount -1 ; Loop through all troop types
			LaunchTroops($i, $nbSides, 0, 1, 0, $overrideSmartDeploy)
			CheckHeroesHealth()
			If _SleepAttack($DELAYALGORITHM_ALLTROOPS5) Then Return
		Next
	Next
EndFunc   ;==>dropRemainingTroops

Func LaunchTroops($kind, $nbSides, $waveNb, $maxWaveNb, $slotsPerEdge = 0, $overrideSmartDeploy = -1, $overrideNumberTroops = -1)
	Local $troopNb
	Local $troop = unitLocation($kind)

	If $overrideNumberTroops = -1 Then
		$troopNb = Ceiling(unitCount($kind) / $maxWaveNb)
	Else
		$troopNb = $overrideNumberTroops
	EndIf

	If ($troop = -1) Or ($troopNb = 0) Then ; Troop not trained or 0 units to deploy
		Return False; nothing to do => skip this wave
	EndIf

	modDropTroop($troop, $nbSides, $troopNb, $slotsPerEdge, -1, $overrideSmartDeploy)

	Return True
EndFunc   ;==>LaunchTroops

Func modDropTroop($troop, $nbSides, $number, $slotsPerEdge = 0, $indexToAttack = -1, $overrideSmartDeploy = -1)
	If isProblemAffect(True) Then Return

	Local $nameFunc = "[modDropTroop]"
	debugRedArea($nameFunc & " IN ")
	debugRedArea("troop : [" & $troop & "] / nbSides : [" & $nbSides & "] / number : [" & $number & "] / slotsPerEdge [" & $slotsPerEdge & "]")

	If ($g_abAttackStdSmartAttack[$g_iMatchMode]) And $overrideSmartDeploy = -1 Then
		If $slotsPerEdge = 0 Or $number < $slotsPerEdge Then $slotsPerEdge = $number
		If _SleepAttack($DelayDropTroop1) Then Return
		If _SleepAttack($DelayDropTroop2) Then Return

		If $nbSides < 1 Then Return
		Local $nbTroopsLeft = $number
		If ($g_abAttackStdSmartNearCollectors[$g_iMatchMode][0] = 0 And $g_abAttackStdSmartNearCollectors[$g_iMatchMode][1] = 0 And $g_abAttackStdSmartNearCollectors[$g_iMatchMode][2] = 0) Then
			If $nbSides = 4 Then
				Local $g_aaiEdgeDropPointsPixelToDrop = GetPixelDropTroop($troop, $number, $slotsPerEdge)

				For $i = 0 To $nbSides - 3
					Local $nbTroopsPerEdge = Round($nbTroopsLeft / ($nbSides - $i * 2))
					If ($number > 0 And $nbTroopsPerEdge = 0) Then $nbTroopsPerEdge = 1
					Local $listEdgesPixelToDrop[2] = [$g_aaiEdgeDropPointsPixelToDrop[$i], $g_aaiEdgeDropPointsPixelToDrop[$i + 2]]
					DropOnPixel($troop, $listEdgesPixelToDrop, $nbTroopsPerEdge, $slotsPerEdge)
					$nbTroopsLeft -= $nbTroopsPerEdge * 2
				Next
				Return
			EndIf

			For $i = 0 To $nbSides - 1
				If $nbSides = 1 Or ($nbSides = 3 And $i = 2) Then
					Local $nbTroopsPerEdge = Round($nbTroopsLeft / ($nbSides - $i))
					If ($number > 0 And $nbTroopsPerEdge = 0) Then $nbTroopsPerEdge = 1
					Local $g_aaiEdgeDropPointsPixelToDrop = GetPixelDropTroop($troop, $nbTroopsPerEdge, $slotsPerEdge)
					Local $listEdgesPixelToDrop[1] = [$g_aaiEdgeDropPointsPixelToDrop[$i]]
					DropOnPixel($troop, $listEdgesPixelToDrop, $nbTroopsPerEdge, $slotsPerEdge)
					$nbTroopsLeft -= $nbTroopsPerEdge
				ElseIf ($nbSides = 2 And $i = 0) Or ($nbSides = 3 And $i <> 1) Then
					Local $nbTroopsPerEdge = Round($nbTroopsLeft / ($nbSides - $i * 2))
					If ($number > 0 And $nbTroopsPerEdge = 0) Then $nbTroopsPerEdge = 1
					Local $g_aaiEdgeDropPointsPixelToDrop = GetPixelDropTroop($troop, $nbTroopsPerEdge, $slotsPerEdge)
					Local $listEdgesPixelToDrop[2] = [$g_aaiEdgeDropPointsPixelToDrop[$i + 3], $g_aaiEdgeDropPointsPixelToDrop[$i + 1]]

					DropOnPixel($troop, $listEdgesPixelToDrop, $nbTroopsPerEdge, $slotsPerEdge)
					$nbTroopsLeft -= $nbTroopsPerEdge * 2
				EndIf
			Next
		Else
			Local $listEdgesPixelToDrop[0]
			If ($indexToAttack <> -1) Then
				Local $nbTroopsPerEdge = $number
				Local $maxElementNearCollector = $indexToAttack
				Local $startIndex = $indexToAttack
			Else
				Local $nbTroopsPerEdge = Round($number / UBound($g_aiPixelNearCollector))
				Local $maxElementNearCollector = UBound($g_aiPixelNearCollector) - 1
				Local $startIndex = 0
			EndIf
			If ($number > 0 And $nbTroopsPerEdge = 0) Then $nbTroopsPerEdge = 1
			For $i = $startIndex To $maxElementNearCollector
				Local $pixel = $g_aiPixelNearCollector[$i]
				ReDim $listEdgesPixelToDrop[UBound($listEdgesPixelToDrop) + 1]
				If ($troop = $eArch Or $troop = $eWiza Or $troop = $eMini or $troop = $eBarb) Then
					$listEdgesPixelToDrop[UBound($listEdgesPixelToDrop) - 1] = _FindPixelCloser($g_aiPixelRedAreaFurther, $pixel, 5)
				Else
					$listEdgesPixelToDrop[UBound($listEdgesPixelToDrop) - 1] = _FindPixelCloser($g_aiPixelRedArea, $pixel, 5)
				EndIf
			Next
			DropOnPixel($troop, $listEdgesPixelToDrop, $nbTroopsPerEdge, $slotsPerEdge)
		EndIf
	Else
		DropOnEdges($troop, $nbSides, $number, $slotsPerEdge)
	EndIf

	debugRedArea($nameFunc & " OUT ")
EndFunc   ;==>modDropTroop

; #FUNCTION# ====================================================================================================================
; Name ..........: unitInfo.au3
; Description ...: Gets various information about units such as the number, location on the bar, clan castle spell type etc...
; Syntax ........:
; Parameters ....:
; Return values .:
; Author ........: @LunaEclipse
; Modified ......: Samkie (17 FEB 2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func unitLocation($kind) ; Gets the location of the unit type on the bar.
	Local $aResult = -1
	Local $i = 0

	; This loops through the bar array but allows us to exit as soon as we find our match.
	While $i < UBound($g_avAttackTroops)
		; $g_avAttackTroops[$i][0] holds the unit ID for that position on the deployment bar.
		If $g_avAttackTroops[$i][0] = $kind Then
			$aResult = $i
			ExitLoop
		EndIf

		$i += 1
	WEnd

	; This returns -1 if not found on the bar, otherwise the bar position number.
	Return $aResult
EndFunc   ;==>unitLocation

Func getUnitLocationArray() ; Gets the location on the bar for every type of unit.
	Local $aResult[0]

	; Loop through all the bar and assign it position to the respective unit.
	For $i = 0 To UBound($g_avAttackTroops) - 1
		If Number($g_avAttackTroops[$i][0]) <> -1 Then
			If UBound($aResult) <= Number($g_avAttackTroops[$i][0]) Then 
				ReDim $aResult[Number($g_avAttackTroops[$i][0]) + 1]
			EndIf
			$aResult[Number($g_avAttackTroops[$i][0])] = $i
		EndIf
	Next

	For $i = 0 To UBound($aResult) -1
		If StringIsSpace($aResult[$i]) Then
			$aResult[$i] = -1
		EndIf
	Next

	; Return the positions as an array.
	Return $aResult
EndFunc   ;==>getUnitLocationArray

Func unitCount($kind) ; Gets a count of the number of units of the type specified.
	Local $numUnits = 0
	Local $barLocation = unitLocation($kind)
	; $barLocation is -1 if the unit/spell type is not found on the deployment bar.
	If $barLocation <> -1 Then
		$numUnits = $g_avAttackTroops[$barLocation][1]
	EndIf

	Return $numUnits
EndFunc   ;==>unitCount

Func unitCountArray() ; Gets a count of the number of units for every type of unit.
	Local $aResult[0]
	
	; Loop through all the bar and assign its unit count to the respective unit.
	For $i = 0 To UBound($g_avAttackTroops) - 1
		If Number($g_avAttackTroops[$i][1]) > 0 Then
			If UBound($aResult) <= Number($g_avAttackTroops[$i][0]) Then 
				ReDim $aResult[Number($g_avAttackTroops[$i][0]) + 1]
			EndIf
			$aResult[Number($g_avAttackTroops[$i][0])] = $g_avAttackTroops[$i][1]
		EndIf
	Next
	
	For $i = 0 To UBound($aResult) -1
		If StringIsSpace($aResult[$i]) Then
			$aResult[$i] = -1
		EndIf
	Next

	; Return the positions as an array.
	Return $aResult
EndFunc   ;==>unitCountArray

; Calculate how many troops to drop for the wave
Func calculateDropAmount($unitCount, $remainingWaves, $position = 0, $minTroopsPerPosition = 1)
	Local $return = Ceiling(($unitCount+1) / $remainingWaves)
	If $position <> 0 Then
		If $unitCount < ($position * $minTroopsPerPosition) Then
			$position = Floor($unitCount / $minTroopsPerPosition)
			$return = $position * $minTroopsPerPosition
		ElseIf $unitCount >= ($position * $minTroopsPerPosition) And $return < ($position * $minTroopsPerPosition) Then
			$return = $position * $minTroopsPerPosition
		EndIf
	EndIf

	Return $return
EndFunc  ;==>calculateDropAmount

; Convert X,Y coords to a point array
Func convertToPoint($x = 0, $y = 0)
	Local $aResult[2] = [0, 0]

	$aResult[0] = $x
	$aResult[1] = $y

	Return $aResult
EndFunc   ;==>convertToPoint


; Adds a new drop vector to the list of already existing vectors
Func addVector(ByRef $vectorArray, $waveNumber, $sideNumber, $startPoint, $endPoint, $dropPoints)
	Local $aDropPoints[$dropPoints][2]

	Local $m = ($endPoint[1] - $startPoint[1]) / ($endPoint[0] - $startPoint[0])
	Local $c = $startPoint[1] - ($m * $startPoint[0])
	Local $stepX = ($endPoint[0] - $startPoint[0]) / ($dropPoints - 1)

	$aDropPoints[0][0] = $startPoint[0]
	$aDropPoints[0][1] = $startPoint[1]

	For $i = 1 to $dropPoints - 2
		$aDropPoints[$i][0] = Round($startPoint[0] + ($i * $stepX))
		$aDropPoints[$i][1] = Round(($m * $aDropPoints[$i][0]) + $c)
	Next

	$aDropPoints[$dropPoints - 1][0] = $endPoint[0]
	$aDropPoints[$dropPoints - 1][1] = $endPoint[1]

	$vectorArray[$waveNumber][$sideNumber] = $aDropPoints
EndFunc   ;==>addVector

; Drop the troops in a standard drop along a vector
Func standardSideDrop($dropVectors, $waveNumber, $sideIndex, $currentSlot, $troopsPerSlot, $bUseDelay = True)
	Local $iDelay = ($bUseDelay = True) ? SetSleep(0) : (0)
	Local $dropPoints

	$dropPoints = $dropVectors[$waveNumber][$sideIndex]
	If $currentSlot < UBound($dropPoints) Then AttackClick($dropPoints[$currentSlot][0], $dropPoints[$currentSlot][1], $troopsPerSlot, $iDelay, 0)
EndFunc   ;==>standardSideDrop

; Drop the troops in a standard drop from two points along vectors at once
Func standardSideTwoFingerDrop($dropVectors, $waveNumber, $sideIndex, $currentSlot, $troopsPerSlot, $bUseDelay = True)
	standardSideDrop($dropVectors, $waveNumber, $sideIndex, $currentSlot, $troopsPerSlot)
	standardSideDrop($dropVectors, $waveNumber, $sideIndex + 1, $currentSlot + 1, $troopsPerSlot, $bUseDelay)
EndFunc   ;==>twoFingerStandardSideDrop

; Drop the troops from a single point on all sides at once
Func multiSingle($totalDrop, $bUseDelay = True)
	Local $dropAmount = Ceiling($totalDrop / 4)

	; Progressively adjust the drop amount
	sideSingle($g_aaiTopLeftDropPoints, $dropAmount)
	$totalDrop -= $dropAmount
	$dropAmount = Ceiling($totalDrop / 3)

	; Progressively adjust the drop amount
	sideSingle($g_aaiTopRightDropPoints, $dropAmount)
	$totalDrop -= $dropAmount
	$dropAmount = Ceiling($totalDrop / 2)

	; Progressively adjust the drop amount
	sideSingle($g_aaiBottomRightDropPoints, $dropAmount)
	$totalDrop -= $dropAmount

	; Drop whatever is left
	sideSingle($g_aaiBottomLeftDropPoints, $totalDrop, True)
EndFunc   ;==>multiSingle

; Drop the troops from two points on all sides at once
Func multiDouble($totalDrop, $bUseDelay = True)
	Local $dropAmount = Ceiling($totalDrop / 4)

	; Progressively adjust the drop amount
	sideDouble($g_aaiTopLeftDropPoints, $dropAmount)
	$totalDrop -= $dropAmount
	$dropAmount = Ceiling($totalDrop / 3)

	; Progressively adjust the drop amount
	sideDouble($g_aaiTopRightDropPoints, $dropAmount)
	$totalDrop -= $dropAmount
	$dropAmount = Ceiling($totalDrop / 2)

	; Progressively adjust the drop amount
	sideDouble($g_aaiBottomRightDropPoints, $dropAmount)
	$totalDrop -= $dropAmount

	; Drop whatever is left
	sideDouble($g_aaiBottomLeftDropPoints, $totalDrop, True)
EndFunc   ;==>multiDouble

; Drop the troops from a single point on a single side
Func sideSingle($dropSide, $dropAmount, $bUseDelay = True)
	Local $iDelay = ($bUseDelay = True) ? SetSleep(0) : (0)

	AttackClick($dropSide[2][0], $dropSide[2][1], $dropAmount, $iDelay, 0)
EndFunc   ;==>sideSingle

; Drop the troops from two points on a single side
Func sideDouble($dropSide, $dropAmount, $bUseDelay = True)
	Local $iDelay = ($bUseDelay = True) ? SetSleep(0) : (0)
	Local $half = Ceiling($dropAmount / 2)

	AttackClick($dropSide[1][0], $dropSide[1][1], $half, 0, 0)
	AttackClick($dropSide[3][0], $dropSide[3][1], $dropAmount - $half, $iDelay, 0)
EndFunc   ;==>sideDouble

; #FUNCTION# ====================================================================================================================
; Name ..........: fourFingerSpiralLeft
; Description ...: Contains functions for four finger spiral left deployment
; Syntax ........:
; Parameters ....:
; Return values .: None
; Author ........: LunaEclipse(January, 2016)
; Modified ......: Samkie (27 Nov 2016)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func fourFingerMulti($dropVectors, $waveNumber, $dropAmount, $slotsPerEdge = 0)
	Local $troopsLeft = $dropAmount
	Local $troopsPerSlot = 0

	If $slotsPerEdge = 0 Or $troopsLeft < $slotsPerEdge Then $slotsPerEdge = $troopsLeft

	For $i = 0 To $slotsPerEdge - 1
		$troopsPerSlot = Ceiling($troopsLeft / ($slotsPerEdge - $i)) ; progressively adapt the number of drops to fill at the best

		standardSideDrop($dropVectors, $waveNumber, 0, $i, $troopsPerSlot)
		standardSideDrop($dropVectors, $waveNumber, 1, $i, $troopsPerSlot)
		standardSideDrop($dropVectors, $waveNumber, 2, $i, $troopsPerSlot)
		standardSideDrop($dropVectors, $waveNumber, 3, $i, $troopsPerSlot, True)

		$troopsLeft -= ($troopsLeft < $troopsPerSlot) ? $troopsLeft : $troopsPerSlot
	Next
EndFunc   ;==>fourFingerMulti

Func fourFingerDropOnEdge($dropVectors, $waveNumber, $kind, $dropAmount, $position = 0)
	Local $troopsPerEdge = Ceiling($dropAmount / 4)

	If $dropAmount = 0 Or isProblemAffect(True) Then Return
		
	If _SleepAttack($DELAYDROPONEDGE1) Then Return
	SelectDropTroop($kind) ; Select Troop
	If _SleepAttack($DELAYDROPONEDGE2) Then Return

	Switch $position
		Case 1
			multiSingle($dropAmount)
		Case 2
			multiDouble($dropAmount)
		Case Else
			Switch $troopsPerEdge
				Case 1
					multiSingle($dropAmount)
				Case 2
					multiDouble($dropAmount)
				Case Else
					fourFingerMulti($dropVectors, $waveNumber, $troopsPerEdge, $position)
			EndSwitch
	EndSwitch
EndFunc   ;==>fourFingerDropOnEdge

; #FUNCTION# ====================================================================================================================
; Name ..........: eightFinger
; Description ...: Contains functions for eight finger deployments
; Syntax ........:
; Parameters ....:
; Return values .: None
; Author ........: LunaEclipse(January, 2016)
; Modified ......: Samkie (27 Nov 2016)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func eightFingerMulti($dropVectors, $waveNumber, $dropAmount, $slotsPerEdge = 0)
	Local $troopsLeft = Ceiling($dropAmount / 2)
	Local $troopsPerSlot = 0

	If $slotsPerEdge = 0 Or $troopsLeft < $slotsPerEdge Then $slotsPerEdge = $troopsLeft

	For $i = 0 To $slotsPerEdge - 1
		$troopsPerSlot = Ceiling($troopsLeft / ($slotsPerEdge - $i)) ; progressively adapt the number of drops to fill at the best

		standardSideTwoFingerDrop($dropVectors, $waveNumber, 0, $i, $troopsPerSlot)
		standardSideTwoFingerDrop($dropVectors, $waveNumber, 2, $i, $troopsPerSlot)
		standardSideTwoFingerDrop($dropVectors, $waveNumber, 4, $i, $troopsPerSlot)
		standardSideTwoFingerDrop($dropVectors, $waveNumber, 6, $i, $troopsPerSlot, True)

		$troopsLeft -= ($troopsLeft < $troopsPerSlot) ? $troopsLeft : $troopsPerSlot
	Next
EndFunc   ;==>eightFingerMulti

Func eightFingerDropOnEdge($dropVectors, $waveNumber, $kind, $dropAmount, $position = 0)
	Local $troopsPerEdge = Ceiling($dropAmount / 4)

	If $dropAmount = 0 Or isProblemAffect(True) Then Return

	If _SleepAttack($DELAYDROPONEDGE1) Then Return
	SelectDropTroop($kind) ; Select Troop
	If _SleepAttack($DELAYDROPONEDGE2) Then Return

	Switch $position
		Case 1
			multiSingle($dropAmount)
		Case 2
			multiDouble($dropAmount)
		Case Else
			Switch $troopsPerEdge
				Case 1
					multiSingle($dropAmount)
				Case 2
					multiDouble($dropAmount)
				Case Else
					eightFingerMulti($dropVectors, $waveNumber, $troopsPerEdge, $position)
			EndSwitch
	EndSwitch
EndFunc   ;==>eightFingerDropOnEdge