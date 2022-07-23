; #FUNCTION# ====================================================================================================================
; Name ..........: BuilderBaseReport()
; Description ...: Make Resources report of Builders Base
; Syntax ........: BuilderBaseReport()
; Parameters ....:
; Return values .: None
; Author ........: ProMac (05-2017)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func BuilderBaseReport($bBypass = False, $bSetLog = True)
	ClickAway()
	If _Sleep($DELAYVILLAGEREPORT1) Then Return

	Switch $bBypass
		Case False
			If $bSetLog Then SetLog("Builder Base Report", $COLOR_INFO)
		Case True
			If $bSetLog Then SetLog("Updating Builder Base Resource Values", $COLOR_INFO)
		Case Else
			If $bSetLog Then SetLog("Builder Base Village Report Error, You have been a BAD programmer!", $COLOR_ERROR)
	EndSwitch

	If Not $bSetLog Then SetLog("Builder Base Village Report", $COLOR_INFO)

	getBuilderCount($bSetLog, True) ; update builder data
	If _Sleep($DELAYRESPOND) Then Return

	$g_aiCurrentLootBB[$eLootTrophyBB] = getTrophyMainScreen(67, 84)
	$g_aiCurrentLootBB[$eLootGoldBB] = getResourcesMainScreen(705, 23)
	$g_aiCurrentLootBB[$eLootElixirBB] = getResourcesMainScreen(705, 72)
	$g_iGemAmount = getResourcesMainScreen(740, 120)
	If $bSetLog Then SetLog(" [G]: " & _NumberFormat($g_aiCurrentLootBB[$eLootGoldBB]) & " [E]: " & _NumberFormat($g_aiCurrentLootBB[$eLootElixirBB]) & "[T]: " & _NumberFormat($g_aiCurrentLootBB[$eLootTrophyBB]), $COLOR_SUCCESS)
	
	BuilderBaseReportAttack(False) ; Custom BB
	
	If Not $bBypass Then ; update stats
		BuilderBaseStats() ;UpdateStats()
	EndIf
EndFunc   ;==>BuilderBaseReport

Func BuilderBaseStats()
	GUICtrlSetData($g_hLblBBResultGoldNow, _NumberFormat($g_aiCurrentLootBB[$eLootGoldBB], True))
	GUICtrlSetData($g_hLblBBResultElixirNow, _NumberFormat($g_aiCurrentLootBB[$eLootElixirBB], True))
	GUICtrlSetData($g_hLblBBResultTrophyNow, _NumberFormat($g_aiCurrentLootBB[$eLootTrophyBB], True))
	GUICtrlSetData($g_hLblBBResultBuilderNow, $g_iFreeBuilderCountBB & "/" & $g_iTotalBuilderCountBB)
	GUICtrlSetData($g_hLblResultGemNow, $g_iGemAmount)

	GUICtrlSetState($g_hLblVillageReportTemp, $GUI_HIDE)
	GUICtrlSetState($g_hPicResultGoldTemp, $GUI_HIDE)
	GUICtrlSetState($g_hPicResultElixirTemp, $GUI_HIDE)
	GUICtrlSetState($g_hPicResultDETemp, $GUI_HIDE)
	GUICtrlSetState($g_hLblResultGoldNow, $GUI_SHOW + $GUI_DISABLE) ; $GUI_DISABLE to trigger default view in btnVillageStat
	GUICtrlSetState($g_hPicResultGoldNow, $GUI_SHOW)
	GUICtrlSetState($g_hLblResultElixirNow, $GUI_SHOW)
	GUICtrlSetState($g_hPicResultElixirNow, $GUI_SHOW)
	GUICtrlSetState($g_hPicResultDEStart, $GUI_HIDE)
	GUICtrlSetState($g_hPicDarkLoot, $GUI_HIDE)
	GUICtrlSetState($g_hPicDarkLastAttack, $GUI_HIDE)
	GUICtrlSetState($g_hPicHourlyStatsDark, $GUI_HIDE)
	GUICtrlSetState($g_hLblResultTrophyNow, $GUI_SHOW)
	GUICtrlSetState($g_hLblResultBuilderNow, $GUI_SHOW)
	GUICtrlSetState($g_hLblResultGemNow, $GUI_SHOW)
	$g_iFirstRun = 0
	btnVillageStat("UpdateStats")
EndFunc   ;==>BuilderBaseStats
