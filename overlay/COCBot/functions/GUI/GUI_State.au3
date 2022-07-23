; #FUNCTION# ====================================================================================================================
; Name ..........: _GUI_STATE
; Description ...: This file Includes several files in the current script and all Declared variables, constant, or create an array.
; Syntax ........: #include , Global
; Parameters ....: $action_groupe, $group_de_controle
; Return values .: None
; Author ........: Boju(06-2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: _GUI_Value_STATE("SHOW",$g_aGroupSearchDB) Show the group $g_aGroupSearchDB
; ===============================================================================================================================
Func _GUI_Value_STATE($action_groupe, $group_de_controle)
	;SetRedrawBotWindow(False)
	Local $liste_controle = StringSplit($group_de_controle, "#")
	If IsArray($liste_controle) Then
		For $i = 1 To $liste_controle[0]
			Switch StringUpper($action_groupe)
				Case "HIDE"
					GUICtrlSetState($liste_controle[$i], $GUI_HIDE)
				Case "SHOW"
					GUICtrlSetState($liste_controle[$i], $GUI_SHOW)
				Case "ENABLE"
					GUICtrlSetState($liste_controle[$i], $GUI_ENABLE)
				Case "DISABLE"
					GUICtrlSetState($liste_controle[$i], $GUI_DISABLE)
				Case "UNCHECKED"
					GUICtrlSetState($liste_controle[$i], $GUI_UNCHECKED)
				Case "CHECKED"
					GUICtrlSetState($liste_controle[$i], $GUI_CHECKED)
			EndSwitch
		Next
	EndIf
	;SetRedrawBotWindow(True)
EndFunc   ;==>_GUI_Value_STATE
