$PBExportHeader$w_fi753_sldo_cta_cte.srw
forward
global type w_fi753_sldo_cta_cte from w_rpt
end type
type rb_treeview from radiobutton within w_fi753_sldo_cta_cte
end type
type cb_proveedores from commandbutton within w_fi753_sldo_cta_cte
end type
type cbx_proveedores from checkbox within w_fi753_sldo_cta_cte
end type
type cb_documentos from commandbutton within w_fi753_sldo_cta_cte
end type
type cbx_documentos from checkbox within w_fi753_sldo_cta_cte
end type
type rb_detalle from radiobutton within w_fi753_sldo_cta_cte
end type
type rb_resumen from radiobutton within w_fi753_sldo_cta_cte
end type
type cb_buscar from commandbutton within w_fi753_sldo_cta_cte
end type
type dw_reporte from u_dw_rpt within w_fi753_sldo_cta_cte
end type
type gb_1 from groupbox within w_fi753_sldo_cta_cte
end type
end forward

global type w_fi753_sldo_cta_cte from w_rpt
integer width = 3387
integer height = 1672
string title = "[FI753] Reporte de Analítico de Cuenta Corriente"
string menuname = "m_reporte"
rb_treeview rb_treeview
cb_proveedores cb_proveedores
cbx_proveedores cbx_proveedores
cb_documentos cb_documentos
cbx_documentos cbx_documentos
rb_detalle rb_detalle
rb_resumen rb_resumen
cb_buscar cb_buscar
dw_reporte dw_reporte
gb_1 gb_1
end type
global w_fi753_sldo_cta_cte w_fi753_sldo_cta_cte

type variables
String is_cod_rel[], is_tipo_doc[]
String is_flag_rel = '2', is_flag_tipo = '2'  // 0 (Ninguno), 1 (Selectiva), 2(Todos) 

//***** VARIABLES VENTANA POP ******//
Integer    ii_lista = 0
//**********************************//

n_cst_wait invo_wait
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

public function boolean of_update ();insert into doc_pendientes_cta_cte(
		cod_relacion, tipo_doc, nro_doc, flag_tabla, cod_moneda, flag_debhab, 
		sldo_sol, 
		saldo_dol, 
		fecha_doc, 
		factor, 
		fecha_vencimiento)
	select cp.cod_relacion, 
			 :gnvo_app.finparam.is_doc_dtrp, 
			 c.nro_detraccion, 
			 '3', 
			 (select cod_soles from logparam where reckey = '1'), 
			 'H', 
			 cp.saldo_sol,
			 cp.saldo_dol,
			 cp.fecha_emision,
			 -1, 
			 cp.vencimiento
	from detraccion  c,
		  cntas_pagar cp
	where c.nro_detraccion = cp.nro_detraccion
	  and cp.tipo_doc		  = :gnvo_app.finparam.is_doc_dtrp
	  and c.nro_detraccion not in (select nro_doc from doc_pendientes_cta_cte where tipo_doc = :gnvo_app.finparam.is_doc_dtrp)
	  and c.flag_estado  <> '0'
	  and cp.flag_estado <> '0'
	  and c.nro_deposito is null
	  and cp.saldo_sol > 0;
  
if gnvo_app.of_existsError(SQLCA) then
	ROLLBACK;
	return false
end if

delete doc_pendientes_cta_cte t
where t.tipo_doc = :gnvo_app.finparam.is_doc_dtrp
  and t.nro_doc not in (select nro_doc from cntas_pagar cp where cp.tipo_doc = :gnvo_app.finparam.is_doc_dtrp);

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

delete doc_pendientes_cta_cte t
where (t.saldo_dol = 0 and t.cod_moneda = (select cod_dolares from logparam where reckey = '1'))
  or (t.sldo_sol = 0 and t.cod_moneda = (select cod_soles from logparam where reckey = '1'));
  
if gnvo_app.of_existsError(SQLCA) then
	ROLLBACK;
	return false
end if

delete doc_pendientes_cta_cte t
where t.cod_relacion || t.tipo_doc || t.nro_doc in (select cod_relacion || tipo_doc || nro_doc
                                                      from cntas_pagar cp
                                                     where cp.flag_estado in ('0', '4'));

if gnvo_app.of_existsError(SQLCA) then
	ROLLBACK;
	return false
end if

delete doc_pendientes_cta_cte t
where t.cod_relacion || t.tipo_doc || t.nro_doc in (select cod_relacion || tipo_doc || nro_doc
                                                      from cntas_pagar cp
                                                     where cp.cod_moneda = (select cod_soles from logparam where reckey = '1')
																	    and cp.saldo_sol = 0);
if gnvo_app.of_existsError(SQLCA) then
	ROLLBACK;
	return false
end if


commit;

return true
end function

on w_fi753_sldo_cta_cte.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.rb_treeview=create rb_treeview
this.cb_proveedores=create cb_proveedores
this.cbx_proveedores=create cbx_proveedores
this.cb_documentos=create cb_documentos
this.cbx_documentos=create cbx_documentos
this.rb_detalle=create rb_detalle
this.rb_resumen=create rb_resumen
this.cb_buscar=create cb_buscar
this.dw_reporte=create dw_reporte
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_treeview
this.Control[iCurrent+2]=this.cb_proveedores
this.Control[iCurrent+3]=this.cbx_proveedores
this.Control[iCurrent+4]=this.cb_documentos
this.Control[iCurrent+5]=this.cbx_documentos
this.Control[iCurrent+6]=this.rb_detalle
this.Control[iCurrent+7]=this.rb_resumen
this.Control[iCurrent+8]=this.cb_buscar
this.Control[iCurrent+9]=this.dw_reporte
this.Control[iCurrent+10]=this.gb_1
end on

on w_fi753_sldo_cta_cte.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_treeview)
destroy(this.cb_proveedores)
destroy(this.cbx_proveedores)
destroy(this.cb_documentos)
destroy(this.cbx_documentos)
destroy(this.rb_detalle)
destroy(this.rb_resumen)
destroy(this.cb_buscar)
destroy(this.dw_reporte)
destroy(this.gb_1)
end on

event resize;call super::resize;dw_reporte.width  = newwidth  - dw_reporte.x - 10
dw_reporte.height = newheight - dw_reporte.y - 10
end event

event ue_retrieve;call super::ue_retrieve;Decimal 	ldc_tasa_cambio
String 	ls_tipo
integer	li_count


if cbx_documentos.checked then
	delete from tt_fin_tipo_doc;
	
	if gnvo_app.of_ExistsError(SQLCA, 'DELETE tt_fin_tipo_doc') then
		return 
	end if
	
	insert into tt_fin_tipo_doc(tipo_doc)
	select distinct dt.tipo_doc
		from doc_tipo dt,
			  doc_pendientes_cta_cte d
		where d.tipo_doc = dt.tipo_doc;
		
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
		from doc_pendientes_cta_cte d;
		
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


IF rb_resumen.checked = TRUE THEN
	idw_1.DataObject='d_rpt_sldo_cta_cte_res_tbl'
ELSEIF rb_detalle.checked = TRUE THEN
	idw_1.DataObject='d_rpt_sldo_cta_cte_detalle_tbl'
ELSEIF rb_detalle.checked = TRUE THEN
	idw_1.DataObject='d_rpt_sldo_cta_cte_tv'
ELSE
	MessageBox('Aviso', 'Seleccione una opción en parámetros')
	return 
END IF 

ib_preview = false
event ue_preview()

this.of_update()

idw_1.SetTransObject(sqlca)
idw_1.retrieve()

ldc_tasa_cambio = gnvo_app.of_tasa_cambio()

idw_1.Object.p_logo.filename = gs_logo
idw_1.Object.t_nombre.text   = gs_empresa
idw_1.Object.t_user.Text     = gs_user
idw_1.Object.t_tasa.Text     = 'Tasa Cambio HOY: '+String(ldc_tasa_cambio, '#0.000')

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

event ue_open_pre;call super::ue_open_pre;invo_wait = create n_cst_wait

if MessageBox('Aviso', 'Deseas actualizar la cuenta corriente antes de obtener el reporte?, ' &
							+ '~r~nEste proceso de actualizacion puede demorar unos minutos, todo depende ' &
							+ 'de la cantidad de informacion que se tenga', Information!, YesNo!, 2) = 1 then

	invo_wait.of_mensaje("un momento Actualizando la Cuenta Corriente...")
	yield()
	this.of_update()
	
	gnvo_app.finparam.of_actualiza_saldo_cc()
	gnvo_app.finparam.of_actualiza_saldo_cp()

end if						



dw_reporte.Settransobject(sqlca)
idw_1 = dw_reporte
ib_preview = FALSE
Trigger Event ue_preview()

invo_wait.of_close()

end event

event ue_print();call super::ue_print;idw_1.EVENT ue_print()
end event

event close;call super::close;destroy invo_wait
end event

type rb_treeview from radiobutton within w_fi753_sldo_cta_cte
integer x = 46
integer y = 196
integer width = 370
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Vista Arbol"
end type

type cb_proveedores from commandbutton within w_fi753_sldo_cta_cte
integer x = 1399
integer y = 140
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

sl_param.dw1		= 'd_lista_codrel_ctacte_tbl'
sl_param.titulo	= 'Listado de Maestro de Relaciones'
sl_param.opcion   = 1
sl_param.tipo		= ''

OpenWithParm( w_abc_seleccion_lista_search, sl_param)
end event

type cbx_proveedores from checkbox within w_fi753_sldo_cta_cte
integer x = 585
integer y = 152
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

type cb_documentos from commandbutton within w_fi753_sldo_cta_cte
integer x = 1399
integer y = 36
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

sl_param.dw1		= 'd_lista_tipo_doc_ctacte_tbl'
sl_param.titulo	= 'Listado de Documentos'
sl_param.opcion   = 19
sl_param.tipo		= ''


OpenWithParm( w_abc_seleccion_lista_search, sl_param)
end event

type cbx_documentos from checkbox within w_fi753_sldo_cta_cte
integer x = 581
integer y = 48
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

type rb_detalle from radiobutton within w_fi753_sldo_cta_cte
integer x = 46
integer y = 124
integer width = 343
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Detalle"
boolean checked = true
end type

type rb_resumen from radiobutton within w_fi753_sldo_cta_cte
integer x = 46
integer y = 52
integer width = 343
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Resumen"
end type

type cb_buscar from commandbutton within w_fi753_sldo_cta_cte
integer x = 2011
integer y = 48
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

event clicked;SetPointer(Hourglass!)
Event ue_retrieve()
SetPointer(Arrow!)

end event

type dw_reporte from u_dw_rpt within w_fi753_sldo_cta_cte
integer y = 292
integer width = 3305
integer height = 1108
string dataobject = "d_rpt_sldo_cta_cte_res_tbl"
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

type gb_1 from groupbox within w_fi753_sldo_cta_cte
integer width = 512
integer height = 284
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "Tipo de Reporte"
end type

