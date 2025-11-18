$PBExportHeader$w_rh422_p_calcula_intereses_cts.srw
forward
global type w_rh422_p_calcula_intereses_cts from w_prc
end type
type st_3 from statictext within w_rh422_p_calcula_intereses_cts
end type
type dw_1 from datawindow within w_rh422_p_calcula_intereses_cts
end type
type cb_1 from commandbutton within w_rh422_p_calcula_intereses_cts
end type
type em_origen from editmask within w_rh422_p_calcula_intereses_cts
end type
type em_descripcion from editmask within w_rh422_p_calcula_intereses_cts
end type
type cb_3 from commandbutton within w_rh422_p_calcula_intereses_cts
end type
type em_fec_proceso from editmask within w_rh422_p_calcula_intereses_cts
end type
type st_1 from statictext within w_rh422_p_calcula_intereses_cts
end type
type uo_1 from u_ddlb_tipo_trabajador within w_rh422_p_calcula_intereses_cts
end type
type gb_1 from groupbox within w_rh422_p_calcula_intereses_cts
end type
type r_1 from rectangle within w_rh422_p_calcula_intereses_cts
end type
type r_2 from rectangle within w_rh422_p_calcula_intereses_cts
end type
end forward

global type w_rh422_p_calcula_intereses_cts from w_prc
integer width = 2761
integer height = 1556
string title = "(RH422) Calcula Intereses de Depósitos de C.T.S."
boolean center = true
st_3 st_3
dw_1 dw_1
cb_1 cb_1
em_origen em_origen
em_descripcion em_descripcion
cb_3 cb_3
em_fec_proceso em_fec_proceso
st_1 st_1
uo_1 uo_1
gb_1 gb_1
r_1 r_1
r_2 r_2
end type
global w_rh422_p_calcula_intereses_cts w_rh422_p_calcula_intereses_cts

on w_rh422_p_calcula_intereses_cts.create
int iCurrent
call super::create
this.st_3=create st_3
this.dw_1=create dw_1
this.cb_1=create cb_1
this.em_origen=create em_origen
this.em_descripcion=create em_descripcion
this.cb_3=create cb_3
this.em_fec_proceso=create em_fec_proceso
this.st_1=create st_1
this.uo_1=create uo_1
this.gb_1=create gb_1
this.r_1=create r_1
this.r_2=create r_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_3
this.Control[iCurrent+2]=this.dw_1
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.em_origen
this.Control[iCurrent+5]=this.em_descripcion
this.Control[iCurrent+6]=this.cb_3
this.Control[iCurrent+7]=this.em_fec_proceso
this.Control[iCurrent+8]=this.st_1
this.Control[iCurrent+9]=this.uo_1
this.Control[iCurrent+10]=this.gb_1
this.Control[iCurrent+11]=this.r_1
this.Control[iCurrent+12]=this.r_2
end on

on w_rh422_p_calcula_intereses_cts.destroy
call super::destroy
destroy(this.st_3)
destroy(this.dw_1)
destroy(this.cb_1)
destroy(this.em_origen)
destroy(this.em_descripcion)
destroy(this.cb_3)
destroy(this.em_fec_proceso)
destroy(this.st_1)
destroy(this.uo_1)
destroy(this.gb_1)
destroy(this.r_1)
destroy(this.r_2)
end on

event open;call super::open;dw_1.settransobject(SQLCA)

end event

type st_3 from statictext within w_rh422_p_calcula_intereses_cts
integer x = 1074
integer y = 396
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

type dw_1 from datawindow within w_rh422_p_calcula_intereses_cts
integer y = 480
integer width = 2702
integer height = 960
string dataobject = "d_lista_actualiza_concepto_tbl"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_1 from commandbutton within w_rh422_p_calcula_intereses_cts
integer x = 1678
integer y = 300
integer width = 293
integer height = 76
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Generar"
end type

event clicked;Parent.SetMicroHelp('Calcula Intereses de los Depósitos de C.T.S.')

string ls_origen, ls_codtra, ls_mensaje, ls_tipo_trabaj
date   ld_fec_proceso
Long   ln_reg_act, ln_reg_tot

ls_origen = string(em_origen.text)
ld_fec_proceso = date(em_fec_proceso.text)

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

DECLARE pb_usp_rh_cts_calculo_intereses PROCEDURE FOR 
	USP_RH_CTS_CALCULO_INTERESES( :ls_codtra, :ld_fec_proceso ) ;

FOR ln_reg_act = 1 TO ln_reg_tot
	 dw_1.ScrollToRow (ln_reg_act)
	 dw_1.SelectRow (0, false)
	 dw_1.SelectRow (ln_reg_act, true)
	 
    ls_codtra = dw_1.GetItemString (ln_reg_act, "cod_trabajador")
    EXECUTE pb_usp_rh_cts_calculo_intereses ;
	
	 r_2.width = ln_reg_act / ln_reg_tot * r_1.width
	 st_3.Text = String(ln_reg_act / ln_reg_tot * 100, '##0.00') + '%'
    st_3.x = r_2.x + r_2.width
NEXT

if SQLCA.SQLCode = -1 then
  ls_mensaje = sqlca.sqlerrtext
  rollback ;
  MessageBox("SQL error", ls_mensaje, StopSign!)
  MessageBox('Atención','No se realizó cálculo de intereses de C.T.S.', Exclamation! )
  Parent.SetMicroHelp('Proceso no se realizó con Exito')
else
  commit ;
  Parent.SetMicroHelp('Proceso ha concluído Satisfactoriamente')
end if

end event

type em_origen from editmask within w_rh422_p_calcula_intereses_cts
integer x = 183
integer y = 124
integer width = 151
integer height = 76
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

type em_descripcion from editmask within w_rh422_p_calcula_intereses_cts
integer x = 485
integer y = 124
integer width = 1143
integer height = 76
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

type cb_3 from commandbutton within w_rh422_p_calcula_intereses_cts
integer x = 361
integer y = 128
integer width = 87
integer height = 68
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

type em_fec_proceso from editmask within w_rh422_p_calcula_intereses_cts
integer x = 1243
integer y = 300
integer width = 343
integer height = 76
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
alignment alignment = center!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "dd/mm/yyyy"
end type

type st_1 from statictext within w_rh422_p_calcula_intereses_cts
integer x = 754
integer y = 308
integer width = 430
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 67108864
string text = "Fecha de Proceso"
boolean focusrectangle = false
end type

type uo_1 from u_ddlb_tipo_trabajador within w_rh422_p_calcula_intereses_cts
integer x = 1705
integer y = 40
end type

on uo_1.destroy
call u_ddlb_tipo_trabajador::destroy
end on

type gb_1 from groupbox within w_rh422_p_calcula_intereses_cts
integer x = 133
integer y = 48
integer width = 1545
integer height = 200
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = " Seleccione Origen "
end type

type r_1 from rectangle within w_rh422_p_calcula_intereses_cts
long linecolor = 33554432
integer linethickness = 4
long fillcolor = 12632256
integer y = 396
integer width = 2702
integer height = 72
end type

type r_2 from rectangle within w_rh422_p_calcula_intereses_cts
long linecolor = 33554432
integer linethickness = 4
long fillcolor = 8421504
integer y = 396
integer width = 1879
integer height = 72
end type

