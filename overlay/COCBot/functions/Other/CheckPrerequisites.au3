; #FUNCTION# ====================================================================================================================
; Name ..........: CheckPrerequisites
; Description ...:
; Syntax ........: CheckPrerequisites()
; Parameters ....:
; Return values .: None
; Author ........:
; Modified ......: Heridero, Zengzeng (2015)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func CheckPrerequisites($bSilent = False)
	Local $bIsAllOk = True

	Local $isNetFramework4dot5Installed = isNetFramework4dot5Installed()
	Local $isVC2010Installed = isVC2010Installed()
	If (Not $isNetFramework4dot5Installed Or Not $isVC2010Installed) Then
		If (Not $isNetFramework4dot5Installed And Not $bSilent) Then
			SetLog("The .Net Framework 4.5 is not installed", $COLOR_ERROR)
			SetLog("Please download here : https://www.microsoft.com/en-US/download/details.aspx?id=30653", $COLOR_ERROR)
		EndIf
		If (Not $isVC2010Installed And Not $bSilent) Then
			SetLog("The VC 2010 x86 is not installed", $COLOR_ERROR)
			SetLog("Please download here : https://www.microsoft.com/en-US/download/details.aspx?id=5555", $COLOR_ERROR)
		EndIf
		$bIsAllOk = False
	EndIf
	If Not isEveryFileInstalled($bSilent) Or Not CheckAutoitVersion($bSilent) Then $bIsAllOk = False
	CheckIsAdmin($bSilent)

	If @DesktopHeight <= 768 Then
		Opt('WinTitleMatchMode', 4)
		Local $aiPos = ControlGetPos("classname=Shell_TrayWnd", "", "")
		If Not @error Then
			If $aiPos[2] > $aiPos[3] And Int($aiPos[3]) + 732 > 768 Then
				SetLog("Display: " & @DesktopWidth & "," & @DesktopHeight, $COLOR_ERROR)
				SetLog("Windows TaskBar: " & $aiPos[2] & "," & $aiPos[3], $COLOR_ERROR)
				SetLog("Emulator[732] and taskbar[" & $aiPos[3] & "] doesn't fit on your display!", $COLOR_ERROR)
				SetLog("Please set your Windows taskbar location to Right!", $COLOR_ERROR)
			EndIf
		EndIf
		Opt('WinTitleMatchMode', 3)
	EndIf

	If Not $bIsAllOk And Not $bSilent Then
		GUICtrlSetState($g_hBtnStart, $GUI_DISABLE)
		$g_bRestarted = False
	EndIf

	Return $bIsAllOk
EndFunc   ;==>CheckPrerequisites

Func isNetFramework4dot5Installed()
	;https://msdn.microsoft.com/it-it/library/hh925568%28v=vs.110%29.aspx#net_b
	Local $z = 0, $sKeyValue, $success = False
	$sKeyValue = RegRead("HKLM\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full\", "Release")
	If Number($sKeyValue) >= 378389 Then $success = True
	Return $success
EndFunc   ;==>isNetFramework4dot5Installed

Func isVC2010Installed()
	Local $hDll = DllOpen("msvcp100.dll")
	Local $success = $hDll <> -1
	If $success = False Then Return $success
	DllClose($hDll)
	_WinAPI_FreeLibrary($hDll)
	Return $success
EndFunc   ;==>isVC2010Installed

Func isEveryFileInstalled($bSilent = False)
	Local $bResult = False, $iCount = 0

	; folders and files needed checking
	Local $aCheckFiles = [@ScriptDir & "\COCBot", _
			$g_sLibPath, _
			@ScriptDir & "\Images", _
			@ScriptDir & "\imgxml", _
			$g_sLibPath & "\helper_functions.dll", _
			$g_sLibPath & "\MBRBot.dll", _
			$g_sLibPath & "\MyBot.run.dll", _
			$g_sLibPath & "\Newtonsoft.Json.dll", _
			$g_sLibPath & "\sqlite3.dll", _
			$g_sLibPath & "\opencv_core220.dll", _
			$g_sLibPath & "\opencv_imgproc220.dll"]

	For $vElement In $aCheckFiles
		$iCount += FileExists($vElement)
	Next
	; How many .xml files in imgxml folder
	Local $xmls = _FileListToArrayRec(@ScriptDir & "\imgxml\", "*.xml", $FLTAR_FILES + $FLTAR_NOHIDDEN, $FLTAR_RECUR, $FLTAR_NOSORT)
	If IsArray($xmls) Then
		If Number($xmls[0]) < 570 Then SetLog("Verify '\imgxml\' folder, found " & $xmls[0] & " *.xml files.", $COLOR_ERROR)
	EndIf

	Local $MsgBox = 0
	Local $sText1 = GetTranslatedFileIni("MBR Popups", "CheckPrerequisites_Item_01", "Hey Chief, we are missing some files!")
	Local $sText2 = GetTranslatedFileIni("MBR Popups", "CheckPrerequisites_Item_02", "Please extract all files and folders and start this program again!")
	Local $sText3 = GetTranslatedFileIni("MBR Popups", "CheckPrerequisites_Item_03", "Sorry, Start button disabled until fixed!")
	Local $sText4 = GetTranslatedFileIni("MBR Popups", "CheckPrerequisites_Item_04", "Hey Chief, file name incorrect!")
	Local $sText5 = GetTranslatedFileIni("MBR Popups", "CheckPrerequisites_Item_05", 'You have renamed the file "MyBot.run.exe"! Please change it back to MyBot.run.exe and restart the bot!')
	If $iCount = UBound($aCheckFiles) Then
		$bResult = True
	ElseIf Not $bSilent Then
		GUICtrlSetState($g_hBtnStart, $GUI_DISABLE)

		SetLog($sText1, $COLOR_ERROR)
		SetLog($sText2, $COLOR_ERROR)
		SetLog($sText3, $COLOR_ERROR)

		_ExtMsgBoxSet(1 + 64, $SS_CENTER, 0x004080, 0xFFFF00, 12, "Comic Sans MS", 500)
		$MsgBox = _ExtMsgBox(48, GetTranslatedFileIni("MBR Popups", "Ok", "Ok"), $sText1, $sText2, 0)
	EndIf
	If @Compiled Then ;if .exe
		If Not StringInStr(@ScriptFullPath, "MyBot.run.exe", 1) Then ; if filename isn't MyBot.run.exe
			If Not $bSilent Then

				SetLog($sText1, $COLOR_ERROR)
				SetLog($sText5, $COLOR_ERROR)
				SetLog($sText3, $COLOR_ERROR)

				_ExtMsgBoxSet(1 + 64, $SS_CENTER, 0x004080, 0xFFFF00, 12, "Comic Sans MS", 500)
				$MsgBox = _ExtMsgBox(48, GetTranslatedFileIni("MBR Popups", "Ok", "Ok"), $sText1, $sText5, 0)
				GUICtrlSetState($g_hBtnStart, $GUI_DISABLE)
			EndIf
			$bResult = False
		EndIf
	EndIf
	Return $bResult
EndFunc   ;==>isEveryFileInstalled

Func CheckAutoitVersion($bSilent = False)
	If @Compiled = True Then Return 1
	Local $requiredAutoit = "3.3.14.2"
	Local $result = _VersionCompare(@AutoItVersion, $requiredAutoit)
	If $result = 0 Or $result = 1 Then Return 1
	If Not $bSilent Then
		Local $sText1 = "Hey Chief, your AutoIt version is out of date!"
		Local $sText3 = "Click OK to download the latest version of AutoIt."
		Local $sText2 = "The bot requires AutoIt version " & $requiredAutoit & " or above. Your version of AutoIt is " & @AutoItVersion & "." & @CRLF & $sText3 & @CRLF & "After installing the new version, open the bot again."
		_ExtMsgBoxSet(1 + 64, $SS_CENTER, 0x004080, 0xFFFF00, 12, "Comic Sans MS", 500)
		Local $MsgBox = _ExtMsgBox(48, "OK|Cancel", $sText1, $sText2, 0)
		If $MsgBox = 1 Then ShellExecute("https://www.autoitscript.com/site/autoit/downloads/")
	EndIf
	Return 0
EndFunc   ;==>checkAutoitVersion

Func CheckIsAdmin($bSilent = False)
	If IsAdmin() Then Return True
	If Not $bSilent Then SetLog("My Bot running without admin privileges", $COLOR_ERROR)
	Return False
EndFunc   ;==>checkIsAdmin