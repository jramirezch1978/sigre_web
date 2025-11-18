$PBExportHeader$w_fi723_rpt_programacion_pagos_det.srw
forward
global type w_fi723_rpt_programacion_pagos_det from w_rpt
end type
type st_1 from statictext within w_fi723_rpt_programacion_pagos_det
end type
type sle_1 from singlelineedit within w_fi723_rpt_programacion_pagos_det
end type
type cb_1 from commandbutton within w_fi723_rpt_programacion_pagos_det
end type
type dw_report from u_dw_rpt within w_fi723_rpt_programacion_pagos_det
end type
type gb_1 from groupbox within w_fi723_rpt_programacion_pagos_det
end type
end forward

global type w_fi723_rpt_programacion_pagos_det from w_rpt
integer width = 2843
integer height = 1808
string title = "Programación de Pagos Detalle (FI723)"
string menuname = "m_reporte"
long backcolor = 12632256
st_1 st_1
sle_1 sle_1
cb_1 cb_1
dw_report dw_report
gb_1 gb_1
end type
global w_fi723_rpt_programacion_pagos_det w_fi723_rpt_programacion_pagos_det

on w_fi723_rpt_programacion_pagos_det.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.st_1=create st_1
this.sle_1=create sle_1
this.cb_1=create cb_1
this.dw_report=create dw_report
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.sle_1
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.dw_report
this.Control[iCurrent+5]=this.gb_1
end on

on w_fi723_rpt_programacion_pagos_det.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.sle_1)
destroy(this.cb_1)
destroy(this.dw_report)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report

idw_1.SetTransObject(sqlca)



ib_preview = FALSE
THIS.Event ue_preview()

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

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

event ue_print;call super::ue_print;idw_1.EVENT ue_print()
end event

event ue_mail_send;String		ls_ini_file, ls_file, ls_name, ls_address, ls_subject, &
            ls_note, ls_path, ls_type, ls_format
Double	ldb_rc
n_cst_email	lnv_mail
n_cst_api	lnv_api

lnv_mail = CREATE n_cst_email
lnv_api  = CREATE n_cst_api

ls_subject = THIS.Title
ls_path = 'c:\report.'
ls_file = 'report.'

// Consulta de formato del archivo
OpenWithParm(w_saveas_opt, THIS)

ldb_rc = Message.DoubleParm

IF ldb_rc = -1 Then 	RETURN

// Creacion del Archivo
CHOOSE CASE ldb_rc
	CASE 1
		ls_type = 'html'
		ls_path = ls_path + ls_type
		idw_1.SaveAs(ls_path, HTMLTable!, True)
	CASE 2
		ls_type = 'xls'
		ls_path = ls_path + ls_type
		idw_1.SaveAs(ls_path, Excel5!, True)
	CASE 3
		ls_type = 'pdf'
		ls_path = ls_path + ls_type
		idw_1.SaveAs(ls_path, PDF!, True)
END CHOOSE

ls_file = ls_file + ls_type

lnv_mail.of_logon()
lnv_mail.of_send_mail(ls_name, ls_address, ls_subject, ls_note, ls_file, ls_path)
lnv_mail.of_logoff()
lnv_api.of_file_delete(ls_path)

DESTROY lnv_mail
DESTROY lnv_api
end event

type st_1 from statictext within w_fi723_rpt_programacion_pagos_det
integer x = 87
integer y = 96
integer width = 343
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Nro Programa :"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_1 from singlelineedit within w_fi723_rpt_programacion_pagos_det
integer x = 443
integer y = 84
integer width = 343
integer height = 80
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
integer limit = 10
borderstyle borderstyle = stylelowered!
end type

type cb_1 from commandbutton within w_fi723_rpt_programacion_pagos_det
integer x = 2373
integer y = 64
integer width = 402
integer height = 112
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Procesar"
end type

event clicked;String ls_prog_pago

ls_prog_pago = sle_1.text



IF Isnull(ls_prog_pago) OR Trim(ls_prog_pago) = '' THEN
	Messagebox('Aviso','Debe Ingresar Nro de Programa de Pago , Verifique!')
	Return
END IF

DECLARE PB_usp_fin_rpt_programacion_pagos PROCEDURE FOR usp_fin_rpt_programacion_pagos
(:ls_prog_pago);
EXECUTE PB_usp_fin_rpt_programacion_pagos ;

IF SQLCA.SQLCode = -1 THEN 
	Rollback ;
	MessageBox('Fallo Store Procedure','Store Procedure usp_fin_rpt_programacion_pagos , Comunicar en Area de Sistemas' )
END IF


CLOSE PB_usp_fin_rpt_programacion_pagos ;



dw_report.retrieve()
dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_nombre.text = gs_empresa
dw_report.object.t_user.text = gs_user


ib_preview = FALSE
parent.Event ue_preview()
end event

type dw_report from u_dw_rpt within w_fi723_rpt_programacion_pagos_det
integer x = 18
integer y = 308
integer width = 2757
integer height = 1324
string dataobject = "d_rpt_programacion_pagos_tbl"
boolean vscrollbar = true
end type

type gb_1 from groupbox within w_fi723_rpt_programacion_pagos_det
integer x = 37
integer y = 32
integer width = 951
integer height = 160
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Datos"
end type

