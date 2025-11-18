$PBExportHeader$w_abc_master.srw
$PBExportComments$abc para una sola tabla tipo ff, con pop de busqueda
forward
global type w_abc_master from w_abc
end type
type dw_master from u_dw_abc within w_abc_master
end type
end forward

global type w_abc_master from w_abc
integer width = 2117
integer height = 1844
event ue_retrieve ( )
dw_master dw_master
end type
global w_abc_master w_abc_master

type variables

end variables

event ue_retrieve();//dw_master.Retrieve()
//this.event ue_query_retrieve()
end event

on w_abc_master.create
int iCurrent
call super::create
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_master
end on

on w_abc_master.destroy
call super::destroy
destroy(this.dw_master)
end on

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - 10
dw_master.height = newheight - dw_master.y - 10
end event

event ue_insert;call super::ue_insert;Long  ll_row

ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN
	THIS.EVENT ue_insert_pos(ll_row)
end if

end event

event ue_modify;call super::ue_modify;dw_master.of_protect() 
end event

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_master             // asignar dw corriente
idw_1.SetTransObject(SQLCA)
idw_1.of_protect()         	// bloquear modificaciones al dw_master

//idw_1.Retrieve()
//ii_help = 101            // help topic
//ii_pregunta_delete = 1   // 1 = si pregunta, 0 = no pregunta (default)
ib_log = TRUE
//idw_query = dw_master


end event

event ue_print;call super::ue_print;OpenWithParm(w_print_opt, dw_master)

If Message.DoubleParm = -1 Then Return

dw_master.Print(True)

end event

event ue_scrollrow;call super::ue_scrollrow;Long ll_rc

ll_rc = idw_1.of_ScrollRow(as_value)

RETURN ll_rc
end event

event ue_update;Boolean lbo_ok = TRUE
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
	
	f_mensaje('Grabación realizada satisfactoriamente', '')
	
	this.event ue_retrieve()
	
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

event ue_update_request;call super::ue_update_request;Integer li_msg_result

IF dw_master.ii_update = 1 THEN
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	IF li_msg_result = 1 THEN
 		THIS.EVENT ue_update()
	else
		ib_update_check = true
	END IF
END IF


end event

event ue_open_pos;call super::ue_open_pos;//IF ib_log THEN											
//	in_log = Create n_cst_log_diario
//	in_log.of_dw_map(idw_1, is_colname, is_coltype)
//END IF
end event

event ue_close_pre();call super::ue_close_pre;IF ib_log THEN
	DESTROY n_cst_log_diario
END IF

end event

event ue_duplicar;call super::ue_duplicar;

idw_1.Event ue_duplicar()

end event

type dw_master from u_dw_abc within w_abc_master
integer width = 1970
integer height = 1568
boolean bringtotop = true
end type

event clicked;call super::clicked;idw_1 = THIS
end event

event itemchanged;call super::itemchanged;//Int 		li_val, li_saldo_consig, li_saldo_pres, li_saldo_dev
//string 	ls_nombre, ls_null, ls_mensaje, ls_desc, ls_almacen
//DATE 		ld_null
//
//This.AcceptText()
//if row = 0 then return
//if dw_master.GetRow() = 0 then return
//
//CHOOSE CASE lower(dwo.name)
//	CASE 'fec_registro'
//		id_fecha_proc = this.object.fec_registro[row]
//		
//		// Verifica tipo de cambio
//		in_tipo_cambio = f_get_tipo_cambio( Date(id_fecha_proc) )
//		if in_tipo_cambio = 0 THEN 
//			
//			// Cojo el ultimo tipo de cambio de la tabla logparam
//			Select ult_tipo_cam
//				into :in_tipo_cambio 
//			from logparam
//			where reckey = '1';
//			
//			if SQLCA.SQLCode = 100 then
//				MessageBox('Aviso', 'No hay parametros en LogParam')
//				return 1
//			end if
//			
//			if in_tipo_cambio = 0 or IsNull(in_tipo_cambio) then
//				MessageBox('Aviso', 'El ultimo tipo de cambio en LogParam es cero o nulo')
//				return 1
//			end if
//			
//		end if		
//		
//	CASE 'almacen'
//
//		SELECT desc_almacen 
//			INTO :ls_desc
//		FROM almacen
//   	WHERE  almacen = :data
//		  and flag_estado = '1'
//		  and cod_origen = :gs_origen
//		  and flag_tipo_almacen <> 'O'; 
//		  
//		IF SQLCA.SQLCODE = 100 or SQLCA.SQLCode < 0 THEN
//			if SQLCA.SQLCode = 100 then
//				Messagebox('Aviso','Codigo de almacen no existe, ' &
//					+ 'no esta activo, no le corresponde a su origen, ' &
//					+ 'o es ALMACEN DE TRÁNSITO, por favor verifique')
//			else
//				MessageBox('Aviso', SQLCA.SQLErrText)
//			end if
//			this.Object.almacen		[row] = ls_null
//			this.object.desc_almacen[row] = ls_null
//			this.setcolumn( "almacen" )
//		 	this.setfocus()
//			RETURN 1
//		END IF
//		this.object.desc_almacen [row] = ls_desc
//		
//	CASE 'tipo_mov'
//		ls_almacen = dw_master.object.almacen [dw_master.GetRow()]
//		
//		if of_tipo_mov(data)  = 0 then // Evalua datos segun tipo de mov.
//			this.object.tipo_mov[row] = ls_null
//			RETURN 1
//		end if
//		
//		SELECT 	a.desc_tipo_mov, 		a.factor_sldo_consig,
//					a.factor_sldo_dev,	a.factor_sldo_pres,
//					a.tipo_mov_dev
//			INTO 	:ls_nombre,				:li_saldo_consig,
//					:li_saldo_pres,		:li_saldo_dev,
//					:is_tipo_mov_dev
//		FROM  articulo_mov_tipo a,
//				almacen_tipo_mov  b
//   	WHERE a.tipo_mov 		= b.tipo_mov
//		  and a.flag_estado 	= '1'
//		  and a.tipo_mov 		= :data 
//		  and b.almacen 		= :ls_almacen;
//		
//		IF SQLCA.SQLCODE = 100 or SQLCA.SQLCode < 0 THEN
//			if SQLCA.SQLCOde = 100 then
//				Messagebox('Aviso','Tipo de Movimiento no existe, no esta activo ' &
//					+ 'o no le corresponde al almacen')
//			else
//				MessageBox('Aviso', SQLCA.SQLErrText)
//			end if
//			
//			this.Object.tipo_mov			[row] = ls_null
//			this.object.desc_tipo_mov 	[row] = ls_null
//			this.setcolumn( "tipo_mov" )
//			this.setfocus()
//			RETURN 1
//		END IF
//		
//		if is_tipo_mov_dev <> '' and Not IsNull(is_tipo_mov_dev) then
//			if is_tipo_mov_dev = data then
//				Messagebox('Aviso','Tipo de movimiento no puede ser devolucion de si mismo ' &
//					+ '~r~nTipo de Mov	 : ' + data &
//					+ '~r~nTipo de Mov Dev: ' + is_tipo_mov_dev )
//					
//				this.Object.tipo_mov			[row] = ls_null
//				this.object.desc_tipo_mov 	[row] = ls_null
//				this.setcolumn( "tipo_mov" )
//				this.setfocus()
//				RETURN 1
//			end if
//		end if
//		
//		if li_saldo_consig <> 0 then
//			Messagebox('Aviso','El movimiento x consignacion no se maneja por esta ventana, ' &
//						+ 'Tiene que ir a la opcion de consignaciones')
//			this.Object.tipo_mov			[row] = ls_null
//			this.object.desc_tipo_mov 	[row] = ls_null
//			this.setcolumn( "tipo_mov" )
//			this.setfocus()
//			RETURN 1
//		end if
//
//		if li_saldo_pres <> 0 or li_saldo_dev <> 0 then
//			Messagebox('Aviso','El movimiento x Prestamos o Devoluciones no se maneja ' &
//						+ 'por esta ventana, Tiene que ir a la opcion de ' &
//						+ 'prestamos/devoluciones' )
//			this.Object.tipo_mov			[row] = ls_null
//			this.object.desc_tipo_mov 	[row] = ls_null
//			this.setcolumn( "tipo_mov" )
//			this.setfocus()
//			RETURN 1
//		end if
//
//		this.object.desc_tipo_mov	[row] = ls_nombre
//		this.object.tipo_mov.background.color = RGB(192,192,192)   
//		this.object.tipo_mov.protect = 1
//		
//	CASE 'proveedor'
//
//		SELECT NOM_PROVEEDOR 
//			INTO :ls_nombre 
//		FROM proveedor
//   	WHERE  PROVEEDOR = :data 
//		  and flag_estado = '1';
//		  
//		IF SQLCA.SQLCODE = 100 or SQLCA.SQLCode < 0 THEN
//			if SQLCA.SQLCOde = 100 then
//				Messagebox('Aviso','Codigo de Proveedor no existe, no esta activo ')
//			else
//				MessageBox('Aviso', SQLCA.SQLErrText)
//			end if
//			this.Object.Proveedor		[row] = ls_null
//			this.object.nom_proveedor	[row] = ls_null
//			this.setcolumn( "proveedor")
//			this.setfocus()
//			RETURN 1
//		END IF
//		
//		this.object.nom_proveedor [row] = ls_nombre
//		
//	CASE 'tipo_doc_int'
//		
//		SELECT desc_tipo_doc 
//			INTO :ls_desc 
//		FROM doc_tipo
//   	WHERE  tipo_doc = :data ;
//		
//		IF SQLCA.SQLCODE = 100 or SQLCA.SQLCode < 0 THEN
//			if SQLCA.SQLCOde = 100 then
//				Messagebox('Aviso','Tipo de Documento Interno no existe ')
//			else
//				MessageBox('Aviso', SQLCA.SQLErrText)
//			end if
//			this.Object.tipo_doc_int[row] = ls_null
//			this.setcolumn( "tipo_doc_int" )
//			this.setfocus()
//			RETURN 1
//		END IF
//		
//	CASE 'tipo_doc_ext'
//		
//		SELECT desc_tipo_doc 
//			INTO :ls_desc 
//		FROM doc_tipo
//   	WHERE  tipo_doc = :data ;
//		
//		IF SQLCA.SQLCODE = 100 or SQLCA.SQLCode < 0 THEN
//			if SQLCA.SQLCOde = 100 then
//				Messagebox('Aviso','Tipo de Documento Externo no existe ')
//			else
//				MessageBox('Aviso', SQLCA.SQLErrText)
//			end if
//			this.Object.tipo_doc_ext[row] = ls_null
//			this.setcolumn( "tipo_doc_ext" )
//			this.setfocus()
//			RETURN 1
//		END IF
//		
//END CHOOSE
//
end event

