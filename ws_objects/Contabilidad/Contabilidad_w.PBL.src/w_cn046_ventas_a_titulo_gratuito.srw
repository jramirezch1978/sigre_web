$PBExportHeader$w_cn046_ventas_a_titulo_gratuito.srw
forward
global type w_cn046_ventas_a_titulo_gratuito from w_abc_master_smpl
end type
end forward

global type w_cn046_ventas_a_titulo_gratuito from w_abc_master_smpl
integer width = 3022
integer height = 952
string title = "(CN046) Ventas a Título Gratuito"
string menuname = "m_master_smpl"
end type
global w_cn046_ventas_a_titulo_gratuito w_cn046_ventas_a_titulo_gratuito

on w_cn046_ventas_a_titulo_gratuito.create
call super::create
if this.MenuName = "m_master_smpl" then this.MenuID = create m_master_smpl
end on

on w_cn046_ventas_a_titulo_gratuito.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_modify;call super::ue_modify;String ls_protect
ls_protect=dw_master.Describe("forma_pago.protect")
IF ls_protect='0' THEN
   dw_master.of_column_protect('forma_pago')
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

type dw_master from w_abc_master_smpl`dw_master within w_cn046_ventas_a_titulo_gratuito
integer x = 50
integer y = 44
integer width = 2880
integer height = 676
string dataobject = "d_venta_titulo_gratuito_tbl"
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;dw_master.Modify("forma_pago.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("desc_forma_pago.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("flag_estado.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("flag_no_cobrable.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("nro_libro.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("cnta_igv_debe.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("cnta_igv_haber.Protect='1~tIf(IsRowNew(),0,1)'")

end event

