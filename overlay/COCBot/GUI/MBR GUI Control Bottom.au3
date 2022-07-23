; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Control
; Description ...: This file Includes all functions to current GUI
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: GkevinOD (2014)
; Modified ......: Hervidero (2015), KnowJack(July 2015), CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Global $g_aFrmBotBottomCtrlState, $g_hFrmBotEmbeddedShield = 0, $g_hFrmBotEmbeddedMouse = 0, $g_hFrmBotEmbeddedGraphics = 0

Func Initiate()
	WinGetAndroidHandle()
	If $g_hAndroidWindow <> 0 And ($g_bAndroidBackgroundLaunched = True Or AndroidControlAvailable()) Then
		SetLogCentered(" " & $g_sBotTitle & " Powered by MyBot.run ", "~", $COLOR_DEBUG)

		Local $Compiled = @ScriptName & (@Compiled ? " Executable" : " Script")
		SetLog($Compiled & " running on " & _OSVersion() & " " & @OSServicePack & " " & @OSArch)
		If Not $g_bSearchMode Then
			SetLogCentered(" Bot Start ", Default, $COLOR_SUCCESS)
		Else
			SetLogCentered(" Search Mode Start ", Default, $COLOR_SUCCESS)
		EndIf
		SetLogCentered("  Current Profile: " & $g_sProfileCurrentName & " ", "-", $COLOR_INFO)
		If $g_bDevMode = True Then ; Custom fix - Team AIO Mod++
			SetLogCentered(" Warning Debug Mode Enabled! ", "-", $COLOR_ERROR)
			SetLog("      SetLog : " & $g_bDebugSetlog, $COLOR_ERROR, "Lucida Console", 8)
			SetLog("     Android : " & $g_bDebugAndroid, $COLOR_ERROR, "Lucida Console", 8)
			SetLog("         OCR : " & $g_bDebugOcr, $COLOR_ERROR, "Lucida Console", 8)
			SetLog("     RedArea : " & $g_bDebugRedArea, $COLOR_ERROR, "Lucida Console", 8)
			SetLog("   ImageSave : " & $g_bDebugImageSave, $COLOR_ERROR, "Lucida Console", 8)
			SetLog(" BuildingPos : " & $g_bDebugBuildingPos, $COLOR_ERROR, "Lucida Console", 8)
			SetLog("   OCRDonate : " & $g_bDebugOCRdonate, $COLOR_ERROR, "Lucida Console", 8)
			SetLog("   AttackCSV : " & $g_bDebugAttackCSV, $COLOR_ERROR, "Lucida Console", 8)
			SetLogCentered(" Warning Debug Mode Enabled! ", "-", $COLOR_ERROR)
		EndIf

		$g_bInitiateSwitchAcc = True
		$g_sLabUpgradeTime = ""
		For $i = 0 To $eLootCount - 1
			$g_abFullStorage[$i] = False
		Next

;~ 		If $g_bNotifyDeleteAllPushesOnStart Then _DeletePush()

		If Not $g_bSearchMode Then
			$g_hTimerSinceStarted = __TimerInit()
		EndIf

		AndroidBotStartEvent() ; signal android that bot is now running
		If Not $g_bRunState Then Return

		If Not $g_bSearchMode Then
			If $g_bRestarted Then
				$g_bRestarted = False
				IniWrite($g_sProfileConfigPath, "general", "Restarted", 0)
				PushMsg("Restarted")
			EndIf
		EndIf
		If Not $g_bRunState Then Return

		AndroidShield("Initiate", True)
		checkMainScreen()
		If Not $g_bRunState Then Return

		ZoomOut()
		If Not $g_bRunState Then Return

		If Not $g_bSearchMode Then
			BotDetectFirstTime()
			If Not $g_bRunState Then Return

			If $g_bCheckGameLanguage Then TestLanguage()
			If Not $g_bRunState Then Return

			runBot()
		EndIf
	Else
		SetLog("Not in Game!", $COLOR_ERROR)
		;		$g_bRunState = True
		btnStop()
	EndIf
EndFunc   ;==>Initiate

Func InitiateLayout()

	Local $AdjustScreenIfNecessarry = True
	WinGetAndroidHandle()
	Local $BSsize = getAndroidPos()

	If IsArray($BSsize) Then ; Is Android Client Control available?

		Local $BSx = $BSsize[2]
		Local $BSy = $BSsize[3]

		SetDebugLog("InitiateLayout: " & $g_sAndroidTitle & " Android-ClientSize: " & $BSx & " x " & $BSy, $COLOR_INFO)

		If Not CheckScreenAndroid($BSx, $BSy) Then ; Is Client size now correct?
			If $AdjustScreenIfNecessarry = True Then
				Local $MsgRet = $IDOK
				;If _Sleep(3000) Then Return False
				;Local $MsgRet = MsgBox(BitOR($MB_OKCANCEL, $MB_SYSTEMMODAL), "Change the resolution and restart " & $g_sAndroidEmulator & "?", _
				;	"Click OK to adjust the screen size of " & $g_sAndroidEmulator & " and restart the emulator." & @CRLF & _
				;	"If your " & $g_sAndroidEmulator & " really has the correct size (" & $g_iDEFAULT_WIDTH & " x " & $g_iDEFAULT_HEIGHT & "), click CANCEL." & @CRLF & _
				;	"(Automatically Cancel in 15 Seconds)", 15)

				If $MsgRet = $IDOK Then
					Return RebootAndroidSetScreen() ; recursive call!
					;Return "RebootAndroidSetScreen()"
				EndIf
			Else
				SetLog("Cannot use " & $g_sAndroidEmulator & ".", $COLOR_ERROR)
				SetLog("Please set its screen size manually to " & $g_iAndroidClientWidth & " x " & $g_iAndroidClientHeight, $COLOR_ERROR)
				btnStop()
				Return False
			EndIf
		EndIf

		DisposeWindows()
		Return True

	EndIf

	Return False

EndFunc   ;==>InitiateLayout

Func chkBackground()
	If IsDeclared("g_hChkBackgroundMode") Then
		UpdateChkBackground()
		; update Android Window always on top
		AndroidToFront(Default, "chkBackground")
	EndIf
EndFunc   ;==>chkBackground

Func UpdateChkBackground()
	If GUICtrlRead($g_hChkBackgroundMode) = $GUI_CHECKED Then
		$g_bChkBackgroundMode = True
		updateBtnHideState($GUI_ENABLE)
	Else
		$g_bChkBackgroundMode = False
		updateBtnHideState($GUI_DISABLE)
	EndIf
	If CheckDpiAwareness() Then
		; DPI awareness changed
	EndIf
EndFunc   ;==>UpdateChkBackground

Func IsStopped()
	If $g_bRunState Then Return False
	If $g_bRestart Then Return True
	Return False
EndFunc   ;==>IsStopped

Func btnStart()
	; decide when to run
	EnableControls($g_hFrmBotBottom, False, $g_aFrmBotBottomCtrlState)
	Local $bRunNow = $g_iBotAction <> $eBotNoAction
	If $bRunNow Then
		BotStart()
	Else
		$g_iBotAction = $eBotStart
	EndIf
	$g_iActualTrainSkip = 0
	#Region - Type Once - ChacalGyn
	Local $iRequestTroopTypeOnce = $g_PreResetZero
	$g_aiRequestTroopTypeOnce = $iRequestTroopTypeOnce
	#EndRegion - Type Once - ChacalGyn
EndFunc   ;==>btnStart

Func btnStop()
	If $g_bRunState Then
		; always invoked in MyBot.run.au3!
		EnableControls($g_hFrmBotBottom, False, $g_aFrmBotBottomCtrlState)
		$g_bRunState = False ; Exit BotStart()
	EndIf
	$g_iBotAction = $eBotStop
EndFunc   ;==>btnStop

Func btnSearchMode()
	; decide when to run
	EnableControls($g_hFrmBotBottom, False, $g_aFrmBotBottomCtrlState)
	Local $bRunNow = $g_iBotAction <> $eBotNoAction
	If $bRunNow Then
		BotSearchMode()
	Else
		$g_iBotAction = $eBotSearchMode
	EndIf
EndFunc   ;==>btnSearchMode

Func btnPause($bRunNow = True)
	TogglePause()
	; Enable/Disable GUI while botting - Team AiO MOD++
	GUICtrlSetState($g_hBtnDisableGUI, $GUI_HIDE)
	GUICtrlSetState($g_hBtnEnableGUI, $GUI_SHOW)

	GUICtrlSetState($g_hLblVersion, $GUI_HIDE)
	; GUICtrlSetState($g_hLblMod, $GUI_HIDE)

EndFunc   ;==>btnPause

Func btnResume()
	TogglePause()
	; Enable/Disable GUI while botting - Team AiO MOD++
	GUICtrlSetState($g_hBtnDisableGUI, $GUI_HIDE)
	GUICtrlSetState($g_hBtnEnableGUI, $GUI_HIDE)

	If $g_bVillageSearchActive And $g_bSearchAttackNowEnable Then
		GUICtrlSetState($g_hLblVersion, $GUI_HIDE)
		; GUICtrlSetState($g_hLblMod, $GUI_HIDE)
	Else
		GUICtrlSetState($g_hLblVersion, $GUI_SHOW)
		; GUICtrlSetState($g_hLblMod, $GUI_SHOW)
	EndIf

EndFunc   ;==>btnResume

; Enable/Disable GUI while botting - Team AiO MOD++
Func btnEnableGUI()
	GUICtrlSetState($g_hBtnEnableGUI, $GUI_HIDE)
	GUICtrlSetState($g_hBtnDisableGUI, $GUI_SHOW)
	GUICtrlSetState($g_hBtnResume, $GUI_DISABLE)
	AndroidShieldForceDown(True)
	EnableGuiControls() ; enable emulator menu controls
	SetLog("Enabled bot controls as you wished", $COLOR_SUCCESS)
EndFunc   ;==>btnEnableGUI

Func btnDisableGUI()
	GUICtrlSetState($g_hBtnDisableGUI, $GUI_HIDE)
	GUICtrlSetState($g_hBtnEnableGUI, $GUI_SHOW)
	GUICtrlSetState($g_hBtnResume, $GUI_ENABLE)
	SetLog("Save config and disable bot controls manually", $COLOR_SUCCESS)
	AndroidShieldForceDown(False)
	SaveConfig()
	readConfig()
	applyConfig()
	DisableGuiControls()
EndFunc   ;==>btnDisableGUI
; Enable/Disable GUI while botting - Team AiO MOD++

Func btnAttackNowDB()
	If $g_bRunState Then
		$g_bBtnAttackNowPressed = True
		$g_iMatchMode = $DB
	EndIf
EndFunc   ;==>btnAttackNowDB

Func btnAttackNowLB()
	If $g_bRunState Then
		$g_bBtnAttackNowPressed = True
		$g_iMatchMode = $LB
	EndIf
EndFunc   ;==>btnAttackNowLB

;~ Hide Android Window again without overwriting $botPos[0] and [1]
Func reHide()
	WinGetAndroidHandle()
	If $g_bIsHidden And $g_hAndroidWindow <> 0 And Not $g_bAndroidEmbedded Then
		SetDebugLog("Hide " & $g_sAndroidEmulator & " Window after restart")
		Local $Result = HideAndroidWindow(True, Default, Default, "reHide") ;WinMove($g_hAndroidWindow, "", -32000, -32000)
		updateBtnHideState()
		Return $Result
	EndIf
	Return 0
EndFunc   ;==>reHide

Func updateBtnHideState($newState = $GUI_ENABLE)
	If $g_hBtnHide = 0 Then Return
	Local $hideState = GUICtrlGetState($g_hBtnHide)
	Local $newHideState = ($g_bAndroidEmbedded = True ? $GUI_DISABLE : $newState)
	If $hideState <> $newHideState Then GUICtrlSetState($g_hBtnHide, $newHideState)
	Local $sText
	If $g_bIsHidden Then
		$sText = GetTranslatedFileIni("MBR GUI Control Bottom", "Func_btnHide_False", "Show")
	Else
		$sText = GetTranslatedFileIni("MBR GUI Control Bottom", "Func_btnHide_True", "Hide")
	EndIf
	If GUICtrlRead($g_hBtnHide) <> $sText Then
		; update text
		GUICtrlSetData($g_hBtnHide, $sText)
	EndIf
EndFunc   ;==>updateBtnHideState

Func btnHide()
	$g_bIsHidden = Not $g_bIsHidden
	HideAndroidWindow($g_bIsHidden, Default, Default, "btnHide")
	updateBtnHideState()
EndFunc   ;==>btnHide

Func updateBtnEmbed()
	If $g_hBtnEmbed = 0 Then Return False
	UpdateFrmBotStyle()
	Local $state = GUICtrlGetState($g_hBtnEmbed)
	If $g_hAndroidWindow = 0 Or $g_bAndroidBackgroundLaunched = True Or $g_bAndroidEmbed = False Or $g_iGuiMode <> 1 Then
		If $state <> $GUI_DISABLE Then GUICtrlSetState($g_hBtnEmbed, $GUI_DISABLE)
		updateBtnHideState()
		Return False
	EndIf

	Local $text = GUICtrlRead($g_hBtnEmbed)
	Local $newText
	If $g_bAndroidEmbedded Then
		$newText = GetTranslatedFileIni("MBR GUI Control Bottom", "Func_AndroidEmbedded_False", "Undock")
	Else
		$newText = GetTranslatedFileIni("MBR GUI Control Bottom", "Func_AndroidEmbedded_True", "Dock")
	EndIf
	If $text <> $newText Then GUICtrlSetData($g_hBtnEmbed, $newText)
	If $state <> $GUI_ENABLE Then GUICtrlSetState($g_hBtnEmbed, $GUI_ENABLE)
	; also update hide button
	updateBtnHideState()
	Return True
EndFunc   ;==>updateBtnEmbed

Func btnEmbed()
	ResumeAndroid()
	WinGetAndroidHandle()
	WinGetPos($g_hAndroidWindow)
	If @error <> 0 Then Return SetError(0, 0, 0)
	AndroidEmbed(Not $g_bAndroidEmbedded)
EndFunc   ;==>btnEmbed

Func btnMakeScreenshot()
	If $g_bRunState Then
		; call with flag when bot is running to execute on _sleep() idle
		$g_bMakeScreenshotNow = True
	Else
		; call directly when bot is stopped
		If $g_bScreenshotPNGFormat = False Then
			MakeScreenshot($g_sProfileTempPath, "jpg")
		Else
			MakeScreenshot($g_sProfileTempPath, "png")
		EndIf
	EndIf
EndFunc   ;==>btnMakeScreenshot

Func GetFont()
	Local $i, $sText = "", $DefaultFont
	$DefaultFont = __EMB_GetDefaultFont()
	For $i = 0 To UBound($DefaultFont) - 1
		$sText &= " $DefaultFont[" & $i & "]= " & $DefaultFont[$i] & ", "
	Next
	SetLog($sText, $COLOR_DEBUG)
EndFunc   ;==>GetFont

Func btnVillageStat($source = "")
	If $g_iFirstRun = 0 And $g_bRunState And Not $g_bBotPaused Then SetTime(True)

	If $g_iCurrentReport = $g_iVillageHourlyReport Then
		;HIDE Village Report Values
		GUICtrlSetState($g_hLblResultGoldNow, $GUI_ENABLE + $GUI_HIDE)
		GUICtrlSetState($g_hLblResultElixirNow, $GUI_ENABLE + $GUI_HIDE)
		GUICtrlSetState($g_hLblResultDENow, $GUI_ENABLE + $GUI_HIDE)
		GUICtrlSetState($g_hLblResultTrophyNow, $GUI_ENABLE + $GUI_HIDE)
		GUICtrlSetState($g_hLblResultBuilderNow, $GUI_ENABLE + $GUI_HIDE)
		GUICtrlSetState($g_hLblResultGemNow, $GUI_ENABLE + $GUI_HIDE)
		If $g_iFirstRun = 1 Then
			GUICtrlSetState($g_hPicResultDETemp, $GUI_ENABLE + $GUI_SHOW)
		Else
			GUICtrlSetState($g_hPicResultDENow, $GUI_ENABLE + $GUI_SHOW)
		EndIf
		;HIDE BB Report Values
		GUICtrlSetState($g_hLblBBResultGoldNow, $GUI_ENABLE + $GUI_HIDE)
		GUICtrlSetState($g_hLblBBResultElixirNow, $GUI_ENABLE + $GUI_HIDE)
		GUICtrlSetState($g_hLblBBResultTrophyNow, $GUI_ENABLE + $GUI_HIDE)
		GUICtrlSetState($g_hLblBBResultBuilderNow, $GUI_ENABLE + $GUI_HIDE)
		;SHOW Village HOURLY Values
		GUICtrlSetState($g_hLblResultGoldHourNow, $GUI_ENABLE + $GUI_SHOW)
		GUICtrlSetState($g_hLblResultElixirHourNow, $GUI_ENABLE + $GUI_SHOW)
		GUICtrlSetState($g_hLblResultDEHourNow, $GUI_ENABLE + $GUI_SHOW)
		If $g_iFirstRun = 0 Or $source = "UpdateStats" Then
			GUICtrlSetState($g_hLblResultRuntimeNow, $GUI_ENABLE + $GUI_SHOW)
			GUICtrlSetState($g_hLblResultAttackedHourNow, $GUI_ENABLE + $GUI_SHOW)
			GUICtrlSetState($g_hLblResultSkippedHourNow, $GUI_ENABLE + $GUI_SHOW)
		EndIf
		;HIDE BB Report Pics
		GUICtrlSetState($g_hPicBBResultTrophyNow, $GUI_ENABLE + $GUI_HIDE)
		GUICtrlSetState($g_hPicBBResultBuilderNow, $GUI_ENABLE + $GUI_HIDE)
		;HIDE Village Report Pics
		GUICtrlSetState($g_hPicResultTrophyNow, $GUI_ENABLE + $GUI_HIDE)
		GUICtrlSetState($g_hPicResultBuilderNow, $GUI_ENABLE + $GUI_HIDE)
		GUICtrlSetState($g_hPicResultGemNow, $GUI_ENABLE + $GUI_HIDE)
		;SHOW Village HOURLY Pics
		GUICtrlSetState($g_hPicResultRuntimeNow, $GUI_ENABLE + $GUI_SHOW)
		GUICtrlSetState($g_hPicResultAttackedHourNow, $GUI_ENABLE + $GUI_SHOW)
		GUICtrlSetState($g_hPicResultSkippedHourNow, $GUI_ENABLE + $GUI_SHOW)
		GUICtrlSetData($g_hLblVillageReportTemp, GetTranslatedFileIni("MBR GUI Design Bottom", "LblVillageReportTemp_01", "Village Report") & @CRLF & _
				GetTranslatedFileIni("MBR GUI Design Bottom", "LblVillageReportTemp_02", "will appear here") & @CRLF & _
				GetTranslatedFileIni("MBR GUI Design Bottom", "LblVillageReportTemp_03", "on first run."))
		GUICtrlSetData($g_hGrpVillage, GetTranslatedFileIni("MBR Main GUI", "Tab_02", -1) & ": " & $g_sProfileCurrentName)
	ElseIf $g_iCurrentReport = $g_iVillageReport Then
		;SHOW Village Report Values
		GUICtrlSetState($g_hLblResultGoldNow, $GUI_ENABLE + $GUI_SHOW)
		GUICtrlSetState($g_hLblResultElixirNow, $GUI_ENABLE + $GUI_SHOW)
		GUICtrlSetState($g_hLblResultDENow, $GUI_ENABLE + $GUI_SHOW)
		GUICtrlSetState($g_hLblResultTrophyNow, $GUI_ENABLE + $GUI_SHOW)
		GUICtrlSetState($g_hLblResultBuilderNow, $GUI_ENABLE + $GUI_SHOW)
		GUICtrlSetState($g_hLblResultGemNow, $GUI_ENABLE + $GUI_SHOW)
		If $g_iFirstRun = 1 Then
			GUICtrlSetState($g_hPicResultDETemp, $GUI_ENABLE + $GUI_SHOW)
		Else
			GUICtrlSetState($g_hPicResultDENow, $GUI_ENABLE + $GUI_SHOW)
		EndIf
		;HIDE BB Report Values
		GUICtrlSetState($g_hLblBBResultGoldNow, $GUI_ENABLE + $GUI_HIDE)
		GUICtrlSetState($g_hLblBBResultElixirNow, $GUI_ENABLE + $GUI_HIDE)
		GUICtrlSetState($g_hLblBBResultTrophyNow, $GUI_ENABLE + $GUI_HIDE)
		GUICtrlSetState($g_hLblBBResultBuilderNow, $GUI_ENABLE + $GUI_HIDE)
		;HIDE Village HOURLY Values
		GUICtrlSetState($g_hLblResultGoldHourNow, $GUI_ENABLE + $GUI_HIDE)
		GUICtrlSetState($g_hLblResultElixirHourNow, $GUI_ENABLE + $GUI_HIDE)
		GUICtrlSetState($g_hLblResultDEHourNow, $GUI_ENABLE + $GUI_HIDE)
		GUICtrlSetState($g_hLblResultRuntimeNow, $GUI_ENABLE + $GUI_HIDE)
		GUICtrlSetState($g_hLblResultAttackedHourNow, $GUI_ENABLE + $GUI_HIDE)
		GUICtrlSetState($g_hLblResultSkippedHourNow, $GUI_ENABLE + $GUI_HIDE)
		;HIDE BB Report Pics
		GUICtrlSetState($g_hPicBBResultTrophyNow, $GUI_ENABLE + $GUI_HIDE)
		GUICtrlSetState($g_hPicBBResultBuilderNow, $GUI_ENABLE + $GUI_HIDE)
		;SHOW Village Report Pics
		GUICtrlSetState($g_hPicResultTrophyNow, $GUI_ENABLE + $GUI_SHOW)
		GUICtrlSetState($g_hPicResultBuilderNow, $GUI_ENABLE + $GUI_SHOW)
		GUICtrlSetState($g_hPicResultGemNow, $GUI_ENABLE + $GUI_SHOW)
		;HIDE Village HOURLY Pics
		GUICtrlSetState($g_hPicResultRuntimeNow, $GUI_ENABLE + $GUI_HIDE)
		GUICtrlSetState($g_hPicResultAttackedHourNow, $GUI_ENABLE + $GUI_HIDE)
		GUICtrlSetState($g_hPicResultSkippedHourNow, $GUI_ENABLE + $GUI_HIDE)
		GUICtrlSetData($g_hLblVillageReportTemp, GetTranslatedFileIni("MBR GUI Design Bottom", "LblVillageReportTemp_01", "Village Report") & @CRLF & _
				GetTranslatedFileIni("MBR GUI Design Bottom", "LblVillageReportTemp_02", "will appear here") & @CRLF & _
				GetTranslatedFileIni("MBR GUI Design Bottom", "LblVillageReportTemp_03", "on first run."))
		GUICtrlSetData($g_hGrpVillage, GetTranslatedFileIni("MBR Main GUI", "Tab_02", -1) & ": " & $g_sProfileCurrentName)
	ElseIf $g_iCurrentReport = $g_iBBReport Then
		;HIDE Village Report Values
		GUICtrlSetState($g_hLblResultGoldNow, $GUI_ENABLE + $GUI_HIDE)
		GUICtrlSetState($g_hLblResultElixirNow, $GUI_ENABLE + $GUI_HIDE)
		GUICtrlSetState($g_hLblResultDENow, $GUI_ENABLE + $GUI_HIDE)
		GUICtrlSetState($g_hLblResultTrophyNow, $GUI_ENABLE + $GUI_HIDE)
		GUICtrlSetState($g_hLblResultBuilderNow, $GUI_ENABLE + $GUI_HIDE)
		If $g_iFirstRun = 1 Then
			GUICtrlSetState($g_hPicResultDETemp, $GUI_ENABLE + $GUI_HIDE)
		Else
			GUICtrlSetState($g_hPicResultDENow, $GUI_ENABLE + $GUI_HIDE)
		EndIf
		;SHOW BB Report Values
		GUICtrlSetState($g_hLblBBResultGoldNow, $GUI_ENABLE + $GUI_SHOW)
		GUICtrlSetState($g_hLblBBResultElixirNow, $GUI_ENABLE + $GUI_SHOW)
		GUICtrlSetState($g_hLblBBResultTrophyNow, $GUI_ENABLE + $GUI_SHOW)
		GUICtrlSetState($g_hLblBBResultBuilderNow, $GUI_ENABLE + $GUI_SHOW)
		GUICtrlSetState($g_hLblResultGemNow, $GUI_ENABLE + $GUI_SHOW)
		;HIDE Village HOURLY Values
		GUICtrlSetState($g_hLblResultGoldHourNow, $GUI_ENABLE + $GUI_HIDE)
		GUICtrlSetState($g_hLblResultElixirHourNow, $GUI_ENABLE + $GUI_HIDE)
		GUICtrlSetState($g_hLblResultDEHourNow, $GUI_ENABLE + $GUI_HIDE)
		GUICtrlSetState($g_hLblResultRuntimeNow, $GUI_ENABLE + $GUI_HIDE)
		GUICtrlSetState($g_hLblResultAttackedHourNow, $GUI_ENABLE + $GUI_HIDE)
		GUICtrlSetState($g_hLblResultSkippedHourNow, $GUI_ENABLE + $GUI_HIDE)
		;SHOW BB Report Pics
		GUICtrlSetState($g_hPicBBResultTrophyNow, $GUI_ENABLE + $GUI_SHOW)
		GUICtrlSetState($g_hPicBBResultBuilderNow, $GUI_ENABLE + $GUI_SHOW)
		GUICtrlSetState($g_hPicResultGemNow, $GUI_ENABLE + $GUI_SHOW)
		;HIDE Village Report Pics
		GUICtrlSetState($g_hPicResultTrophyNow, $GUI_ENABLE + $GUI_HIDE)
		GUICtrlSetState($g_hPicResultBuilderNow, $GUI_ENABLE + $GUI_HIDE)
		;HIDE Village HOURLY Pics
		GUICtrlSetState($g_hPicResultRuntimeNow, $GUI_ENABLE + $GUI_HIDE)
		GUICtrlSetState($g_hPicResultAttackedHourNow, $GUI_ENABLE + $GUI_HIDE)
		GUICtrlSetState($g_hPicResultSkippedHourNow, $GUI_ENABLE + $GUI_HIDE)
		GUICtrlSetData($g_hLblVillageReportTemp, GetTranslatedFileIni("MBR GUI Design Bottom", "LblVillageReportTemp_04", "BB Report") & @CRLF & _
				GetTranslatedFileIni("MBR GUI Design Bottom", "LblVillageReportTemp_02", "will appear here") & @CRLF & _
				GetTranslatedFileIni("MBR GUI Design Bottom", "LblVillageReportTemp_03", "on first run."))
		GUICtrlSetData($g_hGrpVillage, GetTranslatedFileIni("MBR Main GUI", "Tab_04_Profile", "Builder Base") & ": " & $g_sProfileCurrentName)
	EndIf

EndFunc   ;==>btnVillageStat

Func EnableGuiControls($bOptimizedRedraw = True)
	Return ToggleGuiControls(True, $bOptimizedRedraw)
EndFunc   ;==>EnableGuiControls

Func DisableGuiControls($bOptimizedRedraw = True)
	Return ToggleGuiControls(False, $bOptimizedRedraw)
EndFunc   ;==>DisableGuiControls

Func ToggleGuiControls($bEnabled, $bOptimizedRedraw = True)
	$g_bGuiControlsEnabled = $bEnabled
	If $g_iGuiMode <> 1 Then Return
	If $bOptimizedRedraw Then Local $bWasRedraw = SetRedrawBotWindow(False, Default, Default, Default, "ToggleGuiControls")
	If Not $bEnabled Then
		SetDebugLog("Disable GUI Controls")
	Else
		SetDebugLog("Enable GUI Controls")
	EndIf
	$g_bGUIControlDisabled = True
	For $i = $g_hFirstControlToHide To $g_hLastControlToHide
		If IsAlwaysEnabledControl($i) Then ContinueLoop
		;If $g_bNotifyPBEnable And $i = $g_hBtnNotifyDeleteMessages Then ContinueLoop ; exclude the DeleteAllMesages button when Discord is enabled
		If Not $bEnabled Then
			; Save state of all controls on tabs
			$g_aiControlPrevState[$i] = BitAND(GUICtrlGetState($i), $GUI_ENABLE)
			If $g_aiControlPrevState[$i] Then GUICtrlSetState($i, $GUI_DISABLE)
		Else
			; Restore previous state of controls
			If $g_aiControlPrevState[$i] Then GUICtrlSetState($i, $g_aiControlPrevState[$i])
		EndIf
	Next
	If Not $bEnabled Then
		ControlDisable("", "", $g_hCmbGUILanguage)
	Else
		ControlEnable("", "", $g_hCmbGUILanguage)
	EndIf
	$g_bGUIControlDisabled = False
	If $bOptimizedRedraw Then SetRedrawBotWindow($bWasRedraw, Default, Default, Default, "ToggleGuiControls")
EndFunc   ;==>ToggleGuiControls
