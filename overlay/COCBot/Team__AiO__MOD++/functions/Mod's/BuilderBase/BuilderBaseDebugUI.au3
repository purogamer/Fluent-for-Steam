; #FUNCTION# ====================================================================================================================
; Name ..........: DebugUI
; Description ...: Debug GUI
; Syntax ........: DebugUI()
; Parameters ....:
; Return values .: None
; Author ........: ProMac (03-2018), Fahid.Mahmood
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as Mybot and ClashGameBot. Copyright 2015-2018
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include <WinAPIDlg.au3>

Global $g_hDegubUiForm = 0, $g_hlblSourceStatus = 0, $g_hPicLoaded = 0, $g_hGraphics = 0, $g_cmbBuildings = 0
Global $g_sPath2Image = ""
Global $g_frmGuiDebug = 0, $g_lblDebugOnScreen = 0, $btnDebufOSI = 0, $btnDebufOSE = 0

Func DebugUI()

	If $g_hDegubUiForm <> 0 Then Return

	; Variables
	Local $btnLoadImageSource = 0, $lblSourceImage = 0, $btnClose = 0, $btnFillArmy = 0, _
			$btnAllLoop = 0, $btnZoom = 0, $btnDeploy = 0, $btnHall = 0, $btnDrop = 0, _
			$btnAttackBar = 0, $btnCSV = 0, $btnIMG = 0, $btnClockTower = 0, _
			$btnUpgradeWall = 0, $btnMachine = 0, $btnSmartAttack

	Local $x = 10, $y = 20
	; GUI
	$g_hDegubUiForm = GUICreate("MyBotRun Builder Base DebugUI", 440, 320, -1, -1, $WS_BORDER)

	GUICtrlCreateGroup("Debug tests at Emulator", 3, 0, 430, 135)

	$btnAllLoop = GUICtrlCreateButton("Idle loop", $x, $y, 75, 25, $WS_GROUP)
	GUICtrlSetOnEvent($btnAllLoop, "TestBuilderBase")

	$g_cmbBuildings = GUICtrlCreateCombo("", $x + 15 + 75 + 75 + 75, $y, 125, 20)
	GUICtrlSetData($g_cmbBuildings, "AirDefense|Crusher|GuardPost|Cannon|BuilderHall", "Crusher")

	$y += 30
	; First Row
	;	$btnLab = GUICtrlCreateButton("UpgTroop", $x, $y, 75, 25, $WS_GROUP)
	;		GUICtrlSetOnEvent($btnLab, "TestBBUpgradeTroops")
	;$x += 75
	;	$btnSize = GUICtrlCreateButton("UpgBuild", $x, $y, 75, 25, $WS_GROUP)
	;		GUICtrlSetOnEvent($btnSize, "TestBBUpgradeBuilding")
	$btnSmartAttack = GUICtrlCreateButton("AttackBB", $x, $y, 75, 25, $WS_GROUP)
	GUICtrlSetOnEvent($btnSmartAttack, "TestBuilderBaseAttackBB")
	$x += 75
	$btnHall = GUICtrlCreateButton("BuilderHall", $x, $y, 75, 25, $WS_GROUP)
	GUICtrlSetOnEvent($btnHall, "TestUpdateBHPos")
	$x += 75
	$btnDrop = GUICtrlCreateButton("Attack (MAIN).", $x, $y, 75, 25, $WS_GROUP)
	GUICtrlSetOnEvent($btnDrop, "TestBuilderBaseAttack")
	$x += 75
	$btnCSV = GUICtrlCreateButton("CSV", $x, $y, 60, 25, $WS_GROUP)
	GUICtrlSetOnEvent($btnCSV, "TestBuilderBaseParseAttackCSV")
	$x += 60
	;	$btnCleanYard = GUICtrlCreateButton("Clean Yard", $x, $y, 60, 25, $WS_GROUP)
	;		GUICtrlSetOnEvent($btnCleanYard, "TestrunCleanYardBB")
	$y += 25
	$x = 10
	; Second Row
	$btnFillArmy = GUICtrlCreateButton("Fill Army", $x, $y, 75, 25, $WS_GROUP)
	GUICtrlSetOnEvent($btnFillArmy, "TestCheckArmyBuilderBase")
	$x += 75
	$btnZoom = GUICtrlCreateButton("ZoomOut", $x, $y, 75, 25, $WS_GROUP)
	GUICtrlSetOnEvent($btnZoom, "TestBuilderBaseZoomOut")
	$x += 75
	$btnDeploy = GUICtrlCreateButton("Deploy P.", $x, $y, 75, 25, $WS_GROUP)
	GUICtrlSetOnEvent($btnDeploy, "TestBuilderBaseGetDeployPoints")
	$x += 75
	$btnAttackBar = GUICtrlCreateButton("AttackBar", $x, $y, 75, 25, $WS_GROUP)
	GUICtrlSetOnEvent($btnAttackBar, "TestGetAttackBarBB")
	$x += 75
	$btnIMG = GUICtrlCreateButton("Collect", $x, $y, 60, 25, $WS_GROUP)
	GUICtrlSetOnEvent($btnIMG, "CollectBuilderBase")
	$x += 60
	$btnClockTower = GUICtrlCreateButton("ClkTower", $x, $y, 60, 25, $WS_GROUP)
	GUICtrlSetOnEvent($btnClockTower, "TestStartClockTowerBoost")

	$y += 25
	$x = 10
	; 3 Row
	$btnUpgradeWall = GUICtrlCreateButton("UpgradeWall", $x, $y, 75, 25, $WS_GROUP)
	GUICtrlSetOnEvent($btnUpgradeWall, "TestRunWallsUpgradeBB")
	$x += 75
	$btnMachine = GUICtrlCreateButton("BattleMachine", $x, $y, 75, 25, $WS_GROUP)
	GUICtrlSetOnEvent($btnMachine, "TestBattleMachineUpgrade")

	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$y += 35
	$x = 10

	GUICtrlCreateGroup("Debug tests on Images", 3, $y, 430, 155)
	$y += 15
	$lblSourceImage = GUICtrlCreateLabel("ScreenCapture", $x, $y, 75, 17)
	$y += 15
	$btnLoadImageSource = GUICtrlCreateButton("Load Image", $x, $y, 75, 25, $WS_GROUP)
	GUICtrlSetOnEvent($btnLoadImageSource, "LoadImageFile")

	$g_hlblSourceStatus = GUICtrlCreateLabel("Empty", 98, $y + 4, 100, 17)
	$y += 25
	$btnDebufOSI = GUICtrlCreateButton("Debug OS", $x, $y, 75, 25, $WS_GROUP)
	GUICtrlSetOnEvent($btnDebufOSI, "GuiDebug")

	$btnDebufOSE = GUICtrlCreateButton("Debug Exit", $x + 80, $y, 75, 25, $WS_GROUP)
	GUICtrlSetOnEvent($btnDebufOSE, "GuiDebugEnds")

	$btnClose = GUICtrlCreateButton("Exit", $x, 235, 75, 25, $WS_GROUP)
	GUICtrlSetOnEvent($btnClose, "CloseDebugUI")
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	GUISetState(@SW_SHOW)

EndFunc   ;==>DebugUI

Func CloseDebugUI()
	If $g_hDegubUiForm = 0 Then Return
	GUIDelete($g_hDegubUiForm)
	_GDIPlus_GraphicsDispose($g_hGraphics)
	$g_hDegubUiForm = 0
	If $g_frmGuiDebug = 0 Then Return
	GUIDelete($g_frmGuiDebug)
	$g_frmGuiDebug = 0
EndFunc   ;==>CloseDebugUI

Func LoadImageFile()
	$g_sPath2Image = _WinAPI_OpenFileDlg('Open Image File', @ScriptDir, 'png Files (*.png)|All Files (*.*)', 1)
	If @error Then
		$g_sPath2Image = ""
		GUICtrlSetData($g_hlblSourceStatus, "Error loading File")
	EndIf
	GUICtrlSetData($g_hlblSourceStatus, "Image loaded")
	PlaceImage($g_sPath2Image)
EndFunc   ;==>LoadImageFile

Func PlaceImage($sFile)
	Local $hBmp = ScaleImage($sFile, 172, 147, 7)
	$g_hGraphics = _GDIPlus_GraphicsCreateFromHWND($g_hDegubUiForm)
	_GDIPlus_GraphicsDrawImage($g_hGraphics, $hBmp, 223, 116)
	_GDIPlus_BitmapDispose($hBmp)
EndFunc   ;==>PlaceImage

Func ScaleImage($sFile, $iNewWidth, $iNewHeight, $iInterpolationMode = 7)
	If Not FileExists($sFile) Then Return SetError(1, 0, 0)
	Local $hImage = _GDIPlus_ImageLoadFromFile($sFile)
	If @error Then Return SetError(2, 0, 0)
	Local $iWidth = _GDIPlus_ImageGetWidth($hImage)
	Local $iHeight = _GDIPlus_ImageGetHeight($hImage)

	Local $iW, $iH, $f, $fRatio

	If $iWidth > $iHeight Then
		$f = $iWidth / $iNewWidth
	Else
		$f = $iHeight / $iNewHeight
	EndIf
	$iW = Int($iWidth / $f)
	$iH = Int($iHeight / $f)

	If $iW > $iNewWidth Then
		$fRatio = $iNewWidth / $iW
		$iW = Int($iW * $fRatio)
		$iH = Int($iH * $fRatio)
	ElseIf $iH > $iNewHeight Then
		$fRatio = $iNewHeight / $iH
		$iW = Int($iW * $fRatio)
		$iH = Int($iH * $fRatio)
	EndIf

	Local $hBitmap = DllCall($__g_hGDIPDll, "uint", "GdipCreateBitmapFromScan0", "int", $iW, "int", $iH, "int", 0, "int", 0x0026200A, "ptr", 0, "int*", 0)
	If @error Then Return SetError(3, 0, 0)
	$hBitmap = $hBitmap[6]
	Local $hBmpCtxt = _GDIPlus_ImageGetGraphicsContext($hBitmap)
	DllCall($__g_hGDIPDll, "uint", "GdipSetInterpolationMode", "handle", $hBmpCtxt, "int", $iInterpolationMode)
	_GDIPlus_GraphicsDrawImageRect($hBmpCtxt, $hImage, 0, 0, $iW, $iH)
	_GDIPlus_ImageDispose($hImage)
	_GDIPlus_GraphicsDispose($hBmpCtxt)
	Return $hBitmap
EndFunc   ;==>ScaleImage


;;; ONSCREEN ;;

Func GuiDebug()

	$g_frmGuiDebug = GUICreate("DEBUG-IMAGE ONSCREEN @ Boludoz 2018 ", 860, 644, -1, -1, -1, $WS_EX_LAYERED)
	GUISetIcon($g_sLibIconPath, $eIcnGUI)
	;$g_lblDebugOnScreen = GUICtrlCreateLabel(" ::INFO:: ", 10, 10, -1, -1, -1, $GUI_WS_EX_PARENTDRAG)
	GUISetBkColor(0xABCDEF)
	_WinAPI_SetLayeredWindowAttributes($g_frmGuiDebug, 0xABCDEF)
	;GUISetStyle($WS_POPUP, -1, $g_frmGuiDebug)
	GUISetState(@SW_SHOW)
	WinSetOnTop($g_frmGuiDebug, "", $WINDOWS_ONTOP)
	MoveGUIDebug()

EndFunc   ;==>GuiDebug

Func GuiDebugEnds()
	If $g_frmGuiDebug = 0 Then Return
	GUIDelete($g_frmGuiDebug)
	$g_frmGuiDebug = 0
EndFunc   ;==>GuiDebugEnds

Func _UIA_Debug($DebugImage, $color = 0x0000FF, $PenWidth = 4)

	If $g_frmGuiDebug = 0 Then Return

	GUISetBkColor(0xABCDEF, $g_frmGuiDebug)
	_WinAPI_RedrawWindow($g_frmGuiDebug, 0, 0, $RDW_INVALIDATE + $RDW_ALLCHILDREN)
	MoveGUIDebug()

	Local $offset = $g_iAndroidWindowHeight - $g_iAndroidClientHeight

	Local $hDC = _WinAPI_GetWindowDC($g_frmGuiDebug) ; DC of entire screen (desktop)
	Local $hPen = _WinAPI_CreatePen($PS_SOLID, $PenWidth, $color) ; BGR
	Local $obj_orig = _WinAPI_SelectObject($hDC, $hPen)

	; [xx][0] = X , [1] = Y , [2] = Name
	For $z = 0 To UBound($DebugImage) - 1

		Local $tX = $DebugImage[$z][0]
		Local $tY = $DebugImage[$z][1]

		Local $x1 = $tX - 5
		Local $y1 = $tY - 5 + $offset
		Local $x2 = $x1 + 10
		Local $y2 = $y1 + 10

		Local $g_tRECT = DllStructCreate($tagRect)
		DllStructSetData($g_tRECT, "Left", $x1)
		DllStructSetData($g_tRECT, "Top", $y1 + 20)
		DllStructSetData($g_tRECT, "Right", $x1 + 200)
		DllStructSetData($g_tRECT, "Bottom", $y1 + 45)

		_WinAPI_DrawLine($hDC, $x1, $y1, $x2, $y1) ; horizontal to right
		_WinAPI_DrawLine($hDC, $x2, $y1, $x2, $y2) ; vertical down on right
		_WinAPI_DrawLine($hDC, $x2, $y2, $x1, $y2) ; horizontal to left right
		_WinAPI_DrawLine($hDC, $x1, $y2, $x1, $y1) ; vertical up on left
		_WinAPI_DrawText($hDC, $DebugImage[$z][2] & "(" & $tX & "," & $tY & ")", $g_tRECT, $DT_LEFT)
	Next

	; clear resources
	_WinAPI_SelectObject($hDC, $obj_orig)
	_WinAPI_DeleteObject($hPen)
	_WinAPI_ReleaseDC(0, $hDC)
	;_WinAPI_InvalidateRect($Handle, 0)
	;$g_tRECT = 0

EndFunc   ;==>_UIA_Debug


Func MoveGUIDebug()
	If $g_frmGuiDebug = 0 Then Return
	WinMove($g_frmGuiDebug, "", $g_iAndroidPosX, $g_iAndroidPosY, $g_iAndroidClientWidth, $g_iAndroidClientHeight + 30)
EndFunc   ;==>MoveGUIDebug
