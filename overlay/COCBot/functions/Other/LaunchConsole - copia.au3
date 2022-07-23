; #FUNCTION# ====================================================================================================================
; Name ..........: LaunchConsole
; Description ...: Runs console application and returns output of STDIN and STDOUT
; Syntax ........:
; Parameters ....: $cmd, $param, ByRef $process_killed, $timeout = 0, $bUseSemaphore = False
; Return values .: None
; Author ........: Cosote (2015-12)
; Modified ......: Cosote (2016-08)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

#include-once
#include "Synchronization.au3"
#include "WmiAPI.au3"
#include <WinAPI.au3>
#include <WindowsConstants.au3>
#include <APISysConstants.au3>
#include <NamedPipes.au3>

Func LaunchConsole($cmd, $param, ByRef $process_killed, $timeout = 10000, $bUseSemaphore = False, $bNoLog = False)

	If $bUseSemaphore Then
		Local $hSemaphore = LockSemaphore(StringReplace($cmd, "\", "/"), "Waiting to launch: " & $cmd)
	EndIf

	Local $data, $pid, $hStdIn[2], $hStdOut[2], $hTimer, $hProcess, $hThread

	If StringLen($param) > 0 Then $cmd &= " " & $param

	$hTimer = __TimerInit()
	$process_killed = False

	If Not $bNoLog Then SetDebugLog("Func LaunchConsole: " & $cmd, $COLOR_DEBUG) ; Debug Run
	$pid = RunPipe($cmd, "", @SW_HIDE, $STDERR_MERGED, $hStdIn, $hStdOut, $hProcess, $hThread)
	If $pid = 0 Then
		SetLog("Launch failed: " & $cmd, $COLOR_ERROR)
		If $bUseSemaphore = True Then UnlockSemaphore($hSemaphore)
		Return SetError(1, 0, "")
	EndIf

	Local $timeout_sec = Round($timeout / 1000)
	Local $iWaitResult

	Do
		$iWaitResult = _WinAPI_WaitForSingleObject($hProcess, $DELAYSLEEP)
		$data &= ReadPipe($hStdOut[0])
	Until ($timeout > 0 And __TimerDiff($hTimer) > $timeout) Or $iWaitResult <> $WAIT_TIMEOUT

	If ProcessExists($pid) Then
		If ClosePipe($pid, $hStdIn, $hStdOut, $hProcess, $hThread) = 1 Then
			If Not $bNoLog Then SetDebugLog("Process killed: " & $cmd, $COLOR_ERROR)
			$process_killed = True
		EndIf
	Else
		ClosePipe($pid, $hStdIn, $hStdOut, $hProcess, $hThread)
	EndIf
	CleanLaunchOutput($data)

	If Not $bNoLog Then SetDebugLog("Func LaunchConsole Output: " & $data, $COLOR_DEBUG) ; Debug Run Output
	If $bUseSemaphore Then UnlockSemaphore($hSemaphore)
	Return SetError(0, 0, $data)
EndFunc   ;==>LaunchConsole

; Special version of ProcessExists that checks process based on full process image path AND parameters
; Supports also PID as $ProgramPath parameter
; $CompareMode = 0 Path with parameter is compared (" ", '"' and "'" removed!)
; $CompareMode = 1 Any Command Line containing path and parameter is used
; $SearchMode = 0 Search only for $ProgramPath
; $SearchMode = 1 Search for $ProgramPath and $ProgramParameter
; $CompareParameterFunc is func that returns True or False if parameter is matching, "" not used
Func ProcessExists2($ProgramPath, $ProgramParameter = Default, $CompareMode = Default, $SearchMode = 0, $CompareCommandLineFunc = "")

	If IsInt($ProgramPath) Then
		$ProgramPath = _WinAPI_GetProcessFileName($ProgramPath)
	EndIf

	If $ProgramParameter = Default Then
		$ProgramParameter = ""
		If $CompareMode = Default Then $CompareMode = 1
	EndIf

	If $CompareMode = Default Then
		$CompareMode = 0
	EndIf

	Local $commandLine = ($ProgramPath <> "" ? ('"' & $ProgramPath & '"' & ($ProgramParameter = "" ? "" : " " & $ProgramParameter)) : $ProgramParameter)
	Local $commandLineCompare = StringReplace(StringReplace(StringReplace(StringReplace($commandLine, ".exe", "", 1), " ", ""), '"', ""), "'", "")	
	Local $aArrayProcess[0], $Process[3]
	Local $aiProcessList = ProcessList()
	If @error Then Return 0
	
	Local $iUBound = 0, $iPid = 0
	For $iProcess = 1 To UBound($aiProcessList) - 1
		If IsInt($aiProcessList[$iProcess][1]) = 0 Then ContinueLoop
		$Process[0] = Int($aiProcessList[$iProcess][1])
		If $Process[0] = 0 Then ContinueLoop
		$Process[1] = _WinAPI_GetProcessFileName($Process[0])
		If $Process[1] = "" Then ContinueLoop
		
		If $Process[1] <> $ProgramPath Then ContinueLoop
		
		$Process[2] = '"' & $Process[1] & '" ' & _WinAPI_GetProcessCommandLine($Process[0])

		SetDebugLog($Process[0] & " = " & $Process[1] & " (" & $Process[2] & ")")
		
		Local $processCommandLineCompare = StringReplace(StringReplace(StringReplace(StringReplace($Process[2], ".exe", "", 1), " ", ""), '"', ""), "'", "")
		If ($CompareMode = 0 And $commandLineCompare = $processCommandLineCompare) Or _
				($CompareMode = 0 And StringRight($commandLineCompare, StringLen($processCommandLineCompare)) = $processCommandLineCompare) Or _
				($CompareMode = 0 And $CompareCommandLineFunc <> "" And Execute($CompareCommandLineFunc & "(""" & StringReplace($Process[2], """", "") & """)") = True) Or _
				$CompareMode = 1 Then
			
			$iPid = Number($Process[0])
			SetDebugLog("Found Process " & $iPid & " by CommandLine: " & $ProgramPath & ($ProgramParameter = "" ? "" : ($ProgramPath <> "" ? " " : "") & $ProgramParameter))
			Return $iPid
		EndIf
	Next
	
	SetDebugLog("Process by CommandLine not found: " & $ProgramPath & ($ProgramParameter = "" ? "" : ($ProgramPath <> "" ? " " : "") & $ProgramParameter))
	Return $iPid
EndFunc   ;==>ProcessExists2

#cs
; Special version of ProcessExists that checks process based on full process image path AND parameters
; Supports also PID as $ProgramPath parameter
; $CompareMode = 0 Path with parameter is compared (" ", '"' and "'" removed!)
; $CompareMode = 1 Any Command Line containing path and parameter is used
; $SearchMode = 0 Search only for $ProgramPath
; $SearchMode = 1 Search for $ProgramPath and $ProgramParameter
; $CompareParameterFunc is func that returns True or False if parameter is matching, "" not used
Func _ProcessExists2($ProgramPath, $ProgramParameter = Default, $CompareMode = Default, $SearchMode = 0, $CompareCommandLineFunc = "")

	If IsInt($ProgramPath) Then
		Return ProcessExists($ProgramPath)
	EndIf

	If $ProgramParameter = Default Then
		$ProgramParameter = ""
		If $CompareMode = Default Then $CompareMode = 1
	EndIf

	If $CompareMode = Default Then
		$CompareMode = 0
	EndIf

	Local $exe = $ProgramPath
	Local $iLastBS = StringInStr($exe, "\", 0, -1)
	If $iLastBS > 0 Then $exe = StringMid($exe, $iLastBS + 1)
	Local $commandLine = ($ProgramPath <> "" ? ('"' & $ProgramPath & '"' & ($ProgramParameter = "" ? "" : " " & $ProgramParameter)) : $ProgramParameter)
	Local $commandLineCompare = StringReplace(StringReplace(StringReplace(StringReplace($commandLine, ".exe", "", 1), " ", ""), '"', ""), "'", "")
	Local $query = "Select " & GetWmiSelectFields() & " from Win32_Process" ; replaced CommandLine with ExecutablePath
	If StringLen($commandLine) > 0 Then
		$query &= " where "
		If StringLen($ProgramPath) > 0 Then
			$query &= "ExecutablePath like '%" & StringReplace($ProgramPath, "\", "\\") & "%'"
			If $SearchMode = 1 And StringLen($ProgramParameter) > 0 Then $query &= " And "
		EndIf
		If $SearchMode = 1 And StringLen($ProgramParameter) > 0 Then $query &= "CommandLine like '%" & StringReplace($ProgramParameter, "\", "\\") & "%'"
	EndIf

	Local $pid = 0, $i = 0
	For $Process In WmiQuery($query)
		SetDebugLog($Process[0] & " = " & $Process[1] & " (" & $Process[2] & ")")
		If $pid = 0 Then
			Local $processCommandLineCompare = StringReplace(StringReplace(StringReplace(StringReplace($Process[2], ".exe", "", 1), " ", ""), '"', ""), "'", "")
			If ($CompareMode = 0 And $commandLineCompare = $processCommandLineCompare) Or _
					($CompareMode = 0 And StringRight($commandLineCompare, StringLen($processCommandLineCompare)) = $processCommandLineCompare) Or _
					($CompareMode = 0 And $CompareCommandLineFunc <> "" And Execute($CompareCommandLineFunc & "(""" & StringReplace($Process[2], """", "") & """)") = True) Or _
					$CompareMode = 1 Then
				$pid = Number($Process[0])
				;ExitLoop
			EndIf
		EndIf
		$i += 1
		$Process = 0
	Next
	If $pid = 0 Then
		SetDebugLog("Process by CommandLine not found: " & $ProgramPath & ($ProgramParameter = "" ? "" : ($ProgramPath <> "" ? " " : "") & $ProgramParameter))
	Else
		SetDebugLog("Found Process " & $pid & " by CommandLine: " & $ProgramPath & ($ProgramParameter = "" ? "" : ($ProgramPath <> "" ? " " : "") & $ProgramParameter))
	EndIf
	CloseWmiObject()
	Return $pid
EndFunc   ;==>ProcessExists2
#ce

; Special version of ProcessExists2 that returns Array of all processes found
Func ProcessesExist($ProgramPath, $ProgramParameter = Default, $CompareMode = Default, $SearchMode = Default, $CompareCommandLineFunc = Default, $bReturnDetailedArray = Default, $strComputer = ".")

	If $ProgramParameter = Default Then $ProgramParameter = ""
	If $CompareMode = Default Then $CompareMode = 0
	If $SearchMode = Default Then $SearchMode = 0
	If $CompareCommandLineFunc = Default Then $CompareCommandLineFunc = ""
	If $bReturnDetailedArray = Default Then $bReturnDetailedArray = False

	If IsNumber($ProgramPath) Then
		Local $a[1] = [ProcessExists($ProgramPath)] ; Be compatible with ProcessExists
		Return $a
	EndIf
	Local $exe = $ProgramPath
	Local $iLastBS = StringInStr($exe, "\", 0, -1)
	If $iLastBS > 0 Then $exe = StringMid($exe, $iLastBS + 1)
	Local $commandLine = ($ProgramPath <> "" ? ('"' & $ProgramPath & '"' & ($ProgramParameter = "" ? "" : " " & $ProgramParameter)) : $ProgramParameter)
	Local $commandLineCompare = StringReplace(StringReplace(StringReplace(StringReplace($commandLine, ".exe", "", 1), " ", ""), '"', ""), "'", "")
	Local $query = "Select " & GetWmiSelectFields() & " from Win32_Process" ; replaced CommandLine with ExecutablePath
	If StringLen($commandLine) > 0 Then
		$query &= " where "
		If StringLen($ProgramPath) > 0 Then
			$query &= "ExecutablePath like '%" & StringReplace($ProgramPath, "\", "\\") & "%'"
			If $SearchMode = 1 And StringLen($ProgramParameter) > 0 Then $query &= " And "
		EndIf
		If $SearchMode = 1 And StringLen($ProgramParameter) > 0 Then $query &= "CommandLine like '%" & StringReplace($ProgramParameter, "\", "\\") & "%'"
	EndIf
	Local $Process, $pid = 0, $i = 0
	Local $PIDs[0]

	For $Process In WmiQuery($query)
		SetDebugLog($Process[0] & " = " & $Process[2])
		Local $processCommandLineCompare = StringReplace(StringReplace(StringReplace(StringReplace($Process[2], ".exe", "", 1), " ", ""), '"', ""), "'", "")
		If ($CompareMode = 0 And $commandLineCompare = $processCommandLineCompare) Or _
				($CompareMode = 0 And StringRight($commandLineCompare, StringLen($processCommandLineCompare)) = $processCommandLineCompare) Or _
				($CompareMode = 0 And $CompareCommandLineFunc <> "" And Execute($CompareCommandLineFunc & "(""" & StringReplace($Process[2], """", "") & """)") = True) Or _
				$CompareMode = 1 Then

			$pid = Number($Process[0])
			ReDim $PIDs[$i + 1]
			Local $a = $pid
			If $bReturnDetailedArray Then
				Local $a = [$pid, $Process[1], $Process[2]]
			EndIf
			$PIDs[$i] = $a
			$i += 1

			$Process = 0
		EndIf
	Next
	If $i = 0 Then
		SetDebugLog("No process found by CommandLine: " & $ProgramPath & ($ProgramParameter = "" ? "" : " " & $ProgramParameter))
	Else
		SetDebugLog("Found " & $i & " process(es) with " & $ProgramPath & ($ProgramParameter = "" ? "" : " " & $ProgramParameter))
	EndIf
	CloseWmiObject()
	Return $PIDs
EndFunc   ;==>ProcessesExist

Func ProcessGetCommandLine($iPID, $VDEPRECATED = "", $bIncludePath = Default)
	Local $sDebugLog = ""
	If $bIncludePath = Default Then $bIncludePath = True
	$iPID = ProcessExists($iPID)
	If $iPID > 0 Then
		$sDebugLog = _WinAPI_GetProcessCommandLine($iPID)
		If @error Then Return SetError(1, 0, -1)
		If $bIncludePath = True And StringIsSpace($sDebugLog) = 0 Then
			$sDebugLog = '"' & _WinAPI_GetProcessFileName($iPID) & '" ' & $sDebugLog
		ElseIf StringIsSpace($sDebugLog) = 1 Then
			$sDebugLog = _WinAPI_GetProcessFileName($iPID)
		EndIf
		SetDebugLog("ProcessGetCommandLine: " & $sDebugLog)
		Return $sDebugLog
	EndIf	
	SetDebugLog("ProcessGetCommandLine: process not found")
	Return SetError(1, 0, -1)
EndFunc   ;==>ProcessGetCommandLine

; #CS
; Get complete Command Line by PID
Func _ProcessGetCommandLine($pid, $strComputer = ".")

	If Not IsNumber($pid) Then Return SetError(2, 0, -1)

	Local $commandLine
	Local $query = "Select " & GetWmiSelectFields() & " from Win32_Process where Handle = " & $pid
	Local $i = 0

	For $Process In WmiQuery($query)
		SetDebugLog($Process[0] & " = " & $Process[2])
		SetError(0, 0, 0)
		Local $sProcessCommandLine = $Process[2]
		$Process = 0
		CloseWmiObject()
		Return $sProcessCommandLine
	Next
	SetDebugLog("Process not found with PID " & $pid)
	$Process = 0
	CloseWmiObject()
	Return SetError(1, 0, -1)
EndFunc   ;==>ProcessGetCommandLine
; #CE

; Get Wmi Process Object for process
Func ProcessGetWmiProcess($pid, $strComputer = ".")

	If Not IsNumber($pid) Then Return SetError(2, 0, -1)

	Local $commandLine
	Local $query = "Select " & GetWmiSelectFields() & " from Win32_Process where Handle = " & $pid
	Local $i = 0

	For $Process In WmiQuery($query)
		SetDebugLog($Process[0] & " = " & $Process[2])
		SetError(0, 0, 0)
		CloseWmiObject()
		Return $Process
	Next
	SetDebugLog("Process not found with PID " & $pid)
	$Process = 0
	CloseWmiObject()
	Return SetError(1, 0, -1)
EndFunc   ;==>ProcessGetWmiProcess

Func CleanLaunchOutput(ByRef $output)
	$output = StringReplace($output, @LF & @LF, @LF, 0, 2)
	$output = StringReplace($output, @CR & @CR, @LF, 0, 2)
	$output = StringReplace($output, @CRLF & @CRLF, @LF, 0, 2)
	If StringRight($output, 1) = @LF Then $output = StringLeft($output, StringLen($output) - 1)
	If StringRight($output, 1) = @CR Then $output = StringLeft($output, StringLen($output) - 1)
EndFunc   ;==>CleanLaunchOutput

Func RunPipe($program, $workdir, $show_flag, $opt_flag, ByRef $hStdIn, ByRef $hStdOut, ByRef $hProcess, ByRef $hThread)

	If $g_bDepurateADB = True Then
		If StringInStr($program, "adb") Then 
			SetLog("DepurateADB : " & $program, $COLOR_INFO)
		EndIf
	EndIf

	If UBound($hStdIn) < 2 Then
		Local $a = [0, 0]
		$hStdIn = $a
	EndIf
	If UBound($hStdOut) < 2 Then
		Local $a = [0, 0]
		$hStdOut = $a
	EndIf

	Local $tSecurity = DllStructCreate($tagSECURITY_ATTRIBUTES)
	DllStructSetData($tSecurity, "Length", DllStructGetSize($tSecurity))
	DllStructSetData($tSecurity, "InheritHandle", True)
	_NamedPipes_CreatePipe($hStdIn[0], $hStdIn[1], $tSecurity)
	_WinAPI_SetHandleInformation($hStdIn[1], $HANDLE_FLAG_INHERIT, 0)
	_NamedPipes_CreatePipe($hStdOut[0], $hStdOut[1], $tSecurity)
	_WinAPI_SetHandleInformation($hStdOut[0], $HANDLE_FLAG_INHERIT, 0)

	Local $StartupInfo = DllStructCreate($tagSTARTUPINFO)
	DllStructSetData($StartupInfo, "Size", DllStructGetSize($StartupInfo))
	DllStructSetData($StartupInfo, "Flags", $STARTF_USESTDHANDLES + $STARTF_USESHOWWINDOW)
	DllStructSetData($StartupInfo, "StdInput", $hStdIn[0])
	DllStructSetData($StartupInfo, "StdOutput", $hStdOut[1])
	DllStructSetData($StartupInfo, "StdError", $hStdOut[1])
	DllStructSetData($StartupInfo, "ShowWindow", $show_flag)

	Local $lpStartupInfo = DllStructGetPtr($StartupInfo)
	Local $ProcessInformation = DllStructCreate($tagPROCESS_INFORMATION)
	Local $lpProcessInformation = DllStructGetPtr($ProcessInformation)

	If __WinAPI_CreateProcess("", $program, 0, 0, True, 0, 0, $workdir, $lpStartupInfo, $lpProcessInformation) Then
		Local $pid = DllStructGetData($ProcessInformation, "ProcessID")
		$hProcess = DllStructGetData($ProcessInformation, "hProcess")
		$hThread = DllStructGetData($ProcessInformation, "hThread")
		;_WinAPI_CloseHandle($hStdOut[1])
		Return SetError(0, 0, $pid)
	EndIf

	SetLog("Failed creating new process: " & $program, $COLOR_ERROR)
	; close handles
	ClosePipe(0, $hStdIn, $hStdOut, 0, 0)
	Return SetError(1, 0, 0)

EndFunc   ;==>RunPipe

Func ClosePipe($pid, $hStdIn, $hStdOut, $hProcess, $hThread)

	_WinAPI_CloseHandle($hStdIn[0])
	_WinAPI_CloseHandle($hStdIn[1])
	_WinAPI_CloseHandle($hStdOut[0])
	_WinAPI_CloseHandle($hStdOut[1])
	If $hProcess Then _WinAPI_CloseHandle($hProcess)
	If $hThread Then _WinAPI_CloseHandle($hThread)
	Return ProcessClose($pid)

EndFunc   ;==>ClosePipe

Func ReadPipe(ByRef $hPipe)
	If DataInPipe($hPipe) = 0 Then Return SetError(@error, @extended, "")
	Local $tBuffer = DllStructCreate("char Text[4096]")
	Local $iRead
	If _WinAPI_ReadFile($hPipe, DllStructGetPtr($tBuffer), 4096, $iRead) Then
		Return SetError(0, 0, DllStructGetData($tBuffer, "Text"))
	EndIf
	Return SetError(_WinAPI_GetLastError(), 0, "")
EndFunc   ;==>ReadPipe

Func WritePipe(ByRef $hPipe, Const $s)
	Local $tBuffer = DllStructCreate("char Text[4096]")
	DllStructSetData($tBuffer, "Text", $s)
	Local $iToWrite = StringLen($s)
	Local $iWritten = 0
	If _WinAPI_WriteFile($hPipe, DllStructGetPtr($tBuffer), $iToWrite, $iWritten) Then
		Return SetError(0, 0, $iWritten)
	EndIf
	Return SetError(_WinAPI_GetLastError(), 0, 0)
EndFunc   ;==>WritePipe

Func DataInPipe(ByRef $hPipe)
	Local $aResult = DllCall("kernel32.dll", "bool", "PeekNamedPipe", "handle", $hPipe, "ptr", 0, "int", 0, "dword*", 0, "dword*", 0, "dword*", 0)
	If @error Then Return SetError(@error, 0, 0)
	Return SetError(0, 0, $aResult[5])
EndFunc   ;==>DataInPipe

Func __WinAPI_CreateProcess($sAppName, $sCommand, $tSecurity, $tThread, $bInherit, $iFlags, $pEnviron, $sDir, $tStartupInfo, $tProcess)
	Local $tCommand = 0
	Local $sAppNameType = "wstr", $sDirType = "wstr"
	If $sAppName = "" Then
		$sAppNameType = "ptr"
		$sAppName = 0
	EndIf
	If $sCommand <> "" Then
		; must be MAX_PATH characters, can be updated by CreateProcessW
		$tCommand = DllStructCreate("wchar Text[" & 4096 + 1 & "]")
		DllStructSetData($tCommand, "Text", $sCommand)
	EndIf
	If $sDir = "" Then
		$sDirType = "ptr"
		$sDir = 0
	EndIf

	Local $aResult = DllCall("kernel32.dll", "bool", "CreateProcessW", $sAppNameType, $sAppName, "struct*", $tCommand, _
			"struct*", $tSecurity, "struct*", $tThread, "bool", $bInherit, "dword", $iFlags, "struct*", $pEnviron, $sDirType, $sDir, _
			"struct*", $tStartupInfo, "struct*", $tProcess)
	If @error Then Return SetError(@error, @extended, False)

	Return $aResult[0]
EndFunc   ;==>__WinAPI_CreateProcess

Func _WinAPI_FreeConsole()
	Local $aResult = DllCall("kernel32.dll", "bool", "FreeConsole")
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0]
EndFunc   ;==>_WinAPI_FreeConsole

Func _WinAPI_AllocConsole()
	Local $aResult = DllCall("kernel32.dll", "bool", "AllocConsole")
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0]
EndFunc   ;==>_WinAPI_AllocConsole

Func _WinAPI_SetConsoleIcon($g_sLibIconPath, $nIconID, $hWnD = Default)
	Local $hIcon = DllStructCreate("int")
	Local $Result = DllCall("shell32.dll", "int", "ExtractIconEx", "str", $g_sLibIconPath, "int", $nIconID - 1, "hwnd", 0, "ptr", DllStructGetPtr($hIcon), "int", 1)
	If UBound($Result) > 0 Then
		$Result = $Result[0]
		If $Result > 0 Then
			Local $error = 0, $extended = 0
			If $hWnD = Default Then
				$Result = DllCall("kernel32.dll", "bool", "SetConsoleIcon", "ptr", DllStructGetData($hIcon, 1))
				$Result = DllCall("kernel32.dll", "hwnd", "GetConsoleWindow")
				$error = @error
				$extended = @extended
				If UBound($Result) > 0 Then $hWnD = $Result[0]
			EndIf
			If IsHWnd($hWnD) Then
				_SendMessage($hWnD, $WM_SETICON, 0, DllStructGetData($hIcon, 1)) ; SMALL_ICON
				_SendMessage($hWnD, $WM_SETICON, 1, DllStructGetData($hIcon, 1)) ; BIG_ICON
				Sleep(50) ; little wait before detroying icon
			EndIf
			DllCall("user32.dll", "int", "DestroyIcon", "hwnd", DllStructGetData($hIcon, 1))
			If $error Then Return SetError($error, $extended, False)
			Return True
		EndIf
	EndIf
	If @error Then Return SetError(@error, @extended, False)
EndFunc   ;==>_WinAPI_SetConsoleIcon

Func _ConsoleWrite($Text)
	If StringTrimRight($Text, 1) <> @CRLF Then $Text &= @CRLF ; Custom fix - Team AIO Mod++
	Local $hFile, $pBuffer, $iToWrite, $iWritten, $tBuffer = DllStructCreate("char[" & StringLen($Text) & "]")
	DllStructSetData($tBuffer, 1, $Text)
	$hFile = _WinAPI_GetStdHandle(1)
	_WinAPI_WriteFile($hFile, $tBuffer, StringLen($Text), $iWritten)
	Return $iWritten
EndFunc   ;==>_ConsoleWrite

