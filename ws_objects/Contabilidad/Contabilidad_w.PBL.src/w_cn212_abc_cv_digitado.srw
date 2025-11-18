$PBExportHeader$w_cn212_abc_cv_digitado.srw
forward
global type w_cn212_abc_cv_digitado from w_abc_master_smpl
end type
end forward

global type w_cn212_abc_cv_digitado from w_abc_master_smpl
integer width = 1399
integer height = 1496
string title = "(CN212) Movimiento Digitado"
string menuname = "m_abc_modifica"
end type
global w_cn212_abc_cv_digitado w_cn212_abc_cv_digitado

on w_cn212_abc_cv_digitado.create
call super::create
if this.MenuName = "m_abc_modifica" then this.MenuID = create m_abc_modifica
end on

on w_cn212_abc_cv_digitado.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_modify;call super::ue_modify;String ls_protect

ls_protect=dw_master.Describe("tipo_operacion.protect")
IF ls_protect='0' THEN
   dw_master.of_column_protect('tipo_operacion')
END IF

ls_protect=dw_master.Describe("cod_frmt.protect")
IF ls_protect='0' THEN
   dw_master.of_column_protect('cod_frmt')
END IF

ls_protect=dw_master.Describe("linea.protect")
IF ls_protect='0' THEN
   dw_master.of_column_protect('linea')
END IF

ls_protect=dw_master.Describe("columna.protect")
IF ls_protect='0' THEN
   dw_master.of_column_protect('columna')
END IF

end event

event ue_open_pre();call super::ue_open_pre;// Centra pantalla
long ll_x,ll_y
ll_x = (w_main.WorkSpaceWidth() - This.WorkSpaceWidth()) / 2
ll_y = ((w_main.WorkSpaceHeight() - This.WorkSpaceHeight()) / 2) - 150
This.move(ll_x,ll_y)

end event

event resize;// Override
end event

type dw_master from w_abc_master_smpl`dw_master within w_cn212_abc_cv_digitado
integer x = 0
integer y = 0
integer width = 1353
integer height = 1312
string dataobject = "d_abc_cv_digitado_tbl"
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
end event

