$PBExportHeader$w_rh450_p_calcula_provision_cts.srw
forward
global type w_rh450_p_calcula_provision_cts from w_prc
end type
type uo_grati from u_ingreso_fecha within w_rh450_p_calcula_provision_cts
end type
type uo_cts from u_ingreso_rango_fechas within w_rh450_p_calcula_provision_cts
end type
type uo_proceso from u_ingreso_fecha within w_rh450_p_calcula_provision_cts
end type
type st_3 from statictext within w_rh450_p_calcula_provision_cts
end type
type dw_1 from datawindow within w_rh450_p_calcula_provision_cts
end type
type cb_1 from commandbutton within w_rh450_p_calcula_provision_cts
end type
type cb_2 from commandbutton within w_rh450_p_calcula_provision_cts
end type
type em_origen from editmask within w_rh450_p_calcula_provision_cts
end type
type em_descripcion from editmask within w_rh450_p_calcula_provision_cts
end type
type uo_1 from u_ddlb_tipo_trabajador within w_rh450_p_calcula_provision_cts
end type
type gb_1 from groupbox within w_rh450_p_calcula_provision_cts
end type
type gb_2 from groupbox within w_rh450_p_calcula_provision_cts
end type
type gb_3 from groupbox within w_rh450_p_calcula_provision_cts
end type
type gb_4 from groupbox within w_rh450_p_calcula_provision_cts
end type
type r_1 from rectangle within w_rh450_p_calcula_provision_cts
end type
type r_2 from rectangle within w_rh450_p_calcula_provision_cts
end type
end forward

global type w_rh450_p_calcula_provision_cts from w_prc
integer width = 2656
integer height = 1588
string title = "(RH450) Calcula Provisiones por Compensación por Tiempo de Servicios"
uo_grati uo_grati
uo_cts uo_cts
uo_proceso uo_proceso
st_3 st_3
dw_1 dw_1
cb_1 cb_1
cb_2 cb_2
em_origen em_origen
em_descripcion em_descripcion
uo_1 uo_1
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
gb_4 gb_4
r_1 r_1
r_2 r_2
end type
global w_rh450_p_calcula_provision_cts w_rh450_p_calcula_provision_cts

on w_rh450_p_calcula_provision_cts.create
int iCurrent
call super::create
this.uo_grati=create uo_grati
this.uo_cts=create uo_cts
this.uo_proceso=create uo_proceso
this.st_3=create st_3
this.dw_1=create dw_1
this.cb_1=create cb_1
this.cb_2=create cb_2
this.em_origen=create em_origen
this.em_descripcion=create em_descripcion
this.uo_1=create uo_1
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
this.gb_4=create gb_4
this.r_1=create r_1
this.r_2=create r_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_grati
this.Control[iCurrent+2]=this.uo_cts
this.Control[iCurrent+3]=this.uo_proceso
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.dw_1
this.Control[iCurrent+6]=this.cb_1
this.Control[iCurrent+7]=this.cb_2
this.Control[iCurrent+8]=this.em_origen
this.Control[iCurrent+9]=this.em_descripcion
this.Control[iCurrent+10]=this.uo_1
this.Control[iCurrent+11]=this.gb_1
this.Control[iCurrent+12]=this.gb_2
this.Control[iCurrent+13]=this.gb_3
this.Control[iCurrent+14]=this.gb_4
this.Control[iCurrent+15]=this.r_1
this.Control[iCurrent+16]=this.r_2
end on

on w_rh450_p_calcula_provision_cts.destroy
call super::destroy
destroy(this.uo_grati)
destroy(this.uo_cts)
destroy(this.uo_proceso)
destroy(this.st_3)
destroy(this.dw_1)
destroy(this.cb_1)
destroy(this.cb_2)
destroy(this.em_origen)
destroy(this.em_descripcion)
destroy(this.uo_1)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_3)
destroy(this.gb_4)
destroy(this.r_1)
destroy(this.r_2)
end on

event open;call super::open;dw_1.settransobject(SQLCA)

long ll_x,ll_y
ll_x = (w_main.WorkSpaceWidth() - This.WorkSpaceWidth()) / 2
ll_y = ((w_main.WorkSpaceHeight() - This.WorkSpaceHeight()) / 2) - 150
This.move(ll_x,ll_y)

end event

type uo_grati from u_ingreso_fecha within w_rh450_p_calcula_provision_cts
event destroy ( )
integer x = 146
integer y = 556
integer taborder = 40
end type

on uo_grati.destroy
call u_ingreso_fecha::destroy
end on

type uo_cts from u_ingreso_rango_fechas within w_rh450_p_calcula_provision_cts
event destroy ( )
integer x = 1170
integer y = 344
integer taborder = 40
end type

on uo_cts.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor; of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
 of_set_fecha(today(), today()) //para setear la fecha inicial
 of_set_rango_inicio(date('01/01/1900')) // rango inicial
 of_set_rango_fin(date('31/12/9999')) // rango final
// of_get_fecha1(), of_get_fecha2()  para leer las fechas

end event

type uo_proceso from u_ingreso_fecha within w_rh450_p_calcula_provision_cts
event destroy ( )
integer x = 96
integer y = 336
integer height = 96
integer taborder = 40
end type

on uo_proceso.destroy
call u_ingreso_fecha::destroy
end on

event constructor;call super::constructor; of_set_label('Proceso:') // para seatear el titulo del boton
 of_set_fecha(today()) //para setear la fecha inicial
 of_set_rango_inicio(date('01/01/1900')) // rango inicial
 of_set_rango_fin(date('31/12/9999')) // rango final
 //of_get_fecha()  para leer las fechas

end event

type st_3 from statictext within w_rh450_p_calcula_provision_cts
integer x = 1189
integer y = 1240
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

type dw_1 from datawindow within w_rh450_p_calcula_provision_cts
integer x = 114
integer y = 716
integer width = 2354
integer height = 512
string dataobject = "d_listah_calculo_planilla_tbl"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_1 from commandbutton within w_rh450_p_calcula_provision_cts
integer x = 2162
integer y = 556
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

event clicked;Parent.SetMicroHelp('Calcula Provisiones por C.T.S.')

String  ls_origen, ls_codtra, ls_mensaje, ls_tipo_trabaj ,ls_msj_err
date    ld_fec_proceso, ld_fec_ini_cts, ld_fec_fin_cts, ld_fec_grati
long    ln_reg_act, ln_reg_tot
integer ln_sw
decimal ln_importe

ls_origen 		= string(em_origen.text)
ld_fec_proceso = uo_proceso.of_get_fecha()
ld_fec_ini_cts = uo_cts.of_get_fecha1()
ld_fec_fin_cts = uo_cts.of_get_fecha1()
ld_fec_grati 	= uo_grati.of_get_fecha()

ls_tipo_trabaj = uo_1.of_get_value()

dw_1.dataobject = 'd_listah_calculo_planilla_tbl'
dw_1.settransobject(sqlca)
ln_reg_tot = dw_1.Retrieve(ls_origen, ls_tipo_trabaj, ld_fec_proceso) 


r_2.width  = 0
st_3.x     = r_2.x + 50
st_3.width = 2000
st_3.Text  = 'Seleccionando trabajadores para realizar proceso'
st_3.width = 220

DECLARE pb_usp_rh_calcula_provision_cts PROCEDURE FOR USP_RH_CALCULA_PROVISION_CTS
        ( :ls_codtra, :ld_fec_proceso ,:ld_fec_ini_cts, :ld_fec_fin_cts, :ld_fec_grati) ;

FOR ln_reg_act = 1 TO ln_reg_tot
	 dw_1.ScrollToRow (ln_reg_act)
	 dw_1.SelectRow (0, false)
	 dw_1.SelectRow (ln_reg_act, true)
	 
    ls_codtra = dw_1.GetItemString (ln_reg_act, "cod_trabajador")
    EXECUTE pb_usp_rh_calcula_provision_cts ;
	
	 r_2.width = ln_reg_act / ln_reg_tot * r_1.width
	 st_3.Text = String(ln_reg_act / ln_reg_tot * 100, '##0.00') + '%'
    st_3.x = r_2.x + r_2.width
NEXT

if SQLCA.SQLCode = -1 then
  ls_mensaje = sqlca.sqlerrtext
  rollback ;
  MessageBox("SQL error", ls_mensaje, StopSign!)
  MessageBox('Atención','No se realizó calculo de provisión de C.T.S.', Exclamation! )
  Parent.SetMicroHelp('Proceso no se realizó con Exito')
else
  commit ;
  Parent.SetMicroHelp('Proceso ha concluído Satisfactoriamente')
end if

end event

type cb_2 from commandbutton within w_rh450_p_calcula_provision_cts
integer x = 334
integer y = 120
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

type em_origen from editmask within w_rh450_p_calcula_provision_cts
integer x = 151
integer y = 120
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

type em_descripcion from editmask within w_rh450_p_calcula_provision_cts
integer x = 462
integer y = 120
integer width = 1051
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

type uo_1 from u_ddlb_tipo_trabajador within w_rh450_p_calcula_provision_cts
integer x = 1591
integer y = 36
end type

on uo_1.destroy
call u_ddlb_tipo_trabajador::destroy
end on

type gb_1 from groupbox within w_rh450_p_calcula_provision_cts
integer x = 87
integer y = 48
integer width = 1477
integer height = 200
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = " Seleccione Origen "
end type

type gb_2 from groupbox within w_rh450_p_calcula_provision_cts
integer x = 1106
integer y = 260
integer width = 1422
integer height = 216
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Período CTS"
end type

type gb_3 from groupbox within w_rh450_p_calcula_provision_cts
integer x = 78
integer y = 272
integer width = 663
integer height = 188
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Fecha proceso"
end type

type gb_4 from groupbox within w_rh450_p_calcula_provision_cts
integer x = 101
integer y = 480
integer width = 827
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
string text = "Ultima gratificación"
end type

type r_1 from rectangle within w_rh450_p_calcula_provision_cts
long linecolor = 33554432
integer linethickness = 4
long fillcolor = 12632256
integer x = 114
integer y = 1336
integer width = 2322
integer height = 72
end type

type r_2 from rectangle within w_rh450_p_calcula_provision_cts
long linecolor = 33554432
integer linethickness = 4
long fillcolor = 8421504
integer x = 114
integer y = 1336
integer width = 1879
integer height = 72
end type

