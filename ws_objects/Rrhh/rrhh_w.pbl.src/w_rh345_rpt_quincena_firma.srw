$PBExportHeader$w_rh345_rpt_quincena_firma.srw
forward
global type w_rh345_rpt_quincena_firma from w_report_smpl
end type
type cb_3 from commandbutton within w_rh345_rpt_quincena_firma
end type
type em_descripcion from editmask within w_rh345_rpt_quincena_firma
end type
type em_origen from editmask within w_rh345_rpt_quincena_firma
end type
type em_desc_tipo from editmask within w_rh345_rpt_quincena_firma
end type
type em_tipo from editmask within w_rh345_rpt_quincena_firma
end type
type cb_2 from commandbutton within w_rh345_rpt_quincena_firma
end type
type cb_1 from commandbutton within w_rh345_rpt_quincena_firma
end type
type st_3 from statictext within w_rh345_rpt_quincena_firma
end type
type sle_year from singlelineedit within w_rh345_rpt_quincena_firma
end type
type sle_mes from singlelineedit within w_rh345_rpt_quincena_firma
end type
type gb_2 from groupbox within w_rh345_rpt_quincena_firma
end type
type gb_3 from groupbox within w_rh345_rpt_quincena_firma
end type
end forward

global type w_rh345_rpt_quincena_firma from w_report_smpl
integer width = 3392
integer height = 1500
string title = "[RH345] Reporte de quincena para firmar"
string menuname = "m_impresion"
cb_3 cb_3
em_descripcion em_descripcion
em_origen em_origen
em_desc_tipo em_desc_tipo
em_tipo em_tipo
cb_2 cb_2
cb_1 cb_1
st_3 st_3
sle_year sle_year
sle_mes sle_mes
gb_2 gb_2
gb_3 gb_3
end type
global w_rh345_rpt_quincena_firma w_rh345_rpt_quincena_firma

on w_rh345_rpt_quincena_firma.create
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
this.st_3=create st_3
this.sle_year=create sle_year
this.sle_mes=create sle_mes
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
this.Control[iCurrent+8]=this.st_3
this.Control[iCurrent+9]=this.sle_year
this.Control[iCurrent+10]=this.sle_mes
this.Control[iCurrent+11]=this.gb_2
this.Control[iCurrent+12]=this.gb_3
end on

on w_rh345_rpt_quincena_firma.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_3)
destroy(this.em_descripcion)
destroy(this.em_origen)
destroy(this.em_desc_tipo)
destroy(this.em_tipo)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.st_3)
destroy(this.sle_year)
destroy(this.sle_mes)
destroy(this.gb_2)
destroy(this.gb_3)
end on

event ue_retrieve;call super::ue_retrieve;string 	ls_origen, ls_tiptra, ls_descripcion
Integer	li_year, li_mes

ls_origen 		= string(em_origen.text)
ls_tiptra 		= string(em_tipo.text)
ls_descripcion = string(em_desc_tipo.text)
li_year			= Integer(sle_year.text)
li_mes			= Integer(sle_mes.text)

dw_report.retrieve (ls_tiptra,ls_origen, li_year, li_mes)

dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_nombre.text = gs_empresa
dw_report.object.t_user.text = gs_user
dw_report.object.st_sit.text = ls_descripcion
dw_report.object.t_fec_proceso.text = string(li_year, '0000') + '-' + string(li_mes, '00')


end event

event ue_open_pre;call super::ue_open_pre;Date	ld_hoy

ld_hoy = Date(gnvo_app.of_fecha_actual())

sle_year.text = string(ld_hoy, 'yyyy')
sle_mes.text = string(ld_hoy, 'mm')
end event

type dw_report from w_report_smpl`dw_report within w_rh345_rpt_quincena_firma
integer x = 0
integer y = 188
integer width = 3328
integer height = 856
integer taborder = 60
string dataobject = "d_rpt_QUINCENA_FIRMA_TBL"
end type

type cb_3 from commandbutton within w_rh345_rpt_quincena_firma
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

type em_descripcion from editmask within w_rh345_rpt_quincena_firma
integer x = 288
integer y = 72
integer width = 759
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

type em_origen from editmask within w_rh345_rpt_quincena_firma
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

type em_desc_tipo from editmask within w_rh345_rpt_quincena_firma
integer x = 1467
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

type em_tipo from editmask within w_rh345_rpt_quincena_firma
integer x = 1170
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

type cb_2 from commandbutton within w_rh345_rpt_quincena_firma
integer x = 1339
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

type cb_1 from commandbutton within w_rh345_rpt_quincena_firma
integer x = 2903
integer y = 56
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

type st_3 from statictext within w_rh345_rpt_quincena_firma
integer x = 2199
integer y = 60
integer width = 251
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 79741120
string text = "Periodo :"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_year from singlelineedit within w_rh345_rpt_quincena_firma
integer x = 2459
integer y = 56
integer width = 229
integer height = 76
integer taborder = 20
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

type sle_mes from singlelineedit within w_rh345_rpt_quincena_firma
integer x = 2706
integer y = 56
integer width = 155
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

type gb_2 from groupbox within w_rh345_rpt_quincena_firma
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

type gb_3 from groupbox within w_rh345_rpt_quincena_firma
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

