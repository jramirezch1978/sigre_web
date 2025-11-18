$PBExportHeader$w_datos_comunes.srw
forward
global type w_datos_comunes from w_abc
end type
type st_9 from statictext within w_datos_comunes
end type
type em_precio_unidad from editmask within w_datos_comunes
end type
type em_porc_prec_min from editmask within w_datos_comunes
end type
type st_8 from statictext within w_datos_comunes
end type
type st_7 from statictext within w_datos_comunes
end type
type em_porc_oferta from editmask within w_datos_comunes
end type
type st_6 from statictext within w_datos_comunes
end type
type st_5 from statictext within w_datos_comunes
end type
type em_dscto1 from editmask within w_datos_comunes
end type
type em_dscto2 from editmask within w_datos_comunes
end type
type sle_moneda from singlelineedit within w_datos_comunes
end type
type st_4 from statictext within w_datos_comunes
end type
type cb_aceptar from commandbutton within w_datos_comunes
end type
type em_porc_min from editmask within w_datos_comunes
end type
type em_porc_may from editmask within w_datos_comunes
end type
type em_tipo_cambio from editmask within w_datos_comunes
end type
type st_3 from statictext within w_datos_comunes
end type
type st_2 from statictext within w_datos_comunes
end type
type st_1 from statictext within w_datos_comunes
end type
type cb_cerrar from commandbutton within w_datos_comunes
end type
end forward

global type w_datos_comunes from w_abc
integer width = 1838
integer height = 1320
string title = "Datos Genericos"
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
event ue_close ( )
event ue_aceptar ( )
st_9 st_9
em_precio_unidad em_precio_unidad
em_porc_prec_min em_porc_prec_min
st_8 st_8
st_7 st_7
em_porc_oferta em_porc_oferta
st_6 st_6
st_5 st_5
em_dscto1 em_dscto1
em_dscto2 em_dscto2
sle_moneda sle_moneda
st_4 st_4
cb_aceptar cb_aceptar
em_porc_min em_porc_min
em_porc_may em_porc_may
em_tipo_cambio em_tipo_cambio
st_3 st_3
st_2 st_2
st_1 st_1
cb_cerrar cb_cerrar
end type
global w_datos_comunes w_datos_comunes

event ue_close();str_parametros	lstr_param

lstr_param.b_return = false

CloseWithreturn(this, lstr_param)
end event

event ue_aceptar;str_parametros	lstr_param

lstr_param.string1 = sle_moneda.text
em_tipo_cambio.getData( lstr_param.tipo_cambio )
em_porc_may.getData( lstr_param.porc_mayorista )
em_porc_min.getData( lstr_param.porc_minorista )
em_porc_oferta.getData( lstr_param.porc_oferta )
em_porc_prec_min.getData( lstr_param.porc_prec_min )

//Descuentos
em_dscto1.getData( lstr_param.dec1 )
em_dscto2.getData( lstr_param.dec2 )

//Precios
em_precio_unidad.getData( lstr_param.precio_unidad )

if lstr_param.precio_unidad <> 0 and lstr_param.porc_minorista <> 0 then
	MessageBox('Error', 'Solo esta permitido ingresar el porcentaje minorista o el precio minorista, no ambos, por favor corrija', StopSign!)
	return
end if

if MessageBox('Aviso', '¿Desea aplicar esta configuración para todos los registros?', Information!, Yesno!, 2) = 2 then return

lstr_param.b_return = true

CloseWithreturn(this, lstr_param)
end event

on w_datos_comunes.create
int iCurrent
call super::create
this.st_9=create st_9
this.em_precio_unidad=create em_precio_unidad
this.em_porc_prec_min=create em_porc_prec_min
this.st_8=create st_8
this.st_7=create st_7
this.em_porc_oferta=create em_porc_oferta
this.st_6=create st_6
this.st_5=create st_5
this.em_dscto1=create em_dscto1
this.em_dscto2=create em_dscto2
this.sle_moneda=create sle_moneda
this.st_4=create st_4
this.cb_aceptar=create cb_aceptar
this.em_porc_min=create em_porc_min
this.em_porc_may=create em_porc_may
this.em_tipo_cambio=create em_tipo_cambio
this.st_3=create st_3
this.st_2=create st_2
this.st_1=create st_1
this.cb_cerrar=create cb_cerrar
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_9
this.Control[iCurrent+2]=this.em_precio_unidad
this.Control[iCurrent+3]=this.em_porc_prec_min
this.Control[iCurrent+4]=this.st_8
this.Control[iCurrent+5]=this.st_7
this.Control[iCurrent+6]=this.em_porc_oferta
this.Control[iCurrent+7]=this.st_6
this.Control[iCurrent+8]=this.st_5
this.Control[iCurrent+9]=this.em_dscto1
this.Control[iCurrent+10]=this.em_dscto2
this.Control[iCurrent+11]=this.sle_moneda
this.Control[iCurrent+12]=this.st_4
this.Control[iCurrent+13]=this.cb_aceptar
this.Control[iCurrent+14]=this.em_porc_min
this.Control[iCurrent+15]=this.em_porc_may
this.Control[iCurrent+16]=this.em_tipo_cambio
this.Control[iCurrent+17]=this.st_3
this.Control[iCurrent+18]=this.st_2
this.Control[iCurrent+19]=this.st_1
this.Control[iCurrent+20]=this.cb_cerrar
end on

on w_datos_comunes.destroy
call super::destroy
destroy(this.st_9)
destroy(this.em_precio_unidad)
destroy(this.em_porc_prec_min)
destroy(this.st_8)
destroy(this.st_7)
destroy(this.em_porc_oferta)
destroy(this.st_6)
destroy(this.st_5)
destroy(this.em_dscto1)
destroy(this.em_dscto2)
destroy(this.sle_moneda)
destroy(this.st_4)
destroy(this.cb_aceptar)
destroy(this.em_porc_min)
destroy(this.em_porc_may)
destroy(this.em_tipo_cambio)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.cb_cerrar)
end on

type st_9 from statictext within w_datos_comunes
integer x = 96
integer y = 1020
integer width = 695
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Precio Minorista :"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_precio_unidad from editmask within w_datos_comunes
integer x = 823
integer y = 996
integer width = 402
integer height = 112
integer taborder = 40
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "###,##0.0000"
boolean spin = true
double increment = 1
end type

type em_porc_prec_min from editmask within w_datos_comunes
integer x = 823
integer y = 636
integer width = 402
integer height = 112
integer taborder = 40
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "###,##0.0000"
boolean spin = true
double increment = 1
end type

type st_8 from statictext within w_datos_comunes
integer x = 91
integer y = 660
integer width = 695
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Porc. Precio Minimo :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_7 from statictext within w_datos_comunes
integer x = 91
integer y = 540
integer width = 695
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Porcentaje Oferta :"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_porc_oferta from editmask within w_datos_comunes
integer x = 823
integer y = 516
integer width = 402
integer height = 112
integer taborder = 40
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "###,##0.0000"
boolean spin = true
double increment = 1
end type

type st_6 from statictext within w_datos_comunes
integer x = 91
integer y = 780
integer width = 695
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Primer Descuento :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_5 from statictext within w_datos_comunes
integer x = 91
integer y = 900
integer width = 695
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Segundo Descuento :"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_dscto1 from editmask within w_datos_comunes
integer x = 823
integer y = 756
integer width = 402
integer height = 112
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "###,##0.0000"
boolean spin = true
double increment = 1
end type

type em_dscto2 from editmask within w_datos_comunes
integer x = 823
integer y = 876
integer width = 402
integer height = 112
integer taborder = 40
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "###,##0.0000"
boolean spin = true
double increment = 1
end type

type sle_moneda from singlelineedit within w_datos_comunes
event ue_dobleclick pbm_lbuttondblclk
integer x = 823
integer y = 36
integer width = 402
integer height = 112
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "C:\SIGRE\resources\cur\taladro.cur"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event ue_dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "select m.cod_moneda as codigo_moneda, " &
		 + "m.descripcion as descripcion_moneda " &
		 + "from moneda m " &
		 + "where m.flag_estado = '1'"
		 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

if ls_codigo <> '' then
	this.text	= ls_codigo
end if





end event

type st_4 from statictext within w_datos_comunes
integer x = 91
integer y = 60
integer width = 695
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Moneda :"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_aceptar from commandbutton within w_datos_comunes
integer x = 1349
integer y = 44
integer width = 402
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aceptar"
end type

event clicked;parent.event ue_aceptar()
end event

type em_porc_min from editmask within w_datos_comunes
integer x = 823
integer y = 396
integer width = 402
integer height = 112
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "###,##0.0000"
boolean spin = true
double increment = 1
end type

type em_porc_may from editmask within w_datos_comunes
integer x = 823
integer y = 276
integer width = 402
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "###,##0.0000"
boolean spin = true
double increment = 1
end type

type em_tipo_cambio from editmask within w_datos_comunes
integer x = 823
integer y = 156
integer width = 402
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "###,##0.0000"
boolean spin = true
double increment = 1
end type

type st_3 from statictext within w_datos_comunes
integer x = 91
integer y = 420
integer width = 695
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Porcentaje Minorista :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_2 from statictext within w_datos_comunes
integer x = 91
integer y = 300
integer width = 695
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Porcentaje Mayorista :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_1 from statictext within w_datos_comunes
integer x = 91
integer y = 180
integer width = 695
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Tipo de cambio :"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_cerrar from commandbutton within w_datos_comunes
integer x = 1349
integer y = 180
integer width = 402
integer height = 112
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cerrar"
end type

event clicked;parent.event ue_close()
end event

