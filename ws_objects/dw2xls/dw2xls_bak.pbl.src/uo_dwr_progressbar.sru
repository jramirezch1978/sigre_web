$PBExportHeader$uo_dwr_progressbar.sru
$PBExportComments$By PBKiller v2.5.18(http://kivens.nease.net)
forward
global type uo_dwr_progressbar from userobject
end type
end forward

global type uo_dwr_progressbar from userobject
integer width = 1161
integer height = 104
long backcolor = 79741120
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
event valuechanged (long oldvalue,long newvalue)
end type
global uo_dwr_progressbar uo_dwr_progressbar

type prototypes
public subroutine initcommoncontrols () library "comctl32.dll" alias for "InitCommonControls"
public function long createwindowexa (ulong dwexstyle,string as_classname,long windowname,ulong dwstyle,ulong a_x,ulong a_y,ulong nwidth,ulong nheight,ulong hwndparent,ulong hmenu,ulong hinstance,ulong lpparam)  library "user32.dll" alias for "CreateWindowExA"
public function long createwindowexw (ulong dwexstyle,string as_classname,long windowname,ulong dwstyle,ulong a_x,ulong a_y,ulong nwidth,ulong nheight,ulong hwndparent,ulong hmenu,ulong hinstance,ulong lpparam)  library "user32.dll" alias for "CreateWindowExW"
public function integer destroywindow (long hwnd2)  library "user32.dll" alias for "DestroyWindow"
end prototypes

type variables
public long hhwnd
public long value
public long minvalue
public long maxvalue
public uint stepvalue
public string progress_class = "msctls_progress32"
public ulong cw_usedefault = 2147483648
public integer wm_user = 1024
public integer pbm_setrange = 1025
public integer pbm_setpos = 1026
public integer pbm_deltapos = 1027
public integer pbm_setstep = 1028
public integer pbm_stepit = 1029
public integer pbm_setrange32 = 1030
public integer pbm_getrange = 1031
public integer bm_getpos = 1032
public long ws_child = 1073741824
public long ws_visible = 268435456
end variables

forward prototypes
protected subroutine initialize ()
public subroutine setrange (long min,long max)
public subroutine setstep (uint stepval)
public subroutine setvalue (long newvalue)
public subroutine stepit ()
end prototypes

protected subroutine initialize ();setrange(minvalue,maxvalue)
setstep(stepvalue)
end subroutine

public subroutine setrange (long min,long max);minvalue = min
maxvalue = max
send(hhwnd,1025,0,long(minvalue,maxvalue))
end subroutine

public subroutine setstep (uint stepval);stepvalue = stepval
send(hhwnd,1028,stepvalue,0)
end subroutine

public subroutine setvalue (long newvalue);event valuechanged(value,newvalue)
value = newvalue
send(hhwnd,1026,value,0)
end subroutine

public subroutine stepit ();event valuechanged(value,value + stepvalue)
value += stepvalue
send(hhwnd,1029,0,0)
end subroutine

event constructor;long ll_x
long ll_y
long ll_width
long ll_height

initcommoncontrols()
ll_x = unitstopixels(x,xunitstopixels!)
ll_y = unitstopixels(y,yunitstopixels!)
ll_width = unitstopixels(width,xunitstopixels!)
ll_height = unitstopixels(height,yunitstopixels!)
hhwnd = createwindowexa(0,"msctls_progress32",0,1073741824 + 268435456,ll_x,ll_y,ll_width,ll_height,handle(parent),0,handle(getapplication()),0)
visible = false
initialize()
return
end event

on uo_dwr_progressbar.create

end on

on uo_dwr_progressbar.destroy

end on

event destructor;destroywindow(hhwnd)
return
end event

