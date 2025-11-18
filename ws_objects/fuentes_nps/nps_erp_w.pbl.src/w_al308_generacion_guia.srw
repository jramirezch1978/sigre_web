$PBExportHeader$w_al308_generacion_guia.srw
forward
global type w_al308_generacion_guia from w_abc_mastdet
end type
type gb_1 from groupbox within w_al308_generacion_guia
end type
type dw_lista from u_dw_abc within w_al308_generacion_guia
end type
type st_1 from statictext within w_al308_generacion_guia
end type
type st_2 from statictext within w_al308_generacion_guia
end type
type st_nro from statictext within w_al308_generacion_guia
end type
type cb_buscar from commandbutton within w_al308_generacion_guia
end type
type rb_2 from radiobutton within w_al308_generacion_guia
end type
type st_ori from statictext within w_al308_generacion_guia
end type
type sle_ori from singlelineedit within w_al308_generacion_guia
end type
type rb_3 from radiobutton within w_al308_generacion_guia
end type
type sle_nro from singlelineedit within w_al308_generacion_guia
end type
type rb_1 from radiobutton within w_al308_generacion_guia
end type
end forward

global type w_al308_generacion_guia from w_abc_mastdet
integer width = 4389
integer height = 2576
string title = "[AL308] Generación de Guia"
string menuname = "m_mov_almacen"
windowstate windowstate = maximized!
event ue_anular ( )
event ue_preview ( )
event ue_cancelar ( )
gb_1 gb_1
dw_lista dw_lista
st_1 st_1
st_2 st_2
st_nro st_nro
cb_buscar cb_buscar
rb_2 rb_2
st_ori st_ori
sle_ori sle_ori
rb_3 rb_3
sle_nro sle_nro
rb_1 rb_1
end type
global w_al308_generacion_guia w_al308_generacion_guia

type variables
String 	is_doc_gr, is_xvta, is_nro_doc, is_tipo_doc, &
			is_doc_ov
Integer ii_row  // para el drog 
Datastore ids_print
end variables

forward prototypes
public function integer of_get_param ()
public function integer of_set_cliente (string as_cliente)
public function integer of_set_transportista (string as_cliente)
public subroutine of_retrieve (string as_origen, string as_nro)
public function integer of_set_status_doc ()
public function integer of_set_numera ()
public function integer of_datos_ov (string as_nro_ov, string as_almacen)
public subroutine of_modify_ds (datastore ads_data, integer ai_opcion)
public subroutine of_resizepanels ()
end prototypes

event ue_anular();Integer j

IF dw_master.getrow() = 0 then return

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
of_set_status_doc()

// Actualiza los numeros de tickets asignando la guia de remision

String ls_ori, ls_nro

ls_ori = dw_master.object.cod_origen[dw_master.getrow()]
ls_nro = dw_master.object.nro_guia[dw_master.getrow()]

// Quitar la referencia 
update salida_pesada set cod_origen = null, nro_guia = null
  where cod_origen = :ls_ori and nro_guia = :ls_nro;

end event

event ue_preview();// vista previa de guia
str_parametros lstr_rep

if dw_master.rowcount() = 0 then return

IF gnvo_app.invo_empresa.is_empresa = 'E0000004' THEN
	lstr_rep.dw1 = 'd_rpt_guia_remision_rhh'
else
	lstr_rep.dw1 = 'd_rpt_guia_remision'
end if


lstr_rep.titulo = 'Previo de Guia de remision'
lstr_rep.string1 = dw_master.object.cod_origen[dw_master.getrow()]
lstr_rep.string2 = dw_master.object.nro_guia[dw_master.getrow()]
lstr_rep.tipo 	  = '1S2S'

OpenSheetWithParm(w_rpt_preview, lstr_rep, w_main, 0, Layered!)
end event

event ue_cancelar();// Cancela operacion, limpia todo

EVENT ue_update_request()   // Verifica actualizaciones pendientes
dw_master.reset()
dw_detail.reset()
dw_lista.reset()
sle_nro.text = ''
sle_nro.SetFocus()
idw_1 = dw_master

is_Action = ''
of_set_status_doc()




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
 WHERE (cod_usr = :gnvo_app.is_user and tipo_doc = :is_doc_gr) ;

IF ll_count = 0 THEN
	Messagebox("Atencion", 'Usuario No Ha Sido definido en tipo de Documento a Visualizar')
	Return 0
END IF

return 1
end function

public function integer of_set_cliente (string as_cliente);String ls_desc_cliente, ls_almacen, ls_null
Long ll_row

SetNull(ls_null)
ll_row = dw_master.getrow()
if ll_row = 0 then return 0

ls_almacen 			= dw_master.Object.almacen			[ll_row]										
ls_desc_cliente 	= dw_master.object.nom_proveedor [ll_row]

dw_detail.Reset()				
dw_lista.retrieve(ls_almacen, as_cliente)
if dw_lista.rowcount() = 0 then
	Messagebox( "Atencion", "Cliente no tiene despachos", Exclamation!)
	dw_master.object.cliente			[ll_row] = ls_null
	dw_master.object.nom_cliente	 	[ll_row] = ls_null
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

SELECT NOM_PROVEEDOR INTO :ls_des_cliente FROM proveedor
   WHERE  PROVEEDOR = :as_cliente ;
IF SQLCA.SQLCODE <> 0 THEN
	dw_master.Object.prov_transp [ll_row] = ls_null
	Messagebox('Aviso','Debe Ingresar Un Codigo de Cliente Valido')
	RETURN 0
END IF						

dw_master.object.nom_transp[ll_row] = ls_des_cliente
Return 1
end function

public subroutine of_retrieve (string as_origen, string as_nro);Long 		ll_row
string 	ls_cod_almacen, ls_cliente, ls_serie

ll_row = dw_master.retrieve(as_origen, as_nro)
is_action = 'open'

if ll_row > 0 then		
	ls_serie = mid(as_nro, 1, 3 )
	dw_master.object.serie.text = ls_serie
	dw_detail.retrieve(as_origen, as_nro)
	
	ls_cod_almacen = dw_master.object.almacen[ll_row]
	ls_cliente		= dw_master.object.cliente [ll_row]
	
	dw_lista.retrieve(ls_cod_almacen, ls_cliente)
	of_set_status_doc( )
else
	dw_detail.Reset()
	dw_lista.Reset()
end if
dw_master.il_row = ll_row
dw_master.ii_update = 0
dw_detail.ii_update = 0
return 

end subroutine

public function integer of_set_status_doc ();Int li_estado

this.changemenu( m_mov_almacen )

// Activa todas las opciones
m_master.m_file.m_basedatos.m_insertar.enabled = f_niveles( is_niveles, 'I')  
m_master.m_file.m_basedatos.m_eliminar.enabled = f_niveles( is_niveles, 'E')  
m_master.m_file.m_basedatos.m_modificar.enabled = f_niveles( is_niveles, 'M') 
m_master.m_file.m_basedatos.m_anular.enabled = true
m_master.m_file.m_basedatos.m_abrirlista.enabled = true
m_master.m_file.m_printer.m_print1.enabled = true

if dw_master.getrow() = 0 then return 0
if is_Action = 'new' or is_action = 'edit' then
	// Activa desactiva opcion de modificacion, eliminacion	
	m_master.m_file.m_basedatos.m_eliminar.enabled = false
	m_master.m_file.m_basedatos.m_modificar.enabled = false
	m_master.m_file.m_basedatos.m_anular.enabled = false
	m_master.m_file.m_basedatos.m_abrirlista.enabled = false
	m_master.m_file.m_basedatos.m_insertar.enabled = false	
	m_master.m_file.m_printer.m_print1.enabled = false	
end if
if is_Action = 'open' then
	li_estado = Long(dw_master.object.flag_estado[dw_master.getrow()])
	Choose case li_estado
		case 0		// Anulado			
		m_master.m_file.m_basedatos.m_eliminar.enabled = false
		m_master.m_file.m_basedatos.m_modificar.enabled = false
		m_master.m_file.m_basedatos.m_anular.enabled = false	
	CASE is > 1   // Atendido con guia de remision
		m_master.m_file.m_basedatos.m_eliminar.enabled = false
		m_master.m_file.m_basedatos.m_modificar.enabled = false
		m_master.m_file.m_basedatos.m_anular.enabled = false
	end CHOOSE
end if

if is_Action = 'anu'  or is_action = 'del' then	
	m_master.m_file.m_basedatos.m_eliminar.enabled = false
	m_master.m_file.m_basedatos.m_modificar.enabled = false
	m_master.m_file.m_basedatos.m_anular.enabled = false
	m_master.m_file.m_basedatos.m_abrirlista.enabled = false
	m_master.m_file.m_basedatos.m_insertar.enabled = false	
	m_master.m_file.m_printer.m_print1.enabled = false	
end if
return 1
end function

public function integer of_set_numera ();String 	ls_nro, ls_table, ls_msg, ls_origen
Long 		ll_nro, j, ll_nro_serie, ll_count

// Numera documento
if is_action = 'new' then	
	ll_nro_serie = Integer( dw_master.object.serie.text )
	
	SELECT count(*)
  		INTO :ll_count
  	FROM num_doc_tipo
 	WHERE tipo_doc  = :is_doc_gr 
	  AND nro_serie = :ll_nro_serie
	  and cod_empresa = :gnvo_app.invo_empresa.is_empresa;
	
	if ll_count = 0 then
		ROLLBACK;
		Messagebox( "Error", "Defina la numeracion", Exclamation!)
		Return 0
	end if
	
	SELECT ultimo_numero
  		INTO :ll_nro
  	FROM num_doc_tipo
 	WHERE tipo_doc  = :is_doc_gr 
	  AND nro_serie = :ll_nro_serie 
	  and cod_empresa = :gnvo_app.invo_empresa.is_empresa for update;
	
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
	  AND nro_serie  = :ll_nro_serie
	  and cod_empresa = :gnvo_app.invo_empresa.is_empresa;	

	IF SQLCA.SQLCode <> 0 THEN 
		ls_msg = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox("SQL error", ls_msg )
		Return 0
	END IF
	
	// Asigna numero a cabecera		
	ls_nro = String(ll_nro_serie, '000')+ '-' + String(ll_nro, '000000')
	dw_master.object.nro_guia[dw_master.getrow()] =  ls_nro

else 
	ls_nro = dw_master.object.nro_guia[dw_master.getrow()] 
end if

ls_origen = dw_master.object.cod_origen[dw_master.GetRow()]

// Asigna numero a detalle
for j = 1 to dw_detail.RowCount()
	dw_detail.object.origen_guia	[j] = ls_origen
	dw_detail.object.nro_guia		[j] = ls_nro
next

return 1
end function

public function integer of_datos_ov (string as_nro_ov, string as_almacen);string 	ls_desc_almacen, ls_cliente, ls_nom_proveedor, &
			ls_motivo_traslado, ls_desc_motivo, ls_destino, &
			ls_guia_obs, ls_origen_guia, ls_nro_refer, ls_nro_vale, &
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
dw_master.object.nom_proveedor[ll_row_master] = ls_nom_proveedor
dw_master.object.destino		[ll_row_master] = ls_destino
dw_master.object.guia_obs		[ll_row_master] = ls_guia_obs

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

public subroutine of_resizepanels ();// Resize the panels according to the Vertical Line, Horizontal Line,
// BarThickness, and WindowBorder.

Long		ll_Width, ll_Height

// Validate the controls.
If Not IsValid(idrg_Top) or Not IsValid(idrg_Bottom) Then
	Return 
End If

ll_Width = This.WorkSpaceWidth()
ll_Height = This.WorkspaceHeight() //- p_pie.y

// Enforce a minimum window size
If ll_Height < idrg_Bottom.Y + 150 Then
	ll_Height = idrg_Bottom.Y + 150
End If

// Tengo que validar cual es la altura máxima para redimensionar


// Top processing
idrg_Top.Resize(ll_Width - idrg_Top.X, st_horizontal.Y - idrg_Top.Y)

					
// Bottom Procesing
st_1.Move( st_1.x, st_horizontal.Y + cii_BarThickness)
st_2.Move( st_2.x, st_horizontal.Y + cii_BarThickness)
st_2.Resize(ll_Width - st_2.x - cii_WindowBorder, st_2.height)


idrg_Bottom.Move(st_2.x, st_2.Y + st_2.height)
idrg_Bottom.Resize(ll_Width - st_2.x - cii_WindowBorder, &
							ll_Height - idrg_Bottom.Y - cii_WindowBorder)
							
dw_lista.Move(st_1.x, st_1.Y + st_1.height)
dw_lista.Resize(st_1.Width, &
							ll_Height - dw_lista.Y - cii_WindowBorder)
end subroutine

on w_al308_generacion_guia.create
int iCurrent
call super::create
if IsValid(this.MenuID) then destroy(this.MenuID)
if this.MenuName = "m_mov_almacen" then this.MenuID = create m_mov_almacen
this.gb_1=create gb_1
this.dw_lista=create dw_lista
this.st_1=create st_1
this.st_2=create st_2
this.st_nro=create st_nro
this.cb_buscar=create cb_buscar
this.rb_2=create rb_2
this.st_ori=create st_ori
this.sle_ori=create sle_ori
this.rb_3=create rb_3
this.sle_nro=create sle_nro
this.rb_1=create rb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_1
this.Control[iCurrent+2]=this.dw_lista
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.st_nro
this.Control[iCurrent+6]=this.cb_buscar
this.Control[iCurrent+7]=this.rb_2
this.Control[iCurrent+8]=this.st_ori
this.Control[iCurrent+9]=this.sle_ori
this.Control[iCurrent+10]=this.rb_3
this.Control[iCurrent+11]=this.sle_nro
this.Control[iCurrent+12]=this.rb_1
end on

on w_al308_generacion_guia.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_1)
destroy(this.dw_lista)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.st_nro)
destroy(this.cb_buscar)
destroy(this.rb_2)
destroy(this.st_ori)
destroy(this.sle_ori)
destroy(this.rb_3)
destroy(this.sle_nro)
destroy(this.rb_1)
end on

event ue_open_pre;call super::ue_open_pre;dw_lista.SettransObject(sqlca)
ii_pregunta_delete = 1   // 1 = si pregunta, 0 = no pregunta (default)
// ii_help = 101     

idw_1 = dw_master
idw_1.TriggerEvent(clicked!)
of_get_param()   // Evalua parametros

/*Inicialización de DataSotre guia*/
ids_print = Create Datastore
ids_print.DataObject = 'd_rpt_guia_remision'
ids_print.SettransObject(sqlca)

dw_master.object.p_logo.filename = gnvo_app.is_logo

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
if f_row_Processing( dw_master, "form") <> true then return

// Verifica que campos son requeridos y tengan valores
if f_row_Processing( dw_detail, "tabular") <> true then return

dw_master.of_set_flag_replicacion()
dw_detail.of_set_flag_replicacion()

if is_action = 'new' then
	if of_set_numera() = 0 then return
end if
ib_update_check = true


end event

event ue_modify;call super::ue_modify;Int li_protect

IF dw_master.getrow() = 0 then return
li_protect = integer(dw_master.Object.almacen.Protect)

IF li_protect = 0 THEN
   dw_master.Object.almacen.Protect = 1
	
END IF

if dw_detail.RowCount() > 0 then
	dw_master.Object.cliente.Protect = 1
else		
	dw_master.Object.cliente.Protect = 0
end if


is_action = 'edit'
of_set_status_doc()
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
String	ls_msg1, ls_crlf, ls_msg2

ls_crlf = char(13) + char(10)
dw_master.AcceptText()
dw_detail.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN 
	ROLLBACK USING SQLCA;
	RETURN
END IF

IF ib_log THEN
	Datastore		lds_log_m, lds_log_d
	lds_log_m = Create DataStore
	lds_log_d = Create DataStore
	lds_log_m.DataObject = 'd_log_diario_tbl'
	lds_log_d.DataObject = 'd_log_diario_tbl'
	lds_log_m.SetTransObject(SQLCA)
	lds_log_d.SetTransObject(SQLCA)
	in_log.of_create_log(dw_master, lds_log_m, is_colname_m, is_coltype_m, gnvo_app.is_user, is_tabla_m, gnvo_app.invo_empresa.is_empresa)
	in_log.of_create_log(dw_detail, lds_log_d, is_colname_d, is_coltype_d, gnvo_app.is_user, is_tabla_d, gnvo_app.invo_empresa.is_empresa)
END IF

//Open(w_log)
//lds_log.RowsCopy(1, lds_log.RowCount(),Primary!,w_log.dw_log,1,Primary!)

if is_action <> 'del' and is_action <> 'anu' then
	IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
		IF dw_master.Update() = -1 then		// Grabacion del Master
			lbo_ok = FALSE
			ls_msg1 = "Error en Grabacion Master"
			ls_msg2 = "Se ha procedido al rollback"		
		END IF
	END IF
	IF dw_detail.ii_update = 1 THEN
		IF dw_detail.Update() = -1 then		// Grabacion del detalle
			lbo_ok = FALSE
			ls_msg1 = "Error en Grabacion Detalle"
			ls_msg2 = "Se ha procedido al rollback"		
		END IF
	END IF
ELSE
	IF dw_detail.ii_update = 1 AND lbo_ok = TRUE THEN
		IF dw_detail.Update() = -1 then		// Grabacion del detalle
			lbo_ok = FALSE
			ls_msg1 = "Error en Grabacion Detalle"
			ls_msg2 = "Se ha procedido al rollback"		
		END IF
	END IF
	IF	dw_master.ii_update = 1  THEN
		IF dw_master.Update() = -1 then		// Grabacion del Master
			lbo_ok = FALSE
			ls_msg1 = "Error en Grabacion Master"
			ls_msg2 = "Se ha procedido al rollback"		
		END IF
	END IF	
END IF

IF ib_log THEN
	IF lbo_ok THEN
		IF lds_log_m.Update() = -1 THEN
			lbo_ok = FALSE
			ls_msg1 = 'Error en Base de Datos'
			ls_msg2 = 'No se pudo grabar el Log Diario, Maestro'			
		END IF
		IF lds_log_d.Update() = -1 THEN
			lbo_ok = FALSE
			ls_msg1 = 'Error en Base de Datos'
			ls_msg2 = 'No se pudo grabar el Log Diario, Detalle'			
		END IF
	END IF
	DESTROY lds_log_m
	DESTROY lds_log_d
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	is_action = 'open'
	of_set_status_doc()		
	dw_master.ii_update = 0
	dw_detail.ii_update = 0	
	dw_master.il_totdel = 0
	dw_detail.il_totdel = 0
ELSE
	ROLLBACK USING SQLCA;
	messagebox( ls_msg1, ls_msg2)
END IF
end event

event resize;call super::resize;dw_master.width   = newwidth  - dw_master.x - this.cii_windowborder
st_2.width  		= newwidth  - st_2.x - this.cii_windowborder
dw_detail.width  	= newwidth  - dw_detail.x - this.cii_windowborder
dw_detail.height 	= newheight - dw_detail.y - this.cii_windowborder
dw_lista.height 	= newheight - dw_lista.y - this.cii_windowborder
end event

event ue_print;call super::ue_print;// Impresion de guia
String ls_origen, ls_nro, ls_mensaje
Integer	li_opcion

if dw_master.rowcount() = 0 then return

if rb_1.checked then //formato general
	/*Inicialización de DataSotre guia*/
	IF gnvo_app.invo_empresa.is_empresa = 'E0000004' THEN
		ids_print.DataObject = 'd_rpt_guia_remision_rhh'
		ids_print.object.datawindow.print.Paper.Size = 9
	else
		ids_print.DataObject = 'd_rpt_guia_remision'
		ids_print.object.datawindow.print.Paper.Size = 9
	end if
	
	
	ids_print.SettransObject(sqlca)
	li_opcion = 1
end if	


ls_origen = dw_master.object.cod_origen[dw_master.getrow()]
ls_nro = dw_master.object.nro_guia[dw_master.getrow()]

// Impresion de la guia 
//printsetup()
//of_modify_ds(ids_print, li_opcion)


ids_print.Retrieve(ls_origen, ls_nro)
ids_print.print(true, true)

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

event ue_delete();// Override

Long  ll_row

IF dw_master.getrow() = 0 then return
IF ii_pregunta_delete = 1 THEN
	IF MessageBox("Eliminacion de Registro", "Esta Seguro ?", Question!, YesNo!, 2) <> 1 THEN
		RETURN
	END IF
END IF
is_action = 'del'
of_set_status_doc()

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

event ue_retrieve_list;// Abre ventana pop
str_parametros sl_param

sl_param.dw1     = 'd_lista_guias_tbl'
sl_param.titulo  = 'Guias de Remision'
sl_param.string1 = gnvo_app.invo_empresa.is_empresa
sl_param.tipo = '1S'

sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2

OpenWithParm( w_lista, sl_param)
sl_param = MESSAGE.POWEROBJECTPARM
if sl_param.titulo <> 'n' then
	of_retrieve(sl_param.field_ret[1], sl_param.field_ret[2])
END IF
end event

type p_pie from w_abc_mastdet`p_pie within w_al308_generacion_guia
end type

type ole_skin from w_abc_mastdet`ole_skin within w_al308_generacion_guia
integer x = 4146
integer y = 24
end type

type uo_h from w_abc_mastdet`uo_h within w_al308_generacion_guia
end type

type st_box from w_abc_mastdet`st_box within w_al308_generacion_guia
end type

type phl_logonps from w_abc_mastdet`phl_logonps within w_al308_generacion_guia
end type

type p_mundi from w_abc_mastdet`p_mundi within w_al308_generacion_guia
end type

type p_logo from w_abc_mastdet`p_logo within w_al308_generacion_guia
integer x = 2409
integer y = 28
end type

type st_horizontal from w_abc_mastdet`st_horizontal within w_al308_generacion_guia
integer x = 530
integer y = 1448
end type

type st_filter from w_abc_mastdet`st_filter within w_al308_generacion_guia
boolean visible = false
integer x = 571
integer y = 64
boolean enabled = false
end type

type uo_filter from w_abc_mastdet`uo_filter within w_al308_generacion_guia
boolean visible = false
integer x = 919
integer y = 44
boolean enabled = false
end type

type dw_master from w_abc_mastdet`dw_master within w_al308_generacion_guia
event ue_display ( string as_columna,  long al_row )
integer x = 494
integer y = 280
integer width = 3570
integer height = 1168
integer taborder = 50
string dataobject = "d_abc_guia_ff"
end type

event dw_master::ue_display;boolean lb_ret
string ls_codigo, ls_data, ls_sql

if lower(as_columna) <> 'serie' then
	if this.object.serie.text = '' or IsNull(this.object.serie.text) then
		MessageBox('Aviso', 'No ha indicado la serie de la guia')
		return
	end if
end if

choose case lower(as_columna)
		
	case "serie"
		if is_action = 'new' then
			ls_sql = "SELECT b.desc_tipo_doc as descripcion_tipo_doc, " &
					  + "a.nro_serie AS Numero_serie " &
					  + "FROM doc_tipo_usuario a, " &
					  + "doc_tipo b " &
					  + "WHERE a.tipo_doc = b.tipo_doc " &
					  + "AND a.cod_usr = '" + gnvo_app.is_user + "' " &
					  + "AND a.tipo_doc  = '" + is_doc_gr + "'"
					 
			lb_ret = f_lista(ls_sql, ls_data, ls_codigo, '1')
			
			if ls_codigo <> '' then
				this.object.serie.text = string(long(ls_codigo),'000')
			end if
		end if		
		
	case "almacen"
		ls_sql = "SELECT almacen AS CODIGO_almacen, " &
				  + "DESC_almacen AS DESCRIPCION_almacen " &
				  + "FROM almacen " &
				  + "where cod_origen = '" + gnvo_app.is_origen + "' " &
  				  + "order by almacen "
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.almacen			[al_row] = ls_codigo
			this.object.desc_almacen	[al_row] = ls_data
			this.ii_update = 1
		end if
	
	case "cliente"
		ls_sql = "SELECT distinct p.proveedor AS CODIGO_cliente, " &
				  + "p.nom_proveedor AS nombre_cliente, " &
				  + "p.RUC AS RUC " &
				  + "FROM proveedor p, " &
				  + "vale_mov vm, " &
				  + "articulo_mov_tipo amt " &
				  + "where vm.proveedor = p.proveedor " &
				  + "  and vm.tipo_mov = amt.tipo_mov " &
				  + "  and amt.FACTOR_SLDO_TOTAL = -1 " &
				  + "  and p.flag_estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.cliente			[al_row] = ls_codigo
			this.object.nom_cliente		[al_row] = ls_data
			of_set_cliente( ls_codigo )
			this.ii_update = 1
		end if
		
	case "prov_transp"
		ls_sql = "SELECT proveedor AS CODIGO_transportista, " &
				  + "nom_proveedor AS nombre_transportista, " &
				  + "RUC AS RUC " &
				  + "FROM proveedor " &
				  + "where flag_estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.prov_transp	[al_row] = ls_codigo
			this.object.nom_transp	[al_row] = ls_data
			this.ii_update = 1
		end if

	case "motivo_traslado"
		ls_sql = "SELECT motivo_traslado AS motivo_traslado, " &
				  + "descripcion AS descripcion_motivo_traslado " &
				  + "FROM motivo_traslado " 
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
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

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.cod_origen  [al_row] = gnvo_app.is_origen
this.object.fec_registro[al_row] = f_fecha_actual(0)
this.object.flag_estado	[al_row] = '1'
this.object.cod_usr		[al_row] = gnvo_app.is_user

dw_detail.reset()
is_Action = 'new'
of_set_status_doc()
end event

event dw_master::itemchanged;call super::itemchanged;String ls_null, ls_desc

SetNull(ls_null)
this.Accepttext()

CHOOSE CASE dwo.name				
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
			
			if of_set_cliente(data) = 0 then
				Return 1
			end if
			
			this.object.nom_cliente [row] = ls_desc
			return

	 CASE 'prov_transp'
		SELECT NOM_PROVEEDOR 
			INTO :ls_desc
		FROM proveedor
      WHERE  PROVEEDOR = :data
		  and flag_estado = '1';
		  
		IF SQLCA.SQLCODE <> 0 THEN
			dw_master.Object.prov_transp[row] = ls_null
			dw_master.object.nom_transp [row] = ls_null
			Messagebox('Aviso','Debe Ingresar Un Codigo de Cliente Valido')
			RETURN 1
		END IF		
		
		dw_master.object.nom_transp[row] = ls_desc
		
	CASE 'motivo_traslado'
		select descripcion
			into :ls_desc
		from motivo_traslado
		where motivo_traslado = :data;
		
		if SQLCA.SQLCode = 100 then
			MessageBox('Aviso', 'No existe Motivo de traslado')
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

String          ls_boton, ls_sql, ls_almacen, ls_tipo_doc, ls_nro_doc
str_parametros 	 sl_param

ls_boton = lower(dwo.name)

if ls_boton = 'b_balanza' then

	sl_param.string1 = this.object.cod_origen[row]
	sl_param.string2 = this.object.nro_guia[row]

	if IsNull(sl_param.string2) or sl_param.string2 = '' then
		MessageBox('Aviso', 'No numero de guia, debe grabar primero')
		return
	end if
	
//	openwithparm (w_al308_tickets_balanza, sl_param)
	return
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
			 + "articulo_mov      am, " &
			 + "vale_mov          vm, " &
			 + "articulo_mov_tipo amt " &
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
			 
	f_lista_3ret(ls_sql, ls_tipo_doc, ls_nro_doc, ls_almacen, '2')
	
	if ls_tipo_doc <> '' then
		of_datos_ov(ls_nro_doc, ls_almacen)
	end if
	
end if

end event

type dw_detail from w_abc_mastdet`dw_detail within w_al308_generacion_guia
event ue_mouse_move pbm_mousemove
integer x = 2871
integer y = 1556
integer width = 1202
integer height = 464
integer taborder = 70
string dragicon = "Error!"
string title = "Vales Para Generar Guia"
string dataobject = "d_abc_guia_vale_tbl"
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

event dw_detail::ue_insert;//override
RETURN 1

end event

event dw_detail::ue_lbuttonup;call super::ue_lbuttonup;Drag(Cancel!)
end event

event dw_detail::dragdrop;Double 	ld_nro_guia
String 	ls_nro_ov, ls_ref, ls_ori, ls_vale, ls_nro_guia, ls_origen_guia
Long 		ll_row, ll_i, ll_source
u_dw_abc ldw_Source

if source <> dw_lista then return
if dw_master.GetRow() = 0 then return

if dw_master.object.flag_estado [dw_master.GetRow()] <> '1' then 
	MessageBox('Aviso', 'Guia no se puede modificar')
	return
end if

ls_nro_guia = dw_master.object.nro_guia[dw_master.GetRow()]
ls_origen_guia = dw_master.object.cod_origen [dw_master.GetRow()]

ldw_source  = source

// Verifica que vales pertenezcan a una sola orden de venta		
if ldw_source.GetSelectedRow(0) > 0 then
	ll_source = ldw_source.GetSelectedRow(0)
	ls_nro_ov = ldw_source.object.nro_refer[ll_source]
	if IsNull(ls_nro_ov) then ls_nro_ov = ''
	
	For ll_i = 1 to this.rowcount()
		ls_ori  = this.Object.origen_vale[ll_i]  
		ls_vale = this.Object.nro_vale  [ll_i]   
				
		Select nro_refer 
			into :ls_ref 
		from vale_mov 
		where cod_origen = :ls_ori 
		 and nro_vale = :ls_vale;
		
		if IsNull(ls_ref) then ls_ref = ''
		
		if ls_ref <> ls_nro_ov then
			Messagebox( "Error", "Numero de orden de venta no admitido " &
					+ "~r~n OV del Mov. Alm. : " + ls_nro_ov &
					+ "~r~n OV de la Guia    : " + ls_ref)
			Return
		end if
	Next
end if

ll_source = ldw_source.getSelectedRow (0)
do while ll_source > 0 
	if This.RowCount() > 0 then
		ls_nro_ov = ldw_source.object.nro_refer[ll_source]
		if IsNull(ls_nro_ov) then ls_nro_ov = ''
		
		ls_ori  = this.Object.origen_vale[1]  
		ls_vale = this.Object.nro_vale  	[1]   
				
		Select nro_refer 
			into :ls_ref 
		from vale_mov 
		where cod_origen = :ls_ori 
		 and nro_vale = :ls_vale;
		
		if IsNull(ls_ref) then ls_ref = ''
		
		if ls_ref <> ls_nro_ov then
			Messagebox( "Error", "Numero de orden de venta no admitido " &
					+ "~r~n OV del Mov. Alm. : " + ls_nro_ov &
					+ "~r~n OV de la Guia    : " + ls_ref)
			Return
		end if		
	end if
	
	ll_row = This.InsertRow(0)
		
	This.Object.origen_vale [ll_row] = ldw_Source.Object.cod_origen [ll_source]
	This.Object.nro_vale    [ll_row] = ldw_Source.Object.nro_vale   [ll_source]
	this.object.nro_guia		[ll_row] = ls_nro_guia
	this.object.origen_guia [ll_row] = ls_origen_guia
	This.ii_update = 1
		
	// Elimina registro
	ldw_source.DeleteRow(ll_source)
	
	ll_source = ldw_source.getSelectedRow (0)

loop

end event

event dw_detail::ue_delete;//OVERRIDE
RETURN 1
end event

event dw_detail::clicked;call super::clicked;string ls_estado
setcolumn(row)
ii_row = row

if dw_master.GetRow() = 0 then return

ls_estado = dw_master.object.flag_estado[dw_master.GetRow()]

if ls_estado = '1' then
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
	source.DragIcon = "H:\Source\ICO\row.ico"
else
	source.DragIcon = "Error!"
end if

end event

event dw_detail::dragleave;call super::dragleave;//if source = this then
	source.DragIcon = "Error!"
//end if
end event

type gb_1 from groupbox within w_al308_generacion_guia
integer x = 2203
integer y = 156
integer width = 1559
integer height = 116
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
end type

type dw_lista from u_dw_abc within w_al308_generacion_guia
event ue_mouse_move pbm_mousemove
integer x = 498
integer y = 1556
integer width = 2359
integer height = 464
integer taborder = 80
boolean bringtotop = true
string title = "Vales Generados de Movimiento de Almacen"
string dataobject = "d_abc_vale_mov_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
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
integer x = 498
integer y = 1480
integer width = 2359
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
integer x = 2871
integer y = 1480
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
integer x = 992
integer y = 180
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
string text = "Numero:"
boolean focusrectangle = false
end type

type cb_buscar from commandbutton within w_al308_generacion_guia
integer x = 1815
integer y = 164
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

of_retrieve(trim(sle_ori.text), trim(sle_nro.text))
end event

type rb_2 from radiobutton within w_al308_generacion_guia
boolean visible = false
integer x = 2738
integer y = 192
integer width = 489
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean enabled = false
string text = "Formato Externo"
boolean automatic = false
end type

type st_ori from statictext within w_al308_generacion_guia
integer x = 521
integer y = 180
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
string text = "Origen:"
boolean focusrectangle = false
end type

type sle_ori from singlelineedit within w_al308_generacion_guia
integer x = 809
integer y = 168
integer width = 151
integer height = 92
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
textcase textcase = upper!
integer limit = 2
borderstyle borderstyle = stylelowered!
end type

type rb_3 from radiobutton within w_al308_generacion_guia
boolean visible = false
integer x = 3246
integer y = 192
integer width = 489
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean enabled = false
string text = "Templas - Lotes"
boolean automatic = false
end type

type sle_nro from singlelineedit within w_al308_generacion_guia
integer x = 1262
integer y = 168
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

type rb_1 from radiobutton within w_al308_generacion_guia
integer x = 2231
integer y = 192
integer width = 489
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "Formato General"
boolean checked = true
end type

