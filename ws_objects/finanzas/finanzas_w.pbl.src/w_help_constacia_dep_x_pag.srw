$PBExportHeader$w_help_constacia_dep_x_pag.srw
forward
global type w_help_constacia_dep_x_pag from window
end type
type st_2 from statictext within w_help_constacia_dep_x_pag
end type
type st_1 from statictext within w_help_constacia_dep_x_pag
end type
type em_fecha from editmask within w_help_constacia_dep_x_pag
end type
type em_constancia from editmask within w_help_constacia_dep_x_pag
end type
type cb_2 from commandbutton within w_help_constacia_dep_x_pag
end type
type cb_1 from commandbutton within w_help_constacia_dep_x_pag
end type
end forward

global type w_help_constacia_dep_x_pag from window
integer width = 1760
integer height = 380
boolean titlebar = true
string title = "Datos de Constancia Deposito"
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
st_2 st_2
st_1 st_1
em_fecha em_fecha
em_constancia em_constancia
cb_2 cb_2
cb_1 cb_1
end type
global w_help_constacia_dep_x_pag w_help_constacia_dep_x_pag

on w_help_constacia_dep_x_pag.create
this.st_2=create st_2
this.st_1=create st_1
this.em_fecha=create em_fecha
this.em_constancia=create em_constancia
this.cb_2=create cb_2
this.cb_1=create cb_1
this.Control[]={this.st_2,&
this.st_1,&
this.em_fecha,&
this.em_constancia,&
this.cb_2,&
this.cb_1}
end on

on w_help_constacia_dep_x_pag.destroy
destroy(this.st_2)
destroy(this.st_1)
destroy(this.em_fecha)
destroy(this.em_constancia)
destroy(this.cb_2)
destroy(this.cb_1)
end on

event open;str_parametros lstr_param

if not IsNull(Message.Powerobjectparm) and ISValid(Message.PowerObjectParm) then
	lstr_param = Message.Powerobjectparm
	
	if Not IsNull(lstr_param.fecha1) then
		em_Fecha.text = string(lstr_param.fecha1, 'dd/mm/yyyy')
	else
		em_Fecha.text = string(date(gnvo_app.of_fecha_actual()), 'dd/mm/yyyy')
	end if
end if
end event

type st_2 from statictext within w_help_constacia_dep_x_pag
integer x = 23
integer y = 132
integer width = 498
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Fecha Deposito :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_1 from statictext within w_help_constacia_dep_x_pag
integer x = 23
integer y = 32
integer width = 498
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Constancia Deposito :"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_fecha from editmask within w_help_constacia_dep_x_pag
integer x = 530
integer y = 132
integer width = 494
integer height = 80
integer taborder = 30
integer textsize = -8
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
boolean usecodetable = true
boolean dropdowncalendar = true
end type

type em_constancia from editmask within w_help_constacia_dep_x_pag
integer x = 530
integer y = 32
integer width = 494
integer height = 80
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
string minmax = "~~"
end type

type cb_2 from commandbutton within w_help_constacia_dep_x_pag
integer x = 1198
integer y = 128
integer width = 402
integer height = 96
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Cancelar"
end type

event clicked;str_parametros lstr_param

lstr_param.bret = FALSE

CloseWithReturn(Parent,lstr_param)
end event

type cb_1 from commandbutton within w_help_constacia_dep_x_pag
integer x = 1198
integer y = 28
integer width = 402
integer height = 96
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Aceptar"
end type

event clicked;String ls_const_dep
Date   ldt_fecha_dep
str_parametros lstr_param


ls_const_dep  = em_constancia.text
ldt_fecha_dep = Date(em_fecha.text)

IF Len(ls_const_dep) > 15 THEN
	Messagebox('Aviso','Solamente debe Considerar 15 Caracteres para la Constancia del Deposito')
	Return
END IF

lstr_param.string1 = ls_const_dep
lstr_param.fecha1	 = ldt_fecha_dep
lstr_param.bret 	 = TRUE

CloseWithReturn(Parent,lstr_param)
end event

