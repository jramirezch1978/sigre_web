$PBExportHeader$w_fi337_letras_x_cobrar_canje.srw
forward
global type w_fi337_letras_x_cobrar_canje from w_abc
end type
type cb_temporal from commandbutton within w_fi337_letras_x_cobrar_canje
end type
type cb_2 from commandbutton within w_fi337_letras_x_cobrar_canje
end type
type cb_1 from commandbutton within w_fi337_letras_x_cobrar_canje
end type
type tab_1 from tab within w_fi337_letras_x_cobrar_canje
end type
type tabpage_1 from userobject within tab_1
end type
type dw_detail from u_dw_abc within tabpage_1
end type
type tabpage_1 from userobject within tab_1
dw_detail dw_detail
end type
type tabpage_2 from userobject within tab_1
end type
type dw_asiento_det from u_dw_abc within tabpage_2
end type
type dw_asiento_cab from u_dw_abc within tabpage_2
end type
type tabpage_2 from userobject within tab_1
dw_asiento_det dw_asiento_det
dw_asiento_cab dw_asiento_cab
end type
type tab_1 from tab within w_fi337_letras_x_cobrar_canje
tabpage_1 tabpage_1
tabpage_2 tabpage_2
end type
type dw_master from u_dw_abc within w_fi337_letras_x_cobrar_canje
end type
end forward

global type w_fi337_letras_x_cobrar_canje from w_abc
integer width = 4151
integer height = 2264
string title = "[FI337] Canje / Renovación de Letras por Cobrar"
string menuname = "m_mantenimiento_cl_anular"
event ue_anular ( )
event ue_print_voucher ( )
cb_temporal cb_temporal
cb_2 cb_2
cb_1 cb_1
tab_1 tab_1
dw_master dw_master
end type
global w_fi337_letras_x_cobrar_canje w_fi337_letras_x_cobrar_canje

type variables
String 		is_doc_ltc, is_salir, is_confin_ltc, is_desc_confin
Boolean 		ib_estado_preas = FALSE

n_cst_asiento_contable	invo_asiento_cntbl
u_dw_abc						idw_detail, idw_asiento_cab, idw_asiento_det
nvo_numeradores			invo_numerador
u_ds_base 					ids_voucher
end variables

forward prototypes
public subroutine wf_update_moneda_cab_det (string as_cod_moneda_cab)
public function decimal wf_calcular_total ()
public subroutine wf_update_tcambio_det (decimal adc_tasa_cambio)
public subroutine wf_delete_doc_referencias ()
public function boolean wf_verifica_flag_cntas (string as_cta_cntbl, string as_tipo_doc, string as_nro_doc, string as_cod_relacion, long al_row)
public function integer of_get_param ()
public subroutine of_asigna_dws ()
public function boolean of_generacion_asiento ()
end prototypes

event ue_anular;String  ls_flag_estado,ls_nro_certif
Long    ll_row        ,ll_inicio    ,ll_count
Integer li_opcion

dw_master.accepttext()

ll_row = dw_master.Getrow()


IF ll_row = 0 THEN 
	Messagebox('Aviso','No Existe Registro que Anular , Verifique!')
	RETURN
END IF	

ls_flag_estado = dw_master.object.flag_estado     [ll_row]


IF ls_flag_estado <> '1' THEN 
	Messagebox('Aviso','Estado Del Documento no Permitira Anular ')
	RETURN
END IF	

IF (dw_master.ii_update = 1                  OR tab_1.tabpage_1.dw_detail.ii_update      = 1 OR &
    tab_1.tabpage_2.dw_asiento_cab.ii_update = 1 OR tab_1.tabpage_2.dw_asiento_det.ii_update = 1 ) THEN
	 Messagebox('Aviso','Grabe Los Cambios Antes de Anular el Documento')
	 RETURN
END IF	 

//------------------------------------------------
li_opcion = MessageBox('Anula Letras x Cobrar','Esta Seguro de Anular este Documento',Question!, Yesno!, 2)
IF li_opcion = 2 THEN RETURN
//------------------------------------------------


dw_master.deleterow(ll_row)


tab_1.tabpage_2.dw_asiento_cab.object.flag_estado [1] = '0' //asiento anulado

FOR ll_inicio = 1 TO tab_1.tabpage_2.dw_asiento_det.Rowcount()
	 tab_1.tabpage_2.dw_asiento_det.object.imp_movsol [ll_inicio] = 0.00
	 tab_1.tabpage_2.dw_asiento_det.object.imp_movdol [ll_inicio] = 0.00
NEXT

//eliminar el detalle
wf_delete_doc_referencias ()


dw_master.ii_update = 1
tab_1.tabpage_2.dw_asiento_cab.ii_update     = 1
tab_1.tabpage_2.dw_asiento_det.ii_update = 1



is_Action = 'delete'

TriggerEvent('ue_modify')
/*No Generación Asientos*/
ib_estado_preas = FALSE
/**/		

end event

event ue_print_voucher();String ls_origen
Long   ll_ano,ll_mes,ll_nro_libro,ll_nro_asiento
str_parametros lstr_param

IF dw_master.getrow() = 0 THEN
	Messagebox('Aviso','No existe Registro Verifique!')
	Return
END IF

Open(w_print_preview)
lstr_param = Message.PowerObjectParm

if lstr_param.i_return < 0 then return


ls_origen 		= dw_master.object.origen 	    [dw_master.getrow()]
ll_ano			= dw_master.object.ano	  	    [dw_master.getrow()]
ll_mes			= dw_master.object.mes	  	    [dw_master.getrow()]
ll_nro_libro	= dw_master.object.nro_libro   [dw_master.getrow()]
ll_nro_asiento	= dw_master.object.nro_asiento [dw_master.getrow()]

if lstr_param.i_return = 1 then
	
	ids_voucher.retrieve(ls_origen,ll_ano,ll_mes,ll_nro_libro,ll_nro_asiento,gs_empresa)

	ids_voucher.Object.p_logo.filename = gs_logo
	
	if ids_voucher.rowcount() = 0 then 
		f_mensaje('Voucher no tiene registro Verifique', 'FIN_304_02')
		return
	end if
	
	
	ids_voucher.Print(True)

else
	lstr_param.dw1 		= 'd_rpt_voucher_imp_cc_tbl'
	lstr_param.titulo 	= 'Previo de Voucher'
	lstr_param.string1 	= ls_origen
	lstr_param.integer1 	= ll_ano
	lstr_param.integer2 	= ll_mes
	lstr_param.integer3 	= ll_nro_libro
	lstr_param.integer4 	= ll_nro_asiento
	lstr_param.string2	= gs_empresa
	lstr_param.titulo		= "Provisión de Canje de Documentos x Pagar"
	lstr_param.tipo		= '1S1I2I3I4I2S'
	

	OpenSheetWithParm(w_rpt_preview, lstr_param, w_main, 0, Layered!)
end if



end event

public subroutine wf_update_moneda_cab_det (string as_cod_moneda_cab);Long ll_inicio

for ll_inicio = 1 to tab_1.tabpage_1.dw_detail.Rowcount()

	 tab_1.tabpage_1.dw_detail.object.cod_moneda_cab [ll_inicio] = as_cod_moneda_cab
next


end subroutine

public function decimal wf_calcular_total ();String ls_cod_moneda,ls_soles,ls_dolares
Long   ll_inicio,ll_factor,ll_row_master
Decimal {2} ldc_monto_conv,ldc_importe_total
Decimal {3} ldc_tasa_cambio

dw_master.Accepttext()
tab_1.tabpage_1.dw_detail.Accepttext()


//Datos de Cabecera
ll_row_master = dw_master.Getrow()
ldc_tasa_cambio = dw_master.object.tasa_cambio [ll_row_master]
ls_cod_moneda   = dw_master.object.cod_moneda  [ll_row_master]


f_monedas(ls_soles,ls_dolares)

ldc_importe_total = 0.00

FOR ll_inicio = 1 TO tab_1.tabpage_1.dw_detail.Rowcount()
	 ldc_monto_conv = tab_1.tabpage_1.dw_detail.object.monto_conv  [ll_inicio]	
	 ll_factor		 = tab_1.tabpage_1.dw_detail.object.factor      [ll_inicio]	
	 
	 
	 IF Isnull(ldc_monto_conv) THEN ldc_monto_conv = 0.00 
	 IF Isnull(ll_factor)      THEN ll_factor      = 0.00 

	 
	 ldc_importe_total = ldc_importe_total + (ldc_monto_conv * ll_factor)

	 
	 
NEXT				

Return ldc_importe_total
end function

public subroutine wf_update_tcambio_det (decimal adc_tasa_cambio);Long ll_inicio

for ll_inicio = 1 to tab_1.tabpage_1.dw_detail.Rowcount()

	 tab_1.tabpage_1.dw_detail.object.tasa_cambio [ll_inicio] = adc_tasa_cambio
	 tab_1.tabpage_1.dw_detail.ii_update = 1
next



end subroutine

public subroutine wf_delete_doc_referencias ();tab_1.tabpage_1.dw_detail.Accepttext()

DO WHILE tab_1.tabpage_1.dw_detail.Rowcount() > 0
	tab_1.tabpage_1.dw_detail.TriggerEvent('ue_delete')
LOOP


end subroutine

public function boolean wf_verifica_flag_cntas (string as_cta_cntbl, string as_tipo_doc, string as_nro_doc, string as_cod_relacion, long al_row);String  ls_flag_ctabco,ls_flag_cencos,ls_flag_doc_ref,ls_flag_cod_rel,&
		  ls_tipo_doc_ref,ls_nro_doc_ref,ls_cod_relacion,ls_flag_cebef
Boolean lb_retorno = TRUE


IF f_cntbl_cnta(as_cta_cntbl,ls_flag_ctabco,ls_flag_cencos,ls_flag_doc_ref, &
					 ls_flag_cod_rel,ls_flag_cebef)  THEN


	IF ls_flag_doc_ref = '1' THEN
		ls_tipo_doc_ref =	tab_1.tabpage_2.dw_asiento_det.object.tipo_docref1 [al_row]
		ls_nro_doc_ref  = tab_1.tabpage_2.dw_asiento_det.object.nro_docref1  [al_row]
		
		/*Verifico tipo de Documento*/
		IF Isnull(ls_tipo_doc_ref) OR Trim(ls_tipo_doc_ref) = '' THEN
			tab_1.tabpage_2.dw_asiento_det.object.tipo_docref1 [al_row] = as_tipo_doc
		END IF			
		/*Verifico Nro de Documento*/
		IF Isnull(ls_nro_doc_ref) OR Trim(ls_nro_doc_ref) = '' THEN
			tab_1.tabpage_2.dw_asiento_det.object.nro_docref1  [al_row] = as_nro_doc
		END IF
	ELSE
		SetNull(ls_tipo_doc_ref)
		SetNull(ls_nro_doc_ref)
		tab_1.tabpage_2.dw_asiento_det.object.tipo_docref1 [al_row] = ls_tipo_doc_ref
		tab_1.tabpage_2.dw_asiento_det.object.nro_docref1  [al_row] = ls_nro_doc_ref
	END IF

	IF ls_flag_cod_rel = '1' THEN
		ls_cod_relacion = tab_1.tabpage_2.dw_asiento_det.object.cod_relacion [al_row]
		/*Verifico Codigo de Relacion*/	
		IF Isnull(ls_cod_relacion) OR Trim(ls_cod_relacion) = '' THEN
			tab_1.tabpage_2.dw_asiento_det.object.cod_relacion [al_row] = as_cod_relacion
		END IF
	ELSE
		SetNull(ls_cod_relacion)
		tab_1.tabpage_2.dw_asiento_det.object.cod_relacion [al_row] = ls_cod_relacion
	END IF	

ELSE
   lb_retorno = FALSE
END IF

///**/
Return lb_retorno
end function

public function integer of_get_param ();/*recupero doc.letra x pagar*/
String ls_mensaje

try 
	select doc_letra_cobrar
		into :is_doc_ltc
	from finparam 
	where reckey = '1' ;
	
	if sqlca.sqlcode = 100 then
		Messagebox( "Error", "no ha definido parametros en finparam")
		return 0
	end if
	
	if sqlca.sqlcode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		Messagebox( "Error", "Error en consulta en tabla FINPARAM. Mensaje: " + ls_mensaje, StopSign!)
		return 0
	end if
	
	is_confin_ltc = gnvo_app.of_get_parametro("CONFIN_LTC_DEFAULT", "LTC-001")
	
	// busca doc. prog. compras
	if ISNULL( is_doc_ltc ) or TRIM( is_doc_ltc ) = '' then
		Messagebox("Error", "Defina documento Letra x Cobrar en finparam")
		return 0
	end if
	
	select descripcion
		into :is_desc_confin
	from concepto_financiero
	where confin 		= :is_confin_ltc
	  and flag_estado	= '1';
	
	if SQLCA.SQLCode = 100 then
		rollback;
		MessageBox('Error', 'El Concepto Financiero ' + is_confin_ltc + ' no existe o no se encuentra activo, por favor verifique!', StopSign!)
		return 0
	end if
	
	if sqlca.sqlcode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		Messagebox( "Error", "Error en consulta en tabla CONCEPTO_FINANCIERO. Mensaje: " + ls_mensaje, StopSign!)
		return 0
	end if

	
	return 1

catch ( Exception ex )
	gnvo_app.of_catch_exception(ex, 'Error en función of_Get_param()')
	
	return 0
	
end try


end function

public subroutine of_asigna_dws ();idw_Detail 			= tab_1.tabpage_1.dw_detail
idw_asiento_det 	= tab_1.tabpage_2.dw_asiento_det
idw_asiento_cab 	= tab_1.tabpage_2.dw_asiento_cab

end subroutine

public function boolean of_generacion_asiento ();Boolean 			lb_ret = FALSE
String  			ls_mensaje,ls_moneda,ls_nro_certificado
Long    			ll_row
Decimal 			ldc_tasa_cambio
Str_parametros lstr_param

try 
	ll_row   = dw_master.Getrow()

	IF ll_row = 0 THEN RETURN lb_ret
	dw_master.Accepttext()
		
	ls_moneda 		    = dw_master.object.cod_moneda      [ll_row]
	ldc_tasa_cambio    = dw_master.object.tasa_cambio     [ll_row]
	
	
	IF Isnull(ls_moneda) OR Trim(ls_moneda) = '' THEN
		Messagebox('Aviso','Debe Ingresar Algun Tipo de Moneda')
		dw_master.SetFocus()
		dw_master.Setcolumn('cod_moneda')
		Return lb_ret
	END IF
		
	IF Isnull(ldc_tasa_cambio) OR ldc_tasa_cambio = 0 THEN
		Messagebox('Aviso','Debe Ingresar Tasa de Cambio')
		dw_master.SetFocus()
		dw_master.Setcolumn('tasa_cambio')
		Return lb_ret
	END IF
	
	lstr_param.tipo_mov 			= 'C'
	lstr_param.accion 			= is_action
	lstr_param.nro_certificado = ''
	lstr_param.confin			 	= dw_master.object.confin	[dw_master.getRow()]//is_confin

		
	lb_ret = invo_Asiento_cntbl.of_generar_asiento( dw_master         ,&
																	idw_detail,&
																	idw_asiento_cab,&
																	idw_asiento_det,&
																	lstr_param)
												 
	IF not lb_ret THEN
		Messagebox('Aviso',ls_mensaje, StopSign!)
		return false
	end if
	
	tab_1.tabpage_2.dw_asiento_det.ii_update =1	

	Return true
catch ( Exception ex )
	f_mensaje("Error al generar el asiento contable: " + ex.getMessage(), "")
finally
	/*statementBlock*/
end try


end function

on w_fi337_letras_x_cobrar_canje.create
int iCurrent
call super::create
if this.MenuName = "m_mantenimiento_cl_anular" then this.MenuID = create m_mantenimiento_cl_anular
this.cb_temporal=create cb_temporal
this.cb_2=create cb_2
this.cb_1=create cb_1
this.tab_1=create tab_1
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_temporal
this.Control[iCurrent+2]=this.cb_2
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.tab_1
this.Control[iCurrent+5]=this.dw_master
end on

on w_fi337_letras_x_cobrar_canje.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_temporal)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.tab_1)
destroy(this.dw_master)
end on

event resize;call super::resize;of_asigna_dws()

tab_1.width  = newwidth  - tab_1.x - 10
tab_1.height = newheight - tab_1.y - 10

idw_detail.width = tab_1.tabpage_1.width - idw_detail.x - 10
idw_detail.height = tab_1.tabpage_1.height - idw_detail.y - 10

idw_asiento_det.width = tab_1.tabpage_2.width - idw_asiento_det.x - 10
idw_asiento_det.height = tab_1.tabpage_2.height - idw_asiento_det.y - 10

end event

event ue_insert;call super::ue_insert;Long  ll_row

IF idw_1 = tab_1.tabpage_1.dw_detail AND dw_master.il_row = 0 THEN
	MessageBox("Error", "No ha seleccionado registro Maestro")
	RETURN
END IF


IF idw_1 = dw_master THEN

	TriggerEvent('ue_update_request')
	IF ib_update_check = FALSE THEN RETURN
	is_action = 'new'
	dw_master.Reset()
	tab_1.tabpage_1.dw_detail.Reset()
	tab_1.tabpage_2.dw_asiento_cab.Reset()
	tab_1.tabpage_2.dw_asiento_det.Reset()
	/*Generación Asientos*/
	ib_estado_preas = TRUE
	
	ll_row = idw_1.Event ue_insert()

	IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)

END IF

return


end event

event ue_open_pre;call super::ue_open_pre;of_asigna_dws()
String  ls_doc_lp,ls_confin
Long    ll_nro_libro

if of_get_param() = 0 then 
   is_salir = 'S'
	post event closequery()   
	return
end if

dw_master.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos
idw_detail.SetTransObject(sqlca)
idw_asiento_cab.SetTransObject(sqlca)
idw_asiento_det.SetTransObject(sqlca)

idw_1 = dw_master              				// asignar dw corriente
idw_1.SetFocus()

//** Datastore Voucher **//
ids_voucher = Create u_ds_base
ids_voucher.DataObject = 'd_rpt_voucher_imp_cc_tbl'
ids_voucher.SettransObject(sqlca)

//objecto para verificar cierre de mes contable
invo_asiento_cntbl 	= create n_Cst_asiento_contable
invo_numerador			= create nvo_numeradores
end event

event ue_delete;//override

Long  ll_row


IF idw_1 = dw_master THEN RETURN

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

end event

event ue_delete_pos;call super::ue_delete_pos;Long ll_row

//Generación de Asientos
ib_estado_preas = TRUE

ll_row = dw_master.Getrow()

IF ll_row = 0 THEN RETURN

dw_master.object.importe_doc [ll_row] = wf_calcular_total ()
dw_master.ii_update = 1

end event

event ue_update_request;call super::ue_update_request;Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
IF (dw_master.ii_update = 1                  OR tab_1.tabpage_1.dw_detail.ii_update      = 1 OR &
	 tab_1.tabpage_2.dw_asiento_cab.ii_update = 1 OR tab_1.tabpage_2.dw_asiento_det.ii_update = 1 )  THEN
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	IF li_msg_result = 1 THEN
 		this.TriggerEvent("ue_update")
	ELSE
		dw_master.ii_update = 0
		tab_1.tabpage_1.dw_detail.ii_update = 0
		tab_1.tabpage_2.dw_asiento_cab.ii_update = 0
		tab_1.tabpage_2.dw_asiento_det.ii_update = 0
	END IF
END IF

end event

event ue_update_pre;call super::ue_update_pre;Long   	ll_row_master    ,ll_ano   ,ll_mes,ll_nro_libro,ll_nro_asiento,ll_count_doc_ref,&
		 	ll_count_asientos,ll_inicio
String   ls_cod_origen, ls_cod_relacion, ls_tipo_doc, ls_nro_ltc,&
		   ls_flag_situacion,ls_flag_estado,ls_cod_moneda,ls_obs		   ,ls_cod_usr     ,ls_result  ,ls_mensaje,&
			ls_cod_banco     ,ls_cnta_cntbl
Datetime ldt_fecha_emision,ldt_fecha_registro		 
Decimal 	ldc_tasa_cambio, ldc_total_doc,ldc_saldo_sol,ldc_saldo_dol,ldc_totsoldeb, &
			ldc_totdoldeb,ldc_totsolhab, ldc_totdolhab
dwItemStatus ldis_status


/*REPLICACION*/
dw_master.of_set_flag_replicacion()
idw_detail.of_set_flag_replicacion()
idw_asiento_cab.of_set_flag_replicacion()
idw_asiento_det.of_set_flag_replicacion()

if dw_master.RowCount() = 0 or idw_detail.RowCount() = 0 or is_action= 'delete' then 
	ib_update_check = true
	return
end if

ib_update_check = False	

ll_row_master = dw_master.getRow()

//Verificación de Cabecera de Documento
IF gnvo_app.of_row_Processing( dw_master) <> true then return
IF gnvo_app.of_row_Processing( idw_Detail ) <> true then return
IF gnvo_app.of_row_Processing( idw_asiento_det ) <> true then return

//Datos de Cabecera
ls_cod_origen      = dw_master.object.origen             [ll_row_master]
ll_ano      		 = dw_master.object.ano                [ll_row_master]
ll_mes      		 = dw_master.object.mes                [ll_row_master]
ll_nro_libro		 = dw_master.object.nro_libro          [ll_row_master]
ll_nro_asiento		 = dw_master.object.nro_asiento        [ll_row_master]
ls_cod_relacion	 = dw_master.object.cod_relacion       [ll_row_master]
ls_tipo_doc			 = dw_master.object.tipo_doc           [ll_row_master]
ls_nro_ltc			 = dw_master.object.nro_doc            [ll_row_master]
ls_flag_situacion  = dw_master.object.flag_situacion_ltr [ll_row_master]
ldt_fecha_emision	 = dw_master.object.fecha_documento    [ll_row_master]
ls_flag_estado     = dw_master.object.flag_estado    	   [ll_row_master]
ls_cod_moneda 		 = dw_master.object.cod_moneda  		   [ll_row_master]
ldc_tasa_cambio    = dw_master.object.tasa_cambio    	   [ll_row_master]
ls_obs				 = dw_master.object.observacion    	   [ll_row_master]
ldt_fecha_registro = dw_master.object.fecha_registro     [ll_row_master]
ldc_total_doc		 = dw_master.object.importe_doc			[ll_row_master]


IF ls_cod_moneda = gnvo_app.is_soles THEN 
	
	ldc_saldo_sol = ldc_total_doc
	ldc_saldo_dol = Round(ldc_total_doc / ldc_tasa_cambio ,2)
	
ELSEIF ls_cod_moneda = gnvo_app.is_dolares THEN
	
	ldc_saldo_sol = Round(ldc_total_doc *  ldc_tasa_cambio ,2)
	ldc_saldo_dol = ldc_total_doc
	
END IF

//saldos
dw_master.object.saldo_sol [ll_row_master] = ldc_saldo_sol 
dw_master.object.saldo_dol [ll_row_master] = ldc_saldo_dol

/*verifica cierre de mes contable*/
invo_asiento_cntbl.of_val_mes_cntbl(ll_ano,ll_mes,'R',ls_result,ls_mensaje) 

IF ls_result = '0' THEN
	Messagebox('Aviso',ls_result)
	Return
END IF


IF ls_flag_situacion <> '1' THEN
	ls_cod_banco = dw_master.object.banco_ltr [ll_row_master]
	IF Isnull(ls_cod_banco) OR Trim(ls_cod_banco) = '' THEN
		Messagebox('Aviso','Debe Ingresar codigo de Banco , Verifique!')
		dw_master.SetFocus()
		dw_master.SetColumn('cod_banco')
		RETURN
	END IF
END IF

//Asignación de Nro Libro
IF is_action = 'new' or isNull(ls_nro_ltc) or trim(ls_nro_ltc) = '' THEN
	//genera numero de letra x cobrar
	IF not invo_numerador.of_get_nro_doc_tipo(ls_tipo_doc, ls_nro_ltc, ls_cod_origen) THEN return

	dw_master.object.nro_doc [ll_row_master] = ls_nro_ltc
	
	/******/
	ll_nro_libro = f_nro_libro(is_doc_ltc)	 
	
	IF Isnull(ll_nro_libro)  OR ll_nro_libro = 0 THEN return 
	/******/
	
	//verificacion de año y mes	
	IF Isnull(ll_ano) OR ll_ano = 0 THEN
		Messagebox('Aviso','Ingrese Año Contable , Verifique!')
		Return
	END IF
	
	IF Isnull(ll_mes) OR ll_mes = 0 THEN
		Messagebox('Aviso','Ingrese Mes Contable , Verifique!')
		Return
	END IF
	
	IF invo_asiento_cntbl.of_get_nro_asiento(ls_cod_origen, ll_ano, ll_mes, ll_nro_libro, ll_nro_asiento)  = FALSE THEN return
	
	dw_master.object.nro_asiento [1] = ll_nro_asiento 
	dw_master.object.nro_libro   [1] = ll_nro_libro
	
	//asignación de año y mes cab contable
	idw_asiento_cab.Object.ano [1] = ll_ano
	idw_asiento_cab.Object.mes [1] = ll_mes

END IF



/*Generación Pre-Asientos*/
IF ib_estado_preas THEN
	IF of_generacion_Asiento() = FALSE THEN return
END IF

//Acumulador de Registro de doc Referencias
ll_count_doc_ref  = idw_detail.Rowcount()
//Acumulador de Registro de Pre Asientos
ll_count_asientos = idw_asiento_det.Rowcount()

//Documento de Referencia

IF ls_flag_estado = '1'  THEN
	IF ll_count_doc_ref = 0 THEN
		Messagebox('Aviso','Debe Ingresar Algun Tipo de Documento de Referencia')
		RETURN
	END IF
	
END IF

//Asiento Detalle
IF ll_count_asientos = 0 THEN
	Messagebox('Aviso','Debe Revisar Concepto Financiero y Matriz Contable Ingresadas')	
	RETURN
END IF


//Documento de Referencia
FOR ll_inicio = 1 TO ll_count_doc_ref
	 //REGISTRO NUEVOS ACTUALIZAR PK
    ldis_status = idw_detail.GetItemStatus(ll_inicio,0,Primary!)
    IF ldis_status = NewModified! THEN
	     idw_detail.Object.cod_relacion [ll_inicio] = ls_cod_relacion	
		  idw_detail.Object.tipo_doc     [ll_inicio] = ls_tipo_doc
		  idw_detail.Object.nro_doc      [ll_inicio] = ls_nro_ltc
    END IF	 
NEXT

//Asigancion de Datos en Cabecera de Asiento
IF is_action = 'new' THEN
	idw_asiento_cab.Object.origen		 [1] = ls_cod_origen
	idw_asiento_cab.Object.ano			 [1] = ll_ano
	idw_asiento_cab.Object.mes			 [1] = ll_mes
	idw_asiento_cab.Object.nro_libro	 [1] = ll_nro_libro
	idw_asiento_cab.Object.nro_asiento [1] = ll_nro_asiento
END IF

//Asignacion de Datos En Asiento Detalle
FOR ll_inicio = 1 TO idw_asiento_det.Rowcount()
 	 ls_cnta_cntbl = idw_asiento_det.object.cnta_ctbl [ll_inicio]
	 
	 //REGISTRO NUEVOS ACTUALIZAR PK
    ldis_status = idw_asiento_det.GetItemStatus(ll_inicio,0,Primary!)
    IF ldis_status = NewModified! THEN
		 idw_asiento_det.object.origen		[ll_inicio] = ls_cod_origen
		 idw_asiento_det.object.ano			[ll_inicio] = ll_ano
		 idw_asiento_det.object.mes			[ll_inicio] = ll_mes
		 idw_asiento_det.object.nro_libro	[ll_inicio] = ll_nro_libro
		 idw_asiento_det.object.nro_asiento [ll_inicio] = ll_nro_asiento
	 END IF
	
	 idw_asiento_det.object.fec_cntbl   [ll_inicio] = ldt_fecha_emision
    IF wf_verifica_flag_cntas(ls_cnta_cntbl,ls_tipo_doc,ls_nro_ltc,ls_cod_relacion,ll_inicio) = FALSE THEN
		 RETURN
	 END IF

NEXT

//Obtencion de Acumualdores en Pre Asiento Detalle
ldc_totsoldeb = idw_asiento_det.object.monto_soles_cargo	  [1]
ldc_totdoldeb = idw_asiento_det.object.monto_dolares_cargo [1]
ldc_totsolhab = idw_asiento_det.object.monto_soles_abono   [1]
ldc_totdolhab = idw_asiento_det.object.monto_dolares_abono [1]


//Datos Adicionales de Cabecera en Asiento
idw_asiento_cab.Object.cod_moneda	  [1] = ls_cod_moneda
idw_asiento_cab.Object.tasa_cambio  [1] = ldc_tasa_cambio
idw_asiento_cab.Object.desc_glosa	  [1] = ls_obs
idw_asiento_cab.Object.fec_registro [1] = ldt_fecha_registro
idw_asiento_cab.Object.fecha_cntbl  [1] = ldt_fecha_emision
idw_asiento_cab.Object.cod_usr		  [1] = ls_cod_usr
idw_asiento_cab.Object.flag_estado  [1] = ls_flag_estado
idw_asiento_cab.Object.tot_solhab	  [1] = ldc_totsolhab
idw_asiento_cab.Object.tot_dolhab	  [1] = ldc_totdolhab
idw_asiento_cab.Object.tot_soldeb	  [1] = ldc_totsoldeb
idw_asiento_cab.Object.tot_doldeb	  [1] = ldc_totdoldeb

IF idw_detail.ii_update = 1  OR idw_asiento_det.ii_update = 1 THEN dw_master.ii_update = 1	
IF dw_master.ii_update = 1 THEN idw_asiento_cab.ii_update = 1	

// valida asientos descuadrados
IF not invo_asiento_cntbl.of_validar_asiento(idw_asiento_det) then return 

ib_update_check = True

end event

event ue_update;call super::ue_update;Boolean lbo_ok = TRUE
String  ls_origen
Long    ll_row_det,ll_ano,ll_mes,ll_nro_libro,ll_nro_asiento

dw_master.AcceptText()
idw_detail.AcceptText()
idw_asiento_cab.AcceptText()
idw_asiento_det.AcceptText()


THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN 
	Rollback ;
	RETURN
END IF	

if ib_log then
	dw_master.of_create_log()
	idw_detail.of_create_log()
	idw_asiento_cab.of_create_log()
	idw_asiento_det.of_create_log()
end if

//ejecuta procedimiento de actualizacion de tabla temporal
IF idw_asiento_det.ii_update = 1 and is_action <> 'new' THEN
	ll_row_det     = idw_asiento_cab.Getrow()
	ls_origen      = idw_asiento_cab.Object.origen      [ll_row_det]
	ll_ano         = idw_asiento_cab.Object.ano         [ll_row_det]
	ll_mes         = idw_asiento_cab.Object.mes         [ll_row_det]
	ll_nro_libro   = idw_asiento_cab.Object.nro_libro   [ll_row_det]
	ll_nro_asiento = idw_asiento_cab.Object.nro_asiento [ll_row_det]
	
	if f_insert_tmp_asiento(ls_origen,ll_ano,ll_mes,ll_nro_libro,ll_nro_asiento) = FALSE then
		Rollback ;
		Return
	end if	
END IF	


IF idw_asiento_cab.ii_update = 1 AND lbo_ok = TRUE THEN 
	IF idw_asiento_cab.Update (true, false) = -1 THEN // Cabecera de Asiento
		lbo_ok = FALSE
	   Rollback ;
		Messagebox("Error en Grabacion Cabecera de Asiento","Se ha procedido al rollback",exclamation!)
	END IF
END IF	

IF idw_asiento_det.ii_update = 1 AND lbo_ok = TRUE THEN 
	IF idw_asiento_det.Update (true, false) = -1 THEN 
		lbo_ok = FALSE
	   Rollback ;
		Messagebox("Error en Grabacion Detalle de Asiento","Se ha procedido al rollback",exclamation!)
	END IF
END IF
	
IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_master.Update(true, false) = -1 then		// Grabacion del Master
		lbo_ok = FALSE
      Rollback ;
		Messagebox("Error en Grabacion Master","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF idw_detail.ii_update = 1 AND lbo_ok = TRUE THEN
	IF idw_detail.Update(true, false) = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
	   Rollback ;
		Messagebox("Error en Grabacion Detalle","Se ha procedido al rollback",exclamation!)
	END IF
END IF	

if lbo_ok then
	if ib_log then
		lbo_ok = dw_master.of_save_log()
		lbo_ok = idw_detail.of_save_log()
		lbo_ok = idw_asiento_cab.of_save_log()
		lbo_ok = idw_asiento_det.of_save_log()
	end if
end if

IF lbo_ok THEN
	
	COMMIT using SQLCA;
	dw_master.ii_update = 0
	idw_detail.ii_update = 0
	idw_asiento_cab.ii_update = 0
	idw_asiento_det.ii_update = 0

	dw_master.ResetUpdate()
	idw_detail.ResetUpdate()
	idw_asiento_cab.ResetUpdate()
	idw_asiento_det.ResetUpdate()

	is_action = 'fileopen'
	TriggerEvent('ue_modify')
	f_mensaje("Grabación realizada satisfactoriamente", "")
ELSE
	Rollback ;
END IF
end event

event ue_insert_pos;call super::ue_insert_pos;tab_1.tabpage_2.dw_asiento_cab.TriggerEvent('ue_insert')
dw_master.SetFocus ()
dw_master.SetColumn('nro_doc')

end event

event ue_retrieve_list;call super::ue_retrieve_list;//override
// Asigna valores a structura 
Long   ll_row , ll_inicio
str_parametros sl_param

TriggerEvent ('ue_update_request')		

sl_param.dw1    = 'd_abc_lista_letras_x_cobrar_tbl'
sl_param.titulo = 'Canje de Letras  Pagar'
sl_param.field_ret_i[1] = 1	//Codigo de Relación
sl_param.field_ret_i[2] = 2	//Tipo Doc
sl_param.field_ret_i[3] = 3	//Nro Doc
sl_param.field_ret_i[4] = 6	//Origen
sl_param.field_ret_i[5] = 7	//Año
sl_param.field_ret_i[6] = 8	//Mes
sl_param.field_ret_i[7] = 9	//Nro Libro
sl_param.field_ret_i[8] = 10	//Nro Asiento
sl_param.tipo    = '1SQL'
sl_param.string1 =  ' AND ("CNTAS_COBRAR"."FLAG_TIPO_LTR" =  '+"'"+'C'+"'"+')    '&
						 +' AND ("CNTAS_COBRAR"."FLAG_ESTADO"   IN '+'('+"'"+'0'+"','"+'1'+"',"+"'"+'2'+"','"+'3'+"')"+')   '&
						 +' ORDER BY "CNTAS_COBRAR"."FECHA_DOCUMENTO" ASC  '

OpenWithParm( w_lista, sl_param)

sl_param = Message.PowerObjectParm
IF sl_param.titulo <> 'n' THEN
	dw_master.Retrieve('C',sl_param.field_ret[1],sl_param.field_ret[2],sl_param.field_ret[3])
	tab_1.tabpage_1.dw_detail.Retrieve(sl_param.field_ret[1],sl_param.field_ret[2],sl_param.field_ret[3],'C')
	tab_1.tabpage_2.dw_asiento_cab.Retrieve(sl_param.field_ret[4],Long(sl_param.field_ret[5]),Long(sl_param.field_ret[6]),Long(sl_param.field_ret[7]),Long(sl_param.field_ret[8]))
	tab_1.tabpage_2.dw_asiento_det.Retrieve(sl_param.field_ret[4],Long(sl_param.field_ret[5]),Long(sl_param.field_ret[6]),Long(sl_param.field_ret[7]),Long(sl_param.field_ret[8]))

	ib_estado_preas = False   //pre-asiento editado					
	is_action = 'fileopen'	
	TriggerEvent('ue_modify')

	
	dw_master.ii_update = 0
	tab_1.tabpage_1.dw_detail.ii_update = 0
	tab_1.tabpage_2.dw_asiento_cab.ii_update = 0
	tab_1.tabpage_2.dw_asiento_det.ii_update = 0
	
END IF


end event

event ue_modify;call super::ue_modify;Long    ll_row,ll_ano,ll_mes
String  ls_result,ls_mensaje,ls_flag_estado
Integer li_protect

ll_row = dw_master.Getrow()

IF ll_row = 0 THEN RETURN
//bloqueo
dw_master.of_protect()
idw_detail.of_protect()
idw_asiento_det.of_protect()



ls_flag_estado = dw_master.object.flag_estado [ll_row]
ll_ano         = dw_master.object.ano         [ll_row]
ll_mes         = dw_master.object.mes         [ll_row]


/*verifica cierre*/
invo_asiento_cntbl.of_val_mes_cntbl(ll_ano,ll_mes,'R',ls_result,ls_mensaje) 

IF ls_flag_estado = '1' THEN //ACTIVO Y NO TENGA RETENCIONES
   IF (ls_result = '1') THEN //MES CONTABLE ABIERTO
		IF is_action <> 'new' THEN
		   li_protect = integer(dw_master.Object.nro_doc.Protect)
	   	IF li_protect = 0 THEN
				dw_master.Object.cod_relacion.Protect	  = 1
				dw_master.Object.tipo_doc.Protect		  = 1
		      dw_master.Object.nro_doc.Protect		     = 1
				dw_master.Object.ano.Protect			     = 1
				dw_master.Object.mes.Protect			     = 1
				dw_master.Object.dias_a_cancelar.Protect = 1
		   END IF 
		END IF
	END IF
ELSE
	dw_master.ii_protect = 0
	tab_1.tabpage_1.dw_detail.ii_protect = 0
	dw_master.of_protect()
	tab_1.tabpage_1.dw_detail.of_protect()
	
	//SI MES CONTABLE ESTA CERRADO O LETRA YA PASO A OTRO ESTADO DIFERENTE A GENERADO BLOQUEAR ASIENTO
	IF ls_flag_estado <> '1' OR ls_result = '0' THEN
		tab_1.tabpage_2.dw_asiento_det.ii_protect = 0
		tab_1.tabpage_2.dw_asiento_det.of_protect()
	END IF
END IF
end event

event closequery;call super::closequery;destroy invo_asiento_cntbl 
destroy invo_numerador
end event

type cb_temporal from commandbutton within w_fi337_letras_x_cobrar_canje
boolean visible = false
integer x = 3346
integer y = 268
integer width = 462
integer height = 100
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "&Detracción (2)"
end type

event clicked;str_parametros sl_param
String ls_cod_relacion,ls_cod_moneda,ls_flag_estado,ls_tipo_doc,ls_nro_doc,ls_confin
Long   ll_row,ll_inicio
Decimal {3} ldc_tasa_cambio
Decimal {2} ldc_imp_total

dw_master.Accepttext()
ll_row = dw_master.Getrow ()

IF ll_row = 0 THEN 
	Messagebox('Aviso','Debe Ingresar Registro Algun Registro , Verifique!')
	RETURN
END IF

select confin_pago_masivo into :ls_confin from finparam where reckey = '1' ;

//recupero datos de la cabecera
ls_cod_relacion = dw_master.object.cod_relacion [ll_row]	
ls_cod_moneda	 = dw_master.object.cod_moneda   [ll_row]	
ldc_tasa_cambio = dw_master.object.tasa_cambio  [ll_row]	
ls_flag_estado	 = dw_master.object.flag_estado  [ll_row]	


//VERIFICAR ESTADO 
IF ls_flag_estado <> '1' THEN 
	Messagebox('Aviso','Estado de la Letra no esta Disponible para realizar Modificaciones , Verifique!')
	Return
END IF	

IF Isnull(ls_cod_relacion) OR Trim(ls_cod_relacion) = '' THEN
	Messagebox('Aviso','Deb Ingresar Un Codigo de Relacion , Verifique!')
	dw_master.SetFocus()
	dw_master.SetColumn('cod_relacion')
	Return
END IF

IF Isnull(ls_cod_moneda) OR Trim(ls_cod_moneda) = '' THEN
	Messagebox('Aviso','Deb Ingresar Un Codigo de Moneda , Verifique!')
	dw_master.SetFocus()
	dw_master.SetColumn('cod_moneda')
	Return
END IF

IF Isnull(ldc_tasa_cambio) OR ldc_tasa_cambio <= 0 THEN
	Messagebox('Aviso','Debe Ingresar Una Tasa de Cambio Valida , Verifique!')
	dw_master.SetFocus()
	dw_master.SetColumn('tasa_cambio')
	Return
END IF



sl_param.dw1		= 'd_abc_lista_detraccion_temp_tbl'
sl_param.titulo	= 'Documentos Pendientes x Proveedor '
sl_param.tipo 		= '1DETATEMP'
sl_param.string1	= ls_tipo_doc
sl_param.string2	= ls_cod_moneda
sl_param.string3	= ls_nro_doc
sl_param.string4	= ls_cod_relacion

sl_param.opcion   = 24 //DETRACCION
sl_param.db1 		= 1600
sl_param.dw_m		= tab_1.tabpage_1.dw_detail


OpenWithParm( w_abc_seleccion_lista, sl_param)

IF isvalid(message.PowerObjectParm) THEN sl_param = message.PowerObjectParm			
IF sl_param.bret  THEN
	tab_1.tabpage_1.dw_detail.ii_update = 1
	dw_master.object.importe_doc [ll_row] = wf_calcular_total ()
	dw_master.ii_update = 1
	/*GENERACION DE ASIENTOS*/
	ib_estado_preas = TRUE
	
	FOR ll_inicio = 1 to tab_1.tabpage_1.dw_detail.rowcount()
		 tab_1.tabpage_1.dw_detail.object.confin [ll_inicio] = ls_confin
	NEXT
	
END IF

end event

type cb_2 from commandbutton within w_fi337_letras_x_cobrar_canje
boolean visible = false
integer x = 3346
integer y = 160
integer width = 457
integer height = 100
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "&Detracción (1)"
end type

event clicked;str_parametros sl_param
String ls_cod_relacion,ls_cod_moneda,ls_flag_estado,ls_tipo_doc,ls_nro_doc,ls_confin
Long   ll_row,ll_inicio
Decimal {3} ldc_tasa_cambio
Decimal {2} ldc_imp_total

dw_master.Accepttext()
ll_row = dw_master.Getrow ()

IF ll_row = 0 THEN 
	Messagebox('Aviso','Debe Ingresar Registro Algun Registro , Verifique!')
	RETURN
END IF

select confin_pago_masivo into :ls_confin from finparam where reckey = '1' ;

//recupero datos de la cabecera
ls_cod_relacion = dw_master.object.cod_relacion [ll_row]	
ls_cod_moneda	 = dw_master.object.cod_moneda   [ll_row]	
ldc_tasa_cambio = dw_master.object.tasa_cambio  [ll_row]	
ls_flag_estado	 = dw_master.object.flag_estado  [ll_row]	


//VERIFICAR ESTADO 
IF ls_flag_estado <> '1' THEN 
	Messagebox('Aviso','Estado de la Letra no esta Disponible para realizar Modificaciones , Verifique!')
	Return
END IF	

IF Isnull(ls_cod_relacion) OR Trim(ls_cod_relacion) = '' THEN
	Messagebox('Aviso','Deb Ingresar Un Codigo de Relacion , Verifique!')
	dw_master.SetFocus()
	dw_master.SetColumn('cod_relacion')
	Return
END IF

IF Isnull(ls_cod_moneda) OR Trim(ls_cod_moneda) = '' THEN
	Messagebox('Aviso','Deb Ingresar Un Codigo de Moneda , Verifique!')
	dw_master.SetFocus()
	dw_master.SetColumn('cod_moneda')
	Return
END IF

IF Isnull(ldc_tasa_cambio) OR ldc_tasa_cambio <= 0 THEN
	Messagebox('Aviso','Debe Ingresar Una Tasa de Cambio Valida , Verifique!')
	dw_master.SetFocus()
	dw_master.SetColumn('tasa_cambio')
	Return
END IF



OpenWithParm(w_pop_tipo_doc,sl_param)
//* Check text returned in Message object//
IF isvalid(message.PowerObjectParm) THEN
	sl_param = message.PowerObjectParm
	
END IF
//**//





sl_param.dw1		= 'd_abc_lista_detraccion_tbl'
sl_param.titulo	= 'Documentos Pendientes x Proveedor '
//sl_param.string1	= tipo de Documento
sl_param.string2	= ls_cod_moneda
//sl_param.string3	= Nro de Documento
sl_param.string4	= ls_cod_relacion
sl_param.tipo 		= '1DETA'
sl_param.opcion   = 24 //DETRACCION
sl_param.db1 		= 1600
sl_param.dw_m		= tab_1.tabpage_1.dw_detail


OpenWithParm( w_abc_seleccion_lista, sl_param)

IF isvalid(message.PowerObjectParm) THEN sl_param = message.PowerObjectParm			
IF sl_param.bret  THEN
	tab_1.tabpage_1.dw_detail.ii_update = 1
	dw_master.object.importe_doc [ll_row] = wf_calcular_total ()
	dw_master.ii_update = 1
	/*GENERACION DE ASIENTOS*/
	ib_estado_preas = TRUE
	
	FOR ll_inicio = 1 to tab_1.tabpage_1.dw_detail.rowcount()
		 tab_1.tabpage_1.dw_detail.object.confin [ll_inicio] = ls_confin
	NEXT
	
END IF
end event

type cb_1 from commandbutton within w_fi337_letras_x_cobrar_canje
integer x = 3346
integer y = 56
integer width = 462
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Referencias"
end type

event clicked;str_parametros sl_param
String ls_cod_relacion,ls_cod_moneda,ls_flag_estado,ls_confin
Long   ll_row,ll_inicio
Decimal {3} ldc_tasa_cambio
Decimal {2} ldc_imp_total

ll_row = dw_master.Getrow ()

IF ll_row = 0 THEN 
	Messagebox('Aviso','Debe Ingresar Registro Algun Registro , Verifique!')
	RETURN
END IF

select confin_pago_masivo into :ls_confin from finparam where reckey = '1' ;


//recupero datos de la cabecera
ls_cod_relacion = dw_master.object.cod_relacion [ll_row]	
ls_cod_moneda	 = dw_master.object.cod_moneda   [ll_row]	
ldc_tasa_cambio = dw_master.object.tasa_cambio  [ll_row]	
ls_flag_estado	 = dw_master.object.flag_estado  [ll_row]	


//VERIFICAR ESTADO 
IF ls_flag_estado <> '1' THEN 
	Messagebox('Aviso','Estado de la Letra no esta Disponible para realizar Modificaciones , Verifique!')
	Return
END IF	

IF Isnull(ls_cod_relacion) OR Trim(ls_cod_relacion) = '' THEN
	Messagebox('Aviso','Deb Ingresar Un Codigo de Relacion , Verifique!')
	dw_master.SetFocus()
	dw_master.SetColumn('cod_relacion')
	Return
END IF

IF Isnull(ls_cod_moneda) OR Trim(ls_cod_moneda) = '' THEN
	Messagebox('Aviso','Deb Ingresar Un Codigo de Moneda , Verifique!')
	dw_master.SetFocus()
	dw_master.SetColumn('cod_moneda')
	Return
END IF

IF Isnull(ldc_tasa_cambio) OR ldc_tasa_cambio <= 0 THEN
	Messagebox('Aviso','Debe Ingresar Una Tasa de Cambio Valida , Verifique!')
	dw_master.SetFocus()
	dw_master.SetColumn('tasa_cambio')
	Return
END IF

sl_param.dw1		= 'd_abc_lista_doc_x_cobrar_tbl'
sl_param.titulo	= 'Documentos Pendientes x Proveedor '
sl_param.string1	= ls_cod_relacion
sl_param.string2	= ls_cod_moneda
sl_param.db2		= ldc_tasa_cambio
sl_param.tipo 		= '1CC'
sl_param.opcion   = 2 //canje de letras x Cobrar
sl_param.db1 		= 1600
sl_param.dw_m		= dw_master
sl_param.dw_d		= tab_1.tabpage_1.dw_detail


OpenWithParm( w_abc_seleccion_lista, sl_param)

IF isvalid(message.PowerObjectParm) THEN sl_param = message.PowerObjectParm			
IF sl_param.bret  THEN
	tab_1.tabpage_1.dw_detail.ii_update = 1
	dw_master.object.importe_doc [ll_row] = wf_calcular_total ()
	dw_master.ii_update = 1
	/*GENERACION DE ASIENTOS*/
	ib_estado_preas = TRUE
	
	FOR ll_inicio = 1 to tab_1.tabpage_1.dw_detail.rowcount()
		 tab_1.tabpage_1.dw_detail.object.confin [ll_inicio] = ls_confin
	NEXT
	
END IF
end event

type tab_1 from tab within w_fi337_letras_x_cobrar_canje
integer y = 1076
integer width = 3547
integer height = 972
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
boolean raggedright = true
boolean focusonbuttondown = true
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.Control[]={this.tabpage_1,&
this.tabpage_2}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
end on

event selectionchanged;

CHOOSE CASE newindex
		 CASE 2
				IF ib_estado_preas = FALSE THEN RETURN
		 		of_generacion_Asiento()
END CHOOSE

end event

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 3511
integer height = 844
long backcolor = 79741120
string text = "  Documentos de Referencia"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "CreateRuntime!"
long picturemaskcolor = 536870912
dw_detail dw_detail
end type

on tabpage_1.create
this.dw_detail=create dw_detail
this.Control[]={this.dw_detail}
end on

on tabpage_1.destroy
destroy(this.dw_detail)
end on

type dw_detail from u_dw_abc within tabpage_1
integer width = 3246
integer height = 512
integer taborder = 20
string dataobject = "d_abc_doc_ref_letras_x_cobrar_tbl"
borderstyle borderstyle = styleraised!
end type

event constructor;call super::constructor;is_mastdet = 'd'		
is_dwform = 'tabular'	// tabular, form (default)

ii_rk[1] = 1  // columnas que recibimos del master
ii_rk[2] = 2 	      
ii_rk[3] = 3 	      

ii_ck[1] = 1 // columnas de lectrua de este dw
ii_ck[2] = 2				
ii_ck[3] = 3				
ii_ck[4] = 4				
ii_ck[5] = 5				
ii_ck[6] = 6				
ii_ck[7] = 7				

idw_mst  = dw_master				
idw_det  = tab_1.tabpage_1.dw_detail

end event

event itemerror;call super::itemerror;Return 1
end event

event itemchanged;call super::itemchanged;String ls_moneda_cab ,ls_cod_relacion ,ls_tipo_doc ,ls_nro_doc    ,ls_origen_ref,&
       ls_tipo_ref   ,ls_nro_ref      ,ls_accion   ,ls_flag_estado,ls_soles     ,&
		 ls_dolares    ,ls_moneda_det
		 
Decimal {2} ldc_importe,ldc_porc_ret_igv,ldc_imp_retencion
Decimal {3} ldc_tasa_cambio
Long   ll_row_master
dwItemStatus ldis_status


Accepttext()
//Generacion de Asientos Automaticos
ib_estado_preas = TRUE




choose case dwo.name
		 case 'importe'
						
				ll_row_master = dw_master.Getrow()
				
				/*Datos de cabecera*/
				ls_moneda_cab   = This.Object.cod_moneda_cab [row]
				ldc_tasa_cambio = This.Object.tasa_cambio	  [row]
				
				/**/
				ls_cod_relacion   = This.object.cod_relacion [row]
				ls_tipo_doc			= This.object.tipo_doc     [row]
				ls_nro_doc			= This.object.nro_doc      [row]
				ls_origen_ref		= This.object.origen_ref   [row]
				ls_tipo_ref			= This.object.tipo_ref     [row]
				ls_nro_ref			= This.object.nro_ref      [row]
				ldc_importe			= This.object.importe		[row]
				
				/*determinar estado del registro*/
				ldis_status = This.Getitemstatus( row,0,Primary!)
				IF ldis_status = NewModified! THEN
					ls_accion = 'new'
				ELSE
					ls_accion = 'fileopen'
				END IF
				
				f_verifica_monto_ref(ls_cod_relacion,ls_tipo_doc,ls_nro_doc,ls_origen_ref,ls_tipo_ref,ls_nro_ref,ls_accion,ldc_importe,ls_flag_estado)				
				
				
//				IF Trim(ls_flag_estado) = '1' THEN
//					Messagebox('Aviso','Se esta Excediendo en el monto establecido')
//					This.object.importe [row] = 0.00
//					Return 1
//				END IF
				
				//recalcular 
				dw_master.object.importe_doc [ll_row_master] = wf_calcular_total ()
				dw_master.ii_update = 1
				
				
				
end choose

end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event ue_display;call super::ue_display;str_parametros		lstr_param

CHOOSE CASE lower(as_columna)
	CASE 'confin'
	
		lstr_param.tipo		= ''
		lstr_param.opcion		= 3
		lstr_param.titulo 	= 'Selección de Concepto Financiero'
		lstr_param.dw_master	= 'd_lista_grupo_financiero_grd'     //Filtrado para cierto grupo
		lstr_param.dw1			= 'd_lista_concepto_financiero_grd'
		lstr_param.dw_m		=  This
		
		OpenWithParm( w_abc_seleccion_md, lstr_param)
		IF isvalid(message.PowerObjectParm) THEN lstr_param = message.PowerObjectParm			
		IF lstr_param.titulo = 's' THEN
			this.ii_update = 1
			/*Datos del Registro Modificado*/
			ib_estado_preas = TRUE
			/**/
		END IF

END CHOOSE
end event

event doubleclicked;call super::doubleclicked;string ls_columna
if not this.is_protect(dwo.name, row) and row > 0 then
	ls_columna = upper(dwo.name)
	THIS.event dynamic ue_display(ls_columna, row)
end if
end event

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 3511
integer height = 844
long backcolor = 79741120
string text = " Asientos Contables"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "Cursor!"
long picturemaskcolor = 536870912
dw_asiento_det dw_asiento_det
dw_asiento_cab dw_asiento_cab
end type

on tabpage_2.create
this.dw_asiento_det=create dw_asiento_det
this.dw_asiento_cab=create dw_asiento_cab
this.Control[]={this.dw_asiento_det,&
this.dw_asiento_cab}
end on

on tabpage_2.destroy
destroy(this.dw_asiento_det)
destroy(this.dw_asiento_cab)
end on

type dw_asiento_det from u_dw_abc within tabpage_2
integer width = 3474
integer height = 384
integer taborder = 20
string dataobject = "d_abc_cnta_cntbl_pre_asiento_det_tbl"
borderstyle borderstyle = styleraised!
end type

event constructor;call super::constructor;is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
	                  //      'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)


ii_ck[1] = 1			// columnas de lectura de este dw
ii_ck[2] = 2
ii_ck[3] = 3
ii_ck[4] = 4
ii_ck[5] = 5
ii_ck[6] = 6
ii_ck[7] = 7

ii_rk[1] = 1 	      // columnas que recibimos del master
ii_rk[2] = 2
ii_rk[3] = 3
ii_rk[4] = 4
ii_rk[5] = 5
ii_rk[6] = 6



idw_mst = tab_1.tabpage_2.dw_asiento_cab
idw_det = tab_1.tabpage_2.dw_asiento_det
end event

event itemerror;call super::itemerror;Return 1
end event

event itemchanged;call super::itemchanged;accepttext()
ib_estado_preas = FALSE
end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

type dw_asiento_cab from u_dw_abc within tabpage_2
integer x = 18
integer y = 464
integer width = 3474
integer taborder = 20
string dataobject = "d_abc_cnta_cntbl_pre_asiento_cab_tbl"
end type

event constructor;call super::constructor;is_mastdet = 'md'		// 'm' = master sin detalle (default), 'd' =  detalle,
	                  //      'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)



ii_ck[1] = 1			// columnas de lectrua de este dw
ii_ck[2] = 2
ii_ck[3] = 3
ii_ck[4] = 4
ii_ck[5] = 5
ii_ck[6] = 6

ii_dk[1] = 1 	      // columnas que se pasan al detalle
ii_dk[2] = 2
ii_dk[3] = 3
ii_dk[4] = 4
ii_dk[5] = 5
ii_dk[6] = 6

idw_det  = tab_1.tabpage_2.dw_asiento_det
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

end event

event itemchanged;call super::itemchanged;accepttext()
end event

event itemerror;call super::itemerror;Return 1
end event

type dw_master from u_dw_abc within w_fi337_letras_x_cobrar_canje
integer width = 3319
integer height = 1052
string dataobject = "d_abc_letra_x_cobrar_tbl"
boolean hscrollbar = false
boolean vscrollbar = false
end type

event constructor;call super::constructor;is_mastdet = 'md'		

is_dwform = 'form'	// tabular, form (default)


ii_ck[1] = 1			// columnas de lectrua de este dw
ii_ck[2] = 2			

ii_dk[1] = 1 	      // columnas que se pasan al detalle
ii_dk[2] = 2
ii_dk[3] = 3



//idw_mst  = dw_master						 // dw_master
idw_det  = tab_1.tabpage_1.dw_detail // dw_detail

end event

event itemchanged;call super::itemchanged;Long   	ll_count 
String 	ls_prov, ls_nom, ls_prov_old, ls_flag_situacion, ls_codigo, ls_data
Decimal 	ldc_tasa_cambio, ld_dias_a_canc
Date    	ld_fecha_emision,ld_fecha_vencimiento,ld_fecha_emision_old

ls_prov_old          = This.object.cod_relacion  [row]
ld_fecha_emision_old = Date(This.Object.fecha_documento [row])

This.Accepttext()

//Generación de Asientos Automaticos
ib_estado_preas = TRUE

choose case dwo.name
	 case 'cod_moneda'
			/*Actualiza moneda de la cabecera en el detalle*/
			wf_update_moneda_cab_det (data)
			dw_master.Object.importe_doc [row] = wf_calcular_total ()
			
	 case	'tasa_cambio'
			ldc_tasa_cambio = This.object.tasa_cambio [row]
			/*ACTUALIZAR TASA DE CAMBIO DE DETALLE*/
			wf_update_tcambio_det(ldc_tasa_cambio)					
			dw_master.Object.importe_doc [row] = wf_calcular_total ()
			
	 case 'cod_relacion'
	
			IF tab_1.tabpage_1.dw_detail.rowcount() > 0 THEN
				IF ls_prov_old <> data THEN
					wf_delete_doc_referencias ()
					dw_master.Object.importe_doc [row] = wf_calcular_total ()
					dw_master.ii_update = 1
				END IF
			END IF
					
			select count(*) into :ll_count from proveedor where (proveedor = :data) and flag_estado = '1' ;
			
			IF ll_count = 0 THEN
				SetNull(ls_prov)
				This.object.cod_relacion  [row] = ls_prov
				This.object.nom_proveedor [row] = ls_prov
				Messagebox('Aviso','Debe Ingresar Un Proveedor Valido , Verifique!')
				Return 1
			ELSE
				
				
				select nom_proveedor into :ls_nom from proveedor where (proveedor = :data);					
				
				This.object.nom_proveedor [row] = ls_nom
			END IF
	 case 'fecha_documento'
			ld_fecha_emision     = Date(This.Object.fecha_documento   [row])			
			ld_fecha_vencimiento	= Date(This.Object.fecha_vencimiento [row])			
			
			IF ld_fecha_emision > ld_fecha_vencimiento THEN
				This.Object.fecha_documento [row] = ld_fecha_emision_old
				Messagebox('Aviso','Fecha de Emisión del Documento No '&
										+'Puede Ser Mayor a la Fecha de Vencimiento')
				Return 1
			END IF
							
			ld_dias_a_canc   		= This.Object.dias_a_cancelar [row]
			IF Not(Isnull(ld_dias_a_canc) OR ld_dias_a_canc = 0) THEN //SI ES MAYOR QUE 0
				ld_fecha_vencimiento = RelativeDate (ld_fecha_emision, ld_dias_a_canc )
				This.Object.fecha_vencimiento [row] = ld_fecha_vencimiento				
			END IF	
	
			
			//Si es nuevo modifico el año y el mes
			if is_action = 'new' THEN
				This.Object.ano [row] = Long(String(ld_fecha_emision,'YYYY'))
				This.Object.mes [row] = Long(String(ld_fecha_emision,'MM'))
			end if
	
			
			This.Object.tasa_cambio	   [row] = gnvo_app.of_tasa_cambio(ld_fecha_emision)
			
			ldc_tasa_cambio = This.Object.tasa_cambio	   [row]
			
			
			/*ACTUALIZAR TASA DE CAMBIO DE DETALLE*/
			wf_update_tcambio_det(ldc_tasa_cambio)					
			dw_master.Object.importe_doc [row] = wf_calcular_total ()
			
			
	 CASE 'dias_a_cancelar'   
			ld_fecha_emision = Date(This.Object.fecha_documento   [row])
			ld_dias_a_canc   = This.Object.dias_a_cancelar [row]
			ld_fecha_vencimiento = RelativeDate (ld_fecha_emision, ld_dias_a_canc )
			This.Object.fecha_vencimiento [row] = ld_fecha_vencimiento				
			
	 CASE 'fecha_vencimiento'	
			ld_fecha_emision     = Date(This.Object.fecha_documento   [row])			
			ld_fecha_vencimiento	= Date(This.Object.fecha_vencimiento [row])			
			IF ld_fecha_vencimiento < ld_fecha_emision THEN
				This.Object.fecha_vencimiento [row] = ld_fecha_emision
				Messagebox('Aviso','Fecha de Vencimiento del Documento No '&
										+'Puede Ser Menor a la Fecha de Emisión')
				Return 1
			END IF
			
	CASE 'banco_ltr'
		  ls_flag_situacion = This.Object.flag_situacion_ltr [row]
		  IF ls_flag_situacion = '1' THEN
			  SetNull(ls_codigo)
			  This.Object.banco_ltr [row] = ls_codigo
			  Messagebox('Aviso','Si ubicacion de la letra esta en cartera no se debe ingresar codigo de banco ')
			  Return 1
		  END IF
		  
	CASE 'flag_situacion_ltr'
		  IF data = '1' THEN
			  SetNull(ls_codigo)
			  This.Object.banco_ltr [row] = ls_codigo
			  Return 1
		  END IF		
		  
	CASE 'confin'
		select cf.descripcion
			into :ls_data
		from concepto_financiero cf
		where cf.flag_estado = '1'
		  and cf.confin		= :data;

		if SQLCA.SQLCode = 100 then
			this.object.confin		[row] = gnvo_app.is_null
			this.object.desc_confin	[row] = gnvo_app.is_null
			MessageBox('Error', 'Codigo CONCEPTO FINANCIERO ' + ls_data + ' no existe o no esta activo, por favor verifique')
			return 1
		end if

		this.object.desc_confin			[row] = ls_data  
end choose
end event

event itemerror;call super::itemerror;Return 1
end event

event ue_insert_pre;call super::ue_insert_pre;DateTime	ldt_now

ldt_now = gnvo_app.of_fecha_Actual()

This.Object.origen		       	[al_row] = gs_origen
This.Object.tipo_doc		       	[al_row] = is_doc_ltc
This.Object.cod_usr		       	[al_row] = gs_user
This.Object.fecha_registro     	[al_row] = ldt_now
This.Object.fecha_documento    	[al_row] = date(ldt_now)
This.Object.tasa_cambio        	[al_row] = gnvo_app.of_tasa_cambio()
This.Object.ano				    	[al_row] = Long(String(f_fecha_actual(),'YYYY'))
This.Object.mes				    	[al_row] = Long(String(f_fecha_actual(),'MM'))
This.Object.flag_estado		    	[al_row] = '1'
This.Object.nro_ren_ltr  	    	[al_row] = 0
This.Object.flag_situacion_ltr 	[al_row] = '1'
This.Object.flag_tipo_ltr		 	[al_row] = 'C' //CANJE DE LETRAS
This.Object.flag_provisionado	 	[al_row] = 'R' //Provisionado Manualmente
This.Object.nro_libro	       	[al_row] = f_nro_libro(is_doc_ltc)

This.Object.confin	       		[al_row] = is_confin_ltc
This.Object.desc_confin      		[al_row] = is_desc_confin

is_action = 'new'

end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event ue_display;call super::ue_display;Date        		ld_fecha_emision,ld_fecha_vencimiento
Decimal 				ldc_tasa_cambio, ld_dias_a_canc
String      		ls_cod_relacion,ls_name,ls_prot, ls_SQL, ls_codigo, ls_data
str_seleccionar 	lstr_seleccionar
Datawindow 			ldw


CHOOSE CASE lower(as_columna)
	CASE 'cod_relacion'
		ls_sql = "SELECT distinct P.PROVEEDOR AS CODIGO_PROVEEDOR ,"&
				 + "P.NOM_PROVEEDOR AS razon_social ,"&
				 + "decode(p.tipo_doc_ident, '6', p.ruc, p.nro_doc_ident) as ruc_dni, "&
				 + "P.EMAIL			  AS EMAIL "&
				 + "FROM PROVEEDOR P, "&
				 + "     cntas_cobrar cc " &
				 + "WHERE p.proveedor = cc.cod_relacion " &
				 + "  and (cc.saldo_sol > 0 or cc.saldo_dol > 0) " &
				 + "  and p.FLAG_ESTADO = '1'"

		if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, '2') then
			
			IF idw_detail.Rowcount() > 0 THEN
				ls_cod_relacion = This.object.cod_relacion [al_row]
				IF ls_cod_relacion <> ls_codigo THEN
					wf_delete_doc_referencias()	
					dw_master.Object.importe_doc [al_row] = wf_calcular_total ()
					dw_master.ii_update = 1
				END IF
			
			END IF
			
			this.object.cod_relacion 	[al_row] = ls_codigo
			this.object.nom_proveedor 	[al_row] = ls_data
			this.ii_update = 1
			ib_estado_preas = TRUE
		end if		
		

	case "confin"
		ls_sql = "select cf.confin as confin, " &
				 + "cf.descripcion as descripcion_confin " &
				 + "from concepto_financiero cf " &
				 + "where cf.flag_estado = '1' " &
				 + "  and cf.confin like 'LTC%'"

		if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, '2') then
			this.object.confin			[al_row] = ls_codigo
			this.object.desc_confin		[al_row] = ls_data
			this.ii_update = 1
		end if		

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

