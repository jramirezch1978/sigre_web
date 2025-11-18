$PBExportHeader$w_gxc_rpt_cuenta_presupuestal.srw
forward
global type w_gxc_rpt_cuenta_presupuestal from w_report_smpl
end type
type cb_1 from commandbutton within w_gxc_rpt_cuenta_presupuestal
end type
type st_3 from statictext within w_gxc_rpt_cuenta_presupuestal
end type
type st_4 from statictext within w_gxc_rpt_cuenta_presupuestal
end type
type em_ano from editmask within w_gxc_rpt_cuenta_presupuestal
end type
type em_mes from editmask within w_gxc_rpt_cuenta_presupuestal
end type
type cb_2 from commandbutton within w_gxc_rpt_cuenta_presupuestal
end type
type em_cnta_desde from editmask within w_gxc_rpt_cuenta_presupuestal
end type
type em_cnta_hasta from editmask within w_gxc_rpt_cuenta_presupuestal
end type
type cb_3 from commandbutton within w_gxc_rpt_cuenta_presupuestal
end type
type gb_1 from groupbox within w_gxc_rpt_cuenta_presupuestal
end type
type gb_2 from groupbox within w_gxc_rpt_cuenta_presupuestal
end type
end forward

global type w_gxc_rpt_cuenta_presupuestal from w_report_smpl
integer width = 3406
integer height = 1604
string title = "Resumen por Cuentas Presupuestales - Gastos por Campos"
string menuname = "m_abc_report_smpl"
long backcolor = 12632256
cb_1 cb_1
st_3 st_3
st_4 st_4
em_ano em_ano
em_mes em_mes
cb_2 cb_2
em_cnta_desde em_cnta_desde
em_cnta_hasta em_cnta_hasta
cb_3 cb_3
gb_1 gb_1
gb_2 gb_2
end type
global w_gxc_rpt_cuenta_presupuestal w_gxc_rpt_cuenta_presupuestal

on w_gxc_rpt_cuenta_presupuestal.create
int iCurrent
call super::create
if this.MenuName = "m_abc_report_smpl" then this.MenuID = create m_abc_report_smpl
this.cb_1=create cb_1
this.st_3=create st_3
this.st_4=create st_4
this.em_ano=create em_ano
this.em_mes=create em_mes
this.cb_2=create cb_2
this.em_cnta_desde=create em_cnta_desde
this.em_cnta_hasta=create em_cnta_hasta
this.cb_3=create cb_3
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.st_3
this.Control[iCurrent+3]=this.st_4
this.Control[iCurrent+4]=this.em_ano
this.Control[iCurrent+5]=this.em_mes
this.Control[iCurrent+6]=this.cb_2
this.Control[iCurrent+7]=this.em_cnta_desde
this.Control[iCurrent+8]=this.em_cnta_hasta
this.Control[iCurrent+9]=this.cb_3
this.Control[iCurrent+10]=this.gb_1
this.Control[iCurrent+11]=this.gb_2
end on

on w_gxc_rpt_cuenta_presupuestal.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.em_ano)
destroy(this.em_mes)
destroy(this.cb_2)
destroy(this.em_cnta_desde)
destroy(this.em_cnta_hasta)
destroy(this.cb_3)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event ue_retrieve;call super::ue_retrieve;string  ls_cnta_desde, ls_cnta_hasta
integer li_ano, li_mes

ls_cnta_desde = string(em_cnta_desde.text)
ls_cnta_hasta = string(em_cnta_hasta.text)

li_ano = integer(em_ano.text)
li_mes = integer(em_mes.text)

DECLARE pb_usp_gxc_rpt_cnta_presupuestal PROCEDURE FOR USP_GXC_RPT_CNTA_PRESUPUESTAL
        ( :li_ano, :li_mes, :ls_cnta_desde, :ls_cnta_hasta ) ;
EXECUTE pb_usp_gxc_rpt_cnta_presupuestal ;

dw_report.retrieve()

dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_nombre.text = gs_empresa
dw_report.object.t_user.text = gs_user
dw_report.object.t_ano.text = string(li_ano)
dw_report.object.t_mes.text = string(li_mes)

end event

type dw_report from w_report_smpl`dw_report within w_gxc_rpt_cuenta_presupuestal
integer x = 23
integer y = 324
integer width = 3323
integer height = 1088
integer taborder = 60
string dataobject = "d_gxc_rpt_cnta_presupuestal_tbl"
end type

type cb_1 from commandbutton within w_gxc_rpt_cuenta_presupuestal
integer x = 2770
integer y = 128
integer width = 297
integer height = 92
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aceptar"
end type

event clicked;Parent.Event ue_retrieve()

end event

type st_3 from statictext within w_gxc_rpt_cuenta_presupuestal
integer x = 2217
integer y = 152
integer width = 183
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Al Mes"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_4 from statictext within w_gxc_rpt_cuenta_presupuestal
integer x = 1801
integer y = 152
integer width = 133
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Año"
alignment alignment = center!
boolean focusrectangle = false
end type

type em_ano from editmask within w_gxc_rpt_cuenta_presupuestal
integer x = 1943
integer y = 144
integer width = 247
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
alignment alignment = center!
borderstyle borderstyle = stylelowered!
string mask = "####"
end type

type em_mes from editmask within w_gxc_rpt_cuenta_presupuestal
integer x = 2427
integer y = 144
integer width = 178
integer height = 76
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
alignment alignment = center!
borderstyle borderstyle = stylelowered!
string mask = "##"
end type

type cb_2 from commandbutton within w_gxc_rpt_cuenta_presupuestal
integer x = 512
integer y = 148
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

sl_param.dw1 = "d_cnta_presupuestal_tbl"
sl_param.titulo = "Seleccionar Búsqueda"
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2

OpenWithParm( w_search, sl_param)		
sl_param = MESSAGE.POWEROBJECTPARM
IF sl_param.titulo <> 'n' THEN
	em_cnta_desde.text = sl_param.field_ret[1]
END IF

end event

type em_cnta_desde from editmask within w_gxc_rpt_cuenta_presupuestal
integer x = 649
integer y = 144
integer width = 389
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
alignment alignment = center!
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type em_cnta_hasta from editmask within w_gxc_rpt_cuenta_presupuestal
integer x = 1216
integer y = 144
integer width = 389
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
alignment alignment = center!
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type cb_3 from commandbutton within w_gxc_rpt_cuenta_presupuestal
integer x = 1088
integer y = 148
integer width = 87
integer height = 72
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

sl_param.dw1 = "d_cnta_presupuestal_tbl"
sl_param.titulo = "Seleccionar Búsqueda"
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2

OpenWithParm( w_search, sl_param)		
sl_param = MESSAGE.POWEROBJECTPARM
IF sl_param.titulo <> 'n' THEN
	em_cnta_hasta.text = sl_param.field_ret[1]
END IF

end event

type gb_1 from groupbox within w_gxc_rpt_cuenta_presupuestal
integer x = 1765
integer y = 68
integer width = 914
integer height = 200
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = " Periodo Contable "
end type

type gb_2 from groupbox within w_gxc_rpt_cuenta_presupuestal
integer x = 434
integer y = 68
integer width = 1243
integer height = 200
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = " Seleccione Cuenta Presupuestal "
end type

