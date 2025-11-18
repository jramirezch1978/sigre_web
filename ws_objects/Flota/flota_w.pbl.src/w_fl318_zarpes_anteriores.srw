$PBExportHeader$w_fl318_zarpes_anteriores.srw
forward
global type w_fl318_zarpes_anteriores from w_abc
end type
type cb_cancelar from commandbutton within w_fl318_zarpes_anteriores
end type
type st_master from statictext within w_fl318_zarpes_anteriores
end type
type st_detail from statictext within w_fl318_zarpes_anteriores
end type
type cb_aceptar from commandbutton within w_fl318_zarpes_anteriores
end type
type dw_detail from u_dw_abc within w_fl318_zarpes_anteriores
end type
type cb_refrescar from commandbutton within w_fl318_zarpes_anteriores
end type
type dw_master from u_dw_abc within w_fl318_zarpes_anteriores
end type
type uo_fecha from u_ingreso_rango_fechas within w_fl318_zarpes_anteriores
end type
end forward

global type w_fl318_zarpes_anteriores from w_abc
integer width = 2496
integer height = 1936
string title = "Zarpes Anteriores"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
boolean center = true
event ue_cancelar ( )
event ue_aceptar ( )
cb_cancelar cb_cancelar
st_master st_master
st_detail st_detail
cb_aceptar cb_aceptar
dw_detail dw_detail
cb_refrescar cb_refrescar
dw_master dw_master
uo_fecha uo_fecha
end type
global w_fl318_zarpes_anteriores w_fl318_zarpes_anteriores

type variables
string	is_nro_parte, is_aprobado, is_cod_nave
end variables

event ue_cancelar();close(this)
end event

event ue_aceptar();string 	ls_parte_pesca
long 		ll_row, ll_i
u_dw_abc	ldw_1, ldw_fuente

ll_row 	= dw_master.il_row

if ll_row = 0 then
	MessageBox('Aviso', 'No ha seleccionado ningun parte de Pesca', StopSign!)
	return
end if

if is_aprobado = '1' then 
	MessageBox('Aviso', 'El Parte de Pesca esta aprobado, no puede ejecutar esta operación', StopSign!)
	return
end if

ls_parte_pesca = dw_master.object.parte_pesca[ll_row]

if MessageBox('Informacion', 'Ha elegido el parte de pesca: ' + ls_parte_pesca &
		+ '~r~n¿Desea Tomar esta declaración como por defecto?', &
		Information!, YesNo!, 2) = 2 then
	return
end if

ldw_fuente = dw_detail

If IsValid(w_fl305_trip_zarpe) and Not IsNull(w_fl305_trip_zarpe) then
	ldw_1 = w_fl305_trip_zarpe.dw_master
	
	if ldw_1.RowCount() > 0 then
		if MessageBox('Informacion', "Ya se ha ingresado la tripulacion en el zarpe (Parte de Pesca: " + ls_parte_pesca + ")"&
				+ "~r~n¿Desea Eliminar toda la información y sustituirla por la que ha elegido?", &
				Information!, YesNo!, 2) = 2 then
			return
		end if
		
		ldw_1.event dynamic ue_delete_all( )
	end if
	
	for ll_i = 1 to ldw_fuente.RowCount()
		ldw_1.event ue_insert()
		ldw_1.object.tripulante			[ll_i] = ldw_fuente.object.tripulante	[ll_i]
		ldw_1.object.nomb_trip			[ll_i] = ldw_fuente.object.nombre		[ll_i]
		ldw_1.object.cargo_tripulante	[ll_i] = ldw_fuente.object.cod_cargo	[ll_i]
		ldw_1.object.descr_cargo		[ll_i] = ldw_fuente.object.descr_cargo	[ll_i]
	next
	
	
end if

Close(This)
end event

on w_fl318_zarpes_anteriores.create
int iCurrent
call super::create
this.cb_cancelar=create cb_cancelar
this.st_master=create st_master
this.st_detail=create st_detail
this.cb_aceptar=create cb_aceptar
this.dw_detail=create dw_detail
this.cb_refrescar=create cb_refrescar
this.dw_master=create dw_master
this.uo_fecha=create uo_fecha
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_cancelar
this.Control[iCurrent+2]=this.st_master
this.Control[iCurrent+3]=this.st_detail
this.Control[iCurrent+4]=this.cb_aceptar
this.Control[iCurrent+5]=this.dw_detail
this.Control[iCurrent+6]=this.cb_refrescar
this.Control[iCurrent+7]=this.dw_master
this.Control[iCurrent+8]=this.uo_fecha
end on

on w_fl318_zarpes_anteriores.destroy
call super::destroy
destroy(this.cb_cancelar)
destroy(this.st_master)
destroy(this.st_detail)
destroy(this.cb_aceptar)
destroy(this.dw_detail)
destroy(this.cb_refrescar)
destroy(this.dw_master)
destroy(this.uo_fecha)
end on

event ue_set_access;// Ancestor Script has been Override

end event

event ue_open_pre;call super::ue_open_pre;str_parametros 	lstr_param

dw_master.SetTransObject(sqlca)  	// Relacionar el dw con la base de datos
dw_detail.SetTransObject(sqlca)  	// Relacionar el dw con la base de datos

idw_1 = dw_master

if Message.PowerObjectParm.ClassName() = 'str_parametros' then
	lstr_param 			= Message.PowerObjectParm
	is_nro_parte 		= lstr_param.string1
	is_aprobado 		= lstr_param.string2
	is_cod_nave			= lstr_param.string3
else
	MessageBox('Aviso', "Message.PowerObjectParm no es del tipo 'str_parametros'", StopSign!)
	Close(this)
	return
end if

this.event dynamic ue_query_retrieve()
end event

event ue_query_retrieve;// Ancestor Script has been Override
string 	ls_desc_nave
date 		ld_fecha1, ld_fecha2

ld_fecha1 	= uo_fecha.of_get_fecha1( )
ld_fecha2 	= uo_fecha.of_get_fecha2( )

if ld_fecha2 < ld_fecha1 then
	MessageBox('Aviso', 'RANGO DE FECHAS INVALIDO, POR FAVOR VERIFIQUE', StopSign!)
	return
end if

select NOMB_NAVE
	into :ls_desc_nave
from tg_naves
where nave = :is_cod_nave;

dw_master.Retrieve(is_cod_nave, is_nro_parte, ld_fecha1, ld_fecha2)
this.Title = 'Zarpes Anteriores NAVE: '  + is_cod_nave &
	+ ' - ' + ls_desc_nave + ' (FL318)'

end event

event resize;call super::resize;dw_master.width  	= newwidth  - dw_master.x - 10
st_master.X 		= dw_master.X
st_master.width 	= dw_master.width

dw_detail.width  	= newwidth  - dw_detail.x - 10
dw_detail.height 	= newheight - dw_detail.y - 10
st_detail.X 		= dw_detail.X
st_detail.width 	= dw_detail.width

end event

type cb_cancelar from commandbutton within w_fl318_zarpes_anteriores
integer x = 2080
integer y = 16
integer width = 352
integer height = 100
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Cancelar"
boolean cancel = true
end type

event clicked;parent.event dynamic ue_cancelar()

end event

type st_master from statictext within w_fl318_zarpes_anteriores
integer x = 553
integer y = 120
integer width = 1239
integer height = 72
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 67108864
string text = "PARTES DE PESCA"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_detail from statictext within w_fl318_zarpes_anteriores
integer x = 631
integer y = 940
integer width = 1239
integer height = 64
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 67108864
string text = "TRIPULANTES DECLARADOS"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_aceptar from commandbutton within w_fl318_zarpes_anteriores
integer x = 1710
integer y = 16
integer width = 352
integer height = 100
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Aceptar"
boolean default = true
end type

event clicked;parent.event dynamic ue_aceptar()
end event

type dw_detail from u_dw_abc within w_fl318_zarpes_anteriores
integer y = 1024
integer width = 2437
integer height = 752
integer taborder = 60
string dataobject = "d_tripulacion_zarpe_grid"
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
end type

event constructor;call super::constructor;is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_rk[1] = 1 	      // columnas que recibimos del master

idw_mst  = 	dw_master

end event

event rowfocuschanged;call super::rowfocuschanged;IF ii_ss = 1 THEN		        // solo para seleccion individual			
	il_row = Currentrow              // fila corriente
	This.SelectRow(0, False)
	This.SelectRow(CurrentRow, True)
	THIS.SetRow(CurrentRow)
	THIS.Event ue_output(CurrentRow)
	RETURN
END IF

end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

end event

type cb_refrescar from commandbutton within w_fl318_zarpes_anteriores
integer x = 1339
integer y = 16
integer width = 352
integer height = 100
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Cargar Datos"
end type

event clicked;parent.event dynamic ue_query_retrieve()
end event

type dw_master from u_dw_abc within w_fl318_zarpes_anteriores
integer y = 204
integer width = 2437
integer height = 724
integer taborder = 50
string dataobject = "d_fechas_zarpes_grid"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
end type

event constructor;call super::constructor;is_mastdet = 'md'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_dk[1] = 1 	      // columnas que se pasan al detalle

idw_det  = dw_detail
end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

end event

event rowfocuschanged;call super::rowfocuschanged;IF ii_ss = 1 THEN		        // solo para seleccion individual			
	il_row = Currentrow              // fila corriente
	This.SelectRow(0, False)
	This.SelectRow(CurrentRow, True)
	THIS.SetRow(CurrentRow)
	THIS.Event ue_output(CurrentRow)
	RETURN
END IF

end event

event ue_output;call super::ue_output;if al_row > 0 then
	THIS.EVENT ue_retrieve_det(al_row)
end if
end event

event ue_retrieve_det_pos;call super::ue_retrieve_det_pos;idw_det.retrieve(aa_id[1])
if idw_det.RowCount() > 0 then
	idw_det.SetRow(1)
	f_select_current_row(idw_det)
end if
this.SetFocus()
end event

event doubleclicked;call super::doubleclicked;parent.event dynamic ue_aceptar()
end event

type uo_fecha from u_ingreso_rango_fechas within w_fl318_zarpes_anteriores
integer x = 14
integer y = 20
integer taborder = 40
end type

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

on uo_fecha.destroy
call u_ingreso_rango_fechas::destroy
end on

