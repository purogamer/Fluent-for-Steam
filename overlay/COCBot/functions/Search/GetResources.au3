; #FUNCTION# ====================================================================================================================
; Name ..........: MBR Bot
; Description ...: Uses the ColorCheck until the screen is clear from Clouds to Get Resources values.
; Author ........: HungLe (2015)
; Modified ......: ProMac (2015), Hervidero (2015), MonkeyHunter (08-2016)(05-2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Func GetResources($bLog = True, $pMatchMode = -1) ;Reads resources
	Static $iStuck = 0, $iSearchGold2 = 0, $iSearchElixir2 = 0

	If _Sleep($DELAYRESPOND) Then Return
	$g_iSearchGold = ""
	$g_iSearchElixir = ""
	$g_iSearchDark = ""
	$g_iSearchTrophy = ""

	SuspendAndroid()

	Local $iCount = 0
	While (getGoldVillageSearch(48, 69) = "") Or (getElixirVillageSearch(48, 69 + 29) = "")
		$iCount += 1
		If _Sleep($DELAYGETRESOURCES3) Then Return
		If $iCount >= 50 Or isProblemAffect(True) Then ExitLoop ; Wait 50*150ms=7.5 seconds max to read resources
	WEnd

	If _Sleep($DELAYRESPOND) Then Return
	$g_iSearchGold = getGoldVillageSearch(48, 69)
	If _Sleep($DELAYRESPOND) Then Return
	$g_iSearchElixir = getElixirVillageSearch(48, 69 + 29)
	If _Sleep($DELAYRESPOND) Then Return
	If _CheckPixel($aAtkHasDarkElixir, $g_bCapturePixel, Default, "HasDarkElixir1") Or  _ColorCheck(_GetPixelColor(31, 144, True), Hex(0x0F0617, 6), 5)  Then ; check if the village have a Dark Elixir Storage
		$g_iSearchDark = getDarkElixirVillageSearch(48, 126)
		$g_iSearchTrophy = getTrophyVillageSearch(45, 168)
	Else
		$g_iSearchDark = "N/A"
		$g_iSearchTrophy = getTrophyVillageSearch(48, 69 + 69)
	EndIf

	If $g_iSearchGold = $iSearchGold2 And $g_iSearchElixir = $iSearchElixir2 Then $iStuck += 1
	If $g_iSearchGold <> $iSearchGold2 Or $g_iSearchElixir <> $iSearchElixir2 Then $iStuck = 0

	$iSearchGold2 = $g_iSearchGold
	$iSearchElixir2 = $g_iSearchElixir

	If $iStuck >= 5 Or isProblemAffect(True) Then
		$iStuck = 0
		resetAttackSearch(True)
		Return
	EndIf

	$g_iSearchCount += 1 ; Counter for number of searches

	ResumeAndroid()

EndFunc   ;==>GetResources

Func resetAttackSearch($bStuck = False)
	; function to check main screen and restart search and display why as needed
	$g_bIsClientSyncError = True
	checkMainScreen()
	If $g_bRestart Then
		$g_iNbrOfOoS += 1
		UpdateStats()
		If $bStuck Then
			SetLog("Connection Lost While Searching", $COLOR_ERROR)
		Else
			SetLog("Disconnected At Search Clouds", $COLOR_ERROR)
		EndIf
		PushMsg("OoSResources")
	Else
		If $bStuck Then
			SetLog("Attack Is Disabled Or Slow connection issues, Restarting CoC and Bot...", $COLOR_ERROR)
		Else
			SetLog("Stuck At Search Clouds, Restarting CoC and Bot...", $COLOR_ERROR)
		EndIf
		$g_bIsClientSyncError = False ; disable fast OOS restart if not simple error and restarting CoC
		CloseCoC(True)
	EndIf
	Return
EndFunc   ;==>resetAttackSearch
