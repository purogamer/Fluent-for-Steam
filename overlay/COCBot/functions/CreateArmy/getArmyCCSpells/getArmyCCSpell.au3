; #FUNCTION# ====================================================================================================================
; Name ..........: getArmyCCSpells
; Description ...: Obtain the current Clan Castle Spells
; Syntax ........: getArmyCCSpells()
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

Func getArmyCCSpells($bOpenArmyWindow = False, $bCloseArmyWindow = False, $bCheckWindow = False, $bSetLog = True, $bNeedCapture = True, $bGetSlot = False)

	Local $aSpellWSlot[1][3] = [[0, "", 0]] ; X-Coord, Spell Name index, Quantity

	If $g_bDebugSetlogTrain Then SetLog("getArmyCCSpells():", $COLOR_DEBUG)

	If Not $bOpenArmyWindow Then
		If $bCheckWindow And Not IsTrainPage() Then ; check for train page
			SetError(1)
			Return ; not open, not requested to be open - error.
		EndIf
	ElseIf $bOpenArmyWindow Then
		If Not OpenArmyOverview(True, "getArmyCCSpells()") Then
			SetError(2)
			Return ; not open, requested to be open - error.
		EndIf
		If _Sleep($DELAYCHECKARMYCAMP5) Then Return
	EndIf

	Local $sCCSpellDiamond = GetDiamondFromRect("450,451,605,549") ; Resolution changed
	Local $aCurrentCCSpells = findMultiple(@ScriptDir & "\imgxml\ArmyOverview\Spells", $sCCSpellDiamond, $sCCSpellDiamond, 0, 1000, 0,"objectname,objectpoints", $bNeedCapture) ; Returns $aCurrentSpells[index] = $aArray[2] = ["SpellShortName", CordX,CordY]

	Local $aTempSpellArray, $aSpells, $aSpellCoords
	Local $sSpellName = ""
	Local $iSpellIndex = -1
	Local $aCurrentCCSpellsEmpty[$eSpellCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0] ; Local Copy to reset Spells Array

	$g_aiCurrentCCSpells = $aCurrentCCSpellsEmpty ; Reset Current Spells Array

	If UBound($aCurrentCCSpells, 1) >= 1 Then
		For $i = 0 To UBound($aCurrentCCSpells, 1) - 1 ; Loop through found Spells
			$aTempSpellArray = $aCurrentCCSpells[$i] ; Declare Array to Temp Array

			$iSpellIndex = TroopIndexLookup($aTempSpellArray[0], "getArmyCCSpells()") - $eLSpell ; Get the Index of the Spell from the ShortName
			If $iSpellIndex < 0 Then ContinueLoop

			If StringInStr($aTempSpellArray[1], "|") Then
				$aSpells = StringSplit($aTempSpellArray[1], "|")
				Local $X_Coord
				For $i = 1 To $aSpells[0]
					$aSpellCoords = StringSplit($aSpells[$i], ",", $STR_NOCOUNT) ; Split the Coordinates where the Spell got found into X and Y
					If $i >= 1 And Abs($aSpellCoords[0] - $X_Coord) <= 50 Then ContinueLoop ; decode to avoid detecting 1 slot twice (haste)
					Local $TempQty = Number(getBarracksNewTroopQuantity(Slot($aSpellCoords[0], $aSpellCoords[1]), 498)) ; Get The Quantity of the Spell, Slot() Does return the exact spot to read the Number from
					$g_aiCurrentCCSpells[$iSpellIndex] += $TempQty
					$aSpellWSlot[UBound($aSpellWSlot) - 1][0] = Slot($aSpellCoords[0], $aSpellCoords[1])
					$aSpellWSlot[UBound($aSpellWSlot) - 1][1] = $iSpellIndex
					$aSpellWSlot[UBound($aSpellWSlot) - 1][2] = $TempQty
					ReDim $aSpellWSlot[UBound($aSpellWSlot) + 1][3]
					$X_Coord = $aSpellCoords[0]
				Next
			Else
				$aSpellCoords = StringSplit($aTempSpellArray[1], ",", $STR_NOCOUNT) ; Split the Coordinates where the Spell got found into X and Y
				$g_aiCurrentCCSpells[$iSpellIndex] = Number(getBarracksNewTroopQuantity(Slot($aSpellCoords[0], $aSpellCoords[1]), 498)) ; Get The Quantity of the Spell, Slot() Does return the exact spot to read the Number from
				$aSpellWSlot[UBound($aSpellWSlot) - 1][0] = Slot($aSpellCoords[0], $aSpellCoords[1])
				$aSpellWSlot[UBound($aSpellWSlot) - 1][1] = $iSpellIndex
				$aSpellWSlot[UBound($aSpellWSlot) - 1][2] = $g_aiCurrentCCSpells[$iSpellIndex]
				ReDim $aSpellWSlot[UBound($aSpellWSlot) + 1][3]
			EndIf

			$sSpellName = $g_aiCurrentCCSpells[$iSpellIndex] >= 2 ? $g_asSpellNames[$iSpellIndex] & " Spells (Clan Castle)" : $g_asSpellNames[$iSpellIndex] & " Spell (Clan Castle)" ; Select the right Spell Name, If more than one then use Spells at the end
			If $bSetLog Then SetLog(" - " & $g_aiCurrentCCSpells[$iSpellIndex] & "x " & $sSpellName, $COLOR_SUCCESS) ; Log What Spell is available and How many
		Next
	EndIf

	If $bCloseArmyWindow Then
		ClickAway()
		If _Sleep($DELAYCHECKARMYCAMP4) Then Return
	EndIf

	If $bGetSlot Then
		If Ubound($aSpellWSlot) > 1 Then _ArrayDelete($aSpellWSlot, Ubound($aSpellWSlot) - 1)
		If UBound($aSpellWSlot) = 1 And $aSpellWSlot[0][0] = 0 And $aSpellWSlot[0][1] = "" Then Return
		_ArraySort($aSpellWSlot)
		Return $aSpellWSlot
	EndIf
EndFunc   ;==>getArmyCCSpells
