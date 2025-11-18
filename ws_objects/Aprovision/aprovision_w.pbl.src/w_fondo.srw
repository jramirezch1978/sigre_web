$PBExportHeader$w_fondo.srw
forward
global type w_fondo from window
end type
type p_1 from picture within w_fondo
end type
end forward

global type w_fondo from window
integer width = 2784
integer height = 1656
boolean enabled = false
boolean border = false
windowtype windowtype = child!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
p_1 p_1
end type
global w_fondo w_fondo

type variables

end variables

on w_fondo.create
this.p_1=create p_1
this.Control[]={this.p_1}
end on

on w_fondo.destroy
destroy(this.p_1)
end on

event resize;p_1.Height =  w_fondo.Height
p_1.Width = w_fondo.width

end event

type p_1 from picture within w_fondo
integer width = 2734
integer height = 1528
boolean enabled = false
string picturename = "H:\Source\BMP\aprov.jpg"
boolean focusrectangle = false
end type

