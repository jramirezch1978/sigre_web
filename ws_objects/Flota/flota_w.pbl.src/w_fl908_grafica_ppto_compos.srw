$PBExportHeader$w_fl908_grafica_ppto_compos.srw
forward
global type w_fl908_grafica_ppto_compos from w_rpt
end type
type st_1 from statictext within w_fl908_grafica_ppto_compos
end type
type cb_1 from commandbutton within w_fl908_grafica_ppto_compos
end type
type dw_graph from u_dw_grf within w_fl908_grafica_ppto_compos
end type
end forward

global type w_fl908_grafica_ppto_compos from w_rpt
integer width = 3470
integer height = 1900
string title = "Variacion por Partida Presupuestal (FL908)"
string menuname = "m_rpt"
long backcolor = 67108864
boolean center = true
event ue_copiar ( )
st_1 st_1
cb_1 cb_1
dw_graph dw_graph
end type
global w_fl908_grafica_ppto_compos w_fl908_grafica_ppto_compos

event ue_copiar();dw_graph.ClipBoard("gr_1")
end event

on w_fl908_grafica_ppto_compos.create
int iCurrent
call super::create
if this.MenuName = "m_rpt" then this.MenuID = create m_rpt
this.st_1=create st_1
this.cb_1=create cb_1
this.dw_graph=create dw_graph
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.dw_graph
end on

on w_fl908_grafica_ppto_compos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.cb_1)
destroy(this.dw_graph)
end on

event ue_open_pre;call super::ue_open_pre;//idw_1 = dw_report
dw_graph.Visible = False
dw_graph.SetTransObject(sqlca)
THIS.Event ue_preview()
This.Event ue_retrieve()

 ii_help = 101           // help topic

end event

event ue_retrieve;call super::ue_retrieve;string ls_nave
integer li_mes
ls_nave = right(trim(Message.StringParm),8)
li_mes = integer(left(trim(Message.StringParm),2))
//messagebox ('',string(li_mes) +' - '+ ls_nave)
dw_graph.Retrieve(li_mes, ls_nave)
dw_graph.Visible = True
dw_graph.Object.gr_1.Title = 'Distribución de las variaciones por cuenta presupuestal / centro de csotos'
//idw_1.Object.p_logo.filename = gs_logo
end event

event resize;call super::resize;dw_graph.width = newwidth - dw_graph.x
dw_graph.height = newheight - dw_graph.y
end event

type st_1 from statictext within w_fl908_grafica_ppto_compos
boolean visible = false
integer x = 1952
integer y = 104
integer width = 402
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_fl908_grafica_ppto_compos
integer x = 3374
integer width = 78
integer height = 60
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "X"
end type

event clicked;Close(parent)
end event

type dw_graph from u_dw_grf within w_fl908_grafica_ppto_compos
integer width = 3451
integer height = 1560
string dataobject = "d_presup_comp_det_grf"
end type

