$PBExportHeader$w_asi304_asistencia_ht580_bk.srw
forward
global type w_asi304_asistencia_ht580_bk from w_rpt
end type
type uo_1 from u_ingreso_rango_fechas within w_asi304_asistencia_ht580_bk
end type
type pb_1 from picturebutton within w_asi304_asistencia_ht580_bk
end type
type dw_report from u_dw_rpt within w_asi304_asistencia_ht580_bk
end type
type gb_4 from groupbox within w_asi304_asistencia_ht580_bk
end type
end forward

global type w_asi304_asistencia_ht580_bk from w_rpt
integer width = 4128
integer height = 2568
string title = "[ASI707] Asistencia HT580"
string menuname = "m_abc_master_smpl"
uo_1 uo_1
pb_1 pb_1
dw_report dw_report
gb_4 gb_4
end type
global w_asi304_asistencia_ht580_bk w_asi304_asistencia_ht580_bk

on w_asi304_asistencia_ht580_bk.create
int iCurrent
call super::create
if this.MenuName = "m_abc_master_smpl" then this.MenuID = create m_abc_master_smpl
this.uo_1=create uo_1
this.pb_1=create pb_1
this.dw_report=create dw_report
this.gb_4=create gb_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_1
this.Control[iCurrent+2]=this.pb_1
this.Control[iCurrent+3]=this.dw_report
this.Control[iCurrent+4]=this.gb_4
end on

on w_asi304_asistencia_ht580_bk.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_1)
destroy(this.pb_1)
destroy(this.dw_report)
destroy(this.gb_4)
end on

event ue_open_pre;//Overrride

idw_1 = dw_report
idw_1.Visible = true
idw_1.SetTransObject(sqlca)
idw_1.ii_zoom_actual = 100

ib_preview = false
THIS.Event ue_preview()



 ii_help = 101           // help topic
end event

event ue_retrieve;call super::ue_retrieve;Date	 ld_fecha_inicio,ld_fecha_final	

ld_fecha_inicio = uo_1.of_get_fecha1()
ld_fecha_final  = uo_1.of_get_fecha2()
	
idw_1.Retrieve(ld_fecha_inicio,ld_fecha_final)




end event

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

event ue_print;call super::ue_print;idw_1.EVENT ue_print()
end event

event ue_preview;call super::ue_preview;
IF ib_preview THEN
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

type uo_1 from u_ingreso_rango_fechas within w_asi304_asistencia_ht580_bk
integer x = 55
integer y = 52
integer taborder = 20
end type

event constructor;call super::constructor; of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
 of_set_fecha(today(), today()) //para setear la fecha inicial
 of_set_rango_inicio(date('01/01/1900')) // rango inicial
 of_set_rango_fin(date('31/12/9999')) // rango final


end event

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

type pb_1 from picturebutton within w_asi304_asistencia_ht580_bk
integer x = 1440
integer y = 40
integer width = 274
integer height = 152
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "C:\SIGRE\resources\BMP\Aceptar_dn.bmp"
alignment htextalign = left!
end type

event clicked;// Ancestor Script has been Override

SetPointer(HourGlass!)
Parent.event Dynamic ue_retrieve()
SetPointer(Arrow!)
end event

type dw_report from u_dw_rpt within w_asi304_asistencia_ht580_bk
integer y = 220
integer width = 3730
integer height = 1384
string dataobject = "d_abc_asistencia_ht580_tbl"
end type

type gb_4 from groupbox within w_asi304_asistencia_ht580_bk
integer width = 3150
integer height = 208
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Datos"
end type

