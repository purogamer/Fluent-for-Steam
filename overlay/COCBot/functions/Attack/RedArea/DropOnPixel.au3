; #FUNCTION# ====================================================================================================================
; Name ..........: DropOnPixel
; Description ...:
; Syntax ........: DropOnPixel($troop, $listArrPixel, $number[, $slotsPerEdge = 0])
; Parameters ....: $troop               - Troop to deploy
;                  $listArrPixel        - Array of pixel where troop are deploy
;                  $number              - Number of troop to deploy
;                  $slotsPerEdge        - [optional] a string value. Default is 0.
; Return values .: None
; Author ........:
; Modified ......: ProMac (07-2018)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#Region - Custom SmartFarm - Team AIO Mod++
; Strategy :
; While troop left :
;	If number of troop > number of pixel => Search the number of troop to deploy by pixel
;	Else Search the offset to browse the tab of pixel
;	Browse the tab of pixel and send troop
Func DropOnPixel($iTroop, $aListArrPixel, $iNumber, $iSlotsPerEdge = 0, $bRandom = False, $bLastSide = False, $bTankTroop = False)
	If isProblemAffect(True) Then Return
	If Not IsAttackPage() Then Return
	Local $nameFunc = "[DropOnPixel]"
	debugRedArea($nameFunc & " IN ")
	If ($iNumber = 0 Or UBound($aListArrPixel) = 0) Then Return
	KeepClicks()
	Local $iDelay = 0
	For $i = 0 To UBound($aListArrPixel) - 1
		debugRedArea("$aListArrPixel $i : [" & $i & "] ")
		Local $iOffset = 1
		Local $nbTroopByPixel = 1
		Local $Clicked = 0
		Local $arrPixel = $aListArrPixel[$i]
		Local $nbTroopsLeft = UBound($arrPixel) > $iNumber ? $iNumber : UBound($arrPixel)
		If $g_bUseSmartFarmAndRandomQuant And Not $bLastSide Then $nbTroopsLeft = UBound($arrPixel)
		debugRedArea("UBound($arrPixel) " & UBound($arrPixel) & "$iNumber :" & $iNumber)
		While ($nbTroopsLeft > 0)
			If Not $g_bRunState Then ExitLoop
			If (UBound($arrPixel) = 0) Then
				ExitLoop
			EndIf
			If (UBound($arrPixel) > $nbTroopsLeft) Then
				$iOffset = UBound($arrPixel) / $nbTroopsLeft
			Else
				$nbTroopByPixel = Floor($iNumber / UBound($arrPixel))
			EndIf
			If ($iOffset < 1) Then
				$iOffset = 1
			EndIf
			If ($nbTroopByPixel < 1) Then
				$nbTroopByPixel = 1
			EndIf
			For $j = 0 To UBound($arrPixel) - 1 Step $iOffset
				Local $iIndex = Round($j)
				If ($iIndex > UBound($arrPixel) - 1) Then
					$iIndex = UBound($arrPixel) - 1
				EndIf
				Local $currentPixel = $arrPixel[Floor($iIndex)]
				If $bRandom Then $currentPixel = DeployPointRandom($arrPixel[Floor($iIndex)])
				If Not IsArray($currentPixel) And UBound($currentPixel) = 2 Then
					SetDebugLog("Error DropOnPixel with slot " & $iTroop + 1 & " array: " & _ArrayToString($arrPixel[Floor($iIndex)]))
					ContinueLoop
				EndIf
				If $j >= Round(UBound($arrPixel) / 2) And $j <= Round((UBound($arrPixel) / 2) + $iOffset) And $g_bIsHeroesDropped = False Then
					$g_aiDeployHeroesPosition[0] = $currentPixel[0]
					$g_aiDeployHeroesPosition[1] = $currentPixel[1]
					debugRedArea("Heroes : $iSlotsPerEdge = else ")
					debugRedArea("$iOffset: " & $iOffset)
				EndIf
				If $j >= Round(UBound($arrPixel) / 2) And $j <= Round((UBound($arrPixel) / 2) + $iOffset) And $g_bIsCCDropped = False Then
					$g_aiDeployCCPosition[0] = $currentPixel[0]
					$g_aiDeployCCPosition[1] = $currentPixel[1]
					debugRedArea("CC : $iSlotsPerEdge = else ")
					debugRedArea("$iOffset: " & $iOffset)
				EndIf
				If Number($currentPixel[1]) > 555 + $g_iBottomOffsetY Then $currentPixel[1] = 555 + $g_iBottomOffsetY
				$iDelay = SetSleep(0)
				If $bTankTroop Then
					$iDelay = Round($iDelay * Random(1.15, 1.75))
					SetDebugLog("Tank Troop $nbTroopByPixel: " & $nbTroopByPixel & " with delay of " & $iDelay & "ms")
					AttackClick($currentPixel[0], $currentPixel[1], $nbTroopByPixel, $iDelay, 0, "#0098")
					If _Sleep(50) Then ExitLoop
				Else
					AttackClick($currentPixel[0], $currentPixel[1], $nbTroopByPixel, $iDelay, 0, "#0098")
					If _Sleep(50) Then ExitLoop
				EndIf
				$Clicked += $nbTroopByPixel
				$nbTroopsLeft -= $nbTroopByPixel
			Next
		WEnd
		If $g_bUseSmartFarmAndRandomQuant And $g_aiAttackAlgorithm[$DB] = 2 Then SetLog("Clicked " & $Clicked & "x at slot: " & $iTroop + 1, $COLOR_SUCCESS)
	Next
	ReleaseClicks()
	debugRedArea($nameFunc & " OUT ")
	Return $Clicked
EndFunc   ;==>DropOnPixel

Func DeployPointRandom($currentPixel)
	Local $sSide = Side($currentPixel)
	Local $x = Random(5, 16, 1)
	Local $y = Random(5, 16, 1)
	Switch $sSide
		Case "TL"
			$currentPixel[0] -= $x
			$currentPixel[1] -= $y
		Case "TR"
			$currentPixel[0] += $x
			$currentPixel[1] -= $y
		Case "BL"
			$currentPixel[0] -= $x
			$currentPixel[1] += $y
		Case "BR"
			$currentPixel[0] += $x
			$currentPixel[1] += $y
		Case Else
			
			Return -1
	EndSwitch
	Return $currentPixel
EndFunc   ;==>DeployPointRandom
#EndRegion - Custom SmartFarm - Team AIO Mod++
