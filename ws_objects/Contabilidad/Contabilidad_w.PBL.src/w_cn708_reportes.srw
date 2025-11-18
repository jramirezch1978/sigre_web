$PBExportHeader$w_cn708_reportes.srw
forward
global type w_cn708_reportes from w_rpt_htb
end type
end forward

global type w_cn708_reportes from w_rpt_htb
integer width = 3456
integer height = 1668
string title = "Matriz de Reportes (CN708)"
string menuname = "m_rpt_htb"
end type
global w_cn708_reportes w_cn708_reportes

on w_cn708_reportes.create
call super::create
if this.MenuName = "m_rpt_htb" then this.MenuID = create m_rpt_htb
end on

on w_cn708_reportes.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_retrieve();call super::ue_retrieve;idw_1.Retrieve(gs_empresa, gs_user)
idw_1.Visible = True

end event

event ue_open_pre();call super::ue_open_pre;This.event ue_retrieve()
end event

type dw_report from w_rpt_htb`dw_report within w_cn708_reportes
integer width = 3387
integer height = 1376
string dataobject = "d_reporte_tbl"
end type

type htb_1 from w_rpt_htb`htb_1 within w_cn708_reportes
end type

