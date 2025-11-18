$PBExportHeader$w_al748_formatos_inv.srw
forward
global type w_al748_formatos_inv from w_report_smpl
end type
type cb_1 from commandbutton within w_al748_formatos_inv
end type
type cbx_1 from checkbox within w_al748_formatos_inv
end type
type sle_almacen from singlelineedit within w_al748_formatos_inv
end type
type sle_descrip from singlelineedit within w_al748_formatos_inv
end type
type st_2 from statictext within w_al748_formatos_inv
end type
type uo_fecha from u_ingreso_fecha within w_al748_formatos_inv
end type
type gb_1 from groupbox within w_al748_formatos_inv
end type
end forward

global type w_al748_formatos_inv from w_report_smpl
integer width = 3570
integer height = 1740
string title = "[AL748] Formatos de Inventario"
string menuname = "m_impresion"
windowstate windowstate = maximized!
long backcolor = 79741120
cb_1 cb_1
cbx_1 cbx_1
sle_almacen sle_almacen
sle_descrip sle_descrip
st_2 st_2
uo_fecha uo_fecha
gb_1 gb_1
end type
global w_al748_formatos_inv w_al748_formatos_inv

type variables

end variables

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

on w_al748_formatos_inv.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.cb_1=create cb_1
this.cbx_1=create cbx_1
this.sle_almacen=create sle_almacen
this.sle_descrip=create sle_descrip
this.st_2=create st_2
this.uo_fecha=create uo_fecha
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.cbx_1
this.Control[iCurrent+3]=this.sle_almacen
this.Control[iCurrent+4]=this.sle_descrip
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.uo_fecha
this.Control[iCurrent+7]=this.gb_1
end on

on w_al748_formatos_inv.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.cbx_1)
destroy(this.sle_almacen)
destroy(this.sle_descrip)
destroy(this.st_2)
destroy(this.uo_fecha)
destroy(this.gb_1)
end on

event ue_retrieve;call super::ue_retrieve;Date 		ld_hasta
String 	ls_alm

try 
	SetPointer( Hourglass!)
	
	ld_hasta = uo_fecha.of_get_fecha()
	
	if cbx_1.checked then
		ls_alm = '%%'
	else
		ls_alm = trim(sle_almacen.text) + '%'
	end if
	
	dw_report.visible = true
	ib_preview=false
	this.event ue_preview()
	
	dw_report.object.datawindow.Print.Orientation = 2
	dw_report.Object.DataWindow.Print.Paper.Size = 256 
	dw_report.Object.DataWindow.Print.CustomPage.Width = 220
	dw_report.Object.DataWindow.Print.CustomPage.Length = 93

	dw_report.SetTransObject( sqlca)
	dw_report.retrieve(ls_alm, ld_hasta)	
	dw_report.object.t_fecha1.text 	= STRING(LD_HASTA, "DD/MM/YYYY")		
	dw_report.object.t_fecha2.text 	= STRING(LD_HASTA, "DD/MM/YYYY")		
	//dw_report.object.t_user.text 		= gs_user
	//dw_report.Object.p_logo.filename = gs_logo


catch ( Exception ex )
	MessageBox('Error', 'Ha ocurrido una excepción: ' + ex.getMessage())
finally
	SetPointer( Arrow!)
end try
	

end event

event ue_open_pre;call super::ue_open_pre;uo_fecha.of_set_fecha( date(gnvo_app.of_fecha_actual()))
end event

type dw_report from w_report_smpl`dw_report within w_al748_formatos_inv
integer x = 0
integer y = 252
integer width = 3035
integer height = 1092
string dataobject = "d_rpt_ficha_toma_inven_ff"
end type

type cb_1 from commandbutton within w_al748_formatos_inv
integer x = 2501
integer y = 32
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
string text = "Genera Reporte"
end type

event clicked;Parent.Event ue_retrieve()
end event

type cbx_1 from checkbox within w_al748_formatos_inv
integer x = 1079
integer y = 156
integer width = 951
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
end type

event clicked;if this.checked then
	sle_almacen.enabled = false
else
	sle_almacen.enabled = true
end if
end event

type sle_almacen from singlelineedit within w_al748_formatos_inv
event dobleclick pbm_lbuttondblclk
integer x = 1074
integer y = 60
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

type sle_descrip from singlelineedit within w_al748_formatos_inv
integer x = 1303
integer y = 60
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

type st_2 from statictext within w_al748_formatos_inv
integer x = 768
integer y = 72
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

type uo_fecha from u_ingreso_fecha within w_al748_formatos_inv
event destroy ( )
integer x = 69
integer y = 64
integer taborder = 60
boolean bringtotop = true
end type

on uo_fecha.destroy
call u_ingreso_fecha::destroy
end on

event constructor;call super::constructor;of_set_label('Desde:') // para seatear el titulo del boton
of_set_fecha(date('31/12/9999')) //para setear la fecha inicial
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final
// of_get_fecha()  para leer las fechas
end event

type gb_1 from groupbox within w_al748_formatos_inv
integer width = 2482
integer height = 244
integer taborder = 50
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
end type

