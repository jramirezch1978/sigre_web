$PBExportHeader$w_ma717_rpt_agruphor_resumen.srw
forward
global type w_ma717_rpt_agruphor_resumen from w_report_smpl
end type
end forward

global type w_ma717_rpt_agruphor_resumen from w_report_smpl
integer x = 329
integer y = 188
integer width = 2107
integer height = 1908
string title = "Detalle de disponibilidad por estructura (MA717)"
string menuname = "m_rpt_smpl"
windowstate windowstate = maximized!
long backcolor = 12632256
end type
global w_ma717_rpt_agruphor_resumen w_ma717_rpt_agruphor_resumen

type variables
sg_parametros istr_1
end variables

event ue_open_pre;call super::ue_open_pre;Long	ll_row, ll_total

istr_1 = Message.PowerObjectParm					// lectura de parametros


This.Event ue_retrieve()
//of_position(100,100)
// ii_help = 101           // help topic


end event

event ue_retrieve;call super::ue_retrieve;idw_1.Visible = True
idw_1.SettransObject(sqlca)

idw_1.Retrieve(istr_1.string1, istr_1.date1, istr_1.date2)






end event

on w_ma717_rpt_agruphor_resumen.create
call super::create
if this.MenuName = "m_rpt_smpl" then this.MenuID = create m_rpt_smpl
end on

on w_ma717_rpt_agruphor_resumen.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event resize;call super::resize;//
end event

type dw_report from w_report_smpl`dw_report within w_ma717_rpt_agruphor_resumen
integer x = 0
integer y = 0
integer width = 2048
integer height = 1568
string dataobject = "d_rpt_disponib_estructura_det2_tbl"
end type

event dw_report::constructor;call super::constructor;is_dwform = 'form'  
idw_1 = This
end event

