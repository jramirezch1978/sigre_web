$PBExportHeader$w_fi012_personas_autoriz.srw
forward
global type w_fi012_personas_autoriz from w_abc_master_smpl
end type
end forward

global type w_fi012_personas_autoriz from w_abc_master_smpl
integer width = 2843
integer height = 1740
string title = "[FI012] Personas autorizadas a aprobar adelantos"
string menuname = "m_mantenimiento_sl"
end type
global w_fi012_personas_autoriz w_fi012_personas_autoriz

on w_fi012_personas_autoriz.create
call super::create
if this.MenuName = "m_mantenimiento_sl" then this.MenuID = create m_mantenimiento_sl
end on

on w_fi012_personas_autoriz.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre();call super::ue_open_pre;//of_position_window(10,10)       			// Posicionar la ventana en forma fija

end event

event ue_update_pre;call super::ue_update_pre;dw_master.of_set_flag_replicacion()
end event

type dw_master from w_abc_master_smpl`dw_master within w_fi012_personas_autoriz
integer y = 4
integer width = 2747
integer height = 1516
string dataobject = "d_abc_personas_autoriz_tbl"
end type

event dw_master::itemerror;call super::itemerror;return 1
end event

event dw_master::doubleclicked;call super::doubleclicked;
str_seleccionar lstr_seleccionar 

IF row = 0 THEN RETURN
CHOOSE CASE dwo.Name
	CASE 'cod_usr'  
      lstr_seleccionar.s_seleccion = 'S'
		lstr_seleccionar.s_sql = 'SELECT USUARIO.COD_USR AS COD_USR,'&
                                    +' USUARIO.NOMBRE AS NOMBRE '&
										 +' FROM USUARIO '&
										 +'WHERE USUARIO.FLAG_ESTADO='+"'1'"
		OpenWithParm(w_seleccionar,lstr_seleccionar)
		IF IsValid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
		IF lstr_seleccionar.s_action = "aceptar" THEN
			setitem(row,'cod_usr' ,lstr_seleccionar.param1[1])
			setitem(row,'usuario_nombre' ,lstr_seleccionar.param2[1])
			
         ii_update = 1
		END IF
		
	CASE 'cencos'
		lstr_seleccionar.s_seleccion = 'S'
		lstr_seleccionar.s_sql = 'SELECT CENTROS_COSTO.CENCOS AS CENCOS,'&
                                    +' CENTROS_COSTO.DESC_CENCOS AS DESC_CENCOS '&
										 +' FROM CENTROS_COSTO '&
										 +'WHERE CENTROS_COSTO.FLAG_ESTADO='+"'1'"
		OpenWithParm(w_seleccionar,lstr_seleccionar)
		IF IsValid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
		IF lstr_seleccionar.s_action = "aceptar" THEN
			setitem(row,'cencos' ,lstr_seleccionar.param1[1])
			setitem(row,'centros_costo_desc_cencos' ,lstr_seleccionar.param2[1])			
         ii_update = 1
		END IF
		
END CHOOSE			

end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;dw_master.object.flag_estado[al_row]='1'

dw_master.Modify("cod_usr.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("cencos.Protect='1~tIf(IsRowNew(),0,1)'")

end event

event dw_master::itemchanged;call super::itemchanged;Long ll_count
String ls_dato, ls_null

ISNULL(ls_null)
CHOOSE CASE dwo.Name
	CASE 'cod_usr'  
		ls_dato = data 
      SELECT count(*) INTO :ll_count FROM usuario u WHERE u.cod_usr = :ls_dato and u.flag_estado='1';

		IF ll_count = 0 THEN
			MessageBox('Aviso','Usuario no existe o desactivado')
			this.object.cod_usr[row] = ls_null
			Return 1
		END IF 
      ii_update = 1
		
	CASE 'cencos'
		ls_dato = data 
      SELECT count(*) INTO :ll_count FROM centros_costo u WHERE u.cencos = :ls_dato and u.flag_estado='1';

		IF ll_count = 0 THEN
			MessageBox('Aviso','Centro de costo no existe o desactivado')
			this.object.cencos[row] = ls_null
			Return 1
		END IF 
      ii_update = 1
END CHOOSE			

end event

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw
end event

