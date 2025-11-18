$PBExportHeader$w_ve746_detalle_pendientes_cobro.srw
forward
global type w_ve746_detalle_pendientes_cobro from w_rpt
end type
type cbx_origenes from checkbox within w_ve746_detalle_pendientes_cobro
end type
type cb_3 from commandbutton within w_ve746_detalle_pendientes_cobro
end type
type sle_origen from singlelineedit within w_ve746_detalle_pendientes_cobro
end type
type st_2 from statictext within w_ve746_detalle_pendientes_cobro
end type
type uo_1 from u_ingreso_rango_fechas within w_ve746_detalle_pendientes_cobro
end type
type cb_1 from commandbutton within w_ve746_detalle_pendientes_cobro
end type
type dw_report from u_dw_rpt within w_ve746_detalle_pendientes_cobro
end type
type gb_1 from groupbox within w_ve746_detalle_pendientes_cobro
end type
end forward

global type w_ve746_detalle_pendientes_cobro from w_rpt
integer width = 3799
integer height = 2404
string title = "[VE746] Detalle de Pendientes x Cobrar"
string menuname = "m_reporte"
cbx_origenes cbx_origenes
cb_3 cb_3
sle_origen sle_origen
st_2 st_2
uo_1 uo_1
cb_1 cb_1
dw_report dw_report
gb_1 gb_1
end type
global w_ve746_detalle_pendientes_cobro w_ve746_detalle_pendientes_cobro

on w_ve746_detalle_pendientes_cobro.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.cbx_origenes=create cbx_origenes
this.cb_3=create cb_3
this.sle_origen=create sle_origen
this.st_2=create st_2
this.uo_1=create uo_1
this.cb_1=create cb_1
this.dw_report=create dw_report
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_origenes
this.Control[iCurrent+2]=this.cb_3
this.Control[iCurrent+3]=this.sle_origen
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.uo_1
this.Control[iCurrent+6]=this.cb_1
this.Control[iCurrent+7]=this.dw_report
this.Control[iCurrent+8]=this.gb_1
end on

on w_ve746_detalle_pendientes_cobro.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cbx_origenes)
destroy(this.cb_3)
destroy(this.sle_origen)
destroy(this.st_2)
destroy(this.uo_1)
destroy(this.cb_1)
destroy(this.dw_report)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report
idw_1.Visible = true
idw_1.SetTransObject(sqlca)



//datos de reporte
ib_preview = true
This.Event ue_preview()

dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_empresa.text = gs_empresa
dw_report.object.t_user.text = gs_user

sle_origen.text = gs_origen
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

event ue_saveas;call super::ue_saveas;idw_1.EVENT ue_saveas()
end event

event ue_zoom;call super::ue_zoom;idw_1.EVENT ue_zoom(ai_zoom)
end event

type cbx_origenes from checkbox within w_ve746_detalle_pendientes_cobro
integer x = 1047
integer y = 216
integer width = 645
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Todos Los Origenes"
boolean checked = true
end type

event clicked;if this.checked then
	sle_origen.Enabled 	= FALSE
	sle_origen.Text	  	= '%'
	cb_3.enabled 			= false
else
	sle_origen.Enabled = TRUE
	sle_origen.Text	  = ''
	cb_3.enabled 			= true
end if
end event

type cb_3 from commandbutton within w_ve746_detalle_pendientes_cobro
integer x = 786
integer y = 216
integer width = 114
integer height = 80
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "..."
end type

event clicked;string ls_sql, ls_codigo, ls_data
boolean lb_ret

ls_sql = "SELECT COD_ORIGEN AS CODIGO_ORIGEN, " &
		  + "NOMBRE AS NOMBRE_ORIGEN " &
		  + "FROM ORIGEN " 
			 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
	
if ls_codigo <> '' then
	sle_origen.text		= ls_codigo
end if
end event

type sle_origen from singlelineedit within w_ve746_detalle_pendientes_cobro
integer x = 407
integer y = 212
integer width = 343
integer height = 76
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

type st_2 from statictext within w_ve746_detalle_pendientes_cobro
integer x = 78
integer y = 220
integer width = 288
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Origen :"
alignment alignment = right!
boolean focusrectangle = false
end type

type uo_1 from u_ingreso_rango_fechas within w_ve746_detalle_pendientes_cobro
event destroy ( )
integer x = 64
integer y = 80
integer taborder = 30
end type

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
of_set_fecha(date(today()),date(today()))
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final


end event

type cb_1 from commandbutton within w_ve746_detalle_pendientes_cobro
integer x = 1778
integer y = 48
integer width = 425
integer height = 200
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Reporte"
end type

event clicked;String 	ls_origen, ls_nombre
Date		ld_Fecha1, ld_fecha2


//para leer las fechas
ld_fecha1 = uo_1.of_get_fecha1()
ld_fecha2  = uo_1.of_get_fecha2()

//Busco el origen
if cbx_origenes.checked = False then
	ls_origen = sle_origen.text
	
	//buscar descripcion y exigir origen
	select nombre into :ls_nombre from origen where cod_origen = :ls_origen ;
	
	IF Isnull(ls_nombre) or Trim(ls_nombre) = '' THEN
		Messagebox('Aviso','Origen No Existe , Verifique!')
		Return
	END IF
	
	ls_origen = ls_origen + '%'
else
	ls_nombre = 'Todos Los Origenes'
	ls_origen = '%'	
end if

dw_report.Settransobject( sqlca)
dw_report.Retrieve(ld_fecha1, ld_fecha2, ls_origen)

//datos de reporte
ib_preview = true
Parent.Event ue_preview()

dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_empresa.text   = gs_empresa
dw_report.object.t_user.text     = gs_user
dw_report.object.t_titulo1.text  = 'DEL ' + string(ld_fecha1, 'dd/mm/yyyy') + ' AL ' + string(ld_fecha2, 'dd/mm/yyyy')

end event

type dw_report from u_dw_rpt within w_ve746_detalle_pendientes_cobro
integer y = 340
integer width = 3310
integer height = 1748
string dataobject = "d_rpt_detalle_pendientes_cobro_tbl"
boolean livescroll = false
end type

type gb_1 from groupbox within w_ve746_detalle_pendientes_cobro
integer x = 27
integer y = 16
integer width = 1687
integer height = 304
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Datos"
end type

