$PBExportHeader$w_rh335_rpt_emision_planilla.srw
forward
global type w_rh335_rpt_emision_planilla from w_report_smpl
end type
type cb_3 from commandbutton within w_rh335_rpt_emision_planilla
end type
type em_descripcion from editmask within w_rh335_rpt_emision_planilla
end type
type em_origen from editmask within w_rh335_rpt_emision_planilla
end type
type em_desc_tipo from editmask within w_rh335_rpt_emision_planilla
end type
type em_tipo from editmask within w_rh335_rpt_emision_planilla
end type
type cb_2 from commandbutton within w_rh335_rpt_emision_planilla
end type
type cb_1 from commandbutton within w_rh335_rpt_emision_planilla
end type
type em_fecha from editmask within w_rh335_rpt_emision_planilla
end type
type st_1 from statictext within w_rh335_rpt_emision_planilla
end type
type gb_2 from groupbox within w_rh335_rpt_emision_planilla
end type
type gb_3 from groupbox within w_rh335_rpt_emision_planilla
end type
end forward

global type w_rh335_rpt_emision_planilla from w_report_smpl
integer width = 3387
integer height = 1500
string title = "[RH335] Emisión de Planillas"
string menuname = "m_impresion"
cb_3 cb_3
em_descripcion em_descripcion
em_origen em_origen
em_desc_tipo em_desc_tipo
em_tipo em_tipo
cb_2 cb_2
cb_1 cb_1
em_fecha em_fecha
st_1 st_1
gb_2 gb_2
gb_3 gb_3
end type
global w_rh335_rpt_emision_planilla w_rh335_rpt_emision_planilla

on w_rh335_rpt_emision_planilla.create
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
this.em_fecha=create em_fecha
this.st_1=create st_1
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
this.Control[iCurrent+8]=this.em_fecha
this.Control[iCurrent+9]=this.st_1
this.Control[iCurrent+10]=this.gb_2
this.Control[iCurrent+11]=this.gb_3
end on

on w_rh335_rpt_emision_planilla.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_3)
destroy(this.em_descripcion)
destroy(this.em_origen)
destroy(this.em_desc_tipo)
destroy(this.em_tipo)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.em_fecha)
destroy(this.st_1)
destroy(this.gb_2)
destroy(this.gb_3)
end on

event ue_retrieve;call super::ue_retrieve;string ls_origen, ls_tiptra
date ld_fecha

ls_origen = string(em_origen.text)
ls_tiptra = string(em_tipo.text)
ld_fecha = date(em_fecha.text)

if ls_origen = 'PR' then

  DECLARE pb_usp_rh_rpt_planilla_aipsa PROCEDURE FOR USP_RH_RPT_PLANILLA_AIPSA
          ( :ls_tiptra, :ls_origen, :ld_fecha ) ;
  EXECUTE pb_usp_rh_rpt_planilla_aipsa ;
  dw_report.DataObject='d_rpt_planilla_aipsa_tbl'
  dw_report.SetTransObject(sqlca)
  dw_report.retrieve()

elseif ls_origen = 'IN' then

  DECLARE pb_usp_rh_rpt_planilla_ingenio PROCEDURE FOR USP_RH_RPT_PLANILLA_INGENIO
          ( :ls_tiptra, :ls_origen, :ld_fecha ) ;
  EXECUTE pb_usp_rh_rpt_planilla_ingenio ;
  dw_report.DataObject='d_rpt_planilla_ingenio_tbl'
  dw_report.SetTransObject(sqlca)
  dw_report.retrieve()

end if
end event

type dw_report from w_report_smpl`dw_report within w_rh335_rpt_emision_planilla
integer x = 0
integer y = 192
integer width = 3328
integer height = 1024
integer taborder = 50
end type

type cb_3 from commandbutton within w_rh335_rpt_emision_planilla
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

type em_descripcion from editmask within w_rh335_rpt_emision_planilla
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

type em_origen from editmask within w_rh335_rpt_emision_planilla
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

type em_desc_tipo from editmask within w_rh335_rpt_emision_planilla
integer x = 1495
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

type em_tipo from editmask within w_rh335_rpt_emision_planilla
integer x = 1198
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

type cb_2 from commandbutton within w_rh335_rpt_emision_planilla
integer x = 1367
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

type cb_1 from commandbutton within w_rh335_rpt_emision_planilla
integer x = 2757
integer y = 56
integer width = 293
integer height = 76
integer taborder = 40
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

type em_fecha from editmask within w_rh335_rpt_emision_planilla
integer x = 2327
integer y = 96
integer width = 315
integer height = 72
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 12632256
boolean border = false
alignment alignment = center!
maskdatatype maskdatatype = datemask!
string mask = "dd/mm/yyyy"
end type

type st_1 from statictext within w_rh335_rpt_emision_planilla
integer x = 2272
integer y = 24
integer width = 425
integer height = 72
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
boolean focusrectangle = false
end type

type gb_2 from groupbox within w_rh335_rpt_emision_planilla
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

type gb_3 from groupbox within w_rh335_rpt_emision_planilla
integer x = 1152
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

