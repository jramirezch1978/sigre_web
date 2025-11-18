$PBExportHeader$w_sig714_atrazo_cobrza_grupo.srw
forward
global type w_sig714_atrazo_cobrza_grupo from w_rpt
end type
type dw_report from u_dw_rpt within w_sig714_atrazo_cobrza_grupo
end type
end forward

global type w_sig714_atrazo_cobrza_grupo from w_rpt
integer x = 256
integer y = 348
integer width = 3639
integer height = 1760
string title = "Atrazo de cobranza de clientes del grupo  (SIG714)"
string menuname = "m_rpt_simple"
long backcolor = 12632256
dw_report dw_report
end type
global w_sig714_atrazo_cobrza_grupo w_sig714_atrazo_cobrza_grupo

on w_sig714_atrazo_cobrza_grupo.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_simple" then this.MenuID = create m_rpt_simple
this.dw_report=create dw_report
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_report
end on

on w_sig714_atrazo_cobrza_grupo.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_report)
end on

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report
idw_1.Visible = False
idw_1.SetTransObject(sqlca)
this.Event ue_preview()
This.Event ue_retrieve()
idw_1.object.p_logo.filename = gs_logo
// ii_help = 101           // help topic


end event

event ue_retrieve;call super::ue_retrieve;String ls_grp_codrel, ls_rubro, ls_texto
Decimal ld_tipo_cambio

sg_parametros lstr_rep

lstr_rep = message.powerobjectparm

ls_grp_codrel = lstr_rep.string1
ls_rubro = lstr_rep.string2

SELECT USF_CNT_TIPO_CAMBIO(sysdate)
INTO :ld_tipo_cambio
FROM dual ;

SELECT descripcion 
  INTO : ls_texto 
  FROM grupo_proveedor 
 WHERE grupo=trim(:ls_grp_codrel) ;

idw_1.ii_zoom_actual = 120
ib_preview = false
event ue_preview()

//idw_1.Retrieve( trim(ls_grp_codrel), trim(ls_rubro), ld_tipo_cambio)
idw_1.Retrieve( trim(ls_grp_codrel), trim(ls_rubro))
idw_1.Visible = True
idw_1.Object.p_logo.filename = gs_logo
idw_1.Object.t_empresa.text = gs_empresa
idw_1.Object.t_user.text = gs_user
idw_1.Object.t_texto.text = ls_texto

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

type dw_report from u_dw_rpt within w_sig714_atrazo_cobrza_grupo
integer y = 4
integer width = 3355
integer height = 1468
boolean bringtotop = true
string dataobject = "d_rpt_det_saldo_cobranza_grupo_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

