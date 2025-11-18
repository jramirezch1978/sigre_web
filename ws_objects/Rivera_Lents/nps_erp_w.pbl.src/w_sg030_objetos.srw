$PBExportHeader$w_sg030_objetos.srw
forward
global type w_sg030_objetos from w_abc_list_new
end type
type ddlb_1 from u_ddlb within w_sg030_objetos
end type
type st_1 from statictext within w_sg030_objetos
end type
type cb_libreria from commandbutton within w_sg030_objetos
end type
type sle_libreria from singlelineedit within w_sg030_objetos
end type
end forward

global type w_sg030_objetos from w_abc_list_new
integer width = 4101
integer height = 2096
string title = "Mantenimiento de Objetos  (SG030)"
string menuname = "m_save_exit"
long backcolor = 1073741824
ddlb_1 ddlb_1
st_1 st_1
cb_libreria cb_libreria
sle_libreria sle_libreria
end type
global w_sg030_objetos w_sg030_objetos

type variables
integer ii_index
end variables

on w_sg030_objetos.create
int iCurrent
call super::create
if this.MenuName = "m_save_exit" then this.MenuID = create m_save_exit
this.ddlb_1=create ddlb_1
this.st_1=create st_1
this.cb_libreria=create cb_libreria
this.sle_libreria=create sle_libreria
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.ddlb_1
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.cb_libreria
this.Control[iCurrent+4]=this.sle_libreria
end on

on w_sg030_objetos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.ddlb_1)
destroy(this.st_1)
destroy(this.cb_libreria)
destroy(this.sle_libreria)
end on

event ue_update_request;Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
IF dw_2.ii_update = 1 THEN
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	IF li_msg_result = 1 THEN this.TriggerEvent("ue_update")
END IF

end event

event ue_update;call super::ue_update;Boolean lbo_ok = TRUE

dw_2.AcceptText()

IF	dw_2.ii_update = 1 THEN
	IF dw_2.Update() = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		messagebox("Error en Grabacion Master","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_2.ii_update = 0
ELSE 
	ROLLBACK USING SQLCA;
END IF

end event

event ue_open_pre();call super::ue_open_pre;dw_1.SetTransObject(sqlca)  		// Relacionar el dw con la base de datos
dw_2.SetTransObject(sqlca)

//of_position_window(0,0)       			// Posicionar la ventana en forma fija
//ii_help = 101           					// help topic
//ii_pregunta_delete = 1   				// 1 = si pregunta, 0 = no pregunta (default)

dw_2.Retrieve()

//idw_1 = dw_2
end event

event open;call super::open;idc_factor = 0.4
end event

type p_pie from w_abc_list_new`p_pie within w_sg030_objetos
integer x = 0
integer y = 1640
end type

type ole_skin from w_abc_list_new`ole_skin within w_sg030_objetos
end type

type dw_1 from w_abc_list_new`dw_1 within w_sg030_objetos
integer x = 503
integer y = 296
integer width = 1609
integer height = 1208
string dataobject = "d_library_obj"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_1::ue_selected_row_pro;call super::ue_selected_row_pro;Long	ll_row, ll_rc
Any	la_id
Integer	li_x
String	ls_sistema

ll_row = idw_det.EVENT ue_insert()

if ll_row > 0 then
	FOR li_x = 1 to UpperBound(ii_dk)
		la_id = THIS.object.data.primary.current[al_row, ii_dk[li_x]]	
		ll_rc = idw_det.SetItem(ll_row, idw_det.ii_rk[li_x], la_id)
	NEXT
	idw_det.ScrollToRow(ll_row)
	return true
end if
return false





end event

event dw_1::ue_selected_row_pos;call super::ue_selected_row_pos;Long	ll_row, ll_y

ll_row = THIS.GetSelectedRow(0)

Do While ll_row <> 0
	THIS.DeleteRow(ll_row)
	ll_row = THIS.GetSelectedRow(0)
Loop

end event

event dw_1::constructor;call super::constructor;ii_ck[1] = 1  
ii_dk[1] = 1
ii_dk[2] = 3
ii_rk[1] = 1
ii_rk[2] = 3
end event

type dw_2 from w_abc_list_new`dw_2 within w_sg030_objetos
integer x = 2304
integer y = 296
integer width = 1527
integer height = 1208
integer taborder = 50
string dataobject = "d_objetos_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_2::ue_selected_row_pro;call super::ue_selected_row_pro;Long	ll_row, ll_rc
Any	la_id
Integer	li_x

ll_row = idw_det.EVENT ue_insert()

if ll_row > 0 then
	FOR li_x = 1 to UpperBound(ii_dk)
		la_id = THIS.object.data.primary.current[al_row, ii_dk[li_x]]	
		ll_rc = idw_det.SetItem(ll_row, idw_det.ii_rk[li_x], la_id)
	NEXT

	idw_det.ScrollToRow(ll_row)

	return true

end if

return false




end event

event dw_2::ue_selected_row_pos;call super::ue_selected_row_pos;Long	ll_row, ll_y

ll_row = THIS.GetSelectedRow(0)

Do While ll_row <> 0
	THIS.DeleteRow(ll_row)
	ll_row = THIS.GetSelectedRow(0)
Loop

end event

event dw_2::constructor;call super::constructor;ii_ck[1] = 1  
ii_dk[1] = 1
ii_dk[2] = 2
ii_rk[1] = 1
ii_rk[2] = 2
end event

event dw_2::rowfocuschanged;call super::rowfocuschanged;//f_select_current_row(this)
end event

event dw_2::ue_insert_pre;call super::ue_insert_pre;string 	ls_sistema, ls_mensaje

IF ddlb_1.text <> "" THEN
	ls_sistema = ddlb_1.ia_key[ii_index]
	this.object.sistema[al_row] = ls_sistema
else
	ls_mensaje = "No ha especificado ningún sistema"
	gnvo_log.of_errorlog( ls_mensaje )
	gnvo_app.of_showmessagedialog( ls_mensaje )
	return 
END IF


end event

event dw_2::ue_insert_validation;call super::ue_insert_validation;String ls_mensaje

IF ii_index = 0 then
	ls_mensaje = "No ha especificado ningún sistema"
	gnvo_log.of_errorlog( ls_mensaje )
	gnvo_app.of_showmessagedialog( ls_mensaje )
	return false
END IF

IF ddlb_1.ia_key[ii_index] = "" then
	ls_mensaje = "No ha especificado ningún sistema"
	gnvo_log.of_errorlog( ls_mensaje )
	gnvo_app.of_showmessagedialog( ls_mensaje )
	return false
END IF
end event

type pb_1 from w_abc_list_new`pb_1 within w_sg030_objetos
integer x = 2135
integer y = 632
integer taborder = 30
end type

type pb_2 from w_abc_list_new`pb_2 within w_sg030_objetos
integer x = 2130
integer y = 948
integer taborder = 40
end type

event pb_2::clicked;call super::clicked;dw_2.ii_update = 1
end event

type uo_h from w_abc_list_new`uo_h within w_sg030_objetos
end type

type st_box from w_abc_list_new`st_box within w_sg030_objetos
end type

type phl_logonps from w_abc_list_new`phl_logonps within w_sg030_objetos
end type

type p_mundi from w_abc_list_new`p_mundi within w_sg030_objetos
end type

type p_logo from w_abc_list_new`p_logo within w_sg030_objetos
integer x = 3534
end type

type st_filter from w_abc_list_new`st_filter within w_sg030_objetos
end type

type uo_filter from w_abc_list_new`uo_filter within w_sg030_objetos
end type

type ddlb_1 from u_ddlb within w_sg030_objetos
integer x = 2848
integer y = 156
integer width = 805
integer height = 404
integer taborder = 20
boolean bringtotop = true
end type

event ue_open_pre;call super::ue_open_pre;is_dataobject = 'd_sistema_aplicat_tbl'

ii_cn1 = 1                     // Nro del campo 1
ii_ck  = 1                     // Nro del campo key
ii_lc1 = 8                     // Longitud del campo 1


end event

event selectionchanged;call super::selectionchanged;if index > 0 then
   ii_index = index	
end if
end event

type st_1 from statictext within w_sg030_objetos
integer x = 2427
integer y = 164
integer width = 402
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "Sistema"
boolean focusrectangle = false
end type

type cb_libreria from commandbutton within w_sg030_objetos
integer x = 507
integer y = 160
integer width = 247
integer height = 108
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Libreria"
end type

event clicked;string ls_file, ls_path

GetFileOpenName ( "Select Library to Open", ls_path, ls_file, "PBL",&
"Library Files (*.pbl), *.pbl, Libray Files (*.pbd),*.pbd")  



sle_libreria.text = ls_path

sle_libreria.post event modified()

end event

type sle_libreria from singlelineedit within w_sg030_objetos
integer x = 814
integer y = 160
integer width = 1541
integer height = 92
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

event modified;int    li_x, li_total
string ls_objects

IF Trim(This.Text) = "" THEN RETURN

dw_1.reset()
	
ls_objects = LibraryDirectory ( This.Text, DirWindow! )

IF IsNull(This.Text) Or Trim(This.Text) = "" THEN RETURN
	
IF ls_objects <> "" THEN
	dw_1.importstring(ls_objects)
	of_sort_dw_1()
END IF


end event

