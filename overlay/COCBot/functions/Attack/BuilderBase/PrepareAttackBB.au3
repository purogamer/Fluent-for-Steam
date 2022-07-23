; #FUNCTION# ====================================================================================================================
; Name ..........: PrepareAttackBB
; Description ...: This file controls attacking preperation of the builders base
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
#cs - Team AIO Mod++
Func PrepareAttackBB($bTest = False)
	If $bTest Then $g_aiCurrentLootBB[$eLootTrophyBB] = 1004
	If $bTest Then Setlog($g_aiCurrentLootBB[$eLootTrophyBB], $COLOR_INFO)

	Local $bIsToDropTrophies = False

	If $g_bChkBBTrophyRange Then
		SetDebugLog("Current Trophies: " & $g_aiCurrentLootBB[$eLootTrophyBB] & " Lower Limit: " & $g_iTxtBBTrophyLowerLimit & " Upper Limit: " & $g_iTxtBBTrophyUpperLimit)

		If ($g_aiCurrentLootBB[$eLootTrophyBB] > $g_iTxtBBTrophyUpperLimit) Then
			SetLog("Trophies out of range.")
			$bIsToDropTrophies = True
		ElseIf  ($g_aiCurrentLootBB[$eLootTrophyBB] < $g_iTxtBBTrophyLowerLimit) Then
			SetLog("Trophies out of range.")
			Return False
		EndIf
	EndIf

	If _Sleep(1500) Then Return ; Team AIO Mod++

	If Not ClickAttack() Then Return False

	If Not CheckArmyReady() Then
		If _Sleep(1500) Then Return ; Team AIO Mod++
		ClickAway() ; ClickP($aAway)
		Return False
	EndIf

	If $g_bChkBBAttIfLootAvail Then
		If Not CheckLootAvail() Then
			If _Sleep(1500) Then Return ; Team AIO Mod++
			ClickAway() ; ClickP($aAway)
			Return False
		EndIf
	EndIf

	$g_bBBMachineReady = CheckMachReady()
	If Not $g_bBBMachineReady Then
		SetLog("Battle Machine is not ready.")
		If _Sleep(1500) Then Return ; Team AIO Mod++
		ClickAway() ; ClickP($aAway)
		Return False
	EndIf

	Return True ; returns true if all checks succeed
EndFunc

Func ClickAttack()
	local $aColors = [[0xfdd79b, 96, 0], [0xffffff, 20, 50], [0xffffff, 69, 50]] ; coordinates of pixels relative to the 1st pixel
	Local $ButtonPixel = _MultiPixelSearch(8, 640, 120, 755, 1, 1, Hex(0xeac68c, 6), $aColors, 20)
	local $bRet = False

	If IsArray($ButtonPixel) Then
		SetDebugLog(String($ButtonPixel[0]) & " " & String($ButtonPixel[1]))
		PureClick($ButtonPixel[0] + 25, $ButtonPixel[1] + 25) ; Click fight Button
		$bRet = True
	Else
		SetLog("Can not find button for Builders Base Attack button", $COLOR_ERROR)
		If $g_bDebugImageSave Then SaveDebugImage("BBAttack_ButtonCheck_")
	EndIf
	Return $bRet
EndFunc

Func CheckLootAvail()
	local $aCoords = decodeSingleCoord(findImage("BBLootAvail_bmp", $g_sImgBBLootAvail, GetDiamondFromRect("210,622,658,721"), 1, True))
	local $bRet = False

	If IsArray($aCoords) And UBound($aCoords) = 2 Then
		$bRet = True
		SetLog("Loot is Available.")
	Else
		SetLog("No loot available.")
		If $g_bDebugImageSave Then SaveDebugImage("CheckLootAvail")
	EndIf

	Return $bRet
EndFunc

Func CheckMachReady()
	local $aCoords = decodeSingleCoord(findImage("BBMachReady_bmp", $g_sImgBBMachReady, GetDiamondFromRect("113,388,170,448"), 1, True))
	local $bRet = False

	If IsArray($aCoords) And UBound($aCoords) = 2 Then
		$bRet = True
		SetLog("Battle Machine ready.")
	Else
		If $g_bDebugImageSave Then SaveDebugImage("CheckMachReady")
	EndIf

	Return $bRet
EndFunc

Func CheckArmyReady()
	local $i = 0
	local $bReady = True, $bNeedTrain = False, $bTraining = False
	local $sSearchDiamond = GetDiamondFromRect("114,384,190,450") ; start of trained troops bar untill a bit after the 'r' "in Your Troops"

	If _Sleep($DELAYCHECKFULLARMY2) Then Return False ; wait for window
	While $i < 6 And $bReady ; wait for fight preview window
		local $aTroopsTrainingCoords = decodeSingleCoord(findImage("TroopsTrainingBB", $g_sImgBBTroopsTraining, $sSearchDiamond, 1, False)) ; shouldnt need to capture again as it is the same diamond
		local $aNeedTrainCoords = decodeSingleCoord(findImage("NeedTrainBB", $g_sImgBBNeedTrainTroops, $sSearchDiamond, 1, True))

		If IsArray($aNeedTrainCoords) And UBound($aNeedTrainCoords) = 2 Then
			$bReady = False
			$bNeedTrain = True
		EndIf
		If IsArray($aTroopsTrainingCoords) And UBound($aTroopsTrainingCoords) = 2 Then
			$bReady = False
			$bTraining = True
		EndIf

		$i += 1
	WEnd
	If Not $bReady Then
		SetLog("Army is not ready.")
		If $bTraining Then SetLog("Troops are training.")

		#Region - Custom army BB - Team AIO Mod++
			If $bNeedTrain Then
				ClickAway() ; ClickP($aAway, 1, 0, "#0000") ; ensure field is clean
				If _Sleep(1500) Then Return ; Team AIO Mod++ Then Return
				SetLog("Troops need to be trained in the training tab.")
				CheckArmyBuilderBase()
				Return False
			EndIf
		#EndRegion

		If $g_bDebugImageSave Then SaveDebugImage("FindIfArmyReadyBB")
	Else
		SetLog("Army is ready.")
	EndIf

	Return $bReady
EndFunc
#CE