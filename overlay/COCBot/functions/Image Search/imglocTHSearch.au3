; #FUNCTION# ====================================================================================================================
; Name ..........: imglocTHSearch
; Description ...: Searches for the TH in base, and returns; X&Y location, Bldg Level
; Syntax ........: imglocTHSearch([$bReTest = False])
; Parameters ....: $bReTest - [optional] a boolean value. Default is False.
; Return values .: None , sets several global variables
; Author ........: Trlopes (10-2016)
; Modified ......: CodeSlinger69 (01-2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Func imglocTHSearch($bReTest = False, $myVillage = False, $bForceCapture = True)
    Local $xdirectorya = @ScriptDir & "\imgxml\Buildings\Townhall"
    Local $xdirectoryb = @ScriptDir & "\imgxml\Buildings\Townhall2"
    Local $xdirectorySnowa = @ScriptDir & "\imgxml\Buildings\snow-Townhall"
    Local $xdirectorySnowb = @ScriptDir & "\imgxml\Buildings\snow-Townhall2"
    Local $xdirectory, $xdirectorySnow
    Local $sCocDiamond = $CocDiamondECD
    Local $redLines = ""
    Local $minLevel = 6 ; We only support TH6+
	Local $maxLevel = 100
	Local $maxReturnPoints = 1
	Local $returnProps = "objectname,objectlevel,objectpoints,nearpoints,farpoints,redlinedistance"
	Local $iFindTime = 0

	If $myVillage = False Then ; these are only for OPONENT village
		ResetTHsearch() ;see below
		$redLines = $CocDiamondECD ;quick fix for bad redline data
	Else
		$redLines = $CocDiamondECD ;needed for searching your own village
	EndIf

	;aux data
	Local $propsNames = StringSplit($returnProps, ",", $STR_NOCOUNT)
	SetDebugLog("imgloc TH search Start", $COLOR_DEBUG)
	Local $numRetry = 1 ; try to find TH twice (one retry)
	If $g_iDetectedImageType = 1 Then
		$numRetry = 3 ; try to find TH 4 times (three retries also without snow)
	EndIf

	For $retry = 0 To $numRetry
        Local $iLvlFound = 0
        If Mod($retry, 2) = 0 Then
            $xdirectory = $xdirectorya
            $xdirectorySnow = $xdirectorySnowa
        Else
            $xdirectory = $xdirectoryb
            $xdirectorySnow = $xdirectorySnowb
        EndIf
        
        SetDebugLog("$xdirectory = " & $xdirectory, $COLOR_DEBUG)

        If $g_iDetectedImageType = 1 And $retry < 2 Then ;Snow theme on
            $xdirectory = $xdirectorySnow ;"snow-" & $xdirectory
            SetDebugLog("With snow $xdirectory = " & $xdirectory, $COLOR_DEBUG)
        EndIf
		
		If $retry > 0 And $g_sImglocRedline <> "" Then ; on retry IMGLOCREDLNE is already populated
			;$redLines = $g_sImglocRedline ;quick fix for bad redline data, so disabled for now
		EndIf

		Local $hTimer = __TimerInit()
		Local $result = findMultiple($xdirectory, $sCocDiamond, $redLines, $minLevel, $maxLevel, $maxReturnPoints, $returnProps, $bForceCapture)

		If IsArray($result) Then
			;we got results from multisearch ; lets set $redline in case we need to perform another search
			;quick fix for bad redline data, so disabled for now
			;$redLines = $g_sImglocRedline ; that was set by findMultiple if redline argument was ""

			If $g_sImglocRedline <> "" Then  ; Add redline data to global building dictionary
				_ObjPutValue($g_oBldgAttackInfo, $eBldgRedLine & "_OBJECTPOINTS", $g_sImglocRedline)
				If @error Then _ObjErrMsg("_ObjPutValue $g_oBldgAttackInfo imglocTHSearch", @error) ; Log COM error prevented
				Local $aCoordsSplit = StringSplit($g_sImglocRedline, "|") ; split redlines in x,y, to get count of redline locations
				Local $redlinesCount = $aCoordsSplit[0] ; assign to variable to avoid constant check for array exists
				_ObjPutValue($g_oBldgAttackInfo, $eBldgRedLine & "_COUNT", $redlinesCount)
				If @error Then _ObjErrMsg("_ObjPutValue $g_oBldgAttackInfo imglocTHSearch", @error)
			EndIf

			Local $iBestResult = 0
			If UBound($result) > 1 Then
				SetDebugLog("imgloc Found Multiple TH : " & UBound($result), $COLOR_INFO)
				; search for highest level
				Local $iHighestLvl = 0
				For $iResult = 0 To UBound($result) - 1
					Local $propsValues = $result[$iResult]
					For $pv = 0 To UBound($propsValues) - 1
						Switch $propsNames[$pv]
							Case "objectlevel"
								Local $iLvl = Number($propsValues[$pv])
								If $iLvl > $iHighestLvl Then
									$iHighestLvl = $iLvl
									$iBestResult = $iResult
								EndIF
						EndSwitch
					Next
				Next
				SetDebugLog("imgloc Found Multiple TH : Using index " & $iBestResult, $COLOR_INFO)
			EndIf
			If UBound($result) > 0 Then
				SetDebugLog("imgloc Found TH : ", $COLOR_INFO)
				Local $propsValues = $result[$iBestResult]
				For $pv = 0 To UBound($propsValues) - 1
					SetDebugLog("imgloc Found : " & $propsNames[$pv] & " - " & $propsValues[$pv], $COLOR_INFO)
					Switch $propsNames[$pv]
						Case "objectname"
							;nothing to do
							_ObjPutValue($g_oBldgAttackInfo, $eBldgTownHall & "_NAMEFOUND", $propsValues[$pv]) ; add object name found to building dictionary
							If @error Then _ObjErrMsg("$g_oBldgAttackInfo imglocTHSearch " & $g_sBldgNames[$eBldgTownHall] & "_NAMEFOUND", @error) ; Log COM error prevented
							Local $PathFile = $propsValues[$pv]
						Case "objectlevel"
							$iLvlFound = Number($propsValues[$pv])
							If $myVillage = False Then
								$g_iImglocTHLevel = $iLvlFound
								$g_aiTownHallDetails[2] = Number($propsValues[$pv])
								$g_iSearchTH = Number($propsValues[$pv])
								_ObjPutValue($g_oBldgAttackInfo, $eBldgTownHall & "_MAXLEVELFOUND", $propsValues[$pv]) ; add TH Level found to buidling dictionary
								If @error Then _ObjErrMsg("$g_oBldgAttackInfo imglocTHSearch " & $g_sBldgNames[$eBldgTownHall] & "_MAXLEVELFOUND", @error) ; Log COM error prevented
							Else
								$g_iTownHallLevel = $iLvlFound ; I think $g_iTownHallLevel needs to be decreased
							EndIf
						Case "objectpoints"
							If $propsValues[$pv] = "0" Then
								;there was an error inside imgloc and location is empty or error
								SaveDebugImage("imglocTHSearch_NoTHFound_", True)
								ResetTHsearch()
								Return
							EndIf
							If $myVillage = False Then
								$IMGLOCTHLOCATION = decodeSingleCoord($propsValues[$pv]) ;array [x][y]
								$g_aiTownHallDetails[0] = Number($IMGLOCTHLOCATION[0])
								$g_aiTownHallDetails[1] = Number($IMGLOCTHLOCATION[1])
								$g_iTHx = Number($IMGLOCTHLOCATION[0]) ; backwards compatibility
								$g_iTHy = Number($IMGLOCTHLOCATION[1]) ; backwards compatibility
								_ObjPutValue($g_oBldgAttackInfo, $eBldgTownHall & "_OBJECTPOINTS", $propsValues[$pv]) ; add string location of TH found to building dictionary
								If @error Then _ObjErrMsg("$g_oBldgAttackInfo imglocTHSearch " & $g_sBldgNames[$eBldgTownHall] & "_OBJECTPOINTS", @error) ; Log COM error prevented

								Local $aTHLoc = decodeMultipleCoords($propsValues[$pv]) ; need TH location in same format as other buildings, meaning array containing x,y location sub-arrays
								_ObjPutValue($g_oBldgAttackInfo, $eBldgTownHall & "_LOCATION", $aTHLoc) ; add array location of TH found to building dictionary
								If @error Then _ObjErrMsg("$g_oBldgAttackInfo imglocTHSearch " & $g_sBldgNames[$eBldgTownHall] & "_LOCATION", @error) ; Log COM error prevented

								If $g_bDebugImageSave And $retry > 0 Then
									_CaptureRegion()

									; Store a copy of the image handle
									Local $editedImage = $g_hBitmap
									Local $subDirectory = $g_sProfileTempDebugPath & "\Thdetection\"
									DirCreate($subDirectory)

									; Create the timestamp and filename
									Local $Date = @YEAR & "-" & @MON & "-" & @MDAY
									Local $Time = @HOUR & "." & @MIN & "." & @SEC
									Local $fileName = "Thdetection_" & $retry & "_" & $Date & "_" & $Time & ".png"

									; Needed for editing the picture
									Local $hGraphic = _GDIPlus_ImageGetGraphicsContext($editedImage)
									Local $hPen = _GDIPlus_PenCreate(0xFFFF0000, 2) ; Create a pencil Color FF0000/RED

									addInfoToDebugImage($hGraphic, $hPen, String($PathFile & "_" & $g_iImglocTHLevel), $g_iTHx, $g_iTHy)

									; Save the image and release any memory
									_GDIPlus_ImageSaveToFile($editedImage, $subDirectory & $fileName)
									_GDIPlus_PenDispose($hPen)
									_GDIPlus_GraphicsDispose($hGraphic)
								EndIf
							Else
								$g_aiTownHallPos = decodeSingleCoord($propsValues[$pv])
								ConvertFromVillagePos($g_aiTownHallPos[0], $g_aiTownHallPos[1])
							EndIf
						Case "nearpoints"
							If $myVillage = False Then
								$IMGLOCTHNEAR = $propsValues[$pv]
								_ObjPutValue($g_oBldgAttackInfo, $eBldgTownHall & "_NEARPOINTS", $propsValues[$pv]) ; add near points to building dictionary
								If @error Then _ObjErrMsg("$g_oBldgAttackInfo imglocTHSearch " & $g_sBldgNames[$eBldgTownHall] & "_NEARPOINTS", @error) ; Log COM error prevented
							EndIf
						Case "farpoints"
							If $myVillage = False Then
								$IMGLOCTHFAR = $propsValues[$pv]
								_ObjPutValue($g_oBldgAttackInfo, $eBldgTownHall & "_FARPOINTS", $propsValues[$pv]) ; add FAR points to building dictionary
								If @error Then _ObjErrMsg("$g_oBldgAttackInfo imglocTHSearch " & $g_sBldgNames[$eBldgTownHall] & "_FARPOINTS", @error) ; Log COM error prevented
							EndIf
						Case "redlinedistance"
							If $myVillage = False Then
								$IMGLOCTHRDISTANCE = $propsValues[$pv]
								_ObjPutValue($g_oBldgAttackInfo, $eBldgTownHall & "_REDLINEDISTANCE", $propsValues[$pv]) ; add red line distance to building dictionary
								If @error Then _ObjErrMsg("$g_oBldgAttackInfo imglocTHSearch " & $g_sBldgNames[$eBldgTownHall] & "_REDLINEDISTANCE", @error) ; Log COM error prevented
							EndIf
					EndSwitch
					If $myVillage = False Then
						$g_aiTownHallDetails[3] = 1 ; found 1 only
					EndIf
				Next
				If $iLvlFound > 0 Then
					ExitLoop ; TH was found
				EndIf
			EndIf
		Else
            ;th not found
			If $g_bDebugSetlog And $retry > 0 Then SetLog("imgloc Could not find TH", $COLOR_WARNING)
			If $g_bDebugSetlog And $retry > 0 Then SetLog("imgloc THSearch Calculated  (in " & Round(__TimerDiff($hTimer) / 1000, 2) & " seconds) :")
		EndIf

		If $iLvlFound > 0 Then
			$iFindTime += __TimerDiff($hTimer) ; add total TH search time in milliseconds
			SetDebugLog("imgloc THSearch Calculated  (in " & Round($iFindTime / 1000, 2) & " seconds) :")
			ExitLoop ; TH was found
		Else
			If $g_bDebugImageSave And $retry > 0 Then SaveDebugImage("imglocTHSearch_NoTHFound_", True)
			SetDebugLog("imgloc THSearch Notfound, Retry:  " & $retry)
		EndIf

	Next ; retry

	If $iFindTime <> 0 Then ; Remove error message when TH not found at all :(
		_ObjPutValue($g_oBldgAttackInfo, $eBldgTownHall & "_FINDTIME", $iFindTime * 0.001) ; store total TH Finding time in seconds to building dictionary
		If @error Then _ObjErrMsg("$g_oBldgAttackInfo imglocTHSearch " & $g_sBldgNames[$eBldgTownHall] & "_FINDTIME", @error) ; Log COM error prevented
	EndIf

EndFunc   ;==>imglocTHSearch

Func ResetTHsearch()
	;something not good happened
	;reset redlines and other globals
	$g_sImglocRedline = "" ; Redline data obtained from FindMultiple
	$g_iImglocTHLevel = 0 ; Duhhh!!!
	$IMGLOCTHLOCATION = StringSplit(",", ",", $STR_NOCOUNT) ; x,y array
	$IMGLOCTHNEAR = "" ; 5 points 5px from redline Near to TH
	$IMGLOCTHFAR = "" ; 5 points 25px from redline Near to TH
	$IMGLOCTHRDISTANCE = "" ; Reline distace to TH
	;compatibility
	$g_aiTownHallDetails[0] = -1 ; [LocX, LocY, BldgLvl, Quantity]
	$g_aiTownHallDetails[1] = -1 ; [LocX, LocY, BldgLvl, Quantity]
	$g_aiTownHallDetails[2] = -1 ; [LocX, LocY, BldgLvl, Quantity]
	$g_aiTownHallDetails[3] = -1 ; [LocX, LocY, BldgLvl, Quantity]
	$g_iTHx = 0 ; backwards compatibility
	$g_iTHy = 0 ; backwards compatibility
	$g_iSearchTH = "-" ; means not found
	; empty TH data from dictionary
	Local $string
	Local $iKeys = $g_oBldgAttackInfo.Keys
	For $string In $iKeys
		If StringInStr($string, $eBldgTownHall & "_", $STR_NOCASESENSEBASIC) > 0 Then $g_oBldgAttackInfo.Remove($string)
	Next
	; SetDebugLog("TH search data cleared", $COLOR_DEBUG)

EndFunc   ;==>ResetTHsearch

;backwards compatibility
Func imgloccheckTownHallADV2($limit = 0, $tolerancefix = 0, $captureRegion = True)
	imglocTHSearch(True, False, $captureRegion) ; try 2 times to get TH

	If $g_iImglocTHLevel = 0 Then
		Return "-"
	Else
		Return $g_iImglocTHLevel
	EndIf

EndFunc   ;==>imgloccheckTownHallADV2
