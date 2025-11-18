$PBExportHeader$w_fl720_indica_general.srw
forward
global type w_fl720_indica_general from w_rpt
end type
type ddlb_1 from dropdownlistbox within w_fl720_indica_general
end type
type uo_fecha from u_ingreso_rango_fechas within w_fl720_indica_general
end type
type cb_1 from commandbutton within w_fl720_indica_general
end type
type dw_report from u_dw_rpt within w_fl720_indica_general
end type
end forward

global type w_fl720_indica_general from w_rpt
integer width = 2619
integer height = 2212
string title = "Indicadores de Gestión US$ / TM (FL720)"
string menuname = "m_rep_grf"
long backcolor = 67108864
event ue_copiar ( )
ddlb_1 ddlb_1
uo_fecha uo_fecha
cb_1 cb_1
dw_report dw_report
end type
global w_fl720_indica_general w_fl720_indica_general

event ue_copiar();dw_report.ClipBoard("gr_1")
end event

event resize;call super::resize;dw_report.width  = newwidth  - dw_report.x - 10
dw_report.height = newheight - dw_report.y - 10
end event

event ue_retrieve;call super::ue_retrieve;integer 	li_ok
string 	ls_mensaje
date 		ld_fecha1, ld_fecha2

SetPointer(HourGlass!)

ld_fecha1 = uo_fecha.of_get_fecha1()
ld_fecha2 = uo_fecha.of_get_fecha2()

if left(ddlb_1.text,1) = 'a' then
	idw_1.dataobject = 'd_rpt_ratio_d2_x_tm_composite'
elseif left(ddlb_1.text,1) = 'b' then
	idw_1.dataobject = 'd_rpt_ratio_mat_x_tm_composite'
elseif left(ddlb_1.text,1) = 'c' then
	idw_1.dataobject = 'd_rpt_ratio_serv_x_tm_composite'
else
	MessageBox('Aviso', 'Indicador Incorrecto')
	return
end if
idw_1.SetTransObject(SQLCA)
idw_1.SetRedraw(False)
idw_1.Retrieve(ld_fecha1, ld_fecha2)
idw_1.SetRedraw(True)
idw_1.object.titulo2_t.text = 'PERIODO: ' + string(ld_fecha1, 'dd/mm/yyyy') &
	+ ' - ' + string(ld_fecha2, 'dd/mm/yyyy') 
idw_1.object.p_logo.filename = gs_logo
idw_1.object.usuario_t.text  = gs_user

SetPointer(Arrow!)

end event

on w_fl720_indica_general.create
int iCurrent
call super::create
if this.MenuName = "m_rep_grf" then this.MenuID = create m_rep_grf
this.ddlb_1=create ddlb_1
this.uo_fecha=create uo_fecha
this.cb_1=create cb_1
this.dw_report=create dw_report
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.ddlb_1
this.Control[iCurrent+2]=this.uo_fecha
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.dw_report
end on

on w_fl720_indica_general.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.ddlb_1)
destroy(this.uo_fecha)
destroy(this.cb_1)
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

idw_1.object.usuario_t.text 	= 'Usuario: ' + gs_user
idw_1.object.p_logo.filename 	= gs_logo
idw_1.object.Datawindow.Print.Orientation = 1


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

type ddlb_1 from dropdownlistbox within w_fl720_indica_general
integer x = 1317
integer y = 24
integer width = 800
integer height = 408
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean sorted = false
boolean vscrollbar = true
string item[] = {"a.- Petroleo D2 ","b.- Materiales","c.- Servicios"}
borderstyle borderstyle = stylelowered!
end type

type uo_fecha from u_ingreso_rango_fechas within w_fl720_indica_general
event destroy ( )
integer x = 37
integer y = 24
integer taborder = 40
end type

on uo_fecha.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;date 		ld_fecha1, ld_fecha2
Integer 	li_ano, li_mes

of_set_label('Desde:','Hasta:') //para setear la fecha inicial
of_set_fecha(date('01/01/1900'), date('31/12/9999')) // para seatear el titulo del boton
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final

li_ano = Year(Today())
li_mes = Month(Today())

if li_mes = 12 then
	li_mes = 1
	li_ano ++
else
	li_mes ++
end if

ld_fecha1 = date('01/' + String( month( today() ) ,'00' ) &
	+ '/' + string( year( today() ), '0000') )

ld_fecha2 = date('01/' + String( li_mes ,'00' ) &
	+ '/' + string(li_ano, '0000') )

ld_fecha2 = RelativeDate( ld_fecha2, -1 )

This.of_set_fecha( ld_fecha1, ld_fecha2 )

end event

type cb_1 from commandbutton within w_fl720_indica_general
integer x = 2185
integer y = 28
integer width = 343
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Recuperar"
end type

event clicked;parent.event dynamic ue_retrieve()
end event

type dw_report from u_dw_rpt within w_fl720_indica_general
integer y = 172
integer width = 2528
integer height = 1464
integer taborder = 60
string dataobject = "d_rpt_ratio_d2_x_tm_composite"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor;is_dwform = 'form'  // tabular (default), form 
end event

