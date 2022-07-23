; #FUNCTION# ====================================================================================================================
; Name ..........: CheckTombs.au3
; Description ...: This file Includes function to perform defense farming.
; Syntax ........:
; Parameters ....: None
; Return values .: False if regular farming is needed to refill storage
; Author ........: barracoda/KnowJack (2015)
; Modified ......: sardo (05-2015/06-2015) , ProMac (04-2016), MonkeyHuner (06-2015), Team AIO Mod++
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2021
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#Region - Custom Yard - Team AIO Mod++
Func CleanBBYard()
	If Not $g_bRunState Then Return

	; Early exist if noting to do
	If Not $g_bChkCleanBBYard And Not TestCapture() Then Return

	; FuncEnter(CleanBBYard)

	Local $bBuilderBase = isOnBuilderBase(True)
	If $bBuilderBase Then
		SetLog("Going to check Builder Base Yard For Obstacles!", $COLOR_INFO)
		Local $hObstaclesTimer = __TimerInit()
		
		ZoomOut()
		If Not @error Then
			; Get Builders available
			If Not getBuilderCount(False, $bBuilderBase) Then Return
			BuilderBaseReport()
			If _Sleep($DELAYRESPOND) Then Return
			Local $hStarttime = _Timer_Init()
			Local $iObstacleRemoved = 0
			Local $bNoBuilders = $g_iFreeBuilderCountBB < 1
			If $g_iFreeBuilderCountBB > 0 And $g_bChkCleanBBYard = True And Number($g_aiCurrentLootBB[$eLootElixirBB]) > 50000 Then
				Local $aCleanYardBBNXY = findMultipleQuick($g_sImgCleanBBYard)
				If UBound($aCleanYardBBNXY) > 0 And not @error Then
					SetDebugLog("Benchmark Image Detection Of Builder Base Clean Yard: " & Round(_Timer_Diff($hStarttime), 2) & "'ms")
					_ArrayShuffle($aCleanYardBBNXY)
					SetDebugLog("Total Obstacles Found: " & UBound($aCleanYardBBNXY))
					For $i = 0 To UBound($aCleanYardBBNXY) - 1
						If isInsideDiamondXY($aCleanYardBBNXY[$i][1], $aCleanYardBBNXY[$i][2], False) = False Then ContinueLoop ; Check if X,Y is inside Builderbase or outside
						$iObstacleRemoved += 1
						SetLog("Going to remove Builder Base Obstacle: " & $iObstacleRemoved, $COLOR_SUCCESS)
						SetDebugLog($aCleanYardBBNXY[$i][0] & " found at (" & $aCleanYardBBNXY[$i][1] & "," & $aCleanYardBBNXY[$i][2] & ")", $COLOR_SUCCESS)
						If IsMainPageBuilderBase() Then Click($aCleanYardBBNXY[$i][1], $aCleanYardBBNXY[$i][2], 1, 0, "#0430")
						If _Sleep($DELAYCOLLECT3) Then Return
						If Not ClickRemoveObstacle() Then
							ClickAway()
							ContinueLoop
						EndIf
						If _Sleep($DELAYCHECKTOMBS2) Then Return
						ClickAway()
						If _Sleep($DELAYCHECKTOMBS1) Then Return

						; Aca
						If $g_bChkCleanYardBBall Then
							Local $iloops = 0
							Do
								If Not $g_bRunState Then ExitLoop
								If getBuilderCount(False, $bBuilderBase) = False Then Return
								If _Sleep($DELAYCHECKTOMBS3) Then Return
								$iloops += 1
								If $iloops = 30 Then ExitLoop
							Until Not ($g_iFreeBuilderCountBB = 0 And Number($g_aiCurrentLootBB[$eLootElixirBB]) > 50000)
						Else
							If getBuilderCount(False, $bBuilderBase) = False Then Return
						EndIf

						If _Sleep($DELAYRESPOND) Then Return
						If $g_iFreeBuilderCountBB = 0 Then
							SetLog("No More Builders available in Builder Base to remove Obstacles!")
							ExitLoop
						EndIf

						BuilderBaseReport()

						If _Sleep($DELAYRESPOND) Then Return
						If Number($g_aiCurrentLootBB[$eLootElixirBB]) < 50000 Then
							SetLog("Remove Obstacles stopped due to insufficient Elixir.", $COLOR_INFO)
							ExitLoop
						EndIf
					Next
				EndIf
			ElseIf $g_iFreeBuilderCountBB > 0 And $g_bChkCleanBBYard = True And Number($g_aiCurrentLootBB[$eLootElixirBB]) < 50000 Then
				SetLog("Sorry, Low Builder Base Elixir (" & $g_aiCurrentLootBB[$eLootElixirBB] & ") Skip remove Obstacles check!", $COLOR_INFO)
			EndIf

			If $bNoBuilders Then
				SetLog("Builder not available to remove Builder Base Obstacles!")
			Else
				If $iObstacleRemoved = 0 And $g_bChkCleanBBYard And Number($g_aiCurrentLootBB[$eLootElixirBB]) > 50000 Then SetLog("No Obstacles found, Builder Base Yard is clean!", $COLOR_SUCCESS)
				SetDebugLog("Took Time: " & Round(__TimerDiff($hObstaclesTimer) / 1000, 2) & "'s", $COLOR_SUCCESS)
			EndIf
		EndIf
		ClickAway()

	EndIf

	; FuncReturn()
EndFunc   ;==>CleanBBYard
#EndRegion - Custom Yard - Team AIO Mod++