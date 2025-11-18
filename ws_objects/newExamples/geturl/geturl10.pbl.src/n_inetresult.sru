$PBExportHeader$n_inetresult.sru
forward
global type n_inetresult from internetresult
end type
end forward

global type n_inetresult from internetresult
end type
global n_inetresult n_inetresult

type prototypes
Function ulong CreateFile ( &
	string lpFileName, &
	ulong dwDesiredAccess, &
	ulong dwShareMode, &
	ulong lpSecurityAttributes, &
	ulong dwCreationDisposition, &
	ulong dwFlagsAndAttributes, &
	ulong hTemplateFile &
	) Library "kernel32.dll" Alias For "CreateFileW"

Function boolean CloseHandle ( &
	ulong hObject &
	) Library "kernel32.dll"

Function boolean WriteFile ( &
	ulong hFile, &
	blob lpBuffer, &
	ulong nNumberOfBytesToWrite, &
	Ref ulong lpNumberOfBytesWritten, &
	ulong lpOverlapped &
	) Library "kernel32.dll"

Function int GetTempPath ( &
	int nBufferLength, &
	Ref string lpBuffer &
	) Library "kernel32.dll" Alias For "GetTempPathW"

end prototypes

type variables
Blob iblob_data

// constants for CreateFile API function
Constant ULong INVALID_HANDLE_VALUE = -1
Constant ULong GENERIC_READ     = 2147483648
Constant ULong GENERIC_WRITE    = 1073741824
Constant ULong FILE_ATTRIBUTE_NORMAL = 128
Constant ULong FILE_SHARE_READ  = 1
Constant ULong FILE_SHARE_WRITE = 2
Constant ULong CREATE_NEW			= 1
Constant ULong CREATE_ALWAYS		= 2
Constant ULong OPEN_EXISTING		= 3
Constant ULong OPEN_ALWAYS			= 4
Constant ULong TRUNCATE_EXISTING = 5

end variables

forward prototypes
public function integer internetdata (blob data)
public function integer of_writefile (string as_filename, blob ablob_data)
public function string of_gettemppath ()
end prototypes

public function integer internetdata (blob data);// save the data to an instance variable
//
// Return - 1=Success, -1=Failure
//

iblob_data = data

Return 1

end function

public function integer of_writefile (string as_filename, blob ablob_data);ULong lul_file, lul_written
Boolean lb_rtn

// open file for write
lul_file = CreateFile(as_filename, GENERIC_WRITE, &
					FILE_SHARE_WRITE, 0, CREATE_ALWAYS, 0, 0)
If lul_file = INVALID_HANDLE_VALUE Then
	Return -1
End If

// write file to disk
lb_rtn = WriteFile(lul_file, ablob_data, &
					Len(ablob_data), lul_written, 0)

// close the file
CloseHandle(lul_file)

Return 1

end function

public function string of_gettemppath ();String ls_path
Integer li_buflen

li_buflen = 260
ls_path = Space(li_buflen)

GetTempPath(li_buflen, ls_path)

Return ls_path

end function

on n_inetresult.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_inetresult.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

