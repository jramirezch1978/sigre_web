$PBExportHeader$w_al749_res_tipo_movimiento.srw
forward
global type w_al749_res_tipo_movimiento from w_report_smpl
end type
type cb_1 from commandbutton within w_al749_res_tipo_movimiento
end type
type sle_almacen from singlelineedit within w_al749_res_tipo_movimiento
end type
type sle_descrip from singlelineedit within w_al749_res_tipo_movimiento
end type
type st_2 from statictext within w_al749_res_tipo_movimiento
end type
type cbx_1 from checkbox within w_al749_res_tipo_movimiento
end type
type rb_1 from radiobutton within w_al749_res_tipo_movimiento
end type
type rb_2 from radiobutton within w_al749_res_tipo_movimiento
end type
type st_1 from statictext within w_al749_res_tipo_movimiento
end type
type sle_clase from singlelineedit within w_al749_res_tipo_movimiento
end type
type sle_desclase from singlelineedit within w_al749_res_tipo_movimiento
end type
type cbx_2 from checkbox within w_al749_res_tipo_movimiento
end type
type hpb_1 from hprogressbar within w_al749_res_tipo_movimiento
end type
type gb_1 from groupbox within w_al749_res_tipo_movimiento
end type
type gb_2 from groupbox within w_al749_res_tipo_movimiento
end type
type uo_fecha from u_ingreso_rango_fechas_v within w_al749_res_tipo_movimiento
end type
type cbx_3 from checkbox within w_al749_res_tipo_movimiento
end type
type gb_fechas from groupbox within w_al749_res_tipo_movimiento
end type
end forward

global type w_al749_res_tipo_movimiento from w_report_smpl
integer width = 3890
integer height = 1740
string title = "[AL749] Resumen por Tipo de Movimiento"
string menuname = "m_impresion"
windowstate windowstate = maximized!
long backcolor = 79741120
cb_1 cb_1
sle_almacen sle_almacen
sle_descrip sle_descrip
st_2 st_2
cbx_1 cbx_1
rb_1 rb_1
rb_2 rb_2
st_1 st_1
sle_clase sle_clase
sle_desclase sle_desclase
cbx_2 cbx_2
hpb_1 hpb_1
gb_1 gb_1
gb_2 gb_2
uo_fecha uo_fecha
cbx_3 cbx_3
gb_fechas gb_fechas
end type
global w_al749_res_tipo_movimiento w_al749_res_tipo_movimiento

type variables
string is_clase, is_almacen
integer ii_opc2, ii_opc1
date id_fecha1, id_fecha2
end variables

forward prototypes
public subroutine of_procesar ()
end prototypes

public subroutine of_procesar ();Long 		ll_row, ll_nro_am
String 	ls_org_am
Decimal	ldc_precio_real

try 
	hpb_1.visible = true

	for ll_row = 1 to dw_Report.RowCount()
		ls_org_am 			= dw_report.object.org_am 						[ll_row]
		ll_nro_am 			= Long(dw_report.object.nro_am				[ll_row])
		ldc_precio_real 	= Dec(dw_report.object.precio_unit_real	[ll_row])
		
		update articulo_mov am
			set am.precio_unit = :ldc_precio_real
		where cod_origen 	= :ls_org_am
		  and nro_mov		= :ll_nro_am;
		
		if gnvo_app.of_existserror( SQLCA, "update ARTICULO_MOV") then 
			ROLLBACK;
			return
		end if
		
		hpb_1.Position = ll_row / dw_report.RowCount() * 100
		
	next
	
	commit;


catch ( Exception ex )
	MessageBox('Error', 'Ha ocurrido una excepcion: ' + ex.getMessage())
finally
	hpb_1.visible = false
end try


end subroutine

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

on w_al749_res_tipo_movimiento.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.cb_1=create cb_1
this.sle_almacen=create sle_almacen
this.sle_descrip=create sle_descrip
this.st_2=create st_2
this.cbx_1=create cbx_1
this.rb_1=create rb_1
this.rb_2=create rb_2
this.st_1=create st_1
this.sle_clase=create sle_clase
this.sle_desclase=create sle_desclase
this.cbx_2=create cbx_2
this.hpb_1=create hpb_1
this.gb_1=create gb_1
this.gb_2=create gb_2
this.uo_fecha=create uo_fecha
this.cbx_3=create cbx_3
this.gb_fechas=create gb_fechas
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.sle_almacen
this.Control[iCurrent+3]=this.sle_descrip
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.cbx_1
this.Control[iCurrent+6]=this.rb_1
this.Control[iCurrent+7]=this.rb_2
this.Control[iCurrent+8]=this.st_1
this.Control[iCurrent+9]=this.sle_clase
this.Control[iCurrent+10]=this.sle_desclase
this.Control[iCurrent+11]=this.cbx_2
this.Control[iCurrent+12]=this.hpb_1
this.Control[iCurrent+13]=this.gb_1
this.Control[iCurrent+14]=this.gb_2
this.Control[iCurrent+15]=this.uo_fecha
this.Control[iCurrent+16]=this.cbx_3
this.Control[iCurrent+17]=this.gb_fechas
end on

on w_al749_res_tipo_movimiento.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.sle_almacen)
destroy(this.sle_descrip)
destroy(this.st_2)
destroy(this.cbx_1)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.st_1)
destroy(this.sle_clase)
destroy(this.sle_desclase)
destroy(this.cbx_2)
destroy(this.hpb_1)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.uo_fecha)
destroy(this.cbx_3)
destroy(this.gb_fechas)
end on

event ue_retrieve;call super::ue_retrieve;integer 	li_opc1, li_opc2
string		ls_mensaje, ls_almacen, ls_clase
Date 		ld_fecha1, ld_fecha2

ld_fecha1 = uo_Fecha.of_get_fecha1()
ld_fecha2 = uo_Fecha.of_get_fecha2()
if cbx_1.checked then
	ls_almacen = ''
	li_opc1 = 1
else
	li_opc1 = 0
	if trim(sle_almacen.text) = '' then
		MessageBox('Aviso', 'Debe ingresar un codigo de almacen')
		return
	end if
	ls_almacen = trim(sle_almacen.text)
end if

if cbx_2.checked then
	ls_clase = ''
	li_opc2 = 1
else
	li_opc2 = 0
	if trim(sle_clase.text) = '' then
		MessageBox('Aviso', 'Debe ingresar un codigo de clase')
		return
	end if
	ls_clase = trim(sle_clase.text)
end if

IF cbx_3.checked THEN
	IF rb_1.checked THEN
		dw_report.DataObject= "d_rpt_tipo_movim_art_mont"
	ELSE
		dw_report.DataObject= "d_rpt_tipo_movim_art_cant"
	END IF
ELSE
	IF rb_1.checked THEN
		dw_report.DataObject= "d_rpt_tipo_movim_mont"
	ELSE
		dw_report.DataObject= "d_rpt_tipo_movim_cant"
	END IF
END IF
ib_preview=true
this.event ue_preview()
dw_report.visible = true
dw_report.SetTransObject( sqlca)
dw_report.retrieve(ls_clase, li_opc2, ls_almacen, li_opc1, ld_fecha1, ld_fecha2)
is_clase = ls_clase
ii_opc2 = li_opc2
is_almacen = ls_almacen
ii_opc1 = li_opc1
id_fecha1 = ld_fecha1
id_fecha2 = ld_fecha2
dw_report.Object.DataWindow.Print.Orientation = 1


	

end event

event ue_open_pre;call super::ue_open_pre;dw_report.Object.DataWindow.Print.Orientation = 1
end event

type dw_report from w_report_smpl`dw_report within w_al749_res_tipo_movimiento
integer x = 0
integer y = 304
integer width = 3753
integer height = 988
string dataobject = "d_rpt_tipo_movim_mont"
end type

event dw_report::doubleclicked;call super::doubleclicked;str_parametros lstr_rep
string ls_nombre, ls_cadena, ls_columna, ls_cat, ls_col, ls_col1
long ll_colstat, ll_val, ll_column, ll_colvar, ll_pos, ll_col

IF row < 1 THEN RETURN
IF MID(string(THIS.GetBandAtPointer()),1,6) = 'detail' THEN
	dw_report.Modify('datawindow.crosstab.staticmode=yes')
	ll_col = dw_report.GetColumn()
	ll_pos = pos(String(dwo.Name), '_')
	IF ll_pos > 0 THEN
		ls_columna = replace (String(dwo.Name), ll_pos, 1, '_t_')
		ls_col = left(String(dwo.Name), ll_pos - 1)
	ELSE
		ls_columna = String(dwo.Name) + '_t'
		ls_col = String(dwo.Name)
	END IF
	ls_cadena = dw_report.describe(ls_columna + ".text")
	dw_report.Modify('datawindow.crosstab.staticmode=No')
	THIS.selectrow(0,FALSE)
	THIS.selectrow(row,true)
	THIS.ScrollToRow(row)
END IF

ls_col1 = dw_report.describe(ls_col + '_t' + ".text")
IF ls_col1 <> '@movimiento' THEN RETURN
IF isnull(dw_report.getitemnumber(row,String(dwo.Name))) THEN RETURN

ls_cadena = left(ls_cadena, pos(String(ls_cadena), ' ') - 1)
ls_cat = dw_report.object.articulo_categ_cat_art[row]
//messagebox ('', ls_cadena)

lstr_rep.titulo = 'Detalle de Movimientos'
lstr_rep.string1 = is_clase
lstr_rep.string2 = is_almacen
lstr_rep.string3 = ls_cadena
lstr_rep.string4 = trim(ls_cat)
lstr_rep.integer1 = ii_opc2
lstr_rep.integer2 = ii_opc1
lstr_rep.date1 = id_fecha1
lstr_rep.date2 = id_fecha2
IF cbx_3.checked THEN
	lstr_rep.string5 = dw_report.object.articulo_mov_cod_art[row]
	lstr_rep.dw1 = 'd_rpt_tipo_movim_art_det'
	lstr_rep.tipo	  = '749A'
ELSE
	lstr_rep.dw1 = 'd_rpt_tipo_movim_det'
	lstr_rep.tipo	  = '749B'
END IF

OpenSheetWithParm(w_rpt_preview, lstr_rep, w_main, 0, Layered!)
end event

type cb_1 from commandbutton within w_al749_res_tipo_movimiento
integer x = 3273
integer y = 168
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

type sle_almacen from singlelineedit within w_al749_res_tipo_movimiento
event dobleclick pbm_lbuttondblclk
integer x = 960
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

type sle_descrip from singlelineedit within w_al749_res_tipo_movimiento
integer x = 1189
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

type st_2 from statictext within w_al749_res_tipo_movimiento
integer x = 695
integer y = 80
integer width = 256
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
boolean focusrectangle = false
end type

type cbx_1 from checkbox within w_al749_res_tipo_movimiento
integer x = 2363
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

type rb_1 from radiobutton within w_al749_res_tipo_movimiento
integer x = 2661
integer y = 116
integer width = 297
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Importe"
boolean checked = true
end type

type rb_2 from radiobutton within w_al749_res_tipo_movimiento
integer x = 2661
integer y = 196
integer width = 297
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Cantidad"
end type

type st_1 from statictext within w_al749_res_tipo_movimiento
integer x = 695
integer y = 180
integer width = 256
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Clase :"
boolean focusrectangle = false
end type

type sle_clase from singlelineedit within w_al749_res_tipo_movimiento
event dobleclick pbm_lbuttondblclk
integer x = 960
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

ls_sql = "SELECT cod_clase AS CODIGO_clase, " &
	  	 + "desc_clase AS DESCRIPCION_clase " &
	    + "FROM articulo_clase " 
				 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
if ls_codigo <> '' then
	this.text 				= ls_codigo
	sle_desclase.text 	= ls_data
end if

end event

event modified;String 	ls_clase, ls_desc

ls_clase = sle_clase.text
if ls_clase = '' or IsNull(ls_clase) then
	MessageBox('Aviso', 'Debe Ingresar un Codigo de Clase')
	return
end if
		 
SELECT desc_clase
	INTO :ls_desc
FROM articulo_clase 
where cod_clase = :ls_clase ;

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de Clase no Existe')
	return
end if

sle_desclase.text = ls_desc

end event

type sle_desclase from singlelineedit within w_al749_res_tipo_movimiento
integer x = 1189
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

type cbx_2 from checkbox within w_al749_res_tipo_movimiento
integer x = 2363
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
	sle_clase.enabled = false
else
	sle_clase.enabled = true
end if
end event

type hpb_1 from hprogressbar within w_al749_res_tipo_movimiento
boolean visible = false
integer x = 3278
integer y = 68
integer width = 462
integer height = 68
boolean bringtotop = true
unsignedinteger maxposition = 100
unsignedinteger position = 50
integer setstep = 10
end type

type gb_1 from groupbox within w_al749_res_tipo_movimiento
integer x = 677
integer width = 1957
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

type gb_2 from groupbox within w_al749_res_tipo_movimiento
integer x = 2633
integer width = 622
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

type uo_fecha from u_ingreso_rango_fechas_v within w_al749_res_tipo_movimiento
event destroy ( )
integer x = 18
integer y = 60
integer taborder = 30
long backcolor = 67108864
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

type cbx_3 from checkbox within w_al749_res_tipo_movimiento
integer x = 2661
integer y = 56
integer width = 585
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Detallado por Artículo"
end type

type gb_fechas from groupbox within w_al749_res_tipo_movimiento
integer width = 667
integer height = 284
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

