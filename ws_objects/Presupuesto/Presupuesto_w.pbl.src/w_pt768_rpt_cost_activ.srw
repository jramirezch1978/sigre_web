$PBExportHeader$w_pt768_rpt_cost_activ.srw
forward
global type w_pt768_rpt_cost_activ from w_report_smpl
end type
type cb_1 from commandbutton within w_pt768_rpt_cost_activ
end type
type sle_1 from singlelineedit within w_pt768_rpt_cost_activ
end type
end forward

global type w_pt768_rpt_cost_activ from w_report_smpl
integer width = 3447
integer height = 1708
string title = "Diagrama de Gantt"
string menuname = "m_impresion"
long backcolor = 67108864
cb_1 cb_1
sle_1 sle_1
end type
global w_pt768_rpt_cost_activ w_pt768_rpt_cost_activ

on w_pt768_rpt_cost_activ.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.cb_1=create cb_1
this.sle_1=create sle_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.sle_1
end on

on w_pt768_rpt_cost_activ.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.sle_1)
end on

event ue_retrieve;call super::ue_retrieve;//integer li_ano, li_mes_desde, li_mes_hasta
//string  ls_mensaje
//
//li_ano       = integer(em_ano.text)
//li_mes_desde = integer(em_mes_desde.text)
//li_mes_hasta = integer(em_mes_hasta.text)
//
//DECLARE pb_usp_ptto_rpt_volquetes PROCEDURE FOR USP_PTTO_RPT_VOLQUETES
//        ( :li_ano, :li_mes_desde, :li_mes_hasta ) ;
//EXECUTE pb_usp_ptto_rpt_volquetes ;
//
//idw_1.retrieve()
//
//idw_1.object.p_logo.filename = gs_logo
//idw_1.object.t_nombre.text   = gs_empresa
//idw_1.object.t_user.text     = gs_user
//
//if SQLCA.SQLCode = -1 then
//  ls_mensaje = sqlca.sqlerrtext
//  rollback ;
//  MessageBox("SQL error", ls_mensaje, StopSign!)
//end if
//
end event

event ue_open_pre;call super::ue_open_pre;String ls_nro_pry
ls_nro_pry = Message.StringParm
sle_1.Text = ls_nro_pry

sqlca.AutoCommit = True;
DECLARE pb_rpt_costos_activ &
PROCEDURE FOR usp_pry_rpt_costos_activ(:ls_nro_pry) ;
execute pb_rpt_costos_activ ;

IF sqlca.sqlcode = -1 THEN
  rollback ;
  MessageBox( 'Error usp_pry_rpt_costos_activ', sqlca.sqlerrtext, StopSign! )
  Return
END IF
//dw_report.Retrieve()
DataWindow ldw_reporte
//String ls_DataObject, ls_dsc_nivel, ls_footer


ldw_reporte = f_reporte(dw_report,'d_rpt_pry_cost_activ',"COSTOS DEL PROYECTO")
//ldw_reporte.modify( "v_filtro.text='"+wf_dsc_filtro(ii_nivel)+"'")
sqlca.autocommit = True
ldw_reporte.Retrieve()

sqlca.AutoCommit = False;
dw_report.visible = True
end event

type dw_report from w_report_smpl`dw_report within w_pt768_rpt_cost_activ
integer x = 9
integer y = 156
integer width = 3355
integer height = 1184
integer taborder = 50
string dataobject = "d_rpt_pry_cost_activ"
boolean hsplitscroll = true
end type

type cb_1 from commandbutton within w_pt768_rpt_cost_activ
boolean visible = false
integer x = 2185
integer y = 24
integer width = 302
integer height = 76
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aceptar"
end type

event clicked;Parent.Event ue_retrieve()

end event

type sle_1 from singlelineedit within w_pt768_rpt_cost_activ
integer x = 18
integer y = 28
integer width = 581
integer height = 100
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

