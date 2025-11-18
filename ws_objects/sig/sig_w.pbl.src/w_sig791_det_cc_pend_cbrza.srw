$PBExportHeader$w_sig791_det_cc_pend_cbrza.srw
forward
global type w_sig791_det_cc_pend_cbrza from w_rpt
end type
type dw_report from u_dw_rpt within w_sig791_det_cc_pend_cbrza
end type
end forward

global type w_sig791_det_cc_pend_cbrza from w_rpt
integer x = 256
integer y = 348
integer width = 3328
integer height = 1252
string title = "Resumen anticipos por pagar contable (SIG791)"
string menuname = "m_rpt_simple"
long backcolor = 12632256
dw_report dw_report
end type
global w_sig791_det_cc_pend_cbrza w_sig791_det_cc_pend_cbrza

type variables
String is_tipo, is_grp_codrel, is_flag_cc

end variables

on w_sig791_det_cc_pend_cbrza.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_simple" then this.MenuID = create m_rpt_simple
this.dw_report=create dw_report
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_report
end on

on w_sig791_det_cc_pend_cbrza.destroy
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

event ue_retrieve;call super::ue_retrieve;String ls_reporte, ls_texto, ls_clase_pptt, ls_clase_sub_pptt, ls_clase, ls_tipo
Date ld_fecha_ini, ld_fecha_fin
sg_parametros lstr_rep

lstr_rep = message.powerobjectparm

ls_tipo	= lstr_rep.string1


ld_fecha_ini = w_sig791_fce_finanzas.uo_1.of_get_fecha1()
ld_fecha_fin = w_sig791_fce_finanzas.uo_1.of_get_fecha2()

is_grp_codrel = w_sig791_fce_finanzas.em_grp_codrel.text
is_flag_cc	  = w_sig791_fce_finanzas.em_flag_cc.text

ls_texto = 'Del '+string(ld_fecha_ini,'dd/mm/yyyy')+' al '+string(ld_fecha_fin,'dd/mm/yyyy')

IF ls_tipo = 'C' THEN
	
	select clase_prod_term, clase_sub_prod 
	  into :ls_clase_pptt, :ls_clase_sub_pptt 
	  from SIGPARAM 
	 where reckey='1' ;
		
	IF is_flag_cc ='P' THEN
		ls_clase=ls_clase_pptt 
	ELSEIF is_flag_cc ='S' THEN
		ls_clase=ls_clase_sub_pptt 
	ELSE 
		ls_clase='%'
	END IF
		
	idw_1.DataObject='d_rpt_sig_sdo_cc_clase_cred'
	idw_1.SetTransObject(sqlca)
	
//	lstr_rep = message.powerobjectparm
//	
//	is_tipo		= lstr_rep.string1
//	
	idw_1.ii_zoom_actual = 100
	ib_preview = false
	event ue_preview()
	
	idw_1.Retrieve(is_grp_codrel, ls_clase)
END IF

idw_1.Visible = True
idw_1.Object.t_empresa.text = gs_empresa
idw_1.Object.t_user.text = gs_user
idw_1.Object.t_texto.text = ls_texto
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

type dw_report from u_dw_rpt within w_sig791_det_cc_pend_cbrza
integer y = 8
integer width = 3049
integer height = 1028
boolean bringtotop = true
string dataobject = "d_rpt_sig_sdo_cc_clase_cred"
boolean hscrollbar = true
boolean vscrollbar = true
end type

