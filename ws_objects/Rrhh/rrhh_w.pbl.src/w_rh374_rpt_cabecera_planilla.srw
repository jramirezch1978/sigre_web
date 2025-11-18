$PBExportHeader$w_rh374_rpt_cabecera_planilla.srw
forward
global type w_rh374_rpt_cabecera_planilla from w_report_smpl
end type
type cb_3 from commandbutton within w_rh374_rpt_cabecera_planilla
end type
type em_descripcion from editmask within w_rh374_rpt_cabecera_planilla
end type
type em_origen from editmask within w_rh374_rpt_cabecera_planilla
end type
type em_desc_tipo from editmask within w_rh374_rpt_cabecera_planilla
end type
type em_tipo from editmask within w_rh374_rpt_cabecera_planilla
end type
type cb_2 from commandbutton within w_rh374_rpt_cabecera_planilla
end type
type cb_1 from commandbutton within w_rh374_rpt_cabecera_planilla
end type
type st_1 from statictext within w_rh374_rpt_cabecera_planilla
end type
type em_desde from editmask within w_rh374_rpt_cabecera_planilla
end type
type em_hasta from editmask within w_rh374_rpt_cabecera_planilla
end type
type st_2 from statictext within w_rh374_rpt_cabecera_planilla
end type
type gb_2 from groupbox within w_rh374_rpt_cabecera_planilla
end type
type gb_3 from groupbox within w_rh374_rpt_cabecera_planilla
end type
type gb_1 from groupbox within w_rh374_rpt_cabecera_planilla
end type
end forward

global type w_rh374_rpt_cabecera_planilla from w_report_smpl
integer width = 4384
integer height = 1500
string title = "(RH374) Emisión de Cabecera Para Reporte de Planillas"
string menuname = "m_impresion"
cb_3 cb_3
em_descripcion em_descripcion
em_origen em_origen
em_desc_tipo em_desc_tipo
em_tipo em_tipo
cb_2 cb_2
cb_1 cb_1
st_1 st_1
em_desde em_desde
em_hasta em_hasta
st_2 st_2
gb_2 gb_2
gb_3 gb_3
gb_1 gb_1
end type
global w_rh374_rpt_cabecera_planilla w_rh374_rpt_cabecera_planilla

on w_rh374_rpt_cabecera_planilla.create
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
this.st_1=create st_1
this.em_desde=create em_desde
this.em_hasta=create em_hasta
this.st_2=create st_2
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
this.Control[iCurrent+8]=this.st_1
this.Control[iCurrent+9]=this.em_desde
this.Control[iCurrent+10]=this.em_hasta
this.Control[iCurrent+11]=this.st_2
this.Control[iCurrent+12]=this.gb_2
this.Control[iCurrent+13]=this.gb_3
this.Control[iCurrent+14]=this.gb_1
end on

on w_rh374_rpt_cabecera_planilla.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_3)
destroy(this.em_descripcion)
destroy(this.em_origen)
destroy(this.em_desc_tipo)
destroy(this.em_tipo)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.st_1)
destroy(this.em_desde)
destroy(this.em_hasta)
destroy(this.st_2)
destroy(this.gb_2)
destroy(this.gb_3)
destroy(this.gb_1)
end on

event ue_retrieve;call super::ue_retrieve;string ls_origen, ls_tiptra, ls_descripcion, ls_desde, ls_hasta

ls_origen = string(em_origen.text)
ls_tiptra = string(em_tipo.text)
ls_descripcion = string(em_desc_tipo.text)
ls_desde = string(em_desde.text)
ls_hasta = string(em_hasta.text)

DECLARE pb_usp_rh_rpt_cabecera_planilla PROCEDURE FOR USP_RH_RPT_CABECERA_PLANILLA
 	     ( :ls_tiptra, :ls_origen, :ls_desde, :ls_hasta ) ;
EXECUTE pb_usp_rh_rpt_cabecera_planilla ;

if ls_origen = 'PR' then

	dw_report.DataObject='d_rpt_cabecera_planilla_aipsa_tbl'
	dw_report.SetTransObject(sqlca)
	dw_report.retrieve()
	dw_report.object.p_logo.filename = gs_logo
	dw_report.object.st_sit.text = ls_descripcion

elseif ls_origen = 'IN' then

	dw_report.DataObject='d_rpt_cabecera_planilla_ingenio_tbl'
	dw_report.SetTransObject(sqlca)
	dw_report.retrieve()
	dw_report.object.p_logo.filename = gs_logo
	dw_report.object.st_sit.text = ls_descripcion

end if
end event

type dw_report from w_report_smpl`dw_report within w_rh374_rpt_cabecera_planilla
integer x = 0
integer y = 184
integer width = 3369
integer height = 820
integer taborder = 60
end type

type cb_3 from commandbutton within w_rh374_rpt_cabecera_planilla
integer x = 165
integer y = 64
integer width = 87
integer height = 68
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

type em_descripcion from editmask within w_rh374_rpt_cabecera_planilla
integer x = 288
integer y = 72
integer width = 718
integer height = 60
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

type em_origen from editmask within w_rh374_rpt_cabecera_planilla
integer x = 50
integer y = 72
integer width = 96
integer height = 60
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

type em_desc_tipo from editmask within w_rh374_rpt_cabecera_planilla
integer x = 1413
integer y = 72
integer width = 667
integer height = 60
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

type em_tipo from editmask within w_rh374_rpt_cabecera_planilla
integer x = 1115
integer y = 72
integer width = 151
integer height = 60
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

type cb_2 from commandbutton within w_rh374_rpt_cabecera_planilla
integer x = 1285
integer y = 64
integer width = 87
integer height = 68
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

type cb_1 from commandbutton within w_rh374_rpt_cabecera_planilla
integer x = 3488
integer y = 64
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

event clicked;Parent.Event ue_preview()
Parent.Event ue_retrieve()
Parent.Event ue_preview()
end event

type st_1 from statictext within w_rh374_rpt_cabecera_planilla
integer x = 2208
integer y = 68
integer width = 169
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 79741120
string text = "Desde"
boolean focusrectangle = false
end type

type em_desde from editmask within w_rh374_rpt_cabecera_planilla
integer x = 2395
integer y = 72
integer width = 343
integer height = 64
integer taborder = 30
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
maskdatatype maskdatatype = stringmask!
string mask = "##########"
end type

type em_hasta from editmask within w_rh374_rpt_cabecera_planilla
integer x = 2971
integer y = 72
integer width = 343
integer height = 64
integer taborder = 40
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
maskdatatype maskdatatype = stringmask!
string mask = "##########"
end type

type st_2 from statictext within w_rh374_rpt_cabecera_planilla
integer x = 2784
integer y = 68
integer width = 169
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 79741120
string text = "Hasta"
boolean focusrectangle = false
end type

type gb_2 from groupbox within w_rh374_rpt_cabecera_planilla
integer width = 1056
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

type gb_3 from groupbox within w_rh374_rpt_cabecera_planilla
integer x = 1070
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

type gb_1 from groupbox within w_rh374_rpt_cabecera_planilla
integer x = 2135
integer width = 1257
integer height = 172
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = " Ingrese Numeración "
borderstyle borderstyle = stylebox!
end type

