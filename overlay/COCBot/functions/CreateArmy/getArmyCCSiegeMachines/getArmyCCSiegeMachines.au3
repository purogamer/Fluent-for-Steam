; #FUNCTION# ====================================================================================================================
; Name ..........: getArmyCCSiegeMachines
; Description ...: Obtain the current Clan Castle Siege Machines
; Syntax ........: getArmyCCSiegeMachines()
; Parameters ....:
; Return values .:
; Author ........: Fliegerfaust(06-2018)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func getArmyCCSiegeMachines($bOpenArmyWindow = False, $bCloseArmyWindow = False, $bCheckWindow = False, $bSetLog = True, $bNeedCapture = True)

	If $g_bDebugSetlogTrain Then SetLog("getArmyCCSiegeMachines():", $COLOR_DEBUG)

	If $g_iTownHallLevel < 10 Then Return

	If Not $bOpenArmyWindow Then
		If $bCheckWindow And Not IsTrainPage() Then ; check for train page
			SetError(1)
			Return ; not open, not requested to be open - error.
		EndIf
	ElseIf $bOpenArmyWindow Then
		If Not OpenArmyOverview(True, "getArmyCCSiegeMachines()") Then
			SetError(2)
			Return ; not open, requested to be open - error.
		EndIf
		If _Sleep($DELAYCHECKARMYCAMP5) Then Return
	EndIf

	Local $sCCSiegeDiamond = GetDiamondFromRect("620,466,710,544") ; Contains iXStart, $iYStart, $iXEnd, $iYEnd ; Resolution changed
	If $g_bDebugFuncTime Then StopWatchStart("findMultiple, \imgxml\ArmyOverview\SiegeMachines")
	Local $aCurrentCCSiegeMachines = findMultiple(@ScriptDir & "\imgxml\ArmyOverview\SiegeMachines", $sCCSiegeDiamond, $sCCSiegeDiamond, 0, 1000, 0, "objectname,objectpoints", $bNeedCapture) ; Returns $aCurrentSiegeMachines[index] = $aArray[2] = ["Siege M Shortname", CordX,CordY]
	If $g_bDebugFuncTime Then StopWatchStopLog()

	Local $aTempCCSiegeArray, $aCCSiegeCoords
	Local $sCCSiegeName = ""
	Local $iCCSiegeIndex = -1
	Local $aCurrentCCSiegeEmpty[$eSiegeMachineCount] = [0, 0, 0, 0, 0, 0] ; Local Copy to reset Siege Machine Array

	$g_aiCurrentCCSiegeMachines = $aCurrentCCSiegeEmpty ; Reset Current Siege Machine Array

	; Get CC Siege Capacities
	Local $sSiegeInfo = getArmyCampCap(650, 468, $bNeedCapture) ; OCR read Siege built and total
	If $g_bDebugSetlogTrain Then SetLog("OCR $sSiegeInfo = " & $sSiegeInfo, $COLOR_DEBUG)
	Local $aGetSiegeCap = StringSplit($sSiegeInfo, "#", $STR_NOCOUNT) ; split the built Siege number from the total Siege number
	If $bSetLog And Ubound($aGetSiegeCap) = 2 Then
		SetLog("Total Siege CC Capacity: " & $aGetSiegeCap[0] & "/" & $aGetSiegeCap[1])
		If Number($aGetSiegeCap[0]) = 0 then Return
	Else
		Return
	EndIf

	If UBound($aCurrentCCSiegeMachines, 1) >= 1 Then
		For $i = 0 To UBound($aCurrentCCSiegeMachines, 1) - 1 ; Loop through found Troops
			$aTempCCSiegeArray = $aCurrentCCSiegeMachines[$i] ; Declare Array to Temp Array

			$iCCSiegeIndex = TroopIndexLookup($aTempCCSiegeArray[0], "getArmyCCSiegeMachines()") - $eWallW ; Get the Index of the Siege M from the ShortName

			$aCCSiegeCoords = StringSplit($aTempCCSiegeArray[1], ",", $STR_NOCOUNT) ; Split the Coordinates where the Troop got found into X and Y

			If $iCCSiegeIndex < 0 Then ContinueLoop

			$g_aiCurrentCCSiegeMachines[$iCCSiegeIndex] = Number(getBarracksNewTroopQuantity(650, 498, $bNeedCapture)) ; Get The Quantity of the Troop, Slot() Does return the exact spot to read the Number from

			$sCCSiegeName = $g_aiCurrentCCSiegeMachines[$iCCSiegeIndex] >= 2 ? $g_asSiegeMachineNames[$iCCSiegeIndex] & "s" : $g_asSiegeMachineNames[$iCCSiegeIndex] & ""

			If $g_bDebugSetlogTrain Then Setlog($sCCSiegeName & " Coord: (" & $aCCSiegeCoords[0] & "," & $aCCSiegeCoords[1] & ") Quant :" & $g_aiCurrentCCSiegeMachines[$iCCSiegeIndex])
			If $g_bDebugSetlogTrain Then Setlog($sCCSiegeName & " Slot (" & 650 & "," & 498 & ")")

			If $bSetLog Then SetLog(" - " & $g_aiCurrentCCSiegeMachines[$iCCSiegeIndex] & " " & $sCCSiegeName & " Available", $COLOR_SUCCESS)
		Next
	EndIf

	If $bCloseArmyWindow Then
		ClickAway()
		If _Sleep($DELAYCHECKARMYCAMP4) Then Return
	EndIf
EndFunc   ;==>getArmyTroops
