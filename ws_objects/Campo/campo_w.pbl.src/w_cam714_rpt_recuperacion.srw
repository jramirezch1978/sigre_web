$PBExportHeader$w_cam714_rpt_recuperacion.srw
forward
global type w_cam714_rpt_recuperacion from w_rpt
end type
type cb_1 from commandbutton within w_cam714_rpt_recuperacion
end type
type uo_fecha from u_ingreso_rango_fechas within w_cam714_rpt_recuperacion
end type
type dw_report from u_dw_rpt within w_cam714_rpt_recuperacion
end type
end forward

global type w_cam714_rpt_recuperacion from w_rpt
integer x = 256
integer y = 348
integer width = 3314
integer height = 1792
string title = "Reporte de Recuperaciones de Crédito  (CAM712)"
string menuname = "m_rpt_smpl"
cb_1 cb_1
uo_fecha uo_fecha
dw_report dw_report
end type
global w_cam714_rpt_recuperacion w_cam714_rpt_recuperacion

type variables
String 			is_cod_origen, is_nro_liq

end variables

on w_cam714_rpt_recuperacion.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_smpl" then this.MenuID = create m_rpt_smpl
this.cb_1=create cb_1
this.uo_fecha=create uo_fecha
this.dw_report=create dw_report
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.uo_fecha
this.Control[iCurrent+3]=this.dw_report
end on

on w_cam714_rpt_recuperacion.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.uo_fecha)
destroy(this.dw_report)
end on

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report
idw_1.SetTransObject(sqlca)
this.Event ue_preview()
end event

event ue_print;call super::ue_print;idw_1.EVENT ue_print()
end event

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y

//this.windowstate = maximized!
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

event ue_saveas;//Overrding
string ls_path, ls_file
int li_rc

li_rc = GetFileSaveName ( "Select File", &
   ls_path, ls_file, "XLS", &
   "All Files (*.*),*.*" , "C:\", 32770)

IF li_rc = 1 Then
   uf_save_dw_as_excel ( dw_report, ls_file )
End If
end event

type cb_1 from commandbutton within w_cam714_rpt_recuperacion
integer x = 1307
integer y = 28
integer width = 393
integer height = 88
integer taborder = 30
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Filtrar "
end type

event clicked;date   ld_fecha_ini, ld_fecha_fin

ld_fecha_ini 	= date(uo_fecha.of_get_fecha1( ))
ld_fecha_fin 	= date(uo_fecha.of_get_fecha2( ))

dw_report.SetTransObject(SQLCA)
dw_report.Retrieve(ld_fecha_ini, ld_fecha_fin)

end event

type uo_fecha from u_ingreso_rango_fechas within w_cam714_rpt_recuperacion
integer y = 32
integer taborder = 50
end type

event constructor;call super::constructor;date ld_fecini, ld_fecfin
string ls_fecha


ld_fecini = Date('01/'+string(Today(),'mm/yyyy') )

if string(Today(), 'mm' ) <> '12' then
	ld_fecfin = RelativeDate(Date('01/' + string( Integer( string(Today(),'mm') ) + 1 ) &
		+ '/' + string( Today(), 'yyyy')), -1)
else
	ld_fecfin = RelativeDate(Date('01/' + '01' + '/' + string( Integer( string(Today(), 'yyyy') ) +1 ) ), -1)

end if

of_set_label('Desde:','Hasta:') 				// para setear el titulo del boton
of_set_fecha( ld_fecini, ld_fecfin)			// para setear la fecha
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final

// of_get_fecha1(), of_get_fecha2()  para leer las fechas

end event

on uo_fecha.destroy
call u_ingreso_rango_fechas::destroy
end on

type dw_report from u_dw_rpt within w_cam714_rpt_recuperacion
integer y = 152
integer width = 3273
integer height = 1408
boolean bringtotop = true
string dataobject = "d_rpt_recuperacion"
boolean hscrollbar = true
boolean vscrollbar = true
end type

