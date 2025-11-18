$PBExportHeader$w_sig003_abc_fce_x_reporte.srw
forward
global type w_sig003_abc_fce_x_reporte from w_abc_master_smpl
end type
end forward

global type w_sig003_abc_fce_x_reporte from w_abc_master_smpl
integer width = 3589
integer height = 1580
string title = "Factores de gestión por reporte (SIG003)"
string menuname = "m_abc_mantenimiento"
long backcolor = 15793151
end type
global w_sig003_abc_fce_x_reporte w_sig003_abc_fce_x_reporte

on w_sig003_abc_fce_x_reporte.create
call super::create
if this.MenuName = "m_abc_mantenimiento" then this.MenuID = create m_abc_mantenimiento
end on

on w_sig003_abc_fce_x_reporte.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_modify;call super::ue_modify;Int li_protect

li_protect = integer(dw_master.Object.sig_rep.Protect)

IF li_protect = 0 THEN
   dw_master.Object.sig_rep.Protect = 1
END IF 

li_protect = integer(dw_master.Object.sig_fce.Protect)

IF li_protect = 0 THEN
   dw_master.Object.sig_fce.Protect = 1
END IF 

end event

type dw_master from w_abc_master_smpl`dw_master within w_sig003_abc_fce_x_reporte
integer width = 3502
integer height = 1360
string dataobject = "d_abc_fce_x_reporte_tbl"
end type

event dw_master::constructor;call super::constructor;is_dwform = 'tabular'	
ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
ii_ck[1] = 1				// columnas de lectura de este dw

end event

