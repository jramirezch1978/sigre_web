$PBExportHeader$w_pt012_roles.srw
forward
global type w_pt012_roles from w_abc_mastdet_smpl
end type
end forward

global type w_pt012_roles from w_abc_mastdet_smpl
integer width = 1920
integer height = 1640
string title = "Roles para Presupuesto (PT012)"
string menuname = "m_mantenimiento_sl"
end type
global w_pt012_roles w_pt012_roles

on w_pt012_roles.create
call super::create
if this.MenuName = "m_mantenimiento_sl" then this.MenuID = create m_mantenimiento_sl
end on

on w_pt012_roles.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_update_pre;call super::ue_update_pre;// Verifica que campos son requeridos y tengan valores
ib_update_check = False
if f_row_Processing( dw_master, "form") <> true then	
	return
end if	

if f_row_Processing( dw_detail, "form") <> true then	
	return
end if	

ib_update_check = true

end event

type dw_master from w_abc_mastdet_smpl`dw_master within w_pt012_roles
integer x = 0
integer y = 4
integer width = 1806
integer height = 808
string dataobject = "d_abc_roles"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1			// columnas de lectrua de este dw
ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
//idw_det  =  				// dw_detail
end event

event dw_master::itemerror;call super::itemerror;return 1
end event

event dw_master::ue_output;call super::ue_output;THIS.EVENT ue_retrieve_det(al_row)


end event

event dw_master::ue_retrieve_det_pos;call super::ue_retrieve_det_pos;idw_det.retrieve(aa_id[1])
end event

type dw_detail from w_abc_mastdet_smpl`dw_detail within w_pt012_roles
integer x = 0
integer y = 824
integer width = 1819
integer height = 624
string dataobject = "d_abc_rol_cnta_prsp"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_detail::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw
ii_ck[3] = 3				// columnas de lectrua de este dw

ii_rk[1] = 1 	      // columnas que recibimos del master

end event

event dw_detail::itemerror;call super::itemerror;return 1
end event

event dw_detail::doubleclicked;call super::doubleclicked;// Abre ventana pop
str_parametros sl_param

sl_param.dw1 		= "d_list_cencos_cnta_prsp_tbl"
sl_param.titulo 	= "Cencos - Cnta Prsp"
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2
sl_param.field_ret_i[3] = 3
sl_param.field_ret_i[4] = 4

OpenWithParm( w_lista, sl_param)
sl_param = MESSAGE.POWEROBJECTPARM
if sl_param.titulo <> 'n' then	
	// Se ubica la cabecera
	this.object.cencos 			[row] = sl_param.field_ret[1]
	this.object.desc_cencos 	[row] = sl_param.field_ret[2]
	this.object.cnta_prsp 		[row] = sl_param.field_ret[3]
	this.object.desc_cnta_prsp [row] = sl_param.field_ret[4]
END IF
end event

