; #FUNCTION# ====================================================================================================================
; Name ..........: Slice8
; Description ...:
; Syntax ........: Slice8($pixel)
; Parameters ....: $pixel               - pixel array
; Return values .: None
; Author ........: Sardo (2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func Slice8($pixel)
	If UBound($pixel) < 2 Then Return "0_NO_ARRAY" ;exit

	Local $Left = $ExternalArea[0][0]
	Local $Right = $ExternalArea[1][0]
	Local $Top = $ExternalArea[2][1]
	Local $Bottom = $ExternalArea[3][1]

	Local $LeftY = $ExternalArea[0][1]
	Local $RightY = $ExternalArea[1][1]
	Local $TopX = $ExternalArea[2][0]
	Local $BottomX = $ExternalArea[3][0]

	Local $TLX = $ExternalArea[4][0]
	Local $TLY = $ExternalArea[4][1]
	Local $TRX = $ExternalArea[5][0]
	Local $TRY = $ExternalArea[5][1]
	Local $BLX = $ExternalArea[6][0]
	Local $BLY = $ExternalArea[6][1]
	Local $BRX = $ExternalArea[7][0]
	Local $BRY = $ExternalArea[7][1]

	Local $isIn = 1.01

	If $pixel[0] < $Left Or $pixel[0] > $Right Or $pixel[1] < $Top Or $pixel[1] > $Bottom Then
		; PIXEL OUT OF AREA
		Return "0_O"
	Else
		If $pixel[0] <= $TopX Then
			If $pixel[1] <= $LeftY Then
				;TOP-LEFT, slices 5 and 6
				If $pixel[0] <= $TLX Then ; slice 6 external
					If ($TLX - $pixel[0]) / ($TLX - $Left) + ($LeftY - $pixel[1]) / ($LeftY - $TLY) <= $isIn Then
						Return "6E"
					Else
						Return "0_6E"
					EndIf
				Else
					If ($pixel[0] - $TLX) / ($TopX - $TLX) + ($LeftY - $pixel[1]) / ($LeftY - $TLY) <= $isIn Then
						Return "6_I"
					Else
						If ($TopX - $pixel[0]) / ($TopX - $TLX) + Abs($TLY - $pixel[1]) / ($LeftY - $TLY) <= $isIn Then
							If $pixel[1] <= $TLY Then
								Return "5_E"
							Else
								Return "5_I"
							EndIf
						Else
							Return "O_5"
						EndIf
					EndIf
				EndIf
			Else
				;BOTTOM-LEFT slices 7 and 8
				If $pixel[0] <= $BLX Then ; slice 7 external
					If ($BLX - $pixel[0]) / ($BLX - $Left) + ($pixel[1] - $LeftY) / ($BLY - $LeftY) <= $isIn Then
						Return "7_E"
					Else
						Return "0_7"
					EndIf
				Else
					If ($pixel[0] - $BLX) / ($TopX - $BLX) + ($pixel[1] - $LeftY) / ($BLY - $LeftY) <= $isIn Then
						Return "7_I"
					Else
						If ($TopX - $pixel[0]) / ($TopX - $BLX) + Abs($BLY - $pixel[1]) / ($BLY - $LeftY) <= $isIn Then
							If $pixel[1] <= $BLY Then
								Return "8_I"
							Else
								Return "8_E"
							EndIf
						Else
							Return "0_8"
						EndIf
					EndIf
				EndIf
			EndIf
		Else
			If $pixel[1] <= $RightY Then
				;TOP-RIGHT slices 3 and 4
				If $pixel[0] > $TRX Then ; slice 3 external
					If ($pixel[0] - $TRX) / ($Right - $TRX) + ($RightY - $pixel[1]) / ($RightY - $TRY) <= $isIn Then
						Return "3_E"
					Else
						Return "0_3"
					EndIf
				Else
					If ($TRX - $pixel[0]) / ($TRX - $TopX) + ($RightY - $pixel[1]) / ($RightY - $TRY) <= $isIn Then
						Return "3_I"
					Else
						If ($pixel[0] - $TopX) / ($TRX - $TopX) + Abs($TRY - $pixel[1]) / ($RightY - $TRY) <= $isIn Then
							If $pixel[1] <= $TRY Then
								Return "4_E"
							Else
								Return "4_I"
							EndIf
						Else
							Return "0_4"
						EndIf
					EndIf
				EndIf
			Else
				;BOTTOM-RIGHT slices 1 and 2
				If $pixel[0] > $BRX Then ; slice 2 external
					If ($pixel[0] - $BRX) / ($Right - $BRX) + ($pixel[1] - $RightY) / ($BRY - $RightY) <= $isIn Then
						Return "2_E"
					Else
						Return "0_2"
					EndIf
				Else
					If ($BRX - $pixel[0]) / ($BRX - $BottomX) + ($pixel[1] - $RightY) / ($BRY - $RightY) <= $isIn Then
						Return "2_I"
					Else
						If ($pixel[0] - $BottomX) / ($BRX - $BottomX) + Abs($BRY - $pixel[1]) / ($BRY - $RightY) <= $isIn Then
							If $pixel[1] <= $BRY Then
								Return "1_I"
							Else
								Return "1_E"
							EndIf
						Else
							Return "0_1"
						EndIf
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf
EndFunc   ;==>Slice8
