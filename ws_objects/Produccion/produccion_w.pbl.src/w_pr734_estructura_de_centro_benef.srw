$PBExportHeader$w_pr734_estructura_de_centro_benef.srw
forward
global type w_pr734_estructura_de_centro_benef from w_rpt
end type
type uo_fecha from u_ingreso_rango_fechas_v within w_pr734_estructura_de_centro_benef
end type
type em_origen from singlelineedit within w_pr734_estructura_de_centro_benef
end type
type em_descripcion from editmask within w_pr734_estructura_de_centro_benef
end type
type cb_2 from commandbutton within w_pr734_estructura_de_centro_benef
end type
type dw_report from u_dw_rpt within w_pr734_estructura_de_centro_benef
end type
type gb_3 from groupbox within w_pr734_estructura_de_centro_benef
end type
type gb_1 from groupbox within w_pr734_estructura_de_centro_benef
end type
end forward

global type w_pr734_estructura_de_centro_benef from w_rpt
integer width = 3026
integer height = 2244
string title = "Estructura de Centros de Beneficio(PR734)"
string menuname = "m_reporte"
long backcolor = 67108864
uo_fecha uo_fecha
em_origen em_origen
em_descripcion em_descripcion
cb_2 cb_2
dw_report dw_report
gb_3 gb_3
gb_1 gb_1
end type
global w_pr734_estructura_de_centro_benef w_pr734_estructura_de_centro_benef

on w_pr734_estructura_de_centro_benef.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.uo_fecha=create uo_fecha
this.em_origen=create em_origen
this.em_descripcion=create em_descripcion
this.cb_2=create cb_2
this.dw_report=create dw_report
this.gb_3=create gb_3
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_fecha
this.Control[iCurrent+2]=this.em_origen
this.Control[iCurrent+3]=this.em_descripcion
this.Control[iCurrent+4]=this.cb_2
this.Control[iCurrent+5]=this.dw_report
this.Control[iCurrent+6]=this.gb_3
this.Control[iCurrent+7]=this.gb_1
end on

on w_pr734_estructura_de_centro_benef.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_fecha)
destroy(this.em_origen)
destroy(this.em_descripcion)
destroy(this.cb_2)
destroy(this.dw_report)
destroy(this.gb_3)
destroy(this.gb_1)
end on

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report
idw_1.Visible = False
idw_1.SetTransObject(sqlca)
THIS.Event ue_preview()
//This.Event ue_retrieve()
IF UPPER(gs_lpp) = 'S' THEN THIS.EVENT ue_set_retrieve_as_needed('S')

 ii_help = 101           // help topic
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

event ue_retrieve;call super::ue_retrieve;string 	ls_cenbef, ls_mensaje, &
			ls_planta, ls_tipo, ls_desc
integer 	li_ok
date ld_fecha_ini, ld_fecha_fin

this.SetRedraw(false)

ld_fecha_ini = date(uo_fecha.of_get_fecha1( ))
ld_fecha_fin = date(uo_fecha.of_get_fecha2( ))
ls_cenbef	 = em_origen.text

IF ls_cenbef = '' or isnull(ls_cenbef) then
	Messagebox('Producción', 'Debe de Indicar un Centro de Beneficio')
	Return
end if

SELECT desc_centro INTO :ls_desc
FROM centro_beneficio
WHERE centro_benef =:ls_cenbef;
	
idw_1.Retrieve(ls_cenbef, ld_fecha_ini, ld_fecha_fin)
idw_1.Visible = True
idw_1.Object.p_logo.filename = gs_logo
idw_1.Object.t_user.text  = gs_user
idw_1.Object.t_fecha1.text  = string(ld_fecha_ini)
idw_1.Object.t_fecha2.text  = string(ld_fecha_fin)
idw_1.object.t_cenbef.text = ls_cenbef + ' ' + ls_desc
//idw_1.Object.Datawindow.Print.Orientation = '1'
this.SetRedraw(true)
end event

event ue_zoom;call super::ue_zoom;idw_1.EVENT ue_zoom(ai_zoom)
end event

type uo_fecha from u_ingreso_rango_fechas_v within w_pr734_estructura_de_centro_benef
integer x = 64
integer y = 84
integer height = 188
integer taborder = 70
boolean bringtotop = true
end type

event constructor;call super::constructor; of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
 of_set_fecha(today(), today()) //para setear la fecha inicial
 of_set_rango_inicio(date('01/01/1900')) // rango inicial
 of_set_rango_fin(date('31/12/9999')) // rango final
 //of_get_fecha1(), of_get_fecha2()  para leer las fechas
end event

on uo_fecha.destroy
call u_ingreso_rango_fechas_v::destroy
end on

type em_origen from singlelineedit within w_pr734_estructura_de_centro_benef
event dobleclick pbm_lbuttondblclk
integer x = 777
integer y = 88
integer width = 453
integer height = 72
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long backcolor = 16777215
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT centro_benef AS CODIGO, " &
				  + "DESC_centro AS DESCRIPCION " &
				  + "FROM centro_beneficio " &
				  + "WHERE FLAG_ESTADO = '1'"
				  
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
	
if ls_codigo <> '' then
	this.text = ls_codigo
	em_descripcion.text = ls_data
end if
end event

event modified;String 	ls_origen, ls_desc

ls_origen = this.text
if ls_origen = '' or IsNull(ls_origen) then
	MessageBox('Aviso', 'Debe Ingresar un codigo de Origen')
	return
end if

SELECT desc_centro INTO :ls_desc
FROM centro_beneficio
WHERE centro_benef =:ls_origen;

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Centro de Beneficio no existe')
	return
end if

em_descripcion.text = ls_desc
end event

type em_descripcion from editmask within w_pr734_estructura_de_centro_benef
integer x = 777
integer y = 184
integer width = 1335
integer height = 72
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 134217739
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type cb_2 from commandbutton within w_pr734_estructura_de_centro_benef
integer x = 2208
integer y = 128
integer width = 599
integer height = 100
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Generar Reporte"
end type

event clicked;SetPointer(HourGlass!)
Parent.event ue_retrieve()
SetPointer(Arrow!)
end event

type dw_report from u_dw_rpt within w_pr734_estructura_de_centro_benef
integer x = 46
integer y = 344
integer width = 2907
integer height = 1684
string dataobject = "d_rpt_estructura_de_cenbef_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

type gb_3 from groupbox within w_pr734_estructura_de_centro_benef
integer x = 745
integer y = 20
integer width = 1403
integer height = 276
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Centro de Beneficio"
end type

type gb_1 from groupbox within w_pr734_estructura_de_centro_benef
integer x = 41
integer y = 16
integer width = 663
integer height = 284
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Rango de Fechas"
end type

