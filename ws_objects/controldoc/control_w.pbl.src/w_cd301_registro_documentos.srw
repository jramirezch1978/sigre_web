$PBExportHeader$w_cd301_registro_documentos.srw
forward
global type w_cd301_registro_documentos from w_abc_master
end type
end forward

global type w_cd301_registro_documentos from w_abc_master
integer width = 2597
integer height = 2000
string title = "(CD301) Registro de Documentos "
string menuname = "m_abc_anula_sin_eliminar"
boolean resizable = false
end type
global w_cd301_registro_documentos w_cd301_registro_documentos

type variables
string is_next_nro 
DatawindowChild idw_forma_pago

end variables

forward prototypes
public subroutine of_retrieve (string as_nro_lote)
public function integer of_set_numera ()
end prototypes

public subroutine of_retrieve (string as_nro_lote);dw_master.retrieve( as_nro_lote )

//dw_master.ii_protect = 0
//dw_master.of_protect( )
//dw_master.ii_update = 0

is_Action = 'open'

end subroutine

public function integer of_set_numera ();// Numera documento
Long 		ll_count, ll_ult_nro, ll_i
String  	ls_lock_table, ls_mensaje

IF idw_1.getrow() = 0 THEN RETURN 0

IF is_action = 'new' THEN
	SELECT count(*)
		INTO :ll_count
	FROM num_documentos_recibidos
	WHERE origen = :gs_origen;
	
	IF ll_count = 0 THEN
		
		INSERT INTO num_documentos_recibidos(origen, ult_nro)
		VALUES( :gs_origen, 1);
		
	end if
	
	SELECT ult_nro
	  INTO :ll_ult_nro
	FROM num_documentos_recibidos
	WHERE origen = :gs_origen FOR UPDATE;
	
	is_next_nro = trim(gs_origen) + string(ll_ult_nro, '00000000')
	
	UPDATE num_documentos_recibidos
		SET ult_nro = :ll_ult_nro + 1 
	WHERE origen = :gs_origen;

	idw_1.object.nro_registro[idw_1.getrow()] = is_next_nro
	idw_1.ii_update = 1
END IF

RETURN 1
end function

event ue_update;// Ancestor Script has been Override

Boolean lbo_ok = TRUE
//string	ls_nro_registro

if idw_1.GetRow() = 0 then return

idw_1.AcceptText()


THIS.EVENT ue_update_pre()

//ib_update_check = TRUE

IF ib_update_check = FALSE THEN RETURN

IF ib_log THEN
	dw_master.of_create_log()
END IF

IF	dw_master.ii_update = 1 THEN
	IF dw_master.Update(true, false) = -1 then		// Grabacion del Master
		lbo_ok = FALSE
    	Rollback ;
		messagebox("Error en Grabacion Master", &
		           "Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF ib_log and lbo_ok THEN
	lbo_ok = dw_master.of_save_log()
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	idw_1.ii_update  = 0
	idw_1.ii_protect = 0
	idw_1.of_protect( )
	idw_1.ResetUpdate()
	
	f_mensaje("Grabación realizada satisfactoriamente","")

END IF

is_action = 'open'


end event

event ue_update_pre;call super::ue_update_pre;String ls_cod_rel, ls_tipo_doc, ls_nro_doc
Long ll_count

ib_update_check = False

if f_row_processing( idw_1, 'form') = false then return

ls_cod_rel 	= idw_1.object.cod_relacion [idw_1.GetRow()]
ls_tipo_doc = idw_1.object.tipo_doc		 [idw_1.GetRow()]
ls_nro_doc 	= idw_1.object.nro_doc		 [idw_1.GetRow()]

IF is_action = 'new' THEN
	SELECT count(*) 
	 INTO :ll_count 
	 FROM cd_doc_recibido c
	WHERE c.cod_relacion	= :ls_cod_rel 
	  and c.tipo_doc		= :ls_tipo_doc 
	  and c.nro_doc		= :ls_nro_doc 
	  and c.flag_estado	<>'0';
	
	IF ll_count>0 THEN
		MessageBox('Aviso','Documento ya fue anteriormente registrado')
		Return
	END IF
	
	// Genera el numero del embarque
	if of_set_numera() = 0 then return
	
	idw_1.object.nro_registro[idw_1.GetRow()] = is_next_nro 
	
END IF

// Si todo ha salido bien cambio el indicador ib_update_check a true, 
//para indicarle al evento ue_update que todo ha salido bien

ib_update_check = true
end event

on w_cd301_registro_documentos.create
call super::create
if this.MenuName = "m_abc_anula_sin_eliminar" then this.MenuID = create m_abc_anula_sin_eliminar
end on

on w_cd301_registro_documentos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre;call super::ue_open_pre;// Abriendo el ultimo registro
Long ll_count 
String ls_nro_registro

of_position_window(100,100) 

SELECT count(*) 
  INTO :ll_count 
  FROM cd_doc_recibido ;

IF ll_count>0 THEN   
	SELECT nro_registro 
	  INTO :ls_nro_registro 
	  FROM cd_doc_recibido 
	 order by fecha_registro desc;
	
	if not isnull(ls_nro_registro) then dw_master.retrieve( ls_nro_registro )
	
END IF

is_action = 'open'
end event

event ue_anular;call super::ue_anular;Long     ll_count, ll_nro_reg 
String   ls_nro_registro, ls_null ,ls_msj_err
Datetime ld_fecha_actual


// Retorna si no ha seleccionado ningun registro
IF dw_master.GetRow() = 0 THEN RETURN

//VERIFICAR ACCESOS DE USUARIO
select Count(*) into :ll_count from cd_usuario_seccion 
 where (cod_usr 	     = :gs_user ) and
 		 (flag_estado    = '1'	    ) and
		 (flag_recepcion = '1'	    ) ;


if ll_count = 0 then
	Messagebox('Aviso','Usuario no esta Autorizado a Eliminar Documentos , Verifique!')
	Return
end if
// Captura registro y verifica su movimiento historico
ls_nro_registro = dw_master.object.nro_registro[dw_master.GetRow()]

// Eliminando detalle
ll_count = MessageBox("Aviso", 'Esta seguro anular registro', Exclamation!, YesNo!, 2)

IF ll_count = 2 THEN
	RETURN 
ELSE
	DELETE FROM cd_doc_movimiento c
	 WHERE c.nro_registro = :ls_nro_registro ;
	 
	IF SQLCA.SQLCode = -1 THEN 
		ls_msj_err = SQLCA.SQLErrText
		Rollback ;
      MessageBox('Error',ls_msj_err)
		Return
	END IF
	
	Setnull(ls_null)
	
	dw_master.object.tipo_doc        [dw_master.GetRow()] = ls_null
	dw_master.object.nro_doc         [dw_master.GetRow()] = ls_null
	dw_master.object.flag_estado     [dw_master.GetRow()] = '0' 
	dw_master.object.flag_referencia [dw_master.GetRow()] = '0' 
	dw_master.object.valor_venta	   [dw_master.GetRow()] = 0.00
	dw_master.object.precio_venta		[dw_master.GetRow()] = 0.00 
	dw_master.object.observacion		[dw_master.GetRow()] = 'Anulado' 

	
	
	dw_master.ii_update = 1
	TriggerEvent('ue_update')
END IF

end event

event ue_modify;// Override
IF dw_master.GetRow()=0 THEN RETURN

IF TRIM(dw_master.object.cod_usr_reg[dw_master.GetRow()]) <> TRIM(gs_user) THEN
	Messagebox('Aviso', 'Usuario no autorizado a modificar datos de registro')
	Return 
END IF 

dw_master.of_protect()
end event

event ue_insert;Long  ll_row

//
idw_1.reset()

ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN
	THIS.EVENT ue_insert_pos(ll_row)
end if

end event

event ue_open_pos;call super::ue_open_pos;IB_LOG = TRUE
end event

event ue_retrieve_list;// Asigna valores a structura 
String ls_registro

str_parametros sl_param

sl_param.dw1    = 'd_abrir_doc_recibidos_tbl' 
sl_param.titulo = 'DOCUMENTOS REGISTRADOS'
sl_param.field_ret_i[1] = 1	//Documentos Registrados

OpenWithParm( w_lista, sl_param )


sl_param = Message.PowerObjectParm

IF sl_param.titulo <> 'n' THEN
	ls_registro = sl_param.field_ret[1]
	of_retrieve(sl_param.field_ret[1])
END IF
end event

type dw_master from w_abc_master`dw_master within w_cd301_registro_documentos
event ue_display ( string as_columna,  long al_row )
integer width = 2542
integer height = 1648
string dataobject = "d_doc_recibido_ff"
end type

event dw_master::ue_display(string as_columna, long al_row);boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_ruc, ls_nro_embarque, ls_sql_fc, ls_sql_fp, &
			ls_tipo_impuesto, ls_signo
long 		ll_dias
Integer  li_factor
date		ld_fecha_vencimiento
Decimal {2} ld_tasa_impuesto


CHOOSE CASE upper(as_columna)
	
	CASE "NRO_REGISTRO"
		ls_sql = "SELECT NRO_REGISTRO AS NUMERO_REGISTRO, " 		 &
			 		+ "NRO_OV AS NUMERO_OV " &
			  		+ "FROM CD_DOC_RECIBIDO " 						 &
			  		+ "where flag_estado = '1'"
			 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
	
		IF ls_codigo <> '' THEN
			This.object.NRO_REGISTRO	[al_row] = ls_codigo
		END IF
		This.ii_update = 1
		
	CASE "COD_RELACION"
		ls_sql = "SELECT proveedor AS codigo, " 		 &
			 		+ "nom_proveedor AS nom_proveedor, " &
				  	+ "RUC as RUC_proveedor " 				 &
			  		+ "FROM proveedor " 						 &
			  		+ "where flag_estado = '1'"
			 
		lb_ret = f_lista_3ret(ls_sql, ls_codigo, ls_data, ls_ruc, '2')
	
		IF ls_codigo <> '' THEN
			This.object.cod_relacion  [al_row] = ls_codigo
			This.object.nom_proveedor [al_row] = ls_data						
		END IF
		This.ii_update = 1
		
	CASE "TIPO_DOC"
		ls_sql = "SELECT TIPO_DOC AS CODIGO, " 	&
			    + "DESC_TIPO_DOC AS DESCRIPCION " 	&
				 + "FROM VW_DOC_TIPO_CONTROL_DOC " 	

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		IF ls_codigo <> '' THEN
			This.object.tipo_doc[al_row] = ls_codigo
		END IF
		
   	// Para conocer el factor de documento
		SELECT factor 
		  INTO :li_factor 
		  FROM doc_tipo 
		 WHERE tipo_doc = :ls_codigo AND flag_estado<>'0' ;
		 
		IF li_factor > 0 THEN 
			this.object.flag_tabla[al_row] = '1'
		ELSEIF li_factor = 0 THEN 
			this.object.flag_tabla[al_row] = '0'			
		ELSEIF li_factor < 0 THEN 
			this.object.flag_tabla[al_row] = '3'
		END IF 
		
		This.ii_update = 1	

case "COD_MONEDA"
		ls_sql = "SELECT cod_moneda AS CODIGO_moneda, " &
				  + "descripcion AS Descripcion " &
				  + "FROM moneda " 

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		IF ls_codigo <> '' then
			this.object.cod_moneda[al_row] = ls_codigo
			this.object.moneda_descripcion[al_row] = ls_data
		END IF
		This.ii_update = 1

case "FORMA_PAGO"
		ls_sql = "SELECT forma_pago AS CODIGO_forma_pago, " &
				  + "desc_forma_pago AS Descripcion , " &
				  + "dias_vencimiento AS Dias " &
				  + "FROM forma_pago " 

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

		IF ls_codigo <> '' then
			
			select dias_vencimiento into :ll_dias from forma_pago
			 where (forma_pago = :ls_codigo) ;
			
			IF ll_dias > 0 THEN
				ld_fecha_vencimiento = RelativeDate ( date(this.object.fecha_recepcion [al_row]) , ll_dias )
				This.Object.fecha_venc [al_row] = ld_fecha_vencimiento
			END IF			
			
			this.object.forma_pago[al_row] = ls_codigo
		END IF
		This.ii_update = 1

case "TIPO_IMPUESTO"
	
	ls_sql = "SELECT tipo_impuesto AS codigo, " &
				  + "desc_impuesto AS Descripcion , " &
				  + "tasa_impuesto AS Tasa , " &				  
				  + "signo AS TSigno " &
				  + "FROM impuestos_tipo " 

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

		IF ls_codigo <> '' then
			this.object.tipo_impuesto[al_row] = ls_codigo
		END IF

		SELECT tasa_impuesto, signo 
		  INTO :ld_tasa_impuesto, :ls_signo
		  FROM impuestos_tipo 
		 WHERE tipo_impuesto = :ls_tipo_impuesto ;
		
		IF ls_signo ='+' THEN
			This.object.precio_venta[al_row]	= This.object.valor_venta[al_row] * (100 + ld_tasa_impuesto)/100
		ELSE
			This.object.precio_venta[al_row]	= This.object.valor_venta[al_row] * (100 - ld_tasa_impuesto)/100
		END IF 			
		
		This.ii_update = 1
	
END CHOOSE

end event

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw

end event

event dw_master::doubleclicked;call super::doubleclicked;string ls_columna
long ll_row 
str_seleccionar lstr_seleccionar

THIS.AcceptText()
IF THIS.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

IF row > 0 THEN
	ls_columna = upper(dwo.name)
	THIS.event dynamic ue_display(ls_columna, ll_row)
END IF


end event

event dw_master::itemchanged;call super::itemchanged;STRING ls_flag, ls_data, ls_codigo, ls_prov, ls_null, ls_tipo_impuesto, ls_signo, &
		 ls_doc_oc, ls_doc_os, ls_flag_referencia, ls_tipo_ref, ls_nro_ref, ls_moneda, &
		 ls_obs, ls_nom_proveedor, ls_forma_pago
		 
LONG ll_count
integer  li_dias_venc, li_opcion, li_factor
Date   ld_fecha_documento, ld_fecha_vencimiento, ld_fecha_emision, ld_fecha_venc, &
		 ld_fecha_registro, ld_fecha_recepcion
Decimal {2} ld_tasa_impuesto
SetNull(ls_null)
THIS.AcceptText()

IF row = 0 then
	RETURN
END IF



CHOOSE CASE upper(dwo.name)
		
	CASE "FLAG_REFERENCIA"
		ls_flag_referencia = trim(this.object.flag_referencia[row]) 
		
		IF ls_flag_referencia = '1' THEN 
			this.object.tipo_ref	[row] = ls_null
			this.object.nro_ref	[row] = ls_null
		END IF 
		
	CASE "NRO_REF"		
		ls_flag_referencia = TRIM(this.object.flag_referencia[row]) 

		IF ls_flag_referencia = '1' THEN 
			MessageBox('Aviso','Referencia no es valida')
			this.object.tipo_ref[row] = ls_null
			this.object.nro_ref[row] = ls_null
			
		ELSeif ls_flag_referencia = '2' then
			
			SELECT doc_oc, doc_os 
			  INTO :ls_doc_oc, :ls_doc_os
			  FROM logparam l 
			 WHERE reckey='1' ;

		   ls_tipo_ref = this.object.tipo_ref	[row]
			ls_nro_ref = this.object.nro_ref		[row]
			
			IF (trim(ls_tipo_ref) = trim(ls_doc_oc)) OR (trim(ls_tipo_ref) = trim(ls_doc_os)) THEN 
					IF TRIM(ls_tipo_ref) = TRIM(ls_doc_oc) THEN 
						SELECT o.proveedor, o.observacion, o.cod_moneda, p.nom_proveedor, o.forma_pago 
						  INTO :ls_codigo, :ls_obs, :ls_moneda, :ls_nom_proveedor, :ls_forma_pago
						  FROM orden_compra o, proveedor p
						 WHERE o.proveedor = p.proveedor AND 
						 		 o.nro_oc = :ls_nro_ref ;
					ELSEIF TRIM(ls_tipo_ref) = TRIM(ls_doc_os) THEN 
						SELECT o.proveedor, o.descripcion, o.cod_moneda, p.nom_proveedor, o.forma_pago
						  INTO :ls_codigo, :ls_obs, :ls_moneda, :ls_nom_proveedor, :ls_forma_pago
						  FROM orden_servicio o, proveedor p 
						 WHERE o.proveedor = p.proveedor AND  
						 		 o.nro_os = :ls_nro_ref ;
					END IF 
					
					this.object.cod_relacion	[row] = ls_codigo
					this.object.cod_moneda		[row] = ls_moneda
					this.object.observacion		[row] = ls_obs
					this.object.nom_proveedor	[row] = ls_nom_proveedor
					this.object.forma_pago		[row] = ls_forma_pago
			ELSE
				 Messagebox('Aviso','Tipo de referencia no valida')
				 Return 1
			END IF 
			

		END IF 
				
	CASE "COD_RELACION"
		
		ls_codigo = this.object.cod_relacion[row] 
		
   	SELECT count(*) 
        INTO :ll_count 
		  FROM proveedor
		 WHERE proveedor = :ls_codigo ;

		IF ll_count=0 THEN
			MessageBox('Aviso', 'Proveedor no existe')
			this.object.cod_relacion[row] = ls_null 
			RETURN 1
		END IF 
		
		SELECT nom_proveedor
        INTO :ls_data
		FROM proveedor
		WHERE proveedor = :ls_codigo ;
		
		THIS.object.nom_proveedor[row] = ls_data

CASE "TIPO_DOC"

		ls_codigo = this.object.tipo_doc[row] 

		SELECT count(*)
		  INTO :ll_count 
  		  FROM doc_tipo d 
 		 WHERE d.flag_estado='1' 
			AND d.tipo_doc = :ls_codigo 
		   AND d.tipo_doc in (select dr.tipo_doc from doc_grupo_relacion dr 
               where dr.grupo=(select c.grupo_cd from cdparam c where reckey='1')) ;
		 

		IF ll_count=0 THEN
			MessageBox('Aviso', 'Documento no existe, o desactivado, o no se registra en control documentario')
			this.object.tipo_doc[row] = ls_null 
			RETURN 1
		END IF 
		
		SELECT NVL(factor,0) 
		  INTO :li_factor 
		  FROM doc_tipo 
		 WHERE tipo_doc = :ls_codigo AND flag_estado<>'0' ;
		
		IF li_factor > 0 THEN 
			this.object.flag_tabla[row] = '1'
		ELSEIF li_factor = 0 THEN 
			this.object.flag_tabla[row] = '0'			
		ELSEIF li_factor < 0 THEN 
			this.object.flag_tabla[row] = '3'
		END IF 
		
CASE "COD_MONEDA"

		ls_codigo = this.object.cod_moneda[row] 
		
   	SELECT count(*) 
        INTO :ll_count 
		  FROM moneda
		 WHERE cod_moneda = :ls_codigo ;

		IF ll_count=0 THEN
			MessageBox('Aviso', 'Moneda no existe')
			this.object.cod_moneda[row] = ls_null 
			RETURN 1
		END IF 
		
		SELECT descripcion
        INTO :ls_data
		FROM moneda
		WHERE cod_moneda = :ls_codigo ;

CASE 'FORMA_PAGO'

		ls_codigo = this.object.forma_pago[row] 
		
   	SELECT count(*) 
        INTO :ll_count 
		  FROM forma_pago
		 WHERE forma_pago = :ls_codigo ;

		IF ll_count=0 THEN
			MessageBox('Aviso', 'Forma de Pago no existe')
			this.object.forma_pago[row] = ls_null 
			RETURN 1
		END IF 
		
		select dias_vencimiento into :li_dias_venc
   	  from forma_pago
		 where (forma_pago = :data ) ;
		 
		IF li_dias_venc > 0 THEN
			
			//li_opcion = MessageBox('Aviso','Desea Generar Fecha de Vencimiento Dependiendo de la Forma de Pago', question!, YesNo!, 2)
			//IF li_opcion = 1 THEN
				ld_fecha_vencimiento = Relativedate(Date(This.object.fecha_recepcion[row]),li_dias_venc)
				This.Object.fecha_venc [row] = ld_fecha_vencimiento
			//END IF
		ELSE
			This.Object.fecha_venc [row] = This.object.fecha_recepcion[row]
		END IF

CASE 'FECHA_RECEPCION'
	ld_fecha_recepcion = DATE(This.object.fecha_recepcion[row])
	ld_fecha_registro  = DATE(This.object.fecha_registro[row])
	IF ld_fecha_recepcion > ld_fecha_registro THEN
		MessageBox('Aviso','Fecha de rececpción no puede ser mayor a fecha de registro')
		This.object.fecha_recepcion[row] = This.object.fecha_registro[row]
		Return 1
	END IF
	ls_codigo = this.object.forma_pago[row] 
  	SELECT count(*) 
     INTO :ll_count 
	  FROM forma_pago
	 WHERE forma_pago = :ls_codigo ;
	
	IF ll_count=0 THEN
		MessageBox('Aviso', 'Forma de Pago no existe')
		this.object.forma_pago[row] = ls_null 
		RETURN 1
	END IF 
	
	select dias_vencimiento into :li_dias_venc
     from forma_pago
	 where (forma_pago = :data ) ;
		 
	IF li_dias_venc > 0 THEN
		ld_fecha_vencimiento = Relativedate(Date(This.object.fecha_recepcion[row]),li_dias_venc)
		This.Object.fecha_venc [row] = ld_fecha_vencimiento
	ELSE
		This.Object.fecha_venc [row] = This.object.fecha_recepcion[row]
	END IF

CASE 'FECHA_EMISION'
	ld_fecha_emision = DATE(This.object.fecha_emision[row])
	ld_fecha_registro  = DATE(This.object.fecha_registro[row])
	IF ld_fecha_emision > ld_fecha_registro THEN
		MessageBox('Aviso','Fecha de emisión no puede ser mayor a fecha de registro')
		This.object.fecha_emision[row] = This.object.fecha_registro[row]
		Return 1
	END IF	
CASE 'TIPO_IMPUESTO' 
		ls_codigo = this.object.tipo_impuesto[row] 

   	SELECT count(*) 
        INTO :ll_count 
		  FROM impuestos_tipo
		 WHERE tipo_impuesto = :ls_codigo ;

		IF ll_count=0 THEN
			MessageBox('Aviso', 'Tipo de impuesto no existe')
			this.object.tipo_impuesto[row] = ls_null 
			RETURN 1
		ELSE
			SELECT tasa_impuesto, signo 
			  INTO :ld_tasa_impuesto, :ls_signo
			  FROM impuestos_tipo 
			 WHERE tipo_impuesto = :ls_tipo_impuesto ;
			
			IF ls_signo ='+' THEN
				This.object.precio_venta[row]	= This.object.valor_venta[row] * (100 + ld_tasa_impuesto)/100
			ELSE
				This.object.precio_venta[row]	= This.object.valor_venta[row] * (100 - ld_tasa_impuesto)/100
			END IF 			
		END IF 

CASE 'VALOR_VENTA' 
	IF ISNULL(This.object.tipo_impuesto[row]) OR TRIM(This.object.tipo_impuesto[row])='' THEN
		This.object.precio_venta[row]	= This.object.valor_venta[row]
	ELSE
		ls_tipo_impuesto = This.object.tipo_impuesto[row]
		SELECT tasa_impuesto, signo 
        INTO :ld_tasa_impuesto, :ls_signo
        FROM impuestos_tipo 
       WHERE tipo_impuesto = :ls_tipo_impuesto ;
		
		IF ls_signo ='+' THEN
			This.object.precio_venta[row]	= This.object.valor_venta[row] * (100 + ld_tasa_impuesto)/100
		ELSE
			This.object.precio_venta[row]	= This.object.valor_venta[row] * (100 - ld_tasa_impuesto)/100
		END IF 
	END IF 		
END CHOOSE

end event

event dw_master::itemerror;call super::itemerror;RETURN 1
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

event dw_master::ue_insert_pre;call super::ue_insert_pre;string ls_area, ls_seccion, ls_cod_area, ls_cod_seccion
Long 	ll_count
date	ld_fecha

ld_fecha = Date(gnvo_app.of_fecha_actual())

SELECT c.cod_area, a.desc_area, c.cod_seccion, s.desc_seccion 
  INTO :ls_cod_area, :ls_area, :ls_cod_seccion, :ls_seccion
  FROM cd_usuario_seccion c, area a, seccion s 
 WHERE (c.cod_area=s.cod_area) and 
		 (c.cod_seccion=s.cod_seccion and 
		 a.cod_area=s.cod_area) and 
		 c.cod_usr=:gs_user 
		 and c.cod_origen=:gs_origen 
		 and c.flag_recepcion='1';

This.object.cod_usr_reg		[al_row] = gs_user
This.object.cod_origen		[al_row] = gs_origen

This.object.org_destino		[al_row] = gs_origen
This.object.usr_destino		[al_row] = gs_user
This.object.area_destino	[al_row] = ls_cod_area
This.object.seccion_destino[al_row] = ls_cod_seccion

This.object.fecha_registro		[al_row] = gnvo_app.of_fecha_actual()
This.object.fecha_recepcion	[al_row] = ld_fecha
This.object.fecha_emision		[al_row] = ld_fecha
This.object.fecha_venc			[al_row] = ld_fecha
This.object.flag_transfer		[al_row] = '1'
This.object.flag_tabla			[al_row] = '0'
This.object.flag_referencia	[al_row] = '2'
This.object.flag_estado			[al_row] = '1'
This.object.flag_provisionado	[al_row] = '0'
This.object.item					[al_row] = 1

This.object.desc_area[al_row] = ls_area
This.object.desc_seccion[al_row] = ls_seccion

is_action = 'new'
end event

event dw_master::ue_insert;// Override
long ll_count

select count(*)
	into :ll_count
from cd_usuario_seccion
where cod_origen=:gs_origen 
  and cod_usr=:gs_user 
  and flag_recepcion='1';

If ll_count=0 Then
	messagebox('AVISO', 'No Autorizado a Registrar Documentos')
	return 1
end If
//

long ll_row
IF is_mastdet = 'dd' OR is_mastdet = 'd' THEN
	IF idw_mst.il_row = 0 THEN
		MessageBox("Error", "No ha seleccionado registro Maestro")
		RETURN - 1
	END IF
END IF


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

