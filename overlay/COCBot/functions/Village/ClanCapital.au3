#include-once
Func CollectCCGold($bTest = False)
	If Not $g_bChkEnableCollectCCGold Then Return
	SetLog("Start Collecting Clan Capital Gold", $COLOR_INFO)
	ClickAway()
	ZoomOut() ;ZoomOut first
	If QuickMIS("BC1", $g_sImgCCGoldCollect, 250, 550, 400, 730) Then
		Click($g_iQuickMISX, $g_iQuickMISY + 20)
		For $i = 1 To 5
			SetDebugLog("Waiting for Forge Window #" & $i, $COLOR_ACTION)
			If QuickMIS("BC1", $g_sImgGeneralCloseButton, 710, 150, 760, 230) Then
				ExitLoop
			EndIf
			_Sleep(500)
		Next
		Local $aCollect = 0
		If QuickMIS("BC1", $g_sImgCCGoldCollect, 120, 340, 250, 450) Then
			If Not $bTest Then 
				Click($g_iQuickMISX, $g_iQuickMISY + 10) ;Click Collect
				$aCollect = 1
			Else
				SetLog("Test Only, Should Click on [" & $aCollect[$i][1] & "," & $aCollect[$i][2] & "]")
			EndIf
			_Sleep(500)
		EndIf
		ClickDrag(720, 315, 600, 315)
		_Sleep(Random(500, 1000, 1))
		Local $aCollectXtended = QuickMIS("CNX", $g_sImgCCGoldCollect, 120, 340, 740, 450)
		If IsArray($aCollectXtended) And UBound($aCollectXtended) > 0 Then
			For $i = 0 To UBound($aCollectXtended) - 1
				If Not $bTest Then 
					Click($aCollectXtended[$i][1], $aCollectXtended[$i][2]) ;Click Collect
				Else
					SetLog("Test Only, Should Click on [" & $aCollect[$i][1] & "," & $aCollect[$i][2] & "]")
				EndIf
				_Sleep(500)
			Next
		EndIf
		Local $CollectedCCGold = ($aCollect + UBound($aCollectXtended))
		SetLog("Collecting " & $CollectedCCGold & " Clan Capital Gold", $COLOR_INFO)
		_Sleep(800)
		If QuickMIS("BC1", $g_sImgGeneralCloseButton, 710, 180, 760, 225) Then
			Click($g_iQuickMISX, $g_iQuickMISY) ;Click close button
		EndIf
		SetLog("Clan Capital Gold collected successfully!", $COLOR_SUCCESS)
	Else
		SetLog("No available Clan Capital Gold to be collected!", $COLOR_INFO)
		Return
	EndIf
	If _Sleep($DELAYCOLLECT3) Then Return
EndFunc

Func ClanCapitalReport()
	$g_iLootCCGold = getOcrAndCapture("coc-ms", 670, 17, 160, 25)
	$g_iLootCCMedal = getOcrAndCapture("coc-ms", 670, 70, 160, 25)
	GUICtrlSetData($g_lblCapitalGold, $g_iLootCCGold)
	GUICtrlSetData($g_lblCapitalMedal, $g_iLootCCMedal)
EndFunc

Func OpenForgeWindow()
	Local $bRet = False
	If QuickMIS("BC1", $g_sImgForgeHouse, 200, 570, 400, 730) Then 
		Click($g_iQuickMISX + 10, $g_iQuickMISY + 10)
		For $i = 1 To 5
			SetDebugLog("Waiting for Forge Window #" & $i, $COLOR_ACTION)
			If QuickMis("BC1", $g_sImgGeneralCloseButton, 710, 170, 760, 230) Then
				$bRet = True
				ExitLoop
			EndIf
			_Sleep(600)
		Next
	EndIf
	Return $bRet
EndFunc

Func WaitStartCraftWindow()
	Local $bRet = False
	For $i = 1 To 5
		SetDebugLog("Waiting for StartCraft Window #" & $i, $COLOR_ACTION)
		If QuickMis("BC1", $g_sImgGeneralCloseButton, 620, 180, 670, 260) Then
			$bRet = True
			ExitLoop
		EndIf
		_Sleep(600)
	Next
	If Not $bRet Then SetLog("StartCraft Window does not open", $COLOR_ERROR)
	Return $bRet
EndFunc

Func RemoveDupCNX(ByRef $arr, $sortBy = 1, $distance = 10)
	Local $atmparray[0][4]
	Local $tmpCoord = 0
	_ArraySort($arr, 0, 0, 0, $sortBy) ;sort by 1 = , 2 = y
	For $i = 0 To UBound($arr) - 1
		SetDebugLog("SortBy:" & $arr[$i][$sortBy])
		SetDebugLog("tmpCoord:" & $tmpCoord)
		If $arr[$i][$sortBy] >= $tmpCoord + $distance Then 
			_ArrayAdd($atmparray, $arr[$i][0] & "|" & $arr[$i][1] & "|" & $arr[$i][2] & "|" & $arr[$i][3])
			$tmpCoord = $arr[$i][$sortBy] + $distance
		Else
			SetDebugLog("Skip this dup: " & $arr[$i][$sortBy] & " is near " & $tmpCoord, $COLOR_INFO)
			ContinueLoop
		EndIf		
	Next
	$arr = $atmparray
	SetDebugLog(_ArrayToString($arr))
EndFunc

Func ForgeClanCapitalGold($bTest = False)
	ClickAway()
	ZoomOut()
	Local $aForgeType[5] = [$g_bChkEnableForgeGold, $g_bChkEnableForgeElix, $g_bChkEnableForgeDE, $g_bChkEnableForgeBBGold, $g_bChkEnableForgeBBElix]
	Local $bForgeEnabled = False
	Local $iBuilderToUse = $g_iCmbForgeBuilder + 1
	For $i In $aForgeType ;check for every option enabled
		If $i = True Then 
			$bForgeEnabled = True
			ExitLoop
		EndIf
	Next
	If Not $bForgeEnabled Then Return
	If Not $g_bRunState Then Return
	SetLog("Checking for Forge ClanCapital Gold", $COLOR_INFO)
	
	getBuilderCount(True) ;check if we have available builder
	If $bTest Then $g_iFreeBuilderCount = 1
	Local $iWallReserve = $g_bUpgradeWallSaveBuilder ? 1 : 0
	If $g_iFreeBuilderCount - $iWallReserve - ReservedBuildersForHeroes() < 1 Then ;check builder reserve on wall and hero upgrade
		SetLog("FreeBuilder=" & $g_iFreeBuilderCount & ", Reserved (ForHero=" & $g_iHeroReservedBuilder & " ForWall=" & $iWallReserve & ")", $COLOR_INFO)
		SetLog("Not Have builder, exiting", $COLOR_INFO)
		Return
	EndIf
	
	Local $iCurrentGold = getResourcesMainScreen(695, 23) ;get current Gold
	Local $iCurrentElix = getResourcesMainScreen(695, 74) ;get current Elixir
	Local $iCurrentDE = getResourcesMainScreen(720, 120) ;get current Dark Elixir
	If Not $g_bRunState Then Return
	If Not OpenForgeWindow() Then 
		SetLog("Forge Window not Opened, exiting", $COLOR_ACTION)
		Return
	EndIf
	
	If $iBuilderToUse > 3 Then ClickDrag(720, 315, 600, 315)
	If _Sleep(1000) Then Return
	
	If Not $g_bRunState Then Return
	SetLog("Number of Enabled builder for Forge = " & $iBuilderToUse, $COLOR_ACTION)
	If ($g_iTownHallLevel = 13 Or $g_iTownHallLevel = 12) And $iBuilderToUse = 4 Then
		SetLog("TH Level Allows 3 Builders For Forge", $COLOR_DEBUG)
		$iBuilderToUse = 3
	ElseIf $g_iTownHallLevel = 11 And $iBuilderToUse > 2 Then
		SetLog("TH Level Allows 2 Builders For Forge", $COLOR_DEBUG)
		$iBuilderToUse = 2
	ElseIf $g_iTownHallLevel < 11 And $iBuilderToUse > 1 Then
		SetLog("TH Level Allows Only 1 Builder For Forge", $COLOR_DEBUG)
		$iBuilderToUse = 1
	EndIf
	
	Local $iBuilder = 0
	Local $iActiveForge = QuickMIS("CNX", $g_sImgActiveForge, 120, 230, 740, 450) ;check if we have forge in progress
	RemoveDupCNX($iActiveForge)
	If IsArray($iActiveForge) And UBound($iActiveForge) > 0 Then
		_ArraySort($iActiveForge, 0, 0, 0, 1)
		If UBound($iActiveForge) >= $iBuilderToUse Then
			SetLog("We have All Builder Active for Forge", $COLOR_INFO)
			ClickAway()
			Return
		EndIf
		$iBuilder = UBound($iActiveForge)
	EndIf
	
	SetLog("Already active builder Forging = " & $iBuilder, $COLOR_ACTION)
	If Not $g_bRunState Then Return
	Local $iBuilderToAssign = Number($iBuilderToUse) - Number($iBuilder)
	Local $aResource[5][2] = [["Gold", 240], ["Elixir", 330], ["Dark Elixir", 425], ["Builder Base Gold", 520], ["Builder Base Elixir", 610]]
	Local $aCraft = QuickMIS("CNX", $g_sImgCCGoldCraft, 120, 230, 740, 450)
	_ArraySort($aCraft, 0, 0, 0, 1) ;sort by column 1 (x coord)
	SetDebugLog("Count of Craft Button: " & UBound($aCraft))
	SetLog("Available Builder for forge = " & $iBuilderToAssign, $COLOR_INFO)
	If IsArray($aCraft) And UBound($aCraft) > 0 Then
		For $j = 1 To $iBuilderToAssign
			SetDebugLog("Proceed with builder #" & $j)
			Click($aCraft[$j-1][1], $aCraft[$j-1][2])
			_Sleep(500)
			If Not WaitStartCraftWindow() Then 
				ClickAway()
				Return
			EndIf
			For $i = 0 To UBound($aForgeType) -1
				If $aForgeType[$i] = True Then ;check if ForgeType Enabled
					SetLog("Try Forge using " & $aResource[$i][0], $COLOR_INFO)
					Click($aResource[$i][1], 300)
					_Sleep(1000)
					Local $cost = getOcrAndCapture("coc-forge", 240, 380, 160, 25, True)
					Local $gain = getOcrAndCapture("coc-forge", 528, 395, 100, 25, True)
					If $cost = "" Then 
						SetLog("Not enough resource to forge with" & $aResource[$i][0], $COLOR_INFO)
						ContinueLoop
					EndIf
					Local $bSafeToForge = False
					Switch $aResource[$i][0]
						Case "Gold"
							If Number($cost) + 200000 <= $iCurrentGold Then $bSafeToForge = True
						Case "Elixir"
							If Number($cost) + 200000 <= $iCurrentElix Then $bSafeToForge = True
						Case "Dark Elixir"
							If Number($cost) + 10000 <= $iCurrentDE Then $bSafeToForge = True
					EndSwitch
					SetLog("Forge Cost:" & $cost & ", gain Capital Gold:" & $gain, $COLOR_ACTION)
					If Not $bSafeToForge Then 
						SetLog("Not safe to forge with" & $aResource[$i][0] & ", not enough resource to save", $COLOR_INFO)
						ContinueLoop
					EndIf
					
					If Not $bTest Then 
						Click(430, 480)
						SetLog("Succes Forge with " & $aResource[$i][0] & ", will gain " & $gain & " Capital Gold", $COLOR_SUCCESS)
						_Sleep(1000)
						ExitLoop
					Else
						SetLog("Only Test, should click on [430,480]", $COLOR_INFO)
						ClickAway()
					EndIf
				EndIf
				_Sleep(1000)
				If Not $g_bRunState Then Return
			Next
		Next
	EndIf
	_Sleep(1000)
	ClickAway()
EndFunc

Func SwitchToClanCapital()
	Local $bRet = False
	If QuickMIS("BC1", $g_sImgAirShip, 200, 570, 400, 730) Then 
		Click($g_iQuickMISX, $g_iQuickMISY)
		For $i = 1 To 10
			SetDebugLog("Waiting for Travel to Clan Capital Map #" & $i, $COLOR_ACTION)
			If QuickMIS("BC1", $g_sImgCCMap, 300, 10, 430, 40) Then
				$bRet = True
				SetLog("Success Travel to Clan Capital Map", $COLOR_INFO)
				ExitLoop
			EndIf
			_Sleep(800)
		Next
	EndIf
	Return $bRet
EndFunc

Func IsCCBuilderMenuOpen()
	Local $bRet = False
	Local $aBorder[4] = [350, 73, 0xF7F8F5, 40]
	Local $sTriangle
	If _CheckPixel($aBorder, True) Then 
		SetDebugLog("Found Border Color: " & _GetPixelColor($aBorder[0], $aBorder[1], True), $COLOR_ACTION)
		$bRet = True ;got correct color for border 
	EndIf
	
	If Not $bRet Then ;lets re check if border color check not success
		$sTriangle = getOcrAndCapture("coc-buildermenu-cc", 350, 55, 200, 25)
		SetDebugLog("$sTriangle: " & $sTriangle)
		If $sTriangle = "^" Or $sTriangle = "~" Then $bRet = True
	EndIf
	SetDebugLog(String($bRet))
	Return $bRet
EndFunc

Func ClickCCBuilder()
	Local $bRet = False
	If IsCCBuilderMenuOpen() Then $bRet = True
	If Not $bRet Then
		If QuickMIS("BC1", $g_sImgCCMap, 300, 10, 430, 40) Then 
			Click($g_iQuickMISX, $g_iQuickMISY)
			_Sleep(1000)
			If IsCCBuilderMenuOpen() Then $bRet = True
		EndIf
	EndIf
	Return $bRet
EndFunc

#cs
Func FindCCExistingUpgrade()
	Local $aResult[0][3], $name[2] = ["", 0]
	Local $aIgnore[4] = ["Groove", "Tree", "Forest", "Campsite"]
	Local $aUpgrade = QuickMIS("CNX", $g_sImgResourceCC, 400, 100, 550, 360)
	If IsArray($aUpgrade) And UBound($aUpgrade) > 0 Then
		For $i = 0 To UBound($aUpgrade) - 1
			$name = getCCBuildingName($aUpgrade[$i][1] - 250, $aUpgrade[$i][2] - 8)
			If $g_bChkAutoUpgradeCCIgnore Then 
				For $y In $aIgnore
					If StringInStr($name[0], $y) Then 
						SetLog("Upgrade for " & $name[0] & " Ignored, Skip!!", $COLOR_ACTION)
						ContinueLoop 2 ;skip this upgrade, looking next 
					EndIf
				Next
			EndIf
			_ArrayAdd($aResult, $name[0] & "|" & $aUpgrade[$i][1] & "|" &  $aUpgrade[$i][2])
		Next
	EndIf
	Return $aResult
EndFunc

Func FindCCSuggestedUpgrade()
	Local $aResult[0][3], $name[2] = ["", 0]
	Local $aIgnore[4] = ["Groove", "Tree", "Forest", "Campsite"]
	Local $aUpgrade = QuickMIS("CNX", $g_sImgResourceCC, 400, 100, 550, 360)
	If IsArray($aUpgrade) And UBound($aUpgrade) > 0 Then
		For $i = 0 To UBound($aUpgrade) - 1
			$name = getCCBuildingNameBlue($aUpgrade[$i][1] - 250, $aUpgrade[$i][2] - 9)
			If $name[0] = "" Then $name = getCCBuildingName($aUpgrade[$i][1] - 250, $aUpgrade[$i][2] - 9)
			If $g_bChkAutoUpgradeCCIgnore Then 
				For $y In $aIgnore
					If StringInStr($name[0], $y) Then 
						SetLog("Upgrade for " & $name[0] & " Ignored, Skip!!", $COLOR_ACTION)
						ContinueLoop 2 ;skip this upgrade, looking next 
					EndIf
				Next
			EndIf
			_ArrayAdd($aResult, $name[0] & "|" & $aUpgrade[$i][1] & "|" &  $aUpgrade[$i][2])
		Next
	EndIf
	Return $aResult
EndFunc
#ce

Func FindCCExistingUpgrade()
	Local $aResult[0][3], $name[2] = ["", 0]
	Local $aUpgrade = QuickMIS("CNX", $g_sImgResourceCC, 400, 100, 550, 360)
	If IsArray($aUpgrade) And UBound($aUpgrade) > 0 Then
		_ArraySort($aUpgrade, 0, 0, 0, 2) ;sort by Y coord
		For $i = 0 To UBound($aUpgrade) - 1
			$name = getCCBuildingName($aUpgrade[$i][1] - 250, $aUpgrade[$i][2] - 8)
			If $g_bChkAutoUpgradeCCIgnore Then 
				For $y In $aCCBuildingIgnore
					If StringInStr($name[0], $y) Then 
						SetLog("Upgrade for " & $name[0] & " Ignored, Skip!!", $COLOR_ACTION)
						ContinueLoop 2 ;skip this upgrade, looking next 
					EndIf
				Next
			EndIf
			_ArrayAdd($aResult, $name[0] & "|" & $aUpgrade[$i][1] & "|" &  $aUpgrade[$i][2])
		Next
	EndIf
	Return $aResult
EndFunc

Func FindCCSuggestedUpgrade()
	Local $aResult[0][3], $name[2] = ["", 0]
	Local $aUpgrade = QuickMIS("CNX", $g_sImgResourceCC, 400, 100, 550, 360)
	If IsArray($aUpgrade) And UBound($aUpgrade) > 0 Then
		_ArraySort($aUpgrade, 0, 0, 0, 2) ;sort by Y coord
		For $i = 0 To UBound($aUpgrade) - 1
			SetDebugLog("Pixel on " & $aUpgrade[$i][1] - 61 & "," & $aUpgrade[$i][2] + 3 & ": " & _GetPixelColor($aUpgrade[$i][1] - 61, $aUpgrade[$i][2] + 3, True), $COLOR_INFO)
			If _ColorCheck(_GetPixelColor($aUpgrade[$i][1] - 61, $aUpgrade[$i][2] + 3, True), Hex(0xC9F659, 6), 20) Then ;check if we have progressbar
				$name = getCCBuildingName($aUpgrade[$i][1] - 250, $aUpgrade[$i][2] - 11)
			Else
				$name = getCCBuildingNameBlue($aUpgrade[$i][1] - 200, $aUpgrade[$i][2] - 12)
			EndIf
			If $g_bChkAutoUpgradeCCIgnore Then 
				For $y In $aCCBuildingIgnore
					If StringInStr($name[0], $y) Then 
						SetLog("Upgrade for " & $name[0] & " Ignored, Skip!!", $COLOR_ACTION)
						ContinueLoop 2 ;skip this upgrade, looking next 
					EndIf
				Next
			EndIf
			_ArrayAdd($aResult, $name[0] & "|" & $aUpgrade[$i][1] & "|" &  $aUpgrade[$i][2])
		Next
	EndIf
	Return $aResult
EndFunc

Func WaitUpgradeButtonCC()
	Local $aRet[3] = [False, 0, 0]
	For $i = 1 To 10
		If Not $g_bRunState Then Return
		SetLog("Waiting for Upgrade Button #" & $i, $COLOR_ACTION)
		If QuickMIS("BC1", $g_sImgCCUpgradeButton, 300, 570, 600, 680) Then ;check for upgrade button (Hammer)
			$aRet[0] = True
			$aRet[1] = $g_iQuickMISX
			$aRet[2] = $g_iQuickMISY
			Return $aRet ;immediately return as we found upgrade button
		EndIf
		_Sleep(1000)
		If $i > 3 Then SkipChat()
	Next
	Return $aRet
EndFunc

Func WaitUpgradeWindowCC()
	Local $bRet = False
	For $i = 1 To 10
		SetLog("Waiting for Upgrade Window #" & $i, $COLOR_ACTION)
		_Sleep(1000)
		If QuickMis("BC1", $g_sImgGeneralCloseButton, 680, 110, 730, 170) Then ;check if upgrade window opened
			If Not QuickMIS("BC1", $g_sImgClanCapitalTutorial, 30, 460, 200, 630) Then	;also check if there is no tutorial
				$bRet = True
				Return $bRet
			EndIf
		EndIf
		SkipChat()
	Next
	If Not $bRet Then SetLog("Upgrade Window doesn't open", $COLOR_ERROR)
	Return $bRet
EndFunc

Func SkipChat()
	For $y = 1 To 10 
		If Not $g_bRunState Then Return
		If QuickMIS("BC1", $g_sImgClanCapitalTutorial, 30, 460, 200, 680) Then			
			Click($g_iQuickMISX + 100, $g_iQuickMISY)
			SetLog("Skip chat #" & $y, $COLOR_INFO)
			_Sleep(5000)
		Else
			If $y > 5 Then 
				SetLog("Seem's there is no tutorial chat, continue", $COLOR_INFO)
				ExitLoop
			EndIf
		EndIf
		_Sleep(1000)
	Next
EndFunc

Func SwitchToMainVillage()
	Local $bRet = False
	SetDebugLog("Going To MainVillage", $COLOR_ACTION)
	For $i = 1 To 10
		If QuickMIS("BC1", $g_sImgCCMap, 300, 10, 430, 40) Then
			Click(60, 660) ;Click ReturnHome/Map
			_Sleep(2000)
		EndIf
		_Sleep(800)
		If isOnMainVillage() Then 
			$bRet = True
			ExitLoop
		EndIf
	Next
	ZoomOut()
	Return $bRet
EndFunc

Func AutoUpgradeCC($bTest = False)
	If Not $g_bChkEnableAutoUpgradeCC Then Return
	Local $aRet[3] = [False, 0, 0]
	SetLog("Checking Clan Capital AutoUpgrade", $COLOR_INFO)
	ZoomOut() ;ZoomOut first
	If Not SwitchToClanCapital() Then Return
	_Sleep(1000)
	ClanCapitalReport()
	If Number($g_iLootCCGold) = 0 Then 
		SetLog("No Capital Gold to spend to Contribute", $COLOR_INFO)
		SwitchToMainVillage()
		Return
	EndIf
	If Not $g_bRunState Then Return
	Local $bUpgradeFound = True ;lets assume there is upgrade in progress exists
	If ClickCCBuilder() Then 
		_Sleep(1000)
		Local $Text = getOcrAndCapture("coc-buildermenu-capital", 345, 81, 100, 25)
		If StringInStr($Text, "No") Then 
			SetLog("No Upgrades in progress", $COLOR_INFO)
			$bUpgradeFound = False ;builder menu opened but no upgrades on progress exists
		EndIf
	Else
		SetLog("Fail to open Builder Menu", $COLOR_ERROR)
		SwitchToMainVillage()
		Return
	EndIf
	_Sleep(500)
	If $bUpgradeFound Then 
		SetLog("Checking Upgrade From Capital Map", $COLOR_INFO)
		Local $aUpgrade = FindCCExistingUpgrade() ;Find on Capital Map, should only find currently on progress building
		If IsArray($aUpgrade) And UBound($aUpgrade) > 0 Then
			For $i = 0 To UBound($aUpgrade) - 1
				SetDebugLog("CCExistingUpgrade: " & $aUpgrade[$i][0])
				Click($aUpgrade[$i][1], $aUpgrade[$i][2])
				_Sleep(2000)
				$aRet = WaitUpgradeButtonCC()
				If Not $aRet[0] Then 
					SetLog("Upgrade Button Not Found", $COLOR_ERROR)
					SwitchToMainVillage()
					Return
				Else
					Click($aRet[1], $aRet[2])
					_Sleep(2000)
					If IsUpgradeCCIgnore() Then
						SetLog("Upgrade Ignored, Looking Next Upgrade", $COLOR_INFO)
						ContinueLoop
					EndIf
					If Not WaitUpgradeWindowCC() Then 
						SwitchToMainVillage()
						Return
					EndIf
					_Sleep(1000)
					If Not $bTest Then 
						Click(640, 550) ;Click Contribute
						ClickAway()
					Else
						SetLog("Only Test, should click Contibute on [640, 550]", $COLOR_INFO)
						ClickAway()
						SwitchToMainVillage()
						Return
					EndIf
					_Sleep(500)
				EndIf
				ExitLoop ;just do 1 upgrade, next upgrade will do on next attempt (cycle)
			Next
			SwitchToCapitalMain()
		EndIf
	EndIf
	
	ClickAway() ;close builder menu
	ClanCapitalReport()
	;Upgrade through district map
	Local $aMapCoord[7][3] = [["Golem Quarry", 185, 590], ["Dragon Cliffs", 630, 465], ["Builder's Workshop", 490, 525], ["Balloon Lagoon", 300, 490], _ 
									["Wizard Valley", 410, 400], ["Barbarian Camp", 530, 340], ["Capital Peak", 400, 225]]
	While $g_iLootCCGold > 0
		If Number($g_iLootCCGold) > 0 Then
			SetLog("Checking Upgrade From District Map", $COLOR_INFO)
			For $i = 0 To UBound($aMapCoord) - 1
				SetLog("[" & $i & "] Checking " & $aMapCoord[$i][0], $COLOR_ACTION)
				If QuickMIS("BC1", $g_sImgLock, $aMapCoord[$i][1], $aMapCoord[$i][2] - 120, $aMapCoord[$i][1] + 100, $aMapCoord[$i][2]) Then 
					SetLog($aMapCoord[$i][0] & " is Locked", $COLOR_INFO)
					ContinueLoop
				Else
					SetLog($aMapCoord[$i][0] & " is UnLocked", $COLOR_INFO)
				EndIf
				SetLog("Go to " & $aMapCoord[$i][0] & " to Check Upgrades", $COLOR_ACTION)
				Click($aMapCoord[$i][1], $aMapCoord[$i][2])
				If Not WaitForMap($aMapCoord[$i][0]) Then 
					SetLog("Going to " & $aMapCoord[$i][0] & " Failed", $COLOR_ERROR)
					SwitchToMainVillage()
					Return
				EndIf
				If Not ClickCCBuilder() Then Return
				Local $aUpgrade = FindCCSuggestedUpgrade() ;Find on Distric Map, Will Read White and Blue Font
				If IsArray($aUpgrade) And UBound($aUpgrade) > 0 Then
					For $j = 0 To UBound($aUpgrade) - 1
						SetLog("CCSuggestedUpgrade: " & $aUpgrade[$j][0])
						Click($aUpgrade[$j][1], $aUpgrade[$j][2])
						$aRet = WaitUpgradeButtonCC()
						If Not $aRet[0] Then 
							SetLog("Upgrade Button Not Found", $COLOR_ERROR)
							SwitchToMainVillage()
							Return
						Else
							Click($aRet[1], $aRet[2])
							_Sleep(2000)
							If IsUpgradeCCIgnore() Then
								SetLog("Upgrade Ignored, Looking Next Upgrade", $COLOR_INFO)
								ContinueLoop
							EndIf
							If Not WaitUpgradeWindowCC() Then 
								SwitchToMainVillage()
								Return
							EndIf
							If Not $bTest Then 
								Click(640, 550) ;Click Contribute
								ClickAway()
							Else
								SetLog("Only Test, should click Contibute on [640, 550]", $COLOR_INFO)
								ClickAway()
							EndIf
							_Sleep(500)
							ClickAway()
						EndIf
						ClanCapitalReport()
						If Number($g_iLootCCGold) = 0 Then 
							SwitchToMainVillage()
							Return
						EndIf
						ClickCCBuilder()
					Next
				Else ;clan capital gold with blue text not found on builder menu, check if all possible upgrades done?
					Local $Text = getOcrAndCapture("coc-buildermenu", 300, 81, 230, 25)
					Local $aDone[2] = ["All possible", "done"]
					Local $bAllDone = False
					For $z In $aDone
						If StringInStr($Text, $z) Then
							SetDebugLog("Match with: " & $z)
							SetLog("All Possible Upgrades Done", $COLOR_INFO)
						EndIf
					Next
					SwitchToCapitalMain()
				EndIf	
			Next
		EndIf
		ClanCapitalReport()
	WEnd
	SwitchToMainVillage() ;last call, we should go back to main screen
EndFunc 

Func WaitForMap($sMapName = "Capital Peak")
	Local $bRet
	For $i = 1 To 10
		SetDebugLog("Waiting for " & $sMapName & "#" & $i, $COLOR_ACTION)
		_Sleep(2000)
		If QuickMIS("BC1", $g_sImgCCMap, 300, 10, 430, 40) Then ExitLoop
	Next
	Local $aMapName = StringSplit($sMapName, "|", $STR_NOCOUNT)
	Local $Text = getOcrAndCapture("coc-mapname", $g_iQuickMISX, $g_iQuickMISY - 12, 230, 35)
	SetDebugLog("$Text: " & $Text)
	For $i In $aMapName
		If StringInStr($Text, $i) Then 
			SetDebugLog("Match with: " & $i)
			$bRet = True
			SetLog("We are on " & $sMapName, $COLOR_INFO)
		EndIf
	Next
	Return $bRet
EndFunc

Func SwitchToCapitalMain()
	Local $bRet = False
	SetDebugLog("Going to Clan Capital", $COLOR_ACTION)
	For $i = 1 To 5
		If QuickMIS("BC1", $g_sImgCCMap, 15, 610, 115, 700) Then 
			If $g_iQuickMISName = "MapButton" Then 
				Click(60, 640) ;Click Map
				_Sleep(3000)
			EndIf
		EndIf
		If QuickMIS("BC1", $g_sImgCCMap, 15, 610, 115, 700) Then 
			If $g_iQuickMISName = "ReturnHome" Then 
				SetDebugLog("We are on Clan Capital", $COLOR_ACTION)
				$bRet = True
				ExitLoop
			EndIf
		EndIf
	Next
	Return $bRet
EndFunc

Func IsUpgradeCCIgnore()
	Local $bRet = False
	Local $UpgradeName = getOcrAndCapture("coc-build", 200, 494, 400, 25)
	If $g_bChkAutoUpgradeCCIgnore Then 
		For $y In $aCCBuildingIgnore
			If StringInStr($UpgradeName, $y) Then 
				SetDebugLog($UpgradeName & " Match with: " & $y) 
				SetLog("Upgrade for " & $y & " Ignored, Skip!!", $COLOR_ACTION)
				$bRet = True
				ExitLoop
			Else
				SetDebugLog("OCR: " & $UpgradeName & " compare with: " & $y)
			EndIf
		Next
	EndIf
	Return $bRet
EndFunc

;Func AutoUpgradeCCLog($BuildingName = "", $cost = "")
;	GUICtrlSetData($g_hTxtAutoUpgradeCCLog, @CRLF & _NowDate() & " " & _NowTime() & " [" & $g_sProfileCurrentName & "] - Upgrade " & $BuildingName & " cost: " & $cost & " CapitalGold", 1)
;EndFunc
