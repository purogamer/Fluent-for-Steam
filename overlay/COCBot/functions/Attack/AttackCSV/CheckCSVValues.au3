; #FUNCTION# ====================================================================================================================
; Name ..........: CheckCsvValues
; Description ...:
; Syntax ........: CheckCsvValues($instruction, $variablenumber, $variable)
; Parameters ....: $instruction         -
;                  $variablenumber      -
;                  $variable            -
; Return values .: None
; Author ........: Sardo (2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: Noo
; ===============================================================================================================================
Func CheckCsvValues($instruction, $variablenumber, $variable)
	Switch $instruction
		Case "MAKE"
			Switch $variablenumber
				Case 1
					If $variable = "RANDOM" Then
						Return True ;exit true if value=RANDOM
					Else
						Local $vect1 = StringSplit($variable, "-", 2) ;make vect with split values
						If UBound($vect1) = 0 Then ;single value
							If StringLen($vect1) = 1 Then ;check lenght of value
								If (Asc($vect1[$i]) >= 65 And Asc($vect1[$i]) <= 90) Then
									Return True ;if A-Z return true
								Else
									Return False ;lenght >1 or not A-Z return false
								EndIf
							Else
								Return False ;length >1 return false
							EndIf
						Else
							For $i = 0 To UBound($vect1) - 1 ;for all values check length and A-Z
								Local $tempstr = $vect1[$i]
								If StringLen($tempstr) <> 1 Then
									Return False ;exit length>1
								Else
									If Not (Asc($vect1[$i]) >= 65 And Asc($vect1[$i]) <= 90) Then Return False ;exit not A-Z
								EndIf
							Next
							Return True ;all check passed
						EndIf
					EndIf
				Case 2
					Switch $variable
						Case "FRONT-LEFT"
							Return True
						Case "FRONT-RIGHT"
							Return True
						Case "RIGHT-FRONT"
							Return True
						Case "RIGHT-BACK"
							Return True
						Case "LEFT-FRONT"
							Return True
						Case "LEFT-BACK"
							Return True
						Case "BACK-LEFT"
							Return True
						Case "BACK-RIGHT"
							Return True
						Case "RANDOM"
							Return True
					EndSwitch
				Case 5
					Switch $variable
						Case "EXT-INT"
							Return True
						Case "INT-EXT"
							Return True
						Case "IGNORE"
							Return True
						Case Else
							Return False
					EndSwitch
				Case 8 ; check for valid building targets
					Switch $variable
						Case "TOWNHALL"
							Return True
						Case "EAGLE"
							Return True
						Case "INFERNO"
							Return True
						Case "XBOW"
							Return True
						Case "WIZTOWER"
							Return True
						Case "MORTAR"
							Return True
						Case "AIRDEFENSE"
							Return True
						Case "EX-WALL"
							Return True
						Case "IN-WALL"
							Return True
						; Custom CSV - Team AIO Mod++ (Thx to BigSalami)
						Case "SCATTER", "SCATTERSHOT"
							Return True
						Case "CLANCASTLE"
							Return True
						Case Else
							Return False
					EndSwitch
			EndSwitch
	EndSwitch
	Return False ; if no one match return false
EndFunc   ;==>CheckCsvValues
