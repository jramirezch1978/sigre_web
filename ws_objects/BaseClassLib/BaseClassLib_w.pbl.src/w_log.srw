$PBExportHeader$w_log.srw
forward
global type w_log from window
end type
type dw_log from datawindow within w_log
end type
end forward

global type w_log from window
integer width = 1824
integer height = 1004
boolean titlebar = true
string title = "w_log"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
long backcolor = 67108864
dw_log dw_log
end type
global w_log w_log

on w_log.create
this.dw_log=create dw_log
this.Control[]={this.dw_log}
end on

on w_log.destroy
destroy(this.dw_log)
end on

type dw_log from datawindow within w_log
integer x = 9
integer y = 12
integer width = 4882
integer height = 736
integer taborder = 10
boolean enabled = false
string title = "none"
string dataobject = "d_log_diario_tbl"
borderstyle borderstyle = stylelowered!
end type

