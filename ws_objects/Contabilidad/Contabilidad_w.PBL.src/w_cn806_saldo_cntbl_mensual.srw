$PBExportHeader$w_cn806_saldo_cntbl_mensual.srw
forward
global type w_cn806_saldo_cntbl_mensual from w_report_smpl
end type
type sle_ano from singlelineedit within w_cn806_saldo_cntbl_mensual
end type
type st_1 from statictext within w_cn806_saldo_cntbl_mensual
end type
type st_2 from statictext within w_cn806_saldo_cntbl_mensual
end type
type sle_nivel from singlelineedit within w_cn806_saldo_cntbl_mensual
end type
type cb_1 from commandbutton within w_cn806_saldo_cntbl_mensual
end type
type cbx_1 from checkbox within w_cn806_saldo_cntbl_mensual
end type
type cb_2 from commandbutton within w_cn806_saldo_cntbl_mensual
end type
type ddlb_1 from dropdownlistbox within w_cn806_saldo_cntbl_mensual
end type
type gb_1 from groupbox within w_cn806_saldo_cntbl_mensual
end type
type gb_2 from groupbox within w_cn806_saldo_cntbl_mensual
end type
type gb_3 from groupbox within w_cn806_saldo_cntbl_mensual
end type
end forward

global type w_cn806_saldo_cntbl_mensual from w_report_smpl
integer width = 3342
integer height = 1764
string title = "[CN806] Movimiento Mensual por Nivel de Cuenta"
string menuname = "m_abc_report_smpl"
sle_ano sle_ano
st_1 st_1
st_2 st_2
sle_nivel sle_nivel
cb_1 cb_1
cbx_1 cbx_1
cb_2 cb_2
ddlb_1 ddlb_1
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
end type
global w_cn806_saldo_cntbl_mensual w_cn806_saldo_cntbl_mensual

type variables
string is_moneda, is_cod_soles, is_cod_dolares
end variables

on w_cn806_saldo_cntbl_mensual.create
int iCurrent
call super::create
if this.MenuName = "m_abc_report_smpl" then this.MenuID = create m_abc_report_smpl
this.sle_ano=create sle_ano
this.st_1=create st_1
this.st_2=create st_2
this.sle_nivel=create sle_nivel
this.cb_1=create cb_1
this.cbx_1=create cbx_1
this.cb_2=create cb_2
this.ddlb_1=create ddlb_1
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_ano
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.sle_nivel
this.Control[iCurrent+5]=this.cb_1
this.Control[iCurrent+6]=this.cbx_1
this.Control[iCurrent+7]=this.cb_2
this.Control[iCurrent+8]=this.ddlb_1
this.Control[iCurrent+9]=this.gb_1
this.Control[iCurrent+10]=this.gb_2
this.Control[iCurrent+11]=this.gb_3
end on

on w_cn806_saldo_cntbl_mensual.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_ano)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.sle_nivel)
destroy(this.cb_1)
destroy(this.cbx_1)
destroy(this.cb_2)
destroy(this.ddlb_1)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_3)
end on

event ue_open_pre;call super::ue_open_pre;sle_ano.text = string(today(),'yyyy')
sle_nivel.text = string(4)

select cod_soles, cod_dolares
  into :is_cod_soles, :is_cod_dolares
  from logparam
 where reckey = '1';

is_moneda = is_cod_soles
end event

type dw_report from w_report_smpl`dw_report within w_cn806_saldo_cntbl_mensual
integer x = 37
integer y = 256
integer width = 3040
integer height = 1064
string dataobject = "d_rpt_saldo_men_cntbl_x_niveles_dol"
end type

type sle_ano from singlelineedit within w_cn806_saldo_cntbl_mensual
integer x = 219
integer y = 112
integer width = 224
integer height = 72
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

type st_1 from statictext within w_cn806_saldo_cntbl_mensual
integer x = 59
integer y = 120
integer width = 142
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Año:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_2 from statictext within w_cn806_saldo_cntbl_mensual
integer x = 498
integer y = 128
integer width = 462
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Nivel Cnta. Contable:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_nivel from singlelineedit within w_cn806_saldo_cntbl_mensual
integer x = 978
integer y = 112
integer width = 174
integer height = 72
integer taborder = 20
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

type cb_1 from commandbutton within w_cn806_saldo_cntbl_mensual
integer x = 1330
integer y = 100
integer width = 343
integer height = 100
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Seleccion..."
end type

event clicked;openwithparm(w_seleccion_cnta_ctbl,integer(sle_nivel.text))
end event

type cbx_1 from checkbox within w_cn806_saldo_cntbl_mensual
integer x = 1696
integer y = 28
integer width = 69
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

event clicked;if checked = true then
	cb_1.enabled = true
else
	cb_1.enabled = false
end if
end event

type cb_2 from commandbutton within w_cn806_saldo_cntbl_mensual
integer x = 2405
integer y = 128
integer width = 343
integer height = 100
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Aceptar"
boolean default = true
end type

event clicked;dw_report.visible = false

if sle_ano.text = '' or isnull(sle_ano.text) then
	messagebox('Aviso','Debe de ingresar un Año valido')
	sle_ano.setfocus()
	return
end if

if sle_nivel.text = '' or isnull(sle_nivel.text) then
	messagebox('Aviso','Debe de ingresar un Nivel valido')
	sle_ano.setfocus()
	return
end if

if cbx_1.checked = false then
	
	insert into tt_cnt_cnta_ctbl (cnta_ctbl)
	     select cnta_ctbl
		    from cntbl_cnta
			where flag_estado = '1';
			
end if

if is_moneda = is_cod_soles then
	
	dw_report.dataobject = 'd_rpt_saldo_men_cntbl_x_niveles_sol'
	
else
	
	dw_report.dataobject = 'd_rpt_saldo_men_cntbl_x_niveles_dol'
	
end if

dw_report.settransobject(sqlca)
dw_report.retrieve(integer(sle_ano.text),integer(sle_nivel.text),gs_empresa,gs_user)
dw_report.object.p_logo.filename = gs_logo
dw_report.Modify("DataWindow.Print.Preview=Yes")
dw_report.visible = true
end event

type ddlb_1 from dropdownlistbox within w_cn806_saldo_cntbl_mensual
integer x = 1870
integer y = 100
integer width = 466
integer height = 352
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string item[] = {"Dolares","Soles"}
borderstyle borderstyle = stylelowered!
end type

event constructor;selectitem('Soles',2)
end event

event selectionchanged;if index = 1 then
	is_moneda = is_cod_dolares
else
	is_moneda = is_cod_soles
end if
end event

type gb_1 from groupbox within w_cn806_saldo_cntbl_mensual
integer x = 37
integer y = 32
integer width = 1175
integer height = 196
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Opciones"
end type

type gb_2 from groupbox within w_cn806_saldo_cntbl_mensual
integer x = 1243
integer y = 32
integer width = 553
integer height = 196
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Cnta Contables"
end type

type gb_3 from groupbox within w_cn806_saldo_cntbl_mensual
integer x = 1829
integer y = 32
integer width = 553
integer height = 196
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Moneda"
end type

