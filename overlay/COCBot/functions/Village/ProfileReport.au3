; #FUNCTION# ====================================================================================================================
; Name ..........: ProfileReport
; Description ...: This function will report Attacks Won, Defenses Won, Troops Donated and Troops Received from Profile info page
; Syntax ........: ProfileReport()
; Parameters ....:
; Return values .: None
; Author ........: Sardo
; Modified ......: KnowJack (07-2015), Sardo (08-2015), CodeSlinger69 (01-2017), Fliegerfaust (09-2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once
Func ProfileReport()

	Local $iAttacksWon = 0, $iDefensesWon = 0

	Local $iCount
	ClickAway()
	If _Sleep($DELAYPROFILEREPORT1) Then Return

	SetLog("Profile Report", $COLOR_INFO)
	SetLog("Opening Profile page to read Attacks, Defenses, Donations and Recieved Troops", $COLOR_INFO)
	Click(30, 40, 1, 0, "#0222") ; Click Info Profile Button
	If _Sleep($DELAYPROFILEREPORT2) Then Return

	While Not _ColorCheck(_GetPixelColor(252, 69, True), Hex(0xF4F4F0, 6), 5) ; wait for Info Profile to open
		$iCount += 1
		If _Sleep($DELAYPROFILEREPORT1) Then Return
		If $iCount >= 25 Then ExitLoop
	WEnd
	If $iCount >= 25 Then SetDebugLog("Profile Page did not open after " & $iCount & " Loops", $COLOR_DEBUG)

   ; Check If exist 'Claim Reward' button , click and return to Top of the Profile Page
	Local $aSearchResult
	For $i = 0 to 1 ; Check twice,  because the button is animated
		$aSearchResult = decodeSingleCoord(findImage("CollectReward", $g_sImgCollectReward, GetDiamondFromRect("680,121,855,636"), 1, True)) ; Resolution changed
		If IsArray($aSearchResult) And UBound($aSearchResult) = 2 Then
			Click($aSearchResult[0], $aSearchResult[1])
			SetLog("Reward collected", $COLOR_SUCCESS)
			For $i = 0 To 9
				ClickDrag(421, 200 + $g_iMidOffsetYFixed, 421, 630 + $g_iBottomOffsetYFixed, 2000) ; Resolution changed
				If _Sleep(2000) Then Return ; 2000ms
				If _ColorCheck(_GetPixelColor($aCheckTopProfile[0], $aCheckTopProfile[1], True), Hex($aCheckTopProfile[2], 6), $aCheckTopProfile[3])= True _
				  And _ColorCheck(_GetPixelColor($aCheckTopProfile2[0], $aCheckTopProfile2[1], True), Hex($aCheckTopProfile2[2], 6), $aCheckTopProfile2[3]) = True Then ExitLoop
			Next
			ExitLoop ; ok task was done , lets exit from here|
		EndIf
		If _Sleep($DELAYPROFILEREPORT1) Then Return ; 500ms
	Next

	If _Sleep($DELAYPROFILEREPORT1) Then Return
	$iAttacksWon = ""

	If _ColorCheck(_GetPixelColor($aProfileReport[0], $aProfileReport[1], True), Hex($aProfileReport[2], 6), $aProfileReport[3]) Then
		SetDebugLog("Profile seems to be currently unranked", $COLOR_DEBUG)
		$iAttacksWon = 0
		$iDefensesWon = 0
	Else
		$iAttacksWon = getProfile(564, 403)
		SetDebugLog("$iAttacksWon: " & $iAttacksWon, $COLOR_DEBUG)
		$iCount = 0
		While $iAttacksWon = "" ; Wait for $attacksWon to be readable in case of slow PC
			If _Sleep($DELAYPROFILEREPORT1) Then Return
			$iAttacksWon = getProfile(564, 403)
			SetDebugLog("Read Loop $iAttacksWon: " & $iAttacksWon & ", Count: " & $iCount, $COLOR_DEBUG)
			$iCount += 1
			If $iCount >= 20 Then ExitLoop
		WEnd
		If $g_bDebugSetlog And $iCount >= 20 Then SetLog("Excess wait time for reading $AttacksWon: " & getProfile(564, 403), $COLOR_DEBUG)
		$iDefensesWon = getProfile(795, 403)
	EndIf
	$g_iTroopsDonated = getProfile(160, 403)
	$g_iTroopsReceived = getProfile(362, 403)

	SetLog(" [ATKW]: " & _NumberFormat($iAttacksWon) & " [DEFW]: " & _NumberFormat($iDefensesWon) & " [TDON]: " & _NumberFormat($g_iTroopsDonated) & " [TREC]: " & _NumberFormat($g_iTroopsReceived), $COLOR_SUCCESS)
	Click(830, 80, 1, 0, "#0223") ; Close Profile page
	If _Sleep($DELAYPROFILEREPORT3) Then Return

	$iCount = 0
	While Not _CheckPixel($aIsMain, $g_bCapturePixel) ; wait for profile report window very slow close
		If _Sleep($DELAYPROFILEREPORT3) Then Return
		$iCount += 1
		If $iCount > 50 Then
			SetDebugLog("Main Window did not appear after " & $iCount & " Loops", $COLOR_DEBUG)
			ExitLoop
		EndIf
	WEnd

EndFunc   ;==>ProfileReport
