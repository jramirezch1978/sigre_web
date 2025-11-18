$PBExportHeader$w_aud301_cambio_fechas.srw
forward
global type w_aud301_cambio_fechas from w_abc_master
end type
type rb_vale from radiobutton within w_aud301_cambio_fechas
end type
type rb_guia from radiobutton within w_aud301_cambio_fechas
end type
type rb_factura from radiobutton within w_aud301_cambio_fechas
end type
type sle_origen from singlelineedit within w_aud301_cambio_fechas
end type
type sle_tipo_doc from singlelineedit within w_aud301_cambio_fechas
end type
type st_1 from statictext within w_aud301_cambio_fechas
end type
type st_2 from statictext within w_aud301_cambio_fechas
end type
type st_3 from statictext within w_aud301_cambio_fechas
end type
type sle_codrel from singlelineedit within w_aud301_cambio_fechas
end type
type sle_documento from singlelineedit within w_aud301_cambio_fechas
end type
type st_4 from statictext within w_aud301_cambio_fechas
end type
type sle_desc_origen from singlelineedit within w_aud301_cambio_fechas
end type
type sle_desc_codrel from singlelineedit within w_aud301_cambio_fechas
end type
type sle_desc_tipo_doc from singlelineedit within w_aud301_cambio_fechas
end type
type cb_1 from commandbutton within w_aud301_cambio_fechas
end type
type pb_origen from picturebutton within w_aud301_cambio_fechas
end type
type pb_codrel from picturebutton within w_aud301_cambio_fechas
end type
type pb_tipo_doc from picturebutton within w_aud301_cambio_fechas
end type
type gb_1 from groupbox within w_aud301_cambio_fechas
end type
end forward

global type w_aud301_cambio_fechas from w_abc_master
integer width = 3287
integer height = 1332
string title = "Cambio de fecha (AUD301)"
string menuname = "m_graba"
rb_vale rb_vale
rb_guia rb_guia
rb_factura rb_factura
sle_origen sle_origen
sle_tipo_doc sle_tipo_doc
st_1 st_1
st_2 st_2
st_3 st_3
sle_codrel sle_codrel
sle_documento sle_documento
st_4 st_4
sle_desc_origen sle_desc_origen
sle_desc_codrel sle_desc_codrel
sle_desc_tipo_doc sle_desc_tipo_doc
cb_1 cb_1
pb_origen pb_origen
pb_codrel pb_codrel
pb_tipo_doc pb_tipo_doc
gb_1 gb_1
end type
global w_aud301_cambio_fechas w_aud301_cambio_fechas

on w_aud301_cambio_fechas.create
int iCurrent
call super::create
if this.MenuName = "m_graba" then this.MenuID = create m_graba
this.rb_vale=create rb_vale
this.rb_guia=create rb_guia
this.rb_factura=create rb_factura
this.sle_origen=create sle_origen
this.sle_tipo_doc=create sle_tipo_doc
this.st_1=create st_1
this.st_2=create st_2
this.st_3=create st_3
this.sle_codrel=create sle_codrel
this.sle_documento=create sle_documento
this.st_4=create st_4
this.sle_desc_origen=create sle_desc_origen
this.sle_desc_codrel=create sle_desc_codrel
this.sle_desc_tipo_doc=create sle_desc_tipo_doc
this.cb_1=create cb_1
this.pb_origen=create pb_origen
this.pb_codrel=create pb_codrel
this.pb_tipo_doc=create pb_tipo_doc
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_vale
this.Control[iCurrent+2]=this.rb_guia
this.Control[iCurrent+3]=this.rb_factura
this.Control[iCurrent+4]=this.sle_origen
this.Control[iCurrent+5]=this.sle_tipo_doc
this.Control[iCurrent+6]=this.st_1
this.Control[iCurrent+7]=this.st_2
this.Control[iCurrent+8]=this.st_3
this.Control[iCurrent+9]=this.sle_codrel
this.Control[iCurrent+10]=this.sle_documento
this.Control[iCurrent+11]=this.st_4
this.Control[iCurrent+12]=this.sle_desc_origen
this.Control[iCurrent+13]=this.sle_desc_codrel
this.Control[iCurrent+14]=this.sle_desc_tipo_doc
this.Control[iCurrent+15]=this.cb_1
this.Control[iCurrent+16]=this.pb_origen
this.Control[iCurrent+17]=this.pb_codrel
this.Control[iCurrent+18]=this.pb_tipo_doc
this.Control[iCurrent+19]=this.gb_1
end on

on w_aud301_cambio_fechas.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_vale)
destroy(this.rb_guia)
destroy(this.rb_factura)
destroy(this.sle_origen)
destroy(this.sle_tipo_doc)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.sle_codrel)
destroy(this.sle_documento)
destroy(this.st_4)
destroy(this.sle_desc_origen)
destroy(this.sle_desc_codrel)
destroy(this.sle_desc_tipo_doc)
destroy(this.cb_1)
destroy(this.pb_origen)
destroy(this.pb_codrel)
destroy(this.pb_tipo_doc)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;//idw_1.Retrieve()
//ii_help = 101            // help topic
//ii_pregunta_delete = 1   // 1 = si pregunta, 0 = no pregunta (default)
//ib_log = TRUE
//is_tabla = 'Master'
//idw_query = dw_master
end event

type dw_master from w_abc_master`dw_master within w_aud301_cambio_fechas
integer x = 110
integer y = 588
integer width = 3095
integer height = 532
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectura de este dw
ii_ck[2] = 2				// columnas de lectura de este dw

//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
//idw_det  =  				// dw_detail
end event

event dw_master::itemchanged;call super::itemchanged;this.ii_update = 1
end event

event dw_master::clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

type rb_vale from radiobutton within w_aud301_cambio_fechas
integer x = 197
integer y = 160
integer width = 457
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Vale de salida"
end type

event clicked;sle_origen.text = ''
sle_desc_origen.text = ''
sle_codrel.text = ''
sle_desc_codrel.text = ''
sle_tipo_doc.text = 'AL'
sle_desc_tipo_doc.text = 'Movimiento de almacen'

sle_origen.enabled = true
pb_origen.enabled = true
sle_desc_origen.enabled = false

sle_codrel.enabled = false
pb_codrel.enabled = false
sle_desc_codrel.enabled = false

sle_tipo_doc.enabled = false
pb_tipo_doc.enabled = false
sle_desc_tipo_doc.enabled = false
idw_1.reset()
end event

type rb_guia from radiobutton within w_aud301_cambio_fechas
integer x = 197
integer y = 244
integer width = 530
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Guía de remisión"
end type

event clicked;sle_origen.text = ''
sle_desc_origen.text = ''
sle_codrel.text = ''
sle_desc_codrel.text = ''
sle_tipo_doc.text = 'GR'
sle_desc_tipo_doc.text = 'Guía de remisión'

sle_origen.enabled = true
pb_origen.enabled = true
sle_desc_origen.enabled = false

sle_codrel.enabled = false
pb_codrel.enabled = false
sle_desc_codrel.enabled = false

sle_tipo_doc.enabled = false
pb_tipo_doc.enabled = false
sle_desc_tipo_doc.enabled = false
idw_1.reset()
end event

type rb_factura from radiobutton within w_aud301_cambio_fechas
integer x = 197
integer y = 332
integer width = 402
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Facturación"
end type

event clicked;sle_origen.text = ''
sle_desc_origen.text = ''
sle_codrel.text = ''
sle_desc_codrel.text = ''
sle_tipo_doc.text = ''
sle_desc_tipo_doc.text = ''

sle_origen.enabled = false
pb_origen.enabled = false
sle_desc_origen.enabled = false

sle_codrel.enabled = true
pb_codrel.enabled = true
sle_desc_codrel.enabled = false

sle_tipo_doc.enabled = true
pb_tipo_doc.enabled = true
sle_desc_tipo_doc.enabled = false
idw_1.reset()
end event

type sle_origen from singlelineedit within w_aud301_cambio_fechas
integer x = 1349
integer y = 108
integer width = 114
integer height = 76
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event modified;Long ll_count
String ls_origen, ls_nombre

ls_origen = sle_origen.text

SELECT count(*)
INTO :ll_count
FROM origen
WHERE cod_origen = :ls_origen ;

IF ll_count > 0 THEN
	SELECT nombre
	INTO :ls_nombre
	FROM origen
	WHERE cod_origen = :ls_origen ;
	
	sle_desc_origen.text = ls_nombre
ELSE
	MessageBox('Aviso','Origen no existe')
END IF

end event

type sle_tipo_doc from singlelineedit within w_aud301_cambio_fechas
integer x = 1349
integer y = 324
integer width = 155
integer height = 76
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event modified;Long ll_count
String ls_tipo_doc, ls_nombre

ls_tipo_doc = sle_tipo_doc.text

SELECT count(*)
INTO :ll_count
FROM doc_tipo
WHERE tipo_doc = :ls_tipo_doc ;

IF ll_count > 0 THEN
	SELECT desc_tipo_doc
	INTO :ls_nombre
	FROM doc_tipo
	WHERE tipo_doc = :ls_tipo_doc ;
	
	sle_desc_tipo_doc.text = ls_nombre
ELSE
	MessageBox('Aviso','Tipo de documento no existe')
END IF

end event

type st_1 from statictext within w_aud301_cambio_fechas
integer x = 901
integer y = 108
integer width = 242
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Origen :"
boolean focusrectangle = false
end type

type st_2 from statictext within w_aud301_cambio_fechas
integer x = 901
integer y = 320
integer width = 434
integer height = 56
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Tipo documento"
boolean focusrectangle = false
end type

type st_3 from statictext within w_aud301_cambio_fechas
integer x = 901
integer y = 216
integer width = 361
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Cod.relación:"
boolean focusrectangle = false
end type

type sle_codrel from singlelineedit within w_aud301_cambio_fechas
integer x = 1349
integer y = 216
integer width = 270
integer height = 76
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event modified;Long ll_count
String ls_codrel, ls_nombre

ls_codrel = sle_codrel.text

SELECT count(*)
INTO :ll_count
FROM proveedor
WHERE proveedor = :ls_codrel ;

IF ll_count > 0 THEN
	SELECT nom_proveedor
	INTO :ls_nombre
	FROM proveedor
	WHERE proveedor = :ls_codrel ;
	
	sle_desc_codrel.text = ls_nombre
ELSE
	MessageBox('Aviso','Código de relación no existe')
END IF

end event

type sle_documento from singlelineedit within w_aud301_cambio_fechas
integer x = 1349
integer y = 432
integer width = 366
integer height = 76
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_4 from statictext within w_aud301_cambio_fechas
integer x = 901
integer y = 440
integer width = 347
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Documento:"
boolean focusrectangle = false
end type

type sle_desc_origen from singlelineedit within w_aud301_cambio_fechas
integer x = 1609
integer y = 108
integer width = 1179
integer height = 76
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type sle_desc_codrel from singlelineedit within w_aud301_cambio_fechas
integer x = 1755
integer y = 216
integer width = 1029
integer height = 76
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type sle_desc_tipo_doc from singlelineedit within w_aud301_cambio_fechas
integer x = 1650
integer y = 324
integer width = 1134
integer height = 76
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type cb_1 from commandbutton within w_aud301_cambio_fechas
integer x = 2894
integer y = 244
integer width = 283
integer height = 112
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Buscar"
end type

event clicked;String ls_origen, ls_tipo_doc, ls_documento
Long ll_count

ls_documento = trim(sle_documento.text)



IF (rb_vale.checked = true or rb_guia.checked = true) then
	ls_origen = TRIM(sle_origen.text)
END IF
IF rb_factura.checked = true then
	ls_tipo_doc = TRIM( sle_tipo_doc.text )
END IF 



IF rb_vale.checked = true THEN
	SELECT count(*) 
	INTO :ll_count
	FROM vale_mov 
	WHERE cod_origen=:ls_origen AND nro_vale=:ls_documento ;
	
	IF ll_count > 0 THEN
		idw_1.DataObject='d_vale_salida_fecha_tbl'
		idw_1.SetTransObject(sqlca)
		idw_1.retrieve( ls_origen, ls_documento)
	ELSE
		MessageBox('Aviso', 'Vale no existe')
	END IF 
END IF




IF rb_guia.checked = true THEN
	SELECT count(*) 
	INTO :ll_count
	FROM guia 
	WHERE cod_origen=:ls_origen AND nro_guia=:ls_documento ;
	
	IF ll_count > 0 THEN
		idw_1.DataObject='d_guia_remis_fecha_tbl'
		idw_1.SetTransObject(sqlca)
		idw_1.retrieve( ls_origen, ls_documento)
	ELSE
		MessageBox('Aviso', 'Guia no existe')
	END IF 
END IF



IF rb_factura.checked = true THEN
	SELECT count(*) 
	INTO :ll_count
	FROM cntas_cobrar 
	WHERE tipo_doc=:ls_tipo_doc AND nro_doc=:ls_documento ;
	
	IF ll_count > 0 THEN
		idw_1.DataObject='d_factura_fecha_ff'
		idw_1.SetTransObject(sqlca)
		idw_1.retrieve( ls_tipo_doc, ls_documento)
	ELSE
		MessageBox('Aviso', 'Factura no existe')
	END IF 
END IF

end event

type pb_origen from picturebutton within w_aud301_cambio_fechas
integer x = 1477
integer y = 100
integer width = 114
integer height = 104
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "H:\Source\Bmp\file_open.bmp"
alignment htextalign = left!
end type

event clicked;str_seleccionar lstr_seleccionar
String ls_inactivo

IF (rb_vale.checked = true OR rb_guia.checked=true) THEN
	lstr_seleccionar.s_seleccion = 'S'
	lstr_seleccionar.s_sql = 'SELECT ORIGEN.COD_ORIGEN AS CODIGO,'&
									 +'ORIGEN.NOMBRE AS DESCRIPCION '&     	
		   						 +'FROM ORIGEN '

	OpenWithParm(w_seleccionar,lstr_seleccionar)
	IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
	IF lstr_seleccionar.s_action = "aceptar" THEN
		sle_origen.text = lstr_seleccionar.param1[1]
		sle_desc_origen.text = lstr_seleccionar.param2[1]
	END IF												 

END IF

end event

type pb_codrel from picturebutton within w_aud301_cambio_fechas
integer x = 1632
integer y = 208
integer width = 114
integer height = 104
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "H:\Source\Bmp\file_open.bmp"
alignment htextalign = left!
end type

event clicked;str_seleccionar lstr_seleccionar
String ls_inactivo

IF rb_factura.checked = true THEN
	lstr_seleccionar.s_seleccion = 'S'
	lstr_seleccionar.s_sql = 'SELECT PROVEEDOR.PROVEEDOR AS CODIGO,'&
									 +'PROVEEDOR.NOM_PROVEEDOR AS RAZON_SOCIAL, '&
									 +'PROVEEDOR.RUC AS RUC_CLIENTE '&
		   						 +'FROM PROVEEDOR '

	OpenWithParm(w_seleccionar,lstr_seleccionar)
	IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
	IF lstr_seleccionar.s_action = "aceptar" THEN
		sle_codrel.text = lstr_seleccionar.param1[1]
		sle_desc_codrel.text = lstr_seleccionar.param2[1]
	END IF												 

END IF

end event

type pb_tipo_doc from picturebutton within w_aud301_cambio_fechas
integer x = 1522
integer y = 316
integer width = 114
integer height = 104
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "H:\Source\Bmp\file_open.bmp"
alignment htextalign = left!
end type

event clicked;str_seleccionar lstr_seleccionar
String ls_inactivo

IF rb_factura.checked = true THEN
	lstr_seleccionar.s_seleccion = 'S'
	lstr_seleccionar.s_sql = 'SELECT DOC_TIPO.TIPO_DOC AS CODIGO,'&
									 +'DOC_TIPO.DESC_TIPO_DOC AS DESCRIPCION '&
		   						 +'FROM DOC_TIPO '

	OpenWithParm(w_seleccionar,lstr_seleccionar)
	IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
	IF lstr_seleccionar.s_action = "aceptar" THEN
		sle_tipo_doc.text = lstr_seleccionar.param1[1]
		sle_desc_tipo_doc.text = lstr_seleccionar.param2[1]
	END IF												 

END IF

end event

type gb_1 from groupbox within w_aud301_cambio_fechas
integer x = 101
integer y = 36
integer width = 2747
integer height = 520
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "Parámetros"
end type

