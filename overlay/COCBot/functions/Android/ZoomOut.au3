; #FUNCTION# ====================================================================================================================
; Name ..........: ZoomOut
; Description ...: Tries to zoom out of the screen until the borders, located at the top of the game (usually black), is located.
; Syntax ........: ZoomOut()
; Parameters ....:
; Return values .: None
; Author ........:
; Modified ......: KnowJack (07-2015), CodeSlinger69 (01-2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Global $g_aiSearchZoomOutCounter[2] = [0, 1] ; 0: Counter of SearchZoomOut calls, 1: # of post zoomouts after image found
Func ZoomOut($bForceZoom = Default, $bVersusMode = False, $bDebugWithImage = False)
	Static $s_bZoomOutActive = False
	If $s_bZoomOutActive Then Return ; recursive not allowed here
	$s_bZoomOutActive = True

	ResumeAndroid()
	WinGetAndroidHandle()
	getBSPos() ; Update $g_hAndroidWindow and Android Window Positions

	$g_aiSearchZoomOutCounter[0] = 0
	$g_aiSearchZoomOutCounter[1] = 1
	If $bForceZoom = Default Then $bForceZoom = (Not $g_bSkipFirstZoomout) Or $bVersusMode
	$g_bSkipFirstZoomout = (Not $bForceZoom)

	Local $aResult, $bBuilderBase

	Local $bMainSendZoomout = False

	; Small loop just in case
	For $i = 0 To 12
		; Update shield status
		AndroidShield("ZoomOut")

		If $i = 0 Or $i = 3 Or $i = 6 Then
			If IsProblemAffect(True) Then
				SetLog("[ZoomOut] IsProblemAffect is true")
				ExitLoop
			EndIf
		EndIf

		If $bForceZoom Or $i > 0 Then
			$bMainSendZoomout = MainSendZoomout($i, $bVersusMode)
		Else
			$bMainSendZoomout = True
		EndIf

		; Run the ZoomOut Script
		If $bMainSendZoomout Then
			If $bVersusMode And $i = 0 Or $i = 3 Then ClickDrag(514, 187, 545, 130)
			If _Sleep(750) Then
				$s_bZoomOutActive = False
				Return False
			EndIf

			; Get the Distances between images
			$aResult = SearchZoomOut($aCenterHomeVillageClickDrag, True, "BuilderBaseZoomOut", True, $g_bDebugSetlog, $bVersusMode)
			If UBound($aResult) < 1 Or @error Then
				$s_bZoomOutActive = False
				Return False
			EndIf

			If $aResult[0] <> "" Then
				$g_aiSearchZoomOutCounter[0] = 0
				$g_aiSearchZoomOutCounter[1] = 1
				$g_bSkipFirstZoomout = True
				$s_bZoomOutActive = False
				Return True
			EndIf
		Else
			SetDebugLog("[ZoomOut] Send Script Error!", $COLOR_DEBUG)
		EndIf
	Next
	$s_bZoomOutActive = False
	Return False
EndFunc   ;==>ZoomOut

Func MainSendZoomout($i = 0, $bVersusMode = False, $sEmulator = $g_sAndroidEmulator)
	If $g_bDebugSetlog Then
		SetDebugLog("Zooming Out (MainSendZoomout)", $COLOR_INFO)
	Else
		SetLog("Zooming Out", $COLOR_INFO)
	EndIf
	If $i > 2 Then  Return AndroidZoomOut(0, Default)
	Local $bResult = False
	If ($g_iAndroidZoomoutMode = 0 Or $g_iAndroidZoomoutMode = 3) And ($g_bAndroidEmbedded = False Or $g_iAndroidEmbedMode = 1) And $bVersusMode = False Then
		Switch $sEmulator
			Case "BlueStacks", "BlueStacks2", "BlueStacks5"
				If $__BlueStacks2Version_2_5_or_later = False And Not $sEmulator = "BlueStacks5" Then
					; ctrl click is best and most stable for BlueStacks, but not working after 2.5.55.6279 version
					$bResult = ZoomOutCtrlWheelScroll(True, True, True, Default, -5, 250)
				Else
					$bResult = DefaultZoomOut("{DOWN}")
				EndIf
			Case "MEmu"
				$bResult = DefaultZoomOut("{F3}")
			Case "Nox"
				$bResult = ZoomOutCtrlWheelScroll(True, True, True, Default, -5, 250)
		EndSwitch
	EndIf

	If $bResult = False Then
		Return AndroidZoomOut(0, Default)
	EndIf

	$g_bSkipFirstZoomout = True
EndFunc   ;==>MainSendZoomout

Func DefaultZoomOut($ZoomOutKey = "{DOWN}", $bCenterMouseWhileZooming = False) ;Zooms out
	Local $iControlFocus = 1, $iControlSend = 0

	; original windows based zoom-out
	If $g_bChkBackgroundMode = False And $g_bNoFocusTampering = False Then
		$iControlFocus = ControlFocus($g_hAndroidWindow, "", "")
		If $bCenterMouseWhileZooming Then MouseMove($g_aiBSpos[0] + Int($g_iDEFAULT_WIDTH / 2), $g_aiBSpos[1] + Int($g_iDEFAULT_HEIGHT / 2), 0)
	EndIf

	$iControlSend = ControlSend($g_hAndroidWindow, "", "", $ZoomOutKey)
	Return ($iControlFocus = 1 And $iControlSend = 0)
EndFunc   ;==>DefaultZoomOut

Func ZoomOutCtrlWheelScroll($CenterMouseWhileZooming = True, $GlobalMouseWheel = True, $AlwaysControlFocus = False, $hWin = Default, $ScrollSteps = -5, $ClickDelay = 250)
	SetDebugLog("ZoomOutCtrlWheelScroll()")
	Local $sFunc = "ZoomOutCtrlWheelScroll"
	Local $Result[4], $i = 0, $j
	Local $ZoomActions[4] = ["ControlFocus", "Ctrl Down", "Mouse Wheel Scroll Down", "Ctrl Up"]
	If $hWin = Default Then $hWin = ($g_bAndroidEmbedded = False ? $g_hAndroidWindow : $g_aiAndroidEmbeddedCtrlTarget[1])
	Local $aMousePos = MouseGetPos()

	; original windows based zoom-out
	SetDebugLog("Index = " & $i, $COLOR_DEBUG) ; Index=2X loop count if success, will be increment by 1 if controlsend fail
	If _Sleep($DELAYZOOMOUT2) Then Return
	If ($g_bChkBackgroundMode = False And $g_bNoFocusTampering = False) Or $AlwaysControlFocus Then
		$Result[0] = ControlFocus($hWin, "", "")
	Else
		$Result[0] = 1
	EndIf
	For $iTry = 0 To 1
		$Result[1] = ControlSend($hWin, "", "", "{CTRLDOWN}")
		If $CenterMouseWhileZooming Then MouseMove($g_aiBSpos[0] + Int($g_iDEFAULT_WIDTH / 2), $g_aiBSpos[1] + Int($g_iDEFAULT_HEIGHT / 2), 0)
		If $GlobalMouseWheel Then
			$Result[2] = MouseWheel(($ScrollSteps < 0 ? "down" : "up"), Abs($ScrollSteps)) ; can't find $MOUSE_WHEEL_DOWN constant, couldn't include AutoItConstants.au3 either
		Else
			Local $WM_WHEELMOUSE = 0x020A, $MK_CONTROL = 0x0008
			;Local $wParam = BitOR(BitShift($WheelRotation, -16), BitAND($MK_CONTROL, 0xFFFF)) ; HiWord = -120 WheelScrollDown, LoWord = $MK_CONTROL
			Local $wParam = BitOR($ScrollSteps * 0x10000, BitAND($MK_CONTROL, 0xFFFF)) ; HiWord = -120 WheelScrollDown, LoWord = $MK_CONTROL
			Local $lParam = BitOR(($g_aiBSpos[1] + Int($g_iDEFAULT_HEIGHT / 2)) * 0x10000, BitAND(($g_aiBSpos[0] + Int($g_iDEFAULT_WIDTH / 2)), 0xFFFF)) ; ; HiWord = y-coordinate, LoWord = x-coordinate
			;For $k = 1 To $WheelRotationCount
			_WinAPI_PostMessage($hWin, $WM_WHEELMOUSE, $wParam, $lParam)
			;Next
			$Result[2] = (@error = 0 ? 1 : 0)
		EndIf
		If _Sleep($ClickDelay) Then Return
		$Result[3] = ControlSend($hWin, "", "", "{CTRLUP}")
		SetDebugLog("ControlFocus Result = " & $Result[0] & _
				", " & $ZoomActions[1] & " = " & $Result[1] & _
				", " & $ZoomActions[2] & " = " & $Result[2] & _
				", " & $ZoomActions[3] & " = " & $Result[3], $COLOR_DEBUG)
		For $j = 1 To 3
			If $Result[$j] = 0 Then
				SetLog("Warning " & $ZoomActions[$j] & " = " & $Result[1], $COLOR_DEBUG)
				Return False
			EndIf
		Next
	Next

	If $g_bRunState = False Then Return
	Return True
EndFunc   ;==>ZoomOutCtrlWheelScroll

; SearchZoomOut returns always an Array.
; If village can be measured and villages size < 500 pixel then it returns in idx 0 a String starting with "zoomout:" and tries to center base
; Return Array:
; 0 = Empty string if village cannot be measured (e.g. window blocks village or not zoomed out)
; 1 = Current Village X Offset (after centering village)
; 2 = Current Village Y Offset (after centering village)
; 3 = Difference of previous Village X Offset and current (after centering village)
; 4 = Difference of previous Village Y Offset and current (after centering village)
Func SearchZoomOut($CenterVillageBoolOrScrollPos = $aCenterHomeVillageClickDrag, $UpdateMyVillage = True, $sSource = "", $CaptureRegion = True, $DebugLog = $g_bDebugSetlog, $bBBAttack = False)
	FuncEnter(SearchZoomOut)
	Local $aResultSafe = ["", 0, 0, 0, 0] ; expected dummy value
	Local $aResult = _SearchZoomOut($CenterVillageBoolOrScrollPos, $UpdateMyVillage, $sSource, $CaptureRegion, $DebugLog, $bBBAttack)
	If UBound($aResult) >= 5 And Not @error Then Return $aResult
	Return FuncReturn($aResultSafe)
EndFunc   ;==>SearchZoomOut

Func _SearchZoomOut($CenterVillageBoolOrScrollPos = $aCenterHomeVillageClickDrag, $UpdateMyVillage = True, $sSource = "", $CaptureRegion = True, $DebugLog = $g_bDebugSetlog, $bBBAttack = False)
	If Not $g_bRunState Then Return
	If $CaptureRegion Then _CaptureRegion2()

	Local $bOnBuilderBase = $bBBAttack Or isOnBuilderBase($CaptureRegion)
	; If $bOnBuilderBase Then Return SearchZoomOutBB($UpdateMyVillage, $sSource, $CaptureRegion, $DebugLog, $bDebugWithImage)

	If $sSource <> "" Then $sSource = " (" & $sSource & ")"
	Local $bCenterVillage = $CenterVillageBoolOrScrollPos
	If $bCenterVillage = Default Or $g_bDebugDisableVillageCentering Then $bCenterVillage = (Not $g_bDebugDisableVillageCentering)
	Local $aScrollPos[2] = [0, 0]
	If UBound($CenterVillageBoolOrScrollPos) >= 2 Then
		$aScrollPos[0] = $CenterVillageBoolOrScrollPos[0]
		$aScrollPos[1] = $CenterVillageBoolOrScrollPos[1]
		$bCenterVillage = (Not $g_bDebugDisableVillageCentering)
	EndIf

	; Setup arrays, including default return values for $return
	Local $x, $y, $z, $stone[2]
	Local $villageSize = 0

	Local $aResult = ["", 0, 0, 0, 0] ; expected dummy value

	Static $iCallCount = 0
	$g_aFallbackDragFix = -1

	Local $village

	$village = GetVillageSize($DebugLog, "stone", "tree", Default, $bOnBuilderBase, $CaptureRegion, $bCenterVillage = False)

	If $g_aiSearchZoomOutCounter[0] > 0 Then
		If _Sleep(1000) Then
			$iCallCount = 0
			Return FuncReturn($aResult)
		EndIf
	EndIf

	If IsArray($village) = 1 Then
		$villageSize = $village[0]
		If $villageSize < 750 Or $g_bDebugDisableZoomout Then ; xbebenk
			$z = $village[1]
			$x = $village[2]
			$y = $village[3]
			$stone[0] = $village[4]
			$stone[1] = $village[5]
			$aResult[0] = "zoomout:" & $village[6]
			$aResult[1] = $x
			$aResult[2] = $y
			$g_bAndroidZoomoutModeFallback = False


			If $bCenterVillage And ($x <> 0 Or $y <> 0) And ($UpdateMyVillage = False Or $x <> $g_iVILLAGE_OFFSET[0] Or $y <> $g_iVILLAGE_OFFSET[1]) Then
				If $DebugLog Then SetDebugLog("Center Village" & $sSource & " by: " & $x & ", " & $y)
				If $aScrollPos[0] = 0 And $aScrollPos[1] = 0 Then
					;$aScrollPos[0] = $stone[0]
					;$aScrollPos[1] = $stone[1]
					; use fixed position now to prevent boat activation
					$aScrollPos[0] = $aCenterHomeVillageClickDrag[0]
					$aScrollPos[1] = $aCenterHomeVillageClickDrag[1]
				EndIf

				If $bBBAttack = False Then ClickAway()

				If Pixel_Distance($aScrollPos[0], $aScrollPos[1], $aScrollPos[0] - $x, $aScrollPos[1] - $y) > 15 Then
					ClickDrag($aScrollPos[0], $aScrollPos[1], $aScrollPos[0] - $x, $aScrollPos[1] - $y)
				EndIf

				If _Sleep(250) Then
					$iCallCount = 0
					Return FuncReturn($aResult)
				EndIf

				Local $aResult2 = SearchZoomOut(False, $UpdateMyVillage, "SearchZoomOut(1):" & $sSource, True, $DebugLog, $bBBAttack)
				; update difference in offset
				$aResult2[3] = $aResult2[1] - $aResult[1]
				$aResult2[4] = $aResult2[2] - $aResult[2]
				If $DebugLog Then SetDebugLog("Centered Village Offset" & $sSource & ": " & $aResult2[1] & ", " & $aResult2[2] & ", change: " & $aResult2[3] & ", " & $aResult2[4])
				$iCallCount = 0
				Return FuncReturn($aResult2)
			EndIf

			If $UpdateMyVillage Then
				If $x <> $g_iVILLAGE_OFFSET[0] Or $y <> $g_iVILLAGE_OFFSET[1] Or $z <> $g_iVILLAGE_OFFSET[2] Then
					If $DebugLog Then SetDebugLog("Village Offset" & $sSource & " updated to " & $x & ", " & $y & ", " & $z)
				EndIf
				setVillageOffset($x, $y, $z)
				ConvertInternalExternArea("SearchZoomOut", $DebugLog) ; generate correct internal/external diamond measures
			Else
			EndIf
		EndIf
	ElseIf $g_aFallbackDragFix <> -1 And UBound($g_aFallbackDragFix) >= 5 And Not @error Then
		If $aScrollPos[0] = 0 And $aScrollPos[1] = 0 Then
			; use fixed position now to prevent boat activation
			$aScrollPos[0] = $aCenterHomeVillageClickDrag[0]
			$aScrollPos[1] = $aCenterHomeVillageClickDrag[1]
		EndIf

		Local $iDragFix = ($g_aFallbackDragFix[2] - $g_aFallbackDragFix[1])
		If Abs($iDragFix) > 150 Then $iDragFix = Ceiling($iDragFix / 2)
		If $bOnBuilderBase Then $iDragFix *= -1

		; Tree
		If $g_aFallbackDragFix[4] = "Tree" Then
			ClickDrag($aScrollPos[0], $aScrollPos[1], $aScrollPos[0] + _Min(Abs($g_aFallbackDragFix[0] - $g_aFallbackDragFix[2]), 150), $aScrollPos[1] + $iDragFix)
			SetLog("Centering village (tree)", $COLOR_ACTION)
			; Stone
		ElseIf $g_aFallbackDragFix[4] = "Stone" Then
			ClickDrag($aScrollPos[0], $aScrollPos[1], $aScrollPos[0] - _Min(Abs($g_aFallbackDragFix[0] - $g_aFallbackDragFix[2]), 150), $aScrollPos[1] + ($g_aFallbackDragFix[3] - $g_aFallbackDragFix[1]))
			SetLog("Centering village (stone)", $COLOR_ACTION)
			; None
		ElseIf $g_aFallbackDragFix[4] = "None" Then
			ClickDrag($g_aFallbackDragFix[0], $g_aFallbackDragFix[1], $g_aFallbackDragFix[2], $g_aFallbackDragFix[3])
			SetLog("Centering village (none)", $COLOR_ACTION)
		EndIf

		; force additional zoom-out
		$g_aiSearchZoomOutCounter[1] -= 1
		$aResult[0] = ""

		$g_aFallbackDragFix = -1
		Return $aResult
	EndIf

	If $bCenterVillage And Not $g_bZoomoutFailureNotRestartingAnything And Not $g_bAndroidZoomoutModeFallback Then
		If $aResult[0] = "" Then
			If $g_aiSearchZoomOutCounter[0] > 25 Then
				$g_aiSearchZoomOutCounter[0] = 0
				$iCallCount += 1
				If $iCallCount <= 1 Then
					;CloseCoC(True)
					SetLog("Restart CoC to reset zoom" & $sSource & "...", $COLOR_INFO)
					PoliteCloseCoC("Zoomout" & $sSource)
					If _Sleep(1000) Then
						$iCallCount = 0
						Return FuncReturn($aResult)
					EndIf
					CloseCoC() ; ensure CoC is gone
					OpenCoC()

					waitMainScreen()

					Return FuncReturn(SearchZoomOut($CenterVillageBoolOrScrollPos, $UpdateMyVillage, "SearchZoomOut(2):" & $sSource, True, $DebugLog, $bBBAttack))
				Else
					SetLog("Restart Android to reset zoom" & $sSource & "...", $COLOR_INFO)
					$iCallCount = 0
					RebootAndroid()
					If _Sleep(1000) Then
						$iCallCount = 0
						Return FuncReturn($aResult)
					EndIf

					waitMainScreen()

					$aResult = SearchZoomOut($CenterVillageBoolOrScrollPos, $UpdateMyVillage, "SearchZoomOut(2):" & $sSource, True, $DebugLog, $bBBAttack)
					Return FuncReturn($aResult)
				EndIf
			Else
				; failed to find village
				$g_aiSearchZoomOutCounter[0] += 1
				Return FuncReturn(SearchZoomOut($CenterVillageBoolOrScrollPos, $UpdateMyVillage, "SearchZoomOut(3):" & $sSource, True, $DebugLog, $bBBAttack))
			EndIf
		Else
			If Not $g_bDebugDisableZoomout And $villageSize > 480 Then
				If Not $g_bSkipFirstZoomout Then
					; force additional zoom-out
					$aResult[0] = ""
				ElseIf $g_aiSearchZoomOutCounter[1] > 0 And $g_aiSearchZoomOutCounter[0] > 0 Then
					; force additional zoom-out
					$g_aiSearchZoomOutCounter[1] -= 1
					$aResult[0] = ""
				EndIf
			EndIf
		EndIf
		$g_bSkipFirstZoomout = True
	EndIf

	Return $aResult
EndFunc   ;==>_SearchZoomOut
