; #FUNCTION# ====================================================================================================================
; Name ..........: getOcrDissociable
; Description ...: Gets complete value of gold/Elixir/DarkElixir/Trophy/Gem xxx,xxx
; Author ........: Dissociable (2020)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2020
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Global $g_bForceDocr = False

#Region - Team AIO Mod++ (Dissociable OCR)
Func getResourcesBonus($x_start, $y_start) ; -> Gets complete value of Gold/Elixir bonus loot in "AttackReport.au3"
	If $g_bForceDocr = False Then Return getOcrAndCapture("coc-bonus", $x_start, $y_start, 98, 20, True)
	Return getOcrAndCaptureDOCR($g_sASUpgradeResourcesDOCRPath, $x_start, $y_start, 98, 18, True, True) 
EndFunc   ;==>getResourcesBonus

Func getUpgradeResource($x_start, $y_start) ; -> Gets complete value of Gold/Elixir xxx,xxx , RED text on green upgrade button."UpgradeBuildings.au3"
	If $g_bForceDocr = False Then Return getOcrAndCapture("coc-u-r", $x_start, $y_start, 98, 20, True)
	Return getOcrAndCaptureDOCR($g_sASUpgradeResourcesRedDOCRPath, $x_start, $y_start, 98, 18, True, True)
EndFunc   ;==>getUpgradeResource

Func getBldgUpgradeTime($x_start, $y_start) ; -> Gets complete remain building upgrade time
	Return getOcrAndCapture("coc-uptime", $x_start, $y_start, 72, 18) ; Was 42. 72 tested as enough : "12d 19h" now
EndFunc   ;==>getBldgUpgradeTime
#EndRegion - Team AIO Mod++ (Dissociable OCR)

; Attack Screen
Func getAttackScreenButtons($x_start, $y_start, $iWidth, $iHeight)
	Return getOcrAndCaptureDOCR($g_sASButtonsDOCRPath, $x_start, $y_start, $iWidth, $iHeight, False, True)
EndFunc   ;==>getAttackScreenButtons
; End Attack Screen

; Search village sector
#Region - Team AIO Mod++ (Dissociable OCR)
Func getGoldVillageSearch($x_start, $y_start, $bNeedCapture = True) ;48, 69 -> Gets complete value of gold xxx,xxx while searching, top left, Getresources.au3
	If $g_bForceDocr = False Then Return getOcrAndCapture("coc-v-g", $x_start, $y_start, 90, 16, True, Default, $bNeedCapture)
	Return getOcrAndCaptureDOCR($g_sAttackRGold, $x_start, $y_start, 90, 16, True, $bNeedCapture)
EndFunc   ;==>getGoldVillageSearch

Func getElixirVillageSearch($x_start, $y_start, $bNeedCapture = True) ;48, 69+29 -> Gets complete value of Elixir xxx,xxx, top left,  Getresources.au3
	If $g_bForceDocr = False Then Return getOcrAndCapture("coc-v-e", $x_start, $y_start, 90, 16, True, Default, $bNeedCapture)
	Return getOcrAndCaptureDOCR($g_sAttackRPink, $x_start, $y_start, 90, 16, True, $bNeedCapture)
EndFunc   ;==>getElixirVillageSearch

Func getDarkElixirVillageSearch($x_start, $y_start, $bNeedCapture = True) ;48, 69+57 or 69+69  -> Gets complete value of Dark Elixir xxx,xxx, top left,  Getresources.au3
	If $g_bForceDocr = False Then Return getOcrAndCapture("coc-v-de", $x_start, $y_start, 75, 18, True, Default, $bNeedCapture)
	Return getOcrAndCaptureDOCR($g_sAttackRBlack, $x_start, $y_start, 75, 18, True, $bNeedCapture)
EndFunc   ;==>getDarkElixirVillageSearch

Func getTrophyVillageSearch($x_start, $y_start, $bNeedCapture = True) ;48, 69+99 or 69+69 -> Gets complete value of Trophies xxx,xxx , top left, Getresources.au3
	Return getOcrAndCapture("coc-v-t", $x_start, $y_start, 75, 18, True, Default, $bNeedCapture)
EndFunc   ;==>getTrophyVillageSearch

Func getOcrOverAllDamage($x_start, $y_start, $bNeedCapture = True) ;  -> Get the Overall Damage %
	Return getOcrAndCapture("coc-overalldamage", $x_start, $y_start, 50, 20, True, Default, $bNeedCapture)
EndFunc   ;==>getOcrOverAllDamage
#EndRegion - Team AIO Mod++ (Dissociable OCR)

; Search village sector end.

Func getResourcesMainScreen($x_start, $y_start) ; -> Gets complete value of Gold/Elixir/Dark Elixir/Trophies/Gems xxx,xxx "VillageReport.au3"
	If $g_bForceDocr = False Then 
		Return _getResourcesMainScreen($x_start, $y_start)
	EndIf

	Return getOcrAndCaptureDOCR($g_sMainResourcesDOCRB, $x_start, $y_start, 110, 16, True)
EndFunc   ;==>getResourcesMainScreen

Func getTrophyMainScreen($x_start, $y_start) ; -> Gets trophy value, top left of main screen "VillageReport.au3"
	If $g_bForceDocr = False Then 
		Return _getTrophyMainScreen($x_start, $y_start)
	EndIf

	Return getOcrAndCaptureDOCR($g_sMainResourcesDOCRB, $x_start, $y_start, 50, 16, True)
EndFunc   ;==>getTrophyMainScreen

Func getResourcesValueTrainPage($x_start, $y_start) ; -> Gets CheckValuesCost on Train Window
	If $g_bForceDocr = False Then 
		Return _getResourcesValueTrainPage($x_start, $y_start)
	EndIf

	Return getOcrAndCaptureDOCR($g_sMainResourcesDOCRB, $x_start, $y_start, 100, 18, True)
EndFunc   ;==>getResourcesValueTrainPage

Func getBuilders($x_start, $y_start) ;  -> Gets Builders number - main screen --> getBuilders(324,23)  coc-profile
	If $g_bForceDocr = False Then Return getOcrAndCapture("coc-Builders", $x_start, $y_start, 40, 18, True)
	Return getOcrAndCaptureDOCR($g_sMainBuildersDOCRB, $x_start, $y_start, 45, 20, True)
EndFunc   ;==>getBuilders

Func SpecialOCRCut($sBundle, $iX_start, $iY_start, $iWidth, $iHeight, $bRemoveSpace = Default, $bForceCaptureRegion = Default)
	Return StringReplace(getOcrAndCaptureDOCR($sBundle, $iX_start, $iY_start, $iWidth, $iHeight, $bRemoveSpace, $bForceCaptureRegion), "#", "")
EndFunc   ;==>getBuilders

#CS - OCR Betas.
Func _getTroopCountSmall($x_start, $y_start, $bNeedNewCapture = Default) ;  -> Gets troop amount on Attack Screen for non-selected troop kind
	If $g_bForceDocr = False Then 
		Return __getTroopCountSmall($x_start, $y_start, $bNeedNewCapture)
	EndIf

	Return SpecialOCRCut($g_sAttackBarDOCRB, $x_start, $y_start-8, 55, 17+8, True, $bNeedNewCapture)
EndFunc   ;==>_getTroopCountSmall

Func _getTroopCountBig($x_start, $y_start, $bNeedNewCapture = Default) ;  -> Gets troop amount on Attack Screen for selected troop kind
	If $g_bForceDocr = False Then 
		Return __getTroopCountBig($x_start, $y_start, $bNeedNewCapture)
	EndIf

	Return SpecialOCRCut($g_sAttackBarDOCRB, $x_start, $y_start-8, 55, 17+8, True, $bNeedNewCapture)
EndFunc   ;==>_getTroopCountBig

Func getArmyCampCap($x_start, $y_start, $bNeedCapture = True) ;  -> Gets army camp capacity --> train.au3, and used to read CC request time remaining
	Return getOcrAndCaptureDOCR($g_sAOverviewTotals, $x_start, $y_start, 82, 16, True, $bNeedCapture)
EndFunc   ;==>getArmyCampCap

Func getTroopCountSmall($x_start, $y_start, $bNeedNewCapture = Default) ;  -> Gets troop amount on Attack Screen for non-selected troop kind
	Return SpecialOCRCut($g_sAttackBarDOCRB, $x_start, $y_start-8, 55, 17+8, True, $bNeedNewCapture)
EndFunc   ;==>getTroopCountSmall

Func getTroopCountBig($x_start, $y_start, $bNeedNewCapture = Default) ;  -> Gets troop amount on Attack Screen for selected troop kind
	Return SpecialOCRCut($g_sAttackBarDOCRB, $x_start, $y_start-8, 55, 17+8, True, $bNeedNewCapture)
EndFunc   ;==>getTroopCountBig
#CE - OCR Betas.

Func getOcrAndCaptureDOCR($sBundle, $iX_start, $iY_start, $iWidth, $iHeight, $bRemoveSpace = Default, $bForceCaptureRegion = Default)
	If $bRemoveSpace = Default Then $bRemoveSpace = False
	If $bForceCaptureRegion = Default Then $bForceCaptureRegion = $g_bOcrForceCaptureRegion
	Static $_hHBitmap = 0
	If $bForceCaptureRegion = True Then
		_CaptureRegion2($iX_start, $iY_start, $iX_start + $iWidth, $iY_start + $iHeight)
	Else
		$_hHBitmap = GetHHBitmapArea($g_hHBitmap2, $iX_start, $iY_start, $iX_start + $iWidth, $iY_start + $iHeight)
	EndIf
    ;If $g_bDebugOCR = True Then SaveDebugImage("OCRDissociable", $_hHBitmap)
	Local $aResult
	If $_hHBitmap <> 0 Then
		$aResult = getOcrDOCR($_hHBitmap, $sBundle)
	Else
		$aResult = getOcrDOCR($g_hHBitmap2, $sBundle)
	EndIf
	If $_hHBitmap <> 0 Then
		GdiDeleteHBitmap($_hHBitmap)
	EndIf
	$_hHBitmap = 0
	If ($bRemoveSpace) Then
		$aResult = StringReplace($aResult, "|", "")
		$aResult = StringStripWS($aResult, $STR_STRIPALL)
	Else
		$aResult = StringStripWS($aResult, BitOR($STR_STRIPLEADING, $STR_STRIPTRAILING, $STR_STRIPSPACES))
	EndIf
	Return $aResult
EndFunc   ;==>getOcrAndCaptureDOCR

Func getOcrDOCR(ByRef Const $_hHBitmap, $sBundle)
	Local $aResult = DllCallDOCR("Recognize", "str", "handle", $_hHBitmap, "str", $sBundle)
	If $g_bDOCRDebugImages Then
		DirCreate($g_sProfileTempDebugDOCRPath)
		Local $isBundleFile = StringRight($sBundle, 5) = ".docr"
		Local $sSubDirFolder = ""
		If $isBundleFile Then
			; Remove the Last Backslash from the directory path
			While (StringRight($sBundle, 1) = "\")
				$sBundle = StringTrimRight($sBundle, 1)
			WEnd
			Local $aSplittedPath = StringSplit($sBundle, "\")
			$sSubDirFolder = $aSplittedPath[UBound($aSplittedPath, 1) - 2] & "_" & StringReplace($aSplittedPath[UBound($aSplittedPath, 1) - 1], ".docr", "")
		Else
			Local $sDrive = "", $sDir = "", $sFileName = "", $sExtension = ""
			Local $aPathSplit = _PathSplit($sBundle, $sDrive, $sDir, $sFileName, $sExtension)
			Local $aSplittedPath = StringSplit(StringTrimRight($sBundle, StringLen($sFileName & $sExtension) + 1), "\")
			$sSubDirFolder = $aSplittedPath[UBound($aSplittedPath, 1) - 1] & "_" & $sFileName
		EndIf
		Local $sDir
		If StringRight($g_sProfileTempDebugDOCRPath, 1) <> "\" Then
			$sDir = $g_sProfileTempDebugDOCRPath & "\"
		Else
			$sDir = $g_sProfileTempDebugDOCRPath
		EndIf
		$sDir &= $sSubDirFolder & "\"
		DirCreate($sDir)
		
		Local $sDateTime = @YEAR & "-" & @MON & "-" & @MDAY & "_" & @HOUR & "-" & @MIN & "-" & @SEC & "." & @MSEC
		Local $hBitmap_debug = _GDIPlus_BitmapCreateFromHBITMAP($_hHBitmap)
		Local $sFilePath = $sDir & StringRegExpReplace(StringReplace($aResult, "|", "-"), "[\[\]/\|\:\?""\*\\<>]", "") & ".png"
		SetDebugLog("Save DOCR Debug Image: " & $sFilePath)
		_GDIPlus_ImageSaveToFile($hBitmap_debug, $sFilePath)
		_GDIPlus_BitmapDispose($hBitmap_debug)
	EndIf
	Return $aResult
EndFunc   ;==>getOcrDOCR