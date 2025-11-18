$PBExportHeader$w_fl300_pesca_proy.srw
forward
global type w_fl300_pesca_proy from w_abc
end type
type st_1 from statictext within w_fl300_pesca_proy
end type
type em_ano from editmask within w_fl300_pesca_proy
end type
type pb_delete from u_pb_delete within w_fl300_pesca_proy
end type
type pb_new from u_pb_insert within w_fl300_pesca_proy
end type
type pb_modify from u_pb_modify within w_fl300_pesca_proy
end type
type pb_update from u_pb_update within w_fl300_pesca_proy
end type
type pb_recuperar from u_pb_std within w_fl300_pesca_proy
end type
type dw_2 from u_dw_abc within w_fl300_pesca_proy
end type
type dw_1 from u_dw_abc within w_fl300_pesca_proy
end type
end forward

global type w_fl300_pesca_proy from w_abc
integer width = 2994
integer height = 1752
string title = "Pesca Proyectada (FL300)"
string menuname = "m_smpl"
event ue_retrieve ( integer ai_ano )
st_1 st_1
em_ano em_ano
pb_delete pb_delete
pb_new pb_new
pb_modify pb_modify
pb_update pb_update
pb_recuperar pb_recuperar
dw_2 dw_2
dw_1 dw_1
end type
global w_fl300_pesca_proy w_fl300_pesca_proy

event ue_retrieve(integer ai_ano);pb_new.enabled 		= true
pb_delete.enabled 	= true
pb_update.enabled 	= true
pb_modify.enabled 	= true
	
dw_1.retrieve(ai_ano)
dw_2.retrieve(ai_ano)
end event

on w_fl300_pesca_proy.create
int iCurrent
call super::create
if this.MenuName = "m_smpl" then this.MenuID = create m_smpl
this.st_1=create st_1
this.em_ano=create em_ano
this.pb_delete=create pb_delete
this.pb_new=create pb_new
this.pb_modify=create pb_modify
this.pb_update=create pb_update
this.pb_recuperar=create pb_recuperar
this.dw_2=create dw_2
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.em_ano
this.Control[iCurrent+3]=this.pb_delete
this.Control[iCurrent+4]=this.pb_new
this.Control[iCurrent+5]=this.pb_modify
this.Control[iCurrent+6]=this.pb_update
this.Control[iCurrent+7]=this.pb_recuperar
this.Control[iCurrent+8]=this.dw_2
this.Control[iCurrent+9]=this.dw_1
end on

on w_fl300_pesca_proy.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.em_ano)
destroy(this.pb_delete)
destroy(this.pb_new)
destroy(this.pb_modify)
destroy(this.pb_update)
destroy(this.pb_recuperar)
destroy(this.dw_2)
destroy(this.dw_1)
end on

event resize;call super::resize;dw_1.width  = newwidth  - dw_1.x - 10
dw_2.width  = newwidth  - dw_2.x - 10
dw_2.height = newheight - dw_2.y - 10
end event

event ue_open_pre;call super::ue_open_pre;dw_1.SetTransObject(SQLCA)
dw_2.SetTransObject(SQLCA)

idw_1 = dw_1

em_ano.text = string(year(today()))
dw_1.of_Protect()
end event

event ue_insert;call super::ue_insert;long ll_row

ll_row = idw_1.Event ue_insert()
//IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)

end event

event ue_update;call super::ue_update;Boolean lbo_ok = TRUE
string ls_sort

dw_1.AcceptText()
ib_update_check = TRUE
THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF	dw_1.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_1.Update() = -1 then		// Grabacion del Master
		lbo_ok = FALSE
	   Rollback ;
		messagebox("Error en Grabacion Master","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_1.ii_update = 0
	dw_1.of_protect()
END IF
end event

event ue_update_pre;call super::ue_update_pre;Long 	ll_x, ll_row, ll_rows[], ll_column
boolean lb_ok = TRUE
integer li_mes
string ls_nave, ls_mensaje, ls_aprobado
decimal ln_pesca

of_get_row_update(dw_1, ll_rows[])

For ll_x = 1 TO UpperBound(ll_rows)
	ll_row 		= ll_rows[ll_x]
	li_mes 		= Integer(dw_1.object.mes[ll_row])
	ls_nave 		= Trim(dw_1.object.nave[ll_row])
	ln_pesca 	= dec(dw_1.object.pesca_estim[ll_row])
	
	If IsNull(li_mes) or li_mes = 0 then
		ls_mensaje = "Debe Ingresar algun mes"
		ll_column = 1
		lb_ok = false
	end if

	If IsNull(ln_pesca) then
		ls_mensaje = "Debe Ingresar alguna pesca"
		ll_column = 1
		lb_ok = false
	end if

	If ( IsNull(ls_nave) or ls_nave = "") and lb_ok then
		ls_mensaje = "Debe Ingresar alguna nave"
		ll_column = 2
		lb_ok = false
	end if

	IF not lb_ok THEN
		MessageBox("Error",ls_mensaje, StopSign! )
		ib_update_check = False
		dw_1.ScrollToRow(ll_row)
		dw_1.SetColumn(ll_Column)
		dw_1.SelectRow(0, false)
		dw_1.SelectRow(ll_row, true)
		dw_1.SetFocus()
		
		RETURN
	END IF
NEXT

dw_1.of_set_flag_replicacion()

end event

event ue_modify;call super::ue_modify;dw_1.of_protect()

dw_1.Modify("mes.Protect='1~tIf(IsNull(flag_aprobado),0,1)'")
dw_1.Modify("nave.Protect='1~tIf(IsNull(flag_aprobado),0,1)'")
dw_1.Modify("unid.Protect='1~tIf(IsNull(flag_aprobado),0,1)'")
dw_1.Modify("pesca_estim.Protect='1~tIf(IsNull(flag_aprobado),0,1)'")

end event

event ue_update_request;call super::ue_update_request;Integer li_msg_result

//Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
IF dw_1.ii_update = 1 THEN
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	IF li_msg_result = 1 THEN
		this.TriggerEvent("ue_update")
	ELSE
		dw_1.ii_update = 0
	END IF
END IF
end event

type st_1 from statictext within w_fl300_pesca_proy
integer x = 594
integer y = 32
integer width = 439
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Ingrese el año :"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_ano from editmask within w_fl300_pesca_proy
event ue_keyup pbm_keyup
integer x = 1051
integer y = 20
integer width = 334
integer height = 80
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
string mask = "####"
boolean spin = true
double increment = 1
end type

event ue_keyup;integer li_ano

if len(trim(this.text) ) < 4 then
	pb_new.enabled 		= false
	pb_delete.enabled 	= false
	pb_update.enabled 	= false
	pb_modify.enabled 	= false

end if

If Key = KeyEnter! or Key=KeyTab! Then
	li_ano = integer( this.text )

	parent.event ue_retrieve(li_ano)

	pb_new.SetFocus()
end if
end event

type pb_delete from u_pb_delete within w_fl300_pesca_proy
integer x = 768
integer y = 768
integer width = 155
integer height = 132
integer taborder = 80
integer textsize = -2
boolean enabled = false
string text = "&e"
string picturename = "h:\SOURCE\BMP\eliminar.bmp"
string disabledname = "H:\Source\BMP\eliminar_d.bmp"
string powertiptext = "Eliminar"
end type

event clicked;PARENT.EVENT ue_delete()
end event

type pb_new from u_pb_insert within w_fl300_pesca_proy
integer x = 608
integer y = 768
integer width = 155
integer height = 132
integer taborder = 40
integer textsize = -2
boolean enabled = false
string text = "&I"
string picturename = "h:\SOURCE\BMP\nuevo.bmp"
string disabledname = "h:\SOURCE\BMP\nuevo_d.bmp"
string powertiptext = "Insertar"
end type

event clicked;PARENT.EVENT ue_insert()
end event

type pb_modify from u_pb_modify within w_fl300_pesca_proy
integer x = 923
integer y = 768
integer width = 155
integer height = 132
integer taborder = 50
integer textsize = -2
boolean enabled = false
string text = "&m"
string picturename = "h:\SOURCE\BMP\modificar.bmp"
string disabledname = "h:\SOURCE\BMP\modificar_d.bmp"
string powertiptext = "Modificar"
end type

type pb_update from u_pb_update within w_fl300_pesca_proy
integer x = 1083
integer y = 768
integer width = 155
integer height = 132
integer taborder = 60
integer textsize = -2
boolean enabled = false
string text = "&G"
string picturename = "h:\SOURCE\BMP\grabar.bmp"
string disabledname = "h:\SOURCE\BMP\grabar_d.bmp"
string powertiptext = "Grabar"
end type

type pb_recuperar from u_pb_std within w_fl300_pesca_proy
integer x = 1243
integer y = 768
integer width = 155
integer height = 132
integer taborder = 70
integer textsize = -2
string text = "&r"
string picturename = "Retrieve!"
boolean map3dcolors = true
end type

event clicked;integer li_ano

li_ano = integer(em_ano.text)
parent.event dynamic ue_retrieve(li_ano)
end event

type dw_2 from u_dw_abc within w_fl300_pesca_proy
integer y = 912
integer width = 2912
integer height = 592
integer taborder = 30
boolean titlebar = true
string title = "Proyeccion de Pesca (Vista Total)"
string dataobject = "d_pesca_proy_crosstab"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)
ib_delete_cascada = FALSE
ii_ck[1] = 1				// columnas de lectrua de este dw

end event

type dw_1 from u_dw_abc within w_fl300_pesca_proy
event ue_display ( string as_columna,  long al_row )
integer y = 140
integer width = 2898
integer height = 608
integer taborder = 20
string dataobject = "d_pesca_proy_grid"
boolean vscrollbar = true
end type

event ue_display(string as_columna, long al_row);string ls_codigo, ls_data, ls_sql
long ll_count
integer li_i, li_ano, li_mes
str_seleccionar lstr_seleccionar

choose case upper(as_columna)
		
	case "NAVE"
		
		ls_sql = "SELECT NAVE AS CODIGO, " &
				 + "NOMB_NAVE AS DESCRIPCION " &
             + "FROM TG_NAVES " &
				 + "WHERE FLAG_TIPO_FLOTA = 'P'"
				 
		lstr_seleccionar.s_column 	  = '1'
		lstr_seleccionar.s_sql       = ls_sql
		lstr_seleccionar.s_seleccion = 'S'

		OpenWithParm(w_seleccionar,lstr_seleccionar)
		
		IF isvalid(message.PowerObjectParm) THEN 
			lstr_seleccionar = message.PowerObjectParm
		END IF	
		IF lstr_seleccionar.s_action = "aceptar" THEN
			ls_codigo = lstr_seleccionar.param1[1]
			ls_data   = lstr_seleccionar.param2[1]
		ELSE		
			Messagebox('Error', "DEBE SELECCIONAR UN CODIGO DE NAVE", StopSign!)
			return 
		end if
		
		li_ano = integer(em_ano.text)
		li_mes = integer(this.object.mes[al_row])

		select count(*)
			into :ll_count
		from fl_pesca_proy
		where ano = :li_ano 
		  and mes = :li_mes
		  and nave = :ls_codigo;
		
		if ll_count > 0 then
			Messagebox('Error', "NAVE YA EXISTE EN ESTA PROYECCION", StopSign!)
			return 
		end if


		this.object.nomb_nave[al_row] = ls_data		
		this.object.nave[al_row] 		= ls_codigo
		this.ii_update = 1

	case "UNID"
		
		ls_sql = "SELECT UND AS CODIGO, " &
				 + "DESC_UNIDAD AS UNIDAD " &
             + "FROM UNIDAD "
				 
		lstr_seleccionar.s_column 	  = '1'
		lstr_seleccionar.s_sql       = ls_sql
		lstr_seleccionar.s_seleccion = 'S'

		OpenWithParm(w_seleccionar,lstr_seleccionar)
		
		IF isvalid(message.PowerObjectParm) THEN 
			lstr_seleccionar = message.PowerObjectParm
		END IF	
		IF lstr_seleccionar.s_action = "aceptar" THEN
			ls_codigo = lstr_seleccionar.param1[1]
			ls_data   = lstr_seleccionar.param2[1]
		ELSE		
			Messagebox('Error', "DEBE SELECCIONAR UNA UNIDAD", StopSign!)
			return 
		end if
		
		this.object.desc_unidad[al_row] 	= ls_data		
		this.object.unid[al_row] 			= ls_codigo
		this.ii_update = 1

end choose

end event

event constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)
ib_delete_cascada = FALSE
ii_ck[1] = 1				// columnas de lectrua de este dw


end event

event doubleclicked;call super::doubleclicked;string ls_columna, ls_aprobado
long ll_row 
str_seleccionar lstr_seleccionar

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

if ll_row <= 0 then return

ls_aprobado = trim(string(this.object.flag_aprobado[ll_row]))

if ls_aprobado = '1' then
	MessageBox('ERROR', 'NO PUEDE MODIFICAR UNA PROYECCION APROBADA', StopSign!)
	return
end if

if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if
end event

event itemchanged;call super::itemchanged;string ls_codigo, ls_data, ls_tipo, ls_aprobado
long ll_row, ll_count
integer li_ano, li_mes

this.AcceptText()
ll_row = row

if ll_row <= 0 then
	return
end if

ls_aprobado = this.object.flag_aprobado[ll_row]

if ls_aprobado = '1' then
	MessageBox('ERROR', 'NO PUEDE MODIFICAR UNA PROYECCION QUE YA HA SIDO APROBADA', StopSign!)
	return 1
end if

choose case upper(dwo.name)
	case "NAVE"
		
		ls_codigo = this.object.nave[ll_row]

		SetNull(ls_data)
		select nomb_nave
			into :ls_data
		from tg_naves
		where nave = :ls_codigo;
		
		if IsNull(ls_data) or ls_data = "" then
			Messagebox('Error', "CODIGO DE NAVE NO EXISTE", StopSign!)
			return 1
		end if
		
		li_ano = integer(em_ano.text)
		li_mes = integer(this.object.mes[ll_row])

		select count(*)
			into :ll_count
		from fl_pesca_proy
		where ano = :li_ano 
		  and mes = :li_mes
		  and nave = :ls_codigo;
		
		if ll_count > 0 then
			Messagebox('Error', "NAVE YA EXISTE EN ESTA PROYECCION", StopSign!)
			return 1
		end if
		
		this.object.nomb_nave[ll_row] = ls_data
		
	CASE "UNID"

		ls_codigo = this.object.unid[ll_row]

		SetNull(ls_data)
		select desc_unidad
			into :ls_data
		from unidad
		where und = :ls_codigo;
		
		if IsNull(ls_data) or ls_data = "" then
			Messagebox('Error', "UNIDAD NO EXISTE", StopSign!)
			return 1
		end if
		
		this.object.desc_unidad[ll_row] = ls_data

	CASE "MES"

		li_ano = integer(em_ano.text)
		li_mes = integer(this.object.mes[ll_row])

		select count(*)
			into :ll_count
		from fl_pesca_proy
		where ano = :li_ano 
		  and mes = :li_mes
		  and nave = :ls_codigo;
		
		if ll_count > 0 then
			Messagebox('Error', "NAVE YA EXISTE EN ESTA PROYECCION", StopSign!)
			return 1
		end if

end choose

end event

event itemerror;call super::itemerror;return 1
end event

event keydwn;call super::keydwn;string ls_columna, ls_cadena
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
	 	this.event ue_display( ls_columna, ll_row )
	end if
end if
return 0
end event

event ue_insert_pre;call super::ue_insert_pre;string ls_unidad, ls_data, ls_nave
integer li_ano, li_mes

li_ano = integer(em_ano.text)
this.object.ano[al_row] = li_ano
this.object.flag_aprobado[al_row] = '0'


if al_row > 1 then
	ls_unidad = trim(this.object.unid[al_row - 1])
	li_mes    = integer(this.object.mes[al_row - 1])
	ls_nave   = trim(this.object.nave[al_row - 1])
	
	if IsNull(ls_nave) or ls_nave = "" then
		Messagebox('Error', "DEBE DIGITAR EL CODIGO DE UNA NAVE", StopSign!)
		return 
	end if

	if IsNull(li_mes) or li_mes = 0 then
		Messagebox('Error', "DEBE DIGITAR UN MES", StopSign!)
		return 
	end if

	SetNull(ls_data)
	select desc_unidad
		into :ls_data
	from unidad
	where und = :ls_unidad;
		
	if IsNull(ls_data) or ls_data = "" then
		Messagebox('Error', "UNIDAD NO EXISTE", StopSign!)
		return 
	end if
		
	this.object.unid[al_row] 		  = ls_unidad
	this.object.desc_unidad[al_row] = ls_data
	
	SetNull(ls_data)
	select nomb_nave
		into :ls_data
	from tg_naves
	where nave = :ls_nave;
		
	if IsNull(ls_data) or ls_data = "" then
		Messagebox('Error', "CODIGO DE NAVE NO EXISTE", StopSign!)
		return 
	end if
	
	
	if li_mes < 12 then
		this.object.mes[al_row]  		  = li_mes + 1
	else
		this.object.mes[al_row]  		  = 1
	end if
	this.object.nave[al_row]		  = ls_nave
	this.object.nomb_nave[al_row]	  = ls_data
		
end if

end event

