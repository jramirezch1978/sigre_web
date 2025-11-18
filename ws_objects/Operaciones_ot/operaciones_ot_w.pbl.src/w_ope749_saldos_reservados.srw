$PBExportHeader$w_ope749_saldos_reservados.srw
forward
global type w_ope749_saldos_reservados from w_report_smpl
end type
type sle_codigo from singlelineedit within w_ope749_saldos_reservados
end type
type rb_gen from radiobutton within w_ope749_saldos_reservados
end type
type rb_maq from radiobutton within w_ope749_saldos_reservados
end type
type sle_nombre from singlelineedit within w_ope749_saldos_reservados
end type
type cb_3 from commandbutton within w_ope749_saldos_reservados
end type
type pb_1 from picturebutton within w_ope749_saldos_reservados
end type
type rb_ot_adm from radiobutton within w_ope749_saldos_reservados
end type
type rb_ot from radiobutton within w_ope749_saldos_reservados
end type
type gb_1 from groupbox within w_ope749_saldos_reservados
end type
end forward

global type w_ope749_saldos_reservados from w_report_smpl
integer width = 3269
integer height = 2040
string title = "Saldos reservados por requerimeinto (OPE749)"
string menuname = "m_rpt_smpl"
long backcolor = 12632256
sle_codigo sle_codigo
rb_gen rb_gen
rb_maq rb_maq
sle_nombre sle_nombre
cb_3 cb_3
pb_1 pb_1
rb_ot_adm rb_ot_adm
rb_ot rb_ot
gb_1 gb_1
end type
global w_ope749_saldos_reservados w_ope749_saldos_reservados

on w_ope749_saldos_reservados.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_smpl" then this.MenuID = create m_rpt_smpl
this.sle_codigo=create sle_codigo
this.rb_gen=create rb_gen
this.rb_maq=create rb_maq
this.sle_nombre=create sle_nombre
this.cb_3=create cb_3
this.pb_1=create pb_1
this.rb_ot_adm=create rb_ot_adm
this.rb_ot=create rb_ot
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_codigo
this.Control[iCurrent+2]=this.rb_gen
this.Control[iCurrent+3]=this.rb_maq
this.Control[iCurrent+4]=this.sle_nombre
this.Control[iCurrent+5]=this.cb_3
this.Control[iCurrent+6]=this.pb_1
this.Control[iCurrent+7]=this.rb_ot_adm
this.Control[iCurrent+8]=this.rb_ot
this.Control[iCurrent+9]=this.gb_1
end on

on w_ope749_saldos_reservados.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_codigo)
destroy(this.rb_gen)
destroy(this.rb_maq)
destroy(this.sle_nombre)
destroy(this.cb_3)
destroy(this.pb_1)
destroy(this.rb_ot_adm)
destroy(this.rb_ot)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;sle_codigo.enabled = false
end event

type dw_report from w_report_smpl`dw_report within w_ope749_saldos_reservados
integer x = 50
integer y = 396
integer width = 3145
integer height = 1272
end type

type sle_codigo from singlelineedit within w_ope749_saldos_reservados
integer x = 105
integer y = 212
integer width = 311
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

IF IsNull(ls_codigo) OR ls_codigo='' THEN
	MessageBox('Aviso','Falta ingresar parámetro')
	RETURN
END IF

IF rb_ot_adm.checked = true then
	SELECT count(*)
	  INTO :ll_count
	  FROM ot_administracion 
	 WHERE ot_adm = :ls_codigo ;
	
	IF ll_count=0 THEN
		MessageBox('Aviso','Código ingresado no existe')
		RETURN
	END IF

	SELECT descripcion
	  INTO :ls_nombre
	  FROM ot_administracion 
	 WHERE ot_adm = :ls_codigo ;
	
	sle_nombre.text = ls_nombre
ELSEIF rb_ot.checked = true then
	SELECT count(*)
	  INTO :ll_count
	  FROM orden_trabajo 
	 WHERE nro_orden = :ls_codigo ;
	
	IF ll_count=0 THEN
		MessageBox('Aviso','Código ingresado no existe')
		RETURN
	END IF

	SELECT titulo
	  INTO :ls_nombre
	  FROM orden_trabajo
	 WHERE nro_orden = :ls_codigo ;
	 
	sle_nombre.text = ls_nombre
ELSEIF rb_maq.checked = true then
	SELECT count(*)
	  INTO :ll_count
	  FROM maquina
	 WHERE cod_maquina = :ls_codigo ;
	
	IF ll_count=0 THEN
		MessageBox('Aviso','Código ingresado no existe')
		RETURN
	END IF

	SELECT desc_maq
	  INTO :ls_nombre
	  FROM maquina
	 WHERE cod_maquina = :ls_codigo ;

	sle_nombre.text = ls_nombre
END IF 

end event

type rb_gen from radiobutton within w_ope749_saldos_reservados
integer x = 110
integer y = 96
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
string text = "General"
boolean checked = true
end type

event clicked;sle_codigo.enabled = false
sle_codigo.text = ''
sle_nombre.text = ''

end event

type rb_maq from radiobutton within w_ope749_saldos_reservados
integer x = 1897
integer y = 96
integer width = 352
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
string text = "x Máquina"
end type

event clicked;sle_codigo.enabled = true
end event

type sle_nombre from singlelineedit within w_ope749_saldos_reservados
integer x = 567
integer y = 212
integer width = 1723
integer height = 88
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
borderstyle borderstyle = stylelowered!
end type

type cb_3 from commandbutton within w_ope749_saldos_reservados
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

event clicked;String ls_doc_ot, ls_codigo, ls_nombre, ls_texto

SELECT doc_ot INTO :ls_doc_ot FROM logparam WHERE reckey='1' ;

ls_codigo = TRIM(sle_codigo.text)
ls_nombre = TRIM(sle_nombre.text)

IF rb_gen.checked=false and (ls_codigo='' or isnull(ls_codigo)) THEN
	Messagebox('Aviso','Defina código de busqueda')
	Return
END IF
IF rb_gen.checked=true then
	idw_1.DataObject='d_rpt_saldos_reservados_grd'
	idw_1.SetTransObject(sqlca)
	idw_1.retrieve(ls_doc_ot)
	ls_texto = ''
ELSEIF rb_ot_adm.checked=true then
	idw_1.DataObject='d_rpt_saldos_reservados_ot_adm_grd'
	idw_1.SetTransObject(sqlca)
	idw_1.retrieve(ls_doc_ot, ls_codigo)
	ls_texto = ls_codigo + ', ' + ls_nombre
ELSEIF rb_ot.checked=true then
	idw_1.DataObject='d_rpt_saldos_reservados_ot_grd'
	idw_1.SetTransObject(sqlca)
	idw_1.retrieve(ls_doc_ot, ls_codigo)
	ls_texto = 'OT: ' + ls_codigo + ', ' + ls_nombre
ELSEIF rb_maq.checked=true then
	idw_1.DataObject='d_rpt_saldos_reservados_maq_grd'
	idw_1.SetTransObject(sqlca)
	idw_1.retrieve(ls_doc_ot, ls_codigo)
	ls_texto = ls_codigo + ', ' + ls_nombre
END IF

idw_1.Object.p_logo.filename = gs_logo
idw_1.Object.t_texto.text = ls_texto 
idw_1.Object.p_logo.filename = gs_logo
//SetPointer(Arrow!)

ib_preview = false
idw_1.visible=true
idw_1.ii_zoom_actual = 100
parent.event ue_preview()

end event

type pb_1 from picturebutton within w_ope749_saldos_reservados
integer x = 430
integer y = 204
integer width = 123
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

ls_inactivo = '0'

IF rb_ot_adm.checked = true then
	lstr_seleccionar.s_seleccion = 'S'
	lstr_seleccionar.s_sql = 'SELECT OT_ADMINISTRACION.OT_ADM  AS OT_ADM,'&
									 +'OT_ADMINISTRACION.DESCRIPCION AS DESCRIPCION '&     	
		   						 +'FROM OT_ADMINISTRACION ' 

	OpenWithParm(w_seleccionar,lstr_seleccionar)
	IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
	IF lstr_seleccionar.s_action = "aceptar" THEN
		sle_codigo.text = lstr_seleccionar.param1[1]
		sle_nombre.text = lstr_seleccionar.param2[1]
	END IF
ELSEIF rb_ot.checked = true then
	lstr_seleccionar.s_seleccion = 'S'
	lstr_seleccionar.s_sql = 'SELECT ORDEN_TRABAJO.NRO_ORDEN AS NRO_ORDEN,'&
									 +'ORDEN_TRABAJO.TITULO AS DESCRIPCION '&     	
		   						 +'FROM ORDEN_TRABAJO ' 

	OpenWithParm(w_seleccionar,lstr_seleccionar)
	IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
	IF lstr_seleccionar.s_action = "aceptar" THEN
		sle_codigo.text = lstr_seleccionar.param1[1]
		sle_nombre.text = lstr_seleccionar.param2[1]
	END IF
ELSEIF rb_maq.checked = true then
	lstr_seleccionar.s_seleccion = 'S'
	lstr_seleccionar.s_sql = 'SELECT MAQUINA.COD_MAQUINA AS COD_MAQUINA,'&
									 +'MAQUINA.DESC_MAQ AS DESCRIPCION '&     	
		   						 +'FROM MAQUINA ' &
									 +'WHERE MAQUINA.FLAG_ESTADO <> ' + "'" + ls_inactivo + "'"

	OpenWithParm(w_seleccionar,lstr_seleccionar)
	IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
	IF lstr_seleccionar.s_action = "aceptar" THEN
		sle_codigo.text = lstr_seleccionar.param1[1]
		sle_nombre.text = lstr_seleccionar.param2[1]
	END IF
END IF 


end event

type rb_ot_adm from radiobutton within w_ope749_saldos_reservados
integer x = 576
integer y = 96
integer width = 402
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
string text = "x Ot_adm"
end type

event clicked;sle_codigo.enabled = true
end event

type rb_ot from radiobutton within w_ope749_saldos_reservados
integer x = 1225
integer y = 96
integer width = 448
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "x Ord. Trabajo:"
end type

event clicked;sle_codigo.enabled = true
end event

type gb_1 from groupbox within w_ope749_saldos_reservados
integer x = 50
integer y = 16
integer width = 2277
integer height = 340
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "Parámetros"
end type

