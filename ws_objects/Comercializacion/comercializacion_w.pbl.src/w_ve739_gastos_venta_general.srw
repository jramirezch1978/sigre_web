$PBExportHeader$w_ve739_gastos_venta_general.srw
forward
global type w_ve739_gastos_venta_general from w_rpt
end type
type rb_det from radiobutton within w_ve739_gastos_venta_general
end type
type rb_res from radiobutton within w_ve739_gastos_venta_general
end type
type st_1 from statictext within w_ve739_gastos_venta_general
end type
type sle_oventa from singlelineedit within w_ve739_gastos_venta_general
end type
type cb_2 from commandbutton within w_ve739_gastos_venta_general
end type
type uo_1 from u_ingreso_rango_fechas within w_ve739_gastos_venta_general
end type
type cb_1 from commandbutton within w_ve739_gastos_venta_general
end type
type dw_report from u_dw_rpt within w_ve739_gastos_venta_general
end type
type gb_1 from groupbox within w_ve739_gastos_venta_general
end type
end forward

global type w_ve739_gastos_venta_general from w_rpt
integer width = 2706
integer height = 2008
string title = "(VE739) Gastos de Venta General"
string menuname = "m_reporte"
long backcolor = 134217728
rb_det rb_det
rb_res rb_res
st_1 st_1
sle_oventa sle_oventa
cb_2 cb_2
uo_1 uo_1
cb_1 cb_1
dw_report dw_report
gb_1 gb_1
end type
global w_ve739_gastos_venta_general w_ve739_gastos_venta_general

on w_ve739_gastos_venta_general.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.rb_det=create rb_det
this.rb_res=create rb_res
this.st_1=create st_1
this.sle_oventa=create sle_oventa
this.cb_2=create cb_2
this.uo_1=create uo_1
this.cb_1=create cb_1
this.dw_report=create dw_report
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_det
this.Control[iCurrent+2]=this.rb_res
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.sle_oventa
this.Control[iCurrent+5]=this.cb_2
this.Control[iCurrent+6]=this.uo_1
this.Control[iCurrent+7]=this.cb_1
this.Control[iCurrent+8]=this.dw_report
this.Control[iCurrent+9]=this.gb_1
end on

on w_ve739_gastos_venta_general.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_det)
destroy(this.rb_res)
destroy(this.st_1)
destroy(this.sle_oventa)
destroy(this.cb_2)
destroy(this.uo_1)
destroy(this.cb_1)
destroy(this.dw_report)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report

idw_1.Visible = False
idw_1.SetTransObject(sqlca)

ib_preview = false

ib_preview = FALSE
THIS.Event ue_preview()

end event

event ue_preview;call super::ue_preview;IF ib_preview THEN
	idw_1.Modify("DataWindow.Print.Preview=No")
	idw_1.Modify("datawindow.print.preview.zoom = " + String(idw_1.ii_zoom_actual))
	idw_1.title = "Reporte " + " (Zoom: " + String(idw_1.ii_zoom_actual) + "%)"
	SetPointer(hourglass!)
	ib_preview = FALSE
ELSE
	idw_1.Modify("DataWindow.Print.Preview=Yes")
	idw_1.Modify("datawindow.print.preview.zoom = " + String(idw_1.ii_zoom_actual))
	idw_1.title = "Reporte " + " (Zoom: " + String(idw_1.ii_zoom_actual) + "%)"
	SetPointer(hourglass!)
	ib_preview = TRUE
END IF
end event

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

event ue_print;call super::ue_print;idw_1.EVENT ue_print()
end event

event ue_filter;call super::ue_filter;idw_1.groupcalc()
end event

event ue_retrieve;call super::ue_retrieve;String ls_dolar, ls_texto

SELECT cod_dolares INTO :ls_dolar FROM logparam WHERE reckey='1';

IF rb_res.checked=TRUE THEN
	idw_1.DataObject='d_rpt_gastos_ventas_tot_tbl'
ELSE
	idw_1.DataObject='d_rpt_gastos_ventas_tot_det_tbl'	
END IF
idw_1.SetTransObject(Sqlca)
idw_1.visible = TRUE

ls_texto = 'Orden de Venta ' + TRIM(sle_oventa.text)

dw_report.retrieve(ls_dolar)
dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_empresa.text  = gs_empresa
dw_report.object.t_user.text 	   = gs_user
dw_report.object.t_texto.text 	= ls_texto
end event

type rb_det from radiobutton within w_ve739_gastos_venta_general
integer x = 1522
integer y = 200
integer width = 402
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Detalle"
end type

type rb_res from radiobutton within w_ve739_gastos_venta_general
integer x = 1522
integer y = 96
integer width = 402
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Resumen"
boolean checked = true
end type

type st_1 from statictext within w_ve739_gastos_venta_general
integer x = 59
integer y = 216
integer width = 265
integer height = 84
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "O.Venta :"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_oventa from singlelineedit within w_ve739_gastos_venta_general
integer x = 347
integer y = 212
integer width = 343
integer height = 84
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type cb_2 from commandbutton within w_ve739_gastos_venta_general
integer x = 704
integer y = 212
integer width = 78
integer height = 84
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;boolean 	lb_ret
String 	ls_codigo, ls_data, ls_sql 
date		ld_fecha1, ld_Fecha2

ld_fecha1 = uo_1.of_get_fecha1( )
ld_fecha2 = uo_1.of_get_fecha2( )

ls_sql = "SELECT OV.NRO_OV		   		 AS ORD_VENTA, "  &	
		 + "		  SUBSTR(OV.OBS,1,40) 	 AS OBSERVACION, "  &
		 + "		  OV.OT_GASTOS 	 		 AS NRO_ORDEN, "  &
		 + "		  TRUNC(OV.FEC_REGISTRO) AS FECHA  "  &
		 + "FROM ORDEN_VENTA OV "		&
		 + "WHERE OV.OT_GASTOS IS NOT NULL AND " & 
		 + "TO_CHAR(OV.FEC_REGISTRO, 'yyyymmdd') BETWEEN '" + string(ld_Fecha1, 'yyyymmdd') + "' and '" + string(ld_fecha2, 'yyyymmdd') + "'" 				
			 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

IF ls_codigo <> '' THEN
	sle_oventa.text  = ls_codigo
END IF
	
end event

type uo_1 from u_ingreso_rango_fechas within w_ve739_gastos_venta_general
integer x = 105
integer y = 104
integer taborder = 20
end type

event constructor;call super::constructor;of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
of_set_fecha(today(), today()) //para setear la fecha inicial
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final


end event

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

type cb_1 from commandbutton within w_ve739_gastos_venta_general
integer x = 2030
integer y = 140
integer width = 402
integer height = 112
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Procesar"
end type

event clicked;String ls_nro_ov, ls_dolar
Date   ld_fecha_inicial,ld_fecha_final


ls_nro_ov = Trim(sle_oventa.text)

//ld_fecha_inicial = uo_1.of_get_fecha1()
//ld_fecha_final   = uo_1.of_get_fecha2()

If IsNull(ls_nro_ov) OR Trim(ls_nro_ov) = '' THEN
	messagebox('Aviso', 'Defina orden de venta correctamente')
End If

declare PB_usp_vta_gastos_venta procedure for usp_vta_gastos_ventas(:ls_nro_ov);
execute PB_usp_vta_gastos_venta ;

IF SQLCA.SQLCode = -1 THEN 
	MessageBox("SQL error", SQLCA.SQLErrText)
	RollBack ;
	Return ;
END IF

close	PB_usp_vta_gastos_venta ;

parent.event ue_retrieve()


end event

type dw_report from u_dw_rpt within w_ve739_gastos_venta_general
integer x = 27
integer y = 348
integer width = 2569
integer height = 1272
string dataobject = "d_rpt_gastos_ventas_tot_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event doubleclicked;call super::doubleclicked;String ls_refer
Long ll_factor
str_parametros lstr_rep


if row=0 then  return

IF this.Rowcount() = 0 then return

ls_refer = this.object.flag_refer[row]

lstr_rep.string1 = ls_refer
//OpenSheetWithParm(w_ve739_gto_vta_gral_det, lstr_rep, w_main, 2, layered!)

end event

type gb_1 from groupbox within w_ve739_gastos_venta_general
integer x = 27
integer y = 28
integer width = 1938
integer height = 300
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Datos"
end type

