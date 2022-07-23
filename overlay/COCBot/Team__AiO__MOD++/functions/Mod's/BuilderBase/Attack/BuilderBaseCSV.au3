; #FUNCTION# ====================================================================================================================
; Name ..........: BuilderBaseCSV
; Description ...: Use on Builder Base attack
; Syntax ........: BuilderBaseCSV()
; Parameters ....:
; Return values .: None
; Author ........: ProMac (03-2018), Fahid.Mahmood, Team AIO Mod++ ! (2018-2020), Dissociable (08-2020)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as Multibot and ClashGameBot. Copyright 2015-2020
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

; PARSE CSV FILE
Func TestBuilderBaseParseAttackCSV()
	Setlog("** TestBuilderBaseParseAttackCSV START**", $COLOR_DEBUG)
	Local $bStatus = $g_bRunState
	$g_bRunState = True

	Local $bTempDebug = $g_bDOCRDebugImages
	$g_bDOCRDebugImages = True

	BuilderBaseResetAttackVariables()

	; Attack Bar | [0] = Troops Name , [1] = X-axis , [2] - Quantities
	;Local $aAvailableTroops = BuilderBaseAttackBar()
	Local $aAvailableTroops = GetAttackBarBB()

	If IsArray($aAvailableTroops) Then

		; Zoomout the Opponent Village.
		ZoomOut(False, True)

		; Correct script.
		BuilderBaseSelectCorrectScript($aAvailableTroops)

		Local $FurtherFrom = 5 ; 5 pixels before the deploy point.
		BuilderBaseGetDeployPoints($FurtherFrom, True)

		; Parse CSV , Deploy Troops and Get Machine Status [attack algorithm] , waiting for Battle ends window.
		BuilderBaseParseAttackCSV($aAvailableTroops, $g_aDeployPoints, $g_aBestDeployPoints, $g_aOuterDeployPoints, True)

		; Attack Report Window.
		BuilderBaseAttackReport()

	EndIf

	$g_bDOCRDebugImages = $bTempDebug
	$g_bRunState = $bStatus

	Setlog("** TestBuilderBaseParseAttackCSV END**", $COLOR_DEBUG)
EndFunc   ;==>TestBuilderBaseParseAttackCSV

; Main Function
Func BuilderBaseParseAttackCSV($aAvailableTroops, $DeployPoints, $BestDeployPoints, $OuterDeployPoints, $bDebug = False)

	; Reset Stats
	$g_iLastDamage = 0

	Local $FileNamePath = @ScriptDir & "\CSV\BuilderBase\" & $g_sAttackScrScriptNameBB[$g_iBuilderBaseScript] & ".csv"
	; Columm Names
	Local $aIMGLtxt[8] = ["AirDefenses", "Crusher", "GuardPost", "Cannon", "AirBombs", "LavaLauncher", "Roaster", "BuilderHall"]
	Local $aDROP = ["CMD", "QTY", "TROOPNAME__", "DROP_POINTS_", "ADDTILES_", "DROP_SIDE", "SLEEPAFTER_", "OBS"]
	Local $aSplitLine, $command

	; [x][0] = Troops Name , [x][1] = X-axis , [x][2] - Y-Axis [x][3] - Slot starting at 0, [x][4] - Quantity
	Local $aAvailableTroops_NXQ = $aAvailableTroops

	; [0] - TopLeft ,[1] - TopRight , [2] - BottomRight , [3] - BottomLeft
	Local $aBestDeployPoints = $BestDeployPoints ;Best Filtered 10 Points
	Local $aDeployPoints = $DeployPoints ; Non Filterd Deploy Points
	Local $aOuterDeployPoints = $OuterDeployPoints ; Non Filterd Deploy Points

	If FileExists($FileNamePath) Then
		Local $aLines = FileReadToArray($FileNamePath)
		If @error Then Setlog("There was an error reading the CSV file. @error: " & @error, $COLOR_WARNING)

		Local $Line = "", $BuildingSide = ""

		; Loop for every line on CSV
		For $iLine = 0 To UBound($aLines) - 1
			If Not $g_bRunState Then Return
			$Line = $aLines[$iLine]
			SetDebugLog("[" & $iLine & "] " & $Line)
			; Split the Line , delimiter "|"
			$aSplitLine = StringSplit($Line, "|", $STR_NOCOUNT)
			If UBound($aSplitLine) < 5 Then ContinueLoop
			; Remove all spaces and converts a string to uppercase
			$command = StringStripWS(StringUpper($aSplitLine[0]), $STR_STRIPALL)

			If $command = "NOTE" Or $command = "GUIDE" Then ContinueLoop
			SetDebugLog("[CMD]: " & $command)
			Switch $command
				Case "IMGL", "FORC"

					Local $iTotalDefenses = -1, $bNewDefenses = False
					For $sSum In $aSplitLine
						If StringIsDigit(StringStripWS($sSum, $STR_STRIPALL)) Then
							$iTotalDefenses += 1
						EndIf
					Next

					If $iTotalDefenses > 4 Then
						SetLog("CSV v2 BB detected.", $COLOR_INFO)
						$bNewDefenses = True
					Else
						SetLog("CSV v1 BB detected.", $COLOR_INFO)
					EndIf

					Switch $command
						Case "IMGL"
							For $i = 0 To UBound($aIMGLtxt) -1

								If $bNewDefenses = False And $i = 4 Then
									ExitLoop
								EndIf

								$command = Int(StringStripWS($aSplitLine[$i + 1], $STR_STRIPALL))
								If $command = 1 Then
									; Remember the Buildings Arrays is :  [0] = name , [1] = Xaxis , [1] = Yaxis
									Switch $i
										Case 0
											$g_aAirdefensesPos = BuilderBaseBuildingsDetection(0)
											Setlog("Detected Air defenses: " & UBound($g_aAirdefensesPos), $COLOR_INFO)
										Case 1
											$g_aCrusherPos = BuilderBaseBuildingsDetection(1)
											Setlog("Detected Crusher: " & UBound($g_aCrusherPos), $COLOR_INFO)
										Case 2
											$g_aGuardPostPos = BuilderBaseBuildingsDetection(2)
											Setlog("Detected Guard Post: " & UBound($g_aGuardPostPos), $COLOR_INFO)
										Case 3
											$g_aCannonPos = BuilderBaseBuildingsDetection(3)
											Setlog("Detected Cannon: " & UBound($g_aCannonPos), $COLOR_INFO)
										Case 4
											$g_aAirBombs = BuilderBaseBuildingsDetection(4)
											Setlog("Detected Air Bombs: " & UBound($g_aAirBombs), $COLOR_INFO)
										Case 5
											$g_aLavaLauncherPos = BuilderBaseBuildingsDetection(5)
											Setlog("Detected Lava Launcher: " & UBound($g_aLavaLauncherPos), $COLOR_INFO)
										Case 6
											$g_aRoasterPos = BuilderBaseBuildingsDetection(6)
											Setlog("Detected Roaster: " & UBound($g_aRoasterPos), $COLOR_INFO)
										Case 7
											; Is not necessary to get again if was detected when deploy point detection ran
											If $g_aBuilderHallPos = -1 Then $g_aBuilderHallPos = UpdateBHPos() ;BuilderBaseBuildingsDetection(7)
									EndSwitch
								EndIf
							Next
							
							; Main Side to attack
							$g_aBBMainSide = BuilderBaseAttackMainSide()
							Setlog("Detected Front Side: " & $g_aBBMainSide, $COLOR_INFO)
						Case "FORC"
							; Main Side to attack If necessary
							Local $bAlreadyForcedSide = False
							For $i = 0 To UBound($aIMGLtxt) -1

								If $bNewDefenses = False And $i = 4 Then
									ExitLoop
								EndIf

								$command = Int(StringStripWS($aSplitLine[$i + 1 ], $STR_STRIPALL))
								If $command = 1 Then
									Setlog("Check Force Detection For: " & $aIMGLtxt[$i])
									; Get the Array inside the array $aDefensesPos
									Local $aBuildPositionArray = BuilderBaseBuildingsDetection($i)
									If UBound($aBuildPositionArray) > 0 And not @error Then
										; Let get the First building detected
										; Remember the Buildings Arrays is :  [0] = name , [1] = Xaxis , [1] = Yaxis
										Local $aBuildPosition = [$aBuildPositionArray[0][1], $aBuildPositionArray[0][2]]
										Setlog("Detected Pos: " & _ArrayToString($aBuildPosition, ","))
										; Get in string the FORCED Side name
										If Not $bAlreadyForcedSide Then
											$g_aBBMainSide = DeployPointsPosition($aBuildPosition)
											Setlog("Forced Front Side To " & $aIMGLtxt[$i] & " : " & $g_aBBMainSide, $COLOR_INFO)
											$bAlreadyForcedSide = True
										Else
											Setlog("Forced Side Can Be Applied To Only 1 Building Ignore " & $aIMGLtxt[$i], $COLOR_INFO)
										EndIf
									EndIf
								EndIf
							Next
					EndSwitch
				Case "DROP"
					; passing all values to $aDrop from $aSplitLine
					For $i = 1 To 6
						$aDROP[$i] = StringStripWS($aSplitLine[$i], $STR_STRIPALL)
					Next

					; TROOPNAME__: [ "Barb", "Arch", "Giant", "Minion", "Breaker", "BabyD", "Cannon", "Witch", "Drop", "Pekka", "HogG", "Machine" ]
					; $aDROP[2]

					Local $sTroopName = "Barb"
					Local $iTroop = TroopIndexLookupBB($aDROP[2], "Attack CSV")
					If $iTroop = -1 Then
						SetLog("Badly troop: " & $aDROP[2], $COLOR_ERROR)
					Else
						$sTroopName = $g_asAttackBarBB[$iTroop]
					EndIf

					; DROP_SIDE: FRONT - BACK - LEFT - RIGHT (red lines)| FRONTE - BACKE - LEFTE - RIGHTE (external edges )
					; DROP_SIDE: BH - Builder Hall side will attack Only if exposed
					; DROP_SIDE: EDGEB - Will detect if exist Buildings on Corners_SIDE: FRONT - BACK - LEFT - RIGHT - BH - EDGEB
					; $aDROP[5]
					Local $sDropSide = StringUpper($aDROP[5])
					; Qty
					; $aDROP[1]
					Local $sQty = StringUpper($aDROP[1])
					If $sQty = "ALL" Then ; All command will act like remain it will get attack bar troops.
						; $aAvailableTroops_NXQ  [Name][Xaxis][Quantities]
						For $i = 0 To UBound($aAvailableTroops_NXQ) - 1
							SetDebugLog($aAvailableTroops_NXQ[$i][0] & " " & $sTroopName)
							If _CompareTexts($aAvailableTroops_NXQ[$i][0], $sTroopName, 80) Then ;We Just Need To redo the ocr for mentioned troop only
								If _CompareTexts("Machine", $sTroopName, 80) Then
									$aAvailableTroops_NXQ[$i][4] = 1
								Else
									$aAvailableTroops_NXQ[$i][4] = Number(_getTroopCountSmall(Number($aAvailableTroops_NXQ[$i][1]), 640 + $g_iBottomOffsetYFixed))
									If $aAvailableTroops_NXQ[$i][4] < 1 Then $aAvailableTroops_NXQ[$i][4] = Number(_getTroopCountBig(Number($aAvailableTroops_NXQ[$i][1]), 633 + $g_iBottomOffsetYFixed)) ; For Big numbers when the troop is selected
								EndIf
							EndIf
						Next

						If $sDropSide = "FRONT" Or $sDropSide = "BACK" Or $sDropSide = "LEFT" Or $sDropSide = "RIGHT" Then ; Use external edges Point
							$sDropSide = $sDropSide & "E"
						Else ;If BH Or EDGEB defined For All Command Change It to FRONTE because there is chance that they are problamtic
							$sDropSide = "FRONTE"
						EndIf
					EndIf
					
					; Gets Verify Quantities on Slot and what is necessary
					Local $iTotalQtyByTroop = 0
					For $i = 0 To UBound($aAvailableTroops_NXQ) - 1
						If StringInStr($aAvailableTroops_NXQ[$i][0], $sTroopName) <> 0 Then
							$iTotalQtyByTroop += $aAvailableTroops_NXQ[$i][4]
						EndIf
					Next
					
					Local $iQtyToDrop = ($sQty = "ALL") ? ($iTotalQtyByTroop) : (_Min(Int($sQty), $iTotalQtyByTroop)) ; A true dev do not overlook this.
					
					; DROP_POINTS_: Can Be Defined Like e.g Single Drop Point(5),Multi Drop Point(2,4,6),Multi Start To End(2-6)
					; Each side will have 10 points 1-10 , the 5 is the Middle , 0 = closest to BuilderHall
					; $aDROP[3]
					Local $sDropPoints = $aDROP[3]

					; ADDTILES_: Is the distance from the red line. 1 Default Do Nothing - e.g (2) Means ADD 2 tile to drop point
					; $aDROP[4]
					Local $iAddTiles = Int($aDROP[4])
					If $sDropSide = "FRONTE" Or $sDropSide = "BACKE" Or $sDropSide = "LEFTE" Or $sDropSide = "RIGHTE" Then ; If external edges Point Selected Then No need to add tiles as drop point is already end of village
						$iAddTiles = 1
					EndIf

					; SLEEPAFTER_: Sleep after in ms
					; $aDROP[6]
					Local $SleepAfter = 250
					If StringInStr($aDROP[6], "-") > 0 Then
						Local $aRand = StringSplit($aDROP[6], "-", $STR_NOCOUNT)
						$SleepAfter = Random(Int($aRand[0]), Int($aRand[1]), 1)
						Else
						$SleepAfter = Int($aDROP[6])
					EndIf

					SetDebugLog("$iQtyToDrop : " & $iQtyToDrop & ", $sQty : " & $sQty & ", $sTroopName : " & $sTroopName & ", $aSelectedDropSidePoints_XY : " & $sDropPoints & ", $iAddTiles : " & $iAddTiles & ", $sDropSide : " & $sDropSide & ", $SleepAfter : " & $SleepAfter)

					Local $iQtyOfSelectedSlot = 0 ; Quantities on current slot
					Local $iSlotNumber = 20 ; just an impossible slot to initialize it
					Local $aSlot_XY = [0, 0]

					; VerifySlotTroops uses ByRef on $aSlot_XY , $iQtyOfSelectedSlot And $iSlotNumber
					If Not VerifySlotTroop($sTroopName, $aSlot_XY, $iQtyOfSelectedSlot, $iSlotNumber, $aAvailableTroops_NXQ) Then
						TriggerMachineAbility() ;Click On Ability Before Skipping The Loop
						ContinueLoop
					EndIf

					If $sDropSide <> "BH" And $sDropSide <> "EDGEB" Then
						Local $sSelectedDropSideName ;Using For AddTile That Which Side Was Choosed To Attack
						; Correct FRONT - BACK - LEFT - RIGHT - BH - EDGEB
						Local $aSelectedDropSidePoints_XY = CorrectDropPoints($sDropSide, $BestDeployPoints, $OuterDeployPoints, $sSelectedDropSideName)
						SortPoints($aSelectedDropSidePoints_XY, $bDebug)
						; Just in Case
						If UBound($aSelectedDropSidePoints_XY) = 0 Then
							TriggerMachineAbility()
							ContinueLoop
						EndIf

						DebugPrintDropPoint($aSelectedDropSidePoints_XY, "Original", $bDebug)

						; Before Parsing Points Do Add Tiles Distance if defined
						AddTilesToDeployPoint($aSelectedDropSidePoints_XY, $iAddTiles, $sSelectedDropSideName, $bDebug)

						If $bDebug And $iAddTiles > 1 Then DebugBuilderBaseBuildingsDetection($aDeployPoints, $aBestDeployPoints, $aOuterDeployPoints, "CSVAddTile_" & $iAddTiles, $aSelectedDropSidePoints_XY, True) ;Take ScreenShot After AddTile For Debug
						;Get Points which is mentioned in CSV
						Local $aCSVParsedDeployPoint_XY = ParseCSVDropPoints($sDropPoints, $aSelectedDropSidePoints_XY, $bDebug)
						; Just in Case
						If UBound($aCSVParsedDeployPoint_XY) = 0 Then
							TriggerMachineAbility()
							ContinueLoop
						EndIf

						DebugPrintDropPoint($aCSVParsedDeployPoint_XY, "CSV Selected", $bDebug)

						; Deploy Troops
						Local $iTroopsDropped = 0
						While $iTroopsDropped < $iQtyToDrop
							For $i = 0 To UBound($aCSVParsedDeployPoint_XY) - 1
								If Not $g_bRunState Then Return
								If ($iTroopsDropped < $iQtyToDrop Or $sQty = "ALL") Then ; Check That Drop Troops Don't Get Exceeded By CSV DROP Quantity OR Drop all troops if Qunanity is ALL
									; get one Deploy point
									Local $Point2Deploy = $aCSVParsedDeployPoint_XY[$i]
									DeployTroopBB($sTroopName, $aSlot_XY, $Point2Deploy, 1)
									; Increment Troops Dropped
									$iTroopsDropped += 1
									; removing the deployed troop
									$iQtyOfSelectedSlot -= 1
									$iTotalQtyByTroop -= 1
									; Remove the Qty from the Original array :
									$aAvailableTroops_NXQ[$iSlotNumber][4] = $iQtyOfSelectedSlot
									; If is the Machine exist and depolyed
									If IsArray($g_aMachineBB) And UBound($g_aMachineBB) > 2 And $g_aMachineBB[2] Then ExitLoop (2)
									; Just in case
									If $iTotalQtyByTroop < 1 Then ExitLoop (2)
									; Let's select another slot if this slot is empty
									If $iQtyOfSelectedSlot < 1 Then
										; VerifySlotTroops uses ByRef on $aSlot_XY , $iQtyOfSelectedSlot and $iSlotNumber
										If Not VerifySlotTroop($sTroopName, $aSlot_XY, $iQtyOfSelectedSlot, $iSlotNumber, $aAvailableTroops_NXQ) Then ExitLoop (2)
									EndIf
									; Just a small Delay to Pause Function
									If _Sleep(100) Then Return
								Else
									ExitLoop (2)
								EndIf
							Next
						WEnd

					Else
						If $sDropSide = "EDGEB" Then
							; Detect all coordinates return an Array[X][3] Index 3 Contains Edge Side Name
							Local $aSelectedEdgePoints_XYS = BuilderBaseBuildingsOnEdge($aDeployPoints)
							If $aSelectedEdgePoints_XYS = "-1" Then ContinueLoop

							DebugPrintDropPoint($aSelectedEdgePoints_XYS, "Edge", $bDebug)

							; On CSV is the quantities BY edge
							$iQtyToDrop = (UBound($aSelectedEdgePoints_XYS) > 0) ? ($iQtyToDrop * UBound($aSelectedEdgePoints_XYS)) : ($iQtyToDrop)

							Local $iTroopsDropped = 0
							While $iTroopsDropped < $iQtyToDrop
								If Not $g_bRunState Then Return
								For $i = 0 To UBound($aSelectedEdgePoints_XYS) - 1
									If ($iTroopsDropped < $iQtyToDrop Or $sQty = "ALL") Then ; Check That Drop Troops Don't Get Exceeded By CSV DROP Quantity OR Drop all troops if Qunanity is ALL
										; get one Deploy point
										Local $Point2Deploy = [$aSelectedEdgePoints_XYS[$i][0], $aSelectedEdgePoints_XYS[$i][1]]
										DeployTroopBB($sTroopName, $aSlot_XY, $Point2Deploy, 1)
										; Increment Troops Dropped
										$iTroopsDropped += 1
										; removing the deployed troop
										$iQtyOfSelectedSlot -= 1
										$iTotalQtyByTroop -= 1
										; Remove the Qty from the Original array :
										$aAvailableTroops_NXQ[$iSlotNumber][4] = $iQtyOfSelectedSlot
										; If is the Machine exist and deployed
										; If IsMachineDepoloyed($sTroopName, $iSlotNumber, $bIfMachineWasDeployed, $bIfMachineHasAbility, $g_aMachineBB) Then ExitLoop (2)
										If IsArray($g_aMachineBB) And UBound($g_aMachineBB) > 2 And $g_aMachineBB[2] Then ExitLoop (2)

										If $iTotalQtyByTroop < 1 Then ExitLoop (2)
										; Let's select another slot if this slot is empty
										If $iQtyOfSelectedSlot < 1 Then
											; VerifySlotTroops uses ByRef on $aSlot_XY , $iQtyOfSelectedSlot and $iSlotNumber
											If Not VerifySlotTroop($sTroopName, $aSlot_XY, $iQtyOfSelectedSlot, $iSlotNumber, $aAvailableTroops_NXQ) Then ExitLoop (2)
										EndIf
										; Just a small Delay to Pause Function
										If _Sleep(100) Then Return
									Else
										ExitLoop (2)
									EndIf
								Next
							WEnd

						ElseIf $sDropSide = "BH" Then
							
							; Custom logic
							Local $BHposition[2] = [$DiamondMiddleX, $DiamondMiddleX]
							If UBound($g_aBuilderHallPos) > 0 And not @error Then
								$BHposition[0] = $g_aBuilderHallPos[0][1]
								$BHposition[1] = $g_aBuilderHallPos[0][2]
							EndIf
							
							; Get/Check if the distance from any deploy point is less than 75px
							Local $Point2Deploy = GetThePointNearBH($BHposition, $aDeployPoints)
							If $Point2Deploy[0] <> "" Then
								For $i = 0 To $iQtyToDrop - 1
									DeployTroopBB($sTroopName, $aSlot_XY, $Point2Deploy, 1)
									$iQtyOfSelectedSlot -= 1
									$iTotalQtyByTroop -= 1
									; Remove the Qty from the Original array :
									$aAvailableTroops_NXQ[$iSlotNumber][4] = $iQtyOfSelectedSlot
									; If is the Machine exist and deployed
									; If IsMachineDepoloyed() Then ExitLoop
									If IsArray($g_aMachineBB) And UBound($g_aMachineBB) > 2 And $g_aMachineBB[2] Then ExitLoop
									If $iTotalQtyByTroop < 1 Then ExitLoop
									; Let's select another slot if this slot is empty
									If $iQtyOfSelectedSlot < 1 Then
										; VerifySlotTroops uses ByRef on $aSlot_XY , $iQtyOfSelectedSlot and $iSlotNumber
										If Not VerifySlotTroop($sTroopName, $aSlot_XY, $iQtyOfSelectedSlot, $iSlotNumber, $aAvailableTroops_NXQ) Then ExitLoop
									EndIf
									; Just a small Delay to Pause Function
									If _Sleep(100) Then Return
								Next
							EndIf
						EndIf
					EndIf

					; A log user
					SetLog(" - " & $aAvailableTroops_NXQ[$iSlotNumber][4] & "x/" & $iTotalQtyByTroop & "x " & FullNametroops($aAvailableTroops_NXQ[$iSlotNumber][0]) & " at slot " & $iSlotNumber + 1, $COLOR_WARNING)

			EndSwitch
		Next

		; Machine Ability and Battle
		For $i = 0 To Int($SleepAfter / 50)
			; Machine Ability
			TriggerMachineAbility()
			If _Sleep(50) Then Return

			If _CheckPixel($g_aBBBlackArts, True) Then
				If _WaitForCheckImg($g_sImgOkButton, "345, 540, 524, 615") Then
					SetDebugLog("BattleIsOver | $bIsEnded.")
					ExitLoop
				EndIf
			EndIf

		Next

		; Let's Assume That Our CSV Was Bad That None Of The Troops Was Deployed Let's Deploy Everything
		; Let's make a Remain Just In Case deploy points problem somewhere in red zone OR Troop was not mentioned in CSV OR Hero Was not dropped. Let's drop All
		Local $aAvailableTroops_NXQ = GetAttackBarBB()

		If $aAvailableTroops_NXQ <> -1 And IsArray($aAvailableTroops_NXQ) Then
			SetLog("CSV Does not deploy some of the troops. So Now just dropping troops in a waves", $COLOR_INFO)
			AttackBB($aAvailableTroops_NXQ, True)
		EndIf

	Else
		SetLog($FileNamePath & " Doesn't exist!", $COLOR_WARNING)
	EndIf
EndFunc   ;==>BuilderBaseParseAttackCSV

; Extra Methods
Func DebugPrintDropPoint($DropPoint, $Text, $bDebug)
	If $bDebug Then
		SetLog($Text & " Total Deploy Point: " & UBound($DropPoint))
		For $i = 0 To UBound($DropPoint) - 1
			If (UBound($DropPoint, 2) > 0) Then ;Check If 2D Array
				SetDebugLog($Text & "  Deploy Point: " & $i + 1 & " - " & $DropPoint[$i][0] & " x " & $DropPoint[$i][1])
			Else
				Local $Point = $DropPoint[$i]
				SetDebugLog($Text & "  Deploy Point: " & $i + 1 & " - " & $Point[0] & " x " & $Point[1])
			EndIf
		Next
	EndIf
EndFunc   ;==>DebugPrintDropPoint

Func CorrectDropPoints($sDropSide, $BestDeployPoints, $OuterDeployPoints, ByRef $sSelectedDropSideName)
	Enum $tl = 0, $tr, $br, $bl
	Local $front = 0
	Local $ssidenames[4] = ["TopLeft", "TopRight", "BottomRight", "BottomLeft"]
	Local $toreturn
	For $i = 0 To UBound($ssidenames) - 1
		If $g_aBBMainSide = $ssidenames[$i] Then $front = $i
	Next
	Local $dimtoreturn = 0
	Switch $sDropSide
		Case "FRONT", "FRONTE"
			$dimtoreturn = $front
		Case "BACK", "BACKE"
			$dimtoreturn = ($front + 2 > 3) ? Abs(($front + 2) - 4) : $front + 2
		Case "LEFT", "LEFTE"
			$dimtoreturn = ($front + 1 > 3) ? Abs(($front + 1) - 4) : $front + 1
		Case "RIGHT", "RIGHTE"
			$dimtoreturn = ($front - 1 < 0) ? 4 - Abs($front - 1) : $front - 1
		Case Else
			SetLog("CSV DropSide CommAnd '" & $sDropSide & "' Not Supported.", $COLOR_ERROR)
			Return 
	EndSwitch
	If $dimtoreturn < 0 Then $dimtoreturn = 0
	$sSelectedDropSideName = $ssidenames[$dimtoreturn]
	If ($sDropSide = "FRONTE" OR $sDropSide = "BACKE" OR $sDropSide = "LEFTE" OR $sDropSide = "RIGHTE") And IsArray($OuterDeployPoints) And $dimtoreturn < UBound($OuterDeployPoints) Then
		$toreturn = $OuterDeployPoints[$dimtoreturn]
	Else
		If IsArray($BestDeployPoints) And $dimtoreturn < UBound($BestDeployPoints) Then
			$toreturn = $BestDeployPoints[$dimtoreturn]
		ElseIf IsArray($OuterDeployPoints) And $dimtoreturn < UBound($OuterDeployPoints) Then
			$toreturn = $OuterDeployPoints[$dimtoreturn]
		EndIf
	EndIf
	SetDebugLog("Main Side is " & $g_aBBMainSide & " - Drop on " & $sDropSide & " correct side will be " & $ssidenames[$dimtoreturn])
	Return $toreturn
EndFunc

Func ParseCSVDropPoints($sDropPoints, $aSelectedDropSidePoints_XY, $bDebug)
	Local $aCSVParsedDeployPoint_XY[0], $atempDeploy[2]
	Local $indexStart = 1, $indexEnd = 1, $indexArray = 0, $indexVect = 0
	;Temp Solution As For time bing using max Drop points which was detected only
	;TODO: Will Calculate More Points If less points detected
	Local $iMaxDropPoints = UBound($aSelectedDropSidePoints_XY)

	If StringInStr($sDropPoints, "-") > 0 Then ;Multi Start To End(2-6) 1-8
		$indexVect = StringSplit($sDropPoints, "-", 2)
		$indexArray = 0
		If UBound($indexVect) > 1 Then
			If Not $g_bRunState Then Return
			If Int($indexVect[0]) > 0 And Int($indexVect[1]) > 0 Then
				$indexStart = Int($indexVect[0])
				$indexEnd = Int($indexVect[1])
				If $indexStart > $indexEnd Then ;E.g someone wrote 4-2 shuffle them make 2-4
					$indexStart = Int($indexVect[1])
					$indexEnd = Int($indexVect[0])
				EndIf
				If $indexStart > $iMaxDropPoints Then $indexStart = 1
				If $indexEnd > $iMaxDropPoints Then $indexEnd = $iMaxDropPoints
				If $bDebug Then SetLog("Multi Point (" & $sDropPoints & ") , $indexStart : " & $indexStart & " , $indexEnd : " & $indexEnd)
			Else
				$indexVect = 0
			EndIf
		Else
			$indexVect = 0
		EndIf
	ElseIf StringInStr($sDropPoints, ",") > 0 Then ;Multi Drop Point(2,4,6)
		$indexArray = StringSplit($sDropPoints, ",", 2)
		$indexVect = 0
		If UBound($indexArray) > 1 Then
			$indexStart = 0
			$indexEnd = UBound($indexArray)
			If $bDebug Then SetLog("Multi Point (" & $sDropPoints & ") , $indexStart : " & $indexStart & " , $indexEnd : " & $indexEnd)
		Else
			$indexArray = 0
		EndIf
	EndIf

	; Let's find Deploy Points
	If IsArray($indexVect) = 1 Then ;Multi Start To End(2-6)
		ReDim $aCSVParsedDeployPoint_XY[$indexEnd - $indexStart + 1]
		Local $j = 0
		For $i = $indexStart To $indexEnd
			$atempDeploy[0] = $aSelectedDropSidePoints_XY[$i - 1][0]
			$atempDeploy[1] = $aSelectedDropSidePoints_XY[$i - 1][1]
			$aCSVParsedDeployPoint_XY[$j] = $atempDeploy
			$j += 1
		Next
	ElseIf IsArray($indexArray) = 1 Then ;Multi Drop Point(2,4,6)
		ReDim $aCSVParsedDeployPoint_XY[UBound($indexArray)]
		For $i = 0 To $indexEnd - 1
			If $indexArray[$i] > $iMaxDropPoints Then $indexArray[$i] = $iMaxDropPoints ;Points Can't be Greater The Max Drop Points
			If $indexArray[$i] - 1 < 0 Then $indexArray[$i] = 1
			$atempDeploy[0] = $aSelectedDropSidePoints_XY[$indexArray[$i] - 1][0]
			$atempDeploy[1] = $aSelectedDropSidePoints_XY[$indexArray[$i] - 1][1]
			$aCSVParsedDeployPoint_XY[$i] = $atempDeploy
		Next
	Else
		ReDim $aCSVParsedDeployPoint_XY[1]
		$sDropPoints = Int($sDropPoints)
		If $sDropPoints > $iMaxDropPoints Then $sDropPoints = $iMaxDropPoints ; To Avoid Crash Set To Max If More then Max Point
		$atempDeploy[0] = $aSelectedDropSidePoints_XY[$sDropPoints - 1][0]
		$atempDeploy[1] = $aSelectedDropSidePoints_XY[$sDropPoints - 1][1]
		$aCSVParsedDeployPoint_XY[0] = $atempDeploy
	EndIf

	Return $aCSVParsedDeployPoint_XY
EndFunc   ;==>ParseCSVDropPoints

Func SortPoints(ByRef $aSelectedDropSidePoints_XY, $bDebug = False)
	; SORT by X-axis - column 0
	If Not $g_bRunState Then Return
	If UBound($aSelectedDropSidePoints_XY) > 1 Then _ArraySort($aSelectedDropSidePoints_XY, 0, 0, 0, 0)
	SetDebugLog(UBound($aSelectedDropSidePoints_XY) & " points to deploy in this side!", $COLOR_DEBUG)
	If $bDebug Then _ArrayToString($aSelectedDropSidePoints_XY)
EndFunc   ;==>SortPoints

Func AddTilesToDeployPoint(ByRef $aSelectedDropSidePoints_XY, $iAddTiles, $sSelectedDropSideName, $bDebug)
	If $iAddTiles = 1 Then Return ;Default Value Is 1 Do Nothing
	If IsArray($g_aBuilderBaseOuterPolygon) = 0 Then Return ;If Builder Base Outer Polygon not defined skip
	SetDebugLog("AddTilesToDeployPoint $sSelectedDropSideName: " & $sSelectedDropSideName & ", $iAddTiles: " & $iAddTiles)
	For $i = 0 To UBound($aSelectedDropSidePoints_XY) - 1
		If Not $g_bRunState Then Return
		Local $x = $aSelectedDropSidePoints_XY[$i][0]
		Local $y = $aSelectedDropSidePoints_XY[$i][1]
		Local $pixel[2]
		Local $l
		Local $iTWithOutFF = Abs(8 - $g_iFurtherFromBBDefault)
		; use ADDTILES * X pixels per tile to add offset to vector location
		For $u = $iTWithOutFF * Abs(Int($iAddTiles)) To 0 Step -1 ; count down to zero pixels till find valid drop point
			If Int($iAddTiles) > 0 Then ; adjust for positive or negative ADDTILES value
				$l = $u
			Else
				$l = -$u
			EndIf

			Switch $sSelectedDropSideName
				Case "TopLeft"
					$pixel[0] = $x - $l
					$pixel[1] = $y - $l
				Case "TopRight"
					$pixel[0] = $x + $l
					$pixel[1] = $y - $l
				Case "BottomLeft"
					$pixel[0] = $x - $l
					$pixel[1] = $y + $l
				Case "BottomRight"
					$pixel[0] = $x + $l
					$pixel[1] = $y + $l
			EndSwitch

			If isInsideDiamondExt($pixel[0], $pixel[1], $iTWithOutFF) Then ; Check if X,Y is inside Builderbase or outside
				If $bDebug Then SetDebugLog("After AddTile: " & $iAddTiles & ", DropSide: " & $sSelectedDropSideName & ", Deploy Point: " & $i + 1 & " - " & $pixel[0] & " x " & $pixel[1])
				$aSelectedDropSidePoints_XY[$i][0] = $pixel[0]
				$aSelectedDropSidePoints_XY[$i][1] = $pixel[1]
				ExitLoop
			Else
				If $bDebug Or $g_bDebugAndroid Then SetLog("Outside Polygon DropSide, restored secure: " & $sSelectedDropSideName & ", Deploy Point: " & $i + 1 & " - " & $pixel[0] & " x " & $pixel[1], $COLOR_DEBUG)
			EndIf
		Next
	Next

EndFunc   ;==>AddTilesToDeployPoint

Func isInsideDiamondExt($iX, $iY, $iTolerance = 5)
		
	Local $Left = $ExternalArea[0][0], $Right = $ExternalArea[1][0], $Top = $ExternalArea[2][1], $Bottom = $ExternalArea[3][1]
	Local $aDiamond[2][2] = [[$Left, $Top], [$Right, $Bottom]]
	Local $aMiddle = [($aDiamond[0][0] + $aDiamond[1][0]) / 2, ($aDiamond[0][1] + $aDiamond[1][1]) / 2]
	Local $aSize = [$aMiddle[0] - $aDiamond[0][0], $aMiddle[1] - $aDiamond[0][1]]

	Local $DX = Abs($iX - $aMiddle[0])
	Local $DY = Abs($iY - $aMiddle[1])

	; allow additional 5 pixels
	If $DX >= $iTolerance Then $DX -= $iTolerance
	If $DY >= $iTolerance Then $DY -= $iTolerance

	If ($DX / $aSize[0] + $DY / $aSize[1] <= 1) And $iX > $g_aiDeployableLRTB[0] And $iX <= $g_aiDeployableLRTB[1] And $iY >= $g_aiDeployableLRTB[2] And $iY <= $g_aiDeployableLRTB[3] Then
		Return True ; Inside Village
	Else
		Return False ; Outside Village
	EndIf
EndFunc   ;==>isInsideDiamondExt

Func VerifySlotTroop($sTroopName, ByRef $aSlot_XY, ByRef $iQtyOfSelectedSlot, ByRef $iSlotNumber, $aAvailableTroops_NXQ)
	; Select Slot.
	Local $iSlotX = 0, $iSlotY = 0
	; Lets check all available troops
	For $i = 0 To UBound($aAvailableTroops_NXQ) - 1
		If Not $g_bRunState Then Return
		; verify Name and If is different then last slot
		If StringInStr($aAvailableTroops_NXQ[$i][0], $sTroopName) <> 0 And $iSlotNumber <> $i Then
			$iSlotX = $aAvailableTroops_NXQ[$i][1]
			$iSlotY = $aAvailableTroops_NXQ[$i][2]
			$iQtyOfSelectedSlot = $aAvailableTroops_NXQ[$i][4]
			If $iQtyOfSelectedSlot > 0 Then
				$iSlotNumber = $i
				ExitLoop
			EndIf
		EndIf
	Next

	; If the Troop doesn't exist
	If $iQtyOfSelectedSlot = 0 Or $iSlotX = 0 Or $iSlotY = 0 Then
		SetLog(" - " & FullNametroops($sTroopName) & " doesn't exist or empty", $COLOR_WARNING)
		Return False
	EndIf

	; Select Slot
	$aSlot_XY[0] = $iSlotX
	$aSlot_XY[1] = $iSlotY

	; Set The Battle Machine Slot Coordinates in Attack Bar
	If $sTroopName = "Machine" Then
		$g_aMachineBB[0] = $iSlotX
		$g_aMachineBB[1] = $iSlotY
	EndIf

	Click($iSlotX - Random(0, 5, 1), $iSlotY - Random(0, 5, 1), 1, 0)
	If _Sleep(250) Then Return
	Return True
EndFunc   ;==>VerifySlotTroop

Func DeployTroopBB($sTroopName, $aSlot_XY, $Point2Deploy, $iQtyToDrop)
	If $iQtyToDrop < 1 Then Return False
	
	SetDebugLog("[" & _ArrayToString($aSlot_XY) & "] - Deploying " & $iQtyToDrop & " " & FullNametroops($sTroopName) & " At " & $Point2Deploy[0] & " x " & $Point2Deploy[1], $COLOR_INFO)
	PureClickP($Point2Deploy, $iQtyToDrop, 0)

	If ($sTroopName = "Machine") Then
		If IsArray($g_aMachineBB) And ($g_aMachineBB[2] = False) Then
			; Set the Boolean To True to Say Yeah! It's Deployed!
			$g_aMachineBB[2] = True

			; It look for the white border in case it failed to launch.
			If ($g_aMachineBB[0] <> -1) Then
				If _Sleep(1000) Then Return
				$g_aMachineBB[2] = Not _ColorCheckSubjetive(_GetPixelColor($g_aMachineBB[0], 635 , True), "FFFFFF", 5)
				Local $sSay = ($g_aMachineBB[2] == True) ? ("Yeah! It's Deployed!") : (False)
				SetLog("- BB Machine is ok? " & $sSay, $COLOR_INFO)
			EndIf
		EndIf
	EndIf
EndFunc   ;==>DeployTroopBB

Func GetThePointNearBH($BHposition, $aDeployPoints)
	Local $ReturnPoint[2] = ["", ""]
	Local $Name[4] = ["TopLeft", "TopRight", "BottomRight", "BottomLeft"]
	Local $MostNear = 45
	For $i = 0 To UBound($aDeployPoints) - 1
		If Not $g_bRunState Then Return
		Local $TempCoordinatesBySide = $aDeployPoints[$i]
		For $j = 0 To UBound($TempCoordinatesBySide) - 1
			Local $SingleCoordinate = [$TempCoordinatesBySide[$j][0], $TempCoordinatesBySide[$j][1]]
			Local $Distance = Pixel_Distance(Int($BHposition[0]), Int($BHposition[1]), Int($SingleCoordinate[0]), Int($SingleCoordinate[1]))
			If $Distance < $MostNear Then
				$MostNear = $Distance
				$ReturnPoint[0] = Int($SingleCoordinate[0])
				$ReturnPoint[1] = Int($SingleCoordinate[1])
			EndIf
		Next
	Next
	Return $ReturnPoint
EndFunc   ;==>GetThePointNearBH

Func TriggerMachineAbility($bBBIsFirst = -1, $ix = -1, $iy = -1, $bTest = False)
	Local $sFuncName = "TriggerMachineAbility: "

	If UBound($g_aMachineBB) < 4 Then
		Setlog("TriggerMachineAbility | This will not work 0x1.", $COLOR_ERROR)
		Return False
	EndIf

	If ($bBBIsFirst = -1) Then $bBBIsFirst = $g_aMachineBB[3]

	; If it's not just a test, Exit the Function if Machine is not yet deployed
	If $bTest = False And $g_aMachineBB[2] = False Then Return False

	; Check and set the Coordinates of Machine Slot in Attack Bar
	If $g_aMachineBB[0] = -1 Then
		If $ix > -1 And $iy > -1 Then
			SetDebugLog($sFuncName & "Setting Coordinates to the Machine Slot manually! [" & $ix & ", " & $iy & "]", $COLOR_INFO)
			$g_aMachineBB[0] = $ix
			$g_aMachineBB[1] = $iy
		Else
			SetLog($sFuncName & "I have no coordinates to the Machine Slot Position", $COLOR_ERROR)
			Return False
		EndIf
	EndIf

	; If it's too early for a check, exit the Function! NOTE: If $g_iBBMachAbilityLastActivatedTime here is -1, it means Machine is Deployed but the Ability is not yet Activated!
	; We use random to not always get activated in an specific Time Delay
	If $g_iBBMachAbilityLastActivatedTime > -1 And __TimerDiff($g_iBBMachAbilityLastActivatedTime) < Random($g_iBBMachAbilityTime - 2000, $g_iBBMachAbilityTime + 2000, 1) Then Return False

	SetDebugLog("Checking ability of machine.", $COLOR_ACTION)

	Local $hPixel = _GetPixelColor(Int($g_aMachineBB[0]), 633, True) ; Resolution fixed
	If $bTest Or $g_bDebugSetlog Then SetDebugLog("Machine " & $hPixel & " ability color.", $COLOR_DEBUG)

	If $bBBIsFirst And ($g_aMachineBB[0] <> -1) Then
		If $bTest Or $g_bDebugSetlog Then Setlog(_ArrayToString($g_aMachineBB), $COLOR_INFO)
		If _ColorCheckSubjetive($hPixel, "472CC5", 5) Then
			Click(Int($g_aMachineBB[0] + Random(5, 15, 1)), Int($g_aMachineBB[1] + Random(5, 15, 1)), Random(1, 3, 1), 100)
			SetLog("BB Machine : Activated Ability for the first time.", $COLOR_ACTION)
			$bBBIsFirst = False
			$g_aMachineBB[3] = $bBBIsFirst
			$g_iBBMachAbilityLastActivatedTime = __TimerInit()
			If RandomSleep(300) Then Return
			Return True
		Else
			If $g_aMachineBB[3] Then SetLog("BB Machine : Skill not present.", $COLOR_INFO)
			Return False
		EndIf
	EndIf
	If _ColorCheckSubjetive($hPixel, "432CCE", 8) Then
		Click(Int($g_aMachineBB[0] + Random(5, 15, 1)), Int($g_aMachineBB[1] + Random(5, 15, 1)), Random(1, 3, 1), 100)
		SetLog("BB Machine : Activated Ability.", $COLOR_ACTION)
		$g_iBBMachAbilityLastActivatedTime = __TimerInit()
		If RandomSleep(300) Then Return
		Return True
	EndIf
	Return False
EndFunc   ;==>TriggerMachineAbility

Func BattleIsOver()
	Local $bIsEnded = False

	For $iBattleOverLoopCounter = 0 To 190
		If _Sleep(1000) Then Return
		If Not $g_bRunState Then Return

		TriggerMachineAbility()

		Local $iDamage = Number(getOcrOverAllDamage(780, 587 + $g_iBottomOffsetYFixed))  ; Resolution changed
		If Int($iDamage) > Int($g_iLastDamage) Then
			$g_iLastDamage = Int($iDamage)
			Setlog("- Total Damage: " & $g_iLastDamage & "%", $COLOR_INFO)
		EndIf

		If _CheckPixel($g_aBBBlackArts, True) Then
			If _WaitForCheckImg($g_sImgOkButton, "345, 452, 524, 615") Then $bIsEnded = True ; Resolution changed
			SetDebugLog("BattleIsOver | $bIsEnded : " & $bIsEnded)
			ExitLoop
		EndIf
	Next

	If ($iBattleOverLoopCounter > 180) Then Setlog("Window Report Problem!", $COLOR_WARNING)
EndFunc   ;==>BattleIsOver