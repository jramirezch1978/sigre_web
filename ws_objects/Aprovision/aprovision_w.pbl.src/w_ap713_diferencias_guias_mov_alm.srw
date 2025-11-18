$PBExportHeader$w_ap713_diferencias_guias_mov_alm.srw
forward
global type w_ap713_diferencias_guias_mov_alm from w_rpt
end type
type cb_1 from commandbutton within w_ap713_diferencias_guias_mov_alm
end type
type uo_fecha from u_ingreso_rango_fechas within w_ap713_diferencias_guias_mov_alm
end type
type pb_1 from picturebutton within w_ap713_diferencias_guias_mov_alm
end type
type dw_report from u_dw_rpt within w_ap713_diferencias_guias_mov_alm
end type
end forward

global type w_ap713_diferencias_guias_mov_alm from w_rpt
integer width = 2720
integer height = 1688
string title = "Reporte de Diferencia Guias/Mov_Alm  (AP713)"
string menuname = "m_rpt"
windowstate windowstate = maximized!
long backcolor = 67108864
cb_1 cb_1
uo_fecha uo_fecha
pb_1 pb_1
dw_report dw_report
end type
global w_ap713_diferencias_guias_mov_alm w_ap713_diferencias_guias_mov_alm

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report
idw_1.Visible = False
idw_1.SetTransObject(sqlca)
THIS.Event ue_preview()


end event

event ue_retrieve;call super::ue_retrieve;date ld_fecha_ini, ld_fecha_fin

ld_fecha_ini = date(uo_fecha.of_get_fecha1( ))
ld_fecha_fin = date(uo_fecha.of_get_fecha2( ))

idw_1.Retrieve(ld_fecha_ini, ld_fecha_fin)

idw_1.Visible = True

idw_1.object.p_logo.filename 	= gs_logo
idw_1.object.usuario_t.text	= gs_user
end event

on w_ap713_diferencias_guias_mov_alm.create
int iCurrent
call super::create
if this.MenuName = "m_rpt" then this.MenuID = create m_rpt
this.cb_1=create cb_1
this.uo_fecha=create uo_fecha
this.pb_1=create pb_1
this.dw_report=create dw_report
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.uo_fecha
this.Control[iCurrent+3]=this.pb_1
this.Control[iCurrent+4]=this.dw_report
end on

on w_ap713_diferencias_guias_mov_alm.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.uo_fecha)
destroy(this.pb_1)
destroy(this.dw_report)
end on

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
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

type cb_1 from commandbutton within w_ap713_diferencias_guias_mov_alm
integer x = 1486
integer y = 28
integer width = 466
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Generar Reporte"
end type

event clicked;parent.event ue_retrieve()
end event

type uo_fecha from u_ingreso_rango_fechas within w_ap713_diferencias_guias_mov_alm
integer x = 82
integer y = 36
integer taborder = 20
end type

on uo_fecha.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor; of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
 of_set_fecha(today(), today()) //para setear la fecha inicial
 of_set_rango_inicio(date('01/01/1900')) // rango inicial
 of_set_rango_fin(date('31/12/9999')) // rango final
// of_get_fecha1(), of_get_fecha2()  para leer las fechas

end event

type pb_1 from picturebutton within w_ap713_diferencias_guias_mov_alm
integer x = 2135
integer y = 8
integer width = 306
integer height = 148
integer taborder = 10
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "H:\source\BMP\procesar_enb.bmp"
alignment htextalign = left!
end type

event clicked;date ld_fecha_ini, ld_fecha_fin
string ls_mensaje, ls_null

IF idw_1.rowcount( ) = 0 THEN
	messagebox('Cuadrar Movimientos', 'No existen datos a procesar')
   return
END IF

ld_fecha_ini = date(uo_fecha.of_get_fecha1( ))
ld_fecha_fin = date(uo_fecha.of_get_fecha2( ))

IF messagebox('Cuadrar', 'Esta seguro de procesar la información', QUESTION!, YESNO!, 2 ) = 2 THEN RETURN 


SetPointer (HourGlass!)

SetNull(ls_null)
 
DECLARE USP_AP_ACT_GUIAS_MOV_ALM PROCEDURE FOR
 USP_AP_ACT_GUIAS_MOV_ALM( :ld_fecha_ini, :ld_fecha_fin );
 
EXECUTE USP_AP_ACT_GUIAS_MOV_ALM;
 
IF SQLCA.sqlcode = -1 THEN
 ls_mensaje = "PROCEDURE USP_AP_ACT_GUIAS_MOV_ALM: " + SQLCA.SQLErrText
 Rollback ;
 MessageBox('SQL error', ls_mensaje, StopSign!) 
 SetPointer (Arrow!)
 return 
END IF
 
CLOSE USP_AP_ACT_GUIAS_MOV_ALM;
 
MessageBox('Aviso', 'Proceso Terminado Satisfactoriamente')

parent.event ue_retrieve()
 
SetPointer (Arrow!)


end event

type dw_report from u_dw_rpt within w_ap713_diferencias_guias_mov_alm
integer x = 23
integer y = 176
integer width = 2569
integer height = 1300
string dataobject = "d_ap_diferencia_guias_mov_alm"
boolean hscrollbar = true
boolean vscrollbar = true
end type

