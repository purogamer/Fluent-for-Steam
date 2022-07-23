; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Control
; Description ...: This file Includes all functions to current GUI
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Kychera (5-2017)
; Modified ......: NguyenAnhHD [12-2017]
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Func CustomDropOrder()
	; prevent user to open a second window impossible to close...
	GUICtrlSetState($g_hBtnCustomDropOrderDB, $GUI_DISABLE)
	GUICtrlSetState($g_hBtnCustomDropOrderAB, $GUI_DISABLE)
	GUICtrlSetState($g_hBtnCustomDropOrderDB1, $GUI_DISABLE)
	GUISetState(@SW_SHOW, $g_hGUI_DropOrder)
EndFunc   ;==>CustomDropOrder

Func CloseCustomDropOrder()
	; Delete the previous GUI and all controls.
	GUISetState(@SW_HIDE, $g_hGUI_DropOrder)
	GUICtrlSetState($g_hBtnCustomDropOrderDB, $GUI_ENABLE)
	GUICtrlSetState($g_hBtnCustomDropOrderAB, $GUI_ENABLE)
	GUICtrlSetState($g_hBtnCustomDropOrderDB1, $GUI_ENABLE)
EndFunc   ;==>CloseCustomDropOrder

Func chkDropOrder()
	GUICtrlSetState($g_hBtnRemoveDropOrder, $GUI_ENABLE)

	If GUICtrlRead($g_hChkCustomDropOrderEnable) = $GUI_CHECKED Then
		$g_bCustomDropOrderEnable = True
		GUICtrlSetBkColor($g_hBtnCustomDropOrderDB, $COLOR_GREEN)
		GUICtrlSetBkColor($g_hBtnCustomDropOrderAB, $COLOR_GREEN)
		GUICtrlSetBkColor($g_hBtnCustomDropOrderDB1, $COLOR_GREEN)
		GUICtrlSetState($g_hBtnDropOrderSet, $GUI_ENABLE)
		For $i = 0 To UBound($g_ahCmbDropOrder) - 1
			GUICtrlSetState($g_ahCmbDropOrder[$i], $GUI_ENABLE)
		Next
		If IsUseCustomDropOrder() = True Then _GUICtrlSetImage($g_ahImgDropOrderSet, $g_sLibIconPath, $eIcnRedLight)
	Else
		$g_bCustomDropOrderEnable = False
		GUICtrlSetBkColor($g_hBtnCustomDropOrderDB, $COLOR_RED)
		GUICtrlSetBkColor($g_hBtnCustomDropOrderAB, $COLOR_RED)
		GUICtrlSetBkColor($g_hBtnCustomDropOrderDB1, $COLOR_RED)
		GUICtrlSetState($g_hBtnDropOrderSet, $GUI_DISABLE) ; disable button
		;GUICtrlSetState($g_hBtnRemoveDropOrder, $GUI_DISABLE)
		For $i = 0 To UBound($g_ahCmbDropOrder) - 1
			GUICtrlSetState($g_ahCmbDropOrder[$i], $GUI_DISABLE) ; disable combo boxes
		Next
		SetDefaultDropOrderGroup(False)
	EndIf
EndFunc   ;==>chkDropOrder

Func GUIDropOrder()
	Local $bDuplicate = False
	Local $iGUI_CtrlId = @GUI_CtrlId
	Local $iCtrlIdImage = $iGUI_CtrlId + 1 ; record control ID for $g_ahImgTroopOrder[$z] based on control of combobox that called this function
	Local $iDropIndex = _GUICtrlComboBox_GetCurSel($iGUI_CtrlId) + 1 ; find zero based index number of troop selected in combo box, add one for enum of proper icon

	_GUICtrlSetImage($iCtrlIdImage, $g_sLibIconPath, $g_aiDropOrderIcon[$iDropIndex]) ; set proper troop icon

	For $i = 0 To UBound($g_ahCmbDropOrder) - 1 ; check for duplicate combobox index and flag problem
		If $iGUI_CtrlId = $g_ahCmbDropOrder[$i] Then ContinueLoop
		If _GUICtrlComboBox_GetCurSel($iGUI_CtrlId) = _GUICtrlComboBox_GetCurSel($g_ahCmbDropOrder[$i]) Then
			_GUICtrlSetImage($g_ahImgDropOrder[$i], $g_sLibIconPath, $eIcnOptions)
			_GUICtrlComboBox_SetCurSel($g_ahCmbDropOrder[$i], -1)
			GUISetState()
			$bDuplicate = True
		EndIf
	Next
	If $bDuplicate Then
		GUICtrlSetState($g_hBtnDropOrderSet, $GUI_ENABLE) ; enable button to apply new order
		Return
	Else
		GUICtrlSetState($g_hBtnDropOrderSet, $GUI_ENABLE) ; enable button to apply new order
		_GUICtrlSetImage($g_ahImgDropOrderSet, $g_sLibIconPath, $eIcnRedLight) ; set status indicator to show need to apply new order
	EndIf
EndFunc   ;==>GUIDropOrder

Func BtnRemoveDropOrder()
	Local $bWasRedraw = SetRedrawBotWindow(False, Default, Default, Default, "BtnRemoveDropOrder")
	Local $sComboData = ""
	For $j = 0 To UBound($g_asDropOrderList) - 1
		$sComboData &= $g_asDropOrderList[$j] & "|"
	Next
	For $i = 0 To $eDropOrderCount - 1
		$g_aiCmbCustomDropOrder[$i] = -1
		_GUICtrlComboBox_ResetContent($g_aiCmbCustomDropOrder[$i])
		GUICtrlSetData($g_ahCmbDropOrder[$i], $sComboData, "")
		_GUICtrlSetImage($g_ahImgDropOrder[$i], $g_sLibIconPath, $eIcnOptions)
	Next
	_GUICtrlSetImage($g_ahImgDropOrderSet, $g_sLibIconPath, $eIcnSilverStar)
	SetDefaultDropOrderGroup(False)
	SetRedrawBotWindow($bWasRedraw, Default, Default, Default, "BtnRemoveDropOrder")
EndFunc   ;==>BtnRemoveDropOrder

Func BtnDropOrderSet()

	Local $bWasRedraw = SetRedrawBotWindow(False, Default, Default, Default, "BtnDropOrderSet")
	Local $bReady = True ; Initialize ready to record troop order flag
	Local $sNewDropList = ""

	Local $bMissingDrop = False ; flag for when troops are not assigned by user
	Local $aiDropOrder[$eDropOrderCount] = [ _
		$eTroopBarbarianS, $eTroopSuperBarbarianS, $eTroopArcherS, $eTroopSuperArcherS, $eTroopGiantS, $eTroopSuperGiantS, $eTroopGoblinS, $eTroopSneakyGoblinS, $eTroopWallBreakerS, _
		$eTroopSuperWallBreakerS, $eTroopBalloonS, $eTroopRocketBalloonS, $eTroopWizardS, $eTroopSuperWizardS, $eTroopHealerS, $eTroopDragonS, $eTroopPekkaS, $eTroopBabyDragonS, $eTroopInfernoDragonS, _
		$eTroopMinerS, $eTroopElectroDragonS, $eTroopYetiS, $eTroopDragonRiderS, $eTroopMinionS, $eTroopSuperMinionS, $eTroopHogRiderS, $eTroopValkyrieS, $eTroopSuperValkyrieS, $eTroopGolemS, _
		$eTroopWitchS, $eTroopSuperWitchS, $eTroopLavaHoundS, $eTroopIceHoundS, $eTroopBowlerS, $eTroopSuperBowlerS, $eTroopIceGolemS, $eTroopHeadHunterS, $eHeroeS, $eCCS]

	; check for duplicate combobox index and take action
	For $i = 0 To UBound($g_ahCmbDropOrder) - 1
		For $j = 0 To UBound($g_ahCmbDropOrder) - 1
			If $i = $j Then ContinueLoop ; skip if index are same
			If _GUICtrlComboBox_GetCurSel($g_ahCmbDropOrder[$i]) <> -1 And _
					_GUICtrlComboBox_GetCurSel($g_ahCmbDropOrder[$i]) = _GUICtrlComboBox_GetCurSel($g_ahCmbDropOrder[$j]) Then
				_GUICtrlComboBox_SetCurSel($g_ahCmbDropOrder[$j], -1)
				_GUICtrlSetImage($g_ahImgDropOrder[$j], $g_sLibIconPath, $eIcnOptions)
				$bReady = False
			Else
				GUICtrlSetColor($g_ahCmbDropOrder[$j], $COLOR_BLACK)
			EndIf
		Next
		; update combo array variable with new value
		$g_aiCmbCustomDropOrder[$i] = _GUICtrlComboBox_GetCurSel($g_ahCmbDropOrder[$i])
		If $g_aiCmbCustomDropOrder[$i] = -1 Then $bMissingDrop = True ; check if combo box slot that is not assigned a troop
	Next

	; Automatic random fill missing troops
	If $bReady And $bMissingDrop Then
		; 1st update $aiUsedTroop array with troops not used in $g_aiCmbCustomTrainOrder
		For $i = 0 To UBound($g_aiCmbCustomDropOrder) - 1
			For $j = 0 To UBound($aiDropOrder) - 1
				If $g_aiCmbCustomDropOrder[$i] = $j Then
					$aiDropOrder[$j] = -1 ; if troop is used, replace enum value with -1
					ExitLoop
				EndIf
			Next
		Next
		_ArrayShuffle($aiDropOrder) ; make missing training order assignment random
		For $i = 0 To UBound($g_aiCmbCustomDropOrder) - 1
			If $g_aiCmbCustomDropOrder[$i] = -1 Then ; check if custom order index is not set
				For $j = 0 To UBound($aiDropOrder) - 1
					If $aiDropOrder[$j] <> -1 Then ; loop till find a valid troop enum
						$g_aiCmbCustomDropOrder[$i] = $aiDropOrder[$j] ; assign unused troop
						_GUICtrlComboBox_SetCurSel($g_ahCmbDropOrder[$i], $aiDropOrder[$j])
						_GUICtrlSetImage($g_ahImgDropOrder[$i], $g_sLibIconPath, $g_aiDropOrderIcon[$g_aiCmbCustomDropOrder[$i] + 1])
						$aiDropOrder[$j] = -1 ; remove unused troop from array
						ExitLoop
					EndIf
				Next
			EndIf
		Next
	EndIf

	If $bReady Then
		ChangeDropOrder() ; code function to record new training order

		If @error Then
			Switch @error
				Case 1
					SetLog("Code problem, can not continue till fixed!", $COLOR_ERROR)
				Case 2
					SetLog("Bad Combobox selections, please fix!", $COLOR_ERROR)
				Case 3
					SetLog("Unable to Change Troop Drop Order due bad change count!", $COLOR_ERROR)
				Case Else
					SetLog("Monkey ate bad banana, something wrong with ChangeTroopDropOrder() code!", $COLOR_ERROR)
			EndSwitch
			_GUICtrlSetImage($g_ahImgDropOrderSet, $g_sLibIconPath, $eIcnRedLight)
		Else
			SetLog("Troop droping order changed successfully!", $COLOR_SUCCESS)
			For $i = 0 To $eDropOrderCount - 1
				$sNewDropList &= $g_asDropOrderNames[$g_aiCmbCustomDropOrder[$i]] & ", "
			Next
			$sNewDropList = StringTrimRight($sNewDropList, 2)
			SetLog("Troops Dropping Order= " & $sNewDropList, $COLOR_INFO)

		EndIf
	Else
		SetLog("Must use all troops and No duplicate troop names!", $COLOR_ERROR)
		_GUICtrlSetImage($g_ahImgDropOrderSet, $g_sLibIconPath, $eIcnRedLight)
	EndIf
	SetRedrawBotWindow($bWasRedraw, Default, Default, Default, "BtnDropOrderSet")
EndFunc   ;==>BtnDropOrderSet

Func IsUseCustomDropOrder()
	For $i = 0 To UBound($g_aiCmbCustomDropOrder) - 1 ; Check if custom train order has been used, to select log message
		If $g_aiCmbCustomDropOrder[$i] = -1 Then
			Return False
		EndIf
	Next
	Return True
EndFunc   ;==>IsUseCustomDropOrder

Func ChangeDropOrder()
	SetDebugLog("Begin Func ChangeDropOrder()", $COLOR_DEBUG) ;Debug

	Local $NewDropOrder[$eDropOrderCount]
	Local $iUpdateCount = 0

	If Not IsUseCustomDropOrder() Then ; check if no custom troop values saved yet.
		SetError(2, 0, False)
		Return
	EndIf

	; Look for match of combobox text to troopgroup and create new train order
	For $i = 0 To UBound($g_ahCmbDropOrder) - 1
		Local $sComboText = GUICtrlRead($g_ahCmbDropOrder[$i])
		For $j = 0 To UBound($g_asDropOrderList) - 1
			If $sComboText = $g_asDropOrderList[$j] Then
				$NewDropOrder[$i] = $j - 1
				$iUpdateCount += 1
				ExitLoop
			EndIf
		Next
	Next

	If $iUpdateCount = $eDropOrderCount Then ; safety check that all troops properly assigned to new array.
		For $i = 0 To $eDropOrderCount - 1
			$g_aiCmbCustomDropOrder[$i] = $NewDropOrder[$i]
		Next
		_GUICtrlSetImage($g_ahImgDropOrderSet, $g_sLibIconPath, $eIcnGreenLight)
	Else
		SetLog($iUpdateCount & "|" & $eDropOrderCount & " - Error - Bad troop assignment in ChangeTroopDropOrder()", $COLOR_ERROR)
		Return
	EndIf

	Return True
EndFunc   ;==>ChangeDropOrder

Func SetDefaultDropOrderGroup($bSetLog = True)
	For $i = 0 To $eDropOrderCount - 1
		$g_aiDropOrder[$i] = $i
	Next
	If $bSetLog And $g_bCustomDropOrderEnable Then SetLog("Default drop order set", $COLOR_SUCCESS)
EndFunc   ;==>SetDefaultDropOrderGroup
