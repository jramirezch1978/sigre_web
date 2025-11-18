$PBExportHeader$w_rh456_p_actualiza_concepto_fijo.srw
forward
global type w_rh456_p_actualiza_concepto_fijo from w_prc
end type
type st_3 from statictext within w_rh456_p_actualiza_concepto_fijo
end type
type dw_1 from datawindow within w_rh456_p_actualiza_concepto_fijo
end type
type cb_1 from commandbutton within w_rh456_p_actualiza_concepto_fijo
end type
type em_origen from editmask within w_rh456_p_actualiza_concepto_fijo
end type
type em_descripcion from editmask within w_rh456_p_actualiza_concepto_fijo
end type
type rb_1 from radiobutton within w_rh456_p_actualiza_concepto_fijo
end type
type rb_2 from radiobutton within w_rh456_p_actualiza_concepto_fijo
end type
type rb_3 from radiobutton within w_rh456_p_actualiza_concepto_fijo
end type
type cb_3 from commandbutton within w_rh456_p_actualiza_concepto_fijo
end type
type em_concepto from editmask within w_rh456_p_actualiza_concepto_fijo
end type
type em_desc_concep from editmask within w_rh456_p_actualiza_concepto_fijo
end type
type em_importe from editmask within w_rh456_p_actualiza_concepto_fijo
end type
type st_4 from statictext within w_rh456_p_actualiza_concepto_fijo
end type
type cb_4 from commandbutton within w_rh456_p_actualiza_concepto_fijo
end type
type uo_1 from u_ddlb_tipo_trabajador within w_rh456_p_actualiza_concepto_fijo
end type
type gb_1 from groupbox within w_rh456_p_actualiza_concepto_fijo
end type
type gb_2 from groupbox within w_rh456_p_actualiza_concepto_fijo
end type
type gb_3 from groupbox within w_rh456_p_actualiza_concepto_fijo
end type
type r_1 from rectangle within w_rh456_p_actualiza_concepto_fijo
end type
type r_2 from rectangle within w_rh456_p_actualiza_concepto_fijo
end type
end forward

global type w_rh456_p_actualiza_concepto_fijo from w_prc
integer width = 2811
integer height = 1744
string title = "(RH456) Actualiza Conceptos Fijos por Trabajador"
st_3 st_3
dw_1 dw_1
cb_1 cb_1
em_origen em_origen
em_descripcion em_descripcion
rb_1 rb_1
rb_2 rb_2
rb_3 rb_3
cb_3 cb_3
em_concepto em_concepto
em_desc_concep em_desc_concep
em_importe em_importe
st_4 st_4
cb_4 cb_4
uo_1 uo_1
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
r_1 r_1
r_2 r_2
end type
global w_rh456_p_actualiza_concepto_fijo w_rh456_p_actualiza_concepto_fijo

on w_rh456_p_actualiza_concepto_fijo.create
int iCurrent
call super::create
this.st_3=create st_3
this.dw_1=create dw_1
this.cb_1=create cb_1
this.em_origen=create em_origen
this.em_descripcion=create em_descripcion
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rb_3=create rb_3
this.cb_3=create cb_3
this.em_concepto=create em_concepto
this.em_desc_concep=create em_desc_concep
this.em_importe=create em_importe
this.st_4=create st_4
this.cb_4=create cb_4
this.uo_1=create uo_1
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
this.r_1=create r_1
this.r_2=create r_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_3
this.Control[iCurrent+2]=this.dw_1
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.em_origen
this.Control[iCurrent+5]=this.em_descripcion
this.Control[iCurrent+6]=this.rb_1
this.Control[iCurrent+7]=this.rb_2
this.Control[iCurrent+8]=this.rb_3
this.Control[iCurrent+9]=this.cb_3
this.Control[iCurrent+10]=this.em_concepto
this.Control[iCurrent+11]=this.em_desc_concep
this.Control[iCurrent+12]=this.em_importe
this.Control[iCurrent+13]=this.st_4
this.Control[iCurrent+14]=this.cb_4
this.Control[iCurrent+15]=this.uo_1
this.Control[iCurrent+16]=this.gb_1
this.Control[iCurrent+17]=this.gb_2
this.Control[iCurrent+18]=this.gb_3
this.Control[iCurrent+19]=this.r_1
this.Control[iCurrent+20]=this.r_2
end on

on w_rh456_p_actualiza_concepto_fijo.destroy
call super::destroy
destroy(this.st_3)
destroy(this.dw_1)
destroy(this.cb_1)
destroy(this.em_origen)
destroy(this.em_descripcion)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_3)
destroy(this.cb_3)
destroy(this.em_concepto)
destroy(this.em_desc_concep)
destroy(this.em_importe)
destroy(this.st_4)
destroy(this.cb_4)
destroy(this.uo_1)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_3)
destroy(this.r_1)
destroy(this.r_2)
end on

event open;call super::open;dw_1.settransobject(SQLCA)

long ll_x,ll_y
ll_x = (w_main.WorkSpaceWidth() - This.WorkSpaceWidth()) / 2
ll_y = ((w_main.WorkSpaceHeight() - This.WorkSpaceHeight()) / 2) - 150
This.move(ll_x,ll_y)

end event

type st_3 from statictext within w_rh456_p_actualiza_concepto_fijo
integer x = 1266
integer y = 1416
integer width = 247
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
boolean enabled = false
string text = "Avance"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type dw_1 from datawindow within w_rh456_p_actualiza_concepto_fijo
integer x = 192
integer y = 692
integer width = 2354
integer height = 644
string dataobject = "d_lista_actualiza_concepto_tbl"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_1 from commandbutton within w_rh456_p_actualiza_concepto_fijo
integer x = 1221
integer y = 564
integer width = 293
integer height = 76
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Generar"
end type

event clicked;Parent.SetMicroHelp('Actualizando Conceptos de Ganancias o Descuentos Fijos')

string  ls_origen, ls_codtra, ls_mensaje, ls_tipo_trabaj, ls_concepto, ls_tipope
double  ln_importe
Long    ln_reg_act, ln_reg_tot

ls_origen = string(em_origen.text)
ls_concepto = string(em_concepto.text)
ln_importe = double(em_importe.text)

if rb_1.checked = true then
	ls_tipope = 'A'
elseif rb_2.checked = true then
	ls_tipope = 'M'
elseif rb_3.checked = true then
	ls_tipope = 'E'
end if ;

ls_tipo_trabaj = uo_1.of_get_value()

if uo_1.cbx_todos.checked = false then
	dw_1.dataobject = 'd_lista_actualiza_concepto_tbl'
	dw_1.settransobject(sqlca)
	ln_reg_tot = dw_1.Retrieve(ls_origen, ls_tipo_trabaj) 
else
	dw_1.dataobject = 'd_lista_actualiza_concepto_todo_tbl'
	dw_1.settransobject(sqlca)
	ln_reg_tot = dw_1.Retrieve(ls_origen) 
end if

r_2.width  = 0
st_3.x     = r_2.x + 50
st_3.width = 2000
st_3.Text  = 'Seleccionando trabajadores para realizar proceso'
st_3.width = 220

DECLARE pb_usp_rh_actualiza_concepto_fijo PROCEDURE FOR USP_RH_ACTUALIZA_CONCEPTO_FIJO
        ( :ls_codtra, :ls_tipope, :ls_concepto, :ln_importe ) ;

FOR ln_reg_act = 1 TO ln_reg_tot
	 dw_1.ScrollToRow (ln_reg_act)
	 dw_1.SelectRow (0, false)
	 dw_1.SelectRow (ln_reg_act, true)
	 
    ls_codtra = dw_1.GetItemString (ln_reg_act, "cod_trabajador")
    EXECUTE pb_usp_rh_actualiza_concepto_fijo ;
	
	 r_2.width = ln_reg_act / ln_reg_tot * r_1.width
	 st_3.Text = String(ln_reg_act / ln_reg_tot * 100, '##0.00') + '%'
    st_3.x = r_2.x + r_2.width
NEXT

if SQLCA.SQLCode = -1 then
  ls_mensaje = sqlca.sqlerrtext
  rollback ;
  MessageBox("SQL error", ls_mensaje, StopSign!)
  MessageBox('Atención','No se realizó actualización de conceptos', Exclamation! )
  Parent.SetMicroHelp('Proceso no se realizó con Exito')
else
  commit ;
  Parent.SetMicroHelp('Proceso ha concluído Satisfactoriamente')
end if

end event

type em_origen from editmask within w_rh456_p_actualiza_concepto_fijo
integer x = 123
integer y = 124
integer width = 151
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
alignment alignment = center!
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type em_descripcion from editmask within w_rh456_p_actualiza_concepto_fijo
integer x = 434
integer y = 124
integer width = 1143
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type rb_1 from radiobutton within w_rh456_p_actualiza_concepto_fijo
integer x = 1705
integer y = 124
integer width = 288
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 79741120
string text = "Adiciona"
end type

type rb_2 from radiobutton within w_rh456_p_actualiza_concepto_fijo
integer x = 2039
integer y = 124
integer width = 279
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 79741120
string text = "Modifica"
end type

type rb_3 from radiobutton within w_rh456_p_actualiza_concepto_fijo
integer x = 2363
integer y = 124
integer width = 261
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 79741120
string text = "Elimina"
end type

type cb_3 from commandbutton within w_rh456_p_actualiza_concepto_fijo
integer x = 306
integer y = 124
integer width = 87
integer height = 72
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;// Abre ventana de ayuda 

str_parametros sl_param

sl_param.dw1 = "d_seleccion_origen_tbl"
sl_param.titulo = "Seleccionar Búsqueda"
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2

OpenWithParm( w_search_origen, sl_param)		
sl_param = MESSAGE.POWEROBJECTPARM
IF sl_param.titulo <> 'n' THEN
	em_origen.text      = sl_param.field_ret[1]
	em_descripcion.text = sl_param.field_ret[2]
END IF

end event

type em_concepto from editmask within w_rh456_p_actualiza_concepto_fijo
integer x = 169
integer y = 372
integer width = 151
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
alignment alignment = center!
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type em_desc_concep from editmask within w_rh456_p_actualiza_concepto_fijo
integer x = 480
integer y = 372
integer width = 677
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type em_importe from editmask within w_rh456_p_actualiza_concepto_fijo
integer x = 2313
integer y = 384
integer width = 302
integer height = 72
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
string text = "none"
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "###,###.00"
end type

type st_4 from statictext within w_rh456_p_actualiza_concepto_fijo
integer x = 2313
integer y = 292
integer width = 187
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 79741120
string text = "Importe"
boolean focusrectangle = false
end type

type cb_4 from commandbutton within w_rh456_p_actualiza_concepto_fijo
integer x = 352
integer y = 372
integer width = 87
integer height = 72
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;// Abre ventana de ayuda 

str_parametros sl_param

sl_param.dw1 = "d_seleccion_concepto_tbl"
sl_param.titulo = "Seleccionar Búsqueda"
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2

OpenWithParm( w_search, sl_param)		
sl_param = MESSAGE.POWEROBJECTPARM
IF sl_param.titulo <> 'n' THEN
	em_concepto.text    = sl_param.field_ret[1]
	em_desc_concep.text = sl_param.field_ret[2]
END IF

end event

type uo_1 from u_ddlb_tipo_trabajador within w_rh456_p_actualiza_concepto_fijo
integer x = 1253
integer y = 284
end type

on uo_1.destroy
call u_ddlb_tipo_trabajador::destroy
end on

type gb_1 from groupbox within w_rh456_p_actualiza_concepto_fijo
integer x = 119
integer y = 300
integer width = 1093
integer height = 192
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = " Seleccione Concepto "
end type

type gb_2 from groupbox within w_rh456_p_actualiza_concepto_fijo
integer x = 78
integer y = 56
integer width = 1550
integer height = 180
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = " Seleccione Origen "
end type

type gb_3 from groupbox within w_rh456_p_actualiza_concepto_fijo
integer x = 1664
integer y = 56
integer width = 1010
integer height = 180
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = " Seleccione Opción "
end type

type r_1 from rectangle within w_rh456_p_actualiza_concepto_fijo
long linecolor = 33554432
integer linethickness = 4
long fillcolor = 12632256
integer x = 192
integer y = 1416
integer width = 2121
integer height = 72
end type

type r_2 from rectangle within w_rh456_p_actualiza_concepto_fijo
long linecolor = 33554432
integer linethickness = 4
long fillcolor = 8421504
integer x = 192
integer y = 1416
integer width = 1879
integer height = 72
end type

