$PBExportHeader$w_ope752_costos_x_seccion.srw
forward
global type w_ope752_costos_x_seccion from w_rpt
end type
type dw_contador_str from datawindow within w_ope752_costos_x_seccion
end type
type sle_1 from singlelineedit within w_ope752_costos_x_seccion
end type
type cb_2 from commandbutton within w_ope752_costos_x_seccion
end type
type st_1 from statictext within w_ope752_costos_x_seccion
end type
type cb_1 from commandbutton within w_ope752_costos_x_seccion
end type
type dw_report from u_dw_rpt within w_ope752_costos_x_seccion
end type
end forward

global type w_ope752_costos_x_seccion from w_rpt
integer width = 2706
integer height = 1748
string title = "Costos Por Seccion(OPE752)"
string menuname = "m_rpt_smpl"
long backcolor = 12632256
dw_contador_str dw_contador_str
sle_1 sle_1
cb_2 cb_2
st_1 st_1
cb_1 cb_1
dw_report dw_report
end type
global w_ope752_costos_x_seccion w_ope752_costos_x_seccion

on w_ope752_costos_x_seccion.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_smpl" then this.MenuID = create m_rpt_smpl
this.dw_contador_str=create dw_contador_str
this.sle_1=create sle_1
this.cb_2=create cb_2
this.st_1=create st_1
this.cb_1=create cb_1
this.dw_report=create dw_report
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_contador_str
this.Control[iCurrent+2]=this.sle_1
this.Control[iCurrent+3]=this.cb_2
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.cb_1
this.Control[iCurrent+6]=this.dw_report
end on

on w_ope752_costos_x_seccion.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_contador_str)
destroy(this.sle_1)
destroy(this.cb_2)
destroy(this.st_1)
destroy(this.cb_1)
destroy(this.dw_report)
end on

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report

idw_1.SetTransObject(sqlca)
ib_preview = FALSE


idw_1.ii_zoom_actual = 100
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

event ue_print;call super::ue_print;idw_1.EVENT ue_print()
end event

type dw_contador_str from datawindow within w_ope752_costos_x_seccion
boolean visible = false
integer x = 1294
integer y = 372
integer width = 768
integer height = 416
integer taborder = 30
boolean titlebar = true
string title = "Contador de Estructura"
string dataobject = "d_abc_ot_contador_estructura_tbl"
boolean controlmenu = true
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event constructor;Settransobject(sqlca)

end event

type sle_1 from singlelineedit within w_ope752_costos_x_seccion
integer x = 384
integer y = 60
integer width = 370
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
integer limit = 10
borderstyle borderstyle = stylelowered!
end type

type cb_2 from commandbutton within w_ope752_costos_x_seccion
integer x = 768
integer y = 60
integer width = 114
integer height = 100
integer taborder = 20
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
lstr_seleccionar.s_sql = 'SELECT ORDEN_TRABAJO.NRO_ORDEN AS NRO_ORDEN_TRABAJO,'&
										 +'ORDEN_TRABAJO.TITULO AS TITULO_ORDEN_TRABAJO,'&
										 +'ORDEN_TRABAJO.CENCOS_SLC AS CENCOS_SOLICITANTE  ,'&
										 +'ORDEN_TRABAJO.OT_ADM AS ADMINISTRACION		  '&	
										 +'FROM ORDEN_TRABAJO '
				
OpenWithParm(w_seleccionar_op,lstr_seleccionar)
				
IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
	IF lstr_seleccionar.s_action = "aceptar" THEN
		sle_1.text = lstr_seleccionar.param1[1]
	END IF


end event

type st_1 from statictext within w_ope752_costos_x_seccion
integer x = 46
integer y = 72
integer width = 283
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 12632256
string text = "Nro Orden :"
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_ope752_costos_x_seccion
integer x = 2231
integer y = 64
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

event clicked;String ls_nro_ot,ls_msj_err,ls_titulo,ls_estado
Decimal {2} ldc_monto_real,ldc_monto_proy
Long   ll_row

ls_nro_ot = sle_1.text
Parent.SetRedraw(false)
Setpointer(hourglass!)

DECLARE PB_USP_OPE_OT_X_SECCION PROCEDURE FOR USP_OPE_OT_X_SECCION
(:ls_nro_ot);
EXECUTE PB_USP_OPE_OT_X_SECCION ;


IF SQLCA.SQLCode = -1 THEN 
	ls_msj_err = SQLCA.SQLErrText
	MessageBox('SQL error', ls_msj_err)
END IF


CLOSE PB_USP_OPE_OT_X_SECCION ;



							 


dw_report.retrieve()


idw_1.object.p_logo.filename = gs_logo
idw_1.object.t_nombre.text   = gs_empresa
idw_1.object.t_user.text 	  = gs_user
idw_1.object.t_prog.text	  = parent.classname( )



Parent.SetRedraw(true)
end event

type dw_report from u_dw_rpt within w_ope752_costos_x_seccion
integer x = 14
integer y = 204
integer width = 2629
integer height = 1348
string dataobject = "d_abc_costos_x_seccion_tbl"
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
end type

event doubleclicked;call super::doubleclicked;String ls_nro_orden,ls_seccion
//Decimal {2} ldc_monto_real,ldc_monto_proy
str_cns_pop lstr_1
//
This.Accepttext( )
//
ls_nro_orden = this.object.nro_orden  [row]
ls_seccion	 = this.object.ot_seccion [row]



lstr_1.Width = 3460
lstr_1.Height= 2000
lstr_1.title = 'Costos de Orden de Trabajo'
lstr_1.tipo_cascada = 'R'
lstr_1.arg [1] = ls_nro_orden
lstr_1.arg [2] = ls_seccion


choose case dwo.name
		 case 'tt_mat_proy'
				lstr_1.DataObject = 'd_abc_costo_art_proy_x_seccion_tbl'
				of_new_sheet(lstr_1)				
 		  case 'tt_mat_real'
				lstr_1.DataObject = 'd_abc_costo_art_reales_x_seccion_tbl'
				of_new_sheet(lstr_1)
		  case 'tt_ser_proy'
				lstr_1.DataObject = 'd_abc_servicios_proy_x_seccion_tbl'
				of_new_sheet(lstr_1)
		  case 'tt_ser_real'		
		 		lstr_1.DataObject = 'd_abc_servicios_reales_x_ot_seccion_tbl'
			   lstr_1.Width = 3760
				of_new_sheet(lstr_1)
				
		  case 'tt_oper_proy'		
				lstr_1.DataObject = 'd_abc_labor_prop_proy_x_seccion_tbl'
			   lstr_1.Width = 4000
				of_new_sheet(lstr_1)		
				
		  case 'tt_oper_real'		
				lstr_1.DataObject = 'd_abc_labores_prop_reales_x_seccion_tbl'
			   lstr_1.Width = 4000
				of_new_sheet(lstr_1)
				
				
end choose





end event

