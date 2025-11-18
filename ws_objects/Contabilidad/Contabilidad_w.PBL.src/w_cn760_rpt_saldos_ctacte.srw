$PBExportHeader$w_cn760_rpt_saldos_ctacte.srw
forward
global type w_cn760_rpt_saldos_ctacte from w_report_smpl
end type
type cb_1 from commandbutton within w_cn760_rpt_saldos_ctacte
end type
type em_ano from editmask within w_cn760_rpt_saldos_ctacte
end type
type st_1 from statictext within w_cn760_rpt_saldos_ctacte
end type
type st_2 from statictext within w_cn760_rpt_saldos_ctacte
end type
type st_3 from statictext within w_cn760_rpt_saldos_ctacte
end type
type sle_mes_ini from singlelineedit within w_cn760_rpt_saldos_ctacte
end type
type sle_mes_fin from singlelineedit within w_cn760_rpt_saldos_ctacte
end type
type gb_1 from groupbox within w_cn760_rpt_saldos_ctacte
end type
end forward

global type w_cn760_rpt_saldos_ctacte from w_report_smpl
integer width = 3369
integer height = 1508
string title = "(CN760) Saldos de Cuenta Corriente por Proveedores y Cuentas Contables"
string menuname = "m_abc_report_smpl"
long backcolor = 12632256
cb_1 cb_1
em_ano em_ano
st_1 st_1
st_2 st_2
st_3 st_3
sle_mes_ini sle_mes_ini
sle_mes_fin sle_mes_fin
gb_1 gb_1
end type
global w_cn760_rpt_saldos_ctacte w_cn760_rpt_saldos_ctacte

on w_cn760_rpt_saldos_ctacte.create
int iCurrent
call super::create
if this.MenuName = "m_abc_report_smpl" then this.MenuID = create m_abc_report_smpl
this.cb_1=create cb_1
this.em_ano=create em_ano
this.st_1=create st_1
this.st_2=create st_2
this.st_3=create st_3
this.sle_mes_ini=create sle_mes_ini
this.sle_mes_fin=create sle_mes_fin
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.em_ano
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.st_3
this.Control[iCurrent+6]=this.sle_mes_ini
this.Control[iCurrent+7]=this.sle_mes_fin
this.Control[iCurrent+8]=this.gb_1
end on

on w_cn760_rpt_saldos_ctacte.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.em_ano)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.sle_mes_ini)
destroy(this.sle_mes_fin)
destroy(this.gb_1)
end on

event ue_retrieve;call super::ue_retrieve;string  ls_mes_ini, ls_mes_fin
integer li_ano, li_mes_ini, li_mes_fin

li_ano     = integer(em_ano.text)
ls_mes_ini = string(sle_mes_ini.text)
ls_mes_fin = string(sle_mes_fin.text)
li_mes_ini = integer(ls_mes_ini)
li_mes_fin = integer(ls_mes_fin)

DECLARE pb_usp_cntbl_rpt_ctacte_saldos PROCEDURE FOR USP_CNTBL_RPT_CTACTE_SALDOS
        ( :li_ano, :li_mes_ini, :li_mes_fin ) ;
Execute pb_usp_cntbl_rpt_ctacte_saldos ;

dw_report.retrieve()

dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_nombre.text = gs_empresa
dw_report.object.t_user.text = gs_user

end event

type dw_report from w_report_smpl`dw_report within w_cn760_rpt_saldos_ctacte
integer x = 18
integer y = 336
integer width = 3305
integer height = 984
integer taborder = 50
string dataobject = "d_cntbl_rpt_ctacte_saldos_tbl"
end type

type cb_1 from commandbutton within w_cn760_rpt_saldos_ctacte
integer x = 2592
integer y = 144
integer width = 270
integer height = 84
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aceptar"
end type

event clicked;Parent.Event ue_retrieve()

end event

type em_ano from editmask within w_cn760_rpt_saldos_ctacte
integer x = 1193
integer y = 148
integer width = 229
integer height = 80
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
alignment alignment = center!
borderstyle borderstyle = stylelowered!
string mask = "####"
end type

type st_1 from statictext within w_cn760_rpt_saldos_ctacte
integer x = 1042
integer y = 160
integer width = 123
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "Año"
boolean focusrectangle = false
end type

type st_2 from statictext within w_cn760_rpt_saldos_ctacte
integer x = 1472
integer y = 160
integer width = 270
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "Mes Inicio"
boolean focusrectangle = false
end type

type st_3 from statictext within w_cn760_rpt_saldos_ctacte
integer x = 1952
integer y = 160
integer width = 251
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "Mes Final"
boolean focusrectangle = false
end type

type sle_mes_ini from singlelineedit within w_cn760_rpt_saldos_ctacte
integer x = 1778
integer y = 148
integer width = 142
integer height = 80
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
borderstyle borderstyle = stylelowered!
end type

type sle_mes_fin from singlelineedit within w_cn760_rpt_saldos_ctacte
integer x = 2245
integer y = 148
integer width = 142
integer height = 80
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
borderstyle borderstyle = stylelowered!
end type

type gb_1 from groupbox within w_cn760_rpt_saldos_ctacte
integer x = 942
integer y = 68
integer width = 1545
integer height = 212
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 12632256
string text = " Ingrese Datos "
end type

