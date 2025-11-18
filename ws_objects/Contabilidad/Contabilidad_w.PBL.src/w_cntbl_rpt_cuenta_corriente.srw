$PBExportHeader$w_cntbl_rpt_cuenta_corriente.srw
forward
global type w_cntbl_rpt_cuenta_corriente from w_report_smpl
end type
type cb_1 from commandbutton within w_cntbl_rpt_cuenta_corriente
end type
type sle_codigo_desde from singlelineedit within w_cntbl_rpt_cuenta_corriente
end type
type sle_codigo_hasta from singlelineedit within w_cntbl_rpt_cuenta_corriente
end type
type cb_2 from commandbutton within w_cntbl_rpt_cuenta_corriente
end type
type rb_1 from radiobutton within w_cntbl_rpt_cuenta_corriente
end type
type rb_2 from radiobutton within w_cntbl_rpt_cuenta_corriente
end type
type rb_3 from radiobutton within w_cntbl_rpt_cuenta_corriente
end type
type cb_3 from commandbutton within w_cntbl_rpt_cuenta_corriente
end type
type st_1 from statictext within w_cntbl_rpt_cuenta_corriente
end type
type st_2 from statictext within w_cntbl_rpt_cuenta_corriente
end type
type sle_cuenta_desde from singlelineedit within w_cntbl_rpt_cuenta_corriente
end type
type sle_cuenta_hasta from singlelineedit within w_cntbl_rpt_cuenta_corriente
end type
type cb_4 from commandbutton within w_cntbl_rpt_cuenta_corriente
end type
type cb_5 from commandbutton within w_cntbl_rpt_cuenta_corriente
end type
type st_3 from statictext within w_cntbl_rpt_cuenta_corriente
end type
type st_4 from statictext within w_cntbl_rpt_cuenta_corriente
end type
type gb_2 from groupbox within w_cntbl_rpt_cuenta_corriente
end type
type gb_3 from groupbox within w_cntbl_rpt_cuenta_corriente
end type
type gb_1 from groupbox within w_cntbl_rpt_cuenta_corriente
end type
end forward

global type w_cntbl_rpt_cuenta_corriente from w_report_smpl
integer width = 3707
integer height = 1604
string title = "Reporte de Saldos de Cuenta Corriente"
string menuname = "m_abc_report_smpl"
long backcolor = 12632256
cb_1 cb_1
sle_codigo_desde sle_codigo_desde
sle_codigo_hasta sle_codigo_hasta
cb_2 cb_2
rb_1 rb_1
rb_2 rb_2
rb_3 rb_3
cb_3 cb_3
st_1 st_1
st_2 st_2
sle_cuenta_desde sle_cuenta_desde
sle_cuenta_hasta sle_cuenta_hasta
cb_4 cb_4
cb_5 cb_5
st_3 st_3
st_4 st_4
gb_2 gb_2
gb_3 gb_3
gb_1 gb_1
end type
global w_cntbl_rpt_cuenta_corriente w_cntbl_rpt_cuenta_corriente

on w_cntbl_rpt_cuenta_corriente.create
int iCurrent
call super::create
if this.MenuName = "m_abc_report_smpl" then this.MenuID = create m_abc_report_smpl
this.cb_1=create cb_1
this.sle_codigo_desde=create sle_codigo_desde
this.sle_codigo_hasta=create sle_codigo_hasta
this.cb_2=create cb_2
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rb_3=create rb_3
this.cb_3=create cb_3
this.st_1=create st_1
this.st_2=create st_2
this.sle_cuenta_desde=create sle_cuenta_desde
this.sle_cuenta_hasta=create sle_cuenta_hasta
this.cb_4=create cb_4
this.cb_5=create cb_5
this.st_3=create st_3
this.st_4=create st_4
this.gb_2=create gb_2
this.gb_3=create gb_3
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.sle_codigo_desde
this.Control[iCurrent+3]=this.sle_codigo_hasta
this.Control[iCurrent+4]=this.cb_2
this.Control[iCurrent+5]=this.rb_1
this.Control[iCurrent+6]=this.rb_2
this.Control[iCurrent+7]=this.rb_3
this.Control[iCurrent+8]=this.cb_3
this.Control[iCurrent+9]=this.st_1
this.Control[iCurrent+10]=this.st_2
this.Control[iCurrent+11]=this.sle_cuenta_desde
this.Control[iCurrent+12]=this.sle_cuenta_hasta
this.Control[iCurrent+13]=this.cb_4
this.Control[iCurrent+14]=this.cb_5
this.Control[iCurrent+15]=this.st_3
this.Control[iCurrent+16]=this.st_4
this.Control[iCurrent+17]=this.gb_2
this.Control[iCurrent+18]=this.gb_3
this.Control[iCurrent+19]=this.gb_1
end on

on w_cntbl_rpt_cuenta_corriente.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.sle_codigo_desde)
destroy(this.sle_codigo_hasta)
destroy(this.cb_2)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_3)
destroy(this.cb_3)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.sle_cuenta_desde)
destroy(this.sle_cuenta_hasta)
destroy(this.cb_4)
destroy(this.cb_5)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.gb_2)
destroy(this.gb_3)
destroy(this.gb_1)
end on

event ue_retrieve();call super::ue_retrieve;String  ls_codigo_desde, ls_codigo_hasta
String  ls_cuenta_desde, ls_cuenta_hasta

ls_codigo_desde = String(sle_codigo_desde.text)
ls_codigo_hasta = String(sle_codigo_hasta.text)
ls_cuenta_desde = String(sle_cuenta_desde.text)
ls_cuenta_hasta = String(sle_cuenta_hasta.text)

DECLARE pb_usp_cntbl_rpt_saldo_cta_cte PROCEDURE FOR USP_CNTBL_RPT_SALDO_CTA_CTE
        ( :ls_codigo_desde, :ls_codigo_hasta, :ls_cuenta_desde, :ls_cuenta_hasta ) ;
Execute pb_usp_cntbl_rpt_saldo_cta_cte ;

dw_report.retrieve()

dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_nombre.text   = gs_empresa
dw_report.object.t_user.text     = gs_user

end event

event ue_open_pre();call super::ue_open_pre;gb_2.enabled = false
st_1.enabled = false
sle_codigo_desde.enabled = false
cb_2.enabled = false
st_2.enabled = false
sle_codigo_hasta.enabled = false
cb_3.enabled = false

gb_1.enabled = false
st_3.enabled = false
sle_cuenta_desde.enabled = false
cb_4.enabled = false
st_4.enabled = false
sle_cuenta_hasta.enabled = false
cb_5.enabled = false

cb_1.enabled = false
end event

type dw_report from w_report_smpl`dw_report within w_cntbl_rpt_cuenta_corriente
integer x = 23
integer y = 404
integer width = 3639
integer height = 1008
integer taborder = 0
string dataobject = "d_cntbl_rpt_cuenta_corriente_tbl"
end type

type cb_1 from commandbutton within w_cntbl_rpt_cuenta_corriente
integer x = 1984
integer y = 260
integer width = 297
integer height = 92
integer taborder = 90
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

type sle_codigo_desde from singlelineedit within w_cntbl_rpt_cuenta_corriente
integer x = 1024
integer y = 112
integer width = 283
integer height = 72
integer taborder = 10
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

type sle_codigo_hasta from singlelineedit within w_cntbl_rpt_cuenta_corriente
integer x = 1627
integer y = 112
integer width = 283
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

type cb_2 from commandbutton within w_cntbl_rpt_cuenta_corriente
integer x = 1335
integer y = 112
integer width = 87
integer height = 72
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;// Abre ventana de ayuda 

str_parametros sl_param

sl_param.dw1 = "d_cntbl_proveedor_tbl"
sl_param.titulo = "Seleccionar Búsqueda"
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2

OpenWithParm( w_search, sl_param)		
sl_param = MESSAGE.POWEROBJECTPARM
IF sl_param.titulo <> 'n' THEN
	sle_codigo_desde.text = sl_param.field_ret[1]
END IF

end event

type rb_1 from radiobutton within w_cntbl_rpt_cuenta_corriente
integer x = 91
integer y = 100
integer width = 594
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Código y Cuenta"
borderstyle borderstyle = styleraised!
end type

event clicked;if rb_1.checked = true then

	gb_2.enabled = true
	st_1.enabled = true
	sle_codigo_desde.enabled = true
	sle_codigo_desde.text = ' '
	cb_2.enabled = true
	st_2.enabled = true
	sle_codigo_hasta.enabled = true
	sle_codigo_hasta.text = ' '
	cb_3.enabled = true

	gb_1.enabled = true
	st_3.enabled = true
	sle_cuenta_desde.enabled = true
	sle_cuenta_desde.text = ' '
	cb_4.enabled = true
	st_4.enabled = true
	sle_cuenta_hasta.enabled = true
	sle_cuenta_hasta.text = ' '
	cb_5.enabled = true

	cb_1.enabled = true

end if

end event

type rb_2 from radiobutton within w_cntbl_rpt_cuenta_corriente
integer x = 91
integer y = 172
integer width = 594
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Código de Relación"
borderstyle borderstyle = styleraised!
end type

event clicked;if rb_2.checked = true then

	gb_2.enabled = true
	st_1.enabled = true
	sle_codigo_desde.enabled = true
	sle_codigo_desde.text = ' '
	cb_2.enabled = true
	st_2.enabled = true
	sle_codigo_hasta.enabled = true
	sle_codigo_hasta.text = ' '
	cb_3.enabled = true

	gb_1.enabled = false
	st_3.enabled = false
	sle_cuenta_desde.enabled = false
	sle_cuenta_desde.text = ' '
	cb_4.enabled = false
	st_4.enabled = false
	sle_cuenta_hasta.enabled = false
	sle_cuenta_hasta.text = ' '
	cb_5.enabled = false

	cb_1.enabled = true

end if

end event

type rb_3 from radiobutton within w_cntbl_rpt_cuenta_corriente
integer x = 91
integer y = 244
integer width = 594
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Cuenta Contable"
borderstyle borderstyle = styleraised!
end type

event clicked;if rb_3.checked = true then

	gb_2.enabled = false
	st_1.enabled = false
	sle_codigo_desde.enabled = false
	sle_codigo_desde.text = ' '
	cb_2.enabled = false
	st_2.enabled = false
	sle_codigo_hasta.enabled = false
	sle_codigo_hasta.text = ' '
	cb_3.enabled = false

	gb_1.enabled = true
	st_3.enabled = true
	sle_cuenta_desde.enabled = true
	sle_cuenta_desde.text = ' '
	cb_4.enabled = true
	st_4.enabled = true
	sle_cuenta_hasta.enabled = true
	sle_cuenta_hasta.text = ' '
	cb_5.enabled = true

	cb_1.enabled = true

end if

end event

type cb_3 from commandbutton within w_cntbl_rpt_cuenta_corriente
integer x = 1938
integer y = 112
integer width = 87
integer height = 72
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;// Abre ventana de ayuda 

str_parametros sl_param

sl_param.dw1 = "d_cntbl_proveedor_tbl"
sl_param.titulo = "Seleccionar Búsqueda"
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2

OpenWithParm( w_search, sl_param)		
sl_param = MESSAGE.POWEROBJECTPARM
IF sl_param.titulo <> 'n' THEN
	sle_codigo_hasta.text = sl_param.field_ret[1]
END IF

end event

type st_1 from statictext within w_cntbl_rpt_cuenta_corriente
integer x = 827
integer y = 120
integer width = 183
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

type st_2 from statictext within w_cntbl_rpt_cuenta_corriente
integer x = 1458
integer y = 120
integer width = 160
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

type sle_cuenta_desde from singlelineedit within w_cntbl_rpt_cuenta_corriente
integer x = 2400
integer y = 112
integer width = 329
integer height = 72
integer taborder = 50
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

type sle_cuenta_hasta from singlelineedit within w_cntbl_rpt_cuenta_corriente
integer x = 3063
integer y = 112
integer width = 329
integer height = 72
integer taborder = 70
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

type cb_4 from commandbutton within w_cntbl_rpt_cuenta_corriente
integer x = 2766
integer y = 112
integer width = 87
integer height = 72
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;// Abre ventana de ayuda 

str_parametros sl_param

sl_param.dw1 = "d_cntbl_cuentas_tbl"
sl_param.titulo = "Seleccionar Búsqueda"
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2

OpenWithParm( w_search, sl_param)		
sl_param = MESSAGE.POWEROBJECTPARM
IF sl_param.titulo <> 'n' THEN
	sle_cuenta_desde.text = sl_param.field_ret[1]
END IF

end event

type cb_5 from commandbutton within w_cntbl_rpt_cuenta_corriente
integer x = 3419
integer y = 112
integer width = 87
integer height = 72
integer taborder = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;// Abre ventana de ayuda 

str_parametros sl_param

sl_param.dw1 = "d_cntbl_cuentas_tbl"
sl_param.titulo = "Seleccionar Búsqueda"
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2

OpenWithParm( w_search, sl_param)		
sl_param = MESSAGE.POWEROBJECTPARM
IF sl_param.titulo <> 'n' THEN
	sle_cuenta_hasta.text = sl_param.field_ret[1]
END IF

end event

type st_3 from statictext within w_cntbl_rpt_cuenta_corriente
integer x = 2213
integer y = 120
integer width = 183
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Desde"
boolean focusrectangle = false
end type

type st_4 from statictext within w_cntbl_rpt_cuenta_corriente
integer x = 2885
integer y = 120
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
long backcolor = 67108864
string text = "Hasta"
boolean focusrectangle = false
end type

type gb_2 from groupbox within w_cntbl_rpt_cuenta_corriente
integer x = 763
integer y = 36
integer width = 1339
integer height = 196
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = " Seleccione Código de Relación "
borderstyle borderstyle = stylelowered!
end type

type gb_3 from groupbox within w_cntbl_rpt_cuenta_corriente
integer x = 37
integer y = 32
integer width = 690
integer height = 312
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = " Opción "
borderstyle borderstyle = stylelowered!
end type

type gb_1 from groupbox within w_cntbl_rpt_cuenta_corriente
integer x = 2149
integer y = 36
integer width = 1422
integer height = 196
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = " Seleccione Cuenta Contable "
borderstyle borderstyle = stylelowered!
end type

