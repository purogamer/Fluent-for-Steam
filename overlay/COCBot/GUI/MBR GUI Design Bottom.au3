; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file creates the bottom panel
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: GKevinOD (2014)
; Modified ......: DkEd, Hervidero (2015), CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Global $g_hBtnStart = 0, $g_hBtnStop = 0, $g_hBtnPause = 0, $g_hBtnResume = 0, $g_hBtnSearchMode = 0, $g_hBtnMakeScreenshot = 0, $g_hBtnHide = 0, $g_hBtnEmbed = 0, _
	   $g_hChkBackgroundMode = 0, $g_hLblDonate = 0, $g_hBtnAttackNowDB = 0, $g_hBtnAttackNowLB = 0, $g_hBtnAttackNowTS = 0
Global $g_hPicTwoArrowShield = 0, $g_hLblVersion = 0, $g_hPicArrowLeft = 0, $g_hPicArrowRight = 0
Global $g_hGrpVillage = 0
Global $g_hLblResultGoldNow = 0, $g_hLblResultGoldHourNow = 0, $g_hPicResultGoldNow = 0, $g_hPicResultGoldTemp = 0
Global $g_hLblResultElixirNow = 0, $g_hLblResultElixirHourNow = 0, $g_hPicResultElixirNow = 0, $g_hPicResultElixirTemp = 0
Global $g_hLblResultDENow = 0, $g_hLblResultDEHourNow = 0, $g_hPicResultDENow = 0, $g_hPicResultDETemp = 0
Global $g_hLblResultTrophyNow = 0, $g_hPicResultTrophyNow = 0, $g_hLblResultRuntimeNow = 0, $g_hPicResultRuntimeNow = 0, $g_hLblResultBuilderNow = 0, $g_hPicResultBuilderNow = 0
Global $g_hLblResultAttackedHourNow = 0, $g_hPicResultAttackedHourNow = 0, $g_hLblResultGemNow = 0, $g_hPicResultGemNow = 0, $g_hLblResultSkippedHourNow = 0, $g_hPicResultSkippedHourNow = 0
Global $g_hLblVillageReportTemp = 0

; GLOBALS FOR NEW GAME STATUS DISPALY
Global $g_hlblKing = 0, $g_hPicKingGray = 0, $g_hPicKingBlue = 0, $g_hPicKingRed = 0, $g_hPicKingGreen = 0
Global $g_hlblQueen = 0, $g_hPicQueenGray = 0, $g_hPicQueenBlue = 0, $g_hPicQueenRed = 0, $g_hPicQueenGreen = 0
Global $g_hlblWarden = 0, $g_hPicWardenGray = 0, $g_hPicWardenBlue = 0, $g_hPicWardenRed = 0, $g_hPicWardenGreen = 0
Global $g_hlblChampion = 0, $g_hPicChampionGray = 0, $g_hPicChampionBlue = 0, $g_hPicChampionRed = 0, $g_hPicChampionGreen = 0
Global $g_hlblLab = 0, $g_hPicLabGray = 0, $g_hPicLabRed = 0, $g_hPicLabGreen = 0, $g_hLbLLabTime = 0

#Region AIO MOD++
;Mod Logo
; Global $g_hLblMod = 0
; Enable/Disable GUI while botting - Team AiO MOD++
Global $g_hCmbStatusMode = 0
Global $g_hBtnEnableGUI = 0, $g_hBtnDisableGUI = 0
Global $g_hLblBBResultGoldNow = 0, $g_hLblBBResultGoldHourNow = 0, $g_hPicBBResultGoldNow = 0
Global $g_hLblBBResultElixirNow = 0, $g_hLblBBResultElixirHourNow = 0, $g_hPicBBResultElixirNow = 0
Global $g_hLblBBResultTrophyNow = 0, $g_hPicBBResultTrophyNow = 0, $g_hLblBBResultBuilderNow = 0, $g_hPicBBResultBuilderNow = 0

#EndRegion

; Pet House
Global $g_hlblPet = 0, $g_hPicPetGray = 0, $g_hPicPetRed = 0, $g_hPicPetGreen = 0, $g_hLbLPetTime = 0

Func CreateBottomPanel()
	Local $sTxtTip = ""
	;~ ------------------------------------------------------
	;~ Lower part visible on all Tabs
	;~ ------------------------------------------------------

	;~ Buttons
	Local $y_bottom = 0 ; 515
	Local $x = 10, $y = $y_bottom
	; GUICtrlCreateGroup("https://mybot.run " & GetTranslatedFileIni("MBR GUI Design Bottom", "Group_01", "- freeware bot -"), $x - 5, $y - 10, 190, 108 - 15)
	#Region GUI - Team Aio Mod++
	$g_hBtnStart = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Bottom", "BtnStart", "Start Bot"), $x, $y, 90, 28)
		_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Bottom", "BtnStart_Info_01", "Use this to START the bot."))
		GUICtrlSetOnEvent(-1, "btnStart")
		If $g_bBtnColor then GUICtrlSetBkColor(-1, 0x5CAD85)
		GUICtrlSetState(-1, $GUI_DISABLE)
	$g_hBtnStop = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Bottom", "BtnStop", "Stop Bot"), -1, -1, 90, 28)
		_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Bottom", "BtnStop_Info_01", "Use this to STOP the bot (or ESC key)."))
		If $g_bBtnColor then GUICtrlSetBkColor(-1, 0xDB4D4D)
		GUICtrlSetState(-1, $GUI_HIDE)
	$g_hBtnPause = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Bottom", "BtnPause", "Pause"), $x + 90, -1, 90, 28)
		_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Bottom", "BtnPause_Info_01", "Use this to PAUSE all actions of the bot until you Resume (or Pause/Break key)."))
		If $g_bBtnColor then GUICtrlSetBkColor(-1,  0xFFA500)
		GUICtrlSetState(-1, $GUI_HIDE)
	$g_hBtnResume = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Bottom", "BtnResume", "Resume"), -1, -1, 90, 28)
		_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Bottom", "BtnResume_Info_01", "Use this to RESUME a paused Bot (or Pause/Break key)."))
		If $g_bBtnColor then GUICtrlSetBkColor(-1,  0xFFA500)
		GUICtrlSetState(-1, $GUI_HIDE)
	$g_hBtnSearchMode = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Bottom", "BtnSearchMode", "Search Mode"), -1, -1, 90, 28)
		_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Bottom", "BtnSearchMode_Info_01", "Does not attack. Searches for a Village that meets conditions."))
		GUICtrlSetOnEvent(-1, "btnSearchMode")
		If $g_bBtnColor then GUICtrlSetBkColor(-1,  0xFFA500)
		GUICtrlSetState(-1, $GUI_DISABLE)
	; Enable/Disable GUI while botting - Team AiO MOD++
	   	 $g_hBtnEnableGUI = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Bottom", "BtnEnableGUI", "Enable GUI"), $x + 180, -1, 82, 28)
		   	 _GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Bottom", "BtnEnableGUI_Info_01", "Enable GUI control while botting") & @CRLF & _
			 				  GetTranslatedFileIni("MBR GUI Design Bottom", "BtnEnableGUI_Info_02", "Warning: USE THIS WITH CAUTION!") & @CRLF & _
			 				  GetTranslatedFileIni("MBR GUI Design Bottom", "BtnEnableGUI_Info_03", "This function may create errors that require bot/PC restart") & @CRLF & _
			 				  GetTranslatedFileIni("MBR GUI Design Bottom", "BtnEnableGUI_Info_04", "Better to stop the Bot completely if you need to change the setting"))
		   	 GUICtrlSetOnEvent(-1, "btnEnableGUI")
		   	 GUICtrlSetState(-1, $GUI_HIDE)
	   	 $g_hBtnDisableGUI = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Bottom", "BtnDisableGUI", "Disable GUI"), $x + 180, -1, 82, 28)
		   	 _GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Bottom", "BtnDisableGUI_Info_01", "Disable GUI control to continue botting"))
			  GUICtrlSetOnEvent(-1, "btnDisableGUI")
		  	  GUICtrlSetState(-1, $GUI_HIDE)

	$g_hBtnMakeScreenshot = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Bottom", "BtnMakeScreenshot", "Photo"), $x , $y + 28, 40, -1)
		_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Bottom", "BtnMakeScreenshot_Info_01", "Click here to take a snapshot of your village and save it to a file."))
		If $g_bBtnColor then GUICtrlSetBkColor(-1, 0x5CAD85)
	$g_hBtnHide = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Bottom", "BtnHide", "Hide"), $x + 40, $y + 28, 50, -1)
		_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Bottom", "BtnHide_Info_01", "Use this to move the Android Window out of sight.") & @CRLF & _
							GetTranslatedFileIni("MBR GUI Design Bottom", "BtnHide_Info_02", "(Not minimized, but hidden)"))
		If $g_bBtnColor Then GUICtrlSetBkColor(-1, 0x22C4F5)
		GUICtrlSetState(-1, $GUI_DISABLE)
	$g_hBtnEmbed = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Bottom", "BtnEmbed", "Dock"), $x + 90, $y + 28, 90, -1)
		_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Bottom", "BtnEmbed_Info_01", "Use this to embed the Android Window into Bot."))
		If $g_bBtnColor Then GUICtrlSetBkColor(-1, 0x22C4F5)
		GUICtrlSetState(-1, $GUI_DISABLE)
		GUICtrlSetOnEvent(-1, "btnEmbed")
	$y -=18
	#EndRegion - Team Aio Mod++
		$g_hChkBackgroundMode = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Bottom", "ChkBackgroundMode", "Background Mode"), $x + 1, $y + 72, 95, 20) ; Team AiO MOD++
			GUICtrlSetFont(-1, 7)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Bottom", "ChkBackgroundMode_Info_01", "Check this to ENABLE the Background Mode of the Bot.") & @CRLF & _
							   GetTranslatedFileIni("MBR GUI Design Bottom", "ChkBackgroundMode_Info_02", "With this you can also hide the Android Emulator window out of sight."))
			If $g_bGuiRemote Then GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetOnEvent(-1, "chkBackground")
			GUICtrlSetState(-1, (($g_bAndroidAdbScreencap = True) ? ($GUI_CHECKED) : ($GUI_UNCHECKED)))
		#Region - Team AiO MOD++
		; Only farm - Team AiO MOD++
		$g_hCmbStatusMode = GUICtrlCreateCombo("", $x + 100, $y + 72, 82, 20, $CBS_DROPDOWNLIST)
			GUICtrlSetData(-1, GetTranslatedFileIni("MBR GUI Design Bottom", "ComboStatusMode_Normal", "Normal Farm") & "|" & _ 
			GetTranslatedFileIni("MBR GUI Design Bottom", "ComboStatusMode_Farm", "Farm Mode") & "|" & _ 
			GetTranslatedFileIni("MBR GUI Design Bottom", "ComboStatusMode_BB", "Builder Base Mode"))
			_GUICtrlComboBox_SetCurSel(-1, 0)
			GUICtrlSetOnEvent(-1, "ComboStatusMode")
	$y +=18

		$g_hBtnAttackNowDB = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Bottom", "BtnAttackNowDB", "DB Attack"), $x + 200, $y - 1, 60, 19)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_hBtnAttackNowLB = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Bottom", "BtnAttackNowLB", "LB Attack"), $x + 200, $y + 18, 60, 19)
			GUICtrlSetState(-1, $GUI_HIDE)
		#EndRegion 
#cs
		$g_hLblDonate = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Bottom", "LblDonate", "Support the Development"), $x + 293, $y + 80, 142, 24, $SS_RIGHT)
			GUICtrlSetCursor(-1, 0) ; https://www.autoitscript.com/autoit3/docs/functions/MouseGetCursor.htm
			GUICtrlSetFont(-1, 8.5, $FW_BOLD) ;, $GUI_FONTITALIC + $GUI_FONTUNDER)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Bottom", "LblDonate_Info_01", "Paypal Donate?"))
#Ce
	; GUICtrlCreateGroup("", -99, -99, 1, 1)

		If $g_bAndroidAdbScreencap Then chkBackground() ; update background mode GUI

		; $g_hLblMod = _GUICtrlCreateIcon($g_sLibModIconPath, $eIcnAIOMod, $x + 225, $y + 30, 32, 32) ; AIO MOD++

		$g_hPicArrowLeft = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnArrowLeft, $x + 269, $y + 40, 16, 16)
		$sTxtTip = GetTranslatedFileIni("MBR GUI Design Bottom", "GrpVillage_Info_01", "Switch between village info and stats")
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hPicArrowRight = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnArrowRight, $x + 247 + 198, $y + 40, 16, 16)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState(-1, $GUI_SHOW)

		;New section for royal and lab status
		Local $x = 199, $y = $y_bottom
		$sTxtTip = GetTranslatedFileIni("MBR GUI Design Bottom", "GrpStatus_Info_01", "Gray - N/A" & @CRLF & "Green - Ready" & @CRLF & "Blue - Healing" & @CRLF & "Red - Upgrading")
		$g_hPicKingGray = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnGrayShield, $x, $y, 16, 16)
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hPicKingBlue = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnBlueShield, $x, $y, 16, 16)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_hPicKingGreen = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnGreenShield, $x, $y, 16, 16)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_hPicKingRed = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnRedShield, $x, $y, 16, 16)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_hlblKing = GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design Names Troops", "King_K", "K"), $x + 4, $y + 18, 10, 16, $SS_LEFT)
			_GUICtrlSetTip(-1, $sTxtTip)

	$x += 19
		$g_hPicQueenGray = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnGrayShield, $x, $y, 16, 16 )
	  		_GUICtrlSetTip(-1, $sTxtTip)
		$g_hPicQueenBlue = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnBlueShield, $x, $y, 16, 16 )
	  		_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_hPicQueenGreen = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnGreenShield, $x, $y, 16, 16 )
	  		_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_hPicQueenRed = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnRedShield, $x, $y, 16, 16 )
	  		_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_hlblQueen = GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design Names Troops", "Queen_Q", "Q"), $x + 4, $y + 18, 10, 16, $SS_LEFT)
	  		_GUICtrlSetTip(-1, $sTxtTip)


	$x += 19
		$g_hPicWardenGray = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnGrayShield, $x, $y, 16, 16 )
	  		_GUICtrlSetTip(-1, $sTxtTip)
		$g_hPicWardenBlue = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnBlueShield, $x, $y, 16, 16 )
	  		_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_hPicWardenGreen = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnGreenShield, $x, $y, 16, 16 )
	  		_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_hPicWardenRed = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnRedShield, $x, $y, 16, 16 )
	  		_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_hlblWarden = GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design Names Troops", "Warden_W", "W"), $x + 4, $y + 18, 10, 16, $SS_LEFT)
	  		_GUICtrlSetTip(-1, $sTxtTip)

	$x += 19
		$g_hPicChampionGray = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnGrayShield, $x, $y, 16, 16 )
	  		_GUICtrlSetTip(-1, $sTxtTip)
		$g_hPicChampionBlue = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnBlueShield, $x, $y, 16, 16 )
	  		_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_hPicChampionGreen = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnGreenShield, $x, $y, 16, 16 )
	  		_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_hPicChampionRed = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnRedShield, $x, $y, 16, 16 )
	  		_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_hlblChampion = GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design Names Troops", "Champion_C", "C"), $x + 4, $y + 18, 10, 16, $SS_LEFT)
	  		_GUICtrlSetTip(-1, $sTxtTip)

	; Pet House display
	$x -= 19 * 3
	$Y += 30

		$sTxtTip = GetTranslatedFileIni("MBR GUI Design Bottom","GrpStatus_Info_02", "Gray - N/A" & @CRLF & "Green - Pet House is Running" & @CRLF & "Red - Pet House Has Stopped")
		$g_hPicPetGray = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnGrayShield, $x , $y, 16, 16 )
	  		_GUICtrlSetTip(-1, $sTxtTip)
		$g_hPicPetGreen = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnGreenShield, $x, $y, 16, 16 )
	  		_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_hPicPetRed = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnRedShield, $x, $y, 16, 16 )
	  		_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_hlblPet = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Bottom", "Pet_P", "P"), $x + 4, $y + 21, 10, 16, $SS_LEFT)
	  		_GUICtrlSetTip(-1, $sTxtTip)
		$g_hLbLPetTime = GUICtrlCreateLabel("", $x + 20, $y + 2, 50, 16, $SS_LEFT)

	$x += 19 * 4
	$Y -= 30

		$sTxtTip = GetTranslatedFileIni("MBR GUI Design Bottom","GrpStatus_Info_02", "Gray - N/A" & @CRLF & "Green - Lab is Running" & @CRLF & "Red - Lab Has Stopped")
		$g_hPicLabGray = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnGrayShield, $x , $y, 16, 16 )
	  		_GUICtrlSetTip(-1, $sTxtTip)
		$g_hPicLabGreen = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnGreenShield, $x, $y, 16, 16 )
	  		_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_hPicLabRed = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnRedShield, $x, $y, 16, 16 )
	  		_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState(-1, $GUI_HIDE)
		$g_hlblLab = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Bottom", "Lab_L", "L"), $x + 4, $y + 18, 10, 16, $SS_LEFT)
	  		_GUICtrlSetTip(-1, $sTxtTip)
		$g_hLbLLabTime = GUICtrlCreateLabel("", $x - 54, $y + 35, 50, 16, $SS_LEFT)


   ;~ Village
   Local $x = 295, $y = $y_bottom + 20
   $g_hGrpVillage = GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Bottom", "GrpVillage", "Village"), $x + 0, $y - 20, 160, 75)
	   $g_hLblResultGoldNow = GUICtrlCreateLabel("", $x + 10, $y - 2, 60, 15, $SS_RIGHT)
	   $g_hLblBBResultGoldNow = GUICtrlCreateLabel("", $x + 10, $y - 2, 60, 15, $SS_RIGHT)
		   GUICtrlSetState(-1, $GUI_HIDE)
	   $g_hLblResultGoldHourNow = GUICtrlCreateLabel("", $x + 10, $y - 2, 60, 15, $SS_RIGHT)
		   GUICtrlSetState(-1, $GUI_HIDE)
	    $g_hLblBBResultGoldHourNow = GUICtrlCreateLabel("", $x + 10, $y - 2, 60, 15, $SS_RIGHT)
		   GUICtrlSetState(-1, $GUI_HIDE)
	   $g_hPicResultGoldNow = GUICtrlCreateIcon ($g_sLibIconPath, $eIcnGold, $x + 71, $y - 4, 16, 16)
		   GUICtrlSetState(-1, $GUI_HIDE)
	   $g_hPicBBResultGoldNow = GUICtrlCreateIcon ($g_sLibIconPath, $eIcnGold, $x + 71, $y - 4, 16, 16)
		   GUICtrlSetState(-1, $GUI_HIDE)
	   $g_hPicResultGoldTemp = GUICtrlCreateIcon ($g_sLibIconPath, $eIcnGold, $x + 15, $y - 4, 16, 16)

	   $g_hLblResultElixirNow = GUICtrlCreateLabel("", $x + 10, $y + 18, 60, 15, $SS_RIGHT)
	   $g_hLblBBResultElixirNow = GUICtrlCreateLabel("", $x + 10, $y + 18, 60, 15, $SS_RIGHT)
		   GUICtrlSetState(-1, $GUI_HIDE)
	   $g_hLblResultElixirHourNow = GUICtrlCreateLabel("", $x + 10, $y + 18, 60, 15, $SS_RIGHT)
		   GUICtrlSetState(-1, $GUI_HIDE)
	   $g_hLblBBResultElixirHourNow = GUICtrlCreateLabel("", $x + 10, $y + 18, 60, 15, $SS_RIGHT)
		   GUICtrlSetState(-1, $GUI_HIDE)
	   $g_hPicResultElixirNow = GUICtrlCreateIcon ($g_sLibIconPath, $eIcnElixir, $x + 71, $y + 16, 16, 16)
		   GUICtrlSetState(-1, $GUI_HIDE)
	   $g_hPicBBResultElixirNow = GUICtrlCreateIcon ($g_sLibIconPath, $eIcnElixir, $x + 71, $y + 16, 16, 16)
		   GUICtrlSetState(-1, $GUI_HIDE)
	   $g_hPicResultElixirTemp = GUICtrlCreateIcon ($g_sLibIconPath, $eIcnElixir, $x + 15, $y + 16, 16, 16)

	   $g_hLblResultDENow = GUICtrlCreateLabel("", $x + 10, $y + 38, 60, 15, $SS_RIGHT)
	   $g_hLblResultDEHourNow = GUICtrlCreateLabel("", $x + 10, $y + 38, 60, 15, $SS_RIGHT)
		   GUICtrlSetState(-1, $GUI_HIDE)
	   $g_hPicResultDENow = GUICtrlCreateIcon ($g_sLibIconPath, $eIcnDark, $x + 71, $y + 36, 16, 16)
		   GUICtrlSetState(-1, $GUI_HIDE)
	   $g_hPicResultDETemp = GUICtrlCreateIcon ($g_sLibIconPath, $eIcnDark, $x + 71, $y + 36, 16, 16)
		   GUICtrlSetState(-1, $GUI_HIDE)
	   $x += 75

	   ;trophy / runtime
	   $g_hLblResultTrophyNow = GUICtrlCreateLabel("", $x + 13, $y - 2, 43, 15, $SS_RIGHT)
	   $g_hPicResultTrophyNow = GUICtrlCreateIcon ($g_sLibIconPath, $eIcnTrophy, $x + 59, $y - 4, 16, 16)
	   $g_hLblBBResultTrophyNow = GUICtrlCreateLabel("", $x + 13, $y - 2, 43, 15, $SS_RIGHT)
	   GUICtrlSetState(-1, $GUI_HIDE)
	   $g_hPicBBResultTrophyNow = GUICtrlCreateIcon ($g_sLibIconPath, $eIcnTrophy, $x + 59, $y - 4, 16, 16)
	   GUICtrlSetState(-1, $GUI_HIDE)
	   $g_hLblResultRuntimeNow = GUICtrlCreateLabel("00:00:00", $x + 13, $y - 2, 43, 15, $SS_RIGHT)
	   GUICtrlSetState(-1, $GUI_HIDE)
	   $g_hPicResultRuntimeNow = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnHourGlass, $x +57, $y - 4, 16, 16)
	   GUICtrlSetState(-1, $GUI_HIDE)

	   ;builders/attacked
	   $g_hLblResultBuilderNow = GUICtrlCreateLabel("", $x + 13, $y + 18, 43, 15, $SS_RIGHT)
	   $g_hPicResultBuilderNow = GUICtrlCreateIcon ($g_sLibIconPath, $eIcnBuilder, $x + 59, $y + 16, 16, 16)
	   $g_hLblBBResultBuilderNow = GUICtrlCreateLabel("", $x + 13, $y + 18, 43, 15, $SS_RIGHT)
		   GUICtrlSetState(-1, $GUI_HIDE)
	   $g_hPicBBResultBuilderNow = GUICtrlCreateIcon ($g_sLibIconPath, $eIcnBuilder, $x + 59, $y + 16, 16, 16)
		   GUICtrlSetState(-1, $GUI_HIDE)
	   $g_hLblResultAttackedHourNow = GUICtrlCreateLabel("0", $x + 13, $y + 18, 43, 15, $SS_RIGHT)
	   GUICtrlSetState(-1, $GUI_HIDE)
	   $g_hPicResultAttackedHourNow = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnBldgTarget, $x +59, $y + 16, 16, 16)
	   GUICtrlSetState(-1, $GUI_HIDE)

	   ;gems/skipped
	   $g_hLblResultGemNow = GUICtrlCreateLabel("", $x + 13, $y + 38, 43, 15, $SS_RIGHT)
	   $g_hPicResultGemNow = GUICtrlCreateIcon ($g_sLibIconPath, $eIcnGem, $x + 59, $y + 36, 16, 16)
	   $g_hLblResultSkippedHourNow = GUICtrlCreateLabel("0", $x + 13, $y + 38, 43, 15, $SS_RIGHT)
	   GUICtrlSetState(-1, $GUI_HIDE)
	   $g_hPicResultSkippedHourNow = GUICtrlCreateIcon ($g_sLibIconPath, $eIcnBldgX, $x + 59, $y + 36, 16, 16)
	   GUICtrlSetState(-1, $GUI_HIDE)

	$x = 335
		$g_hLblVillageReportTemp = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Bottom", "LblVillageReportTemp_01", "Village Report") & @CRLF & GetTranslatedFileIni("MBR GUI Design Bottom", "LblVillageReportTemp_02", "will appear here") & @CRLF & GetTranslatedFileIni("MBR GUI Design Bottom", "LblVillageReportTemp_03", "on first run."), $x , $y + 5, 80, 45, BITOR($SS_CENTER, $BS_MULTILINE))

	GUICtrlCreateGroup("", -99, -99, 1, 1)

EndFunc   ;==>CreateBottomPanel
