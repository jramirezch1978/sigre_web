$PBExportHeader$w_fi754_compras_detraccion.srw
forward
global type w_fi754_compras_detraccion from w_rpt
end type
type cbx_fechas from checkbox within w_fi754_compras_detraccion
end type
type uo_fechas from u_ingreso_rango_fechas_v within w_fi754_compras_detraccion
end type
type cb_proveedores from commandbutton within w_fi754_compras_detraccion
end type
type cbx_proveedores from checkbox within w_fi754_compras_detraccion
end type
type cb_documentos from commandbutton within w_fi754_compras_detraccion
end type
type cbx_documentos from checkbox within w_fi754_compras_detraccion
end type
type cb_buscar from commandbutton within w_fi754_compras_detraccion
end type
type dw_reporte from u_dw_rpt within w_fi754_compras_detraccion
end type
type gb_1 from groupbox within w_fi754_compras_detraccion
end type
end forward

global type w_fi754_compras_detraccion from w_rpt
integer width = 3387
integer height = 1672
string title = "[FI754] Compras vs Detracciones vs Pagos"
string menuname = "m_reporte"
cbx_fechas cbx_fechas
uo_fechas uo_fechas
cb_proveedores cb_proveedores
cbx_proveedores cbx_proveedores
cb_documentos cb_documentos
cbx_documentos cbx_documentos
cb_buscar cb_buscar
dw_reporte dw_reporte
gb_1 gb_1
end type
global w_fi754_compras_detraccion w_fi754_compras_detraccion

type variables
String is_cod_rel[], is_tipo_doc[]
String is_flag_rel = '2', is_flag_tipo = '2'  // 0 (Ninguno), 1 (Selectiva), 2(Todos) 

//***** VARIABLES VENTANA POP ******//
Integer    ii_lista = 0
//**********************************//
end variables

forward prototypes
public function integer of_new_rpt (str_cns_pop astr_1)
public function boolean of_update ()
end prototypes

public function integer of_new_rpt (str_cns_pop astr_1);Integer li_rc
w_rpt_pop	lw_sheet

li_rc = OpenSheetWithParm(lw_sheet, astr_1, this, 0, Original!)
ii_x ++
iw_sheet[ii_x]  = lw_sheet

RETURN li_rc     						//	Valores de Retorno: 1 = exito, -1 =
end function

public function boolean of_update ();insert into doc_pendientes_cta_cte(cod_relacion, tipo_doc, nro_doc, flag_tabla, cod_moneda, flag_debhab, sldo_sol, saldo_dol, fecha_doc, factor, fecha_vencimiento)
	select cp.cod_relacion, 'DTRP', c.nro_detraccion, '3', cp.cod_moneda, 'H', 
			 DECODE(cp.cod_moneda, 'S/.', round(c.importe, 0), round(c.importe / cp.tasa_cambio,0)),
			 DECODE(cp.cod_moneda, 'US$',c.importe, c.importe * cp.tasa_cambio),
			 cp.fecha_emision,
			 -1, 
			 cp.vencimiento
	from detraccion  c,
		  cntas_pagar cp
	where c.nro_detraccion = cp.nro_detraccion
	  and c.nro_detraccion not in (select nro_doc from doc_pendientes_cta_cte where tipo_doc = 'DTRP')
	  and c.flag_estado <> '0'
	  and cp.flag_estado <> '0'
	  and c.nro_deposito is null;
  
if gnvo_app.of_existsError(SQLCA) then
	ROLLBACK;
	return false
end if

delete doc_pendientes_cta_cte t
where t.tipo_doc = 'DTRP'
  and t.nro_doc not in (select nro_doc from cntas_pagar cp where cp.tipo_doc = 'DTRP');

if gnvo_app.of_existsError(SQLCA) then
	ROLLBACK;
	return false
end if

delete doc_pendientes_cta_cte t
where t.saldo_dol <= 0 and t.sldo_sol <= 0;

if gnvo_app.of_existsError(SQLCA) then
	ROLLBACK;
	return false
end if

commit;

return true
end function

on w_fi754_compras_detraccion.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.cbx_fechas=create cbx_fechas
this.uo_fechas=create uo_fechas
this.cb_proveedores=create cb_proveedores
this.cbx_proveedores=create cbx_proveedores
this.cb_documentos=create cb_documentos
this.cbx_documentos=create cbx_documentos
this.cb_buscar=create cb_buscar
this.dw_reporte=create dw_reporte
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_fechas
this.Control[iCurrent+2]=this.uo_fechas
this.Control[iCurrent+3]=this.cb_proveedores
this.Control[iCurrent+4]=this.cbx_proveedores
this.Control[iCurrent+5]=this.cb_documentos
this.Control[iCurrent+6]=this.cbx_documentos
this.Control[iCurrent+7]=this.cb_buscar
this.Control[iCurrent+8]=this.dw_reporte
this.Control[iCurrent+9]=this.gb_1
end on

on w_fi754_compras_detraccion.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cbx_fechas)
destroy(this.uo_fechas)
destroy(this.cb_proveedores)
destroy(this.cbx_proveedores)
destroy(this.cb_documentos)
destroy(this.cbx_documentos)
destroy(this.cb_buscar)
destroy(this.dw_reporte)
destroy(this.gb_1)
end on

event resize;call super::resize;dw_reporte.width  = newwidth  - dw_reporte.x - 10
dw_reporte.height = newheight - dw_reporte.y - 10
end event

event ue_retrieve;call super::ue_retrieve;String 	ls_tipo, ls_flag_fechas
integer	li_count
Date		ld_fecha1, ld_fecha2


if cbx_documentos.checked then
	delete from tt_fin_tipo_doc;
	
	if gnvo_app.of_ExistsError(SQLCA, 'DELETE tt_fin_tipo_doc') then
		return 
	end if
	
	insert into tt_fin_tipo_doc(tipo_doc)
	select distinct dt.tipo_doc
		from doc_tipo dt,
			  cntas_pagar cp
		where cp.tipo_doc = dt.tipo_doc;
		
	if gnvo_app.of_ExistsError(SQLCA, 'INSERT tt_fin_tipo_doc') then
		return 
	end if

else
	
	select count(*)
	 	into :li_count
	from tt_fin_tipo_doc;
	
	if li_count = 0 then
		f_mensaje("Error, no ha seleccionado ningun tipo de documento para el reporte", "")
		return
	end if
end if

if cbx_proveedores.checked then
	delete from tt_fin_proveedor;
	
	if gnvo_app.of_ExistsError(SQLCA, 'DELETE tt_fin_proveedor') then
		return 
	end if
	
	insert into tt_fin_proveedor(cod_proveedor)
	select distinct cod_relacion
		from cntas_pagar cp;
		
	if gnvo_app.of_ExistsError(SQLCA, 'INSERT tt_fin_proveedor') then
		return 
	end if

else
	
	select count(*)
	 	into :li_count
	from tt_fin_proveedor;
	
	if li_count = 0 then
		f_mensaje("Error, no ha seleccionado ningun código de Relacion para el reporte", "")
		return
	end if
end if


IF cbx_fechas.checked = TRUE THEN
	ls_flag_fechas = '1'
	ld_fecha1 = uo_fechas.of_get_fecha1()
	ld_fecha2 = uo_fechas.of_get_fecha2()
else
	ls_flag_fechas = '0'
END IF 

ib_preview = true
event ue_preview()

idw_1.SetTransObject(sqlca)
idw_1.retrieve(ls_flag_fechas, ld_fecha1, ld_fecha2)

idw_1.Object.p_logo.filename = gs_logo
idw_1.Object.t_empresa.text   = gs_empresa
idw_1.Object.t_user.Text     = gs_user


end event

event ue_preview();call super::ue_preview;IF ib_preview THEN
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

event ue_open_pre;call super::ue_open_pre;this.of_update()

dw_reporte.Settransobject(sqlca)
idw_1 = dw_reporte
ib_preview = FALSE
Trigger Event ue_preview()

end event

event ue_print();call super::ue_print;idw_1.EVENT ue_print()
end event

type cbx_fechas from checkbox within w_fi754_compras_detraccion
integer x = 73
integer y = 4
integer width = 512
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "Filtrar x Fechas"
boolean checked = true
end type

event clicked;if this.checked then
	uo_Fechas.of_enabled(true)
else
	uo_Fechas.of_enabled(false)
end if
end event

type uo_fechas from u_ingreso_rango_fechas_v within w_fi754_compras_detraccion
event destroy ( )
integer x = 37
integer y = 68
integer taborder = 30
end type

on uo_fechas.destroy
call u_ingreso_rango_fechas_v::destroy
end on

event constructor;call super::constructor;Date	ld_fecha_actual

ld_fecha_actual = Date(gnvo_app.of_fecha_actual(true))

of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
of_set_fecha(ld_fecha_actual, gnvo_app.of_last_date(ld_fecha_actual)) //para setear la fecha inicial
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final
end event

type cb_proveedores from commandbutton within w_fi754_compras_detraccion
integer x = 1600
integer y = 136
integer width = 549
integer height = 100
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Código de Relacion"
end type

event clicked;Long ll_count
str_parametros sl_param 


delete tt_fin_proveedor ;
commit;

sl_param.dw1		= 'd_lista_codrel_cntas_pagar_tbl'
sl_param.titulo	= 'Listado de Maestro de Relaciones'
sl_param.opcion   = 1
sl_param.tipo		= ''

OpenWithParm( w_abc_seleccion_lista_search, sl_param)
end event

type cbx_proveedores from checkbox within w_fi754_compras_detraccion
integer x = 786
integer y = 148
integer width = 795
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Todos los Códigos de Relacion"
boolean checked = true
end type

event clicked;if this.checked then
	cb_proveedores.enabled = false
else
	cb_proveedores.enabled = true
end if
end event

type cb_documentos from commandbutton within w_fi754_compras_detraccion
integer x = 1600
integer y = 32
integer width = 549
integer height = 100
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Documentos"
end type

event clicked;Long ll_count
str_parametros sl_param 


delete tt_fin_tipo_doc ;
commit;

sl_param.dw1		= 'd_lista_tipo_doc_cntas_pagar_tbl'
sl_param.titulo	= 'Listado de Documentos'
sl_param.opcion   = 19
sl_param.tipo		= ''


OpenWithParm( w_abc_seleccion_lista_search, sl_param)
end event

type cbx_documentos from checkbox within w_fi754_compras_detraccion
integer x = 782
integer y = 44
integer width = 594
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Todos los documentos"
boolean checked = true
boolean righttoleft = true
end type

event clicked;if this.checked then
	cb_documentos.enabled = false
else
	cb_documentos.enabled = true
end if
end event

type cb_buscar from commandbutton within w_fi754_compras_detraccion
integer x = 2217
integer y = 40
integer width = 507
integer height = 196
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Buscar"
end type

event clicked;
Event ue_retrieve()

end event

type dw_reporte from u_dw_rpt within w_fi754_compras_detraccion
integer y = 280
integer width = 3305
integer height = 1108
string dataobject = "d_rpt_provision_detraccion_tbl"
boolean hsplitscroll = true
end type

event doubleclicked;call super::doubleclicked;IF is_dwform = 'tabular' THEN
	THIS.Event ue_column_sort()
END IF

IF row = 0 THEN RETURN

STR_CNS_POP lstr_1
CHOOSE CASE dwo.Name
	CASE 'cod_relacion'  
		lstr_1.DataObject = 'd_rpt_sldo_cta_cte_res_det_tbl'
		lstr_1.Width = 3100
		lstr_1.Height= 1300
		lstr_1.Title = 'Reporte Saldo de Cuenta Corriente Resumen - Detalle'
		lstr_1.arg[1] = String(GetItemString(row,'cod_relacion'))
		of_new_rpt(lstr_1)
END CHOOSE
end event

event rowfocuschanged;call super::rowfocuschanged;gnvo_app.of_select_current_row( this )
end event

type gb_1 from groupbox within w_fi754_compras_detraccion
integer width = 741
integer height = 272
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
end type

