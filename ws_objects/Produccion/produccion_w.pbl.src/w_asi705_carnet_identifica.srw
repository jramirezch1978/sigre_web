$PBExportHeader$w_asi705_carnet_identifica.srw
forward
global type w_asi705_carnet_identifica from w_report_smpl
end type
type cb_1 from commandbutton within w_asi705_carnet_identifica
end type
type cb_2 from commandbutton within w_asi705_carnet_identifica
end type
type cb_3 from commandbutton within w_asi705_carnet_identifica
end type
type st_1 from statictext within w_asi705_carnet_identifica
end type
type st_2 from statictext within w_asi705_carnet_identifica
end type
type em_area from editmask within w_asi705_carnet_identifica
end type
type em_desc_area from editmask within w_asi705_carnet_identifica
end type
type em_seccion from editmask within w_asi705_carnet_identifica
end type
type em_desc_seccion from editmask within w_asi705_carnet_identifica
end type
type em_desde from editmask within w_asi705_carnet_identifica
end type
type em_hasta from editmask within w_asi705_carnet_identifica
end type
type cbx_todos from checkbox within w_asi705_carnet_identifica
end type
type gb_1 from groupbox within w_asi705_carnet_identifica
end type
type gb_2 from groupbox within w_asi705_carnet_identifica
end type
type gb_5 from groupbox within w_asi705_carnet_identifica
end type
end forward

global type w_asi705_carnet_identifica from w_report_smpl
integer width = 3506
integer height = 1636
string title = "(RH621) Reporte de Promedio General de las Evaluaciones"
string menuname = "m_reporte"
long backcolor = 79741120
cb_1 cb_1
cb_2 cb_2
cb_3 cb_3
st_1 st_1
st_2 st_2
em_area em_area
em_desc_area em_desc_area
em_seccion em_seccion
em_desc_seccion em_desc_seccion
em_desde em_desde
em_hasta em_hasta
cbx_todos cbx_todos
gb_1 gb_1
gb_2 gb_2
gb_5 gb_5
end type
global w_asi705_carnet_identifica w_asi705_carnet_identifica

type variables
string is_codigo
end variables

on w_asi705_carnet_identifica.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.cb_1=create cb_1
this.cb_2=create cb_2
this.cb_3=create cb_3
this.st_1=create st_1
this.st_2=create st_2
this.em_area=create em_area
this.em_desc_area=create em_desc_area
this.em_seccion=create em_seccion
this.em_desc_seccion=create em_desc_seccion
this.em_desde=create em_desde
this.em_hasta=create em_hasta
this.cbx_todos=create cbx_todos
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_5=create gb_5
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.cb_2
this.Control[iCurrent+3]=this.cb_3
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.em_area
this.Control[iCurrent+7]=this.em_desc_area
this.Control[iCurrent+8]=this.em_seccion
this.Control[iCurrent+9]=this.em_desc_seccion
this.Control[iCurrent+10]=this.em_desde
this.Control[iCurrent+11]=this.em_hasta
this.Control[iCurrent+12]=this.cbx_todos
this.Control[iCurrent+13]=this.gb_1
this.Control[iCurrent+14]=this.gb_2
this.Control[iCurrent+15]=this.gb_5
end on

on w_asi705_carnet_identifica.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.cb_2)
destroy(this.cb_3)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.em_area)
destroy(this.em_desc_area)
destroy(this.em_seccion)
destroy(this.em_desc_seccion)
destroy(this.em_desde)
destroy(this.em_hasta)
destroy(this.cbx_todos)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_5)
end on

event ue_retrieve;call super::ue_retrieve;string  ls_area, ls_seccion, ls_desde, ls_hasta

ls_area    = string (em_area.text)
ls_seccion = string (em_seccion.text)

if not cbx_todos.checked then
	ls_desde = em_desde.text
	ls_hasta = em_hasta.text
else
	ls_desde = '10000000'
	ls_hasta = '99999999'
end if

if isnull(ls_desde) or (ls_desde > ls_hasta) then
	MessageBox('Aviso','rango es incorrecto. Verifique')
	return
end if

if isnull(ls_area) or trim(ls_area) = '' then ls_area = '%%'
if isnull(ls_seccion) or trim(ls_seccion) = '' then ls_seccion = '%%'

dw_report.retrieve(ls_area, ls_seccion, ls_desde, ls_hasta)

dw_report.object.p_logo.filename = gs_logo
//dw_report.object.t_nombre.text   = gs_empresa
//dw_report.object.t_user.text     = gs_user


end event

event open;call super::open;FileCopy("IDAutomationHC39M_Free.ttf", &
	"C:\WINDOWS\Fonts\IDAutomationHC39M_Free.ttf", false)
end event

type dw_report from w_report_smpl`dw_report within w_asi705_carnet_identifica
integer x = 9
integer y = 536
integer width = 3451
integer height = 900
integer taborder = 70
string dataobject = "d_rpt_trabajador_lbl"
end type

type cb_1 from commandbutton within w_asi705_carnet_identifica
integer x = 2848
integer y = 340
integer width = 279
integer height = 88
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aceptar"
end type

event clicked;Parent.Event ue_retrieve()

end event

type cb_2 from commandbutton within w_asi705_carnet_identifica
integer x = 347
integer y = 112
integer width = 87
integer height = 80
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;// Abre ventana de ayuda 

str_parametros sl_param

sl_param.dw1 = "d_rpt_rh_area_tbl"
sl_param.titulo = "Seleccionar Búsqueda"
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2

OpenWithParm( w_search, sl_param)		
sl_param = MESSAGE.POWEROBJECTPARM
IF sl_param.titulo <> 'n' THEN
	em_area.text = sl_param.field_ret[1]
	em_desc_area.text = sl_param.field_ret[2]
END IF

end event

type cb_3 from commandbutton within w_asi705_carnet_identifica
integer x = 2030
integer y = 112
integer width = 87
integer height = 80
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;// Abre ventana de ayuda 

str_parametros sl_param

sl_param.dw1 = "d_seleccion_seccion_tbl"
sl_param.titulo = "Seleccionar Búsqueda"
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2

OpenWithParm( w_search, sl_param)		
sl_param = MESSAGE.POWEROBJECTPARM
IF sl_param.titulo <> 'n' THEN
	em_seccion.text = sl_param.field_ret[1]
	em_desc_seccion.text = sl_param.field_ret[2]
END IF

end event

type st_1 from statictext within w_asi705_carnet_identifica
integer x = 475
integer y = 352
integer width = 165
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Desde"
boolean focusrectangle = false
end type

type st_2 from statictext within w_asi705_carnet_identifica
integer x = 1029
integer y = 352
integer width = 146
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Hasta"
boolean focusrectangle = false
end type

type em_area from editmask within w_asi705_carnet_identifica
integer x = 119
integer y = 112
integer width = 192
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
alignment alignment = center!
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type em_desc_area from editmask within w_asi705_carnet_identifica
integer x = 466
integer y = 112
integer width = 1051
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type em_seccion from editmask within w_asi705_carnet_identifica
integer x = 1710
integer y = 112
integer width = 283
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
alignment alignment = center!
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type em_desc_seccion from editmask within w_asi705_carnet_identifica
integer x = 2153
integer y = 112
integer width = 1051
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type em_desde from editmask within w_asi705_carnet_identifica
integer x = 681
integer y = 348
integer width = 311
integer height = 80
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean enabled = false
string text = "10000000"
alignment alignment = center!
borderstyle borderstyle = stylelowered!
string mask = "#"
boolean spin = true
string minmax = "10000000~~99999999"
end type

type em_hasta from editmask within w_asi705_carnet_identifica
integer x = 1230
integer y = 348
integer width = 311
integer height = 80
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean enabled = false
string text = "10000000"
alignment alignment = center!
borderstyle borderstyle = stylelowered!
string mask = "#"
boolean spin = true
string minmax = "10000000~~99999999"
end type

type cbx_todos from checkbox within w_asi705_carnet_identifica
integer x = 119
integer y = 348
integer width = 343
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Todos"
boolean checked = true
end type

event clicked;if not this.checked then
	em_desde.enabled = true
	em_hasta.enabled = true
else
	em_desde.enabled = false
	em_hasta.enabled = false
end if
end event

type gb_1 from groupbox within w_asi705_carnet_identifica
integer x = 55
integer y = 36
integer width = 1518
integer height = 204
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = " Seleccione Area "
end type

type gb_2 from groupbox within w_asi705_carnet_identifica
integer x = 1646
integer y = 36
integer width = 1609
integer height = 204
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = " Seleccione Sección "
end type

type gb_5 from groupbox within w_asi705_carnet_identifica
integer x = 73
integer y = 268
integer width = 2162
integer height = 204
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Rango de Trabajadores"
end type

