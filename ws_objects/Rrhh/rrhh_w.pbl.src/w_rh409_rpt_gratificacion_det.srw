$PBExportHeader$w_rh409_rpt_gratificacion_det.srw
forward
global type w_rh409_rpt_gratificacion_det from w_report_smpl
end type
type cb_3 from commandbutton within w_rh409_rpt_gratificacion_det
end type
type em_descripcion from editmask within w_rh409_rpt_gratificacion_det
end type
type em_origen from editmask within w_rh409_rpt_gratificacion_det
end type
type em_desc_tipo from editmask within w_rh409_rpt_gratificacion_det
end type
type em_tipo from editmask within w_rh409_rpt_gratificacion_det
end type
type cb_2 from commandbutton within w_rh409_rpt_gratificacion_det
end type
type cb_1 from commandbutton within w_rh409_rpt_gratificacion_det
end type
type st_2 from statictext within w_rh409_rpt_gratificacion_det
end type
type st_1 from statictext within w_rh409_rpt_gratificacion_det
end type
type ddlb_mes from dropdownlistbox within w_rh409_rpt_gratificacion_det
end type
type em_year from editmask within w_rh409_rpt_gratificacion_det
end type
type st_3 from statictext within w_rh409_rpt_gratificacion_det
end type
type gb_2 from groupbox within w_rh409_rpt_gratificacion_det
end type
end forward

global type w_rh409_rpt_gratificacion_det from w_report_smpl
integer width = 3387
integer height = 1500
string title = "(RH409) Detalle de Gratificacion"
string menuname = "m_impresion"
cb_3 cb_3
em_descripcion em_descripcion
em_origen em_origen
em_desc_tipo em_desc_tipo
em_tipo em_tipo
cb_2 cb_2
cb_1 cb_1
st_2 st_2
st_1 st_1
ddlb_mes ddlb_mes
em_year em_year
st_3 st_3
gb_2 gb_2
end type
global w_rh409_rpt_gratificacion_det w_rh409_rpt_gratificacion_det

on w_rh409_rpt_gratificacion_det.create
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
this.st_2=create st_2
this.st_1=create st_1
this.ddlb_mes=create ddlb_mes
this.em_year=create em_year
this.st_3=create st_3
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_3
this.Control[iCurrent+2]=this.em_descripcion
this.Control[iCurrent+3]=this.em_origen
this.Control[iCurrent+4]=this.em_desc_tipo
this.Control[iCurrent+5]=this.em_tipo
this.Control[iCurrent+6]=this.cb_2
this.Control[iCurrent+7]=this.cb_1
this.Control[iCurrent+8]=this.st_2
this.Control[iCurrent+9]=this.st_1
this.Control[iCurrent+10]=this.ddlb_mes
this.Control[iCurrent+11]=this.em_year
this.Control[iCurrent+12]=this.st_3
this.Control[iCurrent+13]=this.gb_2
end on

on w_rh409_rpt_gratificacion_det.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_3)
destroy(this.em_descripcion)
destroy(this.em_origen)
destroy(this.em_desc_tipo)
destroy(this.em_tipo)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.ddlb_mes)
destroy(this.em_year)
destroy(this.st_3)
destroy(this.gb_2)
end on

event ue_retrieve;call super::ue_retrieve;String		ls_origen, ls_tiptra,  ls_year
Date	 	ld_fec_proceso

if trim(em_year.text) = '' then
	MessageBox('Error', 'Debe indicar el año de la gratificacion para el proceso', StopSign!)
	em_year.setFocus()
	return
end if

ls_origen 		= trim(em_origen.text) + '%'
ls_tiptra 		= trim(em_tipo.text) + '%'
ls_year 			= em_year.text
	
if left(ddlb_mes.text, 2) = '07' then
	ld_fec_proceso = date('15/07/' + ls_year)
else
	ld_fec_proceso = date('15/12/' + ls_year)
end if

dw_report.retrieve (ls_origen, ls_tiptra, ld_fec_proceso)



end event

event ue_open_pre;//Override
Date 	ld_hoy

idw_1 = dw_report
idw_1.SetTransObject(sqlca)

ld_hoy = Date(gnvo_app.of_fecha_actual())

em_year.text = string(ld_hoy, 'yyyy')
ddlb_mes.SelectItem(1)
end event

type dw_report from w_report_smpl`dw_report within w_rh409_rpt_gratificacion_det
integer x = 0
integer y = 324
integer width = 3328
integer height = 856
integer taborder = 60
string dataobject = "d_rpt_gratificacion_det_crt"
end type

event dw_report::rowfocuschanged;call super::rowfocuschanged;gnvo_app.of_select_current_row( this )
end event

type cb_3 from commandbutton within w_rh409_rpt_gratificacion_det
integer x = 613
integer y = 156
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

type em_descripcion from editmask within w_rh409_rpt_gratificacion_det
integer x = 718
integer y = 160
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

type em_origen from editmask within w_rh409_rpt_gratificacion_det
integer x = 430
integer y = 164
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

type em_desc_tipo from editmask within w_rh409_rpt_gratificacion_det
integer x = 718
integer y = 232
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

type em_tipo from editmask within w_rh409_rpt_gratificacion_det
integer x = 430
integer y = 232
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

type cb_2 from commandbutton within w_rh409_rpt_gratificacion_det
integer x = 613
integer y = 224
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

type cb_1 from commandbutton within w_rh409_rpt_gratificacion_det
integer x = 1545
integer y = 76
integer width = 366
integer height = 184
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Generar"
end type

event clicked;Parent.Event ue_retrieve()
end event

type st_2 from statictext within w_rh409_rpt_gratificacion_det
integer x = 37
integer y = 224
integer width = 375
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 79741120
string text = "T.Trabajador :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_1 from statictext within w_rh409_rpt_gratificacion_det
integer x = 55
integer y = 160
integer width = 343
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 79741120
string text = "Origen :"
alignment alignment = right!
boolean focusrectangle = false
end type

type ddlb_mes from dropdownlistbox within w_rh409_rpt_gratificacion_det
integer x = 430
integer y = 60
integer width = 567
integer height = 352
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
string item[] = {"07. Julio","12. Diciembre"}
borderstyle borderstyle = stylelowered!
end type

type em_year from editmask within w_rh409_rpt_gratificacion_det
integer x = 1010
integer y = 60
integer width = 279
integer height = 92
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
string mask = "###0"
boolean spin = true
double increment = 1
string minmax = "0~~9999"
end type

type st_3 from statictext within w_rh409_rpt_gratificacion_det
integer x = 64
integer y = 76
integer width = 343
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
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

type gb_2 from groupbox within w_rh409_rpt_gratificacion_det
integer width = 1993
integer height = 316
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = " Seleccione Datos"
end type

