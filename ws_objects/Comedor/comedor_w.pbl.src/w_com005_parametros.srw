$PBExportHeader$w_com005_parametros.srw
forward
global type w_com005_parametros from w_abc_master_smpl
end type
type st_1 from statictext within w_com005_parametros
end type
end forward

global type w_com005_parametros from w_abc_master_smpl
integer width = 2053
integer height = 864
string title = "Parámetros Iniciales (COM005)"
string menuname = "m_mantto_consulta_1"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
st_1 st_1
end type
global w_com005_parametros w_com005_parametros

type variables

		

end variables

on w_com005_parametros.create
int iCurrent
call super::create
if this.MenuName = "m_mantto_consulta_1" then this.MenuID = create m_mantto_consulta_1
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
end on

on w_com005_parametros.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
end on

event ue_open_pre;call super::ue_open_pre;//dw_master.SetTransObject(sqlca)  	// Relacionar el dw con la base de datos
//idw_1 = dw_master              		// asignar dw corriente

idw_1.of_protect( )

ib_update_check = true

ib_log = TRUE
//is_tabla = 'COMEDOR_PARAM'
end event

event ue_update_pre;call super::ue_update_pre;ib_update_check = true

if f_row_processing( dw_master, 'tabular') = false then
	ib_update_check = false
	return
end if

dw_master.of_set_flag_replicacion()

end event

event ue_insert;call super::ue_insert;//STRING ls_rec
//
//select RECKEY
//	into :ls_rec
//from comedor_param;
//
//if ls_rec = '1' then
//	MessageBox('Aviso', 'Ya existen un registro, no puede ingresar mas parametros ',StopSign!)
//	return
//	idw_1.retrieve( )
//	idw_1.of_protect( )
//end if

end event

event ue_query_retrieve;call super::ue_query_retrieve;// Ancestor Script has been Override
idw_1.Retrieve()
idw_1.ii_protect = 0
idw_1.of_protect()         			// bloquear modificaciones 
if idw_1.RowCount() = 0 then 
	idw_1.event ue_insert()
end if

end event

event ue_open_pos;call super::ue_open_pos;IF ib_log THEN											
	//in_log = Create n_cst_log_diario
	//in_log.of_dw_map(idw_1, is_colname, is_coltype)
end if	
end event

event ue_update;call super::ue_update;//Boolean  lbo_ok = TRUE
//String	ls_msg
//
//dw_master.AcceptText()
//
//THIS.EVENT ue_update_pre()
//IF ib_update_check = FALSE THEN RETURN
//
//IF ib_log THEN
//	Datastore		lds_log
//	lds_log = Create DataStore
//	lds_log.DataObject = 'd_log_diario_tbl'
//	lds_log.SetTransObject(SQLCA)
//	in_log.of_create_log(dw_master, lds_log, is_colname, is_coltype, gs_user, is_tabla)
//END IF
//
////Open(w_log)
////lds_log.RowsCopy(1, lds_log.RowCount(),Primary!,w_log.dw_log,1,Primary!)
//
//IF	dw_master.ii_update = 1 THEN
//	IF dw_master.Update() = -1 then		// Grabacion del Master
//		lbo_ok = FALSE
//		ROLLBACK USING SQLCA;
//		MessageBox('Error en Base de Datos', 'No se pudo grabar Maestro')
//	END IF
//END IF
//
//IF ib_log THEN
//	IF lbo_ok THEN
//		IF lds_log.Update() = -1 THEN
//			lbo_ok = FALSE
//			ROLLBACK USING SQLCA;
//			MessageBox('Error en Base de Datos', 'No se pudo grabar el Log Diario')
//		END IF
//	END IF
//	DESTROY lds_log
//END IF
//
//IF lbo_ok THEN
//	COMMIT using SQLCA;
//	dw_master.ii_update = 0
//	dw_master.il_totdel = 0
//END IF

end event

event ue_close_pre;call super::ue_close_pre;IF ib_log THEN
	DESTROY n_cst_log_diario
END IF

end event

event open;call super::open;IF this.of_access(gs_user, THIS.ClassName()) THEN
	THIS.EVENT ue_open_pre()
	THIS.EVENT ue_dw_share()
	THIS.EVENT ue_retrieve_dddw()
ELSE
	CLOSE(THIS)
END IF
end event

type dw_master from w_abc_master_smpl`dw_master within w_com005_parametros
event ue_display ( string as_columna,  long al_row )
integer x = 14
integer y = 212
integer width = 2016
integer height = 468
string dataobject = "d_com_parametros"
boolean hscrollbar = false
boolean vscrollbar = false
boolean livescroll = false
borderstyle borderstyle = styleraised!
end type

event dw_master::ue_display(string as_columna, long al_row);boolean lb_ret
string ls_codigo, ls_data, ls_sql
str_seleccionar lstr_seleccionar

choose case upper(as_columna)
		
	case "CNTA_CTBL"
		
		ls_sql = "SELECT CNTA_CTBL AS CODIGO, " &
				  + "DESC_CNTA AS DESCRIPCION " &
				  + "FROM CNTBL_CNTA " &
				  + "WHERE FLAG_ESTADO = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.cnta_ctbl		[al_row] = ls_codigo
			this.object.desc_cuenta		[al_row] = ls_data
			this.ii_update = 1
		end if

		case "CONFIN"
		
		ls_sql = "SELECT CONFIN AS CODIGO, " &
				  + "DESCRIPCION AS DESCRIPCION " &
				  + "FROM CONCEPTO_FINANCIERO " &
				  + "WHERE FLAG_ESTADO = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.confin		[al_row] = ls_codigo
			this.object.desc_confin [al_row] = ls_data
			this.ii_update = 1
		end if
		
		case "SERVICIO"
		
		ls_sql = "SELECT SERVICIO AS CODIGO, " &
				  + "DESCRIPCION AS DESCRIPCION " &
				  + "FROM SERVICIOS " &
				  + "WHERE FLAG_ESTADO = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.servicio		[al_row] = ls_codigo
			this.object.desc_servicio [al_row] = ls_data
			this.ii_update = 1
		end if
end choose

end event

event dw_master::constructor;call super::constructor;is_dwform = 'form'	// tabular, form (default)
ii_ck[1] = 1				// columnas de lectrua de este dw

end event

event dw_master::getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = this
idw_1.BorderStyle = StyleLowered!
end event

event dw_master::doubleclicked;call super::doubleclicked;string ls_columna
long ll_row 
str_seleccionar lstr_seleccionar

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
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

event dw_master::itemchanged;call super::itemchanged;string ls_codigo, ls_data
this.AcceptText()

if row <= 0 then
	return
end if

choose case upper(dwo.name)
	case "CNTA_CTBL"
		
		ls_codigo = this.object.cnta_ctbl[row]

		SetNull(ls_data)
		select DESC_CNTA
			into :ls_data
		from CNTBL_CNTA
		where CNTA_CTBL = :ls_codigo
		  and flag_estado = '1';
		
		if IsNull(ls_data) or ls_data = "" then
			Messagebox('COMEDORES', "CUENTA CONTABLE NO EXISTE O NO ESTA ACTIVA", StopSign!)
			SetNull(ls_codigo)
			this.object.cnta_ctbl		[row] = ls_codigo
			this.object.desc_cuenta 	[row] = ls_codigo
			return 1
		end if

		this.object.desc_cuenta[row] = ls_data
		
		case "CONFIN"
		
		ls_codigo = this.object.confin[row]

		SetNull(ls_data)
		select DESCRIPCION
			into :ls_data
		from concepto_financiero
		where confin = :ls_codigo
		  and flag_estado = '1';
		
		if IsNull(ls_data) or ls_data = "" then
			Messagebox('COMEDORES', "CONCEPTO FINANCIERO NO EXISTE O NO ESTA ACTIVO", StopSign!)
			SetNull(ls_codigo)
			this.object.confin			[row] = ls_codigo
			this.object.desc_confin 	[row] = ls_codigo
			return 1
		end if

		this.object.desc_confin			[row] = ls_data
		
		case "SERVICIO"
		
		ls_codigo = this.object.servicio[row]

		SetNull(ls_data)
		select DESCRIPCION
			into :ls_data
		from SERVICIOS
		where SERVICIO = :ls_codigo
		  and flag_estado = '1';
		
		if IsNull(ls_data) or ls_data = "" then
			Messagebox('COMEDORES', "SERVICIO NO EXISTE O NO ESTA ACTIVO", StopSign!)
			SetNull(ls_codigo)
			this.object.servicio			[row] = ls_codigo
			this.object.desc_servicio 	[row] = ls_codigo
			return 1
		end if

		this.object.desc_servicio		[row] = ls_data
end choose

end event

event dw_master::itemerror;call super::itemerror;return 1
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;//this.object.origen 	[al_row] = gs_origen
//this.object.fecha		[al_row] = Today()
end event

type st_1 from statictext within w_com005_parametros
integer x = 498
integer y = 60
integer width = 1051
integer height = 92
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 134217729
string text = "Parametros del Sistema"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleshadowbox!
boolean focusrectangle = false
end type

