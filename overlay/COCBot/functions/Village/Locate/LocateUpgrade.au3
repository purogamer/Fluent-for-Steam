; #FUNCTION# ====================================================================================================================
; Name ..........: LocateUpgrade.au3
; Description ...: Finds and determines cost of upgrades
; Syntax ........: LocateOneUpgrade($inum) = $inum is building array index [0-3]
; Parameters ....:
; Return values .:
; Author ........: KnowJack (April-2015)
; Modified ......: KnowJack (Jun/Aug-2015),Sardo 2015-08,Monkeyhunter(2106-2)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func LocateUpgrades()

	If $g_bBotPaused Then
		_ExtMsgBoxSet(1 + 64, $SS_CENTER, 0x004080, 0xFFFF00, 12, "Comic Sans MS", 500)
		Local $stext = GetTranslatedFileIni("MBR Popups", "Func_Locate_Building_BotPaused", "Cannot locate Upgrades when bot is paused!")
		Local $MsgBox = _ExtMsgBox(48, GetTranslatedFileIni("MBR Popups", "Ok", "Ok"), GetTranslatedFileIni("MBR Popups", "Notice", "Notice"), $stext, 15, $g_hFrmBot)
		Return
	EndIf

	WinGetAndroidHandle()

	If $g_hAndroidWindow <> 0 And $g_bAndroidBackgroundLaunched = True Then ; Android is running in background mode, so restart Android
		SetLog("Reboot " & $g_sAndroidEmulator & " for Window access", $COLOR_ERROR)
		RebootAndroid(True)
	EndIf

	If $g_hAndroidWindow = 0 Then ; If not found, Android is not open so exit politely
		SetLog($g_sAndroidEmulator & " is not open", $COLOR_ERROR)
		SetError(1)
		Return
	EndIf

	AndroidToFront(Default, "LocateUpgrades")

	Local $wasDown = AndroidShieldForcedDown()
	AndroidShield("LocateUpgrades") ; Update shield status due to manual $g_bRunState

	;SetLog("Upgrade Buildings and Auto Wall Upgrade Can Not Use same Loot Type!", $COLOR_SUCCESS)  = disabled due v7.0 skipwallupgrade code
	Local $MsgBox, $stext
	Local $icount = 0
	Local $hGraphic = 0
	Local $bInitGraphics = True
	While 1
		_CaptureRegion(0, 0, $g_iDEFAULT_WIDTH, 2)
		If _GetPixelColor(1, 1) <> Hex(0x000000, 6) Or _GetPixelColor(850, 1) <> Hex(0x000000, 6) Then ; Check for zoomout in case user tried to zoom in.
			ZoomOut()
			$g_bDisableBreakCheck = True ; stop early PB log off when locating upgrades
			Collect()
			$g_bDisableBreakCheck = False ; restore flag
		EndIf
		$g_bDisableBreakCheck = True ; stop early PB log off when locating upgrades
		Collect() ; must collect or clicking on collectors will fail 1st time
		$g_bDisableBreakCheck = False ; restore flag

		If $bInitGraphics Then
			$bInitGraphics = False
			$hGraphic = AndroidGraphicsGdiBegin()
			If $hGraphic <> 0 Then
				Local $hPen = AndroidGraphicsGdiAddObject("Pen", _GDIPlus_PenCreate(0xFFFFFF00, 2))
				SetDebugLog("LocateUpgrades: $hGraphic=" & $hGraphic & ", $hPen=" & $hPen)

				For $icount = 0 To UBound($g_avBuildingUpgrades, 1) - 1
					If $hGraphic <> 0 And $g_avBuildingUpgrades[$icount][0] > 0 And $g_avBuildingUpgrades[$icount][0] > 0 Then
						Local $xUpgrade = $g_avBuildingUpgrades[$icount][0]
						Local $yUpgrade = $g_avBuildingUpgrades[$icount][1]
						ConvertToVillagePos($xUpgrade, $yUpgrade)
						Local $bMarkerDrawn = _GDIPlus_GraphicsDrawEllipse($hGraphic, $xUpgrade - 10, $yUpgrade - 10, 20, 20, $hPen)
						AndroidGraphicsGdiUpdate()
						SetDebugLog("Existing Updgrade #" & $icount & " found at " & $g_avBuildingUpgrades[$icount][0] & "/" & $g_avBuildingUpgrades[$icount][1] & ", marker drawn: " & $bMarkerDrawn)
					EndIf
				Next
			EndIf
		EndIf

		For $icount = 0 To UBound($g_avBuildingUpgrades, 1) - 1
			If $g_abUpgradeRepeatEnable[$icount] = True And (GUICtrlRead($g_hTxtUpgradeName[$icount]) <> "") Then ; check for repeat upgrade
				_GUICtrlSetImage($g_hPicUpgradeStatus[$icount], $g_sLibIconPath, $eIcnYellowLight) ; Set GUI Status to Yellow showing ready for upgrade
				GUICtrlSetState($g_hChkUpgrade[$icount], $GUI_CHECKED) ; Change upgrade selection box to checked again
				ContinueLoop
			EndIf
			AndroidShieldForceDown(True, True)
			$stext = GetTranslatedFileIni("MBR Popups", "Func_Locate_Building_01", "Click 'Locate Building' button then click on your Building/Hero to upgrade.") & @CRLF & @CRLF & GetTranslatedFileIni("MBR Popups", "Func_Locate_Building_02", "Click 'Finished' button when done locating all upgrades.") & @CRLF & @CRLF & GetTranslatedFileIni("MBR Popups", "Func_Locate_Building_03", "Click on Cancel to exit finding buildings.") & @CRLF & @CRLF
			_ExtMsgBoxSet(1 + 64, $SS_CENTER, 0x004080, 0xFFFF00, 10, "Comic Sans MS", 500)
			$MsgBox = _ExtMsgBox(0, GetTranslatedFileIni("MBR Popups", "Func_Locate_Building_04", "Locate Building|Finished|Cancel"), GetTranslatedFileIni("MBR Popups", "Func_Locate_Building_05", "Locate Upgrades"), $stext, 0, $g_hFrmBot)
			Switch $MsgBox
				Case 1 ; YES! we want to find a building.
					Local $aPos = FindPos()
					$g_avBuildingUpgrades[$icount][0] = $aPos[0]
					$g_avBuildingUpgrades[$icount][1] = $aPos[1]
					; PercentToVillage($aPos[0], $aPos[1])
					PercentToVillage($aPos[0], $aPos[1])
					If isInsideDiamond($aPos) Then ; Check value to make sure its valid.
						Local $bMarkerDrawn = False
						If $hGraphic <> 0 Then
							Local $xUpgrade = $g_avBuildingUpgrades[$icount][0]
							Local $yUpgrade = $g_avBuildingUpgrades[$icount][1]
							; ConvertToVillagePos($xUpgrade, $yUpgrade)
							PercentToVillage($xUpgrade, $yUpgrade)
							$bMarkerDrawn = _GDIPlus_GraphicsDrawEllipse($hGraphic, $xUpgrade - 10, $yUpgrade - 10, 20, 20, $hPen)
							AndroidGraphicsGdiUpdate()
						EndIf
						SetDebugLog("Updgrade #" & $icount & " added at " & $g_avBuildingUpgrades[$icount][0] & "/" & $g_avBuildingUpgrades[$icount][1] & ", marker drawn: " & $bMarkerDrawn)
						_GUICtrlSetImage($g_hPicUpgradeStatus[$icount], $g_sLibIconPath, $eIcnYellowLight) ; Set GUI Status to Yellow showing ready for upgrade
						$g_aiPicUpgradeStatus[$icount] = $eIcnYellowLight
						If _Sleep(750) Then Return
					Else
						SetLog("Bad location recorded, location skipped?", $COLOR_ERROR)
						$g_avBuildingUpgrades[$icount][0] = -1
						$g_avBuildingUpgrades[$icount][1] = -1
						ContinueLoop ; Whoops, here we go again...
					EndIf
				Case 2 ; No! we are done!
					If $icount = 0 Then ; if no upgrades located, reset all values and return
						SetLog("Locate Upgrade Cancelled", $COLOR_WARNING)
						btnResetUpgrade()
						AndroidGraphicsGdiEnd()
						AndroidShieldForceDown($wasDown)
						Return False
					EndIf
					ExitLoop
				Case 3 ; cancel all upgrades
					SetLog("Locate Upgrade Cancelled", $COLOR_WARNING)
					btnResetUpgrade()
					AndroidGraphicsGdiEnd()
					AndroidShieldForceDown($wasDown)
					Return False
				Case Else
					SetLog("Impossible value (" & $MsgBox & ") from Msgbox, you have been a bad programmer!", $COLOR_DEBUG)
			EndSwitch

			ClickAway()

		Next
		ExitLoop
	WEnd

	AndroidGraphicsGdiEnd()
	AndroidShieldForceDown($wasDown)

	CheckUpgrades()

EndFunc   ;==>LocateUpgrades

Func CheckUpgrades() ; Valdiate and determine the cost and type of the upgrade and change GUI boxes/pics to match
	If AndroidShielded() = False Then
		_ExtMsgBoxSet(1 + 64, $SS_CENTER, 0x004080, 0xFFFF00, 12, "Comic Sans MS", 500)
		Local $stext = GetTranslatedFileIni("MBR Popups", "Func_Locate_Building_06", "Keep Mouse OUT of Android Emulator Window While I Check Your Upgrades, Thanks!!")
		Local $MsgBox = _ExtMsgBox(48, GetTranslatedFileIni("MBR Popups", "Ok", "Ok"), GetTranslatedFileIni("MBR Popups", "Notice", "Notice"), $stext, 15, $g_hFrmBot)
		If _Sleep($DELAYCHECKUPGRADES) Then Return
		If $MsgBox <> 1 Then
			SetLog("Something weird happened in getting upgrade values, try again", $COLOR_ERROR)
			Return False
		EndIf
	EndIf
	For $iz = 0 To UBound($g_avBuildingUpgrades, 1) - 1
		If isInsideDiamondXY($g_avBuildingUpgrades[$iz][0], $g_avBuildingUpgrades[$iz][1]) = False Then ; check for location off grass.
			_GUICtrlSetImage($g_hPicUpgradeStatus[$iz], $g_sLibIconPath, $eIcnRedLight) ; change indicator back to red showing location invalid
			GUICtrlSetState($g_hChkUpgrade[$iz], $GUI_UNCHECKED) ; Change upgrade selection box to unchecked
			If $g_abUpgradeRepeatEnable[$iz] = True Then GUICtrlSetState($g_hChkUpgradeRepeat[$iz], $GUI_UNCHECKED) ; Change repeat selection box to unchecked
			ContinueLoop
		EndIf

		If UpgradeValue($iz) = False Then ; Get the upgrade cost, name, level, and time
			If $g_abUpgradeRepeatEnable[$iz] = True And $g_avBuildingUpgrades[$iz][4] <> "" Then ContinueLoop ; If repeat is checked and bldg has name, then get value later.
			SetLog("Locate Upgrade #" & $iz + 1 & " Value Error, try again", $COLOR_ERROR)
			_GUICtrlSetImage($g_hPicUpgradeStatus[$iz], $g_sLibIconPath, $eIcnRedLight) ; change indicator back to red showing location invalid
			GUICtrlSetData($g_hTxtUpgradeName[$iz], "") ; Clear GUI Name
			GUICtrlSetData($g_hTxtUpgradeLevel[$iz], "") ; Clear GUI Level
			GUICtrlSetData($g_hTxtUpgradeValue[$iz], "") ; Clear Upgrade value in GUI
			GUICtrlSetData($g_hTxtUpgradeTime[$iz], "") ; Clear Upgrade time in GUI
			GUICtrlSetData($g_hTxtUpgradeEndTime[$iz], "") ; Clear Upgrade End time in GUI
			_GUICtrlSetImage($g_hPicUpgradeType[$iz], $g_sLibIconPath, $eIcnBlank)
			If $g_abUpgradeRepeatEnable[$iz] = True Then GUICtrlSetState($g_hChkUpgradeRepeat[$iz], $GUI_UNCHECKED) ; Change repeat selection box to unchecked
			ContinueLoop
		EndIf
		;		GUICtrlSetState($g_hChkWalls, $GUI_UNCHECKED) ; Turn off upgrade walls since we have buidlings to upgrade  = disabled due v7.0 skipwallupgrade code
	Next
	; Add duplicate check?

EndFunc   ;==>CheckUpgrades

Func UpgradeValue($inum, $bRepeat = False) ;function to find the value and type of the upgrade.
	Local $inputbox, $iLoot, $aString, $aResult, $ButtonPixel
	Local $bOopsFlag = False

	If $bRepeat Or $g_abUpgradeRepeatEnable[$inum] Then ; check for upgrade in process when continiously upgrading
		ClickAway()
		If _Sleep($DELAYUPGRADEVALUE1) Then Return
		BuildingClick($g_avBuildingUpgrades[$inum][0], $g_avBuildingUpgrades[$inum][1]) ;Select upgrade trained
		If _Sleep($DELAYUPGRADEVALUE4) Then Return
		If $bOopsFlag = True Then SaveDebugImage("ButtonView")
		; check if upgrading collector type building, and reselect in case previous click only collect resource
		If StringInStr($g_avBuildingUpgrades[$inum][4], "collect", $STR_NOCASESENSEBASIC) Or _
				StringInStr($g_avBuildingUpgrades[$inum][4], "mine", $STR_NOCASESENSEBASIC) Or _
				StringInStr($g_avBuildingUpgrades[$inum][4], "drill", $STR_NOCASESENSEBASIC) Then
			ClickAway()
			If _Sleep($DELAYUPGRADEVALUE1) Then Return
			BuildingClick($g_avBuildingUpgrades[$inum][0], $g_avBuildingUpgrades[$inum][1]) ;Select collector upgrade trained
			If _Sleep($DELAYUPGRADEVALUE4) Then Return
		EndIf
		; check for upgrade in process
		Local $offColors[3][3] = [[0x000000, 44, 17], [0xE07740, 69, 31], [0xF2F7F1, 81, 0]] ; 2nd pixel black broken hammer, 3rd pixel lt brown handle, 4th pixel white edge of button
		Local $ButtonPixel = _MultiPixelSearch(284, 572 + $g_iBottomOffsetYFixed, 570, 615 + $g_iBottomOffsetYFixed, 1, 1, Hex(0x000000, 6), $offColors, 25) ; first pixel blackon side of button
		SetDebugLog("Pixel Color #1: " & _GetPixelColor(389, 572, True) & ", #2: " & _GetPixelColor(433, 589, True) & ", #3: " & _GetPixelColor(458, 603, True) & ", #4: " & _GetPixelColor(470, 572, True), $COLOR_DEBUG)
		If IsArray($ButtonPixel) Then
			If $g_bDebugSetlog Or $bOopsFlag Then
				SetLog("ButtonPixel = " & $ButtonPixel[0] & ", " & $ButtonPixel[1], $COLOR_DEBUG) ;Debug
				SetLog("Pixel Color #1: " & _GetPixelColor($ButtonPixel[0], $ButtonPixel[1], True) & ", #2: " & _GetPixelColor($ButtonPixel[0] + 44, $ButtonPixel[1] + 17, True) & ", #3: " & _GetPixelColor($ButtonPixel[0] + 69, $ButtonPixel[1] + 31, True) & ", #4: " & _GetPixelColor($ButtonPixel[0] + 81, $ButtonPixel[1], True), $COLOR_DEBUG)
			EndIf
			SetLog("Selection #" & $inum + 1 & " Upgrade in process - Skipped!", $COLOR_WARNING)
			ClickAway()
			Return False
		EndIf
	Else ; If upgrade not in process
		If $g_avBuildingUpgrades[$inum][0] <= 0 Or $g_avBuildingUpgrades[$inum][1] <= 0 Then Return False
		$g_avBuildingUpgrades[$inum][2] = 0 ; Clear previous upgrade value if run before
		GUICtrlSetData($g_hTxtUpgradeValue[$inum], "") ; Clear Upgrade value in GUI
		$g_avBuildingUpgrades[$inum][3] = "" ; Clear previous loot type if run before
		_GUICtrlSetImage($g_hPicUpgradeType[$inum], $g_sLibIconPath, $eIcnBlank)
		$g_avBuildingUpgrades[$inum][4] = "" ; Clear upgrade name if run before
		GUICtrlSetData($g_hTxtUpgradeName[$inum], "") ; Set GUI name to match $g_avBuildingUpgrades variable
		$g_avBuildingUpgrades[$inum][5] = "" ; Clear upgrade level if run before
		GUICtrlSetData($g_hTxtUpgradeLevel[$inum], "") ; Set GUI level to match $g_avBuildingUpgrades variable
		$g_avBuildingUpgrades[$inum][6] = "" ; Clear upgrade time if run before
		GUICtrlSetData($g_hTxtUpgradeTime[$inum], "") ; Set GUI time to match $g_avBuildingUpgrades variable
		$g_avBuildingUpgrades[$inum][7] = "" ; Clear upgrade end date/time if run before
		GUICtrlSetData($g_hTxtUpgradeEndTime[$inum], "") ; Set GUI time to match $g_avBuildingUpgrades variable
		ClickAway()
		SetLog("-$Upgrade #" & $inum + 1 & " Location =  " & "(" & $g_avBuildingUpgrades[$inum][0] & "," & $g_avBuildingUpgrades[$inum][1] & ")", $COLOR_DEBUG1) ;Debug
		If _Sleep($DELAYUPGRADEVALUE1) Then Return
		BuildingClick($g_avBuildingUpgrades[$inum][0], $g_avBuildingUpgrades[$inum][1], "#0212") ;Select upgrade trained
		If _Sleep($DELAYUPGRADEVALUE2) Then Return
		If $bOopsFlag = True Then SaveDebugImage("ButtonView")
	EndIf

	If $bOopsFlag And $g_bDebugImageSave Then SaveDebugImage("ButtonView")

	$aResult = BuildingInfo(242, 490 + $g_iBottomOffsetY)
	If $aResult[0] > 0 Then
		$g_avBuildingUpgrades[$inum][4] = $aResult[1] ; Store bldg name
		GUICtrlSetData($g_hTxtUpgradeName[$inum], $g_avBuildingUpgrades[$inum][4]) ; Set GUI name to match $g_avBuildingUpgrades variable
		If $aResult[0] > 1 Then
			$g_avBuildingUpgrades[$inum][5] = $aResult[2] ; Store bdlg level
			GUICtrlSetData($g_hTxtUpgradeLevel[$inum], $g_avBuildingUpgrades[$inum][5]) ; Set GUI level to match $g_avBuildingUpgrades variable
		Else
			SetLog("Error: Level for Upgrade not found?", $COLOR_ERROR)
		EndIf
	Else
		SetLog("Error: Name & Level for Upgrade not found?", $COLOR_ERROR)
	EndIf
	SetLog("Upgrade Name = " & $g_avBuildingUpgrades[$inum][4] & ", Level = " & $g_avBuildingUpgrades[$inum][5], $COLOR_INFO) ;Debug

	Local $aUpgradeButton = findButton("Upgrade", Default, 1, True)
	If IsArray($aUpgradeButton) And UBound($aUpgradeButton, 1) = 2 Then
		ClickP($aUpgradeButton, 1, 0, "#0213") ; Click Upgrade Button
		If _Sleep($DELAYUPGRADEVALUE5) Then Return
		If $bOopsFlag And $g_bDebugImageSave Then SaveDebugImage("UpgradeView")
		ForceCaptureRegion()
		_CaptureRegion()
		Select ;Ensure the right upgrade window is open!
			Case _ColorCheck(_GetPixelColor(687, 161 + $g_iMidOffsetY), Hex(0xCD1419, 6), 20) ; Check if the building Upgrade window is open red bottom of white X to close
				If _ColorCheck(_GetPixelColor(330, 545), Hex(0xE1433F, 6), 25) Then ; Check if upgrade requires upgrade to TH and can not be completed
					If $g_abUpgradeRepeatEnable[$inum] = True Then
						SetLog("Selection #" & $inum + 1 & " can not repeat upgrade, need TH upgrade - Skipped!", $COLOR_ERROR)
						$g_abUpgradeRepeatEnable[$inum] = False
						GUICtrlSetState($g_hChkUpgradeRepeat[$inum], $GUI_UNCHECKED) ; Change repeat selection box to unchecked
					Else
						SetLog("Selection #" & $inum + 1 & " upgrade not available, need TH upgrade - Skipped!", $COLOR_ERROR)
					EndIf
					ClearUpgradeInfo($inum) ; clear upgrade information
					_GUICtrlSetImage($g_hPicUpgradeType[$inum], $g_sLibIconPath, $eIcnBlank)
					_GUICtrlSetImage($g_hPicUpgradeStatus[$inum], $g_sLibIconPath, $eIcnRedLight) ; change to needs trained indicator
					$g_abBuildingUpgradeEnable[$inum] = False
					GUICtrlSetState($g_hChkUpgrade[$inum], $GUI_UNCHECKED) ; Change upgrade selection box to unchecked
					$g_avBuildingUpgrades[$inum][7] = "" ; Clear upgrade end date/time if run before
					GUICtrlSetData($g_hTxtUpgradeEndTime[$inum], "") ; Set GUI time to match $g_avBuildingUpgrades variable
					ClickAway()
					Return False
				EndIf

				If _ColorCheck(_GetPixelColor(485, 500 + $g_iMidOffsetY), Hex(0xFFD115, 6), 20) Then $g_avBuildingUpgrades[$inum][3] = "Gold" ;Check if Gold required and update type
				If _ColorCheck(_GetPixelColor(480, 500 + $g_iMidOffsetY), Hex(0xBD21EF, 6), 20) Then $g_avBuildingUpgrades[$inum][3] = "Elixir" ;Check if Elixir required and update type

				$g_avBuildingUpgrades[$inum][2] = Number(getResourcesBonus(366, 487 + $g_iMidOffsetY)) ; Try to read white text.
				If $g_avBuildingUpgrades[$inum][2] = "" Then $g_avBuildingUpgrades[$inum][2] = Number(getUpgradeResource(366, 487 + $g_iMidOffsetY)) ;read RED upgrade text
				If $g_avBuildingUpgrades[$inum][2] = "" And $g_abUpgradeRepeatEnable[$inum] = False Then $bOopsFlag = True ; set error flag for user to set value if not repeat upgrade

				;HArchH X value was 195
				$g_avBuildingUpgrades[$inum][6] = getBldgUpgradeTime(185, 307 + $g_iMidOffsetY) ; Try to read white text showing time for upgrade
				SetLog("Upgrade #" & $inum + 1 & " Time = " & $g_avBuildingUpgrades[$inum][6], $COLOR_INFO)
				If $g_avBuildingUpgrades[$inum][6] <> "" Then $g_avBuildingUpgrades[$inum][7] = "" ; Clear old upgrade end time
				
			Case _ColorCheck(_GetPixelColor(719, 118 + $g_iMidOffsetY), Hex(0xDF0408, 6), 20) ; Check if the Hero Upgrade window is open
				If _ColorCheck(_GetPixelColor(330, 545), Hex(0xE1433F, 6), 25) Then ; Check if upgrade requires upgrade to TH and can not be completed
					If $g_abUpgradeRepeatEnable[$inum] = True Then
						SetLog("Selection #" & $inum + 1 & " can not repeat upgrade, need TH upgrade - Skipped!", $COLOR_ERROR)
						$g_abUpgradeRepeatEnable[$inum] = False
						GUICtrlSetState($g_hChkUpgradeRepeat[$inum], $GUI_UNCHECKED) ; Change repeat selection box to unchecked
					Else
						SetLog("Selection #" & $inum + 1 & " upgrade not available, need TH upgrade - Skipped!", $COLOR_ERROR)
					EndIf
					ClearUpgradeInfo($inum) ; clear upgrade information
					_GUICtrlSetImage($g_hPicUpgradeType[$inum], $g_sLibIconPath, $eIcnBlank)
					_GUICtrlSetImage($g_hPicUpgradeStatus[$inum], $g_sLibIconPath, $eIcnRedLight) ; change to needs trained indicator
					$g_abBuildingUpgradeEnable[$inum] = False
					GUICtrlSetState($g_hChkUpgrade[$inum], $GUI_UNCHECKED) ; Change upgrade selection box to unchecked
					$g_avBuildingUpgrades[$inum][7] = "" ; Clear upgrade end date/time if run before
					GUICtrlSetData($g_hTxtUpgradeEndTime[$inum], "") ; Set GUI time to match $g_avBuildingUpgrades variable
					ClickAway()
					Return False
				EndIf
				If _ColorCheck(_GetPixelColor(710, 535 + $g_iMidOffsetY), Hex(0x3C3035, 6), 20) Then $g_avBuildingUpgrades[$inum][3] = "Dark" ; Check if DE required and update type
				$g_avBuildingUpgrades[$inum][2] = Number(getResourcesBonus(598, 519 + $g_iMidOffsetY)) ; Try to read white text.
				If $g_avBuildingUpgrades[$inum][2] = "" Then $g_avBuildingUpgrades[$inum][2] = Number(getUpgradeResource(598, 519 + $g_iMidOffsetY)) ;read RED upgrade text
				If $g_avBuildingUpgrades[$inum][2] = "" And $g_abUpgradeRepeatEnable[$inum] = False Then $bOopsFlag = True ; set error flag for user to set value
				$g_avBuildingUpgrades[$inum][6] = getHeroUpgradeTime(578, 494) ; Try to read white text showing time for upgrade
				SetLog("Upgrade #" & $inum + 1 & " Time = " & $g_avBuildingUpgrades[$inum][6], $COLOR_INFO)
				If $g_avBuildingUpgrades[$inum][6] <> "" Then $g_avBuildingUpgrades[$inum][7] = "" ; Clear old upgrade end time

			Case Else
				If isGemOpen(True) Then ClickAway()
				SetLog("Selected Upgrade Window Opening Error, try again", $COLOR_ERROR)
				ClearUpgradeInfo($inum) ; clear upgrade information
				ClickAway()
				Return False

		EndSelect

		If StringInStr($g_avBuildingUpgrades[$inum][4], "Warden") > 0 Then $g_avBuildingUpgrades[$inum][3] = "Elixir"

		; Failsafe fix for upgrade value read problems if needed.
		If $g_avBuildingUpgrades[$inum][3] <> "" And $bOopsFlag = True And $bRepeat = False Then ;check if upgrade type value to not waste time and for text read oops flag
			$iLoot = $g_avBuildingUpgrades[$inum][2]
			If $iLoot = "" Then $iLoot = 8000000
			Local $aBotLoc = WinGetPos($g_hFrmBot)

			$inputbox = InputBox(GetTranslatedFileIni("MBR Popups", "Func_Locate_Building_07", "Text Read Error"), GetTranslatedFileIni("MBR Popups", "Func_Locate_Building_08", "Enter the cost of the upgrade"), $iLoot, "", -1, -1, $aBotLoc[0] + 125, $aBotLoc[1] + 225, -1, $g_hFrmBot)
			If @error Then
				SetLog("InputBox error, data reset. Try again", $COLOR_ERROR)
				ClearUpgradeInfo($inum) ; clear upgrade information
				Return False
			EndIf
			$g_avBuildingUpgrades[$inum][2] = Int($inputbox)
			SetLog("User input value = " & $g_avBuildingUpgrades[$inum][2], $COLOR_DEBUG)
			_ExtMsgBoxSet(1 + 64, $SS_CENTER, 0x004080, 0xFFFF00, 12, "Comic Sans MS", 500)
			Local $stext = GetTranslatedFileIni("MBR Popups", "Func_Locate_Building_09", "Save copy of upgrade image for developer analysis ?")
			Local $MsgBox = _ExtMsgBox(48, GetTranslatedFileIni("MBR Popups", "YES_NO", "YES|NO"), GetTranslatedFileIni("MBR Popups", "Notice", "Notice"), $stext, 60, $g_hFrmBot)
			If $MsgBox = 1 And $g_bDebugImageSave Then SaveDebugImage("UpgradeReadError_")
		EndIf
		If $g_avBuildingUpgrades[$inum][3] = "" And $bOopsFlag And Not $bRepeat Then
			_ExtMsgBoxSet(1 + 64, $SS_CENTER, 0x004080, 0xFFFF00, 10, "Comic Sans MS", 500)
			$inputbox = _ExtMsgBox(0, GetTranslatedFileIni("MBR Popups", "Func_Locate_Building_10", "   GOLD   |  ELIXIR  |DARK ELIXIR"), GetTranslatedFileIni("MBR Popups", "Func_Locate_Building_11",  "Need User Help"), GetTranslatedFileIni("MBR Popups", "Func_Locate_Building_12", "Select Upgrade Type:"), 0, $g_hFrmBot)
			SetDebugLog(" _MsgBox returned = " & $inputbox, $COLOR_DEBUG)
			Switch $inputbox
				Case 1
					$g_avBuildingUpgrades[$inum][3] = "Gold"
				Case 2
					$g_avBuildingUpgrades[$inum][3] = "Elixir"
				Case 3
					$g_avBuildingUpgrades[$inum][3] = "Dark"
				Case Else
					SetLog("Silly programmer made an error!", $COLOR_WARNING)
					$g_avBuildingUpgrades[$inum][3] = "HaHa"
			EndSwitch
			SetLog("User selected type = " & $g_avBuildingUpgrades[$inum][3], $COLOR_DEBUG)
		EndIf
		If $g_avBuildingUpgrades[$inum][2] = "" Or $g_avBuildingUpgrades[$inum][3] = "" And Not $g_abUpgradeRepeatEnable[$inum] Then ;report loot error if exists
			SetLog("Error finding loot info " & $inum & ", Loot = " & $g_avBuildingUpgrades[$inum][2] & ", Type= " & $g_avBuildingUpgrades[$inum][3], $COLOR_ERROR)
			$g_avBuildingUpgrades[$inum][0] = -1 ; Clear upgrade location value as it is invalid
			$g_avBuildingUpgrades[$inum][1] = -1 ; Clear upgrade location value as it  is invalid
			ClickAway()
			Return False
		EndIf
		SetLog("Upgrade #" & $inum + 1 & " Value = " & _NumberFormat($g_avBuildingUpgrades[$inum][2]) & " " & $g_avBuildingUpgrades[$inum][3], $COLOR_INFO) ; debug & document cost of upgrade
	Else
		If $g_abUpgradeRepeatEnable[$inum] = False Then
			SetLog("Upgrade selection problem - data cleared, please try again", $COLOR_ERROR)
			ClearUpgradeInfo($inum)
		ElseIf $g_abUpgradeRepeatEnable[$inum] = True Then
			SetLog("Repeat upgrade problem - will retry value update later", $COLOR_ERROR)
		EndIf
		ClickAway()
		Return False
	EndIf

	ClickAway()

	; Update GUI with new values
	Switch $g_avBuildingUpgrades[$inum][3] ;Set GUI Upgrade Type to match $g_avBuildingUpgrades variable
		Case "Gold"
			_GUICtrlSetImage($g_hPicUpgradeType[$inum], $g_sLibIconPath, $eIcnGold) ; 24
		Case "Elixir"
			_GUICtrlSetImage($g_hPicUpgradeType[$inum], $g_sLibIconPath, $eIcnElixir) ; 15
		Case "Dark"
			_GUICtrlSetImage($g_hPicUpgradeType[$inum], $g_sLibIconPath, $eIcnDark) ; 11
		Case Else
			_GUICtrlSetImage($g_hPicUpgradeType[$inum], $g_sLibIconPath, $eIcnBlank)
	EndSwitch
	GUICtrlSetData($g_hTxtUpgradeValue[$inum], _NumberFormat($g_avBuildingUpgrades[$inum][2])) ; Show Upgrade value in GUI
	GUICtrlSetData($g_hTxtUpgradeTime[$inum], StringStripWS($g_avBuildingUpgrades[$inum][6], $STR_STRIPALL)) ; Set GUI time to match $g_avBuildingUpgrades variable
	GUICtrlSetData($g_hTxtUpgradeEndTime[$inum], $g_avBuildingUpgrades[$inum][7]) ; Set GUI time to match $g_avBuildingUpgrades variable

	Return True

EndFunc   ;==>UpgradeValue


Func ClearUpgradeInfo($inum)
	; quick function to reset the $g_avBuildingUpgrades array for one upgrade
	$g_aiPicUpgradeStatus[$inum] = $eIcnRedLight
	$g_avBuildingUpgrades[$inum][0] = -1 ; Clear upgrade location value as it is invalid
	$g_avBuildingUpgrades[$inum][1] = -1 ; Clear upgrade location value as it is invalid
	$g_avBuildingUpgrades[$inum][2] = 0 ; Clear upgrade value as it is invalid
	$g_avBuildingUpgrades[$inum][3] = "" ; Clear upgrade type as it is invalid
	$g_avBuildingUpgrades[$inum][4] = "" ; Clear upgrade name as it is invalid
	$g_avBuildingUpgrades[$inum][5] = "" ; Clear upgrade level as it is invalid
	$g_avBuildingUpgrades[$inum][6] = "" ; Clear upgrade time as it is invalid
	$g_avBuildingUpgrades[$inum][7] = "" ; Clear upgrade end date/time as it is invalid
EndFunc   ;==>ClearUpgradeInfo
