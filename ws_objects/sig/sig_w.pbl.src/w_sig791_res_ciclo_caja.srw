$PBExportHeader$w_sig791_res_ciclo_caja.srw
forward
global type w_sig791_res_ciclo_caja from w_rpt
end type
type dw_report from u_dw_rpt within w_sig791_res_ciclo_caja
end type
end forward

global type w_sig791_res_ciclo_caja from w_rpt
integer x = 256
integer y = 348
integer width = 3127
integer height = 1252
string title = "Resumen anticipos por pagar contable (SIG791)"
string menuname = "m_rpt_simple"
long backcolor = 12632256
dw_report dw_report
end type
global w_sig791_res_ciclo_caja w_sig791_res_ciclo_caja

type variables
String is_tipo
Date id_fec_ini, id_fec_fin
end variables

on w_sig791_res_ciclo_caja.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_simple" then this.MenuID = create m_rpt_simple
this.dw_report=create dw_report
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_report
end on

on w_sig791_res_ciclo_caja.destroy
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

event ue_retrieve;call super::ue_retrieve;String ls_reporte, ls_texto
Date ld_fecha_ini, ld_fecha_fin
sg_parametros lstr_rep


id_fec_ini = w_sig791_fce_finanzas.uo_1.of_get_fecha1()
id_fec_fin = w_sig791_fce_finanzas.uo_1.of_get_fecha2()

ls_texto = 'Del '+string(id_fec_ini,'dd/mm/yyyy')+' al '+string(id_fec_fin,'dd/mm/yyyy')

lstr_rep = message.powerobjectparm

is_tipo		= lstr_rep.string1

idw_1.ii_zoom_actual = 100
ib_preview = false
event ue_preview()

idw_1.Retrieve(is_tipo)
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

type dw_report from u_dw_rpt within w_sig791_res_ciclo_caja
integer y = 8
integer width = 3049
integer height = 1028
boolean bringtotop = true
string dataobject = "d_rpt_sig_ciclo_caja_ff"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event doubleclicked;call super::doubleclicked;Decimal ld_pendiente_cbrza, ld_ventas_credito
sg_parametros lstr_rep

if row=0 then return

IF this.Rowcount( ) = 0 then return

lstr_rep.string1 = is_tipo

CHOOSE CASE dwo.name
		 CASE 'pendiente_cbrza'
				OpenSheetWithParm(w_sig791_det_cc_pend_cbrza, lstr_rep, w_main, 2, layered!)					
		 CASE 'ventas_credito'
				OpenSheetWithParm(w_sig791_det_cc_vta_cred, lstr_rep, w_main, 2, layered!)					
END CHOOSE
				
end event

