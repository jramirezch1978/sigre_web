$PBExportHeader$w_ope709_material_proyec_det.srw
forward
global type w_ope709_material_proyec_det from w_report_smpl
end type
type sle_codigo from singlelineedit within w_ope709_material_proyec_det
end type
type rb_ccr from radiobutton within w_ope709_material_proyec_det
end type
type rb_fec from radiobutton within w_ope709_material_proyec_det
end type
type sle_nombre from singlelineedit within w_ope709_material_proyec_det
end type
type uo_1 from u_ingreso_rango_fechas within w_ope709_material_proyec_det
end type
type cb_3 from commandbutton within w_ope709_material_proyec_det
end type
type pb_1 from picturebutton within w_ope709_material_proyec_det
end type
type rb_eje from radiobutton within w_ope709_material_proyec_det
end type
type rb_ota from radiobutton within w_ope709_material_proyec_det
end type
type gb_1 from groupbox within w_ope709_material_proyec_det
end type
end forward

global type w_ope709_material_proyec_det from w_report_smpl
integer width = 3269
integer height = 1560
string title = "Materiales planeados detalle (ope709)"
string menuname = "m_rpt_smpl"
long backcolor = 12632256
sle_codigo sle_codigo
rb_ccr rb_ccr
rb_fec rb_fec
sle_nombre sle_nombre
uo_1 uo_1
cb_3 cb_3
pb_1 pb_1
rb_eje rb_eje
rb_ota rb_ota
gb_1 gb_1
end type
global w_ope709_material_proyec_det w_ope709_material_proyec_det

on w_ope709_material_proyec_det.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_smpl" then this.MenuID = create m_rpt_smpl
this.sle_codigo=create sle_codigo
this.rb_ccr=create rb_ccr
this.rb_fec=create rb_fec
this.sle_nombre=create sle_nombre
this.uo_1=create uo_1
this.cb_3=create cb_3
this.pb_1=create pb_1
this.rb_eje=create rb_eje
this.rb_ota=create rb_ota
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_codigo
this.Control[iCurrent+2]=this.rb_ccr
this.Control[iCurrent+3]=this.rb_fec
this.Control[iCurrent+4]=this.sle_nombre
this.Control[iCurrent+5]=this.uo_1
this.Control[iCurrent+6]=this.cb_3
this.Control[iCurrent+7]=this.pb_1
this.Control[iCurrent+8]=this.rb_eje
this.Control[iCurrent+9]=this.rb_ota
this.Control[iCurrent+10]=this.gb_1
end on

on w_ope709_material_proyec_det.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_codigo)
destroy(this.rb_ccr)
destroy(this.rb_fec)
destroy(this.sle_nombre)
destroy(this.uo_1)
destroy(this.cb_3)
destroy(this.pb_1)
destroy(this.rb_eje)
destroy(this.rb_ota)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;sle_codigo.enabled = false
end event

type dw_report from w_report_smpl`dw_report within w_ope709_material_proyec_det
integer x = 50
integer y = 464
integer width = 3145
integer height = 748
string dataobject = "d_rpt_proy_mat_fecha_tbl"
end type

type sle_codigo from singlelineedit within w_ope709_material_proyec_det
integer x = 613
integer y = 116
integer width = 357
integer height = 88
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
String ls_codigo, ls_nombre

ls_codigo = sle_codigo.text

IF ( rb_ccr.checked = false and rb_eje.checked = false and &
	  rb_ota.checked = false and rb_fec.checked = false) THEN
	MessageBox('Aviso', 'Defina opción a consultar')
	return 0
END IF

IF rb_ccr.checked = true THEN
	SELECT count(*)
	INTO :ll_count
	FROM centros_costo
	WHERE cencos = :ls_codigo ;

	IF ll_count = 0 THEN
		return 0
	ELSE
		SELECT desc_cencos
	  	INTO :ls_nombre
	  	FROM centros_costo
	 	WHERE cencos = :ls_codigo ;
	END IF

ELSEIF rb_eje.checked = true THEN
	SELECT count(*)
	INTO :ll_count
	FROM centro_beneficio
	WHERE centro_benef = :ls_codigo ;

	IF ll_count = 0 THEN
		return 0
	ELSE
		SELECT desc_centro
	  	INTO :ls_nombre
	  	FROM centro_beneficio
	 	WHERE centro_benef = :ls_codigo ;
	END IF
	
ELSEIF rb_ota.checked = true THEN
	SELECT count(*)
	INTO :ll_count
	FROM ot_administracion
	WHERE ot_adm = :ls_codigo ;

	IF ll_count = 0 THEN
		return 0
	ELSE
		SELECT descripcion
	  	INTO :ls_nombre
	  	FROM ot_administracion
	 	WHERE ot_adm = :ls_codigo ;
	END IF

END IF 

sle_nombre.text = ls_nombre
end event

type rb_ccr from radiobutton within w_ope709_material_proyec_det
integer x = 114
integer y = 92
integer width = 439
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "C.Costo Solic."
end type

event clicked;sle_codigo.text = ''
sle_nombre.text = ''
sle_codigo.enabled = true
end event

type rb_fec from radiobutton within w_ope709_material_proyec_det
integer x = 114
integer y = 320
integer width = 439
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Fecha"
boolean checked = true
end type

event clicked;sle_codigo.text = ''
sle_nombre.text = ''
sle_codigo.enabled = false
end event

type sle_nombre from singlelineedit within w_ope709_material_proyec_det
integer x = 1143
integer y = 116
integer width = 1125
integer height = 88
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
borderstyle borderstyle = stylelowered!
end type

type uo_1 from u_ingreso_rango_fechas within w_ope709_material_proyec_det
integer x = 617
integer y = 260
integer taborder = 20
boolean bringtotop = true
end type

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;of_set_label('Desde:','Hasta:') //para setear la fecha inicial
of_set_fecha(today(), today()) // para seatear el titulo del boton
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final
// of_get_fecha1(), of_get_fecha2()  para leer las fechas

end event

type cb_3 from commandbutton within w_ope709_material_proyec_det
integer x = 2414
integer y = 136
integer width = 402
integer height = 112
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Consultar"
end type

event clicked;String ls_codigo, ls_tipo, ls_descrip, ls_msj
Date ld_fec_ini, ld_fec_fin

SetPointer(HourGlass!)

ls_codigo = TRIM(sle_codigo.text)
ld_fec_ini = uo_1.of_get_fecha1()
ld_fec_fin = uo_1.of_get_fecha2()

ls_codigo = TRIM(sle_codigo.text)
ls_descrip = TRIM(sle_nombre.text)
idw_1.DataObject='d_rpt_proy_mat_fecha_tbl'
IF rb_ccr.checked=true then
	ls_tipo = 'C'
	idw_1.Object.t_texto.text = ls_codigo + ' ' + ls_descrip 
ELSEIF rb_eje.checked=true then
	ls_tipo = 'E'
	idw_1.Object.t_texto.text = ls_codigo + ' ' + ls_descrip 
ELSEIF rb_ota.checked=true then
	ls_tipo = 'O'
	idw_1.Object.t_texto.text = ls_codigo + ' ' + ls_descrip 
ELSEIF rb_fec.checked=true then
	ls_tipo = 'F'
	idw_1.Object.t_texto.text = 'Materiales en general'
END IF

DECLARE PB_USP_OPE_MATERIAL_PROG_PROY PROCEDURE FOR USP_OPE_MATERIAL_PROG_PROY
		  ( 'Y', :ls_tipo, :ls_codigo, :ld_fec_ini, :ld_fec_fin ) ;
Execute PB_USP_OPE_MATERIAL_PROG_PROY ;

SetPointer(Arrow!)

if sqlca.sqlcode = -1 Then
	ls_msj = sqlca.sqlerrtext
	MessageBox( 'Error', ls_msj, StopSign! )
	MessageBox( 'Error', "Procedimiento <<USP_OPE_MATERIAL_PROG_PROY>> no concluyo correctamente", StopSign! )
End If

idw_1.SetTransObject(sqlca)
idw_1.retrieve()

idw_1.Object.p_logo.filename = gs_logo
idw_1.Object.t_fecha.text = 'Del ' + string(ld_fec_ini, 'dd/mm/yyyy') + ' al ' + string(ld_fec_fin, 'dd/mm/yyyy')
idw_1.Object.p_logo.filename = gs_logo

ib_preview = false
idw_1.visible=true
idw_1.ii_zoom_actual = 100
parent.event ue_preview()

//cb_generar.enabled = true
end event

type pb_1 from picturebutton within w_ope709_material_proyec_det
integer x = 992
integer y = 116
integer width = 123
integer height = 104
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
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

IF ( rb_ccr.checked = false and rb_eje.checked = false and &
	  rb_ota.checked = false and rb_fec.checked = false) THEN
	MessageBox('Aviso', 'Defina opción a consultar')
	return 0
END IF

ls_inactivo = '0'
	
IF rb_ccr.checked = true then
	lstr_seleccionar.s_seleccion = 'S'
	lstr_seleccionar.s_sql = 'SELECT CENTROS_COSTO.CENCOS 	  AS CENCOS,'&
									 +'CENTROS_COSTO.DESC_CENCOS AS DESCRIPCION '&     	
		   						 +'FROM CENTROS_COSTO ' &
									 +'WHERE CENTROS_COSTO.FLAG_ESTADO <> ' + "'"+ls_inactivo+"'"

	OpenWithParm(w_seleccionar,lstr_seleccionar)
	IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
	IF lstr_seleccionar.s_action = "aceptar" THEN
		sle_codigo.text = lstr_seleccionar.param1[1]
		sle_nombre.text = lstr_seleccionar.param2[1]
	END IF												 
END IF 

IF rb_eje.checked = true then
	lstr_seleccionar.s_seleccion = 'S'
	lstr_seleccionar.s_sql = 'SELECT CENTRO_BENEFICIO.CENTRO_BENEF  AS CENTRO,'&
									 +'CENTRO_BENEFICIO.DESC_CENTRO AS DESCRIPCION '&     	
		   						 +'FROM CENTRO_BENEFICIO ' &
									 +'WHERE CENTRO_BENEFICIO.FLAG_ESTADO <> ' + "'"+ls_inactivo+"'"

	OpenWithParm(w_seleccionar,lstr_seleccionar)
	IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
	IF lstr_seleccionar.s_action = "aceptar" THEN
		sle_codigo.text = lstr_seleccionar.param1[1]
		sle_nombre.text = lstr_seleccionar.param2[1]
	END IF												 
END IF 

IF rb_ota.checked = true then
	lstr_seleccionar.s_seleccion = 'S'
	lstr_seleccionar.s_sql = 'SELECT OT_ADMINISTRACION.OT_ADM AS CODIGO,'&
									 +'OT_ADMINISTRACION.DESCRIPCION AS DESCRIPCION '&     	
		   						 +'FROM OT_ADMINISTRACION ' 

	OpenWithParm(w_seleccionar,lstr_seleccionar)
	IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
	IF lstr_seleccionar.s_action = "aceptar" THEN
		sle_codigo.text = lstr_seleccionar.param1[1]
		sle_nombre.text = lstr_seleccionar.param2[1]
	END IF												 
END IF 

end event

type rb_eje from radiobutton within w_ope709_material_proyec_det
integer x = 114
integer y = 168
integer width = 498
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Centro beneficio"
end type

event clicked;sle_codigo.text = ''
sle_nombre.text = ''
sle_codigo.enabled = true
end event

type rb_ota from radiobutton within w_ope709_material_proyec_det
integer x = 114
integer y = 244
integer width = 439
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Ot_adm"
end type

event clicked;sle_codigo.text = ''
sle_nombre.text = ''
sle_codigo.enabled = true
end event

type gb_1 from groupbox within w_ope709_material_proyec_det
integer x = 50
integer y = 16
integer width = 2277
integer height = 396
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "Parámetros"
end type

