$PBExportHeader$w_ope712_operaciones_no_program.srw
forward
global type w_ope712_operaciones_no_program from w_rpt
end type
type pb_2 from picturebutton within w_ope712_operaciones_no_program
end type
type sle_nombre from singlelineedit within w_ope712_operaciones_no_program
end type
type sle_codigo from singlelineedit within w_ope712_operaciones_no_program
end type
type pb_1 from picturebutton within w_ope712_operaciones_no_program
end type
type sle_ot_adm from singlelineedit within w_ope712_operaciones_no_program
end type
type st_1 from statictext within w_ope712_operaciones_no_program
end type
type rb_ej from radiobutton within w_ope712_operaciones_no_program
end type
type rb_cc from radiobutton within w_ope712_operaciones_no_program
end type
type uo_1 from u_ingreso_rango_fechas within w_ope712_operaciones_no_program
end type
type cb_5 from commandbutton within w_ope712_operaciones_no_program
end type
type dw_report from u_dw_rpt within w_ope712_operaciones_no_program
end type
type gb_1 from groupbox within w_ope712_operaciones_no_program
end type
end forward

global type w_ope712_operaciones_no_program from w_rpt
integer width = 3342
integer height = 2300
string title = "Operaciones no programadas x OT (OP712)"
string menuname = "m_rpt_smpl"
long backcolor = 134217738
pb_2 pb_2
sle_nombre sle_nombre
sle_codigo sle_codigo
pb_1 pb_1
sle_ot_adm sle_ot_adm
st_1 st_1
rb_ej rb_ej
rb_cc rb_cc
uo_1 uo_1
cb_5 cb_5
dw_report dw_report
gb_1 gb_1
end type
global w_ope712_operaciones_no_program w_ope712_operaciones_no_program

on w_ope712_operaciones_no_program.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_smpl" then this.MenuID = create m_rpt_smpl
this.pb_2=create pb_2
this.sle_nombre=create sle_nombre
this.sle_codigo=create sle_codigo
this.pb_1=create pb_1
this.sle_ot_adm=create sle_ot_adm
this.st_1=create st_1
this.rb_ej=create rb_ej
this.rb_cc=create rb_cc
this.uo_1=create uo_1
this.cb_5=create cb_5
this.dw_report=create dw_report
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_2
this.Control[iCurrent+2]=this.sle_nombre
this.Control[iCurrent+3]=this.sle_codigo
this.Control[iCurrent+4]=this.pb_1
this.Control[iCurrent+5]=this.sle_ot_adm
this.Control[iCurrent+6]=this.st_1
this.Control[iCurrent+7]=this.rb_ej
this.Control[iCurrent+8]=this.rb_cc
this.Control[iCurrent+9]=this.uo_1
this.Control[iCurrent+10]=this.cb_5
this.Control[iCurrent+11]=this.dw_report
this.Control[iCurrent+12]=this.gb_1
end on

on w_ope712_operaciones_no_program.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_2)
destroy(this.sle_nombre)
destroy(this.sle_codigo)
destroy(this.pb_1)
destroy(this.sle_ot_adm)
destroy(this.st_1)
destroy(this.rb_ej)
destroy(this.rb_cc)
destroy(this.uo_1)
destroy(this.cb_5)
destroy(this.dw_report)
destroy(this.gb_1)
end on

event ue_open_pre();call super::ue_open_pre;idw_1 = dw_report
//idw_1.Visible = False
idw_1.SetTransObject(sqlca)

//THIS.Event ue_preview()
//This.Event ue_retrieve()
end event

event ue_preview;call super::ue_preview;IF ib_preview THEN
	idw_1.Modify("DataWindow.Print.Preview=No")
	idw_1.Modify("datawindow.print.preview.zoom = " + String(idw_1.ii_zoom_actual))
	idw_1.title = "Reporte " + " (Zoom: " + String(idw_1.ii_zoom_actual) + "%)"
	SetPointer(hourglass!)
	ib_preview = FALSE
ELSE
	idw_1.Modify("DataWindow.Print.Preview=Yes")
	idw_1.Modify("datawindow.print.preview.zoom = " + String(idw_1.ii_zoom_actual))
	idw_1.title = "Reporte " + " (Zoom: " + String(idw_1.ii_zoom_actual) + "%)"
	SetPointer(hourglass!)
	ib_preview = TRUE
END IF
end event

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

event ue_print;call super::ue_print;idw_1.EVENT ue_print()
end event

type pb_2 from picturebutton within w_ope712_operaciones_no_program
integer x = 1243
integer y = 144
integer width = 114
integer height = 104
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "H:\source\Bmp\file_open.bmp"
alignment htextalign = left!
end type

event clicked;Datawindow ldw
str_seleccionar lstr_seleccionar

IF rb_cc.checked=false and rb_ej.checked=false THEN
	messagebox('Aviso','Seleccione opción')
	//return
END IF

IF rb_cc.checked=true and rb_ej.checked=true THEN
	messagebox('Aviso','Seleccione solo una opción')
	//return
END IF

IF rb_cc.checked=true then
	lstr_seleccionar.s_seleccion = 'S'
	lstr_seleccionar.s_sql = 'SELECT CENTROS_COSTO.CENCOS 	  AS CENCOS,'&
											 +'CENTROS_COSTO.DESC_CENCOS AS DESCRIPCION '&     	
		 		   						 +'FROM CENTROS_COSTO '
   IF lstr_seleccionar.s_seleccion = 'S' THEN
		OpenWithParm(w_seleccionar,lstr_seleccionar)	
		IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm	
		IF lstr_seleccionar.s_action = "aceptar" THEN
			sle_codigo.text = lstr_seleccionar.param1[1]
			sle_nombre.text = lstr_seleccionar.param2[1]
		END IF
	END IF
ELSE											  
	lstr_seleccionar.s_seleccion = 'S'
	lstr_seleccionar.s_sql = 'SELECT EJECUTOR.COD_EJECUTOR AS COD_EJECUTOR, '&
											 +'EJECUTOR.DESCRIPCION AS DESCRIPCION '&     	
		 		   						 +'FROM EJECUTOR '
   IF lstr_seleccionar.s_seleccion = 'S' THEN
		OpenWithParm(w_seleccionar,lstr_seleccionar)	
		IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm	
		IF lstr_seleccionar.s_action = "aceptar" THEN
			sle_codigo.text = lstr_seleccionar.param1[1]
			sle_nombre.text = lstr_seleccionar.param2[1]
		END IF
	END IF
	
END IF

end event

type sle_nombre from singlelineedit within w_ope712_operaciones_no_program
integer x = 1390
integer y = 148
integer width = 1275
integer height = 92
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type sle_codigo from singlelineedit within w_ope712_operaciones_no_program
integer x = 878
integer y = 148
integer width = 343
integer height = 92
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event modified;Long ll_count
String ls_codigo, ls_nombre

IF rb_cc.checked=false and rb_ej.checked=false THEN
	messagebox('Aviso','Seleccione correctamente opción')
	sle_codigo.text = ''
	return
END IF

IF rb_cc.checked=true and rb_ej.checked=true THEN
	messagebox('Aviso','Seleccione correctamente opción')
	sle_codigo.text = ''
	return
END IF

ls_codigo = sle_codigo.text

IF rb_cc.checked=true then
	
	SELECT count(*)
     INTO :ll_count
	  FROM centros_costo
	 WHERE cencos = :ls_codigo ;

	IF ll_count > 0 THEN
		SELECT desc_cencos
		  INTO :ls_nombre
		  FROM centros_costo
		 WHERE cencos = :ls_codigo ;
		
		sle_nombre.text = ls_nombre
	END IF
ELSE											  
	SELECT count(*)
	  INTO :ll_count
	  FROM ejecutor
	 WHERE cod_ejecutor = :ls_codigo ;

	IF ll_count > 0 THEN
		SELECT descripcion
		  INTO :ls_nombre
		  FROM ejecutor
		 WHERE cod_ejecutor = :ls_codigo ;
		
		sle_nombre.text = ls_nombre
	END IF
END IF

end event

type pb_1 from picturebutton within w_ope712_operaciones_no_program
integer x = 2551
integer y = 288
integer width = 114
integer height = 104
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "H:\source\Bmp\file_open.bmp"
alignment htextalign = left!
end type

event clicked;Datawindow ldw
str_seleccionar lstr_seleccionar

lstr_seleccionar.s_seleccion = 'S'
lstr_seleccionar.s_sql = 'SELECT OT_ADMINISTRACION.OT_ADM  AS OT_ADM,'&
										 +'OT_ADMINISTRACION.DESCRIPCION AS DESCRIPCION '&     	
	 		   						 +'FROM OT_ADMINISTRACION '
IF lstr_seleccionar.s_seleccion = 'S' THEN
	OpenWithParm(w_seleccionar,lstr_seleccionar)	
	IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm	
	IF lstr_seleccionar.s_action = "aceptar" THEN
		sle_ot_adm.text = lstr_seleccionar.param1[1]
	END IF
END IF

end event

type sle_ot_adm from singlelineedit within w_ope712_operaciones_no_program
integer x = 2185
integer y = 288
integer width = 343
integer height = 92
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_ope712_operaciones_no_program
integer x = 1906
integer y = 300
integer width = 247
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "OT ADM :"
boolean focusrectangle = false
end type

type rb_ej from radiobutton within w_ope712_operaciones_no_program
integer x = 82
integer y = 188
integer width = 750
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "x ejecutor"
end type

type rb_cc from radiobutton within w_ope712_operaciones_no_program
integer x = 78
integer y = 96
integer width = 750
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "x centro costo responsable"
end type

type uo_1 from u_ingreso_rango_fechas within w_ope712_operaciones_no_program
integer x = 87
integer y = 288
integer taborder = 20
end type

event constructor;call super::constructor;of_set_label('Desde:','Hasta:') //para setear la fecha inicial
//of_set_fecha(date('01/01/1900'), date('31/12/9999') // para seatear el titulo del boton
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final


end event

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

type cb_5 from commandbutton within w_ope712_operaciones_no_program
integer x = 2830
integer y = 212
integer width = 402
integer height = 112
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Procesar"
end type

event clicked;Long   ll_count
String ls_codigo, ls_ot_adm, ls_texto
Date ld_fec_ini, ld_fec_fin

//verificación de fechas
ld_fec_ini = uo_1.of_get_fecha1()
ld_fec_fin = uo_1.of_get_fecha2()

IF Isnull(ld_fec_ini) OR Isnull(ld_fec_fin) THEN
	Messagebox('Aviso','Debe ingresar rango de fechas')	
	RETURN
ELSE
	ls_texto = 'Del ' + string(ld_fec_ini, 'dd/mm/yyyy') + ' al ' + string(ld_fec_fin, 'dd/mm/yyyy')
END IF	

IF ( sle_codigo.text = '') OR ISNULL(sle_codigo.text) THEN 
	RETURN
ELSE
	ls_codigo = sle_codigo.text
END IF

IF ( sle_ot_adm.text = '') OR ISNULL(sle_ot_adm.text) THEN 
	RETURN
ELSE
	ls_ot_adm = sle_ot_adm.text
END IF


//POR CENTRO DE COSTO RESPONSABLE
IF rb_cc.checked then
	idw_1.dataobject = 'd_rpt_opersec_no_program_cc_tbl'
ELSE
	idw_1.dataobject = 'd_rpt_opersec_no_program_ej_tbl'
END IF

idw_1.SettransObject(sqlca)


idw_1.object.p_logo.filename = gs_logo
idw_1.object.t_texto.text = ls_texto
idw_1.object.t_user.text = gs_user
idw_1.object.t_empresa.text = gs_empresa

ib_preview = FALSE
idw_1.ii_zoom_actual = 100
Parent.Event ue_preview()

idw_1.Retrieve( ls_ot_adm, ls_codigo, ld_fec_ini, ld_fec_fin)

end event

type dw_report from u_dw_rpt within w_ope712_operaciones_no_program
integer x = 27
integer y = 500
integer width = 3250
integer height = 1608
string dataobject = "d_rpt_opersec_no_program_cc_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

type gb_1 from groupbox within w_ope712_operaciones_no_program
integer x = 27
integer y = 20
integer width = 2688
integer height = 408
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "Parámetros"
end type

