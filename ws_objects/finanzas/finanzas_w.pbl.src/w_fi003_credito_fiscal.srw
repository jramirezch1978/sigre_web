$PBExportHeader$w_fi003_credito_fiscal.srw
forward
global type w_fi003_credito_fiscal from w_abc
end type
type dw_master from u_dw_abc within w_fi003_credito_fiscal
end type
end forward

global type w_fi003_credito_fiscal from w_abc
integer width = 3113
integer height = 1576
string title = "Credito Fiscal (FI003)"
string menuname = "m_mantenimiento_sl"
dw_master dw_master
end type
global w_fi003_credito_fiscal w_fi003_credito_fiscal

on w_fi003_credito_fiscal.create
int iCurrent
call super::create
if this.MenuName = "m_mantenimiento_sl" then this.MenuID = create m_mantenimiento_sl
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_master
end on

on w_fi003_credito_fiscal.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_master)
end on

event ue_open_pre();call super::ue_open_pre;dw_master.SetTransObject(sqlca)  			// Relacionar el dw con la base de datos
dw_master.Retrieve()
idw_1 = dw_master              				// asignar dw corriente


dw_master.of_protect()         		// bloquear modificaciones 


of_position_window(0,0)       			// Posicionar la ventana en forma fija
//ii_help = 101           					// help topic

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

event ue_update_pre;call super::ue_update_pre;//--VERIFICACION Y ASIGNACION 
IF f_row_Processing( dw_master, "tabular") <> true then	
	ib_update_check = False	
	return
ELSE
	ib_update_check = True
END IF

dw_master.of_set_flag_replicacion ()
end event

event type long ue_scrollrow(string as_value);call super::ue_scrollrow;Long ll_rc

ll_rc = idw_1.of_ScrollRow(as_value)

RETURN ll_rc

end event

event ue_modify();call super::ue_modify;Int li_protect

dw_master.of_protect()

li_protect = integer(dw_master.Object.tipo_cred_fiscal.Protect)

IF li_protect = 0 THEN
   dw_master.Object.tipo_cred_fiscal.Protect = 1
END IF 

end event

event ue_insert();call super::ue_insert;Long  ll_row



ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)


end event

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - 10
dw_master.height = newheight - dw_master.y - 10
end event

type dw_master from u_dw_abc within w_fi003_credito_fiscal
integer width = 2962
integer height = 1236
string dataobject = "d_abc_tipo_credito_fiscal_tbl"
end type

event ue_insert_pre(long al_row);call super::ue_insert_pre;dw_master.Modify("tipo_cred_fiscal.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("descripcion.Protect='1~tIf(IsRowNew(),0,1)'")
end event

event itemerror;call super::itemerror;Return 1	
end event

event itemchanged;call super::itemchanged;String ls_data

this.Accepttext()

CHOOSE CASE dwo.name
	CASE 'tipo_afectacion_igv'
		
		// Verifica que codigo ingresado exista			
		Select desc_tipo_afectacion_igv
	     into :ls_data
		  from sunat_catalogo07
		 Where tipo_afectacion_igv = :data 
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQLCode = 100 then
			this.object.tipo_afectacion_igv			[row] = gnvo_app.is_null
			this.object.desc_tipo_afectacion_igv	[row] = gnvo_app.is_null
			MessageBox('Error', 'Tipo de Afectación de IGV no existe o no esta activo, por favor verifique')
			return 1
		end if

		this.object.desc_tipo_afectacion_igv			[row] = ls_data

END CHOOSE
end event

event rowfocuschanged;call super::rowfocuschanged;f_select_current_row (This)
end event

event constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 1				// indica si se usa seleccion: 1=individual (default), 0=multiple


ii_ck[1] = 1				// columnas de lectrua de este dw

idw_mst  = dw_master				// dw_master

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
	case "tipo_afectacion_igv"
		ls_sql = "select t.tipo_afectacion_igv as tipo_afectacion_igv, " &
				 + "t.desc_tipo_afectacion_igv as desc_tipo_afectacion_igv " &
				 + "from SUNAT_CATALOGO07 t " &
				 + "where t.flag_estado = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

		if ls_codigo <> '' then
			this.object.tipo_afectacion_igv			[al_row] = ls_codigo
			this.object.desc_tipo_afectacion_igv	[al_row] = ls_data
			this.ii_update = 1
		end if
		

end choose
end event

