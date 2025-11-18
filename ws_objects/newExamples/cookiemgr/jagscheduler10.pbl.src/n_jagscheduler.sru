$PBExportHeader$n_jagscheduler.sru
$PBExportComments$Cookie Manager service component
forward
global type n_jagscheduler from nonvisualobject
end type
end forward

global type n_jagscheduler from nonvisualobject
event activate pbm_component_activate
event deactivate pbm_component_deactivate
end type
global n_jagscheduler n_jagscheduler

type prototypes

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

end variables

forward prototypes
private function string of_createinstanceerror (long al_rc)
private function string of_getjagproperty (string as_property)
private subroutine of_log (integer ai_type, string as_msg)
public subroutine stop ()
public subroutine run ()
public subroutine start ()
public subroutine of_schedule (string as_package, string as_component, integer ai_interval)
public function long of_parse (string as_text, string as_sep, ref string as_array[])
end prototypes

private function string of_createinstanceerror (long al_rc);// -----------------------------------------------------------------------------
// SCRIPT:     n_jagscheduler.of_CreateInstanceError
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
// SCRIPT:     n_jagscheduler.of_GetJagProperty
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

ls_property = "com.topwiz.jagscheduler." + as_property

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
// SCRIPT:     n_jagscheduler.of_Log
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

public subroutine stop ();// -----------------------------------------------------------------------------
// SCRIPT:     n_jagscheduler.Stop
//
// PURPOSE:    This is the service stop function.
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

Return

end subroutine

public subroutine run ();// -----------------------------------------------------------------------------
// SCRIPT:     n_jagscheduler.Run
//
// PURPOSE:    This is the service run function. It gets the schedule property
//					and parses out the jobs. It then schedules each job.
//
// DATE        CHANGED BY	DESCRIPTION OF CHANGE / REASON
// ----------  ----------  -----------------------------------------------------
// 04/01/2007	RolandS		Initial coding
// -----------------------------------------------------------------------------

String ls_value, ls_jobs[], ls_parts[]
String ls_package, ls_component
Long ll_row, ll_max, ll_cnt
Integer li_seconds

// get the list of components to run
ls_value = Trim(this.of_GetJagProperty("jobs"))

// parse out components into array
ll_max = this.of_Parse(ls_value, ",", ls_jobs)
For ll_row = 1 To ll_max
	// parse out package/component/seconds
	ll_cnt = this.of_Parse(ls_jobs[ll_row], "/", ls_parts)
	If ll_cnt = 3 Then
		ls_package   = ls_parts[1]
		ls_component = ls_parts[2]
		li_seconds   = Integer(ls_parts[3])
		// schedule the component
		of_Schedule(ls_package, ls_component, li_seconds)
	Else
		this.of_log(iERROR, &
			"Job not correctly formatted: " + ls_jobs[ll_row])
	End If
Next

Return

end subroutine

public subroutine start ();// -----------------------------------------------------------------------------
// SCRIPT:     n_jagscheduler.Start
//
// PURPOSE:    This is the service start function.
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

Return

end subroutine

public subroutine of_schedule (string as_package, string as_component, integer ai_interval);// -----------------------------------------------------------------------------
// SCRIPT:     n_jagscheduler.of_Schedule
//
// PURPOSE:    This function adds a component to the schedule.
//
// ARGUMENTS:  as_package		- The package that the component is in
//					as_component	- The name of the component
//					ai_interval		- The number of seconds between execution
//											or -1 for onetime
//
//	RETURN:		None
//
// DATE        CHANGED BY	DESCRIPTION OF CHANGE / REASON
// ----------  ----------  -----------------------------------------------------
// 04/01/2007	RolandS		Initial coding
// -----------------------------------------------------------------------------

GenericService l_gs
ThreadManager l_tm
String ls_errmsg, ls_group
Long ll_rc

// instantiate the passed component
ll_rc = i_ts.CreateInstance(l_gs, as_package + "/" + as_component)
If ll_rc <> 0 Then
	ls_errmsg = this.of_CreateInstanceError(ll_rc)
	this.of_log(iERROR, as_component + " CreateInstance failed: " + ls_errmsg)
	Return
End If

// instantiate ThreadManager
ll_rc = i_ts.CreateInstance(l_tm, "CtsComponents/ThreadManager")
If ll_rc <> 0 Then
	ls_errmsg = this.of_CreateInstanceError(ll_rc)
	this.of_log(iERROR, "ThreadManager CreateInstance failed: " + ls_errmsg)
	Return
End If

// set thread group name
ls_group = "com." + as_package + "." + as_component

// set thread count
l_tm.SetThreadCount(ls_group, 1)

If ai_interval = 0 Then
	// component will run only once
	l_tm.SetRunInterval(ls_group, -1)
Else
	// component will run once every x seconds
	l_tm.SetRunInterval(ls_group, ai_interval)
End If

// start the component
l_tm.Start(ls_group, l_gs)

this.of_log(iINFO, as_component + " Scheduled!")

Return

end subroutine

public function long of_parse (string as_text, string as_sep, ref string as_array[]);// -----------------------------------------------------------------------------
// SCRIPT:     n_jagscheduler.of_Parse
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

on n_jagscheduler.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_jagscheduler.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

