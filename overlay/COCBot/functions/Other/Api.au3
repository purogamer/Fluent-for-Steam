; #FUNCTION# ====================================================================================================================
; Name ..........: MyBot.run Bot API functions
; Description ...: Register Windows Message and provides functions to communicate between bots and manage bot application
; Author ........: cosote (12-2016)
; Modified ......: CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
;                  Read/write memory: https://www.autoitscript.com/forum/topic/104117-shared-memory-variables-demo/
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

; MyBot Manage Farm (Host) uses these enums to place data of client bot in array
Global Enum $g_eBotDetailsBotForm = 0, $g_eBotDetailsTimer, $g_eBotDetailsProfile, $g_eBotDetailsCommandLine, $g_eBotDetailsTitle, $g_eBotDetailsRunState, $g_eBotDetailsPaused, $g_eBotDetailsLaunched, $g_eBotDetailsVerifyCount, $g_eBotDetailsBotStateStruct, $g_eBotDetailsOptionalStruct, $g_eBotDetailsArraySize
; $tagSTRUCT_BOT_STATE defines bot state details
Global $tagSTRUCT_BOT_STATE = _
		"struct" & _
		";hwnd BotHWnd" & _
		";hwnd AndroidHWnd" & _
		";boolean RunState" & _
		";boolean Paused" & _
		";boolean Launched" & _
		";uint64 g_hTimerSinceStarted" & _
		";uint g_iTimePassed" & _
		";char Profile[64]" & _
		";char AndroidEmulator[32]" & _
		";char AndroidInstance[32]" & _
		";int StructType" & _
		";ptr StructPtr" & _
		";boolean RegisterInHost" & _
		";endstruct"
; $tagSTRUCT_BOT_STATE can contain optional struct for additional information like Status Bar text or Stats
Global Enum $g_eSTRUCT_NONE = 0, $g_eSTRUCT_STATUS_BAR, $g_eSTRUCT_UPDATE_STATS
Global $tagSTRUCT_STATUS_BAR = "struct;char Text[255];endstruct", $g_aiCurrentLootBB[3]
Global $tagSTRUCT_UPDATE_STATS = _
		"struct" & _
		";long g_aiCurrentLoot[" & UBound($g_aiCurrentLoot) & "]" & _
		";long g_iFreeBuilderCount" & _
		";long g_iTotalBuilderCount" & _
		";long g_iGemAmount" & _
		";long g_iStatsTotalGain[" & UBound($g_iStatsTotalGain) & "]" & _
		";long g_iStatsLastAttack[" & UBound($g_iStatsLastAttack) & "]" & _
		";long g_iStatsBonusLast[" & UBound($g_iStatsBonusLast) & "]" & _
		";int g_iFirstAttack" & _
		";int g_aiAttackedCount" & _
		";int g_iSkippedVillageCount" & _
		";long g_aiCurrentLootBB[" & UBound($g_aiCurrentLootBB) & "]" & _ ; Custom BB - Team AIO Mod++
		";int g_iFreeBuilderCountBB" & _
		";int g_iTotalBuilderCountBB" & _
		";endstruct"
Global $tBotState = DllStructCreate($tagSTRUCT_BOT_STATE)
Global $tStatusBar = DllStructCreate($tagSTRUCT_STATUS_BAR)
Global $tUpdateStats = DllStructCreate($tagSTRUCT_UPDATE_STATS)

; API Version
Global $API_VERSION = "1.1"

; Mutex to ensure only one watchdog runs
Global $sWatchdogMutex = "MyBot.run/ManageFarm/" & $API_VERSION

; Register MyBot API Window Message
Global $WM_MYBOTRUN_API = _WinAPI_RegisterWindowMessage("MyBot.run/API/" & $API_VERSION)
SetDebugLog("MyBot.run/API/1.1 Message ID = " & $WM_MYBOTRUN_API)

; Register MyBot State Window Message
Global $WM_MYBOTRUN_STATE = _WinAPI_RegisterWindowMessage("MyBot.run/STATE/" & $API_VERSION)
SetDebugLog("MyBot.run/STATE/1.1 Message ID = " & $WM_MYBOTRUN_STATE)

; Struct helper methods
Func _DllStructSetData(ByRef $Struct, $Element, $value, $index = Default)
	If IsArray($value) Then
		Local $Result[UBound($value)]
		For $i = 0 To UBound($value) - 1
			$Result[$i] = DllStructSetData($Struct, $Element, $value[$i], $i + 1)
		Next
		Return $Result
	Else
		Return DllStructSetData($Struct, $Element, $value, $index)
	EndIf
EndFunc   ;==>_DllStructSetData

Func _DllStructLoadData(ByRef $Struct, $Element, ByRef $value)
	If IsArray($value) Then
		For $i = 0 To UBound($value) - 1
			$value[$i] = DllStructGetData($Struct, $Element, $i + 1)
		Next
		Return 1
	Else
		$value = DllStructGetData($Struct, $Element)
		Return 0
	EndIf
EndFunc   ;==>_DllStructLoadData

