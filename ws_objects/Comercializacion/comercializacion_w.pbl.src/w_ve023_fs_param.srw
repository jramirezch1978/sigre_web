$PBExportHeader$w_ve023_fs_param.srw
forward
global type w_ve023_fs_param from w_abc_master
end type
end forward

global type w_ve023_fs_param from w_abc_master
integer width = 2217
integer height = 1336
string title = "[VE023] Parámetros de Facturación Simplificada"
string menuname = "m_mantenimiento_sl"
boolean maxbox = false
boolean resizable = false
end type
global w_ve023_fs_param w_ve023_fs_param

on w_ve023_fs_param.create
call super::create
if this.MenuName = "m_mantenimiento_sl" then this.MenuID = create m_mantenimiento_sl
end on

on w_ve023_fs_param.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_update_pre;call super::ue_update_pre;ib_update_check = true

if f_row_processing( dw_master, 'tabular') = false then
	ib_update_check = false
	return
end if
end event

event ue_open_pre;call super::ue_open_pre;idw_1.retrieve()
end event

type dw_master from w_abc_master`dw_master within w_ve023_fs_param
integer width = 2112
integer height = 1060
string dataobject = "d_abc_fs_param_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = false
end type

event dw_master::constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 1 				// indica si se usa seleccion: 1=individual (default), 0=multiple

//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
idw_mst  = 	dw_master

end event

event dw_master::itemerror;call super::itemerror;RETURN 1
end event

event dw_master::doubleclicked;call super::doubleclicked;string ls_columna
long ll_row 

THIS.AcceptText()
IF THIS.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

IF row > 0 THEN
	ls_columna = upper(dwo.name)
	THIS.event dynamic ue_display(ls_columna, ll_row)
END IF




end event

event dw_master::ue_display;call super::ue_display;boolean lb_ret
string ls_codigo, ls_data, ls_sql
choose case lower(as_columna)
	case "cod_origen"
		ls_sql = "SELECT cod_origen AS codigo_origen, " &
				  + "nombre AS nombre_origen " &
				  + "FROM origen " &
				  + "WHERE FLAG_ESTADO = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

		if ls_codigo <> '' then
			this.object.cod_origen	[al_row] = ls_codigo
			this.ii_update = 1
		end if
		
	case "cod_moneda"
		ls_sql = "SELECT cod_moneda AS codigo_moneda, " &
				  + "descripcion AS descripcion_moneda " &
				  + "FROM moneda " &
				  + "WHERE FLAG_ESTADO = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.cod_moneda	[al_row] = ls_codigo
			this.object.desc_moneda	[al_row] = ls_data
			this.ii_update = 1
		end if
		
	case "forma_pago"
		ls_sql = "SELECT forma_pago AS forma_pago, " &
				  + "desc_forma_pago AS descripcion_forma_pago " &
				  + "FROM forma_pago " &
				  + "WHERE FLAG_ESTADO = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.forma_pago		[al_row] = ls_codigo
			this.object.desc_forma_pago[al_row] = ls_data
			this.ii_update = 1
		end if

	case "tipo_impuesto"
		ls_sql = "SELECT tipo_impuesto AS tipo_impuesto, " &
				  + "desc_impuesto AS descripcion_tipo_impuesto " &
				  + "FROM impuestos_tipo " 

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.tipo_impuesto	[al_row] = ls_codigo
			this.object.desc_impuesto	[al_row] = ls_data
			this.ii_update = 1
		end if

	case "motivo_traslado"
		ls_sql = "SELECT motivo_traslado AS motivo_traslado, " &
				  + "descripcion AS descripcion_motivo " &
				  + "FROM motivo_traslado " 

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.motivo_traslado[al_row] = ls_codigo
			this.object.desc_motivo		[al_row] = ls_data
			this.ii_update = 1
		end if

	case "almacen"
		ls_sql = "SELECT almacen AS almacen, " &
				  + "desc_almacen AS descripcion_almacen " &
				  + "FROM almacen " &
				  + "where flag_estado = '1'"
				  

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.almacen		[al_row] = ls_codigo
			this.object.desc_almacen[al_row] = ls_data
			this.ii_update = 1
		end if

	case "punto_venta"
		ls_sql = "SELECT punto_venta AS punto_venta, " &
				  + "desc_pto_vta AS descripcion_punto_venta " &
				  + "FROM puntos_venta " &
				  + "where flag_estado = '1'"
				  

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.punto_venta	[al_row] = ls_codigo
			this.object.desc_pto_vta[al_row] = ls_data
			this.ii_update = 1
		end if

	case "forma_embarque"
		ls_sql = "SELECT forma_embarque AS forma_embarque, " &
				  + "DESCRIPCION AS descripcion_forma_embarque " &
				  + "FROM forma_embarque " &
				  + "where flag_estado = '1'"
				  

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.forma_embarque			[al_row] = ls_codigo
			this.object.desc_forma_embarque	[al_row] = ls_data
			this.ii_update = 1
		end if

end choose
end event

event dw_master::itemchanged;call super::itemchanged;String 	ls_null, ls_desc1, ls_desc2
Long 		ll_count

dw_master.Accepttext()
Accepttext()
SetNull( ls_null)

CHOOSE CASE dwo.name
		
	case "cod_origen"
		// Verifica que codigo ingresado exista			
		Select nombre
	     into :ls_desc1
		  from origen
		 Where cod_origen = :data  
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "no existe Código de Origen o no se encuentra activo, por favor verifique")
			this.object.cod_origen	[row] = ls_null
			return 1
			
		end if

	case "cod_moneda"
		// Verifica que codigo ingresado exista			
		Select descripcion
	     into :ls_desc1
		  from moneda
		 Where cod_moneda = :data  
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "no existe Código de moneda o no se encuentra activo, por favor verifique")
			this.object.cod_moneda	[row] = ls_null
			this.object.desc_moneda	[row] = ls_null
			return 1
		end if

		this.object.desc_moneda		[row] = ls_desc1
		
	case "forma_pago"
		// Verifica que codigo ingresado exista			
		Select desc_forma_pago
	     into :ls_desc1
		  from forma_pago
		 Where forma_pago = :data  
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "no existe Forma de Pago o no se encuentra activo, por favor verifique")
			this.object.forma_pago		[row] = ls_null
			this.object.desc_forma_pago[row] = ls_null
			return 1
		end if

		this.object.desc_forma_pago		[row] = ls_desc1

	case "tipo_impuesto"
		// Verifica que codigo ingresado exista			
		Select desc_impuesto
	     into :ls_desc1
		  from impuestos_tipo
		 Where tipo_impuesto = :data;
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "no existe Tipo de Impuesto o no se encuentra activo, por favor verifique")
			this.object.tipo_impuesto	[row] = ls_null
			this.object.desc_impuesto	[row] = ls_null
			return 1
		end if

		this.object.desc_impuesto		[row] = ls_desc1		

	case "motivo_traslado"
		// Verifica que codigo ingresado exista			
		Select descripcion
	     into :ls_desc1
		  from motivo_traslado
		 Where motivo_traslado = :data;
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "no existe Motivo de Traslado o no se encuentra activo, por favor verifique")
			this.object.motivo_traslado[row] = ls_null
			this.object.desc_motivo		[row] = ls_null
			return 1
		end if

		this.object.desc_motivo		[row] = ls_desc1		

	case "almacen"
		// Verifica que codigo ingresado exista			
		Select desc_almacen
	     into :ls_desc1
		  from almacen
		 Where almacen = :data
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "no existe Almacen o no se encuentra activo, por favor verifique")
			this.object.almacen		[row] = ls_null
			this.object.desc_almacen[row] = ls_null
			return 1
		end if

		this.object.desc_almacen		[row] = ls_desc1		

	case "punto_venta"
		// Verifica que codigo ingresado exista			
		Select desc_pto_vta
	     into :ls_desc1
		  from puntos_venta
		 Where punto_venta = :data
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "no existe Punto de Venta o no se encuentra activo, por favor verifique")
			this.object.punto_venta	[row] = ls_null
			this.object.desc_pto_vta[row] = ls_null
			return 1
		end if

		this.object.desc_pto_vta		[row] = ls_desc1		

	case "forma_embarque"
		// Verifica que codigo ingresado exista			
		Select DESCRIPCION
	     into :ls_desc1
		  from forma_embarque
		 Where forma_embarque = :data
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "no existe Punto de Venta o no se encuentra activo, por favor verifique")
			this.object.forma_embarque			[row] = ls_null
			this.object.desc_forma_embarque	[row] = ls_null
			return 1
		end if

		this.object.desc_forma_embarque		[row] = ls_desc1		

END CHOOSE
end event

