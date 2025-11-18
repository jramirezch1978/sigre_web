$PBExportHeader$w_ope907_aprob_material_prsp_det.srw
forward
global type w_ope907_aprob_material_prsp_det from w_report_smpl
end type
end forward

global type w_ope907_aprob_material_prsp_det from w_report_smpl
integer height = 1124
string title = "Saldo Comprometido - Detalle"
string menuname = "m_rpt_smpl"
end type
global w_ope907_aprob_material_prsp_det w_ope907_aprob_material_prsp_det

on w_ope907_aprob_material_prsp_det.create
call super::create
if this.MenuName = "m_rpt_smpl" then this.MenuID = create m_rpt_smpl
end on

on w_ope907_aprob_material_prsp_det.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre;call super::ue_open_pre;this.event ue_retrieve()

end event

event ue_retrieve;call super::ue_retrieve;String ls_cencos, ls_cntap, ls_flag_ctrl
Date ld_fec_ini, ld_fec_fin
Integer li_ano
Decimal lde_sldo, lde_prspini

str_parametros lstr_rep

lstr_rep = message.powerobjectparm

ld_fec_ini = lstr_rep.fecha1
ld_fec_fin = lstr_rep.fecha2
ls_cencos	      = lstr_rep.string1
ls_cntap	      = lstr_rep.string2
ls_flag_ctrl = lstr_rep.string3
li_ano = lstr_rep.long1

//Saldo Presupuesto
Select usf_pto_sldo_acumulado_anual(:li_ano, :ls_cencos, :ls_cntap)
  into :lde_sldo
  from dual;

//Presupuesto Inicial
Select usf_pto_presup_inicial(:li_ano, :ls_cencos, :ls_cntap)
  into :lde_prspini
  from dual;

dw_report.Retrieve(ld_fec_ini, ld_fec_fin, ls_cencos, ls_cntap, ls_flag_ctrl)
dw_report.Object.p_logo.filename = gs_logo
dw_report.object.t_empresa.Text = gs_empresa
dw_report.object.t_user.Text = gs_user
dw_report.object.t_pptoini.Text = String(lde_prspini,"###,###,##0.00")
dw_report.object.t_saldoppto.Text = String(lde_sldo,"###,###,##0.00")
end event

type dw_report from w_report_smpl`dw_report within w_ope907_aprob_material_prsp_det
string dataobject = "d_rpt_aprob_material_prsp_det"
integer ii_zoom_actual = 100
end type

