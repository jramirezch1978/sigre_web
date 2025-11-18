$PBExportHeader$w_cm783_articulos_pendientes.srw
forward
global type w_cm783_articulos_pendientes from w_rpt
end type
type pb_1 from picturebutton within w_cm783_articulos_pendientes
end type
type sle_descrip from singlelineedit within w_cm783_articulos_pendientes
end type
type sle_almacen from singlelineedit within w_cm783_articulos_pendientes
end type
type em_descripcion_ot from singlelineedit within w_cm783_articulos_pendientes
end type
type em_ot_adm from singlelineedit within w_cm783_articulos_pendientes
end type
type uo_fecha from u_ingreso_rango_fechas_v within w_cm783_articulos_pendientes
end type
type em_origen from singlelineedit within w_cm783_articulos_pendientes
end type
type em_descripcion from editmask within w_cm783_articulos_pendientes
end type
type dw_report from u_dw_rpt within w_cm783_articulos_pendientes
end type
type gb_2 from groupbox within w_cm783_articulos_pendientes
end type
type gb_1 from groupbox within w_cm783_articulos_pendientes
end type
type gb_3 from groupbox within w_cm783_articulos_pendientes
end type
type gb_4 from groupbox within w_cm783_articulos_pendientes
end type
end forward

global type w_cm783_articulos_pendientes from w_rpt
integer width = 3410
integer height = 2044
string title = "Atención de Requerimientos por Ordenes de Trabajo [CM783]"
string menuname = "m_consulta_impresion"
long backcolor = 67108864
event ue_query_retrieve ( )
pb_1 pb_1
sle_descrip sle_descrip
sle_almacen sle_almacen
em_descripcion_ot em_descripcion_ot
em_ot_adm em_ot_adm
uo_fecha uo_fecha
em_origen em_origen
em_descripcion em_descripcion
dw_report dw_report
gb_2 gb_2
gb_1 gb_1
gb_3 gb_3
gb_4 gb_4
end type
global w_cm783_articulos_pendientes w_cm783_articulos_pendientes

event ue_query_retrieve();// Ancestor Script has been Override

SetPointer(HourGlass!)
this.event Dynamic ue_retrieve()
SetPointer(Arrow!)
end event

on w_cm783_articulos_pendientes.create
int iCurrent
call super::create
if this.MenuName = "m_consulta_impresion" then this.MenuID = create m_consulta_impresion
this.pb_1=create pb_1
this.sle_descrip=create sle_descrip
this.sle_almacen=create sle_almacen
this.em_descripcion_ot=create em_descripcion_ot
this.em_ot_adm=create em_ot_adm
this.uo_fecha=create uo_fecha
this.em_origen=create em_origen
this.em_descripcion=create em_descripcion
this.dw_report=create dw_report
this.gb_2=create gb_2
this.gb_1=create gb_1
this.gb_3=create gb_3
this.gb_4=create gb_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.sle_descrip
this.Control[iCurrent+3]=this.sle_almacen
this.Control[iCurrent+4]=this.em_descripcion_ot
this.Control[iCurrent+5]=this.em_ot_adm
this.Control[iCurrent+6]=this.uo_fecha
this.Control[iCurrent+7]=this.em_origen
this.Control[iCurrent+8]=this.em_descripcion
this.Control[iCurrent+9]=this.dw_report
this.Control[iCurrent+10]=this.gb_2
this.Control[iCurrent+11]=this.gb_1
this.Control[iCurrent+12]=this.gb_3
this.Control[iCurrent+13]=this.gb_4
end on

on w_cm783_articulos_pendientes.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.sle_descrip)
destroy(this.sle_almacen)
destroy(this.em_descripcion_ot)
destroy(this.em_ot_adm)
destroy(this.uo_fecha)
destroy(this.em_origen)
destroy(this.em_descripcion)
destroy(this.dw_report)
destroy(this.gb_2)
destroy(this.gb_1)
destroy(this.gb_3)
destroy(this.gb_4)
end on

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report
idw_1.Visible = False
idw_1.SetTransObject(sqlca)
IF UPPER(gs_lpp) = 'S' THEN THIS.EVENT ue_set_retrieve_as_needed('S')

 ii_help = 101           // help topic
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

event ue_retrieve;call super::ue_retrieve;string 	ls_origen, ls_mensaje, ls_nombre_origen, ls_ot_adm, &
			ls_almacen
integer 	li_ok
date ld_fecha_ini, ld_fecha_fin

this.SetRedraw(false)

ld_fecha_ini 	= date(uo_fecha.of_get_fecha1( ))
ld_fecha_fin 	= date(uo_fecha.of_get_fecha2( ))
ls_origen		= em_origen.text
ls_ot_adm	 	= em_ot_adm.text
ls_almacen		= sle_almacen.text

if ls_ot_adm = '' or IsNull( ls_ot_adm) then
	MessageBox('Producción', 'La OT_ADM no ha sido Definida', StopSign!)
	return
end if

if ls_origen = '' or IsNull( ls_origen) then
	MessageBox('COMEDORES', 'EL ORIGEN NO ESTA DEFINIDO', StopSign!)
	return
end if

if ls_almacen = '' or IsNull( ls_almacen) then
	MessageBox('Producción', 'Almacen no ha sido Definido', StopSign!)
	return
end if

idw_1.Retrieve(ls_ot_adm, ls_almacen, ls_origen, ld_fecha_ini, ld_fecha_fin)
idw_1.Visible = True
idw_1.Object.p_logo.filename 	= gs_logo
idw_1.Object.usuario_t.text  	= gs_user
idw_1.Object.t_fecha1.text  	= string(ld_fecha_ini)
idw_1.Object.t_fecha2.text  	= string(ld_fecha_fin)
idw_1.Object.Datawindow.Print.Orientation = '1'
this.SetRedraw(true)
end event

type pb_1 from picturebutton within w_cm783_articulos_pendientes
integer x = 2702
integer y = 224
integer width = 366
integer height = 180
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "H:\source\BMP\Aceptar_dn.bmp"
alignment htextalign = left!
end type

event clicked;// Ancestor Script has been Override

SetPointer(HourGlass!)
Parent.event Dynamic ue_retrieve()
SetPointer(Arrow!)
end event

type sle_descrip from singlelineedit within w_cm783_articulos_pendientes
integer x = 2199
integer y = 100
integer width = 818
integer height = 68
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
textcase textcase = upper!
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type sle_almacen from singlelineedit within w_cm783_articulos_pendientes
event dobleclick pbm_lbuttondblclk
integer x = 1970
integer y = 100
integer width = 224
integer height = 68
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long textcolor = 33554432
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT almacen AS CODIGO_almacen, " &
	  	 + "DESC_almacen AS DESCRIPCION_almacen " &
	    + "FROM almacen " 
				 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
if ls_codigo <> '' then
	this.text 			= ls_codigo
	sle_descrip.text 	= ls_data
	Parent.event dynamic ue_seleccionar()
end if

end event

event modified;String 	ls_almacen, ls_desc

ls_almacen = sle_almacen.text
if ls_almacen = '' or IsNull(ls_almacen) then
	MessageBox('Aviso', 'Debe Ingresar un codigo de almacen')
	return
end if

SELECT desc_almacen 
	INTO :ls_desc
FROM almacen 
where almacen = :ls_almacen ;

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de Almacen no existe')
	return
end if

sle_descrip.text = ls_desc


end event

type em_descripcion_ot from singlelineedit within w_cm783_articulos_pendientes
integer x = 1061
integer y = 288
integer width = 841
integer height = 72
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 134217739
string text = " "
borderstyle borderstyle = stylelowered!
end type

type em_ot_adm from singlelineedit within w_cm783_articulos_pendientes
event dobleclick pbm_lbuttondblclk
integer x = 832
integer y = 288
integer width = 215
integer height = 68
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long backcolor = 16777215
boolean autohscroll = false
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT O.OT_ADM AS CODIGO, O.DESCRIPCION AS DESCRIPCION " &
			+ "FROM OT_ADMINISTRACION O"
				 
lb_ret = f_lista(ls_sql, ls_codigo, &
			ls_data, '1')
		
if ls_codigo <> '' then
	
this.text= ls_codigo

em_descripcion_ot.text = ls_data

end if
end event

event modified;String ls_almacen, ls_desc

ls_almacen = trim(this.text)
if ls_almacen = '' or IsNull(ls_almacen) then
	MessageBox('Aviso', 'Debe Ingresar una OT_ADM')
	em_descripcion_ot.text = ''
	return
end if

SELECT descripcion INTO :ls_desc
FROM ot_administracion
WHERE ot_adm =:ls_almacen;

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de OT_ADM no existe')
	em_descripcion_ot.text = ''
	return
end if

em_descripcion_ot.text = ls_desc


end event

type uo_fecha from u_ingreso_rango_fechas_v within w_cm783_articulos_pendientes
integer x = 105
integer y = 128
integer taborder = 50
boolean bringtotop = true
end type

event constructor;call super::constructor; of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
 of_set_fecha(today(), today()) //para setear la fecha inicial
 of_set_rango_inicio(date('01/01/1900')) // rango inicial
 of_set_rango_fin(date('31/12/9999')) // rango final
 //of_get_fecha1(), of_get_fecha2()  para leer las fechas
end event

on uo_fecha.destroy
call u_ingreso_rango_fechas_v::destroy
end on

type em_origen from singlelineedit within w_cm783_articulos_pendientes
event dobleclick pbm_lbuttondblclk
integer x = 841
integer y = 108
integer width = 215
integer height = 68
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long backcolor = 16777215
textcase textcase = upper!
integer limit = 2
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT  cod_origen as codigo, " & 
		  +"nombre AS DESCRIPCION " &
		  + "FROM origen " &
		  + "WHERE flag_estado = '1' "
				  
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
	
if ls_codigo <> '' then
	this.text = ls_codigo
	em_descripcion.text = ls_data
end if

end event

event modified;String 	ls_origen, ls_desc

ls_origen = this.text
if ls_origen = '' or IsNull(ls_origen) then
	MessageBox('Aviso', 'Debe Ingresar un codigo de Origen')
	return
end if

SELECT nombre INTO :ls_desc
FROM origen
WHERE cod_origen =:ls_origen;

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de Origen no existe')
	return
end if

em_descripcion.text = ls_desc

end event

type em_descripcion from editmask within w_cm783_articulos_pendientes
integer x = 1061
integer y = 108
integer width = 841
integer height = 72
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 134217739
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type dw_report from u_dw_rpt within w_cm783_articulos_pendientes
integer x = 69
integer y = 420
integer width = 2999
integer height = 1396
string dataobject = "d_rpt_pendiente_retirar_alm_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

type gb_2 from groupbox within w_cm783_articulos_pendientes
integer x = 800
integer y = 40
integer width = 1143
integer height = 164
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = " Seleccione Origen "
end type

type gb_1 from groupbox within w_cm783_articulos_pendientes
integer x = 69
integer y = 40
integer width = 718
integer height = 344
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Rango de Fechas"
end type

type gb_3 from groupbox within w_cm783_articulos_pendientes
integer x = 800
integer y = 216
integer width = 1143
integer height = 164
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "OT. Administración"
end type

type gb_4 from groupbox within w_cm783_articulos_pendientes
integer x = 1952
integer y = 40
integer width = 1111
integer height = 164
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Almacèn"
end type

