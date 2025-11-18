$PBExportHeader$w_cm751_usr_adm_ot.srw
forward
global type w_cm751_usr_adm_ot from w_rpt
end type
type dw_report from u_dw_rpt within w_cm751_usr_adm_ot
end type
end forward

global type w_cm751_usr_adm_ot from w_rpt
integer x = 283
integer y = 248
integer width = 3150
integer height = 1408
string title = "Usuarios x OT_ADM [CM751]"
string menuname = "m_impresion"
long backcolor = 79741120
dw_report dw_report
end type
global w_cm751_usr_adm_ot w_cm751_usr_adm_ot

type variables

end variables

on w_cm751_usr_adm_ot.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.dw_report=create dw_report
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_report
end on

on w_cm751_usr_adm_ot.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_report)
end on

event ue_open_pre;call super::ue_open_pre;str_parametros lstr_param

idw_1 = dw_report
ii_help = 101           // help topic

	
this.event ue_retrieve()

end event

event ue_retrieve;call super::ue_retrieve;
idw_1.SetTransObject(SQLCA)
idw_1.Object.p_logo.filename = gs_logo
idw_1.object.t_user.text     = gs_user
idw_1.object.t_empresa.text  = gs_empresa
idw_1.object.t_codigo.text   = string(ClassName()) 

idw_1.Retrieve()

idw_1.Visible = True




end event

event resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y


end event

event ue_print();call super::ue_print;dw_report.EVENT ue_print()
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

type dw_report from u_dw_rpt within w_cm751_usr_adm_ot
integer width = 3049
integer height = 1196
boolean bringtotop = true
string dataobject = "d_rpt_usr_adm_ot"
boolean hscrollbar = true
boolean vscrollbar = true
end type

