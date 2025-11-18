$PBExportHeader$w_sg5020_usr_obj.srw
forward
global type w_sg5020_usr_obj from w_abc_list
end type
type ddlb_1 from u_ddlb within w_sg5020_usr_obj
end type
type st_1 from statictext within w_sg5020_usr_obj
end type
type cbx_ins from checkbox within w_sg5020_usr_obj
end type
type cbx_eli from checkbox within w_sg5020_usr_obj
end type
type cbx_mod from checkbox within w_sg5020_usr_obj
end type
type cbx_con from checkbox within w_sg5020_usr_obj
end type
type cbx_anu from checkbox within w_sg5020_usr_obj
end type
type cbx_can from checkbox within w_sg5020_usr_obj
end type
type cbx_dup from checkbox within w_sg5020_usr_obj
end type
type cbx_cer from checkbox within w_sg5020_usr_obj
end type
type gb_1 from groupbox within w_sg5020_usr_obj
end type
end forward

global type w_sg5020_usr_obj from w_abc_list
integer width = 4434
integer height = 1496
string title = "Mantenimiento de Objetos Asignados x Usuario  (SG5020)"
string menuname = "m_abc_objetos"
long backcolor = 67108864
ddlb_1 ddlb_1
st_1 st_1
cbx_ins cbx_ins
cbx_eli cbx_eli
cbx_mod cbx_mod
cbx_con cbx_con
cbx_anu cbx_anu
cbx_can cbx_can
cbx_dup cbx_dup
cbx_cer cbx_cer
gb_1 gb_1
end type
global w_sg5020_usr_obj w_sg5020_usr_obj

type variables

end variables

on w_sg5020_usr_obj.create
int iCurrent
call super::create
if this.MenuName = "m_abc_objetos" then this.MenuID = create m_abc_objetos
this.ddlb_1=create ddlb_1
this.st_1=create st_1
this.cbx_ins=create cbx_ins
this.cbx_eli=create cbx_eli
this.cbx_mod=create cbx_mod
this.cbx_con=create cbx_con
this.cbx_anu=create cbx_anu
this.cbx_can=create cbx_can
this.cbx_dup=create cbx_dup
this.cbx_cer=create cbx_cer
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.ddlb_1
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.cbx_ins
this.Control[iCurrent+4]=this.cbx_eli
this.Control[iCurrent+5]=this.cbx_mod
this.Control[iCurrent+6]=this.cbx_con
this.Control[iCurrent+7]=this.cbx_anu
this.Control[iCurrent+8]=this.cbx_can
this.Control[iCurrent+9]=this.cbx_dup
this.Control[iCurrent+10]=this.cbx_cer
this.Control[iCurrent+11]=this.gb_1
end on

on w_sg5020_usr_obj.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.ddlb_1)
destroy(this.st_1)
destroy(this.cbx_ins)
destroy(this.cbx_eli)
destroy(this.cbx_mod)
destroy(this.cbx_con)
destroy(this.cbx_anu)
destroy(this.cbx_can)
destroy(this.cbx_dup)
destroy(this.cbx_cer)
destroy(this.gb_1)
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

//Open(w_log)
//lds_log.RowsCopy(1, lds_log.RowCount(),Primary!,w_log.dw_log,1,Primary!)


IF	dw_2.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_2.Update(true, false) = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion", ls_msg, StopSign!)
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

event ue_open_pre();call super::ue_open_pre;
dw_1.SetTransObject(sqlca)
dw_2.SetTransObject(sqlca)

idw_1 = dw_2             // asignar dw corriente
//dw_2.ii_cn = 1             // indicar el campo key del master

// ii_help = 101           // help topic


end event

event resize;call super::resize;dw_1.height  = newheight  - dw_1.y - 10

dw_2.height  = newheight  - dw_2.y - 10
dw_2.width 	 = newWidth  - dw_2.x - 10
end event

type dw_1 from w_abc_list`dw_1 within w_sg5020_usr_obj
integer y = 192
integer width = 1349
integer height = 1004
string dataobject = "d_obj_no_usr"
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
ii_dk[2] = 2

ii_rk[1] = 1

end event

type dw_2 from w_abc_list`dw_2 within w_sg5020_usr_obj
integer x = 1495
integer y = 196
integer width = 1984
integer height = 980
integer taborder = 40
string dataobject = "d_usr_obj"
end type

event dw_2::ue_selected_row_pro(long al_row);call super::ue_selected_row_pro;Long	ll_row, ll_rc
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

event dw_2::ue_insert_pre;call super::ue_insert_pre;this.object.cod_usr[al_row] = ddlb_1.ia_id

//is_flag_insertar, is_flag_eliminar, is_flag_modificar, is_flag_consultar, is_flag_anular, &
//is_flag_cancelar, is_flag_duplicar, is_flag_cerrar

if cbx_ins.checked then
	this.object.flag_insertar [al_row] = '1'
else
	this.object.flag_insertar [al_row] = '0'
end if

if cbx_eli.checked then
	this.object.flag_eliminar [al_row] = '1'
else
	this.object.flag_eliminar [al_row] = '0'
end if

if cbx_mod.checked then
	this.object.flag_modificar [al_row] = '1'
else
	this.object.flag_modificar [al_row] = '0'
end if

if cbx_con.checked then
	this.object.flag_consultar [al_row] = '1'
else
	this.object.flag_consultar [al_row] = '0'
end if

if cbx_anu.checked then
	this.object.flag_anular [al_row] = '1'
else
	this.object.flag_anular [al_row] = '0'
end if

if cbx_can.checked then
	this.object.flag_cancelar [al_row] = '1'
else
	this.object.flag_cancelar [al_row] = '0'
end if

if cbx_dup.checked then
	this.object.flag_duplicar [al_row] = '1'
else
	this.object.flag_duplicar [al_row] = '0'
end if

if cbx_cer.checked then
	this.object.flag_cerrar [al_row] = '1'
else
	this.object.flag_cerrar [al_row] = '0'
end if
end event

event dw_2::constructor;call super::constructor;ii_ck[1] = 1 
ii_ck[2] = 2

ii_dk[1] = 2
ii_rk[1] = 2
ii_rk[2] = 7

end event

event dw_2::rowfocuschanged;call super::rowfocuschanged;f_select_current_row(this)
end event

event dw_2::doubleclicked;call super::doubleclicked;CHAR ls_flag
Integer j

CHOOSE CASE dwo.name
	CASE 'flag_insertar_t'
		ls_flag = dw_2.object.flag_insertar[1]
		if ls_flag = '1' then
			ls_flag = '0'
		else
			ls_flag = '1'
		end if
		For j = 1 to dw_2.Rowcount()
			dw_2.object.flag_insertar[j] = ls_flag
			dw_2.ii_update = 1
		Next
	CASE 'flag_eliminar_t'
		ls_flag = dw_2.object.flag_eliminar[1]
		if ls_flag = '1' then
			ls_flag = '0'
		else
			ls_flag = '1'
		end if
		For j = 1 to dw_2.Rowcount()
			dw_2.object.flag_eliminar[j] = ls_flag
			dw_2.ii_update = 1
		Next
	CASE 'flag_modificar_t'
		ls_flag = dw_2.object.flag_modificar[1]
		if ls_flag = '1' then
			ls_flag = '0'
		else
			ls_flag = '1'
		end if
		For j = 1 to dw_2.Rowcount()
			dw_2.object.flag_modificar[j] = ls_flag
			dw_2.ii_update = 1
		Next
	CASE 'flag_consultar_t'
		ls_flag = dw_2.object.flag_consultar[1]
		if ls_flag = '1' then
			ls_flag = '0'
		else
			ls_flag = '1'
		end if
		For j = 1 to dw_2.Rowcount()
			dw_2.object.flag_consultar[j] = ls_flag
			dw_2.ii_update = 1
		Next
END CHOOSE
end event

type pb_1 from w_abc_list`pb_1 within w_sg5020_usr_obj
integer x = 1390
integer y = 860
integer width = 91
string text = ">"
vtextalign vtextalign = vcenter!
end type

type pb_2 from w_abc_list`pb_2 within w_sg5020_usr_obj
integer x = 1390
integer y = 996
integer width = 91
integer taborder = 30
end type

event pb_2::clicked;call super::clicked;
dw_2.ii_update = 1
end event

type ddlb_1 from u_ddlb within w_sg5020_usr_obj
integer x = 370
integer y = 32
integer width = 1399
integer height = 780
boolean bringtotop = true
boolean allowedit = true
end type

event ue_open_pre();call super::ue_open_pre;is_dataobject = 'd_usuario_tbl'

ii_cn1 = 1                     // Nro del campo 1
ii_cn2 = 2                     // Nro del campo 2
ii_ck  = 1                     // Nro del campo key
ii_lc1 = 12                     // Longitud del campo 1
ii_lc2 = 30							// Longitud del campo 2

end event

event ue_output(any aa_key);call super::ue_output;dw_1.Retrieve(aa_key)
dw_2.Retrieve(aa_key)


end event

event modified;call super::modified;//String ls_usr
//
//ls_usr = this.text
//
//dw_1.Retrieve(ls_usr)
//dw_2.Retrieve(ls_usr)
end event

type st_1 from statictext within w_sg5020_usr_obj
integer x = 37
integer y = 40
integer width = 297
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 79741120
boolean enabled = false
string text = "USUARIO:"
boolean focusrectangle = false
end type

type cbx_ins from checkbox within w_sg5020_usr_obj
integer x = 1806
integer y = 52
integer width = 306
integer height = 112
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Insertar"
boolean checked = true
borderstyle borderstyle = styleraised!
end type

type cbx_eli from checkbox within w_sg5020_usr_obj
integer x = 2121
integer y = 52
integer width = 306
integer height = 112
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Eliminar"
boolean checked = true
borderstyle borderstyle = styleraised!
end type

type cbx_mod from checkbox within w_sg5020_usr_obj
integer x = 2437
integer y = 52
integer width = 306
integer height = 112
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Modificar"
boolean checked = true
borderstyle borderstyle = styleraised!
end type

type cbx_con from checkbox within w_sg5020_usr_obj
integer x = 2752
integer y = 52
integer width = 306
integer height = 112
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Consultar"
boolean checked = true
borderstyle borderstyle = styleraised!
end type

type cbx_anu from checkbox within w_sg5020_usr_obj
integer x = 3067
integer y = 52
integer width = 306
integer height = 112
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Anular"
boolean checked = true
borderstyle borderstyle = styleraised!
end type

type cbx_can from checkbox within w_sg5020_usr_obj
integer x = 3383
integer y = 52
integer width = 306
integer height = 112
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Cancelar"
boolean checked = true
borderstyle borderstyle = styleraised!
end type

type cbx_dup from checkbox within w_sg5020_usr_obj
integer x = 3698
integer y = 52
integer width = 306
integer height = 112
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Duplicar"
boolean checked = true
borderstyle borderstyle = styleraised!
end type

type cbx_cer from checkbox within w_sg5020_usr_obj
integer x = 4014
integer y = 52
integer width = 306
integer height = 112
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Cerrar"
boolean checked = true
borderstyle borderstyle = styleraised!
end type

type gb_1 from groupbox within w_sg5020_usr_obj
integer x = 1783
integer width = 2569
integer height = 176
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

