$PBExportHeader$w_cd702_doc_sin_prov.srw
forward
global type w_cd702_doc_sin_prov from w_rpt
end type
type dw_1 from u_dw_rpt within w_cd702_doc_sin_prov
end type
end forward

global type w_cd702_doc_sin_prov from w_rpt
integer width = 4219
integer height = 2260
string title = "[CD702] Documentos sin Provisionar"
string menuname = "m_consulta"
long backcolor = 134217728
dw_1 dw_1
end type
global w_cd702_doc_sin_prov w_cd702_doc_sin_prov

on w_cd702_doc_sin_prov.create
int iCurrent
call super::create
if this.MenuName = "m_consulta" then this.MenuID = create m_consulta
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
end on

on w_cd702_doc_sin_prov.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
end on

event open;call super::open;dw_1.SettransObject(sqlca)
dw_1.retrieve()
end event

event ue_open_pre;call super::ue_open_pre;of_position_window(0,0)
end event

type dw_1 from u_dw_rpt within w_cd702_doc_sin_prov
integer x = 69
integer y = 76
integer width = 3986
integer height = 1808
string dataobject = "d_cns_doc_sin_provision"
boolean hscrollbar = true
boolean vscrollbar = true
end type

