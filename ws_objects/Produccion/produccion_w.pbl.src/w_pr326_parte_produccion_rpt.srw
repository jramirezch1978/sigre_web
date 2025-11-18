$PBExportHeader$w_pr326_parte_produccion_rpt.srw
forward
global type w_pr326_parte_produccion_rpt from w_report_smpl
end type
end forward

global type w_pr326_parte_produccion_rpt from w_report_smpl
integer width = 1737
integer height = 1596
string title = "[PR326] Impresión Parte de Recepción de Materia Prima"
string menuname = "m_impresion_2"
end type
global w_pr326_parte_produccion_rpt w_pr326_parte_produccion_rpt

on w_pr326_parte_produccion_rpt.create
call super::create
if this.MenuName = "m_impresion_2" then this.MenuID = create m_impresion_2
end on

on w_pr326_parte_produccion_rpt.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre;call super::ue_open_pre;This.Event ue_retrieve()
end event

event ue_retrieve;call super::ue_retrieve;string ls_nro_parte, ls_mensaje
str_parametros lstr_rep

lstr_rep = message.powerobjectparm
//this.Event ue_preview()
ls_nro_parte = lstr_rep.string1


DECLARE PB_USP_PROD_RESUMEN_PARTE_PROD PROCEDURE FOR 
	USP_PROD_RESUM_PARTE_PROD(:ls_nro_parte) ;
EXECUTE PB_USP_PROD_RESUMEN_PARTE_PROD ;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE USP_RH_CAL_BORRA_MOV_CALCULO: " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	return 
END IF

CLOSE PB_USP_PROD_RESUMEN_PARTE_PROD;

dw_report.Retrieve(ls_nro_parte)
idw_1.Visible = True
//idw_1.Object.p_logo.filename  = gs_logo
//idw_1.object.t_empresa.text	= ls_nom_empresa
//idw_1.object.t_user.text	= gs_user


end event

type dw_report from w_report_smpl`dw_report within w_pr326_parte_produccion_rpt
integer width = 1655
integer height = 1316
string dataobject = "d_rpt_parte_prod_mp_tbl"
end type

