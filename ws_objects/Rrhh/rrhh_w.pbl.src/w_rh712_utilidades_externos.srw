$PBExportHeader$w_rh712_utilidades_externos.srw
forward
global type w_rh712_utilidades_externos from w_report_smpl
end type
type cb_1 from commandbutton within w_rh712_utilidades_externos
end type
type em_periodo from editmask within w_rh712_utilidades_externos
end type
type st_1 from statictext within w_rh712_utilidades_externos
end type
type em_item from editmask within w_rh712_utilidades_externos
end type
type st_3 from statictext within w_rh712_utilidades_externos
end type
type em_origen from editmask within w_rh712_utilidades_externos
end type
type cb_3 from commandbutton within w_rh712_utilidades_externos
end type
type em_descripcion from editmask within w_rh712_utilidades_externos
end type
type st_4 from statictext within w_rh712_utilidades_externos
end type
type em_tipo from editmask within w_rh712_utilidades_externos
end type
type cb_2 from commandbutton within w_rh712_utilidades_externos
end type
type em_desc_tipo from editmask within w_rh712_utilidades_externos
end type
type st_2 from statictext within w_rh712_utilidades_externos
end type
type em_fec_proceso from editmask within w_rh712_utilidades_externos
end type
type gb_1 from groupbox within w_rh712_utilidades_externos
end type
end forward

global type w_rh712_utilidades_externos from w_report_smpl
integer width = 3552
integer height = 1876
string title = "(RH712) Detalle de Utilidades Externos"
string menuname = "m_impresion"
cb_1 cb_1
em_periodo em_periodo
st_1 st_1
em_item em_item
st_3 st_3
em_origen em_origen
cb_3 cb_3
em_descripcion em_descripcion
st_4 st_4
em_tipo em_tipo
cb_2 cb_2
em_desc_tipo em_desc_tipo
st_2 st_2
em_fec_proceso em_fec_proceso
gb_1 gb_1
end type
global w_rh712_utilidades_externos w_rh712_utilidades_externos

on w_rh712_utilidades_externos.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.cb_1=create cb_1
this.em_periodo=create em_periodo
this.st_1=create st_1
this.em_item=create em_item
this.st_3=create st_3
this.em_origen=create em_origen
this.cb_3=create cb_3
this.em_descripcion=create em_descripcion
this.st_4=create st_4
this.em_tipo=create em_tipo
this.cb_2=create cb_2
this.em_desc_tipo=create em_desc_tipo
this.st_2=create st_2
this.em_fec_proceso=create em_fec_proceso
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.em_periodo
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.em_item
this.Control[iCurrent+5]=this.st_3
this.Control[iCurrent+6]=this.em_origen
this.Control[iCurrent+7]=this.cb_3
this.Control[iCurrent+8]=this.em_descripcion
this.Control[iCurrent+9]=this.st_4
this.Control[iCurrent+10]=this.em_tipo
this.Control[iCurrent+11]=this.cb_2
this.Control[iCurrent+12]=this.em_desc_tipo
this.Control[iCurrent+13]=this.st_2
this.Control[iCurrent+14]=this.em_fec_proceso
this.Control[iCurrent+15]=this.gb_1
end on

on w_rh712_utilidades_externos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.em_periodo)
destroy(this.st_1)
destroy(this.em_item)
destroy(this.st_3)
destroy(this.em_origen)
destroy(this.cb_3)
destroy(this.em_descripcion)
destroy(this.st_4)
destroy(this.em_tipo)
destroy(this.cb_2)
destroy(this.em_desc_tipo)
destroy(this.st_2)
destroy(this.em_fec_proceso)
destroy(this.gb_1)
end on

event ue_retrieve;call super::ue_retrieve;string  	ls_mensaje, ls_origen, ls_tipo_trabaj, ls_desc_origen, ls_desc_tipo_trabaj
integer 	li_periodo, li_item
Date		ld_fec_proceso

li_periodo 	= integer(em_periodo.text)
li_item 		= integer(em_item.text)

ls_origen = string(em_origen.text)
ld_fec_proceso = date(em_fec_proceso.text)

ls_tipo_trabaj = trim(em_tipo.text) + '%'

ls_desc_origen 		= em_descripcion.text
ls_desc_tipo_trabaj 	= em_desc_tipo.text
	
dw_report.retrieve(li_periodo, li_item, ls_origen, ls_tipo_trabaj, ld_fec_proceso)

dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_empresa.text = gs_empresa
dw_report.object.t_user.text = gs_user
dw_report.object.t_texto.text = 'Periodo ' + String(li_periodo) + ' - ' + String(li_item) + ', ' + ls_desc_origen + ' - ' + ls_desc_tipo_trabaj
end event

event ue_open_pre;call super::ue_open_pre;Integer 	li_periodo, li_item
Date		ld_fec_proceso

select t.periodo, t.item
	into :li_periodo, :li_item
from utl_distribucion t
order by t.periodo desc, t.item desc;

em_periodo.text 	= string(li_periodo)
em_item.text		= String(li_item)

select fec_proceso
  into :ld_fec_proceso
from (select distinct c.fec_proceso
		  from calculo c
		  where c.concep in (select * 
									  from table(split(PKG_CONFIG.USF_GET_PARAMETER('RRHH_CNC_UTILIDAD', '1428'))))
		  UNION
		 select distinct hc.fec_calc_plan
			from historico_calculo hc
		  where hc.concep in (select * 
									  from table(split(PKG_CONFIG.USF_GET_PARAMETER('RRHH_CNC_UTILIDAD', '1428'))))
		) s
order by s.fec_proceso desc;

em_fec_proceso.text = String(ld_fec_proceso, 'dd/mm/yyyy')

end event

type dw_report from w_report_smpl`dw_report within w_rh712_utilidades_externos
integer x = 0
integer y = 344
integer width = 3456
integer height = 1360
integer taborder = 60
string dataobject = "d_rpt_utilidad_externos_tbl"
end type

type cb_1 from commandbutton within w_rh712_utilidades_externos
integer x = 2245
integer y = 64
integer width = 293
integer height = 180
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

type em_periodo from editmask within w_rh712_utilidades_externos
integer x = 430
integer y = 60
integer width = 187
integer height = 76
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
alignment alignment = center!
borderstyle borderstyle = stylelowered!
string mask = "####"
end type

type st_1 from statictext within w_rh712_utilidades_externos
integer x = 50
integer y = 68
integer width = 379
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Período :"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_item from editmask within w_rh712_utilidades_externos
integer x = 626
integer y = 60
integer width = 105
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
borderstyle borderstyle = stylelowered!
string mask = "#"
end type

type st_3 from statictext within w_rh712_utilidades_externos
integer x = 50
integer y = 160
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

type em_origen from editmask within w_rh712_utilidades_externos
integer x = 430
integer y = 144
integer width = 183
integer height = 76
integer taborder = 10
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

type cb_3 from commandbutton within w_rh712_utilidades_externos
integer x = 617
integer y = 144
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

type em_descripcion from editmask within w_rh712_utilidades_externos
integer x = 704
integer y = 144
integer width = 983
integer height = 76
integer taborder = 30
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

type st_4 from statictext within w_rh712_utilidades_externos
integer x = 50
integer y = 236
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

type em_tipo from editmask within w_rh712_utilidades_externos
integer x = 430
integer y = 228
integer width = 183
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

type cb_2 from commandbutton within w_rh712_utilidades_externos
integer x = 617
integer y = 228
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

type em_desc_tipo from editmask within w_rh712_utilidades_externos
integer x = 704
integer y = 228
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

type st_2 from statictext within w_rh712_utilidades_externos
integer x = 1733
integer y = 104
integer width = 448
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 67108864
string text = "Fecha de Proceso"
alignment alignment = center!
boolean focusrectangle = false
end type

type em_fec_proceso from editmask within w_rh712_utilidades_externos
integer x = 1733
integer y = 180
integer width = 448
integer height = 72
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 16777215
alignment alignment = center!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "dd/mm/yyyy"
boolean dropdowncalendar = true
end type

type gb_1 from groupbox within w_rh712_utilidades_externos
integer width = 3145
integer height = 328
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Parámetros"
end type

