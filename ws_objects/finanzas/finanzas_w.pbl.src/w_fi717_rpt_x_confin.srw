$PBExportHeader$w_fi717_rpt_x_confin.srw
forward
global type w_fi717_rpt_x_confin from w_rpt
end type
type rb_caja_bco from radiobutton within w_fi717_rpt_x_confin
end type
type rb_pagar from radiobutton within w_fi717_rpt_x_confin
end type
type rb_cobrar from radiobutton within w_fi717_rpt_x_confin
end type
type dw_arg from datawindow within w_fi717_rpt_x_confin
end type
type dw_report from u_dw_rpt within w_fi717_rpt_x_confin
end type
type cb_1 from commandbutton within w_fi717_rpt_x_confin
end type
type gb_1 from groupbox within w_fi717_rpt_x_confin
end type
type gb_5 from groupbox within w_fi717_rpt_x_confin
end type
end forward

global type w_fi717_rpt_x_confin from w_rpt
integer width = 3607
integer height = 1452
string title = "Reporte x Concepto Financiero"
string menuname = "m_reporte"
rb_caja_bco rb_caja_bco
rb_pagar rb_pagar
rb_cobrar rb_cobrar
dw_arg dw_arg
dw_report dw_report
cb_1 cb_1
gb_1 gb_1
gb_5 gb_5
end type
global w_fi717_rpt_x_confin w_fi717_rpt_x_confin

type variables
str_seleccionar istr_seleccionar
String is_und_art
end variables

on w_fi717_rpt_x_confin.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.rb_caja_bco=create rb_caja_bco
this.rb_pagar=create rb_pagar
this.rb_cobrar=create rb_cobrar
this.dw_arg=create dw_arg
this.dw_report=create dw_report
this.cb_1=create cb_1
this.gb_1=create gb_1
this.gb_5=create gb_5
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_caja_bco
this.Control[iCurrent+2]=this.rb_pagar
this.Control[iCurrent+3]=this.rb_cobrar
this.Control[iCurrent+4]=this.dw_arg
this.Control[iCurrent+5]=this.dw_report
this.Control[iCurrent+6]=this.cb_1
this.Control[iCurrent+7]=this.gb_1
this.Control[iCurrent+8]=this.gb_5
end on

on w_fi717_rpt_x_confin.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_caja_bco)
destroy(this.rb_pagar)
destroy(this.rb_cobrar)
destroy(this.dw_arg)
destroy(this.dw_report)
destroy(this.cb_1)
destroy(this.gb_1)
destroy(this.gb_5)
end on

event ue_open_pre();call super::ue_open_pre;//idw_1 = dw_report
//idw_1.Visible = TRUE
//idw_1.SetTransObject(sqlca)
//ib_preview = FALSE
//THIS.Event ue_preview()
////
//
// ii_help = 101           // help topic


end event

event ue_preview();call super::ue_preview;IF ib_preview THEN
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

event ue_print();call super::ue_print;idw_1.EVENT ue_print()
end event

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

type rb_caja_bco from radiobutton within w_fi717_rpt_x_confin
integer x = 1179
integer y = 284
integer width = 882
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Caja Bancos x Concepto Financiero   "
end type

type rb_pagar from radiobutton within w_fi717_rpt_x_confin
integer x = 1179
integer y = 208
integer width = 1042
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Cuentas Por Pagar x Concepto Financiero     "
end type

type rb_cobrar from radiobutton within w_fi717_rpt_x_confin
integer x = 1179
integer y = 128
integer width = 1280
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Cuentas Por Cobrar x Concepto Financiero"
end type

type dw_arg from datawindow within w_fi717_rpt_x_confin
integer x = 96
integer y = 152
integer width = 951
integer height = 188
integer taborder = 10
string title = "none"
string dataobject = "d_ext_fechas_origen_tbl"
boolean border = false
boolean livescroll = true
end type

event itemchanged;Accepttext()
end event

event constructor;Settransobject(sqlca)
Insertrow(0)
end event

event doubleclicked;Datawindow		 ldw	
str_seleccionar lstr_seleccionar



CHOOSE CASE dwo.name
		 CASE 'ad_fecha_inicio'
				ldw = This
				f_call_calendar(ldw,dwo.name,dwo.coltype, row)		
		 CASE 'ad_fecha_final'				
				ldw = This
				f_call_calendar(ldw,dwo.name,dwo.coltype, row)					
							
END CHOOSE


end event

type dw_report from u_dw_rpt within w_fi717_rpt_x_confin
integer x = 32
integer y = 436
integer width = 3511
integer height = 928
integer taborder = 120
end type

type cb_1 from commandbutton within w_fi717_rpt_x_confin
integer x = 2798
integer y = 64
integer width = 613
integer height = 112
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "&Procesar"
end type

event clicked;Date   ld_fecha_inicio,ld_fecha_final
String ls_cod_origen, ls_cod_art, ls_moneda

dw_arg.Accepttext()
ld_fecha_inicio = dw_arg.object.ad_fecha_inicio [1]
ld_fecha_final  = dw_arg.object.ad_fecha_final  [1]

IF rb_pagar.checked = FALSE and rb_cobrar.checked = FALSE and rb_caja_bco.checked = FALSE THEN
	messagebox('Advertencia','Debe Seleccionar un tipo de Reporte')
	Return
END IF

IF rb_cobrar.checked = TRUE THEN
	dw_report.DataObject = 'd_rpt_cntas_cobrar_confin'
END IF
IF rb_pagar.checked = TRUE THEN
	dw_report.DataObject = 'd_rpt_cntas_pagar_confin'
END IF
IF rb_caja_bco.checked = TRUE THEN
	dw_report.DataObject = 'd_rpt_caja_bco_confin'
END IF

idw_1 = dw_report
idw_1.Visible = TRUE
idw_1.SetTransObject(sqlca)
ib_preview = FALSE
Parent.Event ue_preview()
dw_report.Retrieve(ld_fecha_inicio, ld_fecha_final )

dw_report.Object.p_logo.filename = gs_logo
dw_report.Object.t_empresa.text = gs_empresa
dw_report.Object.t_user.text = gs_user
dw_report.Object.t_fecha.text = 'Del: ' + string(ld_fecha_inicio,'dd/mm/yyyy') + ' Al ' + String(ld_fecha_final,'dd/mm/yyyy')




end event

type gb_1 from groupbox within w_fi717_rpt_x_confin
integer x = 41
integer y = 32
integer width = 1065
integer height = 376
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Parametros de Busqueda"
end type

type gb_5 from groupbox within w_fi717_rpt_x_confin
integer x = 1134
integer y = 32
integer width = 1499
integer height = 376
integer taborder = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Tipo de Reporte"
end type

