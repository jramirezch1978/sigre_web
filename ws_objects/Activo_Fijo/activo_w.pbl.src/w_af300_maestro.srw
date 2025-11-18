$PBExportHeader$w_af300_maestro.srw
forward
global type w_af300_maestro from w_abc
end type
type tab_1 from tab within w_af300_maestro
end type
type tabpage_1 from userobject within tab_1
end type
type dw_1 from u_dw_abc within tabpage_1
end type
type tabpage_1 from userobject within tab_1
dw_1 dw_1
end type
type tabpage_7 from userobject within tab_1
end type
type dw_7 from u_dw_abc within tabpage_7
end type
type tabpage_7 from userobject within tab_1
dw_7 dw_7
end type
type tabpage_8 from userobject within tab_1
end type
type dw_accesorios from u_dw_abc within tabpage_8
end type
type tabpage_8 from userobject within tab_1
dw_accesorios dw_accesorios
end type
type tabpage_2 from userobject within tab_1
end type
type dw_2 from u_dw_abc within tabpage_2
end type
type tabpage_2 from userobject within tab_1
dw_2 dw_2
end type
type tabpage_3 from userobject within tab_1
end type
type dw_3 from u_dw_abc within tabpage_3
end type
type tabpage_3 from userobject within tab_1
dw_3 dw_3
end type
type tabpage_4 from userobject within tab_1
end type
type dw_4 from u_dw_abc within tabpage_4
end type
type tabpage_4 from userobject within tab_1
dw_4 dw_4
end type
type tabpage_5 from userobject within tab_1
end type
type dw_5 from u_dw_abc within tabpage_5
end type
type tabpage_5 from userobject within tab_1
dw_5 dw_5
end type
type tabpage_6 from userobject within tab_1
end type
type dw_6 from u_dw_abc within tabpage_6
end type
type tabpage_6 from userobject within tab_1
dw_6 dw_6
end type
type tab_1 from tab within w_af300_maestro
tabpage_1 tabpage_1
tabpage_7 tabpage_7
tabpage_8 tabpage_8
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
tabpage_5 tabpage_5
tabpage_6 tabpage_6
end type
type dw_master from u_dw_abc within w_af300_maestro
end type
end forward

global type w_af300_maestro from w_abc
integer width = 3639
integer height = 2784
string title = "(AF300) Maestro de Activo Fijo"
string menuname = "m_master_mantenimiento"
long backcolor = 67108864
tab_1 tab_1
dw_master dw_master
end type
global w_af300_maestro w_af300_maestro

type variables
u_dw_abc  idw_datos, idw_dat_comp, idw_depreciacion, idw_incidencias , &
			 idw_adaptaciones, idw_traslados, idw_asignacion, idw_accesorios
			 //idw_mejoras, idw_mejoras_det

string  is_oper_depre, is_salir


end variables

forward prototypes
public function string of_set_numera_str ()
public subroutine of_accepttext ()
public subroutine of_retrieve (string as_cod_activo)
public function integer of_nro_item (datawindow adw_pd)
public function integer of_get_param ()
public subroutine of_set_dws ()
end prototypes

public function string of_set_numera_str ();// Numera documento
Long 		ll_count, ll_ult_nro, ll_i
String  	ls_next_nro, ls_lock_table, ls_mensaje, ls_origen

IF dw_master.getrow() = 0 THEN RETURN '0'

ls_origen = dw_master.object.cod_origen [dw_master.getrow()]

IF is_action = 'new' THEN
	SELECT count(*)
		INTO :ll_count
	FROM num_activo_fijo
	WHERE origen = :ls_origen;
	
	IF ll_count = 0 THEN
		ls_lock_table = 'LOCK TABLE num_activo_fijo IN EXCLUSIVE MODE'
		EXECUTE IMMEDIATE :ls_lock_table ;
		
		IF SQLCA.SQLCode < 0 THEN
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Aviso', ls_mensaje)
			RETURN '0'
		END IF
		
		INSERT INTO num_activo_fijo(origen, ult_nro, flag_replicacion)
		VALUES( :ls_origen, 1, '1');
		
		IF SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Aviso', ls_mensaje)
			RETURN '0'
		END IF
	END IF

	SELECT ult_nro
	  INTO :ll_ult_nro
	FROM num_activo_fijo
	WHERE origen = :ls_origen FOR UPDATE;
	
	UPDATE num_activo_fijo
		SET ult_nro = ult_nro + 1
	WHERE origen = :ls_origen;
	
	IF SQLCA.SQLCode < 0 THEN
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Aviso', ls_mensaje)
		RETURN '0'
	END IF
	
	ls_next_nro = trim(ls_origen) + string(ll_ult_nro, '00000000')
	
	dw_master.object.cod_activo[dw_master.getrow()] = ls_next_nro
	
	dw_master.ii_update = 1
	
ELSE
	ls_next_nro = dw_master.object.cod_activo[dw_master.getrow()] 
END IF

// Asigna numero a dw_accesorios
FOR ll_i = 1 to idw_accesorios.RowCount()
	idw_accesorios.object.cod_activo[ll_i] = ls_next_nro
NEXT

// Asigna numero a dw incidencias
FOR ll_i = 1 TO idw_incidencias.RowCount()
	idw_incidencias.object.cod_activo[ll_i] = ls_next_nro
NEXT 

// Asigna numero a dw adaptaciones
FOR ll_i = 1 TO idw_adaptaciones.RowCount()
	idw_adaptaciones.object.cod_activo[ll_i] = ls_next_nro
NEXT 

RETURN '1'

end function

public subroutine of_accepttext ();dw_master.accepttext( )
idw_datos.accepttext( )
idw_dat_comp.Accepttext( )
idw_accesorios.Accepttext( )
idw_depreciacion.accepttext( ) 
idw_incidencias.accepttext( )
idw_adaptaciones.accepttext( ) 

end subroutine

public subroutine of_retrieve (string as_cod_activo);// Funcion para recuperar datos de los activos

Long 		ll_row

ll_row = dw_master.retrieve( as_cod_activo )

idw_datos.retrieve			(as_cod_activo)
idw_dat_comp.retrieve		(as_cod_activo)
idw_accesorios.retrieve		(as_cod_activo)
idw_depreciacion.retrieve	(as_cod_activo, is_oper_depre)
idw_incidencias.retrieve	(as_cod_activo)
idw_adaptaciones.retrieve	(as_cod_activo)
idw_traslados.retrieve		(as_cod_activo)
idw_asignacion.retrieve		(as_cod_activo)
//idw_mejoras.retrieve			(as_cod_activo)

dw_master.ii_protect 		 = 0
idw_datos.ii_protect 		 = 0
idw_dat_comp.ii_protect		 = 0
idw_accesorios.ii_protect	 = 0
idw_depreciacion.ii_protect = 0
idw_incidencias.ii_protect  = 0
idw_adaptaciones.ii_protect = 0
idw_traslados.ii_protect 	 = 0
idw_asignacion.ii_protect 	 = 0
//idw_mejoras.ii_protect 	 	 = 0
//idw_mejoras_det.ii_protect  = 0

dw_master.of_protect			( )
idw_datos.of_protect			( )
idw_dat_comp.of_protect		( )
idw_accesorios.of_protect	( )
idw_depreciacion.of_protect( )
idw_incidencias.of_protect	( )
idw_adaptaciones.of_protect( )
idw_traslados.of_protect	( )
idw_asignacion.of_protect	( )
//idw_mejoras.of_protect		( )
//idw_mejoras_det.of_protect	( )

dw_master.ii_update 			= 0
idw_datos.ii_update 			= 0
idw_dat_comp.ii_update		= 0
idw_accesorios.ii_update	= 0
idw_depreciacion.ii_update = 0
idw_incidencias.ii_update 	= 0
idw_adaptaciones.ii_update = 0

is_Action = 'open'

//of_set_status_menu(dw_master)

end subroutine

public function integer of_nro_item (datawindow adw_pd);integer li_item, li_x

li_item = 0

For li_x = 1 to adw_pd.RowCount()
	IF li_item < adw_pd.object.nro_item[li_x] THEN
		li_item = adw_pd.object.nro_item[li_x]
	END IF
Next

Return li_item + 1


end function

public function integer of_get_param ();// Funcion para obtener parametros

String  ls_mensaje

//Parametros de LogParam

SELECT DEPRECIACION
 INTO  :is_oper_depre
FROM   AF_CALCULO_PARAM
 WHERE RECKEY = '1';

IF SQLCA.SQLCode = 100 THEN
	MessageBox('Aviso', 'No ha definido parametros en AF_CALCULO_PARAM')
	RETURN 0
END IF

IF sqlca.sqlcode < 0 THEN
	Messagebox( "Error en busqueda parametros AF_CALCULO_PARAM", sqlca.sqlerrtext)
	RETURN 0	
END IF

IF ISNULL( is_oper_depre ) or TRIM( is_oper_depre ) = '' THEN
	Messagebox("Error de parametros", "Defina OPER_DEPRE en AF_CALCULO_PARAM")
	RETURN 0
END IF


RETURN 1


end function

public subroutine of_set_dws ();idw_datos 			= tab_1.tabpage_1.dw_1
idw_dat_comp		= tab_1.tabpage_7.dw_7
idw_accesorios		= tab_1.tabpage_8.dw_accesorios
idw_depreciacion 	= tab_1.tabpage_2.dw_2
idw_incidencias 	= tab_1.tabpage_3.dw_3
idw_adaptaciones 	= tab_1.tabpage_4.dw_4
idw_traslados		= tab_1.tabpage_5.dw_5
idw_asignacion		= tab_1.tabpage_6.dw_6
//idw_mejoras			= tab_1.tabpage_9.dw_8
//idw_mejoras_det	= tab_1.tabpage_9.dw_9
end subroutine

on w_af300_maestro.create
int iCurrent
call super::create
if this.MenuName = "m_master_mantenimiento" then this.MenuID = create m_master_mantenimiento
this.tab_1=create tab_1
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_1
this.Control[iCurrent+2]=this.dw_master
end on

on w_af300_maestro.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.tab_1)
destroy(this.dw_master)
end on

event resize;call super::resize;This.SetRedraw(false)
this.of_set_dws()

dw_master.width  = newwidth  - dw_master.x - 10

tab_1.height = newheight - tab_1.y - 10
tab_1.width  = newwidth  - tab_1.x - 10


//resize de los objetos dentro del tab

idw_datos.width  = tab_1.width  - idw_datos.x - 40
idw_datos.height = tab_1.height - idw_datos.y - 150

idw_dat_comp.width  = tab_1.width  - idw_dat_comp.x - 40
idw_dat_comp.height = tab_1.height - idw_dat_comp.y - 150

idw_accesorios.width  = tab_1.width  - idw_accesorios.x - 40
idw_accesorios.height = tab_1.height - idw_accesorios.y - 150

idw_depreciacion.width  = tab_1.width  - idw_depreciacion.x - 40
idw_depreciacion.height = tab_1.height - idw_depreciacion.y - 150

idw_incidencias.width  = tab_1.width  - idw_incidencias.x - 40
idw_incidencias.height = tab_1.height - idw_incidencias.y - 150

idw_adaptaciones.width  = tab_1.width  - idw_adaptaciones.x - 40
idw_adaptaciones.height = tab_1.height - idw_adaptaciones.y - 150

idw_traslados.width  = tab_1.width  - idw_traslados.x - 40
idw_traslados.height = tab_1.height - idw_traslados.y - 150

idw_asignacion.width  = tab_1.width  - idw_asignacion.x - 40
idw_asignacion.height = tab_1.height - idw_asignacion.y - 150

//idw_mejoras.width  = tab_1.width  - idw_mejoras.x - 40
//idw_mejoras_det.width  = tab_1.width  - idw_mejoras_det.x - 40
//idw_mejoras_det.height = tab_1.height - idw_mejoras_det.y - 150

This.SetRedraw(true)
end event

event ue_open_pre;call super::ue_open_pre;IF of_get_param() = 0 THEN
   is_salir = 'S'
	post event closequery()   
END IF

is_action = 'open'

dw_master.SetTransObject(sqlca)  	// Relacionar el dw con la base de datos
dw_master.ii_protect = 0
dw_master.of_protect()         		// bloquear modificaciones 

//Datawindow por defecto
idw_1 = dw_master

idw_datos.SetTransObject			(SQLCA)
idw_dat_comp.SettransObject 		(SQLCA)
idw_accesorios.SettransObject		(SQLCA)
idw_depreciacion.SetTransObject	(SQLCA)	
idw_incidencias.SetTransObject	(SQLCA)
idw_adaptaciones.SetTransObject	(SQLCA)
idw_traslados.SetTransObject		(SQLCA)
idw_asignacion.SetTransObject		(SQLCA)
//idw_mejoras.SetTransObject			(SQLCA)
//idw_mejoras_det.SetTransObject	(SQLCA)


// Compartiendo dw
dw_master.sharedata(idw_datos)
dw_master.sharedata(idw_dat_comp)


end event

event ue_delete_pos;call super::ue_delete_pos;//dw_master.ii_update = 1
end event

event ue_insert;call super::ue_insert;Long   ll_row_master, ll_row, ll_verifica
String ls_clase


of_accepttext() //accepttext de los dw

ll_row_master = dw_master.getrow( )

CHOOSE CASE idw_1
	CASE dw_master
	   // Adicionando en dw_master
	   TriggerEvent ('ue_update_request') //verificar ii_update de los dw
	   IF ib_update_check = FALSE THEN RETURN
	  
	   // Limpieza de los demas dw en insercion
	   idw_datos.reset		 ( ) 
		idw_dat_comp.reset	 ( )
	   idw_depreciacion.reset( )
	   idw_incidencias.reset ( )
	   idw_adaptaciones.reset( )
	   idw_traslados.reset	 ( )
	 
	   //desproteger dw detalle 
	   idw_datos.ii_protect 	= 1
		idw_dat_comp.ii_protect	= 1
	   idw_datos.of_protect		( )
		idw_dat_comp.of_protect ( )

  	   is_action = 'new' 
	
	CASE idw_accesorios
		IF dw_master.GetRow() = 0 THEN
			MessageBox('Error', 'No puede insertar un detalle si no tiene cabecera')
			RETURN
		END IF
		
	CASE idw_depreciacion
		
		MessageBox('Error', 'No se puede insertar registros en esta región')
		RETURN
			
		/*
		IF dw_master.GetRow() = 0 THEN
			MessageBox('Error', 'No puede insertar un detalle si no tiene cabecera')
			RETURN
		END IF
		
		ls_clase = dw_master.Object.clase[ll_row_master]
	
		IF IsNull(ls_clase) OR ls_clase = '' THEN
			MessageBox('Aviso', 'INGRESE CLASE EN CABECERA, POR FAVOR VERIFIQUE', StopSign!)
			RETURN
		END IF
		
		SELECT count(*)
		  INTO :ll_verifica
		FROM af_clase
		WHERE cnta_ctbl = :ls_clase 
		  AND nvl(flag_depreciacion, '0') = '0' ;
			
		IF ll_verifica > 0 then
			MessageBox('Aviso','Según su clase, este activo no se deprecia')
			RETURN
		END IF
		*/
		
	CASE idw_incidencias
		IF dw_master.GetRow() = 0 THEN
			MessageBox('Error', 'No puede insertar un detalle si no tiene cabecera')
			RETURN
		END IF
		
	CASE idw_adaptaciones
		IF dw_master.GetRow() = 0 THEN
			MessageBox('Error', 'No puede insertar un detalle si no tiene cabecera')
			RETURN
		END IF
	
   CASE ELSE
	  RETURN
	  
END CHOOSE

//insertar
ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN
	THIS.EVENT ue_insert_pos(ll_row)
END IF


end event

event ue_retrieve_list;call super::ue_retrieve_list;Str_parametros sl_param

sl_param.dw1 = "d_seleccion_activos_tbl"
sl_param.titulo = "Busqueda de ACTIVOS FIJOS"
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2

OpenWithParm(w_search, sl_param)	

sl_param = MESSAGE.POWEROBJECTPARM

IF sl_param.titulo <> 'n' THEN
	of_retrieve(sl_param.field_ret[1])
END IF


end event

event ue_update;// Override
Boolean lbo_ok = TRUE
Integer	li_rc
String	ls_msg

of_accepttext() 

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN


// Para el Log Diario

IF ib_log THEN
	dw_master.of_create_log()
	idw_accesorios.of_create_log()
	idw_depreciacion.of_create_log()
	idw_incidencias.of_create_log()
	idw_adaptaciones.of_create_log()
END IF

ls_msg = "Se ha procedido al Rollback"

IF	(dw_master.ii_update = 1 or idw_datos.ii_update = 1 or idw_dat_comp.ii_update = 1) and lbo_ok THEN
	IF dw_master.Update(true, false) = -1 then		            // Grabación del Masestro
		lbo_ok = FALSE
		Rollback;
		MessageBox("Error de Grabación del Maestro", ls_msg, exclamation!)
	END IF
END IF

//IF idw_datos.ii_update = 1 THEN
//	IF idw_datos.Update(true, false) = -1 then		// Grabación del detalle
//		lbo_ok = FALSE
//		Rollback;
//		MessageBox("Error de Grabación Datos Generales", ls_msg, exclamation!)
//	END IF
//END IF
//
//IF idw_dat_comp.ii_update = 1 THEN
//	IF idw_dat_comp.Update(true, false) = -1 then		// Grabación de Datos Complementarios
//		Rollback;
//		MessageBox("Error de Grabación Datos Complementarios", ls_msg, exclamation!)
//	END IF
//END IF

IF idw_accesorios.ii_update = 1 THEN
	IF idw_accesorios.Update(true, false) = -1 then		// Grabación del detalle
		lbo_ok = FALSE
		Rollback;
		MessageBox("Error de Grabación en Accesorios", ls_msg, exclamation!)
	END IF
END IF

IF idw_depreciacion.ii_update = 1 THEN
	IF idw_depreciacion.Update(true, false) = -1 then		// Grabación del detalle
		lbo_ok = FALSE
		Rollback;
		MessageBox("Error de Grabación en Depreciacion", ls_msg, exclamation!)
	END IF
END IF

IF idw_incidencias.ii_update = 1 THEN
	IF idw_incidencias.Update(true, false) = -1 then		// Grabación del detalle
		lbo_ok = FALSE
		Rollback;
		MessageBox("Error de Grabación en Incidencias", ls_msg, exclamation!)
	END IF
END IF

IF idw_adaptaciones.ii_update = 1 THEN
	IF idw_adaptaciones.Update(true, false) = -1 then		// Grabación del detalle
		lbo_ok = FALSE
		Rollback;
		MessageBox("Error de Grabación en Adaptaciones", ls_msg, exclamation!)
	END IF
END IF

ls_msg = 'No se pudo grabar el Log Diario'
//Para el log diario
IF ib_log THEN
	dw_master.of_save_log()
	idw_accesorios.of_create_log()
	idw_depreciacion.of_create_log()
	idw_incidencias.of_create_log()
	idw_adaptaciones.of_create_log()
END IF


IF lbo_ok THEN
	COMMIT using SQLCA;
	
	dw_master.ii_update 			= 0
	idw_datos.ii_update 			= 0
	idw_dat_comp.ii_update 		= 0
	idw_accesorios.ii_update 	= 0
	idw_depreciacion.ii_update	= 0
	idw_incidencias.ii_update	= 0
	idw_adaptaciones.ii_update	= 0
	
	dw_master.ii_protect 		 = 0
	idw_datos.ii_protect 		 = 0
	idw_dat_comp.ii_protect 	 = 0
	idw_accesorios.ii_protect 	 = 0
	idw_depreciacion.ii_protect = 0
	idw_incidencias.ii_protect  = 0
	idw_adaptaciones.ii_protect = 0
	
	dw_master.of_protect( )
	idw_datos.of_protect( )
	idw_dat_comp.of_protect( )
	idw_accesorios.of_protect( )
	idw_depreciacion.of_protect( )
	idw_incidencias.of_protect( )
	idw_adaptaciones.of_protect( )
	
	dw_master.ResetUpdate( )
	idw_datos.ResetUpdate( )
	idw_dat_comp.ResetUpdate( )
	idw_accesorios.ResetUpdate( )
	idw_depreciacion.ResetUpdate( )
	idw_incidencias.ResetUpdate( )
	idw_adaptaciones.ResetUpdate( )
	
	is_action = 'open'
	
END IF

end event

event ue_update_pre;
IF dw_master.rowcount( ) = 0 THEN RETURN

ib_update_check = FALSE

// Verifica datos obligatorios en el dw_master
IF f_row_Processing( dw_master, "form") <> TRUE THEN RETURN

// Verifica datos obligatorios en el dw_datos_generales
IF f_row_Processing( idw_datos, "form") <> TRUE THEN RETURN

// Verifica datos obligatorios en el dw_dat_comp
IF f_row_Processing( idw_dat_comp, "form") <> TRUE THEN RETURN

// Verifica datos obligatorios en el dw_accesorios
IF f_row_Processing( idw_accesorios, "tabular") <> TRUE THEN RETURN

// Verifica datos obligatorios en el dw_depreciacion
IF f_row_Processing( idw_depreciacion, "tabular") <> TRUE THEN RETURN

// Verifica datos obligatorios en el dw_incidencias
IF f_row_Processing( idw_incidencias, "tabular") <> TRUE THEN RETURN

// Verifica datos obligatorios en el dw_adaptaciones
IF f_row_Processing( idw_adaptaciones, "tabular") <> TRUE THEN RETURN

////Para la replicacion de datos
dw_master.of_set_flag_replicacion		 ( )
idw_depreciacion.of_set_flag_replicacion( )
idw_incidencias.of_set_flag_replicacion ( )
idw_adaptaciones.of_set_flag_replicacion( )

// Para verificar si tiene adaptaciones
IF idw_adaptaciones.rowcount( ) > 0 THEN
	idw_datos.object.flag_adaptacion[dw_master.getrow()] = '1'
	idw_datos.ii_update = 1
ELSEIF idw_datos.object.flag_adaptacion[dw_master.getrow()] = '1' THEN
	idw_datos.object.flag_adaptacion[dw_master.getrow()] = '0'
	idw_datos.ii_update = 1
END IF

// Numeracion de documento maestro
IF of_set_numera_str() = '0' THEN RETURN

// Si todo ha salido bien cambio el indicador ib_update_check a true, para indicarle
// al evento ue_update que todo ha salido bien
ib_update_check = TRUE


end event

event ue_update_request;Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
IF (dw_master.ii_update = 1 OR idw_datos.ii_update = 1 OR &
	idw_dat_comp.ii_update = 1 OR idw_accesorios.ii_update = 1 OR &
   idw_depreciacion.ii_update = 1 OR idw_incidencias.ii_update = 1 OR &
	idw_adaptaciones.ii_update = 1 ) THEN
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	IF li_msg_result = 1 THEN
 		this.TriggerEvent("ue_update")
	ELSE
		dw_master.ii_update 			= 0
		idw_datos.ii_update 			= 0
		idw_dat_comp.ii_update		= 0
		idw_accesorios.ii_update	= 0
		idw_depreciacion.ii_update = 0	
		idw_incidencias.ii_update 	= 0
		idw_adaptaciones.ii_update = 0	
		ROLLBACK;
	END IF
END IF


end event

event ue_modify;call super::ue_modify;Long    ll_row
Integer li_protect
String  ls_protect

ll_row = dw_master.Getrow()
dw_master.accepttext()

IF ll_row = 0 THEN RETURN

dw_master.of_protect			( )
idw_datos.of_protect			( )
idw_dat_comp.of_protect		( )
idw_accesorios.of_protect	( )
idw_depreciacion.of_protect( )
idw_incidencias.of_protect	( )
idw_adaptaciones.of_protect( )
idw_traslados.of_protect	( )
idw_asignacion.of_protect 	( )
//idw_mejoras.of_protect		( )
//idw_mejoras_det.of_protect	( )


ls_protect = dw_master.Describe("cod_origen.protect")

if ls_protect='0' then
   dw_master.of_column_protect('cod_origen')
end if
end event

event open;//Ancestor Script Override
of_set_dws()

IF this.of_access(gs_user, THIS.ClassName()) THEN
	THIS.EVENT ue_open_pre()
	THIS.EVENT ue_dw_share()
ELSE
	CLOSE(THIS)
END IF
end event

event closequery;call super::closequery;IF is_salir = 'S' THEN
	CLOSE (this)
END IF
end event

type tab_1 from tab within w_af300_maestro
integer y = 1152
integer width = 2885
integer height = 1364
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
boolean focusonbuttondown = true
boolean boldselectedtext = true
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_7 tabpage_7
tabpage_8 tabpage_8
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
tabpage_5 tabpage_5
tabpage_6 tabpage_6
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_7=create tabpage_7
this.tabpage_8=create tabpage_8
this.tabpage_2=create tabpage_2
this.tabpage_3=create tabpage_3
this.tabpage_4=create tabpage_4
this.tabpage_5=create tabpage_5
this.tabpage_6=create tabpage_6
this.Control[]={this.tabpage_1,&
this.tabpage_7,&
this.tabpage_8,&
this.tabpage_2,&
this.tabpage_3,&
this.tabpage_4,&
this.tabpage_5,&
this.tabpage_6}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_7)
destroy(this.tabpage_8)
destroy(this.tabpage_2)
destroy(this.tabpage_3)
destroy(this.tabpage_4)
destroy(this.tabpage_5)
destroy(this.tabpage_6)
end on

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 2848
integer height = 1236
long backcolor = 67108864
string text = "D. Generales"
string picturename = "DosEdit5!"
long picturemaskcolor = 536870912
dw_1 dw_1
end type

on tabpage_1.create
this.dw_1=create dw_1
this.Control[]={this.dw_1}
end on

on tabpage_1.destroy
destroy(this.dw_1)
end on

type dw_1 from u_dw_abc within tabpage_1
event ue_display ( string as_columna,  long al_row )
integer width = 2729
integer height = 1220
integer taborder = 30
string dataobject = "dw_datos_generales_ff"
borderstyle borderstyle = styleraised!
end type

event ue_display;boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_string, ls_evaluate, &
			ls_cod_ubi, ls_null
decimal  ld_null
			
SetNull(ls_null)
SetNull(ld_null)

ls_string = this.Describe(lower(as_columna) + '.Protect' )

IF len(ls_string) > 1 THEN
	ls_string = Mid(ls_string, Pos(ls_string, '~t') + 1)
	ls_string = Mid(ls_string,1, len(ls_string) - 1 )
	ls_evaluate = "Evaluate('" + ls_string + "', " + string(al_row) + ")"
	IF This.Describe(ls_evaluate) = '1' THEN RETURN
ELSE
	IF ls_string = '1' THEN RETURN
END IF

CHOOSE CASE lower(as_columna)

	CASE 'tipo_doc_adq'
		ls_sql = "select tipo_doc as codigo, " &
				  +"desc_tipo_doc as descripcion " &
				  +"from doc_tipo " &
				  +"where flag_estado = '1' "
				  
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		IF ls_codigo <> '' THEN
			This.object.tipo_doc_adq[al_row] = ls_codigo
			This.ii_update = 1
		END IF
		
	CASE 'proveedor'
		ls_sql = "select proveedor as codigo, " &
		        +"nom_proveedor as descripcion " &
				  +"from proveedor " &
				  +"where flag_estado = '1' "
				  
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		IF ls_codigo <> '' THEN
			This.object.proveedor	 [al_row] = ls_codigo
			This.object.nom_proveedor[al_row] = ls_data
			This.ii_update = 1
		END IF
		
	CASE 'cod_moneda'
		ls_sql = "select cod_moneda as codigo, " &
		        +"descripcion as nombre " &
				  +"from moneda " &
				  +"where flag_estado = '1' "
		
		lb_ret =f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		IF ls_codigo <> '' THEN
			This.object.cod_moneda			[al_row] = ls_codigo
			This.object.desc_moneda		[al_row] = ls_data
			This.ii_update = 1
		END IF
	
	CASE 'ubicacion'
		ls_sql = "select ubicacion as codigo, " &
		        +"descripcion as nombre " &
				  +"from af_ubicacion " 
		
		lb_ret =f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		IF ls_codigo <> '' THEN
			This.object.ubicacion				[al_row] = ls_codigo
			This.object.desc_ubicacion 		[al_row] = ls_data
			This.ii_update = 1
		END IF
		
		This.object.item						[al_row] = ld_null
		This.object.desc_item					[al_row] = ls_null
		
	CASE 'item'
		ls_cod_ubi = This.object.ubicacion[al_row]
		ls_sql = "select item as cod_item, " &
		        +"descripcion as nombre " &
				  +"from af_ubicacion_det " &
				  +"where ubicacion = '"+ls_cod_ubi +"'"
				
		lb_ret =f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		IF ls_codigo <> '' THEN
			This.object.item				[al_row] = long(ls_codigo)
			This.object.desc_item			[al_row] = ls_data
			This.ii_update = 1
		END IF
	
//	CASE 'usr_asignado'
//		ls_sql = "select cod_usr as cod_usuario, " &
//		        +"nombre as nombre_usuario " &
//				  +"from usuario " &
//				  +"where flag_estado = '1'"
//				
//		lb_ret =f_lista(ls_sql, ls_codigo, ls_data, '2')
//		
//		IF ls_codigo <> '' THEN
//			This.object.usr_asignado[al_row] = ls_codigo
//			This.object.nombre		[al_row] = ls_data
//			This.ii_update = 1
//		END IF

END CHOOSE

end event

event constructor;call super::constructor;ii_ck[1] = 2   		    // columnas de lectrua de este dw
//ii_rk[1] = 1 	          // columnas que recibimos del master
//ii_dk[1] = 1			    // columnas que se pasan al detalle

is_dwform = 'form'	   // tabular, form (default)

end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!


end event

event doubleclicked;call super::doubleclicked;string ls_columna
long ll_row 


THIS.AcceptText()
IF This.Describe(dwo.Name + ".Protect") = '1' THEN RETURN
ll_row = row

IF row > 0 THEN
	ls_columna = upper(dwo.name)
	This.event dynamic ue_display(ls_columna, ll_row)
END IF



end event

event itemchanged;call super::itemchanged;String 	ls_data, ls_null, ls_cod_ubi
decimal	ld_null

SetNull(ls_null)
SetNull(ld_null)

This.Accepttext()

IF row <= 0 THEN RETURN

CHOOSE CASE dwo.name
	CASE 'proveedor'
 		SELECT nom_proveedor
		  INTO :ls_data
		FROM proveedor
		WHERE proveedor = :data
		 AND flag_estado = '1';
		
		IF SQLCA.sqlcode = 100 THEN
			MessageBox('Aviso', 'PROVEEDOR NO EXISTE O NO ESTA ACTIVO, POR FAVOR VERIFIQUE', StopSign!)
			this.object.proveedor		[row] = ls_null
			this.object.nom_proveedor	[row]	= ls_null
			RETURN 1
		END IF
			
	   This.object.nom_proveedor[row] = ls_data
		
	CASE 'cod_moneda'
		SELECT descripcion
		  INTO :ls_data
		FROM   moneda
		WHERE  cod_moneda = :data
		  AND  flag_estado = '1';
		
		IF SQLCA.sqlcode = 100 THEN
			MessageBox('Aviso', 'MONEDA NO EXISTE O NO ESTA ACTIVO, POR FAVOR VERIFIQUE', StopSign!)
			this.object.moneda				[row] = ls_null
			this.object.moneda_descripcion[row]	= ls_null
			RETURN 1
		END IF
		
		This.object.moneda_descripcion[row] = ls_data
	
	CASE 'tipo_doc_adq'
		SELECT desc_tipo_doc
		  INTO :ls_data
		FROM 	  doc_tipo
		WHERE  tipo_doc = :data
		 AND  flag_estado = '1';
		
		IF SQLCA.sqlcode = 100 THEN
			MessageBox('Aviso', 'DOCUMENTO NO EXISTE O NO ESTA ACTIVO, POR FAVOR VERIFIQUE', StopSign!)
			This.object.tipo_doc_adq[row] = ls_null
			RETURN 1
		END IF
	
	CASE 'ubicacion'
		SELECT descripcion
		  INTO :ls_data
		FROM af_ubicacion
		where ubicacion = :data;
		
		IF SQLCA.sqlcode = 100 THEN
			MessageBox('Aviso', 'UBICACION NO EXISTE O NO ESTA ACTIVO, POR FAVOR VERIFIQUE', StopSign!)
			This.object.ubicacion				[row] = ls_null
			This.object.ubicacion_descripcion[row] = ls_null
			RETURN 1
		END IF
		
		This.object.ubicacion_descripcion[row] = ls_data
		
		This.object.item_ubicacion		[row] = ld_null
		This.object.item_descripcion	[row] = ls_null
		
	CASE 'item_ubicacion'
		ls_cod_ubi = This.object.ubicacion[row]
		SELECT descripcion as nombre
		  INTO :ls_data
		FROM af_ubicacion_det
		WHERE ubicacion = :ls_cod_ubi
		 AND	item = :data;
		
		IF SQLCA.sqlcode = 100 THEN
			MessageBox('Aviso', 'ITEM NO EXISTE O NO ESTA ACTIVO, POR FAVOR VERIFIQUE', StopSign!)
			This.object.item_ubicacion		[row] = ld_null
			This.object.item_descripcion	[row] = ls_null
			RETURN 1
		END IF
		
		This.object.item_descripcion	[row] = ls_data
	
//	CASE 'usr_asignado'
//			SELECT NOMBRE
//			  INTO :ls_data
//			FROM   USUARIO
//			WHERE  COD_USR = :data
//			  AND  flag_estado = '1';
//			
//			IF SQLCA.sqlcode = 100 THEN
//				MessageBox('Aviso', 'CODIGO NO EXISTE O NO ESTA ACTIVO, POR FAVOR VERIFIQUE', StopSign!)
//				This.object.usr_asignado[row] = ls_null
//				This.object.nombre		[row]	= ls_null
//				RETURN 1
//			END IF
//			
//		  This.object.nombre[row] = ls_data
	
END CHOOSE



end event

event itemerror;call super::itemerror;RETURN 1
end event

type tabpage_7 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 2848
integer height = 1236
long backcolor = 79741120
string text = "D. Complementarios"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "DosEdit5!"
long picturemaskcolor = 536870912
dw_7 dw_7
end type

on tabpage_7.create
this.dw_7=create dw_7
this.Control[]={this.dw_7}
end on

on tabpage_7.destroy
destroy(this.dw_7)
end on

type dw_7 from u_dw_abc within tabpage_7
event ue_display ( string as_columna,  long al_row )
integer width = 2734
integer height = 1044
integer taborder = 20
string dataobject = "dw_datos_complementarios_ff"
borderstyle borderstyle = styleraised!
end type

event ue_display;boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_string, ls_evaluate, &
			ls_cod_ubi, ls_null
decimal  ld_null
			
SetNull(ls_null)
SetNull(ld_null)

ls_string = this.Describe(lower(as_columna) + '.Protect' )

IF len(ls_string) > 1 THEN
	ls_string = Mid(ls_string, Pos(ls_string, '~t') + 1)
	ls_string = Mid(ls_string,1, len(ls_string) - 1 )
	ls_evaluate = "Evaluate('" + ls_string + "', " + string(al_row) + ")"
	IF This.Describe(ls_evaluate) = '1' THEN RETURN
ELSE
	IF ls_string = '1' THEN RETURN
END IF

CHOOSE CASE lower(as_columna)
	CASE 'prov_tasador'
		ls_sql = "select proveedor as codigo, " &
		        +"nom_proveedor as descripcion " &
				  +"from proveedor " &
				  +"where flag_estado = '1' "
				  
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		IF ls_codigo <> '' THEN
			This.object.prov_tasador	 [al_row] = ls_codigo
			This.object.nom_prov_tasador[al_row] = ls_data
			This.ii_update = 1
		END IF
		
	CASE 'moneda_tasac'
		ls_sql = "select cod_moneda as codigo, " &
		        +"descripcion as nombre " &
				  +"from moneda " &
				  +"where flag_estado = '1' "
		
		lb_ret =f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		IF ls_codigo <> '' THEN
			This.object.moneda_tasac	[al_row] = ls_codigo
			This.ii_update = 1
		END IF
	CASE 'usr_asignado'
		ls_sql = "select cod_usr as codigo, "&
					+"nombre as nombre"&
					+"  from usuario "&
					+"where flag_estado = '1'"
		
		lb_ret =f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		IF ls_codigo <> '' THEN
			This.object.usr_asignado		[al_row] = ls_codigo
			This.object.nom_usr_asignado	[al_row] = ls_data
			This.ii_update = 1
		END IF

END CHOOSE

end event

event constructor;call super::constructor;ii_ck[1] = 2   		    // columnas de lectrua de este dw
//ii_rk[1] = 1 	          // columnas que recibimos del master
//ii_dk[1] = 1			    // columnas que se pasan al detalle

is_dwform = 'form'	   // tabular, form (default)

end event

event itemchanged;call super::itemchanged;String 	ls_data,  ls_cod_ubi
decimal	ld_null
Long		ll_count

This.Accepttext()

IF row <= 0 THEN RETURN

CHOOSE CASE dwo.name
	CASE 'prov_tasador'
 		SELECT nom_proveedor
		  INTO :ls_data
		FROM proveedor
		WHERE proveedor = :data
		 AND flag_estado = '1';
		
		IF SQLCA.sqlcode = 100 THEN
			MessageBox('Aviso', 'PROVEEDOR NO EXISTE O NO ESTA ACTIVO, POR FAVOR VERIFIQUE', StopSign!)
			this.object.prov_tasador		[row] = gnvo_app.is_null
			this.object.nom_prov_tasador	[row]	= gnvo_app.is_null
			RETURN 1
		END IF
			
	   This.object.nom_prov_tasador[row] = ls_data
	
	CASE 'moneda_tasac'

		SELECT count(cod_moneda)
		  INTO :ll_count
		FROM   moneda
		WHERE  cod_moneda = :data
		  AND  flag_estado = '1';
		
		IF ll_count = 0 THEN
			MessageBox('Aviso', 'MONEDA NO EXISTE O NO ESTA ACTIVO, POR FAVOR VERIFIQUE', StopSign!)
			this.object.moneda_tasac [row] = gnvo_app.is_null
			RETURN 1
		END IF
	
	CASE 'usr_asignado'

		SELECT nombre
		  INTO :ls_data
		FROM   usuario
		WHERE  cod_usr 		= :data
		  AND  flag_estado 	= '1';
		
		IF SQLCA.sqlcode = 100 THEN
			MessageBox('Aviso', 'Usuario ' + ls_data + ' no existe o no esta activo', StopSign!)
			this.object.usr_asignado 		[row] = gnvo_app.is_null
			this.object.nom_usr_asignado 	[row] = gnvo_app.is_null
			RETURN 1
		END IF
		
		this.object.nom_usr_asignado 	[row] = ls_data

END CHOOSE


end event

event doubleclicked;call super::doubleclicked;string ls_columna
long ll_row 
str_seleccionar lstr_seleccionar

THIS.AcceptText()
IF This.Describe(dwo.Name + ".Protect") = '1' THEN RETURN
ll_row = row

IF row > 0 THEN
	ls_columna = upper(dwo.name)
	This.event dynamic ue_display(ls_columna, ll_row)
END IF
end event

event buttonclicked;call super::buttonclicked;string ls_observacion

ls_observacion = this.object.obs[row]

openwithparm(w_af_observacion, ls_observacion)

if not isnull(Message.StringParm) then
	
	this.object.obs[row] = trim(Message.StringParm)
	this.ii_update = 1
	
end if
end event

event itemerror;call super::itemerror;RETURN 1
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

type tabpage_8 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 2848
integer height = 1236
long backcolor = 79741120
string text = "Accesorios"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "Application5!"
long picturemaskcolor = 536870912
dw_accesorios dw_accesorios
end type

on tabpage_8.create
this.dw_accesorios=create dw_accesorios
this.Control[]={this.dw_accesorios}
end on

on tabpage_8.destroy
destroy(this.dw_accesorios)
end on

type dw_accesorios from u_dw_abc within tabpage_8
integer width = 2770
integer height = 1008
integer taborder = 20
string dataobject = "dw_abc_accesorios_tbl"
borderstyle borderstyle = styleraised!
end type

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event ue_insert_pre;call super::ue_insert_pre;
This.object.nro_item	[al_row] = of_nro_item(this)
end event

event constructor;call super::constructor;ii_ck[1] = 1
ii_ck[2] = 2

is_dwform = 'tabular'	 // tabular, form (default)
end event

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 2848
integer height = 1236
long backcolor = 79741120
string text = "Depreciación"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "Parameter!"
long picturemaskcolor = 536870912
dw_2 dw_2
end type

on tabpage_2.create
this.dw_2=create dw_2
this.Control[]={this.dw_2}
end on

on tabpage_2.destroy
destroy(this.dw_2)
end on

type dw_2 from u_dw_abc within tabpage_2
event ue_display ( string as_columna,  long al_row )
integer width = 2802
integer height = 960
integer taborder = 20
string dataobject = "dw_lista_depreciacion_activo"
boolean livescroll = false
borderstyle borderstyle = styleraised!
end type

event ue_display(string as_columna, long al_row);//as columna, al_row

boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_string, ls_evaluate
			
ls_string = this.Describe(lower(as_columna) + '.Protect' )

IF len(ls_string) > 1 THEN
	ls_string = Mid(ls_string, Pos(ls_string, '~t') + 1)
	ls_string = Mid(ls_string,1, len(ls_string) - 1 )
	ls_evaluate = "Evaluate('" + ls_string + "', " + string(al_row) + ")"
	IF This.Describe(ls_evaluate) = '1' THEN RETURN
ELSE
	IF ls_string = '1' THEN RETURN
END IF

CHOOSE CASE lower(as_columna)
					
	CASE "calculo_tipo"
		ls_sql = "select calculo_tipo as codigo, " &
				  +"descripcion as nombre " &
				  +"from af_calculo_tipo "
				  
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		IF ls_codigo <> '' THEN
			This.object.calculo_tipo[al_row] = ls_codigo
			This.ii_update = 1
		END IF
		
			
END CHOOSE

end event

event constructor;call super::constructor;ii_ck[1] = 1
ii_ck[2] = 2
ii_ck[3] = 3

is_dwform = 'tabular'	 // tabular, form (default)

end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!


end event

event rowfocuschanged;call super::rowfocuschanged;This.SelectRow(0, False)
This.SelectRow(currentrow, True)
end event

event ue_insert_pre;call super::ue_insert_pre;string   ls_nro_activo
Long     ll_reg, ln_item

IF dw_master.getrow( ) = 0 THEN RETURN


// Numeración automática de items
ln_item = 0 
FOR ll_reg = 1 to This.RowCount()
	 IF ln_item < This.object.sec[ll_reg] THEN 
	    ln_item = This.object.sec[ll_reg]
	END IF 
NEXT
ln_item = ln_item + 1 

This.object.cod_usr [al_row] = gs_user
This.object.sec	  [al_row] = ln_item

//ll_row = dw_master.GetRow()
//ls_nro_activo = dw_master.GetitemString(ll_Row,"cod_activo")

//this.setitem(al_row,"cod_activo",ls_nro_activo)


end event

event itemchanged;call super::itemchanged;String ls_data, ls_null
decimal {2} ldc_valor_origen, ldc_porc_anual_depre
decimal {2} ldc_monto_anual, ldc_monto_mensual
integer li_nro_year, li_verifica

SetNull(ls_null)
This.Accepttext()

IF row <= 0 THEN RETURN

CHOOSE CASE dwo.name
	
	CASE 'calculo_tipo'
		SELECT count(*)
		  INTO :li_verifica
		FROM  af_calculo_tipo
		WHERE calculo_tipo = :data ;
		
	   IF li_verifica = 0 THEN
			Messagebox("Aviso",'OPERACION NO EXISTE O NO ESTA ACTIVO, POR FAVOR VERIFIQUE', StopSign!)
			This.Object.calculo_tipo [row] = ls_null
		   RETURN 1
		END IF
	  	
	CASE 'valor_origen'
		  ldc_valor_origen     = This.object.valor_origen    [row]	
		  ldc_porc_anual_depre = This.object.porc_anual_depre[row]	

		  IF isnull(ldc_valor_origen) or ldc_valor_origen = 0.00 THEN
			  Messagebox("Aviso","Ingrese el valor del activo a depreciar")
			  RETURN 1
			END IF

		  ldc_monto_anual   = ldc_valor_origen * (ldc_porc_anual_depre / 100)
		  ldc_monto_mensual = ldc_monto_anual / 12
		  li_nro_year       = 100 / ldc_porc_anual_depre
		  
		  This.object.monto_anual_depre[row] = ldc_monto_anual
	     This.object.monto_men_depre	 [row] = ldc_monto_mensual
	     This.object.nro_anos			 [row] = li_nro_year
		  
	 
	CASE 'porc_anual_depre'

		  ldc_valor_origen     = This.object.valor_origen		[row]	
		  ldc_porc_anual_depre = This.object.porc_anual_depre [row]	
		  
		  IF isnull(ldc_porc_anual_depre) or ldc_porc_anual_depre = 0.00 THEN
			  Messagebox("Aviso","Ingrese el porcentaje de depreciación")
			  RETURN 1
			END IF

		  ldc_monto_anual   = ldc_valor_origen * (ldc_porc_anual_depre / 100)
		  ldc_monto_mensual = ldc_monto_anual / 12
		  li_nro_year       = 100 / ldc_porc_anual_depre
		  
		  This.object.monto_anual_depre[row] = ldc_monto_anual
	     This.object.monto_men_depre	 [row] = ldc_monto_mensual
	     This.object.nro_anos			 [row] = li_nro_year
		
END CHOOSE


end event

event doubleclicked;call super::doubleclicked;string ls_columna
long ll_row 


THIS.AcceptText()
IF This.Describe(dwo.Name + ".Protect") = '1' THEN RETURN
ll_row = row

IF row > 0 THEN
	ls_columna = upper(dwo.name)
	This.event dynamic ue_display(ls_columna, ll_row)
END IF


end event

event itemerror;call super::itemerror;RETURN 1
end event

type tabpage_3 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 2848
integer height = 1236
long backcolor = 79741120
string text = "Incidencias"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "ToDoList!"
long picturemaskcolor = 536870912
dw_3 dw_3
end type

on tabpage_3.create
this.dw_3=create dw_3
this.Control[]={this.dw_3}
end on

on tabpage_3.destroy
destroy(this.dw_3)
end on

type dw_3 from u_dw_abc within tabpage_3
event ue_display ( string as_columna,  long al_row )
integer width = 2784
integer height = 948
integer taborder = 20
string dataobject = "dw_incidencias_activo_tbl"
boolean livescroll = false
borderstyle borderstyle = styleraised!
end type

event ue_display(string as_columna, long al_row);boolean 	lb_ret
string 	ls_codigo, ls_data, ls_string, ls_evaluate, ls_sql
			
ls_string = this.Describe(lower(as_columna) + '.Protect' )

IF len(ls_string) > 1 THEN
	ls_string = Mid(ls_string, Pos(ls_string, '~t') + 1)
	ls_string = Mid(ls_string,1, len(ls_string) - 1 )
	ls_evaluate = "Evaluate('" + ls_string + "', " + string(al_row) + ")"
	IF This.Describe(ls_evaluate) = '1' THEN RETURN
ELSE
	IF ls_string = '1' THEN RETURN
END IF

CHOOSE CASE lower(as_columna)
	CASE 'incidencia_tipo'
		ls_sql = "select incidencia_tipo as codigo, " &
				  +"descripcion as nombre " &
				  +"from af_incidencia_tipo "
				  
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		IF ls_codigo <> '' THEN
			This.object.incidencia_tipo[al_row] = ls_codigo
			This.ii_update = 1
		END IF
				
	CASE 'causa_falla'
		ls_sql = "select causa_falla as codigo, " &
				  +"desc_causa as descripcion " &
				  +"from causa_fallas "
				  
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		IF ls_codigo <> '' THEN
			This.object.causa_falla[al_row] = ls_codigo
			This.object.desc_causa [al_row]  = ls_data
			This.ii_update = 1
		END IF
		
END CHOOSE


end event

event constructor;call super::constructor;ii_ck[1] = 1
ii_ck[2] = 2

is_dwform = 'tabular'

end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!


end event

event rowfocuschanged;call super::rowfocuschanged;This.SelectRow(0, False)
This.SelectRow(currentrow, True)
end event

event ue_insert_pre;call super::ue_insert_pre;IF dw_master.getrow( ) = 0 THEN RETURN

This.object.cod_usr	[al_row] = gs_user
This.object.fecha		[al_row] = f_fecha_actual()
end event

event doubleclicked;call super::doubleclicked;string ls_columna
long ll_row 

THIS.AcceptText()
IF This.Describe(dwo.Name + ".Protect") = '1' THEN RETURN
ll_row = row

IF row > 0 THEN
	ls_columna = upper(dwo.name)
	This.event dynamic ue_display(ls_columna, ll_row)
END IF


end event

event itemchanged;call super::itemchanged;String ls_data, ls_null

SetNull(ls_null)
This.Accepttext()

IF row <= 0 THEN RETURN

CHOOSE CASE dwo.name
	CASE 'causa_falla'
		SELECT desc_causa
		  INTO :ls_data
		FROM causa_fallas
		WHERE causa_falla = :data ;
			
		IF SQLCA.sqlcode = 100 THEN
			MessageBox('Aviso', 'CAUSA/FALLA NO EXISTE O NO ESTA ACTIVO, POR FAVOR VERIFIQUE', StopSign!)
			This.object.causa_falla	[row] = ls_null
			This.object.desc_causa	[row]	= ls_null
			RETURN 1
		END IF
		
		This.object.desc_causa[row] = ls_data
	
	CASE 'incidencia_tipo'
		SELECT descripcion
       INTO :ls_data
	 	FROM af_incidencia_tipo
	   WHERE incidencia_tipo = :data ;
	
		IF SQLCA.sqlcode = 100 THEN
			MessageBox('Aviso', 'INCIDENCIA NO EXISTE O NO ESTA ACTIVO, POR FAVOR VERIFIQUE', StopSign!)
			This.object.incidencia_tipo[row] = ls_null
			RETURN 1
		END IF
			
END CHOOSE


end event

event buttonclicked;call super::buttonclicked;string ls_observacion

ls_observacion = this.object.obs[row]

openwithparm(w_af_observacion,ls_observacion)

if not isnull(Message.StringParm) then
	
	this.object.obs[row] = trim(Message.StringParm)
	this.ii_update = 1
	
end if
end event

event itemerror;call super::itemerror;RETURN 1
end event

type tabpage_4 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 2848
integer height = 1236
long backcolor = 79741120
string text = "Adaptaciones"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "Custom044!"
long picturemaskcolor = 536870912
dw_4 dw_4
end type

on tabpage_4.create
this.dw_4=create dw_4
this.Control[]={this.dw_4}
end on

on tabpage_4.destroy
destroy(this.dw_4)
end on

type dw_4 from u_dw_abc within tabpage_4
event ue_display ( string as_columna,  long al_row )
integer width = 2729
integer height = 956
string dataobject = "dw_adaptaciones_tbl"
boolean livescroll = false
borderstyle borderstyle = styleraised!
end type

event ue_display(string as_columna, long al_row);boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_string, ls_evaluate
			

ls_string = this.Describe(lower(as_columna) + '.Protect' )

IF len(ls_string) > 1 THEN
	ls_string = Mid(ls_string, Pos(ls_string, '~t') + 1)
	ls_string = Mid(ls_string,1, len(ls_string) - 1 )
	ls_evaluate = "Evaluate('" + ls_string + "', " + string(al_row) + ")"
	IF This.Describe(ls_evaluate) = '1' THEN RETURN
ELSE
	IF ls_string = '1' THEN RETURN
END IF

CHOOSE CASE lower(as_columna)
	CASE "activo_asociado"
		ls_sql = "select cod_activo as codigo, "&
				  +"descripcion as nombre " &
				  +"from af_maestro " &
				  +"where flag_estado = '1' "
				  
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		IF ls_codigo <> '' THEN
			This.object.activo_asociado[al_row] = ls_codigo
			This.object.descripcion		[al_row] = ls_data
			This.ii_update = 1
		END IF
		
END CHOOSE

end event

event constructor;call super::constructor;ii_ck[1] = 1
ii_ck[2] = 2

is_dwform = 'tabular'
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

end event

event rowfocuschanged;call super::rowfocuschanged;This.SelectRow(0, False)
This.SelectRow(currentrow, True)
end event

event ue_insert_pre;call super::ue_insert_pre;IF dw_master.getrow( ) = 0 THEN RETURN

This.object.fecha [al_row] = f_fecha_actual()
end event

event doubleclicked;call super::doubleclicked;string ls_columna
long ll_row 

THIS.AcceptText()
IF This.Describe(dwo.Name + ".Protect") = '1' THEN RETURN
ll_row = row

IF row > 0 THEN
	ls_columna = upper(dwo.name)
	This.event dynamic ue_display(ls_columna, ll_row)
END IF


end event

event itemchanged;call super::itemchanged;String ls_data, ls_null

SetNull(ls_null)
This.Accepttext()

IF row <= 0 THEN RETURN

CHOOSE CASE dwo.name
	 CASE 'activo_asociado'
	 		SELECT descripcion
		     INTO :ls_data
			FROM af_maestro
			WHERE cod_activo = :data
			  AND flag_estado = '1';
			  
		   IF SQLCA.sqlcode = 100 THEN
				MessageBox('Aviso', 'ACTIVO NO EXISTE O NO ESTA ACTIVO, POR FAVOR VERIFIQUE', StopSign!)
				this.object.activo_asociado[row] = ls_null
				this.object.descripcion		[row]	= ls_null
				return 1
			END IF
			
			This.object.descripcion[row] = ls_data

END CHOOSE


end event

event buttonclicked;call super::buttonclicked;string ls_observacion

ls_observacion = this.object.obs[row]

openwithparm(w_af_observacion,ls_observacion)

if not isnull(Message.StringParm) then
	
	this.object.obs[row] = trim(Message.StringParm)
	this.ii_update = 1
	
end if
end event

type tabpage_5 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 2848
integer height = 1236
long backcolor = 79741120
string text = "Traslados"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "Run!"
long picturemaskcolor = 536870912
dw_5 dw_5
end type

on tabpage_5.create
this.dw_5=create dw_5
this.Control[]={this.dw_5}
end on

on tabpage_5.destroy
destroy(this.dw_5)
end on

type dw_5 from u_dw_abc within tabpage_5
integer width = 2793
integer height = 984
integer taborder = 20
string dataobject = "dw_traslados_tbl"
boolean livescroll = false
borderstyle borderstyle = styleraised!
end type

event constructor;call super::constructor;ii_ck[1] = 1
ii_ck[2] = 2

is_dwform = 'tabular'
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

end event

event rowfocuschanged;call super::rowfocuschanged;This.SelectRow(0, False)
This.SelectRow(currentrow, True)
end event

type tabpage_6 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 2848
integer height = 1236
long backcolor = 79741120
string text = "Asignaciones"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "StaticText!"
long picturemaskcolor = 536870912
dw_6 dw_6
end type

on tabpage_6.create
this.dw_6=create dw_6
this.Control[]={this.dw_6}
end on

on tabpage_6.destroy
destroy(this.dw_6)
end on

type dw_6 from u_dw_abc within tabpage_6
integer width = 2761
integer height = 984
integer taborder = 30
string dataobject = "dw_lista_asignaciones_tbl"
boolean livescroll = false
borderstyle borderstyle = styleraised!
end type

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

end event

event constructor;call super::constructor;ii_ck[1] = 1

is_dwform = 'tabular'
end event

event rowfocuschanged;call super::rowfocuschanged;This.SelectRow(0, False)
This.SelectRow(currentrow, True)
end event

type dw_master from u_dw_abc within w_af300_maestro
event ue_display ( string as_columna,  long al_row )
integer width = 3387
integer height = 1084
string dataobject = "dw_maestro_cabecera_ff"
boolean hscrollbar = false
boolean vscrollbar = false
end type

event ue_display;boolean 	lb_ret
string 	ls_docname, ls_named, ls_string, ls_evaluate, &
			ls_codigo, ls_data, ls_sql, ls_clase
integer	li_file
Decimal	ldc_tasa_cont, ldc_tasa_trib
			

CHOOSE CASE lower(as_columna)
	CASE 'imagen'
		li_file = GetFileOpenName("Seleccione Fotografía", ls_docname, ls_named, "BMP", "Archivos BMP (*.BMP),*.BMP,Archivos JPG (*.JPG),*.JPG, Archivos BMP (*.GIF),*.GIF")
		IF li_file = 1 THEN
			this.object.imagen[al_row] = ls_docname
			this.ii_update = 1
		END IF
	
	CASE 'cencos'
		ls_sql = "select cencos as codigo, " &
				  +"desc_cencos as descripcion " &
				  +"from centros_costo " &
				  +"where flag_estado = '1' "
				  
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		IF ls_codigo <> '' THEN
			This.object.cencos		[al_row] = ls_codigo
			This.object.desc_cencos	[al_row] = ls_data
			This.ii_update = 1
		END IF
	
	CASE 'cod_marca'
		ls_sql = "select cod_marca as codigo, " &
				  +"nom_marca as descripcion " &
				  +"from marca " &
				  +"where flag_estado = '1' "
		
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		IF ls_codigo <> '' THEN
			This.object.cod_marca[al_row] = ls_codigo
			This.object.nom_marca[al_row] = ls_data
			This.ii_update = 1
		END IF
		
	CASE 'cod_clase'
		ls_sql = "select cod_clase as codigo_Clase, " &
				 + "desc_clase as descripcion_clase " &
				 + "from af_Clase " &
				 + "where flag_estado = '1'"
		
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		IF ls_codigo <> '' THEN
			This.object.cod_clase	[al_row] = ls_codigo
			This.object.desc_clase	[al_row] = ls_data
			This.ii_update = 1
		END IF
		
	CASE 'cod_sub_clase'
		ls_clase = dw_master.object.cod_clase[al_row]	
		
		if IsNull(ls_clase) or trim(ls_clase) = '' then
			MEssageBox('Error', "No ha especificado codigo de clase. Por favor verifique!", StopSign!)
			this.SetColumn('cod_clase')
			return
		end if
		
		ls_sql = "select cod_sub_clase as codigo_sub_clase, " &
				 + "desc_sub_clase as descripcion_sub_clase " &
				 + "from af_sub_clase " &
				 + "where flag_estado = '1' " &
				 + "  and cod_clase = '" + ls_clase + "'"
		
		IF gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, '2') THEN
			This.object.cod_sub_clase 	[al_row] = ls_codigo
			This.object.desc_sub_clase	[al_row] = ls_data
			
			This.ii_update = 1
			
			SELECT tasa_dep_cont, tasa_dep_trib
			  INTO :ldc_tasa_cont, :ldc_tasa_trib
			FROM  af_cuenta_cntbl
			WHERE  calculo_tipo = :is_oper_depre
			  AND  cod_sub_clase= :ls_codigo;
		
			if sqlca.SQlCode = 100 then
				MEssageBox('Error', 'No ha especificado parametros para la operacion ' &
										+ is_oper_depre + ' de la subclase ' + ls_codigo &
										+ ". Por favor verifique!", StopSign!)
										
				This.object.tasa_dep 		[al_row] = gnvo_app.idc_null
				This.object.tasa_dep_trib 	[al_row] = gnvo_app.idc_null
	
				return
			end if
			
			This.object.tasa_dep 		[al_row] = ldc_tasa_cont
			This.object.tasa_dep_trib 	[al_row] = ldc_tasa_trib
		
		END IF
		
		
		
	CASE 'cod_maquina'
		ls_sql = "select cod_maquina as codigo, " &
		        +"desc_maq as descripcion " &
				  +"from maquina " &
				  +"where flag_estado = '1' "
				  
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		IF ls_codigo <> '' THEN
			This.object.cod_maquina	[al_row]  = ls_codigo
			This.object.desc_maq		[al_row]  = ls_data
			This.ii_update = 1
		END IF
		
END CHOOSE

end event

event doubleclicked;call super::doubleclicked;string ls_columna, ls_string, ls_evaluate

THIS.AcceptText()

ls_string = this.Describe(lower(dwo.name) + '.Protect' )
if len(ls_string) > 1 then
 	ls_string = Mid(ls_string, Pos(ls_string, '~t') + 1)
 	ls_string = Mid(ls_string,1, len(ls_string) - 1 )
 	ls_evaluate = "Evaluate('" + ls_string + "', " + string(row) + ")"
 
 	if this.Describe(ls_evaluate) = '1' then return
else
 	if ls_string = '1' then return
end if

IF row > 0 THEN
	ls_columna = upper(dwo.name)
	THIS.event dynamic ue_display(ls_columna, row)
END IF
end event

event constructor;call super::constructor;ii_ck[1] = 2
//ii_dk[1] = 1

is_dwform = 'form'


end event

event ue_insert_pre;call super::ue_insert_pre;is_action = 'new'


This.object.cod_usr 				[al_row] = gs_user
This.object.flag_estado 		[al_row] = '1'
This.object.flag_adaptacion	[al_row] = '0'
This.object.cod_origen			[al_row] = gs_origen
This.object.flag_procedencia 	[al_row] = 'N'
This.object.flag_operatividad [al_row] = 'O'
This.object.flag_condicion 	[al_row] = 'B'
This.object.flag_depreciacion [al_row] = '1'


end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

end event

event itemchanged;call super::itemchanged;String 	ls_data, ls_clase
Decimal 	ldc_tasa_cont, ldc_tasa_trib

SetNull(gnvo_app.is_null)
This.Accepttext()

IF row <= 0 THEN RETURN

CHOOSE CASE dwo.name
	 CASE 'cencos'
			SELECT desc_cencos	
			 INTO :ls_data
			FROM centros_costo	
			WHERE cencos = :data
			  AND flag_estado = '1';
			
			IF SQLCA.sqlcode = 100 THEN
				MessageBox('Aviso', 'EL CENCOS NO EXISTE O NO ESTA ACTIVO, POR FAVOR VERIFIQUE', StopSign!)
				This.object.cencos		[row] = gnvo_app.is_null
				This.object.desc_cencos	[row]	= gnvo_app.is_null
				RETURN 1
			END IF
			
			This.object.desc_cencos[row]	= ls_data

	CASE 'cod_marca'
		  	SELECT nom_marca
		     INTO :ls_data
			FROM marca
			WHERE cod_marca = :data 
			  AND flag_estado = '1';
						
			IF SQLCA.sqlcode = 100 THEN
				MessageBox('Aviso', 'LA MARCA NO EXISTE O NO ESTA ACTIVO, POR FAVOR VERIFIQUE', StopSign!)
				This.object.cod_marca	[row] = gnvo_app.is_null
				This.object.nom_marca	[row]	= gnvo_app.is_null
				RETURN 1
			END IF
			
		   This.object.nom_marca[row] = ls_data
		  
	CASE 'cod_clase'
	  		SELECT desc_clase
	 	     INTO :ls_data
			FROM af_clase
			WHERE cod_clase = :data 
			  AND flag_estado = '1';
			
			IF SQLCA.sqlcode = 100 THEN
				MessageBox('Aviso', 'LA CLASE INGRESADA NO EXISTE O NO ESTA ACTIVA, POR FAVOR VERIFIQUE', StopSign!)
				This.object.cod_clase		[row] = gnvo_app.is_null
				This.object.desc_clase		[row]	= gnvo_app.is_null
				RETURN 1
			END IF
			
		   This.object.desc_clase[row] = ls_data
		  
	CASE 'cod_sub_clase'
		
			ls_clase = dw_master.object.cod_clase[row]	
			
			if ISNull(ls_clase) or trim(ls_clase) = '' then
				MessageBox('Aviso', 'No ha especificado ninguna clase, por favor verifique!', StopSign!)
				this.SetColumn('cod_clase')
				return
			end if
			
	  		SELECT desc_sub_clase
	 	     INTO :ls_data
			FROM af_sub_clase
			WHERE cod_clase 		= :ls_clase 
			  AND cod_sub_clase 	= :data 
			  and flag_estado		= '1';
			
			IF SQLCA.sqlcode = 100 THEN
				MessageBox('Aviso', 'LA SUB_CLASE NO EXISTE O NO ESTA ACTIVO, POR FAVOR VERIFIQUE', StopSign!)
				This.object.cod_sub_clase	[row] = gnvo_app.is_null
				This.object.desc_clase		[row]	= gnvo_app.is_null
				This.object.tasa_dep 		[row] = gnvo_app.idc_null
				This.object.tasa_dep_trib 	[row] = gnvo_app.idc_null
				RETURN 1
			END IF
			
			
			SELECT tasa_dep_cont, tasa_dep_trib
			  INTO :ldc_tasa_cont, :ldc_tasa_trib
			FROM  af_cuenta_cntbl
			WHERE  calculo_tipo = :is_oper_depre
			  AND  cod_sub_clase= :data;
			
			IF SQLCA.sqlcode = 100 THEN
				MEssageBox('Error', 'No ha especificado parametros para la operacion ' &
									+ is_oper_depre + ' de la subclase ' + data &
									+ ". Por favor verifique!", StopSign!)
				This.object.tasa_dep 		[row] = gnvo_app.idc_null
				This.object.tasa_dep_trib 	[row] = gnvo_app.idc_null
				RETURN 1
			END IF

		   This.object.desc_clase		[row] = ls_data
			This.object.tasa_dep 		[row] = ldc_tasa_cont
			This.object.tasa_dep_trib 	[row] = ldc_tasa_trib

	CASE 'cod_maquina'
	  		SELECT desc_maq
	 	     INTO :ls_data
			FROM maquina
			WHERE cod_maquina = :data
			 AND flag_estado = '1';
		   
			IF SQLCA.sqlcode = 100 THEN
				MessageBox('Aviso', 'LA MAQUINA NO EXISTE O NO ESTA ACTIVO, POR FAVOR VERIFIQUE', StopSign!)
				This.object.cod_maquina	[row] = gnvo_app.is_null
				This.object.desc_maq		[row]	= gnvo_app.is_null
				RETURN 1
			END IF
			
		  This.object.desc_maq[row] = ls_data
			
END CHOOSE

end event

event itemerror;call super::itemerror;RETURN 1
end event

