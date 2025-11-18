$PBExportHeader$w_cn734_cntbl_rpt_saldos_cuentas.srw
forward
global type w_cn734_cntbl_rpt_saldos_cuentas from w_report_smpl
end type
type sle_ano from singlelineedit within w_cn734_cntbl_rpt_saldos_cuentas
end type
type sle_mes_ini from singlelineedit within w_cn734_cntbl_rpt_saldos_cuentas
end type
type cb_1 from commandbutton within w_cn734_cntbl_rpt_saldos_cuentas
end type
type st_3 from statictext within w_cn734_cntbl_rpt_saldos_cuentas
end type
type st_4 from statictext within w_cn734_cntbl_rpt_saldos_cuentas
end type
type st_2 from statictext within w_cn734_cntbl_rpt_saldos_cuentas
end type
type sle_mes_fin from singlelineedit within w_cn734_cntbl_rpt_saldos_cuentas
end type
type rb_gen from radiobutton within w_cn734_cntbl_rpt_saldos_cuentas
end type
type rb_con from radiobutton within w_cn734_cntbl_rpt_saldos_cuentas
end type
type gb_1 from groupbox within w_cn734_cntbl_rpt_saldos_cuentas
end type
end forward

global type w_cn734_cntbl_rpt_saldos_cuentas from w_report_smpl
integer width = 3410
integer height = 1532
string title = "Resumen de Cuenta Corriente (CN734)"
string menuname = "m_abc_report_smpl"
long backcolor = 12632256
sle_ano sle_ano
sle_mes_ini sle_mes_ini
cb_1 cb_1
st_3 st_3
st_4 st_4
st_2 st_2
sle_mes_fin sle_mes_fin
rb_gen rb_gen
rb_con rb_con
gb_1 gb_1
end type
global w_cn734_cntbl_rpt_saldos_cuentas w_cn734_cntbl_rpt_saldos_cuentas

on w_cn734_cntbl_rpt_saldos_cuentas.create
int iCurrent
call super::create
if this.MenuName = "m_abc_report_smpl" then this.MenuID = create m_abc_report_smpl
this.sle_ano=create sle_ano
this.sle_mes_ini=create sle_mes_ini
this.cb_1=create cb_1
this.st_3=create st_3
this.st_4=create st_4
this.st_2=create st_2
this.sle_mes_fin=create sle_mes_fin
this.rb_gen=create rb_gen
this.rb_con=create rb_con
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_ano
this.Control[iCurrent+2]=this.sle_mes_ini
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.st_4
this.Control[iCurrent+6]=this.st_2
this.Control[iCurrent+7]=this.sle_mes_fin
this.Control[iCurrent+8]=this.rb_gen
this.Control[iCurrent+9]=this.rb_con
this.Control[iCurrent+10]=this.gb_1
end on

on w_cn734_cntbl_rpt_saldos_cuentas.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_ano)
destroy(this.sle_mes_ini)
destroy(this.cb_1)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.st_2)
destroy(this.sle_mes_fin)
destroy(this.rb_gen)
destroy(this.rb_con)
destroy(this.gb_1)
end on

event ue_retrieve();call super::ue_retrieve;String ls_ano, ls_mes_ini, ls_mes_fin

ls_ano = String(sle_ano.text)
ls_mes_ini = String(sle_mes_ini.text)
ls_mes_fin = String(sle_mes_fin.text)

IF rb_gen.checked = true THEN
	idw_1.DataObject='d_cns_saldo_ctacte_anual_tbl'
	idw_1.SetTransObject(sqlca)
	
	idw_1.retrieve(long(ls_ano), long(ls_mes_ini), long(ls_mes_fin))
   idw_1.object.t_ano.text  = ls_ano
   idw_1.object.t_mesi.text = ls_mes_ini
   idw_1.object.t_mesf.text = ls_mes_fin
	
ELSE
	
	DECLARE pb_usp_cntbl_rpt_saldos_cuentas PROCEDURE FOR USP_CNTBL_RPT_SALDOS_CUENTAS
        ( :ls_ano, :ls_mes_ini, :ls_mes_fin ) ;
	Execute pb_usp_cntbl_rpt_saldos_cuentas ;
	
	idw_1.DataObject='d_cntbl_rpt_saldos_cuentas_tbl'
	idw_1.SetTransObject(sqlca)
	idw_1.retrieve()

END IF

idw_1.object.p_logo.filename = gs_logo
idw_1.object.t_nombre.text = gs_empresa
idw_1.object.t_user.text = gs_user

end event

type dw_report from w_report_smpl`dw_report within w_cn734_cntbl_rpt_saldos_cuentas
integer x = 23
integer y = 284
integer width = 3328
integer height = 1052
integer taborder = 70
string dataobject = "d_cntbl_rpt_saldos_cuentas_tbl"
end type

type sle_ano from singlelineedit within w_cn734_cntbl_rpt_saldos_cuentas
integer x = 1623
integer y = 120
integer width = 192
integer height = 76
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type sle_mes_ini from singlelineedit within w_cn734_cntbl_rpt_saldos_cuentas
integer x = 2190
integer y = 120
integer width = 105
integer height = 72
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type cb_1 from commandbutton within w_cn734_cntbl_rpt_saldos_cuentas
integer x = 2926
integer y = 100
integer width = 297
integer height = 92
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aceptar"
end type

event clicked;Parent.Event ue_preview()
Parent.Event ue_retrieve()
Parent.Event ue_preview()

end event

type st_3 from statictext within w_cn734_cntbl_rpt_saldos_cuentas
integer x = 1865
integer y = 132
integer width = 265
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Mes Inicio"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_4 from statictext within w_cn734_cntbl_rpt_saldos_cuentas
integer x = 1431
integer y = 132
integer width = 174
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Año"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_2 from statictext within w_cn734_cntbl_rpt_saldos_cuentas
integer x = 2350
integer y = 132
integer width = 247
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Mes Final"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_mes_fin from singlelineedit within w_cn734_cntbl_rpt_saldos_cuentas
integer x = 2661
integer y = 120
integer width = 105
integer height = 72
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type rb_gen from radiobutton within w_cn734_cntbl_rpt_saldos_cuentas
integer x = 521
integer y = 128
integer width = 357
integer height = 56
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "General"
end type

type rb_con from radiobutton within w_cn734_cntbl_rpt_saldos_cuentas
integer x = 910
integer y = 128
integer width = 457
integer height = 56
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Configurado"
end type

type gb_1 from groupbox within w_cn734_cntbl_rpt_saldos_cuentas
integer x = 421
integer y = 60
integer width = 2427
integer height = 164
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 12632256
string text = " Periodo Contable "
end type

