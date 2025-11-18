$PBExportHeader$w_fl014_tripulantes.srw
forward
global type w_fl014_tripulantes from w_abc
end type
type dw_master from u_dw_abc within w_fl014_tripulantes
end type
end forward

global type w_fl014_tripulantes from w_abc
integer width = 2898
integer height = 908
string title = "Maestro de Tripulantes (FL014)"
string menuname = "m_mto_smpl_cslta"
boolean resizable = false
dw_master dw_master
end type
global w_fl014_tripulantes w_fl014_tripulantes

on w_fl014_tripulantes.create
int iCurrent
call super::create
if this.MenuName = "m_mto_smpl_cslta" then this.MenuID = create m_mto_smpl_cslta
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_master
end on

on w_fl014_tripulantes.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_master)
end on

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - 10
dw_master.height = newheight - dw_master.y - 10

end event

event ue_open_pre;call super::ue_open_pre;//idw_query = dw_master
idw_1 = dw_master
idw_1.SetTransObject(SQLCA)
end event

event ue_update;call super::ue_update;Boolean lbo_ok = TRUE

If idw_1.GetRow() <= 0 then
	return
end if
idw_1.AcceptText()

ib_update_check = TRUE

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF idw_1.Update() = -1 then		// Grabacion del Master
	lbo_ok = FALSE
   Rollback ;
	messagebox("Error en Grabacion Master","Se ha procedido al rollback",exclamation!)
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	idw_1.ii_update  = 0
	idw_1.ii_protect = 0
	idw_1.of_protect( )
END IF

end event

event ue_insert;call super::ue_insert;Long  ll_row

ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)

end event

event ue_update_request;call super::ue_update_request;Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
IF idw_1.ii_update = 1 THEN
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	IF li_msg_result = 1 THEN
 		this.TriggerEvent("ue_update")
	ELSE
		idw_1.ii_update = 0
	END IF
END IF

end event

event ue_retrieve_list;call super::ue_retrieve_list;//override
// Asigna valores a structura 
Long   ll_row , ll_inicio
str_parametros sl_param

sl_param.dw1    = 'ds_tripulante_grid'
sl_param.titulo = 'tripulantes'
sl_param.field_ret_i[1] = 1	//Codigo Tripulante
sl_param.field_ret_i[2] = 2	//Nombre Tripulante
sl_param.field_ret_i[3] = 3	//Codigo Nave
sl_param.field_ret_i[4] = 4	//Nombre Nave

OpenWithParm( w_lista, sl_param)

sl_param = Message.PowerObjectParm
IF sl_param.titulo <> 'n' THEN
	idw_1.Retrieve(sl_param.field_ret[1])
END IF
end event

event ue_update_pre;call super::ue_update_pre;string ls_dni, ls_nave, ls_tripulante, ls_cargo
integer li_row

li_row = idw_1.GetRow()

ls_dni 			= idw_1.object.dni[li_row] 
ls_nave 			= idw_1.object.nave[li_row] 
ls_tripulante	= idw_1.object.tripulante[li_row] 
ls_cargo			= idw_1.object.cargo_tripulante[li_row] 

if not IsNull(ls_dni) and len(ls_dni) < 8 then
	MessageBox('Error en Ingreso', 'El numero de DNI es menor a 8 digitos' )
	ib_update_check = FALSE
	return
end if

if IsNull(ls_nave) then
	MessageBox('Error en Ingreso', 'El tripulante debe estar asignado a una nave' )
	ib_update_check = FALSE
	return
end if

if IsNull(ls_tripulante) then
	MessageBox('Error en Ingreso', 'El tripulante debe tener un codigo' )
	ib_update_check = FALSE
	return
end if

if IsNull(ls_cargo) then
	MessageBox('Error en Ingreso', 'El tripulante debe tener un cargo en la nave' )
	ib_update_check = FALSE
	return
end if

idw_1.of_set_flag_replicacion()


end event

event ue_modify;call super::ue_modify;dw_master.of_protect()
//dw_detail.of_protect()
end event

type dw_master from u_dw_abc within w_fl014_tripulantes
integer width = 2775
integer height = 704
string dataobject = "d_tripulantes_ff"
boolean hscrollbar = false
boolean vscrollbar = false
end type

event constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
is_dwform = 'form'
end event

event itemchanged;call super::itemchanged;string ls_data, ls_null
long ll_row, ll_count

SetNull(ls_null)
this.AcceptText()
ll_row = this.GetRow()
choose case upper(dwo.name)
	case "COD_TRABAJADOR"
		select apel_paterno || ' ' || apel_materno
			|| ', ' || nombre1 
			into :ls_data
		from maestro
		where cod_trabajador = :data;
		
		IF SQLCA.SQLCode = 100 THEN
			Messagebox('Error', "CODIGO DE TRABAJADOR NO EXISTE", StopSign!)
			this.object.cod_trabajador 	[ll_row] = ls_null
			this.object.nombre_tripulante	[ll_row] = ls_null
			this.object.tripulante			[ll_row] = ls_null
			RETURN 1
		END IF
		
		select count(*)
			into :ll_count
		from fl_tripulantes
		where tripulante = :data;
		
		if ll_count > 0 then
			Messagebox('Error', "TRABAJADOR EXISTE EN MAESTRO DE TRIPULANTES", StopSign!)
			this.object.cod_trabajador 	[ll_row] = ls_null
			this.object.nombre_tripulante	[ll_row] = ls_null
			this.object.tripulante			[ll_row] = ls_null
			return 1
		end if

		this.object.nombre_tripulante[ll_row] = ls_data
		this.object.tripulante[ll_row]        = data

	case "CARGO_TRIPULANTE"
		select descr_cargo
			into :ls_data
		from fl_cargo_tripulantes
		where cargo_tripulante = :data;

		IF SQLCA.SQLCode = 100 THEN
			Messagebox('Error', "CARGO DE TRIPULANTE NO EXISTE", StopSign!)
			this.object.cargo_tripulante	[ll_row] = ls_null
			this.object.descr_cargo			[ll_row] = ls_null
			RETURN 1
		END IF

		this.object.descr_cargo[ll_row] = ls_data


	case "NAVE"
		select nomb_nave
			into :ls_data
		from tg_naves
		where nave = :data;

		IF SQLCA.SQLCode = 100 THEN
			Messagebox('Error', "CODIGO DE NAVE NO EXISTE", StopSign!)
			this.object.nave		[ll_row] = ls_null
			this.object.nomb_nave[ll_row] = ls_null
			RETURN 1
		END IF

		this.object.nomb_nave[ll_row] = ls_data

end choose

end event

event ue_insert;call super::ue_insert;this.object.flag_estado[this.GetRow()] = '1'
return 1
end event

event doubleclicked;call super::doubleclicked;string ls_codigo, ls_data, ls_sql
long ll_row, ll_count
integer li_i
str_seleccionar lstr_seleccionar

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = this.GetRow()
choose case upper(dwo.name)
		
	case "COD_TRABAJADOR"
		
		ls_sql = "SELECT COD_TRABAJADOR AS CODIGO, " &
				 + "APEL_PATERNO AS APELLIDO_PATERNO, " &
				 + "APEL_MATERNO AS APELLIDO_MATERNO, " &
				 + "NOMBRE1 AS NOMBRE " &
             + "FROM MAESTRO"	
				 
		lstr_seleccionar.s_column 	  = '2'
		lstr_seleccionar.s_sql       = ls_sql
		lstr_seleccionar.s_seleccion = 'S'

		OpenWithParm(w_seleccionar,lstr_seleccionar)
		
		IF isvalid(message.PowerObjectParm) THEN 
			lstr_seleccionar = message.PowerObjectParm
		END IF	
		IF lstr_seleccionar.s_action = "aceptar" THEN
			ls_codigo = lstr_seleccionar.param1[1]
			ls_data   = trim(lstr_seleccionar.param2[1]) + ' ' &
				+ trim(lstr_seleccionar.param3[1]) + ', ' &
				+ trim(lstr_seleccionar.param4[1])
		ELSE		
			Messagebox('Error', "DEBE SELECCIONAR UN CODIGO DE TRABAJADOR", StopSign!)
			return 1
		end if

		select count(*)
			into :ll_count
		from fl_tripulantes
		where tripulante = :ls_codigo;
		
		if ll_count > 0 then
			Messagebox('Error', "TRABAJADOR EXISTE EN MAESTRO DE TRIPULANTES", StopSign!)
			return 1
		end if


		this.object.nombre_tripulante[ll_row] = ls_data		
		this.object.cod_trabajador[ll_row] 	  = ls_codigo
		this.object.tripulante[ll_row]        = ls_codigo
		this.ii_update = 1

	case "CARGO_TRIPULANTE"

		ls_sql = "SELECT CARGO_TRIPULANTE AS CODIGO, " &
				 + "DESCR_CARGO AS DESCRIPCION " &
             + "FROM FL_CARGO_TRIPULANTES " &
				 + "WHERE FLAG_ESTADO = '1'"
				 
		lstr_seleccionar.s_column = '2'
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
			Messagebox('Error', "DEBE SELECCIONAR UN CARGO DE TRIPULANTE", StopSign!)
			return 1
		end if

		this.object.cargo_tripulante[ll_row] = ls_codigo 
		this.object.descr_cargo[ll_row] = ls_data
		this.ii_update = 1

	case "NAVE"

		ls_sql = "SELECT NAVE AS CODIGO, " &
				 + "NOMB_NAVE AS NOMBRE " &
             + "FROM TG_NAVES " &
				 + "WHERE FLAG_TIPO_FLOTA = 'P'"
				 
		lstr_seleccionar.s_column = '1'
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
			Messagebox('Error', "DEBE SELECCIONAR UNA NAVE", StopSign!)
			return 1
		end if
		
		
		this.object.nave[ll_row] 		= ls_codigo
		this.object.nomb_nave[ll_row] = ls_data
		this.ii_update = 1
		
end choose

end event

event itemerror;call super::itemerror;RETURN 1
end event

