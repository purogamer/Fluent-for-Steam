; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design Bot Android
; Description ...: This file creates the "Android" tab under the "Bot" tab
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........:
; Modified ......: CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Global $g_hCmbCOCDistributors = 0, $g_hCmbAndroidBackgroundMode = 0, $g_hCmbAndroidZoomoutMode = 0, $g_hCmbSuspendAndroid = 0, $g_hChkAndroidAdbClick = 0, _
	$g_hChkAndroidAdbClickDragScript = 0, $g_hBtnAndroidAdbShell = 0, $g_hBtnAndroidHome = 0, $g_hBtnAndroidBack = 0, $g_hTxtAndroidRebootHours = 0, _
	$g_hChkAndroidCloseWithBot = 0, $g_hChkUpdateSharedPrefs = 0, $g_hBtnAndroidEnableTouch = 0, $g_hBtnAndroidDisableTouch = 0, $g_lblHelpBot = 0, _
	$g_hLblAdditionalClickDelay = 0, $g_hSldAdditionalClickDelay = 0, $g_hChkUseDedicatedAdbPort = 0, $g_hCmbAndroidReplaceAdb = 0, _
	$g_hCmbAndroidEmulator = 0, $g_hCmbAndroidInstance = 0

; Custom sleep - Team AIO Mod++ (inspired in Samkie)
Global $g_hInputAndroidSleep = 0

Func CreateBotAndroid()

	Local $x = 25, $y = 45, $y2, $w = 240, $h = 50, $sTxtTip
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR Distributors", "Group_01", "Distributors"), $x - 20, $y - 20, $w, $h) ; $g_iSizeWGrpTab2, $g_iSizeHGrpTab2
	$y -= 2
		$g_hCmbCOCDistributors = GUICtrlCreateCombo("", $x - 8, $y, $w - 25, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Distributors", "CmbCOCDistributors_Info_01", "Allow bot to launch COC based on the distribution chosen"))
			GUICtrlSetOnEvent(-1, "cmbCOCDistributors")
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = 280
	$y = 45
	$w = 185
	GUICtrlCreateGroup(GetTranslatedFileIni("Android", "Android_Click_Delay", "Additional Click Delay"), $x - 20, $y - 20, $w, $h)
	$sTxtTip = GetTranslatedFileIni("Android", "LblAdditionalClickDelay_Info", "Increase the delay if your PC is slow or to create human like click speed")
	$g_hLblAdditionalClickDelay = GUICtrlCreateLabel($g_iAndroidControlClickAdditionalDelay & " ms", $x + $w - 65, $y + 5, 37, 30, $SS_RIGHT)
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hSldAdditionalClickDelay = GUICtrlCreateSlider($x - 15, $y, $w - 44, 25, $TBS_AUTOTICKS)
	_GUICtrlSetTip(-1, $sTxtTip)
	_GUICtrlSlider_SetTipSide(-1, $TBTS_BOTTOM)
	_GUICtrlSlider_SetTicFreq(-1, 2)
	GUICtrlSetLimit(-1, 50, 0) ; 50 position multiplied by 2
	GUICtrlSetData(-1, Int($g_iAndroidControlClickAdditionalDelay / 2)) ; default value
	GUICtrlSetBkColor(-1, $COLOR_WHITE)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$y += 52
	$x -= 60
	GUICtrlCreateGroup(GetTranslatedFileIni("Android Control", "Group_03", "Help"), $x + 92, $y - 20, 170 - 37, 45)
		$g_lblHelpBot = GUICtrlCreateLabel("Command line Help ?", $x + 70 - 2, $y, 150, 24, $SS_RIGHT)
			GUICtrlSetOnEvent($g_lblHelpBot, "ShowControlHelp")
			GUICtrlSetCursor(-1, 0)
			GUICtrlSetFont(-1, 8.5, $FW_BOLD)
			_GUICtrlSetTip(-1, "Click here to get help about command line and option for MyBot.run!")
			GUICtrlSetColor(-1, $COLOR_NAVY)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	; Custom sleep - Team AIO Mod++ (inspired in Samkie)
	$x -= 126
	GUICtrlCreateGroup(GetTranslatedFileIni("Android Control", "Group_05", "Extra delay percentage"), $x + 81, $y - 20, 132, 45)
		$g_hInputAndroidSleep = _GUICtrlCreateInput("0", $x + 111, $y - 5, 40, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_NUMBER))
		GUICtrlSetOnEvent($g_hInputAndroidSleep, "InputAndroidSleep")
		GUICtrlSetLimit($g_hInputAndroidSleep, 3) 
		GUICtrlCreateLabel(" %", $x + 131, $y + 1, 37, 30, $SS_RIGHT)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = 25
	GUICtrlCreateGroup(GetTranslatedFileIni("Android Control", "Group_04", "Emulator/Instance"), $x - 20, $y - 20, 165, 45)
		$g_hCmbAndroidEmulator = GUICtrlCreateCombo("", $x - 10, $y - 5, 70, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			_GUICtrlSetTip(-1, GetTranslatedFileIni("Android Control", "CmbAndroidEmulator_Info", "Change the emulator. MyBot will automaticly detect the installed version."))
			GUICtrlSetOnEvent(-1, "cmbAndroidEmulator")
		$g_hCmbAndroidInstance = GUICtrlCreateCombo("", $x + 65, $y - 5, 70, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			_GUICtrlSetTip(-1, GetTranslatedFileIni("Android Control", "CmbAndroidInstance_Info", "Change the instance. MyBot will automaticly detect the available instance."))
			GUICtrlSetOnEvent(-1, "cmbAndroidInstance")
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = 25
	$y += $h
	$y2 = $y
	$w = $g_iSizeWGrpTab2 - 2
	$h = 8 * 25
	GUICtrlCreateGroup(GetTranslatedFileIni("Android", "Android_Options", "Android Options"), $x - 20, $y - 20, $w, $h)
		GUICtrlCreateLabel(GetTranslatedFileIni("Android", "LblBackgroundMode", "Screencapture Background Mode"), $x - 8, $y + 5, 180, 22, $SS_RIGHT)
		$g_hCmbAndroidBackgroundMode = GUICtrlCreateCombo("", $x - 8 + 180 + 5, $y, 200, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, GetTranslatedFileIni("Android", "CmbBackgroundMode", "Default|Use WinAPI (need Android DirectX)|Use ADB screencap"))
			_GUICtrlSetTip(-1, GetTranslatedFileIni("Android", "CmbBackgroundMode_Info", 'Control how the Android screenshot is taken in background mode.\nDefault chooses WinAPI or screencap based on Android Emulator.\nInfo: WinAPI is faster than screencap, but screencap always works,\neven if screen is off (we call that the "True Background Mode")!'))
			_GUICtrlComboBox_SetCurSel(-1, $g_iAndroidBackgroundMode)
			GUICtrlSetOnEvent(-1, "cmbAndroidBackgroundMode")
	$y += 25
		GUICtrlCreateLabel(GetTranslatedFileIni("Android", "LblZoomoutMode", "Zoomout Mode"), $x - 8, $y + 5, 180, 22, $SS_RIGHT)
		$g_hCmbAndroidZoomoutMode = GUICtrlCreateCombo("", $x - 8 + 180 + 5, $y, 200, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, GetTranslatedFileIni("Android", "CmbZoomoutMode", "Default|Use Minitouch script|Use dd script|WinAPI|Update shared_prefs"))
			_GUICtrlSetTip(-1, GetTranslatedFileIni("Android", "CmbZoomoutMode_Info", 'Control how the zoomout is done. Default chooses usually Minitouch script, which is most stable.'))
			_GUICtrlComboBox_SetCurSel(-1, $g_iAndroidZoomoutMode)
	$y += 25
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR Distributors", "LblAdvanced_Android_Options", "Suspend/Resume Android"), $x - 8, $y + 5, 180, 22, $SS_RIGHT)
		$g_hCmbSuspendAndroid = GUICtrlCreateCombo("", $x - 8 + 180 + 5, $y, 200, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, GetTranslatedFileIni("MBR Distributors", "CmbSuspendAndroid_Item_01", "Disabled|Only during Search/Attack|For every Image processing call"))
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR Distributors", "CmbSuspendAndroid_Info_01", 'Specify if Android will be suspended for brief time only during search and attack or\r\nfor every ImgLoc/Image processing call. If you experience more frequent network issues\r\ntry to use "Only during Search/Attack" option or disable this feature.'))
			_GUICtrlComboBox_SetCurSel(-1, AndroidSuspendFlagsToIndex($g_iAndroidSuspendModeFlags))
			GUICtrlSetOnEvent(-1, "cmbSuspendAndroid")
	$y += 25
		GUICtrlCreateLabel(GetTranslatedFileIni("Android", "LblReplaceAdb", "Replace ADB"), $x - 8, $y + 5, 180, 22, $SS_RIGHT)
		$g_hCmbAndroidReplaceAdb = GUICtrlCreateCombo("", $x - 8 + 180 + 5, $y, 200, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, GetTranslatedFileIni("Android", "CmbReplaceAdb", "Don't replace adb.exe|With My Bot adb.exe|With dummy exe"))
			_GUICtrlSetTip(-1, GetTranslatedFileIni("Android", "CmbReplaceAdb_Info", 'Configure if Android Emulator adb.exe should be replaced with My Bot adb.exe or a dummy.exe to solve adb issues.'))
			_GUICtrlComboBox_SetCurSel(-1, $g_iAndroidAdbReplace)
	$y += 25
		$g_hChkAndroidAdbClick = GUICtrlCreateCheckbox(GetTranslatedFileIni("Android", "ChkAdbClick", "Use minitouch for Click"), $x, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("Android", "ChkAdbClick_Info", "Use minitouch for Android clicks.\r\nIf unchecked use WinAPI control messages."))
			GUICtrlSetState(-1, (($g_bAndroidAdbClickEnabled) ? ($GUI_CHECKED) : ($GUI_UNCHECKED)))
	$y += 25
		$g_hChkAndroidAdbClickDragScript = GUICtrlCreateCheckbox(GetTranslatedFileIni("Android", "ChkAdbClickDragScript", "Use minitouch for accurate Click && Drag"), $x, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("Android", "ChkAdbClickDragScript_Info", "Use minitouch for accurate Click & Drag.\r\nIf unchecked use more compatible 'input swipe' or WinAPI."))
			GUICtrlSetState(-1, (($g_bAndroidAdbClickDragScript) ? ($GUI_CHECKED) : ($GUI_UNCHECKED)))

	$y += 25
		$g_hChkAndroidCloseWithBot = GUICtrlCreateCheckbox(GetTranslatedFileIni("Android", "ChkAndroidCloseWithBot", "Close Android with bot"), $x, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("Android", "ChkAndroidCloseWithBot_Info", "Close also Android Emulator when bot exists."))
			GUICtrlSetState(-1, (($g_bAndroidCloseWithBot) ? ($GUI_CHECKED) : ($GUI_UNCHECKED)))

		$g_hChkUseDedicatedAdbPort = GUICtrlCreateCheckbox(GetTranslatedFileIni("Android", "ChkUseDedicatedAdbPort", "Use dedicated ADB port"), $x + 227, $y - 50, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("Android", "ChkUseDedicatedAdbPort_Info", "Use dedicated ADB instance on unique port. Disable can fix ""device offline"" issues."))
			GUICtrlSetState(-1, (($g_bAndroidAdbPortPerInstance) ? ($GUI_CHECKED) : ($GUI_UNCHECKED)))

		$g_hChkUpdateSharedPrefs = GUICtrlCreateCheckbox(GetTranslatedFileIni("Android", "ChkUpdateSharedPrefs", "Update shared_prefs"), $x + 227, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("Android", "ChkUpdateSharedPrefs_Info", "Pull and push shared_prefs to reset zoom,\nset language to English, disable snow and rate popup."))
			GUICtrlSetState(-1, (($g_bUpdateSharedPrefs) ? ($GUI_CHECKED) : ($GUI_UNCHECKED)))

	$y += 25
		GUICtrlCreateLabel(GetTranslatedFileIni("Android", "LblAndroidRebootHours", "Reboot Android in") & ":", $x + 227, $y - 48, -1, -1)
			$sTxtTip = GetTranslatedFileIni("Android", "LblAndroidRebootHours_Info", "Enter hours when Android will be automatically rebooted after specified run-time.")
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hTxtAndroidRebootHours = _GUICtrlCreateInput($g_iAndroidRebootHours, $x + 327, $y - 49, 30, 16, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetLimit(-1, 4)
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "hrs", -1), $x + 362, $y - 48, -1, -1)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$y = $y2 + $h
	$y2 = $y
	$w = 240
	$h = 110
	GUICtrlCreateGroup(GetTranslatedFileIni("Android Control", "Group_01", "Android Control"), $x - 20, $y - 20, $w, $h)
	$y -= 2
		$g_hBtnAndroidAdbShell = GUICtrlCreateButton(GetTranslatedFileIni("Android Control", "BtnAndroidAdbShell", "Start ADB Shell in new Console Window"), $x - 8, $y, 220, 25)
			GUICtrlSetOnEvent(-1, "OpenAdbShell")
	$y += 30
		$g_hBtnAndroidHome = GUICtrlCreateButton(GetTranslatedFileIni("Android Control", "BtnAndroidHome", "Send Home"), $x - 8, $y, 105, 25)
			GUICtrlSetOnEvent(-1, "AndroidHomeButton")
		$g_hBtnAndroidBack = GUICtrlCreateButton(GetTranslatedFileIni("Android Control", "BtnAndroidBack", "Send Back"), $x - 8 + 115, $y, 105, 25)
			GUICtrlSetOnEvent(-1, "AndroidBackButton")
	$y += 30
		$g_hBtnAndroidEnableTouch = GUICtrlCreateButton(GetTranslatedFileIni("Android Control", "EnableShowTouchs", "Enable Touchs"), $x - 8, $y, 105, 25)
			GUICtrlSetOnEvent(-1, "EnableShowTouchs")
		$g_hBtnAndroidDisableTouch = GUICtrlCreateButton(GetTranslatedFileIni("Android Control", "DisableShowTouchs", "Disable Touchs"), $x - 8 + 115, $y, 105, 25)
			GUICtrlSetOnEvent(-1, "DisableShowTouchs")
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	;$x = 25 + $g_iSizeWGrpTab2 - 2 - 10 - $w
	$x = 25 + 240 + 5
	$y = $y2
	$w = 195
	$h = 110
	GUICtrlCreateGroup(GetTranslatedFileIni("Android Control", "Group_02", "Install Play Store Apps"), $x - 20, $y - 20, $w, $h)
	$y -= 2
		GUICtrlCreateButton(GetTranslatedFileIni("Android Control", "BtnPlayStoreGame", "Clash of Clans"), $x - 8, $y, $w - 24, 25)
			GUICtrlSetOnEvent(-1, "OpenPlayStoreGame")
	$y += 30
		GUICtrlCreateButton(GetTranslatedFileIni("Android Control", "BtnPlayStoreGooglePlayServices", "Google Play Services"), $x - 8, $y, $w - 24, 25)
			GUICtrlSetOnEvent(-1, "OpenPlayStoreGooglePlayServices")
	$y += 30
		GUICtrlCreateButton(GetTranslatedFileIni("Android Control", "BtnPlayStoreNovaLauncher", "Nova Launcher"), $x - 8, $y, $w - 24, 25)
			GUICtrlSetOnEvent(-1, "OpenPlayStoreNovaLauncher")
	GUICtrlCreateGroup("", -99, -99, 1, 1)

EndFunc   ;==>CreateBotAndroid
