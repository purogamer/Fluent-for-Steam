;=================================================================================================
; AutoIt Version:   3.1.127 (beta)
; Language:   English
; Platform:   All Windows
; Author:         Nomad
; Requirements:  These functions will only work with beta.
;=================================================================================================
; Credits:  wOuter - These functions are based on his original _Mem() functions.  But they are
;         easier to comprehend and more reliable.  These functions are in no way a direct copy
;         of his functions.  His functions only provided a foundation from which these evolved.
;=================================================================================================
;
; Functions:
;
;=================================================================================================
; Function:   _MemoryOpen($iv_Pid[, $iv_DesiredAccess[, $iv_InheritHandle]])
; Description:    Opens a process and enables all possible access rights to the process.  The
;               Process ID of the process is used to specify which process to open.  You must
;               call this function before calling _MemoryClose(), _MemoryRead(), or _MemoryWrite().
; Parameter(s):  $iv_Pid - The Process ID of the program you want to open.
;               $iv_DesiredAccess - (optional) Set to 0x1F0FFF by default, which enables all
;                              possible access rights to the process specified by the
;                              Process ID.
;               $if_InheritHandle - (optional) If this value is TRUE, all processes created by
;                              this process will inherit the access handle.  Set to TRUE
;                              (1) by default.  Set to 0 if you want it to be FALSE.
; Requirement(s):   A valid process ID.
; Return Value(s):  On Success - Returns an array containing the Dll handle and an open handle to
;                         the specified process.
;               On Failure - Returns 0
;               @Error - 0 = No error.
;                      1 = Invalid $iv_Pid.
;                      2 = Failed to open Kernel32.dll.
;                      3 = Failed to open the specified process.
; Author(s):        Nomad
; Note(s):
;=================================================================================================
Func _MemoryOpen($iv_Pid, $iv_DesiredAccess = 0x1F0FFF, $if_InheritHandle = 1)

    If Not ProcessExists($iv_Pid) Then
        SetError(1)
        Return 0
    EndIf

    Local $ah_Handle[2] = [DllOpen('kernel32.dll')]

    If @Error Then
        SetError(2)
        Return 0
    EndIf

    Local $av_OpenProcess = DllCall($ah_Handle[0], 'int', 'OpenProcess', 'int', $iv_DesiredAccess, 'int', $if_InheritHandle, 'int', $iv_Pid)

    If @Error Then
        DllClose($ah_Handle[0])
        SetError(3)
        Return 0
    EndIf

    $ah_Handle[1] = $av_OpenProcess[0]

    Return $ah_Handle

EndFunc

;=================================================================================================
; Function:   _MemoryRead($iv_Address, $ah_Handle[, $sv_Type])
; Description:    Reads the value located in the memory address specified.
; Parameter(s):  $iv_Address - The memory address you want to read from. It must be in hex
;                          format (0x00000000).
;               $ah_Handle - An array containing the Dll handle and the handle of the open
;                         process as returned by _MemoryOpen().
;               $sv_Type - (optional) The "Type" of value you intend to read.  This is set to
;                        'dword'(32bit(4byte) signed integer) by default.  See the help file
;                        for DllStructCreate for all types.
;                        An example: If you want to read a word that is 15 characters in
;                        length, you would use 'char[16]'.
; Requirement(s):   The $ah_Handle returned from _MemoryOpen.
; Return Value(s):  On Success - Returns the value located at the specified address.
;               On Failure - Returns 0
;               @Error - 0 = No error.
;                      1 = Invalid $ah_Handle.
;                      2 = $sv_Type was not a string.
;                      3 = $sv_Type is an unknown data type.
;                      4 = Failed to allocate the memory needed for the DllStructure.
;                      5 = Error allocating memory for $sv_Type.
;                      6 = Failed to read from the specified process.
; Author(s):        Nomad
; Note(s):      Values returned are in Decimal format, unless specified as a 'char' type, then
;               they are returned in ASCII format.  Also note that size ('char[size]') for all
;               'char' types should be 1 greater than the actual size.
;=================================================================================================
Func _MemoryRead($iv_Address, $ah_Handle, $sv_Type = 'dword')

    If Not IsArray($ah_Handle) Then
        SetError(1)
        Return 0
    EndIf

    Local $v_Buffer = DllStructCreate($sv_Type)

    If @Error Then
        SetError(@Error + 1)
        Return 0
    EndIf

    DllCall($ah_Handle[0], 'int', 'ReadProcessMemory', 'int', $ah_Handle[1], 'int', $iv_Address, 'ptr', DllStructGetPtr($v_Buffer), 'int', DllStructGetSize($v_Buffer), 'int', '')

    If Not @Error Then
        Local $v_Value = DllStructGetData($v_Buffer, 1)
        Return $v_Value
    Else
        SetError(6)
        Return 0
    EndIf

EndFunc

;=================================================================================================
; Function:   _MemoryWrite($iv_Address, $ah_Handle, $v_Data[, $sv_Type])
; Description:    Writes data to the specified memory address.
; Parameter(s):  $iv_Address - The memory address you want to write to.  It must be in hex
;                          format (0x00000000).
;               $ah_Handle - An array containing the Dll handle and the handle of the open
;                         process as returned by _MemoryOpen().
;               $v_Data - The data to be written.
;               $sv_Type - (optional) The "Type" of value you intend to write.  This is set to
;                        'dword'(32bit(4byte) signed integer) by default.  See the help file
;                        for DllStructCreate for all types.
;                        An example: If you want to write a word that is 15 characters in
;                        length, you would use 'char[16]'.
; Requirement(s):   The $ah_Handle returned from _MemoryOpen.
; Return Value(s):  On Success - Returns 1
;               On Failure - Returns 0
;               @Error - 0 = No error.
;                      1 = Invalid $ah_Handle.
;                      2 = $sv_Type was not a string.
;                      3 = $sv_Type is an unknown data type.
;                      4 = Failed to allocate the memory needed for the DllStructure.
;                      5 = Error allocating memory for $sv_Type.
;                      6 = $v_Data is not in the proper format to be used with the "Type"
;                         selected for $sv_Type, or it is out of range.
;                      7 = Failed to write to the specified process.
; Author(s):        Nomad
; Note(s):      Values sent must be in Decimal format, unless specified as a 'char' type, then
;               they must be in ASCII format.  Also note that size ('char[size]') for all
;               'char' types should be 1 greater than the actual size.
;=================================================================================================
Func _MemoryWrite($iv_Address, $ah_Handle, $v_Data, $sv_Type = 'dword')

    If Not IsArray($ah_Handle) Then
        SetError(1)
        Return 0
    EndIf

    Local $v_Buffer = DllStructCreate($sv_Type)

    If @Error Then
        SetError(@Error + 1)
        Return 0
    Else
        DllStructSetData($v_Buffer, 1, $v_Data)
        If @Error Then
            SetError(6)
            Return 0
        EndIf
    EndIf

    DllCall($ah_Handle[0], 'int', 'WriteProcessMemory', 'int', $ah_Handle[1], 'int', $iv_Address, 'ptr', DllStructGetPtr($v_Buffer), 'int', DllStructGetSize($v_Buffer), 'int', '')

    If Not @Error Then
        Return 1
    Else
        SetError(7)
        Return 0
    EndIf

EndFunc

;=================================================================================================
; Function:   _MemoryClose($ah_Handle)
; Description:    Closes the process handle opened by using _MemoryOpen().
; Parameter(s):  $ah_Handle - An array containing the Dll handle and the handle of the open
;                         process as returned by _MemoryOpen().
; Requirement(s):   The $ah_Handle returned from _MemoryOpen.
; Return Value(s):  On Success - Returns 1
;               On Failure - Returns 0
;               @Error - 0 = No error.
;                      1 = Invalid $ah_Handle.
;                      2 = Unable to close the process handle.
; Author(s):        Nomad
; Note(s):
;=================================================================================================
Func _MemoryClose($ah_Handle)

    If Not IsArray($ah_Handle) Then
        SetError(1)
        Return 0
    EndIf

    DllCall($ah_Handle[0], 'int', 'CloseHandle', 'int', $ah_Handle[1])
    If Not @Error Then
        DllClose($ah_Handle[0])
        Return 1
    Else
        DllClose($ah_Handle[0])
        SetError(2)
        Return 0
    EndIf

EndFunc

;=================================================================================================
; Function:   _MemoryPointerRead ($iv_Address, $ah_Handle, $av_Offset[, $sv_Type])
; Description:    Reads a chain of pointers and returns an array containing the destination
;               address and the data at the address.
; Parameter(s):  $iv_Address - The static memory address you want to start at. It must be in
;                          hex format (0x00000000).
;               $ah_Handle - An array containing the Dll handle and the handle of the open
;                         process as returned by _MemoryOpen().
;               $av_Offset - An array of offsets for the pointers.  Each pointer must have an
;                         offset.  If there is no offset for a pointer, enter 0 for that
;                         array dimension.
;               $sv_Type - (optional) The "Type" of data you intend to read at the destination
;                         address.  This is set to 'dword'(32bit(4byte) signed integer) by
;                         default.  See the help file for DllStructCreate for all types.
; Requirement(s):   The $ah_Handle returned from _MemoryOpen.
; Return Value(s):  On Success - Returns an array containing the destination address and the value
;                         located at the address.
;               On Failure - Returns 0
;               @Error - 0 = No error.
;                      1 = $av_Offset is not an array.
;                      2 = Invalid $ah_Handle.
;                      3 = $sv_Type is not a string.
;                      4 = $sv_Type is an unknown data type.
;                      5 = Failed to allocate the memory needed for the DllStructure.
;                      6 = Error allocating memory for $sv_Type.
;                      7 = Failed to read from the specified process.
; Author(s):        Nomad
; Note(s):      Values returned are in Decimal format, unless a 'char' type is selected.
;               Set $av_Offset like this:
;               $av_Offset[0] = NULL (not used)
;               $av_Offset[1] = Offset for pointer 1 (all offsets must be in Decimal)
;               $av_Offset[2] = Offset for pointer 2
;               etc...
;               (The number of array dimensions determines the number of pointers)
;=================================================================================================
Func _MemoryPointerRead ($iv_Address, $ah_Handle, $av_Offset, $sv_Type = 'dword')

    If IsArray($av_Offset) Then
        If IsArray($ah_Handle) Then
            Local $iv_PointerCount = UBound($av_Offset) - 1
        Else
            SetError(2)
            Return 0
        EndIf
    Else
        SetError(1)
        Return 0
    EndIf

    Local $iv_Data[2], $i
    Local $v_Buffer = DllStructCreate('dword')

    For $i = 0 to $iv_PointerCount

        If $i = $iv_PointerCount Then
            $v_Buffer = DllStructCreate($sv_Type)
            If @Error Then
                SetError(@Error + 2)
                Return 0
            EndIf

            $iv_Address = '0x' & hex($iv_Data[1] + $av_Offset[$i])
            DllCall($ah_Handle[0], 'int', 'ReadProcessMemory', 'int', $ah_Handle[1], 'int', $iv_Address, 'ptr', DllStructGetPtr($v_Buffer), 'int', DllStructGetSize($v_Buffer), 'int', '')
            If @Error Then
                SetError(7)
                Return 0
            EndIf

            $iv_Data[1] = DllStructGetData($v_Buffer, 1)

        ElseIf $i = 0 Then
            DllCall($ah_Handle[0], 'int', 'ReadProcessMemory', 'int', $ah_Handle[1], 'int', $iv_Address, 'ptr', DllStructGetPtr($v_Buffer), 'int', DllStructGetSize($v_Buffer), 'int', '')
            If @Error Then
                SetError(7)
                Return 0
            EndIf

            $iv_Data[1] = DllStructGetData($v_Buffer, 1)

        Else
            $iv_Address = '0x' & hex($iv_Data[1] + $av_Offset[$i])
            DllCall($ah_Handle[0], 'int', 'ReadProcessMemory', 'int', $ah_Handle[1], 'int', $iv_Address, 'ptr', DllStructGetPtr($v_Buffer), 'int', DllStructGetSize($v_Buffer), 'int', '')
            If @Error Then
                SetError(7)
                Return 0
            EndIf

            $iv_Data[1] = DllStructGetData($v_Buffer, 1)

        EndIf

    Next

    $iv_Data[0] = $iv_Address

    Return $iv_Data

EndFunc

;=================================================================================================
; Function:   _MemoryPointerWrite ($iv_Address, $ah_Handle, $av_Offset, $v_Data[, $sv_Type])
; Description:    Reads a chain of pointers and writes the data to the destination address.
; Parameter(s):  $iv_Address - The static memory address you want to start at. It must be in
;                          hex format (0x00000000).
;               $ah_Handle - An array containing the Dll handle and the handle of the open
;                         process as returned by _MemoryOpen().
;               $av_Offset - An array of offsets for the pointers.  Each pointer must have an
;                         offset.  If there is no offset for a pointer, enter 0 for that
;                         array dimension.
;               $v_Data - The data to be written.
;               $sv_Type - (optional) The "Type" of data you intend to write at the destination
;                         address.  This is set to 'dword'(32bit(4byte) signed integer) by
;                         default.  See the help file for DllStructCreate for all types.
; Requirement(s):   The $ah_Handle returned from _MemoryOpen.
; Return Value(s):  On Success - Returns the destination address.
;               On Failure - Returns 0.
;               @Error - 0 = No error.
;                      1 = $av_Offset is not an array.
;                      2 = Invalid $ah_Handle.
;                      3 = Failed to read from the specified process.
;                      4 = $sv_Type is not a string.
;                      5 = $sv_Type is an unknown data type.
;                      6 = Failed to allocate the memory needed for the DllStructure.
;                      7 = Error allocating memory for $sv_Type.
;                      8 = $v_Data is not in the proper format to be used with the
;                         "Type" selected for $sv_Type, or it is out of range.
;                      9 = Failed to write to the specified process.
; Author(s):        Nomad
; Note(s):      Data written is in Decimal format, unless a 'char' type is selected.
;               Set $av_Offset like this:
;               $av_Offset[0] = NULL (not used, doesn't matter what's entered)
;               $av_Offset[1] = Offset for pointer 1 (all offsets must be in Decimal)
;               $av_Offset[2] = Offset for pointer 2
;               etc...
;               (The number of array dimensions determines the number of pointers)
;=================================================================================================
Func _MemoryPointerWrite ($iv_Address, $ah_Handle, $av_Offset, $v_Data, $sv_Type = 'dword')

    If IsArray($av_Offset) Then
        If IsArray($ah_Handle) Then
            Local $iv_PointerCount = UBound($av_Offset) - 1
        Else
            SetError(2)
            Return 0
        EndIf
    Else
        SetError(1)
        Return 0
    EndIf

    Local $iv_StructData, $i
    Local $v_Buffer = DllStructCreate('dword')

    For $i = 0 to $iv_PointerCount
        If $i = $iv_PointerCount Then
            $v_Buffer = DllStructCreate($sv_Type)
            If @Error Then
                SetError(@Error + 3)
                Return 0
            EndIf

            DllStructSetData($v_Buffer, 1, $v_Data)
            If @Error Then
                SetError(8)
                Return 0
            EndIf

            $iv_Address = '0x' & hex($iv_StructData + $av_Offset[$i])
            DllCall($ah_Handle[0], 'int', 'WriteProcessMemory', 'int', $ah_Handle[1], 'int', $iv_Address, 'ptr', DllStructGetPtr($v_Buffer), 'int', DllStructGetSize($v_Buffer), 'int', '')
            If @Error Then
                SetError(9)
                Return 0
            Else
                Return $iv_Address
            EndIf
        ElseIf $i = 0 Then
            DllCall($ah_Handle[0], 'int', 'ReadProcessMemory', 'int', $ah_Handle[1], 'int', $iv_Address, 'ptr', DllStructGetPtr($v_Buffer), 'int', DllStructGetSize($v_Buffer), 'int', '')
            If @Error Then
                SetError(3)
                Return 0
            EndIf

            $iv_StructData = DllStructGetData($v_Buffer, 1)

        Else
            $iv_Address = '0x' & hex($iv_StructData + $av_Offset[$i])
            DllCall($ah_Handle[0], 'int', 'ReadProcessMemory', 'int', $ah_Handle[1], 'int', $iv_Address, 'ptr', DllStructGetPtr($v_Buffer), 'int', DllStructGetSize($v_Buffer), 'int', '')
            If @Error Then
                SetError(3)
                Return 0
            EndIf

            $iv_StructData = DllStructGetData($v_Buffer, 1)

        EndIf
    Next

EndFunc

Func _MemoryReadStruct($iv_Address, $ah_Handle, ByRef $tStruct)

    If Not IsArray($ah_Handle) Then
        SetError(1)
        Return 0
    EndIf

    DllCall($ah_Handle[0], 'int', 'ReadProcessMemory', 'int', $ah_Handle[1], 'int', $iv_Address, 'ptr', DllStructGetPtr($tStruct), 'int', DllStructGetSize($tStruct), 'int', '')

    If Not @Error Then
        Return 1
    Else
        SetError(6)
        Return 0
    EndIf

EndFunc