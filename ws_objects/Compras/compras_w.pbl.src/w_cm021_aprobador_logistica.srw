$PBExportHeader$w_cm021_aprobador_logistica.srw
forward
global type w_cm021_aprobador_logistica from w_abc_master
end type
end forward

global type w_cm021_aprobador_logistica from w_abc_master
integer width = 3095
integer height = 1724
string title = "[CM021] Aprobadores de documentos de compras"
string menuname = "m_mantto_smpl"
end type
global w_cm021_aprobador_logistica w_cm021_aprobador_logistica

on w_cm021_aprobador_logistica.create
call super::create
if this.MenuName = "m_mantto_smpl" then this.MenuID = create m_mantto_smpl
end on

on w_cm021_aprobador_logistica.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre;call super::ue_open_pre;idw_1.Retrieve(gs_user)
//ii_help = 101            // help topic
//ii_pregunta_delete = 1   // 1 = si pregunta, 0 = no pregunta (default)
//ib_log = TRUE
//idw_query = dw_master

end event

event ue_list_open;call super::ue_list_open;// Asigna valores a structura 
Long ll_row
str_parametros sl_param

TriggerEvent ('ue_update_request')		
IF ib_update_check = FALSE THEN RETURN

sl_param.dw1 = "d_lista_logistica_aprobador_tbl"
sl_param.titulo = "Aprobadores de doc. compra"
sl_param.field_ret_i[1] = 1

OpenWithParm( w_lista, sl_param)
sl_param = MESSAGE.POWEROBJECTPARM
if sl_param.titulo <> 'n' then
	// Se ubica la cabecera
	dw_master.retrieve(sl_param.field_ret[1])
END IF
end event

type dw_master from w_abc_master`dw_master within w_cm021_aprobador_logistica
integer width = 2921
integer height = 1228
string dataobject = "d_abc_aprobadores_oc_tbl"
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1			// columnas de lectrua de este dw


//idw_mst  = 				// dw_master
//idw_det  =  				// dw_detail
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;Long ll_mes

ll_mes = LONG(String(today(),'mm'))

this.object.flag_estado[al_row]='1'
this.object.nivel_aprob[al_row]=1
this.object.mes_aprob[al_row]=ll_mes

this.object.imp_max_aprob_oc[al_row]=0
this.object.imp_max_aprob_item_oc[al_row]=0 
this.object.imp_max_mensual_oc[al_row]=0 
this.object.saldo_aprob_mes_oc[al_row]=0

this.object.imp_max_aprob_os[al_row]=0 
this.object.imp_max_aprob_item_os[al_row]=0 
this.object.imp_max_mensual_os[al_row]=0 
this.object.saldo_aprob_mes_os[al_row]=0

end event

event dw_master::itemchanged;call super::itemchanged;//usuario_nombre

string ls_nombre, ls_null

SetNull(ls_null)

if dwo.name = 'cod_usr' then
	
	 Select nombre
		into :ls_nombre 
   	from usuario 
	  where cod_usr = :data;	
	
	if SQLCA.SQLCode = 100 then
		messagebox( "Error", "Usuario no existe", exclamation!)
		this.object.cod_usr			[row] = ls_null
		this.object.usuario_nombre	[row] = ls_null
		return 1
	end if

	this.object.usuario_nombre[row] = ls_nombre 
end if
end event

