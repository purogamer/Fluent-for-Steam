; #FUNCTION# ====================================================================================================================
; Name ..........: MOD GUI Design MOD - Debug.au3
; Description ...: This file creates the "Debug" Tab Under "MOD" Tab
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Chilly-Chill
; Modified ......: Boldina !
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Global $g_hBtnTestSuperXP = 0, $g_hBtnTestBotHumanization = 0, $g_hBtnTestClanChat = 0, $g_hBtnTestFriendlyChallenge = 0, $g_hBtnTestReadChat = 0, _
$g_hBtnTestDailyDiscounts = 0, $g_hBtnTestAttackBB = 0, $g_hBtnTestStopForWar = 0, $g_hBtnTestGTFO = 0, $g_hBtnCheckQueueTroops = 0, $g_hBtnCheckQueueSpells = 0

Func TabDebugGUI()
	Local $x = 25, $y = 45
	GUICtrlCreateGroup("Debug", $x - 20, $y - 20, $g_iSizeWGrpTab2, $g_iSizeHGrpTab2)
	$x = 300
	$y = 40
		$g_hBtnTestSuperXP = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "BtnTestSuperXP", "Test SuperXP"), $x, $y, 140, 25)
		GUICtrlSetOnEvent(-1, "btnTestSuperXP")

	$y += 30
		$g_hBtnTestBotHumanization = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "BtnTestBotHumanization", "Test Humanization"), $x, $y, 140, 25)
		GUICtrlSetOnEvent(-1, "btnTestBotHumanization")

	$y += 30
		$g_hBtnTestClanChat = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "BtnTestClanChat", "Test ClanChat"), $x, $y, 140, 25)
		GUICtrlSetOnEvent(-1, "btnTestClanChat")

	$y += 30
		$g_hBtnTestReadChat = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "BtnTestReadChat", "Test ReadChat"), $x, $y, 140, 25)
		GUICtrlSetOnEvent(-1, "btnTestReadChat")

	$y += 30
		$g_hBtnTestFriendlyChallenge = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "BtnTestFriendChallenge", "Test FriendChallenge"), $x, $y, 140, 25)
		GUICtrlSetOnEvent(-1, "btnTestFriendlyChallenge")


	$y += 30
		$g_hBtnTestDailyDiscounts = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "BtnTestDailyDiscounts", "Test DailyDiscounts"), $x, $y, 140, 25)
		GUICtrlSetOnEvent(-1, "btnTestDailyDiscounts")

	$y += 30
		$g_hBtnTestAttackBB = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "BtnTestAttackBB", "Test AttackBB"), $x, $y, 140, 25)
		GUICtrlSetOnEvent(-1, "btnTestAttackBB")

	$y += 30
		$g_hBtnTestStopForWar = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "BtnTestStopForWar", "Test Stop For War"), $x, $y, 140, 25)
		GUICtrlSetOnEvent(-1, "btnTestStopForWar")

	$y += 30
		$g_hBtnTestGTFO = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "BtnTestGTFO", "Test GTFO"), $x, $y, 140, 25)
	    GUICtrlSetOnEvent(-1, "btnTestGTFO")

	$y += 30
		$g_hBtnCheckQueueTroops = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "CheckQueueTroops", "Test CheckQueueTroops"), $x, $y, 140, 25)
	    GUICtrlSetOnEvent(-1, "btnTestCheckQueueTroops")

	$y += 30
		$g_hBtnCheckQueueSpells = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "CheckQueueSpells", "Test CheckQueueSpells"), $x, $y, 140, 25)
	    GUICtrlSetOnEvent(-1, "btnTestCheckQueueSpells")

	 ; TestRequestDefense TestCollectorsOutside
	GUICtrlCreateGroup("", -99, -99, 1, 1)
EndFunc   ;==>TabDebugGUI
