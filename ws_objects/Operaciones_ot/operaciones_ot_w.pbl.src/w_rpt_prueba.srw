$PBExportHeader$w_rpt_prueba.srw
forward
global type w_rpt_prueba from w_rpt
end type
type cb_3 from commandbutton within w_rpt_prueba
end type
type uo_1 from u_ingreso_rango_fechas within w_rpt_prueba
end type
type dw_report from u_dw_rpt within w_rpt_prueba
end type
end forward

global type w_rpt_prueba from w_rpt
integer width = 2149
integer height = 1204
long backcolor = 12632256
cb_3 cb_3
uo_1 uo_1
dw_report dw_report
end type
global w_rpt_prueba w_rpt_prueba

on w_rpt_prueba.create
int iCurrent
call super::create
this.cb_3=create cb_3
this.uo_1=create uo_1
this.dw_report=create dw_report
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_3
this.Control[iCurrent+2]=this.uo_1
this.Control[iCurrent+3]=this.dw_report
end on

on w_rpt_prueba.destroy
call super::destroy
destroy(this.cb_3)
destroy(this.uo_1)
destroy(this.dw_report)
end on

type cb_3 from commandbutton within w_rpt_prueba
integer x = 1577
integer y = 44
integer width = 402
integer height = 92
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Procesar"
end type

type uo_1 from u_ingreso_rango_fechas within w_rpt_prueba
integer x = 37
integer y = 44
integer taborder = 40
end type

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

type dw_report from u_dw_rpt within w_rpt_prueba
integer x = 23
integer y = 192
integer width = 2066
integer height = 884
string dataobject = "d_rpt_pd_det_verificacion_ing_tbl"
end type

