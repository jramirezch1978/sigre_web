$PBExportHeader$w_main.srw
forward
global type w_main from window
end type
type p_1 from picture within w_main
end type
end forward

global type w_main from window
integer width = 3959
integer height = 1924
boolean titlebar = true
string title = "Programa de Pruebas"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
p_1 p_1
end type
global w_main w_main

on w_main.create
this.p_1=create p_1
this.Control[]={this.p_1}
end on

on w_main.destroy
destroy(this.p_1)
end on

type p_1 from picture within w_main
integer width = 942
integer height = 580
string picturename = "C:\SIGRE\resources\logos\NPSSAC_logo.png"
boolean focusrectangle = false
end type

