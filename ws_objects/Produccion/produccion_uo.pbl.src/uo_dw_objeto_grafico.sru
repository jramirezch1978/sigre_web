$PBExportHeader$uo_dw_objeto_grafico.sru
forward
global type uo_dw_objeto_grafico from datawindow
end type
end forward

global type uo_dw_objeto_grafico from datawindow
integer width = 549
integer height = 300
boolean titlebar = true
string dataobject = "d_ap_objeto_imagen_ff"
boolean resizable = true
string icon = "UserObject5!"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
event ue_move pbm_move
event uo_close pbm_close
end type
global uo_dw_objeto_grafico uo_dw_objeto_grafico

type variables
integer ii_insert, ii_update, ii_clear

end variables

event ue_move;integer li_move, li_xpos, li_ypos, li_width, li_height, li_w_width, li_w_height
long ll_det, ll_tot, ll_cntnr
string ls_item

li_w_width = w_pr311_lecturas_grafico.ii_w_width
li_w_height = w_pr311_lecturas_grafico.ii_w_height

li_width = this.width
li_height = this.height
li_xpos = xpos
li_ypos = ypos

li_move = 0

if li_xpos < 562 then
	li_xpos = 562
	li_ypos = li_ypos - 95
	li_move = 1
end if

if li_ypos < 410 then
	li_ypos = 410
	li_move = 1
end if

if li_width + li_xpos > li_w_width then
	li_xpos = li_w_width - li_width - 50
	li_ypos = li_ypos - 95
	li_move = 1
end if

if li_height + li_ypos > li_w_height then
	li_ypos = li_w_height - li_height - 100
	li_xpos = li_xpos - 20
	li_move = 1
end if

if li_move = 1 and w_pr311_lecturas_grafico.ii_clear = 0 then
	this.move( li_xpos, li_ypos)
end if

if w_pr311_lecturas_grafico.ii_clear = 1 then return

ll_cntnr = this.getrow( )

if ll_cntnr = 1 then
	ls_item = string(this.object.item[ll_cntnr])

	ll_tot = w_pr311_lecturas_grafico.dw_detail.rowcount()
	ll_det = w_pr311_lecturas_grafico.dw_detail.find("item = " + ls_item, 1, ll_tot)

	if ll_det < 1 then
		messagebox('(PR311) Lecturas de Partes de Piso - Modo Grafico','El objeto se ha movido, pero no se ha podido actualizar la posición', stopsign!)
	else
		w_pr311_lecturas_grafico.dw_detail.object.pos_x[ll_det] = li_xpos
		w_pr311_lecturas_grafico.dw_detail.object.pos_y[ll_det] = li_ypos
		w_pr311_lecturas_grafico.dw_detail.ii_update = 1
	end if
end if

end event

on uo_dw_objeto_grafico.create
end on

on uo_dw_objeto_grafico.destroy
end on

event constructor;this.settransobject( sqlca )
ii_clear = 0

end event

event dragdrop;integer li_existe, li_item, li_msg, li_width, li_heigth, li_xpos, li_ypos, li_dw_row
string ls_pantalla, ls_objeto, ls_msg, ls_descripcion

if this.x = 0 then return

li_dw_row = this.getrow( )

if li_dw_row = 1 then
	ls_pantalla = this.object.pantalla[li_dw_row]
	li_item = this.object.item[li_dw_row]
else
	ls_pantalla = w_pr311_lecturas_grafico.is_pantalla_drag
	li_item = w_pr311_lecturas_grafico.ii_item_drag
end if

ls_descripcion = w_pr311_lecturas_grafico.is_descripcion_drag
ls_objeto = w_pr311_lecturas_grafico.is_objeto_drag

li_existe = this.getrow( )
li_width = this.width
li_heigth = this.height
li_xpos = this.x
li_ypos = this.y

declare pb_pntlla_new_obj procedure for
	usp_pr_pntlla_new_obj(:ls_pantalla, :ls_objeto, :li_item, :li_existe, :li_width, :li_heigth, :li_xpos, :li_ypos);

execute pb_pntlla_new_obj;
if sqlca.sqlcode = -1 then
	messagebox('(PR311) Lecturas de Partes de Piso - Modo Grafico', 'No se puede ejecutar procedimiento usp_pr_pntlla_new_obj', StopSign!)
	close (parent)
end if
fetch pb_pntlla_new_obj into :li_item, :li_msg, :ls_msg;
close pb_pntlla_new_obj;

if li_msg = 1 then
	messagebox('(PR311) Lecturas de Partes de Piso - Modo Grafico', ls_msg)
end if

if this.retrieve(ls_pantalla, li_item) = 1 then
	this.title = ls_descripcion
	this.object.p_objeto.filename = this.object.imagen_base[1]
	w_pr311_lecturas_grafico.dw_detail.retrieve(ls_pantalla)
end if

w_pr311_lecturas_grafico.of_dw_number_updt()
end event

event resize;long ll_cntnr, ll_tot, ll_det
integer li_width, li_height
string ls_item

li_width = round((this.width) - 60, 0)
li_height = round((this.height) - 120, 0)

if this.x = 0 then 
	this.width = 549
	this.height = 300
	return
end if

this.object.p_objeto.width = li_width
this.object.p_objeto.height = li_height


if w_pr311_lecturas_grafico.ii_clear = 1 then return

ll_cntnr = this.getrow( )

if ll_cntnr = 1 then
	ls_item = string(this.object.item[ll_cntnr])

	ll_tot = w_pr311_lecturas_grafico.dw_detail.rowcount()
	ll_det = w_pr311_lecturas_grafico.dw_detail.find("item = " + ls_item, 1, ll_tot)

	if ll_det < 1 then
		messagebox('(PR311) Lecturas de Partes de Piso - Modo Grafico','El objeto se ha cambiado de tamaño, pero no se ha podido actualizar su tamaño', stopsign!)
	else
		w_pr311_lecturas_grafico.dw_detail.object.width[ll_det] = li_width
		w_pr311_lecturas_grafico.dw_detail.object.height[ll_det] = li_height
		w_pr311_lecturas_grafico.dw_detail.ii_update = 1
	end if
end if
end event

event rbuttondown;integer li_row

if this.x = 0 then return

li_row = this.getrow()

setnull(w_pr311_lecturas_grafico.ii_item_ini_rel)
setnull(w_pr311_lecturas_grafico.is_pant_ini_rel)

if li_row = 1 then
	w_pr311_lecturas_grafico.ii_item_ini_rel = this.object.item[li_row]
	w_pr311_lecturas_grafico.is_pant_ini_rel = this.object.pantalla[li_row]
end if

Parent.EVENT Post Dynamic ue_PopM(w_main.PointerX(), w_main.PointerY())
end event

event getfocus;long ll_det, ll_tot, ll_cntnr
string ls_item

if this.x = 0 then return

w_pr311_lecturas_grafico.idw_objeto = this
w_pr311_lecturas_grafico.ii_num_dw = integer(right(trim(this.classname( )),2))

ll_cntnr = this.getrow()

if ll_cntnr < 1 then return

ls_item = string(this.object.item[ll_cntnr])

ll_tot = w_pr311_lecturas_grafico.dw_detail.rowcount( )

if ll_tot < 1 then return

ll_det = w_pr311_lecturas_grafico.dw_detail.find("item = " + ls_item, 1, ll_tot)

if ll_det < 1 then return

w_pr311_lecturas_grafico.dw_detail.object.datawindows[ll_det] = w_pr311_lecturas_grafico.ii_num_dw

end event

event clicked;if this.x = 0 then return
if w_pr311_lecturas_grafico.ii_relaciona = 0 then  return

integer li_row

li_row = this.getrow()

setnull(w_pr311_lecturas_grafico.ii_item_fin_rel)
setnull(w_pr311_lecturas_grafico.is_pant_fin_rel)

if li_row = 1 then
	w_pr311_lecturas_grafico.ii_item_fin_rel = this.object.item[li_row]
	w_pr311_lecturas_grafico.is_pant_fin_rel = this.object.pantalla[li_row]
end if

w_pr311_lecturas_grafico.of_set_relation()

end event

