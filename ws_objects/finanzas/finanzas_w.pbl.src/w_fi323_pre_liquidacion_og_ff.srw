$PBExportHeader$w_fi323_pre_liquidacion_og_ff.srw
forward
global type w_fi323_pre_liquidacion_og_ff from w_abc
end type
type cb_1 from commandbutton within w_fi323_pre_liquidacion_og_ff
end type
type dw_detail from u_dw_abc within w_fi323_pre_liquidacion_og_ff
end type
type dw_master from u_dw_abc within w_fi323_pre_liquidacion_og_ff
end type
end forward

global type w_fi323_pre_liquidacion_og_ff from w_abc
integer width = 3749
integer height = 2136
string title = "Liquidacion Fondo Fijo / Orden de Giro (FI323)"
string menuname = "m_mantenimiento_cl_print"
cb_1 cb_1
dw_detail dw_detail
dw_master dw_master
end type
global w_fi323_pre_liquidacion_og_ff w_fi323_pre_liquidacion_og_ff

type variables
Decimal 	idc_porct_ret

end variables

forward prototypes
public subroutine wf_verifica_monto_doc (string as_cod_relacion, string as_origen, string as_nro_solicitud, string as_tip_doc, string as_nro_doc, decimal adc_importe, string as_accion, ref string as_flag_estado)
public subroutine wf_recupera_detalle ()
end prototypes

public subroutine wf_verifica_monto_doc (string as_cod_relacion, string as_origen, string as_nro_solicitud, string as_tip_doc, string as_nro_doc, decimal adc_importe, string as_accion, ref string as_flag_estado);DECLARE PB_USP_FIN_INS_DOC_A_PAGAR_LIQ PROCEDURE FOR USP_FIN_INS_DOC_A_PAGAR_LIQ
(:as_cod_relacion,:as_origen,:as_nro_solicitud,:as_tip_doc,:as_nro_doc,:adc_importe,:as_accion);
EXECUTE PB_USP_FIN_INS_DOC_A_PAGAR_LIQ ;



IF SQLCA.SQLCode = -1 THEN 
	MessageBox("SQL error", SQLCA.SQLErrText)
END IF

FETCH PB_USP_FIN_INS_DOC_A_PAGAR_LIQ INTO :as_flag_estado ;
CLOSE PB_USP_FIN_INS_DOC_A_PAGAR_LIQ ;
end subroutine

public subroutine wf_recupera_detalle ();String ls_origen,ls_nro_solicitud,ls_cod_moneda
Long   ll_inicio

ls_origen 		  = dw_master.object.origen 	 	  [1] 
ls_nro_solicitud = dw_master.object.nro_solicitud [1] 

dw_detail.retrieve(ls_origen,ls_nro_solicitud)

//actualizar moneda cabecera en detalle
IF dw_master.Rowcount() > 0 THEN
	ls_cod_moneda = dw_master.object.cod_moneda [dw_master.Getrow()]
	For ll_inicio = 1 TO dw_detail.Rowcount()
		 dw_detail.object.cod_moneda_cab [ll_inicio] = ls_cod_moneda
	Next
END IF


end subroutine

on w_fi323_pre_liquidacion_og_ff.create
int iCurrent
call super::create
if this.MenuName = "m_mantenimiento_cl_print" then this.MenuID = create m_mantenimiento_cl_print
this.cb_1=create cb_1
this.dw_detail=create dw_detail
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.dw_detail
this.Control[iCurrent+3]=this.dw_master
end on

on w_fi323_pre_liquidacion_og_ff.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.dw_detail)
destroy(this.dw_master)
end on

event ue_open_pre;call super::ue_open_pre;dw_master.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos
dw_detail.SetTransObject(sqlca)

idw_1 = dw_master              				// asignar dw corriente
dw_detail.BorderStyle = StyleRaised!			// indicar dw_detail como no activado

of_position_window(0,0)       			// Posicionar la ventana en forma fija


//parametros

select porc_ret_igv into :idc_porct_ret from finparam where reckey = '1' ;
end event

event ue_insert;//override
end event

event ue_retrieve_list;call super::ue_retrieve_list;// Asigna valores a structura 
Long   ll_row,ll_inicio
String ls_cod_moneda
str_parametros sl_param

TriggerEvent ('ue_update_request')		

sl_param.dw1    = 'd_abc_lista_og_ff_pre_liq_tbl'
sl_param.titulo = 'Orden de Giro (Pre - Liquidación)'
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2


OpenWithParm( w_lista, sl_param)

sl_param = Message.PowerObjectParm
IF sl_param.titulo <> 'n' THEN
	dw_master.retrieve(sl_param.field_ret[1],sl_param.field_ret[2])
	dw_detail.retrieve(sl_param.field_ret[1],sl_param.field_ret[2])

	//actualizar moneda cabecera en detalle
	IF dw_master.Rowcount() > 0 THEN
		ls_cod_moneda = dw_master.object.cod_moneda [dw_master.Getrow()]
		For ll_inicio = 1 TO dw_detail.Rowcount()
			 dw_detail.object.cod_moneda_cab [ll_inicio] = ls_cod_moneda
		Next
	END IF

	dw_master.ii_update = 0
	dw_detail.ii_update = 0
	
	TriggerEvent ('ue_modify')
	
END IF

end event

event resize;call super::resize;dw_detail.width  = newwidth  - dw_detail.x - 40
dw_detail.height = newheight - dw_detail.y - 150

end event

event ue_modify;call super::ue_modify;String ls_flag_estado
Long   ll_row


ll_row = dw_master.Getrow()

IF ll_row = 0 THEN RETURN

ls_flag_estado = dw_master.object.flag_estado [ll_row]

IF ls_flag_estado = '5' THEN
	dw_master.ii_protect = 0
	dw_detail.ii_protect	= 0
	dw_master.of_protect()
	dw_detail.of_protect()
	
	cb_1.Enabled = FALSE
ELSE	
	cb_1.Enabled = TRUE

	dw_detail.of_protect()
	
END IF


end event

event ue_delete;//override
Long   ll_row,ll_row_master
String ls_flag_estado

ll_row_master = dw_master.Getrow()

IF ll_row_master = 0 OR idw_1 = dw_master THEN RETURN

ls_flag_estado = dw_master.object.flag_estado [ll_row_master]





IF ls_flag_estado = '5' THEN
	Messagebox('Aviso','No se puede Eliminar Items Liquidacion ya ha sido cerrada , Verifique!')
	Return
END IF

ll_row = idw_1.Event ue_delete()

IF ll_row = 1 THEN
	THIS.Event ue_delete_list()
	THIS.Event ue_delete_pos(ll_row)
END IF

end event

event ue_update;call super::ue_update;Boolean lbo_ok = TRUE

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
    	Rollback ;
		messagebox("Error en Grabacion Master","Se ha procedido al rollback",exclamation!)
	END IF
END IF


IF dw_detail.ii_update = 1 THEN
	IF dw_detail.Update(TRUE, FALSE) = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
    	Rollback ;
		messagebox("Error en Grabacion Detalle","Se ha procedido al rollback",exclamation!)
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
	
	dw_master.ResetUpdate()
	dw_detail.ResetUpdate()
	
	//RECUPERA INFORMACION
	wf_recupera_detalle()
	
	f_mensaje('Grabación realizada satisfactoriamente', '')
	

END IF

end event

event ue_update_request;call super::ue_update_request;Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
IF (dw_master.ii_update = 1 OR dw_detail.ii_update = 1) THEN
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	IF li_msg_result = 1 THEN
 		this.TriggerEvent("ue_update")
	ELSE
		dw_master.ii_update = 0
		dw_detail.ii_update = 0
	END IF
END IF

end event

event ue_update_pre;call super::ue_update_pre;String ls_flag_estado
Long   ll_row_master,ll_inicio,ll_item
Decimal {2} ldc_importe
dwItemStatus ldis_status

ll_row_master = dw_master.Getrow()

IF ll_row_master = 0 THEN
	Messagebox('Aviso','No Existe Solicitud de Giro , Verifique!')
	ib_update_check = FALSE							
	Return
END IF


ls_flag_estado = dw_master.object.flag_estado [ll_row_master]



IF ls_flag_estado = '5' THEN
	Messagebox('Aviso','Orden de Giro se Encuentra Cerrada , Verifique!')
	ib_update_check = FALSE							
	Return
END IF	



IF dw_detail.Rowcount() > 0 THEN  //VERIFICO SI EXISTE REGISTROS EN DETALLE
	dw_master.object.flag_estado [1] = '4' //liquidacion parcial
	dw_master.ii_update = 1
ELSE
	dw_master.object.flag_estado [1] = '3' //OG PAGADA
	dw_master.ii_update = 1
END IF	



For ll_inicio = 1 TO dw_detail.Rowcount()
	 ll_item     = dw_detail.object.item    [ll_inicio]
	 ldc_importe = dw_detail.object.importe [ll_inicio]	 
	 
	 //asignar nro de solicitud cuando registro sea nuevo
	 ldis_status = dw_detail.GetItemStatus(ll_inicio,0,Primary!)

	 IF ldis_status = NewModified! THEN
		 dw_detail.object.origen        [ll_inicio] = dw_master.object.origen 		  [ll_row_master]
		 dw_detail.object.nro_solicitud [ll_inicio] = dw_master.object.nro_solicitud [ll_row_master]
	 END IF

	 
	 
	 IF Isnull(ldc_importe) OR ldc_importe = 0.00 THEN
		 Messagebox('Aviso','Debe Ingresar Importe Mayor a 0.00 de Item '+Trim(String(ll_item))+' , Verifique!')
		 dw_detail.SetFocus()
		 dw_detail.Setrow(ll_inicio)
		 dw_detail.SetColumn('importe')
	 	 ib_update_check = FALSE									 
		 Return
	 END IF
Next


/*Replicacion*/
dw_master.of_set_flag_replicacion ()
dw_detail.of_set_flag_replicacion ()

end event

event ue_print;call super::ue_print;String  ls_cod_origen,ls_nro_sol,ls_flag_estado
Str_cns_pop lstr_cns_pop

//Verificacion de nro de solicitud
ls_cod_origen  = dw_master.object.origen 			[1]
ls_nro_sol     = dw_master.object.nro_solicitud [1]
ls_flag_estado = dw_master.object.flag_estado	[1]


IF dw_master.ii_update = 1 OR dw_detail.ii_update = 1 THEN
	Messagebox('Aviso','Existe Modificaciones Pendientes, Por Favor Verifique!')
	Return
END IF
	
IF Not(ls_flag_estado = '4' or ls_flag_estado = '5') THEN
	Messagebox('Aviso','Documento No Ha sido Liquidado , Verifique!')
	Return
END IF

lstr_cns_pop.arg[1] = ls_cod_origen
lstr_cns_pop.arg[2] = ls_nro_sol


OpenSheetWithParm(w_fi323_pre_liq_og_rpt, lstr_cns_pop, this, 2, Layered!)
end event

type cb_1 from commandbutton within w_fi323_pre_liquidacion_og_ff
integer x = 3255
integer y = 24
integer width = 407
integer height = 112
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Referencias"
end type

event clicked;String ls_cod_relacion,ls_cod_moneda
Long   ll_row_master
str_parametros sl_param

ll_row_master = dw_master.getrow()

IF ll_row_master = 0 THEN RETURN

ls_cod_relacion = dw_master.Object.cod_relacion [ll_row_master]
ls_cod_moneda	 = dw_master.Object.cod_moneda   [ll_row_master]

IF Isnull(ls_cod_relacion) OR Trim(ls_cod_relacion) = '' THEN
	Messagebox('Debe Ingresar Un Codigo de Proveedor ','Verifique!')
	RETURN
END IF	



sl_param.string3 = ls_cod_relacion

OpenWithParm(w_pop_help_edirecto,sl_param)

//* Check text returned in Message object//
IF isvalid(message.PowerObjectParm) THEN
	sl_param = message.PowerObjectParm
END IF
//**//

sl_param.string1 = sl_param.string3


sl_param.dw1	  = 'd_doc_pendientes_x_pagar_tbl'
sl_param.titulo  = 'Documentos Pendientes'
sl_param.string2 = ls_cod_moneda
sl_param.tipo	  = '1POG' 			                 //pre liquidacion orden giro
sl_param.opcion  = 8 
sl_param.db1 	  = 1500
sl_param.dw_m	  = dw_detail

OpenWithParm( w_abc_seleccion_lista, sl_param)

IF isvalid(message.PowerObjectParm) THEN sl_param = message.PowerObjectParm			
IF sl_param.bret  THEN
	dw_detail.ii_update = 1
END IF
end event

type dw_detail from u_dw_abc within w_fi323_pre_liquidacion_og_ff
integer y = 884
integer width = 3675
integer height = 1012
integer taborder = 20
string dataobject = "d_abc_det_pre_liq_tbl"
end type

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)




ii_ck[1] = 1			// columnas de lectura de este dw
ii_ck[2] = 2
ii_rk[1] = 1 	      // columnas que recibimos del master
ii_rk[2] = 2


idw_mst = dw_master
idw_det = dw_detail
end event

event itemchanged;call super::itemchanged;String ls_accion,ls_origen,ls_cod_relacion,ls_tip_doc_ref,ls_nro_doc_ref,&
		 ls_flag_estado,ls_nro_solicitud,ls_cod_moneda,ls_null
Long 	 ll_count
Decimal {2} ldc_importe,ldc_imp_ret
Decimal {3} ldc_tasa_cambio
dwItemStatus ldis_status

Accepttext ()

SetNull(ls_null)

choose case dwo.name
	case	'flag_ret_igv'
		if data = '1' then
			//porcentaje de retencion y en soles
			ls_cod_moneda   = this.object.cod_moneda  [row]
			ldc_importe   	 = this.object.importe 	   [row]
			ldc_tasa_cambio = this.object.tasa_cambio [row]
		
			if isnull(ldc_importe) then ldc_importe = 0.00
		
			if ls_cod_moneda = gnvo_app.is_soles then
				ldc_imp_ret = (ldc_importe * idc_porct_ret) / 100
			elseif ls_cod_moneda = gnvo_app.is_dolares then
				ldc_importe = Round(ldc_importe * ldc_tasa_cambio,2)
				ldc_imp_ret = (ldc_importe * idc_porct_ret) / 100
			end if
			
		elseif data = '0' then
			ldc_imp_ret = 0.00
			this.object.nro_retencion [row] = ls_null
		end if
		
		this.object.importe_ret_igv [row] = ldc_imp_ret
	
	
	
	case 'confin'
		select Count(*)
		  into :ll_count
		  from concepto_financiero
		 where (confin = :data) ;
		 
		IF ll_count = 0 THEN
			Messagebox('Aviso','No Existe Concepto Financiero ,Verifique!')
			RETURN 1
		END IF
	
	case	'importe'
	
		/*verifica importe*/
		ldis_status = this.GetItemStatus(row,0,Primary!)				
		
		IF ldis_status = NewModified! THEN
			ls_accion = 'new'
		ELSE	
			ls_accion = 'fileopen'					
		END IF
		
		//verifica monto de documento
		ls_origen		  = dw_master.object.origen	     [dw_master.getrow()]
		ls_nro_solicitud = dw_master.object.nro_solicitud [dw_master.getrow()]
		ls_cod_relacion  = this.object.proveedor	  [row]				
		ls_tip_doc_ref	  = this.object.tipo_doc     [row]
		ls_nro_doc_ref	  = this.object.nro_doc      [row]
		ldc_importe		  = this.object.importe      [row]
		
		
		wf_verifica_monto_doc(ls_cod_relacion,ls_origen,ls_nro_solicitud,ls_tip_doc_ref,ls_nro_doc_ref,ldc_importe,ls_accion,ls_flag_estado)
		
		if Trim(ls_flag_estado) = '1' then
			Messagebox('Aviso','Importe se ha excedido, Verifique')
			this.object.importe 		 [row] = 0.00
			Return 1
		end if

end choose

end event

event itemerror;call super::itemerror;Return 1
end event

event rowfocuschanged;call super::rowfocuschanged;This.SelectRow(0, False)
This.SelectRow(currentrow, True)
end event

event ue_display;call super::ue_display;String 		    ls_name,ls_prot
str_parametros   lstr_param


CHOOSE CASE lower(as_columna)
		 CASE 'confin'

		lstr_param.tipo			= 'ARRAY'
		lstr_param.opcion			= 3
		lstr_param.str_array[1] = '8'
		lstr_param.str_array[2] = '4'
		lstr_param.titulo 		= 'Selección de Concepto Financiero'
		lstr_param.dw_master		= 'd_lista_grupo_financiero_filtro_grd'     //Filtrado para cierto grupo
		lstr_param.dw1				= 'd_lista_concepto_financiero_filtro_grd'
		lstr_param.dw_m			=  This
		
		OpenWithParm( w_abc_seleccion_md, lstr_param)
		IF isvalid(message.PowerObjectParm) THEN lstr_param = message.PowerObjectParm			
		IF lstr_param.titulo = 's' THEN
			this.ii_update = 1
		END IF


END CHOOSE
end event

event doubleclicked;call super::doubleclicked;
string ls_columna, ls_string, ls_evaluate

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

type dw_master from u_dw_abc within w_fi323_pre_liquidacion_og_ff
integer width = 2190
integer height = 864
string dataobject = "d_abc_pre_liq_ff_og_tbl"
boolean hscrollbar = false
boolean vscrollbar = false
boolean border = false
borderstyle borderstyle = stylebox!
end type

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;is_mastdet = 'md'		// 'm' = master sin detalle (default), 'd' =  detalle,
                    	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez





ii_ck[1] = 1			// columnas de lectura de este dw
ii_ck[2] = 2

ii_dk[1] = 1 	      // columnas que se pasan al detalle
ii_dk[2] = 2

idw_mst = dw_master
idw_det = dw_detail
end event

