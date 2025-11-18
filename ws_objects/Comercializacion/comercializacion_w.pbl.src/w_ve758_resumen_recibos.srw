$PBExportHeader$w_ve758_resumen_recibos.srw
forward
global type w_ve758_resumen_recibos from w_rpt
end type
type cbx_1 from checkbox within w_ve758_resumen_recibos
end type
type sle_desc_centro from singlelineedit within w_ve758_resumen_recibos
end type
type pb_centro_benef from picturebutton within w_ve758_resumen_recibos
end type
type sle_centro_benef from singlelineedit within w_ve758_resumen_recibos
end type
type st_2 from statictext within w_ve758_resumen_recibos
end type
type uo_1 from u_ingreso_rango_fechas within w_ve758_resumen_recibos
end type
type cb_1 from commandbutton within w_ve758_resumen_recibos
end type
type gb_1 from groupbox within w_ve758_resumen_recibos
end type
type dw_reporte from u_dw_rpt within w_ve758_resumen_recibos
end type
end forward

global type w_ve758_resumen_recibos from w_rpt
integer width = 3520
integer height = 2360
string title = "[VE758] Resumen de recibos de pago"
string menuname = "m_reporte"
cbx_1 cbx_1
sle_desc_centro sle_desc_centro
pb_centro_benef pb_centro_benef
sle_centro_benef sle_centro_benef
st_2 st_2
uo_1 uo_1
cb_1 cb_1
gb_1 gb_1
dw_reporte dw_reporte
end type
global w_ve758_resumen_recibos w_ve758_resumen_recibos

on w_ve758_resumen_recibos.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.cbx_1=create cbx_1
this.sle_desc_centro=create sle_desc_centro
this.pb_centro_benef=create pb_centro_benef
this.sle_centro_benef=create sle_centro_benef
this.st_2=create st_2
this.uo_1=create uo_1
this.cb_1=create cb_1
this.gb_1=create gb_1
this.dw_reporte=create dw_reporte
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_1
this.Control[iCurrent+2]=this.sle_desc_centro
this.Control[iCurrent+3]=this.pb_centro_benef
this.Control[iCurrent+4]=this.sle_centro_benef
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.uo_1
this.Control[iCurrent+7]=this.cb_1
this.Control[iCurrent+8]=this.gb_1
this.Control[iCurrent+9]=this.dw_reporte
end on

on w_ve758_resumen_recibos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cbx_1)
destroy(this.sle_desc_centro)
destroy(this.pb_centro_benef)
destroy(this.sle_centro_benef)
destroy(this.st_2)
destroy(this.uo_1)
destroy(this.cb_1)
destroy(this.gb_1)
destroy(this.dw_reporte)
end on

event ue_retrieve;call super::ue_retrieve;Date 		ld_fec_ini, ld_fec_fin
String 	ls_centro_benef, ls_titulo

if cbx_1.checked then
	ls_centro_benef = '%%'
	ls_titulo = 'Todos los centros de beneficio'
else
	if trim(sle_centro_benef.text) = '' then
		MessageBox('Error', 'Debe elegir un centro de beneficio, por favor verifique!', StopSign!)
		sle_Centro_benef.setFocus()
		return
	end if
	
	ls_centro_benef = trim(sle_centro_benef.text) + '%'
	ls_titulo = trim(sle_desc_centro.text)
end if


ld_fec_ini = uo_1.of_get_fecha1()
ld_fec_fin = uo_1.of_get_fecha2()

idw_1.Retrieve(ld_fec_ini, ld_fec_fin, ls_centro_benef)

idw_1.object.p_logo.filename = gs_logo
idw_1.object.t_nombre.text   = gs_empresa
idw_1.object.t_user.text     = gs_user
idw_1.object.t_titulo1.text    = 'Del ' + string(ld_fec_ini) + ' al ' + string(ld_fec_fin)
idw_1.object.t_titulo2.text    = ls_titulo




end event

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_reporte
idw_1.Visible = true
idw_1.SetTransObject(sqlca)

Event ue_preview()
//This.Event ue_retrieve()

// ii_help = 101           // help topic




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

event ue_print();call super::ue_print;idw_1.EVENT ue_print()
end event

event resize;call super::resize;dw_reporte.width  = newwidth - dw_reporte.x
dw_reporte.height = newheight - dw_reporte.y
end event

type cbx_1 from checkbox within w_ve758_resumen_recibos
integer x = 2075
integer y = 168
integer width = 283
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Todos"
boolean checked = true
end type

event clicked;if this.checked then
	sle_centro_benef.enabled = false
	sle_desc_centro.enabled = false
	pb_centro_benef.enabled = false
else
	sle_centro_benef.enabled = true
	sle_desc_centro.enabled = true
	pb_centro_benef.enabled = true
end if

sle_centro_benef.text = ''
sle_desc_centro.text = ''

end event

type sle_desc_centro from singlelineedit within w_ve758_resumen_recibos
integer x = 965
integer y = 156
integer width = 1102
integer height = 84
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
boolean enabled = false
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type pb_centro_benef from picturebutton within w_ve758_resumen_recibos
integer x = 841
integer y = 160
integer width = 114
integer height = 84
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
boolean enabled = false
string picturename = "C:\SIGRE\resources\PNG\open.png"
string disabledname = "C:\SIGRE\resources\PNG\open.png"
alignment htextalign = left!
boolean map3dcolors = true
end type

event clicked;boolean lb_ret
string ls_codigo, ls_data, ls_sql, ls_cliente

ls_sql = "select distinct " &
		 + "cb.centro_benef as centro_beneficio, " &
		 + "cb.desc_centro as descripcion_centro " &
		 + "from cntas_cobrar cc, " &
		 + "     cntas_cobrar_det ccd, " &
		 + "     centro_beneficio cb " &
		 + "where cc.tipo_doc = ccd.tipo_doc " &
		 + "  and cc.nro_doc  = ccd.nro_doc " &
		 + "  and ccd.centro_benef = cb.centro_benef " &
		 + "  and cc.flag_estado   <> '0' " 
		 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

if ls_codigo <> '' then
	sle_centro_benef.text		= ls_codigo
	sle_desc_centro.text = ls_data
end if




end event

type sle_centro_benef from singlelineedit within w_ve758_resumen_recibos
integer x = 453
integer y = 160
integer width = 384
integer height = 84
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
boolean enabled = false
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type st_2 from statictext within w_ve758_resumen_recibos
integer x = 46
integer y = 168
integer width = 393
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Centro Beneficio :"
boolean focusrectangle = false
end type

type uo_1 from u_ingreso_rango_fechas within w_ve758_resumen_recibos
event destroy ( )
integer x = 178
integer y = 68
integer taborder = 50
end type

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
of_set_fecha(today(), today()) //para setear la fecha inicial
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final

end event

type cb_1 from commandbutton within w_ve758_resumen_recibos
integer x = 2459
integer y = 56
integer width = 352
integer height = 172
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Reporte"
end type

event clicked;Event ue_retrieve()
end event

type gb_1 from groupbox within w_ve758_resumen_recibos
integer width = 2839
integer height = 264
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Ingrese Periodo  y  Selecciona Origen"
end type

type dw_reporte from u_dw_rpt within w_ve758_resumen_recibos
integer y = 300
integer width = 3319
integer height = 1556
integer taborder = 0
boolean bringtotop = true
string dataobject = "d_rpt_resumen_recibos_tbl"
end type

