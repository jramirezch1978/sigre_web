$PBExportHeader$w_rh602_rpt_liquidacion_cnta_crrte.srw
forward
global type w_rh602_rpt_liquidacion_cnta_crrte from w_report_smpl
end type
type cb_1 from commandbutton within w_rh602_rpt_liquidacion_cnta_crrte
end type
type em_nombres from editmask within w_rh602_rpt_liquidacion_cnta_crrte
end type
type em_codigo from editmask within w_rh602_rpt_liquidacion_cnta_crrte
end type
type cb_2 from commandbutton within w_rh602_rpt_liquidacion_cnta_crrte
end type
type gb_2 from groupbox within w_rh602_rpt_liquidacion_cnta_crrte
end type
end forward

global type w_rh602_rpt_liquidacion_cnta_crrte from w_report_smpl
integer width = 3589
integer height = 1696
string title = "(RH602) Cuenta Corriente de Liquidaciones"
string menuname = "m_impresion"
cb_1 cb_1
em_nombres em_nombres
em_codigo em_codigo
cb_2 cb_2
gb_2 gb_2
end type
global w_rh602_rpt_liquidacion_cnta_crrte w_rh602_rpt_liquidacion_cnta_crrte

on w_rh602_rpt_liquidacion_cnta_crrte.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.cb_1=create cb_1
this.em_nombres=create em_nombres
this.em_codigo=create em_codigo
this.cb_2=create cb_2
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.em_nombres
this.Control[iCurrent+3]=this.em_codigo
this.Control[iCurrent+4]=this.cb_2
this.Control[iCurrent+5]=this.gb_2
end on

on w_rh602_rpt_liquidacion_cnta_crrte.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.em_nombres)
destroy(this.em_codigo)
destroy(this.cb_2)
destroy(this.gb_2)
end on

event ue_retrieve;call super::ue_retrieve;string ls_codigo, ls_nombres, ls_mensaje

ls_codigo    = string(em_codigo.text)
ls_nombres   = string(em_nombres.text)

if isnull(ls_codigo) or trim(ls_codigo) = '' then ls_codigo = '%'

dw_report.retrieve(ls_codigo)

dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_nombre.text = gs_empresa
dw_report.object.t_user.text = gs_user

IF SQLCA.SQLCode = -1 THEN 
  ls_mensaje = SQLCA.SQLErrText
  rollback ;
  MessageBox("SQL error", ls_mensaje)
  MessageBox('Atención','Proceso de reporte de liquidación, Falló', Exclamation! )
END IF

end event

type dw_report from w_report_smpl`dw_report within w_rh602_rpt_liquidacion_cnta_crrte
integer x = 0
integer y = 216
integer width = 3511
integer height = 1184
integer taborder = 30
string dataobject = "d_liq_rpt_cnta_crrte_tbl"
end type

type cb_1 from commandbutton within w_rh602_rpt_liquidacion_cnta_crrte
integer x = 1829
integer y = 76
integer width = 293
integer height = 76
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

type em_nombres from editmask within w_rh602_rpt_liquidacion_cnta_crrte
integer x = 530
integer y = 76
integer width = 1143
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

type em_codigo from editmask within w_rh602_rpt_liquidacion_cnta_crrte
integer x = 59
integer y = 76
integer width = 315
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

type cb_2 from commandbutton within w_rh602_rpt_liquidacion_cnta_crrte
integer x = 407
integer y = 76
integer width = 87
integer height = 72
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

sl_param.dw1 = "d_rpt_seleccion_tbl"
sl_param.titulo = "Seleccionar Búsqueda"
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2

OpenWithParm( w_search, sl_param )
sl_param = MESSAGE.POWEROBJECTPARM
IF sl_param.titulo <> 'n' THEN
	em_codigo.text  = sl_param.field_ret[1]
	em_nombres.text = sl_param.field_ret[2]
END IF

end event

type gb_2 from groupbox within w_rh602_rpt_liquidacion_cnta_crrte
integer width = 1728
integer height = 200
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = " Seleccione Trabajador "
borderstyle borderstyle = stylebox!
end type

