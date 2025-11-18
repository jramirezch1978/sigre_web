$PBExportHeader$w_pr729_centros_benefico_tbl.srw
forward
global type w_pr729_centros_benefico_tbl from w_report_smpl
end type
type cb_2 from commandbutton within w_pr729_centros_benefico_tbl
end type
end forward

global type w_pr729_centros_benefico_tbl from w_report_smpl
integer width = 2199
integer height = 2028
string title = "Centros de Beneficio(PR729)"
string menuname = "m_reporte"
long backcolor = 67108864
event ue_query_retrieve ( )
cb_2 cb_2
end type
global w_pr729_centros_benefico_tbl w_pr729_centros_benefico_tbl

event ue_query_retrieve();SetPointer(HourGlass!)
This.event ue_retrieve()
SetPointer(Arrow!)
end event

on w_pr729_centros_benefico_tbl.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.cb_2=create cb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_2
end on

on w_pr729_centros_benefico_tbl.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_2)
end on

event ue_retrieve;call super::ue_retrieve;this.SetRedraw(false)

idw_1.Retrieve()
idw_1.Visible = True
idw_1.Object.p_logo.filename = gs_logo
idw_1.Object.usuario_t.text  = gs_user
idw_1.Object.Datawindow.Print.Orientation = '1'
//idw_1.object.t_nombre.text = gs_empresa
this.SetRedraw(true)
end event

type dw_report from w_report_smpl`dw_report within w_pr729_centros_benefico_tbl
integer x = 37
integer y = 180
integer width = 2107
integer height = 1628
string dataobject = "d_abc_centros_de_beneficio_tbl"
end type

type cb_2 from commandbutton within w_pr729_centros_benefico_tbl
integer x = 37
integer y = 40
integer width = 855
integer height = 100
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Generar Reporte"
end type

event clicked;SetPointer(HourGlass!)
Parent.event ue_retrieve()
SetPointer(Arrow!)
end event

