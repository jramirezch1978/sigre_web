$PBExportHeader$w_sig770_det_requer_vencidos.srw
forward
global type w_sig770_det_requer_vencidos from w_rpt
end type
type dw_report from u_dw_rpt within w_sig770_det_requer_vencidos
end type
end forward

global type w_sig770_det_requer_vencidos from w_rpt
integer x = 256
integer y = 348
integer width = 3259
integer height = 1912
string title = "Detalle de requerimientos atrasados (SIG770)"
string menuname = "m_rpt_simple"
long backcolor = 12632256
dw_report dw_report
end type
global w_sig770_det_requer_vencidos w_sig770_det_requer_vencidos

type variables

end variables

on w_sig770_det_requer_vencidos.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_simple" then this.MenuID = create m_rpt_simple
this.dw_report=create dw_report
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_report
end on

on w_sig770_det_requer_vencidos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_report)
end on

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report
idw_1.Visible = False
idw_1.SetTransObject(sqlca)
this.Event ue_preview()
This.Event ue_retrieve()
//idw_1.object.p_logo.filename = gs_logo
// ii_help = 101           // help topic


end event

event ue_retrieve;call super::ue_retrieve;String ls_cod_n1, ls_cod_n2, ls_cod_n3
String ls_descripcion

sg_parametros lstr_rep

lstr_rep = message.powerobjectparm

ls_cod_n1 = trim(lstr_rep.string1)
ls_cod_n2 = trim(lstr_rep.string2)
ls_cod_n3 = trim(lstr_rep.string3)

select descrippcion into :ls_descripcion
from cencos_niv3 
where cod_n1=:ls_cod_n1 and cod_n2=:ls_cod_n2 and cod_n3=:ls_cod_n3 ;

idw_1.ii_zoom_actual = 100
ib_preview = false
event ue_preview()

idw_1.Retrieve(ls_cod_n1, ls_cod_n2, ls_cod_n3)
idw_1.Visible = True
idw_1.Object.t_empresa.text = gs_empresa
idw_1.Object.t_user.text = gs_user
idw_1.Object.t_texto.text = 'Requerimientos de :' + trim(ls_descripcion)
idw_1.Object.p_logo.filename = gs_logo

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

type dw_report from u_dw_rpt within w_sig770_det_requer_vencidos
integer y = 8
integer width = 3182
integer height = 1620
boolean bringtotop = true
string dataobject = "d_rpt_niv4_movimientos_atrasados_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event doubleclicked;call super::doubleclicked;String ls_cod_n1
sg_parametros lstr_rep

IF row=0 then return

IF this.Rowcount( ) = 0 then return

end event

