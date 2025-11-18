$PBExportHeader$u_comctl_datetimepick.sru
$PBExportComments$Date and Time Picker Control
forward
global type u_comctl_datetimepick from userobject
end type
type initcommoncontrolsex from structure within u_comctl_datetimepick
end type
type systemtime from structure within u_comctl_datetimepick
end type
end forward

type initcommoncontrolsex from structure
	unsignedlong		dwsize
	unsignedlong		dwicc
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

global type u_comctl_datetimepick from userobject
integer width = 384
integer height = 100
userobjects objecttype = externalvisual!
string classname = "sysdatetimepick32"
string libraryname = "comctl32.dll"
long style = 1174405120
end type
global u_comctl_datetimepick u_comctl_datetimepick

type prototypes
Function boolean InitCommonControlsEx( &
	INITCOMMONCONTROLSEX lpInitCtrls &
	) Library "comctl32.dll" alias for "InitCommonControlsEx;Ansi"

Function ulong SendMessageDate(&
	ulong hWnd, &
	ulong Msg, &
	ulong wParam, &
	Ref SYSTEMTIME lpSysTime ) &
	Library "user32.dll" alias for "SendMessageA;Ansi"

Function ulong SendMessageLong(&
	ulong hWnd, &
	ulong Msg, &
	ulong wParam, &
	long lParam ) &
	Library "user32.dll" alias for "SendMessageA"

Function ulong SendMessageString(&
	ulong hWnd, &
	ulong Msg, &
	ulong wParam, &
	Ref string lpszFormat ) &
	Library "user32.dll" alias for "SendMessageA;Ansi"

end prototypes

type variables
Public:

// Color Regions
CONSTANT ulong MCSC_BACKGROUND	= 0	// background color (between months)
CONSTANT ulong MCSC_TEXT		= 1	// dates within a month
CONSTANT ulong MCSC_TITLEBK		= 2	// background of the title
CONSTANT ulong MCSC_TITLETEXT		= 3	// text within the calendar's title
CONSTANT ulong MCSC_MONTHBK		= 4	// background of a month
CONSTANT ulong MCSC_TRAILINGTEXT	= 5	// text color of header & trailing days

Private:

// default style
CONSTANT ulong DEFAULT_STYLE = 1174405120

// Calendar Messages
CONSTANT ulong DTM_FIRST		= 4096
CONSTANT ulong DTM_GETSYSTEMTIME	= DTM_FIRST + 1
CONSTANT ulong DTM_SETSYSTEMTIME	= DTM_FIRST + 2
CONSTANT ulong DTM_GETRANGE		= DTM_FIRST + 3
CONSTANT ulong DTM_SETRANGE		= DTM_FIRST + 4
CONSTANT ulong DTM_SETFORMAT		= DTM_FIRST + 5
CONSTANT ulong DTM_SETMCCOLOR	= DTM_FIRST + 6
CONSTANT ulong DTM_GETMCCOLOR	= DTM_FIRST + 7

end variables

forward prototypes
public function date of_get_date ()
public subroutine of_set_date (date ad_date)
public subroutine of_set_format (string as_format)
public subroutine of_set_style (integer ai_style, boolean ab_resize)
public function decimal of_get_minversion ()
end prototypes

public function date of_get_date ();// get the calendar date

SYSTEMTIME lpSysTime
Date ld_date

SendMessageDate(Handle(this), DTM_GETSYSTEMTIME, 0, lpSysTime)

// combine parts into date variable
ld_date = Date(lpSysTime.wYear, &
					lpSysTime.wMonth, &
					lpSysTime.wDay)

Return ld_date

end function

public subroutine of_set_date (date ad_date);// set the calendar date

SYSTEMTIME lpSysTime

lpSysTime.wYear  = Year(ad_date)
lpSysTime.wMonth = Month(ad_date)
lpSysTime.wDay   = Day(ad_date)

SendMessageDate(Handle(this), DTM_SETSYSTEMTIME, 0, lpSysTime)

end subroutine

public subroutine of_set_format (string as_format);// set format string for date display

// Format String values:
//
//	"d"		The one- or two-digit day. 
//	"dd"		The two-digit day. Single-digit day values are preceded by a zero. 
//	"ddd"		The three-character weekday abbreviation. 
//	"dddd"	The full weekday name. 
//	"h"		The one- or two-digit hour in 12-hour format. 
//	"hh"		The two-digit hour in 12-hour format. Single-digit values are preceded by a zero. 
//	"H"		The one- or two-digit hour in 24-hour format. 
//	"HH"		The two-digit hour in 24-hour format. Single-digit values are preceded by a zero. 
//	"m"		The one- or two-digit minute. 
//	"mm"		The two-digit minute. Single-digit values are preceded by a zero. 
//	"M"		The one- or two-digit month number. 
//	"MM"		The two-digit month number. Single-digit values are preceded by a zero. 
//	"MMM"		The three-character month abbreviation. 
//	"MMMM"	The full month name. 
//	"t"		The one-letter AM/PM abbreviation (that is, AM is displayed as "A"). 
//	"tt"		The two-letter AM/PM abbreviation (that is, AM is displayed as "AM"). 
//	"yy"		The last two digits of the year (that is, 1996 would be displayed as "96"). 
//	"yyyy"	The full year (that is, 1996 would be displayed as "1996"). 

SendMessageString(Handle(this), DTM_SETFORMAT, 0, as_format)

end subroutine

public subroutine of_set_style (integer ai_style, boolean ab_resize);// Styles:
// 0 - Default (dropdown arrow)
// 1 - Up/Down 'spinbox'
// 2 - Dropdown with checkbox
// 4 - Long Date format
// 9 - Time format

// update the control style
this.Style = DEFAULT_STYLE + ai_style

// resize control
If ab_resize Then
	choose case ai_style
		case 2
			this.width = 443
		case 4
			this.width = 846
		case 9
			this.width = 407
		case else
			this.width = 370
	end choose
End If

end subroutine

public function decimal of_get_minversion ();// returns the minimum version of comctl32.dll
// which supports this common control

Return 4.70

end function

event constructor;INITCOMMONCONTROLSEX lpInitCtrls
CONSTANT ulong ICC_DATE_CLASSES = 256

lpInitCtrls.dwSize = 8
lpInitCtrls.dwICC  = ICC_DATE_CLASSES

// initialize control
InitCommonControlsEx(lpInitCtrls)

end event

on u_comctl_datetimepick.create
end on

on u_comctl_datetimepick.destroy
end on

