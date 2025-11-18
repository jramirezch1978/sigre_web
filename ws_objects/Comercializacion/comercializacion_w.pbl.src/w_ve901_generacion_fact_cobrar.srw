$PBExportHeader$w_ve901_generacion_fact_cobrar.srw
forward
global type w_ve901_generacion_fact_cobrar from w_prc
end type
type sle_desc_forma_pago from singlelineedit within w_ve901_generacion_fact_cobrar
end type
type pb_4 from picturebutton within w_ve901_generacion_fact_cobrar
end type
type sle_forma_pago from singlelineedit within w_ve901_generacion_fact_cobrar
end type
type st_6 from statictext within w_ve901_generacion_fact_cobrar
end type
type cb_1 from commandbutton within w_ve901_generacion_fact_cobrar
end type
type uo_1 from u_ingreso_rango_fechas within w_ve901_generacion_fact_cobrar
end type
type pb_3 from picturebutton within w_ve901_generacion_fact_cobrar
end type
type st_5 from statictext within w_ve901_generacion_fact_cobrar
end type
type sle_origen from singlelineedit within w_ve901_generacion_fact_cobrar
end type
type sle_desc_movimiento from singlelineedit within w_ve901_generacion_fact_cobrar
end type
type sle_movimiento from singlelineedit within w_ve901_generacion_fact_cobrar
end type
type st_4 from statictext within w_ve901_generacion_fact_cobrar
end type
type em_fecha from n_ingreso_fecha within w_ve901_generacion_fact_cobrar
end type
type st_3 from statictext within w_ve901_generacion_fact_cobrar
end type
type sle_desc_factura from singlelineedit within w_ve901_generacion_fact_cobrar
end type
type pb_2 from picturebutton within w_ve901_generacion_fact_cobrar
end type
type sle_factura from singlelineedit within w_ve901_generacion_fact_cobrar
end type
type st_2 from statictext within w_ve901_generacion_fact_cobrar
end type
type sle_desc_boleta from singlelineedit within w_ve901_generacion_fact_cobrar
end type
type pb_1 from picturebutton within w_ve901_generacion_fact_cobrar
end type
type sle_boleta from singlelineedit within w_ve901_generacion_fact_cobrar
end type
type st_1 from statictext within w_ve901_generacion_fact_cobrar
end type
type cb_procesar from commandbutton within w_ve901_generacion_fact_cobrar
end type
type gb_1 from groupbox within w_ve901_generacion_fact_cobrar
end type
type gb_2 from groupbox within w_ve901_generacion_fact_cobrar
end type
end forward

global type w_ve901_generacion_fact_cobrar from w_prc
integer width = 2130
integer height = 1336
string title = "[VE901] Generacion de Facturas de Materiales"
string menuname = "m_consulta"
boolean maxbox = false
boolean resizable = false
sle_desc_forma_pago sle_desc_forma_pago
pb_4 pb_4
sle_forma_pago sle_forma_pago
st_6 st_6
cb_1 cb_1
uo_1 uo_1
pb_3 pb_3
st_5 st_5
sle_origen sle_origen
sle_desc_movimiento sle_desc_movimiento
sle_movimiento sle_movimiento
st_4 st_4
em_fecha em_fecha
st_3 st_3
sle_desc_factura sle_desc_factura
pb_2 pb_2
sle_factura sle_factura
st_2 st_2
sle_desc_boleta sle_desc_boleta
pb_1 pb_1
sle_boleta sle_boleta
st_1 st_1
cb_procesar cb_procesar
gb_1 gb_1
gb_2 gb_2
end type
global w_ve901_generacion_fact_cobrar w_ve901_generacion_fact_cobrar

type variables
string is_cod_boleta, is_cod_factura
end variables

on w_ve901_generacion_fact_cobrar.create
int iCurrent
call super::create
if this.MenuName = "m_consulta" then this.MenuID = create m_consulta
this.sle_desc_forma_pago=create sle_desc_forma_pago
this.pb_4=create pb_4
this.sle_forma_pago=create sle_forma_pago
this.st_6=create st_6
this.cb_1=create cb_1
this.uo_1=create uo_1
this.pb_3=create pb_3
this.st_5=create st_5
this.sle_origen=create sle_origen
this.sle_desc_movimiento=create sle_desc_movimiento
this.sle_movimiento=create sle_movimiento
this.st_4=create st_4
this.em_fecha=create em_fecha
this.st_3=create st_3
this.sle_desc_factura=create sle_desc_factura
this.pb_2=create pb_2
this.sle_factura=create sle_factura
this.st_2=create st_2
this.sle_desc_boleta=create sle_desc_boleta
this.pb_1=create pb_1
this.sle_boleta=create sle_boleta
this.st_1=create st_1
this.cb_procesar=create cb_procesar
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_desc_forma_pago
this.Control[iCurrent+2]=this.pb_4
this.Control[iCurrent+3]=this.sle_forma_pago
this.Control[iCurrent+4]=this.st_6
this.Control[iCurrent+5]=this.cb_1
this.Control[iCurrent+6]=this.uo_1
this.Control[iCurrent+7]=this.pb_3
this.Control[iCurrent+8]=this.st_5
this.Control[iCurrent+9]=this.sle_origen
this.Control[iCurrent+10]=this.sle_desc_movimiento
this.Control[iCurrent+11]=this.sle_movimiento
this.Control[iCurrent+12]=this.st_4
this.Control[iCurrent+13]=this.em_fecha
this.Control[iCurrent+14]=this.st_3
this.Control[iCurrent+15]=this.sle_desc_factura
this.Control[iCurrent+16]=this.pb_2
this.Control[iCurrent+17]=this.sle_factura
this.Control[iCurrent+18]=this.st_2
this.Control[iCurrent+19]=this.sle_desc_boleta
this.Control[iCurrent+20]=this.pb_1
this.Control[iCurrent+21]=this.sle_boleta
this.Control[iCurrent+22]=this.st_1
this.Control[iCurrent+23]=this.cb_procesar
this.Control[iCurrent+24]=this.gb_1
this.Control[iCurrent+25]=this.gb_2
end on

on w_ve901_generacion_fact_cobrar.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_desc_forma_pago)
destroy(this.pb_4)
destroy(this.sle_forma_pago)
destroy(this.st_6)
destroy(this.cb_1)
destroy(this.uo_1)
destroy(this.pb_3)
destroy(this.st_5)
destroy(this.sle_origen)
destroy(this.sle_desc_movimiento)
destroy(this.sle_movimiento)
destroy(this.st_4)
destroy(this.em_fecha)
destroy(this.st_3)
destroy(this.sle_desc_factura)
destroy(this.pb_2)
destroy(this.sle_factura)
destroy(this.st_2)
destroy(this.sle_desc_boleta)
destroy(this.pb_1)
destroy(this.sle_boleta)
destroy(this.st_1)
destroy(this.cb_procesar)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event ue_open_pre;call super::ue_open_pre;string ls_desc, ls_cod

select doc_bol_cobrar, doc_fact_cobrar
  into :is_cod_boleta, :is_cod_factura
  from finparam
 where reckey = '1';

select oper_vnta_mat into :ls_cod
  from logparam
 where reckey = '1';

select desc_tipo_mov into :ls_desc
  from articulo_mov_tipo
 where tipo_mov = :ls_cod;

sle_movimiento.text = ls_cod
sle_desc_movimiento.text = ls_desc

sle_origen.text = gs_origen

of_position_window(50,50)
end event

type sle_desc_forma_pago from singlelineedit within w_ve901_generacion_fact_cobrar
integer x = 1106
integer y = 492
integer width = 896
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

type pb_4 from picturebutton within w_ve901_generacion_fact_cobrar
integer x = 992
integer y = 484
integer width = 101
integer height = 88
integer taborder = 60
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

event clicked;str_seleccionar lstr_seleccionar

lstr_seleccionar.s_seleccion = 'S'
lstr_seleccionar.s_sql = " SELECT FORMA_PAGO.FORMA_PAGO as FORMA_PAGO, " &
								+" 		FORMA_PAGO.DESC_FORMA_PAGO AS DESC_FORMA_PAGO, " &
								+"			FORMA_PAGO.DIAS_VENCIMIENTO AS VENCIMIENTO " & 
								+"   FROM FORMA_PAGO  " &
								+"  WHERE FLAG_ESTADO = '1' " &
								+" ORDER BY FORMA_PAGO.FORMA_PAGO ASC "

OpenWithParm(w_seleccionar,lstr_seleccionar)

IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm

IF lstr_seleccionar.s_action = "aceptar" THEN
	sle_forma_pago.text = string(lstr_seleccionar.param1[1])
	sle_desc_forma_pago.text = string(lstr_seleccionar.param2[1])
END IF
end event

type sle_forma_pago from singlelineedit within w_ve901_generacion_fact_cobrar
integer x = 731
integer y = 492
integer width = 251
integer height = 80
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean enabled = false
textcase textcase = upper!
integer limit = 6
end type

type st_6 from statictext within w_ve901_generacion_fact_cobrar
integer x = 55
integer y = 508
integer width = 663
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Forma de Pago :"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_ve901_generacion_fact_cobrar
integer x = 1536
integer y = 848
integer width = 517
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "&Ver Guias a Facturar"
end type

event clicked;str_parametros sgt_parametros
date ld_fecha
time lt_hora
datetime ldt_fecha

ld_fecha = date( mid(em_fecha.text,1,10) )
lt_hora  = time( mid(em_fecha.text,12,19))
ldt_fecha = datetime( ld_fecha, lt_hora)

sgt_parametros.date1 = uo_1.of_Get_fecha1()
sgt_parametros.date2 = uo_1.of_get_fecha2()
sgt_parametros.string1 = sle_movimiento.text
sgt_parametros.datetime1 = ldt_fecha

opensheetwithparm(w_ve902_generacion_fact_cobrar_guias, sgt_parametros, parent, 0 , Layered! )
end event

type uo_1 from u_ingreso_rango_fechas within w_ve901_generacion_fact_cobrar
integer x = 69
integer y = 764
integer taborder = 60
boolean bringtotop = true
end type

event constructor;call super::constructor;String ls_desde
 
 of_set_label('Del:','Al:') 								//	para setear la fecha inicial
 
 ls_desde = '01/' + string(month(today()))+'/' + string(year(today()))
 of_set_fecha(date(ls_desde), today()) 				// para seatear el titulo del boton
 of_set_rango_inicio(date('01/01/1900')) 				// rango inicial
 of_set_rango_fin(date('31/12/9999'))					// rango final

// of_get_fecha1(), of_get_fecha2()  para leer las fechas

end event

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

type pb_3 from picturebutton within w_ve901_generacion_fact_cobrar
integer x = 992
integer y = 364
integer width = 101
integer height = 88
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
boolean enabled = false
string picturename = "EditDataFreeform!"
alignment htextalign = left!
string powertiptext = "Busqueda de Series para Facturas"
end type

event clicked;str_seleccionar lstr_seleccionar

lstr_seleccionar.s_seleccion = 'S'
lstr_seleccionar.s_sql = 'SELECT A.TIPO_MOV AS MOVIMIENTO, '&
								+'A.DESC_TIPO_MOV AS DESCRIPCION '&
								+'FROM ARTICULO_MOV_TIPO A '&
								+"WHERE A.FLAG_ESTADO = '1' "

OpenWithParm(w_seleccionar,lstr_seleccionar)

IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm

IF lstr_seleccionar.s_action = "aceptar" THEN
	sle_movimiento.text = string(lstr_seleccionar.param1[1])
	sle_desc_movimiento.text = string(lstr_seleccionar.param2[1])
END IF
end event

type st_5 from statictext within w_ve901_generacion_fact_cobrar
integer x = 32
integer y = 1020
integer width = 544
integer height = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Origen :"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_origen from singlelineedit within w_ve901_generacion_fact_cobrar
integer x = 594
integer y = 1012
integer width = 110
integer height = 72
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
boolean enabled = false
textcase textcase = upper!
integer limit = 3
end type

type sle_desc_movimiento from singlelineedit within w_ve901_generacion_fact_cobrar
integer x = 1106
integer y = 372
integer width = 896
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

type sle_movimiento from singlelineedit within w_ve901_generacion_fact_cobrar
integer x = 731
integer y = 372
integer width = 251
integer height = 80
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean enabled = false
textcase textcase = upper!
integer limit = 6
end type

type st_4 from statictext within w_ve901_generacion_fact_cobrar
integer x = 55
integer y = 388
integer width = 663
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Tipo. Mov. de Vales de G.R. :"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_fecha from n_ingreso_fecha within w_ve901_generacion_fact_cobrar
integer x = 594
integer y = 912
integer width = 571
integer height = 80
integer taborder = 20
integer textsize = -8
string text = ""
borderstyle borderstyle = stylebox!
maskdatatype maskdatatype = datetimemask!
string mask = "dd/mm/yyyy hh:mm:ss"
boolean spin = true
end type

event constructor;call super::constructor;this.text = string(today(),'dd/mm/yyyy hh:mm:ss')
end event

type st_3 from statictext within w_ve901_generacion_fact_cobrar
integer x = 32
integer y = 928
integer width = 544
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Fecha de Facturacion :"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_desc_factura from singlelineedit within w_ve901_generacion_fact_cobrar
integer x = 1106
integer y = 248
integer width = 896
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

type pb_2 from picturebutton within w_ve901_generacion_fact_cobrar
integer x = 992
integer y = 244
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

event clicked;str_parametros   sl_param

sl_param.dw1 = "d_lista_tipo_doc_usuario"
sl_param.titulo = "Tipo de Documento"
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 3
sl_param.tipo = '2S'
sl_param.string1 = gs_user
sl_param.string2 = is_cod_factura

OpenWithParm( w_lista, sl_param)		
				
sl_param = MESSAGE.POWEROBJECTPARM
				
if sl_param.titulo <> 'n' then	
	sle_factura.text = sl_param.field_ret[1]
	sle_desc_factura.text = sl_param.field_ret[2]
END IF
end event

type sle_factura from singlelineedit within w_ve901_generacion_fact_cobrar
integer x = 731
integer y = 248
integer width = 251
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

type st_2 from statictext within w_ve901_generacion_fact_cobrar
integer x = 55
integer y = 260
integer width = 663
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Serie de Facturas a generar :"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_desc_boleta from singlelineedit within w_ve901_generacion_fact_cobrar
integer x = 1106
integer y = 128
integer width = 896
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

type pb_1 from picturebutton within w_ve901_generacion_fact_cobrar
integer x = 992
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

event clicked;str_parametros   sl_param

sl_param.dw1 = "d_lista_tipo_doc_usuario"
sl_param.titulo = "Tipo de Documento"
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 3
sl_param.tipo = '2S'
sl_param.string1 = gs_user
sl_param.string2 = is_cod_boleta

OpenWithParm( w_lista, sl_param)		
				
sl_param = MESSAGE.POWEROBJECTPARM
				
if sl_param.titulo <> 'n' then	
	sle_boleta.text = sl_param.field_ret[1]
	sle_desc_boleta.text = sl_param.field_ret[2]
END IF
end event

type sle_boleta from singlelineedit within w_ve901_generacion_fact_cobrar
integer x = 731
integer y = 128
integer width = 251
integer height = 80
integer taborder = 30
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

type st_1 from statictext within w_ve901_generacion_fact_cobrar
integer x = 55
integer y = 140
integer width = 663
integer height = 52
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Serie de Boletas a generar :"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_procesar from commandbutton within w_ve901_generacion_fact_cobrar
string tag = "Ejecutar Proceso"
integer x = 1536
integer y = 976
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

event clicked;integer  li_serie_bol, li_serie_fac, li_numero
string   ls_tipo_mov, ls_forma_pago, ls_nro_menor_f, ls_nro_mayor_f, ls_cod_factura, &
			ls_cod_boleta, ls_nro_menor_b, ls_nro_mayor_b
datetime ldt_fecha
date ld_fecha, ld_fec_ini, ld_fec_fin
time lt_hora

li_serie_bol = integer(sle_boleta.text)

if isnull(li_serie_bol) or li_serie_bol = 0 then
	messagebox('Aviso','Debe de ingresar una Serie para la Boleta')
	return
end if

li_serie_fac = integer(sle_factura.text)

if isnull(li_serie_fac) or li_serie_fac = 0 then
	messagebox('Aviso','Debe de ingresar una Serie para la Factura')
	return
end if

ls_forma_pago = string(sle_forma_pago.text)

if isnull(ls_forma_pago) or ls_forma_pago = '' then
	messagebox('Aviso','Debe de ingresar una Forma de Pago para la Factura')
	return
end if

ld_fecha = date( mid(em_fecha.text,1,10) )
lt_hora  = time( mid(em_fecha.text,12,19))
ldt_fecha = datetime( ld_fecha, lt_hora)

ls_tipo_mov = string(sle_movimiento.text)

ld_fec_ini = uo_1.of_get_fecha1()
ld_fec_fin = uo_1.of_get_fecha2()

/* Hallando ultimo numero para efectos de mensaje final*/
select f.doc_fact_cobrar, f.doc_bol_cobrar
  into :ls_cod_factura, :ls_cod_boleta
  from finparam f
 where f.reckey = '1';
 
 //facturas
Select n.ultimo_numero
  into :li_numero
  From num_doc_tipo n
 Where n.tipo_doc = :ls_cod_factura
   And n.nro_serie = :li_serie_fac;

ls_nro_menor_f = right('00'+string(li_serie_fac),3)+'-'+right('000'+string(li_numero),6)

//boletas
Select n.ultimo_numero
  into :li_numero
  From num_doc_tipo n
 Where n.tipo_doc = :ls_cod_boleta
   And n.nro_serie = :li_serie_bol;

ls_nro_menor_b = right('00'+string(li_serie_bol),3)+'-'+right('000'+string(li_numero),6)

/* Finalizacion de codigo pedido por gladys aranda*/
declare usp_proc1 procedure for usp_fin_genera_fact(:li_serie_bol, :li_serie_fac, :ldt_fecha, :ls_tipo_mov, :gs_origen, :gs_user, :ld_fec_ini, :ld_fec_fin, :ls_forma_pago);
execute usp_proc1;

if sqlca.sqlcode = -1 then
	messagebox('Aviso',string(sqlca.sqlcode)+' '+sqlca.sqlerrtext)
	rollback;
	return
else
	commit;
	
	//facturas
	Select n.ultimo_numero
	  into :li_numero
	  From num_doc_tipo n
	 Where n.tipo_doc = :ls_cod_factura
		And n.nro_serie = :li_serie_fac;

	li_numero = li_numero - 1
   ls_nro_mayor_f = right('00'+string(li_serie_fac),3)+'-'+right('000'+string(li_numero),6)
	
	//boletas
	Select n.ultimo_numero
	  into :li_numero
	  From num_doc_tipo n
	 Where n.tipo_doc = :ls_cod_boleta
		And n.nro_serie = :li_serie_bol;

	li_numero = li_numero - 1
   ls_nro_mayor_b = right('00'+string(li_serie_bol),3)+'-'+right('000'+string(li_numero),6)
	
	messagebox('Aviso','Proceso Finalizado Exitosamente, Numeros de Facturas desde '+ls_nro_menor_f+' hasta '+ls_nro_mayor_f+' ~n' + 'Numeros de Boletas desde '+ls_nro_menor_b+' hasta '+ls_nro_mayor_b	)
end if
end event

type gb_1 from groupbox within w_ve901_generacion_fact_cobrar
integer x = 37
integer y = 32
integer width = 2016
integer height = 612
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 8388608
long backcolor = 67108864
string text = "Opciones de Generacion"
borderstyle borderstyle = stylebox!
end type

type gb_2 from groupbox within w_ve901_generacion_fact_cobrar
integer x = 37
integer y = 688
integer width = 1358
integer height = 196
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 8388608
long backcolor = 67108864
string text = "Rango de Fechas para Capturar G. R."
borderstyle borderstyle = stylebox!
end type

