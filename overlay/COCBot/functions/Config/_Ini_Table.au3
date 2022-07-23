; #FUNCTION# ====================================================================================================================
; Name ..........: _Ini_Table.au3
; Description ...: Maintains an in-memory array of all of MBR's ini settings, and provides _Ini_Save to write all settings in one
;				   FileOpen/FileClose batch
; Syntax ........: _Ini_Load($filename), _Ini_Save($filename), _Ini_Clear(), _Ini_Add($section, $key, $value),
;				   _Ini_Update($section, $key, $value), _Ini_Delete($section, $key)
; Parameters ....: $filename = full path to config.ini file
;				   $section = ini file section name
;				   $key and $value = ini file key name and value pair
; Return values .: NA
; Author ........: CodeSlinger69 (2017)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Global Const $g_iIniLinesMax = 20000 ; As of 2017-02-24, the number of active config.ini lines is 685
Global $g_asIniTable[$g_iIniLinesMax][2] ; section|key, value
Global $g_iIniLineCount = 0

Func _Ini_Load($filename)
	Local $hFile = FileOpen($filename, $FO_UTF16_LE)
	Local $sLine = FileReadLine($hFile)
	Local $sCurrentSection = "general"

	While @error = 0

		; Section break
		If StringLeft($sLine, 1) = "[" Then
			Local $asParts = StringSplit($sLine, "[]")
			If $asParts[0] <> 3 Then
				SetLog("Error parsing config.ini section line: " & $sLine & " (" & $asParts[0] & ")")
				Exit
			Else
				$sCurrentSection = $asParts[2]
				;SetDebugLog("New section: " & $sCurrentSection)
			EndIf

			; Key/value pair
		Else
			Local $asParts = StringSplit($sLine, "=")
			If $asParts[0] <> 2 Then
				SetLog("Error parsing config.ini key-value line: " & $sLine & " (" & $asParts[0] & ")")
				Exit
			Else
				_Ini_AddNewKeyValue($sCurrentSection, $asParts[1], $asParts[2])
			EndIf
		EndIf

		$sLine = FileReadLine($hFile)
	WEnd

	FileClose($hFile)
EndFunc   ;==>_Ini_Load

Func _Ini_Save($filename)
	ReDim $g_asIniTable[$g_iIniLineCount][3]
	_ArraySort($g_asIniTable) ; sort on section|key

	FileCopy($filename, $filename & ".bak", $FC_OVERWRITE)

	Local $hFile = FileOpen($filename, $FO_OVERWRITE + $FO_UTF16_LE)
	FileWriteLine($hFile, ";" & TimeDebug() & "MyBot.run configuration saved: " & $filename)
	Local $sCurrentSection = ""

	For $i = 0 To $g_iIniLineCount - 1

		Local $asParts = StringSplit($g_asIniTable[$i][0], "|")
		If $asParts[1] <> $sCurrentSection Then
			$sCurrentSection = $asParts[1]
			FileWriteLine($hFile, "[" & $sCurrentSection & "]")
			; Strategies File
			If $g_sProfileSecondaryOutputFileName <> "" Then
				If $sCurrentSection = "search" Or _
						$sCurrentSection = "attack" Or _
						$sCurrentSection = "SmartFarm" Or _
						$sCurrentSection = "MaxSidesSF" Or _
						$sCurrentSection = "MiscTab" Or _
						$sCurrentSection = "troop" Or _
						$sCurrentSection = "spells" Or _
						$sCurrentSection = "endbattle" Or _
						$sCurrentSection = "collectors" Or _
						$sCurrentSection = "DropOrder" Or _
						$sCurrentSection = "SmartZap" Or _
						$sCurrentSection = "planned" Then
					FileWriteLine($g_sProfileSecondaryOutputFileName, "[" & $sCurrentSection & "]")
				EndIf
			EndIf
		EndIf

		FileWriteLine($hFile, $asParts[2] & "=" & $g_asIniTable[$i][1])

		; Strategies File
		If $g_sProfileSecondaryOutputFileName <> "" Then
			If $sCurrentSection = "search" Or _
					$sCurrentSection = "attack" Or _
					$sCurrentSection = "SmartFarm" Or _
					$sCurrentSection = "MaxSidesSF" Or _
					$sCurrentSection = "MiscTab" Or _
					$sCurrentSection = "troop" Or _
					$sCurrentSection = "spells" Or _
					$sCurrentSection = "endbattle" Or _
					$sCurrentSection = "collectors" Or _
					$sCurrentSection = "DropOrder" Or _
					$sCurrentSection = "SmartZap" Or _
					$sCurrentSection = "planned" Then
				FileWriteLine($g_sProfileSecondaryOutputFileName, $asParts[2] & "=" & $g_asIniTable[$i][1])
			EndIf
		EndIf

	Next
	FileClose($hFile)

	; delete backup
	FileDelete($filename & ".bak")
EndFunc   ;==>_Ini_Save

Func _Ini_Clear()
	$g_asIniTable = 0
	Local $asNewIniTable[$g_iIniLinesMax][3]
	$g_asIniTable = $asNewIniTable
	$g_iIniLineCount = 0
	;SetDebugLog("Cleared Ini table")
EndFunc   ;==>_Ini_Clear

Func _Ini_Add($section, $key, $value)
	_Ini_AddNewKeyValue($section, $key, $value)
EndFunc   ;==>_Ini_Add

Func _Ini_Update($section, $key, $value)
	Local $iIndex = _ArraySearch($g_asIniTable, $section & "|" & $key)

	If $iIndex = -1 Then
		_Ini_AddNewKeyValue($section, $key, $value)
	Else
		$g_asIniTable[$iIndex][1] = $value
	EndIf
EndFunc   ;==>_Ini_Update

Func _Ini_Delete($section, $key)
	Local $iIndex = _ArraySearch($g_asIniTable, $section & "|" & $key)
	If $iIndex <> -1 Then
		_ArrayDelete($g_asIniTable, $iIndex)
		$g_iIniLineCount -= 1
	EndIf
EndFunc   ;==>_Ini_Delete

Func _Ini_AddNewKeyValue($section, $key, $value)
	If UBound($g_asIniTable) < $g_iIniLineCount + 1 Or UBound($g_asIniTable, 2) < 2 Then
		SetDebugLog("_Ini_AddNewKeyValue: Incorrect Array size on section '" & $section & "' for key '" & $key & "' value '" & $value & "'")
		Return
	EndIf
	$g_asIniTable[$g_iIniLineCount][0] = $section & "|" & $key
	$g_asIniTable[$g_iIniLineCount][1] = $value
	;SetDebugLog("New key value pair: " & $g_iIniLineCount & " " & $g_asIniTable[$g_iIniLineCount][0] & "=" & $g_asIniTable[$g_iIniLineCount][1])
	$g_iIniLineCount += 1
EndFunc   ;==>_Ini_AddNewKeyValue

