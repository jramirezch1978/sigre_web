$PBExportHeader$w_rh398_rpt_av_calificacion_desempeno.srw
forward
global type w_rh398_rpt_av_calificacion_desempeno from w_report_smpl
end type
type cb_1 from commandbutton within w_rh398_rpt_av_calificacion_desempeno
end type
type em_ano from editmask within w_rh398_rpt_av_calificacion_desempeno
end type
type em_mes from editmask within w_rh398_rpt_av_calificacion_desempeno
end type
type st_1 from statictext within w_rh398_rpt_av_calificacion_desempeno
end type
type st_2 from statictext within w_rh398_rpt_av_calificacion_desempeno
end type
type gb_1 from groupbox within w_rh398_rpt_av_calificacion_desempeno
end type
end forward

global type w_rh398_rpt_av_calificacion_desempeno from w_report_smpl
integer width = 3429
integer height = 1500
string title = "(RH398) Formato de Calificación por Actitudes"
string menuname = "m_impresion"
cb_1 cb_1
em_ano em_ano
em_mes em_mes
st_1 st_1
st_2 st_2
gb_1 gb_1
end type
global w_rh398_rpt_av_calificacion_desempeno w_rh398_rpt_av_calificacion_desempeno

on w_rh398_rpt_av_calificacion_desempeno.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.cb_1=create cb_1
this.em_ano=create em_ano
this.em_mes=create em_mes
this.st_1=create st_1
this.st_2=create st_2
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.em_ano
this.Control[iCurrent+3]=this.em_mes
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.gb_1
end on

on w_rh398_rpt_av_calificacion_desempeno.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.em_ano)
destroy(this.em_mes)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.gb_1)
end on

event ue_retrieve;call super::ue_retrieve;integer li_ano, li_mes

li_ano = integer(em_ano.text)
li_mes = integer(em_mes.text)

dw_report.retrieve ()

dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_nombre.text = gs_empresa
dw_report.object.t_user.text = gs_user
dw_report.object.t_ano.text = string(li_ano)
dw_report.object.t_mes.text = string(li_mes)

end event

type dw_report from w_report_smpl`dw_report within w_rh398_rpt_av_calificacion_desempeno
integer x = 0
integer y = 208
integer width = 3369
integer height = 956
integer taborder = 40
string dataobject = "d_rpt_av_calificacion_desempeno_tbl"
end type

type cb_1 from commandbutton within w_rh398_rpt_av_calificacion_desempeno
integer x = 1070
integer y = 72
integer width = 293
integer height = 76
integer taborder = 30
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

type em_ano from editmask within w_rh398_rpt_av_calificacion_desempeno
integer x = 251
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

type em_mes from editmask within w_rh398_rpt_av_calificacion_desempeno
integer x = 704
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

type st_1 from statictext within w_rh398_rpt_av_calificacion_desempeno
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

type st_2 from statictext within w_rh398_rpt_av_calificacion_desempeno
integer x = 544
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
string text = "Mes"
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_rh398_rpt_av_calificacion_desempeno
integer width = 987
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

