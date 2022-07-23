#include-once

#Region Header

#CS
	Name: 				OnAutoItErrorRegister - Register AutoIt critical error handler (syntax error usualy).
	Author: 			Copyright © 2011-2015 CreatoR's Lab (G.Sandler), www.creator-lab.ucoz.ru, www.autoit-script.ru. All rights reserved.
	AutoIt version: 	3.3.10.2 - 3.3.12.0
	UDF version:		2.0

	Credits:
						* JScript (João Carlos) - code parts and few ideas from _AutoItErrorTrap UDF.

	Notes:
						* The UDF can not handle crashes that triggered by memory leaks, such as DllCall crashes, "Recursion level has been exceeded..." (when using hook method ($bUseStdOut = False)).
						* When using StdOut method ($bUseStdOut = True), CUI not supported, and additional process executed to allow monitor for errors.
						* After using _OnAutoItErrorUnRegister when $bUseStdOut = True, standard AutoIt error message will not be displayed on following syntax error.
						* To use the "Send bug report" feature, there is need to fill related parameters (variables) under the «User Variables» section in UDF file (check the comments of these variables), or just build your own user function.

						[If $bSetErrLine is True...]
							* Script must be executed before compilation (after any change in it), or use '#AutoIt3Wrapper_Run_Before=%autoitdir%\AutoIt3.exe "%in%" /BC_Strip' in your main script.
							* Do NOT use Au3Stripper when compiling the main script if you want correct error line detection for compiled script.
							* To get correct code line for compiled script, the script is transformed to raw source (merging includes) and FileInstall'ed when it's needed (on error),
								therefore, the script is available in temp dir for few moments (when error is triggered), although it's crypted, but developer should ensure that his script is more protected.

						[If $bSetErrLine is False...]
							* Use supplied GetErrLineCode.au3 to get proper error line code by line number from error that was triggered in compiled script.

	History:
	v2.0
	* UDF rewritten (used methods from AutoItErrorTrap UDF).
	  - Syntax changed, check function header for details.
	* Dropped AutoIt 3.3.8.1 support.
	+ Added last window screen capture feature. File can be sent as attachment when using "Send Bug Report" feature.

	v1.9
	+ Added error line detection for compiled script (to display actual line which caused the error).
		Script must be executed before compilation (after any change in it), or use '#AutoIt3Wrapper_Run_Before=%autoitdir%\AutoIt3.exe "%in%" /BC_Strip' in your main script.
		!!! Do NOT use Au3Stripper when compiling the main script.
	+ Added second function call detection (to prevent multiple recursive execution).
	* Fixed command line issue.

	v1.8
	+ Added 3.3.12.0 compatibility.
	+ Added _OnAutoItErrorUnRegister (see Example 1).
	* Now callback function ($sFunction) in _OnAutoItErrorRegister always recieve 4 parameters ($sScriptPath, $iScriptLine, $sErrDesc, $vParams).
	* Internal functions renamed from __OnAutoItErrorRegister_* to __OAER_*.
	* Removed the usage of command line to detect second script run.
	* More stability in detecting AutoIt error message (when $bUseStdOutMethod = False).
	* Fixed issue when main script (or other UDF) uses Opt('MustDeclareVars', 1).

	v1.7
	* Fixed an issue with showing tray icon even if #NoTrayIcon is specified in the main script.
	* Fixed an issue with not passing the original command line parameters to the main script.
	   Now added /OAER parameter to the command line at the end, it's an identifier for OnAutoItErrorRegister UDF.

	v1.6
	* Fixed an issue with COM errors catching (this UDF should not handle COM errors, it was just for sending email function).
	* Removed unneccessary #include <File.au3>.
	* Fixed bug with auto-ckicked buttons on Windows Vista/7.

	v1.5
	* Fixed issue with high CPU usage
	* "Send bug report" feature improved grately.
	* Added ability to translate all UDF elements (titles, messages, buttons and labels) - see "User Variables" section.
	* Cosmetic changes to the code.

	v1.4
	* UDF rewrited.

#CE
#cs
#include <WindowsConstants.au3>
#include <WinAPIShPath.au3>
#include <WinAPIProc.au3>
#include <WinAPILocale.au3>
#include <WinAPIFiles.au3>
#include <WinAPI.au3>
#include <StaticConstants.au3>
#include <ScreenCapture.au3>
#include <GUIConstantsEx.au3>
#include <Date.au3>
#include <Crypt.au3>
#include <Constants.au3>
;OnAutoItExitRegister('__OAER_OnExit')
#ce

#EndRegion Header

#Region Global Variables

Global Enum _
	$iOAER_bSet_ErrLine, $iOAER_bIn_Proc, $iOAER_bUse_StdOut, $iOAER_iPID, $iOAER_hErr_Callback, $iOAER_hErr_WinHook, $iOAER_sUserFunc, $iOAER_vUserParams, $iOAER_iCOMErrorNumber, $iOAER_sCOMErrorDesc, _
	$iOAER_Total

Global $aOAER_DATA[$iOAER_Total]

#EndRegion Global Variables

#Region Public Functions

; #FUNCTION# ====================================================================================================
; Name...........:	_OnAutoItErrorRegister
; Description....:	Registers a function to be called when AutoIt produces a critical error (syntax error usualy).
; Syntax.........:	_OnAutoItErrorRegister( [$sFunction = '' [, $vParams = '' [, $sTitle = '' [, $bUseStdOut = False [, $bSetErrLine = False]]]]])
; Parameters.....:	$sFunction        - [Optional] The name of the user function to call.
;                                           If this parameter is empty (''), then default (built-in) error message function is called.
;                                           Function always called with these arguments:
;                                           							$sScript_Path 	- Full path to the script / executable
;                                           							$iScript_Line	- Error script line number
;                                           							$sError_Msg		- Error message
;                                           							$vParams		- User parameters passed by $vParams
;                                           							$g_hBitmap        - hBitmap of last screen capture.
;					$vParams          - [Optional] User defined parameters that passed to $sFunction (default is '' - no parameters).
;					$sTitle           - [Optional] The title of the default error message dialog (used only if $sFunction = '').
;					$bUseStdOut       - [Optional] Defines the method that will be used to catch AutoIt errors (default is False - use hook method).
;					$bSetErrLine      - [Optional] Defines whether to enable error line code detection in compiled script or not (default is False - not enabled).
;
; Return values..:	None.
; Author.........:	G.Sandler (CreatoR), www.autoit-script.ru, www.creator-lab.ucoz.ru
; Remarks........:
; Related........:	_OnAutoItErrorUnRegister
; Example........:	Yes.
; ===============================================================================================================
Func _OnAutoItErrorRegister()
	If $aOAER_DATA[$iOAER_hErr_WinHook] Then
		Return ;Prevent conflicts
	EndIf

	;Trap the error window using callback!!!
	$aOAER_DATA[$iOAER_hErr_CallBack] = DllCallbackRegister('__OAER_OnErrorCallback', 'int', 'int;int;int')
	$aOAER_DATA[$iOAER_hErr_WinHook] = _WinAPI_SetWindowsHookEx($WH_CBT, DllCallbackGetPtr($aOAER_DATA[$iOAER_hErr_CallBack]), 0, _WinAPI_GetCurrentThreadId())

	If Not $aOAER_DATA[$iOAER_hErr_WinHook] Then
		DllCallbackFree($aOAER_DATA[$iOAER_hErr_CallBack])
		Return 0
	Else
		Return 1
	EndIf
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _OnAutoItErrorUnRegister
; Description ...: UnRegister AutoIt Error Handler.
; Syntax ........: _OnAutoItErrorUnRegister()
; Parameters ....: None.
; Return values .: None.
; Author ........: G.Sandler
; Remarks .......: If $bUseStdOut = True is set for _OnAutoItErrorRegister, standard AutoIt error message will not be displayed on syntax error.
; Related .......: _OnAutoItErrorRegister
; Example .......: Yes.
; ===============================================================================================================================
Func _OnAutoItErrorUnRegister()
	__OAER_OnExit()
EndFunc

#EndRegion Public Functions

#Region Internal Functions

Func __OAER_OnExit()
	If $aOAER_DATA[$iOAER_hErr_WinHook] Then
		_WinAPI_UnhookWindowsHookEx($aOAER_DATA[$iOAER_hErr_WinHook])
		$aOAER_DATA[$iOAER_hErr_WinHook] = 0
	EndIf

	If $aOAER_DATA[$iOAER_hErr_CallBack] Then
		DllCallbackFree($aOAER_DATA[$iOAER_hErr_CallBack])
		$aOAER_DATA[$iOAER_hErr_CallBack] = 0
	EndIf
EndFunc

Func __OAER_OnErrorCallback($nCode, $wParam, $lParam)
	If $nCode < 0 Then
		Return _WinAPI_CallNextHookEx($aOAER_DATA[$iOAER_hErr_WinHook], $nCode, $wParam, $lParam)
	EndIf

	Switch $nCode
		Case 5 ; HCBT_ACTIVATE
			If Not _WinAPI_FindWindow('#32770', 'AutoIt Error') Then
				Return _WinAPI_CallNextHookEx($aOAER_DATA[$iOAER_hErr_WinHook], $nCode, $wParam, $lParam)
			EndIf

			Local $hError_Wnd = HWnd($wParam)
			Local $sError_Msg = StringRegExpReplace(ControlGetText($hError_Wnd, '', 'Static2'), '(?<!\r)\n', @CRLF)

			If (_WinAPI_GetClassName($hError_Wnd) <> '#32770' And WinGetTitle($hError_Wnd) <> 'AutoIt Error') Or Not StringRegExp($sError_Msg, '(?is)^.*Line \d+\s+\(File "(.*?)"\):\s+.*Error: .*') Then
				Return _WinAPI_CallNextHookEx($aOAER_DATA[$iOAER_hErr_WinHook], $nCode, $wParam, $lParam)
			EndIf

			;_WinAPI_DestroyWindow($hError_Wnd)
			SetDebugLog($g_sBotTitle & " AutoIt Error: " & $sError_Msg, Default, True)

			BotClose(Default, False)

			_WinAPI_FatalAppExit($sError_Msg)
			#cs
			MsgBox(BitOR($MB_ICONERROR, $MB_SERVICE_NOTIFICATION), $g_sBotTitle & " CRASHED", $sError_Msg)
			ProcessClose(@AutoItPID)
			Exit(1)
			#ce
	EndSwitch

	Return _WinAPI_CallNextHookEx($aOAER_DATA[$iOAER_hErr_WinHook], $nCode, $wParam, $lParam)
EndFunc

#EndRegion Internal Functions
