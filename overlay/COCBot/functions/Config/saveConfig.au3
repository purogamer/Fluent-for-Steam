; #FUNCTION# ====================================================================================================================
; Name ..........: saveConfig.au3
; Description ...: Saves all of the GUI values to the config.ini and building.ini files
; Syntax ........: saveConfig()
; Parameters ....: NA
; Return values .: NA
; Author ........:
; Modified ......: CodeSlinger69 (01-2018)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func saveConfig()

	If $g_iGuiMode = 0 Then Return

	If $g_bSaveConfigIsActive Then
		SetDebugLog("saveConfig(), already running, exit")
		Return
	EndIf
	$g_bSaveConfigIsActive = True

	Local $t = __TimerInit()

	Static $iSaveConfigCount = 0
	$iSaveConfigCount += 1
	SetDebugLog("saveConfig(), call number " & $iSaveConfigCount)

	SaveProfileConfig()

	SaveWeakBaseStats()
	;SetDebugLog("saveWeakBaseStats(), time = " & Round(__TimerDiff($t)/1000, 2) & " sec")

	SaveBuildingConfig()
	;SetDebugLog("SaveBuildingConfig(), time = " & Round(__TimerDiff($t)/1000, 2) & " sec")

	SaveRegularConfig()
	;SetDebugLog("SaveRegularConfig(), time = " & Round(__TimerDiff($t)/1000, 2) & " sec")

	SaveClanGamesConfig()
	;SetDebugLog("SaveClanGamesConfig(), time = " & Round(__TimerDiff($t)/1000, 2) & " sec")

	SetDebugLog("SaveConfig(), time = " & Round(__TimerDiff($t) / 1000, 2) & " sec")

	$g_bSaveConfigIsActive = False
EndFunc   ;==>saveConfig

Func SaveProfileConfig($sIniFile = Default, $bForceWrite = False)
	If $sIniFile = Default Then $sIniFile = $g_sProfilePath & "\profile.ini"
	IniWrite($sIniFile, "general", "defaultprofile", $g_sProfileCurrentName)
	If $bForceWrite Or Int(IniRead($sIniFile, "general", "globalactivebotsallowed", 0)) = 0 Then
		IniWrite($sIniFile, "general", "globalactivebotsallowed", $g_iGlobalActiveBotsAllowed)
	EndIf
	If $bForceWrite Or IniRead($sIniFile, "general", "globalthreads", "-") = "-" Then
		IniWrite($sIniFile, "general", "globalthreads", $g_iGlobalThreads)
	EndIf
	; Not used anymore since MBR v7.6.7
	;_SaveProfileConfigAdbPath($sIniFile)
EndFunc   ;==>SaveProfileConfig

Func _SaveProfileConfigAdbPath($sIniFile = Default, $sAdbPath = $g_sAndroidAdbPath)
	If $sIniFile = Default Then $sIniFile = $g_sProfilePath & "\profile.ini"
	IniWrite($sIniFile, "general", "adb.path", $sAdbPath)
EndFunc   ;==>SaveProfileConfigAdbPath

Func SaveWeakBaseStats()
	_Ini_Clear()

	; Loop through the current stats
	For $j = 0 To UBound($g_aiWeakBaseStats) - 1
		; Write the new value to the stats file
		_Ini_Add("WeakBase", $g_aiWeakBaseStats[$j][0], $g_aiWeakBaseStats[$j][1])
	Next

	_Ini_Save($g_sProfileBuildingStatsPath)
EndFunc   ;==>SaveWeakBaseStats

Func SaveBuildingConfig()
	SetDebugLog("Save Building Config " & $g_sProfileBuildingPath)
	_Ini_Clear()

	_Ini_Add("general", "version", GetVersionNormalized($g_sBotVersion))

	;Upgrades
	_Ini_Add("upgrade", "LabPosX", $g_aiLaboratoryPos[0])
	_Ini_Add("upgrade", "LabPosY", $g_aiLaboratoryPos[1])

	_Ini_Add("upgrade", "PetHousePosX", $g_aiPetHousePos[0])
	_Ini_Add("upgrade", "PetHousePosY", $g_aiPetHousePos[1])

	_Ini_Add("upgrade", "StarLabPosX", $g_aiStarLaboratoryPos[0])
	_Ini_Add("upgrade", "StarLabPosY", $g_aiStarLaboratoryPos[1])

	_Ini_Add("other", "xTownHall", $g_aiTownHallPos[0])
	_Ini_Add("other", "yTownHall", $g_aiTownHallPos[1])
	_Ini_Add("other", "LevelTownHall", $g_iTownHallLevel)

	_Ini_Add("other", "xCCPos", $g_aiClanCastlePos[0])
	_Ini_Add("other", "yCCPos", $g_aiClanCastlePos[1])

	_Ini_Add("other", "totalcamp", $g_iTotalCampSpace)

	;_Ini_Add("other", "xspellfactory", $SFPos[0])
	;_Ini_Add("other", "yspellfactory", $SFPos[1])

	;_Ini_Add("other", "xDspellfactory", $DSFPos[0])
	;_Ini_Add("other", "yDspellfactory", $DSFPos[1])

	_Ini_Add("other", "xKingAltarPos", $g_aiKingAltarPos[0])
	_Ini_Add("other", "yKingAltarPos", $g_aiKingAltarPos[1])

	_Ini_Add("other", "xQueenAltarPos", $g_aiQueenAltarPos[0])
	_Ini_Add("other", "yQueenAltarPos", $g_aiQueenAltarPos[1])

	_Ini_Add("other", "xWardenAltarPos", $g_aiWardenAltarPos[0])
	_Ini_Add("other", "yWardenAltarPos", $g_aiWardenAltarPos[1])

	_Ini_Add("other", "xChampionAltarPos", $g_aiChampionAltarPos[0])
	_Ini_Add("other", "yChampionAltarPos", $g_aiChampionAltarPos[1])

	_Ini_Add("upgrade", "xLastGoodWallPos", $g_aiLastGoodWallPos[0])
	_Ini_Add("upgrade", "yLastGoodWallPos", $g_aiLastGoodWallPos[1])

	; <><><><> Village / Upgrade - Lab <><><><>
	ApplyConfig_600_14(GetApplyConfigSaveAction())
	_Ini_Add("upgrade", "upgradetroops", $g_bAutoLabUpgradeEnable ? 1 : 0)
	_Ini_Add("upgrade", "upgradetroopname", $g_iCmbLaboratory)
	_Ini_Add("upgrade", "upgradelabelexircost", $g_iLaboratoryElixirCost)
	_Ini_Add("upgrade", "upgradelabdelexircost", $g_iLaboratoryDElixirCost)
	_Ini_Add("upgrade", "upgradestartroops", $g_bAutoStarLabUpgradeEnable ? 1 : 0)
	_Ini_Add("upgrade", "upgradestartroopname", $g_iCmbStarLaboratory)

	#Region - Custom lab - Team AIO Mod++
    ;xbenk
    _Ini_Add("upgrade", "upgradeorder", $g_bLabUpgradeOrderEnable ? 1 : 0)
    Local $string = ""
    For $i = 0 To UBound($g_aCmbLabUpgradeOrder) - 1
        $string &= $g_aCmbLabUpgradeOrder[$i] & "|"
    Next
    _Ini_Add("upgrade", "upgradeorderlist", $string)

    _Ini_Add("upgrade", "Supgradeorder", $g_bSLabUpgradeOrderEnable ? 1 : 0)
    Local $string = ""
    For $i = 0 To UBound($g_aCmbSLabUpgradeOrder) - 1
        $string &= $g_aCmbSLabUpgradeOrder[$i] & "|"
    Next
    _Ini_Add("upgrade", "Supgradeorderlist", $string)

    #EndRegion - Custom lab - Team AIO Mod++

	; <><><><> Village / Upgrade - Buildings <><><><>
	ApplyConfig_600_16(GetApplyConfigSaveAction())
	For $iz = 0 To UBound($g_avBuildingUpgrades, 1) - 1
		_Ini_Add("upgrade", "xupgrade" & $iz, $g_avBuildingUpgrades[$iz][0])
		_Ini_Add("upgrade", "yupgrade" & $iz, $g_avBuildingUpgrades[$iz][1])
		_Ini_Add("upgrade", "upgradevalue" & $iz, $g_avBuildingUpgrades[$iz][2])
		_Ini_Add("upgrade", "upgradetype" & $iz, $g_avBuildingUpgrades[$iz][3])
		_Ini_Add("upgrade", "upgradename" & $iz, $g_avBuildingUpgrades[$iz][4])
		_Ini_Add("upgrade", "upgradelevel" & $iz, $g_avBuildingUpgrades[$iz][5])
		_Ini_Add("upgrade", "upgradetime" & $iz, $g_avBuildingUpgrades[$iz][6])
		_Ini_Add("upgrade", "upgradeend" & $iz, $g_avBuildingUpgrades[$iz][7])
		_Ini_Add("upgrade", "upgradechk" & $iz, $g_abBuildingUpgradeEnable[$iz] ? 1 : 0)
		_Ini_Add("upgrade", "upgraderepeat" & $iz, $g_abUpgradeRepeatEnable[$iz] ? 1 : 0)
		_Ini_Add("upgrade", "upgradestatusicon" & $iz, $g_aiPicUpgradeStatus[$iz])
	Next

	#Region - Dates - Team AIO Mod++
	_Ini_Add("Dates", "DateAndTimeMagicItems", $g_sDateAndTimeMagicItems)
	_Ini_Add("Dates", "DateAndTimeHeroWUE", $g_sDateAndTimeHeroWUE)
#cs
	_Ini_Add("Dates", "DateAndTimeKing", $g_sDateAndTimeKing)
	_Ini_Add("Dates", "DateAndTimeQueen", $g_sDateAndTimeQueen)
	_Ini_Add("Dates", "DateAndTimeWarden", $g_sDateAndTimeWarden)
	_Ini_Add("Dates", "DateAndTimeChampion", $g_sDateAndTimeChampion)
#ce
	_Ini_Add("Dates", "BuilderBaseTimer", $g_sDateBuilderBase)
	
	; Custom boost - Team AIO Mod++
	_Ini_Add("Dates", "BoostEverythingTime", $g_sBoostEverythingTime)
	#EndRegion - Dates - Team AIO Mod++

	_Ini_Save($g_sProfileBuildingPath)
EndFunc   ;==>SaveBuildingConfig

Func SaveRegularConfig()
	SetDebugLog("Save Config " & $g_sProfileConfigPath)
	_Ini_Clear()

	; General information
	_Ini_Add("general", "version", GetVersionNormalized($g_sBotVersion))

	_Ini_Add("general", "threads", $g_iThreads)
	_Ini_add("general", "botDesignFlags", $g_iBotDesignFlags)

	; Window positions
	_Ini_Add("general", "frmBotPosX", $g_iFrmBotPosX)
	_Ini_Add("general", "frmBotPosY", $g_iFrmBotPosY)
	; read now android position again, as it might have changed
	If $g_hAndroidWindow <> 0 Then WinGetAndroidHandle()
	_Ini_Add("general", "AndroidPosX", $g_iAndroidPosX)
	_Ini_Add("general", "AndroidPosY", $g_iAndroidPosY)
	_Ini_Add("general", "frmBotDockedPosX", $g_iFrmBotDockedPosX)
	_Ini_Add("general", "frmBotDockedPosY", $g_iFrmBotDockedPosY)

	; Redraw mode
	_Ini_Add("general", "RedrawBotWindowMode", $g_iRedrawBotWindowMode)

	; <><><> Attack Plan / Train Army / Options <><><>
	SaveConfig_Android()
	; <><><><> Log window <><><><>
	SaveConfig_600_1()
	; <><><><> Village / Misc <><><><>
	SaveConfig_600_6()
	; <><><><> Village / Achievements <><><><>
	SaveConfig_600_9()
	; <><><><> Village / Donate - Request <><><><>
	SaveConfig_600_11()
	; <><><><> Village / Donate - Donate <><><><>
	SaveConfig_600_12()
	; <><><><> Village / Donate - Schedule <><><><>
	SaveConfig_600_13()
	; <><><><> Village / Upgrade - Heroes <><><><>
	SaveConfig_600_15()
	; <><><><> Village / Upgrade - Buildings <><><><>
	SaveConfig_600_16()
	; <><><><> Village / Upgrade - Auto Upgrade <><><><>
	SaveConfig_auto()
	; <><><><> Village / Upgrade - Walls <><><><>
	SaveConfig_600_17()
	; <><><><> Village / Notify <><><><>
	SaveConfig_600_18()
	; <><><><> Village / Notify <><><><>
	SaveConfig_600_19()
	; <><><> Attack Plan / Train Army / Boost <><><>
	SaveConfig_600_22()
	; <><><><> Attack Plan / Search & Attack / Bully <><><><>
	SaveConfig_600_26()
	; <><><><> Attack Plan / Search & Attack / Options / Search <><><><>
	SaveConfig_600_28()
	; <><><><> Attack Plan / Search & Attack / Deadbase / Search <><><><>
	SaveConfig_600_28_DB()
	; <><><><> Attack Plan / Search & Attack / Activebase / Search <><><><>
	SaveConfig_600_28_LB()
	; <><><><> Attack Plan / Search & Attack / Options / Attack <><><><>
	SaveConfig_600_29()
	; <><><><> Attack Plan / Search & Attack / Deadbase / Attack <><><><>
	SaveConfig_600_29_DB()
	; <><><><> Attack Plan / Search & Attack / Activebase / Attack <><><><>
	SaveConfig_600_29_LB()
	; <><><><> Attack Plan / Search & Attack / Options / End Battle <><><><>
	SaveConfig_600_30()
	; <><><><> Attack Plan / Search & Attack / Deadbase / End Battle <><><><>
	SaveConfig_600_30_DB()
	; <><><><> Attack Plan / Search & Attack / Activebase / End Battle <><><><>
	SaveConfig_600_30_LB()
	; <><><><> Attack Plan / Search & Attack / Deadbase / Collectors <><><><>
	SaveConfig_600_31()
	; <><><><> Attack Plan / Search & Attack / Options / Trophy Settings <><><><>
	SaveConfig_600_32()
	; <><><><> Attack Plan / Search & Attack / Drop Order Troops <><><><>
	SaveConfig_600_33()
	; <><><><> Bot / Options <><><><>
	SaveConfig_600_35_1()
	; <><><><> Bot / Profile / Switch Accounts <><><><>
	SaveConfig_600_35_2()
	; <><><> Attack Plan / Train Army / Troops/Spells <><><>
	; Quick train
	SaveConfig_600_52_1()
	; troop/spell levels and counts
	SaveConfig_600_52_2()
	; <><><> Attack Plan / Train Army / Train Order <><><>
	SaveConfig_600_54()
	; <><><><> Attack Plan / Search & Attack / Options / SmartZap <><><><>
	SaveConfig_600_56()
	; <><><> Attack Plan / Train Army / Options <><><>
	SaveConfig_641_1()
	; <><><><> Bot / Debug <><><><>
	SaveConfig_Debug()

	; <><><> Team AiO MOD++ (2019) <><><>
	; <><><> MiscTab <><><>
	SaveConfig_MOD_MiscTab()
	SaveConfig_MOD_CustomArmyBB()
	; <><><> SuperXP / GoblinXP <><><>
	SaveConfig_MOD_SuperXP()
	; <><><> ChatActions <><><>
	SaveConfig_MOD_ChatActions()
	; <><><> MagicItems <><><>
	SaveConfig_MOD_MagicItems()
	; <><><> Daily Discounts + Builder Base Attack + Builder Base Drop Order <><><>
	SaveConfig_MOD_600_6()
	; <><><> GTFO <><><>
	SaveConfig_MOD_600_12()
	; <><><> Max logout time <><><>
	SaveConfig_MOD_600_28()
	; <><><> Classic Four Finger + CSV Deploy Speed <><><>
	SaveConfig_MOD_600_29()
	; <><><> Check Collectors Outside <><><>
	SaveConfig_MOD_600_31()
	; <><><> Auto Dock, Hide Emulator & Bot <><><>
	SaveConfig_MOD_600_35_1()
	; <><><><> Switch Profiles <><><><>
	SaveConfig_MOD_600_35_2()
	; <><><> Humanization <><><>
	SaveConfig_MOD_Humanization()
	; <><><> Attack Plan / Train Army / Boost <><><>
	SaveConfig_MOD_OneGem()

	; <><><><> Attack Plan / Strategies <><><><>
	; <<< nothing here >>>

	; <><><><> Bot / Profiles <><><><>
	; <<< nothing here >>>

	; <><><><> Bot / Stats <><><><>
	; <<< nothing here >>>

	;SetDebugLog("saveConfig: Wrote " & $g_iIniLineCount & " ini lines.")
	_Ini_Save($g_sProfileConfigPath)
EndFunc   ;==>SaveRegularConfig

Func SaveConfig_Android()
	; <><><><> Bot / Android <><><><>
	ApplyConfig_Android(GetApplyConfigSaveAction())
	_Ini_Add("android", "game.distributor", $g_sAndroidGameDistributor)
	_Ini_Add("android", "game.package", $g_sAndroidGamePackage)
	_Ini_Add("android", "appActitivityName", $g_sAndroidGameClass)
	_Ini_Add("android", "user.distributor", $g_sUserGameDistributor)
	_Ini_Add("android", "user.package", $g_sUserGamePackage)
	_Ini_Add("android", "UserAppActitivityName", $g_sUserGameClass)
	_Ini_Add("android", "backgroundmode", $g_iAndroidBackgroundMode)
	_Ini_Add("android", "zoomoutmode", $g_iAndroidZoomoutMode)
	_Ini_Add("android", "adb.replace", $g_iAndroidAdbReplace)
	_Ini_Add("android", "check.time.lag.enabled", ($g_bAndroidCheckTimeLagEnabled ? "1" : "0"))
	_Ini_Add("android", "adb.dedicated.instance", ($g_bAndroidAdbPortPerInstance ? "1" : "0"))
	_Ini_Add("android", "adb.screencap.timeout.min", $g_iAndroidAdbScreencapTimeoutMin)
	_Ini_Add("android", "adb.screencap.timeout.max", $g_iAndroidAdbScreencapTimeoutMax)
	_Ini_Add("android", "adb.screencap.timeout.dynamic", $g_iAndroidAdbScreencapTimeoutDynamic)
	_Ini_Add("android", "adb.input.enabled", ($g_bAndroidAdbInputEnabled ? "1" : "0"))
	_Ini_Add("android", "adb.click.enabled", ($g_bAndroidAdbClickEnabled ? "1" : "0"))
	_Ini_Add("android", "adb.click.drag.script", ($g_bAndroidAdbClickDragScript ? "1" : "0"))
	_Ini_Add("android", "adb.click.group", $g_iAndroidAdbClickGroup)
	_Ini_Add("android", "adb.clicks.enabled", ($g_bAndroidAdbClicksEnabled ? "1" : "0"))
	_Ini_Add("android", "adb.clicks.troop.deploy.size", $g_iAndroidAdbClicksTroopDeploySize)
	_Ini_Add("android", "no.focus.tampering", ($g_bNoFocusTampering ? "1" : "0"))
	_Ini_Add("android", "shield.color", Hex($g_iAndroidShieldColor, 6))
	_Ini_Add("android", "shield.transparency", $g_iAndroidShieldTransparency)
	_Ini_Add("android", "active.color", Hex($g_iAndroidActiveColor, 6))
	_Ini_Add("android", "active.transparency", $g_iAndroidActiveTransparency)
	_Ini_Add("android", "inactive.color", Hex($g_iAndroidInactiveColor, 6))
	_Ini_Add("android", "inactive.transparency", $g_iAndroidInactiveTransparency)
	_Ini_Add("android", "suspend.mode", $g_iAndroidSuspendModeFlags)
	_Ini_Add("android", "emulator", $g_sAndroidEmulator)
	_Ini_Add("android", "instance", $g_sAndroidInstance)
	_Ini_Add("android", "reboot.hours", $g_iAndroidRebootHours)
	_Ini_Add("android", "close", ($g_bAndroidCloseWithBot ? "1" : "0"))
	_Ini_Add("android", "shared_prefs.update", ($g_bUpdateSharedPrefs ? "1" : "0"))
	_Ini_Add("android", "process.affinity.mask", $g_iAndroidProcessAffinityMask)
	_Ini_Add("android", "click.additional.delay", $g_iAndroidControlClickAdditionalDelay)

	; Custom sleep - Team AIO Mod++ (inspired in Samkie)
	_Ini_Add("android", "AndroidSleep", $g_iInputAndroidSleep)

EndFunc   ;==>SaveConfig_Android

Func SaveConfig_Debug()
	; Debug
	ApplyConfig_Debug(GetApplyConfigSaveAction())
	; <><><><> Bot / Debug <><><><>
	_Ini_Add("debug", "debugsetlog", $g_bDebugSetlog ? 1 : 0)
	_Ini_Add("debug", "debugAndroid", $g_bDebugAndroid ? 1 : 0)
	_Ini_Add("debug", "debugsetclick", $g_bDebugClick ? 1 : 0)
	_Ini_Add("debug", "debugFunc", ($g_bDebugFuncTime And $g_bDebugFuncCall)? 1 : 0)
	_Ini_Add("debug", "disablezoomout", $g_bDebugDisableZoomout ? 1 : 0)
	_Ini_Add("debug", "disablevillagecentering", $g_bDebugDisableVillageCentering ? 1 : 0)
	_Ini_Add("debug", "debugdeadbaseimage", $g_bDebugDeadBaseImage ? 1 : 0)
	_Ini_Add("debug", "debugocr", $g_bDebugOcr ? 1 : 0)
	_Ini_Add("debug", "debugimagesave", $g_bDebugImageSave ? 1 : 0)
	_Ini_Add("debug", "debugbuildingpos", $g_bDebugBuildingPos ? 1 : 0)
	_Ini_Add("debug", "debugtrain", $g_bDebugSetlogTrain ? 1 : 0)
	_Ini_Add("debug", "debugOCRDonate", $g_bDebugOCRdonate ? 1 : 0)
	_Ini_Add("debug", "debugAttackCSV", $g_bDebugAttackCSV ? 1 : 0)
	_Ini_Add("debug", "debugmakeimgcsv", $g_bDebugMakeIMGCSV ? 1 : 0)
	_Ini_Add("debug", "DebugSmartZap", $g_bDebugSmartZap)
EndFunc   ;==>SaveConfig_Debug

Func SaveConfig_600_1()
	; <><><><> Village / Misc <><><><>
	ApplyConfig_600_1(GetApplyConfigSaveAction())
	; <><><><> Log window <><><><>
	_Ini_Add("general", "logstyle", $g_iCmbLogDividerOption)
	_Ini_Add("general", "LogDividerY", $g_iLogDividerY)
	; <><><><> Bottom panel <><><><>
	_Ini_Add("general", "Background", $g_bChkBackgroundMode ? 1 : 0)
	; <><><> Only Farm <><><>
	_Ini_Add("general", "ComboStatusMode", Abs(Number($g_iComboStatusMode)))
EndFunc   ;==>SaveConfig_600_1

Func SaveConfig_600_6()
	; <><><><> Village / Misc <><><><>
	ApplyConfig_600_6(GetApplyConfigSaveAction())
	_Ini_Add("general", "BotStop", $g_bChkBotStop ? 1 : 0)
	_Ini_Add("general", "Command", $g_iCmbBotCommand)
	_Ini_Add("general", "Cond", $g_iCmbBotCond)
	_Ini_Add("general", "Hour", $g_iCmbHoursStop)
	For $i = 0 To $eLootCount - 1
		_Ini_Add("other", "MinResumeAttackLoot_" & $i, $g_aiResumeAttackLoot[$i])
	Next
	_Ini_Add("general", "AvoidInCG", $g_bAvoidInCG ? 1 : 0) ; Custom CG - Team AIO Mod++
	_Ini_Add("general", "CollectStarBonus", $g_bCollectStarBonus ? 1 : 0)
	_Ini_Add("general", "CmbTimeStop", $g_iCmbTimeStop)
	_Ini_Add("other", "ResumeAttackTime", $g_iResumeAttackTime)

	_Ini_Add("other", "minrestartgold", $g_iTxtRestartGold)
	_Ini_Add("other", "minrestartelixir", $g_iTxtRestartElixir)
	_Ini_Add("other", "minrestartdark", $g_iTxtRestartDark)
	_Ini_Add("other", "chkCollect", $g_bChkCollect ? 1 : 0)
	_Ini_Add("other", "chkCollectLootCar", $g_bChkCollectLootCar ? 1 : 0) ; Custom Collect - Team AIO Mod++
	_Ini_Add("other", "minCollectgold", $g_iTxtCollectGold)
	_Ini_Add("other", "minCollectelixir", $g_iTxtCollectElixir)
	_Ini_Add("other", "minCollectdark", $g_iTxtCollectDark)
	_Ini_Add("other", "chkTombstones", $g_bChkTombstones ? 1 : 0)
    _Ini_Add("other", "chkCleanYard", $g_bChkCleanYard ? 1 : 0)

    _Ini_Add("other", "ChkCollectAchievements", $g_bChkCollectAchievements ? 1 : 0)
	_Ini_Add("other", "ChkCollectFreeMagicItems", $g_bChkCollectFreeMagicItems ? 1 : 0) ; AIO MOD++
	_Ini_Add("other", "ChkCollectRewards", $g_bChkCollectRewards ? 1 : 0)
	_Ini_Add("other", "ChkSellRewards", $g_bChkSellRewards ? 1 : 0)
	_Ini_Add("other", "chkGemsBox", $g_bChkGemsBox ? 1 : 0)
	_Ini_Add("other", "ChkTreasuryCollect", $g_bChkTreasuryCollect ? 1 : 0)
	_Ini_Add("other", "minTreasurygold", $g_iTxtTreasuryGold)
	_Ini_Add("other", "minTreasuryelixir", $g_iTxtTreasuryElixir)
	_Ini_Add("other", "minTreasurydark", $g_iTxtTreasuryDark)

	_Ini_Add("other", "ChkCollectBuildersBase", $g_bChkCollectBuilderBase ? 1 : 0)
	_Ini_Add("other", "ChkCleanBBYard", $g_bChkCleanBBYard ? 1 : 0)
    _Ini_Add("other", "chkCleanYardBBall", $g_bChkCleanYardBBall ? 1 : 0) ; AIO MOD++
	;
 	_Ini_Add("other", "ChkStartClockTowerBoost", $g_bChkStartClockTowerBoost ? 1 : 0)
	_Ini_Add("other", "CmbStartClockTowerBoost", $g_iCmbStartClockTowerBoost) ; AIO Mod++
	_Ini_Add("other", "CmbClockTowerPotion", $g_iCmbClockTowerPotion) ; AIO Mod++
	_Ini_Add("other", "ChkClockTowerPotion", $g_bChkClockTowerPotion ? 1 : 0) ; AIO Mod++
	;
;~ 	_Ini_Add("other", "ChkCTBoostBlderBz", $g_bChkCTBoostBlderBz ? 1 : 0) ; AIO MOD++
;~ 	_Ini_Add("other", "ChkCTBoostLabBBActive", $g_bChkCTBoostLabBBActive ? 1 : 0) ; AIO MOD++
	_Ini_Add("other", "ChkBBSuggestedUpgrades", $g_iChkBBSuggestedUpgrades)
	_Ini_Add("other", "ChkBBSuggestedUpgradesIgnoreGold", $g_iChkBBSuggestedUpgradesIgnoreGold)
	_Ini_Add("other", "ChkBBSuggestedUpgradesIgnoreElixir", $g_iChkBBSuggestedUpgradesIgnoreElixir)
;~ 	_Ini_Add("other", "ChkBBSuggestedUpgradesIgnoreHall", $g_iChkBBSuggestedUpgradesIgnoreHall) ; AIO MOD++
;~ 	_Ini_Add("other", "ChkBBSuggestedUpgradesIgnoreWall", $g_iChkBBSuggestedUpgradesIgnoreWall) ; AIO MOD++

	_Ini_Add("other", "ChkPlacingNewBuildings", $g_iChkPlacingNewBuildings)

	; xbebenk clan games
	_Ini_Add("other", "ChkClanGamesAir", $g_bChkClanGamesAir ? 1 : 0)
	_Ini_Add("other", "ChkClanGamesGround", $g_bChkClanGamesGround ? 1 : 0)
	_Ini_Add("other", "ChkClanGamesMisc", $g_bChkClanGamesMisc ? 1 : 0)

	_Ini_Add("other", "ChkClanGamesEnabled", $g_bChkClanGamesEnabled ? 1 : 0)
	_Ini_Add("other", "ChkClanGames60", $g_bChkClanGames60 ? 1 : 0)
	_Ini_Add("other", "ChkClanGamesStopBeforeReachAndPurge", $g_bChkClanGamesStopBeforeReachAndPurge ? 1 : 0)
	_Ini_Add("other", "ChkClanGamesDebug", $g_bChkClanGamesDebug ? 1 : 0)
	;xbenk
	_Ini_Add("other", "ChkClanGamesLoot", $g_bChkClanGamesLoot ? 1 : 0)
	_Ini_Add("other", "ChkClanGamesBattle", $g_bChkClanGamesBattle ? 1 : 0)

    _Ini_Add("other", "ChkClanGamesBBBattle", $g_bChkClanGamesBBBattle ? 1 : 0)
    _Ini_Add("other", "ChkClanGamesBBDestruction", $g_bChkClanGamesBBDes ? 1 : 0)

	_Ini_Add("other", "ChkClanGamesBBTroops", $g_bChkClanGamesBBTroops ? 1 : 0)

	_Ini_Add("other", "ChkForceBBAttackOnClanGames", $g_bChkForceBBAttackOnClanGames ? 1 : 0)

	_Ini_Add("other", "ChkOnlyBuilderBaseGC", $g_bChkOnlyBuilderBaseGC ? 1 : 0)

	_Ini_Add("other", "ChkClanGamesPurgeAny", $g_bChkClanGamesPurgeAny ? 1 : 0)
	_Ini_Add("other", "ChkClanGamesSpell", $g_bChkClanGamesSpell ? 1 : 0)

	_Ini_Add("other", "ChkClanGamesDestruction", $g_bChkClanGamesDes ? 1 : 0)
	_Ini_Add("other", "ChkClanGamesAirTroop", $g_bChkClanGamesAirTroop ? 1 : 0)

	_Ini_Add("other", "ChkClanGamesGroundTroop ", $g_bChkClanGamesGroundTroop ? 1 : 0)

	_Ini_Add("other", "ChkClanGamesMiscellaneous", $g_bChkClanGamesMiscellaneous ? 1 : 0)

	; Builder Base Attack
	;_Ini_Add("other", "ChkEnableBBAttack", $g_bChkEnableBBAttack) ; AIO MOD++
	_Ini_Add("other", "ChkBBTrophyRange", $g_bChkBBTrophyRange)
	_Ini_Add("other", "TxtBBTrophyLowerLimit", $g_iTxtBBTrophyLowerLimit)
	_Ini_Add("other", "TxtBBTrophyUpperLimit", $g_iTxtBBTrophyUpperLimit)
	_Ini_Add("other", "ChkBBAttIfLootAvail", $g_bChkBBAttIfLootAvail)
	; _Ini_Add("other", "ChkBBWaitForMachine", $g_bChkBBWaitForMachine) ; AIO MOD++
	_Ini_Add("other", "iBBNextTroopDelay", $g_iBBNextTroopDelay)
	_Ini_Add("other", "iBBSameTroopDelay", $g_iBBSameTroopDelay)

	; Builder Base Drop Order
	_Ini_Add("other", "bBBDropOrderSet", $g_bBBDropOrderSet)
	#Region - Custom BB Army - Team AIO Mod++
	For $i = 0 To $g_iBBTroopCount - 1
		_Ini_Add("other", "sBBDropOrderSet" & $i, $g_aiCmbBBDropOrder[$i])
	Next
	#EndRegion - Custom BB Army - Team AIO Mod++

	;Clan Capital
	_Ini_Add("ClanCapital", "ChkCollectCCGold", $g_bChkEnableCollectCCGold)
	_Ini_Add("ClanCapital", "ChkEnableForgeGold", $g_bChkEnableForgeGold)
	_Ini_Add("ClanCapital", "ChkEnableForgeElix", $g_bChkEnableForgeElix)
	_Ini_Add("ClanCapital", "ChkEnableForgeDE", $g_bChkEnableForgeDE)
	_Ini_Add("ClanCapital", "ChkEnableForgeBBGold", $g_bChkEnableForgeBBGold)
	_Ini_Add("ClanCapital", "ChkEnableForgeBBElix", $g_bChkEnableForgeBBElix)
	_Ini_Add("ClanCapital", "ForgeUseBuilder", $g_iCmbForgeBuilder)
	_Ini_Add("ClanCapital", "AutoUpgradeCC", $g_bChkEnableAutoUpgradeCC)
	_Ini_Add("ClanCapital", "ChkAutoUpgradeCCIgnore", $g_bChkAutoUpgradeCCIgnore)
	
EndFunc   ;==>SaveConfig_600_6

Func SaveConfig_600_9()
	; <><><><> Village / Achievements <><><><>
	ApplyConfig_600_9(GetApplyConfigSaveAction())
	_Ini_Add("Unbreakable", "chkUnbreakable", $g_iUnbrkMode)
	_Ini_Add("Unbreakable", "UnbreakableWait", $g_iUnbrkWait)
	_Ini_Add("Unbreakable", "minUnBrkgold", $g_iUnbrkMinGold)
	_Ini_Add("Unbreakable", "minUnBrkelixir", $g_iUnbrkMinElixir)
	_Ini_Add("Unbreakable", "minUnBrkdark", $g_iUnbrkMinDark)
	_Ini_Add("Unbreakable", "maxUnBrkgold", $g_iUnbrkMaxGold)
	_Ini_Add("Unbreakable", "maxUnBrkelixir", $g_iUnbrkMaxElixir)
	_Ini_Add("Unbreakable", "maxUnBrkdark", $g_iUnbrkMaxDark)
EndFunc   ;==>SaveConfig_600_9

Func SaveConfig_600_11()
	ApplyConfig_600_11(GetApplyConfigSaveAction())
	; <><><><> Village / Donate - Request <><><><>
	_Ini_Add("planned", "RequestHoursEnable", $g_bRequestTroopsEnable ? 1 : 0)
	_Ini_Add("donate", "txtRequest", $g_sRequestTroopsText)
	; Request Type - Demen
	_Ini_Add("donate", "RequestType_Troop", $g_abRequestType[0] ? 1 : 0)
	_Ini_Add("donate", "RequestType_Spell", $g_abRequestType[1] ? 1 : 0)
	_Ini_Add("donate", "RequestType_Siege", $g_abRequestType[2] ? 1 : 0)
	_Ini_Add("donate", "RequestCountCC_Troop", $g_iRequestCountCCTroop)
	_Ini_Add("donate", "RequestCountCC_Spell", $g_iRequestCountCCSpell)
	For $i = 0 To 2
		_Ini_Add("donate", "cmbClanCastleTroop" & $i, $g_aiClanCastleTroopWaitType[$i])
		_Ini_Add("donate", "txtClanCastleTroop" & $i, $g_aiClanCastleTroopWaitQty[$i])
		_Ini_Add("donate", "cmbClanCastleSpell" & $i, $g_aiClanCastleSpellWaitType[$i])
		If $i <= 1 Then _Ini_Add("donate", "cmbClanCastleSiege" & $i, $g_aiClanCastleSiegeWaitType[$i])
	Next
	Local $string = ""
	For $i = 0 To 23
		$string &= ($g_abRequestCCHours[$i] ? "1" : "0") & "|"
	Next
	_Ini_Add("planned", "RequestHours", $string)

    ; Request defense CC (Demen)
    _Ini_Add("donate", "RequestDefenseEnable", $g_bRequestCCDefense ? 1 : 0)
    _Ini_Add("donate", "RequestDefenseText", $g_sRequestCCDefenseText)
    _Ini_Add("donate", "RequestDefenseWhenPB", $g_iCmbRequestCCDefenseWhen ? 1 : 0)
    _Ini_Add("donate", "RequestDefenseTime", $g_iRequestDefenseTime)
    _Ini_Add("donate", "SaveCCTroopForDefense", $g_bSaveCCTroopForDefense ? 1 : 0)
    _Ini_Add("donate", "ChkRemoveCCForDefense", $g_bChkRemoveCCForDefense ? 1 : 0)

 	; Type Once - ChacalGyn
	_Ini_Add("request", "RequestTypeOnce", $g_bChkRequestTypeOnceEnable ? 1 : 0)

 	; Request from chat - Team AIO Mod++
	_Ini_Add("request", "ChkRequestFromChat", $g_bChkRequestFromChat ? 1 : 0)

	; Request Early - Team AIO Mod++
	_Ini_Add("request", "ChkReqCCFirst", $g_bChkReqCCFirst ? 1 : 0)

    For $i = 0 To 2
        _Ini_Add("donate", "cmbClanCastleTroopDef" & $i, $g_aiClanCastleTroopDefType[$i])
        _Ini_Add("donate", "txtClanCastleTroopDef" & $i, $g_aiCCDefenseTroopWaitQty[$i])
    Next

EndFunc   ;==>SaveConfig_600_11

Func SaveConfig_600_12()
	Local $t = __TimerInit()

	; <><><><> Village / Donate - Donate <><><><>
	ApplyConfig_600_12(GetApplyConfigSaveAction())

	_Ini_Add("donate", "Doncheck", $g_bChkDonate ? 1 : 0)
	_Ini_Add("donate", "chkDonateQueueOnly[0]", $g_abChkDonateQueueOnly[0] ? 1 : 0)
	_Ini_Add("donate", "chkDonateQueueOnly[1]", $g_abChkDonateQueueOnly[1] ? 1 : 0)

	For $i = 0 To $eTroopCount - 1 + $g_iCustomDonateConfigs
		Local $sIniName = ""
		If $i >= $eTroopBarbarian And $i <= $eTroopHeadhunter Then
			$sIniName = StringReplace($g_asTroopNamesPlural[$i], " ", "")
		ElseIf $i = $eCustomA Then
			$sIniName = "CustomA"
		ElseIf $i = $eCustomB Then
			$sIniName = "CustomB"
		ElseIf $i = $eCustomC Then
			$sIniName = "CustomC"
		ElseIf $i = $eCustomD Then
			$sIniName = "CustomD"
		EndIf

		_Ini_Add("donate", "chkDonate" & $sIniName, $g_abChkDonateTroop[$i] ? 1 : 0)
		_Ini_Add("donate", "chkDonateAll" & $sIniName, $g_abChkDonateAllTroop[$i] ? 1 : 0)
		_Ini_Add("donate", "txtDonate" & $sIniName, StringReplace($g_asTxtDonateTroop[$i], @CRLF, "|"))
		_Ini_Add("donate", "txtBlacklist" & $sIniName, StringReplace($g_asTxtBlacklistTroop[$i], @CRLF, "|"))
	Next

	For $i = 0 To $eSpellCount - 1
		Local $sIniName = $g_asSpellNames[$i] & "Spells"
		_Ini_Add("donate", "chkDonate" & $sIniName, $g_abChkDonateSpell[$i] ? 1 : 0)
		_Ini_Add("donate", "chkDonateAll" & $sIniName, $g_abChkDonateAllSpell[$i] ? 1 : 0)
		_Ini_Add("donate", "txtDonate" & $sIniName, StringReplace($g_asTxtDonateSpell[$i], @CRLF, "|"))
		_Ini_Add("donate", "txtBlacklist" & $sIniName, StringReplace($g_asTxtBlacklistSpell[$i], @CRLF, "|"))
	Next

	For $i = $eSiegeWallWrecker to $eSiegeMachineCount - 1
		Local $index = $eTroopCount + $g_iCustomDonateConfigs
		Local $sIniName = $g_asSiegeMachineShortNames[$i]
		_Ini_Add("donate", "chkDonate" & $sIniName, $g_abChkDonateTroop[$index + $i] ? 1 : 0)
		_Ini_Add("donate", "chkDonateAll" & $sIniName, $g_abChkDonateAllTroop[$index + $i] ? 1 : 0)
		_Ini_Add("donate", "txtDonate" & $sIniName, StringReplace($g_asTxtDonateTroop[$index + $i], @CRLF, "|"))
		_Ini_Add("donate", "txtBlacklist" & $sIniName, StringReplace($g_asTxtBlacklistTroop[$index + $i], @CRLF, "|"))
	Next

	For $i = 0 To 2
		_Ini_Add("donate", "cmbDonateCustomA" & $i + 1, $g_aiDonateCustomTrpNumA[$i][0])
		_Ini_Add("donate", "txtDonateCustomA" & $i + 1, $g_aiDonateCustomTrpNumA[$i][1])
		_Ini_Add("donate", "cmbDonateCustomB" & $i + 1, $g_aiDonateCustomTrpNumB[$i][0])
		_Ini_Add("donate", "txtDonateCustomB" & $i + 1, $g_aiDonateCustomTrpNumB[$i][1])
		_Ini_Add("donate", "cmbDonateCustomC" & $i + 1, $g_aiDonateCustomTrpNumC[$i][0])
		_Ini_Add("donate", "txtDonateCustomC" & $i + 1, $g_aiDonateCustomTrpNumC[$i][1])
		_Ini_Add("donate", "cmbDonateCustomD" & $i + 1, $g_aiDonateCustomTrpNumD[$i][0])
		_Ini_Add("donate", "txtDonateCustomD" & $i + 1, $g_aiDonateCustomTrpNumD[$i][1])
	Next

	_Ini_Add("donate", "chkExtraAlphabets", $g_bChkExtraAlphabets ? 1 : 0)
	_Ini_Add("donate", "chkExtraChinese", $g_bChkExtraChinese ? 1 : 0)
	_Ini_Add("donate", "chkExtraKorean", $g_bChkExtraKorean ? 1 : 0)
	_Ini_Add("donate", "chkExtraPersian", $g_bChkExtraPersian ? 1 : 0)

	_Ini_Add("donate", "txtBlacklist", StringReplace($g_sTxtGeneralBlacklist, @CRLF, "|"))
EndFunc   ;==>SaveConfig_600_12

Func SaveConfig_600_13()
	; <><><><> Village / Donate - Schedule <><><><>
	ApplyConfig_600_13(GetApplyConfigSaveAction())
	_Ini_Add("planned", "DonateHoursEnable", $g_bDonateHoursEnable ? 1 : 0)
	Local $string = ""
	For $i = 0 To 23
		$string &= ($g_abDonateHours[$i] ? "1" : "0") & "|"
	Next
	_Ini_Add("planned", "DonateHours", $string)
	_Ini_Add("donate", "cmbFilterDonationsCC", $g_iCmbDonateFilter)
	_Ini_Add("donate", "SkipDonateNearFulLTroopsEnable", $g_bDonateSkipNearFullEnable ? 1 : 0)
	_Ini_Add("donate", "SkipDonateNearFulLTroopsPercentual", $g_iDonateSkipNearFullPercent)
	_Ini_Add("donate", "BalanceCC", $g_bUseCCBalanced ? 1 : 0)
	_Ini_Add("donate", "BalanceCCDonated", $g_iCCDonated)
	_Ini_Add("donate", "BalanceCCReceived", $g_iCCReceived)
	_Ini_Add("donate", "CheckDonateOften", $g_bCheckDonateOften ? 1 : 0)
EndFunc   ;==>SaveConfig_600_13

Func SaveConfig_600_15()
	; <><><><> Village / Upgrade - Heroes <><><><>
	ApplyConfig_600_15(GetApplyConfigSaveAction())
	_Ini_Add("upgrade", "UpgradeKing", $g_bUpgradeKingEnable ? 1 : 0)
	_Ini_Add("upgrade", "UpgradeQueen", $g_bUpgradeQueenEnable ? 1 : 0)
	_Ini_Add("upgrade", "UpgradeWarden", $g_bUpgradeWardenEnable ? 1 : 0)
	_Ini_Add("upgrade", "UpgradeChampion", $g_bUpgradeChampionEnable ? 1 : 0)
	_Ini_Add("upgrade", "HeroReservedBuilder", $g_iHeroReservedBuilder)

	_Ini_Add("upgrade", "UpgradePetLassi", $g_bUpgradePetsEnable[$ePetLassi] ? 1 : 0)
	_Ini_Add("upgrade", "UpgradePetEletroOwl", $g_bUpgradePetsEnable[$ePetEletroOwl] ? 1 : 0)
	_Ini_Add("upgrade", "UpgradePetMightyYak", $g_bUpgradePetsEnable[$ePetMightyYak] ? 1 : 0)
	_Ini_Add("upgrade", "UpgradePetUnicorn", $g_bUpgradePetsEnable[$ePetUnicorn] ? 1 : 0)
EndFunc   ;==>SaveConfig_600_15

Func SaveConfig_600_16()
	; <><><><> Village / Upgrade - Buildings <><><><>
	_Ini_Add("upgrade", "minupgrgold", $g_iUpgradeMinGold)
	_Ini_Add("upgrade", "minupgrelixir", $g_iUpgradeMinElixir)
	_Ini_Add("upgrade", "minupgrdark", $g_iUpgradeMinDark)
EndFunc   ;==>SaveConfig_600_16

Func SaveConfig_auto()
	ApplyConfig_auto(GetApplyConfigSaveAction())
	; Auto Upgrade
	_Ini_Add("Auto Upgrade", "AutoUpgradeEnabled", $g_bAutoUpgradeEnabled)
	For $i = 0 To UBound($g_iChkUpgradesToIgnore) - 1 ; Custom Improve - Team AIO Mod++
		_Ini_Add("Auto Upgrade", "ChkUpgradesToIgnore[" & $i & "]", $g_iChkUpgradesToIgnore[$i])
	Next
	For $i = 0 To 2
		_Ini_Add("Auto Upgrade", "ChkResourcesToIgnore[" & $i & "]", $g_iChkResourcesToIgnore[$i])
	Next
	_Ini_Add("Auto Upgrade", "SmartMinGold", $g_iTxtSmartMinGold)
	_Ini_Add("Auto Upgrade", "SmartMinElixir", $g_iTxtSmartMinElixir)
	_Ini_Add("Auto Upgrade", "SmartMinDark", $g_iTxtSmartMinDark)
EndFunc   ;==>SaveConfig_auto

Func SaveConfig_600_17()
	; <><><><> Village / Upgrade - Walls <><><><>
	ApplyConfig_600_17(GetApplyConfigSaveAction())
	_Ini_Add("upgrade", "auto-wall", $g_bAutoUpgradeWallsEnable ? 1 : 0)
	_Ini_Add("upgrade", "minwallgold", $g_iUpgradeWallMinGold)
	_Ini_Add("upgrade", "minwallelixir", $g_iUpgradeWallMinElixir)
	_Ini_Add("upgrade", "use-storage", $g_iUpgradeWallLootType)
	_Ini_Add("upgrade", "savebldr", $g_bUpgradeWallSaveBuilder ? 1 : 0)
	_Ini_Add("upgrade", "walllvl", $g_iCmbUpgradeWallsLevel)
	For $i = 4 To 15
		_Ini_Add("Walls", "Wall" & StringFormat("%02d", $i), $g_aiWallsCurrentCount[$i])
	Next
	_Ini_Add("upgrade", "WallCost", $g_iWallCost)

	; Custom Wall - Team AIO Mod++
	SaveConfig_MOD_Walls()
EndFunc   ;==>SaveConfig_600_17

Func SaveConfig_600_18()
	; <><><><> Village / Notify <><><><>
	ApplyConfig_600_18(GetApplyConfigSaveAction())
	_Ini_Add("notify", "TGEnabled", $g_bNotifyTGEnable ? 1 : 0)
	_Ini_Add("notify", "TGToken", $g_sNotifyTGToken)
	_Ini_Add("notify", "TGUserID", $g_sTGChatID)

	;Remote Control
	_Ini_Add("notify", "PBRemote", $g_bNotifyRemoteEnable ? 1 : 0)
	_Ini_Add("notify", "Origin", $g_sNotifyOrigin)

	;Alerts
	_Ini_Add("notify", "AlertPBVMFound", $g_bNotifyAlertMatchFound ? 1 : 0)
	_Ini_Add("notify", "AlertPBLastRaid", $g_bNotifyAlerLastRaidIMG ? 1 : 0)
	_Ini_Add("notify", "AlertPBWallUpgrade", $g_bNotifyAlertUpgradeWalls ? 1 : 0)
	_Ini_Add("notify", "AlertPBOOS", $g_bNotifyAlertOutOfSync ? 1 : 0)
	_Ini_Add("notify", "AlertPBVBreak", $g_bNotifyAlertTakeBreak ? 1 : 0)
	_Ini_Add("notify", "AlertPBOtherDevice", $g_bNotifyAlertAnotherDevice ? 1 : 0)
	_Ini_Add("notify", "AlertPBLastRaidTxt", $g_bNotifyAlerLastRaidTXT ? 1 : 0)
	_Ini_Add("notify", "AlertPBCampFull", $g_bNotifyAlertCampFull ? 1 : 0)
	_Ini_Add("notify", "AlertPBVillage", $g_bNotifyAlertVillageReport ? 1 : 0)
	_Ini_Add("notify", "AlertPBLastAttack", $g_bNotifyAlertLastAttack ? 1 : 0)
	_Ini_Add("notify", "AlertBuilderIdle", $g_bNotifyAlertBulderIdle ? 1 : 0)
	_Ini_Add("notify", "AlertPBMaintenance", $g_bNotifyAlertMaintenance ? 1 : 0)
	_Ini_Add("notify", "AlertPBBAN", $g_bNotifyAlertBAN ? 1 : 0)
	_Ini_Add("notify", "AlertPBUpdate", $g_bNotifyAlertBOTUpdate ? 1 : 0)
	_Ini_Add("notify", "AlertSmartWaitTime", $g_bNotifyAlertSmartWaitTime ? 1 : 0)
	_Ini_Add("notify", "AlertLaboratoryIdle", $g_bNotifyAlertLaboratoryIdle ? 1 : 0)
	#Region - Discord - Team AIO Mod++
	_Ini_Add("notify", "AlertPetHouseIdle", $g_bNotifyAlertPetHouseIdle ? 1 : 0)

	_Ini_Add("notifyDS", "DSEnabled", $g_bNotifyDSEnable ? 1 : 0)
	_Ini_Add("notifyDS", "DSToken", $g_sNotifyDSToken)
	_Ini_Add("notifyDS", "Origin", $g_sNotifyOriginDS)
	_Ini_Add("notifyDS", "Remote", $g_bNotifyRemoteEnableDS)

	;Alerts
	_Ini_Add("notifyDS", "AlertPBVMFound", $g_bNotifyAlertMatchFoundDS ? 1 : 0)
	_Ini_Add("notifyDS", "AlertPBLastRaid", $g_bNotifyAlerLastRaidIMGDS ? 1 : 0)
	_Ini_Add("notifyDS", "AlertPBWallUpgrade", $g_bNotifyAlertUpgradeWallsDS ? 1 : 0)
	_Ini_Add("notifyDS", "AlertPBOOS", $g_bNotifyAlertOutOfSyncDS ? 1 : 0)
	_Ini_Add("notifyDS", "AlertPBVBreak", $g_bNotifyAlertTakeBreakDS ? 1 : 0)
	_Ini_Add("notifyDS", "AlertPBOtherDevice", $g_bNotifyAlertAnotherDeviceDS ? 1 : 0)
	_Ini_Add("notifyDS", "AlertPBLastRaidTxt", $g_bNotifyAlerLastRaidTXTDS ? 1 : 0)
	_Ini_Add("notifyDS", "AlertPBCampFull", $g_bNotifyAlertCampFullDS ? 1 : 0)
	_Ini_Add("notifyDS", "AlertPBVillage", $g_bNotifyAlertVillageReportDS ? 1 : 0)
	_Ini_Add("notifyDS", "AlertPBLastAttack", $g_bNotifyAlertLastAttackDS ? 1 : 0)
	_Ini_Add("notifyDS", "AlertBuilderIdle", $g_bNotifyAlertBulderIdleDS ? 1 : 0)
	_Ini_Add("notifyDS", "AlertPBMaintenance", $g_bNotifyAlertMaintenanceDS ? 1 : 0)
	_Ini_Add("notifyDS", "AlertPBBAN", $g_bNotifyAlertBANDS ? 1 : 0)
	_Ini_Add("notifyDS", "AlertPBUpdate", $g_bNotifyAlertBOTUpdateDS ? 1 : 0)
	_Ini_Add("notifyDS", "AlertSmartWaitTime", $g_bNotifyAlertSmartWaitTimeDS ? 1 : 0)
	_Ini_Add("notifyDS", "AlertLaboratoryIdle", $g_bNotifyAlertLaboratoryIdleDS ? 1 : 0)
	_Ini_Add("notifyDS", "AlertPetHouseIdle", $g_bNotifyAlertPetHouseIdleDS ? 1 : 0)
	#EndRegion - Discord - Team AIO Mod++

EndFunc   ;==>SaveConfig_600_18

Func SaveConfig_600_19()
	; <><><><> Village / Notify <><><><>
	ApplyConfig_600_19(GetApplyConfigSaveAction())
	_Ini_Add("notify", "NotifyHoursEnable", $g_bNotifyScheduleHoursEnable ? 1 : 0)
	Local $string = ""
	For $i = 0 To 23
		$string &= ($g_abNotifyScheduleHours[$i] ? "1" : "0") & "|"
	Next
	_Ini_Add("notify", "NotifyHours", $string)
	_Ini_Add("notify", "NotifyWeekDaysEnable", $g_bNotifyScheduleWeekDaysEnable ? 1 : 0)
	Local $string = ""
	For $i = 0 To 6
		$string &= ($g_abNotifyScheduleWeekDays[$i] ? "1" : "0") & "|"
	Next
	_Ini_Add("notify", "NotifyWeekDays", $string)

	#Region - Discord - Team AIO Mod++
	_Ini_Add("notifyDS", "NotifyHoursEnable", $g_bNotifyScheduleHoursEnableDS ? 1 : 0)
	$string = ""
	For $i = 0 To 23
		$string &= ($g_abNotifyScheduleHours[$i] ? "1" : "0") & "|"
	Next
	_Ini_Add("notifyDS", "NotifyHours", $string)
	_Ini_Add("notifyDS", "NotifyWeekDaysEnable", $g_bNotifyScheduleWeekDaysEnableDS ? 1 : 0)
	Local $string = ""
	For $i = 0 To 6
		$string &= ($g_abNotifyScheduleWeekDaysDS[$i] ? "1" : "0") & "|"
	Next
	_Ini_Add("notifyDS", "NotifyWeekDays", $string)
	#EndRegion - Discord - Team AIO Mod++
EndFunc   ;==>SaveConfig_600_19

Func SaveConfig_600_22()
	; <><><> Attack Plan / Train Army / Boost <><><>
	ApplyConfig_600_22(GetApplyConfigSaveAction())
	; Boost settings are not saved to ini, by design, to prevent automatic gem spending
	Local $string = ""
	For $i = 0 To 23
		$string &= ($g_abBoostBarracksHours[$i] ? "1" : "0") & "|"
	Next
	_Ini_Add("planned", "BoostBarracksHours", $string)
	_Ini_Add("SuperTroopsBoost", "SuperTroopsEnable", $g_bSuperTroopsEnable ? 1 : 0)
	; Custom boost - Team AIO Mod++
	_Ini_Add("planned", "CmbBoostEverything", $g_iCmbBoostEverything)
	For $i = 0 To $iMaxSupersTroop - 1
		_Ini_Add("SuperTroopsBoost", "SuperTroopsIndex" & $i, $g_iCmbSuperTroops[$i])
	Next
	; Custom Super Troops - Team AIO Mod++
	_Ini_Add("SuperTroopsBoost", "SuperAutoTroops", $g_bSuperAutoTroops ? 1 : 0)
	_Ini_Add("SuperTroopsBoost", "CmbSuperTroopsResources", $g_iCmbSuperTroopsResources)
EndFunc   ;==>SaveConfig_600_22

Func SaveConfig_600_26()
	; <><><><> Attack Plan / Search & Attack / Bully <><><><>
	ApplyConfig_600_26(GetApplyConfigSaveAction())
	_Ini_Add("search", "BullyMode", $g_abAttackTypeEnable[$TB] ? 1 : 0)
	_Ini_Add("search", "ATBullyMode", $g_iAtkTBEnableCount)
	_Ini_Add("search", "YourTH", $g_iAtkTBMaxTHLevel)
	_Ini_Add("search", "THBullyAttackMode", $g_iAtkTBMode)
EndFunc   ;==>SaveConfig_600_26

#Region - Custom Search Reduction - Team AIO Mod++
Func SaveConfig_600_28()
	; <><><><> Attack Plan / Search & Attack / Options / Search <><><><>
	ApplyConfig_600_28(GetApplyConfigSaveAction())
	_Ini_Add("search", "reduction", $g_bSearchReductionEnable ? 1 : 0)
	_Ini_Add("search", "reduceCountChk", $g_bSearchReductionByCount ? 1 : 0)
	_Ini_Add("search", "reduceMinChk", $g_bSearchReductionByMin ? 1 : 0)
	_Ini_Add("search", "reduceCount", $g_iSearchReductionCount)
	_Ini_Add("search", "reduceMin", $g_iSearchReductionByMin)
	_Ini_Add("search", "reduceGold", $g_iSearchReductionGold)
	_Ini_Add("search", "reduceElixir", $g_iSearchReductionElixir)
	_Ini_Add("search", "reduceGoldPlusElixir", $g_iSearchReductionGoldPlusElixir)
	_Ini_Add("search", "reduceDark", $g_iSearchReductionDark)
	_Ini_Add("search", "reduceTrophy", $g_iSearchReductionTrophy)
	_Ini_Add("other", "VSDelay", $g_iSearchDelayMin)
	_Ini_Add("other", "MaxVSDelay", $g_iSearchDelayMax)
	_Ini_Add("general", "attacknow", $g_bSearchAttackNowEnable ? 1 : 0)
	_Ini_Add("general", "attacknowdelay", $g_iSearchAttackNowDelay)
	_Ini_Add("search", "ChkRestartSearchLimit", $g_bSearchRestartEnable ? 1 : 0)
	_Ini_Add("search", "RestartSearchLimit", $g_iSearchRestartLimit)
	_Ini_Add("search", "RestartSearchPickupHero", $g_bSearchRestartPickupHero ? 1 : 0)
	_Ini_Add("general", "AlertSearch", $g_bSearchAlertMe ? 1 : 0)
EndFunc   ;==>SaveConfig_600_28
#EndRegion - Custom Search Reduction - Team AIO Mod++

Func SaveConfig_600_28_DB()
	; <><><><> Attack Plan / Search & Attack / Deadbase / Search <><><><>
	ApplyConfig_600_28_DB(GetApplyConfigSaveAction())
	_Ini_Add("search", "DBcheck", $g_abAttackTypeEnable[$DB] ? 1 : 0)
	; Search - Start Search If
	_Ini_Add("search", "ChkDBSearchSearches", $g_abSearchSearchesEnable[$DB] ? 1 : 0)
	_Ini_Add("search", "DBEnableAfterCount", $g_aiSearchSearchesMin[$DB])
	_Ini_Add("search", "DBEnableBeforeCount", $g_aiSearchSearchesMax[$DB])
	_Ini_Add("search", "ChkDBSearchTropies", $g_abSearchTropiesEnable[$DB] ? 1 : 0)
	_Ini_Add("search", "DBEnableAfterTropies", $g_aiSearchTrophiesMin[$DB])
	_Ini_Add("search", "DBEnableBeforeTropies", $g_aiSearchTrophiesMax[$DB])
	_Ini_Add("search", "ChkDBSearchCamps", $g_abSearchCampsEnable[$DB] ? 1 : 0)
	_Ini_Add("search", "DBEnableAfterArmyCamps", $g_aiSearchCampsPct[$DB])
	_Ini_Add("attack", "DBKingWait", $g_iHeroWaitAttackNoBit[$DB][0])
	_Ini_Add("attack", "DBQueenWait", $g_iHeroWaitAttackNoBit[$DB][1])
	_Ini_Add("attack", "DBWardenWait", $g_iHeroWaitAttackNoBit[$DB][2])
	_Ini_Add("attack", "DBChampionWait", $g_iHeroWaitAttackNoBit[$DB][3])
	_Ini_Add("attack", "DBNotWaitHeroes", $g_aiSearchNotWaitHeroesEnable[$DB] ? 1 : 0)
	_Ini_Add("search", "ChkDBSpellsWait", $g_abSearchSpellsWaitEnable[$DB] ? 1 : 0)
	_Ini_Add("search", "ChkDBCastleWait", $g_abSearchCastleWaitEnable[$DB] ? 1 : 0)
	; Search - Filters
	_Ini_Add("search", "DBMeetGE", $g_aiFilterMeetGE[$DB])
	_Ini_Add("search", "DBsearchGold", $g_aiFilterMinGold[$DB])
	_Ini_Add("search", "DBsearchElixir", $g_aiFilterMinElixir[$DB])
	_Ini_Add("search", "DBsearchGoldPlusElixir", $g_aiFilterMinGoldPlusElixir[$DB])
	_Ini_Add("search", "DBMeetDE", $g_abFilterMeetDEEnable[$DB] ? 1 : 0)
	_Ini_Add("search", "DBsearchDark", $g_aiFilterMeetDEMin[$DB])
	_Ini_Add("search", "DBMeetTrophy", $g_abFilterMeetTrophyEnable[$DB] ? 1 : 0)
	_Ini_Add("search", "DBsearchTrophy", $g_aiFilterMeetTrophyMin[$DB])
	_Ini_Add("search", "DBsearchTrophyMax", $g_aiFilterMeetTrophyMax[$DB])
	_Ini_Add("search", "DBMeetTH", $g_abFilterMeetTH[$DB] ? 1 : 0)
	_Ini_Add("search", "DBTHLevel", $g_aiFilterMeetTHMin[$DB])
	_Ini_Add("search", "DBMeetTHO", $g_abFilterMeetTHOutsideEnable[$DB] ? 1 : 0)

	_Ini_Add("search", "DBMeetDeadEagle", $g_bChkDeadEagle ? 1 : 0)
	_Ini_Add("search", "DBMeetDeadEagleSearch", $g_iDeadEagleSearch)

	_Ini_Add("search", "DBCheckMortar", $g_abFilterMaxMortarEnable[$DB] ? 1 : 0)
	_Ini_Add("search", "DBCheckWizTower", $g_abFilterMaxWizTowerEnable[$DB] ? 1 : 0)
	_Ini_Add("search", "DBCheckAirDefense", $g_abFilterMaxAirDefenseEnable[$DB] ? 1 : 0)
	_Ini_Add("search", "DBCheckXBow", $g_abFilterMaxXBowEnable[$DB] ? 1 : 0)
	_Ini_Add("search", "DBCheckInferno", $g_abFilterMaxInfernoEnable[$DB] ? 1 : 0)
	_Ini_Add("search", "DBCheckEagle", $g_abFilterMaxEagleEnable[$DB] ? 1 : 0)
	_Ini_Add("search", "DBCheckScatter", $g_abFilterMaxScatterEnable[$DB] ? 1 : 0)
	_Ini_Add("search", "DBWeakMortar", $g_aiFilterMaxMortarLevel[$DB])
	_Ini_Add("search", "DBWeakWizTower", $g_aiFilterMaxWizTowerLevel[$DB])
	_Ini_Add("search", "DBWeakAirDefense", $g_aiFilterMaxAirDefenseLevel[$DB])
	_Ini_Add("search", "DBWeakXBow", $g_aiFilterMaxXBowLevel[$DB])
	_Ini_Add("search", "DBWeakInferno", $g_aiFilterMaxInfernoLevel[$DB])
	_Ini_Add("search", "DBWeakEagle", $g_aiFilterMaxEagleLevel[$DB])
	_Ini_Add("search", "DBWeakScatter", $g_aiFilterMaxScatterLevel[$DB])
	_Ini_Add("search", "DBMeetOne", $g_abFilterMeetOneConditionEnable[$DB] ? 1 : 0)
EndFunc   ;==>SaveConfig_600_28_DB

Func SaveConfig_600_28_LB()
	; <><><><> Attack Plan / Search & Attack / Activebase / Search <><><><>
	ApplyConfig_600_28_LB(GetApplyConfigSaveAction())
	_Ini_Add("search", "ABcheck", $g_abAttackTypeEnable[$LB] ? 1 : 0)
	; Search - Start Search If
	_Ini_Add("search", "ChkABSearchSearches", $g_abSearchSearchesEnable[$LB] ? 1 : 0)
	_Ini_Add("search", "ABEnableAfterCount", $g_aiSearchSearchesMin[$LB])
	_Ini_Add("search", "ABEnableBeforeCount", $g_aiSearchSearchesMax[$LB])
	_Ini_Add("search", "ChkABSearchTropies", $g_abSearchTropiesEnable[$LB] ? 1 : 0)
	_Ini_Add("search", "ABEnableAfterTropies", $g_aiSearchTrophiesMin[$LB])
	_Ini_Add("search", "ABEnableBeforeTropies", $g_aiSearchTrophiesMax[$LB])
	_Ini_Add("search", "ChkABSearchCamps", $g_abSearchCampsEnable[$LB] ? 1 : 0)
	_Ini_Add("search", "ABEnableAfterArmyCamps", $g_aiSearchCampsPct[$LB])
	_Ini_Add("attack", "ABKingWait", $g_iHeroWaitAttackNoBit[$LB][0])
	_Ini_Add("attack", "ABQueenWait", $g_iHeroWaitAttackNoBit[$LB][1])
	_Ini_Add("attack", "ABWardenWait", $g_iHeroWaitAttackNoBit[$LB][2])
	_Ini_Add("attack", "ABChampionWait", $g_iHeroWaitAttackNoBit[$LB][3])
	_Ini_Add("attack", "ABNotWaitHeroes", $g_aiSearchNotWaitHeroesEnable[$LB] ? 1 : 0)
	_Ini_Add("search", "ChkABSpellsWait", $g_abSearchSpellsWaitEnable[$LB] ? 1 : 0)
	_Ini_Add("search", "ChkABCastleWait", $g_abSearchCastleWaitEnable[$LB] ? 1 : 0)
	; Search - Filters
	_Ini_Add("search", "ABMeetGE", $g_aiFilterMeetGE[$LB])
	_Ini_Add("search", "ABsearchGold", $g_aiFilterMinGold[$LB])
	_Ini_Add("search", "ABsearchElixir", $g_aiFilterMinElixir[$LB])
	_Ini_Add("search", "ABsearchGoldPlusElixir", $g_aiFilterMinGoldPlusElixir[$LB])
	_Ini_Add("search", "ABMeetDE", $g_abFilterMeetDEEnable[$LB] ? 1 : 0)
	_Ini_Add("search", "ABsearchDark", $g_aiFilterMeetDEMin[$LB])
	_Ini_Add("search", "ABMeetTrophy", $g_abFilterMeetTrophyEnable[$LB] ? 1 : 0)
	_Ini_Add("search", "ABsearchTrophy", $g_aiFilterMeetTrophyMin[$LB])
	_Ini_Add("search", "ABsearchTrophyMax", $g_aiFilterMeetTrophyMax[$LB])
	_Ini_Add("search", "ABMeetTH", $g_abFilterMeetTH[$LB] ? 1 : 0)
	_Ini_Add("search", "ABTHLevel", $g_aiFilterMeetTHMin[$LB])
	_Ini_Add("search", "ABMeetTHO", $g_abFilterMeetTHOutsideEnable[$LB] ? 1 : 0)
	_Ini_Add("search", "ABCheckMortar", $g_abFilterMaxMortarEnable[$LB] ? 1 : 0)
	_Ini_Add("search", "ABCheckWizTower", $g_abFilterMaxWizTowerEnable[$LB] ? 1 : 0)
	_Ini_Add("search", "ABCheckAirDefense", $g_abFilterMaxAirDefenseEnable[$LB] ? 1 : 0)
	_Ini_Add("search", "ABCheckXBow", $g_abFilterMaxXBowEnable[$LB] ? 1 : 0)
	_Ini_Add("search", "ABCheckInferno", $g_abFilterMaxInfernoEnable[$LB] ? 1 : 0)
	_Ini_Add("search", "ABCheckEagle", $g_abFilterMaxEagleEnable[$LB] ? 1 : 0)
	_Ini_Add("search", "ABCheckScatter", $g_abFilterMaxScatterEnable[$LB] ? 1 : 0)
	_Ini_Add("search", "ABWeakMortar", $g_aiFilterMaxMortarLevel[$LB])
	_Ini_Add("search", "ABWeakWizTower", $g_aiFilterMaxWizTowerLevel[$LB])
	_Ini_Add("search", "ABWeakAirDefense", $g_aiFilterMaxAirDefenseLevel[$LB])
	_Ini_Add("search", "ABWeakXBow", $g_aiFilterMaxXBowLevel[$LB])
	_Ini_Add("search", "ABWeakInferno", $g_aiFilterMaxInfernoLevel[$LB])
	_Ini_Add("search", "ABWeakEagle", $g_aiFilterMaxEagleLevel[$LB])
	_Ini_Add("search", "ABWeakScatter", $g_aiFilterMaxScatterLevel[$LB])
	_Ini_Add("search", "ABMeetOne", $g_abFilterMeetOneConditionEnable[$LB] ? 1 : 0)
EndFunc   ;==>SaveConfig_600_28_LB

Func SaveConfig_600_29()
	; <><><><> Attack Plan / Search & Attack / Options / Attack <><><><>
	; Custom schedule - Team AIO Mod++
	_Ini_Add("planned", "chkRNDSchedAttack", $g_bChkRNDSchedAttack ? 1 : 0)
	_Ini_Add("planned", "cmbRNDSchedAttack", $g_iRNDSchedAttack)
	ApplyConfig_600_29(GetApplyConfigSaveAction())
	_Ini_Add("attack", "ActivateQueen", $g_iActivateQueen)
	_Ini_Add("attack", "ActivateKing", $g_iActivateKing)
	_Ini_Add("attack", "ActivateWarden", $g_iActivateWarden)
	_Ini_Add("attack", "ActivateChampion", $g_iActivateChampion)
	_Ini_Add("attack", "delayActivateQueen", $g_iDelayActivateQueen)
	_Ini_Add("attack", "delayActivateKing", $g_iDelayActivateKing)
	_Ini_Add("attack", "delayActivateWarden", $g_iDelayActivateWarden)
	_Ini_Add("attack", "delayActivateChampion", $g_iDelayActivateChampion)
	_Ini_Add("planned", "chkAttackPlannerEnable", $g_bAttackPlannerEnable ? 1 : 0)
	_Ini_Add("planned", "chkAttackPlannerCloseCoC", $g_bAttackPlannerCloseCoC ? 1 : 0)
	_Ini_Add("planned", "chkAttackPlannerCloseAll", $g_bAttackPlannerCloseAll ? 1 : 0)
	_Ini_Add("planned", "chkAttackPlannerSuspendComputer", $g_bAttackPlannerSuspendComputer ? 1 : 0)
	_Ini_Add("planned", "chkAttackPlannerRandom", $g_bAttackPlannerRandomEnable ? 1 : 0)
	_Ini_Add("planned", "cmbAttackPlannerRandom", $g_iAttackPlannerRandomTime)
	_Ini_Add("planned", "chkAttackPlannerDayLimit", $g_bAttackPlannerDayLimit ? 1 : 0)
	_Ini_Add("planned", "cmbAttackPlannerDayMin", $g_iAttackPlannerDayMin)
	_Ini_Add("planned", "cmbAttackPlannerDayMax", $g_iAttackPlannerDayMax)
	; Custom schedule - Team AIO Mod++
	Local $string = ""
	For $i = 0 To 6
		$string &= ($g_abPlannedAttackWeekDays[$g_iCurAccount][$i] ? 1 : 0) & "|"
	Next
	_Ini_Add("planned", "attackDays", $string)
	Local $string = ""
	For $i = 0 To 23
		$string &= ($g_abPlannedattackHours[$g_iCurAccount][$i] ? 1 : 0) & "|"
	Next
	_Ini_Add("planned", "attackHours", $string)
	_Ini_Add("planned", "DropCCEnable", $g_bPlannedDropCCHoursEnable ? 1 : 0)
	Local $string = ""
	For $i = 0 To 23
		$string &= ($g_abPlannedDropCCHours[$i] ? 1 : 0) & "|"
	Next
	_Ini_Add("planned", "DropCCHours", $string)
EndFunc   ;==>SaveConfig_600_29

Func SaveConfig_600_29_DB()
	; <><><><> Attack Plan / Search & Attack / Deadbase / Attack <><><><>
	ApplyConfig_600_29_DB(GetApplyConfigSaveAction())
	_Ini_Add("attack", "DBAtkAlgorithm", $g_aiAttackAlgorithm[$DB])
	_Ini_Add("attack", "DBSelectTroop", $g_aiAttackTroopSelection[$DB])
	_Ini_Add("attack", "DBKingAtk", BitAND($g_aiAttackUseHeroes[$DB], $eHeroKing))
	_Ini_Add("attack", "DBQueenAtk", BitAND($g_aiAttackUseHeroes[$DB], $eHeroQueen))
	_Ini_Add("attack", "DBWardenAtk", BitAND($g_aiAttackUseHeroes[$DB], $eHeroWarden))
	_Ini_Add("attack", "DBChampionAtk", BitAND($g_aiAttackUseHeroes[$DB], $eHeroChampion))
	_Ini_Add("attack", "DBDropCC", $g_abAttackDropCC[$DB] ? 1 : 0)
	_Ini_Add("attack", "DBLightSpell", $g_abAttackUseLightSpell[$DB] ? 1 : 0)
	_Ini_Add("attack", "DBHealSpell", $g_abAttackUseHealSpell[$DB] ? 1 : 0)
	_Ini_Add("attack", "DBRageSpell", $g_abAttackUseRageSpell[$DB] ? 1 : 0)
	_Ini_Add("attack", "DBJumpSpell", $g_abAttackUseJumpSpell[$DB] ? 1 : 0)
	_Ini_Add("attack", "DBFreezeSpell", $g_abAttackUseFreezeSpell[$DB] ? 1 : 0)
	_Ini_Add("attack", "DBPoisonSpell", $g_abAttackUsePoisonSpell[$DB] ? 1 : 0)
	_Ini_Add("attack", "DBEarthquakeSpell", $g_abAttackUseEarthquakeSpell[$DB] ? 1 : 0)
	_Ini_Add("attack", "DBHasteSpell", $g_abAttackUseHasteSpell[$DB] ? 1 : 0)
	_Ini_Add("attack", "DBCloneSpell", $g_abAttackUseCloneSpell[$DB] ? 1 : 0)
	_Ini_Add("attack", "DBInvisibilitySpell", $g_abAttackUseInvisibilitySpell[$DB] ? 1 : 0)
	_Ini_Add("attack", "DBSkeletonSpell", $g_abAttackUseSkeletonSpell[$DB] ? 1 : 0)
	_Ini_Add("attack", "DBBatSpell", $g_abAttackUseBatSpell[$DB] ? 1 : 0)

	_Ini_Add("attack", "DBAtkUseWardenMode", $g_aiAttackUseWardenMode[$DB])
	_Ini_Add("attack", "DBAtkUseSiege", $g_aiAttackUseSiege[$DB])

	SaveConfig_600_29_DB_Standard()

	SaveConfig_600_29_DB_Scripted()

	SaveConfig_600_29_DB_SmartFarm()

	saveconfig_600_29_db_smartmilk() ; Smart milk - Team AIO Mod++

EndFunc   ;==>SaveConfig_600_29_DB

Func SaveConfig_600_29_DB_Standard()
	; <><><><> Attack Plan / Search & Attack / Deadbase / Attack / Standard <><><><>
	ApplyConfig_600_29_DB_Standard(GetApplyConfigSaveAction())
	_Ini_Add("attack", "DBStandardAlgorithm", $g_aiAttackStdDropOrder[$DB])
	_Ini_Add("attack", "DBDeploy", $g_aiAttackStdDropSides[$DB])
	_Ini_Add("attack", "DBSmartAttackRedArea", $g_abAttackStdSmartAttack[$DB] ? 1 : 0)
	_Ini_Add("attack", "DBSmartAttackDeploy", $g_aiAttackStdSmartDeploy[$DB])
	_Ini_Add("attack", "DBSmartAttackGoldMine", $g_abAttackStdSmartNearCollectors[$DB][0] ? 1 : 0)
	_Ini_Add("attack", "DBSmartAttackElixirCollector", $g_abAttackStdSmartNearCollectors[$DB][1] ? 1 : 0)
	_Ini_Add("attack", "DBSmartAttackDarkElixirDrill", $g_abAttackStdSmartNearCollectors[$DB][2] ? 1 : 0)
	; Custom smart attack - Team AIO Mod++
	_Ini_Add("attack", "DBAttackStdSmartDropSpells", $g_abAttackStdSmartDropSpells[$DB] ? 1 : 0)
EndFunc   ;==>SaveConfig_600_29_DB_Standard

Func SaveConfig_600_29_DB_Scripted()
	; <><><><> Attack Plan / Search & Attack / Deadbase / Attack / Scripted <><><><>
	ApplyConfig_600_29_DB_Scripted(GetApplyConfigSaveAction())
	_Ini_Add("attack", "RedlineRoutineDB", $g_aiAttackScrRedlineRoutine[$DB])
	_Ini_Add("attack", "DroplineEdgeDB", $g_aiAttackScrDroplineEdge[$DB])
	_Ini_Add("attack", "ScriptDB", $g_sAttackScrScriptName[$DB])
EndFunc   ;==>SaveConfig_600_29_DB_Scripted

Func SaveConfig_600_29_DB_SmartFarm()
	#Region - Custom SmartFarm - Team AIO Mod++
	_Ini_Add("SmartFarm", "UseSmartFarmAndRandomDeploy", $g_bUseSmartFarmAndRandomDeploy)
	_Ini_Add("SmartFarm", "UseSmartFarmAndRandomQuant", $g_bUseSmartFarmAndRandomQuant)
	_Ini_Add("SmartFarm", "SmartFarmSpellsEnable", $g_bSmartFarmSpellsEnable)
	_Ini_Add("SmartFarm", "UseSmartFarmRedLine", $g_bUseSmartFarmRedLine)
	_Ini_Add("SmartFarm", "SmartFarmSpellsHowManySides", $g_iSmartFarmSpellsHowManySides)
	#EndRegion - Custom SmartFarm - Team AIO Mod++

	_Ini_Add("SmartFarm", "InsidePercentage", $g_iTxtInsidePercentage)
	_Ini_Add("SmartFarm", "OutsidePercentage", $g_iTxtOutsidePercentage)
	_Ini_Add("SmartFarm", "DebugSmartFarm", $g_bDebugSmartFarm)
EndFunc

Func SaveConfig_600_29_LB()
	; <><><><> Attack Plan / Search & Attack / Activebase / Attack <><><><>
	ApplyConfig_600_29_LB(GetApplyConfigSaveAction())
	_Ini_Add("attack", "ABAtkAlgorithm", $g_aiAttackAlgorithm[$LB])
	_Ini_Add("attack", "ABSelectTroop", $g_aiAttackTroopSelection[$LB])
	_Ini_Add("attack", "ABKingAtk", BitAND($g_aiAttackUseHeroes[$LB], $eHeroKing))
	_Ini_Add("attack", "ABQueenAtk", BitAND($g_aiAttackUseHeroes[$LB], $eHeroQueen))
	_Ini_Add("attack", "ABWardenAtk", BitAND($g_aiAttackUseHeroes[$LB], $eHeroWarden))
	_Ini_Add("attack", "ABChampionAtk", BitAND($g_aiAttackUseHeroes[$LB], $eHeroChampion))
	_Ini_Add("attack", "ABDropCC", $g_abAttackDropCC[$LB] ? 1 : 0)
	_Ini_Add("attack", "ABLightSpell", $g_abAttackUseLightSpell[$LB] ? 1 : 0)
	_Ini_Add("attack", "ABHealSpell", $g_abAttackUseHealSpell[$LB] ? 1 : 0)
	_Ini_Add("attack", "ABRageSpell", $g_abAttackUseRageSpell[$LB] ? 1 : 0)
	_Ini_Add("attack", "ABJumpSpell", $g_abAttackUseJumpSpell[$LB] ? 1 : 0)
	_Ini_Add("attack", "ABFreezeSpell", $g_abAttackUseFreezeSpell[$LB] ? 1 : 0)
	_Ini_Add("attack", "ABCloneSpell", $g_abAttackUseCloneSpell[$LB] ? 1 : 0)
	_Ini_Add("attack", "ABInvisibilitySpell", $g_abAttackUseInvisibilitySpell[$LB] ? 1 : 0)
	_Ini_Add("attack", "ABPoisonSpell", $g_abAttackUsePoisonSpell[$LB] ? 1 : 0)
	_Ini_Add("attack", "ABEarthquakeSpell", $g_abAttackUseEarthquakeSpell[$LB] ? 1 : 0)
	_Ini_Add("attack", "ABHasteSpell", $g_abAttackUseHasteSpell[$LB] ? 1 : 0)
	_Ini_Add("attack", "ABSkeletonSpell", $g_abAttackUseSkeletonSpell[$LB] ? 1 : 0)
	_Ini_Add("attack", "ABBatSpell", $g_abAttackUseBatSpell[$LB] ? 1 : 0)
	_Ini_Add("attack", "ABInvisibilitySpell", $g_abAttackUseInvisibilitySpell[$LB] ? 1 : 0)

	_Ini_Add("attack", "ABAtkUseWardenMode", $g_aiAttackUseWardenMode[$LB])
	_Ini_Add("attack", "ABAtkUseSiege", $g_aiAttackUseSiege[$LB])

	SaveConfig_600_29_LB_Standard()

	SaveConfig_600_29_LB_Scripted()

EndFunc   ;==>SaveConfig_600_29_LB

Func SaveConfig_600_29_LB_Standard()
	; <><><><> Attack Plan / Search & Attack / Activebase / Attack / Standard <><><><>
	ApplyConfig_600_29_LB_Standard(GetApplyConfigSaveAction())
	_Ini_Add("attack", "LBStandardAlgorithm", $g_aiAttackStdDropOrder[$LB])
	_Ini_Add("attack", "ABDeploy", $g_aiAttackStdDropSides[$LB])
	_Ini_Add("attack", "ABSmartAttackRedArea", $g_abAttackStdSmartAttack[$LB] ? 1 : 0)
	_Ini_Add("attack", "ABSmartAttackDeploy", $g_aiAttackStdSmartDeploy[$LB])
	_Ini_Add("attack", "ABSmartAttackGoldMine", $g_abAttackStdSmartNearCollectors[$LB][0] ? 1 : 0)
	_Ini_Add("attack", "ABSmartAttackElixirCollector", $g_abAttackStdSmartNearCollectors[$LB][1] ? 1 : 0)
	_Ini_Add("attack", "ABSmartAttackDarkElixirDrill", $g_abAttackStdSmartNearCollectors[$LB][2] ? 1 : 0)
	; Custom smart attack - Team AIO Mod++
	_Ini_Add("attack", "ABAttackStdSmartDropSpells", $g_abAttackStdSmartDropSpells[$LB] ? 1 : 0)
EndFunc   ;==>SaveConfig_600_29_LB_Standard

Func SaveConfig_600_29_LB_Scripted()
	; <><><><> Attack Plan / Search & Attack / Activebase / Attack / Scripted <><><><>
	ApplyConfig_600_29_LB_Scripted(GetApplyConfigSaveAction())
	_Ini_Add("attack", "RedlineRoutineAB", $g_aiAttackScrRedlineRoutine[$LB])
	_Ini_Add("attack", "DroplineEdgeAB", $g_aiAttackScrDroplineEdge[$LB])
	_Ini_Add("attack", "ScriptAB", $g_sAttackScrScriptName[$LB])
EndFunc   ;==>SaveConfig_600_29_LB_Scripted

Func SaveConfig_600_30()
	; <><><><> Attack Plan / Search & Attack / Options / End Battle <><><><>
	ApplyConfig_600_30(GetApplyConfigSaveAction())
	_Ini_Add("shareattack", "ShareAttack", $g_bShareAttackEnable ? 1 : 0)
	_Ini_Add("shareattack", "minGold", $g_iShareMinGold)
	_Ini_Add("shareattack", "minElixir", $g_iShareMinElixir)
	_Ini_Add("shareattack", "minDark", $g_iShareMinDark)
	_Ini_Add("shareattack", "Message", $g_sShareMessage)
	_Ini_Add("attack", "TakeLootSnapShot", $g_bTakeLootSnapShot ? 1 : 0)
	_Ini_Add("attack", "ScreenshotLootInfo", $g_bScreenshotLootInfo ? 1 : 0)
EndFunc   ;==>SaveConfig_600_30

Func SaveConfig_600_30_DB()
	; <><><><> Attack Plan / Search & Attack / Deadbase / End Battle <><><><>
	ApplyConfig_600_30_DB(GetApplyConfigSaveAction())
	_Ini_Add("endbattle", "chkDBTimeStopAtk", $g_abStopAtkNoLoot1Enable[$DB] ? 1 : 0)
	_Ini_Add("endbattle", "txtDBTimeStopAtk", $g_aiStopAtkNoLoot1Time[$DB])
	_Ini_Add("endbattle", "chkDBTimeStopAtk2", $g_abStopAtkNoLoot2Enable[$DB] ? 1 : 0)
	_Ini_Add("endbattle", "txtDBTimeStopAtk2", $g_aiStopAtkNoLoot2Time[$DB])
	_Ini_Add("endbattle", "txtDBMinGoldStopAtk2", $g_aiStopAtkNoLoot2MinGold[$DB])
	_Ini_Add("endbattle", "txtDBMinElixirStopAtk2", $g_aiStopAtkNoLoot2MinElixir[$DB])
	_Ini_Add("endbattle", "txtDBMinDarkElixirStopAtk2", $g_aiStopAtkNoLoot2MinDark[$DB])
	_Ini_Add("endbattle", "chkDBEndNoResources", $g_abStopAtkNoResources[$DB] ? 1 : 0)
	_Ini_Add("endbattle", "chkDBEndOneStar", $g_abStopAtkOneStar[$DB] ? 1 : 0)
	_Ini_Add("endbattle", "chkDBEndTwoStars", $g_abStopAtkTwoStars[$DB] ? 1 : 0)
	_Ini_Add("endbattle", "chkDBPercentageHigher", $g_abStopAtkPctHigherEnable[$DB] ? 1 : 0)
	_Ini_Add("endbattle", "txtDBPercentageHigher", $g_aiStopAtkPctHigherAmt[$DB])
	_Ini_Add("endbattle", "chkDBPercentageChange", $g_abStopAtkPctNoChangeEnable[$DB] ? 1 : 0)
	_Ini_Add("endbattle", "txtDBPercentageChange", $g_aiStopAtkPctNoChangeTime[$DB])
EndFunc   ;==>SaveConfig_600_30_DB

Func SaveConfig_600_30_LB()
	; <><><><> Attack Plan / Search & Attack / Activebase / End Battle <><><><>
	ApplyConfig_600_30_LB(GetApplyConfigSaveAction())
	_Ini_Add("endbattle", "chkABTimeStopAtk", $g_abStopAtkNoLoot1Enable[$LB] ? 1 : 0)
	_Ini_Add("endbattle", "txtABTimeStopAtk", $g_aiStopAtkNoLoot1Time[$LB])
	_Ini_Add("endbattle", "chkABTimeStopAtk2", $g_abStopAtkNoLoot2Enable[$LB] ? 1 : 0)
	_Ini_Add("endbattle", "txtABTimeStopAtk2", $g_aiStopAtkNoLoot2Time[$LB])
	_Ini_Add("endbattle", "txtABMinGoldStopAtk2", $g_aiStopAtkNoLoot2MinGold[$LB])
	_Ini_Add("endbattle", "txtABMinElixirStopAtk2", $g_aiStopAtkNoLoot2MinElixir[$LB])
	_Ini_Add("endbattle", "txtABMinDarkElixirStopAtk2", $g_aiStopAtkNoLoot2MinDark[$LB])
	_Ini_Add("endbattle", "chkABEndNoResources", $g_abStopAtkNoResources[$LB] ? 1 : 0)
	_Ini_Add("endbattle", "chkABEndOneStar", $g_abStopAtkOneStar[$LB] ? 1 : 0)
	_Ini_Add("endbattle", "chkABEndTwoStars", $g_abStopAtkTwoStars[$LB] ? 1 : 0)
	_Ini_Add("endbattle", "chkDESideEB", $g_bDESideEndEnable ? 1 : 0)
	_Ini_Add("endbattle", "txtDELowEndMin", $g_iDESideEndMin)
	_Ini_Add("endbattle", "chkDisableOtherEBO", $g_bDESideDisableOther ? 1 : 0)
	_Ini_Add("endbattle", "chkDEEndAq", $g_bDESideEndAQWeak ? 1 : 0)
	_Ini_Add("endbattle", "chkDEEndBk", $g_bDESideEndBKWeak ? 1 : 0)
	_Ini_Add("endbattle", "chkDEEndOneStar", $g_bDESideEndOneStar ? 1 : 0)
	_Ini_Add("endbattle", "chkABPercentageHigher", $g_abStopAtkPctHigherEnable[$LB] ? 1 : 0)
	_Ini_Add("endbattle", "txtABPercentageHigher", $g_aiStopAtkPctHigherAmt[$LB])
	_Ini_Add("endbattle", "chkABPercentageChange", $g_abStopAtkPctNoChangeEnable[$LB] ? 1 : 0)
	_Ini_Add("endbattle", "txtABPercentageChange", $g_aiStopAtkPctNoChangeTime[$LB])
EndFunc   ;==>SaveConfig_600_30_LB

Func SaveConfig_600_31()
	; <><><><> Attack Plan / Search & Attack / Deadbase / Collectors <><><><>
	ApplyConfig_600_31(GetApplyConfigSaveAction())
	For $i = 6 To UBound($g_aiCollectorLevelFill) -1
		_Ini_Add("collectors", "lvl" & $i & "Enabled", $g_abCollectorLevelEnabled[$i] ? 1 : 0)
		_Ini_Add("collectors", "lvl" & $i & "fill", $g_aiCollectorLevelFill[$i])
	Next
	_Ini_Add("collectors", "minmatches", $g_iCollectorMatchesMin)
	_Ini_Add("collectors", "tolerance", $g_iCollectorToleranceOffset)
EndFunc   ;==>SaveConfig_600_31

Func SaveConfig_600_32()
	; <><><><> Attack Plan / Search & Attack / Options / Trophy Settings <><><><>
	ApplyConfig_600_32(GetApplyConfigSaveAction())
	_Ini_Add("search", "TrophyRange", $g_bDropTrophyEnable ? 1 : 0)
	_Ini_Add("search", "MaxTrophy", $g_iDropTrophyMax)
	_Ini_Add("search", "MinTrophy", $g_iDropTrophyMin)
	_Ini_Add("search", "chkTrophyHeroes", $g_bDropTrophyUseHeroes ? 1 : 0)
	_Ini_Add("search", "cmbTrophyHeroesPriority", $g_iDropTrophyHeroesPriority)
	_Ini_Add("search", "chkTrophyAtkDead", $g_bDropTrophyAtkDead ? 1 : 0)
	_Ini_Add("search", "DTArmyMin", $g_iDropTrophyArmyMinPct)
	; Drop Throphy - Team AIO Mod++
	_Ini_Add("search", "ChkNoDropIfShield", $g_bChkNoDropIfShield)
	_Ini_Add("search", "ChkTrophyTroops", $g_bChkTrophyTroops)
	_Ini_Add("search", "ChkTrophyHeroesAndTroops", $g_bChkTrophyHeroesAndTroops)
EndFunc   ;==>SaveConfig_600_32

Func SaveConfig_600_33()
	; <><><><> Attack Plan / Search & Attack / Drop Order Troops <><><><>
	_Ini_Add("DropOrder", "chkDropOrder", $g_bCustomDropOrderEnable ? 1 : 0)
	For $p = 0 To UBound($g_aiCmbCustomDropOrder) - 1
		_Ini_Add("DropOrder", "cmbDropOrder" & $p, $g_aiCmbCustomDropOrder[$p])
	Next
EndFunc   ;==>SaveConfig_600_33

Func SaveConfig_600_35_1()
	; <><><><> Bot / Options <><><><>
	ApplyConfig_600_35_1(GetApplyConfigSaveAction())
	_Ini_Add("other", "language", $g_sLanguage)
	_Ini_Add("General", "ChkDisableSplash", $g_bDisableSplash ? 1 : 0)
	_Ini_Add("General", "ChkVersion", $g_bCheckVersion ? 1 : 0)
	_Ini_Add("deletefiles", "DeleteLogs", $g_bDeleteLogs ? 1 : 0)
	_Ini_Add("deletefiles", "DeleteLogsDays", $g_iDeleteLogsDays)
	_Ini_Add("deletefiles", "DeleteTemp", $g_bDeleteTemp ? 1 : 0)
	_Ini_Add("deletefiles", "DeleteTempDays", $g_iDeleteTempDays)
	_Ini_Add("deletefiles", "DeleteLoots", $g_bDeleteLoots ? 1 : 0)
	_Ini_Add("deletefiles", "DeleteLootsDays", $g_iDeleteLootsDays)
	_Ini_Add("general", "AutoStart", $g_bAutoStart ? 1 : 0)
	_Ini_Add("general", "AutoStartDelay", $g_iAutoStartDelay)
	_Ini_Add("General", "ChkLanguage", $g_bCheckGameLanguage ? 1 : 0)
	_Ini_Add("general", "DisposeWindows", $g_bAutoAlignEnable ? 1 : 0)
	_Ini_Add("general", "DisposeWindowsPos", $g_iAutoAlignPosition)
	_Ini_Add("other", "WAOffsetX", $g_iAutoAlignOffsetX)
	_Ini_Add("other", "WAOffsetY", $g_iAutoAlignOffsetY)
	_Ini_Add("general", "UpdatingWhenMinimized", $g_bUpdatingWhenMinimized ? 1 : 0)
	_Ini_Add("general", "HideWhenMinimized", $g_bHideWhenMinimized ? 1 : 0)

	_Ini_Add("other", "UseRandomClick", $g_bUseRandomClick ? 1 : 0)
	_Ini_Add("other", "ScreenshotType", $g_bScreenshotPNGFormat ? 1 : 0)
	_Ini_Add("other", "ScreenshotHideName", $g_bScreenshotHideName ? 1 : 0)
	_Ini_Add("other", "txtTimeWakeUp", $g_iAnotherDeviceWaitTime)
	_Ini_Add("other", "chkSinglePBTForced", $g_bForceSinglePBLogoff ? 1 : 0)
	_Ini_Add("other", "ValueSinglePBTimeForced", $g_iSinglePBForcedLogoffTime)
	_Ini_Add("other", "ValuePBTimeForcedExit", $g_iSinglePBForcedEarlyExitTime)
	_Ini_Add("other", "ChkAutoResume", $g_bAutoResumeEnable ? 1 : 0)
	_Ini_Add("other", "AutoResumeTime", $g_iAutoResumeTime)
	_Ini_Add("other", "ChkDisableNotifications", $g_bDisableNotifications)
	_Ini_Add("other", "ChkFixClanCastle", $g_bForceClanCastleDetection ? 1 : 0)
	_Ini_Add("other", "ChkSqlite", $g_bUseStatistics ? 1 : 0)

	_Ini_Add("ProfileSCID", "OnlySCIDAccounts", $g_bOnlySCIDAccounts ? 1 : 0)
	_Ini_Add("ProfileSCID", "WhatSCIDAccount2Use", $g_iWhatSCIDAccount2Use)

EndFunc   ;==>SaveConfig_600_35_1

Func SaveConfig_600_35_2()
	; <><><><> Bot / Profile / Switch Accounts <><><><>
	ApplyConfig_600_35_2(GetApplyConfigSaveAction())

	Local $sSwitchAccFile
	Local $iCmbSwitchAcc = $g_iCmbSwitchAcc
	If $iCmbSwitchAcc = 0 Then
		; find group this profile belongs to: no switch profile config is saved in config.ini on purpose!
		For $g = 1 To 8
			$sSwitchAccFile = $g_sProfilePath & "\SwitchAccount.0" & $g & ".ini"
			If FileExists($sSwitchAccFile) = 0 Then ContinueLoop
			Local $sProfile
			Local $bEnabled
			For $i = 1 To 8
				$bEnabled = IniRead($sSwitchAccFile, "SwitchAccount", "Enable" & $i, "") = "1"
				If $bEnabled Then
					$bEnabled = IniRead($sSwitchAccFile, "SwitchAccount", "AccountNo." & $i, "") = "1"
					If $bEnabled Then
						$sProfile = IniRead($sSwitchAccFile, "SwitchAccount", "ProfileName." & $i, "")
						If $sProfile = $g_sProfileCurrentName Then
							; found current profile
							$iCmbSwitchAcc = $g
							ExitLoop 2
						EndIf
					EndIf
				EndIf
			Next
		Next
	EndIf
	If $iCmbSwitchAcc Then
		$sSwitchAccFile = $g_sProfilePath & "\SwitchAccount.0" & $iCmbSwitchAcc & ".ini"
		IniWrite($sSwitchAccFile, "SwitchAccount", "Enable", $g_bChkSwitchAcc ? 1 : 0)
		IniWrite($sSwitchAccFile, "SwitchAccount", "GooglePlay", $g_bChkGooglePlay ? 1 : 0)
		IniWrite($sSwitchAccFile, "SwitchAccount", "SuperCellID", $g_bChkSuperCellID ? 1 : 0)
		IniWrite($sSwitchAccFile, "SwitchAccount", "SharedPrefs", $g_bChkSharedPrefs ? 1 : 0)
		IniWrite($sSwitchAccFile, "SwitchAccount", "SmartSwitch", $g_bChkSmartSwitch ? 1 : 0)
		IniWrite($sSwitchAccFile, "SwitchAccount", "DonateLikeCrazy", $g_bDonateLikeCrazy ? 1 : 0)
		IniWrite($sSwitchAccFile, "SwitchAccount", "TotalCocAccount", $g_iTotalAcc)
		IniWrite($sSwitchAccFile, "SwitchAccount", "TrainTimeToSkip", $g_iTrainTimeToSkip)
		For $i = 1 To $g_eTotalAcc
			IniWrite($sSwitchAccFile, "SwitchAccount", "AccountNo." & $i, $g_abAccountNo[$i - 1] ? 1 : 0)
			IniWrite($sSwitchAccFile, "SwitchAccount", "ProfileName." & $i, $g_asProfileName[$i - 1])
			IniWrite($sSwitchAccFile, "SwitchAccount", "DonateOnly." & $i, $g_abDonateOnly[$i - 1] ? 1 : 0)

			; Farm Schedule - Team AiO MOD++
			IniWrite($sSwitchAccFile, "FarmStrategy", "ChkSetFarm" & $i, $g_abChkSetFarm[$i - 1] ? 1 : 0)

			IniWrite($sSwitchAccFile, "FarmStrategy", "CmbAction1" & $i, $g_aiCmbAction1[$i - 1])
			IniWrite($sSwitchAccFile, "FarmStrategy", "CmbCriteria1" & $i, $g_aiCmbCriteria1[$i - 1])
			IniWrite($sSwitchAccFile, "FarmStrategy", "TxtResource1" & $i, $g_aiTxtResource1[$i - 1])
			IniWrite($sSwitchAccFile, "FarmStrategy", "CmbTime1" & $i, $g_aiCmbTime1[$i - 1])

			IniWrite($sSwitchAccFile, "FarmStrategy", "CmbAction2" & $i, $g_aiCmbAction2[$i - 1])
			IniWrite($sSwitchAccFile, "FarmStrategy", "CmbCriteria2" & $i, $g_aiCmbCriteria2[$i - 1])
			IniWrite($sSwitchAccFile, "FarmStrategy", "TxtResource2" & $i, $g_aiTxtResource2[$i - 1])
			IniWrite($sSwitchAccFile, "FarmStrategy", "CmbTime2" & $i, $g_aiCmbTime2[$i - 1])
		Next

	EndIf

EndFunc   ;==>SaveConfig_600_35_2

Func SaveConfig_600_52_1()
	; <><><> Attack Plan / Train Army / Troops/Spells <><><>
	ApplyConfig_600_52_1(GetApplyConfigSaveAction())
	_Ini_Add("other", "ChkUseQTrain", $g_bQuickTrainEnable ? 1 : 0)

	For $i = 0 To 2
		_Ini_Add("troop", "QuickTrainArmy" & $i + 1, $g_bQuickTrainArmy[$i] ? 1 : 0)
		_Ini_Add("troop", "UseInGameArmy_" & $i + 1, $g_abUseInGameArmy[$i] ? 1 : 0)
		For $j = 0 To 6
			_Ini_Add("QuickTroop", "QuickTroopType_" & $i + 1 & "_Slot_" & $j, $g_aiQuickTroopType[$i][$j])
			_Ini_Add("QuickTroop", "QuickTroopQty_" & $i + 1 & "_Slot_" & $j, $g_aiQuickTroopQty[$i][$j])
			_Ini_Add("QuickTroop", "QuickSpellType_" & $i + 1 & "_Slot_" & $j, $g_aiQuickSpellType[$i][$j])
			_Ini_Add("QuickTroop", "QuickSpellQty_" & $i + 1 & "_Slot_" & $j, $g_aiQuickSpellQty[$i][$j])
		Next
		_Ini_Add("QuickTroop", "TotalQuickTroop" & $i + 1, $g_aiTotalQuickTroop[$i])
		_Ini_Add("QuickTroop", "TotalQuickSpell" & $i + 1, $g_aiTotalQuickSpell[$i])
	Next
	
EndFunc   ;==>SaveConfig_600_52_1

Func SaveConfig_600_52_2()
	; troop/spell levels and counts
	ApplyConfig_600_52_2(GetApplyConfigSaveAction())
	For $t = 0 To $eTroopCount - 1
		_Ini_Add("troop", $g_asTroopShortNames[$t], $g_aiArmyCustomTroops[$t])
		_Ini_Add("LevelTroop", $g_asTroopShortNames[$t], $g_aiTrainArmyTroopLevel[$t])
	Next

	For $s = 0 To $eSpellCount - 1
		_Ini_Add("Spells", $g_asSpellShortNames[$s], $g_aiArmyCustomSpells[$s])
		_Ini_Add("LevelSpell", $g_asSpellShortNames[$s], $g_aiTrainArmySpellLevel[$s])
	Next

	For $s = 0 To $eSiegeMachineCount - 1
		_Ini_Add("Siege", $g_asSiegeMachineShortNames[$s], $g_aiArmyCompSiegeMachines[$s])
		_Ini_Add("LevelSiege", $g_asSiegeMachineShortNames[$s], $g_aiTrainArmySiegeMachineLevel[$s])
	Next

	; full & forced Total Camp values
	_Ini_Add("troop", "fulltroop", $g_iTrainArmyFullTroopPct)
	_Ini_Add("other", "ChkTotalCampForced", $g_bTotalCampForced ? 1 : 0)
	_Ini_Add("other", "ValueTotalCampForced", $g_iTotalCampForcedValue)
	; spell capacity and forced flag
	_Ini_Add("Spells", "SpellFactory", $g_iTotalSpellValue)
	; DoubleTrain - Demen
	_Ini_Add("troop", "DoubleTrain", $g_bDoubleTrain ? 1 : 0)
	_Ini_Add("troop", "PreciseArmy", $g_bPreciseArmy ? 1 : 0)
	
	#Region - Custom train - Team AIO Mod++
    _Ini_Add("Sieges", "TxtTotalCountSiege", $g_iTotalSiegeValue)
    _Ini_Add("Sieges", "ChkPreciseSieges", $g_bPreciseSieges ? 1 : 0)
    _Ini_Add("Sieges", "ChkForcePreBuildSieges", $g_bForcePreBuildSieges ? 1 : 0)

	_Ini_Add("other", "IgnoreIncorrectTroopCombo", $g_bIgnoreIncorrectTroopCombo ? 1 : 0)
	_Ini_Add("other", "FillIncorrectTroopCombo", $g_iCmbFillIncorrectTroopCombo)
	_Ini_Add("other", "IgnoreIncorrectSpellCombo", $g_bIgnoreIncorrectSpellCombo ? 1 : 0)
	_Ini_Add("other", "FillIncorrectSpellCombo", $g_iCmbFillIncorrectSpellCombo)

	_Ini_Add("Spells", "PreciseBrew", $g_bPreciseBrew ? 1 : 0)
	_Ini_Add("Spells", "ForcePreBrewSpells", $g_bForcePreBrewSpells ? 1 : 0)

	_Ini_Add("troop", "ChkPreTrainTroopsPercent", $g_bChkPreTrainTroopsPercent ? 1 : 0)
	_Ini_Add("troop", "InpPreTrainTroopsPercent", $g_iInpPreTrainTroopsPercent)
	_Ini_Add("troop", "TrainBeforeAttack", $g_bTrainBeforeAttack ? 1 : 0)
	_Ini_Add("troop", "CmbTroopSetting", $g_iCmbTroopSetting)

	For $i = 0 To 2
		For $t = 0 To $eTroopCount - 1
			_Ini_Add("Cmbtroop" & $i, $g_asTroopShortNames[$t], $g_iCustomArmysMainVillage[$t][$i])
			; _Ini_Add("LevelTroop", $g_asTroopShortNames[$t], $g_aiTrainArmyTroopLevel[$t])
		Next

		For $s = 0 To $eSpellCount - 1
			_Ini_Add("CmbSpells" & $i, $g_asSpellShortNames[$s], $g_iCustomBrewMainVillage[$s][$i])
			; _Ini_Add("LevelSpell", $g_asSpellShortNames[$s], $g_aiTrainArmySpellLevel[$s])
		Next

		For $s = 0 To $eSiegeMachineCount - 1
			_Ini_Add("CmbSiege" & $i, $g_asSiegeMachineShortNames[$s], $g_iCustomSiegesMainVillage[$s][$i])
			; _Ini_Add("LevelSiege", $g_asSiegeMachineShortNames[$s], $g_aiTrainArmySiegeMachineLevel[$s])
		Next
	Next
	#EndRegion - Custom train - Team AIO Mod++
EndFunc   ;==>SaveConfig_600_52_2

Func SaveConfig_600_54()
	; <><><> Attack Plan / Train Army / Train Order <><><>
	ApplyConfig_600_54(GetApplyConfigSaveAction())

	; Troops Order - Team AIO Mod++
	Local $sTName = -1
	_Ini_Add("troop", "chkTroopOrder", $g_bCustomTrainOrderEnable ? 1 : 0)
	For $z = 0 To UBound($g_aiCmbCustomTrainOrder) - 1
		$sTName = GetTroopName($z, 1, True)
		If $sTName = -1 Then ContinueLoop
		_Ini_Add("troop", "cmbTroopOrder_" & $sTName, $g_aiCmbCustomTrainOrder[$z])
	Next

	; Spells Order - Team AIO Mod++
	Local $sSName = -1
	_Ini_Add("Spells", "chkSpellOrder", $g_bCustomBrewOrderEnable ? 1 : 0)
	For $z = 0 To UBound($g_aiCmbCustomBrewOrder) - 1
		$sSName = GetTroopName($z + $eLSpell, 1, True)
		If $sSName = -1 Then ContinueLoop
		_Ini_Add("Spells", "cmbSpellOrder_" & $sSName, $g_aiCmbCustomBrewOrder[$z])
	Next

	; Spells pre train - Team AIO Mod++
	Local $sSName = -1
	For $z = 0 To UBound($g_aiChkSpellsPre) - 1
		$sSName = GetTroopName($z + $eLSpell, 1, True)
		If $sSName = -1 Then ContinueLoop
		_Ini_Add("Spells", "chkSpellPre_" & $sSName, $g_aiChkSpellsPre[$z] ? 1 : 0)
	Next

	; Sieges Machines Order - Team AIO Mod++
	Local $sSgName = -1
	_Ini_Add("Sieges", "chkSiegeOrder", $g_bCustomBuildOrderEnable ? 1 : 0)
	For $z = 0 To UBound($g_aiCmbCustomBuildOrder) - 1
		$sSgName = GetTroopName($z + $eWallW, 1, True)
		If $sSgName = -1 Then ContinueLoop
		_Ini_Add("Sieges", "cmbSiegeOrder_" & $sSgName, $g_aiCmbCustomBuildOrder[$z])
	Next

	; Custom pets - Team AIO Mod++
	_Ini_Add("PetHouseSelector", "ChkPetHouseSelector", $g_bPetHouseSelector ? 1 : 0)
	_Ini_Add("PetHouseSelector", "CmbLassiPet", $g_iCmbLassiPet)
	_Ini_Add("PetHouseSelector", "CmbElectroOwlPet", $g_iCmbElectroOwlPet)
	_Ini_Add("PetHouseSelector", "CmbMightyYakPet", $g_iCmbMightyYakPet)
	_Ini_Add("PetHouseSelector", "CmbUnicornPet", $g_iCmbUnicornPet)
EndFunc   ;==>SaveConfig_600_54

#Region - Custom SmartZap - Team AIO Mod++
Func SaveConfig_600_56()
	; <><><><> Attack Plan / Search & Attack / Options / SmartZap <><><><>
	ApplyConfig_600_56(GetApplyConfigSaveAction())
	_Ini_Add("SmartZap", "UseSmartZap", $g_bSmartZapEnable ? 1 : 0)
	_Ini_Add("SmartZap", "UseEarthQuakeZap", $g_bEarthQuakeZap ? 1 : 0)
	_Ini_Add("SmartZap", "UseNoobZap", $g_bNoobZap ? 1 : 0)
	_Ini_Add("SmartZap", "ZapDBOnly", $g_bSmartZapDB ? 1 : 0)
	_Ini_Add("SmartZap", "THSnipeSaveHeroes", $g_bSmartZapSaveHeroes ? 1 : 0)
	_Ini_Add("SmartZap", "FTW", $g_bSmartZapFTW ? 1 : 0)
	_Ini_Add("SmartZap", "RemainTimeToZap", $g_iRemainTimeToZap)
	_Ini_Add("SmartZap", "DestroyCollectors", $g_bChkSmartZapDestroyCollectors ? 1 : 0)
	_Ini_Add("SmartZap", "DestroyMines", $g_bChkSmartZapDestroyMines ? 1 : 0)
	_Ini_Add("SmartZap", "MinDE", $g_iSmartZapMinDE)
	_Ini_Add("SmartZap", "ExpectedDE", $g_iSmartZapExpectedDE)
	_Ini_Add("SmartZap", "InpSmartZapTimes", $g_iInpSmartZapTimes)
EndFunc   ;==>SaveConfig_600_56
#EndRegion - Custom SmartZap - Team AIO Mod++

Func SaveConfig_641_1()
	; <><><> Attack Plan / Train Army / Options <><><>
	ApplyConfig_641_1(GetApplyConfigSaveAction())
	; Training idle time
	_Ini_Add("other", "chkCloseWaitEnable", $g_bCloseWhileTrainingEnable ? 1 : 0)
	_Ini_Add("other", "chkCloseWaitTrain", $g_bCloseWithoutShield ? 1 : 0)
	_Ini_Add("other", "btnCloseWaitStop", $g_bCloseEmulator ? 1 : 0)
	_Ini_Add("other", "btnCloseWaitSuspendComputer", $g_bSuspendComputer ? 1 : 0)
	_Ini_Add("other", "btnCloseWaitStopRandom", $g_bCloseRandom ? 1 : 0)
	_Ini_Add("other", "btnCloseWaitExact", $g_bCloseExactTime ? 1 : 0)
	_Ini_Add("other", "btnCloseWaitRandom", $g_bCloseRandomTime ? 1 : 0)
	_Ini_Add("other", "CloseWaitRdmPercent", $g_iCloseRandomTimePercent)
	_Ini_Add("other", "MinimumTimeToClose", $g_iCloseMinimumTime)
	; Train click timing
	_Ini_Add("other", "TrainITDelay", $g_iTrainClickDelay)
	; Training add random delay
	_Ini_Add("other", "chkAddIdleTime", $g_bTrainAddRandomDelayEnable ? 1 : 0)
	_Ini_Add("other", "txtAddDelayIdlePhaseTimeMin", $g_iTrainAddRandomDelayMin)
	_Ini_Add("other", "txtAddDelayIdlePhaseTimeMax", $g_iTrainAddRandomDelayMax)
EndFunc   ;==>SaveConfig_641_1

Func IniWriteS($filename, $section, $key, $value)
	;save in standard config files and also save settings in strategy ini file (save strategy button valorize variable $g_sProfileSecondaryOutputFileName )
	Local $s = $section
	Local $k = $key
	IniWrite($filename, $section, $key, $value)
EndFunc   ;==>IniWriteS

Func GetApplyConfigSaveAction()
	; in Mini GUI Mode the "Save" is replaced with "Save(disabled)" as controlls don't exists
	If $g_iGuiMode <> 1 Then
		Return "Save(disabled)"
	EndIf

	Return "Save"
EndFunc   ;==>GetApplyConfigSaveAction
