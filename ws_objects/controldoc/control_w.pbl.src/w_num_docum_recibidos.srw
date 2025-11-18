$PBExportHeader$w_num_docum_recibidos.srw
forward
global type w_num_docum_recibidos from w_abc_master
end type
end forward

global type w_num_docum_recibidos from w_abc_master
integer width = 763
integer height = 648
string title = "Numeracion de Documentos Recibidos"
string menuname = "m_mantenimiento_sl"
end type
global w_num_docum_recibidos w_num_docum_recibidos

on w_num_docum_recibidos.create
call super::create
if this.MenuName = "m_mantenimiento_sl" then this.MenuID = create m_mantenimiento_sl
end on

on w_num_docum_recibidos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre;call super::ue_open_pre;idw_1.Retrieve( )

of_position_window(50,50)

end event

event ue_update;call super::ue_update;// Ancestor Script has been Override
Boolean  lbo_ok = TRUE
String	ls_msg

dw_master.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF ib_log THEN
	dw_master.of_create_log()
END IF

//Open(w_log)
//lds_log.RowsCopy(1, lds_log.RowCount(),Primary!,w_log.dw_log,1,Primary!)

IF	dw_master.ii_update = 1 THEN
	IF dw_master.Update() = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		MessageBox('Error en Base de Datos', 'No se pudo grabar Maestro')
	END IF
END IF

IF ib_log and lbo_ok THEN
	lbo_ok = dw_master.of_save_log()
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	idw_1.Retrieve()
	dw_master.ii_update 	= 0
	dw_master.il_totdel 	= 0
	dw_master.ii_protect = 0
	dw_master.of_protect( )
END IF


end event

event ue_update_pre;call super::ue_update_pre;ib_update_check = true

if f_row_processing( dw_master, 'tabular') = false then
	ib_update_check = false
	return
end if
end event

type dw_master from w_abc_master`dw_master within w_num_docum_recibidos
event ue_display ( string as_columna,  long al_row )
integer width = 709
integer height = 436
string dataobject = "d_num_doc_recibidos"
boolean vscrollbar = true
end type

event dw_master::ue_display(string as_columna, long al_row);boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_tflota, ls_prov
long 		ll_count

CHOOSE CASE upper(as_columna)
		
	CASE "COD_ORIGEN"
		ls_sql = "SELECT A.COD_ORIGEN AS CODIGO, " 	&
			    + "A.NOMBRE AS DESCRIPCION " 			&
				 + "FROM ORIGEN	 	A " 							
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		IF ls_codigo <> '' THEN
			This.object.cod_origen[al_row] = ls_codigo
			This.ii_update = 1
		END IF
		
END CHOOSE
end event

event dw_master::constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw

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

event dw_master::itemchanged;call super::itemchanged;string ls_flag, ls_data, ls_codigo, ls_prov, ls_null

SetNull(ls_null)
THIS.AcceptText()

IF row = 0 then
	RETURN
END IF

CHOOSE CASE upper(dwo.name)
	
	CASE "Origen"
		SELECT a.nombre
			INTO :ls_data
		FROM origen a;
		  
		IF SQLCA.SQLCode = 100 THEN
			Messagebox('Aviso', "Codigo de Origen no existe", StopSign!)
			this.object.cod_origen[row] = ls_Null
			this.object.nombre[row] 	 = ls_Null
			RETURN 1
		END IF
				
END CHOOSE
end event

