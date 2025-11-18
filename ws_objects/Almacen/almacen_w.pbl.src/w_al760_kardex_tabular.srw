$PBExportHeader$w_al760_kardex_tabular.srw
forward
global type w_al760_kardex_tabular from w_rpt
end type
type sle_desc_clase from singlelineedit within w_al760_kardex_tabular
end type
type sle_clase from singlelineedit within w_al760_kardex_tabular
end type
type cbx_almacenes from checkbox within w_al760_kardex_tabular
end type
type cb_1 from commandbutton within w_al760_kardex_tabular
end type
type sle_descrip from singlelineedit within w_al760_kardex_tabular
end type
type sle_almacen from singlelineedit within w_al760_kardex_tabular
end type
type cbx_clases from checkbox within w_al760_kardex_tabular
end type
type uo_fecha from u_ingreso_rango_fechas_v within w_al760_kardex_tabular
end type
type dw_report from u_dw_rpt within w_al760_kardex_tabular
end type
type gb_fechas from groupbox within w_al760_kardex_tabular
end type
type gb_1 from groupbox within w_al760_kardex_tabular
end type
end forward

global type w_al760_kardex_tabular from w_rpt
integer width = 3698
integer height = 1640
string title = "[AL760] Kardex Formato Tabular"
string menuname = "m_impresion"
sle_desc_clase sle_desc_clase
sle_clase sle_clase
cbx_almacenes cbx_almacenes
cb_1 cb_1
sle_descrip sle_descrip
sle_almacen sle_almacen
cbx_clases cbx_clases
uo_fecha uo_fecha
dw_report dw_report
gb_fechas gb_fechas
gb_1 gb_1
end type
global w_al760_kardex_tabular w_al760_kardex_tabular

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

on w_al760_kardex_tabular.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.sle_desc_clase=create sle_desc_clase
this.sle_clase=create sle_clase
this.cbx_almacenes=create cbx_almacenes
this.cb_1=create cb_1
this.sle_descrip=create sle_descrip
this.sle_almacen=create sle_almacen
this.cbx_clases=create cbx_clases
this.uo_fecha=create uo_fecha
this.dw_report=create dw_report
this.gb_fechas=create gb_fechas
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_desc_clase
this.Control[iCurrent+2]=this.sle_clase
this.Control[iCurrent+3]=this.cbx_almacenes
this.Control[iCurrent+4]=this.cb_1
this.Control[iCurrent+5]=this.sle_descrip
this.Control[iCurrent+6]=this.sle_almacen
this.Control[iCurrent+7]=this.cbx_clases
this.Control[iCurrent+8]=this.uo_fecha
this.Control[iCurrent+9]=this.dw_report
this.Control[iCurrent+10]=this.gb_fechas
this.Control[iCurrent+11]=this.gb_1
end on

on w_al760_kardex_tabular.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_desc_clase)
destroy(this.sle_clase)
destroy(this.cbx_almacenes)
destroy(this.cb_1)
destroy(this.sle_descrip)
destroy(this.sle_almacen)
destroy(this.cbx_clases)
destroy(this.uo_fecha)
destroy(this.dw_report)
destroy(this.gb_fechas)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report

idw_1.SetTransObject(sqlca)

ib_preview = true
THIS.Event ue_preview()


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

event ue_retrieve;call super::ue_retrieve;Date 		ld_desde, ld_hasta
string	ls_mensaje, ls_codigo, ls_nom_empresa, ls_almacen, ls_cod_clase


try 
	SetPointer( Hourglass!)
	
	ld_desde = uo_fecha.of_get_fecha1()
	ld_hasta = uo_fecha.of_get_fecha2()
	
	if cbx_almacenes.checked then
		ls_almacen = '%%'
	else
		if trim(sle_almacen.text) = '' then
			MessageBox("Error", "Debe indicar un almacen primero, por favor verifique!")
			sle_almacen.setFocus( )
			return
		end if
		ls_almacen = trim(sle_almacen.text) + '%'
	end if
	
	if cbx_clases.checked then
		ls_Cod_Clase = '%%'
	else
		if trim(sle_clase.text) = '' then
			MessageBox("Error", "Debe indicar primero una CLASE de ARTICULO, por favor verifique!")
			sle_clase.setFocus( )
			return
		end if
		ls_cod_Clase = trim(sle_clase.text) + '%'
	end if
	
	ib_preview = false		
	this.Event ue_preview()		
	
	dw_report.SetTransObject( sqlca)
	dw_report.retrieve(ld_desde, ld_hasta, ls_almacen, ls_cod_clase)	
	dw_report.visible = true
	
	dw_report.object.fec_ini.text 	= STRING(LD_DESDE, "DD/MM/YYYY")
	dw_report.object.fec_fin.text 	= STRING(LD_HASTA, "DD/MM/YYYY")
	dw_report.object.t_user.text 		= gs_user
	dw_report.object.t_ruc.text 		= gnvo_app.empresa.is_ruc
	dw_report.object.t_empresa.text 	= gnvo_app.empresa.is_nom_empresa
	dw_report.object.t_objeto.text 	= this.ClassName()
	
	dw_report.Object.p_logo.filename = gs_logo
	

	
catch ( Exception ex )
	ROLLBACK;
	MessageBox('Exception Error', "Ha ocurrido un error: " + ex.getMessage())
finally
	SetPointer( Arrow!)
end try


end event

type sle_desc_clase from singlelineedit within w_al760_kardex_tabular
integer x = 1609
integer y = 168
integer width = 1211
integer height = 88
integer taborder = 60
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

type sle_clase from singlelineedit within w_al760_kardex_tabular
event dobleclick pbm_lbuttondblclk
integer x = 1381
integer y = 168
integer width = 224
integer height = 88
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long textcolor = 33554432
boolean enabled = false
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "select a.cod_clase as codigo_clase, " &
		 + "a.desc_clase as descripcion_clase " &
		 + "from articulo_clase a " &
		 + "where a.flag_estado = '1'"
				 
if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, '1') then
	this.text 			= ls_codigo
	sle_desc_clase.text 	= ls_data
end if

end event

event modified;String 	ls_cod_clase, ls_desc

ls_cod_clase = this.text

if ls_cod_clase = '' or IsNull(ls_cod_clase) then
	MessageBox('Aviso', 'Debe Ingresar un codigo de CLASE', StopSign!)
	return
end if

SELECT desc_clase 
	INTO :ls_desc
FROM articulo_clase
where cod_clase = :ls_cod_clase 
  and flag_estado = '1';

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de CLASE no existe o no se encuentra activo', StopSign!)
	return
end if

sle_desc_clase.text = ls_desc

end event

type cbx_almacenes from checkbox within w_al760_kardex_tabular
integer x = 736
integer y = 80
integer width = 640
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Todos los almacenes"
boolean checked = true
end type

event clicked;if this.checked then
	sle_almacen.enabled = false
else
	sle_almacen.enabled = true
end if
end event

type cb_1 from commandbutton within w_al760_kardex_tabular
integer x = 3177
integer y = 56
integer width = 366
integer height = 176
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Reporte"
end type

event clicked;setPointer(Hourglass!)
parent.event ue_retrieve( )
setPointer(Arrow!)
end event

type sle_descrip from singlelineedit within w_al760_kardex_tabular
integer x = 1609
integer y = 76
integer width = 1211
integer height = 88
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

type sle_almacen from singlelineedit within w_al760_kardex_tabular
event dobleclick pbm_lbuttondblclk
integer x = 1381
integer y = 76
integer width = 224
integer height = 88
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
boolean enabled = false
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT almacen AS CODIGO_almacen, " &
	  	 + "DESC_almacen AS DESCRIPCION_almacen " &
	    + "FROM almacen " &
		 + "where flag_tipo_almacen <> 'O'"
				 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
if ls_codigo <> '' then
	this.text 			= ls_codigo
	sle_descrip.text 	= ls_data

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
where almacen = :ls_almacen 
  and flag_tipo_almacen <> 'O';

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de Almacen no existe o es un almacén de tránsito')
	return
end if

sle_descrip.text = ls_desc

end event

type cbx_clases from checkbox within w_al760_kardex_tabular
integer x = 736
integer y = 172
integer width = 640
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Todas las clases"
boolean checked = true
end type

event clicked;if this.checked then
	sle_clase.enabled = false
else
	sle_clase.enabled = true
end if
end event

type uo_fecha from u_ingreso_rango_fechas_v within w_al760_kardex_tabular
event destroy ( )
integer x = 27
integer y = 60
integer taborder = 20
boolean bringtotop = true
long backcolor = 67108864
end type

on uo_fecha.destroy
call u_ingreso_rango_fechas_v::destroy
end on

event constructor;call super::constructor;String ls_desde
 
 of_set_label('Del:','Al:') 								//	para setear la fecha inicial
 
 ls_desde = '01/' + string(month(today()))+'/' + string(year(today()))
 of_set_fecha(date(ls_desde), today()) 				// para seatear el titulo del boton
 of_set_rango_inicio(date('01/01/0001')) 				// rango inicial
 of_set_rango_fin(date('31/12/9999'))					// rango final

// of_get_fecha1(), of_get_fecha2()  para leer las fechas

end event

type dw_report from u_dw_rpt within w_al760_kardex_tabular
integer y = 296
integer width = 3593
integer height = 1096
string dataobject = "d_rpt_kardex_tabular_tbl"
end type

type gb_fechas from groupbox within w_al760_kardex_tabular
integer width = 695
integer height = 288
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Rango de Fechas"
end type

type gb_1 from groupbox within w_al760_kardex_tabular
integer x = 704
integer width = 2217
integer height = 288
integer taborder = 40
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Filtro de Busqueda"
end type

