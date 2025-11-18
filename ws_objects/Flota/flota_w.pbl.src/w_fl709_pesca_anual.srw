$PBExportHeader$w_fl709_pesca_anual.srw
forward
global type w_fl709_pesca_anual from w_rpt
end type
type cb_1 from commandbutton within w_fl709_pesca_anual
end type
type em_ano from editmask within w_fl709_pesca_anual
end type
type st_3 from statictext within w_fl709_pesca_anual
end type
type dw_report from u_dw_rpt within w_fl709_pesca_anual
end type
end forward

global type w_fl709_pesca_anual from w_rpt
integer width = 2528
integer height = 2032
string title = "Pesca Anual (FL709)"
string menuname = "m_rep_grf"
long backcolor = 67108864
cb_1 cb_1
em_ano em_ano
st_3 st_3
dw_report dw_report
end type
global w_fl709_pesca_anual w_fl709_pesca_anual

type variables
uo_parte_pesca iuo_parte
end variables

on w_fl709_pesca_anual.create
int iCurrent
call super::create
if this.MenuName = "m_rep_grf" then this.MenuID = create m_rep_grf
this.cb_1=create cb_1
this.em_ano=create em_ano
this.st_3=create st_3
this.dw_report=create dw_report
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.em_ano
this.Control[iCurrent+3]=this.st_3
this.Control[iCurrent+4]=this.dw_report
end on

on w_fl709_pesca_anual.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.em_ano)
destroy(this.st_3)
destroy(this.dw_report)
end on

event ue_retrieve;call super::ue_retrieve;integer li_ano

li_ano = integer(em_ano.text)

idw_1.Object.p_logo.filename = gs_logo
idw_1.object.t_empresa.text = gs_empresa
idw_1.object.t_objeto.text = this.ClassName()
idw_1.object.t_user.text = gs_user
idw_1.object.t_titulo1.text = 'AÑO : ' + string(li_ano)

idw_1.Retrieve(li_ano)

end event

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report
idw_1.SetTransObject(sqlca)

idw_1.object.p_logo.filename 	= gs_logo
idw_1.object.Datawindow.Print.Orientation = 1

THIS.Event ue_preview()

iuo_parte = CREATE uo_parte_pesca

em_ano.text = string( year( today() ) )

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

event ue_saveas;//Overrding
string ls_path, ls_file
int li_rc

li_rc = GetFileSaveName ( "Select File", &
   ls_path, ls_file, "XLS", &
   "All Files (*.*),*.*" , "C:\", 32770)

IF li_rc = 1 Then
   uf_save_dw_as_excel ( dw_report, ls_file )
End If
end event

type cb_1 from commandbutton within w_fl709_pesca_anual
integer x = 763
integer y = 40
integer width = 462
integer height = 88
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Recuperar"
end type

event clicked;parent.event ue_retrieve()
end event

type em_ano from editmask within w_fl709_pesca_anual
integer x = 338
integer y = 36
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

type st_3 from statictext within w_fl709_pesca_anual
integer x = 137
integer y = 56
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

type dw_report from u_dw_rpt within w_fl709_pesca_anual
integer y = 172
integer width = 2482
integer height = 1524
integer taborder = 70
string dataobject = "d_rpt_pesca_anual_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = false
end type

