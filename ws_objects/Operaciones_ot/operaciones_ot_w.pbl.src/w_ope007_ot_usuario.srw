$PBExportHeader$w_ope007_ot_usuario.srw
forward
global type w_ope007_ot_usuario from w_abc_mastdet_smpl
end type
end forward

global type w_ope007_ot_usuario from w_abc_mastdet_smpl
integer width = 2949
integer height = 1860
string title = "Usuarios de OT ADM (OPE007)"
string menuname = "m_master_sin_lista"
end type
global w_ope007_ot_usuario w_ope007_ot_usuario

on w_ope007_ot_usuario.create
call super::create
if this.MenuName = "m_master_sin_lista" then this.MenuID = create m_master_sin_lista
end on

on w_ope007_ot_usuario.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre();call super::ue_open_pre;of_position_window(0,0)       			// Posicionar la ventana en forma fija
ii_pregunta_delete = 1   					// 1 = si pregunta, 0 = no pregunta (default)
//ii_help = 101           					// help topic

end event

event ue_modify;call super::ue_modify;String ls_protect
ls_protect = dw_master.Describe("ot_adm.protect")
If ls_protect = '0' Then
   dw_master.object.ot_adm.protect = 1
End if	

ls_protect = dw_detail.Describe("cod_usr.protect")
If ls_protect = '0' Then
   dw_detail.object.cod_usr.protect = 1
End if	
end event

event ue_update_pre;call super::ue_update_pre;//--VERIFICACION Y ASIGNACION DE ADMINISTRACION
if f_row_Processing( dw_master, "form") <> true then	
	ib_update_check = False	
	return
else
	ib_update_check = True
end if


//--VERIFICACION Y ASIGNACION DE usuario
if f_row_Processing( dw_detail, "form") <> true then	
	ib_update_check = False	
	return
else
	ib_update_check = True
end if

dw_master.of_set_flag_replicacion()
dw_detail.of_set_flag_replicacion()
end event

type dw_master from w_abc_mastdet_smpl`dw_master within w_ope007_ot_usuario
integer x = 0
integer y = 0
integer width = 2871
integer height = 796
string dataobject = "d_abc_ot_administracion_tbl"
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

event dw_master::rowfocuschanged;call super::rowfocuschanged;This.SelectRow(0, FALSE)
This.SelectRow(currentrow, TRUE)
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;// Por defecto, pasa como que se controla la aprobación de requerimientos
this.object.flag_ctrl_aprt_ot		[al_row]='1'
this.object.flag_reserv_aut		[al_row]='1'
this.object.flag_cntrl_ot_plant	[al_row] = '1'

end event

type dw_detail from w_abc_mastdet_smpl`dw_detail within w_ope007_ot_usuario
integer x = 0
integer y = 812
integer width = 2871
integer height = 768
string dataobject = "d_abc_ot_administracion_usuario_tbl"
end type

event dw_detail::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectura de este dw
ii_ck[2] = 2				// columnas de lectura de este dw
ii_rk[1] = 1 		      // columnas que recibimos del master

end event

event dw_detail::doubleclicked;call super::doubleclicked;Accepttext()
String ls_name,ls_prot
Str_seleccionar lStr_seleccionar



ls_name = dwo.name
ls_prot = this.Describe( ls_name + ".Protect")

if ls_prot = '1' then    //protegido 
	return
end if

CHOOSE CASE dwo.name
		 CASE 'cod_usr'

            lstr_seleccionar.s_seleccion = 'S'  
				lstr_seleccionar.s_sql = 'SELECT USUARIO.COD_USR AS CODIGO,'&
												       +'USUARIO.NOMBRE  AS NOMBRES '&
														 +'FROM USUARIO 	  '&	
														 +'WHERE USUARIO.FLAG_ESTADO = '+"'"+'1'+"'"
														 

				OpenWithParm(w_seleccionar,lstr_seleccionar)
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'cod_usr',lstr_seleccionar.param1[1])
					Setitem(row,'nombre',lstr_seleccionar.param2 [1])
					ii_update = 1
				END IF					
				
	
END CHOOSE

end event

event dw_detail::itemchanged;call super::itemchanged;String ls_cod_usr,ls_nombre, ls_null

SetNull(ls_null)
accepttext ()

CHOOSE CASE dwo.name
	CASE 'cod_usr'
		SELECT nombre
		  INTO :ls_nombre
		  FROM usuario
		 WHERE cod_usr = :data   ;
		
		IF SQLCA.SQlCode = 100 THEN
			this.object.nombre [row] = ls_null
			Messagebox('Aviso','Codigo de Usuario No Existe ,Verifique!')
			RETURN 1
		end if
			
		this.object.nombre [row] = ls_nombre

END CHOOSE

end event

event dw_detail::itemerror;call super::itemerror;Return 1
end event

event dw_detail::rowfocuschanged;call super::rowfocuschanged;This.SelectRow(0, FALSE)

This.SelectRow(currentrow, TRUE)
end event

event dw_detail::ue_insert_pre;call super::ue_insert_pre;this.object.flag_aprobador[al_row]='N'
this.object.flag_aprob_serv3ro[al_row]='0'
this.object.flag_conformidad_os[al_row]='0'
end event

