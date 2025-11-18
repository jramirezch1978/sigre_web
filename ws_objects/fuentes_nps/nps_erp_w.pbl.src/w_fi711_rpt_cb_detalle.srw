$PBExportHeader$w_fi711_rpt_cb_detalle.srw
forward
global type w_fi711_rpt_cb_detalle from w_rpt
end type
type cb_2 from commandbutton within w_fi711_rpt_cb_detalle
end type
type dw_1 from datawindow within w_fi711_rpt_cb_detalle
end type
type dw_report from u_dw_rpt within w_fi711_rpt_cb_detalle
end type
type cb_1 from commandbutton within w_fi711_rpt_cb_detalle
end type
end forward

global type w_fi711_rpt_cb_detalle from w_rpt
integer width = 3589
integer height = 1452
string title = "Reporte de Movimiento del detalle de Caja Bancos  (FI711)"
string menuname = "m_impresion"
long backcolor = 67108864
cb_2 cb_2
dw_1 dw_1
dw_report dw_report
cb_1 cb_1
end type
global w_fi711_rpt_cb_detalle w_fi711_rpt_cb_detalle

type variables
str_seleccionar istr_seleccionar
end variables

on w_fi711_rpt_cb_detalle.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.cb_2=create cb_2
this.dw_1=create dw_1
this.dw_report=create dw_report
this.cb_1=create cb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_2
this.Control[iCurrent+2]=this.dw_1
this.Control[iCurrent+3]=this.dw_report
this.Control[iCurrent+4]=this.cb_1
end on

on w_fi711_rpt_cb_detalle.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_2)
destroy(this.dw_1)
destroy(this.dw_report)
destroy(this.cb_1)
end on

event ue_open_pre();call super::ue_open_pre;idw_1 = dw_report
idw_1.Visible = TRUE
idw_1.SetTransObject(sqlca)
ib_preview = FALSE
THIS.Event ue_preview()
//
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

type ole_skin from w_rpt`ole_skin within w_fi711_rpt_cb_detalle
end type

type cb_2 from commandbutton within w_fi711_rpt_cb_detalle
integer x = 3045
integer y = 12
integer width = 471
integer height = 112
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "&Cuenta de Banco"
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

type dw_1 from datawindow within w_fi711_rpt_cb_detalle
integer x = 27
integer y = 16
integer width = 722
integer height = 236
integer taborder = 50
string dataobject = "d_ext_ano_mes_tbl"
boolean border = false
boolean livescroll = true
end type

event constructor;Settransobject(sqlca)
InsertRow(0)
end event

type dw_report from u_dw_rpt within w_fi711_rpt_cb_detalle
integer y = 264
integer width = 3511
integer height = 844
integer taborder = 120
string dataobject = "d_rpt_rel_caja_bancos_det_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

type cb_1 from commandbutton within w_fi711_rpt_cb_detalle
integer x = 3045
integer y = 132
integer width = 471
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

event clicked;Long 		ll_ano,ll_mes
String 	ls_mes, ls_mensaje

dw_1.accepttext()

ll_ano = dw_1.object.ano [1]
ll_mes = dw_1.object.mes [1]

IF Isnull(ll_ano) THEN
	Messagebox('Aviso','Debe Ingresar Un Año A Procesar')
	Return
END IF	


IF Isnull(ll_mes) THEN
	Messagebox('Aviso','Deb Ingresar Un Mes A Procesar')
	Return
END IF	

DELETE TT_FIN_RPT_CB_DET;

DECLARE USP_FIN_RPT_CB_DETALLE PROCEDURE FOR 
	USP_FIN_RPT_CB_DETALLE (:ll_ano,:ll_mes);
EXECUTE USP_FIN_RPT_CB_DETALLE ;

IF SQLCA.SQLCode = -1 THEN 
	ls_mensaje = gnvo_log.of_mensajedb("Error en USP_FIN_RPT_CB_DETALLE", SQLCA)
	Rollback ;
	
	gnvo_log.of_errorlog(ls_mensaje)
	gnvo_app.of_showMessageDialog(ls_mensaje)
	Return
END IF

CLOSE USP_FIN_RPT_CB_DETALLE;

idw_1 = dw_report
idw_1.Visible = TRUE
idw_1.SetTransObject(sqlca)
ib_preview = FALSE
Parent.Event ue_preview()

dw_report.retrieve(ll_ano,ll_mes,gnvo_app.invo_empresa.is_empresa,gnvo_app.is_user)
dw_report.Object.p_logo.filename = gnvo_app.is_logo



end event

