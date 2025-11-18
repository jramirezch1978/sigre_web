$PBExportHeader$w_cam713_rpt_liquidacion_x_productor.srw
forward
global type w_cam713_rpt_liquidacion_x_productor from w_rpt
end type
type rb_ambos from radiobutton within w_cam713_rpt_liquidacion_x_productor
end type
type rb_dolar from radiobutton within w_cam713_rpt_liquidacion_x_productor
end type
type rb_soles from radiobutton within w_cam713_rpt_liquidacion_x_productor
end type
type st_1 from statictext within w_cam713_rpt_liquidacion_x_productor
end type
type cbx_1 from checkbox within w_cam713_rpt_liquidacion_x_productor
end type
type cb_1 from commandbutton within w_cam713_rpt_liquidacion_x_productor
end type
type uo_fecha from u_ingreso_rango_fechas within w_cam713_rpt_liquidacion_x_productor
end type
type dw_report from u_dw_rpt within w_cam713_rpt_liquidacion_x_productor
end type
type gb_1 from groupbox within w_cam713_rpt_liquidacion_x_productor
end type
end forward

global type w_cam713_rpt_liquidacion_x_productor from w_rpt
integer x = 256
integer y = 348
integer width = 3767
integer height = 1988
string title = "Consolidado de Compras por Productor (CAM713)"
string menuname = "m_rpt_smpl"
rb_ambos rb_ambos
rb_dolar rb_dolar
rb_soles rb_soles
st_1 st_1
cbx_1 cbx_1
cb_1 cb_1
uo_fecha uo_fecha
dw_report dw_report
gb_1 gb_1
end type
global w_cam713_rpt_liquidacion_x_productor w_cam713_rpt_liquidacion_x_productor

type variables
String 			is_cod_origen, is_nro_liq

end variables

on w_cam713_rpt_liquidacion_x_productor.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_smpl" then this.MenuID = create m_rpt_smpl
this.rb_ambos=create rb_ambos
this.rb_dolar=create rb_dolar
this.rb_soles=create rb_soles
this.st_1=create st_1
this.cbx_1=create cbx_1
this.cb_1=create cb_1
this.uo_fecha=create uo_fecha
this.dw_report=create dw_report
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_ambos
this.Control[iCurrent+2]=this.rb_dolar
this.Control[iCurrent+3]=this.rb_soles
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.cbx_1
this.Control[iCurrent+6]=this.cb_1
this.Control[iCurrent+7]=this.uo_fecha
this.Control[iCurrent+8]=this.dw_report
this.Control[iCurrent+9]=this.gb_1
end on

on w_cam713_rpt_liquidacion_x_productor.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_ambos)
destroy(this.rb_dolar)
destroy(this.rb_soles)
destroy(this.st_1)
destroy(this.cbx_1)
destroy(this.cb_1)
destroy(this.uo_fecha)
destroy(this.dw_report)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report
idw_1.SetTransObject(sqlca)
this.Event ue_preview()
end event

event ue_print;call super::ue_print;idw_1.EVENT ue_print()
end event

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y

//this.windowstate = maximized!
end event

event ue_preview();call super::ue_preview;IF ib_preview THEN
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

type rb_ambos from radiobutton within w_cam713_rpt_liquidacion_x_productor
integer x = 1833
integer y = 196
integer width = 320
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Ambos"
boolean checked = true
end type

type rb_dolar from radiobutton within w_cam713_rpt_liquidacion_x_productor
integer x = 1833
integer y = 128
integer width = 320
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Dolares"
end type

type rb_soles from radiobutton within w_cam713_rpt_liquidacion_x_productor
integer x = 1833
integer y = 60
integer width = 320
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Soles"
end type

type st_1 from statictext within w_cam713_rpt_liquidacion_x_productor
integer x = 1381
integer y = 64
integer width = 411
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Elegir Moneda:"
alignment alignment = right!
boolean focusrectangle = false
end type

type cbx_1 from checkbox within w_cam713_rpt_liquidacion_x_productor
integer x = 50
integer y = 184
integer width = 965
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Incluir Semana de Produccion"
boolean checked = true
end type

type cb_1 from commandbutton within w_cam713_rpt_liquidacion_x_productor
integer x = 2199
integer y = 60
integer width = 443
integer height = 192
integer taborder = 30
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Filtrar "
end type

event clicked;date   ld_fecha_ini, ld_fecha_fin

ld_fecha_ini 	= date(uo_fecha.of_get_fecha1( ))
ld_fecha_fin 	= date(uo_fecha.of_get_fecha2( ))

if rb_ambos.checked then
	if cbx_1.checked then
		dw_report.DataObject = 'd_rpt_liq_x_productor'
	else
		dw_report.DataObject = 'd_rpt_liq_x_productor_sin_sem_tbl'
	end if
end if

dw_report.SetTransObject(SQLCA)
dw_report.Retrieve(ld_fecha_ini, ld_fecha_fin)

dw_report.Object.p_logo.filename = gs_logo
dw_report.Object.t_empresa.text 	= gnvo_app.empresa.is_nom_empresa
dw_report.Object.t_usuario.text 	= gs_user
dw_report.Object.t_objeto.text 	= this.ClassName( )


end event

type uo_fecha from u_ingreso_rango_fechas within w_cam713_rpt_liquidacion_x_productor
integer x = 46
integer y = 76
integer taborder = 50
end type

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

on uo_fecha.destroy
call u_ingreso_rango_fechas::destroy
end on

type dw_report from u_dw_rpt within w_cam713_rpt_liquidacion_x_productor
integer y = 288
integer width = 3273
integer height = 1408
boolean bringtotop = true
string dataobject = "d_rpt_liq_x_productor"
boolean hscrollbar = true
boolean vscrollbar = true
end type

type gb_1 from groupbox within w_cam713_rpt_liquidacion_x_productor
integer width = 2747
integer height = 280
integer taborder = 60
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Parametros de Búsqueda"
end type

