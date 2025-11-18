$PBExportHeader$w_rh019_abc_profesion_especialidad.srw
forward
global type w_rh019_abc_profesion_especialidad from w_abc_mastdet_smpl
end type
end forward

global type w_rh019_abc_profesion_especialidad from w_abc_mastdet_smpl
integer width = 1897
integer height = 1432
string title = "(RH019) Profesiones y/o Especialidades"
string menuname = "m_master_simple"
end type
global w_rh019_abc_profesion_especialidad w_rh019_abc_profesion_especialidad

type variables
integer ii_dw_upd //variable de actualizacion del dw 
integer ii_flag    //flag de actualizar tablas
end variables

on w_rh019_abc_profesion_especialidad.create
call super::create
if this.MenuName = "m_master_simple" then this.MenuID = create m_master_simple
end on

on w_rh019_abc_profesion_especialidad.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre;call super::ue_open_pre;long ll_x,ll_y
ll_x = (w_main.WorkSpaceWidth() - this.WorkSpaceWidth()) / 2
ll_y = ((w_main.WorkSpaceHeight() - this.WorkSpaceHeight()) / 2) - 150
this.move(ll_x,ll_y)



end event

event ue_modify;call super::ue_modify;int li_protect_master, li_protect_profes, li_protect_espec

//Proteccion del codigo de profesion   
	li_protect_master = integer(dw_detail.Object.cod_profesion.Protect)
	If li_protect_master = 0 Then
		dw_master.Object.cod_profesion.Protect = 1
	End if 
	
	li_protect_profes = integer(dw_detail.Object.cod_profesion.Protect)
	If li_protect_profes = 0 then
		dw_detail.Object.cod_profesion.Protect= 1
	End if 

	li_protect_espec = integer(dw_detail.Object.cod_espec.Protect)
	If li_protect_espec = 0 then
		dw_detail.Object.cod_espec.Protect= 1
	End if 
end event

event resize;// Override
end event

event ue_update_pre;call super::ue_update_pre;dw_master.of_set_flag_replicacion( )
dw_detail.of_set_flag_replicacion( )
end event

type dw_master from w_abc_mastdet_smpl`dw_master within w_rh019_abc_profesion_especialidad
integer x = 55
integer y = 48
integer width = 1746
integer height = 552
string dataobject = "d_profesion_cabecera_tbl"
boolean vscrollbar = true
boolean livescroll = false
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1			// Columnas de lectrua del dw
ii_dk[1] = 1 	      // Columnas que se pasan al detalle


is_dwform = 'tabular'	// tabular, form (default)
ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear


end event

event dw_master::ue_output;call super::ue_output;THIS.EVENT ue_retrieve_det(al_row)


end event

event dw_master::ue_retrieve_det_pos;call super::ue_retrieve_det_pos;dw_detail.retrieve(aa_id[1])
end event

event dw_master::itemchanged;call super::itemchanged;string ls_cod_prof

choose case dwo.Name
	case 'cod_profesion'
		ls_cod_prof = trim(idw_1.GetText())
		If len(ls_cod_prof) <> 3 Then
			Messagebox("Sistema de Validacion","El CODIGO de PROFESION "+&
			           " es de 3 DIGITOS")
			idw_1.SetColumn("cod_profesion")
			idw_1.Setfocus()
			return 1
		end if 	
end choose 


end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;dw_master.Modify("cod_profesion.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("desc_profesion.Protect='1~tIf(IsRowNew(),0,1)'")
end event

event dw_master::clicked;call super::clicked;ii_dw_upd = 1 //Variable de actualizacion para el dw Maestro

end event

type dw_detail from w_abc_mastdet_smpl`dw_detail within w_rh019_abc_profesion_especialidad
integer x = 55
integer y = 648
integer width = 1746
integer height = 552
string dataobject = "d_profesion_especialidad_tbl"
boolean vscrollbar = true
boolean livescroll = false
end type

event dw_detail::constructor;call super::constructor;ii_ck[1] = 1			// Columnas de lectrua de este dw
ii_ck[2] = 2			// Columnas de lectrua de este dw
ii_rk[1] = 1 	      // Columnas que recibimos del master

end event

event dw_detail::itemchanged;call super::itemchanged;string ls_cod_espec

choose case dwo.Name 
	case 'cod_espec'
		ls_cod_espec = trim(idw_1.GetText())
		If len(ls_cod_espec) <> 4 Then
			Messagebox("Sistema de Validacion","El CODIGO de ESPECIALIDAD "+&
			           " es de 4 DIGITOS")
			idw_1.SetColumn("cod_espec")
			idw_1.Setfocus()
			return 1
		end if 	
end choose 		


end event

event dw_detail::ue_insert_pre;call super::ue_insert_pre;//Registros Anteriores del Datawindow Detalle
dw_detail.Modify("cod_profesion.Protect='1~tIf(IsRowNew(),0,1)'")
dw_detail.Modify("cod_espec.Protect='1~tIf(IsRowNew(),0,1)'")
dw_detail.Modify("desc_espec.Protect='1~tIf(IsRowNew(),0,1)'")

//Ingreso de Nuevos Registros 
int li_protect
li_protect = integer(dw_detail.Object.cod_profesion.Protect)
If li_protect = 0 then
	dw_detail.Object.cod_profesion.Protect= 1
End if 
end event

event dw_detail::clicked;call super::clicked;ii_dw_upd = 2 //Variable de actualizacion del dw detalle
end event

