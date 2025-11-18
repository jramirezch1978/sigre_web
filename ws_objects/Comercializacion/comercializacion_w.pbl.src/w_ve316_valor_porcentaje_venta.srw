$PBExportHeader$w_ve316_valor_porcentaje_venta.srw
forward
global type w_ve316_valor_porcentaje_venta from w_abc_master
end type
type sle_codigo from singlelineedit within w_ve316_valor_porcentaje_venta
end type
type st_descripcion from statictext within w_ve316_valor_porcentaje_venta
end type
type pb_1 from picturebutton within w_ve316_valor_porcentaje_venta
end type
type gb_1 from groupbox within w_ve316_valor_porcentaje_venta
end type
end forward

global type w_ve316_valor_porcentaje_venta from w_abc_master
integer width = 2583
integer height = 1836
string title = "[VE316] VALOR/PORCENTAJE VENTA"
string menuname = "m_modificar_grabar"
event ue_retrieve ( string as_codigo )
sle_codigo sle_codigo
st_descripcion st_descripcion
pb_1 pb_1
gb_1 gb_1
end type
global w_ve316_valor_porcentaje_venta w_ve316_valor_porcentaje_venta

event ue_retrieve(string as_codigo);// Recupera los articulos por almacen
dw_master.Retrieve(as_codigo)

end event

on w_ve316_valor_porcentaje_venta.create
int iCurrent
call super::create
if this.MenuName = "m_modificar_grabar" then this.MenuID = create m_modificar_grabar
this.sle_codigo=create sle_codigo
this.st_descripcion=create st_descripcion
this.pb_1=create pb_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_codigo
this.Control[iCurrent+2]=this.st_descripcion
this.Control[iCurrent+3]=this.pb_1
this.Control[iCurrent+4]=this.gb_1
end on

on w_ve316_valor_porcentaje_venta.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_codigo)
destroy(this.st_descripcion)
destroy(this.pb_1)
destroy(this.gb_1)
end on

type dw_master from w_abc_master`dw_master within w_ve316_valor_porcentaje_venta
integer x = 23
integer y = 304
integer width = 2501
integer height = 1332
string dataobject = "d_abc_valor_porcentaje_venta_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_master::constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2

end event

type sle_codigo from singlelineedit within w_ve316_valor_porcentaje_venta
event dobleclick pbm_lbuttondblclk
integer x = 91
integer y = 120
integer width = 283
integer height = 88
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long textcolor = 33554432
textcase textcase = upper!
integer limit = 6
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT  DISTINCT a.almacen AS COD_ALMACEN, " &
			+ "a.desc_almacen AS DESC_ALMACEN " &
			+ "FROM    almacen  a, " &
			+ "articulo_almacen aa " &
			+ "WHERE   a.almacen = aa.almacen " &
			+ " AND  a.flag_estado = '1' " 
				  
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
	
if ls_codigo <> '' then
	this.text 				= ls_codigo
	st_descripcion.text = ls_data
end if

end event

event modified;String 	ls_codigo, ls_desc

ls_codigo = sle_codigo.text
IF ls_codigo = '' OR IsNull(ls_codigo) THEN
	MessageBox('Aviso', 'Debe Ingresar un codigo de Almacen')
	RETURN
END IF

SELECT  DISTINCT a.desc_almacen
  INTO  :ls_desc
FROM    almacen          a,
        articulo_almacen aa
WHERE   a.almacen = aa.almacen
   AND  a.flag_estado = '1'
	AND  a.almacen = :ls_codigo;

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de Almacen no existe')
	st_descripcion.text = ''
	THIS.text			  = ''
	RETURN
END IF

st_descripcion.text = ls_desc

end event

type st_descripcion from statictext within w_ve316_valor_porcentaje_venta
integer x = 389
integer y = 120
integer width = 1317
integer height = 88
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 134217739
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type pb_1 from picturebutton within w_ve316_valor_porcentaje_venta
integer x = 2130
integer y = 72
integer width = 315
integer height = 180
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean originalsize = true
string picturename = "H:\source\BMP\Aceptar.bmp"
alignment htextalign = left!
end type

event clicked;//llama al ue_retrieve de la ventana

String	ls_codigo


ls_codigo = sle_codigo.text

IF ls_codigo = '' OR IsNull(ls_codigo) THEN
	MessageBox('Aviso', 'Debe Ingresar un codigo de Almacen')
	RETURN
END IF

Parent.Event ue_retrieve(ls_codigo)




end event

type gb_1 from groupbox within w_ve316_valor_porcentaje_venta
integer x = 37
integer y = 40
integer width = 1723
integer height = 232
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Almacen "
end type

