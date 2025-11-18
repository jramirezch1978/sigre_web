$PBExportHeader$w_cn707_matriz_cntbl.srw
forward
global type w_cn707_matriz_cntbl from w_rpt_htb
end type
end forward

global type w_cn707_matriz_cntbl from w_rpt_htb
integer width = 3497
integer height = 1616
string title = "Matriz Contable Automática (CN707)"
string menuname = "m_rpt_htb"
end type
global w_cn707_matriz_cntbl w_cn707_matriz_cntbl

on w_cn707_matriz_cntbl.create
call super::create
if this.MenuName = "m_rpt_htb" then this.MenuID = create m_rpt_htb
end on

on w_cn707_matriz_cntbl.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre();call super::ue_open_pre;This.Event ue_retrieve()

// ii_help = 101           // help topic


end event

event ue_retrieve();call super::ue_retrieve;idw_1.Retrieve(gs_empresa, gs_user)

end event

type dw_report from w_rpt_htb`dw_report within w_cn707_matriz_cntbl
integer x = 9
integer width = 3438
integer height = 1332
string dataobject = "d_rpt_matriz_cntbl_tbl"
end type

type htb_1 from w_rpt_htb`htb_1 within w_cn707_matriz_cntbl
end type

