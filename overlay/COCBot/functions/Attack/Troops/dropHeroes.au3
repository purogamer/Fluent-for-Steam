; #FUNCTION# ====================================================================================================================
; Name ..........: dropHeroes
; Description ...: Will drop heroes in a specific coordinates, only if slot is not -1,Only drops when option is clicked.
; Syntax ........: dropHeroes($x, $y, $iKingSlot = -1, $iQueenSlot = -1, $iWardenSlot = -1, $iChampionSlot = -1)
; Parameters ....: $x                   - an unknown value.
;                  $y                   - an unknown value.
;                  $KingSlot            - [optional] an unknown value. Default is -1.
;                  $QueenSlot           - [optional] an unknown value. Default is -1.
;                  $WardenSlot          - [optional] an unknown value. Default is -1.
; Return values .: None
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func dropHeroes($iX, $iY, $iKingSlotNumber = -1, $iQueenSlotNumber = -1, $iWardenSlotNumber = -1, $iChampionSlotNumber = -1, $bSmartFarm = False, $bSmartMilk = False) ;Drops for All Heroes
	SetDebugLog("dropHeroes $iKingSlotNumber " & $iKingSlotNumber & " $iQueenSlotNumber " & $iQueenSlotNumber & " $iWardenSlotNumber " & $iWardenSlotNumber & " $iChampionSlotNumber " & $iChampionSlotNumber & " matchmode " & $g_iMatchMode, $COLOR_DEBUG)
	If _Sleep($DELAYDROPHEROES1) Then Return
	Local $bDropKing = False
	Local $bDropQueen = False
	Local $bDropWarden = False
	Local $bDropChampion = False

	;use hero if  slot (detected ) and ( ($g_iMatchMode <>DB and <>LB  ) or (check user GUI settings) )
	If $iKingSlotNumber <> -1 And (($g_iMatchMode <> $DB And $g_iMatchMode <> $LB) Or BitAND($g_aiAttackUseHeroes[$g_iMatchMode], $eHeroKing) = $eHeroKing) Then $bDropKing = True
	If $iQueenSlotNumber <> -1 And (($g_iMatchMode <> $DB And $g_iMatchMode <> $LB) Or BitAND($g_aiAttackUseHeroes[$g_iMatchMode], $eHeroQueen) = $eHeroQueen) Then $bDropQueen = True
	If $iWardenSlotNumber <> -1 And (($g_iMatchMode <> $DB And $g_iMatchMode <> $LB) Or BitAND($g_aiAttackUseHeroes[$g_iMatchMode], $eHeroWarden) = $eHeroWarden) Then $bDropWarden = True
	If $iChampionSlotNumber <> -1 And (($g_iMatchMode <> $DB And $g_iMatchMode <> $LB) Or BitAND($g_aiAttackUseHeroes[$g_iMatchMode], $eHeroChampion) = $eHeroChampion) Then $bDropChampion = True

	SetDebugLog("drop KING = " & $bDropKing, $COLOR_DEBUG)
	SetDebugLog("drop QUEEN = " & $bDropQueen, $COLOR_DEBUG)
	SetDebugLog("drop WARDEN = " & $bDropWarden, $COLOR_DEBUG)
	SetDebugLog("drop CHAMPION = " & $bDropChampion, $COLOR_DEBUG)

	Local $iDelay = 100
	If $bSmartFarm Then $iDelay = Round(Random(1, 2) * $DELAYDROPHEROES2)
	
	Local $a[4] = ["Q", "K", "W", "C"]
	
	; W K Q C
	If $bSmartMilk Then
		Local $aM[4] = ["W", "K", "Q", "C"]
		$a = $aM
	; K Q W C
	ElseIf Random(0, 100, 1) > 40 Then
		Local $aR[4] = ["K", "Q", "W", "C"]
		$a = $aR
	EndIf
	
	SetDebugLog("Deploy " & $a[0] & " -> " & $a[1] & " -> " & $a[2] & " -> " & $a[3])
		
	Local $i = 0, $irx = 0, $iry = 0
	Do
		$irx = Random(-5, 5, 1)
		$iry = Random(-5, 5, 1)
		
		If $bDropKing And $a[$i] == "K" Then
			SetLog("Dropping King at " & $iX & ", " & $iY, $COLOR_INFO)
			SelectDropTroop($iKingSlotNumber, 1, Default, False)
			If _Sleep($iDelay) Then Return
			AttackClick($iX + $irx, $iY + $iry, 1, 0, 0, "#0093")
			If Not $g_bDropKing Then ; check global flag, only begin hero health check on 1st hero drop as flag is reset to false after activation
				$g_bCheckKingPower = True
			Else
				SetDebugLog("King dropped 2nd time, Check Power flag not changed") ; do nothing as hero already dropped
			EndIf
			$g_bDropKing = True ; Set global flag hero dropped
			$g_aHeroesTimerActivation[$eHeroBarbarianKing] = __TimerInit() ; initialize fixed activation timer
			If RandomSleep($DELAYDROPHEROES1 * 2) Then Return
		EndIf
	
		If $bDropQueen And $a[$i] == "Q" Then
			SetLog("Dropping Queen at " & $iX & ", " & $iY, $COLOR_INFO)
			SelectDropTroop($iQueenSlotNumber, 1, Default, False)
			If _Sleep($iDelay) Then Return
			AttackClick($iX + $irx, $iY + $iry, 1, 0, 0, "#0095")
			If Not $g_bDropQueen Then ; check global flag, only begin hero health check on 1st hero drop as flag is reset to false after activation
				$g_bCheckQueenPower = True
			Else
				SetDebugLog("Queen dropped 2nd time, Check Power flag not changed") ; do nothing as hero already dropped
			EndIf
			$g_bDropQueen = True ; Set global flag hero dropped
			$g_aHeroesTimerActivation[$eHeroArcherQueen] = __TimerInit() ; initialize fixed activation timer
			If RandomSleep($DELAYDROPHEROES1 * 2) Then Return
		EndIf
	
		If $bDropWarden And $a[$i] == "W" Then
			SetLog("Dropping Grand Warden at " & $iX & ", " & $iY, $COLOR_INFO)
			SelectDropTroop($iWardenSlotNumber, 1, Default, False)
			If _Sleep($iDelay) Then Return
			AttackClick($iX + $irx, $iY + $iry, 1, 0, 0, "#x999")
			If Not $g_bDropWarden Then ; check global flag, only begin hero health check on 1st hero drop as flag is reset to false after activation
				$g_bCheckWardenPower = True
			Else
				SetDebugLog("Warden dropped 2nd time, Check Power flag not changed") ; do nothing as hero already dropped
			EndIf
			$g_bDropWarden = True ; Set global flag hero dropped
			$g_aHeroesTimerActivation[$eHeroGrandWarden] = __TimerInit() ; initialize fixed activation timer
			If RandomSleep($DELAYDROPHEROES1 * 2) Then Return
		EndIf
	
		If $bDropChampion And $a[$i] == "C" Then
			SetLog("Dropping Royal Champion at " & $iX & ", " & $iY, $COLOR_INFO)
			SelectDropTroop($iChampionSlotNumber, 1, Default, False)
			If _Sleep($iDelay) Then Return
			AttackClick($iX + $irx, $iY + $iry, 1, 0, 0, "#x999")
			If Not $g_bDropChampion Then ; check global flag, only begin hero health check on 1st hero drop as flag is reset to false after activation
				$g_bCheckChampionPower = True
			Else
				SetDebugLog("Royal Champion dropped 2nd time, Check Power flag not changed") ; do nothing as hero already dropped
			EndIf
			$g_bDropChampion = True ; Set global flag hero dropped
			$g_aHeroesTimerActivation[$eHeroRoyalChampion] = __TimerInit() ; initialize fixed activation timer
			If RandomSleep($DELAYDROPHEROES1 * 2) Then Return
		EndIf
		
		$i += 1
	Until $i = 4
EndFunc   ;==>dropHeroes