$PBExportHeader$w_cm714_art_rep_stock.srw
forward
global type w_cm714_art_rep_stock from w_rpt
end type
type cb_reporte from commandbutton within w_cm714_art_rep_stock
end type
type sle_descrip from singlelineedit within w_cm714_art_rep_stock
end type
type sle_almacen from singlelineedit within w_cm714_art_rep_stock
end type
type st_2 from statictext within w_cm714_art_rep_stock
end type
type cbx_1 from checkbox within w_cm714_art_rep_stock
end type
type dw_report from u_dw_rpt within w_cm714_art_rep_stock
end type
type gb_1 from groupbox within w_cm714_art_rep_stock
end type
end forward

global type w_cm714_art_rep_stock from w_rpt
integer x = 283
integer y = 248
integer width = 3163
integer height = 2328
string title = "[CM714] Artículo de reposición de Stock"
string menuname = "m_impresion"
long backcolor = 79741120
cb_reporte cb_reporte
sle_descrip sle_descrip
sle_almacen sle_almacen
st_2 st_2
cbx_1 cbx_1
dw_report dw_report
gb_1 gb_1
end type
global w_cm714_art_rep_stock w_cm714_art_rep_stock

type variables

end variables

on w_cm714_art_rep_stock.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.cb_reporte=create cb_reporte
this.sle_descrip=create sle_descrip
this.sle_almacen=create sle_almacen
this.st_2=create st_2
this.cbx_1=create cbx_1
this.dw_report=create dw_report
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_reporte
this.Control[iCurrent+2]=this.sle_descrip
this.Control[iCurrent+3]=this.sle_almacen
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.cbx_1
this.Control[iCurrent+6]=this.dw_report
this.Control[iCurrent+7]=this.gb_1
end on

on w_cm714_art_rep_stock.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_reporte)
destroy(this.sle_descrip)
destroy(this.sle_almacen)
destroy(this.st_2)
destroy(this.cbx_1)
destroy(this.dw_report)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;str_parametros lstr_param

idw_1 = dw_report
ii_help = 101           // help topic



end event

event ue_retrieve;call super::ue_retrieve;string	ls_almacen


if cbx_1.checked then
	ls_almacen = '%%'
else
	if trim(sle_almacen.text) = '' then
		MessageBox('Aviso', 'Debe ingresar un codigo de almacen', stopSign!)
		return
	end if
	ls_almacen = trim(sle_almacen.text) + '%'
end if


idw_1.SetTransObject(SQLCA)
idw_1.Object.p_logo.filename = gs_logo
idw_1.object.t_user.text     = gs_user
idw_1.object.t_empresa.text  = gs_empresa
idw_1.object.t_codigo.text   = dw_report.dataobject

idw_1.Retrieve(ls_almacen)

ib_preview = FALSE

event ue_preview()




end event

event resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y


end event

event ue_print();call super::ue_print;dw_report.EVENT ue_print()
end event

event ue_preview();call super::ue_preview;IF ib_preview THEN
	idw_1.Modify("DataWindow.Print.Preview=No")
	idw_1.Modify("datawindow.print.preview.zoom = " + String(idw_1.ii_zoom_actual))
	idw_1.title = "Reporte " + " (Zoom: " + String(idw_1.ii_zoom_actual) + "%)"
	SetPointer(hourglass!)
	ib_preview = FALSE
ELSE
	idw_1.Modify("DataWindow.Print.Preview=Yes")
	idw_1.Modify("datawindow.print.preview.zoom = " + String(idw_1.ii_zoom_actual))
	idw_1.title = "Reporte " + " (Zoom: " + String(idw_1.ii_zoom_actual) + "%)"
	SetPointer(hourglass!)
	ib_preview = TRUE
END IF
end event

type cb_reporte from commandbutton within w_cm714_art_rep_stock
integer x = 1774
integer y = 44
integer width = 471
integer height = 108
integer taborder = 20
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

type sle_descrip from singlelineedit within w_cm714_art_rep_stock
integer x = 567
integer y = 48
integer width = 1157
integer height = 88
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

type sle_almacen from singlelineedit within w_cm714_art_rep_stock
event dobleclick pbm_lbuttondblclk
integer x = 338
integer y = 48
integer width = 224
integer height = 88
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

type st_2 from statictext within w_cm714_art_rep_stock
integer x = 32
integer y = 60
integer width = 302
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Almacen:"
boolean focusrectangle = false
end type

type cbx_1 from checkbox within w_cm714_art_rep_stock
integer x = 46
integer y = 136
integer width = 677
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Todos los almacenes"
boolean checked = true
end type

event clicked;if this.checked then
	sle_almacen.enabled = false
else
	sle_almacen.enabled = true
end if
end event

type dw_report from u_dw_rpt within w_cm714_art_rep_stock
integer y = 276
integer width = 3049
integer height = 1256
boolean bringtotop = true
string dataobject = "d_rpt_articulos_rep_stock_tbl"
end type

type gb_1 from groupbox within w_cm714_art_rep_stock
integer width = 1746
integer height = 264
integer taborder = 10
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
end type

