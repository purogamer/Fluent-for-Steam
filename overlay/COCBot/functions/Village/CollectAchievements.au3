; #FUNCTION# ====================================================================================================================
; Name ..........: collectAchievements
; Description ...: Collect Achievement rewards
; Syntax ........: collectAchievements()
; Parameters ....:
; Return values .: None
; Author ........: Nytol (2020)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Global $g_iCollectAchievementsLoopCount = 0
Global $g_iCollectAchievementsRunOn = 0
Global $g_iFoundScrollEnd = 0

Func CollectAchievements($bTestMode = False) ;Run with True parameter if testing to run regardless of checkbox setting, randomization skips and runstate check

	;If Not $bTestMode Then
	;	If Not $g_bChkCollectAchievements Or Not $g_bRunState Then Return
	;	If Not CollectAchievementsRandomization() Then Return
	;EndIf

	ClickAway()
	If Not IsMainPage() Then Return

	SetLog("Begin collecting achievement rewards", $COLOR_INFO)
	If _Sleep($DELAYCOLLECT2) Then Return
	Local $Collecting = True
	While $Collecting
		If Not $g_bRunState Then Return
		;Check if possible rewards available from main screen
		Local $aImgAchievementsMainScreen = decodeSingleCoord(findImage("AchievementsMainScreen", $g_sImgAchievementsMainScreen, GetDiamondFromRect("5, 60, 70, 2"), 1, True)) ; Resolution changed ?
		If UBound($aImgAchievementsMainScreen) > 1 Then
			SetDebugLog("Achievement counter found on main screen", $COLOR_SUCCESS)
			Click($aImgAchievementsMainScreen[0] - 10, $aImgAchievementsMainScreen[1] + 20)
			If _Sleep(1500) Then Return
		Else
			SetLog("No achievement rewards to collect", $COLOR_INFO)
			SetDebugLog("Achievement counter not found on main screen", $COLOR_ERROR)
			ExitLoop
		EndIf
		
		;Check if MyProfile window Opened correctly
		Local $aImgAchievementsMyProfile = decodeSingleCoord(findImage("MyProfile", $g_sImgAchievementsMyProfile, GetDiamondFromRect("100, 66, 275, 55"), 1, True)) ; Resolution changed ?
		If UBound($aImgAchievementsMainScreen) > 1 Then
			SetDebugLog("My Profile window opened successfully", $COLOR_SUCCESS)
			If _Sleep(1500) Then Return
		Else
			SetDebugLog("My Profile window failed to open", $COLOR_ERROR)
			ClickAway()
			ExitLoop
		EndIf

		If Not CollectAchievementsClaimReward() Then
			SetDebugLog("There are no achievement rewards to collect", $COLOR_INFO)
			ClickAway()
			Return
		EndIf
		ClickAway()
		If _Sleep(1500) Then Return
		If Not IsMainPage() Then ExitLoop
	WEnd

	If _Sleep(1000) Then Return
	SetDebugLog("All achievment rewards collected successfully", $COLOR_SUCCESS)
	ClickAway()
	Return
EndFunc   ;==>CollectAchievements


Func CollectAchievementsRandomization() ; Add some randomization to avoid running the check every loop if a friend request exists

	If $g_iCollectAchievementsRunOn = 0 Then ; Run on first loop
		SetDebugLog("First Run so set randomization parameters and collect", $COLOR_INFO)
		$g_iCollectAchievementsRunOn = Random(2, 5, 1)
		$g_iCollectAchievementsLoopCount = $g_iCollectAchievementsLoopCount + 1
		Return True
	ElseIf $g_iCollectAchievementsLoopCount = $g_iCollectAchievementsRunOn Then ; Run if loop count matches random value
		SetDebugLog("Loop count matches, lets collect!", $COLOR_SUCCESS)
		Return True
	Else ; Return false in none of the above conditions match
		SetDebugLog("Skipping collection for randomization.", $COLOR_INFO)
		SetDebugLog("Collection will happen in '" & $g_iCollectAchievementsRunOn - $g_iCollectAchievementsLoopCount & "' more loops", $COLOR_INFO)
		$g_iCollectAchievementsLoopCount = $g_iCollectAchievementsLoopCount + 1
		Return False
	EndIf
EndFunc   ;==>CollectAchievementsRandomization


Func CollectAchievementsScroll()

	ClickDrag(70, 630 + $g_iBottomOffsetYFixed, 70, 220 + $g_iMidOffsetYFixed) ; Resolution changed
	If _Sleep(1000) Then Return

	Local $aImgAchievementsScrollEnd = decodeSingleCoord(findImage("ScrollEnd", $g_sImgAchievementsScrollEnd, GetDiamondFromRect("50, 612, 250, 506"), 1, True)) ; Resolution changed
	If UBound($aImgAchievementsScrollEnd) > 1 Then
		SetDebugLog("End of achievements list located", $COLOR_INFO)
		$g_iFoundScrollEnd = $g_iFoundScrollEnd + 1
		If _Sleep(1500) Then Return
	Else
		SetDebugLog("End of achievements list not found", $COLOR_INFO)
		SetDebugLog("Continue searching", $COLOR_INFO)
		If _Sleep(1500) Then Return
	EndIf
EndFunc   ;==>CollectAchievementsScroll


Func CollectAchievementsClaimReward()
	;Check Profile for Achievements and collect
	If Not $g_bRunState Then Return

	Local $sSearchArea = GetDiamondFromRect("660, 116, 845, 631") ; Resolution changed
	Local $aClaimButtons = findMultiple($g_sImgAchievementsClaimReward, $sSearchArea, $sSearchArea, 0, 1000, 0, "objectname,objectpoints", True)
	If IsArray($aClaimButtons) And UBound($aClaimButtons) > 0 Then
		For $i = 0 To UBound($aClaimButtons) - 1
			Local $aTemp = $aClaimButtons[$i]
			Local $aClaimButtonXY = decodeMultipleCoords($aTemp[1])
			For $i = 0 To UBound($aClaimButtonXY) - 1
				Local $aTemp = $aClaimButtonXY[$i]
				Click($aTemp[0], $aTemp[1])
				SetLog("Achievement reward collected", $COLOR_SUCCESS)
				If _Sleep(1500) Then Return
			Next
		Next
		Return True
	Else
		SetLog("No achievement rewards to collect", $COLOR_INFO)
		Return False
	EndIf
EndFunc   ;==>CollectAchievementsClaimReward

