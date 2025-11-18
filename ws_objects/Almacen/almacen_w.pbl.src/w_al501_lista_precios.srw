$PBExportHeader$w_al501_lista_precios.srw
forward
global type w_al501_lista_precios from w_report_smpl
end type
end forward

global type w_al501_lista_precios from w_report_smpl
integer width = 1893
string title = "Lista de precios (AL501)"
string menuname = "m_impresion"
long backcolor = 12632256
end type
global w_al501_lista_precios w_al501_lista_precios

on w_al501_lista_precios.create
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
end on

on w_al501_lista_precios.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre();call super::ue_open_pre;This.Event ue_retrieve()
end event

event ue_retrieve;call super::ue_retrieve;idw_1.Retrieve()


idw_1.Object.p_logo.filename = gs_logo
idw_1.object.t_empresa.text = gs_empresa
idw_1.object.t_user.text = gs_user
idw_1.object.t_objeto.text = 'AL501'
end event

type dw_report from w_report_smpl`dw_report within w_al501_lista_precios
integer x = 0
integer y = 24
integer width = 1792
integer height = 896
string dataobject = "d_cns_lista_precios"
end type

