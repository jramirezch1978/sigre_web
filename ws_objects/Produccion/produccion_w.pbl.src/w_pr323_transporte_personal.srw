$PBExportHeader$w_pr323_transporte_personal.srw
forward
global type w_pr323_transporte_personal from w_abc_mastdet
end type
type st_nro from statictext within w_pr323_transporte_personal
end type
type sle_nro from singlelineedit within w_pr323_transporte_personal
end type
type cb_1 from commandbutton within w_pr323_transporte_personal
end type
end forward

global type w_pr323_transporte_personal from w_abc_mastdet
integer width = 3351
integer height = 2312
string title = "Registro de Transporte(PR323)"
string menuname = "m_mantto_smpl"
st_nro st_nro
sle_nro sle_nro
cb_1 cb_1
end type
global w_pr323_transporte_personal w_pr323_transporte_personal

type variables
end variables

forward prototypes
public subroutine of_retrieve (string as_nro_parte)
public function integer of_set_numera ()
public subroutine of_get_fecha (date ad_fecha)
public function integer of_nro_item (datawindow adw_pr)
public function boolean of_prorrata_total ()
public function boolean of_actualiza_prorrata ()
public function boolean of_valida_opersec (datawindow adw_data)
end prototypes

public subroutine of_retrieve (string as_nro_parte);dw_master.Retrieve(as_nro_parte)
dw_detail.retrieve(as_nro_parte)

dw_master.ii_protect = 0
dw_detail.ii_protect = 0

dw_master.of_protect( )
dw_detail.of_protect( )

dw_master.ii_update = 0
dw_detail.ii_update = 0

is_Action = 'open'

end subroutine

public function integer of_set_numera ();// Numera documento
Long 		ll_count, ll_ult_nro, ll_i
String  	ls_next_nro, ls_lock_table, ls_mensaje

IF dw_master.getrow() = 0 THEN RETURN 0

IF is_action = 'new' THEN
	SELECT count(*)
		INTO :ll_count
	FROM NUM_PROD_PARTE_TRANSP
	WHERE origen = :gs_origen;
	
	IF ll_count = 0 THEN
		ls_lock_table = 'LOCK TABLE NUM_PROD_PARTE_TRANSP IN EXCLUSIVE MODE'
		EXECUTE IMMEDIATE :ls_lock_table ;
		
		IF SQLCA.SQLCode < 0 THEN
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Aviso', ls_mensaje)
			RETURN 0
		END IF
		
		INSERT INTO NUM_PROD_PARTE_TRANSP(origen, ult_nro)
		VALUES( :gs_origen, 1);
		
		IF SQLCA.SQLCode < 0 THEN
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Aviso', ls_mensaje)
			RETURN 0
		END IF
	END IF
	
	SELECT ult_nro
	  INTO :ll_ult_nro
	FROM NUM_PROD_PARTE_TRANSP
	WHERE origen = :gs_origen FOR UPDATE;
	
	UPDATE NUM_PROD_PARTE_TRANSP
		SET ult_nro = ult_nro + 1
	WHERE origen = :gs_origen;
	
	IF SQLCA.SQLCode < 0 THEN
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Aviso', ls_mensaje)
		RETURN 0
	END IF
	
	ls_next_nro = trim(gs_origen) + string(ll_ult_nro, '00000000')
	
	dw_master.object.nro_parte[dw_master.getrow()] = ls_next_nro
	dw_master.ii_update = 1
	ELSE
	ls_next_nro = dw_master.object.nro_parte[dw_master.getrow()] 
	END IF

// Asigna numero a detalle dw_detail (detalle de la instruccion)
FOR ll_i = 1 TO dw_detail.RowCount()
	dw_detail.object.nro_parte[ll_i] = ls_next_nro
NEXT

RETURN 1
end function

public subroutine of_get_fecha (date ad_fecha);Integer ai_ano, ai_semana

select ano, semana
	into :ai_ano, :ai_semana
from vw_pr_semanas_prod
where trunc(fecha_inicio) <= to_char( :ad_fecha)
  and trunc(fecha_fin) 	  >= to_char( :ad_fecha);

 dw_master.object.ano		[dw_master.GetRow()] = ai_ano
 dw_master.object.semana	[dw_master.GetRow()] = ai_semana
end subroutine

public function integer of_nro_item (datawindow adw_pr);integer li_item, li_x

li_item = 0

For li_x 		= 1 to adw_pr.RowCount()
	IF li_item 	< adw_pr.object.nro_item[li_x] THEN
		li_item 	= adw_pr.object.nro_item[li_x]
	END IF
Next

Return li_item + 1
end function

public function boolean of_prorrata_total ();Dec		ldc_nro_viajes, 		ldc_precio_por_viaje, &
			ldc_total_importe,	ldc_precio_x_pasajero
integer	li_nro_pasajeros, ll_i, li_nro_personas
String	ls_nro_parte

Boolean lb_ret = TRUE


	ls_nro_parte 			= dw_master.object.nro_parte 			[dw_master.GetRow()]
	ldc_nro_viajes 		= dw_master.object.nro_viajes 		[dw_master.GetRow()]
	ldc_precio_por_viaje = dw_master.object.importe_x_viaje 	[dw_master.GetRow()]

		if ldc_nro_viajes <= 0 then
		Messagebox('Modulo de Producción', 'El Nro. de Viajes debe de ser al Menos uno')
		dw_master.object.nro_viajes [dw_master.GetRow()] = 0
		Return FALSE
		end if

 		if ldc_precio_por_viaje <= 0 then
		Messagebox('Modulo de Producción', 'El Precio por Viaje debe de ser Mayor a Cero')
		dw_master.object.importe_x_viaje [dw_master.GetRow()] = 0
		Return FALSE
		end if

		ldc_total_importe		= ldc_nro_viajes * ldc_precio_por_viaje
		
		IF dw_detail.Getrow( ) > 0 then

		FOR ll_i = 1 to dw_detail.rowcount( )
			 li_nro_personas 		= dw_detail.object.nro_personas [ll_i]
			 li_nro_pasajeros 	= li_nro_pasajeros + lI_nro_personas
		NEXT
		
		ldc_precio_x_pasajero = ldc_total_importe / li_nro_pasajeros
		
		if dw_detail.ii_update = 0 then
			dw_detail.ii_update = 1
	   end if
		
		FOR ll_i = 1 TO dw_detail.rowcount( )
		dw_detail.object.importe [ll_i] = dw_detail.object.nro_personas [ll_i] * ldc_precio_x_pasajero
		NEXT
		else
		Return FALSE
	end if
		
Return lb_ret

	
	
end function

public function boolean of_actualiza_prorrata ();Dec		ldc_nro_viajes, 		ldc_precio_por_viaje, &
			ldc_total_importe,	ldc_precio_x_pasajero
integer	li_nro_pasajeros_p, ll_i, li_suma_total, li_suma, li_nro_personas, li_nro_personas_s
String	ls_nro_parte

boolean lb_ret = true

	ls_nro_parte 			= dw_master.object.nro_parte 			[dw_master.GetRow()]
	ldc_nro_viajes 		= dw_master.object.nro_viajes 		[dw_master.GetRow()]
	ldc_precio_por_viaje = dw_master.object.importe_x_viaje 	[dw_master.GetRow()]


		if ldc_nro_viajes <= 0 then
		Messagebox('Modulo de Producción', 'El Nro. de Viajes debe de ser al Menos uno')
		dw_master.object.nro_viajes [dw_master.GetRow()] = 0
		end if

 		if ldc_precio_por_viaje <= 0 then
		Messagebox('Modulo de Producción', 'El Precio por Viaje debe de ser Mayor a Cero')
		dw_master.object.importe_x_viaje [dw_master.GetRow()] = 0
		Return false
		end if
		
		ldc_total_importe = ldc_nro_viajes * ldc_precio_por_viaje
		
	IF dw_detail.getrow( ) = 0 then

		return false

	ELSE

		FOR ll_i = 1 to dw_detail.rowcount( )
			 li_nro_personas 		= dw_detail.object.nro_personas [ll_i]
			 li_nro_personas_s 	= lI_nro_personas_s + li_nro_personas
		NEXT
		  
		ldc_precio_x_pasajero = ldc_total_importe / li_nro_personas_s
			  	
		FOR ll_i = 1 TO dw_detail.rowcount( )
	
		dw_detail.object.importe [ll_i] = dw_detail.object.nro_personas [ll_i] * ldc_precio_x_pasajero

		NEXT
		
end if

Return lb_ret

	
end function

public function boolean of_valida_opersec (datawindow adw_data);String ls_oper_sec, ls_nro_orden
long   ll_count, ll_i
Boolean lb_resul = true

ll_count = adw_data.RowCount()

for ll_i = 1 to ll_count
	 ls_oper_sec  = adw_data.object.oper_sec[ll_i]
	 ls_nro_orden = adw_data.object.nro_orden[ll_i]
    if isnull(ls_oper_sec)  or ls_oper_sec = '' or &
	    isnull(ls_nro_orden) or ls_nro_orden = '' then
	 Messagebox('Transporte','Campo requerido en OT/OperSec')
	 lb_resul = false
	 Exit
    End if
Next

Return lb_resul
end function

on w_pr323_transporte_personal.create
int iCurrent
call super::create
if this.MenuName = "m_mantto_smpl" then this.MenuID = create m_mantto_smpl
this.st_nro=create st_nro
this.sle_nro=create sle_nro
this.cb_1=create cb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_nro
this.Control[iCurrent+2]=this.sle_nro
this.Control[iCurrent+3]=this.cb_1
end on

on w_pr323_transporte_personal.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_nro)
destroy(this.sle_nro)
destroy(this.cb_1)
end on

event ue_update_request;//Override

Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si 
// se quiere actualizar

IF (dw_master.ii_update = 1 or dw_detail.ii_update = 1 ) THEN
	
	li_msg_result = MessageBox("Actualizaciones Pendientes", &
	                           "Grabamos", Question!, YesNo!, 1)
	
	IF li_msg_result 			= 1 THEN
 		this.TriggerEvent("ue_update")
	ELSE
		dw_master.ii_update 		= 0
		dw_detail.ii_update 		= 0
	END IF
END IF

end event

event ue_update_pre;long 		ll_row, ll_master
Integer 	li_count

// Verifica que campos son requeridos y tengan valores
if of_valida_opersec(dw_detail) =  False then Return
ib_update_check = False
if f_row_Processing( dw_master, "form") <> true then return

// Verifica que campos son requeridos y tengan valores
if f_row_Processing( dw_detail, "tabular") <> true then return

//Para la replicacion de datos

dw_master.of_set_flag_replicacion()
dw_detail.of_set_flag_replicacion()

///////////////////////////////////////////////
if of_set_numera() = 0 then return
///////////////////////////////////////////////

// Si todo ha salido bien cambio el indicador ib_update_check a true, para indicarle
// al evento ue_update que todo ha salido bien
ib_update_check = true
end event

event ue_query_retrieve;call super::ue_query_retrieve;//Override
String ls_nro_parte

ls_nro_parte = sle_nro.text

if ls_nro_parte = ' ' or isnull(ls_nro_parte) then

	Messagebox("Modulo de Producción","Defina el Nro. de Parte que desea buscar")
	return
end if
	
string   ls_os, ls_os_1, ls_mensaje

select 	nro_parte
	into 	:ls_os
from 		prod_parte_transp
	where	nro_parte = :ls_nro_parte;	

IF SQLCA.sqlcode 	<> 0 THEN
	ls_mensaje 		= "Modulo de Producciòn: EL Nro. de Parte no ha sido definido" + SQLCA.SQLErrText
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	return
else
	  This.of_retrieve( ls_nro_parte )
end if
end event

event ue_open_pre;call super::ue_open_pre;ib_log 		= TRUE

end event

event ue_list_open;//override
// Asigna valores a structura 

str_parametros sl_param

sl_param.dw1    = 'ds_peod_transporte_tbl'
sl_param.titulo = 'Registro de Transporte'
sl_param.field_ret_i[1] = 1	//Nro_Consumo
sl_param.tipo    = '1SQL'
sl_param.string1 =  "WHERE SUBSTR(NRO_PARTE,1,2) = '"+ gs_origen + "'" 

OpenWithParm( w_lista, sl_param )

sl_param = Message.PowerObjectParm

IF sl_param.titulo <> 'n' THEN
	of_retrieve(sl_param.field_ret[1])
END IF
end event

event open;//Override

IF this.of_access(gs_user, THIS.ClassName()) THEN
	THIS.EVENT ue_open_pre()
	THIS.EVENT ue_dw_share()
ELSE
	CLOSE(THIS)
END IF
end event

event ue_update;//Override
Boolean lbo_ok = TRUE
String	ls_msg

dw_master.AcceptText()
dw_detail.AcceptText()

THIS.EVENT ue_update_pre()

IF ib_update_check = FALSE THEN RETURN

IF ib_log THEN
	dw_master.of_create_log()
	dw_detail.of_create_log()
END IF

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
	
	dw_master.REsetUpdate()
	dw_detail.ResetUpdate()
	
	f_mensaje("Grabación realizada satisfactoriamente", "")
	
	is_action = 'open'
END IF

end event

event ue_anular;call super::ue_anular;Long ll_row

IF dw_master.GetRow() = 0 THEN RETURN

IF MessageBox('Aviso', 'Deseas anular El Parte de Transporte', Information!, YesNo!, 2) = 2 THEN RETURN

IF dw_master.object.flag_estado[dw_master.GetRow()] = '0' THEN
	MessageBox('Aviso', 'El Parte de Transporte ya esta anulado')
	RETURN
END IF

IF MessageBox("Anulacion de Registro", "Esta Seguro ?", Question!, YesNo!, 2) <> 1 THEN
	RETURN
END IF

dw_master.object.flag_estado[dw_master.GetRow()] = '0'
dw_master.ii_update = 1

is_action = 'anular'
end event

event ue_delete;//Override
if idw_1 = dw_master THEN
Messagebox("Modulo de Producción","No puede eliminar un parte de Transporte. Es preferible que el parte sea Anulado")
Return

else
	idw_1 = dw_detail
	
	Long  ll_row

IF ii_pregunta_delete = 1 THEN
	IF MessageBox("Eliminacion de Registro", "Esta Seguro ?", Question!, YesNo!, 2) <> 1 THEN
		RETURN
	END IF
END IF

ll_row = idw_1.Event ue_delete()

IF ll_row = 1 THEN
	THIS.Event ue_delete_list()
	THIS.Event ue_delete_pos(ll_row)
END IF

//this.event ue_update()
of_prorrata_total()

end if
end event

type dw_master from w_abc_mastdet`dw_master within w_pr323_transporte_personal
event ue_display ( string as_columna,  long al_row )
integer x = 0
integer y = 204
integer width = 2939
integer height = 628
string dataobject = "d_prod_transporte_ff"
end type

event dw_master::ue_display(string as_columna, long al_row);boolean lb_ret
string ls_codigo, ls_data, ls_sql, ls_ruc
str_seleccionar lstr_seleccionar

choose case upper(as_columna)
		
	case "COD_MONEDA"
		
		ls_sql = "SELECT COD_MONEDA AS CODIGO, " &
				  + "DESCRIPCION AS DESCR_MONEDA " &
				  + "FROM MONEDA " 
				 
		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.cod_moneda	[al_row] = ls_codigo
			this.object.desc_moneda	[al_row] = ls_data
			this.ii_update = 1
		end if
		
		case "PROVEEDOR"
			
		ls_sql = "SELECT proveedor AS codigo, " 			&
			 		+ "nom_proveedor AS nom_proveedor, "  	&
				  	+ "RUC as RUC_proveedor " 					&
			  		+ "FROM proveedor " &
			  		+ "where flag_estado = '1'"
			 
		lb_ret = f_lista_3ret(ls_sql, ls_codigo, ls_data, ls_ruc, '2')
	
		IF ls_codigo <> '' THEN
			This.object.proveedor		[al_row] = ls_codigo
			This.object.nom_proveedor	[al_row] = ls_data
			This.object.ruc				[al_row] = ls_ruc
				
		END IF

		This.ii_update = 1
		
		END choose
end event

event dw_master::constructor;//Override

is_dwform = 'form'	// tabular, form (default)

ii_ss = 1				// indica si se usa seleccion: 1=individual (default), 0=multiple

ii_ck[1] = 1			// columnas de lectrua de este dw
ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_det  = dw_detail // dw_detail
end event

event dw_master::doubleclicked;call super::doubleclicked;string ls_columna
long ll_row 
//str_seleccionar lstr_seleccionar

THIS.AcceptText()
IF THIS.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

IF row > 0 THEN
	ls_columna = upper(dwo.name)
	THIS.event dynamic ue_display(ls_columna, ll_row)
END IF

end event

event dw_master::itemchanged;call super::itemchanged;string 	ls_codigo, ls_data
Date 		ld_fecha
Integer	li_ano, li_semana
Long		ll_count
Boolean	lb_ret
dec li_numero_p, ldc_importe

this.AcceptText()

if row <= 0 then
	return
end if

choose case upper(dwo.name)
		
	CASE "FEC_PARTE"
		
		ld_fecha = Date(this.object.fec_parte[row])
		of_get_fecha(ld_fecha)

	case "COD_MONEDA"
		
		ls_codigo = this.object.cod_moneda[row]

		SetNull(ls_data)
		select descripcion
		  into :ls_data
		from moneda
		where cod_moneda = :ls_codigo;
		
		if IsNull(ls_data) or ls_data = "" then
			Messagebox('PRODUCCIÓN', "CODIGO DE MONEDA NO EXISTE", StopSign!)
			SetNull(ls_codigo)
			this.object.cod_moneda [row] = ls_codigo
			this.object.desc_moneda[row] = ls_codigo
			return 1
		end if

		this.object.desc_moneda[row] = ls_data

		case "PROVEEDOR"
		ls_codigo = this.object.proveedor[row]

		SetNull(ls_data)
		select NOM_PROVEEDOR
		  into :ls_data
		  from PROVEEDOR
		 where PROVEEDOR = :ls_codigo
		   and flag_estado = '1';
		
		if IsNull(ls_data) or ls_data = "" then
			Messagebox('COMEDORES', "PROVEEDOR NO EXISTE O NO ESTA ACTIVO", StopSign!)
			SetNull(ls_codigo)
			this.object.proveedor 	  	  [row] = ls_codigo
			this.object.nom_proveedor	  [row] = ls_codigo
			return 1
		end if

		this.object.nom_proveedor		  [row] = ls_data
		
	case "IMPORTE_X_VIAJE"
		
		ldc_importe = this.object.importe_x_viaje [row]
		
		if ldc_importe <= 0 then
		messagebox('Modulo de Producción', 'El precio debe ser mayor a Cero')
		return 1
		else
		of_actualiza_prorrata()
   	end if
		
	CASE "NRO_VIAJES"
		
		li_numero_p = this.object.nro_viajes [row]
		
		if li_numero_p <= 0 then
		messagebox('Modulo de Producción', 'Debe definir al menos un Viaje')
		return 1
		else
		of_actualiza_prorrata()
		IF of_actualiza_prorrata() = FALSE THEN Return 1
		end if
		
end choose
end event

event dw_master::itemerror;call super::itemerror;return 1
end event

event dw_master::getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

end event

event dw_master::keydwn;call super::keydwn;string ls_columna, ls_cadena
integer li_column
long ll_row

// La tecla F2 despliega el cuadro de ayuda dependiendo de que columna estes ubicado
if key = KeyF2! then
	this.AcceptText()
	li_column = this.GetColumn()
	if li_column <= 0 then
		return 0
	end if
	ls_cadena = "#" + string( li_column ) + ".Protect"
	If this.Describe(ls_cadena) = '1' then RETURN
	
	
	ls_cadena = "#" + string( li_column ) + ".Name"
	ls_columna = upper( this.Describe(ls_cadena) )
	
	ll_row = this.GetRow()
	if ls_columna <> "!" then
	 	this.event dynamic ue_display( ls_columna, ll_row )
	end if
end if
return 0
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;Date 		ld_fecha
Boolean	lb_ret
Integer	li_ano, li_semana

this.object.fec_registro			[al_row] = f_fecha_actual()
this.object.fec_parte			   [al_row] = f_fecha_actual()
this.object.cod_usr					[al_row] = gs_user
this.object.flag_estado 			[al_row] = '1'

ld_fecha = date(f_fecha_actual())

of_get_fecha(ld_fecha)
DW_DETAIL.RESET( )
is_action = 'new'

end event

event dw_master::clicked;//Override

IF row = 0 OR is_dwform = 'form' THEN RETURN

end event

type dw_detail from w_abc_mastdet`dw_detail within w_pr323_transporte_personal
event ue_display ( string as_columna,  long al_row )
integer x = 0
integer y = 848
integer width = 2953
integer height = 872
string dataobject = "d_prod_transporte_det_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
end type

event dw_detail::ue_display;boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_nro_orden, &
			ls_oper_sec, ls_cencos, ls_desc_cencos, ls_cencos_r, ls_desc_cencos_r
Long		ll_row_find

str_parametros sl_param

choose case upper(as_columna)
		
	case "ZONA_PROCESO"
		
		ls_sql = "SELECT ZONA_PROCESO AS CODIGO_ZONA, " &
				  + "DESCR_ZONA_PROC AS DESCRIPCION_ZONA " &
				  + "FROM COM_ZONA_PROCESO " &
				  + "WHERE FLAG_ESTADO = '1'" &
				  + "AND NIVEL = 'D'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.zona_proceso[al_row] = ls_codigo
			this.object.desc_zona	[al_row] = ls_data
			
			select cencos 
				into :ls_cencos
			from com_zona_proceso
			where zona_proceso = :ls_codigo;
			
			select desc_cencos
				into :ls_desc_cencos
			from centros_costo
			where cencos = :ls_cencos;
			
			this.object.cencos 		[al_row] = ls_Cencos
			this.object.desc_cencos	[al_row] = ls_desc_cencos
			this.ii_update = 1
		end if
		
	case "CENCOS"

		ls_sql = "SELECT 	CENCOS AS CODIGO_CENCOS, " &
				  + "DESC_CENCOS AS DESCRIPCION " &
				  + "FROM CENTROS_COSTO " &
				  + "WHERE FLAG_ESTADO = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.cencos		[al_row] = ls_codigo
			this.object.desc_cencos	[al_row] = ls_data
			this.ii_update = 1
		end if

	case "NRO_ORDEN"

		ls_sql = "SELECT DISTINCT OT.NRO_ORDEN AS NUMERO_OT, " &
				 + "OP.OPER_SEC AS CODIGO_OPERACION, " &
				 + "OT.OT_ADM AS OT_ADMINISTRACION, " &
				 + "OP.DESC_OPERACION AS DESCRIPCION_OPERACION, " &
				 + "to_char(OT.FEC_INICIO, 'dd/mm/yyyy') AS FECHA_INICIO, " &
				 + "to_char(OT.FEC_ESTIMADA, 'dd/mm/yyyy') AS FECHA_ESTIMADA " &
				 + "FROM ORDEN_TRABAJO OT, "&
				 + "OPERACIONES OP " &
				 + "WHERE OP.FLAG_ESTADO = '1' " &
				 + "  AND OT.NRO_ORDEN = OP.NRO_ORDEN "&
				 + "  AND OP.SERVICIO = (SELECT y.servicio_transp FROM costo_param y) "

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.nro_orden[al_row] = ls_codigo
			this.object.oper_sec	[al_row]	= ls_data
			this.ii_update = 1
		end if

	case "OPER_SEC"
		
		ls_nro_orden = this.object.nro_orden[al_row]
		
		if ls_nro_orden = '' or IsNull(ls_nro_orden) then
			MessageBox('COMEDORES', 'NRO DE ORDEN DE TRABAJO INDEFINIDO',StopSign!)
			return
		end if

		ls_sql = "SELECT OPER_SEC AS CODIGO_OPERACION, " &
			  	 + "DESC_OPERACION AS DESCRIPCION_OPERACION, " &
				 + "to_char(FEC_INICIO, 'dd/mm/yyyy') AS FECHA_INICIO " &
				 + "FROM OPERACIONES " &
				 + "WHERE FLAG_ESTADO IN ('1','3') " &
				 + "AND NRO_ORDEN = '" + ls_nro_orden + "'"

		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.oper_sec	[al_row] = ls_codigo
			
			SELECT  C.CENCOS, C.DESC_CENCOS into :ls_cencos_r, :ls_desc_cencos_r
			FROM    OPERACIONES O, CENTROS_COSTO C
			WHERE   O.CENCOS    =  C.CENCOS
			AND     O.OPER_SEC  =  :ls_codigo;
			
			this.object.oper_sec		[al_row] = ls_codigo
			this.object.cencos		[al_row] = ls_cencos_r
			this.object.desc_cencos [al_row] = ls_desc_cencos_r	
			
			
			this.ii_update = 1
		end if
		
	case "CONFIN"
		
		sl_param.tipo			= ''
		sl_param.opcion		= 1
		sl_param.titulo 		= 'Selección de Concepto Financiero'
		sl_param.dw_master	= 'd_lista_grupo_financiero_grd'     //Filtrado para cierto grupo
		sl_param.dw1			= 'd_lista_concepto_financiero_grd'
		sl_param.dw_m			=  This
				
		OpenWithParm( w_abc_seleccion_md, sl_param)
		
		IF isvalid(message.PowerObjectParm) THEN 
			sl_param = message.PowerObjectParm			
		else
			return
		end if
		
		IF sl_param.titulo = 's' THEN
			this.ii_update = 1
		END IF

end choose
end event

event dw_detail::constructor;//Override
is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1			// columnas de lectrua de este dw
ii_ck[2] = 2			// columnas de lectrua de este dw
ii_rk[1] = 1 	      // columnas que recibimos del master




end event

event dw_detail::itemerror;call super::itemerror;Return 1
end event

event dw_detail::doubleclicked;call super::doubleclicked;string ls_columna
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

event dw_detail::getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

end event

event dw_detail::itemchanged;call super::itemchanged;string 	ls_codigo, ls_data, ls_nro_orden, ls_cencos_r, &
			ls_desc_cencos_r, ls_cencos, ls_desc_cencos
long		ll_count, ll_row_find
integer	li_numero_p

this.AcceptText()

if row <= 0 then
	return
end if

choose case upper(dwo.name)
	case "ZONA_PROCESO"
		
		ls_codigo = this.object.zona_proceso[row]

		SetNull(ls_data)
		select descr_zona_proc
			into :ls_data
		from com_zona_proceso
		where zona_proceso = :ls_codigo
		  and flag_estado = '1';
		
		if IsNull(ls_data) or ls_data = "" then
			Messagebox('COMEDORES', "ZONA DE PROCESO NO EXISTE O NO ESTA ACTIVO", StopSign!)
			SetNull(ls_codigo)
			this.object.zona_proceso	[row] = ls_codigo
			this.object.desc_zona		[row] = ls_codigo
			return 1
		end if

		this.object.desc_zona[row] = ls_data
		
		select cencos 
				into :ls_cencos
			from com_zona_proceso
			where zona_proceso = :ls_codigo;
			
			select desc_cencos
				into :ls_desc_cencos
			from centros_costo
			where cencos = :ls_cencos;
			
			this.object.cencos 		[row] = ls_Cencos
			this.object.desc_cencos	[row] = ls_desc_cencos

	case "CENCOS"
		ls_codigo = this.object.cencos[row]
		
		SetNull(ls_data)
		select desc_cencos
			into :ls_data
		from centros_costo
		where cencos = :ls_codigo
		  and flag_estado = '1';

		if IsNull(ls_data) or ls_data = "" then
			Messagebox('COMEDORES', "CODIGO DE CENTRO DE COSTO NO EXISTE O NO ESTA ACTIVO", StopSign!)
			SetNull(ls_codigo)
			this.object.cencos		[row] = ls_codigo
			this.object.desc_cencos	[row] = ls_codigo
			return 1
		end if
		
		this.object.desc_cencos[row] = ls_data
		
	case "NRO_PERSONAS"
		
		IF of_prorrata_total () = FALSE THEN Return 1
		
		li_numero_p = this.object.nro_personas [row]
		
		if li_numero_p <= 0 then
		messagebox('Modulo de Producción', 'Debe definir al menos una persona como pasajero')
		return 1
		else
		of_prorrata_total()
		end if
	
	case "NRO_ORDEN"
		ls_codigo = this.object.nro_orden[row]
		
		if ls_codigo = '' or IsNull(ls_codigo) then
			return
		end if
		
		SetNull(ls_data)

		select count(*)
			into :ll_count
		from orden_trabajo
		where nro_orden = :ls_codigo
		  and flag_estado in ('1', '2');

		
		if ll_count = 0 then 
			Messagebox('PRODUCCIÓN', "ORDEN DE TRABAJO NO EXISTE O NO ESTA ACTIVO", StopSign!)
			SetNull(ls_codigo)
			this.object.nro_orden	[row] = ls_codigo
			this.object.oper_sec		[row] = ls_codigo
			return 1
		end if
		
		this.object.oper_sec			[row] = ls_data

	case "OPER_SEC"
		
		ls_nro_orden = this.object.nro_orden[row]
		
		if ls_nro_orden = '' or IsNull(ls_nro_orden) then
			MessageBox('PRODUCCIÓN', 'NRO DE ORDEN DE TRABAJO INDEFINIDO',StopSign!)
			return
		end if
		
		ls_codigo = this.object.oper_sec[row]
		
		select count(*)
			into :ll_count
		from operaciones
		where nro_orden = :ls_nro_orden
		  and oper_sec  = :ls_codigo
		  and flag_estado in ('1', '2');
		

		if ll_count = 0 then 
			Messagebox('PRODUCCIÓN', "OPER_SER NO EXISTE, NO ESTA ACTIVO O NO CORRESPONDE A LA O.T.", StopSign!)
			SetNull(ls_codigo)
		return 1
		else
			
		SELECT  C.CENCOS, C.DESC_CENCOS into :ls_cencos_r, :ls_desc_cencos_r
		FROM    OPERACIONES O, CENTROS_COSTO C
			WHERE   O.CENCOS    =  C.CENCOS
			AND     O.OPER_SEC  =  :ls_codigo;
			
			this.object.oper_sec		[row] = ls_codigo
			this.object.cencos		[row] = ls_cencos_r
			this.object.desc_cencos [row] = ls_desc_cencos_r	
		end if

	case "CONFIN"
		
		SetNull(ls_data)
		select descripcion
			into :ls_data
		from concepto_financiero
		where confin = :data
		  and flag_estado = '1';
		  
		if ls_data = '' or IsNull(ls_data) then
			MessageBox('Aviso', 'Concepto Financiero no existe o no se encuentra activo', StopSign!)
			SetNull(ls_data)
			this.object.confin 		[row] = ls_data
			this.object.desc_confin [row] = ls_data
			return 1
		end if
		
		this.object.desc_confin [row] = ls_data
		
end choose
end event

event dw_detail::keydwn;call super::keydwn;string ls_columna, ls_cadena
integer li_column
long ll_row

// La tecla F2 despliega el cuadro de ayuda dependiendo de que columna estes ubicado
if key = KeyF2! then
	this.AcceptText()
	li_column = this.GetColumn()
	if li_column <= 0 then
		return 0
	end if
	ls_cadena = "#" + string( li_column ) + ".Protect"
	If this.Describe(ls_cadena) = '1' then RETURN
	
	
	ls_cadena = "#" + string( li_column ) + ".Name"
	ls_columna = upper( this.Describe(ls_cadena) )
	
	ll_row = this.GetRow()
	if ls_columna <> "!" then
	 	this.event dynamic ue_display( ls_columna, ll_row )
	end if
end if
return 0
end event

event dw_detail::ue_insert_pre;//Override

this.object.nro_item	[al_row] = of_nro_item(this)
this.object.cod_usr  [al_row] = gs_user


if al_row > 1 then
	this.object.zona_proceso [al_row] = this.object.zona_proceso[al_row - 1]
	this.object.desc_zona	 [al_row] = this.object.desc_zona	[al_row - 1]
	this.object.cencos		 [al_row] = this.object.cencos		[al_row - 1]
	this.object.desc_cencos	 [al_row] = this.object.desc_cencos	[al_row - 1]
	this.object.nro_orden	 [al_row] = this.object.nro_orden	[al_row - 1]
	this.object.oper_sec		 [al_row] = this.object.oper_sec		[al_row - 1]
	this.object.confin		 [al_row] = this.object.confin		[al_row - 1]
	this.object.desc_confin	 [al_row] = this.object.desc_confin	[al_row - 1]
end if

end event

event dw_detail::clicked;call super::clicked;string	ls_nro_parte

	ls_nro_parte = dw_master.object.nro_parte [dw_master.Getrow()]	

IF ls_nro_parte = ' ' or isnull(ls_nro_parte) THEN
	
	messagebox('Modulo de Producción','Primero debe guardar la Cabecera. Verifique')

	dw_master.event getfocus( )

	RETURN
	
end if
end event

type st_nro from statictext within w_pr323_transporte_personal
integer x = 64
integer y = 60
integer width = 439
integer height = 132
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Numero de Parte:"
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type sle_nro from singlelineedit within w_pr323_transporte_personal
integer x = 553
integer y = 76
integer width = 389
integer height = 92
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
textcase textcase = upper!
integer limit = 10
borderstyle borderstyle = stylelowered!
end type

event modified;cb_1.event clicked()
end event

type cb_1 from commandbutton within w_pr323_transporte_personal
integer x = 983
integer y = 72
integer width = 402
integer height = 100
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Buscar"
end type

event clicked;string ls_nro_certificado

EVENT ue_update_request()   // Verifica actualizaciones pendientes

ls_nro_certificado = Trim(sle_nro.text)

of_retrieve(ls_nro_certificado)

end event

