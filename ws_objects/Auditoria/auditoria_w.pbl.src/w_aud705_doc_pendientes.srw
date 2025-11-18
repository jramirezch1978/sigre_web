$PBExportHeader$w_aud705_doc_pendientes.srw
forward
global type w_aud705_doc_pendientes from w_report_smpl
end type
type cb_6 from commandbutton within w_aud705_doc_pendientes
end type
type uo_1 from u_ingreso_fecha within w_aud705_doc_pendientes
end type
type ddlb_1 from dropdownlistbox within w_aud705_doc_pendientes
end type
type rb_1 from radiobutton within w_aud705_doc_pendientes
end type
type rb_2 from radiobutton within w_aud705_doc_pendientes
end type
type rb_3 from radiobutton within w_aud705_doc_pendientes
end type
type cb_2 from commandbutton within w_aud705_doc_pendientes
end type
type cb_3 from commandbutton within w_aud705_doc_pendientes
end type
type cb_4 from commandbutton within w_aud705_doc_pendientes
end type
type cb_5 from commandbutton within w_aud705_doc_pendientes
end type
type sle_codigo_desde from singlelineedit within w_aud705_doc_pendientes
end type
type sle_codigo_hasta from singlelineedit within w_aud705_doc_pendientes
end type
type sle_cuenta_desde from singlelineedit within w_aud705_doc_pendientes
end type
type sle_cuenta_hasta from singlelineedit within w_aud705_doc_pendientes
end type
type st_1 from statictext within w_aud705_doc_pendientes
end type
type st_2 from statictext within w_aud705_doc_pendientes
end type
type st_3 from statictext within w_aud705_doc_pendientes
end type
type st_4 from statictext within w_aud705_doc_pendientes
end type
type ddlb_2 from dropdownlistbox within w_aud705_doc_pendientes
end type
type gb_1 from groupbox within w_aud705_doc_pendientes
end type
type gb_2 from groupbox within w_aud705_doc_pendientes
end type
type gb_3 from groupbox within w_aud705_doc_pendientes
end type
type gb_4 from groupbox within w_aud705_doc_pendientes
end type
type gb_5 from groupbox within w_aud705_doc_pendientes
end type
type gb_6 from groupbox within w_aud705_doc_pendientes
end type
end forward

global type w_aud705_doc_pendientes from w_report_smpl
integer width = 3616
integer height = 1592
string title = "Documentos Pendientes de Cobranza por Antiguedad(AUD705)"
string menuname = "m_reporte"
long backcolor = 12632256
cb_6 cb_6
uo_1 uo_1
ddlb_1 ddlb_1
rb_1 rb_1
rb_2 rb_2
rb_3 rb_3
cb_2 cb_2
cb_3 cb_3
cb_4 cb_4
cb_5 cb_5
sle_codigo_desde sle_codigo_desde
sle_codigo_hasta sle_codigo_hasta
sle_cuenta_desde sle_cuenta_desde
sle_cuenta_hasta sle_cuenta_hasta
st_1 st_1
st_2 st_2
st_3 st_3
st_4 st_4
ddlb_2 ddlb_2
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
gb_4 gb_4
gb_5 gb_5
gb_6 gb_6
end type
global w_aud705_doc_pendientes w_aud705_doc_pendientes

on w_aud705_doc_pendientes.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.cb_6=create cb_6
this.uo_1=create uo_1
this.ddlb_1=create ddlb_1
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rb_3=create rb_3
this.cb_2=create cb_2
this.cb_3=create cb_3
this.cb_4=create cb_4
this.cb_5=create cb_5
this.sle_codigo_desde=create sle_codigo_desde
this.sle_codigo_hasta=create sle_codigo_hasta
this.sle_cuenta_desde=create sle_cuenta_desde
this.sle_cuenta_hasta=create sle_cuenta_hasta
this.st_1=create st_1
this.st_2=create st_2
this.st_3=create st_3
this.st_4=create st_4
this.ddlb_2=create ddlb_2
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
this.gb_4=create gb_4
this.gb_5=create gb_5
this.gb_6=create gb_6
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_6
this.Control[iCurrent+2]=this.uo_1
this.Control[iCurrent+3]=this.ddlb_1
this.Control[iCurrent+4]=this.rb_1
this.Control[iCurrent+5]=this.rb_2
this.Control[iCurrent+6]=this.rb_3
this.Control[iCurrent+7]=this.cb_2
this.Control[iCurrent+8]=this.cb_3
this.Control[iCurrent+9]=this.cb_4
this.Control[iCurrent+10]=this.cb_5
this.Control[iCurrent+11]=this.sle_codigo_desde
this.Control[iCurrent+12]=this.sle_codigo_hasta
this.Control[iCurrent+13]=this.sle_cuenta_desde
this.Control[iCurrent+14]=this.sle_cuenta_hasta
this.Control[iCurrent+15]=this.st_1
this.Control[iCurrent+16]=this.st_2
this.Control[iCurrent+17]=this.st_3
this.Control[iCurrent+18]=this.st_4
this.Control[iCurrent+19]=this.ddlb_2
this.Control[iCurrent+20]=this.gb_1
this.Control[iCurrent+21]=this.gb_2
this.Control[iCurrent+22]=this.gb_3
this.Control[iCurrent+23]=this.gb_4
this.Control[iCurrent+24]=this.gb_5
this.Control[iCurrent+25]=this.gb_6
end on

on w_aud705_doc_pendientes.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_6)
destroy(this.uo_1)
destroy(this.ddlb_1)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_3)
destroy(this.cb_2)
destroy(this.cb_3)
destroy(this.cb_4)
destroy(this.cb_5)
destroy(this.sle_codigo_desde)
destroy(this.sle_codigo_hasta)
destroy(this.sle_cuenta_desde)
destroy(this.sle_cuenta_hasta)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.ddlb_2)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_3)
destroy(this.gb_4)
destroy(this.gb_5)
destroy(this.gb_6)
end on

event ue_retrieve();call super::ue_retrieve;string  ls_codigo_desde, ls_codigo_hasta
string  ls_cuenta_desde, ls_cuenta_hasta

ls_codigo_desde = String(sle_codigo_desde.text)
ls_codigo_hasta = String(sle_codigo_hasta.text)
ls_cuenta_desde = String(sle_cuenta_desde.text)
ls_cuenta_hasta = String(sle_cuenta_hasta.text)


integer ln_nro_dias
ln_nro_dias = integer(upper(ddlb_1.Text))

date ld_fec_hasta
ld_fec_hasta = uo_1.of_get_fecha()

string ls_moneda
ls_moneda = string(upper(ddlb_2.text))

DECLARE pb_usp_aud_rpt_doc_pendientes PROCEDURE FOR USP_AUD_RPT_DOC_PENDIENTES
		  ( :ls_codigo_desde, :ls_codigo_hasta, :ls_cuenta_desde,
		  	 :ls_cuenta_hasta, :ln_nro_dias, :ld_fec_hasta, :ls_moneda ) ;
Execute pb_usp_aud_rpt_doc_pendientes ;

idw_1.Retrieve()

dw_report.object.t_nombre.text = gs_empresa
dw_report.object.t_user.text = gs_user
dw_report.object.p_logo.filename = gs_logo

end event

event ue_open_pre();call super::ue_open_pre;gb_4.enabled = false
st_1.enabled = false
sle_codigo_desde.enabled = false
cb_2.enabled = false
st_2.enabled = false
sle_codigo_hasta.enabled = false
cb_3.enabled = false

gb_5.enabled = false
st_3.enabled = false
sle_cuenta_desde.enabled = false
cb_4.enabled = false
st_4.enabled = false
sle_cuenta_hasta.enabled = false
cb_5.enabled = false

cb_6.enabled = false

end event

type dw_report from w_report_smpl`dw_report within w_aud705_doc_pendientes
integer x = 14
integer y = 516
integer width = 3543
integer height = 880
integer taborder = 130
string dataobject = "d_rpt_doc_pendientes_tbl"
end type

type cb_6 from commandbutton within w_aud705_doc_pendientes
integer x = 3090
integer y = 348
integer width = 274
integer height = 84
integer taborder = 120
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

type uo_1 from u_ingreso_fecha within w_aud705_doc_pendientes
event destroy ( )
integer x = 1481
integer y = 352
integer taborder = 100
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

type ddlb_1 from dropdownlistbox within w_aud705_doc_pendientes
integer x = 942
integer y = 352
integer width = 265
integer height = 480
integer taborder = 90
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

type rb_1 from radiobutton within w_aud705_doc_pendientes
integer x = 119
integer y = 148
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

	gb_4.enabled = true
	st_1.enabled = true
	sle_codigo_desde.enabled = true
	sle_codigo_desde.text = ' '
	cb_2.enabled = true
	st_2.enabled = true
	sle_codigo_hasta.enabled = true
	sle_codigo_hasta.text = ' '
	cb_3.enabled = true

	gb_5.enabled = true
	st_3.enabled = true
	sle_cuenta_desde.enabled = true
	sle_cuenta_desde.text = ' '
	cb_4.enabled = true
	st_4.enabled = true
	sle_cuenta_hasta.enabled = true
	sle_cuenta_hasta.text = ' '
	cb_5.enabled = true

	cb_6.enabled = true

end if

end event

type rb_2 from radiobutton within w_aud705_doc_pendientes
integer x = 119
integer y = 216
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

	gb_4.enabled = true
	st_1.enabled = true
	sle_codigo_desde.enabled = true
	sle_codigo_desde.text = ' '
	cb_2.enabled = true
	st_2.enabled = true
	sle_codigo_hasta.enabled = true
	sle_codigo_hasta.text = ' '
	cb_3.enabled = true

	gb_5.enabled = false
	st_3.enabled = false
	sle_cuenta_desde.enabled = false
	sle_cuenta_desde.text = ' '
	cb_4.enabled = false
	st_4.enabled = false
	sle_cuenta_hasta.enabled = false
	sle_cuenta_hasta.text = ' '
	cb_5.enabled = false

	cb_6.enabled = true

end if

end event

type rb_3 from radiobutton within w_aud705_doc_pendientes
integer x = 119
integer y = 288
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

	gb_4.enabled = false
	st_1.enabled = false
	sle_codigo_desde.enabled = false
	sle_codigo_desde.text = ' '
	cb_2.enabled = false
	st_2.enabled = false
	sle_codigo_hasta.enabled = false
	sle_codigo_hasta.text = ' '
	cb_3.enabled = false

	gb_5.enabled = true
	st_3.enabled = true
	sle_cuenta_desde.enabled = true
	sle_cuenta_desde.text = ' '
	cb_4.enabled = true
	st_4.enabled = true
	sle_cuenta_hasta.enabled = true
	sle_cuenta_hasta.text = ' '
	cb_5.enabled = true

	cb_6.enabled = true

end if

end event

type cb_2 from commandbutton within w_aud705_doc_pendientes
integer x = 1394
integer y = 120
integer width = 87
integer height = 80
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

Sg_parametros sl_param

sl_param.dw1 = "d_proveedor_tbl"
sl_param.titulo = "Seleccionar Búsqueda"
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2

OpenWithParm( w_search, sl_param)		
sl_param = MESSAGE.POWEROBJECTPARM
IF sl_param.titulo <> 'n' THEN
	sle_codigo_desde.text = sl_param.field_ret[1]
END IF

end event

type cb_3 from commandbutton within w_aud705_doc_pendientes
integer x = 2016
integer y = 120
integer width = 87
integer height = 80
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

Sg_parametros sl_param

sl_param.dw1 = "d_proveedor_tbl"
sl_param.titulo = "Seleccionar Búsqueda"
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2

OpenWithParm( w_search, sl_param)		
sl_param = MESSAGE.POWEROBJECTPARM
IF sl_param.titulo <> 'n' THEN
	sle_codigo_hasta.text = sl_param.field_ret[1]
END IF

end event

type cb_4 from commandbutton within w_aud705_doc_pendientes
integer x = 2784
integer y = 124
integer width = 87
integer height = 80
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

Sg_parametros sl_param

sl_param.dw1 = "d_cuenta_tbl"
sl_param.titulo = "Seleccionar Búsqueda"
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2

OpenWithParm( w_search, sl_param)		
sl_param = MESSAGE.POWEROBJECTPARM
IF sl_param.titulo <> 'n' THEN
	sle_cuenta_desde.text = sl_param.field_ret[1]
END IF

end event

type cb_5 from commandbutton within w_aud705_doc_pendientes
integer x = 3406
integer y = 124
integer width = 87
integer height = 80
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

Sg_parametros sl_param

sl_param.dw1 = "d_cuenta_tbl"
sl_param.titulo = "Seleccionar Búsqueda"
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2

OpenWithParm( w_search, sl_param)		
sl_param = MESSAGE.POWEROBJECTPARM
IF sl_param.titulo <> 'n' THEN
	sle_cuenta_hasta.text = sl_param.field_ret[1]
END IF

end event

type sle_codigo_desde from singlelineedit within w_aud705_doc_pendientes
integer x = 1051
integer y = 120
integer width = 320
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
borderstyle borderstyle = stylelowered!
end type

type sle_codigo_hasta from singlelineedit within w_aud705_doc_pendientes
integer x = 1673
integer y = 120
integer width = 320
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

type sle_cuenta_desde from singlelineedit within w_aud705_doc_pendientes
integer x = 2441
integer y = 124
integer width = 320
integer height = 80
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

type sle_cuenta_hasta from singlelineedit within w_aud705_doc_pendientes
integer x = 3063
integer y = 124
integer width = 320
integer height = 80
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

type st_1 from statictext within w_aud705_doc_pendientes
integer x = 869
integer y = 136
integer width = 178
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Desde"
boolean focusrectangle = false
end type

type st_2 from statictext within w_aud705_doc_pendientes
integer x = 1504
integer y = 136
integer width = 160
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Hasta"
boolean focusrectangle = false
end type

type st_3 from statictext within w_aud705_doc_pendientes
integer x = 2258
integer y = 140
integer width = 178
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Desde"
boolean focusrectangle = false
end type

type st_4 from statictext within w_aud705_doc_pendientes
integer x = 2894
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
long backcolor = 67108864
string text = "Hasta"
boolean focusrectangle = false
end type

type ddlb_2 from dropdownlistbox within w_aud705_doc_pendientes
integer x = 2286
integer y = 344
integer width = 640
integer height = 352
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
string item[] = {"S O L E S","D O L A R E S","SOLES Y DOLARES"}
borderstyle borderstyle = stylelowered!
end type

type gb_1 from groupbox within w_aud705_doc_pendientes
integer x = 1422
integer y = 276
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

type gb_2 from groupbox within w_aud705_doc_pendientes
integer x = 818
integer y = 280
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

type gb_3 from groupbox within w_aud705_doc_pendientes
integer x = 50
integer y = 88
integer width = 718
integer height = 304
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = " Seleccione Opción "
end type

type gb_4 from groupbox within w_aud705_doc_pendientes
integer x = 818
integer y = 56
integer width = 1330
integer height = 184
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 67108864
string text = " Seleccione Código de Relación "
end type

type gb_5 from groupbox within w_aud705_doc_pendientes
integer x = 2208
integer y = 56
integer width = 1330
integer height = 184
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 67108864
string text = " Seleccione Cuenta Contable "
end type

type gb_6 from groupbox within w_aud705_doc_pendientes
integer x = 2208
integer y = 276
integer width = 782
integer height = 200
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = " Moneda "
end type

