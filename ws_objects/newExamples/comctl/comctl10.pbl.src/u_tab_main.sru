$PBExportHeader$u_tab_main.sru
$PBExportComments$Tabpage object
forward
global type u_tab_main from u_base_tab
end type
type tabpage_monthcal from u_tabpg_monthcal within u_tab_main
end type
type tabpage_datetimepick from u_tabpg_datetimepick within u_tab_main
end type
end forward

global type u_tab_main from u_base_tab
tabpage_monthcal tabpage_monthcal
tabpage_datetimepick tabpage_datetimepick
end type
global u_tab_main u_tab_main

on u_tab_main.create
this.tabpage_monthcal=create tabpage_monthcal
this.tabpage_datetimepick=create tabpage_datetimepick
int iCurrent
call super::create
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tabpage_monthcal
this.Control[iCurrent+2]=this.tabpage_datetimepick
end on

on u_tab_main.destroy
call super::destroy
destroy(this.tabpage_monthcal)
destroy(this.tabpage_datetimepick)
end on

type tabpage_monthcal from u_tabpg_monthcal within u_tab_main
int X=18
int Y=104
int Width=2016
int Height=1068
boolean Border=false
BorderStyle BorderStyle=StyleBox!
end type

type tabpage_datetimepick from u_tabpg_datetimepick within u_tab_main
int X=18
int Y=104
int Width=2016
int Height=1068
boolean Border=false
BorderStyle BorderStyle=StyleBox!
end type

