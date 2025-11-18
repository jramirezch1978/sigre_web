$PBExportHeader$w_rh367_rpt_detalle_convenios.srw
forward
global type w_rh367_rpt_detalle_convenios from w_report_smpl
end type
type cb_3 from commandbutton within w_rh367_rpt_detalle_convenios
end type
type em_descripcion from editmask within w_rh367_rpt_detalle_convenios
end type
type em_origen from editmask within w_rh367_rpt_detalle_convenios
end type
type em_desc_tipo from editmask within w_rh367_rpt_detalle_convenios
end type
type em_tipo from editmask within w_rh367_rpt_detalle_convenios
end type
type cb_2 from commandbutton within w_rh367_rpt_detalle_convenios
end type
type cb_1 from commandbutton within w_rh367_rpt_detalle_convenios
end type
type em_fec_desde from editmask within w_rh367_rpt_detalle_convenios
end type
type em_fec_hasta from editmask within w_rh367_rpt_detalle_convenios
end type
type st_1 from statictext within w_rh367_rpt_detalle_convenios
end type
type st_3 from statictext within w_rh367_rpt_detalle_convenios
end type
type gb_1 from groupbox within w_rh367_rpt_detalle_convenios
end type
type gb_2 from groupbox within w_rh367_rpt_detalle_convenios
end type
type gb_3 from groupbox within w_rh367_rpt_detalle_convenios
end type
end forward

global type w_rh367_rpt_detalle_convenios from w_report_smpl
integer width = 4041
integer height = 1500
string title = "(RH367) Adelantos a Cuenta de C.T.S. - Convenios"
string menuname = "m_impresion"
cb_3 cb_3
em_descripcion em_descripcion
em_origen em_origen
em_desc_tipo em_desc_tipo
em_tipo em_tipo
cb_2 cb_2
cb_1 cb_1
em_fec_desde em_fec_desde
em_fec_hasta em_fec_hasta
st_1 st_1
st_3 st_3
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
end type
global w_rh367_rpt_detalle_convenios w_rh367_rpt_detalle_convenios

on w_rh367_rpt_detalle_convenios.create
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
this.em_fec_desde=create em_fec_desde
this.em_fec_hasta=create em_fec_hasta
this.st_1=create st_1
this.st_3=create st_3
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_3
this.Control[iCurrent+2]=this.em_descripcion
this.Control[iCurrent+3]=this.em_origen
this.Control[iCurrent+4]=this.em_desc_tipo
this.Control[iCurrent+5]=this.em_tipo
this.Control[iCurrent+6]=this.cb_2
this.Control[iCurrent+7]=this.cb_1
this.Control[iCurrent+8]=this.em_fec_desde
this.Control[iCurrent+9]=this.em_fec_hasta
this.Control[iCurrent+10]=this.st_1
this.Control[iCurrent+11]=this.st_3
this.Control[iCurrent+12]=this.gb_1
this.Control[iCurrent+13]=this.gb_2
this.Control[iCurrent+14]=this.gb_3
end on

on w_rh367_rpt_detalle_convenios.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_3)
destroy(this.em_descripcion)
destroy(this.em_origen)
destroy(this.em_desc_tipo)
destroy(this.em_tipo)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.em_fec_desde)
destroy(this.em_fec_hasta)
destroy(this.st_1)
destroy(this.st_3)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_3)
end on

event ue_retrieve;call super::ue_retrieve;string ls_origen, ls_tiptra, ls_descripcion
date ld_fec_desde, ld_fec_hasta

ls_origen = string(em_origen.text)
ls_tiptra = string(em_tipo.text)
ls_descripcion = string(em_desc_tipo.text)
ld_fec_desde = date(em_fec_desde.text)
ld_fec_hasta = date(em_fec_hasta.text)

if ld_fec_desde > ld_fec_hasta then
	MessageBox('Aviso','Corregir Rangos de Fechas')
	return
end if

DECLARE pb_usp_rh_rpt_adelanto_cuenta_cts PROCEDURE FOR USP_RH_RPT_ADELANTO_CUENTA_CTS
 	     ( :ls_tiptra, :ls_origen, :ld_fec_desde, :ld_fec_hasta ) ;
EXECUTE pb_usp_rh_rpt_adelanto_cuenta_cts ;

dw_report.retrieve()

dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_nombre.text = gs_empresa
dw_report.object.t_user.text = gs_user
dw_report.object.st_sit.text = ls_descripcion
dw_report.object.t_fec_desde.text = string(ld_fec_desde,'DD/MM/YYYY')
dw_report.object.t_fec_hasta.text = string(ld_fec_hasta,'DD/MM/YYYY')

end event

type dw_report from w_report_smpl`dw_report within w_rh367_rpt_detalle_convenios
integer x = 0
integer y = 188
integer width = 3328
integer height = 824
integer taborder = 60
string dataobject = "d_rpt_detalle_convenios_tbl"
end type

type cb_3 from commandbutton within w_rh367_rpt_detalle_convenios
integer x = 215
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

type em_descripcion from editmask within w_rh367_rpt_detalle_convenios
integer x = 325
integer y = 64
integer width = 759
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type em_origen from editmask within w_rh367_rpt_detalle_convenios
integer x = 69
integer y = 64
integer width = 123
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
alignment alignment = center!
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type em_desc_tipo from editmask within w_rh367_rpt_detalle_convenios
integer x = 1504
integer y = 64
integer width = 667
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type em_tipo from editmask within w_rh367_rpt_detalle_convenios
integer x = 1207
integer y = 64
integer width = 160
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
alignment alignment = center!
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type cb_2 from commandbutton within w_rh367_rpt_detalle_convenios
integer x = 1394
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

type cb_1 from commandbutton within w_rh367_rpt_detalle_convenios
integer x = 3515
integer y = 60
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

type em_fec_desde from editmask within w_rh367_rpt_detalle_convenios
integer x = 2478
integer y = 68
integer width = 343
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
string text = "none"
alignment alignment = center!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "dd/mm/yyyy"
end type

type em_fec_hasta from editmask within w_rh367_rpt_detalle_convenios
integer x = 3031
integer y = 68
integer width = 343
integer height = 76
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
string text = "none"
alignment alignment = center!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "dd/mm/yyyy"
end type

type st_1 from statictext within w_rh367_rpt_detalle_convenios
integer x = 2286
integer y = 68
integer width = 174
integer height = 68
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
string text = "Desde"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_3 from statictext within w_rh367_rpt_detalle_convenios
integer x = 2839
integer y = 72
integer width = 178
integer height = 68
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
string text = "Hasta"
alignment alignment = center!
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_rh367_rpt_detalle_convenios
integer x = 2240
integer width = 1198
integer height = 184
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = " Seleccione Rangos de Fechas "
end type

type gb_2 from groupbox within w_rh367_rpt_detalle_convenios
integer width = 1134
integer height = 176
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = " Seleccione Origen "
end type

type gb_3 from groupbox within w_rh367_rpt_detalle_convenios
integer x = 1147
integer width = 1083
integer height = 176
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = " Tipo de Trabajador "
end type

