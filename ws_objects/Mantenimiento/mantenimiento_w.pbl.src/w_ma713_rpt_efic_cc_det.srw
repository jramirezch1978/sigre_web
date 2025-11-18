$PBExportHeader$w_ma713_rpt_efic_cc_det.srw
forward
global type w_ma713_rpt_efic_cc_det from w_report_smpl
end type
end forward

global type w_ma713_rpt_efic_cc_det from w_report_smpl
integer x = 329
integer y = 188
string title = "Detalle de reporte de eficiencia (MA713)"
string menuname = "m_rpt_smpl"
windowstate windowstate = maximized!
long backcolor = 12632256
end type
global w_ma713_rpt_efic_cc_det w_ma713_rpt_efic_cc_det

type variables
Str_cns_pop istr_1
end variables

event ue_open_pre();call super::ue_open_pre;// 
Long	ll_row, ll_total


istr_1 = Message.PowerObjectParm					// lectura de parametros


This.Event ue_retrieve()
of_position(100,100)
// ii_help = 101           // help topic


end event

event ue_retrieve();call super::ue_retrieve;
idw_1.Visible = True
idw_1.SettransObject(sqlca)

idw_1.Retrieve(trim(istr_1.arg[1]),TRIM(istr_1.arg[2]))





end event

on w_ma713_rpt_efic_cc_det.create
call super::create
if this.MenuName = "m_rpt_smpl" then this.MenuID = create m_rpt_smpl
end on

on w_ma713_rpt_efic_cc_det.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event resize;call super::resize;//
end event

type dw_report from w_report_smpl`dw_report within w_ma713_rpt_efic_cc_det
string dataobject = "d_rpt_efic_cc_resp_det_tbl"
end type

event dw_report::constructor;call super::constructor;is_dwform = 'form'  
idw_1 = This
end event

