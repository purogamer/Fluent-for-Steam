; #FUNCTION# ====================================================================================================================
; Name ..........: Collect
; Description ...:
; Syntax ........: Collect()
; Parameters ....:
; Return values .: None
; Author ........:
; Modified ......: Sardo (08/2015), KnowJack(10/2015), kaganus (10/2015), ProMac (04/2016), Codeslinger69 (01/2017), Fliegerfaust (11/2017), Boldina (30/2021)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once
#Region - Custom collect - Team AIO Mod++

Func CollectResourcesByPass()
	If Not $g_bChkCollect Or Not $g_bRunState Then Return
	If IsMainPage() Then
		; Setup arrays, including default return values for $return
		Local $sFileName = ""
		Local $aCollectXY, $t
		Local $aResult = returnMultipleMatchesOwnVillage($g_sImgCollectRessources)
		If UBound($aResult) > 1 Then ; we have an array with data of images found
			For $i = 1 To UBound($aResult) - 1 ; loop through array rows
				$sFileName = $aResult[$i][1] ; Filename
				$aCollectXY = $aResult[$i][5] ; Coords
				Switch StringLower($sFileName)
					Case "collectmines"
						If $g_iTxtCollectGold <> 0 And $g_aiCurrentLoot[$eLootGold] >= Number($g_iTxtCollectGold) Then
							SetLog("Gold is high enough, skip collecting", $COLOR_ACTION)
							ContinueLoop
						EndIf
					Case "collectelix"
						If $g_iTxtCollectElixir <> 0 And $g_aiCurrentLoot[$eLootElixir] >= Number($g_iTxtCollectElixir) Then
							SetLog("Elixir is high enough, skip collecting", $COLOR_ACTION)
							ContinueLoop
						EndIf
					Case "collectdelix"
						If $g_iTxtCollectDark <> 0 And $g_aiCurrentLoot[$eLootDarkElixir] >= Number($g_iTxtCollectDark) Then
							SetLog("Dark Elixir is high enough, skip collecting", $COLOR_ACTION)
							ContinueLoop
						EndIf
				EndSwitch
				
				If IsArray($aCollectXY) Then ; found array of locations
					$t = Random(0, UBound($aCollectXY) - 1, 1) ; SC May 2017 update only need to pick one of each to collect all
					SetDebugLog($sFileName & " found, random pick(" & $aCollectXY[$t][0] & "," & $aCollectXY[$t][1] & ")", $COLOR_GREEN)
					If IsMainPage() Then
						Click($aCollectXY[$t][0], $aCollectXY[$t][1], 1, 0, "#0430")
					Else
						ClickAway()
						If _Sleep(500) Then Return
						
						If Not IsMainPage() Then Return False
					EndIf
					If _Sleep($DELAYCOLLECT3) Then Return
				EndIf
			Next
		EndIf
	EndIf
EndFunc   ;==>CollectResourcesMini

Func Collect($bCheckTreasury = True, $bCollectCart = True)
	If Not $g_bChkCollect Or Not $g_bRunState Then Return

	ClickAway()
	
	StartGainCost()
	checkAttackDisable($g_iTaBChkIdle) ; Early Take-A-Break detection
#cs
	; Shooting a missile at a rooster - Forge - Team AIO Mod++
	Local $aDeployPointsResult = DMClassicArray(DFind($g_sForgeCollect, 172, 403, 683, 644, 0, 0, 1000, True), 10, $g_bDebugImageSave) ; _MultiPixelSearch(172, 403, 683, 638, 2, 2, Hex(0xCACBA8, 6), StringSplit2D("0xC2C69F/-1/2|0x9B08BB/9/7", "/", "|"), 25)

	If UBound($aDeployPointsResult) > 0 And not @error Then
		; Click($aDeployPointsResult[0], $aDeployPointsResult[1])
		Click($aDeployPointsResult[0][1], $aDeployPointsResult[0][2])
		If _Sleep(2000) Then Return
		
		If WaitforPixel(137, 346, 234, 375, Hex(0x89D335, 6), 20, 2) Then
			Click(Random(137, 234, 1), Random(346, 375, 1))
			If _Sleep(1500) Then Return
		EndIf
		
		ClickAway()
		
	EndIf
#Ce
	SetLog("Collecting Resources", $COLOR_INFO)
	If _Sleep($DELAYCOLLECT2) Then Return

	Local $bLootCartFirst = (Random(1, 25, 1) > 5) ? (True) : (False)
	If $bLootCartFirst And $g_bChkCollectLootCar And $bCollectCart And ($g_iTxtCollectGold = 0 Or $g_aiCurrentLoot[$eLootGold] < Number($g_iTxtCollectGold) Or $g_iTxtCollectElixir = 0 Or $g_aiCurrentLoot[$eLootElixir] < Number($g_iTxtCollectElixir) Or $g_iTxtCollectDark = 0 Or $g_aiCurrentLoot[$eLootDarkElixir] < Number($g_iTxtCollectDark)) Then CollectLootCart()

	; Setup arrays, including default return values for $return
	Local $sFileName = ""
	Local $aCollectXY, $t

	Local $aResult = returnMultipleMatchesOwnVillage($g_sImgCollectRessources)
	Local $aiLootPoint[2] = [0, 0] ; Magic items - AIO Team Mod++

	If UBound($aResult) > 1 Then ; we have an array with data of images found
		For $i = 1 To UBound($aResult) - 1 ; loop through array rows
			$sFileName = $aResult[$i][1] ; Filename
			$aCollectXY = $aResult[$i][5] ; Coords
			Switch StringLower($sFileName)
				Case "collectmines"
					If $g_iTxtCollectGold <> 0 And $g_aiCurrentLoot[$eLootGold] >= Number($g_iTxtCollectGold) Then
						SetLog("Gold is high enough, skip collecting", $COLOR_ACTION)
						ContinueLoop
					EndIf
				Case "collectelix"
					If $g_iTxtCollectElixir <> 0 And $g_aiCurrentLoot[$eLootElixir] >= Number($g_iTxtCollectElixir) Then
						SetLog("Elixir is high enough, skip collecting", $COLOR_ACTION)
						ContinueLoop
					EndIf
				Case "collectdelix"
					If $g_iTxtCollectDark <> 0 And $g_aiCurrentLoot[$eLootDarkElixir] >= Number($g_iTxtCollectDark) Then
						SetLog("Dark Elixir is high enough, skip collecting", $COLOR_ACTION)
						ContinueLoop
					EndIf
			EndSwitch
			; Local $bArrayExist = False
			If IsArray($aCollectXY) Then ; found array of locations
				$t = Random(0, UBound($aCollectXY) - 1, 1) ; SC May 2017 update only need to pick one of each to collect all
				SetDebugLog($sFileName & " found, random pick(" & $aCollectXY[$t][0] & "," & $aCollectXY[$t][1] & ")", $COLOR_GREEN)
				If IsMainPage() Then Click($aCollectXY[$t][0], $aCollectXY[$t][1], 1, 0, "#0430")

				$aiLootPoint[0] = Number($aCollectXY[$t][0]) ; Magic items - AIO Team Mod++
				$aiLootPoint[1] = Number($aCollectXY[$t][1]) ; Magic items - AIO Team Mod++

				If _Sleep($DELAYCOLLECT3) Then Return
			EndIf
		Next

		If IsArray($aiLootPoint) Then ResourceBoost($aiLootPoint[0], $aiLootPoint[1]) ; Magic items - AIO Team Mod++
	EndIf

	If _Sleep($DELAYCOLLECT3) Then Return
	checkMainScreen(False) ; check if errors during function

	If Not $bLootCartFirst And $g_bChkCollectLootCar And $bCollectCart And ($g_iTxtCollectGold = 0 Or $g_aiCurrentLoot[$eLootGold] < Number($g_iTxtCollectGold) Or $g_iTxtCollectElixir = 0 Or $g_aiCurrentLoot[$eLootElixir] < Number($g_iTxtCollectElixir) Or $g_iTxtCollectDark = 0 Or $g_aiCurrentLoot[$eLootDarkElixir] < Number($g_iTxtCollectDark)) Then CollectLootCart()

	If $g_bChkTreasuryCollect And $bCheckTreasury Then TreasuryCollect()
	EndGainCost("Collect")
EndFunc   ;==>Collect
#EndRegion - Custom collect - Team AIO Mod++

Func CollectLootCart()
	If Not $g_abNotNeedAllTime[0] Then
	    SetLog("Skipping loot cart check", $COLOR_INFO)
	    Return
	EndIf

	SetLog("Searching for a Loot Cart", $COLOR_INFO)

	Local $aLootCart = decodeSingleCoord(findImage("LootCart", $g_sImgCollectLootCart, GetDiamondFromRect("20,176,120,246"), 1, True)) ; Resolution changed
	If UBound($aLootCart) > 1 Then
		$aLootCart[1] += 15
		If IsMainPage() Then ClickP($aLootCart, 1, 0, "#0330")
		If _Sleep(400) Then Return

		Local $aiCollectButton = findButton("CollectLootCart", Default, 1, True)
		If IsArray($aiCollectButton) And UBound($aiCollectButton) = 2 Then
			SetLog("Clicking to collect loot cart.", $COLOR_SUCCESS)
			ClickP($aiCollectButton)
		Else
			SetLog("Cannot find Collect Button", $COLOR_ERROR)
			Return False
		EndIf

	Else
		SetLog("No Loot Cart found on your Village", $COLOR_SUCCESS)
	EndIf

	$g_abNotNeedAllTime[0] = False
EndFunc   ;==>CollectLootCart

