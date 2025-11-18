$PBExportHeader$w_fi307_genera_solicitud_giro.srw
forward
global type w_fi307_genera_solicitud_giro from w_abc
end type
type dw_psg from datawindow within w_fi307_genera_solicitud_giro
end type
type dw_master from u_dw_abc within w_fi307_genera_solicitud_giro
end type
end forward

global type w_fi307_genera_solicitud_giro from w_abc
integer width = 2103
integer height = 1256
string title = "Solicitud de Giro  (FI307)"
string menuname = "m_mantenimiento_cl_anular"
event ue_anular ( )
event ue_find_exact ( )
dw_psg dw_psg
dw_master dw_master
end type
global w_fi307_genera_solicitud_giro w_fi307_genera_solicitud_giro

type variables

end variables

forward prototypes
public function boolean of_verifica_max_og ()
public function integer of_set_numera ()
end prototypes

event ue_anular;String ls_flag_estado
Long   ll_row

ll_row = dw_master.Getrow()
IF ll_row = 0 THEN RETURN
ls_flag_estado = dw_master.object.flag_estado [ll_row]

IF ls_flag_estado <> '1' THEN RETURN

dw_master.object.flag_estado [ll_row] = '0'
dw_master.object.importe_doc [ll_row] = 0.00
dw_master.object.saldo_sol   [ll_row] = 0.00
dw_master.object.saldo_dol   [ll_row] = 0.00

dw_master.ii_update = 1
is_Action = 'DELETE'
TriggerEvent('ue_modify')
end event

event ue_find_exact();// Asigna valores a structura 
str_parametros sl_param
	
TriggerEvent('ue_update_request')

IF ib_update_check = FALSE THEN RETURN //FALLO ACTUALIZACION

	
sl_param.dw1    = 'd_ext_letras_x_cobrar_tbl'
sl_param.dw_m   = dw_master
sl_param.opcion = 3 //SOLICITUD GIRO
OpenWithParm( w_help_datos, sl_param)

sl_param = Message.PowerObjectParm
IF sl_param.titulo <> 'n' THEN		
	TriggerEvent('ue_modify')
	dw_master.ii_update = 0
ELSE
	dw_master.Reset()
END IF
















end event

public function boolean of_verifica_max_og ();String  ls_cod_relacion 
Long    ll_count

ls_cod_relacion = dw_master.Object.cod_relacion [1]

SELECT Count(*)
  INTO :ll_count
  FROM maestro_param_autoriz 
 WHERE nro_solicitudes_pend >= nro_maximo_sol_pend
	  and cod_relacion			  = :ls_cod_relacion	  ;	
		 
IF ll_count > 0 THEN 
	Messagebox('Aviso','No se puede Generar mas Solicitud de Adelanto', StopSign!)
	return false
END IF	

Return true
end function

public function integer of_set_numera (); 
//Numera documento
Long 		ll_ult_nro, ll_count
string		ls_mensaje, ls_nro

if is_action = 'new' then

	Select count(*)
		into :ll_count
	from num_solicitud_giro 
	where origen = :gs_origen;

	IF ll_count = 0 then
		Insert into num_solicitud_giro (origen, ult_nro)
			values( :gs_origen, 1);
		
		IF SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Error', 'Error al insertar registro en num_solicitud_giro: ' + ls_mensaje, StopSign!)
			return 0
		end if
	end if

	Select ult_nro 
		into :ll_ult_nro 
	from num_solicitud_giro 
	where origen = :gs_origen for update;

	IF SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Error', 'Error al consultar tabla en num_solicitud_giro: ' + ls_mensaje, StopSign!)
		return 0
	end if

	//Asigna numero a cabecera
	ls_nro = TRIM( gs_origen) + trim(string(ll_ult_nro, '00000000'))
	
	if IsNull(ls_nro) or ls_nro = '' then
		MessageBox('Error', 'Ha ocurrido un error al generar el numero de la Orden de giro', StopSign!)
		return 0
	end if
	
	//Verifico que este numero no exista
	select count(*)
		into :ll_count
	from solicitud_giro
	where nro_solicitud = :ls_nro;
	
	if ll_count > 0 then
		MessageBox('Error', 'El numero de solicitud ' + ls_nro + ' ya ha sido registrado por favor verifique. ', StopSign!)
		return 0
	end if
	
	dw_master.object.nro_solicitud[dw_master.getrow()] = ls_nro
	
	//Incrementa contador
	Update num_solicitud_giro 
		set ult_nro = :ll_ult_nro + 1 
	 where origen = :gs_origen;
	
	IF SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Error', 'Error al actualizar num_solicitud_giro: ' + ls_mensaje, StopSign!)
		return 0
	end if
		
else 
	ls_nro = dw_master.object.nro_solicitud[dw_master.getrow()] 
end if

return 1

end function

on w_fi307_genera_solicitud_giro.create
int iCurrent
call super::create
if this.MenuName = "m_mantenimiento_cl_anular" then this.MenuID = create m_mantenimiento_cl_anular
this.dw_psg=create dw_psg
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_psg
this.Control[iCurrent+2]=this.dw_master
end on

on w_fi307_genera_solicitud_giro.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_psg)
destroy(this.dw_master)
end on

event ue_open_pre;call super::ue_open_pre;String  ls_doc_sg,ls_origen,ls_nro_solicitud
Long    ll_nro_solicitud


dw_master.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos

idw_1 = dw_master              				// asignar dw corriente

of_position_window(0,0)       			// Posicionar la ventana en forma fija
//ii_help = 101           					// help topic




//finparam
SELECT doc_sol_giro
  INTO :ls_doc_sg
  FROM finparam
 WHERE (reckey = '1');
 
IF Isnull(ls_doc_sg) OR Trim(ls_doc_sg) = '' THEN
	Messagebox('Aviso','Debe Ingresar Tipo de Documento Solicitud Giro en Archivo de Parametros FINPARAM')
END IF


//NUMERADOR
SELECT ult_nro
 INTO :ll_nro_solicitud
 FROM num_solicitud_giro
WHERE (origen = :gs_origen );
 
 
IF Isnull(ll_nro_solicitud) OR ll_nro_solicitud = 0 THEN
   Messagebox('Aviso','Numerador de Solicitud de Giro se Encuentra Vacio Verifique! ')
END IF
 
 


/********************************/
/*Recuperacion de Solicitud Giro*/
/********************************/
SELECT sg.origen			,
		 sg.nro_solicitud	
  INTO :ls_origen ,
  		 :ls_nro_solicitud
  FROM solicitud_giro sg
 WHERE (rowid IN (SELECT MAX(rowid) FROM solicitud_giro )) ;
 
IF Not (Isnull(ls_origen) OR Trim(ls_origen) = '') THEN
	dw_master.retrieve(ls_origen,ls_nro_solicitud)
	dw_master.ii_update = 0
	is_Action = 'fileopen'
	TriggerEvent('ue_modify')
ELSE
	TriggerEvent('ue_insert')
END IF
 
end event

event ue_insert;//Override
Long  ll_row

TriggerEvent ('ue_update_request')

idw_1.Reset()

ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)

idw_1.SetColumn('cod_relacion')


end event

event ue_update_pre;call super::ue_update_pre;String  	ls_moneda
Long    	ll_nro_solicitud
Decimal 	ldc_tasa_cambio, ldc_importe_doc, ldc_saldo_sol, ldc_saldo_dol
Date		ldt_fecha_emision

/*Replicacion*/
dw_master.of_set_flag_replicacion ()

IF is_Action = 'DELETE' THEN RETURN

ib_update_check = False	

/*DATOS DE CABECERA */
IF dw_master.Rowcount() = 0 THEN
	Messagebox('Aviso','Debe Ingresar Registro en la Cabecera', StopSign!)
	Return
END IF

//--VERIFICACION Y ASIGNACION 
IF gnvo_app.of_row_Processing( dw_master ) <> true then	
	return
END IF


IF is_action = 'new' THEN
	IF of_verifica_max_og() = FALSE THEN Return
	
	IF of_set_numera() = 0 THEN RETURN
	
	dw_master.object.fecha_emision [1] = date(gnvo_app.of_fecha_actual())
END IF


/*ACTUALIZA SALDO SOLES,DOLARES*/
ls_moneda		   	= dw_master.object.cod_moneda   	 		[1]
ldc_importe_doc   	= dw_master.object.importe_doc   			[1]
ldt_fecha_emision 	= Date(dw_master.object.fecha_emision 	[1])
ldc_tasa_cambio 	= gnvo_app.of_tasa_cambio(ldt_fecha_emision)

IF Isnull(ldc_tasa_cambio) OR ldc_tasa_cambio = 0.000 THEN
	Messagebox('Aviso','Debe Verificar Tasa de Cambio del Dia', StopSign!)
	RETURN	
END IF

IF ls_moneda = gnvo_app.is_soles THEN
	ldc_saldo_sol   = ldc_importe_doc
	ldc_saldo_dol   = Round(ldc_importe_doc / ldc_tasa_cambio ,2)
ELSEIF ls_moneda = gnvo_app.is_dolares THEN
	ldc_saldo_sol   = Round(ldc_importe_doc * ldc_tasa_cambio,2)
	ldc_saldo_dol   = ldc_importe_doc 
END IF

dw_master.object.saldo_sol [1] = ldc_saldo_sol
dw_master.object.saldo_dol [1] = ldc_saldo_dol


ib_update_check = True
end event

event ue_update;call super::ue_update;Boolean lbo_ok = TRUE
String	ls_msg, ls_crlf

ls_crlf = char(13) + char(10)
dw_master.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF ib_log THEN
	dw_master.of_create_log()
END IF

IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_master.Update(true, false) = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion Master", ls_msg, StopSign!)
	END IF
END IF

IF ib_log THEN
	IF lbo_ok THEN
		lbo_ok = dw_master.of_save_log()
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0
	
	dw_master.il_totdel = 0
	
	dw_master.ResetUpdate()
	
	dw_master.ii_protect = 0
	dw_master.of_protect( )
	
	is_action = 'open'
	
	f_mensaje('Grabación realizada satisfactoriamente', '')
	
	//this.event ue_retrieve()
	
END IF



//Boolean  lbo_ok = TRUE
//String	ls_msg
//
//dw_master.AcceptText()
//
//THIS.EVENT ue_update_pre()
//IF ib_update_check = FALSE THEN RETURN
//
//IF ib_log THEN
//	u_ds_base		lds_log
//	lds_log = Create u_ds_base
//	lds_log.DataObject = 'd_log_diario_tbl'
//	lds_log.SetTransObject(SQLCA)
//	
//	IF ISNull(in_log) THEN											
//		in_log = Create n_cst_log_diario
//		in_log.of_dw_map(idw_1, is_colname, is_coltype)
//	END IF
//	
//	in_log.of_create_log(dw_master, lds_log, is_colname, is_coltype, gs_user, is_tabla)
//END IF
//
////Open(w_log)
////lds_log.RowsCopy(1, lds_log.RowCount(),Primary!,w_log.dw_log,1,Primary!)
//
//IF	dw_master.ii_update = 1 THEN
//	IF dw_master.Update(true, false) = -1 then		// Grabacion del Master
//		lbo_ok = FALSE
//		ROLLBACK USING SQLCA;
//		MessageBox('Error en Base de Datos', 'No se pudo grabar Maestro')
//	END IF
//END IF
//
//IF ib_log THEN
//	IF lbo_ok THEN
//		IF lds_log.Update(true, false) = -1 THEN
//			lbo_ok = FALSE
//			ROLLBACK USING SQLCA;
//			MessageBox('Error en Base de Datos', 'No se pudo grabar el Log Diario')
//		END IF
//	END IF
//	DESTROY lds_log
//END IF
//
//IF lbo_ok THEN
//	COMMIT using SQLCA;
//	dw_master.ii_update = 0
//	dw_master.il_totdel = 0
//	
//	dw_master.ResetUpdate( )
//END IF
//
end event

event ue_update_request();call super::ue_update_request;Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
IF (dw_master.ii_update = 1) THEN
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	IF li_msg_result = 1 THEN
 		this.TriggerEvent("ue_update")
	ELSE
		dw_master.ii_update = 0
		
	END IF
END IF

end event

event ue_modify();call super::ue_modify;Long   ll_row

String ls_flag_estado

ll_row = dw_master.Getrow()

IF ll_row = 0 THEN RETURN
ls_flag_estado = dw_master.object.flag_estado [ll_row]

IF ls_flag_estado = '1' THEN
	dw_master.of_protect()
ELSE
	dw_master.ii_protect = 0
	dw_master.of_protect()
END IF

end event

event ue_retrieve_list;


//override
// Asigna valores a structura 
Long ll_row
str_parametros sl_param

TriggerEvent ('ue_update_request')		

sl_param.dw1    = 'd_abc_solicitud_giro_tbl'
sl_param.titulo = 'Solicitud Giro'
sl_param.field_ret_i[1] = 1  //origen
sl_param.field_ret_i[2] = 2  //nro solicitud



OpenWithParm( w_lista, sl_param)

sl_param = Message.PowerObjectParm
IF sl_param.titulo <> 'n' THEN		
	dw_master.retrieve(sl_param.field_ret[1],sl_param.field_ret[2])
	dw_master.ii_update = 0
	is_action = 'fileopen'
	TriggerEvent('ue_modify')
	
END IF

end event

event ue_delete();//override 
Return
end event

event ue_print;Long   ll_row
String ls_nro_sol,ls_flag_estado,ls_origen

ll_row = dw_master.getrow()

IF ll_row = 0 THEN RETURN
ls_nro_sol = dw_master.object.nro_solicitud [ll_row]
ls_origen  = dw_master.object.origen		  [ll_row]
ls_flag_estado = dw_master.object.flag_estado [ll_row]


IF dw_master.ii_update = 1 THEN
	Messagebox('Aviso','Grabe los cambios Efectuados pra Proceder a Imprimir , Verifique!')
	Return
END IF

IF ls_flag_estado = '0' THEN
	Messagebox('Aviso','Solicitud de Giro Ha Sido Anulado , No se Imprimira Verifique!')
	Return
ELSEIF ls_flag_estado = '1' THEN
	Messagebox('Aviso','Solicitud de Giro No Ha Sido Aprobada , No se Imprimira Verifique!')
	Return
END IF

//*Impresion de SOLICITUD DE GIRO*//
//IF f_imp_f_general () = FALSE THEN RETURN
dw_psg.Retrieve(ls_nro_sol,ls_origen)
dw_psg.object.t_nombre.text = gs_empresa

OpenWithParm(w_print_opt, dw_psg)
If Message.DoubleParm = -1 Then Return
dw_psg.Print(True)
//**//
end event

event key;call super::key;IF key = KeyF4! THEN
	TriggerEvent('ue_find_exact')
END IF
end event

type dw_psg from datawindow within w_fi307_genera_solicitud_giro
boolean visible = false
integer x = 2153
integer y = 312
integer width = 411
integer height = 432
integer taborder = 20
string dataobject = "d_rpt_solicitud_giro_ff"
boolean border = false
boolean livescroll = true
end type

event constructor;SettransObject(sqlca)
end event

type dw_master from u_dw_abc within w_fi307_genera_solicitud_giro
integer width = 2043
integer height = 1040
boolean bringtotop = true
string dataobject = "d_abc_solicitud_giro_ff"
boolean hscrollbar = false
boolean vscrollbar = false
end type

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event itemchanged;call super::itemchanged;Accepttext()
Long   ll_count
String ls_cod_relacion,ls_nombres,ls_codigo,ls_descripcion

CHOOSE CASE dwo.name
		 CASE 'cod_relacion'
			
			   SELECT codigo,
						 nombre
				  INTO :ls_cod_relacion,
				  		 :ls_nombres	
		        FROM vw_fin_person_autoriz_sol_giro
				 WHERE (codigo = :data ) ;
				 
				 
				 
				IF Isnull(ls_cod_relacion) OR Trim(ls_cod_relacion) = '' THEN
					Setnull(ls_cod_relacion)
					Setnull(ls_nombres)
					Messagebox('Aviso','Codigo de Relación No Existe')
					This.Object.cod_relacion [row] = ls_cod_relacion
					This.Object.nombre		 [row] = ls_nombres
					Return 1
				ELSE
					This.Object.nombre		 [row] = ls_nombres					
				END IF
		 CASE 'cencos'
				SELECT Count(*)
				  INTO :ll_count
				  FROM centros_costo
				 WHERE (cencos      = :data ) AND
				       (flag_estado = '1'   )  ;
				
				IF ll_count = 0 THEN
					Messagebox('Aviso','Debe Ingresar Centro de Costo Valido , Verifique!')					
					SetNull(ls_codigo)
					SetNull(ls_descripcion)
					This.Object.cencos      [row] = ls_codigo
					This.Object.desc_cencos [row] = ls_descripcion
					Return 1
				ELSE
					SELECT desc_cencos
				     INTO :ls_descripcion
				     FROM centros_costo
				    WHERE (cencos      = :data ) AND
				          (flag_estado = '1'   )  ;
						 
					This.Object.desc_cencos [row] = ls_descripcion
					
				END IF
				
		 CASE 'cnta_prsp'	
			
				SELECT Count(*)
				  INTO :ll_count
				  FROM presupuesto_cuenta
				 WHERE (cnta_prsp = :data) ;
				
				
				IF ll_count = 0 THEN
					Messagebox('Aviso','Debe Ingresar Cuenta Presupuestal Valida , Verifique!')					
					SetNull(ls_codigo)
					SetNull(ls_descripcion)
					This.Object.cnta_prsp     		 [row] = ls_codigo
					This.Object.cuenta_descripcion [row] = ls_descripcion
					Return 1
				ELSE
					SELECT descripcion
					  INTO :ls_descripcion
					  FROM presupuesto_cuenta
					 WHERE (cnta_prsp = :data) ;
					 
					 This.Object.cuenta_descripcion [row] = ls_descripcion
					
					
				END IF
				 		 
END CHOOSE

end event

event itemerror;call super::itemerror;Return 1
end event

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
	            		// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'form'	// tabular, form (default)

ii_ck[1] = 1			// columnas de lectrua de este dw
ii_ck[2] = 2			// columnas de lectrua de este dw


idw_mst  = dw_master // dw_master

end event

event ue_insert_pre;call super::ue_insert_pre;String ls_cnta_prsp_og

select cnta_prsp_ogiro 
	into :ls_cnta_prsp_og  
from finparam 
where reckey = '1' ;

This.Object.origen 		   [al_row] = gs_origen
This.Object.fecha_registro	[al_row] = gnvo_app.of_fecha_Actual()
This.Object.fecha_emision  [al_row] = Date(gnvo_app.of_fecha_Actual())
This.Object.flag_estado    [al_row] = '1'
This.Object.usuario	      [al_row] = gs_user
This.Object.cnta_prsp	  	[al_row] = ls_cnta_prsp_og


is_Action = 'new'



end event

event doubleclicked;call super::doubleclicked;IF Getrow() = 0 THEN Return
String ls_name,ls_prot
str_seleccionar lstr_seleccionar

ls_name = dwo.name
ls_prot = this.Describe( ls_name + ".Protect")

if ls_prot = '1' then    //protegido 
	return
end if


CHOOSE CASE dwo.name
		 CASE 'cod_relacion'
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT VW_FIN_PERSON_AUTORIZ_SOL_GIRO.CODIGO  AS CODIGO_TRABAJADOR ,'&   
         											 +'VW_FIN_PERSON_AUTORIZ_SOL_GIRO.NOMBRE  AS NOMBRES ,'&
														 +'VW_FIN_PERSON_AUTORIZ_SOL_GIRO.SOLICITUDES_MAX  AS SOLICITUDES_MAX  ,'&
														 +'VW_FIN_PERSON_AUTORIZ_SOL_GIRO.SOLICITUDES_GEN  AS SOLICITUDES_GEN  '&
         										    +'FROM VW_FIN_PERSON_AUTORIZ_SOL_GIRO '   


				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'cod_relacion',lstr_seleccionar.param1[1])
					Setitem(row,'nombre',lstr_seleccionar.param2[1])
					ii_update = 1
				END IF
				
		 CASE 'cencos'
			
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT CENTROS_COSTO.CENCOS AS CODIGO ,'&   
         											 +'CENTROS_COSTO.DESC_CENCOS AS DESC_CENCOS '&
         										    +'FROM CENTROS_COSTO '&  
														 +"WHERE FLAG_ESTADO = '1'"


				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'cencos',lstr_seleccionar.param1[1])
					Setitem(row,'desc_cencos',lstr_seleccionar.param2[1])
					ii_update = 1
				END IF
				
		 CASE 'cnta_prsp'
			
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT PRESUPUESTO_CUENTA.CNTA_PRSP AS CODIGO ,'&   
         											 +'PRESUPUESTO_CUENTA.DESCRIPCION AS DESCRIPCION '&
         										    +'FROM PRESUPUESTO_CUENTA '   

				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'cnta_prsp',lstr_seleccionar.param1[1])
					Setitem(row,'cuenta_descripcion',lstr_seleccionar.param2[1])
					ii_update = 1
				END IF
			
END CHOOSE

end event

event type long keydwn(keycode key, unsignedlong keyflags);call super::keydwn;IF Key = keyF4! THEN
	Parent.TriggerEvent('ue_find_exact')
END IF

Return 0
end event

