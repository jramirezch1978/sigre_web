$PBExportHeader$w_al308_generacion_guia.srw
forward
global type w_al308_generacion_guia from w_abc_mastdet
end type
type dw_lista from u_dw_abc within w_al308_generacion_guia
end type
type st_1 from statictext within w_al308_generacion_guia
end type
type st_2 from statictext within w_al308_generacion_guia
end type
type st_nro from statictext within w_al308_generacion_guia
end type
type sle_nro from singlelineedit within w_al308_generacion_guia
end type
type cb_buscar from commandbutton within w_al308_generacion_guia
end type
end forward

global type w_al308_generacion_guia from w_abc_mastdet
integer width = 3653
integer height = 2720
string title = "Generación de Guia (AL308)"
string menuname = "m_mov_almacen"
windowstate windowstate = maximized!
event ue_anular ( )
event ue_preview ( )
event ue_cancelar ( )
dw_lista dw_lista
st_1 st_1
st_2 st_2
st_nro st_nro
sle_nro sle_nro
cb_buscar cb_buscar
end type
global w_al308_generacion_guia w_al308_generacion_guia

type variables
String 				is_doc_gr, is_xvta, is_nro_doc, is_tipo_doc, is_doc_ov
Integer 				ii_row  // para el drog 
u_ds_base 			ids_print
n_cst_utilitario 	invo_utility
n_cst_wait			invo_Wait

end variables

forward prototypes
public function integer of_get_param ()
public function integer of_set_cliente (string as_cliente)
public function integer of_set_transportista (string as_cliente)
public function integer of_set_numera ()
public function integer of_datos_ov (string as_nro_ov, string as_almacen)
public subroutine of_modify_ds (datastore ads_data, integer ai_opcion)
public subroutine of_retrieve (string as_nro)
public function boolean of_status_btn_gre ()
public function boolean of_hide_btn_gre ()
public function boolean of_hide_btn ()
public subroutine of_noteditandresetupdatedw ()
public function boolean of_enviar_sunat_ose (string as_nro_guia)
end prototypes

event ue_anular;Integer j
String ls_estado

IF dw_master.getrow() = 0 then return

ls_estado 			 = dw_master.object.flag_estado		[1]

if ls_estado <> '1' then 
	MessageBox('Aviso', 'Guia NO SE PUEDE ANULA, NO SE ENCUENTRA ACTIVA', StopSign!)
	
	of_NotEditAndResetUpdateDW()
	
	return
end if

IF MessageBox("Anulacion de Registro", "Esta Seguro ?", Question!, YesNo!, 2) <> 1 THEN
	RETURN
END IF

// Anulando Cabecera
dw_master.object.flag_estado[dw_master.getrow()] = '0'
dw_master.ii_update = 1

// Eliminando Detalle
do while dw_detail.rowCount() > 0
	dw_detail.DeleteRow(0)	
loop

dw_detail.ii_update = 1
is_action = 'anu'


// Actualiza los numeros de tickets asignando la guia de remision

String ls_ori, ls_nro

ls_ori = dw_master.object.cod_origen[1]
ls_nro = dw_master.object.nro_guia	[1]

// Quitar la referencia 
update salida_pesada 
   set cod_origen = null, 
		 nro_guia = null
  where cod_origen = :ls_ori 
    and nro_guia = :ls_nro;

end event

event ue_preview();// vista previa de guia
String			ls_nro_guia, ls_serie, ls_full_nro_guia
str_parametros lstr_rep


if dw_master.rowcount() = 0 then return

ls_full_nro_guia 	= dw_master.object.full_nro_doc			[1]
ls_nro_guia 		= dw_master.object.nro_guia				[1]
ls_serie 			= left(ls_full_nro_guia, 4)

lstr_rep.dw1 = gnvo_app.almacen.of_get_datawindow(ls_serie)

lstr_rep.titulo 	= 'Previo de Guia de remision [' + ls_full_nro_guia + ']'
lstr_rep.string1 	= dw_master.object.cod_origen[dw_master.getrow()]
lstr_rep.string2 	= ls_nro_guia
lstr_rep.tipo		= '1S2S'

OpenSheetWithParm(w_rpt_preview_gr, lstr_rep, w_main, 0, Layered!)
end event

event ue_cancelar;// Cancela operacion, limpia todo

EVENT ue_update_request()   // Verifica actualizaciones pendientes
dw_master.reset()
dw_detail.reset()
dw_lista.reset()
sle_nro.text = ''
sle_nro.SetFocus()
idw_1 = dw_master

is_Action = ''





end event

public function integer of_get_param ();// Verifica que parametros en logparam, existan
Long   ll_count

Select mot_tras_desp_vnta 
	into :is_xvta 
from finparam 
where reckey = '1';		

IF SQLCA.SQLCode = 100 then
	MessageBox('Aviso', 'No ha definido parametros en FindParam')
	return 0
end if

IF SQLCA.SQLCode < 0 then
	MessageBox('Aviso', SQLCA.SQLErrText)
	return 0
end if

IF ISNULL(is_xvta) or TRIM(is_xvta) = '' THEN
	MESSAGEBOX( "ERROR", "Registre tipo despacho por venta en finparam")
	RETURN 0	   // Fallo
END IF

Select doc_gr 
	into :is_doc_gr 
from logparam 
where reckey = '1';

IF SQLCA.SQLCode = 100 then
	MessageBox('Aviso', 'No ha definido parametros en LogParam')
	return 0
end if

IF SQLCA.SQLCode < 0 then
	MessageBox('Aviso', SQLCA.SQLErrText)
	return 0
end if

IF ISNULL(is_doc_gr) or TRIM(is_doc_gr) = '' THEN
	MESSAGEBOX( "ERROR", "Registre tipo documento G/R en logparam")
	RETURN 0	   // Fallo
END IF

SELECT Count(*)
  INTO :ll_count
  FROM doc_tipo_usuario
 WHERE (cod_usr = :gs_user and tipo_doc = :is_doc_gr) ;

IF ll_count = 0 THEN
	Messagebox("Atencion", 'Usuario No Ha Sido definido en tipo de Documento a Visualizar')
	Return 0
END IF

return 1
end function

public function integer of_set_cliente (string as_cliente);String ls_desc_cliente, ls_almacen
Long ll_row

ll_row = dw_master.getrow()
if ll_row = 0 then return 0

ls_almacen 			= dw_master.Object.almacen			[ll_row]										
ls_desc_cliente 	= dw_master.object.nom_cliente 	[ll_row]

dw_detail.Reset()				
dw_lista.retrieve(ls_almacen, as_cliente)

if dw_lista.rowcount() = 0 then
	Messagebox( "Atencion", "Cliente no tiene despachos", Exclamation!)
	dw_master.object.cliente			[ll_row] = gnvo_app.is_null
	dw_master.object.nom_cliente	 	[ll_row] = gnvo_app.is_null
	dw_master.SetColumn('cliente')
	dw_master.SetFocus()
	Return 0
end if

dw_master.object.destinatario[ll_row] = TRIM(MID(ls_desc_cliente,1,40))
Return 1
end function

public function integer of_set_transportista (string as_cliente);String ls_des_cliente, ls_null
Long ll_row

ll_row = dw_master.getrow()

SELECT NOM_PROVEEDOR 
  INTO :ls_des_cliente 
  FROM proveedor
 WHERE  PROVEEDOR = :as_cliente ;
 
IF SQLCA.SQLCODE <> 0 THEN
	dw_master.Object.prov_transp [ll_row] = ls_null
	Messagebox('Aviso','Debe Ingresar Un Codigo de Cliente Valido')
	RETURN 0
END IF						

dw_master.object.nom_transportista	[ll_row] = ls_des_cliente
Return 1
end function

public function integer of_set_numera ();String 	ls_nro, ls_table, ls_msg, ls_origen, ls_serie
Long 		ll_nro, j, ll_count

if dw_master.Rowcount() = 0 then return 1


// Numera documento
if is_action = 'new' then	
	ls_serie = dw_master.object.serie[1]
	
	SELECT count(*)
  		INTO :ll_count
  	FROM num_doc_tipo
 	WHERE tipo_doc  = :is_doc_gr 
	  AND nro_serie = :ls_serie;
	  
	if SQLCA.SQLCode < 0 then
		ls_msg = SQLCA.SQLErrText
		ROLLBACK;
		Messagebox( "Error", "Ha ocurrido un error al obtener el numero de la guia. Vuelva a intentarlo. Mensaje: " + ls_msg)
		Return 0
	end if;	  
	
	if ll_count = 0 then
		ROLLBACK;
		Messagebox( "Error", "No ha definido el numerador de guias para la serie: " + ls_serie + " por favor verifique.", Exclamation!)
		Return 0
	end if
	
	SELECT ultimo_numero
  		INTO :ll_nro
  	FROM num_doc_tipo
 	WHERE tipo_doc  = :is_doc_gr 
	  AND nro_serie = :ls_serie for update;
	
	if SQLCA.SQLCode <> 0 then
		ls_msg = SQLCA.SQLErrText
		ROLLBACK;
		Messagebox( "Error", ls_msg)
		Return 0
	end if;

	// Incrementa contador
	UPDATE num_doc_tipo
		SET ultimo_numero = ultimo_numero + 1
	WHERE  tipo_doc  = :is_doc_gr
	  AND nro_serie  = :ls_serie;	

	IF SQLCA.SQLCode <> 0 THEN 
		ls_msg = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox("SQL error", ls_msg )
		Return 0
	END IF
	
	// Asigna numero a cabecera		
	ls_nro = invo_utility.of_get_nro_doc(ls_Serie, string(ll_nro))

	dw_master.object.nro_guia[dw_master.getrow()] =  ls_nro

else 
	ls_nro 		= dw_master.object.nro_guia	[dw_master.getrow()] 
end if

ls_origen = dw_master.object.cod_origen[dw_master.GetRow()]

// Asigna numero a detalle
for j = 1 to dw_detail.RowCount()
	dw_detail.object.origen_guia	[j] = ls_origen
	dw_detail.object.nro_guia		[j] = ls_nro
next

return 1
end function

public function integer of_datos_ov (string as_nro_ov, string as_almacen);string 	ls_desc_almacen, ls_cliente, ls_nom_proveedor, ls_motivo_traslado, ls_desc_motivo, &
			ls_destino, ls_guia_obs, ls_origen_guia, ls_nro_refer, ls_nro_vale, &
			ls_tipo_refer, ls_origen_vale, ls_nro_guia

Long 		ll_row_master, ll_row, ll_i

if dw_master.GetRow() = 0 then return 0

ll_row_master = dw_master.GetRow()

// Obtengo la descripcion del almacen
select desc_almacen
	into :ls_desc_almacen
from almacen
where almacen = :as_almacen;

//Obtengo los datos de la OV
select cliente, destino
	into :ls_cliente, :ls_destino
from orden_venta
where nro_ov = :as_nro_ov;

//Ahora busco el nombre del cliente
select nom_proveedor
	into :ls_nom_proveedor
from proveedor
where proveedor = :ls_cliente;

ls_guia_obs = 'ORDEN VENTA: ' + as_nro_ov

// Actualizo los datos en el datawindow master
dw_master.object.almacen		[ll_row_master] = as_almacen
dw_master.object.desc_almacen	[ll_row_master] = ls_desc_almacen
dw_master.object.cliente		[ll_row_master] = ls_cliente
dw_master.object.nom_cliente	[ll_row_master] = ls_nom_proveedor
dw_master.object.destino		[ll_row_master] = ls_destino
dw_master.object.guia_obs		[ll_row_master] = ls_guia_obs
dw_master.object.destinatario	[ll_row_master] = ls_nom_proveedor

//Obtengo el origen de la guia
ls_origen_guia = dw_master.object.cod_origen	[ll_row_master] 
ls_nro_guia 	= dw_master.object.nro_guia	[ll_row_master] 

// Ahora recupero los datos de dw_lista
dw_lista.Retrieve(as_almacen, ls_cliente)

if dw_lista.RowCount() = 0 then return 0

for ll_i = 1 to dw_lista.RowCount()
	ls_tipo_refer 	= dw_lista.object.tipo_refer	[ll_i]
	ls_nro_refer	= dw_lista.object.nro_refer  	[ll_i]
	ls_nro_vale		= dw_lista.object.nro_vale		[ll_i]
	ls_origen_vale = dw_lista.object.cod_origen	[ll_i]
	if ls_tipo_refer = is_doc_ov then
		dw_lista.DEleteRow(ll_i)
		ll_Row = dw_detail.event ue_insert()
		if ll_Row > 0 then
			dw_detail.object.origen_guia 	[ll_row] = ls_origen_guia
			dw_detail.object.nro_guia 		[ll_row] = ls_nro_guia
			dw_detail.object.origen_vale	[ll_row] = ls_origen_vale
			dw_detail.object.nro_vale		[ll_row] = ls_nro_vale
		end if
	end if
next


return 1
end function

public subroutine of_modify_ds (datastore ads_data, integer ai_opcion);string 	ls_inifile, ls_modify, ls_error
Long		ll_num_act, ll_i

ls_inifile = "i:\pb_exe\guia_remision" + string(ai_opcion) + ".ini"

if not FileExists(ls_inifile) then return

ll_num_act = Long(ProfileString(ls_inifile, "Total_lineas", 'Total', "0"))

for ll_i = 1 to ll_num_act
	ls_modify = ProfileString(ls_inifile, "Modify", 'Linea' + string(ll_i), "")
	if ls_modify <> "" then
		ls_error = ads_data.Modify(ls_modify)
		if ls_error <> '' then
			MessageBox('Error en Modify datastore', ls_Error + ' ls_modify: ' + ls_modify)
		end if
	end if
next

end subroutine

public subroutine of_retrieve (string as_nro);Long 		ll_row
string 	ls_cod_almacen, ls_cliente, ls_serie

ll_row = dw_master.retrieve( as_nro)
is_action = 'open'


if ll_row > 0 then		
	dw_detail.retrieve(as_nro)
	
	ls_cod_almacen = dw_master.object.almacen[ll_row]
	ls_cliente		= dw_master.object.cliente [ll_row]
	
	dw_lista.retrieve(ls_cod_almacen, ls_cliente)

else
	dw_detail.Reset()
	dw_lista.Reset()
end if

dw_master.il_row = ll_row

dw_master.ii_update = 0
dw_detail.ii_update = 0

dw_master.ResetUpdate()
dw_detail.ResetUpdate()

of_status_btn_gre()

return 

end subroutine

public function boolean of_status_btn_gre ();//Habilito los botones de envio de GRE
String ls_flagEstado, ls_flagEnviarGRE, ls_hasDataXML, ls_hasdataCDR, ls_hasDataPDF, ls_serie

if dw_master.getRow() = 0 then
	dw_master.object.b_envio_gre.visible = "No"
	dw_master.object.b_download.Visible = "No"

	dw_master.object.b_envio_gre.enabled = "No"
	dw_master.object.b_download.enabled = "No"
	
	MessageBox('Error', 'No hay registros en la cabecera del documento', StopSign!)

	return false
end if

ls_flagEstado 		= dw_master.object.flag_Estado 		[1]
ls_flagEnviarGRE 	= dw_master.object.FLAG_ENVIAR_GRE 	[1]
ls_serie 			= dw_master.object.serie 				[1]

ls_hasDataXML 		= dw_master.object.has_data_xml 		[1]
ls_hasdataCDR	 	= dw_master.object.has_data_cdr	 	[1]
ls_hasDataPDF 		= dw_master.object.has_data_pdf 		[1]

if ls_flagEstado = '0' then
	dw_master.object.b_envio_gre.visible = "No"
	dw_master.object.b_download.Visible = "No"

	dw_master.object.b_envio_gre.enabled = "No"
	dw_master.object.b_download.enabled = "No"
	
	return false
end if

//Si la serie de la Guia no comienza con la Letra T no estaría activo los botones de envio ni descarga
if left(ls_serie,1) <> 'T' then
	dw_master.object.b_envio_gre.visible = "No"
	dw_master.object.b_download.Visible = "No"

	dw_master.object.b_envio_gre.enabled = "No"
	dw_master.object.b_download.enabled = "No"
	
	return false
end if

if gnvo_app.almacen.is_flag_gre = '0' then

	dw_master.object.b_envio_gre.visible = "No"
	dw_master.object.b_download.Visible = "No"
	
	dw_master.object.b_envio_gre.enabled = "No"
	dw_master.object.b_download.enabled = "No"

end if

dw_master.object.b_envio_gre.visible = "Yes"
dw_master.object.b_download.Visible = "Yes"


//Si el documento ya se envio, se desactiva el boton de envio
if ls_flagEnviarGRE = '1' then
	dw_master.object.b_envio_gre.enabled = "No"
	return false
end if

if ls_hasDataXML = '1' or ls_hasdataCDR ='1' or ls_hasDataPDF = '1' then
	dw_master.object.b_download.enabled = "Yes"
else
	dw_master.object.b_download.enabled = "No"
end if

dw_master.object.b_envio_gre.enabled = "Yes"


end function

public function boolean of_hide_btn_gre ();dw_master.object.b_envio_gre.visible = "No"
dw_master.object.b_download.Visible = "No"

dw_master.object.b_envio_gre.enabled = "No"
dw_master.object.b_download.enabled = "No"

return true
	

end function

public function boolean of_hide_btn ();dw_master.object.b_envio_gre.visible = "No"
dw_master.object.b_download.Visible = "No"

dw_master.object.b_envio_gre.enabled = "No"
dw_master.object.b_download.enabled = "No"
	
return true
end function

public subroutine of_noteditandresetupdatedw ();dw_master.ii_update = 0
dw_detail.ii_update = 0	

dw_master.of_protect()
dw_detail.of_protect()

dw_master.il_totdel = 0
dw_detail.il_totdel = 0

dw_master.ResetUpdate()
dw_detail.ResetUpdate()
end subroutine

public function boolean of_enviar_sunat_ose (string as_nro_guia);Long		ll_rpta
String 	ls_flag_enviar_gre, ls_Estado


try 
	ls_Estado 				= dw_master.object.flag_estado [1]
	ls_flag_enviar_gre 	= dw_master.object.flag_enviar_gre [1]
	
	//Actualiza el flag_envio
	if ls_Estado = '0' then
		gnvo_app.of_mensaje_error( "La GUIA DE REMISIÓN ELECTRONICA " + as_nro_guia + " se encuentra anulado, no se puede enviar")
		return false
	end if

	if ls_flag_enviar_gre = '1' then
		gnvo_app.of_mensaje_error( "La GUIA DE REMISIÓN ELECTRONICA " + as_nro_guia + " YA SE ENCUENTRA ENVIADA, no se puede VOLVER enviar")
		return false
	end if


	if dw_detail.RowCount() = 0 then
		gnvo_app.of_mensaje_error( "La GUIA DE REMISIÓN ELECTRONICA " + as_nro_guia + " NO TIENE DETALLE, no se puede enviar")
		return false
	end if
	
	if dw_master.ii_update = 1 or dw_detail.ii_update = 1 then
		gnvo_app.of_mensaje_error( "Hay cambios pendientes por grabar en la GUIA DE REMISIÓN ELECTRONICA " + as_nro_guia + ", no se puede enviar")
		return false
	end if
	
	//ACtualizo el flag para enviar a EFACT
	update guia g
		set g.FLAG_ENVIAR_GRE = '1'
	where g.nro_guia	= :as_nro_guia;
	  
	if gnvo_app.of_existserror( SQLCA, "update GUIA") then
		ROLLBACK;
		return false
	end if
	
	// Genero el archivo XML para enviarlo al cliente
	if not gnvo_app.almacen.of_create_only_xml(as_nro_guia) then
		ROLLBACK;
		return false
	end if
	
	commit;
	
	//Envio por email
	if gnvo_app.of_get_parametro('ALWAYS_QUESTION_SEND_EMAIL_GRE', '0') = '1' then
		ll_rpta = MessageBox('Aviso', 'Desea Enviar por email la GUIA DE REMISION ELECTRONICA?', Information!, YesNo!, 2)
	else
		ll_rpta = 1
	end if
	
	if ll_rpta = 1 then
		yield()
		invo_wait.of_mensaje("Enviando el documento por email, espere por favor.....")
		yield()
		
		//gnvo_app.almacen.of_send_email('', as_tipo_doc, as_nro_doc)
		
		invo_wait.of_close()
		yield()
	end if			
	
	
	dw_master.object.b_envio_gre.Enabled = "No"
	
	if dw_master.getRow() > 1 then
		of_status_btn_gre()
	end if
	
	gnvo_app.of_message_error( "GUIA DE REMISIÓN ELECTRONICA ha sido activada para envío. Por favor verifique su correo en unos minutos")
	

catch ( Exception ex )
	gnvo_app.of_catch_exception(ex, 'Error en funcion of_enviar_sunat_ose')
	return false
end try

end function

on w_al308_generacion_guia.create
int iCurrent
call super::create
if this.MenuName = "m_mov_almacen" then this.MenuID = create m_mov_almacen
this.dw_lista=create dw_lista
this.st_1=create st_1
this.st_2=create st_2
this.st_nro=create st_nro
this.sle_nro=create sle_nro
this.cb_buscar=create cb_buscar
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_lista
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.st_nro
this.Control[iCurrent+5]=this.sle_nro
this.Control[iCurrent+6]=this.cb_buscar
end on

on w_al308_generacion_guia.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_lista)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.st_nro)
destroy(this.sle_nro)
destroy(this.cb_buscar)
end on

event ue_open_pre;call super::ue_open_pre;invo_Wait = create n_cst_wait

dw_lista.SettransObject(sqlca)
ii_pregunta_delete = 1   // 1 = si pregunta, 0 = no pregunta (default)
// ii_help = 101     

idw_1 = dw_master
idw_1.TriggerEvent(clicked!)
of_get_param()   // Evalua parametros

/*Inicialización de DataSotre guia*/
ids_print = Create Datastore
if gs_empresa = 'FISHOLG' then
	ids_print.DataObject = 'd_rpt_guia_remision_fisholg'
else
	ids_print.DataObject = 'd_rpt_guia_remision'
end if
ids_print.SettransObject(sqlca)

dw_master.object.p_logo.filename = gs_logo

// Obtengo el tipo de documento de la OV
select doc_ov
	into :is_doc_ov
from logparam
where reckey = '1';

if IsNull(is_doc_ov) or is_doc_ov = '' then
	MessageBox('Error', 'No ha definido el doc_ov en logparam')
	return
end if
end event

event ue_update_pre;ib_update_check = False

// Verifica que campos son requeridos y tengan valores
if gnvo_app.of_row_Processing( dw_master ) <> true then return

// Verifica que campos son requeridos y tengan valores
if gnvo_app.of_row_Processing( dw_detail ) <> true then return

dw_master.of_set_flag_replicacion()
dw_detail.of_set_flag_replicacion()

if of_set_numera() = 0 then return


ib_update_check = true


end event

event ue_modify;//Overide
Int li_protect
String ls_flag_enviar_gre, ls_estado

IF dw_master.getrow() = 0 then return

ls_flag_enviar_gre = dw_master.object.flag_enviar_gre [1]
ls_estado 			 = dw_master.object.flag_estado		[1]

if ls_flag_enviar_gre = '1' then 
	MessageBox('Aviso', 'Guia NO SE PUEDE MODIFICAR, SE ENCUENTRA ENVIADA A SUNAT / PSE', StopSign!)
	
	of_NotEditAndResetUpdateDW()
	
	return
end if

if ls_estado <> '1' then 
	MessageBox('Aviso', 'Guia NO SE PUEDE MODIFICAR, NO SE ENCUENTRA ACTIVA', StopSign!)
	
	of_NotEditAndResetUpdateDW()
	
	return
end if

dw_master.of_protect()
dw_detail.of_protect()

li_protect = integer(dw_master.Object.almacen.Protect)

IF li_protect = 0 THEN
   dw_master.Object.almacen.Protect = 1
	dw_master.Object.cliente.Protect = 1
END IF

is_action = 'edit'

end event

event ue_insert;// Override
if of_get_param() = 0 then 
	return
end if

Long  ll_row
if idw_1 = dw_master then 
	dw_master.reset()
	dw_detail.Reset()
	dw_lista.Reset()
else
	return
end if
ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN
	THIS.EVENT ue_insert_pos(ll_row)
end if
end event

event ue_update;// Override

Boolean lbo_ok = TRUE
String	ls_msg1, ls_crlf, ls_msg2, ls_nro_guia

ls_crlf = char(13) + char(10)
dw_master.AcceptText()
dw_detail.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN 
	ROLLBACK USING SQLCA;
	RETURN
END IF

IF ib_log THEN
	dw_master.of_create_log()
	dw_detail.of_create_log()
END IF

//Open(w_log)
//lds_log.RowsCopy(1, lds_log.RowCount(),Primary!,w_log.dw_log,1,Primary!)

if is_action <> 'del' and is_action <> 'anu' then
	IF	dw_master.ii_update = 1 AND lbo_ok THEN
		IF dw_master.Update(true, false) = -1 then		// Grabacion del Master
			lbo_ok = FALSE
			ls_msg1 = "Error en Grabacion DW_MASTER"
			ls_msg2 = "Se ha procedido al rollback"		
		END IF
	END IF
	IF dw_detail.ii_update = 1 and lbo_ok THEN
		IF dw_detail.Update(true, false) = -1 then		// Grabacion del detalle
			lbo_ok = FALSE
			ls_msg1 = "Error en Grabacion DW_DETAIL"
			ls_msg2 = "Se ha procedido al rollback"		
		END IF
	END IF
ELSE
	IF dw_detail.ii_update = 1 AND lbo_ok THEN
		IF dw_detail.Update(true, false) = -1 then		// Grabacion del detalle
			lbo_ok = FALSE
			ls_msg1 = "Error en Grabacion DW_DETAIL"
			ls_msg2 = "Se ha procedido al rollback"		
		END IF
	END IF
	IF	dw_master.ii_update = 1 AND lbo_ok THEN
		IF dw_master.Update(true, false) = -1 then		// Grabacion del Master
			lbo_ok = FALSE
			ls_msg1 = "Error en Grabacion DW_MASTER"
			ls_msg2 = "Se ha procedido al rollback"		
		END IF
	END IF	
END IF

IF ib_log THEN
	IF lbo_ok THEN
		dw_master.of_save_log()
		dw_detail.of_save_log()
	END IF
END IF

IF not lbo_ok THEN
	ROLLBACK USING SQLCA;
	messagebox( ls_msg1, ls_msg2)
	return
end if


COMMIT using SQLCA;

is_action = 'open'


if dw_master.getRow() > 0 then
	ls_nro_guia = dw_master.object.nro_guia [1]
	
	of_retrieve(ls_nro_guia)
	
end if

if dw_master.getRow() > 1 then
	of_status_btn_gre()
end if


of_status_btn_gre()

of_NotEditAndResetUpdateDW()

end event

event resize;call super::resize;// Override
dw_master.width   = newwidth  - dw_master.x - 10
st_2.width  		= newwidth  - st_2.x - 10
dw_detail.width  	= newwidth  - dw_detail.x - 10
dw_detail.height 	= newheight - dw_detail.y - 10
dw_lista.height 	= newheight - dw_lista.y - 10
end event

event ue_print;call super::ue_print;// Impresion de guia
String ls_origen, ls_nro, ls_mensaje, ls_serie
Integer	li_opcion

if dw_master.rowcount() = 0 then return

ls_serie = left(dw_master.object.full_nro_doc [1], 4)

//Si la serie de la Guia de Remision comienza con T entonces electronica
if left(ls_serie, 1) = 'T' then
	if UPPER(gs_empresa) = 'TRANSMARINA' then
		ids_print.DataObject = 'd_rpt_guia_rem_elect_transmarina_tbl'
	else
		ids_print.DataObject = 'd_rpt_guia_rem_electronica_tbl'
	end if
elseif UPPER(gs_empresa) = 'FISHOLG' then
	ids_print.DataObject = 'd_rpt_guia_remision_fisholg'
elseif UPPER(gs_empresa) = 'BLUEWAVE' or UPPER(gs_empresa) = 'PEZEX' then
	ids_print.DataObject = 'd_rpt_guia_remision_bw'
elseif UPPER(gs_empresa) = 'SEAFROST' or UPPER(gs_empresa) = 'DISTRIBUIDORA' then
	ids_print.DataObject = 'd_rpt_guia_remision_seafrost_tbl'
elseif UPPER(gs_empresa) = 'TRANSMARINA' then
	ids_print.DataObject = 'd_rpt_guia_remision_transmarina_tbl'
else
	ids_print.DataObject = 'd_rpt_guia_remision'
end if
ids_print.SettransObject(sqlca)
li_opcion = 1


ls_origen 	= dw_master.object.cod_origen	[1]
ls_nro 		= dw_master.object.nro_guia	[1]

// Impresion de la guia 
printsetup()
of_modify_ds(ids_print, li_opcion)

//ids_print.object.datawindow.print.Paper.Size = 1
ids_print.Retrieve(ls_origen, ls_nro)

if ids_print.of_ExistePicture("p_logo") then
	ids_print.Object.p_logo.filename = gs_logo
end if

ids_print.print()


// Actualiza fecha de impresion
Update guia 
	set fec_impresion = sysdate
 where cod_origen = :ls_origen
   and nro_guia	= :ls_nro ;
	
IF SQLCA.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Aviso', ls_mensaje)
	return
end if

Commit;
end event

event ue_delete;// Override

Long  ll_row

IF dw_master.getrow() = 0 then return
IF ii_pregunta_delete = 1 THEN
	IF MessageBox("Eliminacion de Registro", "Esta Seguro ?", Question!, YesNo!, 2) <> 1 THEN
		RETURN
	END IF
END IF
is_action = 'del'

ll_row = idw_1.Event ue_delete()

IF ll_row = 1 THEN
	THIS.Event ue_delete_list()
	THIS.Event ue_delete_pos(ll_row)	
END IF
/*
// Eliminando Detalle
do while dw_detail.rowCount() > 0
	dw_detail.DeleteRow(0)	
loop  
dw_master.ii_update = 1
dw_detail.ii_update = 1 */
end event

event ue_retrieve_list;call super::ue_retrieve_list;// Abre ventana pop
str_parametros sl_param

sl_param.dw1    = 'd_lista_guias_tbl'
sl_param.titulo = 'Guias de Remision'
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2


OpenWithParm( w_lista, sl_param)

if IsNull(MESSAGE.POWEROBJECTPARM) or not IsValid(MESSAGE.POWEROBJECTPARM) then return

sl_param = MESSAGE.POWEROBJECTPARM

if sl_param.titulo <> 'n' then
	of_retrieve(sl_param.field_ret[2])
END IF
end event

event ue_insert_pos;call super::ue_insert_pos;of_hide_btn_gre()
end event

event close;call super::close;destroy invo_Wait
end event

type dw_master from w_abc_mastdet`dw_master within w_al308_generacion_guia
event ue_display ( string as_columna,  long al_row )
integer y = 148
integer width = 3570
integer height = 1648
integer taborder = 50
string dataobject = "d_abc_guia_ff"
boolean hscrollbar = false
boolean vscrollbar = false
end type

event dw_master::ue_display;boolean 		lb_ret
string 		ls_codigo, ls_data, ls_sql, ls_mensaje, ls_CERT_INSC_MTC, ls_NRO_AUTOR_ESPECIAL, &
				ls_COD_ENTIDAD_AUTORIZADA, ls_desc_entidad_autorizada, ls_ruc_dni
Long			ll_count
str_ubigeo	lstr_ubigeo
str_prov_transporte lstr_prov_transporte

if lower(as_columna) <> 'serie' then
	if this.object.serie[1] = '' or IsNull(this.object.serie[1]) then
		MessageBox('Aviso', 'No ha indicado la serie de la guia')
		return
	end if
end if

choose case lower(as_columna)

	case "ubigeo_dst"
		lstr_ubigeo = invo_utility.of_get_ubigeo()
		
		if lstr_ubigeo.codigo <> '' then
			this.object.ubigeo_dst			[al_row] = lstr_ubigeo.codigo
			this.object.desc_ubigeo_dst	[al_row] = lstr_ubigeo.descripcion
			this.ii_update = 1
		end if

		
	case "tipo_doc_chofer"
		ls_sql = "select tipo_doc_rtps as tipo_doc_ident, " &
				 + "       desc_tipo_doc_rtps as desc_doc_ident " &
				 + "from rrhh_tipo_doc_rtps " &
				 + "where flag_estado = '1'"
				 
		lb_ret = gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, '1')
			
		if ls_codigo <> '' then
			this.object.tipo_doc_chofer	[al_row] = ls_codigo
			this.object.desc_doc_chofer	[al_row] = ls_data
			this.ii_update = 1
		end if

	case "serie"
		if is_action = 'new' then
			ls_sql = "SELECT b.desc_tipo_doc as descripcion_tipo_doc, " &
					  + "a.nro_serie AS Numero_serie " &
					  + "FROM doc_tipo_usuario a, " &
					  + "doc_tipo b " &
					  + "WHERE a.tipo_doc = b.tipo_doc " &
					  + "AND a.cod_usr = '" + gs_user + "' " &
					  + "AND a.tipo_doc  = '" + is_doc_gr + "'"
					 
			lb_ret = gnvo_app.of_lista(ls_sql, ls_data, ls_codigo, '1')
			
			if ls_codigo <> '' then
				this.object.serie[1] = invo_utility.of_get_serie(ls_codigo + '-')
			end if
		end if		
		
	case "almacen"
		
		select count(*)
			into :ll_count
		from almacen_user
		where cod_usr = :gs_user;
		
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			gnvo_app.of_mensaje_error('Error al consultar la tabla ALMACEN_USER. Mensaje: ' + ls_mensaje)
			return
		end if
		
		if ll_count = 0 then
			ls_sql = "SELECT distinct al.almacen AS CODIGO_almacen, " &
					  + "al.desc_almacen AS descripcion_almacen, " &
					  + "flag_tipo_almacen as flag_tipo_almacen " &
					  + "FROM almacen al, " &
					  + "     vale_mov vm, " &
					  + "     articulo_mov am " &
					  + "where vm.nro_vale = am.nro_vale " &
					  + "and vm.almacen = al.almacen " &
					  + "and am.flag_estado <> '0' " &
					  + "and vm.flag_estado <> '0' " &
					  + "and vm.proveedor is not null " &
					  + "and vm.tipo_mov like 'S%' " &
					  + "and al.cod_origen = '" + gs_origen + "' " &
					  + "and al.flag_estado = '1' " &
					  + "order by al.almacen " 
		else
			ls_sql = "SELECT distinct al.almacen AS CODIGO_almacen, " &
					  + "al.desc_almacen AS descripcion_almacen, " &
					  + "al.flag_tipo_almacen as flag_tipo_almacen " &
					  + "FROM almacen al, " &
					  + "     almacen_user au, " &
					  + "     vale_mov vm, " &
					  + "     articulo_mov am " &
					  + "where vm.nro_vale = am.nro_vale " &
					  + "  and vm.almacen = al.almacen " &
					  + "  and al.almacen = au.almacen " &
					  + "  and am.flag_estado <> '0' " &
					  + "  and vm.flag_estado <> '0' " &
					  + "  and vm.proveedor is not null " &
					  + "  and vm.tipo_mov like 'S%' " &
					  + "  and au.cod_usr = '" + gs_user + "'" &
					  + "  and al.cod_origen = '" + gs_origen + "' " &
					  + "  and al.flag_estado = '1' " &
					  + "  and al.flag_tipo_almacen <> 'O' " &
					  + "order by al.almacen " 
		end if					
				 
		lb_ret = gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.almacen			[al_row] = ls_codigo
			this.object.desc_almacen	[al_row] = ls_data
			this.ii_update = 1
		end if
	
	case "cliente"
		ls_sql = "SELECT distinct p.proveedor AS CODIGO_cliente, " &
				  + "p.nom_proveedor AS nombre_cliente, " &
				  + "decode(p.tipo_doc_ident, '6', p.RUC, p.nro_doc_ident) AS RUC_dni " &
				  + "FROM proveedor p, " &
				  + "     vale_mov  vm " &
				  + "where p.proveedor = vm.proveedor " &
				  + "  and vm.flag_estado = '1' " &
				  + "  and vm.tipo_mov like 'S%'" &
				  + "  and p.flag_estado = '1'"
				 
		lb_ret = gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.cliente			[al_row] = ls_codigo
			this.object.nom_cliente		[al_row] = ls_data
			of_set_cliente( ls_codigo )
			this.ii_update = 1
		end if
		
	case "prov_transp"


		lstr_prov_transporte = gnvo_app.almacen.of_get_prov_transporte( )

		if lstr_prov_transporte.b_Return then

			this.object.prov_transp					[al_row] = lstr_prov_transporte.proveedor
			this.object.nom_transportista			[al_row] = lstr_prov_transporte.nom_proveedor
			this.object.nro_placa					[al_row] = lstr_prov_transporte.nro_placa
			this.object.marca_vehiculo				[al_row] = lstr_prov_transporte.marca
			this.object.CERT_INSC_MTC 				[al_row] = lstr_prov_transporte.CERT_INSC_MTC
			this.object.NRO_AUTOR_ESPECIAL 		[al_row] = lstr_prov_transporte.NRO_AUTOR_ESPECIAL
			this.object.COD_ENTIDAD_AUTORIZADA 	[al_row] = lstr_prov_transporte.COD_ENTIDAD_AUTORIZADA
			this.object.desc_entidad_autorizada [al_row] = lstr_prov_transporte.desc_entidad_autorizada
			
			this.ii_update = 1

		end if
				 
	case "motivo_traslado"
		ls_sql = "SELECT motivo_traslado AS motivo_traslado, " &
				  + "descripcion AS descripcion_motivo_traslado " &
				  + "FROM motivo_traslado " 
				 
		lb_ret = gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.motivo_traslado		[al_row] = ls_codigo
			this.object.desc_motivo_traslado	[al_row] = ls_data
			this.ii_update = 1
		end if

end choose
end event

event dw_master::constructor;call super::constructor;is_dwform = 'form' // tabular form

ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1			// columnas de lectura de este dw

ii_dk[1] = 1 	      // columnas que se pasan al detalle
ii_dk[2] = 2
idw_mst  = dw_master
end event

event dw_master::itemerror;call super::itemerror;Return(1)
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.cod_origen  [al_row] = gs_origen
this.object.fec_registro[al_row] = gnvo_app.of_fecha_actual( )
this.object.flag_estado	[al_row] = '1'
this.object.cod_usr		[al_row] = gs_user

this.setColumn("almacen")

dw_detail.reset()
is_Action = 'new'

end event

event dw_master::itemchanged;call super::itemchanged;String 	ls_null, ls_desc, ls_CERT_INSC_MTC, ls_NRO_AUTOR_ESPECIAL, ls_COD_ENTIDAD_AUTORIZADA, &
			ls_desc_entidad_autorizada

SetNull(ls_null)
this.Accepttext()

CHOOSE CASE dwo.name				
	 CASE 'almacen'
			select desc_almacen
				into :ls_desc
			from almacen
			where almacen = :data
			  and flag_estado = '1';
			
			IF SQLCA.SQLCode = 100 then
				MessageBox('Aviso', 'Codigo de Almacen no existe o no esta activo, por favor verifique')
				return
			end if
			
			this.object.desc_almacen [row] = ls_desc
			return

	CASE 'cliente'
			select nom_proveedor
				into :ls_desc
			from proveedor
			where proveedor = :data
			  and flag_estado = '1';
			
			IF SQLCA.SQLCode = 100 then
				MessageBox('Aviso', 'Codigo de Cliente no existe o no esta activo')
				return
			end if
			
			this.object.nom_cliente [row] = ls_desc
			of_set_cliente(data)
			return

	 CASE 'prov_transp'
		SELECT 	p.NOM_PROVEEDOR, p.CERT_INSC_MTC, p.NRO_AUTOR_ESPECIAL, p.COD_ENTIDAD_AUTORIZADA, 
					d37.descripcion
			INTO 	:ls_desc, :ls_CERT_INSC_MTC, :ls_NRO_AUTOR_ESPECIAL, :ls_COD_ENTIDAD_AUTORIZADA, 
					:ls_desc_entidad_autorizada
		FROM 	proveedor  				p,
				sunat_catalogo_d37	d37
      WHERE p.COD_ENTIDAD_AUTORIZADA  = d37.codigo  (+)
		  and p.PROVEEDOR = :data
		  and p.flag_estado = '1';
		  
		IF SQLCA.SQLCODE <> 0 THEN
			dw_master.Object.prov_transp					[row] = ls_null
			dw_master.object.nom_transportista 			[row] = ls_null
			dw_master.object.CERT_INSC_MTC 				[row] = ls_null
			dw_master.object.NRO_AUTOR_ESPECIAL 		[row] = ls_null
			dw_master.object.COD_ENTIDAD_AUTORIZADA 	[row] = ls_null
			dw_master.object.desc_entidad_autorizada 	[row] = ls_null
			Messagebox('Aviso','Debe Ingresar Un Codigo de Transportista Valido', StopSign!)
			RETURN 1
		END IF		
		
		dw_master.object.nom_transp					[row] = ls_desc
		dw_master.object.CERT_INSC_MTC 				[row] = ls_CERT_INSC_MTC
		dw_master.object.NRO_AUTOR_ESPECIAL 		[row] = ls_NRO_AUTOR_ESPECIAL
		dw_master.object.COD_ENTIDAD_AUTORIZADA 	[row] = ls_COD_ENTIDAD_AUTORIZADA
		dw_master.object.desc_entidad_autorizada 	[row] = ls_desc_entidad_autorizada
		
	CASE 'motivo_traslado'
		select descripcion
			into :ls_desc
		from motivo_traslado
		where motivo_traslado = :data;
		
		if SQLCA.SQLCode = 100 then
			MessageBox('Aviso', 'No existe Motivo de traslado', STopSign!)
			return 1
		end if
		
		this.object.desc_motivo_traslado [row] = ls_desc
//		// Busca motivo de traslado por venta
//		Select mot_tras_desp_vnta into :ls_xvta from finparam where reckey = '1';		
//		if data = ls_xvta then		
//			// Forzar que ingrese nro de factura						
//			this.object.nro_doc.edit.required="yes"
//			this.object.nro_doc.protect=0
////			this.object.nro_factura.tabsequence=80	
//		ELSE
//			this.object.nro_doc.edit.required="no"			
//			this.object.nro_doc.protect=1
////			this.object.nro_factura.tabsequence=0
//			this.object.nro_doc[row] = ''
//		end if
END CHOOSE

end event

event dw_master::buttonclicked;call super::buttonclicked;// Abre ventana de ayuda 

String          	ls_boton, ls_sql, ls_almacen, ls_tipo_doc, ls_nro_doc, ls_Directorio
str_parametros		sl_param
blob					lbl_DATA_XML, lbl_DATA_CDR, lbl_DATA_PDF
Integer				li_FileNum

ls_boton = lower(dwo.name)

if ls_boton = 'b_balanza' then

	sl_param.string1 = this.object.cod_origen	[row]
	sl_param.string2 = this.object.nro_guia	[row]

	if IsNull(sl_param.string2) or sl_param.string2 = '' then
		MessageBox('Aviso', 'No numero de guia, debe grabar primero')
		return
	end if
	
	openwithparm (w_al308_tickets_balanza, sl_param)
	return
	
elseif lower(dwo.name) = 'b_envio_gre' then
	
	IF MessageBox('Confirmacion', 'Desea enviar la GUIA DE REMISION ELECTRONICA a SUNAT / PSE?', &
			Question!, YesNo!, 1) = 2 then return
	
	if row > 0 then
		ls_nro_doc = this.object.nro_guia	[1]
	
		of_enviar_sunat_ose(ls_nro_doc)
	end if
	
elseif lower(dwo.name) = 'b_download' then
		
	if GetFolder("Seleccione el Directorio para guardar los documentos digitales",ls_Directorio) <> 1 then return
	
	SELECTBLOB DATA_XML
			into :lbl_DATA_XML
	FROM GUIA g
	where g.NRO_GUIA	= :ls_nro_doc;
	
	SELECTBLOB 	DATA_CDR
		into 		:lbl_DATA_CDR
	FROM GUIA g
	where g.NRO_GUIA	= :ls_nro_doc;

	SELECTBLOB 	DATA_PDF
		into 		:lbl_DATA_PDF
	FROM GUIA g
	where g.NRO_GUIA	= :ls_nro_doc;
	  
	//Creo el archivo PDF
	if not IsNull(lbl_DATA_PDF) then
		li_FileNum = FileOpen(ls_Directorio + "\" + trim(ls_tipo_doc) +  " " + trim(ls_nro_doc) + ".PDF", &
			StreamMode!, Write!, Shared!, Replace!)

		FileWriteEx(li_FileNum, lbl_DATA_PDF)
		FileClose(li_FileNum)
	end if

	//Creo el archivo XML
	if not IsNull(lbl_DATA_XML) then
		li_FileNum = FileOpen(ls_Directorio + "\" + trim(ls_tipo_doc) +  " " + trim(ls_nro_doc) + ".XML", &
			StreamMode!, Write!, Shared!, Replace!)

		FileWriteEx(li_FileNum, lbl_DATA_XML)
		FileClose(li_FileNum)
	end if

	//Creo el archivo CDR
	if not IsNull(lbl_DATA_CDR) then
		li_FileNum = FileOpen(ls_Directorio + "\" + trim(ls_tipo_doc) +  " " + trim(ls_nro_doc) + ".CDR", &
			StreamMode!, Write!, Shared!, Replace!)

		FileWriteEx(li_FileNum, lbl_DATA_CDR)
		FileClose(li_FileNum)
	end if
	
	gnvo_app.of_mensaje_error( "Archivos generados satisfactoriamente")	

end if

if this.Describe( "cliente.Protect") = '1' then return

if ls_boton = 'b_destino' then
	sl_param.dw1 = "d_dddw_direcciones"
	sl_param.titulo = "Direcciones"
	sl_param.field_ret_i[1] = 3
	sl_param.tipo = '1S'
	sl_param.string1 = this.object.cliente[row]

	OpenWithParm( w_search, sl_param)		
	sl_param = MESSAGE.POWEROBJECTPARM
	if sl_param.titulo <> 'n' then		
		this.object.destino[row] = sl_param.field_ret[1]
		this.ii_update = 1
	END IF
	
elseif ls_boton = 'b_datos_ov' then
	
	ls_almacen = this.object.almacen[row]
	
	if IsNull(ls_almacen) then ls_almacen = ''
	
	if trim(ls_almacen) = '' then ls_almacen = '%%'
	
	ls_sql = "select distinct amp.tipo_doc as tipo_documento, " &
	 	    + "amp.nro_doc as numero_documento, " &
			 + "vm.almacen as almacen_origen " &
			 + "from articulo_mov_proy amp, " &
			 + "     articulo_mov      am, " &
			 + "     vale_mov          vm, " &
			 + "     articulo_mov_tipo amt " &
			 + "where am.nro_vale = vm.nro_Vale " &
			 + "and am.nro_mov_proy = amp.nro_mov " &
			 + "and am.origen_mov_proy = amp.cod_origen " &
			 + "and amt.tipo_mov = vm.tipo_mov " &
			 + "and vm.almacen LIKE '" + ls_almacen + "' " &
			 + "and am.flag_estado <> '0' " &
			 + "and vm.flag_estado <> '0' " &
			 + "and amt.factor_sldo_total = -1 " &
			 + "and amp.tipo_doc = (select doc_ov from logparam where reckey = '1') " &
			 + "and vm.nro_vale not in (select gv.nro_vale from guia_vale gv) " 
			 
	gnvo_app.of_lista(ls_sql, ls_tipo_doc, ls_nro_doc, ls_almacen, '2')
	
	if ls_tipo_doc <> '' then
		of_datos_ov(ls_nro_doc, ls_almacen)
	end if
	
end if

end event

event dw_master::doubleclicked;call super::doubleclicked;string 	ls_columna
long 		ll_row 

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if
end event

type dw_detail from w_abc_mastdet`dw_detail within w_al308_generacion_guia
event ue_mouse_move pbm_mousemove
integer x = 2450
integer y = 1888
integer width = 1202
integer height = 464
integer taborder = 70
string dragicon = "Error!"
string title = "Vales Para Generar Guia"
string dataobject = "d_abc_guia_vale_tbl"
borderstyle borderstyle = styleraised!
end type

event dw_detail::ue_mouse_move;if flags = 1 then
	Drag(Begin!)
end if
end event

event dw_detail::constructor;call super::constructor;ii_ss = 0

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_rk[1] = 1 	      // columnas que recibimos del master
ii_rk[2] = 2

end event

event dw_detail::itemerror;call super::itemerror;return 1
end event

event dw_detail::ue_lbuttonup;call super::ue_lbuttonup;Drag(Cancel!)
end event

event dw_detail::dragdrop;Double 	ld_nro_guia
String 	ls_ori, ls_vale, ls_nro_guia, ls_origen_guia, ls_tipo_refer, ls_nro_refer, &
			ls_tipo_refer_org, ls_nro_refer_org, ls_estado, ls_flag_enviar_gre
Long 		ll_row, ll_i, ll_source
boolean	lb_flag_dif_ov = false
u_dw_abc ldw_Source

if source <> dw_lista then return
if dw_master.GetRow() = 0 then return

ls_estado 			 = dw_master.object.flag_estado [1]
ls_flag_enviar_gre = dw_master.object.flag_enviar_gre [1]


if ls_estado <> '1' then 
	MessageBox('Aviso', 'Guia NO SE PUEDE MODIFICAR, NO SE ENCUENTRA ACTIVA', StopSign!)
	return
end if

if ls_flag_enviar_gre = '1' then 
	MessageBox('Aviso', 'Guia NO SE PUEDE MODIFICAR, YA SE ENCUENTRA ENVIADA A SUNAT', StopSign!)
	return
end if


ls_nro_guia 	= dw_master.object.nro_guia	[1]
ls_origen_guia = dw_master.object.cod_origen [1]
ldw_source  	= source

// Verifica que vales pertenezcan a una sola orden de venta		
if ldw_source.GetSelectedRow(0) > 0 then
	ll_source = ldw_source.GetSelectedRow(0)
	
	ls_tipo_refer_org = ldw_source.object.tipo_refer	[ll_source]
	ls_nro_refer_org 	= ldw_source.object.nro_refer		[ll_source]
	
	if IsNull(ls_nro_refer_org) then ls_nro_refer_org = ''
	
	For ll_i = 1 to this.rowcount()
		ls_nro_refer 	= this.Object.nro_refer  	[ll_i]  
		ls_tipo_refer	= this.Object.tipo_refer  	[ll_i]  
				
		if IsNull(ls_nro_refer) then ls_nro_refer = ''
		
		if ls_nro_refer <> ls_nro_refer_org and ls_nro_refer <> '' then
			if Messagebox( "Error", "Numero de orden de venta son diferentes, desea continuar? " &
					+ "~r~n OV del Mov. Alm. : " + ls_nro_refer_org &
					+ "~r~n OV de la Guia    : " + ls_nro_refer, Information!, Yesno!, 2) = 2 then
				Return
			else
				lb_flag_dif_ov = true
			end if
		end if
	Next
end if

ll_source = ldw_source.getSelectedRow (0)
do while ll_source > 0 
	if This.RowCount() > 0 then
		ls_tipo_refer_org = ldw_source.object.tipo_refer	[ll_source]
		ls_nro_refer_org 	= ldw_source.object.nro_refer		[ll_source]
	
		if IsNull(ls_nro_refer_org) then ls_nro_refer_org = ''
		
		ls_nro_refer 	= this.Object.nro_refer  	[1]  
		ls_tipo_refer	= this.Object.tipo_refer  	[1]  
		
		if IsNull(ls_nro_refer) then ls_nro_refer = ''
				
		if ls_nro_refer <> ls_nro_refer_org and not lb_flag_dif_ov then
			MessageBox('Error', 'Solo puede jalar los vales de salida de la misma Orden de Venta' &
										+ ls_nro_refer + ', por favor verifique', StopSign!)
			Return
		end if		
	end if
	
	ll_row = This.event ue_insert()
	if ll_row > 0 then 
		This.Object.origen_vale [ll_row] = ldw_Source.Object.cod_origen [ll_source]
		This.Object.nro_vale    [ll_row] = ldw_Source.Object.nro_vale   [ll_source]
		this.object.nro_guia		[ll_row] = ls_nro_guia
		this.object.tipo_refer 	[ll_row] = ls_tipo_refer_org
		this.object.nro_refer 	[ll_row] = ls_nro_refer_org
	
		This.ii_update = 1
	END IF

	// Elimina registro
	ldw_source.DeleteRow(ll_source)
		
	
	ll_source = ldw_source.getSelectedRow (0)

loop

end event

event dw_detail::ue_delete;//OVERRIDE
RETURN 1
end event

event dw_detail::clicked;call super::clicked;string ls_estado, ls_flag_enviar_gre

setcolumn(row)
ii_row = row

if dw_master.GetRow() = 0 then return

ls_estado 			 = dw_master.object.flag_estado		[1]
ls_flag_enviar_gre = dw_master.object.FLAG_ENVIAR_GRE	[1]



if ls_estado = '1' and ls_flag_enviar_gre = '0' then
	Drag(Begin!)
else
	Drag(End!)
end if

end event

event dw_detail::dberror;// OVERRIDE


String	ls_msg, ls_crlf, ls_prop, ls_const, ls_cadena, ls_name
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

event dw_detail::dragenter;call super::dragenter;if source = dw_lista then
	source.DragIcon = "C:\SIGRE\resources\ICO\row.ico"
else
	source.DragIcon = "Error!"
end if

end event

event dw_detail::dragleave;call super::dragleave;//if source = this then
	source.DragIcon = "Error!"
//end if
end event

event dw_detail::ue_insert_pre;call super::ue_insert_pre;this.object.serie_dam [al_row] = '1'
end event

type dw_lista from u_dw_abc within w_al308_generacion_guia
event ue_mouse_move pbm_mousemove
integer y = 1888
integer width = 2441
integer height = 464
integer taborder = 80
boolean bringtotop = true
string title = "Vales Generados de Movimiento de Almacen"
string dataobject = "d_abc_vale_mov_tbl"
boolean livescroll = false
borderstyle borderstyle = styleraised!
end type

event ue_mouse_move;if flags = 1 then
	Drag(Begin!)
end if
end event

event ue_lbuttonup;call super::ue_lbuttonup;Drag(Cancel!)
end event

event dragdrop;String  	ls_nro_vale, ls_nro_guia, ls_cod_origen, ls_tipo_ref, & 
   		ls_nro_ref, ls_tipo_mov, ls_desc_tipo_mov
Long 		ll_row, ll_source
DateTime ld_fecha
u_dw_abc ldw_Source

if dw_master.GetRow() = 0 then return

if source = dw_detail then

	if dw_master.object.flag_estado [dw_master.GetRow()] <> '1' then 
		MessageBox('Aviso', 'Guia no se puede modificar')
		return
	end if
	
	ldw_Source = source
	do while ldw_Source.getSelectedRow (0) > 0 
		ll_source = ldw_source.getSelectedRow (0)
		if ll_source > 0 then
			ll_row = This.InsertRow(0)
			ls_cod_origen = ldw_Source.Object.origen_vale[ll_source]
			ls_nro_vale   = ldw_Source.Object.nro_vale   [ll_source]
			
			This.Object.cod_origen[ll_row] = ls_cod_origen
			This.Object.nro_vale  [ll_row] = ls_nro_vale		
			
			// Halla datos
			Select 	vm.fec_registro, vm.tipo_refer, vm.nro_refer, vm.tipo_mov,
						amt.desc_tipo_mov
				into 	:ld_fecha, :ls_tipo_ref, :ls_nro_ref, :ls_tipo_mov,
						:ls_desc_tipo_mov
				from vale_mov vm,
					  articulo_mov_tipo amt
			where amt.tipo_mov = vm.tipo_mov
			  and cod_origen 	= :ls_cod_origen 
			  and nro_vale 	= :ls_nro_vale;
			
			if SQLCA.SQLCode < 0 then
				MessageBox('Aviso', SQLCA.SQLErrText)
				return
			end if
			
			
			This.Object.fec_registro  [ll_row] = ld_fecha
			This.Object.tipo_refer    [ll_row] = ls_tipo_ref
			This.Object.nro_refer     [ll_row] = ls_nro_ref
			This.Object.tipo_mov      [ll_row] = ls_tipo_mov
			This.Object.desc_tipo_mov [ll_row] = ls_desc_tipo_mov
			
			// Elimina registro
			ldw_Source.Deleterow(ll_source)
			ldw_Source.ii_update = 1
		END IF
	loop
end if
end event

event constructor;call super::constructor;is_dwform = 'tabular'
ii_ss = 0
ii_ck[1] = 1				// columnas de lectrua de este dw
ii_rk[1] = 3 	      // columnas que recibimos del master
ii_rk[2] = 8

end event

event clicked;call super::clicked;setcolumn(row)
ii_row = row

idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event dragleave;call super::dragleave;//if source = dw_lista then
	source.DragIcon = "Error!"
//end if

end event

event dragenter;call super::dragenter;if source = dw_detail then
	source.DragIcon = "H:\Source\ICO\row.ico"
else
	source.DragIcon = "Error!"
end if

end event

type st_1 from statictext within w_al308_generacion_guia
integer y = 1812
integer width = 2441
integer height = 68
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 16711680
string text = "Salidas de almacen"
alignment alignment = center!
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_2 from statictext within w_al308_generacion_guia
integer x = 2450
integer y = 1812
integer width = 1202
integer height = 68
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 16711680
string text = "Vales para generar Guia"
alignment alignment = center!
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_nro from statictext within w_al308_generacion_guia
integer y = 36
integer width = 261
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Numero:"
boolean focusrectangle = false
end type

type sle_nro from singlelineedit within w_al308_generacion_guia
integer x = 270
integer y = 24
integer width = 512
integer height = 92
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
textcase textcase = upper!
integer limit = 10
borderstyle borderstyle = stylelowered!
end type

event modified;cb_buscar.event clicked()
end event

type cb_buscar from commandbutton within w_al308_generacion_guia
integer x = 823
integer y = 20
integer width = 343
integer height = 100
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Buscar"
end type

event clicked;EVENT ue_update_request()   // Verifica actualizaciones pendientes

of_retrieve(trim(sle_nro.text))
end event

