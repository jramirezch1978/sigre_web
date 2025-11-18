$PBExportHeader$u_tab_main.sru
forward
global type u_tab_main from u_base_tab
end type
type tabpage_design from u_tabpg_design within u_tab_main
end type
type tabpage_design from u_tabpg_design within u_tab_main
end type
type tabpage_view from u_tabpg_view within u_tab_main
end type
type tabpage_view from u_tabpg_view within u_tab_main
end type
type tabpage_source from u_tabpg_source within u_tab_main
end type
type tabpage_source from u_tabpg_source within u_tab_main
end type
type tabpage_1 from u_tabpg_browse within u_tab_main
end type
type tabpage_1 from u_tabpg_browse within u_tab_main
end type
end forward

global type u_tab_main from u_base_tab
tabpage_design tabpage_design
tabpage_view tabpage_view
tabpage_source tabpage_source
tabpage_1 tabpage_1
end type
global u_tab_main u_tab_main

forward prototypes
public function u_tabpg_design of_getdesign ()
public function u_tabpg_view of_getview ()
public function u_tabpg_source of_getsource ()
end prototypes

public function u_tabpg_design of_getdesign ();// return tabpage ref
Return tabpage_design

end function

public function u_tabpg_view of_getview ();// return tabpage ref
Return tabpage_view

end function

public function u_tabpg_source of_getsource ();// return tabpage ref
Return tabpage_source

end function

on u_tab_main.create
this.tabpage_design=create tabpage_design
this.tabpage_view=create tabpage_view
this.tabpage_source=create tabpage_source
this.tabpage_1=create tabpage_1
int iCurrent
call super::create
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tabpage_design
this.Control[iCurrent+2]=this.tabpage_view
this.Control[iCurrent+3]=this.tabpage_source
this.Control[iCurrent+4]=this.tabpage_1
end on

on u_tab_main.destroy
call super::destroy
destroy(this.tabpage_design)
destroy(this.tabpage_view)
destroy(this.tabpage_source)
destroy(this.tabpage_1)
end on

type tabpage_design from u_tabpg_design within u_tab_main
integer x = 18
integer y = 100
integer height = 1648
end type

type tabpage_view from u_tabpg_view within u_tab_main
integer x = 18
integer y = 100
integer height = 1648
end type

type tabpage_source from u_tabpg_source within u_tab_main
integer x = 18
integer y = 100
integer height = 1648
end type

type tabpage_1 from u_tabpg_browse within u_tab_main
integer x = 18
integer y = 100
integer height = 1648
end type

