$PBExportHeader$w_ap732_productores_sin_lc.srw
$PBExportComments$Record de pesca de embarcaciones
forward
global type w_ap732_productores_sin_lc from w_rpt
end type
type cb_1 from commandbutton within w_ap732_productores_sin_lc
end type
type uo_fecha from u_ingreso_rango_fechas within w_ap732_productores_sin_lc
end type
type dw_report from u_dw_rpt within w_ap732_productores_sin_lc
end type
end forward

global type w_ap732_productores_sin_lc from w_rpt
integer width = 3671
integer height = 3208
string title = "[AP732] Productores sin Liquidación de OC"
string menuname = "m_rpt"
event ue_query_retrieve ( )
cb_1 cb_1
uo_fecha uo_fecha
dw_report dw_report
end type
global w_ap732_productores_sin_lc w_ap732_productores_sin_lc

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

on w_ap732_productores_sin_lc.create
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

on w_ap732_productores_sin_lc.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
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

ld_FechaActual = Date(f_fecha_actual())
ld_FechaInicio = Date('01/01/'+String(Year(ld_FechaActual))) 

		

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
			ls_flag
Integer 	li_verifica, li_year1, li_week1, li_year2, li_week2

ld_fecha_ini 	= date(uo_fecha.of_get_fecha1( ))
ld_fecha_fin 	= date(uo_fecha.of_get_fecha2( ))

//Recupera los datos del reporte
idw_1.Retrieve(ld_fecha_ini, ld_fecha_fin)
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

type cb_1 from commandbutton within w_ap732_productores_sin_lc
integer x = 1298
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

type uo_fecha from u_ingreso_rango_fechas within w_ap732_productores_sin_lc
integer y = 40
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

type dw_report from u_dw_rpt within w_ap732_productores_sin_lc
integer y = 196
integer width = 3470
integer height = 1400
integer taborder = 80
string dataobject = "d_rpt_productor_sin_lc_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event rowfocuschanged;call super::rowfocuschanged;selectRow(0, false)
SelectRow(currentrow, true)
SetRow(currentRow)
end event

