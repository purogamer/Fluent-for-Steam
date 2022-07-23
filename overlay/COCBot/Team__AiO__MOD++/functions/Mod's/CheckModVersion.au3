; #FUNCTION# ====================================================================================================================
; Name ..........: CheckVersion
; Description ...: Check if we have last version of program
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Sardo (2015-06)
; Modified ......: CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Func CheckModVersion($bSilent = True)
	Local $bUpdate = False
	If not $g_bCheckVersion Then Return
	
	; Get the last Version from API
	Local $g_sBotGitVersion = ""
	Local $sCorrectStdOut = InetRead("https://api.github.com/repos/boludoz/AIO-Mod/releases/latest")
	If @error Or $sCorrectStdOut = "" Then Return
	Local $Temp = BinaryToString($sCorrectStdOut)

	If $Temp <> "" And Not @error Then
		Local $g_aBotVersionN = StringSplit($g_sModVersion, " ", 2)
		Local $g_iBotVersionN
		If @error Then
			$g_iBotVersionN = StringReplace($g_sModVersion, "v", "")
		Else
			$g_iBotVersionN = StringReplace($g_aBotVersionN[0], "v", "")
		EndIf
		Local $version = GetLastVersion($Temp)
		$g_sBotGitVersion = StringReplace($version[0], "v", "")
		SetDebugLog("Last GitHub version is " & $g_sBotGitVersion )
		SetDebugLog("Your version is " & $g_iBotVersionN )

		If _VersionCompare($g_iBotVersionN, $g_sBotGitVersion) = -1 Then
			If not $bSilent Then SetLog("WARNING, YOUR AIO VERSION (" & $g_iBotVersionN & ") IS OUT OF DATE.", $COLOR_INFO)
			$g_bNewModAvailable = True
			Local $ChangelogTXT = GetLastChangeLog($Temp)
			Local $Changelog = StringSplit($ChangelogTXT[0], '\r\n', $STR_ENTIRESPLIT + $STR_NOCOUNT)
			For $i = 0 To UBound($Changelog) - 1
				If not $bSilent Then SetLog($Changelog[$i] )
			Next
			PushMsg("Update")
			$bUpdate = True
		ElseIf _VersionCompare($g_iBotVersionN, $g_sBotGitVersion) = 0 Then
			If not $bSilent Then SetLog("WELCOME CHIEF, YOU HAVE THE LATEST AIO MOD VERSION", $COLOR_SUCCESS)
			$g_bNewModAvailable = False
		Else
			If not $bSilent Then SetLog("YOU ARE USING A FUTURE VERSION CHIEF!", $COLOR_ACTION)
			$g_bNewModAvailable = False
		EndIf
	Else
		SetDebugLog($Temp)
	EndIf
	
	; If $bUpdate Then
		; Local $iNewVersion  = MsgBox (4, "New version " & $g_sBotGitVersion ,"Do you want to download the latest update?", 10)
			
		; If $iNewVersion = 6 Then
			; Local $sUrl='https://github.com/boludoz/AIO-Mod/releases/download/v' & $g_sBotGitVersion & '/MyBot.run.zip'
			; ShellExecute($sUrl)
			; Exit
		; EndIf
	; EndIf
	
	Local $aReturn[2] = ["v" & $g_sBotGitVersion, $bUpdate]
	Return $aReturn
EndFunc   ;==>CheckModVersion