$PBExportHeader$w_rh350_rpt_deposito_cts_semestral.srw
forward
global type w_rh350_rpt_deposito_cts_semestral from w_report_smpl
end type
type cb_3 from commandbutton within w_rh350_rpt_deposito_cts_semestral
end type
type em_descripcion from editmask within w_rh350_rpt_deposito_cts_semestral
end type
type em_origen from editmask within w_rh350_rpt_deposito_cts_semestral
end type
type em_desc_tipo from editmask within w_rh350_rpt_deposito_cts_semestral
end type
type em_tipo from editmask within w_rh350_rpt_deposito_cts_semestral
end type
type cb_2 from commandbutton within w_rh350_rpt_deposito_cts_semestral
end type
type cb_1 from commandbutton within w_rh350_rpt_deposito_cts_semestral
end type
type em_fecha from editmask within w_rh350_rpt_deposito_cts_semestral
end type
type st_1 from statictext within w_rh350_rpt_deposito_cts_semestral
end type
type gb_2 from groupbox within w_rh350_rpt_deposito_cts_semestral
end type
type gb_3 from groupbox within w_rh350_rpt_deposito_cts_semestral
end type
end forward

global type w_rh350_rpt_deposito_cts_semestral from w_report_smpl
integer width = 3429
integer height = 2056
string title = "(RH350) Depósitos de C.T.S. Semestrales"
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
global w_rh350_rpt_deposito_cts_semestral w_rh350_rpt_deposito_cts_semestral

on w_rh350_rpt_deposito_cts_semestral.create
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

on w_rh350_rpt_deposito_cts_semestral.destroy
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

event ue_retrieve;call super::ue_retrieve;string ls_origen, ls_tiptra, ls_descripcion
date ld_fecha

ls_origen = string(em_origen.text)
ld_fecha = date(em_fecha.text)
ls_tiptra = string(em_tipo.text)
ls_descripcion = 'Período ' + string(em_fecha.text) + ' - ' + TRIM(string(em_descripcion.text)) + ' - ' + TRIM(string(em_desc_tipo.text))

DECLARE pb_usp_rh_rpt_deposito_cts_sem PROCEDURE FOR USP_RH_RPT_DEPOSITO_CTS_SEM
        ( :ls_tiptra, :ld_fecha, :ls_origen ) ;
EXECUTE pb_usp_rh_rpt_deposito_cts_sem ;

dw_report.retrieve(ld_fecha, ls_origen, ls_tiptra)

dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_empresa.text = gs_empresa
dw_report.object.t_user.text = gs_user
dw_report.object.t_texto.text = ls_descripcion



end event

type dw_report from w_report_smpl`dw_report within w_rh350_rpt_deposito_cts_semestral
integer x = 0
integer y = 192
integer width = 3369
integer height = 1532
integer taborder = 50
string dataobject = "d_rpt_deposito_cts"
end type

type cb_3 from commandbutton within w_rh350_rpt_deposito_cts_semestral
integer x = 174
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

type em_descripcion from editmask within w_rh350_rpt_deposito_cts_semestral
integer x = 288
integer y = 64
integer width = 718
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

type em_origen from editmask within w_rh350_rpt_deposito_cts_semestral
integer x = 50
integer y = 64
integer width = 96
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

type em_desc_tipo from editmask within w_rh350_rpt_deposito_cts_semestral
integer x = 1454
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

type em_tipo from editmask within w_rh350_rpt_deposito_cts_semestral
integer x = 1157
integer y = 64
integer width = 151
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

type cb_2 from commandbutton within w_rh350_rpt_deposito_cts_semestral
integer x = 1335
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

type cb_1 from commandbutton within w_rh350_rpt_deposito_cts_semestral
integer x = 2766
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

type em_fecha from editmask within w_rh350_rpt_deposito_cts_semestral
integer x = 2281
integer y = 80
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
long textcolor = 33554432
long backcolor = 16777215
alignment alignment = center!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "dd/mm/yyyy"
end type

type st_1 from statictext within w_rh350_rpt_deposito_cts_semestral
integer x = 2231
integer y = 8
integer width = 439
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
string text = "Fecha de Proceso"
alignment alignment = center!
boolean focusrectangle = false
end type

type gb_2 from groupbox within w_rh350_rpt_deposito_cts_semestral
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

type gb_3 from groupbox within w_rh350_rpt_deposito_cts_semestral
integer x = 1111
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

