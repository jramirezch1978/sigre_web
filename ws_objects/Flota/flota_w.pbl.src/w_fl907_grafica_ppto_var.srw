$PBExportHeader$w_fl907_grafica_ppto_var.srw
forward
global type w_fl907_grafica_ppto_var from w_rpt
end type
type st_1 from statictext within w_fl907_grafica_ppto_var
end type
type dw_graph from u_dw_grf within w_fl907_grafica_ppto_var
end type
end forward

global type w_fl907_grafica_ppto_var from w_rpt
integer width = 3534
integer height = 1968
string title = "Variaciones Mensuales (FL907)"
string menuname = "m_rpt"
long backcolor = 67108864
boolean center = true
event ue_copiar ( )
st_1 st_1
dw_graph dw_graph
end type
global w_fl907_grafica_ppto_var w_fl907_grafica_ppto_var

event ue_copiar();dw_graph.ClipBoard("gr_1")
end event

on w_fl907_grafica_ppto_var.create
int iCurrent
call super::create
if this.MenuName = "m_rpt" then this.MenuID = create m_rpt
this.st_1=create st_1
this.dw_graph=create dw_graph
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.dw_graph
end on

on w_fl907_grafica_ppto_var.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.dw_graph)
end on

event ue_open_pre;call super::ue_open_pre;//idw_1 = dw_report
dw_graph.Visible = False
dw_graph.SetTransObject(sqlca)
THIS.Event ue_preview()
This.Event ue_retrieve()

 ii_help = 101           // help topic

end event

event ue_retrieve;call super::ue_retrieve;string ls_nave, ls_nave_nomb
ls_nave_nomb = trim(Message.StringParm)
select nave 
	into :ls_nave 
	from tg_naves 
	where trim(nomb_nave) = :ls_nave_nomb;

st_1.text = ls_nave

dw_graph.Retrieve(ls_nave)
dw_graph.Visible = True
dw_graph.object.gr_1.title = 'VARIACIONES MENSUALES PARA LA NAVE ' + uPPER(ls_nave_nomb)
//idw_1.Object.p_logo.filename = gs_logo
end event

event resize;call super::resize;dw_graph.width = newwidth - dw_graph.x
dw_graph.height = newheight - dw_graph.y
end event

type st_1 from statictext within w_fl907_grafica_ppto_var
boolean visible = false
integer x = 123
integer y = 52
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

type dw_graph from u_dw_grf within w_fl907_grafica_ppto_var
integer width = 3451
integer height = 1832
string dataobject = "d_presup_comp_varia_tbl"
end type

event buttonclicked;call super::buttonclicked;grObjectType lgr_click_obj
string   ls_planta, ls_grgraphname="gr_1", ls_find, ls_nave, ls_mes
int    li_series, li_category
Long    ll_rc, ll_row, ll_plantas
Decimal   ldc_total
 
// Ubicar en que lugar del grafico se Clicko
lgr_click_obj = this.ObjectAtPointer (ls_grgraphname, li_series, li_category)
ls_mes = string(li_category)
ls_nave = this.seriesname(ls_grgraphname,li_series)
messagebox('',ls_mes +' - '+ls_nave)
//openwithparm(w_fl908_grafica_ppto_compos, ls_nave)
end event

event doubleclicked;call super::doubleclicked;grObjectType lgr_click_obj
string   ls_planta, ls_grgraphname="gr_1", ls_find, ls_nave, ls_mes, ls_parametro
int    li_series, li_category
Long    ll_rc, ll_row, ll_plantas
Decimal   ldc_total
 
// Ubicar en que lugar del grafico se Clicko
lgr_click_obj = this.ObjectAtPointer (ls_grgraphname, li_series, li_category)

ls_mes = trim(string(li_category,'00'))
ls_nave = trim(st_1.text)
ls_parametro = ls_mes+ls_nave


if li_category > 0 and len(trim(ls_nave)) > 0 then
	openwithparm(w_fl908_grafica_ppto_compos, ls_parametro)
end if
end event

