$PBExportHeader$w_seleccion_canal.srw
forward
global type w_seleccion_canal from w_abc_list
end type
type cb_1 from commandbutton within w_seleccion_canal
end type
type st_1 from statictext within w_seleccion_canal
end type
end forward

global type w_seleccion_canal from w_abc_list
integer width = 3118
integer height = 1480
string title = "Seleccione de Canal de Distribucion"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
cb_1 cb_1
st_1 st_1
end type
global w_seleccion_canal w_seleccion_canal

on w_seleccion_canal.create
int iCurrent
call super::create
this.cb_1=create cb_1
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.st_1
end on

on w_seleccion_canal.destroy
call super::destroy
destroy(this.cb_1)
destroy(this.st_1)
end on

event open;call super::open;dw_1.SetTransObject(sqlca)
dw_1.Retrieve()

end event

event ue_set_access;//oVERRIDE
end event

type dw_1 from w_abc_list`dw_1 within w_seleccion_canal
integer x = 37
integer y = 32
integer width = 1394
integer height = 1188
string dataobject = "d_lista_canal_distribucion"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_1::constructor;call super::constructor;// columna, que juega como key
ii_ck[1] = 1
ii_ck[2] = 2				
// Deploy key
ii_dk[1] = 1				
ii_dk[2] = 2
// Receive key
ii_rk[1] = 1				
ii_rk[2] = 2

end event

event dw_1::ue_selected_row_pos;call super::ue_selected_row_pos;Long	ll_row, ll_y

ll_row = THIS.GetSelectedRow(0)

Do While ll_row <> 0
	THIS.DeleteRow(ll_row)
   st_1.text = "Eliminando fila :"+string(ll_row)
	ll_row = THIS.GetSelectedRow(0)
Loop
st_1.text = ""

end event

event dw_1::ue_selected_row_pro;call super::ue_selected_row_pro;Long	ll_row, ll_rc
Any	la_id
Integer	li_x

ll_row = idw_det.EVENT ue_insert()

FOR li_x = 1 to UpperBound(ii_dk)
	la_id = THIS.object.data.primary.current[al_row, ii_dk[li_x]]	
	st_1.text = "Agregando :"+string(la_id)
	ll_rc = idw_det.SetItem(ll_row, idw_det.ii_rk[li_x], la_id)
NEXT
st_1.text = "Evento Agregar Finalizado"
idw_det.ScrollToRow(ll_row)
end event

type dw_2 from w_abc_list`dw_2 within w_seleccion_canal
integer x = 1646
integer y = 32
integer width = 1394
integer height = 1188
string dataobject = "d_lista_canal_distribucion"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_2::constructor;call super::constructor;// columna, que juega como key
ii_ck[1] = 1
ii_ck[2] = 2				
// Deploy key
ii_dk[1] = 1				
ii_dk[2] = 2
// Receive key
ii_rk[1] = 1				
ii_rk[2] = 2

end event

event dw_2::ue_selected_row_pos;call super::ue_selected_row_pos;Long	ll_row, ll_y

ll_row = THIS.GetSelectedRow(0)

Do While ll_row <> 0
	THIS.DeleteRow(ll_row)
	st_1.text = "Eliminando Fila :"+string(ll_row)
	ll_row = THIS.GetSelectedRow(0)
Loop
st_1.text = ""

end event

event dw_2::ue_selected_row_pro;call super::ue_selected_row_pro;Long	ll_row, ll_rc
Any	la_id
Integer	li_x

ll_row = idw_det.EVENT ue_insert()

FOR li_x = 1 to UpperBound(ii_dk)
	la_id = THIS.object.data.primary.current[al_row, ii_dk[li_x]]
	st_1.text = "Agregando :"+string(la_id)
	ll_rc = idw_det.SetItem(ll_row, idw_det.ii_rk[li_x], la_id)
NEXT
st_1.text = "Evento Agregar Finalizado"
idw_det.ScrollToRow(ll_row)
end event

type pb_1 from w_abc_list`pb_1 within w_seleccion_canal
integer x = 1463
integer y = 396
integer width = 151
end type

type pb_2 from w_abc_list`pb_2 within w_seleccion_canal
integer x = 1463
integer y = 532
integer width = 151
string text = " <"
end type

type cb_1 from commandbutton within w_seleccion_canal
integer x = 2683
integer y = 1248
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
string ls_cod,ls_desc

delete from tt_canal_distribucion;

ll_nbrow = dw_2.rowcount()

if ll_nbrow > 0 then

	for i=1 to ll_nbrow
		
		ls_cod  = trim(dw_2.object.canal[i])
		ls_desc = trim(dw_2.object.descripcion[i])
		
		insert into tt_canal_distribucion (canal, descripcion) values (:ls_cod, :ls_desc);
		st_1.text = "Actualizando : "+ls_cod

	next

end if

close(parent)
end event

type st_1 from statictext within w_seleccion_canal
integer x = 37
integer y = 1252
integer width = 2510
integer height = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean focusrectangle = false
end type

