; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design Splash
; Description ...: This file Includes GUI Design
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: mikemikemikecoc (2016)
; Modified ......: cosote (2016-Aug), CodeSlinger69 (2017), MonkeyHunter (05-2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once
#include <Sound.au3>

; Splash Variables
Global $g_hSplash = 0, $g_hSplashProgress, $g_lSplashStatus, $g_lSplashPic, $g_lSplashTitle
Global $g_iSplashTotalSteps = Default
Global $g_iSplashCurrentStep = 0
Global $g_hSplashTimer = 0
Global $g_hSplashMutex = 0

#include "MBR GUI Control Splash.au3"

#Region Splash
Func CreateSplashScreen($iSteps = Default)

	Local $iGuiState = @SW_SHOWNOACTIVATE
	Local $bDisableSplash = $g_bDisableSplash
	Local $bCustomWindow = IsString($iSteps)

	If $iSteps = Default Then
		$g_iSplashTotalSteps = 13 ; Custom - AIO Mod++
	Else
		$iGuiState = @SW_SHOW
		$bDisableSplash = False
		If Not $bCustomWindow Then
			$g_iSplashTotalSteps = $iSteps
			$g_iSplashCurrentStep = 0
			$g_hSplashTimer = 0
		EndIf
	EndIf

	Local $sSplashImg = $g_sLogoLoading
	Local $iX, $iY
	Local $iT = 0 ; Top of logo (additional space) ; Custom - AIO Mod++
	Local $iB = 0 ; Bottom of logo (additional space)

	If Not $bCustomWindow Then
		Switch $g_iGuiMode ; in Mini GIU or GUI less mode we have less steps
			Case 0 ; No GUI
				$g_iSplashTotalSteps = 3
			Case 2 ; Mini GUI
				$g_iSplashTotalSteps = 4
		EndSwitch

		; Launch only one bot at a time... it simply consumes too much CPU
		$g_hSplashMutex = AcquireMutexTicket("Launching", 1, Default, False)
	EndIf

	If $bDisableSplash = False Or $bCustomWindow Then

		Local $hSplashImg = _GDIPlus_BitmapCreateFromFile($sSplashImg)
		; Determine dimensions of splash image
		$iX = _GDIPlus_ImageGetWidth($hSplashImg)
		$iY = _GDIPlus_ImageGetHeight($hSplashImg)

		Local $iHeight = $iY + $iT + $iB + 60 ; size = image+Top space+Bottom space+60
		Local $iCenterX = @DesktopWidth / 2 ; find center of main display
		Local $iCenterY = @DesktopHeight / 2
		Local $iTop = $iCenterY - $iHeight / 2
		Local $iLeft = $iCenterX - $iX / 2 ; position splash UI centered on width

		; Create Splash container
		$g_hSplash = GUICreate("", $iX, $iHeight, $iLeft, $iTop, BitOR($WS_POPUP, $WS_BORDER, $DS_MODALFRAME), BitOR($WS_EX_TOPMOST, $WS_EX_WINDOWEDGE, $WS_EX_TOOLWINDOW))
		GUISetBkColor($COLOR_WHITE, $g_hSplash)
		$g_lSplashPic = _GUICtrlCreatePic($hSplashImg, 0, $iT) ; Splash Image
		GUICtrlSetOnEvent(-1, "MoveSplashScreen")
		If Not $bCustomWindow Then
			$g_lSplashTitle = GUICtrlCreateLabel($g_sBotTitle, 15, $iY + $iT + $iB + 3, $iX - 30, 15, $SS_CENTER) ; Splash Title
			GUICtrlSetOnEvent(-1, "MoveSplashScreen")
			$g_hSplashProgress = GUICtrlCreateProgress(15, $iY + $iT + $iB + 20, $iX - 30, 10, $PBS_SMOOTH, BitOR($WS_EX_TOPMOST, $WS_EX_WINDOWEDGE, $WS_EX_TOOLWINDOW)) ; Splash Progress
			$g_lSplashStatus = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design - Loading", "SplashStep_Loading", "Loading..."), 15, $iY + $iT + $iB + 38, $iX - 30, 15, $SS_CENTER) ; Splash Title
			GUICtrlSetOnEvent(-1, "MoveSplashScreen")
		Else
			$g_lSplashTitle = 0
			$g_hSplashProgress = 0
			$g_lSplashStatus = 0
		EndIf

		; Cleanup GDI resources
		_GDIPlus_BitmapDispose($hSplashImg)

		SetDebugLog("Splash created: $g_hSplash=" & $g_hSplash & ", $g_lSplashPic=" & $g_lSplashPic & ", $g_lSplashTitle=" & $g_lSplashTitle & ", $g_hSplashProgress=" & $g_hSplashProgress & ", $g_lSplashStatus=" & $g_lSplashStatus)

		If Not $bCustomWindow Then
			; Show Splash
			GUISetState($iGuiState, $g_hSplash)
			$g_hSplashTimer = __TimerInit()
		EndIf

		Local $a = [$iX, $iHeight, $iY + $iT + $iB]
		Return $a
	EndIf

EndFunc   ;==>CreateSplashScreen
#EndRegion Splash
