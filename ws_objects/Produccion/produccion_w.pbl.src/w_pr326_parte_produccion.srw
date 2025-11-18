$PBExportHeader$w_pr326_parte_produccion.srw
forward
global type w_pr326_parte_produccion from w_abc_mastdet
end type
end forward

global type w_pr326_parte_produccion from w_abc_mastdet
integer width = 3922
integer height = 1928
string title = "Partes de Producción (PR326)"
string menuname = "m_mantto_smpl"
end type
global w_pr326_parte_produccion w_pr326_parte_produccion

type variables

end variables

forward prototypes
public function integer of_set_numera ()
public subroutine of_retrieve (string as_nro_parte)
end prototypes

public function integer of_set_numera ();// Numera documento
Long 		ll_count, ll_ult_nro, ll_j
String  	ls_next_nro, ls_lock_table, ls_mensaje

if dw_master.getrow() = 0 then return 0

if is_action = 'new' then
	select count(*)
		into :ll_count
	from num_parte_prod
	where origen = :gs_origen;
	
	if ll_count = 0 then
		ls_lock_table = 'LOCK TABLE NUM_PARTE_PROD IN EXCLUSIVE MODE'
		EXECUTE IMMEDIATE :ls_lock_table ;
		
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Aviso', ls_mensaje)
			return 0
		end if
		
		insert into num_parte_prod(origen, ult_nro)
		values( :gs_origen, 1);
		
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Aviso', ls_mensaje)
			return 0
		end if
	
	end if
	
	SELECT ult_nro
	  INTO :ll_ult_nro
	FROM num_parte_prod
	where origen = :gs_origen for update;
	
	update num_parte_prod
		set ult_nro = ult_nro + 1
	where origen = :gs_origen;
	
	if SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Aviso', ls_mensaje)
		return 0
	end if
	
	ls_next_nro = trim(gs_origen) + string(ll_ult_nro, '00000000')
	
	dw_master.object.nro_parte[dw_master.getrow()] = ls_next_nro
	dw_master.ii_update = 1
else
	ls_next_nro = dw_master.object.nro_parte[dw_master.getrow()] 
end if

// Asigna numero a detalle
for ll_j = 1 to dw_detail.RowCount()
	dw_detail.object.nro_parte[ll_j] = ls_next_nro
next

return 1
end function

public subroutine of_retrieve (string as_nro_parte);//this.event ue_udpate_request()

dw_master.retrieve(as_nro_parte)
dw_detail.retrieve(as_nro_parte)
is_action = 'open'

dw_master.ii_update = 0
dw_master.ii_protect = 0
dw_master.of_protect()

dw_detail.ii_update = 0
dw_detail.ii_protect = 0
dw_detail.of_protect()

if dw_master.getRow() > 0 then dw_master.il_row = dw_master.getRow()

end subroutine

on w_pr326_parte_produccion.create
call super::create
if this.MenuName = "m_mantto_smpl" then this.MenuID = create m_mantto_smpl
end on

on w_pr326_parte_produccion.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_update_pre;call super::ue_update_pre;// Verifica que campos son requeridos y tengan valores
ib_update_check = False
if f_row_Processing( dw_master, "form") <> true then return

// Verifica que campos son requeridos y tengan valores
if f_row_Processing( dw_detail, "tabular") <> true then return


if of_set_numera	() = 0 then return

ib_update_check = true
end event

event ue_insert;Long  ll_row

if idw_1 = dw_master then
	ll_row = idw_1.Event ue_insert()

	IF ll_row <> -1 THEN
		THIS.EVENT ue_insert_pos(ll_row)
	end if
else
	MessageBox('Error', 'No puede insertar directamente registros, debe obtenerlos como referencia')
	return
end if

end event

event ue_open_pre;call super::ue_open_pre;ib_log = TRUE
idw_1 = dw_master
dw_master.setFocus()
end event

event ue_update;//Overriding

Boolean lbo_ok = TRUE
String	ls_msg, ls_crlf

ls_crlf = char(13) + char(10)
dw_master.AcceptText()
dw_detail.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF ib_log THEN
	dw_master.of_create_log()
	dw_detail.of_create_log()
END IF

//Open(w_log)
//lds_log.RowsCopy(1, lds_log.RowCount(),Primary!,w_log.dw_log,1,Primary!)


IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_master.Update(true, false) = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion Master", ls_msg, StopSign!)
	END IF
END IF

IF dw_detail.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_detail.Update(true, false) = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion Detalle", ls_msg, StopSign!)
	END IF
END IF

IF ib_log THEN
	IF lbo_ok THEN
		lbo_ok = dw_master.of_save_log()
		lbo_ok = dw_detail.of_save_log()
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0
	dw_detail.ii_update = 0
	dw_master.il_totdel = 0
	dw_detail.il_totdel = 0
	
	dw_master.ii_protect = 0
	dw_master.of_protect()
	dw_detail.ii_protect = 0
	dw_detail.of_protect()
	
	dw_master.REsetUpdate()
	dw_detail.ResetUpdate()
	
	f_mensaje("Grabación realizada satisfactoriamente", "")
	
	is_action = 'open'
	
END IF

end event

event ue_retrieve_list;// Abre ventana pop
str_parametros sl_param
String ls_tipo_mov

this.event ue_update_request()

sl_param.dw1    = 'd_list_prod_parte_produccion_tbl'
sl_param.titulo = 'Lista de partes de produccion'
sl_param.field_ret_i[1] = 1

OpenWithParm( w_lista, sl_param)
sl_param = MESSAGE.POWEROBJECTPARM
if sl_param.titulo <> 'n' then
	of_retrieve(sl_param.field_ret[1])
END IF
end event

event ue_print;call super::ue_print;IF dw_master.rowcount() = 0 then return

str_parametros lstr_rep

lstr_rep.string1 = dw_master.object.nro_parte[1]

OpenSheetWithParm(w_pr326_parte_produccion_rpt, lstr_rep, w_main, 2, Layered!)
end event

type dw_master from w_abc_mastdet`dw_master within w_pr326_parte_produccion
event ue_display ( string as_columna,  long al_row )
integer width = 3854
integer height = 588
string dataobject = "d_abc_parte_produccion_ff"
end type

event dw_master::ue_display(string as_columna, long al_row);boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, l
			

//str_parametros sl_param

choose case upper(as_columna)
		
		case "COD_PROCESO"

		ls_sql = "Select pp.cod_proceso as codigo, " &
				 + "pp.descripcion as descripcion, " &
				 + "pp.cod_plantilla as plantilla " &
				 + "from prod_procesos pp " &
				 + "Where Nvl(pp.flag_estado,'0')='1' " &
				 + "Order by pp.cod_proceso"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.cod_proceso		[al_row] = ls_codigo
			this.object.desc_proceso	[al_row] = ls_data
			this.ii_update = 1
		end if
					
end choose
end event

event dw_master::constructor;call super::constructor;
is_dwform = 'form'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw

ii_dk[1] = 1 	      // columnas que se pasan al detalle

idw_mst  	=		dw_master
idw_det  	=		dw_detail
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;DateTime ldt_fecha

ldt_fecha = f_fecha_actual()

This.Object.cod_usr			[al_row] = gs_user
This.Object.estacion			[al_row] = gs_estacion
This.Object.fecha_registro	[al_row] = ldt_fecha
This.Object.fecha				[al_row] = ldt_fecha
This.Object.fecha_inicio	[al_row] = ldt_fecha
This.Object.fecha_fin		[al_row] = DateTime(Date(ldt_fecha), &
													RelativeTime(Time(ldt_fecha), 10*60*60))
is_action = 'new'
end event

event dw_master::doubleclicked;call super::doubleclicked;string 	ls_columna
long		ll_row

this.Accepttext( )
IF This.describe(dwo.Name + ".Protect") = '1' Then RETURN
ll_row = row

If ll_row > 0 Then
	ls_columna = upper(dwo.name)
	This.event dynamic ue_display(ls_columna, ll_row)
end if
end event

event dw_master::buttonclicked;call super::buttonclicked;date 				ld_fecha1, ld_fecha2
str_parametros 	lstr_param

this.acceptText()

choose case lower(dwo.name)
		
	case "b_referencia"
		if IsNull(this.object.fecha_inicio[row]) then
			MessageBox("Error", "Debe ingresar una fecha de inicio")
			setColumn("fecha_inicio")
			return
		end if
		if IsNull(this.object.fecha_fin[row]) then
			MessageBox("Error", "Debe ingresar una fecha de fin")
			setColumn("fecha_inicio")
			return
		end if
		
		ld_fecha1 = RelativeDate(Date(this.object.fecha_inicio[row]),-1)
		ld_fecha2 = Date(this.object.fecha_fin[row])
		
		lstr_param.dw_master = 'd_list_proveedor_mp_tbl'      
		lstr_param.dw1       = 'd_list_proveedor_mp_det_tbl'  
		lstr_param.opcion    = 2  // Seleccion por parte de producción
		lstr_param.fecha1	   = ld_fecha1
		lstr_param.fecha2	   = ld_fecha2
		lstr_param.tipo		= '1D2D'
		lstr_param.titulo    = 'Ingresos de MP pendientes de registro'
		lstr_param.dw_m		= dw_master
		lstr_param.dw_d		= dw_detail

		OpenWithParm( w_abc_seleccion_md, lstr_param)
		
		
end choose

end event

event dw_master::getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event dw_master::itemchanged;call super::itemchanged;boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql
DateTime ldt_inicio, ldt_fin
Date 		ld_fecha

this.Accepttext( )

choose case lower(dwo.name)
		
	case "fecha"
		ld_fecha 	= Date (this.object.fecha[row])
		ldt_inicio 	= DateTime(this.object.fecha_inicio[row])
		ldt_fin 		= DateTime(this.object.fecha_fin[row])
		
		ldt_inicio  = DateTime(ld_fecha, Time(ldt_inicio))
		ldt_fin 		= DateTime(ld_fecha, Time(ldt_fin))
		
		this.object.fecha_inicio[row] = ldt_inicio
		this.object.fecha_fin	[row] = ldt_fin
		
		
		
		
end choose

end event

type dw_detail from w_abc_mastdet`dw_detail within w_pr326_parte_produccion
event ue_display ( string as_columna,  integer al_row )
integer x = 0
integer y = 604
integer width = 3854
integer height = 1044
string dataobject = "d_abc_parte_produccion_det_tbl"
borderstyle borderstyle = styleraised!
end type

event dw_detail::ue_display(string as_columna, integer al_row);boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_proceso, ls_nom_prov, &
			ls_placa, ls_nro_parte, ls_especie
DateTime ldt_fecha_ini
Decimal	ldc_peso
Integer  ln_item			

//str_parametros sl_param

choose case upper(as_columna)
		
		case "AP_NRO_PARTE"
		ls_proceso = dw_master.object.cod_proceso[1]
		ls_sql = "Select apd.nro_parte as nro_parte, apd.item as item, "&
					+"p1.nom_proveedor as porv_mp, apd.inicio_descarga as fecha, "&
					+"tg.descr_especie as especie, apd.peso_estimado as peso, "&
					+"p2.nom_proveedor as prov_transp, apd.nro_placa as placa "&
					+"from ap_pd_descarga_det apd, proveedor p1, proveedor p2, tg_especies tg "&
					+"Where apd.proveedor = p1.proveedor and apd.prov_transporte = p2.proveedor "&
					+"and apd.especie = tg.especie and (apd.nro_parte , apd.item) not in "&
					+"(Select ppm.ap_nro_parte, ppm.ap_nro_item from prod_parte_prod_recep_mp ppm) "&
					+"and tg.cod_art in ( Select p.cod_art from plant_costo_art p Where p.cod_plantilla in "&
					+"(Select pp.cod_plantilla from prod_procesos pp Where pp.cod_proceso = '" + ls_proceso +"'))"
//				 '" + ls_proveedor + "'"
		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '2')
		
		if ls_codigo <> '' then
			ls_nro_parte = ls_codigo
			ln_item		 = Integer(ls_data)
			this.object.ap_nro_parte	[al_row] = ls_codigo
			this.object.ap_nro_item		[al_row] = Integer(ls_data)
			this.ii_update = 1
			
			Select p.nom_proveedor, apd.inicio_descarga, tg.descr_especie, 
					 apd.peso_estimado, apd.nro_placa
		     Into :ls_nom_prov, :ldt_fecha_ini, :ls_especie,
			  	 	 :ldc_peso, :ls_placa
           From ap_pd_descarga_det apd, proveedor p, tg_especies tg
 			 Where apd.proveedor = p.proveedor
   		   and apd.especie = tg.especie
   			and apd.nro_parte = :ls_nro_parte
   			and apd.item = :ln_item;
			
			this.object.nom_proveedor		[al_row] = ls_nom_prov
			this.object.inicio_descarga	[al_row] = DateTime(ldt_fecha_ini)
			this.object.descr_especie		[al_row] = ls_especie
			this.object.peso_estimado		[al_row] = ldc_peso
			this.object.nro_placa			[al_row] = ls_placa
		end if
					
end choose
end event

event dw_detail::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 1				// columnas de lectrua de este dw
ii_ck[3] = 1				// columnas de lectrua de este dw

ii_rk[1] = 1 	      // columnas que recibimos del master

//idw_mst  = 				// dw_master
idw_det  =  	dw_detail			// dw_detail
end event

event dw_detail::doubleclicked;call super::doubleclicked;string 	ls_columna
long		ll_row

this.Accepttext( )
IF This.describe(dwo.Name + ".Protect") = '1' Then RETURN
ll_row = row

If ll_row > 0 Then
	ls_columna = upper(dwo.name)
	This.event dynamic ue_display(ls_columna, ll_row)
end if
end event

event dw_detail::ue_insert_pre;call super::ue_insert_pre;DateTime 	ldt_fecha, ldt_fecha_ini
Date			ld_fecha

ldt_fecha = f_fecha_actual()
ld_fecha  = Date(ldt_fecha)
ldt_fecha_ini = ldt_fecha

This.Object.cod_usr			[al_row] = gs_user
This.Object.estacion			[al_row] = gs_estacion
This.Object.fecha_registro	[al_row] = ldt_fecha

end event

event dw_detail::getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

