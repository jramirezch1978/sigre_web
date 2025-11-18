$PBExportHeader$w_ope746_presp_art_activos_pend.srw
forward
global type w_ope746_presp_art_activos_pend from w_rpt
end type
type dw_report from u_dw_rpt within w_ope746_presp_art_activos_pend
end type
end forward

global type w_ope746_presp_art_activos_pend from w_rpt
integer width = 3365
integer height = 2716
string title = "Partidas Presupuestales x Requerimiento (OPE746)"
string menuname = "m_rpt_smpl"
long backcolor = 12632256
dw_report dw_report
end type
global w_ope746_presp_art_activos_pend w_ope746_presp_art_activos_pend

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report
idw_1.Visible = True
idw_1.SetTransObject(sqlca)

//ib_preview = false

//THIS.Event ue_preview()
This.Event ue_retrieve()


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

on w_ope746_presp_art_activos_pend.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_smpl" then this.MenuID = create m_rpt_smpl
this.dw_report=create dw_report
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_report
end on

on w_ope746_presp_art_activos_pend.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_report)
end on

event ue_retrieve;call super::ue_retrieve;String ls_msj_err,ls_nada

SetPointer(hourglass!)


DECLARE PB_usp_ope_evaluacion_pto_all PROCEDURE FOR usp_ope_evaluacion_pto_all
(:ls_nada);
EXECUTE PB_usp_ope_evaluacion_pto_all ;


IF SQLCA.SQLCode = -1 THEN 
	ls_msj_err = SQLCA.SQLErrText
	Rollback ;
   MessageBox('SQL error', ls_msj_err)
END IF


Close PB_usp_ope_evaluacion_pto_all ;

SetPointer(Arrow!)


dw_report.retrieve()
dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_nombre.text = gs_empresa
dw_report.object.t_user.text = gs_user
end event

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

event ue_print;call super::ue_print;idw_1.EVENT ue_print()
end event

event ue_filter;call super::ue_filter;
dw_report.Groupcalc( )
end event

type dw_report from u_dw_rpt within w_ope746_presp_art_activos_pend
integer x = 23
integer y = 140
integer width = 3273
integer height = 2336
string dataobject = "d_rpt_part_presp_req_art_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event doubleclicked;call super::doubleclicked;String ls_flag_control,ls_cencos,ls_cnta_prsp,ls_flag_trim,ls_monto_disp
Long	 ll_ano,ll_mes

str_cns_pop lstr_1

if row = 0 then return

This.SelectRow(0, False)
This.SelectRow(row, True)

ls_flag_control = this.object.flag_control [row]
ls_flag_trim	 = this.object.flag_trim	 [row]
ls_cencos		 = this.object.cencos		 [row]
ls_cnta_prsp	 = this.object.cnta_prsp 	 [row]
ll_ano			 = this.object.ano 			 [row]
ll_mes			 = this.object.mes 			 [row]
ls_monto_disp	 = String(this.object.monto_real	 [row])

CHOOSE CASE dwo.Name
	CASE "saldo_proy" 
	if ls_flag_control     = '1' then //control anual
		lstr_1.DataObject = 'd_rpt_art_requeridos_x_ctrl_anual_tbl'
		lstr_1.Width = 3600
		lstr_1.Height= 1700
		lstr_1.title = 'Lista de Articulos Pendientes - Activos '
		lstr_1.tipo_cascada = 'R'
		lstr_1.arg [1] = ls_cencos
		lstr_1.arg [2] = ls_cnta_prsp
		lstr_1.arg [3] = Trim(String(ll_ano))
		lstr_1.arg [4] = ls_flag_control
		lstr_1.arg [5] = ls_monto_disp
		of_new_sheet(lstr_1)
	elseif ls_flag_control = '2' then //acumulado ala fecha
		lstr_1.DataObject = 'd_rpt_art_requeridos_x_ctrl_afecha_tbl'
		lstr_1.Width = 3450
		lstr_1.Height= 1700
		lstr_1.title = 'Lista de Articulos Pendientes - Activos '
		lstr_1.tipo_cascada = 'R'
		lstr_1.arg [1] = ls_cencos
		lstr_1.arg [2] = ls_cnta_prsp
		lstr_1.arg [3] = Trim(String(ll_ano))
		lstr_1.arg [4] = ls_flag_control
		lstr_1.arg [5] = ls_monto_disp
		of_new_sheet(lstr_1)
	elseif ls_flag_control = '3' then //control mensual
		lstr_1.DataObject = 'd_rpt_art_requeridos_x_ctrl_mensual_tbl'
		lstr_1.Width = 3800
		lstr_1.Height= 1700
		lstr_1.title = 'Lista de Articulos Pendientes - Activos '
		lstr_1.tipo_cascada = 'R'
		lstr_1.arg [1] = ls_cencos
		lstr_1.arg [2] = ls_cnta_prsp
		lstr_1.arg [3] = Trim(String(ll_ano))
		lstr_1.arg [4] = Trim(String(ll_mes))
		lstr_1.arg [5] = ls_flag_control
		lstr_1.arg [6] = ls_monto_disp
		of_new_sheet(lstr_1)
	elseif ls_flag_control = '0' then //partida no existe 
		lstr_1.DataObject = 'd_rpt_art_requeridos_sin_ctrl_tbl'
		lstr_1.Width = 3450
		lstr_1.Height= 1700
		lstr_1.title = 'Lista de Articulos Pendientes - Activos '
		lstr_1.tipo_cascada = 'R'
		lstr_1.arg [1] = ls_cencos
		lstr_1.arg [2] = ls_cnta_prsp
		lstr_1.arg [3] = Trim(String(ll_ano))
		lstr_1.arg [4] = Trim(String(ll_mes))
		lstr_1.arg [5] = ls_flag_control
		of_new_sheet(lstr_1)
	elseif ls_flag_control = '4' then //trimestre fijo
		lstr_1.DataObject = 'd_rpt_art_requerido_x_ctrl_trim_tbl'
		lstr_1.Width = 3450
		lstr_1.Height= 1700
		lstr_1.title = 'Lista de Articulos Pendientes - Activos '
		lstr_1.tipo_cascada = 'R'
		lstr_1.arg [1] = ls_cencos
		lstr_1.arg [2] = ls_cnta_prsp
		lstr_1.arg [3] = Trim(String(ll_ano))
		lstr_1.arg [4] = ls_flag_trim
		lstr_1.arg [5] = ls_flag_control
		lstr_1.arg [6] = ls_monto_disp
		of_new_sheet(lstr_1)	
	end if 	

END CHOOSE
end event

