$PBExportHeader$w_cn012_seguimiento.srw
forward
global type w_cn012_seguimiento from w_abc_mastdet_smpl
end type
end forward

global type w_cn012_seguimiento from w_abc_mastdet_smpl
integer width = 1691
integer height = 1188
string title = "Seguimientos (CN012)"
string menuname = "m_abc_master_smpl"
end type
global w_cn012_seguimiento w_cn012_seguimiento

on w_cn012_seguimiento.create
call super::create
if this.MenuName = "m_abc_master_smpl" then this.MenuID = create m_abc_master_smpl
end on

on w_cn012_seguimiento.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre();call super::ue_open_pre;// Centra pantalla
long ll_x,ll_y
ll_x = (w_main.WorkSpaceWidth() - This.WorkSpaceWidth()) / 2
ll_y = ((w_main.WorkSpaceHeight() - This.WorkSpaceHeight()) / 2) - 150
This.move(ll_x,ll_y)

dw_master.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos
idw_1 = dw_master              				// asignar dw corriente
//of_position_window(0,0)       			// Posicionar la ventana en forma fija
//ii_help = 101           					// help topic
//Log de Seguridad
ib_log = TRUE


end event

event ue_modify();String ls_protect
ls_protect=dw_master.Describe("cod_clase.protect")
IF ls_protect='0' THEN
   dw_master.of_column_protect("cod_clase")
END IF
ls_protect=dw_detail.Describe("cod_segui.protect")
IF ls_protect='0' THEN
   dw_detail.of_column_protect("cod_segui")
END IF
end event

event resize;// Override
end event

event ue_update_pre;call super::ue_update_pre;dw_master.of_set_flag_replicacion()
dw_detail.of_set_flag_replicacion()
end event

type dw_master from w_abc_mastdet_smpl`dw_master within w_cn012_seguimiento
integer x = 27
integer y = 20
integer width = 1595
integer height = 468
string dataobject = "d_cod_segui_clase_tbl"
boolean vscrollbar = true
end type

event dw_master::constructor;call super::constructor;is_mastdet = 'md'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)
ii_ck[1] = 1				// columnas de lectrua de este dw
ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
//idw_det  =  				// dw_detail
end event

event dw_master::ue_output(long al_row);call super::ue_output;THIS.EVENT ue_retrieve_det(al_row)

end event

event dw_master::ue_retrieve_det_pos(any aa_id[]);call super::ue_retrieve_det_pos;idw_det.retrieve(aa_id[1])
end event

type dw_detail from w_abc_mastdet_smpl`dw_detail within w_cn012_seguimiento
integer x = 27
integer y = 512
integer width = 1595
integer height = 468
string dataobject = "d_cod_segui_tbl"
boolean vscrollbar = true
end type

event dw_detail::constructor;call super::constructor;is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
is_dwform = 'tabular'	// tabular, form (default)
ii_ck[1] = 1				// columnas de lectrua de este dw
ii_rk[1] = 2 	      // columnas que recibimos del master
//idw_mst  = 				// dw_master
//idw_det  =  				// dw_detail
end event

