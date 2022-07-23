; #FUNCTION# ====================================================================================================================
; Name ..........: LocatePetHouse
; Description ...:
; Syntax ........: LocatePetHouse()
; Parameters ....:
; Return values .: None
; Author ........: KnowJack (June 2015)
; Modified ......: Sardo 2015-08 GrumpyHog 2021-04
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2021
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func LocatePetH($bCollect = True)
	; reset position
	$g_aiPetHousePos[0] = -1
	$g_aiPetHousePos[1] = -1

	If $g_iTownHallLevel < 14 Then
		SetLog("Townhall Lvl " & $g_iTownHallLevel & " has no Pet House, so skip locating.", $COLOR_DEBUG)
		Return
	EndIf

	ZoomOut()
	checkMainScreen()
	If $bCollect Then Collect(False)

	If Not LocatePetHouse() Then
		If Not _LocatePetHouse() Then Return False
	EndIf

	SaveConfig()

	Return True
EndFunc

Func _LocatePetHouse()
	Local $stext, $MsgBox, $iStupid = 0, $iSilly = 0, $sErrorText = ""

	SetLog("Locating Pet House", $COLOR_INFO)

	WinGetAndroidHandle()

	While 1
		_ExtMsgBoxSet(1 + 64, $SS_CENTER, 0x004080, 0xFFFF00, 12, "Comic Sans MS", 600)
		$stext = $sErrorText & @CRLF & GetTranslatedFileIni("MBR Popups", "Func_Locate_PetHouse_01", "Click OK then click on your Pet House") & @CRLF & @CRLF & _
				GetTranslatedFileIni("MBR Popups", "Locate_building_01", -1) & @CRLF & @CRLF & GetTranslatedFileIni("MBR Popups", "Locate_building_02", -1) & @CRLF
		$MsgBox = _ExtMsgBox(0, GetTranslatedFileIni("MBR Popups", "Ok_Cancel", "Ok|Cancel"), GetTranslatedFileIni("MBR Popups", "Func_Locate_PetHouse_02", "Locate PetHouse"), $stext, 15)
		If $MsgBox = 1 Then
			WinGetAndroidHandle()
			ClickAway()
			Local $aPos = FindPos()
			$g_aiPetHousePos[0] = Int($aPos[0])
			$g_aiPetHousePos[1] = Int($aPos[1])
			PercentToVillage($aPos[0], $aPos[1])
			If isInsideDiamond($aPos) = False Then
				$iStupid += 1
				Select
					Case $iStupid = 1
						$sErrorText = "Pet House Location Not Valid!" & @CRLF
						SetLog("Location not valid, try again", $COLOR_ERROR)
						ContinueLoop
					Case $iStupid = 2
						$sErrorText = "Please try to click inside the grass field!" & @CRLF
						ContinueLoop
					Case $iStupid = 3
						$sErrorText = "This is not funny, Please stop!" & @CRLF & @CRLF
						ContinueLoop
					Case $iStupid = 4
						$sErrorText = "Last Chance, DO NOT MAKE ME ANGRY, or" & @CRLF & "I will give ALL of your gold to Barbarian King," & @CRLF & "And ALL of your Gems to the Archer Queen!" & @CRLF
						ContinueLoop
					Case $iStupid > 4
						SetLog(" Operator Error - Bad Pet House Location.", $COLOR_ERROR)
						ClickAway()
						Return False
				EndSelect
			EndIf
		Else
			SetLog("Locate Pet House Cancelled", $COLOR_INFO)
			ClickAway()
			Return
		EndIf
		Local $sPetHouseInfo = BuildingInfo(245, 490 + $g_iBottomOffsetY); 860x780
		If $sPetHouseInfo[0] > 1 Or $sPetHouseInfo[0] = "" Then
			If StringInStr($sPetHouseInfo[1], "House") = 0 Then
				Local $sLocMsg = ($sPetHouseInfo[0] = "" ? "Nothing" : $sPetHouseInfo[1])

			    $iSilly += 1
				Select
					Case $iSilly = 1
						$sErrorText = "Wait, That is not the Pet House?, It was a " & $sLocMsg & @CRLF
						ContinueLoop
					Case $iSilly = 2
						$sErrorText = "Quit joking, That was " & $sLocMsg & @CRLF
						ContinueLoop
					Case $iSilly = 3
						$sErrorText = "This is not funny, why did you click " & $sLocMsg & "? Please stop!" & @CRLF
						ContinueLoop
					Case $iSilly = 4
						$sErrorText = $sLocMsg & " ?!?!?!" & @CRLF & @CRLF & "Last Chance, DO NOT MAKE ME ANGRY, or" & @CRLF & "I will give ALL of your gold to Barbarian King," & @CRLF & "And ALL of your Gems to the Archer Queen!" & @CRLF
						ContinueLoop
					Case $iSilly > 4
						SetLog("Ok, you really think that's a Pet House?" & @CRLF & "I don't care anymore, go ahead with it!", $COLOR_ERROR)
						ClickAway()
						ExitLoop
				EndSelect
			EndIf
		Else
			SetLog(" Operator Error - Bad Pet House Location: " & "(" & $g_aiPetHousePos[0] & "," & $g_aiPetHousePos[1] & ")", $COLOR_ERROR)
			$g_aiPetHousePos[0] = -1
			$g_aiPetHousePos[1] = -1
			ClickAway()
			Return False
		EndIf
		SetLog("Locate Pet House Success: " & "(" & $g_aiPetHousePos[0] & "," & $g_aiPetHousePos[1] & ")", $COLOR_SUCCESS)
		ExitLoop
	WEnd
	ClickAway()

EndFunc   ;==>LocatePetHouse

; Image Search for Pet House
Func _ImgLocatePetHouse()
	Local $sImgDir = $g_sImgLocationPetHouse

	Local $sSearchArea = "FV"
	Local $avPetHouse = findMultiple($sImgDir, $sSearchArea, $sSearchArea, 0, 1000, 1, "objectname,objectpoints", True)

	If Not IsArray($avPetHouse) Or UBound($avPetHouse, $UBOUND_ROWS) <= 0 Then
		SetLog("Couldn't find Pet House on main village", $COLOR_ERROR)
		If $g_bDebugImageSave Then SaveDebugImage("PetHouse", False)
		Return False
	EndIf

	Local $avPetHouseRes, $aiPetHouseCoords

	; active/inactive Pet House have different images
	; loop thro the detected images
	For $i = 0 To UBound($avPetHouse, $UBOUND_ROWS) - 1
		$avPetHouseRes = $avPetHouse[$i]
		$aiPetHouseCoords = decodeSingleCoord($avPetHouseRes[1])
		If IsArray($aiPetHouseCoords) And UBound($aiPetHouseCoords, $UBOUND_ROWS) > 1 Then
			;$g_aiPetHousePos[0] = $aiPetHouseCoords[0]
			;$g_aiPetHousePos[1] = $aiPetHouseCoords[1]
			SetLog($avPetHouseRes[0] & " found at (" & $aiPetHouseCoords[0] & "," & $aiPetHouseCoords[1] & ")", $COLOR_DEBUG)
			Return $aiPetHouseCoords
		EndIf
	Next

	Return False
EndFunc

; based on LocateStarLab
Func LocatePetHouse()

	If $g_iTownHallLevel < 14 Then
		SetLog("Townhall Lvl " & $g_iTownHallLevel & " has no Pet House, so skip locating.", $COLOR_DEBUG)
		Return
	EndIf

	Local Static $aiLocateError[$g_eTotalAcc]=[0, 0, 0, 0, 0, 0, 0, 0]
	Local $sImgDir = $g_sImgLocationPetHouse

	If $g_aiPetHousePos[0] > 0 And $g_aiPetHousePos[1] > 0 Then
		BuildingClickP($g_aiPetHousePos, "#0197")
		If _Sleep($DELAYLABORATORY1) Then Return ; Wait for description to popup

		Local $aResult = BuildingInfo(245, 490 + $g_iBottomOffsetY) ; Get building name and level with OCR
		If $aResult[0] = 2 Then ; We found a valid building name
			If StringInStr($aResult[1], "House") = True Then ; we found the Pet House
				SetLog("Pet House located.", $COLOR_INFO)
				SetLog("It reads as Level " & $aResult[2] & ".", $COLOR_INFO)
				Return True
			Else
				ClickAway()
				SetDebugLog("Stored Pet House Position is not valid.", $COLOR_ERROR)
				SetDebugLog("Found instead: " & $aResult[1] & ", " & $aResult[2] & " !", $COLOR_DEBUG)
				SetDebugLog("Village position: " & $g_aiPetHousePos[0] & ", " & $g_aiPetHousePos[1], $COLOR_DEBUG, True)
				ConvertToVillagePos($g_aiPetHousePos[0],$g_aiPetHousePos[1])
				SetDebugLog("Real position: " & $g_aiPetHousePos[0] & ", " & $g_aiPetHousePos[1], $COLOR_DEBUG, True)
				;$$g_aiPetHousePos[0] = -1
				;$$g_aiPetHousePos[1] = -1
				$aiLocateError[$g_iCurAccount] += 1

				SetLog("Village[" & $g_iCurAccount & "] Pet House Locate Error: " & $aiLocateError[$g_iCurAccount], $COLOR_DEBUG)

				if $aiLocateError[$g_iCurAccount] > 5 Then
					$aiLocateError[$g_iCurAccount] = 0
					$g_aiPetHousePos[0] = -1
					$g_aiPetHousePos[1] = -1
				Else
					Return False
				Endif
			EndIf
		Else
			ClickAway()
			SetDebugLog("Stored Pet House Position is not valid.", $COLOR_ERROR)
			SetDebugLog("Village position: " & $g_aiPetHousePos[0] & ", " & $g_aiPetHousePos[1], $COLOR_DEBUG, True)
			ConvertToVillagePos($g_aiPetHousePos[0],$g_aiPetHousePos[1])
			SetDebugLog("Real position: " & $g_aiPetHousePos[0] & ", " & $g_aiPetHousePos[1], $COLOR_DEBUG, True)
			$g_aiPetHousePos[0] = -1
			$g_aiPetHousePos[1] = -1
		EndIf
	EndIf

	SetLog("Looking for Pet House...", $COLOR_ACTION)

	Local $sCocDiamond = "FV"
	Local $sRedLines = $sCocDiamond
	Local $iMinLevel = 0
	Local $iMaxLevel = 1000
	Local $iMaxReturnPoints = 1
	Local $sReturnProps = "objectname,objectpoints"
	Local $bForceCapture = True

	; DETECTION IMGLOC
	Local $aResult = findMultiple($sImgDir, $sCocDiamond, $sRedLines, $iMinLevel, $iMaxLevel, $iMaxReturnPoints, $sReturnProps, $bForceCapture)
	If IsArray($aResult) And UBound($aResult) > 0 Then ; we have an array with data of images found
		For $i = 0 To UBound($aResult) - 1
			If _Sleep(50) Then Return ; just in case on PAUSE
			If Not $g_bRunState Then Return ; Stop Button
			SetDebugLog(_ArrayToString($aResult[$i]))
			Local $aTEMP = $aResult[$i]
			Local $sObjectname = String($aTEMP[0])
			SetDebugLog("Image name: " & String($aTEMP[0]), $COLOR_INFO)
			Local $aObjectpoints = $aTEMP[1] ; number of  objects returned
			SetDebugLog("Object points: " & String($aTEMP[1]), $COLOR_INFO)
			If StringInStr($aObjectpoints, "|") Then
				$aObjectpoints = StringReplace($aObjectpoints, "||", "|")
				Local $sString = StringRight($aObjectpoints, 1)
				If $sString = "|" Then $aObjectpoints = StringTrimRight($aObjectpoints, 1)
				Local $tempObbjs = StringSplit($aObjectpoints, "|", $STR_NOCOUNT) ; several detected points
				For $j = 0 To UBound($tempObbjs) - 1
					; Test the coordinates
					Local $tempObbj = StringSplit($tempObbjs[$j], ",", $STR_NOCOUNT) ;  will be a string : 708,360
					If UBound($tempObbj) = 2 Then
						$g_aiPetHousePos[0] = Number($tempObbj[0]) ;+ 9
						$g_aiPetHousePos[1] = Number($tempObbj[1]) ;+ 15
						ConvertFromVillagePos($g_aiPetHousePos[0],$g_aiPetHousePos[1])
						ExitLoop 2
					EndIf
				Next
			Else
				; Test the coordinate
				Local $tempObbj = StringSplit($aObjectpoints, ",", $STR_NOCOUNT) ;  will be a string : 708,360
				If UBound($tempObbj) = 2 Then
					$g_aiPetHousePos[0] = Number($tempObbj[0]) ;+ 9
					$g_aiPetHousePos[1] = Number($tempObbj[1]) ;+ 15
					ConvertFromVillagePos($g_aiPetHousePos[0],$g_aiPetHousePos[1])
					ExitLoop
				EndIf
			EndIf
		Next
	EndIf

	If $g_aiPetHousePos[0] > 0 And $g_aiPetHousePos[1] > 0 Then
		BuildingClickP($g_aiPetHousePos, "#0197")
		If _Sleep($DELAYLABORATORY1) Then Return ; Wait for description to popup

		Local $aResult = BuildingInfo(245, 490 + $g_iBottomOffsetY) ; Get building name and level with OCR
		If $aResult[0] = 2 Then ; We found a valid building name
			If StringInStr($aResult[1], "House") = True Then ; we found the Pet House
				SetLog("Pet House located.", $COLOR_INFO)
				SetLog("It reads as Level " & $aResult[2] & ".", $COLOR_INFO)
				Return True
			Else
				ClickAway()
				SetDebugLog("Found Pet House Position is not valid.", $COLOR_ERROR)
				SetDebugLog("Found instead: " & $aResult[1] & ", " & $aResult[2] & " !", $COLOR_DEBUG)
				SetDebugLog("Village position: " & $g_aiPetHousePos[0] & ", " & $g_aiPetHousePos[1], $COLOR_DEBUG, True)
				ConvertToVillagePos($g_aiPetHousePos[0],$g_aiPetHousePos[1])
				SetDebugLog("Real position: " & $g_aiPetHousePos[0] & ", " & $g_aiPetHousePos[1], $COLOR_DEBUG, True)
				$g_aiPetHousePos[0] = -1
				$g_aiPetHousePos[1] = -1
			EndIf
		Else
			ClickAway()
			SetDebugLog("Found Pet House Position is not valid.", $COLOR_ERROR)
			SetDebugLog("Village position: " & $g_aiPetHousePos[0] & ", " & $g_aiPetHousePos[1], $COLOR_DEBUG, True)
			ConvertToVillagePos($g_aiPetHousePos[0],$g_aiPetHousePos[1])
			SetDebugLog("Real position: " & $g_aiPetHousePos[0] & ", " & $g_aiPetHousePos[1], $COLOR_DEBUG, True)
			$g_aiPetHousePos[0] = -1
			$g_aiPetHousePos[1] = -1
		EndIf
	EndIf

	SetLog("Can not find Pet House.", $COLOR_ERROR)
	Return False
EndFunc   ;==>imgLocatePetHouse()
