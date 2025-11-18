$PBExportHeader$w_rh230_turnos_establec_rtps.srw
forward
global type w_rh230_turnos_establec_rtps from w_abc
end type
type dw_master from u_dw_abc within w_rh230_turnos_establec_rtps
end type
end forward

global type w_rh230_turnos_establec_rtps from w_abc
integer width = 2734
integer height = 1340
string title = "Turnos por Establecimiento(RH230)"
string menuname = "m_master_simple"
dw_master dw_master
end type
global w_rh230_turnos_establec_rtps w_rh230_turnos_establec_rtps

on w_rh230_turnos_establec_rtps.create
int iCurrent
call super::create
if this.MenuName = "m_master_simple" then this.MenuID = create m_master_simple
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_master
end on

on w_rh230_turnos_establec_rtps.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_master)
end on

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - 10
dw_master.height = newheight - dw_master.y - 10
end event

event ue_insert;call super::ue_insert;Long  ll_row


ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)

end event

event ue_modify;call super::ue_modify;dw_master.of_protect()
end event

event ue_open_pre;call super::ue_open_pre;dw_master.SetTransObject(sqlca)  // Relacionar el dw con la base de datos

dw_master.Retrieve()
idw_1 = dw_master              	// asignar dw corriente
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

type dw_master from u_dw_abc within w_rh230_turnos_establec_rtps
event ue_display ( string as_columna,  long al_row )
integer x = 18
integer y = 20
integer width = 2647
integer height = 1104
string dataobject = "d_abc_turnos_establecimientos_rtps"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event ue_display(string as_columna, long al_row);boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_nro_orden, &
			ls_oper_sec, ls_cencos, ls_desc_cencos, ls_cencos_r, ls_desc_cencos_r, &
			ls_dom
Long		ll_row_find

str_parametros sl_param

choose case upper(as_columna)
		
	case "COD_ESTABLECIMIENTO"

		ls_sql = "SELECT COD_ESTABLECIMIENTO AS CODIGO, " &
				  + "DENOMINACION AS DESCRIPCION " &
				  + "FROM RRHH_ESTABLECIMIENTOS_RTPS "
				 
		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.COD_ESTABLECIMIENTO		[al_row] = ls_codigo
			this.object.denominacion  [al_row] = ls_data
			this.ii_update = 1
		end if
			
	case "TURNO"

		ls_sql = "SELECT TURNO AS CODIGO, " &
				  + "to_char(HORA_ENTRADA) AS HORA_ENTRADA1, HORA_SALIDA AS HORA_SALIDA1 " &
				  + "FROM RRHH_TURNO_ASISTENCIA " &
				  + "WHERE FLAG_ESTADO = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.turno	[al_row] = ls_codigo
			this.ii_update = 1
		end if
		
end choose
end event

event itemchanged;call super::itemchanged;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
	                  // 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1			// columnas de lectrua de este dw

idw_mst = dw_master

end event

event itemerror;call super::itemerror;Return 1
end event

event ue_insert_pre;call super::ue_insert_pre;this.object.flag_estado [al_row] = '1'
end event

event doubleclicked;call super::doubleclicked;string 	ls_columna
long		ll_row

this.Accepttext( )
IF This.describe(dwo.Name + ".Protect") = '1' Then RETURN
ll_row = row

If ll_row > 0 Then
	ls_columna = upper(dwo.name)
	This.event dynamic ue_display(ls_columna, ll_row)
end if
end event

