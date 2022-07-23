; #FUNCTION# ====================================================================================================================
; Name ..........: Collect Free Magic Items from trader
; Description ...: Inspired in CollectFreeMagicItems() (ProMac (03-2018))
; Syntax ........: CollectMagicItems()
; Parameters ....:
; Return values .: None
; Author ........: Chilly-Chill, Boldina (boludoz) (7/5/2019 | 26/06/2021), NguyenAnhHD, Dissociable (3/5/2020), Team AIO Mod++ (2020), GrumpyHog
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2020
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
; ALL RESOLUTION FIXED
Func CollectMagicItems($bTest = False)
	If Not $g_bRunState Or $g_bRestart Then Return
	
	If Not ($g_iTownHallLevel >= 8 And not $g_iTownHallLevel = 0) Then Return ; Must be Th8 or more to use the Trader
	
	If $g_bChkCollectFreeMagicItems = False And $g_bChkCollectMagicItems = False Then Return

	Local Static $iLastTimeChecked[$g_eTotalAcc]
	If $iLastTimeChecked[$g_iCurAccount] = @MDAY And Not $bTest Then Return

	;ClickAway()

	If Not IsMainPage() Then Return

	SetLog("Collecting Free Magic Items", $COLOR_INFO)
	If _Sleep($DELAYCOLLECT2) Then Return

	; Check Trader Icon on Main Village

	If QuickMis("BC1", $g_sImgTrader, 120, 140, 210, 215, True, False) Then
		SetLog("Trader available, Entering Daily Discounts", $color_success)
		click($g_iQuickMISX, $g_iQuickMISY)
		If _sleep(1500) Then Return
	Else
		SetLog("Trader unavailable", $color_info)
		Return
	EndIf

	Local $aiDailyDiscount = decodeSingleCoord(findImage("DailyDiscount", $g_sImgDailyDiscountWindow, GetDiamondFromComma(370, 145 + $g_iMidOffsetYFixed, 480, 175 + $g_iMidOffsetYFixed), 1, True, Default))
	If Not IsArray($aiDailyDiscount) Or UBound($aiDailyDiscount, 1) < 1 Then
		ClickAway()
		Return
	EndIf

	If Not $g_bRunState Then Return
	Local $aOcrPositions[3][2] = [[280, 350 + $g_iMidOffsetYFixed], [475, 350 + $g_iMidOffsetYFixed], [650, 350 + $g_iMidOffsetYFixed]]
	Local $aResults[3] = ["", "", ""]

	If Not $bTest Then $iLastTimeChecked[$g_iCurAccount] = @MDAY

	Local $aFreeItem[4] = [255, 265 + $g_iMidOffsetYFixed, 0xA0A0A0, 10]
	
	If _CheckPixel($aFreeItem, True, Default, "CollectFreeMagicItems") Then
		SetLog("Free Item not available!", $COLOR_INFO)
		If _Sleep(100) Then Return
		Click(755, 160 + $g_iMidOffsetYFixed) ; Click Close Window Button
		If _Sleep(100) Then Return
		Return
	EndIf

	For $i = 0 To 2
		$aResults[$i] = getOcrAndCapture("coc-freemagicitems", $aOcrPositions[$i][0], $aOcrPositions[$i][1], 80, 25, True)
		;$aResults[$i] = getOcrAndCapture("coc-freemagicitems", $aOcrPositions[$i][0], $aOcrPositions[$i][1], 80, 30, True) ;CLASHIVERSARY title
		; 5D79C5 ; >Blue Background price
		; 0D997C ; >Xmas
		If $aResults[$i] <> "" Then
			If Not $bTest Then
				If $aResults[$i] = "FREE" Or $aResults[$i] = "mianfei" Then
					Click($aOcrPositions[$i][0], $aOcrPositions[$i][1], 2, 500)
					SetLog("Free Magic Item detected", $COLOR_INFO)
					;CloseWindow("CloseDD")
					If _Sleep(100) Then Return
					Click(755, 160 + $g_iMidOffsetYFixed) ; Click Close Window Button
					If _Sleep(100) Then Return
					Return
				Else
					If _ColorCheck(_GetPixelColor($aOcrPositions[$i][0], $aOcrPositions[$i][1] + 5, True), Hex(0x5D79C5, 6), 5) Then
						$aResults[$i] = $aResults[$i] & " Gems"
					Else
						$aResults[$i] = Int($aResults[$i]) > 0 ? "No Space In Castle" : "Collected"
					EndIf
				EndIf
			EndIf
		ElseIf $aResults[$i] = "" Then
			$aResults[$i] = "N/A"
		EndIf

		If Not $g_bRunState Then Return
	Next

	SetLog("Daily Discounts: " & $aResults[0] & " | " & $aResults[1] & " | " & $aResults[2])
	SetLog("Nothing free to collect!", $COLOR_INFO)

	;CloseWindow("CloseDD")
	If _Sleep(100) Then Return
	Click(755, 160 + $g_iMidOffsetYFixed) ; Click Close Window Button
	If _Sleep(100) Then Return
	CheckMainScreen()
EndFunc   ;==>CollectMagicItems
#cs
	
	If Not $g_bRunState Or $g_bRestart Then Return
	
	If Not ($g_iTownHallLevel >= 8 And not $g_iTownHallLevel = 0) Then Return ; Must be Th8 or more to use the Trader
	
	If $g_bChkCollectFreeMagicItems = False And $g_bChkCollectMagicItems = False Then Return
	
	#Region - Dates - Team AIO Mod++
	If Not $bDebug Then
		If _DateIsValid($g_sDateAndTimeMagicItems) Then
			Local $iDateDiff = _DateDiff('s', _NowCalc(), $g_sDateAndTimeMagicItems)
			If $iDateDiff > 0 And ($g_sConstMaxMagicItemsSeconds < $iDateDiff) = False Then
				SetLog("Collect Magic Items | We've been through here recently.", $COLOR_INFO)
				Return
			EndIf
		EndIf
	EndIf
	#EndRegion - Dates - Team AIO Mod++
	
	Local $aGemSlotsMult = 195
	Local $aResults[3] = ["", "", ""]
	Local $aResultsProx[3] = ["", "", ""]
	
	Local $bNoGems = False
	
	If Not $g_bRunState Or $g_bRestart Then Return
	
	If IsMainScreen() Then
		
		Local $sSetLog = ($g_bChkCollectMagicItems) ? ("Collecting Magic Items") : ("Collecting Free Magic Items")
		SetLog($sSetLog, $COLOR_INFO)
		If _Sleep($DELAYCOLLECT2) Then Return

		; Check Trader Icon on Main Village
		If _WaitForCheckImg($g_sImgTrader, "120,160,210,215", Default, 5000, 500) Then
			SetLog("Trader available, Entering Daily Discounts", $COLOR_SUCCESS)
			Click($g_aImageSearchXML[0][1], $g_aImageSearchXML[0][2])
		Else
			SetLog("Trader unavailable", $COLOR_INFO)
			Return
		EndIf
		
		If Not $g_bRunState Or $g_bRestart Then Return
		
		; Check Daily Discounts Window
		Local $aWaitX[4] = [703, 191, 0xFFFFFF, 25]
		Local $bCanFix = _Wait4Pixel($aWaitX[0], $aWaitX[1], $aWaitX[2], $aWaitX[3], 3000, 100, "IsGemOpen")		
		Local $eFixNoEvent = 0
		Local $aBlueItem[4] = [714, 180, 0xFFFFFF, 25]
		If _ColorCheck(_GetPixelColor($aBlueItem[0], $aBlueItem[1], True), Hex($aBlueItem[2], 6), $aBlueItem[3]) Then
			$eFixNoEvent = -9
		EndIf
		
		If $bCanFix = True Then ; White in 'X'.
		
			Local $aGemSlots[4] = [302, 457 + $eFixNoEvent, 0xE6FC8F, 35] ; 497
			Local $aWaitGem[4] = [421, 407, 0xB9E484, 25]
			Local $aOcrPositions[3][2] = [[200, 439], [390, 439], [580, 439]]

			; Dates - Team AIO Mod++
			If Not $bDebug Then 
				MagicItemsTime(307, 475 + $eFixNoEvent, 240, 42)
			EndIf
			
			If Not $g_bRunState Then Return
			
			_ImageSearchXML($g_sImgDirDailyDiscounts, 0, "140,230,720,485", True, False, True, 25)
			If UBound($g_aImageSearchXML) > 0 And Not @error Then
				
				If Not $g_bRunState Or $g_bRestart Then Return
				
				; Positioned precisely the item, and determines if this is enabled your purchase, if it is not enabled, add N / A, Exits the loop avoiding adding more than one item.
				For $i = 0 To 2
					For $iResult = 0 To UBound($g_aImageSearchXML) - 1
						If ($g_aImageSearchXML[$iResult][1]) > ($aOcrPositions[$i][0] - 41) And ($g_aImageSearchXML[$iResult][1]) < ($aOcrPositions[$i][0] + 135) Then
							$aResultsProx[$i] = ($g_abChkDD_Deals[GetDealIndex($g_aImageSearchXML[$iResult][0])] = False) ? ($g_aImageSearchXML[$iResult][0]) : ("OK" & " - " & $g_aImageSearchXML[$iResult][0])
							ExitLoop
						EndIf
					Next
				Next
				
				If $bDebug Then
					_ArrayDisplay($aResultsProx)
				EndIf

				For $i = 0 To 2
					
					If Not $g_bRunState Or $g_bRestart Then Return

					$aResults[$i] = getOcrAndCapture("coc-freemagicitems", $aOcrPositions[$i][0], $aOcrPositions[$i][1], 100, 100, True)
					$bNoGems = (StringIsSpace($aResults[$i]) = 1)
					
					If ($g_bChkCollectMagicItems = True And StringLeft($aResultsProx[$i], 2) = "OK" And $bNoGems = False) Or ($aResults[$i] = "FREE" And $g_bChkCollectFreeMagicItems = True) Then
						
						Local $hPixelGem = _GetPixelColor($aGemSlots[0] + ($aGemSlotsMult * $i), $aGemSlots[1], True)
						If _ColorCheck($hPixelGem, Hex($aGemSlots[2], 6), $aGemSlots[3]) = False Then 
							SetLog("Gem in gray, it is not possible to buy.", $COLOR_INFO)
							If $bDebug Then SetLog("Daily Discounts gem: " & $i & " | X: " & $aGemSlots[0] + ($aGemSlotsMult * $i) & " Y: " & $aGemSlots[1] & " H: 0x" & $hPixelGem, $COLOR_DEBUG)
							ContinueLoop
						EndIf
						
						SetLog("Magic Item detected : " & $aResultsProx[$i], $COLOR_INFO)
						
						Click($aGemSlots[0] + ($aGemSlotsMult * $i) - 57, $aGemSlots[1], 1)
						If $bDebug Then SetLog("Daily Discounts: " & "X: " & $aOcrPositions[$i][0] & " | " & "Y: " & $aOcrPositions[$i][1], $COLOR_DEBUG)
						If _Sleep(500) Then Return
						
						If $g_bChkCollectMagicItems = True Then
							
							If _Wait4Pixel($aWaitGem[0], $aWaitGem[1], $aWaitGem[2], $aWaitGem[3], 3000, 100, "IsGemOpen") Then
								
								If Not $g_bRunState Or $g_bRestart Then Return

								If Not $bDebug Then
									Click(421, 407)
								Else
									ClickAway()
								EndIf
								
								If _Wait4PixelGone($aWaitGem[0], $aWaitGem[1], $aWaitGem[2], $aWaitGem[3], 3000, 100, "IsGemOpenGone") Then
									SetLog("Successfully purchased " & $aResultsProx[$i], $COLOR_SUCCESS)
								Else
									SetLog("CollectMagicItems : badly in gem.", $COLOR_ERROR)
									
									ClickAway()
									If _Sleep(300) Then Return
								EndIf
							EndIf
							
						EndIf
						
					Else
						
						If _ColorCheck(_GetPixelColor($aGemSlots[0] + ($aGemSlotsMult * $i), $aGemSlots[1], True), Hex($aGemSlots[2], 6), $aGemSlots[3]) Then
							$aResults[$i] = ($bNoGems = False) ? ("(" & String($aResults[$i]) & " Gems)") : ("(No Gems)")
						Else
							$aResults[$i] = "(No Space In Castle Or Collected)"
						EndIf
						
					EndIf
					
					
					If Not $g_bRunState Then Return
				Next
				
				SetLog("Daily Discounts: " & $aResultsProx[0] & " " & $aResults[0] & " | " & $aResultsProx[1] & " " & $aResults[1] & " | " & $aResultsProx[2] & " " & $aResults[2], $COLOR_INFO)
				
			Else
				SetLog("No acquirable items were found.", $COLOR_ERROR)
				ClickAway(Default, True)     ;Click Away
			EndIf
		Else
			SetLog("CollectMagicItems : badly.", $COLOR_ERROR)
			If _Sleep(300) Then Return
		EndIf
	EndIf
	ClickAway()     ;Click Away
	CheckMainScreen(False)
EndFunc   ;==>CollectMagicItems

Func MagicItemsTime($x_start = 307, $y_start = 484, $iWidth = 240, $iHeight = 42)
	Local $iSeconds = 0
	Local $sString = "", $aTmp ; like xx#xx#xx
	$sString = getOcrAndCaptureDOCR($g_sASMagicItemsDOCRPath, $x_start, $y_start, $iWidth, $iHeight, True, True)
	SetDebugLog("MagicItemsTime : " & $sString)
	$aTmp = StringSplit($sString, '#')
	
	If Not @error Then
		Switch $aTmp[0]
			Case 1
				$iSeconds += $aTmp[1]
			Case 2
				$iSeconds += ($aTmp[1] * 60)
				$iSeconds += $aTmp[2]
			Case 3
				$iSeconds += ($aTmp[1] * 3600)
				$iSeconds += ($aTmp[2] * 60)
				$iSeconds += $aTmp[3]
		EndSwitch
	EndIf
	If $iSeconds < 3600 Then $iSeconds = Round(3600 * Random(1.4, 2.8)) ; 3600 Constant = 1 hour
	$g_sDateAndTimeMagicItems = _DateAdd('s', $iSeconds, _NowCalc())
	SetDebugLog("$g_sDateAndTimeMagicItems: " & $g_sDateAndTimeMagicItems)
EndFunc   ;==>MagicItemsTime

Func GetDealIndex($sName)
	Switch ($sName)
		Case "TrainPotion"
			Return $g_eDDPotionTrain
		Case "ClockPotion"
			Return $g_eDDPotionClock
		Case "ResearchPotion"
			Return $g_eDDPotionResearch
		Case "ResourcePotion"
			Return $g_eDDPotionResource
		Case "BuilderPotion"
			Return $g_eDDPotionBuilder
		Case "PowerPotion"
			Return $g_eDDPotionPower
		Case "HeroPotion"
			Return $g_eDDPotionHero
		Case "SuperPotion"
			Return $g_eDDSuperPotion
		Case "WallRing"
			Local $sSearchDiamond = GetDiamondFromRect("140,240,720,485")
			If UBound(decodeSingleCoord(findImage("WallRingAmountx5", $g_sImgDDWallRingx5, $sSearchDiamond, 1, True))) > 1 Then
				Return $g_eDDWallRing5
			ElseIf UBound(decodeSingleCoord(findImage("WallRingAmountx10", $g_sImgDDWallRingx10, $sSearchDiamond, 1, True))) > 1 Then
				Return $g_eDDWallRing10
			EndIf
		Case "Shovel"
			Return $g_eDDShovel
		Case "BookHeros"
			Return $g_eDDBookHeros
		Case "BookFighting"
			Return $g_eDDBookFighting
		Case "BookSpells"
			Return $g_eDDBookSpells
		Case "BookBuilding"
			Return $g_eDDBookBuilding
		Case "RuneGold"
			Return $g_eDDRuneGold
		Case "RuneElixir"
			Return $g_eDDRuneElixir
		Case "RuneDarkElixir"
			Return $g_eDDRuneDarkElixir
		Case "RuneBBGold"
			Return $g_eDDRuneBBGold
		Case "RuneBBElixir"
			Return $g_eDDRuneBBElixir
		Case Else
			Return -1 ; error
	EndSwitch
EndFunc   ;==>GetDealIndex
#ce