$PBExportHeader$w_ve018_puntos_venta.srw
forward
global type w_ve018_puntos_venta from w_abc
end type
type dw_master from u_dw_abc within w_ve018_puntos_venta
end type
end forward

global type w_ve018_puntos_venta from w_abc
integer width = 3081
integer height = 1692
string title = "[VE018] Puntos de Venta"
string menuname = "m_mantenimiento_sl"
boolean maxbox = false
boolean resizable = false
dw_master dw_master
end type
global w_ve018_puntos_venta w_ve018_puntos_venta

on w_ve018_puntos_venta.create
int iCurrent
call super::create
if this.MenuName = "m_mantenimiento_sl" then this.MenuID = create m_mantenimiento_sl
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_master
end on

on w_ve018_puntos_venta.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_master)
end on

event ue_update();call super::ue_update;Boolean lbo_ok = TRUE

dw_master.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN


IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_master.Update() = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		messagebox("Error en Grabacion Master","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0
ELSE 
	ROLLBACK USING SQLCA;
END IF

end event

event ue_update_request();call super::ue_update_request;Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
IF (dw_master.ii_update = 1 ) THEN
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	IF li_msg_result = 1 THEN
 		this.TriggerEvent("ue_update")
	ELSE
		dw_master.ii_update = 0
		
	END IF
END IF

end event

event ue_open_pre;call super::ue_open_pre;dw_master.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos
dw_master.Retrieve()
idw_1 = dw_master              				// asignar dw corriente
dw_master.of_protect()         		// bloquear modificaciones 


end event

event ue_insert();call super::ue_insert;Long  ll_row


ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)




end event

event ue_update_pre;call super::ue_update_pre;
IF f_row_Processing( dw_master, "tabular") <> true then	
	ib_update_check = False	
	return
ELSE
	ib_update_check = True
END IF


dw_master.of_set_flag_replicacion()
end event

event ue_modify();call super::ue_modify;Int li_protect

dw_master.of_protect()

li_protect = integer(dw_master.Object.punto_venta.Protect)

IF li_protect = 0 THEN
   dw_master.Object.punto_venta.Protect = 1
END IF 
end event

event type long ue_scrollrow(string as_value);call super::ue_scrollrow;Long ll_rc

ll_rc = idw_1.of_ScrollRow(as_value)

RETURN ll_rc
end event

type dw_master from u_dw_abc within w_ve018_puntos_venta
integer width = 2761
integer height = 1120
string dataobject = "d_abc_punto_ventas_tbl"
end type

event itemerror;call super::itemerror;Return 1
end event

event itemchanged;call super::itemchanged;string 	ls_data

This.AcceptText()
if row = 0 then return
if dw_master.GetRow() = 0 then return

CHOOSE CASE lower(dwo.name)
		
	CASE 'cod_origen'

		SELECT nombre 
			INTO :ls_data
		FROM origen
   	WHERE cod_origen = :data
		  and flag_estado = '1';
		  
		IF SQLCA.SQLCODE = 100 THEN
			Messagebox('Aviso','Codigo de Origen/Sucursal no existe o no se encuenta activo, por favor verifique!', StopSign!)
				
			this.Object.cod_origen	[row] = gnvo_app.is_null
			this.object.nom_origen	[row] = gnvo_app.is_null
			this.setcolumn( "cod_origen" )
		 	this.setfocus()
			RETURN 1
		END IF
		
		this.object.nom_origen [row] = ls_data

END CHOOSE

end event

event constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)
ii_ss = 1 				   // indica si se usa seleccion: 1=individual (default), 0=multiple
ii_ck[1] = 1				// columnas de lectrua de este dw
idw_mst  = dw_master		// dw_master

end event

event ue_insert_pre(long al_row);call super::ue_insert_pre;dw_master.Modify("punto_venta.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("desc_pto_vta.Protect='1~tIf(IsRowNew(),0,1)'")



end event

event rowfocuschanged;call super::rowfocuschanged;f_select_current_row (This)
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
	case "cod_origen"
		ls_sql = "SELECT cod_origen AS CODIGO_origen, " &
				  + "nombre AS descripcion_origen " &
				  + "FROM origen " &
				  + "WHERE FLAG_ESTADO = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.cod_origen	[al_row] = ls_codigo
			this.object.nom_origen	[al_row] = ls_data
			this.ii_update = 1
		end if
end choose
end event

