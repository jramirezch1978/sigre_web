$PBExportHeader$w_help_const_dep_fact_simpl.srw
forward
global type w_help_const_dep_fact_simpl from window
end type
type st_4 from statictext within w_help_const_dep_fact_simpl
end type
type st_3 from statictext within w_help_const_dep_fact_simpl
end type
type em_3 from editmask within w_help_const_dep_fact_simpl
end type
type cbx_1 from checkbox within w_help_const_dep_fact_simpl
end type
type st_2 from statictext within w_help_const_dep_fact_simpl
end type
type st_1 from statictext within w_help_const_dep_fact_simpl
end type
type em_2 from editmask within w_help_const_dep_fact_simpl
end type
type em_1 from editmask within w_help_const_dep_fact_simpl
end type
type cb_2 from commandbutton within w_help_const_dep_fact_simpl
end type
type cb_1 from commandbutton within w_help_const_dep_fact_simpl
end type
end forward

global type w_help_const_dep_fact_simpl from window
integer width = 1449
integer height = 560
boolean titlebar = true
string title = "Constancia Deposito"
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
st_4 st_4
st_3 st_3
em_3 em_3
cbx_1 cbx_1
st_2 st_2
st_1 st_1
em_2 em_2
em_1 em_1
cb_2 cb_2
cb_1 cb_1
end type
global w_help_const_dep_fact_simpl w_help_const_dep_fact_simpl

on w_help_const_dep_fact_simpl.create
this.st_4=create st_4
this.st_3=create st_3
this.em_3=create em_3
this.cbx_1=create cbx_1
this.st_2=create st_2
this.st_1=create st_1
this.em_2=create em_2
this.em_1=create em_1
this.cb_2=create cb_2
this.cb_1=create cb_1
this.Control[]={this.st_4,&
this.st_3,&
this.em_3,&
this.cbx_1,&
this.st_2,&
this.st_1,&
this.em_2,&
this.em_1,&
this.cb_2,&
this.cb_1}
end on

on w_help_const_dep_fact_simpl.destroy
destroy(this.st_4)
destroy(this.st_3)
destroy(this.em_3)
destroy(this.cbx_1)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.em_2)
destroy(this.em_1)
destroy(this.cb_2)
destroy(this.cb_1)
end on

event open;str_parametros lstr_param

f_centrar(This)


IF isvalid(message.PowerObjectParm) THEN
	lstr_param = message.PowerObjectParm
	st_4.text = 'Item Doc = '+Trim(lstr_param.string2)
END IF
end event

type st_4 from statictext within w_help_const_dep_fact_simpl
integer x = 882
integer y = 28
integer width = 507
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean focusrectangle = false
end type

type st_3 from statictext within w_help_const_dep_fact_simpl
integer x = 37
integer y = 360
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
string text = "% Detraccion :"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_3 from editmask within w_help_const_dep_fact_simpl
integer x = 549
integer y = 356
integer width = 343
integer height = 80
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean enabled = false
string text = "none"
alignment alignment = right!
borderstyle borderstyle = stylelowered!
end type

type cbx_1 from checkbox within w_help_const_dep_fact_simpl
integer x = 23
integer y = 28
integer width = 704
integer height = 76
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Genera Detraccion"
boolean lefttext = true
end type

event clicked;IF this.checked THEN
	em_1.enabled = true
	em_2.enabled = true
	em_3.enabled = true
else
	em_1.enabled = false
	em_2.enabled = false
	em_3.enabled = false
END IF
end event

type st_2 from statictext within w_help_const_dep_fact_simpl
integer x = 37
integer y = 268
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

type st_1 from statictext within w_help_const_dep_fact_simpl
integer x = 37
integer y = 172
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

type em_2 from editmask within w_help_const_dep_fact_simpl
integer x = 549
integer y = 268
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
boolean enabled = false
string text = "none"
alignment alignment = center!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "dd/mm/yyyy"
boolean usecodetable = true
end type

type em_1 from editmask within w_help_const_dep_fact_simpl
integer x = 549
integer y = 172
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
boolean enabled = false
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
string minmax = "~~"
end type

type cb_2 from commandbutton within w_help_const_dep_fact_simpl
integer x = 987
integer y = 256
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

type cb_1 from commandbutton within w_help_const_dep_fact_simpl
integer x = 987
integer y = 156
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

event clicked;String      ls_const_dep
Date        ldt_fecha_dep
Decimal {2} ldc_porc_dep
str_parametros lstr_param

IF cbx_1.Checked THEN //GENERA DETRACCION
	ls_const_dep  = em_1.text
	ldt_fecha_dep = Date(em_2.text)
	ldc_porc_dep  = Dec (em_3.text)


	IF Isnull(ls_const_dep) OR Trim(ls_const_dep) = '' THEN
		Messagebox('Aviso','Debe Ingresar Nro de Constancia de Deposito')
		em_1.Setfocus()
		Return
	END IF	

	IF Isnull(ldt_fecha_dep) OR String(ldt_fecha_dep,'yyyymmdd') = '00000000' THEN
		Messagebox('Aviso','Debe Ingresar Fecha de Deposito')
		em_2.Setfocus()
		Return
	END IF
	
	IF Isnull(ldc_porc_dep) OR ldc_porc_dep = 0 THEN
		Messagebox('Aviso','Debe Ingresar Porcentaje de la Detraccion')
		em_3.Setfocus()
		Return
	END IF

	IF Len(ls_const_dep) > 15 THEN
		Messagebox('Aviso','Solamente debe Considerar 15 Caracteres para la Constancia del Deposito')
		Return
	END IF

	lstr_param.string1 = ls_const_dep
	lstr_param.date1 	 = ldt_fecha_dep
	lstr_param.dec1	 = ldc_porc_dep
	lstr_param.bret 	 = TRUE
	
ELSE
	lstr_param.bret 	 = FALSE 
END IF

CloseWithReturn(Parent,lstr_param)
end event

