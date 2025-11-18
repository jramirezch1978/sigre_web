$PBExportHeader$w_fi722_rpt_pagar_directo.srw
forward
global type w_fi722_rpt_pagar_directo from w_rpt
end type
type uo_1 from u_ingreso_rango_fechas within w_fi722_rpt_pagar_directo
end type
type cb_2 from commandbutton within w_fi722_rpt_pagar_directo
end type
type cb_1 from commandbutton within w_fi722_rpt_pagar_directo
end type
type dw_report from u_dw_rpt within w_fi722_rpt_pagar_directo
end type
type gb_1 from groupbox within w_fi722_rpt_pagar_directo
end type
end forward

global type w_fi722_rpt_pagar_directo from w_rpt
integer width = 3227
integer height = 1956
string title = "Doc. Pagar Directo (FI722)"
string menuname = "m_reporte"
uo_1 uo_1
cb_2 cb_2
cb_1 cb_1
dw_report dw_report
gb_1 gb_1
end type
global w_fi722_rpt_pagar_directo w_fi722_rpt_pagar_directo

on w_fi722_rpt_pagar_directo.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.uo_1=create uo_1
this.cb_2=create cb_2
this.cb_1=create cb_1
this.dw_report=create dw_report
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_1
this.Control[iCurrent+2]=this.cb_2
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.dw_report
this.Control[iCurrent+5]=this.gb_1
end on

on w_fi722_rpt_pagar_directo.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_1)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.dw_report)
destroy(this.gb_1)
end on

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report
idw_1.SetTransObject(sqlca)


//prevista
ib_preview = FALSE
This.Event ue_preview()
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

event ue_print;call super::ue_print;idw_1.EVENT ue_print()
end event

type uo_1 from u_ingreso_rango_fechas within w_fi722_rpt_pagar_directo
integer x = 46
integer y = 88
integer taborder = 20
end type

event constructor;call super::constructor;of_set_label('Desde:','Hasta:') // para seatear el titulo del boton

of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final
//of_set_fecha(date('01/01/1900'), date('31/12/9999') //para setear la fecha inicial


end event

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

type cb_2 from commandbutton within w_fi722_rpt_pagar_directo
integer x = 2053
integer y = 36
integer width = 512
integer height = 128
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Procesar"
end type

event clicked;Date ld_fecha1, ld_fecha2



ld_fecha1 = uo_1.of_get_fecha1()
ld_fecha2  = uo_1.of_get_fecha2()

dw_report.object.DataWindow.Print.Orientation = 2

dw_report.retrieve(ld_fecha1, ld_fecha2)
dw_report.object.p_logo.filename = gs_logo


delete from tt_fin_tipo_doc ;
end event

type cb_1 from commandbutton within w_fi722_rpt_pagar_directo
integer x = 1536
integer y = 40
integer width = 512
integer height = 128
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Tipos de Documento"
end type

event clicked;String ls_tipo_doc
Long   ll_inicio

Str_seleccionar lstr_seleccionar

lstr_seleccionar.s_seleccion = 'M'
lstr_seleccionar.s_sql = 'SELECT VW_FIN_DOC_X_GRUPO_PAGAR.TIPO_DOC AS CODIGO_DOC,'&
									    +'VW_FIN_DOC_X_GRUPO_PAGAR.DESC_TIPO_DOC AS DESCRIPCION '&
  										 +'FROM VW_FIN_DOC_X_GRUPO_PAGAR '  
														
OpenWithParm(w_seleccionar,lstr_seleccionar)
IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
   IF lstr_seleccionar.s_action = "aceptar" THEN
		
		For ll_inicio = 1 to UpperBound(lstr_seleccionar.param1)
			 ls_tipo_doc = lstr_seleccionar.param1[ll_inicio]
			 
			 Insert Into tt_fin_tipo_doc (tipo_doc)
			 Values (:ls_tipo_doc) ;
			 
		Next	 
		
   END IF	
end event

type dw_report from u_dw_rpt within w_fi722_rpt_pagar_directo
integer y = 220
integer width = 3136
integer height = 1496
string dataobject = "d_rpt_directos_x_referencia_tbl"
end type

event ue_filter;call super::ue_filter;This.GroupCalc()
end event

type gb_1 from groupbox within w_fi722_rpt_pagar_directo
integer width = 1472
integer height = 208
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Ingrese Fechas"
end type

