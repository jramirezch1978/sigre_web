$PBExportHeader$w_rh433_rpt_det_hor_plla_rango.srw
forward
global type w_rh433_rpt_det_hor_plla_rango from w_report_smpl
end type
type cb_3 from commandbutton within w_rh433_rpt_det_hor_plla_rango
end type
type em_descripcion from editmask within w_rh433_rpt_det_hor_plla_rango
end type
type em_origen from editmask within w_rh433_rpt_det_hor_plla_rango
end type
type cb_procesar from commandbutton within w_rh433_rpt_det_hor_plla_rango
end type
type uo_2 from u_ingreso_rango_fechas within w_rh433_rpt_det_hor_plla_rango
end type
type cbx_detallado from checkbox within w_rh433_rpt_det_hor_plla_rango
end type
type gb_2 from groupbox within w_rh433_rpt_det_hor_plla_rango
end type
type uo_1 from u_ddlb_tipo_trabajador within w_rh433_rpt_det_hor_plla_rango
end type
type cbx_todos from checkbox within w_rh433_rpt_det_hor_plla_rango
end type
type sle_codigo from singlelineedit within w_rh433_rpt_det_hor_plla_rango
end type
type cb_selec from commandbutton within w_rh433_rpt_det_hor_plla_rango
end type
type st_nom_trabajador from statictext within w_rh433_rpt_det_hor_plla_rango
end type
end forward

global type w_rh433_rpt_det_hor_plla_rango from w_report_smpl
integer width = 4910
integer height = 1500
string title = "[RH433] Planilla Horizontal x Rangos"
string menuname = "m_impresion"
cb_3 cb_3
em_descripcion em_descripcion
em_origen em_origen
cb_procesar cb_procesar
uo_2 uo_2
cbx_detallado cbx_detallado
gb_2 gb_2
uo_1 uo_1
cbx_todos cbx_todos
sle_codigo sle_codigo
cb_selec cb_selec
st_nom_trabajador st_nom_trabajador
end type
global w_rh433_rpt_det_hor_plla_rango w_rh433_rpt_det_hor_plla_rango

on w_rh433_rpt_det_hor_plla_rango.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.cb_3=create cb_3
this.em_descripcion=create em_descripcion
this.em_origen=create em_origen
this.cb_procesar=create cb_procesar
this.uo_2=create uo_2
this.cbx_detallado=create cbx_detallado
this.gb_2=create gb_2
this.uo_1=create uo_1
this.cbx_todos=create cbx_todos
this.sle_codigo=create sle_codigo
this.cb_selec=create cb_selec
this.st_nom_trabajador=create st_nom_trabajador
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_3
this.Control[iCurrent+2]=this.em_descripcion
this.Control[iCurrent+3]=this.em_origen
this.Control[iCurrent+4]=this.cb_procesar
this.Control[iCurrent+5]=this.uo_2
this.Control[iCurrent+6]=this.cbx_detallado
this.Control[iCurrent+7]=this.gb_2
this.Control[iCurrent+8]=this.uo_1
this.Control[iCurrent+9]=this.cbx_todos
this.Control[iCurrent+10]=this.sle_codigo
this.Control[iCurrent+11]=this.cb_selec
this.Control[iCurrent+12]=this.st_nom_trabajador
end on

on w_rh433_rpt_det_hor_plla_rango.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_3)
destroy(this.em_descripcion)
destroy(this.em_origen)
destroy(this.cb_procesar)
destroy(this.uo_2)
destroy(this.cbx_detallado)
destroy(this.gb_2)
destroy(this.uo_1)
destroy(this.cbx_todos)
destroy(this.sle_codigo)
destroy(this.cb_selec)
destroy(this.st_nom_trabajador)
end on

event ue_retrieve;string ls_origen, ls_tipo_trabaj, ls_trabajador
date ld_fecha_ini, ld_fecha_fin 

ls_origen = string(em_origen.text)
ld_fecha_ini = uo_2.of_get_fecha1()
ld_fecha_fin = uo_2.of_get_fecha2()

ls_tipo_trabaj = uo_1.of_get_value()

if cbx_todos.checked then
	ls_trabajador = '%%'
else
	ls_trabajador = trim(sle_codigo.text) + '%'
end if

if isnull(ls_tipo_trabaj) or trim(ls_tipo_trabaj) = '' then ls_tipo_trabaj = '%'

if cbx_detallado.checked then
	dw_report.DataObject = 'd_rpt_det_plla_hor_varias_crt'
else
	dw_report.DataObject = 'd_rpt_resumen_plla_rango_crt'
end if

dw_report.SetTransObject(SQLCA)
dw_report.retrieve(ls_origen, ls_tipo_trabaj, ls_trabajador, ld_fecha_ini, ld_fecha_fin)


dw_report.Object.t_titulo1.text = 'Del ' + string(ld_fecha_ini, 'dd/mm/yyyy') &
											 + 'Al ' + string(ld_fecha_fin, 'dd/mm/yyyy')


end event

event ue_open_pre;idw_1 = dw_report
idw_1.SetTransObject(sqlca)


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

type dw_report from w_report_smpl`dw_report within w_rh433_rpt_det_hor_plla_rango
integer y = 312
integer width = 3689
integer height = 1000
integer taborder = 50
string dataobject = "d_rpt_det_plla_hor_varias_crt"
end type

event dw_report::clicked;call super::clicked;f_select_current_row(this)
end event

event dw_report::rowfocuschanged;call super::rowfocuschanged;f_select_current_row(this)
end event

type cb_3 from commandbutton within w_rh433_rpt_det_hor_plla_rango
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

type em_descripcion from editmask within w_rh433_rpt_det_hor_plla_rango
integer x = 293
integer y = 76
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

type em_origen from editmask within w_rh433_rpt_det_hor_plla_rango
integer x = 50
integer y = 76
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

type cb_procesar from commandbutton within w_rh433_rpt_det_hor_plla_rango
integer x = 3406
integer y = 36
integer width = 352
integer height = 224
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

event clicked;Parent.Event ue_retrieve()
end event

type uo_2 from u_ingreso_rango_fechas within w_rh433_rpt_det_hor_plla_rango
integer x = 2080
integer y = 24
integer taborder = 40
boolean bringtotop = true
end type

event constructor;call super::constructor;of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
of_set_fecha(today(), today()) //para setear la fecha inicial
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final
// of_get_fecha1(), of_get_fecha2()  para leer las fechas

end event

on uo_2.destroy
call u_ingreso_rango_fechas::destroy
end on

type cbx_detallado from checkbox within w_rh433_rpt_det_hor_plla_rango
integer x = 2094
integer y = 148
integer width = 594
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Detallado x boleta"
end type

type gb_2 from groupbox within w_rh433_rpt_det_hor_plla_rango
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

type uo_1 from u_ddlb_tipo_trabajador within w_rh433_rpt_det_hor_plla_rango
integer x = 1125
integer taborder = 20
end type

on uo_1.destroy
call u_ddlb_tipo_trabajador::destroy
end on

type cbx_todos from checkbox within w_rh433_rpt_det_hor_plla_rango
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

type sle_codigo from singlelineedit within w_rh433_rpt_det_hor_plla_rango
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

type cb_selec from commandbutton within w_rh433_rpt_det_hor_plla_rango
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

type st_nom_trabajador from statictext within w_rh433_rpt_det_hor_plla_rango
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

