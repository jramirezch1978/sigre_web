$PBExportHeader$w_cm017_grupo_proveedor.srw
forward
global type w_cm017_grupo_proveedor from w_abc_mastdet_smpl
end type
end forward

global type w_cm017_grupo_proveedor from w_abc_mastdet_smpl
integer width = 1865
integer height = 1348
string title = "Grupo de proveedores (CM017)"
string menuname = "m_mantenimiento"
end type
global w_cm017_grupo_proveedor w_cm017_grupo_proveedor

on w_cm017_grupo_proveedor.create
call super::create
if this.MenuName = "m_mantenimiento" then this.MenuID = create m_mantenimiento
end on

on w_cm017_grupo_proveedor.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre();call super::ue_open_pre;of_position_window(0,0)       			// Posicionar la ventana en forma fija
ii_pregunta_delete = 1   					// 1 = si pregunta, 0 = no pregunta (default)
//ii_help = 101           					// help topic

end event

event resize;call super::resize;//
end event

event ue_modify();call super::ue_modify;String ls_protect
ls_protect = dw_master.Describe("grupo.protect")
If ls_protect = '0' Then
   dw_master.object.grupo.protect = 1
End if	

ls_protect = dw_detail.Describe("grupo.protect")
If ls_protect = '0' Then
   dw_detail.object.grupo.protect = 1
End if	
ls_protect = dw_detail.Describe("proveedor.protect")
If ls_protect = '0' Then
   dw_detail.object.proveedor.protect = 1
End if	

end event

event ue_update_pre;call super::ue_update_pre;dw_master.of_set_flag_replicacion()
dw_detail.of_set_flag_replicacion()
end event

type dw_master from w_abc_mastdet_smpl`dw_master within w_cm017_grupo_proveedor
integer width = 1641
string dataobject = "d_abc_grupo_proveedor_tbl"
boolean vscrollbar = true
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectura de este dw
ii_dk[1] = 1 	      	// columnas que se pasan al detalle
idw_mst  = dw_master

end event

event dw_master::ue_output(long al_row);call super::ue_output;THIS.EVENT ue_retrieve_det(al_row)

//idw_det.ScrollToRow(al_row)


end event

event dw_master::ue_retrieve_det_pos(any aa_id[]);call super::ue_retrieve_det_pos;idw_det.retrieve(aa_id[1])
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.SetItem(al_row, 'flag_grp_econ', '1')
end event

type dw_detail from w_abc_mastdet_smpl`dw_detail within w_cm017_grupo_proveedor
integer width = 1801
integer height = 620
string dataobject = "d_abc_grupo_prov_rel_tbl"
boolean vscrollbar = true
end type

event dw_detail::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectura de este dw
ii_ck[2] = 2				// columnas de lectura de este dw
ii_rk[1] = 1 		      // columnas que recibimos del master

end event

event dw_detail::doubleclicked;call super::doubleclicked;IF Getrow() = 0 THEN Return
String ls_name,ls_prot 
str_seleccionar lstr_seleccionar

ls_name = dwo.name
ls_prot = this.Describe( ls_name + ".Protect")

if ls_prot = '1' then    //protegido 
	return
end if


CHOOSE CASE dwo.name
		
		 CASE 'proveedor'
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT PROVEEDOR.PROVEEDOR AS CODIGO,'&   
												+'PROVEEDOR.NOM_PROVEEDOR AS NOMBRE '&  
												+'FROM PROVEEDOR '

				 OpenWithParm(w_seleccionar,lstr_seleccionar)
 
				 IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm

				 IF lstr_seleccionar.s_action = "aceptar" THEN
					 Setitem(row,'proveedor',lstr_seleccionar.param1[1])
					 Setitem(row,'nom_proveedor',lstr_seleccionar.param2[1])
					 ii_update = 1
				 END IF
			
END CHOOSE

end event

event dw_detail::itemchanged;call super::itemchanged;IF Getrow() = 0 THEN Return
String ls_name,ls_prot, ls_codigo, ls_nom_proveedor
Long ll_count

ls_name = dwo.name
ls_prot = this.Describe( ls_name + ".Protect")

if ls_prot = '1' then    //protegido 
	return
end if

CHOOSE CASE dwo.name
		
		 CASE 'proveedor'
			select count(*) into :ll_count from proveedor 
			where proveedor=:data;
			IF ll_count = 0 then
				Messagebox('Aviso','Codigo de proveedor no existe. Verifique !')	
				SetNull(ls_codigo)
				This.object.proveedor [row] = ls_codigo
				Return 1
			ELSE
				select nom_proveedor into :ls_nom_proveedor from proveedor 
				where proveedor=:data;
				this.SetItem( row, 'nom_proveedor', ls_nom_proveedor )
				ii_update = 1
			END IF
END CHOOSE

end event

