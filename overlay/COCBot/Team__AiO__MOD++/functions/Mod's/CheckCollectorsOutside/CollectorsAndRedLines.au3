; FUNCTION ====================================================================================================================
; Name ..........: CollectorsAndRedLines
; Description ...:
; Syntax ........:
; Parameters ....:
; Return values .: True					More collectors outside than specified.
;				 : False				less collectors outside than specified.
; Author ........: Samkie (13 Jan 2017) & Team AiO MOD++ (2020/2021)
; Modified ......: Boldina !
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2016
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: None
; ===============================================================================================================================
Func CollectorsAndRedLines($bForceCapture = False)
	Local $bReturn = False

	Local Const $imilkfarmoffsetxstep = 35
	Local Const $imilkfarmoffsetystep = 26
	Local $iDiamondx = $imilkfarmoffsetxstep + ($imilkfarmoffsetxstep * $g_iCmbRedlineTiles)
	Local $iDiamondy = $imilkfarmoffsetystep + ($imilkfarmoffsetystep * $g_iCmbRedlineTiles)
	Local $iPixelDistance = Pixel_Distance(0, 0, $iDiamondx, $iDiamondy)

	If $g_bDBMeetCollectorOutside Or $g_bDBCollectorNearRedline Then
		Local $hTimer = TimerInit()
		Local $sText = ($g_bDBCollectorNearRedline And $g_bDBMeetCollectorOutside) ? ("Are collectors near redline ?") : ("Are collectors outside ?")
		If $bForceCapture = True Then _CaptureRegion2()

		Local $aAllCollectors = SmartFarmDetection("All", False, False)
		SetDebugLog("Located collectors in " & Round(TimerDiff($hTimer) / 1000, 2) & " seconds", $COLOR_ACTION)
		Local $iOut = 0
		Local $iLocated = UBound($aAllCollectors)
		If $iLocated > 0 And Not @error Then
			If $g_bDBCollectorNearRedline Then
				$iOut = AreCollectorsNearRedline($aAllCollectors)
			Else
				For $i = 0 To $iLocated - 1
					If ($aAllCollectors[$i][3] = "Out") Then $iOut += 1
				Next
			EndIf
			$bReturn = ($g_iDBMinCollectorOutsidePercent <= Round(Int(($iOut * 100) / $iLocated, 0)))
			SetLog($sText & " : " & $bReturn & " - Out: " & $iOut & " - Located: " & $iLocated, $COLOR_INFO)
		EndIf
	EndIf
	Return $bReturn
EndFunc   ;==>CollectorsAndRedLines

; FUNCTION ====================================================================================================================
; Name ..........: AreCollectorsNearRedline
; Description ...:
; Syntax ........:
; Parameters ....:
; Return values .: True					more collectors near redline
;				 : False				less collectors outside than specified
; Author ........: Samkie (7 FEB 2017)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: None
; ===============================================================================================================================

Func AreCollectorsNearRedline($aAllCollectors)
	; reset variables
	Local $iTotalCollectorNearRedline = 0

	ConvertInternalExternArea("CollectorsAndRedLines")
	_GetRedArea()

	Local $colNbr = UBound($aAllCollectors)

    Local Const $iMilkFarmOffsetX = 56
    Local Const $iMilkFarmOffsetY = 41
	Local Const $imilkfarmoffsetxstep = 35
	Local Const $imilkfarmoffsetystep = 26

	Local $arrCollectorsFlag[0]
	Local $aPixelCoord[2], $aPixelCoord2[2]
	If $colNbr > 0 Then
		ReDim $arrCollectorsFlag[$colNbr]
		Local $iMaxRedArea = UBound($g_aiPixelRedArea) - 1
		For $i = 0 To $iMaxRedArea
			$aPixelCoord = $g_aiPixelRedArea[$i]
			For $j = 0 To $colNbr - 1
				If $arrCollectorsFlag[$j] <> True Then
					$aPixelCoord2[0] = $aAllCollectors[$j][0]
					$aPixelCoord2[1] = $aAllCollectors[$j][1]
					; Setlog($aPixelCoord2[0] & " " & $aPixelCoord2[1] & " " & $aPixelCoord[0] & " " & $aPixelCoord[1])
					If Pixel_Distance($aPixelCoord2[0], $aPixelCoord2[1], $aPixelCoord[0], $aPixelCoord[1]) < (Pixel_Distance($iMilkFarmOffsetX, $iMilkFarmOffsetY, 0, 0) + (Pixel_Distance($imilkfarmoffsetxstep, $imilkfarmoffsetystep, 0, 0) * $g_iCmbRedlineTiles)) Then
						$arrCollectorsFlag[$j] = True
						$iTotalCollectorNearRedline += 1
					EndIf
				EndIf
			Next
			If $iTotalCollectorNearRedline >= $colNbr Then ExitLoop
		Next
	EndIf
	Return $iTotalCollectorNearRedline
EndFunc   ;==>AreCollectorsNearRedline
