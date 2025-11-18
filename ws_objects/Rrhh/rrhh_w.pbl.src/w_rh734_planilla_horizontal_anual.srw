$PBExportHeader$w_rh734_planilla_horizontal_anual.srw
forward
global type w_rh734_planilla_horizontal_anual from w_report_smpl
end type
type cb_origen from commandbutton within w_rh734_planilla_horizontal_anual
end type
type em_descripcion from editmask within w_rh734_planilla_horizontal_anual
end type
type em_origen from editmask within w_rh734_planilla_horizontal_anual
end type
type cb_procesar from commandbutton within w_rh734_planilla_horizontal_anual
end type
type gb_2 from groupbox within w_rh734_planilla_horizontal_anual
end type
type uo_1 from u_ddlb_tipo_trabajador within w_rh734_planilla_horizontal_anual
end type
type cbx_todos from checkbox within w_rh734_planilla_horizontal_anual
end type
type sle_codigo from singlelineedit within w_rh734_planilla_horizontal_anual
end type
type cb_selec from commandbutton within w_rh734_planilla_horizontal_anual
end type
type st_nom_trabajador from statictext within w_rh734_planilla_horizontal_anual
end type
type sle_mes1 from singlelineedit within w_rh734_planilla_horizontal_anual
end type
type st_3 from statictext within w_rh734_planilla_horizontal_anual
end type
type sle_year1 from singlelineedit within w_rh734_planilla_horizontal_anual
end type
type st_4 from statictext within w_rh734_planilla_horizontal_anual
end type
type st_1 from statictext within w_rh734_planilla_horizontal_anual
end type
type sle_year2 from singlelineedit within w_rh734_planilla_horizontal_anual
end type
type st_2 from statictext within w_rh734_planilla_horizontal_anual
end type
type sle_mes2 from singlelineedit within w_rh734_planilla_horizontal_anual
end type
type cbx_1 from checkbox within w_rh734_planilla_horizontal_anual
end type
type cbx_costos from checkbox within w_rh734_planilla_horizontal_anual
end type
type gb_3 from groupbox within w_rh734_planilla_horizontal_anual
end type
type gb_1 from groupbox within w_rh734_planilla_horizontal_anual
end type
end forward

global type w_rh734_planilla_horizontal_anual from w_report_smpl
integer width = 4055
integer height = 1652
string title = "[RH734] Planilla de ingresos horizontal por periodos"
string menuname = "m_impresion"
cb_origen cb_origen
em_descripcion em_descripcion
em_origen em_origen
cb_procesar cb_procesar
gb_2 gb_2
uo_1 uo_1
cbx_todos cbx_todos
sle_codigo sle_codigo
cb_selec cb_selec
st_nom_trabajador st_nom_trabajador
sle_mes1 sle_mes1
st_3 st_3
sle_year1 sle_year1
st_4 st_4
st_1 st_1
sle_year2 sle_year2
st_2 st_2
sle_mes2 sle_mes2
cbx_1 cbx_1
cbx_costos cbx_costos
gb_3 gb_3
gb_1 gb_1
end type
global w_rh734_planilla_horizontal_anual w_rh734_planilla_horizontal_anual

on w_rh734_planilla_horizontal_anual.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.cb_origen=create cb_origen
this.em_descripcion=create em_descripcion
this.em_origen=create em_origen
this.cb_procesar=create cb_procesar
this.gb_2=create gb_2
this.uo_1=create uo_1
this.cbx_todos=create cbx_todos
this.sle_codigo=create sle_codigo
this.cb_selec=create cb_selec
this.st_nom_trabajador=create st_nom_trabajador
this.sle_mes1=create sle_mes1
this.st_3=create st_3
this.sle_year1=create sle_year1
this.st_4=create st_4
this.st_1=create st_1
this.sle_year2=create sle_year2
this.st_2=create st_2
this.sle_mes2=create sle_mes2
this.cbx_1=create cbx_1
this.cbx_costos=create cbx_costos
this.gb_3=create gb_3
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_origen
this.Control[iCurrent+2]=this.em_descripcion
this.Control[iCurrent+3]=this.em_origen
this.Control[iCurrent+4]=this.cb_procesar
this.Control[iCurrent+5]=this.gb_2
this.Control[iCurrent+6]=this.uo_1
this.Control[iCurrent+7]=this.cbx_todos
this.Control[iCurrent+8]=this.sle_codigo
this.Control[iCurrent+9]=this.cb_selec
this.Control[iCurrent+10]=this.st_nom_trabajador
this.Control[iCurrent+11]=this.sle_mes1
this.Control[iCurrent+12]=this.st_3
this.Control[iCurrent+13]=this.sle_year1
this.Control[iCurrent+14]=this.st_4
this.Control[iCurrent+15]=this.st_1
this.Control[iCurrent+16]=this.sle_year2
this.Control[iCurrent+17]=this.st_2
this.Control[iCurrent+18]=this.sle_mes2
this.Control[iCurrent+19]=this.cbx_1
this.Control[iCurrent+20]=this.cbx_costos
this.Control[iCurrent+21]=this.gb_3
this.Control[iCurrent+22]=this.gb_1
end on

on w_rh734_planilla_horizontal_anual.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_origen)
destroy(this.em_descripcion)
destroy(this.em_origen)
destroy(this.cb_procesar)
destroy(this.gb_2)
destroy(this.uo_1)
destroy(this.cbx_todos)
destroy(this.sle_codigo)
destroy(this.cb_selec)
destroy(this.st_nom_trabajador)
destroy(this.sle_mes1)
destroy(this.st_3)
destroy(this.sle_year1)
destroy(this.st_4)
destroy(this.st_1)
destroy(this.sle_year2)
destroy(this.st_2)
destroy(this.sle_mes2)
destroy(this.cbx_1)
destroy(this.cbx_costos)
destroy(this.gb_3)
destroy(this.gb_1)
end on

event ue_retrieve;string 	ls_origen, ls_tipo_trabaj, ls_trabajador
Integer	li_year1, li_mes1, li_year2, li_mes2

if cbx_1.checked then
	ls_origen = '%%'
else
	ls_origen 		= string(em_origen.text) + '%'
end if

li_year1	= Integer(sle_year1.text)
li_mes1	= Integer(sle_mes1.text)
li_year2	= Integer(sle_year2.text)
li_mes2	= Integer(sle_mes2.text)


ls_tipo_trabaj = uo_1.of_get_value()

if cbx_todos.checked then
	ls_trabajador = '%%'
else
	ls_trabajador = trim(sle_codigo.text) + '%'
end if

if isnull(ls_tipo_trabaj) or trim(ls_tipo_trabaj) = '' then ls_tipo_trabaj = '%'

if cbx_costos.checked then
	dw_report.DataObject = 'd_rpt_planilla_costos_anual_crt'
else
	dw_report.DataObject = 'd_rpt_planilla_horizontal_anual_crt'
end if

dw_report.SetTransObject(SQLCA)
dw_report.retrieve(ls_origen, ls_tipo_trabaj, ls_trabajador, li_year1, li_mes1, li_year2, li_mes2)

dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_nombre.text   = gs_empresa
dw_report.object.t_user.text     = gs_user

dw_report.Object.t_titulo2.text = 'Del Periodo ' + string(li_year1, '0000') + ' - ' + string(li_mes1, '00') &
										  + 'Al Periodo ' + string(li_year2, '0000') + ' - ' + string(li_mes2, '00')


end event

event ue_open_pre;Date	ld_today
idw_1 = dw_report
idw_1.SetTransObject(sqlca)

ld_today = Date(gnvo_app.of_fecha_actual())

sle_year1.text = string(ld_today, 'yyyy')
sle_mes1.text	= string(ld_today, 'mm')
sle_year2.text = string(ld_today, 'yyyy')
sle_mes2.text	= string(ld_today, 'mm')

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

type dw_report from w_report_smpl`dw_report within w_rh734_planilla_horizontal_anual
integer y = 312
integer width = 3689
integer height = 1000
integer taborder = 50
string dataobject = "d_rpt_planilla_horizontal_anual_crt"
end type

event dw_report::clicked;call super::clicked;f_select_current_row(this)
end event

event dw_report::rowfocuschanged;call super::rowfocuschanged;f_select_current_row(this)
end event

type cb_origen from commandbutton within w_rh734_planilla_horizontal_anual
integer x = 197
integer y = 56
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
boolean enabled = false
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

type em_descripcion from editmask within w_rh734_planilla_horizontal_anual
integer x = 293
integer y = 60
integer width = 759
integer height = 72
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

type em_origen from editmask within w_rh734_planilla_horizontal_anual
integer x = 50
integer y = 60
integer width = 133
integer height = 72
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

type cb_procesar from commandbutton within w_rh734_planilla_horizontal_anual
integer x = 3552
integer y = 4
integer width = 352
integer height = 176
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Generar"
end type

event clicked;setPointer(HourGlass!)
Parent.Event ue_retrieve()
setPointer(Arrow!)
end event

type gb_2 from groupbox within w_rh734_planilla_horizontal_anual
integer width = 1097
integer height = 212
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = " Seleccione Origen "
end type

type uo_1 from u_ddlb_tipo_trabajador within w_rh734_planilla_horizontal_anual
integer x = 1125
integer taborder = 20
end type

on uo_1.destroy
call u_ddlb_tipo_trabajador::destroy
end on

type cbx_todos from checkbox within w_rh734_planilla_horizontal_anual
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

type sle_codigo from singlelineedit within w_rh734_planilla_horizontal_anual
integer x = 677
integer y = 224
integer width = 270
integer height = 72
integer taborder = 60
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

type cb_selec from commandbutton within w_rh734_planilla_horizontal_anual
integer x = 960
integer y = 228
integer width = 87
integer height = 68
integer taborder = 40
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

type st_nom_trabajador from statictext within w_rh734_planilla_horizontal_anual
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

type sle_mes1 from singlelineedit within w_rh734_planilla_horizontal_anual
integer x = 2624
integer y = 80
integer width = 105
integer height = 72
integer taborder = 70
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

type st_3 from statictext within w_rh734_planilla_horizontal_anual
integer x = 2455
integer y = 88
integer width = 155
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
string text = "Mes :"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_year1 from singlelineedit within w_rh734_planilla_horizontal_anual
integer x = 2240
integer y = 80
integer width = 192
integer height = 76
integer taborder = 70
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

type st_4 from statictext within w_rh734_planilla_horizontal_anual
integer x = 2071
integer y = 88
integer width = 155
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
string text = "Año :"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_1 from statictext within w_rh734_planilla_horizontal_anual
integer x = 2821
integer y = 88
integer width = 155
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
string text = "Año :"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_year2 from singlelineedit within w_rh734_planilla_horizontal_anual
integer x = 2990
integer y = 80
integer width = 192
integer height = 76
integer taborder = 80
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

type st_2 from statictext within w_rh734_planilla_horizontal_anual
integer x = 3205
integer y = 88
integer width = 155
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
string text = "Mes :"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_mes2 from singlelineedit within w_rh734_planilla_horizontal_anual
integer x = 3374
integer y = 80
integer width = 105
integer height = 72
integer taborder = 80
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

type cbx_1 from checkbox within w_rh734_planilla_horizontal_anual
integer x = 46
integer y = 132
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
string text = "Todos los origenes"
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

type cbx_costos from checkbox within w_rh734_planilla_horizontal_anual
integer x = 2757
integer y = 220
integer width = 969
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Solo Considerar ingresos y aportaciones"
end type

type gb_3 from groupbox within w_rh734_planilla_horizontal_anual
integer x = 2779
integer width = 727
integer height = 196
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "Periodo Fin"
end type

type gb_1 from groupbox within w_rh734_planilla_horizontal_anual
integer x = 2039
integer y = 4
integer width = 727
integer height = 196
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "Periodo Inicio"
end type

