; #FUNCTION# ====================================================================================================================
; Name ..........: getArmySiegeMachines
; Description ...: Obtain the current trained Siege Machines
; Syntax ........: getArmySiegeMachines()
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

Func getArmySiegeMachines($bOpenArmyWindow = False, $bCloseArmyWindow = False, $bCheckWindow = False, $bSetLog = True, $bNeedCapture = True)

	;If $g_iTotalTrainSpaceSiege < 1 Then Return

	If $g_bDebugSetlogTrain Then SetLog("getArmySiegeMachines():", $COLOR_DEBUG)

	If Not $bOpenArmyWindow Then
		If $bCheckWindow And Not IsTrainPage() Then ; check for train page
			SetError(1)
			Return ; not open, not requested to be open - error.
		EndIf
	ElseIf $bOpenArmyWindow Then
		If Not OpenArmyOverview(True, "getArmySiegeMachines()") Then
			SetError(2)
			Return ; not open, requested to be open - error.
		EndIf
		If _Sleep($DELAYCHECKARMYCAMP5) Then Return
	EndIf

	If _CheckPixel($aRecievedTroops, $bNeedCapture) Then ; Found the "You have recieved" Message on Screen, wait till its gone.
		If $bSetLog Then SetLog("Detected Clan Castle Message Blocking Troop Images. Waiting until it's gone", $COLOR_INFO)
		_CaptureRegion2()
		While _CheckPixel($aRecievedTroops, False)
			IF _Sleep($DELAYTRAIN1) Then Return
		WEnd
	EndIf

	Local $sSiegeDiamond = GetDiamondFromRect("605,171,840,211") ; Contains iXStart, $iYStart, $iXEnd, $iYEnd ; Resolution changed
	If $g_bDebugFuncTime Then StopWatchStart("findMultiple, \imgxml\ArmyOverview\SiegeMachines")
	Local $aCurrentSiegeMachines = findMultiple(@ScriptDir & "\imgxml\ArmyOverview\SiegeMachines", $sSiegeDiamond, $sSiegeDiamond, 0, 1000, 0, "objectname,objectpoints", $bNeedCapture) ; Returns $aCurrentSiegeMachines[index] = $aArray[2] = ["Siege M Shortname", CordX,CordY]
	If $g_bDebugFuncTime Then StopWatchStopLog()

	Local $aTempSiegeArray, $aSiegeCoords
	Local $sSiegeName = ""
	Local $iSiegeIndex = -1
	Local $aCurrentTroopsEmpty[$eSiegeMachineCount] = [0, 0, 0, 0, 0, 0] ; Local Copy to reset Siege Machine Array

	; Get Siege Capacities
	Local $sSiegeInfo = getArmyCampCap(758, 164, $bNeedCapture) ; OCR read Siege built and total
	If $g_bDebugSetlogTrain Then SetLog("OCR $sSiegeInfo = " & $sSiegeInfo, $COLOR_DEBUG)
	Local $aGetSiegeCap = StringSplit($sSiegeInfo, "#", $STR_NOCOUNT) ; split the built Siege number from the total Siege number
	If Ubound($aGetSiegeCap) = 2 Then
		If $bSetLog Then SetLog("Total Siege Workshop Capacity: " & $aGetSiegeCap[0] & "/" & $aGetSiegeCap[1])
		$g_aiCurrentSiegeMachines = $aCurrentTroopsEmpty ; Reset Current Siege Machine Array
		If Number($aGetSiegeCap[0]) = 0 then Return
	Else
		Return
	EndIf

	If UBound($aCurrentSiegeMachines, 1) >= 1 Then
		For $i = 0 To UBound($aCurrentSiegeMachines, 1) - 1 ; Loop through found Troops
			$aTempSiegeArray = $aCurrentSiegeMachines[$i] ; Declare Array to Temp Array

			$iSiegeIndex = TroopIndexLookup($aTempSiegeArray[0], "getArmySiegeMachines()") - $eWallW ; Get the Index of the Siege M from the ShortName

			$aSiegeCoords = StringSplit($aTempSiegeArray[1], ",", $STR_NOCOUNT) ; Split the Coordinates where the Troop got found into X and Y

			If $iSiegeIndex < 0 Then ContinueLoop

			$g_aiCurrentSiegeMachines[$iSiegeIndex] = Number(getBarracksNewTroopQuantity(Slot($aSiegeCoords[0], $aSiegeCoords[1]), 196, $bNeedCapture)) ; Get The Quantity of the Troop, Slot() Does return the exact spot to read the Number from

			$sSiegeName = $g_aiCurrentSiegeMachines[$iSiegeIndex] >= 2 ? $g_asSiegeMachineNames[$iSiegeIndex] & "s" : $g_asSiegeMachineNames[$iSiegeIndex] & ""

			If $g_bDebugSetlogTrain Then Setlog($sSiegeName & " Coord: (" & $aSiegeCoords[0] & "," & $aSiegeCoords[1] & ") Quant :" & $g_aiCurrentSiegeMachines[$iSiegeIndex])
			If $g_bDebugSetlogTrain Then Setlog($sSiegeName & " Slot (" & Slot($aSiegeCoords[0], $aSiegeCoords[1]) & "," & 196 & ")")

			If $bSetLog Then SetLog(" - " & $g_aiCurrentSiegeMachines[$iSiegeIndex] & " " & $sSiegeName & " Available", $COLOR_SUCCESS)
		Next
	EndIf

	If $bCloseArmyWindow Then
		ClickAway()
		If _Sleep($DELAYCHECKARMYCAMP4) Then Return
	EndIf
EndFunc   ;==>getArmySiegeMachines
