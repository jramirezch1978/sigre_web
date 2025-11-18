$PBExportHeader$w_pr031_param_asistencia.srw
forward
global type w_pr031_param_asistencia from w_abc
end type
type dw_master from u_dw_abc within w_pr031_param_asistencia
end type
end forward

global type w_pr031_param_asistencia from w_abc
integer width = 1806
integer height = 1736
string title = "(PR031) Parametros de Asistencia"
string menuname = "m_mantto_consulta"
boolean maxbox = false
boolean resizable = false
boolean center = true
dw_master dw_master
end type
global w_pr031_param_asistencia w_pr031_param_asistencia

type variables
String      		is_tabla, is_colname[], is_coltype[]
n_cst_log_diario	in_log

end variables

on w_pr031_param_asistencia.create
int iCurrent
call super::create
if this.MenuName = "m_mantto_consulta" then this.MenuID = create m_mantto_consulta
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_master
end on

on w_pr031_param_asistencia.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_master)
end on

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - 10
dw_master.height = newheight - dw_master.y - 10
end event

event ue_insert;call super::ue_insert;Long  ll_row

if idw_1.RowCount() > 0 then
	MessageBox('Aviso', 'Ya existen un registro, no puede ingresar mas parametros ',StopSign!)
	return
end if
ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)
end event

event ue_modify;call super::ue_modify;idw_1.of_protect()
end event

event ue_open_pre;call super::ue_open_pre;dw_master.SetTransObject(sqlca)  	// Relacionar el dw con la base de datos
idw_1 = dw_master              		// asignar dw corriente

ib_log = TRUE
is_tabla = 'ASISTPARAM'
ib_update_check = true

this.event ue_query_retrieve()

end event

event ue_query_retrieve;// Ancestor Script has been Override
idw_1.Retrieve()
idw_1.ii_protect = 0
idw_1.of_protect()         			// bloquear modificaciones 
if idw_1.RowCount() = 0 then 
	idw_1.event ue_insert()
end if

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

event ue_update_pre;call super::ue_update_pre;ib_update_check = true

if f_row_processing( dw_master, dw_master.is_dwform) = false then
	ib_update_check = false
	return
end if

dw_master.of_set_flag_replicacion()
end event

type dw_master from u_dw_abc within w_pr031_param_asistencia
event ue_display ( string as_columna,  long al_row )
integer width = 1787
integer height = 1556
string dataobject = "d_abc_param_asistencia_ff"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event ue_display(string as_columna, long al_row);boolean lb_ret
string ls_codigo, ls_data, ls_sql
str_parametros sl_param

choose case lower(as_columna)
		
	case "mov_tardanza", "mov_asist_nor"
		
		ls_sql = "SELECT cod_tipo_mov as codigo_movimiento, " &
				  + "desc_movimi AS DESCRIPCION_movimiento " &
				  + "FROM tipo_mov_asistencia " 
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			if lower(as_columna) = "mov_tardanza" then
				this.object.mov_tardanza 		[al_row] = ls_codigo
			else
				this.object.mov_asist_nor 	[al_row] = ls_codigo
			end if
			
			this.ii_update = 1
		end if
		
	case "cnc_diu_normal", "cnc_noc_normal", &
		  "cnc_diu_ext1", "cnc_diu_ext2", &
		  "cnc_noc_ext1", "cnc_noc_ext2", &
		  "cnc_fer_hrs_nor", "cnc_fer_hrs_ext1", &
		  "cnc_fer_hrs_ext2", "cnc_dom_hrs_nor", &
		  "cnc_dom_hrs_ext1", "cnc_dom_hrs_ext2", &
		  "cnc_dominical", "cnc_asig_familiar", &
		  "cnc_feriado", "cnc_fer_dia_desc"
		
		ls_sql = "SELECT concep AS concepto_planilla, " &
				  + "DESC_concep AS DESCRIPCION_concepto " &
				  + "FROM concepto " &
				  + "WHERE FLAG_ESTADO = '1' " &
				  + "order by desc_concep"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.setitem( al_row, lower(as_columna), ls_codigo)
			this.ii_update = 1
		end if
		
	
end choose

end event

event constructor;call super::constructor;is_dwform = 'form'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw

end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

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
	 	this.event dynamic ue_display( ls_columna, ll_row )
	end if
end if
return 0

end event

event ue_insert_pre;call super::ue_insert_pre;this.object.reckey[al_row] = '1'
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

event itemchanged;call super::itemchanged;string ls_codigo, ls_data
this.AcceptText()

if row <= 0 then
	return
end if

choose case upper(dwo.name)
			
		case "SERVICIO_TRANSP"
		
		ls_codigo = this.object.servicio_transp[row]

		SetNull(ls_data)
		select DESCRIPCION
			into :ls_data
		from SERVICIOS
		where SERVICIO = :ls_codigo
		  and flag_estado = '1';
		
		if IsNull(ls_data) or ls_data = "" then
			Messagebox('COMEDORES', "SERVICIO NO EXISTE O NO ESTA ACTIVO", StopSign!)
			SetNull(ls_codigo)
			this.object.servicio_transp[row] = ls_codigo
			this.object.DESCRIPCION 	[row] = ls_codigo
			return 1
		end if

		this.object.descripcion		[row] = ls_data
end choose

end event

