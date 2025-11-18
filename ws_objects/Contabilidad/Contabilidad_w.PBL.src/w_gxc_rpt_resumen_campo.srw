$PBExportHeader$w_gxc_rpt_resumen_campo.srw
forward
global type w_gxc_rpt_resumen_campo from w_report_smpl
end type
type sle_ano from singlelineedit within w_gxc_rpt_resumen_campo
end type
type sle_mes from singlelineedit within w_gxc_rpt_resumen_campo
end type
type cb_1 from commandbutton within w_gxc_rpt_resumen_campo
end type
type st_3 from statictext within w_gxc_rpt_resumen_campo
end type
type st_4 from statictext within w_gxc_rpt_resumen_campo
end type
type st_1 from statictext within w_gxc_rpt_resumen_campo
end type
type st_2 from statictext within w_gxc_rpt_resumen_campo
end type
type gb_1 from groupbox within w_gxc_rpt_resumen_campo
end type
end forward

global type w_gxc_rpt_resumen_campo from w_report_smpl
integer width = 3474
integer height = 1604
string title = "Gastos por Campos"
string menuname = "m_abc_report_smpl"
long backcolor = 12632256
sle_ano sle_ano
sle_mes sle_mes
cb_1 cb_1
st_3 st_3
st_4 st_4
st_1 st_1
st_2 st_2
gb_1 gb_1
end type
global w_gxc_rpt_resumen_campo w_gxc_rpt_resumen_campo

on w_gxc_rpt_resumen_campo.create
int iCurrent
call super::create
if this.MenuName = "m_abc_report_smpl" then this.MenuID = create m_abc_report_smpl
this.sle_ano=create sle_ano
this.sle_mes=create sle_mes
this.cb_1=create cb_1
this.st_3=create st_3
this.st_4=create st_4
this.st_1=create st_1
this.st_2=create st_2
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_ano
this.Control[iCurrent+2]=this.sle_mes
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.st_4
this.Control[iCurrent+6]=this.st_1
this.Control[iCurrent+7]=this.st_2
this.Control[iCurrent+8]=this.gb_1
end on

on w_gxc_rpt_resumen_campo.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_ano)
destroy(this.sle_mes)
destroy(this.cb_1)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.gb_1)
end on

event ue_retrieve();call super::ue_retrieve;string ls_ano, ls_mes

ls_ano = String(sle_ano.text)
ls_mes = String(sle_mes.text)

DECLARE pb_usp_gxc_rpt_resumen_campo PROCEDURE FOR USP_GXC_RPT_RESUMEN_CAMPO
        ( :ls_ano, :ls_mes ) ;
Execute pb_usp_gxc_rpt_resumen_campo ;

dw_report.retrieve()

dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_nombre.text   = gs_empresa
dw_report.object.t_user.text     = gs_user

end event

type dw_report from w_report_smpl`dw_report within w_gxc_rpt_resumen_campo
integer x = 23
integer y = 324
integer width = 3397
integer height = 1080
string dataobject = "d_gxc_rpt_resumen_campo_tbl"
end type

type sle_ano from singlelineedit within w_gxc_rpt_resumen_campo
integer x = 2231
integer y = 128
integer width = 192
integer height = 72
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type sle_mes from singlelineedit within w_gxc_rpt_resumen_campo
integer x = 2615
integer y = 128
integer width = 105
integer height = 72
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type cb_1 from commandbutton within w_gxc_rpt_resumen_campo
integer x = 2853
integer y = 112
integer width = 297
integer height = 92
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aceptar"
end type

event clicked;Parent.Event ue_retrieve()

end event

type st_3 from statictext within w_gxc_rpt_resumen_campo
integer x = 2432
integer y = 144
integer width = 178
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Mes"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_4 from statictext within w_gxc_rpt_resumen_campo
integer x = 2053
integer y = 144
integer width = 174
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
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

type st_1 from statictext within w_gxc_rpt_resumen_campo
integer x = 338
integer y = 68
integer width = 1591
integer height = 88
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Century Gothic"
long textcolor = 33554432
long backcolor = 67108864
string text = "RESUMEN POR ADMINISTRACIONES ZONAS"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleshadowbox!
boolean focusrectangle = false
end type

type st_2 from statictext within w_gxc_rpt_resumen_campo
integer x = 667
integer y = 188
integer width = 933
integer height = 88
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Century Gothic"
long textcolor = 33554432
long backcolor = 67108864
string text = "Y CAMPOS  -  CULTIVO"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleshadowbox!
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_gxc_rpt_resumen_campo
integer x = 2021
integer y = 44
integer width = 768
integer height = 220
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 12632256
string text = " Periodo Contable "
borderstyle borderstyle = stylelowered!
end type

