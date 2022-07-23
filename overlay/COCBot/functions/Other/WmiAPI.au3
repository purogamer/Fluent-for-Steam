; #FUNCTION# ====================================================================================================================
; Name ..........: WmiQuery
; Description ...: Uses WMI to retrieve process information
; Syntax ........: WmiQuery($sQuery)
; Parameters ....: $sQuery : WMI query like "Select " & GetWmiSelectFields() & " from Win32_Process"
; Return values .: Array containing array of fields
; Author ........: cosote
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once
#include <Array.au3>

Global $g_oWMI = 0
; Global $g_WmiAPI_External = True ; True retrieves the process list by calling MyBot.run.Wmi.exe - Custom - Team AIO Mod++
Global Static $g_WmiFields = ["Handle", "ExecutablePath", "CommandLine"]

Func GetWmiSelectFields()
	Return _ArrayToString($g_WmiFields, ",")
EndFunc

Func GetWmiObject()
	; Win32_Process: https://msdn.microsoft.com/en-us/library/windows/desktop/aa394372(v=vs.85).aspx
	; https://msdn.microsoft.com/en-us/library/aa393866(v=vs.85).aspx
	If $g_oWMI = 0 Then $g_oWMI = ObjGet("winmgmts:{impersonationLevel=impersonate}!\\.\root\cimv2")
	If @error Or Not IsObj($g_oWMI) Then Return -1
	Return $g_oWMI
EndFunc   ;==>GetWmiObject

Func CloseWmiObject()
	$g_oWMI = 0
EndFunc   ;==>CloseWmiObject

Func WmiQuery($sQuery)
	#cs - Custom - Team AIO Mod++
	If $g_WmiAPI_External = True Then
		Local $sAppFile = @ScriptDir & "\MyBot.run.Wmi." & ((@Compiled) ? ("exe") : ("au3"))
		If FileExists($sAppFile) Then
			Local $process_killed
			Local $cmd = """" & $sAppFile & """"
			If @Compiled = 0 Then $cmd = """" & @AutoItExe & """ /AutoIt3ExecuteScript """ & $sAppFile & """"
			Local $s = LaunchConsole($cmd, """" & $sQuery & """", $process_killed)
			Return WmiOutputToArray($s)
		EndIf
		; fall back to internal WMI call
	EndIf
	#ce - Custom - Team AIO Mod++
	
	Local $aProcesses[0]
	SetDebugLog("WMI Query: " & $sQuery)
	Local $oObjc = GetWmiObject()
	If $oObjc = -1 Or @error Then  Return 0
	Local $oProcessColl = $oObjc.ExecQuery($sQuery, "WQL", 0x20 + 0x10)
	For $Process In $oProcessColl
		Local $aProcess[UBound($g_WmiFields)]
		For $i = 0 To UBound($g_WmiFields) - 1
			$aProcess[$i] = Execute("$Process." & $g_WmiFields[$i])
		Next
		ReDim $aProcesses[UBound($aProcesses) + 1]
		$aProcesses[UBound($aProcesses) - 1] = $aProcess
	Next
	Return $aProcesses
EndFunc

#cs - Custom - Team AIO Mod++
Func WmiOutputToArray(ByRef $s)

	Local $aProcesses[0]

	Local $sProcesses = StringBetween($s, "<Processes>", "</Processes>")
	If @error Then Return $aProcesses

	Local $iPos = 1
	;ConsoleWrite($sProcesses)
	While $iPos > 0
		Local $sProcess = StringBetween($sProcesses, "<Process>", "</Process>", $iPos)
		$iPos = @extended
		If $iPos > 0 Then
			Local $aProcess[UBound($g_WmiFields)]
			Local $iPos2 = 1
			For $i = 0 To UBound($g_WmiFields) - 1
				$aProcess[$i] = StringBetween($sProcess, "<" & $g_WmiFields[$i] & ">", "</" & $g_WmiFields[$i] & ">", $iPos2)
				$iPos2 = @extended
			Next
			ReDim $aProcesses[UBound($aProcesses) + 1]
			$aProcesses[UBound($aProcesses) - 1] = $aProcess
		EndIf
	WEnd

	Return $aProcesses

EndFunc
#ce - Custom - Team AIO Mod++

Func StringBetween(ByRef $s, $sStartTag, $sEndTag, $iStartPos = 1)
    Local $iS = StringInStr($s, $sStartTag, 0, 1, $iStartPos)
    If $iS > 0 Then
		$iS += StringLen($sStartTag)
        Local $iE = StringInStr($s, $sEndTag, 0, 1, $iS)
        If $iE > 0 Then
			Return SetError(0, $iE + StringLen($sEndTag), StringMid($s, $iS, $iE - $iS))
        EndIf
    EndIf
	Return SetError(1, 0, "")
EndFunc
