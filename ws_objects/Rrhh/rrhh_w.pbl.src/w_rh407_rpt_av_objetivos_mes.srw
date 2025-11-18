$PBExportHeader$w_rh407_rpt_av_objetivos_mes.srw
forward
global type w_rh407_rpt_av_objetivos_mes from w_report_smpl
end type
type cb_1 from commandbutton within w_rh407_rpt_av_objetivos_mes
end type
type em_ano from editmask within w_rh407_rpt_av_objetivos_mes
end type
type em_mes_desde from editmask within w_rh407_rpt_av_objetivos_mes
end type
type st_1 from statictext within w_rh407_rpt_av_objetivos_mes
end type
type st_2 from statictext within w_rh407_rpt_av_objetivos_mes
end type
type em_mes_hasta from editmask within w_rh407_rpt_av_objetivos_mes
end type
type st_3 from statictext within w_rh407_rpt_av_objetivos_mes
end type
type gb_1 from groupbox within w_rh407_rpt_av_objetivos_mes
end type
end forward

global type w_rh407_rpt_av_objetivos_mes from w_report_smpl
integer width = 3502
integer height = 1516
string title = "(RH407) Evaluaciones Mensuales por Objetivos"
string menuname = "m_impresion"
cb_1 cb_1
em_ano em_ano
em_mes_desde em_mes_desde
st_1 st_1
st_2 st_2
em_mes_hasta em_mes_hasta
st_3 st_3
gb_1 gb_1
end type
global w_rh407_rpt_av_objetivos_mes w_rh407_rpt_av_objetivos_mes

on w_rh407_rpt_av_objetivos_mes.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.cb_1=create cb_1
this.em_ano=create em_ano
this.em_mes_desde=create em_mes_desde
this.st_1=create st_1
this.st_2=create st_2
this.em_mes_hasta=create em_mes_hasta
this.st_3=create st_3
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.em_ano
this.Control[iCurrent+3]=this.em_mes_desde
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.em_mes_hasta
this.Control[iCurrent+7]=this.st_3
this.Control[iCurrent+8]=this.gb_1
end on

on w_rh407_rpt_av_objetivos_mes.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.em_ano)
destroy(this.em_mes_desde)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.em_mes_hasta)
destroy(this.st_3)
destroy(this.gb_1)
end on

event ue_retrieve;call super::ue_retrieve;integer li_ano, li_mes_desde, li_mes_hasta

li_ano 	    = integer(em_ano.text)
li_mes_desde = integer(em_mes_desde.text)
li_mes_hasta = integer(em_mes_hasta.text)

DECLARE pb_usp_rh_av_rpt_eval_obj_mes PROCEDURE FOR USP_RH_AV_RPT_EVAL_OBJ_MES
	     ( :li_ano, :li_mes_desde, :li_mes_hasta ) ;
EXECUTE pb_usp_rh_av_rpt_eval_obj_mes ;

dw_report.retrieve()

dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_nombre.text = gs_empresa
dw_report.object.t_user.text = gs_user

end event

type dw_report from w_report_smpl`dw_report within w_rh407_rpt_av_objetivos_mes
integer x = 0
integer y = 208
integer width = 3433
integer height = 992
integer taborder = 50
string dataobject = "d_rpt_av_objetivos_mes_tbl"
end type

type cb_1 from commandbutton within w_rh407_rpt_av_objetivos_mes
integer x = 1618
integer y = 76
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

type em_ano from editmask within w_rh407_rpt_av_objetivos_mes
integer x = 238
integer y = 76
integer width = 233
integer height = 76
integer taborder = 10
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

type em_mes_desde from editmask within w_rh407_rpt_av_objetivos_mes
integer x = 809
integer y = 76
integer width = 165
integer height = 76
integer taborder = 20
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

type st_1 from statictext within w_rh407_rpt_av_objetivos_mes
integer x = 91
integer y = 80
integer width = 119
integer height = 56
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
string text = "Año"
boolean focusrectangle = false
end type

type st_2 from statictext within w_rh407_rpt_av_objetivos_mes
integer x = 517
integer y = 80
integer width = 256
integer height = 56
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
string text = "Mes Desde"
boolean focusrectangle = false
end type

type em_mes_hasta from editmask within w_rh407_rpt_av_objetivos_mes
integer x = 1312
integer y = 76
integer width = 165
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
string mask = "##"
end type

type st_3 from statictext within w_rh407_rpt_av_objetivos_mes
integer x = 1029
integer y = 80
integer width = 256
integer height = 56
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
string text = "Mes Hasta"
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_rh407_rpt_av_objetivos_mes
integer width = 1550
integer height = 196
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = " Fecha de Proceso "
end type

