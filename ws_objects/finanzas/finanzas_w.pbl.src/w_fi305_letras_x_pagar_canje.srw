$PBExportHeader$w_fi305_letras_x_pagar_canje.srw
forward
global type w_fi305_letras_x_pagar_canje from w_abc
end type
type dw_rpt from datawindow within w_fi305_letras_x_pagar_canje
end type
type rb_3 from radiobutton within w_fi305_letras_x_pagar_canje
end type
type rb_1 from radiobutton within w_fi305_letras_x_pagar_canje
end type
type tab_1 from tab within w_fi305_letras_x_pagar_canje
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
type dw_asiento from u_dw_abc within tabpage_2
end type
type tabpage_2 from userobject within tab_1
dw_asiento_det dw_asiento_det
dw_asiento dw_asiento
end type
type tab_1 from tab within w_fi305_letras_x_pagar_canje
tabpage_1 tabpage_1
tabpage_2 tabpage_2
end type
type cb_2 from commandbutton within w_fi305_letras_x_pagar_canje
end type
type cb_1 from commandbutton within w_fi305_letras_x_pagar_canje
end type
type dw_master from u_dw_abc within w_fi305_letras_x_pagar_canje
end type
type gb_1 from groupbox within w_fi305_letras_x_pagar_canje
end type
end forward

global type w_fi305_letras_x_pagar_canje from w_abc
integer width = 4151
integer height = 2592
string title = "[FI305] Canje de Documentos x Pagar"
string menuname = "m_mantenimiento_cl_anular"
event ue_anular ( )
event ue_print_voucher ( )
dw_rpt dw_rpt
rb_3 rb_3
rb_1 rb_1
tab_1 tab_1
cb_2 cb_2
cb_1 cb_1
dw_master dw_master
gb_1 gb_1
end type
global w_fi305_letras_x_pagar_canje w_fi305_letras_x_pagar_canje

type variables
Boolean 						ib_estado_asiento = FALSE
String  						is_accion, is_grp_ltp, is_cnta_cntbl, is_doc_ltp, is_soles, is_dolares, &
								is_confin_cnj_pag, is_confin, is_fp_pcon
decimal						idc_porc_ret_igv								

u_ds_base 					ids_voucher
n_cst_cri					invo_cri
n_cst_asiento_contable	invo_asiento_cntbl
u_dw_abc						idw_detail, idw_asiento_cab, idw_asiento_det
boolean						ib_cierre = false
end variables

forward prototypes
public function decimal wf_calcular_total ()
public subroutine wf_delete_doc_referencias ()
public subroutine wf_update_tcambio_det (decimal adc_tasa_cambio)
public subroutine wf_update_moneda_cab_det (string as_cod_moneda_cab)
public subroutine wf_ver_items_x_ret ()
public function boolean wf_verifica_flag_cntas (string as_cta_cntbl, string as_tipo_doc, string as_nro_doc, string as_cod_relacion, long al_row)
public subroutine of_asigna_dws ()
public function integer of_get_param ()
public subroutine of_get_cnta_cntbl (string as_tipo_doc)
public subroutine of_retrieve (string as_cod_relacion, string as_tipo_doc, string as_nro_doc)
public subroutine of_update_imp_retencion ()
public function boolean of_generacion_asiento ()
end prototypes

event ue_anular;String  ls_flag_estado ,ls_nro_certif
Long    ll_row         ,ll_inicio    ,ll_count
Integer li_opcion

dw_master.accepttext()

ll_row = dw_master.Getrow()


IF ll_row = 0 THEN 
	Messagebox('Aviso','No Existe Registro que Anular , Verifique!')
	RETURN
END IF	

if ib_cierre then 
	Messagebox('Aviso','Mes contable cerrado, coordinar con contabilidad')
	return
end if

ls_flag_estado = dw_master.object.flag_estado     [ll_row]
ls_nro_certif  = dw_master.object.nro_certificado [ll_row]

IF ls_flag_estado <> '1' THEN 
	Messagebox('Aviso','Estado Del Documento no Permitira Anular ')
	RETURN
END IF	

IF (dw_master.ii_update = 1                  OR idw_detail.ii_update      = 1 OR &
    idw_asiento_cab.ii_update = 1 OR idw_asiento_det.ii_update = 1 ) THEN
	 Messagebox('Aviso','Grabe Los Cambios Antes de Anular el Documento')
	 RETURN
END IF	 

//------------------------------------------------
li_opcion = MessageBox('Anula Letras x Pagar','Esta Seguro de Anular este Documento',Question!, Yesno!, 2)
IF li_opcion = 2 THEN RETURN
//------------------------------------------------


dw_master.deleterow(ll_row)


tab_1.tabpage_2.dw_asiento.object.flag_estado [1] = '0' //asiento anulado

FOR ll_inicio = 1 TO tab_1.tabpage_2.dw_asiento_det.Rowcount()
	 tab_1.tabpage_2.dw_asiento_det.object.imp_movsol [ll_inicio] = 0.00
	 tab_1.tabpage_2.dw_asiento_det.object.imp_movdol [ll_inicio] = 0.00
NEXT

//eliminar el detalle
wf_delete_doc_referencias ()

//****************************//
//Buscar si letra contiene CRI//
//****************************//
select Count(*) into :ll_count from retencion_igv_crt where (nro_certificado = :ls_nro_certif ) ;


IF ll_count > 0 THEN
	UPDATE retencion_igv_crt  
	   SET flag_estado = '0' , saldo_sol = 0.00 , saldo_dol = 0.00 , importe_doc = 0.00,flag_replicacion = '1'
	WHERE (nro_certificado = :ls_nro_certif) ;
	
	
	IF SQLCA.SQLCode = -1 THEN 
		Messagebox('Error',SQLCA.SQLErrText)
		Rollback ;
		Return
	END IF
	
END IF

	


dw_master.ii_update = 1
tab_1.tabpage_2.dw_asiento.ii_update     = 1
tab_1.tabpage_2.dw_asiento_det.ii_update = 1



is_accion = 'anular'

TriggerEvent('ue_modify')
/*No Generación Asientos*/
ib_estado_asiento = FALSE
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
	lstr_param.dw1 		= 'd_rpt_voucher_imp_cp_tbl'
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

public function decimal wf_calcular_total ();String 	ls_cod_moneda
Long   	ll_inicio,ll_factor,ll_row_master
Decimal 	ldc_monto_conv,ldc_importe_total,ldc_imp_ret, ldc_tasa_cambio



dw_master.Accepttext()
idw_detail.Accepttext()



//Datos de Cabecera
ll_row_master 		= dw_master.Getrow()
ldc_tasa_cambio 	= dw_master.object.tasa_cambio [ll_row_master]
ls_cod_moneda   	= dw_master.object.cod_moneda  [ll_row_master]


ldc_importe_total = 0.00

FOR ll_inicio = 1 TO idw_detail.Rowcount()
	ldc_monto_conv = idw_detail.object.monto_conv  	[ll_inicio]	
	ll_factor		= idw_detail.object.factor     	[ll_inicio]	
	ldc_imp_ret    = idw_detail.object.imp_ret_igv 	[ll_inicio]	


	 
	IF Isnull(ldc_monto_conv) THEN ldc_monto_conv = 0.00 
	IF Isnull(ll_factor)      THEN ll_factor      = 0.00 
	IF Isnull(ldc_imp_ret)    THEN ldc_imp_ret    = 0.00 
	 
	 
	if ls_cod_moneda = gnvo_app.is_dolares then
		ldc_imp_ret = ldc_imp_ret / ldc_tasa_cambio	
	end if
	
	ldc_importe_total = ldc_importe_total + (ldc_monto_conv * ll_factor) - ldc_imp_ret

NEXT				

Return ldc_importe_total
end function

public subroutine wf_delete_doc_referencias ();tab_1.tabpage_1.dw_detail.Accepttext()

DO WHILE tab_1.tabpage_1.dw_detail.Rowcount() > 0
	tab_1.tabpage_1.dw_detail.TriggerEvent('ue_delete')
LOOP


end subroutine

public subroutine wf_update_tcambio_det (decimal adc_tasa_cambio);Long ll_inicio

for ll_inicio = 1 to tab_1.tabpage_1.dw_detail.Rowcount()

	 tab_1.tabpage_1.dw_detail.object.tasa_cambio [ll_inicio] = adc_tasa_cambio
	 tab_1.tabpage_1.dw_detail.ii_update = 1
next



end subroutine

public subroutine wf_update_moneda_cab_det (string as_cod_moneda_cab);Long ll_inicio

for ll_inicio = 1 to tab_1.tabpage_1.dw_detail.Rowcount()

	 tab_1.tabpage_1.dw_detail.object.cod_moneda_cab [ll_inicio] = as_cod_moneda_cab
next


end subroutine

public subroutine wf_ver_items_x_ret ();String ls_expresion,ls_flag_retencion
Long   ll_found,ll_row_master

ll_row_master = dw_master.getrow()
Setnull(ls_flag_retencion)


tab_1.tabpage_1.dw_detail.Accepttext()

ls_expresion = "flag_ret_igv = '1'"
ll_found = tab_1.tabpage_1.dw_detail.find(ls_expresion,1,tab_1.tabpage_1.dw_detail.rowcount())

IF ll_found > 0 THEN
	dw_master.object.flag_retencion [ll_row_master] = '1'
ELSE
	dw_master.object.flag_retencion [ll_row_master] = ls_flag_retencion
END IF


dw_master.ii_update = 1
end subroutine

public function boolean wf_verifica_flag_cntas (string as_cta_cntbl, string as_tipo_doc, string as_nro_doc, string as_cod_relacion, long al_row);String  ls_flag_ctabco,ls_flag_cencos,ls_flag_doc_ref,ls_flag_cod_rel,&
		  ls_tipo_doc_ref,ls_nro_doc_ref,ls_cod_relacion,ls_cri,ls_flag_cbenef
Boolean lb_retorno = TRUE


select doc_ret_igv_crt into :ls_cri from finparam where reckey = '1' ;

IF f_cntbl_cnta(as_cta_cntbl,ls_flag_ctabco,ls_flag_cencos,ls_flag_doc_ref, &
					 ls_flag_cod_rel,ls_flag_cbenef)  THEN


	IF ls_flag_doc_ref = '1' THEN
		ls_tipo_doc_ref =	tab_1.tabpage_2.dw_asiento_det.object.tipo_docref1 [al_row]
		ls_nro_doc_ref  = tab_1.tabpage_2.dw_asiento_det.object.nro_docref1  [al_row]
		
		/*Verifico tipo de Documento*/
		IF Isnull(ls_tipo_doc_ref) OR Trim(ls_tipo_doc_ref) = '' THEN
			tab_1.tabpage_2.dw_asiento_det.object.tipo_docref1 [al_row] = as_tipo_doc
		END IF			
		/*Verifico Nro de Documento*/
		IF Isnull(ls_nro_doc_ref) OR Trim(ls_nro_doc_ref) = '' THEN
			
			IF ls_cri <> ls_tipo_doc_Ref  OR Isnull(ls_tipo_doc_Ref) THEN
				tab_1.tabpage_2.dw_asiento_det.object.nro_docref1 [al_row] = as_nro_doc
			END IF
			
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

/**/

Return lb_retorno
end function

public subroutine of_asigna_dws ();idw_detail = tab_1.tabpage_1.dw_detail
idw_asiento_cab = tab_1.tabpage_2.dw_asiento
idw_asiento_det = tab_1.tabpage_2.dw_asiento_det
end subroutine

public function integer of_get_param ();// Evalua parametros
string 	ls_mensaje

try
	is_grp_ltp = gnvo_app.of_get_parametro('GRP_LTP', 'LET')
	if ISNULL( is_grp_ltp ) or TRIM( is_grp_ltp ) = '' then
		Messagebox("Error", "Defina grupo de letras por pagar en configuración")
		return 0
	end if
	
	/*recupero doc.letra x pagar*/
	select doc_letra_pagar, NVL(porc_ret_igv, 0)
		into :is_doc_ltp, :idc_porc_ret_igv
	from finparam 
	where reckey = '1' ;

	if ISNULL( is_doc_ltp ) or TRIM( is_doc_ltp ) = '' then
		Messagebox("Error", "Defina documento de Letras por Pagar en FinParam")
		return 0
	end if
	
	//*** Logparam **///
	Select cod_soles, cod_dolares	
		into :is_soles, :is_dolares
	from logparam
	where reckey = '1';
	
	//*** Fin Param **///
	SELECT confin_cnj_let_pag, pago_contado
 	 INTO :is_confin_cnj_pag, :is_fp_pcon
  	FROM finparam
 	WHERE (reckey = '1') ;

	
	return 1
catch(Exception ex)
	f_mensaje(ex.getMessage(), '')
	return 0
end try



end function

public subroutine of_get_cnta_cntbl (string as_tipo_doc);string ls_parametro, ls_sql

try
	ls_parametro = 'CNTA_CANJE_' + as_tipo_doc
	
	is_cnta_cntbl = gnvo_app.of_get_parametro(ls_parametro, '')
	
	if ISNull(is_cnta_Cntbl) or is_cnta_cntbl = '' then
		ls_sql = "select cc.cnta_ctbl as cnta_cntbl, cc.desc_cnta as desc_cnta_cntbl " &
				 + "from cntbl_cnta cc " &
				 + "where cc.flag_estado = '1' "
				 
		if gnvo_app.of_prompt_value("Indique la cuenta contable para el tipo de documento: " + as_tipo_doc, is_cnta_cntbl, ls_Sql) then
			gnvo_app.of_set_parametro(ls_parametro, is_cnta_cntbl)
		end if
	end if
catch(Exception ex)
	f_mensaje(ex.getMessage(), '')
end try
end subroutine

public subroutine of_retrieve (string as_cod_relacion, string as_tipo_doc, string as_nro_doc);Long 		ll_row, ll_year, ll_mes, ll_nro_libro, ll_nro_asiento
String 	ls_origen

dw_master.Retrieve('C',as_cod_relacion, as_tipo_doc, as_nro_doc)

if dw_master.RowCount() > 0 then
	
	ls_origen 		= dw_master.object.origen 				[1]
	ll_year 			= Long(dw_master.object.ano			[1])
	ll_mes 			= Long(dw_master.object.mes			[1])
	ll_nro_libro	= Long(dw_master.object.nro_libro	[1])
	ll_nro_Asiento	= Long(dw_master.object.nro_Asiento	[1])
	
	idw_detail.Retrieve(as_cod_relacion, as_tipo_doc, as_nro_doc,'C')
	
	idw_asiento_cab.Retrieve(ls_origen, ll_year, ll_mes, ll_nro_libro, ll_nro_Asiento)
	idw_asiento_det.Retrieve(ls_origen, ll_year, ll_mes, ll_nro_libro, ll_nro_Asiento)

	ib_estado_asiento = False   //pre-asiento editado					
	is_accion = 'fileopen'	
	
	//Limpio los flags
	dw_master.ResetUpdate()
	idw_detail.ResetUpdate()
	idw_asiento_cab.ResetUpdate()
	idw_asiento_det.resetUpdate()

	dw_master.ii_update 			= 0
	idw_detail.ii_update 		= 0
	idw_asiento_cab.ii_update 	= 0
	idw_asiento_det.ii_update 	= 0

	//Lo convierto en no editable
	dw_master.ii_protect 		= 0
	idw_detail.ii_protect 		= 0
	idw_asiento_cab.ii_protect = 0
	idw_asiento_det.ii_protect = 0

	dw_master.of_protect()
	idw_detail.of_protect()
	idw_asiento_cab.of_protect()
	idw_asiento_det.of_protect()
	
	//Valido el cierre de mes
	if invo_asiento_cntbl.of_mes_cerrado( ll_year, ll_mes, "R") then
		ib_cierre = true
		dw_master.object.t_cierre.text = 'CERRADO X CONTABILIDAD'
	else
		dw_master.object.t_cierre.text = ''
		ib_cierre = false
	end if


end if	
end subroutine

public subroutine of_update_imp_retencion ();decimal 	ldc_imp_ret, ldc_ret_sol 
Long		ll_inicio

if dw_master.getRow() = 0 then return 

/*encontrar monto de retencion*/
ldc_ret_sol = 0
for ll_inicio = 1 to idw_detail.Rowcount()
	if idw_Detail.object.flag_ret_igv [ll_inicio] = '1' then
		ldc_imp_ret = Dec(idw_detail.object.imp_ret_igv [ll_inicio])
		IF Isnull(ldc_imp_ret) THEN ldc_imp_ret = 0.00
		//**Acumula en Soles
		ldc_ret_sol += ldc_imp_ret
	end if
next

if IsNull(dw_master.object.imp_retencion[dw_master.GetRow()]) or Dec(dw_master.object.imp_retencion[dw_master.GetRow()]) <> ldc_ret_sol then
	idw_detail.ii_update = 1
	dw_master.ii_update = 1
	
	dw_master.object.imp_retencion [dw_master.getRow()] = ldc_ret_sol
end if
end subroutine

public function boolean of_generacion_asiento ();Boolean 			lb_ret = FALSE
String  			ls_mensaje,ls_moneda,ls_nro_certificado
Long    			ll_row
Decimal 			ldc_tasa_cambio
str_parametros	lstr_param

try
	ll_row   = dw_master.Getrow()

	IF ll_row = 0 THEN RETURN false
	
	dw_master.Accepttext()
	idw_detail.Accepttext( )

	ls_moneda 		    = dw_master.object.cod_moneda      [ll_row]
	ldc_tasa_cambio    = dw_master.object.tasa_cambio     [ll_row]
	ls_nro_certificado =	dw_master.object.nro_certificado [ll_row]

	IF Isnull(ls_moneda) OR Trim(ls_moneda) = '' THEN
		Messagebox('Aviso','Debe Ingresar Algun Tipo de Moneda')
		dw_master.SetFocus()
		dw_master.Setcolumn('cod_moneda')
		Return false
	END IF
	
	IF Isnull(ldc_tasa_cambio) OR ldc_tasa_cambio = 0 THEN
		Messagebox('Aviso','Debe Ingresar Tasa de Cambio')
		dw_master.SetFocus()
		dw_master.Setcolumn('tasa_cambio')
		Return false
	END IF

	
	lstr_param.tipo_mov 			= 'P'
	lstr_param.accion 			= is_accion
	lstr_param.nro_certificado = ls_nro_certificado
	lstr_param.confin			 	= dw_master.object.confin	[dw_master.getRow()]//is_confin

	lb_ret = invo_asiento_cntbl.of_generar_asiento (dw_master			, &
																	idw_detail			, &
																	idw_asiento_Cab	, &
																	idw_asiento_det	, &
																	lstr_param)
												 
	IF lb_ret = true THEN
		idw_asiento_det.ii_update =1	
	END IF

catch(Exception ex)
	f_mensaje("Ha ocurrido una excepcion: " + ex.getMessage(), '')
	Return false
end try


end function

on w_fi305_letras_x_pagar_canje.create
int iCurrent
call super::create
if this.MenuName = "m_mantenimiento_cl_anular" then this.MenuID = create m_mantenimiento_cl_anular
this.dw_rpt=create dw_rpt
this.rb_3=create rb_3
this.rb_1=create rb_1
this.tab_1=create tab_1
this.cb_2=create cb_2
this.cb_1=create cb_1
this.dw_master=create dw_master
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_rpt
this.Control[iCurrent+2]=this.rb_3
this.Control[iCurrent+3]=this.rb_1
this.Control[iCurrent+4]=this.tab_1
this.Control[iCurrent+5]=this.cb_2
this.Control[iCurrent+6]=this.cb_1
this.Control[iCurrent+7]=this.dw_master
this.Control[iCurrent+8]=this.gb_1
end on

on w_fi305_letras_x_pagar_canje.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_rpt)
destroy(this.rb_3)
destroy(this.rb_1)
destroy(this.tab_1)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.dw_master)
destroy(this.gb_1)
end on

event resize;call super::resize;of_Asigna_dws()

tab_1.width  = newwidth  - tab_1.x - 10
tab_1.height = newheight - tab_1.y - 10

idw_detail.height = tab_1.tabpage_1.height - idw_detail.y - 10
idw_detail.width = tab_1.tabpage_1.width - idw_detail.x - 10

idw_asiento_det.height = tab_1.tabpage_2.height - idw_asiento_det.y - 10
idw_asiento_det.width = tab_1.tabpage_2.width - idw_asiento_det.x - 10


end event

event ue_open_pre;call super::ue_open_pre;String  ls_doc_lp,ls_confin
Long    ll_nro_libro

if of_get_param() <> 1 then
	Post Event Close()
	return
end if

of_asigna_dws()

dw_master.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos
idw_detail.SetTransObject(sqlca)
idw_asiento_cab.SetTransObject(sqlca)
idw_asiento_det.SetTransObject(sqlca)

idw_1 = dw_master              				// asignar dw corriente
idw_detail.BorderStyle = StyleRaised!			// indicar dw_detail como no activado


of_position_window(0,0)       			// Posicionar la ventana en forma fija

//** Datastore Voucher **//
ids_voucher = Create u_ds_base
ids_voucher.DataObject = 'd_rpt_voucher_imp_cp_tbl'
ids_voucher.SettransObject(sqlca)


//objecto para verificar cierre de mes contable
invo_asiento_cntbl = create n_cst_asiento_contable
invo_cri				 = create n_cst_cri
end event

event ue_insert;call super::ue_insert;Long  ll_row

IF idw_1 = tab_1.tabpage_1.dw_detail AND dw_master.il_row = 0 THEN
	MessageBox("Error", "No ha seleccionado registro Maestro")
	RETURN
END IF


IF idw_1 = dw_master THEN
	TriggerEvent('ue_update_request')

	is_accion = 'new'
	dw_master.Reset()
	idw_detail.Reset()
	idw_asiento_cab.Reset()
	idw_asiento_det.Reset()
	/*Generación Asientos*/
	ib_estado_asiento = TRUE
	/**/		
	cb_2.enabled = TRUE
else
	return
END IF

ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)


end event

event ue_update_request;call super::ue_update_request;Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
IF (dw_master.ii_update = 1                  OR tab_1.tabpage_1.dw_detail.ii_update      = 1 OR &
	 tab_1.tabpage_2.dw_asiento.ii_update = 1 OR tab_1.tabpage_2.dw_asiento_det.ii_update = 1 )  THEN
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	IF li_msg_result = 1 THEN
 		this.TriggerEvent("ue_update")
	ELSE
		dw_master.ii_update = 0
		tab_1.tabpage_1.dw_detail.ii_update = 0
		tab_1.tabpage_2.dw_asiento.ii_update = 0
		tab_1.tabpage_2.dw_asiento_det.ii_update = 0
	END IF
END IF

end event

event ue_delete;//override
Long  ll_row

if ib_cierre then return

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

event ue_insert_pos;call super::ue_insert_pos;tab_1.tabpage_2.dw_asiento.TriggerEvent('ue_insert')
dw_master.SetFocus ()
dw_master.SetColumn('nro_doc')

end event

event ue_delete_pos;call super::ue_delete_pos;Long ll_row

//Generación de Asientos
ib_estado_asiento = TRUE

ll_row = dw_master.Getrow()

IF ll_row = 0 THEN RETURN

dw_master.object.importe_doc [ll_row] = wf_calcular_total ()
dw_master.ii_update = 1

end event

event ue_update_pre;call super::ue_update_pre;Long     ll_row_master   ,ll_ano           ,ll_mes   ,ll_nro_libro,ll_nro_asiento, &
			ll_count_doc_ref,ll_count_asientos,ll_inicio
			
String   ls_result        ,ls_mensaje     ,ls_nro_cert  	,ls_flag_retencion, &
		   ls_flag_situacion,ls_cod_banco   ,ls_cod_origen ,&
			ls_flag_estado   ,ls_cod_relacion,ls_tipo_doc  	,ls_nro_doc       ,ls_cnta_cntbl    ,&
			ls_cod_moneda    ,ls_obs			,ls_cod_usr  	,ls_serie_cri	
			
Decimal 	ldc_tasa_cambio, 	ldc_totsoldeb,	ldc_totdoldeb ,ldc_totsolhab,ldc_totdolhab , &
			ldc_total_doc,		ldc_saldo_sol,	ldc_saldo_dol, ldc_imp_ret  ,ldc_ret_sol	 , &
			ldc_ret_dol
			
Datetime ldt_fecha_registro
Date		ld_fec_emision_cri, ld_fecha_emision

dwItemStatus ldis_status

String ls_mensajemm

try 
	dw_master.AcceptText()
	idw_detail.AcceptText()
	idw_asiento_cab.AcceptText()
	idw_asiento_det.AcceptText()
	
	/*Replicacion*/
	dw_master.of_set_flag_replicacion()
	idw_detail.of_set_flag_replicacion()
	idw_asiento_cab.of_set_flag_replicacion()
	idw_asiento_det.of_set_flag_replicacion()
	
	
	//if is_accion = 'delete' or is_accion = 'anular' then return
	ib_update_check = False	
	
	if is_accion = 'anular' then 
		ib_update_check = true
		return
	end if
	
	ll_row_master = dw_master.Getrow()
	
	IF ll_row_master = 0 THEN 
		Messagebox('Aviso','Debe Ingresar Registro en la Cabecera')
		Return
	END IF
	
	//Verificación de Cabecera de Documento
	IF gnvo_app.of_row_Processing( dw_master ) <> true then return
	IF gnvo_app.of_row_Processing( idw_detail ) <> true then return
	IF gnvo_app.of_row_Processing( idw_asiento_cab ) <> true then return
	IF gnvo_app.of_row_Processing( idw_asiento_det ) <> true then return
	
	//Datos de Cabecera
	ls_cod_origen      = dw_master.object.origen             [ll_row_master]
	ll_ano      		 = dw_master.object.ano                [ll_row_master]
	ll_mes      		 = dw_master.object.mes                [ll_row_master]
	ll_nro_libro		 = dw_master.object.nro_libro          [ll_row_master]
	ll_nro_asiento		 = dw_master.object.nro_asiento        [ll_row_master]
	ls_cod_relacion	 = dw_master.object.cod_relacion       [ll_row_master]
	ls_tipo_doc			 = dw_master.object.tipo_doc           [ll_row_master]
	ls_nro_doc			 = dw_master.object.nro_doc            [ll_row_master]
	ls_nro_cert 		 = dw_master.object.nro_certificado    		[ll_row_master]
	ls_serie_cri		 = dw_master.object.serie_cri	      			[ll_row_master]
	ls_flag_situacion  = dw_master.object.flag_situacion_ltr 		[ll_row_master]
	ld_fecha_emision	 = Date(dw_master.object.fecha_emision 		[ll_row_master])
	ls_flag_estado     = dw_master.object.flag_estado    	   		[ll_row_master]
	ls_cod_moneda 		 = dw_master.object.cod_moneda  		   		[ll_row_master]
	ldc_tasa_cambio    = dw_master.object.tasa_cambio    	   		[ll_row_master]
	ls_obs				 = dw_master.object.descripcion    	   		[ll_row_master]
	ldt_fecha_registro = DateTime(dw_master.object.fecha_registro	[ll_row_master])
	ls_cod_usr			 = dw_master.object.cod_usr 	 	      		[ll_row_master]
	ls_flag_retencion  = dw_master.object.flag_retencion     		[ll_row_master]
	ldc_total_doc		 = dw_master.object.importe_doc					[ll_row_master]
	is_confin			 = dw_master.object.confin							[ll_row_master]
	ld_fec_emision_cri = Date(dw_master.object.fec_emision_cri 		[ll_row_master])
	
	
	IF ls_cod_moneda = is_soles THEN 
		ldc_saldo_sol = ldc_total_doc
		ldc_saldo_dol = Round(ldc_total_doc / ldc_tasa_cambio ,2)
	ELSEIF ls_cod_moneda = is_dolares THEN
		ldc_saldo_sol = Round(ldc_total_doc *  ldc_tasa_cambio ,2)
		ldc_saldo_dol = ldc_total_doc
	END IF
	
	//saldos
	dw_master.object.saldo_sol [ll_row_master] = ldc_saldo_sol 
	dw_master.object.saldo_dol [ll_row_master] = ldc_saldo_dol
	
	/*verifica cierre de mes contable*/
	if not invo_asiento_cntbl.of_val_mes_cntbl(ll_ano,ll_mes,'R') then return
	
	//verificar si hay retencion
	//Verifico si tiene o no flag de retencion
	ls_flag_retencion = '0'
	FOR ll_inicio = 1 TO idw_detail.Rowcount()
		if idw_detail.object.flag_ret_igv [ll_inicio] = '1' then
			ls_flag_retencion = '1'
			exit
		END IF
	NEXT
	if ls_flag_retencion = '1' and gnvo_app.is_agente_ret = '0' then
		Messagebox('Aviso','Usted no es agente de retención para aplicar CERTIFICADO DE RETENCIÓN, por favor verifique')
		Return	
	end if
	
	//Si al menos uno tiene retención entonces hay que generar una retención
	IF ls_flag_retencion = '1' and is_action = 'new'  THEN //GENERAR COMPROBANTE DE RETENCION
		IF Isnull(ls_serie_cri) OR trim(ls_serie_cri) = '' THEN
			Messagebox('Aviso','Ingrese Serie de Comprobante de Retencion')
			Return
		END IF
	END IF

	dw_master.object.flag_retencion[ll_row_master] = ls_flag_retencion

	IF ls_flag_situacion <> '1' THEN
		ls_cod_banco = dw_master.object.banco_ltr [ll_row_master]
		IF Isnull(ls_cod_banco) OR Trim(ls_cod_banco) = '' THEN
			Messagebox('Aviso','Debe Ingresar codigo de Banco , Verifique!')
			dw_master.SetFocus()
			dw_master.SetColumn('cod_banco')
			RETURN
		END IF
	END IF
	
	
	//Asignación de Nro Libro y generación de numero de Asiento
	IF is_accion = 'new' THEN
		/******/
		ll_nro_libro = invo_asiento_cntbl.of_nro_libro(ls_tipo_doc)	 
		
		IF Isnull(ll_nro_libro)  OR ll_nro_libro <= 0 THEN return
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
		
		IF invo_asiento_cntbl.of_get_nro_asiento( ls_cod_origen, ll_ano, ll_mes, ll_nro_libro, ll_nro_asiento)  = FALSE THEN return
		
		dw_master.object.nro_asiento [1] = ll_nro_asiento 
		dw_master.object.nro_libro   [1] = ll_nro_libro
		
		//asignación de año y mes cab contable
		idw_asiento_cab.Object.ano 			[1] = ll_ano
		idw_asiento_cab.Object.mes 			[1] = ll_mes
		idw_asiento_cab.object.nro_asiento 	[1] = ll_nro_asiento 
		idw_asiento_cab.object.nro_libro   	[1] = ll_nro_libro
	
	END IF
	
	//genero retencion igv crt
	IF ls_flag_retencion = '1' THEN //GENERAR COMPROBANTE DE RETENCION
		
		/*encontrar monto de retencion*/
		for ll_inicio = 1 to idw_detail.Rowcount()
			if idw_Detail.object.flag_ret_igv [ll_inicio] = '1' then
				ldc_imp_ret = Dec(idw_detail.object.imp_ret_igv [ll_inicio])
				IF Isnull(ldc_imp_ret) THEN ldc_imp_ret = 0.00
				//**Acumula en Soles
				ldc_ret_sol = ldc_ret_sol + ldc_imp_ret
			end if
		next
		
		ldc_ret_dol = Round(ldc_ret_sol / ldc_tasa_cambio,2)
		
		/**/
		/***generar numero para comprobantes de retencion***/
		if is_action = "new" or IsNull(ls_nro_cert) or ls_nro_cert = '' then
			
			//Obtengo el numero de Serie Correspondiente al CRI
			IF invo_cri.of_get_nro_cri(ls_serie_cri, ls_nro_cert) = FALSE THEN 
				rollback;
				RETURN
			end if	 
	
			/*ASIGNACION DE NUMERO DE C. RETENCION X C.RELACION*/
			dw_master.object.nro_certificado			[dw_master.getRow()] = ls_nro_cert
				 
		else
			ls_nro_cert = dw_master.object.nro_certificado [dw_master.getRow()] 
		end if
		
		
		
		//CREO REGISTRO DE C.RETENCION
		invo_cri.is_nro_Certificado 	= ls_nro_cert
		invo_cri.id_fecha_emision 		= ld_fec_emision_cri
		invo_cri.is_origen				= ls_cod_origen
		invo_cri.is_flag_estado			= '1'
		invo_cri.is_flag_tabla			= '3'
		invo_cri.idc_importe_doc		= ldc_ret_sol
		invo_cri.idc_saldo_sol			= ldc_ret_sol
		invo_cri.idc_importe_doc		= ldc_ret_dol
		invo_cri.idc_tasa_cambio		= ldc_tasa_cambio
		invo_cri.is_cod_relacion		= ls_cod_relacion
		IF not invo_cri.of_update() THEN
			rollback;
			RETURN
		END IF
		
		dw_master.ii_update = 1
		
	ELSE
		SetNull(ls_nro_cert)
		dw_master.object.nro_certificado [dw_master.getRow()]  = gnvo_app.is_null
		dw_master.ii_update = 1
	END IF
	
	
	/*Generación Pre-Asientos*/
	IF ib_estado_asiento THEN
		IF of_generacion_asiento() = FALSE THEN
			ib_update_check = False	
			RETURN
		END IF
	END IF
	
	//Acumulador de Registro de doc Referencias
	ll_count_doc_ref  = idw_detail.Rowcount()
	//Acumulador de Registro de Pre Asientos
	ll_count_asientos = idw_asiento_det.Rowcount()
	
	//Documento de Referencia
	
	IF ls_flag_estado = '1'  THEN
		IF ll_count_doc_ref = 0 THEN
			rollback;
			Messagebox('Aviso','Debe Ingresar Algun Tipo de Documento de Referencia')
			RETURN
		END IF
		
	END IF
	
	//Asiento Detalle
	IF ll_count_asientos = 0 THEN
		rollback;
		Messagebox('Aviso','Debe Revisar Concepto Financiero y Matriz Contable Ingresadas')	
		RETURN
	END IF
	
	
	
	
	//Documento de Referencia
	FOR ll_inicio = 1 TO ll_count_doc_ref
		 //REGISTRO NUEVOS ACTUALIZAR PK
		idw_detail.Object.cod_relacion [ll_inicio] = ls_cod_relacion	
		idw_detail.Object.tipo_doc     [ll_inicio] = ls_tipo_doc
		idw_detail.Object.nro_doc      [ll_inicio] = ls_nro_doc
	NEXT
	
	//Asigancion de Datos en Cabecera de Asiento
	IF is_accion = 'new' THEN
		idw_asiento_cab.Object.origen		 	[1] = ls_cod_origen
		idw_asiento_cab.Object.ano			 	[1] = ll_ano
		idw_asiento_cab.Object.mes			 	[1] = ll_mes
		idw_asiento_cab.Object.nro_libro	 	[1] = ll_nro_libro
		idw_asiento_cab.Object.nro_asiento 	[1] = ll_nro_asiento
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
		
		 idw_asiento_det.object.fec_cntbl   [ll_inicio] = ld_fecha_emision
		 
		 IF wf_verifica_flag_cntas(ls_cnta_cntbl,ls_tipo_doc,ls_nro_doc,ls_cod_relacion,ll_inicio) = FALSE THEN
			 RETURN
		END IF
	
	NEXT
	
	//Obtencion de Acumualdores en Pre Asiento Detalle
	ldc_totsoldeb = idw_asiento_det.object.monto_soles_cargo	  [1]
	ldc_totdoldeb = idw_asiento_det.object.monto_dolares_cargo [1]
	ldc_totsolhab = idw_asiento_det.object.monto_soles_abono   [1]
	ldc_totdolhab = idw_asiento_det.object.monto_dolares_abono [1]
	
	
	//Datos Adicionales de Cabecera en Asiento
	idw_asiento_cab.Object.cod_moneda	[1] = ls_cod_moneda
	idw_asiento_cab.Object.tasa_cambio  [1] = ldc_tasa_cambio
	idw_asiento_cab.Object.desc_glosa	[1] = ls_obs
	idw_asiento_cab.Object.fec_registro [1] = f_fecha_Actual()
	idw_asiento_cab.Object.fecha_cntbl  [1] = ld_fecha_emision
	idw_asiento_cab.Object.cod_usr		[1] = ls_cod_usr
	idw_asiento_cab.Object.flag_estado	[1] = ls_flag_estado
	idw_asiento_cab.Object.tot_solhab	[1] = ldc_totsolhab
	idw_asiento_cab.Object.tot_dolhab	[1] = ldc_totdolhab
	idw_asiento_cab.Object.tot_soldeb	[1] = ldc_totsoldeb
	idw_asiento_cab.Object.tot_doldeb	[1] = ldc_totdoldeb
	
	IF idw_detail.ii_update = 1  OR idw_asiento_det.ii_update = 1 THEN dw_master.ii_update = 1	
	IF dw_master.ii_update = 1 THEN idw_asiento_cab.ii_update = 1	
	
	
	// valida asientos descuadrados
	if invo_asiento_cntbl.of_validar_asiento(idw_asiento_det) = false then return
	
	ib_update_check = true
	
Catch(exception ex)
	ROLLBACK;
	f_mensaje(ex.getMessage(), '')
	ib_update_check = False	
	RETURN
end try


end event

event ue_update;call super::ue_update;Boolean lbo_ok = TRUE
String  ls_origen, ls_mensaje, ls_voucher
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
IF idw_asiento_det.ii_update = 1 and is_accion <> 'new' THEN
	ll_row_det     = idw_asiento_cab.Getrow()
	ls_origen      = idw_asiento_cab.Object.origen      [ll_row_det]
	ll_ano         = idw_asiento_cab.Object.ano         [ll_row_det]
	ll_mes         = idw_asiento_cab.Object.mes         [ll_row_det]
	ll_nro_libro   = idw_asiento_cab.Object.nro_libro   [ll_row_det]
	ll_nro_asiento = idw_asiento_cab.Object.nro_asiento [ll_row_det]
	
	ls_voucher = ls_origen + '-' + string(ll_ano, '0000') + '-' + string(ll_mes, '00') + '-' + string(ll_nro_libro, '00') + '-' + string(ll_nro_Asiento, '000000')
	
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
		lbo_ok = idw_asiento_det.of_save_log()
		lbo_ok = idw_asiento_cab.of_save_log()
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
	
	if is_accion = 'new' then
		ls_mensaje = "Grabación realizada satisfactoriamente, Vourcher Generado: " + ls_voucher
	else
		ls_mensaje = "Cambios realizados han sido grabados satisfactoriamente"
	end if
	
	is_accion = 'fileopen'
	TriggerEvent('ue_modify')
	ib_estado_asiento = FALSE
	
	f_mensaje(ls_mensaje, '')
END IF

end event

event ue_retrieve_list;call super::ue_retrieve_list;//override
// Asigna valores a structura 
Long   ll_row , ll_inicio
str_parametros sl_param

TriggerEvent ('ue_update_request')		

sl_param.dw1    = 'd_abc_lista_letras_tbl'
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
sl_param.string1 =  " AND (CP.FLAG_TIPO_LTR = 'C')    " &
						 +'ORDER BY CP.FECHA_EMISION ASC  '

OpenWithParm( w_lista, sl_param)

sl_param = Message.PowerObjectParm
IF sl_param.titulo <> 'n' THEN
	of_retrieve(sl_param.field_ret[1],sl_param.field_ret[2],sl_param.field_ret[3])
END IF


end event

event ue_modify;call super::ue_modify;Long    ll_row,ll_count,ll_ano,ll_mes
String  ls_nro_certificado, ls_flag_estado
Integer li_protect

ll_row = dw_master.Getrow()

IF ll_row = 0 THEN RETURN

ls_nro_certificado 	= dw_master.object.nro_certificado 	[ll_row]
ls_flag_estado 		= dw_master.object.flag_estado 		[ll_row]
ll_ano         		= dw_master.object.ano         		[ll_row]
ll_mes         		= dw_master.object.mes         		[ll_row]

if ib_cierre then 
	Messagebox('Aviso','Mes contable cerrado, coordinar con contabilidad')
	dw_master.ii_protect = 0
	dw_master.of_protect()
	
	idw_detail.ii_protect = 0
	idw_detail.of_protect()
	
	idw_asiento_det.ii_protect = 0
	idw_asiento_det.of_protect()
	return
end if

/*verifica cierre*/
if not invo_asiento_cntbl.of_val_mes_cntbl(ll_ano,ll_mes,'R') then 
	dw_master.ii_protect = 0
	dw_master.of_protect()
	
	idw_detail.ii_protect = 0
	idw_detail.of_protect()
	
	idw_asiento_det.ii_protect = 0
	idw_asiento_det.of_protect()
	
	return 
end if

//bloqueo
dw_master.of_protect()
idw_detail.of_protect()
idw_asiento_det.of_protect()

select count(*) into :ll_count from retencion_igv_crt
where nro_certificado = :ls_nro_certificado ;

IF ll_count = 0 THEN 
	cb_2.Enabled = TRUE
ELSE
	cb_2.Enabled = FALSE
END IF

IF ls_flag_estado = '1' THEN //ACTIVO Y NO TENGA RETENCIONES
	IF is_accion <> 'new' THEN
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
ELSE
	dw_master.ii_protect = 0
	tab_1.tabpage_1.dw_detail.ii_protect = 0
	dw_master.of_protect()
	tab_1.tabpage_1.dw_detail.of_protect()
	
	//SI MES CONTABLE ESTA CERRADO O LETRA YA PASO A OTRO ESTADO DIFERENTE A GENERADO BLOQUEAR ASIENTO
	IF ls_flag_estado <> '1' THEN
		idw_asiento_det.ii_protect = 0
		idw_asiento_det.of_protect()
	END IF
END IF
end event

event ue_print;call super::ue_print;String 			ls_nro_certificado,ls_nro_doc,ls_cod_relacion
Long   			ll_row_master
str_parametros	lstr_param

dw_master.Accepttext()
ll_row_master = dw_master.Getrow()

ls_cod_relacion = dw_master.object.cod_relacion [ll_row_master]
ls_nro_doc      = dw_master.object.nro_doc      [ll_row_master]

ls_nro_certificado = dw_master.object.nro_certificado [ll_row_master]

//si check de prevista esta activo viaulizar impresion
Open(w_print_preview)
lstr_param = Message.PowerObjectParm
if lstr_param.i_return < 0 then return

invo_cri.of_print(ls_nro_certificado, lstr_param)


end event

event close;call super::close;destroy ids_voucher
destroy invo_asiento_cntbl
destroy invo_cri

end event

type dw_rpt from datawindow within w_fi305_letras_x_pagar_canje
boolean visible = false
integer x = 4014
integer y = 40
integer width = 142
integer height = 100
integer taborder = 40
string title = "none"
boolean border = false
boolean livescroll = true
end type

type rb_3 from radiobutton within w_fi305_letras_x_pagar_canje
integer x = 3241
integer y = 460
integer width = 667
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Formato Letras x Pagar"
end type

type rb_1 from radiobutton within w_fi305_letras_x_pagar_canje
integer x = 3241
integer y = 372
integer width = 667
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Formato Retencion Lima"
boolean checked = true
end type

type tab_1 from tab within w_fi305_letras_x_pagar_canje
integer y = 1244
integer width = 4064
integer height = 1000
integer taborder = 40
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
				IF ib_estado_asiento = FALSE THEN RETURN
		 		of_generacion_asiento()
END CHOOSE

end event

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 4027
integer height = 872
long backcolor = 79741120
string text = " Documentos de Referencia"
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
event ue_items ( )
integer width = 3945
integer height = 844
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_abc_doc_ref_letras_x_pagar_tbl"
borderstyle borderstyle = styleraised!
end type

event ue_items();Long ll_row_master


ll_row_master = dw_master.Getrow()           
//verifico que item detalle tenga retencion
wf_ver_items_x_ret ()


//recalcular 
dw_master.object.importe_doc [ll_row_master] = wf_calcular_total ()
dw_master.ii_update = 1
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

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
       ls_tipo_ref   ,ls_nro_ref      ,ls_accion   ,ls_flag_estado,&
		 ls_moneda_det
		 
Decimal ldc_importe, ldc_imp_retencion, ldc_tasa_cambio
Long   ll_row_master
dwItemStatus ldis_status


Accepttext()
//Generacion de Asientos Automaticos
ib_estado_asiento = TRUE




choose case dwo.name
	case 'imp_ret_igv'
		ll_row_master = dw_master.Getrow()
		//recalcular 
		of_update_imp_retencion()
		
		dw_master.object.importe_doc [ll_row_master] = wf_calcular_total ()
		dw_master.ii_update = 1	
		
		
		
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
		
		//Verifico si hay que cambiar la retencion
		IF this.object.flag_ret_igv[row] = '1' THEN /*CALCULAR IMPORTE DE RETENCION*/
		
			ldc_importe     = This.object.importe        [row] 		
			ls_moneda_det   = This.object.cod_moneda_det [row] 					
			ldc_tasa_cambio = This.object.tasa_cambio    [row] 					
			
			IF ls_moneda_det <> is_soles THEN 
				ldc_importe   = Round(ldc_importe * ldc_tasa_cambio,2)
			END IF
		  
			ldc_imp_retencion = Round((ldc_importe * idc_porc_ret_igv)/ 100,2)
			This.object.imp_ret_igv [row] = ldc_imp_retencion					
			 
		ELSE /*INICIALIZAR IMOPORTE DE RETENCION*/
			This.object.imp_ret_igv [row] = 0.00
		END IF

		
		f_verifica_monto_ref(ls_cod_relacion,ls_tipo_doc,ls_nro_doc,ls_origen_ref,ls_tipo_ref,ls_nro_ref,ls_accion,ldc_importe,ls_flag_estado)				
		
		
		//recalcular 
		dw_master.object.importe_doc [ll_row_master] = wf_calcular_total ()
		dw_master.ii_update = 1
		
		of_update_imp_retencion()
				
				
	case 'flag_ret_igv'			
	
		
		IF data = '1' THEN /*CALCULAR IMPORTE DE RETENCION*/
		
			ldc_importe     = This.object.importe        [row] 		
			ls_moneda_det   = This.object.cod_moneda_det [row] 					
			ldc_tasa_cambio = This.object.tasa_cambio    [row] 					
			
			IF ls_moneda_det <> is_soles THEN 
				ldc_importe   = Round(ldc_importe * ldc_tasa_cambio,2)
			END IF
		  
			ldc_imp_retencion = Round((ldc_importe * idc_porc_ret_igv)/ 100,2)
			This.object.imp_ret_igv [row] = ldc_imp_retencion					
			 
		ELSE /*INICIALIZAR IMOPORTE DE RETENCION*/
			This.object.imp_ret_igv [row] = 0.00
		END IF
		
		of_update_imp_retencion()
		PostEvent('ue_items')

				
end choose

end event

event ue_insert_pre;call super::ue_insert_pre;this.object.flag_ret_igv	[al_row] = '0'
this.object.tasa_cambio		[al_row] = dw_master.object.tasa_cambio[dw_master.getRow()]

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
			ib_estado_asiento = TRUE
			/**/
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

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 4027
integer height = 872
long backcolor = 79741120
string text = " Asientos Contables"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "Cursor!"
long picturemaskcolor = 536870912
dw_asiento_det dw_asiento_det
dw_asiento dw_asiento
end type

on tabpage_2.create
this.dw_asiento_det=create dw_asiento_det
this.dw_asiento=create dw_asiento
this.Control[]={this.dw_asiento_det,&
this.dw_asiento}
end on

on tabpage_2.destroy
destroy(this.dw_asiento_det)
destroy(this.dw_asiento)
end on

type dw_asiento_det from u_dw_abc within tabpage_2
integer width = 3675
integer height = 384
integer taborder = 20
string dataobject = "d_abc_cnta_cntbl_pre_asiento_det_tbl"
end type

event itemerror;call super::itemerror;Return 1
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

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



idw_mst = tab_1.tabpage_2.dw_asiento
idw_det = tab_1.tabpage_2.dw_asiento_det
end event

event itemchanged;call super::itemchanged;Accepttext()

//No Generacion de Asientos Automaticos
ib_estado_asiento = FALSE
end event

event ue_insert_pre;call super::ue_insert_pre;this.object.flag_gen_aut[al_row] = '0'
end event

type dw_asiento from u_dw_abc within tabpage_2
boolean visible = false
integer x = 18
integer y = 440
integer width = 3694
integer height = 232
integer taborder = 20
string dataobject = "d_abc_cnta_cntbl_pre_asiento_cab_tbl"
end type

event itemerror;call super::itemerror;Return 1 
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

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

idw_mst  = tab_1.tabpage_2.dw_asiento
idw_det  = tab_1.tabpage_2.dw_asiento_det
end event

event itemchanged;call super::itemchanged;Accepttext()
end event

event ue_insert_pre;call super::ue_insert_pre;This.Object.flag_tabla [al_row] = '3' //LETRAS x Pagar
end event

type cb_2 from commandbutton within w_fi305_letras_x_pagar_canje
integer x = 3209
integer y = 156
integer width = 645
integer height = 112
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "&Retenciones"
end type

event clicked;///**************Declaracion de Variables*************/
String 	ls_soles   ,ls_dolares ,ls_flag_retencion,ls_flag_ret_igv,ls_cod_proveedor,&
		 	ls_tipo_doc,ls_cadena  ,ls_fec_ini_ret   ,ls_nro_doc     ,ls_moneda_det   ,&
		 	ls_flag_impuesto,ls_dgp_ret_igv 
Decimal 	ldc_imp_min_ret_igv,ldc_porc_ret_igv   ,ldc_imp_pagar    , ldc_total_pagar ,&
         ldc_imp_total      ,ldc_imp_total_pagar,ldc_imp_retencion, ldc_tasa_cambio
Datetime	ldt_fec_ini_ret,ldt_fecha_emision
Long     ll_row_master,ll_inicio,ll_count,ll_factor
Boolean  lb_flag = FALSE

/*datos de Cabecera*/
dw_master.accepttext()
tab_1.tabpage_1.dw_detail.accepttext()

if ib_cierre then 
	Messagebox('Aviso','Mes contable cerrado, coordinar con contabilidad')
	return
end if

ll_row_master = dw_master.Getrow()


ls_cod_proveedor = dw_master.object.cod_relacion [ll_row_master]
ldc_tasa_cambio  = dw_master.object.tasa_cambio  [ll_row_master]

IF Isnull(ls_cod_proveedor) OR Trim(ls_cod_proveedor) = '' THEN
	Messagebox('Aviso','Debe Ingresar Un Codigo de Relacion ,Verifique!')
	dw_master.setFocus()
	dw_master.setColumn('cod_relacion')
	GOTO SALIDA
END IF


//*************Programa de Retenciones**************/
f_monedas(ls_soles,ls_dolares)

//*datos de archivos de parametros*//
SELECT flag_retencion,imp_min_ret_igv,porc_ret_igv,doc_grupo_ret_igv,fecha_inicio_ret_igv
  INTO :ls_flag_retencion,:ldc_imp_min_ret_igv,:ldc_porc_ret_igv,:ls_dgp_ret_igv,:ldt_fec_ini_ret
  FROM finparam
 WHERE (reckey = '1' ) ;

/*Verifico parametros*/
IF ls_flag_retencion = '0' THEN
	Messagebox('Aviso','Empresa No Realiza Retenciones')
	GOTO SALIDA
END IF




/**VERIFICAR FLAG RETENCION DE PROVEEDOR**/
SELECT p.flag_ret_igv INTO :ls_flag_ret_igv  FROM proveedor  p WHERE (p.proveedor = :ls_cod_proveedor );


IF ls_flag_ret_igv = '0' THEN //no retiene
	Messagebox('Aviso','Proveedor No Habiliatdo para Retenciones')
	GOTO SALIDA
END IF


DECLARE c_doc_retencion CURSOR FOR  
 SELECT doc_grupo_relacion.tipo_doc
   FROM doc_grupo_relacion
  WHERE doc_grupo_relacion.grupo = :ls_dgp_ret_igv ;
  
OPEN c_doc_retencion ;
DO
// Lee datos de cursor
FETCH c_doc_retencion into :ls_tipo_doc;

	IF SQLCA.SQLCODE = 100 THEN EXIT
	
	IF Isnull(ls_cadena) OR Trim(ls_cadena) = '' THEN
   	ls_cadena = "'"+ls_tipo_doc+"'"
	ELSE
		ls_cadena = ls_cadena +", '"+ls_tipo_doc+"'"
	END IF
	// Continua proceso
	LOOP WHILE TRUE
CLOSE c_doc_retencion ;


ls_cadena 		= 'tipo_ref in ('+ls_cadena+')'
ls_fec_ini_ret = String(ldt_fec_ini_ret,'yyyymmdd')

tab_1.tabpage_1.dw_detail.SetFilter(ls_cadena)
tab_1.tabpage_1.dw_detail.Filter()


FOR ll_inicio = 1 TO tab_1.tabpage_1.dw_detail.Rowcount()
	 ls_tipo_doc   = tab_1.tabpage_1.dw_detail.object.tipo_ref       [ll_inicio]
	 ls_nro_doc    = tab_1.tabpage_1.dw_detail.object.nro_ref        [ll_inicio]
	 ldc_imp_pagar = tab_1.tabpage_1.dw_detail.object.importe        [ll_inicio] 
	 ls_moneda_det	= tab_1.tabpage_1.dw_detail.object.cod_moneda_det [ll_inicio] 
	 ll_factor     = tab_1.tabpage_1.dw_detail.object.factor         [ll_inicio] 
	 
	 /*busqueda en impuesto cntas x pagar*/		 
	 SELECT Count(*) INTO :ll_count FROM cp_doc_det_imp
     WHERE ((cod_relacion = :ls_cod_proveedor ) AND
	  		   (tipo_doc     = :ls_tipo_doc      ) AND
			   (nro_doc		  = :ls_nro_doc       ));
	 /**/
 	 /*RECUPERAR MONTO DE FACTURA*/
	 /*TIPO DE MONEDA EN QUE SE GENERO EL DOCUMENTO*/
	 SELECT total_pagar,fecha_emision INTO :ldc_total_pagar,:ldt_fecha_emision FROM cntas_pagar
     WHERE ((cod_relacion = :ls_cod_proveedor ) AND
 		      (tipo_doc     = :ls_tipo_doc      ) AND
	         (nro_doc     = :ls_nro_doc        )) ;	 
				
	 /*documento tiene que tener impuesto y fecha de emision debe ser >= 01/06/2002*/ 
	 IF ll_count > 0 AND String(ldt_fecha_emision,'yyyymmdd') > ls_fec_ini_ret  THEN //IMPUESTO 
		 tab_1.tabpage_1.dw_detail.object.flag_impuesto [ll_inicio] = '1' //activo

		 IF ls_moneda_det <> ls_soles THEN 
		    ldc_total_pagar = Round(ldc_total_pagar * ldc_tasa_cambio,2)
			 ldc_imp_pagar   = Round(ldc_imp_pagar   * ldc_tasa_cambio,2)
	    END IF

		 IF ldc_total_pagar > ldc_imp_min_ret_igv THEN
			 lb_flag = TRUE //OPERACION > 700
		 END IF
		 
    	 /*total de doc*/ 
	    /*provision*/
		 ldc_imp_total = ldc_imp_total + (ldc_total_pagar * ll_factor)
		 /*pago*/ 
		 ldc_imp_total_pagar = ldc_imp_total_pagar + (ldc_imp_pagar * ll_factor)
		 
	 END IF
NEXT

//*SUMATORIA TOTAL*/
IF lb_flag AND ldc_imp_total > ldc_imp_min_ret_igv THEN /*provision*/
	For ll_inicio = 1 TO tab_1.tabpage_1.dw_detail.Rowcount()
		 ldc_imp_pagar = tab_1.tabpage_1.dw_detail.object.importe        [ll_inicio] 		
		 ls_moneda_det = tab_1.tabpage_1.dw_detail.object.cod_moneda_det [ll_inicio] 		
		
		 ls_flag_impuesto = tab_1.tabpage_1.dw_detail.object.flag_impuesto [ll_inicio]
		 
		 IF ls_flag_impuesto = '1' THEN
			 IF ls_moneda_det <> ls_soles THEN 
			 	 ldc_imp_pagar   = Round(ldc_imp_pagar * ldc_tasa_cambio,2)
	    	 END IF
			  
			 tab_1.tabpage_1.dw_detail.object.flag_ret_igv [ll_inicio] = '1' //retencion activada
			 
 			 ldc_imp_retencion = Round((ldc_imp_pagar * ldc_porc_ret_igv)/ 100,2)
			 tab_1.tabpage_1.dw_detail.object.imp_ret_igv [ll_inicio] = ldc_imp_retencion

		 END IF
		 
	Next
	
END IF


IF ldc_imp_total_pagar > ldc_imp_min_ret_igv THEN
	For ll_inicio = 1 TO tab_1.tabpage_1.dw_detail.Rowcount()
		 ldc_imp_pagar = tab_1.tabpage_1.dw_detail.object.importe        [ll_inicio] 		
		 ls_moneda_det = tab_1.tabpage_1.dw_detail.object.cod_moneda_det [ll_inicio] 		
		
		 ls_flag_impuesto = tab_1.tabpage_1.dw_detail.object.flag_impuesto [ll_inicio]
		 
		 IF ls_flag_impuesto = '1' THEN
			 IF ls_moneda_det <> ls_soles THEN 
			 	 ldc_imp_pagar   = Round(ldc_imp_pagar * ldc_tasa_cambio,2)
	    	 END IF
			  
			 tab_1.tabpage_1.dw_detail.object.flag_ret_igv [ll_inicio] = '1' //retencion activada
			 
 			 ldc_imp_retencion = Round((ldc_imp_pagar * ldc_porc_ret_igv)/ 100,2)
			 tab_1.tabpage_1.dw_detail.object.imp_ret_igv [ll_inicio] = ldc_imp_retencion

		 END IF
		 
	Next
END IF


tab_1.tabpage_1.dw_detail.SetFilter('')
tab_1.tabpage_1.dw_detail.Filter()
//verifico que item detalle tenga retencion
wf_ver_items_x_ret ()
//total de documento
dw_master.object.importe_doc [ll_row_master] = wf_calcular_total ()
dw_master.ii_update = 1	

SALIDA:
end event

type cb_1 from commandbutton within w_fi305_letras_x_pagar_canje
integer x = 3209
integer y = 28
integer width = 645
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

event clicked;str_parametros sl_param
String ls_cod_relacion,ls_cod_moneda,ls_flag_estado
Long   ll_row
Decimal {3} ldc_tasa_cambio
Decimal {2} ldc_imp_total

ll_row = dw_master.Getrow ()

IF ll_row = 0 THEN 
	Messagebox('Aviso','Debe Ingresar Registro Algun Registro , Verifique!')
	RETURN
END IF

if ib_cierre then 
	Messagebox('Aviso','Mes contable cerrado, coordinar con contabilidad')
	return
end if

//Selecciono el proveedor
ls_cod_relacion = dw_master.object.cod_relacion [ll_row]	
IF Isnull(ls_cod_relacion) OR Trim(ls_cod_relacion) = '' THEN
	Messagebox('Aviso','Deb Ingresar Un Codigo de Relacion , Verifique!')
	dw_master.SetFocus()
	dw_master.SetColumn('cod_relacion')
	Return
END IF

sl_param.string3 = ls_cod_relacion

OpenWithParm(w_pop_help_edirecto,sl_param)

//* Check text returned in Message object//
if IsNull(message.PowerObjectParm) or not IsValid(message.PowerObjectParm) then return

IF isvalid(message.PowerObjectParm) THEN
	sl_param = message.PowerObjectParm
END IF

if sl_param.titulo = 'n' then return

ls_cod_relacion = sl_param.string3

//recupero el resto de datos de la cabecera
ls_cod_moneda	 = dw_master.object.cod_moneda   [ll_row]	
ldc_tasa_cambio = dw_master.object.tasa_cambio  [ll_row]	
ls_flag_estado	 = dw_master.object.flag_estado  [ll_row]	


//VERIFICAR ESTADO 
IF ls_flag_estado <> '1' THEN 
	Messagebox('Aviso','Estado de la Letra no esta Disponible para realizar Modificaciones , Verifique!')
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

sl_param.dw1		= 'd_abc_lista_doc_x_pagar_tbl'
sl_param.titulo	= 'Documentos Pendientes x Proveedor '
sl_param.string1	= ls_cod_relacion
sl_param.string2	= ls_cod_moneda
sl_param.db2		= ldc_tasa_cambio
sl_param.tipo 		= '1CP'
sl_param.opcion   = 1 //canje de letras x pagar
sl_param.dw_m		= dw_master
sl_param.dw_d		= idw_detail

OpenWithParm( w_abc_seleccion_lista, sl_param)

IF isvalid(message.PowerObjectParm) THEN sl_param = message.PowerObjectParm			
IF sl_param.bret  THEN

	idw_detail.ii_update = 1
	dw_master.object.importe_doc [ll_row] = wf_calcular_total ()
	dw_master.ii_update = 1
	/*GENERACION DE ASIENTOS*/
	ib_estado_asiento = TRUE
END IF

end event

type dw_master from u_dw_abc within w_fi305_letras_x_pagar_canje
integer width = 3136
integer height = 1232
string dataobject = "d_abc_letra_x_pagar_tbl"
boolean hscrollbar = false
boolean vscrollbar = false
end type

event constructor;call super::constructor;is_mastdet = 'md'		

is_dwform = 'form'	// tabular, form (default)


ii_ck[1] = 1			// columnas de lectrua de este dw
ii_ck[2] = 2			
ii_ck[3] = 3			
ii_dk[1] = 1 	      // columnas que se pasan al detalle
ii_dk[2] = 2
ii_dk[3] = 3



idw_mst  = dw_master						 // dw_master
idw_det  = tab_1.tabpage_1.dw_detail // dw_detail

end event

event itemchanged;call super::itemchanged;Long   		ll_count 
String 		ls_prov,ls_nom,ls_prov_old,ls_flag_situacion,ls_codigo, ls_data
Decimal 		ldc_tasa_cambio, ld_dias_a_canc
Date        ld_fecha_emision,ld_fecha_vencimiento,ld_fecha_emision_old
Integer		li_nro_libro

ls_prov_old          = This.object.cod_relacion  [row]
ld_fecha_emision_old = Date(This.Object.fecha_emision [row])


This.Accepttext()

//Generación de Asientos Automaticos
ib_estado_asiento = TRUE

choose case dwo.name
	CASE 'serie_cri'
		if gnvo_app.is_agente_ret = '0' then
			this.object.serie_cri [row] = gnvo_app.il_null
			f_Mensaje('La empresa no esta asignada como agente de retención, no es posible seleccionar una serie de Comprobante de retención', '')
			return
		end if
		
		select count(*)
			into :ll_count
		from 	doc_tipo_usuario dtu, 
				num_doc_tipo     ndt, 
				doc_tipo			  dt 
		where ndt.tipo_doc    = dtu.tipo_doc 
		  and ndt.nro_serie   = dtu.nro_serie
		  and dt.tipo_doc     = dtu.tipo_doc 
		  and dt.tipo_doc 	 = :gnvo_app.is_doc_ret 
		  and dtu.cod_usr     = :gs_user
		  and dt.flag_estado  = '1';
		
		if ll_count = 0 then
			this.object.serie_cri 	[row] = gnvo_app.is_null
			Messagebox('Aviso','Serie de Comprobante de Retencion no existe o no tiene permiso para usarlo, por favor Verifique!')
			return 1
		end if
		
		this.object.serie_cri 	[row] = string(integer(data), '000')
			
		/*Generacion de Asientos*/
	 	ib_estado_asiento = true					

	 case 'tipo_doc'
			select nro_libro 
				into :li_nro_libro 
			from 	doc_tipo dt,
     				doc_grupo_relacion dgr
			where dt.tipo_doc = dgr.tipo_doc     
  			  and dgr.grupo = :is_grp_ltp
			  and dt.tipo_doc = :data
			  and dt.flag_estado = '1';
			
			IF SQLCA.SQLCode = 100 THEN
				This.object.doc_tipo  [row] = gnvo_app.is_null
				f_mensaje("Error, Tipo de documento ingresado no existe, no esta activo o no pertenece al grupo de Letras por pagar", '')
				Return 1
			end if
			This.object.nro_libro [row] = li_nro_libro
			
			of_get_cnta_cntbl(data)
		
	 case 'confin'
			select cf.descripcion
				into :ls_data
			from concepto_financiero cf
			where cf.flag_estado = '1'
 			  and cf.confin = :data;
			
			IF SQLCA.SQLCode = 100 THEN
				This.object.confin  		[row] = gnvo_app.is_null
				This.object.desc_confin [row] = gnvo_app.is_null
				f_mensaje("Error, Concepto financiero " + data + ", no existe o no esta activo", '')
				Return 1
			end if
			This.object.desc_confin [row] = ls_data

	case 'cod_moneda'
			/*Actualiza moneda de la cabecera en el detalle*/
			wf_update_moneda_cab_det (data)
			dw_master.Object.importe_doc [row] = wf_calcular_total ()
			tab_1.tabpage_1.dw_detail.ii_update = 1
			
	 case	'tasa_cambio'
			ldc_tasa_cambio = This.object.tasa_cambio [row]
			/*ACTUALIZAR TASA DE CAMBIO DE DETALLE*/
			wf_update_tcambio_det(ldc_tasa_cambio)					
			dw_master.Object.importe_doc [row] = wf_calcular_total ()
			tab_1.tabpage_1.dw_detail.ii_update = 1
			
	 case 'cod_relacion'
	
			IF idw_detail.rowcount() > 0 THEN
				IF ls_prov_old <> data THEN
					wf_delete_doc_referencias ()
					dw_master.Object.importe_doc [row] = wf_calcular_total ()
					dw_master.ii_update = 1
				END IF
			END IF
					
			select nom_proveedor 
			  into :ls_nom 
			  from proveedor 
			where (proveedor = :data)
			  and flag_estado = '1';	
			
			IF SQLCA.SQLCode = 100 THEN
				This.object.cod_relacion  [row] = gnvo_app.is_null
				This.object.nom_proveedor [row] = gnvo_app.is_null
				f_mensaje("Debe Ingresar Un Proveedor Valido , Verifique!", "")
				Return 1
			end if
				
			This.object.nom_proveedor [row] = ls_nom
			
	 case 'fecha_emision'
			ld_fecha_emision     = Date(This.Object.fecha_emision [row])			
			ld_fecha_vencimiento	= Date(This.Object.vencimiento   [row])			
			
			IF ld_fecha_emision > ld_fecha_vencimiento THEN
				This.Object.fecha_emision [row] = ld_fecha_emision_old
				Messagebox('Aviso','Fecha de Emisión del Documento No '&
										+'Puede Ser Mayor a la Fecha de Vencimiento')
				Return 1
			END IF
							
			ld_dias_a_canc   		= This.Object.dias_a_cancelar [row]
			IF Not(Isnull(ld_dias_a_canc) OR ld_dias_a_canc = 0) THEN //SI ES MAYOR QUE 0
				ld_fecha_vencimiento = RelativeDate (ld_fecha_emision, ld_dias_a_canc )
				This.Object.vencimiento [row] = ld_fecha_vencimiento				
			END IF	
	
			
			//Si es nuevo modifico el año y el mes
			if is_accion = 'new' THEN
	//					This.Object.ano [row] = Long(String(ld_fecha_emision,'YYYY'))
	//					This.Object.mes [row] = Long(String(ld_fecha_emision,'MM'))
			end if
	
			
			This.Object.tasa_cambio	   [row] = gnvo_app.of_tasa_cambio(ld_fecha_emision)
			
			ldc_tasa_cambio = This.Object.tasa_cambio	   [row]
			
			
			/*ACTUALIZAR TASA DE CAMBIO DE DETALLE*/
			wf_update_tcambio_det(ldc_tasa_cambio)					
			dw_master.Object.importe_doc [row] = wf_calcular_total ()
			tab_1.tabpage_1.dw_detail.ii_update = 1
			
	 CASE 'dias_a_cancelar'   
			ld_fecha_emision = Date(This.Object.fecha_emision   [row])
			ld_dias_a_canc   = This.Object.dias_a_cancelar [row]
			ld_fecha_vencimiento = RelativeDate (ld_fecha_emision, ld_dias_a_canc )
			This.Object.vencimiento [row] = ld_fecha_vencimiento				
			
	 CASE 'vencimiento'	
			ld_fecha_emision     = Date(This.Object.fecha_emision [row])			
			ld_fecha_vencimiento	= Date(This.Object.vencimiento   [row])			
			IF ld_fecha_vencimiento < ld_fecha_emision THEN
				This.Object.vencimiento [row] = ld_fecha_emision
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
end choose

end event

event ue_insert_pre;call super::ue_insert_pre;String ls_Desc

ib_cierre = false
dw_master.object.t_cierre.text = ''

This.Object.origen		       [al_row] = gs_origen
This.Object.tipo_doc		       [al_row] = is_doc_ltp
This.Object.cod_usr		       [al_row] = gs_user
This.Object.fecha_registro     [al_row] = f_fecha_actual()
This.Object.fecha_emision      [al_row] = date(f_fecha_actual())
This.Object.tasa_cambio        [al_row] = gnvo_app.of_tasa_cambio()
This.Object.ano				    [al_row] = Long(String(f_fecha_actual(),'YYYY'))
This.Object.mes				    [al_row] = Long(String(f_fecha_actual(),'MM'))
This.Object.flag_estado		    [al_row] = '1'
This.Object.nro_ren_ltr  	    [al_row] = 0
This.Object.flag_situacion_ltr [al_row] = '1'
This.Object.flag_retencion	 	 [al_row] = '1'
This.Object.flag_tipo_ltr		 [al_row] = 'C' //CANJE DE LETRAS
This.Object.flag_provisionado	 [al_row] = 'R' //Provisionado Manualmente
This.Object.nro_libro	       [al_row] = f_nro_libro(is_doc_ltp)
This.Object.forma_pago	       [al_row] = is_fp_pcon

This.Object.confin	       	 [al_row] = is_confin_cnj_pag

select descripcion into :ls_desc from concepto_financiero where confin = :is_confin_cnj_pag;

This.Object.desc_confin	       [al_row] = ls_desc

of_get_cnta_cntbl(is_doc_ltp)

is_accion = "new"

end event

event itemerror;call super::itemerror;Return 1
end event

event ue_display;call super::ue_display;boolean lb_ret
string ls_codigo, ls_data, ls_sql, ls_cod_relacion, ls_nro_libro

choose case lower(as_columna)
	CASE 'serie_cri'
		if gnvo_app.is_agente_ret = '0' then
			f_Mensaje('La empresa no esta asignada como agente de retención, no es posible seleccionar una serie de Comprobante de retención', '')
			return
		end if
		
		ls_sql = "select dtu.tipo_doc as tipo_doc, " &
				 + "ndt.nro_serie as numero_serie, " &
				 + "ndt.ultimo_numero as ultimo " &
				 + "from doc_tipo_usuario dtu, " &
				 + "     num_doc_tipo     ndt, " &
				 + "     doc_tipo			  dt " &
				 + "where ndt.tipo_doc    = dtu.tipo_doc " &
				 + "  and ndt.nro_serie   = dtu.nro_serie" &
				 + "  and dt.tipo_doc     = dtu.tipo_doc " &
				 + "  and dt.tipo_doc 	  = '"+ gnvo_app.is_doc_ret + "'" &
				 + "  and dtu.cod_usr     = '" + gs_user + "'" &
				 + "  and dt.flag_estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, "2")
		
		if ls_codigo <> "" then
			this.object.serie_cri 	[al_row] = ls_data
			
		  	this.ii_update = 1
		  	/*Generacion de Asientos*/
		  	ib_estado_asiento = true					
		  
		END IF			
		
	case "cod_relacion"
		if is_accion = 'new' then
			ls_sql = "SELECT proveedor AS CODIGO_proveedor, " &
					  + "nom_proveedor AS nombre_proveedor, " &
					  + "ruc as ruc_proveedor " &
					  + "FROM proveedor " &
					  + "WHERE FLAG_ESTADO = '1'"
	
			lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
	
			if ls_codigo <> '' then
				IF idw_detail.Rowcount() > 0 THEN
					ls_cod_relacion = This.object.cod_relacion [al_row]
					IF ls_cod_relacion <> ls_codigo THEN
						wf_delete_doc_referencias()	
						dw_master.Object.importe_doc [al_row] = wf_calcular_total ()
						dw_master.ii_update = 1
					END IF
						
				END IF
				this.object.cod_relacion	[al_row] = ls_codigo
				this.object.nom_proveedor	[al_row] = ls_data
				this.ii_update = 1
				
				/*Generación Pre-Asientos*/
				ib_estado_asiento = TRUE
				/**/
			end if
		end if
		
	case "tipo_doc"
		ls_sql = "select dt.tipo_doc as tipo_documento, " &
				 + "dt.desc_tipo_doc as descripcion_tipo_doc, " &
				 + "dt.nro_libro as numero_libro " &
				 + "from doc_tipo dt, " &
				 + "     doc_grupo_relacion dgr " &
				 + "where dt.tipo_doc = dgr.tipo_doc " &
				 + "  and dgr.grupo = '" + is_grp_ltp + "'" &
				  + " and dt.FLAG_ESTADO = '1'"

		lb_ret = f_lista_3ret(ls_sql, ls_codigo, ls_data, ls_nro_libro, '2')

		if ls_codigo <> '' then
			this.object.tipo_doc		[al_row] = ls_codigo
			this.object.nro_doc		[al_row] = gnvo_app.is_null
			
			if not IsNull(ls_nro_libro) and ls_nro_libro <> '' then
				this.object.nro_libro		[al_row] = Long(ls_nro_libro)
			end if
			of_get_cnta_cntbl(ls_codigo)
			
			this.ii_update = 1
		end if		
		
	case "confin"
		ls_sql = "select cf.confin as confin, " &
				 + "cf.descripcion as descripcion_confin " &
				 + "from concepto_financiero cf " &
				 + "where cf.flag_estado = '1' " &
				 + "  and cf.confin like 'LP%'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.confin			[al_row] = ls_codigo
			this.object.desc_confin		[al_row] = ls_data
			this.ii_update = 1
		end if		

end choose


end event

event doubleclicked;call super::doubleclicked;string ls_columna
long ll_row 

THIS.AcceptText()
IF THIS.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

IF row > 0 THEN
	ls_columna = upper(dwo.name)
	THIS.event dynamic ue_display(ls_columna, ll_row)
END IF

// USAR SOLO PARA CONSULTAS EN CASCADA
IF row = 0 THEN RETURN
end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

type gb_1 from groupbox within w_fi305_letras_x_pagar_canje
integer x = 3200
integer y = 292
integer width = 759
integer height = 292
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Impresion"
end type

