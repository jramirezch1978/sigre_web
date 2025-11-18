$PBExportHeader$w_rh378_rpt_padron_trabajadores.srw
forward
global type w_rh378_rpt_padron_trabajadores from w_report_smpl
end type
type cb_3 from commandbutton within w_rh378_rpt_padron_trabajadores
end type
type em_descripcion from editmask within w_rh378_rpt_padron_trabajadores
end type
type em_origen from editmask within w_rh378_rpt_padron_trabajadores
end type
type em_desc_tipo from editmask within w_rh378_rpt_padron_trabajadores
end type
type em_tipo from editmask within w_rh378_rpt_padron_trabajadores
end type
type cb_2 from commandbutton within w_rh378_rpt_padron_trabajadores
end type
type cb_1 from commandbutton within w_rh378_rpt_padron_trabajadores
end type
type st_1 from statictext within w_rh378_rpt_padron_trabajadores
end type
type st_2 from statictext within w_rh378_rpt_padron_trabajadores
end type
type em_titulo from editmask within w_rh378_rpt_padron_trabajadores
end type
type em_glosa from editmask within w_rh378_rpt_padron_trabajadores
end type
type gb_2 from groupbox within w_rh378_rpt_padron_trabajadores
end type
type gb_3 from groupbox within w_rh378_rpt_padron_trabajadores
end type
end forward

global type w_rh378_rpt_padron_trabajadores from w_report_smpl
integer width = 3387
integer height = 1500
string title = "(RH378) Padrón de Trabajadores por Ventas de Productos"
string menuname = "m_impresion"
long backcolor = 12632256
cb_3 cb_3
em_descripcion em_descripcion
em_origen em_origen
em_desc_tipo em_desc_tipo
em_tipo em_tipo
cb_2 cb_2
cb_1 cb_1
st_1 st_1
st_2 st_2
em_titulo em_titulo
em_glosa em_glosa
gb_2 gb_2
gb_3 gb_3
end type
global w_rh378_rpt_padron_trabajadores w_rh378_rpt_padron_trabajadores

on w_rh378_rpt_padron_trabajadores.create
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
this.st_2=create st_2
this.em_titulo=create em_titulo
this.em_glosa=create em_glosa
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
this.Control[iCurrent+8]=this.st_1
this.Control[iCurrent+9]=this.st_2
this.Control[iCurrent+10]=this.em_titulo
this.Control[iCurrent+11]=this.em_glosa
this.Control[iCurrent+12]=this.gb_2
this.Control[iCurrent+13]=this.gb_3
end on

on w_rh378_rpt_padron_trabajadores.destroy
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
destroy(this.st_2)
destroy(this.em_titulo)
destroy(this.em_glosa)
destroy(this.gb_2)
destroy(this.gb_3)
end on

event ue_retrieve;call super::ue_retrieve;string ls_origen, ls_tiptra, ls_descripcion, ls_titulo, ls_glosa

ls_origen = string(em_origen.text)
ls_tiptra = string(em_tipo.text)
ls_descripcion = string(em_desc_tipo.text)
ls_titulo = string(em_titulo.text)
ls_glosa = string(em_glosa.text)

dw_report.retrieve (ls_tiptra,ls_origen)

dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_nombre.text = gs_empresa
dw_report.object.t_user.text = gs_user
dw_report.object.st_tipo.text = ls_descripcion
dw_report.object.t_titulo.text = ls_titulo
dw_report.object.t_glosa.text = ls_glosa

end event

type dw_report from w_report_smpl`dw_report within w_rh378_rpt_padron_trabajadores
integer x = 14
integer y = 484
integer width = 3328
integer height = 828
integer taborder = 60
string dataobject = "d_rpt_padron_trabajadores_tbl"
end type

type cb_3 from commandbutton within w_rh378_rpt_padron_trabajadores
integer x = 686
integer y = 116
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

type em_descripcion from editmask within w_rh378_rpt_padron_trabajadores
integer x = 809
integer y = 124
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

type em_origen from editmask within w_rh378_rpt_padron_trabajadores
integer x = 571
integer y = 124
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

type em_desc_tipo from editmask within w_rh378_rpt_padron_trabajadores
integer x = 2039
integer y = 124
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

type em_tipo from editmask within w_rh378_rpt_padron_trabajadores
integer x = 1742
integer y = 124
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

type cb_2 from commandbutton within w_rh378_rpt_padron_trabajadores
integer x = 1911
integer y = 116
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

type cb_1 from commandbutton within w_rh378_rpt_padron_trabajadores
integer x = 2825
integer y = 296
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

type st_1 from statictext within w_rh378_rpt_padron_trabajadores
integer x = 713
integer y = 284
integer width = 160
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
string text = "Título"
boolean focusrectangle = false
end type

type st_2 from statictext within w_rh378_rpt_padron_trabajadores
integer x = 713
integer y = 376
integer width = 160
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
string text = "Glosa"
boolean focusrectangle = false
end type

type em_titulo from editmask within w_rh378_rpt_padron_trabajadores
integer x = 882
integer y = 272
integer width = 1669
integer height = 68
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
maskdatatype maskdatatype = stringmask!
string mask = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
end type

type em_glosa from editmask within w_rh378_rpt_padron_trabajadores
integer x = 882
integer y = 364
integer width = 1669
integer height = 68
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
maskdatatype maskdatatype = stringmask!
string mask = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
end type

type gb_2 from groupbox within w_rh378_rpt_padron_trabajadores
integer x = 521
integer y = 52
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

type gb_3 from groupbox within w_rh378_rpt_padron_trabajadores
integer x = 1696
integer y = 52
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

