$PBExportHeader$w_ap009_especie.srw
forward
global type w_ap009_especie from w_abc_master_smpl
end type
type st_1 from statictext within w_ap009_especie
end type
type st_2 from statictext within w_ap009_especie
end type
type dw_detail from u_dw_abc within w_ap009_especie
end type
end forward

global type w_ap009_especie from w_abc_master_smpl
integer width = 2505
integer height = 2720
string title = "Mantenimiento de especies (AP009)"
string menuname = "m_mantto_smpl"
boolean maxbox = false
st_1 st_1
st_2 st_2
dw_detail dw_detail
end type
global w_ap009_especie w_ap009_especie

type variables

end variables

forward prototypes
public function integer of_compara_longitud ()
public function integer of_compara_peso ()
public subroutine of_retrieve (string as_especie)
end prototypes

public function integer of_compara_longitud ();long ll_row, ll_min, ll_max

ll_row = dw_master.getrow()

if ll_row >= 1 then
	ll_min = dw_master.object.longitud_min[ll_row]
	ll_max = dw_master.object.longitud_max[ll_row]
	if ll_min < ll_max then
		return 1
	else
		return 0
	end if
end if
end function

public function integer of_compara_peso ();long ll_row, ll_min, ll_max

ll_row = dw_master.getrow()

if ll_row >= 1 then
	ll_min = dw_master.object.peso_min[ll_row]
	ll_max = dw_master.object.peso_max[ll_row]
	if ll_min < ll_max then
		return 1
	else
		return 0
	end if
end if
end function

public subroutine of_retrieve (string as_especie);dw_master.retrieve(as_especie)
dw_Detail.retrieve(as_especie)

dw_master.ii_update = 0
dw_master.ii_protect = 0
dw_master.of_protect()

dw_Detail.ii_update = 0
dw_Detail.ii_protect = 0
dw_Detail.of_protect()

dw_master.ResetUpdate()
dw_Detail.ResetUpdate()
end subroutine

on w_ap009_especie.create
int iCurrent
call super::create
if this.MenuName = "m_mantto_smpl" then this.MenuID = create m_mantto_smpl
this.st_1=create st_1
this.st_2=create st_2
this.dw_detail=create dw_detail
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.dw_detail
end on

on w_ap009_especie.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.dw_detail)
end on

event ue_open_pre;call super::ue_open_pre;string ls_codigo
ii_lec_mst = 0    //Hace que no se haga el retrieve de dw_master

dw_detail.setTransObject(SQLCA)

// Para el Log Diario

ib_log = TRUE


end event

event resize;//Override
dw_master.width  = newwidth  - dw_master.x - 10

dw_detail.width  = newwidth  - dw_detail.x - 10
dw_detail.height = newheight - dw_detail.y - 10

st_1.X = dw_master.x
st_1.Width = dw_master.width

st_2.X = dw_detail.x
st_2.Width = dw_detail.width
end event

event ue_update_pre;//Override

ib_update_check = False
// Verifica que campos son requeridos y tengan valores
if gnvo_app.of_row_Processing( dw_master) <> true then return

// Verifica que campos son requeridos y tengan valores
if gnvo_app.of_row_Processing( dw_detail ) <> true then	return


dw_master.of_set_flag_replicacion()
dw_detail.of_set_flag_replicacion()


ib_update_check = true
end event

event ue_update;//Override
Boolean lbo_ok = TRUE
String	ls_msg, ls_crlf, ls_especie

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
		messagebox("Error en Grabacion DETALLE", ls_msg, StopSign!)
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
	
	dw_master.ii_protect = 0
	dw_master.of_protect( )
	
	dw_detail.ii_update = 0
	dw_detail.il_totdel = 0
	dw_detail.ResetUpdate()
	
	dw_detail.ii_protect = 0
	dw_detail.of_protect( )
	
	f_mensaje('Grabación realizada satisfactoriamente', '')
	
	if dw_master.getRow() <> 0 then
		ls_especie = dw_master.object.especie [1]
		
		this.of_Retrieve(ls_especie)
	end if
	
END IF


end event

event ue_insert;//Ovrerrida
Long  ll_row

if idw_1 = dw_detail then
	if dw_master.getRow() = 0 then 
		MEssageBox('Error', 'No ha especificado ninguna especie, no puede ingresar articulos', StopSign!)
		return
	end if
	
	
elseif idw_1 = dw_master  then
	if dw_master.ii_update = 1 then
		if MEssageBox('Error', 'Existen cambios pendientes por grabar en especies, ' &
									+ 'Si inserta una nueva especie, va a perder todos los cambios. ' &
									+ 'Desea continuar?', Information!, YesNo!, 2) = 2 then return
	end if
	
	if dw_detail.ii_update = 1 then
		if MEssageBox('Error', 'Existen cambios pendientes en los artículos asignados, ' &
									+ 'Si inserta una nueva especie, va a perder todos los cambios. ' &
									+ 'Desea continuar?', Information!, YesNo!, 2) = 2 then return
	end if
	
	dw_master.reset()
	dw_master.resetUpdate()
	dw_master.ii_update = 0
	
	dw_detail.reset()
	dw_detail.resetUpdate()
	dw_detail.ii_update = 0
end if

ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN
	THIS.EVENT ue_insert_pos(ll_row)
end if

end event

event ue_retrieve_list;boolean lb_ret
string ls_sql, ls_codigo, ls_data


Event Dynamic ue_update_request()

ls_sql = "SELECT ESPECIE AS CODIGO, " &
		 + "DESCR_ESPECIE AS DESCRIPCION " &
		 + "FROM TG_ESPECIES "
				 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
if ls_codigo <> '' then
	This.of_retrieve( ls_codigo )
end if



end event

type dw_master from w_abc_master_smpl`dw_master within w_ap009_especie
event ue_display ( string as_columna,  long al_row )
integer y = 100
integer width = 2432
integer height = 1096
string dataobject = "d_especie_ff"
boolean hscrollbar = false
boolean vscrollbar = false
boolean livescroll = false
end type

event dw_master::ue_display;String 	ls_sql, ls_codigo, ls_Data

str_articulo lstr_articulo

choose case lower(as_columna)
		
	case "cod_art"
		
	  	this.event dynamic ue_update_request()
		  
		lstr_articulo = gnvo_app.almacen.of_get_articulos_all( )
		
		if lstr_articulo.b_Return then
			this.object.cod_art				[al_row] = lstr_articulo.cod_art
			this.object.desc_art				[al_row] = lstr_articulo.desc_art
			
			this.ii_update = 1
		end if

	case "cencos_os"
		ls_sql = "SELECT cencos AS CODIGO_cencos, " &
				  + "desc_cencos AS descripcion_cencos " &
				  + "FROM centros_costo " &
				  + "WHERE FLAG_ESTADO = '1'"

		if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, '2') then
			this.object.cencos_os	[al_row] = ls_codigo
			this.object.desc_cencos	[al_row] = ls_data
			this.ii_update = 1
		end if	
end choose
end event

event dw_master::constructor;call super::constructor;//is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'form'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
//idw_det  =  				// dw_detail
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;string ls_especie

declare lc_especie cursor for
	select max(substr(especie,3,8)) from tg_especies where substr(especie,1,2) = :gs_origen;

open lc_especie;
fetch lc_especie into :ls_especie;
close lc_especie;

if isnull(ls_especie) then
	ls_especie = gs_origen+'000001'
else
	ls_especie = gs_origen+right(string(integer(ls_especie)+1,'000000'),6)
end if

this.object.especie[this.rowcount()] = ls_especie

dw_detail.Reset()
dw_detail.ii_update = 0
dw_detail.ResetUpdate()

is_Action = 'new'
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

event dw_master::itemerror;call super::itemerror;return 1
end event

event dw_master::itemchanged;call super::itemchanged;string ls_data, ls_Null

SetNull(ls_Null)
this.AcceptText()

if row <= 0 then return

choose case lower(dwo.name)
	case "cod_art"

		select nom_articulo
			into :ls_data
		from articulo
		where cod_art = :data
		  and flag_estado = '1';
		  
		if SQLCA.SQLCode = 100 then
			Messagebox('Aviso', "Codigo de Articulo no existe", StopSign!)
			this.object.cod_art		[row] = ls_Null
			this.object.nom_articulo[row] = ls_Null
			return 1
		end if

		this.object.nom_articulo[row] = ls_data

	case 'longitud_min'
		if of_compara_longitud() = 0 then
			this.object.longitud_max[row] = this.object.longitud_min[row] + 1
		end if
		
	case 'longitud_max'
		if of_compara_longitud() = 0 then
			if this.object.longitud_max[row] - 1  >= 0 then
				this.object.longitud_min[row] = this.object.longitud_max[row] - 1
			else
				this.object.longitud_min[row] = this.object.longitud_max[row]
			end if
		end if
		
	case 'peso_min'
		if of_compara_peso() = 0 then
			this.object.peso_max[row] = this.object.peso_min[row] + 1
		end if
		
	case 'peso_ma'
		if of_compara_peso() = 0 then
			if this.object.peso_max[row] - 1  >= 0 then
				this.object.peso_min[row] = this.object.peso_max[row] - 1
			else
				this.object.peso_min[row] = this.object.lpeso_max[row]
			end if
		end if

	CASE 'cencos_os'
		
		// Verifica que codigo ingresado exista			
		Select desc_cencos
	     into :ls_data
		  from centros_costo
		 Where cencos = :data 
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQLCode = 100 then
			this.object.cencos_os	[row] = gnvo_app.is_null
			this.object.desc_cencos	[row] = gnvo_app.is_null
			MessageBox('Error', 'Codigo de CENTROS DE COSTO ' + data + ' no existe o no esta activo, por favor verifique')
			return 1
		end if

		this.object.desc_cencos			[row] = ls_data		
end choose
end event

event dw_master::getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

type st_1 from statictext within w_ap009_especie
integer width = 2432
integer height = 100
boolean bringtotop = true
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 8388608
string text = "ESPECIES"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_2 from statictext within w_ap009_especie
integer y = 1204
integer width = 2432
integer height = 100
boolean bringtotop = true
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 8388608
string text = "ARTICULOS X ESPECIE"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type dw_detail from u_dw_abc within w_ap009_especie
integer y = 1312
integer width = 2432
integer height = 1076
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_abc_especies_articulos_tbl"
borderstyle borderstyle = styleraised!
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

event doubleclicked;call super::doubleclicked;string ls_columna
if not this.is_protect(dwo.name, row) and row > 0 then
	ls_columna = upper(dwo.name)
	THIS.event dynamic ue_display(ls_columna, row)
end if
end event

event ue_display;call super::ue_display;boolean lb_ret
string ls_codigo, ls_data, ls_sql, ls_und, ls_clase_mp, ls_clase_pptt
try 
	choose case lower(as_columna)
		case "cod_art"
			//Obtengo las clases que necesito
			ls_clase_mp 	= gnvo_app.of_get_parametro("CLASE_MATERIA_PRIMA", "03")
			ls_clase_pptt	= gnvo_app.of_get_parametro("CLASE_PPTT", "01")
			
			//Solo materia prima
			ls_sql = "select a.cod_art as codigo_articulo, " &
					 + "a.desc_art as descripcion_articulo, " &
					 + "a.und as unidad " &
					 + "from articulo a " &
					 + "where TRIM(a.cod_clase) IN ('" + ls_clase_mp + "', '" + ls_clase_pptt + "')" &
					 + "  and a.flag_estado = '1'"
	
			lb_ret = gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, ls_und, '2')
	
			if ls_codigo <> '' then
				this.object.cod_art	[al_row] = ls_codigo
				this.object.desc_art	[al_row] = ls_data
				this.object.und		[al_row] = ls_und
				this.ii_update = 1
			end if
	
	
	end choose

catch ( Exception ex )
	gnvo_app.of_catch_exception(ex, 'Listado de articulos para especies')

end try

end event

event itemchanged;call super::itemchanged;String ls_data, ls_und, ls_clase_mp, ls_clase_pptt

try 
	
	ls_clase_mp 	= trim(gnvo_app.of_get_parametro('CLASE_MATERIA_PRIMA', '03'))
	ls_clase_pptt 	= trim(gnvo_app.of_get_parametro('CLASE_PPTT', '01'))
	
	this.Accepttext()
	
	CHOOSE CASE dwo.name
		CASE 'cod_art'
			
			// Verifica que codigo ingresado exista			
			Select desc_art
			  into :ls_data
			  from articulo
			 Where cod_art = :data 
				and flag_estado = '1'
				and TRIM(cod_Clase)	 in (:ls_clase_mp, :ls_clase_pptt);
				
			// Verifica que articulo solo sea de reposicion		
			if SQLCA.SQLCode = 100 then
				
				this.object.cod_art	[row] = gnvo_app.is_null
				this.object.desc_art	[row] = gnvo_app.is_null
				this.object.und		[row] = gnvo_app.is_null
				
				MessageBox('Error', 'Codigo de Artículo no existe, no esta activo o no corresponde ' &
										  + 'a MATERIA PRIMA [' + ls_clase_mp + '] o PRODUCTO TERMINADO [' &
										  + ls_clase_pptt + '], por favor verifique!', StopSign!)
				return 1
			end if
	
			this.object.desc_art			[row] = ls_data
			this.object.und				[row] = ls_und
	
	
	END CHOOSE

catch ( Exception ex )
	gnvo_app.of_catch_exception(ex, "Ha ocurrido una exception")
	
end try


end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event ue_insert_pre;call super::ue_insert_pre;if al_row = 0 then return

this.object.especie [al_row] = dw_master.object.especie [1]
end event

