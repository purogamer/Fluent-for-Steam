; #FUNCTION# ====================================================================================================================
; Name ..........: UpgradeWall
; Description ...: This file checks if enough resources to upgrade walls, and upgrades them
; Syntax ........: UpgradeWall()
; Parameters ....:
; Return values .: None
; Author ........: ProMac (2015), HungLe (2015), Team AIO Mod++ (2022)
; Modified ......: Sardo (08-2015), KnowJack (08-2015), MonkeyHunter(06-2016) , trlopes (07-2016)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2021
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......: checkwall.au3
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func UpgradeWall()

	Local $iWallCost = Int($g_iWallCost - ($g_iWallCost * Number($g_iBuilderBoostDiscount) / 100))

	If Not $g_bRunState Then Return

	If $g_bAutoUpgradeWallsEnable = True Then
		SetLog("Checking Upgrade Walls", $COLOR_INFO)
		SetDebugLog("$iWallCost:" & $iWallCost)
		If SkipWallUpgrade($iWallCost) Then Return
		SetDebugLog("$g_iFreeBuilderCount:" & $g_iFreeBuilderCount)
		If $g_iFreeBuilderCount > 0 Then
			
			Local $bDisableElixir = False
			If $g_bChkWallsPriorities Then
				If $g_bupgradewardenenable And BitAnd($g_iheroupgradingbit, $eHeroWarden) <> $eHeroWarden And $g_ifreebuildercount > 1 And $g_iUpgradeWallLootType = 1 Then
					SetLog("Lets use elixir for Warden upgrades!", $COLOR_INFO)
					Return
				ElseIf $g_bupgradewardenenable And BitAnd($g_iheroupgradingbit, $eHeroWarden) <> $eHeroWarden And $g_ifreebuildercount > 1 And $g_iUpgradeWallLootType = 2 Then
					SetLog("Lets use elixir for Warden upgrades, skip upgrade walls with elixir.", $COLOR_INFO)
					$bDisableElixir = True
				EndIf
			
				If $g_ifreebuildercount > ($g_bupgradewallsavebuilder ? 1 : 0) + Int(ReservedBuildersForHeroes()) Then
					SetLog("Lets use Resources for next Building Upgrades!", $COLOR_INFO)
					Return 
				EndIf
			EndIf
			
			ClickAway()
			Local $MinWallGold = Number($g_aiCurrentLoot[$eLootGold] - $iWallCost) > Number($g_iUpgradeWallMinGold) ; Check if enough Gold
			Local $MinWallElixir = ($bDisableElixir = False) ? (Number($g_aiCurrentLoot[$eLootElixir] - $iWallCost) > Number($g_iUpgradeWallMinElixir)) : (False) ; Check if enough Elixir

			SetDebugLog("$g_iUpgradeWallLootType" & $g_iUpgradeWallLootType)
			SetDebugLog("$MinWallGold" & $MinWallGold)
			SetDebugLog("$MinWallElixir" & $MinWallElixir)

			While ($g_iUpgradeWallLootType = 0 And $MinWallGold) Or ($g_iUpgradeWallLootType = 1 And $MinWallElixir) Or ($g_iUpgradeWallLootType = 2 And ($MinWallGold Or $MinWallElixir))

				Switch $g_iUpgradeWallLootType
					Case 0
						If $MinWallGold Then
							SetLog("Upgrading Wall using Gold", $COLOR_SUCCESS)
							If imglocCheckWall() Then
								If Not UpgradeWallGold($iWallCost) Then
									SetLog("Upgrade with Gold failed, skipping...", $COLOR_ERROR)
									Return
								EndIf
							ElseIf SwitchToNextWallLevel() Then
								SetLog("No more walls of current level, switching to next", $COLOR_ACTION)
							Else
								Return
							EndIf
						Else
							SetLog("Gold is below minimum, Skipping Upgrade", $COLOR_ERROR)
						EndIf
					Case 1
						If $MinWallElixir Then
							SetLog("Upgrading Wall using Elixir", $COLOR_SUCCESS)
							If imglocCheckWall() Then
								If Not UpgradeWallElixir($iWallCost) Then
									SetLog("Upgrade with Elixier failed, skipping...", $COLOR_ERROR)
									Return
								EndIf
							ElseIf SwitchToNextWallLevel() Then
								SetLog("No more walls of current level, switching to next", $COLOR_ACTION)
							Else
								Return
							EndIf
						Else
							SetLog("Elixir is below minimum, Skipping Upgrade", $COLOR_ERROR)
						EndIf
					Case 2
						If $MinWallElixir Then
							SetLog("Upgrading Wall using Elixir", $COLOR_SUCCESS)
							If imglocCheckWall() Then
								If Not UpgradeWallElixir($iWallCost) Then
									SetLog("Upgrade with Elixir failed, attempt to upgrade using Gold", $COLOR_ERROR)
									If Not UpgradeWallGold($iWallCost) Then
										SetLog("Upgrade with Gold failed, skipping...", $COLOR_ERROR)
										Return
									EndIf
								EndIf
							ElseIf SwitchToNextWallLevel() Then
								SetLog("No more walls of current level, switching to next", $COLOR_ACTION)
							Else
								Return
							EndIf
						Else
							SetLog("Elixir is below minimum, attempt to upgrade using Gold", $COLOR_ERROR)
							If $MinWallGold Then
								If imglocCheckWall() Then
									If Not UpgradeWallGold($iWallCost) Then
										SetLog("Upgrade with Gold failed, skipping...", $COLOR_ERROR)
										Return
									EndIf
								ElseIf SwitchToNextWallLevel() Then
									SetLog("No more walls of current level, switching to next", $COLOR_ACTION)
								Else
									Return
								EndIf
							Else
								SetLog("Gold is below minimum, Skipping Upgrade", $COLOR_ERROR)
							EndIf
						EndIf
				EndSwitch

				; Check Builder/Shop if open by accident
				If _CheckPixel($g_aShopWindowOpen, $g_bCapturePixel, Default, "ChkShopOpen", $COLOR_DEBUG) = True Then
					Click(820, 40, 1, 0, "#0315") ; Close it
				EndIf

				ClickAway()
				VillageReport(True, True)
				If SkipWallUpgrade($iWallCost) Then Return
				$MinWallGold = Number($g_aiCurrentLoot[$eLootGold] - $iWallCost) > Number($g_iUpgradeWallMinGold) ; Check if enough Gold
				$MinWallElixir = Number($g_aiCurrentLoot[$eLootElixir] - $iWallCost) > Number($g_iUpgradeWallMinElixir) ; Check if enough Elixir

			WEnd
		Else
			SetLog("No free builder, Upgrade Walls skipped..", $COLOR_ERROR)
		EndIf
	EndIf
	If _Sleep($DELAYUPGRADEWALL1) Then Return
	checkMainScreen(False) ; Check for errors during function

EndFunc   ;==>UpgradeWall


Func UpgradeWallGold($iWallCost = $g_iWallCost)

	If _Sleep($DELAYRESPOND) Then Return

	Local $aUpgradeButton = findButton("Upgrade", Default, 2, True)
	If IsArray($aUpgradeButton) And UBound($aUpgradeButton) > 0 Then
		For $i = 0 To UBound($aUpgradeButton) - 1  ; Check for elixircolor in right top button corner and click, if present
			If WaitforPixel($aUpgradeButton[$i][0] + 25, 595 + $g_iBottomOffsetYFixed, $aUpgradeButton[$i][0] + 67, 605 + $g_iBottomOffsetYFixed, Hex(0xFFE41D, 6), 25, 1) = True Then ; Fixed resolution
				Click($aUpgradeButton[$i][0], $aUpgradeButton[$i][1])
				
				If _Sleep($DELAYUPGRADEWALLGOLD2) Then Return
			
				If _ColorCheck(_GetPixelColor(677, 150 + $g_iMidOffsetY, True), Hex(0xE1090E, 6), 20) Then ; wall upgrade window red x
					If isNoUpgradeLoot(False) = True Then
						SetLog("Upgrade stopped due no loot", $COLOR_ERROR)
						Return False
					EndIf
					Click(440, 480 + $g_iMidOffsetY, 1, 0, "#0317")
					If _Sleep(1000) Then Return
					If isGemOpen(True) Then
						ClickAway()
						SetLog("Upgrade stopped due no loot", $COLOR_ERROR)
						Return False
					ElseIf _ColorCheck(_GetPixelColor(677, 150 + $g_iMidOffsetY, True), Hex(0xE1090E, 6), 20) Then ; wall upgrade window red x, didnt closed on upgradeclick, so not able to upgrade
						ClickAway()
						SetLog("unable to upgrade", $COLOR_ERROR)
						Return False
					Else
						If _Sleep($DELAYUPGRADEWALLGOLD3) Then Return
						ClickAway()
						SetLog("Upgrade complete", $COLOR_SUCCESS)
						PushMsg("UpgradeWithGold")
						$g_iNbrOfWallsUppedGold += 1
						$g_iNbrOfWallsUpped += 1
						$g_iCostGoldWall += $iWallCost
						UpdateStats()
						Return True
					EndIf
				EndIf

				ExitLoop
			EndIf
		Next
	EndIf
	
	ClickAway()
	SetLog("No Upgrade Gold Button", $COLOR_ERROR)
	Pushmsg("NowUpgradeGoldButton")
	Return False

EndFunc   ;==>UpgradeWallGold

Func UpgradeWallElixir($iWallCost)

	If _Sleep($DELAYRESPOND) Then Return

	Local $aUpgradeButton = findButton("Upgrade", Default, 2, True)
	If IsArray($aUpgradeButton) And UBound($aUpgradeButton) > 0 Then
		For $i = UBound($aUpgradeButton) - 1 To 0 Step -1 ; Check for elixircolor in right top button corner and click, if present
			If WaitforPixel($aUpgradeButton[$i][0] + 25, 595 + $g_iBottomOffsetYFixed, $aUpgradeButton[$i][0] + 67, 605 + $g_iBottomOffsetYFixed, Hex(0xF032FF, 6), 25, 1) = True Then ; Fixed resolution
				Click($aUpgradeButton[$i][0], $aUpgradeButton[$i][1])
				
				If _Sleep($DELAYUPGRADEWALLELIXIR2) Then Return

				If _ColorCheck(_GetPixelColor(677, 150 + $g_iMidOffsetY, True), Hex(0xE1090E, 6), 20) Then
					If isNoUpgradeLoot(False) = True Then
						SetLog("Upgrade stopped due to insufficient loot", $COLOR_ERROR)
						Return False
					EndIf
					Click(440, 480 + $g_iMidOffsetY, 1, 0, "#0318")
					If _Sleep(1000) Then Return
					If isGemOpen(True) Then
						ClickAway()
						SetLog("Upgrade stopped due to insufficient loot", $COLOR_ERROR)
						Return False
					ElseIf _ColorCheck(_GetPixelColor(677, 150 + $g_iMidOffsetY, True), Hex(0xE1090E, 6), 20) Then ; wall upgrade window red x, didnt closed on upgradeclick, so not able to upgrade
						ClickAway()
						SetLog("unable to upgrade", $COLOR_ERROR)
						Return False
					Else
						If _Sleep($DELAYUPGRADEWALLELIXIR3) Then Return
						ClickAway()
						SetLog("Upgrade complete", $COLOR_SUCCESS)
						PushMsg("UpgradeWithElixir")
						$g_iNbrOfWallsUppedElixir += 1
						$g_iNbrOfWallsUpped += 1
						$g_iCostElixirWall += $iWallCost
						UpdateStats()
						Return True
					EndIf
				EndIf
				
				ExitLoop
			EndIf
		Next
	EndIf

	ClickAway()
	SetLog("No Upgrade Elixir Button", $COLOR_ERROR)
	Pushmsg("NowUpgradeElixirButton")
	Return False

EndFunc   ;==>UpgradeWallElixir

Func SkipWallUpgrade($iWallCost = $g_iWallCost) ; Dynamic Upgrades

	IniReadS($g_iUpgradeWallLootType, $g_sProfileConfigPath, "upgrade", "use-storage", "0") ; Reset Variable to User Selection

	Local $iUpgradeAction = 0
	Local $iBuildingsNeedGold = 0
	Local $iBuildingsNeedElixir = 0
	Local $iAvailBuilderCount = 0

	SetDebugLog("In SkipWallUpgrade")
	SetDebugLog("$g_iTownHallLevel = " & $g_iTownHallLevel)

	Switch $g_iTownHallLevel
		Case 5 To 8 ;Start at Townhall 5 because any Wall Level below 4 is not supported anyways
			SetDebugLog("Case 5 to 8")
			If $g_iTownHallLevel < $g_iCmbUpgradeWallsLevel + 4 Then
				SetLog("Skip Wall upgrade -insufficient TH-Level", $COLOR_WARNING)
				Return True
			EndIf
		Case 9 To $g_iMaxTHLevel
			SetDebugLog("Case 9 to Max")
			If $g_iTownHallLevel < $g_iCmbUpgradeWallsLevel + 3 Then
				SetLog("Skip Wall upgrade -insufficient TH-Level", $COLOR_WARNING)
				Return True
			EndIf
		Case Else
			SetDebugLog("Else case returning True")
			Return True
	EndSwitch

	If Not getBuilderCount() Then Return True ; update builder data, return true to skip if problem
	If _Sleep($DELAYRESPOND) Then Return True

	$iAvailBuilderCount = $g_iFreeBuilderCount ; capture local copy of free builders

	;;;;; Check building upgrade resouce needs .vs. available resources for walls
	For $iz = 0 To UBound($g_avBuildingUpgrades, 1) - 1 ; loop through all upgrades to see if any are enabled.
		If $g_abBuildingUpgradeEnable[$iz] = True Then $iUpgradeAction += 1 ; count number enabled
	Next

	If $g_iFreeBuilderCount > ($g_bUpgradeWallSaveBuilder ? 1 : 0) And $iUpgradeAction > 0 Then ; check if builder available for bldg upgrade, and upgrades enabled
		For $iz = 0 To UBound($g_avBuildingUpgrades, 1) - 1
			; internal check if builder still available, if loop index upgrade slot is enabled, and if upgrade is not in progress
			If $iAvailBuilderCount > ($g_bUpgradeWallSaveBuilder ? 1 : 0) And $g_abBuildingUpgradeEnable[$iz] = True And $g_avBuildingUpgrades[$iz][7] = "" Then
				Switch $g_avBuildingUpgrades[$iz][3]
					Case "Gold"
						$iBuildingsNeedGold += Number($g_avBuildingUpgrades[$iz][2]) ; sum gold required for enabled upgrade
						$iAvailBuilderCount -= 1 ; subtract builder from free count, as only need to save gold for upgrades where builder is available
					Case "Elixir"
						$iBuildingsNeedElixir += Number($g_avBuildingUpgrades[$iz][2]) ; sum elixir required for enabled upgrade
						$iAvailBuilderCount -= 1 ; subtract builder from free count, as only need to save elixir for upgrades where builder is available
				EndSwitch
			EndIf
		Next
		SetLog("SkipWall-Upgrade Summary: G:" & $iBuildingsNeedGold & ", E:" & $iBuildingsNeedElixir & ", Wall: " & $iWallCost & ", MinG: " & $g_iUpgradeWallMinGold & ", MinE: " & $g_iUpgradeWallMinElixir) ; debug
		If $iBuildingsNeedGold > 0 Or $iBuildingsNeedElixir > 0 Then ; if upgrade enabled and building upgrade resource is required, log user messages.
			Switch $g_iUpgradeWallLootType
				Case 0 ; Using gold
					If $g_aiCurrentLoot[$eLootGold] - ($iBuildingsNeedGold + $iWallCost + Number($g_iUpgradeWallMinGold)) < 0 Then
						SetLog("Skip Wall upgrade -insufficient gold for selected upgrades", $COLOR_WARNING)
						Return True
					EndIf
				Case 1 ; Using elixir
					If $g_aiCurrentLoot[$eLootElixir] - ($iBuildingsNeedElixir + $iWallCost + Number($g_iUpgradeWallMinElixir)) < 0 Then
						SetLog("Skip Wall upgrade - insufficient elixir for selected upgrades", $COLOR_WARNING)
						Return True
					EndIf
				Case 2 ; Using gold and elixir
					If $g_aiCurrentLoot[$eLootGold] - ($iBuildingsNeedGold + $iWallCost + Number($g_iUpgradeWallMinGold)) < 0 Then
						SetLog("Wall upgrade: insufficient gold for selected upgrades", $COLOR_WARNING)
						If $g_aiCurrentLoot[$eLootElixir] - ($iBuildingsNeedElixir + $iWallCost + Number($g_iUpgradeWallMinElixir)) >= 0 Then
							SetLog("Using Elixir only for wall Upgrade", $COLOR_SUCCESS1)
							$g_iUpgradeWallLootType = 1
						Else
							SetLog("Skip Wall upgrade -insufficient resources for selected upgrades", $COLOR_WARNING)
							Return True
						EndIf
					EndIf
					If $g_aiCurrentLoot[$eLootElixir] - ($iBuildingsNeedElixir + $iWallCost + Number($g_iUpgradeWallMinElixir)) < 0 Then
						SetLog("Wall upgrade: insufficient elixir for selected upgrades", $COLOR_WARNING)
						If $g_aiCurrentLoot[$eLootGold] - ($iBuildingsNeedGold + $iWallCost + Number($g_iUpgradeWallMinGold)) >= 0 Then
							SetLog("Using Gold only for Wall Upgrade", $COLOR_SUCCESS1)
							$g_iUpgradeWallLootType = 0
						Else
							SetLog("Skip Wall upgrade -insufficient resources for selected upgrades", $COLOR_WARNING)
							Return True
						EndIf
					EndIf
			EndSwitch
		EndIf
		If _Sleep($DELAYRESPOND) Then Return True
	EndIf
	;;;;;;;;;;;;;;;;;;;;;;;;;;;End bldg upgrade value checking


	;   Is Warden Level updated |          Is Warden not max yet           |  Is Upgrade enabled       |               Is Warden not already upgrading                |               Is a Builder available
	If ($g_iWardenLevel <> -1) And ($g_iWardenLevel < $g_iMaxWardenLevel) And $g_bUpgradeWardenEnable And BitAND($g_iHeroUpgradingBit, $eHeroWarden) <> $eHeroWarden And ($g_iFreeBuilderCount > ($g_bUpgradeWallSaveBuilder ? 1 : 0)) Then
		Local $bMinWardenElixir = Number($g_aiCurrentLoot[$eLootElixir]) > ($iWallCost + $g_afWardenUpgCost[$g_iWardenLevel] * 1000000 + Number($g_iUpgradeWallMinElixir))
		If Not $bMinWardenElixir Then
			Switch $g_iUpgradeWallLootType
				Case 1 ; Elixir
					SetLog("Grand Warden needs " & ($g_afWardenUpgCost[$g_iWardenLevel] * 1000000) & " Elixir for next Level", $COLOR_WARNING)
					SetLog("Skipping Wall Upgrade", $COLOR_WARNING)
					Return True
				Case 2 ; Elixir & Gold
					SetLog("Grand Warden needs " & ($g_afWardenUpgCost[$g_iWardenLevel] * 1000000) & " Elixir for next Level", $COLOR_SUCCESS1)
					SetLog("Using Gold only for Wall Upgrade", $COLOR_SUCCESS1)
					$g_iUpgradeWallLootType = 0
			EndSwitch
		EndIf
	EndIf


	;;;;;;;;;;;;;;;;;;;;;;;;;;;##### Verify the Upgrade troop kind in Laboratory , if is elixir Spell/Troop , the Lab have priority #####;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	Local $bMinWallElixir = Number($g_aiCurrentLoot[$eLootElixir]) > ($iWallCost + Number($g_iLaboratoryElixirCost) + Number($g_iUpgradeWallMinElixir)) ; Check if enough Elixir
	If $g_bAutoLabUpgradeEnable And $g_iLaboratoryElixirCost > 0 And Not $bMinWallElixir Then
		Switch $g_iUpgradeWallLootType
			Case 0 ; Using gold
				; do nothing
			Case 1 ; Using elixir
				SetLog("Laboratory needs Elixir to Upgrade :  " & $g_iLaboratoryElixirCost, $COLOR_SUCCESS1)
				SetLog("Skipping Wall Upgrade", $COLOR_SUCCESS1)
				Return True
			Case 2 ; Using gold and elixir
				SetLog("Laboratory needs Elixir to Upgrade :  " & $g_iLaboratoryElixirCost, $COLOR_SUCCESS1)
				SetLog("Using Gold only for Wall Upgrade", $COLOR_SUCCESS1)
				$g_iUpgradeWallLootType = 0
		EndSwitch
	EndIf

	Return False

EndFunc   ;==>SkipWallUpgrade

Func SwitchToNextWallLevel() ; switches wall level to upgrade to next level
	If $g_aiWallsCurrentCount[$g_iCmbUpgradeWallsLevel + 4] = 0 And $g_iCmbUpgradeWallsLevel < 9 Then
		SetDebugLog("$g_aiWallsCurrentCount = " & $g_aiWallsCurrentCount)
		SetDebugLog("$g_iCmbUpgradeWallsLevel = " & $g_iCmbUpgradeWallsLevel)

		EnableGuiControls()
		_GUICtrlComboBox_SetCurSel($g_hCmbWalls, $g_iCmbUpgradeWallsLevel + 1)
		cmbWalls()
		If $g_iCmbUpgradeWallsLevel = 4 Then
			GUICtrlSetState($g_hRdoUseElixirGold, $GUI_CHECKED)
			GUICtrlSetData($g_hTxtWallMinElixir, GUICtrlRead($g_hTxtWallMinGold))
		EndIf
		SaveConfig()
		DisableGuiControls()
		Return True
	EndIf
	Return False
EndFunc   ;==>SwitchToNextWallLevel

				#cs
			Else
				Local $iXClickOffset = 0, $iYClickOffset = 0
				
				Local $iLevelMaxWall = ($g_iCmbUpgradeWallsLevel + 4)
				If $g_bAutomaticLevel = True And $g_iTownHallLevel > 0 Then
					$iLevelMaxWall = $g_iTownHallLevel
					$iLevelMaxWall -= 2
					If $g_iTownHallLevel > 1 Then
						$iLevelMaxWall += 1 
					EndIf
					If $g_iTownHallLevel > 8 Then
						$iLevelMaxWall += 1 
					EndIf
					SetLog("Auto wall lvl: " & $iLevelMaxWall, $COLOR_WARNING)
				ElseIf $g_iTownHallLevel > 0 Then
					SetLog("Please locate townhall for auto wall lvl", $COLOR_WARNING)
				EndIf
				Local $iLastGoodWallX = $g_aiLastGoodWallPos[0]
				Local $iLastGoodWallY = $g_aiLastGoodWallPos[1]
				; ConvertToVillagePos($iLastGoodWallX, $iLastGoodWallY) Unestable
				Local $iSkipMax = -1, $iSkipMin = -1
				Local $aResult = _ImageSearchXML($g_sImgCheckWallDir, 500, $CocDiamondECD, True, False, True, 4, 0, $iLevelMaxWall)
				If UBound($aResult) > 0 And Not @error Then
					For $i = 0 To UBound($aResult) - 1
						Switch $aResult[$i][3]
							Case 10
								$iXClickOffset = 2
								$iYClickOffset = 2
							Case 11
								$iXClickOffset = 1
								$iYClickOffset = -2
						EndSwitch
						$aResult[$i][1] += $iXClickOffset
						$aResult[$i][2] += $iYClickOffset
						$aResult[$i][0] = Pixel_Distance($iLastGoodWallX, $iLastGoodWallY, $aResult[$i][1], $aResult[$i][2])
						
					Next
					
					VillageReportMini() ; Hasnt clickaway

					_ArraySort($aResult, 0, 0, 0, 0)
					Local $aCoord[2]
					SetLog("Calculating walls, wait.", $COLOR_INFO)
					Local $iWallLvl
					For $i = 0 To UBound($aResult) - 1
						$iWallLvl = Int($aResult[$i][3])
						
						; More hard than crime theory
						$g_iWallCost = $g_aiWallCost[$iWallLvl - 4]
						$iWallCost = Int($g_iWallCost - ($g_iWallCost * Number($g_iBuilderBoostDiscount) / 100))
						$MinWallGold = Number($g_aiCurrentLoot[$eLootGold] - $iWallCost) > Number($g_iUpgradeWallMinGold) ; Check if enough Gold
						$MinWallElixir = Number($g_aiCurrentLoot[$eLootElixir] - $iWallCost) > Number($g_iUpgradeWallMinElixir) ; Check if enough Elixir
						
						Select
							Case ($g_iUpgradeWallLootType = 0 And $MinWallGold)
							Case $iWallLvl > 7
								Select
									Case ($g_iUpgradeWallLootType = 1 And $MinWallElixir)
									Case ($g_iUpgradeWallLootType = 2 And ($MinWallGold Or $MinWallElixir))
										If $MinWallElixir Then
										ElseIf $MinWallGold Then
										Else
											ContinueLoop
										EndIf
									Case Else
										ContinueLoop
								EndSelect
							Case Else
								ContinueLoop
						EndSelect			
						
						If Not IsMainPage(1) Then ExitLoop
						
						$aCoord[0] = $aResult[$i][1]
						$aCoord[1] = $aResult[$i][2]
						
						GemClick($aCoord[0], $aCoord[1])
						If _Sleep(2000) Then Return
						
						Local $aOcrResult = BuildingInfo(245, 490 + $g_iBottomOffsetY) ; Get building name and level with OCR
						If $aOcrResult[0] = 2 Then ; We found a valid building name
							If StringInStr($aOcrResult[1], "wall") = True And Number($aOcrResult[2]) <= $g_iCmbUpgradeWallsLevel + 4 Then ; we found a wall
								If $iWallLvl <> Number($aOcrResult[2]) Then ContinueLoop
								
								SetLog("Position : " & $aCoord[0] & ", " & $aCoord[1] & " is a Wall Level: " & $aOcrResult[2] & ".")
								$g_aiLastGoodWallPos[0] = $aCoord[0]
								$g_aiLastGoodWallPos[1] = $aCoord[1]

								If UBound($g_aiWallCost) - 1 >= Int($aOcrResult[2] - 4) Then

									$g_iWallCost = $g_aiWallCost[$aOcrResult[2] - 4]
									$iWallCost = Int($g_iWallCost - ($g_iWallCost * Number($g_iBuilderBoostDiscount) / 100))

									VillageReportMini() ; Hasnt clickaway

									If SkipWallUpgrade($iWallCost) Then
										SetLog("Skipped wall")
										Return
									EndIf

									$MinWallGold = Number($g_aiCurrentLoot[$eLootGold] - $iWallCost) > Number($g_iUpgradeWallMinGold) ; Check if enough Gold
									$MinWallElixir = Number($g_aiCurrentLoot[$eLootElixir] - $iWallCost) > Number($g_iUpgradeWallMinElixir) ; Check if enough Elixir
									Select
										Case ($g_iUpgradeWallLootType = 0 And $MinWallGold)
											If Not UpgradeWallGold($iWallCost) Then
												SetLog("Upgrade with gold failed, skipping.", $COLOR_ERROR)
												Return
											EndIf
										Case $aOcrResult[2] > 7
											Select
												Case ($g_iUpgradeWallLootType = 1 And $MinWallElixir)
													If Not UpgradeWallElixir($iWallCost) Then
														SetLog("Upgrade with elixir failed, skipping.", $COLOR_ERROR)
														Return
													EndIf
												Case ($g_iUpgradeWallLootType = 2 And ($MinWallGold Or $MinWallElixir))
													If $MinWallElixir Then
														If Not UpgradeWallElixir($iWallCost) Then
															SetLog("Upgrade with elixir failed, skipping.", $COLOR_ERROR)
															Return
														EndIf
													Else
														If Not UpgradeWallGold($iWallCost) Then
															SetLog("Upgrade with gold failed, skipping.", $COLOR_ERROR)
															Return
														EndIf
													EndIf
											EndSelect
									EndSelect
									
									If _Sleep(500) Then Return
								Else
									ClickAway()
								EndIf
							Else
								ClickAway()
							EndIf
						EndIf
						
						; Check Builder/Shop if open by accident
						If _CheckPixel($g_aShopWindowOpen, $g_bCapturePixel, Default, "ChkShopOpen", $COLOR_DEBUG) = True Then
							Click(820, 40, 1, 0, "#0315") ; Close it
						EndIf
					Next
					
				EndIf
			EndIf

; Custom wall - Team AIO Mod++
Func VillageReportMini()
	getBuilderCount(True) ; update builder data
	; $g_aiCurrentLoot[$eLootTrophy] = getTrophyMainScreen($aTrophies[0], $aTrophies[1])
	If _CheckPixel($aVillageHasDarkElixir, $g_bCapturePixel) Then ; check if the village have a Dark Elixir Storage
		$g_aiCurrentLoot[$eLootGold] = getResourcesMainScreen(696, 23)
		$g_aiCurrentLoot[$eLootElixir] = getResourcesMainScreen(696, 74)
		$g_aiCurrentLoot[$eLootDarkElixir] = getResourcesMainScreen(728, 123)
		; $g_iGemAmount = getResourcesMainScreen(740, 171)
	Else
		$g_aiCurrentLoot[$eLootGold] = getResourcesMainScreen(701, 23)
		$g_aiCurrentLoot[$eLootElixir] = getResourcesMainScreen(701, 74)
		; $g_iGemAmount = getResourcesMainScreen(719, 123)
		If ProfileSwitchAccountEnabled() Then $g_aiCurrentLoot[$eLootDarkElixir] = "" ; prevent applying Dark Elixir of previous account to current account
	EndIf
EndFunc   ;==>VillageReportMini
			#ce
