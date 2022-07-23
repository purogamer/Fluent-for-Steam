; #FUNCTION# ====================================================================================================================
; Name ..........: CheckImageType()
; Description ...: Detects what Image Type (Normal/Snow)Theme is on your village and sets the $g_iDetectedImageType used for deadbase and Townhall detection.
; Author ........: Hervidero (2015-12)
; Modified ......: CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......: Assign the Village Theme detected to $g_iDetectedImageType
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: CheckImageType ()
; ===============================================================================================================================
#include-once

Func CheckImageType()
	SetLog("Detecting your Village Theme", $COLOR_INFO)

	ClickAway()

	If _Sleep($DELAYCHECKIMAGETYPE1) Then Return
	If Not IsMainPage() Then ClickAway()

	Local $sImgSnowTheme = @ScriptDir & "\imgxml\SnowTheme\Snow*.xml"
	Local $aResult = decodeMultipleCoords(findImage("Snow", $sImgSnowTheme, $CocDiamondDCD, 0, True))

	If IsArray($aResult) And UBound($aResult) >= 5 Then
		$g_iDetectedImageType = 1 ;Snow Theme
		SetDebugLog("Found Snow Images " & UBound($aResult))
		SetLog("Snow Theme detected")
	Else
		$g_iDetectedImageType = 0 ; Normal Theme
		SetLog("Normal Theme detected")
	EndIf
EndFunc   ;==>CheckImageType
