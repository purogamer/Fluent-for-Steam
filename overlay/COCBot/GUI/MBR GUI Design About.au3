; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file creates the "About" tab
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: CodeSlinger69 (2017)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Global $g_hGUI_ABOUT = 0
Global $g_hLblCreditsBckGrnd = 0, $g_hLblMyBotURL = 0, $g_hLblForumURL = 0
Global $g_hGUI_CommandLineHelp = 0

Func CreateAboutTab()
	$g_hGUI_ABOUT = _GUICreate("", $g_iSizeWGrpTab1, $g_iSizeHGrpTab1, $_GUI_CHILD_LEFT, $_GUI_CHILD_TOP, BitOR($WS_CHILD, $WS_TABSTOP), -1, $g_hFrmBotEx)

	Local $sText = ""
	Local $x = 18, $y = 10 + $_GUI_MAIN_TOP

	$sText = "My Bot is brought to you by a worldwide team of open source" & @CRLF & _
			"programmers and a vibrant community of forum members!"
	GUICtrlCreateLabel($sText, $x + 8, $y - 10, 400, 35, $SS_CENTER)
	GUICtrlSetFont(-1, 10, $FW_BOLD, Default, "Arial")
	GUICtrlSetColor(-1, $COLOR_NAVY)

	$y += 30
	$sText = "Please visit our web forums:"
	GUICtrlCreateLabel($sText, $x + 44, $y, 180, 30, $SS_CENTER)
	GUICtrlSetFont(-1, 9.5, $FW_BOLD, Default, "Arial")
	$g_hLblMyBotURL = GUICtrlCreateLabel("https://mybot.run/forums", $x + 223, $y, 150, 20)
	GUICtrlSetCursor(-1, 0)
	GUICtrlSetFont(-1, 9.5, $FW_BOLD, Default, "Arial")
	GUICtrlSetColor(-1, $COLOR_INFO)

	$y += 22
	GUICtrlCreateLabel("Credits belong to following programmers for donating their time:", $x - 5, $y, 420, 20)
	GUICtrlSetFont(-1, 10, $FW_BOLD, Default, "Arial")

	$y += 30
	$sText = "Active developers: "
	GUICtrlCreateLabel($sText, $x - 5, $y, 410, 20, BitOR($WS_VISIBLE, $ES_AUTOVSCROLL, $SS_LEFT), 0)
	GUICtrlSetFont(-1, 9.5, $FW_BOLD, Default, "Arial")
	GUICtrlSetColor(-1, $COLOR_NAVY)
	$sText = "Chilly-Chill, Fliegerfaust and TFKNazGul"
	GUICtrlCreateLabel($sText, $x + 5, $y + 15, 410, 50, BitOR($WS_VISIBLE, $ES_AUTOVSCROLL, $SS_LEFT), 0)
	GUICtrlSetFont(-1, 9, $FW_MEDIUM, Default, "Arial")

	$y += 35
	$sText = "Special participation at v7.8: "
	GUICtrlCreateLabel($sText, $x - 5, $y, 410, 20, BitOR($WS_VISIBLE, $ES_AUTOVSCROLL, $SS_LEFT), 0)
	GUICtrlSetFont(-1, 9.5, $FW_BOLD, Default, "Arial")
	GUICtrlSetColor(-1, $COLOR_NAVY)
	$sText = "HarchH, Nytol and of course Beta Tester Team"
	GUICtrlCreateLabel($sText, $x + 5, $y + 15, 410, 50, BitOR($WS_VISIBLE, $ES_AUTOVSCROLL, $SS_LEFT), 0)
	GUICtrlSetFont(-1, 9, $FW_MEDIUM, Default, "Arial")

	$y += 35
	$sText = "Inactive developers: "
	GUICtrlCreateLabel($sText, $x - 5, $y, 410, 20, BitOR($WS_VISIBLE, $ES_AUTOVSCROLL, $SS_LEFT), 0)
	GUICtrlSetFont(-1, 9.5, $FW_BOLD, Default, "Arial")
	GUICtrlSetColor(-1, $COLOR_NAVY)
	$sText = "Cosote, Demen, Hervidero, Kaganus, Sardo, Trlopes, TripleM"
	GUICtrlCreateLabel($sText, $x + 5, $y + 15, 410, 50, BitOR($WS_VISIBLE, $ES_AUTOVSCROLL, $SS_LEFT), 0)
	GUICtrlSetFont(-1, 9, $FW_MEDIUM, Default, "Arial")

	$y += 50
	$sText = "Retired developers: "
	GUICtrlCreateLabel($sText, $x - 5, $y, 410, 20, BitOR($WS_VISIBLE, $ES_AUTOVSCROLL, $SS_LEFT), 0)
	GUICtrlSetFont(-1, 9.5, $FW_BOLD, Default, "Arial")
	GUICtrlSetColor(-1, $COLOR_NAVY)
	$sText = "Antidote, AtoZ, Barracoda, Boju, Codeslinger69, Didipe, Dinobot, DixonHill, DkEd, GkevinOD, HungLe, KnowJack, LunaEclipse, MonkeyHunter, ProMac, Safar46, Saviart, TheMaster1st, Zengzeng, and others"
	GUICtrlCreateLabel($sText, $x + 5, $y + 15, 410, 50, BitOR($WS_VISIBLE, $ES_AUTOVSCROLL, $SS_LEFT), 0)
	GUICtrlSetFont(-1, 9, $FW_MEDIUM, Default, "Arial")

	$y += 71
	$sText = "Special thanks to all contributing forum members helping to make this" & @CRLF & "software better! And a special note to: @KevinM our server admin!"
	GUICtrlCreateLabel($sText, $x + 14, $y, 390, 30, BitOR($WS_VISIBLE, $ES_AUTOVSCROLL, $ES_CENTER), 0)
	GUICtrlSetFont(-1, 9, $FW_MEDIUM, Default, "Arial")

	$y += 40
	$sText = "The latest release of 'My Bot' can be found at:"
	GUICtrlCreateLabel($sText, $x - 5, $y, 400, 15, BitOR($WS_VISIBLE, $ES_AUTOVSCROLL, $SS_LEFT), 0)
	GUICtrlSetFont(-1, 10, $FW_BOLD, Default, "Arial")

	$y += 18
	$g_hLblForumURL = GUICtrlCreateLabel("https://mybot.run/forums/index.php?/forum/4-official-releases/", $x + 25, $y, 450, 20)
	GUICtrlSetCursor(-1, 0)
	GUICtrlSetFont(-1, 9.5, $FW_BOLD, Default, "Arial")
	GUICtrlSetColor(-1, $COLOR_INFO)

	$y = 380
	$sText = "By running this program, the user accepts all responsibility that arises from the use of this software." & @CRLF & _
			"This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even " & @CRLF & _
			"the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General " & @CRLF & _
			"Public License for more details. The license can be found in the main code folder location." & @CRLF & _
			"Copyright (C) 2015-2022 MyBot.run"
	GUICtrlCreateLabel($sText, $x + 1, $y, 415, 56, BitOR($WS_VISIBLE, $ES_AUTOVSCROLL, $SS_LEFT, $ES_CENTER), 0)
	GUICtrlSetColor(-1, 0x000053)
	GUICtrlSetFont(-1, 6.5, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
EndFunc   ;==>CreateAboutTab

Func ShowCommandLineHelp()
	Return ShowHelp(Default)
EndFunc   ;==>ShowCommandLineHelp

Func ShowControlHelp()
	Return ShowHelp(@GUI_CtrlId)
EndFunc   ;==>ShowControlHelp

Func ShowHelp($Source = Default)

	SetDebugLog ("Help File called from: " & $source)

	Local $PathHelp = "CommandLineParameter"

	; This can be use for several Help Files
	Switch $source
		Case $g_lblHelpBot; Bot/Android/Help Handle
			$PathHelp = "CommandLineParameter"
		Case $g_lblHepNotify
			$PathHelp = "NotifyHelp"
		; Discord - Team AIO Mod++
		Case $g_lblHepNotifyDS
			$PathHelp = "DiscordNotifyHelp"
	EndSwitch

	UpdateBotTitle()
	$g_hGUI_CommandLineHelp = GUICreate($g_sBotTitle & " - Command Line Help", 650, 700, -1, -1, BitOR($WS_CAPTION, $WS_POPUPWINDOW, $DS_MODALFRAME), $WS_EX_TOPMOST, $g_hFrmBot)
	GUISetIcon($g_sLibIconPath, $eIcnGUI, $g_hGUI_CommandLineHelp)

	; add controls
	Local $hClose = GUICtrlCreateButton("Close", 300, 670, 50)
	Local $hRichEdit = _GUICtrlRichEdit_Create($g_hGUI_CommandLineHelp, "", 2, 0, 646, 667, $WS_VSCROLL + $ES_MULTILINE)
	Local $sHelpFile = @ScriptDir & "\Help\" & $PathHelp
	If $g_sLanguage <> $g_sDefaultLanguage Then
		If FileExists($sHelpFile & "_" & $g_sLanguage & ".rtf") Then
			$sHelpFile &= "_" & $g_sLanguage
		Else
			SetDebugLog("Help file not available: " & $sHelpFile & "_" & $g_sLanguage & ".rtf")
		EndIf
	EndIf
	_GUICtrlRichEdit_StreamFromFile($hRichEdit, $sHelpFile & ".rtf")
	_GUICtrlRichEdit_SetReadOnly($hRichEdit)
	_GUICtrlRichEdit_SetScrollPos($hRichEdit, 0, 0) ; scroll to top

	Local $iOpt = Opt("GUIOnEventMode", 0)
	GUISetState(@SW_SHOW, $g_hGUI_CommandLineHelp)
	While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE, $hClose
				ExitLoop
		EndSwitch
	WEnd

	GUIDelete($g_hGUI_CommandLineHelp)
	Opt("GUIOnEventMode", $iOpt)
EndFunc   ;==>ShowHelp
