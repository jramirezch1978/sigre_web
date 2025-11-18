$PBExportHeader$w_al725_mov_ing_sin_valor.srw
forward
global type w_al725_mov_ing_sin_valor from w_report_smpl
end type
type cb_1 from commandbutton within w_al725_mov_ing_sin_valor
end type
type uo_1 from u_ingreso_rango_fechas_v within w_al725_mov_ing_sin_valor
end type
type cbx_1 from checkbox within w_al725_mov_ing_sin_valor
end type
type sle_almacen from singlelineedit within w_al725_mov_ing_sin_valor
end type
type sle_descrip from singlelineedit within w_al725_mov_ing_sin_valor
end type
type st_2 from statictext within w_al725_mov_ing_sin_valor
end type
type gb_fechas from groupbox within w_al725_mov_ing_sin_valor
end type
type gb_1 from groupbox within w_al725_mov_ing_sin_valor
end type
end forward

global type w_al725_mov_ing_sin_valor from w_report_smpl
integer width = 3570
integer height = 2376
string title = "Ingresos sin Valorizacion (AL725)"
string menuname = "m_impresion"
windowstate windowstate = maximized!
long backcolor = 1073741824
cb_1 cb_1
uo_1 uo_1
cbx_1 cbx_1
sle_almacen sle_almacen
sle_descrip sle_descrip
st_2 st_2
gb_fechas gb_fechas
gb_1 gb_1
end type
global w_al725_mov_ing_sin_valor w_al725_mov_ing_sin_valor

type variables

end variables

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

on w_al725_mov_ing_sin_valor.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.cb_1=create cb_1
this.uo_1=create uo_1
this.cbx_1=create cbx_1
this.sle_almacen=create sle_almacen
this.sle_descrip=create sle_descrip
this.st_2=create st_2
this.gb_fechas=create gb_fechas
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.uo_1
this.Control[iCurrent+3]=this.cbx_1
this.Control[iCurrent+4]=this.sle_almacen
this.Control[iCurrent+5]=this.sle_descrip
this.Control[iCurrent+6]=this.st_2
this.Control[iCurrent+7]=this.gb_fechas
this.Control[iCurrent+8]=this.gb_1
end on

on w_al725_mov_ing_sin_valor.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.uo_1)
destroy(this.cbx_1)
destroy(this.sle_almacen)
destroy(this.sle_descrip)
destroy(this.st_2)
destroy(this.gb_fechas)
destroy(this.gb_1)
end on

event ue_retrieve;call super::ue_retrieve;Date 		ld_desde, ld_hasta
String 	ls_alm

ld_desde = uo_1.of_get_fecha1()
ld_hasta = uo_1.of_get_fecha2()

SetPointer( Hourglass!)

if cbx_1.checked then
	ls_alm = '%%'
else
	ls_alm = trim(sle_almacen.text) + '%'
end if

dw_report.visible = true
ib_preview=false
this.event ue_preview()
dw_report.SetTransObject( sqlca)
dw_report.retrieve(ls_alm, ld_desde, ld_hasta)	
dw_report.object.t_fecha.text 	= 'Del : ' & 
		+ STRING(LD_DESDE, "DD/MM/YYYY") + ' Al : ' &
		+ STRING(LD_HASTA, "DD/MM/YYYY")		
dw_report.object.t_user.text 		= gnvo_app.is_user
dw_report.Object.p_logo.filename = gnvo_app.is_logo
dw_report.object.datawindow.Print.Orientation = 1
	

end event

type p_pie from w_report_smpl`p_pie within w_al725_mov_ing_sin_valor
end type

type ole_skin from w_report_smpl`ole_skin within w_al725_mov_ing_sin_valor
end type

type uo_h from w_report_smpl`uo_h within w_al725_mov_ing_sin_valor
end type

type st_box from w_report_smpl`st_box within w_al725_mov_ing_sin_valor
end type

type phl_logonps from w_report_smpl`phl_logonps within w_al725_mov_ing_sin_valor
end type

type p_mundi from w_report_smpl`p_mundi within w_al725_mov_ing_sin_valor
end type

type p_logo from w_report_smpl`p_logo within w_al725_mov_ing_sin_valor
end type

type uo_filter from w_report_smpl`uo_filter within w_al725_mov_ing_sin_valor
integer x = 928
integer y = 44
end type

type st_filtro from w_report_smpl`st_filtro within w_al725_mov_ing_sin_valor
integer x = 617
integer y = 32
end type

type dw_report from w_report_smpl`dw_report within w_al725_mov_ing_sin_valor
integer x = 503
integer y = 528
integer width = 3035
integer height = 1092
string dataobject = "d_rpt_ingresos_sin_valor_tbl"
end type

type cb_1 from commandbutton within w_al725_mov_ing_sin_valor
integer x = 2446
integer y = 372
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

type uo_1 from u_ingreso_rango_fechas_v within w_al725_mov_ing_sin_valor
event destroy ( )
integer x = 539
integer y = 268
integer taborder = 20
boolean bringtotop = true
long backcolor = 1073741824
end type

on uo_1.destroy
call u_ingreso_rango_fechas_v::destroy
end on

event constructor;call super::constructor;String ls_desde
 
 of_set_label('Del:','Al:') 								//	para setear la fecha inicial
 
 ls_desde = '01/' + string(month(today()))+'/' + string(year(today()))
 of_set_fecha(date(ls_desde), today()) 				// para seatear el titulo del boton
 of_set_rango_inicio(date('01/01/1900')) 				// rango inicial
 of_set_rango_fin(date('31/12/9999'))					// rango final

// of_get_fecha1(), of_get_fecha2()  para leer las fechas

end event

type cbx_1 from checkbox within w_al725_mov_ing_sin_valor
integer x = 1243
integer y = 392
integer width = 951
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Todos los almacenes"
end type

event clicked;if this.checked then
	sle_almacen.enabled = false
else
	sle_almacen.enabled = true
end if
end event

type sle_almacen from singlelineedit within w_al725_mov_ing_sin_valor
event dobleclick pbm_lbuttondblclk
integer x = 1536
integer y = 280
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

type sle_descrip from singlelineedit within w_al725_mov_ing_sin_valor
integer x = 1765
integer y = 280
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

type st_2 from statictext within w_al725_mov_ing_sin_valor
integer x = 1230
integer y = 292
integer width = 302
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Almacen:"
boolean focusrectangle = false
end type

type gb_fechas from groupbox within w_al725_mov_ing_sin_valor
integer x = 521
integer y = 208
integer width = 667
integer height = 300
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
end type

type gb_1 from groupbox within w_al725_mov_ing_sin_valor
integer x = 1198
integer y = 208
integer width = 1746
integer height = 300
integer taborder = 50
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
end type

