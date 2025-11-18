$PBExportHeader$w_al756_stock_pallet_posicion.srw
forward
global type w_al756_stock_pallet_posicion from w_report_smpl
end type
type cb_1 from commandbutton within w_al756_stock_pallet_posicion
end type
type cbx_1 from checkbox within w_al756_stock_pallet_posicion
end type
type sle_almacen from singlelineedit within w_al756_stock_pallet_posicion
end type
type sle_descrip from singlelineedit within w_al756_stock_pallet_posicion
end type
type st_2 from statictext within w_al756_stock_pallet_posicion
end type
type gb_1 from groupbox within w_al756_stock_pallet_posicion
end type
end forward

global type w_al756_stock_pallet_posicion from w_report_smpl
integer width = 3570
integer height = 1740
string title = "[AL756] Saldo por posicion, articulo y pallet"
string menuname = "m_impresion"
windowstate windowstate = maximized!
long backcolor = 79741120
cb_1 cb_1
cbx_1 cbx_1
sle_almacen sle_almacen
sle_descrip sle_descrip
st_2 st_2
gb_1 gb_1
end type
global w_al756_stock_pallet_posicion w_al756_stock_pallet_posicion

type variables

end variables

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

on w_al756_stock_pallet_posicion.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.cb_1=create cb_1
this.cbx_1=create cbx_1
this.sle_almacen=create sle_almacen
this.sle_descrip=create sle_descrip
this.st_2=create st_2
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.cbx_1
this.Control[iCurrent+3]=this.sle_almacen
this.Control[iCurrent+4]=this.sle_descrip
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.gb_1
end on

on w_al756_stock_pallet_posicion.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.cbx_1)
destroy(this.sle_almacen)
destroy(this.sle_descrip)
destroy(this.st_2)
destroy(this.gb_1)
end on

event ue_retrieve;call super::ue_retrieve;String 	ls_alm

SetPointer( Hourglass!)

if cbx_1.checked then
	ls_alm = '%%'
else
	ls_alm = trim(sle_almacen.text) + '%'
end if

dw_report.visible = true

ib_preview=true
this.event ue_preview()

dw_report.SetTransObject( sqlca)
dw_report.retrieve(ls_alm )	

	
dw_report.object.t_almacen.text = sle_descrip.text		
dw_report.object.t_user.text 		= gs_user
dw_report.Object.p_logo.filename = gs_logo

dw_report.Object.t_empresa.text = gs_empresa
dw_report.Object.t_objeto.text = dw_report.dataobject


end event

event ue_open_pre;idw_1 = dw_report
idw_1.SetTransObject(sqlca)

idw_1.Visible = False

dw_report.Object.DataWindow.Print.Orientation = 1
dw_report.Object.DataWindow.Print.Paper.Size = 8

ib_preview = true
event ue_preview()
end event

type dw_report from w_report_smpl`dw_report within w_al756_stock_pallet_posicion
integer x = 0
integer y = 304
integer width = 3378
integer height = 1236
string dataobject = "d_rpt_saldo_articulo_pallet_tbl"
end type

event dw_report::rowfocuschanged;call super::rowfocuschanged;if currentrow = 0 then return

gnvo_app.of_select_current_row(this)
end event

event dw_report::doubleclicked;call super::doubleclicked;
String 							ls_cod_art, ls_almacen, ls_nro_pallet
str_parametros					lstr_param
w_al762_consulta_detalle 	lw_1


if row = 0 then return

ls_cod_Art 		= this.object.cod_art 		[row]
ls_almacen		= this.object.almacen		[row]
ls_nro_pallet 	= this.object.nro_pallet	[row]


lstr_param.string1 = ls_cod_Art
lstr_param.string2 = ls_nro_pallet
lstr_param.string3 = ls_almacen

OpenSheetWithParm (lw_1, lstr_param, w_main, 0, layered!)


end event

type cb_1 from commandbutton within w_al756_stock_pallet_posicion
integer x = 1728
integer y = 48
integer width = 526
integer height = 108
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Generar Reporte"
end type

event clicked;Parent.Event ue_retrieve()
end event

type cbx_1 from checkbox within w_al756_stock_pallet_posicion
integer x = 329
integer y = 168
integer width = 667
integer height = 80
boolean bringtotop = true
integer textsize = -9
integer weight = 700
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

type sle_almacen from singlelineedit within w_al756_stock_pallet_posicion
event dobleclick pbm_lbuttondblclk
integer x = 329
integer y = 56
integer width = 224
integer height = 88
integer taborder = 50
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
where almacen = :ls_almacen 
  and FLAG_TIPO_ALMACEN <> 'T';

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de Almacen no existe')
	return
end if

sle_descrip.text = ls_desc

end event

type sle_descrip from singlelineedit within w_al756_stock_pallet_posicion
integer x = 558
integer y = 56
integer width = 1157
integer height = 88
integer taborder = 60
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

type st_2 from statictext within w_al756_stock_pallet_posicion
integer x = 23
integer y = 68
integer width = 302
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Almacen:"
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_al756_stock_pallet_posicion
integer width = 3305
integer height = 300
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Filtros para el reporte"
end type

