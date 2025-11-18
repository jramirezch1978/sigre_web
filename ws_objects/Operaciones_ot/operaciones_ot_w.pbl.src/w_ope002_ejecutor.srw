$PBExportHeader$w_ope002_ejecutor.srw
forward
global type w_ope002_ejecutor from w_abc_master_smpl
end type
end forward

global type w_ope002_ejecutor from w_abc_master_smpl
integer x = 306
integer y = 108
integer width = 3442
integer height = 1608
string title = "Mantenimiento de Ejecutor ((OPE002)"
string menuname = "m_master_sin_lista"
boolean minbox = false
boolean maxbox = false
end type
global w_ope002_ejecutor w_ope002_ejecutor

on w_ope002_ejecutor.create
call super::create
if this.MenuName = "m_master_sin_lista" then this.MenuID = create m_master_sin_lista
end on

on w_ope002_ejecutor.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_modify;call super::ue_modify;String ls_protect
ls_protect=dw_master.Describe("cod_ejecutor.protect")
IF ls_protect='0' THEN
   dw_master.of_column_protect('cod_ejecutor')
END IF
end event

event ue_open_pre();call super::ue_open_pre;of_position_window(150,150)
ii_help = 3           					// help topic


end event

event resize;dw_master.width  = newwidth  - dw_master.x - 10
dw_master.height = newheight - dw_master.y - 10
end event

event ue_update_pre;call super::ue_update_pre;dw_master.of_set_flag_replicacion()
end event

type dw_master from w_abc_master_smpl`dw_master within w_ope002_ejecutor
integer width = 3378
integer height = 1400
string dataobject = "d_ejecutor"
boolean hscrollbar = false
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
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
		 CASE 'cencos'
			
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT CENTROS_COSTO.CENCOS AS CENCOS, '&
														 +'CENTROS_COSTO.DESC_CENCOS AS DESCRIPCION '&
														 +'FROM CENTROS_COSTO WHERE FLAG_ESTADO<>'+"'0'"

										  
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'cencos',lstr_seleccionar.param1[1])
					Setitem(row,'centros_costo_desc_cencos',lstr_seleccionar.param2[1])
					ii_update = 1
				END IF
END CHOOSE




end event

event dw_master::itemchanged;call super::itemchanged;Accepttext()
Integer li_count
String  ls_cencos, ls_desc_cencos


CHOOSE CASE dwo.name
		 // Busca si centro de costo existe
		 CASE 'cencos'
				SELECT Count(*)
				  INTO :li_count
				  FROM centros_costo
				 WHERE cencos = :data AND
				 		 flag_estado <> '0' ; 

				// Si no existe la cuenta contable
				IF li_count = 0 THEN
					Setnull(ls_cencos)
					Setnull(ls_desc_cencos)
					
					Messagebox('Aviso','Centro de costo no existe, Verifique! ',StopSign!)
					This.object.cencos 						  [row] = ls_cencos
					This.object.centros_costo_desc_cencos [row] = ls_desc_cencos
					Return 1
				ELSE
					SELECT desc_cencos
					  INTO :ls_desc_cencos
					  FROM centros_costo
					 WHERE cencos = :data ; 
					 
					 This.object.centros_costo_desc_cencos [row] = ls_desc_cencos
					 
				END IF
END CHOOSE

end event

event dw_master::rowfocuschanged;call super::rowfocuschanged;f_select_current_row(this)
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.flag_externo [al_row] = '0'
end event

