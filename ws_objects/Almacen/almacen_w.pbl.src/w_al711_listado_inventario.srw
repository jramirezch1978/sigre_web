$PBExportHeader$w_al711_listado_inventario.srw
forward
global type w_al711_listado_inventario from w_report_smpl
end type
type st_1 from statictext within w_al711_listado_inventario
end type
type cb_1 from commandbutton within w_al711_listado_inventario
end type
type sle_almacen from singlelineedit within w_al711_listado_inventario
end type
type sle_descrip from singlelineedit within w_al711_listado_inventario
end type
type cbx_todos from checkbox within w_al711_listado_inventario
end type
type gb_1 from groupbox within w_al711_listado_inventario
end type
end forward

global type w_al711_listado_inventario from w_report_smpl
integer width = 3657
integer height = 2020
string title = "[AL711] Listado de inventario"
string menuname = "m_impresion"
st_1 st_1
cb_1 cb_1
sle_almacen sle_almacen
sle_descrip sle_descrip
cbx_todos cbx_todos
gb_1 gb_1
end type
global w_al711_listado_inventario w_al711_listado_inventario

type variables
Integer ii_index
end variables

on w_al711_listado_inventario.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.st_1=create st_1
this.cb_1=create cb_1
this.sle_almacen=create sle_almacen
this.sle_descrip=create sle_descrip
this.cbx_todos=create cbx_todos
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.sle_almacen
this.Control[iCurrent+4]=this.sle_descrip
this.Control[iCurrent+5]=this.cbx_todos
this.Control[iCurrent+6]=this.gb_1
end on

on w_al711_listado_inventario.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.cb_1)
destroy(this.sle_almacen)
destroy(this.sle_descrip)
destroy(this.cbx_todos)
destroy(this.gb_1)
end on

event ue_retrieve;call super::ue_retrieve;String ls_almacen, ls_Desc_almacen

if cbx_todos.checked then
	ls_almacen = '%%'
else
	if trim(sle_almacen.text) = '' then
		Messagebox('Aviso','Debe Seleccionar Almacen', StopSign!)
		sle_almacen.setFocus()
		Return
	end if
	
	ls_almacen = trim(sle_almacen.text) + '%'

end if


idw_1.SetTransObject(sqlca)
idw_1.Retrieve(ls_almacen)


idw_1.Object.p_logo.filename = gs_logo


end event

type dw_report from w_report_smpl`dw_report within w_al711_listado_inventario
integer x = 0
integer y = 288
integer width = 2610
integer height = 996
integer taborder = 10
string dataobject = "d_rpt_formato_de_inventarios_x_alm_x_ubi"
end type

type st_1 from statictext within w_al711_listado_inventario
integer x = 27
integer y = 64
integer width = 229
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Almacen :"
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_al711_listado_inventario
integer x = 1719
integer y = 56
integer width = 256
integer height = 92
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "&Visualizar"
end type

event clicked;Parent.event ue_retrieve()
end event

type sle_almacen from singlelineedit within w_al711_listado_inventario
event dobleclick pbm_lbuttondblclk
integer x = 261
integer y = 64
integer width = 224
integer height = 76
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long textcolor = 33554432
boolean enabled = false
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT almacen AS CODIGO_almacen, " &
	  	 + "DESC_almacen AS DESCRIPCION_almacen " &
	    + "FROM almacen " &
		 + "where flag_tipo_almacen <> 'O'"
				 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
if ls_codigo <> '' then
	this.text 			= ls_codigo
	sle_descrip.text 	= ls_data
	Parent.event dynamic ue_seleccionar()
end if

end event

event modified;String 	ls_almacen, ls_desc

ls_almacen = sle_almacen.text
if ls_almacen = '' or IsNull(ls_almacen) then
	MessageBox('Aviso', 'Debe Ingresar un codigo de almacen')
	return
end if

SELECT desc_almacen 
	INTO :ls_desc
FROM almacen 
where almacen = :ls_almacen 
  and flag_tipo_almacen <> 'O';

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de Almacen no existe o es un almacén de tránsito')
	return
end if

sle_descrip.text = ls_desc
Parent.event dynamic ue_seleccionar()


end event

type sle_descrip from singlelineedit within w_al711_listado_inventario
integer x = 489
integer y = 64
integer width = 1211
integer height = 76
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
textcase textcase = upper!
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type cbx_todos from checkbox within w_al711_listado_inventario
integer x = 27
integer y = 152
integer width = 581
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Todos los almacenes"
boolean checked = true
end type

event clicked;if cbx_todos.checked then
	sle_almacen.enabled = false
else
	sle_almacen.enabled = true
end if

end event

type gb_1 from groupbox within w_al711_listado_inventario
integer width = 2441
integer height = 256
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 255
long backcolor = 67108864
string text = "Parámetros"
end type

