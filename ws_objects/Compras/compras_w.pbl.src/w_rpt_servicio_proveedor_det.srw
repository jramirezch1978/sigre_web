$PBExportHeader$w_rpt_servicio_proveedor_det.srw
forward
global type w_rpt_servicio_proveedor_det from w_rpt
end type
type dw_report from u_dw_rpt within w_rpt_servicio_proveedor_det
end type
end forward

global type w_rpt_servicio_proveedor_det from w_rpt
integer width = 2862
integer height = 1332
string title = "Detalle de servicios por proveedor"
string menuname = "m_impresion"
long backcolor = 12632256
dw_report dw_report
end type
global w_rpt_servicio_proveedor_det w_rpt_servicio_proveedor_det

on w_rpt_servicio_proveedor_det.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.dw_report=create dw_report
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_report
end on

on w_rpt_servicio_proveedor_det.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_report)
end on

event ue_open_pre();call super::ue_open_pre;idw_1 = dw_report
idw_1.Visible = False
idw_1.SetTransObject(sqlca)
this.Event ue_preview()
This.Event ue_retrieve()

// ii_help = 101           // help topic


end event

event ue_retrieve;call super::ue_retrieve;idw_1.Retrieve()
idw_1.Visible = True
//idw_1.Object.p_logo.filename = gs_logo
end event

type dw_report from u_dw_rpt within w_rpt_servicio_proveedor_det
integer x = 5
integer width = 2798
integer height = 1140
boolean bringtotop = true
string dataobject = "d_rpt_serv_prov_detalle"
end type

