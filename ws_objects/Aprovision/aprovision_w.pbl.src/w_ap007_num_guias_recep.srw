$PBExportHeader$w_ap007_num_guias_recep.srw
forward
global type w_ap007_num_guias_recep from w_abc
end type
type dw_master from u_dw_abc within w_ap007_num_guias_recep
end type
end forward

global type w_ap007_num_guias_recep from w_abc
integer width = 1207
integer height = 480
string title = "Numerador Guias de Recepción (AP007)"
string menuname = "m_ap_param"
dw_master dw_master
end type
global w_ap007_num_guias_recep w_ap007_num_guias_recep

on w_ap007_num_guias_recep.create
int iCurrent
call super::create
if this.MenuName = "m_ap_param" then this.MenuID = create m_ap_param
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_master
end on

on w_ap007_num_guias_recep.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_master)
end on

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - 10
dw_master.height = newheight - dw_master.y - 10
end event

event ue_open_pre;call super::ue_open_pre;dw_master.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos
idw_1 = dw_master              				// asignar dw corriente

idw_1.ii_protect = 0
dw_master.of_protect()         		// bloquear modificaciones 
idw_1.Retrieve(gs_origen)

IF idw_1.getrow( ) = 0 THEN
	This.event ue_insert( )
END IF

end event

event ue_query_retrieve;idw_1.Retrieve(gs_origen)
idw_1.ii_protect = 0
idw_1.of_protect()
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

event ue_modify;call super::ue_modify;idw_1.of_protect()
end event

event ue_insert;call super::ue_insert;Long  ll_row, ll_guias

select count(*) 
	into :ll_guias
	from num_ap_guias_recep nagr 
	where nagr.cod_origen = :gs_origen;

if ll_guias >= 1 then 
	messagebox(this.title, 'Ya existe numerador para este origen', StopSign!)
	return
end if

ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)

end event

type dw_master from u_dw_abc within w_ap007_num_guias_recep
integer x = 5
integer y = 48
integer width = 1157
integer height = 220
string dataobject = "d_ap_num_guias_recep_ff"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event constructor;call super::constructor;is_dwform = 'form'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw

end event

event ue_insert;long ll_row

ll_row = this.RowCount()

if ll_row > 0 then
	MessageBox('APROVISIONAMIENTO', 'NO PUEDE INGRESAR MAS REGISTROS, YA EXISTE UN NUMERADOR',StopSign!)
	return -1
end if

ll_row = THIS.InsertRow(0)				// insertar registro maestro

ib_insert_mode = false

IF ll_row = -1 then
	messagebox("Error en Ingreso","No se ha procedido",exclamation!)
ELSE
	ii_protect = 1
	of_protect() // desprotege el dw
	ii_update = 1
	il_row = ll_row
	THIS.Event ue_insert_pre(ll_row) // Asignaciones automaticas
	THIS.ScrollToRow(ll_row)			// ubicar el registro
	THIS.SetColumn(1)
	THIS.SetFocus()						// poner el focus en el primer campo
END IF

RETURN ll_row

end event

event ue_insert_pre;call super::ue_insert_pre;string ls_nombre

select o.nombre 
	into :ls_nombre
	from origen o 
	where o.cod_origen = :gs_origen;
	
this.object.nombre[al_row] = ls_nombre
this.object.cod_origen[al_row] = gs_origen
this.object.ult_nro[al_row]	 = 1

end event

