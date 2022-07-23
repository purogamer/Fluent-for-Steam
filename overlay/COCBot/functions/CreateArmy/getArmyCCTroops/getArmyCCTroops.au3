; #FUNCTION# ====================================================================================================================
; Name ..........: getArmyCCTroops
; Description ...: Obtain the current Troops in the Clan Castle
; Syntax ........: getArmyCCTroops()
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

Func getArmyCCTroops($bOpenArmyWindow = False, $bCloseArmyWindow = False, $bCheckWindow = False, $bSetLog = True, $bNeedCapture = True, $bGetSlot = False)

	Local $aTroopWSlot[1][3] = [[0, "", 0]] ; X-Coord, Troop Name index, Quantity

	If $g_bDebugSetlogTrain Then SetLog("getArmyCCTroops():", $COLOR_DEBUG)

	If Not $bOpenArmyWindow Then
		If $bCheckWindow And Not IsTrainPage() Then ; check for train page
			SetError(1)
			Return ; not open, not requested to be open - error.
		EndIf
	ElseIf $bOpenArmyWindow Then
		If Not OpenArmyOverview(True, "getArmyCCTroops()") Then
			SetError(2)
			Return ; not open, requested to be open - error.
		EndIf
		If _Sleep($DELAYCHECKARMYCAMP5) Then Return
	EndIf

	Local $sTroopDiamond = GetDiamondFromRect("20,451,462,554") ; Contains iXStart, $iYStart, $iXEnd, $iYEnd ; Resolution changed
	Local $aCurrentCCTroops = findMultiple(@ScriptDir & "\imgxml\ArmyOverview\Troops", $sTroopDiamond, $sTroopDiamond, 0, 1000, 0, "objectname,objectpoints", $bNeedCapture) ; Returns $aCurrentTroops[index] = $aArray[2] = ["TroopShortName", CordX,CordY]

	Local $aTempTroopArray, $avTroops, $aTroopCoords
	Local $sTroopName = ""
	Local $iTroopIndex = -1
	Local $aCurrentCCTroopsEmpty[$eTroopCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0] ; Local Copy to reset Troops Array
	Local $aCurrentTroopsLog[0][3] ; [0] = Name [1] = Quantities [3] Xaxis

	$g_aiCurrentCCTroops = $aCurrentCCTroopsEmpty ; Reset Current Troops Array

	If UBound($aCurrentCCTroops, 1) >= 1 Then
		For $i = 0 To UBound($aCurrentCCTroops, 1) - 1 ; Loop through found CC Troops
			$aTempTroopArray = $aCurrentCCTroops[$i] ; Declare Array to Temp Array

			$iTroopIndex = TroopIndexLookup($aTempTroopArray[0], "getArmyTroops()") ; Get the Index of the Troop from the ShortName
			If StringInStr($aTempTroopArray[1], "|") Then
				$avTroops = StringSplit($aTempTroopArray[1], "|")
				For $j = 1 To $avTroops[0]
					$aTroopCoords = StringSplit($avTroops[$j], ",", $STR_NOCOUNT) ; Split the Coordinates where the Troop got found into X and Y
					Local $iQuantity = Number(getBarracksNewTroopQuantity(Slot($aTroopCoords[0], $aTroopCoords[1]), 498, $bNeedCapture)) ; Get The Quantity of the Troop, Slot() Does return the exact spot to read the Number from
					$g_aiCurrentCCTroops[$iTroopIndex] += $iQuantity
					$aTroopWSlot[UBound($aTroopWSlot) - 1][0] = Slot($aTroopCoords[0], $aTroopCoords[1])
					$aTroopWSlot[UBound($aTroopWSlot) - 1][1] = $iTroopIndex
					$aTroopWSlot[UBound($aTroopWSlot) - 1][2] = $iQuantity
					ReDim $aTroopWSlot[UBound($aTroopWSlot) + 1][3]

					$sTroopName = $g_aiCurrentCCTroops[$iTroopIndex] >= 2 ? $g_asTroopNamesPlural[$iTroopIndex] : $g_asTroopNames[$iTroopIndex]
					_ArrayAdd($aCurrentTroopsLog, $sTroopName & "|" & $iQuantity & "|" & Slot($aTroopCoords[0], $aTroopCoords[1]))
				Next
			Else
				$aTroopCoords = StringSplit($aTempTroopArray[1], ",", $STR_NOCOUNT) ; Split the Coordinates where the Troop got found into X and Y
				Local $iQuantity = Number(getBarracksNewTroopQuantity(Slot($aTroopCoords[0], $aTroopCoords[1]), 498, $bNeedCapture))
				$g_aiCurrentCCTroops[$iTroopIndex] += $iQuantity

				$aTroopWSlot[UBound($aTroopWSlot) - 1][0] = Slot($aTroopCoords[0], $aTroopCoords[1])
				$aTroopWSlot[UBound($aTroopWSlot) - 1][1] = $iTroopIndex
				$aTroopWSlot[UBound($aTroopWSlot) - 1][2] = $iQuantity
				ReDim $aTroopWSlot[UBound($aTroopWSlot) + 1][3]

				$sTroopName = $g_aiCurrentCCTroops[$iTroopIndex] >= 2 ? $g_asTroopNamesPlural[$iTroopIndex] : $g_asTroopNames[$iTroopIndex]
				_ArrayAdd($aCurrentTroopsLog, $sTroopName & "|" & $iQuantity & "|" & Slot($aTroopCoords[0], $aTroopCoords[1]))
			EndIf

		Next
	EndIf

	_ArraySort($aCurrentTroopsLog, 0, 0, 0, 2)
	For $index = 0 To UBound($aCurrentTroopsLog) - 1
		If $aCurrentTroopsLog[$index][1] > 0 And $bSetLog Then SetLog(" - " & $aCurrentTroopsLog[$index][1] & " " & $aCurrentTroopsLog[$index][0] & " Available (Clan Castle)", $COLOR_SUCCESS)
	Next


	If $bCloseArmyWindow Then
		ClickAway()
		If _Sleep($DELAYCHECKARMYCAMP4) Then Return
	EndIf

	If $bGetSlot Then
		If UBound($aTroopWSlot) > 1 Then _ArrayDelete($aTroopWSlot, UBound($aTroopWSlot) - 1)
		If UBound($aTroopWSlot) = 1 And $aTroopWSlot[0][0] = 0 And $aTroopWSlot[0][1] = "" Then Return
		_ArraySort($aTroopWSlot)
		Return $aTroopWSlot
	EndIf

EndFunc   ;==>getArmyCCTroops
