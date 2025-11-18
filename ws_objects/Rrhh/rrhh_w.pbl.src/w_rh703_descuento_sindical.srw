$PBExportHeader$w_rh703_descuento_sindical.srw
forward
global type w_rh703_descuento_sindical from w_report_smpl
end type
type cb_1 from commandbutton within w_rh703_descuento_sindical
end type
type st_3 from statictext within w_rh703_descuento_sindical
end type
type st_4 from statictext within w_rh703_descuento_sindical
end type
type em_tipo from editmask within w_rh703_descuento_sindical
end type
type cb_2 from commandbutton within w_rh703_descuento_sindical
end type
type em_desc_tipo from editmask within w_rh703_descuento_sindical
end type
type em_descripcion from editmask within w_rh703_descuento_sindical
end type
type cb_3 from commandbutton within w_rh703_descuento_sindical
end type
type em_origen from editmask within w_rh703_descuento_sindical
end type
type sle_year from singlelineedit within w_rh703_descuento_sindical
end type
type sle_mes from singlelineedit within w_rh703_descuento_sindical
end type
type em_fec_proceso from editmask within w_rh703_descuento_sindical
end type
type rb_fec_proceso from radiobutton within w_rh703_descuento_sindical
end type
type rb_periodo from radiobutton within w_rh703_descuento_sindical
end type
type gb_1 from groupbox within w_rh703_descuento_sindical
end type
end forward

global type w_rh703_descuento_sindical from w_report_smpl
integer width = 5115
integer height = 2152
string title = "[RH703] Reporte de Descuento Sindical"
string menuname = "m_impresion"
cb_1 cb_1
st_3 st_3
st_4 st_4
em_tipo em_tipo
cb_2 cb_2
em_desc_tipo em_desc_tipo
em_descripcion em_descripcion
cb_3 cb_3
em_origen em_origen
sle_year sle_year
sle_mes sle_mes
em_fec_proceso em_fec_proceso
rb_fec_proceso rb_fec_proceso
rb_periodo rb_periodo
gb_1 gb_1
end type
global w_rh703_descuento_sindical w_rh703_descuento_sindical

on w_rh703_descuento_sindical.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.cb_1=create cb_1
this.st_3=create st_3
this.st_4=create st_4
this.em_tipo=create em_tipo
this.cb_2=create cb_2
this.em_desc_tipo=create em_desc_tipo
this.em_descripcion=create em_descripcion
this.cb_3=create cb_3
this.em_origen=create em_origen
this.sle_year=create sle_year
this.sle_mes=create sle_mes
this.em_fec_proceso=create em_fec_proceso
this.rb_fec_proceso=create rb_fec_proceso
this.rb_periodo=create rb_periodo
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.st_3
this.Control[iCurrent+3]=this.st_4
this.Control[iCurrent+4]=this.em_tipo
this.Control[iCurrent+5]=this.cb_2
this.Control[iCurrent+6]=this.em_desc_tipo
this.Control[iCurrent+7]=this.em_descripcion
this.Control[iCurrent+8]=this.cb_3
this.Control[iCurrent+9]=this.em_origen
this.Control[iCurrent+10]=this.sle_year
this.Control[iCurrent+11]=this.sle_mes
this.Control[iCurrent+12]=this.em_fec_proceso
this.Control[iCurrent+13]=this.rb_fec_proceso
this.Control[iCurrent+14]=this.rb_periodo
this.Control[iCurrent+15]=this.gb_1
end on

on w_rh703_descuento_sindical.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.em_tipo)
destroy(this.cb_2)
destroy(this.em_desc_tipo)
destroy(this.em_descripcion)
destroy(this.cb_3)
destroy(this.em_origen)
destroy(this.sle_year)
destroy(this.sle_mes)
destroy(this.em_fec_proceso)
destroy(this.rb_fec_proceso)
destroy(this.rb_periodo)
destroy(this.gb_1)
end on

event ue_retrieve;call super::ue_retrieve;String  	ls_origen, ls_tiptra, ls_desc_origen,   ls_msg, ls_mensaje, ls_flag
Integer 	li_msg, li_year, li_mes
Date		ld_fec_proceso

try 
	dw_report.reset( )
	
	If isnull(em_origen.text)  Or trim(em_origen.text)  = '' Then 
		MessageBox('Atención','Debe Ingresar el Origen', Information!)
		em_origen.SetFocus()
		return
	end if
	
	If isnull(em_tipo.text)  Or trim(em_tipo.text)  = '' Then 
		MessageBox('Atención','Debe Ingresar el Tipo de trabajador', Information!)
		em_origen.SetFocus()
		return
	end if
	
	
	ls_origen      = trim(em_origen.text) + '%'
	ls_desc_origen = trim(em_descripcion.text)
	ls_tiptra 		= trim(em_tipo.text) + '%'
	ld_fec_proceso = Date(em_fec_proceso.text)
	
	li_year			= Integer(sle_year.text)
	li_mes			= Integer(sle_mes.text)
	
	if rb_periodo.checked then
		ls_flag = '1'
	else
		ls_flag = '2'
	end if
	
	
	If isnull(ls_tiptra)  Or trim(ls_tiptra)  = '' Then ls_tiptra  = '%'

	
	dw_report.setTransObject( SQLCA )
	
	ib_preview = false
	event ue_preview()
	
	dw_report.retrieve(ls_origen, ls_tiptra, li_year, li_mes, ld_fec_proceso, ls_flag)
	dw_report.object.p_logo.filename  = gs_logo
	dw_report.object.t_empresa.text   = gs_empresa
	dw_report.object.t_ventana.text   = this.ClassName()
	
	if dw_report.of_ExistsPictureName("p_logo1") then
		dw_report.object.p_logo1.filename = gs_logo
	end if
	if dw_report.of_ExistsText("t_nombre1") then
		dw_report.object.t_nombre1.text   = ls_desc_origen
	end if
	
catch ( Exception ex )
	gnvo_app.of_catch_exception(ex, "Error en generar reporte de descuento sindical")
end try

	
end event

event ue_open_pre;call super::ue_open_pre;Str_parametros		lstr_param
string				ls_desc_origen, ls_data, ls_desc_tipo_planilla
Date					ld_hoy

try 
	ld_hoy = Date(gnvo_app.of_fecha_actual())
	
	sle_year.text = string(ld_hoy, 'yyyy')
	sle_mes.text = string(ld_hoy, 'mm')
	em_fec_proceso.text = string(ld_hoy, 'dd/mm/yyyy')
	
	//Pongo el origen por defecto
	select nombre
		into :ls_desc_origen
	from origen
	where cod_origen = :gs_origen;
	
	em_origen.text = gs_origen


catch ( Exception ex )
	gnvo_app.of_catch_exception(ex, "")
end try


end event

type dw_report from w_report_smpl`dw_report within w_rh703_descuento_sindical
integer x = 0
integer y = 268
integer width = 3438
integer height = 1444
integer taborder = 60
string dataobject = "d_rpt_descuento_sindicato_crt"
end type

type cb_1 from commandbutton within w_rh703_descuento_sindical
integer x = 2843
integer y = 52
integer width = 315
integer height = 184
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

event clicked;setPointer(HourGlass!)
Parent.Event ue_retrieve()
setPointer(Arrow!)
end event

type st_3 from statictext within w_rh703_descuento_sindical
integer x = 14
integer y = 60
integer width = 466
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

type st_4 from statictext within w_rh703_descuento_sindical
integer x = 14
integer y = 144
integer width = 466
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

type em_tipo from editmask within w_rh703_descuento_sindical
integer x = 485
integer y = 136
integer width = 283
integer height = 76
integer taborder = 60
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

type cb_2 from commandbutton within w_rh703_descuento_sindical
integer x = 773
integer y = 136
integer width = 87
integer height = 76
integer taborder = 70
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

type em_desc_tipo from editmask within w_rh703_descuento_sindical
integer x = 859
integer y = 136
integer width = 983
integer height = 76
integer taborder = 80
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

type em_descripcion from editmask within w_rh703_descuento_sindical
integer x = 859
integer y = 52
integer width = 983
integer height = 76
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 15793151
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type cb_3 from commandbutton within w_rh703_descuento_sindical
integer x = 773
integer y = 52
integer width = 87
integer height = 76
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

type em_origen from editmask within w_rh703_descuento_sindical
integer x = 485
integer y = 52
integer width = 283
integer height = 76
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
alignment alignment = center!
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type sle_year from singlelineedit within w_rh703_descuento_sindical
integer x = 2377
integer y = 136
integer width = 229
integer height = 76
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
end type

type sle_mes from singlelineedit within w_rh703_descuento_sindical
integer x = 2615
integer y = 136
integer width = 155
integer height = 76
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
end type

type em_fec_proceso from editmask within w_rh703_descuento_sindical
integer x = 2377
integer y = 48
integer width = 434
integer height = 80
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
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "dd/mm/yyyy"
boolean dropdowncalendar = true
end type

type rb_fec_proceso from radiobutton within w_rh703_descuento_sindical
integer x = 1856
integer y = 52
integer width = 485
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Fecha de Proceso"
end type

event clicked;if this.checked then
	sle_year.enabled = false
	sle_mes.enabled = false
	em_fec_proceso.enabled = true
end if
end event

type rb_periodo from radiobutton within w_rh703_descuento_sindical
integer x = 1851
integer y = 136
integer width = 485
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Periodo"
boolean checked = true
end type

event clicked;if this.checked then
	sle_year.enabled = true
	sle_mes.enabled = true
	em_fec_proceso.enabled = false
end if
end event

type gb_1 from groupbox within w_rh703_descuento_sindical
integer width = 4686
integer height = 260
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Filtro para el reporte"
end type

