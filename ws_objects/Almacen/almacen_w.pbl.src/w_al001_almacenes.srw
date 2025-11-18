$PBExportHeader$w_al001_almacenes.srw
forward
global type w_al001_almacenes from w_abc_master
end type
type dw_lista from u_dw_list_tbl within w_al001_almacenes
end type
type dw_detail from u_dw_abc within w_al001_almacenes
end type
type st_almacen from statictext within w_al001_almacenes
end type
type st_usuarios from statictext within w_al001_almacenes
end type
end forward

global type w_al001_almacenes from w_abc_master
integer width = 4503
integer height = 2512
string title = "Mantenimiento de Almacenes (AL001)"
string menuname = "m_mantenimiento_sl"
dw_lista dw_lista
dw_detail dw_detail
st_almacen st_almacen
st_usuarios st_usuarios
end type
global w_al001_almacenes w_al001_almacenes

type variables
n_cst_utilitario invo_utility
end variables

forward prototypes
public subroutine of_retrieve (string as_almacen)
end prototypes

public subroutine of_retrieve (string as_almacen);dw_master.retrieve(as_almacen)

dw_detail.Retrieve(as_almacen)


dw_master.ii_update = 0
dw_detail.ii_update = 0

dw_master.Resetupdate()
dw_detail.ResetUpdate()

dw_master.ii_protect = 0
dw_detail.ii_protect = 0

dw_master.of_protect()
dw_detail.of_protect()
end subroutine

on w_al001_almacenes.create
int iCurrent
call super::create
if this.MenuName = "m_mantenimiento_sl" then this.MenuID = create m_mantenimiento_sl
this.dw_lista=create dw_lista
this.dw_detail=create dw_detail
this.st_almacen=create st_almacen
this.st_usuarios=create st_usuarios
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_lista
this.Control[iCurrent+2]=this.dw_detail
this.Control[iCurrent+3]=this.st_almacen
this.Control[iCurrent+4]=this.st_usuarios
end on

on w_al001_almacenes.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_lista)
destroy(this.dw_detail)
destroy(this.st_almacen)
destroy(this.st_usuarios)
end on

event ue_open_pre;call super::ue_open_pre;
dw_master.setTransobject( SQLCA )
dw_detail.setTransobject( SQLCA )
dw_lista.setTransobject( SQLCA )

dw_lista.Retrieve()

if dw_lista.RowCount() >0 then
	dw_lista.setRow(1)
	dw_lista.SelectRow(0, false)
	dw_lista.SelectRow(1, true)
	dw_lista.ScrollToRow(1)
end if
end event

event ue_update_pre;call super::ue_update_pre;// Verifica que campos son requeridos y tengan valores
ib_update_check = False

if gnvo_app.of_row_Processing( dw_master ) <> true then return
if gnvo_app.of_row_Processing( dw_detail ) <> true then return

dw_master.of_set_flag_replicacion( )
dw_detail.of_set_flag_replicacion( )

ib_update_check = True
end event

event ue_modify();call super::ue_modify;int li_protect

li_protect = integer(dw_master.Object.almacen.Protect)

IF li_protect = 0 THEN
   dw_master.Object.almacen.Protect = 1
END IF
end event

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - 10
st_almacen.width  = newwidth  - st_almacen.x - 10

dw_detail.width  = newwidth  - dw_detail.x - 10
dw_detail.height = newheight - dw_detail.y - 10
st_usuarios.width  = newwidth  - st_usuarios.x - 10

dw_lista.height = newheight - dw_lista.y - 10
end event

event ue_insert;//Override
Long  	ll_row
String	ls_almacen

choose case idw_1
	case dw_detail
		if dw_master.getRow() = 0 then
			gnvo_app.of_mensaje_error("No hay registro seleccionado en el panel maestro")
			return
		end if
		ls_almacen = dw_master.object.almacen[dw_master.getRow()]
		
		if IsNull(ls_almacen) or trim(ls_almacen) = '' then
			gnvo_app.of_mensaje_error("Debe seleccionar primero un almacen")
			dw_master.setFocus()
			dw_master.setColumn("almacen")
			return
		end if
		
	case dw_master
		if dw_detail.ii_update = 1 then
			if MessageBox("Aviso", "Hay cambios pendientes por grabar en el panel de usuarios", Information!, YesNo!, 2) = 1 then
				event ue_update()
				
			end if
		end if
		
		dw_master.Reset()
		dw_detail.reset()
		
		dw_master.ResetUpdate()
		dw_detail.ResetUpdate()
		
		dw_master.ii_update = 0
		dw_detail.ii_update = 0
		
end choose

ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN
	THIS.EVENT ue_insert_pos(ll_row)
end if

end event

event ue_update_request;//Override
Integer li_msg_result

IF dw_master.ii_update = 1 or dw_detail.ii_update = 1 THEN
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	IF li_msg_result = 1 THEN
 		THIS.EVENT ue_update()
	else
		ib_update_check = true
	END IF
END IF


end event

event ue_update;//Overide
Boolean lbo_ok = TRUE
String	ls_msg, ls_crlf

ls_crlf = char(13) + char(10)
dw_master.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF ib_log THEN
	dw_master.of_create_log()
	dw_detail.of_create_log()
END IF

IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_master.Update(true, false) = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion Master", ls_msg, StopSign!)
	END IF
END IF

IF	dw_detail.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_detail.Update(true, false) = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion Detail", ls_msg, StopSign!)
	END IF
END IF

IF ib_log THEN
	IF lbo_ok THEN
		lbo_ok = dw_master.of_save_log()
		lbo_ok = dw_detail.of_save_log()
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0
	dw_master.il_totdel = 0
	dw_master.ResetUpdate()
	
	dw_detail.ii_update = 0
	dw_detail.il_totdel = 0
	dw_detail.ResetUpdate()
	
	dw_master.ii_protect = 0
	dw_master.of_protect( )
	
	dw_detail.ii_protect = 0
	dw_detail.of_protect( )
	
	f_mensaje('Grabación realizada satisfactoriamente', '')
	
	this.event ue_retrieve()
	
END IF



//Boolean  lbo_ok = TRUE
//String	ls_msg
//
//dw_master.AcceptText()
//
//THIS.EVENT ue_update_pre()
//IF ib_update_check = FALSE THEN RETURN
//
//IF ib_log THEN
//	u_ds_base		lds_log
//	lds_log = Create u_ds_base
//	lds_log.DataObject = 'd_log_diario_tbl'
//	lds_log.SetTransObject(SQLCA)
//	
//	IF ISNull(in_log) THEN											
//		in_log = Create n_cst_log_diario
//		in_log.of_dw_map(idw_1, is_colname, is_coltype)
//	END IF
//	
//	in_log.of_create_log(dw_master, lds_log, is_colname, is_coltype, gs_user, is_tabla)
//END IF
//
////Open(w_log)
////lds_log.RowsCopy(1, lds_log.RowCount(),Primary!,w_log.dw_log,1,Primary!)
//
//IF	dw_master.ii_update = 1 THEN
//	IF dw_master.Update(true, false) = -1 then		// Grabacion del Master
//		lbo_ok = FALSE
//		ROLLBACK USING SQLCA;
//		MessageBox('Error en Base de Datos', 'No se pudo grabar Maestro')
//	END IF
//END IF
//
//IF ib_log THEN
//	IF lbo_ok THEN
//		IF lds_log.Update(true, false) = -1 THEN
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
//	
//	dw_master.ResetUpdate( )
//END IF
//
end event

type dw_master from w_abc_master`dw_master within w_al001_almacenes
event ue_display ( string as_columna,  long al_row )
integer x = 2144
integer y = 96
integer width = 2121
integer height = 968
string dataobject = "d_abc_almacen_ff"
boolean hscrollbar = false
boolean vscrollbar = false
borderstyle borderstyle = styleraised!
end type

event dw_master::ue_display;boolean 		lb_ret
string 		ls_codigo, ls_data, ls_sql
str_ubigeo	lstr_ubigeo

choose case lower(as_columna)

	case "ubigeo_org"
		lstr_ubigeo = invo_utility.of_get_ubigeo()
		
		if lstr_ubigeo.b_return then
			
			this.object.ubigeo_org	[al_row] = lstr_ubigeo.codigo
			this.object.desc_ubigeo	[al_row] = lstr_ubigeo.descripcion
			
			this.object.distrito		[al_row] = lstr_ubigeo.desc_distrito
			this.object.provincia	[al_row] = lstr_ubigeo.desc_provincia
			this.object.departamento[al_row] = lstr_ubigeo.desc_departamento
			
			this.ii_update = 1
		end if
		
	case "prov_almacen"
		ls_sql = "SELECT proveedor AS CODIGO_proveedor, " &
				  + "nom_proveedor AS nombre_proveedor " &
				  + "FROM proveedor " &
				  + "WHERE FLAG_ESTADO = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

		if ls_codigo <> '' then
			this.object.prov_almacen	[al_row] = ls_codigo
			this.object.nom_proveedor	[al_row] = ls_data
			
			this.ii_update = 1
		end if
		
	case "cencos"
		ls_sql = "SELECT cencos AS CODIGO_cencos, " &
				  + "desc_cencos AS descripcion_cencos " &
				  + "FROM centros_costo " &
				  + "WHERE FLAG_ESTADO = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.cencos		[al_row] = ls_codigo
			this.object.desc_cencos	[al_row] = ls_data
			this.ii_update = 1
		end if
		
	case "cod_origen"
		ls_sql = "SELECT cod_origen AS CODIGO_origen, " &
				  + "nombre AS descripcion_origen " &
				  + "FROM origen " &
				  + "WHERE FLAG_ESTADO = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.cod_origen	[al_row] = ls_codigo
			this.object.nom_origen	[al_row] = ls_data
			this.ii_update = 1
		end if

	case "cod_responsable"
		ls_sql = "SELECT cod_usr AS CODIGO_usuario, " &
				  + "NOMBRE AS nombre_usuario " &
				  + "FROM usuario " &
				  + "WHERE FLAG_ESTADO = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.cod_responsable	[al_row] = ls_codigo
			this.object.nom_usuario			[al_row] = ls_data
			this.ii_update = 1
		end if

end choose
end event

event dw_master::constructor;call super::constructor;ii_ck[1] = 1			// columnas de lectura de este dw
ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

is_dwform = 'form'

end event

event dw_master::itemerror;call super::itemerror;Return 1  // Fuerza a no mostrar ventana de error
end event

event dw_master::doubleclicked;call super::doubleclicked;string ls_columna
long ll_row 
this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row
if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if
Send(Handle(this),256,9,Long(0,0))   // fuerza a dar enter
end event

event dw_master::itemchanged;call super::itemchanged;String ls_null
Long ll_count

dw_master.Accepttext()
Accepttext()
str_ubigeo	lstr_ubigeo

CHOOSE CASE dwo.name
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
			this.object.distrito			[row] = gnvo_app.is_null
			this.object.provincia		[row] = gnvo_app.is_null
			this.object.departamento	[row] = gnvo_app.is_null
			MessageBox('Error', 'Codigo de UBIGEO ' + data + ' no existe o no esta activo, por favor verifique')
			return 1
		end if
  
		this.object.desc_ubigeo	[row] = lstr_ubigeo.descripcion
		
		this.object.distrito		[row] = lstr_ubigeo.desc_distrito
		this.object.provincia	[row] = lstr_ubigeo.desc_provincia
		this.object.departamento[row] = lstr_ubigeo.desc_departamento
		
		
	CASE 'cod_responsable'
		String ls_usuario_nombre
		
		// Verifica que codigo ingresado exista			
		Select count(*), nombre
	     into :ll_count, :ls_usuario_nombre
		  from usuario
		 Where cod_usr = :data 
		 group by nombre ;			
			
		// Verifica que articulo solo sea de reposicion		
		if ll_count > 0 then
			this.object.nom_usuario		[row] = ls_usuario_nombre
			return 2
		else
			Messagebox( "Error", "Usuario no existe")
			this.object.cod_responsable[row] = ls_null
			this.object.nom_usuario		[row] = ls_null
			return 1
		end if

	CASE 'cencos' 
		string ls_cencos_nombre
		// Verifica que centro_costo exista
		Select count(*), desc_cencos
	     into :ll_count, :ls_cencos_nombre
		  from centros_costo
		  Where cencos = :data 
		  group by desc_cencos ;
		
		if ll_count > 0 then
			this.object.desc_cencos[row] = ls_cencos_nombre
			return 2
		else
			Messagebox( "Error", "Centro de costo no existe")
			this.object.cencos		[row] = ls_null
			this.object.desc_cencos	[row] = ls_null			
			return 1
		end if
		
	CASE "cod_origen" 
		string ls_origen_nombre
		//Verifica que exista dato ingresado	
		Select count(*), nombre
	     into :ll_count, :ls_origen_nombre
		  from origen
		  Where cod_origen = :data 
		  group by nombre ;
					
		If ll_count > 0 then
			this.object.nom_origen	[row] = ls_origen_nombre
			Return 2
		else
			Messagebox( "Error", "Origen no existe")
			this.object.cod_origen	[row] = ls_null
			this.object.nom_origen	[row] = ls_null
			return 1
		end if	
END CHOOSE


end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;string ls_desc

select nombre
	into :ls_desc
from origen
where cod_origen = :gs_origen;

this.object.cod_origen 			[al_row] = gs_origen
this.object.nom_origen 			[al_row] = ls_desc
this.object.flag_estado			[al_row] = '1'
this.object.flag_cntrl_lote 	[al_row] = '0'

dw_detail.ResetUpdate()
dw_detail.Reset()
dw_detail.ii_update = 0

is_Action = 'new'

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

event dw_master::getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

type dw_lista from u_dw_list_tbl within w_al001_almacenes
integer width = 2126
integer height = 1968
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_abc_almacen_tbl"
end type

event constructor;call super::constructor;
ii_ck[1] = 1         // columnas de lectura de este dw
ii_dk[1] = 1 	      // columnas que se pasan al detalle

end event

event ue_output;call super::ue_output;String ls_almacen
if al_row = 0 then return

ls_almacen = this.object.almacen [al_row]

of_retrieve(ls_almacen)




end event

event rowfocuschanged;call super::rowfocuschanged;
IF ii_ss = 1 THEN		// solo para seleccion individual			
	il_row = currentrow                    // fila corriente
	This.SelectRow(0, False)
	This.SelectRow(currentrow, True)
	THIS.SetRow(currentrow)
	THIS.Event ue_output(currentrow)
	RETURN 
END IF
end event

type dw_detail from u_dw_abc within w_al001_almacenes
integer x = 2144
integer y = 1156
integer width = 2121
integer height = 976
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_abc_almacen_usuario_tbl"
end type

event constructor;call super::constructor;//is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
//idw_det  =  				// dw_detail
end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event ue_display;call super::ue_display;boolean lb_ret
string ls_codigo, ls_data, ls_sql
choose case lower(as_columna)
	case "cod_usr"
		ls_sql = "select cod_usr as codigo_usuario, " &
				 + "nombre as nombre_usuario " &
				 + "from usuario " &
				 + "where flag_estado = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

		if ls_codigo <> '' then
			this.object.cod_usr		[al_row] = ls_codigo
			this.object.nom_usuario	[al_row] = ls_data
			this.ii_update = 1
		end if
		
	
end choose
end event

event itemchanged;call super::itemchanged;String ls_data

this.Accepttext()

CHOOSE CASE dwo.name
	CASE 'cod_usr'
		
		// Verifica que codigo ingresado exista			
		Select nombre
	     into :ls_data
		  from usuario
		 Where cod_usr = :data 
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQLCode = 100 then
			this.object.cod_usr		[row] = gnvo_app.is_null
			this.object.nom_usuario	[row] = gnvo_app.is_null
			MessageBox('Error', 'Codigo de usuario ' + data + ' no existe o no esta activo, por favor verifique')
			return 1
		end if

		this.object.nom_usuario			[row] = ls_data

	
END CHOOSE
end event

event doubleclicked;call super::doubleclicked;string ls_columna
if not this.is_protect(dwo.name, row) and row > 0 then
	ls_columna = upper(dwo.name)
	THIS.event dynamic ue_display(ls_columna, row)
end if
end event

event ue_insert_pre;call super::ue_insert_pre;if dw_master.getRow() = 0 then return

this.object.almacen [al_row] = dw_master.object.almacen [dw_master.getRow()]
end event

type st_almacen from statictext within w_al001_almacenes
integer x = 2144
integer y = 4
integer width = 2121
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 67108864
long backcolor = 8388608
boolean enabled = false
string text = "Datos del almacen"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_usuarios from statictext within w_al001_almacenes
integer x = 2149
integer y = 1072
integer width = 2121
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 67108864
long backcolor = 8388608
boolean enabled = false
string text = "Usuarios"
alignment alignment = center!
boolean focusrectangle = false
end type

