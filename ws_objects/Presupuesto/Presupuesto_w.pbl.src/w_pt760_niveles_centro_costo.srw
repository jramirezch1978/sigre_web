$PBExportHeader$w_pt760_niveles_centro_costo.srw
forward
global type w_pt760_niveles_centro_costo from w_report_smpl
end type
end forward

global type w_pt760_niveles_centro_costo from w_report_smpl
string title = "Cuentas Presupuestales"
string menuname = "m_impresion"
long backcolor = 67108864
end type
global w_pt760_niveles_centro_costo w_pt760_niveles_centro_costo

on w_pt760_niveles_centro_costo.create
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
end on

on w_pt760_niveles_centro_costo.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre();call super::ue_open_pre;This.Event ue_retrieve()
end event

event ue_retrieve;call super::ue_retrieve;idw_1.Retrieve(gs_empresa)
idw_1.Object.p_logo.filename = gs_logo
idw_1.object.t_nombre.text = gs_empresa
idw_1.object.t_user.text = gs_user
end event

type dw_report from w_report_smpl`dw_report within w_pt760_niveles_centro_costo
string dataobject = "d_niveles_cencos_tbl"
end type

