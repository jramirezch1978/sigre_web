$PBExportHeader$w_ap734_rpt_produccion_det.srw
$PBExportComments$Record de pesca de embarcaciones
forward
global type w_ap734_rpt_produccion_det from w_rpt
end type
type st_1 from statictext within w_ap734_rpt_produccion_det
end type
type sle_week2 from singlelineedit within w_ap734_rpt_produccion_det
end type
type sle_year2 from singlelineedit within w_ap734_rpt_produccion_det
end type
type sle_week1 from singlelineedit within w_ap734_rpt_produccion_det
end type
type sle_year1 from singlelineedit within w_ap734_rpt_produccion_det
end type
type rb_2 from radiobutton within w_ap734_rpt_produccion_det
end type
type rb_1 from radiobutton within w_ap734_rpt_produccion_det
end type
type cb_1 from commandbutton within w_ap734_rpt_produccion_det
end type
type uo_fecha from u_ingreso_rango_fechas within w_ap734_rpt_produccion_det
end type
type dw_report from u_dw_rpt within w_ap734_rpt_produccion_det
end type
end forward

global type w_ap734_rpt_produccion_det from w_rpt
integer width = 3671
integer height = 3208
string title = "[AP734] Reporte de Acopio de Producción Detallada"
string menuname = "m_rpt"
windowstate windowstate = maximized!
event ue_query_retrieve ( )
st_1 st_1
sle_week2 sle_week2
sle_year2 sle_year2
sle_week1 sle_week1
sle_year1 sle_year1
rb_2 rb_2
rb_1 rb_1
cb_1 cb_1
uo_fecha uo_fecha
dw_report dw_report
end type
global w_ap734_rpt_produccion_det w_ap734_rpt_produccion_det

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

on w_ap734_rpt_produccion_det.create
int iCurrent
call super::create
if this.MenuName = "m_rpt" then this.MenuID = create m_rpt
this.st_1=create st_1
this.sle_week2=create sle_week2
this.sle_year2=create sle_year2
this.sle_week1=create sle_week1
this.sle_year1=create sle_year1
this.rb_2=create rb_2
this.rb_1=create rb_1
this.cb_1=create cb_1
this.uo_fecha=create uo_fecha
this.dw_report=create dw_report
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.sle_week2
this.Control[iCurrent+3]=this.sle_year2
this.Control[iCurrent+4]=this.sle_week1
this.Control[iCurrent+5]=this.sle_year1
this.Control[iCurrent+6]=this.rb_2
this.Control[iCurrent+7]=this.rb_1
this.Control[iCurrent+8]=this.cb_1
this.Control[iCurrent+9]=this.uo_fecha
this.Control[iCurrent+10]=this.dw_report
end on

on w_ap734_rpt_produccion_det.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.sle_week2)
destroy(this.sle_year2)
destroy(this.sle_week1)
destroy(this.sle_year1)
destroy(this.rb_2)
destroy(this.rb_1)
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
THIS.Event ue_preview()

sle_year1.text = string(Date(f_fecha_actual()), 'yyyy')
sle_week1.text = "1"

sle_year2.text = string(Date(f_fecha_actual()), 'yyyy')


 
ld_FechaActual = Date(f_fecha_actual())
ld_FechaInicio = Date('01/01/'+String(Year(ld_FechaActual))) 
ll_Semana = DaysAfter(ld_FechaInicio, ld_FechaActual) / 7 + 1
		
sle_week2.text = String(ll_semana)
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
String  	ls_empresa, ls_nombre, ls_especie, ls_prov_mp, ls_prov_transp, &
			ls_flag, ls_productor
Integer 	li_verifica, li_year1, li_week1, li_year2, li_week2

if rb_1.checked then
	ls_flag = '1'
elseif rb_2.checked then
	ls_flag = '2'
end if

ls_productor = '%%'

ld_fecha_ini 	= date(uo_fecha.of_get_fecha1( ))
ld_fecha_fin 	= date(uo_fecha.of_get_fecha2( ))

li_year1 = Integer(sle_year1.text)
li_year2 = Integer(sle_year2.text)
li_week1 = Integer(sle_week1.text)
li_week2 = Integer(sle_week2.text)

//Recupera los datos del reporte
idw_1.Retrieve(ls_flag, ld_fecha_ini, ld_fecha_fin, li_year1, li_year2, li_week1, li_week2, ls_productor)
ib_preview = true
event ue_preview()


/*idw_1.object.t_user.text 		= gs_user
idw_1.object.p_logo.filename 		= gs_logo
idw_1.object.t_desde.text 		= String(ld_fecha_ini)
idw_1.object.t_hasta.text 		= String(ld_fecha_fin)
idw_1.object.t_nombre.text	= ls_nombre*/

//idw_1.SetRedraw(true)


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

type st_1 from statictext within w_ap734_rpt_produccion_det
integer x = 1070
integer y = 124
integer width = 197
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "hasta"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_week2 from singlelineedit within w_ap734_rpt_produccion_det
integer x = 1518
integer y = 112
integer width = 137
integer height = 84
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean enabled = false
borderstyle borderstyle = stylelowered!
end type

type sle_year2 from singlelineedit within w_ap734_rpt_produccion_det
integer x = 1298
integer y = 112
integer width = 210
integer height = 84
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean enabled = false
borderstyle borderstyle = stylelowered!
end type

type sle_week1 from singlelineedit within w_ap734_rpt_produccion_det
integer x = 919
integer y = 112
integer width = 137
integer height = 84
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean enabled = false
borderstyle borderstyle = stylelowered!
end type

type sle_year1 from singlelineedit within w_ap734_rpt_produccion_det
integer x = 695
integer y = 112
integer width = 210
integer height = 84
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean enabled = false
borderstyle borderstyle = stylelowered!
end type

type rb_2 from radiobutton within w_ap734_rpt_produccion_det
integer x = 27
integer y = 116
integer width = 622
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Rango de Semanas"
end type

event clicked;if this.checked then
	sle_year1.enabled = true
	sle_week1.enabled = true
	sle_year2.enabled = true
	sle_week2.enabled = true
	uo_fecha.enabled = false
end if
end event

type rb_1 from radiobutton within w_ap734_rpt_produccion_det
integer x = 32
integer y = 16
integer width = 622
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Rango de Fecha:"
boolean checked = true
end type

event clicked;if this.checked then
	sle_year1.enabled = false
	sle_week1.enabled = false
	sle_year2.enabled = false
	sle_week2.enabled = false
	uo_fecha.enabled = true
end if
end event

type cb_1 from commandbutton within w_ap734_rpt_produccion_det
integer x = 2290
integer y = 32
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

type uo_fecha from u_ingreso_rango_fechas within w_ap734_rpt_produccion_det
integer x = 677
integer y = 12
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

type dw_report from u_dw_rpt within w_ap734_rpt_produccion_det
integer y = 256
integer width = 3470
integer height = 1452
integer taborder = 80
string dataobject = "d_rpt_produccion_det_tbl"
end type

event rowfocuschanged;call super::rowfocuschanged;selectRow(0, false)
SelectRow(currentrow, true)
SetRow(currentRow)
end event

