; #FUNCTION# ====================================================================================================================
; Name ..........: WeakBase()
; Description ...: Checks to see if the base can be classified a weak base
; Syntax ........:
; Parameters ....: None
; Return values .:
; Author ........: LunaEclipse(April 2016)
; Modified ......: MonkeyHunter (04-2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func createWeakBaseStats()
	; Get the directory file contents as keys for the stats file
	Local $aKeys = _FileListToArrayRec($g_sImgWeakBaseBuildingsDir, "*.xml", $FLTAR_FILES, $FLTAR_RECUR, $FLTAR_SORT, $FLTAR_NOPATH)
	; Create our return array
	Local $return[UBound($aKeys) - 1][2]

	; If the stats file doesn't exist, create it
	If Not FileExists($g_sProfileBuildingStatsPath) Then _FileCreate($g_sProfileBuildingStatsPath)

	; Loop through the keys
	For $i = 1 To UBound($aKeys) - 1
		; Set the return array values
		$return[$i - 1][0] = $aKeys[$i] ; Filename
		$return[$i - 1][1] = 0 ; Number

		; Write the entry to the stats file
		IniWrite($g_sProfileBuildingStatsPath, "WeakBase", $aKeys[$i], "0")
	Next

	Return $return
EndFunc   ;==>createWeakBaseStats

Func readWeakBaseStats()
	; Get the directory file contents as keys for the stats file
	Local $aKeys = _FileListToArrayRec($g_sImgWeakBaseBuildingsDir, "*.xml", $FLTAR_FILES, $FLTAR_RECUR, $FLTAR_SORT, $FLTAR_NOPATH)
	; Create our return array
	Local $return[UBound($aKeys) - 1][2]

	; Check to see if the stats file exists
	If FileExists($g_sProfileBuildingStatsPath) Then
		; Loop through the keys
		For $i = 1 To UBound($aKeys) - 1
			; Set the return array values
			$return[$i - 1][0] = $aKeys[$i] ; Filename
			$return[$i - 1][1] = IniRead($g_sProfileBuildingStatsPath, "WeakBase", $aKeys[$i], "0") ; Current value
		Next
	Else
		; File doesn't exist so create it and return the values from creation
		$return = createWeakBaseStats()
	EndIf

	Return $return
EndFunc   ;==>readWeakBaseStats

Func updateWeakBaseStats(ByRef $aResult)
	If IsArray($aResult) Then
		; Loop through the found tiles
		For $i = 1 To UBound($aResult) - 1
			; Loop through the current stats
			For $j = 0 To UBound($g_aiWeakBaseStats) - 1
				; Check to see if the current stat is for the found tile
				If $g_aiWeakBaseStats[$j][0] = $aResult[$i][0] Then
					; Update the counter
					$g_aiWeakBaseStats[$j][1] = Number($g_aiWeakBaseStats[$j][1]) + 1
				EndIf
			Next
		Next
	EndIf
EndFunc   ;==>updateWeakBaseStats

Func displayWeakBaseLog($aResult, $showLog = False)
	; Display the various statistical displays
	If $showLog And IsArray($aResult) Then
		SetLog("================ Weak Base Detection Start ================", $COLOR_INFO)
		SetLog("Highest Eagle Artillery: " & $aResult[1][0] & " - Level: " & $aResult[1][2], $COLOR_INFO)
		SetLog("Highest Inferno Tower: " & $aResult[2][0] & " - Level: " & $aResult[2][2], $COLOR_INFO)
		SetLog("Highest X-Bow: " & $aResult[3][0] & " - Level: " & $aResult[3][2], $COLOR_INFO)
		SetLog("Highest Wizard Tower: " & $aResult[4][0] & " - Level: " & $aResult[4][2], $COLOR_INFO)
		SetLog("Highest Mortar: " & $aResult[5][0] & " - Level: " & $aResult[5][2], $COLOR_INFO)
		SetLog("Highest Air Defense: " & $aResult[6][0] & " - Level: " & $aResult[6][2], $COLOR_INFO)
		SetLog("Highest Scatter Shot: " & $aResult[7][0] & " - Level: " & $aResult[7][2], $COLOR_INFO)
		SetLog("Time taken: " & $aResult[0][2] & " " & $aResult[0][3], $COLOR_INFO)
		SetLog("================ Weak Base Detection Stop =================", $COLOR_INFO)
	EndIf
EndFunc   ;==>displayWeakBaseLog

Func getTHDefenseMax($levelTownHall, $iDefenseType)

	; replace orginal weak base code with dictionary function used by any attack method
	If $levelTownHall = 0 Or $levelTownHall = "-" Then $levelTownHall = 13 ; ; If something went wrong with TH search and returned 0, set to max TH level

	Local $maxLevel = _ObjGetValue($g_oBldgLevels, $iDefenseType + 7)[$levelTownHall - 1] ; add 6 to weakbase enum to equal building enum
	If @error Then
		_ObjErrMsg("_ObjGetValue $g_oBldgLevels", @error) ; Log COM error prevented
		$maxLevel = 100 ; unknown number of building levels, then set equal to 100
	EndIf

	Return $maxLevel

EndFunc   ;==>getTHDefenseMax

Func getMaxUISetting($settingArray, $iDefenseType)
	; Setup the default return value
	Local $result = 0, $maxDB = 0, $maxLB = 0

	If IsArray($settingArray) Then
		; Check if dead base search is active and dead base weak base detection is active, use setting if active, 0 if not active
		$maxDB = (IsWeakBaseActive($DB)) ? $settingArray[$DB] : 0
		; Check if live base search is active and live base weak base detection is active, use setting if active, 0 if not active
		$maxLB = (IsWeakBaseActive($LB)) ? $settingArray[$LB] : 0

		; Get the value that is highest
		$result = _Max(Number($maxDB), Number($maxLB))
	EndIf

	SetDebugLog("Max " & $g_aWeakDefenseNames[$iDefenseType] & " Level: " & $result, $COLOR_INFO)
	Return $result
EndFunc   ;==>getMaxUISetting

Func getMinUISetting($settingArray, $iDefenseType)
	; Setup the default return value
	Local $result = 0, $minDB = 0, $minLB = 0

	If IsArray($settingArray) Then
		; Check if dead base search is active and dead base weak base detection is active, use setting if active, 0 if not active
		$minDB = (IsWeakBaseActive($DB)) ? $settingArray[$DB] : 0
		; Check if live base search is active and live base weak base detection is active, use setting if active, 0 if not active
		$minLB = (IsWeakBaseActive($LB)) ? $settingArray[$LB] : 0

		; Get the value that is lowest of maximum defense level to detect
		$result = _Min(Number($minDB), Number($minLB))
	EndIf

	SetDebugLog("Min " & $g_aWeakDefenseNames[$iDefenseType] & " Level: " & $result, $COLOR_INFO)
	Return $result
EndFunc   ;==>getMinUISetting

Func getIsWeak($aResults, $searchType)
	Return $aResults[$eWeakEagle][2] <= Number($g_aiFilterMaxEagleLevel[$searchType]) _
			And $aResults[$eWeakInferno][2] <= Number($g_aiFilterMaxInfernoLevel[$searchType]) _
			And $aResults[$eWeakXBow][2] <= Number($g_aiFilterMaxXBowLevel[$searchType]) _
			And $aResults[$eWeakWizard][2] <= Number($g_aiFilterMaxWizTowerLevel[$searchType]) _
			And $aResults[$eWeakMortar][2] <= Number($g_aiFilterMaxMortarLevel[$searchType]) _
			And $aResults[$eWeakAirDefense][2] <= Number($g_aiFilterMaxAirDefenseLevel[$searchType]) _
			And $aResults[$eWeakScatter][2] <= Number($g_aiFilterMaxScatterLevel[$searchType])

	Local $text = "DB"
	If $searchType = 1 Then $text = "LB"
	SetLog("================ Weak Base Detection Start ================")
	If $g_abFilterMaxEagleEnable[$searchType] Then SetLog("[" & $text & "] Eagle level " & $g_aiFilterMaxEagleLevel[$searchType] & " as max, detection higher level : " & $aResults[$eWeakEagle][2], $COLOR_DEBUG)
	If $g_abFilterMaxInfernoEnable[$searchType] Then SetLog("[" & $text & "] Inferno level " & $g_aiFilterMaxInfernoLevel[$searchType] & " as max, detection higher level: " & $aResults[$eWeakInferno][2], $COLOR_DEBUG)
	If $g_abFilterMaxXBowEnable[$searchType] Then SetLog("[" & $text & "] XBow level " & $g_aiFilterMaxXBowLevel[$searchType] & " as max, detection higher level: " & $aResults[$eWeakXBow][2], $COLOR_DEBUG)
	If $g_abFilterMaxWizTowerEnable[$searchType] Then SetLog("[" & $text & "] WTower level " & $g_aiFilterMaxWizTowerLevel[$searchType] & " as max, detection higher level: " & $aResults[$eWeakWizard][2], $COLOR_DEBUG)
	If $g_abFilterMaxMortarEnable[$searchType] Then SetLog("[ " & $text & "] Mortar level " & $g_aiFilterMaxMortarLevel[$searchType] & " as max, detection higher level: " & $aResults[$eWeakMortar][2], $COLOR_DEBUG)
	If $g_abFilterMaxAirDefenseEnable[$searchType] Then SetLog("[" & $text & "] AirDef level " & $g_aiFilterMaxAirDefenseLevel[$searchType] & " as max, detection higher level: " & $aResults[$eWeakAirDefense][2], $COLOR_DEBUG)
	If $g_abFilterMaxScatterEnable[$searchType] Then SetLog("[" & $text & "] Scatter level " & $g_aiFilterMaxScatterLevel[$searchType] & " as max, detection higher level: " & $aResults[$eWeakScatter][2], $COLOR_DEBUG)
	SetLog("Is a Weak Base? " & $aResults)
	SetLog("================ Weak Base Detection Stop =================")
	Return $aResults

EndFunc   ;==>getIsWeak

Func IsWeakBaseActive($type)
	Return ($g_abFilterMaxEagleEnable[$type] Or $g_abFilterMaxInfernoEnable[$type] Or $g_abFilterMaxXBowEnable[$type] Or $g_abFilterMaxWizTowerEnable[$type] Or _
			$g_abFilterMaxMortarEnable[$type] Or $g_abFilterMaxAirDefenseEnable[$type] or $g_abFilterMaxScatterEnable[$type]) And IsSearchModeActiveMini($type)
EndFunc   ;==>IsWeakBaseActive

Func defenseSearch(ByRef $aResult, $directory, $townHallLevel, $settingArray, $iDefenseType, ByRef $performSearch, $guiEnabledArray, $bForceCaptureRegion = True)

	; Setup default return coords of 0,0
	Local $defaultCoords[1][2] = [[0, 0]]

	; Setup Empty Results in case to avoid errors, levels are set to max level of each type
	Local $aDefenseResult[7] = ["Skipped", "Skipped", $g_oBldgLevels.Item($iDefenseType + 7), 0, 0, $defaultCoords, ""]
	; Results when search is not necessary because of levels
	Local $aNotNecessary[7] = ["None", "None", 0, 0, 0, $defaultCoords, ""]

	; Only do the search if its required
	If $performSearch Then
		; Setup search limitations
		Local $minSearchLevel = getMinUISetting($settingArray, $iDefenseType) + 1 ; stores lowest defense bldg level specified in all active attack modes for max buiding level in GUI
		Local $maxSearchLevel = getTHDefenseMax($townHallLevel, $iDefenseType) ; store the maximum defense building level possible based on TH level being attacked
		Local $bGuiEnableArray = IsArray($guiEnabledArray), $bIsSearchModeActiveDB = IsSearchModeActiveMini($DB), $bIsSearchModeActiveLB = IsSearchModeActiveMini($LB)
		Local $guiCheckDefense = $bGuiEnableArray And (($bIsSearchModeActiveDB And $guiEnabledArray[$DB]) Or ($bIsSearchModeActiveLB And $guiEnabledArray[$LB]))

		; Start the timer for individual defense searches
		Local $defenseTimer = __TimerInit()

		If $guiCheckDefense And $maxSearchLevel >= $minSearchLevel Then
			; Check the defense.
			Local $sDefenseName = StringSplit($directory, "\", $STR_NOCOUNT)
			SetDebugLog("checkDefense :" & $sDefenseName[UBound($sDefenseName) - 1] & " > " & $minSearchLevel & " < " & $maxSearchLevel & " For TH:" & $townHallLevel, $COLOR_ACTION)
			$aDefenseResult = DefenseSearchMultiMatch($iDefenseType, $directory, $aResult[0][0], $g_sProfileBuildingStatsPath, $minSearchLevel, $maxSearchLevel, $bForceCaptureRegion)
			; Store the redlines retrieved for use in the later searches, if you don't currently have redlines saved.
			If $aResult[0][0] = "" Then $aResult[0][0] = $aDefenseResult[6]
			; Check to see if further searches are required, $performSearch is passed ByRef, so this will update the value in the calling function
			If Number($aDefenseResult[2]) > getMaxUISetting($settingArray, $iDefenseType) Then $performSearch = False
			If $g_bDebugSetlog Then
				SetDebugLog("checkDefense: " & $g_aWeakDefenseNames[$iDefenseType] & " - " & Round(__TimerDiff($defenseTimer) / 1000, 2) & " seconds")
				For $i = 0 To UBound($aDefenseResult) - 2
					SetDebugLog("$aDefenseResult[" & $i & "]: " & $aDefenseResult[$i])
				Next
			EndIf
		Else
			$aDefenseResult = $aNotNecessary
			SetDebugLog("checkDefense: " & $g_aWeakDefenseNames[$iDefenseType] & " not necessary! $bGuiEnableArray=" & $bGuiEnableArray & ", $bIsSearchModeActiveDB=" & $bIsSearchModeActiveDB & ", $bIsSearchModeActiveLB=" & $bIsSearchModeActiveLB & ", $maxSearchLevel=" & $maxSearchLevel & ", $minSearchLevel=" & $minSearchLevel)
		EndIf
	EndIf



	Return $aDefenseResult
EndFunc   ;==>defenseSearch

Func weakBaseCheck($townHallLevel = 11, $redlines = "", $bForceCaptureRegion = True)
	; Setup default return coords of 0,0
	Local $defaultCoords[1][2] = [[0, 0]]
	; Setup Empty Results in case to avoid errors, levels are set to max level of each type
	Local $aResult[8][6] = [[$redlines, 0, 0, "Seconds", "", ""], _
			["Skipped", "Skipped", $g_oBldgLevels.Item($eWeakEagle + 6), 0, 0, $defaultCoords], _ ; Eagle
			["Skipped", "Skipped", $g_oBldgLevels.Item($eWeakInferno + 6), 0, 0, $defaultCoords], _ ; Inferno
			["Skipped", "Skipped", $g_oBldgLevels.Item($eWeakXBow + 6), 0, 0, $defaultCoords], _ ; X-Bow
			["Skipped", "Skipped", $g_oBldgLevels.Item($eWeakWizard + 6), 0, 0, $defaultCoords], _ ; Wizard
			["Skipped", "Skipped", $g_oBldgLevels.Item($eWeakMortar + 6), 0, 0, $defaultCoords], _ ; Mortar
			["Skipped", "Skipped", $g_oBldgLevels.Item($eWeakAirDefense + 6), 0, 0, $defaultCoords], _ ; Air Defense
			["Skipped", "Skipped", $g_oBldgLevels.Item($eWeakScatter + 6), 0, 0, $defaultCoords]] ; Scatter Shot
	; [redline data array, num points found, weakbase search time, search time unit, ??, ??] = 1st Row values
	; [image filename found, bldg type, bldg max level, bldg Fill level, number bldg found, location data array] = 2nd+ building row values

	Local $aEagleResults, $aScatterResults, $aInfernoResults, $aMortarResults, $aWizardTowerResults, $aXBowResults, $aAirDefenseResults
	Local $performSearch = True
	; Start the timer for overall weak base search
	Local $hWeakTimer = __TimerInit()

	; Check Eagle Artillery first as there is less images to process, mortars may not be needed.
	$aEagleResults = defenseSearch($aResult, $g_sImgWeakBaseBuildingsEagleDir, $townHallLevel, $g_aiFilterMaxEagleLevel, $eWeakEagle, $performSearch, $g_abFilterMaxEagleEnable, $bForceCaptureRegion)
	$aScatterResults = defenseSearch($aResult, $g_sImgWeakBaseBuildingsScatterDir, $townHallLevel, $g_aiFilterMaxScatterLevel, $eWeakScatter, $performSearch, $g_abFilterMaxScatterEnable, $bForceCaptureRegion)
	$aInfernoResults = defenseSearch($aResult, $g_sImgWeakBaseBuildingsInfernoDir, $townHallLevel, $g_aiFilterMaxInfernoLevel, $eWeakInferno, $performSearch, $g_abFilterMaxInfernoEnable, $bForceCaptureRegion)
	$aXBowResults = defenseSearch($aResult, $g_sImgWeakBaseBuildingsXbowDir, $townHallLevel, $g_aiFilterMaxXBowLevel, $eWeakXBow, $performSearch, $g_abFilterMaxXBowEnable, $bForceCaptureRegion)
	If $g_iDetectedImageType = 1 Then
		$aWizardTowerResults = defenseSearch($aResult, $g_sImgWeakBaseBuildingsWizTowerSnowDir, $townHallLevel, $g_aiFilterMaxWizTowerLevel, $eWeakWizard, $performSearch, $g_abFilterMaxWizTowerEnable, $bForceCaptureRegion)
	Else
		$aWizardTowerResults = defenseSearch($aResult, $g_sImgWeakBaseBuildingsWizTowerDir, $townHallLevel, $g_aiFilterMaxWizTowerLevel, $eWeakWizard, $performSearch, $g_abFilterMaxWizTowerEnable, $bForceCaptureRegion)
	EndIf
	$aMortarResults = defenseSearch($aResult, $g_sImgWeakBaseBuildingsMortarsDir, $townHallLevel, $g_aiFilterMaxMortarLevel, $eWeakMortar, $performSearch, $g_abFilterMaxMortarEnable, $bForceCaptureRegion)
	$aAirDefenseResults = defenseSearch($aResult, $g_sImgWeakBaseBuildingsAirDefenseDir, $townHallLevel, $g_aiFilterMaxAirDefenseLevel, $eWeakAirDefense, $performSearch, $g_abFilterMaxAirDefenseEnable, $bForceCaptureRegion)

	; Fill the array that will be returned with the various results, only store the results if its a valid array
	For $i = 1 To UBound($aResult) - 1
		For $j = 0 To UBound($aResult, 2) - 1
			Switch $i
				Case $eWeakEagle
					If IsArray($aEagleResults) Then $aResult[$i][$j] = $aEagleResults[$j]
				Case $eWeakInferno
					If IsArray($aInfernoResults) Then $aResult[$i][$j] = $aInfernoResults[$j]
				Case $eWeakXBow
					If IsArray($aXBowResults) Then $aResult[$i][$j] = $aXBowResults[$j]
				Case $eWeakWizard
					If IsArray($aWizardTowerResults) Then $aResult[$i][$j] = $aWizardTowerResults[$j]
				Case $eWeakMortar
					If IsArray($aMortarResults) Then $aResult[$i][$j] = $aMortarResults[$j]
				Case $eWeakAirDefense
					If IsArray($aAirDefenseResults) Then $aResult[$i][$j] = $aAirDefenseResults[$j]
				Case $eWeakScatter
					If IsArray($aScatterResults) Then $aResult[$i][$j] = $aScatterResults[$j]
				Case Else
					; This should never happen unless there is a problem with the code.
			EndSwitch
		Next
	Next

	; Extra return results
	$aResult[0][2] = Round(__TimerDiff($hWeakTimer) / 1000, 2) ; Time taken
	$aResult[0][3] = "Seconds" ; Measurement unit

	Return $aResult
EndFunc   ;==>weakBaseCheck

Func IsWeakBase($townHallLevel = $g_iMaxTHLevel, $redlines = "", $bForceCaptureRegion = True)
	Local $aResult = weakBaseCheck($townHallLevel, $redlines, $bForceCaptureRegion)

	; Forces the display of the various statistical displays, if set to true
	; displayWeakBaseLog($aResult, true)
	; Displays the various statistical displays, if debug logging is enabled
	displayWeakBaseLog($aResult, $g_bDebugSetlog)

	If $g_bDebugSetlog Then
		_LogObjList($g_oBldgAttackInfo) ; raw debug only!
		Local $text = _ArrayToString($aResult, ",", 0, UBound($aResult, 1) - 1, "|", 0, UBound($aResult, 2) - 1)
		If @error Then SetDebugLog("Error _ArrayToString, code:" & @error, $COLOR_ERROR)
		SetDebugLog("$aResult Array: " & $text, $COLOR_DEBUG)
	EndIf

	; Take Debug Pictures
	If Number($aResult[0][2]) > 10 Then
		; Search took longer than 10 seconds so take a debug picture no matter what the debug option is
		captureDebugImage($aResult, "WeakBase_Detection_TooSlow")
	ElseIf $g_bDebugImageSave And Number($aResult[1][4]) = 0 Then
		; Eagle Artillery not detected, so lets log the picture for manual inspection
		captureDebugImage($aResult, "WeakBase_Detection_Eagle_NotDetected")
	ElseIf $g_bDebugImageSave And Number($aResult[2][4]) = 0 Then
		; Inferno Towers not detected, so lets log the picture for manual inspection
		captureDebugImage($aResult, "WeakBase_Detection_Inferno_NotDetected")
	ElseIf $g_bDebugImageSave And Number($aResult[3][4]) = 0 Then
		; X-bows not detected, so lets log the picture for manual inspection
		captureDebugImage($aResult, "WeakBase_Detection_Xbow_NotDetected")
	ElseIf $g_bDebugImageSave And Number($aResult[4][4]) = 0 Then
		; Wizard Towers not detected, so lets log the picture for manual inspection
		captureDebugImage($aResult, "WeakBase_Detection_WTower_NotDetected")
	ElseIf $g_bDebugImageSave And Number($aResult[5][4]) = 0 Then
		; Mortars not detected, so lets log the picture for manual inspection
		captureDebugImage($aResult, "WeakBase_Detection_Mortar_NotDetected")
	ElseIf $g_bDebugImageSave And Number($aResult[6][4]) = 0 Then
		; Air Defenses not detected, so lets log the picture for manual inspection
		captureDebugImage($aResult, "WeakBase_Detection_ADefense_NotDetected")
	ElseIf $g_bDebugImageSave And Number($aResult[7][4]) = 0 Then
		; Scatter shot not detected, so lets log the picture for manual inspection
		captureDebugImage($aResult, "WeakBase_Detection_Scatter_NotDetected")
	ElseIf $g_bDebugImageSave Then
		; Debug option is set, so take a debug picture
		captureDebugImage($aResult, "WeakBase_Detection")
	EndIf

	Return $aResult
EndFunc   ;==>IsWeakBase


; #FUNCTION# ====================================================================================================================
; Name ..........: DefenseSearchMultiMatch
; Description ...: Embellished clone of returnHighestLevelSingleMatch() except also copies ALL defense building matches to dictionary for later use by CSV to avoid repeating searches
; Syntax ........: DefenseSearchMultiMatch($iDefenseType, $directory[, $redlines = $CocDiamondDCD[, $statFile = ""[, $minLevel = 0[,
;                  $maxLevel = 100[, $bForceCaptureRegion = True]]]]])
; Parameters ....: $iDefenseType         - integer value, Weak base enum for defense type being searched.
;                  $directory           - string value, folder location where defense images to search for are found
;                  $redlines            - [optional] string value. Default is $CocDiamondDCD.
;                  $statFile            - [optional] string value. Default is "". Path name to location of stats data
;                  $minLevel            - [optional] integer value. Default is 0. min level of building to search
;                  $maxLevel            - [optional] integer value. Default is 100. Max level of building to search
;                  $bForceCaptureRegion  - [optional] Boolean value. Default is True. Flag to control if new image capture is needed for each search.
; Return values .: 1D array with highest level matched data found
; Author ........: MonkeyHunter (04-2017)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func DefenseSearchMultiMatch($iDefenseType, $directory, $redlines = $CocDiamondDCD, $statFile = "", $minLevel = 0, $maxLevel = 100, $bForceCaptureRegion = True)

	SetDebugLog("Begin DefenseSearchMultiMatch: " & $g_sBldgNames[$iDefenseType + 7], $COLOR_DEBUG1)

	Local $hTimer = __TimerInit() ; begin local timer

	; Setup arrays, including default return values for $return
	Local $defaultCoords[1][2] = [[0, 0]]
	Local $return[7] = ["None", "None", 0, 0, 0, $defaultCoords, ""]
	Local $aStatData[1][1] = [[""]] ; create fake "$aResults" array to store all filenames found for update of weakbase stats with existing code
	Local $aCoordArray[0][0], $aCoords, $aCoordsSplit, $aValue, $maxLevelSearch, $iTmpObjectLevel, $iTmpBldTotal, $iBuildingTotal, $sTempCoord
	Local $sLocCoord, $sNearCoord, $sFarCoord, $redlinesCount, $iCountUpdate
	Local $bRedLineExists = False

	; Define DLL call input parameters
	; Max return points possible from defense type being searched
	Local $maxReturnPoints = _ObjGetValue($g_oBldgMaxQty, $iDefenseType + 7)[($g_iSearchTH = "-" ? 10 : $g_iSearchTH - 1)] ; add 6 to weakbase enum to equal building enum
	If @error Then
		_ObjErrMsg("_ObjGetValue $g_oBldgMaxQty", @error) ; Log COM error prevented
	EndIf
	; Set search area to be inside dark green border
	Local $fullCocAreas = $CocDiamondDCD
	; Set max buidling level to search, except if using scripted CSV attack, then override max level
	#cs Not required!
	If isScriptedAttackActive() Then
		$maxLevelSearch = 100
	Else
		$maxLevelSearch = $maxLevel
	EndIf
	#ce
	$maxLevelSearch = $maxLevel

	; verify if red line data exists in dictionary, or was passed as parameter, to set flag for later retrevial of red line data and storage if needed.
	If $redlines = "" Or $redlines = $CocDiamondDCD Then
		If _ObjSearch($g_oBldgAttackInfo, $eBldgRedLine & "_OBJECTPOINTS") = True Then
			If _ObjGetValue($g_oBldgAttackInfo, $eBldgRedLine & "_COUNT") > 50 Then ; if count is less 50, try again to more red line locations
				$redlines = $g_oBldgAttackInfo.item($eBldgRedLine & "_LOCATION")
				If IsString($redlines) And $redlines <> "" And $redlines <> $CocDiamondDCD Then ; error check for null red line data in dictionary
					$bRedLineExists = True
				Else
					$bRedLineExists = False
				EndIf
			Else ; if less than 25 redline stored, then try again.
				$bRedLineExists = False
			EndIf
		Else
			$bRedLineExists = False
		EndIf
	ElseIf $redlines <> "" And $redlines <> $CocDiamondDCD Then
		$bRedLineExists = True
		If _ObjSearch($g_oBldgAttackInfo, $eBldgRedLine & "_OBJECTPOINTS") = False Then ; error check for dictionary value stored
			If $redlines <> $CocDiamondDCD Then ; ensure redline is valid location string
				$aCoordsSplit = StringSplit($redlines, "|") ; split redlines in x,y, to get count of redline locations
				$redlinesCount = $aCoordsSplit[0] ; assign to variable to avoid constant check for array exists
				If $redlinesCount > 50 Then
					_ObjAdd($g_oBldgAttackInfo, $eBldgRedLine & "_OBJECTPOINTS", $redlines)
					If @error Then _ObjErrMsg("_ObjAdd $g_oBldgAttackInfo", @error) ; Log COM error prevented
					_ObjAdd($g_oBldgAttackInfo, $eBldgRedLine & "_COUNT", $redlinesCount)
					If @error Then _ObjErrMsg("_ObjAdd $g_oBldgAttackInfo", @error) ; Log COM error prevented
				Else
					$bRedLineExists = False
				EndIf
			EndIf
		EndIf
	Else ; almost impossible....
		$bRedLineExists = False
	EndIf

	If $bRedLineExists = False Then
		$redlines = $CocDiamondDCD
	EndIf

	If $g_bDebugSetlog Then
		SetDebugLog("> " & $g_sBldgNames[$iDefenseType + 7] & " Max Level: " & $maxLevel & " Max Search Level: " & $maxLevelSearch, $COLOR_DEBUG)
		SetDebugLog("> Max return points: " & $maxReturnPoints, $COLOR_DEBUG)
		SetDebugLog("> Red Line Exists:" & $bRedLineExists & " , redlines=" & $redlines, $COLOR_DEBUG)
	EndIf
	If _Sleep($DELAYCHECKARMYCAMP6) Then Return $return; 10ms improve pause button response

	; Capture the screen
	If $bForceCaptureRegion = True Then _CaptureRegion2()

	; Perform the search
	Local $res = DllCallMyBot("SearchMultipleTilesBetweenLevels", "handle", $g_hHBitmap2, "str", $directory, "str", $fullCocAreas, "Int", $maxReturnPoints, "str", $redlines, "Int", $minLevel, "Int", $maxLevelSearch)
	If @error Then _logErrorDLLCall($g_sLibMyBotPath, @error)

	; Get the redline data if needed
	If $bRedLineExists = False Then ; if already exists, then skip saving again.
		$aValue = RetrieveImglocProperty("redline", "")
		If $aValue <> "" Then ; redline exists
			Local $aCoordsSplit = StringSplit($aValue, "|") ; split redlines in x,y, to get count of redline locations
			If $aCoordsSplit[0] > 50 Then
				$redlines = $aValue
				_ObjPutValue($g_oBldgAttackInfo, $eBldgRedLine & "_OBJECTPOINTS", $redlines) ; add/update value
				If @error Then _ObjErrMsg("_ObjPutValue $g_oBldgAttackInfo redline", @error)
				Local $redlinesCount = $aCoordsSplit[0] ; assign to variable to avoid constant check for array exists
				_ObjPutValue($g_oBldgAttackInfo, $eBldgRedLine & "_COUNT", $redlinesCount)
				If @error Then _ObjErrMsg("_ObjSetValue $g_oBldgAttackInfo", @error)
				$return[6] = $redlines ; Add the redline data to return array if we want to make future searches faster
			Else
				Setdebuglog("> Not enough red line points to save in building dictionary?", $COLOR_WARNING)
			EndIf
		Else
			SetLog("> DLL Error getting Red Lines in DefenseSearchMultiMatch", $COLOR_ERROR)
		EndIf
	Else
		$return[6] = $redlines ; store Redline Data in weak base array's
	EndIf

	If $res[0] <> "" Then ; check for valid dll return
		; Get the keys for the dictionary item.
		Local $aKeys = StringSplit($res[0], "|", $STR_NOCOUNT)
		;
		; Redimension the weak base statistic data array to allow for the new filename entries
		ReDim $aStatData[UBound($aKeys) + 1][1]

		For $i = 0 To UBound($aKeys) - 1
			; retrieve filename property, and store in statistics data array
			$aStatData[$i + 1][0] = RetrieveImglocProperty($aKeys[$i], "filename") ; Filename

			; retrieve object level, used to determine max level to return
			$iTmpObjectLevel = Int(RetrieveImglocProperty($aKeys[$i], "objectlevel")) ; convert string to integer for conditionals

			; Get the location cordinates property
			$sTempCoord = RetrieveImglocProperty($aKeys[$i], "objectpoints")
			; Check for duplicate locations from DLL when more than 1 location returned?
			If $i = 0 And StringLen($sTempCoord) > 7 Then
				$iCountUpdate = RemoveDupNearby($sTempCoord) ; remove duplicates BYREF, return location count
				;If $iTmpObjectLevel <> $iCountUpdate And $iCountUpdate <> "" Then $iTmpObjectLevel = $iCountUpdate
			EndIf

			; get number of buildings found
			$iTmpBldTotal = RetrieveImglocProperty($aKeys[$i], "totalobjects")

			; store "returnhighestsinglelevel" search data
			If $iTmpObjectLevel > Number($return[2]) Then ;And ($iTmpObjectLevel >= Int($maxLevel)) Then ; Check to see if is a higher level then currently stored for weakbase return array
				; Store the retrun data because its higher, and greater than max level in GUI
				$return[0] = $aStatData[$i + 1][0]
				$return[1] = RetrieveImglocProperty($aKeys[$i], "objectname") ; Type
				$return[2] = $iTmpObjectLevel ; Level
				$return[3] = RetrieveImglocProperty($aKeys[$i], "fillLevel") ; Fill level
				$return[4] = $iTmpBldTotal ; store weak base buildings found for this level
				; create location cordinate array for return
				$aCoords = StringSplit($sTempCoord, "|", $STR_NOCOUNT)
				ReDim $aCoordArray[UBound($aCoords)][2]
				; Loop through the found coords
				For $j = 0 To UBound($aCoords) - 1
					; Split the coords into an array
					$aCoordsSplit = StringSplit($aCoords[$j], ",", $STR_NOCOUNT)
					If UBound($aCoordsSplit) = 2 Then
						; Store the coords into a two dimensional array
						$aCoordArray[$j][0] = $aCoordsSplit[0] ; X coord.
						$aCoordArray[$j][1] = $aCoordsSplit[1] ; Y coord.
					EndIf
				Next
				; Store the coords array as a sub-array for return
				$return[5] = $aCoordArray
			EndIf
			; retrieve CSV needed data
			If isScriptedAttackActive() Then ; Need all location cordinates and total buildings found regardless of level if CSV is used
				; save all relevant data on every image found using key number to differentiate data, ONLY WHEN more than one image is found!
				If UBound($aKeys) > 1 Then
					_ObjAdd($g_oBldgAttackInfo, $iDefenseType + 7 & "_LVLFOUND_K" & $i, $iTmpObjectLevel)
					If @error Then _ObjErrMsg("_ObjAdd " & $g_sBldgNames[$iDefenseType + 7] & " _LVLFOUND_K" & $i, @error) ; log errors
					_ObjAdd($g_oBldgAttackInfo, $iDefenseType + 7 & "_FILENAME_K" & $i, $aKeys[$i])
					If @error Then _ObjErrMsg("_ObjAdd " & $g_sBldgNames[$iDefenseType + 7] & " _FILENAME_K" & $i, @error) ; log errors
					_ObjAdd($g_oBldgAttackInfo, $iDefenseType + 7 & "_COUNT_K" & $i, $iTmpBldTotal)
					If @error Then _ObjErrMsg("_ObjAdd " & $g_sBldgNames[$iDefenseType + 7] & " _COUNT_K" & $i, @error) ; log errors
					_ObjAdd($g_oBldgAttackInfo, $iDefenseType + 7 & "_OBJECTPOINTS_K" & $i, $sTempCoord) ; save string of locations
					If @error Then _ObjErrMsg("_ObjAdd " & $g_sBldgNames[$iDefenseType + 7] & " _OBJECTPOINTS_K" & $i, @error) ; Log errors
				EndIf
				If $iBuildingTotal >= $maxReturnPoints Then ContinueLoop ; Rare error where more images are found than max allowed, keep checking images to update weak base array
				; check if valid objectpoints returned
				If $sTempCoord <> "" Then
					If $sLocCoord = "" Then ; check if 1st set of points
						$sLocCoord = $sTempCoord
						$iBuildingTotal = $iTmpBldTotal
					Else ; if not 1st set, then merge and check for duplicate locations in object points
						$iCountUpdate = AddPoints_RemoveDuplicate($sLocCoord, $sTempCoord, $maxReturnPoints) ; filter results to remove duplicate locations matching same building location, return no more than max allowed
						If $iCountUpdate <> "" Then $iBuildingTotal = $iCountUpdate
					EndIf
				Else
					SetDebugLog("> no data in 'objectpoints' request?", $COLOR_WARNING)
				EndIf
			EndIf
		Next

		Local $aBldgCoord = decodeMultipleCoords($sLocCoord) ; change building location string into array
		If IsArray($aBldgCoord) Then $return[5] = $aBldgCoord ; store in return array

		If $g_bDebugSetlog Or $g_bDebugBuildingPos Then
			SetLog($g_sBldgNames[$iDefenseType + 7] & " Coordinates: " & $sLocCoord, $COLOR_DEBUG)
			Local $sText
			Select
				Case UBound($aBldgCoord, 1) > 1 And IsArray($aBldgCoord[1]) ; if we have array of arrays, separate and list
					$sText = PixelArrayToString($aBldgCoord, ",")
				Case UBound($aBldgCoord) > 0 And UBound($aBldgCoord[0]) = 2 ; single row with array
					Local $aPixelb = $aBldgCoord[0]
					$sText = PixelToString($aPixelb, ":")
				Case UBound($aBldgCoord) = 2 And IsArray($aBldgCoord[0]) = 0 ; Check if $aBldCoord has 2 rows otherwise PixelToString throws an error
					$sText = PixelToString($aBldgCoord, ":")
				Case Else
					$sText = "Monkey ate bad banana!"
			EndSelect
			SetLog($g_sBldgNames[$iDefenseType + 7] & " $aBldgCoord Array Contents: " & $sText, $COLOR_DEBUG)
		EndIf

		; finish storing CSV related data after retrieving all keys returned
		If isScriptedAttackActive() Then

			If $return[2] <> 0 Then
				_ObjAdd($g_oBldgAttackInfo, $iDefenseType + 7 & "_MAXLVLFOUND", $return[2]) ; save max level found, add siz to weakbase enum to equal building enum
				If @error Then _ObjErrMsg("_ObjAdd " & $g_sBldgNames[$iDefenseType + 7] & " _MAXLVLFOUND", @error) ; log errors
			EndIf

			If $return[0] <> "None" Then
				_ObjAdd($g_oBldgAttackInfo, $iDefenseType + 7 & "_NAMEFOUND", $return[0]) ; save file name of max level
				If @error Then _ObjErrMsg("_ObjAdd " & $g_sBldgNames[$iDefenseType + 7] & " _NAMEFOUND", @error) ; log errors
			EndIf

			If IsArray($aBldgCoord) Then
				_ObjAdd($g_oBldgAttackInfo, $iDefenseType + 7 & "_OBJECTPOINTS", $sLocCoord) ; save string of locations
				If @error Then _ObjErrMsg("_ObjAdd " & $g_sBldgNames[$iDefenseType + 7] & " _OBJECTPOINTS", @error) ; Log errors
				_ObjAdd($g_oBldgAttackInfo, $iDefenseType + 7 & "_LOCATION", $aBldgCoord) ; save building location array
				If @error Then _ObjErrMsg("_ObjAdd " & $g_sBldgNames[$iDefenseType + 7] & " _LOCATION", @error) ; Log errors
			EndIf

			If $iBuildingTotal <> 0 Then
				_ObjAdd($g_oBldgAttackInfo, $iDefenseType + 7 & "_COUNT", $iBuildingTotal)
				If @error Then _ObjErrMsg("_ObjAdd " & $g_sBldgNames[$iDefenseType + 7] & " _COUNT", @error) ; Log errors
			EndIf

			SetDebugLog("Total " & $g_sBldgNames[$iDefenseType + 7] & " Buildings: " & $iBuildingTotal)

			Local $iTime = __TimerDiff($hTimer) * 0.001 ; Image search time saved to dictionary in seconds
			_ObjAdd($g_oBldgAttackInfo, $iDefenseType + 7 & "_FINDTIME", $iTime)
			If @error Then _ObjErrMsg("_ObjAdd" & $g_sBldgNames[$iDefenseType + 7] & " _FINDTIME", @error) ; Log errors
			SetDebugLog("  - Location(s) found in: " & Round($iTime, 2) & " seconds ", $COLOR_DEBUG1)

		EndIf

	EndIf

	; Updated weakbase stats if filenames matched
	updateMultiSearchStats($aStatData, $statFile)

	Return $return
EndFunc   ;==>DefenseSearchMultiMatch

Func isScriptedAttackActive()
	If ($g_abAttackTypeEnable[$DB] And $g_aiAttackAlgorithm[$DB] = 1) Or ($g_abAttackTypeEnable[$LB] And $g_aiAttackAlgorithm[$LB] = 1) Then Return True
	Return False
EndFunc   ;==>isScriptedAttackActive




