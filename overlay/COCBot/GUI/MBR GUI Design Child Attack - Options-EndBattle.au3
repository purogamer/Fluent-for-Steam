; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file creates the "End Battle" tab under the "Options" tab under the "Search & Attack" tab under the "Attack Plan" tab
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

Global $g_hChkShareAttack = 0, $g_hLblShareMinLoot = 0, $g_hTxtShareMinGold = 0, $g_hTxtShareMinElixir = 0, $g_hTxtShareMinDark = 0, $g_hTxtShareMessage = 0, _
	   $g_hChkTakeLootSS = 0, $g_hChkScreenshotLootInfo = 0

Global $g_hLblShareMinGold = 0, $g_hLblShareMinElixir = 0,  $g_hLblShareMinDark = 0

Func CreateAttackSearchOptionsEndBattle()

	Local $x = 20, $y = 45
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-EndBattle", "Group_01", "Share Replay"), $x - 15, $y - 20, $g_iSizeWGrpTab4, 204)
		$g_hChkShareAttack = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-EndBattle", "ChkShareAttack", "Share Replays in your clan's chat."), $x, $y - 7, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Options-EndBattle", "ChkShareAttack_Info_01", "Check this to share your battle replay in the clan chat."))
			GUICtrlSetOnEvent(-1, "chkShareAttack")

	$x -= 15
	$y -= 2
	$y -=5
	$y += 25
		$g_hLblShareMinLoot = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-EndBattle", "LblShareMinLoot", "When Loot Gained") & ":", $x + 20, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_hLblShareMinGold = GUICtrlCreateLabel(">", $x + 112, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_hTxtShareMinGold = _GUICtrlCreateInput("300000", $x + 120, $y - 2, 61, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Options-EndBattle", "TxtShareMinGold_Info_01", "Only Share Replay when the battle loot is more than this amount of Gold."))
            GUICtrlSetLimit(-1, 7) ;HArchH Allow 7 numeric digits
			GUICtrlSetState(-1, $GUI_DISABLE)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnGold, $x + 182, $y, 16, 16)

	$y += 22
		$g_hLblShareMinElixir = GUICtrlCreateLabel(">", $x + 112, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_hTxtShareMinElixir = _GUICtrlCreateInput("300000", $x + 120, $y - 2, 61, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Options-EndBattle", "TxtShareMinElixir_Info_01", "Only Share Replay when the battle loot is more than this amount of Elixir."))
			GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetLimit(-1, 7) ;HArchH Allow 7 numeric digits
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnElixir, $x + 182, $y, 16, 16)

	$y += 22
		$g_hLblShareMinDark = GUICtrlCreateLabel(">", $x + 112, $y, -1, -1)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_hTxtShareMinDark = _GUICtrlCreateInput("0", $x + 120, $y - 2, 61, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Options-EndBattle", "TxtShareMinDark_Info_01", "Only Share Replay when the battle loot is more than this amount of Dark Elixir."))
			GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetLimit(-1, 5)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDark, $x + 182, $y, 16, 16)

	$y += 25
	$x += 5
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-EndBattle", "LblRandomMessage", "Use a random message from this list") & ":", $x, $y - 2, -1, -1)
			GUICtrlSetState(-1, $GUI_DISABLE)

	$y += 27
		$g_hTxtShareMessage = GUICtrlCreateEdit("", $x, $y - 10, 205, 72, BitOR($ES_WANTRETURN, $ES_CENTER, $ES_AUTOVSCROLL))
			GUICtrlSetData(-1, StringFormat(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-EndBattle", "ListShareMessage_Item_01", "Nice\r\nGood\r\nThanks \r\nWowwww")))
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Options-EndBattle", "ListShareMessage_Info_01", "Message to send with the Share Replay"))
			GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = 20
	$y += 95
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-EndBattle", "Group_02", "Take Loot Snapshot"), $x - 15, $y - 20, $g_iSizeWGrpTab4, 67)
		$g_hChkTakeLootSS = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-EndBattle", "Group_02", -1), $x, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Options-EndBattle", "ChkTakeLootSS_Info_01", "Check this if you want to save a Loot snapshot of the Village that was attacked."))
			GUICtrlSetState(-1, $GUI_UNCHECKED)
			GUICtrlSetOnEvent(-1, "chkTakeLootSS")

	$y += 18
		$g_hChkScreenshotLootInfo = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-EndBattle", "ChkScreenshotLootInfo", "Include loot info in filename"), $x, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Options-EndBattle", "ChkScreenshotLootInfo_Info_01", "Include loot info in the screenshot filename"))
			GUICtrlSetState(-1,$GUI_DISABLE)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	
	$x = 20
	$y += 50
	#Region - Legend trophy protection - Team AIO Mod++
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-EndBattle", "Group_03", "Legends league attack"), $x - 15, $y - 20, 200, 67)
		$g_hChkProtectInLL = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-EndBattle", "ChkProtectInLL", "Legend league protection"), $x, $y, -1, -1)
            _GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Attack", "ChkProtectInLL_Info_01", "This option adds protections in case of legend league, such as not returning if the attack is not completed."))
            GUICtrlSetState(-1, $GUI_CHECKED)
            GUICtrlSetOnEvent(-1, "ChkProtectInLL")

	$y += 18
		$g_hChkForceProtectLL = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-EndBattle", "ChkForceProtectLL", "Force trophies raise"), $x, $y, -1, -1)
            _GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Attack", "ChkForceProtectLL_Info_02", "This option will disable certain things to make the bot more efficient when collecting trophies."))
            GUICtrlSetState(-1, $GUI_DISABLE)
            GUICtrlSetOnEvent(-1, "ChkProtectInLL")
	GUICtrlCreateGroup("", -99, -99, 1, 1)
    #EndRegion - Legend trophy protection - Team AIO Mod++
	
	; Colorful Attack Log - Team AIO Mod++
	$y -= 18
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Options", "Group_04", "Attack Log"), $x - 15 + 211, $y - 20, 211, 67)
		$g_hChkColorfulAttackLog = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Options", "ChkColorfulAttackLog", "Colorful Attack Log"), $x + 211, $y, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Troops_Options", "ChkColorfulAttackLog_Info_01", "When you select this option, the avatar will be displayed in color. Each color indicates a star"))
			GUICtrlSetState(-1, $GUI_CHECKED)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

EndFunc   ;==>CreateAttackSearchOptionsEndBattle
