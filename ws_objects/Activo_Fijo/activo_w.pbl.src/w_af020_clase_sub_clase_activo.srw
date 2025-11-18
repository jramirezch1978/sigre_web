$PBExportHeader$w_af020_clase_sub_clase_activo.srw
forward
global type w_af020_clase_sub_clase_activo from w_abc_mastdet_smpl
end type
type dw_cuenta from u_dw_abc within w_af020_clase_sub_clase_activo
end type
end forward

global type w_af020_clase_sub_clase_activo from w_abc_mastdet_smpl
integer width = 2528
integer height = 2604
string title = "(AF020) Sub Clases de Activos"
string menuname = "m_master_simple"
long backcolor = 67108864
dw_cuenta dw_cuenta
end type
global w_af020_clase_sub_clase_activo w_af020_clase_sub_clase_activo

type variables
Integer ii_dw_upd
String      		is_tabla_c, is_colname_c[], is_coltype_c[]
end variables

on w_af020_clase_sub_clase_activo.create
int iCurrent
call super::create
if this.MenuName = "m_master_simple" then this.MenuID = create m_master_simple
this.dw_cuenta=create dw_cuenta
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_cuenta
end on

on w_af020_clase_sub_clase_activo.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_cuenta)
end on

event ue_open_pre;call super::ue_open_pre;ib_log = TRUE

dw_cuenta.SetTransObject(sqlca)
dw_cuenta.of_protect()

// Para el Log de Cuenta contable
is_tabla_c = dw_cuenta.Object.Datawindow.Table.UpdateTable

end event

event ue_print;call super::ue_print;idw_1.print()
end event

event ue_modify;call super::ue_modify;integer li_protect 

dw_cuenta.of_protect( )

li_protect = integer(dw_detail.Object.cnta_ctbl.Protect)
IF li_protect = 0 THEN
	dw_detail.Object.cnta_ctbl.Protect = 1
END IF

li_protect = integer(dw_detail.Object.cod_sub_clase.Protect)

IF li_protect = 0 THEN
	dw_detail.Object.cod_sub_clase.Protect = 1
END IF


	

end event

event ue_update_pre;call super::ue_update_pre;// Verifica que campos son requeridos y tengan valores
ib_update_check = FALSE

IF f_row_Processing( dw_master, "tabular") <> TRUE THEN RETURN
IF f_row_Processing( dw_detail, "tabular") <> TRUE THEN RETURN
IF f_row_Processing( dw_cuenta, "tabular") <> TRUE THEN RETURN

//Para la replicacion de datos
dw_master.of_set_flag_replicacion( )
dw_detail.of_set_flag_replicacion( )
dw_cuenta.of_set_flag_replicacion( )

// Si todo ha salido bien cambio el indicador ib_update_check a true, para indicarle
// al evento ue_update que todo ha salido bien

ib_update_check = TRUE


end event

event ue_insert;// Override Ancester
Long   ll_row_master, ll_row, ll_verifica, ll_row_sub_clase
String ls_cod_clase, ls_cod_sub_clase


dw_master.accepttext( ) //accepttext de los dwç
dw_detail.accepttext( )
dw_cuenta.accepttext( )

ll_row_master 		= dw_master.getrow( )
ll_row_sub_clase	= dw_detail.getrow( )

CHOOSE CASE idw_1
		
	CASE dw_master
		TriggerEvent ('ue_update_request') //verificar ii_update de los dw
	   	IF ib_update_check = FALSE THEN RETURN
	
	CASE dw_detail
		
		IF dw_master.GetRow() = 0 THEN
			MessageBox('Error', 'No puede insertar un detalle si no tiene cabecera', StopSign!)
			RETURN
		END IF
		
		ls_cod_clase = dw_master.Object.cod_clase	[ll_row_master]
	
		IF IsNull(ls_cod_clase) OR ls_cod_clase = '' THEN
			MessageBox('Aviso', 'INGRESE CLASE EN CABECERA, POR FAVOR VERIFIQUE', StopSign!)
			dw_master.setFocus()
			dw_master.setColumn('cod_clase')
			RETURN
		END IF
	
	CASE dw_cuenta
		IF dw_master.GetRow() = 0 THEN
			MessageBox('Error', 'No puede insertar un detalle si no tiene cabecera')
			RETURN
		END IF
		
		ls_cod_sub_clase = dw_detail.Object.cod_sub_clase[ll_row_sub_clase]
		
		IF IsNull(ls_cod_sub_clase) OR ls_cod_sub_clase = '' THEN
			MessageBox('Aviso', 'INGRESE SUB_CLASE EN CABECERA, POR FAVOR VERIFIQUE', StopSign!)
			dw_detail.setFocus()
			dw_detail.setColumn('cod_sub_clase')
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

event resize;// Override Ancester

dw_master.width  = newwidth  - dw_master.x - 10
dw_detail.width  = newwidth  - dw_detail.x - 10
dw_cuenta.width  = newwidth  - dw_cuenta.x - 10
dw_cuenta.height = newheight - dw_cuenta.y - 10
end event

event ue_update;// Override Ancester

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
	dw_cuenta.of_create_log()
END IF

IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_master.Update(true, false) = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion CLASE", ls_msg, StopSign!)
	END IF
END IF

IF dw_detail.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_detail.Update(true, false) = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion SUB_CLASE", ls_msg, StopSign!)
	END IF
END IF

IF dw_cuenta.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_cuenta.Update(true, false) = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion CUENTA_CONTABLE", ls_msg, StopSign!)
	END IF
END IF

IF ib_log THEN
	IF lbo_ok THEN
		lbo_ok = dw_master.of_save_log()
		lbo_ok = dw_detail.of_save_log()
		lbo_ok = dw_cuenta.of_save_log()
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0
	dw_detail.ii_update = 0
	dw_master.il_totdel = 0
	dw_detail.il_totdel = 0
	dw_cuenta.ii_update = 0
	dw_cuenta.il_totdel = 0
	
	dw_master.ii_protect = 0
	dw_detail.ii_protect = 0
	dw_cuenta.ii_protect = 0
	
	dw_master.of_protect ( )
	dw_detail.of_protect ( )
	dw_cuenta.of_protect ( )
	
	dw_master.ResetUpdate ( )
	dw_detail.ResetUpdate ( )
	dw_cuenta.ResetUpdate ( )
	
	f_mensaje("Grabación realizada satisfactoriamente", '')
END IF
end event

type dw_master from w_abc_mastdet_smpl`dw_master within w_af020_clase_sub_clase_activo
event ue_display ( string as_columna,  long al_row )
integer x = 0
integer y = 0
integer width = 2437
integer height = 916
string dataobject = "dw_clase_activo_tbl"
end type

event dw_master::ue_display(string as_columna, long al_row);boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_string, ls_evaluate, ls_expresion
long		ll_found
			
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
					
	CASE "cnta_ctbl"
		ls_sql = "select cnta_ctbl as codigo, " &
				  +"desc_cnta as descripcion  " &
				  +"from cntbl_cnta " &
				  +"where flag_estado = '1'"
				  
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		ls_expresion = "cnta_ctbl = '" + ls_codigo + "'"
		
		IF This.rowcount( ) > 1 THEN
			ll_found = This.Find(ls_expresion, 1, This.RowCount() - 1)	 
		END IF
		
		IF ll_found > 0 then
   		messagebox("Aviso","Ya existe registro, Verifique")
	//		This.object.cnta_ctbl[row] = ls_null
	//		This.object.nombre	[row]	= ls_null
			RETURN 
		END IF
		
		IF ls_codigo <> '' THEN
			This.object.cnta_ctbl[al_row] = ls_codigo
			This.object.nombre	[al_row] = ls_data
			This.ii_update = 1
		END IF
		
END CHOOSE

end event

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				 // columnas de lectrua de este dw
ii_dk[1] = 1             // colunmna de pase de parametros

ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ss = 1

end event

event dw_master::ue_output;call super::ue_output;if al_row = 0 then return

idw_det.retrieve(this.object.cod_clase [al_row])

if idw_det.RowCount() > 0 then
	idw_det.ScrollToRow(1)
	idw_det.SelectRow(0, false)
	idw_det.SelectRow(1, true)
	idw_det.setRow(1)
end if

end event

event dw_master::ue_retrieve_det_pos;call super::ue_retrieve_det_pos;idw_det.retrieve(aa_id[1])
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;This.object.flag_estado 			[al_row] = '1'
This.object.flag_depreciacion 	[al_row] = '1'
This.object.flag_indexacion 		[al_row] = '1'
end event

event dw_master::getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 				= THIS
idw_1.BorderStyle = StyleLowered!
end event

event dw_master::itemerror;call super::itemerror;RETURN 1
end event

event dw_master::doubleclicked;call super::doubleclicked;string ls_columna
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

event dw_master::itemchanged;call super::itemchanged;String 	ls_data, ls_null, ls_expresion
Long	 	ll_found

SetNull(ls_null)
This.Accepttext()

IF row <= 0 THEN RETURN

CHOOSE CASE dwo.name
	 CASE 'cnta_ctbl'
		
		ls_expresion = "cnta_ctbl = '" + data + "'"
		
		IF This.rowcount( ) > 1 THEN
			ll_found = This.Find(ls_expresion, 1, This.RowCount() - 1)	 
		END IF
		
		IF ll_found > 0 then
   		messagebox("Aviso","Ya existe registro, Verifique")
			This.object.cnta_ctbl[row] = ls_null
			This.object.nombre	[row]	= ls_null
			RETURN 1
			
		ELSE
			SELECT desc_cnta	
			 INTO :ls_data
			FROM cntbl_cnta	
			WHERE cnta_ctbl = :data;
			
			IF SQLCA.sqlcode = 100 THEN
				MessageBox('Aviso', 'LA CUENTA NO EXISTE O NO ESTA ACTIVO, POR FAVOR VERIFIQUE', StopSign!)
				This.object.cnta_ctbl[row] = ls_null
				This.object.nombre	[row]	= ls_null
				Return 1
			END IF
			
			This.object.nombre[row]	= ls_data
			
		END IF

END CHOOSE
end event

event dw_master::rowfocuschanged;call super::rowfocuschanged;//This.event ue_output(currentrow)
end event

type dw_detail from w_abc_mastdet_smpl`dw_detail within w_af020_clase_sub_clase_activo
integer x = 0
integer y = 924
integer width = 2446
integer height = 744
string dataobject = "dw_subclase_activo_tbl"
end type

event dw_detail::constructor;//Override Ancester

is_mastdet = 'dd'      // 'm' = master sin detalle (default), 'd' =  detalle,
                       // 'md' = master con detalle, 'dd' = detalle con detalle a la vez
							  
is_dwform = 'tabular'  // tabular, grid, form

//Forma parte del pK
ii_ck[1] = 1				// columnas de lectrua de este dw

//Variable de pase de Parametros
ii_rk	[1] = 6 	      // columnas que recibimos del master

ii_dk	[1] = 1 	      // columnas que se pasan al detalle


ii_ss = 1

idw_mst  = 	dw_master
idw_det  =  dw_cuenta

 
 
 

end event

event dw_detail::ue_insert_pre;call super::ue_insert_pre;// Validacion al ingresar un registro
This.object.cod_usr 		[al_row] = gs_user
This.object.flag_estado	[al_row] = '1'
end event

event dw_detail::getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event dw_detail::itemerror;call super::itemerror;RETURN 1
end event

event dw_detail::ue_output;call super::ue_output;if al_row = 0 then return

idw_det.retrieve(this.object.cod_sub_clase [al_row])

if idw_det.RowCount() > 0 then
	idw_det.ScrollToRow(1)
	idw_det.SelectRow(0, false)
	idw_det.SelectRow(1, true)
	idw_det.setRow(1)
end if

end event

type dw_cuenta from u_dw_abc within w_af020_clase_sub_clase_activo
event ue_display ( string as_columna,  long al_row )
integer y = 1692
integer width = 2441
integer height = 728
integer taborder = 20
boolean bringtotop = true
string dataobject = "dw_cuenta_clase_activo_tbl"
borderstyle borderstyle = styleraised!
end type

event ue_display;//as columna, al_row

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
	
	CASE 'calculo_tipo'
		ls_sql = "select calculo_tipo as codigo, " &
				  +"descripcion as nombre " &
				  +"from af_calculo_tipo"
		
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		IF ls_codigo <> '' THEN
			This.object.calculo_tipo[al_row] = ls_codigo
			This.object.nombre		[al_row] = ls_data
			This.ii_update = 1
		END IF
	
	CASE 'matriz'
		ls_sql = "select matriz as codigo, " &
				  +"descripcion as nombre " &
				  +"from matriz_cntbl_finan " &
				  +"where flag_estado = '1' " &
				  + "  and upper(matriz) like 'AF%'"
		
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		IF ls_codigo <> '' THEN
			this.object.matriz[al_row] = ls_codigo
			this.ii_update = 1
		END IF
	
	CASE 'matriz_veda'
		ls_sql ="select matriz as codigo, " &
				  +"descripcion as nombre " &
				  +"from matriz_cntbl_finan " &
				  +"where flag_estado = '1' " &
				  + "  and upper(matriz) like 'AF%'"
		
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		IF ls_codigo <> '' THEN
			this.object.matriz_veda[al_row] = ls_codigo
			this.ii_update = 1
		END IF

		
END CHOOSE

end event

event constructor;call super::constructor;
is_mastdet = 'd'			// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez

is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 1 				// indica si se usa seleccion: 1=individual (default), 0=multiple

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2

ii_rk[1] = 1 	      // columnas que recibimos del master


idw_mst  =  dw_detail

end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event itemerror;call super::itemerror;RETURN 1
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

event itemchanged;call super::itemchanged;String ls_data, ls_null
Long	 ll_count

SetNull(ls_null)
This.Accepttext()

IF row <= 0 THEN RETURN

CHOOSE CASE dwo.name
	 CASE 'calculo_tipo'
			SELECT descripcion	
			 INTO :ls_data
			FROM 	af_calculo_tipo	
			WHERE calculo_tipo = :data;
			
			IF SQLCA.sqlcode = 100 THEN
				MessageBox('Aviso', 'LA OPERACION NO EXISTE O NO ESTA ACTIVO, POR FAVOR VERIFIQUE', StopSign!)
				this.object.calculo_tipo[row] = ls_null
				this.object.nombre		[row]	= ls_null
				return 1
			END IF
			
			This.object.nombre[row]	= ls_data
		
	CASE 'matriz'
		SELECT count(matriz)
		  INTO :ll_count
		FROM   matriz_cntbl_finan
		WHERE  matriz = :data
		  AND  flag_estado = '1';
		
		IF ll_count = 0 THEN
			MessageBox('Aviso', 'LA MATRIZ NO EXISTE O NO ESTA ACTIVO, POR FAVOR VERIFIQUE', StopSign!)
			This.object.matriz[row] = ls_null
			RETURN 1
		END IF
	
	CASE 'matriz_veda'
		SELECT count(matriz)
		  INTO :ll_count
		FROM   matriz_cntbl_finan
		WHERE  matriz = :data
		  AND  flag_estado = '1';
		
		IF ll_count = 0 THEN
			MessageBox('Aviso', 'LA MATRIZ de VEDA NO EXISTE O NO ESTA ACTIVO, POR FAVOR VERIFIQUE', StopSign!)
			This.object.matriz_veda[row] = ls_null
			RETURN 1
		END IF
		

END CHOOSE
end event

event ue_insert_pre;call super::ue_insert_pre;if dw_detail.getRow() = 0 then return

this.object.flag_estado		[al_row] = '1'
this.object.cod_sub_clase	[al_row] = dw_detail.object.cod_sub_clase [dw_detail.getRow()]
end event

