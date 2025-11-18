$PBExportHeader$w_rh716_pago_diario_des_jor.srw
forward
global type w_rh716_pago_diario_des_jor from w_report_smpl
end type
type cb_3 from commandbutton within w_rh716_pago_diario_des_jor
end type
type em_descripcion from editmask within w_rh716_pago_diario_des_jor
end type
type em_origen from editmask within w_rh716_pago_diario_des_jor
end type
type cb_procesar from commandbutton within w_rh716_pago_diario_des_jor
end type
type uo_2 from u_ingreso_rango_fechas within w_rh716_pago_diario_des_jor
end type
type gb_2 from groupbox within w_rh716_pago_diario_des_jor
end type
type uo_1 from u_ddlb_tipo_trabajador within w_rh716_pago_diario_des_jor
end type
end forward

global type w_rh716_pago_diario_des_jor from w_report_smpl
integer width = 4910
integer height = 1500
string title = "[RH716] Pago Diario Destajo - Jornal"
string menuname = "m_impresion"
cb_3 cb_3
em_descripcion em_descripcion
em_origen em_origen
cb_procesar cb_procesar
uo_2 uo_2
gb_2 gb_2
uo_1 uo_1
end type
global w_rh716_pago_diario_des_jor w_rh716_pago_diario_des_jor

on w_rh716_pago_diario_des_jor.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.cb_3=create cb_3
this.em_descripcion=create em_descripcion
this.em_origen=create em_origen
this.cb_procesar=create cb_procesar
this.uo_2=create uo_2
this.gb_2=create gb_2
this.uo_1=create uo_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_3
this.Control[iCurrent+2]=this.em_descripcion
this.Control[iCurrent+3]=this.em_origen
this.Control[iCurrent+4]=this.cb_procesar
this.Control[iCurrent+5]=this.uo_2
this.Control[iCurrent+6]=this.gb_2
this.Control[iCurrent+7]=this.uo_1
end on

on w_rh716_pago_diario_des_jor.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_3)
destroy(this.em_descripcion)
destroy(this.em_origen)
destroy(this.cb_procesar)
destroy(this.uo_2)
destroy(this.gb_2)
destroy(this.uo_1)
end on

event ue_retrieve;string ls_origen, ls_tipo_trabaj
date ld_fecha_ini, ld_fecha_fin 

ls_origen = string(em_origen.text)
ld_fecha_ini = uo_2.of_get_fecha1()
ld_fecha_fin = uo_2.of_get_fecha2()

ls_tipo_trabaj = uo_1.of_get_value()

dw_report.SetTransObject(SQLCA)
dw_report.retrieve(ls_origen, ls_tipo_trabaj, ld_fecha_ini, ld_fecha_fin)


dw_report.Object.t_titulo1.text = 'Del ' + string(ld_fecha_ini, 'dd/mm/yyyy') &
											 + 'Al ' + string(ld_fecha_fin, 'dd/mm/yyyy')


end event

event ue_open_pre;idw_1 = dw_report
idw_1.SetTransObject(sqlca)


end event

event ue_saveas;//Overrding
string ls_path, ls_file
int li_rc

li_rc = GetFileSaveName ( "Select File", &
   ls_path, ls_file, "XLS", &
   "All Files (*.*),*.*" , "C:\", 32770)

IF li_rc = 1 Then
   uf_save_dw_as_excel ( dw_report, ls_file )
End If
end event

type dw_report from w_report_smpl`dw_report within w_rh716_pago_diario_des_jor
integer x = 0
integer y = 224
integer width = 3689
integer height = 1000
integer taborder = 50
string dataobject = "d_rpt_pago_diario_des_jor_crt"
end type

event dw_report::clicked;call super::clicked;f_select_current_row(this)
end event

event dw_report::rowfocuschanged;call super::rowfocuschanged;f_select_current_row(this)
end event

type cb_3 from commandbutton within w_rh716_pago_diario_des_jor
integer x = 197
integer y = 72
integer width = 87
integer height = 80
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

type em_descripcion from editmask within w_rh716_pago_diario_des_jor
integer x = 293
integer y = 76
integer width = 759
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 12632256
boolean border = false
boolean displayonly = true
maskdatatype maskdatatype = stringmask!
end type

type em_origen from editmask within w_rh716_pago_diario_des_jor
integer x = 50
integer y = 76
integer width = 133
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 12632256
boolean border = false
alignment alignment = center!
boolean displayonly = true
maskdatatype maskdatatype = stringmask!
end type

type cb_procesar from commandbutton within w_rh716_pago_diario_des_jor
integer x = 3406
integer y = 16
integer width = 352
integer height = 152
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Generar"
end type

event clicked;Parent.Event ue_retrieve()
end event

type uo_2 from u_ingreso_rango_fechas within w_rh716_pago_diario_des_jor
integer x = 2080
integer y = 24
integer taborder = 40
boolean bringtotop = true
end type

event constructor;call super::constructor;of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
of_set_fecha(today(), today()) //para setear la fecha inicial
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final
// of_get_fecha1(), of_get_fecha2()  para leer las fechas

end event

on uo_2.destroy
call u_ingreso_rango_fechas::destroy
end on

type gb_2 from groupbox within w_rh716_pago_diario_des_jor
integer width = 1097
integer height = 212
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = " Seleccione Origen "
end type

type uo_1 from u_ddlb_tipo_trabajador within w_rh716_pago_diario_des_jor
integer x = 1125
integer taborder = 20
end type

on uo_1.destroy
call u_ddlb_tipo_trabajador::destroy
end on

