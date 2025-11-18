$PBExportHeader$n_getfilename.sru
$PBExportComments$GetOpenFileName WinAPI call (with multi-select)
forward
global type n_getfilename from nonvisualobject
end type
type openfilename from structure within n_getfilename
end type
end forward

type openfilename from structure
	ulong		lStructSize
	ulong		hwndOwner
	ulong		hInstance
	ulong		lpstrFilter
	ulong		lpstrCustomFilter
	ulong		nMaxCustFilter
	ulong		nFilterIndex
	ulong		lpstrFile
	ulong		nMaxFile
	ulong		lpstrFileTitle
	ulong		nMaxFileTitle
	ulong		lpstrInitialDir
	ulong		lpstrTitle
	ulong		Flags
	integer		nFileOffset
	integer		nFileExtension
	ulong		lpstrDefExt
	ulong		lCustData
	ulong		lpfnHook
	ulong		lpTemplateName
end type

global type n_getfilename from nonvisualobject autoinstantiate
end type

type prototypes
Private:

Function boolean GetOpenFileName ( &
	Ref OPENFILENAME lpOFN &
	) Library "comdlg32.dll" Alias For "GetOpenFileNameW"

Function boolean GetSaveFileName ( &
	Ref OPENFILENAME lpOFN &
	) Library "comdlg32.dll" Alias For "GetSaveFileNameW"

Function ulong CommDlgExtendedError ( &
	) Library "comdlg32.dll"

Function long RtlZeroMemory ( &
	Ref OPENFILENAME lpOFN, &
	long size &
	) Library "kernel32.dll" Alias For "RtlZeroMemory"

Function long RtlMoveMemory ( &
	Ref char dest[], &
	long source, &
	long size &
	) Library "kernel32.dll" Alias For "RtlMoveMemory"

Function long RtlMoveMemory ( &
	long dest, &
	Ref string source, &
	long Size ) Library "kernel32.dll" Alias For "RtlMoveMemory"

Function long RtlMoveMemory ( &
	long dest, &
	Ref char source[], &
	long Size ) Library "kernel32.dll" Alias For "RtlMoveMemory"

Function long LocalAlloc ( &
	long uFlags, &
	long uBytes &
	) Library "kernel32.dll"

Function long LocalFree ( &
	long hMem &
	) Library "kernel32.dll"

Function long SHGetFolderPath ( &
	long hwndOwner, &
	long nFolder, &
	long hToken, &
	long dwFlags, &
	Ref string pszPath &
	) Library "shell32.dll" Alias For "SHGetFolderPathW"
	
Function ulong RegisterWindowMessage ( &
	string lpString &
	) Library "user32.dll" Alias For "RegisterWindowMessageW"

end prototypes

type variables
Public:

Long il_hWnd
Long il_ChosenFilter

// constants for SHGetFolderPath
Constant Long CSIDL_DESKTOP				= 0
Constant Long CSIDL_INTERNET				= 1
Constant Long CSIDL_PROGRAMS				= 2
Constant Long CSIDL_CONTROLS				= 3
Constant Long CSIDL_PRINTERS				= 4
Constant Long CSIDL_PERSONAL				= 5
Constant Long CSIDL_FAVORITES				= 6
Constant Long CSIDL_STARTUP				= 7
Constant Long CSIDL_RECENT					= 8
Constant Long CSIDL_SENDTO					= 9
Constant Long CSIDL_BITBUCKET				= 10
Constant Long CSIDL_STARTMENU				= 11
Constant Long CSIDL_MYDOCUMENTS			= CSIDL_PERSONAL
Constant Long CSIDL_MYMUSIC				= 13
Constant Long CSIDL_MYVIDEO				= 14
Constant Long CSIDL_DESKTOPDIRECTORY	= 16
Constant Long CSIDL_DRIVES					= 17
Constant Long CSIDL_NETWORK				= 18
Constant Long CSIDL_NETHOOD				= 19
Constant Long CSIDL_FONTS					= 20
Constant Long CSIDL_TEMPLATES				= 21
Constant Long CSIDL_COMMON_STARTMENU	= 22
Constant Long CSIDL_COMMON_PROGRAMS		= 23
Constant Long CSIDL_COMMON_STARTUP		= 24
Constant Long CSIDL_COMMON_DESKTOPDIRECTORY	= 25
Constant Long CSIDL_APPDATA				= 26
Constant Long CSIDL_PRINTHOOD				= 27
Constant Long CSIDL_LOCAL_APPDATA		= 28
Constant Long CSIDL_ALTSTARTUP			= 29
Constant Long CSIDL_COMMON_ALTSTARTUP	= 30
Constant Long CSIDL_COMMON_FAVORITES	= 31
Constant Long CSIDL_INTERNET_CACHE		= 32
Constant Long CSIDL_COOKIES				= 33
Constant Long CSIDL_HISTORY				= 34
Constant Long CSIDL_COMMON_APPDATA		= 35
Constant Long CSIDL_WINDOWS				= 36
Constant Long CSIDL_SYSTEM					= 37
Constant Long CSIDL_PROGRAM_FILES		= 38
Constant Long CSIDL_MYPICTURES			= 39
Constant Long CSIDL_PROFILE				= 40
Constant Long CSIDL_SYSTEMX86				= 41
Constant Long CSIDL_PROGRAM_FILESX86	= 42
Constant Long CSIDL_PROGRAM_FILES_COMMON	= 43
Constant Long CSIDL_PROGRAM_FILES_COMMONX86	= 44
Constant Long CSIDL_COMMON_TEMPLATES	= 45
Constant Long CSIDL_COMMON_DOCUMENTS	= 46
Constant Long CSIDL_COMMON_ADMINTOOLS	= 47
Constant Long CSIDL_ADMINTOOLS			= 48
Constant Long CSIDL_CONNECTIONS			= 49
Constant Long CSIDL_COMMON_MUSIC			= 53
Constant Long CSIDL_COMMON_PICTURES		= 54
Constant Long CSIDL_COMMON_VIDEO			= 55
Constant Long CSIDL_RESOURCES				= 56
Constant Long CSIDL_RESOURCES_LOCALIZED	= 57
Constant Long CSIDL_COMMON_OEM_LINKS	= 58
Constant Long CSIDL_CDBURN_AREA			= 59

Private:

OPENFILENAME iOFN

CONSTANT long CHARSIZE = 2

CONSTANT ulong LMEM_ZEROINIT	= 64
CONSTANT ulong MAX_LENGTH		= 32767

// constants for OPENFILENAME structure flags
CONSTANT ulong OFN_READONLY					= 1
CONSTANT ulong OFN_OVERWRITEPROMPT			= 2
CONSTANT ulong OFN_HIDEREADONLY				= 4
CONSTANT ulong OFN_NOCHANGEDIR				= 8
CONSTANT ulong OFN_SHOWHELP					= 16
CONSTANT ulong OFN_ENABLEHOOK					= 32
CONSTANT ulong OFN_ENABLETEMPLATE			= 64
CONSTANT ulong OFN_ENABLETEMPLATEHANDLE	= 128
CONSTANT ulong OFN_NOVALIDATE					= 256
CONSTANT ulong OFN_ALLOWMULTISELECT			= 512
CONSTANT ulong OFN_EXTENSIONDIFFERENT		= 1024
CONSTANT ulong OFN_PATHMUSTEXIST				= 2048
CONSTANT ulong OFN_FILEMUSTEXIST				= 4096
CONSTANT ulong OFN_CREATEPROMPT				= 8192
CONSTANT ulong OFN_SHAREAWARE					= 16384
CONSTANT ulong OFN_NOREADONLYRETURN			= 32768
CONSTANT ulong OFN_NOTESTFILECREATE			= 65536
CONSTANT ulong OFN_NONETWORKBUTTON			= 131072
CONSTANT ulong OFN_NOLONGNAMES				= 262144
CONSTANT ulong OFN_EXPLORER					= 524288
CONSTANT ulong OFN_NODEREFERENCELINKS		= 1048576
CONSTANT ulong OFN_LONGNAMES					= 2097152

// Variables to help with showing help
CONSTANT string HELPMSGSTRING = "commdlg_help"
Boolean ib_ShowHelp

end variables

forward prototypes
private subroutine of_chartostring (boolean ab_multifile, character ac_char[], ref string as_string[])
private function integer of_getfilename (boolean ab_openfilename, boolean ab_multifile, unsignedlong aul_flags, string as_title, ref string as_pathname[], ref string as_filename[], string as_extension, string as_filter, string as_initdir, string as_initialfile)
public function string of_getfolderpath (long al_csidl)
private subroutine of_parse (string as_sep, string as_list, ref string as_array[])
private function long of_stringtochar (string as_string, ref character ac_char[])
public function integer of_getopenfilename (string as_title, ref string as_pathname, ref string as_filename)
public function integer of_getopenfilename (string as_title, ref string as_pathname, ref string as_filename, string as_extension, string as_filter, string as_initdir)
public function integer of_getopenfilename (string as_title, ref string as_pathname[], ref string as_filename[])
public function integer of_getopenfilename (string as_title, ref string as_pathname[], ref string as_filename[], string as_extension, string as_filter, string as_initdir)
public function integer of_getsavefilename (string as_title, ref string as_pathname, ref string as_filename)
public function integer of_getsavefilename (string as_title, ref string as_pathname, ref string as_filename, string as_extension, string as_filter, string as_initdir)
public function unsignedlong of_sethelp (window aw_window)
public subroutine of_sethelpoff ()
end prototypes

private subroutine of_chartostring (boolean ab_multifile, character ac_char[], ref string as_string[]);// -----------------------------------------------------------------------------
// SCRIPT:     of_CharToString
//
// PURPOSE:    This function converts a character array into an array of
//					strings.  Each string is separated by a null entry.
//
// ARGUMENTS:  ab_multifile	-	True=Multiple files allowed, False=Single
//					ac_char[]		-	Character array
//					as_string[]		-	Output String array
//
// RETURN:     Long				-	The number of entries in the string array
//
// DATE        PROG/ID 		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 10/11/2002	RolandS		Initial creation
// 02/13/2011	RolandS		Changed handling of nulls
// 01/10/2012	RolandS		Changed name of boolean argument
// -----------------------------------------------------------------------------

Long ll_char, ll_max, ll_array = 1
String ls_empty[]

as_string = ls_empty

ll_max = UpperBound(ac_char)
For ll_char = 1 To ll_max
	If ac_char[ll_char] = Char(0) Then
		If ab_multifile Then
			If ac_char[ll_char + 1] = Char(0) Then
				Exit
			Else
				ll_array = ll_array + 1
			End If
		Else
			Exit
		End If
	Else
		as_string[ll_array] += String(ac_char[ll_char])
	End If
Next

end subroutine

private function integer of_getfilename (boolean ab_openfilename, boolean ab_multifile, unsignedlong aul_flags, string as_title, ref string as_pathname[], ref string as_filename[], string as_extension, string as_filter, string as_initdir, string as_initialfile);// -----------------------------------------------------------------------------
// SCRIPT:     of_GetFileName
//
// PURPOSE:    This function opens the GetOpenFileName or GetSaveFileName
//					dialog boxes.
//
// ARGUMENTS:  ab_openfilename	-	True=GetOpenFileName, False=GetSaveFileName
//					ab_multifile		-	True=Multiple files allowed, False=Single
//					aul_flags			-	Flag to set various options
//					as_title				-	Title for the dialog box
//					as_pathname[]		-	Array of returned full path filenames
//					as_filename[]		-	Array of returned filenames
//					as_extension		-	Default file extension
//					as_filter			-	Filter string (see PB Help for format)
//					as_initdir			-	Initial directory
//					as_initialfile		-	Initial file name
//
// RETURN:     Integer				-	 1 = File(s) were selected
//												 0 = User clicked cancel button
//												-1 = Some sort of error
//
// DATE        PROG/ID 		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 10/11/2002	RolandS		Initial creation
// 08/31/2010	RolandS		Changed to support default filename
// 12/07/2010	BrianL		Added support for default file extension
// 01/07/2012	DanC			Added OFN_SHOWHELP flag when of_SetHelp called
// 01/10/2012	RolandS		Added argument ab_multifile
// -----------------------------------------------------------------------------

Integer li_rc, li_cnt, li_max, li_next
Long ll_errcode, ll_length, ll_sizeof
Char lc_pathname[], lc_filter[]
String ls_filter[], ls_work[]
Boolean lb_return

// sizeof structure
ll_sizeof = (18 * 4) + (2 * 2)

// initialize structure memory
RtlZeroMemory(iOFN, ll_sizeof)

// initialize structure
iOFN.lStructSize = ll_sizeof
iOFN.nFilterIndex = 1
iOFN.nMaxFile = MAX_LENGTH
iOFN.hWndOwner = il_hWnd
iOFN.Flags = aul_flags

If ib_ShowHelp Then
	iOFN.Flags += OFN_SHOWHELP
End If

// initialize output arrays
as_pathname = ls_work
as_filename = ls_work

// allocate memory and copy title
ll_length = Len(as_title) * CHARSIZE
iOFN.lpstrTitle = LocalAlloc(LMEM_ZEROINIT, ll_length + 2)
RtlMoveMemory(iOFN.lpstrTitle, as_title, ll_length)

// allocate memory and copy filter
this.of_Parse(",", as_filter, ls_filter)
li_max = UpperBound(ls_filter)
For li_cnt = 1 To li_max
	ll_length = this.of_StringToChar(Trim(ls_filter[li_cnt]), lc_filter)
Next
ll_length = UpperBound(lc_filter) * CHARSIZE
iOFN.lpstrFilter = LocalAlloc(LMEM_ZEROINIT, ll_length)
RtlMoveMemory(iOFN.lpstrFilter, lc_filter, ll_length)

// allocate memory and copy default extension (if given)
If as_extension <> "" Then
	ll_length = Len(as_extension) * CHARSIZE
	iOFN.lpstrDefExt = LocalAlloc(LMEM_ZEROINIT, ll_length)
	RtlMoveMemory(iOFN.lpstrDefExt, as_extension, ll_length)
End If

// allocate memory and copy initialdir (if given)
If as_initdir <> "" Then
	ll_length = Len(as_initdir) * CHARSIZE
	iOFN.lpstrInitialDir = LocalAlloc(LMEM_ZEROINIT, ll_length)
	RtlMoveMemory(iOFN.lpstrInitialDir, as_initdir, ll_length)
End If

// allocate memory for returned data
lc_pathname = Space(MAX_LENGTH)
iOFN.nMaxFile = MAX_LENGTH
iOFN.lpstrFile = LocalAlloc(LMEM_ZEROINIT, MAX_LENGTH)
If as_initialfile <> "" Then
	ll_length = Len(as_initialfile) * CHARSIZE
	RtlMoveMemory(iOFN.lpstrFile, as_initialfile, ll_length)
End If

// display dialog box
If ab_openfilename Then
	lb_return = GetOpenFileName(iOFN)
Else
	lb_return = GetSaveFileName(iOFN)
End If

// check the results
If lb_return Then
	il_ChosenFilter = iOFN.nFilterIndex
	// copy returned pathnames to char array
	RtlMoveMemory(lc_pathname, iOFN.lpstrFile, MAX_LENGTH)
	of_CharToString(ab_multifile, lc_pathname, ls_work)
	// copy pathnames/filenames to output arguments
	li_max = UpperBound(ls_work)
	If li_max = 1 Then
		li_next = LastPos(ls_work[1], "\")
		as_pathname[1] = ls_work[1]
		as_filename[1] = Right(ls_work[1], (Len(ls_work[1]) - li_next))
	Else
		For li_cnt = 2 To li_max
			li_next = UpperBound(as_pathname) + 1
			as_pathname[li_next] = ls_work[1] + "\" + ls_work[li_cnt]
			as_filename[li_next] = ls_work[li_cnt]
		Next
	End If
	li_rc = 1
Else
	ll_errcode = CommDlgExtendedError()
	If ll_errcode = 0 Then
		li_rc = 0
	Else
		MessageBox("Common Dialog Error", "Error code: " + String(ll_errcode))
		li_rc = -1
	End If
End If

// free allocated memory
LocalFree(iOFN.lpstrTitle)
LocalFree(iOFN.lpstrFilter)
LocalFree(iOFN.lpstrFile)

If iOFN.lpstrDefExt > 0 Then
	LocalFree(iOFN.lpstrDefExt)
End If

If iOFN.lpstrInitialDir > 0 Then
	LocalFree(iOFN.lpstrInitialDir)
End If

Return li_rc

end function

public function string of_getfolderpath (long al_csidl);// -----------------------------------------------------------------------------
// SCRIPT:     of_GetFolderPath
//
// PURPOSE:    This function returns the path to a shell folder. The identifiers
//					are defined as public instance constants.
//
// ARGUMENTS:  al_CSIDL	- Shell folder identifier
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 01/10/2012	RolandS		Replaced with version from n_filesys
// -----------------------------------------------------------------------------

Constant Long SHGFP_TYPE_CURRENT = 0
String ls_path

ls_path = Space(256)

SHGetFolderPath(0, al_CSIDL, 0, SHGFP_TYPE_CURRENT, ls_path)

Return ls_path

end function

private subroutine of_parse (string as_sep, string as_list, ref string as_array[]);// -----------------------------------------------------------------------------
// SCRIPT:     of_Parse
//
// PURPOSE:    This function parses a string of comma separated values and
//					returns an array.
//
// ARGUMENTS:  as_sep		-	The separating value
//					as_list		-	String containing separated list
//					as_array[]	-	String array returned
//
// DATE        PROG/ID 		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 10/11/2002	RolandS		Initial creation
// -----------------------------------------------------------------------------

Long ll_pos, ll_cnt, ll_start
String ls_empty[], ls_list
Integer li_next

as_array = ls_empty
ls_list = Trim(as_list)
If Right(ls_list, 1) <> as_sep Then
	ls_list = ls_list + as_sep
End If

ll_start = 1
ll_pos = Pos(ls_list, as_sep, ll_start)
do while ll_pos > 1
	li_next = UpperBound(as_array) + 1
	as_array[li_next] = Mid(ls_list, ll_start, (ll_pos - ll_start))
	ll_start = ll_pos + 1
	ll_pos = Pos(ls_list, as_sep, ll_start)
loop

end subroutine

private function long of_stringtochar (string as_string, ref character ac_char[]);// -----------------------------------------------------------------------------
// SCRIPT:     of_StringToChar
//
// PURPOSE:    This function converts a string to an array of chars.  If this
//					function is called again, the string is added to the end of the
//					array.  Each string is separated by a single null and there are
//					two nulls at the end.
//
// ARGUMENTS:  as_string	-	String to convert
//					ac_char[]	-	String variable to search for
//
// RETURN:     Long			-	Number of entries in the array
//
// DATE        PROG/ID 		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 10/11/2002	RolandS		Initial creation
// -----------------------------------------------------------------------------

Long ll_len, ll_char, ll_into

// copy string to array
ll_len = Len(as_string)
FOR ll_char = 1 TO ll_len
	If ll_char = 1 Then
		ll_into = UpperBound(ac_char)
		If ll_into = 0 Then
			ll_into = 1
		End If
	Else
		ll_into = UpperBound(ac_char) + 1
	End If
	ac_char[ll_into] = Mid(as_string, ll_char, 1)
NEXT

// terminate with two nulls
SetNull(ac_char[ll_into + 1])
SetNull(ac_char[ll_into + 2])

Return UpperBound(ac_char)

end function

public function integer of_getopenfilename (string as_title, ref string as_pathname, ref string as_filename);// -----------------------------------------------------------------------------
// SCRIPT:     of_GetOpenFileName
//
// PURPOSE:    This function opens the GetOpenFileName dialog box.
//
// ARGUMENTS:  as_title			-	Title for the dialog box
//					as_pathname		-	Returned full path filename
//					as_filename		-	Returned filename
//
// RETURN:     Integer			-	 1 = File was selected
//											 0 = User clicked cancel button
//											-1 = Some sort of error
//
// DATE        PROG/ID 		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 12/07/2010	RolandS		Initial creation
// -----------------------------------------------------------------------------

Return of_GetOpenFileName(as_title, as_pathname, as_filename, "", "All Files (*.*), *.*", "")

end function

public function integer of_getopenfilename (string as_title, ref string as_pathname, ref string as_filename, string as_extension, string as_filter, string as_initdir);// -----------------------------------------------------------------------------
// SCRIPT:     of_GetOpenFileName
//
// PURPOSE:    This function opens the GetOpenFileName dialog box.
//
// ARGUMENTS:  as_title			-	Title for the dialog box
//					as_pathname		-	Returned full path filename
//					as_filename		-	Returned filename
//					as_extension	-	Default file extension
//					as_filter		-	Filter string (see PB Help for format)
//					as_initdir		-	Initial directory
//
// RETURN:     Integer			-	 1 = File was selected
//											 0 = User clicked cancel button
//											-1 = Some sort of error
//
// DATE        PROG/ID 		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 10/11/2002	RolandS		Initial creation
// 08/31/2010	RolandS		Changed to support default filename
// 12/07/2010	BrianL		Added support for default file extension
// 01/10/2012	RolandS		Added ab_multifile argument to of_GetFileName call
// -----------------------------------------------------------------------------

Integer li_rc
ULong lul_flags
String ls_pathname[], ls_filename[]

lul_flags = OFN_HIDEREADONLY + OFN_EXPLORER + OFN_FILEMUSTEXIST

li_rc = of_GetFileName(True, False, lul_flags, as_title, ls_pathname, &
				ls_filename, as_extension, as_filter, as_initdir, as_filename)

If UpperBound(ls_pathname) = 0 Then
	as_pathname = ""
	as_filename = ""
Else
	as_pathname = ls_pathname[1]
	as_filename = ls_filename[1]
End If

Return li_rc

end function

public function integer of_getopenfilename (string as_title, ref string as_pathname[], ref string as_filename[]);// -----------------------------------------------------------------------------
// SCRIPT:     of_GetOpenFileName
//
// PURPOSE:    This function opens the GetOpenFileName dialog box.
//
// ARGUMENTS:  as_title			-	Title for the dialog box
//					as_pathname[]	-	Array of returned full path filenames
//					as_filename[]	-	Array of returned filenames
//
// RETURN:     Integer			-	 1 = File(s) were selected
//											 0 = User clicked cancel button
//											-1 = Some sort of error
//
// DATE        PROG/ID 		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 12/07/2010	RolandS		Initial creation
// -----------------------------------------------------------------------------

Return of_GetOpenFileName(as_title, as_pathname, as_filename, "", "All Files (*.*), *.*", "")

end function

public function integer of_getopenfilename (string as_title, ref string as_pathname[], ref string as_filename[], string as_extension, string as_filter, string as_initdir);// -----------------------------------------------------------------------------
// SCRIPT:     of_GetOpenFileName
//
// PURPOSE:    This function opens the GetOpenFileName dialog box.
//
// ARGUMENTS:  as_title			-	Title for the dialog box
//					as_pathname[]	-	Array of returned full path filenames
//					as_filename[]	-	Array of returned filenames
//					as_extension	-	Default file extension
//					as_filter		-	Filter string (see PB Help for format)
//					as_initdir		-	Initial directory
//
// RETURN:     Integer			-	 1 = File(s) were selected
//											 0 = User clicked cancel button
//											-1 = Some sort of error
//
// DATE        PROG/ID 		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 10/11/2002	RolandS		Initial creation
// 08/31/2010	RolandS		Changed to support default filename
// 12/07/2010	BrianL		Added support for default file extension
// 01/10/2012	RolandS		Added ab_multifile argument to of_GetFileName call
// -----------------------------------------------------------------------------

Integer li_rc
ULong lul_flags

lul_flags = OFN_HIDEREADONLY + OFN_ALLOWMULTISELECT + OFN_EXPLORER + OFN_FILEMUSTEXIST

li_rc = of_GetFileName(True, True, lul_flags, as_title, as_pathname, &
				as_filename, as_extension, as_filter, as_initdir, as_filename[1])

Return li_rc

end function

public function integer of_getsavefilename (string as_title, ref string as_pathname, ref string as_filename);// -----------------------------------------------------------------------------
// SCRIPT:     of_GetSaveFileName
//
// PURPOSE:    This function opens the GetSaveFileName dialog box.
//
// ARGUMENTS:  as_title			-	Title for the dialog box
//					as_pathname		-	Returned full path filename
//					as_filename		-	Returned filename
//
// RETURN:     Integer			-	 1 = File was selected
//											 0 = User clicked cancel button
//											-1 = Some sort of error
//
// DATE        PROG/ID 		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 12/07/2010	RolandS		Initial creation
// -----------------------------------------------------------------------------

Return of_GetSaveFileName(as_title, as_pathname, as_filename, "", "All Files (*.*), *.*", "")

end function

public function integer of_getsavefilename (string as_title, ref string as_pathname, ref string as_filename, string as_extension, string as_filter, string as_initdir);// -----------------------------------------------------------------------------
// SCRIPT:     of_GetSaveFileName
//
// PURPOSE:    This function opens the GetSaveFileName dialog box.
//
// ARGUMENTS:  as_title			-	Title for the dialog box
//					as_pathname		-	Returned full path filename
//					as_filename		-	Returned filename
//					as_extension	-	Default file extension
//					as_filter		-	Filter string (see PB Help for format)
//					as_initdir		-	Initial directory
//
// RETURN:     Integer			-	 1 = File was selected
//											 0 = User clicked cancel button
//											-1 = Some sort of error
//
// DATE        PROG/ID 		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 10/11/2002	RolandS		Initial creation
// 08/31/2010	RolandS		Changed to support default filename
// 12/07/2010	BrianL		Added support for default file extension
// 01/10/2012	RolandS		Added ab_multifile argument to of_GetFileName call
// -----------------------------------------------------------------------------

Integer li_rc
ULong lul_flags
String ls_pathname[], ls_filename[]

lul_flags = OFN_HIDEREADONLY + OFN_EXPLORER + OFN_OVERWRITEPROMPT

li_rc = of_GetFileName(False, False, lul_flags, as_title, ls_pathname, &
				ls_filename, as_extension, as_filter, as_initdir, as_filename)

If UpperBound(ls_pathname) = 0 Then
	as_pathname = ""
	as_filename = ""
Else
	as_pathname = ls_pathname[1]
	as_filename = ls_filename[1]
End If

Return li_rc

end function

public function unsignedlong of_sethelp (window aw_window);// -----------------------------------------------------------------------------
// SCRIPT:     of_SetHelp
//
// PURPOSE:    This function activates the Help button on the getfilename
//					dialog window. It also registers an event on the passed window
//					that will be triggered when the Help button is clicked.
//
// ARGUMENTS:  aw_window	- The window displaying the dialog
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 01/07/2012	RolandS		Initial Coding (with thanks to Dan Cooperstock)
// -----------------------------------------------------------------------------

il_hwnd = Handle(aw_window)

ib_ShowHelp  = True

Return RegisterWindowMessage(HELPMSGSTRING)

end function

public subroutine of_sethelpoff ();// -----------------------------------------------------------------------------
// SCRIPT:     of_SetHelpOff
//
// PURPOSE:    This function turns off the Help button.
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 01/10/2012	RolandS		Initial Coding (with thanks to Dan Cooperstock)
// -----------------------------------------------------------------------------

il_hwnd = 0

ib_ShowHelp  = False

end subroutine

on n_getfilename.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_getfilename.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

