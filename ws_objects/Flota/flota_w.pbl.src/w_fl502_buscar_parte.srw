$PBExportHeader$w_fl502_buscar_parte.srw
forward
global type w_fl502_buscar_parte from window
end type
type cbx_todo from checkbox within w_fl502_buscar_parte
end type
type rb_arribo from radiobutton within w_fl502_buscar_parte
end type
type rb_zarpe from radiobutton within w_fl502_buscar_parte
end type
type pb_recuperar from u_pb_std within w_fl502_buscar_parte
end type
type uo_fecha from u_ingreso_rango_fechas within w_fl502_buscar_parte
end type
type st_nomb_nave from statictext within w_fl502_buscar_parte
end type
type st_1 from statictext within w_fl502_buscar_parte
end type
type sle_nave from singlelineedit within w_fl502_buscar_parte
end type
type dw_master from u_dw_abc within w_fl502_buscar_parte
end type
type cb_2 from commandbutton within w_fl502_buscar_parte
end type
type cb_1 from commandbutton within w_fl502_buscar_parte
end type
end forward

global type w_fl502_buscar_parte from window
integer width = 2386
integer height = 1472
boolean titlebar = true
string title = "Busqueda por Partes de Pesca (FL502)"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
event ue_aceptar ( )
event ue_cancelar ( )
event ue_retrieve ( )
cbx_todo cbx_todo
rb_arribo rb_arribo
rb_zarpe rb_zarpe
pb_recuperar pb_recuperar
uo_fecha uo_fecha
st_nomb_nave st_nomb_nave
st_1 st_1
sle_nave sle_nave
dw_master dw_master
cb_2 cb_2
cb_1 cb_1
end type
global w_fl502_buscar_parte w_fl502_buscar_parte

type variables
string is_nro_parte
uo_parte_pesca iuo_parte
end variables

event ue_aceptar();long ll_row
str_buscar lstr_buscar

ll_row = dw_master.GetRow()

if ll_row <= 0 then
	MessageBox('Error', 'NO HA SELECCIONADO NINGUN REGISTRO', StopSign!)
	return
end if

lstr_buscar.ls_parte = trim(dw_master.object.parte_pesca[ll_row])

if rb_arribo.checked then
	lstr_buscar.ls_tipo_pp = "arribo"
elseif rb_zarpe.checked then
	lstr_buscar.ls_tipo_pp = "zarpe"
end if

CloseWithReturn(this, lstr_buscar)
end event

event ue_cancelar();str_buscar lstr_buscar
lstr_buscar.ls_parte = ""

CloseWithReturn(this, lstr_buscar)
end event

event ue_retrieve();date ld_fecha1, ld_fecha2
string ls_cadena

ld_fecha1 = uo_fecha.of_get_fecha1()
ld_fecha2 = uo_fecha.of_get_fecha2()

if cbx_todo.checked then
	ls_cadena = '%%'
else
	ls_cadena = trim(sle_nave.text)
end if

dw_master.SetTransObject(SQLCA)
dw_master.Retrieve( ld_fecha1, ld_fecha2, ls_cadena )

rb_zarpe.enabled   = true
rb_arribo.enabled  = true
end event

on w_fl502_buscar_parte.create
this.cbx_todo=create cbx_todo
this.rb_arribo=create rb_arribo
this.rb_zarpe=create rb_zarpe
this.pb_recuperar=create pb_recuperar
this.uo_fecha=create uo_fecha
this.st_nomb_nave=create st_nomb_nave
this.st_1=create st_1
this.sle_nave=create sle_nave
this.dw_master=create dw_master
this.cb_2=create cb_2
this.cb_1=create cb_1
this.Control[]={this.cbx_todo,&
this.rb_arribo,&
this.rb_zarpe,&
this.pb_recuperar,&
this.uo_fecha,&
this.st_nomb_nave,&
this.st_1,&
this.sle_nave,&
this.dw_master,&
this.cb_2,&
this.cb_1}
end on

on w_fl502_buscar_parte.destroy
destroy(this.cbx_todo)
destroy(this.rb_arribo)
destroy(this.rb_zarpe)
destroy(this.pb_recuperar)
destroy(this.uo_fecha)
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

type cbx_todo from checkbox within w_fl502_buscar_parte
integer x = 1783
integer y = 216
integer width = 475
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 67108864
string text = "Todas las naves"
boolean checked = true
end type

event clicked;if this.checked then
	sle_nave.enabled = false
else
	sle_nave.enabled = true
end if
end event

type rb_arribo from radiobutton within w_fl502_buscar_parte
integer x = 1742
integer y = 108
integer width = 274
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 67108864
boolean enabled = false
string text = "Arribo"
end type

type rb_zarpe from radiobutton within w_fl502_buscar_parte
integer x = 1742
integer y = 28
integer width = 274
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 67108864
boolean enabled = false
string text = "Zarpe"
boolean checked = true
end type

type pb_recuperar from u_pb_std within w_fl502_buscar_parte
integer x = 2185
integer y = 56
integer width = 155
integer height = 132
integer taborder = 20
integer textsize = -2
string text = "&r"
string picturename = "Retrieve!"
boolean map3dcolors = true
end type

event clicked;call super::clicked;parent.event ue_retrieve()
end event

type uo_fecha from u_ingreso_rango_fechas within w_fl502_buscar_parte
event destroy ( )
integer x = 73
integer y = 68
integer taborder = 20
end type

on uo_fecha.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;date 		ld_fecha1, ld_fecha2
Integer 	li_ano, li_mes

of_set_label('Desde:','Hasta:') //para setear la fecha inicial
of_set_fecha(date('01/01/1900'), date('31/12/9999')) // para seatear el titulo del boton
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final

li_ano = Year(Today())
li_mes = Month(Today())

if li_mes = 12 then
	li_mes = 1
	li_ano ++
else
	li_mes ++
end if

ld_fecha1 = date('01/' + String( month( today() ) ,'00' ) &
	+ '/' + string( year( today() ), '0000') )

ld_fecha2 = date('01/' + String( li_mes ,'00' ) &
	+ '/' + string(li_ano, '0000') )

ld_fecha2 = RelativeDate( ld_fecha2, -1 )

This.of_set_fecha( ld_fecha1, ld_fecha2 )

end event

type st_nomb_nave from statictext within w_fl502_buscar_parte
integer x = 818
integer y = 208
integer width = 951
integer height = 88
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 67108864
boolean border = true
boolean focusrectangle = false
end type

type st_1 from statictext within w_fl502_buscar_parte
integer x = 59
integer y = 220
integer width = 421
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

type sle_nave from singlelineedit within w_fl502_buscar_parte
event ue_dblclick pbm_lbuttondblclk
event ue_desp_naves ( )
event ue_keydwn pbm_keydown
integer x = 507
integer y = 208
integer width = 293
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
boolean enabled = false
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
		 + "NOMB_NAVE AS DESCRIPCION, " &
		 + "FLAG_TIPO_FLOTA AS TIPO_FLOTA " &
       + "FROM TG_NAVES " 
				 
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
parent.event ue_retrieve()
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

parent.event ue_retrieve()
end event

type dw_master from u_dw_abc within w_fl502_buscar_parte
integer y = 340
integer width = 2350
integer height = 836
string dataobject = "d_parte_pesca_grid"
boolean hscrollbar = true
boolean vscrollbar = true
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

type cb_2 from commandbutton within w_fl502_buscar_parte
integer x = 1920
integer y = 1200
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

type cb_1 from commandbutton within w_fl502_buscar_parte
integer x = 1481
integer y = 1200
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

