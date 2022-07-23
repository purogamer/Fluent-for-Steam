
; #FUNCTION# ====================================================================================================================
; Name ..........: DropOnEdges
; Description ...:
; Syntax ........: DropOnEdges($troop, $nbSides, $number[, $slotsPerEdge = 0])
; Parameters ....: $troop               - a dll struct value.
;                  $nbSides             - a general number value.
;                  $number              - a general number value.
;                  $slotsPerEdge        - [optional] a string value. Default is 0.
; Return values .: None
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
;
#Region - Multi Finger - Team AIO Mod++
Func DropOnEdges($troop, $nbSides, $number, $slotsPerEdge = 0)
	If $nbSides = 0 Or $number = 1 Then
		OldDropTroop($troop, $g_aaiEdgeDropPoints[0], $number) ;
		Return
	EndIf
	If $nbSides < 1 Then Return
	Local $nbTroopsLeft = $number
	If $nbSides = 4 Then
		For $i = 0 To $nbSides - 3
			KeepClicks()
			Local $nbTroopsPerEdge = Round($nbTroopsLeft / ($nbSides - $i * 2))
			DropOnEdge($troop, $g_aaiEdgeDropPoints[$i], $nbTroopsPerEdge, $slotsPerEdge, $g_aaiEdgeDropPoints[$i + 2], $i)
			$nbTroopsLeft -= $nbTroopsPerEdge * 2
			ReleaseClicks()
		Next
		Return
	EndIf

	; Classic Four Fingers attack
	If $nbSides = 5 Then
		If $slotsPerEdge = 2 Then
			For $i = 0 To $nbSides - 4 ; Four Fingers Deployment Giants
				KeepClicks()
				Local $nbTroopsPerEdge = Round($nbTroopsLeft / (($nbSides-1) - $i * 2))
				DropOnEdge($troop, $g_aaiEdgeDropPoints[$i], $nbTroopsPerEdge, $slotsPerEdge, $g_aaiEdgeDropPoints[$i + 2], $i)
				$nbTroopsLeft -= $nbTroopsPerEdge * 2
				ReleaseClicks()
			Next
		Else
			For $i = 0 To $nbSides - 5 ; Four Fingers Deployment Troops
				KeepClicks()
				Local $nbTroopsPerEdge = Round($nbTroopsLeft / (($nbSides-1) - $i * 2))
				DropOnEdge($troop, $g_aaiEdgeDropPoints[$i], $nbTroopsPerEdge, $slotsPerEdge, $g_aaiEdgeDropPoints[$i + 2], $i, $nbSides)
				$nbTroopsLeft -= $nbTroopsPerEdge * 2
				ReleaseClicks()
			Next
		EndIf
		Return
	EndIf

	For $i = 0 To $nbSides - 1
		KeepClicks()
		If $nbSides = 1 Or ($nbSides = 3 And $i = 2) Then
			Local $nbTroopsPerEdge = Round($nbTroopsLeft / ($nbSides - $i))
			If $g_iMatchMode = $LB And $g_aiAttackStdDropSides[$LB] >= 5 Then ; Used for DE or TH side attack
				DropOnEdge($troop, $g_aaiEdgeDropPoints[$g_iBuildingEdge], $nbTroopsPerEdge, $slotsPerEdge)
			Else
				DropOnEdge($troop, $g_aaiEdgeDropPoints[$i], $nbTroopsPerEdge, $slotsPerEdge)
			EndIf
			$nbTroopsLeft -= $nbTroopsPerEdge
		ElseIf ($nbSides = 2 And $i = 0) Or ($nbSides = 3 And $i <> 1) Then
			Local $nbTroopsPerEdge = Round($nbTroopsLeft / ($nbSides - $i * 2))
			DropOnEdge($troop, $g_aaiEdgeDropPoints[$i + 3], $nbTroopsPerEdge, $slotsPerEdge, $g_aaiEdgeDropPoints[$i + 1])
			$nbTroopsLeft -= $nbTroopsPerEdge * 2
		EndIf
		ReleaseClicks()
	Next
EndFunc   ;==>DropOnEdges
#EndRegion - Multi Finger - Team AIO Mod++
