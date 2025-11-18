$PBExportHeader$w_rh721_resumen_planilla.srw
forward
global type w_rh721_resumen_planilla from w_report_smpl
end type
type uo_1 from u_ingreso_rango_fechas within w_rh721_resumen_planilla
end type
type ddlb_origen from u_ddlb within w_rh721_resumen_planilla
end type
type st_1 from statictext within w_rh721_resumen_planilla
end type
type cb_1 from commandbutton within w_rh721_resumen_planilla
end type
type ddlb_tipo_trabaj from u_ddlb within w_rh721_resumen_planilla
end type
type st_2 from statictext within w_rh721_resumen_planilla
end type
type gb_1 from groupbox within w_rh721_resumen_planilla
end type
end forward

global type w_rh721_resumen_planilla from w_report_smpl
integer width = 3749
integer height = 1832
string title = "[RH721] Resumen de Planilla"
string menuname = "m_reporte"
uo_1 uo_1
ddlb_origen ddlb_origen
st_1 st_1
cb_1 cb_1
ddlb_tipo_trabaj ddlb_tipo_trabaj
st_2 st_2
gb_1 gb_1
end type
global w_rh721_resumen_planilla w_rh721_resumen_planilla

on w_rh721_resumen_planilla.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.uo_1=create uo_1
this.ddlb_origen=create ddlb_origen
this.st_1=create st_1
this.cb_1=create cb_1
this.ddlb_tipo_trabaj=create ddlb_tipo_trabaj
this.st_2=create st_2
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_1
this.Control[iCurrent+2]=this.ddlb_origen
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.cb_1
this.Control[iCurrent+5]=this.ddlb_tipo_trabaj
this.Control[iCurrent+6]=this.st_2
this.Control[iCurrent+7]=this.gb_1
end on

on w_rh721_resumen_planilla.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_1)
destroy(this.ddlb_origen)
destroy(this.st_1)
destroy(this.cb_1)
destroy(this.ddlb_tipo_trabaj)
destroy(this.st_2)
destroy(this.gb_1)
end on

event ue_retrieve;call super::ue_retrieve;String ls_origen, ls_tipo_trabajador, ls_desc_origen, ls_desc_tipo_trab
Date ld_fecha_ini, ld_fecha_fin

ls_origen = trim(left(ddlb_origen.text,2))
ls_desc_origen = MID(trim(ddlb_origen.text),5,18)
ls_tipo_trabajador = trim(left(ddlb_tipo_trabaj.text,3))
ls_desc_tipo_trab = MID(trim(ddlb_tipo_trabaj.text),6,25)

ld_fecha_ini = uo_1.of_get_fecha1()
ld_fecha_fin = uo_1.of_get_fecha2()  

dw_report.Retrieve(ls_origen, ls_tipo_trabajador, ld_fecha_ini, ld_fecha_fin)

dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_texto.text = TRIM(ls_desc_origen) + ' - ' + &
										  TRIM(ls_desc_tipo_trab) + ', del ' + &
										  STRING(ld_fecha_ini, 'dd/mm/yyyy') + ' al ' + &
										  STRING(ld_fecha_fin, 'dd/mm/yyyy')
dw_report.object.t_empresa.text = gs_empresa
dw_report.object.t_objeto.text = 'w_rh721'
dw_report.object.t_user.text = gs_user


end event

type dw_report from w_report_smpl`dw_report within w_rh721_resumen_planilla
integer x = 0
integer y = 328
integer width = 3333
integer height = 1232
string dataobject = "d_rpt_resumen_plla_tbl"
end type

type uo_1 from u_ingreso_rango_fechas within w_rh721_resumen_planilla
integer x = 37
integer y = 188
integer taborder = 30
boolean bringtotop = true
end type

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
of_set_fecha(today(), today()) //para setear la fecha inicial
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final
// of_get_fecha1(), of_get_fecha2()  para leer las fechas

end event

type ddlb_origen from u_ddlb within w_rh721_resumen_planilla
integer x = 274
integer y = 72
integer width = 800
integer height = 468
integer taborder = 20
boolean bringtotop = true
end type

event ue_open_pre;call super::ue_open_pre;is_dataobject = 'd_lista_origen_todos_tbl'

ii_cn1 = 1                     // Nro del campo 1
ii_cn2 = 2                     // Nro del campo 2
ii_ck  = 1                     // Nro del campo key
ii_lc1 = 4                     // Longitud del campo 1
ii_lc2 = 18							// Longitud del campo 2

end event

event ue_output;call super::ue_output;//dw_master.Retrieve(aa_key)

end event

type st_1 from statictext within w_rh721_resumen_planilla
integer x = 55
integer y = 72
integer width = 210
integer height = 92
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Origen: "
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_rh721_resumen_planilla
integer x = 2907
integer y = 124
integer width = 402
integer height = 112
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Reporte"
end type

event clicked;Trigger Event ue_retrieve()
end event

type ddlb_tipo_trabaj from u_ddlb within w_rh721_resumen_planilla
integer x = 1979
integer y = 72
integer width = 805
integer height = 504
integer taborder = 20
boolean bringtotop = true
end type

event ue_open_pre;call super::ue_open_pre;is_dataobject = 'd_lista_tipo_trabaj_todos_tbl'

ii_cn1 = 1                     // Nro del campo 1
ii_cn2 = 2                     // Nro del campo 2
ii_ck  = 1                     // Nro del campo key
ii_lc1 = 5                     // Longitud del campo 1
ii_lc2 = 25							// Longitud del campo 2

end event

type st_2 from statictext within w_rh721_resumen_planilla
integer x = 1445
integer y = 72
integer width = 521
integer height = 92
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Tipo de trabajador :"
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_rh721_resumen_planilla
integer width = 2848
integer height = 300
integer taborder = 40
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Parametros de reporte"
end type

