$PBExportHeader$w_al511_rpt_transporte_combustible.srw
forward
global type w_al511_rpt_transporte_combustible from w_report_smpl
end type
end forward

global type w_al511_rpt_transporte_combustible from w_report_smpl
integer width = 2656
integer height = 1532
string title = "Cuenta por cobrar de transportista de caña (AL511)"
string menuname = "m_impresion"
long backcolor = 12632256
end type
global w_al511_rpt_transporte_combustible w_al511_rpt_transporte_combustible

type variables
Str_cns_pop istr_1
end variables

on w_al511_rpt_transporte_combustible.create
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
end on

on w_al511_rpt_transporte_combustible.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre;call super::ue_open_pre;Long	ll_row, ll_total

istr_1 = Message.PowerObjectParm					// lectura de parametros

This.Event ue_retrieve()
//idw_1.Visible = True
of_position(0,0)
// ii_help = 101           // help topic

end event

event ue_retrieve;call super::ue_retrieve;idw_1.Object.p_logo.filename = gs_logo
idw_1.Visible = True
idw_1.SettransObject(sqlca)

idw_1.Retrieve(TRIM(istr_1.arg[1]))

end event

type dw_report from w_report_smpl`dw_report within w_al511_rpt_transporte_combustible
integer x = 9
integer width = 2569
integer height = 1328
string dataobject = "d_cns_transporte_combustible_tbl"
end type

