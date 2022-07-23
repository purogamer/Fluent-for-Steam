; #FUNCTION# ====================================================================================================================
; Name ..........: GetOffestPixelRedArea2
; Description ...:
; Syntax ........: GetOffestPixelRedArea2($pixel, $eVectorType[, $offset = 3])
; Parameters ....: $pixel               - The pixel to add an offset
;                  $eVectorType         - an unknown value.
;                  $offset              - [optional] an object. Default is 3.
; Return values .: The pixel with offset
; Author ........: didipe
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
; Param : 	$pixel : The pixel to add an offset
;			$xSign : The translation on X
;			$ySign : The translation on Y
;			$g_hBitmap : handle of bitmap
; Return : 	The pixel with offset
; Strategy :
; 			According to the type of translation search the color of pixels around the current pixel
;			With the different of red color, we know how to make the offset (top,bottom,left,right)


Func GetOffestPixelRedArea2($pixel, $eVectorType, $offset = 3)
	; $nameFunc = "[GetOffestPixelRedArea] "
	;  debugRedArea($nameFunc&" IN")
	Local $pixelOffest = $pixel

	If ($eVectorType = $eVectorLeftTop) Then
		$pixelOffest[0] = Round($pixel[0] - $offset * 4 / 3)
		$pixelOffest[1] = $pixel[1] - $offset
	ElseIf ($eVectorType = $eVectorRightBottom) Then
		$pixelOffest[0] = Round($pixel[0] + $offset * 4 / 3)
		$pixelOffest[1] = $pixel[1] + $offset
	ElseIf ($eVectorType = $eVectorLeftBottom) Then
		$pixelOffest[0] = Round($pixel[0] - $offset * 4 / 3)
		$pixelOffest[1] = $pixel[1] + $offset
	ElseIf ($eVectorType = $eVectorRightTop) Then
		$pixelOffest[0] = Round($pixel[0] + $offset * 4 / 3)
		$pixelOffest[1] = $pixel[1] - $offset
	EndIf
	; Not select pixel in menu of troop
	If $pixelOffest[1] > 555 + $g_iBottomOffsetY Then
		$pixelOffest[1] = 555 + $g_iBottomOffsetY
	EndIf
	; debugRedArea($nameFunc&" OUT")
	Return $pixelOffest


EndFunc   ;==>GetOffestPixelRedArea2

