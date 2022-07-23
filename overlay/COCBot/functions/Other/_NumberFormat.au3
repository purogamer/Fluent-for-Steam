
; #FUNCTION# ====================================================================================================================
; Name ..........: _NumberFormat
; Description ...:
; Syntax ........: _NumberFormat($Number[, $NullToZero = False])
; Parameters ....: $Number              - an unknown value.
;                  $NullToZero          - [optional] an unknown value. Default is False.
; Return values .: None
; Author ........:
; Modified ......: kaganus (August 2015)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func _NumberFormat($Number, $NullToZero = False) ; pad numbers with spaces as thousand separator

	If $Number = "" Then
		If $NullToZero = False Then
			Return ""
		Else
			Return "0"
		EndIf
	EndIf

	If StringLeft($Number, 1) = "-" Then
		Return "- " & StringRegExpReplace(StringTrimLeft($Number, 1), "(\A\d{1,3}(?=(\d{3})+\z)|\d{3}(?=\d))", "\1 ")
	Else
		Return StringRegExpReplace($Number, "(\A\d{1,3}(?=(\d{3})+\z)|\d{3}(?=\d))", "\1 ")
	EndIf

EndFunc   ;==>_NumberFormat
