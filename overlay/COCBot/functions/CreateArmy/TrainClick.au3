; #FUNCTION# ====================================================================================================================
; Name ..........: TrainClick
; Description ...: Clicks in troop training window with special checks for Barracks Full, and If not enough elxir to train troops or to close the gem window if opened.
; Syntax ........: TrainClick($x, $y, $iTimes, $iSpeed, $aWatchSpot, $aLootSpot, $debugtxt = "")
; Parameters ....: $x                   - X location to click
;                  $y                   - Y location to click
;                  $iTimes              - Number fo times to cliok
;                  $iSpeed              - Wait time after click
;                  $aWatchSpot          - [in/out] an array of [X location, Y location, Hex Color, Tolerance] to check after click if full
;                  $aLootSpot           - [in/out] an array of [X location, Y location, Hex Color, Tolerance] to check after click, color used to see if out of Elixir for more troops
;						 $sdebugtxt				 - String with click debug text
; Return values .: None
; Author ........: KnowJack (07-2015)
; Modified ......: Sardo (08-2015), Boju (06-2016)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func TrainClick($iX, $iY, $iTimes, $iSpeed, $aWatchSpot, $sdebugtxt, $TypeTroops)
	If IsTrainPage() Then
		If $g_bDebugClick Then
			Local $txt = _DecodeDebug($sdebugtxt)
			SetLog("TrainClick(" & $iX & "," & $iY & "," & $iTimes & "," & $iSpeed & "," & $sdebugtxt & $txt & "," & $TypeTroops & ")", $COLOR_DEBUG)
		EndIf

		If $iTimes <> 1 Then
			KeepClicks()
			; Debug
			If $g_bDebugClick Or $g_bDebugSetlogTrain Then SetLog("KeepClicks: " & KeepClicks(), $COLOR_DEBUG)
			If IsKeepClicksActive() Then
				For $i = 0 To ($iTimes - 1)
					PureClick($iX, $iY) ;Click once.
				Next
				If isProblemAffect(True) Then checkMainScreen(False) ; Check for BS/CoC errors
				Local $sLogText = Default
				If $g_bDebugSetlogTrain Then $sLogText = "TrainClick " & $iX & "," & $iY & "," & $iTimes
				If _CheckPixel($aWatchSpot, True, Default, $sLogText) = True Then ; Check to see if barrack full
					If $g_bDebugClick Or $g_bDebugSetlogTrain Then SetLog("Camp is FULL", $COLOR_DEBUG)
					; Detected the gray [i] and will exit and return
					ClearClicks()
				EndIf
			Else
				; FastCaptureRegion = True when is set to use WinAPI+ BackgroundMode
				If FastCaptureRegion() Then
					; Will make a LOOP for each troop will check a color position ( gray[i] )
					For $i = 0 To ($iTimes - 1)
						If isProblemAffect(True) Then checkMainScreen(False) ; Check for BS/CoC errors
						Local $sLogText = Default
						If $g_bDebugSetlogTrain Then $sLogText = "TrainClick " & $iX & "," & $iY & "," & $iTimes
						If _CheckPixel($aWatchSpot, True, Default, $sLogText) = True Then ; Check to see if barrack full
							If $g_bDebugClick Or $g_bDebugSetlogTrain Then SetLog("Camp is FULL after " & $i & " clicks", $COLOR_DEBUG)
							; Detected the gray [i] and will exit and return
							ExitLoop
						EndIf
						PureClick($iX, $iY) ;Click once.
						If _Sleep($iSpeed, False) Then ExitLoop
					Next
				Else
					If isProblemAffect(True) Then checkMainScreen(False) ; Check for BS/CoC errors
					Local $sLogText = Default
					If $g_bDebugSetlogTrain Then $sLogText = "TrainClick " & $iX & "," & $iY & "," & $iTimes
					If _CheckPixel($aWatchSpot, True, Default, $sLogText) = True Then ; Check to see if barrack full
						If $g_bDebugClick Or $g_bDebugSetlogTrain Then SetLog("Camp is full", $COLOR_DEBUG)
						Return ; Check to see if barrack full
					EndIf
					PureClick($iX, $iY, $iTimes, $iSpeed) ;Click $iTimes.
					If _Sleep($iSpeed, False) Then Return
				EndIf
			EndIf
			ReleaseClicks()
		Else
			Local $sLogText = Default
			If $g_bDebugSetlogTrain Then $sLogText = "TrainClick " & $iX & "," & $iY & "," & $iTimes
			If isProblemAffect(True) Then checkMainScreen(False) ; Check for BS/CoC errors
			If $g_bDebugSetlogTrain Then SetLog("Full Check=" & _GetPixelColor($aWatchSpot[0], $aWatchSpot[1], False), $COLOR_DEBUG)
			If _CheckPixel($aWatchSpot, True, Default, $sLogText) = True Then
				If $g_bDebugClick Or $g_bDebugSetlogTrain Then SetLog("Camp is FULL", $COLOR_DEBUG)
				Return ; Check to see if barrack full
			EndIf
			PureClick($iX, $iY)

			If _Sleep($iSpeed, False) Then Return
		EndIf
		Return True
	Else
		Return False
	EndIf
EndFunc   ;==>TrainClick

Func TrainClickP($aPoint, $iHowOften, $iSpeed, $aWatchSpot, $sdebugtxt, $TypeTroops)
	Return TrainClick($aPoint[0], $aPoint[1], $iHowOften, $iSpeed, $aWatchSpot, $sdebugtxt, $TypeTroops)
EndFunc   ;==>TrainClickP
