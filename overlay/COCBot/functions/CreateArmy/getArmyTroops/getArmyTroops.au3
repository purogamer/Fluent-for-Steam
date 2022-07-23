; #FUNCTION# ====================================================================================================================
; Name ..........: getArmyTroops
; Description ...: Obtain the current trained Troops
; Syntax ........: getArmyTroops()
; Parameters ....:
; Return values .:
; Author ........: Fliegerfaust(11-2017)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include <Array.au3>
#include <MsgBoxConstants.au3>


Func getArmyTroops($bOpenArmyWindow = False, $bCloseArmyWindow = False, $bCheckWindow = False, $bSetLog = True, $bNeedCapture = True)

	If $g_bDebugSetlogTrain Then SetLog("getArmyTroops():", $COLOR_DEBUG)

	If Not $bOpenArmyWindow Then
		If $bCheckWindow And Not IsTrainPage() Then ; check for train page
			SetError(1)
			Return ; not open, not requested to be open - error.
		EndIf
	ElseIf $bOpenArmyWindow Then
		If Not OpenArmyOverview(True, "getArmyTroops()") Then
			SetError(2)
			Return ; not open, requested to be open - error.
		EndIf
		If _Sleep($DELAYCHECKARMYCAMP5) Then Return
	EndIf

	If _CheckPixel($aRecievedTroops, $bNeedCapture) Then ; Found the "You have recieved" Message on Screen, wait till its gone.
		If $bSetLog Then SetLog("Detected Clan Castle Message Blocking Troop Images. Waiting until it's gone", $COLOR_INFO)
		_CaptureRegion2()
		While _CheckPixel($aRecievedTroops, False)
			If _Sleep($DELAYTRAIN1) Then Return
		WEnd
	EndIf

	Local $sTroopDiamond = GetDiamondFromRect("23,171,585,216") ; Contains iXStart, $iYStart, $iXEnd, $iYEnd ; Resolution changed
	If $g_bDebugFuncTime Then StopWatchStart("findMultiple, \imgxml\ArmyOverview\Troops")
	Local $aCurrentTroops = findMultiple(@ScriptDir & "\imgxml\ArmyOverview\Troops", $sTroopDiamond, $sTroopDiamond, 0, 1000, 0, "objectname,objectpoints", $bNeedCapture) ; Returns $aCurrentTroops[index] = $aArray[2] = ["TroopShortName", CordX,CordY]
	If $g_bDebugFuncTime Then StopWatchStopLog()

   ;_ArrayDisplay($aCurrentTroops, "$aCurrentTroops")

	Local $aTempTroopArray, $aTroopCoords
	Local $sTroopName = ""
	Local $iTroopIndex = -1, $iDropTrophyIndex = -1
	Local $aCurrentTroopsEmpty[$eTroopCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0] ; Local Copy to reset Troops Array
	Local $aTroopsForTropyDropEmpty[8][2] = [["Barb", 0], ["Arch", 0], ["Giant", 0], ["Wall", 0], ["Gobl", 0], ["Mini", 0], ["Ball", 0], ["Wiza", 0]] ; Local Copy to reset Troop Drop Trophy Array
	Local $aCurrentTroopsLog[0][3] ; [0] = Name [1] = Quantities [3] Xaxis

	$g_aiCurrentTroops = $aCurrentTroopsEmpty ; Reset Current Troops Array
	$g_avDTtroopsToBeUsed = $aTroopsForTropyDropEmpty ; Reset Drop Trophy Troops Array
	If UBound($aCurrentTroops, 1) >= 1 Then
		For $i = 0 To UBound($aCurrentTroops, 1) - 1 ; Loop through found Troops
			$aTempTroopArray = $aCurrentTroops[$i] ; Declare Array to Temp Array

			$iTroopIndex = TroopIndexLookup($aTempTroopArray[0], "getArmyTroops()") ; Get the Index of the Troop from the ShortName

			$aTroopCoords = StringSplit($aTempTroopArray[1], ",", $STR_NOCOUNT) ; Split the Coordinates where the Troop got found into X and Y

			If $iTroopIndex = -1 Then ContinueLoop

			$g_aiCurrentTroops[$iTroopIndex] = Number(getBarracksNewTroopQuantity(Slot($aTroopCoords[0], $aTroopCoords[1]), 196, $bNeedCapture)) ; Get The Quantity of the Troop, Slot() Does return the exact spot to read the Number from

			$iDropTrophyIndex = _ArraySearch($g_avDTtroopsToBeUsed, $aTempTroopArray[0]) ; Search the Troops ShortName in the Drop Trophy Global to check if it is a Drop Trophy Troop
			If $iDropTrophyIndex <> -1 Then $g_avDTtroopsToBeUsed[$iDropTrophyIndex][1] += $g_aiCurrentTroops[$iTroopIndex] ; If there was a Match in the Array then add the Troop Quantity to it

			$sTroopName = $g_aiCurrentTroops[$iTroopIndex] >= 2 ? $g_asTroopNamesPlural[$iTroopIndex] : $g_asTroopNames[$iTroopIndex] ; Select the right Troop Name, If more than one then use the Plural
			_ArrayAdd($aCurrentTroopsLog, $sTroopName & "|" & $g_aiCurrentTroops[$iTroopIndex] & "|" & Slot($aTroopCoords[0], $aTroopCoords[1]))

		Next
	EndIf

	; Just a good log from left to right
	_ArraySort($aCurrentTroopsLog, 0, 0, 0, 2)
	For $index = 0 To UBound($aCurrentTroopsLog) - 1
		If $aCurrentTroopsLog[$index][1] > 0 And $bSetLog Then SetLog(" - " & $aCurrentTroopsLog[$index][1] & " " & $aCurrentTroopsLog[$index][0] & " Available", $COLOR_SUCCESS)
	Next

	If $bCloseArmyWindow Then
		ClickAway()
		If _Sleep($DELAYCHECKARMYCAMP4) Then Return
	EndIf
EndFunc   ;==>getArmyTroops