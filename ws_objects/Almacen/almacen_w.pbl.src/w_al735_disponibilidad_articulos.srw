$PBExportHeader$w_al735_disponibilidad_articulos.srw
forward
global type w_al735_disponibilidad_articulos from w_report_smpl
end type
type cb_1 from commandbutton within w_al735_disponibilidad_articulos
end type
type sle_almacen from singlelineedit within w_al735_disponibilidad_articulos
end type
type sle_descrip from singlelineedit within w_al735_disponibilidad_articulos
end type
type st_2 from statictext within w_al735_disponibilidad_articulos
end type
type cbx_1 from checkbox within w_al735_disponibilidad_articulos
end type
type st_1 from statictext within w_al735_disponibilidad_articulos
end type
type sle_categoria from singlelineedit within w_al735_disponibilidad_articulos
end type
type sle_desc_categoria from singlelineedit within w_al735_disponibilidad_articulos
end type
type cbx_2 from checkbox within w_al735_disponibilidad_articulos
end type
type gb_1 from groupbox within w_al735_disponibilidad_articulos
end type
end forward

global type w_al735_disponibilidad_articulos from w_report_smpl
integer width = 3890
integer height = 1740
string title = "[AL735] Disponibilidad de Artículos"
string menuname = "m_impresion"
windowstate windowstate = maximized!
long backcolor = 79741120
cb_1 cb_1
sle_almacen sle_almacen
sle_descrip sle_descrip
st_2 st_2
cbx_1 cbx_1
st_1 st_1
sle_categoria sle_categoria
sle_desc_categoria sle_desc_categoria
cbx_2 cbx_2
gb_1 gb_1
end type
global w_al735_disponibilidad_articulos w_al735_disponibilidad_articulos

type variables
string is_clase, is_almacen
integer ii_opc2, ii_opc1
date id_fecha1, id_fecha2
end variables

forward prototypes
public subroutine of_procesar ()
end prototypes

public subroutine of_procesar ();

end subroutine

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

on w_al735_disponibilidad_articulos.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.cb_1=create cb_1
this.sle_almacen=create sle_almacen
this.sle_descrip=create sle_descrip
this.st_2=create st_2
this.cbx_1=create cbx_1
this.st_1=create st_1
this.sle_categoria=create sle_categoria
this.sle_desc_categoria=create sle_desc_categoria
this.cbx_2=create cbx_2
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.sle_almacen
this.Control[iCurrent+3]=this.sle_descrip
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.cbx_1
this.Control[iCurrent+6]=this.st_1
this.Control[iCurrent+7]=this.sle_categoria
this.Control[iCurrent+8]=this.sle_desc_categoria
this.Control[iCurrent+9]=this.cbx_2
this.Control[iCurrent+10]=this.gb_1
end on

on w_al735_disponibilidad_articulos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.sle_almacen)
destroy(this.sle_descrip)
destroy(this.st_2)
destroy(this.cbx_1)
destroy(this.st_1)
destroy(this.sle_categoria)
destroy(this.sle_desc_categoria)
destroy(this.cbx_2)
destroy(this.gb_1)
end on

event ue_retrieve;call super::ue_retrieve;string	ls_mensaje,  ls_cat_art, ls_almacen

if cbx_1.checked then
	ls_almacen = '%%'
else
	if trim(sle_almacen.text) = '' then
		MessageBox('Aviso', 'Debe ingresar un codigo de almacen')
		return
	end if
	ls_almacen = trim(sle_almacen.text) + '%'
end if

if cbx_2.checked then
	ls_cat_art = '%%'
else
	if trim(sle_categoria.text) = '' then
		MessageBox('Aviso', 'Debe ingresar un codigo de categoria', StopSign!)
		return
	end if
	ls_cat_art = trim(sle_categoria.text) + '%'
end if

ib_preview=true
this.event ue_preview()

dw_report.visible = true
dw_report.SetTransObject( sqlca)
dw_report.retrieve(ls_almacen, ls_cat_art)

//dw_report.Object.DataWindow.Print.Orientation = 1


	

end event

event ue_open_pre;call super::ue_open_pre;dw_report.Object.DataWindow.Print.Orientation = 1
end event

type dw_report from w_report_smpl`dw_report within w_al735_disponibilidad_articulos
integer y = 300
integer width = 3753
integer height = 988
string dataobject = "d_rpt_disponibilidad_articulos_tbl"
end type

type cb_1 from commandbutton within w_al735_disponibilidad_articulos
integer x = 2057
integer y = 52
integer width = 466
integer height = 212
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "&Genera Reporte"
end type

event clicked;SetPointer(HourGlass!)
Parent.Event ue_retrieve()
SetPointer(Arrow!)
end event

type sle_almacen from singlelineedit within w_al735_disponibilidad_articulos
event dobleclick pbm_lbuttondblclk
integer x = 343
integer y = 68
integer width = 224
integer height = 88
integer taborder = 60
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
	    + "FROM almacen " 
				 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
if ls_codigo <> '' then
	this.text 			= ls_codigo
	sle_descrip.text 	= ls_data
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
where almacen = :ls_almacen ;

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de Almacen no existe')
	return
end if

sle_descrip.text = ls_desc

end event

type sle_descrip from singlelineedit within w_al735_disponibilidad_articulos
integer x = 571
integer y = 68
integer width = 1157
integer height = 88
integer taborder = 70
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

type st_2 from statictext within w_al735_disponibilidad_articulos
integer x = 18
integer y = 80
integer width = 311
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Almacen :"
alignment alignment = right!
boolean focusrectangle = false
end type

type cbx_1 from checkbox within w_al735_disponibilidad_articulos
integer x = 1746
integer y = 72
integer width = 256
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Todos"
boolean checked = true
end type

event clicked;if this.checked then
	sle_almacen.enabled = false
else
	sle_almacen.enabled = true
end if
end event

type st_1 from statictext within w_al735_disponibilidad_articulos
integer x = 18
integer y = 180
integer width = 311
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Categorias :"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_categoria from singlelineedit within w_al735_disponibilidad_articulos
event dobleclick pbm_lbuttondblclk
integer x = 343
integer y = 168
integer width = 224
integer height = 88
integer taborder = 70
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

ls_sql = "select cat_art as codigo_categoria, " &
		 + "desc_categoria as descripcion_categoria " &
		 + "from articulo_categ " 
				 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
if ls_codigo <> '' then
	this.text 					= ls_codigo
	sle_desc_categoria.text = ls_data
end if

end event

event modified;String ls_codigo, ls_desc

ls_codigo = this.text

if trim(ls_codigo) = '' or IsNull(ls_codigo) then
	MessageBox('Aviso', 'Debe Ingresar una Categoría de Artículo, por favor verifique!', StopSign!)
	this.setFocus()
	return
end if
		 
select desc_categoria
	into :ls_desc
from articulo_categ 
where cat_art = :ls_codigo;

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de Categoría no Existe, por favor verifique', StopSign!)
	this.text = ''
	sle_desc_categoria.text = ''
	this.setFocus()
	return
end if

sle_desc_categoria.text = ls_desc

end event

type sle_desc_categoria from singlelineedit within w_al735_disponibilidad_articulos
integer x = 571
integer y = 168
integer width = 1157
integer height = 88
integer taborder = 70
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

type cbx_2 from checkbox within w_al735_disponibilidad_articulos
integer x = 1746
integer y = 172
integer width = 256
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Todos"
boolean checked = true
end type

event clicked;if this.checked then
	sle_categoria.enabled = false
else
	sle_categoria.enabled = true
end if
end event

type gb_1 from groupbox within w_al735_disponibilidad_articulos
integer width = 2043
integer height = 284
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
end type

