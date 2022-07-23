; #FUNCTION# ====================================================================================================================
; Name ..........: Synchronization functions
; Description ...: Synchronize access to functions or code
; Syntax ........:
; Parameters ....:
; Return values .:
; Author ........: Cosote (2016-08)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2019
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func CreateMutex($sMutex)

	Local $hMutex = _WinAPI_CreateMutex($sMutex, False)
	;If _WinAPI_GetLastError() <> $ERROR_ALREADY_EXISTS Then
	If $hMutex Then
		Switch _WinAPI_WaitForSingleObject($hMutex, 0)
			; WAIT_ABANDONED = 0x80, WAIT_OBJECT_0 = 0, $WAIT_TIMEOUT = 0x102
			Case 0x80, 0
				Return $hMutex
		EndSwitch
		_WinAPI_CloseHandle($hMutex)
	EndIf
	Return 0

EndFunc   ;==>CreateMutex

Func AcquireMutex($mutexName, $scope = Default, $timeout = Default, $sWaitMessage = "", $bUse_Sleep = False)
	Local $timer = __TimerInit()
	If $sWaitMessage = Default Then $sWaitMessage = "Waiting for mutex " & $mutexName & " to become available..."
	Local $iDelay = $DELAYSLEEP
	If $sWaitMessage Then $iDelay = 1000
	Local $g_hMutex_MyBot = 0
	If $scope = Default Then
		$scope = @AutoItPID & "/"
	ElseIf $scope <> "" Then
		$scope &= "/"
	EndIf
	If $timeout = Default Then $timeout = 30000
	Local $bLogged = False
	While $g_hMutex_MyBot = 0 And ($timeout < 1 Or __TimerDiff($timer) < $timeout)
		$g_hMutex_MyBot = CreateMutex("MyBot.run/" & $scope & $mutexName)
		If $g_hMutex_MyBot <> 0 Then ExitLoop
		If $timeout = 0 Then ExitLoop
		If $sWaitMessage Then
			If $bLogged = False Then
				$bLogged = True
				SetLog($sWaitMessage)
			EndIf
			_GUICtrlStatusBar_SetTextEx($g_hStatusBar, $sWaitMessage)
		EndIf
		If $bUse_Sleep Then
			_Sleep($iDelay)
		Else
			Sleep($iDelay)
		EndIf
	WEnd
	If $g_hMutex_MyBot Then
		; protect the handle from getting closed by something else!
		;_WinAPI_SetHandleInformation($g_hMutex_MyBot, $HANDLE_FLAG_PROTECT_FROM_CLOSE, $HANDLE_FLAG_PROTECT_FROM_CLOSE)
	EndIf
	Return $g_hMutex_MyBot
EndFunc   ;==>AcquireMutex

Func ReleaseMutex($hMutex, $ReturnValue = Default)
	If $hMutex Then
		;_WinAPI_SetHandleInformation($hMutex, $HANDLE_FLAG_PROTECT_FROM_CLOSE, 0)
		_WinAPI_ReleaseMutex($hMutex)
		_WinAPI_CloseHandle($hMutex)
	EndIf
	If $ReturnValue = Default Then Return
	Return $ReturnValue
EndFunc   ;==>ReleaseMutex

Func WaitForSemaphore($sSemaphore, $iInitial = 4096, $iMaximum = 4096, $sWaitMessage = Default, $tSecurity = 0)
	Local $hSemaphore = _WinAPI_CreateSemaphore($sSemaphore, $iInitial, $iMaximum, $tSecurity)
	If LockSemaphore($hSemaphore, $sWaitMessage) Then Return $hSemaphore
	; close semaphore when created and bot stopped
	_WinAPI_CloseHandle($hSemaphore)
	Return 0
EndFunc   ;==>WaitForSemaphore

Func LockSemaphore($Semaphore, $sWaitMessage = Default)
	Local $bAquired = False
	If $sWaitMessage = Default Then $sWaitMessage = "Waiting for slot to become available..."
	Local $iDelay = $DELAYSLEEP
	If $sWaitMessage Then $iDelay = 1000
	Local $hSemaphore = $Semaphore
	If IsString($Semaphore) = 1 Then $hSemaphore = _WinAPI_CreateSemaphore($Semaphore, 1, 1)
	Local $bLogged = False
	While $bAquired = False And $g_bRunState = True
		$bAquired = _WinAPI_WaitForSingleObject($hSemaphore, $DELAYSLEEP) <> $WAIT_TIMEOUT
		If $bAquired = True Then
			Return $hSemaphore
		EndIf
		If $sWaitMessage Then
			If $bLogged = False Then
				$bLogged = True
				SetLog($sWaitMessage)
			EndIf
			_GUICtrlStatusBar_SetTextEx($g_hStatusBar, $sWaitMessage)
		EndIf
		_Sleep($iDelay, True, False)
		;Sleep($iDelay)
	WEnd
	; close semaphore when created and bot stopped
	If $Semaphore <> $hSemaphore Then _WinAPI_CloseHandle($hSemaphore)
	Return 0
EndFunc   ;==>LockSemaphore

Func UnlockSemaphore(ByRef $hSemaphore, $bCloseHandle = False)
	If $hSemaphore <> 0 And $hSemaphore <> -1 Then
		Local $iPreviousCount = _WinAPI_ReleaseSemaphore($hSemaphore)
		If $bCloseHandle = True Then
			_WinAPI_CloseHandle($hSemaphore)
			$hSemaphore = 0
		EndIf
		Return $iPreviousCount
	EndIf
	Return -1
EndFunc   ;==>UnlockSemaphore

Func AcquireMutexTicket($sMutexName, $iMinTicketNo, $sWaitMessage = Default, $bCheckRunState = True)
	; get ticket
	Local $hTicketMutex = 0
	Local $sTicketMutex = 0
	Local $iTicket = 256
	For $i = 1 To 255
		If $bCheckRunState = True And $g_bRunState = False Then Return 0
		$sTicketMutex = $sMutexName & "." & $i
		$hTicketMutex = AcquireMutex($sTicketMutex, "Global", 0)
		If $hTicketMutex Then
			$iTicket = $i
			ExitLoop
		EndIf
	Next

	If $hTicketMutex = 0 Then
		SetLog("Could not aquire mutex ticker for: " & $sMutexName, $COLOR_RED)
		Return 0
	EndIf

	If $iTicket <= $iMinTicketNo Then
		SetDebugLog("Aquired mutex ticket: " & $sTicketMutex & ", " & $hTicketMutex)
		Return $hTicketMutex
	EndIf

	SetDebugLog("Wait mutex ticket: " & $sTicketMutex)

	; wait for ticket to get to counter
	If $sWaitMessage = Default Then $sWaitMessage = "Waiting for slot to become available..."
	Local $iDelay = $DELAYSLEEP
	If $sWaitMessage Then $iDelay = 1000

	Local $bLogged = False
	While $bCheckRunState = False Or $g_bRunState = True
		If $iTicket = $iMinTicketNo + 1 Then
			; next in line
			For $i = 1 To $iMinTicketNo
				$sTicketMutex = $sMutexName & "." & $i
				Local $hFinalTicketMutex = AcquireMutex($sTicketMutex, "Global", 0)
				If $hFinalTicketMutex Then
					; found slot
					SetDebugLog("Aquired mutex ticket: " & $sTicketMutex & ", " & $hFinalTicketMutex)
					Return ReleaseMutex($hTicketMutex, $hFinalTicketMutex)
				EndIf
			Next
		Else
			; wait to become next in line
			$sTicketMutex = $sMutexName & "." & ($iTicket - 1)
			Local $hNextTicketMutex = AcquireMutex($sTicketMutex, "Global", 0)
			If $hNextTicketMutex Then
				; move one slot closer
				SetDebugLog("New mutex ticket: " & $sTicketMutex)
				$iTicket -= 1
				$hTicketMutex = ReleaseMutex($hTicketMutex, $hNextTicketMutex)
			EndIf
		EndIf

		If $sWaitMessage Then
			If $bLogged = False Then
				$bLogged = True
				SetLog($sWaitMessage)
			EndIf
			_GUICtrlStatusBar_SetTextEx($g_hStatusBar, $sWaitMessage)
		EndIf
		;SetDebugLog("Waiting for mutex ticket (" & $iTicket & "): " & $sTicketMutex)
		_Sleep($iDelay, True, False)
		;Sleep($iDelay)
	WEnd

	; bot stopped
	Return ReleaseMutex($hTicketMutex, 0)
EndFunc   ;==>AcquireMutexTicket

Func LockBotSlot($bLock = True)
	If $g_bBotLaunchOption_NoBotSlot = True Then Return False
	Static $bBotIsLocked = False
	If $bLock = Default Then Return $bBotIsLocked
	If $bLock = $bBotIsLocked Then Return $bBotIsLocked
	Local $bWasLocked = $bBotIsLocked
	If $bLock = True And $g_bRunState = True Then
		;Semaphores here don't support FIFO, use AcquireMutexTicket
		;If LockSemaphore($g_hMutextOrSemaphoreGlobalActiveBots, GetTranslatedFileIni("MBR GUI Design - Loading", "SplashStep_09", "Waiting for bot slot...")) Then $bBotIsLocked = $bLock
		If $g_hMutextOrSemaphoreGlobalActiveBots Then
			; should not happen
			SetDebugLog("LockBotSlot not released: " & $g_hMutextOrSemaphoreGlobalActiveBots)
			ReleaseMutex($g_hMutextOrSemaphoreGlobalActiveBots)
			$g_hMutextOrSemaphoreGlobalActiveBots = 0
		EndIf
		$g_hMutextOrSemaphoreGlobalActiveBots = AcquireMutexTicket("ActiveBot", $g_iGlobalActiveBotsAllowed, GetTranslatedFileIni("MBR GUI Design - Loading", "SplashStep_09", "Waiting for bot slot..."))
		If $g_hMutextOrSemaphoreGlobalActiveBots Then $bBotIsLocked = $bLock
	ElseIf $bLock = False Then
		;Semaphores here don't support FIFO, use AcquireMutexTicket
		;UnlockSemaphore($g_hMutextOrSemaphoreGlobalActiveBots)
		ReleaseMutex($g_hMutextOrSemaphoreGlobalActiveBots)
		SetDebugLog("Released Bot slot mutex: " & $g_hMutextOrSemaphoreGlobalActiveBots)
		$g_hMutextOrSemaphoreGlobalActiveBots = 0
		$bBotIsLocked = $bLock
	EndIf
	Return $bWasLocked
EndFunc   ;==>LockBotSlot
