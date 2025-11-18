$PBExportHeader$w_fl705_costo_ot.srw
forward
global type w_fl705_costo_ot from w_rpt
end type
type st_orden from statictext within w_fl705_costo_ot
end type
type st_1 from statictext within w_fl705_costo_ot
end type
type sle_orden from singlelineedit within w_fl705_costo_ot
end type
type dw_report from u_dw_rpt within w_fl705_costo_ot
end type
type pb_recuperar from u_pb_std within w_fl705_costo_ot
end type
end forward

global type w_fl705_costo_ot from w_rpt
integer width = 3141
integer height = 2180
string title = "Costo por Orden de Trabajo (FL705)"
string menuname = "m_rep_grf"
long backcolor = 67108864
event ue_copiar ( )
st_orden st_orden
st_1 st_1
sle_orden sle_orden
dw_report dw_report
pb_recuperar pb_recuperar
end type
global w_fl705_costo_ot w_fl705_costo_ot

type variables
uo_parte_pesca iuo_parte
end variables

event ue_copiar();dw_report.ClipBoard("gr_1")
end event

event resize;call super::resize;dw_report.width  = newwidth  - dw_report.x - 10
dw_report.height = newheight - dw_report.y - 10
end event

event ue_retrieve;call super::ue_retrieve;integer li_ok
string ls_mensaje, ls_orden

ls_orden = trim(sle_orden.text)

SetPointer(HourGlass!)

//create or replace procedure USP_FL_COSTO_OT(
//		asi_orden 	in orden_trabajo.nro_orden%TYPE, 
//    aso_mensaje out varchar2, 
//    aio_ok 			out number) is

DECLARE USP_FL_COSTO_OT PROCEDURE FOR
	USP_FL_COSTO_OT( :ls_orden );

EXECUTE USP_FL_COSTO_OT;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE USP_FL_COSTO_OT: " + SQLCA.SQLErrText
	Rollback ;
	SetPointer(Arrow!)
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	return
END IF

FETCH USP_FL_COSTO_OT INTO :ls_mensaje, :li_ok;
CLOSE USP_FL_COSTO_OT;

if li_ok <> 1 then
	SetPointer(Arrow!)
	MessageBox('Error USP_FL_COSTO_OT', ls_mensaje, StopSign!)	
	return
end if

idw_1.SetRedraw(False)
idw_1.Retrieve()
idw_1.object.nro_orden.text = 'ORDEN DE TRABAJO: ' + ls_orden
idw_1.SetRedraw(True)

SetPointer(Arrow!)

end event

on w_fl705_costo_ot.create
int iCurrent
call super::create
if this.MenuName = "m_rep_grf" then this.MenuID = create m_rep_grf
this.st_orden=create st_orden
this.st_1=create st_1
this.sle_orden=create sle_orden
this.dw_report=create dw_report
this.pb_recuperar=create pb_recuperar
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_orden
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.sle_orden
this.Control[iCurrent+4]=this.dw_report
this.Control[iCurrent+5]=this.pb_recuperar
end on

on w_fl705_costo_ot.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_orden)
destroy(this.st_1)
destroy(this.sle_orden)
destroy(this.dw_report)
destroy(this.pb_recuperar)
end on

event ue_print;call super::ue_print;idw_1.EVENT ue_print()
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

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report
idw_1.SetTransObject(sqlca)

idw_1.object.usuario_t.text 	= 'Usuario: ' + gs_user
idw_1.object.p_logo.filename 	= gs_logo
idw_1.object.Datawindow.Print.Orientation = 2

iuo_parte = create uo_parte_pesca

end event

event close;call super::close;destroy iuo_parte
end event

type st_orden from statictext within w_fl705_costo_ot
integer x = 1102
integer y = 44
integer width = 951
integer height = 88
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 67108864
boolean border = true
boolean focusrectangle = false
end type

type st_1 from statictext within w_fl705_costo_ot
integer x = 224
integer y = 60
integer width = 457
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Orden de Trabajo:"
boolean focusrectangle = false
end type

type sle_orden from singlelineedit within w_fl705_costo_ot
event ue_display ( )
event ue_dblclick pbm_lbuttondblclk
event ue_keydwn pbm_keydown
integer x = 686
integer y = 44
integer width = 402
integer height = 88
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long textcolor = 33554432
textcase textcase = upper!
integer limit = 10
borderstyle borderstyle = stylelowered!
end type

event ue_display();// Este evento despliega la pantalla w_seleccionar

string ls_codigo, ls_data, ls_sql, ls_nave
integer li_i
str_seleccionar lstr_seleccionar

ls_sql = "SELECT NRO_ORDEN AS CODIGO, " &
		 + "FEC_ESTIMADA AS FECHA_ESTIMADA, " &
		 + "FEC_INICIO AS FECHA_INICIO, " &
		 + "NOMB_NAVE  AS DESCR_NAVE, " &
		 + "DESCRIPCION AS DESCR_ORDEN " &
		 + "FROM VW_FL_OT_NAVE " 

		 
lstr_seleccionar.s_column 	  = '1'
lstr_seleccionar.s_sql       = ls_sql
lstr_seleccionar.s_seleccion = 'S'

OpenWithParm(w_seleccionar,lstr_seleccionar)

IF isvalid(message.PowerObjectParm) THEN 
	lstr_seleccionar = message.PowerObjectParm
END IF	

IF lstr_seleccionar.s_action = "aceptar" THEN
	ls_codigo = lstr_seleccionar.param1[1]
	ls_data   = lstr_seleccionar.param4[1]
ELSE		
	return
end if
		
st_orden.text = ls_data	

this.text	 		= ls_codigo

end event

event ue_dblclick;this.event ue_display()
end event

event ue_keydwn;if Key = KeyF2! then
	this.event ue_display()	
end if
end event

event modified;string ls_codigo, ls_data
integer ln_count

ls_codigo = trim(this.text)

if ls_codigo = '' then
	MessageBox('ERROR', "DEBE INGRESAR UNA ORDEN DE TRABAJO", StopSign!)
	return
end if

select count(*)
	into :ln_count
from orden_trabajo
where nro_orden = :ls_codigo;

if ln_count = 0 then
	MessageBox('ERROR', "ORDEN DE TRABAJO NO EXISTE", StopSign!)
	return
end if

select descripcion
	into :ls_data
from orden_trabajo
where nro_orden = :ls_codigo;

st_orden.text = ls_data

parent.event dynamic ue_refrescar()

end event

type dw_report from u_dw_rpt within w_fl705_costo_ot
integer y = 172
integer width = 3049
integer height = 1728
integer taborder = 60
string dataobject = "d_rpt_costo_ot_composite"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor;is_dwform = 'form'  // tabular (default), form 
end event

type pb_recuperar from u_pb_std within w_fl705_costo_ot
integer x = 2889
integer y = 20
integer width = 155
integer height = 132
integer textsize = -2
string text = "&r"
string picturename = "Retrieve!"
boolean map3dcolors = true
end type

event clicked;call super::clicked;parent.event dynamic ue_retrieve()
end event

