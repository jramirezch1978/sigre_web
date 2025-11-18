$PBExportHeader$w_aud704_detalle_saldos_cta_cte.srw
forward
global type w_aud704_detalle_saldos_cta_cte from w_report_smpl
end type
type cb_1 from commandbutton within w_aud704_detalle_saldos_cta_cte
end type
type cb_4 from commandbutton within w_aud704_detalle_saldos_cta_cte
end type
type st_3 from statictext within w_aud704_detalle_saldos_cta_cte
end type
type st_20 from statictext within w_aud704_detalle_saldos_cta_cte
end type
type st_21 from statictext within w_aud704_detalle_saldos_cta_cte
end type
type em_ano from editmask within w_aud704_detalle_saldos_cta_cte
end type
type em_mes from editmask within w_aud704_detalle_saldos_cta_cte
end type
type em_cuenta from editmask within w_aud704_detalle_saldos_cta_cte
end type
type em_descripcion from editmask within w_aud704_detalle_saldos_cta_cte
end type
type rb_1 from radiobutton within w_aud704_detalle_saldos_cta_cte
end type
type rb_2 from radiobutton within w_aud704_detalle_saldos_cta_cte
end type
type gb_22 from groupbox within w_aud704_detalle_saldos_cta_cte
end type
type gb_1 from groupbox within w_aud704_detalle_saldos_cta_cte
end type
end forward

global type w_aud704_detalle_saldos_cta_cte from w_report_smpl
integer width = 3694
integer height = 1628
string title = "Detalle de Saldos de Cuenta Corriente(AUD704)"
string menuname = "m_reporte"
long backcolor = 12632256
cb_1 cb_1
cb_4 cb_4
st_3 st_3
st_20 st_20
st_21 st_21
em_ano em_ano
em_mes em_mes
em_cuenta em_cuenta
em_descripcion em_descripcion
rb_1 rb_1
rb_2 rb_2
gb_22 gb_22
gb_1 gb_1
end type
global w_aud704_detalle_saldos_cta_cte w_aud704_detalle_saldos_cta_cte

type variables
String is_opcion

end variables

on w_aud704_detalle_saldos_cta_cte.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.cb_1=create cb_1
this.cb_4=create cb_4
this.st_3=create st_3
this.st_20=create st_20
this.st_21=create st_21
this.em_ano=create em_ano
this.em_mes=create em_mes
this.em_cuenta=create em_cuenta
this.em_descripcion=create em_descripcion
this.rb_1=create rb_1
this.rb_2=create rb_2
this.gb_22=create gb_22
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.cb_4
this.Control[iCurrent+3]=this.st_3
this.Control[iCurrent+4]=this.st_20
this.Control[iCurrent+5]=this.st_21
this.Control[iCurrent+6]=this.em_ano
this.Control[iCurrent+7]=this.em_mes
this.Control[iCurrent+8]=this.em_cuenta
this.Control[iCurrent+9]=this.em_descripcion
this.Control[iCurrent+10]=this.rb_1
this.Control[iCurrent+11]=this.rb_2
this.Control[iCurrent+12]=this.gb_22
this.Control[iCurrent+13]=this.gb_1
end on

on w_aud704_detalle_saldos_cta_cte.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.cb_4)
destroy(this.st_3)
destroy(this.st_20)
destroy(this.st_21)
destroy(this.em_ano)
destroy(this.em_mes)
destroy(this.em_cuenta)
destroy(this.em_descripcion)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.gb_22)
destroy(this.gb_1)
end on

event ue_retrieve;call super::ue_retrieve;Integer li_ano, li_mes
String  ls_cuenta, ls_descripcion, ls_moneda

li_ano = Integer(em_ano.text)
li_mes = Integer(em_mes.text)
ls_cuenta = String(em_cuenta.text)
ls_descripcion = String(em_descripcion.text)

if rb_1.checked = true then
	ls_moneda = 'S'
elseif rb_2.checked = true then
	ls_moneda = 'D'
end if

DECLARE pb_usp_aud_rpt_detsal_ctacte PROCEDURE FOR USP_AUD_RPT_DETSAL_CTACTE
        ( :li_ano, :li_mes, :ls_cuenta, :ls_descripcion, :ls_moneda ) ;
Execute pb_usp_aud_rpt_detsal_ctacte ;

dw_report.retrieve()

dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_nombre.text   = gs_empresa
dw_report.object.t_user.text     = gs_user

end event

type dw_report from w_report_smpl`dw_report within w_aud704_detalle_saldos_cta_cte
integer y = 320
integer width = 3634
integer height = 1120
integer taborder = 60
string dataobject = "d_rpt_saldos_cta_cte_tbl"
end type

type cb_1 from commandbutton within w_aud704_detalle_saldos_cta_cte
integer x = 3227
integer y = 124
integer width = 297
integer height = 92
integer taborder = 50
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

type cb_4 from commandbutton within w_aud704_detalle_saldos_cta_cte
integer x = 1870
integer y = 136
integer width = 87
integer height = 72
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;// Abre ventana de ayuda 

Sg_parametros sl_param

sl_param.dw1 = "d_cuenta_tbl"
sl_param.titulo = "Seleccionar Búsqueda"
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2

OpenWithParm( w_search, sl_param)		
sl_param = MESSAGE.POWEROBJECTPARM
IF sl_param.titulo <> 'n' THEN
	em_cuenta.text      = sl_param.field_ret[1]
	em_descripcion.text = sl_param.field_ret[2]
END IF

end event

type st_3 from statictext within w_aud704_detalle_saldos_cta_cte
integer x = 1262
integer y = 144
integer width = 174
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
long backcolor = 67108864
string text = "Cuenta"
boolean focusrectangle = false
end type

type st_20 from statictext within w_aud704_detalle_saldos_cta_cte
integer x = 937
integer y = 144
integer width = 119
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
string text = "Mes"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_21 from statictext within w_aud704_detalle_saldos_cta_cte
integer x = 553
integer y = 144
integer width = 119
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

type em_ano from editmask within w_aud704_detalle_saldos_cta_cte
integer x = 690
integer y = 132
integer width = 219
integer height = 80
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
alignment alignment = center!
borderstyle borderstyle = stylelowered!
string mask = "####"
end type

type em_mes from editmask within w_aud704_detalle_saldos_cta_cte
integer x = 1083
integer y = 132
integer width = 133
integer height = 80
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
alignment alignment = center!
borderstyle borderstyle = stylelowered!
string mask = "##"
end type

type em_cuenta from editmask within w_aud704_detalle_saldos_cta_cte
integer x = 1472
integer y = 132
integer width = 370
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
alignment alignment = center!
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type em_descripcion from editmask within w_aud704_detalle_saldos_cta_cte
integer x = 1989
integer y = 132
integer width = 1129
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type rb_1 from radiobutton within w_aud704_detalle_saldos_cta_cte
integer x = 110
integer y = 96
integer width = 302
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
long backcolor = 12632256
string text = "Soles"
end type

type rb_2 from radiobutton within w_aud704_detalle_saldos_cta_cte
integer x = 110
integer y = 168
integer width = 302
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Dolares"
end type

type gb_22 from groupbox within w_aud704_detalle_saldos_cta_cte
integer x = 507
integer y = 60
integer width = 2674
integer height = 196
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 12632256
string text = " Periodo Contable "
end type

type gb_1 from groupbox within w_aud704_detalle_saldos_cta_cte
integer x = 50
integer y = 36
integer width = 411
integer height = 236
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = " Seleccione "
end type

