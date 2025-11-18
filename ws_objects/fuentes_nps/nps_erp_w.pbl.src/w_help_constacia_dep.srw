$PBExportHeader$w_help_constacia_dep.srw
forward
global type w_help_constacia_dep from window
end type
type cbx_1 from checkbox within w_help_constacia_dep
end type
type st_2 from statictext within w_help_constacia_dep
end type
type st_1 from statictext within w_help_constacia_dep
end type
type em_2 from editmask within w_help_constacia_dep
end type
type em_1 from editmask within w_help_constacia_dep
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
cbx_1 cbx_1
st_2 st_2
st_1 st_1
em_2 em_2
em_1 em_1
cb_2 cb_2
cb_1 cb_1
end type
global w_help_constacia_dep w_help_constacia_dep

on w_help_constacia_dep.create
this.cbx_1=create cbx_1
this.st_2=create st_2
this.st_1=create st_1
this.em_2=create em_2
this.em_1=create em_1
this.cb_2=create cb_2
this.cb_1=create cb_1
this.Control[]={this.cbx_1,&
this.st_2,&
this.st_1,&
this.em_2,&
this.em_1,&
this.cb_2,&
this.cb_1}
end on

on w_help_constacia_dep.destroy
destroy(this.cbx_1)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.em_2)
destroy(this.em_1)
destroy(this.cb_2)
destroy(this.cb_1)
end on

event open;//f_centrar(This)

end event

type cbx_1 from checkbox within w_help_constacia_dep
integer x = 27
integer y = 244
integer width = 1157
integer height = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Genera Detracción en Cuenta Corriente"
end type

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

type em_2 from editmask within w_help_constacia_dep
integer x = 549
integer y = 128
integer width = 343
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
end type

type em_1 from editmask within w_help_constacia_dep
integer x = 549
integer y = 32
integer width = 343
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
end type

event clicked;String ls_const_dep,ls_cta_cte
Date   ldt_fecha_dep
str_parametros lstr_param


ls_const_dep  = em_1.text
ldt_fecha_dep = Date(em_2.text)

//IF Isnull(ls_const_dep) OR Trim(ls_const_dep) = '' THEN
//	Messagebox('Aviso','Debe Ingresar Nro de Constancia de Deposito')
//	em_1.Setfocus()
//	Return
//END IF	
//
//IF Isnull(ldt_fecha_dep) OR String(ldt_fecha_dep,'yyyymmdd') = '00000000' THEN
//	Messagebox('Aviso','Debe Ingresar Fecha de Deposito')
//	em_2.Setfocus()
//	Return
//END IF	

IF cbx_1.checked THEN
	ls_cta_cte = '1'
ELSE
	ls_cta_cte = '0'
END IF	

IF Len(ls_const_dep) > 15 THEN
	Messagebox('Aviso','Solamente debe Considerar 15 Caracteres para la Constancia del Deposito')
	Return
END IF

lstr_param.string1 = ls_const_dep
lstr_param.string2 = ls_cta_cte
lstr_param.date1 	 = ldt_fecha_dep
lstr_param.bret 	 = TRUE


CloseWithReturn(Parent,lstr_param)
end event

