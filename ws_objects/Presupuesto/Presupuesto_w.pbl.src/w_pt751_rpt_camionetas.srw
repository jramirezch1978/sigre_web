$PBExportHeader$w_pt751_rpt_camionetas.srw
forward
global type w_pt751_rpt_camionetas from w_report_smpl
end type
type cb_1 from commandbutton within w_pt751_rpt_camionetas
end type
type em_ano from editmask within w_pt751_rpt_camionetas
end type
type em_mes_desde from editmask within w_pt751_rpt_camionetas
end type
type st_1 from statictext within w_pt751_rpt_camionetas
end type
type st_2 from statictext within w_pt751_rpt_camionetas
end type
type st_3 from statictext within w_pt751_rpt_camionetas
end type
type em_mes_hasta from editmask within w_pt751_rpt_camionetas
end type
type gb_2 from groupbox within w_pt751_rpt_camionetas
end type
end forward

global type w_pt751_rpt_camionetas from w_report_smpl
integer width = 3410
integer height = 1532
string title = "(PT751) Costos por Horas de las Camionetas"
string menuname = "m_impresion"
long backcolor = 67108864
cb_1 cb_1
em_ano em_ano
em_mes_desde em_mes_desde
st_1 st_1
st_2 st_2
st_3 st_3
em_mes_hasta em_mes_hasta
gb_2 gb_2
end type
global w_pt751_rpt_camionetas w_pt751_rpt_camionetas

on w_pt751_rpt_camionetas.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.cb_1=create cb_1
this.em_ano=create em_ano
this.em_mes_desde=create em_mes_desde
this.st_1=create st_1
this.st_2=create st_2
this.st_3=create st_3
this.em_mes_hasta=create em_mes_hasta
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.em_ano
this.Control[iCurrent+3]=this.em_mes_desde
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.st_3
this.Control[iCurrent+7]=this.em_mes_hasta
this.Control[iCurrent+8]=this.gb_2
end on

on w_pt751_rpt_camionetas.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.em_ano)
destroy(this.em_mes_desde)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.em_mes_hasta)
destroy(this.gb_2)
end on

event ue_retrieve;call super::ue_retrieve;integer li_ano, li_mes_desde, li_mes_hasta
string  ls_mensaje

li_ano       = integer(em_ano.text)
li_mes_desde = integer(em_mes_desde.text)
li_mes_hasta = integer(em_mes_hasta.text)

DECLARE pb_usp_ptto_rpt_camionetas PROCEDURE FOR USP_PTTO_RPT_CAMIONETAS
        ( :li_ano, :li_mes_desde, :li_mes_hasta ) ;
EXECUTE pb_usp_ptto_rpt_camionetas ;

idw_1.retrieve()

idw_1.object.p_logo.filename = gs_logo
idw_1.object.t_nombre.text   = gs_empresa
idw_1.object.t_user.text     = gs_user

if SQLCA.SQLCode = -1 then
  ls_mensaje = sqlca.sqlerrtext
  rollback ;
  MessageBox("SQL error", ls_mensaje, StopSign!)
end if

end event

type dw_report from w_report_smpl`dw_report within w_pt751_rpt_camionetas
integer x = 9
integer y = 260
integer width = 3355
integer height = 1080
integer taborder = 50
string dataobject = "d_rpt_camionetas_tbl"
end type

type cb_1 from commandbutton within w_pt751_rpt_camionetas
integer x = 2633
integer y = 100
integer width = 302
integer height = 76
integer taborder = 40
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

type em_ano from editmask within w_pt751_rpt_camionetas
integer x = 1161
integer y = 104
integer width = 279
integer height = 72
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

type em_mes_desde from editmask within w_pt751_rpt_camionetas
integer x = 1765
integer y = 104
integer width = 192
integer height = 72
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
maskdatatype maskdatatype = stringmask!
string mask = "xx"
end type

type st_1 from statictext within w_pt751_rpt_camionetas
integer x = 1029
integer y = 112
integer width = 110
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Año"
boolean focusrectangle = false
end type

type st_2 from statictext within w_pt751_rpt_camionetas
integer x = 1477
integer y = 112
integer width = 256
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Mes Desde"
boolean focusrectangle = false
end type

type st_3 from statictext within w_pt751_rpt_camionetas
integer x = 1993
integer y = 112
integer width = 251
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Mes Hasta"
boolean focusrectangle = false
end type

type em_mes_hasta from editmask within w_pt751_rpt_camionetas
integer x = 2272
integer y = 104
integer width = 192
integer height = 72
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
maskdatatype maskdatatype = stringmask!
string mask = "xx"
end type

type gb_2 from groupbox within w_pt751_rpt_camionetas
integer x = 951
integer y = 36
integer width = 1591
integer height = 180
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = " Periodo Contable "
end type

