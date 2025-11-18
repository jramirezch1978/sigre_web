$PBExportHeader$n_cookiemgr.sru
$PBExportComments$Cookie Manager service component
forward
global type n_cookiemgr from nonvisualobject
end type
type filetime from structure within n_cookiemgr
end type
type win32_find_data from structure within n_cookiemgr
end type
end forward

type filetime from structure
	unsignedlong		dwlowdatetime
	unsignedlong		dwhighdatetime
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

global type n_cookiemgr from nonvisualobject
event activate pbm_component_activate
event deactivate pbm_component_deactivate
end type
global n_cookiemgr n_cookiemgr

type prototypes
Protected:
Function long FindFirstFile ( &
	Ref string filename, &
	Ref win32_find_data findfiledata &
	) Library "kernel32.dll" Alias For "FindFirstFileW"

Function boolean FindNextFile ( &
	ulong handle, &
	Ref win32_find_data findfiledata &
	) Library "kernel32.dll" Alias For "FindNextFileW"

Function boolean FindClose ( &
	ulong handle &
	) Library "kernel32.dll" Alias For "FindClose"

end prototypes

type variables
Protected:
TransactionServer i_ts
ErrorLogging i_el
String is_debug
Constant Integer iERROR   = 1
Constant Integer iWARNING = 2
Constant Integer iINFO    = 3
Constant Integer iDEBUG   = 4
String is_jagdirectory
Integer ii_cookies

end variables

forward prototypes
private function string of_createinstanceerror (long al_rc)
private function string of_getjagproperty (string as_property)
private subroutine of_log (integer ai_type, string as_msg)
public subroutine run ()
public function long of_parse (string as_text, string as_sep, ref string as_array[])
private function string of_getjagproperty (string as_component, string as_property)
private function integer of_clean_component (string as_package, string as_component, string as_cookie)
end prototypes

private function string of_createinstanceerror (long al_rc);// -----------------------------------------------------------------------------
// SCRIPT:     n_cookiemgr.of_CreateInstanceError
//
// PURPOSE:    This function returns the error text of an createinstance error.
//
// ARGUMENTS:  al_rc	- The error code
//
//	RETURN:		The error message
//
// DATE        CHANGED BY	DESCRIPTION OF CHANGE / REASON
// ----------  ----------  -----------------------------------------------------
// 04/01/2007	RolandS		Initial coding
// -----------------------------------------------------------------------------

String ls_msg

CHOOSE CASE al_rc
	CASE 50
		ls_msg = "Distributed service error"
	CASE 52
		ls_msg = "Distributed communications error"
	CASE 53
		ls_msg = "Requested server not active"
	CASE 54
		ls_msg = "Server not accepting requests"
	CASE 55
		ls_msg = "Request terminated abnormally"
	CASE 56
		ls_msg = "Response to request incomplete"
	CASE 57
		ls_msg = "Not connected"
	CASE 62
		ls_msg = "Server busy"
END CHOOSE

Return ls_msg

end function

private function string of_getjagproperty (string as_property);// -----------------------------------------------------------------------------
// SCRIPT:     n_cookiemgr.of_GetJagProperty
//
// PURPOSE:    This function returns a property for the current component.
//
// ARGUMENTS:  as_property	- The name of the property
//
//	RETURN:		The value of the property
//
// DATE        CHANGED BY	DESCRIPTION OF CHANGE / REASON
// ----------  ----------  -----------------------------------------------------
// 04/01/2007	RolandS		Initial coding
// -----------------------------------------------------------------------------

ContextKeyword l_ckw
String ls_values[], ls_property, ls_propvalue
Integer li_rc

GetContextService("keyword", l_ckw)

ls_property = "com.topwiz.cookiemgr." + as_property

li_rc = l_ckw.GetContextKeywords(ls_property, ls_values)

Choose Case li_rc
	Case Is > 0
		ls_propvalue = ls_values[1]
	Case Else
		ls_propvalue = ""
End Choose

Return ls_propvalue

end function

private subroutine of_log (integer ai_type, string as_msg);// -----------------------------------------------------------------------------
// SCRIPT:     n_cookiemgr.of_Log
//
// PURPOSE:    This function writes a message to the server log.
//
// ARGUMENTS:  ai_type	- The importance level of the message
//					as_msg	- The text of the message
//
//	RETURN:		None
//
// DATE        CHANGED BY	DESCRIPTION OF CHANGE / REASON
// ----------  ----------  -----------------------------------------------------
// 04/01/2007	RolandS		Initial coding
// -----------------------------------------------------------------------------

String ls_msg

choose case ai_type
	case iERROR
		ls_msg = "Error: "
	case iWARNING
		ls_msg = "Warning: "
	case iINFO
		ls_msg = "Info: "
	case iDEBUG
		If is_debug = "false" Then Return
		ls_msg = "Debug: "
	case else
		ls_msg = "Unknown " + String(ai_type) + ": "
end choose

ls_msg += this.ClassName() + " - " + as_msg

If IsValid(i_el) Then
	i_el.Log(ls_msg)
End If

end subroutine

public subroutine run ();// -----------------------------------------------------------------------------
// SCRIPT:     n_cookiemgr.Run
//
// PURPOSE:    This function is called by ThreadManager based on the
//					scheduled interval.
//
// DATE        CHANGED BY	DESCRIPTION OF CHANGE / REASON
// ----------  ----------  -----------------------------------------------------
// 04/01/2007	RolandS		Initial coding
// -----------------------------------------------------------------------------

Repository l_repository
Properties l_properties
Management l_management
View l_components
Long ll_rc, ll_pkg, ll_pkgmax, ll_cmp, ll_cmpmax, ll_count
String ls_component, ls_type, ls_cookie, ls_server
String ls_errmsg, ls_list, ls_packages[]

// create management component
ll_rc = i_ts.CreateInstance(l_management, "Jaguar/Management")
If ll_rc <> 0 Then
	ls_errmsg = this.of_CreateInstanceError(ll_rc)
	this.of_log(iERROR, "Management CreateInstance failed: " + ls_errmsg)
	Return
End If

// create repository component
ll_rc = i_ts.CreateInstance(l_repository, "Jaguar/Repository")
If ll_rc <> 0 Then
	ls_errmsg = this.of_CreateInstanceError(ll_rc)
	this.of_log(iERROR, "Repository CreateInstance failed: " + ls_errmsg)
	Return
End If

// get server name
ls_server = l_management.getServer()
this.of_log(iDEBUG, "Processing Cookies for Server: " + ls_server)

// get directory location
is_jagdirectory = l_management.getenv("JAGUAR")

// get server properties
TRY
	l_properties = l_repository.Lookup("Server", ls_server)
CATCH ( lookuperror lue_prp )
	this.of_log(iERROR, "Property Lookup Error: " + &
				lue_prp.reason + " - " + lue_prp.text)
	Return
END TRY

// find the package list property
ll_pkgmax = UpperBound(l_properties.Item)
FOR ll_pkg = 1 TO ll_pkgmax
	If l_properties.Item[ll_pkg].Name = &
					"com.sybase.jaguar.server.packages" Then
		ls_list = l_properties.Item[ll_pkg].Value
		// return array of installed packages
		of_Parse(ls_list, ",", ls_packages)
	End If
NEXT

// process each installed package
ll_pkgmax = UpperBound(ls_packages)
FOR ll_pkg = 1 TO ll_pkgmax
	// get a view of all components in the package
	TRY
		l_components = l_repository.Items("Component", ls_packages[ll_pkg])
	CATCH ( lookuperror lue_cmp )
		this.of_log(iERROR, "Component Items Error: " + &
					lue_cmp.reason + " - " + lue_cmp.text)
		Return
	END TRY
	// process each component
	ll_cmpmax = UpperBound(l_components.Item)
	FOR ll_cmp = 1 TO ll_cmpmax
		// get package/component name
		ls_component = l_components.Item[ll_cmp].Item[3]
		// only process PowerBuilder components
		ls_type = this.of_getjagproperty(ls_component, &
								"com.sybase.jaguar.component.type")
		If Upper(ls_type) = "PB" Then
			ls_cookie = this.of_getjagproperty(ls_component, &
										"com.sybase.jaguar.component.pb.cookie")
			If IsNumber(ls_cookie) Then
				ls_component = l_components.Item[ll_cmp].Item[2]
				ll_count = ll_count + &
					this.of_clean_component(ls_packages[ll_pkg], ls_component, ls_cookie)
			End If
		End If
	NEXT
NEXT

// log count of components cleaned
If ll_count > 0 Then
	this.of_log(iINFO, "Cookies removed: " + String(ll_count))
End If

Return

end subroutine

public function long of_parse (string as_text, string as_sep, ref string as_array[]);// -----------------------------------------------------------------------------
// SCRIPT:     n_cookiemgr.of_Parse
//
// PURPOSE:    This function parses a string into an array.
//
// ARGUMENTS:  as_text	- The string to be separated
//					as_sep	- The separator characters
//					as_array	- By ref output array
//
//	RETURN:		The number of items in the array
//
// DATE        CHANGED BY	DESCRIPTION OF CHANGE / REASON
// ----------  ----------  -----------------------------------------------------
// 04/01/2007	RolandS		Initial coding
// -----------------------------------------------------------------------------

String ls_empty[], ls_work
Long ll_pos, ll_each

as_array = ls_empty

If IsNull(as_text) Or as_text = "" Then Return 0

ll_pos = Pos(as_text, as_sep)
DO WHILE ll_pos > 0
	ls_work = Trim(Left(as_text, ll_pos - 1))
	as_text = Trim(Mid(as_text, ll_pos + 1))
	as_array[UpperBound(as_array) + 1] = ls_work
	ll_pos = Pos(as_text, as_sep)
LOOP
as_array[UpperBound(as_array) + 1] = Trim(as_text)

Return UpperBound(as_array)

end function

private function string of_getjagproperty (string as_component, string as_property);// -----------------------------------------------------------------------------
// SCRIPT:     n_cookiemgr.of_GetJagProperty
//
// PURPOSE:    This function returns a property for any component.
//
// ARGUMENTS:  as_component	- The name of the component
//					as_property		- The name of the property
//
//	RETURN:		The value of the property
//
// DATE        CHANGED BY	DESCRIPTION OF CHANGE / REASON
// ----------  ----------  -----------------------------------------------------
// 04/01/2007	RolandS		Initial coding
// -----------------------------------------------------------------------------

Repository l_repository
Properties l_properties
String ls_value, ls_errmsg
Long ll_rc, ll_cnt, ll_max

// create repository component
ll_rc = i_ts.CreateInstance(l_repository, "Jaguar/Repository")
If ll_rc = 0 Then
	// get all properties for the component
	TRY
		l_properties = l_repository.Lookup("Component", as_component)
	CATCH ( lookuperror lue_prp )
		this.of_log(iERROR, "Lookup Error: " + lue_prp.reason + " - " + lue_prp.text)
		Return ""
	END TRY
	// find the requested property
	ll_max = UpperBound(l_properties.Item)
	FOR ll_cnt = 1 TO ll_max
		If Lower(l_properties.Item[ll_cnt].Name) = Lower(as_property) Then
			ls_value = l_properties.Item[ll_cnt].Value
		End If
	NEXT
Else
	ls_errmsg = this.of_CreateInstanceError(ll_rc)
	this.of_log(iERROR, "Repository CreateInstance failed: " + ls_errmsg)
	Return ""
End If

Return ls_value

end function

private function integer of_clean_component (string as_package, string as_component, string as_cookie);// -----------------------------------------------------------------------------
// SCRIPT:     n_cookiemgr.of_Clean_Component
//
// PURPOSE:    This function removes unused cookie files
//
// ARGUMENTS:  as_package		- The name of the package
//					as_component	- The name of the component
//					as_cookie		- The current cookie
//
//	RETURN:		The value of the property
//
// DATE        CHANGED BY	DESCRIPTION OF CHANGE / REASON
// ----------  ----------  -----------------------------------------------------
// 04/01/2007	RolandS		Initial coding
// -----------------------------------------------------------------------------

Boolean lb_found1, lb_found2
Integer li_count, li_cookie, li_from, li_thru
Long ll_handle1, ll_handle2
String ls_dirname, ls_filespec, ls_filename, ls_cookiedir
WIN32_FIND_DATA lstr_FD1, lstr_FD2

// set the range to keep
li_thru = Integer(as_cookie)
li_from = (li_thru - ii_cookies) + 1

// build component directory
ls_dirname  = is_jagdirectory + "\Repository\Component\"
ls_dirname += as_package + "\" + as_component

// find first file
ls_filespec = ls_dirname + "\C*.*"
ll_Handle1 = FindFirstFile(ls_filespec, lstr_FD1)
If ll_handle1 > 0 Then
	Do
		ls_filename = Trim(String(lstr_FD1.cfilename))
		li_cookie = Integer(Mid(ls_filename, 2))
		// check to see if in range
		If li_cookie < li_from Or &
			li_cookie > li_thru Then
			// build component cookie directory
			ls_cookiedir = as_package + "\" + as_component + "\" + ls_filename
			ls_dirname  = is_jagdirectory + "\Repository\Component\" + ls_cookiedir
			// find first file
			ls_filespec = ls_dirname + "\*.*"
			ll_Handle2 = FindFirstFile(ls_filespec, lstr_FD2)
			If ll_handle2 > 0 Then
				Do
					ls_filename = String(lstr_FD2.cfilename)
					If ls_filename = "." Or ls_filename = ".." Then
					Else
						// delete the file
						FileDelete(ls_dirname + "\" + ls_filename)
					End If
					// find next file
					lb_Found2 = FindNextFile(ll_Handle2, lstr_FD2)
				Loop Until Not lb_Found2
			End If
			// close find handle
			FindClose(ll_Handle2)
			// remove directory
			RemoveDirectory(ls_dirname)
			li_count = li_count + 1
			this.of_log(iINFO, "Cookie removed: " + ls_cookiedir)
		End If
		// find next file
		lb_Found1 = FindNextFile(ll_Handle1, lstr_FD1)
	Loop Until Not lb_Found1
End If

// close find handle
FindClose(ll_Handle1)

Return li_count

end function

on n_cookiemgr.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cookiemgr.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;// -----------------------------------------------------------------------------
// SCRIPT:     n_cookiemgr.Constructor
//
// PURPOSE:    Initialize the component.
//
// DATE        CHANGED BY	DESCRIPTION OF CHANGE / REASON
// ----------  ----------  -----------------------------------------------------
// 04/01/2007	RolandS		Initial coding
// -----------------------------------------------------------------------------

String ls_value

// get reference to transaction service
GetContextService("TransactionServer", i_ts)

// get reference to error logging service
GetContextService("ErrorLogging", i_el)

// get debug option
ls_value = Trim(this.of_GetJagProperty("debug"))
If IsNull(ls_value) Or ls_value = "" Then
	is_debug = "true"
Else
	is_debug = Lower(ls_value)
End If

// get number of cookies to keep
ls_value = this.of_getjagproperty("cookies")
If IsNumber(ls_value) Then
	ii_cookies = Integer(ls_value)
Else
	ii_cookies = 1
End If

end event

event destructor;// -----------------------------------------------------------------------------
// SCRIPT:     n_cookiemgr.Destructor
//
// PURPOSE:    Perform cleanup for the component.
//
// DATE        CHANGED BY	DESCRIPTION OF CHANGE / REASON
// ----------  ----------  -----------------------------------------------------
// 04/01/2007	RolandS		Initial coding
// -----------------------------------------------------------------------------

// destroy transaction service
If IsValid(i_ts) Then
	DESTROY i_ts
End If

// destroy error logging service
If IsValid(i_el) Then
	DESTROY i_el
End If

end event

