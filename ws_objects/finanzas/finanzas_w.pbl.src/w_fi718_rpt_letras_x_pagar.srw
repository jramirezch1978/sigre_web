$PBExportHeader$w_fi718_rpt_letras_x_pagar.srw
forward
global type w_fi718_rpt_letras_x_pagar from w_rpt
end type
type dw_arg from datawindow within w_fi718_rpt_letras_x_pagar
end type
type dw_report from u_dw_rpt within w_fi718_rpt_letras_x_pagar
end type
type cb_1 from commandbutton within w_fi718_rpt_letras_x_pagar
end type
type gb_1 from groupbox within w_fi718_rpt_letras_x_pagar
end type
end forward

global type w_fi718_rpt_letras_x_pagar from w_rpt
integer width = 3589
integer height = 1392
string title = "(FI718) Reporte de Letras x Pagar  "
string menuname = "m_reporte"
long backcolor = 12632256
dw_arg dw_arg
dw_report dw_report
cb_1 cb_1
gb_1 gb_1
end type
global w_fi718_rpt_letras_x_pagar w_fi718_rpt_letras_x_pagar

type variables

end variables

on w_fi718_rpt_letras_x_pagar.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.dw_arg=create dw_arg
this.dw_report=create dw_report
this.cb_1=create cb_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_arg
this.Control[iCurrent+2]=this.dw_report
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.gb_1
end on

on w_fi718_rpt_letras_x_pagar.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_arg)
destroy(this.dw_report)
destroy(this.cb_1)
destroy(this.gb_1)
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

type dw_arg from datawindow within w_fi718_rpt_letras_x_pagar
integer x = 73
integer y = 80
integer width = 1189
integer height = 380
integer taborder = 20
string title = "none"
string dataobject = "d_ext_param_letras_x_pagar_ff"
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

type dw_report from u_dw_rpt within w_fi718_rpt_letras_x_pagar
integer x = 27
integer y = 536
integer width = 3511
integer height = 644
integer taborder = 20
string dataobject = "d_rpt_letras_x_pagar_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

type cb_1 from commandbutton within w_fi718_rpt_letras_x_pagar
integer x = 1445
integer y = 48
integer width = 503
integer height = 112
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "&Procesar"
end type

event clicked;String ls_cod_origen
Long	 ll_ano, ll_mes_ini, ll_mes_fin

dw_arg.Accepttext()

ls_cod_origen = dw_arg.object.origen 	 [1]
ll_ano 		  = dw_arg.object.ano	 	 [1]	
ll_mes_ini = dw_arg.object.nro_asiento_ini [1]
ll_mes_fin = dw_arg.object.nro_asiento_fin [1]


dw_report.Retrieve(ls_cod_origen, ll_ano, ll_mes_ini, ll_mes_fin)

dw_report.Object.p_logo.filename = gs_logo
dw_report.Object.t_user.text = gs_user
dw_report.Object.t_empresa.text = gs_empresa

end event

type gb_1 from groupbox within w_fi718_rpt_letras_x_pagar
integer x = 37
integer y = 20
integer width = 1253
integer height = 492
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

