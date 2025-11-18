$PBExportHeader$w_ma301_solicit_ot_rpt.srw
forward
global type w_ma301_solicit_ot_rpt from w_report_smpl
end type
end forward

global type w_ma301_solicit_ot_rpt from w_report_smpl
integer x = 329
integer y = 188
string title = "Solicitud de Orden de Trabajo (MA301RPT)"
string menuname = "m_rpt_smpl"
windowstate windowstate = maximized!
end type
global w_ma301_solicit_ot_rpt w_ma301_solicit_ot_rpt

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

event ue_retrieve();call super::ue_retrieve;
idw_1.Visible = True
idw_1.SettransObject(sqlca)

idw_1.Retrieve(istr_1.arg[1])

end event

on w_ma301_solicit_ot_rpt.create
call super::create
if this.MenuName = "m_rpt_smpl" then this.MenuID = create m_rpt_smpl
end on

on w_ma301_solicit_ot_rpt.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

type dw_report from w_report_smpl`dw_report within w_ma301_solicit_ot_rpt
string dataobject = "d_rpt_solicitud_ot_tbl"
end type

event dw_report::constructor;call super::constructor;is_dwform = 'form'  
idw_1 = This
end event

