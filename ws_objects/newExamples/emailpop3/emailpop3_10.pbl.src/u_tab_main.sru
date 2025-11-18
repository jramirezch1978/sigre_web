$PBExportHeader$u_tab_main.sru
forward
global type u_tab_main from u_tab
end type
type tabpage_pop3 from u_tabpg_pop3 within u_tab_main
end type
type tabpage_pop3 from u_tabpg_pop3 within u_tab_main
end type
type tabpage_settings from u_tabpg_settings within u_tab_main
end type
type tabpage_settings from u_tabpg_settings within u_tab_main
end type
end forward

global type u_tab_main from u_tab
integer width = 2446
integer height = 1968
tabpage_pop3 tabpage_pop3
tabpage_settings tabpage_settings
end type
global u_tab_main u_tab_main

on u_tab_main.create
this.tabpage_pop3=create tabpage_pop3
this.tabpage_settings=create tabpage_settings
int iCurrent
call super::create
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tabpage_pop3
this.Control[iCurrent+2]=this.tabpage_settings
end on

on u_tab_main.destroy
call super::destroy
destroy(this.tabpage_pop3)
destroy(this.tabpage_settings)
end on

type tabpage_pop3 from u_tabpg_pop3 within u_tab_main
integer x = 18
integer y = 100
integer width = 2409
integer height = 1852
end type

type tabpage_settings from u_tabpg_settings within u_tab_main
integer x = 18
integer y = 100
integer width = 2409
integer height = 1852
end type

