; #FUNCTION# ====================================================================================================================
; Name ..........:
; Description ...:
; Syntax ........:
; Parameters ....:
; Return values .:
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MyBotRun. Copyright 2015-2018
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......: ---
; Link ..........: https://www.mybot.run
; Example .......: ---
;================================================================================================================================
; Based in xbebenk and snorlax (the best devs)
Func ClickDragAUpgrade($YY = Default, $DragCount = 3)
	Local $x = 345, $yUp = 10, $yDown = 800, $iDelay = 1000
	Local $Yscroll =  123
	If $YY = Default Then $YY = $Yscroll
	For $checkCount = 0 To 2
		If Not $g_bRunState Then Return
		If _ColorCheck(_GetPixelColor(350, 73, True), "FDFEFD", 20) Then ; check upgrade window border
				
			If $YY < 100 Then $YY = 150
			If $DragCount > 1 Then
				For $i = 1 To $DragCount
					ClickDrag($x, $YY, $x, $yUp, $iDelay) ;drag up
				Next
			Else
				ClickDrag($x, $YY, $x, $yUp, $iDelay) ;drag up
			EndIf
			
			If _Sleep($DELAYAUTOUPGRADEBUILDING1) Then Return
		EndIf

		If _ColorCheck(_GetPixelColor(350, 73, True), "FDFEFD", 20) Then ;check upgrade window border
			SetLog("Upgrade Window Exist", $COLOR_INFO)
			Return True
		Else
			SetLog("Upgrade Window Gone!", $COLOR_DEBUG)
			Click(295, 30)
			If _Sleep(1000) Then Return
		EndIf
	Next
	Return False
EndFunc ;==>IsUpgradeWindow

Func AutoUpgrade($bDebug = False)
	Local $bwasrunstate = $g_brunstate
	$g_brunstate = True
	Local $result = _AutoUpgrade($bDebug)
	$g_brunstate = $bwasrunstate
	Return $result
EndFunc

Func _AutoUpgrade($bDebug = False)
	
	If Not $g_bAutoUpgradeEnabled Then Return
	
	If Not $bDebug And $g_ifreebuildercount < 1 Then
		SetLog("No builder available... Skipping Auto Upgrade...", $color_warning)
		Return
	EndIf
	
	SetLog("Entering Auto Upgrade...", $COLOR_INFO)
	
	Local $iLoopAmount = 0
	Local $iloopmax = 50
	
	SetDebugLog("Scroll Attempts? " & $iloopmax)
	
	SetLog("Scroll Attempts: " & $iLoopAmount & " / " & $iloopmax, $COLOR_INFO)
	
	$g_icurrentlineoffset = 0
	$g_inextlineoffset = 0
	
	If RandomSleep($DELAYAUTOUPGRADEBUILDING1) Then Return
	
	VillageReport(True, True)
	Click(295, 30)
	
	If _Sleep($DELAYAUTOUPGRADEBUILDING1) Then Return
	
	Static $s_hHBitmap  = 0
	Static $s_hHBitmap2 = 0
	Local $bIsNewUpdate = False
	While 1
		$iLoopAmount += 1
		If $iLoopAmount >= $iloopmax And $iloopmax <> 0 Then
			SetLog("Scroll to top!")
			For $i = 0 To 2
				Clickdrag(345, 125, 345, 375, 1000)
			Next
			ExitLoop
		EndIf
		
		If Not $bDebug And $g_ifreebuildercount < 1 Then
			SetLog("No builder available... Skipping Auto Upgrade...", $color_warning)
			ExitLoop
		EndIf
		
		If Not $bDebug And ($g_ifreebuildercount - ($g_bAutoUpgradewallsenable And $g_bupgradewallsavebuilder ? 1 : 0) - ReservedBuildersForHeroes()) <= 0 Then
			SetLog("No builder available. Skipping Auto Upgrade!", $color_warning)
			ExitLoop
		EndIf
		
		If Not (_ColorCheck(_GetPixelColor(275, 15, True), "F5F5ED", 20) = True) Then
			SetLog("Unable to find the Builder menu button... Exiting Auto Upgrade...", $COLOR_ERROR)
			ExitLoop
		EndIf
		
		If QuickMIS("BC1", $g_simgaupgradezero, 180, 80 + $g_inextlineoffset + $g_iMidOffsetYFixed, 480, 410 + $g_iMidOffsetYFixed) Then
			SetLog("Possible upgrade found !", $color_success)
			$g_icurrentlineoffset = $g_inextlineoffset + $g_iQuickMISy
		Else
			If $iloopamount <= $iloopmax And $iloopmax <> 0 Then
				SetLog("Scroll Attempts: " & $iloopamount & " / " & $iloopmax, $color_info)
				
				_CaptureRegion()
				If $s_hHBitmap <> 0 Then GdiDeleteHBitmap($s_hHBitmap) ; Prevent memory leaks.
				$s_hHBitmap = GetHHBitmapArea($g_hHBitmap)

				ClickDragAUpgrade(Default, 3)
				If _Sleep($DELAYAUTOUPGRADEBUILDING4 * 2) Then Return			

				_CaptureRegion()
				If $s_hHBitmap2 <> 0 Then GdiDeleteHBitmap($s_hHBitmap2) ; Prevent memory leaks.
				$s_hHBitmap2 = GetHHBitmapArea($g_hHBitmap)
				
				If _MasivePixelCompare($s_hHBitmap, $s_hHBitmap2, 180, 80, 480, 410 + 160, 15, 5, False, 15.0) Then
					$iloopamount = $iLoopMax + 1
					SetLog("My eye detected the end, chau.", $COLOR_INFO)
				EndIf

				$g_icurrentlineoffset = 0
				$g_inextlineoffset = 0
				ContinueLoop
			Else
				SetLog("No possible upgrade found!", $color_success)
				ExitLoop
			EndIf
		EndIf
		
		If QuickMIS("NX", $g_simgaupgradeobst, 180, 80 + $g_icurrentlineoffset - 15 + $g_iMidOffsetYFixed, 480, 80 + $g_icurrentlineoffset + 15 + $g_iMidOffsetYFixed) <> "none" Then
			SetLog("This is a New Building or an Equipment, looking next...", $color_warning)
			$g_inextlineoffset = $g_icurrentlineoffset
			ContinueLoop
		EndIf
		
		Click($g_iQuickMISX, $g_iQuickMISY)
		
		If _Sleep($DELAYAUTOUPGRADEBUILDING2) Then Return
		
		Local $g_bdebugocrtemp = $g_bdebugocr
		Local $g_bdebugsetlogtemp = $g_bdebugsetlog
		Local $aReset[3] = ["", "", ""]
		
		$g_aupgradenamelevel = $aReset
		
		For $i = 0 To 5
			$g_aupgradenamelevel = BuildingInfo(245, 490 + $g_iBottomOffsetY)
			SetLog("Clicked in " & $g_aupgradenamelevel[1])
			If $g_aupgradenamelevel[1] <> "" Then ExitLoop
			If _Sleep($DELAYAUTOUPGRADEBUILDING3) Then ExitLoop
			If $i = 5 And $g_aupgradenamelevel[1] = "" Then
				$g_bdebugocr = True
				$g_bdebugsetlog = True
				; BuildingInfo(245, 490 + $g_iBottomOffsetY)
				SetLog("Unable to find the building title... Exiting Auto Upgrade...", $COLOR_ERROR)
				SetLog("Taking a Image for debug! And OCR debug!", $COLOR_ERROR)
				savedebugimage("AutoUpgrade")
				$g_bdebugocr = $g_bdebugocrtemp
				$g_bdebugsetlog = $g_bdebugsetlogtemp
			EndIf
		Next
		
		; check if any wrong Click by verifying the presence of the Upgrade button (the hammer)
		Local $aUpgradeButton = findButton("Upgrade", Default, 1, True)
		If Not(IsArray($aUpgradeButton) And UBound($aUpgradeButton, 1) = 2) Then
			SetLog("No upgrade here... Wrong Click, looking next...", $COLOR_WARNING)
			;$g_iNextLineOffset = $g_iCurrentLineOffset -> not necessary finally, but in case, I keep lne commented
			$g_iNextLineOffset = $g_iCurrentLineOffset
			ContinueLoop
		EndIf

		If $g_aupgradenamelevel[0] = "" Then
			SetLog("Error when trying to get upgrade name And level, looking next...", $COLOR_ERROR)
			$g_inextlineoffset = $g_icurrentlineoffset
			ContinueLoop
		EndIf

		; It uses sensitive text with algorithm, like wikipedia bots for fix white spaces.
		Local $sEvaluateUpgrade = $g_aupgradenamelevel[1]
		Local $bmustignoreupgrade = False
		Select
			Case IsHonestOCR($sEvaluateUpgrade, "Town Hall")
				$bMustIgnoreUpgrade = ($g_iChkUpgradesToIgnore[0] = 1)
			Case IsHonestOCR($sEvaluateUpgrade, "Gold Mine")
				$bMustIgnoreUpgrade = ($g_iChkUpgradesToIgnore[1] = 1)
			Case IsHonestOCR($sEvaluateUpgrade, "Elixir Collector")
				$bMustIgnoreUpgrade = ($g_iChkUpgradesToIgnore[2] = 1)
			Case IsHonestOCR($sEvaluateUpgrade, "Dark Elixir Drill")
				$bMustIgnoreUpgrade = ($g_iChkUpgradesToIgnore[3] = 1)
			Case IsHonestOCR($sEvaluateUpgrade, "Gold Storage")
				$bMustIgnoreUpgrade = ($g_iChkUpgradesToIgnore[4] = 1)
			Case IsHonestOCR($sEvaluateUpgrade, "Elixir Storage")
				$bMustIgnoreUpgrade = ($g_iChkUpgradesToIgnore[5] = 1)
			Case IsHonestOCR($sEvaluateUpgrade, "Dark Elixir Storage")
				$bMustIgnoreUpgrade = ($g_iChkUpgradesToIgnore[6] = 1)
			Case IsHonestOCR($sEvaluateUpgrade, "Clan Castle")
				$bMustIgnoreUpgrade = ($g_iChkUpgradesToIgnore[7] = 1)
			Case IsHonestOCR($sEvaluateUpgrade, "Army Camp")
				$bMustIgnoreUpgrade = ($g_iChkUpgradesToIgnore[8] = 1)
			Case IsHonestOCR($sEvaluateUpgrade, "Barracks")
				$bMustIgnoreUpgrade = ($g_iChkUpgradesToIgnore[9] = 1)
			Case IsHonestOCR($sEvaluateUpgrade, "Dark Barracks")
				$bMustIgnoreUpgrade = ($g_iChkUpgradesToIgnore[10] = 1)
			Case IsHonestOCR($sEvaluateUpgrade, "Dark Spell Factory")
				$bMustIgnoreUpgrade = ($g_iChkUpgradesToIgnore[11] = 1)
			Case IsHonestOCR($sEvaluateUpgrade, "Spell Factory")
				$bMustIgnoreUpgrade = ($g_iChkUpgradesToIgnore[12] = 1)
			Case IsHonestOCR($sEvaluateUpgrade, "Laboratory")
				$bMustIgnoreUpgrade = ($g_iChkUpgradesToIgnore[13] = 1)
			Case IsHonestOCR($sEvaluateUpgrade, "Workshop")
				$bMustIgnoreUpgrade = ($g_iChkUpgradesToIgnore[14] = 1)
			Case IsHonestOCR($sEvaluateUpgrade, "Pet House")
				$bMustIgnoreUpgrade = ($g_iChkUpgradesToIgnore[15] = 1)
			Case IsHonestOCR($sEvaluateUpgrade, "Barbarian King")
				If $g_iChkUpgradesToIgnore[16] = 1 Or $g_bUpgradeKingEnable = True Then $bMustIgnoreUpgrade = True
			Case IsHonestOCR($sEvaluateUpgrade, "Archer Queen")
				If $g_iChkUpgradesToIgnore[17] = 1 Or $g_bUpgradeQueenEnable = True Then $bMustIgnoreUpgrade = True
			Case IsHonestOCR($sEvaluateUpgrade, "Grand Warden")
				If $g_iChkUpgradesToIgnore[18] = 1 Or $g_bUpgradeWardenEnable = True Then $bMustIgnoreUpgrade = True
			Case IsHonestOCR($sEvaluateUpgrade, "Royal Champion")
				If $g_iChkUpgradesToIgnore[19] = 1 Or $g_bUpgradeChampionEnable = True Then $bMustIgnoreUpgrade = True
			Case IsHonestOCR($sEvaluateUpgrade, "Cannon")
				$bMustIgnoreUpgrade = ($g_iChkUpgradesToIgnore[20] = 1)
			Case IsHonestOCR($sEvaluateUpgrade, "Archer Tower")
				$bMustIgnoreUpgrade = ($g_iChkUpgradesToIgnore[21] = 1)
			Case IsHonestOCR($sEvaluateUpgrade, "Mortar")
				$bMustIgnoreUpgrade = ($g_iChkUpgradesToIgnore[22] = 1)
			Case IsHonestOCR($sEvaluateUpgrade, "Air Defense")
				$bMustIgnoreUpgrade = ($g_iChkUpgradesToIgnore[23] = 1)
			Case IsHonestOCR($sEvaluateUpgrade, "Wizard Tower")
				$bMustIgnoreUpgrade = ($g_iChkUpgradesToIgnore[24] = 1)
			Case IsHonestOCR($sEvaluateUpgrade, "Air Sweeper")
				$bMustIgnoreUpgrade = ($g_iChkUpgradesToIgnore[25] = 1)
			Case IsHonestOCR($sEvaluateUpgrade, "Hidden Tesla")
				$bMustIgnoreUpgrade = ($g_iChkUpgradesToIgnore[26] = 1)
			Case IsHonestOCR($sEvaluateUpgrade, "Bomb Tower")
				$bMustIgnoreUpgrade = ($g_iChkUpgradesToIgnore[27] = 1)
			Case IsHonestOCR($sEvaluateUpgrade, "X-Bow")
				$bMustIgnoreUpgrade = ($g_iChkUpgradesToIgnore[28] = 1)
			Case IsHonestOCR($sEvaluateUpgrade, "Inferno Tower")
				$bMustIgnoreUpgrade = ($g_iChkUpgradesToIgnore[29] = 1)
			Case IsHonestOCR($sEvaluateUpgrade, "Eagle Artillery")
				$bMustIgnoreUpgrade = ($g_iChkUpgradesToIgnore[30] = 1)
			Case IsHonestOCR($sEvaluateUpgrade, "Scattershot")
				$bMustIgnoreUpgrade = ($g_iChkUpgradesToIgnore[31] = 1)
			Case IsHonestOCR($sEvaluateUpgrade, "Builder's Hut")
				$bMustIgnoreUpgrade = ($g_iChkUpgradesToIgnore[32] = 1)
			Case IsHonestOCR($sEvaluateUpgrade, "Wall")
				$bMustIgnoreUpgrade = ($g_iChkUpgradesToIgnore[33] = 1 Or $g_bAutoUpgradeWallsEnable = True)
			Case IsHonestOCR($sEvaluateUpgrade, "Bomb") Or IsHonestOCR($sEvaluateUpgrade, "Spring Trap") Or IsHonestOCR($sEvaluateUpgrade, "Giant Bomb") Or IsHonestOCR($sEvaluateUpgrade, "Air Bomb") Or IsHonestOCR($sEvaluateUpgrade, "Seeking Air Mine") Or IsHonestOCR($sEvaluateUpgrade, "Skeleton Trap") Or IsHonestOCR($sEvaluateUpgrade, "Tornado Trap")
				$bMustIgnoreUpgrade = ($g_iChkUpgradesToIgnore[34] = 1)
			Case Else
				$bMustIgnoreUpgrade = False
		EndSelect
		
		If $bmustignoreupgrade = True Then
			SetLog("This upgrade must be ignored, looking next...", $color_warning)
			$g_inextlineoffset = $g_icurrentlineoffset
			ContinueLoop
		EndIf
		
		; if upgrade don't have to be ignored, Click on the Upgrade button to open Upgrade window
		ClickP($aUpgradeButton)
		If _Sleep($DELAYAUTOUPGRADEBUILDING1) Then Return

		_CaptureRegion2()
		Local $aClickP[2]
		Local $aHandle = QuickMIS("N1Cx1", $g_sImgAUpgradeRes, 690, 540 + $g_iMidOffsetYFixed, 730, 580 + $g_iMidOffsetYFixed)
		If UBound($aHandle) >= 2 And not @error Then
			$aClickP = $aHandle[1]
			$g_aupgraderesourcecostduration[0] = $aHandle[0]
			$g_aupgraderesourcecostduration[1] = getResourcesBonus(598, 509)
			$g_aupgraderesourcecostduration[2] = GetHeroUpgradeTime(578, 450)
		Else
			$aHandle = QuickMIS("N1Cx1", $g_sImgAUpgradeRes, 460, 510 + $g_iMidOffsetYFixed, 500, 550 + $g_iMidOffsetYFixed)
			If UBound($aHandle) >= 2 And not @error Then
				$aClickP = $aHandle[1]
				$g_aupgraderesourcecostduration[0] = $aHandle[0]
				$g_aupgraderesourcecostduration[1] = getResourcesBonus(366, 487 + $g_imidoffsety)
				$g_aupgraderesourcecostduration[2] = getbldgupgradetime(190, 307 + $g_imidoffsety)
			Else
				SetLog("Error when trying to get upgrade details, looking next...", $COLOR_ERROR)
				$g_inextlineoffset = $g_icurrentlineoffset
				ContinueLoop
			EndIf
		EndIf
		
		For $i = 0 To 2
			If $g_aupgraderesourcecostduration[$i] = "" Then
				SetLog("Error when trying to get upgrade details, looking next...", $COLOR_ERROR)
				$g_inextlineoffset = $g_icurrentlineoffset
				ContinueLoop 2
			EndIf
		Next
		
		Local $bMustIgnoreResource = False
		Switch $g_aupgraderesourcecostduration[0]
			Case "Gold"
				$bMustIgnoreResource = ($g_ichkresourcestoignore[0] = 1) ? True : False
			Case "Elixir"
				$bMustIgnoreResource = ($g_ichkresourcestoignore[1] = 1) ? True : False
			Case "Dark Elixir"
				$bMustIgnoreResource = ($g_ichkresourcestoignore[2] = 1) ? True : False
			Case Else
				$bMustIgnoreResource = False
		EndSwitch
		
		If $bMustIgnoreResource = True Then
			SetLog("This resource must be ignored, looking next...", $color_warning)
			$g_inextlineoffset = $g_icurrentlineoffset
			ContinueLoop
		EndIf
		
		Local $bsufficentresourcetoupgrade = False
		Switch $g_aupgraderesourcecostduration[0]
			Case "Gold"
				If $g_aicurrentloot[$elootgold] >= ($g_aupgraderesourcecostduration[1] + $g_itxtsmartmingold) Then $bsufficentresourcetoupgrade = True
			Case "Elixir"
				If $g_aicurrentloot[$elootelixir] >= ($g_aupgraderesourcecostduration[1] + $g_itxtsmartminelixir) Then $bsufficentresourcetoupgrade = True
			Case "Dark Elixir"
				If $g_aicurrentloot[$elootdarkelixir] >= ($g_aupgraderesourcecostduration[1] + $g_itxtsmartmindark) Then $bsufficentresourcetoupgrade = True
		EndSwitch
		
		If Not $bsufficentresourcetoupgrade Or $bDebug Then
			SetLog("Insufficient " & $g_aupgraderesourcecostduration[0] & " to launch this upgrade, looking Next...", $color_warning)
			$g_inextlineoffset = $g_icurrentlineoffset
			SetLog("Scroll to check another possible upgrade")
			ClickP($aaway, 1, 0, "#0000")
			If _Sleep($DELAYAUTOUPGRADEBUILDING1) Then Return
			Click(295, 30)
			If _Sleep($DELAYAUTOUPGRADEBUILDING1) Then Return
			Local $x = 345
			Local $ystart = 123
			Local $yend = 10
			ContinueLoop
		EndIf

		ClickP($aClickP)
		If _Sleep(2000) Then Return
		
		If StringInStr($g_aupgradenamelevel[1], "Elixir") > 0 OR StringInStr($g_aupgradenamelevel[1], "Mine") > 0 Then
			Local $string = getocrAndcapture("coc-boosted", 361, 221, 150, 19, True)
			If StringInStr($string, "End") > 0 Then
				SetLog("Upgrading the building will end the boost.", $COLOR_INFO)
				Click(510, 380)
				If _Sleep(2000) Then Return
			EndIf
		EndIf
		
		If StringInStr($g_aupgradenamelevel[1], "Wall") > 0 Then
			SetLog($g_aupgradenamelevel[1] & " Upgraded to Level: " & $g_aupgradenamelevel[2] + 1 & " successfully!", $color_success)
			SetLog(" - Cost : " & _numberformat($g_aupgraderesourcecostduration[1]) & " " & $g_aupgraderesourcecostduration[0], $color_success)
		Else
			SetLog("Launched upgrade of " & $g_aupgradenamelevel[1] & " to level " & $g_aupgradenamelevel[2] + 1 & " successfully!", $color_success)
			SetLog(" - Cost : " & _numberformat($g_aupgraderesourcecostduration[1]) & " " & $g_aupgraderesourcecostduration[0], $color_success)
			SetLog(" - Duration : " & $g_aupgraderesourcecostduration[2], $color_success)
		EndIf
		
		Local $supgradelog = (StringInStr($g_aupgradenamelevel[1], "Wall") > 0 ? "Upgraded " : "Upgrading ") & $g_aupgradenamelevel[1] & " to level " & $g_aupgradenamelevel[2] + 1 & " for " & _numberformat($g_aupgraderesourcecostduration[1]) & " " & $g_aupgraderesourcecostduration[0] & (StringInStr($g_aupgradenamelevel[1], "Wall") > 0 ? "" : "Duration : " & $g_aupgraderesourcecostduration[2])
		_guictrledit_appendtext($g_htxtAutoUpgradelog, @CRLF & String($g_icuraccount + 1) & " " & _nowdate() & " " & _nowtime(4) & "  " & $supgradelog)
		_filewritelog($g_sprofilelogspath & "\AutoUpgradeHistory.log", $supgradelog)
		PushMsg("BuildingUpgrading")
		$g_icurrentlineoffset -= $g_iQuickMISy
		$g_ifreebuildercount -= 1
		ClickAway()
		Click(295, 30)
		If _Sleep($DELAYAUTOUPGRADEBUILDING1) Then Return
		
		If Not $bDebug And $g_ifreebuildercount < 1 Then
			SetLog("All builders are now working, exit Auto Upgrade ...", $color_success)
			ExitLoop
		EndIf
		
		If Not $bDebug And ($g_ifreebuildercount - ($g_bAutoUpgradewallsenable And $g_bupgradewallsavebuilder ? 1 : 0) - ReservedBuildersForHeroes()) <= 0 Then
			SetLog("All builders are now working, keeping 1 idle for wall upgrade ...", $color_success)
			ExitLoop
		EndIf
	WEnd
	SetLog("Auto Upgrade finished", $COLOR_INFO)
	ClickAway()
	CheckMainScreen()

	; resetting the offsets of the lines
	$g_iCurrentLineOffset = 0
	$g_iNextLineOffset = 0

	SetLog("Auto Upgrade finished", $COLOR_INFO)
	ClickAway() ;Click Away

EndFunc   ;==>AutoUpgrade

Func AutoUpdTest($sText = "")
		Local $bMustIgnoreUpgrade = False

		If $sText <> "" Then
			Local $aTest[3] = [1, $sText, 3]
			$g_aUpgradeNameLevel = $aTest
		Else
			$g_aUpgradeNameLevel = BuildingInfo(242, 490 + $g_iBottomOffsetY)
		EndIf

		Local $sEvaluateUpgrade = String($g_aUpgradeNameLevel[1])
		SetDebugLog("[AutoUpdtest] " & $sEvaluateUpgrade)

		; It uses sensitive text with algorithm, like wikipedia bots for fix white spaces.
		Select
			Case IsHonestOCR($sEvaluateUpgrade, "Town Hall")
				$bMustIgnoreUpgrade = ($g_iChkUpgradesToIgnore[0] = 1)
			Case IsHonestOCR($sEvaluateUpgrade, "Gold Mine")
				$bMustIgnoreUpgrade = ($g_iChkUpgradesToIgnore[1] = 1)
			Case IsHonestOCR($sEvaluateUpgrade, "Elixir Collector")
				$bMustIgnoreUpgrade = ($g_iChkUpgradesToIgnore[2] = 1)
			Case IsHonestOCR($sEvaluateUpgrade, "Dark Elixir Drill")
				$bMustIgnoreUpgrade = ($g_iChkUpgradesToIgnore[3] = 1)
			Case IsHonestOCR($sEvaluateUpgrade, "Gold Storage")
				$bMustIgnoreUpgrade = ($g_iChkUpgradesToIgnore[4] = 1)
			Case IsHonestOCR($sEvaluateUpgrade, "Elixir Storage")
				$bMustIgnoreUpgrade = ($g_iChkUpgradesToIgnore[5] = 1)
			Case IsHonestOCR($sEvaluateUpgrade, "Dark Elixir Storage")
				$bMustIgnoreUpgrade = ($g_iChkUpgradesToIgnore[6] = 1)
			Case IsHonestOCR($sEvaluateUpgrade, "Clan Castle")
				$bMustIgnoreUpgrade = ($g_iChkUpgradesToIgnore[7] = 1)
			Case IsHonestOCR($sEvaluateUpgrade, "Army Camp")
				$bMustIgnoreUpgrade = ($g_iChkUpgradesToIgnore[8] = 1)
			Case IsHonestOCR($sEvaluateUpgrade, "Barracks")
				$bMustIgnoreUpgrade = ($g_iChkUpgradesToIgnore[9] = 1)
			Case IsHonestOCR($sEvaluateUpgrade, "Dark Barracks")
				$bMustIgnoreUpgrade = ($g_iChkUpgradesToIgnore[10] = 1)
			Case IsHonestOCR($sEvaluateUpgrade, "Dark Spell Factory")
				$bMustIgnoreUpgrade = ($g_iChkUpgradesToIgnore[11] = 1)
			Case IsHonestOCR($sEvaluateUpgrade, "Spell Factory")
				$bMustIgnoreUpgrade = ($g_iChkUpgradesToIgnore[12] = 1)
			Case IsHonestOCR($sEvaluateUpgrade, "Laboratory")
				$bMustIgnoreUpgrade = ($g_iChkUpgradesToIgnore[13] = 1)
			Case IsHonestOCR($sEvaluateUpgrade, "Workshop")
				$bMustIgnoreUpgrade = ($g_iChkUpgradesToIgnore[14] = 1)
			Case IsHonestOCR($sEvaluateUpgrade, "Pet House")
				$bMustIgnoreUpgrade = ($g_iChkUpgradesToIgnore[15] = 1)
			Case IsHonestOCR($sEvaluateUpgrade, "Barbarian King")
				If $g_iChkUpgradesToIgnore[16] = 1 Or $g_bUpgradeKingEnable = True Then $bMustIgnoreUpgrade = True
			Case IsHonestOCR($sEvaluateUpgrade, "Archer Queen")
				If $g_iChkUpgradesToIgnore[17] = 1 Or $g_bUpgradeQueenEnable = True Then $bMustIgnoreUpgrade = True
			Case IsHonestOCR($sEvaluateUpgrade, "Grand Warden")
				If $g_iChkUpgradesToIgnore[18] = 1 Or $g_bUpgradeWardenEnable = True Then $bMustIgnoreUpgrade = True
			Case IsHonestOCR($sEvaluateUpgrade, "Royal Champion")
				If $g_iChkUpgradesToIgnore[19] = 1 Or $g_bUpgradeChampionEnable = True Then $bMustIgnoreUpgrade = True
			Case IsHonestOCR($sEvaluateUpgrade, "Cannon")
				$bMustIgnoreUpgrade = ($g_iChkUpgradesToIgnore[20] = 1)
			Case IsHonestOCR($sEvaluateUpgrade, "Archer Tower")
				$bMustIgnoreUpgrade = ($g_iChkUpgradesToIgnore[21] = 1)
			Case IsHonestOCR($sEvaluateUpgrade, "Mortar")
				$bMustIgnoreUpgrade = ($g_iChkUpgradesToIgnore[22] = 1)
			Case IsHonestOCR($sEvaluateUpgrade, "Air Defense")
				$bMustIgnoreUpgrade = ($g_iChkUpgradesToIgnore[23] = 1)
			Case IsHonestOCR($sEvaluateUpgrade, "Wizard Tower")
				$bMustIgnoreUpgrade = ($g_iChkUpgradesToIgnore[24] = 1)
			Case IsHonestOCR($sEvaluateUpgrade, "Air Sweeper")
				$bMustIgnoreUpgrade = ($g_iChkUpgradesToIgnore[25] = 1)
			Case IsHonestOCR($sEvaluateUpgrade, "Hidden Tesla")
				$bMustIgnoreUpgrade = ($g_iChkUpgradesToIgnore[26] = 1)
			Case IsHonestOCR($sEvaluateUpgrade, "Bomb Tower")
				$bMustIgnoreUpgrade = ($g_iChkUpgradesToIgnore[27] = 1)
			Case IsHonestOCR($sEvaluateUpgrade, "X-Bow")
				$bMustIgnoreUpgrade = ($g_iChkUpgradesToIgnore[28] = 1)
			Case IsHonestOCR($sEvaluateUpgrade, "Inferno Tower")
				$bMustIgnoreUpgrade = ($g_iChkUpgradesToIgnore[29] = 1)
			Case IsHonestOCR($sEvaluateUpgrade, "Eagle Artillery")
				$bMustIgnoreUpgrade = ($g_iChkUpgradesToIgnore[30] = 1)
			Case IsHonestOCR($sEvaluateUpgrade, "Scattershot")
				$bMustIgnoreUpgrade = ($g_iChkUpgradesToIgnore[31] = 1)
			Case IsHonestOCR($sEvaluateUpgrade, "Builder's Hut")
				$bMustIgnoreUpgrade = ($g_iChkUpgradesToIgnore[32] = 1)
			Case IsHonestOCR($sEvaluateUpgrade, "Wall")
				$bMustIgnoreUpgrade = ($g_iChkUpgradesToIgnore[33] = 1 Or $g_bAutoUpgradeWallsEnable = True)
			Case IsHonestOCR($sEvaluateUpgrade, "Bomb") Or IsHonestOCR($sEvaluateUpgrade, "Spring Trap") Or IsHonestOCR($sEvaluateUpgrade, "Giant Bomb") Or IsHonestOCR($sEvaluateUpgrade, "Air Bomb") Or IsHonestOCR($sEvaluateUpgrade, "Seeking Air Mine") Or IsHonestOCR($sEvaluateUpgrade, "Skeleton Trap") Or IsHonestOCR($sEvaluateUpgrade, "Tornado Trap")
				$bMustIgnoreUpgrade = ($g_iChkUpgradesToIgnore[34] = 1)
			Case Else
				$bMustIgnoreUpgrade = False
		EndSelect

		SetLog("$bMustIgnoreUpgrade: " & $bMustIgnoreUpgrade)
		SetLog("$bMustIgnoreUpgrade: " & $sEvaluateUpgrade)

		Return $bMustIgnoreUpgrade
EndFunc
; #Ce

Func IsHonestOCR($sTring, $sItem, $iMaxDis = 1, $iEvery = 4)
	Local $iSting = Round(_Max(StringLen($sTring), StringLen($sItem)) / $iEvery)
	If $iSting < 1 Then $iSting = 1
	; SetLog("$sTring: " & $sTring)
	; SetLog("$sItem: " & $sItem)
	; SetLog("$iSting: " & $iSting)
	If _LevDis($sTring, $sItem) <= ($iMaxDis * $iSting) Then
		Return True
	EndIf
	Return False
EndFunc   ;==>IsHonestOCR

Func NewBuildings()

	Local $Screencap = True, $Debug = False

	If _WaitForCheckImg(@ScriptDir & "\COCBot\Team__AiO__MOD++\Images\BuilderBase\Upgrade\New\", "14, 131, 847, 579", Default, 4500) Then ; Resolution changed
		Click($g_aImageSearchXML[0][1] - 100, $g_aImageSearchXML[0][2] + 100, 1)
		If _Sleep(2000) Then Return

		; Lets search for the Correct Symbol on field
		If QuickMIS("BC1", $g_sImgAutoUpgradeNewBldgYes, 150, 150 + $g_iMidOffsetYFixed, 650, 550 + $g_iBottomOffsetYFixed, $Screencap, $Debug) Then ; Resolution changed
			Click($g_iQuickMISX, $g_iQuickMISY, 1)
			SetLog("Placed a new Building on main village! [" & $g_iQuickMISX & "," & $g_iQuickMISY & "]", $COLOR_INFO)
			If _Sleep(1000) Then Return

			; Lets check if exist the [x] , Some Buildings like Traps when you place one will give other to place automaticly!
			If QuickMIS("BC1", $g_sImgAutoUpgradeNewBldgNo, 150, 150 + $g_iMidOffsetYFixed, 650, 550 + $g_iBottomOffsetYFixed, $Screencap, $Debug) Then ; Resolution changed
				Click($g_iQuickMISX, $g_iQuickMISY, 1)
			EndIf

			Return True
		Else
			If QuickMIS("BC1", $g_sImgAutoUpgradeNewBldgNo, 150, 150 + $g_iMidOffsetYFixed, 650, 550 + $g_iBottomOffsetYFixed, $Screencap, $Debug) Then ; Resolution changed
				SetLog("Sorry! Wrong place to deploy a new building! [" & $g_iQuickMISX & "," & $g_iQuickMISY & "]", $COLOR_ERROR)
				Click($g_iQuickMISX, $g_iQuickMISY, 1)
			Else
				SetLog("Error on Undo symbol!", $COLOR_ERROR)
			EndIf
		EndIf
	Else
		SetLog("Fail NewBuildings.", $COLOR_INFO)
		Click(820, 38, 1) ; exit from Shop
	EndIf
	
	CheckObstacles()
	Return False

EndFunc   ;==>NewBuildings
