$PBExportHeader$uo_dwr_progressbar.sru
forward
global type uo_dwr_progressbar from UserObject
end type
end forward

global type uo_dwr_progressbar from UserObject
int Width=1161
int Height=104
long BackColor=79741120
long PictureMaskColor=536870912
long TabTextColor=33554432
long TabBackColor=67108864
event valuechanged ( long oldvalue,  long newvalue )
end type
global uo_dwr_progressbar uo_dwr_progressbar

type prototypes
SubRoutine InitCommonControls() library "comctl32.dll"
Function long CreateWindowExA(ulong dwExStyle, string as_ClassName, long WindowName, ulong dwStyle, ulong a_X, ulong a_Y, ulong nWidth, ulong nHeight, ulong hWndParent, ulong hMenu, ulong hInstance, ulong lpParam) library "user32.dll"
Function long CreateWindowExW(ulong dwExStyle, string as_ClassName, long WindowName, ulong dwStyle, ulong a_X, ulong a_Y, ulong nWidth, ulong nHeight, ulong hWndParent, ulong hMenu, ulong hInstance, ulong lpParam) library "user32.dll"
Function integer DestroyWindow(long hWnd2) library "user32.dll"

end prototypes

type variables
public:
long hhWnd
long Value
long MinValue
long MaxValue
uint StepValue

CONSTANT string PROGRESS_CLASS = 'msctls_progress32'
CONSTANT ulong CW_USEDEFAULT	= 2147483648
CONSTANT integer WM_USER 	= 1024
CONSTANT integer PBM_SETRANGE	= WM_USER+1
CONSTANT integer PBM_SETPOS	= WM_USER+2
CONSTANT integer PBM_DELTAPOS	= WM_USER+3
CONSTANT integer PBM_SETSTEP	= WM_USER+4
CONSTANT integer PBM_STEPIT	= WM_USER+5
CONSTANT integer PBM_SETRANGE32  = WM_USER+6
CONSTANT integer PBM_GETRANGE	= WM_USER+7
CONSTANT integer BM_GETPOS	= WM_USER+8
CONSTANT long WS_CHILD		= 1073741824
CONSTANT long WS_VISIBLE	= 268435456
end variables

forward prototypes
protected subroutine initialize ()
public subroutine stepit ()
public subroutine setstep (unsignedinteger stepval)
public subroutine setrange (long min, long max)
public subroutine setvalue (long newvalue)
end prototypes

protected subroutine initialize ();// Initialize the control setting default properties
This.SetRange(MinValue,MaxValue)
This.SetStep(StepValue)
 
end subroutine

public subroutine stepit ();// The PBM_STEPIT message advances the current position for a progress bar by the step 
// increment and redraws the bar to reflect the new position. An application sets the step 
// increment by sending the PBM_SETSTEP message.
This.EVENT ValueChanged(Value,Value + StepValue)
Value += StepValue
Send(this.hhWnd, PBM_STEPIT,0,0)
 

end subroutine

public subroutine setstep (unsignedinteger stepval);// The PBM_SETSTEP message specifies the step increment for a progress bar. The step 
// increment is the amount by which the progress bar increases its current position 
// whenever it receives a PBM_STEPIT message. By default, the step increment is set to 10.
StepValue = StepVal 
Send(hhWnd,PBM_SETSTEP,StepValue,0)
end subroutine

public subroutine setrange (long min, long max);// The PBM_SETRANGE message sets the minimum and maximum values for a progress bar and 
// redraws the bar to reflect the new range.
//
// The MinValue and MaxValue parameters are INTEGER's therefor if the MaxValue is bigger than
// 32767 you should set MaxValue to 100 (100 percent) and make the appropriate 
// calculations to set the value...
MinValue = Min
MaxValue = Max 
Send(hhWnd,PBM_SETRANGE,0,Long(MinValue,MaxValue))
end subroutine

public subroutine setvalue (long newvalue);// Sets the new value into the control
This.EVENT ValueChanged(Value,Newvalue)
Value = NewValue 
Send(hhWnd, PBM_SETPOS, Value, 0)
end subroutine

on uo_dwr_progressbar.create
end on

on uo_dwr_progressbar.destroy
end on

event constructor;long ll_X,ll_Y,ll_Width, ll_Height

InitCommonControls()   

ll_X 		= UnitsToPixels(This.X,XUnitsToPixels!)
ll_Y 		= UnitsToPixels(This.Y,YUnitsToPixels!)
ll_Width = UnitsToPixels(This.Width,XUnitsToPixels!)
ll_Height= UnitsToPixels(This.Height,YUnitsToPixels!)


hhWnd = CreateWindowExW(0,PROGRESS_CLASS,0, WS_CHILD + WS_VISIBLE, &
         ll_X, ll_Y, ll_Width, ll_Height,  &
         Handle(Parent), 0, Handle(GetApplication()),0)




This.Visible = False

This.POST Initialize()
end event

event destructor;DestroyWindow(hhWnd)
end event

