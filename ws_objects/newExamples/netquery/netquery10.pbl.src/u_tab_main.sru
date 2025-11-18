$PBExportHeader$u_tab_main.sru
forward
global type u_tab_main from u_tab
end type
type tabpage_netqueryinfo from u_tabpg_netqueryinfo within u_tab_main
end type
type tabpage_netsessionenum from u_tabpg_netsessionenum within u_tab_main
end type
type tabpage_servernum from u_tabpg_netserverenum within u_tab_main
end type
type tabpage_userenum from u_tabpg_netwkstauserenum within u_tab_main
end type
type tabpage_drivemapping from u_tabpg_drivemapping within u_tab_main
end type
type tabpage_other from u_tabpg_other within u_tab_main
end type
end forward

global type u_tab_main from u_tab
int Width=2418
int Height=1412
tabpage_netqueryinfo tabpage_netqueryinfo
tabpage_netsessionenum tabpage_netsessionenum
tabpage_servernum tabpage_servernum
tabpage_userenum tabpage_userenum
tabpage_drivemapping tabpage_drivemapping
tabpage_other tabpage_other
end type
global u_tab_main u_tab_main

on u_tab_main.create
this.tabpage_netqueryinfo=create tabpage_netqueryinfo
this.tabpage_netsessionenum=create tabpage_netsessionenum
this.tabpage_servernum=create tabpage_servernum
this.tabpage_userenum=create tabpage_userenum
this.tabpage_drivemapping=create tabpage_drivemapping
this.tabpage_other=create tabpage_other
int iCurrent
call super::create
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tabpage_netqueryinfo
this.Control[iCurrent+2]=this.tabpage_netsessionenum
this.Control[iCurrent+3]=this.tabpage_servernum
this.Control[iCurrent+4]=this.tabpage_userenum
this.Control[iCurrent+5]=this.tabpage_drivemapping
this.Control[iCurrent+6]=this.tabpage_other
end on

on u_tab_main.destroy
call super::destroy
destroy(this.tabpage_netqueryinfo)
destroy(this.tabpage_netsessionenum)
destroy(this.tabpage_servernum)
destroy(this.tabpage_userenum)
destroy(this.tabpage_drivemapping)
destroy(this.tabpage_other)
end on

type tabpage_netqueryinfo from u_tabpg_netqueryinfo within u_tab_main
int X=18
int Y=100
int Width=2382
int Height=1296
boolean Border=false
BorderStyle BorderStyle=StyleBox!
end type

type tabpage_netsessionenum from u_tabpg_netsessionenum within u_tab_main
int X=18
int Y=100
int Width=2382
int Height=1296
boolean Border=false
BorderStyle BorderStyle=StyleBox!
end type

type tabpage_servernum from u_tabpg_netserverenum within u_tab_main
int X=18
int Y=100
int Width=2382
int Height=1296
boolean Border=false
BorderStyle BorderStyle=StyleBox!
end type

type tabpage_userenum from u_tabpg_netwkstauserenum within u_tab_main
int X=18
int Y=100
int Width=2382
int Height=1296
boolean Border=false
BorderStyle BorderStyle=StyleBox!
end type

type tabpage_drivemapping from u_tabpg_drivemapping within u_tab_main
int X=18
int Y=100
int Width=2382
int Height=1296
boolean Border=false
BorderStyle BorderStyle=StyleBox!
end type

type tabpage_other from u_tabpg_other within u_tab_main
int X=18
int Y=100
int Width=2382
int Height=1296
boolean Border=false
BorderStyle BorderStyle=StyleBox!
end type

