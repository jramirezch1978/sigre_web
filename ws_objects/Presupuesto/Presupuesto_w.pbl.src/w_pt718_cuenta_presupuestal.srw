$PBExportHeader$w_pt718_cuenta_presupuestal.srw
forward
global type w_pt718_cuenta_presupuestal from w_report_smpl
end type
end forward

global type w_pt718_cuenta_presupuestal from w_report_smpl
integer width = 2290
integer height = 2232
string title = "(PT718) Cuentas Presupuestales "
string menuname = "m_impresion"
long backcolor = 67108864
end type
global w_pt718_cuenta_presupuestal w_pt718_cuenta_presupuestal

on w_pt718_cuenta_presupuestal.create
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
end on

on w_pt718_cuenta_presupuestal.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre();call super::ue_open_pre;This.Event ue_retrieve()
end event

event ue_retrieve();call super::ue_retrieve;idw_1.Retrieve(gs_empresa)
idw_1.Object.p_logo.filename = gs_logo
end event

type dw_report from w_report_smpl`dw_report within w_pt718_cuenta_presupuestal
integer width = 2181
integer height = 2032
string dataobject = "d_rpt_cuentas_presupuestales"
end type

