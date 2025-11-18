$PBExportHeader$w_fl704_costo_diario.srw
forward
global type w_fl704_costo_diario from w_rpt
end type
type cb_1 from commandbutton within w_fl704_costo_diario
end type
type uo_fecha from u_ingreso_fecha within w_fl704_costo_diario
end type
type dw_report from u_dw_rpt within w_fl704_costo_diario
end type
end forward

global type w_fl704_costo_diario from w_rpt
integer width = 2226
integer height = 1868
string title = "Costo Diario de Flota Propia (FL704)"
string menuname = "m_rep_grf"
long backcolor = 67108864
event ue_copiar ( )
cb_1 cb_1
uo_fecha uo_fecha
dw_report dw_report
end type
global w_fl704_costo_diario w_fl704_costo_diario

event ue_copiar();dw_report.ClipBoard("gr_1")
end event

event resize;call super::resize;dw_report.width  = newwidth  - dw_report.x - 10
dw_report.height = newheight - dw_report.y - 10
end event

event ue_retrieve;call super::ue_retrieve;integer 	li_ok, li_year
string 	ls_mensaje
date 		ld_fecha, ld_ini_sem, ld_fin_sem, ld_ini_mes, ld_fin_mes
Decimal	ldc_tipo_cambio

SetPointer(HourGlass!)

ld_fecha = uo_fecha.of_get_fecha()

select fecha_inicio, fecha_fin
	into :ld_ini_sem, :ld_fin_sem
from semanas
where trunc(:ld_fecha) between trunc(fecha_inicio) and trunc(fecha_fin);

select vta_dol_prom
	into :ldc_tipo_cambio
from calendario
where trunc(fecha) = trunc(:ld_fecha);

ld_ini_mes = Date('01/' + string(ld_fecha, 'mm/yyyy'))
ld_fin_mes = Date('01/' + String(Integer(String(ld_fecha, 'mm')) + 1) + string(ld_fecha, '/yyyy'))
ld_fin_mes = RelativeDate(ld_fin_mes, -1)

//create or replace procedure USP_FL_COSTO_DIARIO(
//    adi_fecha 	in date
//) is

DECLARE USP_FL_COSTO_DIARIO PROCEDURE FOR
	USP_FL_COSTO_DIARIO( :ld_fecha );

EXECUTE USP_FL_COSTO_DIARIO;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE USP_FL_COSTO_DIARIO: " + SQLCA.SQLErrText
	Rollback ;
	SetPointer(Arrow!)
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	return
END IF

CLOSE USP_FL_COSTO_DIARIO;

idw_1.SetRedraw(False)
idw_1.Retrieve()
ib_preview = false
idw_1.ii_zoom_actual = 120
event ue_preview()
idw_1.SetRedraw(True)

idw_1.object.t_dia.text 			= string(ld_fecha, 'dd/mm/yyyy')
idw_1.object.t_ini_sem.text 		= string(ld_ini_sem, 'dd/mm/yyyy')
idw_1.object.t_fin_sem.text 		= string(ld_fin_sem, 'dd/mm/yyyy')
idw_1.object.t_ini_mes.text 		= string(ld_ini_mes, 'dd/mm/yyyy')
idw_1.object.t_fin_mes.text 		= string(ld_fin_mes, 'dd/mm/yyyy')
idw_1.object.t_aprobado_por.text = 'J.L.W.K'
idw_1.object.t_year.text 			= string(ld_fecha, 'dd/mm/yyyy')
idw_1.object.t_empresa.text 		= gs_empresa
idw_1.object.t_objeto.text 		= this.classname()
idw_1.object.t_tipo_cambio.text 	= string(ldc_tipo_cambio, '###,##0.000')


SetPointer(Arrow!)

end event

on w_fl704_costo_diario.create
int iCurrent
call super::create
if this.MenuName = "m_rep_grf" then this.MenuID = create m_rep_grf
this.cb_1=create cb_1
this.uo_fecha=create uo_fecha
this.dw_report=create dw_report
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.uo_fecha
this.Control[iCurrent+3]=this.dw_report
end on

on w_fl704_costo_diario.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.uo_fecha)
destroy(this.dw_report)
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

//idw_1.object.usuario_t.text 	= 'Usuario: ' + gs_user
idw_1.object.p_logo.filename 	= gs_logo
idw_1.object.Datawindow.Print.Orientation = 2


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

type cb_1 from commandbutton within w_fl704_costo_diario
integer x = 1001
integer y = 24
integer width = 343
integer height = 96
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Recuperar"
end type

event clicked;SetPointer(HourGlass!)
parent.event dynamic ue_retrieve()
SetPointer(Arrow!)
end event

type uo_fecha from u_ingreso_fecha within w_fl704_costo_diario
integer x = 389
integer y = 24
integer taborder = 20
end type

on uo_fecha.destroy
call u_ingreso_fecha::destroy
end on

event constructor;call super::constructor;of_set_label('Fecha:') //para setear la fecha inicial
of_set_fecha(TODAY()) // para seatear el titulo del boton
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final
end event

type dw_report from u_dw_rpt within w_fl704_costo_diario
integer y = 140
integer width = 2167
integer height = 1464
integer taborder = 60
string dataobject = "d_rpt_costo_diario_composite"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor;is_dwform = 'form'  // tabular (default), form 
end event

