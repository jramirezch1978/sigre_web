$PBExportHeader$w_cm339_solicitud_conformidad.srw
forward
global type w_cm339_solicitud_conformidad from w_abc
end type
type sle_nro from u_sle_codigo within w_cm339_solicitud_conformidad
end type
type cb_buscar from commandbutton within w_cm339_solicitud_conformidad
end type
type st_nro from statictext within w_cm339_solicitud_conformidad
end type
type dw_detail from u_dw_abc within w_cm339_solicitud_conformidad
end type
type dw_master from u_dw_abc within w_cm339_solicitud_conformidad
end type
end forward

global type w_cm339_solicitud_conformidad from w_abc
integer width = 3387
integer height = 2132
string title = "Conformidad de OS (CM339)"
string menuname = "m_mtto_imp_mail"
sle_nro sle_nro
cb_buscar cb_buscar
st_nro st_nro
dw_detail dw_detail
dw_master dw_master
end type
global w_cm339_solicitud_conformidad w_cm339_solicitud_conformidad

type variables
String      		is_tabla_m,is_tabla_d,is_colname_m[],is_coltype_m[],is_colname_d[],is_coltype_d[]
n_cst_log_diario	in_log

end variables

forward prototypes
public function integer of_nro_item (datawindow adw_pr)
public function integer of_set_numera ()
public subroutine of_retrieve (string as_nro_conformidad)
end prototypes

public function integer of_nro_item (datawindow adw_pr);integer li_item, li_x

li_item = 0

For li_x 		= 1 to adw_pr.RowCount()
	IF li_item 	< adw_pr.object.nro_item[li_x] THEN
		li_item 	= adw_pr.object.nro_item[li_x]
	END IF
Next

Return li_item + 1
end function

public function integer of_set_numera ();// Numera documento
Long 		ll_count, ll_ult_nro, ll_i
String  	ls_next_nro, ls_lock_table, ls_mensaje

IF dw_master.getrow() = 0 THEN RETURN 0

IF is_action = 'new' THEN
	SELECT count(*)
		INTO :ll_count
	FROM NUM_CONF_SERVICIO
	WHERE origen = :gs_origen;
	
	IF ll_count = 0 THEN
		ls_lock_table = 'LOCK TABLE NUM_CONF_SERVICIO IN EXCLUSIVE MODE'
		EXECUTE IMMEDIATE :ls_lock_table ;
		
		IF SQLCA.SQLCode < 0 THEN
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Aviso', ls_mensaje)
			RETURN 0
		END IF
		
		INSERT INTO NUM_CONF_SERVICIO(origen, ult_nro)
		VALUES( :gs_origen, 1);
		
		IF SQLCA.SQLCode < 0 THEN
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Aviso', ls_mensaje)
			RETURN 0
		END IF
	END IF
	
	SELECT ult_nro
	  INTO :ll_ult_nro
	FROM NUM_CONF_SERVICIO
	WHERE origen = :gs_origen FOR UPDATE;
	
	UPDATE NUM_CONF_SERVICIO
		SET ult_nro = ult_nro + 1
	WHERE origen = :gs_origen;
	
	IF SQLCA.SQLCode < 0 THEN
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Aviso', ls_mensaje)
		RETURN 0
	END IF
	
	ls_next_nro = trim(gs_origen) + string(ll_ult_nro, '00000000')
	
	dw_master.object.nro_conformidad[dw_master.getrow()] = ls_next_nro
	dw_master.ii_update = 1
	ELSE
	ls_next_nro = dw_master.object.nro_conformidad[dw_master.getrow()] 
	END IF

// Asigna numero a detalle dw_detail (detalle de la instruccion)
FOR ll_i = 1 TO dw_detail.RowCount()
	dw_detail.object.nro_conformidad[ll_i] = ls_next_nro
NEXT

RETURN 1
end function

public subroutine of_retrieve (string as_nro_conformidad);event ue_update_request( )

dw_master.Retrieve(as_nro_conformidad)
dw_detail.retrieve(as_nro_conformidad)

dw_master.ii_protect = 0
dw_master.of_protect( )
dw_master.ii_update = 0

dw_detail.ii_protect = 0
dw_detail.of_protect( )
dw_detail.ii_update = 0

is_Action = 'open'

end subroutine

on w_cm339_solicitud_conformidad.create
int iCurrent
call super::create
if this.MenuName = "m_mtto_imp_mail" then this.MenuID = create m_mtto_imp_mail
this.sle_nro=create sle_nro
this.cb_buscar=create cb_buscar
this.st_nro=create st_nro
this.dw_detail=create dw_detail
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_nro
this.Control[iCurrent+2]=this.cb_buscar
this.Control[iCurrent+3]=this.st_nro
this.Control[iCurrent+4]=this.dw_detail
this.Control[iCurrent+5]=this.dw_master
end on

on w_cm339_solicitud_conformidad.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_nro)
destroy(this.cb_buscar)
destroy(this.st_nro)
destroy(this.dw_detail)
destroy(this.dw_master)
end on

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - 10
dw_detail.width  = newwidth  - dw_detail.x - 10
dw_detail.height = newheight - dw_detail.y - 10
end event

event ue_open_pre;call super::ue_open_pre;dw_master.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos
dw_detail.SetTransObject(sqlca)

idw_1 = dw_master              				// asignar dw corriente
ib_log 		= TRUE
dw_master.of_protect()         		// bloquear modificaciones 
dw_detail.of_protect()
end event

event ue_insert;call super::ue_insert;Long  ll_row

IF idw_1 = dw_detail then
	MessageBox("Error", "No puede ingresar registros sin hacer referencia a una OS.")
	RETURN
END IF

ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)


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

event ue_update_pre;call super::ue_update_pre;long 		ll_row, ll_master
Integer 	li_count

// Verifica que campos son requeridos y tengan valores
ib_update_check = False
if f_row_Processing( dw_master, "form") <> true then return

// Verifica que campos son requeridos y tengan valores
if f_row_Processing( dw_detail, "tabular") <> true then return

//Para la replicacion de datos

dw_master.of_set_flag_replicacion()
dw_detail.of_set_flag_replicacion()

///////////////////////////////////////////////
if of_set_numera() = 0 then return
///////////////////////////////////////////////

// Si todo ha salido bien cambio el indicador ib_update_check a true, para indicarle
// al evento ue_update que todo ha salido bien
ib_update_check = true
end event

event ue_update;//Override
Boolean lbo_ok = TRUE
String	ls_msg

dw_master.AcceptText()
dw_detail.AcceptText()

THIS.EVENT ue_update_pre()

IF ib_update_check = FALSE THEN RETURN

IF ib_log THEN											
	in_log = Create n_cst_log_diario
	in_log.of_dw_map(dw_master, is_colname_m, is_coltype_m)
	in_log.of_dw_map(dw_detail, is_colname_d, is_coltype_d)
END IF

IF ib_log THEN
	Datastore		lds_log_m, lds_log_d
	lds_log_m = Create DataStore
	lds_log_d = Create DataStore
	lds_log_m.DataObject = 'd_log_diario_tbl'
	lds_log_d.DataObject = 'd_log_diario_tbl'
	lds_log_m.SetTransObject(SQLCA)
	lds_log_d.SetTransObject(SQLCA)
	in_log.of_create_log(dw_master, lds_log_m, is_colname_m, is_coltype_m, gs_user, is_tabla_m)
	in_log.of_create_log(dw_detail, lds_log_d, is_colname_d, is_coltype_d, gs_user, is_tabla_d)
END IF

IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_master.Update() = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion Master", ls_msg, StopSign!)
	END IF
END IF

IF dw_detail.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_detail.Update() = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion Detalle", ls_msg, StopSign!)
	END IF
END IF

IF ib_log THEN
	IF lbo_ok THEN
		IF lds_log_m.Update() = -1 THEN
			lbo_ok = FALSE
			ROLLBACK USING SQLCA;
			MessageBox('Error en Base de Datos', 'No se pudo grabar el Log Diario, Maestro')
		END IF
		IF lds_log_d.Update() = -1 THEN
			lbo_ok = FALSE
			ROLLBACK USING SQLCA;
			MessageBox('Error en Base de Datos', 'No se pudo grabar el Log Diario, Detalle')
		END IF
	END IF
	DESTROY lds_log_m
	DESTROY lds_log_d
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0
	dw_detail.ii_update = 0
	dw_master.il_totdel = 0
	dw_detail.il_totdel = 0
	is_action = 'open'
END IF
end event

event ue_list_open;call super::ue_list_open;// Abre ventana pop - OVERRIDE

IF ii_list = 0 THEN
	ii_list = 1
	THIS.Event ue_update_request()
END IF

str_parametros sl_param

sl_param.dw1 = "d_lista_actas_conformidad_tbl"
sl_param.titulo = "Acta de Conformidad"
sl_param.field_ret_i[1] = 1

OpenWithParm( w_lista, sl_param)
sl_param = MESSAGE.POWEROBJECTPARM
if sl_param.titulo <> 'n' then
	of_retrieve(sl_param.field_ret[1])
END IF



end event

event ue_print;call super::ue_print;str_parametros lstr_rep
IF dw_master.rowcount() = 0 then return

String ls_estado

ls_estado = dw_master.object.flag_estado [dw_master.getrow()]

if ls_estado = 'G' or isnull(ls_estado) then
	Messagebox('Aviso', 'Acta de Conformidad Requiere aprobación')
	Return
end if

lstr_rep.string1 = dw_master.object.nro_conformidad [dw_master.getrow()]
OpenSheetWithParm(w_cm339_solicitud_conformidad_frm, lstr_rep, This, 2, layered!)


end event

event ue_modify;call super::ue_modify;string 	ls_estado
Long		ll_row

if dw_master.GetRow() = 0 then return

ls_estado = dw_master.object.flag_estado [dw_master.GetRow()]

if ls_estado = '2' or isnull(ls_estado) then
	Messagebox('Aviso', 'Si el Acta de Conformidad esta aprobada no puede hacer Modificaciones ')
	Return
end if

dw_master.of_protect()
dw_detail.of_protect()
end event

type sle_nro from u_sle_codigo within w_cm339_solicitud_conformidad
integer x = 315
integer y = 16
integer height = 92
integer taborder = 20
boolean bringtotop = true
end type

event constructor;call super::constructor;ii_prefijo = 2
ii_total = 10
ibl_mayuscula = true
end event

type cb_buscar from commandbutton within w_cm339_solicitud_conformidad
integer x = 864
integer y = 12
integer width = 402
integer height = 100
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Buscar"
end type

event clicked;EVENT ue_update_request()
of_retrieve(sle_nro.text)
end event

type st_nro from statictext within w_cm339_solicitud_conformidad
integer x = 18
integer y = 28
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
string text = "Numero:"
boolean focusrectangle = false
end type

type dw_detail from u_dw_abc within w_cm339_solicitud_conformidad
integer y = 832
integer width = 3259
integer height = 920
integer taborder = 20
string dataobject = "d_abc_conformidad_servicio_det_tbl"
end type

event constructor;call super::constructor;//is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)


ii_ck[1] = 1				// columnas de lectrua de este dw
ii_rk[1] = 1 	      // columnas que recibimos del master

//idw_mst  = 				dw_master
//idw_det  =  			dw_detail
end event

event itemerror;call super::itemerror;return 1
end event

event ue_insert_pre;call super::ue_insert_pre;this.object.nro_item	[al_row] = of_nro_item(this)
this.object.cod_usr  [al_row] = gs_user
end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

type dw_master from u_dw_abc within w_cm339_solicitud_conformidad
event ue_display ( string as_columna,  long al_row )
integer y = 128
integer width = 2263
integer height = 688
string dataobject = "d_abc_conformidad_servicio_ff"
boolean hscrollbar = false
boolean vscrollbar = false
end type

event ue_display(string as_columna, long al_row);boolean lb_ret
string ls_codigo, ls_data, ls_sql, ls_ruc
str_seleccionar lstr_seleccionar

choose case upper(as_columna)
		
	case "COD_MAQUINA"
		
		ls_sql = "SELECT M.COD_MAQUINA AS CODIGO, " &
				  + "M.DESC_MAQ AS DESCR_MONEDA " &
				  + "FROM MAQUINA M " &
				  + "WHERE M.FLAG_ESTADO = '1' "
				 
		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.COD_MAQUINA	[al_row] = ls_codigo
			this.object.DESC_MAQ	[al_row] = ls_data
			this.ii_update = 1
		end if		
   END choose
end event

event constructor;call super::constructor;//is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'form'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw

end event

event clicked;call super::clicked;this.AcceptText()

Long  	ll_row
string	ls_nro_conformidad

str_parametros sl_param
Str_seleccionar lstr_seleccionar

if this.getrow( ) = 0 then return

String ls_estado

ll_row = this.getrow( )

choose case lower(dwo.name)
		
	case "b_referencias"
	
		ls_estado = this.object.flag_estado [ll_row]
		
		if ls_estado = '2' or isnull(ls_estado) then
			Messagebox('Aviso', 'Si el Acta de Conformidad esta aprobada no puede hacer Modificaciones ')
			Return
		end if

		sl_param.dw_master = "d_abc_ordenes_servicio_acta_confor_tbl"
		sl_param.dw1 = "d_abc_ordenes_servicio_acta_det_tbl"
		sl_param.titulo = "Ordenes de Servicio - Solicitan Acta"
		sl_param.dw_m = dw_master
		sl_param.dw_d = dw_detail
		sl_param.opcion = 20
	
		OpenWithParm( w_abc_seleccion_md, sl_param)
				
		this.ii_update = 1
end choose
end event

event itemerror;call super::itemerror;return 1
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
end event

event itemchanged;call super::itemchanged;string 	ls_codigo, ls_data
Long		ll_count

this.AcceptText()

if row <= 0 then
	return
end if

choose case upper(dwo.name)
		
	case "COD_MAQUINA"
		
		ls_codigo = this.object.cod_maquina[row]

		SetNull(ls_data)
		select desc_maq
		  into :ls_data
		from maquina
		where cod_maquina = :ls_codigo;
		
		if IsNull(ls_data) or ls_data = "" then
			Messagebox('PRODUCCIÓN', "CODIGO DE MAUINA NO EXISTE", StopSign!)
			SetNull(ls_codigo)
			this.object.cod_maquina [row] = ls_codigo
			this.object.desc_maq[row] = ls_codigo
			return 1
		end if
		this.object.desc_maq[row] = ls_data
		
end choose
end event

event ue_insert_pre;call super::ue_insert_pre;Date 		ld_fecha
Boolean	lb_ret
string   ls_nom_origen

this.object.cod_origen   [al_row] = gs_origen
this.object.fec_registro [al_row] = f_fecha_actual()
this.object.flag_estado  [al_row] = '1'
this.object.cod_usr		 [al_row] = gs_user

	select nombre
  	  into :ls_nom_origen
  	  from origen
 	 where origen.cod_origen = :gs_origen;
 
this.object.origen_nombre   [al_row]= ls_nom_origen

dw_detail.reset( )
is_action = 'new'

end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

end event

