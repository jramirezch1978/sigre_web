$PBExportHeader$w_ope727_costo_real_est_x_ot.srw
forward
global type w_ope727_costo_real_est_x_ot from w_rpt
end type
type sle_2 from u_sle_codigo within w_ope727_costo_real_est_x_ot
end type
type cb_2 from commandbutton within w_ope727_costo_real_est_x_ot
end type
type st_2 from statictext within w_ope727_costo_real_est_x_ot
end type
type cb_1 from commandbutton within w_ope727_costo_real_est_x_ot
end type
type dw_report from u_dw_rpt within w_ope727_costo_real_est_x_ot
end type
end forward

global type w_ope727_costo_real_est_x_ot from w_rpt
integer width = 2455
integer height = 1972
string title = "Reporte de Costo Real / Estimado (OPE727)"
string menuname = "m_rpt_smpl"
long backcolor = 12632256
sle_2 sle_2
cb_2 cb_2
st_2 st_2
cb_1 cb_1
dw_report dw_report
end type
global w_ope727_costo_real_est_x_ot w_ope727_costo_real_est_x_ot

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report

idw_1.SetTransObject(sqlca)
ib_preview = false
THIS.Event ue_preview()


idw_1.object.p_logo.filename = gs_logo
idw_1.object.t_nombre.text = gs_empresa
idw_1.object.t_user.text = gs_user
end event

on w_ope727_costo_real_est_x_ot.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_smpl" then this.MenuID = create m_rpt_smpl
this.sle_2=create sle_2
this.cb_2=create cb_2
this.st_2=create st_2
this.cb_1=create cb_1
this.dw_report=create dw_report
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_2
this.Control[iCurrent+2]=this.cb_2
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.cb_1
this.Control[iCurrent+5]=this.dw_report
end on

on w_ope727_costo_real_est_x_ot.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_2)
destroy(this.cb_2)
destroy(this.st_2)
destroy(this.cb_1)
destroy(this.dw_report)
end on

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

type sle_2 from u_sle_codigo within w_ope727_costo_real_est_x_ot
integer x = 37
integer y = 156
integer width = 448
integer taborder = 40
integer textsize = -8
end type

type cb_2 from commandbutton within w_ope727_costo_real_est_x_ot
integer x = 549
integer y = 152
integer width = 133
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;str_seleccionar lstr_seleccionar

lstr_seleccionar.s_seleccion = 'S'
lstr_seleccionar.s_sql = 'SELECT ORIGEN         AS CODIGO_ORIGEN       ,'&
								+' NRO_OT         AS NRO_ORDEN_TRABAJO 		  ,'&
						  	   +'ADMINISTRACION AS ADMINISTRACION	   		  ,'&
								+'TIPO           AS TIPO_OT				 		  ,'&
								+'CENCOS_SOLIC   AS CC_SOLICITANTE	 			  ,'&
								+'DESC_CC_SOLICITANTE  AS DESC_CC_SOLICITANTE  ,'&
								+'CENCOS_RESP    AS CC_RESPONSABLE	 			  ,'&
								+'DESC_CC_RESPONSABLE  AS DESC_CC_RESPONSABLE  ,'&
								+'USUARIO        AS CODIGO_USUARIO	 			  ,'&
								+'CODIGO_RESPONSABLE   AS CODIGO_RESPONSABLE   ,'&
								+'NOMBRE_RESPONSABLE   AS NOMBRES_RESPONSABLES ,'&
							  	+'FECHA_INICIO         AS FECHA_INICIO 		  ,'&		
								+'TITULO_ORDEN_TRABAJO AS TITULO_ORDEN_TRABAJO  '&
								+'FROM VW_OPE_CONSULTA_ORDEN_TRABAJO '

				
OpenWithParm(w_seleccionar_op,lstr_seleccionar)
				
IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
	IF lstr_seleccionar.s_action = "aceptar" THEN
		//sle_1.text = lstr_seleccionar.param1[1]
		sle_2.text = lstr_seleccionar.param2[1]
	END IF


end event

type st_2 from statictext within w_ope727_costo_real_est_x_ot
integer x = 37
integer y = 84
integer width = 448
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Nro OT"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_ope727_costo_real_est_x_ot
integer x = 1979
integer y = 132
integer width = 402
integer height = 112
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Procesar"
end type

event clicked;//String ls_origen,ls_nro_orden
String ls_nro_orden

//ls_origen	 = sle_1.text
ls_nro_orden = sle_2.text

dw_report.retrieve(ls_nro_orden)
end event

type dw_report from u_dw_rpt within w_ope727_costo_real_est_x_ot
integer x = 27
integer y = 268
integer width = 2368
integer height = 1484
string dataobject = "d_operaciones_est_real_gen_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

