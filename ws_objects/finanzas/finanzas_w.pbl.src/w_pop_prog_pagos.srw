$PBExportHeader$w_pop_prog_pagos.srw
forward
global type w_pop_prog_pagos from w_abc
end type
type cbx_fec_vence from checkbox within w_pop_prog_pagos
end type
type em_dias from editmask within w_pop_prog_pagos
end type
type st_4 from statictext within w_pop_prog_pagos
end type
type st_3 from statictext within w_pop_prog_pagos
end type
type em_cuotas from editmask within w_pop_prog_pagos
end type
type cbx_proveedor from checkbox within w_pop_prog_pagos
end type
type st_descripcion from statictext within w_pop_prog_pagos
end type
type st_2 from statictext within w_pop_prog_pagos
end type
type st_1 from statictext within w_pop_prog_pagos
end type
type em_fecha from editmask within w_pop_prog_pagos
end type
type cb_aceptar from commandbutton within w_pop_prog_pagos
end type
type cb_cancelar from commandbutton within w_pop_prog_pagos
end type
type p_1 from picture within w_pop_prog_pagos
end type
type sle_codigo from singlelineedit within w_pop_prog_pagos
end type
end forward

global type w_pop_prog_pagos from w_abc
integer width = 3163
integer height = 516
string title = "Seleccione Datos para Programación de Pagos"
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
long backcolor = 16777215
cbx_fec_vence cbx_fec_vence
em_dias em_dias
st_4 st_4
st_3 st_3
em_cuotas em_cuotas
cbx_proveedor cbx_proveedor
st_descripcion st_descripcion
st_2 st_2
st_1 st_1
em_fecha em_fecha
cb_aceptar cb_aceptar
cb_cancelar cb_cancelar
p_1 p_1
sle_codigo sle_codigo
end type
global w_pop_prog_pagos w_pop_prog_pagos

on w_pop_prog_pagos.create
int iCurrent
call super::create
this.cbx_fec_vence=create cbx_fec_vence
this.em_dias=create em_dias
this.st_4=create st_4
this.st_3=create st_3
this.em_cuotas=create em_cuotas
this.cbx_proveedor=create cbx_proveedor
this.st_descripcion=create st_descripcion
this.st_2=create st_2
this.st_1=create st_1
this.em_fecha=create em_fecha
this.cb_aceptar=create cb_aceptar
this.cb_cancelar=create cb_cancelar
this.p_1=create p_1
this.sle_codigo=create sle_codigo
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_fec_vence
this.Control[iCurrent+2]=this.em_dias
this.Control[iCurrent+3]=this.st_4
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.em_cuotas
this.Control[iCurrent+6]=this.cbx_proveedor
this.Control[iCurrent+7]=this.st_descripcion
this.Control[iCurrent+8]=this.st_2
this.Control[iCurrent+9]=this.st_1
this.Control[iCurrent+10]=this.em_fecha
this.Control[iCurrent+11]=this.cb_aceptar
this.Control[iCurrent+12]=this.cb_cancelar
this.Control[iCurrent+13]=this.p_1
this.Control[iCurrent+14]=this.sle_codigo
end on

on w_pop_prog_pagos.destroy
call super::destroy
destroy(this.cbx_fec_vence)
destroy(this.em_dias)
destroy(this.st_4)
destroy(this.st_3)
destroy(this.em_cuotas)
destroy(this.cbx_proveedor)
destroy(this.st_descripcion)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.em_fecha)
destroy(this.cb_aceptar)
destroy(this.cb_cancelar)
destroy(this.p_1)
destroy(this.sle_codigo)
end on

event open;call super::open;date ld_fecha
str_parametros lstr_param

if not IsNull(Message.PowerObjectParm) and IsValid(Message.PowerObjectParm) then
	lstr_param = Message.PowerObjectParm
	
	em_fecha.Text = string(lstr_param.fecha1, "dd/mm/yyyy")
	
else
	em_fecha.Text = string(f_fecha_Actual(), "dd/mm/yyyy")
end if

sle_Codigo.SetFocus()
end event

type cbx_fec_vence from checkbox within w_pop_prog_pagos
integer x = 1591
integer y = 44
integer width = 759
integer height = 84
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
string text = "Fec Vencim. del Documento"
boolean checked = true
end type

event clicked;if this.checked then
	em_fecha.enabled = false
else
	em_fecha.enabled = true
end if
end event

type em_dias from editmask within w_pop_prog_pagos
boolean visible = false
integer x = 1911
integer y = 136
integer width = 343
integer height = 84
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean enabled = false
string text = "30"
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "###,##0"
boolean spin = true
double increment = 1
string minmax = "1~~"
end type

type st_4 from statictext within w_pop_prog_pagos
boolean visible = false
integer x = 1559
integer y = 136
integer width = 334
integer height = 84
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
string text = "Dias Plazo:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_3 from statictext within w_pop_prog_pagos
integer x = 631
integer y = 136
integer width = 553
integer height = 84
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
string text = "Nro Cuotas:"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_cuotas from editmask within w_pop_prog_pagos
integer x = 1202
integer y = 136
integer width = 343
integer height = 84
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "1"
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "###,##0"
boolean spin = true
double increment = 1
string minmax = "1~~"
end type

event modified;if Long(this.text) > 1 then
	em_dias.enabled = true
	em_dias.visible = true
	
	st_4.visible 	 = true
else
	em_dias.enabled = false
	em_dias.visible = false
	
	st_4.visible 	 = false
end if
end event

type cbx_proveedor from checkbox within w_pop_prog_pagos
integer x = 681
integer y = 336
integer width = 1321
integer height = 72
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
string text = "Tomar el codigo de Flujo de Caja Según el proveedor"
end type

event clicked;if this.checked then
	sle_codigo.text = ""
	sle_codigo.enabled = false
else
	sle_codigo.enabled = true
end if
end event

type st_descripcion from statictext within w_pop_prog_pagos
integer x = 1522
integer y = 228
integer width = 1074
integer height = 84
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type st_2 from statictext within w_pop_prog_pagos
integer x = 640
integer y = 228
integer width = 553
integer height = 84
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
string text = "Código Flujo Caja:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_1 from statictext within w_pop_prog_pagos
integer x = 626
integer y = 44
integer width = 553
integer height = 84
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
string text = "Fecha Programada:"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_fecha from editmask within w_pop_prog_pagos
integer x = 1202
integer y = 44
integer width = 370
integer height = 84
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean enabled = false
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
boolean dropdowncalendar = true
end type

type cb_aceptar from commandbutton within w_pop_prog_pagos
integer x = 2656
integer y = 36
integer width = 402
integer height = 112
integer taborder = 50
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aceptar"
boolean default = true
end type

event clicked;str_parametros lstr_param

if Long(em_cuotas.text) <= 0 then
	MessageBox('Error', 'Debe Especificar un numero de cuotas mayor a cero, por favor verifique!')
	em_cuotas.text = "1"
	em_cuotas.Setfocus()
	return
end if

if Long(em_cuotas.text) < 1 then
	if Long(em_dias.text) <= 0 then
		MessageBox('Error', 'Debe Especificar un numero de días mayor a cero, por favor verifique!')
		em_dias.text = "30"
		em_dias.Setfocus()
		return
	end if
end if

lstr_param.string1 	= trim(sle_codigo.text)
lstr_param.boolean1 	= cbx_proveedor.checked
lstr_param.boolean2 	= cbx_fec_vence.checked
lstr_param.fecha1	 	= Date(em_fecha.Text)
lstr_param.long1	 	= Long(em_cuotas.text)
lstr_param.long2	 	= Long(em_dias.text)

lstr_param.i_return = 1

CloseWithReturn(parent, lstr_param)
end event

type cb_cancelar from commandbutton within w_pop_prog_pagos
integer x = 2656
integer y = 168
integer width = 402
integer height = 112
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

event clicked;str_parametros lstr_param

lstr_param.i_return = -1

CloseWithReturn(parent, lstr_param)
end event

type p_1 from picture within w_pop_prog_pagos
integer width = 562
integer height = 304
string picturename = "C:\SIGRE\resources\PNG\sigre.png"
boolean focusrectangle = false
end type

type sle_codigo from singlelineedit within w_pop_prog_pagos
event ue_dobleclick pbm_lbuttondblclk
integer x = 1202
integer y = 228
integer width = 311
integer height = 84
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "C:\SIGRE\resources\cur\taladro.cur"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
boolean hideselection = false
end type

event ue_dobleclick;str_parametros		lstr_param
String 		    	ls_name,ls_prot,ls_flag_cebef, ls_sql, ls_codigo, ls_data, ls_year, ls_cencos

lstr_param.tipo			= ''
lstr_param.opcion			= 15
lstr_param.titulo 		= 'Selección de Flujo de Caja'
lstr_param.dw_master		= 'd_lista_grupo_flujo_caja_tbl'     //Filtrado para cierto grupo
lstr_param.dw1				= 'd_lista_flujo_caja_tbl'
lstr_param.txt_Codigo	=  sle_codigo
lstr_param.st_descripcion = st_descripcion

OpenWithParm( w_abc_seleccion_md, lstr_param)


end event

event modified;string ls_Data, ls_codigo

ls_codigo = this.text

if trim(ls_codigo) = "" then
	MessageBox('Error', 'Debe indicar un codigo, por favor verifique')
	this.SetFocus()
	return
end if

select descripcion
	into :ls_data
from codigo_flujo_caja
where cod_flujo_caja = :ls_codigo
  and flag_estado = '1';

if SQLCA.SQLCode = 100 then
	MessageBox('Aviso', 'No existe codigo de Flujo de Caja o no se encuentra activo, por favor verifique!')
	this.text = ""
	this.setFocus( )
	return
end if

st_descripcion.text = ls_data

end event

