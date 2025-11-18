$PBExportHeader$w_ve750_detalle_consignatario.srw
forward
global type w_ve750_detalle_consignatario from w_rpt
end type
type sle_nom_consignatario from singlelineedit within w_ve750_detalle_consignatario
end type
type cb_3 from commandbutton within w_ve750_detalle_consignatario
end type
type sle_consignatario from singlelineedit within w_ve750_detalle_consignatario
end type
type st_2 from statictext within w_ve750_detalle_consignatario
end type
type uo_1 from u_ingreso_rango_fechas within w_ve750_detalle_consignatario
end type
type cb_1 from commandbutton within w_ve750_detalle_consignatario
end type
type dw_report from u_dw_rpt within w_ve750_detalle_consignatario
end type
type gb_1 from groupbox within w_ve750_detalle_consignatario
end type
end forward

global type w_ve750_detalle_consignatario from w_rpt
integer width = 3799
integer height = 2404
string title = "[VE750] Detalle por Consignatario (Facturacion Simplificada)"
string menuname = "m_reporte"
sle_nom_consignatario sle_nom_consignatario
cb_3 cb_3
sle_consignatario sle_consignatario
st_2 st_2
uo_1 uo_1
cb_1 cb_1
dw_report dw_report
gb_1 gb_1
end type
global w_ve750_detalle_consignatario w_ve750_detalle_consignatario

on w_ve750_detalle_consignatario.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.sle_nom_consignatario=create sle_nom_consignatario
this.cb_3=create cb_3
this.sle_consignatario=create sle_consignatario
this.st_2=create st_2
this.uo_1=create uo_1
this.cb_1=create cb_1
this.dw_report=create dw_report
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_nom_consignatario
this.Control[iCurrent+2]=this.cb_3
this.Control[iCurrent+3]=this.sle_consignatario
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.uo_1
this.Control[iCurrent+6]=this.cb_1
this.Control[iCurrent+7]=this.dw_report
this.Control[iCurrent+8]=this.gb_1
end on

on w_ve750_detalle_consignatario.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_nom_consignatario)
destroy(this.cb_3)
destroy(this.sle_consignatario)
destroy(this.st_2)
destroy(this.uo_1)
destroy(this.cb_1)
destroy(this.dw_report)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report
idw_1.Visible = true
idw_1.SetTransObject(sqlca)



//datos de reporte
ib_preview = true
This.Event ue_preview()

dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_empresa.text = gs_empresa
dw_report.object.t_user.text = gs_user

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

event ue_saveas;call super::ue_saveas;idw_1.EVENT ue_saveas()
end event

event ue_zoom;call super::ue_zoom;idw_1.EVENT ue_zoom(ai_zoom)
end event

type sle_nom_consignatario from singlelineedit within w_ve750_detalle_consignatario
integer x = 951
integer y = 212
integer width = 1545
integer height = 76
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type cb_3 from commandbutton within w_ve750_detalle_consignatario
integer x = 832
integer y = 212
integer width = 114
integer height = 80
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;string ls_sql, ls_codigo, ls_data
boolean lb_ret

ls_sql = "select distinct " &
		 + "       p.proveedor as consignatario, " &
		 + "       p.nom_proveedor as nom_consignatario, " &
		 + "       decode(p.tipo_doc_ident, '6', p.ruc, p.nro_doc_ident) as ruc_dni " &
		 + "from fs_factura_simpl_pagos fp, " &
		 + "     proveedor              p " &
		 + "where fp.consignatario = p.proveedor " 
			 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
	
if ls_codigo <> '' then
	sle_consignatario.text		= ls_codigo
	sle_nom_consignatario.text	= ls_data
end if
end event

type sle_consignatario from singlelineedit within w_ve750_detalle_consignatario
integer x = 480
integer y = 212
integer width = 343
integer height = 76
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type st_2 from statictext within w_ve750_detalle_consignatario
integer x = 78
integer y = 220
integer width = 389
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Consignatario :"
alignment alignment = right!
boolean focusrectangle = false
end type

type uo_1 from u_ingreso_rango_fechas within w_ve750_detalle_consignatario
event destroy ( )
integer x = 64
integer y = 80
integer taborder = 30
end type

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
of_set_fecha(date(today()),date(today()))
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final


end event

type cb_1 from commandbutton within w_ve750_detalle_consignatario
integer x = 2057
integer y = 52
integer width = 425
integer height = 148
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Reporte"
end type

event clicked;String 	ls_consignatario
Date		ld_Fecha1, ld_fecha2


//para leer las fechas
ld_fecha1 = uo_1.of_get_fecha1()
ld_fecha2  = uo_1.of_get_fecha2()
ls_consignatario = sle_consignatario.text

if trim(ls_consignatario) = '' then
	Messagebox('Aviso','Debe especificar un consignatario, por favor verifique!', StopSign!)
	sle_consignatario.setFocus()
	return
end if

dw_report.Settransobject( sqlca)
dw_report.Retrieve(ld_fecha1, ld_fecha2, ls_consignatario)

//datos de reporte
ib_preview = true
Parent.Event ue_preview()

dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_empresa.text  = gs_empresa
dw_report.object.t_user.text     = gs_user
dw_report.object.t_titulo1.text  = 'DEL ' + string(ld_fecha1, 'dd/mm/yyyy') + ' AL ' + string(ld_fecha2, 'dd/mm/yyyy')

end event

type dw_report from u_dw_rpt within w_ve750_detalle_consignatario
integer y = 312
integer width = 3310
integer height = 1748
string dataobject = "d_rpt_detalle_consignatario_tbl"
boolean livescroll = false
end type

type gb_1 from groupbox within w_ve750_detalle_consignatario
integer width = 2537
integer height = 304
integer taborder = 30
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

