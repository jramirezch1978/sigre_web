$PBExportHeader$w_rh741_cts_trabajador.srw
forward
global type w_rh741_cts_trabajador from w_report_smpl
end type
type cb_3 from commandbutton within w_rh741_cts_trabajador
end type
type em_descripcion from editmask within w_rh741_cts_trabajador
end type
type em_origen from editmask within w_rh741_cts_trabajador
end type
type uo_1 from u_ddlb_tipo_trabajador within w_rh741_cts_trabajador
end type
type cbx_todos from checkbox within w_rh741_cts_trabajador
end type
type sle_codigo from singlelineedit within w_rh741_cts_trabajador
end type
type cb_selec from commandbutton within w_rh741_cts_trabajador
end type
type st_nom_trabajador from statictext within w_rh741_cts_trabajador
end type
type st_4 from statictext within w_rh741_cts_trabajador
end type
type sle_year1 from singlelineedit within w_rh741_cts_trabajador
end type
type st_1 from statictext within w_rh741_cts_trabajador
end type
type sle_year2 from singlelineedit within w_rh741_cts_trabajador
end type
type cb_procesar from commandbutton within w_rh741_cts_trabajador
end type
type gb_2 from groupbox within w_rh741_cts_trabajador
end type
end forward

global type w_rh741_cts_trabajador from w_report_smpl
integer width = 3680
integer height = 1524
string title = "[RH741] Reporte de CTS por Trabajador"
string menuname = "m_impresion"
cb_3 cb_3
em_descripcion em_descripcion
em_origen em_origen
uo_1 uo_1
cbx_todos cbx_todos
sle_codigo sle_codigo
cb_selec cb_selec
st_nom_trabajador st_nom_trabajador
st_4 st_4
sle_year1 sle_year1
st_1 st_1
sle_year2 sle_year2
cb_procesar cb_procesar
gb_2 gb_2
end type
global w_rh741_cts_trabajador w_rh741_cts_trabajador

on w_rh741_cts_trabajador.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.cb_3=create cb_3
this.em_descripcion=create em_descripcion
this.em_origen=create em_origen
this.uo_1=create uo_1
this.cbx_todos=create cbx_todos
this.sle_codigo=create sle_codigo
this.cb_selec=create cb_selec
this.st_nom_trabajador=create st_nom_trabajador
this.st_4=create st_4
this.sle_year1=create sle_year1
this.st_1=create st_1
this.sle_year2=create sle_year2
this.cb_procesar=create cb_procesar
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_3
this.Control[iCurrent+2]=this.em_descripcion
this.Control[iCurrent+3]=this.em_origen
this.Control[iCurrent+4]=this.uo_1
this.Control[iCurrent+5]=this.cbx_todos
this.Control[iCurrent+6]=this.sle_codigo
this.Control[iCurrent+7]=this.cb_selec
this.Control[iCurrent+8]=this.st_nom_trabajador
this.Control[iCurrent+9]=this.st_4
this.Control[iCurrent+10]=this.sle_year1
this.Control[iCurrent+11]=this.st_1
this.Control[iCurrent+12]=this.sle_year2
this.Control[iCurrent+13]=this.cb_procesar
this.Control[iCurrent+14]=this.gb_2
end on

on w_rh741_cts_trabajador.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_3)
destroy(this.em_descripcion)
destroy(this.em_origen)
destroy(this.uo_1)
destroy(this.cbx_todos)
destroy(this.sle_codigo)
destroy(this.cb_selec)
destroy(this.st_nom_trabajador)
destroy(this.st_4)
destroy(this.sle_year1)
destroy(this.st_1)
destroy(this.sle_year2)
destroy(this.cb_procesar)
destroy(this.gb_2)
end on

event ue_retrieve;call super::ue_retrieve;string 	ls_origen, ls_tipo_trabaj, ls_trabajador
Integer	li_year1, li_year2

ls_origen 	= string(em_origen.text)
li_year1		= Integer(sle_year1.Text)
li_year2		= Integer(sle_year2.Text)

ls_tipo_trabaj = uo_1.of_get_value()

if cbx_todos.checked then
	ls_trabajador = '%%'
else
	ls_trabajador = trim(sle_codigo.text) + '%'
end if

if isnull(ls_tipo_trabaj) or trim(ls_tipo_trabaj) = '' then ls_tipo_trabaj = '%'

dw_report.SetTransObject(SQLCA)
dw_report.retrieve(li_year1, li_year2, ls_origen, ls_tipo_trabaj, ls_trabajador)


dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_nombre.text 	= gs_empresa
dw_report.object.t_user.text 		= gs_user
//
//
end event

event ue_open_pre;call super::ue_open_pre;DateTime	ldt_hoy

ldt_hoy = gnvo_app.of_fecha_actual()

sle_year1.text = string(ldt_hoy, 'yyyy')
sle_year2.text = string(ldt_hoy, 'yyyy')
end event

type dw_report from w_report_smpl`dw_report within w_rh741_cts_trabajador
integer x = 0
integer y = 320
integer width = 3506
integer height = 992
integer taborder = 40
string dataobject = "d_rpt_cts_trabajador_tbl"
end type

type cb_3 from commandbutton within w_rh741_cts_trabajador
integer x = 197
integer y = 72
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

sl_param.dw1 = "d_seleccion_origen_tbl"
sl_param.titulo = "Seleccionar Búsqueda"
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2

OpenWithParm( w_search_origen, sl_param)		
sl_param = MESSAGE.POWEROBJECTPARM
IF sl_param.titulo <> 'n' THEN
	em_origen.text      = sl_param.field_ret[1]
	em_descripcion.text = sl_param.field_ret[2]
END IF

end event

type em_descripcion from editmask within w_rh741_cts_trabajador
integer x = 293
integer y = 76
integer width = 759
integer height = 72
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 12632256
boolean border = false
boolean displayonly = true
maskdatatype maskdatatype = stringmask!
end type

type em_origen from editmask within w_rh741_cts_trabajador
integer x = 50
integer y = 76
integer width = 133
integer height = 72
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 12632256
boolean border = false
alignment alignment = center!
boolean displayonly = true
maskdatatype maskdatatype = stringmask!
end type

type uo_1 from u_ddlb_tipo_trabajador within w_rh741_cts_trabajador
event destroy ( )
integer x = 1125
integer taborder = 30
boolean bringtotop = true
end type

on uo_1.destroy
call u_ddlb_tipo_trabajador::destroy
end on

type cbx_todos from checkbox within w_rh741_cts_trabajador
integer x = 32
integer y = 224
integer width = 622
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Todos los trabajadores"
boolean checked = true
end type

event clicked;if this.checked then
	cb_selec.enabled = false
	sle_codigo.enabled = false
else
	cb_selec.enabled = true
	sle_codigo.enabled = true
end if
end event

type sle_codigo from singlelineedit within w_rh741_cts_trabajador
integer x = 677
integer y = 224
integer width = 270
integer height = 72
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
boolean enabled = false
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type cb_selec from commandbutton within w_rh741_cts_trabajador
integer x = 960
integer y = 228
integer width = 87
integer height = 68
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "..."
end type

event clicked;// Abre ventana de ayuda 
String	ls_origen
str_parametros lstr_param

ls_origen = em_origen.text

lstr_param.dw1 = "d_rpt_select_codigo_todos_tbl"
lstr_param.titulo = "Seleccionar Búsqueda"
lstr_param.field_ret_i[1] = 1
lstr_param.field_ret_i[2] = 2
lstr_param.string1 		  = ls_origen
lstr_param.tipo			  = '1S'

OpenWithParm( w_search, lstr_param)		
lstr_param = MESSAGE.POWEROBJECTPARM
IF lstr_param.titulo <> 'n' THEN
	sle_codigo.text  			= lstr_param.field_ret[1]
	st_nom_trabajador.text 	= lstr_param.field_ret[2]
END IF

end event

type st_nom_trabajador from statictext within w_rh741_cts_trabajador
integer x = 1079
integer y = 224
integer width = 1577
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type st_4 from statictext within w_rh741_cts_trabajador
integer x = 2075
integer y = 36
integer width = 297
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Año desde:"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_year1 from singlelineedit within w_rh741_cts_trabajador
integer x = 2400
integer y = 28
integer width = 224
integer height = 76
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_rh741_cts_trabajador
integer x = 2085
integer y = 116
integer width = 288
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Año Hasta :"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_year2 from singlelineedit within w_rh741_cts_trabajador
integer x = 2400
integer y = 108
integer width = 224
integer height = 76
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
borderstyle borderstyle = stylelowered!
end type

type cb_procesar from commandbutton within w_rh741_cts_trabajador
integer x = 2683
integer y = 40
integer width = 352
integer height = 224
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Generar"
end type

event clicked;Parent.Event ue_retrieve()
end event

type gb_2 from groupbox within w_rh741_cts_trabajador
integer width = 1097
integer height = 212
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = " Seleccione Origen "
end type

