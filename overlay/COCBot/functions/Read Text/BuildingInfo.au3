; #FUNCTION# ====================================================================================================================
; Name ..........: BuildingInfo
; Description ...:
; Syntax ........: BuildingInfo($iXstart, $iYstart)
; Parameters ....: $iXstart             - an integer value.
;                  $iYstart             - an integer value.
; Return values .: None
; Author ........: KnowJack, Boldina!
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2020
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#Region - Custom fix - Team AIO Mod++
; NOTE: Support for multilangue, more smart, fix some cases like lvl 26 bug.
Func BuildingInfo($iXstart, $iYstart)

	Local $aResult[3] = ["", "", ""]
	Local $sBldgText

	$sBldgText = getNameBuilding($iXstart, $iYstart) ; Get Unit name and level with OCR
	If $sBldgText = "" Then ; try a 2nd time after a short delay if slow PC
		If _Sleep($DELAYBUILDINGINFO1) Then 
			Return $aResult
		EndIf
		$sBldgText = getNameBuilding($iXstart, $iYstart) ; Get Unit name and level with OCR
	EndIf
	
	If StringIsSpace($sBldgText) Then 
		Return $aResult
	EndIf
	
	$sBldgText = StringStripWS($sBldgText, 7) 
	$aResult[2] = OnlyNumbersInString($sBldgText)
	
	Local $sStr = StringSplit($sBldgText, "(")
	If Not @error Then
		$aResult[1] = String($sStr[1])
		$aResult[2] = ($aResult[2] = 0) ? ("Broken") : ($aResult[2])
	Else
		$aResult[1] = $sBldgText
		$aResult[2] = 0
		If StringInStr($sBldgText, "Cart") Then $aResult[2] = 100
		If StringInStr($sBldgText, "Tree") Then $aResult[2] = 99
		If StringInStr($sBldgText, "Mush") Then $aResult[2] = 98
		If StringInStr($sBldgText, "Trunk") Then $aResult[2] = 97
		If StringInStr($sBldgText, "Bush") Then $aResult[2] = 96
		If StringInStr($sBldgText, "Bark") Then $aResult[2] = 95
		If StringInStr($sBldgText, "Gem") Then $aResult[2] = 94
	EndIf
	
	$aResult[1] = String(StringStripWS($aResult[1], $STR_STRIPSPACES + $STR_STRIPTRAILING + $STR_STRIPLEADING))
	
	If $aResult[1] <> "" Then $aResult[0] = 1
	If $aResult[2] <> "" Then $aResult[0] += 1
	
	Return $aResult
EndFunc   ;==>BuildingInfo

Func OnlyNumbersInString($s)
	Local $sString = "", $sOne
	For $i = 0 To StringLen($s)
		$sOne = StringMid($s, $i, 1)
		If StringIsDigit($sOne) Then $sString &= $sOne
	Next
	Return Number($sString)
EndFunc
#EndRegion - Custom fix - Team AIO Mod++
