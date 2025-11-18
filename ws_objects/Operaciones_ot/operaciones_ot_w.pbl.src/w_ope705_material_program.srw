$PBExportHeader$w_ope705_material_program.srw
forward
global type w_ope705_material_program from w_report_smpl
end type
type sle_codigo from singlelineedit within w_ope705_material_program
end type
type rb_cc from radiobutton within w_ope705_material_program
end type
type rb_ej from radiobutton within w_ope705_material_program
end type
type sle_nombre from singlelineedit within w_ope705_material_program
end type
type uo_1 from u_ingreso_rango_fechas within w_ope705_material_program
end type
type cb_3 from commandbutton within w_ope705_material_program
end type
type pb_1 from picturebutton within w_ope705_material_program
end type
type gb_1 from groupbox within w_ope705_material_program
end type
end forward

global type w_ope705_material_program from w_report_smpl
integer width = 3269
integer height = 1356
string title = "Materiales programados (ope705)"
string menuname = "m_rpt_smpl"
long backcolor = 12632256
sle_codigo sle_codigo
rb_cc rb_cc
rb_ej rb_ej
sle_nombre sle_nombre
uo_1 uo_1
cb_3 cb_3
pb_1 pb_1
gb_1 gb_1
end type
global w_ope705_material_program w_ope705_material_program

on w_ope705_material_program.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_smpl" then this.MenuID = create m_rpt_smpl
this.sle_codigo=create sle_codigo
this.rb_cc=create rb_cc
this.rb_ej=create rb_ej
this.sle_nombre=create sle_nombre
this.uo_1=create uo_1
this.cb_3=create cb_3
this.pb_1=create pb_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_codigo
this.Control[iCurrent+2]=this.rb_cc
this.Control[iCurrent+3]=this.rb_ej
this.Control[iCurrent+4]=this.sle_nombre
this.Control[iCurrent+5]=this.uo_1
this.Control[iCurrent+6]=this.cb_3
this.Control[iCurrent+7]=this.pb_1
this.Control[iCurrent+8]=this.gb_1
end on

on w_ope705_material_program.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_codigo)
destroy(this.rb_cc)
destroy(this.rb_ej)
destroy(this.sle_nombre)
destroy(this.uo_1)
destroy(this.cb_3)
destroy(this.pb_1)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;sle_codigo.enabled = false
end event

type dw_report from w_report_smpl`dw_report within w_ope705_material_program
integer x = 50
integer y = 428
integer width = 3145
integer height = 784
end type

type sle_codigo from singlelineedit within w_ope705_material_program
integer x = 613
integer y = 100
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
	
	sle_nombre.text = ls_nombre
END IF 

end event

type rb_cc from radiobutton within w_ope705_material_program
integer x = 105
integer y = 104
integer width = 439
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
string text = "C.Costo Rsp."
end type

event clicked;sle_codigo.enabled = true
end event

type rb_ej from radiobutton within w_ope705_material_program
integer x = 105
integer y = 212
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
string text = "General"
end type

event clicked;sle_codigo.text = ''
sle_nombre.text = ''
sle_codigo.enabled = false
end event

type sle_nombre from singlelineedit within w_ope705_material_program
integer x = 1102
integer y = 100
integer width = 1166
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

type uo_1 from u_ingreso_rango_fechas within w_ope705_material_program
integer x = 617
integer y = 224
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

type cb_3 from commandbutton within w_ope705_material_program
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

event clicked;String ls_codigo
Date ld_fec_ini, ld_fec_fin

ls_codigo = TRIM(sle_codigo.text)
ld_fec_ini = uo_1.of_get_fecha1()
ld_fec_fin = uo_1.of_get_fecha2()

IF rb_cc.checked=true then
	idw_1.DataObject='d_rpt_artic_program_x_cc_rsp_tbl'
	idw_1.SetTransObject(sqlca)
	idw_1.retrieve(ls_codigo, ld_fec_ini, ld_fec_fin)
ELSEIF rb_ej.checked=true then
	idw_1.DataObject='d_rpt_artic_program_tbl'
	idw_1.SetTransObject(sqlca)
	idw_1.retrieve(ld_fec_ini, ld_fec_fin)
END IF

idw_1.Object.p_logo.filename = gs_logo
idw_1.Object.t_texto.text = 'Del ' + string(ld_fec_ini, 'dd/mm/yyyy') + ' al ' + string(ld_fec_fin, 'dd/mm/yyyy')
idw_1.Object.p_logo.filename = gs_logo
//SetPointer(Arrow!)
//idw_1.Retrieve(ls_codigo, ld_fec_ini, ld_fec_fin)

ib_preview = false
idw_1.visible=true
idw_1.ii_zoom_actual = 100
parent.event ue_preview()

//cb_generar.enabled = true
end event

type pb_1 from picturebutton within w_ope705_material_program
integer x = 946
integer y = 100
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

IF ( rb_cc.checked = false and rb_ej.checked=false ) THEN
	MessageBox('Aviso', 'Defina opción a consultar')
	return 0
END IF

IF rb_ej.checked = true then
	MessageBox('Aviso', 'Opción errada')
	return 0
END IF


IF rb_cc.checked = true then
	ls_inactivo = '0'
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


end event

type gb_1 from groupbox within w_ope705_material_program
integer x = 50
integer y = 16
integer width = 2277
integer height = 332
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

