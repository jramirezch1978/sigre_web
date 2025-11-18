$PBExportHeader$w_ve716_ov_fact_gr.srw
forward
global type w_ve716_ov_fact_gr from w_report_smpl
end type
type gb_1 from groupbox within w_ve716_ov_fact_gr
end type
type uo_fechas from u_ingreso_rango_fechas within w_ve716_ov_fact_gr
end type
type cb_4 from commandbutton within w_ve716_ov_fact_gr
end type
end forward

global type w_ve716_ov_fact_gr from w_report_smpl
integer width = 3456
integer height = 1956
string title = "[VE716] Orden Venta - Factura - Guia Remision"
string menuname = "m_reporte"
windowstate windowstate = maximized!
gb_1 gb_1
uo_fechas uo_fechas
cb_4 cb_4
end type
global w_ve716_ov_fact_gr w_ve716_ov_fact_gr

type variables
Integer ii_index
end variables

on w_ve716_ov_fact_gr.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.gb_1=create gb_1
this.uo_fechas=create uo_fechas
this.cb_4=create cb_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_1
this.Control[iCurrent+2]=this.uo_fechas
this.Control[iCurrent+3]=this.cb_4
end on

on w_ve716_ov_fact_gr.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_1)
destroy(this.uo_fechas)
destroy(this.cb_4)
end on

event ue_retrieve;call super::ue_retrieve;Date ld_fec_ini, ld_fec_fin
string ls_operacion, ls_alm

SETPOINTER( HOURGLASS!)

ld_fec_ini = uo_fechas.of_get_fecha1()
ld_fec_fin = uo_fechas.of_get_fecha2()

DECLARE PB_USP_PROC PROCEDURE FOR usp_alm_ov_fact_gr (:ld_fec_ini, :ld_fec_fin);
EXECUTE PB_USP_PROC;
If sqlca.sqlcode = -1 then
	messagebox("Error en usp_alm_ov_fact_gr", sqlca.sqlerrtext)
	return 
end if


dw_report.retrieve(ld_fec_ini, ld_fec_fin)
dw_report.object.t_user.text = gs_user
dw_report.object.t_tit1.text = "Del: " + &
    String( ld_fec_ini, 'dd/mm/yyyy') + ' AL ' + &
	 String( ld_fec_fin, 'dd/mm/yyyy') 
//dw_report.object.t_tit2.text = "Operacion: " + ddlb_1.text
//dw_report.object.t_tit3.text = ddlb_almacen.text
dw_report.Object.p_logo.filename = gs_logo


end event

type dw_report from w_report_smpl`dw_report within w_ve716_ov_fact_gr
integer x = 32
integer y = 240
integer width = 3342
integer height = 1316
string dataobject = "d_rpt_ov_fact_gr"
end type

type gb_1 from groupbox within w_ve716_ov_fact_gr
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
long backcolor = 67108864
string text = "  Fechas  : "
end type

type uo_fechas from u_ingreso_rango_fechas within w_ve716_ov_fact_gr
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

type cb_4 from commandbutton within w_ve716_ov_fact_gr
integer x = 1659
integer y = 92
integer width = 361
integer height = 96
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Seleccion"
end type

event clicked;str_parametros sl_param

OpenWithParm( w_ve716_sel_clientes_ov_fac_gr, sl_param)

Parent.event ue_retrieve()

end event

