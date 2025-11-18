$PBExportHeader$w_ap720_rpt_recepcion_mp_x_especie.srw
$PBExportComments$Record de pesca de embarcaciones
forward
global type w_ap720_rpt_recepcion_mp_x_especie from w_rpt
end type
type rb_2 from radiobutton within w_ap720_rpt_recepcion_mp_x_especie
end type
type st_1 from statictext within w_ap720_rpt_recepcion_mp_x_especie
end type
type rb_1 from radiobutton within w_ap720_rpt_recepcion_mp_x_especie
end type
type dw_report_b from u_dw_rpt within w_ap720_rpt_recepcion_mp_x_especie
end type
type cb_1 from commandbutton within w_ap720_rpt_recepcion_mp_x_especie
end type
type uo_fecha from u_ingreso_rango_fechas within w_ap720_rpt_recepcion_mp_x_especie
end type
type dw_report from u_dw_rpt within w_ap720_rpt_recepcion_mp_x_especie
end type
type gb_1 from groupbox within w_ap720_rpt_recepcion_mp_x_especie
end type
end forward

global type w_ap720_rpt_recepcion_mp_x_especie from w_rpt
integer width = 2999
integer height = 1736
string title = "Recepción de Materia Prima por Especie (AP720)"
string menuname = "m_rpt"
windowstate windowstate = maximized!
event ue_query_retrieve ( )
rb_2 rb_2
st_1 st_1
rb_1 rb_1
dw_report_b dw_report_b
cb_1 cb_1
uo_fecha uo_fecha
dw_report dw_report
gb_1 gb_1
end type
global w_ap720_rpt_recepcion_mp_x_especie w_ap720_rpt_recepcion_mp_x_especie

type variables
String  isa_cod_origen[]
end variables

forward prototypes
public function boolean of_verificar ()
public function integer of_new_sheet (str_cns_pop astr_1)
end prototypes

event ue_query_retrieve();This.Event Dynamic ue_retrieve()
end event

public function boolean of_verificar ();// Verifica que no falten parametros para el reporte

boolean	lb_ok
return lb_ok

end function

public function integer of_new_sheet (str_cns_pop astr_1);Integer 			li_rc
w_abc_pop		lw_sheet_abc
w_cns_pop		lw_sheet_cns
w_ap720_rpt_recep_mp_dt_x_fecha		lw_sheet_rpt
w_grf_pop		lw_sheet_grf
w_cns_rtn_pop	lw_sheet_rtn

CHOOSE CASE Upper(astr_1.Tipo_Cascada)
	CASE 'A' // ABC
		li_rc = OpenSheetWithParm(lw_sheet_abc, astr_1, this, 0, Original!)
		ii_x ++
		iw_sheet[ii_x]  = lw_sheet_abc	
	CASE 'R' // Reporte
		li_rc = OpenSheetWithParm(lw_sheet_rpt, astr_1, this, 0, Original!)
		ii_x ++
		iw_sheet[ii_x]  = lw_sheet_rpt
	CASE 'G' // Grafico
		li_rc = OpenSheetWithParm(lw_sheet_grf, astr_1, this, 0, Original!)
		ii_x ++
		iw_sheet[ii_x]  = lw_sheet_grf
	CASE 'T' // Consulta con Retorno
		li_rc = OpenSheetWithParm(lw_sheet_rtn, astr_1, this, 0, Original!)
		ii_x ++
		iw_sheet[ii_x]  = lw_sheet_rtn
	CASE ELSE // Consulta
		li_rc = OpenSheetWithParm(lw_sheet_cns, astr_1, this, 0, Original!)
		ii_x ++
		iw_sheet[ii_x]  = lw_sheet_cns
END CHOOSE

RETURN li_rc     						
end function

on w_ap720_rpt_recepcion_mp_x_especie.create
int iCurrent
call super::create
if this.MenuName = "m_rpt" then this.MenuID = create m_rpt
this.rb_2=create rb_2
this.st_1=create st_1
this.rb_1=create rb_1
this.dw_report_b=create dw_report_b
this.cb_1=create cb_1
this.uo_fecha=create uo_fecha
this.dw_report=create dw_report
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_2
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.rb_1
this.Control[iCurrent+4]=this.dw_report_b
this.Control[iCurrent+5]=this.cb_1
this.Control[iCurrent+6]=this.uo_fecha
this.Control[iCurrent+7]=this.dw_report
this.Control[iCurrent+8]=this.gb_1
end on

on w_ap720_rpt_recepcion_mp_x_especie.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_2)
destroy(this.st_1)
destroy(this.rb_1)
destroy(this.dw_report_b)
destroy(this.cb_1)
destroy(this.uo_fecha)
destroy(this.dw_report)
destroy(this.gb_1)
end on

event resize;call super::resize;
dw_report.width = ((newwidth - 20 ) / 2)* 0.75
dw_report_b.width = (newwidth - dw_report.width - 10)
dw_report_b.x = dw_report.x + dw_report.width + 10


//dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
dw_report_b.height = newheight - dw_report.y
end event

event ue_open_pre;call super::ue_open_pre;long ll_row

idw_1 = dw_report

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

event ue_retrieve;call super::ue_retrieve;date   ld_fecha_ini, ld_fecha_fin
String ls_empresa, ls_nombre

ld_fecha_ini 	= date(uo_fecha.of_get_fecha1( ))
ld_fecha_fin 	= date(uo_fecha.of_get_fecha2( ))

if rb_1.checked then
	dw_report.DataObject 	= 'd_rpt_recepcion_mp_especie1_crt'
	dw_report_b.DataObject 	= 'd_rpt_recepcion_mp_especie1_grf'
else
	dw_report.DataObject 	= 'd_rpt_recepcion_mp_especie2_crt'
	dw_report_b.DataObject 	= 'd_rpt_recepcion_mp_especie2_grf'
end if

dw_report.SetTransObject(SQLCA)
dw_report_b.SetTransObject(SQLCA)

//Recupera los datos del reporte
dw_report.Retrieve(ld_fecha_ini, ld_fecha_fin)
dw_report_b.Retrieve(ld_fecha_ini, ld_fecha_fin)

dw_report.Visible = True
dw_report_b.Visible = True




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

type rb_2 from radiobutton within w_ap720_rpt_recepcion_mp_x_especie
integer x = 969
integer y = 172
integer width = 549
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Parte de recepcion"
end type

type st_1 from statictext within w_ap720_rpt_recepcion_mp_x_especie
integer x = 23
integer y = 180
integer width = 384
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Filtro de Fecha :"
boolean focusrectangle = false
end type

type rb_1 from radiobutton within w_ap720_rpt_recepcion_mp_x_especie
integer x = 411
integer y = 172
integer width = 549
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Inicio de descarga"
boolean checked = true
end type

type dw_report_b from u_dw_rpt within w_ap720_rpt_recepcion_mp_x_especie
integer x = 1422
integer y = 276
integer width = 1394
integer height = 1076
integer taborder = 90
string dataobject = "d_rpt_recepcion_mp_especie1_grf"
end type

event clicked;call super::clicked;idw_1 = This
end event

type cb_1 from commandbutton within w_ap720_rpt_recepcion_mp_x_especie
integer x = 2103
integer y = 20
integer width = 343
integer height = 100
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

type uo_fecha from u_ingreso_rango_fechas within w_ap720_rpt_recepcion_mp_x_especie
integer x = 18
integer y = 68
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

type dw_report from u_dw_rpt within w_ap720_rpt_recepcion_mp_x_especie
integer y = 276
integer width = 1394
integer height = 1076
integer taborder = 80
string dataobject = "d_rpt_recepcion_mp_especie1_crt"
end type

event doubleclicked;call super::doubleclicked;String 	ls_fecha
Date 		ld_fecha
Long	   li_return
Integer 	li_opcion

str_cns_pop lstr_1

If row = 0 Then Return
This.accepttext ()
lstr_1.DataObject = 'd_rpt_recep_mp_gen_det_tbl'
lstr_1.Width = 4460
lstr_1.Height= 2000
lstr_1.arg [1] = String(Date(This.Object.fecha[row]))
lstr_1.title = "(AP720) Reporte de Recepción de materias al " + lstr_1.arg [1]
lstr_1.tipo_cascada = 'R'
of_new_sheet(lstr_1)
end event

event clicked;call super::clicked;idw_1 = This
end event

type gb_1 from groupbox within w_ap720_rpt_recepcion_mp_x_especie
integer width = 2002
integer height = 264
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Parametros del reporte"
end type

