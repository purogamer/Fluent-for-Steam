; #FUNCTION# ====================================================================================================================
; Name ..........: varies
; Description ...: Scripting Dictionary functions with integrated error checking of input parameters to avoid COM errors
; Syntax ........:
; Parameters ....:
; Return values .:
; Author ........: BugFix  ( bugfix@autoit.de )
; Modified ......: MonkeyHunter (04-2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func _ObjErrMsg($sFunctionName, $iErrorCode)
	SetDebugLog("Dictionary Error: " & $sFunctionName & " code: " & $iErrorCode, $COLOR_ERROR, True)
EndFunc   ;==>_ObjErrMsg

Func _ObjAdd(ByRef $oDICT, $KEY, $VALUE)
	If Not IsObj($oDICT) Then
		SetError(1)
		Return -1
	ElseIf $KEY = '' Then
		SetError(2)
		Return -1
	ElseIf $VALUE = '' Then
		SetError(3)
		Return -1
	ElseIf $oDICT.Exists($KEY) Then
		SetError(4)
		Return -1
	EndIf
	$oDICT.Add($KEY, $VALUE)
	Return 0
EndFunc   ;==>_ObjAdd

Func _ObjPutValue(ByRef $oDICT, $KEY, $VALUE) ; adds key/value if not present, updates value if present
	If Not IsObj($oDICT) Then
		SetError(1)
		Return -1
	ElseIf $KEY = '' Then
		SetError(2)
		Return -1
	ElseIf $VALUE = '' Then
		SetError(3)
		Return -1
	EndIf
	If $oDICT.Exists($KEY) Then
		$oDICT.Item($KEY) = $VALUE
	Else
		$oDICT.Add($KEY, $VALUE)
	EndIf
	Return 0
EndFunc   ;==>_ObjPutValue

Func _ObjGetValue(ByRef $oDICT, $KEY)
	If Not IsObj($oDICT) Then
		SetError(1)
		Return -1
	ElseIf $KEY = '' Then
		SetError(2)
		Return -1
	ElseIf Not $oDICT.Exists($KEY) Then
		SetError(5)
		Return -1
	EndIf
	Return $oDICT.Item($KEY)
EndFunc   ;==>_ObjGetValue


Func _ObjSetValue(ByRef $oDICT, $KEY, $VALUE)
	If Not IsObj($oDICT) Then
		SetError(1)
		Return -1
	ElseIf $KEY = '' Then
		SetError(2)
		Return -1
	ElseIf $VALUE = '' Then
		SetError(3)
		Return -1
	ElseIf Not $oDICT.Exists($KEY) Then
		SetError(5)
		Return -1
	EndIf
	$oDICT.Item($KEY) = $VALUE
	Return 0
EndFunc   ;==>_ObjSetValue

Func _ObjCount(ByRef $oDICT)
	If Not IsObj($oDICT) Then
		SetError(1)
		Return -1
	EndIf
	Return $oDICT.Count
EndFunc   ;==>_ObjCount

Func _ObjSearch(ByRef $oDICT, $KEY)
	If Not IsObj($oDICT) Then
		SetError(1)
		Return -1
	ElseIf $KEY = '' Then
		SetError(2)
		Return -1
	ElseIf Not $oDICT.Exists($KEY) Then
		Return False
	Else
		Return True
	EndIf
EndFunc   ;==>_ObjSearch

Func _ObjDeleteKey(ByRef $oDICT, $KEY = '')
	If Not IsObj($oDICT) Then
		SetError(1)
		Return -1
	EndIf
	If $KEY = '' Then
		$oDICT.RemoveAll
		Return 0
	ElseIf Not $oDICT.Exists($KEY) Then
		SetError(5)
		Return -1
	EndIf
	$oDICT.Remove($KEY)
	Return 0
EndFunc   ;==>_ObjDeleteKey


Func _ObjList(ByRef $oDICT, $TITLE = 'Object Dictionary Elements')
	If Not IsObj($oDICT) Then
		SetError(1)
		Return -1
	EndIf
	Local $count = $oDICT.Count
	Local $SaveMode = Opt("GUIOnEventMode", 0), $ListGUI, $oDictLV, $btnClose, $msg
	$ListGUI = GUICreate($TITLE, 600, 400, (@DesktopWidth - 600) / 2, (@DesktopHeight - 400) / 2)
	$btnClose = GUICtrlCreateButton('Close', 40, 360, 70, 22)
	GUICtrlSetResizing($btnClose, BitOR($GUI_DockRight, $GUI_DockBottom, $GUI_DockSize))
	GUICtrlDelete($oDictLV)
	$oDictLV = GUICtrlCreateListView('Key|Value', 10, 10, 580, 340, BitOR($LVS_SHOWSELALWAYS, _
			$LVS_EDITLABELS), BitOR($LVS_EX_GRIDLINES, $LVS_EX_HEADERDRAGDROP, $LVS_EX_FULLROWSELECT, $LVS_EX_REGIONAL))
	If $count > 0 Then
		Local $strKey, $colKeys = $oDICT.Keys
		For $strKey In $colKeys
			GUICtrlCreateListViewItem($strKey & '|' & $oDICT.Item($strKey), $oDictLV)
		Next
	Else
		WinSetTitle($ListGUI, '', 'Dictionary object does not contain any elements!')
	EndIf
	GUISetState(@SW_SHOW, $ListGUI)
	While 1
		$msg = GUIGetMsg(1)
		If $msg[1] = $ListGUI And _
				($msg[0] = $GUI_EVENT_CLOSE Or $msg[0] = $btnClose) Then ExitLoop
	WEnd
	GUIDelete($ListGUI)
	Opt("GUIOnEventMode", $SaveMode)
EndFunc   ;==>_ObjList

Func _LogObjList(ByRef $oDICT)
	If Not IsObj($oDICT) Then
		SetLog("_LogObjList parameter is not object dictionary!", $COLOR_ERROR)
		SetError(1)
		Return -1
	EndIf
	Local $count = $oDICT.Count
	If $count > 0 Then
		Local $strKey, $Text, $array, $TotalTime
		Local $colKeys = $oDICT.Keys
		For $strKey In $colKeys
			$Text = ""
			If IsArray($oDICT.Item($strKey)) Then
				$array = $oDICT.Item($strKey)
				$Text = "Array Contents: "
				Select
					Case UBound($array, 1) > 1 And IsArray($array[1]) ; if we have array of arrays, separate and list
						$Text &= PixelArrayToString($array, ",")
					Case UBound($array[0]) = 2 ; single row with one array internal
						Local $aPixel = $array[0]
						$Text &= PixelToString($aPixel, ";")
					Case UBound($array) = 2 And IsArray($array[0]) = 0 ; original array has x, y
						$Text &= PixelToString($array, ":")
					Case Else
						$Text = "Monkey found bad banana!"
				EndSelect
			Else
				$Text = $oDICT.Item($strKey)
				If StringInStr($strKey, "FINDTIME", $STR_NOCASESENSEBASIC) Then $TotalTime += Number($Text)
			EndIf
			SetLog("Dictionary Key: " & StringFormat("[%18s]", $strKey) & " = " & $Text, $COLOR_DEBUG)
		Next
		SetLog("Key Summary: " & StringFormat("[%18s]", "TOTAL FINDTIME") & " = " & $TotalTime, $COLOR_DEBUG)
	EndIf
EndFunc   ;==>_LogObjList

