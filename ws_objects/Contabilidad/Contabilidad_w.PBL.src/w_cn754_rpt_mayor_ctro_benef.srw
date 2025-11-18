$PBExportHeader$w_cn754_rpt_mayor_ctro_benef.srw
forward
global type w_cn754_rpt_mayor_ctro_benef from w_report_smpl
end type
type sle_ano from singlelineedit within w_cn754_rpt_mayor_ctro_benef
end type
type sle_mes from singlelineedit within w_cn754_rpt_mayor_ctro_benef
end type
type cb_1 from commandbutton within w_cn754_rpt_mayor_ctro_benef
end type
type st_3 from statictext within w_cn754_rpt_mayor_ctro_benef
end type
type st_4 from statictext within w_cn754_rpt_mayor_ctro_benef
end type
type rb_1 from radiobutton within w_cn754_rpt_mayor_ctro_benef
end type
type rb_2 from radiobutton within w_cn754_rpt_mayor_ctro_benef
end type
type sle_cenbef_desde from singlelineedit within w_cn754_rpt_mayor_ctro_benef
end type
type sle_cenbef_hasta from singlelineedit within w_cn754_rpt_mayor_ctro_benef
end type
type st_1 from statictext within w_cn754_rpt_mayor_ctro_benef
end type
type st_2 from statictext within w_cn754_rpt_mayor_ctro_benef
end type
type gb_1 from groupbox within w_cn754_rpt_mayor_ctro_benef
end type
type gb_2 from groupbox within w_cn754_rpt_mayor_ctro_benef
end type
type gb_3 from groupbox within w_cn754_rpt_mayor_ctro_benef
end type
end forward

global type w_cn754_rpt_mayor_ctro_benef from w_report_smpl
integer width = 3369
integer height = 1604
string title = "(CN754) Detalle del mayor general por Centros de Beneficio "
string menuname = "m_abc_report_smpl"
long backcolor = 12632256
sle_ano sle_ano
sle_mes sle_mes
cb_1 cb_1
st_3 st_3
st_4 st_4
rb_1 rb_1
rb_2 rb_2
sle_cenbef_desde sle_cenbef_desde
sle_cenbef_hasta sle_cenbef_hasta
st_1 st_1
st_2 st_2
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
end type
global w_cn754_rpt_mayor_ctro_benef w_cn754_rpt_mayor_ctro_benef

on w_cn754_rpt_mayor_ctro_benef.create
int iCurrent
call super::create
if this.MenuName = "m_abc_report_smpl" then this.MenuID = create m_abc_report_smpl
this.sle_ano=create sle_ano
this.sle_mes=create sle_mes
this.cb_1=create cb_1
this.st_3=create st_3
this.st_4=create st_4
this.rb_1=create rb_1
this.rb_2=create rb_2
this.sle_cenbef_desde=create sle_cenbef_desde
this.sle_cenbef_hasta=create sle_cenbef_hasta
this.st_1=create st_1
this.st_2=create st_2
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_ano
this.Control[iCurrent+2]=this.sle_mes
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.st_4
this.Control[iCurrent+6]=this.rb_1
this.Control[iCurrent+7]=this.rb_2
this.Control[iCurrent+8]=this.sle_cenbef_desde
this.Control[iCurrent+9]=this.sle_cenbef_hasta
this.Control[iCurrent+10]=this.st_1
this.Control[iCurrent+11]=this.st_2
this.Control[iCurrent+12]=this.gb_1
this.Control[iCurrent+13]=this.gb_2
this.Control[iCurrent+14]=this.gb_3
end on

on w_cn754_rpt_mayor_ctro_benef.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_ano)
destroy(this.sle_mes)
destroy(this.cb_1)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.sle_cenbef_desde)
destroy(this.sle_cenbef_hasta)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_3)
end on

event ue_retrieve;call super::ue_retrieve;String  ls_opcion, ls_cenbef_desde, ls_cenbef_hasta, ls_ano, ls_mes
Long    ll_ano, ll_mes
Integer ln_contador

If rb_1.checked = true then
	ls_opcion = '1'
Elseif rb_2.checked = true then
	ls_opcion = '2'
End if

ls_cenbef_desde = String(sle_cenbef_desde.text)
ls_cenbef_hasta = String(sle_cenbef_hasta.text)

If rb_1.checked = true then

	//  Verifica que centro de costo desde exista
	ln_contador = 0
	Select count(centro_benef)
	  Into :ln_contador
	  From centro_beneficio
	  Where centro_benef = :ls_cenbef_desde ;
	  
	If ln_contador = 0 then
		MessageBox(ls_cenbef_desde,'No Existe Centro de Beneficio Desde')
	End if

	//  Verifica que centro de costo hasta exista
	ln_contador = 0
	Select count(centro_benef)
	  Into :ln_contador
	  From centro_beneficio
	  Where centro_benef = :ls_cenbef_hasta ;
	  
	If ln_contador = 0 then
		MessageBox(ls_cenbef_hasta,'No Existe Centro de Beneficio Hasta')
	End if

End if

ll_ano = Long(sle_ano.text)
ll_mes = Long(sle_mes.text)

DECLARE pb_usp_cntbl_rpt_mayor_cenbef PROCEDURE FOR USP_CNTBL_RPT_MAYOR_CENBEF
        ( :ls_opcion, :ls_cenbef_desde, :ls_cenbef_hasta, :ll_ano, :ll_mes ) ;
Execute pb_usp_cntbl_rpt_mayor_cenbef ;

dw_report.retrieve()

dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_nombre.text = gs_empresa
dw_report.object.t_user.text = gs_user

end event

type dw_report from w_report_smpl`dw_report within w_cn754_rpt_mayor_ctro_benef
integer x = 23
integer y = 304
integer width = 3287
integer height = 1100
integer taborder = 80
string dataobject = "d_rpt_cntbl_mayor_cenbef"
end type

type sle_ano from singlelineedit within w_cn754_rpt_mayor_ctro_benef
integer x = 2368
integer y = 132
integer width = 192
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

type sle_mes from singlelineedit within w_cn754_rpt_mayor_ctro_benef
integer x = 2743
integer y = 132
integer width = 105
integer height = 72
integer taborder = 60
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

type cb_1 from commandbutton within w_cn754_rpt_mayor_ctro_benef
integer x = 2949
integer y = 120
integer width = 297
integer height = 92
integer taborder = 70
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

type st_3 from statictext within w_cn754_rpt_mayor_ctro_benef
integer x = 2578
integer y = 140
integer width = 160
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
string text = "Mes"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_4 from statictext within w_cn754_rpt_mayor_ctro_benef
integer x = 2203
integer y = 140
integer width = 155
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

type rb_1 from radiobutton within w_cn754_rpt_mayor_ctro_benef
integer x = 302
integer y = 108
integer width = 603
integer height = 72
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
string text = "Centro de Beneficio"
borderstyle borderstyle = styleraised!
end type

event clicked;if rb_1.checked = true then
	sle_cenbef_desde.enabled = true
	sle_cenbef_hasta.enabled = true
end if

end event

type rb_2 from radiobutton within w_cn754_rpt_mayor_ctro_benef
integer x = 302
integer y = 176
integer width = 558
integer height = 72
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
string text = "Todos"
borderstyle borderstyle = styleraised!
end type

event clicked;if rb_2.checked = true then
	sle_cenbef_desde.enabled = false
	sle_cenbef_hasta.enabled = false
	sle_cenbef_desde.text = ' '
	sle_cenbef_hasta.text = ' '
end if

end event

type sle_cenbef_desde from singlelineedit within w_cn754_rpt_mayor_ctro_benef
integer x = 1248
integer y = 132
integer width = 306
integer height = 72
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

type sle_cenbef_hasta from singlelineedit within w_cn754_rpt_mayor_ctro_benef
integer x = 1755
integer y = 132
integer width = 306
integer height = 72
integer taborder = 40
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

type st_1 from statictext within w_cn754_rpt_mayor_ctro_benef
integer x = 1042
integer y = 140
integer width = 197
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "Desde"
boolean focusrectangle = false
end type

type st_2 from statictext within w_cn754_rpt_mayor_ctro_benef
integer x = 1577
integer y = 140
integer width = 174
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "Hasta"
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_cn754_rpt_mayor_ctro_benef
integer x = 2167
integer y = 56
integer width = 745
integer height = 196
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 12632256
string text = " Periodo Contable "
borderstyle borderstyle = styleraised!
end type

type gb_2 from groupbox within w_cn754_rpt_mayor_ctro_benef
integer x = 992
integer y = 56
integer width = 1129
integer height = 196
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 12632256
string text = " Seleccione Centros de Beneficio"
borderstyle borderstyle = styleraised!
end type

type gb_3 from groupbox within w_cn754_rpt_mayor_ctro_benef
integer x = 233
integer y = 44
integer width = 690
integer height = 224
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 12632256
string text = " Elija Opción "
borderstyle borderstyle = styleraised!
end type

