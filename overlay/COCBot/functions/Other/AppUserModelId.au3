; #FUNCTION# ====================================================================================================================
; Name ..........: _WindowAppId
; Description ...: Get / Set AppUerModelId(AppId) of a window
; Syntax.........: _WindowAppId($hWnd, $appid = Default)
; Parameters ....: $hWnd - Handle of a window.
;                  $appid - [optional] AppId to set.
; Return values .: Success - Returns current AppId
;                  Failure - Returns "" and sets @error:
; Author ........: binhnx, jackchen
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Link ..........: https://www.autoitscript.com/forum/topic/168099-how-to-prevent-multiple-guis-from-combining-in-the-taskbar/
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Example .......: No
; ===============================================================================================================================

#include-once
; file name: AppUserModelId.au3
; https://www.autoitscript.com/forum/topic/161005-group-different-apps-on-win-7-taskbar/

; #### Title ####
; ================================================================================
; Get / Set AppUserModelId for a window or a shortcut file(*.lnk)
; Thanks to binhnx, LarsJ and others
; - jackchen
; ================================================================================

; #### FUNCTIONS ####
; ================================================================================
; _WindowAppId
; _ShortcutAppId
; ================================================================================

#include <WinAPI.au3>

#Region ====================== #### CONSTANTS #### ======================
; https://www.autoitscript.com/forum/topic/161067-get-clsid-from-iid/
Global Const $CLSID_ShellLink = "{00021401-0000-0000-C000-000000000046}"
Global Const $sIID_IShellLinkW = "{000214F9-0000-0000-C000-000000000046}"
Global Const $tag_IShellLinkW = _
		"GetPath hresult(long;long;long;long);" & _
		"GetIDList hresult(long);" & _
		"SetIDList hresult(long);" & _
		"GetDescription hresult(long;long);" & _
		"SetDescription hresult(wstr);" & _
		"GetWorkingDirectory hresult(long;long);" & _
		"SetWorkingDirectory hresult(long;long);" & _
		"GetArguments hresult(long;long);" & _
		"SetArguments hresult(ptr);" & _
		"GetHotkey hresult(long);" & _
		"SetHotkey hresult(word);" & _
		"GetShowCmd hresult(long);" & _
		"SetShowCmd hresult(int);" & _
		"GetIconLocation hresult(long;long;long);" & _
		"SetIconLocation hresult(wstr;int);" & _
		"SetRelativePath hresult(long;long);" & _
		"Resolve hresult(long;long);" & _
		"SetPath hresult(wstr);"

Global Const $tag_IPersist = "GetClassID hresult(long);"
Global Const $sIID_IPersistFile = "{0000010b-0000-0000-C000-000000000046}"
Global Const $tag_IPersistFile = $tag_IPersist & _ ; Inherits from IPersist
		"IsDirty hresult();" & _
		"Load hresult(wstr;dword);" & _
		"Save hresult(wstr;bool);" & _
		"SaveCompleted hresult(long);" & _
		"GetCurFile hresult(long);"

; https://msdn.microsoft.com/en-us/library/windows/desktop/aa380337(v=vs.85).aspx
Global Const $STGM_READ = 0x00000000
Global Const $STGM_READWRITE = 0x00000002
Global Const $STGM_SHARE_DENY_NONE = 0x00000040

; Global Const $tagPROPERTYKEY = $tagGUID & ';DWORD pid'
Global Const $tagPROPERTYKEY = 'struct;ulong Data1;ushort Data2;ushort Data3;byte Data4[8];DWORD pid;endstruct'
Global $tagPROPVARIANT = _
		'USHORT vt;' & _ ;typedef unsigned short VARTYPE; - in WTypes.h
		'WORD wReserved1;' & _
		'WORD wReserved2;' & _
		'WORD wReserved3;' & _
		'LONG;PTR' ;union, use the largest member (BSTRBLOB, which is 96-bit in x64)

Global Const $sIID_IPropertyStore = '{886D8EEB-8CF2-4446-8D02-CDBA1DBDCF99}'
Global Const $VT_EMPTY = 0, $VT_LPWSTR = 31
#EndRegion ====================== #### CONSTANTS #### ======================


; #FUNCTION# ;===============================================================================
; Name...........: _WindowAppId
; Description ...: Get / Set AppUerModelId(AppId) of a window
; Syntax.........: _WindowAppId($hWnd, $appid = Default)
; Parameters ....: $hWnd - Handle of a window.
;                  $appid - [optional] AppId to set.
; Return values .: Success - Returns current AppId
;                  Failure - Returns "" and sets @error:
; Author ........: binhnx, jackchen
; Link ..........: https://www.autoitscript.com/forum/topic/168099-how-to-prevent-multiple-guis-from-combining-in-the-taskbar/
;============================================================================================
Func _WindowAppId($hWnd, $appid = Default)
	Local $tpIPropertyStore = DllStructCreate('ptr')
	_WinAPI_SHGetPropertyStoreForWindow($hWnd, $sIID_IPropertyStore, $tpIPropertyStore)
	Local $pPropertyStore = DllStructGetData($tpIPropertyStore, 1)
	$tpIPropertyStore = 0

	Local $oPropertyStore = ObjCreateInterface($pPropertyStore, $sIID_IPropertyStore, _
			'GetCount HRESULT(PTR);GetAt HRESULT(DWORD; PTR);GetValue HRESULT(PTR;PTR);' & _
			'SetValue HRESULT(PTR;PTR);Commit HRESULT()')
	If Not IsObj($oPropertyStore) Then Return SetError(1, 0, '')

	Local $tPKEY = _PKEY_AppUserModel_ID()
	Local $tPROPVARIANT = DllStructCreate($tagPROPVARIANT)
	Local $sAppId
	If $appid = Default Then
		$oPropertyStore.GetValue(DllStructGetPtr($tPKEY), DllStructGetPtr($tPROPVARIANT))
		; Extracts a string value from a PROPVARIANT structure
		; http://deletethis.net/dave/dev/setappusermodelid/
		; https://msdn.microsoft.com/en-us/library/windows/desktop/bb776559(v=vs.85).aspx
		If DllStructGetData($tPROPVARIANT, 'vt') <> $VT_EMPTY Then
			Local $buf = DllStructCreate('wchar[128]')
			DllCall('Propsys.dll', 'long', 'PropVariantToString', _
					'ptr', DllStructGetPtr($tPROPVARIANT), _
					'ptr', DllStructGetPtr($buf), _
					'uint', DllStructGetSize($buf))
			If Not @error Then
				$sAppId = DllStructGetData($buf, 1)
			EndIf
			$buf = 0
		EndIf
	Else
		_WinAPI_InitPropVariantFromString($appid, $tPROPVARIANT)
		$oPropertyStore.SetValue(DllStructGetPtr($tPKEY), DllStructGetPtr($tPROPVARIANT))
		$oPropertyStore.Commit()
		$sAppId = $appid
	EndIf

	$tPROPVARIANT = 0
	$tPKEY = 0

	;$oPropertyStore.Release() ; this line crashes Autoit
	Return SetError(($sAppId == '') * 2, 0, $sAppId)
EndFunc   ;==>_WindowAppId


; #FUNCTION# ;===============================================================================
; Name...........: _ShortcutAppId
; Description ...: Get AppUerModelId(AppId) from a .lnk shortcut file or
;                  set the shortcut's AppId if $appid is provided.
; Syntax.........: _ShortcutAppId($lnkfile, $appid = Default)
; Parameters ....: $lnkfile - path of shortcut file.
;                  $appid - [optional] AppId to set.
; Return values .: Success - Returns current AppId
;                  Failure - Returns "" and sets @error:
; Author ........: jackchen
; Linlk .........: https://code.google.com/p/win7appid/
;============================================================================================
Func _ShortcutAppId($lnkfile, $appid = Default)
	Local $oIShellLinkW = ObjCreateInterface($CLSID_ShellLink, $sIID_IShellLinkW, $tag_IShellLinkW)
	If Not IsObj($oIShellLinkW) Then Return SetError(1, 0, '')

	Local $pIPersistFile, $oIPersistFile, $ret, $sAppId
	Local $tRIID_IPersistFile = _WinAPI_GUIDFromString($sIID_IPersistFile)
	$oIShellLinkW.QueryInterface($tRIID_IPersistFile, $pIPersistFile)
	$oIPersistFile = ObjCreateInterface($pIPersistFile, $sIID_IPersistFile, $tag_IPersistFile)
	If IsObj($oIPersistFile) Then
		If $appid == Default Then ; read only
			$ret = $oIPersistFile.Load($lnkfile, BitOR($STGM_READ, $STGM_SHARE_DENY_NONE))
		Else
			$ret = $oIPersistFile.Load($lnkfile, $STGM_READWRITE)
		EndIf
		If $ret = 0 Then
			Local $tPKEY = _PKEY_AppUserModel_ID()
			Local $tPROPVARIANT = DllStructCreate($tagPROPVARIANT)

			Local $tRIID_IPropertyStore = _WinAPI_GUIDFromString($sIID_IPropertyStore)

			Local $pPropertyStore
			$oIShellLinkW.QueryInterface($tRIID_IPropertyStore, $pPropertyStore)

			Local $oPropertyStore = ObjCreateInterface($pPropertyStore, $sIID_IPropertyStore, _
					'GetCount HRESULT(PTR);GetAt HRESULT(DWORD;PTR);GetValue HRESULT(PTR;PTR);' & _
					'SetValue HRESULT(PTR;PTR);Commit HRESULT()')
			If IsObj($oPropertyStore) Then
				If $appid == Default Then ; get appid
					$oPropertyStore.GetValue(DllStructGetPtr($tPKEY), DllStructGetPtr($tPROPVARIANT))
					If DllStructGetData($tPROPVARIANT, 'vt') <> $VT_EMPTY Then
						; Extracts a string value from a PROPVARIANT structure
						; http://deletethis.net/dave/dev/setappusermodelid/
						; https://msdn.microsoft.com/en-us/library/windows/desktop/bb776559(v=vs.85).aspx
						Local $buf = DllStructCreate('wchar[128]')
						DllCall('Propsys.dll', 'long', 'PropVariantToString', _
								'ptr', DllStructGetPtr($tPROPVARIANT), _
								'ptr', DllStructGetPtr($buf), _
								'uint', DllStructGetSize($buf))
						$sAppId = DllStructGetData($buf, 1)
						$buf = 0
					EndIf
				Else ; set appid
					_WinAPI_InitPropVariantFromString($appid, $tPROPVARIANT)
					$oPropertyStore.SetValue(DllStructGetPtr($tPKEY), DllStructGetPtr($tPROPVARIANT))
					$oPropertyStore.Commit()
					$oIPersistFile.Save($lnkfile, True)
					$sAppId = $appid
				EndIf
			EndIf

			$tPROPVARIANT = 0
			$tPKEY = 0
		EndIf
	EndIf
	If IsObj($oPropertyStore) Then $oPropertyStore.Release()
	If IsObj($oIPersistFile) Then $oIPersistFile.Release()
	If IsObj($oIShellLinkW) Then $oIShellLinkW.Release()
	Return SetError(($sAppId == '') * 2, 0, $sAppId)
EndFunc   ;==>_ShortcutAppId

; https://www.autoitscript.com/forum/topic/168099-how-to-prevent-multiple-guis-from-combining-in-the-taskbar/
; This function is not exposed in any dll, but inlined in propvarutil.h so we need to rewrite it entirely in AutoIt
Func _WinAPI_InitPropVariantFromString($sUnicodeString, ByRef $tPROPVARIANT)
	DllStructSetData($tPROPVARIANT, 'vt', $VT_LPWSTR)
	Local $aRet = DllCall('Shlwapi.dll', 'LONG', 'SHStrDupW', _
			'WSTR', $sUnicodeString, 'PTR', DllStructGetPtr($tPROPVARIANT) + 8)

	If @error Then Return SetError(@error, @extended, False)
	Local $bSuccess = $aRet[0] == 0

	; If fails, zero memory of the current PROPVARIANT struct
	If (Not $bSuccess) Then $tPROPVARIANT = DllStructCreate($tagPROPVARIANT)
	Return SetExtended($aRet[0], $bSuccess)
EndFunc   ;==>_WinAPI_InitPropVariantFromString

; https://www.autoitscript.com/forum/topic/168099-how-to-prevent-multiple-guis-from-combining-in-the-taskbar/
Func _PKEY_AppUserModel_ID()
	Local $tPKEY = DllStructCreate($tagPROPERTYKEY)
	;PKEY_AppUserModel_ID = { {0x9F4C2855, 0x9F79, 0x4B39,
	;   {0xA8, 0xD0, 0xE1, 0xD4, 0x2D, 0xE1, 0xD5, 0xF3}}, 5 }
	_WinAPI_GUIDFromStringEx('{9F4C2855-9F79-4B39-A8D0-E1D42DE1D5F3}', _
			DllStructGetPtr($tPKEY))
	DllStructSetData($tPKEY, 'pid', 5)
	Return $tPKEY
EndFunc   ;==>_PKEY_AppUserModel_ID

; https://www.autoitscript.com/forum/topic/168099-how-to-prevent-multiple-guis-from-combining-in-the-taskbar/
Func _WinAPI_SHGetPropertyStoreForWindow($hWnd, $sIID, ByRef $tPointer)
	Local $tIID = _WinAPI_GUIDFromString($sIID)
	Local $pp = IsPtr($tPointer) ? $tPointer : DllStructGetPtr($tPointer)
	Local $aRet = DllCall('Shell32.dll', 'LONG', 'SHGetPropertyStoreForWindow', _
			'HWND', $hWnd, 'STRUCT*', $tIID, 'PTR', $pp)
	If @error Then Return SetError(@error, @extended, False)
	Return SetExtended($aRet[0], ($aRet[0] = 0))
EndFunc   ;==>_WinAPI_SHGetPropertyStoreForWindow
