$PBExportHeader$w_ope751_costos_x_estructura.srw
forward
global type w_ope751_costos_x_estructura from w_rpt
end type
type dw_contador_str from datawindow within w_ope751_costos_x_estructura
end type
type cb_3 from commandbutton within w_ope751_costos_x_estructura
end type
type sle_1 from singlelineedit within w_ope751_costos_x_estructura
end type
type cb_2 from commandbutton within w_ope751_costos_x_estructura
end type
type st_1 from statictext within w_ope751_costos_x_estructura
end type
type cb_1 from commandbutton within w_ope751_costos_x_estructura
end type
type dw_report from u_dw_rpt within w_ope751_costos_x_estructura
end type
end forward

global type w_ope751_costos_x_estructura from w_rpt
integer width = 2706
integer height = 1748
string title = "Costos Por Estructura (OPE751)"
string menuname = "m_rpt_smpl"
long backcolor = 12632256
dw_contador_str dw_contador_str
cb_3 cb_3
sle_1 sle_1
cb_2 cb_2
st_1 st_1
cb_1 cb_1
dw_report dw_report
end type
global w_ope751_costos_x_estructura w_ope751_costos_x_estructura

on w_ope751_costos_x_estructura.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_smpl" then this.MenuID = create m_rpt_smpl
this.dw_contador_str=create dw_contador_str
this.cb_3=create cb_3
this.sle_1=create sle_1
this.cb_2=create cb_2
this.st_1=create st_1
this.cb_1=create cb_1
this.dw_report=create dw_report
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_contador_str
this.Control[iCurrent+2]=this.cb_3
this.Control[iCurrent+3]=this.sle_1
this.Control[iCurrent+4]=this.cb_2
this.Control[iCurrent+5]=this.st_1
this.Control[iCurrent+6]=this.cb_1
this.Control[iCurrent+7]=this.dw_report
end on

on w_ope751_costos_x_estructura.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_contador_str)
destroy(this.cb_3)
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

type dw_contador_str from datawindow within w_ope751_costos_x_estructura
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

type cb_3 from commandbutton within w_ope751_costos_x_estructura
integer x = 2240
integer y = 48
integer width = 402
integer height = 112
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Verificación"
end type

event clicked;String ls_nro_orden

ls_nro_orden = sle_1.text

Insert into tt_ope_aprobacion_ot
(nro_orden)
select ots.ot_hijo
  from ot_estructura ots,orden_trabajo ot
 where ots.ot_hijo = ot.nro_orden
 connect by prior ots.ot_hijo = ots.ot_padre 
 start with ots.ot_padre = :ls_nro_orden ;
 

dw_contador_str.Visible  = TRUE
dw_contador_str.Retrieve ()

delete from tt_ope_aprobacion_ot ;
end event

type sle_1 from singlelineedit within w_ope751_costos_x_estructura
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

type cb_2 from commandbutton within w_ope751_costos_x_estructura
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
lstr_seleccionar.s_sql = 'SELECT NRO_ORDEN  AS ORDEN_TRABAJO       ,'&
										 +'TITULO     AS TITULO_ORDEN_TRABAJO,'&
										 +'CENCOS_SLC AS CENCOS_SOLICITANTE  ,'&
										 +'OT_ADM	  AS ADMINISTRACION		  '&	
										 +'FROM VW_OPE_ESTRUCTURA '
				
OpenWithParm(w_seleccionar_op,lstr_seleccionar)
				
IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
	IF lstr_seleccionar.s_action = "aceptar" THEN
		sle_1.text = lstr_seleccionar.param1[1]
	END IF


end event

type st_1 from statictext within w_ope751_costos_x_estructura
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

type cb_1 from commandbutton within w_ope751_costos_x_estructura
integer x = 1815
integer y = 48
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

DECLARE PB_usp_ope_creal_x_estructura PROCEDURE FOR usp_ope_creal_x_estructura
(:ls_nro_ot);
EXECUTE PB_usp_ope_creal_x_estructura ;


IF SQLCA.SQLCode = -1 THEN 
	ls_msj_err = SQLCA.SQLErrText
	MessageBox('SQL error', ls_msj_err)
END IF


CLOSE PB_usp_ope_creal_x_estructura ;


//verificar monto real y proyectado de ot padre
SELECT tt.monto_real , tt.monto_proy  ,ot.titulo ,ot.flag_estado
  INTO :ldc_monto_real,:ldc_monto_proy,:ls_titulo ,:ls_estado
  FROM tt_ope_ot_aprobadas_costo tt,orden_trabajo ot 
 WHERE (tt.nro_orden = ot.nro_orden ) and
 		 (ot.nro_orden = :ls_nro_ot	)	;
							 


dw_report.retrieve(ls_nro_ot,ls_titulo,ldc_monto_real,ldc_monto_proy)


idw_1.object.p_logo.filename = gs_logo
idw_1.object.t_nombre.text   = gs_empresa
idw_1.object.t_user.text 	  = gs_user
idw_1.object.t_prog.text	  = parent.classname( )



//inserta orden de trabjo padre
ll_row = dw_report.InsertRow(0)
dw_report.object.estructura_orden_trabajo [ll_row] = '* '+Trim(ls_nro_ot)+' '+Trim(ls_titulo)
dw_report.object.nro_orden 					[ll_row] = Trim(ls_nro_ot)
dw_report.object.monto_proy					[ll_row] = ldc_monto_proy
dw_report.object.monto_real 					[ll_row] = ldc_monto_real
dw_report.object.orden							[ll_row] = 1
dw_report.object.flag_estado					[ll_row] = ls_estado

dw_report.setsort( 'orden asc')
dw_report.sort( )



Parent.SetRedraw(true)
end event

type dw_report from u_dw_rpt within w_ope751_costos_x_estructura
integer x = 14
integer y = 204
integer width = 2629
integer height = 1348
string dataobject = "d_rpt_costos_x_estructura_tbl"
boolean maxbox = true
boolean hscrollbar = true
boolean vscrollbar = true
end type

event doubleclicked;call super::doubleclicked;String ls_nro_orden
Decimal {2} ldc_monto_real,ldc_monto_proy
str_cns_pop lstr_1

This.Accepttext( )

ls_nro_orden   = this.object.nro_orden  [row]
ldc_monto_real = this.object.monto_real [row]
ldc_monto_proy = this.object.monto_proy [row]


				
				
lstr_1.Width = 4460
lstr_1.Height= 2000
lstr_1.title = 'Costos de Orden de Trabajo'
lstr_1.tipo_cascada = 'R'
lstr_1.arg [1] = ls_nro_orden
lstr_1.arg [2] = String(ldc_monto_proy)
lstr_1.arg [3] = String(ldc_monto_real)


choose case dwo.name
		 case 'monto_proy'
				lstr_1.DataObject = 'd_rpt_costo_detalle_proy_x_ot_tbl'
				of_new_sheet(lstr_1)
		 case 'monto_real'
				//real
				lstr_1.DataObject = 'd_rpt_costo_real_detalle_x_ot_tbl'
				of_new_sheet(lstr_1)
		 case  'monto_reservados'
				//reservado
				lstr_1.DataObject = 'd_abc_art_reservados_tbl'
				lstr_1.Width = 3200
				lstr_1.Height= 2000

				of_new_sheet(lstr_1)
				
		 case 'monto_transito'
				
				//compras en transito
				lstr_1.DataObject = 'd_abc_art_transito_tbl'
				lstr_1.Width = 3200
				lstr_1.Height= 2000

				of_new_sheet(lstr_1)
				
end choose





end event

event retrieverow;call super::retrieverow;this.object.orden [row] = row + 1
end event

