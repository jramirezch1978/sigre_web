$PBExportHeader$w_rpt_htb.srw
$PBExportComments$Reporte Generico con Regla de Zoom
forward
global type w_rpt_htb from w_report_smpl
end type
type htb_1 from u_htb_rpt within w_rpt_htb
end type
end forward

global type w_rpt_htb from w_report_smpl
integer width = 1147
integer height = 1056
long backcolor = 12632256
htb_1 htb_1
end type
global w_rpt_htb w_rpt_htb

event resize;call super::resize;htb_1.width = newwidth - dw_report.x
end event

on w_rpt_htb.create
int iCurrent
call super::create
this.htb_1=create htb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.htb_1
end on

on w_rpt_htb.destroy
call super::destroy
destroy(this.htb_1)
end on

type dw_report from w_report_smpl`dw_report within w_rpt_htb
integer x = 23
integer y = 100
end type

type htb_1 from u_htb_rpt within w_rpt_htb
integer x = 23
integer width = 951
integer height = 96
boolean bringtotop = true
end type

event constructor;call super::constructor;idw_report = dw_report
end event

