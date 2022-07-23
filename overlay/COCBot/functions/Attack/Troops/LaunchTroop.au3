
; #FUNCTION# ====================================================================================================================
; Name ..........: LaunchTroop
; Description ...:
; Syntax ........: LaunchTroop($troopKind, $nbSides, $waveNb, $maxWaveNb[, $slotsPerEdge = 0])
; Parameters ....: $troopKind           - a dll struct value.
;                  $nbSides             - a general number value.
;                  $waveNb              - an unknown value.
;                  $maxWaveNb           - a map.
;                  $slotsPerEdge        - [optional] a string value. Default is 0.
; Return values .: None
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func LaunchTroop($troopKind, $nbSides, $waveNb, $maxWaveNb, $slotsPerEdge = 0)
	Local $troop = -1
	Local $troopNb = 0
	Local $name = ""
	For $i = 0 To UBound($g_avAttackTroops) - 1 ; identify the position of this kind of troop
		If $g_avAttackTroops[$i][0] = $troopKind Then
			If $g_avAttackTroops[$i][1] < 1 Then Return False
			$troop = $i
			$troopNb = Ceiling($g_avAttackTroops[$i][1] / $maxWaveNb)
			$name = GetTroopName($troopKind, $troopNb)
		EndIf
	Next

	SetDebugLog("Dropping : " & $troopNb & " " & $name, $COLOR_DEBUG)

	If $troop = -1 Or $troopNb = 0 Then
		Return False ; nothing to do => skip this wave
	EndIf

	Local $waveName = "first"
	If $waveNb = 2 Then $waveName = "second"
	If $waveNb = 3 Then $waveName = "third"
	If $maxWaveNb = 1 Then $waveName = "only"
	If $waveNb = 0 Then $waveName = "last"
	SetLog("Dropping " & $waveName & " wave of " & $troopNb & " " & $name, $COLOR_SUCCESS)
	DropTroop($troop, $nbSides, $troopNb, $slotsPerEdge)

	Return True
EndFunc   ;==>LaunchTroop

Func LaunchTroop2($listInfoDeploy, $iCC, $iKing, $iQueen, $iWarden, $iChampion)
	SetDebugLog("LaunchTroop2 with CC " & $iCC & ", K " & $iKing & ", Q " & $iQueen & ", W " & $iWarden & ", C " & $iChampion, $COLOR_DEBUG)
	Local $listListInfoDeployTroopPixel[0]
	Local $pixelRandomDrop[2]
	Local $pixelRandomDropcc[2]

	If ($g_abAttackStdSmartAttack[$g_iMatchMode]) Then
		For $i = 0 To UBound($listInfoDeploy) - 1
			Local $iFoundTroopAt = -1, $iTroopAmount = 0, $sTroopName
			Local $vTroopIndex = $listInfoDeploy[$i][0]
			Local $iNumberSides = $listInfoDeploy[$i][1]
			Local $iNumberWaves = $listInfoDeploy[$i][2]
			Local $iMaxNumberWaves = $listInfoDeploy[$i][3]
			Local $iSlotsPerEdge = $listInfoDeploy[$i][4]
			SetDebugLog("**ListInfoDeploy row " & $i & ": Use: " & $vTroopIndex & "|Sides: " & $iNumberSides & "|Wave: " & $iNumberWaves & "|Max Wavess: " & $iMaxNumberWaves & "|Slots per Edge " & $iSlotsPerEdge, $COLOR_DEBUG)
			If IsNumber($vTroopIndex) Then
				$iFoundTroopAt = _ArraySearch($g_avAttackTroops, $vTroopIndex, 0, 0, 0, 0, 1, 0)
				If $iFoundTroopAt <> -1 Then
					$iTroopAmount = Ceiling($g_avAttackTroops[$iFoundTroopAt][1] / $iMaxNumberWaves)
					$sTroopName = GetTroopName($vTroopIndex, $iTroopAmount)
				EndIf
			EndIf
			If ($iFoundTroopAt <> -1 And $iTroopAmount > 0) Or IsString($vTroopIndex) Then
				Local $listInfoDeployTroopPixel
				If (UBound($listListInfoDeployTroopPixel) < $iNumberWaves) Then
					ReDim $listListInfoDeployTroopPixel[$iNumberWaves]
					Local $newListInfoDeployTroopPixel[0]
					$listListInfoDeployTroopPixel[$iNumberWaves - 1] = $newListInfoDeployTroopPixel
				EndIf
				$listInfoDeployTroopPixel = $listListInfoDeployTroopPixel[$iNumberWaves - 1]

				ReDim $listInfoDeployTroopPixel[UBound($listInfoDeployTroopPixel) + 1]
				If (IsString($vTroopIndex)) Then
					Local $arrCCorHeroes[1] = [$vTroopIndex]
					$listInfoDeployTroopPixel[UBound($listInfoDeployTroopPixel) - 1] = $arrCCorHeroes
				Else
					Local $infoDropTroop = DropTroop2($iFoundTroopAt, $iNumberSides, $iTroopAmount, $iSlotsPerEdge, $sTroopName)
					$listInfoDeployTroopPixel[UBound($listInfoDeployTroopPixel) - 1] = $infoDropTroop
				EndIf
				$listListInfoDeployTroopPixel[$iNumberWaves - 1] = $listInfoDeployTroopPixel
			EndIf
		Next

		If (($g_abAttackStdSmartNearCollectors[$g_iMatchMode][0] Or $g_abAttackStdSmartNearCollectors[$g_iMatchMode][1] Or _
				$g_abAttackStdSmartNearCollectors[$g_iMatchMode][2]) And UBound($g_aiPixelNearCollector) = 0) Then
			SetLog("Error, no pixel found near collector => Normal attack near red line")
		EndIf
		If ($g_aiAttackStdSmartDeploy[$g_iMatchMode] = 0) Then
			For $numwave = 0 To UBound($listlistInfoDeploytrooppixel) - 1
				Local $listInfoDeploytrooppixel = $listlistInfoDeploytrooppixel[$numwave]
				For $i = 0 To UBound($listInfoDeploytrooppixel) - 1
					Local $infopixeldroptroop = $listInfoDeploytrooppixel[$i]
					If (IsString($infopixeldroptroop[0]) And ($infopixeldroptroop[0] = "CC" Or $infopixeldroptroop[0] = "HEROES")) Then
						Local $sPos = $i = 0 ? "First position" : $i
						If $i = UBound($listInfoDeploytrooppixel) - 1 Then $sPos = "Last position"
						Local $currentpixel[2] = [-1, -1]
						For $iL = 0 To UBound($listInfoDeploytrooppixel) - 1
							SetDebugLog("Heroes & CC at First : " & _ArrayToString($g_srAndomsidesnames))
							SetDebugLog("UBound : " & UBound($listInfoDeploytrooppixel) & " $index:" & $iL)
							Local $tempinfotrooplistarrpixel = $listInfoDeploytrooppixel[$iL]
							If Not IsString($tempinfotrooplistarrpixel[0]) Then
								Local $tempinfolistarrpixel = $tempinfotrooplistarrpixel[1]
								Local $listpixel = $tempinfolistarrpixel[0]
								Local $pixeldroptroop[1] = [$listpixel]
								Local $arrpixel = $pixeldroptroop[0]
								Local $iindex = Ceiling(UBound($arrpixel) / 2) <= UBound($arrpixel) - 1 ? Ceiling(UBound($arrpixel) / 2) : 0
								Local $currentpixel = $arrpixel[$iindex]
								Local $sBestSide = Side($currentpixel)
								SetDebugLog($iindex & " - Deploy Point check " & _ArrayToString($currentpixel) & " side: " & $sBestSide)
								SetDebugLog(UBound($arrpixel) & " deploy point(s) at " & $sBestSide, $COLOR_DEBUG)
								If $currentpixel[0] <> -1 Then ExitLoop
							EndIf
						Next
						$pixelRandomDrop[0] = $currentpixel[0] <> -1 ? $currentpixel[0] : $g_aideployheroesposition[0]
						$pixelRandomDrop[1] = $currentpixel[1] <> -1 ? $currentpixel[1] : $g_aideployheroesposition[1]
						If $pixelRandomDrop = -1 Then
							$pixelRandomDrop[0] = $g_aaiBottomLeftDropPoints[2][0]
							$pixelRandomDrop[1] = $g_aaiBottomLeftDropPoints[2][1]
						EndIf
						$pixelRandomDropCC[0] = $currentpixel[0] <> -1 ? $currentpixel[0] : $g_aideployccposition[0]
						$pixelRandomDropCC[1] = $currentpixel[1] <> -1 ? $currentpixel[1] : $g_aideployccposition[1]
						If $pixelRandomDropCC = -1 Then
							$pixelRandomDropCC[0] = $g_aaiBottomLeftDropPoints[2][0]
							$pixelRandomDropCC[1] = $g_aaiBottomLeftDropPoints[2][1]
						EndIf
						If ($infopixeldroptroop[0] = "CC") Then
							DropCC($pixelRandomDropCC[0], $pixelRandomDropCC[1], $iCC)
							$g_bisccdropped = True
						ElseIf ($infopixeldroptroop[0] = "HEROES") Then
							dropheroes($pixelRandomDrop[0], $pixelRandomDrop[1], $iKing, $iQueen, $iWarden, $iChampion)
							$g_bisheroesdropped = True
						EndIf
						If ($g_bisheroesdropped) Then
							If _Sleep($delaylaunchtroop22) Then Return
							checkheroeshealth()
						EndIf
					Else
						If _Sleep($delaylaunchtroop21) Then Return
						selectdroptroop($infopixeldroptroop[0])
						If _Sleep($delaylaunchtroop21) Then Return
						Local $wavename = "first"
						If $numwave + 1 = 2 Then $wavename = "second"
						If $numwave + 1 = 3 Then $wavename = "third"
						If $numwave + 1 = 0 Then $wavename = "last"
						SetLog("Dropping " & $wavename & " wave of " & $infopixeldroptroop[5] & " " & $infopixeldroptroop[4], $COLOR_SUCCESS)
						droponpixel($infopixeldroptroop[0], $infopixeldroptroop[1], $infopixeldroptroop[2], $infopixeldroptroop[3])
					EndIf
					If ($g_bisheroesdropped) Then
						If _Sleep($delaylaunchtroop22) Then Return
						checkheroeshealth()
					EndIf
					If _Sleep(SetSleep(1)) Then Return
				Next
			Next
		Else
			For $numWave = 0 To UBound($listListInfoDeployTroopPixel) - 1
				Local $listInfoDeployTroopPixel = $listListInfoDeployTroopPixel[$numWave]
				If (UBound($listInfoDeployTroopPixel) > 0) Then
					Local $infoTroopListArrPixel = $listInfoDeployTroopPixel[0]
					Local $numberSidesDropTroop = 1

					For $i = 0 To UBound($listInfoDeployTroopPixel) - 1
						$infoTroopListArrPixel = $listInfoDeployTroopPixel[$i]
						If (UBound($infoTroopListArrPixel) > 1) Then
							Local $infoListArrPixel = $infoTroopListArrPixel[1]
							$numberSidesDropTroop = UBound($infoListArrPixel)
							ExitLoop
						EndIf
					Next

					If ($numberSidesDropTroop > 0) Then
						For $i = 0 To $numberSidesDropTroop - 1
							For $j = 0 To UBound($listInfoDeploytrooppixel) - 1
								$infotrooplistarrpixel = $listInfoDeploytrooppixel[$j]
								If (IsString($infotrooplistarrpixel[0]) And ($infotrooplistarrpixel[0] = "CC" Or $infotrooplistarrpixel[0] = "HEROES")) Then
									Local $sPos = $j = 0 ? "First position" : $j
									If $j = UBound($listInfoDeploytrooppixel) - 1 Then $sPos = "Last position"
									SetDebugLog("Wave " & $numwave & " Side " & $i + 1 & "/" & $numberSidesDropTroop & " Dropping a CC & Heroes at " & $sPos)
									Local $currentpixel[2] = [-1, -1]
									For $iL = 0 To UBound($listInfoDeploytrooppixel) - 1
										SetDebugLog("Heroes & CC at First : " & _ArrayToString($g_srAndomsidesnames))
										SetDebugLog("UBound : " & UBound($listInfoDeploytrooppixel) & " $index:" & $iL)
										Local $tempinfotrooplistarrpixel = $listInfoDeploytrooppixel[$iL]
										If Not IsString($tempinfotrooplistarrpixel[0]) Then
											Local $tempinfolistarrpixel = $tempinfotrooplistarrpixel[1]
											Local $listpixel = $tempinfolistarrpixel[$i]
											Local $pixeldroptroop[1] = [$listpixel]
											Local $arrpixel = $pixeldroptroop[0]
											Local $iindex = Ceiling(UBound($arrpixel) / 2) <= UBound($arrpixel) - 1 ? Ceiling(UBound($arrpixel) / 2) : 0
											Local $currentpixel = $arrpixel[$iindex]
											Local $sBestSide = Side($currentpixel)
											SetLog($iindex & " - Deploy Point check " & _ArrayToString($currentpixel) & " side: " & $sBestSide)
											SetLog(UBound($arrpixel) & " deploy point(s) at " & $sBestSide, $COLOR_DEBUG)
											If $currentpixel[0] <> -1 Then ExitLoop
										EndIf
									Next
									$pixelRandomDrop[0] = $currentpixel[0] <> -1 ? $currentpixel[0] : $g_aideployheroesposition[0]
									$pixelRandomDrop[1] = $currentpixel[1] <> -1 ? $currentpixel[1] : $g_aideployheroesposition[1]
									If $pixelRandomDrop = -1 Then
										$pixelRandomDrop[0] = $g_aaiBottomLeftDropPoints[2][0]
										$pixelRandomDrop[1] = $g_aaiBottomLeftDropPoints[2][1]
									EndIf
									$pixelRandomDropCC[0] = $currentpixel[0] <> -1 ? $currentpixel[0] : $g_aideployccposition[0]
									$pixelRandomDropCC[1] = $currentpixel[1] <> -1 ? $currentpixel[1] : $g_aideployccposition[1]
									If $pixelRandomDropCC = -1 Then
										$pixelRandomDropCC[0] = $g_aaiBottomLeftDropPoints[2][0]
										$pixelRandomDropCC[1] = $g_aaiBottomLeftDropPoints[2][1]
									EndIf
									If ($g_bisccdropped = False And $infotrooplistarrpixel[0] = "CC") Then
										DropCC($pixelRandomDropCC[0], $pixelRandomDropCC[1], $iCC)
										$g_bisccdropped = True
									ElseIf ($g_bisheroesdropped = False And $infotrooplistarrpixel[0] = "HEROES" And $i = $numberSidesDropTroop - 1) Then
										DropHeroes($pixelRandomDrop[0], $pixelRandomDrop[1], $iKing, $iQueen, $iWarden, $iChampion)
										$g_bisheroesdropped = True
									EndIf
									If ($g_bisheroesdropped) Then
										If _Sleep($delaylaunchtroop22) Then Return
										checkheroeshealth()
									EndIf
								Else
									$infolistarrpixel = $infotrooplistarrpixel[1]
									Local $listpixel = $infolistarrpixel[$i]
									If _Sleep($delaylaunchtroop21) Then Return
									selectdroptroop($infotrooplistarrpixel[0])
									If _Sleep($delaylaunchtroop23) Then Return
									SetLog("Dropping " & $infotrooplistarrpixel[2] & " of " & $infotrooplistarrpixel[5] & " Points Per Side: " & $infotrooplistarrpixel[3] & " (side " & $i + 1 & ")", $COLOR_SUCCESS)
									Local $pixeldroptroop[1] = [$listpixel]
									droponpixel($infotrooplistarrpixel[0], $pixeldroptroop, $infotrooplistarrpixel[2], $infotrooplistarrpixel[3])
								EndIf
								If ($g_bisheroesdropped) Then
									If _Sleep(1000) Then Return
									checkheroeshealth()
								EndIf
							Next
						Next
					EndIf
				EndIf
				If _Sleep(SetSleep(1)) Then Return
			Next
		EndIf
		For $numWave = 0 To UBound($listListInfoDeployTroopPixel) - 1
			Local $listInfoDeployTroopPixel = $listListInfoDeployTroopPixel[$numWave]
			For $i = 0 To UBound($listInfoDeployTroopPixel) - 1
				Local $infoPixelDropTroop = $listInfoDeployTroopPixel[$i]
				If Not (IsString($infoPixelDropTroop[0]) And ($infoPixelDropTroop[0] = "CC" Or $infoPixelDropTroop[0] = "HEROES")) Then
					Local $numberLeft = ReadTroopQuantity($infoPixelDropTroop[0])
					If ($numberLeft > 0) Then
						If _Sleep($DELAYLAUNCHTROOP21) Then Return
						SelectDropTroop($infoPixelDropTroop[0]) ;Select Troop
						If _Sleep($DELAYLAUNCHTROOP23) Then Return
						SetLog("Dropping last " & $numberLeft & " of " & $infoPixelDropTroop[5], $COLOR_SUCCESS)
						;                       $troop,             $listArrPixel,               $number,                                 $slotsPerEdge = 0
						DropOnPixel($infoPixelDropTroop[0], $infoPixelDropTroop[1], Ceiling($numberLeft / UBound($infoPixelDropTroop[1])), $infoPixelDropTroop[3])
					EndIf
				EndIf
				If _Sleep(SetSleep(0)) Then Return
			Next
			If _Sleep(SetSleep(1)) Then Return
		Next
	Else
		For $i = 0 To UBound($listInfoDeploy) - 1
			If (IsString($listInfoDeploy[$i][0]) And ($listInfoDeploy[$i][0] = "CC" Or $listInfoDeploy[$i][0] = "HEROES")) Then
				If $g_iMatchMode = $LB And $g_aiAttackStdDropSides[$LB] >= 4 Then ; Used for DE or TH side attack
					Local $RandomEdge = $g_aaiEdgeDropPoints[$g_iBuildingEdge]
					Local $RandomXY = 2
				Else
					Local $RandomEdge = $g_aaiEdgeDropPoints[Round(Random(0, 3))]
					Local $RandomXY = Round(Random(1, 3))
				EndIf
				If ($listInfoDeploy[$i][0] = "CC") Then
					dropCC($RandomEdge[$RandomXY][0], $RandomEdge[$RandomXY][1], $iCC)
				ElseIf ($listInfoDeploy[$i][0] = "HEROES") Then
					DropHeroes($RandomEdge[$RandomXY][0], $RandomEdge[$RandomXY][1], $iKing, $iQueen, $iWarden, $iChampion)
				EndIf
			Else
				If LaunchTroop($listInfoDeploy[$i][0], $listInfoDeploy[$i][1], $listInfoDeploy[$i][2], $listInfoDeploy[$i][3], $listInfoDeploy[$i][4]) Then
					If _Sleep(SetSleep(1)) Then Return
				EndIf
			EndIf

		Next

	EndIf
	Return True
EndFunc   ;==>LaunchTroop2