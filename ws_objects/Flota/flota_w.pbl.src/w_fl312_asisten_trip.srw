$PBExportHeader$w_fl312_asisten_trip.srw
forward
global type w_fl312_asisten_trip from w_abc
end type
type pb_menu from picturebutton within w_fl312_asisten_trip
end type
type dw_master from u_dw_abc within w_fl312_asisten_trip
end type
type pb_recuperar from u_pb_std within w_fl312_asisten_trip
end type
type uo_fecha from u_ingreso_rango_fechas within w_fl312_asisten_trip
end type
type st_nomb_nave from statictext within w_fl312_asisten_trip
end type
type st_1 from statictext within w_fl312_asisten_trip
end type
type sle_nave from singlelineedit within w_fl312_asisten_trip
end type
end forward

global type w_fl312_asisten_trip from w_abc
integer width = 2953
integer height = 1724
string title = "Asistencia de Tripulantes (FL312)"
string menuname = "m_mto_smpl"
event ue_retrieve ( )
event ue_act_menu ( boolean ab_estado )
pb_menu pb_menu
dw_master dw_master
pb_recuperar pb_recuperar
uo_fecha uo_fecha
st_nomb_nave st_nomb_nave
st_1 st_1
sle_nave sle_nave
end type
global w_fl312_asisten_trip w_fl312_asisten_trip

type variables
uo_parte_pesca iuo_parte
m_asist_trip   im_asistencia

end variables

forward prototypes
public subroutine of_asist_anterior ()
public subroutine of_trip_zarpe ()
public subroutine of_vista_completa ()
public function integer of_eliminar_asistencia ()
end prototypes

event ue_retrieve();date ld_fecha1, ld_fecha2
string ls_nave

ld_fecha1 = uo_fecha.of_get_fecha1()
ld_fecha2 = uo_fecha.of_get_fecha2()
ls_nave 	 = trim(sle_nave.text)

if IsNull(ls_nave) or ls_nave='' then
	MessageBox('Error', "DEBE INGRESAR EL CODIGO DE ALGUNA NAVE", StopSign!)
	this.event ue_act_menu(false)
	return
end if

dw_master.Retrieve( ls_nave, ld_fecha1, ld_fecha2 )
this.event ue_act_menu(true)
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

public subroutine of_asist_anterior ();string 	ls_nave
date 		ld_fecha1, ld_fecha2

ld_fecha1 = uo_fecha.of_get_fecha1()
ld_fecha2 = uo_fecha.of_get_fecha2()
ls_nave = trim(sle_nave.text)

OpenSheet(w_fl314_asist_anterior, w_main, 0, original!)
w_fl314_asist_anterior.iw_parent = this
w_fl314_asist_anterior.is_nave   = ls_nave
w_fl314_asist_anterior.id_fecha1	= ld_fecha1
w_fl314_asist_anterior.id_fecha2	= ld_fecha2

w_fl314_asist_anterior.event ue_retrieve()
end subroutine

public subroutine of_trip_zarpe ();string 	ls_nave
date 		ld_fecha1, ld_fecha2

ld_fecha1 = uo_fecha.of_get_fecha1()
ld_fecha2 = uo_fecha.of_get_fecha2()
ls_nave = trim(sle_nave.text)

OpenSheet(w_fl315_bus_trip_zarp, w_main, 0, original!)
w_fl315_bus_trip_zarp.iw_parent  = this
w_fl315_bus_trip_zarp.is_nave    = ls_nave
w_fl315_bus_trip_zarp.id_fecha1	= ld_fecha1
w_fl315_bus_trip_zarp.id_fecha2	= ld_fecha2

w_fl315_bus_trip_zarp.event ue_retrieve()
end subroutine

public subroutine of_vista_completa ();string 	ls_nave
date 		ld_fecha1, ld_fecha2

ld_fecha1 = uo_fecha.of_get_fecha1()
ld_fecha2 = uo_fecha.of_get_fecha2()
ls_nave = trim(sle_nave.text)

OpenSheet(w_fl316_vista_asist_trip, w_main, 0, original!)
w_fl316_vista_asist_trip.iw_parent  = this
w_fl316_vista_asist_trip.is_nave    = ls_nave
w_fl316_vista_asist_trip.id_fecha1	= ld_fecha1
w_fl316_vista_asist_trip.id_fecha2	= ld_fecha2

w_fl316_vista_asist_trip.event ue_retrieve()
end subroutine

public function integer of_eliminar_asistencia ();string 	ls_nave, ls_error
date		ld_fecha
long		ll_count
str_parametros lstr_param

ls_nave = sle_nave.text

if ls_nave = '' then
	MessageBox('Aviso', 'Debe ingresar primero un codigo de nave')
	return 0
end if

if MessageBox('Aviso', 'Desea eliminar la asistencia de una determinada Fecha?', Question!, YesNo!, 2) = 2 then return 0
	
ld_fecha = gnvo_app.utilitario.of_get_fecha()
	
if IsNull(ld_fecha) then return 0
	

// Ahora verifico si tiene participacion de pesca, 
// es decir que si se ha procesado plantillas
select count(*)
	into :ll_count
from fl_participacion_pesca flpp
where trunc(flpp.fecha) = trunc(:ld_fecha)
	and flpp.nave = :ls_nave;

if MessageBox('Aviso', 'La Asistencia que intenta eliminar ya ha se ha procesado en planillas' &
		+ 'Desea eliminar la asistencia?', Question!, YesNo!, 2) = 2 then return 0

// Elimino la asistencia
delete fl_asistencia
where nave = :ls_nave
  and trunc(fecha) = trunc(:ld_fecha);

if SQLCA.SQLCode = -1 then
	ls_error = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Error al borrar fl_asistencia', ls_error)
	return 0
end if

// Elimino la participacion de pesca para volverla a calcular
delete fl_participacion_pesca
where nave = :ls_nave
  and trunc(fecha) = trunc(:ld_fecha);

if SQLCA.SQLCode = -1 then
	ls_error = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Error al borrar fl_participacion_pesca', ls_error)
	return 0
end if

// Elimino la consistencia de pesca
delete fl_consistencia_pesca
where nave = :ls_nave
  and trunc(fecha) = trunc(:ld_fecha);

if SQLCA.SQLCode = -1 then
	ls_error = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Error al borrar fl_consistencia_pesca', ls_error)
	return 0
end if

commit;

MessageBox('Aviso', 'Asistencia del dia ' + string(ld_fecha, 'dd/mm/yyyy') + ' ha sido borrada satisfactoriamente')

this.event ue_retrieve()

return 1
end function

on w_fl312_asisten_trip.create
int iCurrent
call super::create
if this.MenuName = "m_mto_smpl" then this.MenuID = create m_mto_smpl
this.pb_menu=create pb_menu
this.dw_master=create dw_master
this.pb_recuperar=create pb_recuperar
this.uo_fecha=create uo_fecha
this.st_nomb_nave=create st_nomb_nave
this.st_1=create st_1
this.sle_nave=create sle_nave
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_menu
this.Control[iCurrent+2]=this.dw_master
this.Control[iCurrent+3]=this.pb_recuperar
this.Control[iCurrent+4]=this.uo_fecha
this.Control[iCurrent+5]=this.st_nomb_nave
this.Control[iCurrent+6]=this.st_1
this.Control[iCurrent+7]=this.sle_nave
end on

on w_fl312_asisten_trip.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_menu)
destroy(this.dw_master)
destroy(this.pb_recuperar)
destroy(this.uo_fecha)
destroy(this.st_nomb_nave)
destroy(this.st_1)
destroy(this.sle_nave)
end on

event ue_open_pre;call super::ue_open_pre;date ld_fecha1, ld_fecha2
iuo_parte = CREATE uo_parte_pesca

ld_fecha1 = date('01/' + String( month( today() ) ,'00' ) &
	+ '/' + string( year( today() ), '0000') )

ld_fecha2 = date('01/' + String( month( today() ) + 1 ,'00' ) &
	+ '/' + string( year( today() ), '0000') )
ld_fecha2 = RelativeDate( ld_fecha2, -1 )

uo_fecha.of_set_fecha( ld_fecha1, ld_fecha2 )

dw_master.SetTransObject(sqlca)  			// Relacionar el dw con la base de datos

idw_1 = dw_master              				// asignar dw corriente
dw_master.of_protect()         				// bloquear modificaciones 

ii_pregunta_delete = 1   						// 1 = si pregunta, 0 = no pregunta (default)
im_asistencia = CREATE m_asist_trip   		// crear menu de boton derecho del mouse

this.event ue_act_menu(false)

end event

event close;call super::close;destroy iuo_parte
destroy im_asistencia
end event

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - 10
dw_master.height = newheight - dw_master.y - 10
end event

event ue_insert;call super::ue_insert;Long  ll_row

ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)
end event

event ue_update;call super::ue_update;Boolean lbo_ok = TRUE

dw_master.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF ib_log THEN
	dw_master.of_create_log()
END IF

IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_master.Update(true, false) = -1 then		// Grabacion del Master
		lbo_ok = FALSE
    	Rollback ;
		messagebox("Error en Grabacion Master","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF ib_log THEN
	IF lbo_ok THEN
		lbo_ok = dw_master.of_save_log()
	END IF
END IF


IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0
	dw_master.ResetUpdate()
END IF
end event

event ue_modify;call super::ue_modify;dw_master.of_protect()
end event

type pb_menu from picturebutton within w_fl312_asisten_trip
integer x = 2085
integer y = 32
integer width = 155
integer height = 132
integer taborder = 40
integer textsize = -2
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "C:\SIGRE\resources\BMP\NOTES.bmp"
string disabledname = "C:\SIGRE\resources\BMP\NOTES.bmp"
alignment htextalign = left!
boolean map3dcolors = true
string powertiptext = "Asistencias Anteriores"
end type

event clicked;string ls_nave

ls_nave = trim(sle_nave.text)

if ls_nave = "" then
	MessageBox('Error', 'DEBE INGRESAR EL CODIGO DE ALGUNA EMBARCACIÓN', StopSign!)
	return
end if
im_asistencia.PopMenu(w_main.PointerX(), w_main.PointerY())
end event

type dw_master from u_dw_abc within w_fl312_asisten_trip
event ue_dblclick ( string as_columna,  long al_row )
integer y = 256
integer width = 2770
integer height = 1016
integer taborder = 20
string dataobject = "d_asistencia_trip_grid"
end type

event ue_dblclick(string as_columna, long al_row);string ls_codigo, ls_data, ls_sql, ls_parte
long ll_count
str_seleccionar lstr_seleccionar

choose case as_columna
		
	case "TRIPULANTE"
		
		ls_sql = "SELECT CODIGO_TRIPULANTE AS COD_TRIP, " &
				 + "NOMB_TRIP AS NOMBRE " &
             + "FROM VW_TRIPULANTES "
				 
		lstr_seleccionar.s_column 	  = '2'
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
			Messagebox('Error', "DEBE SELECCIONAR UN CODIGO DE TRIPULANTES", StopSign!)
			return 
		end if
		
		this.object.nomb_trip[al_row] 	= ls_data		
		this.object.tripulante[al_row] 	= ls_codigo

		//Obtengo el cargo por defecto del tripulante
		ls_codigo = iuo_parte.of_find_cargo_trip( ls_codigo )
		ls_data	 = iuo_parte.of_find_desc_cargo( ls_codigo )
		this.object.cargo_tripulante[al_row] =	ls_codigo
		this.object.descr_cargo[al_row]      = ls_data

		this.ii_update = 1

	case "CARGO_TRIPULANTE"
		
		ls_sql = "SELECT CARGO_TRIPULANTE AS CODIGO, " &
				 + "DESCR_CARGO AS DESCRIPCION " &
             + "FROM FL_CARGO_TRIPULANTES " &
				 + "WHERE FLAG_ESTADO = '1'"
				 
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
			Messagebox('Error', "DEBE SELECCIONAR UN CARGO DE TRIPULANTES", StopSign!)
			return 
		end if
		
		this.object.descr_cargo[al_row] 			= ls_data		
		this.object.cargo_tripulante[al_row] 	= ls_codigo
		this.ii_update = 1

end choose
end event

event constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw
end event

event doubleclicked;call super::doubleclicked;long ll_row

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = this.GetRow()
this.event ue_dblclick(upper(dwo.name), ll_row)
end event

event itemchanged;call super::itemchanged;string 	ls_codigo, ls_data, ls_tipo, ls_mensaje
long 		ll_row, ll_count, ll_horas
Date		ld_fecha
DateTime	ldt_hora_ing, ldt_hora_sal

this.AcceptText()
ll_row = this.GetRow()
choose case upper(dwo.name)
	case "TRIPULANTE"
		
		ls_codigo = this.object.tripulante[ll_row]

		SetNull(ls_data)
		select nomb_trip
			into :ls_data
		from vw_tripulantes
		where codigo_tripulante = :ls_codigo;
		
		if IsNull(ls_data) or ls_data = "" then
			Messagebox('Error', "CODIGO DE TRIPULANTE NO EXISTE", StopSign!)
			return 1
		end if
		
		this.object.nomb_trip[ll_row] 		 = ls_data

		//Obtengo el cargo por defecto del tripulante
		ls_codigo = iuo_parte.of_find_cargo_trip( ls_codigo )
		ls_data	 = iuo_parte.of_find_desc_cargo( ls_codigo )
		this.object.cargo_tripulante[ll_row] =	ls_codigo
		this.object.descr_cargo[ll_row]      = ls_data

	case "CARGO_TRIPULANTE"
		
		ls_codigo = this.object.cargo_tripulante[ll_row]

		ls_data	 = iuo_parte.of_find_desc_cargo( ls_codigo )
		
		if ls_data = "" then
			Messagebox('Error', "CODIGO DE CARGO NO EXISTE", StopSign!)
			return 1
		end if
		
		this.object.descr_cargo[ll_row] = ls_data

	case "fecha"
		
		ld_fecha = Date(this.object.fecha 	[row])
		ll_horas	= Long(this.object.horas	[row])
		
		select to_date(to_char(:ld_fecha, 'dd/mm/yyyy') + ' 08:00', 'dd/mm/yyyy hh:mi')
			into :ldt_hora_ing
		from dual;
		
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Error', 'Ha ocurrido un error al obtener la hora de INGRESO. Mensaje: ' + ls_mensaje, StopSign!)
			return
		end if
		
		select :ldt_hora_ing + :ll_horas /24
			into :ldt_hora_sal
		from dual;
		
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Error', 'Ha ocurrido un error al obtener la hora de SALIDA. Mensaje: ' + ls_mensaje, StopSign!)
			return
		end if
		
		this.object.hora_ing					[row] = ldt_hora_ing
		this.object.hora_sal					[row] = ldt_hora_sal

	case "horas"
		
		ldt_hora_ing 	= DateTime(this.object.hora_ing 	[row])
		ll_horas			= Long(this.object.horas			[row])
		
		select :ldt_hora_ing + :ll_horas /24
			into :ldt_hora_sal
		from dual;
		
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Error', 'Ha ocurrido un error al obtener la hora de SALIDA. Mensaje: ' + ls_mensaje, StopSign!)
			return
		end if
		
		this.object.hora_sal					[row] = ldt_hora_sal		

	case "hora_ing"
		
		ldt_hora_ing 	= DateTime(this.object.hora_ing 	[row])
		ll_horas			= Long(this.object.horas			[row])
		
		select :ldt_hora_ing + :ll_horas /24
			into :ldt_hora_sal
		from dual;
		
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Error', 'Ha ocurrido un error al obtener la hora de SALIDA. Mensaje: ' + ls_mensaje, StopSign!)
			return
		end if
		
		this.object.hora_sal					[row] = ldt_hora_sal	
end choose

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
	 	this.event ue_dblclick( ls_columna, ll_row )
	end if
end if
return 0
end event

event rowfocuschanged;call super::rowfocuschanged;This.SelectRow(0, false)
this.SelectRow(currentrow, true)
this.SetRow(currentrow)
end event

event ue_insert_pre;call super::ue_insert_pre;date 		ld_fecha
string 	ls_nave, ls_mensaje
DateTime ldt_hora_sal, ldt_hora_ing

ld_fecha = Date(gnvo_app.of_fecha_actual())
ls_nave  = (sle_nave.text)
this.object.fecha						[al_row] = ld_fecha
this.object.nave						[al_row] = ls_nave
this.object.flag_tipo_asistencia	[al_row] = 'TF'  //Por defecto el tipo de asistecia es Trabajo en Faena
this.object.flag_replicacion		[al_row] = '1'
this.object.flag_reintegro			[al_row] = '0'


select to_date(to_char(sysdate, 'dd/mm/yyyy') || ' 08:00', 'dd/mm/yyyy hh:mi')
	into :ldt_hora_ing
from dual;

if SQLCA.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Error', 'Ha ocurrido un error al obtener la hora de ingreso. Mensaje: ' + ls_mensaje, StopSign!)
	post event closequery()
	return
end if

select :ldt_hora_ing + 8 /24
	into :ldt_hora_sal
from dual;

if SQLCA.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Error', 'Ha ocurrido un error al obtener la hora de SALDA. Mensaje: ' + ls_mensaje, StopSign!)
	post event closequery()
	return
end if

this.object.horas						[al_row] = 8
this.object.hora_ing					[al_row] = ldt_hora_ing
this.object.hora_sal					[al_row] = ldt_hora_sal



end event

type pb_recuperar from u_pb_std within w_fl312_asisten_trip
integer x = 1915
integer y = 32
integer width = 155
integer height = 132
integer taborder = 30
integer textsize = -2
string text = "&r"
string picturename = "Retrieve!"
boolean map3dcolors = true
string powertiptext = "Recuperar Datos"
end type

event clicked;call super::clicked;parent.event ue_retrieve()
end event

type uo_fecha from u_ingreso_rango_fechas within w_fl312_asisten_trip
event destroy ( )
integer x = 50
integer y = 32
integer taborder = 40
end type

on uo_fecha.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;of_set_label('Desde:','Hasta:') //para setear la fecha inicial
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final

end event

type st_nomb_nave from statictext within w_fl312_asisten_trip
integer x = 818
integer y = 148
integer width = 951
integer height = 88
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 67108864
boolean border = true
boolean focusrectangle = false
end type

type st_1 from statictext within w_fl312_asisten_trip
integer x = 59
integer y = 160
integer width = 421
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Codigo de Nave:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_nave from singlelineedit within w_fl312_asisten_trip
event ue_dblclick pbm_lbuttondblclk
event ue_desp_naves ( )
event ue_keydwn pbm_keydown
integer x = 507
integer y = 148
integer width = 293
integer height = 88
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long textcolor = 33554432
textcase textcase = upper!
integer limit = 8
borderstyle borderstyle = stylelowered!
end type

event ue_dblclick;this.event ue_desp_naves()
end event

event ue_desp_naves();// Este evento despliega la pantalla w_seleccionar

string ls_codigo, ls_data, ls_sql
integer li_i
str_seleccionar lstr_seleccionar

ls_sql = "SELECT NAVE AS CODIGO, " &
		 + "NOMB_NAVE AS DESCRIPCION, " &
		 + "FLAG_TIPO_FLOTA AS TIPO_FLOTA " &
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
		
st_nomb_nave.text = ls_data		
this.text	 		= ls_codigo
parent.event ue_retrieve()
end event

event ue_keydwn;if Key = KeyF2! then
	this.event ue_desp_naves()	
end if
end event

event modified;string ls_codigo, ls_data

If not IsValid(iuo_parte) then
	return
end if

ls_codigo = trim(this.text)

ls_data = iuo_parte.of_get_nomb_nave( ls_codigo )
		
if ls_data = "" then
	Messagebox('Error', "CODIGO DE NAVE NO EXISTE", StopSign!)
	this.text = ""
	st_nomb_nave.text = ""
	dw_master.reset()
	parent.event ue_act_menu(false)
	return
end if
		
if iuo_parte.of_get_tipo_flota( ls_codigo ) <> 'P' then
	Messagebox('Error', "SOLO SE PUEDEN REGISTRAR ASISTENCIA EN EMBACARCIONES PROPIAS", StopSign!)
	this.text = ""
	st_nomb_nave.text = ""
	dw_master.reset()
	parent.event ue_act_menu(false)
	return
end if
st_nomb_nave.text = ls_data

parent.event ue_retrieve()
end event

