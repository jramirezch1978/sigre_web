$PBExportHeader$u_comctl_monthcal.sru
$PBExportComments$Month Calendar Control
forward
global type u_comctl_monthcal from userobject
end type
type initcommoncontrolsex from structure within u_comctl_monthcal
end type
type systemtime from structure within u_comctl_monthcal
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

global type u_comctl_monthcal from userobject
integer width = 805
integer height = 612
userobjects objecttype = externalvisual!
string classname = "sysmonthcal32"
string libraryname = "comctl32.dll"
long style = 1174405120
end type
global u_comctl_monthcal u_comctl_monthcal

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

// Calendar Messages
CONSTANT ulong MCM_FIRST			= 4096
CONSTANT ulong MCM_GETCURSEL			= MCM_FIRST + 1
CONSTANT ulong MCM_SETCURSEL			= MCM_FIRST + 2
CONSTANT ulong MCM_GETMAXSELCOUNT		= MCM_FIRST + 3
CONSTANT ulong MCM_SETMAXSELCOUNT		= MCM_FIRST + 4
CONSTANT ulong MCM_GETSELRANGE		= MCM_FIRST + 5
CONSTANT ulong MCM_SETSELRANGE		= MCM_FIRST + 6
CONSTANT ulong MCM_GETMONTHRANGE		= MCM_FIRST + 7
CONSTANT ulong MCM_SETDAYSTATE		= MCM_FIRST + 8
CONSTANT ulong MCM_GETMINREQRECT		= MCM_FIRST + 9
CONSTANT ulong MCM_SETCOLOR			= MCM_FIRST + 10
CONSTANT ulong MCM_GETCOLOR			= MCM_FIRST + 11
CONSTANT ulong MCM_SETTODAY			= MCM_FIRST + 12
CONSTANT ulong MCM_GETTODAY			= MCM_FIRST + 13

end variables

forward prototypes
public function date of_get_date ()
public function date of_get_today ()
public subroutine of_set_color (unsignedlong aul_type, unsignedlong aul_color)
public subroutine of_set_date (date ad_date)
public subroutine of_set_today (date ad_date)
public function decimal of_get_minversion ()
end prototypes

public function date of_get_date ();// get the calendar date

SYSTEMTIME lpSysTime
Date ld_date

SendMessageDate(Handle(this), MCM_GETCURSEL, 0, lpSysTime)

// combine parts into date variable
ld_date = Date(lpSysTime.wYear, &
					lpSysTime.wMonth, &
					lpSysTime.wDay)

Return ld_date

end function

public function date of_get_today ();// get the current 'today' date

SYSTEMTIME lpSysTime
Date ld_date

SendMessageDate(Handle(this), MCM_GETTODAY, 0, lpSysTime)

// combine parts into date variable
ld_date = Date(lpSysTime.wYear, &
					lpSysTime.wMonth, &
					lpSysTime.wDay)

Return ld_date

end function

public subroutine of_set_color (unsignedlong aul_type, unsignedlong aul_color);// set the calendar color

SendMessageLong(Handle(this), MCM_SETCOLOR, aul_type, aul_color)

end subroutine

public subroutine of_set_date (date ad_date);// set the calendar date

SYSTEMTIME lpSysTime

lpSysTime.wYear  = Year(ad_date)
lpSysTime.wMonth = Month(ad_date)
lpSysTime.wDay   = Day(ad_date)

SendMessageDate(Handle(this), MCM_SETCURSEL, 0, lpSysTime)

end subroutine

public subroutine of_set_today (date ad_date);// set the current 'today' date

SYSTEMTIME lpSysTime

lpSysTime.wYear  = Year(ad_date)
lpSysTime.wMonth = Month(ad_date)
lpSysTime.wDay   = Day(ad_date)

SendMessageDate(Handle(this), MCM_SETTODAY, 0, lpSysTime)

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

on u_comctl_monthcal.create
end on

on u_comctl_monthcal.destroy
end on

