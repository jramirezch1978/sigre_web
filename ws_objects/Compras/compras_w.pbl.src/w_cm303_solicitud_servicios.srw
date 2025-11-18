$PBExportHeader$w_cm303_solicitud_servicios.srw
forward
global type w_cm303_solicitud_servicios from w_abc_mastdet
end type
type st_1 from statictext within w_cm303_solicitud_servicios
end type
type sle_ori from singlelineedit within w_cm303_solicitud_servicios
end type
type st_2 from statictext within w_cm303_solicitud_servicios
end type
type sle_nro from singlelineedit within w_cm303_solicitud_servicios
end type
type cb_1 from commandbutton within w_cm303_solicitud_servicios
end type
end forward

global type w_cm303_solicitud_servicios from w_abc_mastdet
integer width = 3520
integer height = 1792
string title = "Solicitud de Servicios (CM303)"
string menuname = "m_mtto_impresion"
string icon = "H:\Source\Ico\Travel.ico"
event ue_anular ( )
event ue_cancelar ( )
st_1 st_1
sle_ori sle_ori
st_2 st_2
sle_nro sle_nro
cb_1 cb_1
end type
global w_cm303_solicitud_servicios w_cm303_solicitud_servicios

type variables
String is_flag_cnta_prsp

end variables

forward prototypes
public function integer of_set_status_doc (datawindow idw)
public subroutine of_retrieve (string as_origen, string as_nro)
public function integer of_set_numera ()
end prototypes

event ue_anular();Long j

IF MessageBox("Anulacion de Registro", "Esta Seguro ?", Question!, YesNo!, 2) <> 1 THEN
	RETURN
END IF

// Anulando Cabecera
dw_master.Object.flag_estado[dw_master.GetRow()] = '0'
dw_master.ii_update = 1		// Activa para grabacion

// Anulando Detalle
For j = 1 to dw_detail.RowCount()
	dw_detail.object.flag_estado[j] = '0'
	dw_detail.object.precio[j] = 0
Next
dw_detail.ii_update = 1   // Activa para grabacion

is_action = 'anu'
end event

event ue_cancelar();// Cancela operacion, limpia todo

EVENT ue_update_request()   // Verifica actualizaciones pendientes
dw_master.reset()
dw_detail.reset()
sle_ori.text = ''
sle_nro.text = ''
sle_ori.SetFocus()

is_Action = ''
of_set_status_doc(dw_master)
end event

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

public subroutine of_retrieve (string as_origen, string as_nro);Long ll_row

ll_row = dw_master.retrieve(as_origen, as_nro)
Is_action = 'open'
//il_row = ll_row

IF ll_row = 0 then return
dw_detail.retrieve(as_origen, as_nro)
of_set_status_doc( dw_master )
dw_master.il_row = ll_row
return 




















end subroutine

public function integer of_set_numera ();// Numera documento
Long j
String  ls_next_nro

if dw_master.getrow() = 0 then return 1

if is_action = 'new' then
	ls_next_nro = f_numera_documento('num_sol_ord_srv',9)
	if ls_next_nro = '0' then
		return 0
	else
		dw_master.object.nro_sol_serv[dw_master.getrow()] = ls_next_nro
	end if
else
	ls_next_nro = dw_master.object.nro_sol_serv[dw_master.getrow()] 
end if
// Asigna numero a detalle
for j = 1 to dw_detail.RowCount()
	dw_detail.object.nro_sol_serv[j] = ls_next_nro
next

return 1
end function

event ue_open_pre;call super::ue_open_pre;ii_pregunta_delete = 1   // 1 = si pregunta, 0 = no pregunta (default)
// ii_help = 101

select NVL(flag_mod_cnta_prsp, '0')
  into :is_flag_cnta_prsp
 from presup_param
 where llave = '1';


dw_master.object.p_logo.filename = gs_logo


end event

event ue_update_pre;// Verifica que campos son requeridos y tengan valores

ib_update_check = False
if f_row_Processing( dw_master, "form") <> true then	
	return
end if	

// Verifica que campos son requeridos y tengan valores
if f_row_Processing( dw_detail, "tabular") <> true then	
	return
end if	

// Numeracion de documento
if of_set_numera() = 0 then	
	return
end if
if is_action <> 'anu' then
	dw_master.of_protect()         			// bloquear modificaciones 
	dw_detail.of_protect()
end if
is_action = ''   
ib_update_check = true

dw_master.of_set_flag_replicacion()
dw_detail.of_set_flag_replicacion()
end event

on w_cm303_solicitud_servicios.create
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

on w_cm303_solicitud_servicios.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.sle_ori)
destroy(this.st_2)
destroy(this.sle_nro)
destroy(this.cb_1)
end on

event ue_print();call super::ue_print;str_parametros lstr_rep

lstr_rep.string1 = dw_master.object.cod_origen[dw_master.getrow()]
lstr_rep.string2 = dw_master.object.nro_sol_serv[dw_master.getrow()]
OpenSheetWithParm(w_cm303_solicitud_servicio_frm, lstr_rep, This, 2, layered!)

end event

event ue_list_open;// Abre ventana pop
str_parametros sl_param

sl_param.dw1 = "d_lista_solicitud_servicio_tbl"
sl_param.titulo = "Solicitud de Servicio"
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
String	ls_msg, ls_crlf

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

IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_master.Update(true, false) = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion Master", ls_msg, StopSign!)
	END IF
END IF

IF dw_detail.ii_update = 1 THEN
	IF dw_detail.Update(true, false) = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion Detalle", ls_msg, StopSign!)	
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
	
	is_Action = 'open'
	of_set_status_doc( dw_master )		// Activa/desactiva opciones de menu, segun flag_estado
	
	f_mensaje("Cambios guardados satisfactoriamente", "")
	
ELSE
	ROLLBACK USING SQLCA;
END IF


end event

event ue_delete();// Override
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

event ue_modify();call super::ue_modify;int li_protect, li_protect_sol

li_protect = integer(dw_master.Object.cod_origen.Protect)

IF li_protect = 0 THEN
   dw_master.Object.cod_origen.Protect = 1
	dw_master.Object.nro_sol_serv.Protect = 1
END IF

is_action = 'edit'

end event

event ue_insert();// Override
Long  ll_row

if idw_1 = dw_detail and dw_master.getrow() = 0 then return

ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN
	THIS.EVENT ue_insert_pos(ll_row)
end if

end event

type dw_master from w_abc_mastdet`dw_master within w_cm303_solicitud_servicios
event ue_display ( string as_columna,  long al_row )
integer x = 9
integer y = 140
integer width = 3410
integer height = 716
integer taborder = 40
string dataobject = "d_abc_sol_servicio_ff"
end type

event dw_master::ue_display(string as_columna, long al_row);boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql
Long 		ll_ano

choose case lower(as_columna)
		
	case "cencos"
		ll_ano = YEAR( DATE(this.object.fec_registro[al_row] ))
		ls_sql = "SELECT distinct cc.cencos AS CODIGO_cencos, " &
				 + "cc.DESC_cencos AS DESCRIPCION_cencos " &
				 + "FROM centros_costo cc, " &
				 + "presupuesto_partida pp " &
				 + "WHERE pp.cencos = cc.cencos " &
				 + "AND pp.flag_estado <> '0' " &
				 + "AND cc.flag_estado <> '0' " &
				 + "AND NVL(pp.flag_cmp_directa,'') <> '0' " &
				 + "AND pp.ano = " + string(ll_ano) + " " &
				 + "ORDER BY DESC_CENCOS "
					 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
			
		if ls_codigo <> '' then
			this.object.cencos			[al_row] = ls_codigo
			this.object.desc_cencos		[al_row] = ls_data
			this.ii_update = 1
		end if
		return
		
	case "cod_moneda"
		ls_sql = "SELECT cod_moneda AS codigo_moneda, " &
				 + "descripcion AS desc_moneda " &
				 + "FROM moneda " 
					 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
			
		if ls_codigo <> '' then
			this.object.cod_moneda	[al_row] = ls_codigo
			this.object.desc_moneda	[al_row] = ls_data
			this.ii_update = 1
		end if
		return

end choose

end event

event dw_master::constructor;call super::constructor;is_dwform = 'form'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_dk[1] = 1 	      // columnas que se pasan al detalle
ii_dk[2] = 2


end event

event dw_master::itemerror;call super::itemerror;return (1)   // Fuerza a salir sin mostrar mensaje de error
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.fec_registro	[al_row] = f_fecha_actual()
this.object.cod_origen		[al_row] = gs_origen
this.object.flag_estado		[al_row] = '1'		//activo
this.object.cod_usr			[al_row] = gs_user
this.Object.p_logo.filename = gs_logo

is_action = 'new'  // Nuevo documento
end event

event dw_master::clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

of_set_status_doc( this)
end event

event dw_master::itemchanged;call super::itemchanged;String ls_desc, ls_null

SetNull( ls_null)

IF dwo.name = 'cencos' then
	// Verifica que codigo exista
	Select desc_cencos 
		into :ls_desc 
	from centros_costo
	Where cencos = :data
	  and flag_estado = '1';
	  
	if SQLCA.SQLCode = 100 then
		Messagebox( "Error", "Centro de costo no existe o no esta activo")
		this.object.cencos		[row] = ls_null
		this.object.desc_cencos [row] = ls_null
		return 1
	end if
	
	this.object.desc_cencos [row] = ls_desc
	
elseIF dwo.name = 'cod_moneda' then
	
	// Verifica que codigo exista
	Select descripcion
		into :ls_desc 
	from moneda
	Where cod_moneda = :data;
	  
	if SQLCA.SQLCode = 100 then
		Messagebox( "Error", "Codigo de moneda no existe")
		this.object.cod_moneda	[row] = ls_null
		this.object.desc_moneda [row] = ls_null
		return 1
	end if
	
	this.object.desc_moneda [row] = ls_desc
	
END IF
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

type dw_detail from w_abc_mastdet`dw_detail within w_cm303_solicitud_servicios
event ue_display ( string as_columna,  long al_row )
integer x = 0
integer y = 864
integer width = 3429
integer height = 692
integer taborder = 50
string dataobject = "d_abc_sol_serv_detalle1_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
end type

event dw_detail::ue_display(string as_columna, long al_row);boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_cencos, ls_cnta_prsp, &
			ls_null, ls_desc_cnta_prsp
Long		ll_ano, ll_mes

if dw_master.GetRow() = 0 then return

SetNull(ls_null)

ls_cencos = dw_master.object.cencos [dw_master.GetRow()]
If IsNull(ls_cencos) then ls_cencos = ''

if ls_cencos = '' then 
	MessageBox('Aviso', 'Centro de Costo no definido')
	return
end if

choose case lower(as_columna)
		
	case "cnta_prsp"
		
		ll_ano = YEAR( DATE(this.object.fec_requerida [al_row] ))
		
		ls_sql = "SELECT distinct pc.cnta_prsp AS CODIGO_cnta_prsp, " &
				 + "pc.DESCripcion AS DESCRIPCION_cnta_prsp " &
				 + "FROM presupuesto_cuenta pc, " &
				 + "presupuesto_partida pp " &
				 + "WHERE pp.cnta_prsp = pc.cnta_prsp " &
				 + "AND pp.flag_estado <> '0' " &
				 + "AND NVL(pp.flag_cmp_directa,'') <> '0' " &
				 + "AND pp.cencos = '" + ls_cencos + "' " &
				 + "AND pp.ano = " + string(ll_ano) + " " &
				 + "ORDER BY pc.cnta_prsp "
				 
		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.cnta_prsp		[al_row] = ls_codigo
			this.object.desc_cnta_prsp	[al_row] = ls_data
			this.ii_update = 1
		end if
		
		return
		
	case "cod_sub_cat"
		ls_sql = "SELECT distinct a.cod_sub_cat AS CODIGO_sub_categ, " &
				 + "a.desc_sub_cat AS DESCRIPCION_sub_categ, " &
				 + "a.cnta_prsp_egreso AS cnta_prsp " &
				 + "FROM articulo_sub_categ a, " &
				 + "articulo_categ  b " &
				 + "WHERE a.cat_art = b.cat_art " &
				 + "AND b.flag_servicio = '1' " &
				 + "ORDER BY a.desc_sub_cat "
					 
		lb_ret = f_lista_3ret(ls_sql, ls_codigo, ls_data, ls_cnta_prsp, '2')
			
		if ls_codigo <> '' then
			this.object.cod_sub_cat		[al_row] = ls_codigo
			this.object.desc_sub_cat	[al_row] = ls_data
			
			select descripcion
				into :ls_desc_cnta_prsp
			from presupuesto_cuenta
			where cnta_prsp = :ls_cnta_prsp;
			
			this.object.cnta_prsp		[al_row] = ls_cnta_prsp
			this.object.dec_cnta_prsp	[al_row] = ls_desc_cnta_prsp
			this.ii_update = 1
		end if
		return
end choose

// Evalua presupuesto.	
ll_mes = Month( Date( this.object.fec_requerida	[al_row]) )
ll_ano = Year( Date(this.object.fec_requerida 	[al_row]) )

ls_cnta_prsp = this.object.cnta_prsp[al_row]
If IsNull(ls_Cnta_prsp) then ls_cnta_prsp = ''

if ls_cencos = '' or ls_cnta_prsp = '' then return

// Verifico que la partida presupuestal sea de compra directa
if f_prsp_cmp_directa( ls_cencos, ls_cnta_prsp, ll_ano) = '0' then
	MessageBox('Aviso', 'La Partida Presupuestal es solo para mov. de almacen')
	dw_detail.object.cnta_prsp			[al_row] = ls_null
	dw_detail.object.desc_cnta_prsp 	[al_row] = ls_null
	dw_detail.SetColumn( "cnta_prsp")
	RETURN
end if
end event

event dw_detail::constructor;call super::constructor;is_mastdet = 'd'	

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2

ii_rk[1] = 1 	      // columnas que se pasan al detalle
ii_rk[2] = 2

is_dwform = 'form'	
idw_mst  = 	dw_master
idw_det  =  dw_detail
end event

event dw_detail::itemerror;call super::itemerror;return (1)
end event

event dw_detail::ue_insert_pre;call super::ue_insert_pre;THIS.object.fec_registro	[al_row] = THIS.object.fec_registro[al_row]
THIS.object.fec_requerida	[al_row] = dw_master.object.fec_registro[dw_master.getrow()]
this.object.flag_estado		[al_row] = '1'
this.object.nro_item			[al_row] = f_numera_item(dw_detail)
this.object.precio			[al_row] = 0.00

if is_flag_cnta_prsp = '1' then
	this.object.cnta_prsp.protect = 1
	this.object.cnta_prsp.Background.color = RGB(192,192,192)
end if

this.setcolumn( "fec_requerida")


end event

event dw_detail::itemchanged;call super::itemchanged;string 	ls_cencos, ls_desc, ls_null, ls_cnta_prsp, ls_desc_cnta_prsp
Long		ll_ano, ll_mes

SetNull(ls_null)
this.AcceptText()

if dw_master.GetRow() = 0 then return

ls_cencos = dw_master.object.cencos[dw_master.GetRow()]
ll_ano = Year( date( this.object.fec_requerida [row] ) )


if dwo.name = "cnta_prsp" then
	//Verifica que exista dato ingresado
	
	Select pc.descripcion 
		into :ls_desc 
	from presupuesto_cuenta  pc,
		  presupuesto_partida pp
	where pc.cnta_prsp = :data
	  and pp.flag_estado <> '0'
	  and pp.flag_cmp_directa <> '0'
	  and pp.cencos = :ls_cencos
	  and pp.ano    = :ll_ano;	

	if SQLCA.SQLCode = 100 then
		Messagebox( "Error", "Cuenta presupuestal no existe, " &
				+ "no tiene partida presupuestal o la partida presupuestal " &
				+ "no es para compra directa", Exclamation!)
		this.object.cnta_prsp		[row] = ls_null
		this.object.desc_cnta_prsp [row] = ls_null
		return 1
	end if
	
	this.object.desc_cnta_prsp 	[row] = ls_desc
	
elseif dwo.name = 'cod_sub_cat' then
	
	Select desc_sub_cat, cnta_prsp_egreso
		into :ls_desc, :ls_cnta_prsp
	from articulo_sub_categ 	a,
		  articulo_categ			b
	where a.cat_art = b.cat_art
	  and b.flag_servicio = '1'
	  and cod_sub_cat = :data;
	  
	select descripcion
		into :ls_desc_cnta_prsp
	from presupuesto_cuenta
	where cnta_prsp = :ls_cnta_prsp;
	
	if SQLCA.SQLCode = 100 then
		Messagebox( "Error", "Categoria de Servicio no existe, " &
				+ "o no corresponde al tipo de servicio ", Exclamation!)
		this.object.cod_sub_cat		[row] = ls_null
		this.object.desc_sub_cat 	[row] = ls_null
		return 1
	end if
	
	this.object.desc_sub_cat 	[row] = ls_desc
	this.object.cnta_prsp 		[row] = ls_cnta_prsp
	this.object.desc_cnta_prsp [row] = ls_desc_cnta_prsp
	
end if

// Evalua presupuesto.	
ll_mes = Month( Date( this.object.fec_requerida	[row]) )
ll_ano = Year( Date(this.object.fec_requerida 	[row]) )

ls_cnta_prsp = this.object.cnta_prsp[row]
If IsNull(ls_Cnta_prsp) then ls_cnta_prsp = ''

if ls_cencos = '' or ls_cnta_prsp = '' then return

// Verifico que la partida presupuestal sea de compra directa
if f_prsp_cmp_directa( ls_cencos, ls_cnta_prsp, ll_ano) = '0' then
	MessageBox('Aviso', 'La Partida Presupuestal es solo para mov. de almacen')
	this.object.cnta_prsp			[row] = ls_null
	this.object.desc_cnta_prsp 	[row] = ls_null
	dw_detail.SetColumn( "cnta_prsp")
	RETURN
end if
end event

event dw_detail::doubleclicked;call super::doubleclicked;string 	ls_columna

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN

if dwo.name = 'fec_requerida' then
	Datawindow ldw

	ldw = this

	f_call_calendar( ldw, dwo.name, dwo.coltype, row)
	return
end if

if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, row)
end if
end event

event dw_detail::clicked;call super::clicked;of_set_status_doc( dw_detail)
end event

type st_1 from statictext within w_cm303_solicitud_servicios
integer x = 41
integer y = 32
integer width = 279
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
string text = "Origen:"
boolean focusrectangle = false
end type

type sle_ori from singlelineedit within w_cm303_solicitud_servicios
integer x = 352
integer y = 24
integer width = 229
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
borderstyle borderstyle = stylelowered!
end type

type st_2 from statictext within w_cm303_solicitud_servicios
integer x = 645
integer y = 44
integer width = 402
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

type sle_nro from singlelineedit within w_cm303_solicitud_servicios
integer x = 951
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
borderstyle borderstyle = stylelowered!
end type

event modified;cb_1.event clicked()
end event

type cb_1 from commandbutton within w_cm303_solicitud_servicios
integer x = 1504
integer y = 32
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

