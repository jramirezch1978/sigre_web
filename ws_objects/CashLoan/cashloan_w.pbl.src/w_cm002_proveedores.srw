$PBExportHeader$w_cm002_proveedores.srw
forward
global type w_cm002_proveedores from w_abc_master_tab
end type
type tabpage_5 from userobject within tab_1
end type
type dw_5 from u_dw_abc within tabpage_5
end type
type tabpage_5 from userobject within tab_1
dw_5 dw_5
end type
type tabpage_6 from userobject within tab_1
end type
type dw_direccion from u_dw_abc within tabpage_6
end type
type tabpage_6 from userobject within tab_1
dw_direccion dw_direccion
end type
type tabpage_7 from userobject within tab_1
end type
type dw_telefonos from u_dw_abc within tabpage_7
end type
type tabpage_7 from userobject within tab_1
dw_telefonos dw_telefonos
end type
type tabpage_21 from userobject within tab_1
end type
type tabpage_21 from userobject within tab_1
end type
type tabpage_8 from userobject within tab_1
end type
type dw_subcateg from u_dw_abc within tabpage_8
end type
type tabpage_8 from userobject within tab_1
dw_subcateg dw_subcateg
end type
type tabpage_9 from userobject within tab_1
end type
type dw_evaluacion from u_dw_abc within tabpage_9
end type
type tabpage_9 from userobject within tab_1
dw_evaluacion dw_evaluacion
end type
type tabpage_10 from userobject within tab_1
end type
type dw_representante from u_dw_abc within tabpage_10
end type
type tabpage_10 from userobject within tab_1
dw_representante dw_representante
end type
type tabpage_11 from userobject within tab_1
end type
type dw_campos from u_dw_abc within tabpage_11
end type
type tabpage_11 from userobject within tab_1
dw_campos dw_campos
end type
type tabpage_12 from userobject within tab_1
end type
type dw_nave from u_dw_abc within tabpage_12
end type
type tabpage_12 from userobject within tab_1
dw_nave dw_nave
end type
type tabpage_13 from userobject within tab_1
end type
type dw_ctas_bco from u_dw_abc within tabpage_13
end type
type tabpage_13 from userobject within tab_1
dw_ctas_bco dw_ctas_bco
end type
type tabpage_20 from userobject within tab_1
end type
type dw_lineas_credito from u_dw_abc within tabpage_20
end type
type tabpage_20 from userobject within tab_1
dw_lineas_credito dw_lineas_credito
end type
type tabpage_14 from userobject within tab_1
end type
type tab_2 from tab within tabpage_14
end type
type tabpage_15 from userobject within tab_2
end type
type dw_6 from u_dw_abc within tabpage_15
end type
type tabpage_15 from userobject within tab_2
dw_6 dw_6
end type
type tabpage_16 from userobject within tab_2
end type
type dw_7 from u_dw_abc within tabpage_16
end type
type tabpage_16 from userobject within tab_2
dw_7 dw_7
end type
type tabpage_17 from userobject within tab_2
end type
type dw_8 from u_dw_abc within tabpage_17
end type
type tabpage_17 from userobject within tab_2
dw_8 dw_8
end type
type tabpage_18 from userobject within tab_2
end type
type sle_archiobs from singlelineedit within tabpage_18
end type
type st_4 from statictext within tabpage_18
end type
type dp_1 from datepicker within tabpage_18
end type
type st_2 from statictext within tabpage_18
end type
type cb_2 from commandbutton within tabpage_18
end type
type st_3 from statictext within tabpage_18
end type
type dw_9 from u_dw_abc within tabpage_18
end type
type cb_1 from commandbutton within tabpage_18
end type
type sle_rutaarchivo from singlelineedit within tabpage_18
end type
type tabpage_18 from userobject within tab_2
sle_archiobs sle_archiobs
st_4 st_4
dp_1 dp_1
st_2 st_2
cb_2 cb_2
st_3 st_3
dw_9 dw_9
cb_1 cb_1
sle_rutaarchivo sle_rutaarchivo
end type
type tabpage_19 from userobject within tab_2
end type
type dw_10 from u_dw_abc within tabpage_19
end type
type tabpage_19 from userobject within tab_2
dw_10 dw_10
end type
type tab_2 from tab within tabpage_14
tabpage_15 tabpage_15
tabpage_16 tabpage_16
tabpage_17 tabpage_17
tabpage_18 tabpage_18
tabpage_19 tabpage_19
end type
type tabpage_14 from userobject within tab_1
tab_2 tab_2
end type
type tabpage_22 from userobject within tab_1
end type
type dw_prov_asesor_financiero from u_dw_abc within tabpage_22
end type
type tabpage_22 from userobject within tab_1
dw_prov_asesor_financiero dw_prov_asesor_financiero
end type
type st_1 from statictext within w_cm002_proveedores
end type
end forward

global type w_cm002_proveedores from w_abc_master_tab
integer width = 5486
integer height = 2792
string title = "[CM002] Ficha de Proveedores/Clientes"
string menuname = "m_mantto_smpl_lista"
event ue_printvisitas ( )
event ue_event_f5 ( )
event kedown pbm_keydown
st_1 st_1
end type
global w_cm002_proveedores w_cm002_proveedores

type variables
u_dw_abc  	idw_nave     , idw_direccion, idw_telefonos, &
				idw_subcateg , idw_evaluacion, idw_representante, &
				idw_campos   , idw_cta_bcos,	idw_detail, &
				idw_basc_infogeneral, idw_basc_provcli, idw_basc_progvis, idw_basc_documentos, &
				idw_basc_subcontra, idw_lineas_credito, idw_prov_asesor_financiero

string 		is_nombre_archivo, is_old_flag_estado

n_cst_wait			invo_wait
n_cst_utilitario	invo_util
end variables

forward prototypes
public function integer of_set_numera ()
public subroutine of_asigna_dws ()
public subroutine of_retrieve (string as_proveedor)
public subroutine of_reset ()
end prototypes

event ue_printvisitas();str_parametros lstr_parametros
lstr_parametros.string1 = trim(upper(dw_master.object.nom_proveedor[dw_master.getrow()]))
lstr_parametros.string2 = dw_master.object.flag_clie_prov[dw_master.getrow()]
opensheetwithparm(w_cm002_proveedor_ficha_visita,lstr_parametros, w_main, 2, layered!)

//datastore lds_print
//lds_print = create datastore
//lds_print.dataobject = 'd_rpt_proveedor_basc_visista_tbl'
//lds_print.insertrow(0)
//
//if dw_master.getrow() > 0 then
//	
//	string ls_titulo, ls_codigo, ls_version	
//	
//	lds_print.object.nombre_cliente[1] = trim(upper(dw_master.object.nom_proveedor[dw_master.getrow()]))
//	
//	if dw_master.object.flag_clie_prov[dw_master.getrow()] = '0' or dw_master.object.flag_clie_prov[dw_master.getrow()] = '2' then
//		ls_titulo ='VISITA A CLIENTE'
//		ls_codigo = 'CANT.FO.08.3'
//		ls_version = 'VERSION: 00'
//	else
//		ls_titulo ='VISITA A PROVEEDOR'
//		ls_codigo = 'CANT.FO.07.3'
//		ls_version = 'VERSION: 00'
//	end if
//	lds_print.object.t_titulobasc1.text = ls_titulo
//	lds_print.object.t_codigobasc.text = ls_codigo
//	lds_print.object.t_versionbasc.text = ls_version
//	lds_print.Object.p_logo.filename = gs_logo
//end if
//
//lds_print.print(false,false)
end event

event ue_event_f5();String 			ls_ruc, ls_dir_direccion, ls_string []
Integer 			li_count, li_row
BeanPadronRUC 	lnvo_bean
str_parametros	lstr_return

try 
	dw_master.Accepttext()
	
	ls_ruc = invo_util.of_get_string('Ingrese el RUC de la Persona Natural / Juridica', '')
	
	if IsNull(ls_ruc) or trim(ls_ruc) = "" then
		return 
	end if
	
	if len(trim(ls_ruc)) <> 11 then
		MessageBox('Error', 'Solo acepta RUC de 11 digitos, por favor verifique!', StopSign!)
		return 
	end if
	
	select count(*)
		into :li_count
	from proveedor p
	where decode(p.tipo_doc_ident, '6', p.ruc, p.nro_doc_ident) = :ls_ruc;
	
	if SQLCA.SQLCode < 0 then
		MessageBox('Error', 'Ha ocurrido un error al consultar la tabla PROVEEDOR. Mensaje ' &
			+ SQLCA.SQLErrText + ', por favor verifique!', StopSign!)
		return 
	end if
	
	if li_count > 0 then
		MessageBox('Error', 'El RUC ' + ls_ruc &
								+ ' ya esta registrado en la base de datos, ' &
								+ 'por favor confirma y corrija', StopSign!)
		return 
	end if
	
	if MessageBox('Error', '¿Desea que busque el RUC ' + ls_ruc + ' en el Servidor de SUNAT?. ' &
								+ 'Tenga presente que la busqueda puede demorar algunos minutos', &
								Information!, Yesno!, 1) = 1 then
		
		invo_wait.of_mensaje("Espere un momento, procesando Servicio Web de SUNAT")
		
		lnvo_bean = gnvo_app.logistica.of_leer_ruc_externo(ls_ruc)
		
		invo_wait.of_mensaje("Datos Obtenidos, validando informacion")
		
		if not lnvo_bean.isOK then
			MessageBox('Error', 'Error al consultar RUC en sunat. Mensaje: ' + lnvo_bean.mensaje, StopSign!)
			return 
		end if
		
		if trim(lnvo_bean.estado) <> 'ACTIVO' then
			if MessageBox('Error', 'El RUC ' + ls_ruc + ' no se encuentra ACTIVO.' &
										+ '~r~nEstado Real: ' + trim(lnvo_bean.estado) &
										+ '~r~n¿Desea cotinuar con los datos de SUNAT?', Information!, YesNo!, 2) = 2 then
				return 
			end if
		end if
		
		if trim(lnvo_bean.condicion) <> 'HABIDO' then
			if MessageBox('Error', 'El RUC ' + ls_ruc + ' no se encuentra HABIDO.' &
										+ '~r~Condicion Real: ' + trim(lnvo_bean.condicion) &
										+ '~r~n¿Desea cotinuar con los datos de SUNAT?', Information!, YesNo!, 2) = 2 then
				return 
			end if
		end if
		
		invo_wait.of_mensaje("Informacion Validada, llenando formulario...")
		
		//Reseto los datawindows
		of_reset()
		
		li_row = dw_master.event ue_insert()
		
		if li_row <= 0 then return
		
		dw_master.object.nom_proveedor 		[li_row] = lnvo_bean.razonSocial
		dw_master.object.flag_nac_ext 		[li_row] = 'N'
		dw_master.object.tipo_doc_ident 		[li_row] = '6'
		dw_master.object.ruc 					[li_row] = ls_ruc
		dw_master.object.tipo_proveedor		[li_row] = '02'
		dw_master.object.flag_clie_prov		[li_row] = '2'
		dw_master.object.flag_padron_sunat	[li_row] = '0'
		
		
		idw_detail.object.ruc_t.Visible 	= 'yes'
		idw_detail.object.ruc.Visible 		= '1'
		
		
		//Si es una persona natural
		if mid(ls_ruc,1,1) = '1' then
			dw_master.object.flag_personeria [li_row] = 'N'
			
			lstr_return = invo_util.of_split(lnvo_bean.razonSocial, ' ')
			
			ls_string = lstr_return.str_array
			
			if upperBound(ls_string) >= 1 then
				dw_master.object.apellido_pat	[li_row] = ls_string [1]
			end if
			
			if upperBound(ls_string) >= 2 then
				dw_master.object.apellido_mat	[li_row] = ls_string [2]
			end if
			
			if upperBound(ls_string) >= 3 then
				dw_master.object.nombre1		[li_row] = ls_string [3]
			end if
			
			if upperBound(ls_string) >= 4 then
				dw_master.object.nombre2		[li_row] = ls_string [4]
			end if
			
			dw_master.object.flag_personeria	[1] = 'N'
			
		else
			dw_master.object.flag_personeria [li_row] = 'J'
			
			dw_master.object.apellido_pat		[1] = ''
			dw_master.object.apellido_mat		[1] = ''
			dw_master.object.nombre1			[1] = ''
			dw_master.object.nombre2			[1] = ''
			
			dw_master.object.flag_personeria	[1] = 'J'
		end if
		
		//Inserto ahora la direccion
		li_row = idw_direccion.event ue_insert()
		
		if li_row <= 0 then return
		
		idw_direccion.object.descripcion		[li_row] = 'OFICINA PRINCIPAL'
		idw_direccion.object.dir_distrito 	[li_row] = lnvo_bean.descDistrito
		idw_direccion.object.dir_provincia 	[li_row] = lnvo_bean.descDistrito
		idw_direccion.object.dir_dep_estado [li_row] = lnvo_bean.descDepartamento
		idw_direccion.object.dir_ciudad	 	[li_row] = lnvo_bean.descDistrito
		idw_direccion.object.dir_pais		 	[li_row] = 'PERU'
		idw_direccion.object.dir_siglas_pais[li_row] = 'PE'
		idw_direccion.object.cod_pais_sunat	[li_row] = '9589'
		
		ls_dir_direccion = ''
		
		if lnvo_bean.tipoVia <> '-' and trim(lnvo_bean.tipoVia) <> '' then
			ls_dir_direccion += lnvo_bean.tipoVia + ' '
		end if
		
		if lnvo_bean.nombreVia <> '-' and trim(lnvo_bean.nombreVia) <> '' then
			ls_dir_direccion += lnvo_bean.nombreVia + ' '
		end if
		
		if lnvo_bean.codigoZona <> '-' and trim(lnvo_bean.codigoZona) <> '' then
			
			if lnvo_bean.codigoZona = 'URB.' then
			
				idw_direccion.object.dir_urbanizacion	[1] = lnvo_bean.tipoZona
			
			else
				
				ls_dir_direccion += lnvo_bean.tipoZona + ' ' + lnvo_bean.codigoZona + ' '
				
			end if
			
		end if
		
		if lnvo_bean.codigoZona = '-' or trim(lnvo_bean.codigoZona) = '' then
			
			ls_dir_direccion += lnvo_bean.codigoZona + ' '
				
		end if
		
		idw_direccion.object.dir_direccion 		[li_row] = trim(ls_dir_direccion)
		
		if lnvo_bean.numero <> '-' and trim(lnvo_bean.numero) <> '' then
			idw_direccion.object.dir_numero		[li_row] = lnvo_bean.numero
		end if
		
		if lnvo_bean.interior <> '-' and trim(lnvo_bean.interior) <> '' then
			idw_direccion.object.dir_interior	[li_row] = lnvo_bean.interior
		end if
		
		if lnvo_bean.lote <> '-' and trim(lnvo_bean.lote) <> '' then
			idw_direccion.object.dir_lote			[li_row] = lnvo_bean.lote
		end if
		
		if lnvo_bean.manzana <> '-' and trim(lnvo_bean.manzana) <> '' then
			idw_direccion.object.dir_mnz			[li_row] = lnvo_bean.manzana
		end if
		
		invo_wait.of_mensaje("Proceso concluido satisfactoriamente")
		
	end if

catch ( Exception ex )
	gnvo_app.of_catch_exception(ex, 'Error en busqueda de RUC en SUNAT')
	
finally
	invo_Wait.of_close()
	
end try

end event

event kedown;IF Key = KeyF5! THEN
	
	this.event ue_event_f5( )
	

END IF


end event

public function integer of_set_numera ();// Numera documento
Long ll_nro, j, ll_i
String ls_nro, ls_ceros, ls_origen = 'XX', ls_mensaje

if is_Action = 'new' then
	Select ult_nro 
		into :ll_nro 
	from num_proveedor 
	where origen = :ls_origen for update;	

	IF SQLCA.SQLCODE = -1 THEN
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MESSAGEBOX( 'ERROR', "Error al consulta tabla NUM_PROVEEDOR. Mensaje: " + ls_mensaje, StopSign!)
		return 0
	END IF

	if SQLCA.SQLCode = 100 then

		insert into num_proveedor( origen, ult_nro)
		values( :ls_origen, 1);
		
		IF SQLCA.SQLCODE < 0 THEN
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MESSAGEBOX( 'ERROR', 'Error al insertar registro en NUM_PROVEEDOR. Mnesaje: ' &
				+ ls_mensaje, stopSign!)
			return 0
		END IF
		
		ll_nro = 1
	end if

	
	ls_nro = TRIM(String( ll_nro))
	ls_ceros = 'E'
	for j = 1 to 7 - LEN( ls_nro)
		ls_ceros = ls_ceros + "0" 
	next
	ls_nro = ls_ceros + ls_nro

	// Asigna numero a cabecera
	dw_master.object.proveedor[dw_master.getrow()] = ls_nro
	
	// Incrementa contador	
	Update num_proveedor 
		set ult_nro = ult_nro + 1 
	where origen = :ls_origen;
	
	for ll_i=1 to idw_direccion.RowCount()
		idw_direccion.object.codigo [ll_i] = ls_nro
	next
	
	for ll_i=1 to idw_telefonos.RowCount()
		idw_telefonos.object.proveedor [ll_i] = ls_nro
	next
	
	for ll_i=1 to idw_subcateg.RowCount()
		idw_subcateg.object.proveedor [ll_i] = ls_nro
	next
	
	for ll_i=1 to idw_evaluacion.RowCount()
		idw_evaluacion.object.proveedor [ll_i] = ls_nro
	next
	
	for ll_i=1 to idw_cta_bcos.RowCount()
		idw_cta_bcos.object.proveedor [ll_i] = ls_nro
	next
	
	for ll_i=1 to idw_basc_provcli.RowCount()
		idw_basc_provcli.object.proveedor [ll_i] = ls_nro
	next
	
	for ll_i=1 to idw_basc_subcontra.RowCount()
		idw_basc_subcontra.object.proveedor [ll_i] = ls_nro
	next
	
	for ll_i=1 to idw_basc_progvis.RowCount()
		idw_basc_progvis.object.proveedor [ll_i] = ls_nro
	next

end if
return 1
end function

public subroutine of_asigna_dws ();idw_detail1					= tab_1.tabpage_1.dw_1
idw_detail2					= tab_1.tabpage_2.dw_2
idw_detail3					= tab_1.tabpage_3.dw_3
idw_detail4					= tab_1.tabpage_4.dw_4

idw_nave 					= tab_1.tabpage_12.dw_nave
idw_direccion 				= tab_1.tabpage_6.dw_direccion
idw_telefonos 				= tab_1.tabpage_7.dw_telefonos
idw_subcateg				= tab_1.tabpage_8.dw_subcateg
idw_evaluacion				= tab_1.tabpage_9.dw_evaluacion
idw_representante 		= tab_1.tabpage_10.dw_representante
idw_campos					= tab_1.tabpage_11.dw_campos
idw_cta_bcos 				= tab_1.tabpage_13.dw_ctas_bco
idw_detail					= tab_1.tabpage_1.dw_1
idw_basc_infogeneral 	= tab_1.tabpage_14.tab_2.tabpage_15.dw_6
idw_basc_provcli 			= tab_1.tabpage_14.tab_2.tabpage_16.dw_7
idw_basc_subcontra 		= tab_1.tabpage_14.tab_2.tabpage_17.dw_8
idw_basc_documentos 		= tab_1.tabpage_14.tab_2.tabpage_18.dw_9
idw_basc_progvis 			= tab_1.tabpage_14.tab_2.tabpage_19.dw_10
idw_lineas_credito		= tab_1.tabpage_20.dw_lineas_credito
idw_prov_asesor_financiero = tab_1.tabpage_22.dw_prov_asesor_financiero
end subroutine

public subroutine of_retrieve (string as_proveedor);string ls_tipo_doc_ident


dw_master.Retrieve(as_proveedor)
idw_direccion.retrieve( as_proveedor )
idw_telefonos.retrieve( as_proveedor )
idw_subcateg.retrieve( as_proveedor )
idw_evaluacion.retrieve( as_proveedor )
idw_representante.retrieve( as_proveedor )
idw_campos.retrieve( as_proveedor )
idw_nave.retrieve(as_proveedor)
idw_cta_bcos.retrieve(as_proveedor)
idw_lineas_credito.retrieve(as_proveedor)
idw_basc_provcli.retrieve(as_proveedor)
idw_basc_subcontra.retrieve(as_proveedor)
idw_basc_documentos.retrieve(as_proveedor)
idw_basc_progvis.retrieve(as_proveedor)

dw_master.ii_protect = 0
idw_detail.ii_protect = 0
idw_direccion.ii_protect = 0
idw_telefonos.ii_protect = 0
idw_subcateg.ii_protect = 0
idw_evaluacion.ii_protect = 0
idw_representante.ii_protect = 0
idw_campos.ii_protect = 0
idw_nave.ii_protect = 0
idw_cta_bcos.ii_protect = 0
idw_lineas_credito.ii_protect = 0
idw_basc_infogeneral.ii_protect = 0
idw_basc_provcli.ii_protect = 0
idw_basc_subcontra.ii_protect = 0
idw_basc_progvis.ii_protect = 0

dw_master.of_protect()
idw_detail.of_protect( )
idw_direccion.of_protect()
idw_telefonos.of_protect()
idw_subcateg.of_protect()
idw_evaluacion.of_protect()
idw_representante.of_protect()
idw_campos.of_protect()
idw_nave.of_protect( )
idw_cta_bcos.of_protect( )
idw_lineas_credito.of_protect( )
idw_basc_infogeneral.of_protect()
idw_basc_provcli.of_protect()
idw_basc_subcontra.of_protect()
idw_basc_progvis.of_protect()

dw_master.ResetUpdate()
idw_detail.ResetUpdate( )
idw_direccion.ResetUpdate()
idw_telefonos.ResetUpdate()
idw_subcateg.ResetUpdate()
idw_evaluacion.ResetUpdate()
idw_representante.ResetUpdate()
idw_campos.ResetUpdate()
idw_nave.ResetUpdate( )
idw_cta_bcos.ResetUpdate( )
idw_lineas_credito.ResetUpdate( )
idw_basc_infogeneral.ResetUpdate()
idw_basc_provcli.ResetUpdate()
idw_basc_subcontra.ResetUpdate()
idw_basc_progvis.ResetUpdate()

if dw_master.RowCount() > 0 then 
	ls_tipo_doc_ident 	= dw_master.object.tipo_doc_ident 	[1]
	is_old_flag_estado	= dw_master.object.flag_estado		[1]
	
	if ls_tipo_doc_ident = '6' then
		idw_detail.object.nro_doc_ident.visible = '0'
		//ldw_det.object.nro_doc_ident 	[1] = ''
		idw_detail.object.ruc_t.Visible = '1'
		idw_detail.object.ruc.Visible = '1'
	else
		idw_detail.object.nro_doc_ident.visible = '1'
		idw_detail.object.ruc_t.Visible = '0'
		idw_detail.object.ruc.Visible = '0'
	end if
end if
end subroutine

public subroutine of_reset ();//Reseteo los datos
dw_master.Reset()
idw_nave.Reset()
idw_direccion.Reset()
idw_telefonos.Reset()
idw_subcateg.Reset()
idw_evaluacion.Reset()
idw_representante.Reset()
idw_campos.Reset()
idw_cta_bcos.Reset()
idw_detail.Reset()
idw_basc_infogeneral.Reset()
idw_basc_provcli.Reset()
idw_basc_progvis.Reset()
idw_basc_documentos.Reset()
idw_basc_subcontra.Reset()
idw_lineas_credito.Reset()

dw_master.ResetUpdate()
idw_nave.ResetUpdate()
idw_direccion.ResetUpdate()
idw_telefonos.ResetUpdate()
idw_subcateg.ResetUpdate()
idw_evaluacion.ResetUpdate()
idw_representante.ResetUpdate()
idw_campos.ResetUpdate()
idw_cta_bcos.ResetUpdate()
idw_detail.ResetUpdate()
idw_basc_infogeneral.ResetUpdate()
idw_basc_provcli.ResetUpdate()
idw_basc_progvis.ResetUpdate()
idw_basc_documentos.ResetUpdate()
idw_basc_subcontra.ResetUpdate()
idw_lineas_credito.ResetUpdate()

dw_master.ii_update = 0
idw_nave.ii_update = 0
idw_direccion.ii_update = 0
idw_telefonos.ii_update = 0
idw_subcateg.ii_update = 0
idw_evaluacion.ii_update = 0
idw_representante.ii_update = 0
idw_campos.ii_update = 0
idw_cta_bcos.ii_update = 0
idw_detail.ii_update = 0
idw_basc_infogeneral.ii_update = 0
idw_basc_provcli.ii_update = 0
idw_basc_progvis.ii_update = 0
idw_basc_documentos.ii_update = 0
idw_basc_subcontra.ii_update = 0
idw_lineas_credito.ii_update = 0
end subroutine

on w_cm002_proveedores.create
int iCurrent
call super::create
if this.MenuName = "m_mantto_smpl_lista" then this.MenuID = create m_mantto_smpl_lista
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
end on

on w_cm002_proveedores.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
end on

event ue_open_pre;call super::ue_open_pre;String ls_proveedor, ls_flag_personeria
Long ll_row

ib_log = TRUE

of_asigna_dws()

im_1 = CREATE m_rButton      				// crear menu de boton derecho del mouse
invo_wait = create n_cst_wait

idw_1 = dw_master
dw_master.SetTransObject(sqlca)  		// Relacionar el dw con la base de datos
idw_direccion.SetTransObject(sqlca)
idw_telefonos.SetTransObject(sqlca)
idw_subcateg.SetTransObject(sqlca)
idw_evaluacion.SetTransObject(sqlca)
idw_representante.SetTransObject(sqlca)
idw_campos.SetTransObject(sqlca)
idw_nave.SetTransObject(SQLCA)
idw_cta_bcos.SetTransObject(SQLCA)
idw_lineas_credito.SetTransObject(SQLCA)

idw_basc_provcli.SetTransObject(SQLCA)
idw_basc_subcontra.SetTransObject(SQLCA)
idw_basc_documentos.SetTransObject(SQLCA)
idw_basc_progvis.SetTransObject(SQLCA)

idw_prov_asesor_financiero.SetTransObject(SQLCA)

ii_help = 101           					// help topic
ii_pregunta_delete = 1   					// 1 = si pregunta, 0 = no pregunta (default)

// Busco registro menor
Select Max( proveedor ) 
	into :ls_proveedor 
from proveedor
where proveedor like 'E%'
  and flag_estado = '1';

if SQLCA.SQLCode <> 100 and SQLCA.SQLCOde > 0 then
	of_retrieve( ls_proveedor )
end if

is_action = 'open'



end event

event ue_dw_share;//Override

Integer li_share_status

li_share_status = dw_master.ShareData (tab_1.tabpage_1.dw_1)
IF li_share_status <> 1 THEN
	messagebox("Error en Sharedata","Error al compartir con DW1",exclamation!)
	RETURN
END IF

li_share_status = dw_master.ShareData (tab_1.tabpage_4.dw_4)
IF li_share_status <> 1 THEN
	messagebox("Error en Sharedata","Error al compartir con DW4",exclamation!)
	RETURN
END IF

li_share_status = dw_master.ShareData (tab_1.tabpage_5.dw_5)
IF li_share_status <> 1 THEN
	messagebox("Error en Sharedata","Error al compartir con DW5",exclamation!)
	RETURN
END IF

li_share_status = dw_master.ShareData (tab_1.tabpage_14.tab_2.tabpage_15.dw_6)
IF li_share_status <> 1 THEN
	messagebox("Error en Sharedata","Error al compartir con DW5",exclamation!)
	RETURN
END IF
end event

event ue_update_pre;Long 		ll_j, ll_count
String 	ls_ruc, ls_tipo_doc_ident, ls_nro_doc_ident, ls_flag_personeria, ls_nombre1, &
			ls_apel_paterno, ls_apel_materno, ls_nom_proveedor

ib_update_check = False	

tab_1.tabpage_1.dw_1.AcceptText()
tab_1.tabpage_2.dw_2.AcceptText()
tab_1.tabpage_3.dw_3.AcceptText()
tab_1.tabpage_4.dw_4.AcceptText()
tab_1.tabpage_5.dw_5.AcceptText()
tab_1.tabpage_14.tab_2.tabpage_15.dw_6.AcceptText()

idw_direccion.AcceptText()
idw_telefonos.AcceptText()
idw_subcateg.AcceptText()
idw_evaluacion.AcceptText()
idw_representante.AcceptText()
idw_cta_bcos.AcceptText()
idw_basc_provcli.AcceptText()
idw_basc_subcontra.AcceptText()
idw_basc_progvis.AcceptText()

if dw_master.RowCount() = 0 then
	ib_update_check = true
	return
end if

// Verifica que campos son requeridos y tengan valores
if not gnvo_app.of_row_Processing( dw_master) then return
if not gnvo_app.of_row_Processing( idw_basc_infogeneral) then return
if not gnvo_app.of_row_Processing( idw_basc_provcli) then return 
if not gnvo_app.of_row_Processing( idw_basc_subcontra) then return 
if not gnvo_app.of_row_Processing( idw_basc_progvis) then return 

//Obtengo los datos necesarios
ls_flag_personeria 	= dw_master.object.flag_personeria 	[1]
ls_nom_proveedor		= dw_master.object.nom_proveedor 	[1]
ls_nombre1				= dw_master.object.nombre1 			[1]
ls_apel_paterno		= dw_master.object.apellido_pat		[1]
ls_apel_materno		= dw_master.object.apellido_mat		[1]

if IsNull(ls_nom_proveedor) or trim(ls_nom_proveedor) = '' then
	MessageBox('Error', 'Debe especificar el nombre del proveedor, por favor verifique!', StopSign!)
	dw_master.SetColumn('nombre1')
	return
end if

if ls_flag_personeria = 'N' then
	if IsNull(ls_nombre1) or trim(ls_nombre1) = '' then
		MessageBox('Error', 'Debe especificar el nombre de la persona natural, por favor verifique!', StopSign!)
		dw_master.SetColumn('nombre1')
		return
	end if

	if IsNull(ls_apel_paterno) or trim(ls_apel_paterno) = '' then
		MessageBox('Error', 'Debe especificar el APELLIDO PATERNO de la persona natural, por favor verifique!', StopSign!)
		dw_master.SetColumn('apel_paterno')
		return
	end if

	if IsNull(ls_apel_materno) or trim(ls_apel_materno) = '' then
		MessageBox('Error', 'Debe especificar el APELLIDO MATERNO de la persona natural, por favor verifique!', StopSign!)
		dw_master.SetColumn('apel_materno')
		return
	end if

end if

IF is_action = 'new' then
	//Si es un nuevo codigo de relacion valido para que no haya duplicados
	if dw_master.RowCount() = 0 then
		ls_ruc 				= dw_master.Object.ruc 				[1]
		ls_tipo_doc_ident	= dw_master.object.tipo_doc_ident[1]
		ls_nro_doc_ident	= dw_master.object.nro_doc_ident	[1]
		
		if ls_tipo_Doc_ident = '1' then
			select count(*)
				into :ll_count
			from proveedor 
			where ruc = :ls_ruc;
		else
			select count(*)
				into :ll_count
			from proveedor 
			where tipo_doc_ident = :ls_tipo_doc_ident
			  and nro_doc_ident	= :ls_nro_doc_ident;
		
		end if
		
		if ll_count > 0 then
			ROLLBACK;
			MessageBox('Error', 'El RUC / DNI del proveedor ay esta registrado, verifique!', StopSign!)
			return
		end if
	end if

	if of_set_numera() = 0 then
		return	
	end if	
end if


dw_master.of_Set_flag_replicacion( )
tab_1.tabpage_1.dw_1.of_Set_flag_replicacion( )
tab_1.tabpage_2.dw_2.of_Set_flag_replicacion()
tab_1.tabpage_3.dw_3.of_Set_flag_replicacion()
tab_1.tabpage_4.dw_4.of_Set_flag_replicacion()
tab_1.tabpage_5.dw_5.of_Set_flag_replicacion()
tab_1.tabpage_14.tab_2.tabpage_15.dw_6.of_set_flag_replicacion()

idw_direccion.of_Set_flag_replicacion()
idw_telefonos.of_Set_flag_replicacion()
idw_subcateg.of_Set_flag_replicacion()
idw_evaluacion.of_Set_flag_replicacion()
idw_representante.of_Set_flag_replicacion()
idw_cta_bcos.of_Set_flag_replicacion()
idw_basc_provcli.of_Set_flag_replicacion()
idw_basc_subcontra.of_Set_flag_replicacion()
idw_basc_progvis.of_Set_flag_replicacion()

ib_update_check = true
end event

event ue_update;// Override
Boolean 	lbo_ok = TRUE
String	ls_flag_estado

try 
	dw_master.AcceptText()
	
	THIS.EVENT ue_update_pre()
	IF ib_update_check = FALSE THEN RETURN
	
	IF ib_log THEN
		dw_master.of_create_log()
		idw_nave.of_create_log()
		idw_direccion.of_create_log()
		idw_telefonos.of_create_log()
		idw_subcateg.of_create_log()
		idw_evaluacion.of_create_log()
		idw_representante.of_create_log()
		idw_campos.of_create_log()
		idw_cta_bcos.of_create_log()
		idw_basc_provcli.of_create_log()
		idw_basc_subcontra.of_create_log()
		idw_basc_progvis.of_create_log()
	END IF
	
	IF idw_cta_bcos.ii_update = 1 THEN
		IF idw_cta_bcos.Update(true, false) = -1 then		// Grabacion del detalle
			lbo_ok = FALSE
			messagebox("Error en Grabacion dw_cta_bancos","Se ha procedido al rollback",exclamation!)
		END IF
	END IF	
	
	IF idw_campos.ii_update = 1 THEN
		IF idw_campos.Update(true, false) = -1 then		// Grabacion del detalle
			lbo_ok = FALSE
			messagebox("Error en Grabacion dw_campos","Se ha procedido al rollback",exclamation!)
		END IF
	END IF
	
	IF idw_representante.ii_update = 1 THEN
		IF idw_representante.Update(true, false) = -1 then		// Grabacion del detalle
			lbo_ok = FALSE
			messagebox("Error en Grabacion dw_representante","Se ha procedido al rollback",exclamation!)
		END IF
	END IF
	
	IF idw_evaluacion.ii_update = 1 THEN
		IF idw_evaluacion.Update(true, false) = -1 then		// Grabacion del detalle
			lbo_ok = FALSE
			messagebox("Error en Grabacion dw_evaluacion","Se ha procedido al rollback",exclamation!)
		END IF
	END IF
	
	IF idw_subcateg.ii_update = 1 THEN
		IF idw_subcateg.Update(true, false) = -1 then		// Grabacion del detalle
			lbo_ok = FALSE
			messagebox("Error en Grabacion dw_subcategoria","Se ha procedido al rollback",exclamation!)
		END IF
	END IF
	
	IF idw_nave.ii_update = 1 THEN
		IF idw_nave.Update(true, false) = -1 then		// Grabacion del detalle
			lbo_ok = FALSE
			messagebox("Error en Grabacion dw_nave","Se ha procedido al rollback",exclamation!)
		END IF
	END IF
	
	IF idw_telefonos.ii_update = 1 THEN
		IF idw_telefonos.Update(true, false) = -1 then		// Grabacion del detalle
			lbo_ok = FALSE
			messagebox("Error en Grabacion dw_telefonos","Se ha procedido al rollback",exclamation!)
		END IF
	END IF
	
	IF idw_direccion.ii_update = 1 THEN
		IF idw_direccion.Update(true, false) = -1 then		// Grabacion del detalle
			lbo_ok = FALSE
			messagebox("Error en Grabacion dw_direccion","Se ha procedido al rollback",exclamation!)
		END IF
	END IF
	
	IF idw_basc_provcli.ii_update = 1 THEN
		IF idw_basc_provcli.Update(true, false) = -1 then		// Grabacion del detalle
			lbo_ok = FALSE
			messagebox("Error en Grabacion dw_basc_proveedor_cliente","Se ha procedido al rollback",exclamation!)
		END IF
	END IF
	
	IF idw_basc_subcontra.ii_update = 1 THEN
		IF idw_basc_subcontra.Update(true, false) = -1 then		// Grabacion del detalle
			lbo_ok = FALSE
			messagebox("Error en Grabacion dw_basc_subcontratas","Se ha procedido al rollback",exclamation!)
		END IF
	END IF
	
	IF idw_basc_progvis.ii_update = 1 THEN
		IF idw_basc_progvis.Update(true, false) = -1 then		// Grabacion del detalle
			lbo_ok = FALSE
			messagebox("Error en Grabacion dw_basc_progvis","Se ha procedido al rollback",exclamation!)
		END IF
	END IF
	
	IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
		IF dw_master.Update(true, false) = -1 then		// Grabacion del Master
			lbo_ok = FALSE
			messagebox("Error en Grabacion Master","Se ha procedido al rollback",exclamation!)
		END IF
	END IF
	
	IF ib_log THEN
		
		IF lbo_ok THEN
			lbo_ok = dw_master.of_save_log()
		END IF
		
		IF lbo_ok THEN
			lbo_ok = idw_nave.of_save_log()
		end if
		
		IF lbo_ok THEN
			lbo_ok = idw_direccion.of_save_log()
		END IF
		
		IF lbo_ok THEN
			lbo_ok = idw_telefonos.of_save_log()
		END IF
		
		IF lbo_ok THEN
			lbo_ok = idw_subcateg.of_save_log()
		END IF
		
		IF lbo_ok THEN
			lbo_ok = idw_evaluacion.of_save_log()
		END IF
		
		IF lbo_ok THEN
			lbo_ok = idw_representante.of_save_log()
		END IF
		
		IF lbo_ok THEN
			lbo_ok = idw_campos.of_save_log()
		END IF
		
		IF lbo_ok THEN
			lbo_ok = idw_cta_bcos.of_save_log()
		END IF
		
		IF lbo_ok THEN
			lbo_ok = idw_basc_provcli.of_save_log()
		END IF
		
		IF lbo_ok THEN
			lbo_ok = idw_basc_subcontra.of_save_log()
		END IF
		
		IF lbo_ok THEN
			lbo_ok = idw_basc_progvis.of_save_log()
		END IF
		
	END IF
	
	IF lbo_ok THEN
		COMMIT using SQLCA;
		
	
		dw_master.ii_update = 0
		idw_nave.ii_update = 0
		idw_direccion.ii_update = 0
		idw_telefonos.ii_update = 0
		idw_subcateg.ii_update = 0
		idw_evaluacion.ii_update = 0
		idw_representante.ii_update = 0
		idw_campos.ii_update = 0
		idw_cta_bcos.ii_update = 0
		idw_basc_provcli.ii_update = 0
		idw_basc_subcontra.ii_update = 0
		idw_basc_progvis.ii_update = 0
		
		dw_master.ResetUpdate()
		idw_nave.ResetUpdate()
		idw_direccion.ResetUpdate()
		idw_telefonos.ResetUpdate()
		idw_subcateg.ResetUpdate()
		idw_evaluacion.ResetUpdate()
		idw_representante.ResetUpdate()
		idw_campos.ResetUpdate()
		idw_cta_bcos.ResetUpdate()
		idw_basc_provcli.Resetupdate()
		idw_basc_subcontra.Resetupdate()
		idw_basc_progvis.Resetupdate()
		
		is_action = ''
		
		//Si ha habido un cambio en el flag_estado
		if dw_master.RowCount() > 0 then
			if gnvo_app.of_get_parametro("COMPRAS_SEND_EMAIL_CAMBIOS_PROVEEDOR", "0") = "1" then
				
				ls_flag_estado = dw_master.object.flag_estado [1]
				
				if ls_flag_estado <> is_old_flag_estado and ls_flag_estado = '0' then
					
					gnvo_app.logistica.of_send_email_cambio_estado(dw_master)
				
				elseif ls_flag_estado <> is_old_flag_estado and ls_flag_estado = '1' then
					
					gnvo_app.logistica.of_send_email_activa_prov(dw_master)
					
				end if
				
				is_old_flag_estado = ls_flag_estado
			end if
			
			of_retrieve(dw_master.object.proveedor [1])
			
		end if
		
		f_mensaje("Cambios realizados satisfactoriamente", "")
	ELSE 
		ROLLBACK USING SQLCA;
	END IF


catch ( Exception ex )
	gnvo_app.of_catch_Exception(ex, 'Error al momento actualizar proveedor')
end try

end event

event ue_modify;// Ancestor Script has been Override
string 	ls_proveedor, ls_flag_estado
Integer	li_row

try 
	
	if dw_master.GetRow() = 0 then return
	
	li_row = dw_master.GetRow( )
	
	idw_1.of_protect()
	
	if is_action <> 'new' then
		is_action = 'edit'
	end if	
	
	ls_proveedor = dw_master.object.proveedor[li_row]
	
	if gnvo_app.of_get_parametro( "COMPRAS_MOD_ESTADO_TRABAJADOR", "0") = "0" THEN
		select flag_estado
			into :ls_flag_estado
		from maestro
		where cod_trabajador = :ls_proveedor;
		
		if SQLCA.SQLCode <> 100 then
			if string(dw_master.object.flag_estado[li_row]) <> ls_flag_estado then
				dw_master.object.flag_estado[li_row] = ls_flag_estado
				dw_master.ii_update = 1
			end if
			dw_master.object.flag_estado.protect = '1'
			return
		end if
	END IF

catch ( Exception ex )
	gnvo_app.of_catch_exception(ex, 'Ha ocurrido una exception')
	
finally
	
end try




end event

event ue_print;// Override

String ls_proveedor

if dw_master.getrow() <= 0 then
	ls_proveedor = '' 
else
	ls_proveedor = dw_master.object.proveedor[dw_master.getrow()]
end if


OpenSheetWithParm(w_cm002_proveedor_ficha, ls_proveedor, This, 2, original!)
end event

event ue_insert;// Overr

Long  ll_row

if idw_1 = idw_campos or idw_1 = idw_nave or idw_1 = idw_detail or idw_1 = idw_basc_infogeneral then return

if idw_1 = dw_master then
	event ue_update_request( )
	
	dw_master.Reset()
	idw_direccion.Reset()
	idw_telefonos.Reset()
	idw_subcateg.Reset()
	idw_evaluacion.Reset()
	idw_cta_bcos.Reset()
	idw_representante.Reset()
	idw_basc_provcli.Reset()
	idw_basc_subcontra.Reset()
	idw_basc_documentos.Reset()
	idw_basc_progvis.Reset()

elseif idw_1 = idw_lineas_credito then
	
	MessageBox('Aviso', 'no puede realizar modificaciones en este panel, por favor vaya a la ventana correcta', StopSign!)
	return
	
end if

ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN
	THIS.EVENT ue_insert_pos(ll_row)
end if

end event

event resize;call super::resize;of_asigna_dws()

u_dw_abc 	ldw_1

dw_master.width  = newwidth  - dw_master.x - 20
st_1.X = dw_master.X
st_1.width = dw_master.width

ldw_1 = tab_1.tabpage_1.dw_1
idw_detail.Width 	= tab_1.tabpage_1.width - ldw_1.x - 20
idw_detail.height	= tab_1.tabpage_1.height - ldw_1.y - 20

ldw_1 = tab_1.tabpage_2.dw_2
ldw_1.Width = tab_1.tabpage_2.width - ldw_1.x - 20
ldw_1.height= tab_1.tabpage_2.height - ldw_1.y - 20

ldw_1 = tab_1.tabpage_3.dw_3
ldw_1.Width = tab_1.tabpage_3.width - ldw_1.x - 20
ldw_1.height= tab_1.tabpage_3.height - ldw_1.y - 20

ldw_1 = tab_1.tabpage_4.dw_4
ldw_1.Width = tab_1.tabpage_4.width - ldw_1.x - 20
ldw_1.height= tab_1.tabpage_4.height - ldw_1.y - 20

ldw_1 = tab_1.tabpage_5.dw_5
ldw_1.Width = tab_1.tabpage_5.dw_5.width - ldw_1.x - 20
ldw_1.height= tab_1.tabpage_5.dw_5.height - ldw_1.y - 20

idw_direccion.Width = tab_1.tabpage_6.width - idw_direccion.x - 20
idw_direccion.height= tab_1.tabpage_6.height - idw_direccion.y - 20

idw_telefonos.Width = tab_1.tabpage_7.width - idw_telefonos.x - 20
idw_telefonos.height= tab_1.tabpage_7.height - idw_telefonos.y - 20

idw_subcateg.Width = tab_1.tabpage_8.width - idw_subcateg.x - 20
idw_subcateg.height= tab_1.tabpage_8.height - idw_subcateg.y - 20

idw_evaluacion.Width = tab_1.tabpage_9.width - idw_evaluacion.x - 20
idw_evaluacion.height= tab_1.tabpage_9.height - idw_evaluacion.y - 20

idw_representante.Width = tab_1.tabpage_10.width - idw_representante.x - 20
idw_representante.height= tab_1.tabpage_10.height - idw_representante.y - 20

idw_campos.Width = tab_1.tabpage_11.width - idw_campos.x - 20
idw_campos.height= tab_1.tabpage_11.height - idw_campos.y - 20

idw_nave.Width = tab_1.tabpage_12.width - idw_nave.x - 20
idw_nave.height= tab_1.tabpage_12.height - idw_nave.y - 20

idw_cta_bcos.Width = tab_1.tabpage_13.width - idw_cta_bcos.x - 20
idw_cta_bcos.height= tab_1.tabpage_13.height - idw_cta_bcos.y - 20


idw_lineas_credito.Width = tab_1.tabpage_20.width - idw_lineas_credito.x - 20
idw_lineas_credito.height= tab_1.tabpage_20.height - idw_lineas_credito.y - 20

idw_prov_asesor_financiero.width = tab_1.tabpage_22.width - idw_prov_asesor_financiero.x - 20
idw_prov_asesor_financiero.height = tab_1.tabpage_22.height - idw_prov_asesor_financiero.y - 20


// basc
tab_1.tabpage_14.tab_2.width = tab_1.tabpage_14.width - tab_1.tabpage_14.tab_2.x
tab_1.tabpage_14.tab_2.height = tab_1.tabpage_14.height - tab_1.tabpage_14.tab_2.y

idw_basc_infogeneral.width = tab_1.tabpage_14.tab_2.tabpage_15.width - idw_basc_infogeneral.x - 20
idw_basc_infogeneral.height = tab_1.tabpage_14.tab_2.tabpage_15.height - idw_basc_infogeneral.y - 20

idw_basc_provcli.width =  tab_1.tabpage_14.tab_2.tabpage_16.width - idw_basc_provcli.x - 20
idw_basc_provcli.height = tab_1.tabpage_14.tab_2.tabpage_16.height - idw_basc_provcli.y - 20

idw_basc_subcontra.width = tab_1.tabpage_14.tab_2.tabpage_17.width - idw_basc_subcontra.x - 20
idw_basc_subcontra.height = tab_1.tabpage_14.tab_2.tabpage_17.height - idw_basc_subcontra.y - 20

idw_basc_documentos.width = tab_1.tabpage_14.tab_2.tabpage_18.width - idw_basc_documentos.x - 20
idw_basc_documentos.height = tab_1.tabpage_14.tab_2.tabpage_18.height - idw_basc_documentos.y -20

idw_basc_progvis.width = tab_1.tabpage_14.tab_2.tabpage_19.width - idw_basc_progvis.x - 20
idw_basc_progvis.height = tab_1.tabpage_14.tab_2.tabpage_19.height - idw_basc_progvis.y - 20


end event

event close;call super::close;destroy im_1
destroy invo_wait
end event

event ue_retrieve_list;// Asigna valores a estructura 
str_parametros sl_param

sl_param.dw1 = "d_sel_proveedores_tbl"
sl_param.titulo = "Proveedores"
sl_param.field_ret_i[1] = 1

OpenWithParm( w_lista, sl_param)
sl_param = MESSAGE.POWEROBJECTPARM
if sl_param.titulo <> 'n' then
	// Se ubica la cabecera
	of_retrieve(sl_param.field_ret[1])
	is_action = 'open'
END IF
end event

type dw_master from w_abc_master_tab`dw_master within w_cm002_proveedores
event keydown pbm_keydown
integer y = 96
integer width = 3707
integer height = 428
string dataobject = "d_abc_proveedor_id_ff"
boolean hscrollbar = false
boolean vscrollbar = false
end type

event dw_master::keydown;IF Key = KeyF5! THEN
	
	parent.event ue_event_f5( )
	

END IF
end event

event dw_master::constructor;call super::constructor;ii_ck[1] = 1
end event

event dw_master::itemerror;call super::itemerror;Return 1
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;u_dw_abc ldw_det

ldw_det = tab_1.tabpage_1.dw_1

is_old_flag_estado = '1'

this.object.flag_estado			[al_row] = '1'
this.object.cod_usr				[al_row] = gs_user
this.object.flag_nac_ext		[al_row] = 'N'
this.object.flag_tipo_precio	[al_row] = '2'

if gnvo_app.is_agente_ret = '1' then
	this.object.flag_buen_contrib	[al_row] = '0'
	this.object.flag_ret_igv		[al_row] = '1'
else
	this.object.flag_buen_contrib	[al_row] = '0'
	this.object.flag_ret_igv		[al_row] = '0'
end if

//Datos por defecto para el tema de BASC
this.object.basc_flag_email_propio 	[al_row] = '0'
this.object.basc_flag_buenas_ref 	[al_row] = '0'
this.object.basc_flag_buen_fin 		[al_row] = '0'

idw_nave.Reset()
idw_direccion.Reset()
idw_telefonos.Reset()
idw_subcateg.Reset()
idw_evaluacion.Reset()
idw_representante.Reset()
idw_campos.Reset()
idw_cta_bcos.Reset()
idw_basc_provcli.Reset()
idw_basc_subcontra.Reset()
idw_basc_progvis.Reset()


idw_nave.ii_update 				= 0
idw_direccion.ii_update 		= 0
idw_telefonos.ii_update 		= 0
idw_subcateg.ii_update 			= 0
idw_evaluacion.ii_update 		= 0
idw_representante.ii_update 	= 0
idw_campos.ii_update 			= 0
idw_cta_bcos.ii_update 			= 0
idw_basc_provcli.ii_update 	= 0
idw_basc_subcontra.ii_update 	= 0
idw_basc_progvis.ii_update 	= 0
	
idw_nave.ResetUpdate()
idw_direccion.ResetUpdate()
idw_telefonos.ResetUpdate()
idw_subcateg.ResetUpdate()
idw_evaluacion.ResetUpdate()
idw_representante.ResetUpdate()
idw_campos.ResetUpdate()
idw_cta_bcos.ResetUpdate()
idw_basc_provcli.Resetupdate()
idw_basc_subcontra.Resetupdate()
idw_basc_progvis.Resetupdate()
	
idw_basc_infogeneral.enabled = true

is_action = 'new'

this.Setcolumn('nom_proveedor')
end event

event dw_master::ue_output(long al_row);call super::ue_output;//IF al_row > 0 then
//	messagebox( '', al_row)
//	THIS.EVENT ue_retrieve_det(al_row)
//	idw_det.ScrollToRow(al_row)
//end if
end event

event dw_master::getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

type tab_1 from w_abc_master_tab`tab_1 within w_cm002_proveedores
integer x = 0
integer y = 536
integer width = 3657
integer height = 1648
integer textsize = -8
long backcolor = 12632256
boolean boldselectedtext = true
boolean perpendiculartext = true
tabposition tabposition = tabsonright!
tabpage_5 tabpage_5
tabpage_6 tabpage_6
tabpage_7 tabpage_7
tabpage_21 tabpage_21
tabpage_8 tabpage_8
tabpage_9 tabpage_9
tabpage_10 tabpage_10
tabpage_11 tabpage_11
tabpage_12 tabpage_12
tabpage_13 tabpage_13
tabpage_20 tabpage_20
tabpage_14 tabpage_14
tabpage_22 tabpage_22
end type

on tab_1.create
this.tabpage_5=create tabpage_5
this.tabpage_6=create tabpage_6
this.tabpage_7=create tabpage_7
this.tabpage_21=create tabpage_21
this.tabpage_8=create tabpage_8
this.tabpage_9=create tabpage_9
this.tabpage_10=create tabpage_10
this.tabpage_11=create tabpage_11
this.tabpage_12=create tabpage_12
this.tabpage_13=create tabpage_13
this.tabpage_20=create tabpage_20
this.tabpage_14=create tabpage_14
this.tabpage_22=create tabpage_22
call super::create
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_3,&
this.tabpage_4,&
this.tabpage_5,&
this.tabpage_6,&
this.tabpage_7,&
this.tabpage_21,&
this.tabpage_8,&
this.tabpage_9,&
this.tabpage_10,&
this.tabpage_11,&
this.tabpage_12,&
this.tabpage_13,&
this.tabpage_20,&
this.tabpage_14,&
this.tabpage_22}
end on

on tab_1.destroy
call super::destroy
destroy(this.tabpage_5)
destroy(this.tabpage_6)
destroy(this.tabpage_7)
destroy(this.tabpage_21)
destroy(this.tabpage_8)
destroy(this.tabpage_9)
destroy(this.tabpage_10)
destroy(this.tabpage_11)
destroy(this.tabpage_12)
destroy(this.tabpage_13)
destroy(this.tabpage_20)
destroy(this.tabpage_14)
destroy(this.tabpage_22)
end on

type tabpage_1 from w_abc_master_tab`tabpage_1 within tab_1
integer y = 16
integer width = 3090
integer height = 1616
long backcolor = 79741120
string text = "Datos Generales"
long tabbackcolor = 79741120
end type

type dw_1 from w_abc_master_tab`dw_1 within tabpage_1
integer width = 2976
integer height = 1356
boolean bringtotop = true
string dataobject = "d_abc_proveedor_datosgenerales_ff"
boolean hscrollbar = false
boolean vscrollbar = false
end type

event dw_1::clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event dw_1::itemchanged;call super::itemchanged;String ls_null
Long ll_count
SetNull(ls_null)

if lower(dwo.name) = 'ruc' then
	select count(*)
		into :ll_count
	from proveedor
	where ruc = :data;
	
	if ll_count > 0 then
		if MessageBox('Aviso', 'El Numero de RUC ya existe en Maestro de proveedor, ' &
				+ 'Desea Continuar?', Information!, YesNo!,1 ) = 2 then 
			this.object.ruc[row] = ls_null
			return
		end if
	end if
	
elseif dwo.name = 'tipo_doc_ident' then
	if data = '6' then
		this.object.nro_doc_ident.visible = '0'
		this.object.nro_doc_ident [row] = ls_null
		this.object.ruc_t.Visible = 'yes'
		this.object.ruc.Visible = '1'
	else
		this.object.nro_doc_ident.visible = '1'
		this.object.ruc [row] = ls_null
		this.object.ruc_t.Visible = '0'
		this.object.ruc.Visible = '0'
	end if
	
elseif dwo.name = 'flag_buen_contrib' then
	if data = '1' then
		this.object.flag_ret_igv.visible = '0'
		this.object.flag_ret_igv [row] = '0'
	else
		if gnvo_app.is_agente_ret = '1' then
			this.object.flag_ret_igv.visible = '1'
			this.object.flag_ret_igv [row] = '1'
		end if
	end if
	
end if
end event

event dw_1::ue_insert_pre;call super::ue_insert_pre;this.object.tipo_doc_ident [al_row] = '6'

end event

event dw_1::constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
	                  //      'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'form'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw
end event

type tabpage_2 from w_abc_master_tab`tabpage_2 within tab_1
boolean visible = false
integer y = 16
integer width = 3090
integer height = 1616
boolean enabled = false
string text = "Referencias"
end type

type dw_2 from w_abc_master_tab`dw_2 within tabpage_2
integer y = 0
integer width = 2482
integer height = 1044
boolean bringtotop = true
string dataobject = "d_abc_proveedor_referencias_ff"
end type

event dw_2::clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event dw_2::constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
	                  //      'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'form'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw
end event

type tabpage_3 from w_abc_master_tab`tabpage_3 within tab_1
boolean visible = false
integer y = 16
integer width = 3090
integer height = 1616
boolean enabled = false
string text = "Datos Técnicos"
end type

type dw_3 from w_abc_master_tab`dw_3 within tabpage_3
integer y = 0
integer width = 2501
integer height = 1020
boolean bringtotop = true
string dataobject = "d_abc_proveedor_datostecnicos_ff"
end type

event dw_3::clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event dw_3::constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
	                  //      'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'form'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw
end event

type tabpage_4 from w_abc_master_tab`tabpage_4 within tab_1
boolean visible = false
integer y = 16
integer width = 3090
integer height = 1616
boolean enabled = false
string text = "Post Venta"
end type

type dw_4 from w_abc_master_tab`dw_4 within tabpage_4
integer y = 0
integer width = 2519
integer height = 1056
boolean bringtotop = true
string dataobject = "d_abc_proveedor_postventa_ff"
end type

event dw_4::clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event dw_4::constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
	                  //      'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'form'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw
end event

type tabpage_5 from userobject within tab_1
boolean visible = false
integer x = 18
integer y = 16
integer width = 3090
integer height = 1616
boolean enabled = false
long backcolor = 79741120
string text = "Sistema Calidad"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_5 dw_5
end type

on tabpage_5.create
this.dw_5=create dw_5
this.Control[]={this.dw_5}
end on

on tabpage_5.destroy
destroy(this.dw_5)
end on

type dw_5 from u_dw_abc within tabpage_5
integer width = 2505
integer height = 1072
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_abc_proveedor_sistema_calidad_ff"
borderstyle borderstyle = styleraised!
end type

event clicked;//Override
idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;//override
end event

type tabpage_6 from userobject within tab_1
integer x = 18
integer y = 16
integer width = 3090
integer height = 1616
long backcolor = 79741120
string text = "Dirección"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_direccion dw_direccion
end type

on tabpage_6.create
this.dw_direccion=create dw_direccion
this.Control[]={this.dw_direccion}
end on

on tabpage_6.destroy
destroy(this.dw_direccion)
end on

type dw_direccion from u_dw_abc within tabpage_6
integer width = 2994
integer height = 1444
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_abc_proveedor_direccion_tbl"
borderstyle borderstyle = styleraised!
end type

event constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
is_dwform = 'tabular'	
end event

event itemchanged;call super::itemchanged;String 		ls_pais, ls_departamento, ls_provincia, ls_distrito, ls_ciudad, ls_data
str_ubigeo	lstr_ubigeo

idw_1 = this

idw_1.GetText()
idw_1.AcceptText()
		
Choose CASE dwo.name
	case "ubigeo_org"
		
		select su.distrito,
				 su.provincia,
				 su.departamento,
				 su.departamento || '-' || su.provincia || '-' || su.distrito
			into :lstr_ubigeo.desc_distrito,
				  :lstr_ubigeo.desc_provincia,
				  :lstr_ubigeo.desc_departamento,
				  :lstr_ubigeo.descripcion
		  from sunat_ubigeo su
		 where su.ubigeo 			= :data
		   and su.flag_estado 	= '1';
		
		if SQLCA.SQLCode = 100 then
			this.object.dir_distrito	[row] = gnvo_app.is_null
			this.object.dir_provincia	[row] = gnvo_app.is_null
			this.object.dir_dep_estado	[row] = gnvo_app.is_null
			MessageBox('Error', 'Codigo de UBIGEO ' + data + ' no existe o no esta activo, por favor verifique')
			return 1
		end if
  
		this.object.desc_ubigeo	[row] = lstr_ubigeo.descripcion
		
		this.object.dir_distrito		[row] = lstr_ubigeo.desc_distrito
		this.object.dir_provincia		[row] = lstr_ubigeo.desc_provincia
		this.object.dir_dep_estado		[row] = lstr_ubigeo.desc_departamento
		
	Case 'dir_pais'
		ls_pais  = this.GetItemString(row, "dir_pais")
		if ls_pais = "" or isnull(ls_pais) then
			idw_1.ii_update = 0
			Messagebox("Validación", "Ingresar el valor del Pais")
			this.SetColumn("dir_pais")
			this.SetFocus()
		End If
		
	Case 'dir_dep_estado'
		ls_departamento= this.GetItemString(row, "dir_dep_estado")
		if ls_departamento = "" or isnull(ls_departamento) then
			idw_1.ii_update = 0
			Messagebox("Validación", "Ingresar el valor del Departamento")
			this.SetColumn("dir_dep_estado")
			this.SetFocus()
		End If
		
	Case 'dir_provincia'
		ls_provincia  = this.GetItemString(row, "dir_provincia")
		if ls_provincia = "" or isnull(ls_provincia) then
			idw_1.ii_update = 0
			Messagebox("Validación", "Ingresar el valor de la Provincia")
			this.SetColumn("dir_provincia")
			this.SetFocus()
		End If
		
	Case 'dir_ciudad'
		ls_ciudad  = this.GetItemString(row, "dir_ciudad")
		if ls_ciudad = "" or isnull(ls_ciudad) then
			idw_1.ii_update = 0
			Messagebox("Validación", "Ingresar el valor de la Ciudad")
			this.SetColumn("dir_ciudad")
			this.SetFocus()
		End If
		
	Case 'dir_distrito'
		ls_distrito  = this.GetItemString(row, "dir_distrito")
		if ls_distrito = "" or isnull(ls_distrito) then
			idw_1.ii_update = 0
			Messagebox("Validación", "Ingresar el valor del Distrito")
			this.SetColumn("dir_distrito")
			this.SetFocus()
		End If

	CASE 'cod_pais_sunat'
		
		// Verifica que codigo ingresado exista			
		Select descripcion
	     into :ls_data
		  from sunat_tabla35
		 Where codigo = :data 
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQLCode = 100 then
			this.object.cod_pais_sunat	[row] = gnvo_app.is_null
			this.object.nom_pais_sunat	[row] = gnvo_app.is_null
			MessageBox('Error', 'Codigo de Pais no existe o no esta activo, por favor verifique')
			return 1
		end if

		this.object.nom_pais_sunat			[row] = ls_data	

	CASE 'dir_siglas_pais'
		
		// Verifica que codigo ingresado exista			
		Select desc_pais
	     into :ls_data
		  from SUNAT_CATALOGO03
		 Where cod_pais = :data 
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQLCode = 100 then
			this.object.dir_siglas_pais		[row] = gnvo_app.is_null
			this.object.desc_pais_catalogo03	[row] = gnvo_app.is_null
			MessageBox('Error', 'Codigo de Pais CATALOGO 03 no existe o no esta activo, por favor verifique')
			return 1
		end if

		this.object.desc_pais_catalogo03		[row] = ls_data	

End Choose
end event

event ue_insert_pre;call super::ue_insert_pre;Int j, ln_num = 0

this.object.codigo	[al_row] = dw_master.Object.proveedor[1]
this.object.flag_uso [al_row] = '1'

this.object.latitud 	[al_row] = 0.00
this.object.longitud [al_row] = 0.00

For j = 1 to this.rowcount()
	if this.object.item[j] > ln_num then
		ln_num = this.object.item[j]
	end if
Next

this.object.item[al_row] = ln_num + 1
end event

event itemerror;call super::itemerror;RETURN 1
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
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

event ue_display;call super::ue_display;boolean lb_ret
string ls_codigo, ls_data, ls_sql, ls_ubigeo
str_ubigeo	lstr_ubigeo

choose case lower(as_columna)
	case "ubigeo"
		lstr_ubigeo = invo_util.of_get_ubigeo()
		
		if lstr_ubigeo.b_return then
			
			this.object.ubigeo	[al_row] = lstr_ubigeo.codigo
			
			this.object.dir_distrito	[al_row] = lstr_ubigeo.desc_distrito
			this.object.dir_provincia	[al_row] = lstr_ubigeo.desc_provincia
			this.object.dir_dep_estado	[al_row] = lstr_ubigeo.desc_departamento
			
			this.ii_update = 1
		end if
		
	case "cod_pais_sunat"
		ls_sql = "select t.codigo as codigo, " &
				 + "t.descripcion as descripcion " &
				 + "from sunat_tabla35 t " &
				 + "where t.flag_estado = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

		if ls_codigo <> '' then
			this.object.cod_pais_sunat	[al_row] = ls_codigo
			this.object.nom_pais_sunat	[al_row] = ls_data
			this.ii_update = 1
		end if
		
	case "dir_siglas_pais"
		ls_sql = "select t.cod_pais as codigo_pais, " &
				 + "t.desc_pais as descripcion_pais " &
				 + "from SUNAT_CATALOGO03 t " &
				 + "where t.flag_estado = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

		if ls_codigo <> '' then
			this.object.dir_siglas_pais		[al_row] = ls_codigo
			this.object.desc_pais_catalogo03	[al_row] = ls_data
			this.ii_update = 1
		end if
		
	case "zona_venta"
		
		ls_ubigeo = this.object.ubigeo [al_row]
		
		if IsNull(ls_ubigeo) or trim(ls_ubigeo) = '' then
			MessageBox('Error', 'Debe elegir un ubigeo primero, por favor verifique!', StopSign!)
			this.setColumn('ubigeo')
			return
		end if
		
		ls_sql = "select zv.zona_venta as zona_venta, " &
				 + "       zv.desc_zona_venta as desc_zona_venta " &
				 + "from vta_zona_venta zv " & 
				 + "where zv.flag_estado = '1'" &
				 + "  and zv.ubigeo = '" + ls_ubigeo + "'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

		if ls_codigo <> '' then
			this.object.zona_venta			[al_row] = ls_codigo
			this.object.desc_zona_venta	[al_row] = ls_data
			this.ii_update = 1
		end if

	case "zona_despacho"
		
		ls_ubigeo = this.object.ubigeo [al_row]
		
		if IsNull(ls_ubigeo) or trim(ls_ubigeo) = '' then
			MessageBox('Error', 'Debe elegir un ubigeo primero, por favor verifique!', StopSign!)
			this.setColumn('ubigeo')
			return
		end if
		
		ls_sql = "select zd.zona_despacho as zona_despacho, " &
				 + "       zd.desc_zona_despacho as desc_zona_despacho " &
				 + "from vta_zona_despacho zd " &
				 + "where zd.flag_estado = '1'" &
				 + "  and zd.ubigeo = '" + ls_ubigeo + "'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

		if ls_codigo <> '' then
			this.object.zona_despacho			[al_row] = ls_codigo
			this.object.desc_zona_despacho	[al_row] = ls_data
			this.ii_update = 1
		end if
end choose
end event

type tabpage_7 from userobject within tab_1
integer x = 18
integer y = 16
integer width = 3090
integer height = 1616
long backcolor = 79741120
string text = "Teléfonos"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_telefonos dw_telefonos
end type

on tabpage_7.create
this.dw_telefonos=create dw_telefonos
this.Control[]={this.dw_telefonos}
end on

on tabpage_7.destroy
destroy(this.dw_telefonos)
end on

type dw_telefonos from u_dw_abc within tabpage_7
integer width = 2414
integer height = 836
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_abc_proveedor_telefono_tbl"
borderstyle borderstyle = styleraised!
end type

event constructor;ii_ck[1] = 1				// columnas de lectura de este dw
end event

event ue_insert_pre(long al_row);call super::ue_insert_pre;Int j, ln_num = 0

this.object.codigo[al_row] = dw_master.Object.proveedor[dw_master.getrow()]

For j = 1 to this.rowcount()
	if this.object.item[j] > ln_num then
		ln_num = this.object.item[j]
	end if
Next

this.object.item[al_row] = ln_num + 1
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

type tabpage_21 from userobject within tab_1
boolean visible = false
integer x = 18
integer y = 16
integer width = 3090
integer height = 1616
boolean enabled = false
long backcolor = 67108864
string text = "Documentos~r~nAnexos"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
long picturemaskcolor = 536870912
end type

type tabpage_8 from userobject within tab_1
boolean visible = false
integer x = 18
integer y = 16
integer width = 3090
integer height = 1616
boolean enabled = false
long backcolor = 67108864
string text = "Sub. Categ."
long tabtextcolor = 33554432
long tabbackcolor = 12632256
long picturemaskcolor = 536870912
dw_subcateg dw_subcateg
end type

on tabpage_8.create
this.dw_subcateg=create dw_subcateg
this.Control[]={this.dw_subcateg}
end on

on tabpage_8.destroy
destroy(this.dw_subcateg)
end on

type dw_subcateg from u_dw_abc within tabpage_8
event ue_display ( string as_columna,  long al_row )
integer width = 2487
integer height = 860
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_abc_proveedor_subcategoria_tbl"
borderstyle borderstyle = styleraised!
end type

event ue_display;boolean lb_ret
string ls_codigo, ls_data, ls_sql

choose case lower(as_columna)
	case "cod_sub_cat"
		ls_sql = "select t.cod_sub_cat as codigo, " &
				 + "t.desc_sub_cat as descripcion_subcategoria, " &
				 + "t.flag_servicio as servicio " &
				 + "from articulo_sub_categ t " &
				 + "where t.flag_estado = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

		if ls_codigo <> '' then
			this.object.cod_sub_cat		[al_row] = ls_codigo
			this.object.desc_sub_cat	[al_row] = ls_data
			this.ii_update = 1
		end if
		
end choose


end event

event constructor;ii_ck[1] = 1				// columnas de lectura de este dw
end event

event ue_insert_pre;call super::ue_insert_pre;Long ll_row_mas
ll_row_mas = dw_master.GetRow()

if ll_row_mas = 0 then 
	MessageBox('Aviso', 'No se ha definido cabecera de Proveedor', StopSign!)
	return
end if

this.object.proveedor				[al_row] = dw_master.Object.proveedor[ll_row_mas]
this.object.fecha_calificacion 	[al_row] = Today()
this.object.cod_usr					[al_row] = gs_user
this.object.flag_calificacion		[al_row] = '1'


end event

event doubleclicked;call super::doubleclicked;string ls_columna
long ll_row 
str_seleccionar lstr_seleccionar

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' &
	and upper(dwo.name) <> 'ESPECIE' then RETURN
ll_row = row

if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if
end event

event itemchanged;call super::itemchanged;string ls_codigo, ls_data

this.AcceptText()

if row <= 0 then
	return
end if

choose case lower(dwo.name)
	case "cod_sub_cat"
		
		ls_codigo = this.object.cod_sub_cat[row]

		// Verifica que sub categoria exista
		Select desc_sub_cat 
			into :ls_data
		from articulo_sub_categ
		Where cod_sub_cat = :data
		  and flag_estado = '1';
		
		if IsNull(ls_data) or ls_data = '' then
			Messagebox( "Error", "Código de Sub categoria no existe o no se encuentra activa, por favor verifique!", Exclamation!)
			this.object.cod_sub_cat		[row] = gnvo_app.is_null
			this.object.desc_sub_cat	[row] = gnvo_app.is_null
			return 1
		end if
		
		this.object.desc_sub_cat [row] = ls_data
		
	case 'flag_calificacion'
		
		this.object.fecha_calificacion	[row] = gnvo_app.of_fecha_actual( )
		this.object.cod_usr					[row] = gs_user

		
end choose

end event

event itemerror;call super::itemerror;return 1
end event

event keydwn;call super::keydwn;string ls_columna, ls_cadena
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

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

type tabpage_9 from userobject within tab_1
boolean visible = false
integer x = 18
integer y = 16
integer width = 3090
integer height = 1616
boolean enabled = false
long backcolor = 67108864
string text = "Evaluacion"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
long picturemaskcolor = 536870912
dw_evaluacion dw_evaluacion
end type

on tabpage_9.create
this.dw_evaluacion=create dw_evaluacion
this.Control[]={this.dw_evaluacion}
end on

on tabpage_9.destroy
destroy(this.dw_evaluacion)
end on

type dw_evaluacion from u_dw_abc within tabpage_9
integer width = 2491
integer height = 860
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_abc_proveedor_criterio_tbl"
borderstyle borderstyle = styleraised!
end type

event constructor;ii_ck[1] = 1				// columnas de lectura de este dw
end event

event doubleclicked;call super::doubleclicked;// Abre ventana de ayuda 
str_parametros sl_param
String ls_name, ls_prot

ls_name = dwo.name
ls_prot = this.Describe( ls_name + ".Protect")

if ls_prot = '1' then    //protegido 
	return
end if
CHOOSE CASE dwo.name 
	CASE 'cod_sub_cat' 
		// Asigna valores a structura 
		sl_param.dw1 = "d_dddw_sub_categoria"
		sl_param.titulo = "Sub Categorias"
		sl_param.field_ret_i[1] = 1		

		OpenWithParm( w_search, sl_param)
		sl_param = MESSAGE.POWEROBJECTPARM
		if sl_param.titulo <> 'n' then			
			this.object.cod_sub_cat[this.getrow()] = sl_param.field_ret[1]			
		END IF
	
END CHOOSE
end event

event ue_insert_pre;call super::ue_insert_pre;this.object.cod_proveedor[al_row] = dw_master.Object.proveedor[dw_master.getrow()]
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

type tabpage_10 from userobject within tab_1
integer x = 18
integer y = 16
integer width = 3090
integer height = 1616
long backcolor = 67108864
string text = "Representante"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
long picturemaskcolor = 536870912
dw_representante dw_representante
end type

on tabpage_10.create
this.dw_representante=create dw_representante
this.Control[]={this.dw_representante}
end on

on tabpage_10.destroy
destroy(this.dw_representante)
end on

type dw_representante from u_dw_abc within tabpage_10
integer width = 2496
integer height = 860
integer taborder = 40
boolean bringtotop = true
string dataobject = "d_abc_representante_tbl"
borderstyle borderstyle = styleraised!
end type

event constructor;ii_ck[1] = 1				// columnas de lectura de este dw
end event

event doubleclicked;call super::doubleclicked;// Abre ventana de ayuda 
str_parametros sl_param
String ls_name, ls_prot

ls_name = dwo.name
ls_prot = this.Describe( ls_name + ".Protect")

if ls_prot = '1' then    //protegido 
	return
end if
CHOOSE CASE dwo.name 
	CASE 'cod_sub_cat' 
		// Asigna valores a structura 
		sl_param.dw1 = "d_dddw_sub_categoria"
		sl_param.titulo = "Sub Categorias"
		sl_param.field_ret_i[1] = 1		

		OpenWithParm( w_search, sl_param)
		sl_param = MESSAGE.POWEROBJECTPARM
		if sl_param.titulo <> 'n' then			
			this.object.cod_sub_cat[this.getrow()] = sl_param.field_ret[1]			
		END IF
	
END CHOOSE
end event

event ue_insert_pre(long al_row);call super::ue_insert_pre;Int j, ln_num = 0

this.object.cod_proveedor[al_row] = dw_master.Object.proveedor[dw_master.getrow()]

For j = 1 to this.rowcount()
	if this.object.nro_item[j] > ln_num then
		ln_num = this.object.nro_item[j]
	end if
Next

this.object.nro_item[al_row] = ln_num + 1
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

type tabpage_11 from userobject within tab_1
boolean visible = false
integer x = 18
integer y = 16
integer width = 3090
integer height = 1616
boolean enabled = false
long backcolor = 67108864
string text = "Campos"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
long picturemaskcolor = 536870912
dw_campos dw_campos
end type

on tabpage_11.create
this.dw_campos=create dw_campos
this.Control[]={this.dw_campos}
end on

on tabpage_11.destroy
destroy(this.dw_campos)
end on

type dw_campos from u_dw_abc within tabpage_11
integer width = 2491
integer height = 860
integer taborder = 50
boolean bringtotop = true
string dataobject = "d_dddw_campos"
borderstyle borderstyle = styleraised!
end type

event constructor;ii_ck[1] = 1				// columnas de lectura de este dw
end event

event doubleclicked;call super::doubleclicked;// Abre ventana de ayuda 
str_parametros sl_param
String ls_name, ls_prot

ls_name = dwo.name
ls_prot = this.Describe( ls_name + ".Protect")

if ls_prot = '1' then    //protegido 
	return
end if
CHOOSE CASE dwo.name 
	CASE 'cod_sub_cat' 
		// Asigna valores a structura 
		sl_param.dw1 = "d_dddw_sub_categoria"
		sl_param.titulo = "Sub Categorias"
		sl_param.field_ret_i[1] = 1		

		OpenWithParm( w_search, sl_param)
		sl_param = MESSAGE.POWEROBJECTPARM
		if sl_param.titulo <> 'n' then			
			this.object.cod_sub_cat[this.getrow()] = sl_param.field_ret[1]			
		END IF
	
END CHOOSE
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

type tabpage_12 from userobject within tab_1
boolean visible = false
integer x = 18
integer y = 16
integer width = 3090
integer height = 1616
boolean enabled = false
long backcolor = 67108864
string text = "Armador - Nave"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
long picturemaskcolor = 536870912
dw_nave dw_nave
end type

on tabpage_12.create
this.dw_nave=create dw_nave
this.Control[]={this.dw_nave}
end on

on tabpage_12.destroy
destroy(this.dw_nave)
end on

type dw_nave from u_dw_abc within tabpage_12
integer width = 2875
integer height = 1484
integer taborder = 20
string dataobject = "d_naves_ff"
borderstyle borderstyle = styleraised!
end type

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;ii_ck[1] = 1
end event

type tabpage_13 from userobject within tab_1
integer x = 18
integer y = 16
integer width = 3090
integer height = 1616
long backcolor = 67108864
string text = "Cuentas Bancarias"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
long picturemaskcolor = 536870912
dw_ctas_bco dw_ctas_bco
end type

on tabpage_13.create
this.dw_ctas_bco=create dw_ctas_bco
this.Control[]={this.dw_ctas_bco}
end on

on tabpage_13.destroy
destroy(this.dw_ctas_bco)
end on

type dw_ctas_bco from u_dw_abc within tabpage_13
integer width = 2423
integer height = 1036
integer taborder = 20
string dataobject = "d_abc_proveedor_cnta_bco_tbl"
borderstyle borderstyle = styleraised!
end type

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
	                  // 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)



ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2





end event

event itemchanged;call super::itemchanged;Accepttext()
end event

event itemerror;call super::itemerror;Return 1
end event

event ue_insert_pre;call super::ue_insert_pre;this.object.proveedor	[al_row] = dw_master.Object.proveedor[dw_master.getrow()]
this.object.flag_estado	[al_row] = '1'
end event

type tabpage_20 from userobject within tab_1
integer x = 18
integer y = 16
integer width = 3090
integer height = 1616
long backcolor = 67108864
string text = "Lineas de Credito"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
long picturemaskcolor = 536870912
dw_lineas_credito dw_lineas_credito
end type

on tabpage_20.create
this.dw_lineas_credito=create dw_lineas_credito
this.Control[]={this.dw_lineas_credito}
end on

on tabpage_20.destroy
destroy(this.dw_lineas_credito)
end on

type dw_lineas_credito from u_dw_abc within tabpage_20
integer width = 2939
integer height = 1404
string dataobject = "d_abc_lineas_credito_tbl"
borderstyle borderstyle = styleraised!
end type

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
	                  // 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)



ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2





end event

event itemchanged;call super::itemchanged;Accepttext()
end event

event itemerror;call super::itemerror;Return 1
end event

event ue_insert_pre;call super::ue_insert_pre;DateTime ldt_hoy

ldt_hoy = gnvo_app.of_fecha_actual()

this.object.proveedor	[al_row] = dw_master.Object.proveedor[dw_master.getrow()]
this.object.flag_estado	[al_row] = '3'

this.object.fec_registro	[al_row] = ldt_hoy
this.object.fec_inicio_vig	[al_row] = Date(ldt_hoy)
this.object.fec_fin_vig		[al_row] = RelativeDate ( Date(ldt_hoy), 180 )
this.object.cod_usr			[al_row] = gs_user
end event

type tabpage_14 from userobject within tab_1
boolean visible = false
integer x = 18
integer y = 16
integer width = 3090
integer height = 1616
boolean enabled = false
long backcolor = 67108864
string text = "BASC"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
long picturemaskcolor = 536870912
tab_2 tab_2
end type

on tabpage_14.create
this.tab_2=create tab_2
this.Control[]={this.tab_2}
end on

on tabpage_14.destroy
destroy(this.tab_2)
end on

type tab_2 from tab within tabpage_14
integer x = 32
integer y = 32
integer width = 2967
integer height = 1500
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
boolean raggedright = true
boolean focusonbuttondown = true
integer selectedtab = 1
tabpage_15 tabpage_15
tabpage_16 tabpage_16
tabpage_17 tabpage_17
tabpage_18 tabpage_18
tabpage_19 tabpage_19
end type

on tab_2.create
this.tabpage_15=create tabpage_15
this.tabpage_16=create tabpage_16
this.tabpage_17=create tabpage_17
this.tabpage_18=create tabpage_18
this.tabpage_19=create tabpage_19
this.Control[]={this.tabpage_15,&
this.tabpage_16,&
this.tabpage_17,&
this.tabpage_18,&
this.tabpage_19}
end on

on tab_2.destroy
destroy(this.tabpage_15)
destroy(this.tabpage_16)
destroy(this.tabpage_17)
destroy(this.tabpage_18)
destroy(this.tabpage_19)
end on

type tabpage_15 from userobject within tab_2
integer x = 18
integer y = 104
integer width = 2930
integer height = 1380
long backcolor = 67108864
string text = "Inf.General"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
long picturemaskcolor = 536870912
dw_6 dw_6
end type

on tabpage_15.create
this.dw_6=create dw_6
this.Control[]={this.dw_6}
end on

on tabpage_15.destroy
destroy(this.dw_6)
end on

type dw_6 from u_dw_abc within tabpage_15
integer width = 2825
integer height = 1292
integer taborder = 20
string dataobject = "d_abc_proveedor_basc_infoadic_ff"
boolean vscrollbar = false
boolean border = false
borderstyle borderstyle = stylebox!
end type

event buttonclicked;call super::buttonclicked;if dwo.name = 'b_infref' then
	this.object.basc_desc_buenas_ref[row] = gnvo_app.of_get_message('Buenas Referencias',this.object.basc_desc_buenas_ref[row])
elseif dwo.name = 'b_estfin' then
	this.object.basc_desc_estado_fin[row] = gnvo_app.of_get_message('Buen estado Financiero',this.object.basc_desc_estado_fin[row])	
end if
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;Integer	li_x

FOR li_x = 1 TO UpperBound(dw_master.ii_ck)
	ii_ck[li_x] = dw_master.ii_ck[li_x]
NEXT
end event

event itemchanged;call super::itemchanged;dw_master.ii_update = 1
end event

type tabpage_16 from userobject within tab_2
integer x = 18
integer y = 104
integer width = 2930
integer height = 1380
long backcolor = 67108864
string text = "Principales.Clientes"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
dw_7 dw_7
end type

on tabpage_16.create
this.dw_7=create dw_7
this.Control[]={this.dw_7}
end on

on tabpage_16.destroy
destroy(this.dw_7)
end on

type dw_7 from u_dw_abc within tabpage_16
integer width = 2853
integer height = 1308
boolean bringtotop = true
string dataobject = "d_abc_proveedor_basc_princlientes_grd"
end type

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
is_dwform = 'grid'	
end event

event itemchanged;call super::itemchanged;

idw_1 = this

		idw_1.GetText()
		idw_1.AcceptText()

end event

event itemerror;call super::itemerror;RETURN 1
end event

event ue_insert_pre;call super::ue_insert_pre;Int j, ln_num = 0

this.object.proveedor[al_row] = dw_master.Object.proveedor[dw_master.getrow()]
this.object.cod_usr				[al_row] = gs_user
this.object.fec_registro [al_row] = datetime(today(),now())

For j = 1 to this.rowcount()
	if this.object.nro_item[j] > ln_num then
		ln_num = this.object.nro_item[j]
	end if
Next

this.object.nro_item[al_row] = ln_num + 1
end event

type tabpage_17 from userobject within tab_2
integer x = 18
integer y = 104
integer width = 2930
integer height = 1380
long backcolor = 67108864
string text = "Principales.SubContratas"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
dw_8 dw_8
end type

on tabpage_17.create
this.dw_8=create dw_8
this.Control[]={this.dw_8}
end on

on tabpage_17.destroy
destroy(this.dw_8)
end on

type dw_8 from u_dw_abc within tabpage_17
integer width = 2853
integer height = 1308
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_abc_proveedor_basc_prinsubcont_grd"
end type

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
is_dwform = 'grid'	
end event

event itemchanged;call super::itemchanged;

idw_1 = this

		idw_1.GetText()
		idw_1.AcceptText()

end event

event itemerror;call super::itemerror;RETURN 1
end event

event ue_insert_pre;call super::ue_insert_pre;Int j, ln_num = 0

this.object.proveedor[al_row] = dw_master.Object.proveedor[dw_master.getrow()]
this.object.cod_usr				[al_row] = gs_user
this.object.fec_registro [al_row] = datetime(today(),now())

For j = 1 to this.rowcount()
	if this.object.nro_item[j] > ln_num then
		ln_num = this.object.nro_item[j]
	end if
Next

this.object.nro_item[al_row] = ln_num + 1
end event

type tabpage_18 from userobject within tab_2
integer x = 18
integer y = 104
integer width = 2930
integer height = 1380
long backcolor = 67108864
string text = "Visitas"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
sle_archiobs sle_archiobs
st_4 st_4
dp_1 dp_1
st_2 st_2
cb_2 cb_2
st_3 st_3
dw_9 dw_9
cb_1 cb_1
sle_rutaarchivo sle_rutaarchivo
end type

on tabpage_18.create
this.sle_archiobs=create sle_archiobs
this.st_4=create st_4
this.dp_1=create dp_1
this.st_2=create st_2
this.cb_2=create cb_2
this.st_3=create st_3
this.dw_9=create dw_9
this.cb_1=create cb_1
this.sle_rutaarchivo=create sle_rutaarchivo
this.Control[]={this.sle_archiobs,&
this.st_4,&
this.dp_1,&
this.st_2,&
this.cb_2,&
this.st_3,&
this.dw_9,&
this.cb_1,&
this.sle_rutaarchivo}
end on

on tabpage_18.destroy
destroy(this.sle_archiobs)
destroy(this.st_4)
destroy(this.dp_1)
destroy(this.st_2)
destroy(this.cb_2)
destroy(this.st_3)
destroy(this.dw_9)
destroy(this.cb_1)
destroy(this.sle_rutaarchivo)
end on

type sle_archiobs from singlelineedit within tabpage_18
integer x = 1390
integer y = 180
integer width = 946
integer height = 80
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
textcase textcase = upper!
integer limit = 200
borderstyle borderstyle = stylelowered!
end type

type st_4 from statictext within tabpage_18
integer x = 1019
integer y = 196
integer width = 361
integer height = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Observaciones:"
alignment alignment = right!
boolean focusrectangle = false
end type

type dp_1 from datepicker within tabpage_18
integer x = 535
integer y = 176
integer width = 471
integer height = 100
integer taborder = 20
boolean border = true
borderstyle borderstyle = stylelowered!
string customformat = "dd/MM/yyyy"
date maxdate = Date("2999-12-31")
date mindate = Date("1800-01-01")
datetime value = DateTime(Date("2021-11-05"), Time("13:21:55.000000"))
integer textsize = -8
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
integer calendarfontweight = 400
boolean todaysection = true
boolean todaycircle = true
end type

type st_2 from statictext within tabpage_18
integer x = 165
integer y = 204
integer width = 343
integer height = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Fecha Visita:"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_2 from commandbutton within tabpage_18
integer x = 73
integer y = 68
integer width = 434
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Buscar Archivo..."
end type

event clicked;string docpath, docname[]
integer i, li_cnt, li_rtn, li_filenum

li_rtn = GetFileOpenName("Select File", &
   docpath, docname[], "DOC", &
   + "Text Files (*.PDF),*.PDF," &
   + "Doc Files (*.DOCX),*.DOCX," &
   + "All Files (*.*), *.*", &
   "C:\", 18)

sle_rutaarchivo.text = ""
is_nombre_archivo = ''

IF li_rtn < 1 THEN return
li_cnt = Upperbound(docname)

// if only one file is picked, docpath contains the 
// path and file name
if li_cnt = 1 then
   sle_rutaarchivo.text = string(docpath)
   is_nombre_archivo = docname[1]
else
	MessageBox('Aviso','Debe seleccionar unicamente un archivo')
end if
end event

type st_3 from statictext within tabpage_18
integer x = 55
integer y = 396
integer width = 786
integer height = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Archivos Subidos:"
boolean focusrectangle = false
end type

type dw_9 from u_dw_abc within tabpage_18
integer x = 32
integer y = 468
integer width = 2853
integer height = 892
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_abc_proveedor_basc_visitasblob_grd"
end type

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

if dwo.name = 'eliminar' and row > 0 then
	if MessageBox('Aviso','¿Esta Seguro de eliminar el archivo?',Question!,yesNo!,2) = 1 then
		this.deleterow(row)
		this.update()
		commit;
	else
		this.object.eliminar[row] = '0'
		return 1
	end if
end if
end event

event constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
is_dwform = 'grid'	
end event

event itemerror;call super::itemerror;RETURN 1
end event

event ue_insert;//override
return 0
end event

event doubleclicked;call super::doubleclicked;
if row > 0 then
	
	if Messagebox('Aviso','¿Desea descargar el archivo a su computadora',Question!,YesNo!,2) = 1 then
		
		//codigo para abrir documento pdf que se encuentra en un BLOB
		blob lbl_pdfdoc, lbl_null
		string ls_codinc, ls_prov
		integer li_nroitem
		
		// obteniendo valores
		li_nroitem = This.Object.nro_item[row]
		ls_prov = dw_master.Object.proveedor[dw_master.getrow()]
		
		string ls_rutaarchivo, ls_nombrearchivo
		integer li_filenum, li_write_error
		
		ls_nombrearchivo = this.object.nombre_archivo[row]
		
		//se verifica si existe archivo
		if directoryexists("C:\documentos_sigre") = false then
			if createdirectory("C:\documentos_sigre") <> 1 then
				MessageBox('Aviso','No se pudo crear directorio en "C:\documentos_sigre" para guardar el archivo')
				return
			end if
		end if
		
		// se puede establecer cualquier ruta donde tenga permisos de escritura el usuario
		ls_rutaarchivo = "C:\documentos_sigre\"+ls_nombrearchivo

		if fileexists(ls_rutaarchivo) then
			MessageBox('Aviso','Ya existe un archivo con el mismo nombre en el directorio "C:\documentos_sigre". No se podra continuar')
			return
		end if
		
		SetPointer(HourGlass!)
		
		// obteniendo blob
		selectblob documento
				into :lbl_pdfdoc
				from basc_proveedor_visitas
			  where proveedor = :ls_prov
			     and nro_item = :li_nroitem;
		
		if isnull(lbl_pdfdoc) or lbl_pdfdoc = lbl_null then
			messagebox('Aviso','No Existe Documento Adjunto, revise por favor')
			SetPointer(Arrow!)
			return
		end if
				
		// se tiene que abrir con los siguientes permisos para poder sobre escribir
		li_filenum = FileOpen(ls_rutaarchivo, StreamMode!, Write!, LockWrite!, Replace!)
		
		if li_filenum = -1 then
			messagebox('Aviso','No se puede abrir documento PDF por que no tiene acceso al directorio')
			SetPointer(Arrow!)
			return
		end if
		
		li_Write_Error = FileWriteEx(li_filenum, lbl_pdfdoc)
		
		if li_Write_Error = -1 then
			messagebox('Aviso','No se puede guardar documento TEMPORAL por que no tiene acceso al directorio')
			SetPointer(Arrow!)
			return
		end if
		
		FileClose(li_filenum)
		SetPointer(Arrow!)
		
		MessageBox('Aviso','Se guardo el documento exitosamente en "C:\documentos_sigre"');
		run('explorer.exe C:\documentos_sigre')
		
	end if
	
end if
end event

event itemchanged;call super::itemchanged;//if dwo.name = 'eliminar' then
//	if MessageBox('Aviso','¿Esta Seguro de eliminar el archivo?',Question!,yesNo!,2) = 1 then
//		this.deleterow(row)
//		this.update()
//		commit;
//	else
//		this.object.eliminar[row] = '0'
//		return 1
//	end if
//end if

return 1
end event

type cb_1 from commandbutton within tabpage_18
integer x = 2473
integer y = 116
integer width = 343
integer height = 100
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Añadir"
end type

event clicked;string ls_ruta, ls_obs, ls_prov
date ld_fecvis
time lt_now

ls_ruta = sle_rutaarchivo.text

if fileexists(ls_ruta) = false then
	MessageBox("Aviso","El archivo ingresado no existe",StopSign!)
	return
end if

ls_obs = sle_archiobs.text

if ls_obs = '' or isnull(ls_obs) then
	if MessageBox("Aviso","¿Esta seguro de adjuntar el archivo sin observaciones?",Question!,YesNo!,2) = 2 then
		return
	end if
end if

dp_1.getvalue(ld_fecvis,lt_now)

ls_prov = dw_master.Object.proveedor[dw_master.getrow()]

if ls_prov = '' or isnull(ls_prov) then
	MessageBox("Aviso","Debe guardar el registro de proveedor/cliente para poder adjuntar un archivo",StopSign!)
	return
end if

integer li_ret, li_filenum, li_nroitem
blob lbl_doc

// 3.- se abre el archivo
li_filenum = FileOpen(ls_ruta, StreamMode!)

if li_filenum <= 0 then
	MessageBox('Aviso','No se pudo abrir el archivo solicitado')
	return
end if

// 4.- se lee el archivo
li_ret = FileReadEx(li_filenum, lbl_doc)

if li_ret <> -100 and li_ret <> -1 and li_ret <> 0 then
			
	// 5.- se actualiza columna en BD
	FileClose(li_filenum)
	
	SetPointer(Hourglass!)
	
	select count(1) + 1
	 into 	:li_nroitem
	 from basc_proveedor_visitas
	where proveedor = :ls_prov;
	
	if gnvo_app.of_existserror(sqlca) then
		SetPointer(Arrow!)
		return
	end if
	 
	// insertando documento
	insert into basc_proveedor_visitas ( proveedor, nro_item, fec_registro, fec_visita, cod_usr, obs, nombre_archivo) 
		 values ( :ls_prov, :li_nroitem, sysdate, :ld_fecvis, :gs_user, :ls_obs, :is_nombre_archivo );	
	
	if gnvo_app.of_existserror(sqlca) then
		SetPointer(Arrow!)
		return
	end if
	
	// guardando blob
	updateblob basc_proveedor_visitas
			 set documento = :lbl_doc
		  where proveedor = :ls_prov
			 and nro_item = :li_nroitem;
	
	SetPointer(Arrow!)
	
	if gnvo_app.of_existserror(sqlca) then
		return
	end if
	
	commit;
	
	MessageBox('Aviso','El documento se guardo exitosamente')
	
	sle_rutaarchivo.text = ""
	is_nombre_archivo = ''
	sle_archiobs.text = ''
	
	dw_9.retrieve(ls_prov)

else
	MessageBox('Aviso','Ocurrio un error al leer el archivo',StopSign!)
end if
end event

type sle_rutaarchivo from singlelineedit within tabpage_18
integer x = 535
integer y = 76
integer width = 1797
integer height = 80
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type tabpage_19 from userobject within tab_2
integer x = 18
integer y = 104
integer width = 2930
integer height = 1380
long backcolor = 67108864
string text = "Programacion.Visitas"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
dw_10 dw_10
end type

on tabpage_19.create
this.dw_10=create dw_10
this.Control[]={this.dw_10}
end on

on tabpage_19.destroy
destroy(this.dw_10)
end on

type dw_10 from u_dw_abc within tabpage_19
integer width = 2853
integer height = 1308
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_abc_proveedor_basc_visitasprog_grd"
end type

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
is_dwform = 'grid'	
end event

event itemchanged;call super::itemchanged;

idw_1 = this

		idw_1.GetText()
		idw_1.AcceptText()

end event

event itemerror;call super::itemerror;RETURN 1
end event

event ue_insert_pre;call super::ue_insert_pre;this.object.proveedor[al_row] = dw_master.Object.proveedor[dw_master.getrow()]
this.object.cod_usr				[al_row] = gs_user
this.object.fec_registro [al_row] = datetime(today(),now())
end event

type tabpage_22 from userobject within tab_1
integer x = 18
integer y = 16
integer width = 3090
integer height = 1616
long backcolor = 67108864
string text = "Asesor Financiero ~r~nAsignado"
long tabtextcolor = 33554432
long tabbackcolor = 12632256
long picturemaskcolor = 536870912
dw_prov_asesor_financiero dw_prov_asesor_financiero
end type

on tabpage_22.create
this.dw_prov_asesor_financiero=create dw_prov_asesor_financiero
this.Control[]={this.dw_prov_asesor_financiero}
end on

on tabpage_22.destroy
destroy(this.dw_prov_asesor_financiero)
end on

type dw_prov_asesor_financiero from u_dw_abc within tabpage_22
integer width = 2939
integer height = 1404
string dataobject = "d_abc_prov_asesor_financiero_tbl"
borderstyle borderstyle = styleraised!
end type

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
	                  // 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)



ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2





end event

event itemerror;call super::itemerror;Return 1
end event

event ue_insert_pre;call super::ue_insert_pre;DateTime ldt_hoy

ldt_hoy = gnvo_app.of_fecha_actual()

this.object.proveedor		[al_row] = dw_master.Object.proveedor[dw_master.getrow()]
this.object.flag_estado		[al_row] = '1'

this.object.fec_registro	[al_row] = ldt_hoy
this.object.fec_inicio		[al_row] = Date(ldt_hoy)
this.object.cod_usr			[al_row] = gs_user
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

event ue_display;call super::ue_display;boolean lb_ret
string ls_codigo, ls_nom_asesor, ls_zona_venta, ls_desc_zona_venta, ls_sql
choose case lower(as_columna)
	case "cod_asesor"
		ls_sql = "select t.cod_asesor as codigo_Asesor, " &
				 + "       t.apel_paterno || ' ' || t.apel_materno || ', ' || t.nombre1 || ' ' || t.nombre2 as nom_asesor, " &
				 + "       t.zona_venta as zona_venta, "  &
				 + "       zv.desc_zona_venta as desc_zona_venta " &
				 + "  from ASESOR_FINANCIERO t, " &
				 + "       vta_zona_venta    zv  " &
				 + " where t.zona_venta      = zv.zona_venta " &
				 + "   and t.flag_estado     = '1'"

		lb_ret = gnvo_app.of_lista(ls_sql, ls_codigo, ls_nom_asesor, ls_zona_venta, ls_desc_zona_venta, '2')

		if ls_codigo <> '' then
			this.object.cod_asesor			[al_row] = ls_codigo
			this.object.nom_asesor			[al_row] = ls_nom_asesor
			this.object.zona_venta			[al_row] = ls_zona_venta
			this.object.desc_zona_venta	[al_row] = ls_desc_zona_venta
			this.ii_update = 1
		end if
		
end choose
end event

event itemchanged;call super::itemchanged;String ls_nom_asesor, ls_zona_venta, ls_desc_zona_venta

this.Accepttext()

CHOOSE CASE dwo.name
	CASE 'cod_asesor'
		
		select t.apel_paterno || ' ' || t.apel_materno || ', ' || t.nombre1 || ' ' || t.nombre2,
				 t.zona_venta, zv.desc_zona_venta
			into :ls_nom_asesor, :ls_zona_venta, :ls_desc_zona_venta
			from 	ASESOR_FINANCIERO t, 
					vta_zona_venta    zv  
		where t.zona_venta      = zv.zona_venta 
		  and t.flag_estado     = '1'
		  and t.cod_asesor		= :data;

		
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQLCode = 100 then
			this.object.cod_asesor			[row] = gnvo_app.is_null
			this.object.nom_asesor			[row] = gnvo_app.is_null
			this.object.zona_venta			[row] = gnvo_app.is_null
			this.object.desc_zona_venta	[row] = gnvo_app.is_null
			
			MessageBox('Error', "Codigo de Asesor Financiero " + data + " no existe o no esta activo, por favor verifique", StopSign!)
			return 1
		end if

		
		this.object.nom_asesor			[row] = ls_nom_Asesor
		this.object.zona_venta			[row] = ls_zona_venta
		this.object.desc_zona_venta	[row] = ls_desc_zona_venta


END CHOOSE
end event

type st_1 from statictext within w_cm002_proveedores
integer width = 3707
integer height = 88
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 8388608
boolean enabled = false
string text = "Ficha de Proveedores/Clientes"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

