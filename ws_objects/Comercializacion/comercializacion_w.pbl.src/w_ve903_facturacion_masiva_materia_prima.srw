$PBExportHeader$w_ve903_facturacion_masiva_materia_prima.srw
forward
global type w_ve903_facturacion_masiva_materia_prima from w_abc
end type
type cb_2 from commandbutton within w_ve903_facturacion_masiva_materia_prima
end type
type cb_1 from commandbutton within w_ve903_facturacion_masiva_materia_prima
end type
type uo_1 from u_ingreso_rango_fechas within w_ve903_facturacion_masiva_materia_prima
end type
type dw_master from u_dw_abc within w_ve903_facturacion_masiva_materia_prima
end type
type gb_1 from groupbox within w_ve903_facturacion_masiva_materia_prima
end type
end forward

global type w_ve903_facturacion_masiva_materia_prima from w_abc
integer width = 3328
integer height = 1564
cb_2 cb_2
cb_1 cb_1
uo_1 uo_1
dw_master dw_master
gb_1 gb_1
end type
global w_ve903_facturacion_masiva_materia_prima w_ve903_facturacion_masiva_materia_prima

on w_ve903_facturacion_masiva_materia_prima.create
int iCurrent
call super::create
this.cb_2=create cb_2
this.cb_1=create cb_1
this.uo_1=create uo_1
this.dw_master=create dw_master
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_2
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.uo_1
this.Control[iCurrent+4]=this.dw_master
this.Control[iCurrent+5]=this.gb_1
end on

on w_ve903_facturacion_masiva_materia_prima.destroy
call super::destroy
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.uo_1)
destroy(this.dw_master)
destroy(this.gb_1)
end on

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - 10
dw_master.height = newheight - dw_master.y - 10
end event

event ue_open_pre;call super::ue_open_pre;dw_master.Settransobject(sqlca)
idw_1 = dw_master  
end event

type cb_2 from commandbutton within w_ve903_facturacion_masiva_materia_prima
integer x = 2907
integer y = 164
integer width = 343
integer height = 100
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Procesar"
end type

event clicked;Long ll_inicio 

//For ll_inicio = 1 to 
//	
//Next
//
//for /*varname*/=/*start*/ to /*end*/
//	/*statementblock*/
//next

end event

type cb_1 from commandbutton within w_ve903_facturacion_masiva_materia_prima
integer x = 2907
integer y = 36
integer width = 343
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Buscar"
end type

event clicked;Date ld_fecha_inicial,ld_fecha_final

ld_fecha_inicial = uo_1.of_get_fecha1()
ld_fecha_final	  = uo_1.of_get_fecha2()



dw_master.retrieve(ld_fecha_inicial,ld_fecha_final)
end event

type uo_1 from u_ingreso_rango_fechas within w_ve903_facturacion_masiva_materia_prima
integer x = 73
integer y = 108
integer taborder = 40
end type

event constructor;call super::constructor;of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
of_set_fecha(today(), today()) //para setear la fecha inicial
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final


end event

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

type dw_master from u_dw_abc within w_ve903_facturacion_masiva_materia_prima
integer x = 23
integer y = 288
integer width = 3250
integer height = 1156
string dataobject = "d_abc_venta_materia_prima_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
	                  // 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)


ii_ck[1] = 1				// columnas de lectrua de este dw

idw_mst = dw_master

end event

type gb_1 from groupbox within w_ve903_facturacion_masiva_materia_prima
integer x = 37
integer width = 1362
integer height = 260
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Ingrese Fechas"
end type

