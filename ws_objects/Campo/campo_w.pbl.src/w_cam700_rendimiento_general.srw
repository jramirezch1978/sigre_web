$PBExportHeader$w_cam700_rendimiento_general.srw
forward
global type w_cam700_rendimiento_general from w_report_smpl
end type
type uo_fechas from u_ingreso_rango_fechas within w_cam700_rendimiento_general
end type
type cb_reporte from commandbutton within w_cam700_rendimiento_general
end type
end forward

global type w_cam700_rendimiento_general from w_report_smpl
integer width = 2811
integer height = 1704
string title = "[CAM700] Rendimiento General"
string menuname = "m_rpt_smpl"
uo_fechas uo_fechas
cb_reporte cb_reporte
end type
global w_cam700_rendimiento_general w_cam700_rendimiento_general

on w_cam700_rendimiento_general.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_smpl" then this.MenuID = create m_rpt_smpl
this.uo_fechas=create uo_fechas
this.cb_reporte=create cb_reporte
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_fechas
this.Control[iCurrent+2]=this.cb_reporte
end on

on w_cam700_rendimiento_general.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_fechas)
destroy(this.cb_reporte)
end on

event ue_retrieve;call super::ue_retrieve;date ld_fecha1, ld_fecha2

ld_fecha1 = uo_fechas.of_get_fecha1()
ld_fecha2 = uo_fechas.of_get_fecha2()

idw_1.Retrieve(ld_fecha1, ld_Fecha2)


idw_1.Object.p_logo.filename = gs_logo
idw_1.Object.t_empresa.text = gs_empresa
idw_1.Object.t_usuario.text = gs_user
idw_1.Object.t_objeto.text = this.ClassName( )
idw_1.Object.t_titulo1.text = 'Del: ' + string(ld_fecha1, 'dd/mm/yyyy') + ' al ' &
									 +	string(ld_fecha2, 'dd/mm/yyyy')
end event

type dw_report from w_report_smpl`dw_report within w_cam700_rendimiento_general
integer x = 0
integer y = 168
integer width = 2528
integer height = 880
string dataobject = "d_rpt_rendimiento_total_tbl"
end type

type uo_fechas from u_ingreso_rango_fechas within w_cam700_rendimiento_general
integer y = 40
integer taborder = 40
boolean bringtotop = true
end type

on uo_fechas.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;of_set_label('Desde:','Hasta:') // para seatear el titulo del boton

of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final



end event

type cb_reporte from commandbutton within w_cam700_rendimiento_general
integer x = 1335
integer y = 28
integer width = 402
integer height = 112
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Reporte"
end type

event clicked;parent.event ue_retrieve( )
end event

