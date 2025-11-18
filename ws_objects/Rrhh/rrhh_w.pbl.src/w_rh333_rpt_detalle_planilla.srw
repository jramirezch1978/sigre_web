$PBExportHeader$w_rh333_rpt_detalle_planilla.srw
forward
global type w_rh333_rpt_detalle_planilla from w_report_smpl
end type
type cb_3 from commandbutton within w_rh333_rpt_detalle_planilla
end type
type em_descripcion from editmask within w_rh333_rpt_detalle_planilla
end type
type em_origen from editmask within w_rh333_rpt_detalle_planilla
end type
type cb_1 from commandbutton within w_rh333_rpt_detalle_planilla
end type
type em_fec_proceso from editmask within w_rh333_rpt_detalle_planilla
end type
type st_1 from statictext within w_rh333_rpt_detalle_planilla
end type
type uo_1 from u_ddlb_tipo_trabajador within w_rh333_rpt_detalle_planilla
end type
type gb_2 from groupbox within w_rh333_rpt_detalle_planilla
end type
end forward

global type w_rh333_rpt_detalle_planilla from w_report_smpl
integer width = 3387
integer height = 1500
string title = "(RH333) Detalle de Planilla Calculada"
string menuname = "m_impresion"
cb_3 cb_3
em_descripcion em_descripcion
em_origen em_origen
cb_1 cb_1
em_fec_proceso em_fec_proceso
st_1 st_1
uo_1 uo_1
gb_2 gb_2
end type
global w_rh333_rpt_detalle_planilla w_rh333_rpt_detalle_planilla

on w_rh333_rpt_detalle_planilla.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.cb_3=create cb_3
this.em_descripcion=create em_descripcion
this.em_origen=create em_origen
this.cb_1=create cb_1
this.em_fec_proceso=create em_fec_proceso
this.st_1=create st_1
this.uo_1=create uo_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_3
this.Control[iCurrent+2]=this.em_descripcion
this.Control[iCurrent+3]=this.em_origen
this.Control[iCurrent+4]=this.cb_1
this.Control[iCurrent+5]=this.em_fec_proceso
this.Control[iCurrent+6]=this.st_1
this.Control[iCurrent+7]=this.uo_1
this.Control[iCurrent+8]=this.gb_2
end on

on w_rh333_rpt_detalle_planilla.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_3)
destroy(this.em_descripcion)
destroy(this.em_origen)
destroy(this.cb_1)
destroy(this.em_fec_proceso)
destroy(this.st_1)
destroy(this.uo_1)
destroy(this.gb_2)
end on

event ue_retrieve;call super::ue_retrieve;string ls_origen, ls_tipo_trabaj
date ld_fec_proceso

ls_origen = string(em_origen.text)
ld_fec_proceso = date(em_fec_proceso.text)

ls_tipo_trabaj = uo_1.of_get_value()
if isnull(ls_tipo_trabaj) or trim(ls_tipo_trabaj) = '' then ls_tipo_trabaj = '%'

DECLARE USP_RH_RPT_DET_PLLA_CALCULADA PROCEDURE FOR 
	USP_RH_RPT_DET_PLLA_CALCULADA( :ls_origen, 
											 :ls_tipo_trabaj, 
											 :ld_fec_proceso ) ;

EXECUTE USP_RH_RPT_DET_PLLA_CALCULADA ;

dw_report.retrieve()

close USP_RH_RPT_DET_PLLA_CALCULADA;

end event

event ue_open_pre;idw_1 = dw_report
idw_1.SetTransObject(sqlca)
idw_1.Visible = False

end event

type dw_report from w_report_smpl`dw_report within w_rh333_rpt_detalle_planilla
integer x = 0
integer y = 240
integer width = 3337
integer height = 972
integer taborder = 50
string dataobject = "d_det_plla_calculada_tbl"
end type

type cb_3 from commandbutton within w_rh333_rpt_detalle_planilla
integer x = 165
integer y = 84
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

type em_descripcion from editmask within w_rh333_rpt_detalle_planilla
integer x = 288
integer y = 92
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

type em_origen from editmask within w_rh333_rpt_detalle_planilla
integer x = 50
integer y = 92
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

type cb_1 from commandbutton within w_rh333_rpt_detalle_planilla
integer x = 2761
integer y = 60
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

event clicked;Parent.Event ue_retrieve()
end event

type em_fec_proceso from editmask within w_rh333_rpt_detalle_planilla
integer x = 2222
integer y = 112
integer width = 402
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

type st_1 from statictext within w_rh333_rpt_detalle_planilla
integer x = 2199
integer y = 36
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

type uo_1 from u_ddlb_tipo_trabajador within w_rh333_rpt_detalle_planilla
integer x = 1189
integer taborder = 20
boolean bringtotop = true
end type

on uo_1.destroy
call u_ddlb_tipo_trabajador::destroy
end on

type gb_2 from groupbox within w_rh333_rpt_detalle_planilla
integer y = 20
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

