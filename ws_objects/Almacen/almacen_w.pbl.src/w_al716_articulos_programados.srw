$PBExportHeader$w_al716_articulos_programados.srw
forward
global type w_al716_articulos_programados from w_report_smpl
end type
type gb_1 from groupbox within w_al716_articulos_programados
end type
type cb_3 from commandbutton within w_al716_articulos_programados
end type
type uo_fechas from u_ingreso_rango_fechas within w_al716_articulos_programados
end type
end forward

global type w_al716_articulos_programados from w_report_smpl
integer width = 3456
integer height = 1956
string title = "Movimientos por tipo de Operación (AL716)"
string menuname = "m_impresion"
windowstate windowstate = maximized!
long backcolor = 12632256
gb_1 gb_1
cb_3 cb_3
uo_fechas uo_fechas
end type
global w_al716_articulos_programados w_al716_articulos_programados

type variables
Integer ii_index
end variables

on w_al716_articulos_programados.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.gb_1=create gb_1
this.cb_3=create cb_3
this.uo_fechas=create uo_fechas
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_1
this.Control[iCurrent+2]=this.cb_3
this.Control[iCurrent+3]=this.uo_fechas
end on

on w_al716_articulos_programados.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_1)
destroy(this.cb_3)
destroy(this.uo_fechas)
end on

event ue_retrieve();call super::ue_retrieve;Date ld_fec_ini, ld_fec_fin
string ls_operacion, ls_alm

ld_fec_ini = uo_fechas.of_get_fecha1()
ld_fec_fin = uo_fechas.of_get_fecha2()

dw_report.retrieve(ld_fec_ini, ld_fec_fin)
dw_report.object.t_user.text = gs_user
dw_report.object.t_tit1.text = "En Nuevos Soles  del: " + &
    String( ld_fec_ini, 'dd/mm/yyyy') + ' AL ' + &
	 String( ld_fec_fin, 'dd/mm/yyyy') 
//dw_report.object.t_tit2.text = "Operacion: " + ddlb_1.text
//dw_report.object.t_tit3.text = ddlb_almacen.text
dw_report.Object.p_logo.filename = gs_logo


end event

type dw_report from w_report_smpl`dw_report within w_al716_articulos_programados
integer x = 32
integer y = 240
integer width = 3342
integer height = 1316
string dataobject = "d_rpt_material_programado"
end type

type gb_1 from groupbox within w_al716_articulos_programados
integer x = 50
integer y = 24
integer width = 1490
integer height = 196
integer taborder = 10
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "  Fechas  : "
end type

type cb_3 from commandbutton within w_al716_articulos_programados
integer x = 2926
integer y = 20
integer width = 402
integer height = 112
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Reporte"
end type

event clicked;Parent.event ue_retrieve()


end event

type uo_fechas from u_ingreso_rango_fechas within w_al716_articulos_programados
integer x = 137
integer y = 112
integer taborder = 40
boolean bringtotop = true
end type

event constructor;call super::constructor;String ls_desde
 
 of_set_label('Del:','Al:') 								//	para setear la fecha inicial
 
 ls_desde = '01/' + string(month(today()))+'/' + string(year(today()))
 of_set_fecha(date(ls_desde), today()) 				// para seatear el titulo del boton
 of_set_rango_inicio(date('01/01/1900')) 				// rango inicial
 of_set_rango_fin(date('31/12/9999'))					// rango final
end event

on uo_fechas.destroy
call u_ingreso_rango_fechas::destroy
end on

