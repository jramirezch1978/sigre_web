$PBExportHeader$w_pt765_planilla_det.srw
forward
global type w_pt765_planilla_det from w_report_smpl
end type
end forward

global type w_pt765_planilla_det from w_report_smpl
integer width = 3547
integer height = 1776
string title = "(PT764] Reporte de Planilla"
string menuname = "m_impresion"
windowstate windowstate = maximized!
end type
global w_pt765_planilla_det w_pt765_planilla_det

on w_pt765_planilla_det.create
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
end on

on w_pt765_planilla_det.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre;call super::ue_open_pre;str_parametros sgt_parametros
sgt_parametros = message.PowerObjectParm

string ls_cencos, ls_origen
integer li_mes, li_ano

li_ano = sgt_parametros.int1
li_mes = sgt_parametros.int2
ls_origen = sgt_parametros.string1
ls_cencos = sgt_parametros.string2

idw_1.retrieve(li_ano, li_mes, ls_origen, ls_cencos)
idw_1.object.p_logo.filename = gs_logo
idw_1.object.t_empresa.text	= gs_empresa
idw_1.object.t_usuario.text	= 'Usuario: ' + gs_user
idw_1.visible = true
event ue_preview()
end event

event ue_preview;call super::ue_preview;ib_preview = false
end event

type dw_report from w_report_smpl`dw_report within w_pt765_planilla_det
integer x = 0
integer y = 0
integer width = 3442
integer height = 1508
integer taborder = 50
string dataobject = "d_rpt_planilla_det"
end type

