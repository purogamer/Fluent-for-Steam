
; #FUNCTION# ====================================================================================================================
; Name ..........: LocateClanCastle
; Description ...: Locates Clan Castle manually (Temporary)
; Syntax ........: LocateClanCastle()
; Parameters ....:
; Return values .: None
; Author ........:
; Modified ......: KnowJack (06/2015) Sardo (08/2015) Grumpy (01/2022)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func LocateCastle($bCollect=True)
	; reset position
	$g_aiClanCastlePos[0] = -1
	$g_aiClanCastlePos[1] = -1
	
	ZoomOut()
	checkMainScreen()
	If $bCollect Then Collect(False)

	If Not LocateClanCastle() Then 
		If Not _LocateClanCastle() Then Return False
	EndIf

	SaveConfig()
	
	Return True
EndFunc


Func _LocateClanCastle($bCollect = True)
	Local $stext, $MsgBox, $iSilly = 0, $iStupid = 0, $sErrorText = "", $sInfo

	SetLog("Locating Clan Castle manually", $COLOR_INFO)

	WinGetAndroidHandle()
	;checkMainScreen()
	;If $bCollect Then Collect(False)

	While 1
		_ExtMsgBoxSet(1 + 64, $SS_CENTER, 0x004080, 0xFFFF00, 12, "Comic Sans MS", 500)
		$stext = $sErrorText & @CRLF & GetTranslatedFileIni("MBR Popups", "Func_Locate_Clan_Castle_01", "Click OK then click on your Clan Castle") & @CRLF & @CRLF & _
				GetTranslatedFileIni("MBR Popups", "Locate_building_01", "Do not move mouse quickly after clicking location") & @CRLF & @CRLF & GetTranslatedFileIni("MBR Popups", "Locate_building_02", "Make sure the building name is visible for me!") & @CRLF
		$MsgBox = _ExtMsgBox(0, GetTranslatedFileIni("MBR Popups", "Ok_Cancel", "Ok|Cancel"), GetTranslatedFileIni("MBR Popups", "Func_Locate_Clan_Castle_02", "Locate Clan Castle"), $stext, 15)
		If $MsgBox = 1 Then
			WinGetAndroidHandle()
			ClickAway()
			Local $aPos = FindPos()
			$g_aiClanCastlePos[0] = $aPos[0]
			$g_aiClanCastlePos[1] = $aPos[1]
			PercentToVillage($aPos[0], $aPos[1])
			If isInsideDiamond($aPos) = False Then
				$iStupid += 1
				Select
					Case $iStupid = 1
						$sErrorText = "Clan Castle Location Not Valid!" & @CRLF
						SetLog("Location not valid, try again", $COLOR_ERROR)
						ContinueLoop
					Case $iStupid = 2
						$sErrorText = "Please try to click inside the grass field!" & @CRLF
						ContinueLoop
					Case $iStupid = 3
						$sErrorText = "This is not funny, why did you click @ (" & $g_aiClanCastlePos[0] & "," & $g_aiClanCastlePos[1] & ")?" & @CRLF & "  Please stop!" & @CRLF & @CRLF
						ContinueLoop
					Case $iStupid = 4
						$sErrorText = "Last Chance, DO NOT MAKE ME ANGRY, or" & @CRLF & "I will give ALL of your gold to Barbarian King," & @CRLF & "And ALL of your Gems to the Archer Queen!" & @CRLF
						ContinueLoop
					Case $iStupid > 4
						SetLog(" Operator Error - Bad Clan Castle Location: " & "(" & $g_aiClanCastlePos[0] & "," & $g_aiClanCastlePos[1] & ")", $COLOR_ERROR)
						ClickAway()
						Return False
					Case Else
						SetLog(" Operator Error - Bad Clan Castle Location: " & "(" & $g_aiClanCastlePos[0] & "," & $g_aiClanCastlePos[1] & ")", $COLOR_ERROR)
						$g_aiClanCastlePos[0] = -1
						$g_aiClanCastlePos[1] = -1
						ClickAway()
						Return False
				EndSelect
			EndIf
			SetLog("Clan Castle: " & "(" & $g_aiClanCastlePos[0] & "," & $g_aiClanCastlePos[1] & ")", $COLOR_SUCCESS)
		Else
			SetLog("Locate Clan Castle Cancelled", $COLOR_INFO)
			ClickAway()
			Return
		EndIf
		$sInfo = BuildingInfo(245, 490 + $g_iBottomOffsetY) ; 860x780
		If IsArray($sInfo) and ($sInfo[0] > 1 Or $sInfo[0] = "") Then
			If StringInStr($sInfo[1], "Clan") = 0 Then
				Local $sLocMsg = ($sInfo[0] = "" ? "Nothing" : $sInfo[1])

			    $iSilly += 1
				Select
					Case $iSilly = 1
						$sErrorText = "Wait, That is not the Clan Castle?, It was a " & $sLocMsg & @CRLF
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
						SetLog("Quit joking, Click the Clan Castle, or restart bot and try again", $COLOR_ERROR)
						$g_aiClanCastlePos[0] = -1
						$g_aiClanCastlePos[1] = -1
						ClickAway()
						Return False
				EndSelect
			EndIf
			If $sInfo[2] = "Broken" Then
				SetLog("You did not rebuild your Clan Castle yet", $COLOR_ACTION)
			Else
				SetLog("Your Clan Castle is at level: " & $sInfo[2], $COLOR_SUCCESS)
			EndIf
		Else
			SetLog(" Operator Error - Bad Clan Castle Location: " & "(" & $g_aiClanCastlePos[0] & "," & $g_aiClanCastlePos[1] & ")", $COLOR_ERROR)
			$g_aiClanCastlePos[0] = -1
			$g_aiClanCastlePos[1] = -1
			ClickAway()
			Return False
		EndIf
		ExitLoop
	WEnd

	ClickAway()
EndFunc   ;==>LocateClanCastle

; based on LocateStarLab
Func LocateClanCastle()
	Local Static $aiLocateError[$g_eTotalAcc]=[0, 0, 0, 0, 0, 0, 0, 0] 
	Local $sImgDir = $g_sImgLocationCastle

	If $g_aiClanCastlePos[0] > 0 And $g_aiClanCastlePos[1] > 0 Then
		BuildingClickP($g_aiClanCastlePos, "#0197")
		If _Sleep($DELAYLABORATORY1) Then Return ; Wait for description to popup

		Local $aResult = BuildingInfo(245, 490 + $g_iBottomOffsetY) ; Get building name and level with OCR
		If $aResult[0] = 2 Then ; We found a valid building name
			If StringInStr($aResult[1], "Clan") = True Then ; we found the Clan Castle
				SetLog("Clan Castle located.", $COLOR_INFO)
				SetLog("It reads as Level " & $aResult[2] & ".", $COLOR_INFO)
				Return True
			Else
				ClickAway()
				SetDebugLog("Stored Clan Castle Position is not valid.", $COLOR_ERROR)
				SetDebugLog("Found instead: " & $aResult[1] & ", " & $aResult[2] & " !", $COLOR_DEBUG)
				SetDebugLog("Village position: " & $g_aiClanCastlePos[0] & ", " & $g_aiClanCastlePos[1], $COLOR_DEBUG, True)
				ConvertToVillagePos($g_aiClanCastlePos[0],$g_aiClanCastlePos[1])
				SetDebugLog("Real position: " & $g_aiClanCastlePos[0] & ", " & $g_aiClanCastlePos[1], $COLOR_DEBUG, True)
				;$$g_aiClanCastlePos[0] = -1
				;$$g_aiClanCastlePos[1] = -1
				$aiLocateError[$g_iCurAccount] += 1
				
				SetLog("Village[" & $g_iCurAccount & "] Clan Castle Locate Error: " & $aiLocateError[$g_iCurAccount], $COLOR_DEBUG)
				
				; if failed to locate building using saved coord more then 5x, reset as going to assume building has moved
				if $aiLocateError[$g_iCurAccount] > 5 Then
					$aiLocateError[$g_iCurAccount] = 0
					$g_aiClanCastlePos[0] = -1
					$g_aiClanCastlePos[1] = -1
				Else
					Return False
				Endif
			EndIf
		Else
			ClickAway()
			SetDebugLog("Stored Clan Castle Position is not valid.", $COLOR_ERROR)
			SetDebugLog("Village position: " & $g_aiClanCastlePos[0] & ", " & $g_aiClanCastlePos[1], $COLOR_DEBUG, True)
			ConvertToVillagePos($g_aiClanCastlePos[0],$g_aiClanCastlePos[1])
			SetDebugLog("Real position: " & $g_aiClanCastlePos[0] & ", " & $g_aiClanCastlePos[1], $COLOR_DEBUG, True)
			$g_aiClanCastlePos[0] = -1
			$g_aiClanCastlePos[1] = -1
		EndIf
	EndIf
		
	SetLog("Looking for Clan Castle...", $COLOR_ACTION)

	Local $sCocDiamond = "FV"
	Local $sRedLines = $sCocDiamond
	Local $iMinLevel = 0
	Local $iMaxLevel = 1000
	Local $iMaxReturnPoints = 1
	Local $sReturnProps = "objectname,objectpoints"
	Local $bForceCapture = True

	; DETECTION IMGLOC
	Local $aResult 
	For $j = 0 to 1
		; SetLog("ImgLoc CC loop :" & $j & " zoom factor :" & $g_aVillageSize[1])
		$aResult = findMultiple($sImgDir, $sCocDiamond, $sRedLines, $iMinLevel, $iMaxLevel, $iMaxReturnPoints, $sReturnProps, $bForceCapture)
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
							$g_aiClanCastlePos[0] = Number($tempObbj[0]) - 5
							$g_aiClanCastlePos[1] = Number($tempObbj[1]) - 8
							SetLog("Clan Castle :" & $g_aiClanCastlePos[0] & "," & $g_aiClanCastlePos[1])
							ConvertFromVillagePos($g_aiClanCastlePos[0],$g_aiClanCastlePos[1])
							SetLog("Clan Castle VillagePos:" & $g_aiClanCastlePos[0] & "," & $g_aiClanCastlePos[1])
							ExitLoop 3
						EndIf
					Next
				Else
					; Test the coordinate
					Local $tempObbj = StringSplit($aObjectpoints, ",", $STR_NOCOUNT) ;  will be a string : 708,360
					If UBound($tempObbj) = 2 Then
						$g_aiClanCastlePos[0] = Number($tempObbj[0]) - 5
						$g_aiClanCastlePos[1] = Number($tempObbj[1]) - 8
						SetLog("Clan Castle :" & $g_aiClanCastlePos[0] & "," & $g_aiClanCastlePos[1])
						ConvertFromVillagePos($g_aiClanCastlePos[0],$g_aiClanCastlePos[1])
						SetLog("Clan Castle VillagePos:" & $g_aiClanCastlePos[0] & "," & $g_aiClanCastlePos[1])
						ExitLoop 2
					EndIf
				EndIf
			Next
		EndIf
		
		If _Sleep(500) Then Return
	Next
	
	If $g_aiClanCastlePos[0] > 0 And $g_aiClanCastlePos[1] > 0 Then
		BuildingClickP($g_aiClanCastlePos, "#0197")
		If _Sleep($DELAYLABORATORY1) Then Return ; Wait for description to popup

		Local $aResult = BuildingInfo(245, 490 + $g_iBottomOffsetY) ; Get building name and level with OCR
		If $aResult[0] = 2 Then ; We found a valid building name
			If StringInStr($aResult[1], "Clan") = True Then ; we found the Clan Castle
				SetLog("Clan Castle located.", $COLOR_INFO)
				SetLog("It reads as Level " & $aResult[2] & ".", $COLOR_INFO)
				Return True
			Else
				ClickAway()
				SetDebugLog("Found Clan Castle Position is not valid.", $COLOR_ERROR)
				SetDebugLog("Found instead: " & $aResult[1] & ", " & $aResult[2] & " !", $COLOR_DEBUG)
				SetDebugLog("Village position: " & $g_aiClanCastlePos[0] & ", " & $g_aiClanCastlePos[1], $COLOR_DEBUG, True)
				ConvertToVillagePos($g_aiClanCastlePos[0],$g_aiClanCastlePos[1])
				SetDebugLog("Real position: " & $g_aiClanCastlePos[0] & ", " & $g_aiClanCastlePos[1], $COLOR_DEBUG, True)
				$g_aiClanCastlePos[0] = -1
				$g_aiClanCastlePos[1] = -1
			EndIf
		Else
			ClickAway()
			SetDebugLog("Found Clan Castle Position is not valid.", $COLOR_ERROR)
			SetDebugLog("Village position: " & $g_aiClanCastlePos[0] & ", " & $g_aiClanCastlePos[1], $COLOR_DEBUG, True)
			ConvertToVillagePos($g_aiClanCastlePos[0],$g_aiClanCastlePos[1])
			SetDebugLog("Real position: " & $g_aiClanCastlePos[0] & ", " & $g_aiClanCastlePos[1], $COLOR_DEBUG, True)
			$g_aiClanCastlePos[0] = -1
			$g_aiClanCastlePos[1] = -1
		EndIf
	EndIf

	SetLog("Can not find Clan Castle.", $COLOR_ERROR)
	Return False
EndFunc   ;==>LocateClanCastle()
