$PBExportHeader$w_sig791_det_saldo_anticipos.srw
forward
global type w_sig791_det_saldo_anticipos from w_rpt
end type
type dw_report from u_dw_rpt within w_sig791_det_saldo_anticipos
end type
end forward

global type w_sig791_det_saldo_anticipos from w_rpt
integer x = 256
integer y = 348
integer width = 3365
integer height = 1912
string title = "Detalle de anticipos por pagar (SIG791)"
string menuname = "m_rpt_simple"
long backcolor = 12632256
dw_report dw_report
end type
global w_sig791_det_saldo_anticipos w_sig791_det_saldo_anticipos

type variables

end variables

on w_sig791_det_saldo_anticipos.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_simple" then this.MenuID = create m_rpt_simple
this.dw_report=create dw_report
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_report
end on

on w_sig791_det_saldo_anticipos.destroy
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

event ue_retrieve;call super::ue_retrieve;String ls_tipo_doc, ls_doc_anticipo_oc, ls_doc_anticipo_os, ls_doc_anticipo_og, ls_texto
String ls_grupo_contable
Long ll_dias, ll_ano
sg_parametros lstr_rep

lstr_rep = message.powerobjectparm

ls_tipo_doc = trim(lstr_rep.string1)
ll_dias     = lstr_rep.long1
ll_ano 		= Long(lstr_rep.string2)
//Colocarlo en parametros
ls_grupo_contable = '38'

select f.doc_anticipo_oc, f.doc_anticipo_os, f.doc_sol_giro 
  into :ls_doc_anticipo_oc, :ls_doc_anticipo_os, :ls_doc_anticipo_og
  from finparam f 
 where reckey='1' ;

IF ls_tipo_doc = ls_doc_anticipo_os THEN
	ls_texto = 'ANTICIPO DE ORDEN DE SERVICIO'
	idw_1.dataobject = 'd_rpt_fce_saldo_det_anticipo_oc_tbl'
ELSEIF ls_tipo_doc = ls_doc_anticipo_oc THEN
	ls_texto = 'ANTICIPO DE ORDEN DE COMPRA'
	idw_1.dataobject = 'd_rpt_fce_saldo_det_anticipo_oc_tbl'	
ELSE
	ls_texto = 'ORDEN DE GIRO'
	idw_1.dataobject = 'd_rpt_fce_saldo_det_anticipo_og_tbl'
END IF 

idw_1.SettransObject(sqlca)

idw_1.ii_zoom_actual = 100
ib_preview = false
event ue_preview()

IF ls_tipo_doc = ls_doc_anticipo_oc THEN
	idw_1.Retrieve(ls_tipo_doc, ll_dias)
ELSEIF ls_tipo_doc = ls_doc_anticipo_os THEN
	idw_1.Retrieve(ls_tipo_doc, ll_dias)	
ELSE	
	idw_1.Retrieve(ls_tipo_doc, ls_grupo_contable, ll_ano)
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

type dw_report from u_dw_rpt within w_sig791_det_saldo_anticipos
integer y = 8
integer width = 3237
integer height = 1620
boolean bringtotop = true
string dataobject = "d_rpt_fce_saldo_det_anticipo_oc_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event doubleclicked;call super::doubleclicked;//String ls_cod_relacion
//
//sg_parametros lstr_rep1
//
//ls_cod_relacion = this.object.cod_relacion[row]
//
//lstr_rep1.string1 = ls_cod_relacion
//lstr_rep1.long1 = il_factor
//
//OpenSheetWithParm(w_sig725_cnta_cobrar_sem_det, lstr_rep1, w_main, 2, layered!)
//
end event

