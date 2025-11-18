$PBExportHeader$w_fi018_grupo_libros.srw
forward
global type w_fi018_grupo_libros from w_abc_mastdet_smpl
end type
end forward

global type w_fi018_grupo_libros from w_abc_mastdet_smpl
integer width = 2318
integer height = 1344
string title = "Grupo de Libro (FI016)"
string menuname = "m_mantenimiento_sl"
end type
global w_fi018_grupo_libros w_fi018_grupo_libros

on w_fi018_grupo_libros.create
call super::create
if this.MenuName = "m_mantenimiento_sl" then this.MenuID = create m_mantenimiento_sl
end on

on w_fi018_grupo_libros.destroy
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
end event

type dw_master from w_abc_mastdet_smpl`dw_master within w_fi018_grupo_libros
integer x = 9
integer width = 1426
string dataobject = "d_abc_cntbl_grp_lib_tbl"
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

event dw_master::itemerror;call super::itemerror;Return 1
end event

event dw_master::itemchanged;call super::itemchanged;accepttext()
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.flag_estado [al_row] = '1'
end event

type dw_detail from w_abc_mastdet_smpl`dw_detail within w_fi018_grupo_libros
integer width = 2240
integer height = 620
string dataobject = "d_abc_cntbl_libro_grp_det_tbl"
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
		
		 CASE 'nro_libro'
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT CNTBL_LIBRO.NRO_LIBRO AS CODIGO,'&   
												+'CNTBL_LIBRO.DESC_LIBRO AS DESCRIPCION '&  
												+'FROM CNTBL_LIBRO'
												

				 OpenWithParm(w_seleccionar,lstr_seleccionar)
 
				 IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm

				 IF lstr_seleccionar.s_action = "aceptar" THEN
					 this.object.nro_libro              [row] = lstr_seleccionar.paramdc1[1]
					 this.object.cntbl_libro_desc_libro [row] = lstr_seleccionar.param2[1]
					 ii_update = 1
				 END IF
			
END CHOOSE

end event

event dw_detail::itemchanged;call super::itemchanged;Long   ll_count ,ll_nro_libro,ll_null
String ls_null  ,ls_desc_libro 

accepttext()

SetNull(ls_null)
SetNull(ll_null)

CHOOSE CASE dwo.name
		
		 CASE 'nro_libro'
			
				ll_nro_libro = this.object.nro_libro [row]
				
				select count(*) into :ll_count from cntbl_libro
				 where (nro_libro = :ll_nro_libro) ;
			
				IF ll_count = 0 then
					Messagebox('Aviso','Nro de Libro no existe. Verifique !')	

					This.object.nro_libro 				  [row] = ll_null
					This.object.cntbl_libro_desc_libro [row] = ls_null
					Return 1
				ELSE
					select desc_libro into :ls_desc_libro from cntbl_libro
					where (nro_libro = :data);
					
					This.object.cntbl_libro_desc_libro [row] = ls_desc_libro

				END IF
END CHOOSE


end event

event dw_detail::ue_insert_pre;call super::ue_insert_pre;this.object.flag_estado [al_row] = '1'
end event

