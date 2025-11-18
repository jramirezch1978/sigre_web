$PBExportHeader$w_ap316_recibo_cajas.srw
forward
global type w_ap316_recibo_cajas from w_abc_master_smpl
end type
end forward

global type w_ap316_recibo_cajas from w_abc_master_smpl
integer width = 2962
integer height = 2320
string title = "[AP316] Recibo de Entrega de cajas"
string menuname = "m_mantto_consulta"
end type
global w_ap316_recibo_cajas w_ap316_recibo_cajas

type variables
String 	is_soles, is_salir
end variables

forward prototypes
public function integer of_get_param ()
public function integer of_set_numera ()
public function boolean of_get_precio (string as_proveedor, string as_especie, long al_row)
end prototypes

public function integer of_get_param ();// Evalua parametros
string 	ls_mensaje

// busca tipos de movimiento definidos
SELECT 	cod_soles
	INTO 	:is_soles
FROM logparam 
where reckey = '1';

if sqlca.sqlcode = 100 then
	Messagebox( "Error", "no ha definido parametros en Logparam")
	return 0
end if

if sqlca.sqlcode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	Messagebox( "Error", ls_mensaje)
	return 0
end if



return 1
end function

public function integer of_set_numera ();// Numera documento
Long 		ll_ult_nro, ll_count
string	ls_mensaje, ls_nro, ls_table

if is_action = 'new' then

	ls_table = 'LOCK TABLE num_ap_recibo_cajas IN EXCLUSIVE MODE'
	EXECUTE IMMEDIATE :ls_table ;
	
	Select count(*) 
		into :ll_count
	from num_ap_recibo_cajas 
	where origen = :gs_origen;
	
	IF ll_count = 0 then
		Insert into num_ap_recibo_cajas (origen, ult_nro)
			values( :gs_origen, 1);
		
		IF SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Aviso', ls_mensaje)
			return 0
		end if
	end if
	
	Select ult_nro 
		into :ll_ult_nro 
	from num_ap_recibo_cajas 
	where origen = :gs_origen for update;
	
	// Asigna numero a cabecera
	ls_nro = TRIM( gs_origen) + trim(string(ll_ult_nro, '00000000'))
	
	dw_master.object.nro_recibo[dw_master.getrow()] = ls_nro
	// Incrementa contador
	Update num_ap_recibo_cajas 
		set ult_nro = :ll_ult_nro + 1 
	 where origen = :gs_origen;
	
	IF SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Aviso', ls_mensaje)
		return 0
	end if
		
else 
	ls_nro = dw_master.object.nro_recibo[dw_master.getrow()] 
end if

// Asigna numero a detalle
//dw_master.object.nro_oc[dw_master.getrow()] = ls_nro
//for j = 1 to dw_detail.RowCount()	
//	dw_detail.object.nro_doc[j] = ls_nro	
//next
return 1
end function

public function boolean of_get_precio (string as_proveedor, string as_especie, long al_row);string 	ls_moneda
Decimal	ldc_precio
Date		ld_fecha

ld_fecha	= Date(dw_master.object.fec_parte [al_row])

select p.cod_moneda, p.importe
	into :ls_moneda, :ldc_precio
from ap_prov_mp_tarifa p
where p.proveedor = :as_proveedor
  and p.especie   = :as_especie
  and trunc(:ld_fecha) between trunc(p.fecha_inicio) and trunc(p.fecha_fin);
  

if SQLCA.SQLCode = 100 then
	MessageBox('Error', 'El proveedor no tiene especificado un precio de materia prima, por favor verifique')
	return false
end if

dw_master.object.moneda 		[al_Row] = ls_moneda
dw_master.object.precio_unit 	[al_Row] = ldc_precio

return true

end function

on w_ap316_recibo_cajas.create
call super::create
if this.MenuName = "m_mantto_consulta" then this.MenuID = create m_mantto_consulta
end on

on w_ap316_recibo_cajas.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre;call super::ue_open_pre;if of_get_param() = 0 then 
   is_salir = 'S'
	post event closequery()   
	return
end if

ii_lec_mst = 0 
end event

event ue_update_pre;call super::ue_update_pre;ib_update_check = False
// Verifica que campos son requeridos y tengan valores
if f_row_Processing( dw_master, dw_master.is_dwform) <> true then return

if of_set_numera() = 0 then return	

ib_update_check = true

dw_master.of_set_flag_replicacion()

end event

event ue_update;//Override

Boolean  lbo_ok = TRUE
String	ls_msg

dw_master.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF ib_log THEN
	Datastore		lds_log
	lds_log = Create DataStore
	lds_log.DataObject = 'd_log_diario_tbl'
	lds_log.SetTransObject(SQLCA)
	//in_log.of_create_log(dw_master, lds_log, is_colname, is_coltype, gs_user, is_tabla)
END IF

IF	dw_master.ii_update = 1 THEN
	IF dw_master.Update(true, false) = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		MessageBox('Error en Base de Datos', 'No se pudo grabar Maestro')
	END IF
END IF

IF ib_log THEN
	IF lbo_ok THEN
		IF lds_log.Update(true, false) = -1 THEN
			lbo_ok = FALSE
			ROLLBACK USING SQLCA;
			MessageBox('Error en Base de Datos', 'No se pudo grabar el Log Diario')
		END IF
	END IF
	DESTROY lds_log
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0
	dw_master.il_totdel = 0
	
	dw_master.ResetUpdate( )
	
	dw_master.Retrieve(dw_master.object.nro_recibo[dw_master.getRow()])
END IF

end event

type dw_master from w_abc_master_smpl`dw_master within w_ap316_recibo_cajas
integer x = 0
integer y = 0
integer width = 2880
integer height = 2068
string dataobject = "d_abc_recibo_caja_ff"
end type

event dw_master::constructor;call super::constructor;is_dwform = 'form'	// tabular, form (default)
ii_ck[1] = 1				// columnas de lectrua de este dw
end event

event dw_master::doubleclicked;call super::doubleclicked;string ls_columna
long ll_row 
str_seleccionar lstr_seleccionar

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;Date d_FechaActual, d_FechaInicio 
Long l_Semana 

d_FechaActual = Date(f_fecha_actual())
d_FechaInicio = Date('01/01/'+String(Year(d_FechaActual))) 
l_Semana = DaysAfter(d_FechaInicio, d_FechaActual) / 7 + 1

this.object.flag_estado 	[al_row] = '1'
this.object.fec_registro	[al_row] = f_fecha_actual()
this.object.fec_parte		[al_row] = d_FechaActual
this.object.nro_Semana		[al_row] = l_Semana
this.object.cod_origen		[al_row] = gs_origen

this.object.cajas_1			[al_row] = 0
this.object.cajas_2			[al_row] = 0
this.object.cajas_3			[al_row] = 0
this.object.cajas_4			[al_row] = 0

this.object.fundas_1			[al_row] = 0
this.object.fundas_2			[al_row] = 0
this.object.fundas_3			[al_row] = 0
this.object.fundas_4			[al_row] = 0

this.object.peso_cajas		[al_row] = 0.00
this.object.nro_racimos		[al_row] = 0
this.object.precio_unit		[al_row] = 0.00

this.object.moneda			[al_row] = is_soles

is_Action = "new"
end event

event dw_master::itemchanged;call super::itemchanged;String 	ls_null, ls_desc1, ls_desc2, ls_productor
Long 		ll_count
Date		ld_fecha

dw_master.Accepttext()
Accepttext()
SetNull( ls_null)

CHOOSE CASE dwo.name
	CASE 'fec_parte'
		
		// Verifica que codigo ingresado exista			
		Date d_FechaActual 
		Date d_FechaInicio 
		Long l_Semana 
		d_FechaActual = Date(this.object.fec_parte [row])
		d_FechaInicio = Date('01/01/'+String(Year(d_FechaActual))) 
		l_Semana = DaysAfter(d_FechaInicio, d_FechaActual) / 7 + 1
		
		this.object.nro_semana [row] = l_Semana

	case "productor"
		
		// Verifica que codigo ingresado exista			
		Select p.nom_proveedor, ap.nro_certificado
			into :ls_desc1, :ls_desc2
	  	FROM ap_proveedor_mp ap, 
		     proveedor		  p 
		where ap.proveedor    = p.proveedor 
		   and p.flag_estado  = '1' 
		   and ap.flag_estado = '1' 
			and ap.proveedor   = :data;
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "No existe Código de proveedor o no se encuentra activo, por favor verifique")
			this.object.productor			[row] = ls_null
			this.object.desc_productor		[row] = ls_null
			this.object.nro_certificado	[row] = ls_null
			return 1
			
		end if

		this.object.desc_productor		[row] = ls_desc1
		this.object.nro_certificado	[row] = ls_desc2

	case "almacen_mp"
		// Verifica que codigo ingresado exista			
		Select a.desc_almacen
			into :ls_desc1
	  	FROM almacen a
		where a.flag_estado = '1' 
		  and a.flag_tipo_Almacen = 'P'
		  and a.almacen   = :data;
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "No existe Código de Almacén, no se encuentra activo o no es de materia prima, por favor verifique")
			this.object.almacen_mp			[row] = ls_null
			this.object.desc_almacen_mp	[row] = ls_null
			return 1
			
		end if

		this.object.desc_almacen_mp		[row] = ls_desc1
		
	case "almacen_pptt"
		// Verifica que codigo ingresado exista			
		Select a.desc_almacen
			into :ls_desc1
	  	FROM almacen a
		where a.flag_estado = '1' 
		  and a.flag_tipo_Almacen = 'T'
		  and a.almacen   = :data;
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "No existe Código de Almacén, no se encuentra activo o no es de Producto Terminado, por favor verifique")
			this.object.almacen_pptt		[row] = ls_null
			this.object.desc_almacen_pptt	[row] = ls_null
			return 1
			
		end if

		this.object.desc_almacen_pptt		[row] = ls_desc1
		
	case "importador"
		// Verifica que codigo ingresado exista			
		Select p.nom_proveedor
			into :ls_desc1
	  	FROM proveedor		  p 
		where p.flag_estado  = '1' 
		  and p.proveedor   = :data;
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "No existe Código de Importador o no se encuentra activo, por favor verifique")
			this.object.importador			[row] = ls_null
			this.object.desc_importador	[row] = ls_null
			return 1
		end if

		this.object.desc_importador	[row] = ls_desc1
		
	case "cod_empacadora"

		// Verifica que codigo ingresado exista			
		Select p.desc_empacadora
			into :ls_desc1
	  	FROM ap_empacadora  p 
		where p.flag_estado  = '1' 
		  and p.cod_empacadora   = :data;
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "No existe Código de empacadora o no se encuentra activo, por favor verifique")
			this.object.cod_empacadora		[row] = ls_null
			this.object.desc_empacadora	[row] = ls_null
			return 1
		end if

		this.object.desc_empacadora	[row] = ls_desc1
		
	case "especie"
		
		ls_productor = this.object.productor[row]
		
		if IsNull(ls_productor) or ls_productor = '' then
			MessageBox('Error', 'Primero debe ingresar un codigo de productor')
			this.setColumn('productor')
			return
		end if
		
		ld_fecha = date(this.object.fec_parte[row])
		
		// Verifica que codigo ingresado exista			
		Select p.descr_especie
			into :ls_desc1
	  	FROM tg_especies  p 
		where p.flag_estado  = '1' 
		  and p.especie   = :data;
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "No existe Código de Especie o no se encuentra activo, por favor verifique")
			this.object.especie			[row] = ls_null
			this.object.desc_especie	[row] = ls_null
			return 1
		end if

		if of_get_precio(ls_productor, data, row) then
			this.object.desc_especie	[row] = ls_desc1
		end if
		

	case "cod_cuadrilla"
		
		// Verifica que codigo ingresado exista			
		Select p.desc_cuadrilla
			into :ls_desc1
	  	FROM ap_cuadrilla  p 
		where p.flag_estado  = '1' 
		  and p.cod_cuadrilla   = :data;
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "No existe Código de Cuadrilla o no se encuentra activo, por favor verifique")
			this.object.cod_cuadrilla			[row] = ls_null
			return 1
		end if


	case "moneda"

		// Verifica que codigo ingresado exista			
		Select p.descripcion
			into :ls_desc1
	  	FROM moneda  p 
		where p.flag_estado  = '1' 
		  and p.cod_moneda   = :data;
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "No existe Código de Moneda o no se encuentra activo, por favor verifique")
			this.object.cod_moneda			[row] = ls_null
			return 1
		end if

end choose


end event

event dw_master::ue_display;call super::ue_display;boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_data2, ls_productor
date		ld_fecha
choose case lower(as_columna)
		
	case "productor"

		ls_sql = "SELECT ap.proveedor AS codigo_productor, " &
				  + "p.nom_proveedor as nom_productor, " &
				  + "ap.nro_certificado as numero_certificado, " &
				  + "p.nro_doc_ident as dni_productor " &
				  + "FROM ap_proveedor_mp ap, " &
				  + "     proveedor		  p " &
				  + "where ap.proveedor = p.proveedor " & 
				  + "  and p.flag_estado = '1' " &
				  + "  and ap.flag_estado = '1' " &
				  
				 
		lb_ret = f_lista_3ret(ls_sql, ls_codigo, ls_data, ls_data2, '2')
		
		if ls_codigo <> '' then
			this.object.productor			[al_row] = ls_codigo
			this.object.nom_productor		[al_row] = ls_data
			this.object.nro_Certificado	[al_row] = ls_data2
			this.ii_update = 1
		end if
	
	case "centro_benef"

		ls_sql = "SELECT cb.centro_benef AS centro_beneficio, " &
				  + "cb.desc_centro as descripcion_centro_beneficio " &
				  + "FROM centro_beneficio cb " &
				  + "where cb.flag_estado = '1' " &
				  
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.centro_benef	[al_row] = ls_codigo
			this.object.desc_centro		[al_row] = ls_data
			this.ii_update = 1
		end if

	case "importador"

		ls_sql = "SELECT p.proveedor AS codigo_importador, " &
				  + "p.nom_proveedor as nombre_importador, " &
				  + "p.nro_doc_ident as dni_importador, " &
				  + "p.ruc as ruc_importador " &
				  + "FROM proveedor p " &
				  + "where p.flag_estado = '1' " 
				  
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.importador			[al_row] = ls_codigo
			this.object.desc_importador	[al_row] = ls_data
			this.ii_update = 1
		end if		
	
	case "almacen_mp"

		ls_sql = "SELECT a.almacen AS codigo_almacen, " &
				  + "a.desc_almacen as descripcion_almacen " &
				  + "FROM almacen a " &
				  + "where a.flag_estado = '1' " &
				  + "  and a.flag_tipo_almacen = 'P'"
				  
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.almacen_mp			[al_row] = ls_codigo
			this.object.desc_almacen_mp	[al_row] = ls_data
			this.ii_update = 1
		end if		
		
	case "almacen_pptt"

		ls_sql = "SELECT a.almacen AS codigo_almacen, " &
				  + "a.desc_almacen as descripcion_almacen " &
				  + "FROM almacen a " &
				  + "where a.flag_estado = '1' " &
				  + "  and a.flag_tipo_almacen = 'T'"
				  
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.almacen_pptt		[al_row] = ls_codigo
			this.object.desc_almacen_pptt	[al_row] = ls_data
			this.ii_update = 1
		end if		

	case "cod_empacadora"

		ls_sql = "SELECT e.cod_empacadora  AS codigo_empacadora, " &
				  + "e.desc_empacadora as descripcion_empacadora, " &
				  + "s.desc_sector as descripcion_sector " &
				  + "FROM ap_empacadora e, " &
				  + "     ap_sectores   s " &
				  + "where e.cod_sector = s.cod_sector " & 
				  + "  and e.flag_estado = '1' " 
				  
				 
		lb_ret = f_lista_3ret(ls_sql, ls_codigo, ls_data, ls_data2, '2')
		
		if ls_codigo <> '' then
			this.object.cod_empacadora		[al_row] = ls_codigo
			this.object.desc_empacadora	[al_row] = ls_data
			this.object.desc_sector 		[al_row] = ls_data2
			this.ii_update = 1
		end if		

	case "especie"
		
		ls_productor = this.object.productor[al_row]
		
		if IsNull(ls_productor) or ls_productor = '' then
			MessageBox('Error', 'Primero debe ingresar un codigo de productor')
			this.setColumn('productor')
			return
		end if
		
		ld_fecha = date(this.object.fec_parte[al_row])
		
		ls_sql = "SELECT distinct e.especie  AS codigo_especie, " &
				  + "		  e.descr_especie as descripcion_especie " &
				  + "FROM tg_especies e, " &
				  + "     ap_prov_mp_tarifa p " &
				  + "where e.especie = p.especie " &
				  + "  and e.flag_estado = '1' " &
				  + "  and p.proveedor = '" + ls_productor + "' " &
				  + "  and to_date('" + string(ld_fecha, 'dd/mm/yyyy') + "', 'dd/mm/yyyy') between trunc(p.fecha_inicio) and trunc(p.fecha_fin)"
				  
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			if of_get_precio(ls_productor, ls_codigo, al_row) then
				this.object.especie			[al_row] = ls_codigo
				this.object.desc_especie	[al_row] = ls_data
				this.ii_update = 1
			end if
			
		end if	

	case "cod_cuadrilla"

		ls_sql = "SELECT e.cod_cuadrilla  AS codigo_cuadrilla, " &
				  + "e.desc_cuadrilla as descripcion_cuadrilla " &
				  + "FROM ap_cuadrilla e " &
				  + "where e.flag_estado = '1' " 
				  
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.cod_cuadrilla		[al_row] = ls_codigo
			this.ii_update = 1
		end if	

	case "moneda"

		ls_sql = "SELECT e.cod_moneda  AS codigo_moneda, " &
				  + "e.descripcion as descripcion_moneda " &
				  + "FROM moneda e " &
				  + "where e.flag_estado = '1' " 
				  
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.moneda		[al_row] = ls_codigo
			this.ii_update = 1
		end if			

end choose



end event

event dw_master::ue_insert;//Override
long ll_row

IF is_mastdet = 'dd' OR is_mastdet = 'd' THEN
	IF idw_mst.il_row = 0 THEN
		MessageBox("Error", "No ha seleccionado registro Maestro")
		RETURN - 1
	END IF
END IF

this.ResetUpdate()
this.Reset()

ll_row = THIS.InsertRow(0)				// insertar registro maestro

ib_insert_mode = True

IF ll_row = -1 then
	messagebox("Error en Ingreso","No se ha procedido",exclamation!)
ELSE
	ii_protect = 1
	of_protect() // desprotege el dw
	ii_update = 1
	il_row = ll_row
	THIS.Event ue_insert_pre(ll_row) // Asignaciones automaticas
	THIS.ScrollToRow(ll_row)			// ubicar el registro
	THIS.SetColumn(1)
	THIS.SetFocus()						// poner el focus en el primer campo
	IF is_mastdet = 'md' OR is_mastdet = 'dd' THEN idw_det.Reset() //borrar dw detalle
END IF

RETURN ll_row





end event

