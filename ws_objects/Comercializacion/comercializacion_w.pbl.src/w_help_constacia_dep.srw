$PBExportHeader$w_help_constacia_dep.srw
forward
global type w_help_constacia_dep from window
end type
type st_2 from statictext within w_help_constacia_dep
end type
type st_1 from statictext within w_help_constacia_dep
end type
type em_fec_depo from editmask within w_help_constacia_dep
end type
type em_const_dep from editmask within w_help_constacia_dep
end type
type cb_2 from commandbutton within w_help_constacia_dep
end type
type cb_1 from commandbutton within w_help_constacia_dep
end type
end forward

global type w_help_constacia_dep from window
integer width = 1449
integer height = 428
boolean titlebar = true
string title = "Constancia Deposito"
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
st_2 st_2
st_1 st_1
em_fec_depo em_fec_depo
em_const_dep em_const_dep
cb_2 cb_2
cb_1 cb_1
end type
global w_help_constacia_dep w_help_constacia_dep

on w_help_constacia_dep.create
this.st_2=create st_2
this.st_1=create st_1
this.em_fec_depo=create em_fec_depo
this.em_const_dep=create em_const_dep
this.cb_2=create cb_2
this.cb_1=create cb_1
this.Control[]={this.st_2,&
this.st_1,&
this.em_fec_depo,&
this.em_const_dep,&
this.cb_2,&
this.cb_1}
end on

on w_help_constacia_dep.destroy
destroy(this.st_2)
destroy(this.st_1)
destroy(this.em_fec_depo)
destroy(this.em_const_dep)
destroy(this.cb_2)
destroy(this.cb_1)
end on

event open;str_parametros lstr_param

if Not IsNull(Message.PowerObjectParm) and IsValid(Message.PowerObjectparm) then
	lstr_param = Message.PowerObjectparm
	
	em_const_dep.text = lstr_param.string1
	em_fec_depo.text  = string(lstr_param.fecha1, 'dd/mm/yyyy')
end if
end event

type st_2 from statictext within w_help_constacia_dep
integer x = 37
integer y = 128
integer width = 503
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

type st_1 from statictext within w_help_constacia_dep
integer x = 37
integer y = 32
integer width = 503
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

type em_fec_depo from editmask within w_help_constacia_dep
integer x = 549
integer y = 128
integer width = 407
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

type em_const_dep from editmask within w_help_constacia_dep
integer x = 549
integer y = 32
integer width = 407
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

type cb_2 from commandbutton within w_help_constacia_dep
integer x = 987
integer y = 124
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
boolean cancel = true
end type

event clicked;str_parametros lstr_param

lstr_param.bret = FALSE

CloseWithReturn(Parent,lstr_param)
end event

type cb_1 from commandbutton within w_help_constacia_dep
integer x = 987
integer y = 24
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
boolean default = true
end type

event clicked;String ls_const_dep,ls_cta_cte
Date   ldt_fecha_dep
str_parametros lstr_param


ls_const_dep  = em_const_dep.text
ldt_fecha_dep = Date(em_fec_depo.text)

IF Len(ls_const_dep) > 15 THEN
	gnvo_app.of_message_error('Solamente debe Considerar 15 Caracteres para la Constancia del Deposito')
	Return
END IF

lstr_param.string1 = ls_const_dep
lstr_param.fecha1	 = ldt_fecha_dep
lstr_param.bret 	 = TRUE


CloseWithReturn(Parent,lstr_param)
end event

