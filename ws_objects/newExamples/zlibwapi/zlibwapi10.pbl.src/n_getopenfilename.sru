$PBExportHeader$n_getopenfilename.sru
$PBExportComments$GetOpenFileName WinAPI call (with multi-select)
forward
global type n_getopenfilename from nonvisualobject
end type
type openfilename from structure within n_getopenfilename
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

global type n_getopenfilename from nonvisualobject autoinstantiate
end type

type prototypes
Function boolean GetOpenFileName ( &
	Ref OPENFILENAME lpOFN &
	) Library "comdlg32.dll" Alias For "GetOpenFileNameW"

Function ulong CommDlgExtendedError ( &
	) Library "comdlg32.dll"

Function long RtlMoveMemory ( &
	Ref char dest[], &
	long source, &
	long size &
	) Library "kernel32.dll"

Function long RtlMoveMemory ( &
	long dest, &
	Ref string source, &
	long Size ) Library "kernel32.dll"

Function long RtlMoveMemory ( &
	long dest, &
	Ref char source[], &
	long Size ) Library "kernel32.dll"

Function long LocalAlloc ( &
	long uFlags, &
	long uBytes &
	) Library "kernel32.dll"

Function long LocalFree ( &
	long hMem &
	) Library "kernel32.dll"

end prototypes

type variables
Private:

OPENFILENAME iOFN

CONSTANT ulong LMEM_ZEROINIT	= 64
CONSTANT ulong MAX_LENGTH		= 32767

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

end variables

forward prototypes
public function long of_chartostring (character ac_char[], ref string as_string[])
public subroutine of_parse (string as_sep, string as_list, ref string as_array[])
public function long of_stringtochar (string as_string, ref character ac_char[])
public function integer of_getopenfilename (long al_hwnd, unsignedlong aul_flags, string as_title, ref string as_pathname[], ref string as_filename[], string as_filter, string as_initialdir)
public function integer of_getopenfilename (long al_hwnd, string as_title, ref string as_pathname, ref string as_filename, string as_filter, string as_initialdir)
public function integer of_getopenfilename (long al_hwnd, string as_title, ref string as_pathname[], ref string as_filename[], string as_filter, string as_initialdir)
end prototypes

public function long of_chartostring (character ac_char[], ref string as_string[]);// -----------------------------------------------------------------------------
// SCRIPT:     of_CharToString
//
// PURPOSE:    This function converts a character array into an array of
//					strings.  Each string is separated by a null entry.
//
// ARGUMENTS:  ac_char[]	-	Character array
//					as_string[]	-	Output String array
//
// RETURN:     Long			-	The number of entries in the string array
//
// DATE        PROG/ID 		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 10/11/2002	RolandS		Initial creation
// -----------------------------------------------------------------------------

Long ll_char, ll_max, ll_array = 1
String ls_empty[]

as_string = ls_empty

ll_max = UpperBound(ac_char)
FOR ll_char = 1 TO ll_max
	If ac_char[ll_char] = Char(0) Then
		If ac_char[ll_char + 1] = Char(0) Then
			Exit
		Else
			ll_array = ll_array + 1
		End If
	Else
		as_string[ll_array] += String(ac_char[ll_char])
	End If
NEXT

Return UpperBound(as_string)

end function

public subroutine of_parse (string as_sep, string as_list, ref string as_array[]);// -----------------------------------------------------------------------------
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

public function long of_stringtochar (string as_string, ref character ac_char[]);// -----------------------------------------------------------------------------
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

public function integer of_getopenfilename (long al_hwnd, unsignedlong aul_flags, string as_title, ref string as_pathname[], ref string as_filename[], string as_filter, string as_initialdir);// -----------------------------------------------------------------------------
// SCRIPT:     of_GetOpenFileName
//
// PURPOSE:    This function opens the GetOpenFileName dialog box which
//					allows for multiple file selection.
//
// ARGUMENTS:  al_hWnd			-	Handle to parent window
//					aul_flags		-	Flag to set various options
//					as_title			-	Title for the dialog box
//					as_pathname[]	-	Array of returned full path filenames
//					as_filename[]	-	Array of returned filenames
//					as_filter		-	Filter string (see PB Help for format)
//					as_initialdir	-	Initial directory
//
// RETURN:     Integer			-	 1 = File(s) were selected
//											 0 = User clicked cancel button
//											-1 = Some sort of error
//
// DATE        PROG/ID 		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 10/11/2002	RolandS		Initial creation
// -----------------------------------------------------------------------------

Integer li_rc, li_cnt, li_max, li_next
Long ll_errcode, ll_length
Char lc_pathname[], lc_filter[]
String ls_filter[], ls_work[]

// initialize structure
iOFN.lStructSize = (18 * 4) + (2 * 2)
iOFN.nFilterIndex = 1
iOFN.nMaxFile = MAX_LENGTH
iOFN.hWndOwner = al_hWnd
iOFN.Flags = aul_flags

// initialize output arrays
as_pathname = ls_work
as_filename = ls_work

// allocate memory and copy title
ll_length = Len(as_title) * 2
iOFN.lpstrTitle = LocalAlloc(LMEM_ZEROINIT, ll_length + 2)
RtlMoveMemory(iOFN.lpstrTitle, as_title, ll_length)

// allocate memory and copy filter
this.of_Parse(",", as_filter, ls_filter)
li_max = UpperBound(ls_filter)
For li_cnt = 1 To li_max
	ll_length = this.of_StringToChar(Trim(ls_filter[li_cnt]), lc_filter)
Next
ll_length = UpperBound(lc_filter) * 2
iOFN.lpstrFilter = LocalAlloc(LMEM_ZEROINIT, ll_length)
RtlMoveMemory(iOFN.lpstrFilter, lc_filter, ll_length)

// allocate memory and copy initialdir (if given)
If as_initialdir <> "" Then
	ll_length = Len(as_initialdir) * 2
	iOFN.lpstrInitialDir = LocalAlloc(LMEM_ZEROINIT, ll_length)
	RtlMoveMemory(iOFN.lpstrInitialDir, as_initialdir, ll_length)
End If

// allocate memory for returned data
lc_pathname = Space(MAX_LENGTH)
iOFN.nMaxFile = MAX_LENGTH
iOFN.lpstrFile = LocalAlloc(LMEM_ZEROINIT, MAX_LENGTH)

// display dialog box
If GetOpenFileName(iOFN) Then
	// copy returned pathnames to char array
	RtlMoveMemory(lc_pathname, iOFN.lpstrFile, MAX_LENGTH)
	this.of_CharToString(lc_pathname, ls_work)
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
If iOFN.lpstrInitialDir > 0 Then
	LocalFree(iOFN.lpstrInitialDir)
End If

Return li_rc

end function

public function integer of_getopenfilename (long al_hwnd, string as_title, ref string as_pathname, ref string as_filename, string as_filter, string as_initialdir);// -----------------------------------------------------------------------------
// SCRIPT:     of_GetOpenFileName
//
// PURPOSE:    This function opens the GetOpenFileName dialog box which
//					allows for multiple file selection.
//
// ARGUMENTS:  al_hWnd			-	Handle to parent window
//					as_title			-	Title for the dialog box
//					as_pathname		-	Returned full path filename
//					as_filename		-	Returned filename
//					as_filter		-	Filter string (see PB Help for format)
//					as_initialdir	-	Initial directory
//
// RETURN:     Integer			-	 1 = File(s) were selected
//											 0 = User clicked cancel button
//											-1 = Some sort of error
//
// DATE        PROG/ID 		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 10/11/2002	RolandS		Initial creation
// -----------------------------------------------------------------------------

Integer li_rc
ULong lul_flags
String ls_pathname[], ls_filename[]

as_pathname = ""
as_filename = ""

lul_flags = OFN_HIDEREADONLY + OFN_EXPLORER + OFN_FILEMUSTEXIST

li_rc = of_GetOpenFileName(al_hWnd, lul_flags, as_title, ls_pathname, &
							ls_filename, as_filter, as_initialdir)

If UpperBound(ls_pathname) > 0 Then
	as_pathname = ls_pathname[1]
	as_filename = ls_filename[1]
End If

Return li_rc

end function

public function integer of_getopenfilename (long al_hwnd, string as_title, ref string as_pathname[], ref string as_filename[], string as_filter, string as_initialdir);// -----------------------------------------------------------------------------
// SCRIPT:     of_GetOpenFileName
//
// PURPOSE:    This function opens the GetOpenFileName dialog box which
//					allows for multiple file selection.
//
// ARGUMENTS:  al_hWnd			-	Handle to parent window
//					as_title			-	Title for the dialog box
//					as_pathname[]	-	Array of returned full path filenames
//					as_filename[]	-	Array of returned filenames
//					as_filter		-	Filter string (see PB Help for format)
//					as_initialdir	-	Initial directory
//
// RETURN:     Integer			-	 1 = File(s) were selected
//											 0 = User clicked cancel button
//											-1 = Some sort of error
//
// DATE        PROG/ID 		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 10/11/2002	RolandS		Initial creation
// -----------------------------------------------------------------------------

Integer li_rc
ULong lul_flags

lul_flags = OFN_HIDEREADONLY + OFN_ALLOWMULTISELECT + OFN_EXPLORER + OFN_FILEMUSTEXIST

li_rc = of_GetOpenFileName(al_hWnd, lul_flags, as_title, as_pathname, &
							as_filename, as_filter, as_initialdir)

Return li_rc

end function

on n_getopenfilename.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_getopenfilename.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

