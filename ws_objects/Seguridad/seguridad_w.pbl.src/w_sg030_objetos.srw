$PBExportHeader$w_sg030_objetos.srw
forward
global type w_sg030_objetos from w_abc_list
end type
type sle_libreria from singlelineedit within w_sg030_objetos
end type
type cb_libreria from commandbutton within w_sg030_objetos
end type
type ddlb_1 from u_ddlb within w_sg030_objetos
end type
end forward

global type w_sg030_objetos from w_abc_list
integer width = 4101
integer height = 1732
string title = "Mantenimiento de Objetos  (SG030)"
string menuname = "m_abc_master_smpl"
long backcolor = 67108864
sle_libreria sle_libreria
cb_libreria cb_libreria
ddlb_1 ddlb_1
end type
global w_sg030_objetos w_sg030_objetos

type variables

end variables

on w_sg030_objetos.create
int iCurrent
call super::create
if this.MenuName = "m_abc_master_smpl" then this.MenuID = create m_abc_master_smpl
this.sle_libreria=create sle_libreria
this.cb_libreria=create cb_libreria
this.ddlb_1=create ddlb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_libreria
this.Control[iCurrent+2]=this.cb_libreria
this.Control[iCurrent+3]=this.ddlb_1
end on

on w_sg030_objetos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_libreria)
destroy(this.cb_libreria)
destroy(this.ddlb_1)
end on

event ue_update_request;call super::ue_update_request;Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
IF dw_2.ii_update = 1 THEN
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	IF li_msg_result = 1 THEN this.TriggerEvent("ue_update")
END IF

end event

event ue_update;call super::ue_update;Boolean lbo_ok = TRUE
String	ls_msg, ls_crlf

ls_crlf = char(13) + char(10)
dw_2.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF ib_log THEN
	dw_2.of_create_log()
END IF

IF	dw_2.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_2.Update(true, false) = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion Master", ls_msg, StopSign!)
	END IF
END IF

IF ib_log THEN
	IF lbo_ok THEN
		lbo_ok = dw_2.of_save_log()
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_2.ii_update = 0
	dw_2.il_totdel = 0
	
	dw_2.ResetUpdate()
	
	f_mensaje('Grabación realizada satisfactoriamente', '')
END IF

end event

event ue_open_pre();call super::ue_open_pre;dw_1.SetTransObject(sqlca)  		// Relacionar el dw con la base de datos
dw_2.SetTransObject(sqlca)

//of_position_window(0,0)       			// Posicionar la ventana en forma fija
//ii_help = 101           					// help topic
//ii_pregunta_delete = 1   				// 1 = si pregunta, 0 = no pregunta (default)

dw_2.Retrieve()

idw_1 = dw_2
end event

event resize;call super::resize;dw_1.height  	= newheight  - dw_1.y - 10
dw_2.height  	= newheight  - dw_2.y - 10
dw_2.width  	= newwidth  - dw_2.x - 10
end event

type dw_1 from w_abc_list`dw_1 within w_sg030_objetos
integer y = 192
integer width = 1202
integer height = 1312
string dataobject = "d_library_obj"
end type

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

event dw_1::constructor;call super::constructor;ii_ck[1] = 1  
ii_dk[1] = 1
ii_dk[2] = 3
ii_rk[1] = 1
ii_rk[2] = 3
end event

type dw_2 from w_abc_list`dw_2 within w_sg030_objetos
integer x = 1431
integer y = 192
integer width = 2194
integer height = 1312
integer taborder = 50
string dataobject = "d_objetos_tbl"
end type

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

event dw_2::constructor;call super::constructor;ii_ck[1] = 1  
ii_dk[1] = 1
ii_dk[2] = 2
ii_rk[1] = 1
ii_rk[2] = 2
end event

event dw_2::rowfocuschanged;call super::rowfocuschanged;//f_select_current_row(this)
end event

event dw_2::ue_insert_pre;call super::ue_insert_pre;string ls_sistema
Integer	li_index

IF ddlb_1.text <> "" THEN
	ls_sistema = ddlb_1.ia_key[gi_index]
	this.object.sistema[al_row] = ls_sistema
END IF

end event

type pb_1 from w_abc_list`pb_1 within w_sg030_objetos
integer x = 1262
integer y = 576
integer taborder = 30
vtextalign vtextalign = vcenter!
end type

type pb_2 from w_abc_list`pb_2 within w_sg030_objetos
integer x = 1262
integer taborder = 40
end type

event pb_2::clicked;call super::clicked;dw_2.ii_update = 1
end event

type sle_libreria from singlelineedit within w_sg030_objetos
integer x = 338
integer y = 32
integer width = 2007
integer height = 92
integer taborder = 20
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

MessageBox(this.text, ls_objects)

IF IsNull(This.Text) Or Trim(This.Text) = "" THEN RETURN
	
IF ls_objects <> "" THEN
	dw_1.importstring(ls_objects)
	of_sort_dw_1()
END IF


end event

type cb_libreria from commandbutton within w_sg030_objetos
integer x = 37
integer y = 24
integer width = 247
integer height = 108
integer taborder = 10
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

type ddlb_1 from u_ddlb within w_sg030_objetos
integer x = 2482
integer y = 36
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
   gi_index = index	
end if
end event

