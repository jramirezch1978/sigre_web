$PBExportHeader$w_al704_movimiento_almacen.srw
forward
global type w_al704_movimiento_almacen from w_report_smpl
end type
type gb_1 from groupbox within w_al704_movimiento_almacen
end type
type uo_fechas from u_ingreso_rango_fechas_v within w_al704_movimiento_almacen
end type
type cb_3 from commandbutton within w_al704_movimiento_almacen
end type
type cbx_almacen from checkbox within w_al704_movimiento_almacen
end type
type sle_almacen from singlelineedit within w_al704_movimiento_almacen
end type
type sle_descrip from singlelineedit within w_al704_movimiento_almacen
end type
type gb_2 from groupbox within w_al704_movimiento_almacen
end type
end forward

global type w_al704_movimiento_almacen from w_report_smpl
integer width = 3456
integer height = 1956
string title = "Movimientos por tipo de Operación (AL704)"
string menuname = "m_impresion"
windowstate windowstate = maximized!
gb_1 gb_1
uo_fechas uo_fechas
cb_3 cb_3
cbx_almacen cbx_almacen
sle_almacen sle_almacen
sle_descrip sle_descrip
gb_2 gb_2
end type
global w_al704_movimiento_almacen w_al704_movimiento_almacen

type variables
Integer ii_index
end variables

on w_al704_movimiento_almacen.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.gb_1=create gb_1
this.uo_fechas=create uo_fechas
this.cb_3=create cb_3
this.cbx_almacen=create cbx_almacen
this.sle_almacen=create sle_almacen
this.sle_descrip=create sle_descrip
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_1
this.Control[iCurrent+2]=this.uo_fechas
this.Control[iCurrent+3]=this.cb_3
this.Control[iCurrent+4]=this.cbx_almacen
this.Control[iCurrent+5]=this.sle_almacen
this.Control[iCurrent+6]=this.sle_descrip
this.Control[iCurrent+7]=this.gb_2
end on

on w_al704_movimiento_almacen.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_1)
destroy(this.uo_fechas)
destroy(this.cb_3)
destroy(this.cbx_almacen)
destroy(this.sle_almacen)
destroy(this.sle_descrip)
destroy(this.gb_2)
end on

event ue_retrieve;call super::ue_retrieve;Date ld_fec_ini, ld_fec_fin
string ls_alm

ld_fec_ini = uo_fechas.of_get_fecha1()
ld_fec_fin = uo_fechas.of_get_fecha2()

if cbx_almacen.checked = false then
	
	ls_alm = sle_almacen.text
	
	dw_report.Dataobject = 'd_rpt_movimiento_almacen'
	dw_report.SetTransobject( sqlca)
	dw_report.retrieve(ls_alm, ld_fec_ini, ld_fec_fin)
	dw_report.object.t_tit2.text = sle_descrip.text
	
else
	dw_report.Dataobject = 'd_rpt_movimiento_almacen_all'
	dw_report.SetTransobject( sqlca)
	dw_report.retrieve(ld_fec_ini, ld_fec_fin)
end if

ib_preview = false
this.event ue_preview()
dw_report.object.t_user.text = gs_user
idw_1.Object.p_logo.filename = gs_logo
idw_1.Object.t_empresa.text = gs_empresa
idw_1.Object.t_objeto.text = 'AL704'
dw_report.object.t_tit1.text = "En Nuevos Soles  del: " + &
    String( ld_fec_ini, 'dd/mm/yyyy') + ' AL ' + &
	 String( ld_fec_fin, 'dd/mm/yyyy') 

end event

type dw_report from w_report_smpl`dw_report within w_al704_movimiento_almacen
integer x = 0
integer y = 320
integer width = 3342
integer height = 1428
string dataobject = "d_rpt_movimiento_almacen"
end type

type gb_1 from groupbox within w_al704_movimiento_almacen
integer x = 41
integer width = 745
integer height = 300
integer taborder = 10
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "  Fechas  : "
end type

type uo_fechas from u_ingreso_rango_fechas_v within w_al704_movimiento_almacen
integer x = 101
integer y = 76
integer height = 212
integer taborder = 40
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

type cb_3 from commandbutton within w_al704_movimiento_almacen
integer x = 2487
integer y = 40
integer width = 402
integer height = 220
integer taborder = 30
boolean bringtotop = true
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Reporte"
end type

event clicked;Parent.event ue_retrieve()


end event

type cbx_almacen from checkbox within w_al704_movimiento_almacen
integer x = 864
integer y = 192
integer width = 1312
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

event clicked;if this.checked = true then
	sle_almacen.enabled = false
else
	sle_almacen.enabled = true
end if
end event

type sle_almacen from singlelineedit within w_al704_movimiento_almacen
event dobleclick pbm_lbuttondblclk
integer x = 855
integer y = 88
integer width = 274
integer height = 88
integer taborder = 100
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
	    + "FROM almacen " &
		 + "where flag_tipo_almacen <> 'O'"
				 
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
  and flag_tipo_almacen <> 'O';

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de Almacen no existe o es un almacén de tránsito')
	return
end if

sle_descrip.text = ls_desc

end event

type sle_descrip from singlelineedit within w_al704_movimiento_almacen
integer x = 1134
integer y = 88
integer width = 1271
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

type gb_2 from groupbox within w_al704_movimiento_almacen
integer x = 818
integer y = 4
integer width = 1627
integer height = 300
integer taborder = 40
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Almacen:"
end type

