$PBExportHeader$w_fl038_incentivos_pers_adm.srw
forward
global type w_fl038_incentivos_pers_adm from w_abc_master_smpl
end type
type dw_detail from u_dw_abc within w_fl038_incentivos_pers_adm
end type
end forward

global type w_fl038_incentivos_pers_adm from w_abc_master_smpl
integer width = 2469
integer height = 2092
string title = "Incentivos Personal Administrativo (FL038)"
string menuname = "m_mto_smpl"
boolean maxbox = false
boolean resizable = false
long backcolor = 67108864
dw_detail dw_detail
end type
global w_fl038_incentivos_pers_adm w_fl038_incentivos_pers_adm

type variables
String      		is_tabla_d, is_colname_d[], is_coltype_d[]
//n_cst_log_diario	in_log_d

end variables

on w_fl038_incentivos_pers_adm.create
int iCurrent
call super::create
if this.MenuName = "m_mto_smpl" then this.MenuID = create m_mto_smpl
this.dw_detail=create dw_detail
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_detail
end on

on w_fl038_incentivos_pers_adm.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_detail)
end on

event ue_update_pre;call super::ue_update_pre;ib_update_check = true

if f_row_processing( dw_master, 'tabular') = false then
	ib_update_check = false
	return
end if

if f_row_processing( dw_detail, 'tabular') = false then
	ib_update_check = false
	return
end if

dw_master.of_set_flag_replicacion()
end event

event ue_open_pre;call super::ue_open_pre;ib_log = TRUE
ii_lec_mst = 0    //Hace que no se haga el retrieve de dw_master

idw_1 = dw_master
idw_1.Retrieve()

is_tabla_d = dw_detail.Object.Datawindow.Table.UpdateTable
dw_detail.SetTransObject(SQLCA)
dw_detail.of_protect()  
end event

event resize;//Overriding
dw_master.width  = newwidth  - dw_master.x - 10
dw_detail.width  = newwidth  - dw_detail.x - 10
dw_detail.height = newheight - dw_detail.y - 10
end event

event ue_update;//Overrding
Boolean  lbo_ok = TRUE
String	ls_msg

dw_master.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF ib_log THEN
	Datastore		lds_log
	lds_log = Create DataStore
	lds_log.DataObject = 'd_log_diario_tbl'
	lds_log.SetTransObject(SQLCA)
	//in_log.of_create_log(dw_master, lds_log, is_colname, is_coltype, gs_user, is_tabla)

	Datastore		lds_log_d
	lds_log_d = Create DataStore
	lds_log_d.DataObject = 'd_log_diario_tbl'
	lds_log_d.SetTransObject(SQLCA)
	//in_log_d.of_create_log(dw_detail, lds_log, is_colname_d, is_coltype_d, gs_user, is_tabla_d)

END IF

IF	dw_master.ii_update = 1 THEN
	IF dw_master.Update() = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		MessageBox('Error en Base de Datos', 'No se pudo grabar Maestro')
	END IF
END IF

IF	dw_detail.ii_update = 1 and lbo_ok THEN
	IF dw_detail.Update() = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		MessageBox('Error en Base de Datos', 'No se pudo grabar Maestro')
	END IF
END IF

IF ib_log THEN
	IF lbo_ok THEN
		IF lds_log.Update() = -1 THEN
			lbo_ok = FALSE
			ROLLBACK USING SQLCA;
			MessageBox('Error en Base de Datos', 'No se pudo grabar dw_master en el Log Diario')
		END IF
		
		IF lds_log_d.Update() = -1 THEN
			lbo_ok = FALSE
			ROLLBACK USING SQLCA;
			MessageBox('Error en Base de Datos', 'No se pudo grabar dw_detail en el Log Diario')
		END IF
	END IF
	DESTROY lds_log
	DESTROY lds_log_d
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0
	dw_master.il_totdel = 0

	dw_detail.ii_update = 0
	dw_detail.il_totdel = 0
END IF

end event

event ue_open_pos;//Overridig
IF ib_log THEN											
	//in_log = Create n_cst_log_diario
	//in_log.of_dw_map(dw_master, is_colname, is_coltype)
	
	//in_log_d = Create n_cst_log_diario
	//in_log_d.of_dw_map(dw_detail, is_colname_d, is_coltype_d)

END IF
end event

type dw_master from w_abc_master_smpl`dw_master within w_fl038_incentivos_pers_adm
event ue_display ( string as_columna,  long al_row )
integer x = 0
integer y = 0
integer width = 2423
integer height = 1140
string dataobject = "d_abc_incent_pers_adm_tbl"
end type

event dw_master::ue_display(string as_columna, long al_row);boolean lb_ret
string ls_codigo, ls_data, ls_sql
choose case lower(as_columna)
		
	case "cod_trabajador"

		ls_sql = "SELECT cod_trabajador AS CODIGO_trabajador, " &
				  + "nom_trabajador AS nombre_trabajador, " &
				  + "DNI as documento_identidad " &
				  + "FROM vw_pr_trabajador " &
				  + "where flag_estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.cod_trabajador	[al_row] = ls_codigo
			this.object.nom_trabajador	[al_row] = ls_data
			this.ii_update = 1
		end if

	case "cod_moneda"

		ls_sql = "SELECT cod_moneda AS CODIGO_moneda, " &
				  + "descripcion AS descripcion_motorista " &
				  + "FROM moneda " &
				  + "where flag_estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.cod_moneda	[al_row] = ls_codigo
			this.ii_update = 1
		end if
end choose

end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.flag_estado			[al_row] = '1'
this.object.cod_usr				[al_row] = gs_user
this.object.ratio_min			[al_row] = 0
this.object.ratio_max			[al_row] = 0
this.object.pesca_considerar	[al_row] = 0

if al_row > 1 then
	this.object.cod_moneda 			[al_row] = this.object.cod_moneda 			[al_row - 1]
	this.object.pesca_considerar 	[al_row] = this.object.pesca_considerar 	[al_row - 1]
	this.object.ratio_min 			[al_row] = this.object.ratio_min			 	[al_row - 1]
	this.object.ratio_max 			[al_row] = this.object.ratio_max		 		[al_row - 1]
end if

end event

event dw_master::itemerror;call super::itemerror;return 1
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
	if li_column <= 0 then return 0

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

event dw_master::itemchanged;call super::itemchanged;string ls_data1, ls_data2, ls_null

SetNull(ls_null)
this.AcceptText()

choose case lower(dwo.name)
	case "cod_trabajador"
		
		select nom_trabajador
			into :ls_data1
		from vw_pr_trabajador
		where cod_trabajador = :data
		  and flag_estado 	= '1';
		
		if SQLCA.SQLCode = 100 then
			Messagebox('FLOTA', "CODIGO DE TRABAJADOR NO EXISTE O NO ESTA ACTIVO", StopSign!)
			this.object.cod_trabajador	[row] = ls_null
			this.object.nom_trabajador	[row] = ls_null
			return 1
		end if

		this.object.nom_trabajador		[row] = ls_data1

	case "cod_moneda"
		
		select descripcion
			into :ls_data1
		from moneda
		where cod_moneda = :data
		  and flag_estado 	= '1';
		
		if SQLCA.SQLCode = 100 then
			Messagebox('FLOTA', "CODIGO DE MONEDA NO EXISTE O NO ESTA ACTIVO", StopSign!)
			this.object.cod_moneda		 [row] = ls_null
			return 1
		end if

end choose
end event

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_ck[2] = 2				// columnas de lectrua de este dw
end event

event dw_master::ue_output;call super::ue_output;dw_detail.Retrieve( this.object.cod_trabajador [al_row] )
end event

event dw_master::clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

type dw_detail from u_dw_abc within w_fl038_incentivos_pers_adm
event ue_display ( string as_columna,  long al_row )
integer y = 1144
integer width = 2423
integer height = 552
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_abc_incentivo_adm_almacen_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
end type

event ue_display(string as_columna, long al_row);boolean lb_ret
string ls_codigo, ls_data, ls_sql
choose case lower(as_columna)
		
	case "almacen"
		
		ls_sql = "SELECT almacen AS CODIGO, " &
				  + "DESC_almacen AS DESCRIPCION " &
				  + "FROM almacen " &
				  + "WHERE FLAG_ESTADO = '1' " &
				  + "and flag_tipo_Almacen = 'P'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.almacen			[al_row] = ls_codigo
			this.object.desc_almacen	[al_row] = ls_data
			this.ii_update = 1
		end if		

end choose

end event

event constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1
ii_ck[2] = 2
end event

event ue_insert_pre;call super::ue_insert_pre;if dw_master.GetRow() = 0 then return
this.object.cod_trabajador[al_row] = dw_master.object.cod_trabajador[dw_master.GetRow()]
end event

event doubleclicked;call super::doubleclicked;string ls_columna
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

event keydwn;call super::keydwn;string ls_columna, ls_cadena
integer li_column
long ll_row

// La tecla F2 despliega el cuadro de ayuda dependiendo de que columna estes ubicado
if key = KeyF2! then
	this.AcceptText()
	li_column = this.GetColumn()
	if li_column <= 0 then return 0

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

event itemerror;call super::itemerror;return 1
end event

event itemchanged;call super::itemchanged;string ls_data1, ls_data2, ls_null

SetNull(ls_null)
this.AcceptText()

choose case lower(dwo.name)
	case "almacen"
		
		select desc_almacen
			into :ls_data1
		from almacen
		where almacen = :data
		  and flag_estado 	= '1'
		  and flag_tipo_almacen = 'P';
		
		if SQLCA.SQLCode = 100 then
			Messagebox('FLOTA', "ALMACEN NO ESTA ACTIVO O NO CORRESPONDE AL TIPO DE MATERIA PRIMA", StopSign!)
			this.object.almacen		 [row] = ls_null
			return 1
		end if

end choose
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
	
end event

