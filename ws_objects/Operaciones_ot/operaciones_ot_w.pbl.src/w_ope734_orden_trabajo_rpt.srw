$PBExportHeader$w_ope734_orden_trabajo_rpt.srw
forward
global type w_ope734_orden_trabajo_rpt from w_report_smpl
end type
end forward

global type w_ope734_orden_trabajo_rpt from w_report_smpl
integer x = 329
integer y = 188
integer width = 1856
integer height = 1716
string title = "Reporte de Orden de Trabajo (MA302RPT)"
string menuname = "m_rpt_smpl"
windowstate windowstate = maximized!
end type
global w_ope734_orden_trabajo_rpt w_ope734_orden_trabajo_rpt

type variables
Str_cns_pop istr_1
end variables

event ue_open_pre();call super::ue_open_pre;// 
Long	ll_row, ll_total


istr_1 = Message.PowerObjectParm					// lectura de parametros


This.Event ue_retrieve()
of_position(0,0)
// ii_help = 101           // help topic


end event

event ue_retrieve;call super::ue_retrieve;
idw_1.Visible = True
idw_1.SettransObject(sqlca)
idw_1.Retrieve(TRIM(istr_1.arg[1]))
dw_report.object.dw_1.object.p_logo.filename = gs_logo








end event

on w_ope734_orden_trabajo_rpt.create
call super::create
if this.MenuName = "m_rpt_smpl" then this.MenuID = create m_rpt_smpl
end on

on w_ope734_orden_trabajo_rpt.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

type dw_report from w_report_smpl`dw_report within w_ope734_orden_trabajo_rpt
integer width = 1778
integer height = 1520
string dataobject = "d_rpt_formato_ot_corr_tbl"
end type

event dw_report::constructor;call super::constructor;is_dwform = 'form'  
idw_1 = This
end event

