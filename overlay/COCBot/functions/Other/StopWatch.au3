; #FUNCTION# ====================================================================================================================
; Name ..........: StopWatchStart, StopWatchStopLog, StopWatchLevel, StopWatchReturn, FuncEnter, FuncReturn
; Description ...: Logs step execution times
; Syntax ........:
; Parameters ....:
; Return values .:
; Author ........: Cosote, 12-2017
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: StopWatchStart("myFunction") [...] StopWatchStopLog() on early exist use StopWatchReturn($iInitialLevel)
; ===============================================================================================================================

Global $g_oStopWatches = ObjCreate("Scripting.Dictionary")
Global $g_oFuncCall = ObjCreate("Scripting.Dictionary")
If Not IsDeclared("g_bDebugFuncTime") Then Global $g_bDebugFuncTime = False
If Not IsDeclared("g_bDebugFuncCall") Then Global $g_bDebugFuncCall = False

Func FuncEnter($fFunc, $bLog = $g_bDebugFuncCall)
	Local $sFunc = FuncName($fFunc)
	Local $iLevel = FuncCallLevel()
	$g_oFuncCall("__CURRENT_FUNC__" & $iLevel) = $sFunc
	$g_oFuncCall("__CURRENT_FUNC_LEVEL__") = $iLevel + 1
	If $bLog Then
		SetDebugLog(">>> Enter Func: " & $sFunc & ", call-hierarchy: " & FuncCallHierarchy(False), $COLOR_WARNING)
	EndIf
	Return $iLevel
EndFunc   ;==>FuncEnter

Func FuncCallHierarchy($bIncludeCurrent = True)
	Local $iLevel = FuncCallLevel() - 1
	If Not $bIncludeCurrent Then $iLevel -= 1
	Local $sHierarchy = ""
	For $i = 0 To $iLevel
		If $sHierarchy = "" Then
			$sHierarchy = $g_oFuncCall("__CURRENT_FUNC__" & $i)
		Else
			$sHierarchy &= " -> " & $g_oFuncCall("__CURRENT_FUNC__" & $i)
		EndIf
	Next
	Return $sHierarchy
EndFunc   ;==>FuncCallHierarchy

Func FuncCallLevel()
	Local $iLevel = $g_oFuncCall("__CURRENT_FUNC_LEVEL__")
	If IsNumber($iLevel) = 0 Then $iLevel = 0
	Return $iLevel
EndFunc   ;==>FuncCallLevel

Func FuncCurrent()
	Local $iLevel = FuncCallLevel() - 1
	If $iLevel < 0 Then Return ""
	Return $g_oFuncCall("__CURRENT_FUNC__" & $iLevel)
EndFunc   ;==>FuncCurrent

Func FuncReturn($Result = "__No_Result", $bLog = $g_bDebugFuncCall)
	Local $bNoResult = (IsString($Result) And $Result = "__No_Result")
	Local $iLevel = FuncCallLevel() - 1
	If $iLevel < 0 Then
		SetDebugLog("FuncReturn improper use", $COLOR_ERROR)
	Else
		$g_oFuncCall("__CURRENT_FUNC_LEVEL__") = $iLevel
		Local $sTag = "__CURRENT_FUNC__" & $iLevel
		Local $sFunc = $g_oFuncCall($sTag)
		$g_oFuncCall.remove($sTag)
		If $bLog Then
			SetDebugLog("<<< Return Func: " & $sFunc & (($bNoResult) ? (", no result") : (", Result: " & $Result)) & ", call-hierarchy: " & FuncCallHierarchy(True), $COLOR_WARNING)
		EndIf
	EndIf
	If $bNoResult Then Return
	Return $Result
EndFunc   ;==>FuncReturn

Func StopWatchStart($sTag)
	StopWatchStopPushTag($sTag)
	$g_oStopWatches($sTag) = __TimerInit()
EndFunc   ;==>StopWatchStart

Func StopWatchLevel()
	Local $iLevel = $g_oStopWatches("__CURRENT_TAG_LEVEL__")
	If IsNumber($iLevel) = 0 Then $iLevel = 0
	Return $iLevel
EndFunc   ;==>StopWatchLevel

Func StopWatchStopPushTag($sTag)
	Local $iLevel = StopWatchLevel()
	$g_oStopWatches("__CURRENT_TAG__" & $iLevel) = $sTag
	$g_oStopWatches("__CURRENT_TAG_LEVEL__") = $iLevel + 1
	Return $iLevel
EndFunc   ;==>StopWatchStopPushTag

Func StopWatchStopPopTag($iNewLevel = Default)
	Local $iLevel = StopWatchLevel() - 1
	$g_oStopWatches("__CURRENT_TAG_LEVEL__") = $iLevel
	Return $g_oStopWatches("__CURRENT_TAG__" & $iLevel)
EndFunc   ;==>StopWatchStopPopTag

Func StopWatchStopLog($sTag = Default, $iNewLevel = Default, $bLog = True)
	Local $sTagLevel = StopWatchStopPopTag()
	If $sTag = Default Then
		$sTag = $sTagLevel
	ElseIf $sTag <> $sTagLevel Then
		SetLog("StopWatch Level mismatch: " & $sTag & " <> " & $sTagLevel, $COLOR_ERROR)
	EndIf
	Local $hTimer = $g_oStopWatches($sTag)
	$g_oStopWatches.Remove($sTag)
	SetLog($sTag & " Execution-time: " & __TimerDiff($hTimer))
	If $iNewLevel <> Default Then
		While StopWatchLevel() > $iNewLevel
			StopWatchStopLog(Default, Default, $bLog)
		WEnd
	EndIf
EndFunc   ;==>StopWatchStopLog

Func StopWatchReturn($iNewLevel, $bLog = $g_bDebugFuncTime)
	Local $iCurLevel = StopWatchLevel()
	If $iNewLevel <> $iCurLevel Then StopWatchStopLog(Default, $iNewLevel, $bLog)
EndFunc   ;==>StopWatchReturn
