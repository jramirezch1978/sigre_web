$PBExportHeader$u_vtb_rpt.sru
forward
global type u_vtb_rpt from vtrackbar
end type
end forward

global type u_vtb_rpt from vtrackbar
integer width = 146
integer height = 512
integer minposition = 75
integer maxposition = 200
integer position = 100
integer tickfrequency = 7
integer pagesize = 10
integer linesize = 50
integer slidersize = 15
end type
global u_vtb_rpt u_vtb_rpt

type variables
Datawindow	idw_report
end variables

event constructor;//idw_report = dw_report
//THIS.MenuID.item[1].item[2].item[5].enabled = FALSE
//THIS.MenuID.item[1].item[2].item[6].enabled = FALSE
//THIS.MenuID.item[1].item[2].item[7].enabled = FALSE
end event

on u_vtb_rpt.create
end on

on u_vtb_rpt.destroy
end on

event linedown;idw_report.Object.DataWindow.Zoom = this.Position
idw_report.Title = "Zoom: " + String ( this.Position ) + "%"
end event

event lineup;idw_report.Object.DataWindow.Zoom = this.Position
idw_report.Title = "Zoom: " + String ( this.Position ) + "%"
end event

event moved;idw_report.Object.DataWindow.Zoom = scrollpos
idw_report.Title = "Zoom: " + String ( this.Position ) + "%"
end event

event pagedown;idw_report.Object.DataWindow.Zoom = this.Position
idw_report.Title = "Zoom: " + String ( this.Position ) + "%"
end event

event pageup;idw_report.Object.DataWindow.Zoom = this.Position
idw_report.Title = "Zoom: " + String ( this.Position ) + "%"
end event

