$PBExportHeader$w_ope741_rpt_error.srw
forward
global type w_ope741_rpt_error from w_report_smpl
end type
end forward

global type w_ope741_rpt_error from w_report_smpl
integer x = 329
integer y = 188
integer width = 1856
integer height = 1716
string title = "Reporte de errores (OPE741)"
string menuname = "m_rpt_smpl"
windowstate windowstate = maximized!
long backcolor = 12632256
end type
global w_ope741_rpt_error w_ope741_rpt_error

type variables
sg_parametros_est istr_1
end variables

event ue_open_pre;call super::ue_open_pre;Long	ll_row, ll_total

istr_1 = Message.PowerObjectParm					// lectura de parametros

This.Event ue_retrieve()
of_position(0,0)
// ii_help = 101           // help topic


end event

event ue_retrieve;call super::ue_retrieve;String ls_texto, ls_codigo

// Por administrador de orden de trabajo
IF TRIM(istr_1.string1)='1' THEN
	ls_texto = 'Administrador de Orden de trabajo ' + TRIM(istr_1.string2)
ELSE
// Por orden de trabajo
	ls_texto = 'Orden de trabajo ' + TRIM(istr_1.string2)
END IF

idw_1.Retrieve()
idw_1.Visible = True
idw_1.object.p_logo.filename = gs_logo
idw_1.object.t_empresa.text = gs_empresa
idw_1.object.t_user.text = gs_user
idw_1.object.t_texto.text = ls_texto
end event

on w_ope741_rpt_error.create
call super::create
if this.MenuName = "m_rpt_smpl" then this.MenuID = create m_rpt_smpl
end on

on w_ope741_rpt_error.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;//IF f_access(gs_user, THIS.ClassName(), is_niveles) THEN 
	THIS.EVENT ue_open_pre()
//ELSE
//	CLOSE(THIS)
//END IF
end event

type dw_report from w_report_smpl`dw_report within w_ope741_rpt_error
integer width = 1778
integer height = 1520
string dataobject = "d_rpt_error_tbl"
end type

event dw_report::constructor;call super::constructor;is_dwform = 'form'  
idw_1 = This
end event

