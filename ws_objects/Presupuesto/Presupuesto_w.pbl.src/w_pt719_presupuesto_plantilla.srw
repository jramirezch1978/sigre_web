$PBExportHeader$w_pt719_presupuesto_plantilla.srw
forward
global type w_pt719_presupuesto_plantilla from w_report_smpl
end type
type em_ano from editmask within w_pt719_presupuesto_plantilla
end type
type cb_1 from commandbutton within w_pt719_presupuesto_plantilla
end type
type st_1 from statictext within w_pt719_presupuesto_plantilla
end type
end forward

global type w_pt719_presupuesto_plantilla from w_report_smpl
integer width = 2203
integer height = 2052
string title = "Plantillas Presupuestales (PT719)"
string menuname = "m_impresion"
long backcolor = 67108864
em_ano em_ano
cb_1 cb_1
st_1 st_1
end type
global w_pt719_presupuesto_plantilla w_pt719_presupuesto_plantilla

on w_pt719_presupuesto_plantilla.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.em_ano=create em_ano
this.cb_1=create cb_1
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.em_ano
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.st_1
end on

on w_pt719_presupuesto_plantilla.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.em_ano)
destroy(this.cb_1)
destroy(this.st_1)
end on

event ue_open_pre;// Override

idw_1 = dw_report
idw_1.SetTransObject(sqlca)
//idw_1.Event ue_preview()
//idw_1.Visible = False

//This.Event ue_retrieve()
end event

event ue_retrieve;call super::ue_retrieve;Integer li_year

li_year = integer(em_ano.text)
idw_1.Retrieve(li_year)

idw_1.Object.p_logo.filename = gs_logo
idw_1.object.t_user.text = gs_user
idw_1.object.t_titulo2.text = 'Año: ' + string(li_year)
end event

type dw_report from w_report_smpl`dw_report within w_pt719_presupuesto_plantilla
integer x = 0
integer y = 132
integer width = 1861
integer height = 1592
string dataobject = "d_rpt_presupuesto_plantilla"
end type

type em_ano from editmask within w_pt719_presupuesto_plantilla
integer x = 178
integer y = 24
integer width = 251
integer height = 92
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
string mask = "####"
end type

type cb_1 from commandbutton within w_pt719_presupuesto_plantilla
integer x = 457
integer y = 24
integer width = 402
integer height = 92
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Reporte"
end type

event clicked;parent.event ue_retrieve()
end event

type st_1 from statictext within w_pt719_presupuesto_plantilla
integer x = 5
integer y = 36
integer width = 169
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Año:"
alignment alignment = right!
boolean focusrectangle = false
end type

