$PBExportHeader$w_al302_ingreso_masivo.srw
forward
global type w_al302_ingreso_masivo from w_base
end type
type dw_master from u_dw_abc within w_al302_ingreso_masivo
end type
type sle_codigo from singlelineedit within w_al302_ingreso_masivo
end type
type pb_cancelar from u_pb_cancelar within w_al302_ingreso_masivo
end type
type pb_aceptar from u_pb_aceptar within w_al302_ingreso_masivo
end type
type st_1 from statictext within w_al302_ingreso_masivo
end type
type st_2 from statictext within w_al302_ingreso_masivo
end type
type st_descripcion from statictext within w_al302_ingreso_masivo
end type
type st_3 from statictext within w_al302_ingreso_masivo
end type
type em_precio from editmask within w_al302_ingreso_masivo
end type
type sle_numero_serie from singlelineedit within w_al302_ingreso_masivo
end type
type st_4 from statictext within w_al302_ingreso_masivo
end type
type cb_add from commandbutton within w_al302_ingreso_masivo
end type
type gb_1 from groupbox within w_al302_ingreso_masivo
end type
end forward

global type w_al302_ingreso_masivo from w_base
integer width = 2478
integer height = 1680
string title = "Ingreso Masivo de Artículos"
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
boolean center = true
event ue_add ( )
dw_master dw_master
sle_codigo sle_codigo
pb_cancelar pb_cancelar
pb_aceptar pb_aceptar
st_1 st_1
st_2 st_2
st_descripcion st_descripcion
st_3 st_3
em_precio em_precio
sle_numero_serie sle_numero_serie
st_4 st_4
cb_add cb_add
gb_1 gb_1
end type
global w_al302_ingreso_masivo w_al302_ingreso_masivo

type variables
u_dw_abc idw_master, idw_detail
string 	is_cod_art, is_und, is_flag_numero_serie, is_tipo
end variables

event ue_add();string 	ls_cod_art, ls_numero_serie, ls_desc_art
decimal 	ldc_precio
Long		ll_row

ls_cod_art = sle_codigo.text
ls_desc_art = st_descripcion.text
ls_numero_serie = sle_numero_serie.text

em_precio.getdata( ldc_precio )

if ls_cod_art = "" or ls_desc_art = "" then
	MessageBox("Error", "Debe seleccionar un codigo de articulo")
	sle_codigo.setFocus()
	return
end if

if IsNull(ldc_precio) or ldc_precio = 0 then
	MessageBox("Error", "Debe ingresar un precio")
	em_precio.setFocus()
	return
end if

if ls_numero_serie = "" or ls_numero_serie = "" then
	MessageBox("Error", "Debe seleccionar un numero de serie")
	sle_numero_Serie.setFocus()
	return
end if

//verifico si existe el numero de serie
ll_row =  dw_master.Find("numero_serie = '" + ls_numero_serie + "'", 1, dw_master.RowCount())

if ll_row > 0 then
	MessageBox('Error', 'Numero de serie ' + ls_numero_serie + ' ya existe....')
	dw_master.ScrollToRow(ll_row)
	dw_master.SelectRow( 0, false)
	dw_master.SelectRow( ll_row, true)
	sle_numero_serie.text = ""
	sle_numero_serie.setFocus( )
	return
end if

ll_row = dw_master.InsertRow(0)

dw_master.object.cod_art 		[ll_row] = ls_cod_art
dw_master.object.desc_art 		[ll_row] = ls_desc_art
dw_master.object.cantidad 		[ll_row] = 1
dw_master.object.precio 		[ll_row] = ldc_precio
dw_master.object.numero_serie [ll_row] = ls_numero_serie

sle_codigo.enabled = false
em_precio.enabled = true
sle_numero_serie.text = ""
sle_numero_serie.setFocus()


end event

on w_al302_ingreso_masivo.create
int iCurrent
call super::create
this.dw_master=create dw_master
this.sle_codigo=create sle_codigo
this.pb_cancelar=create pb_cancelar
this.pb_aceptar=create pb_aceptar
this.st_1=create st_1
this.st_2=create st_2
this.st_descripcion=create st_descripcion
this.st_3=create st_3
this.em_precio=create em_precio
this.sle_numero_serie=create sle_numero_serie
this.st_4=create st_4
this.cb_add=create cb_add
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_master
this.Control[iCurrent+2]=this.sle_codigo
this.Control[iCurrent+3]=this.pb_cancelar
this.Control[iCurrent+4]=this.pb_aceptar
this.Control[iCurrent+5]=this.st_1
this.Control[iCurrent+6]=this.st_2
this.Control[iCurrent+7]=this.st_descripcion
this.Control[iCurrent+8]=this.st_3
this.Control[iCurrent+9]=this.em_precio
this.Control[iCurrent+10]=this.sle_numero_serie
this.Control[iCurrent+11]=this.st_4
this.Control[iCurrent+12]=this.cb_add
this.Control[iCurrent+13]=this.gb_1
end on

on w_al302_ingreso_masivo.destroy
call super::destroy
destroy(this.dw_master)
destroy(this.sle_codigo)
destroy(this.pb_cancelar)
destroy(this.pb_aceptar)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.st_descripcion)
destroy(this.st_3)
destroy(this.em_precio)
destroy(this.sle_numero_serie)
destroy(this.st_4)
destroy(this.cb_add)
destroy(this.gb_1)
end on

event open;call super::open;str_parametros  lstr_param

if IsNull(Message.PowerObjectParm) or Not IsValid(Message.PowerObjectParm) then
	MessageBox('Error', 'Esta ventana debe recibir parametros')
	this.Post event close( )
	return
end if

if Message.PowerObjectParm.ClassName() <> 'str_parametros' then
	MessageBox('Error', 'Parametros invalidos')
	this.Post event close( )
	return
end if

lstr_param = Message.PowerObjectParm
idw_master = lstr_param.dw_m
idw_detail = lstr_param.dw_d
is_tipo	  = lstr_param.tipo
end event

type p_pie from w_base`p_pie within w_al302_ingreso_masivo
end type

type ole_skin from w_base`ole_skin within w_al302_ingreso_masivo
end type

type dw_master from u_dw_abc within w_al302_ingreso_masivo
integer y = 588
integer width = 2441
integer height = 732
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_abc_art_numero_serie_tbl"
boolean vscrollbar = true
end type

event buttonclicked;call super::buttonclicked;if lower(dwo.name) = 'b_eliminar' then
	deleterow( row )
end if
end event

event constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw

end event

type sle_codigo from singlelineedit within w_al302_ingreso_masivo
event dobleclick pbm_lbuttondblclk
integer x = 402
integer y = 60
integer width = 645
integer height = 84
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string pointer = "C:\SIGRE\resources\cur\taladro.cur"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event dobleclick;str_parametros lstr_param
string 	ls_cod_Art, ls_almacen
decimal	ldc_precio

if is_tipo = 'T' then
	ls_almacen = idw_master.object.almacen_org[idw_master.getRow()]
else
	ls_almacen = idw_master.object.almacen		[idw_master.getRow()]
end if
		
lstr_param.almacen = ls_almacen

OpenWithParm (w_pop_articulos, lstr_param)
lstr_param = MESSAGE.POWEROBJECTPARM
IF lstr_param.titulo <> 'n' then
	ls_cod_art = 		lstr_param.field_ret[1]
	
	//Obtengo el costo promedio
	select COSTO_PROM_SOL
	  into :ldc_precio
	  from articulo_almacen aa
	 where aa.cod_art = :ls_cod_art
		and aa.almacen = :ls_almacen;
	
	this.text				= ls_cod_art
	st_descripcion.text	= lstr_param.field_ret[2]
	is_und					= lstr_param.field_ret[3]
	is_flag_numero_serie	= lstr_param.field_ret[8]
	sle_numero_serie.text= lstr_param.field_ret[7]	
	em_precio.text			= string(ldc_precio, '###,##0.0000')
	
	sle_numero_serie.setFocus( )

END IF
end event

type pb_cancelar from u_pb_cancelar within w_al302_ingreso_masivo
integer x = 1317
integer y = 1352
integer taborder = 30
boolean bringtotop = true
boolean originalsize = false
end type

event clicked;call super::clicked;str_Parametros lstr_param

lstr_param.titulo = 'n'

CloseWithReturn(parent, lstr_param)
end event

type pb_aceptar from u_pb_aceptar within w_al302_ingreso_masivo
integer x = 873
integer y = 1348
integer taborder = 40
boolean bringtotop = true
boolean default = false
end type

event clicked;call super::clicked;long 		ll_row_new, ll_row
integer 	li_garantia
string 	ls_cod_art, ls_codigo_serie, ls_mon_vta
decimal	ldc_precio_vta
str_parametros lstr_param

for ll_row = 1 to dw_master.RowCount()
	ll_row_new = idw_detail.event ue_insert( )

	if ll_row_new > 0 then
		ls_cod_art = dw_master.object.cod_art 		[ll_row]		

		idw_detail.object.cod_art 				[ll_row_new] = ls_Cod_art
		idw_detail.object.desc_art 			[ll_row_new] = dw_master.object.desc_art 		[ll_row]
		idw_detail.object.cant_procesada		[ll_row_new] = dw_master.object.cantidad 		[ll_row]
		idw_detail.object.precio_unit			[ll_row_new] = dw_master.object.precio 		[ll_row]
		idw_detail.object.numero_serie		[ll_row_new] = dw_master.object.numero_serie	[ll_row]
		idw_detail.object.und 					[ll_row_new] = is_und
		idw_detail.object.flag_numero_serie [ll_row_new] = is_flag_numero_serie
		
		
		//Obtengo la garantía por defecto del articulo
		select 	garantia_cliente, CODIGO_SERIE, PRECIO_VENTA, 
					MONEDA_VTA
		  into :li_garantia, :ls_codigo_serie, :ldc_precio_vta, 
		  			:ls_mon_vta
		  from articulo a
		 where a.cod_art = :ls_cod_art;
		 
		idw_detail.object.garantia_cliente 	[ll_row_new] = li_garantia
		idw_detail.object.codigo 				[ll_row_new] = ls_codigo_serie
		idw_detail.object.precio_venta 		[ll_row_new] = ldc_precio_vta
		idw_detail.object.MONEDA_VTA 			[ll_row_new] = ls_mon_vta
	else
		return
	end if
next

lstr_param.titulo = 's'
CloseWithReturn(parent, lstr_param)




end event

type st_1 from statictext within w_al302_ingreso_masivo
integer x = 50
integer y = 68
integer width = 343
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
string text = "Código/Marca"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_2 from statictext within w_al302_ingreso_masivo
integer x = 50
integer y = 168
integer width = 343
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
string text = "Descripción:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_descripcion from statictext within w_al302_ingreso_masivo
integer x = 402
integer y = 160
integer width = 1801
integer height = 168
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type st_3 from statictext within w_al302_ingreso_masivo
integer x = 50
integer y = 344
integer width = 343
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
string text = "Precio:"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_precio from editmask within w_al302_ingreso_masivo
integer x = 402
integer y = 344
integer width = 645
integer height = 84
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
string text = "none"
alignment alignment = right!
borderstyle borderstyle = stylelowered!
end type

event modified;sle_numero_serie.setFocus( )
end event

type sle_numero_serie from singlelineedit within w_al302_ingreso_masivo
integer x = 407
integer y = 444
integer width = 960
integer height = 84
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

event modified;parent.event ue_add( )
end event

type st_4 from statictext within w_al302_ingreso_masivo
integer x = 46
integer y = 452
integer width = 343
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
string text = "Numero Serie:"
alignment alignment = right!
boolean focusrectangle = false
end type

type cb_add from commandbutton within w_al302_ingreso_masivo
integer x = 1440
integer y = 436
integer width = 731
integer height = 92
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Añadir"
end type

event clicked;parent.event ue_add( )
end event

type gb_1 from groupbox within w_al302_ingreso_masivo
integer width = 2432
integer height = 588
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
string text = "Artículo"
end type

