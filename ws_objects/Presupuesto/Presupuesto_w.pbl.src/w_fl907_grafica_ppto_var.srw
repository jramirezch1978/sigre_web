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
integer height = 2104
string title = "Variaciones Mensuales Flota (FL907)"
string menuname = "m_impresion"
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
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
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
MessageBox('aviso', ls_nave_nomb)

select distinct a.nave 
	into :ls_nave 
from tg_naves a,
	  tt_fl_presup_compara b
where a.nave = b.nave
  and a.nomb_nave like :ls_nave_nomb || '%'
  and a.flag_estado = '1';

if SQLCA.SQLCode = 100 then
	MessageBox('Aviso', 'Not Found')
elseif SQLCA.SQLCode < 0 then
	MessageBox('Error', SQLCA.SQLErrText)
end if;

st_1.text = ls_nave

dw_graph.Retrieve(ls_nave)

MessageBox('aviso', ls_nave)

dw_graph.Visible = True
dw_graph.object.gr_1.title = 'VARIACIONES MENSUALES PARA LA NAVE ' + uPPER(ls_nave_nomb)
 
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

event doubleclicked;call super::doubleclicked;string   ls_grgraphname="gr_1", ls_nave, ls_mes, ls_parametro
int    	li_series, li_category
grObjectType lgr_click_obj

// Ubicar en que lugar del grafico se Clicko
lgr_click_obj = this.ObjectAtPointer (ls_grgraphname, li_series, li_category)

ls_mes = this.categoryname( ls_grgraphname , li_category )

if len(trim(ls_mes)) = 1 then ls_mes = '0' + trim(ls_mes)

ls_nave = trim(st_1.text)
ls_parametro = ls_mes+ls_nave

if li_category > 0 and len(trim(ls_nave)) > 0 then
	openwithparm(w_fl908_grafica_ppto_compos, ls_parametro)
end if
end event

