$PBExportHeader$w_ap700_contol_desembarque.srw
forward
global type w_ap700_contol_desembarque from w_rpt
end type
type uo_fecha from u_ingreso_rango_fechas_v within w_ap700_contol_desembarque
end type
type pb_1 from picturebutton within w_ap700_contol_desembarque
end type
type dw_origen from u_dw_abc within w_ap700_contol_desembarque
end type
type dw_report from u_dw_rpt within w_ap700_contol_desembarque
end type
end forward

global type w_ap700_contol_desembarque from w_rpt
integer width = 3095
integer height = 2072
string title = "Control de Desembarque (AP700)"
string menuname = "m_rpt"
windowstate windowstate = maximized!
long backcolor = 67108864
uo_fecha uo_fecha
pb_1 pb_1
dw_origen dw_origen
dw_report dw_report
end type
global w_ap700_contol_desembarque w_ap700_contol_desembarque

type variables
String is_cod_origen
end variables

on w_ap700_contol_desembarque.create
int iCurrent
call super::create
if this.MenuName = "m_rpt" then this.MenuID = create m_rpt
this.uo_fecha=create uo_fecha
this.pb_1=create pb_1
this.dw_origen=create dw_origen
this.dw_report=create dw_report
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_fecha
this.Control[iCurrent+2]=this.pb_1
this.Control[iCurrent+3]=this.dw_origen
this.Control[iCurrent+4]=this.dw_report
end on

on w_ap700_contol_desembarque.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_fecha)
destroy(this.pb_1)
destroy(this.dw_origen)
destroy(this.dw_report)
end on

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

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

event ue_open_pre;call super::ue_open_pre;long ll_row

idw_1 = dw_report
idw_1.Visible = False
idw_1.SetTransObject(sqlca)

// Para mostrar los origenes
dw_origen.SetTransObject(sqlca)
dw_origen.Retrieve()
  
ll_row = dw_origen.Find ("cod_origen = '" + gs_origen +"'", 1, dw_origen.RowCount())

dw_origen.object.chec[ll_row] = '1'

THIS.Event ue_preview()
end event

event ue_retrieve;call super::ue_retrieve;Long 		ll_cuenta
String 	ls_direccion, ls_nombre, ls_ruc, ls_periodo, ls_mensaje
Date   	ld_fecha_ini, ld_fecha_fin

ld_fecha_ini = uo_fecha.of_get_fecha1()
ld_fecha_fin = uo_fecha.of_get_fecha2()
ls_periodo = String(ld_fecha_ini, 'dd/mm/yyyy') + ' - ' + String(ld_fecha_fin,'dd/mm/yyyy')

DECLARE usp_reporte PROCEDURE FOR 
 usp_ap_control_descarga(:is_cod_origen, :ld_fecha_ini, :ld_fecha_fin, :gs_empresa);

EXECUTE usp_reporte;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE USP_AP_CONTROL_DESCARGA: " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	Return
END IF

FETCH usp_reporte INTO :ll_cuenta, :ls_direccion, :ls_nombre, :ls_ruc;

IF ll_cuenta >= 1 THEN
	idw_1.Retrieve()
	idw_1.object.t_nombre.text 	= ls_nombre
	idw_1.object.t_direccion.text	= ls_direccion
	idw_1.object.t_ruc.text 		= ls_ruc
	idw_1.object.t_periodo.text 	= ls_periodo
	idw_1.object.p_logo.filename 	= 'H:\source\Jpg\produce.jpg'
	idw_1.object.usuario_t.text	=	gs_user
	idw_1.Visible = TRUE
ELSE
	messagebox('Control de desembarque de recursos hidrobiológicos','No se han encontrado datos de descargas realizadas en el periodo '+ls_periodo ,StopSign!)
	idw_1.Visible = FALSE
END IF

CLOSE usp_reporte;

end event

type uo_fecha from u_ingreso_rango_fechas_v within w_ap700_contol_desembarque
event destroy ( )
integer x = 82
integer y = 48
integer taborder = 40
end type

on uo_fecha.destroy
call u_ingreso_rango_fechas_v::destroy
end on

event constructor;call super::constructor;date ld_fecini, ld_fecfin
string ls_fecha


ld_fecini = Date('01/'+string(Today(),'mm/yyyy') )

if string(Today(), 'mm' ) <> '12' then
	ld_fecfin = RelativeDate(Date('01/' + string( Integer( string(Today(),'mm') ) + 1 ) &
		+ '/' + string( Today(), 'yyyy')), -1)
else
	ld_fecfin = RelativeDate(Date('01/' + string( Integer( string(Today(),'mm') ) + 1 ) &
		+ '/' + string( Integer( string(Today(), 'yyyy') ) +1 ) ), -1)
	
end if

of_set_label('Desde:','Hasta:') 				// para seatear el titulo del boton
of_set_fecha( ld_fecini, ld_fecfin)			// para setear la fecha
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final

// of_get_fecha1(), of_get_fecha2()  para leer las fechas




end event

type pb_1 from picturebutton within w_ap700_contol_desembarque
integer x = 2569
integer y = 60
integer width = 306
integer height = 148
integer taborder = 20
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "H:\source\BMP\procesar_enb.bmp"
alignment htextalign = left!
end type

event clicked;long ll_i
String ls_separador

is_cod_origen = ''
ls_separador  = ''


// leer el dw_origen con los origenes seleccionados

For ll_i = 1 To dw_origen.RowCount()
	If dw_origen.Object.Chec[ll_i] = '1' Then
		if is_cod_origen <>'' THEN ls_separador = ', '
		is_cod_origen = is_cod_origen + ls_separador + dw_origen.Object.cod_origen[ll_i]
	end if
Next

IF LEN(is_cod_origen) = 0 THEN
	messagebox('Aprovisionamiento', 'Debe seleccionar al menos un origen para el Reporte')
	return
END IF

parent.event ue_retrieve()
end event

type dw_origen from u_dw_abc within w_ap700_contol_desembarque
integer x = 1061
integer y = 16
integer width = 1001
integer height = 260
string dataobject = "d_ap_origen_liq_pesca_tbl"
boolean vscrollbar = true
end type

event constructor;call super::constructor;is_dwform = 'form'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw
end event

type dw_report from u_dw_rpt within w_ap700_contol_desembarque
integer x = 5
integer y = 312
integer width = 3003
integer height = 1552
string dataobject = "d_ap_control_desembarque_cpst"
boolean hscrollbar = true
boolean vscrollbar = true
end type

