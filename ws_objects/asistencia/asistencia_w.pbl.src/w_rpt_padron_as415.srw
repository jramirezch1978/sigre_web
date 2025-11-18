$PBExportHeader$w_rpt_padron_as415.srw
forward
global type w_rpt_padron_as415 from w_report_smpl
end type
type cb_1 from commandbutton within w_rpt_padron_as415
end type
type st_1 from statictext within w_rpt_padron_as415
end type
end forward

global type w_rpt_padron_as415 from w_report_smpl
integer width = 3461
integer height = 1644
string title = "Padrón de Obreros y Empleados (AS415)"
string menuname = "m_reporte"
long backcolor = 79741120
cb_1 cb_1
st_1 st_1
end type
global w_rpt_padron_as415 w_rpt_padron_as415

on w_rpt_padron_as415.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.cb_1=create cb_1
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.st_1
end on

on w_rpt_padron_as415.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.st_1)
end on

event ue_retrieve();call super::ue_retrieve;dw_report.retrieve()

dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_nombre.text = gs_empresa
dw_report.object.t_user.text = gs_user

end event

type dw_report from w_report_smpl`dw_report within w_rpt_padron_as415
integer x = 9
integer y = 276
integer width = 3410
integer height = 1184
integer taborder = 40
string dataobject = "d_rpt_padron_tbl"
end type

type cb_1 from commandbutton within w_rpt_padron_as415
integer x = 1691
integer y = 156
integer width = 274
integer height = 80
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aceptar"
end type

event clicked;w_rpt_padron_as415.Event ue_retrieve()
end event

type st_1 from statictext within w_rpt_padron_as415
integer x = 489
integer y = 36
integer width = 2656
integer height = 76
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Century Gothic"
boolean underline = true
long textcolor = 16711680
long backcolor = 67108864
boolean enabled = false
string text = "PADRON DEL PERSONAL QUE REGISTRA ASISTENCIA"
alignment alignment = center!
boolean focusrectangle = false
end type

