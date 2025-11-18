$PBExportHeader$n_filetouch.sru
forward
global type n_filetouch from datastore
end type
type filetime from structure within n_filetouch
end type
type systemtime from structure within n_filetouch
end type
type win32_find_data from structure within n_filetouch
end type
end forward

type filetime from structure
	unsignedlong		dwlowdatetime
	unsignedlong		dwhighdatetime
end type

type systemtime from structure
	unsignedinteger		wyear
	unsignedinteger		wmonth
	unsignedinteger		wdayofweek
	unsignedinteger		wday
	unsignedinteger		whour
	unsignedinteger		wminute
	unsignedinteger		wsecond
	unsignedinteger		wmilliseconds
end type

type win32_find_data from structure
	unsignedlong		dwfileattributes
	filetime		ftcreationtime
	filetime		ftlastaccesstime
	filetime		ftlastwritetime
	unsignedlong		nfilesizehigh
	unsignedlong		nfilesizelow
	unsignedlong		dwreserved0
	unsignedlong		dwreserved1
	character		cfilename[260]
	character		calternatefilename[14]
end type

global type n_filetouch from datastore
string dataobject = "d_filetouch"
end type
global n_filetouch n_filetouch

type prototypes
Function long FindFirstFile ( &
	Ref string filename, &
	Ref WIN32_FIND_DATA findfiledata &
	) Library "kernel32.dll" Alias For "FindFirstFileW"

Function boolean FindNextFile ( &
	ulong handle, &
	Ref WIN32_FIND_DATA findfiledata &
	) Library "kernel32.dll" Alias For "FindNextFileW"

Function boolean FindClose ( &
	ulong handle &
	) Library "kernel32.dll"

Function boolean FileTimeToLocalFileTime ( &
	FILETIME lpFileTime, &
	Ref FILETIME lpLocalFileTime &
	) Library "kernel32.dll"

Function boolean FileTimeToSystemTime ( &
	FILETIME lpFileTime, &
	Ref SYSTEMTIME lpSystemTime &
	) Library "kernel32.dll"

Function boolean SystemTimeToFileTime ( &
	SYSTEMTIME lpSystemTime, &
	Ref FILETIME lpFileTime &
	) Library "kernel32.dll"

Function boolean LocalFileTimeToFileTime ( &
	Ref FILETIME lpLocalFileTime, &
	Ref FILETIME lpFileTime &
	) Library "kernel32.dll"

Function boolean SetFileTime ( &
	ulong hFile, &
	FILETIME lpCreationTime, &
	FILETIME lpLastAccessTime, &
	FILETIME lpLastWriteTime &
	) Library "kernel32.dll"

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

end prototypes

type variables
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
public function integer of_filedatetimetopb (filetime astr_filetime, ref datetime adt_filetime)
public function integer of_pbdatetimetofile (datetime adt_filetime, ref filetime astr_filetime)
public function boolean of_checkbit (long al_number, unsignedinteger aui_bit)
public function integer of_setfiletime (string as_filename, datetime adt_createtime, datetime adt_accesstime, datetime adt_writetime)
public function integer of_touchdirectory (string as_filespec, datetime adt_createtime, datetime adt_accesstime, datetime adt_writetime)
public function integer of_directory (string as_filespec)
end prototypes

public function integer of_filedatetimetopb (filetime astr_filetime, ref datetime adt_filetime);// convert a FILETIME structure to a PB DateTime

FILETIME	lstr_localtime
SYSTEMTIME lstr_systime
String ls_time
Date ld_fdate
Time lt_ftime

SetNull(adt_filetime)

If Not FileTimeToLocalFileTime(astr_FileTime, &
			lstr_localtime) Then Return -1

If Not FileTimeToSystemTime(lstr_localtime, &
			lstr_systime) Then Return -1

ld_fdate = Date(lstr_systime.wYear, &
					lstr_systime.wMonth, lstr_systime.wDay)

ls_time = String(lstr_systime.wHour) + ":" + &
			 String(lstr_systime.wMinute) + ":" + &
			 String(lstr_systime.wSecond) + ":" + &
			 String(lstr_systime.wMilliseconds)
lt_ftime = Time(ls_Time)

adt_filetime = DateTime(ld_fdate, lt_ftime)

Return 1

end function

public function integer of_pbdatetimetofile (datetime adt_filetime, ref filetime astr_filetime);// convert a PB DateTime to a FILETIME structure

FILETIME	lstr_localtime
SYSTEMTIME lstr_systime
String ls_time
Date ld_fdate
Time lt_ftime

ld_fdate = Date(adt_filetime)
lstr_systime.wYear  = Year(ld_fdate)
lstr_systime.wMonth = Month(ld_fdate)
lstr_systime.wDay   = Day(ld_fdate)

ls_time = String(adt_filetime, "hh:mm:ss:fff")
lstr_systime.wHour   = Long(Left(ls_time, 2))
lstr_systime.wMinute = Long(Mid(ls_time, 4, 2))
lstr_systime.wSecond = Long(Mid(ls_time, 7, 2))
lstr_systime.wMilliseconds = Long(Right(ls_time, 3))

If Not SystemTimeToFileTime(lstr_systime, &
			lstr_localtime) Then Return -1

If Not LocalFileTimeToFileTime(lstr_localtime, &
			astr_filetime) Then Return -1

Return 1

end function

public function boolean of_checkbit (long al_number, unsignedinteger aui_bit);// determine if a bit is on or off

If Int(Mod(al_number / (2 ^(aui_bit - 1)), 2)) > 0 Then
	Return True
End If

Return False

end function

public function integer of_setfiletime (string as_filename, datetime adt_createtime, datetime adt_accesstime, datetime adt_writetime);// set the Create, Access and LastWrite datetime

FILETIME lstr_Create, lstr_Access, lstr_Write
ULong lul_file
Integer li_rtn = 1

// convert createtime
If of_PBDateTimeToFile(adt_CreateTime, lstr_Create) = -1 Then
	Return -1
End If

// convert accesstime
If of_PBDateTimeToFile(adt_AccessTime, lstr_Access) = -1 Then
	Return -1
End If

// convert writetime
If of_PBDateTimeToFile(adt_WriteTime, lstr_Write) = -1 Then
	Return -1
End If

// open file for update
lul_File = CreateFile(as_FileName, GENERIC_WRITE, &
					FILE_SHARE_READ, 0, OPEN_EXISTING, &
					FILE_ATTRIBUTE_NORMAL, 0)
If lul_file = INVALID_HANDLE_VALUE Then
	Return -1
End If

// set the filetimes
If Not SetFileTime(lul_file, lstr_Create, &
				lstr_Access, lstr_Write) Then
	li_rtn = -1
End If

// close the file
CloseHandle(lul_file)

Return li_rtn

end function

public function integer of_touchdirectory (string as_filespec, datetime adt_createtime, datetime adt_accesstime, datetime adt_writetime);// set the filetimes for all files in the directory

WIN32_FIND_DATA lstr_fd
Boolean lb_found, lb_hidden, lb_system, lb_subdir
String ls_directory, ls_filename
Long ll_Handle

// append filename pattern
If Right(as_filespec, 1) = "\" Then
	ls_directory = as_filespec
	as_filespec += "*.*"
Else
	ls_directory = as_filespec + "\"
	as_filespec += "\*.*"
End If

// find first file
ll_Handle = FindFirstFile(as_filespec, lstr_fd)
If ll_Handle < 1 Then Return -1

// loop through each file
Do
	// add file to array
	ls_filename = String(lstr_fd.cFilename)
	If ls_filename = "." Or ls_filename = ".." Then
	Else
		// check for hidden attrib
		lb_hidden = of_checkbit(lstr_fd.dwFileAttributes, 2)
		lb_system = of_checkbit(lstr_fd.dwFileAttributes, 3)
		lb_subdir = of_checkbit(lstr_fd.dwFileAttributes, 5)
		If lb_hidden Or lb_system Or lb_subdir Then
			// skip sub-directories and hidden or system files
		Else
			// set the filetimes
			ls_filename = ls_directory + String(lstr_fd.cFilename)
			of_SetFileTime(ls_filename, adt_CreateTime, &
					adt_AccessTime, adt_WriteTime)
		End If
	End If
	// find next file
	lb_Found = FindNextFile(ll_Handle, lstr_fd)
Loop Until Not lb_Found

// close find handle
FindClose(ll_Handle)

Return 1

end function

public function integer of_directory (string as_filespec);// list files in the directory

WIN32_FIND_DATA lstr_fd
Boolean lb_found, lb_hidden, lb_system, lb_subdir
DateTime ldt_Create, ldt_Access, ldt_Write
String ls_filename, ls_directory
Double ld_size
Long ll_Handle, ll_next

this.Reset()

// append filename pattern
If Right(as_filespec, 1) = "\" Then
	ls_directory = as_filespec
	as_filespec += "*.*"
Else
	ls_directory = as_filespec + "\"
	as_filespec += "\*.*"
End If

// find first file
ll_Handle = FindFirstFile(as_filespec, lstr_fd)
If ll_Handle < 1 Then Return -1

// loop through each file
Do
	// add file to array
	ls_filename = String(lstr_fd.cFilename)
	If ls_filename = "." Or ls_filename = ".." Then
	Else
		// check for hidden attrib
		lb_hidden = of_checkbit(lstr_fd.dwFileAttributes, 2)
		lb_system = of_checkbit(lstr_fd.dwFileAttributes, 3)
		lb_subdir = of_checkbit(lstr_fd.dwFileAttributes, 5)
		If lb_hidden Or lb_system Or lb_subdir Then
			// skip sub-directories and hidden or system files
		Else
			// insert row
			ll_next = this.InsertRow(0)
			this.SetItem(ll_next, "name", ls_filename)
			this.SetItem(ll_next, "filename", ls_directory + ls_filename)
			ld_size = (lstr_fd.nFileSizeHigh * (2.0 ^ 32)) + lstr_fd.nFileSizeLow
			this.SetItem(ll_next, "size", ld_size)
			of_FileDateTimeToPB(lstr_fd.ftCreationTime, ldt_Create)
			this.SetItem(ll_next, "createdate", ldt_Create)
			of_FileDateTimeToPB(lstr_fd.ftLastAccessTime, ldt_Access)
			this.SetItem(ll_next, "accessdate", ldt_Access)
			of_FileDateTimeToPB(lstr_fd.ftLastWriteTime, ldt_Write)
			this.SetItem(ll_next, "writedate", ldt_Write)
		End If
	End If
	// find next file
	lb_Found = FindNextFile(ll_Handle, lstr_fd)
Loop Until Not lb_Found

// close find handle
FindClose(ll_Handle)

Return 1

end function

on n_filetouch.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_filetouch.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

