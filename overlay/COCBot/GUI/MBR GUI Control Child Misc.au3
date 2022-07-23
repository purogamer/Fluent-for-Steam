; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Control Misc
; Description ...: This file Includes all functions to current GUI
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: MyBot.run team
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func cmbProfile()
	If LoadProfile() Then
		Return True
	EndIf
	; restore combo to current profile
	_GUICtrlComboBox_SelectString($g_hCmbProfile, $g_sProfileCurrentName)
	Return False
EndFunc   ;==>cmbProfile

Func LoadProfile($bSaveCurrentProfile = True)
	If $bSaveCurrentProfile Then
		saveConfig()
	EndIf

	; Setup the profile in case it doesn't exist.
	If setupProfile() Then
		readConfig()
		applyConfig()
		saveConfig()
		SetLog("Profile " & $g_sProfileCurrentName & " loaded from " & $g_sProfileConfigPath, $COLOR_SUCCESS)
		Return True
	EndIf
	Return False
EndFunc   ;==>LoadProfile

Func btnAddConfirm()
	Switch @GUI_CtrlId
		Case $g_hBtnAddProfile
			GUICtrlSetState($g_hCmbProfile, $GUI_HIDE)
			GUICtrlSetState($g_hTxtVillageName, $GUI_SHOW)
			GUICtrlSetState($g_hBtnAddProfile, $GUI_HIDE)
			GUICtrlSetState($g_hBtnConfirmAddProfile, $GUI_SHOW)
			GUICtrlSetState($g_hBtnDeleteProfile, $GUI_HIDE)
			GUICtrlSetState($g_hBtnCancelProfileChange, $GUI_SHOW)
			GUICtrlSetState($g_hBtnConfirmRenameProfile, $GUI_HIDE)
			GUICtrlSetState($g_hBtnRenameProfile, $GUI_HIDE)
			GUICtrlSetState($g_hBtnPullSharedPrefs, $GUI_HIDE)
			GUICtrlSetState($g_hBtnPushSharedPrefs, $GUI_HIDE)
			GUICtrlSetState($g_hBtnSaveprofile, $GUI_HIDE)
		Case $g_hBtnConfirmAddProfile
			Local $newProfileName = StringRegExpReplace(GUICtrlRead($g_hTxtVillageName), '[/:*?"<>|]', '_')
			If FileExists($g_sProfilePath & "\" & $newProfileName) Then
				MsgBox($MB_ICONWARNING, GetTranslatedFileIni("MBR Popups", "Profile_Already_Exists_01", "Profile Already Exists"), GetTranslatedFileIni("MBR Popups", "Profile_Already_Exists_02", "%s already exists.\r\nPlease choose another name for your profile.", $newProfileName))
				Return
			EndIf

			saveConfig() ; save current config so we don't miss anything recently changed
			readConfig() ; read it back in to reset all of the .ini file global variables

			$g_sProfileCurrentName = $newProfileName
			; Setup the profile if it doesn't exist.
			createProfile()
			setupProfileComboBox()
			selectProfile()
			GUICtrlSetState($g_hTxtVillageName, $GUI_HIDE)
			GUICtrlSetState($g_hCmbProfile, $GUI_SHOW)
			GUICtrlSetState($g_hBtnAddProfile, $GUI_SHOW)
			GUICtrlSetState($g_hBtnConfirmAddProfile, $GUI_HIDE)
			GUICtrlSetState($g_hBtnDeleteProfile, $GUI_SHOW)
			GUICtrlSetState($g_hBtnCancelProfileChange, $GUI_HIDE)
			GUICtrlSetState($g_hBtnConfirmRenameProfile, $GUI_HIDE)
			GUICtrlSetState($g_hBtnRenameProfile, $GUI_SHOW)
			GUICtrlSetState($g_hBtnPullSharedPrefs, $GUI_SHOW)
			GUICtrlSetState($g_hBtnPushSharedPrefs, $GUI_SHOW)
			GUICtrlSetState($g_hBtnSaveprofile, $GUI_SHOW)

			If GUICtrlGetState($g_hBtnDeleteProfile) <> $GUI_ENABLE Then GUICtrlSetState($g_hBtnDeleteProfile, $GUI_ENABLE)
			If GUICtrlGetState($g_hBtnRenameProfile) <> $GUI_ENABLE Then GUICtrlSetState($g_hBtnRenameProfile, $GUI_ENABLE)
		Case Else
			SetLog("If you are seeing this log message there is something wrong.", $COLOR_ERROR)
	EndSwitch
EndFunc   ;==>btnAddConfirm

Func btnDeleteCancel()
	Switch @GUI_CtrlId
		Case $g_hBtnDeleteProfile
			Local $msgboxAnswer = MsgBox($MB_ICONWARNING + $MB_OKCANCEL, GetTranslatedFileIni("MBR Popups", "Delete_Profile_01", "Delete Profile"), GetTranslatedFileIni("MBR Popups", "Delete_Profile_02", "Are you sure you really want to delete the profile?\r\nThis action can not be undone."))
			If $msgboxAnswer = $IDOK Then
				; Confirmed profile deletion so delete it.
				If deleteProfile() Then
					; reset inputtext
					GUICtrlSetData($g_hTxtVillageName, GetTranslatedFileIni("MBR Popups", "MyVillage", "MyVillage"))
					If _GUICtrlComboBox_GetCount($g_hCmbProfile) > 1 Then
						; select existing profile
						setupProfileComboBox()
						selectProfile()
					Else
						; create new default profile
						createProfile(True)
					EndIf
				EndIf
			EndIf
		Case $g_hBtnCancelProfileChange
			GUICtrlSetState($g_hTxtVillageName, $GUI_HIDE)
			GUICtrlSetState($g_hCmbProfile, $GUI_SHOW)
			GUICtrlSetState($g_hBtnConfirmAddProfile, $GUI_HIDE)
			GUICtrlSetState($g_hBtnAddProfile, $GUI_SHOW)
			GUICtrlSetState($g_hBtnCancelProfileChange, $GUI_HIDE)
			GUICtrlSetState($g_hBtnDeleteProfile, $GUI_SHOW)
			GUICtrlSetState($g_hBtnConfirmRenameProfile, $GUI_HIDE)
			GUICtrlSetState($g_hBtnRenameProfile, $GUI_SHOW)
			GUICtrlSetState($g_hBtnPullSharedPrefs, $GUI_SHOW)
			GUICtrlSetState($g_hBtnPushSharedPrefs, $GUI_SHOW)
			GUICtrlSetState($g_hBtnSaveprofile, $GUI_SHOW)
		Case Else
			SetLog("If you are seeing this log message there is something wrong.", $COLOR_ERROR)
	EndSwitch

	If GUICtrlRead($g_hCmbProfile) = "<No Profiles>" Then
		GUICtrlSetState($g_hBtnDeleteProfile, $GUI_DISABLE)
		GUICtrlSetState($g_hBtnRenameProfile, $GUI_DISABLE)
	EndIf
EndFunc   ;==>btnDeleteCancel

Func btnRenameConfirm()
	Switch @GUI_CtrlId
		Case $g_hBtnRenameProfile
			Local $sProfile = GUICtrlRead($g_hCmbProfile)
			If aquireProfileMutex($sProfile, False, True) = 0 Then
				Return
			EndIf
			GUICtrlSetData($g_hTxtVillageName, $sProfile)
			GUICtrlSetState($g_hCmbProfile, $GUI_HIDE)
			GUICtrlSetState($g_hTxtVillageName, $GUI_SHOW)
			GUICtrlSetState($g_hBtnAddProfile, $GUI_HIDE)
			GUICtrlSetState($g_hBtnConfirmAddProfile, $GUI_HIDE)
			GUICtrlSetState($g_hBtnDeleteProfile, $GUI_HIDE)
			GUICtrlSetState($g_hBtnCancelProfileChange, $GUI_SHOW)
			GUICtrlSetState($g_hBtnRenameProfile, $GUI_HIDE)
			GUICtrlSetState($g_hBtnConfirmRenameProfile, $GUI_SHOW)
			GUICtrlSetState($g_hBtnPullSharedPrefs, $GUI_HIDE)
			GUICtrlSetState($g_hBtnPushSharedPrefs, $GUI_HIDE)
			GUICtrlSetState($g_hBtnSaveprofile, $GUI_HIDE)
		Case $g_hBtnConfirmRenameProfile
			Local $newProfileName = StringRegExpReplace(GUICtrlRead($g_hTxtVillageName), '[/:*?"<>|]', '_')
			If FileExists($g_sProfilePath & "\" & $newProfileName) Then
				MsgBox($MB_ICONWARNING, GetTranslatedFileIni("MBR Popups", "Profile_Already_Exists_01", "Profile Already Exists"), $newProfileName & " " & GetTranslatedFileIni("MBR Popups", "Profile_Already_Exists_03", "already exists.") & @CRLF & GetTranslatedFileIni("MBR Popups", "Profile_Already_Exists_04", "Please choose another name for your profile"))
				Return
			EndIf

			$g_sProfileCurrentName = $newProfileName
			; Rename the profile.
			renameProfile()
			setupProfileComboBox()
			selectProfile()

			GUICtrlSetState($g_hTxtVillageName, $GUI_HIDE)
			GUICtrlSetState($g_hCmbProfile, $GUI_SHOW)
			GUICtrlSetState($g_hBtnConfirmAddProfile, $GUI_HIDE)
			GUICtrlSetState($g_hBtnAddProfile, $GUI_SHOW)
			GUICtrlSetState($g_hBtnCancelProfileChange, $GUI_HIDE)
			GUICtrlSetState($g_hBtnDeleteProfile, $GUI_SHOW)
			GUICtrlSetState($g_hBtnConfirmRenameProfile, $GUI_HIDE)
			GUICtrlSetState($g_hBtnRenameProfile, $GUI_SHOW)
			GUICtrlSetState($g_hBtnPullSharedPrefs, $GUI_SHOW)
			GUICtrlSetState($g_hBtnPushSharedPrefs, $GUI_SHOW)
			GUICtrlSetState($g_hBtnSaveprofile, $GUI_SHOW)
		Case Else
			SetLog("If you are seeing this log message there is something wrong.", $COLOR_ERROR)
	EndSwitch
EndFunc   ;==>btnRenameConfirm

Func btnPullSharedPrefs()
	PullSharedPrefs()
EndFunc   ;==>btnPullSharedPrefs

 ; Custom fix - Team AIO Mod++
Func btnPushSharedPrefs()
	Local $bWasRunState = $g_bRunState
	$g_bRunState = True
	CloseCOC()
	$g_bRunState = $bWasRunState
	PushSharedPrefs()
EndFunc   ;==>btnPushSharedPrefs

Func BtnSaveprofile()
	Setlog("Saving your setting...", $COLOR_INFO)
	SaveConfig()
	readConfig()
	applyConfig()
	Setlog("Done!", $COLOR_SUCCESS)
EndFunc   ;==>BtnSaveprofile

Func OnlySCIDAccounts()
	; $g_hChkOnlySCIDAccounts
	If GUICtrlRead($g_hChkOnlySCIDAccounts) = $GUI_CHECKED Then
		GUICtrlSetState($g_hCmbWhatSCIDAccount2Use, $GUI_ENABLE)
		WhatSCIDAccount2Use()
		$g_bOnlySCIDAccounts = True
	Else
		GUICtrlSetState($g_hCmbWhatSCIDAccount2Use, $GUI_DISABLE)
		$g_bOnlySCIDAccounts = False
	EndIf
EndFunc   ;==>OnlySCIDAccounts

Func WhatSCIDAccount2Use()
	; $g_hCmbWhatSCIDAccount2Use
	$g_iWhatSCIDAccount2Use = _GUICtrlComboBox_GetCurSel($g_hCmbWhatSCIDAccount2Use)
EndFunc   ;==>WhatSCIDAccount2Use

Func cmbBotCond()
	Local $iCond = _GUICtrlComboBox_GetCurSel($g_hCmbBotCond)
	If $iCond = 15 Then
		If _GUICtrlComboBox_GetCurSel($g_hCmbHoursStop) = 0 Then _GUICtrlComboBox_SetCurSel($g_hCmbHoursStop, 1)
		GUICtrlSetState($g_hCmbHoursStop, $GUI_ENABLE)
	Else
		_GUICtrlComboBox_SetCurSel($g_hCmbHoursStop, 0)
		GUICtrlSetState($g_hCmbHoursStop, $GUI_DISABLE)
	EndIf
	If $iCond = 22 Then
		GUICtrlSetState($g_hCmbHoursStop, $GUI_HIDE)
		For $i = $g_ahTxtResumeAttackLoot[$eLootTrophy] To $g_ahTxtResumeAttackLoot[$eLootDarkElixir]
			GUICtrlSetState($i, $GUI_HIDE)
		Next
		_GUI_Value_STATE("SHOW", $g_hCmbTimeStop & "#" & $g_hCmbResumeTime)
		_GUI_Value_STATE("ENABLE", $g_hCmbTimeStop & "#" & $g_hCmbResumeTime)
	Else
		_GUI_Value_STATE("HIDE", $g_hCmbTimeStop & "#" & $g_hCmbResumeTime)
		GUICtrlSetState($g_hCmbHoursStop, $GUI_SHOW)
		For $i = $g_ahTxtResumeAttackLoot[$eLootTrophy] To $g_ahTxtResumeAttackLoot[$eLootDarkElixir]
			GUICtrlSetState($i, $GUI_SHOW)
		Next
	EndIf

	For $i = $g_LblResumeAttack To $g_ahTxtResumeAttackLoot[$eLootDarkElixir]
		GUICtrlSetState($i, $GUI_DISABLE)
	Next
	If _GUICtrlComboBox_GetCurSel($g_hCmbBotCommand) <> 0 Then Return
	If $iCond <= 14 Or $iCond = 22 Then GUICtrlSetState($g_LblResumeAttack, $GUI_ENABLE)
	; Custom CG - Team AIO Mod++
	If $iCond <= 14 Then
		GUICtrlSetState($g_hChkAvoidInCG, $GUI_ENABLE)
		GUICtrlSetState($g_hChkCollectStarBonus, $GUI_ENABLE)
	EndIf
	If $iCond <= 6 Or $iCond = 8 Or $iCond = 10 Or $iCond = 14 Then GUICtrlSetState($g_ahTxtResumeAttackLoot[$eLootGold], $GUI_ENABLE)
	If $iCond <= 5 Or $iCond = 7 Or $iCond = 9 Or $iCond = 11 Or $iCond = 14 Then GUICtrlSetState($g_ahTxtResumeAttackLoot[$eLootElixir], $GUI_ENABLE)
	If $iCond = 13 Or $iCond = 14 Then GUICtrlSetState($g_ahTxtResumeAttackLoot[$eLootDarkElixir], $GUI_ENABLE)
	If $iCond <= 3 Or ($iCond >= 6 And $iCond <= 9) Or $iCond = 12 Then GUICtrlSetState($g_ahTxtResumeAttackLoot[$eLootTrophy], $GUI_ENABLE)
	If $iCond = 22 Then GUICtrlSetState($g_hCmbResumeTime, $GUI_ENABLE)
EndFunc   ;==>cmbBotCond

Func chkBotStop()
	If GUICtrlRead($g_hChkBotStop) = $GUI_CHECKED Then
		For $i = $g_hCmbBotCommand To $g_hCmbBotCond
			GUICtrlSetState($i, $GUI_ENABLE)
		Next
		cmbBotCond()
	Else
		For $i = $g_hCmbBotCommand To $g_ahTxtResumeAttackLoot[$eLootDarkElixir]
			GUICtrlSetState($i, $GUI_DISABLE)
		Next
	EndIf
EndFunc   ;==>chkBotStop

#Region - Custom Locate - Team AIO Mod++
Func btnLocateClanCastle()
	Local $wasRunState = $g_bRunState
	$g_bRunState = True
	ZoomOut()
	LocateCastle()
	chklocations()
	$g_bRunState = $wasRunState
	AndroidShield("btnLocateClanCastle") ; Update shield status due to manual $g_bRunState
EndFunc   ;==>btnLocateClanCastle

Func btnLocateKingAltar()
	Local $wasRunState = $g_bRunState
	$g_bRunState = True
	ZoomOut()
	LocateKingAltar()
	chklocations()
	$g_bRunState = $wasRunState
	AndroidShield("btnLocateKingAltar") ; Update shield status due to manual $g_bRunState
EndFunc   ;==>btnLocateKingAltar

Func btnLocateQueenAltar()
	Local $wasRunState = $g_bRunState
	$g_bRunState = True
	ZoomOut()
	LocateQueenAltar()
	chklocations()
	$g_bRunState = $wasRunState
	AndroidShield("btnLocateQueenAltar") ; Update shield status due to manual $g_bRunState
EndFunc   ;==>btnLocateQueenAltar

Func btnLocateWardenAltar()
	Local $wasRunState = $g_bRunState
	$g_bRunState = True
	ZoomOut()
	LocateWardenAltar()
	chklocations()
	$g_bRunState = $wasRunState
	AndroidShield("btnLocateWardenAltar") ; Update shield status due to manual $g_bRunState
EndFunc   ;==>btnLocateWardenAltar

Func btnLocateChampionAltar()
	Local $wasRunState = $g_bRunState
	$g_bRunState = True
	ZoomOut()
	LocateChampionAltar()
	chklocations()
	$g_bRunState = $wasRunState
	AndroidShield("btnLocateChampionAltar") ; Update shield status due to manual $g_bRunState
EndFunc   ;==>btnLocateChampionAltar

Func btnLab()
	Local $wasRunState = $g_bRunState
	$g_bRunState = True
	ZoomOut()
	LocateLab()
	ChkLocations()
	$g_bRunState = $wasRunState
	AndroidShield("btnLab")
EndFunc   ;==>btnLab

Func btnPet()
	Local $wasRunState = $g_bRunState
	$g_bRunState = True
	ZoomOut()
	LocatePetHouse()
	ChkLocations()
	$g_bRunState = $wasRunState
	AndroidShield("btnPet")
EndFunc   ;==>btnPet

Func btnLocateTownHall()
	Local $wasRunState = $g_bRunState
	Local $g_iOldTownHallLevel = $g_iTownHallLevel
	$g_bRunState = True
	ZoomOut()
	LocateTownHall()
	If Not $g_iOldTownHallLevel = $g_iTownHallLevel Then
		btnResetBuilding()
	EndIf
	chklocations()
	$g_bRunState = $wasRunState
	AndroidShield("btnLocateTownHall") ; Update shield status due to manual $g_bRunState
EndFunc   ;==>btnLocateTownHall

Func btnResetBuilding()
	Local $wasRunState = $g_bRunState
	$g_bRunState = True

	Local $aReset[2] = [-1, -1]

	$g_aiClanCastlePos = $aReset
	$g_aiLaboratoryPos = $aReset
	$g_aiPetHousePos = $aReset
	$g_aiKingAltarPos = $aReset
	$g_aiQueenAltarPos = $aReset
	$g_aiWardenAltarPos = $aReset
	$g_aiChampionAltarPos = $aReset

	; It may not be necessary to restart.
	SaveConfig()
	readConfig()
	applyConfig()

	chklocations(True)
	$g_bRunState = $wasRunState
	AndroidShield("btnResetBuilding")
EndFunc   ;==>btnResetBuilding

; ProMac....
Func chklocations($breset = False)
	If (isinsidediamond($g_aitownhallpos) = False) OR $breset Then
		GUICtrlSetBkColor($g_hlbllocateth, $COLOR_ACTION)
	Else
		GUICtrlSetBkColor($g_hlbllocateth, $color_success)
	EndIf
	If (isinsidediamond($g_aiclancastlepos) = False) OR $breset Then
		GUICtrlSetBkColor($g_hlbllocatecastle, $COLOR_ACTION)
	Else
		GUICtrlSetBkColor($g_hlbllocatecastle, $color_success)
	EndIf
	If (isinsidediamond($g_aikingaltarpos) = False) OR $breset Then
		GUICtrlSetBkColor($g_hlbllocatekingaltar, $COLOR_ACTION)
	Else
		GUICtrlSetBkColor($g_hlbllocatekingaltar, $color_success)
	EndIf
	If (isinsidediamond($g_aiqueenaltarpos) = False) OR $breset Then
		GUICtrlSetBkColor($g_hlbllocatequeenaltar, $COLOR_ACTION)
	Else
		GUICtrlSetBkColor($g_hlbllocatequeenaltar, $color_success)
	EndIf
	If (isinsidediamond($g_aiwardenaltarpos) = False) OR $breset Then
		GUICtrlSetBkColor($g_hlbllocatewardenaltar, $COLOR_ACTION)
	Else
		GUICtrlSetBkColor($g_hlbllocatewardenaltar, $color_success)
	EndIf
	If (isinsidediamond($g_aichampionaltarpos) = False) OR $breset Then
		GUICtrlSetBkColor($g_hlbllocatechampionaltar, $COLOR_ACTION)
	Else
		GUICtrlSetBkColor($g_hlbllocatechampionaltar, $color_success)
	EndIf
	If (isinsidediamond($g_ailaboratorypos) = False) OR $breset Then
		GUICtrlSetBkColor($g_hlbllocatelaboratory, $COLOR_ACTION)
	Else
		GUICtrlSetBkColor($g_hlbllocatelaboratory, $color_success)
	EndIf
	If (isinsidediamond($g_aipethousepos) = False) OR $breset Then
		GUICtrlSetBkColor($g_hlbllocatepethouse, $COLOR_ACTION)
	Else
		GUICtrlSetBkColor($g_hlbllocatepethouse, $color_success)
	EndIf
EndFunc
#EndRegion - Custom Locate - Team AIO Mod++

Func chkTrophyAtkDead()
	If GUICtrlRead($g_hChkTrophyAtkDead) = $GUI_CHECKED Then
		$g_bDropTrophyAtkDead = True
		GUICtrlSetState($g_hTxtDropTrophyArmyMin, $GUI_ENABLE)
		GUICtrlSetState($g_hLblDropTrophyArmyMin, $GUI_ENABLE)
		GUICtrlSetState($g_hLblDropTrophyArmyPercent, $GUI_ENABLE)
	Else
		$g_bDropTrophyAtkDead = False
		GUICtrlSetState($g_hTxtDropTrophyArmyMin, $GUI_DISABLE)
		GUICtrlSetState($g_hLblDropTrophyArmyMin, $GUI_DISABLE)
		GUICtrlSetState($g_hLblDropTrophyArmyPercent, $GUI_DISABLE)
	EndIf
EndFunc   ;==>chkTrophyAtkDead

Func chkTrophyRange()
	If GUICtrlRead($g_hChkTrophyRange) = $GUI_CHECKED Then
		GUICtrlSetState($g_hTxtDropTrophy, $GUI_ENABLE)
		GUICtrlSetState($g_hTxtMaxTrophy, $GUI_ENABLE)
		GUICtrlSetState($g_hChkTrophyHeroes, $GUI_ENABLE)
		GUICtrlSetState($g_hChkTrophyAtkDead, $GUI_ENABLE)
		#Region - Drop Throphy - Team AIO Mod++
		GUICtrlSetState($g_hChkTrophyTroops, $GUI_ENABLE)
		GUICtrlSetState($g_hChkTrophyHeroesAndTroops, $GUI_ENABLE)
		GUICtrlSetState($g_hChkNoDropIfShield, $GUI_ENABLE)
		#EndRegion - Drop Throphy - Team AIO Mod++
		chkTrophyAtkDead()
		chkTrophyHeroes()
	Else
		GUICtrlSetState($g_hTxtDropTrophy, $GUI_DISABLE)
		GUICtrlSetState($g_hTxtMaxTrophy, $GUI_DISABLE)
		GUICtrlSetState($g_hChkTrophyHeroes, $GUI_DISABLE)
		GUICtrlSetState($g_hChkTrophyAtkDead, $GUI_DISABLE)
		GUICtrlSetState($g_hTxtDropTrophyArmyMin, $GUI_DISABLE)
		GUICtrlSetState($g_hLblDropTrophyArmyMin, $GUI_DISABLE)
		GUICtrlSetState($g_hLblDropTrophyArmyPercent, $GUI_DISABLE)
		GUICtrlSetState($g_hLblTrophyHeroesPriority, $GUI_DISABLE)
		GUICtrlSetState($g_hCmbTrophyHeroesPriority, $GUI_DISABLE)
		#Region - Drop Throphy - Team AIO Mod++
		GUICtrlSetState($g_hChkTrophyTroops, $GUI_DISABLE)
		GUICtrlSetState($g_hChkTrophyHeroesAndTroops, $GUI_DISABLE)
		GUICtrlSetState($g_hChkNoDropIfShield, $GUI_DISABLE)
		#EndRegion - Drop Throphy - Team AIO Mod++
	EndIf
EndFunc   ;==>chkTrophyRange

Func TxtDropTrophy()
	If Number(GUICtrlRead($g_hTxtDropTrophy)) > Number(GUICtrlRead($g_hTxtMaxTrophy)) Then
		GUICtrlSetData($g_hTxtMaxTrophy, GUICtrlRead($g_hTxtDropTrophy))
		TxtMaxTrophy()
	EndIf
	_GUI_Value_STATE("HIDE", $g_aGroupListPicMinTrophy)
	If Number(GUICtrlRead($g_hTxtDropTrophy)) >= Number($g_asLeagueDetails[21][4]) Then
		GUICtrlSetState($g_hPicMinTrophies[$eLeagueLegend], $GUI_SHOW)
		GUICtrlSetData($g_hLblMinTrophies, "")
	ElseIf Number(GUICtrlRead($g_hTxtDropTrophy)) >= Number($g_asLeagueDetails[18][4]) Then
		GUICtrlSetState($g_hPicMinTrophies[$eLeagueTitan], $GUI_SHOW)
		If Number(GUICtrlRead($g_hTxtDropTrophy)) >= Number($g_asLeagueDetails[20][4]) Then
			GUICtrlSetData($g_hLblMinTrophies, "1")
		ElseIf Number(GUICtrlRead($g_hTxtDropTrophy)) >= Number($g_asLeagueDetails[19][4]) Then
			GUICtrlSetData($g_hLblMinTrophies, "2")
		ElseIf Number(GUICtrlRead($g_hTxtDropTrophy)) >= Number($g_asLeagueDetails[18][4]) Then
			GUICtrlSetData($g_hLblMinTrophies, "3")
		EndIf
	ElseIf Number(GUICtrlRead($g_hTxtDropTrophy)) >= Number($g_asLeagueDetails[15][4]) Then
		GUICtrlSetState($g_hPicMinTrophies[$eLeagueChampion], $GUI_SHOW)
		If Number(GUICtrlRead($g_hTxtDropTrophy)) >= Number($g_asLeagueDetails[17][4]) Then
			GUICtrlSetData($g_hLblMinTrophies, "1")
		ElseIf Number(GUICtrlRead($g_hTxtDropTrophy)) >= Number($g_asLeagueDetails[16][4]) Then
			GUICtrlSetData($g_hLblMinTrophies, "2")
		ElseIf Number(GUICtrlRead($g_hTxtDropTrophy)) >= Number($g_asLeagueDetails[15][4]) Then
			GUICtrlSetData($g_hLblMinTrophies, "3")
		EndIf
	ElseIf Number(GUICtrlRead($g_hTxtDropTrophy)) >= Number($g_asLeagueDetails[12][4]) Then
		GUICtrlSetState($g_hPicMinTrophies[$eLeagueMaster], $GUI_SHOW)
		If Number(GUICtrlRead($g_hTxtDropTrophy)) >= Number($g_asLeagueDetails[14][4]) Then
			GUICtrlSetData($g_hLblMinTrophies, "1")
		ElseIf Number(GUICtrlRead($g_hTxtDropTrophy)) >= Number($g_asLeagueDetails[13][4]) Then
			GUICtrlSetData($g_hLblMinTrophies, "2")
		ElseIf Number(GUICtrlRead($g_hTxtDropTrophy)) >= Number($g_asLeagueDetails[12][4]) Then
			GUICtrlSetData($g_hLblMinTrophies, "3")
		EndIf
	ElseIf Number(GUICtrlRead($g_hTxtDropTrophy)) >= Number($g_asLeagueDetails[9][4]) Then
		GUICtrlSetState($g_hPicMinTrophies[$eLeagueCrystal], $GUI_SHOW)
		If Number(GUICtrlRead($g_hTxtDropTrophy)) >= Number($g_asLeagueDetails[11][4]) Then
			GUICtrlSetData($g_hLblMinTrophies, "1")
		ElseIf Number(GUICtrlRead($g_hTxtDropTrophy)) >= Number($g_asLeagueDetails[10][4]) Then
			GUICtrlSetData($g_hLblMinTrophies, "2")
		ElseIf Number(GUICtrlRead($g_hTxtDropTrophy)) >= Number($g_asLeagueDetails[9][4]) Then
			GUICtrlSetData($g_hLblMinTrophies, "3")
		EndIf
	ElseIf Number(GUICtrlRead($g_hTxtDropTrophy)) >= Number($g_asLeagueDetails[6][4]) Then
		GUICtrlSetState($g_hPicMinTrophies[$eLeagueGold], $GUI_SHOW)
		If Number(GUICtrlRead($g_hTxtDropTrophy)) >= Number($g_asLeagueDetails[8][4]) Then
			GUICtrlSetData($g_hLblMinTrophies, "1")
		ElseIf Number(GUICtrlRead($g_hTxtDropTrophy)) >= Number($g_asLeagueDetails[7][4]) Then
			GUICtrlSetData($g_hLblMinTrophies, "2")
		ElseIf Number(GUICtrlRead($g_hTxtDropTrophy)) >= Number($g_asLeagueDetails[6][4]) Then
			GUICtrlSetData($g_hLblMinTrophies, "3")
		EndIf
	ElseIf Number(GUICtrlRead($g_hTxtDropTrophy)) >= Number($g_asLeagueDetails[3][4]) Then
		GUICtrlSetState($g_hPicMinTrophies[$eLeagueSilver], $GUI_SHOW)
		If Number(GUICtrlRead($g_hTxtDropTrophy)) >= Number($g_asLeagueDetails[5][4]) Then
			GUICtrlSetData($g_hLblMinTrophies, "1")
		ElseIf Number(GUICtrlRead($g_hTxtDropTrophy)) >= Number($g_asLeagueDetails[4][4]) Then
			GUICtrlSetData($g_hLblMinTrophies, "2")
		ElseIf Number(GUICtrlRead($g_hTxtDropTrophy)) >= Number($g_asLeagueDetails[3][4]) Then
			GUICtrlSetData($g_hLblMinTrophies, "3")
		EndIf
	ElseIf Number(GUICtrlRead($g_hTxtDropTrophy)) >= Number($g_asLeagueDetails[0][4]) Then
		GUICtrlSetState($g_hPicMinTrophies[$eLeagueBronze], $GUI_SHOW)
		If Number(GUICtrlRead($g_hTxtDropTrophy)) >= Number($g_asLeagueDetails[2][4]) Then
			GUICtrlSetData($g_hLblMinTrophies, "1")
		ElseIf Number(GUICtrlRead($g_hTxtDropTrophy)) >= Number($g_asLeagueDetails[1][4]) Then
			GUICtrlSetData($g_hLblMinTrophies, "2")
		ElseIf Number(GUICtrlRead($g_hTxtDropTrophy)) >= Number($g_asLeagueDetails[0][4]) Then
			GUICtrlSetData($g_hLblMinTrophies, "3")
		EndIf
	Else
		GUICtrlSetState($g_hPicMinTrophies[$eLeagueUnranked], $GUI_SHOW)
		GUICtrlSetData($g_hLblMinTrophies, "")
	EndIf
EndFunc   ;==>TxtDropTrophy

Func TxtMaxTrophy()
	If Number(GUICtrlRead($g_hTxtDropTrophy)) > Number(GUICtrlRead($g_hTxtMaxTrophy)) Then
		GUICtrlSetData($g_hTxtMaxTrophy, GUICtrlRead($g_hTxtDropTrophy))
	EndIf
	_GUI_Value_STATE("HIDE", $g_aGroupListPicMaxTrophy)
	If Number(GUICtrlRead($g_hTxtMaxTrophy)) >= Number($g_asLeagueDetails[21][4]) Then
		GUICtrlSetState($g_hPicMaxTrophies[$eLeagueLegend], $GUI_SHOW)
		GUICtrlSetData($g_hLblMaxTrophies, "")
	ElseIf Number(GUICtrlRead($g_hTxtMaxTrophy)) >= Number($g_asLeagueDetails[18][4]) Then
		GUICtrlSetState($g_hPicMaxTrophies[$eLeagueTitan], $GUI_SHOW)
		If Number(GUICtrlRead($g_hTxtMaxTrophy)) >= Number($g_asLeagueDetails[20][4]) Then
			GUICtrlSetData($g_hLblMaxTrophies, "1")
		ElseIf Number(GUICtrlRead($g_hTxtMaxTrophy)) >= Number($g_asLeagueDetails[19][4]) Then
			GUICtrlSetData($g_hLblMaxTrophies, "2")
		ElseIf Number(GUICtrlRead($g_hTxtMaxTrophy)) >= Number($g_asLeagueDetails[18][4]) Then
			GUICtrlSetData($g_hLblMaxTrophies, "3")
		EndIf
	ElseIf Number(GUICtrlRead($g_hTxtMaxTrophy)) >= Number($g_asLeagueDetails[15][4]) Then
		GUICtrlSetState($g_hPicMaxTrophies[$eLeagueChampion], $GUI_SHOW)
		If Number(GUICtrlRead($g_hTxtMaxTrophy)) >= Number($g_asLeagueDetails[17][4]) Then
			GUICtrlSetData($g_hLblMaxTrophies, "1")
		ElseIf Number(GUICtrlRead($g_hTxtMaxTrophy)) >= Number($g_asLeagueDetails[16][4]) Then
			GUICtrlSetData($g_hLblMaxTrophies, "2")
		ElseIf Number(GUICtrlRead($g_hTxtMaxTrophy)) >= Number($g_asLeagueDetails[15][4]) Then
			GUICtrlSetData($g_hLblMaxTrophies, "3")
		EndIf
	ElseIf Number(GUICtrlRead($g_hTxtMaxTrophy)) >= Number($g_asLeagueDetails[12][4]) Then
		GUICtrlSetState($g_hPicMaxTrophies[$eLeagueMaster], $GUI_SHOW)
		If Number(GUICtrlRead($g_hTxtMaxTrophy)) >= Number($g_asLeagueDetails[14][4]) Then
			GUICtrlSetData($g_hLblMaxTrophies, "1")
		ElseIf Number(GUICtrlRead($g_hTxtMaxTrophy)) >= Number($g_asLeagueDetails[13][4]) Then
			GUICtrlSetData($g_hLblMaxTrophies, "2")
		ElseIf Number(GUICtrlRead($g_hTxtMaxTrophy)) >= Number($g_asLeagueDetails[12][4]) Then
			GUICtrlSetData($g_hLblMaxTrophies, "3")
		EndIf
	ElseIf Number(GUICtrlRead($g_hTxtMaxTrophy)) >= Number($g_asLeagueDetails[9][4]) Then
		GUICtrlSetState($g_hPicMaxTrophies[$eLeagueCrystal], $GUI_SHOW)
		If Number(GUICtrlRead($g_hTxtMaxTrophy)) >= Number($g_asLeagueDetails[11][4]) Then
			GUICtrlSetData($g_hLblMaxTrophies, "1")
		ElseIf Number(GUICtrlRead($g_hTxtMaxTrophy)) >= Number($g_asLeagueDetails[10][4]) Then
			GUICtrlSetData($g_hLblMaxTrophies, "2")
		ElseIf Number(GUICtrlRead($g_hTxtMaxTrophy)) >= Number($g_asLeagueDetails[9][4]) Then
			GUICtrlSetData($g_hLblMaxTrophies, "3")
		EndIf
	ElseIf Number(GUICtrlRead($g_hTxtMaxTrophy)) >= Number($g_asLeagueDetails[6][4]) Then
		GUICtrlSetState($g_hPicMaxTrophies[$eLeagueGold], $GUI_SHOW)
		If Number(GUICtrlRead($g_hTxtMaxTrophy)) >= Number($g_asLeagueDetails[8][4]) Then
			GUICtrlSetData($g_hLblMaxTrophies, "1")
		ElseIf Number(GUICtrlRead($g_hTxtMaxTrophy)) >= Number($g_asLeagueDetails[7][4]) Then
			GUICtrlSetData($g_hLblMaxTrophies, "2")
		ElseIf Number(GUICtrlRead($g_hTxtMaxTrophy)) >= Number($g_asLeagueDetails[6][4]) Then
			GUICtrlSetData($g_hLblMaxTrophies, "3")
		EndIf
	ElseIf Number(GUICtrlRead($g_hTxtMaxTrophy)) >= Number($g_asLeagueDetails[3][4]) Then
		GUICtrlSetState($g_hPicMaxTrophies[$eLeagueSilver], $GUI_SHOW)
		If Number(GUICtrlRead($g_hTxtMaxTrophy)) >= Number($g_asLeagueDetails[5][4]) Then
			GUICtrlSetData($g_hLblMaxTrophies, "1")
		ElseIf Number(GUICtrlRead($g_hTxtMaxTrophy)) >= Number($g_asLeagueDetails[4][4]) Then
			GUICtrlSetData($g_hLblMaxTrophies, "2")
		ElseIf Number(GUICtrlRead($g_hTxtMaxTrophy)) >= Number($g_asLeagueDetails[3][4]) Then
			GUICtrlSetData($g_hLblMaxTrophies, "3")
		EndIf
	ElseIf Number(GUICtrlRead($g_hTxtMaxTrophy)) >= Number($g_asLeagueDetails[0][4]) Then
		GUICtrlSetState($g_hPicMaxTrophies[$eLeagueBronze], $GUI_SHOW)
		If Number(GUICtrlRead($g_hTxtMaxTrophy)) >= Number($g_asLeagueDetails[2][4]) Then
			GUICtrlSetData($g_hLblMaxTrophies, "1")
		ElseIf Number(GUICtrlRead($g_hTxtMaxTrophy)) >= Number($g_asLeagueDetails[1][4]) Then
			GUICtrlSetData($g_hLblMaxTrophies, "2")
		ElseIf Number(GUICtrlRead($g_hTxtMaxTrophy)) >= Number($g_asLeagueDetails[0][4]) Then
			GUICtrlSetData($g_hLblMaxTrophies, "3")
		EndIf
	Else
		GUICtrlSetState($g_hPicMaxTrophies[$eLeagueUnranked], $GUI_SHOW)
		GUICtrlSetData($g_hLblMaxTrophies, "")
	EndIf
EndFunc   ;==>TxtMaxTrophy

Func chkTrophyHeroes()
	If GUICtrlRead($g_hChkTrophyHeroes) = $GUI_CHECKED Or GUICtrlRead($g_hChkTrophyHeroesAndTroops) = $GUI_CHECKED Then ; Drop Throphy - Team AIO Mod++
		GUICtrlSetState($g_hLblTrophyHeroesPriority, $GUI_ENABLE)
		GUICtrlSetState($g_hCmbTrophyHeroesPriority, $GUI_ENABLE)
	Else
		GUICtrlSetState($g_hLblTrophyHeroesPriority, $GUI_DISABLE)
		GUICtrlSetState($g_hCmbTrophyHeroesPriority, $GUI_DISABLE)
	EndIf
EndFunc   ;==>chkTrophyHeroes

Func ChkCollect()
	If GUICtrlRead($g_hChkCollect) = $GUI_CHECKED Then
		GUICtrlSetState($g_hChkCollectLootCar, $GUI_ENABLE)
		GUICtrlSetState($g_hChkTreasuryCollect, $GUI_ENABLE)
		GUICtrlSetState($g_hTxtCollectGold, $GUI_ENABLE)
		GUICtrlSetState($g_hTxtCollectElixir, $GUI_ENABLE)
		GUICtrlSetState($g_hTxtCollectDark, $GUI_ENABLE)
		GUICtrlSetState($g_hChkResourcePotion, $GUI_ENABLE) ; Magic items - Team AIO Mod++
	Else
		GUICtrlSetState($g_hChkCollectLootCar, $GUI_UNCHECKED)
		GUICtrlSetState($g_hChkCollectLootCar, $GUI_DISABLE)
		GUICtrlSetState($g_hChkTreasuryCollect, $GUI_UNCHECKED)
		GUICtrlSetState($g_hChkTreasuryCollect, $GUI_DISABLE)
		GUICtrlSetState($g_hTxtCollectGold, $GUI_DISABLE)
		GUICtrlSetState($g_hTxtCollectElixir, $GUI_DISABLE)
		GUICtrlSetState($g_hTxtCollectDark, $GUI_DISABLE)
		GUICtrlSetState($g_hChkResourcePotion, $GUI_UNCHECKED) ; Magic items - Team AIO Mod++
	EndIf
	ChkTreasuryCollect()
	ChkResourcePotion() ; Magic items - Team AIO Mod++
EndFunc   ;==>ChkCollect

; Magic items - Team AIO Mod++
Func ChkResourcePotion()
	$g_bChkResourcePotion = (GUICtrlRead($g_hChkResourcePotion) = $GUI_CHECKED)
	For $h = $g_hInputGoldItems To $g_hInputDarkElixirItems
		GUICtrlSetState($h, ($g_bChkResourcePotion = True) ? ($GUI_ENABLE) : ($GUI_DISABLE))
	Next
EndFunc   ;==>ConfigRefresh

Func ChkTreasuryCollect()
	If GUICtrlRead($g_hChkTreasuryCollect) = $GUI_CHECKED Then
		GUICtrlSetState($g_hTxtTreasuryGold, $GUI_ENABLE)
		GUICtrlSetState($g_hTxtTreasuryElixir, $GUI_ENABLE)
		GUICtrlSetState($g_hTxtTreasuryDark, $GUI_ENABLE)
	Else
		GUICtrlSetState($g_hTxtTreasuryGold, $GUI_DISABLE)
		GUICtrlSetState($g_hTxtTreasuryElixir, $GUI_DISABLE)
		GUICtrlSetState($g_hTxtTreasuryDark, $GUI_DISABLE)
	EndIf
EndFunc   ;==>ChkTreasuryCollect

#Region - Custom fix - Team AIO MOD++
Func ChkCollectRewards()
	If GUICtrlRead($g_hChkCollectRewards) = $GUI_CHECKED Then
		GUICtrlSetState($g_hChkSellRewards, $GUI_ENABLE)
	Else
		GUICtrlSetState($g_hChkSellRewards, $GUI_DISABLE)
	EndIf
EndFunc   ;==>ChkCollectRewards
#EndRegion - Custom fix - Team AIO MOD++

#CS - AIO MOD++
Func ChkFreeMagicItems()
	If $g_iTownHallLevel >= 8 Or $g_iTownHallLevel = 0 Then ; Must be Th8 or more to use the Trader
		GUICtrlSetState($g_hChkFreeMagicItems, $GUI_ENABLE)
	Else
		GUICtrlSetState($g_hChkFreeMagicItems, BitOR($GUI_DISABLE, $GUI_UNCHECKED))
	EndIf
EndFunc   ;==>ChkFreeMagicItems

Func chkStartClockTowerBoost()
	If GUICtrlRead($g_hChkStartClockTowerBoost) = $GUI_CHECKED Then
		GUICtrlSetState($g_hChkCTBoostBlderBz, $GUI_ENABLE)
	Else
		GUICtrlSetState($g_hChkCTBoostBlderBz, $GUI_DISABLE)
	EndIf
EndFunc   ;==>chkStartClockTowerBoost
#CE - AIO MOD++

#Region - xbebenk - Clan Games
Func chkActivateClangames()
	If GUICtrlRead($g_hChkClanGamesEnabled) = $GUI_CHECKED Then
		GUICtrlSetState($g_hChkClanGames60, $GUI_ENABLE)
		GUICtrlSetState($g_hChkClanGamesDebug, $GUI_ENABLE)

		GUICtrlSetState($g_hChkClanGamesLoot, $GUI_ENABLE)
		GUICtrlSetState($g_hChkClanGamesBattle, $GUI_ENABLE)
		GUICtrlSetState($g_hChkClanGamesDes, $GUI_ENABLE)
		If GUICtrlRead($g_hChkClanGamesDes) = $GUI_CHECKED Then
			GUICtrlSetState($g_hBtnCGDes, $GUI_ENABLE)
		Else
			GUICtrlSetState($g_hBtnCGDes, $GUI_DISABLE)
		EndIf

		GUICtrlSetState($g_hChkClanGamesAirTroop, $GUI_ENABLE)
		If GUICtrlRead($g_hChkClanGamesAirTroop) = $GUI_CHECKED Then
			GUICtrlSetState($g_hBtnCGAirTroop, $GUI_ENABLE)
		Else
			GUICtrlSetState($g_hBtnCGAirTroop, $GUI_DISABLE)
		EndIf

		GUICtrlSetState($g_hChkClanGamesGroundTroop, $GUI_ENABLE)
		If GUICtrlRead($g_hChkClanGamesGroundTroop) = $GUI_CHECKED Then
			GUICtrlSetState($g_hBtnCGGroundTroop, $GUI_ENABLE)
		Else
			GUICtrlSetState($g_hBtnCGGroundTroop, $GUI_DISABLE)
		EndIf

		GUICtrlSetState($g_hChkClanGamesBBTroops, $GUI_ENABLE)
		If GUICtrlRead($g_hChkClanGamesBBTroops) = $GUI_CHECKED Then
			GUICtrlSetState($g_hBtnCGBBTroop, $GUI_ENABLE)
		Else
			GUICtrlSetState($g_hBtnCGBBTroop, $GUI_DISABLE)
		EndIf

		GUICtrlSetState($g_hChkClanGamesMiscellaneous, $GUI_ENABLE)
		GUICtrlSetState($g_hChkClanGamesSpell, $GUI_ENABLE)
		If GUICtrlRead($g_hChkClanGamesSpell) = $GUI_CHECKED Then
			GUICtrlSetState($g_hBtnCGSpell, $GUI_ENABLE)
		Else
			GUICtrlSetState($g_hBtnCGSpell, $GUI_DISABLE)
		EndIf

		GUICtrlSetState($g_hChkClanGamesBBBattle, $GUI_ENABLE)
		GUICtrlSetState($g_hChkClanGamesBBDes, $GUI_ENABLE)
		If GUICtrlRead($g_hChkClanGamesBBDes) = $GUI_CHECKED Then
			GUICtrlSetState($g_hBtnCGBBDes, $GUI_ENABLE)
		Else
			GUICtrlSetState($g_hBtnCGBBDes, $GUI_DISABLE)
		EndIf
		GUICtrlSetState($g_hChkForceBBAttackOnClanGames, $GUI_ENABLE)
		GUICtrlSetState($g_hChkClanGamesPurgeAny, $GUI_ENABLE)

		GUICtrlSetState($g_hChkClanGamesStopBeforeReachAndPurge, $GUI_ENABLE)

		GUICtrlSetState($g_hChkOnlyBuilderBaseGC, $GUI_ENABLE)

	Else
		GUICtrlSetState($g_hChkClanGames60, $GUI_DISABLE)
		GUICtrlSetState($g_hChkClanGamesDebug, $GUI_DISABLE)

		GUICtrlSetState($g_hChkClanGamesLoot, $GUI_DISABLE)
		GUICtrlSetState($g_hChkClanGamesBattle, $GUI_DISABLE)
		GUICtrlSetState($g_hChkClanGamesDes, $GUI_DISABLE)
		GUICtrlSetState($g_hChkClanGamesAirTroop, $GUI_DISABLE)
		GUICtrlSetState($g_hChkClanGamesGroundTroop, $GUI_DISABLE)
		GUICtrlSetState($g_hChkClanGamesMiscellaneous, $GUI_DISABLE)

		GUICtrlSetState($g_hChkClanGamesSpell, $GUI_DISABLE)
		GUICtrlSetState($g_hChkClanGamesBBBattle, $GUI_DISABLE)
		GUICtrlSetState($g_hChkClanGamesBBDes, $GUI_DISABLE)
		GUICtrlSetState($g_hChkClanGamesBBTroops, $GUI_DISABLE)
		GUICtrlSetState($g_hChkForceBBAttackOnClanGames, $GUI_DISABLE)
		GUICtrlSetState($g_hChkClanGamesPurgeAny, $GUI_DISABLE)

		GUICtrlSetState($g_hChkClanGamesStopBeforeReachAndPurge, $GUI_DISABLE)
		GUICtrlSetState($g_hBtnCGBBTroop, $GUI_DISABLE)
		GUICtrlSetState($g_hBtnCGGroundTroop, $GUI_DISABLE)
		GUICtrlSetState($g_hBtnCGDes, $GUI_DISABLE)
		GUICtrlSetState($g_hBtnCGAirTroop, $GUI_DISABLE)
		GUICtrlSetState($g_hBtnCGSpell, $GUI_DISABLE)
		GUICtrlSetState($g_hChkOnlyBuilderBaseGC, $GUI_DISABLE)
	EndIf
	chkClanGamesBB()
EndFunc   ;==>chkActivateClangames

; Purging doesnt exist if we want BB challneges, because they are all attack basically... This avoids potential conflicts in code and logic if both are selected
Func chkClanGamesBB()

	Local $bBBChallenges = (GUICtrlRead($g_hChkClanGamesBBBattle) = $GUI_CHECKED Or GUICtrlRead($g_hChkClanGamesBBDes) = $GUI_CHECKED Or GUICtrlRead($g_hChkClanGamesBBTroops) = $GUI_CHECKED)


	If GUICtrlRead($g_hChkClanGamesEnabled) = $GUI_CHECKED Then

		If $bBBChallenges = True Then
			GUICtrlSetState($g_hChkForceBBAttackOnClanGames, $GUI_ENABLE)
			GUICtrlSetState($g_hChkOnlyBuilderBaseGC, $GUI_ENABLE)
		Else
			; GUICtrlSetState($g_hChkForceBBAttackOnClanGames, $GUI_DISABLE + $GUI_UNCHECKED)
			; GUICtrlSetState($g_hChkOnlyBuilderBaseGC, $GUI_DISABLE + $GUI_UNCHECKED)
			GUICtrlSetState($g_hChkForceBBAttackOnClanGames, $GUI_DISABLE)
			GUICtrlSetState($g_hChkOnlyBuilderBaseGC, $GUI_DISABLE)
		EndIf

		; If GUICtrlRead($g_hChkForceBBAttackOnClanGames) = $GUI_CHECKED Then
			; $g_bChkForceBBAttackOnClanGames = True
		; Else
			; $g_bChkForceBBAttackOnClanGames = False
		; EndIf

		; If GUICtrlRead($g_hChkOnlyBuilderBaseGC) = $GUI_CHECKED Then
			; $g_bChkOnlyBuilderBaseGC = True
		; Else
			; $g_bChkOnlyBuilderBaseGC = False
		; EndIf
	; Else
		; $g_bChkForceBBAttackOnClanGames = False
		; $g_bChkOnlyBuilderBaseGC = False
	EndIf
EndFunc

Func btnCGDes()
	GUISetState(@SW_SHOW, $g_hGUI_CGDes)
EndFunc

Func CloseCGDes()
	GUISetState(@SW_HIDE, $g_hGUI_CGDes)
EndFunc

Func btnCGAirTroops()
	GUISetState(@SW_SHOW, $g_hGUI_CGAirTroops)
EndFunc

Func CloseCGAirTroops()
	GUISetState(@SW_HIDE, $g_hGUI_CGAirTroops)
EndFunc

Func btnCGGroundTroops()
 	GUISetState(@SW_SHOW, $g_hGUI_CGGroundTroops)
EndFunc

Func CloseCGGroundTroops()
 	GUISetState(@SW_HIDE, $g_hGUI_CGGroundTroops)
EndFunc

Func btnCGSpells()
	GUISetState(@SW_SHOW, $g_hGUI_CGSpells)
EndFunc

Func CloseCGSpells()
	GUISetState(@SW_HIDE, $g_hGUI_CGSpells)
EndFunc

Func btnCGBBDes()
	GUISetState(@SW_SHOW, $g_hGUI_CGBBDes)
EndFunc

Func CloseCGBBDes()
	GUISetState(@SW_HIDE, $g_hGUI_CGBBDes)
EndFunc

Func btnCGBBTroops()
	GUISetState(@SW_SHOW, $g_hGUI_CGBBTroops)
EndFunc

Func CloseCGBBTroops()
	GUISetState(@SW_HIDE, $g_hGUI_CGBBTroops)
EndFunc
#EndRegion - xbebenk - Clan Games

Func chkEnableBBAttack()
	;If GUICtrlRead($g_hChkEnableBBAttack) = $GUI_CHECKED Then
	GUICtrlSetState($g_hChkBBTrophyRange, $GUI_ENABLE)
	GUICtrlSetState($g_hChkBBAttIfLootAvail, $GUI_ENABLE)
	; GUICtrlSetState($g_hChkBBWaitForMachine, $GUI_ENABLE)
	GUICtrlSetState($g_hBtnBBDropOrder, $GUI_ENABLE)
	GUICtrlSetState($g_hCmbBBSameTroopDelay, $GUI_ENABLE)
	GUICtrlSetState($g_hCmbBBNextTroopDelay, $GUI_ENABLE)
	chkBBTrophyRange()
	;Else
	;	GUICtrlSetState($g_hChkBBTrophyRange, $GUI_DISABLE)
	;	GUICtrlSetState($g_hChkBBAttIfLootAvail, $GUI_DISABLE)
	;	GUICtrlSetState($g_hTxtBBTrophyLowerLimit, $GUI_DISABLE)
	;	GUICtrlSetState($g_hTxtBBTrophyUpperLimit, $GUI_DISABLE)
	;	GUICtrlSetState($g_hChkBBWaitForMachine, $GUI_DISABLE)
	;	GUICtrlSetState($g_hBtnBBDropOrder, $GUI_DISABLE)
	;	GUICtrlSetState($g_hCmbBBSameTroopDelay, $GUI_DISABLE)
	;	GUICtrlSetState($g_hCmbBBNextTroopDelay, $GUI_DISABLE)
	;EndIf
EndFunc   ;==>chkEnableBBAttack

Func cmbBBNextTroopDelay()
	$g_iBBNextTroopDelay = $g_iBBNextTroopDelayDefault + ((_GUICtrlComboBox_GetCurSel($g_hCmbBBNextTroopDelay) + 1) - 5) * $g_iBBNextTroopDelayIncrement ; +- n*increment
	SetDebugLog("Next Troop Delay: " & $g_iBBNextTroopDelay)
	SetDebugLog((_GUICtrlComboBox_GetCurSel($g_hCmbBBNextTroopDelay) + 1) - 5)
EndFunc   ;==>cmbBBNextTroopDelay

Func cmbBBSameTroopDelay()
	$g_iBBSameTroopDelay = $g_iBBSameTroopDelayDefault + ((_GUICtrlComboBox_GetCurSel($g_hCmbBBSameTroopDelay) + 1) - 5) * $g_iBBSameTroopDelayIncrement ; +- n*increment
	SetDebugLog("Same Troop Delay: " & $g_iBBSameTroopDelay)
	SetDebugLog((_GUICtrlComboBox_GetCurSel($g_hCmbBBSameTroopDelay) + 1) - 5)
EndFunc   ;==>cmbBBSameTroopDelay

Func chkBBTrophyRange()
	If GUICtrlRead($g_hChkBBTrophyRange) = $GUI_CHECKED Then
		GUICtrlSetState($g_hTxtBBTrophyLowerLimit, $GUI_ENABLE)
		GUICtrlSetState($g_hTxtBBTrophyUpperLimit, $GUI_ENABLE)
	Else
		GUICtrlSetState($g_hTxtBBTrophyLowerLimit, $GUI_DISABLE)
		GUICtrlSetState($g_hTxtBBTrophyUpperLimit, $GUI_DISABLE)
	EndIf
EndFunc   ;==>chkBBTrophyRange

Func btnBBDropOrder()
	GUICtrlSetState($g_hBtnBBDropOrder, $GUI_DISABLE)
	GUICtrlSetState($g_hChkEnableBBAttack, $GUI_DISABLE)
	GUISetState(@SW_SHOW, $g_hGUI_BBDropOrder)
EndFunc   ;==>btnBBDropOrder

Func chkBBDropOrder()
	If GUICtrlRead($g_hChkBBCustomDropOrderEnable) = $GUI_CHECKED Then
		GUICtrlSetState($g_hBtnBBDropOrderSet, $GUI_ENABLE)
		GUICtrlSetState($g_hBtnBBRemoveDropOrder, $GUI_ENABLE)
		For $i = 0 To $g_iBBTroopCount - 1
			GUICtrlSetState($g_ahCmbBBDropOrder[$i], $GUI_ENABLE)
		Next
	Else
		GUICtrlSetState($g_hBtnBBDropOrderSet, $GUI_DISABLE)
		GUICtrlSetState($g_hBtnBBRemoveDropOrder, $GUI_DISABLE)
		For $i = 0 To $g_iBBTroopCount - 1
			GUICtrlSetState($g_ahCmbBBDropOrder[$i], $GUI_DISABLE)
		Next
		GUICtrlSetBkColor($g_hBtnBBDropOrder, $COLOR_RED)
		$g_bBBDropOrderSet = False
	EndIf
EndFunc   ;==>chkBBDropOrder

#Region - Custom BB Army - Team AIO Mod++
Func GUIBBDropOrder()
	Local $iGUI_CtrlId = @GUI_CtrlId
	Local $iDropIndex = _GUICtrlComboBox_GetCurSel($iGUI_CtrlId)
	Setlog($iDropIndex)
	For $i = 0 To $g_iBBTroopCount - 1
		If $iGUI_CtrlId = $g_ahCmbBBDropOrder[$i] Then
			_GUICtrlSetImage($g_sIcnBBOrder[$i], $g_sLibIconPath, $g_avStarLabTroops[$iDropIndex + 1][4])
		ElseIf $iDropIndex = _GUICtrlComboBox_GetCurSel($g_ahCmbBBDropOrder[$i]) Then
			_GUICtrlComboBox_SetCurSel($g_ahCmbBBDropOrder[$i], -1)
			_GUICtrlSetImage($g_sIcnBBOrder[$i], $g_sLibIconPath, $g_avStarLabTroops[0][4])
			GUISetState()
		EndIf
	Next
EndFunc   ;==>GUIBBDropOrder

Func GUIBBCustomArmy()
	Local $iGUI_CtrlId = @GUI_CtrlId
	Local $iDropIndex = _GUICtrlComboBox_GetCurSel($iGUI_CtrlId)

	For $i = 0 To UBound($g_hComboTroopBB) - 1
		If $iGUI_CtrlId = $g_hComboTroopBB[$i] Then
			_GUICtrlSetImage($g_hIcnTroopBB[$i], $g_sLibIconPath, $g_avStarLabTroops[$iDropIndex + 1][4])
			$g_iCmbCampsBB[$i] = $iDropIndex
		EndIf
	Next
EndFunc   ;==>GUIBBCustomArmy

#EndRegion - Custom BB Army - Team AIO Mod++

Func BtnBBDropOrderSet()
	$g_sBBDropOrder = ""
	; loop through reading and disabling all combo boxes
	For $i = 0 To $g_iBBTroopCount - 1
		GUICtrlSetState($g_ahCmbBBDropOrder[$i], $GUI_DISABLE)
		If GUICtrlRead($g_ahCmbBBDropOrder[$i]) = "" Then ; if not picked assign from default list in order
			Local $asDefaultOrderSplit = StringSplit($g_sBBDropOrderDefault, "|")
			Local $bFound = False, $bSet = False
			Local $j = 0
			While $j < $g_iBBTroopCount And Not $bSet ; loop through troops
				Local $k = 0
				While $k < $g_iBBTroopCount And Not $bFound ; loop through handles
					If $g_ahCmbBBDropOrder[$i] <> $g_ahCmbBBDropOrder[$k] Then
						SetDebugLog("Word: " & $asDefaultOrderSplit[$j + 1] & " " & " Word in slot: " & GUICtrlRead($g_ahCmbBBDropOrder[$k]))
						If $asDefaultOrderSplit[$j + 1] = GUICtrlRead($g_ahCmbBBDropOrder[$k]) Then $bFound = True
					EndIf
					$k += 1
				WEnd
				If Not $bFound Then
					_GUICtrlComboBox_SetCurSel($g_ahCmbBBDropOrder[$i], $j)
					$bSet = True
				Else
					$j += 1
					$bFound = False
				EndIf
			WEnd
		EndIf
		$g_sBBDropOrder &= (GUICtrlRead($g_ahCmbBBDropOrder[$i]) & "|")
		SetDebugLog("DropOrder: " & $g_sBBDropOrder)
		_GUICtrlSetImage($g_sIcnBBOrder[$i], $g_sLibIconPath, $g_avStarLabTroops[_GUICtrlComboBox_GetCurSel($g_ahCmbBBDropOrder[$i]) + 1][4])
	Next
	$g_sBBDropOrder = StringTrimRight($g_sBBDropOrder, 1) ; Remove last '|'
	GUICtrlSetBkColor($g_hBtnBBDropOrder, $COLOR_GREEN)
	$g_bBBDropOrderSet = True
EndFunc   ;==>BtnBBDropOrderSet

Func BtnBBRemoveDropOrder()
	For $i = 0 To $g_iBBTroopCount - 1
		_GUICtrlSetImage($g_sIcnBBOrder[$i], $g_sLibIconPath, $g_avStarLabTroops[0][4])     ; Custom BB Army - Team AIO Mod++
		_GUICtrlComboBox_SetCurSel($g_ahCmbBBDropOrder[$i], -1)
		GUICtrlSetState($g_ahCmbBBDropOrder[$i], $GUI_ENABLE)
	Next
	GUICtrlSetBkColor($g_hBtnBBDropOrder, $COLOR_RED)
	$g_bBBDropOrderSet = False
EndFunc   ;==>BtnBBRemoveDropOrder

Func CloseCustomBBDropOrder()
	GUISetState(@SW_HIDE, $g_hGUI_BBDropOrder)
	GUICtrlSetState($g_hBtnBBDropOrder, $GUI_ENABLE)
	GUICtrlSetState($g_hChkEnableBBAttack, $GUI_ENABLE)
EndFunc   ;==>CloseCustomBBDropOrder
