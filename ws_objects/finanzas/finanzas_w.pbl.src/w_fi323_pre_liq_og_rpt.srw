$PBExportHeader$w_fi323_pre_liq_og_rpt.srw
forward
global type w_fi323_pre_liq_og_rpt from w_report_smpl
end type
end forward

global type w_fi323_pre_liq_og_rpt from w_report_smpl
integer width = 2729
integer height = 2332
string title = "Liquidación de Orden de Giro"
string menuname = "m_reporte"
end type
global w_fi323_pre_liq_og_rpt w_fi323_pre_liq_og_rpt

type variables
Str_cns_pop istr_1
end variables

on w_fi323_pre_liq_og_rpt.create
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
end on

on w_fi323_pre_liq_og_rpt.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre();call super::ue_open_pre;Long	ll_row, ll_total


istr_1 = Message.PowerObjectParm					// lectura de parametros


This.Event ue_retrieve()



end event

event ue_retrieve;call super::ue_retrieve;String ls_desc_emp

idw_1.Visible = True
idw_1.SettransObject(sqlca)

idw_1.Retrieve(istr_1.arg[1],TRIM(istr_1.arg[2]))

idw_1.Object.p_logo.filename 	= gs_logo
idw_1.Object.t_user.text 		= gs_user
idw_1.Object.t_empresa.text 	= gs_empresa
idw_1.Object.t_ventana.text 	= this.ClassName()
//idw_1.object.t_stitulo1.text 	= 'Desde ' + string(ld_fecha1, 'dd/mm/yyyy') + ' hasta ' + string(ld_fecha2, 'dd/mm/yyyy')

end event

type dw_report from w_report_smpl`dw_report within w_fi323_pre_liq_og_rpt
integer x = 0
integer y = 0
integer width = 2670
integer height = 2080
string dataobject = "d_rpt_liquidacion_sg_tbl"
end type

event dw_report::constructor;call super::constructor;is_dwform = 'form'  
idw_1 = This
end event

