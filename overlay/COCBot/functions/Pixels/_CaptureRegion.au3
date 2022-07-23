; #FUNCTION# ====================================================================================================================
; Name ..........: _CaptureRegion
; Description ...: Saves a screenshot of the window into memory. Updates bitmap "$g_hBitmap" and bitmpa DC "$g_hHBitmap" Global handles
; Syntax ........: _CaptureRegion([$iLeft = 0[, $iTop = 0[, $iRight = $g_iGAME_WIDTH[, $iBottom = $g_iGAME_HEIGHT[, $ReturnBMP[,
;                  $ReturnLocal_hHBitmap = False]]]]]])
; Parameters ....: $iLeft               - [optional] an integer value. Default is 0.
;                  $iTop                - [optional] an integer value. Default is 0.
;                  $iRight              - [optional] an integer value. Default is $g_iGAME_WIDTH.
;                  $iBottom             - [optional] an integer value. Default is $g_iGAME_HEIGHT.
;                  $ReturnBMP           - DEPRECATED! [optional] an boolean value. Default is False.
;                  $ReturnLocal_hHBitmap- [optional] an boolean value. Default is False, if True no global variables are changed
;                                         and Local $_hHBitmap is returned.
; Return values .: None
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func _CaptureRegion(Const $iLeft = 0, Const $iTop = 0, Const $iRight = $g_iGAME_WIDTH, Const $iBottom = $g_iGAME_HEIGHT, Const $ReturnLocal_hHBitmap = False)

	If $ReturnLocal_hHBitmap Then
		; Custom fix - Team AIO Mod++
		Static $_hHBitmap = 0
		If $_hHBitmap <> 0 Then GdiDeleteHBitmap($_hHBitmap)
		_CaptureGameScreen($_hHBitmap, $iLeft, $iTop, $iRight, $iBottom)
		Return $_hHBitmap
	EndIf

	If $g_hHBitmap <> 0 And $g_hHBitmap <> $g_hHBitmapTest And $g_hHBitmap2 <> $g_hHBitmap Then
		GdiDeleteHBitmap($g_hHBitmap)
	EndIf
	_CaptureGameScreen($g_hHBitmap, $iLeft, $iTop, $iRight, $iBottom)

	If $g_hBitmap <> 0 Then
		GdiDeleteBitmap($g_hBitmap)
	EndIf
	$g_hBitmap = _GDIPlus_BitmapCreateFromHBITMAP($g_hHBitmap)
	GdiAddBitmap($g_hBitmap)

	Return $g_hHBitmap

EndFunc   ;==>_CaptureRegion

; #FUNCTION# ====================================================================================================================
; Name ..........: _CaptureRegion2
; Description ...: Saves emulator screen shot into memory - updates global handle "$g_hHBitmap2" to bitmap new object
; Syntax ........: _CaptureRegion2([$iLeft = 0[, $iTop = 0[, $iRight = $g_iGAME_WIDTH[, $iBottom = $g_iGAME_HEIGHT]]]])
; Parameters ....: $iLeft               - [optional] an integer value. Default is 0.
;                  $iTop                - [optional] an integer value. Default is 0.
;                  $iRight              - [optional] an integer value. Default is $g_iGAME_WIDTH.
;                  $iBottom             - [optional] an integer value. Default is $g_iGAME_HEIGHT.
; Return values .: None
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func _CaptureRegion2(Const $iLeft = 0, Const $iTop = 0, Const $iRight = $g_iGAME_WIDTH, Const $iBottom = $g_iGAME_HEIGHT)

	If $g_hHBitmap2 <> 0 And $g_hHBitmap2 <> $g_hHBitmapTest And $g_hHBitmap2 <> $g_hHBitmap Then
		GdiDeleteHBitmap($g_hHBitmap2)
	EndIf
	_CaptureGameScreen($g_hHBitmap2, $iLeft, $iTop, $iRight, $iBottom)

EndFunc   ;==>_CaptureRegion2

; #FUNCTION# ====================================================================================================================
; Name ..........: _CaptureGameScreen
; Description ...: Saves a screenshot of the window into memory.
; Syntax ........: _CaptureGameScreen($_hHBitmap, [$iLeft = 0[, $iTop = 0[, $iRight = $g_iGAME_WIDTH[, $iBottom = $g_iGAME_HEIGHT]]]])
; Parameters ....: $_hHBitmap           - ByRef variable receiving the HBitmap
;                  $iLeft               - [optional] an integer value. Default is 0.
;                  $iTop                - [optional] an integer value. Default is 0.
;                  $iRight              - [optional] an integer value. Default is $g_iGAME_WIDTH.
;                  $iBottom             - [optional] an integer value. Default is $g_iGAME_HEIGHT.
; Return values .: None
; Author ........: cosote 2017-Feb
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func _CaptureGameScreen(ByRef $_hHBitmap, Const $iLeft = 0, Const $iTop = 0, Const $iRight = $g_iGAME_WIDTH, Const $iBottom = $g_iGAME_HEIGHT)
	If $g_bExecuteCapture = True Then 
		Local $hBMP = 0, $hHBMP = 0
		Local $sImageFile = FileOpenDialog("Select screenshot to test, cancel to use live screenshot | Called measurements : " & $iLeft & ", " & $iTop & ", " & $iRight & ", " & $iBottom, $g_sProfileTempPath, "Image (*.png)", $FD_FILEMUSTEXIST, "", $g_hFrmBot)
		If @error = 0 Then
			SetLog("Testing image " & $sImageFile, $COLOR_INFO)
			; load test image
			$hBMP = _GDIPlus_BitmapCreateFromFile($sImageFile)
			$_hHBitmap = _GDIPlus_BitmapCreateDIBFromBitmap($hBMP)
			_GDIPlus_BitmapDispose($hBMP)
			Local $hHBitmap_full = $_hHBitmap
			$_hHBitmap = GetHHBitmapArea($_hHBitmap, $iLeft, $iTop, $iRight, $iBottom)
			_WinAPI_DeleteObject($hHBitmap_full)
			Return
		Else
			$g_bExecuteCapture = False
		EndIf
	EndIf
	
	Local $SuspendMode

	If $g_hHBitmapTest = 0 Then
		If $g_bRunState Then CheckAndroidRunning() ; Ensure Android is running
		Local $iL = $iLeft, $iT = $iTop, $iR = $iRight, $iB = $iBottom
		Local $iW = Number($iR) - Number($iL), $iH = Number($iB) - Number($iT)
		Local $bDebugAlwaysSaveFullScreenTimer = False
		If Not $g_hDebugAlwaysSaveFullScreenTimer = 0 Then
			If __TimerDiff($g_hDebugAlwaysSaveFullScreenTimer) < 300000 Then
				$bDebugAlwaysSaveFullScreenTimer = True
				$iL = 0
				$iT = 0
				$iR = $g_iGAME_WIDTH
				$iB = $g_iGAME_HEIGHT
				$iW = Number($iR) - Number($iL)
				$iH = Number($iB) - Number($iT)
			Else
				SetLog("Disable $g_hDebugAlwaysSaveFullScreenTimer")
				$g_hDebugAlwaysSaveFullScreenTimer = 0
			EndIf
		EndIf
		If $g_bChkBackgroundMode = True Then
			If $g_bAndroidAdbScreencap = True Then
				$_hHBitmap = AndroidScreencap($iL, $iT, $iW, $iH)
				Local $iError = @error
				If $iError <> 0 Then
					SetLog("AndroidScreencap error : " & $iError, $COLOR_ERROR)
				EndIf
			Else
				$SuspendMode = ResumeAndroid(False)
				; Local $hCtrl = ControlGetHandle($g_hAndroidWindow, $g_sAppPaneName, $g_sAppClassInstance)
				Local $hCtrl = ControlGetHandle(GetCurrentAndroidHWnD(), $g_sAppPaneName, $g_sAppClassInstance)
				If $hCtrl = 0 Then
					SetLog("AndroidHandle not found, contact support", $COLOR_ERROR)
				EndIf
				Local $hDC_Capture = _WinAPI_GetDC($hCtrl)
				Local $hMemDC = _WinAPI_CreateCompatibleDC($hDC_Capture)
				$_hHBitmap = _WinAPI_CreateCompatibleBitmap($hDC_Capture, $iW, $iH)
				Local $hObjectOld = _WinAPI_SelectObject($hMemDC, $_hHBitmap)

				Local $flags = 0
				;If StringInStr($g_sAndroidEmulator, "Bluestacks") > 0 And 9600 <= @OSBuild Then $flags = 2 ; Custom - Team AIO Mod++
				; $PW_CLIENTONLY = 1 ; Only the client area of the window is copied to hdcBlt. By default, the entire window is copied.
				; $PW_RENDERFULLCONTENT = 2 ; New in Windows 8.1, suppost to capture DirectX/OpenGL screens through DWM (but didn't work for MEmu)
				DllCall("user32.dll", "int", "PrintWindow", "hwnd", $hCtrl, "handle", $hMemDC, "int", $flags)
				_WinAPI_SelectObject($hMemDC, $_hHBitmap)
				_WinAPI_BitBlt($hMemDC, 0, 0, $iW, $iH, $hDC_Capture, $iL, $iT, $SRCCOPY)

				_WinAPI_DeleteDC($hMemDC)
				_WinAPI_SelectObject($hMemDC, $hObjectOld)
				_WinAPI_ReleaseDC($hCtrl, $hDC_Capture)
				SuspendAndroid($SuspendMode, False)
			EndIf
		Else
			getBSPos()
			$SuspendMode = ResumeAndroid(False)
			$_hHBitmap = _ScreenCapture_Capture("", $iL + $g_aiBSpos[0], $iT + $g_aiBSpos[1], $iR + $g_aiBSpos[0] - 1, $iB + $g_aiBSpos[1] - 1, False)
			SuspendAndroid($SuspendMode, False)
		EndIf

		If $bDebugAlwaysSaveFullScreenTimer = True Then
			; save full screen
			Local $sDateTime = @YEAR & "-" & @MON & "-" & @MDAY & "_" & @HOUR & "-" & @MIN & "-" & @SEC & "." & @MSEC
			Local $hBitmap_full = _GDIPlus_BitmapCreateFromHBITMAP($_hHBitmap)
			SetDebugLog("Save full screen: " & $g_sProfileTempDebugPath & "FullScreen_" & $sDateTime & ".png")
			_GDIPlus_ImageSaveToFile($hBitmap_full, $g_sProfileTempDebugPath & "FullScreen_" & $sDateTime & ".png")
			_GDIPlus_BitmapDispose($hBitmap_full)
			If $iLeft > 0 Or $iTop > 0 Or $iRight < $g_iGAME_WIDTH Or $iBottom < $g_iGAME_HEIGHT Then
				; create requested image size
				Local $hHBitmap_full = $_hHBitmap
				$_hHBitmap = GetHHBitmapArea($_hHBitmap, $iLeft, $iTop, $iRight, $iBottom)
				_WinAPI_DeleteObject($hHBitmap_full)
			EndIf
		EndIf
	ElseIf $iLeft > 0 Or $iTop > 0 Or $iRight < $g_iGAME_WIDTH Or $iBottom < $g_iGAME_HEIGHT Then
		; resize test image
		$_hHBitmap = GetHHBitmapArea($g_hHBitmapTest, $iLeft, $iTop, $iRight, $iBottom)
	Else
		; use test image
		$_hHBitmap = $g_hHBitmapTest
	EndIf

	GdiAddHBitmap($_hHBitmap)

	$g_bForceCapture = False
EndFunc   ;==>_CaptureGameScreen

; #FUNCTION# ====================================================================================================================
; Name ..........: _CaptureDispose
; Description ...: Disposes all bitmaps created by _CaptureRegion functions
; Syntax ........: _CaptureDispose()
; Parameters ....: None
; Return values .: None
; Author ........: cosote (Feb-2017)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func _CaptureDispose()
	If $g_hBitmap <> 0 Then GdiDeleteBitmap($g_hBitmap)
	If $g_hHBitmap <> 0 Then GdiDeleteHBitmap($g_hHBitmap)
	If $g_hHBitmap2 <> 0 Then GdiDeleteHBitmap($g_hHBitmap2)
	If $g_hHBitmapTest <> 0 Then GdiDeleteHBitmap($g_hHBitmapTest)
	$g_hBitmap = 0
	$g_hHBitmap = 0
	$g_hHBitmap2 = 0
	$g_hHBitmapTest = 0
EndFunc   ;==>_CaptureDispose

; #FUNCTION# ====================================================================================================================
; Name ..........: _CaptureRegion2Sync
; Description ...: Updates $g_hHBitmap2 from $g_hHBitmap
; Syntax ........: _CaptureRegion2Sync()
; Parameters ....: None
; Return values .: None
; Author ........: cosote
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func _CaptureRegion2Sync()
	If $g_hHBitmap2 <> 0 And $g_hHBitmap2 <> $g_hHBitmapTest And $g_hHBitmap2 <> $g_hHBitmap Then
		GdiDeleteHBitmap($g_hHBitmap2)
	EndIf
	$g_hHBitmap2 = GetHHBitmapArea($g_hHBitmap)
EndFunc   ;==>_CaptureRegion2Sync


; #FUNCTION# ====================================================================================================================
; Name ..........: _CaptureRegions
; Description ...: Updates $g_hHBitmap and $g_hHBitmap2
; Syntax ........: _CaptureRegions()
; Parameters ....: None
; Return values .: None
; Author ........: cosote
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func _CaptureRegions()
	_CaptureRegion()
	_CaptureRegion2Sync()
	Return True
EndFunc   ;==>_CaptureRegions

; #FUNCTION# ====================================================================================================================
; Name ..........: GetHHBitmapArea
; Description ...: Creates a new hHBitmap of given $_hHBitmap in requested size
; Syntax ........: GetHHBitmapArea($_hHBitmap, [$iLeft = 0[, $iTop = 0[, $iRight = $g_iGAME_WIDTH[, $iBottom = $g_iGAME_HEIGHT]]]])
; Parameters ....: $_hHBitmap           - hHBitmap of source
;                  $iLeft               - [optional] an integer value. Default is 0.
;                  $iTop                - [optional] an integer value. Default is 0.
;                  $iRight              - [optional] an integer value. Default is $g_iGAME_WIDTH.
;                  $iBottom             - [optional] an integer value. Default is $g_iGAME_HEIGHT.
; Return values .: new hHBitmap Object of requested size
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func GetHHBitmapArea(Const ByRef $_hHBitmap, Const $iLeft = 0, Const $iTop = 0, Const $iRight = $g_iGAME_WIDTH, Const $iBottom = $g_iGAME_HEIGHT)
	Local $iW = Number($iRight) - Number($iLeft), $iH = Number($iBottom) - Number($iTop)
	Local $hDC = _WinAPI_GetDC($g_hFrmBot)
	Local $hMemDC_src = _WinAPI_CreateCompatibleDC($hDC)
	Local $hMemDC_dst = _WinAPI_CreateCompatibleDC($hDC)
	Local $_hHBitmapArea = _WinAPI_CreateCompatibleBitmap($hDC, $iW, $iH)
	Local $hObjectOld_src = _WinAPI_SelectObject($hMemDC_src, $_hHBitmap)
	Local $hObjectOld_dst = _WinAPI_SelectObject($hMemDC_dst, $_hHBitmapArea)

	_WinAPI_BitBlt($hMemDC_dst, 0, 0, $iW, $iH, $hMemDC_src, $iLeft, $iTop, $SRCCOPY)

	_WinAPI_SelectObject($hMemDC_src, $hObjectOld_src)
	_WinAPI_SelectObject($hMemDC_dst, $hObjectOld_dst)
	_WinAPI_ReleaseDC($g_hFrmBot, $hDC)
	_WinAPI_DeleteDC($hMemDC_src)
	_WinAPI_DeleteDC($hMemDC_dst)

	GdiAddHBitmap($_hHBitmapArea)

	Return $_hHBitmapArea
EndFunc   ;==>GetHHBitmapArea

; #FUNCTION# ====================================================================================================================
; Name ..........: FastCaptureRegion
; Description ...: Returns True is screencapture is using fast PrintWindow way
; Syntax ........: FastCaptureRegion()
; Parameters ....: None
; Return values .: Boolean
; Author ........: Cosote (2016-Aug)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func FastCaptureRegion()
	Return $g_bChkBackgroundMode = True And $g_bAndroidAdbScreencap = False
EndFunc   ;==>FastCaptureRegion

; #FUNCTION# ====================================================================================================================
; Name ..........: NeedCaptureRegion
; Description ...: Return True to tell routine a screen capture should be done in loops
; Syntax ........: NeedCaptureRegion($iCount)
; Parameters ....: $iCount              - An integer value. If FastCaptureRegion() is True or for every tenth count returns True.
; Return values .: Boolean
; Author ........: Cosote (2016-Aug)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func NeedCaptureRegion(Const $iCount)
	Local $bNeedCaptureRegion = FastCaptureRegion() Or Mod($iCount, 10) = 0
	Return $bNeedCaptureRegion
EndFunc   ;==>NeedCaptureRegion

; #FUNCTION# ====================================================================================================================
; Name ..........: ForceCaptureRegion
; Description ...: Forces to take a screen capture on next call to _CaptureRegion or _CaptureRegion2
; Syntax ........: ForceCaptureRegion([$bForceCapture = True])
; Parameters ....: $bForceCapture       - [optional] an boolean value. Default is True.
; Return values .: None
; Author ........: Cosote (2016-Aug)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func ForceCaptureRegion(Const $bForceCapture = True)
	$g_bForceCapture = $bForceCapture
EndFunc   ;==>ForceCaptureRegion

; #FUNCTION# ====================================================================================================================
; Name ..........: TestCapture
; Description ...: Sets or checks for test image returned by _CaptureRegion functions
; Syntax ........: TestCapture([$g_hHBitmap = Default])
; Parameters ....: $g_hHBitmap       - [optional] When Default it returns True if test image is configures or sets test image
; Return values .: True/False when checking for test image or configured test image when updated
; Author ........: Cosote (2016-Aug)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func TestCapture(Const $g_hHBitmap = Default)
	If $g_hHBitmap = Default Then Return $g_hHBitmapTest <> 0
	If $g_hHBitmapTest <> 0 Then _WinAPI_DeleteObject($g_hHBitmapTest) ; delete previous DC object using global handle
	$g_hHBitmapTest = $g_hHBitmap
	Return $g_hHBitmap
EndFunc   ;==>TestCapture

; #FUNCTION# ====================================================================================================================
; Name ..........: debugGdiHandle
; Description ...: Tracks changes on GDI Handle
; Syntax ........: debugGdiHandle("FuncName" [,$bLogAlways])
; Parameters ....: $sSource       - [optional] Function name that calls debugGdiHandle
;                : $bLogAlways    - [optional] Boolean alway log GDI Handle count
; Return values .: True/False when checking for test image or configured test image when updated
; Author ........: Cosote (2017-Feb)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func debugGdiHandle(Const $sSource, Const $bLogAlways = False)
	; track GDI count
	If $g_iDebugGDICount <> 0 Then
		Local $iCount = _WinAPI_GetGuiResources()
		If $iCount <> $g_iDebugGDICount Or $bLogAlways Then
			Local $sMsg = "GDI Handle Count: " & $iCount & " / " & ($iCount - $g_iDebugGDICount) & ", active: " & $g_oDebugGDIHandles.Count & " (" & $sSource & ")"
			$g_iDebugGDICount = $iCount
			If $g_iDebugGDICount > $g_iDebugGDICountMax Then
				$g_iDebugGDICountMax = $g_iDebugGDICount
				$sMsg &= " NEW MAX!"
			EndIf
			SetDebugLog($sMsg, Default, True)
		EndIf
	EndIf
EndFunc   ;==>debugGdiHandle

Func GdiAddBitmap(Const ByRef $_hBitmap)
	If $g_iDebugGDICount <> 0 Then
		$g_oDebugGDIHandles("Bitmap:" & $_hBitmap) = Time()
		SetDebugLog("GdiAddBitmap " & $_hBitmap, Default, True)
	EndIf
EndFunc   ;==>GdiAddBitmap

Func GdiDeleteBitmap(ByRef $_hBitmap)
	If $g_iDebugGDICount <> 0 Then SetDebugLog("_GDIPlus_BitmapDispose>: " & $_hBitmap & ", active: " & $g_oDebugGDIHandles.Count, Default, True)
	Local $Result = _GDIPlus_BitmapDispose($_hBitmap)
	If ($Result <> True Or @error) And $g_iDebugGDICount = 0 Then SetDebugLog("GdiDeleteBitmap not deleted: " & $_hBitmap, Default, True)
	If $g_iDebugGDICount <> 0 Then
		SetDebugLog("_GDIPlus_BitmapDispose<: " & $_hBitmap & " " & $Result & ", active: " & $g_oDebugGDIHandles.Count, Default, True)
		$g_oDebugGDIHandles.Remove("Bitmap:" & $_hBitmap)
		SetDebugLog("GdiDeleteBitmap " & $_hBitmap & ", active: " & $g_oDebugGDIHandles.Count, Default, True)
	EndIf
	$_hBitmap = 0
EndFunc   ;==>GdiDeleteBitmap

Func GdiAddHBitmap(Const ByRef $_hHBitmap)
	If $g_iDebugGDICount <> 0 Then
		$g_oDebugGDIHandles("HBitmap:" & $_hHBitmap) = Time()
		SetDebugLog("GdiAddHBitmap " & $_hHBitmap & ", active: " & $g_oDebugGDIHandles.Count, Default, True)
	EndIf
EndFunc   ;==>GdiAddHBitmap

Func GdiDeleteHBitmap(ByRef $_hHBitmap)
	Local $Result = _WinAPI_DeleteObject($_hHBitmap)
	If ($Result <> True Or @error) And $g_iDebugGDICount = 0 Then SetDebugLog("GdiDeleteHBitmap not deleted: " & $_hHBitmap, Default, True)
	If $g_iDebugGDICount <> 0 Then
		$g_oDebugGDIHandles.Remove("HBitmap:" & $_hHBitmap)
		SetDebugLog("GdiDeleteHBitmap " & $_hHBitmap & " " & $Result & ", active: " & $g_oDebugGDIHandles.Count, Default, True)
	EndIf
	$_hHBitmap = 0
EndFunc   ;==>GdiDeleteHBitmap

Func __GDIPlus_Startup()
	_GDIPlus_Startup()
	$g_iDebugGDICountMax = _WinAPI_GetGuiResources() ; reset count to current
	debugGdiHandle("__GDIPlus_Startup", True)
EndFunc   ;==>__GDIPlus_Startup

Func __GDIPlus_Shutdown()
	_CaptureDispose()
	Local $hDll = $__g_hGDIPDll
	_GDIPlus_Shutdown()
	_WinAPI_FreeLibrary($hDll)
	debugGdiHandle("__GDIPlus_Shutdown", True)
EndFunc   ;==>__GDIPlus_Shutdown
