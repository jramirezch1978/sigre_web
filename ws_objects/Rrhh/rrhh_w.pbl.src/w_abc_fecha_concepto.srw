$PBExportHeader$w_abc_fecha_concepto.srw
forward
global type w_abc_fecha_concepto from w_abc
end type
type uo_fecha from u_ingreso_fecha within w_abc_fecha_concepto
end type
type sle_desc_concepto from singlelineedit within w_abc_fecha_concepto
end type
type sle_concepto from n_cst_textbox within w_abc_fecha_concepto
end type
type st_1 from statictext within w_abc_fecha_concepto
end type
type cb_aceptar from commandbutton within w_abc_fecha_concepto
end type
type cb_cancelar from commandbutton within w_abc_fecha_concepto
end type
end forward

global type w_abc_fecha_concepto from w_abc
integer width = 2030
integer height = 436
string title = "Seleccione la Fecha y el concepto"
boolean maxbox = false
boolean resizable = false
windowtype windowtype = popup!
uo_fecha uo_fecha
sle_desc_concepto sle_desc_concepto
sle_concepto sle_concepto
st_1 st_1
cb_aceptar cb_aceptar
cb_cancelar cb_cancelar
end type
global w_abc_fecha_concepto w_abc_fecha_concepto

on w_abc_fecha_concepto.create
int iCurrent
call super::create
this.uo_fecha=create uo_fecha
this.sle_desc_concepto=create sle_desc_concepto
this.sle_concepto=create sle_concepto
this.st_1=create st_1
this.cb_aceptar=create cb_aceptar
this.cb_cancelar=create cb_cancelar
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_fecha
this.Control[iCurrent+2]=this.sle_desc_concepto
this.Control[iCurrent+3]=this.sle_concepto
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.cb_aceptar
this.Control[iCurrent+6]=this.cb_cancelar
end on

on w_abc_fecha_concepto.destroy
call super::destroy
destroy(this.uo_fecha)
destroy(this.sle_desc_concepto)
destroy(this.sle_concepto)
destroy(this.st_1)
destroy(this.cb_aceptar)
destroy(this.cb_cancelar)
end on

event ue_cancelar;call super::ue_cancelar;str_parametros	lstr_param
lstr_param.b_return = false

CloseWithReturn(this, lstr_param)
end event

event ue_anular;call super::ue_anular;str_parametros	lstr_param

if trim(sle_concepto.Text) = '' then 
	MessageBox('Aviso', 'Debe seleccionar un concepto Valido', StopSign!)
	sle_concepto.setFocus()
	return
end if

lstr_param.b_return = true

lstr_param.string1 = sle_concepto.text
lstr_param.date1	 = uo_fecha.of_get_fecha( )

CloseWithReturn(this, lstr_param)
end event

type uo_fecha from u_ingreso_fecha within w_abc_fecha_concepto
event destroy ( )
integer x = 64
integer y = 132
integer width = 690
integer taborder = 40
boolean bringtotop = true
end type

on uo_fecha.destroy
call u_ingreso_fecha::destroy
end on

event constructor;call super::constructor; of_set_label('Fecha:') // para seatear el titulo del boton
 of_set_fecha(date('31/12/9999')) //para setear la fecha inicial
 of_set_rango_inicio(date('01/01/1900')) // rango inicial
 of_set_rango_fin(date('31/12/9999')) // rango final

end event

type sle_desc_concepto from singlelineedit within w_abc_fecha_concepto
integer x = 617
integer y = 20
integer width = 1193
integer height = 88
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
borderstyle borderstyle = stylelowered!
end type

type sle_concepto from n_cst_textbox within w_abc_fecha_concepto
integer x = 329
integer y = 20
integer width = 288
integer height = 88
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
end type

event modified;call super::modified;String 	ls_desc, ls_codigo

ls_codigo = this.text
if ls_codigo = '' or IsNull(ls_codigo) then
	MessageBox('Aviso', 'Debe Ingresar un codigo de Cuadrilla')
	return
end if

SELECT desc_concep 
	INTO :ls_desc
FROM concepto 
where concep = :ls_codigo 
  and flag_estado = '1';


IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Concepto de planilla no existe o no esta activo, por favor verifique! ')
	return
end if

sle_desc_concepto.text = ls_desc
end event

event ue_dobleclick;call super::ue_dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "select concep as concepto, " &
		 + "desc_concep as descripcion_concepto " &
		 + "from concepto " &
		 + "where flag_estado = '1'"
				 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
if ls_codigo <> '' then
	this.text 			= ls_codigo
	sle_desc_concepto.text 	= ls_data
end if

end event

type st_1 from statictext within w_abc_fecha_concepto
integer x = 64
integer y = 36
integer width = 261
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Concepto:"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_aceptar from commandbutton within w_abc_fecha_concepto
integer x = 1115
integer y = 184
integer width = 402
integer height = 112
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aceptar"
boolean default = true
end type

event clicked;parent.event ue_Aceptar()
end event

type cb_cancelar from commandbutton within w_abc_fecha_concepto
integer x = 1550
integer y = 184
integer width = 402
integer height = 112
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancelar"
boolean cancel = true
end type

event clicked;parent.event ue_cancelar()
end event

