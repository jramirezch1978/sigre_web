$PBExportHeader$w_ve726_rpt_cobrar_x_confin.srw
forward
global type w_ve726_rpt_cobrar_x_confin from w_rpt
end type
type rb_5 from radiobutton within w_ve726_rpt_cobrar_x_confin
end type
type rb_4 from radiobutton within w_ve726_rpt_cobrar_x_confin
end type
type rb_1 from radiobutton within w_ve726_rpt_cobrar_x_confin
end type
type rb_2 from radiobutton within w_ve726_rpt_cobrar_x_confin
end type
type rb_3 from radiobutton within w_ve726_rpt_cobrar_x_confin
end type
type cbx_1 from checkbox within w_ve726_rpt_cobrar_x_confin
end type
type dw_arg from datawindow within w_ve726_rpt_cobrar_x_confin
end type
type cb_2 from commandbutton within w_ve726_rpt_cobrar_x_confin
end type
type dw_report from u_dw_rpt within w_ve726_rpt_cobrar_x_confin
end type
type cb_1 from commandbutton within w_ve726_rpt_cobrar_x_confin
end type
type gb_1 from groupbox within w_ve726_rpt_cobrar_x_confin
end type
type gb_2 from groupbox within w_ve726_rpt_cobrar_x_confin
end type
type gb_3 from groupbox within w_ve726_rpt_cobrar_x_confin
end type
type gb_4 from groupbox within w_ve726_rpt_cobrar_x_confin
end type
end forward

global type w_ve726_rpt_cobrar_x_confin from w_rpt
integer width = 3182
integer height = 944
string title = "[VE726] Reporte de Ventas x Concepto Financiero"
string menuname = "m_reporte"
long backcolor = 67108864
boolean ib_preview = true
rb_5 rb_5
rb_4 rb_4
rb_1 rb_1
rb_2 rb_2
rb_3 rb_3
cbx_1 cbx_1
dw_arg dw_arg
cb_2 cb_2
dw_report dw_report
cb_1 cb_1
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
gb_4 gb_4
end type
global w_ve726_rpt_cobrar_x_confin w_ve726_rpt_cobrar_x_confin

on w_ve726_rpt_cobrar_x_confin.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.rb_5=create rb_5
this.rb_4=create rb_4
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rb_3=create rb_3
this.cbx_1=create cbx_1
this.dw_arg=create dw_arg
this.cb_2=create cb_2
this.dw_report=create dw_report
this.cb_1=create cb_1
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
this.gb_4=create gb_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_5
this.Control[iCurrent+2]=this.rb_4
this.Control[iCurrent+3]=this.rb_1
this.Control[iCurrent+4]=this.rb_2
this.Control[iCurrent+5]=this.rb_3
this.Control[iCurrent+6]=this.cbx_1
this.Control[iCurrent+7]=this.dw_arg
this.Control[iCurrent+8]=this.cb_2
this.Control[iCurrent+9]=this.dw_report
this.Control[iCurrent+10]=this.cb_1
this.Control[iCurrent+11]=this.gb_1
this.Control[iCurrent+12]=this.gb_2
this.Control[iCurrent+13]=this.gb_3
this.Control[iCurrent+14]=this.gb_4
end on

on w_ve726_rpt_cobrar_x_confin.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_5)
destroy(this.rb_4)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_3)
destroy(this.cbx_1)
destroy(this.dw_arg)
destroy(this.cb_2)
destroy(this.dw_report)
destroy(this.cb_1)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_3)
destroy(this.gb_4)
end on

event ue_open_pre();call super::ue_open_pre;idw_1 = dw_report
idw_1.Visible = TRUE
idw_1.SetTransObject(sqlca)
THIS.Event ue_preview()


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

type rb_5 from radiobutton within w_ve726_rpt_cobrar_x_confin
integer x = 2427
integer y = 292
integer width = 270
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Articulo"
end type

type rb_4 from radiobutton within w_ve726_rpt_cobrar_x_confin
integer x = 2139
integer y = 292
integer width = 283
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "General"
boolean checked = true
end type

type rb_1 from radiobutton within w_ve726_rpt_cobrar_x_confin
integer x = 1646
integer y = 112
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
string text = "Soles"
boolean checked = true
end type

type rb_2 from radiobutton within w_ve726_rpt_cobrar_x_confin
integer x = 1646
integer y = 200
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
string text = "Dolares"
end type

type rb_3 from radiobutton within w_ve726_rpt_cobrar_x_confin
integer x = 1646
integer y = 288
integer width = 357
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Ambos tipos "
end type

type cbx_1 from checkbox within w_ve726_rpt_cobrar_x_confin
integer x = 997
integer y = 288
integer width = 553
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Todos Los Origenes"
end type

type dw_arg from datawindow within w_ve726_rpt_cobrar_x_confin
integer x = 69
integer y = 96
integer width = 951
integer height = 272
integer taborder = 20
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

type cb_2 from commandbutton within w_ve726_rpt_cobrar_x_confin
integer x = 2240
integer y = 100
integer width = 329
integer height = 100
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Seleccion..."
end type

event clicked;Long ll_count
str_parametros sl_param 


Rollback ;

sl_param.dw1		= 'd_abc_lista_cf_fac_x_cobrar_tbl'
sl_param.titulo	= 'Concepto Financiero'
sl_param.opcion   = 16
sl_param.db1 		= 1600
sl_param.string1 	= '1CF'




OpenWithParm( w_abc_seleccion_lista_search, sl_param)

end event

type dw_report from u_dw_rpt within w_ve726_rpt_cobrar_x_confin
integer x = 37
integer y = 416
integer width = 3040
integer height = 260
integer taborder = 20
boolean hscrollbar = true
boolean vscrollbar = true
integer ii_zoom_actual = 100
end type

type cb_1 from commandbutton within w_ve726_rpt_cobrar_x_confin
integer x = 2743
integer y = 288
integer width = 334
integer height = 100
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Aceptar"
boolean default = true
end type

event clicked;Date   ld_fecha_inicio,ld_fecha_final
String ls_cod_origen

dw_arg.Accepttext()

ld_fecha_inicio = dw_arg.object.ad_fecha_inicio [1]
ld_fecha_final  = dw_arg.object.ad_fecha_final  [1]
ls_cod_origen   = dw_arg.object.cod_origen	   [1]

IF rb_1.checked = FALSE and rb_2.checked = FALSE and rb_3.checked = FALSE THEN
	messagebox('Advertencia','Debe Seleccionar un tipo de Moneda')
	Return
END IF

IF cbx_1.CHECKED THEN
	ls_cod_origen = '%'
ELSE
	IF Isnull(ls_cod_origen) OR Trim(ls_cod_origen) = '' THEN
		Messagebox('Aviso','Debe Ingresar Codigo de Origen , Verifique!')
		Return
	ELSE
		ls_cod_origen = ls_cod_origen+'%'
	END IF
END IF

if rb_4.checked = true then
	
	// Selecciona dw x tipo de Moneda
	IF rb_1.checked = TRUE  THEN
		dw_report.DataObject = 'd_rpt_confin_x_cobrar_soles_tbl'
	END IF
	IF rb_2.checked = TRUE  THEN
		dw_report.DataObject = 'd_rpt_confin_x_cobrar_dolar_tbl'
	END IF
	IF rb_3.checked = TRUE  THEN
		dw_report.DataObject = 'd_rpt_confin_x_cobrar_tbl'
	END IF
	
else
	
	// Selecciona dw x tipo de Moneda
	IF rb_1.checked = TRUE  THEN
		dw_report.DataObject = 'd_rpt_confin_x_cobrar_soles_art_tbl'
	END IF
	IF rb_2.checked = TRUE  THEN
		dw_report.DataObject = 'd_rpt_confin_x_cobrar_dolar_art_tbl'
	END IF
	IF rb_3.checked = TRUE  THEN
		dw_report.DataObject = 'd_rpt_confin_x_cobrar_art_tbl'
	END IF

end if

idw_1 = dw_report
idw_1.Visible = TRUE
idw_1.SetTransObject(sqlca)
dw_report.Retrieve(ld_fecha_inicio,ld_fecha_final,ls_cod_origen,gs_empresa,gs_user)
dw_report.Object.p_logo.filename = gs_logo
end event

type gb_1 from groupbox within w_ve726_rpt_cobrar_x_confin
integer x = 37
integer y = 32
integer width = 1541
integer height = 356
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Opciones"
end type

type gb_2 from groupbox within w_ve726_rpt_cobrar_x_confin
integer x = 1609
integer y = 32
integer width = 480
integer height = 356
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Moneda"
end type

type gb_3 from groupbox within w_ve726_rpt_cobrar_x_confin
integer x = 2121
integer y = 32
integer width = 590
integer height = 196
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Concepto Financiero"
end type

type gb_4 from groupbox within w_ve726_rpt_cobrar_x_confin
integer x = 2121
integer y = 224
integer width = 590
integer height = 164
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Tipo"
end type

