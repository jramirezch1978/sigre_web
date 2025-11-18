$PBExportHeader$w_pt305_proyectos.srw
forward
global type w_pt305_proyectos from w_abc_master_tab
end type
type dw_5 from u_dw_abc within tabpage_4
end type
end forward

global type w_pt305_proyectos from w_abc_master_tab
integer width = 2953
integer height = 2000
string title = "Proyectos"
string menuname = "m_mtto_impresion"
event ue_cancelar ( )
end type
global w_pt305_proyectos w_pt305_proyectos

type variables

end variables

forward prototypes
public function integer of_set_numera ()
end prototypes

event ue_cancelar();// Cancela operacion, limpia todo

EVENT ue_update_request()   // Verifica actualizaciones pendientes
dw_master.reset()
tab_1.tabpage_2.dw_2.reset()
tab_1.tabpage_3.dw_3.reset()
tab_1.tabpage_4.dw_5.reset()

dw_master.ii_update = 0

//of_set_status_reg()

// Verifica que no pueda modificar
//int li_protect
//
//li_protect = integer(dw_master.Object.ano.Protect)
//IF li_protect = 0 THEN
//	dw_master.of_protect()
//end if
//wf_limpia_datos()	
end event

public function integer of_set_numera ();Long 		ll_nro, ll_j, ll_row
String 	ls_table, ls_ult_nro, ls_mensaje

ll_row = dw_master.GetRow()
if ll_row = 0 then return 0


// Numera documento
if is_action = 'new' then	
	ls_table = 'LOCK TABLE NUM_PROYECTO IN EXCLUSIVE MODE'
	EXECUTE IMMEDIATE :ls_table ;
	
	Select ult_nro 
		into :ll_nro 
	from num_proyecto 
	where origen = :gs_origen;
	
	if SQLCA.SQLCode = 100 then
		INSERT INTO NUM_PROYECTO(origen, ult_nro)
		values( :gs_origen, 1);
		
		IF SQLCA.SQLCode = -1 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('ERROR INSERT NUM_PROYECTO', ls_mensaje)
			return 0
		end if
		
		ll_nro = 1
	end if			
	
	ls_ult_nro = trim(gs_origen) + string(ll_nro, '00000000')
	
	dw_master.object.nro_sec_proy[ll_row] = ls_ult_nro
	// Incrementa contador 
	Update num_proyecto 
		set ult_nro = ult_nro + 1 
	where origen = :gs_origen;	
	
	IF SQLCA.SQLCode = -1 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('ERROR UPDATE NUM_PROYECTO', ls_mensaje)
		return 0
	end if
	
else 
	ls_ult_nro = dw_master.object.nro_sec_proy[ll_row] 
end if

// Asigna numero a detalle
for ll_j = 1 to tab_1.tabpage_1.dw_1.RowCount()
	tab_1.tabpage_1.dw_1.object.nro_sec_proy[ll_j] = ls_ult_nro
next		
	
// Asigna numero a beneficios
for ll_j = 1 to tab_1.tabpage_2.dw_2.RowCount()
	tab_1.tabpage_2.dw_2.object.nro_sec_proy[ll_j] = ls_ult_nro
next
	
// Asigna numero a partidas
for ll_j = 1 to tab_1.tabpage_3.dw_3.RowCount()
	tab_1.tabpage_3.dw_3.object.nro_sec_proy[ll_j] = ls_ult_nro
next		
	
// Asigna numero a operaciones
for ll_j = 1 to tab_1.tabpage_4.dw_5.RowCount()
	tab_1.tabpage_4.dw_5.object.nro_sec_proy[ll_j] = ls_ult_nro
next
	
return 1
end function

on w_pt305_proyectos.create
int iCurrent
call super::create
if this.MenuName = "m_mtto_impresion" then this.MenuID = create m_mtto_impresion
end on

on w_pt305_proyectos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_dw_share;// Over

Integer li_share_status

li_share_status = dw_master.ShareData (tab_1.tabpage_1.dw_1)
IF li_share_status <> 1 THEN
	messagebox("Error en Sharedata","Error al compartir con DW1",exclamation!)
	RETURN
END IF

li_share_status = tab_1.tabpage_4.dw_5.ShareData (tab_1.tabpage_4.dw_4)
IF li_share_status <> 1 THEN
	messagebox("Error en Sharedata","Error al compartir con DW5",exclamation!)
	RETURN
END IF



end event

event ue_open_pre();call super::ue_open_pre;f_centrar( this)

// habilitar dw de tabs
tab_1.tabpage_1.dw_1.enabled = TRUE
tab_1.tabpage_2.dw_2.enabled = TRUE
tab_1.tabpage_3.dw_3.enabled = TRUE
tab_1.tabpage_4.dw_5.enabled = TRUE

//tab_1.tabpage_1.dw_1.of_protect() 
//tab_1.tabpage_2.dw_2.of_protect() 

tab_1.tabpage_2.dw_2.SetTransObject(SQLCA)
tab_1.tabpage_3.dw_3.SetTransObject(SQLCA)
tab_1.tabpage_4.dw_4.SetTransObject(SQLCA)
tab_1.tabpage_4.dw_5.SetTransObject(SQLCA)

end event

event ue_list_open();call super::ue_list_open;// Abre ventana pop
str_parametros sl_param

sl_param.dw1 = "d_sel_proyectos"
sl_param.titulo = "Partidas"
sl_param.field_ret_i[1] = 1
sl_param.retrieve = 'S'

OpenWithParm( w_lista, sl_param)
sl_param = MESSAGE.POWEROBJECTPARM
if sl_param.titulo <> 'n' then	
	// Se ubica la cabecera		
	dw_master.retrieve(LONG(sl_param.field_ret[1]))
	dw_master.il_row = dw_master.getrow()
	tab_1.tabpage_2.dw_2.Retrieve(LONG(sl_param.field_ret[1]))
	tab_1.tabpage_3.dw_3.Retrieve(LONG(sl_param.field_ret[1]))
	tab_1.tabpage_4.dw_5.Retrieve(LONG(sl_param.field_ret[1]))
END IF
end event

event ue_update_pre;call super::ue_update_pre;// Verifica que campos son requeridos y tengan valores
ib_update_check = False
if f_row_Processing( dw_master, "form") <> true then		
	return
end if

if of_set_numera() = 0 then return
ib_update_check = True

dw_master.of_set_flag_replicacion()
tab_1.tabpage_1.dw_1.of_set_flag_replicacion()
tab_1.tabpage_2.dw_2.of_set_flag_replicacion()
tab_1.tabpage_3.dw_3.of_set_flag_replicacion()
tab_1.tabpage_4.dw_4.of_set_flag_replicacion()
tab_1.tabpage_4.dw_5.of_set_flag_replicacion()
end event

event ue_update;//

Boolean  lbo_ok = TRUE
String	ls_msg

dw_master.AcceptText()
tab_1.tabpage_1.dw_1.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN 
	ROLLBACK USING SQLCA;
	RETURN
END IF

IF ib_log THEN
	dw_master.of_create_log()
	tab_1.tabpage_1.dw_1.of_create_log()
	tab_1.tabpage_2.dw_2.of_create_log()
	tab_1.tabpage_3.dw_3.of_create_log()
	tab_1.tabpage_4.dw_5.of_create_log()
END IF

//Open(w_log)
//lds_log.RowsCopy(1, lds_log.RowCount(),Primary!,w_log.dw_log,1,Primary!)

IF	dw_master.ii_update = 1 THEN	
	IF dw_master.Update(true, false) = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		MessageBox('Error en Base de Datos', 'No se pudo grabar Maestro')
	END IF
END IF

IF	tab_1.tabpage_1.dw_1.ii_update = 1 THEN	
	IF tab_1.tabpage_1.dw_1.Update(true, false) = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		MessageBox('Error en Base de Datos', 'No se pudo grabar tab 1')
	END IF
END IF

IF	tab_1.tabpage_2.dw_2.ii_update = 1 THEN		
	IF tab_1.tabpage_2.dw_2.Update(true, false) = -1 then		// Grabacion del dw2
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		MessageBox('Error en Base de Datos', 'No se pudo grabar tab 2')
	END IF
END IF

IF	tab_1.tabpage_3.dw_3.ii_update = 1 THEN		
	IF tab_1.tabpage_3.dw_3.Update(true, false) = -1 then		// Grabacion del dw2
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		MessageBox('Error en Base de Datos', 'No se pudo grabar tab 4')
	END IF
END IF

IF	tab_1.tabpage_4.dw_5.ii_update = 1 THEN		
	IF tab_1.tabpage_4.dw_5.Update(true, false) = -1 then		// Grabacion del dw2
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		MessageBox('Error en Base de Datos', 'No se pudo grabar tab 4')
	END IF
END IF

IF ib_log THEN
	IF lbo_ok THEN
		dw_master.of_save_log()
		tab_1.tabpage_1.dw_1.of_save_log()
		tab_1.tabpage_2.dw_2.of_save_log()
		tab_1.tabpage_3.dw_3.of_save_log()
		tab_1.tabpage_4.dw_5.of_save_log()
	END IF
	
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
//	if is_action = 'new' then dw_master.reset()
	dw_master.ii_update = 0
	dw_master.il_totdel = 0
	dw_master.ResetUpdate()
	
	tab_1.tabpage_1.dw_1.ii_update = 0
	tab_1.tabpage_1.dw_1.il_totdel = 0
	tab_1.tabpage_1.dw_1.ResetUpdate()
	
	tab_1.tabpage_2.dw_2.ii_update = 0
	tab_1.tabpage_2.dw_2.il_totdel = 0
	tab_1.tabpage_2.dw_2.ResetUpdate()
	
	tab_1.tabpage_3.dw_3.ii_update = 0
	tab_1.tabpage_3.dw_3.il_totdel = 0
	tab_1.tabpage_3.dw_3.ResetUpdate()
	
	tab_1.tabpage_4.dw_5.ii_update = 0
	tab_1.tabpage_4.dw_5.il_totdel = 0
	tab_1.tabpage_4.dw_5.ResetUpdate()
	
END IF
end event

event ue_insert();call super::ue_insert;//// over
//
//Long  ll_row
//
//// controla que primero haya grabado la cabecera, por
//// ser secuencia
//
//if idw_1 <> dw_master then
//	if isnull( dw_master.object.nro_sec_proy[dw_master.getrow()]) then
//		messagebox('Atencion', 'Debera grabar primero la cabecera' )
//		return 
//	end if
//end if
//
//ll_row = idw_1.Event ue_insert()
//
//IF ll_row <> -1 THEN
//	THIS.EVENT ue_insert_pos(ll_row)
//end if
//
end event

event ue_print();//

IF dw_master.rowcount() = 0 then return
Long ll_nro
//str_parametros lstr_rep

//lstr_rep.string2 = dw_master.object.nro_oc[dw_master.getrow()]
ll_nro = dw_master.object.nro_sec_proy[dw_master.getrow()]

OpenSheetWithParm(w_pt305_proyecto_frm, ll_nro, This, 2, original!)
end event

event ue_modify();call super::ue_modify;is_action = 'edit'
end event

type dw_master from w_abc_master_tab`dw_master within w_pt305_proyectos
event ue_display ( string as_columna,  long al_row )
integer width = 2811
integer height = 464
string dataobject = "d_abc_proyectos"
end type

event dw_master::ue_display(string as_columna, long al_row);boolean lb_ret
string ls_codigo, ls_data, ls_sql

choose case lower(as_columna)
		
	case "cencos"
		ls_sql = "SELECT cencos AS CODIGO, " &
				  + "DESC_cencos AS DESCRIPCION " &
				  + "FROM centros_costo " &
				  + "WHERE FLAG_ESTADO = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.cencos		[al_row] = ls_codigo
			this.object.desc_cencos	[al_row] = ls_data
			this.ii_update = 1
		end if

	case "cnta_prsp"
		ls_sql = "SELECT cod_usr AS CODIGO_usuario, " &
				  + "nombre AS nom_usuario " &
				  + "FROM usuario " &
				  + "WHERE FLAG_ESTADO = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.responsable		[al_row] = ls_codigo
			this.object.nom_responsable[al_row] = ls_data
			this.ii_update = 1
		end if
		
end choose

end event

event dw_master::constructor;call super::constructor;ii_ck[1] = 1
ii_dk[1] = 1 

is_dwform = 'form'	

idw_mst  = 	dw_master
end event

event dw_master::itemchanged;call super::itemchanged;String ls_desc, ls_estado, ls_null

SetNull( ls_null)
// Verifica si existe
if dwo.name = "cencos" then	
	Select desc_cencos 
		into :ls_desc
	from centros_costo 
	where cencos = :data
	  and flag_estado = '1';		
	
	if SQLCA.SQLCode = 100 then
		Messagebox( "Error", "Centro de costo no existe o no esta activo", Exclamation!)		
		this.object.cencos		[row] = ls_null
		this.object.des_cencos	[row] = ls_null
		Return 1
	end if
	
	this.object.desc_cencos[row] = ls_desc
	
elseif dwo.name = "responsable" then	
	
	Select nombre 
		into :ls_desc 
	from usuario 
	where cod_usr = :data
	  and flag_estado = '1';
	  
	if SQLCA.SQLCode = 100 then
		Messagebox( "Error", "Código de usuario no existe o no está activo", Exclamation!)		
		this.object.responsable		 [row] = ls_null
		this.object.nom_responsable [row] = ls_null
		Return 1
	end if
	
	this.object.nom_responsable[row] = ls_desc
end if
end event

event dw_master::itemerror;call super::itemerror;return 1
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;string ls_desc

select nombre
	into :ls_desc
from usuario
where cod_usr = :gs_user;

tab_1.tabpage_1.dw_1.enabled = TRUE
this.object.responsable		[al_row] = gs_user
this.object.nom_responsable[al_row] = ls_desc
is_action = 'new'
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

event dw_master::keydwn;call super::keydwn;string 	ls_columna, ls_cadena
integer 	li_column
long 		ll_row

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

type tab_1 from w_abc_master_tab`tab_1 within w_pt305_proyectos
integer x = 0
integer y = 472
integer width = 2894
integer height = 1336
boolean boldselectedtext = true
end type

type tabpage_1 from w_abc_master_tab`tabpage_1 within tab_1
integer width = 2857
integer height = 1208
string text = "Datos Generales"
end type

type dw_1 from w_abc_master_tab`dw_1 within tabpage_1
integer width = 2633
integer height = 1204
string dataobject = "d_abc_proyectos_gen"
end type

event dw_1::constructor;call super::constructor;ii_ck[1] = 1
end event

event dw_1::itemerror;call super::itemerror;return 1
end event

event type long dw_1::dwnenter();// Overr
return 0
end event

type tabpage_2 from w_abc_master_tab`tabpage_2 within tab_1
integer width = 2857
integer height = 1208
string text = "Beneficios"
end type

type dw_2 from w_abc_master_tab`dw_2 within tabpage_2
integer width = 2542
integer height = 1180
string dataobject = "d_abc_proyecto_beneficio"
end type

event dw_2::constructor;call super::constructor;ii_ck[1] = 1
ii_rk[1] = 1 	      // columnas que recibimos del master

//is_dwform = 'tabular'
//ii_ss = 1
is_mastdet = 'd'

idw_mst = dw_master
end event

event dw_2::itemerror;call super::itemerror;return 1
end event

event dw_2::ue_insert_pre;call super::ue_insert_pre;if al_row = 1 then
	this.object.item [al_row] = al_row
elseif al_row > 1 then
	this.object.item [al_row] = this.object.item [al_row] + 1
end if
end event

type tabpage_3 from w_abc_master_tab`tabpage_3 within tab_1
integer width = 2857
integer height = 1208
string text = "Partidas"
end type

type dw_3 from w_abc_master_tab`dw_3 within tabpage_3
integer width = 2610
integer height = 1168
string dataobject = "d_abc_proyecto_partidas"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_3::constructor;call super::constructor;ii_ck[1] = 1
ii_rk[1] = 1 	      // columnas que recibimos del master

//is_dwform = 'tabular'
//ii_ss = 1
is_mastdet = 'd'

idw_mst = dw_master
end event

event dw_3::itemerror;call super::itemerror;return 1
end event

event dw_3::doubleclicked;call super::doubleclicked;String ls_prot, ls_name
str_parametros sl_param

ls_name = dwo.name
ls_prot = this.Describe( ls_name + ".Protect")

IF row = 0 then return

if dwo.name = 'cnta_prsp' and ls_prot = '0' then
	sl_param.dw1 = "d_dddw_cntas_presupuestal"
	sl_param.titulo = "Cuentas Presupuestales"
	sl_param.field_ret_i[1] = 1
	sl_param.field_ret_i[2] = 2

	OpenWithParm( w_search, sl_param)
	sl_param = MESSAGE.POWEROBJECTPARM
	if sl_param.titulo <> 'n' then			
		this.object.cnta_prsp[this.getrow()] = sl_param.field_ret[1]
		this.object.descripcion[this.getrow()] = sl_param.field_ret[2]
		ii_update = 1		// activa flag de modificado
	END IF
end if

end event

event dw_3::itemchanged;call super::itemchanged;Long ll_count
String ls_null, ls_desc

SetNull( ls_null )

if dwo.name = 'cnta_prsp' then
	//Verifica que exista dato ingresado	
	Select descripcion into :ls_desc from presupuesto_cuenta 
	    where cnta_prsp = :data;	
	if sqlca.sqlcode <> 0 then			
		Messagebox( "Error", "Cuenta no existe", Exclamation!)		
		this.object.cnta_prsp[row] = ls_null
		Return 1
	end if		
	this.object.descripcion[row] = ls_desc
end if
end event

type tabpage_4 from w_abc_master_tab`tabpage_4 within tab_1
integer width = 2857
integer height = 1208
string text = "Operaciones"
dw_5 dw_5
end type

on tabpage_4.create
this.dw_5=create dw_5
int iCurrent
call super::create
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_5
end on

on tabpage_4.destroy
call super::destroy
destroy(this.dw_5)
end on

type dw_4 from w_abc_master_tab`dw_4 within tabpage_4
integer width = 1029
integer height = 1180
string dataobject = "d_abc_proyecto_operacion"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_4::constructor;call super::constructor;ii_ck[1] = 1
ii_rk[1] = 1 	      // columnas que recibimos del master

//is_dwform = 'tabular'
//ii_ss = 1
is_mastdet = 'd'

idw_mst = dw_master
end event

event dw_4::doubleclicked;call super::doubleclicked;String ls_prot, ls_name
str_parametros sl_param

ls_name = dwo.name
ls_prot = this.Describe( ls_name + ".Protect")

IF row = 0 then return

if dwo.name = 'cnta_prsp' and ls_prot = '0' then
	sl_param.dw1 = "d_dddw_cntas_presupuestal"
	sl_param.titulo = "Cuentas Presupuestales"
	sl_param.field_ret_i[1] = 1
	sl_param.field_ret_i[2] = 2

	OpenWithParm( w_search, sl_param)
	sl_param = MESSAGE.POWEROBJECTPARM
	if sl_param.titulo <> 'n' then			
		this.object.cnta_prsp[this.getrow()] = sl_param.field_ret[1]
		this.object.descripcion[this.getrow()] = sl_param.field_ret[2]
		ii_update = 1		// activa flag de modificado
	END IF
end if

if dwo.name = 'cod_labor' and ls_prot = '0' then
	sl_param.dw1 = "d_sel_labores"
	sl_param.titulo = "Labores"
	sl_param.field_ret_i[1] = 1
	sl_param.field_ret_i[2] = 2

	OpenWithParm( w_search, sl_param)
	sl_param = MESSAGE.POWEROBJECTPARM
	if sl_param.titulo <> 'n' then			
		this.object.cod_labor[this.getrow()] = sl_param.field_ret[1]
//		this.object.descripcion[this.getrow()] = sl_param.field_ret[2]
		ii_update = 1		// activa flag de modificado
	END IF
end if
end event

event dw_4::itemerror;call super::itemerror;return 1
end event

type dw_5 from u_dw_abc within tabpage_4
integer x = 1047
integer y = 16
integer width = 1797
integer height = 1172
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_abc_proyecto_operacion_form"
end type

event constructor;call super::constructor;ii_ck[1] = 1
ii_rk[1] = 1 	      // columnas que recibimos del master

is_dwform = 'form'
//ii_ss = 1
is_mastdet = 'd'

idw_mst = dw_master
end event

event ue_insert_pre(long al_row);call super::ue_insert_pre;this.object.flag_estado[al_row] = '1'
end event

