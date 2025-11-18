$PBExportHeader$w_fi010_bancos.srw
forward
global type w_fi010_bancos from w_abc_master_smpl
end type
end forward

global type w_fi010_bancos from w_abc_master_smpl
integer width = 2574
integer height = 1636
string title = "[FI010] BANCOS"
string menuname = "m_master_simple"
end type
global w_fi010_bancos w_fi010_bancos

on w_fi010_bancos.create
call super::create
if this.MenuName = "m_master_simple" then this.MenuID = create m_master_simple
end on

on w_fi010_bancos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre();call super::ue_open_pre;of_position_window(0,0)
end event

event ue_update_pre;call super::ue_update_pre;dw_master.of_set_flag_replicacion ()
end event

type dw_master from w_abc_master_smpl`dw_master within w_fi010_bancos
integer x = 5
integer y = 4
integer width = 2519
integer height = 1336
string dataobject = "d_abc_banco_tbl"
boolean hscrollbar = false
end type

event dw_master::itemerror;call super::itemerror;return 1
end event

event dw_master::itemchanged;call super::itemchanged;Long   ll_count
String ls_null
Accepttext()


choose case dwo.name
		 case 'proveedor'
				SELECT Count(*)
				  INTO :ll_count
				  FROM proveedor pr
				 WHERE (pr.proveedor   = :data ) and
				 		 (pr.flag_estado = '1'   ) ; 
						 
				
				IF ll_count = 0 THEN
					Messagebox('Aviso','Proveedor No Existe , Verifique!')
					setnull(ls_null)
					This.Object.proveedor [row] = ls_null
					Return 1
				END IF
end choose

end event

event dw_master::rowfocuschanged;call super::rowfocuschanged;f_select_current_row (this)
end event

event dw_master::ue_insert_pre(long al_row);call super::ue_insert_pre;dw_master.Modify("cod_banco.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("nom_banco.Protect='1~tIf(IsRowNew(),0,1)'")
end event

event dw_master::doubleclicked;call super::doubleclicked;IF Getrow() = 0 THEN Return
String      ls_name ,ls_prot 


Str_seleccionar lstr_seleccionar


ls_name = dwo.name
ls_prot = this.Describe( ls_name + ".Protect")

if ls_prot = '1' then    //protegido 
	return
end if


CHOOSE CASE dwo.name
		 CASE 'proveedor'				
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT PROVEEDOR.PROVEEDOR AS CODIGO , '&
								   					 +'PROVEEDOR.NOM_PROVEEDOR AS DESCRIPCION,'&
                                           +'RUC AS NRO_RUC '				   &
									   				 +'FROM PROVEEDOR '&
														 +'WHERE PROVEEDOR.FLAG_ESTADO = '+"'"+'1'+"'"

				
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'proveedor',lstr_seleccionar.param1[1])
					
					ii_update = 1
				END IF
				
		 CASE 'cod_banco_rtps'
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT rrhh_bancos_rtps.cod_banco_rtps AS CODIGO , '&
								   					 +'rrhh_bancos_rtps.desc_banco_rtps AS DESCRIPCION '&
									   				 +'FROM rrhh_bancos_rtps '&
														 +'WHERE rrhh_bancos_rtps.FLAG_ESTADO = '+"'"+'1'+"'"

				
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'cod_banco_rtps',lstr_seleccionar.param1[1])
					
					ii_update = 1
				END IF
	
END CHOOSE

end event

