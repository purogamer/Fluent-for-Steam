; #FUNCTION# ====================================================================================================================
; Name ..........: smartZap
; Description ...: This file Includes all functions to current GUI
; Syntax ........: smartZap()
; Parameters ....: None
; Return values .: None
; Author ........: LunaEclipse(03-2016)
; Modified ......: TheRevenor(11-2016), ProMac(12-2016), TheRevenor(12-2016), TripleM(01-2017), Custom SmartZap - Team AIO Mod++ (2021)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

#Region - Custom SmartZap - Team AIO Mod++
Func displayZapLog(Const ByRef $aDarkDrills, Const ByRef $Spells)
	Local $drillStealableString = "Drills Lvl/Estimated Amount left: "
	Local $spellsLeftString = "Spells left: "
	For $i = 0 To UBound($aDarkDrills) - 1
		If $i = 0 Then
			If $aDarkDrills[$i][3] <> -1 Then $drillStealableString &= "Lvl" & $aDarkDrills[$i][2] & "/" & $aDarkDrills[$i][3]
		Else
			If $aDarkDrills[$i][3] <> -1 Then $drillStealableString &= ", Lvl" & $aDarkDrills[$i][2] & "/" & $aDarkDrills[$i][3]
		EndIf
	Next
	If $Spells[0][4] + $Spells[1][4] + $Spells[2][4] = 0 Then
		$spellsLeftString &= "None"
	Else
		If $Spells[2][4] > 0 Then $spellsLeftString &= $Spells[2][4] & " " & GetTroopName($Spells[2][1], 1)
		If $Spells[2][4] > 0 And $Spells[0][4] + $Spells[1][4] > 0 Then $spellsLeftString &= ", "
		If $Spells[0][4] + $Spells[1][4] > 0 Then $spellsLeftString &= $Spells[0][4] + $Spells[1][4] & " " & GetTroopName($Spells[1][1], 1)
	EndIf
	If $drillStealableString <> "Drills Lvl/Estimated Amount left: " Then
		If $g_bNoobZap = False Then
			SetLog($drillStealableString, $COLOR_INFO)
		Else
			If $g_bDebugSmartZap = True Then SetLog($drillStealableString, $COLOR_DEBUG)
		EndIf
	EndIf
	If $spellsLeftString <> "Spells left: " Then
		SetLog($spellsLeftString, $COLOR_INFO)
	EndIf
EndFunc   ;==>displayZapLog

Func getDarkElixir()
	Local $g_iSearchDark = "", $H37925 = 0
	If _CheckPixel($aAtkHasDarkElixir, $g_bCapturePixel, Default, "HasDarkElixir") Or _ColorCheck(_GetPixelColor(31, 144 + $g_iMidOffsetYFixed, True), Hex(0x0F0617, 6), 5) Then ; Fixed resolution
		While $g_iSearchDark = ""
			If Not $g_bRunState Then ExitLoop
			$g_iSearchDark = getDarkElixirVillageSearch(48, 126)
			$H37925 += 1
			If $H37925 > 15 Then ExitLoop
			If _Sleep($DELAYSMARTZAP1) Then Return
		WEnd
	Else
		$g_iSearchDark = False
		If $g_bDebugSmartZap = True Then SetLog(" - No DE detected.", $COLOR_DEBUG)
	EndIf
	Return $g_iSearchDark
EndFunc   ;==>getDarkElixir

Func getDrillOffset()
	Local $result = -1
	Switch $g_iTownHallLevel
		Case 0 To 7
			$result = 2
		Case 8
			$result = 1
		Case Else
			$result = 0
	EndSwitch
	Return $result
EndFunc   ;==>getDrillOffset

Func getSpellOffset()
	Local $result = -1
	Switch $g_iTownHallLevel
		Case 0 To 4
			$result = -1
		Case 5, 6
			$result = -1
		Case 7, 8
			$result = 2
		Case 9
			$result = 1
		Case Else
			$result = 0
	EndSwitch
	Return $result
EndFunc   ;==>getSpellOffset

Func smartZap($minDE = -1, $bLastChance = False)
	
	#Region - Custom SmartZap - Team AIO Mod++
	Local $performedZap = False
	
	If $g_bSmartZapEnable = False Then Return $performedZap
	If $g_bDoneSmartZap = True Then Return $performedZap

	Local $iTime = Int(AttackRemainingTime() / 1000)
	SetDebugLog("Remain time in seconds is " & $iTime & "s", $COLOR_INFO)
	If $g_iRemainTimeToZap > $iTime And $g_iRemainTimeToZap <> 0 Or $bLastChance = True Then
		SetLog("Let's ZAP, even with troops on the ground.", $COLOR_ACTION)
		$g_bDoneSmartZap = True
	Else
		$g_bDoneSmartZap = False
		Return $performedZap
	EndIf
	#EndRegion - Custom SmartZap - Team AIO Mod++
	
	Local $strikeOffsets = [0, 14]
	Local $drillLvlOffset, $spellAdjust, $numDrills, $testx, $testY, $tempTestX, $tempTestY, $strikeGain, $expectedDE
	Local $g_iSearchDark, $oldSearchDark = 0, $dropPoint
	Local $aSpells[3][5] = [["Own", $eLSpell, -1, -1, 0] _		 ; Own/Donated, SpellType, AttackbarPosition, Level, Count
			, ["Donated", $eLSpell, -1, -1, 0] _
			, ["Donated", $eESpell, -1, -1, 0]]
	Local $bZapDrills = True
	If $g_bDebugSmartZap = True Then SetLog("$g_bSmartZapEnable = " & $g_bSmartZapEnable & " | $g_bNoobZap = " & $g_bNoobZap, $COLOR_DEBUG)
	

	If $bZapDrills Then
		If $g_bSmartZapEnable = True And $g_bNoobZap = False Then
			SetLog("====== You have activated SmartZap Mode ======", $COLOR_ERROR)
		ElseIf $g_bNoobZap = True Then
			SetLog("====== You have activated NoobZap Mode ======", $COLOR_ERROR)
		EndIf
	EndIf
	If $minDE = -1 Then $minDE = Number($g_iSmartZapMinDE)
	If $bZapDrills Then
		$g_iSearchDark = getDarkElixirVillageSearch(48, 126)
		If Number($g_iSearchDark) = 0 Then
			SetLog("No Dark Elixir!", $COLOR_INFO)
			If $g_bDebugSmartZap = True Then SetLog("$g_iSearchDark|Current DE value: " & Number($g_iSearchDark), $COLOR_DEBUG)
			$bZapDrills = False
		Else
			If $g_bDebugSmartZap = True Then SetLog("$g_iSearchDark|Current DE value: " & Number($g_iSearchDark), $COLOR_DEBUG)
		EndIf
	EndIf
	If $bZapDrills Then
		If isAtkDarkElixirFull() Then
			SetLog("No need to zap!", $COLOR_INFO)
			If $g_bDebugSmartZap = True Then SetLog("isAtkDarkElixirFull(): True", $COLOR_DEBUG)
			$bZapDrills = False
		Else
			If $g_bDebugSmartZap = True Then SetLog("isAtkDarkElixirFull(): False", $COLOR_DEBUG)
		EndIf
	EndIf
	If $bZapDrills Then
		If $g_iTownHallLevel < 2 Then
			SetLog("Your Townhalllevel has yet to be determined.", $COLOR_ERROR)
			SetLog("It reads as TH" & $g_iTownHallLevel & ".", $COLOR_ERROR)
			SetLog("Locate your Townhall manually at Village->Misc.", $COLOR_ERROR)
			$bZapDrills = False
		ElseIf $g_iTownHallLevel < 7 Then
			SetLog("You do not have the ability to store Dark Elixir!", $COLOR_ERROR)
			If $g_bDebugSmartZap = True Then SetLog("Your Town Hall Lvl: " & Number($g_iTownHallLevel), $COLOR_DEBUG)
			$bZapDrills = False
		Else
			If $g_bDebugSmartZap = True Then SetLog("Your Town Hall Lvl: " & Number($g_iTownHallLevel), $COLOR_DEBUG)
		EndIf
	EndIf
	If $bZapDrills Then
		If $g_bDebugSmartZap = True Then SetLog("$g_bSmartZapDB = " & $g_bSmartZapDB, $COLOR_DEBUG)
		If $g_bSmartZapDB = True And $g_iMatchMode <> $DB Then
			SetLog("Not a dead base!", $COLOR_INFO)
			$bZapDrills = False
		EndIf
	EndIf
	If $bZapDrills Then
		$drillLvlOffset = getDrillOffset()
		If $g_bDebugSmartZap = True Then SetLog("Drill Level Offset is: " & Number($drillLvlOffset), $COLOR_DEBUG)
		$spellAdjust = getSpellOffset()
		If $g_bDebugSmartZap = True Then SetLog("Spell Adjust is: " & Number($spellAdjust), $COLOR_DEBUG)
	EndIf
	Local $iTroops = PrepareAttack($g_iMatchMode, True) ; Check remaining troops/spells
	If $iTroops > 0 Then
		For $i = 0 To UBound($g_avAttackTroops) - 1
			If $g_avAttackTroops[$i][0] = $eLSpell Then
				If $aSpells[0][4] = 0 Then
					If $g_bDebugSmartZap Then SetLog(GetTroopName($g_avAttackTroops[$i][0]) & ": " & $g_avAttackTroops[$i][1], $COLOR_DEBUG)
					$aSpells[0][2] = $i
					$aSpells[0][3] = Number($g_iLSpellLevel) ; Get the Level on Attack bar
					$aSpells[0][4] = $g_avAttackTroops[$i][1]
				Else
					If $g_bDebugSmartZap Then SetLog("Donated " & GetTroopName($g_avAttackTroops[$i][0]) & ": " & $g_avAttackTroops[$i][1], $COLOR_DEBUG)
					$aSpells[1][2] = $i
					$aSpells[1][3] = Number($g_iLSpellLevel) ; Get the Level on Attack bar
					$aSpells[1][4] = $g_avAttackTroops[$i][1]
				EndIf
			EndIf
			If $g_avAttackTroops[$i][0] = $eESpell Then
				If $g_bDebugSmartZap Then SetLog(GetTroopName($g_avAttackTroops[$i][0]) & ": " & $g_avAttackTroops[$i][1], $COLOR_DEBUG)
				$aSpells[2][2] = $i
				$aSpells[2][3] = Number($g_iESpellLevel) ; Get the Level on Attack bar
				$aSpells[2][4] = $g_avAttackTroops[$i][1]
			EndIf
		Next
	EndIf
	
	If $aSpells[0][4] + $aSpells[1][4] = 0 Then
		SetLog("No lightning spells trained, time to go home!", $COLOR_ERROR)
		Return $performedZap
	Else
		If $aSpells[0][4] > 0 Then
			SetLog(" - Number of " & GetTroopName($aSpells[0][1], 1) & " (Lvl " & $aSpells[0][3] & "): " & Number($aSpells[0][4]), $COLOR_INFO)
		EndIf
		If $aSpells[1][4] > 0 Then
			SetLog(" - Number of Donated " & GetTroopName($aSpells[1][1], 1) & " (Lvl " & $aSpells[1][3] & "): " & Number($aSpells[1][4]), $COLOR_INFO)
		EndIf
	EndIf
	If $aSpells[2][4] > 0 And $g_bEarthQuakeZap = True Then
		SetLog(" - Number of " & GetTroopName($aSpells[2][1], 1) & " (Lvl " & $aSpells[2][3] & "): " & Number($aSpells[2][4]), $COLOR_INFO)
	Else
		$aSpells[2][4] = 0
	EndIf
	If $bZapDrills Then
		If (Number($g_iSearchDark) < Number($minDE)) And $g_bNoobZap = True Then
			SetLog("Dark Elixir is below minimum value [" & Number($g_iSmartZapMinDE) & "]!", $COLOR_INFO)
			If $g_bDebugSmartZap = True Then SetLog("$g_iSearchDark|Current DE value: " & Number($g_iSearchDark), $COLOR_DEBUG)
			$bZapDrills = False
		ElseIf Number($g_iSearchDark) < ($g_aDrillLevelTotal[3 - $drillLvlOffset] / $g_aDrillLevelHP[3 - $drillLvlOffset] * $g_fDarkStealFactor * $g_aLSpellDmg[$aSpells[0][3] - 1] * $g_fDarkFillLevel) Then
			SetLog("There is less Dark Elixir(" & Number($g_iSearchDark) & ") than", $COLOR_INFO)
			SetLog("gain per zap for a single Lvl " & 3 - Number($drillLvlOffset) & " drill(" & Ceiling($g_aDrillLevelTotal[3 - $drillLvlOffset] / $g_aDrillLevelHP[3 - $drillLvlOffset] * $g_fDarkStealFactor * $g_aLSpellDmg[$aSpells[0][3] - 1] * $g_fDarkFillLevel) & ").", $COLOR_INFO)
			SetLog("Base is not worth a Zap!", $COLOR_INFO)
			$bZapDrills = False
		Else
			If $g_bDebugSmartZap = True Then SetLog("$g_iSearchDark = " & Number($g_iSearchDark) & " | $g_iSmartZapMinDE = " & Number($g_iSmartZapMinDE), $COLOR_DEBUG)
		EndIf
		If $g_bDebugSmartZap = True Then
			SetLog("$g_iSmartZapExpectedDE| Expected DE value:" & Number($g_iSmartZapExpectedDE), $COLOR_DEBUG)
			SetLog("$g_abStopAtkNoLoot1Enable[$DB] = " & $g_abStopAtkNoLoot1Enable[$DB] & ", $g_aiStopAtkNoLoot1Time[$DB] = " & $g_aiStopAtkNoLoot1Time[$DB] & "s", $COLOR_DEBUG)
		EndIf
	EndIf
	If $bZapDrills Then
		Local $aDarkDrills = drillSearch()
		If UBound($aDarkDrills) = 0 Then
			SetLog("No drills found!", $COLOR_INFO)
			$bZapDrills = False
		Else
			SetLog(" - Number of Dark Elixir Drills: " & UBound($aDarkDrills), $COLOR_INFO)
		EndIf
		_ArraySort($aDarkDrills, 1, 0, 0, 3)
		Local $itotalStrikeGain = 0
		Local $hTempTimer
	EndIf
	While IsAttackPage() And $bZapDrills And $aSpells[0][4] + $aSpells[1][4] + $aSpells[2][4] > 0 And UBound($aDarkDrills) > 0 And $spellAdjust <> -1
		If Not $g_bRunState Then ExitLoop
		Local $Spellused = $eLSpell
		Local $skippedZap = True
		Local $oldSearchDark = $g_iSearchDark
		CheckHeroesHealth()
		If ($g_iSearchDark < Number($g_iSmartZapMinDE)) And $g_bNoobZap = True Then
			SetLog("Dark Elixir is below minimum value [" & Number($g_iSmartZapMinDE) & "], Exiting Now!", $COLOR_INFO)
			$bZapDrills = False
			ExitLoop
		EndIf
		Local $aCluster = getDrillCluster($aDarkDrills)
		If $aCluster <> -1 Then
			Local $tLastZap = 0
			For $i = 0 To UBound($aCluster[3]) - 1
				If $aDarkDrills[($aCluster[3])[$i]][4] <> 0 Then
					If $tLastZap = 0 Then
						$tLastZap = __TimerDiff($aDarkDrills[($aCluster[3])[$i]][4])
					Else
						$tLastZap = _Min(__TimerDiff($aDarkDrills[($aCluster[3])[$i]][4]), $tLastZap)
					EndIf
				EndIf
			Next
			If $tLastZap > 0 Then
				If _Sleep(_Max($DELAYSMARTZAP10 - $tLastZap, 0)) Then Return
				Local $sToDelete = ""
				Local $iToDelete = 0
				For $i = 0 To UBound($aCluster[3]) - 1
					If $aDarkDrills[($aCluster[3])[$i]][4] <> 0 Then
						If ReCheckDrillExist($aDarkDrills[($aCluster[3])[$i]][0], $aDarkDrills[($aCluster[3])[$i]][1]) Then
							$aDarkDrills[($aCluster[3])[$i]][4] = 0
						Else
							If $sToDelete = "" Then
								$sToDelete &= ($aCluster[3])[$i]
							Else
								$sToDelete &= ";" & ($aCluster[3])[$i]
							EndIf
							$iToDelete += 1
						EndIf
					EndIf
				Next
				If $iToDelete > 1 Then
					SetLog("Removing " & $iToDelete & " destroyed drills from list.", $COLOR_ACTION)
					_ArrayDelete($aDarkDrills, $sToDelete)
					ContinueLoop
				ElseIf $iToDelete > 0 Then
					SetLog("Removing 1 destroyed drill from list.", $COLOR_ACTION)
					_ArrayDelete($aDarkDrills, $sToDelete)
					ContinueLoop
				EndIf
			EndIf
			If $g_bDebugSmartZap = True Then SetLog("Cluster Hold: " & $aCluster[2] & ", First Drill Hold: " & $aDarkDrills[0][3], $COLOR_DEBUG)
			If $aCluster[2] < $aDarkDrills[0][3] Then $aCluster = -1
		EndIf
		If $aCluster = -1 And $aDarkDrills[0][4] <> 0 Then
			If _Sleep(_Max($DELAYSMARTZAP10 - __TimerDiff($aDarkDrills[0][4]), 0)) Then Return
			If ReCheckDrillExist($aDarkDrills[0][0], $aDarkDrills[0][1]) Then
				$aDarkDrills[0][4] = 0
			Else
				SetLog("Removing 1 destroyed drill from list.", $COLOR_ACTION)
				_ArrayDelete($aDarkDrills, 0)
				ContinueLoop
			EndIf
		EndIf
		displayZapLog($aDarkDrills, $aSpells)
		$hTempTimer = __TimerInit()
		If $g_bNoobZap = True Then
			SetLog("NoobZap is going to attack any drill.", $COLOR_ACTION)
			If $aCluster <> -1 Then
				$Spellused = zapBuilding($aSpells, $aCluster[0] + $strikeOffsets[0], $aCluster[1] + $strikeOffsets[1])
				For $i = 0 To UBound($aCluster[3]) - 1
					$aDarkDrills[($aCluster[3])[$i]][4] = $hTempTimer
				Next
			Else
				$Spellused = zapBuilding($aSpells, $aDarkDrills[0][0] + $strikeOffsets[0], $aDarkDrills[0][1] + $strikeOffsets[1])
				$aDarkDrills[0][4] = $hTempTimer
			EndIf
			$performedZap = True
			$skippedZap = False
			If _Sleep($DELAYSMARTZAP4) Then Return
		Else
			If $aSpells[0][4] + $aSpells[1][4] + $aSpells[2][4] > (4 - $spellAdjust) Then
				SetLog("First condition: More than " & 4 - $spellAdjust & " Spells so attack any drill.", $COLOR_INFO)
				If $aCluster <> -1 Then
					$Spellused = zapBuilding($aSpells, $aCluster[0] + $strikeOffsets[0], $aCluster[1] + $strikeOffsets[1])
					For $i = 0 To UBound($aCluster[3]) - 1
						$aDarkDrills[($aCluster[3])[$i]][4] = $hTempTimer
					Next
				Else
					$Spellused = zapBuilding($aSpells, $aDarkDrills[0][0] + $strikeOffsets[0], $aDarkDrills[0][1] + $strikeOffsets[1])
					$aDarkDrills[0][4] = $hTempTimer
				EndIf
				$performedZap = True
				$skippedZap = False
				If _Sleep($DELAYSMARTZAP4) Then Return
			ElseIf $aSpells[0][4] + $aSpells[1][4] + $aSpells[2][4] > (3 - $spellAdjust) And $aDarkDrills[0][2] > (3 - $drillLvlOffset) Then
				SetLog("Second condition: Attack Lvl " & 4 - Number($drillLvlOffset) & " and greater drills if you have more than " & 3 - Number($spellAdjust) & " spells", $COLOR_INFO)
				If $aCluster <> -1 Then
					$Spellused = zapBuilding($aSpells, $aCluster[0] + $strikeOffsets[0], $aCluster[1] + $strikeOffsets[1])
					For $i = 0 To UBound($aCluster[3]) - 1
						$aDarkDrills[($aCluster[3])[$i]][4] = $hTempTimer
					Next
				Else
					$Spellused = zapBuilding($aSpells, $aDarkDrills[0][0] + $strikeOffsets[0], $aDarkDrills[0][1] + $strikeOffsets[1])
					$aDarkDrills[0][4] = $hTempTimer
				EndIf
				$performedZap = True
				$skippedZap = False
				If _Sleep($DELAYSMARTZAP4) Then Return
			ElseIf $aDarkDrills[0][2] > (4 - $drillLvlOffset) And ($aDarkDrills[0][3] / ($g_aDrillLevelTotal[$aDarkDrills[0][2] - 1] * $g_fDarkStealFactor)) > 0.3 Then
				SetLog("Third condition: Attack Lvl " & 5 - Number($drillLvlOffset) & " drills with more then 30% estimated DE left", $COLOR_INFO)
				If $aCluster <> -1 Then
					$Spellused = zapBuilding($aSpells, $aCluster[0] + $strikeOffsets[0], $aCluster[1] + $strikeOffsets[1])
					For $i = 0 To UBound($aCluster[3]) - 1
						$aDarkDrills[($aCluster[3])[$i]][4] = $hTempTimer
					Next
				Else
					$Spellused = zapBuilding($aSpells, $aDarkDrills[0][0] + $strikeOffsets[0], $aDarkDrills[0][1] + $strikeOffsets[1])
					$aDarkDrills[0][4] = $hTempTimer
				EndIf
				$performedZap = True
				$skippedZap = False
				If _Sleep($DELAYSMARTZAP4) Then Return
			ElseIf $aCluster <> -1 Then
				If $aCluster[2] >= ($g_aDrillLevelTotal[5 - $drillLvlOffset] / $g_aDrillLevelHP[5 - $drillLvlOffset] * $g_fDarkStealFactor * $g_aLSpellDmg[$aSpells[0][3] - 1] * $g_fDarkFillLevel) Then
					SetLog("Fourth condition: Attack, when potential left content in cluster is greater than gain for a single Lvl " & 5 - Number($drillLvlOffset) & " drill", $COLOR_INFO)
					$Spellused = zapBuilding($aSpells, $aCluster[0] + $strikeOffsets[0], $aCluster[1] + $strikeOffsets[1])
					For $i = 0 To UBound($aCluster[3]) - 1
						$aDarkDrills[($aCluster[3])[$i]][4] = $hTempTimer
					Next
				EndIf
				$performedZap = True
				$skippedZap = False
				If _Sleep($DELAYSMARTZAP4) Then Return
			Else
				$skippedZap = True
				SetLog("Drill did not match any attack conditions, so we will remove it from the list.", $COLOR_ACTION)
				_ArrayDelete($aDarkDrills, 0)
			EndIf
		EndIf
		$g_iSearchDark = getDarkElixir()
		If Not $g_iSearchDark Or $g_iSearchDark = 0 Then
			SetLog("No Dark Elixir left!", $COLOR_INFO)
			SetDebugLog("$g_iSearchDark = " & Number($g_iSearchDark))
			If $skippedZap = False Then
				If $Spellused = $eESpell Then
					$g_iNumEQSpellsUsed += 1
				Else
					$g_iNumLSpellsUsed += 1
				EndIf
				$g_iSmartZapGain += $oldSearchDark
			EndIf
			$bZapDrills = False
			ExitLoop
		Else
			If $g_bDebugSmartZap = True Then SetLog("$g_iSearchDark = " & Number($g_iSearchDark), $COLOR_DEBUG)
		EndIf
		If $skippedZap = False Then
			If $g_bDebugSmartZap = True Then SetLog("$oldSearchDark = [" & Number($oldSearchDark) & "] - $g_iSearchDark = [" & Number($g_iSearchDark) & "]", $COLOR_DEBUG)
			$strikeGain = Number($oldSearchDark - $g_iSearchDark)
			If $g_bDebugSmartZap = True Then SetLog("$strikeGain = " & Number($strikeGain), $COLOR_DEBUG)
			$expectedDE = -1
			If $Spellused = $eESpell Then
				$g_iNumEQSpellsUsed += 1
				If $aCluster <> -1 Then
					For $i = 0 To UBound($aCluster[3]) - 1
						$expectedDE = _Max(Number($expectedDE), Ceiling(Number($g_aDrillLevelTotal[$aDarkDrills[($aCluster[3])[$i]][2] - 1] * $g_fDarkStealFactor * $g_aEQSpellDmg[$aSpells[2][3] - 1] * $g_fDarkFillLevel)))
					Next
				Else
					$expectedDE = Ceiling(Number($g_aDrillLevelTotal[$aDarkDrills[0][2] - 1] * $g_fDarkStealFactor * $g_aEQSpellDmg[$aSpells[2][3] - 1] * $g_fDarkFillLevel))
				EndIf
			Else
				$g_iNumLSpellsUsed += 1
				If $g_bNoobZap = False Then
					If $aCluster <> -1 Then
						For $i = 0 To UBound($aCluster[3]) - 1
							$expectedDE = _Max(Number($expectedDE), Ceiling(Number($g_aDrillLevelTotal[$aDarkDrills[($aCluster[3])[$i]][2] - 1] / $g_aDrillLevelHP[$aDarkDrills[($aCluster[3])[$i]][2] - 1] * $g_fDarkStealFactor * $g_aLSpellDmg[$aSpells[0][3] - 1] * $g_fDarkFillLevel)))
						Next
					Else
						$expectedDE = Ceiling(Number($g_aDrillLevelTotal[$aDarkDrills[0][2] - 1] / $g_aDrillLevelHP[$aDarkDrills[0][2] - 1] * $g_fDarkStealFactor * $g_aLSpellDmg[$aSpells[0][3] - 1] * $g_fDarkFillLevel))
					EndIf
				Else
					$expectedDE = $g_iSmartZapExpectedDE
				EndIf
			EndIf
			If $g_bDebugSmartZap = True Then SetLog("$expectedDE = " & Number($expectedDE), $COLOR_DEBUG)
			If $strikeGain < $expectedDE And $expectedDE <> -1 Then
				SetLog("Gained: " & $strikeGain & ", Expected: " & $expectedDE, $COLOR_INFO)
				If $aCluster <> -1 Then
					_ArrayDelete($aDarkDrills, _ArrayToString($aCluster[3], ";"))
					SetLog("Last zap gained less DE then expected, removing the drills from the list.", $COLOR_ACTION)
				Else
					_ArrayDelete($aDarkDrills, 0)
					SetLog("Last zap gained less DE then expected, removing the drill from the list.", $COLOR_ACTION)
				EndIf
			Else
				If $aCluster <> -1 Then
					Local $iSumTotalHP = 0
					Local $sToDelete = ""
					If UBound($aCluster[3]) = 2 Then
						For $i = 0 To 1
							$iSumTotalHP += $g_aDrillLevelTotal[$aDarkDrills[($aCluster[3])[$i]][2] - 1] * $g_aDrillLevelHP[$aDarkDrills[($aCluster[3])[Mod($i + 1, 2)]][2] - 1]
						Next
						For $i = 0 To 1
							Local $iSubGain = Ceiling(Number($strikeGain * $g_aDrillLevelTotal[$aDarkDrills[($aCluster[3])[$i]][2] - 1] * $g_aDrillLevelHP[$aDarkDrills[($aCluster[3])[Mod($i + 1, 2)]][2] - 1] / $iSumTotalHP))
							$aDarkDrills[($aCluster[3])[$i]][3] -= $iSubGain
							SetLog(($i + 1) & ".Drill Gained: " & $iSubGain & ", adjusting amount left in this drill.", $COLOR_INFO)
						Next
					Else
						For $i = 0 To 2
							$iSumTotalHP += $g_aDrillLevelTotal[$aDarkDrills[($aCluster[3])[$i]][2] - 1] * $g_aDrillLevelHP[$aDarkDrills[($aCluster[3])[Mod($i + 1, 3)]][2] - 1] * $g_aDrillLevelHP[$aDarkDrills[($aCluster[3])[Mod($i + 2, 3)]][2] - 1]
						Next
						For $i = 0 To 2
							Local $iSubGain = Ceiling(Number($strikeGain * $g_aDrillLevelTotal[$aDarkDrills[($aCluster[3])[$i]][2] - 1] * $g_aDrillLevelHP[$aDarkDrills[($aCluster[3])[Mod($i + 1, 3)]][2] - 1] * $g_aDrillLevelHP[$aDarkDrills[($aCluster[3])[Mod($i + 2, 3)]][2] - 1] / $iSumTotalHP))
							$aDarkDrills[($aCluster[3])[$i]][3] -= $iSubGain
							SetLog(($i + 1) & ".Drill Gained: " & $iSubGain & ", adjusting amount left in this drill.", $COLOR_INFO)
						Next
					EndIf
					If $sToDelete <> "" Then _ArrayDelete($aDarkDrills, $sToDelete)
				Else
					$aDarkDrills[0][3] -= $strikeGain
					SetLog("Gained: " & Number($strikeGain) & ", adjusting amount left in this drill.", $COLOR_INFO)
				EndIf
			EndIf
			$itotalStrikeGain += $strikeGain
			$g_iSmartZapGain += $strikeGain
			SetLog("Total DE from SmartZap/NoobZap: " & Number($itotalStrikeGain), $COLOR_INFO)
		EndIf
		_ArraySort($aDarkDrills, 1, 0, 0, 3)
		If $aSpells[0][4] = 0 Then
			Local $iTroops = PrepareAttack($g_iMatchMode, True)
			If $iTroops > 0 Then
				For $i = 0 To UBound($g_avAttackTroops) - 1
					If $g_avAttackTroops[$i][0] = $eLSpell Then
						If $g_bDebugSmartZap = True Then SetLog("Donated " & GetTroopName($g_avAttackTroops[$i][0], 0) & ": " & $g_avAttackTroops[$i][1], $COLOR_DEBUG)
						$aSpells[1][2] = $i
						$aSpells[1][3] = Number($g_iLSpellLevel)
						$aSpells[1][4] = $g_avAttackTroops[$i][1]
					EndIf
				Next
			EndIf
			If $aSpells[1][4] > 0 Then
				SetLog("Woohoo, found a donated " & GetTroopName($aSpells[1][1], 0) & " (Lvl " & $aSpells[1][3] & ").", $COLOR_INFO)
			EndIf
		EndIf
	WEnd
	zapCollectors($aSpells)
	zapMines($aSpells)
	If $g_bSmartZapFTW Then
		SetLog("====== SmartZap/NoobZap FTW Mode ======", $COLOR_INFO)
	Else
		Return $performedZap
	EndIf
	If _CheckPixel($aWonOneStar, True) Then
		SetLog("One Star already reached.", $COLOR_INFO)
		Return $performedZap
	EndIf
	If $aSpells[0][4] + $aSpells[1][4] = 0 Then
		SetLog("No lightning spells left, time to go home!", $COLOR_ERROR)
		Return $performedZap
	Else
		If $aSpells[0][4] > 0 Then
			SetLog(" - Number of " & GetTroopName($aSpells[0][1], 1) & " (Lvl " & $aSpells[0][3] & "): " & Number($aSpells[0][4]), $COLOR_INFO)
		EndIf
		If $aSpells[1][4] > 0 Then
			SetLog(" - Number of Donated " & GetTroopName($aSpells[1][1], 1) & " (Lvl " & $aSpells[1][3] & "): " & Number($aSpells[1][4]), $COLOR_INFO)
		EndIf
	EndIf
	Local $iPercentageNeeded = 50 - getOcrOverAllDamage(780, 527 + $g_iBottomOffsetY)
	SetLog("Percentage needed: " & $iPercentageNeeded, $COLOR_INFO)
	_ArrayDelete($aSpells, 2)
	Local $aEasyPrey = easyPreySearch()
	If UBound($aEasyPrey) = 0 Then
		SetLog("No easy targets found!", $COLOR_INFO)
		Return $performedZap
	Else
		Local $iTargetCount = 0
		For $iTargets = 0 To UBound($aEasyPrey) - 1
			$iTargetCount += $aEasyPrey[$iTargets][2]
			If $g_bDebugSmartZap = True Then
				SetLog($iTargets + 1 & ". target: x=" & $aEasyPrey[$iTargets][0] & ",y=" & $aEasyPrey[$iTargets][1] & ",w=" & $aEasyPrey[$iTargets][2], $COLOR_DEBUG)
			EndIf
		Next
		SetLog("Count of easy targets: " & $iTargetCount, $COLOR_INFO)
		$iTargetCount = 0
		For $iTargets = 0 To _Min(Number(UBound($aEasyPrey) - 1), Number($aSpells[0][4] + $aSpells[1][4]) - 1)
			$iTargetCount += $aEasyPrey[$iTargets][2]
		Next
		SetLog("Easy targets, we can zap: " & $iTargetCount, $COLOR_INFO)
		If $iPercentageNeeded > $iTargetCount Then
			SetLog("No chance to win!", $COLOR_INFO)
			SetLog("Needed percentage (" & $iPercentageNeeded & ") is greater than targets, we can zap (" & $iTargetCount & ")!", $COLOR_INFO)
			Return $performedZap
		EndIf
	EndIf
	Local $Spellused = $eLSpell
	While IsAttackPage() And $aSpells[0][4] + $aSpells[1][4] > 0 And UBound($aEasyPrey) > 0 And Not _CheckPixel($aWonOneStar, True)
		If Not $g_bRunState Then ExitLoop
		$Spellused = zapBuilding($aSpells, $aEasyPrey[0][0] + 5, $aEasyPrey[0][1] + 5)
		_ArrayDelete($aEasyPrey, 0)
		If _Sleep(6000) Then Return
	WEnd
	If _CheckPixel($aWonOneStar, True) Then
		SetLog("Hooray, One Star reached, we have won!", $COLOR_INFO)
	EndIf
	Return $performedZap
EndFunc   ;==>smartZap

Func zapBuilding(ByRef $Spells, $x, $y)
	Local $iSpell
	For $i = 0 To UBound($Spells) - 1
		If $Spells[$i][4] > 0 Then
			$iSpell = $i
		EndIf
	Next
	If $Spells[$iSpell][2] > -1 Then
		SetLog("Dropping " & $Spells[$iSpell][0] & " " & String(GetTroopName($Spells[$iSpell][1], 0)), $COLOR_ACTION)
		SelectDropTroop($Spells[$iSpell][2])
		If _Sleep($DELAYCASTSPELL1) Then Return
		If IsAttackPage() Then
			AttackClick($x, $y, $g_iInpSmartZapTimes, ($g_iInpSmartZapTimes > 1) ? (500) : (0), "#0029")
		EndIf
		$Spells[$iSpell][4] -= $g_iInpSmartZapTimes
	Else
		If $g_bDebugSmartZap = True Then SetLog("No " & String(GetTroopName($Spells[$iSpell][1], 0)) & " Found", $COLOR_DEBUG)
	EndIf
	Return $Spells[$iSpell][1]
EndFunc   ;==>zapBuilding

Func ReCheckDrillExist($x, $y)
	_CaptureRegion2($x - 25, $y - 25, $x + 25, $y + 25)
	Local $aResult = multiMatches($g_sImgSearchDrill, 1, "FV", "FV", "", 0, 1000, False)
	If UBound($aResult) > 1 Then
		If $g_bDebugSmartZap = True Then SetLog("ReCheckDrillExist: Yes| " & UBound($aResult), $COLOR_SUCCESS)
		Return True
	Else
		If $g_bDebugSmartZap = True Then SetLog("ReCheckDrillExist: No| " & UBound($aResult), $COLOR_ERROR)
	EndIf
	Return False
EndFunc   ;==>ReCheckDrillExist

Func zapCollectors(ByRef $aSpells)
	If Not $g_bChkSmartZapDestroyCollectors Then Return
	If $aSpells[0][4] + $aSpells[1][4] = 0 Then
		SetLog("No lightning spells left, zapCollectors!", $COLOR_ERROR)
		Return
	EndIf
	Local $aCollectores = SmartFarmDetection("Collectors", True)
	If Not IsArray($aCollectores) Or UBound($aCollectores) < 1 Then Return
	_CaptureRegion2()
	Local $iElixirStarted = Int(getElixirVillageSearch(48, 69 + 29))
	SetDebugLog("$iElixirStarted is " & $iElixirStarted & " Elixir")
	SetLog("Found " & UBound($aCollectores) & " Collector to ZAP!", $COLOR_SUCCESS)
	For $i = 0 To UBound($aCollectores) - 1
		If $aSpells[0][4] + $aSpells[1][4] = 0 Then
			SetLog("No lightning spells left, time to go home!", $COLOR_ERROR)
			ExitLoop
		EndIf
		SetDebugLog("Collector position is (" & $aCollectores[$i][0] & "," & $aCollectores[$i][1] & ")")
		SetDebugLog("$aSpells array : " & _ArrayToString($aSpells, ",", -1, -1, "|"))
		zapBuilding($aSpells, $aCollectores[$i][0], $aCollectores[$i][1])
		If _Sleep($DELAYSMARTZAP2) Then ExitLoop
	Next
	_CaptureRegion2()
	Local $iElixirEnded = Int(getElixirVillageSearch(48, 69 + 29)) ; True dev fix.
	SetDebugLog("$iElixirEnded is " & $iElixirEnded & " Elixir")
	Local $iDamage = getOcrOverAllDamage(780, 527 + $g_iBottomOffsetY)
	SetDebugLog("Damage is " & $iDamage & "%")
	If $iElixirStarted - $iElixirEnded > 0 Then SetLog("Zapping Collectors got " & $iElixirStarted - $iElixirEnded & " in Elixir!", $COLOR_INFO)
EndFunc   ;==>zapCollectors

Func zapMines(ByRef $aSpells)
	If Not $g_bChkSmartZapDestroyMines Then Return
	If $aSpells[0][4] + $aSpells[1][4] = 0 Then
		SetLog("No lightning spells left, zapMines!", $COLOR_ERROR)
		Return
	EndIf
	Local $aMines = SmartFarmDetection("Mines", True)
	If Not IsArray($aMines) Or UBound($aMines) < 1 Then Return
	_CaptureRegion2()
	Local $iGoldStarted = Int(getGoldVillageSearch(48, 69))
	SetDebugLog("$iGoldStarted is " & $iGoldStarted & " GOld")
	SetLog("Found " & UBound($aMines) & " Mines to ZAP!", $COLOR_SUCCESS)
	For $i = 0 To UBound($aMines) - 1
		If $aSpells[0][4] + $aSpells[1][4] = 0 Then
			SetLog("No lightning spells left, time to go home!", $COLOR_ERROR)
			ExitLoop
		EndIf
		SetDebugLog("Mine position is (" & $aMines[$i][0] & "," & $aMines[$i][1] & ")")
		SetDebugLog("$aSpells array : " & _ArrayToString($aSpells, ",", -1, -1, "|"))
		zapBuilding($aSpells, $aMines[$i][0], $aMines[$i][1])
		If _Sleep($DELAYSMARTZAP2) Then ExitLoop
	Next
	_CaptureRegion2()
	Local $iGoldEnded = Int(getGoldVillageSearch(48, 69))
	SetDebugLog("$iGoldEnded is " & $iGoldEnded & " Gold")
	Local $iDamage = getOcrOverAllDamage(780, 527 + $g_iBottomOffsetY)
	SetDebugLog("Damage is " & $iDamage & "%")
	If $iGoldStarted - $iGoldEnded > 0 Then SetLog("Zapping Mines got " & $iGoldStarted - $iGoldEnded & " in Gold!", $COLOR_INFO)
EndFunc   ;==>zapMines
#EndRegion - Custom SmartZap - Team AIO Mod++