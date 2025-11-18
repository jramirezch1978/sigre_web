$PBExportHeader$w_sig002_abc_parametros_fce.srw
forward
global type w_sig002_abc_parametros_fce from w_abc_master_smpl
end type
end forward

global type w_sig002_abc_parametros_fce from w_abc_master_smpl
integer width = 3570
integer height = 1488
string title = "Parametros de indicadores de gestión (SIG002)"
string menuname = "m_abc_mantenimiento"
end type
global w_sig002_abc_parametros_fce w_sig002_abc_parametros_fce

on w_sig002_abc_parametros_fce.create
call super::create
if this.MenuName = "m_abc_mantenimiento" then this.MenuID = create m_abc_mantenimiento
end on

on w_sig002_abc_parametros_fce.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_modify;call super::ue_modify;Int li_protect

li_protect = integer(dw_master.Object.sig_fce.Protect)

IF li_protect = 0 THEN
   dw_master.Object.sig_fce.Protect = 1
END IF 

end event

type dw_master from w_abc_master_smpl`dw_master within w_sig002_abc_parametros_fce
integer width = 3438
integer height = 1276
string dataobject = "d_abc_parametros_fce_tbl"
end type

event dw_master::constructor;call super::constructor;is_dwform = 'tabular'	
ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
ii_ck[1] = 1				// columnas de lectura de este dw

end event

