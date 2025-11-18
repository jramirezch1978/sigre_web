$PBExportHeader$w_cm784_abc_proveedores.srw
forward
global type w_cm784_abc_proveedores from w_report_smpl
end type
type uo_fecha from u_ingreso_rango_fechas within w_cm784_abc_proveedores
end type
type cb_3 from commandbutton within w_cm784_abc_proveedores
end type
type rb_oc from radiobutton within w_cm784_abc_proveedores
end type
type rb_os from radiobutton within w_cm784_abc_proveedores
end type
type rb_resumen from radiobutton within w_cm784_abc_proveedores
end type
type rb_proveedor from radiobutton within w_cm784_abc_proveedores
end type
type rb_documento from radiobutton within w_cm784_abc_proveedores
end type
type cbx_1 from checkbox within w_cm784_abc_proveedores
end type
type sle_origen from singlelineedit within w_cm784_abc_proveedores
end type
type gb_1 from groupbox within w_cm784_abc_proveedores
end type
type gb_2 from groupbox within w_cm784_abc_proveedores
end type
end forward

global type w_cm784_abc_proveedores from w_report_smpl
integer width = 3154
integer height = 2808
string title = "Resumen de Compras/Servicios x Proveedor(CM784)"
string menuname = "m_impresion"
uo_fecha uo_fecha
cb_3 cb_3
rb_oc rb_oc
rb_os rb_os
rb_resumen rb_resumen
rb_proveedor rb_proveedor
rb_documento rb_documento
cbx_1 cbx_1
sle_origen sle_origen
gb_1 gb_1
gb_2 gb_2
end type
global w_cm784_abc_proveedores w_cm784_abc_proveedores

type variables

end variables

on w_cm784_abc_proveedores.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.uo_fecha=create uo_fecha
this.cb_3=create cb_3
this.rb_oc=create rb_oc
this.rb_os=create rb_os
this.rb_resumen=create rb_resumen
this.rb_proveedor=create rb_proveedor
this.rb_documento=create rb_documento
this.cbx_1=create cbx_1
this.sle_origen=create sle_origen
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_fecha
this.Control[iCurrent+2]=this.cb_3
this.Control[iCurrent+3]=this.rb_oc
this.Control[iCurrent+4]=this.rb_os
this.Control[iCurrent+5]=this.rb_resumen
this.Control[iCurrent+6]=this.rb_proveedor
this.Control[iCurrent+7]=this.rb_documento
this.Control[iCurrent+8]=this.cbx_1
this.Control[iCurrent+9]=this.sle_origen
this.Control[iCurrent+10]=this.gb_1
this.Control[iCurrent+11]=this.gb_2
end on

on w_cm784_abc_proveedores.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_fecha)
destroy(this.cb_3)
destroy(this.rb_oc)
destroy(this.rb_os)
destroy(this.rb_resumen)
destroy(this.rb_proveedor)
destroy(this.rb_documento)
destroy(this.cbx_1)
destroy(this.sle_origen)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event ue_retrieve;call super::ue_retrieve;String  	ls_origen
Date 		ld_desde, ld_hasta

ld_desde = uo_fecha.of_get_fecha1()
ld_hasta = uo_fecha.of_get_fecha2()

if cbx_1.checked = false then
	ls_origen = '%%'
else
	ls_origen = trim(sle_origen.text) + '%'
end if

if rb_oc.checked then
	idw_1.dataobject = 'd_rpt_abc_compras_prov_x_oc_tbl'
else
	idw_1.dataobject = 'd_rpt_abc_compras_prov_x_os_tbl'
end if

idw_1.SetTransobject( SQLCA )
this.event ue_preview()
idw_1.Object.DataWindow.Print.Orientation = 2
idw_1.GroupCalc()
idw_1.ii_zoom_actual = 100
idw_1.modify('datawindow.print.preview.zoom = ' + String(idw_1.ii_zoom_actual))

idw_1.Retrieve(ld_desde, ld_hasta, ls_origen)

idw_1.object.titulo_1.text 	= 'Del : ' & 
		+ STRING(ld_desde, "DD/MM/YYYY") + ' Al : ' &
		+ STRING(ld_hasta, "DD/MM/YYYY")		
if rb_oc.checked then
	idw_1.object.titulo_2.text 	= 'Ordenes de Compras '		
else
	idw_1.object.titulo_2.text 	= 'Ordenes de Servicio'		
end if

idw_1.object.t_user.text 	  = gs_user
idw_1.Object.p_logo.filename = gs_logo


end event

event ue_preview;call super::ue_preview;ib_preview = false
end event

type dw_report from w_report_smpl`dw_report within w_cm784_abc_proveedores
integer x = 41
integer y = 352
integer width = 2917
integer height = 1532
string dataobject = "d_rpt_abc_compras_prov_x_oc_tbl"
end type

event dw_report::doubleclicked;call super::doubleclicked;date				ld_fecha1, ld_fecha2
string 			ls_proveedor, ls_origen
str_parametros  lstr_param
w_rpt_preview	lw_1

if this.RowCount() = 0 or row = 0 then return

ld_fecha1 		= uo_fecha.of_get_fecha1()
ld_fecha2 		= uo_fecha.of_get_fecha2()
ls_proveedor 	= this.object.proveedor [row]

if cbx_1.checked = false then
	ls_origen = '%%'
else
	ls_origen = trim(sle_origen.text) + '%'
end if

if rb_oc.checked = true then
	if rb_resumen.checked then
		lstr_param.dw1     = 'd_rpt_abc_compras_art_x_pro_tbl'
		lstr_param.oc_os	 = 'ocp1'
		lstr_param.titulo  = "Resumen de Compras por Artículo por Proveedor"
	elseif rb_proveedor.checked then
		lstr_param.dw1     = 'd_rpt_abc_comprador_proveedor_tbl'
		lstr_param.oc_os	 = 'ocp2'
		lstr_param.titulo  = "Resumen de Usuarios de Compras por Proveedor"
	elseif rb_documento.checked then
		lstr_param.dw1     = 'd_rpt_abc_compras_documento_x_pro_tbl'
		lstr_param.oc_os	 = 'ocp3'
		lstr_param.titulo  = "Resumen de Orden de Compra por Proveedor"
	end if
	lstr_param.tipo 	 = '1D2D1S2S'
	lstr_param.fecha1  = ld_fecha1
	lstr_param.fecha2	 = ld_fecha2
	lstr_param.string1 = ls_origen
	lstr_param.string2 = ls_proveedor
	lstr_param.opcion	 = 1

	OpenSheetWithParm( lw_1, lstr_param, w_main, 0, Layered!)
		
elseif rb_os.checked = true then
	if rb_resumen.checked then
		lstr_param.dw1 = 'd_rpt_compras_servicios_x_pro_tbl'
		lstr_param.oc_os	 = 'osp1'
		lstr_param.titulo = "Resumen de Servicios por Proveedor"
	elseif rb_proveedor.checked then
		lstr_param.dw1 = 'd_rpt_compras_usuarios_x_prove_os_tbl'
		lstr_param.oc_os	 = 'osp2'
		lstr_param.titulo = "Resument por Usuario por Proveedor"
	elseif rb_documento.checked then
		lstr_param.dw1 = 'd_rpt_compras_doc_x_proveedor_os_tbl'
		lstr_param.oc_os	 = 'osp3'
		lstr_param.titulo = "Listado de Documentos por Proveedor"
	end if
	
	lstr_param.tipo 	 = '1D2D1S2S'
	lstr_param.fecha1  = ld_fecha1
	lstr_param.fecha2	 = ld_fecha2
	lstr_param.string1 = ls_origen
	lstr_param.string2 = ls_proveedor
	lstr_param.opcion	 = 1

	OpenSheetWithParm( lw_1, lstr_param, w_main, 0, Layered!)
	
end if

end event

type uo_fecha from u_ingreso_rango_fechas within w_cm784_abc_proveedores
integer x = 14
integer y = 28
integer taborder = 40
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

on uo_fecha.destroy
call u_ingreso_rango_fechas::destroy
end on

type cb_3 from commandbutton within w_cm784_abc_proveedores
integer x = 2546
integer y = 16
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
string text = "Reporte"
end type

event clicked;parent.Event ue_retrieve()
end event

type rb_oc from radiobutton within w_cm784_abc_proveedores
integer x = 105
integer y = 184
integer width = 549
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
string text = "Orden de Compra"
boolean checked = true
end type

type rb_os from radiobutton within w_cm784_abc_proveedores
integer x = 105
integer y = 256
integer width = 549
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
string text = "Orden de Servicio"
end type

type rb_resumen from radiobutton within w_cm784_abc_proveedores
integer x = 791
integer y = 204
integer width = 667
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "ABC por Articulo/Servicio"
boolean checked = true
end type

type rb_proveedor from radiobutton within w_cm784_abc_proveedores
integer x = 1463
integer y = 204
integer width = 526
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "ABC por Comprador"
end type

type rb_documento from radiobutton within w_cm784_abc_proveedores
integer x = 2030
integer y = 204
integer width = 489
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "ABC x Documento"
end type

type cbx_1 from checkbox within w_cm784_abc_proveedores
integer x = 1422
integer y = 28
integer width = 475
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
string text = "Filtrar x Origen"
end type

event clicked;if this.checked then
	sle_origen.enabled = true
else
	sle_origen.enabled = false
end if
end event

type sle_origen from singlelineedit within w_cm784_abc_proveedores
event dobleclick pbm_lbuttondblclk
integer x = 1897
integer y = 28
integer width = 329
integer height = 80
integer taborder = 100
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

ls_sql = "SELECT cod_origen AS CODIGO_origen, " &
	  	 + "nombre AS DESCRIPCION_origen " &
	    + "FROM origen " &
		 + "where flag_estado = '1'"
				 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
if ls_codigo <> '' then
	this.text 			= ls_codigo
end if

end event

event modified;String 	ls_codigo, ls_data

ls_codigo = this.text
if ls_codigo = '' or IsNull(ls_codigo) then
	MessageBox('Aviso', 'Debe Ingresar un codigo de origen')
	return
end if

SELECT nombre 
	INTO :ls_data
FROM origen
where cod_origen = :ls_codigo ;

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de Origen no existe')
	this.text = ''
	return
end if


end event

type gb_1 from groupbox within w_cm784_abc_proveedores
integer x = 50
integer y = 128
integer width = 699
integer height = 220
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Fuentes de información"
end type

type gb_2 from groupbox within w_cm784_abc_proveedores
integer x = 763
integer y = 128
integer width = 1801
integer height = 220
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Opciones de Subconsultas"
end type

