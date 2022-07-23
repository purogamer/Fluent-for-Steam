; #FUNCTION# ====================================================================================================================
; Name ..........: PrepareAttack
; Description ...: Checks the troops when in battle, checks for type, slot, and quantity.  Saved in $g_avAttackTroops[SLOT][TYPE/QUANTITY] variable
; Syntax ........: PrepareAttack($pMatchMode[, $Remaining = False])
; Parameters ....: $pMatchMode          - a pointer value.
;                  $Remaining           - [optional] Flag for when checking remaining troops. Default is False.
; Return values .: None
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func PrepareAttack($pMatchMode, $bRemaining = False) ;Assigns troops

	; Attack CSV has debug option to save attack line image, save have png of current $g_hHBitmap2
	If ($pMatchMode = $DB And $g_aiAttackAlgorithm[$DB] = 1) Or ($pMatchMode = $LB And $g_aiAttackAlgorithm[$LB] = 1) Then
		If $g_bDebugMakeIMGCSV And $bRemaining = False And TestCapture() = 0 Then
			If $g_iSearchTH = "-" Then ; If TH is unknown, try again to find as it is needed for filename
				imglocTHSearch(True, False, False)
			EndIf
			SaveDebugImage("clean", False, Default, "TH" & $g_iSearchTH & "-") ; make clean snapshot as well
		EndIf
	EndIf

	If Not $bRemaining Then ; reset Hero variables before attack if not checking remaining troops
		$g_bDropKing = False ; reset hero dropped flags
		$g_bDropQueen = False
		$g_bDropWarden = False
		$g_bDropChampion = False
		If $g_iActivateKing = 1 Or $g_iActivateKing = 2 Then $g_aHeroesTimerActivation[$eHeroBarbarianKing] = 0
		If $g_iActivateQueen = 1 Or $g_iActivateQueen = 2 Then $g_aHeroesTimerActivation[$eHeroArcherQueen] = 0
		If $g_iActivateWarden = 1 Or $g_iActivateWarden = 2 Then $g_aHeroesTimerActivation[$eHeroGrandWarden] = 0
		If $g_iActivateChampion = 1 Or $g_iActivateChampion = 2 Then $g_aHeroesTimerActivation[$eHeroRoyalChampion] = 0

		$g_iTotalAttackSlot = 10 ; reset flag - Slot11+
		$g_bDraggedAttackBar = False
	EndIf

	SetDebugLog("PrepareAttack for " & $pMatchMode & " " & $g_asModeText[$pMatchMode], $COLOR_DEBUG)
	If $bRemaining Then
		SetLog("Checking remaining unused troops for: " & $g_asModeText[$pMatchMode], $COLOR_INFO)
	Else
		SetLog("Initiating attack for: " & $g_asModeText[$pMatchMode], $COLOR_ERROR)
	EndIf

	If _Sleep($DELAYPREPAREATTACK1) Then Return

	Local $iTroopNumber = 0

	Local $avAttackBar = GetAttackBar($bRemaining, $pMatchMode)
	For $i = 0 To UBound($g_avAttackTroops, 1) - 1
		Local $bClearSlot = True ; by default clear the slot, if no corresponding slot is found in attackbar detection
		If $bRemaining Then
			; keep initial heroes to avoid possibly "losing" them when not dropped yet
			;Local $bSlotDetectedAgain = UBound($avAttackBar, 1) > $i And $g_avAttackTroops[$i][0] = Number($avAttackBar[$i][0]) ; wrong, as attackbar array on remain is shorter
			Local $bDropped = Default
			Local $iTroopIndex = $g_avAttackTroops[$i][0]
			Switch $iTroopIndex
				Case $eKing
					$bDropped = $g_bDropKing
				Case $eQueen
					$bDropped = $g_bDropQueen
				Case $eWarden
					$bDropped = $g_bDropWarden
				Case $eChampion
					$bDropped = $g_bDropChampion
			EndSwitch
			If $bDropped = False Then
				SetDebugLog("Discard updating hero " & GetTroopName($g_avAttackTroops[$i][0]) & " because not dropped yet")
				$iTroopNumber += $g_avAttackTroops[$i][2]
				ContinueLoop
			EndIf
			If $bDropped = True Then
				;If $bSlotDetectedAgain Then
					; ok, hero was dropped, really? don't know yet... TODO add check if hero was really dropped...
				;EndIf
				SetDebugLog("Discard updating hero " & GetTroopName($g_avAttackTroops[$i][0]) & " because already dropped")
				$iTroopNumber += $g_avAttackTroops[$i][2]
				ContinueLoop
			EndIf
		EndIf

		If UBound($avAttackBar, 1) > 0 Then
			For $j = 0 To UBound($avAttackBar, 1) - 1
				If $avAttackBar[$j][1] = $i Then
					; troop slot found
					If IsUnitUsed($pMatchMode, $avAttackBar[$j][0]) Then
						$bClearSlot = False
						Local $sLogExtension = ""
						If Not $bRemaining Then
							; Select castle, siege machine and warden mode
							If $pMatchMode = $DB Or $pMatchMode = $LB Then
								Switch $avAttackBar[$j][0]
									Case $eCastle, $eWallW To $eWallW + $eSiegeMachineCount - 1
										If $g_aiAttackUseSiege[$pMatchMode] <= $eSiegeMachineCount + 1 Then ; Sieges + Castle
											SelectCastleOrSiege($avAttackBar[$j][0], Number($avAttackBar[$j][5]), $g_aiAttackUseSiege[$pMatchMode])

											If $g_aiAttackUseSiege[$pMatchMode] = 0 And Not ($avAttackBar[$j][0] = $eCastle) Then ; if the user wanted to drop castle and no troops were available, do not drop a siege
												SetDebugLog("Discard use of " & GetTroopName($avAttackBar[$j][0]) & " (" & $avAttackBar[$j][0] & ")", $COLOR_ERROR)
												ContinueLoop
											EndIf

											If $avAttackBar[$j][0] <> $eCastle Then $sLogExtension = " (level " & $g_iSiegeLevel & ")"
										EndIf
									Case $eWarden
										If $g_aiAttackUseWardenMode[$pMatchMode] <= 1 Then $sLogExtension = SelectWardenMode($g_aiAttackUseWardenMode[$pMatchMode], Number($avAttackBar[$j][5]))
								EndSwitch
							EndIf

							; populate the i-th slot
							$g_avAttackTroops[$i][0] = Number($avAttackBar[$j][0]) ; Troop Index
							$g_avAttackTroops[$i][1] = Number($avAttackBar[$j][2]) ; Amount
							$g_avAttackTroops[$i][2] = Number($avAttackBar[$j][3]) ; X-Coord
							$g_avAttackTroops[$i][3] = Number($avAttackBar[$j][4]) ; Y-Coord
							$g_avAttackTroops[$i][4] = Number($avAttackBar[$j][5]) ; OCR X-Coord
							$g_avAttackTroops[$i][5] = Number($avAttackBar[$j][6]) ; OCR Y-Coord
						Else
							; only update amount of i-th slot
							$g_avAttackTroops[$i][1] = Number($avAttackBar[$j][2]) ; Amount
						EndIf
						$iTroopNumber += $avAttackBar[$j][2]

						Local $sDebugText = $g_bDebugSetlog ? " (X:" & $avAttackBar[$j][3] & "|Y:" & $avAttackBar[$j][4] & "|OCR-X:" & $avAttackBar[$j][5] & "|OCR-Y:" & $avAttackBar[$j][6] & ")" : ""
						SetLog($avAttackBar[$j][1] & ": " & $avAttackBar[$j][2] & " " & GetTroopName($avAttackBar[$j][0], $avAttackBar[$j][2]) & $sLogExtension & $sDebugText, $COLOR_SUCCESS)
					Else
						SetDebugLog("Discard use of " & GetTroopName($avAttackBar[$j][0]) & " (" & $avAttackBar[$j][0] & ")", $COLOR_ERROR)
					EndIf
					ExitLoop
				EndIf
			Next
		EndIf

		If $bClearSlot Then
			; slot not identified
			$g_avAttackTroops[$i][0] = -1
			$g_avAttackTroops[$i][1] = 0
			$g_avAttackTroops[$i][2] = 0
			$g_avAttackTroops[$i][3] = 0
			$g_avAttackTroops[$i][4] = 0
			$g_avAttackTroops[$i][5] = 0
		EndIf
	Next
	If Not $bRemaining Then SetSlotSpecialTroops()

	Return $iTroopNumber
EndFunc   ;==>PrepareAttack

Func SelectCastleOrSiege(ByRef $iTroopIndex, $iX, $iCmbSiege)

	Local $hStarttime = _Timer_Init()
	Local $aSiegeTypes[8] = [$eCastle, $eWallW, $eBattleB, $eStoneS, $eSiegeB, $eLogL, $eFlameF, "Any"]

	Local $iToUse = $aSiegeTypes[$iCmbSiege]
	Local $bNeedSwitch = False, $bAnySiege = False

	Local $sLog = GetTroopName($iTroopIndex)

	Switch $iToUse
		Case $iTroopIndex ; the same as current castle/siege
			If $iTroopIndex <> $eCastle And $g_iSiegeLevel < 4 Then
				$bNeedSwitch = True
				SetLog(GetTroopName($iTroopIndex) & " level " & $g_iSiegeLevel & " detected. Try looking for higher level.")
			EndIf

		Case $eCastle, $eWallW To $eWallW + $eSiegeMachineCount - 1 ; NOT the same as current castle/siege
			$bNeedSwitch = True
			SetLog(GetTroopName($iTroopIndex) & ($iToUse <> $eCastle ? " level " & $g_iSiegeLevel & " detected. Try looking for " : " detected. Switching to ") & GetTroopName($iToUse))

		Case "Any" ; use any siege
			If $iTroopIndex = $eCastle Or ($iTroopIndex <> $eCastle And $g_iSiegeLevel < 4) Then ; found Castle or a low level Siege
				$bNeedSwitch = True
				$bAnySiege = True
				SetLog(GetTroopName($iTroopIndex) & ($iTroopIndex = $eCastle ? " detected. Try looking for any siege machine" : " level " & $g_iSiegeLevel & " detected. Try looking for any higher siege machine"))
			EndIf
	EndSwitch

	If $bNeedSwitch Then
		Local $sSearchArea = GetDiamondFromRect($iX - 30 & ",612," & $iX + 35 & ",612") ; Resolution changed
		Local $aiSwitchBtn = decodeSingleCoord(findImage("SwitchSiegeButton", $g_sImgSwitchSiegeMachine & "SiegeAtt*", $sSearchArea, 1, True, Default))
		If IsArray($aiSwitchBtn) And UBound($aiSwitchBtn, 1) = 2 Then
			ClickP($aiSwitchBtn)

			; wait to appears the new small window
			Local $iLastX = $aiSwitchBtn[0] - 30, $iLastY = $aiSwitchBtn[1]
			If _Sleep(1250) Then Return

			; Lets detect the CC & Sieges and click - search window is - X, 442, X + 390, 442 + 60
			Local $sSearchArea = GetDiamondFromRect(_Min($iX - 50, 470) & ",442(500,60)") ; x = 470 when Castle is at slot 6+ and there are 5 slots in siege switching window ; Resolution changed
			SetLog($sSearchArea)
			Local $aSearchResult = findMultiple($g_sImgSwitchSiegeMachine, $sSearchArea, $sSearchArea, 0, 1000, 5, "objectname,objectpoints", True)
			SetDebugLog("Benchmark Switch Siege imgloc: " & StringFormat("%.2f", _Timer_Diff($hStarttime)) & "'ms")
			$hStarttime = _Timer_Init()
			
			Local $aCoords, $SiegeLevel
			If $aSearchResult <> "" And IsArray($aSearchResult) Then
				Local $aFinalCoords, $iFinalLevel = 0, $iFinalSiege

				For $i = 0 To UBound($aSearchResult) - 1
					Local $aAvailable = $aSearchResult[$i]
					SetDebugLog("SelectCastleOrSiege() $aSearchResult[" & $i & "]: " & _ArrayToString($aAvailable))

					Local $iSiegeIndex = TroopIndexLookup($aAvailable[0], "SelectCastleOrSiege()")
					Local $sAllCoordsString = _ArrayToString($aAvailable, "|", 1)
					Local $aAllCoords = decodeMultipleCoords($sAllCoordsString, 50)

					If $iSiegeIndex = $iToUse And $iSiegeIndex = $eCastle Then
						$aFinalCoords = $aAllCoords[0]
						$iFinalSiege = $iSiegeIndex
						ExitLoop
					EndIf

					If $iSiegeIndex >= $eWallW And $iSiegeIndex <= Int($eWallW + $eSiegeMachineCount - 1) And ($bAnySiege Or $iSiegeIndex = $iToUse) Then
						For $j = 0 To UBound($aAllCoords) - 1
							$aCoords = $aAllCoords[$j]
							$SiegeLevel = Number(getTroopsSpellsLevel(Number($aCoords[0]) - 30, 587 + $g_iBottomOffsetYFixed))

							; Just in case of Level 1
							If $SiegeLevel = 0 Then $SiegeLevel = 1 ; Number if not found digit returns 0.
							If $iFinalLevel < Number($SiegeLevel) Then
								$iFinalLevel = Number($SiegeLevel)
								$aFinalCoords = $aCoords
								$iFinalSiege = $iSiegeIndex
							EndIf
							SetDebugLog($i & "." & $j & ". Name: " & $aAvailable[0] & ", Level: " & $SiegeLevel & ", Coords: " & _ArrayToString($aCoords))
							If $iFinalLevel = 4 Then ExitLoop 2
						Next
					EndIf
				Next
				SetDebugLog("Benchmark Switch Siege Levels: " & StringFormat("%.2f", _Timer_Diff($hStarttime)) & "'ms")
				$hStarttime = _Timer_Init()

				If ($iTroopIndex = $iToUse Or $bAnySiege) And $g_iSiegeLevel >= $iFinalLevel Then
					SetLog($bAnySiege ? "No higher level siege machine found" : "No higher level of " & GetTroopName($iTroopIndex) & " found")
					Click($iLastX, $iLastY, 1)
				ElseIf IsArray($aFinalCoords) Then
					ClickP($aFinalCoords, 1, 0)
					$g_iSiegeLevel = $iFinalLevel
					$iTroopIndex = $iFinalSiege
				Else
					If Not $bAnySiege Then SetLog("No " & GetTroopName($iToUse) & " found")
					Click($iLastX, $iLastY, 1)
				EndIf

			Else
				If $g_bDebugImageSave Then SaveDebugImage("PrepareAttack_SwitchSiege")
				; If was not detectable lets click again on green icon to hide the window!
				Setlog("Undetected " & ($bAnySiege ? "any siege machine " : GetTroopName($iToUse)) & " after click on switch btn!", $COLOR_DEBUG)
				Click($iLastX, $iLastY, 1)
			EndIf
			If _Sleep(750) Then Return
		EndIf
	EndIf
	SetDebugLog("Benchmark Switch Siege Detection: " & StringFormat("%.2f", _Timer_Diff($hStarttime)) & "'ms")

EndFunc   ;==>SelectCastleOrSiege

Func SelectWardenMode($iMode, $XCoord)
	; check current G.Warden's mode. Switch to preferred $iMode if needed. Return log text as "(Ground)"  or "(Air)"

	Local $hStarttime = _Timer_Init()
	Local $aSelectMode[2] = ["Ground", "Air"], $aSelectSymbol[2] = ["Foot", "Wing"]
	Local $sLogText = ""

	Local $sArrow = GetDiamondFromRect($XCoord - 20 & ",612(68,20)") ; Resolution changed
	Local $aCurrentMode = findMultiple($g_sImgSwitchWardenMode, $sArrow, $sArrow, 0, 1000, 1, "objectname,objectpoints", True)

	If $aCurrentMode <> "" And IsArray($aCurrentMode) Then
		Local $aCurrentModeArray = $aCurrentMode[0]
		If Not IsArray($aCurrentModeArray) Or UBound($aCurrentModeArray) < 2 Then Return $sLogText

		SetDebugLog("SelectWardenMode() $aCurrentMode[0]: " & _ArrayToString($aCurrentModeArray))
		If $g_bDebugSetlog Then SetLog("Benchmark G. Warden mode detection: " & StringFormat("%.2f", _Timer_Diff($hStarttime)) & "'ms", $COLOR_DEBUG)

		If $aCurrentModeArray[0] = $aSelectMode[$iMode] Then
			$sLogText = " (" & $aCurrentModeArray[0] & " mode)"
		Else
			Local $aArrowCoords = StringSplit($aCurrentModeArray[1], ",", $STR_NOCOUNT)
			ClickP($aArrowCoords, 1, 0)
			If _Sleep(1200) Then Return

			Local $sSymbol = GetDiamondFromRect(_Min($XCoord - 30, 696) & ",488(162,18)") ; x = 696 when Grand Warden is at slot 10 ; Resolution changed
			Local $aAvailableMode = findMultiple($g_sImgSwitchWardenMode, $sSymbol, $sSymbol, 0, 1000, 2, "objectname,objectpoints", True)
			If $aAvailableMode <> "" And IsArray($aAvailableMode) Then
				For $i = 0 To UBound($aAvailableMode, $UBOUND_ROWS) - 1
					Local $aAvailableModeArray = $aAvailableMode[$i]
					SetDebugLog("SelectWardenMode() $aAvailableMode[" & $i & "]: " & _ArrayToString($aAvailableModeArray))
					If $aAvailableModeArray[0] = $aSelectSymbol[$iMode] Then
						Local $aSymbolCoords = StringSplit($aAvailableModeArray[1], ",", $STR_NOCOUNT)
						ClickP($aSymbolCoords, 1, 0)
						$sLogText =  " (" & $aSelectMode[$iMode] & " mode)"
						ExitLoop
					EndIf
				Next
				If $sLogText = "" Then ClickP($aArrowCoords, 1, 0)
				If $g_bDebugSetlog Then SetLog("Benchmark G. Warden mode selection: " & StringFormat("%.2f", _Timer_Diff($hStarttime)) & "'ms", $COLOR_DEBUG)
			EndIf
		EndIf
	EndIf
	Return $sLogText

EndFunc   ;==>SelectWardenMode

Func IsUnitUsed($iMatchMode, $iTroopIndex)
	If $iTroopIndex < $eKing Then ;Index is a Troop
		If $iMatchMode = $DT Or $iMatchMode = $TB Then Return True
		Local $aTempArray = $g_aaiTroopsToBeUsed[$g_aiAttackTroopSelection[$iMatchMode]]
		Local $iFoundAt = _ArraySearch($aTempArray, $iTroopIndex)
		If $iFoundAt <> -1 Then	Return True
		Return False
	Else ; Index is a Hero/Siege/Castle/Spell
		If $iMatchMode <> $DB And $iMatchMode <> $LB Then
			Return True
		Else
			Switch $iTroopIndex
				Case $eKing
					If (BitAND($g_aiAttackUseHeroes[$iMatchMode], $eHeroKing) = $eHeroKing) Then Return True
				Case $eQueen
					If (BitAND($g_aiAttackUseHeroes[$iMatchMode], $eHeroQueen) = $eHeroQueen) Then Return True
				Case $eWarden
					If (BitAND($g_aiAttackUseHeroes[$iMatchMode], $eHeroWarden) = $eHeroWarden) Then Return True
				Case $eChampion
					If (BitAND($g_aiAttackUseHeroes[$iMatchMode], $eHeroChampion) = $eHeroChampion) Then Return True
				Case $eCastle, $eWallW, $eBattleB, $eStoneS, $eSiegeB, $eLogL, $eFlameF
					If $g_abAttackDropCC[$iMatchMode] Then Return True
				Case $eLSpell
					If $g_abAttackUseLightSpell[$iMatchMode] Or $g_bSmartZapEnable Then Return True 
				; Smart Farm - Team AIO Mod++
				Case $eHSpell
                    If $g_abAttackUseHealSpell[$iMatchMode] Or $g_bSmartFarmSpellsEnable Or $g_abAttackStdSmartDropSpells[$g_iMatchMode] Then Return True 
				; Smart Farm - Team AIO Mod++
				Case $eRSpell
                    If $g_abAttackUseRageSpell[$iMatchMode] Or $g_bSmartFarmSpellsEnable Or $g_abAttackStdSmartDropSpells[$g_iMatchMode] Then Return True
				; Smart Milk - Team AIO Mod++
				Case $eJSpell
					If $g_abAttackUseJumpSpell[$iMatchMode] Or ($g_iMatchMode = $DB And $g_aiAttackAlgorithm[$DB] = 3) Then Return True
				Case $eFSpell
					If $g_abAttackUseFreezeSpell[$iMatchMode] Then Return True
				Case $ePSpell
					If $g_abAttackUsePoisonSpell[$iMatchMode] Then Return True
				Case $eESpell
					If $g_abAttackUseEarthquakeSpell[$iMatchMode] = 1 Or $g_bSmartZapEnable Then Return True
				Case $eHaSpell
					If $g_abAttackUseHasteSpell[$iMatchMode] Then Return True
				Case $eCSpell
					If $g_abAttackUseCloneSpell[$iMatchMode] Then Return True
				Case $eISpell
					If $g_abAttackUseInvisibilitySpell[$iMatchMode] Then Return True
				Case $eSkSpell
					If $g_abAttackUseSkeletonSpell[$iMatchMode] Then Return True
				Case $eBtSpell
					If $g_abAttackUseBatSpell[$iMatchMode] Then Return True
				Case Else
					Return False
			EndSwitch
			Return False
		EndIf

		Return False
	EndIf
	Return False
EndFunc   ;==>IsUnitUsed

Func AttackRemainingTime($bInitialze = Default)
	If $bInitialze Then
		$g_hAttackTimer = __TimerInit()
		$g_iAttackTimerOffset = Default
		SuspendAndroidTime(True) ; Reset suspend Android time for compensation when Android is suspended
		Return
	EndIf

	Local $iPrepareTime = 29 * 1000

	If $g_iAttackTimerOffset = Default Then

		; now attack is really starting (or it has already after 30 Seconds)

		; set offset
		$g_iAttackTimerOffset = __TimerDiff($g_hAttackTimer) - SuspendAndroidTime()

		If $g_iAttackTimerOffset > $iPrepareTime Then
			; adjust offset by remove "lost" attack time
			$g_iAttackTimerOffset = $iPrepareTime - $g_iAttackTimerOffset
		EndIf

	EndIf

;~ 	If Not $bInitialze Then Return

	; Return remaining attack time
	Local $iAttackTime = 3 * 60 * 1000
	Local $iRemaining = $iAttackTime - (__TimerDiff($g_hAttackTimer) - SuspendAndroidTime() - $g_iAttackTimerOffset)
	If $iRemaining < 0 Then Return 0
	Return $iRemaining

EndFunc   ;==>AttackRemainingTime
