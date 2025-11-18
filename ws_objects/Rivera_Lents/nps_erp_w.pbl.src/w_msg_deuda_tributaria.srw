$PBExportHeader$w_msg_deuda_tributaria.srw
forward
global type w_msg_deuda_tributaria from window
end type
type st_1 from statictext within w_msg_deuda_tributaria
end type
type p_2 from picture within w_msg_deuda_tributaria
end type
type p_1 from picture within w_msg_deuda_tributaria
end type
type gb_1 from groupbox within w_msg_deuda_tributaria
end type
end forward

global type w_msg_deuda_tributaria from window
integer width = 2290
integer height = 516
boolean titlebar = true
string title = "Deuda Sunat"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
st_1 st_1
p_2 p_2
p_1 p_1
gb_1 gb_1
end type
global w_msg_deuda_tributaria w_msg_deuda_tributaria

type variables
Integer li_opcion = 1
end variables

on w_msg_deuda_tributaria.create
this.st_1=create st_1
this.p_2=create p_2
this.p_1=create p_1
this.gb_1=create gb_1
this.Control[]={this.st_1,&
this.p_2,&
this.p_1,&
this.gb_1}
end on

on w_msg_deuda_tributaria.destroy
destroy(this.st_1)
destroy(this.p_2)
destroy(this.p_1)
destroy(this.gb_1)
end on

event open;String ls_descripcion

SELECT ' '||M.DESCRIPCION 
  INTO :ls_descripcion 
  FROM MONEDA M 
 WHERE M.COD_MONEDA IN (SELECT L.COD_SOLES FROM LOGPARAM L WHERE L.RECKEY = '1');



st_1.Text = st_1.Text + Message.StringParm + ls_descripcion


 
timer(0.5)
end event

event timer;if li_opcion = 1 then
	st_1.textcolor = rgb(255,0,0)
	li_opcion = 2
else
	st_1.textcolor = rgb(0,0,0)
	li_opcion = 1
end if	
end event

type st_1 from statictext within w_msg_deuda_tributaria
integer x = 183
integer y = 216
integer width = 1984
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Proveedor tiene deuda Tributaria por un Monto de "
boolean focusrectangle = false
end type

type p_2 from picture within w_msg_deuda_tributaria
integer x = 46
integer y = 200
integer width = 110
integer height = 96
boolean originalsize = true
string picturename = "H:\Source\BMP\cliente.bmp"
boolean focusrectangle = false
end type

type p_1 from picture within w_msg_deuda_tributaria
integer x = 41
integer y = 68
integer width = 462
integer height = 104
string picturename = "H:\Source\BMP\sunat.bmp"
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_msg_deuda_tributaria
integer x = 14
integer width = 2258
integer height = 404
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

