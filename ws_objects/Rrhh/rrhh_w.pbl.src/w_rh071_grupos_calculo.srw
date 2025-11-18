$PBExportHeader$w_rh071_grupos_calculo.srw
forward
global type w_rh071_grupos_calculo from w_abc_mastdet_smpl
end type
end forward

global type w_rh071_grupos_calculo from w_abc_mastdet_smpl
integer width = 3227
integer height = 1592
string title = "(RH071) Grupos de Cálculos"
string menuname = "m_master_simple"
end type
global w_rh071_grupos_calculo w_rh071_grupos_calculo

type variables
Integer ii_dw_upd
end variables

on w_rh071_grupos_calculo.create
call super::create
if this.MenuName = "m_master_simple" then this.MenuID = create m_master_simple
end on

on w_rh071_grupos_calculo.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre;call super::ue_open_pre;long ll_x,ll_y
ll_x = (w_main.WorkSpaceWidth() - this.WorkSpaceWidth()) / 2
ll_y = ((w_main.WorkSpaceHeight() - this.WorkSpaceHeight()) / 2) - 150
this.move(ll_x,ll_y)


end event

event ue_print;call super::ue_print;idw_1.print()
end event

event ue_modify;call super::ue_modify;integer li_protect 

li_protect = integer(dw_master.Object.cod_grupo.Protect)
if li_protect = 0 then
	dw_master.Object.cod_grupo.Protect = 1
end if 

li_protect = integer(dw_detail.Object.cod_grupo.Protect)
if li_protect = 0 then
	dw_detail.Object.cod_grupo.Protect = 1
end if 
li_protect = integer(dw_detail.Object.cod_sub_grupo.Protect)
if li_protect = 0 then
	dw_detail.Object.cod_sub_grupo.Protect = 1
end if 


	

end event

event resize;// Override
end event

event ue_update_pre;call super::ue_update_pre;dw_master.of_set_flag_replicacion( )
dw_detail.of_set_flag_replicacion( )
end event

type dw_master from w_abc_mastdet_smpl`dw_master within w_rh071_grupos_calculo
integer x = 55
integer y = 48
integer width = 3077
integer height = 536
string dataobject = "d_grupo_calculo_liq_tbl"
boolean vscrollbar = true
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				 // columnas de lectrua de este dw
ii_dk[1] = 1             // colunmna de pase de parametros

ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

end event

event dw_master::ue_output;call super::ue_output;THIS.EVENT ue_retrieve_det(al_row)
end event

event dw_master::ue_retrieve_det_pos;call super::ue_retrieve_det_pos;idw_det.retrieve(aa_id[1])
end event

event dw_master::clicked;call super::clicked;ii_dw_upd =1
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.setitem(al_row,"cod_usr",gs_user)

// Validacion de ingreso de filas 

dw_master.Modify("cod_grupo.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("descripcion.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("secuencia.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("flag_estado.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("flag_calculo.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("cod_usr.Protect='1~tIf(IsRowNew(),0,1)'")



end event

type dw_detail from w_abc_mastdet_smpl`dw_detail within w_rh071_grupos_calculo
integer x = 55
integer y = 632
integer width = 3077
integer height = 732
string dataobject = "d_grupo_calculo_det_liq_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_detail::constructor;call super::constructor;//Forma parte del pK
ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2
//Variable de pase de Parametros
ii_rk[1] = 1 	      // columnas que recibimos del master

end event

event dw_detail::clicked;call super::clicked;ii_dw_upd = 2
end event

event dw_detail::ue_insert_pre;call super::ue_insert_pre;this.setitem(al_row,"cod_usr",gs_user)

integer li_protect 

li_protect = integer(dw_detail.object.cod_grupo.Protect)
if li_protect = 0 then
	dw_detail.Object.cod_grupo.Protect = 1
end if

// Validacion al ingresar un registro
dw_detail.Modify("cod_grupo.Protect='1~tIf(IsRowNew(),0,1)'")
dw_detail.Modify("cod_sub_grupo.Protect='1~tIf(IsRowNew(),0,1)'")
dw_detail.Modify("descripcion.Protect='1~tIf(IsRowNew(),0,1)'")
dw_detail.Modify("flag_estado.Protect='1~tIf(IsRowNew(),0,1)'")
dw_detail.Modify("matriz.Protect='1~tIf(IsRowNew(),0,1)'")
dw_detail.Modify("observaciones.Protect='1~tIf(IsRowNew(),0,1)'")
dw_detail.Modify("cod_usr.Protect='1~tIf(IsRowNew(),0,1)'")

end event

event dw_detail::doubleclicked;call super::doubleclicked;string ls_col, ls_sql, ls_return1, ls_return2

ls_col = lower(trim(string(dwo.name)))

choose case ls_col
	case 'matriz'
		ls_sql = "select matriz as codigo, descripcion as nombres from matriz_cntbl_finan where flag_estado = '1'"
		f_lista(ls_sql, ls_return1, ls_return2, '2')
		if isnull(ls_return1) or trim(ls_return1) = '' then return
		this.object.matriz[row] = ls_return1
		this.ii_update = 1
end choose


end event

