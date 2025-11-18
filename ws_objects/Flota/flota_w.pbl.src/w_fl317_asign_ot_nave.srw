$PBExportHeader$w_fl317_asign_ot_nave.srw
forward
global type w_fl317_asign_ot_nave from w_abc
end type
type pb_recuperar from u_pb_std within w_fl317_asign_ot_nave
end type
type uo_fecha from u_ingreso_rango_fechas within w_fl317_asign_ot_nave
end type
type st_3 from statictext within w_fl317_asign_ot_nave
end type
type st_2 from statictext within w_fl317_asign_ot_nave
end type
type cb_asignar from commandbutton within w_fl317_asign_ot_nave
end type
type cb_liberar from commandbutton within w_fl317_asign_ot_nave
end type
type dw_2 from u_dw_abc within w_fl317_asign_ot_nave
end type
type dw_1 from u_dw_abc within w_fl317_asign_ot_nave
end type
type sle_nave from singlelineedit within w_fl317_asign_ot_nave
end type
type st_1 from statictext within w_fl317_asign_ot_nave
end type
type st_nomb_nave from statictext within w_fl317_asign_ot_nave
end type
end forward

global type w_fl317_asign_ot_nave from w_abc
integer width = 2185
integer height = 1648
string title = "Asignación de O.Trabajo y NAVE (FL317)"
string menuname = "m_smpl"
event ue_retrieve ( )
event ue_asignar ( )
event ue_liberar ( )
pb_recuperar pb_recuperar
uo_fecha uo_fecha
st_3 st_3
st_2 st_2
cb_asignar cb_asignar
cb_liberar cb_liberar
dw_2 dw_2
dw_1 dw_1
sle_nave sle_nave
st_1 st_1
st_nomb_nave st_nomb_nave
end type
global w_fl317_asign_ot_nave w_fl317_asign_ot_nave

type variables
uo_parte_pesca iuo_parte
end variables

event ue_retrieve();date 		ld_fecha1, ld_fecha2
string	ls_nave

ls_nave 		= trim(sle_nave.text)
ld_fecha1 	= uo_fecha.of_get_fecha1()
ld_fecha2 	= uo_fecha.of_get_fecha2()

if ls_nave = '' then
	MessageBox('ERROR', 'EL CODIGO DE LA NAVE ESTA VACIO', StopSign!)
	return
end if

dw_2.SetRedraw(false)
dw_2.SetTransObject(SQLCA)
dw_2.Retrieve(ld_fecha1, ld_fecha2, gs_user)
dw_2.SetRedraw(true)

dw_1.SetRedraw(false)
dw_1.SetTransObject(SQLCA)
dw_1.Retrieve(ls_nave, ld_fecha1, ld_fecha2)
dw_1.SetRedraw(true)

dw_1.SelectRow(0, false)
dw_2.SelectRow(0, false)
end event

event ue_asignar();string ls_nro_ot, ls_origen, ls_nave
long ll_row, ll_row1

ls_nave = trim(sle_nave.text)

if ls_nave = '' then
	return
end if


for ll_row = 1 to dw_2.RowCount()
	if dw_2.IsSelected(ll_row) then
		ls_nro_ot  = trim(dw_2.object.nro_orden  [ll_row])
		ls_origen = trim(dw_2.object.cod_origen[ll_row])
		
		ll_row1 = dw_1.event ue_insert()
		dw_1.object.nave					[ll_row1] = ls_nave
		dw_1.object.cod_origen			[ll_row1] = ls_origen
		dw_1.object.nro_orden			[ll_row1] = ls_nro_ot
		dw_1.object.cencos_slc			[ll_row1] = dw_2.object.cencos_slc 	[ll_row]
		dw_1.object.cod_maquina			[ll_row1] = dw_2.object.cod_maquina [ll_row]
		dw_1.object.descripcion			[ll_row1] = dw_2.object.descripcion [ll_row]
		dw_1.object.flag_replicacion	[ll_row1] = '1'
		dw_1.ii_update = 1
	end if
next

this.event ue_update()

this.event ue_retrieve()
end event

event ue_liberar();string ls_orden, ls_nave
long ll_row

ls_nave = trim(sle_nave.text)

if ls_nave = '' then
	return
end if


for ll_row = 1 to dw_1.RowCount()
	if dw_1.IsSelected(ll_row) then
		dw_1.DeleteRow(ll_row)
		dw_1.ii_update = 1
	end if
next

this.event ue_update()
this.event ue_retrieve()
end event

on w_fl317_asign_ot_nave.create
int iCurrent
call super::create
if this.MenuName = "m_smpl" then this.MenuID = create m_smpl
this.pb_recuperar=create pb_recuperar
this.uo_fecha=create uo_fecha
this.st_3=create st_3
this.st_2=create st_2
this.cb_asignar=create cb_asignar
this.cb_liberar=create cb_liberar
this.dw_2=create dw_2
this.dw_1=create dw_1
this.sle_nave=create sle_nave
this.st_1=create st_1
this.st_nomb_nave=create st_nomb_nave
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_recuperar
this.Control[iCurrent+2]=this.uo_fecha
this.Control[iCurrent+3]=this.st_3
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.cb_asignar
this.Control[iCurrent+6]=this.cb_liberar
this.Control[iCurrent+7]=this.dw_2
this.Control[iCurrent+8]=this.dw_1
this.Control[iCurrent+9]=this.sle_nave
this.Control[iCurrent+10]=this.st_1
this.Control[iCurrent+11]=this.st_nomb_nave
end on

on w_fl317_asign_ot_nave.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_recuperar)
destroy(this.uo_fecha)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.cb_asignar)
destroy(this.cb_liberar)
destroy(this.dw_2)
destroy(this.dw_1)
destroy(this.sle_nave)
destroy(this.st_1)
destroy(this.st_nomb_nave)
end on

event ue_open_pre;call super::ue_open_pre;date ld_fecha1, ld_fecha2
iuo_parte = CREATE uo_parte_pesca

ld_fecha1 = date('01/' + String( month( today() ) ,'00' ) &
	+ '/' + string( year( today() ), '0000') )

ld_fecha2 = date('01/' + String( month( today() ) + 1 ,'00' ) &
	+ '/' + string( year( today() ), '0000') )
ld_fecha2 = RelativeDate( ld_fecha2, -1 )

uo_fecha.of_set_fecha( ld_fecha1, ld_fecha2 )
end event

event close;call super::close;destroy iuo_parte
end event

event resize;call super::resize;this.SetRedraw(false)
//datawindows
dw_1.width  = newwidth/2  - dw_1.x/2 - 120
dw_1.height = newheight - dw_1.y - 10
dw_2.X		= newwidth/2 + 120
dw_2.width  = newwidth  - dw_2.x - 10
dw_2.height = newheight - dw_2.y - 10

//Botones cb_liberar y cb_asignar

cb_asignar.X = newWidth/2 - cb_asignar.width/2
cb_liberar.X = newWidth/2 - cb_liberar.width/2

//Etiquetas de Texto
st_2.X 		= dw_1.X
st_2.width	= dw_1.width

st_3.X 		= dw_2.X
st_3.width	= dw_2.width

this.SetRedraw(true)
end event

event ue_update;call super::ue_update;Boolean lbo_ok = TRUE

dw_1.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF dw_1.ii_update = 1 THEN
	IF dw_1.Update() = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
    	Rollback ;
		messagebox("Error en Grabacion","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_1.ii_update = 0
END IF
end event

type pb_recuperar from u_pb_std within w_fl317_asign_ot_nave
integer x = 1856
integer y = 44
integer width = 155
integer height = 132
integer taborder = 20
integer textsize = -2
string text = "&r"
string picturename = "Retrieve!"
boolean map3dcolors = true
end type

event clicked;call super::clicked;parent.event dynamic ue_retrieve()
end event

type uo_fecha from u_ingreso_rango_fechas within w_fl317_asign_ot_nave
event destroy ( )
integer x = 105
integer y = 20
integer taborder = 30
end type

on uo_fecha.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;of_set_label('Desde:','Hasta:') //para setear la fecha inicial
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final

end event

type st_3 from statictext within w_fl317_asign_ot_nave
integer x = 1189
integer y = 292
integer width = 937
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "O.Trabajo x OT_ADM"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_2 from statictext within w_fl317_asign_ot_nave
integer y = 292
integer width = 864
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "O.T. Asignados a la Nave"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_asignar from commandbutton within w_fl317_asign_ot_nave
integer x = 910
integer y = 652
integer width = 219
integer height = 100
integer taborder = 40
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "<"
end type

event clicked;parent.event dynamic ue_asignar()
end event

type cb_liberar from commandbutton within w_fl317_asign_ot_nave
integer x = 905
integer y = 760
integer width = 219
integer height = 100
integer taborder = 40
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = ">"
end type

event clicked;parent.event dynamic ue_liberar()
end event

type dw_2 from u_dw_abc within w_fl317_asign_ot_nave
integer x = 1189
integer y = 372
integer width = 937
integer height = 1040
integer taborder = 30
string dragicon = "DosEdit5!"
string dataobject = "d_ot_nave_libres_grid"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)
ii_ss = 0 					// indica si se usa seleccion: 1=individual (default), 0=multiple
ii_ck[1] = 1				// columnas de lectrua de este dw

end event

event rowfocuschanged;call super::rowfocuschanged;long ll_row

ll_row = CurrentRow

IF ll_row = 0 OR is_dwform = 'form' THEN RETURN

IF ii_ss = 1 THEN		        // solo para seleccion individual			
	il_row = ll_row              // fila corriente
	This.Selectrow(0, False)
	This.Selectrow(ll_row, True)
	THIS.Setrow(ll_row)
	THIS.ScrollToRow(ll_row)
	THIS.Event ue_output(ll_row)
	RETURN
END IF
end event

event doubleclicked;call super::doubleclicked;if row > 0 then
	parent.event dynamic ue_asignar()
end if
end event

event clicked;call super::clicked;if row > 0 then
	this.drag( begin! )
else
	this.drag( Cancel! )
end if
end event

event dragdrop;call super::dragdrop;DragObject	ldo_control

ldo_control = DraggedObject()

if ldo_control = dw_1 then
	parent.event dynamic ue_liberar()
end if

end event

type dw_1 from u_dw_abc within w_fl317_asign_ot_nave
integer y = 372
integer width = 864
integer height = 1040
integer taborder = 20
string dragicon = "DosEdit5!"
string dataobject = "d_ot_nave_asig_grid"
boolean minbox = true
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)
ii_ss = 0 					// indica si se usa seleccion: 1=individual (default), 0=multiple
ii_ck[1] = 1				// columnas de lectrua de este dw

end event

event rowfocuschanged;call super::rowfocuschanged;long ll_row

ll_row = CurrentRow

IF ll_row = 0 OR is_dwform = 'form' THEN RETURN

IF ii_ss = 1 THEN		        // solo para seleccion individual			
	il_row = ll_row              // fila corriente
	This.Selectrow(0, False)
	This.Selectrow(ll_row, True)
	THIS.Setrow(ll_row)
	THIS.ScrollToRow(ll_row)
	THIS.Event ue_output(ll_row)
	RETURN
END IF
end event

event doubleclicked;call super::doubleclicked;if row > 0 then
	parent.event dynamic ue_liberar()
end if
end event

event clicked;call super::clicked;if row > 0 then
	this.drag( begin! )
else
	this.drag( Cancel! )
end if
end event

event dragdrop;call super::dragdrop;DragObject	ldo_control

ldo_control = DraggedObject()

if ldo_control = dw_2 then
	parent.event dynamic ue_asignar()
end if

end event

type sle_nave from singlelineedit within w_fl317_asign_ot_nave
event ue_dblclick pbm_lbuttondblclk
event ue_display ( )
event ue_keydwn pbm_keydown
integer x = 503
integer y = 144
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

event ue_dblclick;this.event ue_display()
end event

event ue_display();// Este evento despliega la pantalla w_seleccionar

string ls_codigo, ls_data, ls_sql
integer li_i
str_seleccionar lstr_seleccionar

ls_sql = "SELECT NAVE AS CODIGO, " &
		 + "NOMB_NAVE AS DESCRIPCION, " &
		 + "FLAG_TIPO_FLOTA AS TIPO_FLOTA " &
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
parent.event DYNAMIC ue_retrieve()
end event

event ue_keydwn;if Key = KeyF2! then
	this.event ue_display()	
end if
end event

event modified;string ls_codigo, ls_data, ls_tflota

ls_codigo = trim(this.text)

iuo_parte.of_get_nomb_nave( ls_codigo )
		
if ls_data = "" then
	this.text 			= ''
	st_nomb_nave.text = ''
	Messagebox('Error', "CODIGO DE NAVE NO EXISTE", StopSign!)
	return
end if

ls_tflota = iuo_parte.of_get_tipo_flota( ls_codigo )

if ls_tflota <> 'P' then
	this.text 			= ''
	st_nomb_nave.text = ''
	Messagebox('Error', "LA EMBARCACIÓN NO ES FLOTA PROPIA", StopSign!)
	return
end if

st_nomb_nave.text = ls_data

parent.event DYNAMIC ue_retrieve()
end event

type st_1 from statictext within w_fl317_asign_ot_nave
integer x = 46
integer y = 156
integer width = 443
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

type st_nomb_nave from statictext within w_fl317_asign_ot_nave
integer x = 855
integer y = 156
integer width = 937
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

