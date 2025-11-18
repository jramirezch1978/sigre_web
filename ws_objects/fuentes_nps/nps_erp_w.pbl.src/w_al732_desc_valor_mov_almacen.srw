$PBExportHeader$w_al732_desc_valor_mov_almacen.srw
forward
global type w_al732_desc_valor_mov_almacen from w_report_smpl
end type
type cb_1 from commandbutton within w_al732_desc_valor_mov_almacen
end type
type uo_fecha from u_ingreso_rango_fechas_v within w_al732_desc_valor_mov_almacen
end type
type sle_almacen from singlelineedit within w_al732_desc_valor_mov_almacen
end type
type sle_descrip from singlelineedit within w_al732_desc_valor_mov_almacen
end type
type st_2 from statictext within w_al732_desc_valor_mov_almacen
end type
type cb_2 from commandbutton within w_al732_desc_valor_mov_almacen
end type
type cbx_1 from checkbox within w_al732_desc_valor_mov_almacen
end type
type gb_fechas from groupbox within w_al732_desc_valor_mov_almacen
end type
type gb_1 from groupbox within w_al732_desc_valor_mov_almacen
end type
end forward

global type w_al732_desc_valor_mov_almacen from w_report_smpl
integer width = 3712
integer height = 2372
string title = "Descuadres de Valorizacion en Movimientos de Almacen (AL732)"
string menuname = "m_impresion"
windowstate windowstate = maximized!
long backcolor = 1073741824
cb_1 cb_1
uo_fecha uo_fecha
sle_almacen sle_almacen
sle_descrip sle_descrip
st_2 st_2
cb_2 cb_2
cbx_1 cbx_1
gb_fechas gb_fechas
gb_1 gb_1
end type
global w_al732_desc_valor_mov_almacen w_al732_desc_valor_mov_almacen

type variables

end variables

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

on w_al732_desc_valor_mov_almacen.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.cb_1=create cb_1
this.uo_fecha=create uo_fecha
this.sle_almacen=create sle_almacen
this.sle_descrip=create sle_descrip
this.st_2=create st_2
this.cb_2=create cb_2
this.cbx_1=create cbx_1
this.gb_fechas=create gb_fechas
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.uo_fecha
this.Control[iCurrent+3]=this.sle_almacen
this.Control[iCurrent+4]=this.sle_descrip
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.cb_2
this.Control[iCurrent+7]=this.cbx_1
this.Control[iCurrent+8]=this.gb_fechas
this.Control[iCurrent+9]=this.gb_1
end on

on w_al732_desc_valor_mov_almacen.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.uo_fecha)
destroy(this.sle_almacen)
destroy(this.sle_descrip)
destroy(this.st_2)
destroy(this.cb_2)
destroy(this.cbx_1)
destroy(this.gb_fechas)
destroy(this.gb_1)
end on

event ue_retrieve;call super::ue_retrieve;string	ls_mensaje, ls_almacen
Date 		ld_fecha1, ld_fecha2

ld_fecha1 = uo_Fecha.of_get_fecha1()
ld_fecha2 = uo_Fecha.of_get_fecha2()
if cbx_1.checked then
	ls_almacen = '%%'
else
	if trim(sle_almacen.text) = '' then
		MessageBox('Aviso', 'Debe ingresar un codigo de almacen')
		return
	end if
	ls_almacen = trim(sle_almacen.text) + '%'
end if

//create or replace procedure USP_ALM_RPT_PRECIO_MOV(
//       asi_almacen in almacen.almacen%TYPE, 
//       adi_fecha1  in date,
//       adi_fecha2  in date
//) is

DECLARE USP_ALM_RPT_PRECIO_MOV PROCEDURE FOR
	USP_ALM_RPT_PRECIO_MOV( :ls_almacen,
									:ld_fecha1,
									:ld_fecha2);

EXECUTE USP_ALM_RPT_PRECIO_MOV;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE USP_ALM_RPT_PRECIO_MOV:" &
			  + SQLCA.SQLErrText
	Rollback;
	MessageBox('Aviso', ls_mensaje)
	Return
END IF

CLOSE USP_ALM_RPT_PRECIO_MOV;

ib_preview=false
this.event ue_preview()
dw_report.visible = true
dw_report.SetTransObject( sqlca)
dw_report.retrieve()	
dw_report.object.t_fechas.text = string(ld_fecha1, 'dd/mm/yyyy') &
	+ ' AL ' + string(ld_fecha2, 'dd/mm/yyyy')
dw_report.object.t_almacen.text = 'ALMACEN: ' + sle_descrip.text
dw_report.Object.DataWindow.Print.Orientation = 1
dw_report.object.t_user.text 		= gnvo_app.is_user
dw_report.object.t_ventana.text 	= this.classname( )
dw_report.Object.p_logo.filename = gnvo_app.is_logo

	

end event

event ue_open_pre;call super::ue_open_pre;dw_report.Object.DataWindow.Print.Orientation = 1
end event

type p_pie from w_report_smpl`p_pie within w_al732_desc_valor_mov_almacen
end type

type ole_skin from w_report_smpl`ole_skin within w_al732_desc_valor_mov_almacen
integer x = 3063
integer y = 112
end type

type uo_h from w_report_smpl`uo_h within w_al732_desc_valor_mov_almacen
end type

type st_box from w_report_smpl`st_box within w_al732_desc_valor_mov_almacen
end type

type phl_logonps from w_report_smpl`phl_logonps within w_al732_desc_valor_mov_almacen
end type

type p_mundi from w_report_smpl`p_mundi within w_al732_desc_valor_mov_almacen
end type

type p_logo from w_report_smpl`p_logo within w_al732_desc_valor_mov_almacen
end type

type uo_filter from w_report_smpl`uo_filter within w_al732_desc_valor_mov_almacen
integer x = 910
integer y = 32
end type

type st_filtro from w_report_smpl`st_filtro within w_al732_desc_valor_mov_almacen
integer x = 585
integer y = 56
end type

type dw_report from w_report_smpl`dw_report within w_al732_desc_valor_mov_almacen
integer y = 556
integer width = 3141
integer height = 1536
string dataobject = "d_rpt_precio_mov_cab"
end type

type cb_1 from commandbutton within w_al732_desc_valor_mov_almacen
integer x = 3049
integer y = 292
integer width = 471
integer height = 108
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

type uo_fecha from u_ingreso_rango_fechas_v within w_al732_desc_valor_mov_almacen
event destroy ( )
integer x = 512
integer y = 312
integer taborder = 30
boolean bringtotop = true
long backcolor = 1073741824
end type

on uo_fecha.destroy
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

type sle_almacen from singlelineedit within w_al732_desc_valor_mov_almacen
event dobleclick pbm_lbuttondblclk
integer x = 1509
integer y = 320
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

type sle_descrip from singlelineedit within w_al732_desc_valor_mov_almacen
integer x = 1737
integer y = 320
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

type st_2 from statictext within w_al732_desc_valor_mov_almacen
integer x = 1202
integer y = 332
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

type cb_2 from commandbutton within w_al732_desc_valor_mov_almacen
integer x = 3049
integer y = 428
integer width = 471
integer height = 112
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Procesar"
end type

event clicked;OpenSheet (w_al900_act_prec_prom_art_all, w_main, 0, Original!)
end event

type cbx_1 from checkbox within w_al732_desc_valor_mov_almacen
integer x = 1216
integer y = 436
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

type gb_fechas from groupbox within w_al732_desc_valor_mov_almacen
integer x = 503
integer y = 244
integer width = 667
integer height = 300
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
end type

type gb_1 from groupbox within w_al732_desc_valor_mov_almacen
integer x = 1179
integer y = 244
integer width = 1746
integer height = 300
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
end type

