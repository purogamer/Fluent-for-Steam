; #FUNCTION# ====================================================================================================================
; Name ..........: GetAttackBarBB
; Description ...: Gets the troops and there quantities for the current attack
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Chilly-Chill (04-2019)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#Region - Custom - Team AIO Mod++
Func GetAttackBarBB($bRemaining = False)
	local $iTroopBanners = 640 ; y location of where to find troop quantities
	local $iTroopBannersBig = 633 ; y location of where to find troop quantities big
	local $iSlotOffset = 73 ; slots are 73 pixels apart
	local $iBarOffset = 66 ; 66 pixels from side to attack bar
	
	local $aBBAttackBar[0][5]
	#comments-start
		$aAttackBar[n][8]
		[n][0] = Name of the found Troop/Spell/Hero/Siege
		[n][1] = The X Coordinate of the Troop
		[n][2] = The Y Coordinate of the Troop/Spell/Hero/Siege
		[n][3] = The Slot Number (Starts with 0)
		[n][4] = The Amount
	#comments-end

    local $sSearchDiamond = GetDiamondFromRect("0,542,860,644") ; Resolution fixed
	local $aBBAttackBarResult = findMultiple($g_sImgDirBBTroops, $sSearchDiamond, $sSearchDiamond, 0, 1000, 0, "objectname,objectpoints", True)
	
	If Not $g_bRunState Then Return ; Stop Button

	If UBound($aBBAttackBarResult) = 0 Then
		If Not $bRemaining Then
			; SetDebugLog("Error in BBAttackBarCheck(): Search did not return any results!", $COLOR_ERROR)
			If $g_bDebugImageSave Then SaveDebugImage("ErrorBBAttackBarCheck", False, Default, Default)
		EndIf
		Return -1
	EndIf

	; parse data into attackbar array... not done
	For $i = 0 To UBound($aBBAttackBarResult, 1) - 1
		local $aTroop = $aBBAttackBarResult[$i]

		local $aTempMultiCoords = decodeMultipleCoords($aTroop[1])
		For $j = 0 To UBound($aTempMultiCoords, 1) - 1
			local $aTempCoords = $aTempMultiCoords[$j]
			If UBound($aTempCoords) < 2 Then ContinueLoop
			Local $iSlot = Int(($aTempCoords[0] - $iBarOffset) / $iSlotOffset)
			Local $iCount = 1
			If String($aTroop[0]) <> "Machine" Then 
				local $iCount = Number(_getTroopCountSmall($aTempCoords[0], $iTroopBanners + $g_iBottomOffsetYFixed)) ; Fixed resolution
				If $iCount < 1 Then $iCount = Number(_getTroopCountBig($aTempCoords[0], $iTroopBannersBig + $g_iBottomOffsetYFixed)) ; Fixed resolution
				If $iCount < 1 Then
					If $bRemaining = False Then SetLog("Could not get count for " & $aTroop[0] & " in slot " & String($iSlot), $COLOR_ERROR)
					ContinueLoop
				EndIf
			EndIf

			Local $aTempElement[1][5] = [[$aTroop[0], $aTempCoords[0], $aTempCoords[1], $iSlot, $iCount]] ; element to add to attack bar list
			
			_ArrayAdd($aBBAttackBar, $aTempElement)
			
			If Not $g_bRunState Then Return ; Stop Button
			
		Next
		
		If Not $g_bRunState Then Return ; Stop Button

	Next
	_ArraySort($aBBAttackBar, 0, 0, 0, 3)
	For $i=0 To UBound($aBBAttackBar, 1) - 1
		SetLog($aBBAttackBar[$i][0] & ", (" & String($aBBAttackBar[$i][1]) & "," & String($aBBAttackBar[$i][2]) & "), Slot: " & String($aBBAttackBar[$i][3]) & ", Count: " & String($aBBAttackBar[$i][4]), $COLOR_SUCCESS)
	Next
	Return $aBBAttackBar
EndFunc
#EndRegion - Custom - Team AIO Mod++