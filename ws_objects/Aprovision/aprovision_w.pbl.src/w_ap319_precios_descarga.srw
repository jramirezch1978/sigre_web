$PBExportHeader$w_ap319_precios_descarga.srw
forward
global type w_ap319_precios_descarga from w_abc_master_smpl
end type
type uo_fecha from u_ingreso_rango_fechas within w_ap319_precios_descarga
end type
type cb_refresh from commandbutton within w_ap319_precios_descarga
end type
type gb_1 from groupbox within w_ap319_precios_descarga
end type
end forward

global type w_ap319_precios_descarga from w_abc_master_smpl
integer width = 2789
integer height = 2000
string title = "[AP319] Modificar precios del parte de recepcion MP"
string menuname = "m_mantto_tablas"
uo_fecha uo_fecha
cb_refresh cb_refresh
gb_1 gb_1
end type
global w_ap319_precios_descarga w_ap319_precios_descarga

on w_ap319_precios_descarga.create
int iCurrent
call super::create
if this.MenuName = "m_mantto_tablas" then this.MenuID = create m_mantto_tablas
this.uo_fecha=create uo_fecha
this.cb_refresh=create cb_refresh
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_fecha
this.Control[iCurrent+2]=this.cb_refresh
this.Control[iCurrent+3]=this.gb_1
end on

on w_ap319_precios_descarga.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_fecha)
destroy(this.cb_refresh)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;ii_lec_mst = 0    //Hace que no se haga el retrieve de dw_master
end event

event ue_refresh;call super::ue_refresh;Date 	ld_fecha1, ld_fecha2
ld_fecha1 = uo_fecha.of_get_fecha1()
ld_fecha2 = uo_fecha.of_get_fecha2()

dw_master.retrieve( ld_fecha1, ld_fecha2 )
end event

type dw_master from w_abc_master_smpl`dw_master within w_ap319_precios_descarga
integer y = 176
integer width = 2715
integer height = 1628
string dataobject = "d_abc_precio_descarga_det_tbl"
end type

event dw_master::constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
//idw_det  =  				// dw_detail
end event

event dw_master::doubleclicked;call super::doubleclicked;string ls_columna
if not this.is_protect(dwo.name, row) and row > 0 then
	ls_columna = upper(dwo.name)
	THIS.event dynamic ue_display(ls_columna, row)
end if
end event

event dw_master::ue_display;call super::ue_display;boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql
Long		ll_row
choose case lower(as_columna)
	case "bahia"

		ls_sql = "select p.proveedor as facturador, " &
				 + "       p.nom_proveedor as nom_facturador, " &
				 + "       decode(p.tipo_doc_ident, '6', p.ruc, p.nro_doc_ident) as ruc_dni " &
				 + "  from proveedor p " &
				 + " where p.flag_estado = '1'"
				 
		if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, '2') then
			this.object.bahia			[al_row] = ls_codigo
			this.object.nom_bahia	[al_row] = ls_data
			this.ii_update = 1
			
			if al_row < this.RowCount() then
				if MessageBox('Pregunta', 'Desea aplicar el mismo BAHIA para los registros restantes?', &
								Information!, YesNo!, 2) = 2 then
					return 
				end if
				
				for ll_row = al_row + 1 to this.RowCount()
					yield()
					this.object.bahia			[ll_row] = ls_codigo
					this.object.nom_bahia	[ll_row] = ls_data
					yield()
				next
			end if
		end if
		
	case "facturador"

		ls_sql = "select p.proveedor as facturador, " &
				 + "       p.nom_proveedor as nom_facturador, " &
				 + "       decode(p.tipo_doc_ident, '6', p.ruc, p.nro_doc_ident) as ruc_dni " &
				 + "  from proveedor p " &
				 + " where p.flag_estado = '1'"
				 
		if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, '2') then
			this.object.facturador		[al_row] = ls_codigo
			this.object.nom_Facturador	[al_row] = ls_data
			this.ii_update = 1
			
			if al_row < this.RowCount() then
				if MessageBox('Pregunta', 'Desea aplicar el mismo FACTURADOR para los registros restantes?', &
								Information!, YesNo!, 2) = 2 then
					return 
				end if
				
				for ll_row = al_row + 1 to this.RowCount()
					this.object.facturador		[ll_row] = ls_codigo
					this.object.nom_facturador	[ll_row] = ls_data
				next
			end if
		end if

	case "cod_moneda"

		ls_sql = "Select cod_moneda as codigo_moneda, " &
				 + "descripcion as descripcion_moneda " &
				 + "from moneda " &
				 + "where flag_estado = '1'"
				 
		if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, '2') then
			this.object.cod_moneda	[al_row] = ls_codigo
			this.ii_update = 1
			
			if al_row < this.RowCount() then
				if MessageBox('Pregunta', 'Desea aplicar la misma MONEDA DE VENTA para los registros restantes?', &
								Information!, YesNo!, 2) = 2 then
					return 
				end if
				
				for ll_row = al_row + 1 to this.RowCount()
					this.object.cod_moneda	[ll_row] = ls_codigo
		
				next
			end if
			
		end if

	case "moneda_proceso"

		ls_sql = "Select cod_moneda as codigo_moneda, " &
				 + "descripcion as descripcion_moneda " &
				 + "from moneda " &
				 + "where flag_estado = '1'"
				 
		if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, '2') then
			
			this.object.moneda_proceso	[al_row] = ls_codigo
			this.ii_update = 1
			
			if al_row < this.RowCount() then
				if MessageBox('Pregunta', 'Desea aplicar la misma MONEDA DE PROCESO para los registros restantes?', &
								Information!, YesNo!, 2) = 2 then
					return 
				end if
				
				for ll_row = al_row + 1 to this.RowCount()
					this.object.moneda_proceso	[ll_row] = ls_codigo
		
				next
			end if
			
		
			
		end if		

	case "servicio_proc"

		ls_sql = "select s.servicio as codigo_servicio, " &
				 + "       s.descripcion as desc_servicio " &
				 + "from servicios s " &
				 + "where s.flag_estado = '1'"

		if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, '2') then
			
			this.object.servicio_proc	[al_row] = ls_codigo
			this.object.desc_servicio	[al_row] = ls_data
			
			this.ii_update = 1
			
			if al_row < this.RowCount() then
				if MessageBox('Pregunta', 'Desea aplicar el mismo tipo de SERVICIO para los registros restantes?', &
								Information!, YesNo!, 2) = 2 then
					return 
				end if
				
				for ll_row = al_row + 1 to this.RowCount()
					this.object.servicio_proc	[ll_row] = ls_codigo
					this.object.desc_servicio	[ll_row] = ls_data
				next
			end if
			
		
			
		end if				

end choose



end event

event dw_master::itemchanged;call super::itemchanged;Long 		ll_row
String	ls_data

this.Accepttext()

CHOOSE CASE dwo.name
	CASE 'bahia'
		
		// Verifica que codigo ingresado exista			
		Select nom_proveedor
	     into :ls_data
		  from proveedor p
		 Where proveedor = :data  
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "El codigo de BAHIA " + data + " no Existe o no se encuentra activo, por favor verifique")
			this.object.bahia			[row] = gnvo_app.is_null
			this.object.nom_bahia	[row] = gnvo_app.is_null
			return 1
			
		end if

		this.object.nom_bahia		[row] = ls_data
		
		if row < this.RowCount() then
			if MessageBox('Pregunta', 'Desea aplicar el mismo BAHIA para los registros restantes?', &
							Information!, YesNo!, 2) = 2 then
				return 1
			end if
			
			for ll_row = row + 1 to this.RowCount()
				yield()
				this.object.bahia			[ll_row] = data
				this.object.nom_bahia	[ll_row] = ls_data
				yield()
			next
		end if	
		
	CASE 'facturador'
		
		// Verifica que codigo ingresado exista			
		Select nom_proveedor
	     into :ls_data
		  from proveedor p
		 Where proveedor = :data  
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "El codigo de facturador " + data + " no Existe o no se encuentra activo, por favor verifique")
			this.object.facturador		[row] = gnvo_app.is_null
			this.object.nom_facturador	[row] = gnvo_app.is_null
			return 1
			
		end if

		this.object.nom_facturador		[row] = ls_data
		
		if row < this.RowCount() then
			if MessageBox('Pregunta', 'Desea aplicar el mismo FACTURADOR para los registros restantes?', &
							Information!, YesNo!, 2) = 2 then
				return 1
			end if
			
			for ll_row = row + 1 to this.RowCount()
				this.object.facturador		[ll_row] = data
				this.object.nom_facturador	[ll_row] = ls_data
			next
		end if	
		
	CASE 'servicio_proc'
		
		// Verifica que codigo ingresado exista			
		Select descripcion
	     into :ls_data
		  from servicios
		 Where servicio = :data  
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "No existe Tipo de SERVICIO " + data + " o no se encuentra activo, por favor verifique")
			this.object.servicio_proc	[row] = gnvo_app.is_null
			this.object.desc_servicio	[row] = gnvo_app.is_null
			return 1
			
		end if

		this.object.desc_servicio		[row] = ls_data
		
		if row < this.RowCount() then
			if MessageBox('Pregunta', 'Desea aplicar el mismo TIPO DE SERVICIO para los registros restantes?', &
							Information!, YesNo!, 2) = 2 then
				return 1
			end if
			
			for ll_row = row + 1 to this.RowCount()
				this.object.servicio_proc	[ll_row] = data
				this.object.desc_servicio	[ll_row] = ls_data
			next
		end if	


	CASE 'moneda_proceso'
	
		if row < this.RowCount() then
			if MessageBox('Pregunta', 'Desea aplicar la misma MONEDA DE PROCESO para los registros restantes?', &
							Information!, YesNo!, 2) = 2 then
				return 1
			end if
			
			for ll_row = row + 1 to this.RowCount()
				this.object.moneda_proceso	[ll_row] = data
	
			next
		end if		

	CASE 'precio_venta'
	
		if row < this.RowCount() and row > 0 then
			if MessageBox('Pregunta', 'Desea aplicar el mismo PRECIO DE VENTA para los registros restantes?', &
							Information!, YesNo!, 2) = 2 then
				return 1
			end if
			
			for ll_row = row + 1 to this.RowCount()
				this.object.precio_venta	[ll_row] = Dec(data)
	
			next
		end if
		
	CASE 'precio_proceso'
	
		if row < this.RowCount() and row > 0 then
			if MessageBox('Pregunta', 'Desea aplicar el mismo PRECIO DE PROCESO para los registros restantes?', &
							Information!, YesNo!, 2) = 2 then
				return 1
			end if
			
			for ll_row = row + 1 to this.RowCount()
				this.object.precio_proceso	[ll_row] = Dec(data)
	
			next
		end if

	CASE 'flag_exo_igv_proceso'
	
		if row < this.RowCount() then
			if MessageBox('Pregunta', 'Desea aplicar el mismo CONCEPTO DE EXONERACION DE IGV para los registros restantes?', &
							Information!, YesNo!, 2) = 2 then
				return 1
			end if
			
			for ll_row = row + 1 to this.RowCount()
				this.object.flag_exo_igv_proceso	[ll_row] = data
	
			next
		end if	

	CASE 'flag_incluye_igv_proceso'
	
		if row < this.RowCount() then
			if MessageBox('Pregunta', 'Desea aplicar el mismo CONCEPTO DE INCLUSION DE IGV para los registros restantes?', &
							Information!, YesNo!, 2) = 2 then
				return 1
			end if
			
			for ll_row = row + 1 to this.RowCount()
				this.object.flag_incluye_igv_proceso	[ll_row] = data
	
			next
		end if		
END CHOOSE
end event

type uo_fecha from u_ingreso_rango_fechas within w_ap319_precios_descarga
event destroy ( )
integer x = 14
integer y = 56
integer taborder = 80
boolean bringtotop = true
end type

on uo_fecha.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;Date ld_fecha1, ld_fecha2

ld_fecha2 = DAte(gnvo_app.of_fecha_actual( ))

ld_fecha1 = Date('01/' + string(ld_fecha2, 'mm/yyyy'))

of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
of_set_fecha(ld_fecha1, ld_fecha2) //para setear la fecha inicial
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final

end event

type cb_refresh from commandbutton within w_ap319_precios_descarga
integer x = 1307
integer y = 48
integer width = 439
integer height = 100
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Recuperar"
end type

event clicked;parent.event ue_refresh( )
end event

type gb_1 from groupbox within w_ap319_precios_descarga
integer width = 2725
integer height = 172
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Filtro de Busqueda"
end type

