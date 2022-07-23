; #FUNCTION# ====================================================================================================================
; Name ..........: -
; Description ...:
; Syntax ........: BoostResourcePotion()
; Parameters ....:
; Return values .: None
; Author ........: (Boldina) boludoz - 2018 / 2021 - (FOR RK MOD/AIO Mod++) (When you hold a mod for 4 years, talk about me.)
; Modified ......:
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func DbgBuilderPotionBoost($iDbgTotalBuilderCount = 5, $iDbgFreeBuilderCount = 5)

	Local $iTmpDbgTotalBuilderCount = $g_iTotalBuilderCount
	Local $iTmpDbgFreeBuilderCount = $g_iFreeBuilderCount

	$g_iTotalBuilderCount = $iDbgTotalBuilderCount
	$g_iFreeBuilderCount = $iDbgFreeBuilderCount

	Local $bResult = BuilderPotionBoost(True)

	$g_iTotalBuilderCount = $iTmpDbgTotalBuilderCount
	$g_iFreeBuilderCount = $iTmpDbgFreeBuilderCount

	Return $bResult
EndFunc   ;==>DbgBuilderPotionBoost

Func AlreadyBoosted()
	Local $aBoostBtn = findButton("BoostOne")
	If UBound($aBoostBtn) > 1 And not @error Then
		If UBound(_PixelSearch($aBoostBtn[0], $aBoostBtn[1], $aBoostBtn[0] + 25, $aBoostBtn[1] + 41, Hex(0xD5FE95, 6), 35, True)) > 0 And not @error Then
			Return True
		EndIf
	EndIf
	Return False
EndFunc   ;==>AlreadyBoosted

Func ResourceBoost($aPos1 = 0, $aPos2 = 0)
	If Not $g_bChkResourcePotion Then Return
	
	ClickAway()
	
	If Not IsMainPage(5) Then Return False
	
	If Not (($g_iInputGoldItems >= $g_aiTempGainCost[0]) And ($g_iInputElixirItems >= $g_aiTempGainCost[1]) And ($g_iInputDarkElixirItems >= $g_aiTempGainCost[2])) Then Return

	Static $iLastTimeChecked = $g_PreResetZero

	If $iLastTimeChecked[Number($g_iCurAccount)] = 0 And isInsideDiamondInt($aPos1, $aPos2) Then
		If _Sleep($DELAYBOOSTHEROES2) Then Return

		BuildingClick($aPos1, $aPos2 + 25)
		If _Sleep($DELAYBOOSTHEROES2) Then Return
		
		ForceCaptureRegion()
		Local $aResult = BuildingInfo(242, 490 + $g_iBottomOffsetY)
		If $aResult[0] > 1 Then
			Local $sN = $aResult[1]      ; Store bldg name
			Local $sL = $aResult[2]      ; Sotre bdlg level
			If Number($sL) > 0 Then      ; Multi Language
				; Structure located
				SetLog("Find " & $sN & " (Level " & $sL & ") located at " & $aPos1 & ", " & $aPos2, $COLOR_SUCCESS)
				
				If AlreadyBoosted() Then
					Setlog("Already boosted.", $COLOR_INFO)
					$iLastTimeChecked[Number($g_iCurAccount)] = 1
					Return
				EndIf
				
				If BoostPotionMod("ResourcePotion") Then
					$iLastTimeChecked[Number($g_iCurAccount)] = 1
					Return True
				Else
					Return False
				EndIf
			EndIf
		EndIf
	Else
		;Setlog("Magic Items| Fail resource potion.", $COLOR_ERROR)
		Return False
	EndIf
	Return False
EndFunc   ;==>ResourceBoost

Func LabPotionBoost($bDebug = False)
	If Not $g_bChkLabPotion Then Return False
	
	If Not IsMainPage(1) Then Return False

	Static $iLastTimeChecked = $g_PreResetZero

	If $iLastTimeChecked[Number($g_iCurAccount)] = 0 Then
		If _Sleep($DELAYBOOSTHEROES2) Then Return
		
		If (Number(_DateDiff("h", _NowCalc(), $g_sLabUpgradeTime)) > Int($g_iInputLabPotion)) Or Int($g_iInputLabPotion) = 0 Then

			If Not FindResearchButton(True) Then 
				;Click Laboratory
				BuildingClickP($g_aiLaboratoryPos, "#0197") ; Team AIO Mod++
				If _Sleep($DELAYLABORATORY3) Then Return ; Wait for window to open
			EndIf
			
			If AlreadyBoosted() Then
				Setlog("Already boosted lab.", $COLOR_INFO)
				$iLastTimeChecked[Number($g_iCurAccount)] = 1
				Return True
			EndIf

			; If Not FindResearchButton(True) Then Return False ; adieu bye bye
		
			If BoostPotionMod("LabPotion", $bDebug) Then
				$iLastTimeChecked[Number($g_iCurAccount)] = 1
				Return True
			EndIf
		EndIf
	EndIf

	Return False
EndFunc   ;==>LabPotionBoost

; BoostPotionMod("LabPotion", False)
Func BoostPotionMod($sName, $bDebug = False)
	
	Local $aFiles = _FileListToArray($g_sImgPotionsBtn, $sName & "*.*", $FLTA_FILES)
	If UBound($aFiles) > 1 And not @error Then
		Local $aCoords = decodeSingleCoord(findImage($aFiles[1], $g_sImgPotionsBtn & "\" & $aFiles[1], GetDiamondFromComma(198, 477, 678, 585), 1, True))
		If UBound($aCoords) > 1 And Not @error Then
			Setlog("Magic Items : boosting " & $sName, $COLOR_INFO)
			ClickP($aCoords, 1)
			If _Sleep(1500) Then Return False
			
			If WaitforPixel(391, 314 + $g_iMidOffsetYFixed, 455, 500 + $g_iBottomOffsetYFixed, Hex(0xE1E3CB, 6), 15, 15) Then ; Resolution changed
				If $bDebug = False Then
					Click(420, 418 + $g_iMidOffsetYFixed, 1) ; Resolution changed
				Else
					ClickAway(Default, True)
				EndIf
				
				SetLog("Potion used: " & $sName & ".", $COLOR_SUCCESS)
				If _Sleep(500) Then Return False
				Return True
				
			Else
				SetLog("No potion for boost: " & $sName & ".", $COLOR_INFO)
			EndIf
		Else
			SetLog("No potion detected : " & $sName & ".", $COLOR_INFO) ; In short, mistakes are seen by people, not a group of VIPs.
		EndIf
	Else
		SetLog("BoostPotionMod: No files found.", $COLOR_INFO)
	EndIf
	ClickAway()
	Return False
EndFunc   ;==>BoostPotionMod

; Builder Status - Team AIO Mod++
Func BuilderPotionBoost($bDebug = False)
	If Not $g_bChkBuilderPotion Then Return
	
	If Abs($g_iFreeBuilderCount - $g_iTotalBuilderCount) >= $g_iInputBuilderPotion + 1 Or $bDebug Then

		Local $iBuilderTime = -1, $iTimeFromLastCheck = -1, $sBuilderTimeLastCheck = ""
		Static $asBuilderTimeLastCheck[$g_eTotalAcc]
		$sBuilderTimeLastCheck = $asBuilderTimeLastCheck[Number($g_iCurAccount)]
	
		If _DateIsValid($sBuilderTimeLastCheck) And not $bDebug Then
			$iTimeFromLastCheck = Int(_DateDiff('s', $sBuilderTimeLastCheck, _NowCalc())) ; elapse time in minutes
	
			SetDebugLog("Magic Items | It has been " & $iTimeFromLastCheck & " s since last check (" & $sBuilderTimeLastCheck & ")")
	
			If $iTimeFromLastCheck <= 21600 Then
				SetDebugLog("$iTimeFromLastCheck: " & $iTimeFromLastCheck)
				If $bDebug = False Then Return
			EndIf
		EndIf
	
		If _Sleep($DELAYBOOSTHEROES2 * 3) Then Return False
	
		If IsMainPage() Then Click(293, 32) ; click builder's nose for poping out information
		If _Sleep($DELAYBOOSTHEROES2 * 2) Then Return
	
		Local $sBuilderTime = ""
		
		For $i = 0 To 2
			$sBuilderTime = QuickMIS("OCR", @ScriptDir & "\imgxml\BuilderTime", 335, 102 + $g_iMidOffsetYFixed, 465, 124 + $g_iMidOffsetYFixed, True) ; Resolution changed
			If StringInStr($sBuilderTime, "h") > 0 Or StringInStr($sBuilderTime, "m") > 0 Then
				$iBuilderTime = ConvertOCRLongTime("Builder Time", $sBuilderTime, False)
				SetDebugLog("$sResult QuickMIS OCR: " & $sBuilderTime & " (" & Round($iBuilderTime,2) & " minutes)")
				If $iBuilderTime > 0 Then
					$asBuilderTimeLastCheck[Number($g_iCurAccount)] = _NowCalc()
					SetLog("Magic Items | Builder will be free in : " & $sBuilderTime, $COLOR_SUCCESS)
				EndIf
				ExitLoop
			Else
				Swipe(344, 124, 344, 374, 1000)
				If _Sleep($DELAYBOOSTHEROES2 * 2) Then Return
			EndIf
		Next
					
		If Number($iBuilderTime) < 600 And $bDebug = False Then
			SetLog("Magic Items | Less than 10 hours left, it's not worth using the builder potion", $COLOR_INFO)
			ClickAway(Default, True)
			Return False
		EndIf
			
		Click(Random(212, 453, 1), Random(114, 129, 1))
		If _Sleep($DELAYBOOSTHEROES2) Then Return
		
		ForceCaptureRegion()
		Local $aResult = getNameBuilding(242, 490 + $g_iBottomOffsetY)
		If $aResult <> "" Then
			If _Sleep($DELAYBOOSTHEROES2) Then Return
			
			If BoostPotionMod("BuilderPotion", $bDebug) Then
				Return True
			Else
				Setlog("Magic Items | No builder potion.", $COLOR_ERROR)
			EndIf
			
		Else
			Setlog("Magic Items| OCR Fail.", $COLOR_ERROR)
		EndIf
		ClickAway(Default, True, 2) ;Click Away
	Else
		Setlog("Magic Items | Condition not met.", $COLOR_WARNING)
	EndIf
	Return False
EndFunc   ;==>BuilderPotionBoost

Func ConvertOCRLongTime($WhereRead, $ToConvert, $bSetLog = True) ; Convert longer time with days - hours - minutes - seconds

	Local $iRemainTimer = 0, $aResult, $iDay = 0, $iHour = 0, $iMinute = 0, $iSecond = 0

	If $ToConvert <> "" Then
		If StringInStr($ToConvert, "d") > 1 Then
			$aResult = StringSplit($ToConvert, "d", $STR_NOCOUNT)
			; $aResult[0] will be the Day and the $aResult[1] will be the rest
			$iDay = Number($aResult[0])
			$ToConvert = $aResult[1]
		EndIf
		If StringInStr($ToConvert, "h") > 1 Then
			$aResult = StringSplit($ToConvert, "h", $STR_NOCOUNT)
			$iHour = Number($aResult[0])
			$ToConvert = $aResult[1]
		EndIf
		If StringInStr($ToConvert, "m") > 1 Then
			$aResult = StringSplit($ToConvert, "m", $STR_NOCOUNT)
			$iMinute = Number($aResult[0])
			$ToConvert = $aResult[1]
		EndIf
		If StringInStr($ToConvert, "s") > 1 Then
			$aResult = StringSplit($ToConvert, "s", $STR_NOCOUNT)
			$iSecond = Number($aResult[0])
		EndIf

		$iRemainTimer = Round($iDay * 24 * 60 + $iHour * 60 + $iMinute + $iSecond / 60, 2)
		If $iRemainTimer = 0 And $g_bDebugSetlog Then SetLog($WhereRead & ": Bad OCR string", $COLOR_ERROR)

		If $bSetLog Then SetLog($WhereRead & " time: " & StringFormat("%.2f", $iRemainTimer) & " min", $COLOR_INFO)

	Else
		If $g_bDebugSetlog Then SetLog("Can not read remaining time for " & $WhereRead, $COLOR_ERROR)
	EndIf
	Return $iRemainTimer
EndFunc   ;==>ConvertOCRLongTime
