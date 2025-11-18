$PBExportHeader$w_cn752_cv_rpt_movimiento_mes.srw
forward
global type w_cn752_cv_rpt_movimiento_mes from w_report_smpl
end type
type cb_1 from commandbutton within w_cn752_cv_rpt_movimiento_mes
end type
type em_ano from editmask within w_cn752_cv_rpt_movimiento_mes
end type
type em_mes from editmask within w_cn752_cv_rpt_movimiento_mes
end type
type st_1 from statictext within w_cn752_cv_rpt_movimiento_mes
end type
type st_2 from statictext within w_cn752_cv_rpt_movimiento_mes
end type
type st_3 from statictext within w_cn752_cv_rpt_movimiento_mes
end type
end forward

global type w_cn752_cv_rpt_movimiento_mes from w_report_smpl
integer width = 3451
integer height = 1508
string title = "(CN752) Movimiento Mensual de Costos de Ventas de Azúcar"
string menuname = "m_abc_report_smpl"
long backcolor = 12632256
cb_1 cb_1
em_ano em_ano
em_mes em_mes
st_1 st_1
st_2 st_2
st_3 st_3
end type
global w_cn752_cv_rpt_movimiento_mes w_cn752_cv_rpt_movimiento_mes

type variables
String is_opcion

end variables

on w_cn752_cv_rpt_movimiento_mes.create
int iCurrent
call super::create
if this.MenuName = "m_abc_report_smpl" then this.MenuID = create m_abc_report_smpl
this.cb_1=create cb_1
this.em_ano=create em_ano
this.em_mes=create em_mes
this.st_1=create st_1
this.st_2=create st_2
this.st_3=create st_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.em_ano
this.Control[iCurrent+3]=this.em_mes
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.st_3
end on

on w_cn752_cv_rpt_movimiento_mes.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.em_ano)
destroy(this.em_mes)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.st_3)
end on

event ue_retrieve;call super::ue_retrieve;integer li_ano, li_mes

li_ano = integer(em_ano.text)
li_mes = integer(em_mes.text)

DECLARE pb_usp_cntbl_rpt_cv_mov_mensual PROCEDURE FOR USP_CNTBL_RPT_CV_MOV_MENSUAL
        ( :li_ano, :li_mes ) ;
Execute pb_usp_cntbl_rpt_cv_mov_mensual ;

dw_report.retrieve()

dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_nombre.text   = gs_empresa
dw_report.object.t_user.text     = gs_user
if gs_origen = 'PR' then
   dw_report.object.t_32.text = 'MOVIMIENTO MENSUAL DE COSTOS DE VENTA DE AZUCAR'
elseif gs_origen = 'IN' then
	dw_report.object.t_32.text = 'MOVIMIENTO MENSUAL DE COSTOS DE VENTA DE CAÑA'
end if

end event

type dw_report from w_report_smpl`dw_report within w_cn752_cv_rpt_movimiento_mes
integer x = 0
integer y = 196
integer width = 3401
integer height = 1116
integer taborder = 40
string dataobject = "d_cv_rpt_movimiento_mes_tbl"
end type

type cb_1 from commandbutton within w_cn752_cv_rpt_movimiento_mes
integer x = 2341
integer y = 64
integer width = 270
integer height = 84
integer taborder = 30
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

type em_ano from editmask within w_cn752_cv_rpt_movimiento_mes
integer x = 1682
integer y = 64
integer width = 219
integer height = 76
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
alignment alignment = center!
borderstyle borderstyle = stylelowered!
string mask = "####"
end type

type em_mes from editmask within w_cn752_cv_rpt_movimiento_mes
integer x = 2085
integer y = 64
integer width = 160
integer height = 76
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
alignment alignment = center!
borderstyle borderstyle = stylelowered!
string mask = "##"
end type

type st_1 from statictext within w_cn752_cv_rpt_movimiento_mes
integer x = 987
integer y = 72
integer width = 457
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 255
long backcolor = 67108864
string text = "Fecha de Proceso"
boolean focusrectangle = false
end type

type st_2 from statictext within w_cn752_cv_rpt_movimiento_mes
integer x = 1938
integer y = 72
integer width = 110
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 67108864
string text = "Mes"
boolean focusrectangle = false
end type

type st_3 from statictext within w_cn752_cv_rpt_movimiento_mes
integer x = 1536
integer y = 72
integer width = 110
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 67108864
string text = "Año"
boolean focusrectangle = false
end type

