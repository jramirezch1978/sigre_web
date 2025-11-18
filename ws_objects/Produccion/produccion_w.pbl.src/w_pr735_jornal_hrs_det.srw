$PBExportHeader$w_pr735_jornal_hrs_det.srw
forward
global type w_pr735_jornal_hrs_det from w_report_smpl
end type
type pb_1 from picturebutton within w_pr735_jornal_hrs_det
end type
type cbx_trabajador from checkbox within w_pr735_jornal_hrs_det
end type
type sle_trabajador from singlelineedit within w_pr735_jornal_hrs_det
end type
type st_trabajador from statictext within w_pr735_jornal_hrs_det
end type
type uo_rango from u_ingreso_rango_fechas within w_pr735_jornal_hrs_det
end type
type cbx_destajo from checkbox within w_pr735_jornal_hrs_det
end type
type cbx_detalle from checkbox within w_pr735_jornal_hrs_det
end type
type gb_1 from groupbox within w_pr735_jornal_hrs_det
end type
end forward

global type w_pr735_jornal_hrs_det from w_report_smpl
integer width = 3995
integer height = 1356
string title = "[PR735] Resumen de Horas Trabajadas"
string menuname = "m_reporte"
event ue_query_retrieve ( )
pb_1 pb_1
cbx_trabajador cbx_trabajador
sle_trabajador sle_trabajador
st_trabajador st_trabajador
uo_rango uo_rango
cbx_destajo cbx_destajo
cbx_detalle cbx_detalle
gb_1 gb_1
end type
global w_pr735_jornal_hrs_det w_pr735_jornal_hrs_det

event ue_query_retrieve();this.event ue_retrieve()
end event

on w_pr735_jornal_hrs_det.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.pb_1=create pb_1
this.cbx_trabajador=create cbx_trabajador
this.sle_trabajador=create sle_trabajador
this.st_trabajador=create st_trabajador
this.uo_rango=create uo_rango
this.cbx_destajo=create cbx_destajo
this.cbx_detalle=create cbx_detalle
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.cbx_trabajador
this.Control[iCurrent+3]=this.sle_trabajador
this.Control[iCurrent+4]=this.st_trabajador
this.Control[iCurrent+5]=this.uo_rango
this.Control[iCurrent+6]=this.cbx_destajo
this.Control[iCurrent+7]=this.cbx_detalle
this.Control[iCurrent+8]=this.gb_1
end on

on w_pr735_jornal_hrs_det.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.pb_1)
destroy(this.cbx_trabajador)
destroy(this.sle_trabajador)
destroy(this.st_trabajador)
destroy(this.uo_rango)
destroy(this.cbx_destajo)
destroy(this.cbx_detalle)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;//ii_lec_mst = 0
end event

event ue_retrieve;call super::ue_retrieve;String 	ls_trabajador, ls_titulo
Date		ld_fecha1, ld_fecha2

ld_fecha1 = date(uo_rango.of_get_fecha1( ))
ld_fecha2 = date(uo_rango.of_get_fecha2( ))

If not cbx_trabajador.Checked Then
	ls_trabajador = sle_trabajador.text + "%"
Else
	ls_trabajador = '%%'
End If 

if ld_fecha1 = ld_fecha2 then
	ls_titulo = 'HORAS DE TRABAJADORES. DÍA ' + string(ld_fecha1, 'dd/mm/yyyy')
else
	ls_titulo = 'HORAS DE TRABAJADORES. PERIODO ' + string(ld_fecha1, 'dd/mm/yyyy') + ' - ' + string(ld_fecha2, 'dd/mm/yyyy')
end if

if cbx_destajo.checked then
	if cbx_detalle.checked then
		dw_report.dataobject = 'd_rpt_asistencia_jor_des_tbl'
	else
		dw_report.dataobject = 'd_rpt_asistencia_jor_des_res_tbl'
	end if
	dw_report.object.Datawindow.print.Paper.Size = 9
	dw_report.object.Datawindow.print.Orientation = 1
else
	dw_report.dataobject = 'd_rpt_asistencia_jor_tbl'
	dw_report.object.Datawindow.print.Paper.Size = 9
	dw_report.object.Datawindow.print.Orientation = 2
end if

dw_report.settransobject( sqlca )
ib_preview = false
event ue_preview()

dw_report.retrieve(ld_fecha1, ld_fecha2, ls_trabajador )

dw_report.object.p_logo.filename = gs_logo
dw_report.object.st_usuario.text = gs_user
dw_report.object.st_empresa.text = gs_empresa
dw_report.object.st_comentario.text 	= ls_titulo
dw_report.object.st_desde.text 	= string(ld_fecha1, 'dd/mm/yyyy')
dw_report.object.st_hasta.text 	= string(ld_fecha2, 'dd/mm/yyyy')


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

type dw_report from w_report_smpl`dw_report within w_pr735_jornal_hrs_det
integer x = 0
integer y = 304
integer width = 3314
integer height = 776
integer taborder = 10
string dataobject = "d_rpt_asistencia_jor_tbl"
string is_dwform = ""
end type

type pb_1 from picturebutton within w_pr735_jornal_hrs_det
integer x = 3163
integer y = 60
integer width = 357
integer height = 188
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "C:\SIGRE\resources\BMP\Aceptar.bmp"
end type

event clicked;parent.event ue_retrieve()
end event

type cbx_trabajador from checkbox within w_pr735_jornal_hrs_det
integer x = 50
integer y = 176
integer width = 667
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Todos los Trabajadores"
boolean checked = true
boolean lefttext = true
end type

event clicked;If not this.Checked Then
	sle_trabajador.enabled = true
	sle_trabajador.text=''
Else
	sle_trabajador.enabled = False
	sle_trabajador.text=''
End If
end event

type sle_trabajador from singlelineedit within w_pr735_jornal_hrs_det
event dobleclick pbm_lbuttondblclk
integer x = 745
integer y = 176
integer width = 288
integer height = 80
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean enabled = false
integer limit = 8
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean   lb_ret
string 	 ls_codigo, ls_data, ls_sql

ls_sql = "Select m.cod_trabajador as codigo, "&
			+"m.apel_paterno||' '||m.apel_materno||' '||m.nombre1||' '||m.nombre2 as nombre "&
  			+"from maestro m Where m.tipo_trabajador ='JOR'"
				  
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
	
if ls_codigo <> '' then
	this.text = ls_codigo
	st_trabajador.text = ls_data
end if
end event

type st_trabajador from statictext within w_pr735_jornal_hrs_det
integer x = 1051
integer y = 176
integer width = 1792
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
boolean enabled = false
boolean border = true
boolean focusrectangle = false
end type

type uo_rango from u_ingreso_rango_fechas within w_pr735_jornal_hrs_det
integer x = 59
integer y = 64
integer taborder = 40
boolean bringtotop = true
end type

on uo_rango.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;Date	ld_fecha_actual

ld_fecha_actual = Date(gnvo_app.of_fecha_actual(true))

of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
of_set_fecha(ld_fecha_actual, gnvo_app.of_last_date(ld_fecha_actual)) //para setear la fecha inicial
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final
end event

type cbx_destajo from checkbox within w_pr735_jornal_hrs_det
integer x = 2176
integer y = 68
integer width = 709
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Incluir Horas de Destajo"
end type

type cbx_detalle from checkbox within w_pr735_jornal_hrs_det
integer x = 1467
integer y = 68
integer width = 709
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Reporte Detallado x día"
boolean checked = true
end type

type gb_1 from groupbox within w_pr735_jornal_hrs_det
integer width = 3566
integer height = 288
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Parametros"
end type

