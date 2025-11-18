$PBExportHeader$w_pr727_reporte_de_asistencia.srw
forward
global type w_pr727_reporte_de_asistencia from w_rpt
end type
type cbx_trabajador from checkbox within w_pr727_reporte_de_asistencia
end type
type cbx_tipo_m from checkbox within w_pr727_reporte_de_asistencia
end type
type em_tipo_m from singlelineedit within w_pr727_reporte_de_asistencia
end type
type sle_desc_tipo_m from singlelineedit within w_pr727_reporte_de_asistencia
end type
type uo_fecha from ou_rango_fechas within w_pr727_reporte_de_asistencia
end type
type pb_1 from picturebutton within w_pr727_reporte_de_asistencia
end type
type sle_codigo from singlelineedit within w_pr727_reporte_de_asistencia
end type
type sle_nombre from singlelineedit within w_pr727_reporte_de_asistencia
end type
type st_1 from statictext within w_pr727_reporte_de_asistencia
end type
type dw_report from u_dw_rpt within w_pr727_reporte_de_asistencia
end type
type gb_4 from groupbox within w_pr727_reporte_de_asistencia
end type
type gb_2 from groupbox within w_pr727_reporte_de_asistencia
end type
type gb_3 from groupbox within w_pr727_reporte_de_asistencia
end type
end forward

global type w_pr727_reporte_de_asistencia from w_rpt
integer width = 4055
integer height = 2132
string title = "Reporte de Asistencias(PR727)"
string menuname = "m_reporte"
long backcolor = 67108864
cbx_trabajador cbx_trabajador
cbx_tipo_m cbx_tipo_m
em_tipo_m em_tipo_m
sle_desc_tipo_m sle_desc_tipo_m
uo_fecha uo_fecha
pb_1 pb_1
sle_codigo sle_codigo
sle_nombre sle_nombre
st_1 st_1
dw_report dw_report
gb_4 gb_4
gb_2 gb_2
gb_3 gb_3
end type
global w_pr727_reporte_de_asistencia w_pr727_reporte_de_asistencia

on w_pr727_reporte_de_asistencia.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.cbx_trabajador=create cbx_trabajador
this.cbx_tipo_m=create cbx_tipo_m
this.em_tipo_m=create em_tipo_m
this.sle_desc_tipo_m=create sle_desc_tipo_m
this.uo_fecha=create uo_fecha
this.pb_1=create pb_1
this.sle_codigo=create sle_codigo
this.sle_nombre=create sle_nombre
this.st_1=create st_1
this.dw_report=create dw_report
this.gb_4=create gb_4
this.gb_2=create gb_2
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_trabajador
this.Control[iCurrent+2]=this.cbx_tipo_m
this.Control[iCurrent+3]=this.em_tipo_m
this.Control[iCurrent+4]=this.sle_desc_tipo_m
this.Control[iCurrent+5]=this.uo_fecha
this.Control[iCurrent+6]=this.pb_1
this.Control[iCurrent+7]=this.sle_codigo
this.Control[iCurrent+8]=this.sle_nombre
this.Control[iCurrent+9]=this.st_1
this.Control[iCurrent+10]=this.dw_report
this.Control[iCurrent+11]=this.gb_4
this.Control[iCurrent+12]=this.gb_2
this.Control[iCurrent+13]=this.gb_3
end on

on w_pr727_reporte_de_asistencia.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cbx_trabajador)
destroy(this.cbx_tipo_m)
destroy(this.em_tipo_m)
destroy(this.sle_desc_tipo_m)
destroy(this.uo_fecha)
destroy(this.pb_1)
destroy(this.sle_codigo)
destroy(this.sle_nombre)
destroy(this.st_1)
destroy(this.dw_report)
destroy(this.gb_4)
destroy(this.gb_2)
destroy(this.gb_3)
end on

event ue_open_pre;//Overrride

idw_1 = dw_report
idw_1.Visible = False
idw_1.SetTransObject(sqlca)
THIS.Event ue_preview()
//This.Event ue_retrieve()
IF UPPER(gs_lpp) = 'S' THEN THIS.EVENT ue_set_retrieve_as_needed('S')

 ii_help = 101           // help topic
end event

event ue_retrieve;call super::ue_retrieve;string 	ls_tipo, ls_cod_trabajador, ls_origen
integer 	li_ok
date 		ld_fecha_ini, ld_fecha_fin

ld_fecha_ini = date(uo_fecha.of_get_fecha1( ))
ld_fecha_fin = date(uo_fecha.of_get_fecha2( ))
ls_tipo      = em_tipo_m.text

if cbx_tipo_m.checked = true then
			ls_tipo	= '%%'
 	else
			ls_tipo	= em_tipo_m.text
end if
		
if ls_tipo = '' or IsNull( ls_tipo) then
			MessageBox('Aviso', 'El tipo no ha sido Definido', StopSign!)
return
end if


if cbx_trabajador.checked = false THEN
	
	IF LEN(trim(sle_codigo.text)) < 0 THEN
		MESSAGEBOX('Aviso', 'Debe de Seleccionar al Menos un trabajador')
	Return
	End if
	
   ls_cod_trabajador 	= 	trim(sle_codigo.text)
	
	this.SetRedraw(false)

		idw_1.dataobject 		= 	'd_rpt_detalle_asistencia_tbl'
		idw_1.settransobject(sqlca)
		idw_1.Retrieve(ld_fecha_ini, ld_fecha_fin, ls_cod_trabajador, ls_tipo)
		idw_1.Visible = True
		idw_1.Object.p_logo.filename = gs_logo
		idw_1.Object.usuario_t.text  = gs_user
		idw_1.Object.t_fecha1.text   = string(ld_fecha_ini)
		idw_1.Object.t_fecha2.text   = string(ld_fecha_fin)
		idw_1.Object.Datawindow.Print.Orientation = '1'
		this.SetRedraw(true)
		
else
	
		this.SetRedraw(false)
		
		idw_1.dataobject 		= 	'd_rpt_detalle_asistencia_v_tbl'
		idw_1.settransobject(sqlca)
		idw_1.Retrieve(ld_fecha_ini, ld_fecha_fin, ls_tipo)
		idw_1.Visible = True
		idw_1.Object.p_logo.filename = gs_logo
		idw_1.Object.usuario_t.text  = gs_user
		idw_1.Object.t_fecha1.text   = string(ld_fecha_ini)
		idw_1.Object.t_fecha2.text   = string(ld_fecha_fin)
		idw_1.Object.Datawindow.Print.Orientation = '1'
		this.SetRedraw(true)
		
end if
end event

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

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

type cbx_trabajador from checkbox within w_pr727_reporte_de_asistencia
integer x = 128
integer y = 392
integer width = 91
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

event clicked;if this.checked = true then
	
	sle_codigo.enabled = false
	sle_codigo.text = '' 
	
else
	
	sle_codigo.enabled = true

end if
end event

type cbx_tipo_m from checkbox within w_pr727_reporte_de_asistencia
integer x = 1627
integer y = 116
integer width = 91
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

event clicked;if this.checked = true then
	
	em_tipo_m.enabled = false
	em_tipo_m.text = '' 
	
else
	
	em_tipo_m.enabled = true

end if
end event

type em_tipo_m from singlelineedit within w_pr727_reporte_de_asistencia
event dobleclick pbm_lbuttondblclk
integer x = 1787
integer y = 124
integer width = 219
integer height = 68
integer taborder = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long backcolor = 16777215
boolean autohscroll = false
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT t.cod_tipo_mov as codigo, t.desc_movimi AS DESCRIPCION " &
				  + "FROM tipo_mov_asistencia t order by t.cod_tipo_mov"
				 
lb_ret = f_lista(ls_sql, ls_codigo, &
			ls_data, '1')
		
if ls_codigo <> '' then
	
this.text= ls_codigo

sle_desc_tipo_m.text = ls_data

end if
end event

event modified;String ls_tipo, ls_desc

ls_tipo = this.text
if ls_tipo = '' or IsNull(ls_tipo) then
	MessageBox('Aviso', 'Debe Ingresar un Tipo')
	return
end if

SELECT desc_movimi INTO :ls_desc
FROM tipo_mov_asistencia
WHERE cod_tipo_mov =:ls_tipo;

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de Tipo no existe')
	sle_desc_tipo_m.text = ''
	return
end if

sle_desc_tipo_m.text = ls_desc


end event

type sle_desc_tipo_m from singlelineedit within w_pr727_reporte_de_asistencia
integer x = 2016
integer y = 124
integer width = 969
integer height = 72
integer taborder = 90
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 134217739
string text = " "
borderstyle borderstyle = stylelowered!
end type

type uo_fecha from ou_rango_fechas within w_pr727_reporte_de_asistencia
event destroy ( )
integer x = 160
integer y = 116
integer taborder = 70
boolean bringtotop = true
end type

on uo_fecha.destroy
call ou_rango_fechas::destroy
end on

type pb_1 from picturebutton within w_pr727_reporte_de_asistencia
integer x = 2706
integer y = 308
integer width = 315
integer height = 180
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "H:\source\BMP\Aceptar_dn.bmp"
alignment htextalign = left!
end type

event clicked;// Ancestor Script has been Override

SetPointer(HourGlass!)
Parent.event Dynamic ue_retrieve()
SetPointer(Arrow!)
end event

type sle_codigo from singlelineedit within w_pr727_reporte_de_asistencia
event dobleclick pbm_lbuttondblclk
integer x = 311
integer y = 396
integer width = 242
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
long textcolor = 134217746
long backcolor = 33554431
integer limit = 8
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql, ls_tipo, ls_origen

ls_sql = "SELECT  distinct m.cod_trabajador as codigo, " & 
		 + "m.apel_paterno||' '||m.apel_materno||', '||m.nombre1||' '||m.nombre2 AS TRABAJADOR " &
		 + "FROM maestro m, asistencia a " &
	  	 + "WHERE m.flag_estado = '1' and a.cod_trabajador = m.cod_trabajador"

lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
	
if ls_codigo <> '' then
	this.text = ls_codigo
	sle_nombre.text = ls_data
end if

end event

event modified;String 	ls_cod_t, ls_nombre

ls_cod_t = this.text
if ls_cod_t = '' or IsNull(ls_cod_t) then
	MessageBox('Aviso', 'Debe Ingresar un codigo de Trabajador')
	sle_nombre.text = ''
	return
end if

SELECT m.apel_paterno||' '||m.apel_materno||' '||m.nombre1||' '||m.nombre2
	INTO :ls_nombre
FROM maestro m, asistencia a
WHERE a.cod_trabajador = :ls_cod_t
  and a.cod_trabajador = m.cod_trabajador
  and m.flag_estado <> '0';

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de Trabajador no existe')
	sle_nombre.text = ''
	return
end if

sle_nombre.text = ls_nombre
end event

type sle_nombre from singlelineedit within w_pr727_reporte_de_asistencia
integer x = 567
integer y = 396
integer width = 901
integer height = 72
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 134217738
boolean enabled = false
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_pr727_reporte_de_asistencia
integer x = 96
integer y = 264
integer width = 626
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Reporte por Trabajador"
boolean focusrectangle = false
end type

type dw_report from u_dw_rpt within w_pr727_reporte_de_asistencia
integer x = 64
integer y = 544
integer width = 3730
integer height = 1356
string dataobject = "d_rpt_detalle_asistencia_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

type gb_4 from groupbox within w_pr727_reporte_de_asistencia
integer x = 69
integer y = 328
integer width = 1458
integer height = 180
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = " Todos   Seleccione Trabajador "
end type

type gb_2 from groupbox within w_pr727_reporte_de_asistencia
integer x = 69
integer y = 56
integer width = 1458
integer height = 172
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Seleccione rango de fechas"
end type

type gb_3 from groupbox within w_pr727_reporte_de_asistencia
integer x = 1545
integer y = 56
integer width = 1477
integer height = 172
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Todos    Tipo de Movimiento"
end type

