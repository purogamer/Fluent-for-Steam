; #FUNCTION# ====================================================================================================================
; Name ..........: ParseAttackCSV_Read_SIDE_variables
; Description ...:
; Syntax ........: ParseAttackCSV_Read_SIDE_variables()
; Parameters ....:
; Return values .: None
; Author ........: Sardo (2016), Boldina (09 July, 2022)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func ParseAttackCSV_Read_SIDE_variables()

	$g_bCSVLocateMine = False
	$g_bCSVLocateElixir = False
	$g_bCSVLocateDrill = False
	$g_bCSVLocateStorageGold = False
	$g_bCSVLocateStorageElixir = False
	$g_bCSVLocateStorageDarkElixir = False
	$g_bCSVLocateStorageTownHall = False
	$g_bCSVLocateEagle = False
	$g_bCSVLocateScatter = False
	$g_bCSVLocateInferno = False
	$g_bCSVLocateXBow = False
	$g_bCSVLocateWizTower = False
	$g_bCSVLocateMortar = False
	$g_bCSVLocateAirDefense = False
	$g_bCSVLocateWall = False
	$g_bCSVLocateClanCastle = False ; Custom CSV - Team AIO Mod++

	Local $sFilename = ""
	If $g_iMatchMode = $DB Then
		$sFilename = $g_sAttackScrScriptName[$DB]
	Else
		$sFilename = $g_sAttackScrScriptName[$LB]
	EndIf

	Local $f, $line, $acommand, $command
	Local $value1, $value2, $value3, $value4, $value5, $value6, $value7, $value8, $value9
	Local $bForceSideExist = False

	If FileExists($g_sCSVAttacksPath & "\" & $sFilename & ".csv") Then
		Local $aLines = FileReadToArray($g_sCSVAttacksPath & "\" & $sFilename & ".csv")
		If @error Then
			SetLog("Attack CSV script not found: " & $g_sCSVAttacksPath & "\" & $sFilename & ".csv", $COLOR_ERROR)
			Return
		EndIf
		For $iLine = 0 To UBound($aLines) - 1
			$line = $aLines[$iLine]
			$acommand = StringSplit($line, "|")
			If $acommand[0] >= 8 Then
				$command = StringStripWS(StringUpper($acommand[1]), $STR_STRIPTRAILING)

				If $command <> "SIDE" And $command <> "SIDEB" And $command <> "MAKE" Then ContinueLoop

				$value1 = StringStripWS(StringUpper($acommand[2]), $STR_STRIPTRAILING)
				$value2 = StringStripWS(StringUpper($acommand[3]), $STR_STRIPTRAILING)
				$value3 = StringStripWS(StringUpper($acommand[4]), $STR_STRIPTRAILING)
				$value4 = StringStripWS(StringUpper($acommand[5]), $STR_STRIPTRAILING)
				$value5 = StringStripWS(StringUpper($acommand[6]), $STR_STRIPTRAILING)
				$value6 = StringStripWS(StringUpper($acommand[7]), $STR_STRIPTRAILING)
				$value7 = StringStripWS(StringUpper($acommand[8]), $STR_STRIPTRAILING)
				$value8 = StringStripWS(StringUpper($acommand[9]), $STR_STRIPTRAILING)
				$value9 = StringStripWS(StringUpper($acommand[10]), $STR_STRIPTRAILING)

				If $command = "SIDE" And StringUpper($value8) = "TOP-LEFT" Or StringUpper($value8) = "TOP-RIGHT" Or StringUpper($value8) = "BOTTOM-LEFT" Or StringUpper($value8) = "BOTTOM-RIGHT" Then
					$bForceSideExist = True ;keep original values
				EndIf

				Switch $command
					Case "SIDE" ;if this line uses a building, then it must be detected
						If $bForceSideExist = False Then
							If Int($value1) > 0 Then $g_bCSVLocateMine = True
							If Int($value2) > 0 Then $g_bCSVLocateElixir = True
							If Int($value3) > 0 Then $g_bCSVLocateDrill = True
							If Int($value4) > 0 Then $g_bCSVLocateStorageGold = True
							If Int($value5) > 0 Then $g_bCSVLocateStorageElixir = True
							If Int($value6) > 0 Then $g_bCSVLocateStorageDarkElixir = True
							If Int($value7) > 0 Then $g_bCSVLocateStorageTownHall = True
							; $value8 = Forced Side value
						EndIf
					Case "SIDEB"
						If $bForceSideExist = False Then
							If Int($value1) > 0 Then $g_bCSVLocateEagle = True
							If Int($value2) > 0 Then $g_bCSVLocateInferno = True
							If Int($value3) > 0 Then $g_bCSVLocateXBow = True
							If Int($value4) > 0 Then $g_bCSVLocateWizTower = True
							If Int($value5) > 0 Then $g_bCSVLocateMortar = True
							If Int($value6) > 0 Then $g_bCSVLocateAirDefense = True
							If Int($value7) > 0 Then $g_bCSVLocateScatter = True
							; If Int($value8) > 0 Then $g_bCSVLocateGemBox = True IE unused
						EndIf
					Case "MAKE" ; check if targeted building vectors are used im MAKE commands >> starting in V7.2+
						If StringLen(StringStripWS($value8, $STR_STRIPALL)) > 0 Then ; check for empty string?
							Switch $value8
								Case "TOWNHALL"
									$g_bCSVLocateStorageTownHall = True
								Case "EAGLE"
									$g_bCSVLocateEagle = True
								Case "INFERNO"
									$g_bCSVLocateInferno = True
								Case "XBOW"
									$g_bCSVLocateXBow = True
								Case "SCATTER", "SCATTERSHOT"
									$g_bCSVLocateScatter = True
								Case "WIZTOWER"
									$g_bCSVLocateWizTower = True
								Case "MORTAR"
									$g_bCSVLocateMortar = True
								Case "AIRDEFENSE"
									$g_bCSVLocateAirDefense = True
								Case "EX-WALL"
									$g_bCSVLocateWall = True
								Case "IN-WALL"
									$g_bCSVLocateWall = True
								Case "CLANCASTLE"
									$g_bCSVLocateClanCastle = True
								Case Else
									SetDebugLog("Invalid MAKE building target name: " & $value8, $COLOR_WARNING)
									debugAttackCSV("Invalid MAKE building target name: " & $value8)
							EndSwitch
							debugAttackCSV("SIDE Parse MAKE target building= " & $value8)
						EndIf
				EndSwitch
			EndIf
		Next
	Else
		SetLog("Cannot find attack file " & $g_sCSVAttacksPath & "\" & $sFilename & ".csv", $COLOR_ERROR)
	EndIf
EndFunc   ;==>ParseAttackCSV_Read_SIDE_variables
