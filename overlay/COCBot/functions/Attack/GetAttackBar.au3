; #FUNCTION# ====================================================================================================================
; Name ..........: GetAttackBar
; Description ...: Detects Army in the Attackbar and Returns Name, Slot, Amount and X Coordinate
; Syntax ........: GetAttackBar($bRemaining = False, $pMatchMode = $DB, $bDebug = False)
; Parameters ....: $bRemaining (First Check or for Remaining Troops), $pMatchMode (Attackmode that needs the Attackbar: $DB, $AB), $bDebug (Debug GetAttackbar)
; Return values .:
; Author ........: Trlopes (06-2016)
; Modified ......: ProMac (12-2016), Fliegerfaust(12-2018)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func GetAttackBar($bRemaining = False, $pMatchMode = $DB, $bDebug = False)
	Local Static $aAttackBar[0][8]
	Local Static $bDoubleRow = False, $bCheckSlot12 = False
	Local $sSearchDiamond = GetDiamondFromRect("0,547,835,610") ; Resolution changed
	Local $iYBelowRowOne = 630, $aiOCRLocation[2] = [-1, -1], $aSlotAmountX[0][3]

	If $g_bDraggedAttackBar Then DragAttackBar($g_iTotalAttackSlot, True)

	;Reset All Static Variables if GetAttackBar is not for Remaining
	If Not $bRemaining Then
		$bCheckSlot12 = False
		$bDoubleRow = False
		Local $aDummyArray[0][8]
		$aAttackBar = $aDummyArray
		$g_iLSpellLevel = 1
		$g_iESpellLevel = 1
		$g_iRSpellLevel = 1
		$g_iHSpellLevel = 1
		$g_iSiegeLevel = 0

		;Check if Double Row is enabled aswell as has 12+ Slots
		If _CheckPixel($aDoubRowAttackBar, True) Then
			$bDoubleRow = True
			$sSearchDiamond = GetDiamondFromRect("0,447,835,654") ; Resolution changed
		ElseIf _CheckPixel($a12OrMoreSlots, True) Then
			$bCheckSlot12 = True
			SetDeBugLog("Found 12th slot for Normal Troops")
		EndIf
		SetDebugLog("GetBarCheck: DoubleRow= " & $bDoubleRow)
	EndIf

	If Not $g_bRunState Then Return

	If UBound($aAttackBar) = 0 Or Not $bRemaining Then
		Local $iAttackbarStart = __TimerInit()
		Local $aTempArray, $aTempCoords, $aTempMultiCoords, $iRow = 1

		Local $aAttackBarResult = findMultiple($g_sImgAttackBarDir, $sSearchDiamond, $sSearchDiamond, 0, 1000, 0, "objectname,objectpoints", True)

		If UBound($aAttackBarResult) = 0 Then
			SetLog("Error in GetAttackBar(): Search did not return any results!", $COLOR_ERROR)
			SaveDebugImage("ErrorGetAttackBar", False, Default, "#1")
			Return ""
		EndIf

		;Add found Stuff into our Arrays
		For $i = 0 To UBound($aAttackBarResult, 1) - 1
			$aTempArray = $aAttackBarResult[$i]
			$aTempMultiCoords = decodeMultipleCoords($aTempArray[1], 40, 40, -1)
			For $j = 0 To UBound($aTempMultiCoords, 1) - 1
				$aTempCoords = $aTempMultiCoords[$j]
				If UBound($aTempCoords) < 2 Then ContinueLoop
				If $bDoubleRow And $aTempCoords[1] >= $iYBelowRowOne Then $iRow = 2
				If StringRegExp($aTempArray[0], "(AmountX)", 0) Then
					_ArrayAdd($aSlotAmountX, $aTempCoords[0] & "|" & $aTempCoords[1] & "|" & $iRow, 0, "|", @CRLF, $ARRAYFILL_FORCE_NUMBER)
					$aiOCRLocation[$iRow - 1] = $aTempCoords[1] ; Store any OCR Location for later use on Heroes
				Else
					If StringRegExp($aTempArray[0], "(King)|(Queen)|(Warden)|(Champion)", 0) Then _ArrayAdd($aSlotAmountX, $aTempCoords[0] & "|" & $aTempCoords[1] & "|" & $iRow, 0, "|", @CRLF, $ARRAYFILL_FORCE_NUMBER)
					Local $aTempElement[1][8] = [[$aTempArray[0], $aTempCoords[0], $aTempCoords[1], -1, -1, -1, -1, $iRow]] ; trick to get the right variable types into our array. Delimiter Adding only gets us string which can't be sorted....
					_ArrayAdd($aAttackBar, $aTempElement)
				EndIf
				$iRow = 1
			Next
		Next

		If UBound($aAttackBar, 1) = 0 Then
			SetLog("Error in GetAttackBar(): $aAttackBar has no results in it", $COLOR_ERROR)
			Return ""
		EndIf

		;Sort the Arrays by X Position of the Results
		_ArraySort($aAttackBar, 0, 0, 0, 1)
		_ArraySort($aSlotAmountX)
		If $bDoubleRow Then $aSlotAmountX = SortDoubleRowXElements($aSlotAmountX)

		SetDebugLog("GetAttackBar(): Finished Image Search in: " & StringFormat("%.2f", __TimerDiff($iAttackbarStart)) & " ms")
		$iAttackbarStart = __TimerInit()

	EndIf

	#comments-start
		$aAttackBar[n][8]
		[n][0] = Name of the found Troop/Spell/Hero/Siege
		[n][1] = The X Coordinate of the Troop/Spell/Hero/Siege
		[n][2] = The Y Coordinate of the Troop/Spell/Hero/Siege
		[n][3] = The Slot Number (Starts with 0)
		[n][4] = The Amount
		[n][5] = The X Coordinate of the x beside the Amount
		[n][6] = The Y Coordinate of the x beside the Amount
		[n][7] = The Row where it is in
	#comments-end

	Local $aFinalAttackBar[0][7]
	Local $aiOCRY = [-1, -1]
	If Not $bRemaining Then $aiOCRY = GetOCRYLocation($aSlotAmountX)
	Local $sKeepRemainTroops = "(King)|(Queen)|(Warden)|(Champion)|(WallW)|(BattleB)|(StoneS)|(SiegeB)|(LogL)|(FlameF)" ; TODO: check if (WallW)|(BattleB)|(StoneS)|(SiegeB)|(LogL)|(FlameF) required

	For $i = 0 To UBound($aAttackBar, 1) - 1
		If $aAttackBar[$i][1] > 0 Then
			Local $bRemoved = False
			If Not $g_bRunState Then Return
			If _Sleep(20) Then Return

			If $bRemaining Then
				$aTroopIsDeployed[0] = $aAttackBar[$i][5] - 15
				$aTroopIsDeployed[1] = $aAttackBar[$i][6]
				If _CheckPixel($aTroopIsDeployed, True) Then
					; Troop got deployed already
					$bRemoved = True
					$aAttackBar[$i][4] = 0 ; set available troops to 0
					If StringRegExp($aAttackBar[$i][0], $sKeepRemainTroops, 0) = 0 Then
						SetDebugLog("GetAttackBar(): Troop " & $aAttackBar[$i][0] & " already deployed, now removed")
						ContinueLoop
					Else
						SetDebugLog("GetAttackBar(): Troop " & $aAttackBar[$i][0] & " already deployed, but stays")
					EndIf
				EndIf
			Else
				Local $aTempSlot = AttackSlot(Number($aAttackBar[$i][1]), Number($aAttackBar[$i][7]), $aSlotAmountX)
				$aAttackBar[$i][5] = Number($aTempSlot[0])
				$aAttackBar[$i][6] = Number($aTempSlot[1])
				$aAttackBar[$i][3] = Number($aTempSlot[2])
				If StringRegExp($aAttackBar[$i][0], "(King)|(Queen)|(Warden)|(Champion)", 0) And $aiOCRY[$aAttackBar[$i][7] - 1] <> -1 Then $aAttackBar[$i][6] = ($aiOCRY[$aAttackBar[$i][7] - 1] - 7)
			EndIf

			If StringRegExp($aAttackBar[$i][0], "(King)|(Queen)|(Warden)|(Champion)|(Castle)|(WallW)|(BattleB)|(StoneS)|(SiegeB)|(LogL)|(FlameF)", 0) Then
				If Not $bRemoved Then $aAttackBar[$i][4] = 1
				If ($pMatchMode = $DB Or $pMatchMode = $LB) And StringRegExp($aAttackBar[$i][0], "(WallW)|(BattleB)|(StoneS)|(SiegeB)|(LogL)|(FlameF)", 0) And $g_abAttackDropCC[$pMatchMode] And $g_aiAttackUseSiege[$pMatchMode] > 0 And $g_aiAttackUseSiege[$pMatchMode] <= $eSiegeMachineCount + 1 Then
					$g_iSiegeLevel = Number(getTroopsSpellsLevel(Number($aAttackBar[$i][5]) - 30, 704 + $g_iBottomOffsetYFixed))
					If $g_iSiegeLevel = 0 Then $g_iSiegeLevel = 1 ; Number if not found digit returns 0.
					SetDebugLog($aAttackBar[$i][0] & " level: " & $g_iSiegeLevel)
				EndIf
			Else
				If Not $bRemoved Then
					$aAttackBar[$i][4] = Number(getTroopCountSmall(Number($aAttackBar[$i][5]), Number($aAttackBar[$i][6])))
					If $aAttackBar[$i][4] = 0 Then $aAttackBar[$i][4] = Number(getTroopCountBig(Number($aAttackBar[$i][5]), Number($aAttackBar[$i][6] - 2)))
				EndIf
				If StringRegExp($aAttackBar[$i][0], "(LSpell)", 0) And $g_bSmartZapEnable Then
					Local $iLSpellLevel = Number(getTroopsSpellsLevel(Number($aAttackBar[$i][5]) - 20, 704 + $g_iBottomOffsetYFixed))
					SetDebugLog("$iLSpellLevel:" & $iLSpellLevel)
					If $iLSpellLevel > 0 And $iLSpellLevel <= 9 Then $g_iLSpellLevel = $iLSpellLevel
				ElseIf StringRegExp($aAttackBar[$i][0], "(ESpell)", 0) And $g_bEarthQuakeZap Then
					Local $iESpellLevel = Number(getTroopsSpellsLevel(Number($aAttackBar[$i][5]) - 20, 704 + $g_iBottomOffsetYFixed))
					SetDebugLog("$iESpellLevel:" & $iESpellLevel)
					If $iESpellLevel > 0 And $iESpellLevel <= 5 Then $g_iESpellLevel = $iESpellLevel
 				ElseIf StringRegExp($aAttackBar[$i][0], "(RSpell)|(HSpell)", 0) > 0 And $g_bSmartFarmSpellsEnable Then ; Custom Smart Farm - Team AIO Mod++
					Local $iSpellLevel = Number(getTroopsSpellsLevel(Number($aAttackBar[$i][5]) - 20, 704 + $g_iBottomOffsetYFixed))
					If StringInStr($aAttackBar[$i][0], "RSpell") <> 0 And $iSpellLevel > 0 Then $g_iRSpellLevel = $iSpellLevel
					If StringInStr($aAttackBar[$i][0], "HSpell") <> 0 And $iSpellLevel > 0 Then $g_iHSpellLevel = $iSpellLevel
				EndIf
			EndIf
			; 0: Index, 1: Slot, 2: Amount, 3: X-Coord, 4: Y-Coord, 5: OCR X-Coord, 6: OCR Y-Coord
			Local $aTempFinalArray[1][7] = [[TroopIndexLookup($aAttackBar[$i][0]), $aAttackBar[$i][3], $aAttackBar[$i][4], $aAttackBar[$i][1], $aAttackBar[$i][2], $aAttackBar[$i][5], $aAttackBar[$i][6]]]
			_ArrayAdd($aFinalAttackBar, $aTempFinalArray)
		EndIf
	Next

	; Drag left & checking extended troops from Slot11+ ONLY if not a smart attack
	If ($pMatchMode <= $LB And $bCheckSlot12 And Not $bDoubleRow And UBound($aAttackBar) > 1 And $g_aiAttackAlgorithm[$pMatchMode] <> 2) Or ($bDebug And $bCheckSlot12) Then
		DragAttackBar()
		Local $aExtendedArray = ExtendedAttackBarCheck($aAttackBar, $bRemaining, $sSearchDiamond)
		_ArrayAdd($aFinalAttackBar, $aExtendedArray)
		If Not $bRemaining Then
			$g_iTotalAttackSlot = UBound($aFinalAttackBar, 1) - 1
			DragAttackBar($g_iTotalAttackSlot, True) ; return drag
		EndIf
	EndIf

	_ArraySort($aFinalAttackBar, 0, 0, 0, 1) ; Sort Final Array by Slot Number
	Return $aFinalAttackBar

EndFunc   ;==>GetBarCheck

Func ExtendedAttackBarCheck($aAttackBarFirstSearch, $bRemaining, $sSearchDiamond)

	Local Static $aAttackBar[0][8]
	Local $iLastSlotNumber = _ArrayMax($aAttackBarFirstSearch, 0, -1, -1, 3)
	Local $sLastTroopName = $aAttackBarFirstSearch[_ArrayMaxIndex($aAttackBarFirstSearch, 0, -1, -1, 1)][0], $aiOCRLocation[2] = [-1, -1]
	Local $aSlotAmountX[0][3]

	;Reset All Static Variables if the AttackBarCheck is not for Remaining
	If Not $bRemaining Then
		Local $aDummyArray[0][8]
		$aAttackBar = $aDummyArray
		$g_iTotalAttackSlot = 11
	EndIf

	If Not $g_bRunState Then Return

	If UBound($aAttackBar) = 0 Or Not $bRemaining Then
		Local $iAttackbarStart = __TimerInit()
		Local $aTempArray, $aTempCoords, $aTempMultiCoords, $iRow = 1

		Local $aAttackBarResult = findMultiple($g_sImgAttackBarDir, $sSearchDiamond, $sSearchDiamond, 0, 1000, 0, "objectname,objectpoints", True)

		If UBound($aAttackBarResult) = 0 Then
			SetLog("Error in AttackBarCheck(): Search did not return any results!", $COLOR_ERROR)
			SaveDebugImage("ErrorAttackBarCheck", False, Default, "#2")
			Return ""
		EndIf

		;Add found Stuff into our Arrays
		For $i = 0 To UBound($aAttackBarResult, 1) - 1
			$aTempArray = $aAttackBarResult[$i]
			$aTempMultiCoords = decodeMultipleCoords($aTempArray[1], 40, 40, -1)
			For $j = 0 To UBound($aTempMultiCoords, 1) - 1
				$aTempCoords = $aTempMultiCoords[$j]
				If UBound($aTempCoords) < 2 Then ContinueLoop
				If StringRegExp($aTempArray[0], "(AmountX)", 0) Then
					_ArrayAdd($aSlotAmountX, $aTempCoords[0] & "|" & $aTempCoords[1] & "|" & $iRow, 0, "|", @CRLF, $ARRAYFILL_FORCE_NUMBER)
					$aiOCRLocation[$iRow - 1] = $aTempCoords[1]
				Else
					If StringRegExp($aTempArray[0], "(King)|(Queen)|(Warden)|(Champion)", 0) Then _ArrayAdd($aSlotAmountX, $aTempCoords[0] & "|" & $aTempCoords[1] & "|" & $iRow, 0, "|", @CRLF, $ARRAYFILL_FORCE_NUMBER)
					Local $aTempElement[1][8] = [[$aTempArray[0], $aTempCoords[0], $aTempCoords[1], -1, -1, -1, -1, $iRow]]
					_ArrayAdd($aAttackBar, $aTempElement)
				EndIf
			Next
		Next

		If UBound($aAttackBar, 1) = 0 Then
			SetLog("Error in AttackBarCheck(): $aAttackBar has no results in it", $COLOR_ERROR)
			Return ""
		EndIf

		;Sort the Arrays by X Position of the Results
		_ArraySort($aAttackBar, 0, 0, 0, 1)
		_ArraySort($aSlotAmountX)

		SetDebugLog("AttackBarCheck(): Finished Image Search in: " & StringFormat("%.2f", __TimerDiff($iAttackbarStart)) & " ms")
		$iAttackbarStart = __TimerInit()
	EndIf

	#comments-start
		$aAttackBar[n][8]
		[n][0] = Name of the found Troop/Spell/Hero/Siege
		[n][1] = The X Coordinate of the Troop/Spell/Hero/Siege
		[n][2] = The Y Coordinate of the Troop/Spell/Hero/Siege
		[n][3] = The Slot Number (Starts with 0)
		[n][4] = The Amount
		[n][5] = The X Coordinate of the x beside the Amount
		[n][6] = The Y Coordinate of the x beside the Amount
		[n][7] = The Row where it is in
	#comments-end

	Local $aFinalAttackBar[0][7]
	Local $aiOCRY = [-1, -1]
	Local $sKeepRemainTroops = "(King)|(Queen)|(Warden)|(Champion)|(WallW)|(BattleB)|(StoneS)|(SiegeB)|(LogL)|(FlameF)" ; TODO: check if (WallW)|(BattleB)|(StoneS)|(SiegeB)|(LogL)|(FlameF) required

	If Not $bRemaining Then
		$aiOCRY = GetOCRYLocation($aSlotAmountX)
		Local $iLastTroopIndex = _ArraySearch($aAttackBar, $sLastTroopName, 0, 0, 0, 0, 1, 0) + 1
		$aAttackBar = _ArrayExtract($aAttackBar, $iLastTroopIndex)
		$aSlotAmountX = _ArrayExtract($aSlotAmountX, $iLastTroopIndex)
	EndIf

	For $i = 0 To UBound($aAttackBar, 1) - 1
		If $aAttackBar[$i][1] > 0 Then
			Local $bRemoved = False
			If Not $g_bRunState Then Return
			If _Sleep(20) Then Return

			If $bRemaining Then
				$aTroopIsDeployed[0] = $aAttackBar[$i][5] - 15
				$aTroopIsDeployed[1] = $aAttackBar[$i][6]
				If _CheckPixel($aTroopIsDeployed, True) Then
					; Troop got deployed already
					$bRemoved = True
					$aAttackBar[$i][4] = 0 ; set available troops to 0
					If StringRegExp($aAttackBar[$i][0], $sKeepRemainTroops, 0) = 0 Then
						SetDebugLog("AttackBarCheck(): Troop " & $aAttackBar[$i][0] & " already deployed, now removed")
						ContinueLoop
					Else
						SetDebugLog("AttackBarCheck(): Troop " & $aAttackBar[$i][0] & " already deployed, but stays")
					EndIf
				EndIf
			Else
				Local $aTempSlot = AttackSlot(Number($aAttackBar[$i][1]), Number($aAttackBar[$i][7]), $aSlotAmountX)
				$aAttackBar[$i][5] = Number($aTempSlot[0])
				$aAttackBar[$i][6] = Number($aTempSlot[1])
				$aAttackBar[$i][3] = Number($aTempSlot[2] + $iLastSlotNumber + 1)
				If StringRegExp($aAttackBar[$i][0], "(King)|(Queen)|(Warden)|(Champion)", 0) And $aiOCRY[$aAttackBar[$i][7] - 1] <> -1 Then $aAttackBar[$i][6] = ($aiOCRY[$aAttackBar[$i][7] - 1] - 7)
			EndIf

			If StringRegExp($aAttackBar[$i][0], "(King)|(Queen)|(Warden)|(Champion)|(Castle)|(WallW)|(BattleB)|(StoneS)|(SiegeB)|(LogL)|(FlameF)", 0) Then
				If Not $bRemoved Then $aAttackBar[$i][4] = 1
			Else
				If Not $bRemoved Then
					$aAttackBar[$i][4] = Number(getTroopCountSmall(Number($aAttackBar[$i][5]), Number($aAttackBar[$i][6])))
					If $aAttackBar[$i][4] = 0 Then $aAttackBar[$i][4] = Number(getTroopCountBig(Number($aAttackBar[$i][5]), Number($aAttackBar[$i][6] - 2)))
				EndIf
				If StringRegExp($aAttackBar[$i][0], "(LSpell)", 0) And $g_bSmartZapEnable Then
					Local $iLSpellLevel = Number(getTroopsSpellsLevel(Number($aAttackBar[$i][5]) - 20, 704 + $g_iBottomOffsetYFixed))
					SetDebugLog("$iLSpellLevel:" & $iLSpellLevel)
					If $iLSpellLevel > 0 And $iLSpellLevel <= 9 Then $g_iLSpellLevel = $iLSpellLevel
				ElseIf StringRegExp($aAttackBar[$i][0], "(ESpell)", 0) And $g_bEarthQuakeZap Then
					Local $iESpellLevel = Number(getTroopsSpellsLevel(Number($aAttackBar[$i][5]) - 20, 704 + $g_iBottomOffsetYFixed))
					SetDebugLog("$iESpellLevel:" & $iESpellLevel)
					If $iESpellLevel > 0 And $iESpellLevel <= 5 Then $g_iESpellLevel = $iESpellLevel
 				ElseIf StringRegExp($aAttackBar[$i][0], "(RSpell)|(HSpell)", 0) > 0 And $g_bSmartFarmSpellsEnable Then	; Custom Smart Farm - Team AIO Mod++
					Local $iSpellLevel = Number(getTroopsSpellsLevel(Number($aAttackBar[$i][5]) - 20, 704 + $g_iBottomOffsetYFixed))
					If StringInStr($aAttackBar[$i][0], "RSpell") <> 0 And $iSpellLevel > 0 Then $g_iRSpellLevel = $iSpellLevel
					If StringInStr($aAttackBar[$i][0], "HSpell") <> 0 And $iSpellLevel > 0 Then $g_iHSpellLevel = $iSpellLevel
				EndIf
			EndIf
			; 0: Index, 1: Slot, 2: Amount, 3: X-Coord, 4: Y-Coord, 5: OCR X-Coord, 6: OCR Y-Coord
			Local $aTempFinalArray[1][7] = [[TroopIndexLookup($aAttackBar[$i][0]), $aAttackBar[$i][3], $aAttackBar[$i][4], $aAttackBar[$i][1], $aAttackBar[$i][2], $aAttackBar[$i][5], $aAttackBar[$i][6]]]
			_ArrayAdd($aFinalAttackBar, $aTempFinalArray)
		EndIf
	Next

	_ArraySort($aFinalAttackBar, 0, 0, 0, 1) ; Sort Final Array by Slot Number

	Return $aFinalAttackBar
EndFunc   ;==>ExtendedAttackBarCheck

Func GetOCRYLocation($aArray)
	Local $aiReturn[2] = [-1, -1], $aTempArray[0], $aTempArray2[0]
	For $i = 0 To UBound($aArray, 1) - 1
		If $aArray[$i][2] = 1 Then
			_ArrayAdd($aTempArray, $aArray[$i][1])
		Else
			_ArrayAdd($aTempArray2, $aArray[$i][1])
		EndIf
	Next
	$aiReturn[0] = _ArrayMin($aTempArray)
	$aiReturn[1] = _ArrayMin($aTempArray2)

	Return $aiReturn
EndFunc   ;==>GetOCRYLocation

Func SearchNearest($aArray, $iNumber, $iRow)
	Local $iVal, $iValOld = _ArrayMax($aArray), $iReturn
	For $i = 0 To UBound($aArray) - 1
		$iVal = Abs($aArray[$i][0] - $iNumber)
		If $iValOld >= $iVal And $iRow = Number($aArray[$i][2]) Then
			$iValOld = $iVal
			$iReturn = $i
		EndIf
	Next
	Return $iReturn
EndFunc   ;==>SearchNearest

Func SortDoubleRowXElements($aArray)
	Local $aSecondRow[0][3]
	Local $aNewSlotAmountX[0][3]
	For $i = 0 To UBound($aArray) - 1
		If $aArray[$i][2] = 2 Then
			_ArrayAdd($aSecondRow, _ArrayExtract($aArray, $i, $i))
		Else
			_ArrayAdd($aNewSlotAmountX, _ArrayExtract($aArray, $i, $i))
		EndIf
	Next
	_ArraySort($aNewSlotAmountX)
	_ArraySort($aSecondRow)
	_ArrayAdd($aNewSlotAmountX, $aSecondRow)

	Return $aNewSlotAmountX
EndFunc   ;==>SortDoubleRowXElements

Func DragAttackBar($iTotalSlot = 20, $bBack = False)
	If $g_iTotalAttackSlot > 10 Then $iTotalSlot = $g_iTotalAttackSlot
	Local $bAlreadyDrag = False

	If Not $bBack Then
		SetDebugLog("Dragging attack troop bar to 2nd page. Distance = " & $iTotalSlot - 9 & " slots")
		ClickDrag(25 + 73 * ($iTotalSlot - 9), 660 + $g_iBottomOffsetYFixed, 25, 660 + $g_iBottomOffsetYFixed, 1000) ; Resolution changed
		If _Sleep(1000 + $iTotalSlot * 25) Then Return
		$bAlreadyDrag = True
	Else
		SetDebugLog("Dragging attack troop bar back to 1st page. Distance = " & $iTotalSlot - 9 & " slots")
		ClickDrag(25, 660 + $g_iBottomOffsetYFixed, 25 + 73 * ($iTotalSlot - 9), 660 + $g_iBottomOffsetYFixed, 1000) ; Resolution changed
		If _Sleep(800 + $iTotalSlot * 25) Then Return
		$bAlreadyDrag = False
	EndIf

	$g_bDraggedAttackBar = $bAlreadyDrag
	$g_iCSVLastTroopPositionDropTroopFromINI = -1 ; after drag attack bar, need to clear last troop selected
	Return $bAlreadyDrag
EndFunc   ;==>DragAttackBar

Func AttackSlot($iPosX, $iRow, $aSlots)
	Local $aTempSlot[3] = [0, 0, 0]
	Local $iClosest = SearchNearest($aSlots, $iPosX, $iRow)
	Local $bLast = False
	If $iClosest = _ArrayMaxIndex($aSlots, 0) And $aSlots[$iClosest][0] >= ($g_iGAME_WIDTH - 60) Then $bLast = True

	If $iClosest >= 0 And $iClosest < UBound($aSlots) Then
		$aTempSlot[0] = $bLast ? $g_iGAME_WIDTH - 53 : $aSlots[$iClosest][0] - 15 ; X Coord | Last Item to get OCRd needs to be compensated because it could happen that the Capture Rectangle gets out of boundary and image gets not usable
		$aTempSlot[1] = $aSlots[$iClosest][1] - 7 ; Y Coord
		$aTempSlot[2] = $iClosest
	EndIf

	Return $aTempSlot
EndFunc   ;==>AttackSlot

Func DebugAttackBarImage($aAttackBarResult)
	#comments-start
		SetDebugLog("Attackbar OCR completed in " & StringFormat("%.2f", __TimerDiff($iAttackbarStart)) & " ms")

		If $bDebug Then
		Local $iX1 = 0, $iY1 = 635, $iX2 = 853, $iY2 = 698
		_CaptureRegion2($iX1, $iY1, $iX2, $iY2)

		Local $sSubDir = $g_sProfileTempDebugPath & "AttackBarDetection"

		DirCreate($sSubDir)

		Local $sDate = @YEAR & "-" & @MON & "-" & @MDAY, $sTime = @HOUR & "." & @MIN & "." & @SEC
		Local $sDebugImageName = String($sDate & "_" & $sTime & "_.png")
		Local $hEditedImage = _GDIPlus_BitmapCreateFromHBITMAP($g_hHBitmap2)
		Local $hGraphic = _GDIPlus_ImageGetGraphicsContext($hEditedImage)
		Local $hPenRED = _GDIPlus_PenCreate(0xFFFF0000, 3)

		For $i = 0 To UBound($aResult) - 1
		addInfoToDebugImage($hGraphic, $hPenRED, $aResult[$i][0], $aResult[$i][1], $aResult[$i][2])
		Next

		_GDIPlus_ImageSaveToFile($hEditedImage, $sSubDir & "\" & $sDebugImageName)
		_GDIPlus_PenDispose($hPenRED)
		_GDIPlus_GraphicsDispose($hGraphic)
		_GDIPlus_BitmapDispose($hEditedImage)
		EndIf

	#comments-end
EndFunc   ;==>DebugAttackBarImage
