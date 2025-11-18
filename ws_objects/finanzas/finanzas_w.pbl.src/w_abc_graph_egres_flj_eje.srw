$PBExportHeader$w_abc_graph_egres_flj_eje.srw
forward
global type w_abc_graph_egres_flj_eje from w_cns
end type
type dw_cns from u_dw_grf within w_abc_graph_egres_flj_eje
end type
type cb_1 from commandbutton within w_abc_graph_egres_flj_eje
end type
end forward

global type w_abc_graph_egres_flj_eje from w_cns
integer width = 3063
integer height = 1272
string title = "Egresos de Flujo de Caja Ejecutado"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
dw_cns dw_cns
cb_1 cb_1
end type
global w_abc_graph_egres_flj_eje w_abc_graph_egres_flj_eje

on w_abc_graph_egres_flj_eje.create
int iCurrent
call super::create
this.dw_cns=create dw_cns
this.cb_1=create cb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_cns
this.Control[iCurrent+2]=this.cb_1
end on

on w_abc_graph_egres_flj_eje.destroy
call super::destroy
destroy(this.dw_cns)
destroy(this.cb_1)
end on

event ue_open_pre;call super::ue_open_pre;dw_cns.Settransobject(sqlca)
dw_cns.Retrieve()
end event

event open;THIS.EVENT ue_open_pre()
end event

type dw_cns from u_dw_grf within w_abc_graph_egres_flj_eje
integer x = 23
integer y = 8
integer width = 2670
integer height = 1152
string dataobject = "d_abc_egresos_flj_caja_ejecutado_grp"
end type

type cb_1 from commandbutton within w_abc_graph_egres_flj_eje
integer x = 2747
integer y = 1048
integer width = 251
integer height = 112
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Close"
end type

event clicked;Close(Parent)
end event

