$PBExportHeader$w_ope766_atencion_materiales.srw
forward
global type w_ope766_atencion_materiales from w_rpt
end type
type cb_2 from commandbutton within w_ope766_atencion_materiales
end type
type st_busqueda from statictext within w_ope766_atencion_materiales
end type
type sle_dato from singlelineedit within w_ope766_atencion_materiales
end type
type cb_1 from commandbutton within w_ope766_atencion_materiales
end type
type uo_1 from u_ingreso_rango_fechas within w_ope766_atencion_materiales
end type
type rb_4 from radiobutton within w_ope766_atencion_materiales
end type
type rb_3 from radiobutton within w_ope766_atencion_materiales
end type
type rb_2 from radiobutton within w_ope766_atencion_materiales
end type
type rb_1 from radiobutton within w_ope766_atencion_materiales
end type
type dw_report from u_dw_rpt within w_ope766_atencion_materiales
end type
type gb_1 from groupbox within w_ope766_atencion_materiales
end type
end forward

global type w_ope766_atencion_materiales from w_rpt
integer width = 3287
integer height = 1748
string title = "Atencion de MATERIALES (OPE766)"
string menuname = "m_rpt_smpl"
cb_2 cb_2
st_busqueda st_busqueda
sle_dato sle_dato
cb_1 cb_1
uo_1 uo_1
rb_4 rb_4
rb_3 rb_3
rb_2 rb_2
rb_1 rb_1
dw_report dw_report
gb_1 gb_1
end type
global w_ope766_atencion_materiales w_ope766_atencion_materiales

on w_ope766_atencion_materiales.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_smpl" then this.MenuID = create m_rpt_smpl
this.cb_2=create cb_2
this.st_busqueda=create st_busqueda
this.sle_dato=create sle_dato
this.cb_1=create cb_1
this.uo_1=create uo_1
this.rb_4=create rb_4
this.rb_3=create rb_3
this.rb_2=create rb_2
this.rb_1=create rb_1
this.dw_report=create dw_report
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_2
this.Control[iCurrent+2]=this.st_busqueda
this.Control[iCurrent+3]=this.sle_dato
this.Control[iCurrent+4]=this.cb_1
this.Control[iCurrent+5]=this.uo_1
this.Control[iCurrent+6]=this.rb_4
this.Control[iCurrent+7]=this.rb_3
this.Control[iCurrent+8]=this.rb_2
this.Control[iCurrent+9]=this.rb_1
this.Control[iCurrent+10]=this.dw_report
this.Control[iCurrent+11]=this.gb_1
end on

on w_ope766_atencion_materiales.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_2)
destroy(this.st_busqueda)
destroy(this.sle_dato)
destroy(this.cb_1)
destroy(this.uo_1)
destroy(this.rb_4)
destroy(this.rb_3)
destroy(this.rb_2)
destroy(this.rb_1)
destroy(this.dw_report)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report
ib_preview = false
THIS.Event ue_preview()
idw_1.SetTransObject(sqlca)

st_busqueda.text = 'Por O.Trabajo  :'
sle_dato.limit   = 10
sle_dato.text	  = ''
end event

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
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

event ue_print;call super::ue_print;idw_1.EVENT ue_print()
end event

type cb_2 from commandbutton within w_ope766_atencion_materiales
integer x = 2240
integer y = 76
integer width = 110
integer height = 80
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;str_seleccionar lstr_seleccionar



//busqueda segun seleccion
if rb_1.checked then // x ORDEN_TRABAJO
	lstr_seleccionar.s_seleccion = 'S'
	lstr_seleccionar.s_sql = 'SELECT ORDEN_TRABAJO.NRO_ORDEN AS NRO_OT, '&   
									    +'ORDEN_TRABAJO.COD_ORIGEN AS ORIGEN, '&   
										 +'ORDEN_TRABAJO.OT_ADM AS ADMINISTRACION '&   
										 +'FROM ORDEN_TRABAJO '&
										 

	OpenWithParm(w_seleccionar,lstr_seleccionar)
			
	IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
	IF lstr_seleccionar.s_action = "aceptar" THEN
		sle_dato.text = lstr_seleccionar.param1[1]
	END IF
	
elseif rb_2.checked then //x adminisracion
	lstr_seleccionar.s_seleccion = 'S'
	lstr_seleccionar.s_sql = 'SELECT OT_ADMINISTRACION.OT_ADM AS ADMINISTRACION, '&   
									    +'OT_ADMINISTRACION.DESCRIPCION AS DESCRIPCION '&   
										 +'FROM OT_ADMINISTRACION '&
										 

	OpenWithParm(w_seleccionar,lstr_seleccionar)
			
	IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
	IF lstr_seleccionar.s_action = "aceptar" THEN
		sle_dato.text = lstr_seleccionar.param1[1]
	END IF
	
elseif rb_3.checked then  // x almacen
	lstr_seleccionar.s_seleccion = 'S'
	lstr_seleccionar.s_sql = 'SELECT ALMACEN.ALMACEN AS COD_ALMACEN, '&   
									    +'ALMACEN.DESC_ALMACEN AS DESCRIPCION, '&   
										 +'ALMACEN.COD_ORIGEN AS ORIGEN '&   
										 +'FROM ALMACEN '&
										 

	OpenWithParm(w_seleccionar,lstr_seleccionar)
			
	IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
	IF lstr_seleccionar.s_action = "aceptar" THEN
		sle_dato.text = lstr_seleccionar.param1[1]
	END IF
	
elseif rb_4.checked then	//articulo
	lstr_seleccionar.s_seleccion = 'S'
	lstr_seleccionar.s_sql = 'SELECT ARTICULO.COD_ART AS CODIGO, '&   
									    +'ARTICULO.DESC_ART AS DESCRIPCION, '&   
										 +'ARTICULO.UND AS UNIDAD '&   
										 +'FROM  ARTICULO '&
										 +'WHERE ARTICULO.FLAG_ESTADO = '+"'"+'1'+"'"

	OpenWithParm(w_seleccionar,lstr_seleccionar)
			
	IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
	IF lstr_seleccionar.s_action = "aceptar" THEN
		sle_dato.text = lstr_seleccionar.param1[1]
	END IF
end if
end event

type st_busqueda from statictext within w_ope766_atencion_materiales
integer x = 887
integer y = 84
integer width = 544
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Por ............................ :"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_dato from singlelineedit within w_ope766_atencion_materiales
integer x = 1449
integer y = 68
integer width = 768
integer height = 84
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

type cb_1 from commandbutton within w_ope766_atencion_materiales
integer x = 2775
integer y = 24
integer width = 421
integer height = 120
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Procesar"
end type

event clicked;String ls_dato,ls_nro_orden,ls_ot_adm,ls_almacen,ls_titulo,ls_articulo
Date   ld_fecha_inicio,ld_fecha_final




ls_dato = sle_dato.text

ld_fecha_inicio = uo_1.of_get_fecha1()
ld_fecha_final  = uo_1.of_get_fecha2()


if rb_1.checked then
	ls_nro_orden = ls_dato
	ls_ot_adm 	 = '%'
	ls_almacen	 = '%'
	ls_articulo	 = '%'
	ls_titulo 	 = 'Orden de Trabajo : ' + ls_dato
elseif rb_2.checked then	
	ls_nro_orden = '%'
	ls_ot_adm 	 = ls_dato
	ls_almacen	 = '%'
	ls_articulo	 = '%'	
	ls_titulo 	 = 'Administración : ' + ls_dato
elseif rb_3.checked then	
	ls_nro_orden = '%'
	ls_ot_adm 	 = '%'
	ls_almacen	 = ls_dato
	ls_articulo	 = '%'
	ls_titulo 	 = 'Almacen : ' + ls_dato
elseif rb_4.checked then	
	ls_nro_orden = '%'
	ls_ot_adm 	 = '%'
	ls_almacen	 = '%'
	ls_articulo	 = ls_dato
	ls_titulo 	 = 'Articulo : ' + ls_dato
	
end if	





dw_report.retrieve(ls_nro_orden,ls_ot_adm,ls_almacen,ls_articulo,ls_titulo,ld_fecha_inicio,ld_fecha_final)
dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_nombre.text = gs_empresa
dw_report.object.t_user.text = gs_user

end event

type uo_1 from u_ingreso_rango_fechas within w_ope766_atencion_materiales
integer x = 896
integer y = 220
integer taborder = 20
end type

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
of_set_fecha(date('01/01/1900'), date('31/12/9999')) //para setear la fecha inicial
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final


end event

type rb_4 from radiobutton within w_ope766_atencion_materiales
integer x = 128
integer y = 320
integer width = 594
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Articulo"
end type

event clicked;if rb_4.checked then
	st_busqueda.text = 'Por Articulo        :'
	sle_dato.limit   = 12
	sle_dato.text	  = ''	
else
	st_busqueda.text = 'Por ................:'
	sle_dato.limit   = 0
	sle_dato.text	  = ''	
end if
end event

type rb_3 from radiobutton within w_ope766_atencion_materiales
integer x = 128
integer y = 248
integer width = 594
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Almacen"
end type

event clicked;if rb_3.checked then
	st_busqueda.text = 'Por Almacen         :'
	sle_dato.limit   = 6
	sle_dato.text	  = ''	
else
	st_busqueda.text = 'Por ................:'
	sle_dato.limit   = 0
	sle_dato.text	  = ''	
end if
end event

type rb_2 from radiobutton within w_ope766_atencion_materiales
integer x = 128
integer y = 168
integer width = 594
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Administración de OT"
end type

event clicked;if rb_2.checked then
	st_busqueda.text = 'Por Administracion  :'
	sle_dato.limit   = 10
	sle_dato.text	  = ''
else
	st_busqueda.text = 'Por ................:'
	sle_dato.limit   = 0
	sle_dato.text	  = ''	
end if
end event

type rb_1 from radiobutton within w_ope766_atencion_materiales
integer x = 128
integer y = 92
integer width = 594
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Orden de Trabajo"
boolean checked = true
end type

event clicked;if rb_1.checked then
	st_busqueda.text = 'Por O.Trabajo  :'
	sle_dato.limit   = 10
	sle_dato.text	  = ''
else
	st_busqueda.text = 'Por ...........:'
	sle_dato.limit   = 0
	sle_dato.text	  = ''
end if
end event

type dw_report from u_dw_rpt within w_ope766_atencion_materiales
integer x = 46
integer y = 460
integer width = 3159
integer height = 1068
string dataobject = "d_rpt_atencion_mat_x_articulo_tbl"
end type

type gb_1 from groupbox within w_ope766_atencion_materiales
integer x = 78
integer y = 24
integer width = 750
integer height = 392
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Datos"
end type

