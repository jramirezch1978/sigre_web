$PBExportHeader$w_fi700_rpt_libro_bancos.srw
forward
global type w_fi700_rpt_libro_bancos from w_rpt
end type
type uo_fechas from u_ingreso_rango_fechas_v within w_fi700_rpt_libro_bancos
end type
type cb_2 from commandbutton within w_fi700_rpt_libro_bancos
end type
type dw_report from u_dw_rpt within w_fi700_rpt_libro_bancos
end type
type cb_1 from commandbutton within w_fi700_rpt_libro_bancos
end type
type gb_1 from groupbox within w_fi700_rpt_libro_bancos
end type
end forward

global type w_fi700_rpt_libro_bancos from w_rpt
integer width = 3589
integer height = 1364
string title = "(FI700) Reporte de Libro - Bancos "
string menuname = "m_reporte"
uo_fechas uo_fechas
cb_2 cb_2
dw_report dw_report
cb_1 cb_1
gb_1 gb_1
end type
global w_fi700_rpt_libro_bancos w_fi700_rpt_libro_bancos

on w_fi700_rpt_libro_bancos.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.uo_fechas=create uo_fechas
this.cb_2=create cb_2
this.dw_report=create dw_report
this.cb_1=create cb_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_fechas
this.Control[iCurrent+2]=this.cb_2
this.Control[iCurrent+3]=this.dw_report
this.Control[iCurrent+4]=this.cb_1
this.Control[iCurrent+5]=this.gb_1
end on

on w_fi700_rpt_libro_bancos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_fechas)
destroy(this.cb_2)
destroy(this.dw_report)
destroy(this.cb_1)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;Date	ld_fecha1, ld_fecha2, ld_hoy
idw_1 = dw_report
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

type uo_fechas from u_ingreso_rango_fechas_v within w_fi700_rpt_libro_bancos
event destroy ( )
integer x = 27
integer y = 52
integer taborder = 20
end type

on uo_fechas.destroy
call u_ingreso_rango_fechas_v::destroy
end on

event constructor;call super::constructor;Date	ld_fecha_actual

ld_fecha_actual = Date(gnvo_app.of_fecha_actual())

of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
of_set_fecha(gnvo_app.of_first_date(ld_fecha_actual), gnvo_app.of_last_date(ld_fecha_actual)) //para setear la fecha inicial
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final
end event

type cb_2 from commandbutton within w_fi700_rpt_libro_bancos
integer x = 722
integer y = 44
integer width = 471
integer height = 100
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Cuentas de Bancos"
end type

event clicked;Long ll_count
str_parametros sl_param 

Rollback ;

sl_param.dw1		= 'd_abc_cnta_bco_help_rpt_tbl'
sl_param.titulo	= 'Cuenta de Banco'
sl_param.opcion   = 8
sl_param.db1 		= 1600
sl_param.string1 	= '1RPP'

OpenWithParm( w_abc_seleccion_lista_search, sl_param)
end event

type dw_report from u_dw_rpt within w_fi700_rpt_libro_bancos
integer y = 276
integer width = 3511
integer height = 748
integer taborder = 20
string dataobject = "d_rpt_libro_bancos_tbl"
end type

type cb_1 from commandbutton within w_fi700_rpt_libro_bancos
integer x = 722
integer y = 140
integer width = 471
integer height = 100
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "&Procesar"
end type

event clicked;Date 		ld_fecha_inicio,ld_fecha_final
string	ls_mensaje

ld_fecha_inicio = uo_fechas.of_get_fecha1( )
ld_fecha_final  = uo_fechas.of_get_fecha2( )

DECLARE USP_FIN_RPT_LIBRO_BANCOS PROCEDURE FOR 
	USP_FIN_RPT_LIBRO_BANCOS(:ld_fecha_inicio,
									 :ld_fecha_final);
EXECUTE USP_FIN_RPT_LIBRO_BANCOS ;

IF SQLCA.SQLCode = -1 THEN 
	ls_mensaje = 'PROCEDURE USP_FIN_RPT_LIBRO_BANCOS: ' + SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Error ', ls_mensaje)
	Return
END IF

CLOSE USP_FIN_RPT_LIBRO_BANCOS;

dw_report.Retrieve(String(ld_fecha_inicio),String(ld_fecha_final),gs_empresa,gs_user)
dw_report.Object.p_logo.filename = gs_logo
end event

type gb_1 from groupbox within w_fi700_rpt_libro_bancos
integer width = 1737
integer height = 264
integer taborder = 20
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

