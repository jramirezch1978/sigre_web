$PBExportHeader$n_application.sru
forward
global type n_application from nonvisualobject
end type
end forward

global type n_application from nonvisualobject autoinstantiate
end type

type prototypes
Function boolean ShowWindow ( &
	Long handle, &
	Integer ncmdshow &
	) Library "user32.dll"

Function integer GetSystemMetrics ( &
	integer nIndex &
	) Library "user32.dll"

end prototypes

type variables
Date ld_compiled = Today()
String is_company = "Topwiz"
String is_version = "1.4"

end variables

forward prototypes
public function string of_replaceall (string as_oldstring, string as_findstr, string as_replace)
public function integer of_setreg (string as_subkey, string as_entry, string as_value)
public function integer of_setreg (string as_entry, string as_value)
public function string of_getreg (string as_subkey, string as_entry, string as_default)
public function string of_getreg (string as_entry, string as_default)
public function string of_getappname ()
public subroutine of_showwindow (ref window aw_window, windowstate ae_state)
public function integer of_titlebaroffset ()
public function string of_getcompany ()
public function long of_parse (string as_string, string as_separator, ref string as_outarray[])
end prototypes

public function string of_replaceall (string as_oldstring, string as_findstr, string as_replace);// -----------------------------------------------------------------------------
// SCRIPT:     n_application.of_ReplaceAll
//
// PURPOSE:    This function all of the occurrences of a string within
//					another string.
//
// ARGUMENTS:  as_oldstring	- The string to be updated
//					as_findstr		- The string to look for
//					as_replace		- The replacement string
//
//	RETURN:		The updated string
//
// DATE        CHANGED BY	DESCRIPTION OF CHANGE / REASON
// ----------  ----------  -----------------------------------------------------
// 02/17/2010  RolandS		Initial creation
// -----------------------------------------------------------------------------

String ls_newstring
Long ll_findstr, ll_replace, ll_pos

// get length of strings
ll_findstr = Len(as_findstr)
ll_replace = Len(as_replace)

// find first occurrence
ls_newstring = as_oldstring
ll_pos = Pos(ls_newstring, as_findstr)

Do While ll_pos > 0
	// replace old with new
	ls_newstring = Replace(ls_newstring, ll_pos, ll_findstr, as_replace)
	// find next occurrence
	ll_pos = Pos(ls_newstring, as_findstr, (ll_pos + ll_replace))
Loop

Return ls_newstring

end function

public function integer of_setreg (string as_subkey, string as_entry, string as_value);// -----------------------------------------------------------------------------
// SCRIPT:     n_application.of_SetReg
//
// PURPOSE:    This function sets parameters in the registry.
//
// ARGUMENTS:  as_subkey	- Optional subkey
//					as_entry		- Entry name
//					as_value		- Value to be stored
//
//	RETURN:		Result of RegistrySet
//
// DATE        CHANGED BY	DESCRIPTION OF CHANGE / REASON
// ----------  ----------  -----------------------------------------------------
// 02/17/2010  RolandS		Initial creation
// -----------------------------------------------------------------------------

String ls_regkey

// build registry key name
ls_regkey  = "HKEY_CURRENT_USER\Software\"
ls_regkey += is_company + "\" + of_GetAppName()
If Len(as_subkey) > 0 Then
	ls_regkey += "\" + as_subkey
End If

// set value in initialization source
Return RegistrySet(ls_regkey, as_entry, as_value)

end function

public function integer of_setreg (string as_entry, string as_value);// -----------------------------------------------------------------------------
// SCRIPT:     n_application.of_SetReg
//
// PURPOSE:    This function sets parameters in the registry.
//
// ARGUMENTS:  as_entry		- Entry name
//					as_value		- Value to be stored
//
//	RETURN:		Result of RegistrySet
//
// DATE        CHANGED BY	DESCRIPTION OF CHANGE / REASON
// ----------  ----------  -----------------------------------------------------
// 02/17/2010  RolandS		Initial creation
// -----------------------------------------------------------------------------

Return this.of_SetReg("", as_entry, as_value)

end function

public function string of_getreg (string as_subkey, string as_entry, string as_default);// -----------------------------------------------------------------------------
// SCRIPT:     n_application.of_SetReg
//
// PURPOSE:    This function gets parameters from the registry.
//
// ARGUMENTS:  as_subkey	- Optional subkey
//					as_entry		- Entry name
//					as_value		- Default value if none found
//
//	RETURN:		The value stored in the registry.
//
// DATE        CHANGED BY	DESCRIPTION OF CHANGE / REASON
// ----------  ----------  -----------------------------------------------------
// 02/17/2010  RolandS		Initial creation
// -----------------------------------------------------------------------------

String ls_regkey, ls_regvalue

// build registry key name
ls_regkey  = "HKEY_CURRENT_USER\Software\"
ls_regkey += is_company + "\" + of_GetAppName()
If Len(as_subkey) > 0 Then
	ls_regkey += "\" + as_subkey
End If

// get value from initialization source
RegistryGet(ls_regkey, as_entry, ls_regvalue)
If ls_regvalue = "" Then
	ls_regvalue = as_default
End If

Return ls_regvalue

end function

public function string of_getreg (string as_entry, string as_default);// -----------------------------------------------------------------------------
// SCRIPT:     n_application.of_SetReg
//
// PURPOSE:    This function gets parameters from the registry.
//
// ARGUMENTS:  as_entry		- Entry name
//					as_value		- Default value if none found
//
//	RETURN:		The value stored in the registry.
//
// DATE        CHANGED BY	DESCRIPTION OF CHANGE / REASON
// ----------  ----------  -----------------------------------------------------
// 02/17/2010  RolandS		Initial creation
// -----------------------------------------------------------------------------

Return this.of_GetReg("", as_entry, as_default)

end function

public function string of_getappname ();// -----------------------------------------------------------------------------
// SCRIPT:     n_application.of_GetAppName
//
// PURPOSE:    This function returns the application name.
//
// RETURN:     Applicaton name.
//
// DATE        CHANGED BY	DESCRIPTION OF CHANGE / REASON
// ----------  ----------  -----------------------------------------------------
// 12/05/2006  Roland S		Initial creation
// -----------------------------------------------------------------------------

String ls_appname
Application la_app

la_app = GetApplication()
If la_app.DisplayName = "" Then
	ls_appname = WordCap(la_app.AppName)
Else
	ls_appname = WordCap(la_app.DisplayName)
End If

Return ls_appname

end function

public subroutine of_showwindow (ref window aw_window, windowstate ae_state);// this function sets the windowstate

Integer li_cmdshow

CHOOSE CASE ae_state
	CASE Maximized!
		li_cmdshow = 3
	CASE Minimized!
		li_cmdshow = 2
	CASE Normal!
		li_cmdshow = 1
END CHOOSE

ShowWindow(Handle(aw_window), li_cmdshow)

aw_window.SetFocus()

end subroutine

public function integer of_titlebaroffset ();// -----------------------------------------------------------------------------
// FUNCTION:	n_application.of_TitlebarOffset
//
// PURPOSE:		This function returns the difference between the current
//					titlebar size and the standard 'Windows Classic' size.
//
// RETURN:		Offset ( difference )
//
// DATE			PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------	--------		-----------------------------------------------------
// 06/25/2008	RolandS		Initial coding
// -----------------------------------------------------------------------------

CONSTANT Integer SM_CYCAPTION = 4
Integer li_pixels, li_pbunits, li_offset

li_pixels = GetSystemMetrics(SM_CYCAPTION)
li_pbunits = PixelsToUnits(li_pixels, YPixelsToUnits!)

li_offset = li_pbunits - 76

Return li_offset

end function

public function string of_getcompany ();// -----------------------------------------------------------------------------
// SCRIPT:     n_application.of_GetCompany
//
// PURPOSE:    This function returns the company name.
//
// RETURN:     Company name.
//
// DATE        CHANGED BY	DESCRIPTION OF CHANGE / REASON
// ----------  ----------  -----------------------------------------------------
// 12/05/2006  Roland S		Initial creation
// -----------------------------------------------------------------------------

Return is_company

end function

public function long of_parse (string as_string, string as_separator, ref string as_outarray[]);// -----------------------------------------------------------------------------
// SCRIPT:     n_application.of_Parse
//
// PURPOSE:    This function parses a string into an array.
//
// ARGUMENTS:  as_string		- The string to be separated
//					as_separate		- The separator characters
//					as_outarray		- By ref output array
//
//	RETURN:		The number of items in the array
//
// DATE        CHANGED BY	DESCRIPTION OF CHANGE / REASON
// ----------  ----------  -----------------------------------------------------
// 03/17/2012	RolandS		Rewritten based on an example by Mike Bartos
// -----------------------------------------------------------------------------

Long ll_PosEnd, ll_PosStart = 1, ll_SeparatorLen, ll_Counter = 1

If UpperBound(as_OutArray) > 0 Then as_OutArray = {""}

ll_SeparatorLen = Len(as_Separator)

ll_PosEnd = Pos(as_String, as_Separator, 1)

Do While ll_PosEnd > 0
	as_OutArray[ll_Counter] = Mid(as_String, ll_PosStart, ll_PosEnd - ll_PosStart)
	ll_PosStart = ll_PosEnd + ll_SeparatorLen
	ll_PosEnd = Pos(as_String, as_Separator, ll_PosStart)
	ll_Counter++
Loop

as_OutArray[ll_Counter] = Right(as_String, Len(as_String) - ll_PosStart + 1)

Return ll_Counter

end function

on n_application.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_application.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

