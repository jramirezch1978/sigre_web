$PBExportHeader$w_fl500_buscar_zarpe.srw
forward
global type w_fl500_buscar_zarpe from window
end type
type st_nomb_nave from statictext within w_fl500_buscar_zarpe
end type
type st_1 from statictext within w_fl500_buscar_zarpe
end type
type sle_nave from singlelineedit within w_fl500_buscar_zarpe
end type
type dw_master from u_dw_abc within w_fl500_buscar_zarpe
end type
type cb_2 from commandbutton within w_fl500_buscar_zarpe
end type
type cb_1 from commandbutton within w_fl500_buscar_zarpe
end type
end forward

global type w_fl500_buscar_zarpe from window
integer width = 2386
integer height = 1356
boolean titlebar = true
string title = "Buscar Zarpes"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
event ue_aceptar ( )
event ue_cancelar ( )
event ue_retrieve ( string as_nave )
st_nomb_nave st_nomb_nave
st_1 st_1
sle_nave sle_nave
dw_master dw_master
cb_2 cb_2
cb_1 cb_1
end type
global w_fl500_buscar_zarpe w_fl500_buscar_zarpe

type variables
string is_nro_parte
uo_parte_pesca iuo_parte
end variables

event ue_aceptar();long ll_row

ll_row = dw_master.GetRow()

if ll_row <= 0 then
	MessageBox('Error', 'NO HA SELECCIONADO NINGUN REGISTRO', StopSign!)
	return
end if

is_nro_parte = trim(dw_master.object.parte_pesca[ll_row])

CloseWithReturn(this, is_nro_parte)
end event

event ue_cancelar();SetNull(is_nro_parte)

CloseWithReturn(this, is_nro_parte)
end event

event ue_retrieve(string as_nave);dw_master.SetTransObject(SQLCA)
dw_master.Retrieve(as_nave)
end event

on w_fl500_buscar_zarpe.create
this.st_nomb_nave=create st_nomb_nave
this.st_1=create st_1
this.sle_nave=create sle_nave
this.dw_master=create dw_master
this.cb_2=create cb_2
this.cb_1=create cb_1
this.Control[]={this.st_nomb_nave,&
this.st_1,&
this.sle_nave,&
this.dw_master,&
this.cb_2,&
this.cb_1}
end on

on w_fl500_buscar_zarpe.destroy
destroy(this.st_nomb_nave)
destroy(this.st_1)
destroy(this.sle_nave)
destroy(this.dw_master)
destroy(this.cb_2)
destroy(this.cb_1)
end on

event resize;dw_master.width  = newwidth  - dw_master.x - 10
end event

event open;iuo_parte = CREATE uo_parte_pesca

end event

event close;DESTROY iuo_parte
end event

type st_nomb_nave from statictext within w_fl500_buscar_zarpe
integer x = 1061
integer y = 36
integer width = 763
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 67108864
boolean focusrectangle = false
end type

type st_1 from statictext within w_fl500_buscar_zarpe
integer x = 155
integer y = 36
integer width = 512
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Codigo de Nave:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_nave from singlelineedit within w_fl500_buscar_zarpe
event ue_dblclick pbm_lbuttondblclk
event ue_desp_naves ( )
event ue_keydwn pbm_keydown
integer x = 695
integer y = 24
integer width = 343
integer height = 88
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long textcolor = 33554432
integer limit = 10
borderstyle borderstyle = stylelowered!
end type

event ue_dblclick;this.event ue_desp_naves()
end event

event ue_desp_naves();// Este evento despliega la pantalla w_seleccionar

string ls_codigo, ls_data, ls_sql
integer li_i
str_seleccionar lstr_seleccionar

ls_sql = "SELECT NAVE AS CODIGO, " &
		 + "NOMB_NAVE AS DESCRIPCION " &
       + "FROM TG_NAVES " &
   	 + "WHERE FLAG_TIPO_FLOTA = 'P'"
				 
lstr_seleccionar.s_column 	  = '1'
lstr_seleccionar.s_sql       = ls_sql
lstr_seleccionar.s_seleccion = 'S'

OpenWithParm(w_seleccionar,lstr_seleccionar)

IF isvalid(message.PowerObjectParm) THEN 
	lstr_seleccionar = message.PowerObjectParm
END IF	

IF lstr_seleccionar.s_action = "aceptar" THEN
	ls_codigo = lstr_seleccionar.param1[1]
	ls_data   = lstr_seleccionar.param2[1]
ELSE		
	Messagebox('Error', "DEBE SELECCIONAR UN CODIGO DE NAVE", StopSign!)
	return
end if
		
st_nomb_nave.text = ls_data		
this.text	 		= ls_codigo
parent.event ue_retrieve(ls_codigo)
end event

event ue_keydwn;if Key = KeyF2! then
	this.event ue_desp_naves()	
end if
end event

event modified;string ls_codigo, ls_data

ls_codigo = trim(this.text)

iuo_parte.of_get_nomb_nave( ls_codigo )
		
if ls_data = "" then
	Messagebox('Error', "CODIGO DE NAVE NO EXISTE", StopSign!)
	return
end if
		
st_nomb_nave.text = ls_data

parent.event ue_retrieve(ls_codigo)
end event

type dw_master from u_dw_abc within w_fl500_buscar_zarpe
integer y = 152
integer width = 2350
integer height = 920
string dataobject = "d_buscar_zarpe_grid"
end type

event constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw
end event

event doubleclicked;call super::doubleclicked;parent.event ue_aceptar()
end event

event rowfocuschanged;call super::rowfocuschanged;This.SelectRow(0, false)
this.SelectRow(currentrow, true)
this.SetRow(currentrow)
end event

type cb_2 from commandbutton within w_fl500_buscar_zarpe
integer x = 1920
integer y = 1116
integer width = 402
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancelar"
boolean cancel = true
end type

event clicked;parent.event ue_cancelar()
end event

type cb_1 from commandbutton within w_fl500_buscar_zarpe
integer x = 1481
integer y = 1116
integer width = 402
integer height = 112
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Aceptar"
boolean default = true
end type

event clicked;parent.event ue_aceptar()
end event

