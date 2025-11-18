$PBExportHeader$w_ope304_prog_operaciones_rpt.srw
forward
global type w_ope304_prog_operaciones_rpt from w_report_smpl
end type
end forward

global type w_ope304_prog_operaciones_rpt from w_report_smpl
integer x = 329
integer y = 188
integer width = 1303
string title = "Reporte de Orden de Trabajo (MA302RPT)"
string menuname = "m_rpt_smpl"
windowstate windowstate = maximized!
long backcolor = 12632256
end type
global w_ope304_prog_operaciones_rpt w_ope304_prog_operaciones_rpt

type variables
Str_cns_pop istr_1
end variables

event ue_open_pre;call super::ue_open_pre;Long	ll_row, ll_total

istr_1 = Message.PowerObjectParm					// lectura de parametros

This.Event ue_retrieve()
of_position(0,0)
// ii_help = 101           // help topic


end event

event ue_retrieve;call super::ue_retrieve;idw_1.Visible = True
idw_1.SettransObject(sqlca)

idw_1.Retrieve(TRIM(istr_1.arg[1]))
//idw_1.Retrieve(istr_1.arg[1])
idw_1.object.p_logo.filename = gs_logo

end event

on w_ope304_prog_operaciones_rpt.create
call super::create
if this.MenuName = "m_rpt_smpl" then this.MenuID = create m_rpt_smpl
end on

on w_ope304_prog_operaciones_rpt.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

type dw_report from w_report_smpl`dw_report within w_ope304_prog_operaciones_rpt
integer width = 1134
integer height = 820
string dataobject = "d_fmt_prog_trabajo_tbl"
end type

event dw_report::constructor;call super::constructor;is_dwform = 'form'  
idw_1 = This
end event

