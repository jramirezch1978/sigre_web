$PBExportHeader$w_fl015_clientes.srw
forward
global type w_fl015_clientes from w_abc
end type
type cb_lectura from commandbutton within w_fl015_clientes
end type
type sle_1 from singlelineedit within w_fl015_clientes
end type
type st_1 from statictext within w_fl015_clientes
end type
type dw_master from u_dw_abc within w_fl015_clientes
end type
type dw_detail from u_dw_abc within w_fl015_clientes
end type
type gb_1 from groupbox within w_fl015_clientes
end type
end forward

global type w_fl015_clientes from w_abc
integer width = 3451
integer height = 1352
string title = "Matenimiento de Clientes (FL015)"
cb_lectura cb_lectura
sle_1 sle_1
st_1 st_1
dw_master dw_master
dw_detail dw_detail
gb_1 gb_1
end type
global w_fl015_clientes w_fl015_clientes

on w_fl015_clientes.create
int iCurrent
call super::create
this.cb_lectura=create cb_lectura
this.sle_1=create sle_1
this.st_1=create st_1
this.dw_master=create dw_master
this.dw_detail=create dw_detail
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_lectura
this.Control[iCurrent+2]=this.sle_1
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.dw_master
this.Control[iCurrent+5]=this.dw_detail
this.Control[iCurrent+6]=this.gb_1
end on

on w_fl015_clientes.destroy
call super::destroy
destroy(this.cb_lectura)
destroy(this.sle_1)
destroy(this.st_1)
destroy(this.dw_master)
destroy(this.dw_detail)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;//im_1.m_cortar.visible = false

//dw_master.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos
//dw_detail.SetTransObject(sqlca)
//dw_lista.SetTransObject(sqlca)

//idw_1 = dw_master              				// asignar dw corriente
//idw_query = dw_master								// ventana para query
//dw_detail.BorderStyle = StyleRaised!			// indicar dw_detail como no activado

//dw_master.of_protect()         		// bloquear modificaciones 
//dw_detail.of_protect()

//of_position_window(0,0)       			// Posicionar la ventana en forma fija
//ii_help = 101           					// help topic
//ii_pregunta_delete = 1   				// 1 = si pregunta, 0 = no pregunta (default)
//ii_consulta = 1                      // 1 = la lista de consulta es gobernada por el sistema de acceso
//ii_access = 1					
end event

type cb_lectura from commandbutton within w_fl015_clientes
integer x = 3013
integer y = 64
integer width = 366
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Lectura"
end type

event clicked;String ls_cliente

ls_cliente = sle_1.text
dw_master.retrieve( ls_cliente )
end event

type sle_1 from singlelineedit within w_fl015_clientes
integer x = 2592
integer y = 60
integer width = 402
integer height = 96
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_fl015_clientes
integer x = 2363
integer y = 68
integer width = 233
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Cliente:"
boolean focusrectangle = false
end type

type dw_master from u_dw_abc within w_fl015_clientes
integer x = 46
integer y = 88
integer width = 2263
integer height = 1092
integer taborder = 20
string dataobject = "d_cliente_ff"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event constructor;call super::constructor;is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_rk[1] = 1 	      // columnas que recibimos del master

idw_mst  = 	dw_master

end event

type dw_detail from u_dw_abc within w_fl015_clientes
integer x = 2766
integer y = 476
integer width = 192
string dataobject = "d_proveedor_grd"
boolean vscrollbar = true
end type

event constructor;call super::constructor;is_mastdet = 'md'		
is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_dk[1] = 1 	      // columnas que se pasan al detalle

idw_det  =  dw_detail
end event

type gb_1 from groupbox within w_fl015_clientes
integer x = 2309
integer y = 20
integer width = 1083
integer height = 220
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Busqueda"
end type

