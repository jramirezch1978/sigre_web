$PBExportHeader$w_view_image.srw
forward
global type w_view_image from window
end type
type p_view_image from picture within w_view_image
end type
type ln_1 from line within w_view_image
end type
end forward

global type w_view_image from window
integer width = 1810
integer height = 1020
boolean titlebar = true
string title = "Visor de imagen"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 16777215
string icon = "AppIcon!"
boolean center = true
p_view_image p_view_image
ln_1 ln_1
end type
global w_view_image w_view_image

type variables
str_parametros ist_datos
end variables
on w_view_image.create
this.p_view_image=create p_view_image
this.ln_1=create ln_1
this.Control[]={this.p_view_image,&
this.ln_1}
end on

on w_view_image.destroy
destroy(this.p_view_image)
destroy(this.ln_1)
end on

event open;BLOB lbb_imagen
Integer a

// Asigna parametro
if NOT ISNULL( MESSAGE.POWEROBJECTPARM) THEN
	ist_datos = MESSAGE.POWEROBJECTPARM	
end if

selectblob  imagen into :lbb_imagen 
from ticket_capt_pantalla 
where ticket_cap_pant_id = :ist_datos.int1;

p_view_image.SetRedraw(FALSE)
a = p_view_image.SetPicture(lbb_imagen)
p_view_image.SetRedraw(TRUE)
end event

event resize;ln_1.endx = newwidth
end event

type p_view_image from picture within w_view_image
integer x = 37
integer y = 124
integer width = 553
integer height = 396
boolean originalsize = true
boolean focusrectangle = false
end type

type ln_1 from line within w_view_image
long linecolor = 134217738
integer linethickness = 4
integer beginx = 27
integer beginy = 96
integer endx = 1755
integer endy = 96
end type

