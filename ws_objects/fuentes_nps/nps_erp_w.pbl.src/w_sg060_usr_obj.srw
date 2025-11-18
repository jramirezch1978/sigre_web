$PBExportHeader$w_sg060_usr_obj.srw
forward
global type w_sg060_usr_obj from w_abc_list_new
end type
type gb_1 from groupbox within w_sg060_usr_obj
end type
type ddlb_1 from u_ddlb within w_sg060_usr_obj
end type
type st_1 from statictext within w_sg060_usr_obj
end type
type cbx_can from checkbox within w_sg060_usr_obj
end type
type cbx_anu from checkbox within w_sg060_usr_obj
end type
type cbx_con from checkbox within w_sg060_usr_obj
end type
type cbx_mod from checkbox within w_sg060_usr_obj
end type
type cbx_eli from checkbox within w_sg060_usr_obj
end type
type cbx_ins from checkbox within w_sg060_usr_obj
end type
end forward

global type w_sg060_usr_obj from w_abc_list_new
integer width = 4279
integer height = 2584
string title = "[SG060] Objetos x Usuario"
string menuname = "m_save_exit"
long backcolor = 1073741824
gb_1 gb_1
ddlb_1 ddlb_1
st_1 st_1
cbx_can cbx_can
cbx_anu cbx_anu
cbx_con cbx_con
cbx_mod cbx_mod
cbx_eli cbx_eli
cbx_ins cbx_ins
end type
global w_sg060_usr_obj w_sg060_usr_obj

type variables

end variables

on w_sg060_usr_obj.create
int iCurrent
call super::create
if this.MenuName = "m_save_exit" then this.MenuID = create m_save_exit
this.gb_1=create gb_1
this.ddlb_1=create ddlb_1
this.st_1=create st_1
this.cbx_can=create cbx_can
this.cbx_anu=create cbx_anu
this.cbx_con=create cbx_con
this.cbx_mod=create cbx_mod
this.cbx_eli=create cbx_eli
this.cbx_ins=create cbx_ins
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_1
this.Control[iCurrent+2]=this.ddlb_1
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.cbx_can
this.Control[iCurrent+5]=this.cbx_anu
this.Control[iCurrent+6]=this.cbx_con
this.Control[iCurrent+7]=this.cbx_mod
this.Control[iCurrent+8]=this.cbx_eli
this.Control[iCurrent+9]=this.cbx_ins
end on

on w_sg060_usr_obj.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_1)
destroy(this.ddlb_1)
destroy(this.st_1)
destroy(this.cbx_can)
destroy(this.cbx_anu)
destroy(this.cbx_con)
destroy(this.cbx_mod)
destroy(this.cbx_eli)
destroy(this.cbx_ins)
end on

event ue_update_request;call super::ue_update_request;Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
IF dw_2.ii_update = 1 THEN
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	IF li_msg_result = 1 THEN this.TriggerEvent("ue_update")
END IF

end event

event ue_update();call super::ue_update;Boolean lbo_ok = TRUE

dw_2.AcceptText()

IF	dw_2.ii_update = 1 THEN	
	IF dw_2.Update() = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		messagebox("Error en Grabacion dw_2","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_2.ii_update = 0
ELSE 
	ROLLBACK USING SQLCA;
END IF
end event

event ue_open_pre();call super::ue_open_pre;
dw_1.SetTransObject(sqlca)
dw_2.SetTransObject(sqlca)

//idw_1 = dw_2             // asignar dw corriente
//dw_2.ii_cn = 1             // indicar el campo key del master

// ii_help = 101           // help topic


end event

type p_pie from w_abc_list_new`p_pie within w_sg060_usr_obj
end type

type ole_skin from w_abc_list_new`ole_skin within w_sg060_usr_obj
integer x = 4069
integer y = 252
end type

type dw_1 from w_abc_list_new`dw_1 within w_sg060_usr_obj
integer x = 489
integer y = 308
integer width = 2016
integer height = 1004
string dataobject = "d_obj_no_usr"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_1::ue_selected_row_pro;call super::ue_selected_row_pro;Long	ll_row, ll_rc
Any	la_id
Integer	li_x

ll_row = idw_det.EVENT ue_insert()

if ll_row < 0 then return false

FOR li_x = 1 to UpperBound(ii_dk)
	la_id = THIS.object.data.primary.current[al_row, ii_dk[li_x]]	
	ll_rc = idw_det.SetItem(ll_row, idw_det.ii_rk[li_x], la_id)	
	  	if cbx_ins.checked = true then 
         idw_det.setitem( ll_row, 'flag_insertar', '1')
   	end if 
   	if cbx_eli.checked = true then 
         idw_det.setitem( ll_row, 'flag_eliminar', '1')
   	end if 
	   if cbx_mod.checked = true then 
         idw_det.setitem( ll_row, 'flag_modificar', '1')
   	end if 
	   if cbx_con.checked = true then 
         idw_det.setitem( ll_row, 'flag_consultar', '1')
   	end if 
	   if cbx_anu.checked = true then 
         idw_det.setitem( ll_row, 'flag_anular', '1')
   	end if 
	   if cbx_can.checked = true then 
         idw_det.setitem( ll_row, 'flag_cancelar', '1')
   	end if 

NEXT

idw_det.ScrollToRow(ll_row)
return true

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

type dw_2 from w_abc_list_new`dw_2 within w_sg060_usr_obj
integer x = 2094
integer y = 312
integer width = 1079
integer height = 980
integer taborder = 40
string dataobject = "d_usr_obj"
boolean hscrollbar = true
boolean vscrollbar = true
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

event dw_2::ue_insert_pre(long al_row);call super::ue_insert_pre;Long ll_row
Any la_id

ll_row = al_row
la_id = ddlb_1.ia_id

THIS.SetItem(al_row, 1, ddlb_1.ia_id)

end event

event dw_2::constructor;call super::constructor;ii_ck[1] = 2 
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

type pb_1 from w_abc_list_new`pb_1 within w_sg060_usr_obj
integer x = 1934
integer y = 728
integer width = 128
string text = ">"
end type

type pb_2 from w_abc_list_new`pb_2 within w_sg060_usr_obj
integer x = 1934
integer y = 864
integer width = 128
integer taborder = 30
end type

event pb_2::clicked;call super::clicked;
dw_2.ii_update = 1
end event

type uo_h from w_abc_list_new`uo_h within w_sg060_usr_obj
end type

type st_box from w_abc_list_new`st_box within w_sg060_usr_obj
end type

type phl_logonps from w_abc_list_new`phl_logonps within w_sg060_usr_obj
end type

type p_mundi from w_abc_list_new`p_mundi within w_sg060_usr_obj
end type

type p_logo from w_abc_list_new`p_logo within w_sg060_usr_obj
integer x = 3767
integer y = 28
end type

type st_filter from w_abc_list_new`st_filter within w_sg060_usr_obj
end type

type uo_filter from w_abc_list_new`uo_filter within w_sg060_usr_obj
end type

type gb_1 from groupbox within w_sg060_usr_obj
integer x = 2295
integer y = 120
integer width = 1248
integer height = 176
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = styleraised!
end type

type ddlb_1 from u_ddlb within w_sg060_usr_obj
integer x = 882
integer y = 148
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

type st_1 from statictext within w_sg060_usr_obj
integer x = 549
integer y = 156
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
boolean enabled = false
string text = "USUARIO:"
boolean focusrectangle = false
end type

type cbx_can from checkbox within w_sg060_usr_obj
integer x = 3310
integer y = 152
integer width = 201
integer height = 112
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "Can"
borderstyle borderstyle = styleraised!
end type

type cbx_anu from checkbox within w_sg060_usr_obj
integer x = 3090
integer y = 152
integer width = 201
integer height = 112
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "Anu"
borderstyle borderstyle = styleraised!
end type

type cbx_con from checkbox within w_sg060_usr_obj
integer x = 2871
integer y = 152
integer width = 201
integer height = 112
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "Cons"
borderstyle borderstyle = styleraised!
end type

type cbx_mod from checkbox within w_sg060_usr_obj
integer x = 2683
integer y = 152
integer width = 169
integer height = 112
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "Mod"
borderstyle borderstyle = styleraised!
end type

type cbx_eli from checkbox within w_sg060_usr_obj
integer x = 2528
integer y = 152
integer width = 137
integer height = 112
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "Eli"
borderstyle borderstyle = styleraised!
end type

type cbx_ins from checkbox within w_sg060_usr_obj
integer x = 2336
integer y = 152
integer width = 174
integer height = 112
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "Ins"
borderstyle borderstyle = styleraised!
end type

