$PBExportHeader$w_get_fecha.srw
forward
global type w_get_fecha from window
end type
type em_fecha from editmask within w_get_fecha
end type
type st_1 from statictext within w_get_fecha
end type
type cb_cancelar from commandbutton within w_get_fecha
end type
type cb_aceptar from commandbutton within w_get_fecha
end type
end forward

global type w_get_fecha from window
integer width = 1358
integer height = 448
boolean titlebar = true
string title = "Ingrese la fecha requerida ..."
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
event ue_cancelar ( )
event ue_aceptar ( )
em_fecha em_fecha
st_1 st_1
cb_cancelar cb_cancelar
cb_aceptar cb_aceptar
end type
global w_get_fecha w_get_fecha

event ue_cancelar();str_parametros lstr_param

lstr_param.b_Return = false

CloseWithReturn(this, lstr_param)
end event

event ue_aceptar();str_parametros lstr_param
lstr_param.b_Return = true

em_fecha.getData(lstr_param.fecha1)

if IsNull(lstr_param.fecha1) or String(lstr_param.fecha1, 'dd/mm/yyyy') = '00/00/0000' then
	MessageBox('Aviso', 'Debe especificar una fecha valida, por favor verifique!', StopSign!)
	return
end if


CloseWithReturn(this, lstr_param)
end event

on w_get_fecha.create
this.em_fecha=create em_fecha
this.st_1=create st_1
this.cb_cancelar=create cb_cancelar
this.cb_aceptar=create cb_aceptar
this.Control[]={this.em_fecha,&
this.st_1,&
this.cb_cancelar,&
this.cb_aceptar}
end on

on w_get_fecha.destroy
destroy(this.em_fecha)
destroy(this.st_1)
destroy(this.cb_cancelar)
destroy(this.cb_aceptar)
end on

event open;em_fecha.text = string(gnvo_app.of_fecha_Actual(), 'dd/mm/yyyy')
end event

type em_fecha from editmask within w_get_fecha
integer x = 462
integer width = 768
integer height = 132
integer taborder = 10
integer textsize = -18
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
alignment alignment = center!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "dd/mm/yyyy"
boolean dropdowncalendar = true
end type

type st_1 from statictext within w_get_fecha
integer x = 9
integer width = 402
integer height = 132
integer textsize = -18
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Fecha :"
boolean focusrectangle = false
end type

type cb_cancelar from commandbutton within w_get_fecha
integer x = 681
integer y = 212
integer width = 379
integer height = 144
integer taborder = 60
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancelar"
boolean cancel = true
end type

event clicked;Parent.event dynamic ue_cancelar()
end event

type cb_aceptar from commandbutton within w_get_fecha
integer x = 302
integer y = 212
integer width = 379
integer height = 144
integer taborder = 50
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Aceptar"
boolean default = true
end type

event clicked;Parent.event dynamic ue_aceptar()
end event

