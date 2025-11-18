$PBExportHeader$w_pt903_articulos_no_valorizados.srw
$PBExportComments$Control presupuestario por centro de costo
forward
global type w_pt903_articulos_no_valorizados from w_report_smpl
end type
type cb_10 from commandbutton within w_pt903_articulos_no_valorizados
end type
type st_1 from statictext within w_pt903_articulos_no_valorizados
end type
type em_ano from editmask within w_pt903_articulos_no_valorizados
end type
end forward

global type w_pt903_articulos_no_valorizados from w_report_smpl
integer width = 2999
integer height = 1236
string title = "Articulos no valorizados (PT903)"
string menuname = "m_impresion"
long backcolor = 12632256
cb_10 cb_10
st_1 st_1
em_ano em_ano
end type
global w_pt903_articulos_no_valorizados w_pt903_articulos_no_valorizados

on w_pt903_articulos_no_valorizados.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.cb_10=create cb_10
this.st_1=create st_1
this.em_ano=create em_ano
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_10
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.em_ano
end on

on w_pt903_articulos_no_valorizados.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_10)
destroy(this.st_1)
destroy(this.em_ano)
end on

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

event ue_retrieve();call super::ue_retrieve;Long ll_ano
ll_ano = Long(em_ano.text)
//dw_report.SetTransObject(sqlca)

ib_preview = false
this.Event ue_preview()

dw_report.retrieve(ll_ano)
dw_report.object.t_user.text = gs_user
dw_report.object.t_titulo1.text = "Año :" + STRING( ll_ano)
dw_report.object.p_logo.filename = gs_logo

end event

type dw_report from w_report_smpl`dw_report within w_pt903_articulos_no_valorizados
integer x = 9
integer y = 212
string dataobject = "d_rpt_articulos_no_valorizados"
end type

type cb_10 from commandbutton within w_pt903_articulos_no_valorizados
integer x = 2313
integer y = 56
integer width = 306
integer height = 92
integer taborder = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Aceptar"
boolean default = true
end type

event clicked;parent.event ue_retrieve()

end event

type st_1 from statictext within w_pt903_articulos_no_valorizados
integer x = 146
integer y = 60
integer width = 151
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Año:"
boolean focusrectangle = false
end type

type em_ano from editmask within w_pt903_articulos_no_valorizados
integer x = 347
integer y = 48
integer width = 247
integer height = 92
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
string mask = "####"
end type

