$PBExportHeader$w_cm715_precios_pactados.srw
forward
global type w_cm715_precios_pactados from w_report_smpl
end type
end forward

global type w_cm715_precios_pactados from w_report_smpl
integer height = 1124
string title = "Precios Pactados (CM715)"
string menuname = "m_impresion"
long backcolor = 67108864
end type
global w_cm715_precios_pactados w_cm715_precios_pactados

on w_cm715_precios_pactados.create
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
end on

on w_cm715_precios_pactados.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre;call super::ue_open_pre;IF UPPER(gs_lpp) = 'S' THEN THIS.EVENT ue_set_retrieve_as_needed('S')

This.Event ue_retrieve()
end event

event ue_retrieve;call super::ue_retrieve;idw_1.Retrieve()

idw_1.Object.p_logo.filename = gs_logo
idw_1.object.t_empresa.text = gs_empresa
idw_1.object.t_user.text = gs_user
idw_1.object.t_objeto.text = 'CM715'
end event

type dw_report from w_report_smpl`dw_report within w_cm715_precios_pactados
string dataobject = "d_rpt_art_precio_pactado_tbl"
end type

