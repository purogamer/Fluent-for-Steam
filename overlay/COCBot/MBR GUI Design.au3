; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file Includes GUI Design
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: GKevinOD (2014)
; Modified ......: DkEd, Hervidero (2015), CodeSlinger69 (01-2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#Tidy_On
#include-once

#include "Functions\Other\AppUserModelId.au3"
#include "Functions\Other\ITaskBarList.au3"
#include "Functions\GUI\_GUICtrlSetTip.au3"
#include "functions\GUI\_GUICtrlCreatePic.au3"
#include "functions\GUI\GUI_State.au3"

Global Const $TCM_SETITEM = 0x1306
Global Const $iFixResolution = 71
Global $_GUI_MAIN_WIDTH = 472 ; changed from 470 to 472 for DPI scaling cutting off right by 2 pixel
Global $_GUI_MAIN_HEIGHT = 692 - $iFixResolution ; changed from 690 to 692 for DPI scaling cutting off bottom by 2 pixel
Global Const $_NORMALGUI_MAIN_WIDTH = $_GUI_MAIN_WIDTH ; changed from 470 to 472 for DPI scaling cutting off right by 2 pixel
Global Const $_NORMALGUI_MAIN_HEIGHT = $_GUI_MAIN_HEIGHT ; changed from 690 to 692 for DPI scaling cutting off bottom by 2 pixel
Global Const $_MINIGUI_MAIN_WIDTH = $_GUI_MAIN_WIDTH ; changed from 470 to 472 for DPI scaling cutting off right by 2 pixel
Global Const $_MINIGUI_MAIN_HEIGHT = 220 ; changed from 690 to 692 for DPI scaling cutting off bottom by 2 pixel
Global $_GUI_MAIN_TOP = 23 ; Adjusted in CreateMainGUI()
Global $_GUI_MAIN_BUTTON_SIZE = [25, 17] ; minimize/close button size
Global $_GUI_MAIN_BUTTON_COUNT = 4
Global $_GUI_CHILD_TOP = 78 + $_GUI_MAIN_TOP ; Adjusted in CreateMainGUI()
Global Const $_GUI_BOTTOM_HEIGHT = 170 - $iFixResolution
Global Const $_GUI_CHILD_LEFT = 10
Global Const $g_bBtnColor = False ; True

Global Const $g_iSizeWGrpTab1 = $_GUI_MAIN_WIDTH - 20
Global Const $g_iSizeHGrpTab1 = $_GUI_MAIN_HEIGHT - 255 + $iFixResolution
Global Const $g_iSizeWGrpTab2 = $_GUI_MAIN_WIDTH - 30 ;440
Global Const $g_iSizeHGrpTab2 = $_GUI_MAIN_HEIGHT - 285 + $iFixResolution ;405
Global Const $g_iSizeWGrpTab3 = $_GUI_MAIN_WIDTH - 40 ;430
Global Const $g_iSizeHGrpTab3 = $_GUI_MAIN_HEIGHT - 315 + $iFixResolution ;375
Global Const $g_iSizeWGrpTab4 = $_GUI_MAIN_WIDTH - 50 ;420
Global Const $g_iSizeHGrpTab4 = $_GUI_MAIN_HEIGHT - 345 + $iFixResolution ;345

Global $g_iBotDesignFlags = 3 ; Bit 0 = Use Windows Default Title Bar, 1 = Use new custom Title Bar, 2 = Auto Slide bot when docked and window activation changes, 4, 8, ... future features
Global $g_bCustomTitleBarActive = Default ; Current state if custom title bar has been designed, set to True or False in CreateMainGUI()
Global $g_bBotDockedShrinked = False ; Bot is shrinked or not when docked
Global $g_hFrmBotButtons, $g_hFrmBotLogoUrlSmall, $g_hFrmBotEx = 0, $g_hLblBotTitle, $g_hLblBotShrink = 0, $g_hLblBotExpand = 0, $g_hLblBotMiniGUI = 0, $g_hLblBotNormalGUI = 0 _
		, $g_hLblBotMinimize = 0, $g_hLblBotClose = 0, $g_hFrmBotBottom = 0, $g_hFrmBotEmbeddedShield = 0, $g_hFrmBotEmbeddedShieldInput = 0, $g_hFrmBotEmbeddedGraphics = 0
Global $g_hFrmBot_MAIN_PIC = 0, $g_hFrmBot_URL_PIC = 0, $g_hFrmBot_URL_PIC2 = 0
Global $g_hTabMain = 0, $g_hTabLog = 0, $g_hTabVillage = 0, $g_hTabAttack = 0, $g_hTabBot = 0, $g_hTabAbout = 0
Global $g_hTabBuilderBase = 0, $g_hTabMOD = 0 ; Team AIO Mod++
Global $g_hStatusBar = 0

Global $g_hTiShow = 0, $g_hTiHide = 0, $g_hTiDonate = 0, $g_hTiAbout = 0, $g_hTiStartStop = 0, $g_hTiPause = 0, $g_hTiExit = 0
Global $g_aFrmBotPosInit[8] = [0, 0, 0, 0, 0, 0, 0, 0]
Global $g_hFirstControlToHide = 0, $g_hLastControlToHide = 0, $g_aiControlPrevState[1]
Global $g_bFrmBotMinimized = False ; prevents bot flickering
Global $g_hTblStart = 0, $g_hTblStop = 0, $g_hTblPause = 0, $g_hTblResume = 0, $g_hTblMakeScreenshot = 0 ; TaskBarList buttons

Global $g_oCtrlIconData = ObjCreate("Scripting.Dictionary")
Global $g_oGuiNotInMini = ObjCreate("Scripting.Dictionary")

#include "GUI\MBR GUI Design Bottom.au3"
#include "GUI\MBR GUI Design Log.au3"
#include "GUI\MBR GUI Design Village.au3"
#include "GUI\MBR GUI Design Attack.au3"
#include "GUI\MBR GUI Design Bot.au3"
#include "GUI\MBR GUI Design About.au3"
#Region - Team AiO MOD++ (2020)
#include "Team__AiO__MOD++\GUI\MOD GUI Design - Builder Base.au3"
#include "Team__AiO__MOD++\GUI\MOD GUI Design.au3"
#EndRegion - Team AiO MOD++ (2020)

Func CreateMainGUI()

;~ ------------------------------------------------------
;~ Main GUI
;~ ------------------------------------------------------
	Local $iStyle = $WS_BORDER
	If BitAND($g_iBotDesignFlags, 1) = 0 Then
		; Window default title bar
		$g_bCustomTitleBarActive = False
		$iStyle = $WS_CAPTION
		; adjust some hights
		$_GUI_MAIN_TOP = 5
		$_GUI_CHILD_TOP = 110 + $_GUI_MAIN_TOP
	Else
		$g_bCustomTitleBarActive = True
	EndIf
	Switch $g_iGuiMode
		Case 0
			; GUI less mode
			;Opt("TrayIconHide", 1)
		Case 2
			; mini GUI mode
			$_GUI_MAIN_WIDTH = $_MINIGUI_MAIN_WIDTH
			$_GUI_MAIN_HEIGHT = $_MINIGUI_MAIN_HEIGHT
	EndSwitch

	$g_hFrmBot = GUICreate($g_sBotTitle, $_GUI_MAIN_WIDTH, $_GUI_MAIN_HEIGHT + $_GUI_MAIN_TOP, ($g_iFrmBotPosX = $g_WIN_POS_DEFAULT ? -1 : $g_iFrmBotPosX), ($g_iFrmBotPosY = $g_WIN_POS_DEFAULT ? -1 : $g_iFrmBotPosY), _
			BitOR($WS_MINIMIZEBOX, $WS_POPUP, $WS_SYSMENU, $WS_CLIPCHILDREN, $WS_CLIPSIBLINGS, $iStyle))

	; see https://github.com/Microsoft/Windows-classic-samples/blob/master/Samples/Win7Samples/winui/shell/appshellintegration/TaskbarThumbnailToolbar/ThumbnailToolbar.cpp
	_WinAPI_ChangeWindowMessageFilterEx($g_hFrmBot, $g_WM_TaskbarButtonCreated, $MSGFLT_ALLOW)
	_WinAPI_ChangeWindowMessageFilterEx($g_hFrmBot, $WM_COMMAND, $MSGFLT_ALLOW)

	; update $g_iFrmBotPosX and $g_iFrmBotPosY for default position
	If $g_iFrmBotPosX = $g_WIN_POS_DEFAULT Or $g_iFrmBotPosY = $g_WIN_POS_DEFAULT Then
		Local $a = WinGetPos($g_hFrmBot)
		If UBound($a) > 1 Then
			$g_iFrmBotPosX = $a[0]
			$g_iFrmBotPosY = $a[1]
		Else
			$g_iFrmBotPosX = 100
			$g_iFrmBotPosY = 100
		EndIf
	EndIf

	; Set Main Window icon
	GUISetIcon($g_sLibModIconPath, $eIcnAIOMod)
	If $g_iGuiMode = 0 Then
		UpdateBotTitle()
		Return
	EndIf

	; Create tray icon
	TraySetIcon($g_sLibModIconPath, $eIcnAIOMod)
	Opt("TrayMenuMode", 3)
	Opt("TrayOnEventMode", 1)
	Opt("TrayIconHide", 0)

	; initialize bot title
	UpdateBotTitle()

	; group multiple bot windows using _WindowAppId
	_WindowAppId($g_hFrmBot, "MyBot.run")

	; Create tray icon menu
	$g_hTiShow = TrayCreateItem(GetTranslatedFileIni("MBR GUI Design - Loading", "StatusBar_Item_01", "Show bot"))
	TrayItemSetOnEvent(-1, "tiShow")
	$g_hTiStartStop = TrayCreateItem(GetTranslatedFileIni("MBR GUI Design - Loading", "StatusBar_Item_Start", "Start bot"))
	GetTranslatedFileIni("MBR GUI Design - Loading", "StatusBar_Item_Stop", "Stop bot") ; gets renamed also to Stop bot
	TrayItemSetOnEvent(-1, "tiStartStop")
	$g_hTiPause = TrayCreateItem(GetTranslatedFileIni("MBR GUI Design - Loading", "StatusBar_Item_Pause", "Pause bot"))
	GetTranslatedFileIni("MBR GUI Design - Loading", "StatusBar_Item_Resume", "Resume bot") ; gets renamed also to Resume bot
	TrayItemSetState($g_hTiPause, $TRAY_DISABLE)
	TrayItemSetOnEvent(-1, "btnPause")
	TrayCreateItem("")
	$g_hTiHide = TrayCreateItem(GetTranslatedFileIni("MBR GUI Design - Loading", "StatusBar_Item_02", "Hide when minimized"))
	TrayItemSetOnEvent(-1, "tiHide")
	TrayCreateItem("")
	$g_hTiDonate = TrayCreateItem(GetTranslatedFileIni("MBR GUI Design - Loading", "StatusBar_Item_03", "Support Development"))
	TrayItemSetOnEvent(-1, "tiDonate")
	$g_hTiAbout = TrayCreateItem(GetTranslatedFileIni("MBR GUI Design - Loading", "StatusBar_Item_04", "About"))
	TrayItemSetOnEvent(-1, "tiAbout")
	TrayCreateItem("")
	$g_hTiExit = TrayCreateItem(GetTranslatedFileIni("MBR GUI Design - Loading", "StatusBar_Item_05", "Exit"))
	TrayItemSetOnEvent(-1, "tiExit")

EndFunc   ;==>CreateMainGUI

Func CreateMainGUIControls($bGuiModeUpdate = False)

	If Not $bGuiModeUpdate Then

		Local $aBtnSize = $_GUI_MAIN_BUTTON_SIZE
		GUISwitch($g_hFrmBot)

		Local $sStepText
		Switch $g_iGuiMode
			Case 0
				Return
			Case 1
				$sStepText = GetTranslatedFileIni("MBR GUI Design - Loading", "SplashStep_01", "Loading Main GUI...")
			Case 2
				$sStepText = GetTranslatedFileIni("MBR GUI Design - Loading", "SplashStep_01_Mini", "Loading Mini GUI...")
				;$_GUI_MAIN_BUTTON_COUNT = 3
		EndSwitch

		SplashStep($sStepText)

		If $g_bCustomTitleBarActive Then
			$g_hFrmBotButtons = GUICreate("My Bot Title Buttons", $_GUI_MAIN_BUTTON_COUNT * $aBtnSize[0], $aBtnSize[1], $_GUI_MAIN_WIDTH - $aBtnSize[0] * $_GUI_MAIN_BUTTON_COUNT, 0, BitOR($WS_CHILD, $WS_TABSTOP), BitOR($WS_EX_TOOLWINDOW, $WS_EX_NOACTIVATE, ($g_bAndroidShieldPreWin8 ? 0 : $WS_EX_LAYERED)), $g_hFrmBot)
			WinSetTrans($g_hFrmBotButtons, "", 254) ; trick to hide buttons from Android Screen that is not always refreshing
		EndIf
		; Need $g_hFrmBotEx for embedding Android
		$g_hFrmBotEx = GUICreate("My Bot Controls", $_GUI_MAIN_WIDTH, $_GUI_MAIN_HEIGHT - $_GUI_BOTTOM_HEIGHT + $_GUI_MAIN_TOP, 0, 0, _
				BitOR($WS_CHILD, $WS_TABSTOP), 0, $g_hFrmBot)

		$g_hToolTip = _GUIToolTip_Create($g_hFrmBot) ; tool tips for URL links etc
		_GUIToolTip_SetMaxTipWidth($g_hToolTip, $_GUI_MAIN_WIDTH) ; support multiple lines

		If $g_bCustomTitleBarActive = False Then
			; Window default title bar
			GUICtrlCreateLabel("", 0, 0, $_GUI_MAIN_WIDTH, $_GUI_MAIN_TOP)
			GUICtrlSetOnEvent(-1, "BotMoveRequest")
			GUICtrlSetBkColor(-1, $COLOR_WHITE)
		Else
			; align title bar with logo
			Local $iTitleX = 25
			GUICtrlCreateLabel("", 0, 0, $iTitleX, $_GUI_MAIN_TOP)
			GUICtrlSetOnEvent(-1, "BotMoveRequest")
			GUICtrlSetBkColor(-1, $COLOR_WHITE)
			; title
			$g_hLblBotTitle = GUICtrlCreateLabel($g_sBotTitle, $iTitleX, 0, $_GUI_MAIN_WIDTH - $_GUI_MAIN_BUTTON_COUNT * $aBtnSize[0] - 25, $_GUI_MAIN_TOP) ;, $SS_CENTER)
			GUICtrlSetOnEvent(-1, "BotMoveRequest")
			GUICtrlSetFont(-1, 11, 0, 0, "Segoe UI") ; "Verdana" "Lucida Console"
			GUICtrlSetBkColor(-1, $COLOR_WHITE)
			GUICtrlSetColor(-1, 0x171717)

			; buttons, positions are adjusted also in BotShrinkExpandToggle()
			GUISwitch($g_hFrmBotButtons)
			; ◄ ► docked shrink/expand
			$g_hLblBotShrink = GUICtrlCreateLabel(ChrW(0x25C4), 0, 0, $aBtnSize[0], $aBtnSize[1], $SS_CENTER)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Title", "LblBotShrink", "Shrink Bot when docked"))
			GUICtrlSetFont(-1, 10)
			GUICtrlSetBkColor(-1, 0xF0F0F0)
			GUICtrlSetColor(-1, 0xB8B8B8)
			$g_hLblBotExpand = GUICtrlCreateLabel(ChrW(0x25BA), 0, 0, $aBtnSize[0], $aBtnSize[1], $SS_CENTER)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Title", "LblBotExpand", "Expand Bot when docked"))
			GUICtrlSetState(-1, $GUI_HIDE)
			GUICtrlSetFont(-1, 10)
			GUICtrlSetBkColor(-1, 0xF0F0F0)
			GUICtrlSetColor(-1, 0xB8B8B8)
			; ▄ █ Mini/Normal GUI mode switch
			$g_hLblBotMiniGUI = GUICtrlCreateLabel(ChrW(0x2584), $aBtnSize[0] * ($_GUI_MAIN_BUTTON_COUNT - 3), 0, $aBtnSize[0], $aBtnSize[1], $SS_CENTER)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Title", "LblBotMiniGUI", "Switch to Mini Mode"))
			GUICtrlSetState(-1, $g_iGuiMode = 1 ? $GUI_SHOW : $GUI_HIDE)
			GUICtrlSetFont(-1, 10)
			GUICtrlSetBkColor(-1, 0xF0F0F0)
			GUICtrlSetColor(-1, 0xB8B8B8)
			$g_hLblBotNormalGUI = GUICtrlCreateLabel(ChrW(0x2588), $aBtnSize[0] * ($_GUI_MAIN_BUTTON_COUNT - 3), 0, $aBtnSize[0], $aBtnSize[1], $SS_CENTER)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Title", "LblBotNormal", "Switch to Normal Mode"))
			GUICtrlSetState(-1, $g_iGuiMode = 2 ? $GUI_SHOW : $GUI_HIDE)
			GUICtrlSetFont(-1, 10)
			GUICtrlSetBkColor(-1, 0xF0F0F0)
			GUICtrlSetColor(-1, 0xB8B8B8)
			; minimize button
			$g_hLblBotMinimize = GUICtrlCreateLabel("̶", $aBtnSize[0] * ($_GUI_MAIN_BUTTON_COUNT - 2), 0, $aBtnSize[0], $aBtnSize[1], $SS_CENTER)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Title", "LblBotMinimize", "Minimize"))
			GUICtrlSetFont(-1, 10)
			GUICtrlSetBkColor(-1, 0xF0F0F0)
			GUICtrlSetColor(-1, 0xB8B8B8)
			; close button
			$g_hLblBotClose = GUICtrlCreateLabel("×", $aBtnSize[0] * ($_GUI_MAIN_BUTTON_COUNT - 1), 0, $aBtnSize[0], $aBtnSize[1], $SS_CENTER)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Title", "LblBotClose", "Close"))
			GUICtrlSetFont(-1, 10)
			GUICtrlSetBkColor(-1, 0xFF4040)
			GUICtrlSetColor(-1, 0xF8F8F8)

			$g_hFrmBotLogoUrlSmall = GUICreate("My Bot URL", 290, 13, 0, 0, BitOR($WS_CHILD, $WS_TABSTOP), BitOR($WS_EX_TOOLWINDOW, $WS_EX_NOACTIVATE, ($g_bAndroidShieldPreWin8 ? 0 : $WS_EX_LAYERED)), $g_hFrmBot)
			;WinSetTrans($g_hFrmBotLogoUrlSmall, "", 254) ; trick to hide buttons from Android Screen that is not always refreshing
			$g_hFrmBot_URL_PIC2 = _GUICtrlCreatePic($g_sLogoUrlSmallPath, 0, 0, 290, 13)
			GUICtrlSetCursor(-1, 0)

			GUISwitch($g_hFrmBotEx)
			; fill button space
			GUICtrlCreateLabel("", $_GUI_MAIN_WIDTH - $_GUI_MAIN_BUTTON_COUNT * $aBtnSize[0], $aBtnSize[1], $_GUI_MAIN_BUTTON_COUNT * $aBtnSize[0], $_GUI_MAIN_TOP - $aBtnSize[1])
			GUICtrlSetOnEvent(-1, "BotMoveRequest")
			GUICtrlSetBkColor(-1, $COLOR_WHITE)
		EndIf

		$g_hFrmBot_MAIN_PIC = _GUICtrlCreatePic($g_sLogoPath, 0, $_GUI_MAIN_TOP, $_GUI_MAIN_WIDTH, 40)
		GUICtrlSetOnEvent(-1, "BotMoveRequest")

		$g_hLblAndroidInfo = GUICtrlCreateLabel("", $_GUI_MAIN_WIDTH - 166 + 85, $_GUI_MAIN_TOP, 160, 26, $SS_LEFT)
		GUICtrlSetFont(-1, 8.5, $FW_BOLD)
		GUICtrlSetColor(-1, 0x0E67BC)
		GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)

		$g_hFrmBot_URL_PIC = _GUICtrlCreatePic($g_sLogoUrlPath, 0, $_GUI_MAIN_TOP + 40, $_GUI_MAIN_WIDTH, 13)
		GUICtrlSetCursor(-1, 0)

		GUISwitch($g_hFrmBot)
		$g_hFrmBotEmbeddedShieldInput = _GUICtrlCreateInput("", 0, 0, -1, -1, $WS_TABSTOP)
		;$g_hFrmBotEmbeddedShieldInput = GUICtrlCreateLabel("", 0, 0, 0, 0, $WS_TABSTOP)
		;$g_hFrmBotEmbeddedShieldInput = GUICtrlCreateDummy()
		GUICtrlSetState($g_hFrmBotEmbeddedShieldInput, $GUI_HIDE)

		$g_hFrmBotBottom = GUICreate("My Bot Buttons", $_GUI_MAIN_WIDTH, $_GUI_BOTTOM_HEIGHT, 0, $_GUI_MAIN_HEIGHT - $_GUI_BOTTOM_HEIGHT + $_GUI_MAIN_TOP, _
				BitOR($WS_CHILD, $WS_TABSTOP), 0, $g_hFrmBot)

;~ ------------------------------------------------------
;~ Header Menu
;~ ------------------------------------------------------
		GUISwitch($g_hFrmBot)
		;$idMENU_DONATE = GUICtrlCreateMenu("&" & GetTranslatedFileIni("MBR GUI Design Bottom", "g_hLblDonate_Info_01", "Paypal Donate?"))
		;_GUICtrlMenu_SetItemType(_GUICtrlMenu_GetMenu($g_hFrmBot), 0, $MFT_RIGHTJUSTIFY) ; move to right
		;$idMENU_DONATE_SUPPORT = GUICtrlCreateMenuItem(GetTranslatedFileIni("MBR GUI Design Bottom", "g_hLblDonate", "Support the development"), $idMENU_DONATE)
		;GUICtrlSetOnEvent(-1, "")

;~ ------------------------------------------------------
;~ GUI Bottom Panel
;~ ------------------------------------------------------
		SplashStep(GetTranslatedFileIni("MBR GUI Design - Loading", "SplashStep_02", "Loading GUI Bottom..."))
		GUISwitch($g_hFrmBotBottom)
		CreateBottomPanel()

;~ ------------------------------------------------------
;~ GUI Child Tab Files
;~ ------------------------------------------------------
		GUISwitch($g_hFrmBotEx)

		; Bottom status bar
		$g_hStatusBar = _GUICtrlStatusBar_Create($g_hFrmBotBottom)
		_GUICtrlStatusBar_SetSimple($g_hStatusBar)
		_GUICtrlStatusBar_SetText($g_hStatusBar, "Status : Idle")

	Else

		GUISwitch($g_hFrmBotEx)

	EndIf

	If $g_iGuiMode = 2 Then
		; just create the log controls in $g_hFrmBotEx
		CreateLogTab($g_hFrmBotEx)
		Return
	EndIf

	; This dummy is used in btnStart and btnStop to disable/enable all labels, text, buttons etc. on all tabs.
	$g_hFirstControlToHide = GUICtrlCreateDummy()

	SplashStep(GetTranslatedFileIni("MBR GUI Design - Loading", "SplashStep_03", "Loading Log tab..."))
	CreateLogTab()

	SplashStep(GetTranslatedFileIni("MBR GUI Design - Loading", "SplashStep_04", "Loading Village tab..."))
	CreateVillageTab()

	SplashStep(GetTranslatedFileIni("MBR GUI Design - Loading", "SplashStep_05", "Loading Attack tab..."))
	CreateAttackTab()
	
	#Region - Team AIO Mod++
	SplashStep(GetTranslatedFileIni("MBR GUI Design - Loading", "SplashStep_11", "Loading Builder Base tab..."))
	CreateBuilderBaseTab()

	SplashStep(GetTranslatedFileIni("MBR GUI Design - Loading", "SplashStep_10", "Loading Mods tab..."))
	CreateMODTab()
	#EndRegion - Team AIO Mod++
	
	SplashStep(GetTranslatedFileIni("MBR GUI Design - Loading", "SplashStep_06", "Loading Bot tab..."))
	CreateBotTab() ; also creates  $g_hLastControlToHide
	If Not $bGuiModeUpdate Then DistributorsUpdateGUI() ; Now loading Distributors (during GUI switch it must be called outside CreateMainGUIControls()!)

	SplashStep(GetTranslatedFileIni("MBR GUI Design - Loading", "SplashStep_07", "Loading About tab..."))
	CreateAboutTab()

	Local $sStepText = ""
	Switch $g_iGuiMode
		Case 1
			$sStepText = GetTranslatedFileIni("MBR GUI Design - Loading", "SplashStep_08", "Initializing GUI...")
		Case 2
			$sStepText = GetTranslatedFileIni("MBR GUI Design - Loading", "SplashStep_08_Mini", "Initializing Mini GUI...")
	EndSwitch
	SplashStep($sStepText)

;~ ------------------------------------------------------
;~ GUI Main Tab Control
;~ ------------------------------------------------------
	GUISwitch($g_hFrmBotEx)
	; $g_hTabMain = GUICtrlCreateTab(5, 85 + $_GUI_MAIN_TOP, $_GUI_MAIN_WIDTH - 9, $_GUI_MAIN_HEIGHT - 225) ; , $TCS_MULTILINE)
	$g_hTabMain = GUICtrlCreateTab(5, 53 + $_GUI_MAIN_TOP, $_GUI_MAIN_WIDTH - 9, $_GUI_MAIN_HEIGHT - (225 - $iFixResolution))  ; Fixed resolution
	$g_hTabLog = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_01", "Log"))
	$g_hTabVillage = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_02", "Village"))
	$g_hTabAttack = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_03", "Attack Plan"))
	$g_hTabBuilderBase = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_10", "BBase"))  ; BBase - Team AIO Mod++
	$g_hTabMOD = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_06", "Mods")) ; Team AIO Mod++
	$g_hTabBot = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_04", "Bot"))
	$g_hTabAbout = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_05", "About"))
	GUICtrlCreateTabItem("")
	GUICtrlSetResizing(-1, $GUI_DOCKBORDERS)

;~ -------------------------------------------------------------
;~ GUI init
;~ -------------------------------------------------------------
	; Bind Icon images to all Tabs in all GUI windows (main and children)

	; Static to avoid GDI Handle leak
	Static $g_hTabMain_ImageList = 0
	Static $g_hGUI_VILLAGE_TAB_ImageList = 0
	Static $g_hGUI_MISC_TAB_ImageList = 0
	Static $g_hGUI_DONATE_TAB_ImageList = 0
	Static $g_hGUI_UPGRADE_TAB_ImageList = 0
	Static $g_hGUI_NOTIFY_TAB_ImageList = 0
	Static $g_hGUI_ATTACK_TAB_ImageList = 0
	Static $g_hGUI_TRAINARMY_TAB_ImageList = 0
	Static $g_hGUI_SEARCH_TAB_ImageList = 0
	Static $g_hGUI_DEADBASE_TAB_ImageList = 0
	Static $g_hGUI_ACTIVEBASE_TAB_ImageList = 0
	Static $g_hGUI_THSNIPE_TAB_ImageList = 0
	Static $g_hGUI_ATTACKOPTION_TAB_ImageList = 0
	Static $g_hGUI_STRATEGIES_TAB_ImageList = 0
	Static $g_hGUI_BOT_TAB_ImageList = 0
	Static $g_hGUI_SWITCH_OPTIONS_TAB_ImageList = 0
	Static $g_hGUI_STATS_TAB_ImageList = 0
	
	#Region - Team__AiO__MOD
	Static $g_hGUI_BUILDER_BASE_TAB_ImageList = 0
	Static $g_hGUI_MOD_TAB_ImageList = 0

	Bind_ImageList($g_hGUI_MOD_TAB, $g_hGUI_MOD_TAB_ImageList)
	Bind_ImageList($g_hGUI_BUILDER_BASE_TAB, $g_hGUI_BUILDER_BASE_TAB_ImageList)
	#EndRegion - Team__AiO__MOD
	
	Bind_ImageList($g_hTabMain, $g_hTabMain_ImageList)

	Bind_ImageList($g_hGUI_VILLAGE_TAB, $g_hGUI_VILLAGE_TAB_ImageList)
	Bind_ImageList($g_hGUI_MISC_TAB, $g_hGUI_MISC_TAB_ImageList)
	Bind_ImageList($g_hGUI_DONATE_TAB, $g_hGUI_DONATE_TAB_ImageList)
	Bind_ImageList($g_hGUI_UPGRADE_TAB, $g_hGUI_UPGRADE_TAB_ImageList)
	Bind_ImageList($g_hGUI_NOTIFY_TAB, $g_hGUI_NOTIFY_TAB_ImageList)

	Bind_ImageList($g_hGUI_ATTACK_TAB, $g_hGUI_ATTACK_TAB_ImageList)
	Bind_ImageList($g_hGUI_TRAINARMY_TAB, $g_hGUI_TRAINARMY_TAB_ImageList)
	Bind_ImageList($g_hGUI_SEARCH_TAB, $g_hGUI_SEARCH_TAB_ImageList)
	Bind_ImageList($g_hGUI_DEADBASE_TAB, $g_hGUI_DEADBASE_TAB_ImageList)
	Bind_ImageList($g_hGUI_ACTIVEBASE_TAB, $g_hGUI_ACTIVEBASE_TAB_ImageList)
	Bind_ImageList($g_hGUI_ATTACKOPTION_TAB, $g_hGUI_ATTACKOPTION_TAB_ImageList)
	Bind_ImageList($g_hGUI_STRATEGIES_TAB, $g_hGUI_STRATEGIES_TAB_ImageList)
	

	Bind_ImageList($g_hGUI_BOT_TAB, $g_hGUI_BOT_TAB_ImageList)
	Bind_ImageList($g_hGUI_SWITCH_OPTIONS_TAB, $g_hGUI_SWITCH_OPTIONS_TAB_ImageList)
	Bind_ImageList($g_hGUI_STATS_TAB, $g_hGUI_STATS_TAB_ImageList)

	; Show Tab LOG
	GUICtrlSetState($g_hTabLog, $GUI_SHOW)
	tabMain()

	; Create log window
	cmbLog()

;~ -------------------------------------------------------------
	SetDebugLog("$g_hFrmBot=" & $g_hFrmBot, Default, True)
	SetDebugLog("$g_hFrmBotEx=" & $g_hFrmBotEx, Default, True)
	SetDebugLog("$g_hFrmBotBottom=" & $g_hFrmBotBottom, Default, True)
	SetDebugLog("$g_hFrmBotEmbeddedShield=" & $g_hFrmBotEmbeddedShield, Default, True)
	SetDebugLog("$g_hFrmBotEmbeddedShieldInput=" & $g_hFrmBotEmbeddedShieldInput, Default, True)
	SetDebugLog("$g_hFrmBotEmbeddedGraphics=" & $g_hFrmBotEmbeddedGraphics, Default, True)

EndFunc   ;==>CreateMainGUIControls

Func ShowMainGUI()

	If $g_iGuiMode = 0 Then Return

	CheckDpiAwareness(False, $g_bBotLaunchOption_ForceDpiAware, True)

	If Not $g_bNoFocusTampering Then
		; normal
		GUISetState(@SW_SHOW, $g_hFrmBot)
	Else
		GUISetState(@SW_SHOW, $g_hFrmBot)
		;GUISetState(@SW_SHOWNOACTIVATE, $g_hFrmBot)
		;Local $lCurExStyle = _WinAPI_GetWindowLong($g_hFrmBot, $GWL_EXSTYLE)
		;_WinAPI_SetWindowLong($g_hAndroidWindow, $GWL_EXSTYLE, BitOR($lCurExStyle, $WS_EX_TOPMOST))
		;_WinAPI_SetWindowLong($g_hAndroidWindow, $GWL_EXSTYLE, $lCurExStyle)
	EndIf

	; create task bar object
	If IsObj($g_ITBL_oTaskBar) = 0 Then
		_ITaskBar_CreateTaskBarObj(True, False)
		If @error Then
			SetLog("Cannot create Taskbar icons, error: " & @error, $COLOR_ERROR)
		EndIf
	EndIf

	; add taskbar buttons
	If IsObj($g_ITBL_oTaskBar) And $g_hTblStart = 0 Then
		$g_hTblStart = _ITaskBar_CreateTBButton(GetTranslatedFileIni("MBR GUI Design Bottom", "BtnStart", "Start Bot"), @ScriptDir & '\images\Icons\TaskBar_start.ico')
		$g_hTblStop = _ITaskBar_CreateTBButton(GetTranslatedFileIni("MBR GUI Design Bottom", "BtnStop", "Stop Bot"), @ScriptDir & '\images\Icons\TaskBar_stop.ico', -1, -1, $THBF_DISABLED)
		$g_hTblPause = _ITaskBar_CreateTBButton(GetTranslatedFileIni("MBR GUI Design Bottom", "BtnPause", "Pause"), @ScriptDir & '\images\Icons\TaskBar_pause.ico', -1, -1, $THBF_DISABLED)
		$g_hTblResume = _ITaskBar_CreateTBButton(GetTranslatedFileIni("MBR GUI Design Bottom", "BtnResume", "Resume"), @ScriptDir & '\images\Icons\TaskBar_resume.ico', -1, -1, $THBF_DISABLED)
		$g_hTblMakeScreenshot = _ITaskBar_CreateTBButton(GetTranslatedFileIni("MBR GUI Design Bottom", "BtnMakeScreenshot", "Photo"), @ScriptDir & '\images\Icons\TaskBar_photo.ico')
		_ITaskBar_AddTBButtons($g_hFrmBot)
	EndIf

	GUISetState(@SW_SHOWNOACTIVATE, $g_hFrmBotButtons)
	If $g_hFrmBotEx Then GUISetState(@SW_SHOWNOACTIVATE, $g_hFrmBotEx)
	GUISetState(@SW_SHOWNOACTIVATE, $g_hFrmBotBottom)
	CheckBotShrinkExpandButton()

	GUISwitch($g_hFrmBotEx)
	$g_bFrmBotMinimized = False

	Local $p = WinGetPos($g_hFrmBot)
	$g_aFrmBotPosInit[0] = $p[0]
	$g_aFrmBotPosInit[1] = $p[1]
	$g_aFrmBotPosInit[2] = $p[2]
	$g_aFrmBotPosInit[3] = $p[3]
	$g_aFrmBotPosInit[4] = _WinAPI_GetClientWidth($g_hFrmBot)
	$g_aFrmBotPosInit[5] = _WinAPI_GetClientHeight($g_hFrmBot)
	$g_aFrmBotPosInit[6] = ControlGetPos($g_hFrmBot, "", $g_hFrmBotEx)[3]

EndFunc   ;==>ShowMainGUI

Func UpdateMainGUI()
	If $g_hLibMyBot <> -1 Then
		;enable buttons start and search mode only if MRBfunctions.dll loaded, prevent click of buttons before dll loaded in memory
		GUICtrlSetState($g_hBtnStart, $GUI_ENABLE)
		; enable search only button when TH level variable has valid level, to avoid posts from users not pressing start first
		If $g_iTownHallLevel > 2 Then
			GUICtrlSetState($g_hBtnSearchMode, $GUI_ENABLE)
		EndIf
	EndIf
EndFunc   ;==>UpdateMainGUI

Func CheckDpiAwareness($bCheckOnlyIfAlreadyAware = False, $bForceDpiAware = False, $bForceDpiAware2 = False)

	Static $sbDpiAware = False
	Static $sbDpiAlreadyChecked = False

	If $bCheckOnlyIfAlreadyAware = True Then Return $sbDpiAware

	Local $bDpiAware = False
	Local $bChanged = False

	If $sbDpiAlreadyChecked = True Or (Not IsBotLaunched() And $bForceDpiAware2 = False) Then Return $bChanged

	If $g_iDpiAwarenessMode <> 0 And RegRead("HKCU\Control Panel\Desktop\WindowMetrics", "AppliedDPI") <> 96 Then
		; DPI is different, check if awareness needs to be set
		$bDpiAware = $bForceDpiAware = True _ ; override to set DPI Awareness regardless of current state
				Or $g_bChkBackgroundMode = False _ ; in non background mode Desktop screen capture is totally wrong due to the scaling
				Or GetProcessDpiAwareness(GetAndroidPid()) ; in normal background mode using WinAPI and Android is DPI Aware, bot must be too or window will be scaled and blury
		; 2019-04-19 cosote: removed "$g_bAndroidAdbScreencap = False And" from line above
		$bChanged = $bDpiAware And Not $sbDpiAware
		If $bChanged Then ; only required when not running with screencap, but even if screencap is running, change it
			$sbDpiAware = True ; do it only once, assume bot will become DPI aware
			Local $bWasEmbedded = AndroidEmbedded()
			If $bWasEmbedded Then AndroidEmbed(False)
			; Make this process DPI aware, so it doesn't scale (for now only way to get bot working right)
			If $g_bCustomTitleBarActive = False Then
				; Default Windows Title Bar changes height
				Local $g_iDpiAwarenessYcomp = _WinAPI_GetSystemMetrics($SM_CYCAPTION)
				Local $aResult = DllCall("user32.dll", "boolean", "SetProcessDPIAware")
				$g_aFrmBotPosInit[7] = _WinAPI_GetSystemMetrics($SM_CYCAPTION) - $g_iDpiAwarenessYcomp
				SetDebugLog("Enabled DPI Awareness, height compensation: " & $g_aFrmBotPosInit[7])
				;DllCall("user32.dll", "dword", "SetProcessDpiAwareness", "dword", 0)
			Else
				; Custom Title Bar
				Local $aResult = DllCall("user32.dll", "boolean", "SetProcessDPIAware")
			EndIf
			SetDebugLog("SetProcessDPIAware called: " & @error & ((UBound($aResult) = 0) ? ("") : (", " & $aResult[0])))
			If $bWasEmbedded Then AndroidEmbed(True)
		EndIf

	EndIf

	;$sbDpiAlreadyChecked = True ; executed often so cache result (even if DPI changes!)

	Return $bChanged
EndFunc   ;==>CheckDpiAwareness

Func GetProcessDpiAwareness($iPid)
	$iPid = ProcessExists($iPid)
	If $iPid = 0 Then
		Return SetError(1, 0, 0)
	EndIf
	Local $hProcess
	If _WinAPI_GetVersion() >= 6.0 Then
		$hProcess = _WinAPI_OpenProcess($PROCESS_QUERY_LIMITED_INFORMATION, 0, $iPid)
	Else
		$hProcess = _WinAPI_OpenProcess($PROCESS_QUERY_INFORMATION, 0, $iPid)
	EndIf
	If @error Then
		Return SetError(2, 0, 0)
	EndIf
	Local $aResult = DllCall("user32.dll", "boolean", "GetProcessDpiAwarenessInternal", "handle", $hProcess, "ulong*", 0)
	_WinAPI_CloseHandle($hProcess)
	If @error Or UBound($aResult) < 3 Then Return SetError(3, 0, 0)
	Local $iDpiAwareness = $aResult[2]
	Return $iDpiAwareness
EndFunc   ;==>GetProcessDpiAwareness

; Create GUI but register it also in $g_oGuiNotInMini to get deleted when switching to Mini Mode
Func _GUICreate($title, $width, $height, $left = -1, $top = -1, $style = -1, $exStyle = -1, $parent = 0)
	Local $h = GUICreate($title, $width, $height, $left, $top, $style, $exStyle, $parent)
	Local $key = String($h)
	Local $obj = $h
	$g_oGuiNotInMini.Add($key, $obj)
	Return $h
EndFunc   ;==>_GUICreate

;######################################################################################################################################
; #FUNCTION# ====================================================================================================================
; Name ..........: GetDPIRatio
; Description ...:
; Syntax ........: GetDPIRatio([$iDPIDef = 96])
; Parameters ....: $iDPIDef             - [optional] An integer value. Default is 96.
; Return values .: Desktop Scaling float (1 = 100% for 96 DPI)
; Author ........: UEZ
; Modified ......:
; Remarks .......: Update GUI like this: GUISetFont(8.5 * _GDIPlus_GraphicsGetDPIRatio())
; Related .......:
; Link ..........: http://www.autoitscript.com/forum/topic/159612-dpi-resolution-problem/?hl=%2Bdpi#entry1158317
; Example .......: No
; ===============================================================================================================================
Func GetDPIRatio($iDPIDef = 96)
	;return 1
	_GDIPlus_Startup()
	Local $hGfx = _GDIPlus_GraphicsCreateFromHWND(0)
	If @error Then Return SetError(1, @extended, 0)
	Local $aResult = DllCall($__g_hGDIPDll, "int", "GdipGetDpiX", "handle", $hGfx, "float*", 0)
	If @error Then Return SetError(2, @extended, 1)
	Local $iDPI = $iDPIDef / $aResult[2]
	_GDIPlus_GraphicsDispose($hGfx)
	_GDIPlus_Shutdown()
	Return $iDPI
EndFunc   ;==>GetDPIRatio

; #FUNCTION# ====================================================================================================================
; Name ..........: _GUICtrlCreateIcon
; Description ...: Uses GUICtrlCreatePic to reduce GDI Handles by 2 per control
; Syntax ........: see GUICtrlCreateIcon
; Parameters ....: see GUICtrlCreateIcon
; Return values .:
; Author ........: cosote
; Modified ......:
; Remarks .......: Optimized for $g_sLibIconPath
; Related .......:
; Link ..........: http://www.autoitscript.com/forum/topic/159612-dpi-resolution-problem/?hl=%2Bdpi#entry1158317
; Example .......: No
; ===============================================================================================================================
Func _GUICtrlCreateIcon($filename, $iconName, $left, $top, $width = 32, $height = 32, $style = -1, $exStyle = -1)
	;Return GUICtrlCreateIcon($filename, $iconName, $left, $top, $width, $height, $style, $exStyle)
	Static $s_hLibIcon = 0
	Local $hLib
	If $filename = $g_sLibIconPath Then
		If $s_hLibIcon = 0 Then
			$s_hLibIcon = _WinAPI_LoadLibraryEx($filename, $LOAD_LIBRARY_AS_DATAFILE)
		EndIf
		$hLib = $s_hLibIcon
	Else
		$hLib = _WinAPI_LoadLibraryEx($filename, $LOAD_LIBRARY_AS_DATAFILE)
	EndIf
	Local $hIcon = _WinAPI_LoadImage($hLib, $iconName, $IMAGE_ICON, $width, $height, $LR_DEFAULTCOLOR)
	If $hLib <> $s_hLibIcon Then
		_WinAPI_FreeLibrary($hLib)
	EndIf
	Local $hBmp = _WinAPI_Create32BitHBITMAP($hIcon, False, True)
	Local $controlID = GUICtrlCreatePic("", $left, $top, $width, $height, $style, $exStyle)
	_WinAPI_DeleteObject(GUICtrlSendMsg($controlID, $STM_SETIMAGE, 0, $hBmp))
	_WinAPI_DeleteObject($hBmp)
	; required for later icon change using _GUICtrlSetImage
	Local $aIconData = [$width, $height]
	$g_oCtrlIconData("Icon:" & GUICtrlGetHandle($controlID)) = $aIconData
	Return $controlID
EndFunc   ;==>_GUICtrlCreateIcon

; #FUNCTION# ====================================================================================================================
; Name ..........: _GUICtrlSetImage
; Description ...: Support icon change for _GUICtrlCreateIcon
; Syntax ........: see GUICtrlSetImage
; Parameters ....: see GUICtrlSetImage
; Return values .:
; Author ........: cosote
; Modified ......:
; Remarks .......: Optimized for $g_sLibIconPath
; Related .......:
; Link ..........: http://www.autoitscript.com/forum/topic/159612-dpi-resolution-problem/?hl=%2Bdpi#entry1158317
; Example .......: No
; ===============================================================================================================================
Func _GUICtrlSetImage($controlID, $filename, $iconName = -1, $iconType = 1)

	Local $aIconData = $g_oCtrlIconData("Icon:" & GUICtrlGetHandle($controlID))

	;SetDebugLog("_GUICtrlSetImage pass $iconName=" & $iconName)
	If IsArray($aIconData) = 0 Then
		;SetDebugLog("Control is an array, returning.")
		Return GUICtrlSetImage($controlID, $filename, $iconName, $iconType)
	EndIf

	Static $s_hLibIcon = 0
	Local $hLib
	If $filename = $g_sLibIconPath Then
		If $s_hLibIcon = 0 Then
			$s_hLibIcon = _WinAPI_LoadLibraryEx($filename, $LOAD_LIBRARY_AS_DATAFILE)
		EndIf
		$hLib = $s_hLibIcon
		;SetDebugLog("$hlib set to " & $hlib)
	Else
		$hLib = _WinAPI_LoadLibraryEx($filename, $LOAD_LIBRARY_AS_DATAFILE)
	EndIf
	;If $hLib = 0 Then SetDebugLog("hLib is zero.  Returning.")
	If $hLib = 0 Then Return 0
	Local $width = $aIconData[0], $height = $aIconData[1]
	Local $hIcon = _WinAPI_LoadImage($hLib, $iconName, $IMAGE_ICON, $width, $height, $LR_DEFAULTCOLOR)
	;SetDebugLog("width, height:" & $width & ", " & $height)
	;SetDebugLog("$hIcon=" & $hIcon)
	;SetDebugLog("$s_hlibIcon=" & $s_hLibIcon)
	If $hLib <> $s_hLibIcon Then
		_WinAPI_FreeLibrary($hLib)
		;SetDebugLog("Freed $hlib=" & $hlib)
	EndIf
	;If $hIcon = 0 Then SetDebugLog("hIcon is zero.  Returning.")
	If $hIcon = 0 Then Return 0
	Local $hBmp = _WinAPI_Create32BitHBITMAP($hIcon, False, True)
	;If $hBmp = 0 Then SetDebugLog("hBmp is zero.  Returning.")
	If $hBmp = 0 Then Return 0
	_WinAPI_DeleteObject(GUICtrlSendMsg($controlID, $STM_SETIMAGE, 0, 0))
	GUICtrlSendMsg($controlID, $STM_SETIMAGE, 0, $hBmp)
	_WinAPI_InvalidateRect(GUICtrlGetHandle($controlID), 0, False)
	_WinAPI_DeleteObject($hBmp)
	Return 1
EndFunc   ;==>_GUICtrlSetImage
