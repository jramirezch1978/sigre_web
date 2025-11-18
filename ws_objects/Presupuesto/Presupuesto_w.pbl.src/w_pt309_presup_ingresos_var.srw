$PBExportHeader$w_pt309_presup_ingresos_var.srw
forward
global type w_pt309_presup_ingresos_var from w_abc
end type
type sle_nro from singlelineedit within w_pt309_presup_ingresos_var
end type
type cb_2 from commandbutton within w_pt309_presup_ingresos_var
end type
type st_2 from statictext within w_pt309_presup_ingresos_var
end type
type dw_master from u_dw_abc within w_pt309_presup_ingresos_var
end type
end forward

global type w_pt309_presup_ingresos_var from w_abc
integer width = 2382
integer height = 1388
string title = "Variaciones Presupuesto Ingresos (PT309)"
string menuname = "m_mantenimiento_cl"
sle_nro sle_nro
cb_2 cb_2
st_2 st_2
dw_master dw_master
end type
global w_pt309_presup_ingresos_var w_pt309_presup_ingresos_var

type variables
end variables

forward prototypes
public subroutine of_set_status_reg ()
public subroutine of_retrieve (string as_nro)
public function integer of_set_numera ()
end prototypes

public subroutine of_set_status_reg ();/*
  Funcion que verifica el status del documento
*/
Int li_estado

this.changemenu(m_mantenimiento_cl)

// Activa todas las opciones
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
m_master.m_file.m_basedatos.m_grabar.enabled = true


if dw_master.getrow() = 0 then return 

if is_Action = 'new' then
	// Activa desactiva opcion de modificacion, eliminacion	
	m_master.m_file.m_basedatos.m_eliminar.enabled 	 = false
	m_master.m_file.m_basedatos.m_modificar.enabled  = false	
	m_master.m_file.m_basedatos.m_abrirlista.enabled = false	
	m_master.m_file.m_basedatos.m_anular.enabled 	 = false
	m_master.m_file.m_basedatos.m_insertar.enabled 	= false	

elseif is_Action = 'open' then
	
	li_estado = Long(dw_master.object.flag_estado[dw_master.getrow()])
	
	Choose case li_estado
		case 0		// Anulado			
			m_master.m_file.m_basedatos.m_eliminar.enabled   = false
			m_master.m_file.m_basedatos.m_modificar.enabled  = false				
			m_master.m_file.m_basedatos.m_anular.enabled 	 = false
			
		CASE 1   // Activo
		
		CASE 2   // Procesado
			m_master.m_file.m_basedatos.m_eliminar.enabled  = false
			m_master.m_file.m_basedatos.m_modificar.enabled = false		
			m_master.m_file.m_basedatos.m_anular.enabled 	= false
			
	end CHOOSE
	
elseif is_Action = 'edit' OR is_Action = 'anu' OR is_Action = 'del' then
	
	m_master.m_file.m_basedatos.m_insertar.enabled   = false
	m_master.m_file.m_basedatos.m_eliminar.enabled   = false
	m_master.m_file.m_basedatos.m_modificar.enabled  = false	
	m_master.m_file.m_basedatos.m_abrirlista.enabled = false	
	m_master.m_file.m_basedatos.m_anular.enabled 	 = false
	
end if

return 
end subroutine

public subroutine of_retrieve (string as_nro);dw_master.Retrieve( as_nro )
dw_master.ii_protect = 0
dw_master.of_protect()

dw_master.ii_update = 0
end subroutine

public function integer of_set_numera ();// Numera documento
Long 		ll_long, ll_nro
string	ls_mensaje, ls_nro, ls_table

if dw_master.GetRow() = 0 then return 0

if is_action = 'new' then
	ls_table = 'LOCK TABLE num_presup_ingr_var IN EXCLUSIVE MODE'
	EXECUTE IMMEDIATE :ls_table ;
	
	Select ult_nro 
		into :ll_nro 
	from num_presup_ingr_var
	where origen = :gs_origen;
	
	IF SQLCA.SQLCode = 100 then
		Insert into num_presup_ingr_var (origen, ult_nro)
			values( :gs_origen, 1);
		
		IF SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Aviso', ls_mensaje)
			return 0
		end if
		
		ll_nro = 1
	end if
	
	// Asigna numero a cabecera
	ls_nro = String(ll_nro)	
	ll_long = 10 - len( TRIM( gs_origen))
   ls_nro = TRIM(gs_origen) + f_llena_caracteres('0',Trim(ls_nro),ll_long) 		
	
	// Incrementa contador
	Update num_presup_ingr_var 
		set ult_nro = ult_nro + 1 
	 where origen = :gs_origen;
	
	IF SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Aviso', ls_mensaje)
		return 0
	end if

	dw_master.object.nro_variacion[dw_master.getrow()] = ls_nro
end if

return 1
end function

on w_pt309_presup_ingresos_var.create
int iCurrent
call super::create
if this.MenuName = "m_mantenimiento_cl" then this.MenuID = create m_mantenimiento_cl
this.sle_nro=create sle_nro
this.cb_2=create cb_2
this.st_2=create st_2
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_nro
this.Control[iCurrent+2]=this.cb_2
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.dw_master
end on

on w_pt309_presup_ingresos_var.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_nro)
destroy(this.cb_2)
destroy(this.st_2)
destroy(this.dw_master)
end on

event ue_insert;call super::ue_insert;Long  ll_row

ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)
end event

event ue_open_pre;call super::ue_open_pre;dw_master.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos
idw_1 = dw_master              				// asignar dw corriente
dw_master.of_protect()         		// bloquear modificaciones 

end event

event ue_update_pre;call super::ue_update_pre;ib_update_check = false

if f_row_processing( dw_master, 'form') = false then
	return
end if

if is_action = 'new' then
	if of_set_numera() = 0 then return
end if

ib_update_check = true
end event

event ue_update;call super::ue_update;Boolean lbo_ok = TRUE

dw_master.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_master.Update() = -1 then		// Grabacion del Master
		lbo_ok = FALSE
    	Rollback ;
		messagebox("Error en Grabacion Master","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0
END IF

end event

event ue_modify;call super::ue_modify;if dw_master.GetRow() = 0 then return

if dw_master.object.flag_automatico[dw_master.GetRow()] = 'A' then
	MessageBox('Aviso', 'No puede modificar una variacion automatica')
	dw_master.ii_protect = 0
	dw_master.of_protect()
	return
end if

dw_master.of_protect()
end event

event ue_list_open;call super::ue_list_open;// Abre ventana pop
str_parametros sl_param

sl_param.dw1 		= "d_lista_presup_ingresos_var_tbl"
sl_param.titulo 	= "Variaciones"
sl_param.field_ret_i[1] = 1

OpenWithParm( w_lista, sl_param)
sl_param = MESSAGE.POWEROBJECTPARM
if sl_param.titulo <> 'n' then	
	// Se ubica la cabecera
	of_retrieve(sl_param.field_ret[1])
END IF
end event

event ue_update_request;call super::ue_update_request;Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
IF dw_master.ii_update = 1 THEN
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	IF li_msg_result = 1 THEN
 		this.TriggerEvent("ue_update")
	ELSE
		dw_master.ii_update = 0
	END IF
END IF

end event

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - 10
dw_master.height = newheight - dw_master.y - 10
end event

event ue_delete;// Ancestor Script has been Override
if dw_master.object.flag_automatico[dw_master.GetRow()] = 'A' then
	MessageBox('Aviso', 'No puede Eliminar una variacion automatica')
	dw_master.ii_protect = 0
	dw_master.of_protect()
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
end event

event ue_print;call super::ue_print;str_parametros lstr_param

if dw_master.GetRow() = 0 then return

lstr_param.dw1		 = 'd_rpt_prsp_ingr_var'
lstr_param.string1 = dw_master.object.nro_variacion[dw_master.GetRow()]

OpenSheetWithParm(w_pt773_prsp_ingr_var_frm, lstr_param, w_main, 0, Layered!)
end event

type sle_nro from singlelineedit within w_pt309_presup_ingresos_var
integer x = 590
integer y = 4
integer width = 462
integer height = 100
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
textcase textcase = upper!
integer limit = 10
borderstyle borderstyle = stylelowered!
end type

type cb_2 from commandbutton within w_pt309_presup_ingresos_var
integer x = 1097
integer y = 12
integer width = 261
integer height = 84
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Buscar"
end type

event clicked;if sle_nro.text = '' then
	MessageBox('Aviso', 'Debe ingresar un numero de variación')
	return
end if

parent.of_retrieve(sle_nro.text)
sle_nro.text = ''


end event

type st_2 from statictext within w_pt309_presup_ingresos_var
integer x = 55
integer y = 24
integer width = 498
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Nro Variacion:"
alignment alignment = right!
boolean focusrectangle = false
end type

type dw_master from u_dw_abc within w_pt309_presup_ingresos_var
event ue_display ( string as_columna,  long al_row )
integer y = 128
integer width = 2313
integer height = 1052
string dataobject = "d_abc_prsp_ingr_var_frm"
end type

event ue_display(string as_columna, long al_row);boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_cencos
Integer	li_year

choose case lower(as_columna)
		
	case "cencos"
		
		li_year = integer(this.object.ano[al_row])
		
		if li_year = 0 or IsNull(li_year) then
			MessageBox('Aviso', 'Debe indicar el año')
			return
		end if
		
		ls_sql = "SELECT a.cencos AS CODIGO_cencos, " &
				 + "b.DESC_cencos AS DESCRIPCION_cencos " &
				 + "FROM centros_costo a," &
				 + "presup_ingresos_und b " &
				 + "where a.cencos = b.cencos " &
				 + "and a.flag_estado = '1' " &
				 + "and b.flag_estado = '2' " &
				 + "and b.ano = " + string(li_year)

				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.cencos		[al_row] = ls_codigo
			this.object.desc_cencos	[al_row] = ls_data
			this.ii_update = 1
		end if
		return

	case "cod_art"
		li_year = integer(this.object.ano[al_row])
		
		if li_year = 0 or IsNull(li_year) then
			MessageBox('Aviso', 'Debe indicar el año')
			return
		end if
		
		ls_cencos = this.object.cencos [al_row]
		if ls_cencos = '' or IsNull(ls_cencos) then
			MessageBox('Aviso', 'Debe indicar el Centro de Costo')
			return
		end if
		
		
		ls_sql = "SELECT a.cod_art AS CODIGO_articulo, " &
				 + "b.DESC_art AS DESCRIPCION_articulo " &
				 + "FROM articulo a," &
				 + "presup_ingresos_und b " &
				 + "where a.cod_art = b.cod_art " &
				 + "and a.flag_estado = '1' " &
				 + "and b.flag_estado = '2' " &
				 + "and b.cencos = '" + ls_cencos + "' " &
				 + "and b.ano = " + string(li_year)

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.cod_art	[al_row] = ls_codigo
			this.object.desc_art	[al_row] = ls_data
			this.ii_update = 1
		end if
		return
	
end choose

end event

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'form'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw

end event

event ue_insert_pre;call super::ue_insert_pre;this.object.cod_usr				[al_row] = gs_user
this.object.fecha 				[al_row] = f_fecha_actual()
this.object.flag_replicacion 	[al_row] = '1'
this.object.flag_automatico	[al_row] = 'M'
is_action = 'new'
end event

event doubleclicked;call super::doubleclicked;string 	ls_columna
long 		ll_row 

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if

end event

event keydwn;call super::keydwn;string 	ls_columna, ls_cadena
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

event itemchanged;call super::itemchanged;String 	ls_desc, ls_und, ls_estado, ls_null, ls_mensaje, &
			ls_cencos
Integer	li_year


SetNull(ls_null)

// Verifica si existe
this.AcceptText()

if dwo.name = "cencos" then	
	
	li_year = integer(this.object.ano[row])
	
	if li_year = 0 or IsNull(li_year) then
		MessageBox('Aviso', 'Debe indicar el año')
		return
	end if
	
	Select desc_cencos 
		into :ls_desc 
	from centros_costo 			a,
		  presup_ingresos_und 	b
	where a.cencos 		= b.cencos
	  and a.cencos 		= :data
	  and b.ano 			= :li_year
	  and a.flag_estado 	= '1'
	  and b.flag_estado 	= '2';

	  
	if SQLCA.SQLCode = 100 then
		ROLLBACK;
		Messagebox( "Error", "El Centro de costo no existe, no esta activo, " &
			+ "no tiene presupuesto de ingresos para el año " + string(li_year) &
			+ " o el presupuesto de ingresos todavia no ha sido procesado", Exclamation!)		
			
		this.object.cencos		[row] = ls_null
		this.object.desc_cencos	[row] = ls_null
		Return 1
	end if	
	
	this.object.desc_cencos[row] = ls_desc

elseIF dwo.name = "cod_art" then		

	li_year = integer(this.object.ano[row])
	
	if li_year = 0 or IsNull(li_year) then
		MessageBox('Aviso', 'Debe indicar el año')
		return
	end if
	
	ls_cencos = this.object.cencos[row]
	
	if ls_Cencos = '' or IsNull(ls_cencos) then
		MessageBox('Aviso', 'Debe indicar el centro de costos')
		return
	end if 
	
	Select desc_art, und
		into :ls_desc, :ls_und
	from articulo a,
		  presup_ingresos_und b
	where a.cod_art 		= b.cod_art
	  and a.cod_art 		= :data
	  and b.ano 			= :li_year
	  and a.flag_estado 	= '1'
	  and NVL(a.flag_inventariable,'0')	= '1'
	  and b.flag_estado 	= '2';

	  
	if SQLCA.SQLCode = 100 then
		Messagebox( "Error", "Codigo no aceptado, las causas pueden ser: ~r~n" &
			 + "1.- Codigo de Articulo no existe ~r~n" &
			 + "2.- Codigo de Articulo no esta activo ~r~n" &
			 + "3.- Codigo de Articulo esta como no inventariable ~r~n" &
			 + "4.- Codigo de Artículo no tien presupuesto de ingreso para el año: " + string(li_year) + "~r~n" &
			 + "5.- Presupuesto de Ingreso correspondiente no esta procesado ", &
			 Exclamation!)		
			 
		this.object.cod_Art	[row] = ls_null
		this.object.desc_Art	[row] = ls_null
		this.object.und		[row] = ls_null
		Return 1
	end if
	
	this.object.desc_art	[row] = ls_desc
	this.object.und		[row] = ls_und	

end if
end event

event itemerror;call super::itemerror;return 1
end event

event buttonclicked;call super::buttonclicked;string ls_docname, ls_named
integer li_value, li_row
str_parametros sl_param

This.AcceptText()
If this.ii_protect = 1 then RETURN

choose case lower(dwo.name)
	case "b_referencia"

		sl_param.dw1 = "d_list_presup_ingresos_tbl"
		sl_param.titulo = "Presupuesto de Ingresos"
		sl_param.field_ret_i[1] = 1
		sl_param.field_ret_i[2] = 2
		sl_param.field_ret_i[3] = 3
		sl_param.field_ret_i[4] = 4
		sl_param.field_ret_i[5] = 5
		sl_param.field_ret_i[6] = 6
		
		OpenWithParm(w_lista, sl_param)
		sl_param = MESSAGE.POWEROBJECTPARM
		
		if sl_param.titulo <> 'n' then
			dw_master.object.ano				[row] = Long(sl_param.field_ret[1])
			dw_master.object.cencos 		[row] = sl_param.field_ret[2]
			dw_master.object.desc_cencos 	[row] = sl_param.field_ret[3]
			dw_master.object.cod_art 		[row] = sl_param.field_ret[4]
			dw_master.object.desc_art 		[row] = sl_param.field_ret[5]
			dw_master.object.und 			[row] = sl_param.field_ret[6]
		END IF
end choose
end event

