$PBExportHeader$w_al740_res_x_tipo_x_alm.srw
forward
global type w_al740_res_x_tipo_x_alm from w_report_smpl
end type
type uo_fechas from u_ingreso_rango_fechas_v within w_al740_res_x_tipo_x_alm
end type
type cb_3 from commandbutton within w_al740_res_x_tipo_x_alm
end type
type cbx_1 from checkbox within w_al740_res_x_tipo_x_alm
end type
type sle_almacen from singlelineedit within w_al740_res_x_tipo_x_alm
end type
type sle_descrip from singlelineedit within w_al740_res_x_tipo_x_alm
end type
type st_2 from statictext within w_al740_res_x_tipo_x_alm
end type
type gb_1 from groupbox within w_al740_res_x_tipo_x_alm
end type
type gb_2 from groupbox within w_al740_res_x_tipo_x_alm
end type
end forward

global type w_al740_res_x_tipo_x_alm from w_report_smpl
integer width = 3387
integer height = 1860
string title = "[AL740] Resumen por Tipo de Movimiento"
string menuname = "m_impresion"
uo_fechas uo_fechas
cb_3 cb_3
cbx_1 cbx_1
sle_almacen sle_almacen
sle_descrip sle_descrip
st_2 st_2
gb_1 gb_1
gb_2 gb_2
end type
global w_al740_res_x_tipo_x_alm w_al740_res_x_tipo_x_alm

type variables
Integer ii_index
end variables

on w_al740_res_x_tipo_x_alm.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.uo_fechas=create uo_fechas
this.cb_3=create cb_3
this.cbx_1=create cbx_1
this.sle_almacen=create sle_almacen
this.sle_descrip=create sle_descrip
this.st_2=create st_2
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_fechas
this.Control[iCurrent+2]=this.cb_3
this.Control[iCurrent+3]=this.cbx_1
this.Control[iCurrent+4]=this.sle_almacen
this.Control[iCurrent+5]=this.sle_descrip
this.Control[iCurrent+6]=this.st_2
this.Control[iCurrent+7]=this.gb_1
this.Control[iCurrent+8]=this.gb_2
end on

on w_al740_res_x_tipo_x_alm.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_fechas)
destroy(this.cb_3)
destroy(this.cbx_1)
destroy(this.sle_almacen)
destroy(this.sle_descrip)
destroy(this.st_2)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event ue_retrieve;call super::ue_retrieve;Date 		ld_desde, ld_hasta
String 	ls_alm

ld_desde = uo_fechas.of_get_fecha1()
ld_hasta = uo_fechas.of_get_fecha2()

SetPointer( Hourglass!)

if cbx_1.checked then
	ls_alm = '%%'
else
	ls_alm = trim(sle_almacen.text) 
end if

dw_report.visible = true
ib_preview=false
this.event ue_preview()
//dw_report.SetTransObject( sqlca)

dw_report.retrieve(ls_alm, ld_desde, ld_hasta )	
dw_report.Object.DataWindow.Print.Orientation = 1
dw_report.object.t_fecha.text 	= 'Del : ' & 
		+ STRING(LD_DESDE, "DD/MM/YYYY") + ' Al : ' &
		+ STRING(LD_HASTA, "DD/MM/YYYY")		
dw_report.object.t_almacen.text = sle_descrip.text		
dw_report.object.t_user.text 		= gs_user
dw_report.Object.p_logo.filename = gs_logo
idw_1.Object.t_empresa.text = gs_empresa
idw_1.Object.t_objeto.text = 'AL733'	

end event

type dw_report from w_report_smpl`dw_report within w_al740_res_x_tipo_x_alm
integer x = 0
integer y = 336
integer width = 3259
integer height = 1036
string dataobject = "d_rpt_mov_res_x_tipo_almacen_tbl"
end type

type uo_fechas from u_ingreso_rango_fechas_v within w_al740_res_x_tipo_x_alm
event destroy ( )
integer x = 110
integer y = 80
integer height = 212
integer taborder = 50
boolean bringtotop = true
long backcolor = 67108864
end type

on uo_fechas.destroy
call u_ingreso_rango_fechas_v::destroy
end on

event constructor;call super::constructor;String ls_desde

ls_desde = '01/' + string(month(today()))+'/' + string(year(today()))
uo_fechas.of_set_label("Desde","Hasta")
uo_fechas.of_set_fecha(date(ls_desde), today()) 				// para seatear el titulo del boton
uo_fechas.of_set_rango_inicio(DATE('01/01/1000'))
uo_fechas.of_set_rango_fin(DATE('31/12/9999'))

end event

type cb_3 from commandbutton within w_al740_res_x_tipo_x_alm
integer x = 2935
integer y = 28
integer width = 334
integer height = 84
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Reporte"
end type

event clicked;Parent.event ue_retrieve()


end event

type cbx_1 from checkbox within w_al740_res_x_tipo_x_alm
integer x = 882
integer y = 196
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
end type

event clicked;if this.checked then
	sle_almacen.enabled = false
else
	sle_almacen.enabled = true
end if
end event

type sle_almacen from singlelineedit within w_al740_res_x_tipo_x_alm
event dobleclick pbm_lbuttondblclk
integer x = 1175
integer y = 84
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

type sle_descrip from singlelineedit within w_al740_res_x_tipo_x_alm
integer x = 1403
integer y = 84
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

type st_2 from statictext within w_al740_res_x_tipo_x_alm
integer x = 869
integer y = 96
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

type gb_1 from groupbox within w_al740_res_x_tipo_x_alm
integer x = 50
integer y = 24
integer width = 745
integer height = 284
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "  Fechas  : "
end type

type gb_2 from groupbox within w_al740_res_x_tipo_x_alm
integer x = 846
integer y = 16
integer width = 1746
integer height = 300
integer taborder = 10
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
end type

