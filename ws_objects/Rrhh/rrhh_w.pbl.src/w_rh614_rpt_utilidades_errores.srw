$PBExportHeader$w_rh614_rpt_utilidades_errores.srw
forward
global type w_rh614_rpt_utilidades_errores from w_report_smpl
end type
type cb_1 from commandbutton within w_rh614_rpt_utilidades_errores
end type
type em_periodo from editmask within w_rh614_rpt_utilidades_errores
end type
type st_1 from statictext within w_rh614_rpt_utilidades_errores
end type
type ddlb_tipo_trabaj from u_ddlb within w_rh614_rpt_utilidades_errores
end type
type ddlb_origen from u_ddlb within w_rh614_rpt_utilidades_errores
end type
type st_2 from statictext within w_rh614_rpt_utilidades_errores
end type
type st_3 from statictext within w_rh614_rpt_utilidades_errores
end type
type gb_1 from groupbox within w_rh614_rpt_utilidades_errores
end type
end forward

global type w_rh614_rpt_utilidades_errores from w_report_smpl
integer width = 3552
integer height = 2228
string title = "(RH614) Errores de Utilidades"
string menuname = "m_impresion"
cb_1 cb_1
em_periodo em_periodo
st_1 st_1
ddlb_tipo_trabaj ddlb_tipo_trabaj
ddlb_origen ddlb_origen
st_2 st_2
st_3 st_3
gb_1 gb_1
end type
global w_rh614_rpt_utilidades_errores w_rh614_rpt_utilidades_errores

on w_rh614_rpt_utilidades_errores.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.cb_1=create cb_1
this.em_periodo=create em_periodo
this.st_1=create st_1
this.ddlb_tipo_trabaj=create ddlb_tipo_trabaj
this.ddlb_origen=create ddlb_origen
this.st_2=create st_2
this.st_3=create st_3
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.em_periodo
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.ddlb_tipo_trabaj
this.Control[iCurrent+5]=this.ddlb_origen
this.Control[iCurrent+6]=this.st_2
this.Control[iCurrent+7]=this.st_3
this.Control[iCurrent+8]=this.gb_1
end on

on w_rh614_rpt_utilidades_errores.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.em_periodo)
destroy(this.st_1)
destroy(this.ddlb_tipo_trabaj)
destroy(this.ddlb_origen)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.gb_1)
end on

event ue_retrieve;call super::ue_retrieve;String  ls_periodo, ls_mensaje, ls_origen, ls_tipo_trabajador, ls_desc_origen, ls_desc_tipo_trabaj, ls_fecha
Long ll_pos
Date ld_fecha

ls_periodo = TRIM(em_periodo.text)
ls_origen = MID(ddlb_origen.text,1,2)
ls_desc_origen = MID(ddlb_origen.text,6,25)
ll_pos = POS(ls_desc_origen, '.')
ls_desc_origen = MID(ls_desc_origen, 1, ll_pos)

ls_tipo_trabajador = MID(ddlb_tipo_trabaj.text,1,3)
ls_desc_tipo_trabaj = MID(ddlb_tipo_trabaj.text,6,30)
ll_pos = POS(ls_desc_tipo_trabaj, '.')
ls_desc_tipo_trabaj = MID(ls_desc_tipo_trabaj, 1, ll_pos)

ld_fecha = DATE('31/12/'+trim(ls_periodo))

dw_report.retrieve(ls_periodo, ld_fecha, ls_origen, ls_tipo_trabajador)

dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_empresa.text = gs_empresa
dw_report.object.t_user.text = gs_user
dw_report.object.t_texto.text = 'Periodo ' + ls_periodo + ', ' + ls_desc_origen + ' - ' + ls_desc_tipo_trabaj
end event

type dw_report from w_report_smpl`dw_report within w_rh614_rpt_utilidades_errores
integer x = 0
integer y = 224
integer width = 3456
integer height = 1744
integer taborder = 30
string dataobject = "d_rpt_error_utilidades_tbl"
end type

type cb_1 from commandbutton within w_rh614_rpt_utilidades_errores
integer x = 3205
integer y = 96
integer width = 293
integer height = 84
integer taborder = 20
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

type em_periodo from editmask within w_rh614_rpt_utilidades_errores
integer x = 261
integer y = 100
integer width = 187
integer height = 76
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
alignment alignment = center!
borderstyle borderstyle = stylelowered!
string mask = "####"
end type

type st_1 from statictext within w_rh614_rpt_utilidades_errores
integer x = 27
integer y = 100
integer width = 224
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 16711680
long backcolor = 12632256
string text = "Período:"
boolean focusrectangle = false
end type

type ddlb_tipo_trabaj from u_ddlb within w_rh614_rpt_utilidades_errores
integer x = 2245
integer y = 92
integer width = 763
integer height = 376
integer taborder = 20
boolean bringtotop = true
integer limit = 4
string is_dataobject = "d_lista_tipo_trabaj_todos_tbl"
end type

event ue_open_pre;call super::ue_open_pre;is_dataobject = 'd_lista_tipo_trabaj_todos_tbl'

ii_cn1 = 1                    // Nro del campo 1
ii_cn2 = 2                    // Nro del campo 2
ii_ck  = 1                    // Nro del campo key
ii_lc1 = 5							// Longitud del campo 1
ii_lc2 = 30							// Longitud del campo 2

end event

type ddlb_origen from u_ddlb within w_rh614_rpt_utilidades_errores
integer x = 878
integer y = 100
integer width = 663
integer height = 412
integer taborder = 20
boolean bringtotop = true
integer limit = 4
string is_dataobject = "d_lista_origen_todos_tbl"
end type

event ue_open_pre;call super::ue_open_pre;is_dataobject = 'd_lista_origen_todos_tbl'

ii_cn1 = 1                    // Nro del campo 1
ii_cn2 = 2                    // Nro del campo 2
ii_ck  = 1                    // Nro del campo key
ii_lc1 = 5							// Longitud del campo 1
ii_lc2 = 20							// Longitud del campo 2

end event

type st_2 from statictext within w_rh614_rpt_utilidades_errores
integer x = 681
integer y = 108
integer width = 178
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 134217730
long backcolor = 12632256
string text = "Origen:"
boolean focusrectangle = false
end type

type st_3 from statictext within w_rh614_rpt_utilidades_errores
integer x = 1847
integer y = 108
integer width = 379
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 134217730
long backcolor = 12632256
string text = "Tipo Trabajador:"
alignment alignment = center!
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_rh614_rpt_utilidades_errores
integer y = 12
integer width = 3040
integer height = 200
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Parámetros"
end type

