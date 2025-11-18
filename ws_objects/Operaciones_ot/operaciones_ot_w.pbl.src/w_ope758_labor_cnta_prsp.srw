$PBExportHeader$w_ope758_labor_cnta_prsp.srw
forward
global type w_ope758_labor_cnta_prsp from w_report_smpl
end type
type rb_labor from radiobutton within w_ope758_labor_cnta_prsp
end type
type rb_articulo from radiobutton within w_ope758_labor_cnta_prsp
end type
type cb_3 from commandbutton within w_ope758_labor_cnta_prsp
end type
type gb_1 from groupbox within w_ope758_labor_cnta_prsp
end type
end forward

global type w_ope758_labor_cnta_prsp from w_report_smpl
integer width = 3515
integer height = 2040
string title = "(ope758) Consultas de cuentas presupuestales por labor"
string menuname = "m_rpt_smpl"
long backcolor = 12632256
rb_labor rb_labor
rb_articulo rb_articulo
cb_3 cb_3
gb_1 gb_1
end type
global w_ope758_labor_cnta_prsp w_ope758_labor_cnta_prsp

on w_ope758_labor_cnta_prsp.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_smpl" then this.MenuID = create m_rpt_smpl
this.rb_labor=create rb_labor
this.rb_articulo=create rb_articulo
this.cb_3=create cb_3
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_labor
this.Control[iCurrent+2]=this.rb_articulo
this.Control[iCurrent+3]=this.cb_3
this.Control[iCurrent+4]=this.gb_1
end on

on w_ope758_labor_cnta_prsp.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_labor)
destroy(this.rb_articulo)
destroy(this.cb_3)
destroy(this.gb_1)
end on

event ue_retrieve;call super::ue_retrieve;String ls_codigo, ls_texto
Date ld_fec_ini, ld_fec_fin

SetPointer(Arrow!)
IF rb_labor.checked=true then
	idw_1.DataObject='d_cns_cnta_prsp_x_labor_tbl'
	idw_1.SetTransObject(sqlca)
	idw_1.retrieve()
	ls_texto = 'Por cuenta presupuestal de labor'
ELSEIF rb_articulo.checked=true then
	idw_1.DataObject='d_cns_cnta_prsp_x_labor_insumo_tbl'
	idw_1.SetTransObject(sqlca)
	idw_1.retrieve()
	ls_texto = 'Por cuenta presupuestal del artículo'

END IF

idw_1.Object.p_logo.filename = gs_logo
idw_1.Object.t_texto.text = ls_texto 
idw_1.Object.p_logo.filename = gs_logo
SetPointer(Arrow!)

ib_preview = false
idw_1.visible=true
idw_1.ii_zoom_actual = 100
event ue_preview()

end event

type dw_report from w_report_smpl`dw_report within w_ope758_labor_cnta_prsp
integer x = 50
integer y = 216
integer width = 3387
integer height = 1624
end type

type rb_labor from radiobutton within w_ope758_labor_cnta_prsp
integer x = 87
integer y = 80
integer width = 613
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Cnta Prsp de Labor "
boolean checked = true
end type

type rb_articulo from radiobutton within w_ope758_labor_cnta_prsp
integer x = 850
integer y = 80
integer width = 599
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Cnta Prsp de  articulo"
end type

type cb_3 from commandbutton within w_ope758_labor_cnta_prsp
integer x = 1531
integer y = 48
integer width = 361
integer height = 112
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Consultar"
end type

event clicked;parent.event ue_retrieve()
end event

type gb_1 from groupbox within w_ope758_labor_cnta_prsp
integer x = 50
integer y = 16
integer width = 1435
integer height = 156
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "Opciones"
end type

