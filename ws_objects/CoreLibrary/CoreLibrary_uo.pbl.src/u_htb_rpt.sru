$PBExportHeader$u_htb_rpt.sru
forward
global type u_htb_rpt from htrackbar
end type
end forward

global type u_htb_rpt from htrackbar
integer width = 585
integer height = 128
integer minposition = 75
integer maxposition = 200
integer position = 100
integer tickfrequency = 7
integer pagesize = 10
integer linesize = 50
integer slidersize = 15
end type
global u_htb_rpt u_htb_rpt

type variables
Datawindow	idw_report
end variables

event lineleft;idw_report.Object.DataWindow.Zoom = this.Position
idw_report.Title = "Zoom: " + String ( this.Position ) + "%"

end event

on u_htb_rpt.create
end on

on u_htb_rpt.destroy
end on

event lineright;idw_report.Object.DataWindow.Zoom = this.Position
idw_report.Title = "Zoom: " + String ( this.Position ) + "%"
end event

event pageleft;idw_report.Object.DataWindow.Zoom = this.Position
idw_report.Title = "Zoom: " + String ( this.Position ) + "%"
end event

event pageright;idw_report.Object.DataWindow.Zoom = this.Position
idw_report.Title = "Zoom: " + String ( this.Position ) + "%"
end event

event moved;idw_report.Object.DataWindow.Zoom = scrollpos
idw_report.Title = "Zoom: " + String ( this.Position ) + "%"
end event

event constructor;//idw_report = dw_report
//THIS.MenuID.item[1].item[2].item[5].enabled = FALSE
//THIS.MenuID.item[1].item[2].item[6].enabled = FALSE
//THIS.MenuID.item[1].item[2].item[7].enabled = FALSE
end event

