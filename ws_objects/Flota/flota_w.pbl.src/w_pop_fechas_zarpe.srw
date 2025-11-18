$PBExportHeader$w_pop_fechas_zarpe.srw
forward
global type w_pop_fechas_zarpe from w_abc
end type
type pb_ok from picturebutton within w_pop_fechas_zarpe
end type
type pb_cancel from picturebutton within w_pop_fechas_zarpe
end type
type dw_master from u_dw_abc within w_pop_fechas_zarpe
end type
end forward

global type w_pop_fechas_zarpe from w_abc
integer width = 1033
integer height = 1300
string title = "Fechas de Zarpe"
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
event ue_aceptar ( )
pb_ok pb_ok
pb_cancel pb_cancel
dw_master dw_master
end type
global w_pop_fechas_zarpe w_pop_fechas_zarpe

event ue_aceptar();date		ld_fecha
Integer	li_tripulantes
Str_parametros lstr_param

if dw_master.RowCount() = 0  or dw_master.getRow() = 0 then
	lstr_param.b_return = false
else
	lstr_param.b_return = true
	
	ld_fecha 		= Date(dw_master.object.fecha_zarpe [dw_master.GetRow()])
	li_tripulantes	= Int(dw_master.object.tripulantes 	[dw_master.GetRow()])
	
	lstr_param.fecha1 = ld_fecha
	lstr_param.int1 	= li_tripulantes
end if

CloseWithReturn(this, lstr_param)
end event

on w_pop_fechas_zarpe.create
int iCurrent
call super::create
this.pb_ok=create pb_ok
this.pb_cancel=create pb_cancel
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_ok
this.Control[iCurrent+2]=this.pb_cancel
this.Control[iCurrent+3]=this.dw_master
end on

on w_pop_fechas_zarpe.destroy
call super::destroy
destroy(this.pb_ok)
destroy(this.pb_cancel)
destroy(this.dw_master)
end on

event ue_cancelar;call super::ue_cancelar;Str_parametros lstr_param

lstr_param.b_return = false

CloseWithReturn(this, lstr_param)
end event

event ue_open_pre;call super::ue_open_pre;Str_parametros lstr_param
String	ls_nave

if ISNull(Message.PowerObjectParm) or not IsValid(Message.PowerObjectParm) then 
	gnvo_app.of_message_error( "No ha especificado un parametro de ingreso para esta ventana")
	return
end if

if Message.PowerObjectParm.ClassName() <> 'str_parametros' then 
	gnvo_app.of_message_error( "El parametro de ingreso para esta ventana debe ser de tipo str_parametros, por favor verifique!")
	return
end if

lstr_param = MESSAGE.POWEROBJECTPARM
ls_nave = lstr_param.string1

dw_master.SetTransObject( SQLCA)	
dw_master.Retrieve(ls_nave)
end event

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - 10
dw_master.height = newheight - dw_master.y - 10
end event

type pb_ok from picturebutton within w_pop_fechas_zarpe
integer x = 78
integer y = 980
integer width = 325
integer height = 188
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean default = true
string picturename = "C:\SIGRE\resources\BMP\Aceptar.bmp"
alignment htextalign = left!
boolean map3dcolors = true
string powertiptext = "Cambiar Origen"
end type

event clicked;parent.event ue_aceptar( )
end event

type pb_cancel from picturebutton within w_pop_fechas_zarpe
integer x = 558
integer y = 976
integer width = 325
integer height = 188
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean cancel = true
string picturename = "C:\SIGRE\resources\BMP\Salir.bmp"
alignment htextalign = left!
boolean map3dcolors = true
string powertiptext = "Salir del Sistema"
end type

event clicked;parent.event ue_cancelar( )
end event

type dw_master from u_dw_abc within w_pop_fechas_zarpe
integer width = 1010
integer height = 952
string dataobject = "d_lista_fechas_zarpe_tbl"
boolean hscrollbar = false
end type

event rowfocuschanged;call super::rowfocuschanged;This.SelectRow(0, False)
This.SelectRow(currentrow, True)
THIS.SetRow(currentrow)
This.SetRow( currentrow )
end event

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
//idw_det  =  				// dw_detail
end event

