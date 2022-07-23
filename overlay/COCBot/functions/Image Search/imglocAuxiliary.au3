; #FUNCTION# ====================================================================================================================
; Name ..........: Imgloc Aux functions
; Description ...: auxyliary functions used by imgloc
; Syntax ........:
; Parameters ....:
; Return values .: None
; Author ........: Trlopes (2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func decodeMultipleCoords($coords, $iDedupX = Default, $iDedupY = Default, $iSorted = Default)
	If $iDedupX = Default Then $iDedupX = -1
	If $iDedupY = Default Then $iDedupY = -1
	If $iSorted = Default Then $iSorted = -1
	;returns array of N coordinates [0=x, 1=y][0=x1, 1=y1]
	Local $retCoords, $c
	Local $pOff = 0
	;	SetDebugLog("**decodeMultipleCoords: " & $coords, $COLOR_DEBUG)
	Local $aCoordsSplit = StringSplit($coords, "|", $STR_NOCOUNT)
	If StringInStr($aCoordsSplit[0], ",") > 0 Then
		Local $retCoords[UBound($aCoordsSplit)]
	Else ;has total count in value
		$pOff = 1
		Local $retCoords[Number($aCoordsSplit[0])]
	EndIf
	Local $iErr = 0
	For $p = 0 To UBound($retCoords) - 1
		$c = decodeSingleCoord($aCoordsSplit[$p + $pOff])
		If UBound($c) > 1 Then
			$retCoords[$p - $iErr] = $c
		Else
			; not a coordinate
			$iErr += 1
		EndIf
	Next
	If $iErr > 0 Then ReDim $retCoords[UBound($retCoords) - $iErr]

	If UBound($retCoords) = 0 Then
		Local $aEmpty[0]
		Return $aEmpty
	EndIf
	If UBound($retCoords) = 1 Or ($iDedupX < 1 And $iDedupY < 1 And $iSorted = -1) Then Return $retCoords ; no dedup, return array

	; dedup coords
	If $iDedupX > 0 Or $iDedupY > 0 Then
		Local $aFinalCoords[1] = [$retCoords[0]]
		Local $c1, $c2, $k, $inX, $inY
		For $i = 1 To UBound($retCoords) - 1
			$c1 = $retCoords[$i]
			$k = UBound($aFinalCoords) - 1
			For $j = 0 To $k
				$c2 = $aFinalCoords[$j]
				$inX = Abs($c1[0] - $c2[0]) < $iDedupX
				$inY = Abs($c1[1] - $c2[1]) < $iDedupY
				If ($iDedupY < 1 And $inX) Or ($iDedupX < 1 And $inY) Or ($inX And $inY) Then
					; duplicate coord
					ContinueLoop 2
				EndIf
			Next
			; add coord
			ReDim $aFinalCoords[$k + 2]
			$aFinalCoords[$k + 1] = $c1
		Next
	Else
		Local $aFinalCoords = $retCoords
	EndIf
	If $iSorted = 0 Or $iSorted = 1 Then
		Local $a[UBound($aFinalCoords)][2], $c1
		For $i = 0 To UBound($aFinalCoords) - 1
			$c1 = $aFinalCoords[$i]
			$a[$i][0] = $c1[0]
			$a[$i][1] = $c1[1]
		Next
		_ArraySort($a, 0, 0, 0, $iSorted)
		For $i = 0 To UBound($a) - 1
			$c1 = $aFinalCoords[$i]
			$c1[0] = $a[$i][0]
			$c1[1] = $a[$i][1]
			$aFinalCoords[$i] = $c1
		Next
	EndIf

	Return $aFinalCoords
EndFunc   ;==>decodeMultipleCoords

Func decodeSingleCoord($coords)
	Return _decodeSingleCoord($coords)
EndFunc   ;==>decodeSingleCoord

Func _decodeSingleCoord($coords)
	#Region - Custom fix - Team AIO Mod++
	If UBound($coords) > 0 And not @error Then
		Local $aArray = $coords[0]
		; _ArrayDisplay($aArray)
		If UBound($aArray) > 0 And not @error Then
			For $sIn In $aArray
				; SetLog($sIn)
				If StringInStr($sIn, ",") > 0 Then
					; SetLog($sIn)
					Local $aSplit = StringSplit2D($sIn, ",", "|", True)
					; _ArrayDisplay($aSplit)
					If UBound($aSplit, $UBOUND_COLUMNS) > 0 And not @error Then
						; SetlOG("OK")
						Local $aReturn[2] = [$aSplit[0][0], $aSplit[0][1]]
						; _ArrayDisplay($aReturn)
						Return $aReturn
					EndIf
				EndIf
			Next
		EndIf
	EndIf
	#EndRegion - Custom fix - Team AIO Mod++

	;returns array with 2 coordinates 0=x, 1=y
	Local $aCoordsSplit = StringSplit($coords, ",", $STR_NOCOUNT)
	If UBound($aCoordsSplit) > 1 Then
		$aCoordsSplit[0] = Int($aCoordsSplit[0])
		$aCoordsSplit[1] = Int($aCoordsSplit[1])
	EndIf
	Return $aCoordsSplit
EndFunc   ;==>_decodeSingleCoord

Func RetrieveImglocProperty($key, $property)
	; Get the property
	Local $aValue = DllCall($g_hLibMyBot, "str", "GetProperty", "str", $key, "str", $property)
	If @error Then _logErrorDLLCall($g_sLibMyBotPath, @error) ; check for error with DLL call
	If UBound($aValue) = 0 Then
		Return ""
	EndIf
	Return $aValue[0]
EndFunc   ;==>RetrieveImglocProperty

Func checkImglocError(ByRef $imglocvalue, $funcName, $sTileSource = "", $sImageArea = "")
	;Return true if there is an error in imgloc return string
	If IsArray($imglocvalue) Then ;despite beeing a string, AutoIt receives a array[0]
		If $imglocvalue[0] = "0" Or $imglocvalue[0] = "" Then
			SetDebugLog($funcName & " imgloc search returned no results" & ($sImageArea ? " in " & $sImageArea : "") & ($sTileSource ? " for '" & $sTileSource & "' !" : "!"), $COLOR_WARNING)
			Return True
		ElseIf StringLeft($imglocvalue[0], 2) = "-1" Then ;error
			SetDebugLog($funcName & " - Imgloc DLL Error: " & $imglocvalue[0], $COLOR_ERROR)
			Return True
		ElseIf StringLeft($imglocvalue[0], 2) = "-2" Then ;critical error
			SetLog($funcName & " - Imgloc DLL Critical Error", $COLOR_RED)
			SetLog(StringMid($imglocvalue[0], 4), $COLOR_RED)
			SetLog("Restart bot in 30 seconds.", $COLOR_GREEN)
			If _SleepStatus(30000) = False Then
				RestartBot(False, True)
			EndIf
			Return True
		Else
			Return False
		EndIf
	Else
		SetDebugLog($funcName & " - Imgloc  Error: Not an Array Result", $COLOR_ERROR)
		Return True
	EndIf
EndFunc   ;==>checkImglocError

Func ClickB($sButtonName, $buttonTileArrayOrPatternOrFullPath = Default, $iDelay = 100, $iLoop = 1)
	Local $aiButton = -1

	For $i = 1 To $iLoop
		$aiButton = findButton($sButtonName, $buttonTileArrayOrPatternOrFullPath, 1, True)
		If $iLoop = 1 Then ExitLoop
		If _Sleep($iDelay) Then Return
		If IsArray($aiButton) And UBound($aiButton) >= 2 Then ExitLoop
	Next

	If IsArray($aiButton) And UBound($aiButton) >= 2 Then
		ClickP($aiButton, 1)
		If _Sleep($iDelay) Then Return
		Return True
	EndIf
	Return False
EndFunc   ;==>ClickB

Func findButton($sButtonName, $buttonTileArrayOrPatternOrFullPath = Default, $maxReturnPoints = 1, $bForceCapture = True)

	If $buttonTileArrayOrPatternOrFullPath = Default Then $buttonTileArrayOrPatternOrFullPath = $sButtonName & "*"

	Local $error, $extError
	Local $searchArea = GetButtonDiamond($sButtonName)
	Local $aCoords = "" ; use AutoIt mixed varaible type and initialize array of coordinates to null
	Local $aButtons
	Local $sButtons = ""

	; check if file tile is a pattern
	If IsString($buttonTileArrayOrPatternOrFullPath) Then
		$sButtons = $buttonTileArrayOrPatternOrFullPath
		If StringInStr($buttonTileArrayOrPatternOrFullPath, "*") > 0 Then
			Local $aFiles = _FileListToArray($g_sImgImgLocButtons, $sButtons, $FLTA_FILES, True)
			If @error Then
				Local $vError = SetError(1, 1, False)
				Setlog("findButton | No files in " & $g_sImgImgLocButtons, $COLOR_ERROR)
				Return $vError
			EndIf
			$aButtons = $aFiles
		Else
			Local $a[1] = [$sButtons]
			$aButtons = $a
		EndIf
	ElseIf IsArray($buttonTileArrayOrPatternOrFullPath) Then
		$aButtons = $buttonTileArrayOrPatternOrFullPath
		$sButtons = _ArrayToString($aButtons)
	Else
		Return SetError(1, 2, "Bad Input Values : " & $buttonTileArrayOrPatternOrFullPath) ; Set external error code = 1 for bad input values
	EndIf

	; Check function parameters
	If Not IsString($sButtonName) Or UBound($aButtons) < 1 Then
		Return SetError(1, 3, "Bad Input Values : " & $sButtons) ; Set external error code = 1 for bad input values
	EndIf
	#Region - Custom fix - Team AIO Mod++
	Local $i = 0
	Do
		For $buttonTile In $aButtons

			; Check function parameters
			If FileExists($buttonTile) = 0 Then ContinueLoop ; Team AIO Mod++

			If $bForceCapture Then _CaptureRegion2() ;to have FULL screen image to work with

			SetDebugLog(" imgloc searching for: " & $sButtonName & " : " & $buttonTile)
			Local $result = DllCallMyBot("FindTile", "handle", $g_hHBitmap2, "str", $buttonTile, "str", $searchArea, "Int", $maxReturnPoints)
			$error = @error ; Store error values as they reset at next function call
			$extError = @extended
			If $error Then
				_logErrorDLLCall($g_sLibMyBotPath, $error)
				SetDebugLog(" imgloc DLL Error imgloc " & $error & " --- " & $extError)
				Return SetError(2, 1, $extError) ; Set external error code = 2 for DLL error
			EndIf

			If $result[0] <> "" And checkImglocError($result, "imglocFindButton", $buttonTile) = False Then
				SetDebugLog($sButtonName & " Button Image Found in: " & $result[0])
				$aCoords = StringSplit($result[0], "|", $STR_NOCOUNT)
				;[0] - total points found
				;[1] -  coordinates
				If $maxReturnPoints = 1 Then
					Return StringSplit($aCoords[1], ",", $STR_NOCOUNT) ; return just X,Y coord
				ElseIf IsArray($aCoords) Then
					Local $aReturnResult[0][2]
					For $i = 1 To UBound($aCoords) - 1
						_ArrayAdd($aReturnResult, $aCoords[$i], 0, ",", @CRLF, $ARRAYFILL_FORCE_NUMBER)
					Next
					Return $aReturnResult ; return 2D array
				EndIf
			EndIf

		Next
		If _Sleep(500) Then Return $aCoords
		$i += 1
	Until ($i > 1)
	#EndRegion - Custom fix - Team AIO Mod++

	SetDebugLog($sButtonName & " Button Image(s) NOT FOUND : " & $sButtons, $COLOR_ERROR)
	Return $aCoords
EndFunc   ;==>findButton

Func GetButtonDiamond($sButtonName)
	Local $btnDiamond = "FV"

	Switch $sButtonName
		Case "UpgradePets"
			$btnDiamond = GetDiamondFromRect("590,486,735,551") ; Resolution changed
		Case "ReloadButton"
			$btnDiamond = GetDiamondFromRect("550,406,850,656") ; Resolution changed
		Case "CloseFindMatch" ;Find Match Screen
			$btnDiamond = "806,12|848,12|848,52|806,52" ; Resolution changed
		Case "AttackButton" ;Main Window Screen
			$btnDiamond = "15,532|112,532|112,627|15,627" ; Resolution changed
		Case "OpenTrainWindow" ;Main Window Screen
			$btnDiamond = "15,472|65,472|65,522|15,522" ; Resolution changed
		Case "TrashEvent"
			$btnDiamond = GetDiamondFromRect("100,156(740,340)") ; Resolution changed
		Case "EventFailed"
			$btnDiamond = GetDiamondFromRect("230,130(547,430)") ; Resolution changed
		Case "OK"
			$btnDiamond = "440,351|587,351|587,416|440,416" ; Resolution changed
		Case "CANCEL"
			$btnDiamond = "272,351|420,351|420,416|272,416" ; Resolution changed
		Case "ReturnHome"
			$btnDiamond = "357,501|502,501|502,563|357,563" ; Resolution changed
		Case "Next" ; attackpage attackwindow
			$btnDiamond = "697,454|850,454|850,522|697,522" ; Resolution changed
		Case "ObjectButtons", "BoostOne", "BoostCT", "Upgrade", "Research", "Treasury", "RemoveObstacle", "CollectLootCart", "Pets" ; Full size of object buttons at the bottom
			$btnDiamond = GetDiamondFromRect("140,500(580,80)") ; Resolution changed
		Case "GEM", "BOOSTBtn" ; Boost window button (full button size)
			$btnDiamond = GetDiamondFromRect("359,368(148,66)") ; Resolution changed
		Case "EnterShop"
			$btnDiamond = GetDiamondFromRect("359,348(148,66)") ; Resolution changed
		Case "EndBattleSurrender" ;surrender - attackwindow
			$btnDiamond = "12,489|125,489|125,527|12,527" ; Resolution changed
		Case "ClanChat"
			$btnDiamond = GetDiamondFromRect("0,256(400,250)") ; Resolution changed
		Case "ChatOpenRequestPage" ;mainwindow - chat open
			$btnDiamond = "5,600|65,600|65,637|5,637" ; Resolution changed
		Case "Profile" ;mainwindow - only visible if chat closed
			$btnDiamond = "172,15|205,15|205,48|172,48" ; Resolution changed
		Case "DonateWindow" ;mainwindow - only when donate window is visible
			$btnDiamond = "310,0|360,0|360,644|310,644" ; Resolution changed
		Case "DonateButton" ;mainwindow - only when chat window is visible
			$btnDiamond = "200,85|305,85|305,590|200,590" ; Resolution changed
		Case "UpDonation" ;mainwindow - only when chat window is visible
			$btnDiamond = "282,85|306,85|306,130|282,130" ; Resolution changed
		Case "DownDonation" ;mainwindow - only when chat window is visible
			$btnDiamond = "282,547|306,547|306,590|282,590" ; Resolution changed
		Case "Collect"
			$btnDiamond = "350,410|505,410|505,480|350,480" ; Resolution changed
		Case "BoostBarrack", "BarrackBoosted"
			$btnDiamond = GetDiamondFromRect("630,236,850,316") ; Resolution changed
		Case "ArmyTab", "TrainTroopsTab", "BrewSpellsTab", "BuildSiegeMachinesTab", "QuickTrainTab"
			$btnDiamond = GetDiamondFromRect("18,56,800,106") ; Resolution changed
		Case "MessagesButton"
			$btnDiamond = GetDiamondFromRect("0,0,250,250") ; Resolution changed
		Case "AttackLogTab", "ShareReplayButton"
			$btnDiamond = GetDiamondFromRect("280,41,600,256") ; Resolution changed ?
		Case "EndBattle", "Surrender"
			$btnDiamond = "12,489|125,489|125,527|12,527" ; Resolution changed
		Case "Okay"
			$btnDiamond = "440,351|587,351|587,416|440,416" ; Resolution changed
		#Region - BoostPotion - Team AIO Mod
        Case "MagicItems", "Boostleft" ; Team AIO Mod++
			$btnDiamond = GetDiamondFromRect("200,490(500,100)") ; Resolution changed
		#EndRegion - BoostPotion - Team AIO Mod
		Case Else
			$btnDiamond = "FV" ; use full image to locate button
	EndSwitch
	Return $btnDiamond
EndFunc   ;==>GetButtonDiamond

Func UpdateImgeTile(ByRef $sImageTile, $AndroidTag = Default)
	Local $iMinimumAndroidVersion = Int($AndroidTag)
	If $iMinimumAndroidVersion > 1 And $g_iAndroidVersionAPI < $iMinimumAndroidVersion Then
		; not required to search anything
		Return False
	EndIf

	If Not IsBool($AndroidTag) Then
		If $iMinimumAndroidVersion > 0 Then
			$AndroidTag = True
		Else
			$AndroidTag = False
		EndIf
	EndIf


	If $AndroidTag Then
		; add [Android Code Name] at the end, see https://en.wikipedia.org/wiki/Android_version_history
		$sImageTile = StringReplace($sImageTile, "[Android]", GetAndroidCodeName())
		If $iMinimumAndroidVersion > 1 And @extended = 0 Then
			SetDebugLog("Android Code Name cannot be added to title: " & $sImageTile, $COLOR_ERROR)
		EndIf
	EndIf

	Return True
EndFunc   ;==>UpdateImgeTile

Func findImage($sImageName, $sImageTile, $sImageArea, $maxReturnPoints = 1, $bForceCapture = True, $AndroidTag = Default)
	If $AndroidTag = Default Then $AndroidTag = True
	Local $aCoords = "" ; use AutoIt mixed variable type and initialize array of coordinates to null
	Local $iPattern = StringInStr($sImageTile, "*")
	If Not UpdateImgeTile($sImageTile, $AndroidTag) Then Return $aCoords

	If $iPattern > 0 Then
		Local $dir = ""
		Local $pat = $sImageTile
		Local $iLastBS = StringInStr($sImageTile, "\", 0, -1)
		If $iLastBS > 0 Then
			$dir = StringLeft($sImageTile, $iLastBS)
			$pat = StringMid($sImageTile, $iLastBS + 1)
		EndIf
		Local $files = _FileListToArray($dir, $pat, $FLTA_FILES, True)
		If @error Or UBound($files) < 2 Then
			SetDebugLog("findImage files not found : " & $sImageTile, $COLOR_ERROR)
			SetError(1, 0, $aCoords) ; Set external error code = 1 for bad input values
			Return
		EndIf
		For $i = 1 To $files[0]
			$aCoords = findImage($sImageName, $files[$i], $sImageArea, $maxReturnPoints, $bForceCapture)
			If UBound(decodeSingleCoord($aCoords)) > 1 Then Return $aCoords
		Next
		Return $aCoords
	EndIf
	; same has findButton, but allow custom area instead of button area decoding
	; nice for dynamic locations
	Local $error, $extError

	; Check function parameters
	If Not FileExists($sImageTile) Then
		SetDebugLog("findImage file not found : " & $sImageTile, $COLOR_ERROR)
		SetError(1, 1, $aCoords) ; Set external error code = 1 for bad input values
		Return
	EndIf

	; Capture the screen for comparison
	; _CaptureRegion2() or similar must be used before
	; Perform the search
	If $bForceCapture Then _CaptureRegion2() ;to have FULL screen image to work with

	Local $result = DllCallMyBot("FindTile", "handle", $g_hHBitmap2, "str", $sImageTile, "str", $sImageArea, "Int", $maxReturnPoints)
	$error = @error ; Store error values as they reset at next function call
	$extError = @extended
	If $error Then
		_logErrorDLLCall($g_sLibMyBotPath, $error)
		SetDebugLog(" imgloc DLL Error imgloc " & $error & " --- " & $extError)
		SetError(2, $extError, $aCoords) ; Set external error code = 2 for DLL error
		Return
	EndIf

	If checkImglocError($result, "findImage", $sImageTile, $sImageArea) Then
		If $g_bDebugSetlog And $g_bDebugImageSave Then SaveDebugImage("findImage_" & $sImageName, True)
		Return $aCoords
	EndIf

	If $result[0] <> "" Then ;despite being a string, AutoIt receives a array[0]
		SetDebugLog("findImage : " & $sImageName & " Found in: " & $result[0])
		$aCoords = StringSplit($result[0], "|", $STR_NOCOUNT)
		;[0] - total points found
		;[1] -  coordinates
		If $maxReturnPoints = 1 Then
			Return $aCoords[1] ; return just X,Y coord
		Else
			Return $result[0] ; return full string with count and points
		EndIf
	Else
		SetDebugLog("findImage : " & $sImageName & " NOT FOUND " & $sImageTile)
		If $g_bDebugSetlog And $g_bDebugImageSave Then SaveDebugImage("findImage_" & $sImageName, True)
		Return $aCoords
	EndIf

EndFunc   ;==>findImage

Func GetDeployableNextTo($sPoints, $distance = 3, $redlineoverride = "")
	Local $result = DllCall($g_hLibMyBot, "str", "GetDeployableNextTo", "str", $sPoints, "int", $distance, "str", $redlineoverride)
	Local $error = @error ; Store error values as they reset at next function call
	Local $extError = @extended
	If $error Then
		_logErrorDLLCall($g_sLibMyBotPath, $error)
		SetDebugLog(" imgloc DLL Error imgloc " & $error & " --- " & $extError)
		SetError(2, $extError, "") ; Set external error code = 2 for DLL error
		Return ""
	EndIf

	If UBound($result) = 0 Then Return ""
	SetDebugLog("GetDeployableNextTo : " & $sPoints & ", dist. = " & $distance & " : " & $result[0], $COLOR_ACTION)
	Return $result[0]
EndFunc   ;==>GetDeployableNextTo

Func GetOffsetRedline($sArea = "TL", $distance = 3)
	Local $result = DllCall($g_hLibMyBot, "str", "GetOffSetRedline", "str", $sArea, "int", $distance)
	Local $error = @error ; Store error values as they reset at next function call
	Local $extError = @extended
	If $error Then
		_logErrorDLLCall($g_sLibMyBotPath, $error)
		SetDebugLog(" imgloc DLL Error imgloc " & $error & " --- " & $extError)
		SetError(2, $extError, "") ; Set external error code = 2 for DLL error
		Return ""
	EndIf

	If UBound($result) = 0 Then Return ""
	SetDebugLog("GetOffSetRedline : " & $sArea & ", dist. = " & $distance & " : " & $result[0], $COLOR_ACTION)
	Return $result[0]
EndFunc   ;==>GetOffsetRedline

Func findMultiple($directory, $sCocDiamond, $redLines, $minLevel = 0, $maxLevel = 1000, $maxReturnPoints = 0, $returnProps = "objectname,objectlevel,objectpoints", $bForceCapture = True)
	; same has findButton, but allow custom area instead of button area decoding
	; nice for dinamic locations
	If $g_bDebugSetlog Then
		SetDebugLog("******** findMultiple *** START ***", $COLOR_ACTION)
		SetDebugLog("findMultiple : directory : " & $directory, $COLOR_ACTION)
		SetDebugLog("findMultiple : sCocDiamond : " & $sCocDiamond, $COLOR_ACTION)
		SetDebugLog("findMultiple : redLines : " & $redLines, $COLOR_ACTION)
		SetDebugLog("findMultiple : minLevel : " & $minLevel, $COLOR_ACTION)
		SetDebugLog("findMultiple : maxLevel : " & $maxLevel, $COLOR_ACTION)
		SetDebugLog("findMultiple : maxReturnPoints : " & $maxReturnPoints, $COLOR_ACTION)
		SetDebugLog("findMultiple : returnProps : " & $returnProps, $COLOR_ACTION)
		SetDebugLog("******** findMultiple *** START ***", $COLOR_ACTION)
	EndIf

	Local $error, $extError

	Local $aCoords = "" ; use AutoIt mixed variable type and initialize array of coordinates to null
	Local $returnData = StringSplit($returnProps, ",", $STR_NOCOUNT)
	Local $returnLine[UBound($returnData)]
	Local $returnValues[0]


	; Capture the screen for comparison
	; Perform the search
	If $bForceCapture Then _CaptureRegion2() ;to have FULL screen image to work with

	Local $result = DllCallMyBot("SearchMultipleTilesBetweenLevels", "handle", $g_hHBitmap2, "str", $directory, "str", $sCocDiamond, "Int", $maxReturnPoints, "str", $redLines, "Int", $minLevel, "Int", $maxLevel)
	$error = @error ; Store error values as they reset at next function call
	$extError = @extended
	If $error Then
		_logErrorDLLCall($g_sLibMyBotPath, $error)
		SetDebugLog(" imgloc DLL Error : " & $error & " --- " & $extError)
		SetError(2, $extError, $aCoords) ; Set external error code = 2 for DLL error
		Return ""
	EndIf

	If checkImglocError($result, "findMultiple", $directory) = True Then
		SetDebugLog("findMultiple Returned Error or No values : ", $COLOR_DEBUG)
		SetDebugLog("******** findMultiple *** END ***", $COLOR_ACTION)
		Return ""
	Else
		SetDebugLog("findMultiple found : " & $result[0])
	EndIf

	If $result[0] <> "" Then ;despite being a string, AutoIt receives a array[0]
		Local $resultArr = StringSplit($result[0], "|", $STR_NOCOUNT)
		ReDim $returnValues[UBound($resultArr)]
		Local $iErr = 0
		For $rs = 0 To UBound($resultArr) - 1
			For $rD = 0 To UBound($returnData) - 1 ; cycle props
				$returnLine[$rD] = RetrieveImglocProperty($resultArr[$rs], $returnData[$rD])
				If $returnData[$rD] = "objectpoints" Then
					; validate object points
					If StringInStr($returnLine[$rD], ",") = 0 Then
						; no valid coordinate, skip values
						SetDebugLog("findMultiple : Invalid objectpoint in result in " & $rD & ": " & $result[0])
						$iErr += 1
						ContinueLoop 2
					EndIf
				EndIf
				SetDebugLog("findMultiple : " & $resultArr[$rs] & "->" & $returnData[$rD] & " -> " & $returnLine[$rD])
			Next
			$returnValues[$rs - $iErr] = $returnLine
		Next
		If $iErr Then ReDim $returnValues[UBound($resultArr) - $iErr]

		;;lets check if we should get redlinedata
		If $redLines = "" Then
			$g_sImglocRedline = RetrieveImglocProperty("redline", "") ;global var set in imgltocTHSearch
			SetDebugLog("findMultiple : Redline argument is emty, setting global Redlines")
		EndIf
		SetDebugLog("******** findMultiple *** END ***", $COLOR_ACTION)
		Return $returnValues

	Else
		SetDebugLog(" ***  findMultiple has no result **** ", $COLOR_ACTION)
		SetDebugLog("******** findMultiple *** END ***", $COLOR_ACTION)
		Return ""
	EndIf

EndFunc   ;==>findMultiple

;receives "StartX,StartY,EndX,EndY" or "StartX,StartY(Width,Height)" and returns 0 based array
Func GetRectArray($rect, $bLogError = True)
	Local $a = []
	Local $RectValues = StringSplit($rect, ",", $STR_NOCOUNT)
	If UBound($RectValues) = 3 Then
		ReDim $RectValues[4]
		; check for width and height
		$i = StringInStr($RectValues[2], ")")
		If $i = 0 Then
			If $bLogError Then SetDebugLog("GetRectArray : Bad Input Values : " & $rect, $COLOR_ERROR)
			Return SetError(1, 1, $a)
		EndIf
		$RectValues[3] = $RectValues[1] + StringLeft($RectValues[2], $i - 1)
		$i = StringInStr($RectValues[1], "(")
		If $i = 0 Then
			If $bLogError Then SetDebugLog("GetRectArray : Bad Input Values : " & $rect, $COLOR_ERROR)
			Return SetError(1, 2, $a)
		EndIf
		$RectValues[2] = $RectValues[0] + StringMid($RectValues[1], $i + 1)
		$RectValues[1] = StringLeft($RectValues[1], $i - 1)
	EndIf
	If UBound($RectValues) < 4 Then
		If $bLogError Then SetDebugLog("GetRectArray : Bad Input Values : " & $rect, $COLOR_ERROR)
		Return SetError(1, 3, $a)
	EndIf
	Return SetError(0, 0, $RectValues)
EndFunc   ;==>GetRectArray

Func GetDiamondFromRect($rect)
	;receives "StartX,StartY,EndX,EndY" or "StartX,StartY(Width,Height)"
	;returns "StartX,StartY|EndX,StartY|EndX,EndY|StartX,EndY"
	SetError(0)
	Local $returnvalue = "", $i
	Local $RectValues = IsArray($rect) ? $rect : GetRectArray($rect, False)
	Local $error = @error, $extended = @extended
	If UBound($RectValues) < 4 Then
		If $error = 0 Then $error = 1
		SetDebugLog("GetDiamondFromRect : Bad Input Values : " & $rect, $COLOR_ERROR)
		Return SetError($error, $extended, $returnvalue)
	EndIf
	Local $DiamdValues[4]
	Local $X = Number($RectValues[0])
	Local $Y = Number($RectValues[1])
	Local $Ex = Number($RectValues[2])
	Local $Ey = Number($RectValues[3])
	$DiamdValues[0] = $X & "," & $Y
	$DiamdValues[1] = $Ex & "," & $Y
	$DiamdValues[2] = $Ex & "," & $Ey
	$DiamdValues[3] = $X & "," & $Ey
	$returnvalue = $DiamdValues[0] & "|" & $DiamdValues[1] & "|" & $DiamdValues[2] & "|" & $DiamdValues[3]
	Return $returnvalue
EndFunc   ;==>GetDiamondFromRect

Func GetDiamondFromArray($aRectArray)
	;Recieves $aArray[0] = StartX
	;		  $aArray[1] = StartY
	;		  $aArray[2] = EndX
	;		  $aArray[3] = EndY

	If UBound($aRectArray, 1) < 4 Then
		SetDebugLog("GetDiamondFromArray: Bad Input Array!", $COLOR_ERROR)
		Return ""
	EndIf
	Local $iX = Number($aRectArray[0]), $iY = Number($aRectArray[1])
	Local $iEndX = Number($aRectArray[2]), $iEndY = Number($aRectArray[3])

	;If User inputed Width and Height then add start point to get the final End Coordinates
	If $iEndY <= $iY Then $iEndY += $iY
	If $iEndX <= $iX Then $iEndX += $iX

	Local $sReturnDiamond = ""
	$sReturnDiamond = $iX & "," & $iY & "|" & $iEndX & "," & $iY & "|" & $iEndX & "," & $iEndY & "|" & $iX & "," & $iEndY
	Return $sReturnDiamond
EndFunc   ;==>GetDiamondFromArray

#Region - Custom - Team AIO Mod++
Func GetDiamondFromComma($iX = -1, $iY = -1, $iEndX = $g_iGAME_WIDTH, $iEndY = $g_iGAME_HEIGHT)

	If $iX = -1 Or $iY = -1 Or $iEndX = -1 Or $iEndY = -1 Then
		SetDebugLog("GetDiamondRectComma: Bad input!", $COLOR_ERROR)
		Return "FV"
	EndIf

	;If User inputed Width and Height then add start point to get the final End Coordinates
	If $iEndY <= $iY Then $iEndY += $iY
	If $iEndX <= $iX Then $iEndX += $iX

	Local $sReturnDiamond = ""
	$sReturnDiamond = $iX & "," & $iY & "|" & $iEndX & "," & $iY & "|" & $iEndX & "," & $iEndY & "|" & $iX & "," & $iEndY
	Return $sReturnDiamond
EndFunc   ;==>GetDiamondFromArray
#EndRegion - Custom - Team AIO Mod++

Func FindImageInPlace($sImageName, $sImageTile, $place, $bForceCaptureRegion = True, $AndroidTag = Default)
	;creates a reduced capture of the place area a finds the image in that area
	;returns string with X,Y of ACTUALL FULL SCREEN coordinates or Empty if not found
	SetDebugLog("FindImageInPlace : > " & $sImageName & " - " & $sImageTile & " - " & $place, $COLOR_INFO)
	Local $returnvalue = ""
	Local $aPlaces = GetRectArray($place)
	Local $sImageArea = GetDiamondFromRect($aPlaces)
	If $bForceCaptureRegion = True Then
		$sImageArea = "FV"
		_CaptureRegion2(Number($aPlaces[0]), Number($aPlaces[1]), Number($aPlaces[2]), Number($aPlaces[3]))
	EndIf
	Local $coords = findImage($sImageName, $sImageTile, $sImageArea, 1, False, $AndroidTag) ; reduce capture full image
	Local $aCoords = decodeSingleCoord($coords)
	If UBound($aCoords) < 2 Then
		SetDebugLog("FindImageInPlace : " & $sImageName & " NOT Found", $COLOR_INFO)
		Return ""
	EndIf
	If $bForceCaptureRegion Then
		$returnvalue = Number($aCoords[0]) + Number($aPlaces[0]) & "," & Number($aCoords[1]) + Number($aPlaces[1])
	Else
		$returnvalue = Number($aCoords[0]) & "," & Number($aCoords[1])
	EndIf
	SetDebugLog("FindImageInPlace : < " & $sImageName & " Found in " & $returnvalue, $COLOR_INFO)
	Return $returnvalue
EndFunc   ;==>FindImageInPlace

Func SearchRedLines($sCocDiamond = $CocDiamondECD)
	If $g_sImglocRedline <> "" Then Return $g_sImglocRedline
	Local $result = DllCallMyBot("SearchRedLines", "handle", $g_hHBitmap2, "str", $sCocDiamond)
	Local $error = @error ; Store error values as they reset at next function call
	Local $extError = @extended
	If $error Then
		_logErrorDLLCall($g_sLibMyBotPath, $error)
		SetDebugLog(" imgloc DLL Error : " & $error & " --- " & $extError)
		SetError(2, $extError) ; Set external error code = 2 for DLL error
		Return ""
	EndIf
	If checkImglocError($result, "SearchRedLines") = True Then
		SetDebugLog("SearchRedLines Returned Error or No values : ", $COLOR_DEBUG)
		SetDebugLog("******** SearchRedLines *** END ***", $COLOR_ACTION)
		Return ""
	Else
		SetDebugLog("SearchRedLines found : " & $result[0])
	EndIf
	$g_sImglocRedline = $result[0]
	Return $g_sImglocRedline
EndFunc   ;==>SearchRedLines

Func SearchRedLinesMultipleTimes($sCocDiamond = $CocDiamondECD, $iCount = 3, $iDelay = 300)
	Local $bHBitmap_synced = ($g_hHBitmap = $g_hHBitmap2)
	Local $g_hHBitmap2_old = $g_hHBitmap2
	Local $g_sImglocRedline_old

	; ensure current $g_sImglocRedline has been generated
	SearchRedLines($sCocDiamond)
	; count # of redline points
	Local $iRedlinePoints = [UBound(StringSplit($g_sImglocRedline, "|", $STR_NOCOUNT)), 0]

	SetDebugLog("Initial # of redline points: " & $iRedlinePoints[0])

	; clear $g_hHBitmap2, so it doesn't get deleted
	$g_hHBitmap2 = 0

	Local $iCaptureTime = 0
	Local $iRedlineTime = 0
	Local $aiTotals = [0, 0]
	Local $iBest = 0

	For $i = 1 To $iCount

		$g_sImglocRedline_old = $g_sImglocRedline

		Local $hTimer = __TimerInit()

		; take new screenshot
		ForceCaptureRegion()
		_CaptureRegion2()

		$iCaptureTime = __TimerDiff($hTimer)

		; generate new redline based on new screenshot
		$g_sImglocRedline = "" ; clear current redline
		SearchRedLines($sCocDiamond)

		$iRedlineTime = __TimerDiff($hTimer) - $iCaptureTime

		$aiTotals[0] += $iCaptureTime
		$aiTotals[1] += $iRedlineTime

		; count # of redline points
		$iRedlinePoints[1] = UBound(StringSplit($g_sImglocRedline, "|", $STR_NOCOUNT))

		SetDebugLog($i & ". # of redline points: " & $iRedlinePoints[1])

		If $iRedlinePoints[1] > $iRedlinePoints[0] Then
			; new picture has more redline points
			$iRedlinePoints[0] = $iRedlinePoints[1]
			$iBest = $i
		Else
			; old picture has more redline points
			$g_sImglocRedline = $g_sImglocRedline_old
		EndIf

		If $i < $iCount Then
			Local $iDelayCompensated = $iDelay - __TimerDiff($hTimer)
			If $iDelayCompensated >= 10 Then Sleep($iDelayCompensated)
		EndIf

	Next

	If $iBest = 0 Then
		SetDebugLog("Using initial redline with " & $iRedlinePoints[0] & " points")
	Else
		SetDebugLog("Using " & $iBest & ". redline with " & $iRedlinePoints[0] & " points (capture/redline avg. time: " & Int($aiTotals[0] / $iCount) & "/" & Int($aiTotals[1] / $iCount) & ")")
	EndIf

	; delete current $g_hHBitmap2
	GdiDeleteHBitmap($g_hHBitmap2)

	; restore previous captured image
	If $bHBitmap_synced Then
		_CaptureRegion2Sync()
	Else
		$g_hHBitmap2 = $g_hHBitmap2_old
	EndIf
	Return $g_sImglocRedline
EndFunc   ;==>SearchRedLinesMultipleTimes

Func Slot($iX, $iY) ; Return Slots for Quantity Reading on Army Window
	If $iY < 490 Then
		Switch $iX ; Troops & Spells Slots
			Case 0 To 94 ; Slot 1
				If $iY < 315 Then Return 35 ; Troops
				If $iY > 315 Then Return 40 ; Spells

			Case 95 To 170 ; Slot 2
				If $iY < 315 Then Return 111 ; Troops
				If $iY > 315 Then Return 120 ; Spell

			Case 171 To 243 ; Slot 3
				If $iY < 315 Then Return 184 ; Troops
				If $iY > 315 Then Return 195 ; Spell

			Case 244 To 314 ; Slot 4
				If $iY < 315 Then Return 255 ; Troops
				If $iY > 315 Then Return 272 ; Spell

			Case 315 To 387 ; Slot 5
				If $iY < 315 Then Return 330 ; Troops
				If $iY > 315 Then Return 341 ; Spell

			Case 388 To 460 ; Slot 6
				If $iY < 315 Then Return 403 ; Troops
				If $iY > 315 Then Return 415 ; Spell

			Case 461 To 533 ; Slot 7
				If $iY < 315 Then Return 477 ; Troops
				If $iY > 315 Then Return 485 ; Spell
;~ 			Case 534 To 600 ; Slot 7.5 (8)
;~ 				Return 551 ; Troops

			Case 605 To 677 ; Slot 8
				Return 620 ; Siege Machines slot 1

			Case 678 To 752 ; Slot 9
				Return 693 ; Siege Machines slot 2

			Case 754 To 826 ; Slot 10
				Return 769 ; Siege Machines slot 2
		EndSwitch
	Else ;CC Troops & Spells
		Switch $iX
			Case 0 To 94 ; CC Troops Slot 1
				Return 35

			Case 95 To 170 ; CC Troops Slot 2
				Return 111

			Case 171 To 243 ; CC Troops Slot 3
				Return 184

			Case 244 To 307 ; CC Troops Slot 4
				Return 255

			Case 308 To 392 ; CC Troops Slot 5
				Return 330

			Case 393 To 435 ; CC Troops Slot 6
				Return 403

			Case 450 To 510 ; CC Spell Slot 1
				Return 475
			Case 511 To 535 ; CC Spell Middle ( Happens with Clan Castles with the max. Capacity of 1!)
				Return 510
			Case 536 To 605 ; CC Spell Slot 2
				Return 555
			Case 625 To 700 ; CC Siege Machines
				Return 650
		EndSwitch
	EndIf
EndFunc   ;==>Slot

Func GetDummyRectangle($sCoords, $ndistance)
	;creates a dummy rectangle to be used by Reduced Image Capture
	Local $aCoords = StringSplit($sCoords, ",", $STR_NOCOUNT)
	Return Number($aCoords[0]) - $ndistance & "," & Number($aCoords[1]) - $ndistance & "," & Number($aCoords[0]) + $ndistance & "," & Number($aCoords[1]) + $ndistance
EndFunc   ;==>GetDummyRectangle

Func ImgLogDebugProps($result)
	If UBound($result) < 1 Then Return False
	Local $resultArr = StringSplit($result[0], "|", $STR_NOCOUNT)
	Local $returnData = StringSplit("objectname,objectlevel,objectpoints", ",", $STR_NOCOUNT)
	For $rs = 0 To UBound($resultArr) - 1
		For $rD = 0 To UBound($returnData) - 1 ; cycle props
			Local $returnLine = RetrieveImglocProperty($resultArr[$rs], $returnData[$rD])
			SetLog("ImgLogDebugProps : " & $resultArr[$rs] & "->" & $returnData[$rD] & " -> " & $returnLine)
		Next
	Next
EndFunc   ;==>ImgLogDebugProps

Func CaptureReg($sDir, $searchArea = "FV", $bForceCapture = True, $maxReturnPoints = 1000)
	Local $aReturnResult[0][4]
	If $bForceCapture Then _CaptureRegion2() ;to have FULL screen image to work with

	Local $aFiles = _FileListToArrayRec($sDir, "*.png;*.xml", 1, 0, 1,2)
	If @error Then
		Setlog("findMulti: No files in " & $sDir, $COLOR_ERROR)
		Return SetError(1, 1, False)
	EndIf

	Local $asResult, $iError, $bFirst = False, $aCoords, $iCount = 0, $sFname = ""
	For $buttonTile In $aFiles
		If $bFirst = False Then
			$bFirst = True
			ContinueLoop
		EndIf
		
		$asResult = DllCallMyBot("FindTile", "handle", $g_hHBitmap2, "str", $buttonTile, "str", $searchArea, "Int", $maxReturnPoints)
		If @error Then _logErrorDLLCall($g_sLibMyBotPath, @error)

		If IsArray($asResult) Then
			If $asResult[0] = "0" Then
				$iError = 0
			ElseIf $asResult[0] = "-1" Then
				$iError = -1
			ElseIf $asResult[0] = "-2" Then
				$iError = -2
			Else
				If $asResult[0] = "" Then ContinueLoop
				$aCoords = StringSplit($asResult[0], "|", $STR_NOCOUNT)
				For $i = 1 To UBound($aCoords) - 1
					$sFname = StringRegExpReplace($buttonTile, "^.*\\|\_.*$", "")
					ReDim $aReturnResult[$iCount + 1][4]
					$aReturnResult[$iCount][0] = $sFname
					$aReturnResult[$iCount][1] = Number(StringRegExpReplace($aCoords[$i], "\,.*$", ""))
					$aReturnResult[$iCount][2] = Number(StringRegExpReplace($aCoords[$i], "^.*\,", ""))
					$aReturnResult[$iCount][3] = _StringBetween($sFname, "_", ".")
					$iCount += 1
				Next
			EndIf
		EndIf
	Next
	
	If UBound($aReturnResult) < 1 Then 
		Return -1
	EndIf
	
	; DebugImgArrayClassic($aReturnResult, "CaptureReg")
	
	Return $aReturnResult ; return 3D array
EndFunc
