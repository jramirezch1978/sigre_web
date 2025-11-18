$PBExportHeader$w_ma007_operadores_maq.srw
forward
global type w_ma007_operadores_maq from w_abc_list
end type
type st_1 from statictext within w_ma007_operadores_maq
end type
type st_2 from statictext within w_ma007_operadores_maq
end type
end forward

global type w_ma007_operadores_maq from w_abc_list
integer width = 3429
integer height = 1952
string title = "Mantenimiento de Operadores  (MA007)"
string menuname = "m_abc_list"
st_1 st_1
st_2 st_2
end type
global w_ma007_operadores_maq w_ma007_operadores_maq

on w_ma007_operadores_maq.create
int iCurrent
call super::create
if this.MenuName = "m_abc_list" then this.MenuID = create m_abc_list
this.st_1=create st_1
this.st_2=create st_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.st_2
end on

on w_ma007_operadores_maq.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.st_2)
end on

event ue_open_pre();call super::ue_open_pre;dw_1.SetTransObject(sqlca)  		// Relacionar el dw con la base de datos
dw_2.SetTransObject(sqlca)

of_position_window(0,0)       			// Posicionar la ventana en forma fija
//Help
ii_help = 9    	       					// help topic
//ii_pregunta_delete = 1   				// 1 = si pregunta, 0 = no pregunta (default)

dw_1.Retrieve()
dw_2.Retrieve()

idw_1 = dw_2
end event

event ue_update_request;call super::ue_update_request;Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
IF (dw_1.ii_update = 1 OR dw_2.ii_update = 1) THEN
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	IF li_msg_result = 1 THEN
 		this.TriggerEvent("ue_update")
	END IF
END IF

end event

event ue_update;call super::ue_update;Boolean lbo_ok = TRUE

dw_2.AcceptText()

THIS.EVENT ue_update_pre()

IF dw_2.Update() = -1 then		// Grabacion del detalle
	lbo_ok = FALSE
	messagebox("Error en Grabacion","Se ha procedido al rollback",exclamation!)
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_1.ii_update = 0
	dw_2.ii_update = 0
ELSE 
	ROLLBACK USING SQLCA;
END IF

end event

event ue_update_pre;call super::ue_update_pre;dw_2.of_set_flag_replicacion( )
end event

type dw_1 from w_abc_list`dw_1 within w_ma007_operadores_maq
integer y = 108
integer width = 1317
integer height = 1600
string dataobject = "d_maestro_no_opermaq_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_1::constructor;call super::constructor;ii_ck[1] = 1          // columna, que juega como key

ii_dk[1] = 1				// Deploy key
ii_dk[2] = 2
ii_dk[3] = 3

ii_rk[1] = 1
ii_rk[2] = 2	
ii_rk[3] = 3	



end event

event dw_1::ue_selected_row_pro;call super::ue_selected_row_pro;Long	ll_row, ll_rc
Any	la_id
Integer	li_x

ll_row = idw_det.EVENT ue_insert()

FOR li_x = 1 to UpperBound(ii_dk)
	la_id = THIS.object.data.primary.current[al_row, ii_dk[li_x]]	
	ll_rc = idw_det.SetItem(ll_row, idw_det.ii_rk[li_x], la_id)
NEXT

idw_det.ScrollToRow(ll_row)


end event

event dw_1::ue_selected_row_pos;call super::ue_selected_row_pos;Long	ll_row, ll_y

ll_row = THIS.GetSelectedRow(0)

Do While ll_row <> 0
	THIS.DeleteRow(ll_row)
	ll_row = THIS.GetSelectedRow(0)
Loop

end event

event dw_1::itemerror;call super::itemerror;Return 1
end event

type dw_2 from w_abc_list`dw_2 within w_ma007_operadores_maq
integer x = 1591
integer y = 108
integer width = 1783
integer height = 1600
string dataobject = "d_abc_operador_maq_tbl"
boolean vscrollbar = true
end type

event dw_2::constructor;call super::constructor;ii_ck[1] = 1          // columna, que juega como key

ii_dk[1] = 1				// Deploy key
ii_dk[2] = 2
ii_dk[3] = 3

ii_rk[1] = 1
ii_rk[2] = 2	
ii_rk[3] = 3	


end event

event dw_2::ue_selected_row_pro;call super::ue_selected_row_pro;Long	ll_row, ll_rc
Any	la_id
Integer	li_x

ll_row = idw_det.EVENT ue_insert()

FOR li_x = 1 to UpperBound(ii_dk)
	la_id = THIS.object.data.primary.current[al_row, ii_dk[li_x]]	
	ll_rc = idw_det.SetItem(ll_row, idw_det.ii_rk[li_x], la_id)
NEXT

idw_det.ScrollToRow(ll_row)



end event

event dw_2::ue_selected_row_pos;call super::ue_selected_row_pos;Long	ll_row, ll_y

ll_row = THIS.GetSelectedRow(0)

Do While ll_row <> 0
	THIS.DeleteRow(ll_row)
	ll_row = THIS.GetSelectedRow(0)
Loop

end event

event dw_2::itemerror;call super::itemerror;Return 1
end event

type pb_1 from w_abc_list`pb_1 within w_ma007_operadores_maq
integer x = 1394
integer y = 560
end type

type pb_2 from w_abc_list`pb_2 within w_ma007_operadores_maq
integer x = 1394
integer y = 1168
end type

type st_1 from statictext within w_ma007_operadores_maq
integer x = 18
integer y = 36
integer width = 1317
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 134217752
long backcolor = 134217730
boolean enabled = false
string text = "Trabajador"
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_2 from statictext within w_ma007_operadores_maq
integer x = 1591
integer y = 36
integer width = 1783
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 134217752
long backcolor = 134217730
boolean enabled = false
string text = "Operador"
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

