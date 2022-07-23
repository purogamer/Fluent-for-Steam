; #FUNCTION# ====================================================================================================================
; Name ..........: PetsSelect.au3
; Description ...: Trying a bit of objects to select the correct pet.
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Boldina
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2022
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once
Func PetsByPassed()
	If $g_iTownHallLevel <> 0 And $g_iTownHallLevel < 14 Then Return False
	If IsMainPage() Then
		
		SetDebugLog("Pet House Position: " & $g_aiPetHousePos[0] & ", " & $g_aiPetHousePos[1], $COLOR_DEBUG)
		
		If Not LocatePetHouse() Then
			SetLog("Failed to open Pet House Window!", $COLOR_ERROR)
			ClickAway()
			Return False
		EndIf
		
		If _Sleep(1500) Then Return     ; Wait for window to open
		
		If Not FindPetsButton() Then Return
		If _Sleep(1500) Then Return     ; Wait for window to open

		If Not IsPetHousePage() Then
			SetLog("Failed to open Pet House Window!", $COLOR_ERROR)
			ClickAway()
			Return False
		EndIf
		
		If $g_bPetHouseSelector = False Then Return True
		
		SelectHeroPets()
		If _Sleep(1500) Then Return     ; Wait for window to open
		
		Return True
	Else
		SetDebugLog("Pets error , is not at main page!")
		SaveDebugImage("Pets", True)
		ClickAway()
	EndIf
	ClickAway()
	Return False
EndFunc   ;==>PetsByPassed

Func SelectHeroPets()
	If $g_bPetHouseSelector = False Then Return

	SetDebugLog("SelectHeroPets")
	Local $aHeroNames = ["Any", "King", "Queen", "Warden", "Champion"]
	Local $aPetsNames = ["Lassi", "Electro Owl", "Mighty Yak", "Unicorn"]
	Local $aPetsHeroes = [$g_iCmbLassiPet, $g_iCmbElectroOwlPet, $g_iCmbMightyYakPet, $g_iCmbUnicornPet]
	
	Local $oPetsGUI = ObjCreate("Scripting.Dictionary")
	If @error Then
		SetLog("Error creating the dictionary object")
	EndIf
	
	For $o = 0 To UBound($aPetsHeroes) - 1
		$oPetsGUI($aPetsNames[$o]) = $aHeroNames[$aPetsHeroes[$o]]
	Next
	
	Local $aIMGHerosMain = _ImageSearchXML($g_sImgpetsHouseHeroes, 1000, "127, 420, 650, 474", True, False, True, 70)
	If IsArray($aIMGHerosMain) And UBound($aIMGHerosMain) < 5 Then

		Local $aIMGHeros = -1
		Local $aArea = [20, 280, 855, 360]
		Local $oPets = ObjCreate("Scripting.Dictionary")
		If @error Then
			SetLog("Error creating the dictionary object")
		EndIf
		
		_ArraySort($aIMGHerosMain, 0, 0, 0, 1)
		
		For $i = 0 To UBound($aIMGHerosMain) - 1
			$oPets($aPetsNames[$i]) = $aIMGHerosMain[$i][0]
		Next

		If _Sleep(1500) Then Return
		
		Local $oHerosDummy = ObjCreate("Scripting.Dictionary")
		If @error Then
			SetLog("Error creating the dictionary object")
		EndIf
		
		Local $bFound = False
		For $i = 1 To UBound($aHeroNames) - 1
			$bFound = False
			For $ss In $oPetsGUI.Items
				If $ss = $aHeroNames[$i] Then
					$bFound = True
				EndIf
			Next
			If $bFound = False Then $oHerosDummy($aHeroNames[$i]) = True
		Next
		
		; Learning what is present in ANY case.
		For $s In $oPetsGUI
			If $oPetsGUI($s) = "Any" Then
				For $sHero In $oHerosDummy
					If $oHerosDummy($sHero) = True Then
						If $oPets($s) = $sHero Then
							$oHerosDummy($sHero) = False
							$oPetsGUI($s) = $sHero
							ExitLoop
						EndIf
					EndIf
				Next
			EndIf
		Next
		
		; Fill test
		For $s In $oPetsGUI
			If $oPetsGUI($s) = "Any" Then
				For $sHero In $oHerosDummy
					If $oHerosDummy($sHero) = True Then
						$oHerosDummy($sHero) = False
						$oPetsGUI($s) = $sHero
						ExitLoop
					EndIf
				Next
			EndIf
		Next

		Local $iCount = -1
		Local $aIMGHeros = -1
		SetLog("Assigned heros to pets :", $COLOR_INFO)
		For $o In $oPets.Items
			$iCount += 1
			If $iCount > Int(UBound($aIMGHerosMain) - 1) Then ExitLoop
			
			SetLog("- " & $aPetsNames[$iCount] & " : " & $o, $COLOR_INFO)

			SetLog(" Must be : " & $oPetsGUI($aPetsNames[$iCount]), $COLOR_INFO)
			
			If String($oPetsGUI($aPetsNames[$iCount])) <> String($o) Then
				Click($aIMGHerosMain[$iCount][1], $aIMGHerosMain[$iCount][2])
				If _Sleep(1500) Then Return
				
				$aIMGHeros = _ImageSearchXML($g_sImgpetsHouseSelection, 1000, "20, 280, 855, 360", True, False, True, 30)
				If IsArray($aIMGHeros) Then
					For $iClick = 0 To UBound($aIMGHeros) - 1
						If $aIMGHeros[$iClick][0] = $oPetsGUI($aPetsNames[$iCount]) Then
							Click($aIMGHeros[$iClick][1], $aIMGHeros[$iClick][2])
							If _Sleep(1000) Then Return
							ExitLoop
						EndIf
					Next
				EndIf
			EndIf
		Next
		
	EndIf
	ClickAway()
EndFunc   ;==>SelectHeroPets
