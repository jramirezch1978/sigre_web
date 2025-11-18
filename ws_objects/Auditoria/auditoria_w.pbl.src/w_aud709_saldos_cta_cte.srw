$PBExportHeader$w_aud709_saldos_cta_cte.srw
forward
global type w_aud709_saldos_cta_cte from w_report_smpl
end type
type cb_1 from commandbutton within w_aud709_saldos_cta_cte
end type
type sle_codigo_desde from singlelineedit within w_aud709_saldos_cta_cte
end type
type sle_codigo_hasta from singlelineedit within w_aud709_saldos_cta_cte
end type
type cb_2 from commandbutton within w_aud709_saldos_cta_cte
end type
type rb_1 from radiobutton within w_aud709_saldos_cta_cte
end type
type rb_2 from radiobutton within w_aud709_saldos_cta_cte
end type
type rb_3 from radiobutton within w_aud709_saldos_cta_cte
end type
type cb_3 from commandbutton within w_aud709_saldos_cta_cte
end type
type st_1 from statictext within w_aud709_saldos_cta_cte
end type
type st_2 from statictext within w_aud709_saldos_cta_cte
end type
type sle_cuenta_desde from singlelineedit within w_aud709_saldos_cta_cte
end type
type sle_cuenta_hasta from singlelineedit within w_aud709_saldos_cta_cte
end type
type cb_4 from commandbutton within w_aud709_saldos_cta_cte
end type
type cb_5 from commandbutton within w_aud709_saldos_cta_cte
end type
type st_3 from statictext within w_aud709_saldos_cta_cte
end type
type st_4 from statictext within w_aud709_saldos_cta_cte
end type
type st_20 from statictext within w_aud709_saldos_cta_cte
end type
type st_21 from statictext within w_aud709_saldos_cta_cte
end type
type em_ano from editmask within w_aud709_saldos_cta_cte
end type
type em_mes from editmask within w_aud709_saldos_cta_cte
end type
type uo_1 from u_ingreso_fecha within w_aud709_saldos_cta_cte
end type
type ddlb_1 from dropdownlistbox within w_aud709_saldos_cta_cte
end type
type gb_2 from groupbox within w_aud709_saldos_cta_cte
end type
type gb_3 from groupbox within w_aud709_saldos_cta_cte
end type
type gb_1 from groupbox within w_aud709_saldos_cta_cte
end type
type gb_22 from groupbox within w_aud709_saldos_cta_cte
end type
type gb_4 from groupbox within w_aud709_saldos_cta_cte
end type
type gb_5 from groupbox within w_aud709_saldos_cta_cte
end type
end forward

global type w_aud709_saldos_cta_cte from w_report_smpl
integer width = 3707
integer height = 1604
string title = "Reporte de Saldos de Cuenta Corriente[AUD709] "
string menuname = "m_reporte"
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
st_20 st_20
st_21 st_21
em_ano em_ano
em_mes em_mes
uo_1 uo_1
ddlb_1 ddlb_1
gb_2 gb_2
gb_3 gb_3
gb_1 gb_1
gb_22 gb_22
gb_4 gb_4
gb_5 gb_5
end type
global w_aud709_saldos_cta_cte w_aud709_saldos_cta_cte

type variables
String is_opcion

end variables

on w_aud709_saldos_cta_cte.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
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
this.st_20=create st_20
this.st_21=create st_21
this.em_ano=create em_ano
this.em_mes=create em_mes
this.uo_1=create uo_1
this.ddlb_1=create ddlb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
this.gb_1=create gb_1
this.gb_22=create gb_22
this.gb_4=create gb_4
this.gb_5=create gb_5
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
this.Control[iCurrent+17]=this.st_20
this.Control[iCurrent+18]=this.st_21
this.Control[iCurrent+19]=this.em_ano
this.Control[iCurrent+20]=this.em_mes
this.Control[iCurrent+21]=this.uo_1
this.Control[iCurrent+22]=this.ddlb_1
this.Control[iCurrent+23]=this.gb_2
this.Control[iCurrent+24]=this.gb_3
this.Control[iCurrent+25]=this.gb_1
this.Control[iCurrent+26]=this.gb_22
this.Control[iCurrent+27]=this.gb_4
this.Control[iCurrent+28]=this.gb_5
end on

on w_aud709_saldos_cta_cte.destroy
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
destroy(this.st_20)
destroy(this.st_21)
destroy(this.em_ano)
destroy(this.em_mes)
destroy(this.uo_1)
destroy(this.ddlb_1)
destroy(this.gb_2)
destroy(this.gb_3)
destroy(this.gb_1)
destroy(this.gb_22)
destroy(this.gb_4)
destroy(this.gb_5)
end on

event ue_retrieve;call super::ue_retrieve;Integer ln_ano, ln_mes, ln_nro_dias
String  ls_codigo_desde, ls_codigo_hasta
String  ls_cuenta_desde, ls_cuenta_hasta
date 	  ld_fecha

ls_codigo_desde = TRIM(sle_codigo_desde.text)
ls_codigo_hasta = TRIM(sle_codigo_hasta.text)

ls_cuenta_desde = TRIM(sle_cuenta_desde.text)
ls_cuenta_hasta = TRIM(sle_cuenta_hasta.text)

ln_ano = Integer(em_ano.text)
ln_mes = Integer(em_mes.text)
ln_nro_dias = integer(upper(ddlb_1.Text))
ld_fecha = uo_1.of_get_fecha()

if isnull(ls_codigo_desde) or trim(ls_codigo_desde) = '' then ls_codigo_desde = '0'
if isnull(ls_codigo_hasta) or trim(ls_codigo_hasta) = '' then ls_codigo_hasta = '99999999'
if isnull(ls_cuenta_desde) or trim(ls_cuenta_desde) = '' then ls_cuenta_desde = '0'
if isnull(ls_cuenta_hasta) or trim(ls_cuenta_hasta) = '' then ls_cuenta_hasta = '99999999'

SetPointer(HourGlass!)

DECLARE pb_usp_aud_rpt_saldos_ctacte PROCEDURE FOR USP_AUD_RPT_SALDOS_CTACTE
        ( :ln_ano, :ln_mes, :ls_codigo_desde, :ls_codigo_hasta,
		  	 :ls_cuenta_desde, :ls_cuenta_hasta, :ld_fecha, :ln_nro_dias ) ;
Execute pb_usp_aud_rpt_saldos_ctacte ;

if rb_1.checked = true then
	idw_1.DataObject='d_rpt_saldos_codcta_tbl'
elseif rb_2.checked = true then
	idw_1.DataObject='d_rpt_saldos_codigo_tbl'
elseif rb_3.checked = true then
	idw_1.DataObject='d_rpt_saldos_cuenta_tbl'
end if

ib_preview = false
triggerevent('ue_preview')
idw_1.SetTransObject(sqlca)
idw_1.retrieve()

SetPointer(Arrow!)

idw_1.object.p_logo.filename = gs_logo
idw_1.object.t_nombre.text   = gs_empresa
idw_1.object.t_user.text     = gs_user
idw_1.object.t_dias.text     = string(ln_nro_dias)

end event

event ue_open_pre;call super::ue_open_pre;gb_2.enabled = false
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

type dw_report from w_report_smpl`dw_report within w_aud709_saldos_cta_cte
integer x = 23
integer y = 508
integer width = 3639
integer height = 904
integer taborder = 140
string dataobject = "d_cntbl_rpt_analitico_tbl"
end type

type cb_1 from commandbutton within w_aud709_saldos_cta_cte
integer x = 3159
integer y = 304
integer width = 297
integer height = 92
integer taborder = 130
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

type sle_codigo_desde from singlelineedit within w_aud709_saldos_cta_cte
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

type sle_codigo_hasta from singlelineedit within w_aud709_saldos_cta_cte
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

type cb_2 from commandbutton within w_aud709_saldos_cta_cte
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
/*
Sg_parametros sl_param

sl_param.dw1 = "d_cntbl_proveedor_tbl"
sl_param.titulo = "Seleccionar Búsqueda"
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2

OpenWithParm( w_search, sl_param)		
sl_param = MESSAGE.POWEROBJECTPARM
IF sl_param.titulo <> 'n' THEN
	sle_codigo_desde.text = sl_param.field_ret[1]
END IF
*/

str_seleccionar lstr_seleccionar

lstr_seleccionar.s_seleccion = 'S'
lstr_seleccionar.s_sql = 'SELECT PROVEEDOR.PROVEEDOR AS CODIGO, '&
										 +'PROVEEDOR.NOM_PROVEEDOR AS NOMBRE '&
										 +'FROM PROVEEDOR '
										  
OpenWithParm(w_seleccionar,lstr_seleccionar)
				
IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
	IF lstr_seleccionar.s_action = "aceptar" THEN
		sle_codigo_desde.text = lstr_seleccionar.param1[1]
	END IF

end event

type rb_1 from radiobutton within w_aud709_saldos_cta_cte
integer x = 91
integer y = 156
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

event clicked;is_opcion = '1'

if rb_1.checked = true then

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

type rb_2 from radiobutton within w_aud709_saldos_cta_cte
integer x = 91
integer y = 228
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

event clicked;is_opcion = '2'

if rb_2.checked = true then

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

type rb_3 from radiobutton within w_aud709_saldos_cta_cte
integer x = 91
integer y = 300
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

event clicked;is_opcion = '3'

if rb_3.checked = true then

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

type cb_3 from commandbutton within w_aud709_saldos_cta_cte
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

event clicked;/*
// Abre ventana de ayuda 

Sg_parametros sl_param

sl_param.dw1 = "d_cntbl_proveedor_tbl"
sl_param.titulo = "Seleccionar Búsqueda"
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2

OpenWithParm( w_search, sl_param)		
sl_param = MESSAGE.POWEROBJECTPARM
IF sl_param.titulo <> 'n' THEN
	sle_codigo_hasta.text = sl_param.field_ret[1]
END IF
*/

str_seleccionar lstr_seleccionar

lstr_seleccionar.s_seleccion = 'S'
lstr_seleccionar.s_sql = 'SELECT PROVEEDOR.PROVEEDOR AS CODIGO, '&
										 +'PROVEEDOR.NOM_PROVEEDOR AS NOMBRE '&
										 +'FROM PROVEEDOR '
										  
OpenWithParm(w_seleccionar,lstr_seleccionar)
				
IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
	IF lstr_seleccionar.s_action = "aceptar" THEN
		sle_codigo_hasta.text = lstr_seleccionar.param1[1]
	END IF

end event

type st_1 from statictext within w_aud709_saldos_cta_cte
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

type st_2 from statictext within w_aud709_saldos_cta_cte
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

type sle_cuenta_desde from singlelineedit within w_aud709_saldos_cta_cte
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

type sle_cuenta_hasta from singlelineedit within w_aud709_saldos_cta_cte
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

type cb_4 from commandbutton within w_aud709_saldos_cta_cte
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

event clicked;
// Abre ventana de ayuda 
/*
Sg_parametros sl_param

sl_param.dw1 = "d_cntbl_cuentas_tbl"
sl_param.titulo = "Seleccionar Búsqueda"
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2

OpenWithParm( w_search, sl_param)		
sl_param = MESSAGE.POWEROBJECTPARM
IF sl_param.titulo <> 'n' THEN
	sle_cuenta_desde.text = sl_param.field_ret[1]
END IF
*/

str_seleccionar lstr_seleccionar
			
lstr_seleccionar.s_seleccion = 'S'
lstr_seleccionar.s_sql = 'SELECT CNTBL_CNTA.CNTA_CTBL AS CUENTA_CONTBLE, '&
										 +'CNTBL_CNTA.DESC_CNTA AS DESCRIPCION, '&
										 +'CNTBL_CNTA.FLAG_ESTADO AS ESTADO '&
										 +'FROM CNTBL_CNTA ' &
										 +'WHERE CNTBL_CNTA.NIV_CNTA = 4 '
										  
OpenWithParm(w_seleccionar,lstr_seleccionar)
				
IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
	IF lstr_seleccionar.s_action = "aceptar" THEN
		sle_cuenta_desde.text = lstr_seleccionar.param1[1]
	END IF

end event

type cb_5 from commandbutton within w_aud709_saldos_cta_cte
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
/*
Sg_parametros sl_param

sl_param.dw1 = "d_cntbl_cuentas_tbl"
sl_param.titulo = "Seleccionar Búsqueda"
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2

OpenWithParm( w_search, sl_param)		
sl_param = MESSAGE.POWEROBJECTPARM
IF sl_param.titulo <> 'n' THEN
	sle_cuenta_hasta.text = sl_param.field_ret[1]
END IF
*/

str_seleccionar lstr_seleccionar
			
lstr_seleccionar.s_seleccion = 'S'
lstr_seleccionar.s_sql = 'SELECT CNTBL_CNTA.CNTA_CTBL AS CUENTA_CONTBLE, '&
										 +'CNTBL_CNTA.DESC_CNTA AS DESCRIPCION, '&
										 +'CNTBL_CNTA.FLAG_ESTADO AS ESTADO '&
										 +'FROM CNTBL_CNTA ' &
										 +'WHERE CNTBL_CNTA.NIV_CNTA = 4 '
										  
OpenWithParm(w_seleccionar,lstr_seleccionar)
				
IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
	IF lstr_seleccionar.s_action = "aceptar" THEN
		sle_cuenta_hasta.text = lstr_seleccionar.param1[1]
	END IF

end event

type st_3 from statictext within w_aud709_saldos_cta_cte
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

type st_4 from statictext within w_aud709_saldos_cta_cte
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

type st_20 from statictext within w_aud709_saldos_cta_cte
integer x = 1321
integer y = 328
integer width = 137
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
boolean focusrectangle = false
end type

type st_21 from statictext within w_aud709_saldos_cta_cte
integer x = 896
integer y = 328
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

type em_ano from editmask within w_aud709_saldos_cta_cte
integer x = 1051
integer y = 316
integer width = 233
integer height = 72
integer taborder = 90
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

type em_mes from editmask within w_aud709_saldos_cta_cte
integer x = 1467
integer y = 316
integer width = 142
integer height = 72
integer taborder = 100
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
string mask = "##"
end type

type uo_1 from u_ingreso_fecha within w_aud709_saldos_cta_cte
event destroy ( )
integer x = 2427
integer y = 320
integer taborder = 120
boolean bringtotop = true
end type

on uo_1.destroy
call u_ingreso_fecha::destroy
end on

event constructor;call super::constructor;string ls_inicio
date ld_fec_proceso 
of_set_label('Al')

If len(string(ld_fec_proceso))=0 or ld_fec_proceso= Date('01/01/1900') Then 
	ld_fec_proceso = today()
End if 	

of_set_fecha(ld_fec_proceso)
of_set_rango_inicio(date('01/01/1900'))
of_set_rango_fin(date('31/12/9999'))

end event

type ddlb_1 from dropdownlistbox within w_aud709_saldos_cta_cte
integer x = 1888
integer y = 316
integer width = 265
integer height = 480
integer taborder = 110
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
string item[] = {"000","030","060","090","180","360"}
borderstyle borderstyle = stylelowered!
end type

type gb_2 from groupbox within w_aud709_saldos_cta_cte
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
end type

type gb_3 from groupbox within w_aud709_saldos_cta_cte
integer x = 37
integer y = 88
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
end type

type gb_1 from groupbox within w_aud709_saldos_cta_cte
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
end type

type gb_22 from groupbox within w_aud709_saldos_cta_cte
integer x = 859
integer y = 248
integer width = 832
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
end type

type gb_4 from groupbox within w_aud709_saldos_cta_cte
integer x = 2368
integer y = 244
integer width = 727
integer height = 200
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = " Ingrese Fecha "
end type

type gb_5 from groupbox within w_aud709_saldos_cta_cte
integer x = 1765
integer y = 244
integer width = 517
integer height = 200
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = " Mayor en Días a "
end type

