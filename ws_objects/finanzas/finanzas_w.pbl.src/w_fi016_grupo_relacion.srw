$PBExportHeader$w_fi016_grupo_relacion.srw
forward
global type w_fi016_grupo_relacion from w_abc_mastdet_smpl
end type
end forward

global type w_fi016_grupo_relacion from w_abc_mastdet_smpl
integer width = 2350
integer height = 1372
string title = "Grupo de Relacion (FI016)"
string menuname = "m_mantenimiento_sl"
end type
global w_fi016_grupo_relacion w_fi016_grupo_relacion

on w_fi016_grupo_relacion.create
call super::create
if this.MenuName = "m_mantenimiento_sl" then this.MenuID = create m_mantenimiento_sl
end on

on w_fi016_grupo_relacion.destroy
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

type dw_master from w_abc_mastdet_smpl`dw_master within w_fi016_grupo_relacion
integer x = 9
integer width = 2286
string dataobject = "d_abc_grupo_relacion_tbl"
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

type dw_detail from w_abc_mastdet_smpl`dw_detail within w_fi016_grupo_relacion
integer width = 2286
integer height = 620
string dataobject = "d_abc_agrupamiento_relacion_tbl"
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
		
		 CASE 'cod_relacion'
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT CODIGO_RELACION.COD_RELACION AS RELACION_CODIGO,'&   
												+'CODIGO_RELACION.NOMBRE AS NOMBRE '&  
												+'FROM CODIGO_RELACION '

				 OpenWithParm(w_seleccionar,lstr_seleccionar)
 
				 IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm

				 IF lstr_seleccionar.s_action = "aceptar" THEN
					 Setitem(row,'cod_relacion',lstr_seleccionar.param1[1])
					 Setitem(row,'nombre',lstr_seleccionar.param2[1])
					 ii_update = 1
				 END IF
			
END CHOOSE

end event

event dw_detail::itemchanged;call super::itemchanged;String ls_codigo, ls_nombre
Long   ll_count

accepttext()
CHOOSE CASE dwo.name
		
		 CASE 'cod_relacion'
				select count(*) into :ll_count from codigo_relacion 
				where cod_relacion=:data;
			
				IF ll_count = 0 then
					Messagebox('Aviso','Codigo de Relación no existe. Verifique !')	
					SetNull(ls_codigo)
					This.object.cod_relacion [row] = ls_codigo
					This.object.nombre       [row] = ls_codigo
					Return 1
				ELSE
					select nombre into :ls_nombre from codigo_relacion
					where cod_relacion = :data;
					
					this.SetItem( row, 'nombre', ls_nombre)
				END IF
END CHOOSE

end event

