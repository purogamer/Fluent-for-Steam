;
; #FUNCTION# ====================================================================================================================
; Name ..........: ReadTroopQuantity
; Description ...: Read the quantity for a given troop
; Syntax ........: ReadTroopQuantity($Troop)
; Parameters ....: $Troop               - an unknown value.
; Return values .: None
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func ReadTroopQuantity($iSlotNumber, $bCheckSelectedSlot = False, $bNeedNewCapture = True)
	Local $iAmount, $aSlotPosition = GetSlotPosition($iSlotNumber)
	Switch $bCheckSelectedSlot
		Case False
			$iAmount = getTroopCountSmall($aSlotPosition[0], $aSlotPosition[1])
			If $iAmount = "" Then
				$iAmount = getTroopCountBig($aSlotPosition[0], $aSlotPosition[1] - 3)
			EndIf
		Case Else
			Local $isTheSlotSelected = IsSlotSelected($iSlotNumber, $bNeedNewCapture)
			If Not $isTheSlotSelected Then
				$iAmount = Number(getTroopCountSmall($aSlotPosition[0], $aSlotPosition[1]))
			Else
				$iAmount = Number(getTroopCountBig($aSlotPosition[0], $aSlotPosition[1] - 3))
			EndIf
	EndSwitch
	Return Number($iAmount)
EndFunc   ;==>ReadTroopQuantity

Func UpdateTroopQuantity($sTroopName, $bNeedNewCapture = Default)
	If Not $bNeedNewCapture Then $bNeedNewCapture = True
	If $bNeedNewCapture Then
		_CaptureRegion2()
	EndIf

	; Get the integer index of the troop name specified
	Local $iTroopIndex = TroopIndexLookup($sTroopName)
	If $iTroopIndex = -1 Then
		SetLog("'UpdateTroopQuantity' troop name '" & $sTroopName & "' is unrecognized.")
		Return
	EndIf

	Local $iFoundAt = _ArraySearch($g_avAttackTroops, $iTroopIndex)
	If $iFoundAt = -1 Then
		SetLog("Couldn't find '" & $sTroopName & "' in $g_avAttackTroops", $COLOR_ERROR)
	EndIf

	If Not $g_bRunState Then Return
	Local $iQuantity = ReadTroopQuantity($iFoundAt, True, Not $bNeedNewCapture)
	$g_avAttackTroops[$iFoundAt][1] = $iQuantity

	Return $iFoundAt ; Return Troop Position in the Array, will be the slot of Troop in Attack bar
EndFunc   ;==>UpdateTroopQuantity

Func IsSlotSelected($iSlotIndex, $bNeedNewCapture = Default)
	; $iSlotIndex Starts from 0
	If Not $bNeedNewCapture Then $bNeedNewCapture = True
	If $bNeedNewCapture Then
		ForceCaptureRegion()
		_CaptureRegion()
	EndIf
	Local $iOffset = 73
	Local $iStartX = 75
	Local $iY = 724
	If $bNeedNewCapture Then
		Return _ColorCheck( _
				_GetPixelColor($iStartX + ($iOffset * $iSlotIndex), $iY, False), _ ; capture color #1
				Hex(0xFFFFFF, 6), _ ; compare to Color #2 from screencode
				20)
	Else
		Return _ColorCheck( _
				Hex(_GDIPlus_BitmapGetPixel(_GDIPlus_BitmapCreateFromHBITMAP($g_hHBitmap2), ($iStartX + ($iOffset * $iSlotIndex)), $iY), 6), _ ; Get pixel color
				Hex(0xFFFFFF, 6), _ ; compare to Color #2 from screencode
				20)
	EndIf
EndFunc   ;==>IsSlotSelected
