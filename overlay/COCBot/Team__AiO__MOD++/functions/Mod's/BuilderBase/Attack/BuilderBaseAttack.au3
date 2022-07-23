; #FUNCTION# ====================================================================================================================
; Name ..........: BuilderBaseAttack
; Description ...: Use on Builder Base attack
; Syntax ........: BuilderBaseAttack()
; Parameters ....:
; Return values .: None
; Author ........: ProMac (03-2018)
; Modified ......: Chilly-Chill (05/2019)
; Remarks .......: This file is part of MyBot, previously known as Multibot and ClashGameBot. Copyright 2015-2020
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Func TestBuilderBaseAttack()
	Setlog("** TestBuilderBaseAttack START**", $COLOR_DEBUG)
	Local $Status = $g_bRunState
	$g_bRunState = True
	Local $AvailableAttacksBB = $g_iAvailableAttacksBB
	$g_iAvailableAttacksBB = 3
	BuilderBaseAttack(True)
	$g_iAvailableAttacksBB = $AvailableAttacksBB
	$g_bRunState = $Status
	Setlog("** TestBuilderBaseAttack END**", $COLOR_DEBUG)
EndFunc   ;==>TestBuilderBaseAttack

Func BuilderBaseAttack($bTestRun = False)

	If Not $g_bRunState Then Return

	; Stop when reach the value set it as minimum of trophies
	If (Not $bTestRun) And Int($g_aiCurrentLootBB[$eLootTrophyBB]) < Int($g_iTxtBBDropTrophiesMin) And $g_iAvailableAttacksBB = 0 And $g_bChkBBTrophiesRange = True Then
		Setlog("You reach the value set it as minimum of trophies!", $COLOR_INFO)
		Setlog("And you don't have any attack available.", $COLOR_INFO)
		Return False
	EndIf

	; Variables
	Local $IsReaddy = False, $bIsToDropTrophies = False

	; LOG
	Setlog("Entering in Builder Base Attack!", $COLOR_INFO)

	If checkObstacles(True) Then Return
	If $g_bRestart Then Return
	If RandomSleep(1500) Then Return ; Add Delay Before Check Builder Face As When Army Camp Get's Close Due To It's Effect Builder Face Is Dull and not recognized on slow pc

	; Check for builder base.
	If Not isOnBuilderBase() Then
		Return
	EndIf

	; Check Attack Button
	If Not CheckAttackBtn() Then
		SetLog("CheckAttackBtn not possible", $COLOR_DEBUG)
		Return False
	EndIf

	; Check if is present bonus OCR.
	If IsBuilderBaseOCR() Then
		ClickAway(Default, True)
		If RandomSleep(1500) Then Return
		Return False
	EndIf

	; Get Army Status
	ArmyStatus($IsReaddy)
	If RandomSleep(800) Then Return

	; Get Drop Trophies Status
	IsToDropTrophies($bIsToDropTrophies)
	If RandomSleep(800) Then Return

	; Get Battle Machine status
	Local $HeroStatus = HeroStatus()
	$g_bIsMachinePresent = ($HeroStatus = "Battle Machine ready to use" ? True : False)

	;If $bTestRun Then $bIsToDropTrophies = True

	; User LOG
	SetLog(" - Are you ready to Battle? " & $IsReaddy, $COLOR_INFO)
	SetLog(" - Is To Drop Trophies? " & $bIsToDropTrophies, $COLOR_INFO)
	SetLog(" - " & $HeroStatus, $COLOR_INFO)

	If $g_bRestart = True Then Return
	If $IsReaddy And (($bIsToDropTrophies) Or ($g_iCmbBBAttack = $g_eBBAttackCSV) Or ($g_iCmbBBAttack = $g_eBBAttackSmart)) Then

		If Not FindVersusBattlebtn() Then
			SetLog("FindVersusBattlebtn not possible", $COLOR_DEBUG)
			ClickAway()
			Return False
		EndIf

		; Clouds
		If Not WaitForVersusBattle() Then
			SetLog("WaitForVersusBattle not possible", $COLOR_DEBUG)
			ClickAway()
			Return False
		EndIf
		If Not $g_bRunState Then Return

		; Attack Bar | [0] = Troops Name , [1] = X-axis , [2] - Y-axis, [3] - Slot starting at 0, [4] - Amount
		; Local $aAvailableTroops = BuilderBaseAttackBar()
		Local $aAvailableTroops = GetAttackBarBB()
		If IsArray($aAvailableTroops) Then
			SetDebugLog("Attack Bar Array: " & _ArrayToString($aAvailableTroops, "-", -1, -1, "|", -1, -1))
		Else
			SetDebugLog("No troops AttackBar.", $COLOR_ERROR)
			CheckMainScreen()
			Return -1
		EndIf
					
		For $i = 0 To 1
			If (($i = 1) ? (True) : (False)) = (Not $g_bChkBBCustomAttack Or ($g_iCmbBBAttack = $g_eBBAttackSmart)) Then
				; Zoomout the Opponent Village
				ZoomOut(False, True)
				If $g_bRestart = True Then Return
				If Not $g_bRunState Then Return
			ElseIf Not $bIsToDropTrophies Then
				; Verify the scripts and attack bar
				BuilderBaseSelectCorrectScript($aAvailableTroops)
				If $g_bRestart = True Then Return
				If Not $g_bRunState Then Return
			EndIf
		Next
		
		; Avoid bugs in redlines (too fast MyBot).
		If RandomSleep(1500) Then Return

		; Reset vars machine.
		$g_aMachineBB = $g_aMachineBBReset

		RemoveChangeTroopsDialog()

		; Select mode.
		Select
			Case $bIsToDropTrophies = True
				Setlog("Let's Drop some Trophies!", $COLOR_SUCCESS)

				; Start the Attack realing one troop and surrender
				BuilderBaseAttackToDrop($aAvailableTroops)
				If Not $g_bRunState Then Return

			Case ($g_iCmbBBAttack = $g_eBBAttackCSV)
				Setlog("Ready to Battle! BB CSV... Let's Go!", $COLOR_SUCCESS)

				; Parse CSV , Deploy Troops and Get Machine Status [attack algorithm] , waiting for Battle ends window
				BuilderBaseCSVAttack($aAvailableTroops)
				If Not $g_bRunState Then Return

			Case ($g_iCmbBBAttack = $g_eBBAttackSmart)
				Setlog("Ready to Battle! BB Smart Attack... Let's Go!", $COLOR_SUCCESS)

				; BB Smart Attack
				AttackBB($aAvailableTroops)
				If Not $g_bRunState Then Return

			Case Else
				$g_bRestart = ($bTestRun = True) ? (False) : (True)
				If $g_bRestart = True Then Return

		EndSelect

		; Attack Report Window
		BuilderBaseAttackReport()
		If $g_bRestart = True Then Return
		If Not $g_bRunState Then Return

	EndIf

	; Exit
	Setlog("Exit from Builder Base Attack!", $COLOR_INFO)
	ClickAway(Default, True, 2)
	CheckMainScreen(True)
	If _Sleep(2000) Then Return
	Return True
EndFunc   ;==>BuilderBaseAttack

Func RemoveChangeTroopsDialog()
	If _ColorCheck(_GetPixelColor(103, 710 + $g_iBottomOffsetYFixed, True), Hex(0x6C6E6F, 6), 25) Then ; Resolution changed
		SetLog("Removing change troops dialog to start attack...", $COLOR_INFO)
		Local $aClickPoints = [64, 648]
		$aClickPoints[0] += Random(1, 282, 1)
		$aClickPoints[1] += Random(1, 35, 1)
		ClickP($aClickPoints)
		Return True
	EndIf
	Return False
EndFunc   ;==>RemoveChangeTroopsDialog

Func CheckAttackBtn()
	Local $i = 0, $bFoundWindows = False
	If QuickMIS("BC1", $g_sImgAttackBtnBB, 15, 622 + $g_iBottomOffsetYFixed, 109, 715 + $g_iBottomOffsetYFixed, True, False) Then
		SetDebugLog("Attack Button detected: " & $g_iQuickMISX & "," & $g_iQuickMISY) ; Resolution changed
		PureClick(Random(30, 94, 1), Random(636, 696, 1) + $g_iBottomOffsetYFixed, 1) ; Resolution changed
	EndIf

	Do
		$i += 1
		If Not _Wait4PixelArray($g_aOnVersusBattleWindowBB) Then
			If QuickMIS("BC1", $g_sImgAttackBtnBB, 15, 622 + $g_iBottomOffsetYFixed, 109, 715 + $g_iBottomOffsetYFixed, True, False) Then
				SetDebugLog("Attack Button detected: " & $g_iQuickMISX & "," & $g_iQuickMISY) ; Resolution changed
				PureClick(Random(30, 94, 1), Random(636, 696, 1) + $g_iBottomOffsetYFixed, 1) ; Resolution changed
			EndIf
			If _Sleep(500) Then Return 
			ContinueLoop
		EndIf
		
		$bFoundWindows = _CheckPixel($g_aFindBattleBB, True)
		
		If Not $g_bRunState Then Return
		
		If $bFoundWindows = False Then
		
			If Not $g_bRunState Then Return
		
			If _CheckPixel($g_aFindBattleBB, True) Then
				SetDebugLog("Versus Battle window detected.")
			ElseIf _CheckPixel($g_aOkayBtnBB, True) Then
				Click($g_aOkayBtnBB[0] + Random(5, 10, 1), $g_aOkayBtnBB[1] + Random(5, 10, 1))
			ElseIf Not BuilderBaseAttackOppoWait() Then
				SetLog("[" & $i & "] Versus Battle window not available.", $COLOR_WARNING)
			EndIf
			
			If _Sleep(1500) Then Return 
		EndIf
		
		
	Until ($i = 30) Or $bFoundWindows Or Not $g_bRunState
	
	If $i > 14 Then
		ClickAway(Default, True)
		Return False
	EndIf
	
	Return True
EndFunc   ;==>CheckAttackBtn

Func BuilderBaseAttackOppoWait()
	Local $iWait = 180000 ; 3 min
	Local $hTimer = TimerInit()
	Local $iErrorLoop = 0
	Local $i = 0;, $hResultColor = 0x000000
	If _CheckPixel($g_aIsAttackBB, True) Then
		Local $bWasSuspend = $g_bAndroidSuspended
		$g_bAndroidSuspended = True

		Do
			$i += 1
			If Not $g_bRunState Then Return

			If isOnBuilderBase(True) Or $iErrorLoop = 15 Then
				SetLog("[BuilderBaseAttackOppoWait] Something weird happened here. Leave the screen alone.", $COLOR_ERROR)
				If checkObstacles(True) Then SetLog("Window clean required, but no problem for MyBot!", $COLOR_INFO)
				Return False
			EndIf

			; Wait
			If _CheckPixel($g_aIsAttackBB, True) Then
				If isProblemAffect(True) Then
					SetLog("[BuilderBaseAttackOppoWait] isProblemAffect ? True.", $COLOR_ERROR)
					If checkObstacles(True) Then SetLog("Window clean required, but no problem for MyBot!", $COLOR_INFO)
					Return False
				EndIf
				If (Mod($i  + 1, 4) = 0) Then Setlog("Opponent is attacking.", $COLOR_INFO)
				If _Sleep(3000) Then Return ; 3 seconds
				ContinueLoop
			EndIf

			; Thropy
			If _WaitForCheckImg($g_sImgReportFinishedBB, "465, 405, 490, 461", Default, 5000, 250) Then ; Resolution changed
				; $hResultColor = _GetPixelColor(150, 192 + $g_iMidOffsetYFixed, True) ; Resolution changed
				ExitLoop
			Else
				$iErrorLoop += 1
			EndIf

		Until ($iWait < TimerDiff($hTimer))
		
		$g_bAndroidSuspended = $bWasSuspend

		If _Sleep(5000) Then Return

		If _CheckPixel($g_aOkayBtnBB, True) Then
			Click($g_aOkayBtnBB[0] + Random(5, 10, 1), $g_aOkayBtnBB[1] + Random(5, 10, 1))
			If _Sleep(1500) Then Return
			Return True
		EndIf
	EndIf

	Return False
EndFunc   ;==>BuilderBaseAttackOppoWait

Func ArmyStatus(ByRef $bIsReady)
	If Not $g_bRunState Then Return

	#Region Legacy Chilly-Chill fragment.
	Local $sSearchDiamond = GetDiamondFromRect("114,340(76,66)") ; start of trained troops bar untill a bit after the 'r' "in Your Troops" ; Resolution changed
	Local $aNeedTrainCoords = decodeSingleCoord(findImage("NeedTrainBB", $g_sImgBBNeedTrainTroops, $sSearchDiamond, 1, True))

	If IsArray($aNeedTrainCoords) And UBound($aNeedTrainCoords) = 2 Then
		Local $bNeedTrain = True

		ClickAway() ; ClickP($aAway, 1, 0, "#0000") ; ensure field is clean
		If _Sleep(1500) Then Return ; Team AIO Mod++ Then Return
		SetLog("Troops need to be trained in the training tab.", $COLOR_INFO)
		CheckArmyBuilderBase()
		$bIsReady = False
		Return False

	EndIf
	#EndRegion Legacy Chilly-Chill fragment.

	If QuickMis("BC1", $g_sImgFullArmyBB, 108, 355 + $g_iMidOffsetYFixed, 431, 459 + $g_iMidOffsetYFixed, True, False) Then ; Resolution changed
		SetDebugLog("Full Army detected.")
		SetLog("Full Army detected", $COLOR_INFO)
		$bIsReady = True
	ElseIf QuickMis("BC1", $g_sImgHeroStatusUpg, 108, 355 + $g_iMidOffsetYFixed, 431, 459 + $g_iMidOffsetYFixed, True, False) Then ; Resolution changed
		SetLog("Full Army detected, But Battle Machine is on Upgrade", $COLOR_INFO)
		$bIsReady = True
	Else
		$bIsReady = False
	EndIf

	$g_bBBMachineReady = $bIsReady

EndFunc   ;==>ArmyStatus

Func HeroStatus()
	If Not $g_bRunState Then Return
	Local $Status = "No Hero to use in Battle"
	If QuickMis("BC1", $g_sImgHeroStatusRec, 108, 355 + $g_iMidOffsetYFixed, 431, 459 + $g_iMidOffsetYFixed, True, False) Then ; Resolution changed
		$Status = "Battle Machine Recovering"
	EndIf
	If QuickMis("BC1", $g_sImgHeroStatusMachine, 108, 355 + $g_iMidOffsetYFixed, 431, 459 + $g_iMidOffsetYFixed, True, False) Then ; Resolution changed
		$Status = "Battle Machine ready to use"
	EndIf
	If QuickMis("BC1", $g_sImgHeroStatusUpg, 108, 355 + $g_iMidOffsetYFixed, 431, 459 + $g_iMidOffsetYFixed, True, False) Then ; Resolution changed
		$Status = "Battle Machine Upgrading"
	EndIf
	Return $Status
EndFunc   ;==>HeroStatus

Func IsToDropTrophies(ByRef $bIsToDropTrophies)
	If Not $g_bRunState Then Return
	$bIsToDropTrophies = False

	If Not $g_bChkBBTrophiesRange Then Return

	If Int($g_aiCurrentLootBB[$eLootTrophyBB]) > Int($g_iTxtBBDropTrophiesMax) Then
		SetLog("Max Trophies reached!", $COLOR_WARNING)
		$bIsToDropTrophies = True
	EndIf
EndFunc   ;==>IsToDropTrophies

Func FindVersusBattlebtn()
	If Not $g_bRunState Then Return

	Local $aFindVersusBattleBtn[2][3] = [[0xFFCA4A, 1, 0], [0xFFCA4A, 0, 1]]
	Local $aOkayVersusBattleBtn[2][3] = [[0xFDDF685, 1, 0], [0xDDF685, 2, 0]]

	SetLog("Finding Button Now!", $COLOR_INFO)

	Local $aXY[2] = [Random(528, 666, 1), Random(254, 312, 1)]
	Local $bClicked = False

	For $i = 0 To 6
		If _MultiPixelSearch(490, 284 + $g_iMidOffsetYFixed, 710, 375 + $g_iMidOffsetYFixed, 1, 1, Hex(0xFFCA4A, 6), $aFindVersusBattleBtn, 25) <> 0 Then
			PureClickP($aXY, 1)
			If _Sleep(Random(800, 1200, 1)) Then Return False
			$bClicked = True
		ElseIf $bClicked = True Then
			SetDebugLog("Find Now! Button detected: " & $g_iMultiPixelOffSet[0] & "," & $g_iMultiPixelOffSet[1])
			Return True
		Else
			If _MultiPixelSearch(600, 452, 745, 510, 1, 1, Hex(0xDDF685, 6), $aOkayVersusBattleBtn, 25) <> 0 Then
				SetDebugLog("OKAY! Button detected: " & $g_iMultiPixelOffSet[0] & "," & $g_iMultiPixelOffSet[1])
				ClickP($g_iMultiPixelOffSet, 2, 0)
				If _Sleep(1200) Then Return False
			EndIf
		EndIf
	Next

	If ($i >= 5) Or ($g_iMultiPixelOffSet[0] = Null) And $bClicked = False Then
		SetLog("Find Now! Button not available...", $COLOR_DEBUG)
	EndIf

	Return False
EndFunc   ;==>FindVersusBattlebtn

Func WaitForVersusBattle()
	Local $aCancelVersusBattleBtn[4][3] = [[0xFE2D40, 1, 0], [0xFE2D40, 2, 0], [0xFE2D40, 3, 0], [0xFE2D40, 4, 0]]
	Local $aAttackerVersusBattle[2][3] = [[0xFFFF99, 0, 1], [0xFFFF99, 0, 2]]

	If Not $g_bRunState Then Return

	; Clouds
	Local $iTime = 0
	Local $iSwitch = 0

	While $iTime < 100 ; 5 minutes
		If Not $g_bRunState Then Return False

		If (Mod($iTime, 3) = 0) Then $iSwitch += 1
		Switch $iSwitch
			Case 0
				SetLog("Searching for opponents.", $COLOR_ACTION)
			Case 1
				If isProblemAffect(True) Then
					Return False
				EndIf
			Case 2
				If checkObstacles_Network(True, True) Then
					Return False
				EndIf
			Case 3
				If isOnBuilderBase(True) Then
					Return False
				EndIf
				$iSwitch = 0
		EndSwitch

		If _MultiPixelSearch(711, 2, 856, 55, 1, 1, Hex(0xFFFF99, 6), $aAttackerVersusBattle, 15) <> 0 Then
			ExitLoop
		EndIf

		If _Sleep(3000) Then Return
		$iTime += 1
	WEnd

	If $iTime >= 100 Then
		If _MultiPixelSearch(375, 547 + $g_iBottomOffsetYFixed, 450, 555 + $g_iBottomOffsetYFixed, 1, 1, Hex(0xFE2D40, 6), $aCancelVersusBattleBtn, 5) <> 0 Then
			SetLog("Exit from battle search.", $COLOR_WARNING)
			ClickP($g_iMultiPixelOffSet, 2, 0)
			If _Sleep(3000) Then Return
			CheckMainScreen(True)
			Return False
		EndIf
	EndIf

	For $i = 0 To 60
		If Not $g_bRunState Then Return False
		Local $bIsBBAttackPage = IsBBAttackPage()
		SetDebugLog("WaitForVersusBattle: Is BB Attack Page ? " & $bIsBBAttackPage)
		If $bIsBBAttackPage Then ExitLoop
		If _Sleep(2000) Then Return
		If $i = 60 Then
			CheckMainScreen(True)
			Return False
		EndIf
	Next

	SetLog("The Versus Battle begins NOW!", $COLOR_SUCCESS)

	Return True

EndFunc   ;==>WaitForVersusBattle

Func IsBBAttackPage()
	Return (WaitforPixel(378, 5, 482, 26, Hex(0xFFD6D5, 6), 15, 2) = True)
EndFunc   ;==>IsSTPage

Func BuilderBaseAttackToDrop($aAvailableTroops)
	#comments-start
		$aAttackBar[n][8]
		[n][0] = Name of the found Troop/Spell/Hero/Siege
		[n][1] = The X Coordinate of the Troop
		[n][2] = The Y Coordinate of the Troop/Spell/Hero/Siege
		[n][3] = The Slot Number (Starts with 0)
		[n][4] = The Amount
	#comments-end

	If Not $g_bRunState Then Return
	If Not UBound($aAvailableTroops) > 0 Then Return

	; Reset all variables
	BuilderBaseResetAttackVariables()

	Local $Troop = $aAvailableTroops[0][0]
	Local $Slot = [$aAvailableTroops[0][1], $aAvailableTroops[0][2]]

	; Select the Troop
	ClickP($Slot, 1, 0)

	Setlog("Selected " & FullNametroops($Troop) & " to deploy.")

	If _Sleep(1000) Then Return

	If ZoomBuilderBaseMecanics(False) < 1 Then Return False

	; [0] - TopLeft ,[1] - TopRight , [2] - BottomRight , [3] - BottomLeft
	Local $DeployPoints = BuilderBaseGetDeployPoints(5)
	Local $aUniqueDeployPoint[2] = [0, 0]

	If IsArray($DeployPoints) Then
		; Just get a valid point to deploy
		For $i = 0 To 3
			Local $aUniqueDeploySide = $DeployPoints[$i]
			If UBound($aUniqueDeploySide) < 1 Then ContinueLoop
			$aUniqueDeployPoint[0] = $aUniqueDeploySide[0][0]
			$aUniqueDeployPoint[1] = $aUniqueDeploySide[0][1]
		Next
	EndIf

	If $aUniqueDeployPoint[0] = 0 Then
        $g_aBuilderBaseDiamond = BuilderBaseAttackDiamond()
		If @error Then
			Return False
		EndIf

		$g_aExternalEdges = BuilderBaseGetEdges($g_aBuilderBaseDiamond, "External Edges")
	EndIf

	Local $aUniqueDeploySide = $g_aExternalEdges[0]
	$aUniqueDeployPoint[0] = $aUniqueDeploySide[0][0]
	$aUniqueDeployPoint[1] = $aUniqueDeploySide[0][1]

	If $aUniqueDeployPoint[0] <> 0 Then
		; Deploy One Troop
		ClickP($aUniqueDeployPoint, 1, 0)
	EndIf

	Local $aBlackArts[4] = [520, 600 + $g_iMidOffsetYFixed, 0x000000, 5] ; Fixed resolution
	For $i = 0 To 15
		; Surrender button [FC5D64]
		If chkSurrenderBtn() = True Then
			SetLog("Let's Surrender!")
			ClickP($aSurrenderButton, 1, 0, "#0099") ;Click Surrender

			If _Wait4PixelArray($g_aOKBtn) Then
				Click($g_aOKBtn[0] - Random(0, 25, 1), $g_aOKBtn[1] + Random(0, 25, 1))
				_Wait4PixelGoneArray($g_aOKBtn)
			EndIf

			If RandomSleep(250) Then Return

			If _Wait4PixelArray($aBlackArts) Then
				ExitLoop
			EndIf

		Else
			If ($aUniqueDeploySide) > $i Then
				$aUniqueDeployPoint[0] = $aUniqueDeploySide[$i][0]
				$aUniqueDeployPoint[1] = $aUniqueDeploySide[$i][1]

				If $aUniqueDeployPoint[0] <> 0 Then
					; Deploy One Troop
					ClickP($aUniqueDeployPoint, 1, 0)
				EndIf
			EndIf
		EndIf
		If _Sleep(500) Then Return
	Next

	If $i >= 15 Then Setlog("Surrender button Problem!", $COLOR_WARNING)


EndFunc   ;==>BuilderBaseAttackToDrop

Func BuilderBaseCSVAttack($aAvailableTroops, $bDebug = False)
	; $aAvailableTroops[$x][0] = Name , $aAvailableTroops[$x][1] = X axis
	If Not $g_bRunState Then Return

	; Reset all variables
	BuilderBaseResetAttackVariables()
	; $aAvailableTroops[$x][0] = Name , $aAvailableTroops[$x][1] = X axis

	; maybe will be necessary to click on attack bar to release the zoomout pinch
	; x = 75 , y = 584
	;Local $slotZero[2] = [102, 684] ; DESRC DONE
	;ClickP($slotZero, 1, 0)

	; [0] - TopLeft ,[1] - TopRight , [2] - BottomRight , [3] - BottomLeft
	Local $FurtherFrom = 5 ; 5 pixels before the deploy point
	BuilderBaseGetDeployPoints($FurtherFrom, $bDebug)
	If Not $g_bRunState Then Return
	; Parse CSV , Deploy Troops and Get Machine Status [attack algorithm] , waiting for Battle ends window
	BuilderBaseParseAttackCSV($aAvailableTroops, $g_aDeployPoints, $g_aBestDeployPoints, $g_aOuterDeployPoints, $bDebug)

EndFunc   ;==>BuilderBaseCSVAttack

Func BuilderBaseAttackReport($bNoExit = False)
	; Verify the Window Report , Point[0] Archer Shadow Black Zone [155,460,000000], Point[1] Ok Green Button [430,590, 6DBC1F]
	Local $aSurrenderBtn = [65, 607 + $g_iBottomOffsetYFixed] ; Fixed resolution
	Local $sReturn ;, $bTrueCap = False

	; Check if BattleIsOver.
	BattleIsOver()

	;BB attack Ends
	If _Sleep(2000) Then Return

	; in case BB Attack Ends in error
	If _ColorCheck(_GetPixelColor($aSurrenderBtn[0], $aSurrenderBtn[1], True), Hex(0xFE5D65, 6), 10) Then
		Setlog("Surrender Button fail - battle end early - CheckMainScreen()", $COLOR_ERROR)
		CheckMainScreen()
		Return False
	EndIf

	Local $iStars = 0
	Local $StarsPositions[3][2] = [[326, 394 + $g_iMidOffsetYFixed], [452, 388 + $g_iMidOffsetYFixed], [546, 413 + $g_iMidOffsetYFixed]] ; Fixed resolution
	Local $iColor[3] = [0xD0D4D0, 0xDBDEDB, 0xDBDDD8]

	If _Sleep(1500) Then Return
	If Not $g_bRunState Then Return

	For $i = 0 To UBound($StarsPositions) - 1
		If _ColorCheck(_GetPixelColor($StarsPositions[$i][0], $StarsPositions[$i][1], True), Hex($iColor[$i], 6), 30) Then $iStars += 1
	Next

	Setlog("Your Attack: " & $iStars & " Star(s)!", $COLOR_INFO)

	If Okay() Then
	   SetLog("Return To Home.", $Color_Info)
	Else
	  Setlog("Return home button fail.", $COLOR_ERROR)
	  CheckMainScreen()
	EndIf

	Local $iWait = 185000 ; 3 min
	Local $hTimer = TimerInit()
	Local $iErrorLoop = 0
	Local $i = 0
	
	Local $bWasSuspend = $g_bAndroidSuspended
	$g_bAndroidSuspended = True
	Do
		$i += 1
		If Not $g_bRunState Or $g_bRestart Then Return

			If isOnBuilderBase(True) Or $iErrorLoop = 15 Then
				SetLog("[BuilderBaseAttackReport] Something weird happened here. Leave the screen alone.", $COLOR_ERROR)
				If checkObstacles(True) Then SetLog("Window clean required, but no problem for MyBot!", $COLOR_INFO)
				Return False
			EndIf

			; Wait
			If _CheckPixel($g_aIsAttackBB, True) Then
				If isProblemAffect(True) Then
					SetLog("[BuilderBaseAttackReport] isProblemAffect ? True.", $COLOR_ERROR)
					Return False
				EndIf
			If (Mod($i  + 1, 4) = 0) Then Setlog("Opponent is attacking.", $COLOR_INFO)
			If _Sleep(3000) Then Return ; 3 seconds
			ContinueLoop
		EndIf

		; Thropy
		If _WaitForCheckImg($g_sImgReportFinishedBB, "465, 405, 490, 461", Default, 5000, 250) Then ; Fixed resolution
			ExitLoop
		Else
			$iErrorLoop += 1
		EndIf

	Until ($iWait < TimerDiff($hTimer))
	$g_bAndroidSuspended = $bWasSuspend
	If RandomSleep(2500, 1550) Then Return

	; 0, 1, 2
	Local $hResultColor = _GetPixelColor(150, 192 + $g_iMidOffsetYFixed, True) ; Fixed resolution
	Local $aColorsResult = [0x8DBE51, 0xD0262C, 0x87A9CF]
	Local $iModeSet = HexColorIndex($aColorsResult, $hResultColor, 25)

	If $iModeSet = -1 Then
		SetLog("Failed detection in BuilderBaseAttackReport", $COLOR_ERROR)
		$iModeSet = 2
	EndIf
	
	If Not $g_bRunState Or $g_bRestart Then Return

	; Get the LOOT :
	Local $iGain[3]

	$iGain[$eLootTrophyBB] = Int(getOcrOverAllDamage(493, 480 + $g_iMidOffsetYFixed)) ; Fixed resolution
	$iGain[$eLootGoldBB] = Int(getTrophyVillageSearch(150, 483 + $g_iMidOffsetYFixed)) ; Fixed resolution
	$iGain[$eLootElixirBB] = Int(getTrophyVillageSearch(310, 483 + $g_iMidOffsetYFixed)) ; Fixed resolution
	Local $iLastDamage = Int(_getTroopCountBig(222, 304 + $g_iMidOffsetYFixed)) ; Fixed resolution
	If $iLastDamage > $g_iLastDamage Then $g_iLastDamage = $iLastDamage

	; 0, 1, 2
	Local $iTropy[3] = [$iGain[$eLootTrophyBB], $iGain[$eLootTrophyBB] * -1, 0]
	Local $aLogColor[3] = [$COLOR_GREEN, $COLOR_ERROR, $COLOR_INFO]
	Local $aLogMode[3] = ["Victory", "Defeat", "Draw"]

	$iGain[$eLootTrophyBB] = $iTropy[$iModeSet]

	; #######################################################################
	; Just a temp log for BB attacks , this needs a new TAB like a stats tab
	Local $sAtkLogTxt
	$sAtkLogTxt = "  " & String($g_iCurAccount + 1) & "|" & _NowTime(4) & "|"
	$sAtkLogTxt &= StringFormat("%5d", $g_aiCurrentLootBB[$eLootTrophyBB]) & "|"
	$sAtkLogTxt &= StringFormat("%7d", $iGain[$eLootGoldBB]) & "|"
	$sAtkLogTxt &= StringFormat("%7d", $iGain[$eLootElixirBB]) & "|"
	$sAtkLogTxt &= StringFormat("%3d", $iGain[$eLootTrophyBB]) & "|"
	$sAtkLogTxt &= StringFormat("%1d", $iStars) & "|"
	$sAtkLogTxt &= StringFormat("%3d", $g_iLastDamage) & "|"
	$sAtkLogTxt &= StringFormat("%1d", $g_iBuilderBaseScript + 1) & "|"

	SetBBAtkLog($sAtkLogTxt, "", $aLogColor[$iModeSet])
	Setlog("Attack Result: " & $aLogMode[$iModeSet], $aLogColor[$iModeSet])

	; #######################################################################

	If $bNoExit = False Then
		; Return to Main Page
		ClickAway()

		; Reset Variables
		$g_aMachineBB = $g_aMachineBBReset
		$g_iBBMachAbilityLastActivatedTime = -1

		If $g_bIsBBevent = True Then
			; xbebenk
			For $i = 0 To 8
				If Not $g_bRunState Or $g_bRestart Then Return
				_CaptureRegion2(760, 510 + $g_iBottomOffsetYFixed, 820, 550 + $g_iBottomOffsetYFixed) ; Fixed resolution
				If UBound(decodeSingleCoord(findImage("GameComplete", $g_sImgGameComplete & "\*", "FV", 1, False))) = 2 And not @error Then
					SetLog("Nice, clan came completed.", $COLOR_INFO)
					$g_bIsBBevent = False

					Click(700, 570 + $g_iBottomOffsetYFixed, 1) ; Fixed resolution

					If _Wait4Pixel(827, 78 + $g_iBottomOffsetYFixed, 0xFFFFFF, 5, 2500, 250, "BuilderBaseAttackReport") Then ; Fixed resolution
						_ClanGames(False, True)
						ExitLoop
					EndIf

				Endif
				If _Sleep(500) Then Return
			Next
		EndIf

		If RandomSleep(1500) Then Return
	Else
		If _CheckPixel($g_aOkayBtnBB, True) Then
			Click($g_aOkayBtnBB[0] + Random(5, 10, 1), $g_aOkayBtnBB[1] + Random(5, 10, 1))
			If _Sleep(1500) Then Return
			Return True
		EndIf

		Return False
	EndIf
EndFunc   ;==>BuilderBaseAttackReport

Func HexColorIndex($aMultiPixels, $pColor, $iTolerance = 25)
	For $i = 0 To UBound($aMultiPixels) - 1
		If _ColorCheck($pColor, Hex($aMultiPixels[$i], 6), $iTolerance) Then
			Return $i
		EndIf
	Next
	Return -1
EndFunc   ;==>HexColorIndex
