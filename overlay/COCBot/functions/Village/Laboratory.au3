; #FUNCTION# ====================================================================================================================
; Name ..........: Laboratory
; Description ...:
; Syntax ........: Laboratory()
; Parameters ....:
; Return values .: None
; Author ........: summoner
; Modified ......: KnowJack (06/2015), Sardo (08/2015), Monkeyhunter(04/2016), MMHK(06/2018), Chilly-Chill (12/2019), xbebenk (02/2021)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Global $iSlotWidth = 94, $iDistBetweenSlots = 12 ; use for logic to upgrade troops.. good for generic-ness
Global $iYMidPoint = 468 + $g_iMidOffsetYFixed ;Space between rows in lab screen.  CHANGE ONLY WITH EXTREME CAUTION. ; Resolution changed
Global $iPicsPerPage = 12, $iPages = 4 ; used to know exactly which page the users choice is on
Global $sLabWindow = "99,78,760,572", $sLabTroopsSection = "115,319,750,533", $sLabTroopLastPage = "435,319,750,533" ; Resolution changed
;$sLabTroopLastPage for partial last page, currently 3 columns of siege machines.
Global $sLabWindowDiam = GetDiamondFromRect($sLabWindow), $sLabTroopsSectionDiam = GetDiamondFromRect($sLabTroopsSection), $sLabTroopsLastPageDiam = GetDiamondFromRect($sLabTroopLastPage) ; easy to change search areas

Func TestLaboratory()
	Local $bWasRunState = $g_bRunState
	Local $sWasLabUpgradeTime = $g_sLabUpgradeTime
	Local $sWasLabUpgradeEnable = $g_bAutoLabUpgradeEnable
	$g_bRunState = True
	$g_bAutoLabUpgradeEnable = True
	$g_sLabUpgradeTime = ""
	$g_bSilentSetDebugLog = False
	Local $Result = Laboratory(True)
	$g_bRunState = $bWasRunState
	$g_sLabUpgradeTime = $sWasLabUpgradeTime
	$g_bAutoLabUpgradeEnable = $sWasLabUpgradeEnable
	Return $Result
EndFunc   ;==>TestLaboratory

; Credits for xbenk (xbebenk)
#Region - Magic Items - Team AIO Mod++
Func Laboratory($bDebug = False)
	If Not $g_bAutoLabUpgradeEnable And Not $g_bChkLabPotion Then Return ; Lab upgrade not enabled.

	Local $bChkUpgradeInProgress = ChkUpgradeInProgress()

	If $g_iTownHallLevel < 3 Then
		SetLog("Townhall Lvl " & $g_iTownHallLevel & " has no Lab.", $COLOR_ERROR)
		Return
	EndIf
	
	; Get updated village elixir and dark elixir values
	VillageReport(True, True)
	Local $bReturn = False
	If Not $bChkUpgradeInProgress Then  ; see if we know about an upgrade in progress without checking the lab

		If FindResearchButton() Then ; cant start becuase we cannot find the research button
			If _Sleep(1000) Then Return

			Local $bUpgradeInProgress = ChkLabUpgradeInProgress() ; Lab currently running skip going further

			If $g_bAutoLabUpgradeEnable And $bUpgradeInProgress = False Then
				$bReturn = _Laboratory($bDebug)
			ElseIf $bUpgradeInProgress = False Then
				ClickAway()
				If _Sleep(500) Then Return
			EndIf
		EndIf

	EndIf

	If $g_bChkLabPotion = True Then
		LabPotionBoost($bDebug)
	EndIf

	ClickAway()
	Return $bReturn
EndFunc   ;==>Laboratory
#EndRegion - Magic Items - Team AIO Mod++

Func _Laboratory($debug = False)

	; Lab upgrade is not in progress and not upgrading, so we need to start an upgrade.
	Local $iCurPage = 1
	Local $sCostResult

	; user made a specific choice of lab upgrade
	If $g_iCmbLaboratory <> 0 Then
		SetDebugLog("User picked to upgrade " & $g_avLabTroops[$g_iCmbLaboratory][0])
		Local $iPage = Ceiling($g_iCmbLaboratory / $iPicsPerPage) ; page # of user choice
		While ($iCurPage < $iPage) ; go directly to the needed page
			LabNextPage($iCurPage, $iPages, $iYMidPoint) ; go to next page of upgrades
			$iCurPage += 1 ; Next page
			If _Sleep(2000) Then Return
		WEnd
		SetDebugLog("On page " & $iCurPage & " of " & $iPages)
		; Get coords of upgrade the user wants
		If $iCurPage >= $iPages Then ;Use last partial page
			SetDebugLog("Finding on last page diamond")
			Local $aPageUpgrades = findMultiple($g_sImgLabResearch, $sLabTroopsLastPageDiam, $sLabTroopsLastPageDiam, 0, 1000, 0, "objectname,objectpoints", True) ; Returns $aCurrentTroops[index] = $aArray[2] = ["TroopShortName", CordX,CordY]
		Else ;Use full page
			Local $aPageUpgrades = findMultiple($g_sImgLabResearch, $sLabTroopsSectionDiam, $sLabTroopsSectionDiam, 0, 1000, 0, "objectname,objectpoints", True) ; Returns $aCurrentTroops[index] = $aArray[2] = ["TroopShortName", CordX,CordY]
		EndIf
		Local $aCoords, $bUpgradeFound = False
		If UBound($aPageUpgrades, 1) >= 1 Then  ; if we found any troops
			For $i = 0 To UBound($aPageUpgrades, 1) - 1  ; Loop through found upgrades
				Local $aTempTroopArray = $aPageUpgrades[$i]     ; Declare Array to Temp Array

				If $aTempTroopArray[0] = $g_avLabTroops[$g_iCmbLaboratory][2] Then     ; if this is the file we want
					$aCoords = decodeSingleCoord($aTempTroopArray[1])
					$bUpgradeFound = True
					ExitLoop
				EndIf
				If _Sleep($DELAYLABORATORY2) Then Return
			Next
		EndIf

		If Not $bUpgradeFound Then
			SetLog("Lab Upgrade " & $g_avLabTroops[$g_iCmbLaboratory][0] & " - Not available.", $COLOR_INFO)
			$g_iCmbLaboratory = 0     ;set lab upgrade to any
			Return False
		EndIf

		If $bUpgradeFound Then
			Local $LabZero = decodeSingleCoord(findImage("Zero", $g_sImgLabZero & "LabZero*", GetDiamondFromRect($aCoords[0] - 40 & "," & $aCoords[1] & "," & $aCoords[0] + 40 & "," & $aCoords[1] + 80), 1, True, Default))
			If UBound($LabZero) > 1 Then
				Return LaboratoryUpgrade($g_avLabTroops[$g_iCmbLaboratory][0], $aCoords, $sCostResult, $debug)     ; return whether or not we successfully upgraded
			Else
				Local $LabUpgradeRequired = decodeSingleCoord(findImage("LabUpgradeRequired", $g_sImgLabZero & "Required*", GetDiamondFromRect($aCoords[0] - 40 & "," & $aCoords[1] & "," & $aCoords[0] + 40 & "," & $aCoords[1] + 80), 1, True, Default))
				If UBound($LabUpgradeRequired) > 1 Then
					SetLog("Lab Upgrade " & $g_avLabTroops[$g_iCmbLaboratory][0] & " - Max Level. Choose another upgrade.", $COLOR_INFO)
				Else
					SetLog("Lab Upgrade " & $g_avLabTroops[$g_iCmbLaboratory][0] & " - Not enough Resources." & @CRLF & "We will try again later.", $COLOR_INFO)
					Return False
				EndIf
			EndIf
		EndIf
	Else     ; users choice is any upgrade
		If $g_bLabUpgradeOrderEnable Then
			Local $iPriority = 0
			Local $iTmpTroop = 0
			For $z = 0 To UBound($g_aCmbLabUpgradeOrder) - 1     ; list of lab upgrade order
				$iTmpTroop = $g_aCmbLabUpgradeOrder[$z] + 1
				If $iTmpTroop <> 0 Then
					$iPriority = $z + 1
					SetLog("Priority order " & $iPriority & " : " & $g_avLabTroops[$iTmpTroop][0], $COLOR_SUCCESS)
				EndIf
			Next
			For $z = 0 To UBound($g_aCmbLabUpgradeOrder) - 1     ;try labupgrade based on order
				$g_iCmbLaboratory = $g_aCmbLabUpgradeOrder[$z] + 1
				If $g_iCmbLaboratory <> 0 Then
					SetLog("Try Lab Upgrade :" & $g_avLabTroops[$g_iCmbLaboratory][0], $COLOR_DEBUG)
					Local $iPage = Ceiling($g_iCmbLaboratory / $iPicsPerPage)     ; page # of user choice
					While ($iCurPage < $iPage)    ; go directly to the needed page
						LabNextPage($iCurPage, $iPages, $iYMidPoint)     ; go to next page of upgrades
						$iCurPage += 1     ; Next page
						If _Sleep(2000) Then Return
					WEnd

					; Get coords of upgrade the user wants
					Local $aPageUpgrades = findMultiple($g_sImgLabResearch, $sLabTroopsSectionDiam, $sLabTroopsSectionDiam, 0, 1000, 0, "objectname,objectpoints", True)     ; Returns $aCurrentTroops[index] = $aArray[2] = ["TroopShortName", CordX,CordY]
					Local $aCoords, $bUpgradeFound = False
					If UBound($aPageUpgrades, 1) >= 1 Then     ; if we found any troops
						For $i = 0 To UBound($aPageUpgrades, 1) - 1     ; Loop through found upgrades
							Local $aTempTroopArray = $aPageUpgrades[$i]     ; Declare Array to Temp Array

							If $aTempTroopArray[0] = $g_avLabTroops[$g_iCmbLaboratory][2] Then     ; if this is the file we want
								$aCoords = decodeSingleCoord($aTempTroopArray[1])
								$bUpgradeFound = True
								ExitLoop
							EndIf
							If _Sleep($DELAYLABORATORY2) Then Return
						Next
					EndIf

					If Not $bUpgradeFound Then
						SetLog("Lab Upgrade " & $g_avLabTroops[$g_iCmbLaboratory][0] & " - Not available.", $COLOR_INFO)
						LabPrevPage($iCurPage)
						$iCurPage = 1     ;reset current page
					EndIf

					If $bUpgradeFound Then
						Local $LabZero = decodeSingleCoord(findImage("Zero", $g_sImgLabZero & "LabZero*", GetDiamondFromRect($aCoords[0] - 40 & "," & $aCoords[1] & "," & $aCoords[0] + 40 & "," & $aCoords[1] + 80), 1, True, Default))
						If UBound($LabZero) > 1 Then
							Return LaboratoryUpgrade($g_avLabTroops[$g_iCmbLaboratory][0], $aCoords, $sCostResult, $debug)     ; return whether or not we successfully upgraded
						Else
							Local $LabUpgradeRequired = decodeSingleCoord(findImage("LabUpgradeRequired", $g_sImgLabZero & "Required*", GetDiamondFromRect($aCoords[0] - 40 & "," & $aCoords[1] & "," & $aCoords[0] + 40 & "," & $aCoords[1] + 80), 1, True, Default))
							If UBound($LabUpgradeRequired) > 1 Then
								SetLog("Lab Upgrade " & $g_avLabTroops[$g_iCmbLaboratory][0] & " - Max Level. Choose another upgrade.", $COLOR_INFO)
								LabPrevPage($iCurPage, $iYMidPoint)
								$iCurPage = 1     ;reset current page
							Else
								SetLog("Lab Upgrade " & $g_avLabTroops[$g_iCmbLaboratory][0] & " - Not enough Resources." & @CRLF & "We will try again later.", $COLOR_INFO)
								ExitLoop
							EndIf
						EndIf
					EndIf
				EndIf
			Next     ;search next

		Else ; users choice is any upgrade
			While ($iCurPage <= $iPages)
				SetDebugLog("User picked any upgrade.")
				If $iCurPage >= $iPages Then ;Use last partial page
					SetDebugLog("Finding on last page diamond")
					Local $aPageUpgrades = findMultiple($g_sImgLabResearch, $sLabTroopsLastPageDiam, $sLabTroopsLastPageDiam, 0, 1000, 0, "objectname,objectpoints", True) ; Returns $aCurrentTroops[index] = $aArray[2] = ["TroopShortName", CordX,CordY]
				Else ;Use full page
					Local $aPageUpgrades = findMultiple($g_sImgLabResearch, $sLabTroopsSectionDiam, $sLabTroopsSectionDiam, 0, 1000, 0, "objectname,objectpoints", True) ; Returns $aCurrentTroops[index] = $aArray[2] = ["TroopShortName", CordX,CordY]
				EndIf
				If UBound($aPageUpgrades, 1) >= 1 Then ; if we found any troops
					SetDebugLog("Found " & UBound($aPageUpgrades, 1) & " possible on this page #" & $iCurPage)
					For $i = 0 To UBound($aPageUpgrades, 1) - 1 ; Loop through found upgrades
						Local $aTempTroopArray = $aPageUpgrades[$i] ; Declare Array to Temp Array

						; find image slot that we found so that we can read the cost to see if we can upgrade it... slots read 1-12 top to bottom so barb = 1, arch = 2, giant = 3, etc...
						Local $aCoords = decodeSingleCoord($aTempTroopArray[1])
						Local $LabZero = decodeSingleCoord(findImage("Zero", $g_sImgLabZero & "LabZero*", GetDiamondFromRect($aCoords[0] - 40 & "," & $aCoords[1] & "," & $aCoords[0] + 40 & "," & $aCoords[1] + 80), 1, True, Default))
						If UBound($LabZero) > 1 Then
							Return LaboratoryUpgrade($g_avLabTroops[$g_iCmbLaboratory][0], $aCoords, $sCostResult, $debug)     ; return whether or not we successfully upgraded
						Else
							Local $LabUpgradeRequired = decodeSingleCoord(findImage("LabUpgradeRequired", $g_sImgLabZero & "Required*", GetDiamondFromRect($aCoords[0] - 40 & "," & $aCoords[1] & "," & $aCoords[0] + 40 & "," & $aCoords[1] + 80), 1, True, Default))
							If UBound($LabUpgradeRequired) > 1 Then
								SetLog("Lab Upgrade " & $g_avLabTroops[$g_iCmbLaboratory][0] & " - Max Level. Choose another upgrade.", $COLOR_INFO)
							Else
								SetLog("Lab Upgrade " & $g_avLabTroops[$g_iCmbLaboratory][0] & " - Not enough Resources." & @CRLF & "We will try again later.", $COLOR_INFO)
								ExitLoop
							EndIf
						EndIf
					Next
				EndIf

				LabNextPage($iCurPage, $iPages, $iYMidPoint)     ; go to next page of upgrades
				$iCurPage += 1     ; Next page
				If _Sleep($DELAYLABORATORY2) Then Return
			WEnd
		EndIf
		; If We got to here without returning, then nothing available for upgrade
		SetLog("Nothing available for upgrade at the moment, try again later.")
		Click(243, 33)
	EndIf
	Return False ; No upgrade started
EndFunc   ;==>_Laboratory

; start a given upgrade
Func LaboratoryUpgrade($name, $aCoords, $sCostResult, $debug = False)
	SetLog("Selected upgrade: " & $name & " Cost: " & $sCostResult, $COLOR_INFO)
	ClickP($aCoords) ; click troop
	If _Sleep(2000) Then Return

	LabStatusGUIUpdate()
	If $debug = True Then ; if debugging, do not actually click it
		SetLog("[debug mode] - Start Upgrade, Click (" & 660 & "," & 520 + $g_iMidOffsetY & ")", $COLOR_ACTION)
		Click(243, 33)
		Return True ; return true as if we really started an upgrade
	Else
		Click(660, 520 + $g_iMidOffsetY, 1, 0, "#0202") ; Everything is good - Click the upgrade button
		If isGemOpen(True) = False Then ; check for gem window
			; check for green button to use gems to finish upgrade, checking if upgrade actually started
			If Not (_ColorCheck(_GetPixelColor(625, 218 + $g_iMidOffsetY, True), Hex(0x6fbd1f, 6), 15) Or _ColorCheck(_GetPixelColor(660, 218 + $g_iMidOffsetY, True), Hex(0x6fbd1f, 6), 15)) Then
				SetLog("Something went wrong with " & $name & " Upgrade, try again.", $COLOR_ERROR)
				Click(243, 33)
				Return False
			EndIf

			; success
			SetLog("Upgrade " & $name & " in your laboratory started with success...", $COLOR_SUCCESS)
			PushMsg("LabSuccess")
			If _Sleep($DELAYLABUPGRADE2) Then Return
			Click(243, 33)
			Return True ; upgrade started
		Else
			SetLog("Oops, Gems required for " & $name & " Upgrade, try again.", $COLOR_ERROR)
			Return False
		EndIf
	EndIf
EndFunc   ;==>LaboratoryUpgrade

; get the time for the selected upgrade
Func SetLabUpgradeTime($sTrooopName)
	Local $Result = getLabUpgradeTime(581, 495) ; Try to read white text showing time for upgrade
	Local $iLabFinishTime = ConvertOCRTime("Lab Time", $Result, False)
	SetLog($sTrooopName & " Upgrade OCR Time = " & $Result & ", $iLabFinishTime = " & $iLabFinishTime & " m", $COLOR_INFO)
	Local $StartTime = _NowCalc() ; what is date:time now
	SetDebugLog($sTrooopName & " Upgrade Started @ " & $StartTime, $COLOR_SUCCESS)
	If $iLabFinishTime > 0 Then
		$g_sLabUpgradeTime = _DateAdd('n', Ceiling($iLabFinishTime), $StartTime)
		SetLog($sTrooopName & " Upgrade Finishes @ " & $Result & " (" & $g_sLabUpgradeTime & ")", $COLOR_SUCCESS)
	Else
		SetLog("Error processing upgrade time required, try again!", $COLOR_WARNING)
		Return False
	EndIf
	Return True ; success
EndFunc   ;==>SetLabUpgradeTime

; get the cost of an upgrade based on its coords
; find image slot that we found so that we can read the cost to see if we can upgrade it... slots read 1-12 top to bottom so barb = 1, arch = 2, giant = 3, etc...
Func GetLabCostResult($aCoords)
	SetDebugLog("Getting lab cost.")
	SetDebugLog("$iYMidPoint=" & $iYMidPoint)
	Local $iCurSlotOnPage, $iCurSlotsToTheRight, $sCostResult
	$iCurSlotsToTheRight = Ceiling((Int($aCoords[0]) - Int(StringSplit($sLabTroopsSection, ",")[1])) / ($iSlotWidth + $iDistBetweenSlots))
	If Int($aCoords[1]) < $iYMidPoint Then ; first row
		SetDebugLog("First row.")
		$iCurSlotOnPage = 2 * $iCurSlotsToTheRight - 1
		SetDebugLog("$iCurSlotOnPage=" & $iCurSlotOnPage)
		$sCostResult = getLabUpgrdResourceWht(Int(StringSplit($sLabTroopsSection, ",")[1]) + 10 + ($iCurSlotsToTheRight - 1) * ($iSlotWidth + $iDistBetweenSlots), Int(StringSplit($sLabTroopsSection, ",")[2]) + 76)
	Else ; second row
		SetDebugLog("Second row.")
		$iCurSlotOnPage = 2 * $iCurSlotsToTheRight
		SetDebugLog("$iCurSlotOnPage=" & $iCurSlotOnPage)
		$sCostResult = getLabUpgrdResourceWht(Int(StringSplit($sLabTroopsSection, ",")[1]) + 10 + ($iCurSlotsToTheRight - 1) * ($iSlotWidth + $iDistBetweenSlots), $iYMidPoint + 76 + 2) ;was 76
	EndIf
	SetDebugLog("Cost found is " & $sCostResult)
	Return $sCostResult
EndFunc   ;==>GetLabCostResult

; if we are on last page, smaller clickdrag... for future dev: this is whatever is enough distance to move 6 off to the left and have the next page similarily aligned.  "-50" to avoid the white triangle.
Func LabNextPage($iCurPage, $iPages, $iYMid = $iYMidPoint)
	If $iCurPage >= $iPages Then Return  ; nothing left to scroll
	If $iCurPage = $iPages - 1 Then ; last page
		;Last page has 3 columns of icons.  3*(94+12)=3*106=318.  720-318=402
		SetDebugLog("Drag to last page to pixel 401")
        ClickDrag(720, $iYMid - 50, 401, $iYMid) ;"-50" to avoid the little triangle.
		;If _Sleep(4000) Then Return ;Settling time on last page not needed if not rubber-band bounce.
	Else
		SetDebugLog("Drag to next full page.")
        ClickDrag(720, $iYMid - 50, 85, $iYMid) ;"-50" to avoid the little triangle.  Diagonal drag doesn't matter.  Every human will diagonal drag.
	EndIf

EndFunc   ;==>LabNextPage

; if we are on last page, smaller clickdrag... for future dev: this is whatever is enough distance to move 6 off to the left and have the next page similarily aligned
Func LabPrevPage($iDragTo = 6, $iYMid = $iYMidPoint)
	For $i = 1 To _Max($iDragTo, 6)
		ClickDrag(130, $iYMid - 50, 760, $iYMid - 50, 2000) ;600
		_CaptureRegion()
		If _ColorCheck(_GetPixelColor(117, 457, False), Hex(0xD3D3CB, 6), 15) And _ColorCheck(_GetPixelColor(729, 458, False), Hex(0xFFFFFF, 6), 15) Then
			If _Sleep(2000) Then Return
			ExitLoop
		EndIf
	Next
EndFunc   ;==>LabPrevPage

; check the lab to see if something is upgrading in the lab already
Func ChkLabUpgradeInProgress()
	; check for upgrade in process - look for green in finish upgrade with gems button
	If _ColorCheck(_GetPixelColor(730, 200, True), Hex(0xA2CB6C, 6), 20) Then ; Look for light green in upper right corner of lab window.
		SetLog("Laboratory is Running", $COLOR_INFO)
		;==========Hide Red  Show Green Hide Gray===
		GUICtrlSetState($g_hPicLabGray, $GUI_HIDE)
		GUICtrlSetState($g_hPicLabRed, $GUI_HIDE)
		GUICtrlSetState($g_hPicLabGreen, $GUI_SHOW)
		;===========================================
		If _Sleep($DELAYLABORATORY2) Then Return
		Local $sLabTimeOCR = getRemainTLaboratory(270, 257)
		Local $iLabFinishTime = ConvertOCRTime("Lab Time", $sLabTimeOCR, False)
		SetDebugLog("$sLabTimeOCR: " & $sLabTimeOCR & ", $iLabFinishTime = " & $iLabFinishTime & " m")
		If $iLabFinishTime > 0 Then
			$g_sLabUpgradeTime = _DateAdd('n', Ceiling($iLabFinishTime), _NowCalc())
			SetLog("Research will finish in " & $sLabTimeOCR & " (" & $g_sLabUpgradeTime & ")")
		EndIf
		ClickAway()
		If ProfileSwitchAccountEnabled() Then SwitchAccountVariablesReload("Save") ; saving $asLabUpgradeTime[$g_iCurAccount] = $g_sLabUpgradeTime for instantly displaying in multi-stats
		Return True
	EndIf
	Return False
EndFunc   ;==>ChkLabUpgradeInProgress

; checks our global variable to see if we know of something already upgrading
Func ChkUpgradeInProgress()
	Local $TimeDiff ; time remaining on lab upgrade
	If $g_sLabUpgradeTime <> "" Then $TimeDiff = _DateDiff("n", _NowCalc(), $g_sLabUpgradeTime) ; what is difference between end time and now in minutes?
	If @error Then _logErrorDateDiff(@error)
	SetDebugLog($g_avLabTroops[$g_iCmbLaboratory][0] & " Lab end time: " & $g_sLabUpgradeTime & ", DIFF= " & $TimeDiff, $COLOR_DEBUG)

	If Not $g_bRunState Then Return
	If $TimeDiff <= 0 Then
		SetLog("Checking Troop Upgrade in Laboratory ...", $COLOR_INFO)
	Else
		SetLog("Laboratory Upgrade in progress, waiting for completion", $COLOR_INFO)
		Return True
	EndIf
	Return False ; we currently do not know of any upgrades in progress
EndFunc   ;==>ChkUpgradeInProgress

; Find Research Button
Func FindResearchButton($bOnLyCheck = False) ; Magic items - Team AIO Mod++
	Local $ResearchButtonFound = False

	If $bOnLyCheck = False Then
		CheckMainScreen(False)
		
		;Click Laboratory
		ZoomOut()
		CheckObstacles()
		ClickAway()

		If LocateLaboratory() Then
	
			Local $aCancelButton = findButton("Cancel")
			If IsArray($aCancelButton) And UBound($aCancelButton, 1) = 2 Then
				SetLog("Laboratory is Upgrading!, Cannot start any upgrade", $COLOR_ERROR)
				ClickAway()
				Return False
			EndIf
		Else
			ClickAway()
			Return False
		EndIf

		Local $aResearchButton = findButton("Research", Default, 1, True)
		If IsArray($aResearchButton) And UBound($aResearchButton, 1) = 2 Then
			If $g_bDebugImageSave Then SaveDebugImage("LabUpgrade") ; Debug Only
			If $bOnLyCheck = False Then ClickP($aResearchButton)
			$ResearchButtonFound = True
			If _Sleep($DELAYLABORATORY1) Then Return ; Wait for window to open
			Return True
		Else
			SetLog("Cannot find the Laboratory Research Button!", $COLOR_INFO)
		EndIf
	EndIf

	If Not $ResearchButtonFound Then
		SetLog("Try to Locate Laboratory!", $COLOR_INFO)
		ClickAway()
		If BuildChecker($g_aiLaboratoryPos, $g_sImgLocationLabs) Then ;try locate lab again
			SetLog("Laboratory located on coords: " & "[" & $g_aiLaboratoryPos[0] & "," & $g_aiLaboratoryPos[1] & "], Saving Lab Loc for future", $COLOR_INFO)
			If _Sleep(1000) Then Return
			If $bOnLyCheck = False Then
				ClickB("Research")
				If _Sleep(1500) Then Return
			EndIf
			Return True
		Else
			SetLog("Laboratory location not found, please locate manually", $COLOR_DEBUG)
		EndIf
	EndIf
	
	ClickAway()
	Return False
EndFunc   ;==>FindResearchButton

Func BuildChecker(ByRef $aPosXY, $sImgDir)
	Local $aImgLocPos[2] = [-1, -1]
	
	ZoomOut()
	CheckObstacles()
	ClickAway()
	
	Local $bStatus = $g_bUseRandomClick	
	$g_bUseRandomClick = False

	Local $bOkLegacy = IsInsideDiamond($aPosXY)
	Local $bImgLocPosOk = ImgLocateBuilds($aImgLocPos, $sImgDir)
	If UBound($aPosXY) > 0 And Not @error And $bOkLegacy And $bImgLocPosOk Then
		
		Local $bFirstPos = Pixel_Distance($aPosXY[0], $aPosXY[1], $aImgLocPos[0], $aImgLocPos[1]) < 75
		
		If $bFirstPos = True Then
			BuildingClick($aPosXY[0], $aPosXY[1] - 25, "#4546")
		Else
			PureClickP($aImgLocPos)
			; ConvertFromVillagePos($aImgLocPos[0], $aImgLocPos[1])
			; BuildingClick($aImgLocPos[0], $aImgLocPos[1], "#4547")
			$aPosXY[0] = $aImgLocPos[0]
			$aPosXY[1] = $aImgLocPos[1]
		EndIf

	ElseIf $bImgLocPosOk Then
		PureClickP($aImgLocPos)
		; ConvertFromVillagePos($aImgLocPos[0], $aImgLocPos[1])
		; BuildingClick($aImgLocPos[0], $aImgLocPos[1], "#4548")
		$aPosXY[0] = $aImgLocPos[0]
		$aPosXY[1] = $aImgLocPos[1]
	ElseIf UBound($aPosXY) > 0 And Not @error And $bOkLegacy Then
		BuildingClick($aPosXY[0], $aPosXY[1], "#4549")
	Else
		$aPosXY[0] = 0
		$aPosXY[1] = 0
		$g_bUseRandomClick = $bStatus
		Return False
	EndIf
	
	$g_bUseRandomClick = $bStatus
	Local $aCancelButton = findButton("Cancel")
	If IsArray($aCancelButton) And UBound($aCancelButton, 1) = 2 Then
	Else
		Local $aResearchButton = findButton("Research", Default, 1, True)
		If IsArray($aResearchButton) And UBound($aResearchButton, 1) = 2 Then
			If $bImgLocPosOk Then
				ConvertFromVillagePos($aImgLocPos[0], $aImgLocPos[1])
				$aPosXY[0] = $aImgLocPos[0]
				$aPosXY[1] = $aImgLocPos[1]
			EndIf
			Return True
		EndIf
	EndIf

	ClickAway()
	If _Sleep(1000) Then Return
	Return False
EndFunc   ;==>BuildChecker

;ImgLocateBuilds($g_aiLaboratoryPos, $g_sImgLocationLabs)
Func ImgLocateBuilds(ByRef $aiCoords, $sImgDir)
	ZoomOut()
	Local $avBuild = _ImageSearchXML($g_sImgLocationLabs, 0, $CocDiamondECD)

	If UBound($avBuild) > 0 And not @error Then
		For $i = 0 To UBound($avBuild) - 1
			$aiCoords[0] = $avBuild[$i][1]
			$aiCoords[1] = $avBuild[$i][2]
			Return True
		Next
	ElseIf $g_bDebugImageSave Then
		SaveDebugImage("ImgLocateBuilds", False)
	EndIf

	Return False
EndFunc   ;==>ImgLocateBuilds
