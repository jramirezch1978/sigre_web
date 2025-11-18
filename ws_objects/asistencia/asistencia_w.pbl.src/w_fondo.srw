$PBExportHeader$w_fondo.srw
forward
global type w_fondo from window
end type
type p_1 from picture within w_fondo
end type
end forward

global type w_fondo from window
integer width = 4018
integer height = 2372
boolean border = false
windowtype windowtype = child!
long backcolor = 67108864
string icon = "AppIcon!"
p_1 p_1
end type
global w_fondo w_fondo

event resize;this.SetRedraw(false)

p_1.width 	= this.width
p_1.height 	= this.height

this.SetRedraw(true)
end event

on w_fondo.create
this.p_1=create p_1
this.Control[]={this.p_1}
end on

on w_fondo.destroy
destroy(this.p_1)
end on

type p_1 from picture within w_fondo
integer x = 37
integer y = 20
integer width = 3429
integer height = 1788
string picturename = "C:\SIGRE\resources\PNG\Logos Modernos\fondo_asitencia.png"
boolean focusrectangle = false
end type

