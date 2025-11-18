$PBExportHeader$w_rpt_htb.srw
$PBExportComments$Reporte Generico con Regla de Zoom
forward
global type w_rpt_htb from w_report_smpl
end type
type htb_1 from u_htb_rpt within w_rpt_htb
end type
end forward

global type w_rpt_htb from w_report_smpl
integer width = 2537
integer height = 1804
htb_1 htb_1
end type
global w_rpt_htb w_rpt_htb

event resize;call super::resize;htb_1.width = newwidth - dw_report.x - this.cii_WindowBorder
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

type ole_skin from w_report_smpl`ole_skin within w_rpt_htb
end type

type uo_h from w_report_smpl`uo_h within w_rpt_htb
end type

type st_box from w_report_smpl`st_box within w_rpt_htb
end type

type phl_logonps from w_report_smpl`phl_logonps within w_rpt_htb
end type

type p_mundi from w_report_smpl`p_mundi within w_rpt_htb
end type

type p_logo from w_report_smpl`p_logo within w_rpt_htb
end type

type uo_filter from w_report_smpl`uo_filter within w_rpt_htb
end type

type st_filtro from w_report_smpl`st_filtro within w_rpt_htb
end type

type dw_report from w_report_smpl`dw_report within w_rpt_htb
integer x = 503
integer y = 376
end type

type htb_1 from u_htb_rpt within w_rpt_htb
integer x = 503
integer y = 276
integer width = 1778
integer height = 96
boolean bringtotop = true
end type

event constructor;call super::constructor;idw_report = dw_report
end event

