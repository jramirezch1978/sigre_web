$PBExportHeader$w_cn744_rpt_res_activo_fijo_det.srw
forward
global type w_cn744_rpt_res_activo_fijo_det from w_report_smpl
end type
end forward

global type w_cn744_rpt_res_activo_fijo_det from w_report_smpl
integer width = 3328
integer height = 1552
string title = "[CN744] Detalle de Cuenta por Articulos"
string menuname = "m_abc_report_smpl"
long backcolor = 12632256
end type
global w_cn744_rpt_res_activo_fijo_det w_cn744_rpt_res_activo_fijo_det

on w_cn744_rpt_res_activo_fijo_det.create
call super::create
if this.MenuName = "m_abc_report_smpl" then this.MenuID = create m_abc_report_smpl
end on

on w_cn744_rpt_res_activo_fijo_det.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_retrieve;call super::ue_retrieve;ib_preview = false

dw_report.visible = true

dw_report.retrieve()

dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_empresa.text = gs_empresa
dw_report.object.t_user.text = gs_user

this.event ue_preview()

setpointer(Arrow!)
end event

event open;//Override

if isvalid(message.powerobjectparm) then
	str_parametros lstr_parametros
	
	lstr_parametros = message.powerobjectparm
	
	long ll_ano, ll_mes
	string ls_cnta
	
	ll_ano = long(lstr_parametros.string1)
	ll_mes = long(lstr_parametros.string2)
	ls_cnta = string(lstr_parametros.string3)
	
	DECLARE PB_usp_cnt_saldo_mensual_cntbl PROCEDURE FOR usp_cnt_saldo_mensual_cntbl_d
		  ( :ll_ano, :ll_mes, :ls_cnta ) ;
	Execute PB_usp_cnt_saldo_mensual_cntbl ;
	
	if sqlca.sqlcode = -1 then
		messagebox('Error',string(sqlca.sqlcode) + ' ' + string(sqlca.sqlerrtext) )
		rollback;
		return
	end if
	
	dw_report.visible = true
	
	this.event ue_open_pre()
	THIS.EVENT ue_retrieve()
	
else
	
	messagebox('Aviso','Error al Momento de Pasar parametros de Cuenta Contable')
	
end if
end event

type dw_report from w_report_smpl`dw_report within w_cn744_rpt_res_activo_fijo_det
integer x = 37
integer y = 32
integer width = 3186
integer height = 1284
integer taborder = 50
string dataobject = "d_rpt_libro_res_activo_fijo_det_tbl"
integer ii_zoom_actual = 100
end type

