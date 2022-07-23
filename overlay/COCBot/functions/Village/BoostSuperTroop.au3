; #FUNCTION# ====================================================================================================================
; Name ..........: Boost a troop to super troop
; Description ...: Supertroops with low maintenance level, based on images.
; Syntax ........: BoostSuperTroop()
; Parameters ....:
; Return values .:
; Author ........: xbebenk (08/2021), Boldina (08/2021 - 03/2022)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2021
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func SetOnStAuto($i, $bTest = False)
	If $g_bSuperAutoTroops = False Or $g_bQuickTrainEnable = True Then 
		Return Int($g_iCmbSuperTroops[$i] - 1)
	EndIf

	Local $aTroopsAuto[$iMaxSupersTroop] = [0, 0], $iCount = 0
	
	If $i > Int($iMaxSupersTroop - 1) Then Return SetError(1, 1, -1)
	
	If $g_bSuperAutoTroops = True And $g_bQuickTrainEnable = False Then
		For $iAssignSt = 0 To UBound($g_ahTxtTrainArmyTroopCount) - 1
			If $g_aiArmyCustomTroops[$iAssignSt] = 0 Then ContinueLoop

			For $i2 = 0 To $iSuperTroopsCount -1
				If $iAssignSt = $g_asSuperTroopIndex[$i2] Then
					$aTroopsAuto[$iCount] = $i2 + 1
					$iCount += 1
					If $iCount = $iMaxSupersTroop + 1 Then
						ExitLoop 2
					EndIf
					ExitLoop
				EndIf
			Next

		Next
	EndIf
	
	Local $aCmbTmp[2] = [_ArrayMin($aTroopsAuto, 1) - 1, _ArrayMax($aTroopsAuto, 1) - 1]
	If $aCmbTmp[0] = $aCmbTmp[1] Then $aCmbTmp[1] = -1
	
	If $bTest = True Then _ArrayDisplay($aCmbTmp)

	Return $aCmbTmp[$i]
EndFunc   ;==>SetOnStAuto

Func BoostSuperTroop($bTest = False)
	If Not $g_bSuperTroopsEnable Then
		Return False
	EndIf

	SetLog("Checking super troops.", $COLOR_INFO)

	Local $aAlreadyChecked[0]

	Local $aTroopsAuto[$iMaxSupersTroop] = [0, 0], $iCount = 0

	If $g_bSuperAutoTroops = True And $g_bQuickTrainEnable = False Then
		For $iAssignSt = 0 To UBound($g_ahTxtTrainArmyTroopCount) - 1
			If $g_aiArmyCustomTroops[$iAssignSt] = 0 Then ContinueLoop

			For $i2 = 0 To $iSuperTroopsCount -1
				If $iAssignSt = $g_asSuperTroopIndex[$i2] Then
					$aTroopsAuto[$iCount] = $i2 + 1
					$iCount += 1
					If $iCount = $iMaxSupersTroop + 1 Then
						SetLog("Max Super Troops limit in game overflow on GUI (" & $iMaxSupersTroop & ")", $COLOR_ERROR)
						ExitLoop 2
					EndIf
					ExitLoop
				EndIf
			Next
		Next
	EndIf

	Local $aiSTCombos = ($g_bSuperAutoTroops = True And $g_bQuickTrainEnable = False) ? ($aTroopsAuto) : ($g_iCmbSuperTroops)
	Local $aCmbTmp[2] = [_ArrayMin($aiSTCombos, 1) - 1, _ArrayMax($aiSTCombos, 1) - 1]
	If $aCmbTmp[0] = $aCmbTmp[1] Then $aCmbTmp[1] = -1
	
	If $bTest = True Then _ArrayDisplay($aCmbTmp)

	Local $iActive = 0
	For $i = 0 To 1
		If $aiSTCombos[$i] > 0 Then
			$iActive += 1
		EndIf
	Next

	If $iActive = 0 Then
		SetLog("No troops have been selected to accelerate.", $COLOR_WARNING)
		Return False
	EndIf

	Local $aBrownDown[4] = [150, 552 + $g_iBottomOffsetYFixed, 0x685C50, 20] ; Resolution changed

	Local $bCheckBottom = False, $bBadTryPotion = False, $bBadTryDark = False, $bTroopCord = False, $bIsGrayed = False
	Local $iIndex = -1, $aSuperT = -1, $aClock = -1, $aTmp = -1, $aBarD = 0, $iDist = 0, $sFilenameClock = "", $sFilenameST = ""
	Local $aClockCoords[0], $aTroopsCoords[0], $aPoints[0]
	Local $sGetDiamondFromRect = GetDiamondFromRect("140,191(580,330)") ; Resolution changed

	ClickAway()
	If IsMainPage(1) Then
		If QuickMIS("BC1", $g_sImgBoostTroopsBarrel, 0, 0, 170, 250, True, False) Then ; Resolution changed
			If $bTest Then SetLog("Found Barrel at " & $g_iQuickMISX & "," & $g_iQuickMISY, $COLOR_DEBUG)
			Click($g_iQuickMISX, $g_iQuickMISY, 1)
			If _Sleep(1500) Then Return

			; Check the brown pixel below, just below the black one to avoid confusion.
			If IsSTPage() = True Then

				If _Sleep(1500) Then Return

				; Nada al azar.
				Local $eBeDrag = Floor($iSuperTroopsCount / 4)
				If Mod($iSuperTroopsCount, 4) > 0 Then $eBeDrag += 1
				For $iDrags = 1 To $eBeDrag

					If IsSTPage(1) = True Then

						_CaptureRegions()
						$bCheckBottom = _CheckPixel($aBrownDown, False)

						; Check If is boosted
						Local $aSuperT = findMultiple($g_sImgBoostTroopsIcons, $sGetDiamondFromRect, $sGetDiamondFromRect, 0, 1000, 0, "objectname,objectlevel,objectpoints", False)
						Local $aClock = findMultiple($g_sImgBoostTroopsClock, $sGetDiamondFromRect, $sGetDiamondFromRect, 0, 1000, 0, "objectname,objectlevel,objectpoints", False)
						If UBound($aSuperT) > 0 And Not @error Then
							For $aMatchedTroops In $aSuperT
								If $iActive = UBound($aAlreadyChecked) Then
									ContinueLoop
								EndIf
								
								$aPoints = decodeMultipleCoords($aMatchedTroops[2])
								
								If UBound($aPoints) > 0 And not @error Then
								
									$sFilenameST = $aMatchedTroops[0] ; Filename
									
									$aTroopsCoords = $aPoints[0]
									
									Local $iRedColor = -1, $yEnd = $aTroopsCoords[1]
									Do 	
										$yEnd -= 1
										
										If Abs($yEnd - $aTroopsCoords[1]) = 150 Then ExitLoop
										
										Local $xMid = 0
										Select 
											Case $aTroopsCoords[0] > 150 And $aTroopsCoords[0] < 277
												$xMid = 150 + 65
											Case $aTroopsCoords[0] > 293 And $aTroopsCoords[0] < 418
												$xMid = 293 + 65
											Case $aTroopsCoords[0] > 435 And $aTroopsCoords[0] < 560
												$xMid = 435 + 65
											Case $aTroopsCoords[0] > 578 And $aTroopsCoords[0] < 703
												$xMid = 578 + 65
											Case Else
												ContinueLoop
										EndSelect
										
										If _ColorCheck(_GetPixelColor($xMid, $yEnd, False), Hex(0xDD4545, 6), 25) = True Then
											$iRedColor += 1
										EndIf
									Until $iRedColor = 3
									
									If $iRedColor < 2 Then
										ContinueLoop
									EndIf

									SetDebugLog($sFilenameST & " found (" & $aTroopsCoords[0] & "," & $aTroopsCoords[1] & ")", $COLOR_SUCCESS)

									If _ArraySearch($aAlreadyChecked, $sFilenameST) > -1 And Not @error Then
										If $bTest Then Setlog("Skip checked " & $sFilenameST & ".", $COLOR_DEBUG)
										ContinueLoop
									ElseIf $bCheckBottom = False And $aTroopsCoords[1] > 472 Then
										If $bTest Then Setlog("Skip bottom " & $sFilenameST & " X: " & $aTroopsCoords[0] & " Y: " & $aTroopsCoords[1] & ".", $COLOR_DEBUG)
										ContinueLoop
									EndIf

									; Check If is boosted
									If $bTest Then SetLog("Stage 1 - Check If is boosted.", $COLOR_INFO)
									If UBound($aClock) > 0 And Not @error Then
										For $aMatchedClocks In $aClock
											$aPoints = decodeMultipleCoords($aMatchedClocks[2])
											$sFilenameClock = $aMatchedClocks[0] ; Filename
											For $i = 0 To UBound($aPoints) - 1
												$aClockCoords = $aPoints[$i] ; Coords
												SetDebugLog($sFilenameClock & " found (" & $aClockCoords[0] & "," & $aClockCoords[1] & ")", $COLOR_SUCCESS)
												Local $bIsOnArea = IsOnArea($aClockCoords[0] - 30, $aClockCoords[1] - 110, $aClockCoords[0] + 95, $aClockCoords[1], $aTroopsCoords[0], $aTroopsCoords[1])
												SetDebuglog("Clock check in : " & $aClockCoords[0] & " / " & $aClockCoords[1] & " | " & $sFilenameST & " | IS ON AREA : " & $bIsOnArea)
												If $bIsOnArea = True Then
													Local $iIndexName = TroopIndexLookup($sFilenameST)
													If $iIndexName <> -1 Then
														SetLog($g_asTroopNamesPlural[$iIndexName] & " is boosted.", $COLOR_INFO)
													Else
														SetLog("Unrecognized " & $sFilenameST)
													EndIf
													
													ReDim $aAlreadyChecked[UBound($aAlreadyChecked) + 1]
													$aAlreadyChecked[UBound($aAlreadyChecked) - 1] = $sFilenameST

													If $iActive = UBound($aAlreadyChecked) Then
														ExitLoop 4
													EndIf

													ContinueLoop 3
												EndIf
											Next
										Next
									EndIf

									If $bTest Then SetLog("Stage 2 - Boost.", $COLOR_INFO)
									For $i = 0 To 1

										; Verifica que el slot $i este activo.
										If $aCmbTmp[$i] > -1 Then

											; Devuelve el index en short name.
											$iIndex = _ArraySearch($g_asTroopShortNames, $sFilenameST)
											If $bTest Then SetLog("_ArraySearch : " & $sFilenameST & " | Index : Test 1")
											If $iIndex > -1 Then

												If $bTest Then SetLog("_ArraySearch : " & $g_asTroopShortNames[$iIndex] & " | " & $sFilenameST & " | Index : " & $iIndex)
												If $g_asTroopNames[$iIndex] = $g_asSuperTroopNames[$aCmbTmp[$i]] Then
													If $bTest Then SetLog("Compare texts : " & $g_asTroopNames[$iIndex] & " | " & $g_asSuperTroopNames[$aCmbTmp[$i]])

													; Boost Here
													Click($aTroopsCoords[0], $aTroopsCoords[1], 1)
													If _Sleep(1500) Then Return False

													If IsSTPageBoost() Then
														Local $sTroopName = $g_asSuperTroopNames[$aCmbTmp[$i]]

														Setlog("Checking " & $sTroopName, $COLOR_INFO)

														ReDim $aAlreadyChecked[UBound($aAlreadyChecked) + 1]
														$aAlreadyChecked[UBound($aAlreadyChecked) - 1] = $sFilenameST

														If $bBadTryPotion == False And $bBadTryDark == False Then
															FinalBoostST($bBadTryPotion, $bBadTryDark, $bTest)
														Else
															ClickAway(Default, True)
															If _Sleep(1500) Then Return False
														EndIf
													Else
														Setlog("Bad IsSTPageBoost.", $COLOR_ERROR)
														ClickAway(Default, True)
														If _Sleep(1500) Then Return False

														ClickAway(Default, True)
														If _Sleep(1500) Then Return False
														ExitLoop 3
													EndIf

													If IsSTPageBoost(1) = True Then
														ClickAway()
														If _Sleep(500) Then Return
													EndIf

													If IsSTPage(1) = False Then
														ClickAway()
														If _Sleep(500) Then Return
													EndIf
												EndIf
											EndIf
										EndIf
										If $iActive = UBound($aAlreadyChecked) Then
											ExitLoop 3
										EndIf
									Next
								EndIf
							Next
						EndIf
						
						If $iDrags = 1 Then
							ClickDrag(283, 500 + $g_iBottomOffsetYFixed, 283, 260 + $g_iMidOffsetYFixed, 200) ; Resolution changed
						Else
							ClickDrag(283, 500 - 67 + $g_iBottomOffsetYFixed, 283, 260 + $g_iMidOffsetYFixed, 200) ; Resolution changed
						EndIf
						
						If $bTest Then SetLog("Stage ClickDrag.", $COLOR_INFO)
						If _Sleep(1500) Then Return False
					Else
						SetLog("Bad IsSTPage.", $COLOR_ERROR)
						ClickAway()
						If _Sleep(500) Then Return

						ClickAway()
						If _Sleep(500) Then Return
						ExitLoop
					EndIf
				Next
			EndIf
		Else
			SetLog("Couldn't find super troop barrel.", $COLOR_ERROR)
		EndIf

		If UBound($aAlreadyChecked) > 0 And not @error Then
			SetLog("Super troops checked:", $COLOR_INFO)

			For $i = 0 To UBound($aAlreadyChecked) - 1
				Local $iIndexName = TroopIndexLookup($aAlreadyChecked[$i])
				If $iIndexName <> -1 Then
					SetLog("- " & $g_asTroopNamesPlural[$iIndexName], $COLOR_INFO)
				Else
					SetLog(" - Unrecognized " & $aAlreadyChecked[$i])
				EndIf
			Next
		EndIf
	Else
		SetLog("BoostSuperTroop: Bad mainscreen.", $COLOR_ERROR)
	EndIf

	ClickAway()
	If _Sleep(500) Then Return

EndFunc   ;==>BoostSuperTroop

Func FinalBoostST(ByRef $bBadTryPotion, ByRef $bBadTryDark, $bTest = False)

	Local $aImgBoostBtn1[4] = [430, 485, 740, 550] ; Resolution changed
	Local $aImgBoostBtn2[4] = [330, 400, 515, 465] ; Resolution changed

	Local $bPotionAvariable = QuickMIS("BC1", $g_sImgBoostTroopsPotion, $aImgBoostBtn1[0], $aImgBoostBtn1[1], $aImgBoostBtn1[2], $aImgBoostBtn1[3], True, False)
	Local $aClickPotion[2] = [$g_iQuickMISX, $g_iQuickMISY]

	Local $bDarkAvariable = QuickMIS("BC1", $g_sImgBoostTroopsButtons, $aImgBoostBtn1[0], $aImgBoostBtn1[1], $aImgBoostBtn1[2], $aImgBoostBtn1[3], True, False)
	Local $aClickDark[2] = [$g_iQuickMISX, $g_iQuickMISY]
	$bDarkAvariable = IsDarkAvariable() And $bDarkAvariable
	Local $aResource = [$bDarkAvariable, $bPotionAvariable]
	Local $aClick = [$aClickDark, $aClickPotion]
	Local $iDOW = $g_iCmbSuperTroopsResources + 1
	Local $iD = -1
	Local $iNum = -1
	For $iWk = 1 To 2
		If $iD > 2 Then
			$iDOW = ($g_iCmbSuperTroopsResources + 1) - 2
		EndIf
		$iD = $iDOW + $iWk
		$iNum = $iD - 2
		If $aResource[$iNum] == True Then
			ClickP($aClick[$iNum])
			If _Sleep(1500) Then Return
			
			Local $sMode = ""
			$sMode = ($iNum = 0) ? ($g_sImgBoostTroopsButtons) : ($g_sImgBoostTroopsPotion)
			If QuickMIS("BC1", $sMode, $aImgBoostBtn2[0], $aImgBoostBtn2[1], $aImgBoostBtn2[2], $aImgBoostBtn2[3], True, False) Then
				If $bTest = False Then
					Click($g_iQuickMISX, $g_iQuickMISY, 1)
				Else
					$sMode = ($iNum = 0) ? ("dark") : ("potion")
					SetLog("Not possible boost with " & $sMode, $COLOR_ERROR)
					ClickAway()
					If _Sleep(1500) Then Return

					ClickAway()
				EndIf
			EndIf

			ExitLoop
		Else
			If $iNum = 0 Then
				$bBadTryDark = True
			Else
				$bBadTryPotion = True
			EndIf
		EndIf
	Next
EndFunc   ;==>FinalBoostST

Func IsDarkAvariable()
	Return (WaitforPixel(632, 543 + $g_iBottomOffsetYFixed, 688, 576 + $g_iBottomOffsetYFixed, Hex(0xFF887F, 6), 15, 1) = False)
EndFunc   ;==>IsDarkAvariable

Func IsSTPage($iTry = 15)
	Return WaitforPixel(428, 214 + $g_iMidOffsetYFixed, 430, 216 + $g_iMidOffsetYFixed, Hex(0xF0D028, 6), 15, $iTry)
EndFunc   ;==>IsSTPage

Func IsSTPageBoost($iTry = 15)
	Return WaitforPixel(545, 165 + $g_iMidOffsetYFixed, 610, 220 + $g_iMidOffsetYFixed, Hex(0xF0D028, 6), 15, $iTry)
EndFunc   ;==>IsSTPageBoost

Func IsOnArea($x, $y, $x1, $y1, $iPointX, $iPointY)
	Local $iAreaX, $iAreaY
	$iAreaX = Abs($x - $x1) / (_Max($x, $x1) - $iPointX)
	$iAreaY = Abs($y - $y1) / (_Max($y, $y1) - $iPointY)
	If (1 > $iAreaY) Or (1 > $iAreaX) Then Return False
	Return True
EndFunc   ;==>IsOnSquare
