$PBExportHeader$w_ap724_recep_mp_x_transportista.srw
$PBExportComments$Record de pesca de embarcaciones
forward
global type w_ap724_recep_mp_x_transportista from w_rpt
end type
type cb_1 from commandbutton within w_ap724_recep_mp_x_transportista
end type
type uo_fecha from u_ingreso_rango_fechas within w_ap724_recep_mp_x_transportista
end type
type dw_report from u_dw_rpt within w_ap724_recep_mp_x_transportista
end type
end forward

global type w_ap724_recep_mp_x_transportista from w_rpt
integer width = 2779
integer height = 3208
string title = "Recepción de Materia Prima por Transportista (AP724)"
string menuname = "m_rpt"
windowstate windowstate = maximized!
long backcolor = 67108864
event ue_query_retrieve ( )
cb_1 cb_1
uo_fecha uo_fecha
dw_report dw_report
end type
global w_ap724_recep_mp_x_transportista w_ap724_recep_mp_x_transportista

type variables
String  isa_cod_origen[]
end variables

forward prototypes
public function boolean of_verificar ()
end prototypes

event ue_query_retrieve();This.Event Dynamic ue_retrieve()
end event

public function boolean of_verificar ();// Verifica que no falten parametros para el reporte

boolean	lb_ok
return lb_ok

end function

on w_ap724_recep_mp_x_transportista.create
int iCurrent
call super::create
if this.MenuName = "m_rpt" then this.MenuID = create m_rpt
this.cb_1=create cb_1
this.uo_fecha=create uo_fecha
this.dw_report=create dw_report
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.uo_fecha
this.Control[iCurrent+3]=this.dw_report
end on

on w_ap724_recep_mp_x_transportista.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.uo_fecha)
destroy(this.dw_report)
end on

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
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


DECLARE usp_ap_recep_mp_porc_trans PROCEDURE FOR 
	usp_ap_recep_mp_porc_trans(:ld_fecha_ini, :ld_fecha_fin) ;
EXECUTE usp_ap_recep_mp_porc_trans ;	

IF sqlca.sqlcode = -1 Then
	Rollback ;
	MessageBox( 'Error en usp_ap_recep_mp_porc_trans', sqlca.sqlerrtext, StopSign! )
	Return
End If

commit;
close usp_ap_recep_mp_porc_trans;

idw_1.SetTransObject(SQLCA)

Select g.cod_empresa 
	Into :ls_empresa 
from genparam g 
where g.reckey = '1';

Select e.nombre 
	Into :ls_nombre 
from empresa e 
where e.cod_empresa = :ls_empresa;

idw_1.Retrieve(ld_fecha_ini, ld_fecha_fin)
idw_1.object.t_user.text 		= gs_user
idw_1.object.p_logo.filename 		= gs_logo
idw_1.object.t_desde.text 		= String(ld_fecha_ini)
idw_1.object.t_hasta.text 		= String(ld_fecha_fin)
idw_1.object.t_nombre.text	= ls_nombre
idw_1.Visible = True
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

type cb_1 from commandbutton within w_ap724_recep_mp_x_transportista
integer x = 1376
integer y = 24
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

type uo_fecha from u_ingreso_rango_fechas within w_ap724_recep_mp_x_transportista
integer x = 55
integer y = 32
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

type dw_report from u_dw_rpt within w_ap724_recep_mp_x_transportista
integer x = 50
integer y = 164
integer width = 2651
integer height = 1532
integer taborder = 80
string dataobject = "d_rpt_ap_recepcion_mp_transporte_cps"
boolean hscrollbar = true
boolean vscrollbar = true
end type

