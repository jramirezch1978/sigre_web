$PBExportHeader$w_rh332_rpt_conceptos_varios.srw
forward
global type w_rh332_rpt_conceptos_varios from w_report_smpl
end type
type cb_3 from commandbutton within w_rh332_rpt_conceptos_varios
end type
type em_descripcion from editmask within w_rh332_rpt_conceptos_varios
end type
type em_origen from editmask within w_rh332_rpt_conceptos_varios
end type
type em_desc_tipo from editmask within w_rh332_rpt_conceptos_varios
end type
type em_tipo from editmask within w_rh332_rpt_conceptos_varios
end type
type cb_2 from commandbutton within w_rh332_rpt_conceptos_varios
end type
type cb_1 from commandbutton within w_rh332_rpt_conceptos_varios
end type
type cb_4 from commandbutton within w_rh332_rpt_conceptos_varios
end type
type em_desc_concep from editmask within w_rh332_rpt_conceptos_varios
end type
type em_concepto from editmask within w_rh332_rpt_conceptos_varios
end type
type em_fec_proceso from editmask within w_rh332_rpt_conceptos_varios
end type
type st_1 from statictext within w_rh332_rpt_conceptos_varios
end type
type gb_2 from groupbox within w_rh332_rpt_conceptos_varios
end type
type gb_3 from groupbox within w_rh332_rpt_conceptos_varios
end type
type gb_1 from groupbox within w_rh332_rpt_conceptos_varios
end type
end forward

global type w_rh332_rpt_conceptos_varios from w_report_smpl
integer width = 4233
integer height = 1500
string title = "(RH332) Reporte de Conceptos Varios"
string menuname = "m_impresion"
cb_3 cb_3
em_descripcion em_descripcion
em_origen em_origen
em_desc_tipo em_desc_tipo
em_tipo em_tipo
cb_2 cb_2
cb_1 cb_1
cb_4 cb_4
em_desc_concep em_desc_concep
em_concepto em_concepto
em_fec_proceso em_fec_proceso
st_1 st_1
gb_2 gb_2
gb_3 gb_3
gb_1 gb_1
end type
global w_rh332_rpt_conceptos_varios w_rh332_rpt_conceptos_varios

on w_rh332_rpt_conceptos_varios.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.cb_3=create cb_3
this.em_descripcion=create em_descripcion
this.em_origen=create em_origen
this.em_desc_tipo=create em_desc_tipo
this.em_tipo=create em_tipo
this.cb_2=create cb_2
this.cb_1=create cb_1
this.cb_4=create cb_4
this.em_desc_concep=create em_desc_concep
this.em_concepto=create em_concepto
this.em_fec_proceso=create em_fec_proceso
this.st_1=create st_1
this.gb_2=create gb_2
this.gb_3=create gb_3
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_3
this.Control[iCurrent+2]=this.em_descripcion
this.Control[iCurrent+3]=this.em_origen
this.Control[iCurrent+4]=this.em_desc_tipo
this.Control[iCurrent+5]=this.em_tipo
this.Control[iCurrent+6]=this.cb_2
this.Control[iCurrent+7]=this.cb_1
this.Control[iCurrent+8]=this.cb_4
this.Control[iCurrent+9]=this.em_desc_concep
this.Control[iCurrent+10]=this.em_concepto
this.Control[iCurrent+11]=this.em_fec_proceso
this.Control[iCurrent+12]=this.st_1
this.Control[iCurrent+13]=this.gb_2
this.Control[iCurrent+14]=this.gb_3
this.Control[iCurrent+15]=this.gb_1
end on

on w_rh332_rpt_conceptos_varios.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_3)
destroy(this.em_descripcion)
destroy(this.em_origen)
destroy(this.em_desc_tipo)
destroy(this.em_tipo)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.cb_4)
destroy(this.em_desc_concep)
destroy(this.em_concepto)
destroy(this.em_fec_proceso)
destroy(this.st_1)
destroy(this.gb_2)
destroy(this.gb_3)
destroy(this.gb_1)
end on

event ue_retrieve;call super::ue_retrieve;string ls_origen, ls_tiptra, ls_descripcion, ls_concepto
date ld_fec_proceso

ls_origen 			= string(em_origen.text)
ls_tiptra 			= string(em_tipo.text)
ls_descripcion 	= string(em_desc_tipo.text)
ls_concepto 		= string(em_concepto.text)
ld_fec_proceso 	= date(em_fec_proceso.text)

dw_report.retrieve (ls_concepto,ls_tiptra,ls_origen,ld_fec_proceso)

dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_nombre.text 	= gs_empresa
dw_report.object.t_user.text 		= gs_user
dw_report.object.st_sit.text 		= ls_descripcion
dw_report.object.t_fec_proceso.text = string(ld_fec_proceso,'dd/mm/yyyy')

end event

type dw_report from w_report_smpl`dw_report within w_rh332_rpt_conceptos_varios
integer x = 0
integer y = 188
integer width = 3328
integer height = 856
integer taborder = 60
string dataobject = "d_rpt_conceptos_tbl"
end type

type cb_3 from commandbutton within w_rh332_rpt_conceptos_varios
integer x = 183
integer y = 60
integer width = 101
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

type em_descripcion from editmask within w_rh332_rpt_conceptos_varios
integer x = 288
integer y = 60
integer width = 759
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 16777215
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type em_origen from editmask within w_rh332_rpt_conceptos_varios
integer x = 50
integer y = 60
integer width = 123
integer height = 80
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

type em_desc_tipo from editmask within w_rh332_rpt_conceptos_varios
integer x = 1467
integer y = 60
integer width = 667
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 16777215
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type em_tipo from editmask within w_rh332_rpt_conceptos_varios
integer x = 1170
integer y = 60
integer width = 178
integer height = 80
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

type cb_2 from commandbutton within w_rh332_rpt_conceptos_varios
integer x = 1358
integer y = 60
integer width = 101
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

sl_param.dw1 = "d_seleccion_tiptra_tbl"
sl_param.titulo = "Seleccionar Búsqueda"
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2

OpenWithParm( w_search_tiptra, sl_param)		
sl_param = MESSAGE.POWEROBJECTPARM
IF sl_param.titulo <> 'n' THEN
	em_tipo.text      = sl_param.field_ret[1]
	em_desc_tipo.text = sl_param.field_ret[2]
END IF

end event

type cb_1 from commandbutton within w_rh332_rpt_conceptos_varios
integer x = 3826
integer y = 36
integer width = 293
integer height = 76
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

type cb_4 from commandbutton within w_rh332_rpt_conceptos_varios
integer x = 2427
integer y = 60
integer width = 105
integer height = 80
integer taborder = 30
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

sl_param.dw1 = "d_seleccion_concepto_tbl"
sl_param.titulo = "Seleccionar Búsqueda"
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2

OpenWithParm( w_search, sl_param)		
sl_param = MESSAGE.POWEROBJECTPARM
IF sl_param.titulo <> 'n' THEN
	em_concepto.text    = sl_param.field_ret[1]
	em_desc_concep.text = sl_param.field_ret[2]
END IF

end event

type em_desc_concep from editmask within w_rh332_rpt_conceptos_varios
integer x = 2546
integer y = 60
integer width = 681
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 16777215
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type em_concepto from editmask within w_rh332_rpt_conceptos_varios
integer x = 2235
integer y = 60
integer width = 183
integer height = 80
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

type em_fec_proceso from editmask within w_rh332_rpt_conceptos_varios
integer x = 3301
integer y = 60
integer width = 402
integer height = 80
integer taborder = 40
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
end type

type st_1 from statictext within w_rh332_rpt_conceptos_varios
integer x = 3278
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

type gb_2 from groupbox within w_rh332_rpt_conceptos_varios
integer width = 1097
integer height = 172
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = " Seleccione Origen "
end type

type gb_3 from groupbox within w_rh332_rpt_conceptos_varios
integer x = 1125
integer width = 1056
integer height = 172
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = " Tipo de Trabajador "
end type

type gb_1 from groupbox within w_rh332_rpt_conceptos_varios
integer x = 2185
integer width = 1097
integer height = 172
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = " Seleccione Concepto "
borderstyle borderstyle = stylebox!
end type

