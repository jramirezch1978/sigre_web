$PBExportHeader$w_ve761_proyeccion_ingresos_anual.srw
forward
global type w_ve761_proyeccion_ingresos_anual from w_rpt
end type
type cbx_2 from checkbox within w_ve761_proyeccion_ingresos_anual
end type
type cbx_1 from checkbox within w_ve761_proyeccion_ingresos_anual
end type
type sle_desc_centro from singlelineedit within w_ve761_proyeccion_ingresos_anual
end type
type pb_centro_benef from picturebutton within w_ve761_proyeccion_ingresos_anual
end type
type sle_centro_benef from singlelineedit within w_ve761_proyeccion_ingresos_anual
end type
type st_2 from statictext within w_ve761_proyeccion_ingresos_anual
end type
type em_year from editmask within w_ve761_proyeccion_ingresos_anual
end type
type st_1 from statictext within w_ve761_proyeccion_ingresos_anual
end type
type dw_reporte from u_dw_rpt within w_ve761_proyeccion_ingresos_anual
end type
type cb_1 from commandbutton within w_ve761_proyeccion_ingresos_anual
end type
type gb_1 from groupbox within w_ve761_proyeccion_ingresos_anual
end type
end forward

global type w_ve761_proyeccion_ingresos_anual from w_rpt
integer width = 3520
integer height = 2360
string title = "[VE761] Proyeccion de Ingresos Anual"
string menuname = "m_reporte"
cbx_2 cbx_2
cbx_1 cbx_1
sle_desc_centro sle_desc_centro
pb_centro_benef pb_centro_benef
sle_centro_benef sle_centro_benef
st_2 st_2
em_year em_year
st_1 st_1
dw_reporte dw_reporte
cb_1 cb_1
gb_1 gb_1
end type
global w_ve761_proyeccion_ingresos_anual w_ve761_proyeccion_ingresos_anual

on w_ve761_proyeccion_ingresos_anual.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.cbx_2=create cbx_2
this.cbx_1=create cbx_1
this.sle_desc_centro=create sle_desc_centro
this.pb_centro_benef=create pb_centro_benef
this.sle_centro_benef=create sle_centro_benef
this.st_2=create st_2
this.em_year=create em_year
this.st_1=create st_1
this.dw_reporte=create dw_reporte
this.cb_1=create cb_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_2
this.Control[iCurrent+2]=this.cbx_1
this.Control[iCurrent+3]=this.sle_desc_centro
this.Control[iCurrent+4]=this.pb_centro_benef
this.Control[iCurrent+5]=this.sle_centro_benef
this.Control[iCurrent+6]=this.st_2
this.Control[iCurrent+7]=this.em_year
this.Control[iCurrent+8]=this.st_1
this.Control[iCurrent+9]=this.dw_reporte
this.Control[iCurrent+10]=this.cb_1
this.Control[iCurrent+11]=this.gb_1
end on

on w_ve761_proyeccion_ingresos_anual.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cbx_2)
destroy(this.cbx_1)
destroy(this.sle_desc_centro)
destroy(this.pb_centro_benef)
destroy(this.sle_centro_benef)
destroy(this.st_2)
destroy(this.em_year)
destroy(this.st_1)
destroy(this.dw_reporte)
destroy(this.cb_1)
destroy(this.gb_1)
end on

event ue_retrieve;call super::ue_retrieve;Integer	li_year
String	ls_centro_benef, ls_titulo, ls_flag

li_year = Integer(em_year.text)

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

if cbx_2.checked then
	ls_flag = '1'
else
	ls_flag = '0'
end if

idw_1.object.p_logo.filename = gs_logo
idw_1.object.t_nombre.text   = gs_empresa
idw_1.object.t_user.text     = gs_user
idw_1.object.t_titulo2.text  = ls_titulo

idw_1.retrieve( li_year, ls_centro_benef, ls_flag )


end event

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_reporte
idw_1.Visible = true
idw_1.SetTransObject(sqlca)

Event ue_preview()

em_year.text = string(date(gnvo_app.of_fecha_Actual()), 'yyyy')

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

type cbx_2 from checkbox within w_ve761_proyeccion_ingresos_anual
integer x = 434
integer y = 164
integer width = 654
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Deducir cuotas pagadas"
end type

type cbx_1 from checkbox within w_ve761_proyeccion_ingresos_anual
integer x = 2574
integer y = 80
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

type sle_desc_centro from singlelineedit within w_ve761_proyeccion_ingresos_anual
integer x = 1463
integer y = 68
integer width = 1102
integer height = 84
integer taborder = 40
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

type pb_centro_benef from picturebutton within w_ve761_proyeccion_ingresos_anual
integer x = 1339
integer y = 72
integer width = 114
integer height = 84
integer taborder = 50
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

type sle_centro_benef from singlelineedit within w_ve761_proyeccion_ingresos_anual
integer x = 951
integer y = 72
integer width = 384
integer height = 84
integer taborder = 40
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

type st_2 from statictext within w_ve761_proyeccion_ingresos_anual
integer x = 434
integer y = 76
integer width = 517
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Centro Beneficio :"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_year from editmask within w_ve761_proyeccion_ingresos_anual
integer x = 210
integer y = 68
integer width = 229
integer height = 88
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "0000"
boolean spin = true
double increment = 1
string minmax = "1~~9999"
end type

type st_1 from statictext within w_ve761_proyeccion_ingresos_anual
integer x = 14
integer y = 80
integer width = 183
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "AÑO:"
alignment alignment = right!
boolean focusrectangle = false
end type

type dw_reporte from u_dw_rpt within w_ve761_proyeccion_ingresos_anual
integer y = 248
integer width = 3319
integer height = 1556
integer taborder = 0
string dataobject = "d_rpt_proyeccion_ingresos_tbl"
end type

type cb_1 from commandbutton within w_ve761_proyeccion_ingresos_anual
integer x = 2857
integer y = 36
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

type gb_1 from groupbox within w_ve761_proyeccion_ingresos_anual
integer width = 3232
integer height = 236
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Filtro para el reporte"
end type

