$PBExportHeader$w_fl320_asistencia_bonificacion.srw
forward
global type w_fl320_asistencia_bonificacion from w_abc
end type
type em_hora from editmask within w_fl320_asistencia_bonificacion
end type
type cb_importar from commandbutton within w_fl320_asistencia_bonificacion
end type
type st_4 from statictext within w_fl320_asistencia_bonificacion
end type
type st_3 from statictext within w_fl320_asistencia_bonificacion
end type
type sle_mes from singlelineedit within w_fl320_asistencia_bonificacion
end type
type sle_year from singlelineedit within w_fl320_asistencia_bonificacion
end type
type cb_buscar from commandbutton within w_fl320_asistencia_bonificacion
end type
type dw_master from u_dw_abc within w_fl320_asistencia_bonificacion
end type
type gb_1 from groupbox within w_fl320_asistencia_bonificacion
end type
end forward

global type w_fl320_asistencia_bonificacion from w_abc
integer width = 2953
integer height = 1724
string title = "[FL320] Asistencia Mensual (Bonificaciones - Fijo)"
string menuname = "m_mto_smpl"
event ue_retrieve ( )
event ue_act_menu ( boolean ab_estado )
event ue_importar ( )
em_hora em_hora
cb_importar cb_importar
st_4 st_4
st_3 st_3
sle_mes sle_mes
sle_year sle_year
cb_buscar cb_buscar
dw_master dw_master
gb_1 gb_1
end type
global w_fl320_asistencia_bonificacion w_fl320_asistencia_bonificacion

type variables

String 	is_columna, is_Texto, is_horas
Long		il_row
end variables

forward prototypes
public function integer of_get_horas (string as_texto)
public function string of_get_formato (string as_texto, string as_horas)
end prototypes

event ue_retrieve();Integer li_year, li_mes

li_year 	= integer(sle_year.text)
li_mes	= integer(sle_mes.text)

dw_master.Retrieve( li_mes, li_year )

end event

event ue_act_menu(boolean ab_estado);this.MenuId.item[1].item[1].item[2].visible = ab_estado
this.MenuId.item[1].item[1].item[3].visible = ab_estado
this.MenuId.item[1].item[1].item[4].visible = ab_estado
this.MenuId.item[1].item[1].item[5].visible = ab_estado

this.MenuId.item[1].item[1].item[2].ToolbarItemvisible = ab_estado
this.MenuId.item[1].item[1].item[3].ToolbarItemvisible = ab_estado
this.MenuId.item[1].item[1].item[4].ToolbarItemvisible = ab_estado
this.MenuId.item[1].item[1].item[5].ToolbarItemvisible = ab_estado

end event

event ue_importar();u_ds_base	lds_base, lds_asistencia
Long			ll_i, ll_row
Integer		li_year, li_mes
String		ls_cod_trabaj, ls_nom_trabaj

try 
	li_year 	= Integer(sle_year.text)
	li_mes	= Integer(sle_mes.text)
	
	lds_base = create u_ds_base
	lds_base.dataobject = 'd_lista_trip_bonif_pesca_tbl'
	lds_base.setTransobject( SQLCA )
	lds_base.REtrieve( )
	
	lds_asistencia = create u_ds_base
	lds_asistencia.dataobject = 'd_lista_asist_x_trip_tbl'
	lds_asistencia.SetTransobject( SQLCA )
	
	if lds_base.RowCount() = 0 then
		gnvo_app.of_mensaje_error( "No hay tripulantes registrados y activos que tengan " &
										 + "el concepto de bonificacion, por favor verifique " &
										 + "en RRHH si el concepto de bonificacion (1005) " &
										 + "lo tienen registrado como ingreso fijo")
	end if
	
	
	for ll_i = 1 to lds_base.RowCount()
		ls_cod_trabaj = lds_base.object.tripulante 		[ll_i]
		ls_nom_trabaj = lds_base.object.nom_trabajador 	[ll_i]
		
		//Busco si existe o no el trabajador en la lista indicada
		ll_row = dw_master.find("tripulante='" + ls_cod_trabaj +"'", 1, dw_master.RowCount())
		
		if ll_row > 0 then
			MessageBox('Informacion', 'El tripulante ' + ls_cod_trabaj + '-' + ls_nom_trabaj + " ya esta en el listado de asistencia, se procederá a ignorarlo.")
		else
			ll_row = dw_master.event ue_insert( )
			if ll_row > 0 then
				dw_master.object.nave 					[ll_row] = lds_base.object.nave 					[ll_i]
				dw_master.object.nomb_nave 			[ll_row] = lds_base.object.nomb_nave 			[ll_i]
				dw_master.object.tripulante 			[ll_row] = lds_base.object.tripulante 			[ll_i]
				dw_master.object.nom_trabajador 		[ll_row] = lds_base.object.nom_trabajador 	[ll_i]
				dw_master.object.cargo_tripulante 	[ll_row] = lds_base.object.cargo_tripulante 	[ll_i]
				dw_master.object.descr_cargo 			[ll_row] = lds_base.object.descr_cargo 		[ll_i]
			end if
		end if
		
		// Ahora la asistencia en caso de que exista
		lds_asistencia.REtrieve(li_mes, li_year, ls_cod_trabaj )
		
		if lds_asistencia.Rowcount( ) > 0 then
			dw_master.object.dia_01 [ll_row] = lds_asistencia.object.dia_01 [1]
			dw_master.object.dia_02 [ll_row] = lds_asistencia.object.dia_02 [1]
			dw_master.object.dia_03 [ll_row] = lds_asistencia.object.dia_03 [1]
			dw_master.object.dia_04 [ll_row] = lds_asistencia.object.dia_04 [1]
			dw_master.object.dia_05 [ll_row] = lds_asistencia.object.dia_05 [1]
			dw_master.object.dia_06 [ll_row] = lds_asistencia.object.dia_06 [1]
			dw_master.object.dia_07 [ll_row] = lds_asistencia.object.dia_07 [1]
			dw_master.object.dia_08 [ll_row] = lds_asistencia.object.dia_08 [1]
			dw_master.object.dia_09 [ll_row] = lds_asistencia.object.dia_09 [1]
			dw_master.object.dia_10 [ll_row] = lds_asistencia.object.dia_10 [1]
			dw_master.object.dia_11 [ll_row] = lds_asistencia.object.dia_11 [1]
			dw_master.object.dia_12 [ll_row] = lds_asistencia.object.dia_12 [1]
			dw_master.object.dia_13 [ll_row] = lds_asistencia.object.dia_13 [1]
			dw_master.object.dia_14 [ll_row] = lds_asistencia.object.dia_14 [1]
			dw_master.object.dia_15 [ll_row] = lds_asistencia.object.dia_15 [1]
			dw_master.object.dia_16 [ll_row] = lds_asistencia.object.dia_16 [1]
			dw_master.object.dia_17 [ll_row] = lds_asistencia.object.dia_17 [1]
			dw_master.object.dia_18 [ll_row] = lds_asistencia.object.dia_18 [1]
			dw_master.object.dia_19 [ll_row] = lds_asistencia.object.dia_19 [1]
			dw_master.object.dia_20 [ll_row] = lds_asistencia.object.dia_20 [1]
			dw_master.object.dia_21 [ll_row] = lds_asistencia.object.dia_21 [1]
			dw_master.object.dia_22 [ll_row] = lds_asistencia.object.dia_22 [1]
			dw_master.object.dia_23 [ll_row] = lds_asistencia.object.dia_23 [1]
			dw_master.object.dia_24 [ll_row] = lds_asistencia.object.dia_24 [1]
			dw_master.object.dia_25 [ll_row] = lds_asistencia.object.dia_25 [1]
			dw_master.object.dia_26 [ll_row] = lds_asistencia.object.dia_26 [1]
			dw_master.object.dia_27 [ll_row] = lds_asistencia.object.dia_27 [1]
			dw_master.object.dia_28 [ll_row] = lds_asistencia.object.dia_28 [1]
			dw_master.object.dia_29 [ll_row] = lds_asistencia.object.dia_29 [1]
			dw_master.object.dia_30 [ll_row] = lds_asistencia.object.dia_30 [1]
			dw_master.object.dia_31 [ll_row] = lds_asistencia.object.dia_31 [1]
		else
			dw_master.object.dia_01 [ll_row] = 'TT(08)'
			dw_master.object.dia_02 [ll_row] = 'TT(08)'
			dw_master.object.dia_03 [ll_row] = 'TT(08)'
			dw_master.object.dia_04 [ll_row] = 'TT(08)'
			dw_master.object.dia_05 [ll_row] = 'TT(08)'
			dw_master.object.dia_06 [ll_row] = 'TT(08)'
			dw_master.object.dia_07 [ll_row] = 'TT(08)'
			dw_master.object.dia_08 [ll_row] = 'TT(08)'
			dw_master.object.dia_09 [ll_row] = 'TT(08)'
			dw_master.object.dia_10 [ll_row] = 'TT(08)'
			dw_master.object.dia_11 [ll_row] = 'TT(08)'
			dw_master.object.dia_12 [ll_row] = 'TT(08)'
			dw_master.object.dia_13 [ll_row] = 'TT(08)'
			dw_master.object.dia_14 [ll_row] = 'TT(08)'
			dw_master.object.dia_15 [ll_row] = 'TT(08)'
			dw_master.object.dia_16 [ll_row] = 'TT(08)'
			dw_master.object.dia_17 [ll_row] = 'TT(08)'
			dw_master.object.dia_18 [ll_row] = 'TT(08)'
			dw_master.object.dia_19 [ll_row] = 'TT(08)'
			dw_master.object.dia_20 [ll_row] = 'TT(08)'
			dw_master.object.dia_21 [ll_row] = 'TT(08)'
			dw_master.object.dia_22 [ll_row] = 'TT(08)'
			dw_master.object.dia_23 [ll_row] = 'TT(08)'
			dw_master.object.dia_24 [ll_row] = 'TT(08)'
			dw_master.object.dia_25 [ll_row] = 'TT(08)'
			dw_master.object.dia_26 [ll_row] = 'TT(08)'
			dw_master.object.dia_27 [ll_row] = 'TT(08)'
			dw_master.object.dia_28 [ll_row] = 'TT(08)'
			dw_master.object.dia_29 [ll_row] = 'TT(08)'
			dw_master.object.dia_30 [ll_row] = 'TT(08)'
			dw_master.object.dia_31 [ll_row] = 'TT(08)'

		end if
		
		
		
	next
		
catch ( Exception ex )
	gnvo_app.of_catch_exception( ex, "")
	
finally
	
	if not IsNull(lds_base) then
		destroy lds_base
	end if
	
	if not IsNull(lds_asistencia) then
		destroy lds_asistencia
	end if
end try
end event

public function integer of_get_horas (string as_texto);String ls_horas

ls_horas = mid(as_texto, 4, 2)

return integer(ls_horas)
end function

public function string of_get_formato (string as_texto, string as_horas);string ls_formato

ls_formato = left(as_texto, 2) + '(' + as_horas + ')'

return ls_formato
end function

on w_fl320_asistencia_bonificacion.create
int iCurrent
call super::create
if this.MenuName = "m_mto_smpl" then this.MenuID = create m_mto_smpl
this.em_hora=create em_hora
this.cb_importar=create cb_importar
this.st_4=create st_4
this.st_3=create st_3
this.sle_mes=create sle_mes
this.sle_year=create sle_year
this.cb_buscar=create cb_buscar
this.dw_master=create dw_master
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.em_hora
this.Control[iCurrent+2]=this.cb_importar
this.Control[iCurrent+3]=this.st_4
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.sle_mes
this.Control[iCurrent+6]=this.sle_year
this.Control[iCurrent+7]=this.cb_buscar
this.Control[iCurrent+8]=this.dw_master
this.Control[iCurrent+9]=this.gb_1
end on

on w_fl320_asistencia_bonificacion.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.em_hora)
destroy(this.cb_importar)
destroy(this.st_4)
destroy(this.st_3)
destroy(this.sle_mes)
destroy(this.sle_year)
destroy(this.cb_buscar)
destroy(this.dw_master)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;date ld_fecha

ld_fecha = date(gnvo_app.of_fecha_actual( ))

sle_year.text = string(ld_fecha, 'yyyy')
sle_mes.text = string(ld_fecha, 'mm')

dw_master.SetTransObject(sqlca)  			// Relacionar el dw con la base de datos

idw_1 = dw_master              				// asignar dw corriente
dw_master.of_protect()         				// bloquear modificaciones 


end event

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - 10
dw_master.height = newheight - dw_master.y - 10
end event

event ue_insert;call super::ue_insert;Long  ll_row

ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)
end event

event ue_update;//Override
Long		ll_row, ll_day, ll_year, ll_mes
String	ls_tripulante, ls_nave, ls_dato, ls_tipo_Asistencia, ls_cargo, ls_mensaje, ls_column
date 		ld_fecha
Integer	li_horas, li_count

if dw_master.RowCount() = 0 then
	gnvo_app.of_mensaje_error( "No hay registros que grabar, por favor confirme!")
	return
end if

ll_year 	= Long(sle_year.text)
ll_mes	= Long(sle_mes.text)

for ll_row = 1 to dw_master.RowCount()
	ls_tripulante 	= dw_master.object.tripulante 		[ll_row]
	ls_nave		  	= dw_master.object.nave					[ll_row]
	ls_cargo			= dw_master.object.cargo_tripulante	[ll_row]
	
	for ll_day = 1 to gnvo_app.of_last_day( ll_mes, ll_year)
		ld_fecha = Date(ll_year, ll_mes, ll_day)
		ls_column = "dia_" + trim(string(ll_day, '00'))
		
		ls_dato = dw_master.getItemstring( ll_row, ls_column )
		
		//Si el dato es nulo o está vacío debe eliminarse el registro
		if IsNull(ls_dato) or trim(ls_dato) = '' then
			delete fl_asistencia
			where tripulante 	= :ls_tripulante
			  and nave			= :ls_nave
			  and fecha			= :ld_fecha;
			
			if gnvo_app.of_existserror( SQLCA, "Error al momento de eliminar registro en fl_asistencia" &
													+ "~r~nTripulante: " + ls_tripulante &
													+ "~r~nNave: " + ls_nave &
													+ "~r~nFecha: " + String(ld_fecha, 'dd/mm/yyyy') ) then
				return 
			end if
			
		else
			//Sacamos el tipo de Asistencia
			ls_tipo_asistencia 	= mid(ls_dato, 1, 2)
			li_horas					= Integer(mid(ls_dato, 4, 2))
			
			//Actualizar
			select count(*)
				into :li_count
			from fl_asistencia
			where tripulante 	= :ls_tripulante
			  and nave			= :ls_nave
			  and fecha			= :ld_fecha;
			
			if li_count > 0 then
				
				update fl_asistencia fla
					set fla.flag_tipo_asistencia 	= :ls_tipo_asistencia,
						 fla.horas						= :li_horas	
				where tripulante 	= :ls_tripulante
				  and nave			= :ls_nave
				  and fecha			= :ld_fecha;
				
				if SQLCA.SQLCode < 0 then
					ls_mensaje = SQLCA.SQLErrText
					ROLLBACK;
					gnvo_app.of_mensaje_error( "Error al momento de actualizar en fl_asistencia " &
													 + "~r~nTripulante: " + ls_tripulante &
													 + "~r~nNave: " + ls_nave &
													 + "~r~nFecha: " + String(ld_fecha, 'dd/mm/yyyy') &
													 + "~r~nMensaje: " + ls_mensaje)
					return
				end if
				
			else
				//Si no existe el registro entonces simplemente lo inserto
				insert into fl_asistencia(
					tripulante, cargo_tripulante, nave, fecha, flag_tipo_asistencia, horas)
				values(
					:ls_tripulante, :ls_cargo, :ls_nave, :ld_fecha, :ls_tipo_asistencia, :li_horas);
					
				//Si hay un error
				if SQLCA.SQLCode < 0 then
					ls_mensaje = SQLCA.SQLErrText
					ROLLBACK;
					gnvo_app.of_mensaje_error( "Error al momento de insertar en fl_asistencia " &
													 + "~r~nTripulante: " + ls_tripulante &
													 + "~r~nNave: " + ls_nave &
													 + "~r~nFecha: " + String(ld_fecha, 'dd/mm/yyyy') &
													 + "~r~nMensaje: " + ls_mensaje)
					return
				end if
			end if

		end if
		
		
	next
	
next

commit;

this.event ue_retrieve( )

f_mensaje("Cambios Guardados satisfactoriamente", "")
end event

event ue_modify;call super::ue_modify;dw_master.of_protect()
end event

type em_hora from editmask within w_fl320_asistencia_bonificacion
event ue_tecla pbm_keydown
boolean visible = false
integer x = 2382
integer y = 52
integer width = 210
integer height = 80
integer taborder = 80
integer textsize = -7
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
boolean enabled = false
string mask = "00"
boolean spin = true
string minmax = "0~~16"
end type

event ue_tecla;String ls_formato, ls_horas

if key = KeyEscape! then
	
	this.enabled = false
	this.visible = false
	
elseif key = KeyEnter! then
	
	ls_horas = this.Text
	
	if ls_horas <> is_horas then
	
		ls_formato = parent.of_get_formato( is_texto, ls_horas)
		
		dw_master.SetItem( il_row, is_columna, ls_formato)
		dw_master.ii_update = 1
	end if
	
	this.enabled = false
	this.visible = false
	
end if
end event

event losefocus;this.enabled = false
this.visible = false
end event

type cb_importar from commandbutton within w_fl320_asistencia_bonificacion
integer x = 1147
integer y = 72
integer width = 439
integer height = 100
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Importar datos"
end type

event clicked;setPointer(HourGlass!)

parent.event ue_importar( )

SetPointer(Arrow!)
end event

type st_4 from statictext within w_fl320_asistencia_bonificacion
integer x = 37
integer y = 84
integer width = 155
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Año"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_3 from statictext within w_fl320_asistencia_bonificacion
integer x = 411
integer y = 84
integer width = 160
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Mes"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_mes from singlelineedit within w_fl320_asistencia_bonificacion
integer x = 576
integer y = 84
integer width = 133
integer height = 76
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
borderstyle borderstyle = stylelowered!
end type

type sle_year from singlelineedit within w_fl320_asistencia_bonificacion
integer x = 201
integer y = 84
integer width = 192
integer height = 76
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
borderstyle borderstyle = stylelowered!
end type

type cb_buscar from commandbutton within w_fl320_asistencia_bonificacion
integer x = 782
integer y = 72
integer width = 343
integer height = 100
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Buscar"
end type

event clicked;setPointer(HourGlass!)

parent.event ue_retrieve( )

SetPointer(Arrow!)
end event

type dw_master from u_dw_abc within w_fl320_asistencia_bonificacion
event ue_dblclick ( string as_columna,  long al_row )
event ue_rbuttonclick pbm_rbuttondown
integer y = 204
integer width = 2770
integer height = 1016
integer taborder = 20
string dataobject = "d_abc_asistencia_tripulantes_tbl"
end type

event constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw
end event

event doubleclicked;call super::doubleclicked;string ls_columna, ls_string, ls_evaluate, ls_texto

THIS.AcceptText()

if left(lower(dwo.name), 3) = 'dia' and row > 0 then
	ls_columna = lower(dwo.name)
	ls_texto = String(this.getItemString( row, ls_columna))

	if IsNull(ls_texto) or trim(ls_Texto) = '' then
		ls_Texto = 'TT(08)'	
	elseif left(ls_texto, 2) = 'TT' then
		ls_Texto = 'TF' + right(ls_texto, 4)
	elseif left(ls_texto, 2) = 'TF' then
		SetNull(ls_texto)
	end if
	
	this.setItem(row, ls_columna, ls_Texto)
	this.ii_update = 1
	
	return 1
end if

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

event itemchanged;call super::itemchanged;//string ls_codigo, ls_data, ls_tipo
//long ll_row, ll_count
//
//this.AcceptText()
//ll_row = this.GetRow()
//choose case upper(dwo.name)
//	case "TRIPULANTE"
//		
//		ls_codigo = this.object.tripulante[ll_row]
//
//		SetNull(ls_data)
//		select nomb_trip
//			into :ls_data
//		from vw_tripulantes
//		where codigo_tripulante = :ls_codigo;
//		
//		if IsNull(ls_data) or ls_data = "" then
//			Messagebox('Error', "CODIGO DE TRIPULANTE NO EXISTE", StopSign!)
//			return 1
//		end if
//		
//		this.object.nomb_trip[ll_row] 		 = ls_data
//
//		//Obtengo el cargo por defecto del tripulante
//		ls_codigo = iuo_parte.of_find_cargo_trip( ls_codigo )
//		ls_data	 = iuo_parte.of_find_desc_cargo( ls_codigo )
//		this.object.cargo_tripulante[ll_row] =	ls_codigo
//		this.object.descr_cargo[ll_row]      = ls_data
//
//	case "CARGO_TRIPULANTE"
//		
//		ls_codigo = this.object.cargo_tripulante[ll_row]
//
//		ls_data	 = iuo_parte.of_find_desc_cargo( ls_codigo )
//		
//		if ls_data = "" then
//			Messagebox('Error', "CODIGO DE CARGO NO EXISTE", StopSign!)
//			return 1
//		end if
//		
//		this.object.descr_cargo[ll_row] = ls_data
//
//end choose
end event

event rowfocuschanged;call super::rowfocuschanged;This.SelectRow(0, false)
this.SelectRow(currentrow, true)
this.SetRow(currentrow)
end event

event ue_insert_pre;call super::ue_insert_pre;date ld_fecha
string ls_nave


this.object.dia_01	[al_row]  = gnvo_app.is_null
this.object.dia_02	[al_row]  = gnvo_app.is_null
this.object.dia_03	[al_row]  = gnvo_app.is_null
this.object.dia_04	[al_row]  = gnvo_app.is_null
this.object.dia_05	[al_row]  = gnvo_app.is_null
this.object.dia_06	[al_row]  = gnvo_app.is_null
this.object.dia_07	[al_row]  = gnvo_app.is_null
this.object.dia_08	[al_row]  = gnvo_app.is_null
this.object.dia_09	[al_row]  = gnvo_app.is_null
this.object.dia_10	[al_row]  = gnvo_app.is_null
this.object.dia_11	[al_row]  = gnvo_app.is_null
this.object.dia_12	[al_row]  = gnvo_app.is_null
this.object.dia_13	[al_row]  = gnvo_app.is_null
this.object.dia_14	[al_row]  = gnvo_app.is_null
this.object.dia_15	[al_row]  = gnvo_app.is_null
this.object.dia_16	[al_row]  = gnvo_app.is_null
this.object.dia_17	[al_row]  = gnvo_app.is_null
this.object.dia_18	[al_row]  = gnvo_app.is_null
this.object.dia_19	[al_row]  = gnvo_app.is_null
this.object.dia_20	[al_row]  = gnvo_app.is_null
this.object.dia_21	[al_row]  = gnvo_app.is_null
this.object.dia_22	[al_row]  = gnvo_app.is_null
this.object.dia_23	[al_row]  = gnvo_app.is_null
this.object.dia_24	[al_row]  = gnvo_app.is_null
this.object.dia_25	[al_row]  = gnvo_app.is_null
this.object.dia_26	[al_row]  = gnvo_app.is_null
this.object.dia_27	[al_row]  = gnvo_app.is_null
this.object.dia_28	[al_row]  = gnvo_app.is_null
this.object.dia_29	[al_row]  = gnvo_app.is_null
this.object.dia_30	[al_row]  = gnvo_app.is_null
this.object.dia_31	[al_row]  = gnvo_app.is_null

end event

event ue_display;call super::ue_display;boolean lb_ret
string ls_codigo, ls_data, ls_sql, ls_nave, ls_data2, ls_data3

choose case lower(as_columna)
	case "nave"
		ls_sql = "select nave as codigo_nave, " &
				 + "nomb_nave as nombre_nave " &
				 + "from tg_naves " &
				 + "where flag_tipo_flota = 'P' " &
				 + "  and flag_estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

		if ls_codigo <> '' then
			this.object.nave			[al_row] = ls_codigo
			this.object.nomb_nave	[al_row] = ls_data
			this.ii_update = 1
		end if
		
	case "tripulante"
		ls_nave = this.object.nave [al_row]
		
		if IsNull(ls_nave) or trim(ls_nave) = '' then
			gnvo_app.of_mensaje_error( "No ha especificado alguna embarcación propia. Por favor verifique!")
			this.SetColumn("nave")
			return
		end if
		
		ls_sql = "select fl.tripulante as codigo_tripulante, " &
				 + "m.NOM_TRABAJADOR as nombre_tripulante, " &
				 + "fl.cargo_tripulante as cargo_tripulante, " &
				 + "fc.descr_cargo as descripcion_cargo " &
				 + "from fl_tripulantes fl, " &
				 + "     vw_pr_trabajador m, " &
				 + "     fl_cargo_tripulantes fc " &
				 + "where fl.tripulante       = m.COD_TRABAJADOR " &
				 + "  and fl.cargo_tripulante = fc.cargo_tripulante " &
				 + "  and fl.flag_estado      = '1'" &
				 + "  and fl.nave             = '" + ls_nave + "' "

		lb_ret = f_lista_4ret(ls_sql, ls_codigo, ls_data, ls_data2, ls_data3, '2')

		if ls_codigo <> '' then
			this.object.cencos				[al_row] = ls_codigo
			this.object.desc_cencos			[al_row] = ls_data
			this.object.cargo_tripulante	[al_row] = ls_data2
			this.object.descr_cargo			[al_row] = ls_data3
			this.ii_update = 1
		end if
		
	case "cargo_tripulante"
		ls_sql = "select fc.cargo_tripulante as cargo_tripulante, " &
				 + "       fc.descr_cargo as descripcion_cargo " &
				 + "from fl_cargo_tripulantes fc" &
				 + "WHERE fl.FLAG_ESTADO = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.cargo_tripulante	[al_row] = ls_codigo
			this.object.descr_cargo			[al_row] = ls_data
			this.ii_update = 1
		end if

end choose


end event

event rbuttondown;//Override
string ls_texto

if row = 0 or left(lower(dwo.name), 3 ) <> 'dia' then
	
	em_hora.enabled = false
	em_hora.visible = false
	im_menu.PopMenu(w_main.Pointerx( ), w_main.PointerY( ) - dw_master.y + 200)
	
elseif left(lower(dwo.name), 3 ) = 'dia' then
	
	//Obtengo las horas de la celda
	ls_texto = String(this.getItemString( row, lower(dwo.name)))
	
	parent.is_texto = ls_texto
	parent.is_horas = String(parent.of_get_horas( ls_texto ), '00')
	parent.il_row	= row
	parent.is_columna = lower(dwo.name)
	
	em_hora.x = w_main.Pointerx( ) - 15
	em_hora.y = w_main.PointerY( ) - dw_master.y - em_hora.height - 5
	em_hora.enabled = true
	em_hora.visible = true
	em_hora.text = is_horas
	em_hora.SetFocus()
	
	
	
	
end if
end event

event getfocus;call super::getfocus;em_hora.enabled = false
em_hora.visible = false
end event

event ue_delete;//Override
Long 		ll_row, ll_year, ll_mes
String	ls_nombre, ls_codigo, ls_nave, ls_mensaje

if this.GetRow() = 0 then return -1

ll_row = this.GetRow( )

ls_nombre = trim(this.object.tripulante [ll_row]) + ' ' + trim(this.object.nom_trabajador [ll_row])
ls_codigo = this.object.tripulante 	[ll_row]
ls_nave	 = this.object.nave 			[ll_row]

if MessageBox('Información', "¿Desea eliminar la asistencia del tripulante " + ls_nombre &
				+ "?. Si lo confirma ya no hay forma de revertirlo", Information!, Yesno!, 2) = 2 then return -1

ll_mes 	= Long(sle_mes.text)
ll_year	= Long(sle_year.text)

delete from FL_ASISTENCIA fla
where FLA.TRIPULANTE = :ls_codigo
  and fla.nave			= :ls_nave
  and to_number(to_char(fla.fecha, 'yyyy')) 	= :ll_year
  and to_number(to_char(fla.fecha, 'mm')) 	= :ll_mes;

if SQLCA.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	gnvo_app.of_mensaje_error( "Error al eliminar la asistencia del trabajador " + ls_nombre &
									 + " para el periodo: " + string(ll_year) + "/" + trim(string(ll_mes, '00')) &
									 + ". Por favor verifique!" &
									 + "~r~nMensaje de Error: " + ls_mensaje)
	return -1
end if

parent.event ue_retrieve( )

f_mensaje("Eliminación de asistencia realizada satisfactoriamente", '')

return ll_row
end event

type gb_1 from groupbox within w_fl320_asistencia_bonificacion
integer width = 2245
integer height = 196
integer taborder = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Filtro"
end type

