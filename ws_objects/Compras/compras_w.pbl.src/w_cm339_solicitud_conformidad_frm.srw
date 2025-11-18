$PBExportHeader$w_cm339_solicitud_conformidad_frm.srw
forward
global type w_cm339_solicitud_conformidad_frm from w_rpt
end type
type dw_report from u_dw_rpt within w_cm339_solicitud_conformidad_frm
end type
end forward

global type w_cm339_solicitud_conformidad_frm from w_rpt
integer x = 256
integer y = 348
integer width = 3314
integer height = 1676
string title = "Formato de orden de compra (CM314)"
string menuname = "m_impresion"
long backcolor = 67108864
dw_report dw_report
end type
global w_cm339_solicitud_conformidad_frm w_cm339_solicitud_conformidad_frm

on w_cm339_solicitud_conformidad_frm.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.dw_report=create dw_report
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_report
end on

on w_cm339_solicitud_conformidad_frm.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_report)
end on

event ue_open_pre();call super::ue_open_pre;idw_1 = dw_report
idw_1.Visible = False
idw_1.SetTransObject(sqlca)
this.Event ue_preview()
This.Event ue_retrieve()

// ii_help = 101           // help topic


end event

event ue_retrieve;call super::ue_retrieve;String ls_nro_conformidad

str_parametros lstr_rep

lstr_rep = message.powerobjectparm

ls_nro_conformidad = lstr_rep.string1

idw_1.Retrieve(ls_nro_conformidad)
idw_1.Visible = True
idw_1.Object.p_logo.filename  = gs_logo

end event

event ue_print;call super::ue_print;idw_1.EVENT ue_print()
end event

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

event ue_preview();call super::ue_preview;IF ib_preview THEN
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

type dw_report from u_dw_rpt within w_cm339_solicitud_conformidad_frm
integer y = 4
integer width = 3273
integer height = 1424
boolean bringtotop = true
string dataobject = "d_rpt_acta_conformidad_rpt"
boolean hscrollbar = true
boolean vscrollbar = true
end type

