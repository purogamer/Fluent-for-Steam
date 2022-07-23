
; #FUNCTION# ====================================================================================================================
; Name ..........: getBuilderCount
; Description ...: updates global builder count variables
; Syntax ........: getBuilderCount([$bSuppressLog = False], [$bBuilderBase = False])
; Parameters ....: $bSuppressLog        - [optional] a boolean value that stops log of builder count. Default is False.
; Parameters ....: $bBuilderBase        - [optional] Set to True if you want to get Builder Count on Builder Base. Default is False -> Read Normal Village Count
; Return values .: None
; Author ........: MonkeyHunter (06-2016)
; Modified ......: Fliegerfaust (06-2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

;getBuilderCount(true,true)
;MainSuggestedUpgradeCode()
Func getBuilderCount($bSuppressLog = False, $bBuilderBase = $g_bStayOnBuilderBase) ; AIO Team

	If $g_bChkOnlyFarm Then SetLog("Only farm mode ON.", $COLOR_INFO) ; AIO Team - Only farm
	
	Local $sBuilderInfo, $aGetBuilders, $bIsMainPage = False

	If Not $bBuilderBase Then
		$bIsMainPage = IsMainPage()
	Else
		$bIsMainPage = IsMainPageBuilderBase()
	EndIf

	If $bIsMainPage Then ; check for proper window location

		If Not $bBuilderBase Then
			$sBuilderInfo = getBuilders($aBuildersDigits[0], $aBuildersDigits[1]) ; get builder string with OCR
		Else
			$sBuilderInfo = getBuilders($aBuildersDigitsBuilderBase[0], $aBuildersDigitsBuilderBase[1]) ; get builder base builder string with OCR
		EndIf
		If StringInStr($sBuilderInfo, "#") > 0 Then ; check for valid OCR read
			$aGetBuilders = StringSplit($sBuilderInfo, "#", $STR_NOCOUNT) ; Split into free and total builder strings
			If Not $bBuilderBase Then
				$g_iFreeBuilderCount = Int($aGetBuilders[0]) ; update global values
				If $g_iTestFreeBuilderCount <> -1 Then $g_iFreeBuilderCount = $g_iTestFreeBuilderCount ; used for test cases
				$g_iTotalBuilderCount = Int($aGetBuilders[1])
				If $g_bDebugSetlog And Not $bSuppressLog Then SetLog("No. of Free/Total Builders: " & $g_iFreeBuilderCount & "/" & $g_iTotalBuilderCount, $COLOR_DEBUG)
			Else
				$g_iFreeBuilderCountBB = Int($aGetBuilders[0]) ; update global values
				$g_iTotalBuilderCountBB = Int($aGetBuilders[1])
				If $g_bDebugSetlog And Not $bSuppressLog Then SetLog("No. of Free/Total Builders: " & $g_iFreeBuilderCountBB & "/" & $g_iTotalBuilderCountBB, $COLOR_DEBUG)
			EndIf
			Return True ; Happy Monkey returns!
		Else
			SetLog("Bad OCR read Free/Total Builders", $COLOR_ERROR) ; OCR returned unusable value?
			; drop down to error handling code
		EndIf
	Else
		SetLog("Unable to read Builders info at this time", $COLOR_ERROR)
		; drop down to error handling code
	EndIf
	If $g_bDebugSetlog Or $g_bDebugImageSave Then SaveDebugImage("getBuilderCount_")
	If checkObstacles() Then checkMainScreen() ; trap common error messages
	Return False

EndFunc   ;==>getBuilderCount
