$PBExportHeader$w_ope718_orden_trabajo_rpt.srw
forward
global type w_ope718_orden_trabajo_rpt from w_report_smpl
end type
type sle_orden from singlelineedit within w_ope718_orden_trabajo_rpt
end type
type st_1 from statictext within w_ope718_orden_trabajo_rpt
end type
type cb_1 from commandbutton within w_ope718_orden_trabajo_rpt
end type
end forward

global type w_ope718_orden_trabajo_rpt from w_report_smpl
integer x = 329
integer y = 188
integer width = 2363
integer height = 1424
string title = "Reporte de Orden de Trabajo (MA302RPT)"
string menuname = "m_rpt_smpl"
windowstate windowstate = maximized!
long backcolor = 12632256
sle_orden sle_orden
st_1 st_1
cb_1 cb_1
end type
global w_ope718_orden_trabajo_rpt w_ope718_orden_trabajo_rpt

type variables
//Str_cns_pop istr_1
end variables

event ue_open_pre;call super::ue_open_pre;Long	ll_row, ll_total
//istr_1 = Message.PowerObjectParm					// lectura de parametros
//This.Event ue_retrieve()
of_position(0,0)
// ii_help = 101           // help topic


end event

event ue_retrieve;call super::ue_retrieve;String ls_nro_orden

ls_nro_orden = sle_orden.text
idw_1.Visible = True
idw_1.SettransObject(sqlca)
idw_1.Retrieve(trim(ls_nro_orden))
dw_report.object.dw_1.object.p_logo.filename = gs_logo








end event

on w_ope718_orden_trabajo_rpt.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_smpl" then this.MenuID = create m_rpt_smpl
this.sle_orden=create sle_orden
this.st_1=create st_1
this.cb_1=create cb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_orden
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.cb_1
end on

on w_ope718_orden_trabajo_rpt.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_orden)
destroy(this.st_1)
destroy(this.cb_1)
end on

type dw_report from w_report_smpl`dw_report within w_ope718_orden_trabajo_rpt
integer y = 236
integer width = 1134
integer height = 820
string dataobject = "d_rpt_formato_ot_corr_log_tbl"
end type

event dw_report::constructor;call super::constructor;is_dwform = 'form'  
idw_1 = This
end event

type sle_orden from singlelineedit within w_ope718_orden_trabajo_rpt
integer x = 539
integer y = 76
integer width = 407
integer height = 92
integer taborder = 10
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

type st_1 from statictext within w_ope718_orden_trabajo_rpt
integer x = 50
integer y = 88
integer width = 457
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Orden de trabajo :"
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_ope718_orden_trabajo_rpt
integer x = 1015
integer y = 76
integer width = 343
integer height = 100
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Recuperar"
end type

event clicked;Parent.Event ue_retrieve()
//ParentEvent ue_retrieve()
end event

