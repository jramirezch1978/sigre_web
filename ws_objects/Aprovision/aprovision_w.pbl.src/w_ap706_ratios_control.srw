$PBExportHeader$w_ap706_ratios_control.srw
forward
global type w_ap706_ratios_control from w_rpt
end type
type st_1 from statictext within w_ap706_ratios_control
end type
type dw_report from u_dw_rpt within w_ap706_ratios_control
end type
type ddlb_mes from dropdownlistbox within w_ap706_ratios_control
end type
type pb_1 from picturebutton within w_ap706_ratios_control
end type
type dw_origen from u_dw_abc within w_ap706_ratios_control
end type
type uo_fecha from u_ingreso_rango_fechas_v within w_ap706_ratios_control
end type
end forward

global type w_ap706_ratios_control from w_rpt
integer width = 3520
integer height = 2180
string title = "Ratios Control (AP706)"
string menuname = "m_rpt"
windowstate windowstate = maximized!
long backcolor = 67108864
st_1 st_1
dw_report dw_report
ddlb_mes ddlb_mes
pb_1 pb_1
dw_origen dw_origen
uo_fecha uo_fecha
end type
global w_ap706_ratios_control w_ap706_ratios_control

type variables
String is_cod_origen
end variables

on w_ap706_ratios_control.create
int iCurrent
call super::create
if this.MenuName = "m_rpt" then this.MenuID = create m_rpt
this.st_1=create st_1
this.dw_report=create dw_report
this.ddlb_mes=create ddlb_mes
this.pb_1=create pb_1
this.dw_origen=create dw_origen
this.uo_fecha=create uo_fecha
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.dw_report
this.Control[iCurrent+3]=this.ddlb_mes
this.Control[iCurrent+4]=this.pb_1
this.Control[iCurrent+5]=this.dw_origen
this.Control[iCurrent+6]=this.uo_fecha
end on

on w_ap706_ratios_control.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.dw_report)
destroy(this.ddlb_mes)
destroy(this.pb_1)
destroy(this.dw_origen)
destroy(this.uo_fecha)
end on

event ue_open_pre;call super::ue_open_pre;long ll_row

idw_1 = dw_report
idw_1.Visible = False
idw_1.SetTransObject(sqlca)



// Para mostrar los origenes
dw_origen.SetTransObject(sqlca)
dw_origen.Retrieve()
ll_row = dw_origen.Find ("cod_origen = '" + gs_origen +"'", 1, dw_origen.RowCount())
dw_origen.object.chec[ll_row] = '1'

//Para seleccionar la zona de carga Chata
ddlb_mes.selectitem(1)


idw_1.visible = True
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

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

event ue_print;call super::ue_print;idw_1.EVENT ue_print()
end event

event ue_retrieve;call super::ue_retrieve;string 	ls_mensaje, ls_flag_zona
date  	ld_fecha_ini, ld_fecha_fin
integer 	li_ok


idw_1.SetRedraw(false)

ld_fecha_ini = uo_fecha.of_get_fecha1( )
ld_fecha_fin = uo_fecha.of_get_fecha2( )


CHOOSE CASE trim(ddlb_mes.text)
	CASE 'Chata'
		ls_flag_zona =	'C'
	CASE 'Planta'
		ls_flag_zona = 'P'
	CASE ELSE
		ls_flag_zona = 'Y'
END CHOOSE
 
DECLARE USP_AP_RATIOS_CONTROL PROCEDURE FOR
	USP_AP_RATIOS_CONTROL( :is_cod_origen, :ld_fecha_ini, :ld_fecha_fin , :ls_flag_zona);

EXECUTE USP_AP_RATIOS_CONTROL;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE USP_AP_RATIOS_CONTROL: " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	return
END IF

FETCH USP_AP_RATIOS_CONTROL INTO :ls_mensaje, :li_ok;
CLOSE USP_AP_RATIOS_CONTROL;

if li_ok <> 1 then
	MessageBox('Error USP_AP_RATIOS_CONTROL', ls_mensaje, StopSign!)	
	idw_1.Reset()
	return
end if

idw_1.Retrieve()

idw_1.object.usuario_t.text 		= gs_user
idw_1.object.p_logo.filename 		= gs_logo

idw_1.Visible = True
idw_1.SetRedraw(true)
end event

type st_1 from statictext within w_ap706_ratios_control
integer x = 800
integer y = 36
integer width = 485
integer height = 76
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Zona de Descarga"
boolean focusrectangle = false
end type

type dw_report from u_dw_rpt within w_ap706_ratios_control
integer x = 18
integer y = 308
integer width = 3442
integer height = 1576
integer taborder = 30
string dataobject = "d_ap_rpt_ratios_control_composite"
boolean hscrollbar = true
boolean vscrollbar = true
end type

type ddlb_mes from dropdownlistbox within w_ap706_ratios_control
integer x = 786
integer y = 112
integer width = 530
integer height = 312
integer taborder = 30
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean sorted = false
string item[] = {"Chata","Planta","Playa"}
borderstyle borderstyle = stylelowered!
end type

type pb_1 from picturebutton within w_ap706_ratios_control
integer x = 2679
integer y = 68
integer width = 306
integer height = 148
integer taborder = 30
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

IF ddlb_mes.Text = '' THEN
	messagebox('Aprovisionamiento', 'Por favor seleccione una Zona de descarga')
	return
END IF

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

type dw_origen from u_dw_abc within w_ap706_ratios_control
integer x = 1422
integer y = 24
integer width = 1001
integer height = 260
integer taborder = 30
string dataobject = "d_ap_origen_liq_pesca_tbl"
boolean vscrollbar = true
end type

event constructor;call super::constructor;is_dwform = 'form'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw
end event

type uo_fecha from u_ingreso_rango_fechas_v within w_ap706_ratios_control
integer x = 59
integer y = 36
integer taborder = 30
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
	ld_fecfin = RelativeDate(Date('01/' + '01' + '/' + string( Integer( string(Today(), 'yyyy') ) +1 ) ), -1)

end if

of_set_label('Desde:','Hasta:') 				// para setear el titulo del boton
of_set_fecha( ld_fecini, ld_fecfin)			// para setear la fecha
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final

// of_get_fecha1(), of_get_fecha2()  para leer las fechas




end event

