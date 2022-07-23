
; #FUNCTION# ====================================================================================================================
; Name ..........: DropOnEdge
; Description ...:
; Syntax ........: DropOnEdge($troop, $edge, $number[, $slotsPerEdge = 0[, $edge2 = -1[, $x = -1]]])
; Parameters ....: $troop               - a dll struct value.
;                  $edge                - an unknown value.
;                  $number              - a general number value.
;                  $slotsPerEdge        - [optional] a string value. Default is 0.
;                  $edge2               - [optional] an unknown value. Default is -1.
;                  $x                   - [optional] an unknown value. Default is -1.
; Return values .: None
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#Region - Multi Finger - Team AIO Mod++
Func DropOnEdge($troop, $edge, $number, $slotsPerEdge = 0, $edge2 = -1, $x = -1, $FourFingers = 0)

	If isProblemAffect(True) Then Return
	If $number = 0 Then Return
	If _SleepAttack($DELAYDROPONEDGE1) Then Return
	SelectDropTroop($troop) ;Select Troop
	If _SleepAttack($DELAYDROPONEDGE2) Then Return
	If $slotsPerEdge = 0 Or $number < $slotsPerEdge Then $slotsPerEdge = $number
	If $number = 1 Or $slotsPerEdge = 1 Then ; Drop on a single point per edge => on the middle
		If $edge2 = -1 Then
			AttackClick($edge[2][0], $edge[2][1], $number, $DELAYDROPONEDGE1, $DELAYDROPONEDGE3, "#0102")
		Else
			AttackClick($edge[2][0], $edge[2][1], $number, $DELAYDROPONEDGE1, 0, "#0102")
			AttackClick($edge2[2][0], $edge2[2][1], $number, $DELAYDROPONEDGE1, $DELAYDROPONEDGE3, "#0103")
		EndIf
	ElseIf $slotsPerEdge = 2 And $FourFingers = 0 Then ; Drop on 2 points per edge
		Local $half = Ceiling($number / 2)
		AttackClick($edge[1][0], $edge[1][1], $half, SetSleep(0), 0, "#0104")
		If $edge2 <> -1 Then
			AttackClick($edge2[1][0], $edge2[1][1], $half, SetSleep(0), 0, "#0105")
		EndIf
		AttackClick($edge[3][0], $edge[3][1], $number - $half, SetSleep(0), 0, "#0106")
		If $edge2 <> -1 Then
			AttackClick($edge2[3][0], $edge2[3][1], $number - $half, SetSleep(0), 0, "#0107")
		EndIf
	Else
		Local $minX = $edge[0][0]
		Local $maxX = $edge[4][0]
		Local $minY = $edge[0][1]
		Local $maxY = $edge[4][1]
		If $FourFingers = 5 Then
			Local $minXTL = $g_aaiTopLeftDropPoints[0][0]
			Local $maxXTL = $g_aaiTopLeftDropPoints[4][0]
			Local $minYTL = $g_aaiTopLeftDropPoints[0][1]
			Local $maxYTL = $g_aaiTopLeftDropPoints[4][1]
		EndIf
		If $edge2 <> -1 Then
			Local $minX2 = $edge2[0][0]
			Local $maxX2 = $edge2[4][0]
			Local $minY2 = $edge2[0][1]
			Local $maxY2 = $edge2[4][1]
			If $FourFingers = 5 Then
				Local $minX2TR = $g_aaiTopRightDropPoints[0][0]
				Local $maxX2TR = $g_aaiTopRightDropPoints[4][0]
				Local $minY2TR = $g_aaiTopRightDropPoints[0][1]
				Local $maxY2TR = $g_aaiTopRightDropPoints[4][1]
			EndIf
		EndIf
		Local $nbTroopsLeft = $number
		For $i = 0 To $slotsPerEdge - 1
			Local $nbtroopPerSlot = Round($nbTroopsLeft / ($slotsPerEdge - $i)) ; progressively adapt the number of drops to fill at the best
			If $FourFingers = 5 Then
				Local $posX = $minX + (($maxX - $minX) * ($slotsPerEdge - $i)) / ($slotsPerEdge - 1)
				Local $posY = $minY + (($maxY - $minY) * ($slotsPerEdge - $i)) / ($slotsPerEdge - 1)
				AttackClick($posX, $posY, $nbtroopPerSlot, SetSleep(0), 0, "#0108")
				Local $posX = $minXTL + (($maxXTL - $minXTL) * $i) / ($slotsPerEdge - 1)
				Local $posY = $minYTL + (($maxYTL - $minYTL) * $i) / ($slotsPerEdge - 1)
			Else
				Local $posX = Round($minX + (($maxX - $minX) * $i) / ($slotsPerEdge - 1))
				Local $posY = Round($minY + (($maxY - $minY) * $i) / ($slotsPerEdge - 1))
			EndIf
			AttackClick($posX, $posY, $nbtroopPerSlot, SetSleep(0), 0, "#0108")
			If $edge2 <> -1 Then ; for 2, 3 and 4 sides attack use 2x dropping
				If $FourFingers = 5 Then
					Local $posX2 = $maxX2 - (($maxX2 - $minX2) * ($slotsPerEdge - $i)) / ($slotsPerEdge - 1)
					Local $posY2 = $maxY2 - (($maxY2 - $minY2) * ($slotsPerEdge - $i)) / ($slotsPerEdge - 1)
					AttackClick($posX2, $posY2, $nbtroopPerSlot, SetSleep(0), 0, "#0109")
					Local $posX2 = $maxX2TR - (($maxX2TR - $minX2TR) * $i) / ($slotsPerEdge - 1)
					Local $posY2 = $maxY2TR - (($maxY2TR - $minY2TR) * $i) / ($slotsPerEdge - 1)
				Else
					Local $posX2 = Round($maxX2 - (($maxX2 - $minX2) * $i) / ($slotsPerEdge - 1))
					Local $posY2 = Round($maxY2 - (($maxY2 - $minY2) * $i) / ($slotsPerEdge - 1))
				EndIf
				AttackClick($posX2, $posY2, $nbtroopPerSlot, SetSleep(0), 0, "#0109")
			EndIf
			$nbTroopsLeft -= $nbtroopPerSlot
		Next
	EndIf
EndFunc   ;==>DropOnEdge
#EndRegion - Multi Finger - Team AIO Mod++
