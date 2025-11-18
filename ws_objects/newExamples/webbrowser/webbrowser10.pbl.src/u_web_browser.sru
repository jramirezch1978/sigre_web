$PBExportHeader$u_web_browser.sru
forward
global type u_web_browser from olecustomcontrol
end type
end forward

global type u_web_browser from olecustomcontrol
integer width = 1655
integer height = 1032
integer taborder = 10
boolean border = false
string binarykey = "u_web_browser.udo"
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
event statustextchange ( string as_text )
event progresschange ( long progress,  long progressmax )
event commandstatechange ( long command,  boolean enable )
event downloadbegin ( )
event downloadcomplete ( )
event titlechange ( string as_text )
event propertychange ( string szproperty )
event beforenavigate2 ( oleobject pdisp,  any url,  any flags,  any targetframename,  any postdata,  any headers,  ref boolean ab_cancel )
event newwindow2 ( ref oleobject ppdisp,  ref boolean ab_cancel )
event navigatecomplete2 ( oleobject pdisp,  any url )
event documentcomplete ( oleobject pdisp,  any url )
event onquit ( )
event onvisible ( boolean ocx_visible )
event ontoolbar ( boolean toolbar )
event onmenubar ( boolean menubar )
event onstatusbar ( boolean statusbar )
event onfullscreen ( boolean fullscreen )
event ontheatermode ( boolean theatermode )
event windowsetresizable ( boolean resizable )
event windowsetleft ( long left )
event windowsettop ( long top )
event windowsetwidth ( long ocx_width )
event windowsetheight ( long ocx_height )
event windowclosing ( boolean ischildwindow,  ref boolean ab_cancel )
event clienttohostwindow ( ref long cx,  ref long cy )
event setsecurelockicon ( long securelockicon )
event filedownload ( boolean activedocument,  ref boolean ab_cancel )
event navigateerror ( oleobject pdisp,  any url,  any frame,  any statuscode,  ref boolean ab_cancel )
event printtemplateinstantiation ( oleobject pdisp )
event printtemplateteardown ( oleobject pdisp )
event updatepagestatus ( oleobject pdisp,  any npage,  any fdone )
event privacyimpactedstatechange ( boolean bimpacted )
event setphishingfilterstatus ( long phishingfilterstatus )
end type
global u_web_browser u_web_browser

type prototypes
Function long ShellExecute ( &
	long hwindow, &
	string lpOperation, &
	string lpFile, &
	string lpParameters, &
	string lpDirectory, &
	long nShowCmd &
	) Library "shell32.dll" Alias for "ShellExecuteW"

Function long GetDesktopWindow ( &
	) Library "user32.dll"

Function ulong CreateFile ( &
	string lpFileName, &
	ulong dwDesiredAccess, &
	ulong dwShareMode, &
	ulong lpSecurityAttributes, &
	ulong dwCreationDisposition, &
	ulong dwFlagsAndAttributes, &
	ulong hTemplateFile &
	) Library "kernel32.dll" Alias For "CreateFileW"

Function boolean ReadFile ( &
	ulong hFile, &
	Ref blob lpBuffer, &
	ulong nNumberOfBytesToRead, &
	Ref ulong lpNumberOfBytesRead, &
	ulong lpOverlapped &
	) Library "kernel32.dll"

Function boolean WriteFile ( &
	ulong hFile, &
	blob lpBuffer, &
	ulong nNumberOfBytesToWrite, &
	Ref ulong lpNumberOfBytesWritten, &
	ulong lpOverlapped &
	) Library "kernel32.dll"

Function boolean CloseHandle ( &
	ulong hObject &
	) Library "kernel32.dll"

end prototypes

type variables
// constants for CreateFile API function
Constant ULong INVALID_HANDLE_VALUE = -1
Constant ULong GENERIC_READ     = 2147483648
Constant ULong GENERIC_WRITE    = 1073741824
Constant ULong FILE_SHARE_READ  = 1
Constant ULong FILE_SHARE_WRITE = 2
Constant ULong CREATE_NEW			= 1
Constant ULong CREATE_ALWAYS		= 2
Constant ULong OPEN_EXISTING		= 3
Constant ULong OPEN_ALWAYS			= 4
Constant ULong TRUNCATE_EXISTING = 5

integer OLECMDEXECOPT_DODEFAULT			= 0
integer OLECMDEXECOPT_PROMPTUSER			= 1
integer OLECMDEXECOPT_DONTPROMPTUSER	= 2
integer OLECMDEXECOPT_SHOWHELP			= 3

integer OLECMDID_OPEN					= 1
integer OLECMDID_NEW						= 2
integer OLECMDID_SAVE					= 3
integer OLECMDID_SAVEAS					= 4
integer OLECMDID_SAVECOPYAS			= 5
integer OLECMDID_PRINT					= 6
integer OLECMDID_PRINTPREVIEW			= 7
integer OLECMDID_PAGESETUP				= 8
integer OLECMDID_SPELL					= 9
integer OLECMDID_PROPERTIES			= 10
integer OLECMDID_CUT						= 11
integer OLECMDID_COPY					= 12
integer OLECMDID_PASTE					= 13
integer OLECMDID_PASTESPECIAL			= 14
integer OLECMDID_UNDO					= 15
integer OLECMDID_REDO					= 16
integer OLECMDID_SELECTALL				= 17
integer OLECMDID_CLEARSELECTION		= 18
integer OLECMDID_ZOOM					= 19
integer OLECMDID_GETZOOMRANGE			= 20
integer OLECMDID_UPDATECOMMANDS		= 21
integer OLECMDID_REFRESH				= 22
integer OLECMDID_STOP					= 23
integer OLECMDID_HIDETOOLBARS			= 24
integer OLECMDID_SETPROGRESSMAX		= 25
integer OLECMDID_SETPROGRESSPOS		= 26
integer OLECMDID_SETPROGRESSTEXT		= 27
integer OLECMDID_SETTITLE				= 28
integer OLECMDID_SETDOWNLOADSTATE	= 29
integer OLECMDID_STOPDOWNLOAD			= 30
integer OLECMDID_ONTOOLBARACTIVATED	= 31
integer OLECMDID_FIND					= 32
integer OLECMDID_DELETE					= 33
integer OLECMDID_HTTPEQUIV				= 34
integer OLECMDID_HTTPEQUIV_DONE		= 35
integer OLECMDID_ENABLE_INTERACTION	= 36
integer OLECMDID_ONUNLOAD				= 37
integer OLECMDID_PROPERTYBAG2			= 38
integer OLECMDID_PREREFRESH			= 39
integer OLECMDID_SHOWSCRIPTERROR        = 40 
integer OLECMDID_SHOWMESSAGE            = 41 
integer OLECMDID_SHOWFIND               = 42 
integer OLECMDID_SHOWPAGESETUP          = 43 
integer OLECMDID_SHOWPRINT              = 44 
integer OLECMDID_CLOSE                  = 45 
integer OLECMDID_ALLOWUILESSSAVEAS      = 46 
integer OLECMDID_DONTDOWNLOADCSS        = 47 
integer OLECMDID_UPDATEPAGESTATUS       = 48 
integer OLECMDID_PRINT2                 = 49 
integer OLECMDID_PRINTPREVIEW2          = 50 
integer OLECMDID_SETPRINTTEMPLATE       = 51 
integer OLECMDID_GETPRINTTEMPLATE       = 52 
integer OLECMDID_PAGEACTIONBLOCKED      = 55
integer OLECMDID_PAGEACTIONUIQUERY      = 56
integer OLECMDID_FOCUSVIEWCONTROLS      = 57
integer OLECMDID_FOCUSVIEWCONTROLSQUERY = 58
integer OLECMDID_SHOWPAGEACTIONMENU     = 59
integer OLECMDID_ADDTRAVELENTRY         = 60
integer OLECMDID_UPDATETRAVELENTRY      = 61
integer OLECMDID_UPDATEBACKFORWARDSTATE = 62
integer OLECMDID_OPTICAL_ZOOM           = 63
integer OLECMDID_OPTICAL_GETZOOMRANGE   = 64
integer OLECMDID_WINDOWSTATECHANGED     = 65
integer OLECMDID_ACTIVEXINSTALLSCOPE    = 66

end variables

forward prototypes
public subroutine of_goback ()
public subroutine of_goforward ()
public subroutine of_gohome ()
public subroutine of_refresh ()
public subroutine of_gosearch ()
public subroutine of_stop ()
public subroutine of_execwb (integer command_id, integer execution_option)
public subroutine of_navigate (string as_url)
public subroutine of_execwb_saveas ()
public subroutine of_execwb_save ()
public subroutine of_execwb_print (boolean ab_prompt)
public subroutine of_resize (integer ai_newwidth, integer ai_newheight)
public subroutine of_designmode ()
public subroutine of_controlpanel (string as_control_app)
public function string of_getsource ()
public function string of_geturl ()
public subroutine of_setsource (string as_source)
public subroutine of_execwb_printpreview ()
public subroutine of_execwb_pagesetup ()
public subroutine of_documentcommand (string as_command)
public subroutine of_documentcommand (string as_command, boolean ab_userinterface)
public subroutine of_toggle_property (string as_propname)
public function boolean of_ispropertyset (string as_propname)
public subroutine of_inserthtml (string as_html)
public subroutine of_documentcommand (string as_command, string as_value)
public function window of_parentwindow ()
public function integer of_writefile (string as_filename, string as_filecontents)
public function unsignedlong of_readfile (string as_filename, ref string as_filecontents)
public subroutine of_execscript (integer as_script)
public function encoding of_getencoding (string as_filename)
end prototypes

public subroutine of_goback ();// go back one page
this.object.goBack()

end subroutine

public subroutine of_goforward ();// go forward one page
this.object.goForward()

end subroutine

public subroutine of_gohome ();// go to home page
this.object.goHome()

end subroutine

public subroutine of_refresh ();// refresh current page
this.object.Refresh()

end subroutine

public subroutine of_gosearch ();// go to search page
this.object.goSearch()

end subroutine

public subroutine of_stop ();// stop current navigate
this.object.Stop()

end subroutine

public subroutine of_execwb (integer command_id, integer execution_option);// execute web browser command
this.object.ExecWB(command_id, execution_option, AsStatement!)

end subroutine

public subroutine of_navigate (string as_url);// go to specified file\webpage

SetPointer(HourGlass!)

this.object.Navigate(as_url, 0, "", "", "")

end subroutine

public subroutine of_execwb_saveas ();// open saveas dialog
//this.of_execwb(OLECMDID_SAVEAS, OLECMDEXECOPT_DODEFAULT)
this.of_execwb(OLECMDID_SAVEAS, OLECMDEXECOPT_PROMPTUSER)

end subroutine

public subroutine of_execwb_save ();// save the current document
this.of_execwb(OLECMDID_SAVE, OLECMDEXECOPT_DODEFAULT)

end subroutine

public subroutine of_execwb_print (boolean ab_prompt);// open print dialog
If ab_prompt Then
	this.of_execwb(OLECMDID_PRINT, OLECMDEXECOPT_PROMPTUSER)
Else
	this.of_execwb(OLECMDID_PRINT, OLECMDEXECOPT_DODEFAULT)
End If

end subroutine

public subroutine of_resize (integer ai_newwidth, integer ai_newheight);// resize the control
this.Resize(ai_newwidth, ai_newheight)

// adjust object size to match control size
this.SetRedraw(False)
this.Object.Width = UnitsToPixels(ai_newwidth, XUnitsToPixels!)
this.Object.Height = UnitsToPixels(ai_newheight, YUnitsToPixels!)
this.SetRedraw(True)

end subroutine

public subroutine of_designmode ();// turn on design mode
this.Object.Document.designMode = "On"

end subroutine

public subroutine of_controlpanel (string as_control_app);// this function launches a Control Panel app

String ls_null

SetNull(ls_null)

ShellExecute(GetDesktopWindow(), ls_null, "rundll32.exe", &
	"shell32.dll,Control_RunDLL " + as_control_app + ",", ls_null, 0)

end subroutine

public function string of_getsource ();// return the webpage HTML source
Return this.Object.Document.documentElement.InnerHTML

end function

public function string of_geturl ();// return the current URL
Return this.Object.LocationURL

end function

public subroutine of_setsource (string as_source);// set the webpage HTML source
this.Object.Document.Open()

this.Object.Document.Write(as_source)

this.Object.Document.Close()

end subroutine

public subroutine of_execwb_printpreview ();// Open Print Preview window
this.of_execwb(OLECMDID_PRINTPREVIEW, OLECMDEXECOPT_PROMPTUSER)

end subroutine

public subroutine of_execwb_pagesetup ();// Open Page Setup window
this.of_execwb(OLECMDID_PAGESETUP, OLECMDEXECOPT_PROMPTUSER)

end subroutine

public subroutine of_documentcommand (string as_command);// Execute document command

String ls_Null

SetNull(ls_Null)

this.Object.Document.ExecCommand(as_Command, False, ls_Null)

end subroutine

public subroutine of_documentcommand (string as_command, boolean ab_userinterface);// Execute document command with choice of popup/nopopup

String ls_Null

SetNull(ls_Null)

this.Object.Document.ExecCommand(as_Command, ab_UserInterface, ls_Null)

end subroutine

public subroutine of_toggle_property (string as_propname);// Toggle a property such as Bold, Italic or Underline

// This is actually done as a command
of_DocumentCommand(as_PropName)

end subroutine

public function boolean of_ispropertyset (string as_propname);// Query a boolean property of the document, e.g. Bold, Italic, or Underline

Return this.Object.Document.queryCommandState(as_PropName)

end function

public subroutine of_inserthtml (string as_html);// insert passed HTML into the selected range

OleObject range

range = this.Object.Document.selection.createRange()

range.pasteHTML(as_Html)

range.collapse(false)

range.select()

end subroutine

public subroutine of_documentcommand (string as_command, string as_value);// Execute document command with value

this.Object.Document.ExecCommand(as_Command, False, as_Value)

end subroutine

public function window of_parentwindow ();PowerObject	lpo_parent
Window lw_window

// loop thru parents until a window is found
lpo_parent = this.GetParent()
Do While lpo_parent.TypeOf() <> Window! and IsValid (lpo_parent)
	lpo_parent = lpo_parent.GetParent()
Loop

// set return to the window or null if not found
If IsValid (lpo_parent) Then
	lw_window = lpo_parent
Else
	SetNull(lw_window)
End If

Return lw_window

end function

public function integer of_writefile (string as_filename, string as_filecontents);// -----------------------------------------------------------------------------
// SCRIPT:     u_web_browser.of_WriteFile
//
// PURPOSE:    This function writes a file to disk.
//
// ARGUMENTS:  as_filename			- Name of the file to write
//					as_filecontents	- Contents of the file
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 9/18/2008	RolandS		Initial Coding
// -----------------------------------------------------------------------------

ULong lul_file, lul_length, lul_written
Blob lblob_filecontents
Boolean lb_result

lul_file = CreateFile(as_filename, GENERIC_WRITE, &
					FILE_SHARE_WRITE, 0, CREATE_ALWAYS, 0, 0)
If lul_file = INVALID_HANDLE_VALUE Then
	Return -999
End If

lblob_filecontents = Blob(as_filecontents)
lul_length = Len(lblob_filecontents)

lb_result = WriteFile(lul_file, lblob_filecontents, &
					lul_length, lul_written, 0)

CloseHandle(lul_file)

Return 0

end function

public function unsignedlong of_readfile (string as_filename, ref string as_filecontents);// -----------------------------------------------------------------------------
// SCRIPT:     u_web_browser.of_ReadFile
//
// PURPOSE:    This function reads a file from disk.
//
// ARGUMENTS:  as_filename			- Name of the file to read
//					as_filecontents	- Contents of the file ( by ref )
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 9/18/2008	RolandS		Initial Coding
// -----------------------------------------------------------------------------

ULong lul_file, lul_bytes, lul_length
Blob lblob_contents
Boolean lb_result
Encoding lEncoding

lul_file = CreateFile(as_filename, GENERIC_READ, &
					FILE_SHARE_READ, 0, OPEN_EXISTING, 0, 0)
If lul_file = INVALID_HANDLE_VALUE Then
	Return -1
End If

lEncoding = of_GetEncoding(as_filename)

lul_length = FileLength(as_filename)
lblob_contents = Blob(Space(lul_length))

lb_result = ReadFile(lul_file, lblob_contents, &
					lul_length, lul_bytes, 0)

lblob_contents = BlobMid(lblob_contents, 1, lul_length)

CloseHandle(lul_file)

as_filecontents = String(lblob_contents, lEncoding)

Return lul_bytes

end function

public subroutine of_execscript (integer as_script);// execute a script within the document
this.Object.Document.ParentWindow.ExecScript(as_script)

end subroutine

public function encoding of_getencoding (string as_filename);// This function determines a blob's string encoding.

Integer li_fnum, li_bom1, li_bom2, li_bom3
Long ll_length, ll_bytes
Blob lblob_contents

li_fnum = FileOpen(as_filename, StreamMode!, Read!, Shared!)
If li_fnum = -1 Then
	Return EncodingAnsi!
End If

ll_length = 3
lblob_contents = Blob(Space(ll_length), EncodingAnsi!)

ll_bytes = FileReadEx(li_fnum, lblob_contents, ll_length)
FileClose(li_fnum)

li_bom1 = AscA(String(BlobMid(lblob_contents, 1, 1), EncodingAnsi!))
li_bom2 = AscA(String(BlobMid(lblob_contents, 2, 1), EncodingAnsi!))
li_bom3 = AscA(String(BlobMid(lblob_contents, 3, 1), EncodingAnsi!))

If li_bom1 = 255 And li_bom2 = 254 Then
	Return EncodingUTF16LE!
Else
	If li_bom1 = 254 And li_bom2 = 255 Then
		Return EncodingUTF16BE!
	Else
		If li_bom1 = 239 And li_bom2 = 187 And li_bom3 = 191 Then
			Return EncodingUTF8!
		End If
	End If
End If

Return EncodingAnsi!

end function

event externalexception;action = ExceptionIgnore!

end event

event error;action = ExceptionIgnore!

end event

on u_web_browser.create
end on

on u_web_browser.destroy
end on


Start of PowerBuilder Binary Data Section : Do NOT Edit
0Cu_web_browser.bin 
2600000a00e011cfd0e11ab1a1000000000000000000000000000000000003003e0009fffe000000060000000000000000000000010000000100000000000010000000000200000001fffffffe0000000000000000fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffdfffffffefffffffefffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff006f00520074006f004500200074006e00790072000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000050016ffffffffffffffff00000001000000000000000000000000000000000000000000000000000000007637b9b001ce0c7a00000003000001800000000000500003004f0042005800430054005300450052004d0041000000000000000000000000000000000000000000000000000000000000000000000000000000000102001affffffff00000002ffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000000000009c00000000004200500043004f00530058004f00540041005200450047000000000000000000000000000000000000000000000000000000000000000000000000000000000001001affffffffffffffff000000038856f96111d0340ac0006ba9a205d74f000000007637b9b001ce0c7a7637b9b001ce0c7a000000000000000000000000004f00430054004e004e00450053005400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001020012ffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000030000009c000000000000000100000002fffffffe0000000400000005fffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
20ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0000004c0000256a00001aaa0000000000000000000000000000000000000000000000000000004c0000000000000000000000010057d0e011cf3573000869ae62122e2b00000008000000000000004c0002140100000000000000c0460000000000008000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004c0000256a00001aaa0000000000000000000000000000000000000000000000000000004c0000000000000000000000010057d0e011cf3573000869ae62122e2b00000008000000000000004c0002140100000000000000c0460000000000008000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1Cu_web_browser.bin 
End of PowerBuilder Binary Data Section : No Source Expected After This Point
