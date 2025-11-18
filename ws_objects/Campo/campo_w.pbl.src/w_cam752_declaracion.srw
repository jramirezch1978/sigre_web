$PBExportHeader$w_cam752_declaracion.srw
forward
global type w_cam752_declaracion from window
end type
type dw_report from datawindow within w_cam752_declaracion
end type
end forward

global type w_cam752_declaracion from window
integer width = 3127
integer height = 2112
boolean titlebar = true
string title = "[CAM752] Declaración del Exportador"
string menuname = "m_rpt_smpl"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
dw_report dw_report
end type
global w_cam752_declaracion w_cam752_declaracion

event resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

on w_cam752_declaracion.create
if this.MenuName = "m_rpt_smpl" then this.MenuID = create m_rpt_smpl
this.dw_report=create dw_report
this.Control[]={this.dw_report}
end on

on w_cam752_declaracion.destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_report)
end on

type dw_report from datawindow within w_cam752_declaracion
integer x = 59
integer y = 172
integer width = 2994
integer height = 1724
integer taborder = 10
string title = "none"
string dataobject = "d_rpt_declaracion_rt"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

