$PBExportHeader$w_cn743_rpt_eeff_clientes.srw
forward
global type w_cn743_rpt_eeff_clientes from w_report_smpl
end type
type cb_1 from commandbutton within w_cn743_rpt_eeff_clientes
end type
type sle_ano from singlelineedit within w_cn743_rpt_eeff_clientes
end type
type sle_cuenta from singlelineedit within w_cn743_rpt_eeff_clientes
end type
type st_10 from statictext within w_cn743_rpt_eeff_clientes
end type
type st_11 from statictext within w_cn743_rpt_eeff_clientes
end type
type em_uit from editmask within w_cn743_rpt_eeff_clientes
end type
type st_1 from statictext within w_cn743_rpt_eeff_clientes
end type
type st_2 from statictext within w_cn743_rpt_eeff_clientes
end type
type em_factor from editmask within w_cn743_rpt_eeff_clientes
end type
type st_3 from statictext within w_cn743_rpt_eeff_clientes
end type
type gb_12 from groupbox within w_cn743_rpt_eeff_clientes
end type
end forward

global type w_cn743_rpt_eeff_clientes from w_report_smpl
integer width = 3735
integer height = 1564
string title = "(CN743) Texto de saldos por código de relación según cuenta"
string menuname = "m_abc_report_smpl"
long backcolor = 12632256
cb_1 cb_1
sle_ano sle_ano
sle_cuenta sle_cuenta
st_10 st_10
st_11 st_11
em_uit em_uit
st_1 st_1
st_2 st_2
em_factor em_factor
st_3 st_3
gb_12 gb_12
end type
global w_cn743_rpt_eeff_clientes w_cn743_rpt_eeff_clientes

on w_cn743_rpt_eeff_clientes.create
int iCurrent
call super::create
if this.MenuName = "m_abc_report_smpl" then this.MenuID = create m_abc_report_smpl
this.cb_1=create cb_1
this.sle_ano=create sle_ano
this.sle_cuenta=create sle_cuenta
this.st_10=create st_10
this.st_11=create st_11
this.em_uit=create em_uit
this.st_1=create st_1
this.st_2=create st_2
this.em_factor=create em_factor
this.st_3=create st_3
this.gb_12=create gb_12
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.sle_ano
this.Control[iCurrent+3]=this.sle_cuenta
this.Control[iCurrent+4]=this.st_10
this.Control[iCurrent+5]=this.st_11
this.Control[iCurrent+6]=this.em_uit
this.Control[iCurrent+7]=this.st_1
this.Control[iCurrent+8]=this.st_2
this.Control[iCurrent+9]=this.em_factor
this.Control[iCurrent+10]=this.st_3
this.Control[iCurrent+11]=this.gb_12
end on

on w_cn743_rpt_eeff_clientes.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.sle_ano)
destroy(this.sle_cuenta)
destroy(this.st_10)
destroy(this.st_11)
destroy(this.em_uit)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.em_factor)
destroy(this.st_3)
destroy(this.gb_12)
end on

event ue_retrieve;call super::ue_retrieve;integer li_monto, li_ano, li_factor
string  ls_cuenta

li_ano = integer(sle_ano.text)
ls_cuenta = String(sle_cuenta.text)
li_factor = integer(em_factor.text)
li_monto = integer(em_uit.text)

SetPointer(HourGlass!)

DECLARE PB_usp_cnt_importacion_saldos PROCEDURE FOR usp_cnt_importacion_saldos
		  ( :li_ano, :ls_cuenta, :li_monto, :li_factor ) ;
Execute PB_usp_cnt_importacion_saldos ;

dw_report.retrieve()

SetPointer(Arrow!)


end event

event ue_open_pre;call super::ue_open_pre;//dw_almacen.SetTransObject(sqlca)
//dw_almacen.retrieve()
end event

type dw_report from w_report_smpl`dw_report within w_cn743_rpt_eeff_clientes
integer x = 9
integer y = 284
integer width = 3657
integer height = 1068
integer taborder = 0
string dataobject = "d_abc_importar_saldo_tbl"
end type

type cb_1 from commandbutton within w_cn743_rpt_eeff_clientes
integer x = 2373
integer y = 120
integer width = 297
integer height = 92
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

type sle_ano from singlelineedit within w_cn743_rpt_eeff_clientes
integer x = 270
integer y = 132
integer width = 192
integer height = 76
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
integer limit = 4
borderstyle borderstyle = stylelowered!
end type

type sle_cuenta from singlelineedit within w_cn743_rpt_eeff_clientes
integer x = 965
integer y = 136
integer width = 137
integer height = 72
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
integer limit = 2
borderstyle borderstyle = stylelowered!
end type

type st_10 from statictext within w_cn743_rpt_eeff_clientes
integer x = 503
integer y = 140
integer width = 425
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 12632256
string text = "Cuenta Dos Dígitos"
boolean focusrectangle = false
end type

type st_11 from statictext within w_cn743_rpt_eeff_clientes
integer x = 101
integer y = 140
integer width = 155
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 12632256
string text = "Año"
alignment alignment = center!
boolean focusrectangle = false
end type

type em_uit from editmask within w_cn743_rpt_eeff_clientes
integer x = 1477
integer y = 124
integer width = 352
integer height = 84
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "##,###,###,###.00"
end type

type st_1 from statictext within w_cn743_rpt_eeff_clientes
integer x = 1115
integer y = 140
integer width = 311
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 12632256
string text = "Importe U.I.T."
alignment alignment = right!
boolean focusrectangle = false
end type

type st_2 from statictext within w_cn743_rpt_eeff_clientes
integer x = 1861
integer y = 140
integer width = 169
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 12632256
string text = "Factor"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_factor from editmask within w_cn743_rpt_eeff_clientes
integer x = 2080
integer y = 124
integer width = 178
integer height = 84
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "##"
end type

type st_3 from statictext within w_cn743_rpt_eeff_clientes
integer x = 2775
integer y = 144
integer width = 827
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 67108864
string text = "Factor si es D = 1  y si es H = - 1"
boolean focusrectangle = false
end type

type gb_12 from groupbox within w_cn743_rpt_eeff_clientes
integer x = 78
integer y = 52
integer width = 2249
integer height = 200
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 12632256
string text = " Seleccione  "
end type

