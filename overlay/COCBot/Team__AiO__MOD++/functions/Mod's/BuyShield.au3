; #FUNCTION# ====================================================================================================================
; Name ..........: BuyShield.au3
; Description ...: Buy guard every 24 hours.
; Syntax ........: BuyGuard()
; Parameters ....: 
; Return values .: 
; Author ........: Boldina / TheExtractor (05-2021)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2021
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func BuyGuard($bDebug = False)
	If Not $g_bChkBuyGuard Or $g_iUnbrkMode = 1 Then Return
	Local $bReturn = False
	
	SetLog("Start Buy Two Hour Guard Check", $COLOR_INFO)
	
	If IsMainPage(5) Then
		$g_iStatsLastAttack[$eLootTrophy] = getResourcesLootT(403, 402 + $g_iMidOffsetY)
	
		If $g_iStatsLastAttack[$eLootTrophy] >= 5000 Then
			SetLog("Buy guard skipped in legend league, can't be possible.", $COLOR_INFO)
			Return True
		EndIf
		
		If CheckShield() Then
			If IsShopOpen() Then
				SetLog("Shop Window Opened.", $COLOR_SUCCESS)
				If IsGuardAvailable() Then
					If GemOcr() Then
						If $bDebug = False Then
							Click(430, 429, 1)
						Else
							ClickAway()
						EndIf
						If _Sleep($DELAYBOOSTHEROES4) Then Return
						If IsArray(findButton("EnterShop")) Then
							SetLog("Not enough gems to buy two hours Guard.", $COLOR_ERROR)
							ClickAway()
							If _Sleep($DELAYRUNBOT3) Then Return
						Else
							SetLog("Two hours Guard Successfully Activated.", $COLOR_SUCCESS)
							If _Sleep($DELAYRUNBOT1) Then Return
							
							$bReturn = True
						EndIf
					Else
						ClickAway()
						If _Sleep($DELAYRUNBOT3) Then Return
					EndIf
				EndIf
			EndIf
		EndIf
	Else
		SetLog("Unable To Find Main Page, Skip Buy Guard Check.", $COLOR_ERROR)
	EndIf
	
	If $bReturn = False Then CloseShop()
	
	CheckMainScreen()
EndFunc   ;==>BuyGuard

Func IsGuardAvailable()
	If _CheckPixel($g_aGuardAvailable, True, Default, "GuardAvailable", $COLOR_DEBUG) = True Then
		Click($g_aGuardAvailable[0] - 30, $g_aGuardAvailable[1] + 30, 1)
		If _Wait4Pixel($aIsGemWindow1[0], $aIsGemWindow1[1], $aIsGemWindow1[2], $aIsGemWindow1[3], 2000, "IsGemWindow1") Then
			Return True
		Else
			SetLog("Sorry, two hours Guard Gem Window Did Not Opened.", $COLOR_INFO)
		EndIf
	Else
		SetLog("Sorry, two hours Guard is not available yet.", $COLOR_INFO)
	EndIf
	Return False
EndFunc   ;==>IsGuardAvailable

Func CloseShop($bForce = False)
	If $bForce Or _CheckPixel($g_aShopOpen, True, Default, "ChkShopOpen", $COLOR_DEBUG) = True Then
		Click($g_aShopOpen[0], $g_aShopOpen[1], 1)
		If _Sleep($DELAYRUNBOT5) Then Return
	EndIf
EndFunc   ;==>CloseShop

Func IsShopOpen()
	Click(578, 30, 1)
	If _Wait4Pixel($g_aShopOpen[0], $g_aShopOpen[1], $g_aShopOpen[2], $g_aShopOpen[3], 3000, "IsShopOpen") Then
		Return True
	Else
		SetLog("Sorry, Shop Did Not Opened.", $COLOR_ERROR)
	EndIf
	Return False
EndFunc   ;==>IsShopOpen

Func GemOcr()
	Local $iGemOcr = getOcrAndCaptureDOCR($g_sASGemsSDOCRPath, 343, 390, 172, 67, True, True)
	$iGemOcr = StringStripWS($iGemOcr, $STR_STRIPALL)
	SetDebugLog("Gem: " & $iGemOcr)
	If $iGemOcr <> "none" Then
		If Int($iGemOcr) = 10 Then 
			Return True
		EndIf
	EndIf
	Return False
EndFunc   ;==>GemOcr

Func CheckShield()
	_CaptureRegion()
	If _CheckPixel($aNoShield, False) Or _CheckPixel($aHavePerGuard, False) Then
		Return True
	ElseIf _CheckPixel($aHaveShield, False) Then
		SetLog("Shield Active, Skip Buy Guard Check.", $COLOR_INFO)
	EndIf
	Return False
EndFunc   ;==>CheckShield

