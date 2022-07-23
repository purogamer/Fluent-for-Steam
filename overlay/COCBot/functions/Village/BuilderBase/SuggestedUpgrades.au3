; #FUNCTION# ====================================================================================================================
; Name ..........: SuggestedUpgrades()
; Description ...: Goes to Builders Island and Upgrades buildings with 'suggested upgrades window'.
; Syntax ........: SuggestedUpgrades()
; Parameters ....:
; Return values .: None
; Author ........: ProMac (05-2017), Team AIO Mod++ (2021)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

; coc-armycamp ---> OCR the values on Builder suggested updates
; coc-build ----> building names and levels [ needs some work on 'u' and 'e' ]  BuildingInfo

; Zoomout
; If Suggested Upgrade window is open [IMAGE] -> C:\Users\user\Documents\MDOCOCPROJECT\imgxml\Resources\PicoBuildersBase\SuggestedUpdates\IsSuggestedWindowOpened_0_92.png
; Image folder [GOLD] -> C:\Users\user\Documents\MDOCOCPROJECT\imgxml\Resources\PicoBuildersBase\SuggestedUpdates\Gold_0_89.png
; Image folder [GOLD] -> C:\Users\user\Documents\MDOCOCPROJECT\imgxml\Resources\PicoBuildersBase\SuggestedUpdates\Elixir_0_89.png

; Buider Icon position Blue[i] [Check color] [360, 11, 0x7cbdde, 10]
; Suggested Upgrade window position [Imgloc] [380, 59, 100, 20]
; Zone to search for Gold / Elixir icons and values [445, 100, 90, 85 ]
; Gold offset for OCR [Point] [x,y, length]  ,x = x , y = - 10  , length = 535 - x , Height = y + 7   [17]
; Elixir offset for OCR [Point] [x,y, length]  ,x = x , y = - 10  , length = 535 - x , Height = y + 7 [17]
; Buider Name OCR ::::: BuildingInfo(245, 490 + $g_iBottomOffsetY)
; Button Upgrade position [275, 670, 300, 30]  -> UpgradeButton_0_89.png
; Button OK position Check Pixel [430, 540, 0x6dbd1d, 10] and CLICK

; Draft
; 01 - Verify if we are on Builder island [Boolean]
; 01.1 - Verify available builder [ OCR - coc-Builders ] [410 , 23 , 40 ]
; 02 - Click on Builder [i] icon [Check color]
; 03 - Verify if the window opened [Boolean]
; 04 - Detect Gold and Exlir icons [Point] by a dynamic Y [ignore list]
; 05 - With the previous positiosn and a offset , proceeds with OCR : [WHITE] OK , [salmon] Not enough resources will return "" [strings] convert to [integer]
; 06 - Make maths , IF the Gold is selected on GUI , if Elixir is Selected on GUI , and the resources values and min to safe [Boolean]
; 07 - Click on he correct ICon on Suggested Upgrades window [Point]
; 08 - Verify buttons to upgrade [Point] - Detect the Builder name [OCR]
; 09 - Verify the button to upgrade window [point]  -> [Boolean] ->[check pixel][imgloc]
; 10 - Builder Base report
; 11 - DONE

; GUI
; Check Box to enable the function
; Ignore Gold , Ignore Elixir
; Ignore building names
; Setlog

Func chkActivateBBSuggestedUpgrades()
	; CheckBox Enable Suggested Upgrades [Update values][Update GUI State]
	If GUICtrlRead($g_hChkBBSuggestedUpgrades) = $GUI_CHECKED Then
		$g_iChkBBSuggestedUpgrades = 1
		GUICtrlSetState($g_hChkBBSuggestedUpgradesIgnoreGold, $GUI_ENABLE)
		GUICtrlSetState($g_hChkBBSuggestedUpgradesIgnoreElixir, $GUI_ENABLE)
		#Region - Custom BB Army - Team AIO Mod++
;~ 		GUICtrlSetState($g_hChkBBSuggestedUpgradesIgnoreHall, $GUI_ENABLE)
;~ 		GUICtrlSetState($g_hChkBBSuggestedUpgradesIgnoreWall, $GUI_ENABLE)
		GUICtrlSetState($g_hChkPlacingNewBuildings, $GUI_ENABLE)
		; For $i = 0 To UBound($g_iChkBBUpgradesToIgnore) - 1
			; GUICtrlSetState($g_hChkBBUpgradesToIgnore[$i], $GUI_ENABLE)
		; Next
		#EndRegion - Custom BB Army - Team AIO Mod++
		GUICtrlSetState($g_hRadioBBUpgradesToIgnore, $GUI_ENABLE) ; Custom Improve - Team AIO Mod++
		GUICtrlSetState($g_hRadioBBCustomOTTO, $GUI_ENABLE) ; Custom Improve - Team AIO Mod++
	Else
		$g_iChkBBSuggestedUpgrades = 0
		GUICtrlSetState($g_hChkBBSuggestedUpgradesIgnoreGold, BitOR($GUI_UNCHECKED, $GUI_DISABLE))
		GUICtrlSetState($g_hChkBBSuggestedUpgradesIgnoreElixir, BitOR($GUI_UNCHECKED, $GUI_DISABLE))
		#Region - Custom BB Army - Team AIO Mod++
;~ 		GUICtrlSetState($g_hChkBBSuggestedUpgradesIgnoreHall, BitOR($GUI_UNCHECKED, $GUI_DISABLE))
;~ 		GUICtrlSetState($g_hChkBBSuggestedUpgradesIgnoreWall, BitOR($GUI_UNCHECKED, $GUI_DISABLE))
		GUICtrlSetState($g_hChkPlacingNewBuildings, BitOR($GUI_UNCHECKED, $GUI_DISABLE))
		; For $i = 0 To UBound($g_iChkBBUpgradesToIgnore) - 1
			; GUICtrlSetState($g_hChkBBUpgradesToIgnore[$i], $GUI_DISABLE)
		; Next
		#EndRegion - Custom BB Army - Team AIO Mod++
		GUICtrlSetState($g_hRadioBBUpgradesToIgnore, $GUI_DISABLE) ; Custom Improve - Team AIO Mod++
		GUICtrlSetState($g_hRadioBBCustomOTTO, $GUI_DISABLE) ; Custom Improve - Team AIO Mod++
	EndIf
	RadioIgnoreUpgradesBBOrOtto() ; Custom Improve - Team AIO Mod++
EndFunc   ;==>chkActivateBBSuggestedUpgrades

Func chkActivateBBSuggestedUpgradesGold()
	; if disabled, why continue?
	If $g_iChkBBSuggestedUpgrades = 0 Then Return
	; Ignore Upgrade Building with Gold [Update values]
	$g_iChkBBSuggestedUpgradesIgnoreGold = (GUICtrlRead($g_hChkBBSuggestedUpgradesIgnoreGold) = $GUI_CHECKED) ? 1 : 0
	; If Gold is Selected Than we can disable the Builder Hall [is gold] and Wall almost [is Gold]
	If $g_iChkBBSuggestedUpgradesIgnoreGold = 0 Then
		GUICtrlSetState($g_hChkBBSuggestedUpgradesIgnoreElixir, $GUI_ENABLE)
;~ 		GUICtrlSetState($g_hChkBBSuggestedUpgradesIgnoreHall, $GUI_ENABLE)
;~ 		GUICtrlSetState($g_hChkBBSuggestedUpgradesIgnoreWall, $GUI_ENABLE)
	Else
		GUICtrlSetState($g_hChkBBSuggestedUpgradesIgnoreElixir, BitOR($GUI_UNCHECKED, $GUI_DISABLE))
;~ 		GUICtrlSetState($g_hChkBBSuggestedUpgradesIgnoreHall, BitOR($GUI_UNCHECKED, $GUI_DISABLE))
;~ 		GUICtrlSetState($g_hChkBBSuggestedUpgradesIgnoreWall, BitOR($GUI_UNCHECKED, $GUI_DISABLE))
	EndIf
	; Ignore Upgrade Builder Hall [Update values]
;~ 	$g_iChkBBSuggestedUpgradesIgnoreHall = (GUICtrlRead($g_hChkBBSuggestedUpgradesIgnoreHall) = $GUI_CHECKED) ? 1 : 0
	; Update Elixir value
	$g_iChkBBSuggestedUpgradesIgnoreElixir = (GUICtrlRead($g_hChkBBSuggestedUpgradesIgnoreElixir) = $GUI_CHECKED) ? 1 : 0
	; Ignore Wall
;~ 	$g_iChkBBSuggestedUpgradesIgnoreWall = (GUICtrlRead($g_hChkBBSuggestedUpgradesIgnoreWall) = $GUI_CHECKED) ? 1 : 0
EndFunc   ;==>chkActivateBBSuggestedUpgradesGold

Func chkActivateBBSuggestedUpgradesElixir()
	; if disabled, why continue?
	If $g_iChkBBSuggestedUpgrades = 0 Then Return
	; Ignore Upgrade Building with Elixir [Update values]
	$g_iChkBBSuggestedUpgradesIgnoreElixir = (GUICtrlRead($g_hChkBBSuggestedUpgradesIgnoreElixir) = $GUI_CHECKED) ? 1 : 0
	If $g_iChkBBSuggestedUpgradesIgnoreElixir = 0 Then
		GUICtrlSetState($g_hChkBBSuggestedUpgradesIgnoreGold, $GUI_ENABLE)
	Else
		GUICtrlSetState($g_hChkBBSuggestedUpgradesIgnoreGold, BitOR($GUI_UNCHECKED, $GUI_DISABLE))
	EndIf
	; Update Gold value
	$g_iChkBBSuggestedUpgradesIgnoreGold = (GUICtrlRead($g_hChkBBSuggestedUpgradesIgnoreGold) = $GUI_CHECKED) ? 1 : 0
EndFunc   ;==>chkActivateBBSuggestedUpgradesElixir

Func chkPlacingNewBuildings()
	$g_iChkPlacingNewBuildings = (GUICtrlRead($g_hChkPlacingNewBuildings) = $GUI_CHECKED) ? 1 : 0
EndFunc   ;==>chkPlacingNewBuildings

; MAIN CODE
#Region - Bulder base upgrades - Team AIO Mod++
Global $g_bBuildingUpgraded = False

Func MainSuggestedUpgradeCode($bDebug = $g_bDebugSetlog)
	Local $aResourcesPicks[0][3], $aResourcesReset[0][3], $aMatrix[1][3], $aResult[3] = [-1, -1, ""]

	Local $vMultipix = 0
	Local $aAreaToSearch[4] = [374, 73, 503, 370] ; Resolution changed

	$g_bBuildingUpgraded = False

	; If is not selected return
	If $g_iChkBBSuggestedUpgrades = 0 Then Return

	BuilderBaseReport()

	Local $aArrays = -1
	Local $iMinScroll = -1, $iMaxScroll = -1
	Local $iMinScroll1 = -1, $iMaxScroll1 = -1
	Local $iMinScroll2 = -1, $iMaxScroll2 = -1
	Local $bAlreadyCheked = False

	ClickAway(Default, True)
	If _Sleep(500) Then Return

	If isOnBuilderBase(True) Then

		If ClickOnBuilder() Then

			SetLog("Checking for upgrades in the builder base.", $COLOR_INFO)
			
			Local $iMaxLoop = -1
			While _PixelSearch(309, 79, 440, 103, Hex(0xD4FF80, 6), 25) = False And $iMaxLoop < 3
				Swipe(344, 124, 344, 374, 1000)
				If _Sleep(Random(1000, 2000, 1)) Then Return
				$iMaxLoop += 1
			Wend 
			
			For $z = 0 To 6     ; For do scroll 7 times.

				If _Sleep(1500) Then Return

				$aArrays = QuickMIS("CNX", $g_sImgAutoUpgradeElixir, $aAreaToSearch[0], $aAreaToSearch[1], $aAreaToSearch[2], $aAreaToSearch[3], True, False) ; _ImageSearchXML($g_sImgAutoUpgradeElixir, 10, $aAreaToSearch, False, True, True, 8, 0, 1000)
				If IsArray($aArrays) Then
					$iMinScroll1 = _ArrayMin($aArrays, 1, -1, -1, 2)
					$iMaxScroll1 = _ArrayMax($aArrays, 1, -1, -1, 2)
				EndIf

				If $g_iChkBBSuggestedUpgradesIgnoreElixir = 0 And $g_aiCurrentLootBB[$eLootElixirBB] > 250 Then
					If UBound($aArrays) > 0 And Not @error Then
						For $iItem = 0 To UBound($aArrays) - 1
							If UBound(_PixelSearch(512, $aArrays[$iItem][2] - 14, 529, $aArrays[$iItem][2] + 14, Hex(0xFFFFFF, 6), 35)) > 0 And Not @error Then
								$aMatrix[0][0] = (UBound(_PixelSearch(310, $aArrays[$iItem][2] - 14, 340, $aArrays[$iItem][2] + 14, Hex(0x0DFF0D, 6), 35)) > 0 And Not @error) ? ("New") : ("Elixir")
								If ($g_iChkPlacingNewBuildings = 1 And $aMatrix[0][0] = "New") Or $aMatrix[0][0] <> "New" Then
									$aMatrix[0][1] = $aArrays[$iItem][1]
									$aMatrix[0][2] = $aArrays[$iItem][2]
									_ArrayAdd($aResourcesPicks, $aMatrix)
								EndIf
							EndIf
						Next
					EndIf
				EndIf

				$aArrays = QuickMIS("CNX", $g_sImgAutoUpgradeGold, $aAreaToSearch[0], $aAreaToSearch[1], $aAreaToSearch[2], $aAreaToSearch[3], True, False) ; _ImageSearchXML($g_sImgAutoUpgradeGold, 10, $aAreaToSearch, False, True, True, 8, 0, 1000)
				If IsArray($aArrays) Then
					$iMinScroll2 = _ArrayMin($aArrays, 1, -1, -1, 2)
					$iMaxScroll2 = _ArrayMax($aArrays, 1, -1, -1, 2)
				EndIf

				If $g_iChkBBSuggestedUpgradesIgnoreGold = 0 And $g_aiCurrentLootBB[$eLootGoldBB] > 250 Then
					If UBound($aArrays) > 0 And Not @error Then
						For $iItem = 0 To UBound($aArrays) - 1
							If UBound(_PixelSearch(512, $aArrays[$iItem][2] - 14, 529, $aArrays[$iItem][2] + 14, Hex(0xFFFFFF, 6), 35)) > 0 And Not @error Then
								$aMatrix[0][0] = (UBound(_PixelSearch(310, $aArrays[$iItem][2] - 14, 340, $aArrays[$iItem][2] + 14, Hex(0x0DFF0D, 6), 35)) > 0 And Not @error) ? ("New") : ("Gold")
								If ($g_iChkPlacingNewBuildings = 1 And $aMatrix[0][0] = "New") Or $aMatrix[0][0] <> "New" Then
									$aMatrix[0][1] = $aArrays[$iItem][1]
									$aMatrix[0][2] = $aArrays[$iItem][2]
									_ArrayAdd($aResourcesPicks, $aMatrix)
								EndIf
							EndIf
						Next
					EndIf
				EndIf

				If $iMinScroll2 > $iMinScroll1 And $iMinScroll1 > 0 Then
					$iMinScroll = $iMinScroll1
				Else
					$iMinScroll = $iMinScroll2
				EndIf

				If $iMaxScroll2 > $iMinScroll1 Then
					$iMaxScroll = $iMaxScroll2
				Else
					$iMaxScroll = $iMaxScroll1
				EndIf

				If $z <> 2 Then
					$bAlreadyCheked = ($iMinScroll > 111) ? (False) : (True)
				EndIf

				For $i = 0 To UBound($aResourcesPicks) - 1
					$aResult[0] = $aResourcesPicks[$i][1]
					$aResult[1] = $aResourcesPicks[$i][2]
					$aResult[2] = $aResourcesPicks[$i][0]

					If $aResult[2] = "New" Then
						$g_bBuildingUpgraded = BBNewBuildings($aResult)
						If $g_bBuildingUpgraded Then
							SetLog("[" & $i + 1 & "]" & " New Building detected, placing it.", $COLOR_INFO)
							ExitLoop
						EndIf
					Else
						Click($aResult[0], $aResult[1], 1)
						If _Sleep(1000) Then Return

						$g_bBuildingUpgraded = GetUpgradeButton($aResult, $bDebug)
						If $g_bBuildingUpgraded Then
							SetLog("[" & $i + 1 & "]" & " Building detected, try upgrading it.", $COLOR_INFO)
							ExitLoop
						EndIf
					EndIf

					$vMultipix = _PixelSearch(443, 70, 444, 76, Hex(0xFFFFFF, 6), 35)
					If $vMultipix = 0 Then
						If ClickOnBuilder() = False Then
							SetLog("MainSuggestedUpgradeCode bad.", $COLOR_ERROR)
							ExitLoop
						EndIf
					EndIf

				Next

				If $g_bBuildingUpgraded Then
					Setlog("Exiting of improvements.", $COLOR_INFO)
					ExitLoop
				EndIf

				$aResourcesPicks = $aResourcesReset

				If $iMaxScroll > -1 And $iMinScroll > -1 Then
					Local $iFixY = Round(Abs($iMaxScroll - $iMinScroll) * 0.25)
					If _PixelSearch(443, 70, 444, 76, Hex(0xFFFFFF, 6), 35) <> 0 Then
						If $bAlreadyCheked = False Then
							ClickDrag(333, $iMaxScroll - $iFixY, 333, $iMinScroll + $iFixY, 1000)     ; Do scroll down.
						Else
							ExitLoop
							; ClickDrag(333, $iMinScroll + $iFixY, 333, $iMaxScroll - $iFixY, 1000)     ; Do scroll up.
						EndIf
					Else
						ClickOnBuilder()
						If _Sleep(1500) Then Return
						If _PixelSearch(443, 70, 444, 76, Hex(0xFFFFFF, 6), 35) = 0 Then
							SetLog("[MainSuggestedUpgradeCode] Wrong upgrades window", $COLOR_ERROR)
							ExitLoop
						EndIf
						If $bAlreadyCheked = False Then
							ClickDrag(333, $iMaxScroll - $iFixY, 333, $iMinScroll + $iFixY, 1000)     ; Do scroll down.
						Else
							ExitLoop
							; ClickDrag(333, $iMinScroll + $iFixY, 333, $iMaxScroll - $iFixY, 1000)     ; Do scroll up.
						EndIf
					EndIf
				Else
					ExitLoop
				EndIf
				
				If _Sleep(1500) Then Return
				If _PixelSearch(309, 79, 440, 103, Hex(0xD4FF80, 6), 25) = True Then ExitLoop
			Next

		EndIf
	EndIf

	ClickAway()

EndFunc   ;==>MainSuggestedUpgradeCode
#EndRegion - Bulder base upgrades - Team AIO Mod++

; This fucntion will Open the Suggested Window and check if is OK
Func ClickOnBuilder()

	; Debug Stuff
	Local $sDebugText = ""
	Local Const $Debug = False
	Local Const $Screencap = True

	getBuilderCount(True, True)

	; Master Builder is not available return
	If $g_iFreeBuilderCountBB = 0 Then SetLog("No Master Builder available! [" & $g_iFreeBuilderCountBB & "/" & $g_iTotalBuilderCountBB & "]", $COLOR_INFO)

	; Master Builder available
	If $g_iFreeBuilderCountBB > 0 Then
		; Check the Color and click
		If _CheckPixel($g_aMasterBuilder, True) Then
			; Click on Builder
			Click($g_aMasterBuilder[0], $g_aMasterBuilder[1], 1)
			If _Sleep(1500) Then Return
			; Let's verify if the Suggested Window open
			If _PixelSearch(443, 70, 444, 76, Hex(0xFFFFFF, 6), 35) <> 0 Then
				Return True
			Else
				$sDebugText = "Window didn't opened"
			EndIf
		Else
			$sDebugText = "BB Pixel problem"
		EndIf
	EndIf
	If $sDebugText <> "" Then SetLog("Problem on Suggested Upg Window: [" & $sDebugText & "]", $COLOR_ERROR)
	Return False
EndFunc   ;==>ClickOnBuilder

#Region - Bulder base upgrades - Team AIO Mod++
Func GetUpgradeButton($sUpgButtom = "", $bDebug = False)

	;Local $aBtnPos = [360, 500, 180, 50] ; x, y, w, h
	Local $aBtnPos = [360, 460, 740, 580] ; x, y, w, h ; support Battke Machine, broken and upgrade
	Local $aResetBB[3] = ["", "", ""]

	If $sUpgButtom = "" Then Return

	If $sUpgButtom = "Elixir" Then $sUpgButtom = $g_sImgAutoUpgradeBtnElixir
	If $sUpgButtom = "Gold" Then $sUpgButtom = $g_sImgAutoUpgradeBtnGold

	; Clean.
	$g_aBBUpgradeResourceCostDuration = $aResetBB
	$g_aBBUpgradeNameLevel = $aResetBB

	If _WaitForCheckImg($g_sImgAutoUpgradeBtnDir, "182, 500, 685, 883") Then
		If UBound($g_aImageSearchXML) > 0 And Not @error Then
			$g_aBBUpgradeNameLevel = BuildingInfo(245, 490 + $g_iBottomOffsetY)
			If $g_aBBUpgradeNameLevel[0] = 2 Then
				SetLog("Building: " & $g_aBBUpgradeNameLevel[1], $COLOR_INFO)

				; Verify if is to Upgrade
				Local $sMsg = "", $i = -1
				; Inspired in @xbebenk idea.
				If $g_bRadioBBCustomOTTO = True Then
					$i = _ArraySearchMaxStringDis($g_sBBOptimizeOTTO, $g_aBBUpgradeNameLevel[1], 1)
					If $i = -1 Then
						$sMsg = "Ops! Algorithm detection: none | Detection: " & $g_aBBUpgradeNameLevel[1] & " is not to Upgrade! (Optimize O.T.T.O.)"
						SetLog($sMsg, $COLOR_ERROR)

						$g_aBBUpgradeResourceCostDuration = $aResetBB
						$g_aBBUpgradeNameLevel = $aResetBB

						Return False
					Else
						$sMsg = "Optimize O.T.T.O. : " & $g_sBBOptimizeOTTO[$i] & " is for Upgrade."
						SetLog($sMsg, $COLOR_SUCCESS)
					EndIf
				Else
					$i = _ArraySearchMaxStringDis($g_sBBUpgradesToIgnore, $g_aBBUpgradeNameLevel[1], 1)
					If $i > -1 And $g_iChkBBUpgradesToIgnore[$i] = 1 Then
						$sMsg = "Ops! Algorithm: " & $g_sBBUpgradesToIgnore[$i] & " | Detection: " & $g_aBBUpgradeNameLevel[1] & " is not to Upgrade!"
						SetLog($sMsg, $COLOR_ERROR)

						$g_aBBUpgradeResourceCostDuration = $aResetBB
						$g_aBBUpgradeNameLevel = $aResetBB

						Return False
					Else
						$sMsg = $g_aBBUpgradeNameLevel[1] & " is for Upgrade."
						SetLog($sMsg, $COLOR_SUCCESS)
					EndIf
				EndIf
				Local $iyBtn = 501; 579 + $g_iBottomOffsetYFixed
				
				If _MultiPixelSearch($g_aImageSearchXML[0][1], $iyBtn, $g_aImageSearchXML[0][2] + 67, $iyBtn + 34, 2, 2, Hex(0xFF887F, 6), StringSplit2D("0xFF887F-0-1|0xFF887F-4-0"), 35) <> 0 Then
					SetLog("Upgrade stopped due to insufficient loot", $COLOR_ERROR)
					ClickAway()

					$g_aBBUpgradeResourceCostDuration = $aResetBB
					$g_aBBUpgradeNameLevel = $aResetBB

					Return False
				EndIf

				Click($g_aImageSearchXML[0][1], $g_aImageSearchXML[0][2], 1)
				If _Sleep(1500) Then Return

				If StringInStr($g_aBBUpgradeNameLevel[2], "Broken") = 0 Then
					$g_aBBUpgradeResourceCostDuration[0] = $sUpgButtom
					If StringInStr($g_aBBUpgradeNameLevel[1], "Machine") > 0 Then
						$g_aBBUpgradeResourceCostDuration[1] = getResourcesUpgrade(598, 509 + 44)
						$g_aBBUpgradeResourceCostDuration[2] = getHeroUpgradeTime(578, 450 + 44)
					Else
						$g_aBBUpgradeResourceCostDuration[1] = getResourcesUpgrade(366, 473 + 44)
						$g_aBBUpgradeResourceCostDuration[2] = getBldgUpgradeTime(190, 292 + 44)
					EndIf
				EndIf

				If QuickMIS("BC1", $sUpgButtom, $aBtnPos[0], $aBtnPos[1], $aBtnPos[2], $aBtnPos[3]) Then
					Click($g_iQuickMISX, $g_iQuickMISY, 1)
					If _Sleep(500) Then Return

					If isGemOpen(True) Then
						SetLog("Upgrade stopped due to insufficient loot", $COLOR_ERROR)
						ClickAway()
						If _Sleep(500) Then Return
						ClickAway()

						$g_aBBUpgradeResourceCostDuration = $aResetBB
						$g_aBBUpgradeNameLevel = $aResetBB

						Return False
					Else
						SetLog($g_aBBUpgradeNameLevel[1] & " Upgrading!", $COLOR_INFO)
						ClickAway()
						; $g_bBuildingUpgraded = True
						Return True
					EndIf
				Else
					Local $bHammerBuilding = WaitforPixel(352, 490, 511, 566, Hex(0x7C8AFF, 6), 30, 10)
					If $bHammerBuilding = True Then
						SetLog("Hammer Building Detected!", $COLOR_ERROR)
					Else
						; SetLog("Not enough Resources to Upgrade " & $g_aBBUpgradeNameLevel[1] & " !", $COLOR_ERROR)
						SetLog("Fail upgrade " & $g_aBBUpgradeNameLevel[1] & " !", $COLOR_ERROR)
					EndIf

					ClickAway()
					If _Sleep(250) Then Return
				EndIf

			EndIf
		EndIf
	Else
		Setlog("g_sImgAutoUpgradeBtnDir fail.", $COLOR_ERROR)
	EndIf

	$g_aBBUpgradeResourceCostDuration = $aResetBB
	$g_aBBUpgradeNameLevel = $aResetBB

	Return False
EndFunc   ;==>GetUpgradeButton

Func _ArraySearchMaxStringDis($aArray, $sItem, $iMaxDis = 1, $iEvery = 4)
	Local $iSting = 1
	For $i = 0 To UBound($aArray) - 1
		$iSting = Ceiling(_Max(StringLen($aArray[$i]), StringLen($sItem)) / $iEvery)
		If _LevDis($aArray[$i], $sItem) <= ($iMaxDis * $iSting) Then
			Return $i
		EndIf
	Next
	Return -1
EndFunc   ;==>_ArraySearchMaxStringDis
#EndRegion - Bulder base upgrades - Team AIO Mod++

Func BBNewBuildings($aResult)

	Local $Screencap = True, $Debug = False

	If UBound($aResult) = 3 And $aResult[2] = "New" Then

		Click($aResult[0], $aResult[1], 1)
		If _Sleep(1500) Then Return

		If _WaitForCheckImg(@ScriptDir & "\COCBot\Team__AiO__MOD++\Images\BuilderBase\Upgrade\New\", "14, 131, 847, 579", Default, 4500) Then ; Resolution changed
			Click($g_aImageSearchXML[0][1] - 100, $g_aImageSearchXML[0][2] + 100, 1)
			If _Sleep(2000) Then Return

			; Lets search for the Correct Symbol on field
			If QuickMIS("BC1", $g_sImgAutoUpgradeNewBldgYes, 150, 150 + $g_iMidOffsetYFixed, 650, 550 + $g_iBottomOffsetYFixed, $Screencap, $Debug) Then ; Resolution changed
				Click($g_iQuickMISX, $g_iQuickMISY, 1)
				SetLog("Placed a new Building on Builder Island! [" & $g_iQuickMISX & "," & $g_iQuickMISY & "]", $COLOR_INFO)
				If _Sleep(1000) Then Return

				; Lets check if exist the [x] , Some Buildings like Traps when you place one will give other to place automaticly!
				If QuickMIS("BC1", $g_sImgAutoUpgradeNewBldgNo, 150, 150 + $g_iMidOffsetYFixed, 650, 550 + $g_iBottomOffsetYFixed, $Screencap, $Debug) Then ; Resolution changed
					Click($g_iQuickMISX, $g_iQuickMISY, 1)
				EndIf

				Return True
			Else
				If QuickMIS("BC1", $g_sImgAutoUpgradeNewBldgNo, 150, 150 + $g_iMidOffsetYFixed, 650, 550 + $g_iBottomOffsetYFixed, $Screencap, $Debug) Then ; Resolution changed
					SetLog("Sorry! Wrong place to deploy a new building on BB! [" & $g_iQuickMISX & "," & $g_iQuickMISY & "]", $COLOR_ERROR)
					Click($g_iQuickMISX, $g_iQuickMISY, 1)
				Else
					SetLog("Error on Undo symbol!", $COLOR_ERROR)
				EndIf
			EndIf
		Else
			SetLog("Fail BBNewBuildings.", $COLOR_INFO)
			Click(820, 38, 1) ; exit from Shop
		EndIf

	EndIf

	Return False

EndFunc   ;==>BBNewBuildings

