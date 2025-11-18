$PBExportHeader$w_abc_lista_zapatos_sugeridos.srw
forward
global type w_abc_lista_zapatos_sugeridos from w_abc
end type
type cb_cancel from commandbutton within w_abc_lista_zapatos_sugeridos
end type
type cb_aceptar from commandbutton within w_abc_lista_zapatos_sugeridos
end type
type dw_master from u_dw_abc within w_abc_lista_zapatos_sugeridos
end type
end forward

global type w_abc_lista_zapatos_sugeridos from w_abc
integer width = 3305
integer height = 1000
string title = "Listado de Zapatos Sugeridos"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
cb_cancel cb_cancel
cb_aceptar cb_aceptar
dw_master dw_master
end type
global w_abc_lista_zapatos_sugeridos w_abc_lista_zapatos_sugeridos

type variables
str_parametros 	istr_param
u_ds_base			ids_sugerencias
end variables

on w_abc_lista_zapatos_sugeridos.create
int iCurrent
call super::create
this.cb_cancel=create cb_cancel
this.cb_aceptar=create cb_aceptar
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_cancel
this.Control[iCurrent+2]=this.cb_aceptar
this.Control[iCurrent+3]=this.dw_master
end on

on w_abc_lista_zapatos_sugeridos.destroy
call super::destroy
destroy(this.cb_cancel)
destroy(this.cb_aceptar)
destroy(this.dw_master)
end on

event ue_cancelar;call super::ue_cancelar;str_parametros lstr_param

lstr_param.b_return = false

CloseWithReturn(this, lstr_param)
end event

event ue_aceptar;call super::ue_aceptar;str_parametros lstr_param
Long 				ll_talla_min, ll_talla_max, ll_row
String			ls_mensaje
string 			ls_cod_suela, ls_desc_suela,  ls_cod_acabado, ls_desc_acabado, &
					ls_color1, ls_Color_primario, ls_color2, ls_color_secundario, &
					ls_cod_taco, ls_desc_taco, ls_und, ls_desc_unidad, &
					ls_Cod_clase, ls_desc_clase
					
u_dw_abc			ldw_master					

//Validar la cantidad de registros con cantidad, tiene que haber puesto cantidad al menos
//en un registro
if dw_master.RowCount() = 0 then 
	MessageBox('Error', 'No hay registros de sugerencia, por favor verifique!', StopSign!)
	return
end if

if dw_master.getRow() = 0 then
	MessageBox('Error', 'No ha seleccionado ningun registro, por favor verifique!', StopSign!)
	return 
end if

ldw_master = istr_param.dw_m

ll_row = dw_master.getRow()

//Obtengo los datos necesarios para los articulos
ls_cod_suela 			= dw_master.object.cod_suela			[ll_row]
ls_desc_suela 			= dw_master.object.desc_suela			[ll_row]
ls_cod_acabado 		= dw_master.object.cod_acabado		[ll_row]
ls_desc_acabado 		= dw_master.object.desc_acabado		[ll_row]
ls_color1		 		= dw_master.object.color1				[ll_row]
ls_color_primario		= dw_master.object.color_primario	[ll_row]
ls_color2 				= dw_master.object.color2				[ll_row]
ls_color_secundario	= dw_master.object.color_secundario	[ll_row]
ls_cod_taco 			= dw_master.object.cod_taco			[ll_row]
ls_desc_taco			= dw_master.object.desc_taco			[ll_row]
ls_und					= dw_master.object.und					[ll_row]
ls_desc_unidad			= dw_master.object.desc_unidad		[ll_row]
ls_cod_clase			= dw_master.object.cod_clase			[ll_row]
ls_desc_clase			= dw_master.object.desc_clase			[ll_row]

ll_talla_min			= Long(dw_master.object.talla_min	[ll_row])
ll_talla_max			= Long(dw_master.object.talla_max	[ll_row])

//Actualizo los datos en el datawindow anterior
ldw_master.object.cod_suela			[1]  	= ls_cod_suela
ldw_master.object.desc_suela			[1]  	= ls_desc_suela
ldw_master.object.cod_acabado			[1]  	= ls_cod_acabado
ldw_master.object.desc_acabado		[1]  	= ls_desc_acabado
ldw_master.object.color1				[1]  	= ls_color1
ldw_master.object.color_primario		[1]  	= ls_color_primario
ldw_master.object.color2				[1]  	= ls_color2
ldw_master.object.color_secundario	[1]  	= ls_color_secundario
ldw_master.object.cod_taco				[1]  	= ls_cod_taco
ldw_master.object.desc_taco			[1]  	= ls_desc_taco
ldw_master.object.und					[1]  	= ls_und
ldw_master.object.desc_unidad			[1]  	= ls_desc_unidad
ldw_master.object.cod_clase			[1]  	= ls_cod_clase
ldw_master.object.desc_clase			[1]  	= ls_desc_clase
ldw_master.object.talla_min			[1]  	= ll_talla_min
ldw_master.object.talla_max			[1]  	= ll_talla_max


lstr_param.b_return = true

CloseWithReturn(this, lstr_param)
end event

event ue_open_pre;call super::ue_open_pre;

istr_param = Message.PowerObjectParm

idw_1 = dw_master              				// asignar dw corriente

dw_master.Retrieve(istr_param.string1, istr_param.string2, istr_param.string3, istr_param.string4)
end event

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - 10

end event

type cb_cancel from commandbutton within w_abc_lista_zapatos_sugeridos
integer x = 2793
integer y = 792
integer width = 402
integer height = 112
integer taborder = 30
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

type cb_aceptar from commandbutton within w_abc_lista_zapatos_sugeridos
integer x = 2368
integer y = 792
integer width = 402
integer height = 112
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aceptar"
end type

event clicked;parent.event ue_aceptar()
end event

type dw_master from u_dw_abc within w_abc_lista_zapatos_sugeridos
integer width = 3278
integer height = 784
string dataobject = "d_list_sugerencias_zapatos_tbl"
boolean hscrollbar = false
boolean vscrollbar = false
end type

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

