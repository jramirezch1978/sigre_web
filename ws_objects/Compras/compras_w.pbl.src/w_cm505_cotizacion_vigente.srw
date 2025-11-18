$PBExportHeader$w_cm505_cotizacion_vigente.srw
forward
global type w_cm505_cotizacion_vigente from w_report_smpl
end type
end forward

global type w_cm505_cotizacion_vigente from w_report_smpl
string title = "Articulos vigentes segun cotizacion (CM505)"
string menuname = "m_impresion"
long backcolor = 12632256
end type
global w_cm505_cotizacion_vigente w_cm505_cotizacion_vigente

on w_cm505_cotizacion_vigente.create
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
end on

on w_cm505_cotizacion_vigente.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre();call super::ue_open_pre;This.Event ue_retrieve()
end event

event ue_retrieve();call super::ue_retrieve;idw_1.Visible = True

idw_1.Retrieve(today())
//idw_1.Object.p_logo.filename = gs_logo
end event

type dw_report from w_report_smpl`dw_report within w_cm505_cotizacion_vigente
string dataobject = "d_rpt_cotizacion_vigente"
end type

