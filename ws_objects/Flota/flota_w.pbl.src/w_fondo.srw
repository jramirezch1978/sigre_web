$PBExportHeader$w_fondo.srw
forward
global type w_fondo from window
end type
type p_1 from picture within w_fondo
end type
end forward

global type w_fondo from window
integer width = 3008
integer height = 2044
boolean enabled = false
boolean border = false
windowtype windowtype = child!
long backcolor = 16777215
string icon = "AppIcon!"
string pointer = "h:\Source\CUR\P-ARGYLE.ANI"
p_1 p_1
end type
global w_fondo w_fondo

on w_fondo.create
this.p_1=create p_1
this.Control[]={this.p_1}
end on

on w_fondo.destroy
destroy(this.p_1)
end on

event resize;this.SetRedraw(false)

p_1.width 	= this.width
p_1.height 	= this.height

this.SetRedraw(true)
end event

event open;p_1.PictureName = gs_WallPaper
end event

type p_1 from picture within w_fondo
integer width = 2926
integer height = 1920
string pointer = "h:\Source\CUR\P-ARGYLE.ANI"
string picturename = "H:\source\Jpg\Constante.JPG"
boolean focusrectangle = false
end type

