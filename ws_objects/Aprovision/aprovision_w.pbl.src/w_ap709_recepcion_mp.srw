$PBExportHeader$w_ap709_recepcion_mp.srw
forward
global type w_ap709_recepcion_mp from w_rpt
end type
type st_1 from statictext within w_ap709_recepcion_mp
end type
type cb_1 from commandbutton within w_ap709_recepcion_mp
end type
type uo_fecha from u_ingreso_rango_fechas within w_ap709_recepcion_mp
end type
type dw_report from u_dw_rpt within w_ap709_recepcion_mp
end type
end forward

global type w_ap709_recepcion_mp from w_rpt
integer width = 3671
integer height = 3208
string title = "[AP709] Recepcion de Materia Prima por Tinas"
string menuname = "m_rpt"
windowstate windowstate = maximized!
event ue_query_retrieve ( )
st_1 st_1
cb_1 cb_1
uo_fecha uo_fecha
dw_report dw_report
end type
global w_ap709_recepcion_mp w_ap709_recepcion_mp

type variables
String  isa_cod_origen[]
end variables

forward prototypes
public function boolean of_verificar ()
end prototypes

public function boolean of_verificar ();// Verifica que no falten parametros para el reporte

boolean	lb_ok
return lb_ok

end function

on w_ap709_recepcion_mp.create
int iCurrent
call super::create
if this.MenuName = "m_rpt" then this.MenuID = create m_rpt
this.st_1=create st_1
this.cb_1=create cb_1
this.uo_fecha=create uo_fecha
this.dw_report=create dw_report
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.uo_fecha
this.Control[iCurrent+4]=this.dw_report
end on

on w_ap709_recepcion_mp.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.cb_1)
destroy(this.uo_fecha)
destroy(this.dw_report)
end on

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

event ue_open_pre;call super::ue_open_pre;Date 	ld_FechaActual, ld_FechaInicio
Long 	ll_Semana 
		
idw_1 = dw_report

dw_Report.setTransObject(SQLCA)

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

event ue_retrieve;call super::ue_retrieve;date    	ld_fecha_ini, ld_fecha_fin


ld_fecha_ini 	= date(uo_fecha.of_get_fecha1( ))
ld_fecha_fin 	= date(uo_fecha.of_get_fecha2( ))


//Recupera los datos del reporte
idw_1.Retrieve(ld_fecha_ini, ld_fecha_fin)
ib_preview = true
event ue_preview()


end event

event ue_saveas;//Overrding
string ls_path, ls_file
int li_rc

li_rc = GetFileSaveName ( "Select File", &
   ls_path, ls_file, "XLS", &
   "All Files (*.xls),*.*" , "C:\", 32770)

IF li_rc = 1 Then
   uf_save_dw_as_excel ( dw_report, ls_file )
End If
 
end event

type st_1 from statictext within w_ap709_recepcion_mp
integer y = 8
integer width = 434
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Rango de Fechas"
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_ap709_recepcion_mp
integer x = 1335
integer y = 4
integer width = 343
integer height = 172
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Generar"
end type

event clicked;parent.event ue_retrieve()
end event

type uo_fecha from u_ingreso_rango_fechas within w_ap709_recepcion_mp
integer y = 76
integer height = 96
integer taborder = 10
end type

event constructor;call super::constructor;of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
of_set_fecha(RelativeDate(today(),-7) , today()) //para setear la fecha inicial
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final
// of_get_fecha1(), of_get_fecha2()  para leer las fechas

end event

on uo_fecha.destroy
call u_ingreso_rango_fechas::destroy
end on

type dw_report from u_dw_rpt within w_ap709_recepcion_mp
integer y = 184
integer width = 3470
integer height = 1452
integer taborder = 80
string dataobject = "d_rpt_materia_prima_tinas_tbl"
end type

event rowfocuschanged;call super::rowfocuschanged;selectRow(0, false)
SelectRow(currentrow, true)
SetRow(currentRow)
end event

