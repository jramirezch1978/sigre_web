$PBExportHeader$w_cm301_solicitud_compra.srw
forward
global type w_cm301_solicitud_compra from w_abc_mastdet
end type
type st_1 from statictext within w_cm301_solicitud_compra
end type
type sle_ori from singlelineedit within w_cm301_solicitud_compra
end type
type st_2 from statictext within w_cm301_solicitud_compra
end type
type sle_nro from singlelineedit within w_cm301_solicitud_compra
end type
type cb_1 from commandbutton within w_cm301_solicitud_compra
end type
end forward

global type w_cm301_solicitud_compra from w_abc_mastdet
integer width = 3520
integer height = 1792
string title = "Solicitud de Compras [CM301]"
string menuname = "m_mtto_impresion"
boolean controlmenu = false
string icon = "H:\Source\Ico\Travel.ico"
event ue_anular ( )
event ue_cancelar ( )
st_1 st_1
sle_ori sle_ori
st_2 st_2
sle_nro sle_nro
cb_1 cb_1
end type
global w_cm301_solicitud_compra w_cm301_solicitud_compra

type variables
String 	is_doc_sc, is_soles
decimal {3} idc_tipo_cambio
DateTime	id_fecha_proc

end variables

forward prototypes
public function integer of_verifica_dup (string as_cod_art)
public function integer of_set_cmp_directa (long an_ano, string as_cencos, string as_cnta_prsp)
public function integer of_set_status_doc (datawindow idw)
public function integer of_get_fecha2 (date ad_fecha)
public function integer of_set_numera ()
public subroutine of_retrieve (string as_origen, string as_nro)
public function integer of_articulo_restriccion (string as_cod_art, string as_tipo_doc, string as_cencos)
end prototypes

event ue_anular();Long j

IF dw_master.RowCount() = 0 then return
IF MessageBox("Anulacion de Registro", "Esta Seguro ?", Question!, YesNo!, 2) <> 1 THEN
	RETURN
END IF 

// Anulando Cabecera
dw_master.Object.flag_estado[dw_master.GetRow()] = '0'
dw_master.ii_update = 1		// Activa indicar para grabacion

// Anulando Detalle
For j = 1 to dw_detail.RowCount()
	dw_detail.object.flag_estado[j] = '0'
	dw_detail.object.cant_proyect[j] = 0
	dw_detail.object.precio_unit[j]  = 0
Next
dw_detail.ii_update = 1		// Activa indicar para grabacion
is_action = 'anu'
of_set_status_doc(dw_master)
end event

event ue_cancelar();// Cancela operacion, limpia todo

EVENT ue_update_request()   // Verifica actualizaciones pendientes
dw_master.reset()
dw_detail.reset()
sle_ori.text = ''
sle_nro.text = ''
sle_ori.SetFocus()
idw_1 = dw_master
dw_master.il_row = 0

is_Action = ''
of_set_status_doc(dw_master)

end event

public function integer of_verifica_dup (string as_cod_art);// Verifica codigo duplicados

long ll_find = 1, ll_end, ll_vec = 0
String ls_cad

ls_cad = "cod_art = '" + as_cod_Art + "'"
ll_vec = 0
ll_end = dw_detail.RowCount()

ll_find = dw_detail.Find(ls_cad, ll_find, ll_end)
DO WHILE ll_find > 0
	ll_vec ++
	// Collect found row
	ll_find++
	// Prevent endless loop
	IF ll_find > ll_end THEN EXIT
	ll_find = dw_detail.Find(ls_cad, ll_find, ll_end)
LOOP			

if ll_vec > 1 then 
	messagebox( "Error", "Codigo de articulo ya existe", Exclamation!)
	return 0	
end if
return 1
end function

public function integer of_set_cmp_directa (long an_ano, string as_cencos, string as_cnta_prsp);/*
   Funcion que valida la partida presupuestal sea de compra
	directa	
	
	0 = Fallo
	1 = Ok
*/
String ls_flag
Long ll_row

if ISNULL( as_cencos) OR TRIM( as_cencos) = '' THEN RETURN 0
if ISNULL( as_cnta_prsp) OR TRIM( as_cnta_prsp) = '' THEN RETURN 0

ll_row = dw_detail.getrow()

	Select flag_cmp_directa into :ls_flag from presupuesto_partida
 		Where ano = :an_ano and cencos = :as_cencos and 
  		cnta_prsp = :as_cnta_prsp;
	
	IF sqlca.sqlcode = 100 THEN    // no lo encontro
		Messagebox( "Error", "Partida presupuestal no existe", Exclamation!)
		dw_detail.object.partida_presup[ll_row] = ''
		return 0
	END IF
	if ls_flag = '0'  OR isnull( ls_flag) then
		Messagebox( "Atencion", "cuenta presupuestal no válida para hacer solicitudes", exclamation!)
		dw_detail.object.partida_presup[ll_row] = ''
		return 0
	end if

return 1
end function

public function integer of_set_status_doc (datawindow idw);this.changemenu(m_mtto_impresion)

Int li_estado

if is_flag_insertar = '1' then
	m_master.m_file.m_basedatos.m_insertar.enabled = true
else
	m_master.m_file.m_basedatos.m_insertar.enabled = false
end if

if is_flag_eliminar = '1' then
	m_master.m_file.m_basedatos.m_eliminar.enabled = true
else
	m_master.m_file.m_basedatos.m_eliminar.enabled = false
end if

if is_flag_modificar = '1' then
	m_master.m_file.m_basedatos.m_modificar.enabled = true
else
	m_master.m_file.m_basedatos.m_modificar.enabled = false
end if

if is_flag_anular = '1' then
	m_master.m_file.m_basedatos.m_anular.enabled = true
else
	m_master.m_file.m_basedatos.m_anular.enabled = false
end if

if is_flag_cerrar = '1' then
	m_master.m_file.m_basedatos.m_cerrar.enabled = true
else
	m_master.m_file.m_basedatos.m_cerrar.enabled = false
end if

if is_flag_consultar = '1' then
	m_master.m_file.m_basedatos.m_abrirlista.enabled = true
else
	m_master.m_file.m_basedatos.m_abrirlista.enabled = false
end if

m_master.m_file.m_printer.m_print1.enabled = true

if dw_master.getrow() = 0 then return 0
if is_Action = 'new' then
	m_master.m_file.m_basedatos.m_eliminar.enabled = false
	m_master.m_file.m_basedatos.m_modificar.enabled = false
	m_master.m_file.m_basedatos.m_anular.enabled = false
	m_master.m_file.m_basedatos.m_abrirlista.enabled = false
	m_master.m_file.m_printer.m_print1.enabled = false		
	// Activa desactiva opcion de modificacion, eliminacion	
	if idw = dw_master then		// Si es master, tiene que estar activo para adicionar otro documento
		m_master.m_file.m_basedatos.m_insertar.enabled = false
	else
		m_master.m_file.m_basedatos.m_insertar.enabled = true
		if is_flag_eliminar = '1' then
			m_master.m_file.m_basedatos.m_eliminar.enabled = true
		else
			m_master.m_file.m_basedatos.m_eliminar.enabled = false
		end if
	end if
end if

if is_Action = 'open' then
	li_estado = Long( dw_master.object.flag_estado[dw_master.getrow()])

	Choose case li_estado
		case 0		// Anulado	
		m_master.m_file.m_basedatos.m_eliminar.enabled = false
		m_master.m_file.m_basedatos.m_modificar.enabled = false
		m_master.m_file.m_basedatos.m_anular.enabled = false
		if idw = dw_detail then	   		
		   m_master.m_file.m_basedatos.m_insertar.enabled = false
	   end if
	CASE 2,4,5   // Aprobado, Atendido parcial, total
		m_master.m_file.m_basedatos.m_eliminar.enabled = false
		m_master.m_file.m_basedatos.m_modificar.enabled = false
		m_master.m_file.m_basedatos.m_anular.enabled = false
		if idw = dw_master then		// Si es master, tiene que estar activo para adicionar otro documento			
   		if is_flag_insertar = '1' then
				m_master.m_file.m_basedatos.m_insertar.enabled = true
			else
				m_master.m_file.m_basedatos.m_insertar.enabled = false
			end if
	   else			
		   m_master.m_file.m_basedatos.m_insertar.enabled = false
	   end if
	end CHOOSE
end if

if is_Action = 'anu' or is_Action = 'edit' or is_Action = 'del' then	
	m_master.m_file.m_basedatos.m_eliminar.enabled = false
	m_master.m_file.m_basedatos.m_modificar.enabled = false
	m_master.m_file.m_basedatos.m_anular.enabled = false
	m_master.m_file.m_basedatos.m_abrirlista.enabled = false
	m_master.m_file.m_basedatos.m_insertar.enabled = false	
	m_master.m_file.m_printer.m_print1.enabled = false
end if

return 1
end function

public function integer of_get_fecha2 (date ad_fecha);if String( ad_fecha, 'dd/mm/yyyy') < string( today(), 'dd/mm/yyyy') then
	dw_detail.SetColumn( 'fec_requerida')
	dw_detail.SetFocus()
	return 1
else
	return 0
end if
end function

public function integer of_set_numera ();// Numera documento
Long j
String  ls_next_nro

if dw_master.getrow() = 0 then return 1

if is_action = 'new' then
	ls_next_nro = f_numera_documento('num_sol_ord_comp',9)
	dw_master.object.nro_sol_comp[dw_master.getrow()] = ls_next_nro
else
	ls_next_nro = dw_master.object.nro_sol_comp[dw_master.getrow()] 
end if
// Asigna numero a detalle
for j = 1 to dw_detail.RowCount()
	dw_detail.object.nro_sol_comp[j] = ls_next_nro
next

return 1
end function

public subroutine of_retrieve (string as_origen, string as_nro);Long ll_row

ll_row = dw_master.retrieve(as_origen, as_nro)
is_action = 'open'

dw_detail.reset()

if ll_row > 0 then		
	dw_detail.retrieve( as_origen, as_nro)
	of_set_status_doc( dw_master )
end if

dw_master.il_row = ll_row
dw_master.object.p_logo.filename = gs_logo

return 
end subroutine

public function integer of_articulo_restriccion (string as_cod_art, string as_tipo_doc, string as_cencos);// Verifica que articulo no este restringido
Long ln_count

Select count(cod_art) 
	into :ln_count 
from articulo_doc_restriccion 
where cod_Art 	= :as_cod_art
  and tipo_doc = :as_tipo_doc 
  and cencos 	= :as_cencos;
  
if ln_count > 0 then
	messagebox( "Atencion", "Codigo " + as_cod_Art + " esta restringido " &
		+ "~r~nTipo Doc   : " + as_tipo_doc &
		+ "~r~nCent. Costo: " + as_cencos , exclamation!)
	return 0
end if

return 1
end function

event ue_open_pre;call super::ue_open_pre;ii_pregunta_delete = 1   // 1 = si pregunta, 0 = no pregunta (default)
// ii_help = 101

// busca tipo doc. sol. compra
Select doc_sc, cod_soles
	into :is_doc_sc, :is_soles
from logparam 
where reckey = '1';  

IF SQLCA.SQLCode = 100 then
	MessageBox('Aviso', 'No ha definido los parametros en LogParam')
	return
end if

if IsNull(is_doc_sc) or is_doc_sc = '' then
	MessageBox('Aviso', 'No ha definido el Tipo de Documento Solicitud de Compra', Exclamation!)
	return
end if

if IsNull(is_soles) or is_soles = '' then
	MessageBox('Aviso', 'No ha definido Moneda Soles en Logparam', Exclamation!)
	return
end if

dw_master.object.p_logo.filename = gs_logo
end event

event ue_update_pre;// Verifica que campos son requeridos y tengan valores
ib_update_check = False
if f_row_Processing( dw_master, "form") <> true then return

// Verifica que campos son requeridos y tengan valores
if f_row_Processing( dw_detail, "tabular") <> true then return

if dw_detail.rowcount() = 0 then 
	messagebox( "Atencion", "No se grabara el documento, falta detalle")
	return
end if

//// evalua partida presupuestal
Long j, ln_ano
String ls_cod_art, ls_cencos
//String ls_cencos, ls_cnta_prsp
//
ls_cencos    = dw_master.object.cencos[dw_master.getrow()]
//ln_ano		 = YEAR( DATE(dw_master.object.fec_registro[dw_master.getrow()]))
//
For j = 1 to dw_detail.rowcount()
//	ls_cnta_prsp = dw_detail.object.partida_presup[j]
//	if of_set_cmp_directa(ln_ano, ls_cencos, ls_cnta_prsp) = 0 then
//		return 
//	END IF
	ls_cod_art = dw_detail.object.cod_art[j]	
   if of_articulo_restriccion( ls_cod_Art, is_doc_sc, ls_cencos) = 0 then return	   
Next

// Numeracion de documento
if of_set_numera() = 0 then return	

if is_action <> 'anu' then
	dw_master.of_protect()         			// bloquear modificaciones 
	dw_detail.of_protect()
end if
ib_update_check = true

dw_master.of_set_flag_replicacion()
dw_detail.of_set_flag_replicacion()
end event

on w_cm301_solicitud_compra.create
int iCurrent
call super::create
if this.MenuName = "m_mtto_impresion" then this.MenuID = create m_mtto_impresion
this.st_1=create st_1
this.sle_ori=create sle_ori
this.st_2=create st_2
this.sle_nro=create sle_nro
this.cb_1=create cb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.sle_ori
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.sle_nro
this.Control[iCurrent+5]=this.cb_1
end on

on w_cm301_solicitud_compra.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.sle_ori)
destroy(this.st_2)
destroy(this.sle_nro)
destroy(this.cb_1)
end on

event ue_print;call super::ue_print;str_parametros lstr_rep

lstr_rep.string1 = dw_master.object.cod_origen[dw_master.getrow()]
lstr_rep.string2 = dw_master.object.nro_sol_comp[dw_master.getrow()]
OpenSheetWithParm(w_cm301_solicitud_compra_frm, lstr_rep, This, 2, layered!)

end event

event ue_list_open;// Abre ventana pop
str_parametros sl_param

sl_param.dw1 = "d_dddw_solicitud_compra_all_tbl"
sl_param.titulo = "Solicitud de compra"
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2

OpenWithParm( w_lista, sl_param)
sl_param = MESSAGE.POWEROBJECTPARM
if sl_param.titulo <> 'n' then	
	of_retrieve(sl_param.field_ret[1], sl_param.field_ret[2])
END IF
end event

event ue_update();// Override
Boolean lbo_ok = TRUE
String	ls_crlf, ls_msg1, ls_msg2

ls_crlf = char(13) + char(10)
dw_master.AcceptText()
dw_detail.AcceptText()

IF dw_master.RowCount() = 0 then return

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN 
	ROLLBACK USING SQLCA;
	RETURN
end if

IF ib_log THEN
	dw_master.of_create_log()
	dw_detail.of_create_log()
END IF

//Open(w_log)
//lds_log.RowsCopy(1, lds_log.RowCount(),Primary!,w_log.dw_log,1,Primary!)


IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_master.Update(true, false) = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		ls_msg1 = "Se ha procedido al rollback"
		ls_msg2 = "Error en Grabacion Master"		
	END IF
END IF

IF dw_detail.ii_update = 1 THEN
	IF dw_detail.Update(true, false) = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		ls_msg1 = "Se ha procedido al rollback"
		ls_msg2 = "Error en Grabacion Detalle"	
	END IF
END IF

IF ib_log THEN
	lbo_ok = dw_master.of_save_log()
	lbo_ok = dw_detail.of_save_log()
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0
	dw_detail.ii_update = 0
	
	dw_master.il_totdel = 0
	dw_detail.il_totdel = 0
	
	dw_master.ResetUpdate()
	dw_detail.ResetUpdate()
	
	is_action = 'open' 
	of_set_status_doc( dw_master )		// Activa/desactiva opciones de menu, segun flag_estado	
	
	f_mensaje("Cambios grabados satisfactoriamente", "")
ELSE
	ROLLBACK USING SQLCA;
	messagebox(ls_msg1, ls_msg2, StopSign!)
END IF
end event

event ue_delete();// Override

IF dw_master.RowCount() = 0 then return

if idw_1 = dw_master then 
	Messagebox( "Operacion no válida", "No se permite Eliminar este documento")	
	return 
end if

if dw_detail.rowcount() = 1 then
	messagebox( "Operacion no válida", "No se permite dejar el documento vacio")
	return 
end if

Long  ll_row

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

IF is_action <> 'new' then	
	is_action = 'del'
	of_Set_Status_doc(dw_detail)
end if

end event

event ue_modify();call super::ue_modify;int li_protect

li_protect = integer(dw_detail.Object.cod_Art.Protect)
IF li_protect = 0 THEN
	dw_detail.Object.cod_Art.Protect = 1
END IF

is_action = 'edit'

of_set_status_doc( dw_master)
end event

event ue_insert;call super::ue_insert;Long	ll_mov_atrazados
n_cst_diaz_retrazo lnvo_amp_retr

id_fecha_proc = f_fecha_actual() 

if idw_1 = dw_master then
	// Obtengo los movimientos proyectados atrazados 
	// Solo por el tipo de documento
	// Los dias de retrazo los toma de LogParam y el usuario de gs_user
	lnvo_amp_retr = CREATE n_cst_diaz_retrazo
	ll_mov_atrazados = lnvo_amp_retr.of_amp_retrazados( is_doc_sc )
	DESTROY lnvo_amp_retr
	
	if ll_mov_atrazados > 0 then
		MessageBox('Aviso', 'Tiene pendientes ' + string(ll_mov_atrazados) &
			+ ' movimientos Proyectados en Solicitud de Compra')
		return
	end if
end if

end event

type dw_master from w_abc_mastdet`dw_master within w_cm301_solicitud_compra
event ue_display ( string as_columna,  long al_row )
integer x = 23
integer y = 124
integer width = 3109
integer height = 516
integer taborder = 40
string dataobject = "d_abc_solicitud_compra_ff"
end type

event dw_master::ue_display(string as_columna, long al_row);boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql
long 		ll_count
Integer	li_ano

str_parametros 		sl_param


choose case lower(as_columna)
		
	case "cod_moneda"
		
		ls_sql = "SELECT COD_MONEDA AS CODIGO, " &
				 + "DESCRIPCION AS DESCRIPCION_MONEDA " &
				 + "FROM MONEDA " 
				 
		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.cod_moneda	[al_row] = ls_codigo
			this.object.desc_moneda	[al_row] = ls_data
		
			this.ii_update = 1
		end if

	CASE 'cencos'			
		
		li_ano 	 		= Year( Date( this.object.fec_registro	[al_row] ) )
		if li_ano = 0 or IsNull(li_ano) then li_ano = Year(Today())
		
		ls_sql = "select distinct cc.cencos as codi_cencos, " &
				 + "cc.desc_cencos as descripcion_cencos " &
				 + "from centros_costo cc, " & 
				 + "presupuesto_partida pp " &
				 + "where pp.cencos = cc.cencos " &
				 + "and cc.flag_estado = '1' " &
				 + "and pp.ano = " + string(li_ano) &
				 + "and NVL(pp.flag_cmp_directa,'') in ('0', '2') " &
				 + "and pp.flag_estado <> '0' " &
				 + "order by cc.desc_cencos"
				 
		f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo = '' then return
		
		this.object.cencos		[al_row] = ls_codigo
		this.object.desc_cencos	[al_row] = ls_data
		this.ii_update = 1

end choose
end event

event dw_master::constructor;call super::constructor;is_dwform = 'form' // tabular form

ii_ck[1] = 1				// columnas de lectura de este dw
ii_dk[1] = 1 	      // columnas que se pasan al detalle
ii_dk[2] = 2
ii_ss = 1 
end event

event dw_master::itemerror;call super::itemerror;return (1)   // Fuerza a salir sin mostrar mensaje de error
end event

event dw_master::ue_insert_pre;// Asigna valores
this.object.fec_registro[al_row] = Today()
this.object.cod_origen	[al_row] = gs_origen
this.object.flag_estado	[al_row] = '1'		// Activo
this.object.cod_usr		[al_row] = gs_user

is_action = 'new'   // Nuevo documento
of_set_status_doc( dw_master)

idc_tipo_cambio = f_get_tipo_cambio(Today())
end event

event dw_master::buttonclicked;call super::buttonclicked;// Abre ventana de ayuda
String 	ls_name, ls_prot
str_parametros sl_param


of_set_status_doc(idw_1)   // Evalua status de documento

if row <= 0 then return 1

ls_name = lower(dwo.name)
ls_prot = this.Describe(  "cencos.Protect" )
if ls_prot = '1' then return 


CHOOSE CASE dwo.name 
	CASE 'b_pto'
		sl_param.string1 = this.object.cod_origen		[this.getrow()]
		sl_param.string2 = this.object.nro_sol_comp	[this.getrow()]
		sl_param.string3 = is_doc_sc
		sl_param.long1 = 3
		
		OPenwithParm( w_cns_proyeccion_pto_doc, sl_param)
		
END CHOOSE
end event

event dw_master::itemchanged;call super::itemchanged;String ls_estado, ls_null, ls_codigo, ls_data
This.AcceptText()

if row <= 0 then return

SetNull( ls_null )

IF dwo.name = 'cencos' then
	ls_codigo = this.object.cencos[row]
	
	// Verifica que codigo exista
	Select desc_cencos, flag_estado
		into :ls_data, :ls_estado
	from centros_costo
	Where cencos = :ls_codigo;
	
	if IsNull(ls_data) or ls_data = '' then
		Messagebox( "Error", "Centro de costo no existe", Exclamation!)
		this.object.cencos		[row] = ls_null
		this.object.desc_cencos	[row] = ls_null
		return 1
	end if
	
   if ls_estado <> '1' then
		Messagebox( "Error", "Centro de costo esta desactivado", Exclamation!)		
		this.object.cencos		[row] = ls_null
		this.object.desc_cencos	[row] = ls_null
		Return 1
	end if
	
	this.object.desc_cencos[row] = ls_data
	
elseif dwo.name = 'cod_moneda' then
	
	ls_codigo = this.object.cod_moneda[row]
	
	select descripcion
		into :ls_data
	from moneda
	where cod_moneda = :ls_codigo;
	
	if IsNull(ls_data) or ls_data = '' then
		Messagebox( "Error", "Codigo de Moneda no existe", Exclamation!)
		this.object.cod_moneda	[row] = ls_null
		this.object.desc_moneda	[row] = ls_null
		return 1
	end if
	
	this.object.desc_moneda[row] = ls_data
	
END IF
end event

event dw_master::doubleclicked;call super::doubleclicked;string ls_columna
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

type dw_detail from w_abc_mastdet`dw_detail within w_cm301_solicitud_compra
integer x = 14
integer y = 644
integer width = 3429
integer height = 952
integer taborder = 50
string dataobject = "d_abc_solicitud_compra_det_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
end type

event dw_detail::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
ii_rk[1] = 1 	      // columnas que recibimos del master
ii_rk[2] = 2

end event

event dw_detail::itemerror;call super::itemerror;return (1)
end event

event dw_detail::ue_insert_pre;call super::ue_insert_pre;
this.object.fec_registro	[al_row] = gd_Fecha
this.object.fec_requerida	[al_row] = gd_Fecha
this.object.flag_estado		[al_row] = '1'

This.SetColumn( "cod_art")
This.SetFocus()

of_set_status_doc( dw_detail)
end event

event dw_detail::itemchanged;call super::itemchanged;String 	ls_desc_art, ls_und, ls_cencos, &
   		ls_cnta_prsp, ls_null, ls_cod_art
Decimal 	ln_precio, ln_cambio, ldc_importe
Integer 	li_dias, ln_ano
Date 		ld_fecha, ld_fec_req
Long		ll_row_mas, ll_count, ll_ano, ll_mes

ll_row_mas = dw_master.GetRow()
if ll_row_mas <= 0 then return

This.AcceptText()

ld_fecha = DATE(dw_master.object.fec_registro[ll_row_mas])
ls_cencos = dw_master.object.cencos[ll_row_mas]

if IsNull(ls_cencos) or ls_cencos = '' then
	MessageBox('Aviso', 'No ha indicado el Centro de Costos en la cabecera de la solicitud', Exclamation!)
	dw_master.SetColumn('cencos')
	return 1
end if

SetNull(ls_null)

IF dwo.name = "cod_art" then		
	
	ls_cod_art = this.object.cod_art[row]	
	
	if of_verifica_dup( ls_cod_art ) = 0 then // verifica codigos duplicados
		this.object.cod_art	[row] = ls_null
		this.object.desc_art	[row] = ls_null
		this.object.und		[row] = ls_null
		return 1
	end if

	if gnvo_app.almacen.of_articulo_inventariable( ls_cod_art ) <> 1 then 
		this.object.cod_art	[row] = ls_null
		this.object.desc_art	[row] = ls_null
		this.object.und		[row] = ls_null
		return 1
	end if	
	
	Select desc_art, und, costo_ult_compra, dias_reposicion 
	  into :ls_desc_art, :ls_und, :ln_precio, :li_dias 
  	from articulo 
   Where cod_Art = :ls_cod_art;

	if is_action = 'new' then
		// Segun tipo de moneda, asigna precio ult. compra	
		if dw_master.object.cod_moneda[ll_row_mas] = is_soles then			
			// Busca ult. tipo de cambio
			Select cmp_dol_prom 
				into :ln_cambio 
			from calendario 
			where fecha = :ld_fecha;
			
			IF ln_cambio = 0 or isnull( ln_cambio) then
				Messagebox( "Atencion", "no existe tipo de cambio para hacer conversion~r" + &
				    "Su precio en US$ es: " + string( ln_precio), Exclamation! )
			   ln_precio = 0
			else
			  ln_precio = ln_precio * ln_cambio
		   end if
		end if
		this.object.precio_unit[row] = ln_precio
	end if
	
	this.object.desc_Art			[row] = ls_desc_art
	this.object.und				[row] = ls_und
	this.object.dias_reposicion[row] = li_dias	
	
elseif dwo.name = "partida_presup" then
	
	//Verifica que exista dato ingresado
	
	Select count( cnta_prsp) 
		into :ll_count 
	from presupuesto_cuenta 
	where cnta_prsp = :data;
	
	if ll_count = 0 then
		Messagebox( "Error", "Cuenta presupuestal no existe", Exclamation!)		
		this.object.partida_presup[row] = ls_null
		Return 1
	end if

end if

// Evalua presupuesto.	
ldc_importe = dec(this.object.precio_unit[row]) * Dec(this.object.cant_proyect[row])
if dw_master.object.cod_moneda[dw_master.GetRow()] = is_soles then
	if idc_tipo_cambio = 0 then return
	ldc_importe = ldc_importe / idc_tipo_cambio
end if

ls_cencos = trim(dw_master.object.cencos[dw_master.GetRow()])
If IsNull(ls_cencos) then ls_cencos = ''

ls_cnta_prsp = trim(this.object.partida_presup[row])
If IsNull(ls_cnta_prsp) then ls_cnta_prsp = ''

ll_mes = Month( DAte( this.object.fec_requerida[row]) )
ll_ano = Year( Date(this.object.fec_requerida [row]) )

if ls_cencos = '' or ls_cnta_prsp = '' then return

// Verifico que la partida presupuestal sea de compra directa
if f_prsp_cmp_directa( ls_cencos, ls_cnta_prsp, ll_ano) = '1' then
	MessageBox('Aviso', 'La Partida Presupuestal solo es para gastos directos')
	dw_detail.object.partida_presup		[row] = ls_null
	dw_detail.SetColumn( "cnta_prsp")
	RETURN 1
end if
	
IF f_afecta_presup(ll_mes, ll_ano, ls_cencos, ls_cnta_prsp, ldc_importe) = 0 THEN
	dw_detail.object.partida_presup		[row] = ls_null
	dw_detail.SetColumn( "cnta_prsp")
	RETURN 1
END IF

end event

event dw_detail::doubleclicked;// Abre ventana de ayuda 
String 	ls_name, ls_prot, ls_cencos, ls_sql, &
			ls_cnta_prsp, ls_cod_art, ls_null, ls_codigo, ls_data
Long 		ll_ano, ll_row_mas, ll_mes
Decimal {2} ln_precio, ln_cambio, ldc_importe
Date 		ld_fecha, ld_fec_req
str_parametros sl_param 

dw_master.AcceptText()
dw_detail.AcceptText()
of_set_status_doc(idw_1)   // Evalua status de documento

ll_row_mas = dw_master.GetRow()

if ll_row_mas <= 0 then return
if row <= 0 then return

SetNull(ls_null)

ls_name 		= dwo.name
ls_prot 		= this.Describe( ls_name + ".Protect")
if ls_prot = '1' then return

ld_fecha 	= DATE( dw_master.object.fec_registro[ll_row_mas])
ls_cencos 	= dw_master.Object.cencos[ll_row_mas]

// Ayuda de busqueda para articulos
IF ls_name = 'cod_art' then
	OpenWithParm (w_pop_articulos, parent)
	sl_param = MESSAGE.POWEROBJECTPARM
	IF sl_param.titulo <> 'n' then
		ls_cod_art = sl_param.field_ret[1]
		
		this.object.cod_art			[row] = ls_cod_art
		this.object.desc_art			[row] = sl_param.field_ret[2]
		this.object.und				[row] = sl_param.field_ret[3]
		this.object.dias_reposicion[row] = INTEGER(sl_param.field_ret[5]) 	
	
		Select costo_ult_compra 
			into :ln_precio 
		from articulo 
     	Where cod_Art = :ls_cod_art;
		  
		if sqlca.sqlcode = 100 then		
			Messagebox( "Error", "Codigo no existe", Exclamation!)
			this.object.cod_art	[row] = ls_null
			this.object.desc_art	[row] = ls_null
			this.object.und		[row] = ls_null
			return 1
		end if
		
		if of_verifica_dup( ls_cod_art) = 0 then // verifica codigos duplicados
			this.object.cod_art	[row] = ls_null
			this.object.desc_art	[row] = ls_null
			this.object.und		[row] = ls_null
			return 1
		end if	
		
		if is_action = 'new' then
			// Segun tipo de moneda, asigna precio ult. compra	
			if dw_master.object.cod_moneda[dw_master.getrow()] = is_soles then
				// Busca ult. tipo de cambio
				Select cmp_dol_prom 
					into :ln_cambio 
				from calendario 
		   	where TRUNC( fecha ) = :ld_fecha;				
				
				IF ln_cambio = 0 or isnull( ln_cambio) then
					Messagebox( "Atencion", "no existe tipo de cambio para hacer conversion~r" + &
				    	"Su precio en US$ es: " + string( ln_precio), Exclamation! )
			   	ln_precio = 0
				else
			  		ln_precio = ln_precio * ln_cambio
		   	end if
			end if
			this.object.precio_unit[row] = ln_precio
		end if
		this.ii_update = 1
	END IF
	
elseif ls_name = 'partida_presup' then	
	
	ls_cencos = dw_master.object.cencos[dw_master.GetRow()]
	ll_ano 	 = Year( Date( this.object.fec_requerida	[row] ) )
	if ll_ano = 0 or IsNull(ll_ano) then ll_ano = Year(Today())
	
	ls_sql = "select distinct pc.cnta_prsp as codigo_cuenta, " &
			 + "pc.descripcion as descripcion_cuenta " &
			 + "from presupuesto_cuenta pc, " &
			 + "presupuesto_partida pp " &
			 + "where pp.cnta_prsp = pc.cnta_prsp " &
			 + "and cencos = '"+ls_cencos+"' " &
			 + "and ano = " + string(ll_ano) + " " &
			 + "and NVL(pp.flag_cmp_directa, '') <> '1' " &
			 + "and pp.flag_estado <> '0' " &
			 + "order by pc.descripcion"
				 
	f_lista(ls_sql, ls_codigo, ls_data, '2')
	
	if ls_codigo = '' then return
	
	this.object.partida_presup	[row] = ls_codigo
	this.ii_update = 1	

elseif ls_name = 'fec_requerida' and ls_prot = '0' then
	
	Datawindow ldw
	ldw = this
	if dwo.type <> 'column' then return 1

	f_call_calendar( ldw, dwo.name, dwo.coltype, row)
	
	ld_fec_req = Date( this.object.fec_requerida[row] )
	
	if ld_fec_req < ld_fecha then
		MessageBox('Aviso', 'No puede ingresar una fecha anterior al del documento', StopSign!)
		SetNull(ld_fec_req)
		this.object.fec_requerida[row] = ld_fec_req
	end if

	this.ii_update = 1
	
end if

Send(Handle(this),256,9,Long(0,0))   // fuerza a dar enter

// Evalua presupuesto.	
ldc_importe = dec(this.object.precio_unit[row]) * Dec(this.object.cant_proyect[row])

if dw_master.object.cod_moneda[dw_master.GetRow()] = is_soles then
	if idc_tipo_cambio = 0 then return
	ldc_importe = ldc_importe / idc_tipo_cambio
end if

ls_cencos = trim(dw_master.object.cencos[dw_master.GetRow()])
If IsNull(ls_cencos) then ls_cencos = ''

ls_cnta_prsp = trim(this.object.partida_presup[row])
If IsNull(ls_cnta_prsp) then ls_cnta_prsp = ''

ll_mes = Month( DAte( this.object.fec_requerida[row]) )
ll_ano = Year( Date(this.object.fec_requerida [row]) )

if ls_cencos = '' or ls_cnta_prsp = '' then return

// Verifico que la partida presupuestal sea de compra directa
if f_prsp_cmp_directa( ls_cencos, ls_cnta_prsp, ll_ano) = '1' then
	MessageBox('Aviso', 'La Partida Presupuestal solo es para gastos directos')
	dw_detail.object.partida_presup		[row] = ls_null
	dw_detail.SetColumn( "partida_presup")
	RETURN 1
end if
	
IF f_afecta_presup(ll_mes, ll_ano, ls_cencos, ls_cnta_prsp, ldc_importe) = 0 THEN
	dw_detail.object.partida_presup		[row] = ls_null
	dw_detail.SetColumn( "partida_presup")
	RETURN 1
END IF

end event

event dw_detail::clicked;call super::clicked;of_set_status_doc( dw_detail)
end event

event dw_detail::getfocus;call super::getfocus;// Verifica que datos de cabecera existan

if dw_master.rowcount() = 0 then return
String ls_mon, ls_cencos

ls_mon = dw_master.object.cod_moneda[dw_master.getrow()]
if isnull( ls_mon) or trim( ls_mon) = '' then
	Messagebox( "Atencion", "Ingrese Codigo de moneda")
	dw_master.setcolumn( "cod_moneda")
	dw_master.setfocus()
	return
end if
ls_cencos = dw_master.object.cencos[dw_master.getrow()]
if isnull( ls_cencos) or trim( ls_cencos) = '' then
	Messagebox( "Atencion", "Ingrese centro de costo")	
	dw_master.setcolumn( "cencos")
	dw_master.setfocus()
	return
end if
end event

type st_1 from statictext within w_cm301_solicitud_compra
integer x = 50
integer y = 28
integer width = 279
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Origen:"
boolean focusrectangle = false
end type

type sle_ori from singlelineedit within w_cm301_solicitud_compra
integer x = 338
integer y = 12
integer width = 229
integer height = 92
integer taborder = 10
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_2 from statictext within w_cm301_solicitud_compra
integer x = 626
integer y = 24
integer width = 402
integer height = 64
boolean bringtotop = true
integer textsize = -9
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

type sle_nro from singlelineedit within w_cm301_solicitud_compra
integer x = 901
integer y = 12
integer width = 512
integer height = 92
integer taborder = 20
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event modified;cb_1.event clicked()
end event

type cb_1 from commandbutton within w_cm301_solicitud_compra
integer x = 1499
integer y = 12
integer width = 402
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

of_retrieve(sle_ori.text, sle_nro.text)

end event

