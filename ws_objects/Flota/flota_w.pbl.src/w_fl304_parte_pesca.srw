$PBExportHeader$w_fl304_parte_pesca.srw
forward
global type w_fl304_parte_pesca from w_abc
end type
type st_titulo from statictext within w_fl304_parte_pesca
end type
type tab_1 from tab within w_fl304_parte_pesca
end type
type tabpage_1 from userobject within tab_1
end type
type dw_tripulantes from u_dw_abc within tabpage_1
end type
type st_tripulantes from statictext within tabpage_1
end type
type st_2 from statictext within tabpage_1
end type
type dw_zarpe from u_dw_abc within tabpage_1
end type
type tabpage_1 from userobject within tab_1
dw_tripulantes dw_tripulantes
st_tripulantes st_tripulantes
st_2 st_2
dw_zarpe dw_zarpe
end type
type tabpage_2 from userobject within tab_1
end type
type st_5 from statictext within tabpage_2
end type
type dw_arribo from u_dw_abc within tabpage_2
end type
type st_ventas from statictext within tabpage_2
end type
type dw_ventas from u_dw_abc within tabpage_2
end type
type tabpage_2 from userobject within tab_1
st_5 st_5
dw_arribo dw_arribo
st_ventas st_ventas
dw_ventas dw_ventas
end type
type tabpage_3 from userobject within tab_1
end type
type tabpage_3 from userobject within tab_1
end type
type tab_1 from tab within w_fl304_parte_pesca
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
end type
end forward

global type w_fl304_parte_pesca from w_abc
integer width = 3474
integer height = 2848
string title = "[FL304] Partes de Pesca"
string menuname = "m_mto_smpl_cslta"
event ue_bitacora ( )
st_titulo st_titulo
tab_1 tab_1
end type
global w_fl304_parte_pesca w_fl304_parte_pesca

type variables
u_dw_abc 		idw_zarpe, idw_arribo, idw_tripulantes, idw_ventas
StaticText		ist_ventas, ist_tripulantes
uo_parte_pesca iuo_parte
end variables

forward prototypes
public subroutine of_asigna_dws ()
public subroutine of_set_titulos ()
public subroutine of_retrieve (string as_parte_pesca)
public function integer of_set_numera ()
end prototypes

event ue_bitacora();string ls_parte, ls_nave
long ll_row
str_parametros lstr_param
w_fl310_bitacora	lw_1

ll_row = idw_zarpe.GetRow()

if ll_row <= 0 then
	if MessageBox('FLOTA', 'NO HA SELECCIONADO NINGUN PARTE DE PESCA.' &
		+ '~r~nDESEA INGRESAR DE TODAS MANERAS UNA BITACORA?', &
		Information!, YesNo!, 2) = 1 then
		
		SetNull(ls_parte)
		SetNull(ls_nave)
	else
		return
	end if
else
	ls_nave  = idw_zarpe.object.nave_real		[ll_row]
	ls_parte = idw_zarpe.object.parte_pesca	[ll_row]
	
	if IsNull(ls_parte) or trim(ls_parte) = '' then
		MessageBox('AViso', 'No ha definido parte de pesca, por favor Verifique')
		return
	end if
	
	if IsNull(ls_nave) or trim(ls_nave) = '' then
		MessageBox('AViso', 'No ha definido Codigo de Nave, por favor Verifique')
		return
	end if
	
end if

lstr_param.string1 = ls_parte
lstr_param.string2 = ls_nave

OpenSheetWithParm(lw_1, lstr_param, w_main, 0, Layered!)
end event

public subroutine of_asigna_dws ();idw_zarpe 			= tab_1.tabpage_1.dw_zarpe
idw_tripulantes 	= tab_1.tabpage_1.dw_tripulantes

idw_arribo			= tab_1.tabpage_2.dw_arribo
idw_ventas			= tab_1.tabpage_2.dw_ventas

ist_tripulantes	= tab_1.tabpage_1.st_tripulantes
ist_ventas			= tab_1.tabpage_2.st_ventas
end subroutine

public subroutine of_set_titulos ();ist_tripulantes.Text = 'TRIPULANTES DEL ZARPE: ' + string(idw_tripulantes.RowCount( ))
ist_ventas.text		= 'DESCARGAS DE LA PESCA CAPTURADA: ' + string(idw_ventas.RowCount())
end subroutine

public subroutine of_retrieve (string as_parte_pesca);idw_zarpe.REset( )
idw_tripulantes.REset( )
idw_ventas.REset( )

idw_zarpe.retrieve(as_parte_pesca)

if idw_zarpe.RowCount() > 0 then
	idw_tripulantes.Retrieve( as_parte_pesca )
	idw_ventas.Retrieve( as_parte_pesca )
end if

idw_zarpe.REsetUpdate( )
idw_tripulantes.REsetUpdate( )
idw_ventas.REsetUpdate( )

idw_zarpe.ii_update = 0
idw_tripulantes.ii_update = 0
idw_ventas.ii_update = 0

return
end subroutine

public function integer of_set_numera (); 
//Numera documento
Long 		ll_ult_nro, ll_i
string	ls_mensaje, ls_nro

if idw_zarpe.RowCount() = 0 then return 1

if is_action = 'new' then

	Select ult_nro 
		into :ll_ult_nro 
	from num_fl_parte_pesca 
	where cod_origen = :gs_origen;
	
	IF SQLCA.SQLCode = 100 then
		ll_ult_nro = 1
		
		Insert into num_fl_parte_pesca (cod_origen, ult_nro)
			values( :gs_origen, 1);
		
		IF SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			gnvo_app.of_message_error('Error al insertar registro en num_fl_parte_pesca: ' + ls_mensaje)
			return 0
		end if
	end if
	
	//Asigna numero a cabecera
	ls_nro = TRIM(gs_origen) + trim(string(ll_ult_nro, '00000000'))
	
	idw_zarpe.object.parte_pesca[idw_zarpe.getrow()] = ls_nro
	
	//Incrementa contador
	Update num_fl_parte_pesca 
		set ult_nro = :ll_ult_nro + 1 
	 where cod_origen = :gs_origen;
	
	IF SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		gnvo_app.of_message_error('Error al actualizar num_fl_parte_pesca: ' + ls_mensaje)
		return 0
	end if
		
else 
	ls_nro = idw_zarpe.object.parte_pesca[idw_zarpe.getrow()] 
end if

for ll_i = 1 to idw_tripulantes.RowCount()
	idw_tripulantes.object.parte_pesca [ll_i] = ls_nro
next

for ll_i = 1 to idw_ventas.RowCount()
	idw_ventas.object.parte_pesca [ll_i] = ls_nro
next


return 1
end function

on w_fl304_parte_pesca.create
int iCurrent
call super::create
if this.MenuName = "m_mto_smpl_cslta" then this.MenuID = create m_mto_smpl_cslta
this.st_titulo=create st_titulo
this.tab_1=create tab_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_titulo
this.Control[iCurrent+2]=this.tab_1
end on

on w_fl304_parte_pesca.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_titulo)
destroy(this.tab_1)
end on

event resize;call super::resize;of_asigna_dws()

st_titulo.width  = newwidth  - st_titulo.x - 10

tab_1.width  = newwidth  - tab_1.x - 10
tab_1.height = newheight - tab_1.y - 10

tab_1.tabpage_1.st_2.width = tab_1.tabpage_1.width - tab_1.tabpage_1.st_2.x - 10
ist_tripulantes.width 		= tab_1.tabpage_1.width - ist_tripulantes.x - 10

idw_zarpe.width = tab_1.tabpage_1.width - idw_zarpe.x - 10
idw_tripulantes.width = tab_1.tabpage_1.width - idw_tripulantes.x - 10
idw_tripulantes.height = tab_1.tabpage_1.height - idw_tripulantes.y - 10

tab_1.tabpage_2.st_5.width = tab_1.tabpage_2.width - tab_1.tabpage_2.st_5.x - 10
ist_ventas.width 				= tab_1.tabpage_2.width - ist_ventas.x - 10

idw_arribo.width = tab_1.tabpage_2.width - idw_arribo.x - 10
idw_ventas.width = tab_1.tabpage_2.width - idw_ventas.x - 10
idw_ventas.height = tab_1.tabpage_2.height - idw_ventas.y - 10


end event

event ue_open_pre;call super::ue_open_pre;of_asigna_dws()

idw_zarpe.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos
idw_arribo.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos
idw_tripulantes.SetTransObject(sqlca)  		// Relacionar el dw con la base de datos
idw_ventas.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos

idw_zarpe.ShareData(idw_arribo)

idw_1 = idw_zarpe
//idw_zarpe.setFocus( )

iuo_parte = create uo_parte_pesca 


end event

event ue_insert;call super::ue_insert;Long  ll_row

IF idw_1 = idw_arribo THEN
	
	gnvo_app.of_message_error("No es posible insertar registros en arribo, si debe ingresar un PARTE DE PESCA nuevo debe ingresar desde el zarpe")
	RETURN
	
elseif idw_1 = idw_zarpe then
	
	if (idw_zarpe.ii_update = 1 or idw_arribo.ii_update = 1 or &
		 idw_tripulantes.ii_update = 1 or idw_ventas.ii_update = 1) then
		 this.event ue_update_request( )
	end if
	
	idw_zarpe.Reset( )
	idw_tripulantes.Reset( )
	idw_ventas.Reset( )
	
	idw_zarpe.ResetUpdate( )
	idw_tripulantes.ResetUpdate( )
	idw_ventas.ResetUpdate( )
	
	idw_zarpe.ii_update = 0
	idw_arribo.ii_update = 0
	idw_tripulantes.ii_update = 0
	idw_ventas.ii_update = 0
	
	ll_row = idw_1.Event ue_insert()

	IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)
	
	is_action = 'new'
	
else
	ll_row = idw_1.Event ue_insert()

	IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)
	
end if



end event

event ue_update_pre;call super::ue_update_pre;
idw_zarpe.AcceptText()
idw_arribo.AcceptText()
idw_tripulantes.AcceptText()
idw_ventas.AcceptText()

ib_update_check = False
// Verifica que campos son requeridos y tengan valores
if gnvo_app.of_row_processing( idw_zarpe ) <> true then return
if gnvo_app.of_row_processing( idw_arribo ) <> true then return
if gnvo_app.of_row_processing( idw_tripulantes ) <> true then return
if gnvo_app.of_row_processing( idw_ventas ) <> true then return

//of_set_total_oc()
if of_set_numera() = 0 then return	

ib_update_check = true
end event

event ue_update;call super::ue_update;Boolean 	lbo_ok = TRUE
String 	ls_parte_pesca

idw_zarpe.AcceptText()
idw_arribo.AcceptText()
idw_tripulantes.Accepttext( )
idw_ventas.accepttext( )

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

if ib_log then
	idw_zarpe.of_create_log()
	idw_tripulantes.of_create_log()
	idw_ventas.of_create_log()
end if

IF idw_zarpe.ii_update = 1 or idw_arribo.ii_update = 1 THEN
	IF idw_zarpe.Update(true, false) = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
	   Rollback ;
		messagebox("Error en Grabacion ZARPE / ARRIBO","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF	idw_tripulantes.ii_update = 1 AND lbo_ok = TRUE THEN
	IF idw_tripulantes.Update(true, false) = -1 then		// Grabacion del Master
		lbo_ok = FALSE
    	Rollback ;
		messagebox("Error en Grabacion TRIPULANTES","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF	idw_ventas.ii_update = 1 AND lbo_ok = TRUE THEN
	IF idw_ventas.Update(true, false) = -1 then		// Grabacion del Master
		lbo_ok = FALSE
    	Rollback ;
		messagebox("Error en Grabacion VENTAS","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF lbo_ok and ib_log THEN
	lbo_ok = idw_zarpe.of_save_log()
	lbo_ok = idw_tripulantes.of_save_log()
	lbo_ok = idw_ventas.of_save_log()
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	
	idw_Zarpe.ii_update = 0
	idw_arribo.ii_update = 0
	idw_tripulantes.ii_update = 0
	idw_ventas.ii_update = 0
	
	idw_Zarpe.ResetUpdate()
	idw_arribo.ResetUpdate()
	idw_tripulantes.ResetUpdate()
	idw_ventas.ResetUpdate()
	
	if idw_zarpe.RowCount() > 0 then
		ls_parte_pesca = idw_zarpe.object.parte_pesca[1]
		this.of_retrieve( ls_parte_pesca )
	end if
	
	f_mensaje("Cambios guardados satisfactoriamente.", "")
	
END IF
end event

event ue_update_request;call super::ue_update_request;Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
IF (idw_zarpe.ii_update = 1 OR idw_arribo.ii_update = 1 or idw_tripulantes.ii_update = 1 or idw_ventas.ii_update = 1) THEN
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	IF li_msg_result = 1 THEN
 		this.TriggerEvent("ue_update")
	ELSE
		idw_zarpe.ii_update = 0
		idw_arribo.ii_update = 0
		idw_tripulantes.ii_update = 0
		idw_ventas.ii_update = 0
	END IF
END IF

end event

event close;call super::close;destroy iuo_parte
end event

event ue_retrieve_list;// Abre ventana pop
THIS.Event ue_update_request()

str_parametros sl_param

sl_param.dw1    = 'd_lista_partes_de_pesca_tbl'
sl_param.titulo = 'PARTES DE PESCA'
sl_param.field_ret_i[1] = 1

OpenWithParm( w_lista, sl_param)
sl_param = MESSAGE.POWEROBJECTPARM
if sl_param.titulo <> 'n' then
	of_retrieve(sl_param.field_ret[1])
END IF
end event

event ue_anular;call super::ue_anular;String	ls_estado

if idw_zarpe.RowCount() = 0 then return

ls_estado = idw_zarpe.object.flag_estado [1]

if ls_estado <> '1' then
	gnvo_app.of_mensaje_error( "El Parte de Pesca no se encuentra activo no es posible anularlo, por favor verifique!")
	return
end if

if MessageBox("Aviso", "Si anula el registro, los datos ingresados no serán considerados en ningún proceso o reporte. Desea Anular el Registro?", Information!, Yesno!, 2) = 2 then return

idw_zarpe.object.flag_estado [1] = '0'
idw_zarpe.ii_update = 1
end event

type st_titulo from statictext within w_fl304_parte_pesca
integer width = 3447
integer height = 120
integer textsize = -16
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "PARTES DE PESCA"
alignment alignment = center!
boolean focusrectangle = false
end type

type tab_1 from tab within w_fl304_parte_pesca
integer y = 128
integer width = 3328
integer height = 2048
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
boolean raggedright = true
boolean focusonbuttondown = true
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.tabpage_3=create tabpage_3
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_3}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
destroy(this.tabpage_3)
end on

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 3291
integer height = 1920
long backcolor = 79741120
string text = "Datos del Zarpe"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_tripulantes dw_tripulantes
st_tripulantes st_tripulantes
st_2 st_2
dw_zarpe dw_zarpe
end type

on tabpage_1.create
this.dw_tripulantes=create dw_tripulantes
this.st_tripulantes=create st_tripulantes
this.st_2=create st_2
this.dw_zarpe=create dw_zarpe
this.Control[]={this.dw_tripulantes,&
this.st_tripulantes,&
this.st_2,&
this.dw_zarpe}
end on

on tabpage_1.destroy
destroy(this.dw_tripulantes)
destroy(this.st_tripulantes)
destroy(this.st_2)
destroy(this.dw_zarpe)
end on

type dw_tripulantes from u_dw_abc within tabpage_1
integer y = 1316
integer width = 3246
integer height = 544
string dataobject = "d_abc_tripulantes_zarpe_tbl"
borderstyle borderstyle = styleraised!
end type

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 1				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
//idw_det  =  				// dw_detail
end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event ue_insert_pre;call super::ue_insert_pre;this.object.fec_registro	[al_row] = gnvo_app.of_fecha_Actual()
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
string ls_codigo, ls_data, ls_sql, ls_nro_censo, ls_fec_vigencia, ls_cargo, ls_Desc_cargo
choose case lower(as_columna)
	case "tripulante"
		  
		ls_sql = "select fl.tripulante as tripulante, " &
				 + "       m.NOM_TRABAJADOR as nombre_tripulante, " &
				 + "       fl.libreta_embarque as matricula, " &
				 + "       fl.fec_vigencia as fecha_vigencia, " &
				 + "		  fl.cargo_tripulante as cargo_tripulante, " &
				 + "		  fc.descr_cargo as descripcion_Cargo " &
				 + "from fl_tripulantes fl," &
				 + "     vw_pr_trabajador m," &
				 + "		fl_cargo_tripulantes fc " &
				 + "where fl.tripulante = m.COD_TRABAJADOR" &
				 + "  and fl.cargo_tripulante = fc.cargo_tripulante (+)" &
				 + "  and fl.flag_estado = '1'"

		lb_ret = f_lista_6ret(ls_sql, ls_codigo, ls_data, ls_nro_censo, ls_fec_vigencia, ls_Cargo, ls_Desc_cargo, '2')

		if ls_codigo <> '' then
			this.object.tripulante			[al_row] = ls_codigo
			this.object.nom_trabajador		[al_row] = ls_data
			this.object.nro_censo			[al_row] = ls_nro_censo
			this.object.fec_vigencia		[al_row] = Date(ls_fec_vigencia)
			this.object.cargo_tripulante 	[al_row] = ls_cargo
			this.object.descr_cargo 		[al_row] = ls_Desc_cargo
			
			this.ii_update = 1
		end if
		
	case "cargo_tripulante"
		ls_sql = "SELECT CARGO_TRIPULANTE AS CODIGO, " &
				 + "DESCR_CARGO AS DESCRIPCION " &
             + "FROM FL_CARGO_TRIPULANTES " &
				 + "WHERE FLAG_ESTADO = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.cargo_tripulante	[al_row] = ls_codigo
			this.object.descr_cargo			[al_row] = ls_data
			this.ii_update = 1
		end if
		
end choose

end event

event itemchanged;call super::itemchanged;string 	ls_codigo, ls_data, ls_tipo, ls_parte, ls_nro_censo, ls_cargo, ls_desc_cargo
long 		ll_row, ll_count
Date		ld_fec_vigencia

this.AcceptText()
choose case upper(dwo.name)
	case "TRIPULANTE"
		
		select m.NOM_TRABAJADOR, fl.libreta_embarque, fl.fec_vigencia, fl.cargo_tripulante, 
				fc.descr_cargo
			into :ls_data, :ls_nro_censo, :ld_fec_vigencia, :ls_cargo, :ls_desc_cargo
		from fl_tripulantes fl,
			  vw_pr_trabajador m,
		     fl_cargo_tripulantes fc
		where fl.tripulante = m.COD_TRABAJADOR  
		  and fl.cargo_tripulante = fc.cargo_tripulante (+)
		  and fl.tripulante = :data
		  and fl.flag_Estado = '1';
		
		if SQLCA.SQLCode = 100 then
			gnvo_app.of_message_error("Código de Tripulante " + data + " no existe o no se encuentra activo, por favor verifiue!")
			
			this.object.tripulante 			[row] = gnvo_app.is_null
			this.object.nom_tripulante 	[row] = gnvo_app.is_null
			this.object.nro_censo 			[row] = gnvo_app.is_null
			this.object.fec_vigencia 		[row] = gnvo_app.id_null
			this.object.cargo_tripulante 	[row] = gnvo_app.is_null
			this.object.descr_cargo 		[row] = gnvo_app.is_null
			
			return 1
		end if
		

		//Obtengo el cargo por defecto del tripulante
		this.object.nom_tripulante 	[row] = ls_data
		this.object.nro_censo 			[row] = ls_nro_censo
		this.object.fec_vigencia 		[row] = ld_Fec_vigencia
		this.object.cargo_tripulante 	[row] = ls_Cargo
		this.object.descr_cargo 		[row] = ls_Desc_cargo

	case "cargo_tripulante"
		
		select descr_cargo
			into :ls_data
		from FL_CARGO_TRIPULANTES
		where cargo_tripulante = :data
		  and flag_estado		  = '1';

		if SQLCA.SQLCode = 100 then
			gnvo_app.of_message_error("Cargo de Tripulante " + data + " no existe o no se encuentra activo, por favor verifiue!")
			
			this.object.cargo_tripulante 	[row] = gnvo_app.is_null
			this.object.descr_cargo 		[row] = gnvo_app.is_null
			
			return 1
		end if
		
		//Obtengo el cargo por defecto del tripulante
		this.object.descr_cargo 		[row] = ls_data

end choose
end event

type st_tripulantes from statictext within tabpage_1
integer y = 1208
integer width = 3214
integer height = 100
integer textsize = -11
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 8388608
string text = "TRIPULANTES DEL ZARPE"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_2 from statictext within tabpage_1
integer width = 3214
integer height = 100
integer textsize = -11
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 8388608
string text = "REGISTRO DE ZARPE"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type dw_zarpe from u_dw_abc within tabpage_1
integer y = 108
integer width = 3214
integer height = 1096
integer taborder = 20
string dataobject = "d_parte_pesca_zarpe_ff"
boolean hscrollbar = false
boolean vscrollbar = false
end type

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
//is_dwform = 'tabular'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
//idw_det  =  				// dw_detail
end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event ue_insert_pre;call super::ue_insert_pre;DateTime	ldt_now

ldt_now = gnvo_app.of_fecha_actual( )

this.object.fec_registro_zarpe 		[al_row] = ldt_now
this.object.fecha_hora_zarpe 			[al_row] = ldt_now
this.object.fecha_hora_est_arribo	[al_row] = ldt_now
this.object.usr_zarpe					[al_row] = gs_user
this.object.unidad						[al_row] = gnvo_app.is_und_hrs
this.object.origen						[al_row] = gs_origen
this.object.flag_zarpe_aprobado		[al_row] = '0'
this.object.flag_arribo_aprobado		[al_row] = '0'
this.object.flag_estado					[al_row] = '1'
this.object.usr_zarpe					[al_row] = gs_user
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
string ls_codigo, ls_data, ls_sql
choose case lower(as_columna)
	case "nave_real"
		ls_sql = "SELECT NAVE AS CODIGO, " &
					 + "NOMB_NAVE AS EMBARCACION " &
					 + "FROM vw_fl_naves_zarpe " &
				  + "WHERE FLAG_ESTADO = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.nave_real		[al_row] = ls_codigo
			this.object.nom_nave_real	[al_row] = ls_data
			this.ii_update = 1
		end if
		
	case "puerto_zarpe"
		ls_sql = "SELECT PUERTO AS CODIGO, " &
					 + "DESCR_PUERTO AS DESCRIPCION " &
					 + "FROM FL_PUERTOS " &
					 + "WHERE FLAG_ESTADO = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.puerto_zarpe		[al_row] = ls_codigo
			this.object.desc_puerto_zarpe	[al_row] = ls_data
			this.ii_update = 1
		end if
		
	case "situac_zarpe"
		ls_sql = "SELECT MOTIVO_MOVIMIENTO AS CODIGO, " &
					 + "DESCR_SITUACION AS DESCRIPCION " &
					 + "FROM FL_MOTIVO_MOVIMIENTO " &
					 + "WHERE FLAG_ESTADO = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.situac_zarpe	[al_row] = ls_codigo
			this.object.motivo_zarpe	[al_row] = ls_data
			this.ii_update = 1
		end if

	case "zona_pesca_zarpe"
		ls_sql = "SELECT ZONA_PESCA AS CODIGO, " &
					 + "DESCR_ZONA AS DESCRIPCION " &
					 + "FROM TG_ZONAS_PESCA " &
					 + "WHERE FLAG_ESTADO = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.zona_pesca_zarpe	[al_row] = ls_codigo
			this.object.desc_zona_zarpe	[al_row] = ls_data
			this.ii_update = 1
		end if

end choose
end event

event itemchanged;call super::itemchanged;string 	ls_codigo, ls_data, ls_tipo, ls_unidad
string 	ls_nave, ls_cencos
datetime ldt_fecha, ldt_fecha_hora_zarpe
time 		lt_time
Long		ll_tiempo

this.AcceptText()

choose case upper(dwo.name)
	case "FECHA_HORA_ARRIBO"
		ldt_fecha_hora_zarpe = DateTime(idw_zarpe.object.fecha_hora_zarpe [1])
		ldt_fecha 				= DateTime(this.object.fecha_hora_zarpe [1])
		
		if ldt_fecha < ldt_fecha_hora_zarpe then
			
			gnvo_app.of_message_error("Fecha y Hora del arribo no puede ser menor a la Fecha y hora del zarpe, por favor corrija")
			
			ldt_fecha 				= DateTime(idw_zarpe.object.fecha_hora_est_arribo [1])
			
			this.object.fecha_hora_zarpe 		[row] = ldt_fecha

			return 1
		end if
		
	case "NAVE_REAL"
		
		select nomb_nave
			into :ls_data
		from vw_fl_naves_zarpe
		where nave = :data
		  and flag_estado = '1';

		if SQLCA.SQLCode = 100  then
			gnvo_app.of_message_error("Código de Nave " + data + " no es propia, no está activo, no existe o ya tiene un zarpe pendiente de arribo")
			this.object.nave_real 		[row] = gnvo_app.is_null
			this.object.nom_nave_real 	[row] = gnvo_app.is_null
			return 1
		end if
		
		// Verifico si antes de zarpar no tenga arribos pendientes
		this.object.nom_nave_real	[row] = ls_data
		
	case "PUERTO_ZARPE"
		
		select descr_puerto
			into :ls_data
		from fl_puertos
		where puerto = :data
		  and flag_estado = '1';

		if SQLCA.SQLCode = 100 then
			gnvo_app.of_message_error("Código de Puerto no existe o no esta activo, por favor verifique!")
			this.object.puerto_zarpe 		[row] = gnvo_app.is_null
			this.object.desc_puerto_zarpe [row] = gnvo_app.is_null
			return 1
		end if
		
		this.object.desc_puerto_zarpe	[row] = ls_data
		
	case "SITUAC_ZARPE"
		
		select descr_situacion
			into :ls_data
		from fl_motivo_movimiento
		where motivo_movimiento = :data
		  and flag_estado = '1';

		if SQLCA.SQLCode = 100 then
			gnvo_app.of_message_error("Código de Motivo de Movimiento " + data + " no existe o no esta activo, por favor verifique!")
			this.object.situac_zarpe	[row] = gnvo_app.is_null
			this.object.motivo_zarpe 	[row] = gnvo_app.is_null
			return 1
		end if
		
		this.object.motivo_zarpe	[row] = ls_data

	case "ZONA_PESCA_ZARPE"
		
		select descr_zona
			into :ls_data
		from tg_zonas_pesca
		where zona_pesca = :data
		  and flag_estado = '1';

		if SQLCA.SQLCode = 100 then
			gnvo_app.of_message_error("Código de Zona de Pesca " + data + " no existe o no esta activo, por favor verifique!")
			this.object.zona_pesca_zarpe	[row] = gnvo_app.is_null
			this.object.desc_zona_zarpe 	[row] = gnvo_app.is_null
			return 1
		end if
		
		this.object.desc_zona_zarpe	[row] = ls_data

	CASE "TIEMPO_EST_OPER", "FECHA_HORA_ZARPE"
		
		ll_tiempo = long(this.object.tiempo_est_oper			[row])
		ls_unidad = trim(this.object.unidad						[row])
		ldt_fecha  = datetime(this.object.fecha_hora_zarpe	[row])

		ldt_fecha = f_relative_date( ldt_fecha, ll_tiempo, ls_unidad )
		
		this.object.fecha_hora_est_arribo[row] = ldt_fecha
	
	
end choose

end event

event buttonclicked;call super::buttonclicked;string ls_parte, ls_nave
str_parametros 		lstr_param
w_fl310_bitacora		lw_1
w_pop_fechas_Zarpe 	lw_2

if row <= 0 then return

choose case lower(dwo.name)
	case "b_bitacora"
		
		ls_nave 	= this.object.nave_real		[row]
		ls_parte = this.object.parte_pesca	[row]
		
		if IsNull(ls_parte) or trim(ls_parte) = '' then
			MessageBox('AViso', 'No ha definido parte de pesca, por favor Verifique')
			return
		end if
		
		if IsNull(ls_nave) or trim(ls_nave) = '' then
			MessageBox('AViso', 'No ha definido Codigo de Nave, por favor Verifique')
			return
		end if
		
		lstr_param.string1 = ls_parte
		lstr_param.string2 = ls_nave
		
		OpenSheetWithParm(lw_1, lstr_param, w_main, 0, Layered!)
	
	case 'b_tripulantes'
		ls_nave 	= this.object.nave_real		[row]
		
		if IsNull(ls_nave) or trim(ls_nave) = '' then
			MessageBox('AViso', 'No ha definido Codigo de Nave, por favor Verifique')
			return
		end if
		
		lstr_param.string1 = ls_nave
		
		OpenWithParm(lw_2, lstr_param)
		
		lstr_param = Message.PowerObjectParm
		
		//Si presiono cancelar o cerro la ventana, entonces simplemente lo regreso
		if not lstr_param.b_return then return
		
		iuo_parte.of_tripulante_zarpe( idw_tripulantes, ls_nave, lstr_param.fecha1)
		
		
end choose

end event

event ue_delete;//Overide

long ll_row = 1

ib_insert_mode = False

IF is_mastdet = 'md' OR is_mastdet = 'dd' THEN ll_row = THIS.Event ue_delete_pre()  // solo si se tiene detalle

IF ll_row = 1 THEN
	ll_row = THIS.DeleteRow (0)
	IF ll_row = -1 then
		messagebox("Error en Eliminacion de Registro","No se ha procedido",exclamation!)
	ELSE
		il_totdel ++
		ii_update = 1								// indicador de actualizacion pendiente
		THIS.Event Post ue_delete_pos()
	END IF
END IF

is_action = 'delete'

RETURN ll_row


end event

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 3291
integer height = 1920
long backcolor = 79741120
string text = "Datos del Arribo"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
st_5 st_5
dw_arribo dw_arribo
st_ventas st_ventas
dw_ventas dw_ventas
end type

on tabpage_2.create
this.st_5=create st_5
this.dw_arribo=create dw_arribo
this.st_ventas=create st_ventas
this.dw_ventas=create dw_ventas
this.Control[]={this.st_5,&
this.dw_arribo,&
this.st_ventas,&
this.dw_ventas}
end on

on tabpage_2.destroy
destroy(this.st_5)
destroy(this.dw_arribo)
destroy(this.st_ventas)
destroy(this.dw_ventas)
end on

type st_5 from statictext within tabpage_2
integer width = 3214
integer height = 100
integer textsize = -11
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 8388608
string text = "REGISTRO DE ARRIBO"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type dw_arribo from u_dw_abc within tabpage_2
event ue_default ( long al_row )
integer y = 108
integer width = 3214
integer height = 1144
string dataobject = "d_parte_pesca_arribo_ff"
boolean hscrollbar = false
boolean vscrollbar = false
borderstyle borderstyle = styleraised!
end type

event ue_default(long al_row);DateTime ldt_now
String	ls_usr_arribo

ldt_now = dateTime(this.object.fec_registro_arribo [al_row])
ls_usr_arribo = this.object.usr_arribo 				[al_row] 

if ISNull(ldt_now) then
	this.object.fec_registro_arribo 	[al_row] = gnvo_App.of_fecha_Actual()
end if

if ISNull(ls_usr_arribo) or trim(ls_usr_arribo) = '' then
	this.object.usr_arribo 				[al_row] = gs_user
end if
end event

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
//is_dwform = 'tabular'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
//idw_det  =  				// dw_detail
end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
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
string ls_codigo, ls_data, ls_sql, ls_nave, ls_cencos

choose case lower(as_columna)
	case "nro_orden"
		ls_nave   = trim( this.object.nave_real[al_row] )
		if ls_nave = "" then
			MessageBox('ERROR', 'DEBES TENER PRIMERO UN CODIGO DE NAVE', StopSign!)
			return 
		end if
		
		if iuo_parte.of_get_tipo_flota( ls_nave ) <> 'P' then
			MessageBox('ERROR', 'LA ORDEN DE TRABAJO SOLO SE ASIGNA A UNA EMBARCACION PROPIA', StopSign!)
			return 
		end if
		
		ls_cencos = iuo_parte.of_get_cencos_nave( ls_nave )
		
		if ls_cencos = "" then
			MessageBox('ERROR', 'LA NAVE PROPIA DEBE TENER ASIGNADO UN CENTRO DE COSTOS', StopSign!)
			return 
		end if

		ls_sql = "SELECT NRO_ORDEN AS CODIGO, " &
				 + "Titulo AS titulo_OT, " &
				 + "DESCRIPCION AS DESCR_ORDEN " &
				 + "FROM VW_FL_OT_NAVE " &
				 + "WHERE NAVE = '" + ls_nave + "'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

		if ls_codigo <> '' then
			this.object.nro_orden	[al_row] = ls_codigo
			this.object.titulo		[al_row] = ls_data
			this.event ue_default( al_row )
			this.ii_update = 1
		end if
		
	case "nave_declarada"
		ls_sql = "SELECT NAVE AS CODIGO, " &
				 + "NOMB_NAVE AS EMBARCACION, " &
				 + "FLAG_TIPO_FLOTA AS TIPO_FLOTA " &
				 + "FROM TG_NAVES " &
				 + "where flag_estado = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.nave_declarada			[al_row] = ls_codigo
			this.object.nom_nave_declarada	[al_row] = ls_data
			this.event ue_default( al_row )
			this.ii_update = 1
		end if
		
	case "puerto_arribo"
		ls_sql = "SELECT PUERTO AS CODIGO, " &
				 + "DESCR_PUERTO AS DESCRIPCION " &
				 + "FROM FL_PUERTOS " &
				 + "WHERE FLAG_ESTADO = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.puerto_arribo			[al_row] = ls_codigo
			this.object.desc_puerto_arribo	[al_row] = ls_data
			this.event ue_default( al_row )
			this.ii_update = 1
		end if

	case "situac_arribo"
		ls_sql = "SELECT MOTIVO_MOVIMIENTO AS CODIGO, " &
				 + "DESCR_SITUACION AS DESCRIPCION " &
				 + "FROM FL_MOTIVO_MOVIMIENTO " &
				 + "WHERE FLAG_ESTADO = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.situac_arribo	[al_row] = ls_codigo
			this.object.motivo_arribo	[al_row] = ls_data
			this.event ue_default( al_row )
			this.ii_update = 1
		end if

	case "zona_pesca_arribo"
		ls_sql = "SELECT ZONA_PESCA AS CODIGO, " &
				 + "DESCR_ZONA AS DESCRIPCION " &
				 + "FROM TG_ZONAS_PESCA " &
				 + "WHERE FLAG_ESTADO = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.zona_pesca_arribo	[al_row] = ls_codigo
			this.object.desc_zona_arribo	[al_row] = ls_data
			this.event ue_default( al_row )
			this.ii_update = 1
		end if
		
end choose


end event

event itemchanged;call super::itemchanged;String ls_data, ls_nave, ls_cencos, ls_data2

this.Accepttext()

CHOOSE CASE dwo.name
	case "nro_orden"
		ls_nave   = trim( this.object.nave_real[row] )
		if ls_nave = "" then
			MessageBox('ERROR', 'DEBES TENER PRIMERO UN CODIGO DE NAVE', StopSign!)
			return 
		end if
		
		if iuo_parte.of_get_tipo_flota( ls_nave ) <> 'P' then
			MessageBox('ERROR', 'LA ORDEN DE TRABAJO SOLO SE ASIGNA A UNA EMBARCACION PROPIA', StopSign!)
			return 
		end if
		
		ls_cencos = iuo_parte.of_get_cencos_nave( ls_nave )
		
		if ls_cencos = "" then
			MessageBox('ERROR', 'LA NAVE PROPIA DEBE TENER ASIGNADO UN CENTRO DE COSTOS', StopSign!)
			return 
		end if

		SELECT Titulo 
			into :ls_data
		FROM VW_FL_OT_NAVE 
		WHERE NAVE = :ls_nave
		  and nro_orden = :data;
		
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQLCode = 100 then
			this.object.nro_orden	[row] = gnvo_app.is_null
			this.object.titulo		[row] = gnvo_app.is_null
			MessageBox('Error', 'Numero de Orden de Trabajo no existe, no esta activo o no esta amarrada a la nave ' + ls_nave + ', por favor verifique')
			return 1
		end if		  

		this.object.titulo		[row] = ls_data
		this.event ue_default( row )

	case "nave_declarada"
		SELECT  NOMB_NAVE,  FLAG_TIPO_FLOTA
			into :ls_data, :ls_data2
		FROM TG_NAVES 
		where nave = :data
		  and flag_estado = '1';
		  
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQLCode = 100 or ls_data2 <> 'P' then
			this.object.nave_declarada		[row] = gnvo_app.is_null
			this.object.nom_nave_declarada[row] = gnvo_app.is_null
			MessageBox('Error', 'La Nave Declarada ' + data + ' no existe, no esta activa o no de la flota propia, por favor verifique')
			return 1
		end if
		
		this.object.nom_nave_declarada[row] = ls_data
		this.event ue_default( row )

	case "puerto_arribo"
		SELECT  DESCR_PUERTO
			into :ls_data
		FROM FL_PUERTOS 
		where PUERTO = :data
		  and flag_estado = '1';
		  
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQLCode = 100 then
			this.object.puerto_arribo		[row] = gnvo_app.is_null
			this.object.desc_puerto_arribo[row] = gnvo_app.is_null
			MessageBox('Error', 'El Código de puerto ' + data + ' no existe o no se encuentra activo, por favor verifique')
			return 1
		end if
		
		this.object.desc_puerto_arribo[row] = ls_data
		this.event ue_default( row )

	case "situac_arribo"
		SELECT  DESCR_SITUACION
			into :ls_data
		FROM FL_MOTIVO_MOVIMIENTO 
		where MOTIVO_MOVIMIENTO = :data
		  and flag_estado = '1';
		  
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQLCode = 100 then
			this.object.situac_arribo		[row] = gnvo_app.is_null
			this.object.motivo_arribo		[row] = gnvo_app.is_null
			MessageBox('Error', 'El Código de motivo de movimiento ' + data + ' no existe o no se encuentra activo, por favor verifique')
			return 1
		end if
		
		this.object.motivo_arribo	[row] = ls_data
		this.event ue_default( row )

	case "zona_pesca_arribo"
		SELECT  DESCR_ZONA
			into :ls_data
		FROM TG_ZONAS_PESCA 
		where ZONA_PESCA = :data
		  and flag_estado = '1';
		  
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQLCode = 100 then
			this.object.zona_pesca_arribo		[row] = gnvo_app.is_null
			this.object.desc_zona_arribo		[row] = gnvo_app.is_null
			MessageBox('Error', 'El Código de ZONA DE ZARPE ' + data + ' no existe o no se encuentra activo, por favor verifique')
			return 1
		end if
		
		this.object.desc_zona_arribo	[row] = ls_data
		this.event ue_default( row )		
	
	case else
		this.event ue_default( row )		
END CHOOSE


end event

type st_ventas from statictext within tabpage_2
integer y = 1256
integer width = 3214
integer height = 100
integer textsize = -11
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 8388608
string text = "DESCARGAS DE LA PESCA CAPTURADA"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type dw_ventas from u_dw_abc within tabpage_2
event type integer ue_validar_venta ( )
integer y = 1364
integer width = 3246
integer height = 544
integer taborder = 20
string dataobject = "d_abc_venta_arribo_tbl"
borderstyle borderstyle = styleraised!
end type

event type integer ue_validar_venta();/*
	Esta funcion valida el total capturado y vendido en cada 
	arribo no supere la capacidad de bodega de la nave
	tambien verifica que no sobrepase la capacidad permitida
	de bodega
*/
long 		ll_row
decimal	ln_cap, ln_real, ln_cast, ln_CapBod, ln_CapPerBod, ln_dcl
string 	ls_nave
date 		ld_fecha

if idw_zarpe.RowCount() = 0 then return 0

ls_nave  = idw_zarpe.object.nave_real [1]
ld_fecha	= Date(idw_arribo.object.fecha_hora_arribo [1])

select nvl(capac_bodega,0), nvl(capac_permitida,0)
	into :ln_CapBod, :ln_CapPerBod
from tg_naves	
where nave = :ls_nave;

ln_cap = 0
ln_dcl = 0
for ll_row = 1 to this.RowCount()
	ln_real 	= dec(this.object.cantidad_real[ll_row])
	ln_cast 	= dec(this.object.cantidad_castigada[ll_row])
	ln_dcl	+= dec(this.object.cantidad_declarada[ll_row])
	ln_cap 	= ln_cap + (ln_real - ln_cast)
next

if ln_cap > ln_CapBod and ln_CapBod <> 0 then
	if MessageBox('FLOTA', 'EN ESTE ARRIBO LA CANTIDAD VENDIDA HA SOBREPASADO LA CAPACIDAD DE BODEGA DE LA NAVE' & 
				+ '~r~nCapacidad de Bodega: ' + string(ln_CapBod) &
				+ '~r~nCapacidad Permitida: ' + string(ln_CapPerBod) &
				+ '~r~nPesca Vendidad: ' + string(ln_cap) &
				+ '~r~nDESEA CONTINUAR INGRESANDO DATOS? ', &
				Information!, YesNo!, 1) = 2 then
		return 1
	end if
end if

if ln_dcl > ln_CapPerBod and ln_CapPerBod <> 0 then
	if MessageBox('FLOTA', 'EN ESTE ARRIBO LA CANTIDAD DECLARADA HA SOBREPASADO LA CAPACIDAD DE BODEGA PERMITIDA DE LA NAVE' & 
				+ '~r~nCapacidad de Bodega: ' + string(ln_CapBod) &
				+ '~r~nCapacidad Permitida: ' + string(ln_CapPerBod) &
				+ '~r~nPesca Vendidad: ' + string(ln_cap) &
				+ '~r~nDESEA CONTINUAR INGRESANDO DATOS? ', &
				Information!, YesNo!, 1) = 2 then
		
		return 1
	end if
end if

if ln_cap > ln_CapPerBod and ln_CapPerBod <> 0 then
	if MessageBox('FLOTA', 'EN ESTE ARRIBO LA CANTIDAD VENDIDA HA SOBREPASADO LA CAPACIDAD DE BODEGA PERMITIDA DE LA NAVE' & 
				+ '~r~nCapacidad de Bodega: ' + string(ln_CapBod) &
				+ '~r~nCapacidad Permitida: ' + string(ln_CapPerBod) &
				+ '~r~nPesca Vendidad: ' + string(ln_cap) &
				+ '~r~nDESEA CONTINUAR INGRESANDO DATOS? ', &
				Information!, YesNo!, 1) = 2 then
		return 1
	end if
end if

return 0
end event

event ue_insert_pre;call super::ue_insert_pre;DateTime	ldt_inicio_descarga, ldt_fin_descarga

ldt_inicio_descarga				= DateTime(idw_arribo.object.fecha_hora_arribo [1])

this.object.fec_registro 			[al_row] = gnvo_app.of_fecha_actual( )



select :ldt_inicio_descarga + 4 / 24
	into :ldt_fin_descarga
from dual;

this.object.hora_inicio_descarga [al_row] = ldt_inicio_descarga
this.object.hora_fin_descarga 	[al_row] = ldt_fin_descarga


this.object.unidad				[al_row] = gnvo_app.is_und_ton
this.object.cod_usr				[al_row] = gs_user
this.object.precio_unitario	[al_Row] = 0.00
this.object.cantidad_castigada[al_Row] = 0.00
this.object.cantidad_declarada[al_Row] = 0.00
this.object.cantidad_real		[al_Row] = 0.00
this.object.cantidad_estimada	[al_Row] = 0.00


this.object.cod_moneda		[al_row] = gnvo_app.is_soles
this.object.cod_moneda_1	[al_row] = gnvo_app.is_soles
this.object.cod_moneda_2	[al_row] = gnvo_app.is_soles
this.object.flag_destino	[al_row] = 'H'
end event

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
//is_dwform = 'tabular'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw
ii_ck[3] = 3				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
//idw_det  =  				// dw_detail
end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
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
string ls_codigo, ls_data, ls_sql
choose case lower(as_columna)
	case "cliente"
		ls_sql = "SELECT CLIENTE AS CODIGO, " &
				 + "NOM_PROVEEDOR AS PROVEEDOR " &
             + "FROM vW_FL_NOMB_CLIENTE"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

		if ls_codigo <> '' then
			this.object.cliente	[al_row] = ls_codigo
			this.object.nom_proveedor	[al_row] = ls_data
			this.ii_update = 1
		end if
		
	case "especie"
		ls_sql = "SELECT ESPECIE AS CODIGO, " &
				 + "DESCR_ESPECIE AS DESCRIPCION " &
             + "FROM TG_ESPECIES " &
				 + "where flag_estado = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.especie			[al_row] = ls_codigo
			this.object.descr_especie	[al_row] = ls_data
			this.ii_update = 1
		end if
		
	case "unidad"
		ls_sql = "SELECT UND AS CODIGO, " &
				 + "DESC_UNIDAD AS DESCRIPCION " &
             + "FROM UNIDAD " &
				 + "where flag_estado = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.unidad	[al_row] = ls_codigo
			this.ii_update = 1
		end if

	case "cod_moneda"
		ls_sql = "SELECT COD_MONEDA AS CODIGO, " &
				 + "DESCRIPCION AS NOMBRE_MONEDA " &
             + "FROM MONEDA " &
				 + "where flag_estado = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.cod_moneda	[al_row] = ls_codigo
			this.ii_update = 1
		end if

end choose
end event

event itemchanged;call super::itemchanged;String 	ls_data
decimal 	ln_estim, ln_real, ln_cast, ln_dcl
DateTime	ldt_hora_fin_descarga, ldt_hora_inicio_descarga

this.Accepttext()

CHOOSE CASE dwo.name
	CASE 'cliente'
		
		// Verifica que codigo ingresado exista			
		Select nom_proveedor
	     into :ls_data
		  from vW_FL_NOMB_CLIENTE
		 Where cliente = :data;
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQLCode = 100 then
			this.object.cliente			[row] = gnvo_app.is_null
			this.object.nom_proveedor	[row] = gnvo_app.is_null
			MessageBox('Error', 'Codigo de Cliente no existe o no esta activo, por favor verifique')
			return 1
		end if

		this.object.nom_proveedor			[row] = ls_data

	CASE 'especie'
		
		// Verifica que codigo ingresado exista			
		Select descr_especie
	     into :ls_data
		  from tg_especies
		 Where especie = :data 
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQLCode = 100 then
			this.object.especie			[row] = gnvo_app.is_null
			this.object.descr_especie	[row] = gnvo_app.is_null
			
			MessageBox('Error', 'Código de Especie no existe o no esta activo, por favor verifique')
			return 1
		end if
		this.object.descr_especie	[row] = ls_data
		
	CASE 'unidad'
		
		// Verifica que codigo ingresado exista			
		Select desc_unidad
	     into :ls_data
		  from unidad
		 Where und = :data 
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQLCode = 100 then
			this.object.unidad			[row] = gnvo_app.is_null
			MessageBox('Error', 'Código de Unidad no existe o no esta activo, por favor verifique')
			return 1
		end if

	CASE 'cod_moneda'
		
		// Verifica que codigo ingresado exista			
		Select descripcion
	     into :ls_data
		  from moneda
		 Where cod_moneda = :data 
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQLCode = 100 then
			this.object.cod_moneda		[row] = gnvo_app.is_null
			this.object.cod_moneda_1	[row] = gnvo_app.is_null
			this.object.cod_moneda_2	[row] = gnvo_app.is_null
			MessageBox('Error', 'Código de Moneda no existe o no esta activo, por favor verifique')
			return 1
		end if
		
		this.object.cod_moneda_1	[row] = data
		this.object.cod_moneda_2	[row] = data

	CASE 'cantidad_estimada'
		
		ln_estim = dec(this.object.cantidad_estimada	[row])
		ln_real 	= dec(this.object.cantidad_real		[row])
		ln_cast 	= dec(this.object.cantidad_castigada[row])
		ln_dcl	= dec(this.object.cantidad_declarada[row])
		
		if ln_real = 0 then
			this.object.cantidad_real[row] = ln_estim
			ln_real = ln_estim
		end if
		if ln_dcl = 0 then
			this.object.cantidad_declarada[row] = ln_real - ln_cast
		end if

	CASE 'cantidad_real'
		
		ln_real 	= dec(this.object.cantidad_real[row])
		ln_cast 	= dec(this.object.cantidad_castigada[row])
		ln_dcl	= dec(this.object.cantidad_declarada[row])
		
		this.object.cantidad_declarada[row] = ln_real - ln_cast
		
		this.event ue_validar_venta()
		
	CASE 'cantidad_castigada'
		
		ln_real 	= dec(this.object.cantidad_real[row])
		ln_cast 	= dec(this.object.cantidad_castigada[row])
		ln_dcl	= dec(this.object.cantidad_declarada[row])
		
		this.object.cantidad_declarada[row] = ln_real - ln_cast
		
		this.event ue_validar_venta( )
		
	CASE 'hora_fin_descarga'
		
		ldt_hora_fin_descarga 		= DateTime(this.object.hora_fin_Descarga 		[row])
		ldt_hora_inicio_descarga 	= DateTime(this.object.hora_inicio_descarga 	[row])
				
		// Verifica que articulo solo sea de reposicion		
		if ldt_hora_fin_descarga < ldt_hora_inicio_descarga then
			MessageBox('Error', 'La hora de fin de descarga no puede ser menor a la hora de inicio de descarga, por favor verifique')
			
			this.object.hora_fin_Descarga			[row] = gnvo_app.idt_null
		
			return 1
		end if

END CHOOSE

end event

type tabpage_3 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 3291
integer height = 1920
long backcolor = 79741120
string text = "Consumos Diversos"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
end type

