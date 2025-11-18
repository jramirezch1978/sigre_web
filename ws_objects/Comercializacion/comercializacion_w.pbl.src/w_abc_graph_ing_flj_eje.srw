$PBExportHeader$w_abc_graph_ing_flj_eje.srw
forward
global type w_abc_graph_ing_flj_eje from w_cns
end type
type cb_1 from commandbutton within w_abc_graph_ing_flj_eje
end type
type dw_cns from u_dw_grf within w_abc_graph_ing_flj_eje
end type
end forward

global type w_abc_graph_ing_flj_eje from w_cns
integer width = 3063
integer height = 1272
string title = "Ingresos Flujo de Caja Ejecutado"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
cb_1 cb_1
dw_cns dw_cns
end type
global w_abc_graph_ing_flj_eje w_abc_graph_ing_flj_eje

on w_abc_graph_ing_flj_eje.create
int iCurrent
call super::create
this.cb_1=create cb_1
this.dw_cns=create dw_cns
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.dw_cns
end on

on w_abc_graph_ing_flj_eje.destroy
call super::destroy
destroy(this.cb_1)
destroy(this.dw_cns)
end on

event ue_open_pre;dw_cns.SetTransObject(sqlca)
dw_cns.Retrieve()
f_centrar(this)




//of_position_window(0,0)        // Posicionar la ventana en forma fija
end event

event open;//OVERRIDE
THIS.EVENT ue_open_pre()
end event

type cb_1 from commandbutton within w_abc_graph_ing_flj_eje
integer x = 2729
integer y = 1044
integer width = 274
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

type dw_cns from u_dw_grf within w_abc_graph_ing_flj_eje
integer x = 23
integer y = 8
integer width = 2670
integer height = 1152
string dataobject = "d_abc_ingresos_flj_caja_ejecutado_grp"
end type

