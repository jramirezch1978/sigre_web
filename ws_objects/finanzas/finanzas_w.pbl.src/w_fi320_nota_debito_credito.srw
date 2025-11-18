$PBExportHeader$w_fi320_nota_debito_credito.srw
forward
global type w_fi320_nota_debito_credito from w_abc
end type
type cb_1 from commandbutton within w_fi320_nota_debito_credito
end type
type tab_1 from tab within w_fi320_nota_debito_credito
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
type dw_referencias from u_dw_abc within tabpage_2
end type
type tabpage_2 from userobject within tab_1
dw_referencias dw_referencias
end type
type tabpage_3 from userobject within tab_1
end type
type dw_impuestos from u_dw_abc within tabpage_3
end type
type tabpage_3 from userobject within tab_1
dw_impuestos dw_impuestos
end type
type tabpage_4 from userobject within tab_1
end type
type dw_totales from u_dw_abc within tabpage_4
end type
type tabpage_4 from userobject within tab_1
dw_totales dw_totales
end type
type tabpage_5 from userobject within tab_1
end type
type dw_pre_asiento_det from u_dw_abc within tabpage_5
end type
type dw_pre_asiento_cab from u_dw_abc within tabpage_5
end type
type tabpage_5 from userobject within tab_1
dw_pre_asiento_det dw_pre_asiento_det
dw_pre_asiento_cab dw_pre_asiento_cab
end type
type tab_1 from tab within w_fi320_nota_debito_credito
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
tabpage_5 tabpage_5
end type
type dw_master from u_dw_abc within w_fi320_nota_debito_credito
end type
end forward

global type w_fi320_nota_debito_credito from w_abc
integer width = 4494
integer height = 2228
string title = "Nota de Debito / Credito (FI320)"
string menuname = "m_mantenimiento_cl_anular"
event ue_anular ( )
event ue_find_exact ( )
event ue_print_detra ( )
event ue_print_voucher ( )
cb_1 cb_1
tab_1 tab_1
dw_master dw_master
end type
global w_fi320_nota_debito_credito w_fi320_nota_debito_credito

type variables
Boolean 			 	ib_estado_prea = TRUE	//Pre Asiento No editado					

DatawindowChild 	idw_tasa ,idw_doc_tipo ,idw_forma_pago
DataStore       		ids_pre_asiento_det,	ids_voucher         ,ids_formato_det
String					is_NDP

u_dw_abc					idw_detail, idw_referencias, idw_impuestos, idw_asiento_cab, idw_asiento_det

boolean						ib_modif_dtrp		
n_cst_asiento_contable	invo_asiento_cntbl
n_cst_detraccion			invo_detraccion
n_cst_cntas_pagar			invo_cntas_pagar
end variables

forward prototypes
public subroutine wf_generacion_imp (string as_item)
public function decimal wf_totales ()
public subroutine of_asigna_dws ()
public subroutine of_calcular_detraccion ()
public subroutine of_retrieve (string as_cod_relacion, string as_tipo_doc, string as_nro_doc)
public function integer of_get_param ()
public subroutine of_modify_detail ()
public function boolean of_genera_asiento_cntbl ()
public function boolean of_verifica_flag_cntas (string as_cnta_cntbl, string as_tipo_doc, string as_nro_doc, string as_cod_relacion, long al_row)
end prototypes

event ue_anular;String  ls_flag_estado,ls_origen,ls_tipo_doc,ls_nro_doc
Long    ll_row,ll_row_pasiento,ll_inicio,ll_count
Integer li_opcion


dw_master.Accepttext()
idw_detail.Accepttext()
idw_referencias.Accepttext()
idw_impuestos.Accepttext()
idw_asiento_cab.Accepttext()
idw_asiento_det.Accepttext()
	 
ll_row = dw_master.Getrow()

IF ll_row = 0 OR is_action = 'new' THEN RETURN 

ls_flag_estado = dw_master.object.flag_estado[ll_row]
ls_origen   	= dw_master.object.origen   [ll_row]
ls_tipo_doc 	= dw_master.object.tipo_doc [ll_row]
ls_nro_doc  	= dw_master.object.nro_doc  [ll_row]

IF Not(ls_flag_estado = '1' OR ls_flag_estado = '0') THEN RETURN 

IF (dw_master.ii_update 		= 1 OR &
	 idw_detail.ii_update 		= 1 OR &
	 idw_referencias.ii_update = 1 OR &
	 idw_impuestos.ii_update 	= 1 OR &
	 idw_asiento_cab.ii_update = 1 OR &
	 idw_asiento_det.ii_update = 1 ) THEN
	 
	 Messagebox('Aviso','Grabe Los Cambios Antes de Anular el Documento', StopSign!)
	 RETURN
	 
END IF

li_opcion = MessageBox('Anula Nota Debito Credito x Pagar','Esta Seguro de Anular el comprobante ' + ls_tipo_doc + '/' + ls_nro_doc,Question!, Yesno!, 2)

IF li_opcion = 2 THEN RETURN



/*Verifica Si ha tenido Transaciones*/
SELECT Count(*)
  INTO :ll_count
  FROM doc_referencias
 WHERE (origen_ref = :ls_origen   ) AND
 		 (tipo_ref   = :ls_tipo_doc ) AND
		 (nro_ref	 = :ls_nro_doc  ) ;
/**/

IF ll_count > 0 THEN
	Messagebox('Aviso','Documento esta referenciada en otro comprobante ya registrado, por favor Verifique!')
   Return
END IF

/*Elimino Cabecera de Nota Debito Credito x Pagar*/
DO WHILE dw_master.Rowcount() > 0
	dw_master.Deleterow(0)
	dw_master.ii_update = 1
LOOP

/*Elimino detalle de Nota Debito Credito x Pagar*/
DO WHILE idw_detail.Rowcount() > 0
	idw_detail.Deleterow(0)
	idw_detail.ii_update = 1
LOOP

/*Elimino Impuesto de Nota Debito Credito x Pagar*/
DO WHILE idw_impuestos.Rowcount() > 0
	idw_impuestos.Deleterow(0)
	idw_impuestos.ii_update = 1
LOOP

/*Elimino documentos de Referencias*/
DO WHILE idw_referencias.Rowcount() > 0
	idw_referencias.Deleterow(0)
	idw_referencias.ii_update = 1
LOOP

//Cabecera de Asiento
idw_asiento_cab.Object.flag_estado	 [1] = '0'
idw_asiento_cab.Object.tot_solhab	 [1] = 0.00
idw_asiento_cab.Object.tot_dolhab	 [1] = 0.00
idw_asiento_cab.Object.tot_soldeb	 [1] = 0.00
idw_asiento_cab.Object.tot_doldeb    [1] = 0.00
idw_asiento_cab.ii_update = 1

//Detalle de Asiento
FOR ll_inicio = 1 TO idw_asiento_det.Rowcount()
  	idw_asiento_det.Object.imp_movsol [ll_inicio] = 0.00
  	idw_asiento_det.Object.imp_movdol [ll_inicio] = 0.00	
	idw_asiento_det.ii_update = 1
NEXT



is_action = 'anular'
//* Inicialización de Variables de Modificación de Data *//
dw_master.ii_update  		= 1
idw_detail.ii_update 	   = 1
idw_referencias.ii_update  = 1
idw_impuestos.ii_update  	= 1
idw_asiento_cab.ii_update 	= 1
idw_asiento_det.ii_update 	= 1


ib_estado_prea = FALSE   //Autogeneración de Pre Asientos

dw_master.ii_protect 		= 0
idw_detail.ii_protect 		= 0
idw_referencias.ii_protect = 0
idw_impuestos.ii_protect 	= 0
idw_asiento_cab.ii_protect = 0
idw_asiento_det.ii_protect = 0

dw_master.of_protect()
idw_detail.of_protect()
idw_referencias.of_protect()
idw_impuestos.of_protect()
idw_asiento_cab.of_protect()
idw_asiento_det.of_protect()
end event

event ue_print_detra();String ls_nro_detrac

IF dw_master.getrow() = 0 THEN
	Messagebox('Aviso','No existe Registro Verifique!')
	Return
END IF

ls_nro_detrac = dw_master.object.nro_detraccion[dw_master.getrow()]

IF Isnull(ls_nro_detrac) OR Trim(ls_nro_detrac) = '' THEN
	Messagebox('Aviso','No existe Detraccion Verifique!')
END IF

ids_formato_det.Retrieve(ls_nro_detrac)
ids_formato_det.object.t_nombre.text = gs_empresa
ids_formato_det.object.t_user.text = gs_user
ids_formato_det.Print(True)
end event

event ue_print_voucher();String ls_origen
Long   ll_ano,ll_mes,ll_nro_libro,ll_nro_asiento
str_parametros lstr_param

IF dw_master.RowCount() = 0 or dw_master.GetRow() = 0 THEN
	f_mensaje('No existe Registro en la cabecera del documento, Verifique!', 'FIN_NOT_DOC')
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
	lstr_param.dw1 		= 'd_rpt_voucher_imp_cp_tbl'
	lstr_param.titulo 	= 'Previo de Voucher'
	lstr_param.string1 	= ls_origen
	lstr_param.integer1 	= ll_ano
	lstr_param.integer2 	= ll_mes
	lstr_param.integer3 	= ll_nro_libro
	lstr_param.integer4 	= ll_nro_asiento
	lstr_param.string2	= gs_empresa
	lstr_param.titulo		= "Provisión de Cuentas x Pagar"
	lstr_param.tipo		= '1S1I2I3I4I2S'
	

	OpenSheetWithParm(w_rpt_preview, lstr_param, w_main, 0, Layered!)
end if

end event

public subroutine wf_generacion_imp (string as_item);String      ls_item,ls_expresion
Long 			ll_inicio,ll_found
Decimal {2} ldc_total,ldc_tasa_impuesto


ls_expresion = 'item = '+as_item

idw_impuestos.Setfilter(ls_expresion)
idw_impuestos.filter()
Setnull(ls_expresion)
	
FOR ll_inicio = 1 TO idw_impuestos.Rowcount()
	 idw_impuestos.ii_update = 1
	 ls_item		  = Trim(String(idw_impuestos.object.item [ll_inicio]))
	 ls_expresion = 'item = ' + ls_item
	 ll_found 	  = idw_detail.find(ls_expresion ,1,idw_detail.rowcount())
	 IF ll_found > 0 THEN
		 ldc_tasa_impuesto = idw_impuestos.object.tasa_impuesto [ll_inicio]
		 ldc_total			 = idw_detail.object.total		        [ll_found]
		 idw_impuestos.object.importe [ll_inicio] = Round((ldc_total * ldc_tasa_impuesto ) / 100 ,2)
	 END IF			 
NEXT
	
idw_impuestos.Setfilter('')
idw_impuestos.filter()


idw_impuestos.SetSort('item a')
idw_impuestos.Sort()


end subroutine

public function decimal wf_totales ();Long 	  ll_inicio
String  ls_signo
Decimal {2} ldc_impuesto        = 0.00, ldc_total_imp     = 0.00 ,ldc_bruto = 0.00 , &
		      ldc_total_bruto     = 0.00, ldc_total_general = 0.00


tab_1.tabpage_4.dw_totales.Reset()
tab_1.tabpage_4.dw_totales.Insertrow(0)



FOR ll_inicio = 1 TO idw_detail.Rowcount()
	
	 ldc_bruto 		= Round(idw_detail.object.total [ll_inicio],2)
	 
	 IF isnull(ldc_bruto)     THEN ldc_bruto     = 0 		 
	 
	 ldc_total_bruto 		= ldc_total_bruto + ldc_bruto
	 
NEXT


FOR ll_inicio = 1 TO idw_impuestos.Rowcount()
	
	 ldc_impuesto = idw_impuestos.Object.importe [ll_inicio]
	 ls_signo	  = idw_impuestos.Object.signo   [ll_inicio]
	 
	 IF Isnull(ldc_impuesto) THEN ldc_impuesto = 0 
		 IF     ls_signo = '+' THEN
			 ldc_total_imp = ldc_total_imp + ldc_impuesto 
	 ELSEIF ls_signo = '-' THEN
		 ldc_total_imp = ldc_total_imp - ldc_impuesto 
	 END IF
NEXT


tab_1.tabpage_4.dw_totales.object.bruto 	 [1] = ldc_total_bruto
tab_1.tabpage_4.dw_totales.object.impuesto [1] = ldc_total_imp


ldc_total_general = ldc_total_bruto + ldc_total_imp




Return ldc_total_general

end function

public subroutine of_asigna_dws (); //idw_detail, idw_referencias, idw_impuestos, idw_asiento_cab, idw_asiento_det
 
idw_detail 			= tab_1.tabpage_1.dw_detail
idw_referencias	= tab_1.tabpage_2.dw_referencias
idw_impuestos		= tab_1.tabpage_3.dw_impuestos
idw_asiento_cab	= tab_1.tabpage_5.dw_pre_asiento_cab
idw_asiento_det	= tab_1.tabpage_5.dw_pre_asiento_det

end subroutine

public subroutine of_calcular_detraccion ();//Actualizo el importe de la detraccion
decimal 	ldc_total, ldc_tasa_cambio, ldc_imp_soles, ldc_porc_detr
string	ls_moneda

if dw_master.getRow() = 0 then return

if ib_modif_dtrp = true then return

ldc_total = wf_totales ()
if dw_master.object.flag_detraccion [1] = '1' then
	
	ldc_tasa_cambio = Dec(dw_master.object.tasa_cambio [1])
	ls_moneda		 = dw_master.object.cod_moneda	[1]
	ldc_porc_detr	 = Dec(dw_master.object.porc_detraccion [1])
	
	if ls_moneda = gnvo_app.is_soles then
		ldc_imp_soles = round(ldc_total * ldc_porc_detr/ 100,invo_detraccion.of_nro_decimales())
	else
		ldc_total 	  = ldc_total * ldc_tasa_cambio
		ldc_imp_soles = round(ldc_total * ldc_porc_detr/ 100,invo_detraccion.of_nro_decimales())
	end if
	
	dw_master.object.imp_detraccion [1] = ldc_imp_soles
	dw_master.ii_update = 1

end if

end subroutine

public subroutine of_retrieve (string as_cod_relacion, string as_tipo_doc, string as_nro_doc);Long 		ll_year, ll_mes, ll_nro_libro, ll_nro_asiento, ll_inicio
String	ls_origen, ls_motivo, ls_tipo_doc

dw_master.Retrieve(as_cod_relacion, as_tipo_doc, as_nro_doc)

if dw_master.RowCount() > 0 then
	
	ls_origen 		= dw_master.object.origen 				[1]
	ll_year			= Long(dw_master.object.ano			[1])
	ll_mes			= Long(dw_master.object.mes			[1])
	ll_nro_libro	= Long(dw_master.object.nro_libro	[1])
	ll_nro_asiento	= Long(dw_master.object.nro_Asiento	[1])
	
	idw_detail.Retrieve(as_cod_relacion, as_tipo_doc, as_nro_doc)
	idw_referencias.Retrieve(as_cod_relacion, as_tipo_doc, as_nro_doc)
	idw_impuestos.Retrieve(as_cod_relacion, as_tipo_doc, as_nro_doc)
	idw_asiento_cab.Retrieve(ls_origen, ll_year, ll_mes, ll_nro_libro, ll_nro_asiento)
	idw_asiento_det.Retrieve(ls_origen, ll_year, ll_mes, ll_nro_libro, ll_nro_asiento)

	dw_master.ii_protect = 0
	idw_detail.ii_protect = 0
	idw_referencias.ii_protect = 0
	idw_impuestos.ii_protect = 0
	idw_asiento_cab.ii_protect = 0
	idw_asiento_det.ii_protect = 0
	
	dw_master.of_protect()
	idw_detail.of_protect()
	idw_referencias.of_protect()
	idw_impuestos.of_protect()
	idw_asiento_cab.of_protect()
	idw_asiento_det.of_protect()
	
	dw_master.ResetUpdate()
	idw_detail.ResetUpdate()
	idw_referencias.ResetUpdate()
	idw_impuestos.ResetUpdate()
	idw_asiento_cab.ResetUpdate()
	idw_asiento_det.ResetUpdate()
	
	dw_master.ii_update = 0
	idw_detail.ii_update = 0
	idw_referencias.ii_update = 0
	idw_impuestos.ii_update = 0
	idw_asiento_cab.ii_update = 0
	idw_asiento_det.ii_update = 0
	
	ib_estado_prea = False   //pre-asiento editado					

	is_action = 'fileopen'	

end if
end subroutine

public function integer of_get_param ();SELECT nota_deb_ncc
	INTO :is_NDP
FROM finparam
WHERE reckey = '1';

if IsNull(is_NDP) or trim(is_NDP) = "" then
	gnvo_app.of_mensaje_error( "No ha especificado la nota de DEbido por Pagar, por favor confirme")
	return 0
end if

return 1
end function

public subroutine of_modify_detail ();//Detalle de Documento
idw_detail.Modify("cod_art.Protect='1~tIf(IsNull(flag_hab),0,1)'")
//idw_detail.Modify("descripcion.Protect='1~tIf(IsNull(flag_hab),0,1)'")
idw_detail.Modify("cantidad.Protect='1~tIf(IsNull(flag_hab),0,1)'")
idw_detail.Modify("importe.Protect='1~tIf(IsNull(flag_hab),0,1)'")
//idw_detail.Modify("confin.Protect='1~tIf(IsNull(flag_hab),0,1)'")
idw_detail.Modify("cencos.Protect='1~tIf(IsNull(flag_hab),0,1)'")
idw_detail.Modify("cnta_prsp.Protect='1~tIf(IsNull(flag_hab),0,1)'")
idw_detail.Modify("tipo_cred_fiscal.Protect='1~tIf(IsNull(flag_hab),0,1)'")
//Impuestos
idw_impuestos.Modify("tipo_impuesto.Protect='1~tIf(IsNull(flag),0,1)'")
idw_impuestos.Modify("importe.Protect='1~tIf(IsNull(flag),0,1)'")

end subroutine

public function boolean of_genera_asiento_cntbl ();String  ls_cod_relacion,ls_motivo, &
		  ls_cencos,ls_moneda,ls_cebef
Long    ll_inicio
Boolean lb_ret  = FALSE
Decimal ldc_tasa_cambio


ldc_tasa_cambio  = dw_master.object.tasa_cambio	 [1]
ls_cod_relacion  = dw_master.object.cod_relacion [1]
ls_moneda		  = dw_master.object.cod_moneda   [1]
ls_motivo  		  = dw_master.object.motivo       [1]

IF Isnull(ls_cod_relacion) OR Trim(ls_cod_relacion) = '' THEN
	Messagebox('Aviso','Debe Ingresar Codigo de Proveedor, Verifique!')
	dw_master.SetFocus()
	dw_master.SetColumn('cod_relacion')
	return false
END IF

IF Isnull(ls_moneda) OR Trim(ls_moneda) = '' THEN
	Messagebox('Aviso','Debe Ingresar Codigo de Moneda, Verifique!')
	dw_master.SetFocus()
	return false
END IF

IF Isnull(ldc_tasa_cambio) OR ldc_tasa_cambio = 0 THEN
	Messagebox('Aviso','Debe Ingresar Tasa de Cambio de Documento a Generar, Verifique!')
	dw_master.SetFocus()
	dw_master.SetColumn('tasa_cambio')
	return false
END IF

IF Isnull(ls_motivo) OR Trim(ls_motivo) = '' THEN
	Messagebox('Aviso','Debe Ingresar Motivo de Documento a Generar, Verifique!')
	dw_master.SetFocus()
	dw_master.SetColumn('motivo')
	return false
END IF

//Verificación de Data en Detalle de Documento
IF not gnvo_app.of_row_Processing(idw_detail) then return false

/*Ejecuto Función*/
if not invo_asiento_Cntbl.of_Generar_asiento_ncp_ndp( dw_master, &
																		idw_detail, idw_referencias, &
															  			idw_impuestos,   &
															  			idw_asiento_cab, &
															  			idw_asiento_det, &
															  			tab_1) then return false

idw_asiento_det.ii_update = 1

return true
end function

public function boolean of_verifica_flag_cntas (string as_cnta_cntbl, string as_tipo_doc, string as_nro_doc, string as_cod_relacion, long al_row);String  ls_flag_ctabco,ls_flag_cencos,ls_flag_doc_ref,ls_flag_cod_rel,ls_flag_cebef

IF f_cntbl_cnta(as_cnta_cntbl,ls_flag_ctabco,ls_flag_cencos,ls_flag_doc_ref, &
					 ls_flag_cod_rel,ls_flag_cebef)  THEN


	IF ls_flag_ctabco = '1' THEN
		Messagebox('Aviso','Campo No Ha Sido Definido , Cuenta de Banco')
	   return false
	END IF

	IF ls_flag_doc_ref = '1' THEN
		If IsNull(idw_asiento_det.object.tipo_docref1 	[al_row]) or  &
			IsNull(idw_asiento_det.object.nro_docref1 	[al_row]) or  &
			trim(idw_asiento_det.object.tipo_docref1 		[al_row]) = "" or &  
			trim(idw_asiento_det.object.nro_docref1 		[al_row]) = "" then
			
			Messagebox('Aviso','Cuenta Contable ' + as_cnta_cntbl + ' pide documento de referencia y no se ha colocado ninguno', StopSign!)
	   	return false
		end if
	END IF

	IF ls_flag_cod_rel = '1' THEN
		If IsNull(idw_asiento_det.object.cod_relacion 	[al_row]) or  &
			trim(idw_asiento_det.object.cod_relacion 		[al_row]) = "" then
			
			Messagebox('Aviso','Cuenta Contable ' + as_cnta_cntbl + ' pide Código de Relacion y no se ha colocado ninguno', StopSign!)
	   	return false
		end if
	END IF	
	
else
	
	return false
	
END IF

return true
end function

on w_fi320_nota_debito_credito.create
int iCurrent
call super::create
if this.MenuName = "m_mantenimiento_cl_anular" then this.MenuID = create m_mantenimiento_cl_anular
this.cb_1=create cb_1
this.tab_1=create tab_1
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.tab_1
this.Control[iCurrent+3]=this.dw_master
end on

on w_fi320_nota_debito_credito.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.tab_1)
destroy(this.dw_master)
end on

event ue_open_pre;call super::ue_open_pre;of_asigna_dws()

dw_master.SettransObject(sqlca)
idw_detail.SettransObject(sqlca)
idw_referencias.SettransObject(sqlca)
idw_impuestos.SettransObject(sqlca)
idw_asiento_cab.SettransObject(sqlca)
idw_asiento_det.SettransObject(sqlca)


//** Datastore Detalle Pre Asiento **//
ids_pre_asiento_det 			   = Create Datastore
ids_pre_asiento_det.DataObject = 'd_pre_asientos_doc_tbl'
ids_pre_asiento_det.SettransObject(sqlca)
////** **//


//** Datastore Voucher **//
ids_voucher = Create Datastore
ids_voucher.DataObject = 'd_rpt_voucher_imp_cp_tbl'
ids_voucher.SettransObject(sqlca)


//** Datastore Formato Detraccion **//
ids_formato_det = Create Datastore
ids_formato_det.DataObject = 'd_rpt_formato_detraccion_x_pagar_tbl'
ids_formato_det.SettransObject(sqlca)
////** **//


//** Insertamos GetChild de Tipo de Documento dw_master **//
dw_master.Getchild('tipo_doc',idw_doc_tipo )
idw_doc_tipo.settransobject(sqlca)
idw_doc_tipo.Retrieve()
//** **//

//** Insertamos GetChild de Forma de Pago **//
dw_master.Getchild('forma_pago',idw_forma_pago)
idw_forma_pago.settransobject(sqlca)
idw_forma_pago.Retrieve()
//** **//

//** Insertamos GetChild de Tasa de Impuesto Tab 3 **//
idw_impuestos.Getchild('tipo_impuesto',idw_tasa )
idw_tasa.settransobject(sqlca)
idw_tasa.Retrieve()
//** **//

idw_1 = dw_master              								// asignar dw corriente
idw_detail.BorderStyle = StyleRaised!	// indicar dw_detail como no activado

////ii_help = 101           					// help topic
	
invo_asiento_cntbl = create n_cst_asiento_contable	
invo_detraccion	 = create n_cst_detraccion
invo_cntas_pagar 	 = create n_cst_cntas_pagar
end event

event ue_insert;String  ls_flag_estado,ls_cod_moneda,ls_motivo
Long    ll_row,ll_currow
Boolean lb_result

ll_row = dw_master.Getrow()

CHOOSE CASE idw_1
	 	 CASE dw_master
				TriggerEvent('ue_update_request')
				idw_1.Reset()
				idw_detail.Reset ()
				idw_referencias.Reset ()
				idw_impuestos.Reset	 ()
//				tab_1.tabpage_4.dw_totales.Reset()
				tab_1.tabpage_5.dw_pre_asiento_cab.Reset ()
				idw_asiento_det.Reset ()
				is_action = 'new'
				ib_estado_prea = TRUE   //Pre Asiento No editado  Autogeneración
				
 		 CASE idw_detail
			
				Messagebox('Aviso','No esta permitido añadir registros directamente en el detalle de una Nota de Credito o DEbito, por favor jale la referencia', StopSign!)
				Return
				/*
				
				ls_flag_estado = dw_master.object.flag_estado [ll_row]
				ls_cod_moneda  = dw_master.object.cod_moneda  [ll_row]
				ls_motivo		= dw_master.object.motivo      [ll_row]
				
				IF ls_flag_estado <> '1'  THEN RETURN //Documento Ha sido Anulado o facturado
				IF Isnull(ls_cod_moneda) OR Trim(ls_cod_moneda) = '' THEN
					Messagebox('Aviso','Debe Seleccionar Un Documento de Referencia')
					Return
				END IF
				
				IF Isnull(ls_motivo) OR Trim(ls_motivo) = '' THEN
					Messagebox('Aviso','Debe Seleccionar Un Motivo del Documento A Generar')
					Return
				ELSEIF ls_motivo  = 'NCP002' THEN //Reversión de Documentos
					Messagebox('Aviso','Cuando Motivo de Documento de es Reversión No se Puede '&
											+'Ingresar Registros en el detalle ')
					Return
				END IF
				*/
				
				ib_estado_prea = TRUE   //Pre Asiento No editado  Autogeneración
	 	 CASE idw_impuestos
				ll_currow = idw_detail.GetRow()
				lb_result = idw_detail.IsSelected(ll_currow)
				ls_motivo		= dw_master.object.motivo      [ll_row]
				ls_flag_estado = dw_master.object.flag_estado [ll_row]
				
				IF ls_flag_estado <> '1' THEN RETURN //Documento Ha sido Anulado o facturado

				IF lb_result = FALSE then
					Messagebox('Aviso','Debe Seleccionar Un documento para generar su Respectivo Interes')
					Return
				END IF
				
				IF Isnull(ls_motivo) OR Trim(ls_motivo) = '' THEN
					Messagebox('Aviso','Debe Seleccionar Un Motivo del Documento A Generar')
					Return
				ELSEIF ls_motivo  = 'NCP002' THEN //Reversión de Documentos
					Messagebox('Aviso','Cuando Motivo de Documento de es Reversión, No se Puede '&
											+'Ingresar Registros en Impuestos ')
					Return
				END IF
				
				
				ib_estado_prea = TRUE    //Pre Asiento No editado	Autogeneración				
				/**/
		 CASE	ELSE
				Return
END CHOOSE

ll_row = idw_1.Event ue_insert()
IF idw_1 = dw_master THEN
	idw_1.Setcolumn('cod_relacion')
END IF

IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)
end event

event resize;call super::resize;of_asigna_dws()

tab_1.width  = newwidth  - tab_1.x - 10
tab_1.height = newheight - tab_1.y - 10

idw_detail.width       = tab_1.tabpage_1.width  - idw_detail.x - 10
idw_detail.height      = tab_1.tabpage_1.height - idw_detail.y - 10

idw_referencias.width  = tab_1.tabpage_2.width - idw_referencias.x  - 10
idw_referencias.height = tab_1.tabpage_2.height - idw_referencias.y - 10

idw_impuestos.width   =  tab_1.tabpage_3.width - idw_impuestos.x  - 10
idw_impuestos.height  =  tab_1.tabpage_3.height - idw_impuestos.y  - 10


tab_1.tabpage_4.dw_totales.width  = tab_1.tabpage_4.width   - tab_1.tabpage_4.dw_totales.x - 10
tab_1.tabpage_4.dw_totales.height = tab_1.tabpage_4.height  - tab_1.tabpage_4.dw_totales.y - 10

idw_asiento_det.width  = tab_1.tabpage_5.width   - idw_asiento_det.x - 10
idw_asiento_det.height = tab_1.tabpage_5.height  - idw_asiento_det.y - 10
end event

event ue_insert_pos(long al_row);call super::ue_insert_pos;IF idw_1 = dw_master THEN
	tab_1.tabpage_5.dw_pre_asiento_cab.TriggerEvent('ue_insert')
END IF
end event

event ue_delete();//override
Long   ll_row,ll_row_master
String ls_flag_estado,ls_motivo,ls_item,ls_expresion_imp

ll_row = idw_1.Getrow()
ll_row_master = dw_master.Getrow()

IF ll_row_master = 0 THEN Return

ls_flag_estado = dw_master.Object.flag_estado [ll_row_master]
ls_motivo		= dw_master.Object.motivo		 [ll_row_master]


IF ls_flag_estado <> '1' THEN
	Messagebox('Aviso','Documento Se Encuentra en un estado Distinto a Generado, Verifique!')
	Return
END IF

CHOOSE CASE idw_1
		 CASE idw_detail
				IF ls_motivo = '000003' THEN //Reversion de Documentos
					Messagebox('Aviso','No se Puede Eliminar Registro en detalle '&
											+'Por que es una Reversión de Documento , Elimine Documento de Referencia')
					Return 											
				END IF
				
				//Eliminar impuesto del item a eliminar
				ls_item			   = Trim(String(idw_detail.object.item [ll_row]))
				ls_expresion_imp = 'item = '+ls_item
				
				idw_impuestos.SetFilter(ls_expresion_imp)
				idw_impuestos.Filter()
				
			   DO WHILE idw_impuestos.Rowcount() > 0 
				   idw_impuestos.deleterow(0)
					idw_impuestos.ii_update = 1
 			   LOOP
				 
  			   idw_impuestos.SetFilter('')
				idw_impuestos.Filter()
				
	    CASE idw_referencias
			
				IF ls_motivo = '000003' THEN //Reversión de Documentos			
					/*Elimino Items en el Detalle*/
					DO WHILE idw_detail.Rowcount() > 0
						idw_detail.deleteRow(0)
						idw_detail.ii_update = 1
					LOOP
					
					/*Elimino Impuesto de Items */
					DO WHILE idw_impuestos.Rowcount() > 0
						idw_impuestos.deleteRow(0)
						idw_impuestos.ii_update = 1
					LOOP
				END IF
				
		 CASE dw_master
				Return	
					
END CHOOSE




ll_row = idw_1.Event ue_delete()

IF ll_row = 1 THEN
	THIS.Event ue_delete_list()
	THIS.Event ue_delete_pos(ll_row)
	ib_estado_prea = TRUE //Genración Automaticas de Pre Asientos	
END IF

end event

event ue_delete_pos(long al_row);call super::ue_delete_pos;/*Actualiza Master*/
dw_master.object.total_pagar [1] = wf_totales()
dw_master.ii_update = 1
/**/

end event

event ue_update_request();//OVERRIDE
Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
IF (dw_master.ii_update = 1 						 		  OR idw_detail.ii_update          = 1 OR &
	 idw_referencias.ii_update     = 1 OR idw_impuestos.ii_update       = 1 OR &
	 tab_1.tabpage_5.dw_pre_asiento_cab.ii_update = 1 OR idw_asiento_det.ii_update = 1 )THEN
	 
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	IF li_msg_result = 1 THEN
 		this.TriggerEvent("ue_update")
	ELSE
		dw_master.ii_update = 0
		idw_detail.ii_update				= 0
	   idw_referencias.ii_update		= 0 
	   idw_impuestos.ii_update			= 0 
		tab_1.tabpage_5.dw_pre_asiento_cab.ii_update = 0 
	   idw_asiento_det.ii_update = 0 
	END IF
END IF

end event

event ue_update;call super::ue_update;Boolean lbo_ok = TRUE
Long    ll_row_det,ll_ano,ll_mes,ll_nro_libro,ll_nro_asiento
String  ls_origen

dw_master.AcceptText()
idw_detail.AcceptText()
idw_referencias.AcceptText()
idw_impuestos.AcceptText()
idw_asiento_cab.AcceptText()
idw_asiento_det.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN 
	Rollback ;
	RETURN
END IF

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

if ib_log then
	dw_master.of_create_log()
	idw_detail.of_create_log()
	idw_referencias.of_create_log()
	idw_impuestos.of_create_log()
	idw_asiento_cab.of_create_log()
	idw_asiento_det.of_create_log()
end if

IF idw_asiento_cab.ii_update = 1 AND lbo_ok = TRUE  THEN         
	IF idw_asiento_cab.Update(true, false) = -1 then		// Grabacion Pre - Asiento Cabecera
		lbo_ok = FALSE
		Messagebox("Error en Grabacion dw_asiento_cab","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF idw_asiento_det.ii_update = 1 AND lbo_ok = TRUE  THEN
	IF idw_asiento_det.Update(true, false) = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		Messagebox("Error en Grabacion dw_asiento_det","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF is_action <> 'delete' and is_action <> 'anular' THEN
	IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
		IF dw_master.Update(true, false) = -1 then		// Grabación Cabecera de Ctas x Pagar
			lbo_ok = FALSE
			Messagebox('Error en Grabación de dw_master','Se ha procedido al rollback',exclamation!)
		END IF
	END IF

	IF	idw_referencias.ii_update = 1 AND lbo_ok = TRUE THEN
		IF idw_referencias.Update(true, false) = -1 then		// Grabacion de Doc Referencias
			lbo_ok = FALSE
			Messagebox('Error en Grabacion Doc Referencias','Se ha procedido al rollback',exclamation!)
		END IF
	END IF


	IF	idw_detail.ii_update = 1 AND lbo_ok = TRUE THEN
		IF idw_detail.Update(true, false) = -1 then		// Grabacion de Doc Referencias
			lbo_ok = FALSE
			Messagebox('Error en Grabacion de Detalle de Ctas x Pagar ','Se ha procedido al rollback',exclamation!)
		END IF
	END IF

	IF idw_impuestos.ii_update = 1 AND lbo_ok = TRUE THEN
		IF idw_impuestos.Update (true, false) = -1 then //Grabacion de Impuestos
			lbo_ok = FALSE
			Messagebox('Error en Grabacion de Impuestos ','Se ha procedido al rollback',exclamation!)
		END IF
	END IF
	
ELSE
	
	IF idw_impuestos.ii_update = 1 AND lbo_ok = TRUE THEN
		IF idw_impuestos.Update (true, false) = -1 then //Grabacion de Impuestos
			lbo_ok = FALSE
			Messagebox('Error en Grabacion de Impuestos ','Se ha procedido al rollback',exclamation!)
		END IF
	END IF	


	IF	idw_referencias.ii_update = 1 AND lbo_ok = TRUE THEN
		IF idw_referencias.Update(true, false) = -1 then		// Grabacion de Doc Referencias
			lbo_ok = FALSE
			Messagebox('Error en Grabacion Doc Referencias','Se ha procedido al rollback',exclamation!)
		END IF
	END IF


	IF	idw_detail.ii_update = 1 AND lbo_ok = TRUE THEN
		IF idw_detail.Update(true, false) = -1 then		// Grabacion de Doc Referencias
			lbo_ok = FALSE
			Messagebox('Error en Grabacion de Detalle de Ctas x Pagar ','Se ha procedido al rollback',exclamation!)
		END IF
	END IF

	IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
		IF dw_master.Update(true, false) = -1 then		// Grabación Cabecera de Ctas x Pagar
			lbo_ok = FALSE
			Messagebox('Error en Grabación de Cabecera de Ctas x Pagar','Se ha procedido al rollback',exclamation!)
		END IF
	END IF
END IF

if ib_log then
	if lbo_ok then
		lbo_ok = dw_master.of_save_log()
	end if
	if lbo_ok then
		lbo_ok = idw_detail.of_save_log()
	end if
	if lbo_ok then
		lbo_ok = idw_referencias.of_save_log()
	end if
	if lbo_ok then
		lbo_ok = idw_impuestos.of_save_log()
	end if
	if lbo_ok then
		lbo_ok = idw_asiento_cab.of_save_log()
	end if
	if lbo_ok then
		lbo_ok = idw_asiento_det.of_save_log()
	end if
end if

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update 			= 0
	idw_detail.ii_update 		= 0
	idw_referencias.ii_update 	= 0
	idw_impuestos.ii_update 	= 0
	idw_asiento_cab.ii_update 	= 0
	idw_asiento_det.ii_update 	= 0
	
	dw_master.ResetUpdate()
	idw_detail.ResetUpdate()
	idw_referencias.ResetUpdate()
	idw_impuestos.ResetUpdate()
	idw_asiento_cab.ResetUpdate()
	idw_asiento_det.ResetUpdate()

	ib_estado_prea = False   //pre-asiento editado					
	is_action = 'fileopen'
	TriggerEvent('ue_modify')
	f_mensaje("Cambios Guardados Satisfactoriamente", "")
ELSE 
	ROLLBACK USING SQLCA;
END IF



end event

event ue_update_pre;Long    ll_nro_libro, ll_nro_asiento , ll_inicio,ll_year,ll_mes,ll_count
String  ls_periodo    ,ls_flag_estado 		,ls_tipo_doc  		 ,ls_nro_doc  ,ls_cod_relacion   ,&
		  ls_cnta_ctbl	 ,ls_cod_origen  		,ls_cod_moneda		 ,&
		  ls_flag_detraccion ,ls_nro_detraccion ,ls_const_dep	 ,ls_cta_cte		  ,&
		  ls_bien_serv	 ,ls_oper				,ls_obs
Date    ld_last_day,ldt_fecha_dep, ld_fec_emision, ld_fecha_dep
Decimal 	ldc_totsoldeb = 0.00,ldc_totdoldeb   = 0.00,ldc_totsolhab      = 0.00, &
			ldc_totdolhab = 0.00,ldc_importe_imp = 0.00,ldc_porc_ret_x_doc = 0.00, &
			ldc_monto_doc         ,ldc_saldo_sol				, &
			ldc_saldo_dol		  ,ldc_porc_detrac	    ,ldc_monto_detrac			, &
			ldc_tasa_cambio
Long     li_opcion
str_parametros 	lstr_param

try 
	
	/*Replicacion*/
	dw_master.of_set_flag_replicacion ()
	idw_detail.of_set_flag_replicacion ()
	idw_referencias.of_set_flag_replicacion ()
	idw_impuestos.of_set_flag_replicacion ()
	idw_asiento_cab.of_set_flag_replicacion ()
	idw_asiento_det.of_set_flag_replicacion ()
	
	
	IF is_action = 'delete' or is_action = 'anular' THEN
		ib_update_check = True
		Return
	END IF
	
	ib_update_check = False	
	
	//Verificación de Data en Cabecera de Documento
	IF gnvo_app.of_row_Processing( dw_master ) <> true then return
	IF gnvo_app.of_row_Processing( idw_detail ) <> true then return
	IF gnvo_app.of_row_Processing( idw_impuestos ) <> true then return
	
	//Verificación de Detalle de Documento
	IF idw_detail.Rowcount() = 0 THEN 
		Messagebox('Aviso','Debe Ingresar Items en el Detalle')
		RETURN
	END IF
	
	////Seleccionar Informacion de Cabecera
	ls_cod_origen      = dw_master.Object.origen          	[1]
	ls_tipo_doc        = dw_master.object.tipo_doc        	[1]
	ls_nro_doc	       = dw_master.object.nro_doc         	[1]
	ls_cod_relacion    = dw_master.object.cod_relacion    	[1] 
	ll_year			    = Long(dw_master.object.ano    		   [1])
	ll_mes			    = Long(dw_master.object.mes		      [1])
	ll_nro_libro       = Long(dw_master.object.nro_libro  	[1])
	ll_nro_asiento     = Long(dw_master.object.nro_asiento	[1])
	ls_flag_estado     = dw_master.object.flag_estado     	[1]
	ld_fec_emision     = Date(dw_master.object.fecha_emision [1])
	ldc_tasa_cambio    = Dec(dw_master.object.tasa_cambio	   [1])
	ls_cod_moneda	    = dw_master.object.cod_moneda	   	[1]
	ldc_monto_doc	    = Dec(dw_master.object.importe_doc	   [1])
	ls_obs			    = dw_master.object.descripcion	   	[1]
	ls_flag_detraccion = dw_master.object.flag_detraccion 	[1]
	ldc_monto_detrac   = Dec(dw_master.object.imp_detraccion [1])
	ls_nro_detraccion  = dw_master.object.nro_detraccion  	[1]
	ldc_porc_detrac	 = dw_master.object.porc_detraccion 	[1]
	
	//Verificacion del Estado del Documento
	if ls_flag_estado = '0' then
		Messagebox('Aviso','El Documento se encuentra anulado, y no se pueden grabar cambios. Por favor verifique!')
		RETURN
	end if
	
	//Verificación de Referencias de Documentos
	IF ls_flag_estado = '1' THEN
		IF idw_referencias.Rowcount() = 0 THEN
			Messagebox('Aviso','Debe Ingresar Documentos de Referencia')
			RETURN
		END IF
	END IF
	
	//Validacion del Periodo contable
	if not invo_asiento_cntbl.of_val_mes_cntbl( ll_year, ll_mes, 'R') then return
	
	//Nuevo documento
	IF is_action = 'new' THEN
		
		
		//verificacion de año y mes	
		IF Isnull(ll_year) OR ll_year = 0 THEN
			Messagebox('Aviso','Ingrese Año Contable , Verifique!')
			Return
		END IF
		
		IF Isnull(ll_mes) OR ll_mes = 0 THEN
			Messagebox('Aviso','Ingrese Mes Contable , Verifique!')
			Return
		END IF
		
		IF not invo_asiento_cntbl.of_get_nro_asiento(ls_cod_origen, ll_year, ll_mes, ll_nro_libro, ll_nro_asiento)  then return
		dw_master.object.nro_asiento 			[1] = ll_nro_asiento 
	
		//CABECERA DE ASIENTOS	
		idw_asiento_cab.Object.ano 			[1] = ll_year
		idw_asiento_cab.Object.mes 			[1] = ll_mes
		idw_asiento_cab.Object.nro_libro		[1] = ll_nro_libro
		idw_asiento_cab.object.nro_asiento 	[1] = ll_nro_asiento 
	
	END IF
	
	//actualiza saldos
	IF ls_cod_moneda = gnvo_app.is_soles THEN 
		ldc_saldo_sol = ldc_monto_doc
		ldc_saldo_dol = Round(ldc_monto_doc / ldc_tasa_cambio ,2)
	ELSEIF ls_cod_moneda = gnvo_app.is_dolares THEN
		ldc_saldo_sol = Round(ldc_monto_doc *  ldc_tasa_cambio ,2)
		ldc_saldo_dol = ldc_monto_doc
	END IF
	
	//saldos
	dw_master.object.saldo_sol [1] = ldc_saldo_sol 
	dw_master.object.saldo_dol [1] = ldc_saldo_dol
	
	//Generación Automaticas de pre Asientos
	IF ib_estado_prea = TRUE THEN 
		IF not of_genera_asiento_cntbl() then return
	END IF
	
	
	/*RECUPERACION DE ARCHIVO DE PARAMETROS*/
	IF gnvo_app.is_agente_ret = '1' AND ls_flag_detraccion = '0' THEN /*RETIENE*/
		/*CONVERTIR A SOLES*/
		IF ls_cod_moneda = gnvo_app.is_soles THEN
			ldc_monto_doc = dw_master.object.importe_doc [1]
		ELSE
			ldc_monto_doc = Round(Dec(dw_master.object.importe_doc [1]) * ldc_tasa_cambio, 2)
		END IF
	
		IF ldc_monto_doc > gnvo_app.idc_monto_retencion THEN
			ldc_porc_ret_x_doc = dw_master.Object.porc_ret_igv [1]
			IF Isnull(ldc_porc_ret_x_doc) THEN ldc_porc_ret_x_doc = 0.00
			IF ldc_porc_ret_x_doc <> gnvo_app.idc_tasa_retencion THEN
				/*Asignar porc. retencion*/
				dw_master.Object.porc_ret_igv [1] = gnvo_app.idc_tasa_retencion
				dw_master.ii_update = 1
			END IF
		END IF
	END IF	
	
	//DETRACCION
	IF ls_flag_detraccion = '1' THEN
		//Recalcula la detraccion
		of_calcular_detraccion()
	
		//verifica porcentaje	
		if isnull(ldc_porc_detrac) or ldc_porc_detrac = 0.00 then
			Messagebox('Aviso','Debe Ingresar Porcentaje Detracción')
			dw_master.Setfocus()
			dw_master.SetColumn('porc_detraccion')
			Return			
		end if
		
		if not IsNull(ls_nro_detraccion) and ls_nro_detraccion <> "" then
			select count(*)
			  into :ll_count
			from detraccion
			where nro_detraccion = :ls_nro_detraccion;
		end if
		
		//Si no hay detraccion entonces creo el numero de la detraccion y solicito si tiene o 
		//no la constancia de deposito
		if IsNull(ls_nro_detraccion) or ls_nro_detraccion = "" or ll_count = 0 then
			ls_nro_detraccion = invo_detraccion.of_next_nro(ls_cod_origen)
			
			li_opcion = Messagebox('Aviso','Desea Colocar Datos del Deposito o Detracción',Question!,Yesno!,2)
			
			if li_opcion = 1 then
				//ventana de ayuda
				OpenWithParm(w_help_constacia_dep_x_pag,ls_bien_serv)
				
				//*Datos Recuperados
				If IsValid(message.PowerObjectParm) Then
					lstr_param = message.PowerObjectParm
					
					if not lstr_param.bret then return
					ls_const_dep  = lstr_param.string1
					ld_fecha_dep  = lstr_param.date1
				end if 
			else
				SetNull(ls_const_dep)
				SetNull(ld_fecha_dep)
			end if //si ingreso constancia
			
			//coloca datos de la detracción
			dw_master.object.nro_detraccion [1] = ls_nro_detraccion
			dw_master.object.ind_detrac	  [1]	= gnvo_app.is_null
			
		else
			select nro_deposito, fecha_deposito
				into :ls_const_dep, :ld_fecha_dep
			from detraccion
			where nro_detraccion = :ls_nro_detraccion;
		end if

		//update de la detraccion
		invo_detraccion.idw_master = dw_master
		
		IF invo_detraccion.of_update(	ls_cod_origen, &			
												ls_nro_detraccion,&
												ls_cod_relacion, &
												ls_obs, &
												ld_fec_emision, &
												ls_const_dep,&
												ld_fecha_dep,&
												gnvo_app.is_soles, &
												ldc_tasa_cambio, &
												ldc_monto_detrac, &
												'3') = FALSE THEN
			Return								 
		END IF
		
	elseIF ls_flag_detraccion = '0' THEN
		
		if is_action = 'fileopen'	 then
			/*Buscar Nro de Detracción*/
			select nro_detraccion 
				into :ls_nro_detraccion 
				from cntas_pagar cp
			 where cp.cod_relacion 	= :ls_cod_relacion
				and cp.tipo_doc		= :ls_tipo_doc		
				and cp.nro_doc			= :ls_nro_doc;
	
			select count(*) 
			  into :ll_count 
			from detraccion 
			where nro_detraccion = :ls_nro_detraccion ;
			
			if ll_count > 0 then
				li_opcion = Messagebox('Aviso','Esta Segura de Eliminar Datos de la Detracción ' + ls_nro_detraccion + '?',Question!,YesNo!,2)
				
				if li_opcion = 2 then return
					
				if not invo_detraccion.of_anular(ls_nro_detraccion) then return
				
			end if		
		end if	
	END IF
	
	
	///detalle de Documento
	FOR ll_inicio = 1 TO idw_detail.Rowcount()
		 idw_detail.object.tipo_doc 	  [ll_inicio]  = ls_tipo_doc		 
		 idw_detail.object.nro_doc  	  [ll_inicio]  = ls_nro_doc		
		 idw_detail.object.cod_relacion [ll_inicio]  = ls_cod_relacion
	NEXT
	
	///Referencias de Documentos
	FOR ll_inicio = 1 TO idw_referencias.Rowcount()
		 idw_referencias.object.tipo_doc 		[ll_inicio] = ls_tipo_doc		 
		 idw_referencias.object.nro_doc  		[ll_inicio] = ls_nro_doc		
		 idw_referencias.object.cod_relacion 	[ll_inicio] = ls_cod_relacion
	NEXT
	
	
	///Impuestos
	FOR ll_inicio = 1 TO idw_impuestos.Rowcount()
		 idw_impuestos.object.tipo_doc 	  [ll_inicio] = ls_tipo_doc		 
		 idw_impuestos.object.nro_doc  	  [ll_inicio] = ls_nro_doc	
		 idw_impuestos.object.cod_relacion [ll_inicio] = ls_cod_relacion
		 
		 /*Verifica Monto de Impuesto sea Mayor a 0*/
		 ldc_importe_imp = idw_impuestos.object.importe [ll_inicio]
		 IF ls_flag_estado = '1' THEN   //Generado
			 IF Isnull(ldc_importe_imp) OR ldc_importe_imp = 0 THEN
				 Messagebox('Aviso','Verifique Importe de Impuesto debe ser Mayor que 0')
				 return
			 END IF
		END IF
	NEXT
	
	
	
	///Detalle de pre asiento
	FOR ll_inicio = 1 TO idw_asiento_det.Rowcount()
		 ls_cnta_ctbl = idw_asiento_det.object.cnta_ctbl [ll_inicio]
		 idw_asiento_det.object.origen   	[ll_inicio] = ls_cod_origen
		 idw_asiento_det.object.ano	   	[ll_inicio] = ll_year
		 idw_asiento_det.object.mes	   	[ll_inicio] = ll_mes
		 idw_asiento_det.object.nro_libro	[ll_inicio] = ll_nro_libro
		 idw_asiento_det.object.nro_asiento	[ll_inicio] = ll_nro_asiento
		 idw_asiento_det.object.fec_cntbl   [ll_inicio] = ld_fec_emision
		 
		 IF not of_verifica_flag_cntas (ls_cnta_ctbl,ls_tipo_doc,ls_nro_doc,ls_cod_relacion,ll_inicio) THEN
			 Messagebox('Aviso','Flag de Cuenta Contable '+ls_cnta_ctbl +'Tiene Problemas ,Verifique!')
			 Return	
		 END IF
		 
	NEXT
	
	//*Totales Para Cabecera de Pre - Asientos*//
	ldc_totsoldeb  = idw_asiento_det.object.monto_soles_cargo   [1]
	ldc_totdoldeb  = idw_asiento_det.object.monto_dolares_cargo [1]
	ldc_totsolhab  = idw_asiento_det.object.monto_soles_abono	 [1]
	ldc_totdolhab  = idw_asiento_det.object.monto_dolares_abono [1]
	
	//Cabecera de pre asiento
	idw_asiento_cab.Object.origen     	[1] = ls_cod_origen
	idw_asiento_cab.Object.ano     	   [1] = ll_year
	idw_asiento_cab.Object.mes     	   [1] = ll_mes
	idw_asiento_cab.Object.nro_libro 	[1] = ll_nro_libro
	idw_asiento_cab.Object.nro_asiento 	[1] = ll_nro_asiento

	//Cabecera de pre asiento datos Complementarios
	idw_asiento_cab.Object.cod_moneda	[1] = dw_master.object.cod_moneda     [1]
	idw_asiento_cab.Object.tasa_cambio	[1] = dw_master.object.tasa_cambio    [1]
	idw_asiento_cab.Object.desc_glosa	[1] = Mid(dw_master.object.descripcion    [1],1,100)
	idw_asiento_cab.Object.fec_registro	[1] = f_fecha_actual()
	idw_asiento_cab.Object.fecha_cntbl  [1] = ld_fec_emision
	idw_asiento_cab.Object.cod_usr		[1] = gs_user
	idw_asiento_cab.Object.flag_estado	[1] = '1'
	idw_asiento_cab.Object.tot_solhab	[1] = ldc_totsolhab
	idw_asiento_cab.Object.tot_dolhab	[1] = ldc_totdolhab
	idw_asiento_cab.Object.tot_soldeb	[1] = ldc_totsoldeb
	idw_asiento_cab.Object.tot_doldeb   [1] = ldc_totdoldeb
	
	
	IF idw_asiento_det.ii_update = 1 THEN dw_master.ii_update = 1
	IF dw_master.ii_update = 1 THEN idw_asiento_cab.ii_update = 1
	
	// valida asientos descuadrados
	if not invo_asiento_cntbl.of_validar_asiento(idw_asiento_det) then return
	
	ib_update_check = true
	
catch ( Exception ex )
	ROLLBACK;
	MessageBox('Error', "Ha ocurrido una exception: " + ex.getMessage())
	
end try


end event

event ue_modify;call super::ue_modify;Long    ll_row
String  ls_flag_estado
Integer li_protect

ll_row = dw_master.Getrow()

dw_master.accepttext()

IF ll_row = 0 THEN RETURN


ls_flag_estado = dw_master.object.flag_estado [ll_row]

dw_master.of_protect()
idw_detail.of_protect()
idw_referencias.of_protect()
idw_impuestos.of_protect()
idw_asiento_det.of_protect()

IF ls_flag_estado = '1' THEN
	IF is_action <> 'new' THEN
		li_protect = integer(dw_master.Object.tipo_doc.Protect)
		IF li_protect = 0	THEN
			dw_master.object.tipo_doc.Protect 	  = 1
			dw_master.object.serie_cp.Protect 	  = 1
			dw_master.object.numero_cp.Protect 	  = 1
			dw_master.object.cod_relacion.Protect = 1
			dw_master.object.nro_libro.Protect 	  = 1
			dw_master.object.ano.Protect 	  		  = 1
			dw_master.object.mes.Protect 	  		  = 1
		END IF
	END IF	
	
	li_protect = dw_master.ii_protect
	/*Bloqueo de Registro en Detalle*/
	of_modify_detail()	
	
ELSE
	
	dw_master.ii_protect = 0
	idw_detail.ii_protect	 = 0
	idw_referencias.ii_protect		 = 0
	idw_impuestos.ii_protect		 = 0
	idw_asiento_det.ii_protect = 0
	dw_master.of_protect()
	idw_detail.of_protect()
	idw_referencias.of_protect()
	idw_impuestos.of_protect()
	idw_asiento_det.of_protect()
END IF

end event

event ue_retrieve_list;//override
// Asigna valores a structura 
Long   ll_row , ll_inicio
str_parametros sl_param
String ls_motivo, ls_tipo_doc

TriggerEvent ('ue_update_request')		

sl_param.dw1    = 'd_lista_cntas_pagar_nv_tbl'
sl_param.titulo = 'Notas de Credito / Debito Por Pagar'
sl_param.field_ret_i[1] = 1	//Codigo de Relación
sl_param.field_ret_i[2] = 2	//Tipo Doc
sl_param.field_ret_i[3] = 3	//Nro Doc
sl_param.field_ret_i[4] = 7	//Origen
sl_param.field_ret_i[5] = 8	//Año
sl_param.field_ret_i[6] = 9	//Mes
sl_param.field_ret_i[7] = 10	//Nro Libro
sl_param.field_ret_i[8] = 11	//Nro asiento

//OpenWithParm( w_search_datos, sl_param)
OpenWithParm( w_lista, sl_param)

sl_param = Message.PowerObjectParm
IF sl_param.titulo <> 'n' THEN
	of_retrieve(sl_param.field_ret[1],sl_param.field_ret[2],sl_param.field_ret[3])
END IF

end event

event key;call super::key;IF key = KeyF4! THEN
	TriggerEvent('ue_find_exact')
END IF
end event

event close;call super::close;destroy invo_asiento_cntbl
destroy invo_detraccion

destroy ids_pre_asiento_det
destroy ids_voucher         
destroy ids_formato_det
destroy invo_cntas_pagar
end event

event ue_print;call super::ue_print;String ls_origen
Long   ll_ano,ll_mes,ll_nro_libro,ll_nro_asiento
str_parametros lstr_param

IF dw_master.RowCount() = 0 or dw_master.GetRow() = 0 THEN
	f_mensaje('No existe Registro en la cabecera del documento, Verifique!', 'FIN_NOT_DOC')
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
	lstr_param.dw1 		= 'd_rpt_voucher_imp_cp_tbl'
	lstr_param.titulo 	= 'Previo de Voucher'
	lstr_param.string1 	= ls_origen
	lstr_param.integer1 	= ll_ano
	lstr_param.integer2 	= ll_mes
	lstr_param.integer3 	= ll_nro_libro
	lstr_param.integer4 	= ll_nro_asiento
	lstr_param.string2	= gs_empresa
	lstr_param.titulo		= "Provisión de Cuentas x Pagar"
	lstr_param.tipo		= '1S1I2I3I4I2S'
	

	OpenSheetWithParm(w_rpt_preview, lstr_param, w_main, 0, Layered!)
end if

end event

type cb_1 from commandbutton within w_fi320_nota_debito_credito
integer x = 3808
integer y = 48
integer width = 608
integer height = 148
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
string text = "Documentos x Pagar"
end type

event clicked;String 	ls_cod_proveedor,ls_flag_estado,ls_motivo,ls_moneda, ls_flag_cab_det
Long   	ll_count,ll_row
Decimal	ldc_tasa_cambio
str_parametros lstr_param 


ll_row = dw_master.Getrow()
ls_cod_proveedor 	= dw_master.Object.cod_relacion 		[ll_row]
ls_flag_estado	  	= dw_master.Object.flag_estado  		[ll_row]
ls_motivo		  	= dw_master.Object.motivo		 		[ll_row]
ldc_tasa_cambio  	= dw_master.Object.tasa_cambio		[ll_row]
ls_flag_cab_det	= dw_master.Object.flag_cab_det		[ll_row]


IF ls_flag_estado <> '1'  THEN
	Messagebox('Aviso','Documento No Se Puede Modificar por que el Documento ya ha tenido Movimiento, Verifique!')
	Return	
END IF

IF Isnull(ls_motivo) OR Trim(ls_motivo) = '' THEN
	Messagebox('Aviso','Debe Ingresar Motivo del Documento A Generar , Verifique!')
	dw_master.setFocus()
	dw_master.SetColumn('motivo')
	Return
END IF

IF Isnull(ls_flag_cab_det) OR Trim(ls_flag_cab_det) = '' THEN
	Messagebox('Aviso','El motivo ingresado ' + ls_motivo + ' no tiene asignado si es Cabecera o Detalle, por favor corrija!')
	dw_master.setFocus()
	dw_master.SetColumn('motivo')
	Return
END IF


IF Isnull(ldc_tasa_cambio) OR ldc_tasa_cambio = 0 THEN
	Messagebox('Aviso','Debe Considerar Tasa de Cambio	de Documento A Generar, Verifique!')
	dw_master.setFocus()
	dw_master.SetColumn('tasa_cambio')
	Return
END IF

IF Isnull(ls_cod_proveedor) OR trim(ls_cod_proveedor) = "" THEN
	Messagebox('Aviso','Dee ingresar el código de proveedor, por favor Verifique!')
	dw_master.SetFocus()
	dw_master.setColumn('cod_relacion')
	Return
END IF

//Verifico si es el mismo proveedor
lstr_param.string3 = ls_cod_proveedor

OpenWithParm(w_pop_help_edirecto,lstr_param)

//* Check text returned in Message object//
if IsNull(message.PowerObjectParm) or not IsValid(message.PowerObjectParm) then return

lstr_param = message.PowerObjectParm
if lstr_param.titulo = 'n' then return

ls_cod_proveedor = lstr_param.string3


if ls_flag_cab_det = 'D' then
	lstr_param.dw1		= 'd_cntas_pagar_detalle_tbl'
else
	lstr_param.dw1		= 'd_cntas_pagar_cabecera_tbl'
end if
lstr_param.titulo	= 'Comprobantes de Pago del Proveedor'
lstr_param.opcion   = 3   	//Notas de Ventas Por Pagar
lstr_param.db1 		= 1600	
lstr_param.tipo		= '1NVP'
lstr_param.dw_m		= dw_master
lstr_param.dw_d		= idw_referencias
lstr_param.dw_c		= idw_detail
lstr_param.dw_e		= idw_impuestos
lstr_param.string1 	= '1HNV'
lstr_param.string2 	= trim(ls_cod_proveedor) + '%'
lstr_param.string3 	= ls_motivo


OpenWithParm( w_abc_seleccion_lista_search, lstr_param)
IF isvalid(message.PowerObjectParm) THEN lstr_param = message.PowerObjectParm

IF lstr_param.accion = "aceptar" THEN
	/*Bloqueo de Registros*/
	of_modify_detail()
	
	
	idw_referencias.ii_update = 1
	
	idw_detail.ii_update 	= 1
	idw_impuestos.ii_update = 1
	/*Actualiza Master*/
	dw_master.object.importe_doc [1] = wf_totales()
	dw_master.ii_update = 1
	
	ib_estado_prea = TRUE  //Generacion de Pre Asientos Automaticos
END IF


end event

type tab_1 from tab within w_fi320_nota_debito_credito
integer y = 1216
integer width = 2834
integer height = 828
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
boolean raggedright = true
boolean focusonbuttondown = true
boolean boldselectedtext = true
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
tabpage_5 tabpage_5
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.tabpage_3=create tabpage_3
this.tabpage_4=create tabpage_4
this.tabpage_5=create tabpage_5
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_3,&
this.tabpage_4,&
this.tabpage_5}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
destroy(this.tabpage_3)
destroy(this.tabpage_4)
destroy(this.tabpage_5)
end on

event selectionchanged;CHOOSE CASE newindex
		 CASE	4	
				wf_totales		   ()
		 CASE 5	//Pre Asientos
			   IF ib_estado_prea = FALSE THEN RETURN //  Editado
				of_genera_asiento_cntbl ()
END CHOOSE
end event

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 2798
integer height = 700
long backcolor = 79741120
string text = "Registro"
long tabtextcolor = 8388608
long tabbackcolor = 79741120
string picturename = "Custom072!"
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
integer width = 2514
integer height = 688
integer taborder = 20
string dataobject = "d_abc_cntas_pagar_det_ncp_ndp_tbl"
borderstyle borderstyle = styleraised!
end type

event constructor;call super::constructor;is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 1 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw
ii_ck[3] = 3				// columnas de lectrua de este dw
ii_ck[4] = 4				// columnas de lectrua de este dw

ii_rk[1] = 1 	      // columnas que recibimos del master
ii_rk[2] = 2 	      // columnas que recibimos del master
ii_rk[3] = 3 	      // columnas que recibimos del master



idw_mst  = dw_master						 // dw_master
idw_det  = idw_detail // dw_detail
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event itemchanged;call super::itemchanged;String  	ls_matriz_cntbl,ls_descripcion,ls_cod_art,ls_item
Long    	ll_count
Decimal	ldc_importe, ldc_cantidad, ldc_precio_unit
Accepttext()

/*Datos del Registro Modificado*/
ib_estado_prea = TRUE
/**/

CHOOSE CASE dwo.name
	 CASE	'centro_benef'
		
		select count (*) 
			into :ll_count
		from 	centro_beneficio cb
		where cb.centro_benef	= :data;
				 
		if ll_count = 0 then
			Messagebox('Aviso','Centro Beneficio No Existe o no esta activo,Verifique!')
			This.Object.centro_benef [row] = gnvo_app.is_null
			Return 1
		
		END IF
			
	 CASE	'tipo_cred_fiscal'
		
		select descripcion
			into :ls_descripcion
		from 	credito_fiscal 
		where tipo_cred_fiscal	= :data
		  and flag_estado 		= '1'
		  and flag_cxp_cxc 		= 'P';
				 
		if ll_count = 0 then
			Messagebox('Aviso','Tipo de Credito Fiscal No Existe, no pertenece a cuentas por pagar o no esta activo,Verifique!')
			This.Object.tipo_cred_fiscal	[row] = gnvo_app.is_null
			This.Object.desc_cred_fiscal 	[row] = gnvo_app.is_null
			Return 1
		
		END IF
		
		This.Object.desc_cred_fiscal [row] = ls_descripcion
		
	CASE	'cod_art'
		SELECT desc_art
		  INTO :ls_descripcion
		  FROM articulo
		 WHERE cod_art = :data
		   and flag_estado = '1';
		 
		IF SQLCA.SQLCode = 100 THEN
			/*Recupero Descripción del Articulo*/
			Messagebox('Aviso','Articulo No Existe o no se encuentra activo, Verifique!')
			This.Object.cod_art 		 [row] = gnvo_app.is_null
			This.Object.descripcion	 [row] = gnvo_app.is_null
			Return 2
		end if
		
		This.Object.descripcion	 [row] = ls_descripcion
	
	 CASE 'confin'
		SELECT matriz_cntbl
		  INTO :ls_matriz_cntbl
		  FROM concepto_financiero
		 WHERE (confin = :data);	
		
		IF SQLCA.SQLCode = 100 THEN
			Messagebox('Aviso','Concepto Financiero '+data+' No Existe , Verifique!')
			This.Object.confin 		 [row] = gnvo_app.is_null
			This.Object.matriz_cntbl [row] = gnvo_app.is_null
			Return 1
		end if
			 
		This.Object.matriz_cntbl [row] = ls_matriz_cntbl
			
	CASE 'cencos'				 
			
		SELECT Count(*)
		  INTO :ll_count
		  FROM centros_costo
		 WHERE (flag_estado = '1'   ) AND
				 (cencos		  = :data ) ;
				  
		IF ll_count = 0 THEN
			Messagebox('Aviso','Centro de Costo '+data+' No Existe , Verifique!')
			This.Object.cencos [row] = ''
			Return 1
		END IF
			
	CASE 'cnta_prsp'
		
		SELECT Count(*)
		  INTO :ll_count
		  FROM presupuesto_cuenta
		 WHERE (cnta_prsp = :data) ;
		 
		IF ll_count = 0 THEN
			Messagebox('Aviso','Cuenta Preuspuestal No Existe , Verifique!')
			This.Object.cnta_prsp [row] = ''
			Return 1
		END IF
			
			
	CASE	'cantidad', 'precio_unit'
		ldc_cantidad 		= Dec(This.object.cantidad	 	[row])
		
		if IsNull(ldc_cantidad) or ldc_cantidad = 0 then
			Messagebox('Aviso','Cantidad debe ser mayor que cero, Verifique!')
			This.object.cantidad	 	[row] = 0.0
			This.object.precio_unit [row] = 0.0
			This.object.importe 		[row] = 0.0
			setColumn("cantidad")
			return 1
		end if
		
		ldc_precio_unit 	= Dec(This.object.precio_unit [row])
		
		if IsNull(ldc_precio_unit) or ldc_precio_unit = 0 then
			
			Messagebox('Aviso','Precio Unitario debe ser mayor que cero, Verifique!')
			This.object.cantidad	 	[row] = 0.0
			This.object.precio_unit [row] = 0.0
			This.object.importe 		[row] = 0.0
			setColumn("precio_unit")
			return 1
			
		end if
		
		ldc_importe = ldc_cantidad * ldc_precio_unit
		This.object.importe [row] = ldc_importe

		ls_item = Trim(String(This.object.item [row]))
		//Recalculo de Impuesto	
		wf_generacion_imp (ls_item)		
		
		/*Actualiza Master */
		dw_master.object.importe_doc [1] = wf_totales()
		dw_master.ii_update = 1
		/**/
			
				
				
END CHOOSE
				
end event

event itemerror;call super::itemerror;Return 1
end event

event rowfocuschanged;call super::rowfocuschanged;This.SelectRow(0, False)
This.SelectRow(currentrow, True)
end event

event ue_insert_pre;call super::ue_insert_pre;String  		ls_signo ,ls_cnta_cntbl ,ls_flag_dh_cxp ,ls_desc_cnta,&
				ls_item,ls_motivo
Integer 		li_row
Decimal 		ldc_tasa_impuesto


This.Object.item		[al_row] = al_row	
this.object.importe	[al_row] = 0.00

/*Autogeneración de Cuentas*/
ib_estado_prea = TRUE



/*Motivo del Documento*/
ls_motivo = dw_master.object.motivo [1]
/**/


/*Tasa Impuesto Pre Definido*/
SELECT it.tasa_impuesto,it.signo,it.cnta_ctbl,it.flag_dh_cxp,cc.desc_cnta
  INTO :ldc_tasa_impuesto,:ls_signo,:ls_cnta_cntbl,:ls_flag_dh_cxp,:ls_desc_cnta
  FROM impuestos_tipo it,
  		 cntbl_cnta		 cc
 WHERE (it.cnta_ctbl		 = cc.cnta_ctbl ) AND
       (it.tipo_impuesto = :gnvo_app.finparam.is_igv	  ) ;
	 

IF Isnull(ldc_tasa_impuesto) OR ldc_tasa_impuesto = 0 THEN
	Messagebox('Aviso','Tasa de Impuesto IGV no Ha sido Ingresada '&
							+'Verifique!, Impuesto no se Ha Generado')	
	GOTO SALIDA
END IF

IF Isnull(ls_signo) OR Trim(ls_signo) = '' THEN
	Messagebox('Aviso','Signo de Impuesto IGV no Ha sido Ingresado '&
							+'Verifique!, Impuesto no se Ha Generado')	
	GOTO SALIDA
END IF

IF Isnull(ls_cnta_cntbl) OR Trim(ls_cnta_cntbl) = '' THEN
	Messagebox('Aviso','Cuenta Contable de IGV no Ha sido Ingresado '&
							+'Verifique!, Impuesto no se Ha Generado')	
	GOTO SALIDA
END IF

IF Isnull(ls_flag_dh_cxp) OR Trim(ls_flag_dh_cxp) = '' THEN
	Messagebox('Aviso','Flag de Debe /Haber de IGV no Ha sido Ingresado '&
							+'Verifique!, Impuesto no se Ha Generado')	
	GOTO SALIDA
END IF
	


///*Inserto Impuesto x Cada Item Ingresado Cuentas x Pagar Detalle*/
li_row = idw_impuestos.InsertRow(0)

idw_impuestos.object.item          [li_row] = al_row
idw_impuestos.object.tipo_impuesto [li_row] = gnvo_app.finparam.is_igv
idw_impuestos.object.tasa_impuesto [li_row] = ldc_tasa_impuesto 	
idw_impuestos.object.cnta_ctbl	  [li_row] = ls_cnta_cntbl
idw_impuestos.object.desc_cnta     [li_row] = ls_desc_cnta
idw_impuestos.object.signo		     [li_row] = ls_signo
idw_impuestos.object.flag_dh_cxp   [li_row] = ls_flag_dh_cxp

idw_impuestos.ii_update = 1
//Recalculo de Impuesto	
ls_item = Trim(String(idw_impuestos.object.item [li_row]))
wf_generacion_imp (ls_item)		

/*Actualiza Master*/
dw_master.object.total_pagar [1] = wf_totales()
dw_master.ii_update = 1
/**/

SALIDA:
end event

event dberror;String	ls_msg, ls_crlf, ls_prop, ls_const, ls_cadena, ls_name
Integer	li_pos_ini, li_pos_fin, li_pos_nc

ls_crlf = char(13) + char(10)
li_pos_ini = Pos(sqlerrtext,'(',1) + 1
li_pos_fin = Pos(sqlerrtext,')',li_pos_ini) - 1

ls_cadena = Mid(sqlerrtext,li_pos_ini,li_pos_fin - (li_pos_ini - 1) )
li_pos_nc = Pos(ls_cadena,'.',1) - 1 
ls_prop   = Mid(ls_cadena,1,li_pos_nc)
ls_const  = Mid(ls_cadena,li_pos_nc + 2)

CHOOSE CASE sqldbcode
//	CASE 1                        // Llave Duplicada
//        Messagebox('Error PK','Llave Duplicada, Linea: ' + String(row))
//        Return 1
	CASE 02292                         // Eliminar y Existen registros en tablas dependientes
		SELECT TABLE_NAME
        INTO :ls_name
        FROM ALL_CONSTRAINTS
       WHERE ((OWNER          = :ls_prop  ) AND 
             (CONSTRAINT_NAME = :ls_const )) ;
        Messagebox('Error FK','Registro Tiene Movimientos en Tabla: '+ls_name)
        Return 1
	CASE ELSE
		ls_msg  = 'Database: ' + SQLCA.Database + ls_crlf
		ls_msg += 'DBMS: ' + SQLCA.DBMS + ls_crlf
		ls_msg += 'Lock: ' + SQLCA.Lock + ls_crlf
		ls_msg += 'ServerName: ' + SQLCA.ServerName + ls_crlf
		ls_msg += 'SQLCode: ' + String(SQLCA.SQLCode) + ls_crlf
		ls_msg += 'SQLDBCode: ' + String(SQLDBCode) + ls_crlf
		ls_msg += 'SQLErrText: ' + SQLErrText + ls_crlf
		ls_msg += 'Linea: ' + String(row) + ls_crlf
		//ls_msg += 'SQLDBCode: ' + String(SQLCA.SQLDBCode) + ls_crlf
		//ls_msg += 'SQLErrText: ' + SQLCA.SQLErrText + ls_crlf
		ls_msg += 'SQLNRows: ' + String(SQLCA.SQLNRows) + ls_crlf
		ls_msg += 'SQLReturnData: ' + SQLCA.SQLReturnData + ls_crlf
		ls_msg += 'UserID: ' + SQLCA.UserID
		messagebox("dberror", ls_msg, StopSign!)
END CHOOSE





end event

event ue_display;call super::ue_display;boolean lb_ret
string ls_codigo, ls_data, ls_sql
str_parametros sl_param
choose case lower(as_columna)
	case "centro_benef"
		ls_sql = "SELECT CB.CENTRO_BENEF AS CODIGO, " &
				 + "CB.DESC_CENTRO AS DESCRIPCION "&
				 + "FROM CENTRO_BENEFICIO CB " &
				 + "WHERE CB.FLAG_ESTADO = '1' "

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

		if ls_codigo <> '' then
			this.object.centro_benef	[al_row] = ls_codigo
			
			this.ii_update = 1
			
			/*Datos del Registro Modificado*/
			ib_estado_prea = TRUE
		end if
		
	case "cod_art"
		
		OpenWithParm (w_pop_articulos, parent)
		sl_param = MESSAGE.POWEROBJECTPARM
		IF sl_param.titulo <> 'n' then
			this.object.cod_art		[al_row] = sl_param.field_ret[1]
			this.object.descripcion	[al_row] = sl_param.field_ret[2]
		
			this.ii_update = 1
			
			/*Datos del Registro Modificado*/
			ib_estado_prea = TRUE
	 	END IF
		
	CASE 'confin'
	
		sl_param.tipo			= ''
		sl_param.opcion		= 3
		sl_param.titulo 		= 'Selección de Concepto Financiero'
		sl_param.dw_master	= 'd_lista_grupo_financiero_grd'
		sl_param.dw1			= 'd_lista_concepto_financiero_grd'
		sl_param.dw_m			=  This
		OpenWithParm( w_abc_seleccion_md, sl_param)
		IF isvalid(message.PowerObjectParm) THEN sl_param = message.PowerObjectParm			
		IF sl_param.titulo = 's' THEN
			This.ii_update = 1
			
			/*Datos del Registro Modificado*/
			ib_estado_prea = TRUE
			/**/
		END IF

	case "cencos"
		ls_sql = "SELECT CENCOS   AS CENT_COSTO ,"&
				 + "DESC_CENCOS  AS DESCRIPCION_CENT_COSTO "&
  				 + "FROM CENTROS_COSTO " &
				 + "WHERE FLAG_ESTADO = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.cencos	[al_row] = ls_codigo
			this.ii_update = 1
			
			/*Datos del Registro Modificado*/
			ib_estado_prea = TRUE
		end if

	case "cnta_prsp"
		ls_sql = "SELECT CNTA_PRSP AS CUENTA_PRESUP ,"&
				 + "DESCRIPCION		  AS DESCRIPCION	 "&
				 + "FROM PRESUPUESTO_CUENTA " &
				 + "WHERE FLAG_ESTADO = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.cnta_prsp	[al_row] = ls_codigo
			this.ii_update = 1
			
			/*Datos del Registro Modificado*/
			ib_estado_prea = TRUE
			
		end if

	case "tipo_cred_fiscal"
		ls_sql = "select tipo_cred_fiscal as tipo_credito_fiscal, " &
				 + "descripcion as descripcion_credito_fiscal " &
				 + "from credito_fiscal " &
				 + "where flag_estado = '1'" &
				 + "  and flag_cxp_cxc = 'P' " &
				 + "order by tipo_cred_fiscal  "

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.tipo_cred_fiscal	[al_row] = ls_codigo
			this.object.desc_cred_fiscal	[al_row] = ls_data
			this.ii_update = 1
			
			/*Datos del Registro Modificado*/
			ib_estado_prea = TRUE
			
		end if

end choose
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

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 2798
integer height = 700
long backcolor = 79741120
string text = "Referencias"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "Join!"
long picturemaskcolor = 536870912
dw_referencias dw_referencias
end type

on tabpage_2.create
this.dw_referencias=create dw_referencias
this.Control[]={this.dw_referencias}
end on

on tabpage_2.destroy
destroy(this.dw_referencias)
end on

type dw_referencias from u_dw_abc within tabpage_2
integer width = 2487
integer taborder = 20
string dataobject = "d_abc_doc_referencia_nventas_pagar_tbl"
borderstyle borderstyle = styleraised!
end type

event constructor;call super::constructor;is_mastdet = 'm'		  // 'm' = master sin detalle (default), 'd' =  detalle,
	                    // 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'  // tabular, form (default)

ii_ss = 1 			// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1		// columnas de lectrua de este dw
ii_ck[2] = 2		// columnas de lectrua de este dw
ii_ck[3] = 3		// columnas de lectrua de este dw
ii_ck[4] = 4		// columnas de lectrua de este dw
ii_ck[5] = 5		// columnas de lectrua de este dw
ii_ck[6] = 6		// columnas de lectrua de este dw
ii_ck[7] = 7		// columnas de lectrua de este dw




idw_mst  = idw_referencias			// dw_master

end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event ue_insert_pre;call super::ue_insert_pre;this.object.cod_relacion 	[al_row] = dw_master.object.cod_relacion 	[1]
this.object.tipo_doc 		[al_row] = dw_master.object.tipo_doc 		[1]
this.object.nro_doc 			[al_row] = dw_master.object.nro_doc 		[1]

end event

type tabpage_3 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 2798
integer height = 700
long backcolor = 79741120
string text = "Impuestos"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "Custom023!"
long picturemaskcolor = 536870912
dw_impuestos dw_impuestos
end type

on tabpage_3.create
this.dw_impuestos=create dw_impuestos
this.Control[]={this.dw_impuestos}
end on

on tabpage_3.destroy
destroy(this.dw_impuestos)
end on

type dw_impuestos from u_dw_abc within tabpage_3
integer width = 2775
integer height = 668
integer taborder = 20
string dataobject = "d_abc_cp_det_imp_tbl"
borderstyle borderstyle = styleraised!
end type

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
	                  //      'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1			// columnas de lectrua de este dw
ii_ck[2] = 2			// columnas de lectrua de este dw
ii_ck[3] = 3			// columnas de lectrua de este dw
ii_ck[4] = 4			// columnas de lectrua de este dw
ii_ck[5] = 5			// columnas de lectrua de este dw


idw_mst  = idw_impuestos	// dw_master

end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event itemchanged;call super::itemchanged;String 	ls_item,ls_expresion,ls_timpuesto,ls_signo,ls_cnta_cntbl,ls_desc_cnta,&
		 	ls_flag_dh_cxp
Long   	ll_found
Decimal 	ldc_imp_total,ldc_tasa_impuesto,ldc_total
this.Accepttext()

ib_estado_prea = TRUE   //Pre Asiento No editado 
								//se activara proceso de Autogeneración

CHOOSE CASE dwo.name
		
		 CASE 'tipo_impuesto'
			
				select it.cnta_ctbl, it.tasa_impuesto, it.signo, it.flag_dh_cxp
					into :ls_cnta_cntbl, :ldc_tasa_impuesto, :ls_signo, :ls_flag_dh_cxp
				from impuestos_tipo it
				where tipo_impuesto = :data
				   and it.cnta_ctbl is not null;
				  
				IF SQLCA.SQLCode = 100 THEN
					MessageBox('Error', 'El impuesto ingresado ' + data + ' no existe o no tiene ninguna cuenta contable asociada, por favor verifique', StopSign!)
					
					This.Object.tasa_impuesto 	[row] = 0.00
					This.Object.signo			  	[row] = gnvo_app.is_null
					This.Object.cnta_ctbl	  		[row] = gnvo_app.is_null
					This.Object.flag_dh_cxp	  	[row] = gnvo_app.is_null
					This.Object.desc_cnta	  	[row] = gnvo_app.is_null
					This.Object.importe		  	[row] = 0.00
					
					
					return 1
				end if
				
				//Verifico y busco el importe en el detalle del comprobante
				ls_item = Trim(String(This.object.item [row]))
				
				ls_expresion = 'item = '+ls_item
				ll_found		 = idw_detail.find(ls_expresion, 1, idw_detail.Rowcount())
				
				IF ll_found = 0 THEN
					This.Object.tasa_impuesto 	[row] = 0.00
					This.Object.signo			  	[row] = gnvo_app.is_null
					This.Object.cnta_ctbl	  		[row] = gnvo_app.is_null
					This.Object.flag_dh_cxp	  	[row] = gnvo_app.is_null
					This.Object.desc_cnta	  	[row] = gnvo_app.is_null
					This.Object.importe		  	[row] = 0.00
					
					MessageBox('Error', 'No existe el Item ' + ls_item + ' en el detalle del comprobante, por favor verifique', StopSign!)
					return 1
				end if
				
				ldc_imp_total = idw_detail.object.importe [ll_found]							
				
								
				This.Object.tasa_impuesto 	[row] = ldc_tasa_impuesto
				This.Object.signo			  	[row] = ls_signo
				This.Object.cnta_ctbl	  		[row] = ls_cnta_cntbl
				This.Object.flag_dh_cxp	  	[row] = ls_flag_dh_cxp
				This.Object.desc_cnta	  	[row] = ls_desc_cnta
				This.Object.importe		  	[row] = Round(ldc_imp_total * ldc_tasa_impuesto ,4)/ 100
				
				
				/*Total de Documento*/
				ldc_total = wf_totales ()		
				dw_master.object.importe_doc [1] = ldc_total
				dw_master.ii_update = 1  

		 CASE	'importe'
				/*Total de Documento*/
				ldc_total = wf_totales ()		
				dw_master.object.importe_doc [1] = ldc_total
				dw_master.ii_update = 1  					
END CHOOSE

end event

event ue_insert_pre(long al_row);call super::ue_insert_pre;Long ll_currow,ll_item

ll_currow = idw_detail.GetRow()
ll_item 	 = idw_detail.Object.item [ll_currow]

This.Object.item [al_row] = ll_item
end event

event itemerror;call super::itemerror;Return 1
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

event ue_display;call super::ue_display;boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_cnta_cntbl, ls_flag_dh_cxp, ls_signo, ls_item, ls_expresion
Long		ll_found
decimal	ldc_tasa_impuesto, ldc_importe


choose case lower(as_columna)
	case "tipo_impuesto"
		//Verifico y busco el importe en el detalle del comprobante
		ls_item = Trim(String(This.object.item [al_row]))
		
		ls_expresion = 'item = '+ls_item
		ll_found		 = idw_detail.find(ls_expresion, 1, idw_detail.Rowcount())
		
		IF ll_found = 0 THEN
			This.Object.tasa_impuesto 	[al_row] = 0.00
			This.Object.signo			  	[al_row] = gnvo_app.is_null
			This.Object.cnta_ctbl	  		[al_row] = gnvo_app.is_null
			This.Object.flag_dh_cxp	  	[al_row] = gnvo_app.is_null
			This.Object.desc_cnta	  	[al_row] = gnvo_app.is_null
			This.Object.importe		  	[al_row] = 0.00
			
			MessageBox('Error', 'No existe el Item ' + ls_item + ' en el detalle del comprobante, por favor verifique', StopSign!)
			return 
		end if
		
		//Obtengo el importe
		ldc_importe = idw_detail.object.importe [ll_found]	
		
		ls_sql = "select it.tipo_impuesto as tipo_impuesto, " &
				 + "it.desc_impuesto as descripcion_impuesto " &
				 + "from impuestos_tipo it " &
				 + "where it.cnta_ctbl is not null"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

		if ls_codigo <> '' then
			
			select it.cnta_ctbl, it.tasa_impuesto, it.signo, it.flag_dh_cxp
				into :ls_cnta_cntbl, :ldc_tasa_impuesto, :ls_signo, :ls_flag_dh_cxp
			from impuestos_tipo it
			where tipo_impuesto = :ls_codigo;
			
			
			
			this.object.tipo_impuesto		[al_row] = ls_codigo
			this.object.desc_impuesto	[al_row] = ls_data
			this.object.cnta_ctbl			[al_row] = ls_cnta_cntbl
			this.object.tasa_impuesto	[al_row] = ldc_tasa_impuesto
			this.object.signo				[al_row] = ls_signo
			this.object.flag_dh_cxp		[al_row] = ls_flag_dh_cxp
			This.Object.importe		  	[al_row] = Round(ldc_importe * ldc_tasa_impuesto ,4)/ 100
			
			this.ii_update = 1
		end if
		
end choose
end event

type tabpage_4 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 2798
integer height = 700
long backcolor = 79741120
string text = "Totales"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "PlaceColumn!"
long picturemaskcolor = 536870912
dw_totales dw_totales
end type

on tabpage_4.create
this.dw_totales=create dw_totales
this.Control[]={this.dw_totales}
end on

on tabpage_4.destroy
destroy(this.dw_totales)
end on

type dw_totales from u_dw_abc within tabpage_4
integer x = 5
integer y = 8
integer width = 2747
integer height = 656
integer taborder = 20
string dataobject = "d_tot_ctas_x_pagar_ext_ff"
boolean hscrollbar = false
boolean vscrollbar = false
end type

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

end event

event constructor;call super::constructor;is_mastdet = 'd'		   // 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'form'   // tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple


ii_ck[1] = 1			// columnas de lectrua de este dw
ii_rk[1] = 1 	      // columnas que recibimos del master


idw_mst  = dw_master							// dw_master
idw_det  = tab_1.tabpage_4.dw_totales	// dw_detail
end event

event itemerror;call super::itemerror;Return 1
end event

type tabpage_5 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 2798
integer height = 700
long backcolor = 79741120
string text = "Asiento"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "DropDownListBox2!"
long picturemaskcolor = 536870912
dw_pre_asiento_det dw_pre_asiento_det
dw_pre_asiento_cab dw_pre_asiento_cab
end type

on tabpage_5.create
this.dw_pre_asiento_det=create dw_pre_asiento_det
this.dw_pre_asiento_cab=create dw_pre_asiento_cab
this.Control[]={this.dw_pre_asiento_det,&
this.dw_pre_asiento_cab}
end on

on tabpage_5.destroy
destroy(this.dw_pre_asiento_det)
destroy(this.dw_pre_asiento_cab)
end on

type dw_pre_asiento_det from u_dw_abc within tabpage_5
integer width = 2629
integer taborder = 20
string dataobject = "d_abc_cnta_cntbl_pre_asiento_det_tbl"
borderstyle borderstyle = styleraised!
end type

event constructor;call super::constructor;is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 1 				// indica si se usa seleccion: 1=individual (default), 0=multiple


ii_ck[1] = 1			// columnas de lectrua de este dw
ii_ck[2] = 2			// columnas de lectrua de este dw
ii_ck[3] = 3			// columnas de lectrua de este dw
ii_ck[4] = 4			// columnas de lectrua de este dw
ii_ck[5] = 5			// columnas de lectrua de este dw
ii_ck[6] = 6			// columnas de lectrua de este dw


ii_rk[1] = 1 	      // columnas que recibimos del master
ii_rk[2] = 2	      // columnas que recibimos del master
ii_rk[3] = 3 	      // columnas que recibimos del master
ii_rk[4] = 4 	      // columnas que recibimos del master
ii_rk[5] = 5 	      // columnas que recibimos del master


idw_mst = tab_1.tabpage_5.dw_pre_asiento_cab // dw_master
idw_det = idw_asiento_det // dw_detail

end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event itemchanged;call super::itemchanged;Accepttext()

ib_estado_prea = FALSE   //Pre Asiento editado	
end event

event itemerror;call super::itemerror;Return 1
end event

event ue_insert_pre;call super::ue_insert_pre;this.object.flag_gen_aut[al_row] = '0'
end event

type dw_pre_asiento_cab from u_dw_abc within tabpage_5
boolean visible = false
integer y = 360
integer taborder = 20
string dataobject = "d_abc_cnta_cntbl_pre_asiento_cab_tbl"
end type

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                    	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 1 				// indica si se usa seleccion: 1=individual (default), 0=multiple


ii_ck[1] = 1			// columnas de lectrua de este dw
ii_ck[2] = 2			// columnas de lectrua de este dw
ii_ck[3] = 3			// columnas de lectrua de este dw
ii_ck[4] = 4			// columnas de lectrua de este dw
ii_ck[5] = 5			// columnas de lectrua de este dw

ii_dk[1] = 1 	      // columnas que se pasan al detalle
ii_dk[2] = 2 	      // columnas que se pasan al detalle
ii_dk[3] = 3 	      // columnas que se pasan al detalle
ii_dk[4] = 4 	      // columnas que se pasan al detalle
ii_dk[5] = 5 	      // columnas que se pasan al detalle

idw_mst = tab_1.tabpage_5.dw_pre_asiento_cab // dw_master
idw_det = idw_asiento_det // dw_detail
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event itemerror;call super::itemerror;Return 1
end event

event itemchanged;call super::itemchanged;Accepttext()
end event

event ue_insert_pre(long al_row);call super::ue_insert_pre;This.object.flag_tabla [al_row] = '3' //Cuentas x Pagar
end event

type dw_master from u_dw_abc within w_fi320_nota_debito_credito
integer width = 3767
integer height = 1200
string dataobject = "d_abc_cntas_pagar_nd_nc_tbl"
boolean hscrollbar = false
boolean vscrollbar = false
boolean livescroll = false
end type

event constructor;call super::constructor;is_mastdet = 'md'		// 'm' = master sin detalle (default), 'd' =  detalle,
                   	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez

ii_ck[1] = 1			// columnas de lectrua de este dw
ii_ck[2] = 2			// 
ii_ck[3] = 3			// 

ii_dk[1] = 1 	      // columnas que se pasan al detalle
ii_dk[2] = 2 	      // 
ii_dk[3] = 3 	      // 

idw_mst  = dw_master						 // dw_master
idw_det  = idw_detail // dw_detail

end event

event itemerror;call super::itemerror;Return 1
end event

event itemchanged;call super::itemchanged;String      ls_nom_proveedor, ls_forma_pago , ls_mes, ls_filtro, ls_codigo,&
				ls_nro_detraccion,ls_flag_detraccion, ls_flag_imp, ls_serie_cp, ls_numero_cp, &
				ls_proveedor, ls_tipo_doc, ls_nro_doc, ls_desc
Date        ld_fecha_emision, ld_fecha_vencimiento,ld_fecha_emision_old
Decimal 		ldc_tasa_cambio, ldc_tasa
Integer		li_dias_venc , li_opcion
Long        ll_nro_libro

try 
	ld_fecha_emision_old = Date(This.Object.fecha_emision [row])
	
	this.Accepttext()
	
	/*Datos del Registro Modificado*/
	ib_estado_prea = TRUE
	/**/
	
	
	CHOOSE CASE dwo.name
		case 'serie_cp' 
			
			ls_serie_cp = this.object.serie_cp [row]
			ls_numero_cp = this.object.numero_cp [row]
			
			if len(trim(ls_serie_cp)) < 4 then
				ls_serie_cp = gnvo_app.utilitario.lpad(ls_serie_cp, 4, '0')
				this.object.serie_cp [row] = ls_serie_cp
			end if
			
			
			if not IsNull(ls_numero_cp) and trim(ls_numero_cp) <> '' then
				ls_numero_cp = gnvo_app.utilitario.lpad(ls_numero_cp, 10, '0')
				this.object.numero_cp [row] = ls_numero_cp
			end if
			
			if not IsNull(ls_serie_cp) and not IsNull(ls_numero_cp) then
				//Valido si el documento ya ha sido registrado o no
				ls_proveedor	= this.object.cod_relacion [row]
				ls_tipo_doc  	= this.object.tipo_doc		[row]
				
				if not IsNull(ls_proveedor) and not IsNull(ls_tipo_doc) and trim(ls_proveedor) <> '' and trim(ls_tipo_doc) <> '' then
					if not invo_cntas_pagar.of_validar_doc( ls_proveedor, ls_tipo_doc, ls_serie_cp, ls_numero_cp) then 
						this.object.serie_cp [row] = gnvo_app.is_null
						this.SetColumn("serie_cp")
						return 1
					end if
					
				end if
				
				//GEnero el numero de documento
				ls_nro_doc = this.object.nro_doc [row]
				if is_action = 'new' or IsNull(ls_nro_doc) or trim(ls_nro_doc) = '' then
					this.object.nro_doc [row] = invo_cntas_pagar.of_get_nro_doc( ls_proveedor, ls_tipo_doc, ls_serie_cp, ls_numero_cp)
				end if
			end if
			
			return 2
		
		case 'numero_cp' 
			
			ls_serie_cp = this.object.serie_cp 		[row]
			ls_numero_cp = this.object.numero_cp 	[row]
			
			if not IsNull(ls_numero_cp) and trim(ls_numero_cp) <> '' then
				if IsNull(ls_serie_cp) or trim(ls_serie_cp) = '' then
					if MessageBox('Aviso', 'No ha ingresado un numero de serie, desea continuar ingresando el numero del comprobante de pago sin haber ingresado el numero de Serie?', &
						Information!, YesNo!, 2) = 2 then
						
						this.object.numero_cp [row] = gnvo_app.is_null
						this.setColumn("serie_cp")
						return 1
						
					end if
				end if
			end if
			
			if not IsNull(ls_numero_cp) and trim(ls_numero_cp) <> '' then
				ls_numero_cp = gnvo_app.utilitario.lpad(ls_numero_cp, 8, '0')
				this.object.numero_cp [row] = ls_numero_cp
			end if
			
			if not IsNull(ls_serie_cp) and not IsNull(ls_numero_cp) then
				//Valido si el documento ya ha sido registrado o no
				ls_proveedor	= this.object.cod_relacion [row]
				ls_tipo_doc  	= this.object.tipo_doc		[row]
				
				if not IsNull(ls_proveedor) and not IsNull(ls_tipo_doc) and trim(ls_proveedor) <> '' and trim(ls_tipo_doc) <> '' then
					if not invo_cntas_pagar.of_validar_doc( ls_proveedor, ls_tipo_doc, ls_serie_cp, ls_numero_cp) then 
						this.object.serie_cp [row] = gnvo_app.is_null
						this.SetColumn("serie_cp")
						return 1
					end if
					
				end if
				
				//GEnero el numero de documento
				ls_nro_doc = this.object.nro_doc [row]
				if is_action = 'new' or IsNull(ls_nro_doc) or trim(ls_nro_doc) = '' then
					this.object.nro_doc [row] = invo_cntas_pagar.of_get_nro_doc( ls_proveedor, ls_tipo_doc, ls_serie_cp, ls_numero_cp)
				end if
			end if
			
			return 2
	
			
		CASE	'tipo_doc'
			select nro_libro
				into :ll_nro_libro
			from doc_tipo
			where tipo_doc = :data
			  and flag_estado = '1';
			  
			IF SQLCA.SQLCode = 100 THEN
				Messagebox('Aviso','Tipo de Documento No Existe o no Esta Activo, por favor Verifique!')
				This.Object.tipo_doc 	[row] = gnvo_app.is_null
				This.Object.nro_libro	[row] = gnvo_app.il_null
				This.Object.motivo    	[row] = gnvo_app.is_null
				Return 1
			end if
				
			This.Object.nro_libro [row] = ll_nro_libro
			This.Object.motivo    [row] = gnvo_app.is_null
			 
		CASE	'motivo'	
				
			ls_tipo_doc = This.object.tipo_doc [row]
			
			if IsNull(ls_tipo_doc) or trim(ls_tipo_doc) = '' then
				MessageBox('Error', 'Debe especificar primero el tipo de documento. Por favor verifique!', StopSign!)
				this.setColumn( "tipo_doc" )
				return
			end if
			
			if ls_tipo_doc = gnvo_app.is_doc_ncp then
				ls_filtro = 'NCP'
			else
				ls_filtro = 'NDP'
			end if
			
			select t.descripcion 
				into :ls_desc
			from MOTIVO_NOTA t 
			where motivo = :data
			  and substr(t.motivo, 1, 3) = :ls_filtro;
					 
			IF SQLCA.SQLCode = 100 THEN
				Messagebox('Aviso','Motivo de Nota de Credito / Débito No Existe o no esta activo, por favor Verifique!')
				This.Object.motivo 		[row] = gnvo_app.is_null
				This.Object.desc_motivo	[row] = gnvo_app.il_null
				Return 1
			end if
				
			This.Object.desc_motivo    [row] = ls_desc
	
			 
		 CASE 'cod_relacion'
			
				IF idw_referencias.rowcount() > 0 THEN
					Messagebox('Aviso','No puede Cambiar El codigo del Cliente Tiene Documentos Referenciados , Verifique!')
					This.Object.cod_relacion [row] = idw_referencias.Object.cod_relacion [1]
					Return 1
				END IF
		
				SELECT prov.nom_proveedor
				  INTO :ls_nom_proveedor
				  FROM proveedor prov
				 WHERE prov.proveedor = :data 
					and flag_estado = '1';
						 
				
				IF SQLCA.SQLCode = 100 THEN
					Messagebox('Aviso','Proveedor No Existe o no Esta Activo, por favor Verifique!')
					This.Object.cod_relacion [row] = gnvo_app.is_null
					This.Object.nom_proveedor[row] = gnvo_app.is_null
					Return 1
				end if
				This.Object.nom_proveedor[row] = ls_nom_proveedor
				
		 
		 CASE	'motivo'
			
				ls_tipo_doc = This.Object.tipo_doc [row]				
				IF Isnull(ls_tipo_doc) OR Trim(ls_tipo_doc) = '' THEN
					Messagebox('Aviso','Debe Seleccionar Tipo de Documento ,Verifique')
					This.Object.motivo [row] = gnvo_app.is_null
					Return 1
				END IF
				
				IF idw_referencias.Rowcount() > 0 THEN
					This.Object.motivo [row] = This.Object.motivo_det[row]
					Messagebox('Aviso','No Puede Cambiar Motivo de Documento,'&
											+'Por que Tiene Documentos de Referencia ')
					Return 1
				END IF
				This.Object.motivo_det [row] = data
				
		 CASE	'fecha_emision'
				
				ld_fecha_emision     = Date(This.Object.fecha_emision [row])			
				ld_fecha_vencimiento	= Date(This.Object.vencimiento   [row])			
				ls_forma_pago			= This.Object.forma_pago [row]	
				
				IF ld_fecha_emision > ld_fecha_vencimiento THEN
					This.Object.fecha_emision [row] = ld_fecha_emision_old
					Messagebox('Aviso','Fecha de Emisión del Documento No '&
											+'Puede Ser Mayor a la Fecha de Vencimiento')
					Return 1
				END IF
		
				This.Object.tasa_cambio [row] = gnvo_app.of_tasa_cambio(ld_fecha_emision)
				
				IF Not (Isnull(ls_forma_pago) OR Trim(ls_forma_pago) = '') THEN
					
					li_dias_venc = idw_forma_pago.Getitemnumber(idw_forma_pago.getrow(),'dias_vencimiento')
				
					IF li_dias_venc > 0 THEN
						li_opcion = MessageBox('Aviso','Desea Generar Fecha de Vencimiento Dependiendo de la Forma de Pago', question!, YesNo!, 2)
						IF li_opcion = 1 THEN
							ld_fecha_vencimiento = Relativedate(Date(This.object.fecha_emision[row]),li_dias_venc)
							This.Object.vencimiento [row] = ld_fecha_vencimiento
						END IF
					END IF	
				END IF
				
				
		
		 CASE 'vencimiento'	
				ld_fecha_emision     = Date(This.Object.fecha_emision [row])			
				ld_fecha_vencimiento	= Date(This.Object.vencimiento   [row])			
				
				IF ld_fecha_vencimiento < ld_fecha_emision THEN
					This.Object.fecha_vencimiento [row] = ld_fecha_emision
					Messagebox('Aviso','Fecha de Vencimiento del Documento No '&
											+'Puede Ser Menor a la Fecha de Emisión')
					Return 1
				END IF
				
		 CASE	'forma_pago'
				li_dias_venc = idw_forma_pago.Getitemnumber(idw_forma_pago.getrow(),'dias_vencimiento')
				IF li_dias_venc > 0 THEN
					
					li_opcion = MessageBox('Aviso','Desea Generar Fecha de Vencimiento Dependiendo de la Forma de Pago', question!, YesNo!, 2)
					IF li_opcion = 1 THEN
						ld_fecha_vencimiento = Relativedate(Date(This.object.fecha_emision[row]),li_dias_venc)
						This.Object.vencimiento [row] = ld_fecha_vencimiento
					END IF
				ELSE
					This.Object.vencimiento [row] = This.object.fecha_emision[row]
				END IF
				
		 CASE 'periodo'
				ls_mes = Mid(data,1,2)
			
				IF Isnull(ls_mes) THEN
					Messagebox('Aviso','Debe Ingresar Un Periodo Valido, Verifique!')
					This.Object.periodo [row] = ''
					Return 1
				ELSEIF Integer(ls_mes) <= 0 OR Integer(ls_mes) > 12 THEN
					Messagebox('Aviso','Debe Ingresar Un Periodo Valido, Verifique!')
					This.Object.periodo [row] = ''
					Return 1
				END IF		
				
				
		
		
		CASE 'flag_detraccion'
			
			invo_detraccion.of_change_estado(this, is_Action)
				  
		CASE 'porc_detraccion'	
			
			  ls_flag_detraccion = This.object.flag_detraccion [row]	
			  
			  IF ls_flag_detraccion = '0' THEN
				  this.object.porc_detraccion	[row] = 0.00
				  Messagebox('Aviso','Documento no tiene indicador detracción Activo ,Verifique!')	  	
				  RETURN 1
			  END IF
			  
			  of_calcular_detraccion()
			
		CASE 'tasa_cambio'
			of_calcular_detraccion()
	
		CASE	'clase_bien_serv'
			select descripcion
				into :ls_desc
			  from sunat_tabla30
			 where codigo   = :data 
				and flag_estado = '1';
					  
			
			if sqlca.sqlcode = 100 then
				Messagebox('Aviso','Codigo de Clasificación de Bien o Servicio (SUNAT TABLA30) No Existe o Esta Inactivo,Verifique!')	
				this.object.clase_bien_serv      [row] = gnvo_app.is_null
				this.object.desc_clase_bien_serv	[row] = gnvo_app.is_null
				Return 1
			end if
			
			this.object.desc_clase_bien_serv [row] =	ls_desc
	
		CASE	'bien_serv'
			IF this.object.flag_detraccion[row] = '0' THEN
				this.object.bien_serv 	[row] = gnvo_app.is_null
				Messagebox('Aviso','Debe Seleccionar que Generara Detracción')
				this.setColumn("flag_detraccion")
				Return 2
			END IF
			
			select tasa_pdbe ,flag_ind_imp 
				into :ldc_tasa ,:ls_flag_imp 
			  from detr_bien_serv
			 where bien_serv   = :data 
				and flag_estado = '1';
					  
			
			if sqlca.sqlcode = 100 then
				Messagebox('Aviso','Codigo de Detraccion No Existe o Esta Inactivo,Verifique!')	
				this.object.bien_serv       [row] = gnvo_app.is_null
				this.object.flag_ind_imp    [row] =	gnvo_app.is_null
				this.object.porc_detraccion [row] =	0.00
				Return 1
			end if
			
			this.object.porc_detraccion [row] =	ldc_tasa
			this.object.flag_ind_imp    [row] =	ls_flag_imp
			
			
			of_calcular_detraccion()
			ib_modif_dtrp = false
					
		CASE	'imp_detraccion'
			ib_modif_dtrp = true
			  
	END CHOOSE

				
catch ( Exception ex )
	gnvo_app.of_catch_exception( ex, 'Error exception')

end try

end event

event ue_insert_pre;call super::ue_insert_pre;This.object.origen 			   [al_row] = gs_origen
This.object.cod_usr 			   [al_row] = gs_user
This.object.fecha_registro    [al_row] = f_fecha_actual()
This.object.fecha_emision 	   [al_row] = Date(f_fecha_actual())
This.object.vencimiento  	   [al_row] = Date(f_fecha_actual())
This.object.ano	 			   [al_row] = Long(String(f_fecha_actual(),'YYYY'))
This.object.mes	 			   [al_row] = Long(String(f_fecha_actual(),'MM'))
This.object.tasa_cambio 	   [al_row] = gnvo_app.of_tasa_cambio()
This.object.flag_estado 	   [al_row] = '1'
This.object.flag_provisionado [al_row] = 'R'
This.object.soles 				[al_row] = gnvo_app.is_soles
This.object.flag_detraccion	[al_row] = '0'

is_Action = 'new'
ib_modif_dtrp = false
invo_detraccion.of_change_estado(this, is_Action)
end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event ue_display;call super::ue_display;String      ls_name ,ls_prot, ls_sql, ls_codigo, ls_flag_detrac, ls_tasa, ls_data, &
				ls_flag_importe, ls_nro_libro, ls_filtro, ls_tipo_doc, ls_flag_cab_det
Decimal 		ldc_tasa_cambio
Boolean		lb_ret

CHOOSE CASE lower(as_columna)
		
	CASE 'cod_relacion'
		IF idw_referencias.RowCount() > 0 THEN
			Messagebox('Aviso','No puede	Cambiar El codigo del Cliente porque ya se ha ingresado Referencias')
			Return
		END IF

		ls_sql = 'SELECT distinct P.PROVEEDOR AS CODIGO_PROVEEDOR,'&
				 + 'P.NOM_PROVEEDOR AS razon_social ,'&
				 + 'p.ruc AS ruc_proveedor '&
				 + 'FROM PROVEEDOR P, '&
				 + "cntas_pagar cp " &
				 + "where cp.cod_relacion = p.proveedor " &
				 + "  and p.flag_estado = '1' " &
				 + "  and cp.flag_estado <> '0'"

		f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.cod_relacion	[al_row] = ls_codigo
			this.object.nom_proveedor	[al_row] = ls_data
			this.ii_update = 1
			ib_estado_prea = TRUE
		end if

	CASE	'clase_bien_serv'	
			
		ls_sql = "select codigo as codigo, " &
				 + "descripcion as descripcion " &
				 + "from sunat_tabla30 " &
				 + "where flag_estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, "2")
		
		if ls_codigo <> "" then
		
			this.object.clase_bien_serv       [al_row] = ls_codigo
			this.object.desc_clase_bien_serv  [al_row] = ls_data
			this.ii_update = 1
			
		end if
		

	CASE 'tipo_doc'
		IF idw_referencias.RowCount() > 0 THEN
			Messagebox('Aviso','No puede	Cambiar el Tipo de Documento porque ya se ha ingresado Referencias')
			Return
		END IF

		ls_sql = "SELECT DT.TIPO_DOC as tipo_doc, " &
				 + "DT.DESC_TIPO_DOC as descripcion_tipo_doc, " &
				 + "DT.NRO_LIBRO as nro_libro " &
				 + "FROM DOC_GRUPO_RELACION DGR, " &
				 + "FINPARAM F," &
				 + "DOC_TIPO DT " &
				 + "WHERE DGR.TIPO_DOC    = DT.TIPO_DOC " &
				 + "  and F.GRP_DOC_NVNTP = DGR.GRUPO " &
				 + "  and F.RECKEY        = '1' " &
				 + "order by dt.tipo_doc "

		f_lista_3ret(ls_sql, ls_codigo, ls_data, ls_nro_libro, '2')

		if ls_codigo <> '' then
			this.object.tipo_doc		[al_row] = ls_codigo
			this.object.nro_libro	[al_row] = Long(ls_nro_libro)
			
			
			This.Object.motivo    		[al_row] = gnvo_app.is_null
			This.Object.desc_motivo  	[al_row] = gnvo_app.is_null
		
		
			this.ii_update = 1
			ib_estado_prea = TRUE
		end if

	CASE	'motivo'	
			
		ls_tipo_doc = This.object.tipo_doc [al_row]
		
		if IsNull(ls_tipo_doc) or trim(ls_tipo_doc) = '' then
			MessageBox('Error', 'Debe especificar primero el tipo de documento. Por favor verifique!', StopSign!)
			this.setColumn( "tipo_doc" )
			return
		end if
		
		if trim(ls_tipo_doc) = trim(gnvo_app.is_doc_ncp) or ls_tipo_doc = 'CNC' then
			ls_filtro = 'NCP'
		else
			ls_filtro = 'NDP'
		end if
		
		ls_sql = "select t.motivo as motivo, " &
				 + "t.descripcion as descripcion_motivo, " &
				 + "t.flag_cab_det as flag_cab_det " &
				 + "from MOTIVO_NOTA t " &
				 + "where substr(t.motivo, 1, 3) = '" + ls_filtro + "'"
				 
		lb_ret = f_lista_3ret(ls_sql, ls_codigo, ls_data, ls_flag_cab_det, "2")
		
		if ls_codigo <> "" then
		
			this.object.motivo       [al_row] = ls_codigo
			this.object.desc_motivo	 [al_row] =	ls_data
			this.object.flag_cab_det [al_row] =	ls_flag_cab_det
			
			this.ii_update = 1
			/*Datos del Registro Modificado*/
			ib_estado_prea = TRUE
			/**/
		end if

	CASE	'bien_serv'	
			
		ls_flag_detrac = This.object.flag_detraccion [al_row]
		
		if ls_flag_detrac <> '1' then
			Messagebox('Aviso','Debe Seleccionar si realizara Detracción')
			Return 	
		end if
		
		ls_sql = "SELECT 	S.BIEN_SERV    AS CODIGO ,"&
				 + "			S.DESCRIPCION  AS DESCRIPCION ," &
				 + "		 	S.TASA_PDBE	  AS TASA_BIEN_SERV, "&
				 + "		 	S.FLAG_IND_IMP AS FLAG_IMPORTE	  "&	
				 + "  FROM DETR_BIEN_SERV S " & 
				 + " WHERE S.FLAG_ESTADO = '1'"
				 
		lb_ret = f_lista_4ret(ls_sql, ls_codigo, ls_data, ls_tasa, ls_flag_importe, "2")
		
		if ls_codigo <> "" then
		
			this.object.bien_serv       [al_row] = ls_codigo
			this.object.porc_detraccion [al_row] =	dec(ls_tasa)
			this.object.flag_ind_imp    [al_row] =	ls_flag_importe
			
			of_calcular_detraccion()
			ib_modif_dtrp = false
			this.ii_update = 1
			/*Datos del Registro Modificado*/
			ib_estado_prea = TRUE
			/**/
		end if
		
	CASE	'oper_detr'	
			
		ls_flag_detrac = This.object.flag_detraccion [al_row]
		
		if ls_flag_detrac <> '1' then
			Messagebox('Aviso','Debe Seleccionar si realizara Detracción')
			Return 	
		end if
		
		ls_sql = "select oper_detr as codigo_operacion, " &
				 + "descripcion as descripcion_operacion " &
				 + "from detr_operacion " &
				 + "where flag_estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, "2")
		
		if ls_codigo <> "" then
		
			this.object.oper_detr       [al_row] = ls_codigo
			this.ii_update = 1
			/*Datos del Registro Modificado*/
			ib_estado_prea = TRUE
			/**/
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

