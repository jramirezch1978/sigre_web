$PBExportHeader$w_rh423_liquidacion_benef.srw
forward
global type w_rh423_liquidacion_benef from w_report_smpl
end type
type cb_3 from commandbutton within w_rh423_liquidacion_benef
end type
type em_descripcion from editmask within w_rh423_liquidacion_benef
end type
type em_origen from editmask within w_rh423_liquidacion_benef
end type
type cb_1 from commandbutton within w_rh423_liquidacion_benef
end type
type em_desc_tipo from editmask within w_rh423_liquidacion_benef
end type
type em_tipo from editmask within w_rh423_liquidacion_benef
end type
type cb_2 from commandbutton within w_rh423_liquidacion_benef
end type
type st_4 from statictext within w_rh423_liquidacion_benef
end type
type st_3 from statictext within w_rh423_liquidacion_benef
end type
type st_1 from statictext within w_rh423_liquidacion_benef
end type
type em_year from editmask within w_rh423_liquidacion_benef
end type
type em_mes from editmask within w_rh423_liquidacion_benef
end type
type gb_1 from groupbox within w_rh423_liquidacion_benef
end type
end forward

global type w_rh423_liquidacion_benef from w_report_smpl
integer width = 4731
integer height = 1500
string title = "[RH423] Planilla Horizaontal de LBS"
string menuname = "m_impresion"
cb_3 cb_3
em_descripcion em_descripcion
em_origen em_origen
cb_1 cb_1
em_desc_tipo em_desc_tipo
em_tipo em_tipo
cb_2 cb_2
st_4 st_4
st_3 st_3
st_1 st_1
em_year em_year
em_mes em_mes
gb_1 gb_1
end type
global w_rh423_liquidacion_benef w_rh423_liquidacion_benef

on w_rh423_liquidacion_benef.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.cb_3=create cb_3
this.em_descripcion=create em_descripcion
this.em_origen=create em_origen
this.cb_1=create cb_1
this.em_desc_tipo=create em_desc_tipo
this.em_tipo=create em_tipo
this.cb_2=create cb_2
this.st_4=create st_4
this.st_3=create st_3
this.st_1=create st_1
this.em_year=create em_year
this.em_mes=create em_mes
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_3
this.Control[iCurrent+2]=this.em_descripcion
this.Control[iCurrent+3]=this.em_origen
this.Control[iCurrent+4]=this.cb_1
this.Control[iCurrent+5]=this.em_desc_tipo
this.Control[iCurrent+6]=this.em_tipo
this.Control[iCurrent+7]=this.cb_2
this.Control[iCurrent+8]=this.st_4
this.Control[iCurrent+9]=this.st_3
this.Control[iCurrent+10]=this.st_1
this.Control[iCurrent+11]=this.em_year
this.Control[iCurrent+12]=this.em_mes
this.Control[iCurrent+13]=this.gb_1
end on

on w_rh423_liquidacion_benef.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_3)
destroy(this.em_descripcion)
destroy(this.em_origen)
destroy(this.cb_1)
destroy(this.em_desc_tipo)
destroy(this.em_tipo)
destroy(this.cb_2)
destroy(this.st_4)
destroy(this.st_3)
destroy(this.st_1)
destroy(this.em_year)
destroy(this.em_mes)
destroy(this.gb_1)
end on

event ue_retrieve;call super::ue_retrieve;string	ls_origen, ls_tipo_trabaj
Long		ll_year, ll_mes

ls_origen = string(em_origen.text)

ls_tipo_trabaj = trim(em_tipo.text) + '%'

ll_year = Long(em_year.text)
ll_mes  = Long(em_mes.text)

if ll_mes <= 0 or ll_mes > 12 then
	MessageBox('Error', 'Debe Elegir un mes válido', StopSign!)
	em_mes.setFocus()
	return
end if
	
dw_report.setTransObject(SQLCA)
dw_report.retrieve(ls_origen, ls_tipo_Trabaj, ll_year, ll_mes)
	
dw_report.Object.p_logo.filename 	= gs_logo
dw_report.Object.t_user.text  		= gs_user
dw_report.Object.t_empresa.text  	= gs_empresa

	

end event

event ue_open_pre;DateTime	ldt_now

try 
	ldt_now = gnvo_app.of_fecha_actual()
	
	idw_1 = dw_report
	idw_1.SetTransObject(sqlca)
	idw_1.Visible = False
	
	em_year.text 	= string(ldt_now, 'yyyy')
	em_mes.text 	= string(ldt_now, 'mm')
	
	
catch ( Exception ex )
	gnvo_app.of_catch_exception(ex, "")
end try


end event

event ue_saveas;//Overrding
string ls_path, ls_file
int li_rc

li_rc = GetFileSaveName ( "Select File", &
   ls_path, ls_file, "XLS", &
   "Hoja de Excel (*.xls),*.xls" , "C:\", 32770)

IF li_rc = 1 Then
   uf_save_dw_as_excel ( dw_report, ls_file )
End If
end event

type dw_report from w_report_smpl`dw_report within w_rh423_liquidacion_benef
integer x = 0
integer y = 316
integer width = 3337
integer height = 972
integer taborder = 70
string dataobject = "d_rpt_liquidacion_benefcios_tbl"
end type

event dw_report::rowfocuschanged;call super::rowfocuschanged;f_select_current_row(this)
end event

type cb_3 from commandbutton within w_rh423_liquidacion_benef
integer x = 672
integer y = 44
integer width = 87
integer height = 76
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

type em_descripcion from editmask within w_rh423_liquidacion_benef
integer x = 759
integer y = 44
integer width = 983
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 255
long backcolor = 15793151
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type em_origen from editmask within w_rh423_liquidacion_benef
integer x = 485
integer y = 44
integer width = 183
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 16777215
alignment alignment = center!
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type cb_1 from commandbutton within w_rh423_liquidacion_benef
integer x = 1783
integer y = 56
integer width = 293
integer height = 172
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Generar"
end type

event clicked;SetPointer(HourGlass!)
Parent.Event ue_retrieve()
SetPointer(Arrow!)
end event

type em_desc_tipo from editmask within w_rh423_liquidacion_benef
integer x = 759
integer y = 128
integer width = 983
integer height = 76
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 15793151
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type em_tipo from editmask within w_rh423_liquidacion_benef
integer x = 485
integer y = 128
integer width = 183
integer height = 76
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
string text = "%"
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type cb_2 from commandbutton within w_rh423_liquidacion_benef
integer x = 672
integer y = 128
integer width = 87
integer height = 76
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;boolean lb_ret
string ls_codigo, ls_data, ls_sql, ls_origen

ls_origen = trim(em_origen.text) + '%'

ls_sql = "SELECT distinct tt.TIPO_TRABAJADOR AS CODIGO_origen, " &
		  + "tt.DESC_TIPO_TRA AS descripcion_tipo " &
		  + "FROM tipo_trabajador tt," &
		  + "     maestro			  m " &
		  + "WHERE m.tipo_Trabajador = tt.tipo_trabajador " &
		  + "  and m.cod_origen like '" + ls_origen + "'" &
		  + "  and m.flag_estado = '1'" &
		  + "  and tt.FLAG_ESTADO = '1'"

lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

if ls_codigo <> '' then
	em_tipo.text = ls_codigo
	em_desc_tipo.text = ls_data
end if

end event

type st_4 from statictext within w_rh423_liquidacion_benef
integer x = 50
integer y = 136
integer width = 379
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Tipo Trabajador :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_3 from statictext within w_rh423_liquidacion_benef
integer x = 50
integer y = 60
integer width = 379
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Origen :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_1 from statictext within w_rh423_liquidacion_benef
integer x = 50
integer y = 224
integer width = 379
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Periodo :"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_year from editmask within w_rh423_liquidacion_benef
integer x = 485
integer y = 212
integer width = 265
integer height = 76
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
alignment alignment = right!
boolean displayonly = true
borderstyle borderstyle = stylelowered!
string mask = "###0"
boolean spin = true
double increment = 1
end type

type em_mes from editmask within w_rh423_liquidacion_benef
integer x = 759
integer y = 212
integer width = 183
integer height = 76
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
alignment alignment = right!
boolean displayonly = true
borderstyle borderstyle = stylelowered!
string mask = "00"
boolean spin = true
end type

type gb_1 from groupbox within w_rh423_liquidacion_benef
integer width = 4686
integer height = 304
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Filtro para el reporte"
end type

