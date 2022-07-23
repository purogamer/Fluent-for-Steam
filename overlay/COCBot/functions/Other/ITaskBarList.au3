
; #INDEX# =======================================================================================================================
; Title .........: ITaskBarList
; AutoIt Version : 3.3.7.18 (Beta)
; Language ......: English
; Description ...: Functions to assist in using the ITaskBarList Interface.
; Author(s) .....: Brian J Christy (Beege)
; Modified ......: cosote (2019-May)
; Link ..........: https://www.autoitscript.com/forum/topic/111018-itaskbarlist-udf-rewrite-for-beta-all-methods-included/
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
; _ITaskBar_CreateTaskBarObj - Creates a ITaskBarList object.
; _ITaskBar_SetOverlayIcon - Applies an overlay to a taskbar button to indicate application status or a notification to the user.
; _ITaskBar_SetThumbNailClip - Selects a portion of a window's client area to display as that window's thumbnail in the taskbar.
; _ITaskBar_AddTBButtons - Applies buttons that have been previously created using _ITaskBar_CreateTBButton()
; _ITaskBar_CreateTBButton - Creates a ThumbBar button
; _ITaskBar_UpdateTBButton - Shows, enables, disables, or hides buttons in a thumbnail toolbar as required by the window's current state.
; _ITaskBar_SetTBImageList - Specifies an image list that contains button images for a toolbar embedded in a thumbnail image of a window in a taskbar button flyout.
; _ITaskBar_ActivateTab - Activates an item on the taskbar. The window is not actually activated; the window's item on the taskbar is merely displayed as active.
; _ITaskBar_AddTab - Adds an item to the taskbar.
; _ITaskBar_DeleteTab - Deletes an item from the taskbar.
; _ITaskBar_SetActiveAlt - Marks a taskbar item as active but does not visually activate it.
; _ITaskBar_MarkFullscreenWindow - Marks a window as full-screen.
; _ITaskBar_RegisterTab - Informs the taskbar that a new tab or document thumbnail has been provided for display in an application's taskbar group flyout.
; _ITaskBar_UnregisterTab - Removes a thumbnail from an application's preview group when that tab or document is closed in the application.
; _ITaskBar_SetTabProperties - Allows a tab to specify whether the main application frame window or the tab window should be used as a thumbnail or in the peek feature under certain circumstances.
; _ITaskBar_SetProgressState - Sets the type and state of the progress indicator displayed on a taskbar button.
; _ITaskBar_SetProgressValue - Displays or updates a progress bar hosted in a taskbar button to show the specific percentage completed of the full operation.
; _ITaskBar_SetTabActive - Informs the taskbar that a tab or document window has been made the active window.
; _ITaskBar_SetTabOrder - Inserts a new thumbnail into a tabbed-document interface (TDI) or multiple-document interface (MDI) application's group flyout or moves an existing thumbnail to a new position in the application's group.
; _ITaskBar_SetThumbNailToolTip - Specifies or updates the text of the tooltip that is displayed when the mouse pointer rests on an individual preview thumbnail in a taskbar button flyout.
; _ITaskBar_DestroyObject - Destroys ITaskBarObject and icons freeing any memory the icons occupied
; ===============================================================================================================================

#include-once
#include <WindowsConstants.au3>
#include <WinAPI.au3>
#include <GUIConstantsEx.au3>
#include <Constants.au3>

#Region Global Variables and Constants
	;THUMBBUTTONMASK
	Global Const $THB_BITMAP = 0x00000001
	Global Const $THB_ICON = 0x00000002
	Global Const $THB_TOOLTIP = 0x00000004
	Global Const $THB_FLAGS = 0x00000008
	;THUMBBUTTONFLAGS
	Global Const $THBF_ENABLED = 0x00000000
	Global Const $THBF_DISABLED = 0x00000001
	Global Const $THBF_DISMISSONCLICK = 0x00000002
	Global Const $THBF_NOBACKGROUND = 0x00000004
	Global Const $THBF_HIDDEN = 0x00000008
	Global Const $THBF_NONINTERACTIVE = 0x00000010
	;THUMBBUTTONEVENTS
	Global Const $THBN_CLICKED = 0x1800

	Global $g_ITBL_oTaskBar = 0
	Global $g_ITBL_oButtonIDs = ObjCreate("Scripting.Dictionary")
	Global $g_WM_TaskbarButtonCreated = _WinAPI_RegisterWindowMessage("TaskbarButtonCreated")
	Global $g_ITBL_bTaskBarReady = 0
	Global Enum $g_ITBL_DllStruct = 1, $g_ITBL_hGui
	Global Enum $g_ITBL_iID, $g_ITBL_hIcon, $g_ITBL_sToolTip, $g_ITBL_sCallFunc, $g_ITBL_iFlags, $g_ITBL_iBitmap, $g_ITBL_iMask, $g_ITBL_Max
	Global $g_ITBL_aButtons[1][$g_ITBL_Max] = [[0, 0]]
	#cs
		$g_ITBL_aButtons[0][0] 						= Button Count
		$g_ITBL_aButtons[0][$g_ITBL_DllStruct] 		= DllStruct Array contating THUMBSTRUCTURES
		$g_ITBL_aButtons[0][$g_ITBL_hGui] 			= Handle to GUI

		$g_ITBL_aButtons[$i][$g_ITBL_iID] 			= Button ID
		$g_ITBL_aButtons[$i][$g_ITBL_hIcon]			= Handle to button icon
		$g_ITBL_aButtons[$i][$g_ITBL_sToolTip]		= Text that is displayed when mouse hovers button
		$g_ITBL_aButtons[$i][$g_ITBL_sCallFunc]		= Function to call when button is pressed
		$g_ITBL_aButtons[$i][$g_ITBL_iFlags]		= A combination of THUMBBUTTONFLAGS values that control specific states and behaviors of the button.
		$g_ITBL_aButtons[$i][$g_ITBL_iBitmap]		= Zero-based index of the button image within the image list set through set through _ThumbBar_SetImageList.
		$g_ITBL_aButtons[$i][$g_ITBL_iMask]			= A combination of THUMBBUTTONMASK values that specify which members of this structure contain valid data
	#ce
#EndRegion Global Variables and Constants

Global $g_ITBL_oErrorHandler ; Custom fix - Team AIO Mod++

Func _ITaskBar_Init($bRegisterWM_COMMAND = True)
	$g_ITBL_oErrorHandler = ""
	If $bRegisterWM_COMMAND Then GUIRegisterMsg($WM_COMMAND, '__TaskbarWM_Command')
	GUIRegisterMsg($g_WM_TaskbarButtonCreated, "__TaskbarButtonCreated")
	OnAutoItExitRegister('__TaskbarExit')
	;ClipPut(_CreateUDFHeader())
EndFunc   ;==>_ITaskBar_Init

#Region Public Functions
	; #FUNCTION# ====================================================================================================
	; Name...........:	_ITaskBar_CreateTaskBarObj
	; Description....:	Creates a ITaskBarList object.
	; Syntax.........:	_ITaskBar_CreateTaskBarObj($bInitiate = True, $bErrorHandler = True)
	; Parameters.....:	$bInitiate - [Optional] - Initiates taskbarlist object.This is a requirment that must be happen
	;					before any other function can be called.
	;					$bErrorHandler - [Optional] - Registers an error handler that allows autoit to intercept any com
	;					before they allow your script to crash. Highly recommend that you have one. It is left optional
	;					incase the user wants to use thier own.
	; Return values..:	Success - ITaskBarList object
	;					Failure - 0 and sets @error:
	;					1 - Error creating interface
	;					2 - Taskbar Button Creation Timeout
	;					3 - ObjectInterface returned is not an object.
	; Author.........:	Brian J Christy (Beege)
	; Remarks........:	The ITaskBarList object returned by this function is also held in a global variable that gets used by all
	;					functions in this udf.
	; ===============================================================================================================
	Func _ITaskBar_CreateTaskBarObj($bInitiate = True, $bErrorHandler = True)

		If IsObj($g_ITBL_oTaskBar) Then Return $g_ITBL_oTaskBar
		If $bErrorHandler Then $g_ITBL_oErrorHandler = ObjEvent("AutoIt.Error", "__TaskbarErrFunc")

		Local $CLSID_TaskBarlist4 = "{56FDF344-FD6D-11D0-958A-006097C9A090}"
		Local $IID_ITaskbarList4 = "{56FDF342-FD6D-11d0-958A-006097C9A090}"
		Local $tagITaskbarList4 = "HrInit hresult();" & _
				"AddTab hresult(hwnd);" & _
				"DeleteTab hresult(hwnd);" & _
				"ActivateTab hresult(hwnd);" & _
				"SetActiveAlt hresult(hwnd);" & _
				"MarkFullscreenWindow hresult(hwnd;bool);" & _
				"SetProgressValue hresult(hwnd;uint64;uint64);" & _
				"SetProgressState hresult(hwnd;int);" & _
				"RegisterTab hresult(hwnd;hwnd);" & _
				"UnregisterTab hresult(hwnd);" & _
				"SetTabOrder hresult(hwnd;hwnd);" & _
				"SetTabActive hresult(hwnd;hwnd;dword);" & _
				"ThumbBarAddButtons hresult(hwnd;uint;ptr);" & _
				"ThumbBarUpdateButtons hresult(hwnd;uint;ptr);" & _
				"ThumbBarSetImageList hresult(hwnd;ptr);" & _
				"SetOverlayIcon hresult(hwnd;ptr;wstr);" & _
				"SetThumbnailTooltip hresult(hwnd;wstr);" & _
				"SetThumbnailClip hresult(hwnd;ptr);" & _
				"SetTabProperties hresult(hwnd;int);"

		$g_ITBL_oTaskBar = ObjCreateInterface($CLSID_TaskBarlist4, $IID_ITaskbarList4, $tagITaskbarList4)
		If @error Then Return SetError(1, 0, 0)

		If Not IsObj($g_ITBL_oTaskBar) Then Return SetError(3, 0, 0)

		If $bInitiate Then
			Local $iRet = $g_ITBL_oTaskBar.HrInit()
			If $iRet Then Return SetError($iRet, 0, 0)
		EndIf

		Local $time = TimerInit()
		;The Tab should be created by now.
		While Not $g_ITBL_bTaskBarReady
			Sleep(10)
			If TimerDiff($time) > 5000 Then Return SetError(2, 0, 0)
		WEnd

		Return SetError(0, 0, $g_ITBL_oTaskBar)

	EndFunc   ;==>_ITaskBar_CreateTaskBarObj

	; #FUNCTION# ====================================================================================================
	; Name...........:	_ITaskBar_SetOverlayIcon
	; Description....:	Applies an overlay to a taskbar button to indicate application status or a notification to the user.
	; Syntax.........:	_ITaskBar_SetOverlayIcon($hGui, $hIcon = 0, $sDescription = '')
	; Parameters.....:	$hGui - Handle to Gui
	;					$hIcon - [Optional] - The handle of an icon to use as the overlay.
	;					$sDescription - [Optional] -  alt text version of the information conveyed by the overlay, for accessibility purposes.
	; Return values..:	Success - 1
	;					Failure - 0 and sets @error to HRESULT error code or:
	;							  1 - File Icon does not exist
	;							  2 - Failed loading icon image.
	; Author.........:	Brian J Christy (Beege)
	; Remarks........:	The icon should be a small icon, measuring 16x16 pixels at 96 dpi. If the taskbar is configured
	;					through Taskbar and Start Menu Properties to show small icons, overlays cannot be applied and calls
	;					to this method are ignored
	; ===============================================================================================================
	Func _ITaskBar_SetOverlayIcon($hGui, $hIcon = 0, $sDescription = '')
		If IsObj($g_ITBL_oTaskBar) = 0 Then Return SetError(1, 1, 0)
		If $hIcon And Not IsPtr($hIcon) Then
			If Not FileExists($hIcon) Then Return SetError(1, 0, 0)
			If StringRight($hIcon, 3) = 'exe' Then
				$hIcon = __GetEXEIconHandle($hIcon)
				If @error Then Return SetError(2, 0, 0)
			Else
				$hIcon = _WinAPI_LoadImage(0, $hIcon, $IMAGE_ICON, 16, 16, $LR_LOADFROMFILE)
				If @error Then Return SetError(2, 0, 0)
			EndIf
		EndIf

		Local $iRet = $g_ITBL_oTaskBar.SetOverlayIcon($hGui, $hIcon, $sDescription)

		If IsPtr($hIcon) Then _WinAPI_DestroyIcon($hIcon)

		If $iRet Then Return SetError($iRet, 0, 0)
		Return 1

	EndFunc   ;==>_ITaskBar_SetOverlayIcon

	; #FUNCTION# ====================================================================================================
	; Name...........:	_ITaskBar_SetThumbNailClip
	; Description....:	Selects a portion of a window's client area to display as that window's thumbnail in the taskbar.
	; Syntax.........:	_ITaskBar_SetThumbNailClip($hGui, $iLeft = -1, $iTop = -1, $iRight = -1, $iBottom = -1)
	; Parameters.....:	$hGui - Handle to Gui
	;					$iLeft - [Optional] - x-coordinate of the upper-left corner
	;					$iTop - [Optional] - y-coordinate of the upper-left corner
	;					$iRight - [Optional] - x-coordinate of the lower-right corner
	;					$iBottom - [Optional] - y-coordinate of the lower-right corner
	; Return values..:	Success - 1
	;					Failure - 0 and sets @error to HRESULT error code
	; Author.........:	Brian J Christy (Beege)
	; Remarks........:	None
	; ===============================================================================================================
	Func _ITaskBar_SetThumbNailClip($hGui, $iLeft = -1, $iTop = -1, $iRight = -1, $iBottom = -1)
		If IsObj($g_ITBL_oTaskBar) = 0 Then Return SetError(1, 1, 0)

		If $iLeft = -1 Then Return $g_ITBL_oTaskBar.SetThumbNailClip($hGui, 0)

		Local $vRect = DllStructCreate("int Left;int Top;int Right;int Bottom")
		DllStructSetData($vRect, 1, $iLeft)
		DllStructSetData($vRect, 2, $iTop)
		DllStructSetData($vRect, 3, $iRight)
		DllStructSetData($vRect, 4, $iBottom)

		Local $iRet = $g_ITBL_oTaskBar.SetThumbNailClip($hGui, DllStructGetPtr($vRect))
		If $iRet Then Return SetError($iRet, 0, 0)
		Return 1

	EndFunc   ;==>_ITaskBar_SetThumbNailClip

	; #FUNCTION# ====================================================================================================
	; Name...........:	_ITaskBar_AddTBButtons
	; Description....:	Applies buttons that have been previously created using _ITaskBar_CreateTBButton()
	; Syntax.........:	_ITaskBar_AddTBButtons($hGui)
	; Parameters.....:	$hGui - Handle to GUI
	; Return values..:	Success - 1
	;					Failure - 0 and sets @error to HRESULT error code or:
	;					1 - No buttons have been created.
	; Author.........:	Brian J Christy (Beege)
	; Remarks........:	If the gui is hidden, the thumbbar gets destroyed and this function will need to be called again.
	;					Besides that, this function should only be called once. Buttons can be hidden/restored by using
	;					_ITaskBar_UpdateTBButton(), but not added multiple times. A Maximum of 7 buttons is allowed.
	; ===============================================================================================================
	Func _ITaskBar_AddTBButtons($hGui)
		If IsObj($g_ITBL_oTaskBar) = 0 Then Return SetError(1, 1, 0)

		If $g_ITBL_aButtons[0][0] = 0 Then Return SetError(1, 0, 0) ;No buttons have been created

		$g_ITBL_aButtons[0][$g_ITBL_hGui] = $hGui

		Local $i, $tagTHUMBBUTTON = "dword;dword;dword;handle;WCHAR[260];dword_ptr"
		For $i = 1 To $g_ITBL_aButtons[0][0]
			$tagTHUMBBUTTON &= ';' & $tagTHUMBBUTTON
		Next

		$g_ITBL_aButtons[0][$g_ITBL_DllStruct] = DllStructCreate($tagTHUMBBUTTON)
		__SetThumbBarStructData()

		Local $iRet = $g_ITBL_oTaskBar.ThumbBarAddButtons($hGui, $g_ITBL_aButtons[0][0], DllStructGetPtr($g_ITBL_aButtons[0][$g_ITBL_DllStruct]))

		If $iRet Then Return SetError($iRet, 0, 0)
		Return 1

	EndFunc   ;==>_ITaskBar_AddTBButtons

	; #FUNCTION# ====================================================================================================
	; Name...........:	_ITaskBar_CreateTBButton
	; Description....:	Creates a ThumbBar button
	; Syntax.........:	_ITaskBar_CreateTBButton($sToolTip = '', $hIcon = -1, $iBitmap = -1, $sFunctiontoCall = -1, $iFlags = -1, $iMask = -1)
	; Parameters.....:	$sToolTip - [Optional] - Text of the button's tooltip displayed when the mouse pointer hovers over the button
	;					$sIcon - [Optional] - Can be either a icon handle, fullpath of an icon file, or fullpath of .exe used as the button image
	;					$iBitmap - [Optional] - The zero-based index of the button image within the image list set through _ITaskBar_SetTBImageList()
	;					$sFunctiontoCall - [Optional] - Function to call when button is pressed
	;					$iFlags - [Optional] - A combination of THUMBBUTTONFLAGS values that control specific states and behaviors of the button. Default = $THBF_ENABLED
	;					$iMask - [Optional] -  A combination of THUMBBUTTONMASK values that specify which members of this structure contain valid data.
	; Return values..:	Success - Button CtrlID
	;					Failure - 0 and sets @error:
	;							  1 - File Icon does not exist
	;							  2 - Failed loading icon image.
	;							  3 - Maximum Button Count Reached
	; Author.........:	Brian J Christy (Beege)
	; Remarks........:	Maximum of 7 buttons is allowed. If both an icon and an image list Bitmap are specified for a button's image, the icon is used if possible. If
	;					for some reason the attempt to retrieve the icon fails, the image from the image list is used.
	; ===============================================================================================================
	Func _ITaskBar_CreateTBButton($sToolTip = '', $hIcon = -1, $iBitmap = -1, $sFunctiontoCall = -1, $iFlags = -1, $iMask = -1)

		Local $iD = GUICtrlCreateDummy()

		If $g_ITBL_aButtons[0][0] = 7 Then Return SetError(3, 0, 0)

		If $hIcon <> -1 And Not IsPtr($hIcon) Then
			If Not FileExists($hIcon) Then Return SetError(1, 0, 0)
			If StringRight($hIcon, 3) = 'exe' Then
				$hIcon = __GetEXEIconHandle($hIcon)
				If @error Then Return SetError(2, 0, 0)
			Else
				$hIcon = _WinAPI_LoadImage(0, $hIcon, $IMAGE_ICON, 16, 16, $LR_LOADFROMFILE)
				If @error Then Return SetError(2, 0, 0)
			EndIf
		EndIf

		ReDim $g_ITBL_aButtons[UBound($g_ITBL_aButtons) + 1][$g_ITBL_Max]
		$g_ITBL_aButtons[0][0] += 1

		$g_ITBL_oButtonIDs.Add($iD, $g_ITBL_aButtons[0][0])

		If $hIcon = -1 Then $hIcon = 0
		If $iFlags = -1 Then $iFlags = $THBF_ENABLED

		$g_ITBL_aButtons[$g_ITBL_aButtons[0][0]][$g_ITBL_iID] = $iD
		$g_ITBL_aButtons[$g_ITBL_aButtons[0][0]][$g_ITBL_hIcon] = $hIcon
		$g_ITBL_aButtons[$g_ITBL_aButtons[0][0]][$g_ITBL_sToolTip] = $sToolTip
		$g_ITBL_aButtons[$g_ITBL_aButtons[0][0]][$g_ITBL_sCallFunc] = $sFunctiontoCall
		$g_ITBL_aButtons[$g_ITBL_aButtons[0][0]][$g_ITBL_iFlags] = $iFlags
		$g_ITBL_aButtons[$g_ITBL_aButtons[0][0]][$g_ITBL_iBitmap] = $iBitmap

		If $iMask <> -1 Then
			$g_ITBL_aButtons[$g_ITBL_aButtons[0][0]][$g_ITBL_iMask] = $iMask
		Else
			__UpdateTBMask($g_ITBL_aButtons[0][0])
		EndIf

		Return $iD

	EndFunc   ;==>_ITaskBar_CreateTBButton

	; #FUNCTION# ====================================================================================================
	; Name...........:	_ITaskBar_UpdateTBButton
	; Description....:	Shows, enables, disables, or hides buttons in a thumbnail toolbar as required by the window's current state.
	; Syntax.........:	_ITaskBar_UpdateTBButton($iButton, $iFlags = -1, $sToolTip = -1, $sIcon = -1, $iBitmap = -1, $sFunctiontoCall = -1, $iMask = -1)
	; Parameters.....:	$iButton - CtrlID of button returned from _ITaskBar_CreateTBButton().
	;					$iFlags - [Optional] - A combination of THUMBBUTTONFLAGS values that control specific states and behaviors of the button.
	;					$sToolTip - [Optional] - Text of the button's tooltip displayed when the mouse pointer hovers over the button
	;					$sIcon - [Optional] - The handle or path of an icon to use as the button image
	;					$iBitmap - [Optional] - The zero-based index of the button image within the image list set through _ITaskBar_SetTBImageList
	;					$sFunctiontoCall - [Optional] - Function to call when button is pressed
	;					$iMask - [Optional] - A combination of THUMBBUTTONMASK values that specify which members of this structure contain valid data.
	; Return values..:	Success - 1
	;					Failure - 0 and sets @error to HRESULT error code or:
	;							  2 - Invalid Button CtrlID
	; Author.........:	Brian J Christy (Beege)
	; Remarks........:	Any Parameter that is -1 will not be changed.
	; ===============================================================================================================
	Func _ITaskBar_UpdateTBButton($iButton, $iFlags = -1, $sToolTip = -1, $sIcon = -1, $iBitmap = -1, $sFunctiontoCall = -1, $iMask = -1)
		If IsObj($g_ITBL_oTaskBar) = 0 Then Return SetError(1, 1, 0)

		If Not $g_ITBL_oButtonIDs.Exists($iButton) Then Return SetError(1, 0, 0)
		Local $iIndex = $g_ITBL_oButtonIDs.Item($iButton)
		;ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $iIndex = ' & $iIndex & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console


		If $sIcon <> -1 Then $g_ITBL_aButtons[$iIndex][$g_ITBL_hIcon] = $sIcon
		If $sFunctiontoCall <> -1 Then $g_ITBL_aButtons[$iIndex][$g_ITBL_sCallFunc] = $sFunctiontoCall
		If $iFlags <> -1 Then $g_ITBL_aButtons[$iIndex][$g_ITBL_iFlags] = $iFlags
		If $iBitmap <> -1 Then $g_ITBL_aButtons[$iIndex][$g_ITBL_iBitmap] = $iBitmap
		If $sToolTip <> -1 Then $g_ITBL_aButtons[$iIndex][$g_ITBL_sToolTip] = $sToolTip

		If $iMask <> -1 Then
			$g_ITBL_aButtons[$iIndex][$g_ITBL_iMask] = $iMask
		Else
			__UpdateTBMask($iIndex)
		EndIf

		__SetThumbBarStructData()

		Local $iRet = $g_ITBL_oTaskBar.ThumbBarUpdateButtons($g_ITBL_aButtons[0][$g_ITBL_hGui], $g_ITBL_aButtons[0][0], DllStructGetPtr($g_ITBL_aButtons[0][$g_ITBL_DllStruct]))
		If $iRet Then Return SetError($iRet, 0, 0)
		Return 1

	EndFunc   ;==>_ITaskBar_UpdateTBButton

	; #FUNCTION# ====================================================================================================
	; Name...........:	_ITaskBar_SetTBImageList
	; Description....:	Specifies an image list that contains button images for a toolbar embedded in a thumbnail image of a
	;					window in a taskbar button flyout.
	; Syntax.........:	_ITaskBar_SetTBImageList($hGui, $hImageList)
	; Parameters.....:	$hGui - Handle to GUI
	;					$hImageList - The handle of the image list that contains all button images to be used in the toolbar.
	; Return values..:	Success - 1
	;					Failure - 0 and sets @error to HRESULT error code
	; Author.........:	Brian J Christy (Beege)
	; Remarks........:	None
	; ===============================================================================================================
	Func _ITaskBar_SetTBImageList($hGui, $hImageList)
		If IsObj($g_ITBL_oTaskBar) = 0 Then Return SetError(1, 1, 0)
		Local $iRet = $g_ITBL_oTaskBar.ThumbBarSetImageList($hGui, $hImageList)
		If $iRet Then Return SetError($iRet, 0, 0)
		Return 1
	EndFunc   ;==>_ITaskBar_SetTBImageList

	; #FUNCTION# ====================================================================================================
	; Name...........:	_ITaskBar_ActivateTab
	; Description....:	Activates an item on the taskbar. The window is not actually activated; the window's item on
	;					the taskbar is merely displayed as active.
	; Syntax.........:	_ITaskBar_ActivateTab($hGui)
	; Parameters.....:	$hGui - A handle to the window on the taskbar to be displayed as active.
	; Return values..:	Success - 1
	;					Failure - 0 and sets @error to HRESULT error code
	; Author.........:	Brian J Christy (Beege)
	; Remarks........:	None
	; ===============================================================================================================
	Func _ITaskBar_ActivateTab($hGui)
		If IsObj($g_ITBL_oTaskBar) = 0 Then Return SetError(1, 1, 0)
		Local $iRet = $g_ITBL_oTaskBar.ActivateTab($hGui)
		If $iRet Then Return SetError($iRet, 0, 0)
		Return 1
	EndFunc   ;==>_ITaskBar_ActivateTab

	; #FUNCTION# ====================================================================================================
	; Name...........:	_ITaskBar_AddTab
	; Description....:	Adds an item to the taskbar.
	; Syntax.........:	_ITaskBar_AddTab($hGui)
	; Parameters.....:	$hGui - Handle to Gui
	; Return values..:	Success - 1
	;					Failure - 0 and sets @error to HRESULT error code
	; Author.........:	Brian J Christy (Beege)
	; Remarks........:	Any type of window can be added to the taskbar, but it is recommended that the window at least
	;					have the WS_CAPTION style.Any window added with this method must be removed with the DeleteTab method
	;					when the added window is destroyed.
	; ===============================================================================================================
	Func _ITaskBar_AddTab($hGui)
		If IsObj($g_ITBL_oTaskBar) = 0 Then Return SetError(1, 1, 0)
		Local $iRet = $g_ITBL_oTaskBar.AddTab($hGui)
		If $iRet Then Return SetError($iRet, 0, 0)
		Return 1
	EndFunc   ;==>_ITaskBar_AddTab

	; #FUNCTION# ====================================================================================================
	; Name...........:	_ITaskBar_DeleteTab
	; Description....:	Deletes an item from the taskbar.
	; Syntax.........:	_ITaskBar_DeleteTab($hGui)
	; Parameters.....:	$hGui - Handle to Gui to be deleted from taskbar
	; Return values..:	Success - 1
	;					Failure - 0 and sets @error to HRESULT error code
	; Author.........:	Brian J Christy (Beege)
	; Remarks........:	None
	; ===============================================================================================================
	Func _ITaskBar_DeleteTab($hGui)
		If IsObj($g_ITBL_oTaskBar) = 0 Then Return SetError(1, 1, 0)
		Local $iRet = $g_ITBL_oTaskBar.DeleteTab($hGui)
		If $iRet Then Return SetError($iRet, 0, 0)
		Return 1
	EndFunc   ;==>_ITaskBar_DeleteTab

	; #FUNCTION# ====================================================================================================
	; Name...........:	_ITaskBar_SetActiveAlt
	; Description....:	Marks a taskbar item as active but does not visually activate it.
	; Syntax.........:	_ITaskBar_SetActiveAlt($hGui = 0)
	; Parameters.....:	$hGui - [Optional] - Handle to Gui. If set to 0, the state will be cleared
	; Return values..:	Success - 1
	;					Failure - 0 and sets @error to HRESULT error code
	; Author.........:	Brian J Christy (Beege)
	; Remarks........:	See http://msdn.microsoft.com/en-us/library/bb774655(VS.85).aspx
	; ===============================================================================================================
	Func _ITaskBar_SetActiveAlt($hGui = 0)
		If IsObj($g_ITBL_oTaskBar) = 0 Then Return SetError(1, 1, 0)
		Local $iRet = $g_ITBL_oTaskBar.SetActiveAlt($hGui)
		If $iRet Then Return SetError($iRet, 0, 0)
		Return 1
	EndFunc   ;==>_ITaskBar_SetActiveAlt

	; #FUNCTION# ====================================================================================================
	; Name...........:	_ITaskBar_MarkFullscreenWindow
	; Description....:	Marks a window as full-screen.
	; Syntax.........:	_ITaskBar_MarkFullscreenWindow($hGui, $bFull = 1)
	; Parameters.....:	$hGui - Handle of Gui
	;					$bFull - [Optional] - A Boolean value marking the desired full-screen status of the window.
	; Return values..:	Success - 1
	;					Failure - 0 and sets @error to HRESULT error code
	; Author.........:	Brian J Christy (Beege)
	; Remarks........:	see http://msdn.microsoft.com/en-us/library/bb774640(VS.85).aspx
	; ===============================================================================================================
	Func _ITaskBar_MarkFullscreenWindow($hGui, $bFull = 1)
		If IsObj($g_ITBL_oTaskBar) = 0 Then Return SetError(1, 1, 0)
		Local $iRet = $g_ITBL_oTaskBar.MarkFullscreenWindow($hGui, $bFull)
		If $iRet Then Return SetError($iRet, 0, 0)
		Return 1
	EndFunc   ;==>_ITaskBar_MarkFullscreenWindow

	; #FUNCTION# ====================================================================================================
	; Name...........:	_ITaskBar_RegisterTab
	; Description....:	Informs the taskbar that a new tab or document thumbnail has been provided for display in an
	;					application's taskbar group flyout.
	; Syntax.........:	_ITaskBar_RegisterTab($hWndTab, $hGui)
	; Parameters.....:	$hWndTab - Handle of the tab or document window.
	;					$hMainGui - Handle of the application's main window.
	; Return values..:	Success - 1
	;					Failure - 0 and sets @error to HRESULT error code
	; Author.........:	Brian J Christy (Beege)
	; Remarks........:	By itself, registering a tab thumbnail alone will not result in its being displayed. You must
	;					also call ITaskbarList3::SetTabOrder to instruct the group where to display it.
	; ===============================================================================================================
	Func _ITaskBar_RegisterTab($hWndTab, $hMainGui)
		If IsObj($g_ITBL_oTaskBar) = 0 Then Return SetError(1, 1, 0)
		Local $iRet = $g_ITBL_oTaskBar.RegisterTab($hWndTab, $hMainGui)
		If $iRet Then Return SetError($iRet, 0, 0)
		Return 1
	EndFunc   ;==>_ITaskBar_RegisterTab

	; #FUNCTION# ====================================================================================================
	; Name...........:	_ITaskBar_UnregisterTab
	; Description....:	Removes a thumbnail from an application's preview group when that tab or document is closed in the application.
	; Syntax.........:	_ITaskBar_UnregisterTab($hWndTab)
	; Parameters.....:	$hWndTab - The handle of the tab window whose thumbnail is being removed.
	; Return values..:	Success - 1
	;					Failure - 0 and sets @error to HRESULT error code
	; Author.........:	Brian J Christy (Beege)
	; Remarks........:	None
	; ===============================================================================================================
	Func _ITaskBar_UnregisterTab($hWndTab)
		If IsObj($g_ITBL_oTaskBar) = 0 Then Return SetError(1, 1, 0)
		Local $iRet = $g_ITBL_oTaskBar.UnregisterTab($hWndTab)
		If $iRet Then Return SetError($iRet, 0, 0)
		Return 1
	EndFunc   ;==>_ITaskBar_UnregisterTab

	; #FUNCTION# ====================================================================================================
	; Name...........:	_ITaskBar_SetTabProperties
	; Description....:	Allows a tab to specify whether the main application frame window or the tab window should be
	;					used as a thumbnail or in the peek feature under certain circumstances.
	; Syntax.........:	_ITaskBar_SetTabProperties($hWndTab, $iFlags)
	; Parameters.....:	$hWndTab - The handle of the tab window that is to have properties set. This handle must already
	;					be registered through _ITaskBar_RegisterTab()
	;					$iFlags - Combination of flags that specify the displayed thumbnail and peek image source of the tab thumbnail.
	;					0 - NONE - No specific property values are specified. The default behavior is used
	;					1 - USEAPPTHUMBNAILALWAYS - Always use the thumbnail provided by the main application frame window rather than a
	;						thumbnail provided by the individual tab window. Cannot be used with flag 2.
	;					2 - USEAPPTHUMBNAILWHENACTIVE - When the application tab is active and a live representation of
	;						its window is available, use the main application's frame window thumbnail. At other times,
	;						use the tab window thumbnail. Cannot be used with flag 1.
	;					4 - USEAPPPEEKALWAYS - Always use the peek image provided by the main application frame window rather
	;						than a peek image provided by the individual tab window. Cannot be used with flag 8.
	;					8 - USEAPPPEEKWHENACTIVE - When the application tab is active and a live representation of its window is available, show the
	;						main application frame in the peek feature. At other times, use the tab window. Cannot be used with flag 4.
	; Return values..:	Success - 1
	;					Failure - 0 and sets @error to HRESULT error code
	; Author.........:	Brian J Christy (Beege)
	; Remarks........:	An application might want to use the thumbnail or peek representation of its associated parent window if the
	;					application cannot generate its own thumbnail for a tab or for its active tab content (such as an animation) to appear live.
	; ===============================================================================================================
	Func _ITaskBar_SetTabProperties($hWndTab, $iFlags)
		If IsObj($g_ITBL_oTaskBar) = 0 Then Return SetError(1, 1, 0)
		Local $iRet = $g_ITBL_oTaskBar.SetTabProperties($hWndTab)
		If $iRet Then Return SetError($iRet, 0, 0)
		Return 1
	EndFunc   ;==>_ITaskBar_SetTabProperties

	; #FUNCTION# ====================================================================================================
	; Name...........:	_ITaskBar_SetProgressState
	; Description....:	Sets the type and state of the progress indicator displayed on a taskbar button.
	; Syntax.........:	_ITaskBar_SetProgressState($hGui, $iState)
	; Parameters.....:	$hGui - Handle to Gui
	;					$iState - Flags that control the current state of the progress button. Specify only one of the
	;					following flags; all states are mutually exclusive of all others.
	;					0 - No Progress - Stops displaying progress and returns the button to its normal state
	;					1 - Indeterminate - The progress indicator does not grow in size, but cycles repeatedly along the length of the taskbar button.
	;					2 - Normal - The progress indicator grows in size from left to right in proportion to the estimated amount of the operation completed.
	;					4 - Error - The progress indicator turns red to show that an error has occurred in one of the windows that is broadcasting progress.
	;					8 - Paused - The progress indicator turns yellow to show that progress is currently stopped in one of the windows but can be resumed by the user.
	; Return values..:	Success - 1
	;					Failure - 0 and sets @error to HRESULT error code
	; Author.........:	Brian J Christy (Beege)
	; Remarks........:	See http://msdn.microsoft.com/en-us/library/dd391697(VS.85).aspx
	; ===============================================================================================================
	Func _ITaskBar_SetProgressState($hGui, $iState = 0)
		If IsObj($g_ITBL_oTaskBar) = 0 Then Return SetError(1, 1, 0)
		Local $iRet = $g_ITBL_oTaskBar.SetProgressState($hGui, $iState)
		If $iRet Then Return SetError($iRet, 0, 0)
		Return 1
	EndFunc   ;==>_ITaskBar_SetProgressState

	; #FUNCTION# ====================================================================================================
	; Name...........:	_ITaskBar_SetProgressValue
	; Description....:	Displays or updates a progress bar hosted in a taskbar button to show the specific percentage
	;					completed of the full operation.
	; Syntax.........:	_ITaskBar_SetProgressValue($hGui, $iValue, $iMaxValue = 100)
	; Parameters.....:	$hGui - Handle of Gui
	;					$iValue - An application-defined value that indicates the proportion of the operation that has been completed.
	;					$iMaxValue - [Optional] - Max value used to specify progress
	; Return values..:	Success - 1
	;					Failure - 0 and sets @error to HRESULT error code
	; Author.........:	Brian J Christy (Beege)
	; Remarks........:	None
	; ===============================================================================================================
	Func _ITaskBar_SetProgressValue($hGui, $iValue, $iMaxValue = 100)
		If IsObj($g_ITBL_oTaskBar) = 0 Then Return SetError(1, 1, 0)
		Local $iRet = $g_ITBL_oTaskBar.SetProgressValue($hGui, $iValue, $iMaxValue)
		If $iRet Then Return SetError($iRet, 0, 0)
		Return 1
	EndFunc   ;==>_ITaskBar_SetProgressValue

	; #FUNCTION# ====================================================================================================
	; Name...........:	_ITaskBar_SetTabActive
	; Description....:	Informs the taskbar that a tab or document window has been made the active window.
	; Syntax.........:	_ITaskBar_SetTabActive($hWndTab, $MainGui)
	; Parameters.....:	$hWndTab - Handle of the active tab window.
	;					$MainGui - Handle of the application's main window.
	; Return values..:	Success - 1
	;					Failure - 0 and sets @error to HRESULT error code
	; Author.........:	Brian J Christy (Beege)
	; Remarks........:	None
	; ===============================================================================================================
	Func _ITaskBar_SetTabActive($hWndTab, $hMainGui)
		If IsObj($g_ITBL_oTaskBar) = 0 Then Return SetError(1, 1, 0)
		Local $iRet = $g_ITBL_oTaskBar.SetTabActive($hWndTab, $hMainGui, 0)
		If $iRet Then Return SetError($iRet, 0, 0)
		Return 1
	EndFunc   ;==>_ITaskBar_SetTabActive

	; #FUNCTION# ====================================================================================================
	; Name...........:	_ITaskBar_SetTabOrder
	; Description....:	Inserts a new thumbnail into a tabbed-document interface (TDI) or multiple-document interface (MDI)
	;					application's group flyout or moves an existing thumbnail to a new position in the application's group.
	; Syntax.........:	_ITaskBar_SetTabOrder($hWndTab, $hWndInsertBefore = 0)
	; Parameters.....:	$hWndTab - The handle of the tab window whose thumbnail is being placed
	;					$hWndInsertBefore - [Optional] - The handle of the tab window whose thumbnail that hwndTab is
	;					inserted to the left of. If not specifed, the new thumbnail is added to the end of the list
	; Return values..:	Success - 1
	;					Failure - 0 and sets @error to HRESULT error code
	; Author.........:	Brian J Christy (Beege)
	; Remarks........:	Both handles must be register with _ITaskBar_RegisterTab() before calling this function.
	;					This method must be called for the thumbnail to be shown in the group
	; ===============================================================================================================
	Func _ITaskBar_SetTabOrder($hWndTab, $hWndInsertBefore = 0)
		If IsObj($g_ITBL_oTaskBar) = 0 Then Return SetError(1, 1, 0)
		Local $iRet = $g_ITBL_oTaskBar.SetTabOrder($hWndTab, $hWndInsertBefore)
		If $iRet Then Return SetError($iRet, 0, 0)
		Return 1
	EndFunc   ;==>_ITaskBar_SetTabOrder

	; #FUNCTION# ====================================================================================================
	; Name...........:	_ITaskBar_SetThumbNailToolTip
	; Description....:	Specifies or updates the text of the tooltip that is displayed when the mouse pointer rests
	;					on an individual preview thumbnail in a taskbar button flyout.
	; Syntax.........:	_ITaskBar_SetThumbNailToolTip($hGui, $sTip = 0)
	; Parameters.....:	$hGui - Handle to GUI
	;					$sTip - [Optional] - text to be displayed in the tooltip. If $sTip = 0 then the title of the
	;										 window specified by hwnd is used as the tooltip.
	; Return values..:	Success - 1
	;					Failure - 0 and sets @error to HRESULT error code
	; Author.........:	Brian J Christy (Beege)
	; Remarks........:	None
	; ===============================================================================================================
	Func _ITaskBar_SetThumbNailToolTip($hGui, $sTip = 0)
		If IsObj($g_ITBL_oTaskBar) = 0 Then Return SetError(1, 1, 0)
		Local $iRet = $g_ITBL_oTaskBar.SetThumbNailToolTip($hGui, $sTip)
		If $iRet Then Return SetError($iRet, 0, 0)
		Return 1
	EndFunc   ;==>_ITaskBar_SetThumbNailToolTip

	; #FUNCTION# ====================================================================================================
	; Name...........:	_ITaskBar_DestroyObject
	; Description....:	Destroys ITaskBarObject and icons freeing any memory the icons occupied
	; Syntax.........:	_ITaskBar_DestroyObject($hGui)
	; Parameters.....:	$hGui - Handle to Gui
	; Return values..:	Success - 1
	;					Failure - 0 and sets @error:
	;					1 - failed to destroy one of the icons
	; Author.........:	Brian J Christy (Beege)
	; Remarks........:	OverlayIcons and any previously set ThumbNailClip are also removed
	; ===============================================================================================================
	Func _ITaskBar_DestroyObject($hGui)

		Local $iError = 0

		GUISetState(@SW_HIDE, $hGui)
		GUISetState(@SW_SHOW, $hGui)

		For $i = 1 To $g_ITBL_aButtons[0][0]
			If IsPtr($g_ITBL_aButtons[$i][$g_ITBL_hIcon]) Then _WinAPI_DestroyIcon($g_ITBL_aButtons[$i][$g_ITBL_hIcon])
			If @error Then $iError = 1
		Next

		Dim $g_ITBL_aButtons[1][$g_ITBL_Max] = [[0, 0]]

		$g_ITBL_oTaskBar = 0

		If $iError Then Return SetError(1, 0, 0)
		Return 1

	EndFunc   ;==>_ITaskBar_DestroyObject

#EndRegion Public Functions

#Region Internel Functions

	Func __GetEXEIconHandle($sPath)
		Local $Icon = DllStructCreate("handle")
		Local $iIcon = _WinAPI_ExtractIconEx($sPath, 0, 0, DllStructGetPtr($Icon), 1)
		If @error Then Return SetError(1, 0, 0)
		Return DllStructGetData($Icon, 1)
	EndFunc   ;==>__GetEXEIconHandle

	Func __SetThumbBarStructData()

		Local $j = 1

		For $i = 1 To $g_ITBL_aButtons[0][0]
			DllStructSetData($g_ITBL_aButtons[0][$g_ITBL_DllStruct], $j, $g_ITBL_aButtons[$i][$g_ITBL_iMask])
			DllStructSetData($g_ITBL_aButtons[0][$g_ITBL_DllStruct], $j + 1, $g_ITBL_aButtons[$i][$g_ITBL_iID])
			DllStructSetData($g_ITBL_aButtons[0][$g_ITBL_DllStruct], $j + 2, $g_ITBL_aButtons[$i][$g_ITBL_iBitmap])
			DllStructSetData($g_ITBL_aButtons[0][$g_ITBL_DllStruct], $j + 3, $g_ITBL_aButtons[$i][$g_ITBL_hIcon])
			DllStructSetData($g_ITBL_aButtons[0][$g_ITBL_DllStruct], $j + 4, $g_ITBL_aButtons[$i][$g_ITBL_sToolTip])
			DllStructSetData($g_ITBL_aButtons[0][$g_ITBL_DllStruct], $j + 5, $g_ITBL_aButtons[$i][$g_ITBL_iFlags])
			$j += 6
		Next

	EndFunc   ;==>__SetThumbBarStructData

	Func __UpdateTBMask($iIndex)
		$g_ITBL_aButtons[$iIndex][$g_ITBL_iMask] = $THB_FLAGS
		If $g_ITBL_aButtons[$iIndex][$g_ITBL_hIcon] <> 0 Then $g_ITBL_aButtons[$iIndex][$g_ITBL_iMask] = BitOR($g_ITBL_aButtons[$iIndex][$g_ITBL_iMask], $THB_ICON)
		If $g_ITBL_aButtons[$iIndex][$g_ITBL_iBitmap] <> -1 Then $g_ITBL_aButtons[$iIndex][$g_ITBL_iMask] = BitOR($g_ITBL_aButtons[$iIndex][$g_ITBL_iMask], $THB_BITMAP)
		If $g_ITBL_aButtons[$iIndex][$g_ITBL_sToolTip] <> '' Then $g_ITBL_aButtons[$iIndex][$g_ITBL_iMask] = BitOR($g_ITBL_aButtons[$iIndex][$g_ITBL_iMask], $THB_TOOLTIP)
	EndFunc   ;==>__UpdateTBMask

	Func __TaskbarWM_Command($hWnd, $msg, $wParam, $lParam)

		Local $iMsg = _WinAPI_HiWord($wParam)

		If $iMsg = $THBN_CLICKED Then
			Local $iID = _WinAPI_LoWord($wParam)
			If $g_ITBL_oButtonIDs.Exists($iID) Then
				Local $iIndex = $g_ITBL_oButtonIDs.Item($iID)
				If $g_ITBL_aButtons[$iIndex][$g_ITBL_sCallFunc] <> -1 Then Execute($g_ITBL_aButtons[$iIndex][$g_ITBL_sCallFunc] & "()")
			EndIf
		EndIf

		Return $GUI_RUNDEFMSG

	EndFunc   ;==>__TaskbarWM_Command

	Func __TaskbarButtonCreated()
		$g_ITBL_bTaskBarReady = 1
	EndFunc   ;==>__TaskbarButtonCreated

	Func __TaskbarExit()
		$g_ITBL_oTaskBar = 0
		$g_ITBL_oButtonIDs = 0
	EndFunc   ;==>__TaskbarExit

	Func __TaskbarErrFunc()
		ConsoleWrite("! COM Error !  Number: 0x" & Hex($g_ITBL_oErrorHandler.number, 8) & "   ScriptLine: " & $g_ITBL_oErrorHandler.scriptline & " - " & $g_ITBL_oErrorHandler.windescription & @CRLF)
	EndFunc   ;==>__TaskbarErrFunc

	Func _Get_HRESULT_ERROR_STRING($iError)
		Switch $iError
			Case 0x80004001
				Return 'Not implemented'
			Case 0x80004002
				Return 'Interface not supported'
			Case 0x80004004
				Return 'Aborted'
			Case 0x80004005
				Return 'Unspecifed Failure'
			Case 0x80070057
				Return 'One or more arguments are invalid'
		EndSwitch
		#cs HRESULT error codes
			0x80004001 - E_NOTIMPL - Not implemented
			0x80004002 - E_NOINTERFACE - Interface not supported
			0x80004004 - E_ABORT - Operation aborted
			0x80004005 - E_FAIL - Unspecified failure
			0x80070057 - E_INVALIDARG - One or more arguments are invalid
		#ce
	EndFunc   ;==>_Get_HRESULT_ERROR_STRING

	Func _CreateUDFHeader()
		Local $aUDF, $iNext, $sHeader = '; '
		$aUDF = StringSplit(StringReplace(FileRead(@ScriptFullPath, FileGetSize(@ScriptFullPath)), @CRLF, @CR), @CR)
		For $i = 1 To $aUDF[0]
			If StringInStr($aUDF[$i], '; Name...........:	') And (Not StringInStr($aUDF[$i], '@%@SKIPME@#%@')) Then
				$sHeader &= StringReplace($aUDF[$i], '; Name...........:	', '') & ' - ' ;@%@SKIPME@#%@
				$iNext = 1
				While Not StringInStr($aUDF[$i + $iNext], '; Description....:	')
					$sHeader &= ' ' & StringStripWS(StringTrimLeft($aUDF[$i + $iNext], 2), 1)
					$iNext += 1
				WEnd
				$sHeader &= StringReplace($aUDF[$i + $iNext], '; Description....:	', '')
				$iNext += 1
				While Not StringInStr($aUDF[$i + $iNext], '; Syntax.........:	')
					$sHeader &= ' ' & StringStripWS(StringTrimLeft($aUDF[$i + $iNext], 2), 1)
					$iNext += 1
				WEnd
				$sHeader &= @CRLF & '; '
			EndIf
		Next
		Return StringTrimRight($sHeader, 4)
	EndFunc   ;==>_CreateUDFHeader

#EndRegion Internel Functions

