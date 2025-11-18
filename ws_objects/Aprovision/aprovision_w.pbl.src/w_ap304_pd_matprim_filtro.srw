$PBExportHeader$w_ap304_pd_matprim_filtro.srw
forward
global type w_ap304_pd_matprim_filtro from window
end type
type uo_1 from u_ingreso_rango_fechas within w_ap304_pd_matprim_filtro
end type
type cbx_tipo from checkbox within w_ap304_pd_matprim_filtro
end type
type pb_1 from picturebutton within w_ap304_pd_matprim_filtro
end type
type pb_2 from picturebutton within w_ap304_pd_matprim_filtro
end type
end forward

global type w_ap304_pd_matprim_filtro from window
integer width = 1349
integer height = 384
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
uo_1 uo_1
cbx_tipo cbx_tipo
pb_1 pb_1
pb_2 pb_2
end type
global w_ap304_pd_matprim_filtro w_ap304_pd_matprim_filtro

on w_ap304_pd_matprim_filtro.create
this.uo_1=create uo_1
this.cbx_tipo=create cbx_tipo
this.pb_1=create pb_1
this.pb_2=create pb_2
this.Control[]={this.uo_1,&
this.cbx_tipo,&
this.pb_1,&
this.pb_2}
end on

on w_ap304_pd_matprim_filtro.destroy
destroy(this.uo_1)
destroy(this.cbx_tipo)
destroy(this.pb_1)
destroy(this.pb_2)
end on

type uo_1 from u_ingreso_rango_fechas within w_ap304_pd_matprim_filtro
integer x = 18
integer y = 32
integer taborder = 50
end type

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;of_set_label('Desde:','Hasta:') //para setear la fecha inicial
of_set_fecha(date('01/01/1900'), date('31/12/9999')) // para seatear el titulo del boton
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final
end event

type cbx_tipo from checkbox within w_ap304_pd_matprim_filtro
integer x = 14
integer y = 172
integer width = 1298
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Visualizar sólo los partes de piso que requieran firma"
end type

type pb_1 from picturebutton within w_ap304_pd_matprim_filtro
integer x = 1024
integer y = 268
integer width = 101
integer height = 88
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "Custom038!"
alignment htextalign = left!
end type

event clicked;string ls_fecha1, ls_fecha2, ls_mensaje
ls_fecha1 = trim(string(uo_1.of_get_fecha1(), 'dd/mm/yyyy'))
ls_fecha2 = trim(string(uo_1.of_get_fecha2(), 'dd/mm/yyyy'))
ls_mensaje = ls_fecha1 + ls_fecha2
if cbx_tipo.checked then
	ls_mensaje = ls_fecha1 + ls_fecha2 + 'S'
else
	ls_mensaje = ls_fecha1 + ls_fecha2 + 'N'
end if

CloseWithReturn(Parent, ls_mensaje)
end event

type pb_2 from picturebutton within w_ap304_pd_matprim_filtro
integer x = 1170
integer y = 268
integer width = 101
integer height = 88
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "Close!"
alignment htextalign = left!
end type

event clicked;close (parent)
end event

