$PBExportHeader$w_rh736_vacaciones_gozadas.srw
forward
global type w_rh736_vacaciones_gozadas from w_report_smpl
end type
type cb_1 from commandbutton within w_rh736_vacaciones_gozadas
end type
type st_3 from statictext within w_rh736_vacaciones_gozadas
end type
type st_4 from statictext within w_rh736_vacaciones_gozadas
end type
type em_tipo from editmask within w_rh736_vacaciones_gozadas
end type
type cb_2 from commandbutton within w_rh736_vacaciones_gozadas
end type
type em_desc_tipo from editmask within w_rh736_vacaciones_gozadas
end type
type em_descripcion from editmask within w_rh736_vacaciones_gozadas
end type
type cb_3 from commandbutton within w_rh736_vacaciones_gozadas
end type
type em_origen from editmask within w_rh736_vacaciones_gozadas
end type
type em_cod_trabajador from editmask within w_rh736_vacaciones_gozadas
end type
type cb_4 from commandbutton within w_rh736_vacaciones_gozadas
end type
type em_nom_trabajador from editmask within w_rh736_vacaciones_gozadas
end type
type st_5 from statictext within w_rh736_vacaciones_gozadas
end type
type gb_1 from groupbox within w_rh736_vacaciones_gozadas
end type
end forward

global type w_rh736_vacaciones_gozadas from w_report_smpl
integer width = 5115
integer height = 2152
string title = "[RH733] Saldo días de vacaciones"
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
em_cod_trabajador em_cod_trabajador
cb_4 cb_4
em_nom_trabajador em_nom_trabajador
st_5 st_5
gb_1 gb_1
end type
global w_rh736_vacaciones_gozadas w_rh736_vacaciones_gozadas

on w_rh736_vacaciones_gozadas.create
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
this.em_cod_trabajador=create em_cod_trabajador
this.cb_4=create cb_4
this.em_nom_trabajador=create em_nom_trabajador
this.st_5=create st_5
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
this.Control[iCurrent+10]=this.em_cod_trabajador
this.Control[iCurrent+11]=this.cb_4
this.Control[iCurrent+12]=this.em_nom_trabajador
this.Control[iCurrent+13]=this.st_5
this.Control[iCurrent+14]=this.gb_1
end on

on w_rh736_vacaciones_gozadas.destroy
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
destroy(this.em_cod_trabajador)
destroy(this.cb_4)
destroy(this.em_nom_trabajador)
destroy(this.st_5)
destroy(this.gb_1)
end on

event ue_retrieve;call super::ue_retrieve;String  	ls_origen, ls_tiptra, ls_codigo


dw_report.reset( )

ls_origen      = trim(em_origen.text)
ls_tiptra 		= trim(em_tipo.text) + '%'
ls_codigo      = trim(em_cod_trabajador.text) + '%'


If isnull(ls_origen)  Or trim(ls_origen)  = '' Then 
	MessageBox('Atención','Debe Ingresar el Origen')
	return
end if

If isnull(ls_tiptra)  Or trim(ls_tiptra)  = '' Then ls_tiptra  = '%'
If isnull(ls_codigo)  Or trim(ls_codigo)  = '' Then ls_codigo  = '%'


ib_preview = true
event ue_preview()

dw_report.retrieve(ls_origen, ls_tiptra, ls_codigo)

dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_empresa.text  = gs_empresa
dw_report.object.t_user.text   	= gs_user
dw_report.object.t_ventana.text 	= this.classname( )


	
end event

event ue_open_pre;call super::ue_open_pre;date	ld_hoy

try 
	//ld_hoy = Date(gnvo_app.of_fecha_actual())
	
	//em_year.text = string(ld_hoy, 'yyyy')

catch ( Exception ex )
	gnvo_app.of_catch_exception(ex, "")
end try


end event

type dw_report from w_report_smpl`dw_report within w_rh736_vacaciones_gozadas
integer x = 0
integer y = 332
integer width = 3438
integer height = 1444
integer taborder = 60
string dataobject = "d_rpt_control_vacaciones_tbl"
end type

type cb_1 from commandbutton within w_rh736_vacaciones_gozadas
integer x = 1902
integer y = 64
integer width = 315
integer height = 220
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

type st_3 from statictext within w_rh736_vacaciones_gozadas
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

type st_4 from statictext within w_rh736_vacaciones_gozadas
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

type em_tipo from editmask within w_rh736_vacaciones_gozadas
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

type cb_2 from commandbutton within w_rh736_vacaciones_gozadas
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

type em_desc_tipo from editmask within w_rh736_vacaciones_gozadas
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

type em_descripcion from editmask within w_rh736_vacaciones_gozadas
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

type cb_3 from commandbutton within w_rh736_vacaciones_gozadas
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

type em_origen from editmask within w_rh736_vacaciones_gozadas
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

type em_cod_trabajador from editmask within w_rh736_vacaciones_gozadas
integer x = 485
integer y = 220
integer width = 283
integer height = 76
integer taborder = 70
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

type cb_4 from commandbutton within w_rh736_vacaciones_gozadas
integer x = 773
integer y = 220
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
string ls_codigo, ls_data, ls_sql, ls_origen, ls_tipo_trabajador

ls_origen = trim(em_origen.text)

if ls_origen = '' then
	gnvo_App.of_mensaje_error("Debe especificar un codigo de origen antes de continuar", "Error")
	em_origen.setFocus()
	return
end if

ls_tipo_trabajador = trim(em_tipo.text) + '%'

ls_sql = "SELECT distinct m.COD_TRABAJADOR as codigo_trabajador, " &
		 + "m.NOM_TRABAJADOR as nombre_trabajador, " &
		 + "m.DNI as dni " &
		 + "from vw_pr_trabajador m, "&
		 + "     historico_calculo hc " &
		 + "where m.cod_trabajador = hc.cod_trabajador " &
		 + "  and hc.cod_origen = '" + ls_origen + "'" &
		 + "  and hc.tipo_trabajador like '" + ls_tipo_trabajador + "'"

lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

if ls_codigo <> '' then
	em_cod_trabajador.text = ls_codigo
	em_nom_trabajador.text = ls_data
end if

end event

type em_nom_trabajador from editmask within w_rh736_vacaciones_gozadas
integer x = 859
integer y = 220
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

type st_5 from statictext within w_rh736_vacaciones_gozadas
integer x = 14
integer y = 228
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
string text = "Código Trabajador :"
alignment alignment = right!
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_rh736_vacaciones_gozadas
integer width = 4686
integer height = 312
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

