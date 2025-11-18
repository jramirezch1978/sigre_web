$PBExportHeader$n_cst_tooltiptext.sru
$PBExportComments$Non-Visual tooltip control object
forward
global type n_cst_tooltiptext from nonvisualobject
end type
type rect from structure within n_cst_tooltiptext
end type
type toolinfo from structure within n_cst_tooltiptext
end type
type point from structure within n_cst_tooltiptext
end type
type msg from structure within n_cst_tooltiptext
end type
end forward

type rect from structure
	long		left
	long		top
	long		right
	long		bottom
end type

type toolinfo from structure
	long		cbsize
	long		uflags
	long		hwnd
	long		uid
	RECT		rect
	long		hinstance
	long		lpsztext
end type

type point from structure
	long		x
	long		y
end type

type msg from structure
	long		hwnd
	long		message
	long		wparam
	long		lparam
	long		time
	point		pt
end type

global type n_cst_tooltiptext from nonvisualobject autoinstantiate
end type

type prototypes
// ToolTip Functions
SubRoutine InitCommonControls() library "comctl32.dll"
Function long CreateWindowExA(ulong dwExStyle, string ClassName, long WindowName, ulong dwStyle, ulong X, ulong Y, ulong nWidth, ulong nHeight, ulong hWndParent, ulong hMenu, ulong hInstance, ulong lpParam) library "user32.dll" alias for "CreateWindowExA;Ansi"
Function integer DestroyWindow(long hWnd) library "user32.dll"
Function integer ToolTipMsg(long hWnd, long uMsg, long wParam, REF TOOLINFO ToolInfo) library "user32.dll" Alias For "SendMessageA;Ansi"
Function integer RelayMsg(long hWnd, long uMsg, long wParam, REF MSG Msg) library "user32.dll" Alias For "SendMessageA;Ansi"

// Memory handling functions
Function long LocalAlloc(long Flags, long Bytes) library "kernel32.dll"
Function long LocalFree(long MemHandle) library "kernel32.dll"
Function long lstrcpy(long Destination, string Source) library "kernel32.dll" alias for "lstrcpy;Ansi"


end prototypes

type variables
Private:

// Misc Constants
CONSTANT string TOOLTIPS_CLASS		= 'tooltips_class32'
CONSTANT ulong CW_USEDEFAULT		= 2147483648
CONSTANT long WM_USER 		= 1024
CONSTANT long WS_EX_TOPMOST		= 8
CONSTANT long  WM_SETFONT          	= 48

// ToolTip Messages
CONSTANT long TTM_ADDTOOL 		= WM_USER + 4
CONSTANT long TTM_NEWTOOLRECT	= WM_USER + 6
CONSTANT long TTM_RELAYEVENT 		= WM_USER + 7
CONSTANT long TTM_UPDATETIPTEXT	= WM_USER + 12
CONSTANT long TTM_TRACKACTIVATE	= WM_USER + 17
CONSTANT long TTM_TRACKPOSITION	= WM_USER + 18

// Public variables and constants
Public:
long hWndTT	// Tooltip control window handle
long ToolID = 1	// Tooltip internal ID

// Tooltip flags
CONSTANT integer TTF_CENTERTIP 		= 2
CONSTANT integer TTF_RTLREADING	= 4
CONSTANT integer TTF_SUBCLASS		= 16
CONSTANT integer TTF_TRACK		= 32
CONSTANT integer TTF_ABSOLUTE		= 128
CONSTANT integer TTF_TRANSPARENT	= 256
CONSTANT integer TTF_DI_SETITEM		= 32768
end variables

forward prototypes
public subroutine relaymsg (dragobject object)
public subroutine settiptext (dragobject object, long uid, long tiptext)
public subroutine settiptext (dragobject object, long uid, string tiptext)
public subroutine updatetiprect (dragobject object, long uid, long left, long top, long right, long bottom)
public function integer addtool (dragobject object, string tiptext, integer flags)
public subroutine settrack (dragobject object, integer uID, boolean Status)
public subroutine settipposition (integer x, integer y)
public subroutine setfont (long hfont)
end prototypes

public subroutine relaymsg (dragobject object);// This function will send the control message to the toolwindow control
MSG Msg

Msg.hWnd		= Handle(Object)
Msg.Message	= 512	// WM_MOUSEMOVE
Msg.WParam 	= Message.WordParm
Msg.LParam 	= Message.LongParm

RelayMsg(hWndTT,TTM_RELAYEVENT,0,Msg)

end subroutine

public subroutine settiptext (dragobject object, long uid, long tiptext);// Sets the new text for a tool window
//
// Arguments:
//				object	: Object registered on the toolwindow control
//				uID	 	: Object ID
//				text		: Tooltip text
TOOLINFO ToolInfo

ToolInfo.hWnd		= Handle(Object)
ToolInfo.uID		= uID
ToolInfo.lpszText	= TipText

ToolTipMsg(hWndTT,TTM_UPDATETIPTEXT,0,ToolInfo)
end subroutine

public subroutine settiptext (dragobject object, long uid, string tiptext);// Sets the new text for a tool window
//
// Arguments:
//				object	: Object registered on the toolwindow control
//				uID	 	: Object ID
//				text		: Tooltip text
long lpszText

lpszText = LocalAlloc(0,255)
lStrCpy(lpszText,Left(TipText,255))
SetTipText(Object,uId,lpszText)

LocalFree(lpszText)
end subroutine

public subroutine updatetiprect (dragobject object, long uid, long left, long top, long right, long bottom);// Updates the tip rectangle
//
// Arguments:
//				hWnd		=> Handle of the registered tool
//				uID		=> Internal tool ID
//				Rect		=> New Rectangle
TOOLINFO ToolInfo

ToolInfo.hWnd	= Handle(Object)
ToolInfo.uID	= uID

ToolInfo.Rect.Left	= Left
ToolInfo.Rect.Top		= Top
ToolInfo.Rect.Right	= Right
ToolInfo.Rect.Bottom	= Bottom

ToolTipMsg(hWndTT,TTM_NEWTOOLRECT,0,ToolInfo)

end subroutine

public function integer addtool (dragobject object, string tiptext, integer flags);// Registers a control within the tooltip control
//
// Arguments: 
//				object  	=> Object to register within the tooltip control
//				tiptext	=> Tooltip Text
//				Flags		=> Tool creation flags
TOOLINFO ToolInfo

ToolInfo.cbSize 	= 40
ToolInfo.uFlags 	= Flags 
ToolInfo.hWnd		= Handle(Object)
ToolInfo.hInstance= 0 // Not used 
ToolInfo.uID		= ToolID
ToolID++
ToolInfo.lpszText	= LocalAlloc(0,80)
POST LocalFree(ToolInfo.lpszText) // Free Allocated Memory
lStrCpy(ToolInfo.lpszText,Left(tiptext,80))

ToolInfo.Rect.Left	= 0
ToolInfo.Rect.Top 	= 0
ToolInfo.Rect.Right	= UnitsToPixels(Object.Width,XUnitsToPixels!)
ToolInfo.Rect.Bottom	= UnitsToPixels(Object.Height,YUnitsToPixels!)

If ToolTipMsg(hWndTT,TTM_ADDTOOL, 0, ToolInfo) = 0 Then
	MessageBox("Error","Cannot register object in the toolwindow control!",StopSign!,Ok!)
	Return(-1)
End If

Return(ToolID - 1)

end function

public subroutine settrack (dragobject object, integer uID, boolean Status);// This function (de)activates a tracking tooltip, this kind of tooltip can be reposicioned on
// the screen using the SetTipPosition function... 
//
// Arguments:
//				object	=> Object registered within the tooltip control
//				uID		=> Internal ID of the object
//				Status	=> True to activate tracking, False to deactivate tracking
TOOLINFO ToolInfo

ToolInfo.cbSize	= 40
ToolInfo.hWnd		= Handle(Object)
ToolInfo.uID		= uID

If Status Then 
	ToolTipMsg(hWndTT,TTM_TRACKACTIVATE,1,ToolInfo)
Else
	ToolTipMsg(hWndTT,TTM_TRACKACTIVATE,0,ToolInfo)
End If
end subroutine

public subroutine settipposition (integer x, integer y);// This function sets the position of a tracking tooltip..
//
// Arguments:
//				X 	=> X position of the tooltip
//				Y	=> Y position of the tooltip
//
// Notes: The tooltip control chooses where the tooltip will be displayed (typically near
// the tool) unless the TTF_ABSOLUTE flags is specified when adding the tool
Send(hWndTT,TTM_TRACKPOSITION,0,Long(X,Y))
end subroutine

public subroutine setfont (long hfont);// Sets the font used in the tooltip window
Send(hWndTT,WM_SETFONT,hFont,1)

end subroutine

on n_cst_tooltiptext.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_tooltiptext.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;InitCommonControls()

hWndTT = CreateWindowExA(WS_EX_TOPMOST,TOOLTIPS_CLASS,0, TTF_CENTERTIP, &
         CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT,  &
         0, 0, Handle(GetApplication()),0)

end event

event destructor;DestroyWindow(hWndTT)
end event

