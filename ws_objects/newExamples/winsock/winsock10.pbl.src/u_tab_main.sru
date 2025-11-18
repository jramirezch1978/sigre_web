$PBExportHeader$u_tab_main.sru
$PBExportComments$Base tab object
forward
global type u_tab_main from u_tab
end type
type tabpage_tcpip_send from u_tabpg_tcpip_send within u_tab_main
end type
type tabpage_tcpip_send from u_tabpg_tcpip_send within u_tab_main
end type
type tabpage_tcpip_listen from u_tabpg_tcpip_listen within u_tab_main
end type
type tabpage_tcpip_listen from u_tabpg_tcpip_listen within u_tab_main
end type
type tabpage_udp_send from u_tabpg_udp_send within u_tab_main
end type
type tabpage_udp_send from u_tabpg_udp_send within u_tab_main
end type
type tabpage_udp_listen from u_tabpg_udp_listen within u_tab_main
end type
type tabpage_udp_listen from u_tabpg_udp_listen within u_tab_main
end type
end forward

global type u_tab_main from u_tab
integer width = 2981
integer height = 1512
tabpage_tcpip_send tabpage_tcpip_send
tabpage_tcpip_listen tabpage_tcpip_listen
tabpage_udp_send tabpage_udp_send
tabpage_udp_listen tabpage_udp_listen
end type
global u_tab_main u_tab_main

on u_tab_main.create
this.tabpage_tcpip_send=create tabpage_tcpip_send
this.tabpage_tcpip_listen=create tabpage_tcpip_listen
this.tabpage_udp_send=create tabpage_udp_send
this.tabpage_udp_listen=create tabpage_udp_listen
int iCurrent
call super::create
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tabpage_tcpip_send
this.Control[iCurrent+2]=this.tabpage_tcpip_listen
this.Control[iCurrent+3]=this.tabpage_udp_send
this.Control[iCurrent+4]=this.tabpage_udp_listen
end on

on u_tab_main.destroy
call super::destroy
destroy(this.tabpage_tcpip_send)
destroy(this.tabpage_tcpip_listen)
destroy(this.tabpage_udp_send)
destroy(this.tabpage_udp_listen)
end on

type tabpage_tcpip_send from u_tabpg_tcpip_send within u_tab_main
integer x = 18
integer y = 100
integer width = 2944
integer height = 1396
end type

type tabpage_tcpip_listen from u_tabpg_tcpip_listen within u_tab_main
integer x = 18
integer y = 100
integer width = 2944
integer height = 1396
end type

type tabpage_udp_send from u_tabpg_udp_send within u_tab_main
integer x = 18
integer y = 100
integer width = 2944
integer height = 1396
end type

type tabpage_udp_listen from u_tabpg_udp_listen within u_tab_main
integer x = 18
integer y = 100
integer width = 2944
integer height = 1396
end type

