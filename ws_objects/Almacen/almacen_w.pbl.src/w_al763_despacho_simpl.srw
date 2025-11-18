$PBExportHeader$w_al763_despacho_simpl.srw
forward
global type w_al763_despacho_simpl from w_report_smpl
end type
type uo_fechas from u_ingreso_rango_fechas_v within w_al763_despacho_simpl
end type
type cb_3 from commandbutton within w_al763_despacho_simpl
end type
type sle_almacen from singlelineedit within w_al763_despacho_simpl
end type
type sle_descrip from singlelineedit within w_al763_despacho_simpl
end type
type cbx_1 from checkbox within w_al763_despacho_simpl
end type
type cbx_moviles from checkbox within w_al763_despacho_simpl
end type
type cb_moviles from commandbutton within w_al763_despacho_simpl
end type
type cbx_guias from checkbox within w_al763_despacho_simpl
end type
type cb_guias from commandbutton within w_al763_despacho_simpl
end type
type cbx_documentos from checkbox within w_al763_despacho_simpl
end type
type cb_comprobantes from commandbutton within w_al763_despacho_simpl
end type
type gb_1 from groupbox within w_al763_despacho_simpl
end type
type gb_2 from groupbox within w_al763_despacho_simpl
end type
end forward

global type w_al763_despacho_simpl from w_report_smpl
integer width = 3831
integer height = 1980
string title = "[AL763] Despacho resumido por GUIA - VEHICULO"
string menuname = "m_impresion"
uo_fechas uo_fechas
cb_3 cb_3
sle_almacen sle_almacen
sle_descrip sle_descrip
cbx_1 cbx_1
cbx_moviles cbx_moviles
cb_moviles cb_moviles
cbx_guias cbx_guias
cb_guias cb_guias
cbx_documentos cbx_documentos
cb_comprobantes cb_comprobantes
gb_1 gb_1
gb_2 gb_2
end type
global w_al763_despacho_simpl w_al763_despacho_simpl

type variables
Integer ii_index
end variables

on w_al763_despacho_simpl.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.uo_fechas=create uo_fechas
this.cb_3=create cb_3
this.sle_almacen=create sle_almacen
this.sle_descrip=create sle_descrip
this.cbx_1=create cbx_1
this.cbx_moviles=create cbx_moviles
this.cb_moviles=create cb_moviles
this.cbx_guias=create cbx_guias
this.cb_guias=create cb_guias
this.cbx_documentos=create cbx_documentos
this.cb_comprobantes=create cb_comprobantes
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_fechas
this.Control[iCurrent+2]=this.cb_3
this.Control[iCurrent+3]=this.sle_almacen
this.Control[iCurrent+4]=this.sle_descrip
this.Control[iCurrent+5]=this.cbx_1
this.Control[iCurrent+6]=this.cbx_moviles
this.Control[iCurrent+7]=this.cb_moviles
this.Control[iCurrent+8]=this.cbx_guias
this.Control[iCurrent+9]=this.cb_guias
this.Control[iCurrent+10]=this.cbx_documentos
this.Control[iCurrent+11]=this.cb_comprobantes
this.Control[iCurrent+12]=this.gb_1
this.Control[iCurrent+13]=this.gb_2
end on

on w_al763_despacho_simpl.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_fechas)
destroy(this.cb_3)
destroy(this.sle_almacen)
destroy(this.sle_descrip)
destroy(this.cbx_1)
destroy(this.cbx_moviles)
destroy(this.cb_moviles)
destroy(this.cbx_guias)
destroy(this.cb_guias)
destroy(this.cbx_documentos)
destroy(this.cb_comprobantes)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event ue_retrieve;call super::ue_retrieve;Date 		ld_desde, ld_hasta
String 	ls_alm
Long		ll_count

ld_desde = uo_fechas.of_get_fecha1()
ld_hasta = uo_fechas.of_get_fecha2()

SetPointer( Hourglass!)

if cbx_1.checked then
	ls_alm = '%%'
else
	ls_alm = trim(sle_almacen.text) 
end if

//Filtrar Placa - Chofer
if cbx_moviles.checked then
	
	delete TT_GUIA_PLACA_CHOFER;
	if gnvo_app.of_existsError(SQLCA, 'Eliminacion tabla TT_GUIA_PLACA_CHOFER' ) then
		rollback;
		return 
	end if	
	
	Insert into TT_GUIA_PLACA_CHOFER(nro_placa, nom_chofer)
	select distinct 
			 g.nro_placa, g.nom_chofer
	  from guia             g,
			 guia_vale        gv,
			 vale_mov         vm,
			 articulo_mov     am,
			 (select * 
				from articulo_mov_proy
			  where tipo_doc = (select doc_ov from logparam where reckey = '1')) amp,
			 orden_Venta      ov,
			 articulo         a,
			 sunat_ubigeo     su,
			 cntas_cobrar_det ccd
	 where g.nro_guia         = gv.nro_guia
		and gv.nro_vale        = vm.nro_vale
		and vm.nro_vale        = am.nro_Vale
		and am.cod_art         = a.cod_art
		and am.origen_mov_proy = amp.cod_origen 
		and am.nro_mov_proy    = amp.nro_mov    
		and amp.nro_doc        = ov.nro_ov      
		and g.ubigeo_dst       = su.ubigeo
		and am.cod_origen      = ccd.org_am     
		and am.nro_mov         = ccd.nro_am      
		and g.nro_placa        is not null
		and g.nom_chofer       is not null
		and trunc(vm.fec_registro) between :ld_desde and :ld_hasta
		and vm.almacen         like :ls_alm;

		
	if gnvo_app.of_existsError(SQLCA, 'Insert tabla TT_GUIA_PLACA_CHOFER' ) then
		rollback;
		return 
	end if	
		
	commit;

else
	select count(*)
		into :ll_count
	from TT_GUIA_PLACA_CHOFER;
	
	if ll_count = 0 then 
		MessageBox('Error', 'Debe seleccionar a una PLACA - CHOFER, por favor verifique!', StopSign!)
		return
	end if
end if

//Filtrar Guias de remisión
if cbx_guias.checked then
	
	delete TT_GUIAS;
	if gnvo_app.of_existsError(SQLCA, 'Eliminacion tabla TT_GUIAS' ) then
		rollback;
		return 
	end if	
	
	Insert into TT_GUIAS(nro_guia)
	select distinct 
			 g.nro_guia
	  from guia             g,
			 guia_vale        gv,
			 vale_mov         vm,
			 articulo_mov     am,
			 (select * 
				from articulo_mov_proy
			  where tipo_doc = (select doc_ov from logparam where reckey = '1')) amp,
			 orden_Venta      ov,
			 articulo         a,
			 sunat_ubigeo     su,
			 cntas_cobrar_det ccd
	 where g.nro_guia         = gv.nro_guia
		and gv.nro_vale        = vm.nro_vale
		and vm.nro_vale        = am.nro_Vale
		and am.cod_art         = a.cod_art
		and am.origen_mov_proy = amp.cod_origen 
		and am.nro_mov_proy    = amp.nro_mov    
		and amp.nro_doc        = ov.nro_ov      
		and g.ubigeo_dst       = su.ubigeo
		and am.cod_origen      = ccd.org_am     
		and am.nro_mov         = ccd.nro_am      
		and g.nro_placa        is not null
		and g.nom_chofer       is not null
		and g.nro_placa || '-' || g.nom_chofer in (select nro_placa || '-' || nom_chofer from TT_GUIA_PLACA_CHOFER)
		and trunc(vm.fec_registro) between :ld_desde and :ld_hasta
		and vm.almacen         like :ls_alm;

		
	if gnvo_app.of_existsError(SQLCA, 'Insert tabla TT_GUIAS' ) then
		rollback;
		return 
	end if	
		
	commit;

else
	select count(*)
		into :ll_count
	from TT_GUIAS;
	
	if ll_count = 0 then 
		MessageBox('Error', 'Debe seleccionar a una GUIA DE REMISION, por favor verifique!', StopSign!)
		return
	end if
end if

//Filtrar Comprobantes de Venta
if cbx_documentos.checked then
	
	delete TT_COMPROBANTES;
	if gnvo_app.of_existsError(SQLCA, 'Eliminacion tabla TT_COMPROBANTES' ) then
		rollback;
		return 
	end if	
	
	Insert into TT_COMPROBANTES(tipo_doc, nro_doc)
	select distinct 
			 ccd.tipo_doc,
			 ccd.nro_doc
	  from guia             g,
			 guia_vale        gv,
			 vale_mov         vm,
			 articulo_mov     am,
			 (select * 
				from articulo_mov_proy
			  where tipo_doc = (select doc_ov from logparam where reckey = '1')) amp,
			 orden_Venta      ov,
			 articulo         a,
			 sunat_ubigeo     su,
			 cntas_cobrar_det ccd,
			 proveedor        p
	 where g.nro_guia         = gv.nro_guia
		and gv.nro_vale        = vm.nro_vale
		and vm.nro_vale        = am.nro_Vale
		and am.cod_art         = a.cod_art
		and am.origen_mov_proy = amp.cod_origen 
		and am.nro_mov_proy    = amp.nro_mov    
		and amp.nro_doc        = ov.nro_ov      
		and g.ubigeo_dst       = su.ubigeo
		and am.cod_origen      = ccd.org_am     
		and am.nro_mov         = ccd.nro_am      
		and ov.cliente         = p.proveedor
		and g.nro_placa        is not null
		and g.nom_chofer       is not null
		and g.nro_placa || '-' || g.nom_chofer in (select nro_placa || '-' || nom_chofer from TT_GUIA_PLACA_CHOFER)
		and g.nro_guia in (select nro_guia from TT_GUIAS)
		and trunc(vm.fec_registro) between :ld_desde and :ld_hasta
		and vm.almacen         like :ls_alm;

		
	if gnvo_app.of_existsError(SQLCA, 'Insert tabla TT_COMPROBANTES' ) then
		rollback;
		return 
	end if	
		
	commit;

else
	select count(*)
		into :ll_count
	from TT_COMPROBANTES;
	
	if ll_count = 0 then 
		MessageBox('Error', 'Debe seleccionar un Comprobante de Venta, por favor verifique!', StopSign!)
		return
	end if
end if

dw_report.visible = true
ib_preview=false
this.event ue_preview()
//dw_report.SetTransObject( sqlca)

dw_report.retrieve(Ld_desde, ld_hasta, ls_alm )	
//dw_report.Object.DataWindow.Print.Orientation = 1
dw_report.object.t_titulo1.text 	= 'Del : ' + STRING(LD_DESDE, "DD/MM/YYYY") + ' Al : ' &
		+ STRING(LD_HASTA, "DD/MM/YYYY")		
dw_report.object.t_titulo2.text = sle_descrip.text		

dw_report.object.t_user.text 		= gs_user
dw_report.Object.p_logo.filename = gs_logo
dw_report.Object.t_empresa.text 	= gs_empresa
dw_report.Object.t_objeto.text 	= 'AL733'	

end event

type dw_report from w_report_smpl`dw_report within w_al763_despacho_simpl
integer x = 0
integer y = 368
integer width = 3259
integer height = 1036
string dataobject = "d_rpt_despacho_simplificado_cmp"
end type

type uo_fechas from u_ingreso_rango_fechas_v within w_al763_despacho_simpl
event destroy ( )
integer x = 59
integer y = 64
integer height = 212
integer taborder = 50
boolean bringtotop = true
long backcolor = 67108864
end type

on uo_fechas.destroy
call u_ingreso_rango_fechas_v::destroy
end on

event constructor;call super::constructor;String ls_desde

ls_desde = '01/' + string(month(today()))+'/' + string(year(today()))
uo_fechas.of_set_label("Desde","Hasta")
uo_fechas.of_set_fecha(date(ls_desde), today()) 				// para seatear el titulo del boton
uo_fechas.of_set_rango_inicio(DATE('01/01/1000'))
uo_fechas.of_set_rango_fin(DATE('31/12/9999'))

end event

type cb_3 from commandbutton within w_al763_despacho_simpl
integer x = 3310
integer y = 56
integer width = 393
integer height = 244
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Reporte"
end type

event clicked;Parent.event ue_retrieve()


end event

type sle_almacen from singlelineedit within w_al763_despacho_simpl
event dobleclick pbm_lbuttondblclk
integer x = 1458
integer y = 60
integer width = 224
integer height = 88
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 700
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
	    + "FROM almacen " 
				 
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
where almacen = :ls_almacen ;

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de Almacen no existe')
	return
end if

sle_descrip.text = ls_desc

end event

type sle_descrip from singlelineedit within w_al763_despacho_simpl
integer x = 1687
integer y = 60
integer width = 1157
integer height = 88
integer taborder = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
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

type cbx_1 from checkbox within w_al763_despacho_simpl
integer x = 814
integer y = 64
integer width = 635
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
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

type cbx_moviles from checkbox within w_al763_despacho_simpl
integer x = 818
integer y = 164
integer width = 640
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Filtrar Placa - Chofer"
boolean checked = true
end type

event clicked;if this.checked then
	cb_moviles.enabled = false
else
	cb_moviles.enabled = true
end if
end event

type cb_moviles from commandbutton within w_al763_despacho_simpl
integer x = 818
integer y = 240
integer width = 640
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
string text = "Elegir Placa - Chofer"
end type

event clicked;Long ll_count
Date 		ld_desde, ld_hasta
String 	ls_alm
str_parametros lstr_param 

ld_desde = uo_fechas.of_get_fecha1()
ld_hasta = uo_fechas.of_get_fecha2()

if cbx_1.checked then
	ls_alm = '%%'
else
	ls_alm = trim(sle_almacen.text) 
end if


delete TT_GUIA_PLACA_CHOFER ;
commit;

lstr_param.dw1			= 'd_lista_nro_placa_chofer_tbl'
lstr_param.titulo		= 'Listado de Placa - Chofer'
lstr_param.opcion   	= 17
lstr_param.tipo		= '1D2D1S'
lstr_param.fecha1		= ld_desde
lstr_param.fecha2		= ld_hasta
lstr_param.string1	= ls_alm


OpenWithParm( w_abc_seleccion, lstr_param)
end event

type cbx_guias from checkbox within w_al763_despacho_simpl
integer x = 1467
integer y = 164
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
string text = "Filtrar por GUIA"
boolean checked = true
end type

event clicked;if this.checked then
	cb_guias.enabled = false
else
	cb_guias.enabled = true
end if
end event

type cb_guias from commandbutton within w_al763_despacho_simpl
integer x = 1467
integer y = 240
integer width = 539
integer height = 100
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Elegir Guia Rem."
end type

event clicked;Long ll_count
Date 		ld_desde, ld_hasta
String 	ls_alm
str_parametros lstr_param 

ld_desde = uo_fechas.of_get_fecha1()
ld_hasta = uo_fechas.of_get_fecha2()

if cbx_1.checked then
	ls_alm = '%%'
else
	ls_alm = trim(sle_almacen.text) 
end if

//Filtrar Placa - Chofer
if cbx_moviles.checked then
	
	delete TT_GUIA_PLACA_CHOFER;
	if gnvo_app.of_existsError(SQLCA, 'Eliminacion tabla TT_GUIA_PLACA_CHOFER' ) then
		rollback;
		return 
	end if	
	
	Insert into TT_GUIA_PLACA_CHOFER(nro_placa, nom_chofer)
	select distinct 
			 g.nro_placa, g.nom_chofer
	  from guia             g,
			 guia_vale        gv,
			 vale_mov         vm,
			 articulo_mov     am,
			 (select * 
				from articulo_mov_proy
			  where tipo_doc = (select doc_ov from logparam where reckey = '1')) amp,
			 orden_Venta      ov,
			 articulo         a,
			 sunat_ubigeo     su,
			 cntas_cobrar_det ccd
	 where g.nro_guia         = gv.nro_guia
		and gv.nro_vale        = vm.nro_vale
		and vm.nro_vale        = am.nro_Vale
		and am.cod_art         = a.cod_art
		and am.origen_mov_proy = amp.cod_origen 
		and am.nro_mov_proy    = amp.nro_mov    
		and amp.nro_doc        = ov.nro_ov      
		and g.ubigeo_dst       = su.ubigeo
		and am.cod_origen      = ccd.org_am     
		and am.nro_mov         = ccd.nro_am      
		and g.nro_placa        is not null
		and g.nom_chofer       is not null
		and trunc(vm.fec_registro) between :ld_desde and :ld_hasta
		and vm.almacen         like :ls_alm;

		
	if gnvo_app.of_existsError(SQLCA, 'Insert tabla TT_GUIA_PLACA_CHOFER' ) then
		rollback;
		return 
	end if	
		
	commit;

else
	select count(*)
		into :ll_count
	from TT_GUIA_PLACA_CHOFER;
	
	if ll_count = 0 then 
		MessageBox('Error', 'Debe seleccionar a una PLACA - CHOFER, por favor verifique!', StopSign!)
		return
	end if
end if


delete TT_GUIAS ;
commit;

lstr_param.dw1			= 'd_lista_guias_ubigeo_destino_tbl'
lstr_param.titulo		= 'Listado de Guias - Ubigeo Destino'
lstr_param.opcion   	= 18
lstr_param.tipo		= '1D2D1S'
lstr_param.fecha1		= ld_desde
lstr_param.fecha2		= ld_hasta
lstr_param.string1	= ls_alm


OpenWithParm( w_abc_seleccion, lstr_param)

end event

type cbx_documentos from checkbox within w_al763_despacho_simpl
integer x = 2021
integer y = 164
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
string text = "Filtrar x Comprobante"
boolean checked = true
end type

event clicked;if this.checked then
	cb_comprobantes.enabled = false
else
	cb_comprobantes.enabled = true
end if
end event

type cb_comprobantes from commandbutton within w_al763_despacho_simpl
integer x = 2021
integer y = 240
integer width = 539
integer height = 100
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Elegir comprobantes"
end type

event clicked;Long ll_count
Date 		ld_desde, ld_hasta
String 	ls_alm
str_parametros lstr_param 

ld_desde = uo_fechas.of_get_fecha1()
ld_hasta = uo_fechas.of_get_fecha2()

if cbx_1.checked then
	ls_alm = '%%'
else
	ls_alm = trim(sle_almacen.text) 
end if

//Filtrar Placa - Chofer
if cbx_moviles.checked then
	
	delete TT_GUIA_PLACA_CHOFER;
	if gnvo_app.of_existsError(SQLCA, 'Eliminacion tabla TT_GUIA_PLACA_CHOFER' ) then
		rollback;
		return 
	end if	
	
	Insert into TT_GUIA_PLACA_CHOFER(nro_placa, nom_chofer)
	select distinct 
			 g.nro_placa, g.nom_chofer
	  from guia             g,
			 guia_vale        gv,
			 vale_mov         vm,
			 articulo_mov     am,
			 (select * 
				from articulo_mov_proy
			  where tipo_doc = (select doc_ov from logparam where reckey = '1')) amp,
			 orden_Venta      ov,
			 articulo         a,
			 sunat_ubigeo     su,
			 cntas_cobrar_det ccd
	 where g.nro_guia         = gv.nro_guia
		and gv.nro_vale        = vm.nro_vale
		and vm.nro_vale        = am.nro_Vale
		and am.cod_art         = a.cod_art
		and am.origen_mov_proy = amp.cod_origen 
		and am.nro_mov_proy    = amp.nro_mov    
		and amp.nro_doc        = ov.nro_ov      
		and g.ubigeo_dst       = su.ubigeo
		and am.cod_origen      = ccd.org_am     
		and am.nro_mov         = ccd.nro_am      
		and g.nro_placa        is not null
		and g.nom_chofer       is not null
		and trunc(vm.fec_registro) between :ld_desde and :ld_hasta
		and vm.almacen         like :ls_alm;

		
	if gnvo_app.of_existsError(SQLCA, 'Insert tabla TT_GUIA_PLACA_CHOFER' ) then
		rollback;
		return 
	end if	
		
	commit;

else
	select count(*)
		into :ll_count
	from TT_GUIA_PLACA_CHOFER;
	
	if ll_count = 0 then 
		MessageBox('Error', 'Debe seleccionar a una PLACA - CHOFER, por favor verifique!', StopSign!)
		return
	end if
end if

//Filtrar Guias de remisión
if cbx_guias.checked then
	
	delete TT_GUIAS;
	if gnvo_app.of_existsError(SQLCA, 'Eliminacion tabla TT_GUIAS' ) then
		rollback;
		return 
	end if	
	
	Insert into TT_GUIAS(nro_guia)
	select distinct 
			 g.nro_guia
	  from guia             g,
			 guia_vale        gv,
			 vale_mov         vm,
			 articulo_mov     am,
			 (select * 
				from articulo_mov_proy
			  where tipo_doc = (select doc_ov from logparam where reckey = '1')) amp,
			 orden_Venta      ov,
			 articulo         a,
			 sunat_ubigeo     su,
			 cntas_cobrar_det ccd
	 where g.nro_guia         = gv.nro_guia
		and gv.nro_vale        = vm.nro_vale
		and vm.nro_vale        = am.nro_Vale
		and am.cod_art         = a.cod_art
		and am.origen_mov_proy = amp.cod_origen 
		and am.nro_mov_proy    = amp.nro_mov    
		and amp.nro_doc        = ov.nro_ov      
		and g.ubigeo_dst       = su.ubigeo
		and am.cod_origen      = ccd.org_am     
		and am.nro_mov         = ccd.nro_am      
		and g.nro_placa        is not null
		and g.nom_chofer       is not null
		and g.nro_placa || '-' || g.nom_chofer in (select nro_placa || '-' || nom_chofer from TT_GUIA_PLACA_CHOFER)
		and trunc(vm.fec_registro) between :ld_desde and :ld_hasta
		and vm.almacen         like :ls_alm;

		
	if gnvo_app.of_existsError(SQLCA, 'Insert tabla TT_GUIAS' ) then
		rollback;
		return 
	end if	
		
	commit;

else
	select count(*)
		into :ll_count
	from TT_GUIAS;
	
	if ll_count = 0 then 
		MessageBox('Error', 'Debe seleccionar a una GUIA DE REMISION, por favor verifique!', StopSign!)
		return
	end if
end if


delete TT_COMPROBANTES ;
commit;

lstr_param.dw1			= 'd_lista_comprobantes_tbl'
lstr_param.titulo		= 'Listado de Comprobantes de Venta'
lstr_param.opcion   	= 19
lstr_param.tipo		= '1D2D1S'
lstr_param.fecha1		= ld_desde
lstr_param.fecha2		= ld_hasta
lstr_param.string1	= ls_alm


OpenWithParm( w_abc_seleccion, lstr_param)

end event

type gb_1 from groupbox within w_al763_despacho_simpl
integer y = 8
integer width = 745
integer height = 348
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "  Fechas  : "
end type

type gb_2 from groupbox within w_al763_despacho_simpl
integer x = 763
integer y = 8
integer width = 2999
integer height = 348
integer taborder = 10
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
end type

