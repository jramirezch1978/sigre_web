$PBExportHeader$w_ve776_pendientes_vs_clientes.srw
forward
global type w_ve776_pendientes_vs_clientes from w_rpt
end type
type cbx_categoria from checkbox within w_ve776_pendientes_vs_clientes
end type
type cb_categ from commandbutton within w_ve776_pendientes_vs_clientes
end type
type cb_almacen from commandbutton within w_ve776_pendientes_vs_clientes
end type
type cbx_almacen from checkbox within w_ve776_pendientes_vs_clientes
end type
type cb_cliente from commandbutton within w_ve776_pendientes_vs_clientes
end type
type cbx_cliente from checkbox within w_ve776_pendientes_vs_clientes
end type
type cb_especie from commandbutton within w_ve776_pendientes_vs_clientes
end type
type cbx_especie from checkbox within w_ve776_pendientes_vs_clientes
end type
type cb_subcategoria from commandbutton within w_ve776_pendientes_vs_clientes
end type
type cbx_subcateg from checkbox within w_ve776_pendientes_vs_clientes
end type
type cb_1 from commandbutton within w_ve776_pendientes_vs_clientes
end type
type dw_report from u_dw_rpt within w_ve776_pendientes_vs_clientes
end type
type gb_1 from groupbox within w_ve776_pendientes_vs_clientes
end type
end forward

global type w_ve776_pendientes_vs_clientes from w_rpt
integer width = 3799
integer height = 2404
string title = "[VE776] Pendientes de OV vs Clientes"
string menuname = "m_reporte"
cbx_categoria cbx_categoria
cb_categ cb_categ
cb_almacen cb_almacen
cbx_almacen cbx_almacen
cb_cliente cb_cliente
cbx_cliente cbx_cliente
cb_especie cb_especie
cbx_especie cbx_especie
cb_subcategoria cb_subcategoria
cbx_subcateg cbx_subcateg
cb_1 cb_1
dw_report dw_report
gb_1 gb_1
end type
global w_ve776_pendientes_vs_clientes w_ve776_pendientes_vs_clientes

on w_ve776_pendientes_vs_clientes.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.cbx_categoria=create cbx_categoria
this.cb_categ=create cb_categ
this.cb_almacen=create cb_almacen
this.cbx_almacen=create cbx_almacen
this.cb_cliente=create cb_cliente
this.cbx_cliente=create cbx_cliente
this.cb_especie=create cb_especie
this.cbx_especie=create cbx_especie
this.cb_subcategoria=create cb_subcategoria
this.cbx_subcateg=create cbx_subcateg
this.cb_1=create cb_1
this.dw_report=create dw_report
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_categoria
this.Control[iCurrent+2]=this.cb_categ
this.Control[iCurrent+3]=this.cb_almacen
this.Control[iCurrent+4]=this.cbx_almacen
this.Control[iCurrent+5]=this.cb_cliente
this.Control[iCurrent+6]=this.cbx_cliente
this.Control[iCurrent+7]=this.cb_especie
this.Control[iCurrent+8]=this.cbx_especie
this.Control[iCurrent+9]=this.cb_subcategoria
this.Control[iCurrent+10]=this.cbx_subcateg
this.Control[iCurrent+11]=this.cb_1
this.Control[iCurrent+12]=this.dw_report
this.Control[iCurrent+13]=this.gb_1
end on

on w_ve776_pendientes_vs_clientes.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cbx_categoria)
destroy(this.cb_categ)
destroy(this.cb_almacen)
destroy(this.cbx_almacen)
destroy(this.cb_cliente)
destroy(this.cbx_cliente)
destroy(this.cb_especie)
destroy(this.cbx_especie)
destroy(this.cb_subcategoria)
destroy(this.cbx_subcateg)
destroy(this.cb_1)
destroy(this.dw_report)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;
idw_1 = dw_report

idw_1.SetTransObject(sqlca)

//datos de reporte
ib_preview = true
This.Event ue_preview()

dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_empresa.text = gs_empresa
dw_report.object.t_user.text = gs_user



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

event ue_saveas;call super::ue_saveas;idw_1.EVENT ue_saveas()
end event

event ue_zoom;call super::ue_zoom;idw_1.EVENT ue_zoom(ai_zoom)
end event

event ue_retrieve;call super::ue_retrieve;Long		ll_count
DateTime	ldt_fecha1, ldt_fecha2
Decimal	ldc_dif_tiempo
String	ls_tiempo

//Filtrar Especies
if cbx_especie.checked then
	
	delete tt_especies;
	if gnvo_app.of_existsError(SQLCA, 'Eliminacion tabla tt_especies' ) then
		rollback;
		return 
	end if	
	
	Insert into tt_especies(especie)
	select distinct 
			 te.especie
	  from orden_venta ov,
			 articulo_mov_proy amp,
			 articulo          a,
			 tg_especies       te,
			 tg_especies_articulo tea
	 where ov.nro_ov    = amp.nro_doc
		and amp.tipo_doc = (select doc_ov from logparam where reckey = '1')
		and amp.cod_art  = a.cod_art
		and a.cod_art    = tea.cod_art  
		and tea.especie  = te.especie   
		and usf_ap_conv_und(amp.und, a.und, amp.cant_proyect) - amp.cant_procesada > 0
		and amp.flag_estado = '1';
		
	if gnvo_app.of_existsError(SQLCA, 'Insert tabla tt_especies' ) then
		rollback;
		return 
	end if	
		
	commit;

else
	select count(*)
		into :ll_count
	from tt_especies;
	
	if ll_count = 0 then 
		MessageBox('Error', 'Debe seleccionar a una ESPECIE, por favor verifique!', StopSign!)
		return
	end if
end if


//Filtrar Categorias
if cbx_categoria.checked then
	
	delete TT_ARTICULO_ALMACEN;
	if gnvo_app.of_existsError(SQLCA, 'Eliminacion tabla TT_ARTICULO_ALMACEN' ) then
		rollback;
		return 
	end if	
	
	Insert into TT_ARTICULO_ALMACEN(CAT_ART)
	select distinct
       a1.cat_art
  from articulo          a,
       tg_especies_articulo tea,
       articulo_sub_Categ   a2,
       articulo_categ       a1
 where a.sub_cat_art  = a2.cod_sub_cat
   and a2.cat_art     = a1.cat_art
   and a.cod_art    = tea.cod_art  (+)
   and (tea.especie in (select tt.especie from tt_especies tt) or tea.especie is null);

		
	if gnvo_app.of_existsError(SQLCA, 'Insert tabla TT_ARTICULO_ALMACEN' ) then
		rollback;
		return 
	end if	
		
	commit;

else
	select count(*)
		into :ll_count
	from TT_ARTICULO_ALMACEN;
	
	if ll_count = 0 then 
		MessageBox('Error', 'Debe seleccionar a una CATEGORIA, por favor verifique!', StopSign!)
		return
	end if
end if

//Filtrar SubCategorias
if cbx_subcateg.checked then
	
	delete TT_CNT_SUB_CAT;
	if gnvo_app.of_existsError(SQLCA, 'Eliminacion tabla TT_CNT_SUB_CAT' ) then
		rollback;
		return 
	end if	
	
	Insert into TT_CNT_SUB_CAT(SUB_CAT)
	select distinct
			 a2.cod_sub_cat
	  from articulo          a,
			 tg_especies_articulo tea,
			 articulo_sub_Categ   a2
	 where a.sub_cat_art  = a2.cod_sub_cat
		and a.cod_art    = tea.cod_art  (+)
		and (tea.especie in (select tt.especie from tt_especies tt) or tea.especie is null)
		and a2.cat_art     in (select cat_art from TT_ARTICULO_ALMACEN);

		
	if gnvo_app.of_existsError(SQLCA, 'Insert tabla TT_CNT_SUB_CAT' ) then
		rollback;
		return 
	end if	
		
	commit;

else
	select count(*)
		into :ll_count
	from TT_CNT_SUB_CAT;
	
	if ll_count = 0 then 
		MessageBox('Error', 'Debe seleccionar a una SUBCATEGORIA, por favor verifique!', StopSign!)
		return
	end if
end if

//Filtrar Cliente
if cbx_cliente.checked then
	
	delete TT_PROVEEDOR;
	if gnvo_app.of_existsError(SQLCA, 'Eliminacion tabla TT_PROVEEDOR' ) then
		rollback;
		return 
	end if	
	
	Insert into TT_PROVEEDOR(PROVEEDOR)
	  select distinct
				p.proveedor
		 from orden_venta ov,
			 articulo_mov_proy amp,
			 articulo          a,
			 tg_especies_articulo tea,
			 articulo_sub_Categ   a2,
			 articulo_categ       a1,
			 PROVEEDOR            p
		where ov.nro_ov    = amp.nro_doc
		 and amp.tipo_doc = (select doc_ov from logparam where reckey = '1')
		 and amp.cod_art  = a.cod_art
		 and a.sub_cat_art  = a2.cod_sub_cat
		 and a2.cat_art     = a1.cat_art
		 and a.cod_art    = tea.cod_art  (+)
		 and ov.cliente   = p.proveedor
		 and usf_ap_conv_und(amp.und, a.und, amp.cant_proyect) - amp.cant_procesada > 0
		 and (tea.especie in (select tt.especie from tt_especies tt) or tea.especie is null)
		 and (a1.cat_art in (select t2.cat_art from TT_ARTICULO_ALMACEN t2) or tea.especie is null)
		 and amp.flag_estado = '1';
		
	if gnvo_app.of_existsError(SQLCA, 'Insert tabla TT_ARTICULO_ALMACEN' ) then
		rollback;
		return 
	end if	
		
	commit;

else
	select count(*)
		into :ll_count
	from TT_PROVEEDOR;
	
	if ll_count = 0 then 
		MessageBox('Error', 'Debe seleccionar a un CLIENTE, por favor verifique!', StopSign!)
		return
	end if
end if

//Filtrar almacenes
if cbx_almacen.checked then
	
	delete TT_ALMACENES;
	if gnvo_app.of_existsError(SQLCA, 'Eliminacion tabla TT_ALMACENES' ) then
		rollback;
		return 
	end if	
	
	Insert into TT_ALMACENES(ALMACEN)
	  select al.almacen
		from almacen al
		where al.flag_virtual = '0';
		
	if gnvo_app.of_existsError(SQLCA, 'Insert tabla TT_ALMACENES' ) then
		rollback;
		return 
	end if	
		
	commit;

else
	
	select count(*)
		into :ll_count
	from TT_ALMACENES;
	
	if ll_count = 0 then 
		MessageBox('Error', 'Debe seleccionar un ALMACEN, por favor verifique!', StopSign!)
		return
	end if
end if

commit;


ldt_Fecha1 = gnvo_app.of_fecha_Actual()
dw_report.Retrieve()

ldt_fecha2 = gnvo_app.of_fecha_Actual()

select (:ldt_fecha2 - :ldt_fecha1) 
	into :ldc_dif_tiempo
from dual;

ls_tiempo = gnvo_app.utilitario.of_time_to_string(ldc_dif_tiempo)

MessageBox('Aviso', 'Reporte generado satisfactoriamente en ' + ls_tiempo, Information!)
end event

type cbx_categoria from checkbox within w_ve776_pendientes_vs_clientes
integer x = 603
integer y = 64
integer width = 539
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Filtrar x Categoria"
boolean checked = true
end type

event clicked;if this.checked then
	cb_categ.enabled = false
else
	cb_categ.enabled = true
end if
end event

type cb_categ from commandbutton within w_ve776_pendientes_vs_clientes
integer x = 603
integer y = 140
integer width = 539
integer height = 100
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Elegir Categoria(s)"
end type

event clicked;Long 		ll_count
String 	ls_vendedor
str_parametros lstr_param 


//Filtrar Especie
if cbx_especie.checked then
	
	delete tt_especies;
	if gnvo_app.of_existsError(SQLCA, 'Eliminacion tabla tt_especies' ) then
		rollback;
		return 
	end if	
	
	Insert into tt_especies(especie)
	select distinct
			 te.especie
	  from Vale_mov 					vm,
			 articulo_mov 				am,
			 articulo_mov_tipo		amt,
			 articulo          		a,
			 tg_especies       		te,
			 tg_especies_articulo 	tea
	 where vm.nro_Vale		= am.nro_vale
		and vm.tipo_mov		= amt.tipo_mov
		and am.cod_art  		= a.cod_art
		and a.cod_art    		= tea.cod_art  
		and tea.especie  		= te.especie   
		and vm.flag_estado	<> '0'
		and am.flag_estado	<> '0'
	group by te.especie,
			 te.descr_especie
	having abs(sum(am.cant_procesada * amt.factor_sldo_total)) > 0;

		
	if gnvo_app.of_existsError(SQLCA, 'Insert tabla tt_especies' ) then
		rollback;
		return 
	end if	
		
	commit;

else
	select count(*)
		into :ll_count
	from tt_especies;
	
	if ll_count = 0 then 
		MessageBox('Error', 'Debe seleccionar a una ESPECIE, por favor verifique!', StopSign!)
		return
	end if
end if


delete tt_articulo_almacen ;

if gnvo_app.of_existsError(SQLCA, 'Eliminacion tabla TT_ARTICULO_ALMACEN' ) then
	rollback;
	return 
end if	

commit;

lstr_param.dw1			= 'd_lista_categorias_pendientes_tbl'
lstr_param.titulo		= 'Listado de Categorias de Articulos'
lstr_param.opcion   	= 27
lstr_param.tipo		= ''


OpenWithParm( w_abc_seleccion_lista_search, lstr_param)

end event

type cb_almacen from commandbutton within w_ve776_pendientes_vs_clientes
integer x = 2235
integer y = 140
integer width = 539
integer height = 100
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Elegir Almacen(es)"
end type

event clicked;Long 		ll_count
String 	ls_vendedor
str_parametros lstr_param 


lstr_param.dw1			= 'd_lista_almacenes_tbl'
lstr_param.titulo		= 'Listado de Almacenes'
lstr_param.opcion   	= 29
lstr_param.tipo		= ''


OpenWithParm( w_abc_seleccion_lista_search, lstr_param)

end event

type cbx_almacen from checkbox within w_ve776_pendientes_vs_clientes
integer x = 2245
integer y = 64
integer width = 539
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Filtrar x Almacen"
boolean checked = true
end type

event clicked;if this.checked then
	cb_almacen.enabled = false
else
	cb_almacen.enabled = true
end if
end event

type cb_cliente from commandbutton within w_ve776_pendientes_vs_clientes
integer x = 1691
integer y = 140
integer width = 539
integer height = 100
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Elegir Cliente(s)"
end type

event clicked;Long 		ll_count
String 	ls_vendedor
str_parametros lstr_param 


//Filtrar especie
if cbx_especie.checked then
	
	delete tt_especies;
	if gnvo_app.of_existsError(SQLCA, 'Eliminacion tabla tt_especies' ) then
		rollback;
		return 
	end if	
	
	Insert into tt_especies(especie)
	select distinct
			 te.especie
	  from Vale_mov 					vm,
			 articulo_mov 				am,
			 articulo_mov_tipo		amt,
			 articulo          		a,
			 tg_especies       		te,
			 tg_especies_articulo 	tea
	 where vm.nro_Vale		= am.nro_vale
		and vm.tipo_mov		= amt.tipo_mov
		and am.cod_art  		= a.cod_art
		and a.cod_art    		= tea.cod_art  
		and tea.especie  		= te.especie   
		and vm.flag_estado	<> '0'
		and am.flag_estado	<> '0'
	group by te.especie,
			 te.descr_especie
	having abs(sum(am.cant_procesada * amt.factor_sldo_total)) > 0;

		
	if gnvo_app.of_existsError(SQLCA, 'Insert tabla tt_especies' ) then
		rollback;
		return 
	end if	
		
	commit;

else
	select count(*)
		into :ll_count
	from tt_especies;
	
	if ll_count = 0 then 
		MessageBox('Error', 'Debe seleccionar a una ESPECIE, por favor verifique!', StopSign!)
		return
	end if
end if

//Filtrar Categorias
if cbx_categoria.checked then
	
	delete TT_ARTICULO_ALMACEN;
	if gnvo_app.of_existsError(SQLCA, 'Eliminacion tabla TT_ARTICULO_ALMACEN' ) then
		rollback;
		return 
	end if	
	
	Insert into TT_ARTICULO_ALMACEN(CAT_ART)
	select distinct
			 a1.cat_art
	  from orden_venta 				ov,
			 articulo_mov_proy 		amp,
			 articulo          		a,
			 tg_especies_articulo 	tea,
			 articulo_sub_Categ   	a2,
			 articulo_categ       	a1
	 where ov.nro_ov    		= amp.nro_doc
		and amp.tipo_doc 		= (select doc_ov from logparam where reckey = '1')
		and amp.cod_art  		= a.cod_art
		and a.sub_cat_art  	= a2.cod_sub_cat
		and a2.cat_art     	= a1.cat_art
		and a.cod_art    		= tea.cod_art  (+)
		and usf_ap_conv_und(amp.und, a.und, amp.cant_proyect) - amp.cant_procesada > 0
		and (tea.especie in (select tt.especie from tt_especies tt) or tea.especie is null)
		and amp.flag_estado = '1';

		
	if gnvo_app.of_existsError(SQLCA, 'Insert tabla TT_ARTICULO_ALMACEN' ) then
		rollback;
		return 
	end if	
		
	commit;

else
	select count(*)
		into :ll_count
	from TT_ARTICULO_ALMACEN;
	
	if ll_count = 0 then 
		MessageBox('Error', 'Debe seleccionar a una CATEGORIA, por favor verifique!', StopSign!)
		return
	end if
end if

delete tt_proveedor ;

if gnvo_app.of_existsError(SQLCA, 'Eliminacion tabla TT_PROVEEDOR' ) then
	rollback;
	return 
end if	

commit;
lstr_param.dw1			= 'd_lista_clientes_tbl'
lstr_param.titulo		= 'Listado de Clientes'
lstr_param.opcion   	= 28
lstr_param.tipo		= ''


OpenWithParm( w_abc_seleccion_lista_search, lstr_param)

end event

type cbx_cliente from checkbox within w_ve776_pendientes_vs_clientes
integer x = 1701
integer y = 64
integer width = 539
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Filtrar x Cliente"
boolean checked = true
end type

event clicked;if this.checked then
	cb_cliente.enabled = false
else
	cb_cliente.enabled = true
end if
end event

type cb_especie from commandbutton within w_ve776_pendientes_vs_clientes
integer x = 59
integer y = 140
integer width = 539
integer height = 100
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Elegir Especie(s)"
end type

event clicked;Long 		ll_count
str_parametros lstr_param 

delete tt_especies ;

if gnvo_app.of_ExistsError(sqlca, 'Eliminacion de TABLA tt_especies' ) then return

commit;

lstr_param.dw1			= 'd_lista_pendiente_especies_tbl'
lstr_param.titulo		= 'Listado de Especies'
lstr_param.opcion   	= 26
lstr_param.tipo		= ''



OpenWithParm( w_abc_seleccion_lista_search, lstr_param)

end event

type cbx_especie from checkbox within w_ve776_pendientes_vs_clientes
integer x = 59
integer y = 64
integer width = 539
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Filtrar x Especie"
boolean checked = true
end type

event clicked;if this.checked then
	cb_Especie.enabled = false
else
	cb_Especie.enabled = true
end if
end event

type cb_subcategoria from commandbutton within w_ve776_pendientes_vs_clientes
integer x = 1147
integer y = 140
integer width = 539
integer height = 100
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Elegir SubCateg"
end type

event clicked;Long 		ll_count
String 	ls_vendedor
str_parametros lstr_param 


//Filtrar Especie
if cbx_especie.checked then
	
	delete tt_especies;
	if gnvo_app.of_existsError(SQLCA, 'Eliminacion tabla tt_especies' ) then
		rollback;
		return 
	end if	
	
	Insert into tt_especies(especie)
	select distinct
			 te.especie
	  from Vale_mov 					vm,
			 articulo_mov 				am,
			 articulo_mov_tipo		amt,
			 articulo          		a,
			 tg_especies       		te,
			 tg_especies_articulo 	tea
	 where vm.nro_Vale		= am.nro_vale
		and vm.tipo_mov		= amt.tipo_mov
		and am.cod_art  		= a.cod_art
		and a.cod_art    		= tea.cod_art  
		and tea.especie  		= te.especie   
		and vm.flag_estado	<> '0'
		and am.flag_estado	<> '0'
	group by te.especie,
			 te.descr_especie
	having abs(sum(am.cant_procesada * amt.factor_sldo_total)) > 0;

		
	if gnvo_app.of_existsError(SQLCA, 'Insert tabla tt_especies' ) then
		rollback;
		return 
	end if	
		
	commit;

else
	select count(*)
		into :ll_count
	from tt_especies;
	
	if ll_count = 0 then 
		MessageBox('Error', 'Debe seleccionar a una ESPECIE, por favor verifique!', StopSign!)
		return
	end if
end if

//Filtrar Categorias
if cbx_categoria.checked then
	
	delete TT_ARTICULO_ALMACEN;
	if gnvo_app.of_existsError(SQLCA, 'Eliminacion tabla TT_ARTICULO_ALMACEN' ) then
		rollback;
		return 
	end if	
	
	Insert into TT_ARTICULO_ALMACEN(CAT_ART)
	select distinct
			 a1.cat_art
	  from orden_venta 				ov,
			 articulo_mov_proy 		amp,
			 articulo          		a,
			 tg_especies_articulo 	tea,
			 articulo_sub_Categ   	a2,
			 articulo_categ       	a1
	 where ov.nro_ov    		= amp.nro_doc
		and amp.tipo_doc 		= (select doc_ov from logparam where reckey = '1')
		and amp.cod_art  		= a.cod_art
		and a.sub_cat_art  	= a2.cod_sub_cat
		and a2.cat_art     	= a1.cat_art
		and a.cod_art    		= tea.cod_art  (+)
		and usf_ap_conv_und(amp.und, a.und, amp.cant_proyect) - amp.cant_procesada > 0
		and (tea.especie in (select tt.especie from tt_especies tt) or tea.especie is null)
		and amp.flag_estado = '1';

		
	if gnvo_app.of_existsError(SQLCA, 'Insert tabla TT_ARTICULO_ALMACEN' ) then
		rollback;
		return 
	end if	
		
	commit;

else
	select count(*)
		into :ll_count
	from TT_ARTICULO_ALMACEN;
	
	if ll_count = 0 then 
		MessageBox('Error', 'Debe seleccionar a una CATEGORIA, por favor verifique!', StopSign!)
		return
	end if
end if


delete TT_CNT_SUB_CAT ;

if gnvo_app.of_existsError(SQLCA, 'Eliminacion tabla TT_CNT_SUB_CAT' ) then
	rollback;
	return 
end if	

commit;

lstr_param.dw1			= 'd_lista_subcategorias_pendientes_tbl'
lstr_param.titulo		= 'Listado de SubCategorias de Articulos'
lstr_param.opcion   	= 30
lstr_param.tipo		= ''


OpenWithParm( w_abc_seleccion_lista_search, lstr_param)

end event

type cbx_subcateg from checkbox within w_ve776_pendientes_vs_clientes
integer x = 1157
integer y = 64
integer width = 539
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Filtrar x Subcateg"
boolean checked = true
end type

event clicked;if this.checked then
	cb_subcategoria.enabled = false
else
	cb_subcategoria.enabled = true
end if
end event

type cb_1 from commandbutton within w_ve776_pendientes_vs_clientes
integer x = 2802
integer y = 44
integer width = 443
integer height = 180
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Reporte"
end type

event clicked;Parent.Event ue_retrieve()
end event

type dw_report from u_dw_rpt within w_ve776_pendientes_vs_clientes
integer y = 292
integer width = 3310
integer height = 1748
string dataobject = "d_rpt_pendientes_clientes_crt"
boolean livescroll = false
end type

event getfocus;call super::getfocus;gnvo_app.of_select_current_row( this )
end event

type gb_1 from groupbox within w_ve776_pendientes_vs_clientes
integer width = 3570
integer height = 272
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Datos"
end type

