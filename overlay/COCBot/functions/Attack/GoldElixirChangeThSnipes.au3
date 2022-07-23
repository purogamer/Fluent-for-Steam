;==========================================================================
; #FUNCTION# ====================================================================================================================
; Name ..........: GoldElixirChangeThSnipes
; Description....: Checks if the gold/elixir changes values within 20 seconds, Returns True if changed. Also
; 					    checks every 5 seconds if gold/elixir = "", meaning battle is over. If either condition is met, return
; 					    false
; Syntax ........: GoldElixirChangeThSnipes()
; Parameters ....: $x
; Return values .: None
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
; Notes: If all troops are used, the battle will end when they are all dead, the timer runs out, or the
; base has been 3-starred. When the battle ends, it is detected within 5 seconds, otherwise it takes up
; to 20 seconds.

Func GoldElixirChangeThSnipes($x)
	Local $Gold1, $Gold2
	Local $GoldChange, $ElixirChange
	Local $Elixir1, $Elixir2

	SetLog("Checking if the Gold6Elixir are changing...", $COLOR_INFO)

	For $y = 0 To $x
		$Gold1 = getGoldVillageSearch(48, 69)
		$Elixir1 = getElixirVillageSearch(48, 69 + 29)

		Local $iBegin = __TimerInit()

		While __TimerDiff($iBegin) < 2000
			CheckHeroesHealth()
			If $g_bCheckKingPower Or $g_bCheckQueenPower Then
				If _Sleep($DELAYGOLDELIXIRCHANGE1) Then Return
			Else
				If _Sleep($DELAYGOLDELIXIRCHANGE2) Then Return
			EndIf

			$Gold2 = getGoldVillageSearch(48, 69)

			If $Gold2 = "" Then
				If _Sleep($DELAYGOLDELIXIRCHANGE1) Then Return
				$Gold2 = getGoldVillageSearch(48, 69)
			EndIf
			$Elixir2 = getElixirVillageSearch(48, 69 + 29)


			If $Gold2 <> "" Or $Elixir2 <> "" Then
				$GoldChange = $Gold2
				$ElixirChange = $Elixir2
			EndIf

			If ($Gold2 = "" And $Elixir2 = "") Then
				If _Sleep($DELAYGOLDELIXIRCHANGE1) Then Return

				If getGoldVillageSearch(48, 69) = "" And getElixirVillageSearch(48, 69 + 29) = "" Then
					SetLog("Battle has finished", $COLOR_SUCCESS)
					Return True
					ExitLoop
				EndIf
			EndIf

		WEnd
		If ($Gold1 = $Gold2 And $Elixir1 = $Elixir2) Or ($Gold2 = "" And $Elixir2 = "") Then
			ExitLoop
		Else
			SetLog("Gold & Elixir change detected, waiting...", $COLOR_SUCCESS)
			ContinueLoop
		EndIf
		$x += 1
		If Sleep(1000) Then Return
		Return False
	Next
EndFunc   ;==>GoldElixirChangeThSnipes
