$PBExportHeader$w_rh451_p_calcula_provision_gra.srw
forward
global type w_rh451_p_calcula_provision_gra from w_prc
end type
type st_4 from statictext within w_rh451_p_calcula_provision_gra
end type
type st_2 from statictext within w_rh451_p_calcula_provision_gra
end type
type st_3 from statictext within w_rh451_p_calcula_provision_gra
end type
type dw_1 from datawindow within w_rh451_p_calcula_provision_gra
end type
type cb_1 from commandbutton within w_rh451_p_calcula_provision_gra
end type
type cb_2 from commandbutton within w_rh451_p_calcula_provision_gra
end type
type em_origen from editmask within w_rh451_p_calcula_provision_gra
end type
type em_descripcion from editmask within w_rh451_p_calcula_provision_gra
end type
type em_fec_proceso from editmask within w_rh451_p_calcula_provision_gra
end type
type st_1 from statictext within w_rh451_p_calcula_provision_gra
end type
type uo_1 from u_ddlb_tipo_trabajador within w_rh451_p_calcula_provision_gra
end type
type gb_1 from groupbox within w_rh451_p_calcula_provision_gra
end type
type r_1 from rectangle within w_rh451_p_calcula_provision_gra
end type
type r_2 from rectangle within w_rh451_p_calcula_provision_gra
end type
end forward

global type w_rh451_p_calcula_provision_gra from w_prc
integer width = 2574
integer height = 1704
string title = "(RH451) Calcula Provisiones de Gratificaciones"
st_4 st_4
st_2 st_2
st_3 st_3
dw_1 dw_1
cb_1 cb_1
cb_2 cb_2
em_origen em_origen
em_descripcion em_descripcion
em_fec_proceso em_fec_proceso
st_1 st_1
uo_1 uo_1
gb_1 gb_1
r_1 r_1
r_2 r_2
end type
global w_rh451_p_calcula_provision_gra w_rh451_p_calcula_provision_gra

on w_rh451_p_calcula_provision_gra.create
int iCurrent
call super::create
this.st_4=create st_4
this.st_2=create st_2
this.st_3=create st_3
this.dw_1=create dw_1
this.cb_1=create cb_1
this.cb_2=create cb_2
this.em_origen=create em_origen
this.em_descripcion=create em_descripcion
this.em_fec_proceso=create em_fec_proceso
this.st_1=create st_1
this.uo_1=create uo_1
this.gb_1=create gb_1
this.r_1=create r_1
this.r_2=create r_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_4
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.st_3
this.Control[iCurrent+4]=this.dw_1
this.Control[iCurrent+5]=this.cb_1
this.Control[iCurrent+6]=this.cb_2
this.Control[iCurrent+7]=this.em_origen
this.Control[iCurrent+8]=this.em_descripcion
this.Control[iCurrent+9]=this.em_fec_proceso
this.Control[iCurrent+10]=this.st_1
this.Control[iCurrent+11]=this.uo_1
this.Control[iCurrent+12]=this.gb_1
this.Control[iCurrent+13]=this.r_1
this.Control[iCurrent+14]=this.r_2
end on

on w_rh451_p_calcula_provision_gra.destroy
call super::destroy
destroy(this.st_4)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.dw_1)
destroy(this.cb_1)
destroy(this.cb_2)
destroy(this.em_origen)
destroy(this.em_descripcion)
destroy(this.em_fec_proceso)
destroy(this.st_1)
destroy(this.uo_1)
destroy(this.gb_1)
destroy(this.r_1)
destroy(this.r_2)
end on

event open;call super::open;dw_1.settransobject(SQLCA)

long ll_x,ll_y
ll_x = (w_main.WorkSpaceWidth() - This.WorkSpaceWidth()) / 2
ll_y = ((w_main.WorkSpaceHeight() - This.WorkSpaceHeight()) / 2) - 150
This.move(ll_x,ll_y)

end event

type st_4 from statictext within w_rh451_p_calcula_provision_gra
integer x = 78
integer y = 1464
integer width = 2382
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "que información se encuentre en el histórico."
boolean focusrectangle = false
end type

type st_2 from statictext within w_rh451_p_calcula_provision_gra
integer x = 73
integer y = 1384
integer width = 2382
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "El sistema capturará información histórica para calcular promedio de horas extras. Asegurese"
boolean focusrectangle = false
end type

type st_3 from statictext within w_rh451_p_calcula_provision_gra
integer x = 1189
integer y = 1248
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

type dw_1 from datawindow within w_rh451_p_calcula_provision_gra
integer x = 114
integer y = 452
integer width = 2354
integer height = 704
string dataobject = "d_listah_calculo_planilla_tbl"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_1 from commandbutton within w_rh451_p_calcula_provision_gra
integer x = 1563
integer y = 332
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

event clicked;Parent.SetMicroHelp('Calcula Provisiones de Gratificaciones')

string ls_origen, ls_codtra, ls_mensaje, ls_tipo_trabaj
date   ld_fec_proceso
Long   ln_reg_act, ln_reg_tot

ls_origen = string(em_origen.text)
ld_fec_proceso = date(em_fec_proceso.text)

ls_tipo_trabaj = uo_1.of_get_value()


dw_1.dataobject = 'd_listah_calculo_planilla_tbl'
dw_1.settransobject(sqlca)
ln_reg_tot = dw_1.Retrieve(ls_origen, ls_tipo_trabaj, ld_fec_proceso) 

//
//if uo_1.cbx_1.checked = false then
//	ls_tipo_trabaj = trim(right(uo_1.ddlb_1.text,3))
//	dw_1.dataobject = 'd_lista_calculo_planilla_tbl'
//	dw_1.settransobject(sqlca)
//	ln_reg_tot = dw_1.Retrieve(ls_origen, ls_tipo_trabaj) 
//else
//	dw_1.dataobject = 'd_lista_calculo_planilla_todo_tbl'
//	dw_1.settransobject(sqlca)
//	ln_reg_tot = dw_1.Retrieve(ls_origen) 
//end if
//
r_2.width  = 0
st_3.x     = r_2.x + 50
st_3.width = 2000
st_3.Text  = 'Seleccionando trabajadores para realizar proceso'
st_3.width = 220

DECLARE pb_usp_rh_calcula_provision_gra PROCEDURE FOR USP_RH_CALCULA_PROVISION_GRA
        ( :ls_codtra, :ld_fec_proceso ) ;

FOR ln_reg_act = 1 TO ln_reg_tot
	 dw_1.ScrollToRow (ln_reg_act)
	 dw_1.SelectRow (0, false)
	 dw_1.SelectRow (ln_reg_act, true)
	 
    ls_codtra = dw_1.GetItemString (ln_reg_act, "cod_trabajador")
    EXECUTE pb_usp_rh_calcula_provision_gra ;
	
	 r_2.width = ln_reg_act / ln_reg_tot * r_1.width
	 st_3.Text = String(ln_reg_act / ln_reg_tot * 100, '##0.00') + '%'
    st_3.x = r_2.x + r_2.width
NEXT

if SQLCA.SQLCode = -1 then
  ls_mensaje = sqlca.sqlerrtext
  rollback ;
  MessageBox("SQL error", ls_mensaje, StopSign!)
  MessageBox('Atención','No se realizó calculo de provisión de Gratificación', Exclamation! )
  Parent.SetMicroHelp('Proceso no se realizó con Exito')
else
  commit ;
  Parent.SetMicroHelp('Proceso ha concluído Satisfactoriamente')
end if

end event

type cb_2 from commandbutton within w_rh451_p_calcula_provision_gra
integer x = 352
integer y = 140
integer width = 87
integer height = 76
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

type em_origen from editmask within w_rh451_p_calcula_provision_gra
integer x = 169
integer y = 140
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

type em_descripcion from editmask within w_rh451_p_calcula_provision_gra
integer x = 480
integer y = 140
integer width = 1006
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

type em_fec_proceso from editmask within w_rh451_p_calcula_provision_gra
integer x = 1193
integer y = 340
integer width = 325
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

type st_1 from statictext within w_rh451_p_calcula_provision_gra
integer x = 709
integer y = 340
integer width = 443
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
alignment alignment = center!
boolean focusrectangle = false
end type

type uo_1 from u_ddlb_tipo_trabajador within w_rh451_p_calcula_provision_gra
integer x = 1586
integer y = 52
end type

on uo_1.destroy
call u_ddlb_tipo_trabajador::destroy
end on

type gb_1 from groupbox within w_rh451_p_calcula_provision_gra
integer x = 110
integer y = 72
integer width = 1426
integer height = 188
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = " Seleccione Origen "
end type

type r_1 from rectangle within w_rh451_p_calcula_provision_gra
long linecolor = 33554432
integer linethickness = 4
long fillcolor = 12632256
integer x = 114
integer y = 1248
integer width = 2121
integer height = 72
end type

type r_2 from rectangle within w_rh451_p_calcula_provision_gra
long linecolor = 33554432
integer linethickness = 4
long fillcolor = 8421504
integer x = 114
integer y = 1248
integer width = 1879
integer height = 72
end type

