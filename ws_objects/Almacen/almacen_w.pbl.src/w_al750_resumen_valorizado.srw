$PBExportHeader$w_al750_resumen_valorizado.srw
forward
global type w_al750_resumen_valorizado from w_report_smpl
end type
type cb_1 from commandbutton within w_al750_resumen_valorizado
end type
type sle_almacen from singlelineedit within w_al750_resumen_valorizado
end type
type sle_descrip from singlelineedit within w_al750_resumen_valorizado
end type
type st_2 from statictext within w_al750_resumen_valorizado
end type
type cbx_1 from checkbox within w_al750_resumen_valorizado
end type
type st_1 from statictext within w_al750_resumen_valorizado
end type
type sle_clase from singlelineedit within w_al750_resumen_valorizado
end type
type sle_desclase from singlelineedit within w_al750_resumen_valorizado
end type
type cbx_2 from checkbox within w_al750_resumen_valorizado
end type
type gb_1 from groupbox within w_al750_resumen_valorizado
end type
type uo_fecha from u_ingreso_rango_fechas_v within w_al750_resumen_valorizado
end type
type gb_fechas from groupbox within w_al750_resumen_valorizado
end type
end forward

global type w_al750_resumen_valorizado from w_report_smpl
integer width = 3890
integer height = 1740
string title = "[AL750] Resumen Valorizado"
string menuname = "m_impresion"
windowstate windowstate = maximized!
long backcolor = 79741120
cb_1 cb_1
sle_almacen sle_almacen
sle_descrip sle_descrip
st_2 st_2
cbx_1 cbx_1
st_1 st_1
sle_clase sle_clase
sle_desclase sle_desclase
cbx_2 cbx_2
gb_1 gb_1
uo_fecha uo_fecha
gb_fechas gb_fechas
end type
global w_al750_resumen_valorizado w_al750_resumen_valorizado

type variables
string is_clase, is_almacen
integer ii_opc2, ii_opc1
date id_fecha1, id_fecha2
end variables

forward prototypes
public subroutine of_procesar ()
end prototypes

public subroutine of_procesar ();

end subroutine

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

on w_al750_resumen_valorizado.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.cb_1=create cb_1
this.sle_almacen=create sle_almacen
this.sle_descrip=create sle_descrip
this.st_2=create st_2
this.cbx_1=create cbx_1
this.st_1=create st_1
this.sle_clase=create sle_clase
this.sle_desclase=create sle_desclase
this.cbx_2=create cbx_2
this.gb_1=create gb_1
this.uo_fecha=create uo_fecha
this.gb_fechas=create gb_fechas
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.sle_almacen
this.Control[iCurrent+3]=this.sle_descrip
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.cbx_1
this.Control[iCurrent+6]=this.st_1
this.Control[iCurrent+7]=this.sle_clase
this.Control[iCurrent+8]=this.sle_desclase
this.Control[iCurrent+9]=this.cbx_2
this.Control[iCurrent+10]=this.gb_1
this.Control[iCurrent+11]=this.uo_fecha
this.Control[iCurrent+12]=this.gb_fechas
end on

on w_al750_resumen_valorizado.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.sle_almacen)
destroy(this.sle_descrip)
destroy(this.st_2)
destroy(this.cbx_1)
destroy(this.st_1)
destroy(this.sle_clase)
destroy(this.sle_desclase)
destroy(this.cbx_2)
destroy(this.gb_1)
destroy(this.uo_fecha)
destroy(this.gb_fechas)
end on

event ue_retrieve;call super::ue_retrieve;string	ls_mensaje, ls_almacen, ls_clase
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

if cbx_2.checked then
	ls_clase = '%%'
else
	if trim(sle_clase.text) = '' then
		MessageBox('Aviso', 'Debe ingresar un codigo de clase')
		return
	end if
	ls_clase = trim(sle_clase.text) + '%'
end if

ib_preview=true
this.event ue_preview()

dw_report.visible = true
dw_report.SetTransObject( sqlca)
dw_report.retrieve(ls_clase, ls_almacen, ld_fecha1, ld_fecha2)

dw_report.Object.DataWindow.Print.Orientation = 1


	

end event

event ue_open_pre;call super::ue_open_pre;dw_report.Object.DataWindow.Print.Orientation = 1
end event

type dw_report from w_report_smpl`dw_report within w_al750_resumen_valorizado
integer x = 0
integer y = 304
integer width = 3753
integer height = 988
string dataobject = "d_rpt_resumen_valorizado_crt"
end type

type cb_1 from commandbutton within w_al750_resumen_valorizado
integer x = 2642
integer y = 52
integer width = 466
integer height = 212
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

type sle_almacen from singlelineedit within w_al750_resumen_valorizado
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

type sle_descrip from singlelineedit within w_al750_resumen_valorizado
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

type st_2 from statictext within w_al750_resumen_valorizado
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

type cbx_1 from checkbox within w_al750_resumen_valorizado
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

type st_1 from statictext within w_al750_resumen_valorizado
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

type sle_clase from singlelineedit within w_al750_resumen_valorizado
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

ls_sql = "SELECT E.cod_clase AS CODIGO_clase, " &
	  	 + "E.desc_clase AS DESCRIPCION_clase " &
	    + "FROM articulo_clase E " 
				 
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

type sle_desclase from singlelineedit within w_al750_resumen_valorizado
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

type cbx_2 from checkbox within w_al750_resumen_valorizado
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

type gb_1 from groupbox within w_al750_resumen_valorizado
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

type uo_fecha from u_ingreso_rango_fechas_v within w_al750_resumen_valorizado
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

type gb_fechas from groupbox within w_al750_resumen_valorizado
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

