$PBExportHeader$w_al712_de_inventario_x_conteo.srw
forward
global type w_al712_de_inventario_x_conteo from w_report_smpl
end type
type cb_1 from commandbutton within w_al712_de_inventario_x_conteo
end type
type sle_almacen from singlelineedit within w_al712_de_inventario_x_conteo
end type
type sle_descrip from singlelineedit within w_al712_de_inventario_x_conteo
end type
type st_1 from statictext within w_al712_de_inventario_x_conteo
end type
type st_2 from statictext within w_al712_de_inventario_x_conteo
end type
type sle_conteo from singlelineedit within w_al712_de_inventario_x_conteo
end type
type dp_fecha from datepicker within w_al712_de_inventario_x_conteo
end type
type st_3 from statictext within w_al712_de_inventario_x_conteo
end type
end forward

global type w_al712_de_inventario_x_conteo from w_report_smpl
integer width = 3877
integer height = 3100
string title = "Reprote de Inventarios x Conteo  (AL712)"
string menuname = "m_impresion"
long backcolor = 79741120
cb_1 cb_1
sle_almacen sle_almacen
sle_descrip sle_descrip
st_1 st_1
st_2 st_2
sle_conteo sle_conteo
dp_fecha dp_fecha
st_3 st_3
end type
global w_al712_de_inventario_x_conteo w_al712_de_inventario_x_conteo

on w_al712_de_inventario_x_conteo.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.cb_1=create cb_1
this.sle_almacen=create sle_almacen
this.sle_descrip=create sle_descrip
this.st_1=create st_1
this.st_2=create st_2
this.sle_conteo=create sle_conteo
this.dp_fecha=create dp_fecha
this.st_3=create st_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.sle_almacen
this.Control[iCurrent+3]=this.sle_descrip
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.sle_conteo
this.Control[iCurrent+7]=this.dp_fecha
this.Control[iCurrent+8]=this.st_3
end on

on w_al712_de_inventario_x_conteo.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.sle_almacen)
destroy(this.sle_descrip)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.sle_conteo)
destroy(this.dp_fecha)
destroy(this.st_3)
end on

event ue_retrieve;call super::ue_retrieve;Long   	ll_conteo
string	ls_almacen
Date		ld_Fec_conteo

ll_conteo = Long(sle_conteo.text)
ls_almacen = sle_almacen.text
ld_fec_conteo = Date(dp_fecha.value)

if ll_conteo = 0 or IsNull(ll_conteo) then 
	MessageBox('Aviso', 'Debe indicar un nro de conteo')
	sle_conteo.SetFocus()
	return
end if

if ls_almacen = '' then
	MessageBox('Aviso', 'Debe indicar un almacen')
	sle_almacen.SetFocus()
	return
end if

dw_report.object.datawindow.Print.Orientation = 1
idw_1.Retrieve(ls_almacen, ll_conteo, ld_fec_conteo)
idw_1.Object.p_logo.filename = gs_logo
end event

event ue_open_pre;call super::ue_open_pre;ib_preview = true

event ue_preview()
end event

type dw_report from w_report_smpl`dw_report within w_al712_de_inventario_x_conteo
integer x = 0
integer y = 216
integer width = 2610
integer height = 1132
integer taborder = 10
string dataobject = "d_rpt_inventario_x_conteo"
end type

type cb_1 from commandbutton within w_al712_de_inventario_x_conteo
integer x = 2181
integer y = 28
integer width = 526
integer height = 104
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

event clicked;Parent.TriggerEvent('ue_retrieve')
end event

type sle_almacen from singlelineedit within w_al712_de_inventario_x_conteo
event dobleclick pbm_lbuttondblclk
integer x = 384
integer y = 20
integer width = 224
integer height = 88
integer taborder = 100
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "C:\SIGRE\resources\cur\taladro.cur"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT distinct a.almacen AS CODIGO_almacen, " &
	  	 + "a.DESC_almacen AS DESCRIPCION_almacen " &
	    + "FROM almacen a, " &
		 + "inventario_conteo ic " &
		 + "where ic.almacen = a.almacen " 
				 
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

type sle_descrip from singlelineedit within w_al712_de_inventario_x_conteo
integer x = 613
integer y = 20
integer width = 1554
integer height = 88
integer taborder = 110
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

type st_1 from statictext within w_al712_de_inventario_x_conteo
integer x = 27
integer y = 36
integer width = 343
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 79741120
string text = "Almacen: "
alignment alignment = right!
boolean focusrectangle = false
end type

type st_2 from statictext within w_al712_de_inventario_x_conteo
integer x = 27
integer y = 124
integer width = 343
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 79741120
string text = "Nro Conteo"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_conteo from singlelineedit within w_al712_de_inventario_x_conteo
event dobleclick pbm_lbuttondblclk
integer x = 384
integer y = 108
integer width = 224
integer height = 88
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "C:\SIGRE\resources\cur\taladro.cur"
long textcolor = 33554432
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql, ls_almacen

ls_almacen = trim(sle_almacen.text)

if ls_almacen = '' then
	MessageBox('Aviso', 'Debe indicar un almacen')
	sle_almacen.SetFocus()
	return
end if

ls_sql = "SELECT distinct to_char(nro_conteo) AS numero_conteo, " &
	  	 + "to_char(fec_conteo, 'dd/mm/yyyy') AS fecha_conteo " &
	    + "FROM inventario_conteo " &
		 + "where almacen = '" + ls_almacen + "'"
				 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
if ls_codigo <> '' then
	this.text 		= ls_codigo
	dp_Fecha.Value = dateTime(Date(ls_data), now())
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
Parent.event dynamic ue_seleccionar()

end event

type dp_fecha from datepicker within w_al712_de_inventario_x_conteo
integer x = 1719
integer y = 108
integer width = 439
integer height = 88
integer taborder = 90
boolean bringtotop = true
boolean allowedit = true
boolean dropdownright = true
string customformat = "dd/mm/yyyy"
date maxdate = Date("2999-12-31")
date mindate = Date("1800-01-01")
datetime value = DateTime(Date("2013-12-19"), Time("11:15:55.000000"))
integer textsize = -8
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
integer calendarfontweight = 400
boolean todaysection = true
boolean todaycircle = true
end type

type st_3 from statictext within w_al712_de_inventario_x_conteo
integer x = 1307
integer y = 120
integer width = 379
integer height = 64
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Fecha Conteo:"
boolean focusrectangle = false
end type

