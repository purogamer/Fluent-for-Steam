; #FUNCTION# ====================================================================================================================
; Name ..........: FindTownHall
; Description ...:
; Syntax ........: FindTownHall([$check = True])
; Parameters ....: $check               - [optional] an unknown value. Default is True.
; Return values .: None
; Author ........:
; Modified ......: CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
#include-once

Func FindTownHall($bCheck = True, $forceCaptureRegion = True)
	Local $THString = ""
	$g_iSearchTH = "-"
	$g_iTHx = 0
	$g_iTHy = 0 ;if not check, find bully mode, always find				if deadbase enabled, and TH lvl or Outside checked, find          same with ActiveBase

	If $bCheck Or ($g_bIsModeActive[$DB] And ($g_abFilterMeetTH[$DB] Or $g_abFilterMeetTHOutsideEnable[$DB])) Or ($g_bIsModeActive[$LB] And ($g_abFilterMeetTH[$LB] Or $g_abFilterMeetTHOutsideEnable[$LB])) Then

		$g_iSearchTH = imgloccheckTownHallADV2(0, 0, $forceCaptureRegion)

		If $g_iSearchTH <> "-" Then
			$g_sTHLoc = "In"
		ElseIf $g_iSearchTH <> "-" Then
			$g_sTHLoc = "Out"
		Else
			$g_sTHLoc = $g_iSearchTH
			$g_iTHx = 0
			$g_iTHy = 0
		EndIf
		Return " [TH]:" & StringFormat("%2s", $g_iSearchTH) & ", " & $g_sTHLoc
	EndIf
	$g_sTHLoc = $g_iSearchTH
	$g_iTHx = 0
	$g_iTHy = 0
	Return ""
EndFunc   ;==>FindTownHall
