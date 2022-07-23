; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file creates the "Trophy Settings" tab under the "Options" tab under the "Search & Attack" tab under the "Attack Plan" tab
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

Global $g_hChkTrophyRange = 0, $g_hTxtDropTrophy = 0, $g_hTxtMaxTrophy = 0, $g_hChkTrophyHeroes = 0, $g_hCmbTrophyHeroesPriority = 0, _
	   $g_hChkTrophyAtkDead = 0, $g_hTxtDropTrophyArmyMin = 0
Global $g_hPicMinTrophies[$eLeagueCount] = [0,0,0,0,0,0,0,0,0], $g_hLblMinTrophies = 0
Global $g_hPicMaxTrophies[$eLeagueCount] = [0,0,0,0,0,0,0,0,0], $g_hLblMaxTrophies = 0

Global $g_hLblTrophyHeroesPriority = 0, $g_hLblDropTrophyArmyMin = 0, $g_hLblDropTrophyArmyPercent = 0

Func CreateAttackSearchOptionsTrophySettings()

	Local $sTxtTip = ""
	Local $x = 25, $y = 45
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-TrophySettings", "Group_01", "Trophy Settings"), $x - 20, $y - 20, $g_iSizeWGrpTab4, $g_iSizeHGrpTab4)
	$x += 25
	$y += 25
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnTrophy, $x - 15, $y, 64, 64, $BS_ICON)

	$x += 50
		$g_hChkTrophyRange = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-TrophySettings", "ChkTrophyRange", "Trophy range") & ":", $x + 20, $y, -1, -1)
			GUICtrlSetOnEvent(-1, "chkTrophyRange")
		$g_hTxtDropTrophy = _GUICtrlCreateInput("5000", $x + 110, $y, 35, -1, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetLimit(-1, 4)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Options-TrophySettings", "TxtDropTrophy_Info_01", "MIN: The Bot will drop trophies until below this value."))
			GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetOnEvent(-1, "TxtDropTrophy")

		$g_hPicMinTrophies[$eLeagueUnranked] = _GUICtrlCreateIcon($g_sLibIconPath, $eUnranked, $x + 116, $y - 30, 24, 24)
			GUICtrlSetState(-1,$GUI_SHOW)
		$g_hPicMinTrophies[$eLeagueBronze] = _GUICtrlCreateIcon($g_sLibIconPath, $eBronze, $x + 116, $y - 30, 24, 24)
			GUICtrlSetState(-1,$GUI_HIDE)
		$g_hPicMinTrophies[$eLeagueSilver] = _GUICtrlCreateIcon($g_sLibIconPath, $eSilver, $x + 116, $y - 30, 24, 24)
			GUICtrlSetState(-1,$GUI_HIDE)
		$g_hPicMinTrophies[$eLeagueGold] = _GUICtrlCreateIcon($g_sLibIconPath, $eGold, $x + 116, $y - 30, 24, 24)
			GUICtrlSetState(-1,$GUI_HIDE)
		$g_hPicMinTrophies[$eLeagueCrystal] = _GUICtrlCreateIcon($g_sLibIconPath, $eCrystal, $x + 116, $y - 30, 24, 24)
			GUICtrlSetState(-1,$GUI_HIDE)
		$g_hPicMinTrophies[$eLeagueMaster] = _GUICtrlCreateIcon($g_sLibIconPath, $eMaster, $x + 116, $y - 30, 24, 24)
			GUICtrlSetState(-1,$GUI_HIDE)
		$g_hPicMinTrophies[$eLeagueChampion] = _GUICtrlCreateIcon($g_sLibIconPath, $eLChampion, $x + 116, $y - 30, 24, 24)
			GUICtrlSetState(-1,$GUI_HIDE)
		$g_hPicMinTrophies[$eLeagueTitan] = _GUICtrlCreateIcon($g_sLibIconPath, $eTitan, $x + 116, $y - 30, 24, 24)
			GUICtrlSetState(-1,$GUI_HIDE)
		$g_hPicMinTrophies[$eLeagueLegend] = _GUICtrlCreateIcon($g_sLibIconPath, $eLegend, $x + 116, $y - 30, 24, 24)
			GUICtrlSetState(-1,$GUI_HIDE)
		$g_hLblMinTrophies = GUICtrlCreateLabel("", $x + 133, $y - 15, 17, 17, $SS_CENTER)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)

		GUICtrlCreateLabel("-", $x + 148, $y + 4, -1, -1)
		$g_hTxtMaxTrophy = _GUICtrlCreateInput("5000", $x + 155, $y, 35, -1, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			GUICtrlSetLimit(-1, 4)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Options-TrophySettings", "TxtMaxTrophy_Info_01", "MAX: The Bot will drop trophies if your trophy count is greater than this value."))
			GuiCtrlSetState(-1,$GUI_DISABLE)
			GUICtrlSetOnEvent(-1, "TxtMaxTrophy")

		$g_hPicMaxTrophies[$eLeagueUnranked] = _GUICtrlCreateIcon($g_sLibIconPath, $eUnranked, $x + 161, $y - 30, 24, 24)
			GUICtrlSetState(-1,$GUI_SHOW)
		$g_hPicMaxTrophies[$eLeagueBronze] = _GUICtrlCreateIcon($g_sLibIconPath, $eBronze, $x + 161, $y - 30, 24, 24)
			GUICtrlSetState(-1,$GUI_HIDE)
		$g_hPicMaxTrophies[$eLeagueSilver] = _GUICtrlCreateIcon($g_sLibIconPath, $eSilver, $x + 161, $y - 30, 24, 24)
			GUICtrlSetState(-1,$GUI_HIDE)
		$g_hPicMaxTrophies[$eLeagueGold] = _GUICtrlCreateIcon($g_sLibIconPath, $eGold, $x + 161, $y - 30, 24, 24)
			GUICtrlSetState(-1,$GUI_HIDE)
		$g_hPicMaxTrophies[$eLeagueCrystal] = _GUICtrlCreateIcon($g_sLibIconPath, $eCrystal, $x + 161, $y - 30, 24, 24)
			GUICtrlSetState(-1,$GUI_HIDE)
		$g_hPicMaxTrophies[$eLeagueMaster] = _GUICtrlCreateIcon($g_sLibIconPath, $eMaster, $x + 161, $y - 30, 24, 24)
			GUICtrlSetState(-1,$GUI_HIDE)
		$g_hPicMaxTrophies[$eLeagueChampion] = _GUICtrlCreateIcon($g_sLibIconPath, $eLChampion, $x + 161, $y - 30, 24, 24)
			GUICtrlSetState(-1,$GUI_HIDE)
		$g_hPicMaxTrophies[$eLeagueTitan] = _GUICtrlCreateIcon($g_sLibIconPath, $eTitan, $x + 161, $y - 30, 24, 24)
			GUICtrlSetState(-1,$GUI_HIDE)
		$g_hPicMaxTrophies[$eLeagueLegend] = _GUICtrlCreateIcon($g_sLibIconPath, $eLegend, $x + 161, $y - 30, 24, 24)
			GUICtrlSetState(-1,$GUI_HIDE)
		$g_hLblMaxTrophies = GUICtrlCreateLabel("", $x + 178, $y - 15, 17, 17, $SS_CENTER)
		GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
		GUICtrlSetColor(-1, $COLOR_BLACK)

	$y += 24
	$x += 20
        #Region - Drop Throphy - Team AIO Mod++
		$g_hChkTrophyHeroes = GUICtrlCreateRadio(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-TrophySettings", "ChkTrophyHeroes_0", "Use heroes."), $x, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Options-TrophySettings", "ChkTrophyHeroes_Info_01", "Use Heroes to drop Trophies if Heroes are available."))
			;GUICtrlSetState(-1,$GUI_DISABLE)
			GUICtrlSetOnEvent(-1, "chkTrophyHeroes")
		$g_hChkTrophyTroops = GUICtrlCreateRadio(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-TrophySettings", "ChkTrophyHeroes_1", "Use troops."), $x + 75, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Options-TrophySettings", "ChkTrophyHeroes_Info_02", "Use Troops to drop Trophies if troops are available."))
			;GUICtrlSetState(-1,$GUI_DISABLE)
			GUICtrlSetOnEvent(-1, "chkTrophyHeroes")
		$g_hChkTrophyHeroesAndTroops = GUICtrlCreateRadio(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-TrophySettings", "ChkTrophyHeroes_2", "Use heroes and troops."), $x + 75 + 75, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Options-TrophySettings", "ChkTrophyHeroes_Info_03", "Use Heroes and troops to drop Trophies if are available."))
			;GUICtrlSetState(-1,$GUI_DISABLE)
			GUICtrlSetOnEvent(-1, "chkTrophyHeroes")
        #EndRegion - Drop Throphy - Team AIO Mod++
	$y += 25
		$g_hLblTrophyHeroesPriority = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-TrophySettings", "LblTrophyHeroesPriority", "Priority Hero to Use") & ":", $x + 16, $y, 110, -1)
		$g_hCmbTrophyHeroesPriority = GUICtrlCreateCombo("", $x + 125, $y - 4 , 170, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Options-TrophySettings", "LblTrophyHeroesPriority_Info_01", "Set the order on which Hero the Bot drops first when available."))
			Local $txtPriorityConnector = ">"
			Local $txtPriorityDefault = GetTranslatedFileIni("MBR Global GUI Design Names Troops", "Queen", -1) & $txtPriorityConnector & _
										GetTranslatedFileIni("MBR Global GUI Design Names Troops", "King", -1) & $txtPriorityConnector & _
										GetTranslatedFileIni("MBR Global GUI Design Names Troops", "Warden", -1) & $txtPriorityConnector & _
										GetTranslatedFileIni("MBR Global GUI Design Names Troops", "Champion", -1) ; default value Queen, King, G.Warden, Royal Champion
			Local $txtPriorityList = "" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "Queen", -1) & $txtPriorityConnector & GetTranslatedFileIni("MBR Global GUI Design Names Troops", "King", -1) & $txtPriorityConnector & GetTranslatedFileIni("MBR Global GUI Design Names Troops", "Warden", -1) & $txtPriorityConnector & GetTranslatedFileIni("MBR Global GUI Design Names Troops", "Champion", -1) & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "Queen", -1) & $txtPriorityConnector & GetTranslatedFileIni("MBR Global GUI Design Names Troops", "Warden", -1) & $txtPriorityConnector & GetTranslatedFileIni("MBR Global GUI Design Names Troops", "King", -1) & $txtPriorityConnector & GetTranslatedFileIni("MBR Global GUI Design Names Troops", "Champion", -1) & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "King", -1) & $txtPriorityConnector & GetTranslatedFileIni("MBR Global GUI Design Names Troops", "Queen", -1) & $txtPriorityConnector & GetTranslatedFileIni("MBR Global GUI Design Names Troops", "Warden", -1) & $txtPriorityConnector & GetTranslatedFileIni("MBR Global GUI Design Names Troops", "Champion", -1) & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "King", -1) & $txtPriorityConnector & GetTranslatedFileIni("MBR Global GUI Design Names Troops", "Warden", -1) & $txtPriorityConnector & GetTranslatedFileIni("MBR Global GUI Design Names Troops", "Queen", -1) & $txtPriorityConnector & GetTranslatedFileIni("MBR Global GUI Design Names Troops", "Champion", -1) & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "Warden", -1) & $txtPriorityConnector & GetTranslatedFileIni("MBR Global GUI Design Names Troops", "King", -1) & $txtPriorityConnector & GetTranslatedFileIni("MBR Global GUI Design Names Troops", "Queen", -1) & $txtPriorityConnector & GetTranslatedFileIni("MBR Global GUI Design Names Troops", "Champion", -1) & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "Warden", -1) & $txtPriorityConnector & GetTranslatedFileIni("MBR Global GUI Design Names Troops", "Queen", -1) & $txtPriorityConnector & GetTranslatedFileIni("MBR Global GUI Design Names Troops", "King", -1) & $txtPriorityConnector & GetTranslatedFileIni("MBR Global GUI Design Names Troops", "Champion", -1) & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "Champion", -1) & $txtPriorityConnector & GetTranslatedFileIni("MBR Global GUI Design Names Troops", "Warden", -1) & $txtPriorityConnector & GetTranslatedFileIni("MBR Global GUI Design Names Troops", "Queen", -1) & $txtPriorityConnector & GetTranslatedFileIni("MBR Global GUI Design Names Troops", "King", -1) & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "Champion", -1) & $txtPriorityConnector & GetTranslatedFileIni("MBR Global GUI Design Names Troops", "Queen", -1) & $txtPriorityConnector & GetTranslatedFileIni("MBR Global GUI Design Names Troops", "Warden", -1) & $txtPriorityConnector & GetTranslatedFileIni("MBR Global GUI Design Names Troops", "King", -1) & "|" & _
			""

			SetDebugLog($txtPriorityDefault)
			SetDebugLog($txtPriorityList)
			GUICtrlSetData(-1, $txtPriorityList , $txtPriorityDefault)
			GUICtrlSetState(-1, $GUI_DISABLE)

	$y += 20
		$g_hChkTrophyAtkDead = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-TrophySettings", "ChkTrophyAtkDead", "Attack Dead Bases During Drop"), $x, $y + 2, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Options-TrophySettings", "ChkTrophyAtkDead_Info_01", "Attack a Deadbase found on the first search while dropping Trophies."))
			GUICtrlSetOnEvent(-1, "chkTrophyAtkDead")
			GUICtrlSetState(-1,$GUI_DISABLE)

	$y += 24
		$g_hLblDropTrophyArmyMin = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-TrophySettings", "LblDropTrophyArmyMin", "Wait until Army Camp are at least") & " " & ChrW(8805), $x + 16, $y + 6, 200, -1, $SS_LEFT)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Options-TrophySettings", "LblDropTrophyArmyMin_Info_01", "Enter the percent of full army required for dead base attack before starting trophy drop.")
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hTxtDropTrophyArmyMin = _GUICtrlCreateInput("70", $x + 215, $y + 2, 27, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetLimit(-1, 2)
			GUICtrlSetState (-1, $GUI_DISABLE)
		$g_hLblDropTrophyArmyPercent = GUICtrlCreateLabel("%", $x + 245, $y + 6, -1, -1)
	#Region - Drop trophy - Team AiO MOD++
	$y += 25
		$g_hChkNoDropIfShield = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-TrophySettings", "ChkNoDropIfShield", "Drop trophies only if the shield is not available."), $x, $y, -1, -1)
			GUICtrlSetOnEvent(-1, "chkNoDropIfShield")
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Options-TrophySettings", "ChkNoDropIfShield_Info_02", "Drop trophies only if the shield is not available."))
	#EndRegion - Drop trophy - Team AiO MOD++
	GUICtrlCreateGroup("", -99, -99, 1, 1)

EndFunc   ;==>CreateAttackSearchOptionsTrophySettings
