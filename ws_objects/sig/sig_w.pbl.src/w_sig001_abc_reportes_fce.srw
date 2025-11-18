$PBExportHeader$w_sig001_abc_reportes_fce.srw
forward
global type w_sig001_abc_reportes_fce from w_abc_master_smpl
end type
end forward

global type w_sig001_abc_reportes_fce from w_abc_master_smpl
integer width = 2002
string title = "Reportes de factores claves de exito (SIG001)"
string menuname = "m_abc_mantenimiento"
long backcolor = 15793151
end type
global w_sig001_abc_reportes_fce w_sig001_abc_reportes_fce

on w_sig001_abc_reportes_fce.create
call super::create
if this.MenuName = "m_abc_mantenimiento" then this.MenuID = create m_abc_mantenimiento
end on

on w_sig001_abc_reportes_fce.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_modify;call super::ue_modify;Int li_protect

li_protect = integer(dw_master.Object.sig_rep.Protect)

IF li_protect = 0 THEN
   dw_master.Object.sig_rep.Protect = 1
END IF 

end event

type dw_master from w_abc_master_smpl`dw_master within w_sig001_abc_reportes_fce
integer width = 1915
string dataobject = "d_abc_reporte_fce_tbl"
end type

event dw_master::constructor;call super::constructor;is_dwform = 'tabular'	
ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
ii_ck[1] = 1				// columnas de lectura de este dw

end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;if dw_master.GetRow() = 0 then return

dw_master.object.flag_estado[al_row]='1'
end event

