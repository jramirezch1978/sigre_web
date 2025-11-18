$PBExportHeader$w_pr333_parte_transferencia_popup.srw
forward
global type w_pr333_parte_transferencia_popup from w_abc_mastdet_smpl
end type
type cb_grabar from commandbutton within w_pr333_parte_transferencia_popup
end type
type cb_cancelar from commandbutton within w_pr333_parte_transferencia_popup
end type
type cb_1 from commandbutton within w_pr333_parte_transferencia_popup
end type
end forward

global type w_pr333_parte_transferencia_popup from w_abc_mastdet_smpl
integer width = 3552
integer height = 2784
string title = "[PR333] Parte de Transferencia"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
windowstate windowstate = maximized!
cb_grabar cb_grabar
cb_cancelar cb_cancelar
cb_1 cb_1
end type
global w_pr333_parte_transferencia_popup w_pr333_parte_transferencia_popup

type variables
n_cst_wait 	invo_wait
nvo_numeradores_varios	invo_nro
end variables

forward prototypes
public function integer of_set_numera ()
public function boolean of_procesar_parte (string as_nro_parte)
end prototypes

public function integer of_set_numera ();// Numera documento
Long 		ll_count, ll_ult_nro, ll_row
String  	ls_mensaje, ls_nro_parte
n_cst_utilitario 	lnvo_util


try 
	select count(*)
		into :ll_count
	from NUM_TABLAS
	where tabla	 = 'TG_PARTE_TRANSFERENCIA'
	  and origen = :gs_origen;
	
	if SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Aviso', "Error al consulta la tabla NUM_TABLAS. Mensaje: " + ls_mensaje, StopSign!)
		return 0
	end if
	
	if ll_count = 0 then
		insert into NUM_TABLAS(tabla, origen, ult_nro)
		values( 'TG_PARTE_TRANSFERENCIA', :gs_origen, 1);
		
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Aviso', "Error al INSERTAR en tabla NUM_TABLAS. Mensaje: " + ls_mensaje, StopSign!)
			return 0
		end if
	
	end if
	
	SELECT ult_nro
	  INTO :ll_ult_nro
	FROM NUM_TABLAS
	where tabla  = 'TG_PARTE_TRANSFERENCIA'
	  and origen = :gs_origen for update;
	
	if SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Aviso', "Error al consulta la tabla NUM_TABLAS. Mensaje: " + ls_mensaje, StopSign!)
		return 0
	end if
	
	//Verifico que el numero del oper_sec no exista
	do
		invo_wait.of_mensaje( "Generando NRO DE PARTE para Parte de RECEPCION " + string(ll_ult_nro) )
		
		if gnvo_app.of_get_parametro("PROD_NRO_PARTE_RECEPCION_HEXADECIMAL", "1") = "1" then
			ls_nro_parte = trim(gs_origen) + lnvo_util.lpad(lnvo_util.of_long2hex( ll_ult_nro ), 10 - len(trim(gs_origen)), '0')
		else
			ls_nro_parte = trim(gs_origen) + lnvo_util.lpad(string( ll_ult_nro ), 10 - len(trim(gs_origen)), '0')
		end if
		
		SELECT count(*)
			into :ll_count
		from TG_PARTE_TRANSFERENCIA t
		where t.nro_parte = :ls_nro_parte;
		
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Aviso', "Error al consulta la tabla TG_PARTE_TRANSFERENCIA. Mensaje: " + ls_mensaje, StopSign!)
			return 0
		end if
		
		if ll_count > 0 then 
			ll_ult_nro++ 
		end if
		
	loop while ll_count <> 0 
	
	update NUM_TABLAS
		set ult_nro = :ll_ult_nro + 1
	where tabla  = 'TG_PARTE_TRANSFERENCIA'
	  and origen = :gs_origen;
	
	if SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Aviso', "Error al realizar UPDATE en tabla NUM_TABLAS. Mensaje: " + ls_mensaje, StopSign!)
		return 0
	end if
	
	dw_master.object.nro_parte [1] = ls_nro_parte
	
	for ll_row = 1 to dw_detail.RowCount()
		dw_detail.object.nro_parte [ll_row] = ls_nro_parte
	next
	
	return 1

catch ( Exception ex )
	gnvo_app.of_catch_Exception(ex, "Error al generar numero de opersec")
	
finally
	invo_Wait.of_close()
end try

end function

public function boolean of_procesar_parte (string as_nro_parte);string  ls_mensaje
integer li_ok

//begin
//  -- Call the procedure
//  pkg_produccion.sp_procesar_transferencia(asi_nro_parte => :asi_nro_parte);
//end;

DECLARE sp_procesar_transferencia PROCEDURE FOR
	pkg_produccion.sp_procesar_transferencia( :as_nro_parte );

EXECUTE sp_procesar_transferencia;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = SQLCA.SQLErrText
	Rollback;
	MessageBox('Error en procedimiento pkg_produccion.sp_procesar_transferencia()', ls_mensaje, StopSign!)
	Return false
END IF

CLOSE sp_procesar_transferencia;

return true
end function

on w_pr333_parte_transferencia_popup.create
int iCurrent
call super::create
this.cb_grabar=create cb_grabar
this.cb_cancelar=create cb_cancelar
this.cb_1=create cb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_grabar
this.Control[iCurrent+2]=this.cb_cancelar
this.Control[iCurrent+3]=this.cb_1
end on

on w_pr333_parte_transferencia_popup.destroy
call super::destroy
destroy(this.cb_grabar)
destroy(this.cb_cancelar)
destroy(this.cb_1)
end on

event resize;//Override
dw_detail.width  = newwidth  - dw_detail.x - 10
dw_detail.height = newheight - dw_detail.y - 10
end event

event ue_open_pre;call super::ue_open_pre;str_parametros		lstr_param

ii_lec_mst = 0

if IsNull(Message.PowerObjectParm) or Not IsValid(Message.PowerObjectParm) then
	dw_master.event ue_insert( )
end if


invo_wait = create n_cst_wait
invo_nro = create nvo_numeradores_varios


end event

event ue_update_pre;call super::ue_update_pre;String 	ls_almacen
Long		ll_count

// Verifica que campos son requeridos y tengan valores
ib_update_check = False

if gnvo_app.of_row_Processing( dw_master ) <> true then return

// Verifica que campos son requeridos y tengan valores
if gnvo_app.of_row_Processing( dw_detail ) <> true then return

// verifica que tenga datos de detalle
if dw_detail.rowcount() = 0 then
	Messagebox( "Atencion", "Ingrese informacion de detalle", StopSign!)
	return
end if

// verifica que tenga datos de detalle
if dw_master.rowcount() = 0 then
	Messagebox( "Atencion", "Ingrese informacion de Cabecera del documento", StopSign!)
	return
end if

//Validando el almacen de Origen
ls_almacen = dw_master.object.almacen_org	[1]

select count(*)
  into :ll_count
  from tg_parte_empaque
 where almacen_pptt = :ls_almacen;

if ll_count > 0 then
	Messagebox( "Atencion", "El almacen de origen " + ls_almacen + " no esta permitido para iniciar una transferencia", StopSign!)
	return
end if

//Validando el almacen de Destino
ls_almacen = dw_master.object.almacen_dst	[1]

select count(*)
  into :ll_count
  from tg_parte_empaque
 where almacen_pptt = :ls_almacen;

if ll_count > 0 then
	Messagebox( "Atencion", "El almacen de destino " + ls_almacen + " no esta permitido para iniciar una transferencia", StopSign!)
	return
end if


dw_master.of_set_flag_replicacion()
dw_detail.of_set_flag_replicacion()

if of_set_numera	() = 0 then return

ib_update_check = true


end event

event close;call super::close;destroy invo_Wait
destroy invo_nro
end event

event ue_update;//Override
Boolean 				lbo_ok = TRUE
String				ls_msg, ls_crlf, ls_nro_parte
str_parametros		lstr_param

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
	ls_nro_parte = dw_master.object.nro_parte [1]
	
	if not this.of_procesar_parte( ls_nro_parte ) then return
	
	COMMIT using SQLCA;
	dw_master.ii_update = 0
	dw_detail.ii_update = 0
	dw_master.il_totdel = 0
	dw_detail.il_totdel = 0
	
	dw_master.ResetUpdate()
	dw_detail.ResetUpdate()
	
	f_mensaje('Grabación realizada satisfactoriamente', '')
	
	lstr_param.b_Return = true
	
	closeWithReturn(this, lstr_param)
	
END IF

end event

type dw_master from w_abc_mastdet_smpl`dw_master within w_pr333_parte_transferencia_popup
integer x = 0
integer y = 0
integer width = 3008
integer height = 944
string dataobject = "d_abc_parte_transferencia_cab_ff"
boolean hscrollbar = false
boolean vscrollbar = false
end type

event dw_master::ue_insert_pre;call super::ue_insert_pre;DateTime	ldt_now

ldt_now = gnvo_app.of_fecha_Actual()

this.object.fec_transferencia [al_row] = Date(ldt_now)
this.object.fec_registro		[al_row] = ldt_now
this.object.cod_usr				[al_row] = gs_user
this.object.cantidad				[al_row] = 0.00
this.object.nro_cajas			[al_row] = 0.00
this.object.cod_origen			[al_row] = gs_origen

is_action = 'new'

end event

event dw_master::constructor;call super::constructor; is_dwform = 'form' // tabular form
 
ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
ii_dk[1] = 1 	      // columnas que se pasan al detalle

is_action = 'new'
end event

event dw_master::ue_display;call super::ue_display;boolean lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_almacen_org, ls_almacen_dst, &
			ls_anaquel, ls_fila, ls_columna, ls_nro_pallet, ls_mensaje, &
			ls_desc_almacen_org

choose case lower(as_columna)
	
	case 'nro_pallet_org'
		
		ls_sql = "select t.nro_pallet as nro_pallet, " &
				 + "       t.almacen as almacen, " &
				 + "       t.desc_almacen as desc_almacen, " &
				 + "       t.anaquel as anaquel, " &
				 + "       t.fila as fila, " &
				 + "       t.columna as columna " &
				 + "from VW_ALM_PALLETS_TRANSF_ORG t, " &
				 + "     almacen al, " & 
				 + "     almacen_user au " &
				 + "where t.almacen     = al.almacen " &
				 + "  and al.almacen	   = au.almacen " &
				 + "  and al.cod_origen = '" + gs_origen + "'" &
				 + "  and au.cod_usr		= '" + gs_user + "'"
				 
		if gnvo_app.of_lista(ls_sql, ls_nro_pallet, ls_almacen_org, ls_desc_almacen_org, &
									ls_anaquel, ls_fila, ls_columna, '1') then
											  
			this.object.nro_pallet_org		[al_row] = ls_nro_pallet
			this.object.almacen_org			[al_row] = ls_almacen_org
			this.object.desc_almacen_org	[al_row] = ls_desc_almacen_org
			this.object.anaquel_org			[al_row] = ls_anaquel
			this.object.fila_org				[al_row] = ls_fila
			this.object.columna_org			[al_row] = ls_columna
			this.object.nro_pallet_dst		[al_row] = ls_nro_pallet
			this.ii_update = 1
			
		end if			
		
		
	case "almacen_org"
		
		ls_nro_pallet = dw_master.object.nro_pallet_org [1]
		
		if IsNull(ls_nro_pallet) or trim(ls_nro_pallet) = '' then
			this.setColumn("nro_pallet_org")
			MessageBox('Error', 'Debe Seleccionar el nro de Pallet Origen', StopSign!)
			return
		end if
		

		ls_sql = "select t.almacen as almacen, " &
				 + "       t.desc_almacen as desc_almacen, " &
				 + "       t.anaquel as anaquel, " &
				 + "       t.fila as fila, " &
				 + "       t.columna as columna " &
				 + "from VW_ALM_PALLETS_TRANSF_ORG t " &
				 + "where t.nro_pallet = '" + ls_nro_pallet + "'"
				 
		if gnvo_app.of_lista(ls_sql, ls_almacen_org, ls_desc_almacen_org, ls_anaquel, &
											  ls_fila, ls_columna, '2') then
											  
			this.object.almacen_org			[al_row] = ls_almacen_org
			this.object.desc_almacen_org	[al_row] = ls_desc_almacen_org
			this.object.anaquel_org			[al_row] = ls_anaquel
			this.object.fila_org				[al_row] = ls_fila
			this.object.columna_org			[al_row] = ls_columna
			this.ii_update = 1
			
		end if
		
	case 'anaquel_org'
		ls_nro_pallet = dw_master.object.nro_pallet_org [1]
		ls_almacen_org = dw_master.object.almacen_org [1]
		
		if IsNull(ls_nro_pallet) or trim(ls_nro_pallet) = '' then
			this.setColumn("nro_pallet_org")
			MessageBox('Error', 'Debe Seleccionar el nro de Pallet Origen', StopSign!)
			return
		end if
		
		if IsNull(ls_almacen_org) or trim(ls_almacen_org) = '' then
			MessageBox('Error', 'Debe Seleccionar el ALMACEN Origen', StopSign!)
			this.setColumn("almacen_org")
			return
		end if
		
		ls_sql = "select t.almacen as almacen, " &
				 + "       t.desc_almacen as desc_almacen, " &
				 + "       t.anaquel as anaquel, " &
				 + "       t.fila as fila, " &
				 + "       t.columna as columna " &
				 + "from VW_ALM_PALLETS_TRANSF_ORG t " &
				 + "where t.nro_pallet = '" + ls_nro_pallet + "'" &
				 + "  and t.almacen = '" + ls_almacen_org + "'"
				 
		if gnvo_app.of_lista(ls_sql, ls_anaquel, ls_fila, ls_columna, '1') then
			this.object.anaquel_org		[al_row] = ls_anaquel
			this.object.fila_org			[al_row] = ls_fila
			this.object.columna_org		[al_row] = ls_columna
			this.ii_update = 1
		end if			
	
	case "almacen_dst"
		
		ls_almacen_org = dw_master.object.almacen_org [1]
		
		if IsNull(ls_almacen_org) or trim(ls_almacen_org) = '' then
			this.setColumn("almacen_org")
			return
		end if

		ls_sql = "select distinct al.almacen as almacen, " &
				 + "al.desc_almacen as descripcion_almacen " &
				 + "from almacen al, " &
				 + "     almacen_user au, " &
				 + "		vw_alm_posiciones_libres vw, " &
				 + "      (select distinct almacen " &
				 + "         from vw_alm_posiciones_libres " &
				 + "       minus " &
				 + "       select distinct te.almacen_pptt " &
				 + "         from tg_parte_empaque te) s " &
				 + "where al.almacen = au.almacen " &
				 + "  and al.almacen = vw.almacen " &
				 + "  and al.almacen = s.almacen " &
				 + "  and au.cod_usr = '" + gs_user + "'" &
				 + "  and al.cod_origen = '" + gs_origen + "'" &
				 + "  and al.flag_tipo_almacen in ('T', 'P')"
				 
		if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, '2') then
			this.object.almacen_dst			[al_row] = ls_codigo
			this.object.desc_almacen_dst	[al_row] = ls_data
			this.ii_update = 1
		end if		
	
	case 'anaquel_dst'
		ls_almacen_dst = dw_master.object.almacen_dst [1]
		
		if IsNull(ls_almacen_dst) or trim(ls_almacen_dst) = '' then
			this.setColumn("almacen_dst")
			return
		end if
		
		ls_sql = "select distinct a.anaquel as anaquel " &
				 + "from vw_alm_posiciones_libres a " &
				 + "where a.almacen = '" + ls_almacen_dst + "'"
				 
		if gnvo_app.of_lista(ls_sql, ls_anaquel, '1') then
			this.object.anaquel_dst	[al_row] = ls_anaquel
			
			this.ii_update = 1
			
			if ls_anaquel = '00' then
				select fila, columna
					into :ls_fila, :ls_columna
				from vw_alm_posiciones_libres
				where almacen 	= :ls_almacen_dst
				  and anaquel 	= :ls_anaquel
				  and rownum	= '1';
			 	
				if SQLCA.SQlCode < 0 then
					ls_mensaje = SQLCA.SQLErrText
					rollback;
					MessageBox('Error', 'Error al consultar datos de la vista vw_alm_posiciones_libres. Mensaje: ' + ls_mensaje, StopSign!)
					return
				end if
				
				if SQLCA.SQlCode = 100 then
					this.object.fila_dst		[al_row] = gnvo_app.is_null
					this.object.columna_dst	[al_row] = gnvo_app.is_null
				else
					this.object.fila_dst		[al_row] = ls_fila
					this.object.columna_dst	[al_row] = ls_columna
				end if
				
			end if
			
			
		end if			
	
	case 'fila_dst'
		ls_almacen_dst = dw_master.object.almacen_dst [1]
		
		if IsNull(ls_almacen_dst) or trim(ls_almacen_dst) = '' then
			this.setColumn("almacen_dst")
			return
		end if
		
		ls_anaquel = dw_master.object.anaquel_dst [1]
		
		if IsNull(ls_anaquel) or trim(ls_anaquel) = '' then
			return
		end if
		
		ls_sql = "select distinct a.fila as fila " &
				 + "from vw_alm_posiciones_libres a " &
				 + "where a.almacen = '" + ls_almacen_dst + "'" &
				 + "  and a.anaquel = '" + ls_anaquel + "'"
				 
		if gnvo_app.of_lista(ls_sql, ls_fila, '1') then
			this.object.fila_dst		[al_row] = ls_fila
			this.ii_update = 1
		end if		
	
	case 'columna_dst'
		ls_almacen_dst = dw_master.object.almacen_dst [1]
		
		if IsNull(ls_almacen_dst) or trim(ls_almacen_dst) = '' then
			this.setColumn("almacen_dst")
			return
		end if
		
		ls_anaquel = dw_master.object.anaquel_dst [1]
		
		if IsNull(ls_anaquel) or trim(ls_anaquel) = '' then
			return
		end if
		
		ls_fila = dw_master.object.fila_dst [1]
		
		if IsNull(ls_fila) or trim(ls_fila) = '' then
			return
		end if
		
		ls_sql = "select a.columna as columna " &
				 + "from vw_alm_posiciones_libres a " &
				 + "where a.almacen = '" + ls_almacen_dst + "'" &
				 + "  and a.anaquel = '" + ls_anaquel + "'" &
				 + "  and a.fila = '" + ls_fila + "'"
				 
		if gnvo_app.of_lista(ls_sql, ls_columna, '1') then
			this.object.columna_dst	[al_row] = ls_columna
			this.ii_update = 1
		end if		
		
		
		
end choose



end event

event dw_master::doubleclicked;call super::doubleclicked;string ls_columna
if not this.is_protect(dwo.name, row) and row > 0 then
	ls_columna = upper(dwo.name)
	THIS.event dynamic ue_display(ls_columna, row)
end if
end event

event dw_master::buttonclicked;call super::buttonclicked;String ls_nro_pallet, ls_origen
this.AcceptText()


choose case lower(dwo.name)

	case 'b_new_pallet'
		
		ls_origen		= this.object.cod_origen		[row]
		ls_nro_pallet 	= this.object.nro_pallet_dst 	[row]
		
		if MessageBox('Aviso', 'Desea generar un nuevo nro de pallet?', Information!, YesNo!, 2) = 2 then return
		
		//Genero un nuevo nro de pallet
		if not invo_nro.of_nro_pallet( ls_origen, ls_nro_pallet) then return
		
		this.object.nro_pallet_dst 	[row] = ls_nro_pallet
		this.ii_update = 1
		commit;
		
		MessageBox('Aviso', 'Se ha generado satisfactoriamente el nro de pallet ' + ls_nro_pallet, Information!)
		
	
End choose
end event

event dw_master::itemchanged;call super::itemchanged;String 	ls_almacen_org	, ls_desc_almacen_org, ls_anaquel, &
			ls_fila			, ls_columna

this.Accepttext()

CHOOSE CASE dwo.name
	case 'nro_pallet_org'
		
		select t.almacen, t.desc_almacen, t.anaquel, t.fila, t.columna
			into :ls_almacen_org, :ls_desc_almacen_org, :ls_anaquel, :ls_fila, :ls_columna
		from VW_ALM_PALLETS_TRANSF_ORG t 
		where t.nro_palle = :data;
				 
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
											  
			this.object.nro_pallet_org		[row] = gnvo_app.is_null
			this.object.almacen_org			[row] = gnvo_app.is_null
			this.object.desc_almacen_org	[row] = gnvo_app.is_null
			this.object.anaquel_org			[row] = gnvo_app.is_null
			this.object.fila_org				[row] = gnvo_app.is_null
			this.object.columna_org			[row] = gnvo_app.is_null
			this.object.nro_pallet_dst		[row] = gnvo_app.is_null
			return 1
			
		end if		
		
		this.object.almacen_org			[row] = ls_almacen_org
		this.object.desc_almacen_org	[row] = ls_desc_almacen_org
		this.object.anaquel_org			[row] = ls_anaquel
		this.object.fila_org				[row] = ls_fila
		this.object.columna_org			[row] = ls_columna
		this.object.nro_pallet_dst		[row] = data
		

END CHOOSE
end event

type dw_detail from w_abc_mastdet_smpl`dw_detail within w_pr333_parte_transferencia_popup
integer x = 0
integer y = 968
integer width = 3470
integer height = 1600
string dataobject = "d_abc_parte_transferencia_det_tbl"
end type

event dw_detail::ue_insert_pre;call super::ue_insert_pre;this.object.nro_item 		[al_row] = of_nro_item()
this.object.cod_usr			[al_row] = gs_user
this.object.fec_registro	[al_row] = gnvo_app.of_fecha_actual()

end event

event dw_detail::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw

ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle
end event

type cb_grabar from commandbutton within w_pr333_parte_transferencia_popup
integer x = 3017
integer width = 521
integer height = 156
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Grabar"
end type

event clicked;parent.event ue_update()

end event

type cb_cancelar from commandbutton within w_pr333_parte_transferencia_popup
integer x = 3022
integer y = 176
integer width = 521
integer height = 156
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Cerrar"
boolean cancel = true
end type

event clicked;str_parametros	lstr_param

lstr_param.b_Return = false

CloseWithReturn(parent, lstr_param)
end event

type cb_1 from commandbutton within w_pr333_parte_transferencia_popup
integer x = 2386
integer y = 764
integer width = 594
integer height = 156
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cajas"
boolean cancel = true
end type

event clicked;Str_parametros 	lstr_param
String				ls_almacen_org, ls_nro_pallet_org

ls_almacen_org 	= dw_master.object.almacen_org 		[1]
ls_nro_pallet_org	= dw_master.object.nro_pallet_org 	[1]

// Ingreso por Compra Normal
lstr_param.dw_master = 'd_list_pallet_transferir_tbl'      
lstr_param.dw1       = 'd_lista_codigo_cu_transferir_tbl'  
lstr_param.opcion    = 4
lstr_param.string1 	= ls_almacen_org
lstr_param.string2 	= ls_nro_pallet_org
lstr_param.tipo		='1S2S'
lstr_param.titulo    = 'Lista de Pallets para transferencia'
lstr_param.dw_d		= dw_detail
lstr_param.dw_m		= dw_master


OpenWithParm( w_abc_seleccion_md, lstr_param)
end event

