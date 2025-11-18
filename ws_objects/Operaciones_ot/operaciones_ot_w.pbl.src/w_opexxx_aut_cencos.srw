$PBExportHeader$w_opexxx_aut_cencos.srw
forward
global type w_opexxx_aut_cencos from w_abc_master_smpl
end type
end forward

global type w_opexxx_aut_cencos from w_abc_master_smpl
integer x = 306
integer y = 108
integer width = 1371
integer height = 1576
string title = "Mantenimiento de Ejecutor ((OPE002)"
string menuname = "m_master_sin_lista"
boolean minbox = false
boolean maxbox = false
end type
global w_opexxx_aut_cencos w_opexxx_aut_cencos

on w_opexxx_aut_cencos.create
call super::create
if this.MenuName = "m_master_sin_lista" then this.MenuID = create m_master_sin_lista
end on

on w_opexxx_aut_cencos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_modify;call super::ue_modify;String ls_protect
ls_protect=dw_master.Describe("cod_ejecutor.protect")
IF ls_protect='0' THEN
   dw_master.of_column_protect('cod_ejecutor')
END IF
end event

event ue_open_pre;call super::ue_open_pre;of_position_window(50,50)
ii_help = 3           					// help topic


end event

event resize;dw_master.width  = newwidth  - dw_master.x - 10
dw_master.height = newheight - dw_master.y - 10
end event

event ue_update_pre;call super::ue_update_pre;dw_master.of_set_flag_replicacion()
end event

type dw_master from w_abc_master_smpl`dw_master within w_opexxx_aut_cencos
integer width = 1298
integer height = 1332
string dataobject = "d_abc_lista_aprobacion_x_usr_tbl"
boolean hscrollbar = false
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1	// columnas de lectrua de este dw
ii_ck[2] = 2			
ii_ck[3] = 3			
ii_ck[4] = 4			

end event

event dw_master::itemerror;call super::itemerror;Return 1
end event

event dw_master::doubleclicked;call super::doubleclicked;IF Getrow() = 0 THEN Return
String ls_name,ls_prot
str_seleccionar lstr_seleccionar

ls_name = dwo.name
ls_prot = this.Describe( ls_name + ".Protect")

if ls_prot = '1' then    //protegido 
	return
end if

CHOOSE CASE dwo.name
		 CASE	'tipo_doc'

				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT DOC_TIPO.TIPO_DOC AS DOCUMENTO, '&
														 +'DOC_TIPO.DESC_TIPO_DOC AS DESCRIPCION '&
														 +'FROM DOC_TIPO '


										  
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'tipo_doc',lstr_seleccionar.param1[1])
					ii_update = 1
				END IF
				
		 CASE	'cod_usr'	
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT USUARIO.COD_USR AS CODIGO, '&
														 +'USUARIO.NOMBRE AS DESCRIPCION '&
														 +'FROM USUARIO '


										  
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'cod_usr',lstr_seleccionar.param1[1])
					ii_update = 1
				END IF
		 CASE 'cencos'
			
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT CENTROS_COSTO.CENCOS AS CENCOS, '&
														 +'CENTROS_COSTO.DESC_CENCOS AS DESCRIPCION '&
														 +'FROM CENTROS_COSTO WHERE FLAG_ESTADO <> '+"'0'"

										  
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'cencos',lstr_seleccionar.param1[1])
					ii_update = 1
				END IF
END CHOOSE




end event

event dw_master::itemchanged;call super::itemchanged;Accepttext()
Integer li_count
String  ls_cencos


CHOOSE CASE dwo.name
		 CASE	'tipo_doc'
				select count(*) into :li_count from doc_tipo where tipo_doc = :data ;
				
				IF li_count = 0 THEN
					Setnull(ls_cencos)
					
					Messagebox('Aviso','Documento no existe, Verifique! ',StopSign!)
					This.object.tipo_doc [row] = ls_cencos
					Return 1
				END IF
   	 CASE	'cod_usr'
				select count(*) into :li_count from usuario where cod_usr = :data ;
				
				IF li_count = 0 THEN
					Setnull(ls_cencos)
					Messagebox('Aviso','Usuario no existe, Verifique! ',StopSign!)
					This.object.cod_usr [row] = ls_cencos
					Return 1
				END IF
				
		 CASE 'cencos'
				SELECT Count(*)
				  INTO :li_count
				  FROM centros_costo
				 WHERE cencos = :data AND
				 		 flag_estado <> '0' ; 

				// Si no existe la cuenta contable
				IF li_count = 0 THEN
					Setnull(ls_cencos)
					
					Messagebox('Aviso','Centro de costo no existe, Verifique! ',StopSign!)
					This.object.cencos 						  [row] = ls_cencos
					Return 1
					 
				END IF
END CHOOSE

end event

event dw_master::rowfocuschanged;call super::rowfocuschanged;f_select_current_row(this)
end event

