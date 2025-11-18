$PBExportHeader$w_rh376_rpt_ganancias_descuentos_fijos.srw
forward
global type w_rh376_rpt_ganancias_descuentos_fijos from w_report_smpl
end type
type cb_3 from commandbutton within w_rh376_rpt_ganancias_descuentos_fijos
end type
type em_descripcion from editmask within w_rh376_rpt_ganancias_descuentos_fijos
end type
type em_origen from editmask within w_rh376_rpt_ganancias_descuentos_fijos
end type
type cb_1 from commandbutton within w_rh376_rpt_ganancias_descuentos_fijos
end type
type uo_1 from u_ddlb_tipo_trabajador within w_rh376_rpt_ganancias_descuentos_fijos
end type
type gb_2 from groupbox within w_rh376_rpt_ganancias_descuentos_fijos
end type
end forward

global type w_rh376_rpt_ganancias_descuentos_fijos from w_report_smpl
integer width = 3387
integer height = 1500
string title = "(RH376) Ganancias y Descuentos Fijos - Todos los Trabajadores"
string menuname = "m_impresion"
cb_3 cb_3
em_descripcion em_descripcion
em_origen em_origen
cb_1 cb_1
uo_1 uo_1
gb_2 gb_2
end type
global w_rh376_rpt_ganancias_descuentos_fijos w_rh376_rpt_ganancias_descuentos_fijos

on w_rh376_rpt_ganancias_descuentos_fijos.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.cb_3=create cb_3
this.em_descripcion=create em_descripcion
this.em_origen=create em_origen
this.cb_1=create cb_1
this.uo_1=create uo_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_3
this.Control[iCurrent+2]=this.em_descripcion
this.Control[iCurrent+3]=this.em_origen
this.Control[iCurrent+4]=this.cb_1
this.Control[iCurrent+5]=this.uo_1
this.Control[iCurrent+6]=this.gb_2
end on

on w_rh376_rpt_ganancias_descuentos_fijos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_3)
destroy(this.em_descripcion)
destroy(this.em_origen)
destroy(this.cb_1)
destroy(this.uo_1)
destroy(this.gb_2)
end on

event ue_retrieve;call super::ue_retrieve;string ls_origen, ls_tipo_trabaj

ls_origen = string(em_origen.text)

ls_tipo_trabaj = uo_1.of_Get_value()

if isnull(ls_tipo_trabaj) or trim(ls_tipo_trabaj) = '' then ls_tipo_trabaj = '%'

DECLARE USP_RH_RPT_GANDES_FIJOS PROCEDURE FOR 
	USP_RH_RPT_GANDES_FIJOS( :ls_tipo_trabaj, 
									 :ls_origen ) ;

EXECUTE USP_RH_RPT_GANDES_FIJOS ;

if gnvo_app.of_existsError(SQLCA) then
	rollback;
	return
end if

CLOSE USP_RH_RPT_GANDES_FIJOS;

dw_report.retrieve()

end event

event ue_open_pre;idw_1 = dw_report
idw_1.SetTransObject(sqlca)
idw_1.Visible = False

end event

type dw_report from w_report_smpl`dw_report within w_rh376_rpt_ganancias_descuentos_fijos
integer x = 0
integer y = 228
integer width = 3328
integer height = 1088
integer taborder = 60
string dataobject = "d_rpt_ganancia_descuento_fijo_crt"
end type

type cb_3 from commandbutton within w_rh376_rpt_ganancias_descuentos_fijos
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

type em_descripcion from editmask within w_rh376_rpt_ganancias_descuentos_fijos
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

type em_origen from editmask within w_rh376_rpt_ganancias_descuentos_fijos
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

type cb_1 from commandbutton within w_rh376_rpt_ganancias_descuentos_fijos
integer x = 2062
integer y = 52
integer width = 361
integer height = 100
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

type uo_1 from u_ddlb_tipo_trabajador within w_rh376_rpt_ganancias_descuentos_fijos
integer x = 1111
integer width = 891
integer height = 216
integer taborder = 30
boolean bringtotop = true
end type

on uo_1.destroy
call u_ddlb_tipo_trabajador::destroy
end on

type gb_2 from groupbox within w_rh376_rpt_ganancias_descuentos_fijos
integer width = 1097
integer height = 216
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = " Seleccione Origen "
end type

