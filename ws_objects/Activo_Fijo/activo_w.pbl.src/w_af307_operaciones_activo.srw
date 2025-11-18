$PBExportHeader$w_af307_operaciones_activo.srw
forward
global type w_af307_operaciones_activo from w_abc_mastdet_smpl
end type
type dw_mejoras_det from u_dw_abc within w_af307_operaciones_activo
end type
type st_1 from statictext within w_af307_operaciones_activo
end type
end forward

global type w_af307_operaciones_activo from w_abc_mastdet_smpl
integer width = 2674
integer height = 2348
string title = "(AF307)Operaciones de Activos"
string menuname = "m_master_simple"
boolean center = true
dw_mejoras_det dw_mejoras_det
st_1 st_1
end type
global w_af307_operaciones_activo w_af307_operaciones_activo

type variables
String      	is_tabla_md, is_colname_md[], is_coltype_md[]
end variables

forward prototypes
public function integer of_nro_item (datawindow adw_pd)
end prototypes

public function integer of_nro_item (datawindow adw_pd);integer li_item, li_x

li_item = 0

For li_x = 1 to adw_pd.RowCount()
	IF li_item < adw_pd.object.nro_item[li_x] THEN
		li_item = adw_pd.object.nro_item[li_x]
	END IF
Next

Return li_item + 1
end function

on w_af307_operaciones_activo.create
int iCurrent
call super::create
if this.MenuName = "m_master_simple" then this.MenuID = create m_master_simple
this.dw_mejoras_det=create dw_mejoras_det
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_mejoras_det
this.Control[iCurrent+2]=this.st_1
end on

on w_af307_operaciones_activo.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_mejoras_det)
destroy(this.st_1)
end on

event ue_open_pre;call super::ue_open_pre;
//dw_mejoras_det.SetTransObject(sqlca)
//dw_mejoras_det.of_protect()

// Para el Log de detalle de mejoras
ib_log = TRUE
//is_tabla_md = dw_mejoras_det.Object.Datawindow.Table.UpdateTable

end event

event resize;// Override Ancester

dw_master.width  = newwidth  - dw_master.x - 10
dw_detail.width  = newwidth  - dw_detail.x - 10
dw_mejoras_det.width  = newwidth  - dw_mejoras_det.x - 10
dw_mejoras_det.height = newheight - dw_mejoras_det.y - 20
end event

event ue_insert;// Ancester Override
Long  ll_row

//AccepTtext de los Dw

dw_detail.AcceptText		 ( )
dw_mejoras_det.Accepttext( )

IF dw_master.GetRow( ) = 0 THEN RETURN

CHOOSE CASE idw_1
		
	CASE dw_detail
			TriggerEvent ('ue_update_request') //verificar ii_update de los dw
	   	IF ib_update_check = FALSE THEN RETURN
			
			IF dw_master.GetRow() = 0 THEN
				MessageBox('Error', 'No puede insertar un detalle si no tiene cabecera')
				RETURN	
			END IF
	
	
	CASE dw_mejoras_det
			IF dw_detail.Getrow() = 0 THEN
				MessageBox('Error', 'No puede insertar un detalle si no tiene cabecera')
				RETURN	
			END IF
	CASE ELSE
			RETURN
		
END CHOOSE

// Inserta un registro en los DW seleccionados
ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN
	THIS.EVENT ue_insert_pos(ll_row)
end if

end event

event ue_update_request;call super::ue_update_request;Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
IF (dw_master.ii_update = 1 OR dw_detail.ii_update = 1 OR &
	 dw_mejoras_det.ii_update = 1) THEN
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	IF li_msg_result = 1 THEN
 		this.TriggerEvent("ue_update")
	ELSE
		dw_master.ii_update = 0
		dw_detail.ii_update = 0
		dw_mejoras_det.ii_update = 0
	END IF
END IF
end event

event ue_update_pre;call super::ue_update_pre;// Verifica que campos son requeridos y tengan valores
ib_update_check = FALSE

IF f_row_Processing( dw_detail, "tabular") <> TRUE THEN RETURN
IF f_row_Processing( dw_mejoras_det, "tabular") <> TRUE THEN RETURN

//Para la replicacion de datos
dw_detail.of_set_flag_replicacion()
dw_mejoras_det.of_set_flag_replicacion()

// Si todo ha salido bien cambio el indicador ib_update_check a true, para indicarle
// al evento ue_update que todo ha salido bien

ib_update_check = TRUE
end event

event ue_update;//Ancester Override 
Boolean lbo_ok = TRUE
String	ls_msg, ls_crlf

ls_crlf = char(13) + char(10)
dw_master.AcceptText()
dw_detail.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF ib_log THEN
	dw_detail.of_create_log()
END IF

//Open(w_log)
//lds_log.RowsCopy(1, lds_log.RowCount(),Primary!,w_log.dw_log,1,Primary!)


IF	dw_detail.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_detail.Update(true, false) = -1 then		// Grabacion del Master de Mejoras
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion Master de Mejoras", ls_msg, StopSign!)
	END IF
END IF

IF ib_log THEN
	IF lbo_ok THEN
		lbo_ok = dw_detail.of_save_log()
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_detail.ii_update 		 = 0
	dw_mejoras_det.ii_update = 0
	
	dw_detail.ii_protect 		= 0
	dw_mejoras_det.ii_protect  = 0
	dw_detail.of_protect		 ( )
	dw_mejoras_det.of_protect( )
	
	dw_master.il_totdel = 0
	dw_detail.il_totdel = 0
	
	dw_master.ResetUpdate()
	dw_detail.ResetUpdate()
	
	f_mensaje("Grabación realizado satisfactoriamente", "")
END IF


end event

event ue_open_pos;// Ancester Override
end event

type dw_master from w_abc_mastdet_smpl`dw_master within w_af307_operaciones_activo
integer x = 50
integer y = 112
integer width = 2560
integer height = 636
string dataobject = "dw_lista_maestro_tbl"
boolean vscrollbar = true
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
ii_dk[1] = 1 	      // columnas que se pasan al detalle

end event

event dw_master::ue_retrieve_det_pos;call super::ue_retrieve_det_pos;idw_det.retrieve(aa_id[1])
end event

event dw_master::ue_output;call super::ue_output;THIS.EVENT ue_retrieve_det(al_row)

idw_det.ScrollToRow(al_row)
end event

type dw_detail from w_abc_mastdet_smpl`dw_detail within w_af307_operaciones_activo
event ue_display ( string as_columna,  long al_row )
integer x = 50
integer y = 776
integer width = 2578
integer height = 732
string dataobject = "dw_abc_operaciones_activo_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_detail::ue_display(string as_columna, long al_row);//as columna, al_row

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
				  +"from af_calculo_tipo "
		
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		IF ls_codigo <> '' THEN
			This.object.calculo_tipo[al_row] = ls_codigo
			This.object.descripcion [al_row] = ls_data
			This.ii_update = 1
		END IF
	
	CASE 'cod_moneda'
		ls_sql = "select cod_moneda as codigo, " &
				  +"descripcion as nombre " &
				  +"from moneda "&
				  +"where flag_estado = '1'"
		
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		IF ls_codigo <> '' THEN
			This.object.cod_moneda[al_row] = ls_codigo
			This.ii_update = 1
		END IF
	
	CASE 'matriz_produc'
		ls_sql = "select matriz as codigo, " &
				  +"descripcion as nombre " &
				  +"from matriz_cntbl_finan " &
				  +"where flag_estado = '1'"
		
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		IF ls_codigo <> '' THEN
			this.object.matriz_produc[al_row] = ls_codigo
			this.ii_update = 1
		END IF
	
	CASE 'matriz_veda'
		ls_sql = "select matriz as codigo, " &
				  +"descripcion as nombre " &
				  +"from matriz_cntbl_finan " &
				  +"where flag_estado = '1'"
		
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		IF ls_codigo <> '' THEN
			this.object.matriz_veda[al_row] = ls_codigo
			this.ii_update = 1
		END IF
		
END CHOOSE

end event

event dw_detail::itemerror;call super::itemerror;RETURN 1

end event

event dw_detail::constructor;// Ancester Override
is_mastdet = 'dd'      // 'm' = master sin detalle (default), 'd' =  detalle,
                       // 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular' // tabular, grid, form
 

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2
ii_ck[2] = 4
ii_rk[1] = 1 	      // columnas que recibimos del master
ii_dk[1] = 1 	      // columnas que se pasan al detalle
ii_dk[2] = 2

ii_ss = 1

idw_mst  = dw_master
idw_det  = dw_mejoras_det

end event

event dw_detail::ue_insert_pre;call super::ue_insert_pre;
This.object.nro_item				[al_row] = of_nro_item(This)
This.object.cod_usr 				[al_row] = gs_user
This.object.flag_Estado 		[al_row] = '1'
This.object.fec_registro		[al_row] = f_fecha_actual()
This.object.flag_contabiliza	[al_row] = '1'
This.object.flag_deprecia		[al_row] = '1'

end event

event dw_detail::ue_retrieve_det_pos;call super::ue_retrieve_det_pos;idw_det.retrieve(aa_id[1],aa_id[2])
end event

event dw_detail::ue_output;call super::ue_output;THIS.EVENT ue_retrieve_det(al_row)

idw_det.ScrollToRow(al_row)
end event

event dw_detail::doubleclicked;call super::doubleclicked;string ls_columna
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

event dw_detail::itemchanged;call super::itemchanged;String ls_data, ls_null
Long   ll_count

SetNull(ls_null)
This.Accepttext()

IF row <= 0 THEN RETURN

CHOOSE CASE dwo.name
		
	CASE 'cod_moneda'
			SELECT count(cod_moneda)
			 INTO :ll_count
			FROM Moneda
			WHERE cod_moneda = :data
			  and flag_estado = '1';
			
			IF ll_count = 0 THEN
				MessageBox('Aviso', 'LA MONEDA NO EXISTE O NO ESTA ACTIVO, POR FAVOR VERIFIQUE', StopSign!)
				THIS.object.cod_moneda	[row] = ls_null
				RETURN 1
			END IF
			
	CASE 'calculo_tipo'
			SELECT descripcion	
			 INTO :ls_data
			FROM 	af_calculo_tipo	
			WHERE calculo_tipo = :data;
			
			IF SQLCA.sqlcode = 100 THEN
				MessageBox('Aviso', 'LA OPERACION NO EXISTE O NO ESTA ACTIVO, POR FAVOR VERIFIQUE', StopSign!)
				this.object.calculo_tipo[row] = ls_null
				this.object.descripcion	[row]	= ls_null
				return 1
			END IF
			
			This.object.descripcion[row]	= ls_data
		
	CASE 'matriz_produc'
		SELECT count(matriz)
		  INTO :ll_count
		FROM   matriz_cntbl_finan
		WHERE  matriz = :data
		  AND  flag_estado = '1';
		
		IF ll_count = 0 THEN
			MessageBox('Aviso', 'LA MATRIZ NO EXISTE O NO ESTA ACTIVO, POR FAVOR VERIFIQUE', StopSign!)
			This.object.matriz_produc[row] = ls_null
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

type dw_mejoras_det from u_dw_abc within w_af307_operaciones_activo
event ue_display ( string as_columna,  long al_row )
integer x = 59
integer y = 1528
integer width = 2560
integer height = 616
boolean bringtotop = true
string dataobject = "dw_abc_mejoras_det_activo_tbl"
boolean vscrollbar = true
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
	
	CASE 'calculo_tipo'
		ls_sql = "select calculo_tipo as codigo, " &
				  +"descripcion as nombre " &
				  +"from af_calculo_tipo"
		
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		IF ls_codigo <> '' THEN
			This.object.calculo_tipo[al_row] = ls_codigo
			This.object.descripcion	[al_row] = ls_data
			This.ii_update = 1
		END IF
	
END CHOOSE

end event

event constructor;call super::constructor;is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 1 				// indica si se usa seleccion: 1=individual (default), 0=multiple

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2
ii_ck[3] = 3

ii_rk[1] = 1 	      // columnas que recibimos del master
ii_rk[2] = 2

idw_mst  = 	dw_detail


end event

event itemerror;call super::itemerror;RETURN 1

end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event ue_insert_pre;call super::ue_insert_pre;
This.object.nro_item[al_row] = of_nro_item(This)
This.object.cod_usr [al_row] = gs_user

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


SetNull(ls_null)
This.Accepttext()

IF row <= 0 THEN RETURN

CHOOSE CASE dwo.name
	 CASE 'calculo_tipo'
			SELECT descripcion	
			 INTO :ls_data
			FROM af_calculo_tipo
			WHERE calculo_tipo = :data;
			
			IF SQLCA.sqlcode = 100 THEN
				MessageBox('Aviso', 'TIPO DE CALCULO NO EXISTE O NO ESTA ACTIVO, POR FAVOR VERIFIQUE', StopSign!)
				this.object.calculo_tipo[row] = ls_null
				this.object.descripcion	[row]	= ls_null
				return 1
			END IF
			
			this.object.descripcion[row]	= ls_data

END CHOOSE
end event

type st_1 from statictext within w_af307_operaciones_activo
integer x = 50
integer y = 44
integer width = 2560
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 10789024
string text = "LISTADO DE ACTIVOS"
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

