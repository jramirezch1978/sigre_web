$PBExportHeader$w_ope700_solicitud_ot.srw
forward
global type w_ope700_solicitud_ot from w_rpt
end type
type uo_1 from u_ingreso_rango_fechas within w_ope700_solicitud_ot
end type
type dw_report from u_dw_rpt within w_ope700_solicitud_ot
end type
type rb_2 from radiobutton within w_ope700_solicitud_ot
end type
type rb_1 from radiobutton within w_ope700_solicitud_ot
end type
type cb_2 from commandbutton within w_ope700_solicitud_ot
end type
type cb_1 from commandbutton within w_ope700_solicitud_ot
end type
type cbx_4 from checkbox within w_ope700_solicitud_ot
end type
type cbx_3 from checkbox within w_ope700_solicitud_ot
end type
type cbx_2 from checkbox within w_ope700_solicitud_ot
end type
type cbx_1 from checkbox within w_ope700_solicitud_ot
end type
type gb_1 from groupbox within w_ope700_solicitud_ot
end type
type gb_2 from groupbox within w_ope700_solicitud_ot
end type
end forward

global type w_ope700_solicitud_ot from w_rpt
integer width = 3566
integer height = 1812
string title = "Solicitud de Orden de Trabajo (OPE700)"
string menuname = "m_rpt_smpl"
long backcolor = 67108864
uo_1 uo_1
dw_report dw_report
rb_2 rb_2
rb_1 rb_1
cb_2 cb_2
cb_1 cb_1
cbx_4 cbx_4
cbx_3 cbx_3
cbx_2 cbx_2
cbx_1 cbx_1
gb_1 gb_1
gb_2 gb_2
end type
global w_ope700_solicitud_ot w_ope700_solicitud_ot

on w_ope700_solicitud_ot.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_smpl" then this.MenuID = create m_rpt_smpl
this.uo_1=create uo_1
this.dw_report=create dw_report
this.rb_2=create rb_2
this.rb_1=create rb_1
this.cb_2=create cb_2
this.cb_1=create cb_1
this.cbx_4=create cbx_4
this.cbx_3=create cbx_3
this.cbx_2=create cbx_2
this.cbx_1=create cbx_1
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_1
this.Control[iCurrent+2]=this.dw_report
this.Control[iCurrent+3]=this.rb_2
this.Control[iCurrent+4]=this.rb_1
this.Control[iCurrent+5]=this.cb_2
this.Control[iCurrent+6]=this.cb_1
this.Control[iCurrent+7]=this.cbx_4
this.Control[iCurrent+8]=this.cbx_3
this.Control[iCurrent+9]=this.cbx_2
this.Control[iCurrent+10]=this.cbx_1
this.Control[iCurrent+11]=this.gb_1
this.Control[iCurrent+12]=this.gb_2
end on

on w_ope700_solicitud_ot.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_1)
destroy(this.dw_report)
destroy(this.rb_2)
destroy(this.rb_1)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.cbx_4)
destroy(this.cbx_3)
destroy(this.cbx_2)
destroy(this.cbx_1)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report
idw_1.SetTransObject(sqlca)
idw_1.ii_zoom_actual = 95
THIS.Event ue_preview()
//This.Event ue_retrieve()

// ii_help = 101           // help topic

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

type uo_1 from u_ingreso_rango_fechas within w_ope700_solicitud_ot
integer x = 859
integer y = 92
integer taborder = 40
end type

event constructor;call super::constructor;of_set_label('Desde:','Hasta:') //para setear la fecha inicial
//of_set_fecha(date('01/01/1900'), date('31/12/9999') // para seatear el titulo del boton
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final


end event

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

type dw_report from u_dw_rpt within w_ope700_solicitud_ot
integer x = 18
integer y = 380
integer width = 3497
integer height = 1212
integer taborder = 40
string dataobject = "d_cons_soli_ord_tra_sol"
boolean hscrollbar = true
boolean vscrollbar = true
end type

type rb_2 from radiobutton within w_ope700_solicitud_ot
integer x = 2231
integer y = 136
integer width = 768
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Centro de Costo Responsable"
end type

type rb_1 from radiobutton within w_ope700_solicitud_ot
integer x = 2231
integer y = 44
integer width = 768
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Centro de Costo Solicitante"
end type

type cb_2 from commandbutton within w_ope700_solicitud_ot
integer x = 3072
integer y = 148
integer width = 434
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Procesar"
end type

event clicked;String ls_cadena []
Long   ll_count,ll_count_arr
Date   ld_fecha_inicio,ld_fecha_final

dw_report.object.DataWindow.Print.Orientation = 1

//estados de la solicitud ot
IF cbx_1.checked THEN //ANULADO
	ls_cadena [1] = '0'
END IF

IF cbx_2.checked THEN //ACTIVO
	ll_count_arr = UpperBound(ls_cadena)
	ls_cadena [ll_count_arr + 1] = '1'
END IF

IF cbx_3.checked THEN //CERRADO
	ll_count_arr = UpperBound(ls_cadena)
	ls_cadena [ll_count_arr + 1] = '2'
END IF

IF cbx_4.checked THEN //PROYECTADO
	ll_count_arr = UpperBound(ls_cadena)
	ls_cadena [ll_count_arr + 1] = '3'
END IF


IF UpperBound(ls_cadena) = 0 THEN
	Messagebox('Aviso','Debe Seleccionar algun Estado de la Solicitud de Orden Trabajo')
	Return
END IF

//Seleccionar centro de costo
select count(*) into :ll_count from tt_ope_cencos ;

IF ll_count = 0 THEN
	Messagebox('Aviso','Debe Seleccionar algun Centro de Costo , Verifique!')
	Return
END IF

IF rb_1.checked THEN     // Solicitante
	dw_report.dataobject = 'd_cons_soli_ord_tra_sol'
ELSEIF rb_2.checked THEN // Responsable
	dw_report.dataobject = 'd_cons_soli_ord_tra_resp'
END IF

//rango de fechas
ld_fecha_inicio = uo_1.of_get_fecha1()
ld_fecha_final  = uo_1.of_get_fecha2()

dw_report.Settransobject(sqlca)
ib_preview = FALSE
Parent.TriggerEvent('ue_preview')
dw_report.retrieve(ls_cadena,ld_fecha_inicio,ld_fecha_final,gs_empresa,gs_user)
dw_report.Object.p_logo.filename = gs_logo
dw_report.object.DataWindow.Print.Orientation = 1

end event

type cb_1 from commandbutton within w_ope700_solicitud_ot
integer x = 3072
integer y = 36
integer width = 434
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Centro de Costo"
end type

event clicked;Long ll_count
str_parametros sl_param 


Rollback ;

sl_param.dw1		= 'd_abc_lista_cencos_tbl'
sl_param.titulo	= 'Centros de Costo'
sl_param.opcion   = 19
sl_param.db1 		= 1600
sl_param.string1 	= '1CCOS'



OpenWithParm( w_abc_seleccion_lista_search, sl_param)

end event

type cbx_4 from checkbox within w_ope700_solicitud_ot
integer x = 448
integer y = 96
integer width = 343
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Rechazado"
end type

type cbx_3 from checkbox within w_ope700_solicitud_ot
integer x = 64
integer y = 256
integer width = 343
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Aceptado"
end type

type cbx_2 from checkbox within w_ope700_solicitud_ot
integer x = 64
integer y = 176
integer width = 343
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Pendiente "
end type

type cbx_1 from checkbox within w_ope700_solicitud_ot
integer x = 64
integer y = 96
integer width = 343
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Anulado"
end type

type gb_1 from groupbox within w_ope700_solicitud_ot
integer x = 18
integer y = 20
integer width = 786
integer height = 324
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Estados de la Solicitud OT"
end type

type gb_2 from groupbox within w_ope700_solicitud_ot
integer x = 818
integer y = 20
integer width = 1371
integer height = 192
integer taborder = 30
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

