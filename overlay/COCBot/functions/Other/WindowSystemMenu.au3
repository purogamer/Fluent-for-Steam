Func WindowSystemMenu($HWnD, $iButton, $Action = Default, $DebugInfo = "")
	Local $hSysMenu = _GUICtrlMenu_GetSystemMenu($HWnD, False)
	If $Action = Default Then
		Return _GUICtrlMenu_GetItemID($hSysMenu, $iButton, False) <> 0
	EndIf
	Local $enabled = WindowSystemMenu($HWnD, $iButton)
	If $Action <> $enabled Then
		Local $i, $c = _GUICtrlMenu_GetItemCount($hSysMenu)
		Local $aVisible[$c]
		For $i = 0 To $c - 1
			$aVisible[$i] = _GUICtrlMenu_GetItemID($hSysMenu, $i)
		Next
		_GUICtrlMenu_GetSystemMenu($HWnD, True)
		$hSysMenu = _GUICtrlMenu_GetSystemMenu($HWnD, False)
		_GUICtrlMenu_DrawMenuBar($HWnD)
		$c = _GUICtrlMenu_GetItemCount($hSysMenu)
		If $DebugInfo = "" Then $DebugInfo = $iButton
		For $i = 0 To $c - 1
			Local $id = _GUICtrlMenu_GetItemID($hSysMenu, $i)
			If $id = $iButton Then
				If $Action = False Then
					SetDebugLog("Hide SystemMenu Item: " & $DebugInfo)
					_GUICtrlMenu_RemoveMenu($hSysMenu, $i)
				Else
					SetDebugLog("Show SystemMenu Item: " & $DebugInfo)
				EndIf
			ElseIf  _ArraySearch($aVisible, $id) = -1 Then
				_GUICtrlMenu_RemoveMenu($hSysMenu, $i)
			EndIf

		Next
	EndIf
EndFunc