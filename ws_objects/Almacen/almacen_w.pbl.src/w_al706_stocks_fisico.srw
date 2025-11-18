$PBExportHeader$w_al706_stocks_fisico.srw
forward
global type w_al706_stocks_fisico from w_rpt_list
end type
type gb_fechas from groupbox within w_al706_stocks_fisico
end type
type cb_seleccionar from commandbutton within w_al706_stocks_fisico
end type
type uo_fecha from u_ingreso_fecha within w_al706_stocks_fisico
end type
type ddlb_clase from u_ddlb within w_al706_stocks_fisico
end type
type cbx_1 from checkbox within w_al706_stocks_fisico
end type
type sle_almacen from singlelineedit within w_al706_stocks_fisico
end type
type sle_descrip from singlelineedit within w_al706_stocks_fisico
end type
type uo_search from n_cst_search within w_al706_stocks_fisico
end type
type gb_1 from groupbox within w_al706_stocks_fisico
end type
type gb_2 from groupbox within w_al706_stocks_fisico
end type
end forward

global type w_al706_stocks_fisico from w_rpt_list
integer width = 3899
integer height = 2476
string title = "[AL706] Stocks Fisico Valorizado x Almacen"
string menuname = "m_impresion"
windowstate windowstate = maximized!
long backcolor = 67108864
gb_fechas gb_fechas
cb_seleccionar cb_seleccionar
uo_fecha uo_fecha
ddlb_clase ddlb_clase
cbx_1 cbx_1
sle_almacen sle_almacen
sle_descrip sle_descrip
uo_search uo_search
gb_1 gb_1
gb_2 gb_2
end type
global w_al706_stocks_fisico w_al706_stocks_fisico

type variables
String is_almacen, is_col = '', is_type
Integer  ii_clase

end variables

on w_al706_stocks_fisico.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.gb_fechas=create gb_fechas
this.cb_seleccionar=create cb_seleccionar
this.uo_fecha=create uo_fecha
this.ddlb_clase=create ddlb_clase
this.cbx_1=create cbx_1
this.sle_almacen=create sle_almacen
this.sle_descrip=create sle_descrip
this.uo_search=create uo_search
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_fechas
this.Control[iCurrent+2]=this.cb_seleccionar
this.Control[iCurrent+3]=this.uo_fecha
this.Control[iCurrent+4]=this.ddlb_clase
this.Control[iCurrent+5]=this.cbx_1
this.Control[iCurrent+6]=this.sle_almacen
this.Control[iCurrent+7]=this.sle_descrip
this.Control[iCurrent+8]=this.uo_search
this.Control[iCurrent+9]=this.gb_1
this.Control[iCurrent+10]=this.gb_2
end on

on w_al706_stocks_fisico.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_fechas)
destroy(this.cb_seleccionar)
destroy(this.uo_fecha)
destroy(this.ddlb_clase)
destroy(this.cbx_1)
destroy(this.sle_almacen)
destroy(this.sle_descrip)
destroy(this.uo_search)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event resize;call super::resize;dw_report.width = newwidth - dw_report.x - 10
dw_report.height = newheight - dw_report.y - 10

pb_1.x = newwidth / 2 - pb_1.width
pb_2.x = pb_1.x

dw_1.height = newheight - dw_1.y - 10
dw_1.width 	= pb_1.x - dw_1.x - 10

dw_2.height = newheight - dw_2.y
dw_2.x		= pb_1.x + pb_1.width + 10
dw_2.width	= newWidth - dw_2.x

uo_search.width = newwidth - uo_search.x - 10

uo_search.event ue_resize( sizetype, uo_search.width, uo_search.height)
end event

event ue_open_pre;call super::ue_open_pre;uo_search.of_set_dw(dw_1)
end event

type dw_report from w_rpt_list`dw_report within w_al706_stocks_fisico
boolean visible = false
integer x = 0
integer y = 300
integer width = 3319
integer height = 1960
integer taborder = 30
string dataobject = "d_rpt_stocks_fisico"
end type

type dw_1 from w_rpt_list`dw_1 within w_al706_stocks_fisico
integer x = 0
integer y = 388
integer width = 1669
integer height = 1416
integer taborder = 100
string dataobject = "d_sel_mov_articulos_x_clases_tbl"
end type

event dw_1::constructor;call super::constructor;this.SettransObject( sqlca)
ii_ck[1] = 1 
ii_ck[2] = 2
ii_ck[3] = 3

ii_dk[1] = 1
ii_dk[2] = 2
ii_dk[3] = 3

ii_rk[1] = 1
ii_rk[2] = 2
ii_rk[3] = 3
end event

type pb_1 from w_rpt_list`pb_1 within w_al706_stocks_fisico
integer x = 1728
integer y = 876
integer taborder = 110
end type

event pb_1::clicked;call super::clicked;if dw_2.Rowcount() > 0 then
	cb_report.enabled = true
end if
	
end event

type pb_2 from w_rpt_list`pb_2 within w_al706_stocks_fisico
integer x = 1728
integer y = 1044
integer taborder = 130
alignment htextalign = center!
end type

type dw_2 from w_rpt_list`dw_2 within w_al706_stocks_fisico
integer x = 1911
integer y = 388
integer width = 1669
integer height = 1416
integer taborder = 120
string dataobject = "d_sel_mov_articulos_x_clases_tbl"
end type

event dw_2::constructor;call super::constructor;this.SettransObject( sqlca)

ii_ck[1] = 1
ii_ck[2] = 2
ii_ck[3] = 3

ii_dk[1] = 1
ii_dk[2] = 2
ii_dk[3] = 3

ii_rk[1] = 1
ii_rk[2] = 2
ii_rk[3] = 3
end event

type cb_report from w_rpt_list`cb_report within w_al706_stocks_fisico
integer x = 3040
integer y = 112
integer width = 366
integer height = 100
integer taborder = 80
integer textsize = -8
boolean enabled = false
string text = "Reporte"
boolean default = true
end type

event cb_report::clicked;call super::clicked;Date 		ld_fecha
double 	ln_saldo
Long 		ll_row
String 	ls_cod, ls_mensaje

ld_fecha = uo_fecha.of_get_fecha()


SetPointer( Hourglass!)

is_almacen = sle_almacen.text

if dw_2.rowcount() = 0 then return	

// Llena datos de dw seleccionados a tabla temporal
delete from tt_alm_seleccion;
FOR ll_row = 1 to dw_2.rowcount()
	
	ls_cod = dw_2.object.cod_art[ll_row]		
	
	Insert into tt_alm_seleccion( cod_Art, fecha1) 
	values ( :ls_cod, :ld_fecha);		
	
	If sqlca.sqlcode = -1 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		messagebox("Error", "Error al insertar en tt_alm_seleccion. Mensaje: " + ls_mensaje, StopSign!)
		return
	END IF
NEXT			
	
dw_1.visible = false
dw_2.visible = false		
pb_1.visible = false
pb_2.visible = false
uo_search.visible = false

	
dw_report.SetTransObject( sqlca)
parent.Event ue_preview()
dw_report.retrieve(is_almacen, ld_fecha)	
dw_report.object.fec_ini.text = STRING(ld_fecha, "DD/MM/YYYY")
dw_report.object.t_user.text = gs_user
dw_report.object.t_almacen.text = sle_descrip.text
dw_report.Object.p_logo.filename = gs_logo

dw_report.visible = true
		
//this.enabled = false
cb_seleccionar.enabled = true
cb_seleccionar.visible = true

end event

type gb_fechas from groupbox within w_al706_stocks_fisico
integer x = 46
integer y = 4
integer width = 727
integer height = 284
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

type cb_seleccionar from commandbutton within w_al706_stocks_fisico
boolean visible = false
integer x = 3040
integer y = 16
integer width = 366
integer height = 100
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Seleccionar"
end type

event clicked;String 	ls_clase
Date		ld_Fecha

dw_1.visible = true
dw_2.visible = true
pb_1.visible = true
pb_2.visible = true
uo_search.visible = true


dw_report.visible = false	
dw_1.reset()
dw_2.reset()

if ii_clase = 0 and cbx_1.checked = false then
	Messagebox( "Aviso", "Debe indicar la clase, por favor verifique!", StopSign!)
	return
end if

if cbx_1.checked = true then
	ls_clase = '%'
else
	ls_clase = ddlb_clase.ia_key[ii_clase]
end if

ld_Fecha = uo_Fecha.of_get_fecha()

dw_1.retrieve( sle_almacen.text, ls_clase, ld_fecha)
end event

type uo_fecha from u_ingreso_fecha within w_al706_stocks_fisico
event destroy ( )
integer x = 64
integer y = 108
integer taborder = 70
boolean bringtotop = true
end type

on uo_fecha.destroy
call u_ingreso_fecha::destroy
end on

event constructor;call super::constructor;String ls_desde
 
 of_set_label('Al:') 								//	para setear la fecha inicial
 
 ls_desde = '01/' + string(month(today()))+'/' + string(year(today()))
 of_set_fecha(today()) 				// para seatear el titulo del boton
 of_set_rango_inicio(date('01/01/1900')) 				// rango inicial
 of_set_rango_fin(date('31/12/9999'))		
end event

type ddlb_clase from u_ddlb within w_al706_stocks_fisico
integer x = 2331
integer y = 156
integer width = 608
integer height = 436
integer taborder = 30
boolean bringtotop = true
end type

event selectionchanged;call super::selectionchanged;if index > 0 then
   ii_clase = index	
end if
end event

event ue_open_pre();call super::ue_open_pre;is_dataobject = 'd_dddw_clases'

ii_cn1 = 1                     // Nro del campo 1
ii_cn2 = 2                     // Nro del campo 2
ii_ck  = 1                     // Nro del campo key
ii_lc1 = 6                     // Longitud del campo 1
ii_lc2 = 45							// Longitud del campo 2
end event

type cbx_1 from checkbox within w_al706_stocks_fisico
integer x = 2331
integer y = 76
integer width = 402
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Todos"
end type

event clicked;if this.checked = true then
	ddlb_clase.enabled = false
	ddlb_clase.text = ''
else	
	ddlb_clase.enabled = true
end if
end event

type sle_almacen from singlelineedit within w_al706_stocks_fisico
event dobleclick pbm_lbuttondblclk
integer x = 786
integer y = 104
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
	Parent.event dynamic ue_seleccionar()
	cb_seleccionar.visible = true
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
cb_seleccionar.visible = true

end event

type sle_descrip from singlelineedit within w_al706_stocks_fisico
integer x = 1024
integer y = 104
integer width = 1211
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

type uo_search from n_cst_search within w_al706_stocks_fisico
event destroy ( )
integer y = 296
integer width = 3584
integer taborder = 10
boolean bringtotop = true
end type

on uo_search.destroy
call n_cst_search::destroy
end on

event ue_buscar;call super::ue_buscar;String ls_buscar

ls_buscar = this.of_get_filtro()

parent.event dynamic ue_filtro( ls_buscar)
end event

type gb_1 from groupbox within w_al706_stocks_fisico
integer x = 768
integer y = 4
integer width = 1518
integer height = 284
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Almacen:"
end type

type gb_2 from groupbox within w_al706_stocks_fisico
integer x = 2295
integer y = 4
integer width = 713
integer height = 284
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Clases"
end type

