; #FUNCTION# ====================================================================================================================
; Name ..........: CheckTombs.au3
; Description ...: This file Includes function to perform defense farming.
; Syntax ........:
; Parameters ....: None
; Return values .: False if regular farming is needed to refill storage
; Author ........: barracoda/KnowJack (2015)
; Modified ......: sardo (05-2015/06-2015) , ProMac (04-2016), MonkeyHuner (06-2015)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2021
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func CheckTombs()
	If Not TestCapture() Then
		If Not $g_bChkTombstones Then Return False
		If Not $g_abNotNeedAllTime[1] Then Return
	EndIf
	; Timer
	Local $hTimer = __TimerInit()

	; Setup arrays, including default return values for $return
	Local $return[7] = ["None", "None", 0, 0, 0, "", ""]
	Local $TombsXY[2] = [0, 0]

	; Perform a parallel search with all images inside the directory
	Local $aResult = returnSingleMatchOwnVillage($g_sImgClearTombs)

	If UBound($aResult) > 1 Then
		; Now loop through the array to modify values, select the highest entry to return
		For $i = 1 To UBound($aResult) - 1
			; Check to see if its a higher level then currently stored
			If Number($aResult[$i][2]) > Number($return[2]) Then
				; Store the data because its higher
				$return[0] = $aResult[$i][0] ; Filename
				$return[1] = $aResult[$i][1] ; Type
				$return[4] = $aResult[$i][4] ; Total Objects
				$return[5] = $aResult[$i][5] ; Coords
			EndIf
		Next
		$TombsXY = $return[5]

		SetDebugLog("Filename :" & $return[0])
		SetDebugLog("Type :" & $return[1])
		SetDebugLog("Total Objects :" & $return[4])

		Local $bRemoved = False
		If IsArray($TombsXY) Then
			; Loop through all found points for the item and click them to clear them, there should only be one
			For $j = 0 To UBound($TombsXY) - 1
				If isInsideDiamondXY($TombsXY[$j][0], $TombsXY[$j][1]) Then
					SetDebugLog("Coords :" & $TombsXY[$j][0] & "," & $TombsXY[$j][1])
					If IsMainPage() Then
						Click($TombsXY[$j][0], $TombsXY[$j][1], 1, 0, "#0430")
						If Not $bRemoved Then $bRemoved = IsMainPage()
					EndIf
				EndIf
			Next
		EndIf
		If $bRemoved Then
			SetLog("Tombs removed!", $COLOR_DEBUG1)
			$g_abNotNeedAllTime[1] = False
		Else
			SetLog("Tombs not removed, please do manually!", $COLOR_WARNING)
		EndIf
	Else
		SetLog("No Tombs Found!", $COLOR_SUCCESS)
		$g_abNotNeedAllTime[1] = False
	EndIf

	checkMainScreen(False) ; check for screen errors while function was running
EndFunc   ;==>CheckTombs

Func CleanYard()

	; Early exist if noting to do
	If Not $g_bChkCleanYard And Not $g_bChkGemsBox And Not TestCapture() Then Return

	; Timer
	Local $hObstaclesTimer = __TimerInit()

	; Get Builders available
	If Not getBuilderCount() Then Return ; update builder data, return if problem
	If _Sleep($DELAYRESPOND) Then Return

	; Obstacles function to Parallel Search , will run all pictures inside the directory

	; Setup arrays, including default return values for $return
	Local $Filename = ""
	Local $Locate = 0
	Local $CleanYardXY
	Local $sCocDiamond = ($g_bEdgeObstacle = False) ? ($CocDiamondDCD) : ($CocDiamondECD) ;$CocDiamondECD ; Custom Yard - Team AIO Mod++
	Local $redLines = $sCocDiamond
	Local $bNoBuilders = $g_iFreeBuilderCount < 1

	If $g_iFreeBuilderCount > 0 And $g_bChkCleanYard And Number($g_aiCurrentLoot[$eLootElixir]) > 50000 Then
		Local $aResult = findMultiple($g_iDetectedImageType = 1 ? $g_sImgCleanYardSnow  : $g_sImgCleanYard, $sCocDiamond, $redLines, 0, 1000, 10, "objectname,objectlevel,objectpoints", True)
		If IsArray($aResult) Then
			For $matchedValues In $aResult
				Local $aPoints = decodeMultipleCoords($matchedValues[2])
				$Filename = $matchedValues[0] ; Filename
				For $i = 0 To UBound($aPoints) - 1
					$CleanYardXY = $aPoints[$i] ; Coords
					If UBound($CleanYardXY) > 1 And isInsideDiamondXY($CleanYardXY[0], $CleanYardXY[1]) Then ; secure x because of clan chat tab
						SetDebugLog($Filename & " found (" & $CleanYardXY[0] & "," & $CleanYardXY[1] & ")", $COLOR_SUCCESS)
						If IsMainPage() Then Click($CleanYardXY[0], $CleanYardXY[1], 1, 0, "#0430")
						$Locate = 1
						If _Sleep($DELAYCOLLECT3) Then Return
						If Not ClickRemoveObstacle() Then ContinueLoop
						If _Sleep($DELAYCHECKTOMBS2) Then Return
						ClickAway() ; ClickP($aAway, 2, 300, "#0329") ;Click Away
						If _Sleep($DELAYCHECKTOMBS1) Then Return
						If Not getBuilderCount() Then Return ; update builder data, return if problem
						If _Sleep($DELAYRESPOND) Then Return
						If $g_iFreeBuilderCount = 0 Then
							SetLog("No More Builders available")
							If _Sleep(2000) Then Return
							ExitLoop (2)
						EndIf
					EndIf
				Next
			Next
		EndIf
	EndIf

	; Setup arrays, including default return values for $return
	Local $return[7] = ["None", "None", 0, 0, 0, "", ""]
	Local $GemBoxXY[2] = [0, 0]

	; Perform a parallel search with all images inside the directory
	If ($g_iFreeBuilderCount > 0 And $g_bChkGemsBox And Number($g_aiCurrentLoot[$eLootElixir]) > 50000) Or TestCapture() Then
		Local $aResult = multiMatches($g_sImgGemBox, 1, $sCocDiamond, $sCocDiamond)
		If UBound($aResult) > 1 Then
			; Now loop through the array to modify values, select the highest entry to return
			For $i = 1 To UBound($aResult) - 1
				; Check to see if its a higher level then currently stored
				If Number($aResult[$i][2]) > Number($return[2]) Then
					; Store the data because its higher
					$return[0] = $aResult[$i][0] ; Filename
					$return[1] = $aResult[$i][1] ; Type
					$return[4] = $aResult[$i][4] ; Total Objects
					$return[5] = $aResult[$i][5] ; Coords
				EndIf
			Next
			$GemBoxXY = $return[5]

			SetDebugLog("Filename :" & $return[0])
			SetDebugLog("Type :" & $return[1])
			SetDebugLog("Total Objects :" & $return[4])

			If IsArray($GemBoxXY) Then
				; Loop through all found points for the item and click them to remove it, there should only be one
				For $j = 0 To UBound($GemBoxXY) - 1
					SetDebugLog("Coords :" & $GemBoxXY[$j][0] & "," & $GemBoxXY[$j][1])
					If isInsideDiamondXY($GemBoxXY[$j][0], $GemBoxXY[$j][1]) Then
						If IsMainPage() Then Click($GemBoxXY[$j][0], $GemBoxXY[$j][1], 1, 0, "#0430")
						If _Sleep($DELAYCHECKTOMBS2) Then Return
						$Locate = 1
						If _Sleep($DELAYCOLLECT3) Then Return
						If Not ClickRemoveObstacle() Then ContinueLoop
						If _Sleep($DELAYCHECKTOMBS2) Then Return
						ClickAway() ; ClickP($aAway, 2, 300, "#0329") ;Click Away
						If _Sleep($DELAYCHECKTOMBS1) Then Return
						If Not getBuilderCount() Then Return ; update builder data, return if problem
						If _Sleep($DELAYRESPOND) Then Return
						If $g_iFreeBuilderCount = 0 Then
							SetLog("No More Builders available")
							If _Sleep(2000) Then Return
							ExitLoop
						EndIf
					EndIf
				Next
			EndIf
			SetLog("GemBox removed!", $COLOR_DEBUG1)
		Else
			SetLog("No GemBox Found!", $COLOR_SUCCESS)
		EndIf
	EndIf

	If $bNoBuilders Then
		SetLog("No Builders available to remove Obstacles!")
	Else
		If $Locate = 0 And $g_bChkCleanYard And Number($g_aiCurrentLoot[$eLootElixir]) > 50000 Then SetLog("No Obstacles found, Yard is clean!", $COLOR_SUCCESS)
		SetDebugLog("Time: " & Round(__TimerDiff($hObstaclesTimer) / 1000, 2) & "'s", $COLOR_SUCCESS)
	EndIf
	UpdateStats()
	ClickAway()

EndFunc   ;==>CleanYard

Func ClickRemoveObstacle()
	Local $aiButton = findButton("RemoveObstacle", Default, 1, True)
	If IsArray($aiButton) And UBound($aiButton) >= 2 Then
		SetDebugLog("Remove Button found! Clicking it at X: " & $aiButton[0] & ", Y: " & $aiButton[1], $COLOR_DEBUG1)
		ClickP($aiButton)
		Return True
	Else
		SetLog("Cannot find Remove Button", $COLOR_ERROR)
		Return False
	EndIf
EndFunc   ;==>ClickRemoveObstacle
