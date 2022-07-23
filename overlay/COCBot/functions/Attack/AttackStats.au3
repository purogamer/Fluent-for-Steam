; #FUNCTION# ====================================================================================================================
; Name ..........: AttackStats (V2)
; Description ...: This file contains the SQLite algorithm
; Syntax ........: ---
; Parameters ....: ---
; Return values .: ---
; Author ........: ProMac 01/2017
; Modified ......: ProMac 07/2018 [v2]
; Remarks .......: This file is part of MyBotRun. Copyright 2018
;                  MyBotRun is distributed under the terms of the GNU GPL
; Related .......: ---
; Link ..........: https://www.mybot.run
; Example .......: ---
;================================================================================================================================

#include <SQLite.au3>

Func OpenSqlite()
	If Not $g_bUseStatistics Then Return

	Local $sSQLite = _SQLite_Startup($g_sLibSQLitePath, False, 1)
	If @error Then
		MsgBox($MB_SYSTEMMODAL, "SQLite Error", "SQLite3.dll Can't be Loaded!", 10)
		Return False
	EndIf

	$g_hSQLiteDB = _SQLite_Open(@ScriptDir & "\AttackStats.sqlite3")
	If @error Then
		MsgBox($MB_SYSTEMMODAL, "SQLite DB", "Can't open or create a Database!", 10)
		Return False
	EndIf
	Return True
EndFunc   ;==>OpenSqlite

Func CloseSqlite()
	_SQLite_Close($g_hSQLiteDB)
	_SQLite_Shutdown()
EndFunc   ;==>CloseSqlite

Func CreaTableDB()

	If Not $g_bUseStatistics Then Return

	If OpenSqlite() Then

		Local $sTableCreation = "CREATE TABLE IF NOT EXISTS `" & $g_sTabletName & "` (`Attack` INTEGER PRIMARY KEY AUTOINCREMENT, " & _
				"'Date' TEXT NOT NULL, " & _
				"'Profilename' TEXT NOT NULL, " & _
				"'SearchCount' TEXT NOT NULL, " & _
				"'Attacksides' TEXT NOT NULL, " & _
				"'ResIN' TEXT NOT NULL, " & _
				"'ResOUT' TEXT NOT NULL, " & _
				"'ResBySide' TEXT NOT NULL, " & _
				"'OppThlevel' TEXT NOT NULL, " & _
				"'OppGold' TEXT NOT NULL, " & _
				"'OppElixir' TEXT NOT NULL, " & _
				"'OppDE' TEXT NOT NULL, " & _
				"'OppTrophies' TEXT NOT NULL, " & _
				"'PerDamage' TEXT NOT NULL, " & _
				"'PerResources' TEXT NOT NULL, " & _
				"'LootGold' TEXT NOT NULL, " & _
				"'LootElixir' TEXT NOT NULL, " & _
				"'LootDE' TEXT NOT NULL, " & _
				"'League' TEXT NOT NULL, " & _
				"'BonusGold' TEXT NOT NULL, " & _
				"'BonusElixir' TEXT NOT NULL, " & _
				"'BonusDE' TEXT NOT NULL)"

		_SQLite_Exec($g_hSQLiteDB, $sTableCreation)
	Else
		Return
	EndIf
	CloseSqlite()
EndFunc   ;==>CreaTableDB

Func UpdateSDataBase()

	If Not $g_bUseStatistics Then Return

	If OpenSqlite() Then
		UpdateVarStats()
		Local $sInsereRow = "INSERT INTO " & $g_sTabletName & _
				" (Date,Profilename,SearchCount,Attacksides,ResIN,ResOUT,ResBySide,OppThlevel,OppGold,OppElixir,OppDE,OppTrophies,PerDamage,PerResources,LootGold,LootElixir,LootDE,League,BonusGold,BonusElixir,BonusDE)" & _
				" VALUES ('" & $g_sDate & "','" & $g_sProfilename & "','" & $g_sSearchCount & "','" & $g_sAttacksides & "','" & $g_sResourcesIN & "','" & $g_sResourcesOUT & "','" & $g_sResBySide & _
				"','" & $g_sOppThlevel & "','" & $g_sOppGold & "','" & $g_sOppElixir & "','" & $g_sOppDE & "','" & $g_sOppTrophies & "','" & $g_sTotalDamage & "','" & $g_sPercentagesResources & _
				"','" & $g_sLootGold & "','" & $g_sLootElixir & "','" & $g_sLootDE & "','" & $g_sLeague & _
				"','" & $g_sBonusGold & "','" & $g_sBonusElixir & "','" & $g_sBonusDE & "');"


		_SQLite_Exec($g_hSQLiteDB, $sInsereRow)
	Else
		Return
	EndIf
	CloseSqlite()
EndFunc   ;==>UpdateSDataBase

Func ExportDataBase($bLog = True)

	If Not $g_bUseStatistics Then Return

	If OpenSqlite() Then
		Local $iColumns, $aResult, $iRows
		Local $StrinForm[22] = ["%6s", "%20s", "%12s", "%12s", "%12s", "%7s", "%7s", "%10s", "%11s", "%8s", "%11s", "%7s", "%12s", "%10s", "%13s", "%9s", "%11s", "%7s", "%7s", "%10s", "%12s", "%8s"]
		Local $filePath = @ScriptDir & "\SQLite_exportedData.csv"

		Local $iRval = _SQLite_GetTable2d($g_hSQLiteDB, "Select * From " & $g_sTabletName, $aResult, $iRows, $iColumns)

		If FileExists($filePath) Then FileDelete($filePath)

		ConsoleWrite("Rows: " & $iRows & " Columns: " & $iColumns & @CRLF)

		; Write the header file
		Local $header = "Attack;Date;Profilename;SearchCount;Attacksides;ResIN;ResOUT;ResBySide;OppThlevel;OppGold;OppElixir;OppDE;OppTrophies;PerDamage;PerResources;LootGold;LootElixir;LootDE;League;BonusGold;BonusElixir;BonusDE"
		local $aHeader = StringSplit($header , ";", $STR_NOCOUNT)
		$header = ""
		For $i = 0 to Ubound($header) - 1
			$header &= StringFormat($StrinForm[$i], $aHeader[$i]) & ";"
		Next
		StringTrimRight($header, 1)
		FileWriteLine($filePath, $header)

		For $iR = 0 To $iRows
			Local $sText = ""
			For $iC = 0 To $iColumns - 1
				$sText &= StringFormat($StrinForm[$iC], $aResult[$iR][$iC])& ";"
			Next
			; remove the last ;
			StringTrimRight($sText, 1)
			FileWriteLine($filePath, $sText)
			If $bLog Then ConsoleWrite($sText & @CRLF)
		Next
	Else
		Return
	EndIf
	CloseSqlite()
EndFunc   ;==>ExportDataBase

Func UpdateVarStats()

	$g_sDate = _Date_Time_GetLocalTime()
	$g_sDate = _Date_Time_SystemTimeToDateTimeStr($g_sDate)
	$g_sProfilename = $g_sProfileCurrentName = "" ? $g_asProfileName[$g_iNextAccount] : $g_sProfileCurrentName
	; $g_sSearchCount = "120"
	; $g_sAttacksides = "2"
	; $g_sResourcesIN = "3"
	; $g_sResourcesOUT = "12"
	; $g_sResBySide = "3|7|2|3"
	$g_sOppThlevel = "TH" & $g_iSearchTH
	; $g_sOppGold = "500000"
	; $g_sOppElixir = "500000"
	; $g_sOppDE = "1580"
	; $g_sOppTrophies = "28"
	$g_sTotalDamage = $g_sTotalDamage & "%"
	; $g_sLootGold = "450000"
	; $g_sLootElixir = "450000"
	; $g_sLootDE = "250"
	; $g_sLeague = "M1"
	; $g_sBonusGold = "55000"
	; $g_sBonusElixir = "55000"
	; $g_sBonusDE = "250"
	Local $totalresources = Int($g_sOppGold) + Int($g_sOppElixir) + Int($g_sOppDE)
	Local $totalgrab = Int($g_sLootGold) + Int($g_sLootElixir) + Int($g_sLootDE)
	$g_sPercentagesResources = StringFormat("%.2f", (($totalgrab / $totalresources) * 100)) & "%"
EndFunc   ;==>UpdateVarStats