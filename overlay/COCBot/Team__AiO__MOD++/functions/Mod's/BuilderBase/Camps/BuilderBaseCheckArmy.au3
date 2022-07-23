; #FUNCTION# ====================================================================================================================
; Name ..........: CheckArmyBuilderBase
; Description ...: Use on Builder Base attack
; Syntax ........: CheckArmyBuilderBase()
; Parameters ....:
; Return values .: None
; Author ........: Boludoz (redo) (2019), ProMac (03-2018), Fahid.Mahmood
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as Multibot and ClashGameBot. Copyright 2015-2020
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once
Global $g_aTroopButton = 0


Func TestCheckArmyBuilderBase() ; ProMac (03-2018), Fahid.Mahmood part.
	SetDebugLog("** TestCheckArmyBuilderBase START**", $COLOR_DEBUG)
	Local $Status = $g_bRunState
	$g_bRunState = True
	CheckArmyBuilderBase(True)
	$g_bRunState = $Status
	SetDebugLog("** TestCheckArmyBuilderBase END**", $COLOR_DEBUG)
EndFunc   ;==>TestCheckArmyBuilderBase

Func CheckArmyBuilderBase($bDebug = False)

	FuncEnter(CheckArmyBuilderBase)
	If Not $g_bRunState Then Return
	If Not IsMainPageBuilderBase() Then Return

	SetDebugLog("** Click Away **", $COLOR_DEBUG)

	ClickAway() ; ClickP($aAway, 1, 0, "#0332") ;Click Away

	Setlog("Entering troops", $COLOR_PURPLE)

	; Check the Train Button
	If Not _ColorCheck(_GetPixelColor($aArmyTrainButtonBB[0], $aArmyTrainButtonBB[1], True), _
			Hex($aArmyTrainButtonBB[2], 6), $aArmyTrainButtonBB[3]) Then Return

	SetDebugLog("** Check the Train Button Detected**", $COLOR_DEBUG)

	; Click on that Button
	Click($aArmyTrainButton[0], $aArmyTrainButton[1], 1, 0, "#0347") ; Click Button Army Overview

	; Wait for Window
	If Not _WaitForCheckImg($g_sImgPathFillArmyCampsWindow, "278, 321, 411, 376") Then ; Resolution changed
		Setlog("Can't Open The Fill Army Camps Window!", $COLOR_DEBUG)
		ClickAway() ; ClickP($aAway, 1, 0, "#0332") ;Click Away
		Return
	EndIf

	SetDebugLog("** Fill Army Camps Window Detected **", $COLOR_DEBUG)

	DetectCamps()

	Setlog("Exit from Camps!", $COLOR_PURPLE)
	ClickAway() ; ClickP($aAway, 1, 0, "#0332") ;Click Away
	FuncReturn()

EndFunc   ;==>CheckArmyBuilderBase

Func DetectCamps()
	Local $iArmyCampsInBB[6] = [0, 0, 0, 0, 0, 0]
	Local $asAttackBarBB = $g_asAttackBarBB
	Local $bDebugLog = False
	If $g_bDebugBBattack Then $bDebugLog = True

	If _Sleep(Random(500, 1000, 1)) Then Return

	; Result [X][0] = NAME , [x][1] = Xaxis , [x][2] = Yaxis , [x][3] = Level
	Local $aResults = _ImageSearchXML($g_sImgPathCamps, 10, "40,187,820,400", True, $bDebugLog) ; Cantidad de campametos

	If $aResults = -1 Or Not IsArray($aResults) Then Return -1
	Setlog("Detected " & UBound($aResults) & " Camp(s).")

	; Limit GUI camps and Camps ($iArmyCampsBB).
	Local $aCmbCampsInBBGUILimited = _ArrayExtract($g_iCmbCampsBB, 0, UBound($aResults) - 1)

	; Limit Camps of game to detected
	Local $iArmyCampsInBBLimited = _ArrayExtract($iArmyCampsInBB, 0, UBound($aResults) - 1)

	; Fill $iArmyCampsBB (only one capture like FreeMagicItems system)
	Local $aTroops = _ImageSearchXML($g_sImgPathTroopsTrain, 100, "40, 242, 820, 330", True, $bDebugLog) ; Troops in camps
	;_ArrayDisplay($aTroops)

	; Train matrix
	Local $aTrainLikeBoss[$g_iBBTroopCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
	Local $aTrainedLikeBoss[$g_iBBTroopCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

	; Translate $aCmbCampsInBBGUILimited to $aTrainLikeBoss.
	For $i = 0 To UBound($aCmbCampsInBBGUILimited) - 1
		Local $i2 = $aCmbCampsInBBGUILimited[$i]
		$aTrainLikeBoss[$i2] += 1
	Next
	
	; Is in camp.
	For $i2 = 0 To UBound($aTroops) - 1
		;	If ((Int($iX - 20) < $aTroops[$i2][1]) And (Int($iX + 100) > $aTroops[$i2][1])) Then
		Local $iA = __ArraySearch($asAttackBarBB, $aTroops[$i2][0])
		If ($iA > -1) Then
			If (Int($aTrainLikeBoss[$iA]) < Int($aTrainedLikeBoss[$iA])) Then
				DeleteTroop($aTroops[$i2][1], $aTroops[$i2][2])
			Else
				$aTrainedLikeBoss[$iA] += 1
				$aTrainLikeBoss[$iA] -= 1
			EndIf
		Else
			DeleteTroop($aTroops[$i2][1], $aTroops[$i2][2])
		EndIf
	Next
	
	; Troops Train
	Local $iFillFix = 0 ; Barb Default
	For $i = 0 To UBound($aTrainLikeBoss) - 1
		If ($i = 0) Then SetLog("Builder base army - Train check.", $COLOR_SUCCESS)
		If ($aTrainLikeBoss[$i] <> 0) And Not StringIsSpace($aTrainLikeBoss[$i]) Then
			Local $aLocateTroopButton = LocateTroopButton($i)
			;_ArrayDisplay($aLocateTroopButton, $i)
			If IsArray($aLocateTroopButton) Then
				SetLog("- x" & $aTrainLikeBoss[$i] & " " & $g_avStarLabTroops[$i + 1][3], $COLOR_SUCCESS)
				MyTrainClick($g_aTroopButton, $aTrainLikeBoss[$i])
				$iFillFix = $g_aTroopButton
			Else
				SetLog("Builder base army: LocateTroopButton troop not unlocked or fail.", $COLOR_ERROR)
				MyTrainClick($iFillFix, $aTrainLikeBoss[$i]) ; Train 4 fill last "ok" (more smart)
			EndIf
		EndIf
		If _Sleep(Random((200 * 90) / 100, (300 * 110) / 100, 1), False) Then Return
	Next

EndFunc   ;==>DetectCamps

Func DeleteTroop($X, $Y, $bOnlyCheck = False)
	SetDebugLog("Red Coordinates: " & $X & "," & $Y)
	Local $saiArea2SearchOri[4] = [$X, 200, $X + 95, 227] ; Resolution changed
	Local $aAllResults = findMultipleQuick(@ScriptDir & "\COCBot\Team__AiO__MOD++\Images\BuilderBase\FillArmyCamps\Bundles\", 0, $saiArea2SearchOri, True, "Del", False, 25)
	If IsArray($aAllResults) Then
		_ArraySort($aAllResults, 0, 0, 0, 1)
		If $bOnlyCheck = False Then Click($aAllResults[0][1] + Random(0, 10, 1), Random(200, 227, 1), 1) ; Resolution changed
		Return True
	EndIf
	If $bOnlyCheck = False Then Setlog("Builder base army: Fail DeleteTroop.", $COLOR_ERROR)
	Return False
EndFunc   ;==>DeleteTroop

; Samkie inspired code
Func LocateTroopButton($iTroopButton, $sImgTrain = $g_sImgPathTroopsTrain, $sRegionForScan = "37, 479, 891, 579", $bDebugLog = False)
	Global $g_aTroopButton[2] = [0, 0]
	Local $asAttackBarBB = $g_asAttackBarBB
	Local $iButtonIsIn, $aTroopPosition
	
	
	If ($iTroopButton > (UBound($asAttackBarBB) - 1)) Then SetLog("Train army on BB: Troop not rocognized, it return first.", $COLOR_ERROR)
	
	For $i = 0 To 3
		Local $iButtonIsIn = __ArraySearch(_ImageSearchXML($g_sImgPathTroopsTrain, 0, $sRegionForScan, True, False, True, 25), $g_asAttackBarBB[$iTroopButton])

		$aTroopPosition = $g_aImageSearchXML
		SetDebugLog("LocateTroopButton: " & "__ArraySearch($aTroopPosition, $asAttackBarBB[$iTroopButton]) " & $aTroopPosition)
		
		If ($iButtonIsIn > -1) Then
			$g_aTroopButton[0] = $aTroopPosition[$iButtonIsIn][1]
			$g_aTroopButton[1] = $aTroopPosition[$iButtonIsIn][2]
			Return $g_aTroopButton
		ElseIf __ArraySearch($asAttackBarBB, $aTroopPosition[0][0]) < $iTroopButton Then
			SetDebugLog("LocateTroopButton: " & "ClickDrag(575, 522 + $g_iBottomOffsetYFixed, 280, 522 + $g_iBottomOffsetYFixed, 50)") ; Resolution changed
			ClickDrag(575, 522 + $g_iBottomOffsetYFixed, 280, 522 + $g_iBottomOffsetYFixed, 50)
			If _Sleep(Random((400 * 90) / 100, (400 * 110) / 100, 1)) Then Return
		ElseIf __ArraySearch($asAttackBarBB, $aTroopPosition[UBound($aTroopPosition) - 1][0]) > $iTroopButton Then
			SetDebugLog("LocateTroopButton: " & "ClickDrag(280, 522 + $g_iBottomOffsetYFixed, 575, 522 + $g_iBottomOffsetYFixed, 50)") ; Resolution changed
			ClickDrag(280, 522 + $g_iBottomOffsetYFixed, 575, 522 + $g_iBottomOffsetYFixed, 50) ; Resolution changed
			If _Sleep(Random((400 * 90) / 100, (400 * 110) / 100, 1)) Then Return
		EndIf
		SetDebugLog("LocateTroopButton: " & "LOOP : " & $i)
		
		If _Sleep(500) Then Return
	Next
	
	SetLog("Cannot find " & $asAttackBarBB[$iTroopButton] & " for scan", $COLOR_ERROR)
	
	Global $g_aTroopButton = 0
	Return 0

EndFunc   ;==>LocateTroopButton

Func MyTrainClick($aXY, $iTimes = 1, $iSpeed = 0, $sdebugtxt = "")
	If Not IsArray($aXY) Then Return False
	Local $X = $aXY[0], $Y = $aXY[1]
	Local $iHLFClickMin = 7, $iHLFClickMax = 14
	Local $isldHLFClickDelayTime = 2000
	Local $iRandNum = Random($iHLFClickMin - 1, $iHLFClickMax - 1, 1)   ;Initialize value (delay awhile after $iRandNum times click)
	Local $iRandX = Random($X - 5, $X + 5, 1), $iRandY = Random($Y - 5, $Y + 5, 1)

	For $i = 0 To $iTimes - 1
		PureClick(Random($iRandX - 2, $iRandX + 2, 1), Random($iRandY - 2, $iRandY + 2, 1))
		If ($i >= $iRandNum) Then
			$iRandNum = $iRandNum + Random($iHLFClickMin, $iHLFClickMax, 1)
			$iRandX = Random($X - 5, $X + 5, 1)
			$iRandY = Random($Y - 5, $Y + 5, 1)
			If _Sleep(Random(($isldHLFClickDelayTime * 138) / 100, (($isldHLFClickDelayTime * 138) * 2) / 100, 1), False) Then Return
		Else
			If _Sleep(Random(($isldHLFClickDelayTime * 138) / 100, (($isldHLFClickDelayTime * 138) * 3) / 100, 1), False) Then Return
		EndIf
	Next
EndFunc   ;==>MyTrainClick
