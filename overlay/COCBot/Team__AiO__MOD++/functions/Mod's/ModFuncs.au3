
; #FUNCTION# ====================================================================================================================
; Name ..........: ModFuncs.au3
; Description ...: Avoid loss of functions during updates.
; Author ........: Boludoz (2020)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2020
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

; #FUNCTION# ====================================================================================================================
; Author ........: Michael Michta <MetalGX91 at GMail dot com>
; Modified.......: gcriaco <gcriaco at gmail dot com>; Ultima - 2D arrays supported, directional search, code cleanup, optimization; Melba23 - added support for empty arrays and row search; BrunoJ - Added compare option 3 to use a regex pattern
; Modified.......: Boldina !
; ===============================================================================================================================
Func __ArraySearch(Const ByRef $aArray, $vValue, $iStart = 0, $iEnd = 0, $iCase = 0, $iCompare = 0, $iForward = 1, $iSubItem = -1, $bRow = False)
	If Not IsArray($aArray) Then Return -1
	Select
		Case ($iCompare = 0)
			Return _ArraySearch($aArray, $vValue, $iStart, $iEnd, $iCase, 2, $iForward, $iSubItem, $bRow)
		Case ($iCompare = 2)
			Return _ArraySearch($aArray, $vValue, $iStart, $iEnd, $iCase, 0, $iForward, $iSubItem, $bRow)
		Case Else
			Return _ArraySearch($aArray, $vValue, $iStart, $iEnd, $iCase, $iCompare, $iForward, $iSubItem, $bRow)
	EndSelect
EndFunc   ;==>__ArraySearch

Func SearchNoLeague($bCheckOneTime = False)
	If _Sleep($DELAYSPECIALCLICK1) Then Return False
	
	Local $bReturn = False
	
	$bReturn = _WaitForCheckImg($g_sImgNoLeague, "3,4,47,53", Default, ($bCheckOneTime = False) ? (1500) : (0)) ; Resolution changed ?
	
	If $g_bDebugSetlog Then
		SetDebugLog("SearchNoLeague: Is no league? " & $bReturn, $COLOR_DEBUG)
	EndIf
	
	Return $bReturn
EndFunc   ;==>SearchNoLeague

Func UnderstandChatRules()
	Local $bReturn = False

	; check for "I Understand" button
	Local $aCoord = decodeSingleCoord(findImage("I Understand", $g_sImgChatIUnterstand, GetDiamondFromRect("50,356(230,150)"))) ; Resolution changed

	If UBound($aCoord) > 1 And _Wait4PixelGoneArray($g_aClanBadgeNoClan) Then
		SetLog('Clicking "I Understand" button', $COLOR_ACTION)
		ClickP($aCoord)
		If _Sleep($DELAYDONATECC2) Then Return
		$bReturn = True
	EndIf

	If _Sleep($DELAYDONATECC2) Then Return

	Return $bReturn
EndFunc   ;==>UnderstandChatRules

Func IsToRequestCC($ClickPAtEnd = True, $bSetLog = False, $bNeedCapture = True)
	Local $bNeedRequest = False
	Local $sCCRequestDiamond = GetDiamondFromRect("715, 534, 842, 571") ; Contains iXStart, $iYStart, $iXEnd, $iYEnd ; Resolution changed
	Local $aCurrentCCRequest = findMultiple($g_sImgArmyRequestCC, $sCCRequestDiamond, $sCCRequestDiamond, 0, 1000, 0, "objectname,objectpoints", $bNeedCapture)

	Local $aTempCCRequestArray, $aCCRequestCoords
	If UBound($aCurrentCCRequest, 1) >= 1 Then
		For $i = 0 To UBound($aCurrentCCRequest, 1) - 1 ; Loop through found
			$aTempCCRequestArray = $aCurrentCCRequest[$i] ; Declare Array to Temp Array
			$aCCRequestCoords = StringSplit($aTempCCRequestArray[1], ",", $STR_NOCOUNT) ; Split the Coordinates where the Button got found into X and Y

			If $g_bDebugSetlog Then
				SetDebugLog($aTempCCRequestArray[0] & " Found on Coord: (" & $aCCRequestCoords[0] & "," & $aCCRequestCoords[1] & ")")
			EndIf

			If $aTempCCRequestArray[0] = "RequestFilled" Then ; Clan Castle Full
				SetLog("Your Clan Castle is already full or you are not in a clan.", $COLOR_SUCCESS)
				$g_bCanRequestCC = False
			ElseIf $aTempCCRequestArray[0] = "Waiting4Request" Then ; Request has already been made
				SetLog("Request has already been made!", $COLOR_INFO)
				$g_bCanRequestCC = False
			ElseIf $aTempCCRequestArray[0] = "CanRequest" Then ; Can make a request
				If Not $g_abRequestType[0] And Not $g_abRequestType[1] And Not $g_abRequestType[2] Then
					SetDebugLog("Request for Specific CC is not enable!", $COLOR_INFO)
					$bNeedRequest = True
				ElseIf Not $ClickPAtEnd Then
					$bNeedRequest = True
				Else
					For $i = 0 To 2
						If Not IsFullClanCastleType($i) Then
							$bNeedRequest = True
							ExitLoop
						EndIf
					Next
				EndIf
			Else ; No button request found
				SetLog("Cannot detect button request troops.")
			EndIf
		Next
	EndIf
	Return $bNeedRequest

EndFunc   ;==>IsToRequestCC

Func _GUICtrlCreateInput($sText, $iLeft, $iTop, $iWidth, $iHeight, $vStyle = -1, $vExStyle = -1)
	Local $hReturn = GUICtrlCreateInput($sText, $iLeft, $iTop, $iWidth, $iHeight, $vStyle, $vExStyle)
	GUICtrlSetBkColor($hReturn, 0xD1DFE7)
	Return $hReturn
EndFunc   ;==>_GUICtrlCreateInput

Func StringSplit2D($sMatches = "Hola-2-5-50-50-100-100|Hola-6-200-200-100-100", Const $sDelim_Item = "-", Const $sDelim_Row = "|", $bFixLast = Default)
    Local $iValDim_1, $iValDim_2 = 0, $iColCount

    ; Fix last item or row.
	If $bFixLast <> False Then
		Local $sTrim = StringRight($sMatches, 1)
		If $sTrim = $sDelim_Row Or $sTrim = $sDelim_Item Then $sMatches = StringTrimRight($sMatches, 1)
	EndIf

    Local $aSplit_1 = StringSplit($sMatches, $sDelim_Row, $STR_NOCOUNT + $STR_ENTIRESPLIT)
    $iValDim_1 = UBound($aSplit_1, $UBOUND_ROWS)
    Local $aTmp[$iValDim_1][0], $aSplit_2
    For $i = 0 To $iValDim_1 - 1
        $aSplit_2 = StringSplit($aSplit_1[$i], $sDelim_Item, $STR_NOCOUNT + $STR_ENTIRESPLIT)
        $iColCount = UBound($aSplit_2)
        If $iColCount > $iValDim_2 Then
            $iValDim_2 = $iColCount
            ReDim $aTmp[$iValDim_1][$iValDim_2]
        EndIf
        For $j = 0 To $iColCount - 1
            $aTmp[$i][$j] = $aSplit_2[$j]
        Next
    Next
    Return $aTmp
EndFunc   ;==>StringSplit2D

Func IsDir($sFolderPath)
	Return (DirGetSize($sFolderPath) > 0 and not @error)
EndFunc   ;==>IsDir

Func IsFile($sFilePath)
	Return (FileGetSize($sFilePath) > 0 and not @error)
EndFunc   ;==>IsDir

Func SecureClick($x, $y)
	If $x < 68 And $y > 316 Then ; coordinates where the game will click on the CHAT tab (safe margin)
		SetDebugLog("Coordinate Inside Village, but Exclude CHAT")
		Return False
	ElseIf $y < 63 Then ; coordinates where the game will click on the BUILDER button or SHIELD button (safe margin)
		SetDebugLog("Coordinate Inside Village, but Exclude BUILDER")
		Return False
	ElseIf $x > 692 And $y > 156 And $y < 210 Then ; coordinates where the game will click on the GEMS button (safe margin)
		SetDebugLog("Coordinate Inside Village, but Exclude GEMS")
		Return False
	ElseIf $x > 669 And $y > 489 Then ; coordinates where the game will click on the SHOP button (safe margin)
		SetDebugLog("Coordinate Inside Village, but Exclude SHOP")
		Return False
	EndIf
	Return True
EndFunc   ;==>SecureClick

Func _LevDis($s, $t)
	Local $m, $n, $iMaxM, $iMaxN

	$n = StringLen($s)
	$m = StringLen($t)
	$iMaxN = $n + 1
	$iMaxM = $m + 1
	Local $d[$iMaxN + 1][$iMaxM + 1]
	$d[0][0] = 0

	If $n = 0 Then
		Return $m
	ElseIf $m = 0 Then
		Return $n
	EndIf

	For $i = 1 To $n
		$d[$i][0] = $d[$i - 1][0] + 1
	Next
	For $j = 1 To $m
		$d[0][$j] = $d[0][$j - 1] + 1
	Next
	
	Local $jj, $ii, $iCost
	
	For $i = 1 To $n
		For $j = 1 To $m
			$jj = $j - 1
			$ii = $i - 1
			If (StringMid($s, $i, 1) = StringMid($t, $j, 1)) Then
				$iCost = 0
			Else
				$iCost = 1
			EndIf
			$d[$i][$j] = _Min(_Min($d[$ii][$j] + 1, $d[$i][$jj] + 1), $d[$ii][$jj] + $iCost)
		Next
	Next
	Return $d[$n][$m]
EndFunc   ;==>_LevDis

Func _CompareTexts($sTextIn = "", $sText2in = "", $iPerc = 80, $bStrip = False)

	Local $sText2 = "", $sTexta = ""
	If StringLen($sText2in) > StringLen($sTextIn) Then
		$sText2 = ($bSTRIP = False) ? ($sTextIn) : (StringStripWS($sTextIn, $STR_STRIPALL))
		$sTexta = ($bSTRIP = False) ? ($sText2in) : (StringStripWS($sText2in, $STR_STRIPALL))
	Else
		$sTexta = ($bSTRIP = False) ? ($sTextIn) : (StringStripWS($sTextIn, $STR_STRIPALL))
		$sText2 = ($bSTRIP = False) ? ($sText2in) : (StringStripWS($sText2in, $STR_STRIPALL))
	EndIf

	Local $aSeparate = StringSplit($sTexta, "", $STR_ENTIRESPLIT + $STR_NOCOUNT)
	If Not @error Then

		Local $iOf2 = StringLen($sText2) - 1
		If $iOf2 < 1 Then Return False

		Local $iC = 0, $iC2 = 0, $iText = 0, $iText2 = 0, $iLev = 0
		Local $sText = ""

		Local $iMax = 0
		For $i = 0 To UBound($aSeparate) - 1
			$sText = ""
			For $iTrin = 0 To $iOf2
				$iMax = $i + $iTrin
				If UBound($aSeparate) = $iMax Then ExitLoop
				$sText &= $aSeparate[$iMax]
			Next

			$iC = 0
			$iC2 = 0
			$iText = StringLen($sText)
			$iText2 = StringLen($sText2)
			$iLev = _LevDis($sText, $sText2)

			$iC = ((_Max($iText, $iText2) - $iLev) * 100)
			$iC2 = ((_Max($iText, $iText2)) * 100)
			$iC = (_Min($iC, $iC2) / _Max($iC, $iC2)) * 100

			If $iLev = 0 Or ($iC >= $iPerc) Then
				Return True
			EndIf
		Next
	EndIf
	Return False
EndFunc   ;==>_CompareTexts

;	https://link.clashofclans.com/en?action=CopyArmy&army=u20x3-3x23
; Func ()
	; 0xFF1919
	; AndroidAdbSendShellCommand("am start -n " & $g_sAndroidGamePackage & "/" & $g_sAndroidGameClass & " -a android.intent.action.VIEW -d ' "& $s & "'", Default)

; EndFunc   ;==>
; #cs
Func CloseEmulatorForce($bOnlyAdb = False)
	Local $iPids[0], $a[0], $s

	If $bOnlyAdb = False Then
		$s = Execute("Get" & $g_sAndroidEmulator & "Path()")
		If not @error Then
			$a = ProcessFindBy($s, "")
			_ArrayAdd($iPids, $a)
		EndIf
		$a = ProcessFindBy($__VBoxManage_Path, "")
		_ArrayAdd($iPids, $a)
	EndIf

	$a = ProcessFindBy($g_sAndroidAdbPath)
	_ArrayAdd($iPids, $a)

	If UBound($iPids) > 0 and not @error Then
		For $i = 0 To UBound($iPids) -1 ; Custom fix - Team AIO Mod++
			KillProcess($iPids[$i], $g_sAndroidAdbPath)
		Next

		Return True
	EndIf

	Return False
EndFunc   ;==>ProcessFindBy


;  	ProcessFindBy($g_sAndroidAdbPath), $sPort
;	ProcessFindBy("C:\...\lib\TempAdb\MEmu\", "", true, false)
Func ProcessFindBy($sPath = "", $sCommandline = "", $bAutoItMode = False, $bDontShootYourself = True)
	Local $bGetProcessPath, $bGetProcessCommandLine, $bFail, $aReturn[0]

	; In exe case, like emulator.
	If IsFile($sPath) = True Then
		Local $sFile = StringRegExpReplace($sPath, "^.*\\", "")
		$sFile = StringTrimRight($sFile, StringLen($sFile))
		_ConsoleWrite($sFile)
	EndIf

	$sPath = StringReplace($sPath, "\\", "\")
	If StringIsSpace($sPath) And StringIsSpace($sCommandline) Then Return $aReturn
	Local $sCommandlineParam
	Local $aiProcessList = ProcessList()
	If @error Then Return $aReturn
	For $i = 2 To UBound($aiProcessList) - 1
		$bGetProcessPath = StringInStr(_WinAPI_GetProcessFileName($aiProcessList[$i][1]), $sPath) > 0
		$sCommandlineParam = _WinAPI_GetProcessCommandLine($aiProcessList[$i][1])
		If $bGetProcessPath = False And $bAutoItMode Then $bGetProcessPath = StringInStr($sCommandlineParam, $sPath) > 0
		$bGetProcessCommandLine = StringInStr($sCommandlineParam, $sCommandline) > 0
		Local $iAdd = Int($aiProcessList[$i][1])
		If $iAdd > 0 Then
			Select
				Case $bGetProcessPath And $bGetProcessCommandLine
					If Not StringIsSpace($sPath) And Not StringIsSpace($sCommandline) Then
						_ArrayAdd($aReturn, $iAdd, $ARRAYFILL_FORCE_INT)
					EndIf
				Case $bGetProcessPath And Not $bGetProcessCommandLine
					If StringIsSpace($sCommandline) Then
						_ArrayAdd($aReturn, $iAdd, $ARRAYFILL_FORCE_INT)
					EndIf
				Case Not $bGetProcessPath And $bGetProcessCommandLine
					If StringIsSpace($sPath) Then
						_ArrayAdd($aReturn, $iAdd, $ARRAYFILL_FORCE_INT)
					EndIf
			EndSelect
		EndIf
	Next

	For $i = UBound($aReturn) - 1 To 0 Step -1
		If $aReturn[$i] = @AutoItPID Then
			If $bDontShootYourself = True Then
				_ArrayDelete($aReturn, $i)
			Else
				Local $iNT = $i
				_ArrayAdd($aReturn, $aReturn[$i], $ARRAYFILL_FORCE_INT)
				_ArrayDelete($aReturn, $iNT)
			EndIf
			ExitLoop
		EndIf
	Next

	Return $aReturn
EndFunc   ;==>ProcessFindBy

Func ForegroundFixer($sPackage = Default)
	If $sPackage = Default Then $sPackage = $g_sAndroidGamePackage
	If GetAndroidProcessPID($sPackage, True, 0) = 0 Then
		SetLog("Trying to bring the game into the foreground", $COLOR_DEBUG)
		AndroidAdbSendShellCommand("am start -W -n " & $g_sAndroidGamePackage & "/" & $g_sAndroidGameClass, 60000)
	EndIf
EndFunc   ;==>ForegroundFixer
; #ce
Func _OSVersion()
	Static $s_iTrueOSVersion = 0
	If $s_iTrueOSVersion > 0 Then
		Return $s_iTrueOSVersion
	EndIf
	
	$s_iTrueOSVersion = @OSVersion
	
	Local $sCurrentBuildNumber = RegRead($g_sHKLM & "\SOFTWARE" & $g_sWow6432Node & "\Microsoft\Windows NT\CurrentVersion\", "ProductName")
	If @error Then $sCurrentBuildNumber = ""

	If ("WIN_10" = @OSVersion Or StringInStr($sCurrentBuildNumber, "Windows 10") > 0) And (_OSBuild() >= "22000" And _OSBuild() <= "32000") Then
		$s_iTrueOSVersion = "WIN_11"
	EndIf
	
	Return $s_iTrueOSVersion
EndFunc   ;==>_OSVersion

Func _OSBuild()
	Static $s_iTrueOSBuild = 0
	If $s_iTrueOSBuild > 0 Then
		Return $s_iTrueOSBuild
	EndIf
	$s_iTrueOSBuild = RegRead($g_sHKLM & "\SOFTWARE" & $g_sWow6432Node & "\Microsoft\Windows NT\CurrentVersion\", "CurrentBuildNumber")
	If @error Or Number($s_iTrueOSBuild) = 0 Then $s_iTrueOSBuild = @OSBuild
	Return SetError(0, 0, $s_iTrueOSBuild)
EndFunc   ;==>_OSBuild
