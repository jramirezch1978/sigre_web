$PBExportHeader$w_al509_guias_pend_ticket.srw
forward
global type w_al509_guias_pend_ticket from w_report_smpl
end type
type uo_1 from u_ingreso_rango_fechas within w_al509_guias_pend_ticket
end type
type cb_3 from commandbutton within w_al509_guias_pend_ticket
end type
end forward

global type w_al509_guias_pend_ticket from w_report_smpl
integer width = 2930
integer height = 1132
string title = "Guias de Remisión Faltantes de Ticket de Balanza (AL509)"
string menuname = "m_impresion"
long backcolor = 12632256
uo_1 uo_1
cb_3 cb_3
end type
global w_al509_guias_pend_ticket w_al509_guias_pend_ticket

type variables
Integer ii_opcion
end variables

on w_al509_guias_pend_ticket.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.uo_1=create uo_1
this.cb_3=create cb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_1
this.Control[iCurrent+2]=this.cb_3
end on

on w_al509_guias_pend_ticket.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_1)
destroy(this.cb_3)
end on

type dw_report from w_report_smpl`dw_report within w_al509_guias_pend_ticket
integer x = 69
integer y = 156
integer width = 1710
string dataobject = "d_rpt_guias_pend_ticket"
end type

type uo_1 from u_ingreso_rango_fechas within w_al509_guias_pend_ticket
integer x = 46
integer y = 32
integer taborder = 30
boolean bringtotop = true
end type

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;String ls_desde
 
 of_set_label('Del:','Al:') 								//	para setear la fecha inicial
 
 ls_desde = '01/' + string(month(today()))+'/' + string(year(today()))
 of_set_fecha(date(ls_desde), today()) 				// para seatear el titulo del boton
 of_set_rango_inicio(date('01/01/1900')) 				// rango inicial
 of_set_rango_fin(date('31/12/9999'))					// rango final
end event

type cb_3 from commandbutton within w_al509_guias_pend_ticket
integer x = 1371
integer y = 28
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

event clicked;Date ld_desde, ld_hasta

ld_desde = uo_1.of_get_fecha1()
ld_hasta = uo_1.of_get_fecha2()



//idw_1 = dw_report
ib_preview = false
parent.Event ue_preview()
//idw_1.Visible = False
idw_1.Visible = True
//
//idw_1.SetTransObject(Sqlca)
////idw_1.Retrieve(gs_empresa)
//idw_1.Object.p_logo.filename = gs_logo
//idw_1.object.t_user.text = gs_user
dw_report.object.t_fechas.text   = 'Del: ' + string( ld_desde,'dd/mm/yyyy') + ' Al: ' + string( ld_hasta,'dd/mm/yyyy')
dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_empresa.text   = gs_empresa
dw_report.object.t_user.text   = gs_user


dw_report.retrieve(ld_desde,ld_hasta)


end event

