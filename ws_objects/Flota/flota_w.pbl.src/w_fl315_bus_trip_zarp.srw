$PBExportHeader$w_fl315_bus_trip_zarp.srw
forward
global type w_fl315_bus_trip_zarp from w_abc
end type
type cb_copiar from commandbutton within w_fl315_bus_trip_zarp
end type
type st_2 from statictext within w_fl315_bus_trip_zarp
end type
type st_1 from statictext within w_fl315_bus_trip_zarp
end type
type dw_1 from u_dw_abc within w_fl315_bus_trip_zarp
end type
type dw_2 from u_dw_abc within w_fl315_bus_trip_zarp
end type
end forward

global type w_fl315_bus_trip_zarp from w_abc
integer width = 2542
integer height = 1672
string title = "Asistencia de Zarpes Anteriores (FL315)"
string menuname = "m_mto_smpl"
event ue_retrieve ( )
event ue_act_menu ( boolean ab_estado )
cb_copiar cb_copiar
st_2 st_2
st_1 st_1
dw_1 dw_1
dw_2 dw_2
end type
global w_fl315_bus_trip_zarp w_fl315_bus_trip_zarp

type variables
window iw_parent
string is_nave
date id_fecha1, id_fecha2
uo_asistencia iuo_asistencia
end variables

event ue_retrieve();dw_2.SetTransObject(SQLCA)
dw_2.Retrieve(is_nave, id_fecha1, id_fecha2)
end event

event ue_act_menu(boolean ab_estado);this.MenuId.item[1].item[1].item[4].visible = ab_estado
this.MenuId.item[1].item[1].item[5].visible = ab_estado

this.MenuId.item[1].item[1].item[4].ToolbarItemvisible = ab_estado
this.MenuId.item[1].item[1].item[5].ToolbarItemvisible = ab_estado

end event

on w_fl315_bus_trip_zarp.create
int iCurrent
call super::create
if this.MenuName = "m_mto_smpl" then this.MenuID = create m_mto_smpl
this.cb_copiar=create cb_copiar
this.st_2=create st_2
this.st_1=create st_1
this.dw_1=create dw_1
this.dw_2=create dw_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_copiar
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.dw_1
this.Control[iCurrent+5]=this.dw_2
end on

on w_fl315_bus_trip_zarp.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_copiar)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.dw_1)
destroy(this.dw_2)
end on

event resize;call super::resize;dw_1.width  = newwidth/2  - dw_1.x - 5
dw_1.height = newheight - dw_1.y - 20
dw_2.X      = newwidth/2  + 5
dw_2.width  = newwidth  - dw_2.x - 20
dw_2.height = newheight - dw_2.y - 10

st_1.X = dw_1.X
st_2.X = dw_2.X

cb_copiar.X  = newwidth  - cb_copiar.width - 20
end event

event ue_open_pre;call super::ue_open_pre;dw_2.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos
idw_1 = dw_1              				// asignar dw corriente
dw_1.BorderStyle = StyleRaised!			// indicar dw_detail como no activado

dw_2.of_protect()         		// bloquear modificaciones 

ii_pregunta_delete = 1   				// 1 = si pregunta, 0 = no pregunta (default)
iuo_asistencia = create uo_asistencia

this.event ue_act_menu(false)
end event

event ue_insert;call super::ue_insert;Long  ll_row

ll_row = dw_1.Event ue_insert()

IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)
end event

event close;call super::close;destroy iuo_asistencia
end event

type cb_copiar from commandbutton within w_fl315_bus_trip_zarp
integer x = 1783
integer y = 12
integer width = 361
integer height = 88
integer taborder = 10
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Copiar"
end type

event clicked;date 		ld_destino[]
long 		ll_x
string 	ls_parte
boolean 	lb_result

ll_x = dw_2.GetRow()

if ll_x <= 0 then
	MessageBox('ERROR', 'NO HAY ASISTENCIA SELECCIONADA', StopSign!)
	return
end if

ls_parte = trim(dw_2.object.parte_pesca[ll_x])

for ll_x =1 to dw_1.RowCount()
	ld_destino[ll_x] = Date(dw_1.object.fecha[ll_x])
next

lb_result = iuo_asistencia.of_copy_trip_zarpe( ls_parte, ld_destino, is_nave )

if lb_result then
	MessageBox('AVISO', 'PROCESO REALIZADO SATISFACTORIAMENTE', Information!)
	iw_parent.Event DYNAMIC ue_retrieve()
end if
end event

type st_2 from statictext within w_fl315_bus_trip_zarp
integer x = 1125
integer y = 132
integer width = 667
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Zarpes Anteriores"
boolean focusrectangle = false
end type

type st_1 from statictext within w_fl315_bus_trip_zarp
integer x = 73
integer y = 132
integer width = 434
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Fechas "
boolean focusrectangle = false
end type

type dw_1 from u_dw_abc within w_fl315_bus_trip_zarp
integer y = 212
integer width = 1106
integer height = 1228
integer taborder = 20
string dataobject = "d_ingreso_fecha_ext_grid"
boolean vscrollbar = true
end type

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw
end event

event ue_insert_pre;call super::ue_insert_pre;date ld_fecha
long ll_row

if al_row = 1 then
	ll_row = dw_2.GetRow()
	if ll_row <= 0 then
		ld_fecha = today()
	else
		ld_fecha = date(dw_2.object.fecha[ll_row])
	end if
	this.object.fecha[al_row] = ld_fecha
elseif al_row > 1 then
	ld_fecha = date(this.object.fecha[al_row - 1])
	ld_fecha = relativeDate(ld_fecha, 1)
	this.object.fecha[al_row] = ld_fecha
end if
end event

event rowfocuschanged;call super::rowfocuschanged;This.SelectRow(0, false)
this.SelectRow(currentrow, true)
this.SetRow(currentrow)
end event

type dw_2 from u_dw_abc within w_fl315_bus_trip_zarp
integer x = 1120
integer y = 212
integer width = 1335
integer height = 1228
string dataobject = "d_busc_trip_zarpe_grid"
boolean vscrollbar = true
end type

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

end event

event constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw
end event

event rowfocuschanged;call super::rowfocuschanged;This.SelectRow(0, false)
this.SelectRow(currentrow, true)
this.SetRow(currentrow)
end event

