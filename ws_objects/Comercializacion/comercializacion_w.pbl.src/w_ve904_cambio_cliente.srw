$PBExportHeader$w_ve904_cambio_cliente.srw
forward
global type w_ve904_cambio_cliente from w_prc
end type
type st_3 from statictext within w_ve904_cambio_cliente
end type
type sle_cliente_new from u_sle_codigo within w_ve904_cambio_cliente
end type
type sle_nro_ov from u_sle_codigo within w_ve904_cambio_cliente
end type
type sle_desc_forma_pago from singlelineedit within w_ve904_cambio_cliente
end type
type cb_1 from commandbutton within w_ve904_cambio_cliente
end type
type sle_desc_cliente_new from singlelineedit within w_ve904_cambio_cliente
end type
type st_4 from statictext within w_ve904_cambio_cliente
end type
type sle_desc_cliente_old from singlelineedit within w_ve904_cambio_cliente
end type
type pb_2 from picturebutton within w_ve904_cambio_cliente
end type
type sle_cliente_old from singlelineedit within w_ve904_cambio_cliente
end type
type st_2 from statictext within w_ve904_cambio_cliente
end type
type sle_desc_boleta from singlelineedit within w_ve904_cambio_cliente
end type
type pb_1 from picturebutton within w_ve904_cambio_cliente
end type
type st_1 from statictext within w_ve904_cambio_cliente
end type
type cb_procesar from commandbutton within w_ve904_cambio_cliente
end type
type gb_1 from groupbox within w_ve904_cambio_cliente
end type
end forward

global type w_ve904_cambio_cliente from w_prc
integer width = 2149
integer height = 1072
string title = "[VE901] Generacion de Facturas de Materiales"
string menuname = "m_consulta"
boolean maxbox = false
boolean resizable = false
st_3 st_3
sle_cliente_new sle_cliente_new
sle_nro_ov sle_nro_ov
sle_desc_forma_pago sle_desc_forma_pago
cb_1 cb_1
sle_desc_cliente_new sle_desc_cliente_new
st_4 st_4
sle_desc_cliente_old sle_desc_cliente_old
pb_2 pb_2
sle_cliente_old sle_cliente_old
st_2 st_2
sle_desc_boleta sle_desc_boleta
pb_1 pb_1
st_1 st_1
cb_procesar cb_procesar
gb_1 gb_1
end type
global w_ve904_cambio_cliente w_ve904_cambio_cliente

type variables
string is_cod_boleta, is_cod_factura
end variables

on w_ve904_cambio_cliente.create
int iCurrent
call super::create
if this.MenuName = "m_consulta" then this.MenuID = create m_consulta
this.st_3=create st_3
this.sle_cliente_new=create sle_cliente_new
this.sle_nro_ov=create sle_nro_ov
this.sle_desc_forma_pago=create sle_desc_forma_pago
this.cb_1=create cb_1
this.sle_desc_cliente_new=create sle_desc_cliente_new
this.st_4=create st_4
this.sle_desc_cliente_old=create sle_desc_cliente_old
this.pb_2=create pb_2
this.sle_cliente_old=create sle_cliente_old
this.st_2=create st_2
this.sle_desc_boleta=create sle_desc_boleta
this.pb_1=create pb_1
this.st_1=create st_1
this.cb_procesar=create cb_procesar
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_3
this.Control[iCurrent+2]=this.sle_cliente_new
this.Control[iCurrent+3]=this.sle_nro_ov
this.Control[iCurrent+4]=this.sle_desc_forma_pago
this.Control[iCurrent+5]=this.cb_1
this.Control[iCurrent+6]=this.sle_desc_cliente_new
this.Control[iCurrent+7]=this.st_4
this.Control[iCurrent+8]=this.sle_desc_cliente_old
this.Control[iCurrent+9]=this.pb_2
this.Control[iCurrent+10]=this.sle_cliente_old
this.Control[iCurrent+11]=this.st_2
this.Control[iCurrent+12]=this.sle_desc_boleta
this.Control[iCurrent+13]=this.pb_1
this.Control[iCurrent+14]=this.st_1
this.Control[iCurrent+15]=this.cb_procesar
this.Control[iCurrent+16]=this.gb_1
end on

on w_ve904_cambio_cliente.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_3)
destroy(this.sle_cliente_new)
destroy(this.sle_nro_ov)
destroy(this.sle_desc_forma_pago)
destroy(this.cb_1)
destroy(this.sle_desc_cliente_new)
destroy(this.st_4)
destroy(this.sle_desc_cliente_old)
destroy(this.pb_2)
destroy(this.sle_cliente_old)
destroy(this.st_2)
destroy(this.sle_desc_boleta)
destroy(this.pb_1)
destroy(this.st_1)
destroy(this.cb_procesar)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;//string ls_desc, ls_cod
//
//select doc_bol_cobrar, doc_fact_cobrar
//  into :is_cod_boleta, :is_cod_factura
//  from finparam
// where reckey = '1';
//
//select oper_vnta_mat into :ls_cod
//  from logparam
// where reckey = '1';
//
//select desc_tipo_mov into :ls_desc
//  from articulo_mov_tipo
// where tipo_mov = :ls_cod;
//
//sle_movimiento.text = ls_cod
//sle_desc_movimiento.text = ls_desc
//
//sle_origen.text = gs_origen
//
//of_position_window(50,50)
end event

type st_3 from statictext within w_ve904_cambio_cliente
integer x = 87
integer y = 824
integer width = 1984
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 8388608
long backcolor = 67108864
string text = "Orden de venta, vale de salida, guía de remisión, facturación, asiento contable, embarque"
boolean focusrectangle = false
end type

type sle_cliente_new from u_sle_codigo within w_ve904_cambio_cliente
integer x = 530
integer y = 376
integer width = 357
integer height = 80
integer taborder = 50
end type

type sle_nro_ov from u_sle_codigo within w_ve904_cambio_cliente
integer x = 530
integer y = 128
integer width = 357
integer height = 80
integer taborder = 30
end type

event constructor;call super::constructor;ii_prefijo = 2
ii_total = 9
ibl_mayuscula = true
end event

event modified;call super::modified;Long ll_count
String ls_nro_ov, ls_cliente, ls_nombre

ls_nro_ov = TRIM(sle_nro_ov.text)

SELECT count(*) INTO :ll_count 
FROM orden_venta WHERE nro_ov = :ls_nro_ov ;

IF ll_count = 0 THEN
	Messagebox('Aviso','Orden de venta no existe')
	Return 1
END IF 

SELECT ov.cliente, p.nom_proveedor 
  INTO :ls_cliente, :ls_nombre 
  FROM orden_venta ov, proveedor p 
 WHERE ov.cliente=p.proveedor and 
       ov.nro_ov = :ls_nro_ov  ;

sle_cliente_old.text = ls_cliente
sle_desc_cliente_old.text = ls_cliente
end event

type sle_desc_forma_pago from singlelineedit within w_ve904_cambio_cliente
integer x = 46
integer y = 524
integer width = 2007
integer height = 80
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean enabled = false
integer limit = 100
end type

type cb_1 from commandbutton within w_ve904_cambio_cliente
integer x = 50
integer y = 656
integer width = 622
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Ver documentos a cambiar"
end type

event clicked;//sg_parametros sgt_parametros
//date ld_fecha
//time lt_hora
//datetime ldt_fecha
//
//ld_fecha = date( mid(em_fecha.text,1,10) )
//lt_hora  = time( mid(em_fecha.text,12,19))
//ldt_fecha = datetime( ld_fecha, lt_hora)
//
//sgt_parametros.date1 = uo_1.of_Get_fecha1()
//sgt_parametros.date2 = uo_1.of_get_fecha2()
//sgt_parametros.string1 = sle_movimiento.text
//sgt_parametros.datetime1 = ldt_fecha
//
//opensheetwithparm(w_ve902_generacion_fact_cobrar_guias, sgt_parametros, parent, 0 , Layered! )
end event

type sle_desc_cliente_new from singlelineedit within w_ve904_cambio_cliente
integer x = 1019
integer y = 372
integer width = 1024
integer height = 80
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean enabled = false
integer limit = 100
end type

type st_4 from statictext within w_ve904_cambio_cliente
integer x = 55
integer y = 388
integer width = 439
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Nuevo cliente  :"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_desc_cliente_old from singlelineedit within w_ve904_cambio_cliente
integer x = 1019
integer y = 248
integer width = 1024
integer height = 80
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long backcolor = 16777215
boolean enabled = false
end type

type pb_2 from picturebutton within w_ve904_cambio_cliente
integer x = 896
integer y = 368
integer width = 101
integer height = 88
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string picturename = "EditDataFreeform!"
alignment htextalign = left!
string powertiptext = "Busqueda de Series para Facturas"
end type

event clicked;//sg_parametros   sl_param
//
//sl_param.dw1 = "d_lista_tipo_doc_usuario"
//sl_param.titulo = "Tipo de Documento"
//sl_param.field_ret_i[1] = 1
//sl_param.field_ret_i[2] = 3
//sl_param.tipo = '2S'
//sl_param.string1 = gs_user
//sl_param.string2 = is_cod_factura
//
//OpenWithParm( w_lista, sl_param)		
//				
//sl_param = MESSAGE.POWEROBJECTPARM
//				
//if sl_param.titulo <> 'n' then	
//	sle_factura.text = sl_param.field_ret[1]
//	sle_desc_factura.text = sl_param.field_ret[2]
//END IF
end event

type sle_cliente_old from singlelineedit within w_ve904_cambio_cliente
integer x = 530
integer y = 248
integer width = 357
integer height = 80
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long backcolor = 16777215
boolean enabled = false
boolean righttoleft = true
end type

type st_2 from statictext within w_ve904_cambio_cliente
integer x = 55
integer y = 260
integer width = 439
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Cliente actual :"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_desc_boleta from singlelineedit within w_ve904_cambio_cliente
integer x = 1019
integer y = 128
integer width = 1024
integer height = 80
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long backcolor = 16777215
boolean enabled = false
end type

type pb_1 from picturebutton within w_ve904_cambio_cliente
integer x = 896
integer y = 124
integer width = 101
integer height = 88
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
boolean originalsize = true
string picturename = "EditDataFreeform!"
alignment htextalign = left!
string powertiptext = "Busqueda de Series para Boletas"
end type

event clicked;//sg_parametros   sl_param
//
//sl_param.dw1 = "d_lista_tipo_doc_usuario"
//sl_param.titulo = "Tipo de Documento"
//sl_param.field_ret_i[1] = 1
//sl_param.field_ret_i[2] = 3
//sl_param.tipo = '2S'
//sl_param.string1 = gs_user
//sl_param.string2 = is_cod_boleta
//
//OpenWithParm( w_lista, sl_param)		
//				
//sl_param = MESSAGE.POWEROBJECTPARM
//				
//if sl_param.titulo <> 'n' then	
//	sle_boleta.text = sl_param.field_ret[1]
//	sle_desc_boleta.text = sl_param.field_ret[2]
//END IF
end event

type st_1 from statictext within w_ve904_cambio_cliente
integer x = 55
integer y = 140
integer width = 439
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Orden de venta :"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_procesar from commandbutton within w_ve904_cambio_cliente
string tag = "Ejecutar Proceso"
integer x = 1527
integer y = 656
integer width = 517
integer height = 100
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "&Procesar"
end type

event clicked;// Cambiar orden de venta
// Cambiar vales de salida
// Cambiar guias de remision
// Cambiar facturacion
// Cambiar asiento contable

end event

type gb_1 from groupbox within w_ve904_cambio_cliente
integer x = 50
integer y = 52
integer width = 2016
integer height = 452
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 8388608
long backcolor = 67108864
string text = "Documento"
borderstyle borderstyle = stylebox!
end type

