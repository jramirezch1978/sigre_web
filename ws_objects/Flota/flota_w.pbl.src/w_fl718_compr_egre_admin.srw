$PBExportHeader$w_fl718_compr_egre_admin.srw
forward
global type w_fl718_compr_egre_admin from w_rpt
end type
type cb_2 from commandbutton within w_fl718_compr_egre_admin
end type
type cb_1 from commandbutton within w_fl718_compr_egre_admin
end type
type em_ano from editmask within w_fl718_compr_egre_admin
end type
type em_mes from editmask within w_fl718_compr_egre_admin
end type
type st_3 from statictext within w_fl718_compr_egre_admin
end type
type st_2 from statictext within w_fl718_compr_egre_admin
end type
type dw_report from u_dw_rpt within w_fl718_compr_egre_admin
end type
end forward

global type w_fl718_compr_egre_admin from w_rpt
integer width = 2962
integer height = 3652
string title = "Incentivos de Personal Administrativo Flota (FL718)"
string menuname = "m_rpt"
long backcolor = 67108864
cb_2 cb_2
cb_1 cb_1
em_ano em_ano
em_mes em_mes
st_3 st_3
st_2 st_2
dw_report dw_report
end type
global w_fl718_compr_egre_admin w_fl718_compr_egre_admin

type variables
uo_parte_pesca iuo_parte
end variables

on w_fl718_compr_egre_admin.create
int iCurrent
call super::create
if this.MenuName = "m_rpt" then this.MenuID = create m_rpt
this.cb_2=create cb_2
this.cb_1=create cb_1
this.em_ano=create em_ano
this.em_mes=create em_mes
this.st_3=create st_3
this.st_2=create st_2
this.dw_report=create dw_report
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_2
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.em_ano
this.Control[iCurrent+4]=this.em_mes
this.Control[iCurrent+5]=this.st_3
this.Control[iCurrent+6]=this.st_2
this.Control[iCurrent+7]=this.dw_report
end on

on w_fl718_compr_egre_admin.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.em_ano)
destroy(this.em_mes)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.dw_report)
end on

event ue_retrieve;call super::ue_retrieve;integer 	li_mes, li_ano
string 	ls_mensaje

li_ano = integer(em_ano.text)
li_mes = integer(em_mes.text)

SetPointer(HourGlass!)
idw_1.Retrieve(li_ano, li_mes)
idw_1.Visible = True

SetPointer(Arrow!)
end event

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report
idw_1.SetTransObject(sqlca)

idw_1.object.Datawindow.Print.Orientation = 1

iuo_parte = create uo_parte_pesca

em_ano.text = string( year( Date(f_fecha_actual()) ) )
em_mes.text = string( month( Date(f_fecha_actual()) ) )

idw_1.object.p_logo.filename 	= gs_logo
idw_1.object.t_empresa.text 	= gs_empresa
idw_1.object.t_usuario.text	= gs_user
idw_1.object.t_objeto.text		= this.classname()
end event

event resize;call super::resize;this.SetRedraw(false)
dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
this.SetRedraw(true)
end event

event ue_print;call super::ue_print;idw_1.EVENT ue_print()
end event

event ue_preview;call super::ue_preview;IF ib_preview THEN
	idw_1.Modify("DataWindow.Print.Preview=No")
	idw_1.Modify("datawindow.print.preview.zoom = " + String(idw_1.ii_zoom_actual))
	idw_1.title = "Reporte " + " (Zoom: " + String(idw_1.ii_zoom_actual) + "%)"
	SetPointer(hourglass!)
	ib_preview = FALSE
ELSE
	idw_1.Modify("DataWindow.Print.Preview=Yes")
	idw_1.Modify("datawindow.print.preview.zoom = " + String(idw_1.ii_zoom_actual))
	idw_1.title = "Reporte " + " (Zoom: " + String(idw_1.ii_zoom_actual) + "%)"
	SetPointer(hourglass!)
	ib_preview = TRUE
END IF
end event

type cb_2 from commandbutton within w_fl718_compr_egre_admin
integer x = 2199
integer y = 28
integer width = 553
integer height = 92
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Imprimir CE"
end type

event clicked;integer 	li_mes, li_ano
string 	ls_mensaje

li_ano = integer(em_ano.text)
li_mes = integer(em_mes.text)

SetPointer(HourGlass!)
idw_1.dataobject = 'd_rpt_comprobante_egreso_adm_tbl'
idw_1.SetTransObject(SQLCA)
idw_1.Retrieve(li_ano, li_mes)
idw_1.object.p_logo.filename = gs_logo
idw_1.object.empresa_t.text = gs_empresa
idw_1.Visible = True

ib_preview = false
event ue_preview()

SetPointer(Arrow!)
end event

type cb_1 from commandbutton within w_fl718_compr_egre_admin
integer x = 1797
integer y = 28
integer width = 393
integer height = 92
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Reporte"
end type

event clicked;Parent.event ue_retrieve( )
end event

type em_ano from editmask within w_fl718_compr_egre_admin
integer x = 338
integer y = 28
integer width = 375
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
string mask = "####"
boolean spin = true
end type

type em_mes from editmask within w_fl718_compr_egre_admin
integer x = 1307
integer y = 28
integer width = 370
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
string mask = "##"
boolean spin = true
end type

type st_3 from statictext within w_fl718_compr_egre_admin
integer x = 137
integer y = 48
integer width = 165
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 67108864
string text = "Año:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_2 from statictext within w_fl718_compr_egre_admin
integer x = 928
integer y = 48
integer width = 343
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 67108864
string text = "Mes:"
alignment alignment = right!
boolean focusrectangle = false
end type

type dw_report from u_dw_rpt within w_fl718_compr_egre_admin
integer y = 156
integer width = 2482
integer height = 1524
integer taborder = 70
string dataobject = "d_rpt_comprob_egreso_admin_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = false
end type

