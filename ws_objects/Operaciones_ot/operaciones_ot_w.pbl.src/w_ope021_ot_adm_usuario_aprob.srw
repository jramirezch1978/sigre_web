$PBExportHeader$w_ope021_ot_adm_usuario_aprob.srw
forward
global type w_ope021_ot_adm_usuario_aprob from w_abc_mastdet_smpl
end type
type st_1 from statictext within w_ope021_ot_adm_usuario_aprob
end type
type st_2 from statictext within w_ope021_ot_adm_usuario_aprob
end type
end forward

global type w_ope021_ot_adm_usuario_aprob from w_abc_mastdet_smpl
integer width = 3177
integer height = 1988
string title = "[OP021] Níveles de autorizaciones de aprobaciones"
string menuname = "m_master_sin_lista"
st_1 st_1
st_2 st_2
end type
global w_ope021_ot_adm_usuario_aprob w_ope021_ot_adm_usuario_aprob

on w_ope021_ot_adm_usuario_aprob.create
int iCurrent
call super::create
if this.MenuName = "m_master_sin_lista" then this.MenuID = create m_master_sin_lista
this.st_1=create st_1
this.st_2=create st_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.st_2
end on

on w_ope021_ot_adm_usuario_aprob.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.st_2)
end on

event ue_open_pre;call super::ue_open_pre;//Help
ii_help = 1
ii_lec_mst = 0
//dw_master.retrieve(gs_user)
dw_master.retrieve()
end event

event ue_print;call super::ue_print;//String      ls_cadena
//Str_cns_pop lstr_cns_pop
//
//IF idw_1.getrow() = 0 THEN RETURN
//
//ls_cadena = idw_1.Object.cod_fase[idw_1.getrow()]
//
//IF Isnull(ls_cadena) OR Trim(ls_cadena) = '' THEN RETURN
//
//lstr_cns_pop.arg[1] = ls_cadena
//lstr_cns_pop.arg[2] = gs_empresa
//lstr_cns_pop.arg[3] = gs_user
//lstr_cns_pop.arg[4] = ''
//
//
//lstr_cns_pop.dataobject = 'd_rpt_labor_fase_etapa_ff'
//lstr_cns_pop.title = 'Reporte de Etapas Por Fase'
//lstr_cns_pop.width  = 3650
//lstr_cns_pop.height = 1950
//
//OpenSheetWithParm(w_rpt_pop, lstr_cns_pop, This, 2, Layered!)
end event

event ue_update_pre;call super::ue_update_pre;dw_master.accepttext()
dw_detail.accepttext()


//--VERIFICACION Y ASIGNACION DE FASE Y ETAPA
IF f_row_Processing( dw_master, "grid") <> true then	
	ib_update_check = False	
	return
ELSE
	ib_update_check = True
END IF

//--VERIFICACION Y ASIGNACION DE FASE Y ETAPA

IF f_row_Processing( dw_detail, "grid") <> true then	
	ib_update_check = False	
	return
ELSE
	ib_update_check = True
END IF

dw_master.of_set_flag_replicacion()
dw_detail.of_set_flag_replicacion()
end event

event resize;//override
dw_master.width  = newwidth  - dw_master.x - 10
dw_detail.width  = newwidth  - dw_detail.x - 10
dw_detail.height = newheight - dw_detail.y - 10

st_1.width = dw_master.width
st_2.width = dw_detail.width
end event

type dw_master from w_abc_mastdet_smpl`dw_master within w_ope021_ot_adm_usuario_aprob
integer x = 0
integer y = 88
integer width = 2971
integer height = 1216
string dataobject = "d_abc_ot_admin_usuario_aprob_tbl"
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw
ii_dk[1] = 1 	      // columnas que se pasan al detalle
ii_dk[2] = 2 	      // columnas que se pasan al detalle

end event

event dw_master::ue_output;call super::ue_output;THIS.EVENT ue_retrieve_det(al_row)
end event

event dw_master::ue_retrieve_det_pos;call super::ue_retrieve_det_pos;//idw_det.retrieve(aa_id[1],gs_user)
idw_det.retrieve(aa_id[1], aa_id[2])

end event

event dw_master::itemerror;call super::itemerror;Return 1
end event

event dw_master::doubleclicked;call super::doubleclicked;//IF Getrow() = 0 THEN Return
//String ls_name,ls_prot
//str_seleccionar lstr_seleccionar
//
//ls_name = dwo.name
//ls_prot = this.Describe( ls_name + ".Protect")
//
//if ls_prot = '1' then    //protegido 
//	return
//end if
//
//CHOOSE CASE dwo.name
//		 CASE 'ot_adm'
//			
//				lstr_seleccionar.s_seleccion = 'S'
//				lstr_seleccionar.s_sql = 'SELECT VW_OPE_OT_ADM_USR.OT_ADM AS CODIGO_ADM, '&
//														 +'VW_OPE_OT_ADM_USR.DESCRIPCION AS DESCRIPCION '&
//														 +'FROM VW_OPE_OT_ADM_USR '&
//														 +'WHERE COD_USR = '+"'"+gs_user+"'"
//														 
//
//										  
//				OpenWithParm(w_seleccionar,lstr_seleccionar)
//				
//				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
//				IF lstr_seleccionar.s_action = "aceptar" THEN
//					Setitem(row,'ot_adm',lstr_seleccionar.param1[1])
//					Setitem(row,'descripcion',lstr_seleccionar.param2[1])
//					ii_update = 1
//				END IF
//END CHOOSE
//
//
//
//
end event

event dw_master::getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

type dw_detail from w_abc_mastdet_smpl`dw_detail within w_ope021_ot_adm_usuario_aprob
integer x = 0
integer y = 1392
integer width = 3003
integer height = 356
string dataobject = "d_abc_ot_adm_aprob_req_ff"
boolean livescroll = false
end type

event dw_detail::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectura de este dw
ii_ck[2] = 2				// columnas de lectura de este dw
ii_rk[1] = 1
ii_rk[2] = 2
end event

event dw_detail::itemerror;call super::itemerror;Return 1
end event

event dw_detail::itemchanged;call super::itemchanged;//String ls_codigo,ls_descripcion
//Long 	 ll_count
//
//Accepttext()
//
//choose case dwo.name
//	 	 case 'ot_adm'
//				
//				select count(*) 
//				  into :ll_count
//				  from vw_ope_ot_adm_usr
//				 where (ot_adm  = :data    ) and
//				 		 (cod_usr = :gs_user ) ;
//				
//				if ll_count = 0 then
//					SetNull(ls_codigo)
//					Messagebox('Aviso','OT Administracion No Existe Verifique')
//					This.object.ot_adm      [row] = ls_codigo
//					This.object.descripcion [row] = ls_codigo
//					Return 1	
//				else
//					select descripcion into :ls_descripcion from ot_administracion where ot_adm =:data ;
//					
//					This.object.descripcion [row] = ls_descripcion
//					
//				end if		
//				 		 
//
//end choose
//
end event

event dw_detail::ue_insert_pre;call super::ue_insert_pre;String ls_flag_aprobador

ls_flag_aprobador = dw_master.object.flag_aprobador[dw_master.GetRow()]

// No debe insertar 
IF ls_flag_aprobador <>'A' then
	Messagebox('Aviso', 'Usuario no autorizado')
	dw_detail.reset()
	ib_update_check = False
END IF 

this.object.saldo_aprob_mes[al_Row] = 0
this.object.mes_aprob[al_Row] = 0
this.object.nivel_aprob[al_row] = 1
this.object.flag_saldo_disp[al_row] = '0'

end event

event dw_detail::getfocus;call super::getfocus;String ls_flag_aprobador

ls_flag_aprobador = dw_master.object.flag_aprobador[dw_master.GetRow()]

// No debe insertar 
IF ls_flag_aprobador <>'A' then
	Messagebox('Aviso', 'No puede ingresar parametros a usuarios no autorizados o de comite de compras')
	dw_master.setFocus( )
	return
END IF 

idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

type st_1 from statictext within w_ope021_ot_adm_usuario_aprob
integer width = 3003
integer height = 84
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 8388608
boolean enabled = false
string text = "Administradores de Ordenes de Trabajo"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_2 from statictext within w_ope021_ot_adm_usuario_aprob
integer y = 1304
integer width = 3003
integer height = 84
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 8388608
boolean enabled = false
string text = "Parámetros de aprobación"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

