$PBExportHeader$w_seleccion_cencos_niv2.srw
forward
global type w_seleccion_cencos_niv2 from w_abc_list
end type
type cb_1 from commandbutton within w_seleccion_cencos_niv2
end type
end forward

global type w_seleccion_cencos_niv2 from w_abc_list
integer width = 3058
integer height = 1444
string title = "Seleccione Centro Costo Nivel 1"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
cb_1 cb_1
end type
global w_seleccion_cencos_niv2 w_seleccion_cencos_niv2

on w_seleccion_cencos_niv2.create
int iCurrent
call super::create
this.cb_1=create cb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
end on

on w_seleccion_cencos_niv2.destroy
call super::destroy
destroy(this.cb_1)
end on

event open;call super::open;dw_1.SetTransObject(sqlca)
dw_1.Retrieve()
dw_2.SetTransObject(sqlca)
end event

event ue_set_access;//oVERRIDE
end event

type dw_1 from w_abc_list`dw_1 within w_seleccion_cencos_niv2
integer x = 32
integer y = 32
integer width = 1385
integer height = 1188
string dataobject = "d_lis_cencos_niv2"
boolean vscrollbar = true
end type

event dw_1::constructor;call super::constructor;ii_ck[1] = 1
ii_ck[2] = 2				// columna, que juega como key
ii_ck[3] = 3
ii_dk[1] = 1				// Deploy key
ii_dk[2] = 2
ii_dk[3] = 3
ii_rk[1] = 1				// Receive key
ii_rk[2] = 2
ii_rk[3] = 3

end event

event dw_1::ue_selected_row_pos;call super::ue_selected_row_pos;Long	ll_row, ll_y

ll_row = THIS.GetSelectedRow(0)

Do While ll_row <> 0
	THIS.DeleteRow(ll_row)
	ll_row = THIS.GetSelectedRow(0)
Loop

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

type dw_2 from w_abc_list`dw_2 within w_seleccion_cencos_niv2
integer x = 1623
integer y = 32
integer width = 1385
integer height = 1188
string dataobject = "d_lis_cencos_niv2"
boolean vscrollbar = true
end type

event dw_2::constructor;call super::constructor;ii_ck[1] = 1
ii_ck[2] = 2				// columna, que juega como key
ii_ck[3] = 3
ii_dk[1] = 1				// Deploy key
ii_dk[2] = 2
ii_dk[3] = 3
ii_rk[1] = 1				// Receive key
ii_rk[2] = 2
ii_rk[3] = 3
end event

event dw_2::ue_selected_row_pos;call super::ue_selected_row_pos;Long	ll_row, ll_y

ll_row = THIS.GetSelectedRow(0)

Do While ll_row <> 0
	THIS.DeleteRow(ll_row)
	ll_row = THIS.GetSelectedRow(0)
Loop

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

type pb_1 from w_abc_list`pb_1 within w_seleccion_cencos_niv2
integer x = 1449
integer y = 396
end type

type pb_2 from w_abc_list`pb_2 within w_seleccion_cencos_niv2
integer x = 1449
integer y = 532
end type

type cb_1 from commandbutton within w_seleccion_cencos_niv2
integer x = 2647
integer y = 1240
integer width = 357
integer height = 108
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Aceptar"
boolean default = true
end type

event clicked;long ll_nbrow
integer i
string ls_cod_n1, ls_cod_n2, ls_desc

delete from tt_cencos_niv2;
delete from tt_cencos_niv3;
ll_nbrow = dw_2.rowcount()
if ll_nbrow > 0 then
	for i=1 to ll_nbrow
		ls_cod_n1 = dw_2.object.cod_n1[i]
		ls_cod_n2 = dw_2.object.cod_n2[i]
		insert into tt_cencos_niv2(cod_n1, cod_n2) values (:ls_cod_n1, :ls_cod_n2);
	next
end if
close(parent)
end event

