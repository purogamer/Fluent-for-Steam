; #FUNCTION# ====================================================================================================================
; Name ..........: GetButtons.au3
; Description ...: Get the buttons in attack screen using Dissociable.OCR
; Syntax ........: 
; Parameters ....: None
; Return values .: None
; Author ........: Dissociable
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2020
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func GetButtonsCountByString($sButtons, $bFixByLength = False, $iMinLength = 3)
    If $bFixByLength Then
        $sButtons = FixButtonsWithSmallLength($sButtons, $iMinLength)
    EndIf
    Return StringSplit($sButtons, "|")[0]
EndFunc

Func GetButtons($aRegion)
    If Not IsArray($aRegion) Or UBound($aRegion) < 4 Then
        SetLog("Invalid Parameters passed to GetButtons function.", $COLOR_ERROR)
        Return ""
    EndIf
    Local $sButtons = getAttackScreenButtons($aRegion[0], $aRegion[1], $aRegion[2], $aRegion[3])
    While (StringRight($sButtons, 1) = "|")
        $sButtons = StringTrimRight($sButtons, 1)
    WEnd
    Return FixButtonNames($sButtons)
EndFunc

Func FixButtonNames($sButtons)
    Local $aSplittedButtons = StringSplit($sButtons, "|")
    Local $sNameFixedButtons = ""
    Local $sAdditional = ""
    For $i = 1 To UBound($aSplittedButtons) - 1
        If $aSplittedButtons[$i] = "|" Then
            ContinueLoop
        EndIf

        If $i > 0 Then
            $sAdditional = "|"
        EndIf

        Switch ($aSplittedButtons[$i])
            Case "HBeoroosets"
                $sNameFixedButtons &= $sAdditional & "Boost Heroes"
            Case Else
                $sNameFixedButtons &= $sAdditional & $aSplittedButtons[$i]
        EndSwitch
    Next
    Return $sNameFixedButtons
EndFunc

Func FixButtonsWithSmallLength($sButtons, $iMinLength)
    Local $aSplittedButtons = StringSplit($sButtons, "|")
    Local $sButtonsFixed = ""
    For $i = 1 To UBound($aSplittedButtons) - 1
        ; If The Button Length is Lower than 3, it's probably due to a bad text recognition, we gonna handle it as much as possible!
        If StringLen($aSplittedButtons[$i]) < $iMinLength Then
            $sButtonsFixed &= $aSplittedButtons[$i]
        Else
            If StringLen($sButtonsFixed) > 0 Then
                $sButtonsFixed &= "|" & $aSplittedButtons[$i]
            Else
                $sButtonsFixed &= $aSplittedButtons[$i]
            EndIf
        EndIf
    Next
    Return $sButtonsFixed
EndFunc